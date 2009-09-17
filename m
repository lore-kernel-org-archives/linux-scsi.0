From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] block: use normal I/O path for discard requests
Date: Thu, 17 Sep 2009 12:25:37 -0400
Message-ID: <20090917163105.333243158@bombadil.infradead.org>
References: <20090917162536.815743395@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZIQQbC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 12:31:02 -0400
Content-Disposition: inline; filename=discard-remove-prepare-discard
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, matthew@wil.cx, dwmw2@infradead.org
Cc: linux-scsi@vger.kernel.org

prepare_discard_fn() was being called in a place where memory allocation
was effectively impossible.  This makes it inappropriate for all but
the most trivial translations of Linux's DISCARD operation to the block
command set.  Additionally adding a payload there makes the ownership
of the bio backing unclear as it's now allocated by the device driver
and not the submitter as usual.

It is replaced with QUEUE_FLAG_DISCARD which is used to indicate whether
the queue supports discard operations or not.  blkdev_issue_discard now
allocates a one-page, sector-length payload which is the right thing
for the common ATA and SCSI implementations.

The mtd implementation of prepare_discard_fn() is replaced with simply
checking for the request being a discard.

Largely based on a previous patch from Matthew Wilcox <matthew@wil.cx>
which did the prepare_discard_fn but not the different payload allocation
yet.

Signed-off-by: Christoph Hellwig <hch@lst.de>

-- 

 block/blk-barrier.c         |   37 +++++++++++++++++++++++++++++++------
 block/blk-core.c            |    3 +--
 block/blk-settings.c        |   17 -----------------
 drivers/mtd/mtd_blkdevs.c   |   19 +++++--------------
 drivers/staging/dst/dcore.c |    2 +-
 include/linux/blkdev.h      |    6 ++----
6 files changed, 40 insertions(+), 44 deletions(-)

Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2009-09-17 11:47:20.557003984 -0300
+++ linux-2.6/block/blk-barrier.c	2009-09-17 12:19:18.659011091 -0300
@@ -350,6 +350,7 @@ static void blkdev_discard_end_io(struct
 
 	if (bio->bi_private)
 		complete(bio->bi_private);
+	__free_page(bio_page(bio));
 
 	bio_put(bio);
 }
@@ -372,26 +373,44 @@ int blkdev_issue_discard(struct block_de
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = flags & DISCARD_FL_BARRIER ?
 		DISCARD_BARRIER : DISCARD_NOBARRIER;
+	struct bio *bio;
+	struct page *page;
 	int ret = 0;
 
 	if (!q)
 		return -ENXIO;
 
-	if (!q->prepare_discard_fn)
+	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
 	while (nr_sects && !ret) {
-		struct bio *bio = bio_alloc(gfp_mask, 0);
-		if (!bio)
-			return -ENOMEM;
+		unsigned int sector_size = q->limits.logical_block_size;
 
+		bio = bio_alloc(gfp_mask, 1);
+		if (!bio)
+			goto out;
+		bio->bi_sector = sector;
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
 		if (flags & DISCARD_FL_WAIT)
 			bio->bi_private = &wait;
 
-		bio->bi_sector = sector;
-
+		/*
+		 * Add a zeroed one-sector payload as that's what
+		 * our current implementations need.  If we'll ever need
+		 * more the interface will need revisiting.
+		 */
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			goto out_free_bio;
+		if (bio_add_pc_page(q, bio, page, sector_size, 0) < sector_size)
+			goto out_free_page;
+
+		/*
+		 * And override the bio size - the way discard works we
+		 * touch many more blocks on disk than the actual payload
+		 * length.
+		 */
 		if (nr_sects > queue_max_hw_sectors(q)) {
 			bio->bi_size = queue_max_hw_sectors(q) << 9;
 			nr_sects -= queue_max_hw_sectors(q);
@@ -414,5 +433,11 @@ int blkdev_issue_discard(struct block_de
 		bio_put(bio);
 	}
 	return ret;
+out_free_page:
+	__free_page(page);
+out_free_bio:
+	bio_put(bio);
+out:
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2009-09-17 11:47:20.594004647 -0300
+++ linux-2.6/block/blk-core.c	2009-09-17 12:15:20.485003934 -0300
@@ -1124,7 +1124,6 @@ void init_request_from_bio(struct reques
 		req->cmd_flags |= REQ_DISCARD;
 		if (bio_rw_flagged(bio, BIO_RW_BARRIER))
 			req->cmd_flags |= REQ_SOFTBARRIER;
-		req->q->prepare_discard_fn(req->q, req);
 	} else if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER)))
 		req->cmd_flags |= REQ_HARDBARRIER;
 
