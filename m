From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 7/7] libata: implement drain buffers
Date: Sat,  9 Feb 2008 10:40:26 +0900
Message-ID: <1202521228149-git-send-email-htejun@gmail.com>
References: <12025212262892-git-send-email-htejun@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:57403 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637AbYBIBkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 20:40:41 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2705689rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Feb 2008 17:40:40 -0800 (PST)
In-Reply-To: <12025212262892-git-send-email-htejun@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <htejun@gmail.com>

From: James Bottomley <James.Bottomley@HansenPartnership.com>

This just updates the libata slave configure routine to take advantage
of the block layer drain buffers.  It also adjusts the size lengths in
the atapi code to add the drain buffer to the DMA length so the driver
knows it can rely on it.

I suspect I should also be checking for AHCI as well as ATA_DEV_ATAPI,
but I couldn't see how to do that easily.

tj: * atapi_drain_needed() added such that draining is applied to only
      misc ATAPI commands.
    * q->bounce_gfp used when allocating drain buffer.
    * Now duplicate ATAPI PIO drain logic dropped.
    * ata_dev_printk() used instead of sdev_printk().

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/libata-core.c |   56 +++---------------------------------------
 drivers/ata/libata-scsi.c |   59 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 58 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d49b271..c03cef4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4623,28 +4623,6 @@ int ata_check_atapi_dma(struct ata_queued_cmd *qc)
 }
 
 /**
- *	atapi_qc_may_overflow - Check whether data transfer may overflow
- *	@qc: ATA command in question
- *
- *	ATAPI commands which transfer variable length data to host
- *	might overflow due to application error or hardare bug.  This
- *	function checks whether overflow should be drained and ignored
- *	for @qc.
- *
- *	LOCKING:
- *	None.
- *
- *	RETURNS:
- *	1 if @qc may overflow; otherwise, 0.
- */
-static int atapi_qc_may_overflow(struct ata_queued_cmd *qc)
-{
-	return ata_is_atapi(qc->tf.protocol) && ata_is_data(qc->tf.protocol) &&
-		atapi_cmd_type(qc->cdb[0]) == ATAPI_MISC &&
-		!(qc->tf.flags & ATA_TFLAG_WRITE);
-}
-
-/**
  *	ata_std_qc_defer - Check whether a qc needs to be deferred
  *	@qc: ATA command in question
  *
@@ -5007,36 +4985,10 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 next_sg:
 	sg = qc->cursg;
 	if (unlikely(!sg)) {
-		/*
-		 * The end of qc->sg is reached and the device expects
-		 * more data to transfer. In order not to overrun qc->sg
-		 * and fulfill length specified in the byte count register,
-		 *    - for read case, discard trailing data from the device
-		 *    - for write case, padding zero data to the device
-		 */
-		u16 pad_buf[1] = { 0 };
-
-		if (qc->curbytes + bytes > qc->nbytes + ATAPI_MAX_DRAIN) {
-			ata_ehi_push_desc(ehi, "too much trailing data "
-					  "buf=%u cur=%u bytes=%u",
-					  qc->nbytes, qc->curbytes, bytes);
-			return -1;
-		}
-
-		/* allow overflow only for misc ATAPI commands */
-		if (!atapi_qc_may_overflow(qc)) {
-			ata_ehi_push_desc(ehi, "unexpected trailing data "
-					  "%u bytes", bytes);
-			return -1;
-		}
-
-		consumed = 0;
-		while (consumed < bytes)
-			consumed += ap->ops->data_xfer(dev,
-					(unsigned char *)pad_buf, 2, rw);
-
-		qc->curbytes += bytes;
-		return 0;
+		ata_ehi_push_desc(ehi, "unexpected or too much trailing data "
+				  "buf=%u cur=%u bytes=%u",
+				  qc->nbytes, qc->curbytes, bytes);
+		return -1;
 	}
 
 	page = sg_page(sg);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e54ee6e..b3b3b44 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -826,17 +826,56 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	sdev->max_device_blocked = 1;
 }
 
-static void ata_scsi_dev_config(struct scsi_device *sdev,
-				struct ata_device *dev)
+/**
+ *	atapi_drain_needed - Check whether data transfer may overflow
+ *	@request: request to be checked
+ *
+ *	ATAPI commands which transfer variable length data to host
+ *	might overflow due to application error or hardare bug.  This
+ *	function checks whether overflow should be drained and ignored
+ *	for @request.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	1 if ; otherwise, 0.
+ */
+static int atapi_drain_needed(struct request *rq)
+{
+	if (likely(!blk_pc_request(rq)))
+		return 0;
+
+	if (!rq->data_len || (rq->cmd_flags & REQ_RW))
+		return 0;
+
+	return atapi_cmd_type(rq->cmd[0]) == ATAPI_MISC;
+}
+
+static int ata_scsi_dev_config(struct scsi_device *sdev,
+			       struct ata_device *dev)
 {
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
-	if (dev->class == ATA_DEV_ATAPI)
+	if (dev->class == ATA_DEV_ATAPI) {
+		struct request_queue *q = sdev->request_queue;
+		void *buf;
+
 		/* set the min alignment */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_DMA_PAD_SZ - 1);
-	else {
+
+		/* configure draining */
+		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
+		if (!buf) {
+			ata_dev_printk(dev, KERN_ERR,
+				       "drain buffer allocation failed\n");
+			return -ENOMEM;
+		}
+
+		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
+	} else {
 		/* ATA devices must be sector aligned */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
@@ -853,6 +892,8 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		depth = min(ATA_MAX_QUEUE - 1, depth);
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
+
+	return 0;
 }
 
 /**
@@ -871,13 +912,14 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
+	int rc = 0;
 
 	ata_scsi_sdev_config(sdev);
 
 	if (dev)
-		ata_scsi_dev_config(sdev, dev);
+		rc = ata_scsi_dev_config(sdev, dev);
 
-	return 0;
+	return rc;
 }
 
 /**
@@ -897,6 +939,7 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 void ata_scsi_slave_destroy(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
 	struct ata_device *dev;
 
@@ -912,6 +955,10 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 		ata_port_schedule_eh(ap);
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
+
+	kfree(q->dma_drain_buffer);
+	q->dma_drain_buffer = NULL;
+	q->dma_drain_size = 0;
 }
 
 /**
-- 
1.5.2.4

