From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove remaining queueing-related code from scsi.c to scsi_lib.c
Date: Tue, 11 Feb 2003 15:21:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211152139.A23300@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Try to keep all queuing-related stuff in one file and sanitize global
symbols.  BTW, any chance you could bk rename scsi_lib.c to
scsi_queue.c?


--- 1.90/drivers/scsi/scsi.c	Sun Feb  9 11:56:18 2003
+++ edited/drivers/scsi/scsi.c	Tue Feb 11 09:53:40 2003
@@ -171,30 +170,6 @@
 #endif
 
 /*
- *	Issue a command and wait for it to complete
- */
- 
-static void scsi_wait_done(Scsi_Cmnd * SCpnt)
-{
-	struct request *req = SCpnt->request;
-        struct request_queue *q = SCpnt->device->request_queue;
-        unsigned long flags;
-
-        ASSERT_LOCK(q->queue_lock, 0);
-	req->rq_status = RQ_SCSI_DONE;	/* Busy, but indicate request done */
-
-        spin_lock_irqsave(q->queue_lock, flags);
-
-        if(blk_rq_tagged(req))
-                blk_queue_end_tag(q, req);
-
-        spin_unlock_irqrestore(q->queue_lock, flags);
-
-	if (req->waiting)
-		complete(req->waiting);
-}
-
-/*
  * Function:    scsi_allocate_request
  *
  * Purpose:     Allocate a request descriptor.
@@ -263,87 +238,6 @@
 	kfree(req);
 }
 
-/*
- * Function:    scsi_mlqueue_insert()
- *
- * Purpose:     Insert a command in the midlevel queue.
- *
- * Arguments:   cmd    - command that we are adding to queue.
- *              reason - why we are inserting command to queue.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     Nothing.
- *
- * Notes:       We do this for one of two cases.  Either the host is busy
- *              and it cannot accept any more commands for the time being,
- *              or the device returned QUEUE_FULL and can accept no more
- *              commands.
- * Notes:       This could be called either from an interrupt context or a
- *              normal process context.
- */
-static int scsi_mlqueue_insert(Scsi_Cmnd * cmd, int reason)
-{
-	struct Scsi_Host *host = cmd->device->host;
-	struct scsi_device *device = cmd->device;
-
-	SCSI_LOG_MLQUEUE(1,
-		 printk("Inserting command %p into mlqueue\n", cmd));
-
-	/*
-	 * We are inserting the command into the ml queue.  First, we
-	 * cancel the timer, so it doesn't time out.
-	 */
-	scsi_delete_timer(cmd);
-
-	/*
-	 * Next, set the appropriate busy bit for the device/host.
-	 *
-	 * If the host/device isn't busy, assume that something actually
-	 * completed, and that we should be able to queue a command now.
-	 *
-	 * Note that the prior mid-layer assumption that any host could
-	 * always queue at least one command is now broken.  The mid-layer
-	 * will implement a user specifiable stall (see
-	 * scsi_host.max_host_blocked and scsi_device.max_device_blocked)
-	 * if a command is requeued with no other commands outstanding
-	 * either for the device or for the host.
-	 */
-	if (reason == SCSI_MLQUEUE_HOST_BUSY) {
-		host->host_blocked = host->max_host_blocked;
-	} else {
-		device->device_blocked = device->max_device_blocked;
-	}
-
-	/*
-	 * Register the fact that we own the thing for now.
-	 */
-	cmd->state = SCSI_STATE_MLQUEUE;
-	cmd->owner = SCSI_OWNER_MIDLEVEL;
-	cmd->bh_next = NULL;
-
-	/*
-	 * Decrement the counters, since these commands are no longer
-	 * active on the host/device.
-	 */
-	scsi_host_busy_dec_and_test(host, device);
-
-	/*
-	 * Insert this command at the head of the queue for it's device.
-	 * It will go before all other commands that are already in the queue.
-	 *
-	 * NOTE: there is magic here about the way the queue is
-	 * plugged if we have no outstanding commands.
-	 * scsi_insert_special_cmd eventually calls
-	 * blk_queue_insert().  Although this *doesn't* plug the
-	 * queue, it does call the request function.  The SCSI request
-	 * function detects the blocked condition and plugs the queue
-	 * appropriately.
-	 */
-	scsi_insert_special_cmd(cmd, 1);
-	return 0;
-}
-
 struct scsi_host_cmd_pool {
 	kmem_cache_t	*slab;
 	unsigned int	users;
@@ -621,7 +515,7 @@
 			rtn = host->hostt->queuecommand(SCpnt, scsi_done);
 			spin_unlock_irqrestore(host->host_lock, flags);
 			if (rtn != 0) {
-				scsi_mlqueue_insert(SCpnt, rtn == SCSI_MLQUEUE_DEVICE_BUSY ? rtn : SCSI_MLQUEUE_HOST_BUSY);
+				scsi_queue_insert(SCpnt, rtn == SCSI_MLQUEUE_DEVICE_BUSY ? rtn : SCSI_MLQUEUE_HOST_BUSY);
 				SCSI_LOG_MLQUEUE(3,
 				   printk("queuecommand : request rejected\n"));                                
 			}
@@ -659,128 +553,6 @@
 	return rtn;
 }
 
