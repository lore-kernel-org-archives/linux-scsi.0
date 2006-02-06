From: brking@us.ibm.com
Subject: [patch 04/15] libata: Allow for ata_port without a libata owned scsi_host
Date: Mon, 06 Feb 2006 09:42:23 -0600
Message-ID: <200602061542.k16FgTlj015607@d03av03.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Prepare for future SAS changes where libata will have ata_ports
with no libata owned scsi_host.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/libata-core.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_scsi_host_owner drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_scsi_host_owner	2006-02-03 12:37:11.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-03 12:37:11.000000000 -0600
@@ -1208,6 +1208,21 @@ unsigned int ata_pio_need_iordy(const st
 	return 0;
 }
 
+static void ata_set_cdb_len(struct ata_port *ap, unsigned int cdb_len)
+{
+	ap->cdb_len = cdb_len;
+	if (ap->host)
+		ap->host->max_cmd_len = cdb_len;
+}
+
+static void ata_set_max_sectors(struct ata_port *ap, unsigned int max_sectors)
+{
+	if (ap->host) {
+		ap->host->max_sectors = ATA_MAX_SECTORS;
+		ap->host->hostt->max_sectors = ATA_MAX_SECTORS;
+	}
+}
+
 /**
  *	ata_dev_identify - obtain IDENTIFY x DEVICE page
  *	@ap: port on which device we wish to probe resides
@@ -1402,7 +1417,7 @@ retry:
 
 		}
 
-		ap->host->max_cmd_len = 16;
+		ata_set_cdb_len(ap, 16);
 	}
 
 	/* ATAPI-specific feature tests */
@@ -1415,8 +1430,8 @@ retry:
 			printk(KERN_WARNING "ata%u: unsupported CDB len\n", ap->id);
 			goto err_out_nosup;
 		}
-		ap->cdb_len = (unsigned int) rc;
-		ap->host->max_cmd_len = (unsigned char) ap->cdb_len;
+
+		ata_set_cdb_len(ap, rc);
 
 		/* print device info to dmesg */
 		printk(KERN_INFO "ata%u: dev %u ATAPI, max %s\n",
@@ -1456,8 +1471,7 @@ void ata_dev_config(struct ata_port *ap,
 		printk(KERN_INFO "ata%u(%u): applying bridge limits\n",
 			ap->id, ap->device->devno);
 		ap->udma_mask &= ATA_UDMA5;
-		ap->host->max_sectors = ATA_MAX_SECTORS;
-		ap->host->hostt->max_sectors = ATA_MAX_SECTORS;
+		ata_set_max_sectors(ap, ATA_MAX_SECTORS);
 		ap->device[i].flags |= ATA_DFLAG_LOCK_SECTORS;
 	}
 
_
