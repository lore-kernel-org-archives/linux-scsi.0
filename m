From: brking@us.ibm.com
Subject: [patch 06/15] libata: ata_scsi_queuecmd cleanup
Date: Mon, 06 Feb 2006 09:42:25 -0600
Message-ID: <200602061542.k16FgV7d025207@d03av04.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Encapsulate part of ata_scsi_queuecmd so that it can be
reused by future SAS patches.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/libata-scsi.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_scsi_queuecmd drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_scsi_queuecmd	2006-02-03 12:37:17.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-02-03 12:37:17.000000000 -0600
@@ -2509,6 +2509,21 @@ static inline void ata_scsi_dump_cdb(str
 #endif
 }
 
+static void __ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
+				struct ata_port *ap, struct ata_device *dev)
+{
+	if (dev->class == ATA_DEV_ATA) {
+		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
+							      cmd->cmnd[0]);
+
+		if (xlat_func)
+			ata_scsi_translate(ap, dev, cmd, done, xlat_func);
+		else
+			ata_scsi_simulate(ap, dev, cmd, done);
+	} else
+		ata_scsi_translate(ap, dev, cmd, done, atapi_xlat);
+}
+
 /**
  *	ata_scsi_queuecmd - Issue SCSI cdb to libata-managed device
  *	@cmd: SCSI command to be sent
@@ -2549,17 +2564,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 		goto out_unlock;
 	}
 
-	if (dev->class == ATA_DEV_ATA) {
-		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
-							      cmd->cmnd[0]);
-
-		if (xlat_func)
-			ata_scsi_translate(ap, dev, cmd, done, xlat_func);
-		else
-			ata_scsi_simulate(ap, dev, cmd, done);
-	} else
-		ata_scsi_translate(ap, dev, cmd, done, atapi_xlat);
-
+	__ata_scsi_queuecmd(cmd, done, ap, dev);
 out_unlock:
 	spin_unlock(ap->lock);
 	spin_lock(shost->host_lock);
_
