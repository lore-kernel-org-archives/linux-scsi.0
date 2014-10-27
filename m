From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 22/36] atari_scsi: Fix atari_scsi deadlocks on Falcon
Date: Mon, 27 Oct 2014 16:26:29 +1100
Message-ID: <20141027052612.445434791@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-stdma_try_lock
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Don't disable irqs when waiting for the ST DMA "lock"; its release may
require an interrupt.

Introduce stdma_try_lock() for use in soft irq context. atari_scsi now tells
the SCSI mid-layer to defer queueing a command if the ST DMA lock is not
available, as per Michael's patch:
http://marc.info/?l=linux-m68k&m=139095335824863&w=2

The falcon_got_lock variable is race prone: we can't disable IRQs while
waiting to acquire the lock, so after acquiring it there must be some
interval during which falcon_got_lock remains false. Introduce
stdma_is_locked_by() to replace falcon_got_lock.

The falcon_got_lock tests in the EH handlers are incorrect these days. It
can happen that an EH handler is called after a command completes normally.
Remove these checks along with falcon_got_lock.

Also remove the complicated and racy fairness wait queues. If fairness is an
issue (when SCSI competes with IDE for the ST DMA interrupt), the solution
is likely to be a lower value for host->can_queue.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Changes since v1:
- Use Geert's suggestion for simpler stdma_is_locked_by() implementation.

---
 arch/m68k/atari/stdma.c             |   61 ++++++++++++++++++----------
 arch/m68k/include/asm/atari_stdma.h |    4 -
 drivers/scsi/atari_NCR5380.c        |   35 +++++-----------
 drivers/scsi/atari_scsi.c           |   76 +++++++-----------------------------
 4 files changed, 69 insertions(+), 107 deletions(-)

Index: linux/arch/m68k/atari/stdma.c
===================================================================
--- linux.orig/arch/m68k/atari/stdma.c	2014-10-27 16:17:59.000000000 +1100
+++ linux/arch/m68k/atari/stdma.c	2014-10-27 16:25:45.000000000 +1100
@@ -59,6 +59,31 @@ static irqreturn_t stdma_int (int irq, v
 /************************* End of Prototypes **************************/
 
 
+/**
+ * stdma_try_lock - attempt to acquire ST DMA interrupt "lock"
+ * @handler: interrupt handler to use after acquisition
+ *
+ * Returns !0 if lock was acquired; otherwise 0.
+ */
+
+int stdma_try_lock(irq_handler_t handler, void *data)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (stdma_locked) {
+		local_irq_restore(flags);
+		return 0;
+	}
+
+	stdma_locked   = 1;
+	stdma_isr      = handler;
+	stdma_isr_data = data;
+	local_irq_restore(flags);
+	return 1;
+}
+EXPORT_SYMBOL(stdma_try_lock);
+
 
 /*
  * Function: void stdma_lock( isrfunc isr, void *data )
@@ -78,19 +103,10 @@ static irqreturn_t stdma_int (int irq, v
 
 void stdma_lock(irq_handler_t handler, void *data)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);		/* protect lock */
-
 	/* Since the DMA is used for file system purposes, we
 	 have to sleep uninterruptible (there may be locked
 	 buffers) */
-	wait_event(stdma_wait, !stdma_locked);
-
-	stdma_locked   = 1;
-	stdma_isr      = handler;
-	stdma_isr_data = data;
-	local_irq_restore(flags);
+	wait_event(stdma_wait, stdma_try_lock(handler, data));
 }
 EXPORT_SYMBOL(stdma_lock);
 
@@ -122,22 +138,25 @@ void stdma_release(void)
 EXPORT_SYMBOL(stdma_release);
 
 
-/*
- * Function: int stdma_others_waiting( void )
- *
- * Purpose: Check if someone waits for the ST-DMA lock.
- *
- * Inputs: none
- *
- * Returns: 0 if no one is waiting, != 0 otherwise
+/**
+ * stdma_is_locked_by - allow lock holder to check whether it needs to release.
+ * @handler: interrupt handler previously used to acquire lock.
  *
+ * Returns !0 if locked for the given handler; 0 otherwise.
  */
 
-int stdma_others_waiting(void)
+int stdma_is_locked_by(irq_handler_t handler)
 {
-	return waitqueue_active(&stdma_wait);
+	unsigned long flags;
+	int result;
+
+	local_irq_save(flags);
+	result = stdma_locked && (stdma_isr == handler);
+	local_irq_restore(flags);
+
+	return result;
 }
