From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 05/14] block: Deprecate the use of the term sector in the context of block integrity
Date: Wed, 28 May 2014 23:28:39 -0400
Message-ID: <1401334128-15499-6-git-send-email-martin.petersen@oracle.com>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26882 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbaE2D3I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:08 -0400
In-Reply-To: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

The protection interval is not necessarily tied to the logical block
size of a block device. Stop using the terms sector and sectors.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/bio-integrity.c  | 46 +++++++++++++++++++++-------------------------
 block/blk-integrity.c  | 10 +++++-----
 drivers/scsi/sd_dif.c  | 46 +++++++++++++++++++++++-----------------------
 include/linux/blkdev.h |  6 +++---
 4 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index e06b3c807eef..c52a8fd98706 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -191,29 +191,25 @@ bool bio_integrity_enabled(struct bio *bio)
 EXPORT_SYMBOL(bio_integrity_enabled);
 
 /**
- * bio_integrity_hw_sectors - Convert 512b sectors to hardware ditto
+ * bio_integrity_intervals - Return number of integrity intervals for a bio
  * @bi:		blk_integrity profile for device
- * @sectors:	Number of 512 sectors to convert
+ * @sectors:	Size of the bio in 512-byte sectors
  *
  * Description: The block layer calculates everything in 512 byte
- * sectors but integrity metadata is done in terms of the hardware
- * sector size of the storage device.  Convert the block layer sectors
- * to physical sectors.
+ * sectors but integrity metadata is done in terms of the data integrity
+ * interval size of the storage device.  Convert the block layer sectors
+ * to the appropriate number of integrity intervals.
  */
-static inline unsigned int bio_integrity_hw_sectors(struct blk_integrity *bi,
-						    unsigned int sectors)
+static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
+						   unsigned int sectors)
 {
-	/* At this point there are only 512b or 4096b DIF/EPP devices */
-	if (bi->sector_size == 4096)
-		return sectors >>= 3;
-
-	return sectors;
+	return sectors >> (ilog2(bi->interval) - 9);
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 					       unsigned int sectors)
 {
-	return bio_integrity_hw_sectors(bi, sectors) * bi->tuple_size;
+	return bio_integrity_intervals(bi, sectors) * bi->tuple_size;
 }
 
 /**
@@ -227,25 +223,25 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 	struct blk_integrity_exchg bix;
 	struct bio_vec *bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	sector_t sector;
-	unsigned int sectors, ret = 0, i;
+	sector_t seed;
+	unsigned int intervals, ret = 0, i;
 	void *prot_buf = page_address(bip->bip_vec->bv_page) +
 		bip->bip_vec->bv_offset;
 
 	if (operate)
-		sector = bio->bi_iter.bi_sector;
+		seed = bio->bi_iter.bi_sector;
 	else
-		sector = bip->bip_iter.bi_sector;
+		seed = bip->bip_iter.bi_sector;
 
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	bix.sector_size = bi->sector_size;
+	bix.interval = bi->interval;
 
 	bio_for_each_segment_all(bv, bio, i) {
 		void *kaddr = kmap_atomic(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
-		bix.sector = sector;
+		bix.seed = seed;
 
 		if (operate)
 			bi->generate_fn(&bix);
@@ -257,9 +253,9 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 			}
 		}
 
-		sectors = bv->bv_len / bi->sector_size;
-		sector += sectors;
-		prot_buf += sectors * bi->tuple_size;
+		intervals = bv->bv_len / bi->interval;
+		seed += intervals;
+		prot_buf += intervals * bi->tuple_size;
 
 		kunmap_atomic(kaddr);
 	}
@@ -300,17 +296,17 @@ int bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
-	unsigned int sectors;
+	unsigned int intervals;
 
 	bi = bdev_get_integrity(bio->bi_bdev);
 	q = bdev_get_queue(bio->bi_bdev);
 	BUG_ON(bi == NULL);
 	BUG_ON(bio_integrity(bio));
 
-	sectors = bio_integrity_hw_sectors(bi, bio_sectors(bio));
+	intervals = bio_integrity_intervals(bi, bio_sectors(bio));
 
 	/* Allocate kernel buffer for protection data */
-	len = sectors * bi->tuple_size;
+	len = intervals * bi->tuple_size;
 	buf = kmalloc(len, GFP_NOIO | q->bounce_gfp);
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 7ac17160ab69..3760d0aeed92 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -154,10 +154,10 @@ int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 	if (!b1 || !b2)
 		return -1;
 
