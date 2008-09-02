From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 11/14] scsi: fix up SCSI_MLQUEUE defintions and add driver, device and transport ones
Date: Tue,  2 Sep 2008 09:05:40 -0700
Message-ID: <1220371543-15099-12-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33653 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYIBQFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5oWb003343
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:50 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5oQq233558
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5nSd021366
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:50 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
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
 include/scsi/scsi.h       |   34 +++++++++++++++++++++++-----------
 3 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 16bca8b..417f119 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -307,7 +307,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		return SCSI_MLQUEUE_DIS_FAIL;	/* no valid sense data */
 
 	if (scsi_sense_is_deferred(&sshdr))
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DEV_RETRY;
 
 	if (sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh &&
 			sdev->scsi_dh_data->scsi_dh->check_sense) {
@@ -349,7 +349,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x10) /* DIF */
 			return SCSI_MLQUEUE_DIS_FINISH;
 
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DEV_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
 		/*
@@ -360,14 +360,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
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
@@ -389,11 +389,11 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
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
 
@@ -1343,7 +1343,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		return SCSI_MLQUEUE_DIS_RETRY;
+		return SCSI_MLQUEUE_DIS_DRV_RETRY;
 	case DID_IMM_RETRY:
 	case DID_REQUEUE:
 		return SCSI_MLQUEUE_IMM_RETRY;
@@ -1369,11 +1369,11 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
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
index 9bbc11d..3f01015 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -153,14 +153,28 @@ int scsi_attempt_requeue_command(struct scsi_cmnd *cmd, int reason)
 	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
 		device->device_blocked = device->max_device_blocked;
 
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
index a3083de..cacb12c 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -425,20 +425,32 @@ enum {
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
-	SCSI_MLQUEUE_IMM_RETRY		= 0x102 | SCSI_MLQUEUE_DIS_RETRY |
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
+	SCSI_MLQUEUE_IMM_RETRY		= (0x04 << SCSI_MLQUEUE_BUSY_SHIFT) |
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

