From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] scsi: improved eh timeout handler
Date: Mon,  2 Sep 2013 13:58:37 +0200
Message-ID: <1378123118-111972-3-git-send-email-hare@suse.de>
References: <1378123118-111972-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419Ab3IBL6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 07:58:43 -0400
In-Reply-To: <1378123118-111972-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

When a command runs into a timeout we need to send an 'ABORT TASK'
TMF. This is typically done by the 'eh_abort_handler' LLDD callback.

Conceptually, however, this function is a normal SCSI command, so
there is no need to enter the error handler.

This patch implements a new scsi_abort_command() function which
invokes an asynchronous function scsi_eh_abort_handler() to
abort the commands via the usual 'eh_abort_handler'.

If abort succeeds the command is either retried or terminated,
depending on the number of allowed retries. However, 'eh_eflags'
records the abort, so if the retry would fail again the
command is pushed onto the error handler without trying to
abort it (again); it'll be cleared up from SCSI EH.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/scsi/scsi.c       |   3 +
 drivers/scsi/scsi_error.c | 149 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_priv.h  |   2 +
 include/scsi/scsi_cmnd.h  |   1 +
 include/scsi/scsi_host.h  |   5 ++
 5 files changed, 147 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index fe0bcb1..2b04a57 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -297,6 +297,7 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 
 		cmd->device = dev;
 		INIT_LIST_HEAD(&cmd->list);
+		INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 		spin_lock_irqsave(&dev->list_lock, flags);
 		list_add_tail(&cmd->list, &dev->cmd_list);
 		spin_unlock_irqrestore(&dev->list_lock, flags);
@@ -353,6 +354,8 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	list_del_init(&cmd->list);
 	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
+	cancel_delayed_work(&cmd->abort_work);
+
 	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_put_command);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c88cb7e..8eaf524 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -53,6 +53,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd);
 #define HOST_RESET_SETTLE_TIME  (10)
 
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
+static int scsi_try_to_abort_cmd(struct scsi_host_template *, struct scsi_cmnd *);
 
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
@@ -100,6 +101,115 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 }
 
 /**
+ * scmd_eh_abort_handler - Handle command aborts
+ * @work:	command to be aborted.
+ */
+void
+scmd_eh_abort_handler(struct work_struct *work)
+{
+	struct scsi_cmnd *scmd =
+		container_of(work, struct scsi_cmnd, abort_work.work);
+	struct scsi_device *sdev = scmd->device;
+	unsigned long flags;
+	int rtn;
+
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	if (scsi_host_eh_past_deadline(sdev->host)) {
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "scmd %p eh timeout, not aborting\n", scmd));
+	} else {
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "aborting command %p\n", scmd));
+		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
+		if (rtn == SUCCESS) {
+			scmd->result |= DID_TIME_OUT << 16;
+			if (!scsi_noretry_cmd(scmd) &&
+			    (++scmd->retries <= scmd->allowed)) {
+				SCSI_LOG_ERROR_RECOVERY(3,
+					scmd_printk(KERN_WARNING, scmd,
+						    "scmd %p retry "
+						    "aborted command\n", scmd));
+				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+			} else {
+				SCSI_LOG_ERROR_RECOVERY(3,
+					scmd_printk(KERN_WARNING, scmd,
+						    "scmd %p finish "
+						    "aborted command\n", scmd));
+				scsi_finish_command(scmd);
+			}
+			return;
+		}
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "scmd %p abort failed, rtn %d\n",
+				    scmd, rtn));
+	}
+
+	if (scsi_eh_scmd_add(scmd, 0)) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_WARNING, scmd,
+				    "scmd %p terminate "
+				    "aborted command\n", scmd));
+		scmd->result |= DID_TIME_OUT << 16;
+		scsi_finish_command(scmd);
+	}
+}
+
+/**
+ * scsi_abort_command - schedule a command abort
+ * @scmd:	scmd to abort.
+ *
+ * We only need to abort commands after a command timeout
+ */
+static int
+scsi_abort_command(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
+
+	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
+		/*
+		 * command abort timed out.
+		 */
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "scmd %p abort timeout\n", scmd));
+		cancel_delayed_work(&scmd->abort_work);
+		return FAILED;
+	}
+
+	/*
+	 * Do not try a command abort if
+	 * SCSI EH has already started.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsi_host_in_recovery(shost)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "scmd %p not aborting, host in recovery\n",
+				    scmd));
+		return FAILED;
+	}
+
+	if (shost->eh_deadline && !shost->last_reset)
+		shost->last_reset = jiffies;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
+	SCSI_LOG_ERROR_RECOVERY(3,
+		scmd_printk(KERN_INFO, scmd,
+			    "scmd %p abort scheduled\n", scmd));
+	schedule_delayed_work(&scmd->abort_work, HZ / 100);
+	return SUCCESS;
+}
+
+/**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
  * @eh_flag:	optional SCSI_EH flag.
@@ -125,6 +235,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 		shost->last_reset = jiffies;
 
 	ret = 1;
+	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
+		eh_flag &= ~SCSI_EH_CANCEL_CMD;
 	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
@@ -161,6 +273,10 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	else if (host->hostt->eh_timed_out)
 		rtn = host->hostt->eh_timed_out(scmd);
 
+	if (rtn == BLK_EH_NOT_HANDLED && !host->hostt->no_async_abort)
+		if (scsi_abort_command(scmd) == SUCCESS)
+			return BLK_EH_NOT_HANDLED;
+
 	scmd->result |= DID_TIME_OUT << 16;
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
@@ -1577,7 +1693,7 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 }
 
 /**
- * scsi_noretry_cmd - determinte if command should be failed fast
+ * scsi_noretry_cmd - determine if command should be failed fast
  * @scmd:	SCSI cmd to examine.
  */
 int scsi_noretry_cmd(struct scsi_cmnd *scmd)
