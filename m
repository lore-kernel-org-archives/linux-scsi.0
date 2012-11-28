From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 12/13] Avoid that scsi_device_set_state() triggers a race
Date: Wed, 28 Nov 2012 13:53:24 +0100
Message-ID: <50B60944.2080605@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:57141 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2K1MxZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:53:25 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Make concurrent invocations of scsi_device_set_state() safe.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c   |   24 ++++++++++++------------
 drivers/scsi/scsi_sysfs.c |    9 ++++++++-
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cfc420b..f3d6e0d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2072,7 +2072,9 @@ EXPORT_SYMBOL(scsi_test_unit_ready);
  *	@state:	state to change to.
  *
  *	Returns zero if unsuccessful or an error if the requested 
- *	transition is illegal.
+ *	transition is illegal. It is the responsibility of the caller to make
+ *      sure that a call of this function does not race with other code that
+ *      accesses the device state, e.g. by holding the host lock.
  */
 int
 scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
@@ -2433,21 +2435,19 @@ scsi_internal_device_block(struct scsi_device *sdev)
 	unsigned long flags;
 	int err = 0;
 
+	spin_lock_irqsave(q->queue_lock, flags);
 	err = scsi_device_set_state(sdev, SDEV_BLOCK);
-	if (err) {
+	if (err)
 		err = scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
 
-		if (err)
-			return err;
+	if (err == 0) {
+		/*
+		 * The device has transitioned to SDEV_BLOCK.  Stop the
+		 * block layer from calling the midlayer with this device's
+		 * request queue.
+		 */
+		blk_stop_queue(q);
 	}
-
-	/* 
-	 * The device has transitioned to SDEV_BLOCK.  Stop the
-	 * block layer from calling the midlayer with this device's
-	 * request queue. 
-	 */
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_stop_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 89195e2..3f5197e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -960,8 +960,12 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	unsigned long flags;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
 			return;
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
@@ -975,7 +979,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 * scsi_run_queue() invocations have finished before tearing down the
 	 * device.
 	 */
+	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_device_set_state(sdev, SDEV_DEL);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-- 
1.7.10.4

