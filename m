From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix NC5380 locking and delayed work handling
Date: Sat, 14 Aug 2004 19:03:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040814170316.GA27814@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:16302 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264251AbUHNRDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Aug 2004 13:03:21 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: kenn@linux.ie, linux-scsi@vger.kernel.org

 - move delayed workqueue handling to schedule_delayed_work instead
   of the old horrible global list thing
 - add NCR5380_exit to make sure all delayed work is flushed on HBA
   (or module) removal
 - fix locking


--- 1.25/drivers/scsi/NCR5380.c	2004-07-26 23:21:24 +02:00
+++ edited/drivers/scsi/NCR5380.c	2004-08-14 18:49:19 +02:00
@@ -310,12 +310,8 @@
  * possible) function may be used.  Before the specific driver initialization
  * code finishes, NCR5380_print_options should be called.
  */
-
 static int do_abort(struct Scsi_Host *host);
 static void do_reset(struct Scsi_Host *host);
-static struct NCR5380_hostdata *first_host = NULL;
-static struct NCR5380_hostdata *last_host = NULL;
-static struct timer_list usleep_timer;
 
 /*
  *	initialize_SCp		-	init the scsi pointer field
@@ -533,9 +529,6 @@
 #define USLEEP_WAITLONG USLEEP_SLEEP
 #endif
 
-static struct Scsi_Host *expires_first = NULL;
-static spinlock_t timer_lock;	/* Guards expires list */
-
 /* 
  * Function : int should_disconnect (unsigned char cmd)
  *
@@ -578,90 +571,10 @@
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
-}
-
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
+	hostdata->time_expires = jiffies + timeout;
+	schedule_delayed_work(&hostdata->coroutine, hostdata->time_expires);
 }
 
 
@@ -788,22 +701,6 @@
 }
 
 /**
- *	NCR5380_coroutine_running	-	coroutine status
- *	@instance: controller to check
- *
- *	Return true if the co-routine for this controller is running
- *	or scheduled to run
- *
- *	FIXME: this test function belongs in the workqueue code!
- */
- 
-static int NCR5380_coroutine_running(struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *)instance->hostdata;
-	return test_bit(0, &hostdata->coroutine.pending);
-}
-
-/**
  *	NCR5380_print_status 	-	dump controller info
  *	@instance: controller to dump
  *
@@ -819,8 +716,6 @@
 	char *start;
 	int len;
 
-	printk("NCR5380 : coroutine is%s running.\n",  NCR5380_coroutine_running(instance)? "" : "n't");
-
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
@@ -900,7 +795,6 @@
 	SPRINTF("Highwater I/O busy_spin_counts -- write: %d  read: %d\n", pas_wmaxi, pas_maxi);
 #endif
 	spin_lock_irq(instance->host_lock);
-	SPRINTF("NCR5380 : coroutine is%s running.\n", NCR5380_coroutine_running(instance) ? "" : "n't");
 	if (!hostdata->connected)
 		SPRINTF("scsi%d: no currently connected command\n", instance->host_no);
 	else
@@ -912,7 +806,6 @@
 	SPRINTF("scsi%d: disconnected_queue\n", instance->host_no);
 	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
 		pos = lprint_Scsi_Cmnd(ptr, pos, buffer, length);
-
 	spin_unlock_irq(instance->host_lock);
 	
 	*start = buffer;
@@ -964,7 +857,7 @@
  *	Locks: interrupts must be enabled when we are called 
  */
 
