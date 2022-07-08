/*
		Inventory Items Table
*/
-- Membuat tabel inventory_items
create table inventory_items(
	id int,
	product_id int,
	created_at date,
	sold_at date,
	cost float,
	product_category varchar(50),
	product_name varchar(225),
	product_brand varchar(225),
	product_retail_price float,
	product_departement varchar(6),
	product_sku varchar(50),
	product_distribution_center_id int
)
-- Import file inventory_items dari csv ke postgresql
copy inventory_items(
	id,
	product_id,
	created_at,
	sold_at,
	cost,
	product_category,
	product_name,
	product_brand,
	product_retail_price,
	product_departement,
	product_sku,
	product_distribution_center_id 
)
from 'D:\College Files\Semester 6\Ruangguru\Final Project\Dataset Final Project DBA\inventory_items.csv'
delimiter ','
csv header
-- Melihat semua data yang ada di tabel inventory_items
select * from inventory_items

/*
		Products Table
*/
-- Membuat tabel products
create table products(
	id int,
	cost float,
	category varchar(100),
	name varchar(225),
	brand varchar(50),
	retail_price float,
	departement varchar(6),
	sku varchar(225),
	distribution_center_id int
)
-- Import tabel products dari file csv ke postgresql
copy products(
	id,
	cost,
	category,
	name,
	brand,
	retail_price,
	departement,
	sku,
	distribution_center_id 
)
from 'D:\College Files\Semester 6\Ruangguru\Final Project\Dataset Final Project DBA\products.csv'
delimiter ','
csv header
-- Melihat semua data yang ada di tabel products
select * from products

/*
		Distribution Centers Table
*/
-- Membuat tabel distribution_centers
create table distribution_centers(
	id int,
	name varchar(100),
	latitude float,
	longitude float
)
-- Import tabel distribution_centers dari file csv ke postgresql
copy distribution_centers(
	id,
	name,
	latitude,
	longitude
)
from 'D:\College Files\Semester 6\Ruangguru\Final Project\Dataset Final Project DBA\distribution_centers.csv'
delimiter ','
csv header
-- Melihat semua data yang ada di tabel products
select * from distribution_centers

/*
		Query Join
*/
-- Join kolom-kolom yang dibutuhkan dari tabel inventory_items, products, dan distribution_centers
select
	ii.product_id,
	ii.product_category,
	ii.product_name,
	ii.product_departement,
	ii.created_at,
	ii.sold_at,
	ii.cost,
	ii.product_retail_price,
	ii.product_distribution_center_id,
	p.brand,
	dc.name,
	dc.latitude,
	dc.longitude
from inventory_items ii
inner join products p
on ii.product_id = p.id
inner join distribution_centers dc
on ii.product_distribution_center_id = dc.id
order by ii.product_id, ii.product_category, ii.product_name
-- Save result query ke csv pakai tombol save di atas dengan nama products_data.csv dan products_data.sql

/*
		Mengambil Data untuk Modeling
*/
-- Membuat tabel products_data_final
create table products_data_final(
	product_id int,
	product_category varchar(50),
	product_name varchar(225),
	product_departement varchar(6),
	created_at date,
	cost float,
	product_retail_price float,
	product_distribution_center_id int,
	brand varchar(50),
	name varchar(100),
	latitude float,
	longitude float
)
-- Import file csv products_data_final ke postgresql
copy products_data_final(
	product_id,
	product_category,
	product_name,
	product_departement,
	created_at,
	cost,
	product_retail_price,
	product_distribution_center_id,
	brand,
	name,
	latitude,
	longitude
)
from 'D:\College Files\Semester 6\Ruangguru\Final Project\products_data_final.csv'
delimiter ','
csv header
-- Melihat tabel products_data_final
select * from products_data_final
-- Mengambil kolom created_at dan product_name, lalu group by created_at untuk menghasilkan data (asumsi) penjualan setiap produk per tanggal 
-- PS: Seharusnya menggunakan kolom sold_at, namun kolom tersebut tidak dapat digunakan akibat terlalu banyak null values di dalamnya
select created_at as per_tanggal,
		count(product_name)as product_sum
from products_data_final
group by created_at
order by created_at
-- Eksport hasil pengambilan data di atas ke dalam csv menggunakan tombol save result di atas dengan nama forecasting_file.csv dan forecasting_file.sql



