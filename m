From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi_error update take 2
Date: Wed, 19 Feb 2003 01:09:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030219090919.GA2185@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e32.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1J97XtU024704
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2003 04:07:33 -0500
Received: from hmsbounty (sig-9-65-40-25.mts.ibm.com [9.65.40.25])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1J97U7E139692
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2003 02:07:31 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an update of a previous patch I posted.
http://marc.theaimsgroup.com/?l=linux-scsi&m=104495114103628&w=2

This patch is against scsi-misc-2.5

The updates from the last patch include:
	- Names changes:
		eh_cmd_list => eh_cmd_q
		eh_list => eh_entry

	- Move shost->in_recovery = 0

	- Switch from scsi_retry_command to scsi_queue_insert for retry
	  to solve fast completions / serial start of retries.

	- Use list_splice_init in scsi_unjam_host.

Sorry for the one large patch chunk :-(.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 hosts.c      |   20 --
 hosts.h      |    2 
 scsi.c       |   46 ++++
 scsi.h       |   11 -
 scsi_error.c |  550 +++++++++++++++++++++++++++++++----------------------------
 scsi_lib.c   |    2 
 scsi_syms.c  |    1 
 7 files changed, 351 insertions(+), 281 deletions(-)
-------

diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Tue Feb 18 09:13:11 2003
+++ b/drivers/scsi/hosts.c	Tue Feb 18 09:13:11 2003
@@ -397,6 +397,7 @@
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
 	INIT_LIST_HEAD(&shost->my_devices);
+	INIT_LIST_HEAD(&shost->eh_cmd_q);
 
 	init_waitqueue_head(&shost->host_wait);
 	shost->dma_channel = 0xff;
@@ -634,22 +635,9 @@
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
 	sdev->device_busy--;
-	if (shost->in_recovery && (shost->host_busy == shost->host_failed)) {
-		up(shost->eh_wait);
-		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
-					  " thread\n"));
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
-
-void scsi_host_failed_inc_and_test(struct Scsi_Host *shost)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->in_recovery = 1;
-	shost->host_failed++;
-	if (shost->host_busy == shost->host_failed) {
+	if (shost->in_recovery && shost->host_failed &&
+	    (shost->host_busy == shost->host_failed))
+	{
 		up(shost->eh_wait);
 		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
 					  " thread\n"));
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Tue Feb 18 09:13:11 2003
+++ b/drivers/scsi/hosts.h	Tue Feb 18 09:13:11 2003
@@ -384,6 +384,7 @@
     spinlock_t		  default_lock;
     spinlock_t		  *host_lock;
 
+    struct list_head	eh_cmd_q;
     struct task_struct    * ehandler;  /* Error recovery thread. */
     struct semaphore      * eh_wait;   /* The error recovery thread waits on
                                           this. */
@@ -587,7 +588,6 @@
  */
 extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
 extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
-extern void scsi_host_failed_inc_and_test(struct Scsi_Host *);
 
 /**
  * scsi_find_device - find a device given the host
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Tue Feb 18 09:13:12 2003
+++ b/drivers/scsi/scsi.c	Tue Feb 18 09:13:12 2003
@@ -790,13 +790,9 @@
 				if ((status_byte(SCpnt->result) & CHECK_CONDITION) != 0) {
 					SCSI_LOG_MLCOMPLETE(3, print_sense("bh", SCpnt));
 				}
-				if (SCpnt->device->host->eh_wait != NULL) {
-					scsi_eh_eflags_set(SCpnt, SCSI_EH_CMD_FAILED | SCSI_EH_CMD_ERR);
-					SCpnt->owner = SCSI_OWNER_ERROR_HANDLER;
-					SCpnt->state = SCSI_STATE_FAILED;
 
-					scsi_host_failed_inc_and_test(SCpnt->device->host);
-				} else {
+				if (!scsi_eh_scmd_add(SCpnt, 0))
+				{
 					/*
 					 * We only get here if the error
 					 * recovery thread has died.
@@ -1296,6 +1292,44 @@
 {
 	sdev->access_count--;
 	module_put(sdev->host->hostt->module);
+}
+
+/**
+ * scsi_set_device_offline - set scsi_device offline
+ * @sdev:	pointer to struct scsi_device to offline. 
+ *
+ * Locks:	host_lock held on entry.
+ **/
+void scsi_set_device_offline(struct scsi_device *sdev)
+{
+	struct scsi_cmnd *scmd;
+	int	cmds_active = 0;
+	unsigned long flags;
+
+	sdev->online = FALSE;
+
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_for_each_entry(scmd, &sdev->cmd_list, list) {
+		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE) {
+			/*
+			 * If we are unable to remove the timer, it means
+			 * that the command has already timed out or
+			 * finished.
+			 */
+			if (!scsi_delete_timer(scmd)) {
+				continue;
+			}
+
+			++cmds_active;
+
+			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+		}
+	}
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+
+	if (!cmds_active) {
+		/* FIXME: Send online state change hotplug event */
+	}
 }
 
 /*
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Tue Feb 18 09:13:11 2003
+++ b/drivers/scsi/scsi.h	Tue Feb 18 09:13:11 2003
@@ -455,6 +455,7 @@
 extern void scsi_slave_detach(struct scsi_device *);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
+extern void scsi_set_device_offline(struct scsi_device *);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);
@@ -726,6 +727,7 @@
 
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 
+	struct list_head eh_entry; /* entry for the host eh_cmd_q */
 	int eh_state;		/* Used for state tracking in error handlr */
 	int eh_eflags;		/* Used by error handlr */
 	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
