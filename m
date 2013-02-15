From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v9 7/9] Avoid that scsi_device_set_state() triggers a race
Date: Fri, 15 Feb 2013 13:08:53 +0100
Message-ID: <511E2555.9060404@acm.org>
References: <511E23DD.2030309@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:48273 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3BOMIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 07:08:55 -0500
In-Reply-To: <511E23DD.2030309@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

Make concurrent invocations of scsi_device_set_state() safe.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |    4 ++++
 drivers/scsi/scsi_lib.c   |   43 ++++++++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_scan.c  |   15 ++++++++-------
 drivers/scsi/scsi_sysfs.c |   18 ++++++++++++++----
 4 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b739afe..a1b7eff 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1431,7 +1431,11 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
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
index d2a2a2f..41c0eb1 100644
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
@@ -2355,7 +2357,13 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
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
 
@@ -2379,13 +2387,21 @@ EXPORT_SYMBOL(scsi_device_quiesce);
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
@@ -2435,17 +2451,19 @@ EXPORT_SYMBOL(scsi_target_resume);
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
@@ -2480,13 +2498,16 @@ int
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
@@ -2498,7 +2519,11 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
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
index 3e58b22..5041aa8 100644
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
index 47c1e0e..1463931 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -592,7 +592,7 @@ static ssize_t
 store_state_field(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	int i;
+	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = INVALID_SDEV_STATE;
 
@@ -608,9 +608,11 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	    state == SDEV_DEL)
 		return -EINVAL;
 
-	if (scsi_device_set_state(sdev, state))
-		return -EINVAL;
-	return count;
+	spin_lock_irq(sdev->host->host_lock);
+	ret = scsi_device_set_state(sdev, state);
+	spin_unlock_irq(sdev->host->host_lock);
+
+	return ret < 0 ? ret : count;
 }
 
 static ssize_t
@@ -870,7 +872,10 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	struct request_queue *rq = sdev->request_queue;
 	struct scsi_target *starget = sdev->sdev_target;
 
+	spin_lock_irq(sdev->host->host_lock);
 	error = scsi_device_set_state(sdev, SDEV_RUNNING);
+	spin_unlock_irq(sdev->host->host_lock);
+
 	if (error)
 		return error;
 
@@ -957,7 +962,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	unsigned long flags;
 
 	if (sdev->is_visible) {
+		spin_lock_irqsave(shost->host_lock, flags);
 		WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) != 0);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
@@ -971,7 +978,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 * scsi_run_queue() invocations have finished before tearing down the
 	 * device.
 	 */
+	spin_lock_irqsave(shost->host_lock, flags);
 	WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_DEL) != 0);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-- 
1.7.10.4

