From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6/7] Fix race between starved list processing and device removal
Date: Fri, 26 Oct 2012 14:05:01 +0200
Message-ID: <508A7C6D.8070002@acm.org>
References: <508A7B63.60608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37594 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab2JZMFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:05:02 -0400
In-Reply-To: <508A7B63.60608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

The SCSI core maintains a "starved list" per SCSI host. This is a
list of devices for which one or more requests have been queued
but that have not yet been passed to the SCSI LLD. The function
scsi_run_queue() examines all SCSI devices on the starved list.
Since scsi_remove_device() can be invoked concurrently with
scsi_run_queue() it is important to avoid that a SCSI device is
accessed by that function after it has been freed. Avoid that the
sdev reference count can drop to zero before the queue is run by
scsi_run_queue() by inserting a get_device() / put_device() pair
in that function. Move the code for removing a device from the
starved list from scsi_device_dev_release_usercontext() to
__scsi_remove_device() such that it is guaranteed that the newly
added get_device() call succeeds.

Reported-and-tested-by: Chanho Min <chanho.min@lge.com>
Reference: http://lkml.org/lkml/2012/8/2/96
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c   |    5 +++++
 drivers/scsi/scsi_sysfs.c |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f29a1a9..c5d4ec2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -452,10 +452,15 @@ static void scsi_run_queue(struct request_queue *q)
 			continue;
 		}
 
+		get_device(&sdev->sdev_gendev);
 		spin_unlock(shost->host_lock);
+
 		spin_lock(sdev->request_queue->queue_lock);
 		__blk_run_queue(sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
+
+		put_device(&sdev->sdev_gendev);
+
 		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ce5224c..2661a957 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -348,7 +348,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
-	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
@@ -956,6 +955,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
 
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
@@ -977,6 +978,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&sdev->starved_entry);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
1.7.10.4

