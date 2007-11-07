From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] gdth: scp timeout clean up (try #2)
Date: Wed, 7 Nov 2007 14:22:57 +0100
Message-ID: <20071107132256.GG5525@kernel.dk>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:6785 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbXKGNXs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Nov 2007 08:23:48 -0500
Content-Disposition: inline
In-Reply-To: <20071106223453.GA5668@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Achim_Leubner@adaptec.com

On Tue, Nov 06 2007, malahal@us.ibm.com wrote:
> gdth driver is modified NOT to use scp->eh_timeout. Now, it has
> eh_timed_out (gdth_timed_out) to handle command timeouts for locked
> I/O's. Have not tested as I don't have needed hardware! Patch is
> against 2.6.23-mm1.

I updated the timeout patch to current kernel and fixed some fallout. I
included your gdth patch.

Completely untested, patch is below. It's also in the #timeout branch of
the block git repo, to keep track of it.

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 75c98d5..79ed268 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -46,6 +46,7 @@ static struct io_context *current_io_context(gfp_t gfp_flags, int node);
 static void blk_recalc_rq_segments(struct request *rq);
 static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			    struct bio *bio);
+static void blk_rq_timed_out_timer(unsigned long data);
 
 /*
  * For the allocated request tables
@@ -181,6 +182,18 @@ void blk_queue_softirq_done(struct request_queue *q, softirq_done_fn *fn)
 
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
@@ -243,7 +256,9 @@ static void rq_init(struct request_queue *q, struct request *rq)
 {
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
+	INIT_LIST_HEAD(&rq->timeout_list);
 
+	rq->timeout = 0;
 	rq->errors = 0;
 	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
@@ -1868,6 +1883,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	}
 
 	init_timer(&q->unplug_timer);
+	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
+	INIT_LIST_HEAD(&q->timeout_list);
 
 	kobject_set_name(&q->kobj, "%s", "queue");
 	q->kobj.ktype = &queue_ktype;
@@ -2285,6 +2302,7 @@ EXPORT_SYMBOL(blk_start_queueing);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
+	blk_delete_timer(rq);
 	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
 
 	if (blk_rq_tagged(rq))
@@ -3622,12 +3640,145 @@ static int __cpuinit blk_cpu_notify(struct notifier_block *self, unsigned long a
 	return NOTIFY_OK;
 }
 
-
 static struct notifier_block blk_cpu_notifier __cpuinitdata = {
 	.notifier_call	= blk_cpu_notify,
 };
 
 /**
+ * blk_delete_timer - Delete/cancel timer for a given function.
+ * @req:	request that we are canceling timer for
+ *
+ * Return value:
+ *     1 if we were able to detach the timer.  0 if we blew it, and the
+ *     timer function has already started to run. Caller must hold queue lock.
+ */
+int blk_delete_timer(struct request *req)
+{
+	struct request_queue *q = req->q;
+ 
+	/*
+	 * Nothing to detach
+	 */
+	if (!q->rq_timed_out_fn)
+		return 1;
+
+	/*
+	 * Not on the list, must have already been scheduled (or never added)
+	 */
+	if (list_empty(&req->timeout_list))
+		return 0;
+
+	list_del_init(&req->timeout_list);
+
+	if (list_empty(&q->timeout_list))
+		del_timer(&q->timeout);
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(blk_delete_timer);
+
+static void blk_rq_timed_out(struct request *req)
+{
+	struct request_queue *q = req->q;
+	enum blk_eh_timer_return ret;
+
+	ret = q->rq_timed_out_fn(req);
+	switch (ret) {
+	case BLK_EH_HANDLED:
+		__blk_complete_request(req);
+		break;
+	case BLK_EH_RESET_TIMER:
+		blk_add_timer(req);
+		break;
+	case BLK_EH_NOT_HANDLED:
+		/*
+		 * LLD handles this for now but in the future
+		 * we can send a request msg to abort the command
+		 * and we can move more of the generic scsi eh code to
+		 * the blk layer.
+		 */
+		break;
+	default:
+		printk(KERN_ERR "block: bad eh return: %d\n", ret);
+		break;
+	}
+}
+
+static void blk_rq_timed_out_timer(unsigned long data)
+{
+	struct request_queue *q = (struct request_queue *) data;
+	unsigned long flags, next = 0;
+	struct request *rq, *tmp;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list) {
+		if (!next || time_before(next, rq->timeout))
+			next = rq->timeout;
+		if (time_after_eq(jiffies, rq->timeout)) {
+			list_del_init(&rq->timeout_list);
+			blk_rq_timed_out(rq);
+		}
+	}
+
+	if (next)
+		mod_timer(&q->timeout, round_jiffies(next));
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+/**
+ * blk_abort_request -- Request request recovery for the specified command
+ * @req:	pointer to the request of interest
+ *
+ * This function requests that the block layer start recovery for the
+ * request by deleting the timer and calling the q's timeout function.
+ * LLDDs who implement their own error recovery MAY ignore the timeout
+ * event if they generated blk_abort_req. Must hold queue lock.
+ */
+void blk_abort_request(struct request *req)
+{
+        if (!blk_delete_timer(req))
+                return;
+        blk_rq_timed_out(req);
+}
+EXPORT_SYMBOL_GPL(blk_abort_request);
+
+/**
+ * blk_add_timer - Start timeout timer for a single request
+ * @req:	request that is about to start running.
+ *
+ * Notes:
+ *    Each request has its own timer, and as it is added to the queue, we
+ *    set up the timer. When the request completes, we cancel the timer.
+ */
+void blk_add_timer(struct request *req)
+{
+	struct request_queue *q = req->q;
+	unsigned long expiry;
+
+	BUG_ON(!list_empty(&req->timeout_list));
+
+	if (req->timeout)
+		req->timeout += jiffies;
+	else
+		req->timeout = jiffies + q->rq_timeout;
+
+	list_add_tail(&req->timeout_list, &q->timeout_list);
+
+	/*
+	 * If the timer isn't already pending or this timeout is earlier
+	 * than an existing one, modify the timer. Round to next nearest
+	 * second.
+	 */
+	expiry = round_jiffies(req->timeout);
+	if (!timer_pending(&q->timeout) ||
+	    time_before(expiry, q->timeout.expires))
+		mod_timer(&q->timeout, expiry);
+}
+EXPORT_SYMBOL_GPL(blk_add_timer);
+
+/**
  * blk_complete_request - end I/O on a request
  * @req:      the request being processed
  *
@@ -3638,14 +3789,13 @@ static struct notifier_block blk_cpu_notifier __cpuinitdata = {
  *     through a softirq handler. The user must have registered a completion
  *     callback through blk_queue_softirq_done().
  **/
-
-void blk_complete_request(struct request *req)
+void __blk_complete_request(struct request *req)
 {
 	struct list_head *cpu_list;
 	unsigned long flags;
 
 	BUG_ON(!req->q->softirq_done_fn);
-		
+
 	local_irq_save(flags);
 
 	cpu_list = &__get_cpu_var(blk_cpu_done);
@@ -3654,9 +3804,36 @@ void blk_complete_request(struct request *req)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(__blk_complete_request);
+
+/**
+ * blk_complete_request - end I/O on a request
+ * @req:	the request being processed
+ *
+ * Description:
+ *     Ends all I/O on a request. It does not handle partial completions,
+ *     unless the driver actually implements this in its completion callback
+ *     through requeueing. Theh actual completion happens out-of-order,
+ *     through a softirq handler. The user must have registered a completion
+ *     callback through blk_queue_softirq_done().
+ */
+void blk_complete_request(struct request *req)
+{
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
 
+	__blk_complete_request(req);
+}
 EXPORT_SYMBOL(blk_complete_request);
-	
+
 /*
  * queue lock must be held
  */
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ed8813b..0358b55 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -33,6 +33,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -312,29 +313,29 @@ static void ata_eh_clear_action(struct ata_link *link, struct ata_device *dev,
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
 
@@ -766,7 +767,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 	 * Note that ATA_QCFLAG_FAILED is unconditionally set after
 	 * this function completes.
 	 */
-	scsi_req_abort_cmd(qc->scsicmd);
+	blk_abort_request(qc->scsicmd->request);
 }
 
 /**
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0e6cf3a..ac22b5c 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -164,7 +164,7 @@ extern int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val);
 extern int sata_pmp_attach(struct ata_device *dev);
 
 /* libata-eh.c */
-extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
+extern enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern void ata_scsi_error(struct Scsi_Host *host);
 extern void ata_port_wait_eh(struct ata_port *ap);
 extern void ata_eh_fastdrain_timerfn(unsigned long arg);
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a77ab8d..3c8356d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1125,7 +1125,7 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
 	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
-	timeout = cmd->timeout_per_command/HZ;
+	timeout = cmd->request->timeout/HZ;
 	if (timeout == 0)
 		timeout = 1;
 	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b253b8c..da655c8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -507,7 +507,6 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
 
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
-    scp->timeout_per_command = timeout*HZ;
     sg_init_one(&one_sg, gdtcmd, sizeof(*gdtcmd));
     gdth_set_sglist(scp, &one_sg);
     gdth_set_sg_count(scp, 1);
@@ -2056,23 +2055,12 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
     ulong flags;
-    unchar b, t;
 
     TRACE(("gdth_putq() priority %d\n",priority));
     spin_lock_irqsave(&ha->smp_lock, flags);
 
-    if (!cmndinfo->internal_command) {
+    if (!cmndinfo->internal_command)
         cmndinfo->priority = priority;
-        b = scp->device->channel;
-        t = scp->device->id;
-        if (priority >= DEFAULT_PRI) {
-            if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
-                (b==ha->virt_bus && t<MAX_HDRIVES && ha->hdr[t].lock)) {
-                TRACE2(("gdth_putq(): locked IO ->update_timeout()\n"));
-                cmndinfo->timeout = gdth_update_timeout(scp, 0);
-            }
-        }
-    }
 
     if (ha->req_first==NULL) {
         ha->req_first = scp;                    /* queue was empty */
@@ -3938,6 +3926,39 @@ static const char *gdth_info(struct Scsi_Host *shp)
     return ((const char *)ha->binfo.type_string);
 }
 
+static enum blk_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
+{
+	gdth_ha_str *ha = shost_priv(scp->device->host);
+	struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
+	unchar b, t;
+	ulong flags;
+	enum blk_eh_timer_return retval = BLK_EH_NOT_HANDLED;
+
+	TRACE(("%s() cmd 0x%x\n", scp->cmnd[0], __FUNCTION__));
+	b = scp->device->channel;
+	t = scp->device->id;
+
+	/*
+	 * We don't really honor the command timeout, but we try to
+	 * honor 6 times of the actual command timeout! So reset the
+	 * timer if this is less than 6th timeout on this command!
+	 */
+	if (++cmndinfo->timeout_count < 6)
+		retval = BLK_EH_RESET_TIMER;
+
+	/* Reset the timeout if it is locked IO */
+	spin_lock_irqsave(&ha->smp_lock, flags);
+	if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha, b)].lock) ||
+	    (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) {
+		TRACE2(("%s(): locked IO, reset timeout\n", __FUNCTION__));
+		retval = BLK_EH_RESET_TIMER;
+	}
+	spin_unlock_irqrestore(&ha->smp_lock, flags);
+
+	return retval;
+}
+
+
 static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
