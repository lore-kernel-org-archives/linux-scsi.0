From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH NCR5380 updates
Date: Tue, 18 Nov 2003 11:26:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031118102649.GA1442@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:48856 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262129AbTKRK04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 05:26:56 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

Hi Alan,

do you still have time to look at NCR5380 occasionally?  I recently
stumbled over the driver and have a few updates for 2.6:

  - use schedule_delayed_work() instead of the global timer for the
    coroutines
  - use dev_id field in the isr instead of searching the global list
    of hosts (g_NCR5380 had to be updated to pass in that one for
    this change)
  - use spinlocks even in the non-interrupt driven case, with SMP
    and PREEMPT that's needed these days
  - update the big comments to reflect reality

Unfortunately I don't any hardware to test, so if you could give this
a spin..


--- 1.23/drivers/scsi/NCR5380.c	Sun Sep 28 02:38:22 2003
+++ edited/drivers/scsi/NCR5380.c	Wed Nov  5 10:44:43 2003
@@ -113,32 +113,18 @@
 
 /*
  * Design
- * Issues :
  *
- * The other Linux SCSI drivers were written when Linux was Intel PC-only,
- * and specifically for each board rather than each chip.  This makes their
- * adaptation to platforms like the Mac (Some of which use NCR5380's)
- * more difficult than it has to be.
- *
- * Also, many of the SCSI drivers were written before the command queuing
- * routines were implemented, meaning their implementations of queued 
- * commands were hacked on rather than designed in from the start.
- *
- * When I designed the Linux SCSI drivers I figured that 
- * while having two different SCSI boards in a system might be useful
- * for debugging things, two of the same type wouldn't be used.
- * Well, I was wrong and a number of users have mailed me about running
- * multiple high-performance SCSI boards in a server.
- *
- * Finally, when I get questions from users, I have no idea what 
- * revision of my driver they are running.
- *
- * This driver attempts to address these problems :
  * This is a generic 5380 driver.  To use it on a different platform, 
  * one simply writes appropriate system specific macros (ie, data
  * transfer - some PC's will use the I/O bus, 68K's must use 
  * memory mapped) and drops this file in their 'C' wrapper.
  *
+ * (Note from hch:  unfortunately it was not enough for the different
+ * m68k folks and instead of improving this driver they copied it
+ * and hacked it up for their needs.  As a consequence they lost
+ * most updates to this driver, sigh.  Maybe someone will actually
+ * fixup their all the drivers to use a common core..)
+ *
  * As far as command queueing, two queues are maintained for 
  * each 5380 in the system - commands that haven't been issued yet,
  * and commands that are currently executing.  This means that an 
@@ -148,17 +134,6 @@
  * allowing multiple commands to propagate all the way to a SCSI-II device 
  * while a command is already executing.
  *
- * To solve the multiple-boards-in-the-same-system problem, 
- * there is a separate instance structure for each instance
- * of a 5380 in the system.  So, multiple NCR5380 drivers will
- * be able to coexist with appropriate changes to the high level
- * SCSI code.  
- *
- * A NCR5380_PUBLIC_REVISION macro is provided, with the release
- * number (updated for each public release) printed by the 
- * NCR5380_print_options command, which should be called from the 
- * wrapper detect function, so that I know what release of the driver
- * users are using.
  *
  * Issues specific to the NCR5380 : 
  *
@@ -183,11 +158,10 @@
  * Architecture :
  *
  * At the heart of the design is a coroutine, NCR5380_main,
- * which is started when not running by the interrupt handler,
- * timer, and queue command function.  It attempts to establish
- * I_T_L or I_T_L_Q nexuses by removing the commands from the 
- * issue queue and calling NCR5380_select() if a nexus 
- * is not established. 
+ * which is started from a workqueue for each NCR5380 host in the
+ * system.  It attempts to establish I_T_L or I_T_L_Q nexuses by
+ * removing the commands from the issue queue and calling
+ * NCR5380_select() if a nexus is not established. 
  *
  * Once a nexus is established, the NCR5380_information_transfer()
  * phase goes through the various phases as instructed by the target.
@@ -289,33 +263,14 @@
  * NCR5380_pwrite(instance, src, count)
  * NCR5380_pread(instance, dst, count);
  *
- * If nothing specific to this implementation needs doing (ie, with external
- * hardware), you must also define 
- *  
- * NCR5380_queue_command
- * NCR5380_reset
- * NCR5380_abort
- * NCR5380_proc_info
- *
- * to be the global entry points into the specific driver, ie 
- * #define NCR5380_queue_command t128_queue_command.
- *
- * If this is not done, the routines will be defined as static functions
- * with the NCR5380* names and the user must provide a globally
- * accessible wrapper function.
- *
  * The generic driver is initialized by calling NCR5380_init(instance),
  * after setting the appropriate host specific fields and ID.  If the 
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
- * possible) function may be used.  Before the specific driver initialization
- * code finishes, NCR5380_print_options should be called.
+ * possible) function may be used.
  */
 
 static int do_abort(struct Scsi_Host *host);
 static void do_reset(struct Scsi_Host *host);
