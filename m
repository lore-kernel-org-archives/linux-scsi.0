From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ConingStyle police for scsi_error.c
Date: Fri, 21 Feb 2003 23:51:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030221235136.B30977@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.36/drivers/scsi/scsi_error.c	Fri Feb 21 15:57:24 2003
+++ edited/drivers/scsi/scsi_error.c	Fri Feb 21 18:50:34 2003
@@ -15,33 +15,19 @@
  */
 
 #include <linux/module.h>
-
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/ioport.h>
 #include <linux/kernel.h>
-#include <linux/stat.h>
-#include <linux/blk.h>
 #include <linux/interrupt.h>
-#include <linux/delay.h>
+#include <linux/blkdev.h>
 #include <linux/smp_lock.h>
-#include <linux/completion.h>
-
-#define __KERNEL_SYSCALLS__
-
-#include <linux/unistd.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/dma.h>
+#include <scsi/scsi_ioctl.h>
 
 #include "scsi.h"
 #include "hosts.h"
 
-#include <scsi/scsi_ioctl.h> /* grr */
-
 #ifdef DEBUG
 #define SENSE_TIMEOUT SCSI_TIMEOUT
 #else
@@ -111,8 +97,8 @@
  *    simple, really, especially compared to the old way of handling this
  *    crap.
  **/
-void scsi_add_timer(Scsi_Cmnd *scmd, int timeout, void (*complete)
-		    (Scsi_Cmnd *))
+void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
+		    void (*complete)(struct scsi_cmnd *))
 {
 
 	/*
@@ -120,10 +106,10 @@
 	 * first delete the timer.  The timer handling code gets rather
 	 * confused if we don't do this.
 	 */
-	if (scmd->eh_timeout.function != NULL) {
+	if (scmd->eh_timeout.function)
 		del_timer(&scmd->eh_timeout);
-	}
-	scmd->eh_timeout.data = (unsigned long) scmd;
+
+	scmd->eh_timeout.data = (unsigned long)scmd;
 	scmd->eh_timeout.expires = jiffies + timeout;
 	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;
 
@@ -132,7 +118,6 @@
 					  scmd, timeout, complete));
 
 	add_timer(&scmd->eh_timeout);
-
 }
 
 /**
@@ -146,7 +131,7 @@
  *     1 if we were able to detach the timer.  0 if we blew it, and the
  *     timer function has already started to run.
  **/
-int scsi_delete_timer(Scsi_Cmnd *scmd)
+int scsi_delete_timer(struct scsi_cmnd *scmd)
 {
 	int rtn;
 
@@ -156,7 +141,7 @@
 					 " rtn: %d\n", __FUNCTION__,
 					 scmd, rtn));
 
-	scmd->eh_timeout.data = (unsigned long) NULL;
+	scmd->eh_timeout.data = (unsigned long)NULL;
 	scmd->eh_timeout.function = NULL;
 
 	return rtn;
@@ -172,7 +157,7 @@
  *     normal completion function determines that the timer has already
  *     fired, then it mustn't do anything.
  **/
