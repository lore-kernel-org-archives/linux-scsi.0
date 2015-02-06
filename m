From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 21/36] aha1542: Simplify aha1542_biosparam
Date: Fri,  6 Feb 2015 23:11:42 +0100
Message-ID: <1423260717-15944-22-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56952 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbbBFWPg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:36 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8G-0006fF-EU
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:12 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Simplify aha1542_biosparam, use sector_div, remove unused BIOS_TRANSLATION_1632.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index d151913..1615865 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -78,7 +78,6 @@ static int dma_speed[MAXBOARDS] = { -1, -1, -1, -1 };
 module_param_array(dma_speed, int, NULL, 0);
 MODULE_PARM_DESC(dma_speed, "DMA speed [MB/s] (5,6,7,8,10, default=-1 [by jumper])");
 
-#define BIOS_TRANSLATION_1632 0	/* Used by some old 1542A boards */
 #define BIOS_TRANSLATION_6432 1	/* Default case these days */
 #define BIOS_TRANSLATION_25563 2	/* Big disk case */
 
@@ -1048,24 +1047,20 @@ static int aha1542_host_reset(Scsi_Cmnd *SCpnt)
 }
 
 static int aha1542_biosparam(struct scsi_device *sdev,
-		struct block_device *bdev, sector_t capacity, int *ip)
+		struct block_device *bdev, sector_t capacity, int geom[])
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(sdev->host);
-	int translation_algorithm;
-	int size = capacity;
 
-	translation_algorithm = aha1542->bios_translation;
-
-	if ((size >> 11) > 1024 && translation_algorithm == BIOS_TRANSLATION_25563) {
+	if (capacity >= 0x200000 &&
+			aha1542->bios_translation == BIOS_TRANSLATION_25563) {
 		/* Please verify that this is the same as what DOS returns */
-		ip[0] = 255;
-		ip[1] = 63;
-		ip[2] = size / 255 / 63;
+		geom[0] = 255;	/* heads */
+		geom[1] = 63;	/* sectors */
 	} else {
-		ip[0] = 64;
-		ip[1] = 32;
-		ip[2] = size >> 11;
+		geom[0] = 64;	/* heads */
+		geom[1] = 32;	/* sectors */
 	}
+	geom[2] = sector_div(capacity, geom[0] * geom[1]);	/* cylinders */
 
 	return 0;
 }
-- 
Ondrej Zary

