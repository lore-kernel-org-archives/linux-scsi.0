From: malahal@us.ibm.com
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Tue, 9 Oct 2007 07:26:51 -0700
Message-ID: <20071009142651.GA19808@us.ibm.com>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com> <20071009091451.GD5241@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34033 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbXJIO1S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2007 10:27:18 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l99ERHkE001035
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 10:27:17 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l99ERESg081806
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 10:27:17 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l99ER4EJ015096
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 10:27:04 -0400
Content-Disposition: inline
In-Reply-To: <20071009091451.GD5241@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

Here is another attempt! Thank you.


diff -r 1b51503899a0 block/ll_rw_blk.c
--- a/block/ll_rw_blk.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/block/ll_rw_blk.c	Tue Oct 09 07:00:51 2007 -0700
@@ -181,6 +181,18 @@ void blk_queue_softirq_done(struct reque
 
 EXPORT_SYMBOL(blk_queue_softirq_done);
 
+void blk_queue_rq_timeout(struct request_queue *q, unsigned int timeout)
+{
+	q->rq_timeout = timeout;
+}
+EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);
+
+void blk_queue_rq_timed_out(struct request_queue *q, rq_timed_out_fn *fn)
+{
+	q->rq_timed_out_fn = fn;
+}
+EXPORT_SYMBOL_GPL(blk_queue_rq_timed_out);
+
 /**
  * blk_queue_make_request - define an alternate make_request function for a device
  * @q:  the request queue for the device to be affected
@@ -243,7 +255,9 @@ static void rq_init(struct request_queue
 {
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
-
+	init_timer(&rq->timer);
+
+	rq->timeout = 0;
 	rq->errors = 0;
 	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
@@ -2305,6 +2319,7 @@ EXPORT_SYMBOL(blk_start_queueing);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
+	blk_delete_timer(rq);
 	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
 
 	if (blk_rq_tagged(rq))
@@ -3647,8 +3662,109 @@ static struct notifier_block blk_cpu_not
 };
 
 /**
+ * blk_delete_timer - Delete/cancel timer for a given function.
+ * @req:	request that we are canceling timer for
+ *
+ * Return value:
+ *     1 if we were able to detach the timer.  0 if we blew it, and the
+ *     timer function has already started to run.
+ */
+int blk_delete_timer(struct request *req)
+{
+	if (!req->q->rq_timed_out_fn)
+		return 1;
+
+	return del_timer(&req->timer);
+}
+EXPORT_SYMBOL_GPL(blk_delete_timer);
+
+static void blk_rq_timed_out(struct request *req)
+{
+	struct request_queue *q = req->q;
+
+	switch (q->rq_timed_out_fn(req)) {
+	case BLK_EH_HANDLED:
+		__blk_complete_request(req);
+		return;
+	case BLK_EH_RESET_TIMER:
+		blk_add_timer(req);
+		return;
+	case BLK_EH_NOT_HANDLED:
+		/*
+		 * LLD handles this for now but in the future
+		 * we can send a request msg to abort the command
+		 * and we can move more of the generic scsi eh code to
+		 * the blk layer.
+		 */
+		return;
+	}
+}
+
+static void blk_rq_timed_out_timer(unsigned long data)
+{
+	struct request *req = (struct request *)data;
+
+	blk_rq_timed_out(req);
+}
+
+/**
+ * blk_abort_req -- Request request recovery for the specified command
+ * @req:	pointer to the request of interest
+ *
+ * This function requests that the block layer start recovery for the
+ * request by deleting the timer and calling the q's timeout function.
+ * LLDDs who implement their own error recovery MAY ignore the timeout
+ * event if they generated blk_abort_req.
+ */
+void blk_abort_req(struct request *req)
+{
+        if (!blk_delete_timer(req))
+                return;
+        blk_rq_timed_out(req);
+}
+EXPORT_SYMBOL_GPL(blk_abort_req);
+
+/**
+ * blk_add_timer - Start timeout timer for a single request
+ * @req:	request that is about to start running.
+ *
+ * Notes:
+ *    Each request has its own timer, and as it is added to the queue, we
+ *    set up the timer.  When the request completes, we cancel the timer.
+ */
+void blk_add_timer(struct request *req)
+{
+	struct request_queue *q = req->q;
+
+	req->timer.data = (unsigned long)req;
+	if (req->timeout)
+		req->timer.expires = jiffies + req->timeout;
+	else
+		req->timer.expires = jiffies + q->rq_timeout;
+	req->timer.function = blk_rq_timed_out_timer;
+	add_timer(&req->timer);
+}
+EXPORT_SYMBOL_GPL(blk_add_timer);
+
+void __blk_complete_request(struct request *req)
+{
+	struct list_head *cpu_list;
+	unsigned long flags;
+
+	BUG_ON(!req->q->softirq_done_fn);
+
+	local_irq_save(flags);
+
+	cpu_list = &__get_cpu_var(blk_cpu_done);
+	list_add_tail(&req->donelist, cpu_list);
+	raise_softirq_irqoff(BLOCK_SOFTIRQ);
+
+	local_irq_restore(flags);
+}
+
+/**
  * blk_complete_request - end I/O on a request
- * @req:      the request being processed
+ * @req:	the request being processed
  *
  * Description:
  *     Ends all I/O on a request. It does not handle partial completions,
@@ -3656,26 +3772,24 @@ static struct notifier_block blk_cpu_not
  *     through requeueing. The actual completion happens out-of-order,
  *     through a softirq handler. The user must have registered a completion
  *     callback through blk_queue_softirq_done().
- **/
-
+ */
 void blk_complete_request(struct request *req)
 {
-	struct list_head *cpu_list;
-	unsigned long flags;
-
-	BUG_ON(!req->q->softirq_done_fn);
-		
-	local_irq_save(flags);
-
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_add_tail(&req->donelist, cpu_list);
-	raise_softirq_irqoff(BLOCK_SOFTIRQ);
-
-	local_irq_restore(flags);
-}
-
+	/*
+	 * We don't have to worry about this one timing out any more.
+	 * If we are unable to remove the timer, then the command
+	 * has already timed out.  In which case, we have no choice but to
+	 * let the timeout function run, as we have no idea where in fact
+	 * that function could really be.  It might be on another processor,
+	 * etc, etc.
+	 */
+	if (!blk_delete_timer(req))
+		return;
+
+	__blk_complete_request(req);
+}
 EXPORT_SYMBOL(blk_complete_request);
