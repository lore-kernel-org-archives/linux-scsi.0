From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/6] libata: Add ata_scsi_dev_disabled
Date: Mon, 12 Jun 2006 14:54:17 -0500
Message-ID: <200606121954.k5CJsJxv027844@d01av03.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Separate out parts of ata_scsi_find_dev to be reused in
future SAS/SATA patches.

Acked-by: Jeff Garzik <jgarzik@pobox.com>

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-scsi.c |   41 +++++++++++++++++++-------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_scsi_enabled drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_scsi_enabled	2006-06-12 14:40:16.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-06-12 14:40:16.000000000 -0500
@@ -2374,6 +2374,36 @@ static struct ata_device * __ata_scsi_fi
 }
 
 /**
+ *	ata_scsi_dev_enabled - determine if device is enabled
+ *	@dev: ATA device
+ *
+ *	Determine if commands should be sent to the specified device.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ *
+ *	RETURNS:
+ *	0 if commands are not allowed / 1 if commands are allowed
+ */
+
+static int ata_scsi_dev_enabled(struct ata_device *dev)
+{
+	if (unlikely(!ata_dev_enabled(dev)))
+		return 0;
+
+	if (!atapi_enabled || (dev->ap->flags & ATA_FLAG_NO_ATAPI)) {
+		if (unlikely(dev->class == ATA_DEV_ATAPI)) {
+			ata_dev_printk(dev, KERN_WARNING,
+				       "WARNING: ATAPI is %s, device ignored.\n",
+				       atapi_enabled ? "not supported with this driver" : "disabled");
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+/**
  *	ata_scsi_find_dev - lookup ata_device from scsi_cmnd
  *	@ap: ATA port to which the device is attached
  *	@scsidev: SCSI device from which we derive the ATA device
@@ -2394,18 +2424,9 @@ ata_scsi_find_dev(struct ata_port *ap, c
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
 
-	if (unlikely(!dev || !ata_dev_enabled(dev)))
+	if (unlikely(!dev || !ata_scsi_dev_enabled(dev)))
 		return NULL;
 
-	if (!atapi_enabled || (ap->flags & ATA_FLAG_NO_ATAPI)) {
-		if (unlikely(dev->class == ATA_DEV_ATAPI)) {
-			ata_dev_printk(dev, KERN_WARNING,
-				"WARNING: ATAPI is %s, device ignored.\n",
-				atapi_enabled ? "not supported with this driver" : "disabled");
-			return NULL;
-		}
-	}
-
 	return dev;
 }
 
_