-void scsi_times_out(Scsi_Cmnd *scmd)
+void scsi_times_out(struct scsi_cmnd *scmd)
 {
 	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		panic("Error handler thread not present at %p %p %s %d",
@@ -195,7 +180,7 @@
  * Return value:
  *     0 when dev was taken offline by error recovery. 1 OK to proceed.
  **/
-int scsi_block_when_processing_errors(Scsi_Device *sdev)
+int scsi_block_when_processing_errors(struct scsi_device *sdev)
 {
 	wait_event(sdev->host->host_wait, (sdev->host->in_recovery == 0));
 
@@ -260,11 +245,10 @@
  * Return value:
  * 	SUCCESS or FAILED or NEEDS_RETRY
  **/
-static int scsi_check_sense(Scsi_Cmnd *scmd)
+static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
-	if (!SCSI_SENSE_VALID(scmd)) {
+	if (!SCSI_SENSE_VALID(scmd))
 		return FAILED;
-	}
 	if (scmd->sense_buffer[2] & 0xe0)
 		return SUCCESS;
 
@@ -326,9 +310,8 @@
  *    don't allow for the possibility of retries here, and we are a lot
  *    more restrictive about what we consider acceptable.
  **/
-static int scsi_eh_completed_normally(Scsi_Cmnd *scmd)
+static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 {
-
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
@@ -353,15 +336,15 @@
 		 */
 		return scsi_check_sense(scmd);
 	}
-	if (host_byte(scmd->result) != DID_OK) {
+	if (host_byte(scmd->result) != DID_OK)
 		return FAILED;
-	}
+
 	/*
 	 * next, check the message byte.
 	 */
-	if (msg_byte(scmd->result) != COMMAND_COMPLETE) {
+	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
 		return FAILED;
-	}
+
 	/*
 	 * now, check the status byte to see if this indicates
 	 * anything special.
@@ -397,46 +380,38 @@
  *    for some action to complete on the device.  our only job is to
  *    record that it timed out, and to wake up the thread.
  **/
-static void scsi_eh_times_out(Scsi_Cmnd *scmd)
+static void scsi_eh_times_out(struct scsi_cmnd *scmd)
 {
 	scsi_eh_eflags_set(scmd, SCSI_EH_REC_TIMEOUT);
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd:%p\n", __FUNCTION__,
 					  scmd));
 
-	if (scmd->device->host->eh_action != NULL)
+	if (scmd->device->host->eh_action)
 		up(scmd->device->host->eh_action);
-	else
-		printk("%s: eh_action NULL\n", __FUNCTION__);
 }
 
 /**
  * scsi_eh_done - Completion function for error handling.
  * @scmd:	Cmd that is done.
  **/
-static void scsi_eh_done(Scsi_Cmnd *scmd)
+static void scsi_eh_done(struct scsi_cmnd *scmd)
 {
-	int     rtn;
-
 	/*
 	 * if the timeout handler is already running, then just set the
 	 * flag which says we finished late, and return.  we have no
 	 * way of stopping the timeout handler from running, so we must
 	 * always defer to it.
 	 */
-	rtn = del_timer(&scmd->eh_timeout);
-	if (!rtn) {
-		return;
-	}
+	if (del_timer(&scmd->eh_timeout)) {
+		scmd->request->rq_status = RQ_SCSI_DONE;
+		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
 
-	scmd->request->rq_status = RQ_SCSI_DONE;
-
-	scmd->owner = SCSI_OWNER_ERROR_HANDLER;
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
+					   __FUNCTION__, scmd, scmd->result));
 
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
-					  __FUNCTION__, scmd, scmd->result));
-
-	if (scmd->device->host->eh_action != NULL)
-		up(scmd->device->host->eh_action);
+		if (scmd->device->host->eh_action)
+			up(scmd->device->host->eh_action);
+	}
 }
 
 /**
@@ -451,10 +426,10 @@
  * Return value:
  *    SUCCESS or FAILED or NEEDS_RETRY
  **/