-void scsi_wait_req (Scsi_Request * SRpnt, const void *cmnd ,
- 		  void *buffer, unsigned bufflen, 
- 		  int timeout, int retries)
-{
-	DECLARE_COMPLETION(wait);
-	
-	SRpnt->sr_request->waiting = &wait;
-	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
-	scsi_do_req (SRpnt, (void *) cmnd,
-		buffer, bufflen, scsi_wait_done, timeout, retries);
-	generic_unplug_device(SRpnt->sr_device->request_queue);
-	wait_for_completion(&wait);
-	SRpnt->sr_request->waiting = NULL;
-	if( SRpnt->sr_command != NULL )
-	{
-		scsi_put_command(SRpnt->sr_command);
-		SRpnt->sr_command = NULL;
-	}
-
-}
- 
-/*
- * Function:    scsi_do_req
- *
- * Purpose:     Queue a SCSI request
- *
- * Arguments:   SRpnt     - command descriptor.
- *              cmnd      - actual SCSI command to be performed.
- *              buffer    - data buffer.
- *              bufflen   - size of data buffer.
- *              done      - completion function to be run.
- *              timeout   - how long to let it run before timeout.
- *              retries   - number of retries we allow.
- *
- * Lock status: With the new queueing code, this is SMP-safe, and no locks
- *              need be held upon entry.   The old queueing code the lock was
- *              assumed to be held upon entry.
- *
- * Returns:     Nothing.
- *
- * Notes:       Prior to the new queue code, this function was not SMP-safe.
- *              Also, this function is now only used for queueing requests
- *              for things like ioctls and character device requests - this
- *              is because we essentially just inject a request into the
- *              queue for the device. Normal block device handling manipulates
- *              the queue directly.
- */
-void scsi_do_req(Scsi_Request * SRpnt, const void *cmnd,
-	      void *buffer, unsigned bufflen, void (*done) (Scsi_Cmnd *),
-		 int timeout, int retries)
-{
-	Scsi_Device * SDpnt = SRpnt->sr_device;
-	struct Scsi_Host *host = SDpnt->host;
-
-	ASSERT_LOCK(host->host_lock, 0);
-
-	SCSI_LOG_MLQUEUE(4,
-			 {
-			 int i;
-			 int size = COMMAND_SIZE(((const unsigned char *)cmnd)[0]);
-			 printk("scsi_do_req (host = %d, channel = %d target = %d, "
-		    "buffer =%p, bufflen = %d, done = %p, timeout = %d, "
-				"retries = %d)\n"
-				"command : ", host->host_no, SDpnt->channel, SDpnt->id, buffer,
-				bufflen, done, timeout, retries);
-			 for (i	 = 0; i < size; ++i)
-			 	printk("%02x  ", ((unsigned char *) cmnd)[i]);
-			 	printk("\n");
-			 });
-
-	if (!host) {
-		panic("Invalid or not present host.\n");
-	}
-
-	/*
-	 * If the upper level driver is reusing these things, then
-	 * we should release the low-level block now.  Another one will
-	 * be allocated later when this request is getting queued.
-	 */
-	if( SRpnt->sr_command != NULL )
-	{
-		scsi_put_command(SRpnt->sr_command);
-		SRpnt->sr_command = NULL;
-	}
-
-	/*
-	 * We must prevent reentrancy to the lowlevel host driver.  This prevents
-	 * it - we enter a loop until the host we want to talk to is not busy.
-	 * Race conditions are prevented, as interrupts are disabled in between the
-	 * time we check for the host being not busy, and the time we mark it busy
-	 * ourselves.
-	 */
-
-
-	/*
-	 * Our own function scsi_done (which marks the host as not busy, disables
-	 * the timeout counter, etc) will be called by us or by the
-	 * scsi_hosts[host].queuecommand() function needs to also call
-	 * the completion function for the high level driver.
-	 */
-
-	memcpy((void *) SRpnt->sr_cmnd, (const void *) cmnd, 
-	       sizeof(SRpnt->sr_cmnd));
-	SRpnt->sr_bufflen = bufflen;
-	SRpnt->sr_buffer = buffer;
-	SRpnt->sr_allowed = retries;
-	SRpnt->sr_done = done;
-	SRpnt->sr_timeout_per_command = timeout;
-
-	if (SRpnt->sr_cmd_len == 0)
-		SRpnt->sr_cmd_len = COMMAND_SIZE(SRpnt->sr_cmnd[0]);
-
-	/*
-	 * At this point, we merely set up the command, stick it in the normal
-	 * request queue, and return.  Eventually that request will come to the
-	 * top of the list, and will be dispatched.
-	 */
-	scsi_insert_special_req(SRpnt, 0);
-
-	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_do_req()\n"));
-}
- 
 /*
  * Function:    scsi_init_cmd_from_req
  *
@@ -998,7 +770,7 @@
 				 */
 				SCSI_LOG_MLCOMPLETE(3, printk("Command rejected as device queue full, put on ml queue %p\n",
                                                               SCpnt));
