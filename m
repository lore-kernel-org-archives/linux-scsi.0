From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [patch] 1/5 scsi-locking-2.5 single_lun store scsi_device pointer
Date: Wed, 9 Apr 2003 16:46:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409164612.A23701@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:15498 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263938AbTDIXiT (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 19:38:19 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Change single_lun code to use a struct scsi_device *, so that we do not
need an sdev (or queue_lock) while checking if a single_lun target is in
use by a particular scsi_device.

diff -purN -X /home/patman/dontdiff sl-base-2.5/drivers/scsi/scsi.h 01_slun_mod/drivers/scsi/scsi.h
--- sl-base-2.5/drivers/scsi/scsi.h	Wed Apr  9 11:34:36 2003
+++ 01_slun_mod/drivers/scsi/scsi.h	Wed Apr  9 12:39:15 2003
@@ -532,10 +532,11 @@ extern int scsi_dev_info_list_add_str(ch
 
 /*
  * scsi_target: representation of a scsi target, for now, this is only
- * used for single_lun devices.
+ * used for single_lun devices. If no one has active IO to the target,
+ * starget_sdev_user is NULL, else it points to the active sdev.
  */
 struct scsi_target {
-	unsigned int starget_busy;
+	struct scsi_device *starget_sdev_user;
 	unsigned int starget_refcnt;
 };
 
diff -purN -X /home/patman/dontdiff sl-base-2.5/drivers/scsi/scsi_lib.c 01_slun_mod/drivers/scsi/scsi_lib.c
--- sl-base-2.5/drivers/scsi/scsi_lib.c	Wed Apr  9 11:34:37 2003
+++ 01_slun_mod/drivers/scsi/scsi_lib.c	Wed Apr  9 12:39:15 2003
@@ -327,9 +327,9 @@ void scsi_setup_cmd_retry(struct scsi_cm
 }
 
 /*
- * Called for single_lun devices on IO completion. Clear starget_busy, and
- * Call __blk_run_queue for all the scsi_devices on the target - including
- * current_sdev first.
+ * Called for single_lun devices on IO completion. Clear starget_sdev_user,
+ * and call __blk_run_queue for all the scsi_devices on the target -
+ * including current_sdev first.
  *
  * Called with *no* scsi locks held.
  */
@@ -338,19 +338,33 @@ static void scsi_single_lun_run(struct s
 	struct scsi_device *sdev;
 	unsigned int flags, flags2;
 
-	spin_lock_irqsave(current_sdev->request_queue->queue_lock, flags2);
 	spin_lock_irqsave(current_sdev->host->host_lock, flags);
-	WARN_ON(!current_sdev->sdev_target->starget_busy);
-	if (current_sdev->device_busy == 0)
-		current_sdev->sdev_target->starget_busy = 0;
+	WARN_ON(!current_sdev->sdev_target->starget_sdev_user);
+	current_sdev->sdev_target->starget_sdev_user = NULL;
 	spin_unlock_irqrestore(current_sdev->host->host_lock, flags);
 
 	/*
 	 * Call __blk_run_queue for all LUNs on the target, starting with
-	 * current_sdev.
+	 * current_sdev. We race with others (to set starget_sdev_user),
+	 * but in most cases, we will be first. Ideally, each LU on the
+	 * target would get some limited time or requests on the target.
 	 */
+	spin_lock_irqsave(current_sdev->request_queue->queue_lock, flags2);
 	__blk_run_queue(current_sdev->request_queue);
 	spin_unlock_irqrestore(current_sdev->request_queue->queue_lock, flags2);
+
+	spin_lock_irqsave(current_sdev->host->host_lock, flags);
+	if (current_sdev->sdev_target->starget_sdev_user) {
+		/*
+		 * After unlock, this races with anyone clearing
+		 * starget_sdev_user, but we (should) always enter this
+		 * function again, avoiding any problems.
+		 */
+		spin_unlock_irqrestore(current_sdev->host->host_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(current_sdev->host->host_lock, flags);
+
 	list_for_each_entry(sdev, &current_sdev->same_target_siblings,
 			    same_target_siblings) {
 		spin_lock_irqsave(sdev->request_queue->queue_lock, flags2);
@@ -1158,8 +1172,8 @@ static void scsi_request_fn(request_queu
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto after_host_lock;
 
-		if (sdev->single_lun && !sdev->device_busy &&
-		    sdev->sdev_target->starget_busy)
+		if (sdev->single_lun && sdev->sdev_target->starget_sdev_user &&
+		    (sdev->sdev_target->starget_sdev_user != sdev))
 			goto after_host_lock;
 
 		/*
@@ -1198,7 +1212,7 @@ static void scsi_request_fn(request_queu
 			blkdev_dequeue_request(req);
 	
 		if (sdev->single_lun)
-			sdev->sdev_target->starget_busy = 1;
+			sdev->sdev_target->starget_sdev_user = sdev;
 
 		shost->host_busy++;
 		spin_unlock_irqrestore(shost->host_lock, flags);
diff -purN -X /home/patman/dontdiff sl-base-2.5/drivers/scsi/scsi_scan.c 01_slun_mod/drivers/scsi/scsi_scan.c
--- sl-base-2.5/drivers/scsi/scsi_scan.c	Wed Apr  9 11:34:37 2003
+++ 01_slun_mod/drivers/scsi/scsi_scan.c	Wed Apr  9 12:39:15 2003
@@ -1283,7 +1283,7 @@ static int scsi_add_lun(Scsi_Device *sde
 				return SCSI_SCAN_NO_RESPONSE;
 			}
 			starget->starget_refcnt = 0;
-			starget->starget_busy = 0;
+			starget->starget_sdev_user = NULL;
 		}
 		starget->starget_refcnt++;
 		sdev->sdev_target = starget;
