From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] de-uglify scsi.c
Date: Sat, 26 Apr 2003 19:03:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426190303.A20780@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:59398 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S262284AbTDZQvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 12:51:05 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

It's the last file of the scsi core that needed to be converted from
the old scsi style.


--- 1.103/drivers/scsi/scsi.c	Mon Apr 14 11:34:14 2003
+++ edited/drivers/scsi/scsi.c	Sat Apr 26 16:30:26 2003
@@ -38,38 +38,22 @@
 
 #include <linux/config.h>
 #include <linux/module.h>
-
+#include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/stat.h>
-#include <linux/blk.h>
-#include <linux/interrupt.h>
+#include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
-
-#define __KERNEL_SYSCALLS__
-
 #include <linux/unistd.h>
 #include <linux/spinlock.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/dma.h>
-#include <asm/uaccess.h>
+#include <linux/kmod.h>
 
 #include "scsi.h"
 #include "hosts.h"
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 
 /*
  * Definitions and constants.
@@ -86,18 +70,16 @@
  * vendor unique and we will depend upon the command length being
  * supplied correctly in cmd_len.
  */
-#define CDB_SIZE(SCpnt)	((((SCpnt->cmnd[0] >> 5) & 7) < 6) ? \
-				COMMAND_SIZE(SCpnt->cmnd[0]) : SCpnt->cmd_len)
+#define CDB_SIZE(cmd)	(((((cmd)->cmnd[0] >> 5) & 7) < 6) ? \
+				COMMAND_SIZE((cmd)->cmnd[0]) : (cmd)->cmd_len)
 
 /*
  * Data declarations.
  */
 unsigned long scsi_pid;
-Scsi_Cmnd *last_cmnd;
+struct scsi_cmnd *last_cmnd;
 static unsigned long serial_number;
 
-static struct list_head done_q[NR_CPUS] __cacheline_aligned;
-
 /*
  * List of all highlevel drivers.
  */
@@ -110,8 +92,7 @@
  */
 unsigned int scsi_logging_level;
 
-const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE] =
-{
+const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE] = {
 	"Direct-Access    ",
 	"Sequential-Access",
 	"Printer          ",
@@ -136,14 +117,12 @@
 /* 
  * Function prototypes.
  */
-extern void scsi_times_out(Scsi_Cmnd * SCpnt);
+extern void scsi_times_out(struct scsi_cmnd *cmd);
 
-#ifdef MODULE
 MODULE_PARM(scsi_logging_level, "i");
 MODULE_PARM_DESC(scsi_logging_level, "SCSI logging level; should be zero or nonzero");
 
-#else
-
+#ifndef MODULE
 static int __init scsi_logging_setup(char *str)
 {
 	int tmp;
@@ -157,9 +136,7 @@
 		return 0;
 	}
 }
-
 __setup("scsi_logging=", scsi_logging_setup);
-
 #endif
 
 /*
@@ -177,30 +154,26 @@
  *              to track the difference between a command and a
  *              request.  A request is a pending item in the queue that
  *              has not yet reached the top of the queue.
+ *
+ * XXX(hch):	Need to add a gfp_mask argument.
  */
