From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/2] seperate max_sectors from max_hw_sectors
Date: Mon, 05 Dec 2005 02:37:06 -0600
Message-ID: <1133771827.23619.17.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:3025 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751355AbVLEIh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2005 03:37:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, Linux SCSI list <linux-scsi@vger.kernel.org>

- export __blk_put_request and blk_execute_rq_nowait
needed for async REQ_BLOCK_PC requests
- seperate max_hw_sectors and max_sectors for block/scsi_ioctl.c and
SG_IO bio.c helpers per Jens's last comments. Since block/scsi_ioctl.c SG_IO was
already testing against max_sectors and SCSI-ml was setting max_sectors and
max_hw_sectors to the same value this does not change any scsi SG_IO behavior. It only
prepares ll_rw_blk.c, scsi_ioctl.c and bio.c for when SCSI-ml begins to set
a valid max_hw_sectors for all LLDs. Today if a LLD does not set it
SCSI-ml sets it to a safe default and some LLDs set it to a artificial low
value to overcome memory and feedback issues.

Note: Since we now cap max_sectors to BLK_DEF_MAX_SECTORS, which is 1024,
drivers that used to call blk_queue_max_sectors with a large value of
max_sectors will now see the fs requests capped to BLK_DEF_MAX_SECTORS.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 5f52e30..d57fed9 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -241,7 +241,7 @@ void blk_queue_make_request(request_queu
 	q->backing_dev_info.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
-	blk_queue_max_sectors(q, MAX_SECTORS);
+	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
@@ -557,7 +557,12 @@ void blk_queue_max_sectors(request_queue
 		printk("%s: set to minimum %d\n", __FUNCTION__, max_sectors);
 	}
 
-	q->max_sectors = q->max_hw_sectors = max_sectors;
+	if (BLK_DEF_MAX_SECTORS > max_sectors)
+		q->max_hw_sectors = q->max_sectors = max_sectors;
+ 	else {
+		q->max_sectors = BLK_DEF_MAX_SECTORS;
+		q->max_hw_sectors = max_sectors;
+	}
 }
 
 EXPORT_SYMBOL(blk_queue_max_sectors);
