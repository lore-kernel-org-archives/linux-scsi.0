From: Matthew Wilcox <willy@debian.org>
Subject: softscsi patch
Date: Sun, 30 Jun 2002 22:20:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020630222043.B29045@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "David S. Miller" <davem@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>


Doug Gilbert and James Bottomley hassled me all through KernelSummit &
OLS to explain about softirqs, tasklets and bottom halves.  In the end,
it was easier to write the code myself.  Thanks to James for pointing
out that the pointer handling in my original code was completely broken
and helping me debug.

I've booted this patch on a 4-way system at OSDL with two Adaptec SCSI
cards.  I haven't tried stressing it (not quite sure which discs I can
use ;-), and I don't understand the locking in the scsi subsystem at all.

The main effect of applying this patch is that scsi_softirq() [was
scsi_tasklet_func, and before that scsi_bottom_half_handler()] can now be
run on multiple CPUs at the same time.  We _seem_ to do enough locking
elsewhere in the SCSI stack that this is safe.  But someone who really
understands the SCSI stack should audit this.

This work shows up a hole in the current softirq API -- there's no support
for unregistering a softirq (close_softirq or similar).  We should do
this in scsi_exit -- make sure no softirqs are running while we unload.
This probably isn't a problem in practice, but it'd be nice to fix it.

diff -urNX dontdiff linux-2.5.24/drivers/scsi/scsi.c linux-2.5.24-mm/drivers/scsi/scsi.c
--- linux-2.5.24/drivers/scsi/scsi.c	Wed Jun 19 06:15:46 2002
+++ linux-2.5.24-mm/drivers/scsi/scsi.c	Sun Jun 30 13:12:39 2002
@@ -130,8 +130,13 @@
 	16, 12, 10, 10
 };
 static unsigned long serial_number;
