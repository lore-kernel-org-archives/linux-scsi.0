From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] scsi: make scsi_eh_scmd_add() always succeed
Date: Tue,  4 Nov 2014 13:11:11 +0100
Message-ID: <1415103073-90276-2-git-send-email-hare@suse.de>
References: <1415103073-90276-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbaKDMLQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 07:11:16 -0500
In-Reply-To: <1415103073-90276-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

BLK_EH_HANDLED does not work with scsi commands, as we need
to release the associated buffers correctly.
And scsi_eh_scmd_add() currently only will fail if no
error handler thread is started (which will never be the
case) or if the state machine encounters an illegal transition.
As state machine transitions don't have any real meaning
we can also force setting of the new state and
make scsi_dh_scmd_add() a void function.
With that we'll never have to resort to return
BLK_EH_HANDLED.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 30 +++++++++---------------------
 drivers/scsi/scsi_lib.c   |  4 ++--
 drivers/scsi/scsi_priv.h  |  2 +-
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index fa7b5ec..c71d61f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -163,14 +163,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 		}
 	}
 
-	if (!scsi_eh_scmd_add(scmd, 0)) {
-		SCSI_LOG_ERROR_RECOVERY(3,
-			scmd_printk(KERN_WARNING, scmd,
-				    "scmd %p terminate "
-				    "aborted command\n", scmd));
-		set_host_byte(scmd, DID_TIME_OUT);
-		scsi_finish_command(scmd);
-	}
+	scsi_eh_scmd_add(scmd, 0);
 }
 
 /**
@@ -228,37 +221,33 @@ scsi_abort_command(struct scsi_cmnd *scmd)
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
 
-	if (!shost->ehandler)
-		return 0;
+	WARN_ON(!shost->ehandler);
 
 	spin_lock_irqsave(shost->host_lock, flags);
+	/*
+	 * Force SHOST_RECOVERY even for illegal state transitions;
+	 * we cannot handle failed commands otherwise.
+	 */
 	if (scsi_host_set_state(shost, SHOST_RECOVERY))
 		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
-			goto out_unlock;
+			shost->shost_state = SHOST_RECOVERY;
 
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
 
-	ret = 1;
 	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
 		eh_flag &= ~SCSI_EH_CANCEL_CMD;
 	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
- out_unlock:
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	return ret;
 }
 
 /**
@@ -294,8 +283,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 			return BLK_EH_NOT_HANDLED;
 
 		set_host_byte(scmd, DID_TIME_OUT);
-		if (!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))
-			rtn = BLK_EH_HANDLED;
+		scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
 	}
 
 	return rtn;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc0a8a0..26f7dcf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1647,8 +1647,8 @@ static void scsi_softirq_done(struct request *rq)
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
index 12b8e1b..b2d1a2b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -72,7 +72,7 @@ extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
-extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
+extern void scsi_eh_scmd_add(struct scsi_cmnd *, int);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q);
-- 
1.8.5.2

