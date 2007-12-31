From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/2] block: Introduce new blk_queue_update_dma_alignment
	interface
Date: Mon, 31 Dec 2007 16:37:00 -0600
Message-ID: <1199140621.3110.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38720 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbXLaWhK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Dec 2007 17:37:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The purpose of this is to allow stacked alignment settings, with the
ultimate queue alignment being set to the largest alignment requirement
in the stack.

The reason for this is so that the SCSI mid-layer can relax the default
alignment requirements (which are basically causing a lot of superfluous
copying to go on in the SG_IO interface) while allowing transports,
devices or HBAs to add stricter limits if they need them.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8b91994..8097bf0 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -760,6 +760,30 @@ void blk_queue_dma_alignment(struct request_queue *q, int mask)
 EXPORT_SYMBOL(blk_queue_dma_alignment);
 
 /**
+ * blk_queue_update_dma_alignment - update dma length and memory alignment
+ * @q:     the request queue for the device
+ * @mask:  alignment mask
+ *
+ * description:
+ *    update required memory and length aligment for direct dma transactions.
+ *    If the requested alignment is larger than the current alignment, then
+ *    the current queue alignment is updated to the new value, otherwise it 
+ *    is left alone.  The design of this is to allow multiple objects
+ *    (driver, device, transport etc) to set their respective
+ *    alignments without having them interfere.
+ *
+ **/
+void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
+{
+	BUG_ON(mask > PAGE_SIZE);
+
+	if (mask > q->dma_alignment)
+		q->dma_alignment = mask;
+}
+
+EXPORT_SYMBOL(blk_queue_update_dma_alignment);
+
+/**
  * blk_queue_find_tag - find a request by its tag and queue
  * @q:	 The request queue for the device
  * @tag: The tag of the request
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d18ee67..81e99e5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -766,6 +766,7 @@ extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
+extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);