@@ -850,6 +852,7 @@
  */
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
+#define SCSI_MLQUEUE_EH_RETRY    0x1057
 
 /*
  * old style reset request from external source
@@ -960,12 +963,12 @@
 /*
  * Scsi Error Handler Flags
  */
-#define SCSI_EH_CMD_ERR	0x0001	/* Orig cmd error'd */
-#define SCSI_EH_CMD_FAILED	0x0002	/* Orig cmd error type failed */
-#define SCSI_EH_CMD_TIMEOUT	0x0004	/* Orig cmd error type timeout */
-#define SCSI_EH_REC_TIMEOUT	0x0008	/* Recovery cmd timeout */
+#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
+#define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */
 
 #define SCSI_SENSE_VALID(scmd) ((scmd->sense_buffer[0] & 0x70) == 0x70)
+
+extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
 
 int scsi_set_medium_removal(Scsi_Device *dev, char state);
 
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Tue Feb 18 09:13:11 2003
+++ b/drivers/scsi/scsi_error.c	Tue Feb 18 09:13:11 2003
@@ -56,6 +56,49 @@
 #define HOST_RESET_SETTLE_TIME  10*HZ
 
 /**
+ * scsi_eh_scmd_add - add scsi cmd to error handling.
+ * @scmd:	scmd to run eh on.
+ * @eh_flag:	optional SCSI_EH flag.
+ *
+ * Return value:
+ *	0 on failure.
+ **/
+int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
+{
+	struct Scsi_Host *shost = scmd->device->host;
+	unsigned long flags;
+
+	if (shost->eh_wait == NULL)
+		return 0;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	scsi_eh_eflags_set(scmd, eh_flag);
+	/*
+	 * FIXME: Can we stop setting owner and state.
+	 */
+	scmd->owner = SCSI_OWNER_ERROR_HANDLER;
+	scmd->state = SCSI_STATE_FAILED;
+	/*
+	 * Set the serial_number_at_timeout to the current
+	 * serial_number
+	 */
+	scmd->serial_number_at_timeout = scmd->serial_number;
+	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
+	shost->in_recovery = 1;
+	shost->host_failed++;
+	if (shost->host_busy == shost->host_failed) {
+		up(shost->eh_wait);
+		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
+					  " thread\n"));
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return 1;
+}
+
+/**
  * scsi_add_timer - Start timeout timer for a single scsi command.
  * @scmd:	scsi command that is about to start running.
  * @timeout:	amount of time to allow this command to run.
@@ -131,22 +174,14 @@
  **/
 void scsi_times_out(Scsi_Cmnd *scmd)
 {
-	struct Scsi_Host *shost = scmd->device->host;
-
-	/* Set the serial_number_at_timeout to the current serial_number */
-	scmd->serial_number_at_timeout = scmd->serial_number;
-
-	scsi_eh_eflags_set(scmd, SCSI_EH_CMD_TIMEOUT | SCSI_EH_CMD_ERR);
-
-	if (unlikely(shost->eh_wait == NULL)) {
+	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		panic("Error handler thread not present at %p %p %s %d",
-		      scmd, shost, __FILE__, __LINE__);
+		      scmd, scmd->device->host, __FILE__, __LINE__);
 	}
 
