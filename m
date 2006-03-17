From: Brian King <brking@us.ibm.com>
Subject: [PATCH 04/15] libata: ata_scsi_queuecmd cleanup
Date: Fri, 17 Mar 2006 17:04:21 -0600
Message-ID: <200603172304.k2HN4LDp014215@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:12169 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S932848AbWCQXEX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 18:04:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Encapsulate part of ata_scsi_queuecmd so that it can be
reused by future SAS patches.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-scsi.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_scsi_queuecmd drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_scsi_queuecmd	2006-03-14 13:55:38.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-03-14 13:55:38.000000000 -0600
@@ -2565,6 +2565,21 @@ static inline void ata_scsi_dump_cdb(str
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
@@ -2605,16 +2620,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
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
+	__ata_scsi_queuecmd(cmd, done, ap, dev);
 
 out_unlock:
 	spin_unlock(&ap->host_set->lock);
_