-
-Scsi_Request *scsi_allocate_request(Scsi_Device * device)
+struct scsi_request *scsi_allocate_request(struct scsi_device *sdev)
 {
-  	Scsi_Request *SRpnt = NULL;
-        const int offset = ALIGN(sizeof(Scsi_Request), 4);
-        const int size = offset + sizeof(struct request);
-  
-  	if (!device)
-  		panic("No device passed to scsi_allocate_request().\n");
+	const int offset = ALIGN(sizeof(struct scsi_request), 4);
+	const int size = offset + sizeof(struct request);
+	struct scsi_request *sreq;
   
-        SRpnt = (Scsi_Request *) kmalloc(size, GFP_ATOMIC);
-	if( SRpnt == NULL )
-	{
-		return NULL;
-	}
-	memset(SRpnt, 0, size);
-        SRpnt->sr_request = (struct request *)(((char *)SRpnt) + offset);
-	SRpnt->sr_device = device;
-	SRpnt->sr_host = device->host;
-	SRpnt->sr_magic = SCSI_REQ_MAGIC;
-	SRpnt->sr_data_direction = SCSI_DATA_UNKNOWN;
+	sreq = kmalloc(size, GFP_ATOMIC);
+	if (likely(sreq != NULL)) {
+		memset(sreq, 0, size);
+		sreq->sr_request = (struct request *)(((char *)sreq) + offset);
+		sreq->sr_device = sdev;
+		sreq->sr_host = sdev->host;
+		sreq->sr_magic = SCSI_REQ_MAGIC;
+		sreq->sr_data_direction = SCSI_DATA_UNKNOWN;
+	}
 
-	return SRpnt;
+	return sreq;
 }
 
 /*
@@ -208,29 +181,21 @@
  *
  * Purpose:     Release a request descriptor.
  *
- * Arguments:   device    - device for which we want a request
+ * Arguments:   sreq    - request to release
  *
  * Lock status: No locks assumed to be held.  This function is SMP-safe.
- *
- * Returns:     Pointer to request block.
- *
- * Notes:       With the new queueing code, it becomes important
- *              to track the difference between a command and a
- *              request.  A request is a pending item in the queue that
- *              has not yet reached the top of the queue.  We still need
- *              to free a request when we are done with it, of course.
  */
-void scsi_release_request(Scsi_Request * req)
+void scsi_release_request(struct scsi_request *sreq)
 {
-	if( req->sr_command != NULL )
-	{
-    		request_queue_t *q = req->sr_device->request_queue;
-		scsi_put_command(req->sr_command);
-		req->sr_command = NULL;
+	if (likely(sreq->sr_command != NULL)) {
+    		struct request_queue *q = sreq->sr_device->request_queue;
+
+		scsi_put_command(sreq->sr_command);
+		sreq->sr_command = NULL;
 		scsi_queue_next_request(q, NULL);
 	}
 
-	kfree(req);
+	kfree(sreq);
 }
 
 struct scsi_host_cmd_pool {
@@ -424,42 +389,31 @@
  *
  * Purpose:     Dispatch a command to the low-level driver.
  *
- * Arguments:   SCpnt - command block we are dispatching.
+ * Arguments:   cmd - command block we are dispatching.
  *
  * Notes:
  */
-int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt)
+int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
-#ifdef DEBUG_DELAY
-	unsigned long clock;
-#endif
-	struct Scsi_Host *host;
-	int rtn = 0;
+	struct Scsi_Host *host = cmd->device->host;
 	unsigned long flags = 0;
 	unsigned long timeout;
-
-#if DEBUG
-	unsigned long *ret = 0;
-#ifdef __mips__
-	__asm__ __volatile__("move\t%0,$31":"=r"(ret));
-#else
-	ret = __builtin_return_address(0);
-#endif
-#endif
-
-	host = SCpnt->device->host;
+	int rtn = 1;
 
 	/* Assign a unique nonzero serial_number. */
+	/* XXX(hch): this is racy */
 	if (++serial_number == 0)
 		serial_number = 1;
-	SCpnt->serial_number = serial_number;
-	SCpnt->pid = scsi_pid++;
+	cmd->serial_number = serial_number;
+	cmd->pid = scsi_pid++;
+
 	/* 
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
-	if (SCpnt->device->scsi_level <= SCSI_2)
-		SCpnt->cmnd[1] = (SCpnt->cmnd[1] & 0x1f) |
-			(SCpnt->device->lun << 5 & 0xe0);
+	if (cmd->device->scsi_level <= SCSI_2) {
+		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
+			       (cmd->device->lun << 5 & 0xe0);
+	}
 
 	/*
 	 * We will wait MIN_RESET_DELAY clock ticks after the last reset so
@@ -483,65 +437,63 @@
 		host->resetting = 0;
 	}
 
-	scsi_add_timer(SCpnt, SCpnt->timeout_per_command, scsi_times_out);
+	scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
 
 	/*
-	 * We will use a queued command if possible, otherwise we will emulate the
-	 * queuing and calling of completion function ourselves.
+	 * We will use a queued command if possible, otherwise we will
+	 * emulate the queuing and calling of completion function ourselves.
 	 */
-	SCSI_LOG_MLQUEUE(3, printk("scsi_dispatch_cmnd (host = %d, channel = %d, target = %d, "
-	       "command = %p, buffer = %p, \nbufflen = %d, done = %p)\n",
-	SCpnt->device->host->host_no, SCpnt->device->channel, SCpnt->device->id, SCpnt->cmnd,
-			    SCpnt->buffer, SCpnt->bufflen, SCpnt->done));
+	SCSI_LOG_MLQUEUE(3, printk("scsi_dispatch_cmnd (host = %d, "
+				"channel = %d, target = %d, command = %p, "
+				"buffer = %p, \nbufflen = %d, done = %p)\n",
+				host->host_no, cmd->device->channel,
+				cmd->device->id, cmd->cmnd, cmd->buffer,
+				cmd->bufflen, cmd->done));
+
+	cmd->state = SCSI_STATE_QUEUED;
+	cmd->owner = SCSI_OWNER_LOWLEVEL;
+
+	/*
+	 * Before we queue this command, check if the command
+	 * length exceeds what the host adapter can handle.
+	 */
+	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
+		SCSI_LOG_MLQUEUE(3,
+				printk("queuecommand : command too long.\n"));
+		cmd->result = (DID_ABORT << 16);
+
+		spin_lock_irqsave(host->host_lock, flags);
+		scsi_done(cmd);
+		spin_unlock_irqrestore(host->host_lock, flags);
+		goto out;
+	}
 
