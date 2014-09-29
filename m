From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 34/38] scsi: Remove command pointer argument from logging messages
Date: Mon, 29 Sep 2014 13:59:03 +0200
Message-ID: <1411991947-130166-35-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbaI2L7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:18 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Printing out the command pointer during logging messages doesn't
serve any real purpose, but only takes up space.
So we should remove it and rely on the generic logging functions
to distinguish the command for us.

Suggested-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 33 +++++++++++++--------------------
 drivers/scsi/scsi_lib.c   |  2 +-
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9daaf2a..0d977d3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -123,50 +123,45 @@ scmd_eh_abort_handler(struct work_struct *work)
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
+						    "eh timeout, "
 						    "not retrying aborted "
-						    "command\n", scmd));
+						    "command\n"));
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
+						    "command aborted\n"));
 				scsi_finish_command(scmd);
 				return;
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					    "scmd %p abort failed, rtn %d\n",
-					    scmd, rtn));
+					    "abort failed, rtn %d\n", rtn));
 		}
 	}
 
 	if (!scsi_eh_scmd_add(scmd, 0)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_WARNING, scmd,
-				    "scmd %p terminate "
-				    "aborted command\n", scmd));
+				    "terminate aborted command\n"));
 		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_finish_command(scmd);
 	}
@@ -192,7 +187,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p previous abort failed\n", scmd));
+				    "previous abort failed\n"));
 		BUG_ON(delayed_work_pending(&scmd->abort_work));
 		return FAILED;
 	}
@@ -206,8 +201,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p not aborting, host in recovery\n",
-				    scmd));
+				    "not aborting, host in recovery\n"));
 		return FAILED;
 	}
 
@@ -217,8 +211,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
 	SCSI_LOG_ERROR_RECOVERY(3,
-		scmd_printk(KERN_INFO, scmd,
-			    "scmd %p abort scheduled\n", scmd));
+		scmd_printk(KERN_INFO, scmd, "abort scheduled\n"));
 	queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);
 	return SUCCESS;
 }
@@ -740,8 +733,8 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 	struct completion *eh_action;
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"%s scmd: %p result: %x\n",
-			__func__, scmd, scmd->result));
+			"%s result: %x\n",
+			__func__, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
 	if (eh_action)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5c67e4e..0290b7522 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -144,7 +144,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
-		"Inserting command %p into mlqueue\n", cmd));
+		"Inserting into mlqueue\n"));
 
 	scsi_set_blocked(cmd, reason);
 
-- 
1.8.5.2

