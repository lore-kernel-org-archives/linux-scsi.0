From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 3/7 consolidate single_lun code
Date: Mon, 24 Mar 2003 18:02:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324180247.B15047@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e35.co.us.ibm.com (8.12.8/8.12.2) with ESMTP id h2P26LgJ072818
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 21:06:21 -0500
Received: from localhost.localdomain (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.8/NCO/VER6.5) with ESMTP id h2P26KVR125776
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 19:06:20 -0700
Received: (from patman@localhost)
	by localhost.localdomain (8.11.2/8.11.6) id h2P22lq15133
	for linux-scsi@vger.kernel.org; Mon, 24 Mar 2003 18:02:47 -0800
Content-Disposition: inline
In-Reply-To: <20030324180227.A15047@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Mar 24, 2003 at 06:02:27PM -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Consolidate scsi single_lun code.

diff -purN -X /home/patman/dontdiff put_cmd-25/drivers/scsi/scsi_lib.c lun-single-25/drivers/scsi/scsi_lib.c
--- put_cmd-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:51 2003
+++ lun-single-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:55 2003
@@ -323,6 +323,49 @@ void scsi_setup_cmd_retry(struct scsi_cm
 }
 
 /*
+ * Called for single_lun devices. The target associated with current_sdev can
+ * only handle one active command at a time. Scan through all of the luns
+ * on the same target as current_sdev, return 1 if any are active.
+ */
+static int scsi_single_lun_check(struct scsi_device *current_sdev)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &current_sdev->same_target_siblings,
+			    same_target_siblings)
+		if (sdev->device_busy)
+			return 1;
+	return 0;
+}
+
+/*
+ * Called for single_lun devices on IO completion. If no requests
+ * outstanding for current_sdev, call __blk_run_queue for the next
+ * scsi_device on the same target that has requests.
+ *
+ * Called with queue_lock held.
+ */
+static void scsi_single_lun_run(struct scsi_device *current_sdev,
+				 struct request_queue *q)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
+
+	shost = current_sdev->host;
+	if (blk_queue_empty(q) && current_sdev->device_busy == 0 &&
+	    !shost->host_blocked && !shost->host_self_blocked &&
+	    !((shost->can_queue > 0) &&
+	      (shost->host_busy >= shost->can_queue)))
+		list_for_each_entry(sdev, &current_sdev->same_target_siblings,
+				    same_target_siblings)
+			if (!sdev->device_blocked &&
+			    !blk_queue_empty(sdev->request_queue)) {
+				__blk_run_queue(sdev->request_queue);
+				break;
+			}
+}
+
+/*
  * Function:    scsi_queue_next_request()
  *
  * Purpose:     Handle post-processing of completed commands.
@@ -390,29 +433,11 @@ void scsi_queue_next_request(request_que
 	}
 
 	sdev = q->queuedata;
-	shost = sdev->host;
 
-	/*
-	 * If this is a single-lun device, and we are currently finished
-	 * with this device, then see if we need to get another device
-	 * started.  FIXME(eric) - if this function gets too cluttered
-	 * with special case code, then spin off separate versions and
-	 * use function pointers to pick the right one.
-	 */
-	if (sdev->single_lun && blk_queue_empty(q) && sdev->device_busy ==0 &&
-			!shost->host_blocked && !shost->host_self_blocked &&
-			!((shost->can_queue > 0) && (shost->host_busy >=
-				       		     shost->can_queue))) {
-		list_for_each_entry(sdev2, &sdev->same_target_siblings,
-			       same_target_siblings) {
-			if (!sdev2->device_blocked &&
-			    !blk_queue_empty(sdev2->request_queue)) {
-				__blk_run_queue(sdev2->request_queue);
-				break;
-			}
-		}
-	}
+	if (sdev->single_lun)
+		scsi_single_lun_run(sdev, q);
 
+	shost = sdev->host;
 	while (!list_empty(&shost->starved_list) &&
 	       !shost->host_blocked && !shost->host_self_blocked &&
 		!((shost->can_queue > 0) &&
@@ -917,22 +942,6 @@ static int scsi_init_io(struct scsi_cmnd
 	return BLKPREP_KILL;
 }
 
-/*
- * The target associated with myself can only handle one active command at
- * a time. Scan through all of the luns on the same target as myself,
- * return 1 if any are active.
- */
-static int check_all_luns(struct scsi_device *myself)
-{
-	struct scsi_device *sdev;
-
-	list_for_each_entry(sdev, &myself->same_target_siblings,
-			    same_target_siblings)
-		if (sdev->device_busy)
-			return 1;
-	return 0;
-}
-
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct Scsi_Device_Template *sdt;
@@ -1077,9 +1086,6 @@ static void scsi_request_fn(request_queu
 		if (sdev->device_busy >= sdev->queue_depth)
 			break;
 
-		if (sdev->single_lun && check_all_luns(sdev))
-			break;
-
 		if (shost->host_busy == 0 && shost->host_blocked) {
 			/* unblock after host_blocked iterates to zero */
 			if (--shost->host_blocked == 0) {
@@ -1120,6 +1126,9 @@ static void scsi_request_fn(request_queu
 			break;
 		}
 
+		if (sdev->single_lun && scsi_single_lun_check(sdev))
+			break;
+
 		/*
 		 * If we couldn't find a request that could be queued, then we
 		 * can also quit.