-static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
+static int __devinit NCR5380_init(struct Scsi_Host *instance, int flags)
 {
 	NCR5380_local_declare();
 	int i, pass;
@@ -984,7 +877,6 @@
 #endif
 
 	NCR5380_setup(instance);
-	NCR5380_all_init();
 
 	hostdata->aborted = 0;
 	hostdata->id_mask = 1 << instance->this_id;
@@ -1021,18 +913,8 @@
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
-	hostdata->next_timer = NULL;
 
 #ifndef AUTOSENSE
 	if ((instance->cmd_per_lun > 1) || instance->can_queue > 1)
@@ -1089,6 +971,19 @@
 }
 
 /**
+ *	NCR5380_exit	-	remove an NCR5380
+ *	@instance: adapter to remove
+ */
+
+static void __devexit NCR5380_exit(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+
+	cancel_delayed_work(&hostdata->coroutine);
+	flush_scheduled_work();
+}
+
+/**
  *	NCR5380_queue_command 		-	queue a command
  *	@cmd: SCSI command
  *	@done: completion handler
@@ -1169,6 +1064,7 @@
 	return 0;
 }
 
+
 /**
  *	NCR5380_main	-	NCR state machines
  *
@@ -1184,28 +1080,11 @@
 static void NCR5380_main(void *p)
 {
 	struct NCR5380_hostdata *hostdata = p;
+	struct Scsi_Host *instance = hostdata->host;
 	Scsi_Cmnd *tmp, *prev;
-	struct Scsi_Host *instance;
 	int done;
-	unsigned long flags = 0;
 	
-	/*
-	 * We run (with interrupts disabled) until we're sure that none of 
-	 * the host adapters have anything that can be done, at which point 
-	 * we can exit
-	 *
-	 * Interrupts are enabled before doing various other internal 
-	 * instructions, after we've decided that we need to run through
-	 * the loop again.
-	 *
-	 * this should prevent any race conditions.
-	 */
-
-	instance = hostdata->host;
-
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_lock_irqsave(instance->host_lock, flags);
-
+	spin_lock_irq(instance->host_lock);
 	do {
 		/* Lock held here */
 		done = 1;
@@ -1286,8 +1165,7 @@
 				LIST(tmp, hostdata->issue_queue);
 				tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 				hostdata->issue_queue = tmp;
-				hostdata->time_expires = jiffies + USLEEP_WAITLONG;
-				NCR5380_set_timer(instance);
+				NCR5380_set_timer(hostdata, USLEEP_WAITLONG);
 			}
 		}	/* if hostdata->selecting */
 		if (hostdata->connected
@@ -1304,8 +1182,7 @@
 			break;
 	} while (!done);
 	
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irq(instance->host_lock);
 }
 
 #ifndef DONT_USE_INTR
@@ -1330,12 +1207,13 @@
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	int done;
 	unsigned char basr;
+	unsigned long flags;
 
 	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n", irq));
 
 	do {
 		done = 1;
-		spin_lock_irq(instance->host_lock);
+		spin_lock_irqsave(instance->host_lock, flags);
 		/* Look for pending interrupts */
 		NCR5380_setup(instance);
 		basr = NCR5380_read(BUS_AND_STATUS_REG);
@@ -1386,7 +1264,7 @@
 #endif
 			}
 		}	/* if BASR_IRQ */
-		spin_unlock_irq(instance->host_lock);
+		spin_unlock_irqrestore(instance->host_lock, flags);
 		if(!done)
 			schedule_work(&hostdata->coroutine);
 	} while (!done);
@@ -1469,12 +1347,8 @@
 	int err;
 	NCR5380_setup(instance);
 
-	if (hostdata->selecting) {
-		if(instance->irq != SCSI_IRQ_NONE)
-			spin_unlock_irq(instance->host_lock);
-		goto part2;	/* RvC: sorry prof. Dijkstra, but it keeps the
-				   rest of the code nearly the same */
-	}
+	if (hostdata->selecting)
+		goto part2;
 
 	hostdata->restart_select = 0;
 
@@ -1495,16 +1369,12 @@
 	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
 	NCR5380_write(MODE_REG, MR_ARBITRATE);
 
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_unlock_irq(instance->host_lock);
 
 	/* We can be relaxed here, interrupts are on, we are
 	   in workqueue context, the birds are singing in the trees */
-
+	spin_unlock_irq(instance->host_lock);
 	err = NCR5380_poll_politely(instance, INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS, ICR_ARBITRATION_PROGRESS, 5*HZ);
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_lock_irq(instance->host_lock);
-
+	spin_lock_irq(instance->host_lock);
 	if (err < 0) {
 		printk(KERN_DEBUG "scsi: arbitration timeout at %d\n", __LINE__);
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1628,8 +1498,7 @@
 	if (!value && (hostdata->select_time < HZ/4)) {
 		/* RvC: we still must wait for a device response */
 		hostdata->select_time++;	/* after 25 ticks the device has failed */
-		hostdata->time_expires = jiffies + 1;
-		NCR5380_set_timer(instance);
+		NCR5380_set_timer(hostdata, 1);
 		return 0;	/* RvC: we return here with hostdata->selecting set,
 				   to go to sleep */
 	}
@@ -1638,8 +1507,6 @@
 					   waiting period */
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		if(instance->irq != SCSI_IRQ_NONE)
-			spin_lock_irq(instance->host_lock);
 		NCR5380_reselect(instance);
 		printk("scsi%d : reselection after won arbitration?\n", instance->host_no);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -1665,8 +1532,6 @@
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 			return -1;
 		}
