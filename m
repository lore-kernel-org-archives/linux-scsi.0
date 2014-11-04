From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi: make asynchronous aborts mandatory
Date: Tue,  4 Nov 2014 13:11:13 +0100
Message-ID: <1415103073-90276-4-git-send-email-hare@suse.de>
References: <1415103073-90276-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbaKDMLR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 07:11:17 -0500
In-Reply-To: <1415103073-90276-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

There hasn't been any reports for HBAs where asynchronous abort
would not work, so we should make it mandatory and remove
the fallback.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.txt | 28 +++++++-------
 drivers/scsi/scsi_error.c      | 85 +++++-------------------------------------
 drivers/scsi/scsi_lib.c        |  2 +-
 drivers/scsi/scsi_priv.h       |  3 +-
 include/scsi/scsi_host.h       |  5 ---
 5 files changed, 24 insertions(+), 99 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 011c03d..cbb07f2 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -70,7 +70,7 @@ with the command.
 	scmd is requeued to blk queue.
 
  - otherwise
-	scsi_eh_scmd_add(scmd, 0) is invoked for the command.  See
+	scsi_eh_scmd_add(scmd) is invoked for the command.  See
 	[1-3] for details of this function.
 
 
@@ -103,13 +103,15 @@ function
         eh_timed_out() callback did not handle the command.
 	Step #2 is taken.
 
- 2. If the host supports asynchronous completion (as indicated by the
-    no_async_abort setting in the host template) scsi_abort_command()
-    is invoked to schedule an asynchrous abort. If that fails
-    Step #3 is taken.
+ 2. scsi_abort_command() is invoked to schedule an asynchrous abort
+    (Seee [1-3] for more information).
+    Asynchronous abort are not invoked for commands which have
+    SCSI_EH_ABORT_SCHEDULED set (this indicates that the command
+    already had been aborted once, and this is a retry which failed),
+    or when the EH deadline is expired. In these case Step #3 is taken.
 
- 2. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
-    command.  See [1-3] for more information.
+ 3. scsi_eh_scmd_add(scmd) is invoked for the
+    command.  See [1-4] for more information.
 
 [1-3] Asynchronous command aborts
 
@@ -124,16 +126,13 @@ function
 
  scmds enter EH via scsi_eh_scmd_add(), which does the following.
 
- 1. Turns on scmd->eh_eflags as requested.  It's 0 for error
-    completions and SCSI_EH_CANCEL_CMD for timeouts.
+ 1. Links scmd->eh_entry to shost->eh_cmd_q
 
- 2. Links scmd->eh_entry to shost->eh_cmd_q
+ 2. Sets SHOST_RECOVERY bit in shost->shost_state
 
- 3. Sets SHOST_RECOVERY bit in shost->shost_state
+ 3. Increments shost->host_failed
 
- 4. Increments shost->host_failed
-
- 5. Wakes up SCSI EH thread if shost->host_busy == shost->host_failed
+ 4. Wakes up SCSI EH thread if shost->host_busy == shost->host_failed
 
  As can be seen above, once any scmd is added to shost->eh_cmd_q,
 SHOST_RECOVERY shost_state bit is turned on.  This prevents any new
@@ -249,7 +248,6 @@ scmd->allowed.
 
  1. Error completion / time out
     ACTION: scsi_eh_scmd_add() is invoked for scmd
-	- set scmd->eh_eflags
 	- add scmd to shost->eh_cmd_q
 	- set SHOST_RECOVERY
 	- shost->host_failed++
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 27cb30d..cee85e9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -163,7 +163,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 		}
 	}
 
-	scsi_eh_scmd_add(scmd, 0);
+	scsi_eh_scmd_add(scmd);
 }
 
 /**
@@ -219,9 +219,8 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
- * @eh_flag:	optional SCSI_EH flag.
  */
-void scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
+void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
@@ -240,9 +239,6 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
 
-	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
-		eh_flag &= ~SCSI_EH_CANCEL_CMD;
-	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
@@ -277,12 +273,10 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (rtn == BLK_EH_NOT_HANDLED) {
-		if (!host->hostt->no_async_abort &&
-		    scsi_abort_command(scmd) == SUCCESS)
-			return BLK_EH_NOT_HANDLED;
-
-		set_host_byte(scmd, DID_TIME_OUT);
-		scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+		if (scsi_abort_command(scmd) != SUCCESS) {
+			set_host_byte(scmd, DID_TIME_OUT);
+			scsi_eh_scmd_add(scmd);
+		}
 	}
 
 	return rtn;
