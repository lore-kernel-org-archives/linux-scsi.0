From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 2/2] qla1280: error recovery rewrite
Date: Wed, 08 Apr 2009 14:34:33 -0500
Message-ID: <49DCFC49.8030908@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:56858 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbZDHTef (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Apr 2009 15:34:35 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A57C8F8049
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2009 12:34:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Jes Sorensen <jes@sgi.com>

The driver now waits for the scsi commands associated with a
particular error recovery step to be returned to the mid-layer,
and returns the appropriate SUCCESS or FAILED status.  Removes
unneeded polling of chip for interrupts.

This patch also bumps the driver version number.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- a/drivers/scsi/qla1280.c	2009-04-08 10:28:55.646489186 -0500
+++ b/drivers/scsi/qla1280.c	2009-04-08 10:38:52.382493685 -0500
@@ -17,9 +17,12 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.26"
+#define QLA1280_VERSION      "3.27"
 /*****************************************************************************
     Revision History:
+    Rev  3.27, February 10, 2009, Michael Reed
+	- General code cleanup.
+	- Improve error recovery.
     Rev  3.26, January 16, 2006 Jes Sorensen
 	- Ditch all < 2.6 support
     Rev  3.25.1, February 10, 2005 Christoph Hellwig
@@ -718,6 +721,8 @@ qla1280_queuecommand(struct scsi_cmnd *c
 	cmd->scsi_done = fn;
 	sp->cmd = cmd;
 	sp->flags = 0;
+	sp->wait = NULL;
+	CMD_HANDLE(cmd) = (unsigned char *)NULL;
 
 	qla1280_print_scsi_cmd(5, cmd);
 
@@ -742,14 +747,6 @@ enum action {
 	ADAPTER_RESET,
 };
 
-/* timer action for error action processor */
-static void qla1280_error_wait_timeout(unsigned long __data)
-{
-	struct scsi_cmnd *cmd = (struct scsi_cmnd *)__data;
-	struct srb *sp = (struct srb *)CMD_SP(cmd);
-
-	complete(sp->wait);
-}
 
 static void qla1280_mailbox_timeout(unsigned long __data)
 {
@@ -764,6 +761,65 @@ static void qla1280_mailbox_timeout(unsi
 	complete(ha->mailbox_wait);
 }
 
+static int
+_qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *sp,
+				 struct completion *wait)
+{
+	int	status = FAILED;
+	struct scsi_cmnd *cmd = sp->cmd;
+
+	spin_unlock_irq(ha->host->host_lock);
+	wait_for_completion_timeout(wait, 4*HZ);
+	spin_lock_irq(ha->host->host_lock);
+	sp->wait = NULL;
+	if(CMD_HANDLE(cmd) == COMPLETED_HANDLE) {
+		status = SUCCESS;
+		(*cmd->scsi_done)(cmd);
+	}
+	return status;
+}
+
+static int
+qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *sp)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	sp->wait = &wait;
+	return _qla1280_wait_for_single_command(ha, sp, &wait);
+}
+
+static int
+qla1280_wait_for_pending_commands(struct scsi_qla_host *ha, int bus, int target)
+{
+	int		cnt;
+	int		status;
+	struct srb	*sp;
+	struct scsi_cmnd *cmd;
+
+	status = SUCCESS;
+
+	/*
+	 * Wait for all commands with the designated bus/target
+	 * to be completed by the firmware
+	 */
+	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = ha->outstanding_cmds[cnt];
+		if (sp) {
+			cmd = sp->cmd;
+
+			if (bus >= 0 && SCSI_BUS_32(cmd) != bus)
+				continue;
+			if (target >= 0 && SCSI_TCN_32(cmd) != target)
+				continue;
+
+			status = qla1280_wait_for_single_command(ha, sp);
+			if (status == FAILED)
+				break;
+		}
+	}
+	return status;
+}
+
 /**************************************************************************
  * qla1280_error_action
  *    The function will attempt to perform a specified error action and
@@ -777,11 +833,6 @@ static void qla1280_mailbox_timeout(unsi
  * Returns:
  *      SUCCESS or FAILED
  *
- * Note:
- *      Resetting the bus always succeeds - is has to, otherwise the
- *      kernel will panic! Try a surgical technique - sending a BUS
- *      DEVICE RESET message - on the offending target before pulling
- *      the SCSI bus reset line.
  **************************************************************************/
 static int
 qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
