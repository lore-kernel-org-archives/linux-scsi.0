From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] block: separate out padding from alignment
Date: Mon, 03 Mar 2008 15:10:28 +0900
Message-ID: <47CB9654.2000109@gmail.com>
References: <47C8F4FC.1040505@gmail.com>	<20080302235223X.tomof@acm.org>	<47CB6508.3040206@gmail.com> <20080303125940T.fujita.tomonori@lab.ntt.co.jp> <47CB79E9.8000505@gmail.com> <47CB95C2.40309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:22741 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYCCGM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 01:12:27 -0500
Received: by wa-out-1112.google.com with SMTP id v27so6615610wah.23
        for <linux-scsi@vger.kernel.org>; Sun, 02 Mar 2008 22:12:27 -0800 (PST)
In-Reply-To: <47CB95C2.40309@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com

Block layer alignment was used for two different purposes - memory
alignment and padding.  This causes problems in lower layers because
drivers which only require memory alignment ends up with adjusted
rq->data_len.  Separate out padding such that padding occurs iff
driver explicitly requests it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
As wrote before, the major problem was that drivers which don't want
size adjustment got it acciedentally by mixing up aligning and padding
which are two conceptually separate things.  Let padding occur iff the
driver explicitly requested it.  This makes both parties happy.

 block/blk-map.c           |   16 +++++++++-------
 block/blk-settings.c      |   17 +++++++++++++++++
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    2 ++
 4 files changed, 30 insertions(+), 8 deletions(-)

Index: work/block/blk-settings.c
===================================================================
--- work.orig/block/blk-settings.c
+++ work/block/blk-settings.c
@@ -293,6 +293,23 @@ void blk_queue_stack_limits(struct reque
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
 /**
+ * blk_queue_dma_pad - set pad mask
+ * @q:     the request queue for the device
+ * @mask:  pad mask
+ *
+ * Set pad mask.  Direct IO requests are padded to the mask specified.
+ *
+ * Appending pad buffer to a request modifies ->data_len such that it
+ * includes the pad buffer.  The original requested data length can be
+ * obtained using blk_rq_raw_data_len().
+ **/
+void blk_queue_dma_pad(struct request_queue *q, unsigned int mask)
+{
+	q->dma_pad_mask = mask;
+}
+EXPORT_SYMBOL(blk_queue_dma_pad);
+
+/**
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
  *
  * @q:  the request queue for the device
Index: work/block/blk-map.c
===================================================================
--- work.orig/block/blk-map.c
+++ work/block/blk-map.c
@@ -43,6 +43,7 @@ static int __blk_rq_map_user(struct requ
 			     void __user *ubuf, unsigned int len)
 {
 	unsigned long uaddr;
+	unsigned int alignment;
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
@@ -53,8 +54,8 @@ static int __blk_rq_map_user(struct requ
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) &&
-	    !(len & queue_dma_alignment(q)))
+	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+	if (!(uaddr & alignment) && !(len & alignment))
 		bio = bio_map_user(q, NULL, uaddr, len, reading);
 	else
 		bio = bio_copy_user(q, uaddr, len, reading);
@@ -141,15 +142,16 @@ int blk_rq_map_user(struct request_queue
 
 	/*
 	 * __blk_rq_map_user() copies the buffers if starting address
-	 * or length isn't aligned.  As the copied buffer is always
-	 * page aligned, we know that there's enough room for padding.
-	 * Extend the last bio and update rq->data_len accordingly.
+	 * or length isn't aligned to dma_pad_mask.  As the copied
+	 * buffer is always page aligned, we know that there's enough
+	 * room for padding.  Extend the last bio and update
+	 * rq->data_len accordingly.
 	 *
 	 * On unmap, bio_uncopy_user() will use unmodified
 	 * bio_map_data pointed to by bio->bi_private.
 	 */
-	if (len & queue_dma_alignment(q)) {
-		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
+	if (len & q->dma_pad_mask) {
+		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
 		struct bio *bio = rq->biotail;
 
 		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -362,6 +362,7 @@ struct request_queue
 	unsigned long		seg_boundary_mask;
 	void			*dma_drain_buffer;
 	unsigned int		dma_drain_size;
+	unsigned int		dma_pad_mask;
 	unsigned int		dma_alignment;
 
 	struct blk_queue_tag	*queue_tags;
@@ -707,6 +708,7 @@ extern void blk_queue_max_hw_segments(st
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
+extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size);
Index: work/drivers/ata/libata-scsi.c
===================================================================
--- work.orig/drivers/ata/libata-scsi.c
+++ work/drivers/ata/libata-scsi.c
@@ -862,9 +862,10 @@ static int ata_scsi_dev_config(struct sc
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
-		/* set the min alignment */
+		/* set the min alignment and padding */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_DMA_PAD_SZ - 1);
+		blk_queue_dma_pad(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