-	SCpnt->state = SCSI_STATE_QUEUED;
-	SCpnt->owner = SCSI_OWNER_LOWLEVEL;
 	if (host->can_queue) {
 		SCSI_LOG_MLQUEUE(3, printk("queuecommand : routine at %p\n",
 					   host->hostt->queuecommand));
-		/*
-		 * Before we queue this command, check if the command
-		 * length exceeds what the host adapter can handle.
-		 */
-		if (CDB_SIZE(SCpnt) <= SCpnt->device->host->max_cmd_len) {
-			spin_lock_irqsave(host->host_lock, flags);
-			rtn = host->hostt->queuecommand(SCpnt, scsi_done);
-			spin_unlock_irqrestore(host->host_lock, flags);
-			if (rtn != 0) {
-				scsi_queue_insert(SCpnt, rtn == SCSI_MLQUEUE_DEVICE_BUSY ? rtn : SCSI_MLQUEUE_HOST_BUSY);
-				SCSI_LOG_MLQUEUE(3,
-				   printk("queuecommand : request rejected\n"));                                
-			}
-		} else {
+
+		spin_lock_irqsave(host->host_lock, flags);
+		rtn = host->hostt->queuecommand(cmd, scsi_done);
+		spin_unlock_irqrestore(host->host_lock, flags);
+		if (rtn) {
+			scsi_queue_insert(cmd,
+				(rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
+					rtn : SCSI_MLQUEUE_HOST_BUSY);
 			SCSI_LOG_MLQUEUE(3,
-				printk("queuecommand : command too long.\n"));
-			SCpnt->result = (DID_ABORT << 16);
-			spin_lock_irqsave(host->host_lock, flags);
-			scsi_done(SCpnt);
-			spin_unlock_irqrestore(host->host_lock, flags);
-			rtn = 1;
+			    printk("queuecommand : request rejected\n"));
 		}
 	} else {
-		int temp;
+		SCSI_LOG_MLQUEUE(3, printk("command() :  routine at %p\n",
+					host->hostt->command));
 
-		SCSI_LOG_MLQUEUE(3, printk("command() :  routine at %p\n", host->hostt->command));
-                spin_lock_irqsave(host->host_lock, flags);
-		temp = host->hostt->command(SCpnt);
-		SCpnt->result = temp;
-#ifdef DEBUG_DELAY
-                spin_unlock_irqrestore(host->host_lock, flags);
-		clock = jiffies + 4 * HZ;
-		while (time_before(jiffies, clock)) {
-			barrier();
-			cpu_relax();
-		}
-		printk("done(host = %d, result = %04x) : routine at %p\n",
-		       host->host_no, temp, host->hostt->command);
-                spin_lock_irqsave(host->host_lock, flags);
-#endif
-		scsi_done(SCpnt);
-                spin_unlock_irqrestore(host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
+		cmd->result = host->hostt->command(cmd);
+		scsi_done(cmd);
+		spin_unlock_irqrestore(host->host_lock, flags);
+		rtn = 0;
 	}
+
+ out:
 	SCSI_LOG_MLQUEUE(3, printk("leaving scsi_dispatch_cmnd()\n"));
 	return rtn;
 }
@@ -550,10 +502,10 @@
  * Function:    scsi_init_cmd_from_req
  *
  * Purpose:     Queue a SCSI command
- * Purpose:     Initialize a Scsi_Cmnd from a Scsi_Request
+ * Purpose:     Initialize a struct scsi_cmnd from a struct scsi_request
  *
- * Arguments:   SCpnt     - command descriptor.
- *              SRpnt     - Request from the queue.
+ * Arguments:   cmd       - command descriptor.
+ *              sreq      - Request from the queue.
  *
  * Lock status: None needed.
  *
@@ -570,65 +522,61 @@
  *              The request structure is generally used by ioctls and character
  *              devices.
  */
-void scsi_init_cmd_from_req(Scsi_Cmnd * SCpnt, Scsi_Request * SRpnt)
+void scsi_init_cmd_from_req(struct scsi_cmnd *cmd, struct scsi_request *sreq)
 {
-	struct Scsi_Host *host = SCpnt->device->host;
+	sreq->sr_command = cmd;
 
-	SCpnt->owner = SCSI_OWNER_MIDLEVEL;
-	SRpnt->sr_command = SCpnt;
+	cmd->owner = SCSI_OWNER_MIDLEVEL;
+	cmd->cmd_len = sreq->sr_cmd_len;
+	cmd->use_sg = sreq->sr_use_sg;
 
-	if (!host) {
-		panic("Invalid or not present host.\n");
-	}
-
-	SCpnt->cmd_len = SRpnt->sr_cmd_len;
-	SCpnt->use_sg = SRpnt->sr_use_sg;
-
-        SCpnt->request = SRpnt->sr_request;
-	memcpy((void *) SCpnt->data_cmnd, (const void *) SRpnt->sr_cmnd, 
-	       sizeof(SCpnt->data_cmnd));
-	SCpnt->reset_chain = NULL;
-	SCpnt->serial_number = 0;
-	SCpnt->serial_number_at_timeout = 0;
-	SCpnt->bufflen = SRpnt->sr_bufflen;
-	SCpnt->buffer = SRpnt->sr_buffer;
-	SCpnt->flags = 0;
-	SCpnt->retries = 0;
-	SCpnt->allowed = SRpnt->sr_allowed;
-	SCpnt->done = SRpnt->sr_done;
-	SCpnt->timeout_per_command = SRpnt->sr_timeout_per_command;
-
-	SCpnt->sc_data_direction = SRpnt->sr_data_direction;
-
-	SCpnt->sglist_len = SRpnt->sr_sglist_len;
-	SCpnt->underflow = SRpnt->sr_underflow;
-
-	SCpnt->sc_request = SRpnt;
+	cmd->request = sreq->sr_request;
+	memcpy(cmd->data_cmnd, sreq->sr_cmnd, sizeof(cmd->data_cmnd));
+	cmd->reset_chain = NULL;
+	cmd->serial_number = 0;
+	cmd->serial_number_at_timeout = 0;
+	cmd->bufflen = sreq->sr_bufflen;
+	cmd->buffer = sreq->sr_buffer;
+	cmd->flags = 0;
+	cmd->retries = 0;
+	cmd->allowed = sreq->sr_allowed;
+	cmd->done = sreq->sr_done;
+	cmd->timeout_per_command = sreq->sr_timeout_per_command;
+	cmd->sc_data_direction = sreq->sr_data_direction;
+	cmd->sglist_len = sreq->sr_sglist_len;
+	cmd->underflow = sreq->sr_underflow;
+	cmd->sc_request = sreq;
+	memcpy(cmd->cmnd, sreq->sr_cmnd, sizeof(sreq->sr_cmnd));
 
-	memcpy((void *) SCpnt->cmnd, (const void *) SRpnt->sr_cmnd, 
-	       sizeof(SCpnt->cmnd));
-	/* Zero the sense buffer.  Some host adapters automatically request
+	/*
+	 * Zero the sense buffer.  Some host adapters automatically request
 	 * sense on error.  0 is not a valid sense code.
 	 */
-	memset((void *) SCpnt->sense_buffer, 0, sizeof SCpnt->sense_buffer);
-	SCpnt->request_buffer = SRpnt->sr_buffer;
-	SCpnt->request_bufflen = SRpnt->sr_bufflen;
-	SCpnt->old_use_sg = SCpnt->use_sg;
-	if (SCpnt->cmd_len == 0)
-		SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
-	SCpnt->old_cmd_len = SCpnt->cmd_len;
-	SCpnt->sc_old_data_direction = SCpnt->sc_data_direction;
-	SCpnt->old_underflow = SCpnt->underflow;
-
-	/* Start the timer ticking.  */
-
-	SCpnt->internal_timeout = NORMAL_TIMEOUT;
-	SCpnt->abort_reason = 0;
-	SCpnt->result = 0;
+	memset(cmd->sense_buffer, 0, sizeof(sreq->sr_sense_buffer));
+	cmd->request_buffer = sreq->sr_buffer;
+	cmd->request_bufflen = sreq->sr_bufflen;
+	cmd->old_use_sg = cmd->use_sg;
+	if (cmd->cmd_len == 0)
+		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
+	cmd->old_cmd_len = cmd->cmd_len;
+	cmd->sc_old_data_direction = cmd->sc_data_direction;
+	cmd->old_underflow = cmd->underflow;
+
+	/*
+	 * Start the timer ticking.
+	 */
+	cmd->internal_timeout = NORMAL_TIMEOUT;
+	cmd->abort_reason = 0;
+	cmd->result = 0;
 
 	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_init_cmd_from_req()\n"));
 }
 
+/*
+ * Per-CPU I/O completion queue.
+ */
+static struct list_head done_q[NR_CPUS] __cacheline_aligned;
+
 /**
  * scsi_done - Enqueue the finished SCSI command into the done queue.
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
@@ -644,9 +592,8 @@
  */
 void scsi_done(struct scsi_cmnd *cmd)
 {
-	int cpu;
 	unsigned long flags;
-	struct list_head *pdone_q;
+	int cpu;
 
 	/*
 	 * We don't have to worry about this one timing out any more.
@@ -659,7 +606,9 @@
 	if (!scsi_delete_timer(cmd))
 		return;
 
-	/* Set the serial numbers back to zero */
+	/*
+	 * Set the serial numbers back to zero
+	 */
 	cmd->serial_number = 0;
 	cmd->serial_number_at_timeout = 0;
 	cmd->state = SCSI_STATE_BHQUEUE;
@@ -671,12 +620,9 @@
 	 * and need no spinlock.
 	 */
 	local_irq_save(flags);
-
 	cpu = smp_processor_id();
-	pdone_q = &done_q[cpu];
-	list_add_tail(&cmd->eh_entry, pdone_q);
+	list_add_tail(&cmd->eh_entry, &done_q[cpu]);
 	cpu_raise_softirq(cpu, SCSI_SOFTIRQ);
-
 	local_irq_restore(flags);
 }
 
@@ -764,17 +710,15 @@
 			/*
 			 * Dump the sense information too.
 			 */
-			if ((status_byte(cmd->result)&CHECK_CONDITION) != 0) {
+			if (status_byte(cmd->result) & CHECK_CONDITION)
 				SCSI_LOG_MLCOMPLETE(3, print_sense("bh", cmd));
-			}
 
-			if (!scsi_eh_scmd_add(cmd, 0)) {
-				/*
-				 * We only get here if the error
-				 * recovery thread has died.
-				 */
+			/*
+			 * We only fail here if the error recovery thread
+			 * has died.
+			 */
+			if (!scsi_eh_scmd_add(cmd, 0))
 				scsi_finish_command(cmd);
-			}
 		}
 	}
 }
