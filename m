From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] consolidate and log scsi command on send and completion
Date: Tue, 30 Sep 2003 17:21:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030930172134.A10611@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:38561 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261824AbTJAAWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2003 20:22:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Hi -

Patch against 2.6.0-test6.

Consolidate and nicely log the scsi_device and scsi command before sending
and after completing a command to an adapter driver.

diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi.c bl-25-scmd-log/drivers/scsi/scsi.c
--- bl-25/drivers/scsi/scsi.c	Mon Sep 29 12:21:09 2003
+++ bl-25-scmd-log/drivers/scsi/scsi.c	Tue Sep 30 14:24:17 2003
@@ -351,6 +351,124 @@ void scsi_destroy_command_freelist(struc
 	up(&host_cmd_pool_mutex);
 }
 
+#ifdef CONFIG_SCSI_LOGGING
+void scsi_log_send(struct scsi_cmnd *cmd)
+{
+	unsigned int level;
+	struct scsi_device *sdev;
+
+	/*
+	 * If ML QUEUE log level is greater than or equal to:
+	 *
+	 * 1: nothing (match completion)
+	 *
+	 * 2: log opcode + command of all commands
+	 *
+	 * 3: same as 2 plus dump cmd address
+	 *
+	 * 4: same as 3 plus dump extra junk
+	 */
+	if (unlikely(scsi_logging_level)) {
+		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
+				       SCSI_LOG_MLQUEUE_BITS);
+		if (level > 1) {
+			sdev = cmd->device;
+			printk(KERN_INFO "scsi <%d:%d:%d:%d> send ",
+			       sdev->host->host_no, sdev->channel, sdev->id,
+			       sdev->lun);
+			if (level > 2)
+				printk("0x%p ", cmd);
+			/*
+			 * spaces to match disposition and cmd->result
+			 * output in scsi_log_completion.
+			 */
+			printk("                 ");
+			print_command(cmd->cmnd);
+			if (level > 3) {
+				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
+				       " done = 0x%p, queuecommand 0x%p\n",
+					cmd->buffer, cmd->bufflen,
+					cmd->done,
+					sdev->host->hostt->queuecommand);
+
+			}
+		}
+	}
+}
+
+void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
+{
+	unsigned int level;
+	struct scsi_device *sdev;
+
+	/*
+	 * If ML COMPLETE log level is greater than or equal to:
+	 *
+	 * 1: log disposition, result, opcode + command, and conditionally
+	 * sense data for failures or non SUCCESS dispositions.
+	 *
+	 * 2: same as 1 but for all command completions.
+	 *
+	 * 3: same as 2 plus dump cmd address
+	 *
+	 * 4: same as 3 plus dump extra junk
+	 */
+	if (unlikely(scsi_logging_level)) {
+		level = SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
+				       SCSI_LOG_MLCOMPLETE_BITS);
+		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
+		    (level > 1)) {
+			sdev = cmd->device;
+			printk(KERN_INFO "scsi <%d:%d:%d:%d> done ",
+			       sdev->host->host_no, sdev->channel, sdev->id,
+			       sdev->lun);
+			if (level > 2)
+				printk("0x%p ", cmd);
+			/*
+			 * Dump truncated values, so we usually fit within
+			 * 80 chars.
+			 */
+			switch (disposition) {
+			case SUCCESS:
+				printk("SUCCESS");
+				break;
+			case NEEDS_RETRY:
+				printk("RETRY  ");
+				break;
+			case ADD_TO_MLQUEUE:
+				printk("MLQUEUE");
+				break;
+			case FAILED:
+				printk("FAILED ");
+				break;
+			case TIMEOUT:
+				/* 
+				 * If called via scsi_times_out.
+				 */
+				printk("TIMEOUT");
+				break;
+			default:
+				printk("UNKNOWN");
+			}
+			printk(" %8x ", cmd->result);
+			print_command(cmd->cmnd);
+			if (status_byte(cmd->result) & CHECK_CONDITION) {
+				/*
+				 * XXX The print_sense formatting/prefix
+				 * doesn't match this function.
+				 */
+				print_sense("", cmd);
+			}
+			if (level > 3) {
+				printk(KERN_INFO "scsi host busy %d failed %d\n",
+				       sdev->host->host_busy,
+				       sdev->host->host_failed);
+			}
+		}
+	}
+}
+#endif
+
 /*
  * Function:    scsi_dispatch_command
  *
@@ -406,16 +524,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 
 	scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
 
+	scsi_log_send(cmd);
+
 	/*
 	 * We will use a queued command if possible, otherwise we will
 	 * emulate the queuing and calling of completion function ourselves.
 	 */
