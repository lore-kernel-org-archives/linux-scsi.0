From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 8/8] scsi: inline command aborts
Date: Tue,  4 Apr 2017 16:03:01 +0200
Message-ID: <1491314581-73795-9-git-send-email-hare@suse.de>
References: <1491314581-73795-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754051AbdDDODK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 10:03:10 -0400
In-Reply-To: <1491314581-73795-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The block layer always calls the timeout function from a workqueue
context, so there is no need to have yet another workqueue for
running command aborts.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi.c       |  2 --
 drivers/scsi/scsi_error.c | 80 +++++++++++++++++++++++------------------------
 drivers/scsi/scsi_lib.c   |  2 --
 drivers/scsi/scsi_priv.h  |  1 -
 4 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 7bfbcfa..fdec73e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -115,8 +115,6 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	BUG_ON(list_empty(&cmd->list));
 	list_del_init(&cmd->list);
 	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
-
-	BUG_ON(delayed_work_pending(&cmd->abort_work));
 }
 
 #ifdef CONFIG_SCSI_LOGGING
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c09e81f..7165bcd 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -115,11 +115,9 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
  */
-void
-scmd_eh_abort_handler(struct work_struct *work)
+int
+scmd_eh_abort_handler(struct scsi_cmnd *scmd)
 {
-	struct scsi_cmnd *scmd =
-		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
 	int rtn;
 
@@ -127,42 +125,40 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "eh timeout, not aborting\n"));
-	} else {
-		SCSI_LOG_ERROR_RECOVERY(3,
-			scmd_printk(KERN_INFO, scmd,
-				    "aborting command\n"));
-		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
-		if (rtn == SUCCESS) {
-			set_host_byte(scmd, DID_TIME_OUT);
-			if (scsi_host_eh_past_deadline(sdev->host)) {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					scmd_printk(KERN_INFO, scmd,
-						    "eh timeout, not retrying "
-						    "aborted command\n"));
-			} else if (!scsi_noretry_cmd(scmd) &&
-			    (++scmd->retries <= scmd->allowed)) {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					scmd_printk(KERN_WARNING, scmd,
-						    "retry aborted command\n"));
-				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
-				return;
-			} else {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					scmd_printk(KERN_WARNING, scmd,
-						    "finish aborted command\n"));
-				scsi_finish_command(scmd);
-				return;
-			}
-		} else {
+		return FAILED;
+	}
+	SCSI_LOG_ERROR_RECOVERY(3,
+		scmd_printk(KERN_INFO, scmd,
+			    "aborting command\n"));
+	rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
+	if (rtn == SUCCESS) {
+		set_host_byte(scmd, DID_TIME_OUT);
+		if (scsi_host_eh_past_deadline(sdev->host)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					    "cmd abort %s\n",
-					    (rtn == FAST_IO_FAIL) ?
-					    "not send" : "failed"));
+					    "eh timeout, not retrying "
+					    "aborted command\n"));
+			rtn = FAILED;
+		} else if (!scsi_noretry_cmd(scmd) &&
+			   (++scmd->retries <= scmd->allowed)) {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_WARNING, scmd,
+					    "retry aborted command\n"));
+			scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_WARNING, scmd,
+					    "finish aborted command\n"));
+			scsi_finish_command(scmd);
 		}
+		return rtn;
 	}
-
-	scsi_eh_scmd_add(scmd);
+	SCSI_LOG_ERROR_RECOVERY(3,
+		scmd_printk(KERN_INFO, scmd,
+			    "cmd abort %s\n",
+			    (rtn == FAST_IO_FAIL) ?
+			    "not send" : "failed"));
+	return rtn;
 }
 
 /**
@@ -185,7 +181,6 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "previous abort failed\n"));
-		BUG_ON(delayed_work_pending(&scmd->abort_work));
 		return FAILED;
 	}
 
@@ -197,8 +192,7 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
 	SCSI_LOG_ERROR_RECOVERY(3,
 		scmd_printk(KERN_INFO, scmd, "abort scheduled\n"));
-	queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);
-	return SUCCESS;
+	return scmd_eh_abort_handler(scmd);
 }
 
 /**
@@ -274,10 +268,14 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (rtn == BLK_EH_NOT_HANDLED) {
-		if (scsi_abort_command(scmd) != SUCCESS) {
+		int ret;
+
+		ret = scsi_abort_command(scmd);
+		if (ret == FAILED) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_scmd_add(scmd);
-		}
+		} else if (ret == FAST_IO_FAIL)
+			rtn = BLK_EH_RESET_TIMER;
 	}
 
 	return rtn;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9822fde..2ae00b8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1146,7 +1146,6 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
-	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
 
 	spin_lock_irqsave(&dev->list_lock, flags);
@@ -1863,7 +1862,6 @@ static int scsi_mq_prep_fn(struct request *req)
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	INIT_LIST_HEAD(&cmd->list);
-	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
 
 	if (shost->use_cmd_list) {
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index e20ab10..e7f43b9 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -66,7 +66,6 @@ extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 extern void scsi_exit_devinfo(void);
 
 /* scsi_error.c */
-extern void scmd_eh_abort_handler(struct work_struct *work);
 extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
-- 
1.8.5.6