@@ -4031,7 +4052,7 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
     BUG_ON(!cmndinfo);
 
     scp->scsi_done = done;
-    gdth_update_timeout(scp, scp->timeout_per_command * 6);
+    cmndinfo->timeout_count = 0;
     cmndinfo->priority = DEFAULT_PRI;
 
     gdth_set_bufflen(scp, scsi_bufflen(scp));
@@ -4137,12 +4158,10 @@ static int ioc_lockdrv(void __user *arg)
             ha->hdr[j].lock = 1;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
             gdth_wait_completion(ha, ha->bus_cnt, j);
-            gdth_stop_timeout(ha, ha->bus_cnt, j);
         } else {
             spin_lock_irqsave(&ha->smp_lock, flags);
             ha->hdr[j].lock = 0;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
-            gdth_start_timeout(ha, ha->bus_cnt, j);
             gdth_next(ha);
         }
     } 
@@ -4580,18 +4599,14 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
                 spin_lock_irqsave(&ha->smp_lock, flags);
                 ha->raw[i].lock = 1;
                 spin_unlock_irqrestore(&ha->smp_lock, flags);
-                for (j = 0; j < ha->tid_cnt; ++j) {
+                for (j = 0; j < ha->tid_cnt; ++j)
                     gdth_wait_completion(ha, i, j);
-                    gdth_stop_timeout(ha, i, j);
-                }
             } else {
                 spin_lock_irqsave(&ha->smp_lock, flags);
                 ha->raw[i].lock = 0;
                 spin_unlock_irqrestore(&ha->smp_lock, flags);
-                for (j = 0; j < ha->tid_cnt; ++j) {
-                    gdth_start_timeout(ha, i, j);
+                for (j = 0; j < ha->tid_cnt; ++j)
                     gdth_next(ha);
-                }
             }
         } 
         break;
