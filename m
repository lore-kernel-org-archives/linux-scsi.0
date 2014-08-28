From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 03/14] block: Remove integrity tagging functions
Date: Thu, 28 Aug 2014 15:31:21 -0400
Message-ID: <1409254292-2540-4-git-send-email-martin.petersen@oracle.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22772 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaH1Tad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 15:30:33 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com, "Martin K. Petersen" <martin.petersen@oracle.com>

None of the filesystems appear interested in using the integrity tagging
feature. Potentially because very few storage devices actually permit
using the application tag space.

Remove the tagging functions.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 Documentation/block/data-integrity.txt | 34 ------------
 block/bio-integrity.c                  | 94 +---------------------------------
 block/blk-integrity.c                  |  2 -
 drivers/scsi/sd_dif.c                  | 65 -----------------------
 include/linux/bio.h                    |  3 --
 include/linux/blkdev.h                 |  4 --
 6 files changed, 1 insertion(+), 201 deletions(-)

diff --git a/Documentation/block/data-integrity.txt b/Documentation/block/data-integrity.txt
index 4d4de8b09530..f56ec97f0d14 100644
--- a/Documentation/block/data-integrity.txt
+++ b/Documentation/block/data-integrity.txt
@@ -206,36 +206,6 @@ will require extra work due to the application tag.
       bio_integrity_enabled() returned 1.
 
 
-    int bio_integrity_tag_size(bio);
-
-      If the filesystem wants to use the application tag space it will
-      first have to find out how much storage space is available.
-      Because tag space is generally limited (usually 2 bytes per
-      sector regardless of sector size), the integrity framework
-      supports interleaving the information between the sectors in an
-      I/O.
-
-      Filesystems can call bio_integrity_tag_size(bio) to find out how
-      many bytes of storage are available for that particular bio.
-
-      Another option is bdev_get_tag_size(block_device) which will
-      return the number of available bytes per hardware sector.
-
-
-    int bio_integrity_set_tag(bio, void *tag_buf, len);
-
-      After a successful return from bio_integrity_prep(),
-      bio_integrity_set_tag() can be used to attach an opaque tag
-      buffer to a bio.  Obviously this only makes sense if the I/O is
-      a WRITE.
-
-
-    int bio_integrity_get_tag(bio, void *tag_buf, len);
-
-      Similarly, at READ I/O completion time the filesystem can
-      retrieve the tag buffer using bio_integrity_get_tag().
-
-
 5.3 PASSING EXISTING INTEGRITY METADATA
 
     Filesystems that either generate their own integrity metadata or
@@ -288,8 +258,6 @@ will require extra work due to the application tag.
             .name                   = "STANDARDSBODY-TYPE-VARIANT-CSUM",
             .generate_fn            = my_generate_fn,
        	    .verify_fn              = my_verify_fn,
-       	    .get_tag_fn             = my_get_tag_fn,
-       	    .set_tag_fn             = my_set_tag_fn,
 	    .tuple_size             = sizeof(struct my_tuple_size),
 	    .tag_size               = <tag bytes per hw sector>,
         };
@@ -311,7 +279,5 @@ will require extra work due to the application tag.
       are available per hardware sector.  For DIF this is either 2 or
       0 depending on the value of the Control Mode Page ATO bit.
 
