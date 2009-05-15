From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 03/13] block: Move queue limits to an embedded struct
Date: Fri, 15 May 2009 00:40:25 -0400
Message-ID: <1242362435-11953-4-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:58073 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbZEOEmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 00:42:11 -0400
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

From: Martin K. Petersen <martin.petersen@oracle.com>

To accommodate stacking drivers that do not have an associated request
queue we're moving the limits to a separate, embedded structure.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c   |   55 +++++++++++++++++++++++++++++------------------
 include/linux/blkdev.h |   44 ++++++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0b32f98..b0f547c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -179,16 +179,16 @@ void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
 	 */
 	if (b_pfn < (min_t(u64, 0xffffffffUL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
-	q->bounce_pfn = max_low_pfn;
+	q->limits.bounce_pfn = max_low_pfn;
 #else
 	if (b_pfn < blk_max_low_pfn)
 		dma = 1;
-	q->bounce_pfn = b_pfn;
+	q->limits.bounce_pfn = b_pfn;
 #endif
 	if (dma) {
 		init_emergency_isa_pool();
 		q->bounce_gfp = GFP_NOIO | GFP_DMA;
-		q->bounce_pfn = b_pfn;
+		q->limits.bounce_pfn = b_pfn;
 	}
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
@@ -211,10 +211,10 @@ void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
 	}
 
 	if (BLK_DEF_MAX_SECTORS > max_sectors)
-		q->max_hw_sectors = q->max_sectors = max_sectors;
+		q->limits.max_hw_sectors = q->limits.max_sectors = max_sectors;
 	else {
-		q->max_sectors = BLK_DEF_MAX_SECTORS;
-		q->max_hw_sectors = max_sectors;
+		q->limits.max_sectors = BLK_DEF_MAX_SECTORS;
+		q->limits.max_hw_sectors = max_sectors;
 	}
 }
 EXPORT_SYMBOL(blk_queue_max_sectors);
@@ -222,9 +222,9 @@ EXPORT_SYMBOL(blk_queue_max_sectors);
 void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_sectors)
 {
 	if (BLK_DEF_MAX_SECTORS > max_sectors)
-		q->max_hw_sectors = BLK_DEF_MAX_SECTORS;
+		q->limits.max_hw_sectors = BLK_DEF_MAX_SECTORS;
 	else
-		q->max_hw_sectors = max_sectors;
+		q->limits.max_hw_sectors = max_sectors;
 }
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
@@ -247,7 +247,7 @@ void blk_queue_max_phys_segments(struct request_queue *q,
 		       __func__, max_segments);
 	}
 
-	q->max_phys_segments = max_segments;
+	q->limits.max_phys_segments = max_segments;
 }
 EXPORT_SYMBOL(blk_queue_max_phys_segments);
 
@@ -271,7 +271,7 @@ void blk_queue_max_hw_segments(struct request_queue *q,
 		       __func__, max_segments);
 	}
 
-	q->max_hw_segments = max_segments;
+	q->limits.max_hw_segments = max_segments;
 }
 EXPORT_SYMBOL(blk_queue_max_hw_segments);
 
@@ -292,7 +292,7 @@ void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
 		       __func__, max_size);
 	}
 
-	q->max_segment_size = max_size;
+	q->limits.max_segment_size = max_size;
 }
 EXPORT_SYMBOL(blk_queue_max_segment_size);
 
@@ -308,7 +308,7 @@ EXPORT_SYMBOL(blk_queue_max_segment_size);
  **/
 void blk_queue_logical_block_size(struct request_queue *q, unsigned short size)
 {
-	q->logical_block_size = size;
+	q->limits.logical_block_size = size;
 }
 EXPORT_SYMBOL(blk_queue_logical_block_size);
 
