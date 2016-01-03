From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 37/78] ncr5380: Standardize work queueing algorithm
Date: Sun, 03 Jan 2016 16:05:38 +1100
Message-ID: <20160103050510.821816279@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-main_running-and-queue_main
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The complex main_running/queue_main mechanism is peculiar to
atari_NCR5380.c. It isn't SMP safe and offers little value given that
the work queue already offers concurrency management. Remove this
complexity to bring atari_NCR5380.c closer to NCR5380.c.

It is not a good idea to call the information transfer state machine from
queuecommand because, according to Documentation/scsi/scsi_mid_low_api.txt
that could happen in soft irq context. Fix this.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.h       |    1 
 drivers/scsi/atari_NCR5380.c |   80 +++----------------------------------------
 2 files changed, 6 insertions(+), 75 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:03:47.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:03:48.000000000 +1100
@@ -262,7 +262,6 @@ struct NCR5380_hostdata {
 	                                   * transfer to handle chip overruns */
 	int retain_dma_intr;
 	struct work_struct main_task;
-	volatile int main_running;
 #ifdef SUPPORT_TAGS
 	struct tag_alloc TagAlloc[8][8];	/* 8 targets and 8 LUNs */
 #endif
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:46.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:48.000000000 +1100
@@ -602,36 +602,6 @@ static void NCR5380_print_phase(struct S
 
 #endif
 
-/*
- * ++roman: New scheme of calling NCR5380_main()
- *
- * If we're not in an interrupt, we can call our main directly, it cannot be
- * already running. Else, we queue it on a task queue, if not 'main_running'
- * tells us that a lower level is already executing it. This way,
- * 'main_running' needs not be protected in a special way.
- *
- * queue_main() is a utility function for putting our main onto the task
- * queue, if main_running is false. It should be called only from a
- * interrupt or bottom half.
- */
-
-#include <linux/gfp.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-
-static inline void queue_main(struct NCR5380_hostdata *hostdata)
-{
-	if (!hostdata->main_running) {
-		/* If in interrupt and NCR5380_main() not already running,
-		   queue it on the 'immediate' task queue, to be processed
-		   immediately after the current interrupt processing has
-		   finished. */
-		queue_work(hostdata->work_q, &hostdata->main_task);
-	}
-	/* else: nothing to do: the running NCR5380_main() will pick up
-	   any newly queued command. */
-}
-
 /**
  * NCR58380_info - report driver and host information
  * @instance: relevant scsi host instance
@@ -714,8 +684,6 @@ static void __maybe_unused NCR5380_print
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
 	local_irq_save(flags);
-	printk("NCR5380: coroutine is%s running.\n",
-		hostdata->main_running ? "" : "n't");
 	if (!hostdata->connected)
 		printk("scsi%d: no currently connected command\n", HOSTNO);
 	else
@@ -757,8 +725,6 @@ static int __maybe_unused NCR5380_show_i
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
 	local_irq_save(flags);
-	seq_printf(m, "NCR5380: coroutine is%s running.\n",
-		hostdata->main_running ? "" : "n't");
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
 	else
@@ -997,17 +963,8 @@ static int NCR5380_queue_command(struct
 	dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
 		  (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
-	/* If queue_command() is called from an interrupt (real one or bottom
-	 * half), we let queue_main() do the job of taking care about main. If it
-	 * is already running, this is a no-op, else main will be queued.
-	 *
-	 * If we're not in an interrupt, we can call NCR5380_main()
-	 * unconditionally, because it cannot be already running.
-	 */
-	if (in_interrupt() || irqs_disabled())
-		queue_main(hostdata);
-	else
-		NCR5380_main(&hostdata->main_task);
+	/* Kick off command processing */
+	queue_work(hostdata->work_q, &hostdata->main_task);
 	return 0;
 }
 
@@ -1044,30 +1001,11 @@ static void NCR5380_main(struct work_str
 	unsigned long flags;
 
 	/*
-	 * We run (with interrupts disabled) until we're sure that none of
-	 * the host adapters have anything that can be done, at which point
-	 * we set main_running to 0 and exit.
-	 *
-	 * Interrupts are enabled before doing various other internal
-	 * instructions, after we've decided that we need to run through
-	 * the loop again.
-	 *
-	 * this should prevent any race conditions.
-	 *
 	 * ++roman: Just disabling the NCR interrupt isn't sufficient here,
 	 * because also a timer int can trigger an abort or reset, which can
 	 * alter queues and touch the Falcon lock.
 	 */
 
-	/* Tell int handlers main() is now already executing.  Note that
-	   no races are possible here. If an int comes in before
-	   'main_running' is set here, and queues/executes main via the
-	   task queue, it doesn't do any harm, just this instance of main
-	   won't find any work left to do. */
-	if (hostdata->main_running)
-		return;
-	hostdata->main_running = 1;
-
 	local_save_flags(flags);
 	do {
 		local_irq_disable();	/* Freeze request queues */
@@ -1182,11 +1120,6 @@ static void NCR5380_main(struct work_str
 			done = 0;
 		}
 	} while (!done);
-
-	/* Better allow ints _after_ 'main_running' has been cleared, else
-	   an interrupt could believe we'll pick up the work it left for
-	   us, but we won't see it anymore here... */
-	hostdata->main_running = 0;
 	local_irq_restore(flags);
 }
 
@@ -1299,6 +1232,7 @@ static void NCR5380_dma_complete(struct
 static irqreturn_t NCR5380_intr(int irq, void *dev_id)
 {
 	struct Scsi_Host *instance = dev_id;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int done = 1, handled = 0;
 	unsigned char basr;
 
@@ -1367,11 +1301,9 @@ static irqreturn_t NCR5380_intr(int irq,
 #endif
 	}
 
-	if (!done) {
-		dprintk(NDEBUG_INTR, "scsi%d: in int routine, calling main\n", HOSTNO);
-		/* Put a call to NCR5380_main() on the queue... */
-		queue_main(shost_priv(instance));
-	}
+	if (!done)
+		queue_work(hostdata->work_q, &hostdata->main_task);
+
 	return IRQ_RETVAL(handled);
 }
 
