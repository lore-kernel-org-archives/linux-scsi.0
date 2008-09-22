From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 08/13] scsi: convert other scsi_check_sense users to new error codes
Date: Mon, 22 Sep 2008 09:33:37 -0700
Message-ID: <1222101222-15079-9-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:50158 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYIVQeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:06 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY6HI011523
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:06 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY6Ye203754
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY1kt005120
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:05 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
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
index 0505883..9a539dd 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -370,13 +370,13 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
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
@@ -385,7 +385,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	switch (status_byte(scmd->result)) {
 	case GOOD:
 	case COMMAND_TERMINATED:
-		return SUCCESS;
+		return SCSI_MLQUEUE_DIS_FINISH;
 	case CHECK_CONDITION:
 		return scsi_check_sense(scmd);
 	case CONDITION_GOOD:
@@ -394,14 +394,14 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
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
@@ -729,15 +729,12 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
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
@@ -965,7 +962,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
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

