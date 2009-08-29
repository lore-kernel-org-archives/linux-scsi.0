From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] block: allow large discard requests
Date: Sat, 29 Aug 2009 19:03:38 -0400
Message-ID: <20090829231122.302813585@bombadil.infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752838AbZH2XMk@vger.kernel.org>
Content-Disposition: inline; filename=discard-allow-large-requests
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

Currently we set the bio size to the byte equivalent of the blocks to
be trimmed when submitting the initial DISCARD ioctl.  That means it
is subject to the max_hw_sectors limitation of the HBA which is
much lower than the size of a DISCARD request we can support.
Add a separate max_discard_bytes tunable to limit the size for discard
requests.  Currently for all implementations it's all we can fit into
the 32 bit variable that holds the bio size, although it could be much
larger if we had a way to pass it through the block layer as a number
of sectors.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2009-08-29 19:31:29.891344258 -0300
+++ linux-2.6/block/blk-core.c	2009-08-29 19:31:56.891344537 -0300
@@ -1431,7 +1431,8 @@ static inline void __generic_make_reques
 			goto end_io;
 		}
 
-		if (unlikely(nr_sectors > queue_max_hw_sectors(q))) {
+		if (unlikely(!bio_discard(bio) &&
+			     nr_sectors > queue_max_hw_sectors(q))) {
 			printk(KERN_ERR "bio too big device %s (%u > %u)\n",
 			       bdevname(bio->bi_bdev, b),
 			       bio_sectors(bio),
Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2009-08-29 19:31:29.911344985 -0300
+++ linux-2.6/block/blk-settings.c	2009-08-29 19:31:56.895345046 -0300
@@ -35,8 +35,9 @@ EXPORT_SYMBOL(blk_queue_prep_rq);
 
 /**
  * blk_queue_set_discard - set a discard_sectors function for queue
- * @q:		queue
- * @dfn:	prepare_discard function
+ * @q:			queue
+ * @dfn:		prepare_discard function
+ * @max_discard:	maximum number of bytes for a single discard request
  *
  * It's possible for a queue to register a discard callback which is used
  * to transform a discard request into the appropriate type for the
@@ -44,8 +45,10 @@ EXPORT_SYMBOL(blk_queue_prep_rq);
  * with %EOPNOTSUPP.
  *
  */
-void blk_queue_set_discard(struct request_queue *q, prepare_discard_fn *dfn)
+void blk_queue_set_discard(struct request_queue *q, prepare_discard_fn *dfn,
+		unsigned int max_discard)
 {
+	q->limits.max_discard_bytes = max_discard;
 	q->prepare_discard_fn = dfn;
 }
 EXPORT_SYMBOL(blk_queue_set_discard);
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-08-29 19:31:29.951344623 -0300
+++ linux-2.6/include/linux/blkdev.h	2009-08-29 19:31:56.895345046 -0300
@@ -308,6 +308,7 @@ struct queue_limits {
 	unsigned int		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
+	unsigned int		max_discard_bytes;
 
 	unsigned short		logical_block_size;
 	unsigned short		max_hw_segments;
@@ -935,7 +936,8 @@ extern void blk_queue_merge_bvec(struct 
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
-extern void blk_queue_set_discard(struct request_queue *, prepare_discard_fn *);
+extern void blk_queue_set_discard(struct request_queue *, prepare_discard_fn *,
+		unsigned int max_discard);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2009-08-29 19:31:29.931344315 -0300
+++ linux-2.6/block/blk-barrier.c	2009-08-29 19:31:56.899380824 -0300
@@ -384,6 +384,8 @@ int blkdev_issue_discard(struct block_de
 
 	while (nr_sects && !ret) {
 		struct bio *bio = bio_alloc(gfp_mask, 1);
+		unsigned int max_discard_sectors;
+
 		if (!bio)
 			return -ENOMEM;
 
@@ -394,10 +396,11 @@ int blkdev_issue_discard(struct block_de
 
 		bio->bi_sector = sector;
 
-		if (nr_sects > queue_max_hw_sectors(q)) {
-			bio->bi_size = queue_max_hw_sectors(q) << 9;
-			nr_sects -= queue_max_hw_sectors(q);
-			sector += queue_max_hw_sectors(q);
+		max_discard_sectors = q->limits.max_discard_bytes >> 9;
+		if (nr_sects > max_discard_sectors) {
+			bio->bi_size = q->limits.max_discard_bytes;
+			nr_sects -= max_discard_sectors;
+			sector += max_discard_sectors;
 		} else {
 			bio->bi_size = nr_sects << 9;
 			nr_sects = 0;
Index: linux-2.6/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtd_blkdevs.c	2009-08-29 19:31:29.971356036 -0300
+++ linux-2.6/drivers/mtd/mtd_blkdevs.c	2009-08-29 19:31:56.903369320 -0300
@@ -381,7 +381,7 @@ int register_mtd_blktrans(struct mtd_blk
 	blk_queue_logical_block_size(tr->blkcore_priv->rq, tr->blksize);
 	if (tr->discard)
 		blk_queue_set_discard(tr->blkcore_priv->rq,
-				      blktrans_discard_request);
+				      blktrans_discard_request, 0xffffffff);
 
 	tr->blkshift = ffs(tr->blksize) - 1;
 
Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c	2009-08-29 19:31:29.983344641 -0300
+++ linux-2.6/drivers/scsi/sd.c	2009-08-29 19:31:56.907380585 -0300
@@ -1963,7 +1963,8 @@ static int sd_revalidate_disk(struct gen
 
 	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
 	if (sdkp->thin_provisioning && !sdp->request_queue->prepare_discard_fn)
-		blk_queue_set_discard(sdkp->disk->queue, sd_prepare_discard);
+		blk_queue_set_discard(sdkp->disk->queue, sd_prepare_discard,
+				      0xffffffff);
 
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
Index: linux-2.6/drivers/ata/libata-scsi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-scsi.c	2009-08-29 19:32:05.391879870 -0300
+++ linux-2.6/drivers/ata/libata-scsi.c	2009-08-29 19:32:16.895376612 -0300
@@ -1140,7 +1140,8 @@ static int ata_scsi_dev_config(struct sc
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
 	if (ata_id_has_trim(dev->id))
-		blk_queue_set_discard(sdev->request_queue, ata_discard_fn);
+		blk_queue_set_discard(sdev->request_queue, ata_discard_fn,
+				     0xffffffff);
 
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
