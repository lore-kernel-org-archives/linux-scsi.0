From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 04/12] Protect SCSI device state changes with a mutex
Date: Fri, 2 Jun 2017 14:21:55 -0700
Message-ID: <20170602212203.30401-5-bart.vanassche@sandisk.com>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:45812 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdFBViA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 17:38:00 -0400
In-Reply-To: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Serializing SCSI device state changes avoids that two state changes
can occur concurrently, e.g. the state changes in scsi_target_block()
and __scsi_remove_device(). This serialization is essential to make
patch "Make __scsi_remove_device go straight from BLOCKED to DEL"
work reliably.

Enable this mechanism for all scsi_target_*block() callers but not
for the scsi_internal_device_unblock() calls from the mpt3sas driver
because that driver can call scsi_internal_device_unblock() from
atomic context.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c         |  8 +++++++-
 drivers/scsi/scsi_lib.c           | 27 +++++++++++++++++++++------
 drivers/scsi/scsi_scan.c          | 16 +++++++++-------
 drivers/scsi/scsi_sysfs.c         | 24 +++++++++++++++++++-----
 drivers/scsi/scsi_transport_srp.c |  7 ++++---
 drivers/scsi/sd.c                 |  7 +++++--
 include/scsi/scsi_device.h        |  1 +
 7 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ecc07dab893d..ac3196420435 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1628,11 +1628,17 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 				  struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
+	struct scsi_device *sdev;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		sdev_printk(KERN_INFO, scmd->device, "Device offlined - "
 			    "not ready after error recovery\n");
-		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
+		sdev = scmd->device;
+
+		mutex_lock(&sdev->state_mutex);
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+		mutex_unlock(&sdev->state_mutex);
+
 		scsi_eh_finish_cmd(scmd, done_q);
 	}
 	return;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index aa84b77e41dc..845d47244e70 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2881,7 +2881,12 @@ static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
 int
 scsi_device_quiesce(struct scsi_device *sdev)
 {
-	int err = scsi_device_set_state(sdev, SDEV_QUIESCE);
+	int err;
+
+	mutex_lock(&sdev->state_mutex);
+	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
+	mutex_unlock(&sdev->state_mutex);
+
 	if (err)
 		return err;
 
@@ -2909,10 +2914,11 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * so assume the state is being managed elsewhere (for example
 	 * device deleted during suspend)
 	 */
-	if (sdev->sdev_state != SDEV_QUIESCE ||
-	    scsi_device_set_state(sdev, SDEV_RUNNING))
-		return;
-	scsi_run_queue(sdev->request_queue);
+	mutex_lock(&sdev->state_mutex);
+	if (sdev->sdev_state == SDEV_QUIESCE &&
+	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
+		scsi_run_queue(sdev->request_queue);
+	mutex_unlock(&sdev->state_mutex);
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
@@ -3011,6 +3017,7 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 	int err;
 
+	mutex_lock(&sdev->state_mutex);
 	err = scsi_internal_device_block_nowait(sdev);
 	if (err == 0) {
 		if (q->mq_ops)
@@ -3018,6 +3025,8 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 		else
 			scsi_wait_for_queuecommand(sdev);
 	}
+	mutex_unlock(&sdev->state_mutex);
+
 	return err;
 }
  
@@ -3088,7 +3097,13 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_unblock_nowait);
 static int scsi_internal_device_unblock(struct scsi_device *sdev,
 					enum scsi_device_state new_state)
 {
-	return scsi_internal_device_unblock_nowait(sdev, new_state);
+	int ret;
+
+	mutex_lock(&sdev->state_mutex);
+	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
+	mutex_unlock(&sdev->state_mutex);
+
+	return ret;
 }
 
 static void
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f7128f49c30..e6de4eee97a3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -231,6 +231,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->id = starget->id;
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
+	mutex_init(&sdev->state_mutex);
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
@@ -943,16 +944,17 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	/* set the device running here so that slave configure
 	 * may do I/O */
+	mutex_lock(&sdev->state_mutex);
 	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
-	if (ret) {
+	if (ret)
 		ret = scsi_device_set_state(sdev, SDEV_BLOCK);
+	mutex_unlock(&sdev->state_mutex);
 
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
index 82dfe07b1d47..a91537a3abbf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -719,7 +719,7 @@ static ssize_t
 store_state_field(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	int i;
+	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
 
@@ -734,9 +734,11 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	if (!state)
 		return -EINVAL;
 
-	if (scsi_device_set_state(sdev, state))
-		return -EINVAL;
-	return count;
+	mutex_lock(&sdev->state_mutex);
+	ret = scsi_device_set_state(sdev, state);
+	mutex_unlock(&sdev->state_mutex);
+
+	return ret == 0 ? count : -EINVAL;
 }
 
 static ssize_t
@@ -1272,6 +1274,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	int res;
 
 	/*
 	 * This cleanup path is not reentrant and while it is impossible
@@ -1282,7 +1285,15 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		return;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		/*
+		 * If scsi_internal_target_block() is running concurrently,
+		 * wait until it has finished before changing the device state.
+		 */
+		mutex_lock(&sdev->state_mutex);
+		res = scsi_device_set_state(sdev, SDEV_CANCEL);
+		mutex_unlock(&sdev->state_mutex);
+
+		if (res != 0)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
@@ -1298,7 +1309,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 * scsi_run_queue() invocations have finished before tearing down the
 	 * device.
 	 */
+	mutex_lock(&sdev->state_mutex);
 	scsi_device_set_state(sdev, SDEV_DEL);
+	mutex_unlock(&sdev->state_mutex);
+
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 3c5d89852e9f..f617021c94f7 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -554,11 +554,12 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		 * invoking scsi_target_unblock() won't change the state of
 		 * these devices into running so do that explicitly.
 		 */
-		spin_lock_irq(shost->host_lock);
-		__shost_for_each_device(sdev, shost)
+		shost_for_each_device(sdev, shost) {
+			mutex_lock(&sdev->state_mutex);
 			if (sdev->sdev_state == SDEV_OFFLINE)
 				sdev->sdev_state = SDEV_RUNNING;
-		spin_unlock_irq(shost->host_lock);
+			mutex_unlock(&sdev->state_mutex);
+		}
 	} else if (rport->state == SRP_RPORT_RUNNING) {
 		/*
 		 * srp_reconnect_rport() has been invoked with fast_io_fail
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f9d1432d7cc5..aea55f5afed0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1798,8 +1798,9 @@ static void sd_eh_reset(struct scsi_cmnd *scmd)
 static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 {
 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
+	struct scsi_device *sdev = scmd->device;
 
-	if (!scsi_device_online(scmd->device) ||
+	if (!scsi_device_online(sdev) ||
 	    !scsi_medium_access_command(scmd) ||
 	    host_byte(scmd->result) != DID_TIME_OUT ||
 	    eh_disp != SUCCESS)
@@ -1825,7 +1826,9 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	if (sdkp->medium_access_timed_out >= sdkp->max_medium_access_timeouts) {
 		scmd_printk(KERN_ERR, scmd,
 			    "Medium access timeout failure. Offlining disk!\n");
-		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
+		mutex_lock(&sdev->state_mutex);
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+		mutex_unlock(&sdev->state_mutex);
 
 		return SUCCESS;
 	}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5f24dae2a8e1..d13bc80825b1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -207,6 +207,7 @@ struct scsi_device {
 	void			*handler_data;
 
 	unsigned char		access_state;
+	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
-- 
2.12.2