-static struct NCR5380_hostdata *first_host = NULL;
-static struct NCR5380_hostdata *last_host = NULL;
-static struct timer_list usleep_timer;
 
 /*
  *	initialize_SCp		-	init the scsi pointer field
@@ -533,9 +488,6 @@
 #define USLEEP_WAITLONG USLEEP_SLEEP
 #endif
 
-static struct Scsi_Host *expires_first = NULL;
-static spinlock_t timer_lock;	/* Guards expires list */
-
 /* 
  * Function : int should_disconnect (unsigned char cmd)
  *
@@ -578,93 +530,12 @@
 	}
 }
 
-/*
- * Assumes instance->time_expires has been set in higher level code.
- * We should move to a timer per host
- *
- * Locks: Takes the timer queue lock
- */
-
-static int NCR5380_set_timer(struct Scsi_Host *instance)
+static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata, unsigned long timeout)
 {
-	struct Scsi_Host *tmp, **prev;
-	unsigned long flags;
-
-	if (((struct NCR5380_hostdata *) (instance->hostdata))->next_timer) {
-		return -1;
-	}
-	
-	spin_lock_irqsave(&timer_lock, flags);
-	for (prev = &expires_first, tmp = expires_first; tmp; prev = &(((struct NCR5380_hostdata *) tmp->hostdata)->next_timer), tmp = ((struct NCR5380_hostdata *) tmp->hostdata)->next_timer)
-		if (((struct NCR5380_hostdata *) instance->hostdata)->time_expires < ((struct NCR5380_hostdata *) tmp->hostdata)->time_expires)
-			break;
-
-	((struct NCR5380_hostdata *) instance->hostdata)->next_timer = tmp;
-	*prev = instance;
-
-	mod_timer(&usleep_timer, ((struct NCR5380_hostdata *) expires_first->hostdata)->time_expires);
-	
-	spin_unlock_irqrestore(&timer_lock, flags);
-	return 0;
+	hostdata->time_expires = jiffies + timeout;
+	schedule_delayed_work(&hostdata->coroutine, hostdata->time_expires);
 }
 
