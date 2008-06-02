From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 1/6] block: add blk_queue_update_dma_pad
Date: Mon,  2 Jun 2008 15:57:27 +0900
Message-ID: <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This adds blk_queue_update_dma_pad to prevent LLDs from overwriting
the dma pad mask wrongly (we added blk_queue_update_dma_alignment due
to the same reason).

This also converts libata to use blk_queue_update_dma_pad instead of
blk_queue_dma_pad.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-settings.c      |   24 ++++++++++++++++++++----
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    1 +
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8dd8641..dfc7701 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -302,11 +302,10 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * @q:     the request queue for the device
  * @mask:  pad mask
  *
- * Set pad mask.  Direct IO requests are padded to the mask specified.
+ * Set dma pad mask.
  *
- * Appending pad buffer to a request modifies ->data_len such that it
- * includes the pad buffer.  The original requested data length can be
- * obtained using blk_rq_raw_data_len().
+ * Appending pad buffer to a request modifies the last entry of a
+ * scatter list such that it includes the pad buffer.
  **/
 void blk_queue_dma_pad(struct request_queue *q, unsigned int mask)
 {
@@ -315,6 +314,23 @@ void blk_queue_dma_pad(struct request_queue *q, unsigned int mask)
 EXPORT_SYMBOL(blk_queue_dma_pad);
 
 /**
+ * blk_queue_update_dma_pad - update pad mask
+ * @q:     the request queue for the device
+ * @mask:  pad mask
+ *
+ * Update dma pad mask.
+ *
+ * Appending pad buffer to a request modifies the last entry of a
+ * scatter list such that it includes the pad buffer.
+ **/
+void blk_queue_update_dma_pad(struct request_queue *q, unsigned int mask)
+{
+	if (mask > q->dma_pad_mask)
+		q->dma_pad_mask = mask;
+}
+EXPORT_SYMBOL(blk_queue_update_dma_pad);
+
+/**
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
  * @q:  the request queue for the device
  * @dma_drain_needed: fn which returns non-zero if drain is necessary
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index aeb6e01..60c0e28 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -885,7 +885,8 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		/* set the min alignment and padding */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_DMA_PAD_SZ - 1);
-		blk_queue_dma_pad(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
+		blk_queue_update_dma_pad(sdev->request_queue,
+					 ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1171abd..5d8c339 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -748,6 +748,7 @@ extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
+extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
 extern int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size);
-- 
1.5.4.2