@@ -789,20 +733,20 @@
  *              level drivers should not become re-entrant as a result of
  *              this.
  */
-int scsi_retry_command(Scsi_Cmnd * SCpnt)
+int scsi_retry_command(struct scsi_cmnd *cmd)
 {
 	/*
 	 * Restore the SCSI command state.
 	 */
-	scsi_setup_cmd_retry(SCpnt);
+	scsi_setup_cmd_retry(cmd);
 
         /*
          * Zero the sense information from the last time we tried
          * this command.
          */
-	memset((void *) SCpnt->sense_buffer, 0, sizeof SCpnt->sense_buffer);
+	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
 
-	return scsi_dispatch_cmd(SCpnt);
+	return scsi_dispatch_cmd(cmd);
 }
 
 /*
@@ -812,68 +756,66 @@
  *              request, waking processes that are waiting on results,
  *              etc.
  */
-void scsi_finish_command(Scsi_Cmnd * SCpnt)
+void scsi_finish_command(struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *host;
-	Scsi_Device *device;
-	Scsi_Request * SRpnt;
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_request *sreq;
 	unsigned long flags;
 
-	host = SCpnt->device->host;
-	device = SCpnt->device;
+	scsi_host_busy_dec_and_test(shost, sdev);
 
-        /*
-         * We need to protect the decrement, as otherwise a race condition
-         * would exist.  Fiddling with SCpnt isn't a problem as the
-         * design only allows a single SCpnt to be active in only
-         * one execution context, but the device and host structures are
-         * shared.
-         */
-	scsi_host_busy_dec_and_test(host, device);
-	spin_lock_irqsave(SCpnt->device->request_queue->queue_lock, flags);
-	SCpnt->device->device_busy--;
-	spin_unlock_irqrestore(SCpnt->device->request_queue->queue_lock, flags);
+	/*
+	 * XXX(hch): We really want a nice helper for this..
+	 */
+	spin_lock_irqsave(&sdev->sdev_lock, flags);
+	sdev->device_busy--;
+	spin_unlock_irqrestore(&sdev->sdev_lock, flags);
 
         /*
          * Clear the flags which say that the device/host is no longer
          * capable of accepting new commands.  These are set in scsi_queue.c
          * for both the queue full condition on a device, and for a
          * host full condition on the host.
+	 *
+	 * XXX(hch): What about locking?
          */
-        host->host_blocked = 0;
-        device->device_blocked = 0;
+        shost->host_blocked = 0;
+        sdev->device_blocked = 0;
 
 	/*
 	 * If we have valid sense information, then some kind of recovery
 	 * must have taken place.  Make a note of this.
 	 */
-	if (SCSI_SENSE_VALID(SCpnt)) {
-		SCpnt->result |= (DRIVER_SENSE << 24);
-	}
-	SCSI_LOG_MLCOMPLETE(3, printk("Notifying upper driver of completion for device %d %x\n",
-				      SCpnt->device->id, SCpnt->result));
+	if (SCSI_SENSE_VALID(cmd))
+		cmd->result |= (DRIVER_SENSE << 24);
+
+	SCSI_LOG_MLCOMPLETE(3, printk("Notifying upper driver of completion "
+				"for device %d %x\n", sdev->id, cmd->result));
 
-	SCpnt->owner = SCSI_OWNER_HIGHLEVEL;
-	SCpnt->state = SCSI_STATE_FINISHED;
+	cmd->owner = SCSI_OWNER_HIGHLEVEL;
+	cmd->state = SCSI_STATE_FINISHED;
+
+	/*
+	 * We can get here with use_sg=0, causing a panic in the upper level
+	 */
+	cmd->use_sg = cmd->old_use_sg;
 
-	/* We can get here with use_sg=0, causing a panic in the upper level (DB) */
-	SCpnt->use_sg = SCpnt->old_use_sg;
-
-       /*
-	* If there is an associated request structure, copy the data over before we call the
-	* completion function.
-	*/
-	SRpnt = SCpnt->sc_request;
-	if( SRpnt != NULL ) {
-	       SRpnt->sr_result = SRpnt->sr_command->result;
-	       if( SRpnt->sr_result != 0 ) {
-		       memcpy(SRpnt->sr_sense_buffer,
-			      SRpnt->sr_command->sense_buffer,
-			      sizeof(SRpnt->sr_sense_buffer));
+	/*
+	 * If there is an associated request structure, copy the data over
+	 * before we call the completion function.
+	 */
+	sreq = cmd->sc_request;
+	if (sreq) {
+	       sreq->sr_result = sreq->sr_command->result;
+	       if (sreq->sr_result) {
+		       memcpy(sreq->sr_sense_buffer,
+			      sreq->sr_command->sense_buffer,
+			      sizeof(sreq->sr_sense_buffer));
 	       }
 	}
 
-	SCpnt->done(SCpnt);
+	cmd->done(cmd);
 }
 
 /*
@@ -882,7 +824,7 @@
  * Purpose:	Allow low level drivers to tell us to change the queue depth
  * 		on a specific SCSI device
  *
- * Arguments:	SDpnt	- SCSI Device in question
+ * Arguments:	sdev	- SCSI Device in question
  * 		tagged	- Do we use tagged queueing (non-0) or do we treat
  * 			  this device as an untagged device (0)
  * 		tags	- Number of tags allowed if tagged queueing enabled,
@@ -897,8 +839,10 @@
  * 		the right thing depending on whether or not the device is
  * 		currently active and whether or not it even has the
  * 		command blocks built yet.
+ *
+ * XXX(hch):	What exactly is device_request_lock trying to protect?
  */
-void scsi_adjust_queue_depth(Scsi_Device *SDpnt, int tagged, int tags)
+void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 {
 	static spinlock_t device_request_lock = SPIN_LOCK_UNLOCKED;
 	unsigned long flags;
@@ -906,35 +850,35 @@
 	/*
 	 * refuse to set tagged depth to an unworkable size
 	 */
-	if(tags <= 0)
+	if (tags <= 0)
 		return;
 	/*
 	 * Limit max queue depth on a single lun to 256 for now.  Remember,
 	 * we allocate a struct scsi_command for each of these and keep it
 	 * around forever.  Too deep of a depth just wastes memory.
 	 */
-	if(tags > 256)
+	if (tags > 256)
 		return;
 
 	spin_lock_irqsave(&device_request_lock, flags);
-	SDpnt->queue_depth = tags;
-	switch(tagged) {
+	sdev->queue_depth = tags;
+	switch (tagged) {
 		case MSG_ORDERED_TAG:
-			SDpnt->ordered_tags = 1;
-			SDpnt->simple_tags = 1;
+			sdev->ordered_tags = 1;
+			sdev->simple_tags = 1;
 			break;
 		case MSG_SIMPLE_TAG:
-			SDpnt->ordered_tags = 0;
-			SDpnt->simple_tags = 1;
+			sdev->ordered_tags = 0;
+			sdev->simple_tags = 1;
 			break;
 		default:
 			printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
 				"scsi_adjust_queue_depth, bad queue type, "
-				"disabled\n", SDpnt->host->host_no,
-				SDpnt->channel, SDpnt->id, SDpnt->lun); 
+				"disabled\n", sdev->host->host_no,
+				sdev->channel, sdev->id, sdev->lun); 
 		case 0:
-			SDpnt->ordered_tags = SDpnt->simple_tags = 0;
-			SDpnt->queue_depth = tags;
+			sdev->ordered_tags = sdev->simple_tags = 0;
+			sdev->queue_depth = tags;
 			break;
 	}
 	spin_unlock_irqrestore(&device_request_lock, flags);
@@ -947,7 +891,7 @@
  * 		specific SCSI device to determine if and when there is a
  * 		need to adjust the queue depth on the device.
  *
- * Arguments:	SDpnt	- SCSI Device in question
+ * Arguments:	sdev	- SCSI Device in question
  * 		depth	- Current number of outstanding SCSI commands on
  * 			  this device, not counting the one returned as
  * 			  QUEUE_FULL.
@@ -962,33 +906,32 @@
  * Notes:	Low level drivers may call this at any time and we will do
  * 		"The Right Thing."  We are interrupt context safe.
  */
-int scsi_track_queue_full(Scsi_Device *SDptr, int depth)
+int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 {
-	if((jiffies >> 4) != SDptr->last_queue_full_time) {
-		SDptr->last_queue_full_time = (jiffies >> 4);
-		if(SDptr->last_queue_full_depth == depth)
-			SDptr->last_queue_full_count++;
-		else {
-			SDptr->last_queue_full_count = 1;
-			SDptr->last_queue_full_depth = depth;
-		}
-		if(SDptr->last_queue_full_count > 10) {
-			if(SDptr->last_queue_full_depth < 8) {
-				/* Drop back to untagged */
-				scsi_adjust_queue_depth(SDptr, 0 /* untagged */,
-						SDptr->host->cmd_per_lun);
-				return -1;
-			}
-			if(SDptr->ordered_tags)
-				scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG,
-						depth);
-			else
-				scsi_adjust_queue_depth(SDptr, MSG_SIMPLE_TAG,
-						depth);
-			return depth;
-		}
+	if ((jiffies >> 4) == sdev->last_queue_full_time)
+		return 0;
+
+	sdev->last_queue_full_time = (jiffies >> 4);
+	if (sdev->last_queue_full_depth != depth) {
+		sdev->last_queue_full_count = 1;
+		sdev->last_queue_full_depth = depth;
+	} else {
+		sdev->last_queue_full_count++;
 	}
-	return 0;
+
+	if (sdev->last_queue_full_count <= 10)
+		return 0;
+	if (sdev->last_queue_full_depth < 8) {
+		/* Drop back to untagged */
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+		return -1;
+	}
+	
+	if (sdev->ordered_tags)
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
+	else
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
+	return depth;
 }
 
 
@@ -1307,7 +1250,7 @@
 	struct list_head *lh, *lh_sf;
 	unsigned long flags;
 
-	sdev->online = FALSE;
+	sdev->online = 0;
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
@@ -1317,9 +1260,8 @@
 			 * that the command has already timed out or
 			 * finished.
 			 */
-			if (!scsi_delete_timer(scmd)) {
+			if (!scsi_delete_timer(scmd))
 				continue;
-			}
 			list_add_tail(&scmd->eh_entry, &active_list);
 		}
 	}