-/**
- *	NCR5380_timer_fn	-	handle polled timeouts
- *	@unused: unused
- *
- *	Walk the list of controllers, find which controllers have exceeded
- *	their expiry timeout and then schedule the processing co-routine to
- *	do the real work.
- *
- *	Doing something about unwanted reentrancy here might be useful 
- *
- *	Locks: disables irqs, takes and frees the timer lock
- */
- 
-static void NCR5380_timer_fn(unsigned long unused)
-{
-	struct Scsi_Host *instance;
-	struct NCR5380_hostdata *hostdata;
-	unsigned long flags;
-
-	spin_lock_irqsave(&timer_lock, flags);
-	for (; expires_first && time_before_eq(((struct NCR5380_hostdata *) expires_first->hostdata)->time_expires, jiffies);) 
-	{
-		hostdata = (struct NCR5380_hostdata *) expires_first->hostdata;
-		schedule_work(&hostdata->coroutine);
-		instance = hostdata->next_timer;
-		hostdata->next_timer = NULL;
-		hostdata->time_expires = 0;
-		expires_first = instance;
-	}
-
-	del_timer(&usleep_timer);
-	if (expires_first) {
-		usleep_timer.expires = ((struct NCR5380_hostdata *) expires_first->hostdata)->time_expires;
-		add_timer(&usleep_timer);
-	}
-	spin_unlock_irqrestore(&timer_lock, flags);
-}
-
-/**
- *	NCR5380_all_init	-	global setup
- *
- *	Set up the global values and timers needed by the NCR5380 driver
- */
- 
-static inline void NCR5380_all_init(void)
-{
-	static int done = 0;
-	if (!done) {
-		dprintk(NDEBUG_INIT, ("scsi : NCR5380_all_init()\n"));
-		done = 1;
-		init_timer(&usleep_timer);
-		spin_lock_init(&timer_lock);
-		usleep_timer.function = NCR5380_timer_fn;
-	}
-}
-
-
 static int probe_irq __initdata = 0;
 
 /**
@@ -984,7 +855,6 @@
 #endif
 
 	NCR5380_setup(instance);
-	NCR5380_all_init();
 
 	hostdata->aborted = 0;
 	hostdata->id_mask = 1 << instance->this_id;
@@ -1021,15 +891,6 @@
 	else
 		hostdata->flags = FLAG_CHECK_LAST_BYTE_SENT | flags;
 
-	hostdata->next = NULL;
-	
-	if (!first_host)
-		first_host = hostdata;
-	else
-		last_host->next = hostdata;
-
-	last_host = hostdata;
-	
 	hostdata->host = instance;
 	hostdata->time_expires = 0;
 	hostdata->next_timer = NULL;
@@ -1184,8 +1045,8 @@
 static void NCR5380_main(void *p)
 {
 	struct NCR5380_hostdata *hostdata = p;
+	struct Scsi_Host *instance = hostdata->host;
 	Scsi_Cmnd *tmp, *prev;
-	struct Scsi_Host *instance;
 	int done;
 	unsigned long flags = 0;
 	
@@ -1200,14 +1061,8 @@
 	 *
 	 * this should prevent any race conditions.
 	 */
-
-	instance = hostdata->host;
-
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_lock_irqsave(instance->host_lock, flags);
-
+	spin_lock_irqsave(instance->host_lock, flags);
 	do {
-		/* Lock held here */
 		done = 1;
 		if (!hostdata->connected && !hostdata->selecting) {
 			dprintk(NDEBUG_MAIN, ("scsi%d : not connected\n", instance->host_no));
@@ -1286,8 +1141,7 @@
 				LIST(tmp, hostdata->issue_queue);
 				tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 				hostdata->issue_queue = tmp;
-				hostdata->time_expires = jiffies + USLEEP_WAITLONG;
-				NCR5380_set_timer(instance);
+				NCR5380_set_timer(hostdata, USLEEP_WAITLONG);
 			}
 		}	/* if hostdata->selecting */
 		if (hostdata->connected
@@ -1304,8 +1158,7 @@
 			break;
 	} while (!done);
 	
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(instance->host_lock, flags);
 }
 
 #ifndef DONT_USE_INTR