@@ -334,7 +328,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (scmd->device == sdev) {
 				++total_failures;
-				if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD)
+				if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
 					++cmd_cancel;
 				else
 					++cmd_failed;
@@ -1155,7 +1149,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 	int rtn;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
+		if ((scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) ||
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
@@ -1296,61 +1290,6 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 	return list_empty(work_q);
 }
 
-
-/**
- * scsi_eh_abort_cmds - abort pending commands.
- * @work_q:	&list_head for pending commands.
- * @done_q:	&list_head for processed commands.
- *
- * Decription:
- *    Try and see whether or not it makes sense to try and abort the
- *    running command.  This only works out to be the case if we have one
- *    command that has timed out.  If the command simply failed, it makes
- *    no sense to try and abort the command, since as far as the shost
- *    adapter is concerned, it isn't running.
- */
-static int scsi_eh_abort_cmds(struct list_head *work_q,
-			      struct list_head *done_q)
-{
-	struct scsi_cmnd *scmd, *next;
-	LIST_HEAD(check_list);
-	int rtn;
-	struct Scsi_Host *shost;
-
-	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
-			continue;
-		shost = scmd->device->host;
-		if (scsi_host_eh_past_deadline(shost)) {
-			list_splice_init(&check_list, work_q);
-			SCSI_LOG_ERROR_RECOVERY(3,
-				scmd_printk(KERN_INFO, scmd,
-					    "%s: skip aborting cmd, past eh deadline\n",
-					    current->comm));
-			return list_empty(work_q);
-		}
-		SCSI_LOG_ERROR_RECOVERY(3,
-			scmd_printk(KERN_INFO, scmd,
-				     "%s: aborting cmd\n", current->comm));
-		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
-		if (rtn == FAILED) {
-			SCSI_LOG_ERROR_RECOVERY(3,
-				scmd_printk(KERN_INFO, scmd,
-					    "%s: aborting cmd failed\n",
-					     current->comm));
-			list_splice_init(&check_list, work_q);
-			return list_empty(work_q);
-		}
-		scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
-		if (rtn == FAST_IO_FAIL)
-			scsi_eh_finish_cmd(scmd, done_q);
-		else
-			list_move_tail(&scmd->eh_entry, &check_list);
-	}
-
-	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
-}
-
 /**
  * scsi_eh_try_stu - Send START_UNIT to device.
  * @scmd:	&scsi_cmnd to send START_UNIT
@@ -1693,11 +1632,6 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 		sdev_printk(KERN_INFO, scmd->device, "Device offlined - "
 			    "not ready after error recovery\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
-		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
-			/*
-			 * FIXME: Handle lost cmds.
-			 */
-		}
 		scsi_eh_finish_cmd(scmd, done_q);
 	}
 	return;
@@ -2139,8 +2073,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost, &eh_work_q));
 
 	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
-		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
-			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
+		scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->eh_deadline != -1)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 26f7dcf..9cbe33b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1647,7 +1647,7 @@ static void scsi_softirq_done(struct request *rq)
 			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 			break;
 		default:
-			scsi_eh_scmd_add(cmd, 0);
+			scsi_eh_scmd_add(cmd);
 			break;
 	}
 }
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b2d1a2b..1248e72 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -18,7 +18,6 @@ struct scsi_nl_hdr;
 /*
  * Scsi Error Handler Flags
  */
-#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
 #define SCSI_EH_ABORT_SCHEDULED	0x0002	/* Abort has been scheduled */
 
 #define SCSI_SENSE_VALID(scmd) \
@@ -72,7 +71,7 @@ extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
-extern void scsi_eh_scmd_add(struct scsi_cmnd *, int);
+extern void scsi_eh_scmd_add(struct scsi_cmnd *);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5e36248..4f4db75 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -460,11 +460,6 @@ struct scsi_host_template {
 	unsigned no_write_same:1;
 
 	/*
-	 * True if asynchronous aborts are not supported
-	 */
-	unsigned no_async_abort:1;
-
-	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
-- 
1.8.5.2