-	scsi_host_failed_inc_and_test(shost);
-
 	SCSI_LOG_TIMEOUT(3, printk("Command timed out busy=%d failed=%d\n",
-				   shost->host_busy, shost->host_failed));
+				   scmd->device->host->host_busy,
+				   scmd->device->host->host_failed));
 }
 
 /**
@@ -173,39 +208,40 @@
 #if CONFIG_SCSI_LOGGING
 /**
  * scsi_eh_prt_fail_stats - Log info on failures.
- * @sc_list:	List for failed cmds.
  * @shost:	scsi host being recovered.
+ * @work_q:	Queue of scsi cmds to process.
  **/
-static void scsi_eh_prt_fail_stats(Scsi_Cmnd *sc_list, struct Scsi_Host *shost)
+static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
+					  struct list_head *work_q)
 {
-	Scsi_Cmnd *scmd;
-	Scsi_Device *sdev;
+	struct scsi_cmnd *scmd;
+	struct scsi_device *sdev;
 	int total_failures = 0;
 	int cmd_failed = 0;
-	int cmd_timed_out = 0;
+	int cmd_cancel = 0;
 	int devices_failed = 0;
 
 
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		for (scmd = sc_list; scmd; scmd = scmd->bh_next) {
+		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (scmd->device == sdev) {
 				++total_failures;
 				if (scsi_eh_eflags_chk(scmd,
-						       SCSI_EH_CMD_TIMEOUT))
-					++cmd_timed_out;
-				else
+						       SCSI_EH_CANCEL_CMD))
+					++cmd_cancel;
+				else 
 					++cmd_failed;
 			}
 		}
 
-		if (cmd_timed_out || cmd_failed) {
+		if (cmd_cancel || cmd_failed) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				printk("%s: %d:%d:%d:%d cmds failed: %d,"
-				       " timedout: %d\n",
+				       " cancel: %d\n",
 				       __FUNCTION__, shost->host_no,
 				       sdev->channel, sdev->id, sdev->lun,
-				       cmd_failed, cmd_timed_out));
-			cmd_timed_out = 0;
+				       cmd_failed, cmd_cancel));
+			cmd_cancel = 0;
 			cmd_failed = 0;
 			++devices_failed;
 		}
@@ -218,68 +254,6 @@
 #endif
 
 /**
- * scsi_eh_get_failed - Gather failed cmds.
- * @sc_list:	A pointer to a list for failed cmds.
- * @shost:	Scsi host being recovered.
- *
- * XXX Add opaque interator for device / shost. Investigate direct
- * addition to per eh list on error allowing skipping of this step.
- **/
-static void scsi_eh_get_failed(Scsi_Cmnd **sc_list, struct Scsi_Host *shost)
-{
-	int found;
-	Scsi_Device *sdev;
-	Scsi_Cmnd *scmd;
-
-	found = 0;
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&sdev->list_lock, flags);
-		list_for_each_entry(scmd, &sdev->cmd_list, list) {
-			if (scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR)) {
-				scmd->bh_next = *sc_list;
-				*sc_list = scmd;
-				found++;
-			} else {
-				/*
-				 * FIXME Verify how this can happen and if
-				 * this is still needed??
-				 */
-			    if (scmd->state != SCSI_STATE_INITIALIZING
-			    && scmd->state != SCSI_STATE_UNUSED) {
-				/*
-				 * Rats.  Something is still floating
-				 * around out there This could be the
-				 * result of the fact that the upper level
-				 * drivers are still frobbing commands
-				 * that might have succeeded.  There are
-				 * two outcomes. One is that the command
-				 * block will eventually be freed, and the
-				 * other one is that the command will be
-				 * queued and will be finished along the
-				 * way.
-				 */
-				SCSI_LOG_ERROR_RECOVERY(1, printk("Error hdlr"
-							  " prematurely woken"
-							  " cmds still active"
-							  " (%p %x %d)\n",
-					       scmd, scmd->state,
-					       scmd->device->id));
-				}
-			}
-		}
-		spin_unlock_irqrestore(&sdev->list_lock, flags);
-	}
-
-	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(*sc_list, shost));
-
-	if (shost->host_failed != found)
-		printk(KERN_ERR "%s: host_failed: %d != found: %d\n", 
-		       __FUNCTION__, shost->host_failed, found);
-}
-
-/**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
  *
@@ -535,7 +509,8 @@
 			spin_lock_irqsave(scmd->device->host->host_lock, flags);
 			if (scmd->device->host->hostt->eh_abort_handler)
 				scmd->device->host->hostt->eh_abort_handler(scmd);
-			spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+			spin_unlock_irqrestore(scmd->device->host->host_lock,
+					       flags);
 			
 			scmd->request->rq_status = RQ_SCSI_DONE;
 			scmd->owner = SCSI_OWNER_ERROR_HANDLER;
@@ -676,7 +651,7 @@
 /**
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
- * @shost:	SCSI host that cmd originally failed on.
+ * @done_q:	Queue for processed commands.
  *
  * Notes:
  *    We don't want to use the normal command completion while we are are
@@ -685,9 +660,10 @@
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
  **/