@@ -1367,10 +1309,8 @@
 {
 	sdev->attached--;
 }
+
 /*
- * This entry point should be called by a loadable module if it is trying
- * add a high level scsi driver to the system.
- *
  * This entry point is called from the upper level module's module_init()
  * routine.  That implies that when this function is called, the
  * scsi_mod module is locked down because of upper module layering and
@@ -1385,7 +1325,7 @@
  */
 int scsi_register_device(struct Scsi_Device_Template *tpnt)
 {
-	Scsi_Device *SDpnt;
+	struct scsi_device *sdev;
 	struct Scsi_Host *shpnt;
 
 #ifdef CONFIG_KMOD
@@ -1404,15 +1344,15 @@
 
 	for (shpnt = scsi_host_get_next(NULL); shpnt;
 	     shpnt = scsi_host_get_next(shpnt)) 
-		list_for_each_entry (SDpnt, &shpnt->my_devices, siblings)
-			(*tpnt->attach) (SDpnt);
+		list_for_each_entry(sdev, &shpnt->my_devices, siblings)
+			(*tpnt->attach)(sdev);
 
 	return 0;
 }
 
 int scsi_unregister_device(struct Scsi_Device_Template *tpnt)
 {
-	Scsi_Device *SDpnt;
+	struct scsi_device *sdev;
 	struct Scsi_Host *shpnt;
 
 	/*
@@ -1420,8 +1360,8 @@
 	 */
 	for (shpnt = scsi_host_get_next(NULL); shpnt;
 	     shpnt = scsi_host_get_next(shpnt)) {
-		list_for_each_entry(SDpnt, &shpnt->my_devices, siblings)
-			(*tpnt->detach) (SDpnt);
+		list_for_each_entry(sdev, &shpnt->my_devices, siblings)
+			(*tpnt->detach)(sdev);
 	}
 
 	/*
@@ -1448,8 +1388,7 @@
 MODULE_LICENSE("GPL");
 
 #ifndef MODULE
-
-int __init setup_scsi_dev_flags(char *str)
+static int __init setup_scsi_dev_flags(char *str)
 {
 	scsi_dev_flags = str;
 	return 1;
@@ -1471,7 +1410,6 @@
 	}
 }
 __setup("scsi_default_dev_flags=", setup_scsi_default_dev_flags);
-
 #endif
 
 static int __init init_scsi(void)
