From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 03/12] scsi: sd_zbc: Move ZBC declarations to scsi_proto.h
Date: Fri,  8 Sep 2017 01:16:31 +0900
Message-ID: <20170907161640.30465-4-damien.lemoal@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:6565 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932095AbdIGQSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2017 12:18:00 -0400
In-Reply-To: <20170907161640.30465-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Move standard macro definitions for the zone types and zone conditions
to scsi_proto.h together with the definitions related to the
REPORT ZONES command.

While at it, define all values in the enums to be clear.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@wdc.com>
---
 drivers/scsi/sd_zbc.c     | 18 ------------------
 include/scsi/scsi_proto.h | 45 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 8aa54779aac1..d445a57f99bd 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -37,24 +37,6 @@
 #include "sd.h"
 #include "scsi_priv.h"
 
-enum zbc_zone_type {
-	ZBC_ZONE_TYPE_CONV = 0x1,
-	ZBC_ZONE_TYPE_SEQWRITE_REQ,
-	ZBC_ZONE_TYPE_SEQWRITE_PREF,
-	ZBC_ZONE_TYPE_RESERVED,
-};
-
-enum zbc_zone_cond {
-	ZBC_ZONE_COND_NO_WP,
-	ZBC_ZONE_COND_EMPTY,
-	ZBC_ZONE_COND_IMP_OPEN,
-	ZBC_ZONE_COND_EXP_OPEN,
-	ZBC_ZONE_COND_CLOSED,
-	ZBC_ZONE_COND_READONLY = 0xd,
-	ZBC_ZONE_COND_FULL,
-	ZBC_ZONE_COND_OFFLINE,
-};
-
 /**
  * Convert a zone descriptor to a zone struct.
  */
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 8c285d9a06d8..39130a9c05bf 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -301,19 +301,42 @@ struct scsi_lun {
 
 /* Reporting options for REPORT ZONES */
 enum zbc_zone_reporting_options {
-	ZBC_ZONE_REPORTING_OPTION_ALL = 0,
-	ZBC_ZONE_REPORTING_OPTION_EMPTY,
-	ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN,
-	ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN,
-	ZBC_ZONE_REPORTING_OPTION_CLOSED,
-	ZBC_ZONE_REPORTING_OPTION_FULL,
-	ZBC_ZONE_REPORTING_OPTION_READONLY,
-	ZBC_ZONE_REPORTING_OPTION_OFFLINE,
-	ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP = 0x10,
-	ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE,
-	ZBC_ZONE_REPORTING_OPTION_NON_WP = 0x3f,
+	ZBC_ZONE_REPORTING_OPTION_ALL		= 0x00,
+	ZBC_ZONE_REPORTING_OPTION_EMPTY		= 0x01,
+	ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN	= 0x02,
+	ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN	= 0x03,
+	ZBC_ZONE_REPORTING_OPTION_CLOSED	= 0x04,
+	ZBC_ZONE_REPORTING_OPTION_FULL		= 0x05,
+	ZBC_ZONE_REPORTING_OPTION_READONLY	= 0x06,
+	ZBC_ZONE_REPORTING_OPTION_OFFLINE	= 0x07,
+	/* 0x08 to 0x0f are reserved */
+	ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP	= 0x10,
+	ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE	= 0x11,
+	/* 0x12 to 0x3e are reserved */
+	ZBC_ZONE_REPORTING_OPTION_NON_WP	= 0x3f,
 };
 
 #define ZBC_REPORT_ZONE_PARTIAL 0x80
 
+/* Zone types of REPORT ZONES zone descriptors */
+enum zbc_zone_type {
+	ZBC_ZONE_TYPE_CONV		= 0x1,
+	ZBC_ZONE_TYPE_SEQWRITE_REQ	= 0x2,
+	ZBC_ZONE_TYPE_SEQWRITE_PREF	= 0x3,
+	/* 0x4 to 0xf are reserved */
+};
+
+/* Zone conditions of REPORT ZONES zone descriptors */
+enum zbc_zone_cond {
+	ZBC_ZONE_COND_NO_WP		= 0x0,
+	ZBC_ZONE_COND_EMPTY		= 0x1,
+	ZBC_ZONE_COND_IMP_OPEN		= 0x2,
+	ZBC_ZONE_COND_EXP_OPEN		= 0x3,
+	ZBC_ZONE_COND_CLOSED		= 0x4,
+	/* 0x5 to 0xc are reserved */
+	ZBC_ZONE_COND_READONLY		= 0xd,
+	ZBC_ZONE_COND_FULL		= 0xe,
+	ZBC_ZONE_COND_OFFLINE		= 0xf,
+};
+
 #endif /* _SCSI_PROTO_H_ */
-- 
2.13.5