-				scsi_mlqueue_insert(SCpnt, SCSI_MLQUEUE_DEVICE_BUSY);
+				scsi_queue_insert(SCpnt, SCSI_MLQUEUE_DEVICE_BUSY);
 				break;
 			default:
 				/*
===== drivers/scsi/scsi.h 1.60 vs edited =====
--- 1.60/drivers/scsi/scsi.h	Sun Feb  9 10:35:26 2003
+++ edited/drivers/scsi/scsi.h	Tue Feb 11 09:57:35 2003
@@ -433,12 +433,11 @@
  */
 extern int scsi_maybe_unblock_host(Scsi_Device * SDpnt);
 extern void scsi_setup_cmd_retry(Scsi_Cmnd *SCpnt);
-extern int scsi_insert_special_cmd(Scsi_Cmnd * SCpnt, int);
 extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
 			       int block_sectors);
-extern void scsi_queue_next_request(request_queue_t * q, Scsi_Cmnd * SCpnt);
-extern int scsi_prep_fn(struct request_queue *q, struct request *req);
-extern void scsi_request_fn(request_queue_t * q);
+extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost);
+extern void scsi_free_queue(request_queue_t *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
 
===== drivers/scsi/scsi_lib.c 1.68 vs edited =====
--- 1.68/drivers/scsi/scsi_lib.c	Thu Feb  6 09:58:07 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Feb 11 11:25:56 2003
@@ -37,11 +37,11 @@
 
 
 /*
- * Function:    scsi_insert_special_cmd()
+ * Function:    scsi_insert_special_req()
  *
- * Purpose:     Insert pre-formed command into request queue.
+ * Purpose:     Insert pre-formed request into request queue.
  *
- * Arguments:   cmd	- command that is ready to be queued.
+ * Arguments:   sreq	- request that is ready to be queued.
  *              at_head	- boolean.  True if we should insert at head
  *                        of queue, false if we should insert at tail.
  *
@@ -56,46 +56,195 @@
  *              for now), and then call the queue request function to actually
  *              process it.
  */
-int scsi_insert_special_cmd(struct scsi_cmnd *cmd, int at_head)
+int scsi_insert_special_req(struct scsi_request *sreq, int at_head)
 {
-	blk_insert_request(cmd->device->request_queue, cmd->request,
-		       	   at_head, cmd);
+	/*
+	 * Because users of this function are apt to reuse requests with no
+	 * modification, we have to sanitise the request flags here
+	 */
+	sreq->sr_request->flags &= ~REQ_DONTPREP;
+	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
+		       	   at_head, sreq);
 	return 0;
 }
 
 /*
- * Function:    scsi_insert_special_req()
+ * Function:    scsi_queue_insert()
  *
- * Purpose:     Insert pre-formed request into request queue.
+ * Purpose:     Insert a command in the midlevel queue.
  *
- * Arguments:   sreq	- request that is ready to be queued.
- *              at_head	- boolean.  True if we should insert at head
- *                        of queue, false if we should insert at tail.
+ * Arguments:   cmd    - command that we are adding to queue.
+ *              reason - why we are inserting command to queue.
  *
  * Lock status: Assumed that lock is not held upon entry.
  *
- * Returns:     Nothing
+ * Returns:     Nothing.
  *
- * Notes:       This function is called from character device and from
- *              ioctl types of functions where the caller knows exactly
- *              what SCSI command needs to be issued.   The idea is that
- *              we merely inject the command into the queue (at the head
- *              for now), and then call the queue request function to actually
- *              process it.
+ * Notes:       We do this for one of two cases.  Either the host is busy
+ *              and it cannot accept any more commands for the time being,
+ *              or the device returned QUEUE_FULL and can accept no more
+ *              commands.
+ * Notes:       This could be called either from an interrupt context or a
+ *              normal process context.
  */