@@ -1470,7 +1469,7 @@ static inline void __generic_make_reques
 			goto end_io;
 
 		if (bio_rw_flagged(bio, BIO_RW_DISCARD) &&
-		    !q->prepare_discard_fn) {
+		    !blk_queue_discard(q)) {
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2009-09-17 11:47:20.601004002 -0300
+++ linux-2.6/block/blk-settings.c	2009-09-17 12:15:20.494003963 -0300
@@ -34,23 +34,6 @@ void blk_queue_prep_rq(struct request_qu
 EXPORT_SYMBOL(blk_queue_prep_rq);
 
 /**
- * blk_queue_set_discard - set a discard_sectors function for queue
- * @q:		queue
- * @dfn:	prepare_discard function
- *
- * It's possible for a queue to register a discard callback which is used
- * to transform a discard request into the appropriate type for the
- * hardware. If none is registered, then discard requests are failed
- * with %EOPNOTSUPP.
- *
- */
-void blk_queue_set_discard(struct request_queue *q, prepare_discard_fn *dfn)
-{
-	q->prepare_discard_fn = dfn;
-}
-EXPORT_SYMBOL(blk_queue_set_discard);
-
-/**
  * blk_queue_merge_bvec - set a merge_bvec function for queue
  * @q:		queue
  * @mbfn:	merge_bvec_fn
Index: linux-2.6/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtd_blkdevs.c	2009-09-17 11:47:20.607004137 -0300
+++ linux-2.6/drivers/mtd/mtd_blkdevs.c	2009-09-17 11:47:34.453004247 -0300
@@ -32,14 +32,6 @@ struct mtd_blkcore_priv {
 	spinlock_t queue_lock;
 };
 
-static int blktrans_discard_request(struct request_queue *q,
-				    struct request *req)
-{
-	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
-	req->cmd[0] = REQ_LB_OP_DISCARD;
-	return 0;
-}
-
 static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 			       struct mtd_blktrans_dev *dev,
 			       struct request *req)
@@ -52,10 +44,6 @@ static int do_blktrans_request(struct mt
 
 	buf = req->buffer;
 
-	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
-	    req->cmd[0] == REQ_LB_OP_DISCARD)
-		return tr->discard(dev, block, nsect);
-
 	if (!blk_fs_request(req))
 		return -EIO;
 
@@ -63,6 +51,9 @@ static int do_blktrans_request(struct mt
 	    get_capacity(req->rq_disk))
 		return -EIO;
 
+	if (blk_discard_rq(req))
+		return tr->discard(dev, block, nsect);
+
 	switch(rq_data_dir(req)) {
 	case READ:
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
@@ -380,8 +371,8 @@ int register_mtd_blktrans(struct mtd_blk
 	tr->blkcore_priv->rq->queuedata = tr;
 	blk_queue_logical_block_size(tr->blkcore_priv->rq, tr->blksize);
 	if (tr->discard)
-		blk_queue_set_discard(tr->blkcore_priv->rq,
-				      blktrans_discard_request);
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
+					tr->blkcore_priv->rq);
 
 	tr->blkshift = ffs(tr->blksize) - 1;
 
Index: linux-2.6/drivers/staging/dst/dcore.c
===================================================================
--- linux-2.6.orig/drivers/staging/dst/dcore.c	2009-09-17 11:47:20.615002991 -0300
+++ linux-2.6/drivers/staging/dst/dcore.c	2009-09-17 11:47:34.456003163 -0300
@@ -102,7 +102,7 @@ static int dst_request(struct request_qu
 	struct dst_node *n = q->queuedata;
 	int err = -EIO;
 
-	if (bio_empty_barrier(bio) && !q->prepare_discard_fn) {
+	if (bio_empty_barrier(bio) && !blk_queue_discard(q)) {
 		/*
 		 * This is a dirty^Wnice hack, but if we complete this
 		 * operation with -EOPNOTSUPP like intended, XFS
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-09-17 11:47:20.622004162 -0300
+++ linux-2.6/include/linux/blkdev.h	2009-09-17 12:15:20.542254662 -0300
@@ -82,7 +82,6 @@ enum rq_cmd_type_bits {
 enum {
 	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
 	REQ_LB_OP_FLUSH = 0x41,		/* flush request */
-	REQ_LB_OP_DISCARD = 0x42,	/* discard sectors */
 };
 
 /*
@@ -261,7 +260,6 @@ typedef void (request_fn_proc) (struct r
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
-typedef int (prepare_discard_fn) (struct request_queue *, struct request *);
 
 struct bio_vec;
 struct bvec_merge_data {
@@ -340,7 +338,6 @@ struct request_queue
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
-	prepare_discard_fn	*prepare_discard_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
@@ -460,6 +457,7 @@ struct request_queue
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 #define QUEUE_FLAG_CQ	       16	/* hardware does queuing */
+#define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -591,6 +589,7 @@ enum {
 #define blk_queue_flushing(q)	((q)->ordseq)
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
+#define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
@@ -955,7 +954,6 @@ extern void blk_queue_merge_bvec(struct 
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
-extern void blk_queue_set_discard(struct request_queue *, prepare_discard_fn *);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);

