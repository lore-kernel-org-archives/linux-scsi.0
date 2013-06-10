From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 09:40:52 +0200
Message-ID: <1370850058-27613-4-git-send-email-hare@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3FJHlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:03 -0400
In-Reply-To: <1370850058-27613-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

When a command runs into a timeout we need to send an 'ABORT TASK'
TMF. This is typically done by the 'eh_abort_handler' LLDD callback.

Conceptually, however, this function is a normal SCSI command, so
there is no need to enter the error handler.

This patch implements a new scsi_abort_command() function which
invokes an asynchronous function scsi_eh_abort_handler() to
abort the commands via 'eh_abort_handler'.

If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
command will be retried if possible. If no retries are allowed
the command will be returned immediately, as we have to assume
the TMF succeeded and the command is completed with the LLDD.
If the TMF fails the command will be pushed back onto the
list of failed commands and the SCSI EH handler will be
called immediately for all timed-out commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c        | 123 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_scan.c         |   3 +
 drivers/scsi/scsi_sysfs.c        |   5 ++
 drivers/scsi/scsi_transport_fc.c |   2 +-
 include/scsi/scsi_cmnd.h         |   1 +
 include/scsi/scsi_device.h       |   2 +
 6 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 96b4bb6..467cb3c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -55,6 +55,8 @@ static void scsi_eh_done(struct scsi_cmnd *scmd);
 #define HOST_RESET_SETTLE_TIME  (10)
 
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
+static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
+				 struct scsi_cmnd *scmd);
 
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
@@ -90,6 +92,125 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 EXPORT_SYMBOL_GPL(scsi_schedule_eh);
 
 /**
+ * scsi_eh_abort_handler - Handle command aborts
+ * @work:	sdev on which commands should be aborted.
+ */
+void
+scsi_eh_abort_handler(struct work_struct *work)
+{
+	struct scsi_device *sdev =
+		container_of(work, struct scsi_device, abort_work);
+	struct scsi_cmnd *scmd, *tmp;
+	LIST_HEAD(abort_list);
+	unsigned long flags;
+	int rtn;
+
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_splice_init(&sdev->eh_abort_list, &abort_list);
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+
+	list_for_each_entry_safe(scmd, tmp, &abort_list, eh_entry) {
+		list_del_init(&scmd->eh_entry);
+		if (sdev->sdev_state == SDEV_CANCEL) {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_INFO, scmd,
+				    "terminate, device removed\n"));
+			scmd->result |= DID_NO_CONNECT << 16;
+			scsi_finish_command(scmd);
+			continue;
+		}
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "aborting command %p\n", scmd));
+		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
+		if (rtn == FAILED) {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_INFO, scmd,
+					     "abort command failed\n"));
+			list_move_tail(&scmd->eh_entry, &abort_list);
+			goto start_eh;
+		}
+		if (!(scmd->request->cmd_flags & REQ_FAILFAST_DEV) &&
+		    (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) &&
+		    (++scmd->retries <= scmd->allowed)) {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_WARNING, scmd,
+					    "retry aborted command\n"));
+
+			scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_WARNING, scmd,
+					    "fast fail aborted command\n"));
+			scmd->result |= DID_TRANSPORT_FAILFAST << 16;
+			scsi_finish_command(scmd);
+		}
+	}
+
+	if (list_empty(&abort_list))
+		return;
+
+start_eh:
+	list_for_each_entry_safe(scmd, tmp, &abort_list, eh_entry) {
+		scmd->result |= DID_TIME_OUT << 16;
+		if (!scsi_eh_scmd_add(scmd, 0)) {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				scmd_printk(KERN_WARNING, scmd,
+					    "terminate aborted command\n"));
+			scsi_finish_command(scmd);
+		}
+	}
+}
+
+/**
+ * scsi_abort_command - schedule a command abort
+ * @scmd:	scmd to abort.
+ *
+ * We only need to abort commands after a command timeout
+ */
+enum blk_eh_timer_return
+scsi_abort_command(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	int kick_worker = 0;
+	struct scsi_device *sdev = scmd->device;
+
+	/*
+	 * Do not try a command abort if
+	 * SCSI EH has already started.
+	 */
+	if (scsi_host_in_recovery(sdev->host)) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "host in recovery, not aborting\n"));
+		scmd->result |= DID_TIME_OUT << 16;
+		scsi_eh_scmd_add(scmd, 0);
+		return BLK_EH_SCHEDULED;
+	}
+	if (sdev->sdev_state == SDEV_CANCEL ||
+	    sdev->sdev_state == SDEV_OFFLINE) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "device removed, terminating command\n"));
+		scmd->result |= DID_NO_CONNECT << 16;
+		scsi_finish_command(scmd);
+		return BLK_EH_SCHEDULED;
+	}
+
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	if (list_empty(&sdev->eh_abort_list))
+		kick_worker = 1;
+	list_add(&scmd->eh_entry, &sdev->eh_abort_list);
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	SCSI_LOG_ERROR_RECOVERY(3,
+		scmd_printk(KERN_INFO, scmd, "adding to eh_abort_list\n"));
+	if (kick_worker)
+		schedule_work(&sdev->abort_work);
+	return BLK_EH_SCHEDULED;
+}
+EXPORT_SYMBOL_GPL(scsi_abort_command);
+
+/**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
  * @eh_flag:	optional SCSI_EH flag.
@@ -145,11 +266,11 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	else if (host->hostt->eh_timed_out)
 		rtn = host->hostt->eh_timed_out(scmd);
 
-	scmd->result |= DID_TIME_OUT << 16;
 	/* Check for delayed EH scheduling */
 	if (rtn == BLK_EH_SCHEDULED)
 		return BLK_EH_NOT_HANDLED;
 
+	scmd->result |= DID_TIME_OUT << 16;
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
 		rtn = BLK_EH_HANDLED;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..f9cc6fc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -231,6 +231,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	extern void scsi_evt_thread(struct work_struct *work);
 	extern void scsi_requeue_run_queue(struct work_struct *work);
+	extern void scsi_eh_abort_handler(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -251,9 +252,11 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
+	INIT_LIST_HEAD(&sdev->eh_abort_list);
 	spin_lock_init(&sdev->list_lock);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
+	INIT_WORK(&sdev->abort_work, scsi_eh_abort_handler);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..af64c1c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -966,6 +966,11 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		put_device(&sdev->sdev_dev);
 
 	/*
+	 * Terminate timed-out commands
+	 */
+	flush_work(&sdev->abort_work);
+
+	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
 	 * scsi_run_queue() invocations have finished before tearing down the
 	 * device.
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e106c27..1e1de9f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2079,7 +2079,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
 	if (rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
-	return BLK_EH_NOT_HANDLED;
+	return scsi_abort_command(scmd);
 }
 
 /*
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index de5f5d8..d521694 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -144,6 +144,7 @@ extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
+extern enum blk_eh_timer_return scsi_abort_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index cc64587..e03d379 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -80,6 +80,7 @@ struct scsi_device {
 	spinlock_t list_lock;
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
+	struct list_head eh_abort_list;
 	struct scsi_cmnd *current_cmnd;	/* currently active command */
 	unsigned short queue_depth;	/* How deep of a queue we want */
 	unsigned short max_queue_depth;	/* max queue depth */
@@ -180,6 +181,7 @@ struct scsi_device {
 
 	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
+	struct work_struct	abort_work;
 
 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;
-- 
1.7.12.4