@@ -4724,6 +4739,7 @@ static struct scsi_host_template gdth_template = {
         .slave_configure        = gdth_slave_configure,
         .bios_param             = gdth_bios_param,
         .proc_info              = gdth_proc_info,
+	.eh_timed_out		= gdth_timed_out,
         .proc_name              = "gdth",
         .can_queue              = GDTH_MAXCMDS,
         .this_id                = -1,
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1434c6b..f5851f8 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -917,7 +917,7 @@ typedef struct {
         int internal_command;                   /* don't call scsi_done */
         dma_addr_t sense_paddr;                 /* sense dma-addr */
         unchar priority;
-        int timeout;
+        int timeout_count;			/* # of timeout calls */
         volatile int wait_for_completion;
         ushort status;
         ulong32 info;
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index de57734..b55ed8f 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -750,69 +750,3 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
-
-static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id)
-{
-    ulong flags;
-    Scsi_Cmnd *scp;
-    unchar b, t;
-
-    spin_lock_irqsave(&ha->smp_lock, flags);
-
-    for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-        if (!cmndinfo->internal_command) {
-            b = scp->device->channel;
-            t = scp->device->id;
-            if (t == (unchar)id && b == (unchar)busnum) {
-                TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
-                cmndinfo->timeout = gdth_update_timeout(scp, 0);
-            }
-        }
-    }
-    spin_unlock_irqrestore(&ha->smp_lock, flags);
-}
-
-static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id)
-{
-    ulong flags;
-    Scsi_Cmnd *scp;
-    unchar b, t;
-
-    spin_lock_irqsave(&ha->smp_lock, flags);
-
-    for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-        if (!cmndinfo->internal_command) {
-            b = scp->device->channel;
-            t = scp->device->id;
-            if (t == (unchar)id && b == (unchar)busnum) {
-                TRACE2(("gdth_start_timeout(): update_timeout()\n"));
-                gdth_update_timeout(scp, cmndinfo->timeout);
-            }
-        }
-    }
-    spin_unlock_irqrestore(&ha->smp_lock, flags);
-}
-
-static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout)
-{
-    int oldto;
-
-    oldto = scp->timeout_per_command;
-    scp->timeout_per_command = timeout;
-
-    if (timeout == 0) {
-        del_timer(&scp->eh_timeout);
-        scp->eh_timeout.data = (unsigned long) NULL;
-        scp->eh_timeout.expires = 0;
-    } else {
-        if (scp->eh_timeout.data != (unsigned long) NULL) 
-            del_timer(&scp->eh_timeout);
-        scp->eh_timeout.data = (unsigned long) scp;
-        scp->eh_timeout.expires = jiffies + timeout;
-        add_timer(&scp->eh_timeout);
-    }
-
-    return oldto;
-}
diff --git a/drivers/scsi/gdth_proc.h b/drivers/scsi/gdth_proc.h
index 45e6fda..9b900cc 100644
--- a/drivers/scsi/gdth_proc.h
+++ b/drivers/scsi/gdth_proc.h
@@ -20,9 +20,6 @@ static char *gdth_ioctl_alloc(gdth_ha_str *ha, int size, int scratch,
                               ulong64 *paddr);
 static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr);
 static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id);
