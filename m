From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 09/13] scsi: fix up SCSI_MLQUEUE defintions and add driver, device and transport ones
Date: Mon, 22 Sep 2008 09:33:38 -0700
Message-ID: <1222101222-15079-10-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34899 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYIVQeH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:07 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY6eh005997
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:06 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY6sF067622
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY4cX005232
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:06 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This adds new driver, device and transport errors and fixes up
the SCSI_MLQUEUE definitions so there not collisions.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   22 +++++++++++-----------
 drivers/scsi/scsi_lib.c   |   26 ++++++++++++++++++++------
 include/scsi/scsi.h       |   39 ++++++++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9a539dd..c0254ec 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -246,7 +246,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		return SCSI_MLQUEUE_DIS_FAIL;	/* no valid sense data */
 
 	if (scsi_sense_is_deferred(&sshdr))
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DEV_RETRY;
 
 	if (sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh &&
 			sdev->scsi_dh_data->scsi_dh->check_sense) {
@@ -288,7 +288,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x10) /* DIF */
 			return SCSI_MLQUEUE_DIS_FINISH;
 
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DEV_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
 		/*
@@ -299,14 +299,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		 */
 		if (scmd->device->expecting_cc_ua) {
 			scmd->device->expecting_cc_ua = 0;
-			return SCSI_MLQUEUE_DIS_RETRY;
+			return SCSI_MLQUEUE_DIS_DEV_RETRY;
 		}
 		/*
 		 * if the device is in the process of becoming ready, we 
 		 * should retry.
 		 */
 		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
-			return SCSI_MLQUEUE_DIS_RETRY;
+			return SCSI_MLQUEUE_DIS_DEV_RETRY;
 		/*
 		 * if the device is not started, we need to wake
 		 * the error handler to start the motor
@@ -328,11 +328,11 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
 			return SCSI_MLQUEUE_DIS_FINISH;
 		}
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DEV_RETRY;
 
 	case HARDWARE_ERROR:
 		if (scmd->device->retry_hwerror)
-			return SCSI_MLQUEUE_DIS_RETRY;
+			return SCSI_MLQUEUE_DIS_DEV_RETRY;
 		else
 			return SCSI_MLQUEUE_DIS_FINISH;
 
@@ -1316,7 +1316,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DRV_RETRY;
 	case DID_IMM_RETRY:
 		return SCSI_MLQUEUE_IMM_RETRY;
 	case DID_REQUEUE:
@@ -1343,11 +1343,11 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 			 * lower down
 			 */
 			break;
