From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] add device quiescing to the SCSI API
Date: 11 Mar 2004 22:58:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079063893.2147.99.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:16521 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261867AbUCLD6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 22:58:17 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: gibbs@scsiguy.com

This patch adds the ability to quiesce a SCSI device.  The idea is that
user issued commands (including filesystem ones) would get blocked,
while mid-layer and device issued ones would be allowed to proceed. 
This is for things like Domain Validation which like to operate on an
otherwise quiet device.

There is one big change: to get all of this to happen correctly,
scsi_do_req() has to queue on the *head* of the request queue, not the
tail as it was doing previously.  The reason is that deferred requests
block the queue, so anything needing executing after a deferred request
has to go in front of it.  I don't think there are any untoward
consequences of this, but let me know if you spot any.

James

===== drivers/scsi/scsi.c 1.139 vs edited =====
--- 1.139/drivers/scsi/scsi.c	Thu Mar 11 10:56:04 2004
+++ edited/drivers/scsi/scsi.c	Thu Mar 11 18:19:10 2004
@@ -1097,7 +1097,7 @@
 	struct list_head *lh, *lh_sf;
 	unsigned long flags;
 
-	sdev->sdev_state = SDEV_CANCEL;
+	scsi_device_set_state(sdev, SDEV_CANCEL);
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
===== drivers/scsi/scsi_lib.c 1.122 vs edited =====
--- 1.122/drivers/scsi/scsi_lib.c	Wed Mar 10 09:34:09 2004
+++ edited/drivers/scsi/scsi_lib.c	Thu Mar 11 21:38:26 2004
@@ -190,6 +190,10 @@
  *		like ioctls and character device requests - this is because
  *		we essentially just inject a request into the queue for the
  *		device.
+ *
+ *		In order to support the scsi_device_quiesce function, we
+ *		now inject requests on the *head* of the device queue
+ *		rather than the tail.
  */
 void scsi_do_req(struct scsi_request *sreq, const void *cmnd,
 		 void *buffer, unsigned bufflen,
@@ -220,11 +224,9 @@
 		sreq->sr_cmd_len = COMMAND_SIZE(sreq->sr_cmnd[0]);
 
 	/*
-	 * At this point, we merely set up the command, stick it in the normal
-	 * request queue, and return.  Eventually that request will come to the
-	 * top of the list, and will be dispatched.
+	 * head injection *required* here otherwise quiesce won't work
 	 */
-	scsi_insert_special_req(sreq, 0);
+	scsi_insert_special_req(sreq, 1);
 }
  
 static void scsi_wait_done(struct scsi_cmnd *cmd)
@@ -967,7 +969,7 @@
 		}
 		/* OK, we only allow special commands (i.e. not
 		 * user initiated ones */