-	SCSI_LOG_MLQUEUE(3, printk("scsi_dispatch_cmnd (host = %d, "
-				"channel = %d, target = %d, command = %p, "
-				"buffer = %p, \nbufflen = %d, done = %p)\n",
-				host->host_no, cmd->device->channel,
-				cmd->device->id, cmd->cmnd, cmd->buffer,
-				cmd->bufflen, cmd->done));
 
 	cmd->state = SCSI_STATE_QUEUED;
 	cmd->owner = SCSI_OWNER_LOWLEVEL;
@@ -435,9 +549,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		goto out;
 	}
 
-	SCSI_LOG_MLQUEUE(3, printk("queuecommand : routine at %p\n",
-				   host->hostt->queuecommand));
-
 	spin_lock_irqsave(host->host_lock, flags);
 	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state))) {
 		cmd->result = (DID_NO_CONNECT << 16);
@@ -594,6 +705,7 @@ void scsi_done(struct scsi_cmnd *cmd)
  */
 static void scsi_softirq(struct softirq_action *h)
 {
+	int disposition;
 	LIST_HEAD(local_q);
 
 	local_irq_disable();
@@ -605,75 +717,19 @@ static void scsi_softirq(struct softirq_
 						   struct scsi_cmnd, eh_entry);
 		list_del_init(&cmd->eh_entry);
 
-		switch (scsi_decide_disposition(cmd)) {
+		disposition = scsi_decide_disposition(cmd);
+		scsi_log_completion(cmd, disposition);
+		switch (disposition) {
 		case SUCCESS:
-			/*
-			 * Add to BH queue.
-			 */
-			SCSI_LOG_MLCOMPLETE(3,
-					    printk("Command finished %d %d "
-						   "0x%x\n",
-					   cmd->device->host->host_busy,
-					   cmd->device->host->host_failed,
-						   cmd->result));
-
 			scsi_finish_command(cmd);
 			break;
 		case NEEDS_RETRY:
-			/*
-			 * We only come in here if we want to retry a
-			 * command.  The test to see whether the
-			 * command should be retried should be keeping
-			 * track of the number of tries, so we don't
-			 * end up looping, of course.
-			 */
-			SCSI_LOG_MLCOMPLETE(3, printk("Command needs retry "
-						      "%d %d 0x%x\n",
-					      cmd->device->host->host_busy,
-					      cmd->device->host->host_failed,
-						      cmd->result));
-
 			scsi_retry_command(cmd);
 			break;
 		case ADD_TO_MLQUEUE:
-			/* 
-			 * This typically happens for a QUEUE_FULL
-			 * message - typically only when the queue
-			 * depth is only approximate for a given
-			 * device.  Adding a command to the queue for
-			 * the device will prevent further commands
-			 * from being sent to the device, so we
-			 * shouldn't end up with tons of things being
-			 * sent down that shouldn't be.
-			 */
-			SCSI_LOG_MLCOMPLETE(3, printk("Command rejected as "
-						      "device queue full, "
-						      "put on ml queue %p\n",
-						      cmd));
 			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 			break;
 		default:
-			/*
-			 * Here we have a fatal error of some sort.
-			 * Turn it over to the error handler.
-			 */
-			SCSI_LOG_MLCOMPLETE(3,
-					    printk("Command failed %p %x "
-						   "busy=%d failed=%d\n",
-						   cmd, cmd->result,
-					   cmd->device->host->host_busy,
-					   cmd->device->host->host_failed));
-
-			/*
-			 * Dump the sense information too.
-			 */
-			if (status_byte(cmd->result) & CHECK_CONDITION)
-				SCSI_LOG_MLCOMPLETE(3, print_sense("bh", cmd));
-
-			/*
-			 * We only fail here if the error recovery thread
-			 * has died.
-			 */
 			if (!scsi_eh_scmd_add(cmd, 0))
 				scsi_finish_command(cmd);
 		}
@@ -739,7 +795,7 @@ void scsi_finish_command(struct scsi_cmn
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(3, printk("Notifying upper driver of completion "
+	SCSI_LOG_MLCOMPLETE(4, printk("Notifying upper driver of completion "
 				"for device %d %x\n", sdev->id, cmd->result));
 
 	cmd->owner = SCSI_OWNER_HIGHLEVEL;
diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_error.c bl-25-scmd-log/drivers/scsi/scsi_error.c
--- bl-25/drivers/scsi/scsi_error.c	Mon Sep 29 12:21:09 2003
+++ bl-25-scmd-log/drivers/scsi/scsi_error.c	Mon Sep 29 12:37:28 2003
@@ -164,14 +164,11 @@ int scsi_delete_timer(struct scsi_cmnd *
  **/
 void scsi_times_out(struct scsi_cmnd *scmd)
 {
+	scsi_log_completion(scmd, TIMEOUT);
 	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		panic("Error handler thread not present at %p %p %s %d",
 		      scmd, scmd->device->host, __FILE__, __LINE__);
 	}
-
-	SCSI_LOG_TIMEOUT(3, printk("Command timed out busy=%d failed=%d\n",
-				   scmd->device->host->host_busy,
-				   scmd->device->host->host_failed));
 }
 
 /**
@@ -446,10 +443,12 @@ static int scsi_send_eh_cmnd(struct scsi
 	scmd->request->rq_status = RQ_SCSI_BUSY;
 
 	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	scsi_log_send(scmd);
 	host->hostt->queuecommand(scmd, scsi_eh_done);
 	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	down(&sem);
+	scsi_log_completion(scmd, SUCCESS);
 
 	scmd->device->host->eh_action = NULL;
 
diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_logging.h bl-25-scmd-log/drivers/scsi/scsi_logging.h
--- bl-25/drivers/scsi/scsi_logging.h	Mon Sep 22 13:08:53 2003
+++ bl-25-scmd-log/drivers/scsi/scsi_logging.h	Mon Sep 29 12:37:28 2003
@@ -40,10 +40,13 @@
 extern unsigned int scsi_logging_level;
 
 #ifdef CONFIG_SCSI_LOGGING
+
+#define SCSI_LOG_LEVEL(SHIFT, BITS)				\
+        ((scsi_logging_level >> (SHIFT)) & ((1 << (BITS)) - 1))
+
 #define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)		\
 {								\
-        unsigned int mask = (1 << (BITS)) - 1;			\
-        if (((scsi_logging_level >> (SHIFT)) & mask) > (LEVEL))	\
+        if ((SCSI_LOG_LEVEL(SHIFT, BITS)) > (LEVEL))		\
 		(CMD);						\
 }
 #else
diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_priv.h bl-25-scmd-log/drivers/scsi/scsi_priv.h
--- bl-25/drivers/scsi/scsi_priv.h	Mon Sep 29 12:21:09 2003
+++ bl-25-scmd-log/drivers/scsi/scsi_priv.h	Mon Sep 29 12:37:28 2003
@@ -83,6 +83,15 @@ extern int scsi_insert_special_req(struc
 extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
 		struct scsi_request *sreq);
 extern void __scsi_release_request(struct scsi_request *sreq);
+#ifdef CONFIG_SCSI_LOGGING
+void scsi_log_send(struct scsi_cmnd *cmd);
+void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
+#else
+static inline void scsi_log_send(struct scsi_cmnd *cmd) 
+	{ };
+static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
+	{ };
+#endif
 
 /* scsi_devinfo.c */
 extern int scsi_get_device_flags(unsigned char *vendor, unsigned char *model);
diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi.h bl-25-scmd-log/include/scsi/scsi.h
--- bl-25/include/scsi/scsi.h	Mon Sep 29 12:21:10 2003
+++ bl-25-scmd-log/include/scsi/scsi.h	Mon Sep 29 12:39:10 2003
@@ -302,6 +302,7 @@ struct scsi_lun {
 #define QUEUED          0x2004
 #define SOFT_ERROR      0x2005
 #define ADD_TO_MLQUEUE  0x2006
+#define TIMEOUT         0x2007
 
 /*
  * Midlevel queue return values.