-		/* fallthrough */
-
-	case DID_BUS_BUSY:
+		/* fall through */
 	case DID_PARITY:
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DEV_RETRY;
+	case DID_BUS_BUSY:
+		return SCSI_MLQUEUE_DIS_XPT_RETRY;
 	case DID_TIME_OUT:
 		/*
 		 * when we scan the bus, we get timeout messages for
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 34a50e0..39c5929 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -161,14 +161,28 @@ int scsi_attempt_requeue_command(struct scsi_cmnd *cmd, int reason)
 		break;
 	}
 
-	if (!scsi_ign_failfast(reason)) {
-		if (blk_noretry_request(cmd->request)) {
-			set_driver_byte(cmd, DRIVER_TIMEOUT);
-			scsi_finish_command(cmd);
-			return 0;
-		}
+	if (!scsi_ign_failfast(reason) && scsi_disposition_retry(reason)) {
+		if (reason & SCSI_MLQUEUE_DIS_XPT_RETRY) {
+			if (!blk_failfast_transport(cmd->request))
+				goto check_retries;
+		} else if (reason & SCSI_MLQUEUE_DIS_DEV_RETRY) {
+			if (!blk_failfast_dev(cmd->request))
+				goto check_retries;
+		} else if (reason & SCSI_MLQUEUE_DIS_DRV_RETRY) {
+			if (!blk_failfast_driver(cmd->request))
+				goto check_retries;
+		} else if (reason & SCSI_MLQUEUE_DIS_RETRY) {
+			if (!blk_noretry_request(cmd->request))
+				goto check_retries;
+		} else
+			goto check_retries;
+
+		set_driver_byte(cmd, DRIVER_TIMEOUT);
+		scsi_finish_command(cmd);
+		return 0;
 	}
 
+check_retries:
 	if (!scsi_ign_cmd_retries(reason)) {
 		if (++cmd->retries > cmd->allowed) {
 			set_driver_byte(cmd, DRIVER_TIMEOUT);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5b4cbf8..09751e4 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -425,22 +425,35 @@ enum {
 	SCSI_IGN_ALLOWED	= 0x01,
 	SCSI_IGN_BLK_FAILFAST	= 0x02,
 
-	SCSI_MLQUEUE_DIS_FINISH	= 0x10,
-	SCSI_MLQUEUE_DIS_RETRY	= 0x20,
-	SCSI_MLQUEUE_DIS_FAIL	= 0x40,
-
-	SCSI_MLQUEUE_HOST_BUSY		= 0x100 | SCSI_MLQUEUE_DIS_RETRY |
-		SCSI_IGN_BLK_FAILFAST | SCSI_IGN_ALLOWED,
-	SCSI_MLQUEUE_DEVICE_BUSY	= 0x101 | SCSI_MLQUEUE_DIS_RETRY |
-		SCSI_IGN_BLK_FAILFAST | SCSI_IGN_ALLOWED,
-	SCSI_MLQUEUE_TARGET_BUSY	= 0x102 | SCSI_MLQUEUE_DIS_RETRY |
-		SCSI_IGN_BLK_FAILFAST | SCSI_IGN_ALLOWED,
-	SCSI_MLQUEUE_IMM_RETRY		= 0x103 | SCSI_MLQUEUE_DIS_RETRY |
-		SCSI_IGN_BLK_FAILFAST | SCSI_IGN_ALLOWED,
+	SCSI_MLQUEUE_DIS_SHIFT		= 4,
+	SCSI_MLQUEUE_DIS_FINISH		= 0x01 << SCSI_MLQUEUE_DIS_SHIFT,
+	SCSI_MLQUEUE_DIS_RETRY		= 0x02 << SCSI_MLQUEUE_DIS_SHIFT,
+	SCSI_MLQUEUE_DIS_XPT_RETRY	= 0x04 << SCSI_MLQUEUE_DIS_SHIFT,
+	SCSI_MLQUEUE_DIS_DEV_RETRY	= 0x08 << SCSI_MLQUEUE_DIS_SHIFT,
+	SCSI_MLQUEUE_DIS_DRV_RETRY	= 0x10 << SCSI_MLQUEUE_DIS_SHIFT,
+	SCSI_MLQUEUE_DIS_FAIL		= 0x20 << SCSI_MLQUEUE_DIS_SHIFT,
+
+	SCSI_MLQUEUE_BUSY_SHIFT		= 8,
+	SCSI_MLQUEUE_HOST_BUSY		= (0x01 << SCSI_MLQUEUE_BUSY_SHIFT) |
+		SCSI_MLQUEUE_DIS_RETRY | SCSI_IGN_BLK_FAILFAST |
+		SCSI_IGN_ALLOWED,
+	SCSI_MLQUEUE_DEVICE_BUSY	= (0x02 << SCSI_MLQUEUE_BUSY_SHIFT) |
+		SCSI_MLQUEUE_DIS_RETRY | SCSI_IGN_BLK_FAILFAST |
+		SCSI_IGN_ALLOWED,
+	SCSI_MLQUEUE_TARGET_BUSY	= (0x04 << SCSI_MLQUEUE_BUSY_SHIFT) |
+		SCSI_MLQUEUE_DIS_RETRY | SCSI_IGN_BLK_FAILFAST |
+		SCSI_IGN_ALLOWED,
+	SCSI_MLQUEUE_IMM_RETRY		= (0x08 << SCSI_MLQUEUE_BUSY_SHIFT) |
+		SCSI_MLQUEUE_DIS_RETRY | SCSI_IGN_BLK_FAILFAST |
+		SCSI_IGN_ALLOWED,
 };
 
 #define scsi_disposition_finish(dis) (dis & SCSI_MLQUEUE_DIS_FINISH)
-#define scsi_disposition_retry(dis) (dis & SCSI_MLQUEUE_DIS_RETRY)
+#define scsi_disposition_retry(dis)			\
+	((dis & SCSI_MLQUEUE_DIS_RETRY)		||	\
+	 (dis & SCSI_MLQUEUE_DIS_XPT_RETRY)	||	\
+	 (dis & SCSI_MLQUEUE_DIS_DEV_RETRY)	||	\
+	 (dis & SCSI_MLQUEUE_DIS_DRV_RETRY))
 #define scsi_ign_cmd_retries(dis) (dis & SCSI_IGN_ALLOWED)
 #define scsi_ign_failfast(dis) (dis & SCSI_IGN_BLK_FAILFAST)
 
-- 
1.5.5.1

