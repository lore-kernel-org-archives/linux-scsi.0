From: Christoph Hellwig <hch@infradead.org>
Subject: Re: status of block-integrity
Date: Mon, 23 Dec 2013 05:48:13 -0800
Message-ID: <20131223134813.GA4737@infradead.org>
References: <20131222192128.GA28532@infradead.org>
 <yq11u134rmt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq11u134rmt.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 23, 2013 at 08:35:22AM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> Christoph> We have the block integrity code to support DIF/DIX in the
> Christoph> the tree for about 5 and a half years, and we still don't
> Christoph> have a single consumer of it.  
> 
> What do you mean? If you have a DIX-capable HBA (lpfc, qla2xxx, zfcp)
> then integrity protection is active from the block layer down. The only
> code that's not currently being exercised are the tag interleaving
> functions.  I was hoping the FS people would use them for back pointers
> but nobody seemed to bite.

With single consumer of it I obviously meant the various symbols for the
consumer side as well as the application tag support.

Patch to remove the dead code below:

---
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] block: remove dead on arrival integrity code

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 03cf717..0b14db7 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -194,7 +194,6 @@ int blk_integrity_merge_rq(struct request_queue *q, struct request *req,
 
 	return 0;
 }
-EXPORT_SYMBOL(blk_integrity_merge_rq);
 
 int blk_integrity_merge_bio(struct request_queue *q, struct request *req,
 			    struct bio *bio)
@@ -214,7 +213,6 @@ int blk_integrity_merge_bio(struct request_queue *q, struct request *req,
 
 	return 0;
 }
-EXPORT_SYMBOL(blk_integrity_merge_bio);
 
 struct integrity_sysfs_entry {
 	struct attribute attr;
@@ -414,8 +412,6 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		bi->generate_fn = template->generate_fn;
 		bi->verify_fn = template->verify_fn;
 		bi->tuple_size = template->tuple_size;
-		bi->set_tag_fn = template->set_tag_fn;
-		bi->get_tag_fn = template->get_tag_fn;
 		bi->tag_size = template->tag_size;
 	} else
 		bi->name = bi_unsupported_name;
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 6174ca4..e32035a 100644
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
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index fc60b31..793eaa4 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -32,6 +32,8 @@
 static struct kmem_cache *bip_slab;
 static struct workqueue_struct *kintegrityd_wq;
 
+static void bio_integrity_endio(struct bio *bio, int error);
+
 /**
  * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
@@ -42,7 +44,7 @@ static struct workqueue_struct *kintegrityd_wq;
  * metadata.  nr_vecs specifies the maximum number of pages containing
  * integrity metadata that can be attached.
  */
-struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
+static struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 						  gfp_t gfp_mask,
 						  unsigned int nr_vecs)
 {
@@ -83,7 +85,6 @@ err:
 	mempool_free(bip, bs->bio_integrity_pool);
 	return NULL;
 }
-EXPORT_SYMBOL(bio_integrity_alloc);
 
 /**
  * bio_integrity_free - Free bio integrity payload
@@ -112,7 +113,6 @@ void bio_integrity_free(struct bio *bio)
 
 	bio->bi_integrity = NULL;
 }
-EXPORT_SYMBOL(bio_integrity_free);
 
 /**
  * bio_integrity_add_page - Attach integrity metadata
@@ -123,7 +123,7 @@ EXPORT_SYMBOL(bio_integrity_free);
  *
  * Description: Attach a page containing integrity metadata to bio.
  */
-int bio_integrity_add_page(struct bio *bio, struct page *page,
+static int bio_integrity_add_page(struct bio *bio, struct page *page,
 			   unsigned int len, unsigned int offset)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
@@ -144,7 +144,6 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 
 	return len;
 }
-EXPORT_SYMBOL(bio_integrity_add_page);
 
 static int bdev_integrity_enabled(struct block_device *bdev, int rw)
 {
@@ -181,7 +180,6 @@ int bio_integrity_enabled(struct bio *bio)
 
 	return bdev_integrity_enabled(bio->bi_bdev, bio_data_dir(bio));
 }
-EXPORT_SYMBOL(bio_integrity_enabled);
 
 /**
  * bio_integrity_hw_sectors - Convert 512b sectors to hardware ditto
@@ -204,89 +202,6 @@ static inline unsigned int bio_integrity_hw_sectors(struct blk_integrity *bi,
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
-	BUG_ON(bio->bi_size == 0);
-
-	return bi->tag_size * (bio->bi_size / bi->sector_size);
-}
-EXPORT_SYMBOL(bio_integrity_tag_size);
-
-int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len, int set)
-{
-	struct bio_integrity_payload *bip = bio->bi_integrity;
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
-	if (nr_sectors * bi->tuple_size > bip->bip_size) {
-		printk(KERN_ERR "%s: tag too big for bio: %u > %u\n",
-		       __func__, nr_sectors * bi->tuple_size, bip->bip_size);
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
  * bio_integrity_generate - Generate integrity metadata for a bio
  * @bio:	bio to generate integrity metadata for
  *
@@ -427,7 +342,6 @@ int bio_integrity_prep(struct bio *bio)
 
 	return 0;
 }
-EXPORT_SYMBOL(bio_integrity_prep);
 
 /**
  * bio_integrity_verify - Verify integrity metadata for a bio
@@ -510,7 +424,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
  * in process context.	This function postpones completion
  * accordingly.
  */
-void bio_integrity_endio(struct bio *bio, int error)
+static void bio_integrity_endio(struct bio *bio, int error)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 
@@ -530,14 +444,13 @@ void bio_integrity_endio(struct bio *bio, int error)
 	INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
 	queue_work(kintegrityd_wq, &bip->bip_work);
 }
-EXPORT_SYMBOL(bio_integrity_endio);
 
 /**
  * bio_integrity_mark_head - Advance bip_vec skip bytes
  * @bip:	Integrity vector to advance
  * @skip:	Number of bytes to advance it
  */
-void bio_integrity_mark_head(struct bio_integrity_payload *bip,
+static void bio_integrity_mark_head(struct bio_integrity_payload *bip,
 			     unsigned int skip)
 {
 	struct bio_vec *iv;
@@ -563,7 +476,7 @@ void bio_integrity_mark_head(struct bio_integrity_payload *bip,
  * @bip:	Integrity vector to truncate
  * @len:	New length of integrity vector
  */
-void bio_integrity_mark_tail(struct bio_integrity_payload *bip,
+static void bio_integrity_mark_tail(struct bio_integrity_payload *bip,
 			     unsigned int len)
 {
 	struct bio_vec *iv;
@@ -603,7 +516,6 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	nr_sectors = bio_integrity_hw_sectors(bi, bytes_done >> 9);
 	bio_integrity_mark_head(bip, nr_sectors * bi->tuple_size);
 }
-EXPORT_SYMBOL(bio_integrity_advance);
 
 /**
  * bio_integrity_trim - Trim integrity vector
@@ -676,7 +588,6 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
 	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
 }
-EXPORT_SYMBOL(bio_integrity_split);
 
 /**
  * bio_integrity_clone - Callback for cloning bios with integrity metadata
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 060ff69..4ff2d82 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -576,14 +576,9 @@ struct biovec_slab {
 
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
-extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern void bio_integrity_free(struct bio *);
-extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern int bio_integrity_enabled(struct bio *bio);
-extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
-extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_prep(struct bio *);
-extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b135d4..d6db54e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1430,14 +1430,10 @@ struct blk_integrity_exchg {
 
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
