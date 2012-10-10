From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/4] Fix race between starved list processing and device removal
Date: Wed, 10 Oct 2012 17:10:35 +0200
Message-ID: <50758FEB.9090602@acm.org>
References: <50758EBE.7050202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:39388 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab2JJPKg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2012 11:10:36 -0400
In-Reply-To: <50758EBE.7050202@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Avoid that the sdev reference count can drop to zero before
the queue is run by scsi_run_queue(). Also avoid that the sdev
reference count can drop to zero in the same function by invoking
__blk_run_queue().

Reported-and-tested-by: Chanho Min <chanho.min@lge.com>
Reference: http://lkml.org/lkml/2012/8/2/96
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c   |    5 +++++
 drivers/scsi/scsi_sysfs.c |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0e15374..fb57e68 100644
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

