Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF268C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Dec 2021 02:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242551AbhLaCQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Dec 2021 21:16:11 -0500
Received: from smtp.infotech.no ([82.134.31.41]:46075 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhLaCQK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Dec 2021 21:16:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2BF082041B2;
        Fri, 31 Dec 2021 03:08:44 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EgW5AtFTXTfI; Fri, 31 Dec 2021 03:08:40 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        by smtp.infotech.no (Postfix) with ESMTPA id 4D15C2041C0;
        Fri, 31 Dec 2021 03:08:36 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Subject: [PATCH 5/9] scsi_debug: divide power on reset unit attention
Date:   Thu, 30 Dec 2021 21:08:25 -0500
Message-Id: <20211231020829.29147-6-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211231020829.29147-1-dgilbert@interlog.com>
References: <20211231020829.29147-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To distinguish between resets sent by the SCSI mid-level error
handling and newly introduced devices (LUs), this Unit Attention:
   power on, reset, or bus reset occurred [0x29,0x0]
has been subdivided into that UA for the reset case and this new UA:
   power on occurred [0x29,0x1]
for the new device (LU) case. This makes debug a little easier to
follow when it is turned on (e.g. 'echo 0x1 > opts').

Bump driver version number.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0fe3fe0be8d6..c2c82aa5b98f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7,7 +7,7 @@
  *  anything out of the ordinary is seen.
  * ^^^^^^^^^^^^^^^^^^^^^^^ Original ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  *
- * Copyright (C) 2001 - 2020 Douglas Gilbert
+ * Copyright (C) 2001 - 2021 Douglas Gilbert
  *
  *  For documentation see http://sg.danny.cz/sg/scsi_debug.html
  */
@@ -61,8 +61,8 @@
 #include "scsi_logging.h"
 
 /* make sure inq_product_rev string corresponds to this version */
-#define SDEBUG_VERSION "0190"	/* format to fit INQUIRY revision field */
-static const char *sdebug_version_date = "20200710";
+#define SDEBUG_VERSION "0191"	/* format to fit INQUIRY revision field */
+static const char *sdebug_version_date = "20210520";
 
 #define MY_NAME "scsi_debug"
 
@@ -84,6 +84,7 @@ static const char *sdebug_version_date = "20200710";
 #define INSUFF_RES_ASC 0x55
 #define INSUFF_RES_ASCQ 0x3
 #define POWER_ON_RESET_ASCQ 0x0
+#define POWER_ON_OCCURRED_ASCQ 0x1
 #define BUS_RESET_ASCQ 0x2	/* scsi bus reset occurred */
 #define MODE_CHANGED_ASCQ 0x1	/* mode parameters changed */
 #define CAPACITY_CHANGED_ASCQ 0x9
@@ -197,13 +198,14 @@ static const char *sdebug_version_date = "20200710";
  * priority. The UA numbers should be a sequence starting from 0 with
  * SDEBUG_NUM_UAS being 1 higher than the highest numbered UA. */
 #define SDEBUG_UA_POR 0		/* Power on, reset, or bus device reset */
-#define SDEBUG_UA_BUS_RESET 1
-#define SDEBUG_UA_MODE_CHANGED 2
-#define SDEBUG_UA_CAPACITY_CHANGED 3
-#define SDEBUG_UA_LUNS_CHANGED 4
-#define SDEBUG_UA_MICROCODE_CHANGED 5	/* simulate firmware change */
-#define SDEBUG_UA_MICROCODE_CHANGED_WO_RESET 6
-#define SDEBUG_NUM_UAS 7
+#define SDEBUG_UA_POOCCUR 1	/* Power on occurred */
+#define SDEBUG_UA_BUS_RESET 2
+#define SDEBUG_UA_MODE_CHANGED 3
+#define SDEBUG_UA_CAPACITY_CHANGED 4
+#define SDEBUG_UA_LUNS_CHANGED 5
+#define SDEBUG_UA_MICROCODE_CHANGED 6	/* simulate firmware change */
+#define SDEBUG_UA_MICROCODE_CHANGED_WO_RESET 7
+#define SDEBUG_NUM_UAS 8
 
 /* when 1==SDEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
  * sector on read commands: */
@@ -1086,6 +1088,12 @@ static int make_ua(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			if (sdebug_verbose)
 				cp = "power on reset";
 			break;
+		case SDEBUG_UA_POOCCUR:
+			mk_sense_buffer(scp, UNIT_ATTENTION, UA_RESET_ASC,
+					POWER_ON_OCCURRED_ASCQ);
+			if (sdebug_verbose)
+				cp = "power on occurred";
+			break;
 		case SDEBUG_UA_BUS_RESET:
 			mk_sense_buffer(scp, UNIT_ATTENTION, UA_RESET_ASC,
 					BUS_RESET_ASCQ);
@@ -5007,7 +5015,7 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
 	open_devip->lun = sdev->lun;
 	open_devip->sdbg_host = sdbg_host;
 	atomic_set(&open_devip->num_in_q, 0);
-	set_bit(SDEBUG_UA_POR, open_devip->uas_bm);
+	set_bit(SDEBUG_UA_POOCCUR, open_devip->uas_bm);
 	open_devip->used = true;
 	return open_devip;
 }
-- 
2.25.1

