From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/22] scsi: align logging messages
Date: Thu, 28 Aug 2014 19:33:34 +0200
Message-ID: <1409247216-76074-21-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaH1Rdo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:44 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Always use 'scmd 0x%p' when logging a command pointer.

Suggested-by: Robert Elliot <elliot@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c       |  7 +++---
 drivers/scsi/scsi_error.c | 58 +++++++++++++++++++++++------------------------
 drivers/scsi/scsi_lib.c   |  2 +-
 3 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 58e2d7f..7e677d0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -533,14 +533,15 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 
 			__scsi_print_command(cmd->cmnd, buf, 80);
 			if (level > 2)
-				scmd_printk(KERN_INFO, cmd, "Send: 0x%p %s\n",
+				scmd_printk(KERN_INFO, cmd,
+					    "Send: scmd 0x%p %s\n",
 					    cmd, buf);
 			else
 				scmd_printk(KERN_INFO, cmd, "Send: %s\n", buf);
 			if (level > 3) {
 				struct Scsi_Host *shost = cmd->device->host;
 				scmd_printk(KERN_INFO, cmd,
-					    "Send: 0x%p buffer = 0x%p,"
+					    "Send: scmd 0x%p buffer = 0x%p,"
 					    " bufflen = %d,"
 					    " queuecommand 0x%p\n",
 					    cmd, scsi_sglist(cmd),
@@ -577,7 +578,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 			__scsi_print_command(cmd->cmnd, buf, 80);
 			if (level > 2)
 				scmd_printk(KERN_INFO, cmd,
-					    "Done: 0x%p %s\n", cmd, buf);
+					    "Done: scmd 0x%p %s\n", cmd, buf);
 			else
 				scmd_printk(KERN_INFO, cmd, "Done: %s\n", buf);
 			scsi_print_result(cmd, disposition);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 07887b1..5736570 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -123,33 +123,33 @@ scmd_eh_abort_handler(struct work_struct *work)
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p eh timeout, not aborting\n",
+				    "scmd 0x%p eh timeout, not aborting\n",
 				    scmd));
 	} else {
-		SCSI_LOG_ERROR_RECOVERY(3,
+		SCSI_LOG_ERROR_RECOVERY(2,
 			scmd_printk(KERN_INFO, scmd,
-				    "aborting command %p\n", scmd));
+				    "aborting scmd 0x%p\n", scmd));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
 		if (rtn == SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
-						    "scmd %p eh timeout, "
+						    "scmd 0x%p eh timeout, "
 						    "not retrying aborted "
 						    "command\n", scmd));
 			} else if (!scsi_noretry_cmd(scmd) &&
 			    (++scmd->retries <= scmd->allowed)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
-						    "scmd %p retry "
+						    "scmd 0x%p retry "
 						    "aborted command\n", scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 				return;
 			} else {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
-						    "scmd %p finish "
+						    "scmd 0x%p finish "
 						    "aborted command\n", scmd));
 				scsi_finish_command(scmd);
 				return;
@@ -157,23 +157,23 @@ scmd_eh_abort_handler(struct work_struct *work)
 		} else {
 			const char *rtn_str = scsi_disposition_string(rtn);
 			if (rtn_str) {
-				SCSI_LOG_ERROR_RECOVERY(3,
+				SCSI_LOG_ERROR_RECOVERY(2,
 					scmd_printk(KERN_INFO, scmd,
-						    "scmd %p abort failed,"
+						    "scmd 0x%p abort failed,"
 						    " %s\n", scmd, rtn_str));
 			} else {
-				SCSI_LOG_ERROR_RECOVERY(3,
+				SCSI_LOG_ERROR_RECOVERY(2,
 					scmd_printk(KERN_INFO, scmd,
-						    "scmd %p abort failed,"
+						    "scmd 0x%p abort failed,"
 						    " 0x%x\n", scmd, rtn));
 			}
 		}
 	}
 
 	if (!scsi_eh_scmd_add(scmd, 0)) {
-		SCSI_LOG_ERROR_RECOVERY(3,
+		SCSI_LOG_ERROR_RECOVERY(2,
 			scmd_printk(KERN_WARNING, scmd,
-				    "scmd %p terminate "
+				    "scmd 0x%p terminate "
 				    "aborted command\n", scmd));
 		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_finish_command(scmd);
@@ -198,9 +198,9 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		 * Retry after abort failed, escalate to next level.
 		 */
 		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
-		SCSI_LOG_ERROR_RECOVERY(3,
+		SCSI_LOG_ERROR_RECOVERY(2,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p previous abort failed\n", scmd));
+				    "scmd 0x%p previous abort failed\n", scmd));
 		BUG_ON(delayed_work_pending(&scmd->abort_work));
 		return FAILED;
 	}
@@ -214,7 +214,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
-				    "scmd %p not aborting, host in recovery\n",
+				    "scmd 0x%p not aborting, host in recovery\n",
 				    scmd));
 		return FAILED;
 	}