@@ -1585,6 +1701,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	switch (host_byte(scmd->result)) {
 	case DID_OK:
 		break;
+	case DID_TIME_OUT:
+		goto check_type;
 	case DID_BUS_BUSY:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
 	case DID_PARITY:
@@ -1598,18 +1716,19 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
 	}
 
-	switch (status_byte(scmd->result)) {
-	case CHECK_CONDITION:
-		/*
-		 * assume caller has checked sense and determinted
-		 * the check condition was retryable.
-		 */
-		if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
-		    scmd->request->cmd_type == REQ_TYPE_BLOCK_PC)
-			return 1;
-	}
+	switch (status_byte(scmd->result) != CHECK_CONDITION)
+		return 0;
 
-	return 0;
+check_type:
+	/*
+	 * assume caller has checked sense and determined
+	 * the check condition was retryable.
+	 */
+	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
+	    scmd->request->cmd_type == REQ_TYPE_BLOCK_PC)
+		return 1;
+	else
+		return 0;
 }
 
 /**
@@ -1659,9 +1778,13 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * looks good.  drop through, and check the next byte.
 		 */
 		break;
+	case DID_ABORT:
+		if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
+			scmd->result |= DID_TIME_OUT << 16;
+			return SUCCESS;
+		}
 	case DID_NO_CONNECT:
 	case DID_BAD_TARGET:
-	case DID_ABORT:
 		/*
 		 * note - this means that we just report the status back
 		 * to the top level driver, not that we actually think
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 8f9a0ca..f079a59 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -19,6 +19,7 @@ struct scsi_nl_hdr;
  * Scsi Error Handler Flags
  */
 #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
+#define SCSI_EH_ABORT_SCHEDULED	0x0002	/* Abort has been scheduled */
 
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
@@ -66,6 +67,7 @@ extern int __init scsi_init_devinfo(void);
 extern void scsi_exit_devinfo(void);
 
 /* scsi_error.c */
+extern void scmd_eh_abort_handler(struct work_struct *work);
 extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index de5f5d8..91558a1 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -55,6 +55,7 @@ struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
+	struct delayed_work abort_work;
 	int eh_eflags;		/* Used by error handlr */
 
 	/*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 896bb05..6ca9174 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -476,6 +476,11 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
+	 * True if asynchronous aborts are not supported
+	 */
+	unsigned no_async_abort:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
-- 
1.7.12.4

