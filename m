From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata test-unit-ready for ATAPI devices
Date: Tue, 15 Nov 2005 23:48:41 -0500
Message-ID: <20051116044841.GA11722@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:49855 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S965242AbVKPEso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 23:48:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org


The following patch clears the "I was just reset" condition from an
ATAPI device, and waits for it to come online, before continuing with
the probe.

Not checking this into any upstream-bound branch, as I'm not yet
convinced of its value.


 drivers/scsi/libata-core.c |  135 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+)

diff --git a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
index ba1eb8b..89fa5c7 100644
--- a/drivers/scsi/libata-core.c
+++ b/drivers/scsi/libata-core.c
@@ -68,6 +68,7 @@ static void ata_dev_reread_id(struct ata
 static void ata_dev_init_params(struct ata_port *ap, struct ata_device *dev);
 static void ata_set_mode(struct ata_port *ap);
 static void ata_dev_set_xfermode(struct ata_port *ap, struct ata_device *dev);
+static void atapi_dev_tur(struct ata_port *ap, struct ata_device *dev);
 static unsigned int ata_get_mode_mask(const struct ata_port *ap, int shift);
 static int fgb(u32 bitmap);
 static int ata_choose_xfer_mode(const struct ata_port *ap,
@@ -1361,6 +1362,10 @@ static int ata_bus_probe(struct ata_port
 	if (ap->flags & ATA_FLAG_PORT_DISABLED)
 		goto err_out_disable;
 
+	for (i = 0; i < ATA_MAX_DEVICES; i++)
+		if (ap->device[i].class == ATA_DEV_ATAPI)
+			atapi_dev_tur(ap, &ap->device[i]);
+
 	return 0;
 
 err_out_disable:
@@ -2376,6 +2381,136 @@ static void ata_dev_init_params(struct a
 	DPRINTK("EXIT\n");
 }
 
+static int atapi_tur_request_sense(struct ata_port *ap, struct ata_device *dev)
+{
+	DECLARE_COMPLETION(wait);
+	struct ata_queued_cmd *qc;
+	unsigned long flags;
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	int rc, do_poll = 0;
+
+	DPRINTK("ATAPI TUR request sense\n");
+
+	memset(&sense_buffer, 0xff, sizeof(sense_buffer));
+
+	qc = ata_qc_new_init(ap, dev);
+	BUG_ON(qc == NULL);
+
+	ata_sg_init_one(qc, sense_buffer, sizeof(sense_buffer));
+	qc->dma_dir = DMA_FROM_DEVICE;
+
+	memset(&qc->cdb, 0, ap->cdb_len);
+	qc->cdb[0] = REQUEST_SENSE;
+	qc->cdb[4] = SCSI_SENSE_BUFFERSIZE;
+
+	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	qc->tf.command = ATA_CMD_PACKET;
+
+	qc->tf.protocol = ATA_PROT_ATAPI;
+	qc->tf.lbam = (8 * 1024) & 0xff;
+	qc->tf.lbah = (8 * 1024) >> 8;
+
+	qc->nbytes = SCSI_SENSE_BUFFERSIZE;
+
+	qc->waiting = &wait;
+	qc->complete_fn = ata_qc_complete_noop;
+
+	spin_lock_irqsave(&ap->host_set->lock, flags);
+	rc = ata_qc_issue(qc);
+	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+
+	if (!rc)
+		wait_for_completion(&wait);
+
+	switch (sense_buffer[12]) {	/* byte 12 == ASC */
+	case 0x29:
+	case 0x4:
+		do_poll = 1;
+		break;
+	}
+
+	DPRINTK("EXIT\n");
+
+	return do_poll;
+}
+
+static int ata_qc_complete_sense(struct ata_queued_cmd *qc, unsigned int err_mask)
+{
+	unsigned int *sense = qc->private_data;
+
+	qc->ap->ops->tf_read(qc->ap, &qc->tf);
+	if (qc->tf.command & ATA_ERR)
+		*sense = qc->tf.feature >> 4;
+	else
+		*sense = 0;
+	return 0;
+}
+
+static void atapi_dev_tur(struct ata_port *ap, struct ata_device *dev)
+{
+	DECLARE_COMPLETION(wait);
+	struct ata_queued_cmd *qc;
+	int rc, do_poll;
+	unsigned long flags;
+	unsigned int sense;
+	unsigned int retries = 15;
+
+	/* set up TUR taskfile */
+	DPRINTK("TUR\n");
+
+tur_retry:
+	qc = ata_qc_new_init(ap, dev);
+	BUG_ON(qc == NULL);
+
+	memset(&qc->cdb, 0, ap->cdb_len);
+	qc->cdb[0] = TEST_UNIT_READY;
+
+	qc->dma_dir = DMA_NONE;
+	qc->tf.command = ATA_CMD_PACKET;
+	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	qc->tf.protocol = ATA_PROT_ATAPI;
+	qc->tf.lbam = (8 * 1024) & 0xff;
+	qc->tf.lbah = (8 * 1024) >> 8;
+
+	sense = 0xffffffffU;
+	qc->private_data = &sense;
+
+	qc->waiting = &wait;
+	qc->complete_fn = ata_qc_complete_sense;
+
+	spin_lock_irqsave(&ap->host_set->lock, flags);
+	rc = ata_qc_issue(qc);
+	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+
+	if (rc) {
+tur_error:
+		printk(KERN_WARNING "ata%u: TUR failure, port disabled\n",
+			ap->id);
+		ata_port_disable(ap);
+		return;
+	}
+
+	wait_for_completion(&wait);
+
+	if (sense == 0)
+		return;
+	if (sense > 0xf)
+		goto tur_error;
+
+	do_poll = atapi_tur_request_sense(ap, dev);
+	if (do_poll == 0)
+		return;
+	if (do_poll < 0)
+		goto tur_error;
+
+	msleep(500);
+
+	retries--;
+	goto tur_retry;
+
+	DPRINTK("EXIT\n");
+}
+
 /**
  *	ata_sg_clean - Unmap DMA memory associated with command
  *	@qc: Command containing DMA memory to be released