-static void scsi_eh_finish_cmd(Scsi_Cmnd *scmd, struct Scsi_Host *shost)
+static void scsi_eh_finish_cmd(Scsi_Cmnd *scmd,
+			       struct list_head *done_q )
 {
-	shost->host_failed--;
+	scmd->device->host->host_failed--;
 	scmd->state = SCSI_STATE_BHQUEUE;
 	scsi_eh_eflags_clr_all(scmd);
 
@@ -696,12 +672,14 @@
 	 * things.
 	 */
 	scsi_setup_cmd_retry(scmd);
+
+	list_move_tail(&scmd->eh_entry, done_q);
 }
 
 /**
  * scsi_eh_get_sense - Get device sense data.
- * @sc_todo:	list of cmds that have failed.
- * @shost:	scsi host being recovered.
+ * @work_q:	Queue of commands to process.
+ * @done_q:	Queue of proccessed commands..
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
@@ -719,23 +697,23 @@
  *
  *    In 2.5 this capability will be going away.
  **/
-static int scsi_eh_get_sense(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_get_sense(struct list_head *work_q,
+			     struct list_head *done_q)
 {
 	int rtn;
+	struct list_head *lh, *lh_sf;
 	Scsi_Cmnd *scmd;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: checking to see if we need"
-					  " to request sense\n",
-					  __FUNCTION__));
-
-	for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_FAILED) ||
+	list_for_each_safe(lh, lh_sf, work_q) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD) ||
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(2, printk("%s: requesting sense"
-						  " for tgt: %d\n",
-						  __FUNCTION__, scmd->device->id));
+						  " for id: %d\n",
+						  current->comm,
+						  scmd->device->id));
 		rtn = scsi_request_sense(scmd);
 		if (rtn != SUCCESS)
 			continue;
@@ -752,7 +730,7 @@
 		 * upper level.
 		 */
 		if (rtn == SUCCESS)
-			scsi_eh_finish_cmd(scmd, shost);
+			scsi_eh_finish_cmd(scmd, done_q);
 		if (rtn != NEEDS_RETRY)
 			continue;
 
@@ -771,10 +749,10 @@
 		/*
 		 * we eventually hand this one back to the top level.
 		 */
-		scsi_eh_finish_cmd(scmd, shost);
+		scsi_eh_finish_cmd(scmd, done_q);
 	}
 
-	return shost->host_failed;
+	return list_empty(work_q);
 }
 
 /**
@@ -864,9 +842,9 @@
 }
 
 /**
- * scsi_eh_abort_cmd - abort a timed-out cmd.
- * @sc_todo:	A list of cmds that have failed.
+ * scsi_eh_abort_cmds - abort canceled commands.
  * @shost:	scsi host being recovered.
+ * @eh_done_q:	list_head for processed commands.
  *
  * Decription:
  *    Try and see whether or not it makes sense to try and abort the
@@ -875,29 +853,36 @@
  *    no sense to try and abort the command, since as far as the shost
  *    adapter is concerned, it isn't running.
  **/