@@ -1326,81 +1179,70 @@
 static irqreturn_t NCR5380_intr(int irq, void *dev_id, struct pt_regs *regs) 
 {
 	NCR5380_local_declare();
-	struct Scsi_Host *instance;
+	struct Scsi_Host *instance = dev_id;
 	int done;
 	unsigned char basr;
 	struct NCR5380_hostdata *hostdata;
-	int handled = 0;
 
 	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n", irq));
 
 	do {
 		done = 1;
-		/* The instance list is constant while the driver is
-		   loaded */
-		for (hostdata = first_host; hostdata != NULL; hostdata = hostdata->next)
-		{
-			instance = hostdata->host;
-			if (instance->irq == irq) {
-				handled = 1;
-				spin_lock_irq(instance->host_lock);
-				/* Look for pending interrupts */
-				NCR5380_setup(instance);
-				basr = NCR5380_read(BUS_AND_STATUS_REG);
-				/* XXX dispatch to appropriate routine if found and done=0 */
-				if (basr & BASR_IRQ) {
-					NCR5380_dprint(NDEBUG_INTR, instance);
-					if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
-						done = 0;
-						dprintk(NDEBUG_INTR, ("scsi%d : SEL interrupt\n", instance->host_no));
-						NCR5380_reselect(instance);
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-					} else if (basr & BASR_PARITY_ERROR) {
-						dprintk(NDEBUG_INTR, ("scsi%d : PARITY interrupt\n", instance->host_no));
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-					} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-						dprintk(NDEBUG_INTR, ("scsi%d : RESET interrupt\n", instance->host_no));
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-					} else {
+		spin_lock_irq(instance->host_lock);
+		/* Look for pending interrupts */
+		NCR5380_setup(instance);
+		basr = NCR5380_read(BUS_AND_STATUS_REG);
+		/* XXX dispatch to appropriate routine if found and done=0 */
+		if (basr & BASR_IRQ) {
+			NCR5380_dprint(NDEBUG_INTR, instance);
+			if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
+				done = 0;
+				dprintk(NDEBUG_INTR, ("scsi%d : SEL interrupt\n", instance->host_no));
+				NCR5380_reselect(instance);
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			} else if (basr & BASR_PARITY_ERROR) {
+				dprintk(NDEBUG_INTR, ("scsi%d : PARITY interrupt\n", instance->host_no));
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
+				dprintk(NDEBUG_INTR, ("scsi%d : RESET interrupt\n", instance->host_no));
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			} else {
 #if defined(REAL_DMA)
-						/*
-						 * We should only get PHASE MISMATCH and EOP interrupts
-						 * if we have DMA enabled, so do a sanity check based on
-						 * the current setting of the MODE register.
-						 */
-
-						if ((NCR5380_read(MODE_REG) & MR_DMA) && ((basr & BASR_END_DMA_TRANSFER) || !(basr & BASR_PHASE_MATCH))) {
-							int transfered;
+				/*
+				 * We should only get PHASE MISMATCH and EOP interrupts
+				 * if we have DMA enabled, so do a sanity check based on
+				 * the current setting of the MODE register.
+				 */
+				if ((NCR5380_read(MODE_REG) & MR_DMA) && ((basr & BASR_END_DMA_TRANSFER) || !(basr & BASR_PHASE_MATCH))) {
+					int transfered;
 
-							if (!hostdata->connected)
-								panic("scsi%d : received end of DMA interrupt with no connected cmd\n", instance->hostno);
+					if (!hostdata->connected)
+						panic("scsi%d : received end of DMA interrupt with no connected cmd\n", instance->hostno);
 
-							transfered = (hostdata->dmalen - NCR5380_dma_residual(instance));
-							hostdata->connected->SCp.this_residual -= transferred;
-							hostdata->connected->SCp.ptr += transferred;
-							hostdata->dmalen = 0;
+					transfered = (hostdata->dmalen - NCR5380_dma_residual(instance));
+					hostdata->connected->SCp.this_residual -= transferred;
+					hostdata->connected->SCp.ptr += transferred;
+					hostdata->dmalen = 0;
 
-							(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+					(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 							
-							/* FIXME: we need to poll briefly then defer a workqueue task ! */
-							NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2*HZ);
+					/* FIXME: we need to poll briefly then defer a workqueue task ! */
+					NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2*HZ);
 
-							NCR5380_write(MODE_REG, MR_BASE);
-							NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-						}
+					NCR5380_write(MODE_REG, MR_BASE);
+					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+				}
 #else
-						dprintk(NDEBUG_INTR, ("scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG)));
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+				dprintk(NDEBUG_INTR, ("scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG)));
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 #endif
-					}
-				}	/* if BASR_IRQ */
-				spin_unlock_irq(instance->host_lock);
-				if(!done)
-					schedule_work(&hostdata->coroutine);
-			}	/* if (instance->irq == irq) */
-		}
+			}
+		}	/* if BASR_IRQ */
+		spin_unlock_irq(instance->host_lock);
+		if (!done)
+			schedule_work(&hostdata->coroutine);
 	} while (!done);
-	return IRQ_RETVAL(handled);
+	return IRQ_HANDLED;
 }
 
 #endif 
@@ -1480,8 +1322,7 @@
 	NCR5380_setup(instance);
 
 	if (hostdata->selecting) {
-		if(instance->irq != SCSI_IRQ_NONE)
-			spin_unlock_irq(instance->host_lock);
+		spin_unlock_irq(instance->host_lock);
 		goto part2;	/* RvC: sorry prof. Dijkstra, but it keeps the
 				   rest of the code nearly the same */
 	}
@@ -1505,8 +1346,7 @@
 	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
 	NCR5380_write(MODE_REG, MR_ARBITRATE);
 
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_unlock_irq(instance->host_lock);
+	spin_unlock_irq(instance->host_lock);
 
 	/* We can be relaxed here, interrupts are on, we are
 	   in workqueue context, the birds are singing in the trees */
@@ -1638,8 +1478,7 @@
 	if (!value && (hostdata->select_time < HZ/4)) {
 		/* RvC: we still must wait for a device response */
 		hostdata->select_time++;	/* after 25 ticks the device has failed */
-		hostdata->time_expires = jiffies + 1;
-		NCR5380_set_timer(instance);
+		NCR5380_set_timer(hostdata, 1);
 		return 0;	/* RvC: we return here with hostdata->selecting set,
 				   to go to sleep */
 	}
@@ -1648,8 +1487,7 @@
 					   waiting period */
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		if(instance->irq != SCSI_IRQ_NONE)
-			spin_lock_irq(instance->host_lock);
+		spin_lock_irq(instance->host_lock);
 		NCR5380_reselect(instance);
 		printk("scsi%d : reselection after won arbitration?\n", instance->host_no);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -1675,8 +1513,7 @@
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 			return -1;
 		}
