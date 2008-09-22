From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 07/13] scsi: have device handlers return SCSI_MLQUEUE error value
Date: Mon, 22 Sep 2008 09:33:36 -0700
Message-ID: <1222101222-15079-8-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49566 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYIVQeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:03 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY1cp020657
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY15u130238
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY0OF005087
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:01 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
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
 drivers/scsi/scsi_error.c                  |    9 +++++----
 4 files changed, 22 insertions(+), 21 deletions(-)

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
index 247b1d1..0721b85 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -417,7 +417,7 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			 * Can return FAILED only when we want the error
 			 * recovery process to kick in.
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		break;
 	case ILLEGAL_REQUEST:
 		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
@@ -431,7 +431,7 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			 * Can return FAILED only when we want the error
 			 * recovery process to kick in.
 			 */
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
@@ -439,11 +439,11 @@ static int clariion_check_sense(struct scsi_device *sdev,
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
index 6e31572..1055c62 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -544,13 +544,13 @@ static int rdac_check_sense(struct scsi_device *sdev,
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
@@ -559,7 +559,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			 * Fail the path, so that the other path be used.
 			 */
 			h->state = RDAC_STATE_PASSIVE;
-			return SUCCESS;
+			return SCSI_MLQUEUE_DIS_FINISH;
 		}
 		break;
 	case UNIT_ATTENTION:
@@ -567,11 +567,11 @@ static int rdac_check_sense(struct scsi_device *sdev,
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
index 02f999b..0505883 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -253,7 +253,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		int rc;
 
 		rc = sdev->scsi_dh_data->scsi_dh->check_sense(sdev, &sshdr);
-		if (rc != SCSI_RETURN_NOT_HANDLED)
+		if (rc)
 			return rc;
 		/* handler does not care. Drop down to default handling */
 	}
@@ -1321,8 +1321,9 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case DID_SOFT_ERROR:
 		return SCSI_MLQUEUE_DIS_RETRY;
 	case DID_IMM_RETRY:
-	case DID_REQUEUE:
 		return SCSI_MLQUEUE_IMM_RETRY;
+	case DID_REQUEUE:
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	case DID_TRANSPORT_DISRUPTED:
 		/*
 		 * LLD/transport was disrupted during processing of the IO.
@@ -1330,7 +1331,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and the transport will decide what to do with the IO
 		 * based on its timers and recovery capablilities.
 		 */
-		return SCSI_MLQUEUE_IMM_RETRY;
+		return SCSI_MLQUEUE_TARGET_BUSY;
 	case DID_TRANSPORT_FAILFAST:
 		/*
 		 * The transport decided to failfast the IO (most likely
@@ -1390,7 +1391,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * the empty queue handling to trigger a stall in the
 		 * device.
 		 */
-		return SCSI_MLQUEUE_IMM_RETRY;
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	case GOOD:
 	case COMMAND_TERMINATED:
 	case TASK_ABORTED:
-- 
1.5.5.1