-static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id);
-static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id);
-static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout);
 
 #endif
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 5f2396c..499af38 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -740,7 +740,7 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 	init_event_struct(evt_struct,
 			  handle_cmd_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  cmnd->timeout_per_command/HZ);
+			  cmnd->request->timeout/HZ);
 
 	evt_struct->cmnd = cmnd;
 	evt_struct->cmnd_done = done;
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 8d0244c..43826f4 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -812,7 +812,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;
 	pc->done = done;
-	pc->timeout = jiffies + cmd->timeout_per_command;
+	pc->timeout = jiffies + cmd->request->timeout;
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0841df0..2960674 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3659,7 +3659,8 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 			sdev->no_uld_attach = 1;
 		}
 		if (ipr_is_vset_device(res)) {
-			sdev->timeout = IPR_VSET_RW_TIMEOUT;
+			blk_queue_rq_timeout(sdev->request_queue,
+					     IPR_VSET_RW_TIMEOUT);
 			blk_queue_max_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
 		}
 		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 5c5a9b2..faffc87 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3863,7 +3863,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		scb->cmd.dcdb.segment_4G = 0;
 		scb->cmd.dcdb.enhanced_sg = 0;
 
-		TimeOut = scb->scsi_cmd->timeout_per_command;
+		TimeOut = scb->scsi_cmd->request->timeout;
 
 		if (ha->subsys->param[4] & 0x00100000) {	/* If NEW Tape DCDB is Supported */
 			if (!scb->sg_len) {
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0829b55..8dc4fef 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -407,7 +407,7 @@ void sas_ata_task_abort(struct sas_task *task)
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
-		scsi_req_abort_cmd(qc->scsicmd);
+		blk_abort_request(qc->scsicmd->request);
 		scsi_schedule_eh(qc->scsicmd->device->host);
 		return;
 	}
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 2b8213b..13ac4a3 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -55,7 +55,7 @@ void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
 void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
-enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *);
+enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *);
 
 int  sas_init_queue(struct sas_ha_struct *sas_ha);
 int  sas_init_events(struct sas_ha_struct *sas_ha);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7663841..004b232 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
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
@@ -1020,7 +1020,7 @@ void sas_task_abort(struct sas_task *task)
 		return;
 	}
 
