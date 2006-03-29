From: Brian King <brking@us.ibm.com>
Subject: [PATCH 03/10] libata: Conditionally set host->max_cmd_len
Date: Wed, 29 Mar 2006 08:38:05 -0600
Message-ID: <200603291438.k2TEc5rh022074@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:25766 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751123AbWC2OiH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 09:38:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, brking@us.ibm.com


In preparation for SAS attached SATA devices, which will
not have a libata scsi_host, only setup host->max_cmd_len
if ap->host exists.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/libata-core.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_cdb_len drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_cdb_len	2006-03-24 13:09:11.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-03-24 13:09:11.000000000 -0600
@@ -1311,11 +1311,13 @@ static int ata_dev_configure(struct ata_
 			       ap->id, dev->devno, ata_mode_string(xfer_mask));
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
 	if (ata_dev_knobble(ap, dev)) {
_