-int scsi_insert_special_req(struct scsi_request *sreq, int at_head)
+int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
+	struct Scsi_Host *host = cmd->device->host;
+	struct scsi_device *device = cmd->device;
+
+	SCSI_LOG_MLQUEUE(1,
+		 printk("Inserting command %p into mlqueue\n", cmd));
+
 	/*
-	 * Because users of this function are apt to reuse requests with no
-	 * modification, we have to sanitise the request flags here
+	 * We are inserting the command into the ml queue.  First, we
+	 * cancel the timer, so it doesn't time out.
 	 */
-	sreq->sr_request->flags &= ~REQ_DONTPREP;
-	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
-		       	   at_head, sreq);
+	scsi_delete_timer(cmd);
+
+	/*
+	 * Next, set the appropriate busy bit for the device/host.
+	 *
+	 * If the host/device isn't busy, assume that something actually
+	 * completed, and that we should be able to queue a command now.
+	 *
+	 * Note that the prior mid-layer assumption that any host could
+	 * always queue at least one command is now broken.  The mid-layer
+	 * will implement a user specifiable stall (see
+	 * scsi_host.max_host_blocked and scsi_device.max_device_blocked)
+	 * if a command is requeued with no other commands outstanding
+	 * either for the device or for the host.
+	 */
+	if (reason == SCSI_MLQUEUE_HOST_BUSY)
+		host->host_blocked = host->max_host_blocked;
+	else
+		device->device_blocked = device->max_device_blocked;
+
+	/*
+	 * Register the fact that we own the thing for now.
+	 */
+	cmd->state = SCSI_STATE_MLQUEUE;
+	cmd->owner = SCSI_OWNER_MIDLEVEL;
+	cmd->bh_next = NULL;
+
+	/*
+	 * Decrement the counters, since these commands are no longer
+	 * active on the host/device.
+	 */
+	scsi_host_busy_dec_and_test(host, device);
+
+	/*
+	 * Insert this command at the head of the queue for it's device.
+	 * It will go before all other commands that are already in the queue.
+	 *
+	 * NOTE: there is magic here about the way the queue is plugged if
+	 * we have no outstanding commands.
+	 * 
+	 * Although this *doesn't* plug the queue, it does call the request
+	 * function.  The SCSI request function detects the blocked condition
+	 * and plugs the queue appropriately.
+	 */
+	blk_insert_request(device->request_queue, cmd->request, 1, cmd);
 	return 0;
 }
 
 /*
+ * Function:    scsi_do_req
+ *
+ * Purpose:     Queue a SCSI request
+ *
+ * Arguments:   sreq	  - command descriptor.
+ *              cmnd      - actual SCSI command to be performed.
+ *              buffer    - data buffer.
+ *              bufflen   - size of data buffer.
+ *              done      - completion function to be run.
+ *              timeout   - how long to let it run before timeout.
+ *              retries   - number of retries we allow.
+ *
+ * Lock status: No locks held upon entry.
+ *
+ * Returns:     Nothing.
+ *
+ * Notes:	This function is only used for queueing requests for things
+ *		like ioctls and character device requests - this is because
+ *		we essentially just inject a request into the queue for the
+ *		device.
+ */
+void scsi_do_req(struct scsi_request *sreq, const void *cmnd,
+		 void *buffer, unsigned bufflen,
+		 void (*done)(struct scsi_cmnd *),
+		 int timeout, int retries)
+{
+	/*
+	 * If the upper level driver is reusing these things, then
+	 * we should release the low-level block now.  Another one will
+	 * be allocated later when this request is getting queued.
+	 */
+	if (sreq->sr_command) {
+		scsi_put_command(sreq->sr_command);
+		sreq->sr_command = NULL;
+	}
+
+	/*
+	 * Our own function scsi_done (which marks the host as not busy,
+	 * disables the timeout counter, etc) will be called by us or by the
+	 * scsi_hosts[host].queuecommand() function needs to also call
+	 * the completion function for the high level driver.
+	 */
+	memcpy(sreq->sr_cmnd, cmnd, sizeof(sreq->sr_cmnd));
+	sreq->sr_bufflen = bufflen;
+	sreq->sr_buffer = buffer;
+	sreq->sr_allowed = retries;
+	sreq->sr_done = done;
+	sreq->sr_timeout_per_command = timeout;
+
+	if (sreq->sr_cmd_len == 0)
+		sreq->sr_cmd_len = COMMAND_SIZE(sreq->sr_cmnd[0]);
+
+	/*
+	 * At this point, we merely set up the command, stick it in the normal
+	 * request queue, and return.  Eventually that request will come to the
+	 * top of the list, and will be dispatched.
+	 */
+	scsi_insert_special_req(sreq, 0);
+}
+ 
+static void scsi_wait_done(struct scsi_cmnd *cmd)
+{
+	struct request *req = cmd->request;
+	struct request_queue *q = cmd->device->request_queue;
+	unsigned long flags;
+
+	req->rq_status = RQ_SCSI_DONE;	/* Busy, but indicate request done */
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_rq_tagged(req))
+		blk_queue_end_tag(q, req);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (req->waiting)
+		complete(req->waiting);
+}
+
+void scsi_wait_req(struct scsi_request *sreq, const void *cmnd, void *buffer,
+		   unsigned bufflen, int timeout, int retries)
+{
+	DECLARE_COMPLETION(wait);
+	
+	sreq->sr_request->waiting = &wait;
+	sreq->sr_request->rq_status = RQ_SCSI_BUSY;
+	scsi_do_req(sreq, cmnd, buffer, bufflen, scsi_wait_done,
+			timeout, retries);
+	generic_unplug_device(sreq->sr_device->request_queue);
+	wait_for_completion(&wait);
+	sreq->sr_request->waiting = NULL;
+
+	if (sreq->sr_command) {
+		scsi_put_command(sreq->sr_command);
+		sreq->sr_command = NULL;
+	}
+}
+
+/*
  * Function:    scsi_init_cmd_errh()
  *
  * Purpose:     Initialize cmd fields related to error handling.
@@ -203,7 +352,7 @@
  *		permutations grows as 2**N, and if too many more special cases
  *		get added, we start to get screwed.
  */
