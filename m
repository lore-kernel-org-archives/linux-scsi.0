From: maksim.rayskiy@gmail.com
Subject: [RFC/PATCH] Deferred disk spinup during system resume
Date: Tue, 11 Jan 2011 17:24:17 -0800
Message-ID: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1235 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1ALBZ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2011 20:25:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jgarzik@pobox.com, tj@kernel.org
Cc: Maksim Rayskiy <maksim.rayskiy@gmail.com>

To speed up time-to-full-power transition do not execute spinup request synchronously.
Schedule EH work and complete the request immediately.

Signed-off-by: Maksim Rayskiy <maksim.rayskiy@gmail.com>
---
 drivers/ata/libata-core.c |    7 +++++++
 drivers/ata/libata-eh.c   |   40 ++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |    1 +
 include/linux/libata.h    |    1 +
 4 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7f77c67..6ed42d0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4978,6 +4978,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	struct ata_link *link = qc->dev->link;
 	u8 prot = qc->tf.protocol;
 
+	if (unlikely(qc->flags & ATA_QCFLAG_VERIFY)) {
+		ata_port_schedule_eh(ap);
+		qc->scsidone(qc->scsicmd);
+		ata_qc_free(qc);
+		return;
+	}
+
 	/* Make sure only one non-NCQ command is outstanding.  The
 	 * check is skipped for old EH because it reuses active qc to
 	 * request ATAPI sense.
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5e59050..0e6f6b1 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3252,6 +3252,43 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 	return rc;
 }
 
+static int ata_eh_maybe_verify(struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+	int rc = 0;
+
+	ata_tf_init(dev, &tf);
+
+	if (dev->flags & ATA_DFLAG_LBA) {
+		tf.flags |= ATA_TFLAG_LBA;
+
+		tf.lbah = 0x0;
+		tf.lbam = 0x0;
+		tf.lbal = 0x0;
+		tf.device |= ATA_LBA;
+	} else {
+		/* CHS */
+		tf.lbal = 0x1; /* sect */
+		tf.lbam = 0x0; /* cyl low */
+		tf.lbah = 0x0; /* cyl high */
+	}
+
+	tf.command = ATA_CMD_VERIFY;	/* READ VERIFY */
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_LBA48 | ATA_TFLAG_DEVICE;
+	tf.protocol = ATA_PROT_NODATA;
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (err_mask) {
+		ata_dev_printk(dev, KERN_WARNING,
+			       "READ_VERIFY failed Emask 0x%x\n", err_mask);
+		rc = -EIO;
+	}
+
+	return rc;
+}
+
 /**
  *	ata_eh_set_lpm - configure SATA interface power management
  *	@link: link to configure power management
@@ -3738,6 +3775,9 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			rc = ata_eh_maybe_retry_flush(dev);
 			if (rc)
 				goto rest_fail;
+			rc = ata_eh_maybe_verify(dev);
+			if (rc)
+				goto rest_fail;
 		}
 
 	config_lpm:
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..fb7d5b8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1311,6 +1311,7 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		}
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
+		qc->flags |= ATA_QCFLAG_VERIFY;
 	} else {
 		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
 		 * or S5) causing some drives to spin up and down again.
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d947b12..1bb2d55 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -234,6 +234,7 @@ enum {
 	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
 	ATA_QCFLAG_QUIET	= (1 << 6), /* don't report device error */
 	ATA_QCFLAG_RETRY	= (1 << 7), /* retry after failure */
+	ATA_QCFLAG_VERIFY	= (1 << 8), /* used to force spin up */
 
 	ATA_QCFLAG_FAILED	= (1 << 16), /* cmd failed and is owned by EH */
 	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
-- 
1.7.0.4


