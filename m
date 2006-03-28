From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/2] libata: Use scsi_device max_cmd_len
Date: Tue, 28 Mar 2006 16:17:26 -0600
Message-ID: <200603282217.k2SMHQBu002257@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:31196 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932441AbWC1WR2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 17:17:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Use the newly added max_cmd_len in the scsi_device
struct instead of the field by the same name in
the scsi_host struct. This allows for better
granularity of control of the max allowed command
length and simplifies supporting libata controlled
SATA devices attached to SAS HBAs.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   10 ++--------
 libata-dev-bjking1/drivers/scsi/libata-scsi.c |    1 +
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_sd_cdb_len drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_sd_cdb_len	2006-03-28 16:09:14.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-03-28 16:09:14.000000000 -0600
@@ -1208,7 +1208,7 @@ static int ata_dev_configure(struct ata_
 {
 	const u16 *id = dev->id;
 	unsigned int xfer_mask;
-	int i, rc;
+	int rc;
 
 	if (!ata_dev_present(dev)) {
 		DPRINTK("ENTER/EXIT (host %u, dev %u) -- nodev\n",
@@ -1311,12 +1311,6 @@ static int ata_dev_configure(struct ata_
 			       ap->id, dev->devno, ata_mode_string(xfer_mask));
 	}
 
-	ap->host->max_cmd_len = 0;
-	for (i = 0; i < ATA_MAX_DEVICES; i++)
-		ap->host->max_cmd_len = max_t(unsigned int,
-					      ap->host->max_cmd_len,
-					      ap->device[i].cdb_len);
-
 	/* limit bridge transfers to udma5, 200 sectors */
 	if (ata_dev_knobble(ap, dev)) {
 		if (print_info)
@@ -4396,7 +4390,7 @@ static void ata_host_init(struct ata_por
 	host->max_lun = 1;
 	host->max_channel = 1;
 	host->unique_id = ata_unique_id++;
-	host->max_cmd_len = 12;
+	host->max_cmd_len = ATAPI_CDB_LEN;
 
 	ap->flags = ATA_FLAG_PORT_DISABLED;
 	ap->id = host->unique_id;
diff -puN drivers/scsi/libata-scsi.c~libata_sd_cdb_len drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_sd_cdb_len	2006-03-28 16:09:14.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-03-28 16:09:14.000000000 -0600
@@ -680,6 +680,7 @@ static void ata_scsi_dev_config(struct s
 		max_sectors = dev->max_sectors;
 
 	blk_queue_max_sectors(sdev->request_queue, max_sectors);
+	sdev->max_cmd_len = dev->cdb_len;
 
 	/*
 	 * SATA DMA transfers must be multiples of 4 byte, so
_
