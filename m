From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] block: allow large discard requests
Date: Thu, 17 Sep 2009 12:25:38 -0400
Message-ID: <20090917163105.535796572@bombadil.infradead.org>
References: <20090917162536.815743395@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZIQQbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 12:31:03 -0400
Content-Disposition: inline; filename=discard-allow-large-requests
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, matthew@wil.cx, dwmw2@infradead.org
Cc: linux-scsi@vger.kernel.org

Currently we set the bio size to the byte equivalent of the blocks to
be trimmed when submitting the initial DISCARD ioctl.  That means it
is subject to the max_hw_sectors limitation of the HBA which is
much lower than the size of a DISCARD request we can support.
Add a separate max_discard_sectors tunable to limit the size for discard
requests. 

We limit the max discard request size in bytes to 32bit as that is the
limit for bio->bi_size.  This could be much larger if we had a way to pass
that information through the block layer.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2009-09-17 12:15:20.485003934 -0300
+++ linux-2.6/block/blk-core.c	2009-09-17 12:23:33.018028602 -0300
@@ -1436,7 +1436,8 @@ static inline void __generic_make_reques
 			goto end_io;
 		}
 
-		if (unlikely(nr_sectors > queue_max_hw_sectors(q))) {
+		if (unlikely(!bio_rw_flagged(bio, BIO_RW_DISCARD) &&
+			     nr_sectors > queue_max_hw_sectors(q))) {
 			printk(KERN_ERR "bio too big device %s (%u > %u)\n",
 			       bdevname(bio->bi_bdev, b),
 			       bio_sectors(bio),
Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2009-09-17 12:15:20.494003963 -0300
+++ linux-2.6/block/blk-settings.c	2009-09-17 13:12:00.770254159 -0300
@@ -95,6 +95,7 @@ void blk_set_default_limits(struct queue
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = MAX_SEGMENT_SIZE;
 	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
+	lim->max_discard_sectors = SAFE_MAX_SECTORS;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -237,6 +238,18 @@ void blk_queue_max_hw_sectors(struct req
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
 /**
+ * blk_queue_max_discard_sectors - set max sectors for a single discard
+ * @q:  the request queue for the device
+ * @max_discard: maximum number of sectors to discard
+ **/
+void blk_queue_max_discard_sectors(struct request_queue *q,
+		unsigned int max_discard_sectors)
+{
+	q->limits.max_discard_sectors = max_discard_sectors;
+}
+EXPORT_SYMBOL(blk_queue_max_discard_sectors);
+
+/**
  * blk_queue_max_phys_segments - set max phys segments for a request for this queue
  * @q:  the request queue for the device
  * @max_segments:  max number of segments
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-09-17 12:15:20.542254662 -0300
+++ linux-2.6/include/linux/blkdev.h	2009-09-17 13:12:15.542006586 -0300
@@ -311,6 +311,7 @@ struct queue_limits {
 	unsigned int		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
+	unsigned int		max_discard_sectors;
 
 	unsigned short		logical_block_size;
 	unsigned short		max_hw_segments;
@@ -928,6 +929,8 @@ extern void blk_queue_max_hw_sectors(str
 extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
+extern void blk_queue_max_discard_sectors(struct request_queue *q,
+		unsigned int max_discard_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_alignment_offset(struct request_queue *q,
Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2009-09-17 12:19:18.659011091 -0300
+++ linux-2.6/block/blk-barrier.c	2009-09-17 12:31:05.660256438 -0300
@@ -385,6 +385,8 @@ int blkdev_issue_discard(struct block_de
 
 	while (nr_sects && !ret) {
 		unsigned int sector_size = q->limits.logical_block_size;
+		unsigned int max_discard_sectors =
+			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio)
@@ -411,10 +413,10 @@ int blkdev_issue_discard(struct block_de
 		 * touch many more blocks on disk than the actual payload
 		 * length.
 		 */
-		if (nr_sects > queue_max_hw_sectors(q)) {
-			bio->bi_size = queue_max_hw_sectors(q) << 9;
-			nr_sects -= queue_max_hw_sectors(q);
-			sector += queue_max_hw_sectors(q);
+		if (nr_sects > max_discard_sectors) {
+			bio->bi_size = max_discard_sectors << 9;
+			nr_sects -= max_discard_sectors;
+			sector += max_discard_sectors;
 		} else {
 			bio->bi_size = nr_sects << 9;
 			nr_sects = 0;

