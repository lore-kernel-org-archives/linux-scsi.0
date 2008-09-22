From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 04/13] scsi: remove maybe_retry
Date: Mon, 22 Sep 2008 09:33:33 -0700
Message-ID: <1222101222-15079-5-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49656 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYIVQeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:06 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY5Fs020778
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:05 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY4DV176500
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY2Qo005142
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:04 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYM003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:33:58 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove maybe_retry from scsi_decide_disposition.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4eabb1a..b092089 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1268,7 +1268,6 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
  */
 int scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
-	int rtn;
 
 	/*
 	 * if the device is offline, then we clearly just pass the result back
@@ -1318,7 +1317,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		goto maybe_retry;
+		return NEEDS_RETRY;
 	case DID_IMM_RETRY:
 	case DID_REQUEUE:
 		return ADD_TO_MLQUEUE;
@@ -1348,7 +1347,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 	case DID_BUS_BUSY:
 	case DID_PARITY:
-		goto maybe_retry;
+		return NEEDS_RETRY;
 	case DID_TIME_OUT:
 		/*
 		 * when we scan the bus, we get timeout messages for
@@ -1395,14 +1394,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case TASK_ABORTED:
 		return SUCCESS;
 	case CHECK_CONDITION:
-		rtn = scsi_check_sense(scmd);
-		if (rtn == NEEDS_RETRY)
-			goto maybe_retry;
-		/* if rtn == FAILED, we have no sense information;
-		 * returning FAILED will wake the error handler thread
-		 * to collect the sense and redo the decide
-		 * disposition */
-		return rtn;
+		return scsi_check_sense(scmd);
 	case CONDITION_GOOD:
 	case INTERMEDIATE_GOOD:
 	case INTERMEDIATE_C_GOOD:
@@ -1421,8 +1413,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	}
 	return FAILED;
 
-      maybe_retry:
-		return NEEDS_RETRY;
 }
 
 /**
-- 
1.5.5.1