-		if(instance->irq != SCSI_IRQ_NONE)
-			spin_lock_irq(instance->host_lock);
+		spin_lock_irq(instance->host_lock);
 		cmd->result = DID_BAD_TARGET << 16;
 		collect_stats(hostdata, cmd);
 		cmd->scsi_done(cmd);
@@ -1715,8 +1552,7 @@
 	dprintk(NDEBUG_SELECTION, ("scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id));
 	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
 
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_lock_irq(instance->host_lock);
+	spin_lock_irq(instance->host_lock);
 		
 	len = 1;
 	cmd->tag = 0;
@@ -1737,8 +1573,7 @@
 
 	/* Selection failed */
 failed:
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_lock_irq(instance->host_lock);
+	spin_lock_irq(instance->host_lock);
 	return -1;
 
 }
@@ -1814,8 +1649,7 @@
 		while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ) && !break_allowed);
 		if (!(tmp & SR_REQ)) {
 			/* timeout condition */
-			hostdata->time_expires = jiffies + USLEEP_SLEEP;
-			NCR5380_set_timer(instance);
+			NCR5380_set_timer(hostdata, USLEEP_SLEEP);
 			break;
 		}
 
@@ -2653,9 +2487,8 @@
 				 */
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
-					hostdata->time_expires = jiffies + USLEEP_SLEEP;
 					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
-					NCR5380_set_timer(instance);
+					NCR5380_set_timer(hostdata, USLEEP_SLEEP);
 					return;
 				}
 				break;
@@ -2674,9 +2507,8 @@
 			/* RvC: go to sleep if polling time expired
 			 */
 			if (!cmd->device->disconnect && time_after_eq(jiffies, poll_time)) {
-				hostdata->time_expires = jiffies + USLEEP_SLEEP;
 				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
-				NCR5380_set_timer(instance);
+				NCR5380_set_timer(hostdata, USLEEP_SLEEP);
 				return;
 			}
 		}
--- 1.9/drivers/scsi/NCR5380.h	Thu Aug 21 10:36:23 2003
+++ edited/drivers/scsi/NCR5380.h	Tue Nov  4 16:42:59 2003
@@ -248,10 +248,9 @@
 #define FLAG_DTC3181E			16	/* DTC3181E */
 
 #ifndef ASM
 struct NCR5380_hostdata {
 	NCR5380_implementation_fields;		/* implementation specific */
 	struct Scsi_Host *host;			/* Host backpointer */
-	struct NCR5380_hostdata *next;		/* Next in our hot chain */
 	unsigned char id_mask, id_higher_mask;	/* 1 << id, all bits greater */
 	unsigned char targets_present;		/* targets we have connected
 						   to, so we can call a select
--- 1.24/drivers/scsi/g_NCR5380.c	Thu Oct  2 09:12:16 2003
+++ edited/drivers/scsi/g_NCR5380.c	Wed Nov  5 10:21:04 2003
@@ -445,7 +445,7 @@
 			instance->irq = NCR5380_probe_irq(instance, 0xffff);
 
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, generic_NCR5380_intr, SA_INTERRUPT, "NCR5380", NULL)) {
+			if (request_irq(instance->irq, generic_NCR5380_intr, SA_INTERRUPT, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