-static Scsi_Cmnd *scsi_bh_queue_head;
-static Scsi_Cmnd *scsi_bh_queue_tail;
+
+struct softscsi_data {
+	Scsi_Cmnd *head;
+	Scsi_Cmnd *tail;
+};
+
+static struct softscsi_data softscsi_data[NR_CPUS] __cacheline_aligned;
 
 /*
  * Note - the initial logging level can be set here to log events at boot time.
@@ -271,12 +276,6 @@
 static spinlock_t device_request_lock = SPIN_LOCK_UNLOCKED;
 
 /*
- * Used to protect insertion into and removal from the queue of
- * commands to be processed by the bottom half handler.
- */
-static spinlock_t scsi_bhqueue_lock = SPIN_LOCK_UNLOCKED;
-
-/*
  * Function:    scsi_allocate_request
  *
  * Purpose:     Allocate a request descriptor.
@@ -1089,37 +1088,29 @@
 	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_do_cmd()\n"));
 }
 
-void scsi_tasklet_func(unsigned long);
-static DECLARE_TASKLET(scsi_tasklet, scsi_tasklet_func, 0);
-
-/*
+/**
+ * scsi_done - Mark this command as done
+ * @SCpnt: The SCSI Command which we think we've completed.
+ *
  * This function is the mid-level interrupt routine, which decides how
- *  to handle error conditions.  Each invocation of this function must
- *  do one and *only* one of the following:
+ * to handle error conditions.  Each invocation of this function must
+ * do one and *only* one of the following:
  *
  *      1) Insert command in BH queue.
  *      2) Activate error handler for host.
  *
- * FIXME(eric) - I am concerned about stack overflow (still).  An
- * interrupt could come while we are processing the bottom queue,
- * which would cause another command to be stuffed onto the bottom
- * queue, and it would in turn be processed as that interrupt handler
- * is returning.  Given a sufficiently steady rate of returning
- * commands, this could cause the stack to overflow.  I am not sure
- * what is the most appropriate solution here - we should probably
- * keep a depth count, and not process any commands while we still
- * have a bottom handler active higher in the stack.
- *
- * There is currently code in the bottom half handler to monitor
- * recursion in the bottom handler and report if it ever happens.  If
- * this becomes a problem, it won't be hard to engineer something to
- * deal with it so that only the outer layer ever does any real
- * processing.  
+ * There is no longer a problem with stack overflow.  Interrupts queue
+ * Scsi_Cmnd on a per-CPU queue and the softirq handler removes them
+ * from the queue one at a time.
+ *
+ * This function is sometimes called from interrupt context, but sometimes
+ * from task context.
  */
 void scsi_done(Scsi_Cmnd * SCpnt)
 {
 	unsigned long flags;
-	int tstatus;
+	int cpu, tstatus;
+	struct softscsi_data *queue;
 
 	/*
 	 * We don't have to worry about this one timing out any more.
@@ -1155,7 +1146,6 @@
 		SCSI_LOG_MLCOMPLETE(1, printk("Ignoring completion of %p due to timeout status", SCpnt));
 		return;
 	}
-	spin_lock_irqsave(&scsi_bhqueue_lock, flags);
 
 	SCpnt->serial_number_at_timeout = 0;
 	SCpnt->state = SCSI_STATE_BHQUEUE;
@@ -1163,75 +1153,49 @@
 	SCpnt->bh_next = NULL;
 
 	/*
-	 * Next, put this command in the BH queue.
-	 * 
-	 * We need a spinlock here, or compare and exchange if we can reorder incoming
-	 * Scsi_Cmnds, as it happens pretty often scsi_done is called multiple times
-	 * before bh is serviced. -jj
+	 * Next, put this command in the softirq queue.
 	 *
-	 * We already have the io_request_lock here, since we are called from the
-	 * interrupt handler or the error handler. (DB)
-	 *
-	 * This may be true at the moment, but I would like to wean all of the low
-	 * level drivers away from using io_request_lock.   Technically they should
-	 * all use their own locking.  I am adding a small spinlock to protect
-	 * this datastructure to make it safe for that day.  (ERY)
-	 */
-	if (!scsi_bh_queue_head) {
-		scsi_bh_queue_head = SCpnt;
-		scsi_bh_queue_tail = SCpnt;
+	 * This is a per-CPU queue, so we just disable local interrupts
+	 * and need no spinlock.
+	 */
+
+	local_irq_save(flags);
+
+	cpu = smp_processor_id();
+	queue = &softscsi_data[cpu];
+
+	if (!queue->head) {
+		queue->head = SCpnt;
+		queue->tail = SCpnt;
 	} else {
-		scsi_bh_queue_tail->bh_next = SCpnt;
-		scsi_bh_queue_tail = SCpnt;
+		queue->tail->bh_next = SCpnt;
+		queue->tail = SCpnt;
 	}
 
-	spin_unlock_irqrestore(&scsi_bhqueue_lock, flags);
-	/*
-	 * Mark the bottom half handler to be run.
-	 */
-	tasklet_hi_schedule(&scsi_tasklet);
+	cpu_raise_softirq(cpu, SCSI_SOFTIRQ);
+
+	local_irq_restore(flags);
 }
 
-/*
- * Procedure:   scsi_bottom_half_handler
- *
- * Purpose:     Called after we have finished processing interrupts, it
- *              performs post-interrupt handling for commands that may
- *              have completed.
+/**
+ * scsi_softirq - Perform post-interrupt handling for completed commands
  *
- * Notes:       This is called with all interrupts enabled.  This should reduce
- *              interrupt latency, stack depth, and reentrancy of the low-level
- *              drivers.
- *
- * The io_request_lock is required in all the routine. There was a subtle
- * race condition when scsi_done is called after a command has already
- * timed out but before the time out is processed by the error handler.
- * (DB)
- *
- * I believe I have corrected this.  We simply monitor the return status of
- * del_timer() - if this comes back as 0, it means that the timer has fired
- * and that a timeout is in progress.   I have modified scsi_done() such
- * that in this instance the command is never inserted in the bottom
- * half queue.  Thus the only time we hold the lock here is when
- * we wish to atomically remove the contents of the queue.
+ * This is called with all interrupts enabled.  This should reduce
+ * interrupt latency, stack depth, and reentrancy of the low-level
+ * drivers.
  */
-void scsi_tasklet_func(unsigned long ignore)
+static void scsi_softirq(struct softirq_action *h)
 {
-	Scsi_Cmnd *SCpnt;
-	Scsi_Cmnd *SCnext;
-	unsigned long flags;
+	int cpu = smp_processor_id();
+	struct softscsi_data *queue = &softscsi_data[cpu];
 
+	while (queue->head) {
+		Scsi_Cmnd *SCpnt, *SCnext;
 
-	while (1 == 1) {
-		spin_lock_irqsave(&scsi_bhqueue_lock, flags);
-		SCpnt = scsi_bh_queue_head;
-		scsi_bh_queue_head = NULL;
-		spin_unlock_irqrestore(&scsi_bhqueue_lock, flags);
-
-		if (SCpnt == NULL) {
-			return;
-		}
-		SCnext = SCpnt->bh_next;
+		local_irq_disable();
+		SCpnt = queue->head;
+		queue->head = NULL;
+		local_irq_enable();
 
 		for (; SCpnt; SCpnt = SCnext) {
 			SCnext = SCpnt->bh_next;
@@ -1249,10 +1215,11 @@
 				break;
 			case NEEDS_RETRY:
 				/*
-				 * We only come in here if we want to retry a command.  The
-				 * test to see whether the command should be retried should be
-				 * keeping track of the number of tries, so we don't end up looping,
-				 * of course.
+				 * We only come in here if we want to retry a
+				 * command.  The test to see whether the
+				 * command should be retried should be keeping
+				 * track of the number of tries, so we don't
+				 * end up looping, of course.
 				 */
 				SCSI_LOG_MLCOMPLETE(3, printk("Command needs retry %d %d 0x%x\n", SCpnt->host->host_busy,
 				SCpnt->host->host_failed, SCpnt->result));
@@ -1261,12 +1228,14 @@
 				break;
 			case ADD_TO_MLQUEUE:
 				/* 
-				 * This typically happens for a QUEUE_FULL message -
-				 * typically only when the queue depth is only
-				 * approximate for a given device.  Adding a command
-				 * to the queue for the device will prevent further commands
-				 * from being sent to the device, so we shouldn't end up
-				 * with tons of things being sent down that shouldn't be.
+				 * This typically happens for a QUEUE_FULL
+				 * message - typically only when the queue
+				 * depth is only approximate for a given
+				 * device.  Adding a command to the queue for
+				 * the device will prevent further commands
+				 * from being sent to the device, so we
+				 * shouldn't end up with tons of things being
+				 * sent down that shouldn't be.
 				 */
 				SCSI_LOG_MLCOMPLETE(3, printk("Command rejected as device queue full, put on ml queue %p\n",
                                                               SCpnt));
@@ -1274,8 +1243,8 @@
 				break;
 			default:
 				/*
-				 * Here we have a fatal error of some sort.  Turn it over to
-				 * the error handler.
+				 * Here we have a fatal error of some sort.
+				 * Turn it over to the error handler.
 				 */
 				SCSI_LOG_MLCOMPLETE(3, printk("Command failed %p %x active=%d busy=%d failed=%d\n",
 						    SCpnt, SCpnt->result,
@@ -1295,8 +1264,10 @@
 					SCpnt->state = SCSI_STATE_FAILED;
 					SCpnt->host->in_recovery = 1;
 					/*
-					 * If the host is having troubles, then look to see if this was the last
-					 * command that might have failed.  If so, wake up the error handler.
+					 * If the host is having troubles, then
+					 * look to see if this was the last
+					 * command that might have failed.  If
+					 * so, wake up the error handler.
 					 */
 					if (SCpnt->host->host_busy == SCpnt->host->host_failed) {
 						SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler thread (%d)\n",
@@ -1305,15 +1276,14 @@
 					}
 				} else {
 					/*
-					 * We only get here if the error recovery thread has died.
+					 * We only get here if the error
+					 * recovery thread has died.
 					 */
 					scsi_finish_command(SCpnt);
 				}
-			}
+			}	/* switch */
 		}		/* for(; SCpnt...) */
-
-	}			/* while(1==1) */
-
+	}			/* while(queue->head) */
 }
 
 /*
@@ -2548,6 +2518,9 @@
 		printk(KERN_INFO "scsi: host order: %s\n", scsihosts);	
 	scsi_host_no_init (scsihosts);
 
+	/* Where we handle work queued by scsi_done */
+	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
+
 	return 0;
 }
 
@@ -2555,8 +2528,6 @@
 {
 	Scsi_Host_Name *shn, *shn2 = NULL;
 	int i;
-
-	tasklet_kill(&scsi_tasklet);
 
         devfs_unregister (scsi_devfs_handle);
         for (shn = scsi_host_no_list;shn;shn = shn->next) {
diff -urNX dontdiff linux-2.5.24/include/linux/interrupt.h linux-2.5.24-mm/include/linux/interrupt.h
--- linux-2.5.24/include/linux/interrupt.h	Thu Jun 20 17:04:42 2002
+++ linux-2.5.24-mm/include/linux/interrupt.h	Sat Jun 29 05:42:50 2002
@@ -57,6 +57,7 @@
 	HI_SOFTIRQ=0,
 	NET_TX_SOFTIRQ,
 	NET_RX_SOFTIRQ,
+	SCSI_SOFTIRQ,
 	TASKLET_SOFTIRQ
 };
 

-- 
Revolutions do not require corporate support.
