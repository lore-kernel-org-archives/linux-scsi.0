From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 07/14] block: Clean up the code used to generate and verify integrity metadata
Date: Fri, 25 Jul 2014 16:34:22 -0400
Message-ID: <1406320469-29352-8-git-send-email-martin.petersen@oracle.com>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22803 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588AbaGYUdn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:43 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXguK030893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:42 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXfva014566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:41 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXe1U004120
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:40 GMT
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Instead of the "operate" parameter we pass in a seed value and a pointer
to a function that can be used to process the integrity metadata. The
generation function is changed to have a return value to fit into this
scheme.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c  |  82 ++++++++++----------------------------
 drivers/scsi/sd_dif.c  | 106 ++++++++++++++++++++++++++-----------------------
 include/linux/bio.h    |  12 ++++++
 include/linux/blkdev.h |   9 ++---
 4 files changed, 94 insertions(+), 115 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 320ce7df1a5f..c4dd7f6d4f1d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -213,49 +213,37 @@ static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 }
 
 /**
- * bio_integrity_generate_verify - Generate/verify integrity metadata for a bio
+ * bio_integrity_process - Process integrity metadata for a bio
  * @bio:	bio to generate/verify integrity metadata for
- * @operate:	operate number, 1 for generate, 0 for verify
+ * @proc_fn:	Pointer to the relevant processing function
  */
-static int bio_integrity_generate_verify(struct bio *bio, int operate)
+static int bio_integrity_process(struct bio *bio,
+				 integrity_processing_fn *proc_fn)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	struct blk_integrity_exchg bix;
+	struct blk_integrity_iter iter;
 	struct bio_vec *bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	sector_t seed;
-	unsigned int intervals, ret = 0, i;
+	unsigned int i, ret = 0;
 	void *prot_buf = page_address(bip->bip_vec->bv_page) +
 		bip->bip_vec->bv_offset;
 
-	if (operate)
-		seed = bio->bi_iter.bi_sector;
-	else
-		seed = bip->bip_iter.bi_sector;
-
-	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	bix.interval = bi->interval;
+	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
+	iter.interval = bi->interval;
+	iter.seed = bip_get_seed(bip);
+	iter.prot_buf = prot_buf;
 
 	bio_for_each_segment_all(bv, bio, i) {
 		void *kaddr = kmap_atomic(bv->bv_page);
-		bix.data_buf = kaddr + bv->bv_offset;
-		bix.data_size = bv->bv_len;
-		bix.prot_buf = prot_buf;
-		bix.seed = seed;
-
-		if (operate)
-			bi->generate_fn(&bix);
-		else {
-			ret = bi->verify_fn(&bix);
-			if (ret) {
-				kunmap_atomic(kaddr);
-				return ret;
-			}
-		}
 
-		intervals = bv->bv_len / bi->interval;
-		seed += intervals;
-		prot_buf += intervals * bi->tuple_size;
+		iter.data_buf = kaddr + bv->bv_offset;
+		iter.data_size = bv->bv_len;
+
+		ret = proc_fn(&iter);
+		if (ret) {
+			kunmap_atomic(kaddr);
+			return ret;
+		}
 
 		kunmap_atomic(kaddr);
 	}
@@ -263,20 +251,6 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 }
 
 /**
- * bio_integrity_generate - Generate integrity metadata for a bio
- * @bio:	bio to generate integrity metadata for
- *
- * Description: Generates integrity metadata for a bio by calling the
- * block device's generation callback function.  The bio must have a
- * bip attached with enough room to accommodate the generated
- * integrity metadata.
- */
-static void bio_integrity_generate(struct bio *bio)
-{
-	bio_integrity_generate_verify(bio, 1);
-}
-
-/**
  * bio_integrity_prep - Prepare bio for integrity I/O
  * @bio:	bio to prepare
  *
@@ -327,7 +301,7 @@ int bio_integrity_prep(struct bio *bio)
 
 	bip->bip_owns_buf = 1;
 	bip->bip_iter.bi_size = len;
-	bip->bip_iter.bi_sector = bio->bi_iter.bi_sector;
+	bip_set_seed(bip, bio->bi_iter.bi_sector);
 
 	/* Map it */
 	offset = offset_in_page(buf);
