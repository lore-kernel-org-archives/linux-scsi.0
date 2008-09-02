From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 10/14] scsi: convert other scsi_check_sense users to new error codes
Date: Tue,  2 Sep 2008 09:05:39 -0700
Message-ID: <1220371543-15099-11-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42974 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYIBQFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5nUx023554
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5n0e231378
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5nhM021337
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

scsi_eh_completed_normally are expecting a old style FAILED/SUCCESS
type of error code, but scsi_check_sense returns the new SCSI_MLQUEUE
ones. This converted scsi_check_sense users to the new codes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b0e4b42..16bca8b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -431,13 +431,13 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		return scsi_check_sense(scmd);
 	}
 	if (host_byte(scmd->result) != DID_OK)
-		return FAILED;
+		return SCSI_MLQUEUE_DIS_FAIL;
 
 	/*
 	 * next, check the message byte.
 	 */
 	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
-		return FAILED;
+		return SCSI_MLQUEUE_DIS_FAIL;
 
 	/*
 	 * now, check the status byte to see if this indicates
@@ -446,7 +446,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	switch (status_byte(scmd->result)) {
 	case GOOD:
 	case COMMAND_TERMINATED:
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	case CHECK_CONDITION:
 		return scsi_check_sense(scmd);
 	case CONDITION_GOOD:
@@ -455,14 +455,14 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		/*
 		 * who knows?  FIXME(eric)
 		 */
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	case BUSY:
 	case QUEUE_FULL:
 	case RESERVATION_CONFLICT:
 	default:
-		return FAILED;
+		return SCSI_MLQUEUE_DIS_FAIL;
 	}
-	return FAILED;
+	return SCSI_MLQUEUE_DIS_FAIL;
 }
 
 /**
@@ -790,15 +790,12 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 			printk("%s: scsi_eh_completed_normally %x\n",
 			       __func__, rtn));
 
-		switch (rtn) {
-		case SUCCESS:
-		case NEEDS_RETRY:
-		case FAILED:
-			break;
-		default:
+		if (scsi_disposition_finish(rtn))
+			rtn = SUCCESS;
+		else if (scsi_disposition_retry(rtn))
+			rtn = NEEDS_RETRY;
+		else
 			rtn = FAILED;
-			break;
-		}
 	} else {
 		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
@@ -1026,7 +1023,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
-			    scsi_check_sense(scmd) == FAILED ) {
+			    scsi_check_sense(scmd) == SCSI_MLQUEUE_DIS_FAIL) {
 				stu_scmd = scmd;
 				break;
 			}
-- 
1.5.5.1

