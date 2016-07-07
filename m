From: tom.ty89@gmail.com
Subject: [PATCH 1/2] libata-scsi: fix SET FEATURES "filtering" for ata_msense_caching()
Date: Thu,  7 Jul 2016 09:43:33 +0800
Message-ID: <577db3cc.0a6a620a.c3774.1502@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34379 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbcGGBnm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 21:43:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Without this fix, the DRA bit of the caching mode page would not
be updated when the read look-ahead feature is toggled (e.g. with
`smartctl --set`), but will only be until, for example, the write
cache feature is touched.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6be7770..077daf0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5127,7 +5127,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		switch (qc->tf.command) {
 		case ATA_CMD_SET_FEATURES:
 			if (qc->tf.feature != SETFEATURES_WC_ON &&
-			    qc->tf.feature != SETFEATURES_WC_OFF)
+			    qc->tf.feature != SETFEATURES_WC_OFF &&
+			    qc->tf.feature != SETFEATURES_RA_ON &&
+			    qc->tf.feature != SETFEATURES_RA_OFF)
 				break;
 			/* fall through */
 		case ATA_CMD_INIT_DEV_PARAMS: /* CHS translation changed */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 99346be..2d68793 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -409,6 +409,9 @@ enum {
 	SETFEATURES_WC_ON	= 0x02, /* Enable write cache */
 	SETFEATURES_WC_OFF	= 0x82, /* Disable write cache */
 
+	SETFEATURES_RA_ON	= 0xaa, /* Enable read look-ahead */
+	SETFEATURES_RA_OFF	= 0x55, /* Disable read look-ahead */
+
 	/* Enable/Disable Automatic Acoustic Management */
 	SETFEATURES_AAM_ON	= 0x42,
 	SETFEATURES_AAM_OFF	= 0xC2,
-- 
2.9.0