-void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
+static void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev, *sdev2;
 	struct Scsi_Host *shost;
@@ -791,7 +940,7 @@
 	return 0;
 }
 
-int scsi_prep_fn(struct request_queue *q, struct request *req)
+static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct Scsi_Device_Template *sdt;
 	struct scsi_device *sdev = q->queuedata;
@@ -902,7 +1051,7 @@
  *
  * Lock status: IO request lock assumed to be held when called.
  */
-void scsi_request_fn(request_queue_t *q)
+static void scsi_request_fn(request_queue_t *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
@@ -1045,6 +1194,62 @@
 		 */
 		spin_lock_irq(q->queue_lock);
 	}
+}
+
+u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
+{
+	if (shost->highmem_io) {
+		struct device *host_dev = scsi_get_device(shost);
+
+		if (PCI_DMA_BUS_IS_PHYS && host_dev && host_dev->dma_mask)
+			return *host_dev->dma_mask;
+
+		/*
+		 * Platforms with virtual-DMA translation
+ 		 * hardware have no practical limit.
+		 */
+		return BLK_BOUNCE_ANY;
+	} else if (shost->unchecked_isa_dma)
+		return BLK_BOUNCE_ISA;
+
+	return BLK_BOUNCE_HIGH;
+}
+
+request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost)
+{
+	request_queue_t *q;
+
+	q = kmalloc(sizeof(*q), GFP_ATOMIC);
+	if (!q)
+		return NULL;
+	memset(q, 0, sizeof(*q));
+
+	if (!shost->max_sectors) {
+		/*
+		 * Driver imposes no hard sector transfer limit.
+		 * start at machine infinity initially.
+		 */
+		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
+	}
+
+	blk_init_queue(q, scsi_request_fn, shost->host_lock);
+	blk_queue_prep_rq(q, scsi_prep_fn);
+
+	blk_queue_max_hw_segments(q, shost->sg_tablesize);
+	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
+	blk_queue_max_sectors(q, shost->max_sectors);
+	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
+
+	if (!shost->use_clustering)
+		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+	return q;
+}
+
+void scsi_free_queue(request_queue_t *q)
+{
+	blk_cleanup_queue(q);
+	kfree(q);
 }
 
 /*
--- 1.58/drivers/scsi/scsi_scan.c	Sun Feb  9 13:09:38 2003
+++ edited/drivers/scsi/scsi_scan.c	Tue Feb 11 09:56:25 2003
@@ -364,62 +364,6 @@
 		printk("\n");
 }
 
-u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
-{
-	if (shost->highmem_io) {
-		struct device *host_dev = scsi_get_device(shost);
-
-		if (PCI_DMA_BUS_IS_PHYS && host_dev && host_dev->dma_mask)
-			return *host_dev->dma_mask;
-
-		/*
-		 * Platforms with virtual-DMA translation
- 		 * hardware have no practical limit.
-		 */
-		return BLK_BOUNCE_ANY;
-	} else if (shost->unchecked_isa_dma)
-		return BLK_BOUNCE_ISA;
-
-	return BLK_BOUNCE_HIGH;
-}
-
-static request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost)
-{
-	request_queue_t *q;
-
-	q = kmalloc(sizeof(*q), GFP_ATOMIC);
-	if (!q)
-		return NULL;
-	memset(q, 0, sizeof(*q));
-
-	if (!shost->max_sectors) {
-		/*
-		 * Driver imposes no hard sector transfer limit.
-		 * start at machine infinity initially.
-		 */
-		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
-	}
-
-	blk_init_queue(q, scsi_request_fn, shost->host_lock);
-	blk_queue_prep_rq(q, scsi_prep_fn);
-
-	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
-	blk_queue_max_sectors(q, shost->max_sectors);
-	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
-
-	if (!shost->use_clustering)
-		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
-
-	return q;
-}
-
-static void scsi_free_queue(request_queue_t *q)
-{
-	blk_cleanup_queue(q);
-	kfree(q);
-}
-
 /**
  * scsi_alloc_sdev - allocate and setup a Scsi_Device
  *
