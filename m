From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Sun, 23 Apr 2017 12:28:29 -0500
Message-ID: <1492968509.2414.6.camel@HansenPartnership.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
         <1492725550.2642.9.camel@sandisk.com>
         <1492726397.21601.16.camel@HansenPartnership.com>
         <1492728740.2642.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54036 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1162392AbdDWR2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Apr 2017 13:28:39 -0400
In-Reply-To: <1492728740.2642.14.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, 2017-04-20 at 22:52 +0000, Bart Van Assche wrote:
> On Thu, 2017-04-20 at 15:13 -0700, James Bottomley wrote:
> > How is that possible?  Once the device goes into the CANCEL state,
> > it
> > no longer can be found by starget_for_each_device() because
> > scsi_device_get() returns NULL ...
> 
> scsi_target_block() is not serialized against __scsi_remove_device().
> I think
> the following sequence of events can cause a queue to be stopped for
> a device
> in the CANCEL state:
> (a) scsi_target_block() triggers a call to scsi_get_device().
> (b) __scsi_remove_device() is called from the context of another
> thread.
> (c) __scsi_remove_device() changes the device state into SDEV_CANCEL.
> (d) scsi_internal_device_block() calls blk_mq_stop_hw_queue().

OK, so the bug is that I didn't prevent the DEL->BLOCK transition which
allows us to go blocked after the new DEL if you were blocked before
when we reached cancel (corrected).  but looking at all of this, I
don't like the loose binding of block and queue stop, so this one makes
it more simplistic by deferring the queue stop until we try to execute
a blocked request.

In doing all of this, I folded in your start queue patch (I bet if we
fix this someone's going to want a backport to stable, so we shouldn't
make it difficult).

I also noticed the scsi_wait_for_queuecommand() should be event driven
(we're not supposed to do sleep driven condition checking) and there's
a spurious lock in scsi_request_fn_active() which means we could
eliminate the whole function.

However, the above is for another day.  This should work.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e5a2d590a104..a9ec35d9c91b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1250,6 +1250,12 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			break;
 		case SDEV_BLOCK:
 		case SDEV_CREATED_BLOCK:
+			/* q lock is held only in the non-mq case */
+			if (req->q->mq_ops)
+				blk_mq_stop_hw_queues(req->q);
+			else
+				blk_stop_queue(req->q);
+
 			ret = BLKPREP_DEFER;
 			break;
 		case SDEV_QUIESCE:
@@ -2611,7 +2617,6 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
-		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -2844,10 +2849,12 @@ static int scsi_request_fn_active(struct scsi_device *sdev)
  */
 static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
 {
-	WARN_ON_ONCE(sdev->host->use_blk_mq);
-
-	while (scsi_request_fn_active(sdev))
-		msleep(20);
+	if (sdev->request_queue->mq_ops) {
+		synchronize_rcu();
+	} else {
+		while (scsi_request_fn_active(sdev))
+			msleep(20);
+	}
 }
 
 /**
@@ -2953,8 +2960,6 @@ EXPORT_SYMBOL(scsi_target_resume);
 int
 scsi_internal_device_block(struct scsi_device *sdev, bool wait)
 {
-	struct request_queue *q = sdev->request_queue;
-	unsigned long flags;
 	int err = 0;
 
 	err = scsi_device_set_state(sdev, SDEV_BLOCK);
@@ -2970,23 +2975,27 @@ scsi_internal_device_block(struct scsi_device *sdev, bool wait)
 	 * block layer from calling the midlayer with this device's
 	 * request queue. 
 	 */
+	if (wait)
+		scsi_wait_for_queuecommand(sdev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_internal_device_block);
+
+void scsi_start_queue(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->request_queue;
+	unsigned long flags;
+
 	if (q->mq_ops) {
-		if (wait)
-			blk_mq_quiesce_queue(q);
-		else
-			blk_mq_stop_hw_queues(q);
+		blk_mq_start_stopped_hw_queues(q, false);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
-		blk_stop_queue(q);
+		blk_start_queue(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		if (wait)
-			scsi_wait_for_queuecommand(sdev);
 	}
-
-	return 0;
 }
-EXPORT_SYMBOL_GPL(scsi_internal_device_block);
- 
+
 /**
  * scsi_internal_device_unblock - resume a device after a block request
  * @sdev:	device to resume
@@ -3007,9 +3016,6 @@ int
 scsi_internal_device_unblock(struct scsi_device *sdev,
 			     enum scsi_device_state new_state)
 {
-	struct request_queue *q = sdev->request_queue; 
-	unsigned long flags;
-
 	/*
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
@@ -3027,13 +3033,7 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
-	if (q->mq_ops) {
-		blk_mq_start_stopped_hw_queues(q, false);
-	} else {
-		spin_lock_irqsave(q->queue_lock, flags);
-		blk_start_queue(q);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
+	scsi_start_queue(sdev);
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f11bd102d6d5..c7629e31a75b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -89,6 +89,7 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
+extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
 extern int scsi_init_queue(void);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07b1d47..5e826801c84c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1282,8 +1282,17 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		return;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-			return;
+		/*
+		 * If blocked, we go straight to DEL so any commands
+		 * issued during the driver shutdown (like sync cache)
+		 * are errored
+		 */
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0) {
+			if (scsi_device_set_state(sdev, SDEV_DEL) != 0)
+				return;
+
+			scsi_start_queue(sdev);
+		}
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
