From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 07/13] block: Deprecate blk_queue_stack_limits
Date: Fri, 15 May 2009 00:40:29 -0400
Message-ID: <1242362435-11953-8-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

blk_queue_stack_limits() has been replaced by blk_stack_limits() and
disk_stack_limits() and can be removed.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c   |   40 ----------------------------------------
 include/linux/blkdev.h |    1 -
 2 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index aea6762..001ab8d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -402,46 +402,6 @@ EXPORT_SYMBOL(blk_queue_io_opt);
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
 
 /**
- * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
- * @t:	the stacking driver (top)
- * @b:  the underlying device (bottom)
- **/
-void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
-{
-	/* zero is "infinity" */
-	t->limits.max_sectors = min_not_zero(queue_max_sectors(t),
-					     queue_max_sectors(b));
-
-	t->limits.max_hw_sectors = min_not_zero(queue_max_hw_sectors(t),
-						queue_max_hw_sectors(b));
-
-	t->limits.seg_boundary_mask = min_not_zero(queue_segment_boundary(t),
-						   queue_segment_boundary(b));
-
-	t->limits.max_phys_segments = min_not_zero(queue_max_phys_segments(t),
-						   queue_max_phys_segments(b));
-
-	t->limits.max_hw_segments = min_not_zero(queue_max_hw_segments(t),
-						 queue_max_hw_segments(b));
-
-	t->limits.max_segment_size = min_not_zero(queue_max_segment_size(t),
-						  queue_max_segment_size(b));
-
-	t->limits.logical_block_size = max(queue_logical_block_size(t),
-					   queue_logical_block_size(b));
-
-	if (!t->queue_lock)
-		WARN_ON_ONCE(1);
-	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
-		unsigned long flags;
-		spin_lock_irqsave(t->queue_lock, flags);
-		queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
-		spin_unlock_irqrestore(t->queue_lock, flags);
-	}
-}
-EXPORT_SYMBOL(blk_queue_stack_limits);
-
-/**
  * blk_stack_limits - adjust queue_limits for stacked devices
  * @t:	the stacking driver limits (top)
  * @bdev:  the underlying queue limits (bottom)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 55d19dc..df5a8cd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -923,7 +923,6 @@ extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 			      sector_t offset);
-extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
 extern int blk_queue_dma_drain(struct request_queue *q,
-- 
1.6.0.6

