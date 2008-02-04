From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/3] libata: implement drain buffers
Date: Mon, 04 Feb 2008 10:42:13 -0600
Message-ID: <1202143333.3096.35.camel@localhost.localdomain>
References: <1202142930.3096.29.camel@localhost.localdomain>
	 <1202143204.3096.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202143204.3096.31.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This just updates the libata slave configure routine to take advantage
of the block layer drain buffers.  It also adjusts the size lengths in
the atapi code to add the drain buffer to the DMA length so the driver
knows it can rely on it.

I suspect I should also be checking for AHCI as well as ATA_DEV_ATAPI,
but I couldn't see how to do that easily.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/ata/libata-scsi.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8ffff44..acf6a8b 100644
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
@@ -839,6 +839,16 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		sdev->manage_start_stop = 1;
 	}
 
+	if (dev->class == ATA_DEV_ATAPI) {
+		struct request_queue *q = sdev->request_queue;
+		void *buf = kmalloc(ATAPI_MAX_DRAIN, GFP_KERNEL);
+		if (!buf) {
+			sdev_printk(KERN_ERR, sdev, "drain buffer allocation failed\n");
+			return -ENOMEM;
+		}
+		blk_queue_dma_drain(q, buf, ATAPI_MAX_DRAIN);
+	}
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
@@ -849,6 +859,8 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		depth = min(ATA_MAX_QUEUE - 1, depth);
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
+
+	return 0;
 }
 
 /**
@@ -867,13 +879,14 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
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
@@ -895,6 +908,7 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	unsigned long flags;
 	struct ata_device *dev;
+	struct request_queue *q = sdev->request_queue;
 
 	if (!ap->ops->error_handler)
 		return;
@@ -908,6 +922,10 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 		ata_port_schedule_eh(ap);
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
+
+	kfree(q->dma_drain_buffer);
+	q->dma_drain_buffer = NULL;
+	q->dma_drain_size = 0;
 }
 
 /**
@@ -2478,6 +2496,8 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 
 	qc->tf.command = ATA_CMD_PACKET;
 	qc->nbytes = scsi_bufflen(scmd);
+	if (blk_pc_request(scmd->request))
+		qc->nbytes += blk_rq_drain_size(scmd->request);
 
 	/* check whether ATAPI DMA is safe */
 	if (!using_pio && ata_check_atapi_dma(qc))
@@ -2814,6 +2834,8 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 *       cover scatter/gather case.
 	 */
 	qc->nbytes = scsi_bufflen(scmd);
+	if (ata_is_atapi(qc->tf.protocol))
+		qc->nbytes += blk_rq_drain_size(scmd->request);
 
 	/* request result TF and be quiet about device error */
 	qc->flags |= ATA_QCFLAG_RESULT_TF | ATA_QCFLAG_QUIET;
-- 
1.5.3.8



