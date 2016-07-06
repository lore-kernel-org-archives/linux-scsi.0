From: tom.ty89@gmail.com
Subject: [PATCH 2/2] libata-scsi: do not return t10 designator if drive has WWN
Date: Thu,  7 Jul 2016 06:12:13 +0800
Message-ID: <577d824d.a10c420a.da50c.ffff9544@mx.google.com>
References: <20160706221213.1928-1-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35410 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbcGFWMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 18:12:47 -0400
In-Reply-To: <20160706221213.1928-1-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

SAT (as of sat4r05f.pdf) only requires the t10 designator if the
drive does not support/have WWN. Besides, we already have the ATA
information VPD.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9f478ad..84b3d42 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2210,21 +2210,6 @@ static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
 	rbuf[1] = 0x83;			/* this page code */
 	num = 4;
 
-	/* SAT defined lu model and serial numbers descriptor */
-	/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
-	rbuf[num + 0] = 2;
-	rbuf[num + 1] = 1;
-	rbuf[num + 3] = sat_model_serial_desc_len;
-	num += 4;
-	memcpy(rbuf + num, "ATA     ", 8);
-	num += 8;
-	ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_PROD,
-		      ATA_ID_PROD_LEN);
-	num += ATA_ID_PROD_LEN;
-	ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_SERNO,
-		      ATA_ID_SERNO_LEN);
-	num += ATA_ID_SERNO_LEN;
-
 	if (ata_id_has_wwn(args->id)) {
 		/* SAT defined lu world wide name */
 		/* piv=0, assoc=lu, code_set=binary, designator=NAA */
@@ -2236,6 +2221,23 @@ static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
 			      ATA_ID_WWN, ATA_ID_WWN_LEN);
 		num += ATA_ID_WWN_LEN;
 	}
+	else {
+		/* SAT defined lu model and serial numbers descriptor */
+		/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
+		rbuf[num + 0] = 2;
+		rbuf[num + 1] = 1;
+		rbuf[num + 3] = sat_model_serial_desc_len;
+		num += 4;
+		memcpy(rbuf + num, "ATA     ", 8);
+		num += 8;
+		ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_PROD,
+			      ATA_ID_PROD_LEN);
+		num += ATA_ID_PROD_LEN;
+		ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_SERNO,
+			      ATA_ID_SERNO_LEN);
+		num += ATA_ID_SERNO_LEN;
+	}
+
 	rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */
 	return 0;
 }
-- 
2.9.0