-static int scsi_eh_abort_cmd(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_abort_cmds(struct list_head *work_q,
+			      struct list_head *done_q)
 {
-
 	int rtn;
-	Scsi_Cmnd *scmd;
+	struct list_head *lh, *lh_sf;
+	struct scsi_cmnd *scmd;
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: checking to see if we need"
-					  " to abort cmd\n", __FUNCTION__));
-
-	for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_TIMEOUT))
+	list_for_each_safe(lh, lh_sf, work_q) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD))
 			continue;
-
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
+						  "0x%p\n", current->comm,
+						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd);
 		if (rtn == SUCCESS) {
-			if (!scsi_eh_tur(scmd)) {
-				rtn = scsi_eh_retry_cmd(scmd);
-				if (rtn == SUCCESS)
-					scsi_eh_finish_cmd(scmd, shost);
+			scsi_eh_eflags_clr(scmd,  SCSI_EH_CANCEL_CMD);
+			if (!scmd->device->online || !scsi_eh_tur(scmd)) {
+				scsi_eh_finish_cmd(scmd, done_q);
 			}
-		}
+				
+		} else
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
+							  " cmd failed:"
+							  "0x%p\n",
+							  current->comm,
+							  scmd));
 	}
-	return shost->host_failed;
+
+	return list_empty(work_q);
 }
 
 /**
@@ -933,9 +918,9 @@
 }
 
 /**
- * scsi_eh_bus_device_reset - send bdr is needed
- * @sc_todo:	a list of cmds that have failed.
+ * scsi_eh_bus_device_reset - send bdr if needed
  * @shost:	scsi host being recovered.
+ * @eh_done_q:	list_head for processed commands.
  *
  * Notes:
  *    Try a bus device reset.  still, look to see whether we have multiple
@@ -943,39 +928,52 @@
  *    makes no sense to try bus_device_reset - we really would need to try
  *    a bus_reset instead. 
  **/
-static int scsi_eh_bus_device_reset(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
+				    struct list_head *work_q,
+				    struct list_head *done_q)
 {
 	int rtn;
-	Scsi_Cmnd *scmd;
-	Scsi_Device *sdev;
-
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Trying BDR\n", __FUNCTION__));
+	struct list_head *lh, *lh_sf;
+	struct scsi_cmnd *scmd, *bdr_scmd;
+	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		for (scmd = sc_todo; scmd; scmd = scmd->bh_next)
-			if ((scmd->device == sdev) &&
-			    scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
+		bdr_scmd = NULL;
+		list_for_each_entry(scmd, work_q, eh_entry)
+			if (scmd->device == sdev) {
+				bdr_scmd = scmd;
 				break;
+			}
 
-		if (!scmd)
+		if (!bdr_scmd)
 			continue;
 
-		/*
-		 * ok, we have a device that is having problems.  try and send
-		 * a bus device reset to it.
-		 */
-		rtn = scsi_try_bus_device_reset(scmd);
-		if ((rtn == SUCCESS) && (!scsi_eh_tur(scmd)))
-				for (scmd = sc_todo; scmd; scmd = scmd->bh_next)
-					if ((scmd->device == sdev) &&
-					    scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR)) {
-						rtn = scsi_eh_retry_cmd(scmd);
-						if (rtn == SUCCESS)
-							scsi_eh_finish_cmd(scmd, shost);
-					}
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BDR sdev:"
+						  " 0x%p\n", current->comm,
+						  sdev));
+		rtn = scsi_try_bus_device_reset(bdr_scmd);
+		if (rtn == SUCCESS) {
+			if (!sdev->online || !scsi_eh_tur(bdr_scmd)) {
+				list_for_each_safe(lh, lh_sf,
+						   work_q) {
+					scmd = list_entry(lh, struct
+							  scsi_cmnd,
+							  eh_entry);
+					if (scmd->device == sdev)
+						scsi_eh_finish_cmd(scmd,
+								   done_q);
+				}
+			}
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BDR"
+							  " failed sdev:"
+							  "0x%p\n",
+							  current->comm,
+							   sdev));
+		}
 	}
 
-	return shost->host_failed;
+	return list_empty(work_q);
 }
 
 /**
@@ -1005,7 +1003,8 @@
 		/*
 		 * Mark all affected devices to expect a unit attention.
 		 */
