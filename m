From: Luben Tuikov <luben@splentec.com>
Subject: [PATCH] softirq queue is now list_head, eliminate bh_next
Date: Fri, 07 Mar 2003 18:55:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E69317E.8030403@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id h27NtdL13646
	for <linux-scsi@vger.kernel.org>; Fri, 7 Mar 2003 18:55:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patch gets rid of softscsi_data struct and
array for the more manageable
static struct list_head done_q[NR_CPUS] __cacheline_aligned;

Thus, scsi_cmnd::bh_next is eliminated, since it was used only
in the scsi softirq processing code.

The comments are updated.

80 chars per line for the affected functions: scsi_done()
and scsi_softirq().

Eliminated is the double loop in scsi_softirq() -- this is
better handled in do_softirq() and gives the system a ``breather''.
(There are pros and cons for either side and if you guys
think that it was better with the double loop, I'll change it and
resubmit the patch.)

-- 
Luben

diff -Naur -X dontdiff linux-2.5.64/drivers/scsi.orig/scsi.c linux-2.5.64/drivers/scsi/scsi.c
--- linux-2.5.64/drivers/scsi.orig/scsi.c	2003-03-04 22:29:19.000000000 -0500
+++ linux-2.5.64/drivers/scsi/scsi.c	2003-03-07 14:28:43.000000000 -0500
@@ -96,12 +96,7 @@
  Scsi_Cmnd *last_cmnd;
  static unsigned long serial_number;

-struct softscsi_data {
-	Scsi_Cmnd *head;
-	Scsi_Cmnd *tail;
-};
-
-static struct softscsi_data softscsi_data[NR_CPUS] __cacheline_aligned;
+static struct list_head done_q[NR_CPUS] __cacheline_aligned;

  /*
   * List of all highlevel drivers.
@@ -637,79 +632,60 @@
  }

  /**
- * scsi_done - Mark this command as done
- * @SCpnt: The SCSI Command which we think we've completed.
- *
- * This function is the mid-level interrupt routine, which decides how
- * to handle error conditions.  Each invocation of this function must
- * do one and *only* one of the following:
+ * scsi_done - Enqueue the finished SCSI command into the done queue.
+ * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
+ * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
   *
- *      1) Insert command in BH queue.
- *      2) Activate error handler for host.
+ * This function is the mid-level's (SCSI Core) interrupt routine, which
+ * regains ownership of the SCSI command (de facto) from a LLDD, and enqueues
+ * the command to the done queue for further processing.
   *
- * There is no longer a problem with stack overflow.  Interrupts queue
- * Scsi_Cmnd on a per-CPU queue and the softirq handler removes them
- * from the queue one at a time.
+ * This is the producer of the done queue who enqueues at the tail.
   *
- * This function is sometimes called from interrupt context, but sometimes
- * from task context.
+ * This function is interrupt context safe.
   */
