From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 09/14] scsi: have device handlers return SCSI_MLQUEUE error value
Date: Tue,  2 Sep 2008 09:05:38 -0700
Message-ID: <1220371543-15099-10-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39481 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYIBQFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:50 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5nlA027574
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5n57173078
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5mH6021300
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This has the scsi device handlers return SCSI_MLQUEUE error
values instead of the old values.

One change is that if the handler does not care we return 0
instead of SCSI_RETURN_NOT_HANDLED.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |   16 ++++++++--------
 drivers/scsi/device_handler/scsi_dh_emc.c  |    8 ++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c |   10 +++++-----
 drivers/scsi/scsi_error.c                  |    2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6bc55a6..b98d531 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -426,45 +426,45 @@ static int alua_check_sense(struct scsi_device *sdev,
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_IMM_RETRY;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0b)
 			/*
 			 * LUN Not Accessible -- Target port in standby state
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0c)
 			/*
 			 * LUN Not Accessible -- Target port in unavailable state
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x12)
 			/*
 			 * LUN Not Ready -- Offline
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
 			/*
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_IMM_RETRY;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
 			/*
 			 * ALUA state changed
 			 */
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_IMM_RETRY;
 		}
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
 			/*
 			 * Implicit ALUA state transition failed
 			 */
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_IMM_RETRY;
 		}
 		break;
 	}
 
-	return SCSI_RETURN_NOT_HANDLED;
+	return 0;
 }
 
 /*
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 64a56e5..4be7be3 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -418,7 +418,7 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			 * Can return FAILED only when we want the error
 			 * recovery process to kick in.
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		break;
 	case ILLEGAL_REQUEST:
 		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
@@ -432,7 +432,7 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			 * Can return FAILED only when we want the error
 			 * recovery process to kick in.
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
@@ -440,11 +440,11 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			 * Unit Attention Code. This is the first IO
 			 * to the new path, so just retry.
 			 */
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_IMM_RETRY;
 		break;
 	}
 
-	return SCSI_RETURN_NOT_HANDLED;
+	return 0;
 }
 
 static int clariion_prep_fn(struct scsi_device *sdev, struct request *req)
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c504afe..9b1c2d5 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -546,13 +546,13 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			 *
 			 * Nothing we can do here. Try to bypass the path.
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0xA1)
 			/* LUN Not Ready - Quiescense in progress
 			 *
 			 * Just retry and wait.
 			 */
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_IMM_RETRY;
 		break;
 	case ILLEGAL_REQUEST:
 		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
@@ -561,7 +561,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			 * Fail the path, so that the other path be used.
 			 */
 			h->state = RDAC_STATE_PASSIVE;
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		}
 		break;
 	case UNIT_ATTENTION:
@@ -569,11 +569,11 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			/*
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
-			return NEEDS_RETRY;
+			return SCSI_MLQUEUE_IMM_RETRY;
 		break;
 	}
 	/* success just means we do not care what scsi-ml does */
-	return SCSI_RETURN_NOT_HANDLED;
+	return 0;
 }
 
 static const struct scsi_dh_devlist rdac_dev_list[] = {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 45c7d24..b0e4b42 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -314,7 +314,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		int rc;
 
 		rc = sdev->scsi_dh_data->scsi_dh->check_sense(sdev, &sshdr);
-		if (rc != SCSI_RETURN_NOT_HANDLED)
+		if (rc)
 			return rc;
 		/* handler does not care. Drop down to default handling */
 	}
-- 
1.5.5.1