-	scsi_req_abort_cmd(sc);
+	blk_abort_request(sc->request);
 	scsi_schedule_eh(sc->device->host);
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index e3c5c52..67a8c52 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -969,7 +969,7 @@ static int megasas_generic_reset(struct scsi_cmnd *scmd)
  * cmd has not been completed within the timeout period.
  */
 static enum
-scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
+blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 {
 	struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
 	struct megasas_instance *instance;
@@ -977,7 +977,7 @@ scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 
 	if (time_after(jiffies, scmd->jiffies_at_alloc +
 				(MEGASAS_DEFAULT_CMD_TIMEOUT * 2) * HZ)) {
-		return EH_NOT_HANDLED;
+		return BLK_EH_NOT_HANDLED;
 	}
 
 	instance = cmd->instance;
@@ -991,7 +991,7 @@ scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 
 		spin_unlock_irqrestore(instance->host->host_lock, flags);
 	}
-	return EH_RESET_TIMER;
+	return BLK_EH_RESET_TIMER;
 }
 
 /**
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 016c462..f809406 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4170,8 +4170,8 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
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
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 3aeb68b..2aabcbd 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2862,7 +2862,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->timeout_per_command/HZ);
+	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
@@ -3167,7 +3167,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(cmd->timeout_per_command/HZ);
+	pkt->timeout = cpu_to_le16(cmd->request->timeout/HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 89460d2..463ab4e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1565,7 +1565,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
 		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
-		      cmd, jiffies, cmd->timeout_per_command / HZ,
+		      cmd, jiffies, cmd->request->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
 	/* FIXME: wait for hba to go online */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1929488..9bcca34 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -204,7 +204,6 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 
 		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
-		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
 		spin_lock_irqsave(&dev->list_lock, flags);
 		list_add_tail(&cmd->list, &dev->cmd_list);
@@ -468,14 +467,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
@@ -488,7 +492,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * future requests should not occur until the device 
 		 * transitions out of the suspend state.
 		 */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+
+		scsi_queue_retry(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
 		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
 
@@ -530,21 +535,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		host->resetting = 0;
 	}
 
-	/* 
-	 * AK: unlikely race here: for some reason the timer could
-	 * expire before the serial number is set up below.
-	 */
-	scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
-
 	scsi_log_send(cmd);
 
 	/*
-	 * We will use a queued command if possible, otherwise we will
-	 * emulate the queuing and calling of completion function ourselves.
-	 */
-	atomic_inc(&cmd->device->iorequest_cnt);
-
-	/*
 	 * Before we queue this command, check if the command
 	 * length exceeds what the host adapter can handle.
 	 */
