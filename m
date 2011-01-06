From: maksim.rayskiy@gmail.com
Subject: [RFC] Deferred disk spinup during system resume
Date: Thu, 6 Jan 2011 12:20:25 -0800
Message-ID: <1294345225-28407-1-git-send-email-maksim.rayskiy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1305 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1AFUVh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 15:21:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, tj@kernel.org

Tejun,

Thanks and sorry for late response, I was testing the patch on several platforms, 
including the ones with sata-based rootfs. The patch seems to be working fine for me. 
I only had to include ATA_EH_VERIFY into ATA_EH_PERDEV_MASK mask to avoid warning 
from ata_eh_clear_action().

Are you going to submit the patch to the mainline?

Maksim.

---
 drivers/ata/libata-eh.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |   21 ++++-----------------
 include/linux/libata.h    |    4 +++-
 3 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5e59050..3823bc6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3252,6 +3252,48 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 	return rc;
 }
 
+static int ata_eh_maybe_verify(struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+	int rc = 0;
+
+	ata_eh_about_to_do(link, dev, ATA_EH_VERIFY);
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
+	/* don't retry VERIFY */
+	ata_eh_done(link, dev, ATA_EH_VERIFY);
+
+	return rc;
+}
+
 /**
  *	ata_eh_set_lpm - configure SATA interface power management
  *	@link: link to configure power management
@@ -3738,6 +3780,9 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			rc = ata_eh_maybe_retry_flush(dev);
 			if (rc)
 				goto rest_fail;
+			rc = ata_eh_maybe_verify(dev);
+			if (rc)
+				goto rest_fail;
 		}
 
 	config_lpm:
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..ae8d9ca 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1276,6 +1276,7 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth,
  */
 static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 {
+	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->tf;
 	const u8 *cdb = scmd->cmnd;
@@ -1294,23 +1295,9 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		goto invalid_fld;       /* power conditions not supported */
 
 	if (cdb[4] & 0x1) {
-		tf->nsect = 1;	/* 1 sector, lba=0 */
-
-		if (qc->dev->flags & ATA_DFLAG_LBA) {
-			tf->flags |= ATA_TFLAG_LBA;
-
-			tf->lbah = 0x0;
-			tf->lbam = 0x0;
-			tf->lbal = 0x0;
-			tf->device |= ATA_LBA;
-		} else {
-			/* CHS */
-			tf->lbal = 0x1; /* sect */
-			tf->lbam = 0x0; /* cyl low */
-			tf->lbah = 0x0; /* cyl high */
-		}
-
-		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
+		dev->link->eh_info.dev_action[dev->devno] |= ATA_EH_VERIFY;
+		ata_port_schedule_eh(dev->link->ap);
+		goto skip;
 	} else {
 		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
 		 * or S5) causing some drives to spin up and down again.
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d947b12..5d91fd0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -326,9 +326,11 @@ enum {
 	ATA_EH_HARDRESET	= (1 << 2), /* meaningful only in ->prereset */
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
+	ATA_EH_VERIFY		= (1 << 4), /* used to force spin up */
 	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
 
-	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
+	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK |
+				  ATA_EH_VERIFY,
 	ATA_EH_ALL_ACTIONS	= ATA_EH_REVALIDATE | ATA_EH_RESET |
 				  ATA_EH_ENABLE_LINK,
 
-- 
1.7.0.4


