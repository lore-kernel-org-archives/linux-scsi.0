From: Brian King <brking@us.ibm.com>
Subject: [PATCH 4/6] libata: Conditionally set host->max_cmd_len
Date: Mon, 12 Jun 2006 14:54:33 -0500
Message-ID: <200606121954.k5CJsXjL011968@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:157 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S932170AbWFLTyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 15:54:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


In preparation for SAS attached SATA devices, which will
not have a libata scsi_host, only setup host->max_cmd_len
if ap->host exists.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_cdb_len drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_cdb_len	2006-06-12 14:11:11.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-12 14:11:11.000000000 -0500
@@ -1424,11 +1424,13 @@ int ata_dev_configure(struct ata_device 
 				       cdb_intr_string);
 	}
 
-	ap->host->max_cmd_len = 0;
-	for (i = 0; i < ATA_MAX_DEVICES; i++)
-		ap->host->max_cmd_len = max_t(unsigned int,
-					      ap->host->max_cmd_len,
-					      ap->device[i].cdb_len);
+	if (ap->host) {
+		ap->host->max_cmd_len = 0;
+		for (i = 0; i < ATA_MAX_DEVICES; i++)
+			ap->host->max_cmd_len = max_t(unsigned int,
+						      ap->host->max_cmd_len,
+						      ap->device[i].cdb_len);
+	}
 
 	/* limit bridge transfers to udma5, 200 sectors */
 	if (ata_dev_knobble(dev)) {
_
