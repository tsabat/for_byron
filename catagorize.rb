#!/usr/bin/env ruby

require 'csv'
#require 'byebug'
#require 'awesome_print'

class Categorize

  # set constants
  PRODUCT_CODE = 0
  PRODUCT_NAME = 1
  PRODUCT_TAGS = 2
  PRODUCT_CATS = 3

  CAT_CODE = 0
  CAT_NAME = 1
  CAT_TAGS = 2

  attr_accessor :categories, :products
  attr_accessor :categoriezed
  attr_accessor :i_categories


  def call
    puts "setting up"
    init_values
    puts "indexing"
    index_categories
    puts "combining"
    loop_products
    puts "writing #{products.count} products to 'output.csv'"
    write_products
  end

  private

  def write_products
    rslt = ""
    categoriezed.each do |p|
      rslt += %Q("#{p[0]}", "#{p[1]}", "#{p[2]}", "#{p[3]}"\n)
    end
    rslt
    IO.write('output.csv', rslt)
  end

  def loop_products
    @categoriezed = products.map do |product|
      tags = product[PRODUCT_TAGS].split(',')
      tags = tags.map(&:strip)
      codes = tags.map do |tag|
        i_categories[tag]
      end.compact
      product[PRODUCT_CATS] = codes.join(',')
      product
    end
  end

  def init_values
    # read in files
    @categories = CSV.read("UAB_Categories.csv")
    @products   = CSV.read("UAB_Products.csv")

    # drop headers
    categories.shift
    products.shift
  end

  def index_categories
    @i_categories = {}
    categories.each do |cat|
      tags = cat[CAT_TAGS].split(",")
      tags = tags.map(&:strip)
      tags.each do |tag|
        code = cat[CAT_CODE]
        i_categories[tag] = code
      end
    end
  end
end

Categorize.new.call
