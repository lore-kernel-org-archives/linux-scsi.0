From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] scsi-misc-2.5 remove scsi_device list_lock
Date: Thu, 24 Apr 2003 10:02:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424100229.A32098@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:2287 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263776AbTDXQyG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 12:54:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patch against scsi-misc-2.5 to use the sdev->sdev_lock (or queue_lock)
instead of the sdev->list_lock.

diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/dpt_i2o.c rmcmd_lock-2.5-cur/drivers/scsi/dpt_i2o.c
--- 2.5-cur/drivers/scsi/dpt_i2o.c	Tue Mar 11 11:23:06 2003
+++ rmcmd_lock-2.5-cur/drivers/scsi/dpt_i2o.c	Thu Apr 24 09:14:04 2003
@@ -2512,7 +2512,7 @@ static void adpt_fail_posted_scbs(adpt_h
 
 	list_for_each_entry(d, &pHba->host->my_devices, siblings) {
 		unsigned long flags;
-		spin_lock_irqsave(&d->list_lock, flags);
+		spin_lock_irqsave(&d->sdev_lock, flags);
 		list_for_each_entry(cmd, &d->cmd_list, list) {
 			if(cmd->serial_number == 0){
 				continue;
@@ -2520,7 +2520,7 @@ static void adpt_fail_posted_scbs(adpt_h
 			cmd->result = (DID_OK << 16) | (QUEUE_FULL <<1);
 			cmd->scsi_done(cmd);
 		}
-		spin_unlock_irqrestore(&d->list_lock, flags);
+		spin_unlock_irqrestore(&d->sdev_lock, flags);
 	}
 }
 
diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/hosts.c rmcmd_lock-2.5-cur/drivers/scsi/hosts.c
--- 2.5-cur/drivers/scsi/hosts.c	Mon Apr 21 16:15:43 2003
+++ rmcmd_lock-2.5-cur/drivers/scsi/hosts.c	Thu Apr 24 09:14:04 2003
@@ -214,7 +214,7 @@ static int scsi_check_device_busy(struct
 	 * device.  If any of them are busy, then set the state
 	 * back to inactive and bail.
 	 */
-	spin_lock_irqsave(&sdev->list_lock, flags);
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
 		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE)
 			goto active;
@@ -227,7 +227,7 @@ static int scsi_check_device_busy(struct
 		if (scmd->request)
 			scmd->request->rq_status = RQ_SCSI_DISCONNECTING;
 	}
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	return 0;
 
@@ -244,7 +244,7 @@ active:
 		}
 	}
 
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	printk(KERN_ERR "Device busy???\n");
 	return 1;
 }
diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi.c rmcmd_lock-2.5-cur/drivers/scsi/scsi.c
--- 2.5-cur/drivers/scsi/scsi.c	Mon Apr 21 16:15:43 2003
+++ rmcmd_lock-2.5-cur/drivers/scsi/scsi.c	Thu Apr 24 09:14:04 2003
@@ -254,7 +254,7 @@ static struct scsi_host_cmd_pool scsi_cm
 
 static DECLARE_MUTEX(host_cmd_pool_mutex);
 
-static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
+static struct scsi_cmnd *scsi_alloc_cmd(struct Scsi_Host *shost,
 					    int gfp_mask)
 {
 	struct scsi_cmnd *cmd;
@@ -278,59 +278,82 @@ static struct scsi_cmnd *__scsi_get_comm
 }
 
 /*
- * Function:	scsi_get_command()
+ * Function:	__scsi_get_command()
  *
- * Purpose:	Allocate and setup a scsi command block
+ * Purpose:	Allocate and setup a scsi command block. This function is
+ * 		extern but not exported outside of scsi.
  *
  * Arguments:	dev	- parent scsi device
  *		gfp_mask- allocator flags
  *
+ * Locks:	Called with queue_lock held.
+ *
  * Returns:	The allocated scsi command structure.
  */
-struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int gfp_mask)
+struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int gfp_mask)
 {
-	struct scsi_cmnd *cmd = __scsi_get_command(dev->host, gfp_mask);
+	struct scsi_cmnd *cmd = scsi_alloc_cmd(dev->host, gfp_mask);
 
 	if (likely(cmd != NULL)) {
-		unsigned long flags;
-
 		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
 		cmd->state = SCSI_STATE_UNUSED;
 		cmd->owner = SCSI_OWNER_NOBODY;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
-		spin_lock_irqsave(&dev->list_lock, flags);
 		list_add_tail(&cmd->list, &dev->cmd_list);
-		spin_unlock_irqrestore(&dev->list_lock, flags);
 	}
 
 	return cmd;
 }				
 
 /*
- * Function:	scsi_put_command()
+ * Function:	scsi_get_command()
+ *
+ * Purpose:	Allocate and setup a scsi command block. This function is
+ * 		exported.
+ *
+ * Arguments:	cmd	- command block to free
+ *
+ * Returns:	Nothing.
+ *
+ * Notes:	Mabye drop the gpf_mask argument, as we are (currently) always
+ * 		called with GFP_KERNEL.
+ */
+struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int gfp_mask)
+{
+	struct scsi_cmnd *cmd;
+	unsigned long flags;
+	
+	spin_lock_irqsave(dev->request_queue->queue_lock, flags);
+	cmd = __scsi_get_command(dev, gfp_mask);
+	spin_unlock_irqrestore(dev->request_queue->queue_lock, flags);
+	return cmd;
+}
+
+/*
+ * Function:	__scsi_put_command()
  *
- * Purpose:	Free a scsi command block
+ * Purpose:	Free a scsi command block. This function is extern but not
+ * 		exported outside of scsi.
  *
  * Arguments:	cmd	- command block to free
  *
  * Returns:	Nothing.
  *
+ * Locks:	Called with queue_lock held.
+ *
  * Notes:	The command must not belong to any lists.
  */