-static int scsi_send_eh_cmnd(Scsi_Cmnd *scmd, int timeout)
+static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, int timeout)
 {
-	unsigned long flags;
 	struct Scsi_Host *host = scmd->device->host;
+	unsigned long flags;
 	int rtn = SUCCESS;
 
 	ASSERT_LOCK(host->host_lock, 0);
@@ -567,32 +542,33 @@
  *    that we obtain it on our own. This function will *not* return until
  *    the command either times out, or it completes.
  **/
-static int scsi_request_sense(Scsi_Cmnd *scmd)
+static int scsi_request_sense(struct scsi_cmnd *scmd)
 {
 	static unsigned char generic_sense[6] =
 	{REQUEST_SENSE, 0, 0, 0, 255, 0};
-	unsigned char scsi_result0[256], *scsi_result = NULL;
+	unsigned char scsi_result0[256], *scsi_result = &scsi_result0[0];
 	int saved_result;
 	int rtn;
 
-	memcpy((void *) scmd->cmnd, (void *) generic_sense,
-	       sizeof(generic_sense));
-
-	scsi_result = (!scmd->device->host->hostt->unchecked_isa_dma)
-	    ? &scsi_result0[0] : kmalloc(512, GFP_ATOMIC | GFP_DMA);
+	memcpy(scmd->cmnd, generic_sense, sizeof(generic_sense));
 
-	if (scsi_result == NULL) {
-		printk("%s: cannot allocate scsi_result.\n", __FUNCTION__);
-		return FAILED;
+	if (scmd->device->host->hostt->unchecked_isa_dma) {
+		scsi_result = kmalloc(512, GFP_ATOMIC | __GFP_DMA);
+		if (unlikely(!scsi_result)) {
+			printk(KERN_ERR "%s: cannot allocate scsi_result.\n",
+					__FUNCTION__);
+			return FAILED;
+		}
 	}
+
 	/*
 	 * zero the sense buffer.  some host adapters automatically always
 	 * request sense, so it is not a good idea that
 	 * scmd->request_buffer and scmd->sense_buffer point to the same
 	 * address (db).  0 is not a valid sense code. 
 	 */
-	memset((void *) scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
-	memset((void *) scsi_result, 0, 256);
+	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
+	memset(scsi_result, 0, 256);
 
 	saved_result = scmd->result;
 	scmd->request_buffer = scsi_result;
@@ -605,12 +581,12 @@
 	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT);
 
 	/* last chance to have valid sense data */
-	if (!SCSI_SENSE_VALID(scmd))
-		memcpy((void *) scmd->sense_buffer,
-		       scmd->request_buffer,
-		       sizeof(scmd->sense_buffer));
+	if (!SCSI_SENSE_VALID(scmd)) {
+		memcpy(scmd->sense_buffer, scmd->request_buffer,
+				sizeof(scmd->sense_buffer));
+	}
 
-	if (scsi_result != &scsi_result0[0] && scsi_result != NULL)
+	if (scsi_result != &scsi_result0[0])
 		kfree(scsi_result);
 
 	/*
@@ -619,10 +595,6 @@
 	 */
 	scsi_setup_cmd_retry(scmd);
 	scmd->result = saved_result;
-
-	/*
-	 * hey, we are done.  let's look to see what happened.
-	 */
 	return rtn;
 }
 
@@ -634,7 +606,7 @@
  *    This function will *not* return until the command either times out,
  *    or it completes.
  **/
-static int scsi_eh_retry_cmd(Scsi_Cmnd *scmd)
+static int scsi_eh_retry_cmd(struct scsi_cmnd *scmd)
 {
 	int rtn = SUCCESS;
 
@@ -660,11 +632,12 @@
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
  **/
-static void scsi_eh_finish_cmd(Scsi_Cmnd *scmd,
-			       struct list_head *done_q )
+static void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
+			       struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
 	scmd->state = SCSI_STATE_BHQUEUE;
+
 	scsi_eh_eflags_clr_all(scmd);
 
 	/*
@@ -672,7 +645,6 @@
 	 * things.
 	 */
 	scsi_setup_cmd_retry(scmd);
-
 	list_move_tail(&scmd->eh_entry, done_q);
 }
 
@@ -685,7 +657,6 @@
  *    See if we need to request sense information.  if so, then get it
  *    now, so we have a better idea of what to do.  
  *
- *
  * Notes:
  *    This has the unfortunate side effect that if a shost adapter does
  *    not automatically request sense information, that we end up shutting
@@ -696,13 +667,15 @@
  *    this.
  *
  *    In 2.5 this capability will be going away.
+ *
+ *    Really?  --hch
  **/
 static int scsi_eh_get_sense(struct list_head *work_q,
 			     struct list_head *done_q)
 {
-	int rtn;
 	struct list_head *lh, *lh_sf;
-	Scsi_Cmnd *scmd;
+	struct scsi_cmnd *scmd;
+	int rtn;
 
 	list_for_each_safe(lh, lh_sf, work_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
@@ -766,14 +739,14 @@
  *    they can provide this facility themselves.  helper functions in
  *    scsi_error.c can be supplied to make this easier to do.
  **/
-static int scsi_try_to_abort_cmd(Scsi_Cmnd *scmd)
+static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	int rtn = FAILED;
 	unsigned long flags;
+	int rtn = FAILED;
 
-	if (scmd->device->host->hostt->eh_abort_handler == NULL) {
+	if (!scmd->device->host->hostt->eh_abort_handler)
 		return rtn;
-	}
+
 	/*
 	 * scsi_done was called just after the command timed out and before
 	 * we had a chance to process it. (db)
@@ -786,6 +759,7 @@
 	spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
 	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+
 	return rtn;
 }
 
@@ -796,22 +770,19 @@
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
  **/
-static int scsi_eh_tur(Scsi_Cmnd *scmd)
+static int scsi_eh_tur(struct scsi_cmnd *scmd)
 {
-	static unsigned char tur_command[6] =
-	{TEST_UNIT_READY, 0, 0, 0, 0, 0};
-	int rtn;
-	int retry_cnt = 1;
+	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
+	int retry_cnt = 1, rtn;
 
 retry_tur:
-	memcpy((void *) scmd->cmnd, (void *) tur_command,
-	       sizeof(tur_command));
+	memcpy(scmd->cmnd, tur_command, sizeof(tur_command));
 
 	/*
 	 * zero the sense buffer.  the scsi spec mandates that any
 	 * untransferred sense data should be interpreted as being zero.
 	 */
-	memset((void *) scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
+	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
 
 	scmd->request_buffer = NULL;
 	scmd->request_bufflen = 0;
@@ -856,9 +827,9 @@
 static int scsi_eh_abort_cmds(struct list_head *work_q,
 			      struct list_head *done_q)
 {
-	int rtn;
 	struct list_head *lh, *lh_sf;
 	struct scsi_cmnd *scmd;
+	int rtn;
 
 	list_for_each_safe(lh, lh_sf, work_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
@@ -895,14 +866,14 @@
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  **/
-static int scsi_try_bus_device_reset(Scsi_Cmnd *scmd)
+static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn = FAILED;
 
-	if (scmd->device->host->hostt->eh_device_reset_handler == NULL) {
+	if (!scmd->device->host->hostt->eh_device_reset_handler)
 		return rtn;
-	}
+
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
 	spin_lock_irqsave(scmd->device->host->host_lock, flags);
@@ -932,10 +903,10 @@
 				    struct list_head *work_q,
 				    struct list_head *done_q)
 {
-	int rtn;
 	struct list_head *lh, *lh_sf;
 	struct scsi_cmnd *scmd, *bdr_scmd;
 	struct scsi_device *sdev;
+	int rtn;
 
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
 		bdr_scmd = NULL;
@@ -980,18 +951,18 @@
  * scsi_try_bus_reset - ask host to perform a bus reset
  * @scmd:	SCSI cmd to send bus reset.
  **/
-static int scsi_try_bus_reset(Scsi_Cmnd *scmd)
+static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
+	struct scsi_device *sdev;
 	unsigned long flags;
 	int rtn;
-	Scsi_Device *sdev;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __FUNCTION__));
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 	scmd->serial_number_at_timeout = scmd->serial_number;
 
-	if (scmd->device->host->hostt->eh_bus_reset_handler == NULL)
+	if (!scmd->device->host->hostt->eh_bus_reset_handler)
 		return FAILED;
 
 	spin_lock_irqsave(scmd->device->host->host_lock, flags);
@@ -1017,18 +988,18 @@
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send hsot reset.
  **/
-static int scsi_try_host_reset(Scsi_Cmnd *scmd)
+static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
+	struct scsi_device *sdev;
 	unsigned long flags;
 	int rtn;
-	 Scsi_Device *sdev;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __FUNCTION__));
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 	scmd->serial_number_at_timeout = scmd->serial_number;
 
-	if (scmd->device->host->hostt->eh_host_reset_handler == NULL)
+	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
 
 	spin_lock_irqsave(scmd->device->host->host_lock, flags);
@@ -1059,11 +1030,11 @@
 			     struct list_head *work_q,
 			     struct list_head *done_q)
 {
-	int rtn;
 	struct list_head *lh, *lh_sf;
-	Scsi_Cmnd *scmd;
-	Scsi_Cmnd *chan_scmd;
+	struct scsi_cmnd *scmd;
+	struct scsi_cmnd *chan_scmd;
 	unsigned int channel;
+	int rtn;
 
 	/*
 	 * we really want to loop over the various channels, and do this on
@@ -1121,7 +1092,7 @@
 {
 	int rtn;
 	struct list_head *lh, *lh_sf;
-	Scsi_Cmnd *scmd;
+	struct scsi_cmnd *scmd;
 
 	if (!list_empty(work_q)) {
 		scmd = list_entry(work_q->next,
@@ -1156,7 +1127,7 @@
 				  struct list_head *done_q)
 {
 	struct list_head *lh, *lh_sf;
-	Scsi_Cmnd *scmd;
+	struct scsi_cmnd *scmd;
 
 	list_for_each_safe(lh, lh_sf, work_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
@@ -1183,12 +1154,12 @@
  * @sem:	semphore to signal
  *
  **/
-static
-void scsi_sleep_done(struct semaphore *sem)
+static void scsi_sleep_done(unsigned long data)
 {
-	if (sem != NULL) {
+	struct semaphore *sem = (struct semaphore *)data;
+
+	if (sem)
 		up(sem);
-	}
 }
 
 /**
@@ -1202,9 +1173,9 @@
 	struct timer_list timer;
 
 	init_timer(&timer);
-	timer.data = (unsigned long) &sem;
+	timer.data = (unsigned long)&sem;
 	timer.expires = jiffies + timeout;
-	timer.function = (void (*)(unsigned long)) scsi_sleep_done;
+	timer.function = (void (*)(unsigned long))scsi_sleep_done;
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("sleeping for timer tics %d\n",
 					  timeout));
@@ -1229,7 +1200,7 @@
  *    doesn't require the error handler read (i.e. we don't need to
  *    abort/reset), then this function should return SUCCESS.
  **/
-int scsi_decide_disposition(Scsi_Cmnd *scmd)
+int scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
 	int rtn;
 
@@ -1429,7 +1400,7 @@
 {
 	struct scsi_request *sreq = scsi_allocate_request(sdev);
 
-	if (sreq == NULL) {
+	if (unlikely(!sreq)) {
 		printk(KERN_ERR "%s: request allocate failed,"
 		       "prevent media removal cmd not sent", __FUNCTION__);
 		return;
@@ -1463,7 +1434,7 @@
  **/
 static void scsi_restart_operations(struct Scsi_Host *shost)
 {
-	Scsi_Device *sdev;
+	struct scsi_device *sdev;
 	unsigned long flags;
 
 	ASSERT_LOCK(shost->host_lock, 0);
@@ -1533,7 +1504,7 @@
 static void scsi_eh_flush_done_q(struct list_head *done_q)
 {
 	struct list_head *lh, *lh_sf;
-	Scsi_Cmnd *scmd;
+	struct scsi_cmnd *scmd;
 
 	list_for_each_safe(lh, lh_sf, done_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
@@ -1674,11 +1645,10 @@
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (shost->hostt->eh_strategy_handler != NULL) {
+		if (shost->hostt->eh_strategy_handler) 
 			rtn = shost->hostt->eh_strategy_handler(shost);
-		} else {
+		else
 			scsi_unjam_host(shost);
-		}
 
 		shost->eh_active = 0;
 
@@ -1719,45 +1689,8 @@
 	complete_and_exit(shost->eh_notify, 0);
 }
 
-/**
- * scsi_new_reset - Send reset to a bus or device at any phase.
- * @scmd:	Cmd to send reset with (usually a dummy)
- * @flag:	Reset type.
- *
- * Description:
- *    This is used by the SCSI Generic driver to provide Bus/Device reset
- *    capability.
- *
- * Return value:
- *    SUCCESS/FAILED.
- **/
-static int scsi_new_reset(Scsi_Cmnd *scmd, int flag)
-{
-	int rtn;
-
-	switch(flag) {
-	case SCSI_TRY_RESET_DEVICE:
-		rtn = scsi_try_bus_device_reset(scmd);
-		if (rtn == SUCCESS)
-			break;
-		/* FALLTHROUGH */
-	case SCSI_TRY_RESET_BUS:
-		rtn = scsi_try_bus_reset(scmd);
-		if (rtn == SUCCESS)
-			break;
-		/* FALLTHROUGH */
-	case SCSI_TRY_RESET_HOST:
-		rtn = scsi_try_host_reset(scmd);
-		break;
-	default:
-		rtn = FAILED;
-	}
-
-	return rtn;
-}
-
 static void
-scsi_reset_provider_done_command(Scsi_Cmnd *SCpnt)
+scsi_reset_provider_done_command(struct scsi_cmnd *scmd)
 {
 }
 
@@ -1775,47 +1708,63 @@
  *		Bus/Device reset capability.
  */
 int
-scsi_reset_provider(Scsi_Device *dev, int flag)
+scsi_reset_provider(struct scsi_device *dev, int flag)
 {
-	struct scsi_cmnd *SCpnt = scsi_get_command(dev, GFP_KERNEL);
+	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
 	struct request req;
 	int rtn;
 
-	SCpnt->request = &req;
-	memset(&SCpnt->eh_timeout, 0, sizeof(SCpnt->eh_timeout));
-	SCpnt->request->rq_status      	= RQ_SCSI_BUSY;
-	SCpnt->state                   	= SCSI_STATE_INITIALIZING;
-	SCpnt->owner	     		= SCSI_OWNER_MIDLEVEL;
+	scmd->request = &req;
+	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
+	scmd->request->rq_status      	= RQ_SCSI_BUSY;
+	scmd->state                   	= SCSI_STATE_INITIALIZING;
+	scmd->owner	     		= SCSI_OWNER_MIDLEVEL;
     
-	memset(&SCpnt->cmnd, '\0', sizeof(SCpnt->cmnd));
+	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
-	SCpnt->scsi_done		= scsi_reset_provider_done_command;
-	SCpnt->done			= NULL;
-	SCpnt->reset_chain		= NULL;
+	scmd->scsi_done		= scsi_reset_provider_done_command;
+	scmd->done			= NULL;
+	scmd->reset_chain		= NULL;
         
-	SCpnt->buffer			= NULL;
-	SCpnt->bufflen			= 0;
-	SCpnt->request_buffer		= NULL;
-	SCpnt->request_bufflen		= 0;
-
-	SCpnt->internal_timeout		= NORMAL_TIMEOUT;
-	SCpnt->abort_reason		= DID_ABORT;
-
-	SCpnt->cmd_len			= 0;
-
-	SCpnt->sc_data_direction	= SCSI_DATA_UNKNOWN;
-	SCpnt->sc_request		= NULL;
-	SCpnt->sc_magic			= SCSI_CMND_MAGIC;
+	scmd->buffer			= NULL;
+	scmd->bufflen			= 0;
+	scmd->request_buffer		= NULL;
+	scmd->request_bufflen		= 0;
+
+	scmd->internal_timeout		= NORMAL_TIMEOUT;
+	scmd->abort_reason		= DID_ABORT;
+
+	scmd->cmd_len			= 0;
+
+	scmd->sc_data_direction	= SCSI_DATA_UNKNOWN;
+	scmd->sc_request		= NULL;
+	scmd->sc_magic			= SCSI_CMND_MAGIC;
 
 	/*
 	 * Sometimes the command can get back into the timer chain,
 	 * so use the pid as an identifier.
 	 */
-	SCpnt->pid			= 0;
+	scmd->pid			= 0;
 
-	rtn = scsi_new_reset(SCpnt, flag);
+	switch (flag) {
+	case SCSI_TRY_RESET_DEVICE:
+		rtn = scsi_try_bus_device_reset(scmd);
+		if (rtn == SUCCESS)
+			break;
+		/* FALLTHROUGH */
+	case SCSI_TRY_RESET_BUS:
+		rtn = scsi_try_bus_reset(scmd);
+		if (rtn == SUCCESS)
+			break;
+		/* FALLTHROUGH */
+	case SCSI_TRY_RESET_HOST:
+		rtn = scsi_try_host_reset(scmd);
+		break;
+	default:
+		rtn = FAILED;
+	}
 
-	scsi_delete_timer(SCpnt);
-	scsi_put_command(SCpnt);
+	scsi_delete_timer(scmd);
+	scsi_put_command(scmd);
 	return rtn;
 }