@@ -789,15 +840,19 @@ qla1280_error_action(struct scsi_cmnd *c
 	struct scsi_qla_host *ha;
 	int bus, target, lun;
 	struct srb *sp;
-	uint16_t data;
-	unsigned char *handle;
-	int result, i;
+	int i, found;
+	int result=FAILED;
+	int wait_for_bus=-1;
+	int wait_for_target = -1;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	struct timer_list timer;
 
 	ENTER("qla1280_error_action");
 
 	ha = (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
+	sp = (struct srb *)CMD_SP(cmd);
+	bus = SCSI_BUS_32(cmd);
+	target = SCSI_TCN_32(cmd);
+	lun = SCSI_LUN_32(cmd);
 
 	dprintk(4, "error_action %i, istatus 0x%04x\n", action,
 		RD_REG_WORD(&ha->iobase->istatus));
@@ -811,73 +866,42 @@ qla1280_error_action(struct scsi_cmnd *c
 		       "Handle=0x%p, action=0x%x\n",
 		       ha->host_no, cmd, CMD_HANDLE(cmd), action);
 
-	sp = (struct srb *)CMD_SP(cmd);
-	handle = CMD_HANDLE(cmd);
-
-	/* Check for pending interrupts. */
-	data = qla1280_debounce_register(&ha->iobase->istatus);
-	/*
-	 * The io_request_lock is held when the reset handler is called, hence
-	 * the interrupt handler cannot be running in parallel as it also
-	 * grabs the lock. /Jes
-	 */
-	if (data & RISC_INT)
-		qla1280_isr(ha, &ha->done_q);
-
 	/*
-	 * Determine the suggested action that the mid-level driver wants
-	 * us to perform.
+	 * Check to see if we have the command in the outstanding_cmds[]
+	 * array.  If not then it must have completed before this error
+	 * action was initiated.  If the error_action isn't ABORT_COMMAND
+	 * then the driver must proceed with the requested action.
 	 */
-	if (handle == (unsigned char *)INVALID_HANDLE || handle == NULL) {
-		if(action == ABORT_COMMAND) {
-			/* we never got this command */
-			printk(KERN_INFO "qla1280: Aborting a NULL handle\n");
-			return SUCCESS;	/* no action - we don't have command */
+	found = -1;
+	for (i = 0; i < MAX_OUTSTANDING_COMMANDS; i++) {
+		if (sp == ha->outstanding_cmds[i]) {
+			found = i;
+			sp->wait = &wait; /* we'll wait for it to complete */
+			break;
 		}
-	} else {
-		sp->wait = &wait;
 	}
 
-	bus = SCSI_BUS_32(cmd);
-	target = SCSI_TCN_32(cmd);
-	lun = SCSI_LUN_32(cmd);
+	if (found < 0) {	/* driver doesn't have command */
+		result = SUCCESS;
+		if (qla1280_verbose) {
+			printk(KERN_INFO
+			       "scsi(%ld:%d:%d:%d): specified command has "
+			       "already completed.\n", ha->host_no, bus,
+				target, lun);
+		}
+	}
 
-	/* Overloading result.  Here it means the success or fail of the
-	 * *issue* of the action.  When we return from the routine, it must
-	 * mean the actual success or fail of the action */
-	result = FAILED;
 	switch (action) {
-	case ABORT_COMMAND:
-		if ((sp->flags & SRB_ABORT_PENDING)) {
-			printk(KERN_WARNING
-			       "scsi(): Command has a pending abort "
-			       "message - ABORT_PENDING.\n");
-			/* This should technically be impossible since we
-			 * now wait for abort completion */
-			break;
-		}
 
-		for (i = 0; i < MAX_OUTSTANDING_COMMANDS; i++) {
-			if (sp == ha->outstanding_cmds[i]) {
-				dprintk(1, "qla1280: RISC aborting command\n");
-				if (qla1280_abort_command(ha, sp, i) == 0)
-					result = SUCCESS;
-				else {
-					/*
-					 * Since we don't know what might
-					 * have happend to the command, it
-					 * is unsafe to remove it from the
-					 * device's queue at this point.
-					 * Wait and let the escalation
-					 * process take care of it.
-					 */
-					printk(KERN_WARNING
-					       "scsi(%li:%i:%i:%i): Unable"
-					       " to abort command!\n",
-					       ha->host_no, bus, target, lun);
-				}
-			}
-		}
+	case ABORT_COMMAND:
+		dprintk(1, "qla1280: RISC aborting command\n");
+		/*
+		 * The abort might fail due to race when the host_lock
+		 * is released to issue the abort.  As such, we
+		 * don't bother to check the return status.
+		 */
+		if (found >= 0)
+			qla1280_abort_command(ha, sp, found);
 		break;
 
 	case DEVICE_RESET:
@@ -885,16 +909,21 @@ qla1280_error_action(struct scsi_cmnd *c
 			printk(KERN_INFO
 			       "scsi(%ld:%d:%d:%d): Queueing device reset "
 			       "command.\n", ha->host_no, bus, target, lun);
-		if (qla1280_device_reset(ha, bus, target) == 0)
-			result = SUCCESS;
+		if (qla1280_device_reset(ha, bus, target) == 0) {
+			/* issued device reset, set wait conditions */
+			wait_for_bus = bus;
+			wait_for_target = target;
+		}
 		break;
 
 	case BUS_RESET:
 		if (qla1280_verbose)
 			printk(KERN_INFO "qla1280(%ld:%d): Issued bus "
 			       "reset.\n", ha->host_no, bus);
-		if (qla1280_bus_reset(ha, bus) == 0)
-			result = SUCCESS;
+		if (qla1280_bus_reset(ha, bus) == 0) {
+			/* issued bus reset, set wait conditions */
+			wait_for_bus = bus;
+		}
 		break;
 
 	case ADAPTER_RESET:
@@ -907,55 +936,48 @@ qla1280_error_action(struct scsi_cmnd *c
 			       "continue automatically\n", ha->host_no);
 		}
 		ha->flags.reset_active = 1;
-		/*
-		 * We restarted all of the commands automatically, so the
-		 * mid-level code can expect completions momentitarily.
-		 */
-		if (qla1280_abort_isp(ha) == 0)
-			result = SUCCESS;
+
+		if (qla1280_abort_isp(ha) != 0) {	/* it's dead */
+			result = FAILED;
+		}
 
 		ha->flags.reset_active = 0;
 	}
 
-	if (!list_empty(&ha->done_q))
-		qla1280_done(ha);
-
-	/* If we didn't manage to issue the action, or we have no
-	 * command to wait for, exit here */
-	if (result == FAILED || handle == NULL ||
-	    handle == (unsigned char *)INVALID_HANDLE) {
-		/*
-		 * Clear completion queue to avoid qla1280_done() trying
-		 * to complete the command at a later stage after we
-		 * have exited the current context
-		 */
-		sp->wait = NULL;
-		goto leave;
-	}
+	/*
+	 * At this point, the host_lock has been released and retaken
+	 * by the issuance of the mailbox command.
+	 * Wait for the command passed in by the mid-layer if it
+	 * was found by the driver.  It might have been returned
+	 * between eh recovery steps, hence the check of the "found"
+	 * variable.
+	 */
 
-	/* set up a timer just in case we're really jammed */
-	init_timer(&timer);
-	timer.expires = jiffies + 4*HZ;
-	timer.data = (unsigned long)cmd;
-	timer.function = qla1280_error_wait_timeout;
-	add_timer(&timer);
+	if (found >= 0)
+		result = _qla1280_wait_for_single_command(ha, sp, &wait);
 
-	/* wait for the action to complete (or the timer to expire) */
-	spin_unlock_irq(ha->host->host_lock);
-	wait_for_completion(&wait);
-	del_timer_sync(&timer);
-	spin_lock_irq(ha->host->host_lock);
-	sp->wait = NULL;
+	if (action == ABORT_COMMAND && result != SUCCESS) {
+		printk(KERN_WARNING
+		       "scsi(%li:%i:%i:%i): "
+		       "Unable to abort command!\n",
+		       ha->host_no, bus, target, lun);
+	}
 
-	/* the only action we might get a fail for is abort */
-	if (action == ABORT_COMMAND) {
-		if(sp->flags & SRB_ABORTED)
-			result = SUCCESS;
-		else
-			result = FAILED;
+	/*
+	 * If the command passed in by the mid-layer has been
+	 * returned by the board, then wait for any additional
+	 * commands which are supposed to complete based upon
+	 * the error action.
+	 *
+	 * All commands are unconditionally returned during a
+	 * call to qla1280_abort_isp(), ADAPTER_RESET.  No need
+	 * to wait for them.
+	 */
+	if (result == SUCCESS && wait_for_bus >= 0) {
+		result = qla1280_wait_for_pending_commands(ha,
+					wait_for_bus, wait_for_target);
 	}
 
- leave:
 	dprintk(1, "RESET returning %d\n", result);
 
 	LEAVE("qla1280_error_action");
@@ -1258,7 +1280,8 @@ qla1280_done(struct scsi_qla_host *ha)
 		switch ((CMD_RESULT(cmd) >> 16)) {
 		case DID_RESET:
 			/* Issue marker command. */
-			qla1280_marker(ha, bus, target, 0, MK_SYNC_ID);
+			if (!ha->flags.abort_isp_active)
+				qla1280_marker(ha, bus, target, 0, MK_SYNC_ID);
 			break;
 		case DID_ABORT:
 			sp->flags &= ~SRB_ABORT_PENDING;
@@ -1272,12 +1295,11 @@ qla1280_done(struct scsi_qla_host *ha)
 		scsi_dma_unmap(cmd);
 
 		/* Call the mid-level driver interrupt handler */
-		CMD_HANDLE(sp->cmd) = (unsigned char *)INVALID_HANDLE;
 		ha->actthreads--;
 
-		(*(cmd)->scsi_done)(cmd);
-
-		if(sp->wait != NULL)
+		if (sp->wait == NULL)
+			(*(cmd)->scsi_done)(cmd);
+		else
 			complete(sp->wait);
 	}
 	LEAVE("qla1280_done");
@@ -3415,6 +3437,7 @@ qla1280_isr(struct scsi_qla_host *ha, st
 
 					/* Save ISP completion status */
 					CMD_RESULT(sp->cmd) = 0;
+					CMD_HANDLE(sp->cmd) = COMPLETED_HANDLE;
 
 					/* Place block on done queue */
 					list_add_tail(&sp->list, done_q);
@@ -3681,6 +3704,8 @@ qla1280_status_entry(struct scsi_qla_hos
 		}
 	}
 
+	CMD_HANDLE(sp->cmd) = COMPLETED_HANDLE;
+
 	/* Place command on done queue. */
 	list_add_tail(&sp->list, done_q);
  out:
@@ -3736,6 +3761,8 @@ qla1280_error_entry(struct scsi_qla_host
 			CMD_RESULT(sp->cmd) = DID_ERROR << 16;
 		}
 
+		CMD_HANDLE(sp->cmd) = COMPLETED_HANDLE;
+
 		/* Place command on done queue. */
 		list_add_tail(&sp->list, done_q);
 	}
@@ -3786,19 +3813,16 @@ qla1280_abort_isp(struct scsi_qla_host *
 		struct scsi_cmnd *cmd;
 		sp = ha->outstanding_cmds[cnt];
 		if (sp) {
-
 			cmd = sp->cmd;
 			CMD_RESULT(cmd) = DID_RESET << 16;
-
-			sp->cmd = NULL;
+			CMD_HANDLE(cmd) = COMPLETED_HANDLE;
 			ha->outstanding_cmds[cnt] = NULL;
-
-			(*cmd->scsi_done)(cmd);
-
-			sp->flags = 0;
+			list_add_tail(&sp->list, &ha->done_q);
 		}
 	}
 
+	qla1280_done(ha);
+
 	status = qla1280_load_firmware(ha);
 	if (status)
 		goto out;
--- a/drivers/scsi/qla1280.h	2009-04-07 14:40:53.000000000 -0500
+++ b/drivers/scsi/qla1280.h	2009-04-08 10:27:19.178492197 -0500
@@ -88,7 +88,8 @@
 
 /* Maximum outstanding commands in ISP queues */
 #define MAX_OUTSTANDING_COMMANDS	512
-#define INVALID_HANDLE			(MAX_OUTSTANDING_COMMANDS + 2)
+#define COMPLETED_HANDLE		((unsigned char *) \
+					(MAX_OUTSTANDING_COMMANDS + 2))
 
 /* ISP request and response entry counts (37-65535) */
 #define REQUEST_ENTRY_CNT		255 /* Number of request entries. */
