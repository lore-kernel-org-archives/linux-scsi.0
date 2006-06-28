From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/4] libata: Conditionally set host->max_cmd_len
Date: Wed, 28 Jun 2006 08:30:31 -0500
Message-ID: <200606281330.k5SDUWAM024097@d03av03.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


In preparation for SAS attached SATA devices, which will
not have a libata scsi_host, only setup host->max_cmd_len
if ap->host exists.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_cdb_len drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_cdb_len	2006-06-27 16:01:47.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-27 16:01:47.000000000 -0500
@@ -1326,6 +1326,19 @@ static void ata_dev_config_ncq(struct at
 		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
+static void ata_set_port_max_cmd_len(struct ata_port *ap)
+{
+	int i;
+
+	if (ap->host) {
+		ap->host->max_cmd_len = 0;
+		for (i = 0; i < ATA_MAX_DEVICES; i++)
+			ap->host->max_cmd_len = max_t(unsigned int,
+						      ap->host->max_cmd_len,
+						      ap->device[i].cdb_len);
+	}
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -1345,7 +1358,7 @@ int ata_dev_configure(struct ata_device 
 	struct ata_port *ap = dev->ap;
 	const u16 *id = dev->id;
 	unsigned int xfer_mask;
-	int i, rc;
+	int rc;
 
 	if (!ata_dev_enabled(dev) && ata_msg_info(ap)) {
 		ata_dev_printk(dev, KERN_INFO,
@@ -1475,11 +1488,7 @@ int ata_dev_configure(struct ata_device 
 				       cdb_intr_string);
 	}
 
-	ap->host->max_cmd_len = 0;
-	for (i = 0; i < ATA_MAX_DEVICES; i++)
-		ap->host->max_cmd_len = max_t(unsigned int,
-					      ap->host->max_cmd_len,
-					      ap->device[i].cdb_len);
+	ata_set_port_max_cmd_len(ap);
 
 	/* limit bridge transfers to udma5, 200 sectors */
 	if (ata_dev_knobble(dev)) {
_
