From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 5/6] scsi: make scsi_eh_scmd_add() always succeed
Date: Wed,  1 Mar 2017 10:15:19 +0100
Message-ID: <1488359720-130871-6-git-send-email-hare@suse.de>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdCAJep (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Mar 2017 04:34:45 -0500
In-Reply-To: <1488359720-130871-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_eh_scmd_add() currently only will fail if no
error handler thread is started (which will never be the
case) or if the state machine encounters an illegal transition.

But if we're encountering an invalid state transition
chances is we cannot fixup things with the error handler.
So better add a WARN_ON for illegal host states and
make scsi_dh_scmd_add() a void function.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c | 41 +++++++++++++----------------------------
 drivers/scsi/scsi_lib.c   |  4 ++--
 drivers/scsi/scsi_priv.h  |  2 +-
 3 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4613aa1..802a081 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -163,13 +163,7 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 		}
 	}
 
-	if (!scsi_eh_scmd_add(scmd, 0)) {
-		SCSI_LOG_ERROR_RECOVERY(3,
-			scmd_printk(KERN_WARNING, scmd,
-				    "terminate aborted command\n"));
-		set_host_byte(scmd, DID_TIME_OUT);
-		scsi_finish_command(scmd);
-	}
+	scsi_eh_scmd_add(scmd, 0);
 }
 
 /**
@@ -224,28 +218,23 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
  * @eh_flag:	optional SCSI_EH flag.
- *
- * Return value:
- *	0 on failure.
  */
-int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
+void scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
-	if (!shost->ehandler)
-		return 0;
+	WARN_ON_ONCE(!shost->ehandler);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_RECOVERY))
-		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
-			goto out_unlock;
-
+	if (scsi_host_set_state(shost, SHOST_RECOVERY)) {
+		ret = scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);
+		WARN_ON_ONCE(ret);
+	}
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
 
-	ret = 1;
 	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
 		eh_flag &= ~SCSI_EH_CANCEL_CMD;
 	scmd->eh_eflags |= eh_flag;
@@ -253,9 +242,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
- out_unlock:
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	return ret;
 }
 
 /**
@@ -284,13 +271,11 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (rtn == BLK_EH_NOT_HANDLED) {
-		if (!host->hostt->no_async_abort &&
-		    scsi_abort_command(scmd) == SUCCESS)
-			return BLK_EH_NOT_HANDLED;
-
-		set_host_byte(scmd, DID_TIME_OUT);
-		if (!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))
-			rtn = BLK_EH_HANDLED;
+		if (host->hostt->no_async_abort ||
+		    scsi_abort_command(scmd) != SUCCESS) {
+			set_host_byte(scmd, DID_TIME_OUT);
+			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+		}
 	}
 
 	return rtn;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5e45a2..0735a46 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1593,8 +1593,8 @@ static void scsi_softirq_done(struct request *rq)
 			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 			break;
 		default:
-			if (!scsi_eh_scmd_add(cmd, 0))
-				scsi_finish_command(cmd);
+			scsi_eh_scmd_add(cmd, 0);
+			break;
 	}
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 99bfc98..5be6cbf6 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -72,7 +72,7 @@ extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
-extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
+extern void scsi_eh_scmd_add(struct scsi_cmnd *, int);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q);
-- 
1.8.5.6
