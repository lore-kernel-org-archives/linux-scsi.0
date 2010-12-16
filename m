From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC] uas host lock removal conversion
Date: Wed, 15 Dec 2010 22:02:57 -0700
Message-ID: <20101216050257.GC1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47178 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0LPFC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 00:02:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I thought I'd take a crack at removing the host lock from uas.  I think
I can now switch to using GFP_NOIO (since interrupts are enabled by
scsi_request_fn()), and I have to use _irq spinlocks to protect the list
that is modified from interrupt context (same reason :-).

Comments?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5b6bbae..9e881cd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1443,7 +1443,7 @@ static void scsi_softirq_done(struct request *rq)
  *
  * Returns:     Nothing
  *
- * Lock status: IO request lock assumed to be held when called.
+ * Lock status: request queue lock held, interrupts disabled
  */
 static void scsi_request_fn(struct request_queue *q)
 {
@@ -1530,10 +1530,6 @@ static void scsi_request_fn(struct request_queue *q)
 		scsi_target(sdev)->target_busy++;
 		shost->host_busy++;
 
-		/*
-		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
-		 *		take the lock again.
-		 */
 		spin_unlock_irq(shost->host_lock);
 
 		/*
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 23f0dd9..a2cff4b 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -433,8 +433,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 	return 0;
 }
 
-static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
-					void (*done)(struct scsi_cmnd *))
+static int uas_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 {
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
@@ -453,8 +452,6 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		cmdinfo->stream = 1;
 	}
 
-	cmnd->scsi_done = done;
-
 	cmdinfo->state = ALLOC_STATUS_URB | SUBMIT_STATUS_URB |
 			ALLOC_CMD_URB | SUBMIT_CMD_URB;
 
@@ -475,24 +472,22 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		cmdinfo->stream = 0;
 	}
 
-	err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
+	err = uas_submit_urbs(cmnd, devinfo, GFP_NOIO);
 	if (err) {
 		/* If we did nothing, give up now */
 		if (cmdinfo->state & SUBMIT_STATUS_URB) {
 			usb_free_urb(cmdinfo->status_urb);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
-		spin_lock(&uas_work_lock);
+		spin_lock_irq(&uas_work_lock);
 		list_add_tail(&cmdinfo->list, &uas_work_list);
-		spin_unlock(&uas_work_lock);
+		spin_unlock_irq(&uas_work_lock);
 		schedule_work(&uas_work);
 	}
 
 	return 0;
 }
 
-static DEF_SCSI_QCMD(uas_queuecommand)
-
 static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 {
 	struct scsi_device *sdev = cmnd->device;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
