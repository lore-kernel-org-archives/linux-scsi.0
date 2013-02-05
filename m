From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v8 01/10] Fix race between starved list processing and device
 removal
Date: Tue, 05 Feb 2013 13:45:45 +0100
Message-ID: <5110FEF9.9010903@acm.org>
References: <5110FE98.8030209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:41694 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3BEMpr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 07:45:47 -0500
In-Reply-To: <5110FE98.8030209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

scsi_run_queue() examines all SCSI devices that are present on
the starved list. Since scsi_run_queue() unlocks the SCSI host
lock before running a queue a SCSI device can get removed after
it has been removed from the starved list and before its queue
is run. Protect against that race condition by increasing the
sdev refcount before running the sdev queue. Also, remove a
SCSI device from the starved list before __scsi_remove_device()
decreases the sdev refcount such that the get_device() call
added in scsi_run_queue() is guaranteed to succeed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reported-and-tested-by: Chanho Min <chanho.min@lge.com>
Reference: http://lkml.org/lkml/2012/8/2/96
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c   |   16 +++++++++++-----
 drivers/scsi/scsi_sysfs.c |   14 +++++++++++++-
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f1bf5af..5c67339 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -452,11 +452,17 @@ static void scsi_run_queue(struct request_queue *q)
 			continue;
 		}
 
-		spin_unlock(shost->host_lock);
-		spin_lock(sdev->request_queue->queue_lock);
-		__blk_run_queue(sdev->request_queue);
-		spin_unlock(sdev->request_queue->queue_lock);
-		spin_lock(shost->host_lock);
+		/*
+		 * Obtain a reference before unlocking the host_lock such that
+		 * the sdev can't disappear before blk_run_queue() is invoked.
+		 */
+		get_device(&sdev->sdev_gendev);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		blk_run_queue(sdev->request_queue);
+		put_device(&sdev->sdev_gendev);
+
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..34f1b39 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -345,7 +345,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
-	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
@@ -953,6 +952,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
 
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
@@ -974,6 +975,17 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
+	/*
+	 * Remove a SCSI device from the starved list after blk_cleanup_queue()
+	 * finished such that scsi_request_fn() can't add it back to that list.
+	 * Also remove an sdev from the starved list before invoking
+	 * put_device() such that get_device() is guaranteed to succeed for an
+	 * sdev present on the starved list.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&sdev->starved_entry);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
1.7.10.4

