From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 6/7 add and use a per-scsi_device queue_lock
Date: Mon, 24 Mar 2003 18:03:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324180341.E15047@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.8/8.12.2) with ESMTP id h2P26DTr072820
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 21:06:13 -0500
Received: from localhost.localdomain (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay02.boulder.ibm.com (8.12.8/NCO/VER6.5) with ESMTP id h2P27EBS100216
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 19:07:15 -0700
Received: (from patman@localhost)
	by localhost.localdomain (8.11.2/8.11.6) id h2P23fM15158
	for linux-scsi@vger.kernel.org; Mon, 24 Mar 2003 18:03:41 -0800
Content-Disposition: inline
In-Reply-To: <20030324180325.D15047@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Mar 24, 2003 at 06:03:25PM -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add and use a per scsi_device queue_lock.

diff -purN -X /home/patman/dontdiff salloc_queue-25/drivers/scsi/hosts.c lksplit-25/drivers/scsi/hosts.c
--- salloc_queue-25/drivers/scsi/hosts.c	Mon Mar 24 12:14:28 2003
+++ lksplit-25/drivers/scsi/hosts.c	Mon Mar 24 12:15:10 2003
@@ -620,7 +620,6 @@ void scsi_host_busy_dec_and_test(struct 
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
-	sdev->device_busy--;
 	if (shost->in_recovery && shost->host_failed &&
 	    (shost->host_busy == shost->host_failed))
 	{
diff -purN -X /home/patman/dontdiff salloc_queue-25/drivers/scsi/scsi.c lksplit-25/drivers/scsi/scsi.c
--- salloc_queue-25/drivers/scsi/scsi.c	Mon Mar 24 11:57:13 2003
+++ lksplit-25/drivers/scsi/scsi.c	Mon Mar 24 12:15:10 2003
@@ -447,8 +447,6 @@ int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt)
 
 	host = SCpnt->device->host;
 
-	ASSERT_LOCK(host->host_lock, 0);
-
 	/* Assign a unique nonzero serial_number. */
 	if (++serial_number == 0)
 		serial_number = 1;
@@ -574,8 +572,6 @@ void scsi_init_cmd_from_req(Scsi_Cmnd * 
 {
 	struct Scsi_Host *host = SCpnt->device->host;
 
-	ASSERT_LOCK(host->host_lock, 0);
-
 	SCpnt->owner = SCSI_OWNER_MIDLEVEL;
 	SRpnt->sr_command = SCpnt;
 
@@ -819,12 +815,11 @@ void scsi_finish_command(Scsi_Cmnd * SCp
 	struct Scsi_Host *host;
 	Scsi_Device *device;
 	Scsi_Request * SRpnt;
+	unsigned int flags;
 
 	host = SCpnt->device->host;
 	device = SCpnt->device;
 
-	ASSERT_LOCK(host->host_lock, 0);
-
         /*
          * We need to protect the decrement, as otherwise a race condition
          * would exist.  Fiddling with SCpnt isn't a problem as the
@@ -833,6 +828,9 @@ void scsi_finish_command(Scsi_Cmnd * SCp
          * shared.
          */
 	scsi_host_busy_dec_and_test(host, device);
+	spin_lock_irqsave(SCpnt->device->request_queue->queue_lock, flags);
+	SCpnt->device->device_busy--;
+	spin_unlock_irqrestore(SCpnt->device->request_queue->queue_lock, flags);
 
         /*
          * Clear the flags which say that the device/host is no longer
diff -purN -X /home/patman/dontdiff salloc_queue-25/drivers/scsi/scsi.h lksplit-25/drivers/scsi/scsi.h
--- salloc_queue-25/drivers/scsi/scsi.h	Mon Mar 24 12:14:51 2003
+++ lksplit-25/drivers/scsi/scsi.h	Mon Mar 24 12:15:10 2003
@@ -418,7 +418,7 @@ extern void scsi_io_completion(Scsi_Cmnd
 			       int block_sectors);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd);
-extern request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost);
+extern request_queue_t *scsi_alloc_queue(struct scsi_device *sdev);
 extern void scsi_free_queue(request_queue_t *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
@@ -554,6 +554,7 @@ struct scsi_device {
 	struct Scsi_Host *host;
 	request_queue_t *request_queue;
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
+	spinlock_t sdev_lock;           /* also the request queue_lock */
 	spinlock_t list_lock;
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
diff -purN -X /home/patman/dontdiff salloc_queue-25/drivers/scsi/scsi_error.c lksplit-25/drivers/scsi/scsi_error.c
--- salloc_queue-25/drivers/scsi/scsi_error.c	Mon Mar 24 12:14:51 2003
+++ lksplit-25/drivers/scsi/scsi_error.c	Mon Mar 24 12:15:10 2003
@@ -431,8 +431,6 @@ static int scsi_send_eh_cmnd(struct scsi
 	unsigned long flags;
 	int rtn = SUCCESS;
 
-	ASSERT_LOCK(host->host_lock, 0);
-
 	/*
 	 * we will use a queued command if possible, otherwise we will
 	 * emulate the queuing and calling of completion function ourselves.
@@ -1405,8 +1403,6 @@ static void scsi_restart_operations(stru
 	struct scsi_device *sdev;
 	unsigned long flags;
 
-	ASSERT_LOCK(shost->host_lock, 0);
-
 	/*
 	 * If the door was locked, we need to insert a door lock request
 	 * onto the head of the SCSI request queue for the device.  There
@@ -1434,18 +1430,11 @@ static void scsi_restart_operations(stru
 	 * now that error recovery is done, we will need to ensure that these
 	 * requests are started.
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		if ((shost->can_queue > 0 &&
-		     (shost->host_busy >= shost->can_queue))
-		    || (shost->host_blocked)
-		    || (shost->host_self_blocked)) {
-			break;
-		}
-
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 		__blk_run_queue(sdev->request_queue);
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**
diff -purN -X /home/patman/dontdiff salloc_queue-25/drivers/scsi/scsi_lib.c lksplit-25/drivers/scsi/scsi_lib.c
--- salloc_queue-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:15:01 2003
+++ lksplit-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:15:10 2003
@@ -92,6 +92,7 @@ int scsi_queue_insert(struct scsi_cmnd *
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
+	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1,
 		 printk("Inserting command %p into mlqueue\n", cmd));
@@ -130,6 +131,9 @@ int scsi_queue_insert(struct scsi_cmnd *
 	 * Decrement the counters, since these commands are no longer
 	 * active on the host/device.
 	 */
+	spin_lock_irqsave(device->request_queue->queue_lock, flags);
+	device->device_busy--;
+	spin_unlock_irqrestore(device->request_queue->queue_lock, flags);
 	scsi_host_busy_dec_and_test(host, device);
 
 	/*
@@ -343,7 +347,7 @@ static int scsi_single_lun_check(struct 
  * outstanding for current_sdev, call __blk_run_queue for the next
  * scsi_device on the same target that has requests.
  *
- * Called with queue_lock held.
+ * Called with *no* scsi locks held.
  */
 static void scsi_single_lun_run(struct scsi_device *current_sdev,
 				 struct request_queue *q)
@@ -407,9 +411,6 @@ void scsi_queue_next_request(request_que
 	struct Scsi_Host *shost;
 	unsigned long flags;
 
-	ASSERT_LOCK(q->queue_lock, 0);
-
-	spin_lock_irqsave(q->queue_lock, flags);
 	if (cmd != NULL) {
 
 		/*
@@ -418,6 +419,7 @@ void scsi_queue_next_request(request_que
 		 * in which case we need to request the blocks that come after
 		 * the bad sector.
 		 */
+		spin_lock_irqsave(q->queue_lock, flags);
 		cmd->request->special = cmd;
 		if (blk_rq_tagged(cmd->request))
 			blk_queue_end_tag(q, cmd->request);
@@ -430,6 +432,7 @@ void scsi_queue_next_request(request_que
 		cmd->request->flags |= REQ_SPECIAL;
 		cmd->request->flags &= ~REQ_DONTPREP;
 		__elv_add_request(q, cmd->request, 0, 0);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 
 	sdev = q->queuedata;
@@ -438,6 +441,7 @@ void scsi_queue_next_request(request_que
 		scsi_single_lun_run(sdev, q);
 
 	shost = sdev->host;
+	spin_lock_irqsave(shost->host_lock, flags);
 	while (!list_empty(&shost->starved_list) &&
 	       !shost->host_blocked && !shost->host_self_blocked &&
 		!((shost->can_queue > 0) &&
@@ -447,15 +451,26 @@ void scsi_queue_next_request(request_que
 		 * starved queues, call __blk_run_queue. scsi_request_fn
 		 * drops the queue_lock and can add us back to the
 		 * starved_list.
+		 *
+		 * host_lock protects the starved_list and starved_entry.
+		 * scsi_request_fn must get the host_lock before checking
+		 * or modifying starved_list or starved_entry.
 		 */
 		sdev2 = list_entry(shost->starved_list.next,
 					  struct scsi_device, starved_entry);
 		list_del_init(&sdev2->starved_entry);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		spin_lock_irqsave(sdev2->request_queue->queue_lock, flags);
 		__blk_run_queue(sdev2->request_queue);
+		spin_unlock_irqrestore(sdev2->request_queue->queue_lock, flags);
+
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	spin_lock_irqsave(q->queue_lock, flags);
 	__blk_run_queue(q);
-
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -489,8 +504,6 @@ static struct scsi_cmnd *scsi_end_reques
 	struct request *req = cmd->request;
 	unsigned long flags;
 
-	ASSERT_LOCK(q->queue_lock, 0);
-
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
@@ -588,8 +601,6 @@ static void scsi_release_buffers(struct 
 {
 	struct request *req = cmd->request;
 
-	ASSERT_LOCK(cmd->device->host->host_lock, 0);
-
 	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
 	 */
@@ -670,8 +681,6 @@ void scsi_io_completion(struct scsi_cmnd
 	 *	would be used if we just wanted to retry, for example.
 	 *
 	 */
-	ASSERT_LOCK(q->queue_lock, 0);
-
 	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
 	 * For the case of a READ, we need to copy the data out of the
@@ -1075,7 +1084,7 @@ static inline int scsi_check_sdev(struct
 /*
  * scsi_check_shost: if we can send requests to shost, return 0 else return 1.
  *
- * Called with the queue_lock held.
+ * Called with queue_lock and host_lock held.
  */
 static inline int scsi_check_shost(struct request_queue *q,
 				   struct Scsi_Host *shost,
@@ -1132,8 +1141,7 @@ static void scsi_request_fn(request_queu
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_cmnd *cmd;
 	struct request *req;
-
-	ASSERT_LOCK(q->queue_lock, 1);
+	unsigned int flags;
 
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
@@ -1141,7 +1149,7 @@ static void scsi_request_fn(request_queu
 	 */
 	for (;;) {
 		if (blk_queue_plugged(q))
-			break;
+			goto completed;
 
 		/*
 		 * get next queueable request.  We do this early to make sure
@@ -1152,28 +1160,29 @@ static void scsi_request_fn(request_queu
 		req = elv_next_request(q);
 
 		if (scsi_check_sdev(q, sdev))
-			break;
+			goto completed;
 
+		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_check_shost(q, shost, sdev))
-			break;
+			goto after_host_lock;
 
 		if (sdev->single_lun && scsi_single_lun_check(sdev))
-			break;
+			goto after_host_lock;
 
 		/*
 		 * If we couldn't find a request that could be queued, then we
 		 * can also quit.
 		 */
 		if (blk_queue_empty(q))
-			break;
+			goto after_host_lock;
 
 		if (!req) {
 			/* If the device is busy, a returning I/O
 			 * will restart the queue.  Otherwise, we have
 			 * to plug the queue */
-			if (sdev->device_busy == 0)
+			if (sdev->device_busy == 1)
 				blk_plug_device(q);
-			break;
+			goto after_host_lock;
 		}
 
 		cmd = req->special;
@@ -1195,11 +1204,9 @@ static void scsi_request_fn(request_queu
 		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
 			blkdev_dequeue_request(req);
 	
-		/*
-		 * Now bump the usage count for both the host and the
-		 * device.
-		 */
 		shost->host_busy++;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
 		sdev->device_busy++;
 		spin_unlock_irq(q->queue_lock);
 
@@ -1220,6 +1227,11 @@ static void scsi_request_fn(request_queu
 		 */
 		spin_lock_irq(q->queue_lock);
 	}
+completed:
+	return;
+
+after_host_lock:
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
@@ -1241,15 +1253,20 @@ u64 scsi_calculate_bounce_limit(struct S
 	return BLK_BOUNCE_HIGH;
 }
 
-request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost)
+request_queue_t *scsi_alloc_queue(struct scsi_device *sdev)
 {
 	request_queue_t *q;
+	struct Scsi_Host *shost;
 
 	q = kmalloc(sizeof(*q), GFP_ATOMIC);
 	if (!q)
 		return NULL;
 	memset(q, 0, sizeof(*q));
 
+	/*
+	 * XXX move host code to scsi_register
+	 */
+	shost = sdev->host;
 	if (!shost->max_sectors) {
 		/*
 		 * Driver imposes no hard sector transfer limit.
@@ -1258,7 +1275,7 @@ request_queue_t *scsi_alloc_queue(struct
 		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
 	}
 
-	blk_init_queue(q, scsi_request_fn, shost->host_lock);
+	blk_init_queue(q, scsi_request_fn, &sdev->sdev_lock);
 	blk_queue_prep_rq(q, scsi_prep_fn);
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
diff -purN -X /home/patman/dontdiff salloc_queue-25/drivers/scsi/scsi_scan.c lksplit-25/drivers/scsi/scsi_scan.c
--- salloc_queue-25/drivers/scsi/scsi_scan.c	Mon Mar 24 12:15:05 2003
+++ lksplit-25/drivers/scsi/scsi_scan.c	Mon Mar 24 12:15:10 2003
@@ -415,7 +415,8 @@ static struct scsi_device *scsi_alloc_sd
 	 */
 	sdev->borken = 1;
 
-	sdev->request_queue = scsi_alloc_queue(shost);
+	spin_lock_init(&sdev->sdev_lock);
+	sdev->request_queue = scsi_alloc_queue(sdev);
 	if (!sdev->request_queue)
 		goto out_free_dev;
 