@@ -659,8 +664,8 @@ EXPORT_SYMBOL(blk_queue_hardsect_size);
 void blk_queue_stack_limits(request_queue_t *t, request_queue_t *b)
 {
 	/* zero is "infinity" */
-	t->max_sectors = t->max_hw_sectors =
-		min_not_zero(t->max_sectors,b->max_sectors);
+	t->max_sectors = min_not_zero(t->max_sectors,b->max_sectors);
+	t->max_hw_sectors = min_not_zero(t->max_hw_sectors,b->max_hw_sectors);
 
 	t->max_phys_segments = min(t->max_phys_segments,b->max_phys_segments);
 	t->max_hw_segments = min(t->max_hw_segments,b->max_hw_segments);
@@ -1295,9 +1300,15 @@ static inline int ll_new_hw_segment(requ
 static int ll_back_merge_fn(request_queue_t *q, struct request *req, 
 			    struct bio *bio)
 {
+	unsigned short max_sectors;
 	int len;
 
-	if (req->nr_sectors + bio_sectors(bio) > q->max_sectors) {
+	if (unlikely(blk_pc_request(req)))
+		max_sectors = q->max_hw_sectors;
+	else
+		max_sectors = q->max_sectors;
+
+	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -1327,9 +1338,16 @@ static int ll_back_merge_fn(request_queu
 static int ll_front_merge_fn(request_queue_t *q, struct request *req, 
 			     struct bio *bio)
 {
+	unsigned short max_sectors;
 	int len;
 
-	if (req->nr_sectors + bio_sectors(bio) > q->max_sectors) {
+	if (unlikely(blk_pc_request(req)))
+		max_sectors = q->max_hw_sectors;
+	else
+		max_sectors = q->max_sectors;
+
+
+	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -2146,7 +2164,7 @@ int blk_rq_map_user(request_queue_t *q, 
 	struct bio *bio;
 	int reading;
 
-	if (len > (q->max_sectors << 9))
+	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len || !ubuf)
 		return -EINVAL;
@@ -2261,7 +2279,7 @@ int blk_rq_map_kern(request_queue_t *q, 
 {
 	struct bio *bio;
 
-	if (len > (q->max_sectors << 9))
+	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len || !kbuf)
 		return -EINVAL;
@@ -2308,6 +2326,8 @@ void blk_execute_rq_nowait(request_queue
 	generic_unplug_device(q);
 }
 
+EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2446,7 +2466,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2475,6 +2495,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL_GPL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	unsigned long flags;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 382dea7..4e390df 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -233,7 +233,7 @@ static int sg_io(struct file *file, requ
 	if (verify_command(file, cmd))
 		return -EPERM;
 
-	if (hdr->dxfer_len > (q->max_sectors << 9))
+	if (hdr->dxfer_len > (q->max_hw_sectors << 9))
 		return -EIO;
 
 	if (hdr->dxfer_len)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a6d3baa..a6f2dc6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -638,7 +638,7 @@ int dm_split_args(int *argc, char ***arg
 static void check_for_valid_limits(struct io_restrictions *rs)
 {
 	if (!rs->max_sectors)
-		rs->max_sectors = MAX_SECTORS;
+		rs->max_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_phys_segments)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
 	if (!rs->max_hw_segments)
diff --git a/fs/bio.c b/fs/bio.c
index 460554b..38d3e80 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -313,7 +313,8 @@ int bio_get_nr_vecs(struct block_device 
 }
 
 static int __bio_add_page(request_queue_t *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset)
+			  *page, unsigned int len, unsigned int offset,
+			  unsigned short max_sectors)
 {
 	int retried_segments = 0;
 	struct bio_vec *bvec;
@@ -327,7 +328,7 @@ static int __bio_add_page(request_queue_
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
-	if (((bio->bi_size + len) >> 9) > q->max_sectors)
+	if (((bio->bi_size + len) >> 9) > max_sectors)
 		return 0;
 
 	/*
@@ -386,6 +387,25 @@ static int __bio_add_page(request_queue_
 }
 
 /**
+ *	bio_add_pc_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block
+ *	device limitations. The target block device must allow bio's
+ *	smaller than PAGE_SIZE, so it is always possible to add a single
+ *	page to an empty bio. This should only be used by REQ_PC bios.
+ */
+int bio_add_pc_page(request_queue_t *q, struct bio *bio, struct page *page,
+		    unsigned int len, unsigned int offset)
+{
+	return __bio_add_page(q, bio, page, len, offset, q->max_hw_sectors);
+}
+
+/**
  *	bio_add_page	-	attempt to add page to bio
  *	@bio: destination bio
  *	@page: page to add
@@ -401,8 +421,8 @@ static int __bio_add_page(request_queue_
 int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset)
 {
-	return __bio_add_page(bdev_get_queue(bio->bi_bdev), bio, page,
-			      len, offset);
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
 }
 
 struct bio_map_data {
@@ -514,7 +534,7 @@ struct bio *bio_copy_user(request_queue_
 			break;
 		}
 
-		if (__bio_add_page(q, bio, page, bytes, 0) < bytes) {
+		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes) {
 			ret = -EINVAL;
 			break;
 		}
@@ -628,7 +648,8 @@ static struct bio *__bio_map_user_iov(re
 			/*
 			 * sorry...
 			 */
-			if (__bio_add_page(q, bio, pages[j], bytes, offset) < bytes)
+			if (bio_add_pc_page(q, bio, pages[j], bytes, offset) <
+					    bytes)
 				break;
 
 			len -= bytes;
@@ -801,8 +822,8 @@ static struct bio *__bio_map_kern(reques
 		if (bytes > len)
 			bytes = len;
 
-		if (__bio_add_page(q, bio, virt_to_page(data), bytes,
-				   offset) < bytes)
+		if (bio_add_pc_page(q, bio, virt_to_page(data), bytes,
+				    offset) < bytes)
 			break;
 
 		data += bytes;
@@ -1228,6 +1249,7 @@ EXPORT_SYMBOL(bio_clone);
 EXPORT_SYMBOL(bio_phys_segments);
 EXPORT_SYMBOL(bio_hw_segments);
 EXPORT_SYMBOL(bio_add_page);
+EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_map_user);
 EXPORT_SYMBOL(bio_unmap_user);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 685fd37..b60ffe3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -292,6 +292,8 @@ extern struct bio *bio_clone(struct bio 
 extern void bio_init(struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
+extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
+			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a33a31e..856e76d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -558,6 +558,7 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, gfp_t);
@@ -579,6 +580,10 @@ extern int blk_rq_map_kern(request_queue
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *, struct sg_iovec *, int);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *,
 			  struct request *, int);
+extern void blk_execute_rq_nowait(request_queue_t *, struct gendisk *,
+				  struct request *, int,
+				  void (*done)(struct request *));
+
 static inline request_queue_t *bdev_get_queue(struct block_device *bdev)
 {
 	return bdev->bd_disk->queue;
@@ -696,7 +701,8 @@ extern int blkdev_issue_flush(struct blo
 
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
-#define MAX_SECTORS 255
+#define SAFE_MAX_SECTORS 255
+#define BLK_DEF_MAX_SECTORS 1024
 
 #define MAX_SEGMENT_SIZE	65536
 