-      See 6.2 for a description of get_tag_fn and set_tag_fn.
-
 ----------------------------------------------------------------------
 2007-12-24 Martin K. Petersen <martin.petersen@oracle.com>
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 148a63e1e323..9be2431475e5 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -210,90 +210,6 @@ static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 }
 
 /**
- * bio_integrity_tag_size - Retrieve integrity tag space
- * @bio:	bio to inspect
- *
- * Description: Returns the maximum number of tag bytes that can be
- * attached to this bio. Filesystems can use this to determine how
- * much metadata to attach to an I/O.
- */
-unsigned int bio_integrity_tag_size(struct bio *bio)
-{
-	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-
-	BUG_ON(bio->bi_iter.bi_size == 0);
-
-	return bi->tag_size * (bio->bi_iter.bi_size / bi->sector_size);
-}
-EXPORT_SYMBOL(bio_integrity_tag_size);
-
-static int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len,
-			     int set)
-{
-	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	unsigned int nr_sectors;
-
-	BUG_ON(bip->bip_buf == NULL);
-
-	if (bi->tag_size == 0)
-		return -1;
-
-	nr_sectors = bio_integrity_hw_sectors(bi,
-					DIV_ROUND_UP(len, bi->tag_size));
-
-	if (nr_sectors * bi->tuple_size > bip->bip_iter.bi_size) {
-		printk(KERN_ERR "%s: tag too big for bio: %u > %u\n", __func__,
-		       nr_sectors * bi->tuple_size, bip->bip_iter.bi_size);
-		return -1;
-	}
-
-	if (set)
-		bi->set_tag_fn(bip->bip_buf, tag_buf, nr_sectors);
-	else
-		bi->get_tag_fn(bip->bip_buf, tag_buf, nr_sectors);
-
-	return 0;
-}
-
-/**
- * bio_integrity_set_tag - Attach a tag buffer to a bio
- * @bio:	bio to attach buffer to
- * @tag_buf:	Pointer to a buffer containing tag data
- * @len:	Length of the included buffer
- *
- * Description: Use this function to tag a bio by leveraging the extra
- * space provided by devices formatted with integrity protection.  The
- * size of the integrity buffer must be <= to the size reported by
- * bio_integrity_tag_size().
- */
-int bio_integrity_set_tag(struct bio *bio, void *tag_buf, unsigned int len)
-{
-	BUG_ON(bio_data_dir(bio) != WRITE);
-
-	return bio_integrity_tag(bio, tag_buf, len, 1);
-}
-EXPORT_SYMBOL(bio_integrity_set_tag);
-
-/**
- * bio_integrity_get_tag - Retrieve a tag buffer from a bio
- * @bio:	bio to retrieve buffer from
- * @tag_buf:	Pointer to a buffer for the tag data
- * @len:	Length of the target buffer
- *
- * Description: Use this function to retrieve the tag buffer from a
- * completed I/O. The size of the integrity buffer must be <= to the
- * size reported by bio_integrity_tag_size().
- */
-int bio_integrity_get_tag(struct bio *bio, void *tag_buf, unsigned int len)
-{
-	BUG_ON(bio_data_dir(bio) != READ);
-
-	return bio_integrity_tag(bio, tag_buf, len, 0);
-}
-EXPORT_SYMBOL(bio_integrity_get_tag);
-
-/**
  * bio_integrity_generate_verify - Generate/verify integrity metadata for a bio
  * @bio:	bio to generate/verify integrity metadata for
  * @operate:	operate number, 1 for generate, 0 for verify
@@ -355,14 +271,6 @@ static void bio_integrity_generate(struct bio *bio)
 	bio_integrity_generate_verify(bio, 1);
 }
 
-static inline unsigned short blk_integrity_tuple_size(struct blk_integrity *bi)
-{
-	if (bi)
-		return bi->tuple_size;
-
-	return 0;
-}
-
 /**
  * bio_integrity_prep - Prepare bio for integrity I/O
  * @bio:	bio to prepare
@@ -393,7 +301,7 @@ int bio_integrity_prep(struct bio *bio)
 	sectors = bio_integrity_hw_sectors(bi, bio_sectors(bio));
 
 	/* Allocate kernel buffer for protection data */
-	len = sectors * blk_integrity_tuple_size(bi);
+	len = sectors * bi->tuple_size;
 	buf = kmalloc(len, GFP_NOIO | q->bounce_gfp);
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 7fbab84399e6..7ac17160ab69 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -418,8 +418,6 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		bi->generate_fn = template->generate_fn;
 		bi->verify_fn = template->verify_fn;
 		bi->tuple_size = template->tuple_size;
-		bi->set_tag_fn = template->set_tag_fn;
-		bi->get_tag_fn = template->get_tag_fn;
 		bi->tag_size = template->tag_size;
 	} else
 		bi->name = bi_unsupported_name;
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 29f0477a8708..38a7778631be 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -128,39 +128,10 @@ static int sd_dif_type1_verify_ip(struct blk_integrity_exchg *bix)
 	return sd_dif_type1_verify(bix, sd_dif_ip_fn);
 }
 
-/*
- * Functions for interleaving and deinterleaving application tags
- */
-static void sd_dif_type1_set_tag(void *prot, void *tag_buf, unsigned int sectors)
-{
-	struct sd_dif_tuple *sdt = prot;
-	u8 *tag = tag_buf;
-	unsigned int i, j;
-
-	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
-		sdt->app_tag = tag[j] << 8 | tag[j+1];
-		BUG_ON(sdt->app_tag == 0xffff);
-	}
-}
-
-static void sd_dif_type1_get_tag(void *prot, void *tag_buf, unsigned int sectors)
-{
-	struct sd_dif_tuple *sdt = prot;
-	u8 *tag = tag_buf;
-	unsigned int i, j;
-
-	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
-		tag[j] = (sdt->app_tag & 0xff00) >> 8;
-		tag[j+1] = sdt->app_tag & 0xff;
-	}
-}
-
 static struct blk_integrity dif_type1_integrity_crc = {
 	.name			= "T10-DIF-TYPE1-CRC",
 	.generate_fn		= sd_dif_type1_generate_crc,
 	.verify_fn		= sd_dif_type1_verify_crc,
-	.get_tag_fn		= sd_dif_type1_get_tag,
-	.set_tag_fn		= sd_dif_type1_set_tag,
 	.tuple_size		= sizeof(struct sd_dif_tuple),
 	.tag_size		= 0,
 };