@@ -558,6 +551,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
@@ -568,12 +567,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
@@ -584,24 +579,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 }
 
 /**
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
-
-/**
  * scsi_done - Enqueue the finished SCSI command into the done queue.
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
  * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
@@ -616,42 +593,7 @@ EXPORT_SYMBOL(scsi_req_abort_cmd);
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
 
 /* Move this to a header if it becomes more generally useful */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ebaca4c..1786ab1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -112,69 +112,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
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
@@ -182,9 +121,11 @@ int scsi_delete_timer(struct scsi_cmnd *scmd)
  *     normal completion function determines that the timer has already
  *     fired, then it mustn't do anything.
  **/
-void scsi_times_out(struct scsi_cmnd *scmd)
+enum blk_eh_timer_return scsi_times_out(struct request *req)
 {
-	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+	struct scsi_cmnd *scmd = req->special;
+	enum blk_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
@@ -196,22 +137,20 @@ void scsi_times_out(struct scsi_cmnd *scmd)
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
+		return BLK_EH_HANDLED;
 	}
+
+	return BLK_EH_NOT_HANDLED;
 }
 
 /**
@@ -1694,7 +1633,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	int rtn;
 
 	scmd->request = &req;
-	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
@@ -1706,8 +1644,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 
 	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
 
-	init_timer(&scmd->eh_timeout);
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0e81e4c..e2e32ff 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -162,6 +162,29 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 }
 
 /**
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
+}
+
+/**
  * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
  * @cmd:	scsi command
@@ -1218,7 +1241,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
-	cmd->timeout_per_command = req->timeout;
 	return BLKPREP_OK;
 }
 EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
@@ -1445,17 +1467,26 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
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
 
+	/*
+	 * Set the serial numbers back to zero
+	 */
+	cmd->serial_number = 0;
+	
+	atomic_inc(&cmd->device->iodone_cnt);
+	if (cmd->result)
+		atomic_inc(&cmd->device->ioerr_cnt);
+
 	disposition = scsi_decide_disposition(cmd);
 	if (disposition != SUCCESS &&
 	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
@@ -1689,6 +1720,7 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
+	blk_queue_rq_timed_out(q, scsi_times_out);
 	return q;
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index eff0059..a04ef47 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 
 struct request_queue;
+struct request;
 struct scsi_cmnd;
 struct scsi_device;
 struct scsi_host_template;
@@ -27,7 +28,6 @@ extern void scsi_exit_hosts(void);
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
-extern void __scsi_done(struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
@@ -49,10 +49,7 @@ extern int __init scsi_init_devinfo(void);
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
@@ -67,6 +64,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_retry(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f374fdc..7edb0bf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -493,12 +493,15 @@ sdev_rd_attr (vendor, "%.8s\n");
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
@@ -508,7 +511,7 @@ sdev_store_timeout (struct device *dev, struct device_attribute *attr, const cha
 	int timeout;
 	sdev = to_scsi_device(dev);
 	sscanf (buf, "%d\n", &timeout);
-	sdev->timeout = timeout * HZ;
+	blk_queue_rq_timeout(sdev->request_queue, timeout * HZ);
 	return count;
 }
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 7a7cfe5..c2d2b8b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1921,15 +1921,15 @@ static int fc_vport_match(struct attribute_container *cont,
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
+		return BLK_EH_RESET_TIMER;
 
-	return EH_NOT_HANDLED;
+	return BLK_EH_NOT_HANDLED;
 }
 
 /*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a69b155..230921c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -351,7 +351,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	struct gendisk *disk = rq->rq_disk;
 	sector_t block = rq->sector;
 	unsigned int this_count = rq->nr_sectors;
-	unsigned int timeout = sdp->timeout;
 	int ret;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
@@ -520,7 +519,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
-	SCpnt->timeout_per_command = timeout;
 
 	/*
 	 * This indicates that the command is ready from our end to be
@@ -1635,11 +1633,12 @@ static int sd_probe(struct device *dev)
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
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index c619990..fb7aeb7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -293,7 +293,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 
 static int sr_prep_fn(struct request_queue *q, struct request *rq)
 {
-	int block=0, this_count, s_size, timeout = SR_TIMEOUT;
+	int block=0, this_count, s_size;
 	struct scsi_cd *cd;
 	struct scsi_cmnd *SCpnt;
 	struct scsi_device *sdp = q->queuedata;
@@ -422,7 +422,6 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = MAX_RETRIES;
-	SCpnt->timeout_per_command = timeout;
 
 	/*
 	 * This indicates that the command is ready from our end to be
@@ -581,6 +580,8 @@ static int sr_probe(struct device *dev)
 	disk->fops = &sr_bdops;
 	disk->flags = GENHD_FL_CD;
 
+	blk_queue_rq_timeout(sdev->request_queue, SR_TIMEOUT);
+
 	cd->device = sdev;
 	cd->disk = disk;
 	cd->driver = &sr_template;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 0f74aba..ab2a91f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -520,8 +520,8 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8396db2..917fe86 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -295,7 +295,8 @@ struct request {
 	void *data;
 	void *sense;
 
-	unsigned int timeout;
+	unsigned long timeout;
+	struct list_head timeout_list;
 	int retries;
 
 	/*
@@ -333,6 +334,14 @@ typedef int (merge_bvec_fn) (struct request_queue *, struct bio *, struct bio_ve
 typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
 
+enum blk_eh_timer_return {
+	BLK_EH_NOT_HANDLED,
+	BLK_EH_HANDLED,
+	BLK_EH_RESET_TIMER,
+};
+
+typedef enum blk_eh_timer_return (rq_timed_out_fn)(struct request *);
+
 enum blk_queue_state {
 	Queue_down,
 	Queue_up,
@@ -368,6 +377,7 @@ struct request_queue
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
+	rq_timed_out_fn		*rq_timed_out_fn;
 
 	/*
 	 * Dispatch queue sorting
@@ -439,6 +449,10 @@ struct request_queue
 	unsigned int		nr_sorted;
 	unsigned int		in_flight;
 
+	unsigned int		rq_timeout;
+	struct			timer_list timeout;
+	struct list_head	timeout_list;
+
 	/*
 	 * sg stuff
 	 */
@@ -732,6 +746,10 @@ extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
 extern void end_dequeued_request(struct request *, int);
 extern void blk_complete_request(struct request *);
+extern void __blk_complete_request(struct request *);
+extern void blk_abort_request(struct request *);
+extern int blk_delete_timer(struct request *);
+extern void blk_add_timer(struct request *);
 
 /*
  * end_that_request_first/chunk() takes an uptodate argument. we account
@@ -743,6 +761,8 @@ extern void blk_complete_request(struct request *);
 
 static inline void blkdev_dequeue_request(struct request *req)
 {
+	if (req->q->rq_timed_out_fn)
+		blk_add_timer(req);
 	elv_dequeue_request(req->q, req);
 }
 
@@ -766,6 +786,8 @@ extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
+extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
+extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);
 extern int blk_do_ordered(struct request_queue *, struct request **);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3f47e52..ac0169a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -54,7 +54,6 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
-	int timeout_per_command;
 
 	unsigned char cmd_len;
 	enum dma_data_direction sc_data_direction;
@@ -64,7 +63,6 @@ struct scsi_cmnd {
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 	unsigned request_bufflen;	/* Actual request size */
 
-	struct timer_list eh_timeout;	/* Used to time out the command. */
 	void *request_buffer;		/* Actual requested buffer */
 
 	/* These elements define the operation we ultimately want to perform */
@@ -122,7 +120,6 @@ extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
-extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0fd4746..ebaa645 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -42,13 +42,6 @@ struct blk_queue_tags;
 #define DISABLE_SG_CHAINING 0
 #define ENABLE_SG_CHAINING 1
 
-enum scsi_eh_timer_return {
-	EH_NOT_HANDLED,
-	EH_HANDLED,
-	EH_RESET_TIMER,
-};
-
-
 struct scsi_host_template {
 	struct module *module;
 	const char *name;
@@ -339,7 +332,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+	enum blk_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
 
 	/*
 	 * Name of proc directory
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 0dfef75..4eab054 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
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

-- 
Jens Axboe

