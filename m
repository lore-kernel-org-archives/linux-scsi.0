From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 35/37] atari_NCR5380: Move static co-routine variables to host data
Date: Wed, 12 Nov 2014 16:12:21 +1100
Message-ID: <20141112051154.745478975@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:41010 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaKLFnh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:37 -0500
Content-Disposition: inline; filename=atari_NCR5380-move-coroutine-variables
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Unlike NCR5380.c, the atari_NCR5380.c core driver is limited to a single
instance because co-routine state is stored globally.

Fix this by removing the static scsi host pointer. For the co-routine,
obtain this pointer from the work_struct pointer instead. For the interrupt
handler, obtain it from the dev_id argument.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.h       |    2 +
 drivers/scsi/atari_NCR5380.c |   61 +++++++++++++++----------------------------
 drivers/scsi/atari_scsi.c    |    8 ++---
 3 files changed, 28 insertions(+), 43 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-11-12 16:11:41.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-11-12 16:11:42.000000000 +1100
@@ -283,6 +283,8 @@ struct NCR5380_hostdata {
 	int read_overruns;                /* number of bytes to cut from a
 	                                   * transfer to handle chip overruns */
 	int retain_dma_intr;
+	struct work_struct main_task;
+	volatile int main_running;
 #ifdef SUPPORT_TAGS
 	struct tag_alloc TagAlloc[8][8];	/* 8 targets and 8 LUNs */
 #endif
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:41.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:42.000000000 +1100
@@ -221,9 +221,6 @@
  * possible) function may be used.
  */
 
-static struct Scsi_Host *first_instance = NULL;
-static struct scsi_host_template *the_template = NULL;
-
 /* Macros ease life... :-) */
 #define	SETUP_HOSTDATA(in)				\
     struct NCR5380_hostdata *hostdata =			\