@@ -363,26 +337,13 @@ int bio_integrity_prep(struct bio *bio)
 
 	/* Auto-generate integrity metadata if this is a write */
 	if (bio_data_dir(bio) == WRITE)
-		bio_integrity_generate(bio);
+		bio_integrity_process(bio, bi->generate_fn);
 
 	return 0;
 }
 EXPORT_SYMBOL(bio_integrity_prep);
 
 /**
- * bio_integrity_verify - Verify integrity metadata for a bio
- * @bio:	bio to verify
- *
- * Description: This function is called to verify the integrity of a
- * bio.	 The data in the bio io_vec is compared to the integrity
- * metadata returned by the HBA.
- */
-static int bio_integrity_verify(struct bio *bio)
-{
-	return bio_integrity_generate_verify(bio, 0);
-}
-
-/**
  * bio_integrity_verify_fn - Integrity I/O completion worker
  * @work:	Work struct stored in bio to be verified
  *
@@ -395,9 +356,10 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	struct bio_integrity_payload *bip =
 		container_of(work, struct bio_integrity_payload, bip_work);
 	struct bio *bio = bip->bip_bio;
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	int error;
 
-	error = bio_integrity_verify(bio);
+	error = bio_integrity_process(bio, bi->verify_fn);
 
 	/* Restore original bio completion handler */
 	bio->bi_end_io = bip->bip_end_io;
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 1600270a46e5..801c41851a01 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -53,42 +53,44 @@ static __u16 sd_dif_ip_fn(void *data, unsigned int len)
  * Type 1 and Type 2 protection use the same format: 16 bit guard tag,
  * 16 bit app tag, 32 bit reference tag.
  */
-static void sd_dif_type1_generate(struct blk_integrity_exchg *bix, csum_fn *fn)
+static void sd_dif_type1_generate(struct blk_integrity_iter *iter, csum_fn *fn)
 {
-	void *buf = bix->data_buf;
-	struct sd_dif_tuple *sdt = bix->prot_buf;
-	sector_t seed = bix->seed;
+	void *buf = iter->data_buf;
+	struct sd_dif_tuple *sdt = iter->prot_buf;
+	sector_t seed = iter->seed;
 	unsigned int i;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
-		sdt->guard_tag = fn(buf, bix->interval);
+	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
+		sdt->guard_tag = fn(buf, iter->interval);
 		sdt->ref_tag = cpu_to_be32(seed & 0xffffffff);
 		sdt->app_tag = 0;
 
-		buf += bix->interval;
+		buf += iter->interval;
 		seed++;
 	}
 }
 
-static void sd_dif_type1_generate_crc(struct blk_integrity_exchg *bix)
+static int sd_dif_type1_generate_crc(struct blk_integrity_iter *iter)
 {
-	sd_dif_type1_generate(bix, sd_dif_crc_fn);
+	sd_dif_type1_generate(iter, sd_dif_crc_fn);
+	return 0;
 }
 
-static void sd_dif_type1_generate_ip(struct blk_integrity_exchg *bix)
+static int sd_dif_type1_generate_ip(struct blk_integrity_iter *iter)
 {
-	sd_dif_type1_generate(bix, sd_dif_ip_fn);
+	sd_dif_type1_generate(iter, sd_dif_ip_fn);
+	return 0;
 }
 
-static int sd_dif_type1_verify(struct blk_integrity_exchg *bix, csum_fn *fn)
+static int sd_dif_type1_verify(struct blk_integrity_iter *iter, csum_fn *fn)
 {
-	void *buf = bix->data_buf;
-	struct sd_dif_tuple *sdt = bix->prot_buf;
-	sector_t seed = bix->seed;
+	void *buf = iter->data_buf;
+	struct sd_dif_tuple *sdt = iter->prot_buf;
+	sector_t seed = iter->seed;
 	unsigned int i;
 	__u16 csum;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
+	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
 		/* Unwritten sectors */
 		if (sdt->app_tag == 0xffff)
 			return 0;
@@ -96,36 +98,36 @@ static int sd_dif_type1_verify(struct blk_integrity_exchg *bix, csum_fn *fn)
 		if (be32_to_cpu(sdt->ref_tag) != (seed & 0xffffffff)) {
 			printk(KERN_ERR
 			       "%s: ref tag error on sector %lu (rcvd %u)\n",
-			       bix->disk_name, (unsigned long)seed,
+			       iter->disk_name, (unsigned long)seed,
 			       be32_to_cpu(sdt->ref_tag));
 			return -EIO;
 		}
 
-		csum = fn(buf, bix->interval);
+		csum = fn(buf, iter->interval);
 
 		if (sdt->guard_tag != csum) {
 			printk(KERN_ERR "%s: guard tag error on sector %lu " \
-			       "(rcvd %04x, data %04x)\n", bix->disk_name,
+			       "(rcvd %04x, data %04x)\n", iter->disk_name,
 			       (unsigned long)seed,
 			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
 			return -EIO;
 		}
 
-		buf += bix->interval;
+		buf += iter->interval;
 		seed++;
 	}
 
 	return 0;
 }
 
