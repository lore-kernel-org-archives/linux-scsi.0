From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 7/7 fix single_lun code for per-scsi_device queue_lock
Date: Mon, 24 Mar 2003 18:04:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324180404.F15047@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com> <20030324180341.E15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.8/8.12.2) with ESMTP id h2P27cPh048058
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 21:07:38 -0500
Received: from localhost.localdomain (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay02.boulder.ibm.com (8.12.8/NCO/VER6.5) with ESMTP id h2P27bBS151474
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 19:07:37 -0700
Received: (from patman@localhost)
	by localhost.localdomain (8.11.2/8.11.6) id h2P244l15188
	for linux-scsi@vger.kernel.org; Mon, 24 Mar 2003 18:04:04 -0800
Content-Disposition: inline
In-Reply-To: <20030324180341.E15047@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Mar 24, 2003 at 06:03:41PM -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix single_lun code for per-scsi_device queue_lock

diff -purN -X /home/patman/dontdiff lksplit-25/drivers/scsi/scsi.h sl_lksplit-25/drivers/scsi/scsi.h
--- lksplit-25/drivers/scsi/scsi.h	Mon Mar 24 12:15:10 2003
+++ sl_lksplit-25/drivers/scsi/scsi.h	Mon Mar 24 12:15:26 2003
@@ -531,6 +531,15 @@ extern struct list_head scsi_dev_info_li
 extern int scsi_dev_info_list_add_str(char *);
 
 /*
+ * scsi_target: representation of a scsi target, for now, this is only
+ * used for single_lun devices.
+ */
+struct scsi_target {
+	unsigned int starget_busy;
+	unsigned int starget_refcnt;
+};
+
+/*
  *  The scsi_device struct contains what we know about each given scsi
  *  device.
  *
@@ -588,6 +597,7 @@ struct scsi_device {
 	unsigned char current_tag;	/* current tag */
 //	unsigned char sync_min_period;	/* Not less than this period */
 //	unsigned char sync_max_offset;	/* Not greater than this offset */
+	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
 	unsigned online:1;
 	unsigned writeable:1;
diff -purN -X /home/patman/dontdiff lksplit-25/drivers/scsi/scsi_lib.c sl_lksplit-25/drivers/scsi/scsi_lib.c
--- lksplit-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:15:10 2003
+++ sl_lksplit-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:15:26 2003
@@ -327,46 +327,36 @@ void scsi_setup_cmd_retry(struct scsi_cm
 }
 
 /*
- * Called for single_lun devices. The target associated with current_sdev can
- * only handle one active command at a time. Scan through all of the luns
- * on the same target as current_sdev, return 1 if any are active.
- */
-static int scsi_single_lun_check(struct scsi_device *current_sdev)
-{
-	struct scsi_device *sdev;
-
-	list_for_each_entry(sdev, &current_sdev->same_target_siblings,
-			    same_target_siblings)
-		if (sdev->device_busy)
-			return 1;
-	return 0;
-}
-
-/*
- * Called for single_lun devices on IO completion. If no requests
- * outstanding for current_sdev, call __blk_run_queue for the next
- * scsi_device on the same target that has requests.
+ * Called for single_lun devices on IO completion. Clear starget_busy, and
+ * Call __blk_run_queue for all the scsi_devices on the target - including
+ * current_sdev first.
  *
  * Called with *no* scsi locks held.
  */
-static void scsi_single_lun_run(struct scsi_device *current_sdev,
-				 struct request_queue *q)
+static void scsi_single_lun_run(struct scsi_device *current_sdev)
 {
 	struct scsi_device *sdev;
-	struct Scsi_Host *shost;
+	unsigned int flags, flags2;
 
-	shost = current_sdev->host;
-	if (blk_queue_empty(q) && current_sdev->device_busy == 0 &&
-	    !shost->host_blocked && !shost->host_self_blocked &&
-	    !((shost->can_queue > 0) &&
-	      (shost->host_busy >= shost->can_queue)))
-		list_for_each_entry(sdev, &current_sdev->same_target_siblings,
-				    same_target_siblings)
-			if (!sdev->device_blocked &&
-			    !blk_queue_empty(sdev->request_queue)) {
-				__blk_run_queue(sdev->request_queue);
-				break;
-			}
+	spin_lock_irqsave(current_sdev->request_queue->queue_lock, flags2);
+	spin_lock_irqsave(current_sdev->host->host_lock, flags);
+	WARN_ON(!current_sdev->sdev_target->starget_busy);
+	if (current_sdev->device_busy == 0)
+		current_sdev->sdev_target->starget_busy = 0;
+	spin_unlock_irqrestore(current_sdev->host->host_lock, flags);
+
+	/*
+	 * Call __blk_run_queue for all LUNs on the target, starting with
+	 * current_sdev.
+	 */
+	__blk_run_queue(current_sdev->request_queue);
+	spin_unlock_irqrestore(current_sdev->request_queue->queue_lock, flags2);
+	list_for_each_entry(sdev, &current_sdev->same_target_siblings,
+			    same_target_siblings) {
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags2);
+		__blk_run_queue(sdev->request_queue);
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags2);
+	}
 }
 
 /*
@@ -438,7 +428,7 @@ void scsi_queue_next_request(request_que
 	sdev = q->queuedata;
 
 	if (sdev->single_lun)
-		scsi_single_lun_run(sdev, q);
+		scsi_single_lun_run(sdev);
 
 	shost = sdev->host;
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -1166,7 +1156,8 @@ static void scsi_request_fn(request_queu
 		if (scsi_check_shost(q, shost, sdev))
 			goto after_host_lock;
 
-		if (sdev->single_lun && scsi_single_lun_check(sdev))
+		if (sdev->single_lun && !sdev->device_busy &&
+		    sdev->sdev_target->starget_busy)
 			goto after_host_lock;
 
 		/*
@@ -1204,6 +1195,9 @@ static void scsi_request_fn(request_queu
 		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
 			blkdev_dequeue_request(req);
 	
+		if (sdev->single_lun)
+			sdev->sdev_target->starget_busy = 1;
+
 		shost->host_busy++;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
diff -purN -X /home/patman/dontdiff lksplit-25/drivers/scsi/scsi_scan.c sl_lksplit-25/drivers/scsi/scsi_scan.c
--- lksplit-25/drivers/scsi/scsi_scan.c	Mon Mar 24 12:15:10 2003
+++ sl_lksplit-25/drivers/scsi/scsi_scan.c	Mon Mar 24 12:15:26 2003
@@ -478,6 +478,8 @@ out:
  **/
 static void scsi_free_sdev(struct scsi_device *sdev)
 {
+	unsigned int flags;
+
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 
@@ -487,6 +489,14 @@ static void scsi_free_sdev(struct scsi_d
 		sdev->host->hostt->slave_destroy(sdev);
 	if (sdev->inquiry)
 		kfree(sdev->inquiry);
+	if (sdev->single_lun) {
+		spin_lock_irqsave(sdev->host->host_lock, flags);
+		sdev->sdev_target->starget_refcnt--;
+		if (sdev->sdev_target->starget_refcnt == 0)
+			kfree(sdev->sdev_target);
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	}
+
 	kfree(sdev);
 }
 
@@ -1122,6 +1132,10 @@ static void scsi_probe_lun(Scsi_Request 
 static int scsi_add_lun(Scsi_Device *sdev, Scsi_Request *sreq,
 		char *inq_result, int *bflags)
 {
+	struct scsi_device *sdev_sibling;
+	struct scsi_target *starget;
+	unsigned int flags;
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -1243,10 +1257,38 @@ static int scsi_add_lun(Scsi_Device *sde
 
 	/*
 	 * If we need to allow I/O to only one of the luns attached to
-	 * this target id at a time, then we set this flag.
+	 * this target id at a time set single_lun, and allocate or modify
+	 * sdev_target.
 	 */
-	if (*bflags & BLIST_SINGLELUN)
+	if (*bflags & BLIST_SINGLELUN) {
 		sdev->single_lun = 1;
+		spin_lock_irqsave(sdev->host->host_lock, flags);
+		starget = NULL;
+		/*
+		 * Search for an existing target for this sdev.
+		 */
+		list_for_each_entry(sdev_sibling, &sdev->same_target_siblings,
+				    same_target_siblings) {
+			if (sdev_sibling->sdev_target != NULL) {
+				starget = sdev_sibling->sdev_target;
+				break;
+			}
+		}
+		if (!starget) {
+			starget = kmalloc(sizeof(*starget), GFP_KERNEL);
+			if (!starget) {
+				printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+				spin_unlock_irqrestore(sdev->host->host_lock,
+						       flags);
+				return SCSI_SCAN_NO_RESPONSE;
+			}
+			starget->starget_refcnt = 0;
+			starget->starget_busy = 0;
+		}
+		starget->starget_refcnt++;
+		sdev->sdev_target = starget;
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	}
 
 	/* if the device needs this changing, it may do so in the detect
 	 * function */