-void scsi_done(Scsi_Cmnd * SCpnt)
+void scsi_done(struct scsi_cmnd *cmd)
  {
+	int cpu;
  	unsigned long flags;
-	int cpu, tstatus;
-	struct softscsi_data *queue;
+	struct list_head *pdone_q;

  	/*
  	 * We don't have to worry about this one timing out any more.
-	 */
-	tstatus = scsi_delete_timer(SCpnt);
-
-	/*
-	 * If we are unable to remove the timer, it means that the command
-	 * has already timed out.  In this case, we have no choice but to
+	 * If we are unable to remove the timer, then the command
+	 * has already timed out.  In which case, we have no choice but to
  	 * let the timeout function run, as we have no idea where in fact
  	 * that function could really be.  It might be on another processor,
  	 * etc, etc.
  	 */
-	if (!tstatus) {
+	if (!scsi_delete_timer(cmd))
  		return;
-	}

  	/* Set the serial numbers back to zero */
-	SCpnt->serial_number = 0;
-	SCpnt->serial_number_at_timeout = 0;
-	SCpnt->state = SCSI_STATE_BHQUEUE;
-	SCpnt->owner = SCSI_OWNER_BH_HANDLER;
-	SCpnt->bh_next = NULL;
+	cmd->serial_number = 0;
+	cmd->serial_number_at_timeout = 0;
+	cmd->state = SCSI_STATE_BHQUEUE;
+	cmd->owner = SCSI_OWNER_BH_HANDLER;

  	/*
-	 * Next, put this command in the softirq queue.
-	 *
-	 * This is a per-CPU queue, so we just disable local interrupts
+	 * Next, enqueue the command into the done queue.
+	 * It is a per-CPU queue, so we just disable local interrupts
  	 * and need no spinlock.
  	 */
-
  	local_irq_save(flags);

  	cpu = smp_processor_id();
-	queue = &softscsi_data[cpu];
-
-	if (!queue->head) {
-		queue->head = SCpnt;
-		queue->tail = SCpnt;
-	} else {
-		queue->tail->bh_next = SCpnt;
-		queue->tail = SCpnt;
-	}
-
+	pdone_q = &done_q[cpu];
+	list_add_tail(&cmd->eh_entry, pdone_q);
  	cpu_raise_softirq(cpu, SCSI_SOFTIRQ);

  	local_irq_restore(flags);
-}
+} /* end scsi_done() */

  /**
- * scsi_softirq - Perform post-interrupt handling for completed commands
+ * scsi_softirq - Perform post-interrupt processing of finished SCSI commands.
+ *
+ * This is the consumer of the done queue.
   *
   * This is called with all interrupts enabled.  This should reduce
   * interrupt latency, stack depth, and reentrancy of the low-level
@@ -717,89 +693,93 @@
   */
  static void scsi_softirq(struct softirq_action *h)
  {
-	int cpu = smp_processor_id();
-	struct softscsi_data *queue = &softscsi_data[cpu];
+	LIST_HEAD(local_q);

-	while (queue->head) {
-		Scsi_Cmnd *SCpnt, *SCnext;
+	local_irq_disable();
+	list_splice_init(&done_q[smp_processor_id()], &local_q);
+	local_irq_enable();
+
+	while (!list_empty(&local_q)) {
+		struct scsi_cmnd *cmd = list_entry(local_q.next,
+						   struct scsi_cmnd, eh_entry);
+		list_del_init(&cmd->eh_entry);

-		local_irq_disable();
-		SCpnt = queue->head;
-		queue->head = NULL;
-		local_irq_enable();
+		switch (scsi_decide_disposition(cmd)) {
+		case SUCCESS:
+			/*
+			 * Add to BH queue.
+			 */
+			SCSI_LOG_MLCOMPLETE(3,
+					    printk("Command finished %d %d "
+						   "0x%x\n",
+					   cmd->device->host->host_busy,
+					   cmd->device->host->host_failed,
+						   cmd->result));

-		for (; SCpnt; SCpnt = SCnext) {
-			SCnext = SCpnt->bh_next;
+			scsi_finish_command(cmd);
+			break;
+		case NEEDS_RETRY:
+			/*
+			 * We only come in here if we want to retry a
+			 * command.  The test to see whether the
+			 * command should be retried should be keeping
+			 * track of the number of tries, so we don't
+			 * end up looping, of course.
+			 */
+			SCSI_LOG_MLCOMPLETE(3, printk("Command needs retry "
+						      "%d %d 0x%x\n",
+					      cmd->device->host->host_busy,
+					      cmd->device->host->host_failed,
+						      cmd->result));

-			switch (scsi_decide_disposition(SCpnt)) {
-			case SUCCESS:
-				/*
-				 * Add to BH queue.
-				 */
-				SCSI_LOG_MLCOMPLETE(3, printk("Command finished %d %d 0x%x\n", SCpnt->device->host->host_busy,
-						SCpnt->device->host->host_failed,
-							 SCpnt->result));
-
-				scsi_finish_command(SCpnt);
-				break;
-			case NEEDS_RETRY:
-				/*
-				 * We only come in here if we want to retry a
-				 * command.  The test to see whether the
-				 * command should be retried should be keeping
-				 * track of the number of tries, so we don't
-				 * end up looping, of course.
-				 */
-				SCSI_LOG_MLCOMPLETE(3, printk("Command needs retry %d %d 0x%x\n", SCpnt->device->host->host_busy,
-				SCpnt->device->host->host_failed, SCpnt->result));
+			scsi_retry_command(cmd);
+			break;
+		case ADD_TO_MLQUEUE:
+			/*
+			 * This typically happens for a QUEUE_FULL
+			 * message - typically only when the queue
+			 * depth is only approximate for a given
+			 * device.  Adding a command to the queue for
+			 * the device will prevent further commands
+			 * from being sent to the device, so we
+			 * shouldn't end up with tons of things being
+			 * sent down that shouldn't be.
+			 */
+			SCSI_LOG_MLCOMPLETE(3, printk("Command rejected as "
+						      "device queue full, "
+						      "put on ml queue %p\n",
+						      cmd));
+			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+			break;
+		default:
+			/*
+			 * Here we have a fatal error of some sort.
+			 * Turn it over to the error handler.
+			 */
+			SCSI_LOG_MLCOMPLETE(3,
+					    printk("Command failed %p %x "
+						   "busy=%d failed=%d\n",
+						   cmd, cmd->result,
+					   cmd->device->host->host_busy,
+					   cmd->device->host->host_failed));

-				scsi_retry_command(SCpnt);
-				break;
-			case ADD_TO_MLQUEUE:
-				/*
-				 * This typically happens for a QUEUE_FULL
-				 * message - typically only when the queue
-				 * depth is only approximate for a given
-				 * device.  Adding a command to the queue for
-				 * the device will prevent further commands
-				 * from being sent to the device, so we
-				 * shouldn't end up with tons of things being
-				 * sent down that shouldn't be.
-				 */
-				SCSI_LOG_MLCOMPLETE(3, printk("Command rejected as device queue full, put on ml queue %p\n",
-                                                              SCpnt));
-				scsi_queue_insert(SCpnt, SCSI_MLQUEUE_DEVICE_BUSY);
-				break;
-			default:
-				/*
-				 * Here we have a fatal error of some sort.
-				 * Turn it over to the error handler.
-				 */
-				SCSI_LOG_MLCOMPLETE(3,
-					printk("Command failed %p %x busy=%d failed=%d\n",
-						SCpnt, SCpnt->result,
-						SCpnt->device->host->host_busy,
-						SCpnt->device->host->host_failed));
+			/*
+			 * Dump the sense information too.
+			 */
+			if ((status_byte(cmd->result)&CHECK_CONDITION) != 0) {
+				SCSI_LOG_MLCOMPLETE(3, print_sense("bh", cmd));
+			}

+			if (!scsi_eh_scmd_add(cmd, 0)) {
  				/*
-				 * Dump the sense information too.
+				 * We only get here if the error
+				 * recovery thread has died.
  				 */
-				if ((status_byte(SCpnt->result) & CHECK_CONDITION) != 0) {
-					SCSI_LOG_MLCOMPLETE(3, print_sense("bh", SCpnt));
-				}
-
-				if (!scsi_eh_scmd_add(SCpnt, 0))
-				{
-					/*
-					 * We only get here if the error
-					 * recovery thread has died.
-					 */
-					scsi_finish_command(SCpnt);
-				}
-			}	/* switch */
-		}		/* for(; SCpnt...) */
-	}			/* while(queue->head) */
-}
+				scsi_finish_command(cmd);
+			}
+		} /* switch (command disposition) */
+	} /* while (local queue is not emtpy) */
+} /* end scsi_softirq() */

  /*
   * Function:    scsi_retry_command
@@ -1481,7 +1461,7 @@

  static int __init init_scsi(void)
  {
-	int error;
+	int error, i;

  	error = scsi_init_queue();
  	if (error)
@@ -1496,6 +1476,9 @@
  	if (error)
  		goto cleanup_devlist;

+	for (i = 0; i < NR_CPUS; i++)
+		INIT_LIST_HEAD(&done_q[i]);
+
  	scsi_host_init();
  	devfs_mk_dir(NULL, "scsi", NULL);
  	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
diff -Naur -X dontdiff linux-2.5.64/drivers/scsi.orig/scsi.h linux-2.5.64/drivers/scsi/scsi.h
--- linux-2.5.64/drivers/scsi.orig/scsi.h	2003-03-04 22:29:03.000000000 -0500
+++ linux-2.5.64/drivers/scsi/scsi.h	2003-03-07 14:19:50.000000000 -0500
@@ -760,8 +760,7 @@
  	 * abort, etc are in process.
  	 */
  	unsigned volatile char internal_timeout;
-	struct scsi_cmnd *bh_next;	/* To enumerate the commands waiting
-					   to be processed. */
+
  	unsigned char cmd_len;
  	unsigned char old_cmd_len;
  	unsigned char sc_data_direction;
diff -Naur -X dontdiff linux-2.5.64/drivers/scsi.orig/scsi_lib.c linux-2.5.64/drivers/scsi/scsi_lib.c
--- linux-2.5.64/drivers/scsi.orig/scsi_lib.c	2003-03-04 22:29:19.000000000 -0500
+++ linux-2.5.64/drivers/scsi/scsi_lib.c	2003-03-07 15:02:53.000000000 -0500
@@ -125,7 +125,6 @@
  	 */
  	cmd->state = SCSI_STATE_MLQUEUE;
  	cmd->owner = SCSI_OWNER_MIDLEVEL;
-	cmd->bh_next = NULL;

  	/*
  	 * Decrement the counters, since these commands are no longer