@@ -169,8 +140,6 @@ static struct blk_integrity dif_type1_integrity_ip = {
 	.name			= "T10-DIF-TYPE1-IP",
 	.generate_fn		= sd_dif_type1_generate_ip,
 	.verify_fn		= sd_dif_type1_verify_ip,
-	.get_tag_fn		= sd_dif_type1_get_tag,
-	.set_tag_fn		= sd_dif_type1_set_tag,
 	.tuple_size		= sizeof(struct sd_dif_tuple),
 	.tag_size		= 0,
 };
@@ -245,42 +214,10 @@ static int sd_dif_type3_verify_ip(struct blk_integrity_exchg *bix)
 	return sd_dif_type3_verify(bix, sd_dif_ip_fn);
 }
 
-static void sd_dif_type3_set_tag(void *prot, void *tag_buf, unsigned int sectors)
-{
-	struct sd_dif_tuple *sdt = prot;
-	u8 *tag = tag_buf;
-	unsigned int i, j;
-
-	for (i = 0, j = 0 ; i < sectors ; i++, j += 6, sdt++) {
-		sdt->app_tag = tag[j] << 8 | tag[j+1];
-		sdt->ref_tag = tag[j+2] << 24 | tag[j+3] << 16 |
-			tag[j+4] << 8 | tag[j+5];
-	}
-}
-
-static void sd_dif_type3_get_tag(void *prot, void *tag_buf, unsigned int sectors)
-{
-	struct sd_dif_tuple *sdt = prot;
-	u8 *tag = tag_buf;
-	unsigned int i, j;
-
-	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
-		tag[j] = (sdt->app_tag & 0xff00) >> 8;
-		tag[j+1] = sdt->app_tag & 0xff;
-		tag[j+2] = (sdt->ref_tag & 0xff000000) >> 24;
-		tag[j+3] = (sdt->ref_tag & 0xff0000) >> 16;
-		tag[j+4] = (sdt->ref_tag & 0xff00) >> 8;
-		tag[j+5] = sdt->ref_tag & 0xff;
-		BUG_ON(sdt->app_tag == 0xffff || sdt->ref_tag == 0xffffffff);
-	}
-}
-
 static struct blk_integrity dif_type3_integrity_crc = {
 	.name			= "T10-DIF-TYPE3-CRC",
 	.generate_fn		= sd_dif_type3_generate_crc,
 	.verify_fn		= sd_dif_type3_verify_crc,
-	.get_tag_fn		= sd_dif_type3_get_tag,
-	.set_tag_fn		= sd_dif_type3_set_tag,
 	.tuple_size		= sizeof(struct sd_dif_tuple),
 	.tag_size		= 0,
 };
@@ -289,8 +226,6 @@ static struct blk_integrity dif_type3_integrity_ip = {
 	.name			= "T10-DIF-TYPE3-IP",
 	.generate_fn		= sd_dif_type3_generate_ip,
 	.verify_fn		= sd_dif_type3_verify_ip,
-	.get_tag_fn		= sd_dif_type3_get_tag,
-	.set_tag_fn		= sd_dif_type3_set_tag,
 	.tuple_size		= sizeof(struct sd_dif_tuple),
 	.tag_size		= 0,
 };
diff --git a/include/linux/bio.h b/include/linux/bio.h
index a810a74071b2..63a0e53e238c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -362,7 +362,6 @@ extern struct bio *bio_clone_fast(struct bio *, gfp_t, struct bio_set *);
 extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 
 extern struct bio_set *fs_bio_set;
-unsigned int bio_integrity_tag_size(struct bio *bio);
 
 static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
@@ -674,8 +673,6 @@ extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, un
 extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_enabled(struct bio *bio);
-extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
-extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_prep(struct bio *);
 extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f8e52ec150e5..9e814ab51dfc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1478,14 +1478,10 @@ struct blk_integrity_exchg {
 
 typedef void (integrity_gen_fn) (struct blk_integrity_exchg *);
 typedef int (integrity_vrfy_fn) (struct blk_integrity_exchg *);
-typedef void (integrity_set_tag_fn) (void *, void *, unsigned int);
-typedef void (integrity_get_tag_fn) (void *, void *, unsigned int);
 
 struct blk_integrity {
 	integrity_gen_fn	*generate_fn;
 	integrity_vrfy_fn	*verify_fn;
-	integrity_set_tag_fn	*set_tag_fn;
-	integrity_get_tag_fn	*get_tag_fn;
 
 	unsigned short		flags;
 	unsigned short		tuple_size;
-- 
1.9.3

