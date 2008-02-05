From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/5] libata: implement drain buffers
Date: Tue,  5 Feb 2008 16:53:05 +0900
Message-ID: <12021979861729-git-send-email-htejun@gmail.com>
References: <12021979851743-git-send-email-htejun@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <12021979851743-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

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
    * ata_dev_printk() used instead of sdev_printk().

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/libata-scsi.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e54ee6e..185d699 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -826,17 +826,38 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	sdev->max_device_blocked = 1;
 }
 
-static void ata_scsi_dev_config(struct scsi_device *sdev,
-				struct ata_device *dev)
+static int atapi_drain_needed(struct request *rq)
+{
+	if (likely(!blk_pc_request(rq)))
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
@@ -853,6 +874,8 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		depth = min(ATA_MAX_QUEUE - 1, depth);
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
+
+	return 0;
 }
 
 /**
@@ -871,13 +894,14 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
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
@@ -897,6 +921,7 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 void ata_scsi_slave_destroy(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
 	struct ata_device *dev;
 
@@ -912,6 +937,10 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
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

