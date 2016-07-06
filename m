From: tom.ty89@gmail.com
Subject: [PATCH 1/2] libata-scsi: do not return designator for serial number
Date: Thu,  7 Jul 2016 06:12:12 +0800
Message-ID: <577d8249.a10c420a.da50c.ffff953e@mx.google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

SAT (as of sat4r05f.pdf) does not require this vendor specific
designator. Besides, we already have the Unit Serial Number VPD.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..9f478ad 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2210,14 +2210,6 @@ static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
 	rbuf[1] = 0x83;			/* this page code */
 	num = 4;
 
-	/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
-	rbuf[num + 0] = 2;
-	rbuf[num + 3] = ATA_ID_SERNO_LEN;
-	num += 4;
-	ata_id_string(args->id, (unsigned char *) rbuf + num,
-		      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
-	num += ATA_ID_SERNO_LEN;
-
 	/* SAT defined lu model and serial numbers descriptor */
 	/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
 	rbuf[num + 0] = 2;
-- 
2.9.0