-		list_for_each_entry(sdev, &scmd->device->host->my_devices, siblings)
+		list_for_each_entry(sdev, &scmd->device->host->my_devices,
+				    siblings)
 			if (scmd->device->channel == sdev->channel) {
 				sdev->was_reset = 1;
 				sdev->expecting_cc_ua = 1;
@@ -1041,7 +1040,8 @@
 		/*
 		 * Mark all affected devices to expect a unit attention.
 		 */
-		list_for_each_entry(sdev, &scmd->device->host->my_devices, siblings)
+		list_for_each_entry(sdev, &scmd->device->host->my_devices,
+				    siblings)
 			if (scmd->device->channel == sdev->channel) {
 				sdev->was_reset = 1;
 				sdev->expecting_cc_ua = 1;
@@ -1051,26 +1051,21 @@
 }
 
 /**
- * scsi_eh_bus_host_reset - send a bus reset and on failure try host reset
- * @sc_todo:	a list of cmds that have failed.
+ * scsi_eh_bus_reset - send a bus reset 
  * @shost:	scsi host being recovered.
+ * @eh_done_q:	list_head for processed commands.
  **/
-static int scsi_eh_bus_host_reset(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static int scsi_eh_bus_reset(struct Scsi_Host *shost,
+			     struct list_head *work_q,
+			     struct list_head *done_q)
 {
 	int rtn;
+	struct list_head *lh, *lh_sf;
 	Scsi_Cmnd *scmd;
 	Scsi_Cmnd *chan_scmd;
 	unsigned int channel;
 
 	/*
-	 * if we ended up here, we have serious problems.  the only thing left
-	 * to try is a full bus reset.  if someone has grabbed the bus and isn't
-	 * letting go, then perhaps this will help.
-	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Try Bus/Host RST\n",
-					  __FUNCTION__));
-
-	/* 
 	 * we really want to loop over the various channels, and do this on
 	 * a channel by channel basis.  we should also check to see if any
 	 * of the failed commands are on soft_reset devices, and if so, skip
@@ -1078,9 +1073,8 @@
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
-		for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-			if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
-				continue;
+		chan_scmd = NULL;
+		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (channel == scmd->device->channel) {
 				chan_scmd = scmd;
 				break;
@@ -1091,63 +1085,95 @@
 			}
 		}
 
-		if (!scmd)
+		if (!chan_scmd)
 			continue;
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BRST chan:"
+						  " %d\n", current->comm,
+						  channel));
+		rtn = scsi_try_bus_reset(chan_scmd);
+		if (rtn == SUCCESS) {
+			list_for_each_safe(lh, lh_sf, work_q) {
+				scmd = list_entry(lh, struct scsi_cmnd,
+						  eh_entry);
+				if (channel == scmd->device->channel)
+					if (!scmd->device->online ||
+					    !scsi_eh_tur(scmd))
+						scsi_eh_finish_cmd(scmd,
+								   done_q);
+			}
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BRST"
+							  " failed chan: %d\n",
+							  current->comm,
+							  channel));
+		}
+	}
+	return list_empty(work_q);
+}
 
-		/*
-		 * we now know that we are able to perform a reset for the
-		 * channel that scmd points to.
-		 */
-		rtn = scsi_try_bus_reset(scmd);
-		if (rtn != SUCCESS)
-			rtn = scsi_try_host_reset(scmd);
+/**
+ * scsi_eh_host_reset - send a host reset 
+ * @work_q:	list_head for processed commands.
+ * @done_q:	list_head for processed commands.
+ **/
+static int scsi_eh_host_reset(struct list_head *work_q,
+			      struct list_head *done_q)
+{
+	int rtn;
+	struct list_head *lh, *lh_sf;
+	Scsi_Cmnd *scmd;
 
-		if (rtn == SUCCESS) {
-			for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-				if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR)
-				    || channel != scmd->device->channel)
-					continue;
-				if (!scsi_eh_tur(scmd)) {
-					rtn = scsi_eh_retry_cmd(scmd);
+	if (!list_empty(work_q)) {
+		scmd = list_entry(work_q->next,
+				  struct scsi_cmnd, eh_entry);
 
-					if (rtn == SUCCESS)
-						scsi_eh_finish_cmd(scmd, shost);
-				}
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending HRST\n"
+						  , current->comm));
+
+		rtn = scsi_try_host_reset(scmd);
+		if (rtn == SUCCESS) {
+			list_for_each_safe(lh, lh_sf, work_q) {
+				scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+				if (!scmd->device->online || !scsi_eh_tur(scmd)) 
+					scsi_eh_finish_cmd(scmd, done_q);
 			}
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: HRST"
+							  " failed\n",
+							  current->comm));
 		}