@@ -226,7 +226,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
 	SCSI_LOG_ERROR_RECOVERY(3,
 		scmd_printk(KERN_INFO, scmd,
-			    "scmd %p abort scheduled\n", scmd));
+			    "scmd 0x%p abort scheduled\n", scmd));
 	queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);
 	return SUCCESS;
 }
@@ -748,7 +748,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 	struct completion *eh_action;
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"%s scmd: %p result: %x\n",
+			"%s scmd 0x%p result: %x\n",
 			__func__, scmd, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
@@ -1046,7 +1046,7 @@ retry:
 	scsi_log_completion(scmd, rtn);
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"%s: scmd: %p, timeleft: %ld\n",
+			"%s: scmd 0x%p timeleft: %ld\n",
 			__func__, scmd, timeleft));
 
 	/*
@@ -1186,7 +1186,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"sense requested for %p result %x\n",
+			"sense requested for scmd 0x%p result %x\n",
 			scmd, scmd->result));
 		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense(scmd));
 
@@ -1331,15 +1331,15 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 					     __func__));
 			return list_empty(work_q);
 		}
-		SCSI_LOG_ERROR_RECOVERY(3,
+		SCSI_LOG_ERROR_RECOVERY(2,
 			shost_printk(KERN_INFO, shost,
-				     "%s: aborting cmd: 0x%p\n",
+				     "%s: aborting scmd 0x%p\n",
 				     current->comm, scmd));
 		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
 		if (rtn == FAILED) {
-			SCSI_LOG_ERROR_RECOVERY(3,
+			SCSI_LOG_ERROR_RECOVERY(2,
 				shost_printk(KERN_INFO, shost,
-					     "%s: aborting cmd failed: 0x%p\n",
+					     "%s: aborting scmd 0x%p failed\n",
 					     current->comm, scmd));
 			list_splice_init(&check_list, work_q);
 			return list_empty(work_q);
@@ -1416,7 +1416,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 
 		SCSI_LOG_ERROR_RECOVERY(3,
 			shost_printk(KERN_INFO, shost,
-				     "%s: Sending START_UNIT to sdev: 0x%p\n",
+				     "%s: Sending START_UNIT to sdev 0x%p\n",
 				     current->comm, sdev));
 
 		if (!scsi_eh_try_stu(stu_scmd)) {
@@ -1432,7 +1432,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
-					     "%s: START_UNIT failed to sdev:"
+					     "%s: START_UNIT failed to sdev"
 					     " 0x%p\n", current->comm, sdev));
 		}
 	}
@@ -1481,7 +1481,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 
 		SCSI_LOG_ERROR_RECOVERY(3,
 			shost_printk(KERN_INFO, shost,
-				     "%s: Sending BDR sdev: 0x%p\n",
+				     "%s: Sending BDR sdev 0x%p\n",
 				     current->comm, sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
@@ -1499,7 +1499,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
-					     "%s: BDR failed sdev: 0x%p\n",
+					     "%s: BDR failed sdev 0x%p\n",
 					     current->comm, sdev));
 		}
 	}
@@ -2085,7 +2085,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 		    (++scmd->retries <= scmd->allowed)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					     "%s: flush retry cmd: %p\n",
+					     "%s: flush retry scmd 0x%p\n",
 					     current->comm, scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
@@ -2098,7 +2098,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 				scmd->result |= (DRIVER_TIMEOUT << 24);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					     "%s: flush finish cmd: %p\n",
+					     "%s: flush finish scmd 0x%p\n",
 					     current->comm, scmd));
 			scsi_finish_command(scmd);
 		}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d3657b6..ed5e40f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -144,7 +144,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
-		"Inserting command %p into mlqueue\n", cmd));
+		"Inserting scmd %p into mlqueue\n", cmd));
 
 	scsi_set_blocked(cmd, reason);
 
-- 
1.8.5.2