-		if(instance->irq != SCSI_IRQ_NONE)
-			spin_lock_irq(instance->host_lock);
 		cmd->result = DID_BAD_TARGET << 16;
 		collect_stats(hostdata, cmd);
 		cmd->scsi_done(cmd);
@@ -1693,11 +1558,13 @@
 	 */
 
 	/* Wait for start of REQ/ACK handshake */
-	
+
+	spin_unlock_irq(instance->host_lock);
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+	spin_lock_irq(instance->host_lock);
 	
-	if(err)
-	{	printk(KERN_ERR "scsi%d: timeout at NCR5380.c:%d\n", instance->host_no, __LINE__);
+	if(err) {
+		printk(KERN_ERR "scsi%d: timeout at NCR5380.c:%d\n", instance->host_no, __LINE__);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		goto failed;
 	}
@@ -1705,9 +1572,6 @@
 	dprintk(NDEBUG_SELECTION, ("scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id));
 	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
 
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_lock_irq(instance->host_lock);
-		
 	len = 1;
 	cmd->tag = 0;
 
@@ -1721,14 +1585,10 @@
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 
 	initialize_SCp(cmd);
-
-
 	return 0;
 
 	/* Selection failed */
 failed:
-	if(instance->irq != SCSI_IRQ_NONE)
-		spin_lock_irq(instance->host_lock);
 	return -1;
 
 }
@@ -1804,8 +1664,7 @@
 		while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ) && !break_allowed);
 		if (!(tmp & SR_REQ)) {
 			/* timeout condition */
-			hostdata->time_expires = jiffies + USLEEP_SLEEP;
-			NCR5380_set_timer(instance);
+			NCR5380_set_timer(hostdata, USLEEP_SLEEP);
 			break;
 		}
 
@@ -2643,9 +2502,8 @@
 				 */
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
-					hostdata->time_expires = jiffies + USLEEP_SLEEP;
+					NCR5380_set_timer(hostdata, USLEEP_SLEEP);
 					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
-					NCR5380_set_timer(instance);
 					return;
 				}
 				break;
@@ -2664,9 +2522,8 @@
 			/* RvC: go to sleep if polling time expired
 			 */
 			if (!cmd->device->disconnect && time_after_eq(jiffies, poll_time)) {
-				hostdata->time_expires = jiffies + USLEEP_SLEEP;
+				NCR5380_set_timer(hostdata, USLEEP_SLEEP);
 				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
-				NCR5380_set_timer(instance);
 				return;
 			}
 		}