-
 	}
-	return shost->host_failed;
+	return list_empty(work_q);
 }
 
 /**
  * scsi_eh_offline_sdevs - offline scsi devices that fail to recover
- * @sc_todo:	a list of cmds that have failed.
- * @shost:	scsi host being recovered.
+ * @work_q:	list_head for processed commands.
+ * @done_q:	list_head for processed commands.
  *
  **/
-static void scsi_eh_offline_sdevs(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
+static void scsi_eh_offline_sdevs(struct list_head *work_q,
+				  struct list_head *done_q)
 {
+	struct list_head *lh, *lh_sf;
 	Scsi_Cmnd *scmd;
 
-	for (scmd = sc_todo; scmd; scmd = scmd->bh_next) {
-		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
-			continue;
-
+	list_for_each_safe(lh, lh_sf, work_q) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
 		printk(KERN_INFO "scsi: Device offlined - not"
-				" ready or command retry failed"
-				" after error recovery: host"
+		       		" ready after error recovery: host"
 				" %d channel %d id %d lun %d\n",
-				shost->host_no,
+				scmd->device->host->host_no,
 				scmd->device->channel,
 				scmd->device->id,
 				scmd->device->lun);
-
-		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_TIMEOUT))
-			scmd->result |= (DRIVER_TIMEOUT << 24);
-
-		scmd->device->online = 0;
-		scsi_eh_finish_cmd(scmd, shost);
+		scmd->device->online = FALSE;
+		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
+			/*
+			 * FIXME: Handle lost cmds.
+			 */
+		}
+		scsi_eh_finish_cmd(scmd, done_q);
 	}
 	return;
 }
@@ -1459,6 +1485,8 @@
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
 					  __FUNCTION__));
 
+	shost->in_recovery = 0;
+
 	wake_up(&shost->host_wait);
 
 	/*
@@ -1482,6 +1510,55 @@
 }
 
 /**
+ * scsi_eh_ready_devs - check device ready state and recover if not.
+ * @shost: 	host to be recovered.
+ * @eh_done_q:	list_head for processed commands.
+ *
+ **/
+static void scsi_eh_ready_devs(struct Scsi_Host *shost,
+			       struct list_head *work_q,
+			       struct list_head *done_q)
+{
+	if (scsi_eh_bus_device_reset(shost, work_q, done_q))
+		if (scsi_eh_bus_reset(shost, work_q, done_q))
+			if (scsi_eh_host_reset(work_q, done_q))
+				scsi_eh_offline_sdevs(work_q, done_q);
+}
+
+/**
+ * scsi_eh_flush_done_q - finish processed commands or retry them.
+ * @done_q:	list_head of processed commands.
+ *
+ **/
+static void scsi_eh_flush_done_q(struct list_head *done_q)
+{
+	struct list_head *lh, *lh_sf;
+	Scsi_Cmnd *scmd;
+
+	list_for_each_safe(lh, lh_sf, done_q) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+		list_del_init(lh);
+		if (!scmd->device->online) {
+			 scmd->result |= (DRIVER_TIMEOUT << 24);
+		} else {
+			if (++scmd->retries < scmd->allowed) {
+				SCSI_LOG_ERROR_RECOVERY(3,
+					printk("%s: flush retry"
+					       " cmd: %p\n",
+						  current->comm,
+						  scmd));
+				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+				continue;
+			}
+		}
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
+				       " cmd: %p\n",
+					  current->comm, scmd));
+		scsi_finish_command(scmd);
+	}
+}
+
+/**
  * scsi_unjam_host - Attempt to fix a host which has a cmd that failed.
  * @shost:	Host to unjam.
  *
@@ -1506,60 +1583,21 @@
  **/
 static void scsi_unjam_host(struct Scsi_Host *shost)
 {
-	Scsi_Cmnd *sc_todo = NULL;
-	Scsi_Cmnd *scmd;
-
-	/*
-	 * Is this assert really ok anymore (andmike). Should we at least
-	 * be using spin_lock_unlocked.
-	 */
-	ASSERT_LOCK(shost->host_lock, 0);
-
-	scsi_eh_get_failed(&sc_todo, shost);
-
-	if (scsi_eh_get_sense(sc_todo, shost))
-		if (scsi_eh_abort_cmd(sc_todo, shost))
-			if (scsi_eh_bus_device_reset(sc_todo, shost))
-				if (scsi_eh_bus_host_reset(sc_todo, shost))
-					scsi_eh_offline_sdevs(sc_todo, shost);
-
-	BUG_ON(shost->host_failed);
+	unsigned long flags;
+	LIST_HEAD(eh_work_q);
+	LIST_HEAD(eh_done_q);
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	/*
-	 * We are currently holding these things in a linked list - we
-	 * didn't put them in the bottom half queue because we wanted to
-	 * keep things quiet while we were working on recovery, and
-	 * passing them up to the top level could easily cause the top
-	 * level to try and queue something else again.
-	 *
-	 * start by marking that the host is no longer in error recovery.
-	 */
-	shost->in_recovery = 0;
+	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost, &eh_work_q));
 
