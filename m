From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 9/9] scsi_error: do not display kernel pointer in message logs
Date: Thu,  8 Jan 2015 07:43:50 +0100
Message-ID: <1420699430-9492-10-git-send-email-hare@suse.de>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbbAHGoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 01:44:11 -0500
In-Reply-To: <1420699430-9492-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

It is not good practice to display the kernel pointer
in any message logs, and it doesn't display any additional
information. And as we know have block-layer assigned tags
we can use them to differentiate the messages.
So remove any pointer references from the displayed messages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 49 +++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e42fff6..10ffa21 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -124,41 +124,37 @@ scmd_eh_abort_handler(struct work_struct *work)
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p eh timeout, not aborting\n",
-				    scmd));
+				    "eh timeout, not aborting\n"));
 	} else {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "aborting command %p\n", scmd));
+				    "aborting command\n"));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
 		if (rtn == SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
-						    "scmd %p eh timeout, "
-						    "not retrying aborted "
-						    "command\n", scmd));
+						    "eh timeout, not retrying "
+						    "aborted command\n"));
 			} else if (!scsi_noretry_cmd(scmd) &&
 			    (++scmd->retries <= scmd->allowed)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
-						    "scmd %p retry "
-						    "aborted command\n", scmd));
+						    "retry aborted command\n"));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 				return;
 			} else {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
-						    "scmd %p finish "
-						    "aborted command\n", scmd));
+						    "finish aborted command\n"));
 				scsi_finish_command(scmd);
 				return;
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					    "scmd %p abort %s\n", scmd,
+					    "cmd abort %s\n",
 					    (rtn == FAST_IO_FAIL) ?
 					    "not send" : "failed"));
 		}
@@ -167,8 +163,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 	if (!scsi_eh_scmd_add(scmd, 0)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_WARNING, scmd,
-				    "scmd %p terminate "
-				    "aborted command\n", scmd));
+				    "terminate aborted command\n"));
 		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_finish_command(scmd);
 	}
@@ -194,7 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p previous abort failed\n", scmd));
+				    "previous abort failed\n"));
 		BUG_ON(delayed_work_pending(&scmd->abort_work));
 		return FAILED;
 	}
@@ -208,8 +203,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p not aborting, host in recovery\n",
-				    scmd));
+				    "not aborting, host in recovery\n"));
 		return FAILED;
 	}
 
@@ -219,8 +213,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
 	SCSI_LOG_ERROR_RECOVERY(3,
-		scmd_printk(KERN_INFO, scmd,
-			    "scmd %p abort scheduled\n", scmd));
+		scmd_printk(KERN_INFO, scmd, "abort scheduled\n"));
 	queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);
 	return SUCCESS;
 }
@@ -737,8 +730,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 	struct completion *eh_action;
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"%s scmd: %p result: %x\n",
-			__func__, scmd, scmd->result));
+			"%s result: %x\n", __func__, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
 	if (eh_action)
@@ -1052,8 +1044,8 @@ retry:
 	scsi_log_completion(scmd, rtn);
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"%s: scmd: %p, timeleft: %ld\n",
-			__func__, scmd, timeleft));
+			"%s timeleft: %ld\n",
+			__func__, timeleft));
 
 	/*
 	 * If there is time left scsi_eh_done got called, and we will examine
@@ -1192,8 +1184,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"sense requested for %p result %x\n",
-			scmd, scmd->result));
+			"sense requested, result %x\n", scmd->result));
 		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense(scmd));
 
 		rtn = scsi_decide_disposition(scmd);
@@ -1235,7 +1226,7 @@ retry_tur:
 				scmd->device->eh_timeout, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-		"%s: scmd %p rtn %x\n", __func__, scmd, rtn));
+		"%s return: %x\n", __func__, rtn));
 
 	switch (rtn) {
 	case NEEDS_RETRY:
@@ -2092,8 +2083,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 		    (++scmd->retries <= scmd->allowed)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					     "%s: flush retry cmd: %p\n",
-					     current->comm, scmd));
+					     "%s: flush retry cmd\n",
+					     current->comm));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
 			/*
@@ -2105,8 +2096,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 				scmd->result |= (DRIVER_TIMEOUT << 24);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					     "%s: flush finish cmd: %p\n",
-					     current->comm, scmd));
+					     "%s: flush finish cmd\n",
+					     current->comm));
 			scsi_finish_command(scmd);
 		}
 	}
-- 
1.8.4.5