-static int sd_dif_type1_verify_crc(struct blk_integrity_exchg *bix)
+static int sd_dif_type1_verify_crc(struct blk_integrity_iter *iter)
 {
-	return sd_dif_type1_verify(bix, sd_dif_crc_fn);
+	return sd_dif_type1_verify(iter, sd_dif_crc_fn);
 }
 
-static int sd_dif_type1_verify_ip(struct blk_integrity_exchg *bix)
+static int sd_dif_type1_verify_ip(struct blk_integrity_iter *iter)
 {
-	return sd_dif_type1_verify(bix, sd_dif_ip_fn);
+	return sd_dif_type1_verify(iter, sd_dif_ip_fn);
 }
 
 static struct blk_integrity dif_type1_integrity_crc = {
@@ -149,69 +151,71 @@ static struct blk_integrity dif_type1_integrity_ip = {
  * Type 3 protection has a 16-bit guard tag and 16 + 32 bits of opaque
  * tag space.
  */
-static void sd_dif_type3_generate(struct blk_integrity_exchg *bix, csum_fn *fn)
+static void sd_dif_type3_generate(struct blk_integrity_iter *iter, csum_fn *fn)
 {
-	void *buf = bix->data_buf;
-	struct sd_dif_tuple *sdt = bix->prot_buf;
+	void *buf = iter->data_buf;
+	struct sd_dif_tuple *sdt = iter->prot_buf;
 	unsigned int i;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
-		sdt->guard_tag = fn(buf, bix->interval);
+	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
+		sdt->guard_tag = fn(buf, iter->interval);
 		sdt->ref_tag = 0;
 		sdt->app_tag = 0;
 
-		buf += bix->interval;
+		buf += iter->interval;
 	}
 }
 
-static void sd_dif_type3_generate_crc(struct blk_integrity_exchg *bix)
+static int sd_dif_type3_generate_crc(struct blk_integrity_iter *iter)
 {
-	sd_dif_type3_generate(bix, sd_dif_crc_fn);
+	sd_dif_type3_generate(iter, sd_dif_crc_fn);
+	return 0;
 }
 
-static void sd_dif_type3_generate_ip(struct blk_integrity_exchg *bix)
+static int sd_dif_type3_generate_ip(struct blk_integrity_iter *iter)
 {
-	sd_dif_type3_generate(bix, sd_dif_ip_fn);
+	sd_dif_type3_generate(iter, sd_dif_ip_fn);
+	return 0;
 }
 
-static int sd_dif_type3_verify(struct blk_integrity_exchg *bix, csum_fn *fn)
+static int sd_dif_type3_verify(struct blk_integrity_iter *iter, csum_fn *fn)
 {
-	void *buf = bix->data_buf;
-	struct sd_dif_tuple *sdt = bix->prot_buf;
-	sector_t seed = bix->seed;
+	void *buf = iter->data_buf;
+	struct sd_dif_tuple *sdt = iter->prot_buf;
+	sector_t seed = iter->seed;
 	unsigned int i;
 	__u16 csum;
 
-	for (i = 0 ; i < bix->data_size ; i += bix->interval, sdt++) {
+	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
 		/* Unwritten sectors */
 		if (sdt->app_tag == 0xffff && sdt->ref_tag == 0xffffffff)
 			return 0;
 
-		csum = fn(buf, bix->interval);
+		csum = fn(buf, iter->interval);
 
 		if (sdt->guard_tag != csum) {
 			printk(KERN_ERR "%s: guard tag error on sector %lu " \
-			       "(rcvd %04x, data %04x)\n", bix->disk_name,
+			       "(rcvd %04x, data %04x)\n", iter->disk_name,
 			       (unsigned long)seed,
 			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
 			return -EIO;
 		}
 
-		buf += bix->interval;
+		buf += iter->interval;
 		seed++;
 	}
 
 	return 0;
 }
 
-static int sd_dif_type3_verify_crc(struct blk_integrity_exchg *bix)
+static int sd_dif_type3_verify_crc(struct blk_integrity_iter *iter)
 {
-	return sd_dif_type3_verify(bix, sd_dif_crc_fn);
+	return sd_dif_type3_verify(iter, sd_dif_crc_fn);
 }
 
-static int sd_dif_type3_verify_ip(struct blk_integrity_exchg *bix)
+static int sd_dif_type3_verify_ip(struct blk_integrity_iter *iter)
 {
-	return sd_dif_type3_verify(bix, sd_dif_ip_fn);
+	return sd_dif_type3_verify(iter, sd_dif_ip_fn);
 }
 
 static struct blk_integrity dif_type3_integrity_crc = {
@@ -310,6 +314,7 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 	phys = hw_sector & 0xffffffff;
 
 	__rq_for_each_bio(bio, rq) {
+		struct bio_integrity_payload *bip = bio_integrity(bio);
 		struct bio_vec iv;
 		struct bvec_iter iter;
 		unsigned int j;
@@ -318,9 +323,9 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 		if (bio_flagged(bio, BIO_MAPPED_INTEGRITY))
 			break;
 
-		virt = bio_integrity(bio)->bip_iter.bi_sector & 0xffffffff;
+		virt = bip_get_seed(bip) & 0xffffffff;
 
-		bip_for_each_vec(iv, bio_integrity(bio), iter) {
+		bip_for_each_vec(iv, bip, iter) {
 			sdt = kmap_atomic(iv.bv_page)
 				+ iv.bv_offset;
 
@@ -366,12 +371,13 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		phys >>= 3;
 
 	__rq_for_each_bio(bio, scmd->request) {
+		struct bio_integrity_payload *bip = bio_integrity(bio);
 		struct bio_vec iv;
 		struct bvec_iter iter;
 
-		virt = bio_integrity(bio)->bip_iter.bi_sector & 0xffffffff;
+		virt = bip_get_seed(bip) & 0xffffffff;
 
-		bip_for_each_vec(iv, bio_integrity(bio), iter) {
+		bip_for_each_vec(iv, bip, iter) {
 			sdt = kmap_atomic(iv.bv_page)
 				+ iv.bv_offset;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 38bcec55c4c6..b43f8acc845e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -321,6 +321,18 @@ struct bio_integrity_payload {
 	struct bio_vec		*bip_vec;
 	struct bio_vec		bip_inline_vecs[0];/* embedded bvec array */
 };
+
+static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
+{
+	return bip->bip_iter.bi_sector;
+}
+
+static inline void bip_set_seed(struct bio_integrity_payload *bip,
+				sector_t seed)
+{
+	bip->bip_iter.bi_sector = seed;
+}
+
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 extern void bio_trim(struct bio *bio, int offset, int size);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d097f945cf57..2ee4e190900e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1465,7 +1465,7 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 #define INTEGRITY_FLAG_READ	2	/* verify data integrity on read */
 #define INTEGRITY_FLAG_WRITE	4	/* generate data integrity on write */
 
-struct blk_integrity_exchg {
+struct blk_integrity_iter {
 	void			*prot_buf;
 	void			*data_buf;
 	sector_t		seed;
@@ -1474,12 +1474,11 @@ struct blk_integrity_exchg {
 	const char		*disk_name;
 };
 
-typedef void (integrity_gen_fn) (struct blk_integrity_exchg *);
-typedef int (integrity_vrfy_fn) (struct blk_integrity_exchg *);
+typedef int (integrity_processing_fn) (struct blk_integrity_iter *);
 
 struct blk_integrity {
-	integrity_gen_fn	*generate_fn;
-	integrity_vrfy_fn	*verify_fn;
+	integrity_processing_fn	*generate_fn;
+	integrity_processing_fn	*verify_fn;
 
 	unsigned short		flags;
 	unsigned short		tuple_size;
-- 
1.9.3