-	
+
 /*
  * queue lock must be held
  */
diff -r 1b51503899a0 drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/ata/libata-eh.c	Mon Oct 08 21:57:34 2007 -0700
@@ -33,6 +33,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_eh.h>
@@ -312,29 +313,29 @@ static void ata_eh_clear_action(struct a
  *	RETURNS:
  *	EH_HANDLED or EH_NOT_HANDLED
  */
-enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd)
+enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct ata_port *ap = ata_shost_to_port(host);
 	unsigned long flags;
 	struct ata_queued_cmd *qc;
-	enum scsi_eh_timer_return ret;
+	enum blk_eh_timer_return ret;
 
 	DPRINTK("ENTER\n");
 
 	if (ap->ops->error_handler) {
-		ret = EH_NOT_HANDLED;
+		ret = BLK_EH_NOT_HANDLED;
 		goto out;
 	}
 
-	ret = EH_HANDLED;
+	ret = BLK_EH_HANDLED;
 	spin_lock_irqsave(ap->lock, flags);
 	qc = ata_qc_from_tag(ap, ap->link.active_tag);
 	if (qc) {
 		WARN_ON(qc->scsicmd != cmd);
 		qc->flags |= ATA_QCFLAG_EH_SCHEDULED;
 		qc->err_mask |= AC_ERR_TIMEOUT;
-		ret = EH_NOT_HANDLED;
+		ret = BLK_EH_NOT_HANDLED;
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
 
@@ -765,7 +766,7 @@ void ata_qc_schedule_eh(struct ata_queue
 	 * Note that ATA_QCFLAG_FAILED is unconditionally set after
 	 * this function completes.
 	 */
-	scsi_req_abort_cmd(qc->scsicmd);
+	blk_abort_req(qc->scsicmd->request);
 }
 
 /**
diff -r 1b51503899a0 drivers/ata/libata.h
--- a/drivers/ata/libata.h	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/ata/libata.h	Mon Oct 08 21:57:34 2007 -0700
@@ -149,7 +149,7 @@ extern int ata_bus_probe(struct ata_port
 extern int ata_bus_probe(struct ata_port *ap);
 
 /* libata-eh.c */
-extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
+extern enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern void ata_scsi_error(struct Scsi_Host *host);
 extern void ata_port_wait_eh(struct ata_port *ap);
 extern void ata_eh_fastdrain_timerfn(unsigned long arg);
diff -r 1b51503899a0 drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/aacraid/aachba.c	Mon Oct 08 21:57:34 2007 -0700
@@ -1125,7 +1125,7 @@ static struct aac_srb * aac_scsi_common(
 	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
 	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
-	timeout = cmd->timeout_per_command/HZ;
+	timeout = cmd->request->timeout/HZ;
 	if (timeout == 0)
 		timeout = 1;
 	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
diff -r 1b51503899a0 drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/advansys.c	Mon Oct 08 21:57:34 2007 -0700
@@ -5859,7 +5859,7 @@ static void asc_prt_scsi_cmnd(struct scs
 	printk(" serial_number 0x%x, retries %d, allowed %d\n",
 	       (unsigned)s->serial_number, s->retries, s->allowed);
 
-	printk(" timeout_per_command %d\n", s->timeout_per_command);
+	printk(" request timeout %d\n", s->request->timeout);
 
 	printk(" scsi_done 0x%p, done 0x%p, host_scribble 0x%p, result 0x%x\n",
 		s->scsi_done, s->done, s->host_scribble, s->result);
diff -r 1b51503899a0 drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/gdth.c	Mon Oct 08 21:57:34 2007 -0700
@@ -728,7 +728,6 @@ int __gdth_execute(struct scsi_device *s
     scp->device = sdev;
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
-    scp->timeout_per_command = timeout*HZ;
     scp->request_buffer = gdtcmd;
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
@@ -4944,7 +4943,7 @@ static int gdth_queuecommand(Scsi_Cmnd *
     if (scp->done == gdth_scsi_done)
         priority = scp->SCp.this_residual;
     else
-        gdth_update_timeout(hanum, scp, scp->timeout_per_command * 6);
+        gdth_update_timeout(hanum, scp, scp->request->timeout* 6);
 
     gdth_putq( hanum, scp, priority );
     gdth_next( hanum );
diff -r 1b51503899a0 drivers/scsi/gdth_proc.c
--- a/drivers/scsi/gdth_proc.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/gdth_proc.c	Mon Oct 08 21:57:34 2007 -0700
@@ -846,19 +846,19 @@ static int gdth_update_timeout(int hanum
 {
     int oldto;
 
-    oldto = scp->timeout_per_command;
-    scp->timeout_per_command = timeout;
+    oldto = scp->request->timeout;
+    scp->request->timeout = timeout;
 
     if (timeout == 0) {
-        del_timer(&scp->eh_timeout);
-        scp->eh_timeout.data = (unsigned long) NULL;
-        scp->eh_timeout.expires = 0;
+        del_timer(&scp->request->timer);
+        scp->request->timer.data = (unsigned long) NULL;
+        scp->request->timer.expires = 0;
     } else {
-        if (scp->eh_timeout.data != (unsigned long) NULL) 
-            del_timer(&scp->eh_timeout);
-        scp->eh_timeout.data = (unsigned long) scp;
-        scp->eh_timeout.expires = jiffies + timeout;
-        add_timer(&scp->eh_timeout);
+        if (scp->request->timer.data != (unsigned long) NULL) 
+            del_timer(&scp->request->timer);
+        scp->request->timer.data = (unsigned long) scp;
+        scp->request->timer.expires = jiffies + timeout;
+        add_timer(&scp->request->timer);
     }
 
     return oldto;
diff -r 1b51503899a0 drivers/scsi/ibmvscsi/ibmvscsi.c
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c	Mon Oct 08 21:57:34 2007 -0700
@@ -732,7 +732,7 @@ static int ibmvscsi_queuecommand(struct 
 	init_event_struct(evt_struct,
 			  handle_cmd_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  cmnd->timeout_per_command/HZ);
+			  cmnd->request->timeout/HZ);
 
 	evt_struct->cmnd = cmnd;
 	evt_struct->cmnd_done = done;
diff -r 1b51503899a0 drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/ide-scsi.c	Mon Oct 08 21:57:34 2007 -0700
@@ -812,7 +812,7 @@ static int idescsi_queue (struct scsi_cm
 	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;
 	pc->done = done;
-	pc->timeout = jiffies + cmd->timeout_per_command;
+	pc->timeout = jiffies + cmd->request->timeout;
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
diff -r 1b51503899a0 drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/ipr.c	Mon Oct 08 21:57:34 2007 -0700
@@ -3654,7 +3654,8 @@ static int ipr_slave_configure(struct sc
 			sdev->no_uld_attach = 1;
 		}
 		if (ipr_is_vset_device(res)) {
-			sdev->timeout = IPR_VSET_RW_TIMEOUT;
+			blk_queue_rq_timeout(sdev->request_queue,
+					     IPR_VSET_RW_TIMEOUT);
 			blk_queue_max_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
 		}
 		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
diff -r 1b51503899a0 drivers/scsi/ips.c
--- a/drivers/scsi/ips.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/ips.c	Mon Oct 08 21:57:34 2007 -0700
@@ -3862,7 +3862,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * 
 		scb->cmd.dcdb.segment_4G = 0;
 		scb->cmd.dcdb.enhanced_sg = 0;
 
-		TimeOut = scb->scsi_cmd->timeout_per_command;
+		TimeOut = scb->scsi_cmd->request->timeout;
 
 		if (ha->subsys->param[4] & 0x00100000) {	/* If NEW Tape DCDB is Supported */
 			if (!scb->sg_len) {
diff -r 1b51503899a0 drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/libsas/sas_ata.c	Mon Oct 08 21:57:34 2007 -0700
@@ -407,7 +407,7 @@ void sas_ata_task_abort(struct sas_task 
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
-		scsi_req_abort_cmd(qc->scsicmd);
+		blk_abort_req(qc->scsicmd->request);
 		scsi_schedule_eh(qc->scsicmd->device->host);
 		return;
 	}
diff -r 1b51503899a0 drivers/scsi/libsas/sas_internal.h
--- a/drivers/scsi/libsas/sas_internal.h	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/libsas/sas_internal.h	Mon Oct 08 21:57:34 2007 -0700
@@ -55,7 +55,7 @@ int  sas_register_ports(struct sas_ha_st
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
 void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
-enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *);
+enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *);
 
 int  sas_init_queue(struct sas_ha_struct *sas_ha);
 int  sas_init_events(struct sas_ha_struct *sas_ha);
diff -r 1b51503899a0 drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/libsas/sas_scsi_host.c	Mon Oct 08 21:57:34 2007 -0700
@@ -654,43 +654,43 @@ out:
 	return;
 }
 
-enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
+enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
 {
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	unsigned long flags;
 
 	if (!task) {
-		cmd->timeout_per_command /= 2;
+		cmd->request->timeout /= 2;
 		SAS_DPRINTK("command 0x%p, task 0x%p, gone: %s\n",
-			    cmd, task, (cmd->timeout_per_command ?
-			    "EH_RESET_TIMER" : "EH_NOT_HANDLED"));
-		if (!cmd->timeout_per_command)
-			return EH_NOT_HANDLED;
-		return EH_RESET_TIMER;
+			    cmd, task, (cmd->request->timeout ?
+			    "BLK_EH_RESET_TIMER" : "BLK_EH_NOT_HANDLED"));
+		if (!cmd->request->timeout)
+			return BLK_EH_NOT_HANDLED;
+		return BLK_EH_RESET_TIMER;
 	}
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	BUG_ON(task->task_state_flags & SAS_TASK_STATE_ABORTED);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		SAS_DPRINTK("command 0x%p, task 0x%p, timed out: EH_HANDLED\n",
-			    cmd, task);
-		return EH_HANDLED;
+		SAS_DPRINTK("command 0x%p, task 0x%p, timed out: "
+			    "BLK_EH_HANDLED\n", cmd, task);
+		return BLK_EH_HANDLED;
 	}
 	if (!(task->task_state_flags & SAS_TASK_AT_INITIATOR)) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		SAS_DPRINTK("command 0x%p, task 0x%p, not at initiator: "
-			    "EH_RESET_TIMER\n",
+			    "BLK_EH_RESET_TIMER\n",
 			    cmd, task);
-		return EH_RESET_TIMER;
+		return BLK_EH_RESET_TIMER;
 	}
 	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	SAS_DPRINTK("command 0x%p, task 0x%p, timed out: EH_NOT_HANDLED\n",
+	SAS_DPRINTK("command 0x%p, task 0x%p, timed out: BLK_EH_NOT_HANDLED\n",
 		    cmd, task);
 
-	return EH_NOT_HANDLED;
+	return BLK_EH_NOT_HANDLED;
 }
 
 int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
@@ -1020,7 +1020,7 @@ void sas_task_abort(struct sas_task *tas
 		return;
 	}
 
-	scsi_req_abort_cmd(sc);
+	blk_abort_req(sc->request);
 	scsi_schedule_eh(sc->device->host);
 }
 
diff -r 1b51503899a0 drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/megaraid/megaraid_sas.c	Mon Oct 08 21:57:34 2007 -0700
@@ -969,7 +969,7 @@ static int megasas_generic_reset(struct 
  * cmd has not been completed within the timeout period.
  */
 static enum
-scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
+blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 {
 	struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
 	struct megasas_instance *instance;
@@ -977,7 +977,7 @@ scsi_eh_timer_return megasas_reset_timer
 
 	if (time_after(jiffies, scmd->jiffies_at_alloc +
 				(MEGASAS_DEFAULT_CMD_TIMEOUT * 2) * HZ)) {
-		return EH_NOT_HANDLED;
+		return BLK_EH_NOT_HANDLED;
 	}
 
 	instance = cmd->instance;
@@ -991,7 +991,7 @@ scsi_eh_timer_return megasas_reset_timer
 
 		spin_unlock_irqrestore(instance->host->host_lock, flags);
 	}
-	return EH_RESET_TIMER;
+	return BLK_EH_RESET_TIMER;
 }
 
 /**
diff -r 1b51503899a0 drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/ncr53c8xx.c	Mon Oct 08 21:57:34 2007 -0700
@@ -4170,8 +4170,8 @@ static int ncr_queue_command (struct ncb
 	**
 	**----------------------------------------------------
 	*/
-	if (np->settle_time && cmd->timeout_per_command >= HZ) {
-		u_long tlimit = jiffies + cmd->timeout_per_command - HZ;
+	if (np->settle_time && cmd->request->timeout >= HZ) {
+		u_long tlimit = jiffies + cmd->request->timeout - HZ;
 		if (time_after(np->settle_time, tlimit))
 			np->settle_time = tlimit;
 	}
diff -r 1b51503899a0 drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/qla1280.c	Mon Oct 08 21:57:34 2007 -0700
@@ -2862,7 +2862,7 @@ qla1280_64bit_start_scsi(struct scsi_qla
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->timeout_per_command/HZ);
+	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
@@ -3167,7 +3167,7 @@ qla1280_32bit_start_scsi(struct scsi_qla
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->timeout_per_command/HZ);
+	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
diff -r 1b51503899a0 drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/qla4xxx/ql4_os.c	Mon Oct 08 21:57:34 2007 -0700
@@ -1565,7 +1565,7 @@ static int qla4xxx_eh_device_reset(struc
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
 		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
-		      cmd, jiffies, cmd->timeout_per_command / HZ,
+		      cmd, jiffies, cmd->request->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
 	/* FIXME: wait for hba to go online */
diff -r 1b51503899a0 drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/scsi.c	Mon Oct 08 21:57:34 2007 -0700
@@ -203,7 +203,6 @@ struct scsi_cmnd *scsi_get_command(struc
 
 		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
-		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
 		spin_lock_irqsave(&dev->list_lock, flags);
 		list_add_tail(&cmd->list, &dev->cmd_list);
@@ -472,14 +471,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	unsigned long timeout;
 	int rtn = 0;
 
+	/*
+	 * We will use a queued command if possible, otherwise we will
+	 * emulate the queuing and calling of completion function ourselves.
+	 */
+	atomic_inc(&cmd->device->iorequest_cnt);
+
 	/* check if the device is still usable */
 	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
 		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
 		cmd->result = DID_NO_CONNECT << 16;
-		atomic_inc(&cmd->device->iorequest_cnt);
-		__scsi_done(cmd);
+		scsi_done(cmd);
 		/* return 0 (because the command has been processed) */
 		goto out;
 	}
@@ -492,7 +496,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		 * future requests should not occur until the device 
 		 * transitions out of the suspend state.
 		 */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+
+		scsi_queue_retry(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
 		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
 
@@ -534,19 +539,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		host->resetting = 0;
 	}
 
-	/* 
-	 * AK: unlikely race here: for some reason the timer could
-	 * expire before the serial number is set up below.
-	 */
-	scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
-
 	scsi_log_send(cmd);
-
-	/*
-	 * We will use a queued command if possible, otherwise we will
-	 * emulate the queuing and calling of completion function ourselves.
-	 */
-	atomic_inc(&cmd->device->iorequest_cnt);
 
 	/*
 	 * Before we queue this command, check if the command
@@ -562,6 +555,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	}
 
 	spin_lock_irqsave(host->host_lock, flags);
+	/* 
+	 * AK: unlikely race here: for some reason the timer could
+	 * expire before the serial number is set up below.
+	 *
+	 * TODO: kill serial or move to blk layer
+	 */
 	scsi_cmd_get_serial(host, cmd); 
 
 	if (unlikely(host->shost_state == SHOST_DEL)) {
@@ -572,12 +571,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
-		if (scsi_delete_timer(cmd)) {
-			atomic_inc(&cmd->device->iodone_cnt);
-			scsi_queue_insert(cmd,
-					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
-					  rtn : SCSI_MLQUEUE_HOST_BUSY);
-		}
+		scsi_queue_retry(cmd, (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
+						rtn : SCSI_MLQUEUE_HOST_BUSY);
 		SCSI_LOG_MLQUEUE(3,
 		    printk("queuecommand : request rejected\n"));
 	}
@@ -586,24 +581,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	SCSI_LOG_MLQUEUE(3, printk("leaving scsi_dispatch_cmnd()\n"));
 	return rtn;
 }
-
-/**
- * scsi_req_abort_cmd -- Request command recovery for the specified command
- * cmd: pointer to the SCSI command of interest
- *
- * This function requests that SCSI Core start recovery for the
- * command by deleting the timer and adding the command to the eh
- * queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
- * implement their own error recovery MAY ignore the timeout event if
- * they generated scsi_req_abort_cmd.
- */
-void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
-{
-	if (!scsi_delete_timer(cmd))
-		return;
-	scsi_times_out(cmd);
-}
-EXPORT_SYMBOL(scsi_req_abort_cmd);
 
 /**
  * scsi_done - Enqueue the finished SCSI command into the done queue.
@@ -620,42 +597,7 @@ EXPORT_SYMBOL(scsi_req_abort_cmd);
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
-	/*
-	 * We don't have to worry about this one timing out any more.
-	 * If we are unable to remove the timer, then the command
-	 * has already timed out.  In which case, we have no choice but to
-	 * let the timeout function run, as we have no idea where in fact
-	 * that function could really be.  It might be on another processor,
-	 * etc, etc.
-	 */
-	if (!scsi_delete_timer(cmd))
-		return;
-	__scsi_done(cmd);
-}
-
-/* Private entry to scsi_done() to complete a command when the timer
- * isn't running --- used by scsi_times_out */
-void __scsi_done(struct scsi_cmnd *cmd)
-{
-	struct request *rq = cmd->request;
-
-	/*
-	 * Set the serial numbers back to zero
-	 */
-	cmd->serial_number = 0;
-
-	atomic_inc(&cmd->device->iodone_cnt);
-	if (cmd->result)
-		atomic_inc(&cmd->device->ioerr_cnt);
-
-	BUG_ON(!rq);
-
-	/*
-	 * The uptodate/nbytes values don't matter, as we allow partial
-	 * completes and thus will check this in the softirq callback
-	 */
-	rq->completion_data = cmd;
-	blk_complete_request(rq);
+	blk_complete_request(cmd->request);
 }
 
 /*
diff -r 1b51503899a0 drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/scsi_error.c	Mon Oct 08 21:57:34 2007 -0700
@@ -113,69 +113,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 }
 
 /**
- * scsi_add_timer - Start timeout timer for a single scsi command.
- * @scmd:	scsi command that is about to start running.
- * @timeout:	amount of time to allow this command to run.
- * @complete:	timeout function to call if timer isn't canceled.
- *
- * Notes:
- *    This should be turned into an inline function.  Each scsi command
- *    has its own timer, and as it is added to the queue, we set up the
- *    timer.  When the command completes, we cancel the timer.
- **/
-void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
-		    void (*complete)(struct scsi_cmnd *))
-{
-
-	/*
-	 * If the clock was already running for this command, then
-	 * first delete the timer.  The timer handling code gets rather
-	 * confused if we don't do this.
-	 */
-	if (scmd->eh_timeout.function)
-		del_timer(&scmd->eh_timeout);
-
-	scmd->eh_timeout.data = (unsigned long)scmd;
-	scmd->eh_timeout.expires = jiffies + timeout;
-	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;
-
-	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p, time:"
-					  " %d, (%p)\n", __FUNCTION__,
-					  scmd, timeout, complete));
-
-	add_timer(&scmd->eh_timeout);
-}
-
-/**
- * scsi_delete_timer - Delete/cancel timer for a given function.
- * @scmd:	Cmd that we are canceling timer for
- *
- * Notes:
- *     This should be turned into an inline function.
- *
- * Return value:
- *     1 if we were able to detach the timer.  0 if we blew it, and the
- *     timer function has already started to run.
- **/
-int scsi_delete_timer(struct scsi_cmnd *scmd)
-{
-	int rtn;
-
-	rtn = del_timer(&scmd->eh_timeout);
-
-	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p,"
-					 " rtn: %d\n", __FUNCTION__,
-					 scmd, rtn));
-
-	scmd->eh_timeout.data = (unsigned long)NULL;
-	scmd->eh_timeout.function = NULL;
-
-	return rtn;
-}
-
-/**
  * scsi_times_out - Timeout function for normal scsi commands.
- * @scmd:	Cmd that is timing out.
+ * @req:	request that is timing out.
  *
  * Notes:
  *     We do not need to lock this.  There is the potential for a race
@@ -183,9 +122,11 @@ int scsi_delete_timer(struct scsi_cmnd *
  *     normal completion function determines that the timer has already
  *     fired, then it mustn't do anything.
  **/
-void scsi_times_out(struct scsi_cmnd *scmd)
-{
-	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+enum blk_eh_timer_return scsi_times_out(struct request *req)
+{
+	struct scsi_cmnd *scmd = req->special;
+	enum blk_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
@@ -197,22 +138,20 @@ void scsi_times_out(struct scsi_cmnd *sc
 		eh_timed_out = NULL;
 
 	if (eh_timed_out)
-		switch (eh_timed_out(scmd)) {
-		case EH_HANDLED:
-			__scsi_done(scmd);
-			return;
-		case EH_RESET_TIMER:
-			scsi_add_timer(scmd, scmd->timeout_per_command,
-				       scsi_times_out);
-			return;
-		case EH_NOT_HANDLED:
+		rtn = eh_timed_out(scmd);
+		switch (rtn) {
+		case BLK_EH_NOT_HANDLED:
 			break;
+		default:
+			return rtn;
 		}
 
 	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		scmd->result |= DID_TIME_OUT << 16;
-		__scsi_done(scmd);
-	}
+		return BLK_EH_HANDLED;
+	}
+
+	return BLK_EH_NOT_HANDLED;
 }
 
 /**
@@ -1666,7 +1605,6 @@ scsi_reset_provider(struct scsi_device *
 	int rtn;
 
 	scmd->request = &req;
-	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
@@ -1678,8 +1616,6 @@ scsi_reset_provider(struct scsi_device *
 	scmd->cmd_len			= 0;
 
 	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
-
-	init_timer(&scmd->eh_timeout);
 
 	/*
 	 * Sometimes the command can get back into the timer chain,
diff -r 1b51503899a0 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/scsi_lib.c	Mon Oct 08 21:57:34 2007 -0700
@@ -159,6 +159,29 @@ int scsi_queue_insert(struct scsi_cmnd *
 	scsi_run_queue(q);
 
 	return 0;
+}
+
+/**
+ * scsi_queue_retry - Try inserting a command in the midlevel queue.
+ *
+ * @cmd:	command that we are adding to queue.
+ * @reason:	why we are inserting command to queue.
+ *
+ * Notes:       This is very similar to scsi_queue_insert except that we
+ *              call this function when we don't know if the blk layer timer
+ *              is active or not. We could implement this either by calling
+ *              blk_delete_timer and inserting in the midlevel queue if we
+ *              successfully delete the timer OR setting appropriate result
+ *              field in the cmd and letting it go through the normal done
+ *              routines which will retry the command. For now, We call
+ *              blk_delete_timer!
+ */
+void scsi_queue_retry(struct scsi_cmnd *cmd, int reason)
+{
+	if (blk_delete_timer(cmd->request)) {
+		atomic_inc(&cmd->device->iodone_cnt);
+		scsi_queue_insert(cmd, reason);
+	}
 }
 
 /**
@@ -1227,7 +1250,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 	
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
-	cmd->timeout_per_command = req->timeout;
 	cmd->done = scsi_blk_pc_done;
 	return BLKPREP_OK;
 }
@@ -1455,16 +1477,25 @@ static void scsi_kill_request(struct req
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 
-	__scsi_done(cmd);
+	__blk_complete_request(req);
 }
 
 static void scsi_softirq_done(struct request *rq)
 {
-	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
+	struct scsi_cmnd *cmd = rq->special;
+	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
 	int disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
+
+	/*
+	 * Set the serial numbers back to zero
+	 */
+	cmd->serial_number = 0;
+	
+	atomic_inc(&cmd->device->iodone_cnt);
+	if (cmd->result)
+		atomic_inc(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
 	if (disposition != SUCCESS &&
@@ -1699,6 +1730,7 @@ struct request_queue *scsi_alloc_queue(s
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
+	blk_queue_rq_timed_out(q, scsi_times_out);
 	return q;
 }
 
diff -r 1b51503899a0 drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/scsi_priv.h	Mon Oct 08 21:57:34 2007 -0700
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 
 struct request_queue;
+struct request;
 struct scsi_cmnd;
 struct scsi_device;
 struct scsi_host_template;
@@ -27,7 +28,6 @@ extern int scsi_dispatch_cmd(struct scsi
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
-extern void __scsi_done(struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
@@ -49,10 +49,7 @@ extern void scsi_exit_devinfo(void);
 extern void scsi_exit_devinfo(void);
 
 /* scsi_error.c */
-extern void scsi_add_timer(struct scsi_cmnd *, int,
-		void (*)(struct scsi_cmnd *));
-extern int scsi_delete_timer(struct scsi_cmnd *);
-extern void scsi_times_out(struct scsi_cmnd *cmd);
+extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
@@ -67,6 +64,7 @@ extern int scsi_maybe_unblock_host(struc
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_retry(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
diff -r 1b51503899a0 drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/scsi_sysfs.c	Mon Oct 08 21:57:34 2007 -0700
@@ -480,12 +480,15 @@ sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
 
+/*
+ * TODO: can we make these symlinks to the block layer ones?
+ */
 static ssize_t
 sdev_show_timeout (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf (buf, 20, "%d\n", sdev->timeout / HZ);
+	return snprintf (buf, 20, "%d\n", sdev->request_queue->rq_timeout / HZ);
 }
 
 static ssize_t
@@ -495,7 +498,7 @@ sdev_store_timeout (struct device *dev, 
 	int timeout;
 	sdev = to_scsi_device(dev);
 	sscanf (buf, "%d\n", &timeout);
-	sdev->timeout = timeout * HZ;
+	blk_queue_rq_timeout(sdev->request_queue, timeout * HZ);
 	return count;
 }
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
diff -r 1b51503899a0 drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/scsi_transport_fc.c	Mon Oct 08 21:57:34 2007 -0700
@@ -1921,15 +1921,15 @@ static int fc_vport_match(struct attribu
  * Notes:
  *	This routine assumes no locks are held on entry.
  **/
-static enum scsi_eh_timer_return
+static enum blk_eh_timer_return
 fc_timed_out(struct scsi_cmnd *scmd)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
 
 	if (rport->port_state == FC_PORTSTATE_BLOCKED)
-		return EH_RESET_TIMER;
-
-	return EH_NOT_HANDLED;
+		return BLK_EH_RESET_TIMER;
+
+	return BLK_EH_NOT_HANDLED;
 }
 
 /*
diff -r 1b51503899a0 drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/sd.c	Mon Oct 08 21:57:34 2007 -0700
@@ -337,7 +337,6 @@ static int sd_prep_fn(struct request_que
 	struct gendisk *disk = rq->rq_disk;
 	sector_t block = rq->sector;
 	unsigned int this_count = rq->nr_sectors;
-	unsigned int timeout = sdp->timeout;
 	int ret;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
@@ -506,7 +505,6 @@ static int sd_prep_fn(struct request_que
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
-	SCpnt->timeout_per_command = timeout;
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
@@ -1633,11 +1631,12 @@ static int sd_probe(struct device *dev)
 	sdkp->index = index;
 	sdkp->openers = 0;
 
-	if (!sdp->timeout) {
+	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
-			sdp->timeout = SD_TIMEOUT;
+			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
 		else
-			sdp->timeout = SD_MOD_TIMEOUT;
+			blk_queue_rq_timeout(sdp->request_queue,
+					     SD_MOD_TIMEOUT);
 	}
 
 	class_device_initialize(&sdkp->cdev);
diff -r 1b51503899a0 drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/sr.c	Mon Oct 08 21:57:34 2007 -0700
@@ -306,7 +306,7 @@ static void rw_intr(struct scsi_cmnd * S
 
 static int sr_prep_fn(struct request_queue *q, struct request *rq)
 {
-	int block=0, this_count, s_size, timeout = SR_TIMEOUT;
+	int block=0, this_count, s_size;
 	struct scsi_cd *cd;
 	struct scsi_cmnd *SCpnt;
 	struct scsi_device *sdp = q->queuedata;
@@ -435,7 +435,6 @@ static int sr_prep_fn(struct request_que
 	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = MAX_RETRIES;
-	SCpnt->timeout_per_command = timeout;
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
@@ -599,6 +598,8 @@ static int sr_probe(struct device *dev)
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
 	disk->flags = GENHD_FL_CD;
+
+	blk_queue_rq_timeout(sdev->request_queue, SR_TIMEOUT);
 
 	cd->device = sdev;
 	cd->disk = disk;
diff -r 1b51503899a0 drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Sep 27 00:25:15 2007 -0700
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Oct 08 21:57:34 2007 -0700
@@ -571,8 +571,8 @@ static int sym53c8xx_queue_command(struc
 	 *  Shorten our settle_time if needed for 
 	 *  this command not to time out.
 	 */
-	if (np->s.settle_time_valid && cmd->timeout_per_command) {
-		unsigned long tlimit = jiffies + cmd->timeout_per_command;
+	if (np->s.settle_time_valid && cmd->request->timeout) {
+		unsigned long tlimit = jiffies + cmd->request->timeout;
 		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
 		if (time_after(np->s.settle_time, tlimit)) {
 			np->s.settle_time = tlimit;
diff -r 1b51503899a0 include/linux/blkdev.h
--- a/include/linux/blkdev.h	Thu Sep 27 00:25:15 2007 -0700
+++ b/include/linux/blkdev.h	Mon Oct 08 21:57:34 2007 -0700
@@ -309,6 +309,7 @@ struct request {
 	void *data;
 	void *sense;
 
+	struct timer_list timer;
 	unsigned int timeout;
 	int retries;
 
@@ -346,6 +347,14 @@ typedef int (merge_bvec_fn) (struct requ
 typedef int (merge_bvec_fn) (struct request_queue *, struct bio *, struct bio_vec *);
 typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
+
+enum blk_eh_timer_return {
+	BLK_EH_NOT_HANDLED,
+	BLK_EH_HANDLED,
+	BLK_EH_RESET_TIMER,
+};
+
+typedef enum blk_eh_timer_return (rq_timed_out_fn)(struct request *);
 
 enum blk_queue_state {
 	Queue_down,
@@ -383,6 +392,7 @@ struct request_queue
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
+	rq_timed_out_fn		*rq_timed_out_fn;
 
 	/*
 	 * Dispatch queue sorting
@@ -452,6 +462,8 @@ struct request_queue
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight;
+
+	unsigned int		rq_timeout;
 
 	/*
 	 * sg stuff
@@ -747,6 +759,10 @@ extern void end_queued_request(struct re
 extern void end_queued_request(struct request *, int);
 extern void end_dequeued_request(struct request *, int);
 extern void blk_complete_request(struct request *);
+extern void __blk_complete_request(struct request *);
+extern void blk_abort_req(struct request *);
+extern int blk_delete_timer(struct request *);
+extern void blk_add_timer(struct request *);
 
 /*
  * end_that_request_first/chunk() takes an uptodate argument. we account
@@ -758,6 +774,8 @@ extern void blk_complete_request(struct 
 
 static inline void blkdev_dequeue_request(struct request *req)
 {
+	if (req->q->rq_timed_out_fn)
+		blk_add_timer(req);
 	elv_dequeue_request(req->q, req);
 }
 
@@ -781,6 +799,8 @@ extern void blk_queue_merge_bvec(struct 
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
+extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
+extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);
 extern int blk_do_ordered(struct request_queue *, struct request **);
diff -r 1b51503899a0 include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	Thu Sep 27 00:25:15 2007 -0700
+++ b/include/scsi/scsi_cmnd.h	Mon Oct 08 21:57:34 2007 -0700
@@ -57,7 +57,6 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
-	int timeout_per_command;
 
 	unsigned char cmd_len;
 	enum dma_data_direction sc_data_direction;
@@ -67,7 +66,6 @@ struct scsi_cmnd {
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 	unsigned request_bufflen;	/* Actual request size */
 
-	struct timer_list eh_timeout;	/* Used to time out the command. */
 	void *request_buffer;		/* Actual requested buffer */
 
 	/* These elements define the operation we ultimately want to perform */
@@ -127,7 +125,6 @@ extern void __scsi_put_command(struct Sc
 			       struct device *);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
-extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
diff -r 1b51503899a0 include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Thu Sep 27 00:25:15 2007 -0700
+++ b/include/scsi/scsi_host.h	Mon Oct 08 21:57:34 2007 -0700
@@ -41,13 +41,6 @@ struct blk_queue_tags;
 
 #define DISABLE_SG_CHAINING 0
 #define ENABLE_SG_CHAINING 1
-
-enum scsi_eh_timer_return {
-	EH_NOT_HANDLED,
-	EH_HANDLED,
-	EH_RESET_TIMER,
-};
-
 
 struct scsi_host_template {
 	struct module *module;
@@ -339,7 +332,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+	enum blk_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
 
 	/*
 	 * Name of proc directory
diff -r 1b51503899a0 include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h	Thu Sep 27 00:25:15 2007 -0700
+++ b/include/scsi/scsi_transport.h	Mon Oct 08 21:57:34 2007 -0700
@@ -21,6 +21,7 @@
 #define SCSI_TRANSPORT_H
 
 #include <linux/transport_class.h>
+#include <linux/blkdev.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 
@@ -64,7 +65,7 @@ struct scsi_transport_template {
 	 *			begin counting again
 	 * EH_NOT_HANDLED	Begin normal error recovery
 	 */
-	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+	enum blk_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
 
 	/*
 	 * Used as callback for the completion of i_t_nexus request