-void scsi_put_command(struct scsi_cmnd *cmd)
+void __scsi_put_command(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shost = cmd->device->host;
 	unsigned long flags;
 	
 	/* serious error if the command hasn't come from a device list */
-	spin_lock_irqsave(&cmd->device->list_lock, flags);
 	BUG_ON(list_empty(&cmd->list));
 	list_del_init(&cmd->list);
-	spin_unlock(&cmd->device->list_lock);
-	/* changing locks here, don't need to restore the irq state */
-	spin_lock(&shost->free_list_lock);
+	spin_lock_irqsave(&shost->free_list_lock, flags);
 	if (unlikely(list_empty(&shost->free_list))) {
 		list_add(&cmd->list, &shost->free_list);
 		cmd = NULL;
@@ -342,6 +365,25 @@ void scsi_put_command(struct scsi_cmnd *
 }
 
 /*
+ * Function:	scsi_put_command()
+ *
+ * Purpose:	Free a scsi command block. This function is exported.
+ *
+ * Arguments:	cmd	- command block to free
+ *
+ * Returns:	Nothing.
+ */
+void scsi_put_command(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdev = cmd->device;
+	unsigned long flags;
+	
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	__scsi_put_command(cmd);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+}
+
+/*
  * Function:	scsi_setup_command_freelist()
  *
  * Purpose:	Setup the command freelist for a scsi host.
@@ -1298,7 +1340,7 @@ void scsi_device_put(struct scsi_device 
  * scsi_set_device_offline - set scsi_device offline
  * @sdev:	pointer to struct scsi_device to offline. 
  *
- * Locks:	host_lock held on entry.
+ * Locks:	No scsi locks should be held on entry.
  **/
 void scsi_set_device_offline(struct scsi_device *sdev)
 {
@@ -1307,9 +1349,8 @@ void scsi_set_device_offline(struct scsi
 	struct list_head *lh, *lh_sf;
 	unsigned long flags;
 
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->online = FALSE;
-
-	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
 		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE) {
 			/*
@@ -1323,7 +1364,7 @@ void scsi_set_device_offline(struct scsi
 			list_add_tail(&scmd->eh_entry, &active_list);
 		}
 	}
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	if (!list_empty(&active_list)) {
 		list_for_each_safe(lh, lh_sf, &active_list) {
diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi.h rmcmd_lock-2.5-cur/drivers/scsi/scsi.h
--- 2.5-cur/drivers/scsi/scsi.h	Thu Apr 24 08:58:43 2003
+++ rmcmd_lock-2.5-cur/drivers/scsi/scsi.h	Thu Apr 24 09:14:04 2003
@@ -413,7 +413,9 @@ extern void scsi_exit_queue(void);
 extern int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
+extern struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int flags);
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int flags);
+extern void __scsi_put_command(struct scsi_cmnd *cmd);
 extern void scsi_put_command(struct scsi_cmnd *cmd);
 extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
 extern int scsi_track_queue_full(Scsi_Device *, int);
@@ -546,7 +548,6 @@ struct scsi_device {
 	request_queue_t *request_queue;
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
 	spinlock_t sdev_lock;           /* also the request queue_lock */
-	spinlock_t list_lock;
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
         Scsi_Cmnd *current_cmnd;	/* currently active command */
diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi_lib.c rmcmd_lock-2.5-cur/drivers/scsi/scsi_lib.c
--- 2.5-cur/drivers/scsi/scsi_lib.c	Mon Apr 21 16:24:39 2003
+++ rmcmd_lock-2.5-cur/drivers/scsi/scsi_lib.c	Thu Apr 24 09:14:04 2003
@@ -527,13 +527,13 @@ static struct scsi_cmnd *scsi_end_reques
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(q, req);
 	end_that_request_last(req);
+	__scsi_put_command(cmd);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
 	 */
-	scsi_put_command(cmd);
 	scsi_queue_next_request(q, NULL);
 	return NULL;
 }
@@ -949,7 +949,7 @@ static int scsi_init_io(struct scsi_cmnd
 			req->current_nr_sectors);
 
 	/* release the command and kill it */
-	scsi_put_command(cmd);
+	__scsi_put_command(cmd);
 	return BLKPREP_KILL;
 }
 
@@ -973,7 +973,7 @@ static int scsi_prep_fn(struct request_q
 		struct scsi_request *sreq = req->special;
 
 		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
-			cmd = scsi_get_command(sreq->sr_device, GFP_ATOMIC);
+			cmd = __scsi_get_command(sreq->sr_device, GFP_ATOMIC);
 			if (unlikely(!cmd))
 				goto defer;
 			scsi_init_cmd_from_req(cmd, sreq);
@@ -984,7 +984,7 @@ static int scsi_prep_fn(struct request_q
 		 * Now try and find a command block that we can use.
 		 */
 		if (!req->special) {
-			cmd = scsi_get_command(sdev, GFP_ATOMIC);
+			cmd = __scsi_get_command(sdev, GFP_ATOMIC);
 			if (unlikely(!cmd))
 				goto defer;
 		} else
@@ -1005,10 +1005,10 @@ static int scsi_prep_fn(struct request_q
 	
 	/*
 	 * FIXME: drop the lock here because the functions below
-	 * expect to be called without the queue lock held.  Also,
-	 * previously, we dequeued the request before dropping the
-	 * lock.  We hope REQ_STARTED prevents anything untoward from
-	 * happening now.
+	 * expect to be called without the queue lock held (except
+	 * __scsi_put_command). Also, previously, we dequeued the request
+	 * before dropping the lock. We hope REQ_STARTED prevents
+	 * anything untoward from happening now.
 	 */
 	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 		int ret;
@@ -1041,7 +1041,7 @@ static int scsi_prep_fn(struct request_q
 		 */
 		if (unlikely(!sdt->init_command(cmd))) {
 			scsi_release_buffers(cmd);
-			scsi_put_command(cmd);
+			__scsi_put_command(cmd);
 			return BLKPREP_KILL;
 		}
 	}
diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi_proc.c rmcmd_lock-2.5-cur/drivers/scsi/scsi_proc.c
--- 2.5-cur/drivers/scsi/scsi_proc.c	Thu Apr 24 08:58:43 2003
+++ rmcmd_lock-2.5-cur/drivers/scsi/scsi_proc.c	Thu Apr 24 09:14:04 2003
@@ -360,7 +360,8 @@ static void scsi_dump_status(int level)
 		list_for_each_entry(SDpnt, &shpnt->my_devices, siblings) {
 			unsigned long flags;
 
-			spin_lock_irqsave(&SDpnt->list_lock, flags);
+			spin_lock_irqsave(SDpnt->request_queue->queue_lock,
+					  flags);
 			list_for_each_entry(SCpnt, &SDpnt->cmd_list, list) {
 				/*  (0) h:c:t:l (dev sect nsect cnumsec sg) (ret all flg) (to/cmd to ito) cmd snse result %d %x      */
 				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) (%1d %1d 0x%2x) (%4d %4d %4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
@@ -391,7 +392,8 @@ static void scsi_dump_status(int level)
 				       SCpnt->sense_buffer[2],
 				       SCpnt->result);
 			}
-			spin_unlock_irqrestore(&SDpnt->list_lock, flags);
+			spin_unlock_irqrestore(SDpnt->request_queue->queue_lock,
+					       flags);
 		}
 	}
 }
diff -purN -X /home/patman/dontdiff 2.5-cur/drivers/scsi/scsi_scan.c rmcmd_lock-2.5-cur/drivers/scsi/scsi_scan.c
--- 2.5-cur/drivers/scsi/scsi_scan.c	Thu Apr 24 08:58:43 2003
+++ rmcmd_lock-2.5-cur/drivers/scsi/scsi_scan.c	Thu Apr 24 09:14:04 2003
@@ -408,7 +408,6 @@ static struct scsi_device *scsi_alloc_sd
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
-	spin_lock_init(&sdev->list_lock);
 
 	/*
 	 * Some low level driver could use device->type