===== drivers/scsi/NCR5380.h 1.9 vs edited =====
--- 1.9/drivers/scsi/NCR5380.h	2003-08-21 10:36:23 +02:00
+++ edited/drivers/scsi/NCR5380.h	2004-08-14 18:49:19 +02:00
@@ -251,7 +251,6 @@
 struct NCR5380_hostdata {
 	NCR5380_implementation_fields;		/* implementation specific */
 	struct Scsi_Host *host;			/* Host backpointer */
-	struct NCR5380_hostdata *next;		/* Next in our hot chain */
 	unsigned char id_mask, id_higher_mask;	/* 1 << id, all bits greater */
 	unsigned char targets_present;		/* targets we have connected
 						   to, so we can call a select
@@ -270,7 +269,6 @@
 	volatile unsigned aborted:1;		/* flag, says aborted */
 	int flags;
 	unsigned long time_expires;		/* in jiffies, set prior to sleeping */
-	struct Scsi_Host *next_timer;
 	int select_time;			/* timer in select for target response */
 	volatile Scsi_Cmnd *selecting;
 	struct work_struct coroutine;		/* our co-routine */
@@ -295,6 +293,7 @@
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
 #endif
 static int NCR5380_init(struct Scsi_Host *instance, int flags);
+static void NCR5380_exit(struct Scsi_Host *instance);
 static void NCR5380_information_transfer(struct Scsi_Host *instance);
 #ifndef DONT_USE_INTR
 static irqreturn_t NCR5380_intr(int irq, void *dev_id, struct pt_regs *regs);
===== drivers/scsi/dmx3191d.c 1.16 vs edited =====
--- 1.16/drivers/scsi/dmx3191d.c	2004-05-12 17:46:20 +02:00
+++ edited/drivers/scsi/dmx3191d.c	2004-08-14 18:52:29 +02:00
@@ -106,9 +106,10 @@
 
 static int dmx3191d_release_resources(struct Scsi_Host *instance)
 {
-	release_region(instance->io_port, DMX3191D_REGION);
 	if(instance->irq!=SCSI_IRQ_NONE)
 		free_irq(instance->irq, instance);
+	NCR5380_exit(instance);
+	release_region(instance->io_port, DMX3191D_REGION);
 
 	return 0;
 }
===== drivers/scsi/dtc.c 1.13 vs edited =====
--- 1.13/drivers/scsi/dtc.c	2004-05-12 17:46:20 +02:00
+++ edited/drivers/scsi/dtc.c	2004-08-14 20:22:41 +02:00
@@ -451,6 +451,7 @@
 {
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
+	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
===== drivers/scsi/g_NCR5380.c 1.28 vs edited =====
--- 1.28/drivers/scsi/g_NCR5380.c	2004-07-26 23:22:32 +02:00
+++ edited/drivers/scsi/g_NCR5380.c	2004-08-14 18:53:15 +02:00
@@ -501,6 +501,10 @@
 {
 	NCR5380_local_declare();
 	NCR5380_setup(instance);
+	
+	if (instance->irq != SCSI_IRQ_NONE)
+		free_irq(instance->irq, NULL);
+	NCR5380_exit(instance);
 
 #ifndef CONFIG_SCSI_G_NCR5380_MEM
 	release_region(instance->NCR5380_instance_name, instance->n_io_port);
@@ -508,8 +512,6 @@
 	release_mem_region(instance->NCR5380_instance_name, NCR5380_region_size);
 #endif
 
-	if (instance->irq != SCSI_IRQ_NONE)
-		free_irq(instance->irq, NULL);
 
 	return 0;
 }
===== drivers/scsi/mac_scsi.c 1.9 vs edited =====
--- 1.9/drivers/scsi/mac_scsi.c	2004-05-12 17:46:22 +02:00
+++ edited/drivers/scsi/mac_scsi.c	2004-08-14 18:52:55 +02:00
@@ -326,6 +326,7 @@
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
 		free_irq (shpnt->irq, NCR5380_intr);
+	NCR5380_exit(shpnt);
 
 	return 0;
 }
===== drivers/scsi/pas16.c 1.14 vs edited =====
--- 1.14/drivers/scsi/pas16.c	2004-05-12 17:46:22 +02:00
+++ edited/drivers/scsi/pas16.c	2004-08-14 20:15:53 +02:00
@@ -605,6 +605,7 @@
 {
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
+	NCR5380_exit(shost);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
===== drivers/scsi/t128.c 1.14 vs edited =====
--- 1.14/drivers/scsi/t128.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/t128.c	2004-08-14 20:21:47 +02:00
@@ -284,6 +284,7 @@
 {
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
+	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
===== drivers/scsi/arm/cumana_1.c 1.22 vs edited =====
--- 1.22/drivers/scsi/arm/cumana_1.c	2004-06-19 17:53:23 +02:00
+++ edited/drivers/scsi/arm/cumana_1.c	2004-08-14 18:54:42 +02:00
@@ -321,6 +321,7 @@
 
 	scsi_remove_host(host);
 	free_irq(host->irq, host);
+	NCR5380_exit(host);
 	release_region(host->io_port, host->n_io_port);
 	scsi_host_put(host);
 }
===== drivers/scsi/arm/ecoscsi.c 1.22 vs edited =====
--- 1.22/drivers/scsi/arm/ecoscsi.c	2004-06-19 17:53:25 +02:00
+++ edited/drivers/scsi/arm/ecoscsi.c	2004-08-14 18:54:21 +02:00
@@ -222,6 +222,7 @@
 
 	if (shpnt->irq != IRQ_NONE)
 		free_irq(shpnt->irq, NULL);
+	NCR5380_exit(host);
 	if (shpnt->io_port)
 		release_region(shpnt->io_port, shpnt->n_io_port);
 
===== drivers/scsi/arm/oak.c 1.23 vs edited =====
--- 1.23/drivers/scsi/arm/oak.c	2004-06-19 17:53:31 +02:00
+++ edited/drivers/scsi/arm/oak.c	2004-08-14 18:53:39 +02:00
@@ -179,6 +179,7 @@
 	ecard_set_drvdata(ec, NULL);
 	scsi_remove_host(host);
 
+	NCR5380_exit(host);
 	release_region(host->io_port, host->n_io_port);
 	scsi_host_put(host);
 }