-		specials_only = 1;
+		specials_only = sdev->sdev_state;
 	}
 
 	/*
@@ -993,6 +995,9 @@
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 
 		if(unlikely(specials_only)) {
+			if(specials_only == SDEV_QUIESCE)
+				return BLKPREP_DEFER;
+			
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
 			return BLKPREP_KILL;
@@ -1536,3 +1541,95 @@
 
 	return ret;
 }
+
+/**
+ *	scsi_device_set_state - Take the given device through the device
+ *		state model.
+ *	@sdev:	scsi device to change the state of.
+ *	@state:	state to change to.
+ *
+ *	Returns zero if unsuccessful or an error if the requested 
+ *	transition is illegal.
+ **/
+int
+scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
+{
+	enum scsi_device_state oldstate = sdev->sdev_state;
+
+	/* FIXME: eventually we will enforce all the state model
+	 * transitions here */
+
+	if(oldstate == state)
+		return 0;
+
+	switch(state) {
+	case SDEV_RUNNING:
+		if(oldstate != SDEV_CREATED && oldstate != SDEV_QUIESCE)
+			return -EINVAL;
+		break;
+
+	case SDEV_QUIESCE:
+		if(oldstate != SDEV_RUNNING)
+			return -EINVAL;
+		break;
+
+	default:
+		break;
+	}
+	sdev->sdev_state = state;
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_device_set_state);
+
+/**
+ *	scsi_device_quiesce - Block user issued commands.
+ *	@sdev:	scsi device to quiesce.
+ *
+ *	This works by trying to transition to the SDEV_QUIESCE state
+ *	(which must be a legal transition).  When the device is in this
+ *	state, only special requests will be accepted, all others will
+ *	be deferred.  Since special requests may also be requeued requests,
+ *	a successful return doesn't guarantee the device will be 
+ *	totally quiescent.
+ *
+ *	Must be called with user context, may sleep.
+ *
+ *	Returns zero if unsuccessful or an error if not.
+ **/
+int
+scsi_device_quiesce(struct scsi_device *sdev)
+{
+	int err = scsi_device_set_state(sdev, SDEV_QUIESCE);
+	if(err)
+		return err;
+
+	scsi_run_queue(sdev->request_queue);
+	while(sdev->device_busy) {
+		schedule_timeout(HZ/5);
+		scsi_run_queue(sdev->request_queue);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(scsi_device_quiesce);
+
+/**
+ *	scsi_device_resume - Restart user issued commands to a quiesced device.
+ *	@sdev:	scsi device to resume.
+ *
+ *	Moves the device from quiesced back to running and restarts the
+ *	queues.
+ *
+ *	Must be called with user context, may sleep.
+ **/
+void
+scsi_device_resume(struct scsi_device *sdev)
+{
+	if(sdev->sdev_state != SDEV_QUIESCE)
+		return;
+
+	scsi_device_set_state(sdev, SDEV_RUNNING);
+	scsi_run_queue(sdev->request_queue);
+}
+EXPORT_SYMBOL(scsi_device_resume);
+
===== drivers/scsi/scsi_sysfs.c 1.41 vs edited =====
--- 1.41/drivers/scsi/scsi_sysfs.c	Thu Mar  4 16:29:02 2004
+++ edited/drivers/scsi/scsi_sysfs.c	Thu Mar 11 18:26:24 2004
@@ -351,13 +351,11 @@
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
 	struct class_device_attribute **attrs;
-	int error = -EINVAL, i;
+	int error, i;
 
-	if (sdev->sdev_state != SDEV_CREATED)
+	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
 
-	sdev->sdev_state = SDEV_RUNNING;
-
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		printk(KERN_INFO "error 1\n");
@@ -419,7 +417,7 @@
  clean_device2:
 	class_device_del(&sdev->sdev_classdev);
  clean_device:
-	sdev->sdev_state = SDEV_CANCEL;
+	scsi_device_set_state(sdev, SDEV_CANCEL);
 
 	device_del(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
@@ -434,7 +432,7 @@
 void scsi_remove_device(struct scsi_device *sdev)
 {
 	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
-		sdev->sdev_state = SDEV_DEL;
+		scsi_device_set_state(sdev, SDEV_DEL);
 		class_device_unregister(&sdev->sdev_classdev);
 		class_device_unregister(&sdev->transport_classdev);
 		device_del(&sdev->sdev_gendev);
===== include/scsi/scsi_device.h 1.13 vs edited =====
--- 1.13/include/scsi/scsi_device.h	Thu Mar  4 16:29:02 2004
+++ edited/include/scsi/scsi_device.h	Thu Mar 11 18:14:57 2004
@@ -15,7 +15,7 @@
  * sdev state
  */
 enum scsi_device_state {
-	SDEV_CREATED,		/* device created but not added to sysfs
+	SDEV_CREATED = 1,	/* device created but not added to sysfs
 				 * Only internal commands allowed (for inq) */
 	SDEV_RUNNING,		/* device properly configured
 				 * All commands allowed */
@@ -23,6 +23,9 @@
 				 * Only error handler commands allowed */
 	SDEV_DEL,		/* device deleted 
 				 * no commands allowed */
+	SDEV_QUIESCE,		/* Device quiescent.  No block commands
+				 * will be accepted, only specials (which
+				 * originate in the mid-layer) */
 };
 
 struct scsi_device {
@@ -170,4 +173,8 @@
 extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			   unsigned char *buffer, int len, int timeout,
 			   int retries, struct scsi_mode_data *data);
+extern int scsi_device_set_state(struct scsi_device *sdev,
+				 enum scsi_device_state state);
+extern int scsi_device_quiesce(struct scsi_device *sdev);
+extern void scsi_device_resume(struct scsi_device *sdev);
 #endif /* _SCSI_SCSI_DEVICE_H */