-EXPORT_SYMBOL(stdma_others_waiting);
+EXPORT_SYMBOL(stdma_is_locked_by);
 
 
 /*
Index: linux/arch/m68k/include/asm/atari_stdma.h
===================================================================
--- linux.orig/arch/m68k/include/asm/atari_stdma.h	2014-10-27 16:17:59.000000000 +1100
+++ linux/arch/m68k/include/asm/atari_stdma.h	2014-10-27 16:25:45.000000000 +1100
@@ -8,11 +8,11 @@
 
 /***************************** Prototypes *****************************/
 
+int stdma_try_lock(irq_handler_t, void *);
 void stdma_lock(irq_handler_t handler, void *data);
 void stdma_release( void );
-int stdma_others_waiting( void );
 int stdma_islocked( void );
-void *stdma_locked_by( void );
+int stdma_is_locked_by(irq_handler_t);
 void stdma_init( void );
 
 /************************* End of Prototypes **************************/
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:36.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:45.000000000 +1100
@@ -879,10 +879,10 @@ static void NCR5380_exit(struct Scsi_Hos
  *
  */
 
-static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd,
-                                     void (*done)(struct scsi_cmnd *))
+static int NCR5380_queue_command(struct Scsi_Host *instance,
+                                 struct scsi_cmnd *cmd)
 {
-	SETUP_HOSTDATA(cmd->device->host);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	struct scsi_cmnd *tmp;
 	unsigned long flags;
 
@@ -893,7 +893,7 @@ static int NCR5380_queue_command_lck(str
 		printk(KERN_NOTICE "scsi%d: WRITE attempted with NO_WRITE debugging flag set\n",
 		       H_NO(cmd));
 		cmd->result = (DID_ERROR << 16);
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
@@ -904,8 +904,6 @@ static int NCR5380_queue_command_lck(str
 	 */
 
 	SET_NEXT(cmd, NULL);
-	cmd->scsi_done = done;
-
 	cmd->result = 0;
 
 	/*
@@ -915,7 +913,6 @@ static int NCR5380_queue_command_lck(str
 	 * sense data is only guaranteed to be valid while the condition exists.
 	 */
 
-	local_irq_save(flags);
 	/* ++guenther: now that the issue queue is being set up, we can lock ST-DMA.
 	 * Otherwise a running NCR5380_main may steal the lock.
 	 * Lock before actually inserting due to fairness reasons explained in
@@ -928,11 +925,13 @@ static int NCR5380_queue_command_lck(str
 	 * because also a timer int can trigger an abort or reset, which would
 	 * alter queues and touch the lock.
 	 */
-	if (!IS_A_TT()) {
-		/* perhaps stop command timer here */
-		falcon_get_lock();
-		/* perhaps restart command timer here */
-	}
+	/* perhaps stop command timer here */
+	if (!falcon_get_lock())
+		return SCSI_MLQUEUE_HOST_BUSY;
+	/* perhaps restart command timer here */
+
+	local_irq_save(flags);
+
 	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
 		LIST(cmd, hostdata->issue_queue);
 		SET_NEXT(cmd, hostdata->issue_queue);
@@ -956,15 +955,13 @@ static int NCR5380_queue_command_lck(str
 	 * If we're not in an interrupt, we can call NCR5380_main()
 	 * unconditionally, because it cannot be already running.
 	 */
-	if (in_interrupt() || ((flags >> 8) & 7) >= 6)
+	if (in_interrupt() || irqs_disabled())
 		queue_main();
 	else
 		NCR5380_main(NULL);
 	return 0;
 }
 
-static DEF_SCSI_QCMD(NCR5380_queue_command)
-
 /*
  * Function : NCR5380_main (void)
  *
@@ -2555,10 +2552,6 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 
 	local_irq_save(flags);
 
-	if (!IS_A_TT() && !falcon_got_lock)
-		printk(KERN_ERR "scsi%d: !!BINGO!! Falcon has no lock in NCR5380_abort\n",
-		       HOSTNO);
-
 	dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		    NCR5380_read(BUS_AND_STATUS_REG),
 		    NCR5380_read(STATUS_REG));
@@ -2757,10 +2750,6 @@ static int NCR5380_bus_reset(struct scsi
 	struct scsi_cmnd *connected, *disconnected_queue;
 #endif
 
-	if (!IS_A_TT() && !falcon_got_lock)
-		printk(KERN_ERR "scsi%d: !!BINGO!! Falcon has no lock in NCR5380_reset\n",
-		       H_NO(cmd));
-
 	NCR5380_print_status(cmd->device->host);
 
 	/* get in phase */
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-27 16:25:36.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-10-27 16:25:45.000000000 +1100
@@ -184,7 +184,7 @@ static void atari_scsi_fetch_restbytes(v
 static irqreturn_t scsi_tt_intr(int irq, void *dummy);
 static irqreturn_t scsi_falcon_intr(int irq, void *dummy);
 static void falcon_release_lock_if_possible(struct NCR5380_hostdata *hostdata);
-static void falcon_get_lock(void);
+static int falcon_get_lock(void);
 #ifdef CONFIG_ATARI_SCSI_RESET_BOOT
 static void atari_scsi_reset_boot(void);
 #endif
@@ -473,17 +473,10 @@ static void atari_scsi_fetch_restbytes(v
 #endif /* REAL_DMA */
 
 
-static int falcon_got_lock = 0;
-static DECLARE_WAIT_QUEUE_HEAD(falcon_fairness_wait);
-static int falcon_trying_lock = 0;
-static DECLARE_WAIT_QUEUE_HEAD(falcon_try_wait);
 static int falcon_dont_release = 0;
 
 /* This function releases the lock on the DMA chip if there is no
- * connected command and the disconnected queue is empty. On
- * releasing, instances of falcon_get_lock are awoken, that put
- * themselves to sleep for fairness. They can now try to get the lock
- * again (but others waiting longer more probably will win).
+ * connected command and the disconnected queue is empty.
  */
 
 static void falcon_release_lock_if_possible(struct NCR5380_hostdata *hostdata)
@@ -495,20 +488,12 @@ static void falcon_release_lock_if_possi
 
 	local_irq_save(flags);
 
-	if (falcon_got_lock && !hostdata->disconnected_queue &&
-	    !hostdata->issue_queue && !hostdata->connected) {
-
-		if (falcon_dont_release) {
-#if 0
-			printk("WARNING: Lock release not allowed. Ignored\n");
-#endif
-			local_irq_restore(flags);
-			return;
-		}
-		falcon_got_lock = 0;
+	if (!hostdata->disconnected_queue &&
+	    !hostdata->issue_queue &&
+	    !hostdata->connected &&
+	    !falcon_dont_release &&
+	    stdma_is_locked_by(scsi_falcon_intr))
 		stdma_release();
-		wake_up(&falcon_fairness_wait);
-	}
 
 	local_irq_restore(flags);
 }
@@ -517,51 +502,20 @@ static void falcon_release_lock_if_possi
  * If the DMA isn't locked already for SCSI, it tries to lock it by
  * calling stdma_lock(). But if the DMA is locked by the SCSI code and
  * there are other drivers waiting for the chip, we do not issue the
- * command immediately but wait on 'falcon_fairness_queue'. We will be
- * waked up when the DMA is unlocked by some SCSI interrupt. After that
- * we try to get the lock again.
- * But we must be prepared that more than one instance of
- * falcon_get_lock() is waiting on the fairness queue. They should not
- * try all at once to call stdma_lock(), one is enough! For that, the
- * first one sets 'falcon_trying_lock', others that see that variable
- * set wait on the queue 'falcon_try_wait'.
- * Complicated, complicated.... Sigh...
+ * command immediately but tell the SCSI mid-layer to defer.
  */
 
-static void falcon_get_lock(void)
+static int falcon_get_lock(void)
 {
-	unsigned long flags;
-
 	if (IS_A_TT())
-		return;
+		return 1;
 
-	local_irq_save(flags);
-
-	wait_event_cmd(falcon_fairness_wait,
-		in_interrupt() || !falcon_got_lock || !stdma_others_waiting(),
-		local_irq_restore(flags),
-		local_irq_save(flags));
-
-	while (!falcon_got_lock) {
-		if (in_irq())
-			panic("Falcon SCSI hasn't ST-DMA lock in interrupt");
-		if (!falcon_trying_lock) {
-			falcon_trying_lock = 1;
-			stdma_lock(scsi_falcon_intr, NULL);
-			falcon_got_lock = 1;
-			falcon_trying_lock = 0;
-			wake_up(&falcon_try_wait);
-		} else {
-			wait_event_cmd(falcon_try_wait,
-				falcon_got_lock && !falcon_trying_lock,
-				local_irq_restore(flags),
-				local_irq_save(flags));
-		}
+	if (in_interrupt()) {
+		return stdma_try_lock(scsi_falcon_intr, NULL);
+	} else {
+		stdma_lock(scsi_falcon_intr, NULL);
+		return 1;
 	}
-
-	local_irq_restore(flags);
-	if (!falcon_got_lock)
-		panic("Falcon SCSI: someone stole the lock :-(\n");
 }
 
 