@@ -325,14 +325,27 @@ EXPORT_SYMBOL(blk_queue_logical_block_size);
 void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 {
 	/* zero is "infinity" */
-	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
-	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
-	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask, b->seg_boundary_mask);
-
-	t->max_phys_segments = min_not_zero(t->max_phys_segments, b->max_phys_segments);
-	t->max_hw_segments = min_not_zero(t->max_hw_segments, b->max_hw_segments);
-	t->max_segment_size = min_not_zero(t->max_segment_size, b->max_segment_size);
-	t->logical_block_size = max(t->logical_block_size, b->logical_block_size);
+	t->limits.max_sectors = min_not_zero(queue_max_sectors(t),
+					     queue_max_sectors(b));
+
+	t->limits.max_hw_sectors = min_not_zero(queue_max_hw_sectors(t),
+						queue_max_hw_sectors(b));
+
+	t->limits.seg_boundary_mask = min_not_zero(queue_segment_boundary(t),
+						   queue_segment_boundary(b));
+
+	t->limits.max_phys_segments = min_not_zero(queue_max_phys_segments(t),
+						   queue_max_phys_segments(b));
+
+	t->limits.max_hw_segments = min_not_zero(queue_max_hw_segments(t),
+						 queue_max_hw_segments(b));
+
+	t->limits.max_segment_size = min_not_zero(queue_max_segment_size(t),
+						  queue_max_segment_size(b));
+
+	t->limits.logical_block_size = max(queue_logical_block_size(t),
+					   queue_logical_block_size(b));
+
 	if (!t->queue_lock)
 		WARN_ON_ONCE(1);
 	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
@@ -430,7 +443,7 @@ void blk_queue_segment_boundary(struct request_queue *q, unsigned long mask)
 		       __func__, mask);
 	}
 
-	q->seg_boundary_mask = mask;
+	q->limits.seg_boundary_mask = mask;
 }
 EXPORT_SYMBOL(blk_queue_segment_boundary);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e7950df..2655673 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -307,6 +307,21 @@ struct blk_cmd_filter {
 	struct kobject kobj;
 };
 
+struct queue_limits {
+	unsigned long		bounce_pfn;
+	unsigned long		seg_boundary_mask;
+
+	unsigned int		max_hw_sectors;
+	unsigned int		max_sectors;
+	unsigned int		max_segment_size;
+
+	unsigned short		logical_block_size;
+	unsigned short		max_hw_segments;
+	unsigned short		max_phys_segments;
+
+	unsigned char		no_cluster;
+};
+
 struct request_queue
 {
 	/*
@@ -358,7 +373,6 @@ struct request_queue
 	/*
 	 * queue needs bounce pages for pages above this limit
 	 */
-	unsigned long		bounce_pfn;
 	gfp_t			bounce_gfp;
 
 	/*
@@ -387,14 +401,6 @@ struct request_queue
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
 
-	unsigned int		max_sectors;
-	unsigned int		max_hw_sectors;
-	unsigned short		max_phys_segments;
-	unsigned short		max_hw_segments;
-	unsigned short		logical_block_size;
-	unsigned int		max_segment_size;
-
-	unsigned long		seg_boundary_mask;
 	void			*dma_drain_buffer;
 	unsigned int		dma_drain_size;
 	unsigned int		dma_pad_mask;
@@ -410,6 +416,8 @@ struct request_queue
 	struct timer_list	timeout;
 	struct list_head	timeout_list;
 
+	struct queue_limits	limits;
+
 	/*
 	 * sg stuff
 	 */
@@ -989,45 +997,45 @@ extern void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter);
 
 static inline unsigned long queue_bounce_pfn(struct request_queue *q)
 {
-	return q->bounce_pfn;
+	return q->limits.bounce_pfn;
 }
 
 static inline unsigned long queue_segment_boundary(struct request_queue *q)
 {
-	return q->seg_boundary_mask;
+	return q->limits.seg_boundary_mask;
 }
 
 static inline unsigned int queue_max_sectors(struct request_queue *q)
 {
-	return q->max_sectors;
+	return q->limits.max_sectors;
 }
 
 static inline unsigned int queue_max_hw_sectors(struct request_queue *q)
 {
-	return q->max_hw_sectors;
+	return q->limits.max_hw_sectors;
 }
 
 static inline unsigned short queue_max_hw_segments(struct request_queue *q)
 {
-	return q->max_hw_segments;
+	return q->limits.max_hw_segments;
 }
 
 static inline unsigned short queue_max_phys_segments(struct request_queue *q)
 {
-	return q->max_phys_segments;
+	return q->limits.max_phys_segments;
 }
 
 static inline unsigned int queue_max_segment_size(struct request_queue *q)
 {
-	return q->max_segment_size;
+	return q->limits.max_segment_size;
 }
 
 static inline unsigned short queue_logical_block_size(struct request_queue *q)
 {
 	int retval = 512;
 
-	if (q && q->logical_block_size)
-		retval = q->logical_block_size;
+	if (q && q->limits.logical_block_size)
+		retval = q->limits.logical_block_size;
 
 	return retval;
 }
-- 
1.6.0.6

