From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 06/14] scsi: remove maybe_retry
Date: Tue,  2 Sep 2008 09:05:35 -0700
Message-ID: <1220371543-15099-7-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42889 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYIBQFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5mrW023446
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:48 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5lJX239224
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5l6h021148
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:47 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Remove maybe_retry from scsi_decide_disposition.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5c112e2..ffe5e70 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1295,7 +1295,6 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
  */
 int scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
-	int rtn;
 
 	/*
 	 * if the device is offline, then we clearly just pass the result back
@@ -1345,7 +1344,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		goto maybe_retry;
+		return NEEDS_RETRY;
 	case DID_IMM_RETRY:
 	case DID_REQUEUE:
 		return ADD_TO_MLQUEUE;
@@ -1375,7 +1374,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 	case DID_BUS_BUSY:
 	case DID_PARITY:
-		goto maybe_retry;
+		return NEEDS_RETRY;
 	case DID_TIME_OUT:
 		/*
 		 * when we scan the bus, we get timeout messages for
@@ -1422,14 +1421,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
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
@@ -1448,8 +1440,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	}
 	return FAILED;
 
-      maybe_retry:
-		return NEEDS_RETRY;
 }
 
 /**
-- 
1.5.5.1