-	/*
-	 * take the list of commands, and stick them in the bottom half queue.
-	 * the current implementation of scsi_done will do this for us - if need
-	 * be we can create a special version of this function to do the
-	 * same job for us.
-	 */
-	for (scmd = sc_todo; scmd; scmd = sc_todo) {
-		sc_todo = scmd->bh_next;
-		scmd->bh_next = NULL;
-		/*
-		 * Oh, this is a vile hack.  scsi_done() expects a timer
-		 * to be running on the command.  If there isn't, it assumes
-		 * that the command has actually timed out, and a timer
-		 * handler is running.  That may well be how we got into
-		 * this fix, but right now things are stable.  We add
-		 * a timer back again so that we can report completion.
-		 * scsi_done() will immediately remove said timer from
-		 * the command, and then process it.
-		 */
-		scsi_add_timer(scmd, 100, scsi_eh_times_out);
-		scsi_done(scmd);
-	}
+	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
+		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
+			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
 
+	scsi_eh_flush_done_q(&eh_done_q);
 }
 
 /**
@@ -1597,7 +1635,8 @@
 	/*
 	 * Wake up the thread that created us.
 	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of scsi_eh_%d\n",shost->host_no));
+	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
+					  " scsi_eh_%d\n",shost->host_no));
 
 	complete(shost->eh_notify);
 
@@ -1607,7 +1646,9 @@
 		 * away and die.  This typically happens if the user is
 		 * trying to unload a module.
 		 */
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d sleeping\n",shost->host_no));
+		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
+						  " scsi_eh_%d"
+						  " sleeping\n",shost->host_no));
 
 		/*
 		 * Note - we always use down_interruptible with the semaphore
@@ -1622,7 +1663,9 @@
 		if (shost->eh_kill)
 			break;
 
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d waking up\n",shost->host_no));
+		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
+						  " scsi_eh_%d waking"
+						  " up\n",shost->host_no));
 
 		shost->eh_active = 1;
 
@@ -1650,7 +1693,8 @@
 
 	}
 
-	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d exiting\n",shost->host_no));
+	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d"
+					  " exiting\n",shost->host_no));
 
 	/*
 	 * Make sure that nobody tries to wake us up again.
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Tue Feb 18 09:13:12 2003
+++ b/drivers/scsi/scsi_lib.c	Tue Feb 18 09:13:12 2003
@@ -117,7 +117,7 @@
 	 */
 	if (reason == SCSI_MLQUEUE_HOST_BUSY)
 		host->host_blocked = host->max_host_blocked;
-	else
+	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
 		device->device_blocked = device->max_device_blocked;
 
 	/*
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Tue Feb 18 09:13:11 2003
+++ b/drivers/scsi/scsi_syms.c	Tue Feb 18 09:13:11 2003
@@ -80,6 +80,7 @@
 EXPORT_SYMBOL(scsi_slave_detach);
 EXPORT_SYMBOL(scsi_device_get);
 EXPORT_SYMBOL(scsi_device_put);
+EXPORT_SYMBOL(scsi_set_device_offline);
 
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.