-	if (b1->sector_size != b2->sector_size) {
-		printk(KERN_ERR "%s: %s/%s sector sz %u != %u\n", __func__,
-		       gd1->disk_name, gd2->disk_name,
-		       b1->sector_size, b2->sector_size);
+	if (b1->interval != b2->interval) {
+		printk(KERN_ERR "%s: %s/%s protection interval %u != %u\n",
+		       __func__, gd1->disk_name, gd2->disk_name,
+		       b1->interval, b2->interval);
 		return -1;
 	}
 
@@ -407,7 +407,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		kobject_uevent(&bi->kobj, KOBJ_ADD);
 
 		bi->flags |= INTEGRITY_FLAG_READ | INTEGRITY_FLAG_WRITE;
-		bi->sector_size = queue_logical_block_size(disk->queue);
+		bi->interval = queue_logical_block_size(disk->queue);
 		disk->integrity = bi;
 	} else
 		bi = disk->integrity;
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 38a7778631be..1600270a46e5 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -57,16 +57,16 @@ static void sd_dif_type1_generate(struct blk_integrity_exchg *bix, csum_fn *fn)
 {
 	void *buf = bix->data_buf;
 	struct sd_dif_tuple *sdt = bix->prot_buf;
-	sector_t sector = bix->sector;
+	sector_t seed = bix->seed;
 	unsigned int i;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
-		sdt->guard_tag = fn(buf, bix->sector_size);
-		sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
+	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
+		sdt->guard_tag = fn(buf, bix->interval);
+		sdt->ref_tag = cpu_to_be32(seed & 0xffffffff);
 		sdt->app_tag = 0;
 
-		buf += bix->sector_size;
-		sector++;
+		buf += bix->interval;
+		seed++;
 	}
 }
 
@@ -84,35 +84,35 @@ static int sd_dif_type1_verify(struct blk_integrity_exchg *bix, csum_fn *fn)
 {
 	void *buf = bix->data_buf;
 	struct sd_dif_tuple *sdt = bix->prot_buf;
-	sector_t sector = bix->sector;
+	sector_t seed = bix->seed;
 	unsigned int i;
 	__u16 csum;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
+	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
 		/* Unwritten sectors */
 		if (sdt->app_tag == 0xffff)
 			return 0;
 
-		if (be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
+		if (be32_to_cpu(sdt->ref_tag) != (seed & 0xffffffff)) {
 			printk(KERN_ERR
 			       "%s: ref tag error on sector %lu (rcvd %u)\n",
-			       bix->disk_name, (unsigned long)sector,
+			       bix->disk_name, (unsigned long)seed,
 			       be32_to_cpu(sdt->ref_tag));
 			return -EIO;
 		}
 
-		csum = fn(buf, bix->sector_size);
+		csum = fn(buf, bix->interval);
 
 		if (sdt->guard_tag != csum) {
 			printk(KERN_ERR "%s: guard tag error on sector %lu " \
 			       "(rcvd %04x, data %04x)\n", bix->disk_name,
-			       (unsigned long)sector,
+			       (unsigned long)seed,
 			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
 			return -EIO;
 		}
 
-		buf += bix->sector_size;
-		sector++;
+		buf += bix->interval;
+		seed++;
 	}
 
 	return 0;
@@ -155,12 +155,12 @@ static void sd_dif_type3_generate(struct blk_integrity_exchg *bix, csum_fn *fn)
 	struct sd_dif_tuple *sdt = bix->prot_buf;
 	unsigned int i;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
-		sdt->guard_tag = fn(buf, bix->sector_size);
+	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
+		sdt->guard_tag = fn(buf, bix->interval);
 		sdt->ref_tag = 0;
 		sdt->app_tag = 0;
 
-		buf += bix->sector_size;
+		buf += bix->interval;
 	}
 }
 
@@ -178,27 +178,27 @@ static int sd_dif_type3_verify(struct blk_integrity_exchg *bix, csum_fn *fn)
 {
 	void *buf = bix->data_buf;
 	struct sd_dif_tuple *sdt = bix->prot_buf;
-	sector_t sector = bix->sector;
+	sector_t seed = bix->seed;
 	unsigned int i;
 	__u16 csum;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
+	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
 		/* Unwritten sectors */
 		if (sdt->app_tag == 0xffff && sdt->ref_tag == 0xffffffff)
 			return 0;
 
-		csum = fn(buf, bix->sector_size);
+		csum = fn(buf, bix->interval);
 
 		if (sdt->guard_tag != csum) {
 			printk(KERN_ERR "%s: guard tag error on sector %lu " \
 			       "(rcvd %04x, data %04x)\n", bix->disk_name,
-			       (unsigned long)sector,
+			       (unsigned long)seed,
 			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
 			return -EIO;
 		}
 
-		buf += bix->sector_size;
-		sector++;
+		buf += bix->interval;
+		seed++;
 	}
 
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ce42891dc386..b4fa1de92d29 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1434,9 +1434,9 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 struct blk_integrity_exchg {
 	void			*prot_buf;
 	void			*data_buf;
-	sector_t		sector;
+	sector_t		seed;
 	unsigned int		data_size;
-	unsigned short		sector_size;
+	unsigned short		interval;
 	const char		*disk_name;
 };
 
@@ -1449,7 +1449,7 @@ struct blk_integrity {
 
 	unsigned short		flags;
 	unsigned short		tuple_size;
-	unsigned short		sector_size;
+	unsigned short		interval;
 	unsigned short		tag_size;
 
 	const char		*name;
-- 
1.9.0