@@ -595,32 +592,19 @@ static void NCR5380_print_phase(struct S
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 
-static volatile int main_running;
-static DECLARE_WORK(NCR5380_tqueue, NCR5380_main);
-
-static inline void queue_main(void)
+static inline void queue_main(struct NCR5380_hostdata *hostdata)
 {
-	if (!main_running) {
+	if (!hostdata->main_running) {
 		/* If in interrupt and NCR5380_main() not already running,
 		   queue it on the 'immediate' task queue, to be processed
 		   immediately after the current interrupt processing has
 		   finished. */
-		schedule_work(&NCR5380_tqueue);
+		schedule_work(&hostdata->main_task);
 	}
 	/* else: nothing to do: the running NCR5380_main() will pick up
 	   any newly queued command. */
 }
 
-
-static inline void NCR5380_all_init(void)
-{
-	static int done = 0;
-	if (!done) {
-		dprintk(NDEBUG_INIT, "scsi : NCR5380_all_init()\n");
-		done = 1;
-	}
-}
-
 /**
  * NCR58380_info - report driver and host information
  * @instance: relevant scsi host instance
@@ -703,7 +687,7 @@ static void NCR5380_print_status(struct
 
 	local_irq_save(flags);
 	printk("NCR5380: coroutine is%s running.\n",
-		main_running ? "" : "n't");
+		hostdata->main_running ? "" : "n't");
 	if (!hostdata->connected)
 		printk("scsi%d: no currently connected command\n", HOSTNO);
 	else
@@ -746,7 +730,7 @@ static int __maybe_unused NCR5380_show_i
 
 	local_irq_save(flags);
 	seq_printf(m, "NCR5380: coroutine is%s running.\n",
-		main_running ? "" : "n't");
+		hostdata->main_running ? "" : "n't");
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
 	else
@@ -783,8 +767,7 @@ static int __init NCR5380_init(struct Sc
 	int i;
 	SETUP_HOSTDATA(instance);
 
-	NCR5380_all_init();
-
+	hostdata->host = instance;
 	hostdata->aborted = 0;
 	hostdata->id_mask = 1 << instance->this_id;
 	hostdata->id_higher_mask = 0;
@@ -805,10 +788,7 @@ static int __init NCR5380_init(struct Sc
 	hostdata->disconnected_queue = NULL;
 	hostdata->flags = flags;
 
-	if (!the_template) {
-		the_template = instance->hostt;
-		first_instance = instance;
-	}
+	INIT_WORK(&hostdata->main_task, NCR5380_main);
 
 	prepare_info(instance);
 
@@ -829,7 +809,9 @@ static int __init NCR5380_init(struct Sc
 
 static void NCR5380_exit(struct Scsi_Host *instance)
 {
-	cancel_work_sync(&NCR5380_tqueue);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	cancel_work_sync(&hostdata->main_task);
 }
 
 /**
@@ -924,9 +906,9 @@ static int NCR5380_queue_command(struct
 	 * unconditionally, because it cannot be already running.
 	 */
 	if (in_interrupt() || irqs_disabled())
-		queue_main();
+		queue_main(hostdata);
 	else
-		NCR5380_main(NULL);
+		NCR5380_main(&hostdata->main_task);
 	return 0;
 }
 
@@ -955,9 +937,10 @@ static inline void maybe_release_dma_irq
 
 static void NCR5380_main(struct work_struct *work)
 {
+	struct NCR5380_hostdata *hostdata =
+		container_of(work, struct NCR5380_hostdata, main_task);
+	struct Scsi_Host *instance = hostdata->host;
 	struct scsi_cmnd *tmp, *prev;
-	struct Scsi_Host *instance = first_instance;
-	struct NCR5380_hostdata *hostdata = HOSTDATA(instance);
 	int done;
 	unsigned long flags;
 
@@ -982,9 +965,9 @@ static void NCR5380_main(struct work_str
 	   'main_running' is set here, and queues/executes main via the
 	   task queue, it doesn't do any harm, just this instance of main
 	   won't find any work left to do. */
-	if (main_running)
+	if (hostdata->main_running)
 		return;
-	main_running = 1;
+	hostdata->main_running = 1;
 
 	local_save_flags(flags);
 	do {
@@ -1103,7 +1086,7 @@ static void NCR5380_main(struct work_str
 	/* Better allow ints _after_ 'main_running' has been cleared, else
 	   an interrupt could believe we'll pick up the work it left for
 	   us, but we won't see it anymore here... */
-	main_running = 0;
+	hostdata->main_running = 0;
 	local_irq_restore(flags);
 }
 
@@ -1215,7 +1198,7 @@ static void NCR5380_dma_complete(struct
 
 static irqreturn_t NCR5380_intr(int irq, void *dev_id)
 {
-	struct Scsi_Host *instance = first_instance;
+	struct Scsi_Host *instance = dev_id;
 	int done = 1, handled = 0;
 	unsigned char basr;
 
@@ -1287,7 +1270,7 @@ static irqreturn_t NCR5380_intr(int irq,
 	if (!done) {
 		dprintk(NDEBUG_INTR, "scsi%d: in int routine, calling main\n", HOSTNO);
 		/* Put a call to NCR5380_main() on the queue... */
-		queue_main();
+		queue_main(shost_priv(instance));
 	}
 	return IRQ_RETVAL(handled);
 }
@@ -1767,7 +1750,7 @@ static int NCR5380_transfer_pio(struct S
  * Returns : 0 on success, -1 on failure.
  */
 
-static int do_abort(struct Scsi_Host *host)
+static int do_abort(struct Scsi_Host *instance)
 {
 	unsigned char tmp, *msgptr, phase;
 	int len;
@@ -1802,7 +1785,7 @@ static int do_abort(struct Scsi_Host *ho
 	msgptr = &tmp;
 	len = 1;
 	phase = PHASE_MSGOUT;
-	NCR5380_transfer_pio(host, &phase, &len, &msgptr);
+	NCR5380_transfer_pio(instance, &phase, &len, &msgptr);
 
 	/*
 	 * If we got here, and the command completed successfully,
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-11-12 16:11:39.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-11-12 16:11:42.000000000 +1100
@@ -110,7 +110,7 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         atari_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase) & SR_IO))
 
-#define NCR5380_acquire_dma_irq(instance)      falcon_get_lock()
+#define NCR5380_acquire_dma_irq(instance)      falcon_get_lock(instance)
 #define NCR5380_release_dma_irq(instance)      falcon_release_lock()
 
 #include "NCR5380.h"
@@ -468,15 +468,15 @@ static void falcon_release_lock(void)
  * command immediately but tell the SCSI mid-layer to defer.
  */
 
-static int falcon_get_lock(void)
+static int falcon_get_lock(struct Scsi_Host *instance)
 {
 	if (IS_A_TT())
 		return 1;
 
 	if (in_interrupt())
-		return stdma_try_lock(scsi_falcon_intr, NULL);
+		return stdma_try_lock(scsi_falcon_intr, instance);
 
-	stdma_lock(scsi_falcon_intr, NULL);
+	stdma_lock(scsi_falcon_intr, instance);
 	return 1;
 }
 


