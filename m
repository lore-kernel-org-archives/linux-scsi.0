From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 2/2] libata: implement drain buffers
Date: Thu, 10 Jan 2008 11:42:50 -0600
Message-ID: <1199986970.3141.59.camel@localhost.localdomain>
References: <11992723701811-git-send-email-htejun@gmail.com>
	 <11992723711076-git-send-email-htejun@gmail.com>
	 <1199986236.3141.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1199986236.3141.51.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This just updates the libata slave configure routine to take advantage
of the block layer drain buffers.

I suspect I should also be checking for AHCI as well as ATA_DEV_ATAPI,
but I couldn't see how to do that easily.

James

---

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a883bb0..ce8f63c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -826,8 +826,8 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	sdev->max_device_blocked = 1;
 }
 
-static void ata_scsi_dev_config(struct scsi_device *sdev,
-				struct ata_device *dev)
+static int ata_scsi_dev_config(struct scsi_device *sdev,
+			       struct ata_device *dev)
 {
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
@@ -838,7 +838,12 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 	 */
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
-		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
+		void *buf = kmalloc(ATAPI_MAX_DRAIN, GFP_KERNEL);
+		if (!buf) {
+			sdev_printk(KERN_ERR, sdev, "drain buffer allocation failed\n");
+			return -ENOMEM;
+		}
+		blk_queue_dma_drain(q, buf, ATAPI_MAX_DRAIN);
 	}
 
 	if (dev->flags & ATA_DFLAG_AN)
@@ -851,6 +856,8 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		depth = min(ATA_MAX_QUEUE - 1, depth);
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
+
+	return 0;
 }
 
 /**
@@ -869,15 +876,16 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
+	int rc = 0;
 
 	ata_scsi_sdev_config(sdev);
 
 	sdev->manage_start_stop = 1;
 
 	if (dev)
-		ata_scsi_dev_config(sdev, dev);
+		rc = ata_scsi_dev_config(sdev, dev);
 
-	return 0;	/* scsi layer doesn't check return value, sigh */
+	return rc;
 }
 
 /**
@@ -899,6 +907,7 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	unsigned long flags;
 	struct ata_device *dev;
+	struct request_queue *q = sdev->request_queue;
 
 	if (!ap->ops->error_handler)
 		return;
@@ -912,6 +921,10 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 		ata_port_schedule_eh(ap);
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
+
+	kfree(q->dma_drain_buffer);
+	q->dma_drain_buffer = NULL;
+	q->dma_drain_size = 0;
 }
 
 /**


