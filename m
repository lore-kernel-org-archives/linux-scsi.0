From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 9/9] Avoid that scsi_device_set_state() triggers a race
Date: Thu, 06 Dec 2012 17:00:58 +0100
Message-ID: <50C0C13A.9060009@acm.org>
References: <50C0BEEE.4040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46721 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab2LFQBC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 11:01:02 -0500
In-Reply-To: <50C0BEEE.4040907@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Make concurrent invocations of scsi_device_set_state() safe.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |    4 ++++
 drivers/scsi/scsi_lib.c   |   43 ++++++++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_scan.c  |   15 ++++++++-------
 drivers/scsi/scsi_sysfs.c |   19 ++++++++++++++++---
 4 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 76761aa..dbc1fb86 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1432,7 +1432,11 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		sdev_printk(KERN_INFO, scmd->device, "Device offlined - "
 			    "not ready after error recovery\n");
+
+		spin_lock_irq(scmd->device->host->host_lock);
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
+		spin_unlock_irq(scmd->device->host->host_lock);
+
 		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
 			/*
 			 * FIXME: Handle lost cmds.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index db4836bc..f6e415d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2074,7 +2074,9 @@ EXPORT_SYMBOL(scsi_test_unit_ready);
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
@@ -2351,7 +2353,13 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 int
 scsi_device_quiesce(struct scsi_device *sdev)
 {
-	int err = scsi_device_set_state(sdev, SDEV_QUIESCE);
+	struct Scsi_Host *host = sdev->host;
+	int err;
+
+	spin_lock_irq(host->host_lock);
+	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
+	spin_unlock_irq(host->host_lock);
+
 	if (err)
 		return err;
 
@@ -2375,13 +2383,21 @@ EXPORT_SYMBOL(scsi_device_quiesce);
  */
 void scsi_device_resume(struct scsi_device *sdev)
 {
+	struct Scsi_Host *host = sdev->host;
+	int err;
+
 	/* check if the device state was mutated prior to resume, and if
 	 * so assume the state is being managed elsewhere (for example
 	 * device deleted during suspend)
 	 */
-	if (sdev->sdev_state != SDEV_QUIESCE ||
-	    scsi_device_set_state(sdev, SDEV_RUNNING))
+	spin_lock_irq(host->host_lock);
+	err = sdev->sdev_state == SDEV_QUIESCE ?
+		scsi_device_set_state(sdev, SDEV_RUNNING) : -EINVAL;
+	spin_unlock_irq(host->host_lock);
+
+	if (err)
 		return;
+
 	scsi_run_queue(sdev->request_queue);
 }
 EXPORT_SYMBOL(scsi_device_resume);
@@ -2431,17 +2447,19 @@ EXPORT_SYMBOL(scsi_target_resume);
 int
 scsi_internal_device_block(struct scsi_device *sdev)
 {
+	struct Scsi_Host *host = sdev->host;
 	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
 	int err = 0;
 
+	spin_lock_irqsave(host->host_lock, flags);
 	err = scsi_device_set_state(sdev, SDEV_BLOCK);
-	if (err) {
+	if (err)
 		err = scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
+	spin_unlock_irqrestore(host->host_lock, flags);
 
-		if (err)
-			return err;
-	}
+	if (err)
+		return err;
 
 	/* 
 	 * The device has transitioned to SDEV_BLOCK.  Stop the
@@ -2476,13 +2494,16 @@ int
 scsi_internal_device_unblock(struct scsi_device *sdev,
 			     enum scsi_device_state new_state)
 {
+	struct Scsi_Host *host = sdev->host;
 	struct request_queue *q = sdev->request_queue; 
 	unsigned long flags;
+	int ret = 0;
 
 	/*
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
 	 */
+	spin_lock_irqsave(host->host_lock, flags);
 	if ((sdev->sdev_state == SDEV_BLOCK) ||
 	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
 		sdev->sdev_state = new_state;
@@ -2494,7 +2515,11 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 			sdev->sdev_state = SDEV_CREATED;
 	} else if (sdev->sdev_state != SDEV_CANCEL &&
 		 sdev->sdev_state != SDEV_OFFLINE)
-		return -EINVAL;
+		ret = -EINVAL;
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_start_queue(q);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0612fba..3fbdd7b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -898,18 +898,19 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
+	spin_lock_irq(sdev->host->host_lock);
 	/* set the device running here so that slave configure
 	 * may do I/O */
 	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
-	if (ret) {
+	if (ret)
 		ret = scsi_device_set_state(sdev, SDEV_BLOCK);
+	spin_unlock_irq(sdev->host->host_lock);
 
-		if (ret) {
-			sdev_printk(KERN_ERR, sdev,
-				    "in wrong state %s to complete scan\n",
-				    scsi_device_state_name(sdev->sdev_state));
-			return SCSI_SCAN_NO_RESPONSE;
-		}
+	if (ret) {
+		sdev_printk(KERN_ERR, sdev,
+			    "in wrong state %s to complete scan\n",
+			    scsi_device_state_name(sdev->sdev_state));
+		return SCSI_SCAN_NO_RESPONSE;
 	}
 
 	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6368576..b2ebcfd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -598,7 +598,7 @@ static ssize_t
 store_state_field(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	int i;
+	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = INVALID_SDEV_STATE;
 
@@ -614,9 +614,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	    state == SDEV_DEL)
 		return -EINVAL;
 
+	ret = count;
+
+	spin_lock_irq(sdev->host->host_lock);
 	if (scsi_device_set_state(sdev, state))
-		return -EINVAL;
-	return count;
+		ret = -EINVAL;
+	spin_unlock_irq(sdev->host->host_lock);
+
+	return ret;
 }
 
 static ssize_t
@@ -876,7 +881,10 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	struct request_queue *rq = sdev->request_queue;
 	struct scsi_target *starget = sdev->sdev_target;
 
+	spin_lock_irq(sdev->host->host_lock);
 	error = scsi_device_set_state(sdev, SDEV_RUNNING);
+	spin_unlock_irq(sdev->host->host_lock);
+
 	if (error)
 		return error;
 
@@ -963,8 +971,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	unsigned long flags;
 
 	if (sdev->is_visible) {
+		spin_lock_irqsave(shost->host_lock, flags);
 		WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
 			     scsi_device_set_state(sdev, SDEV_DEL) != 0);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
@@ -978,7 +988,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
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

