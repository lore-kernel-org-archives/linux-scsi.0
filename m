From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Updated state model for SCSI devices
Date: 17 Nov 2003 12:03:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069092203.2426.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:60677 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263637AbTKQSDZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 13:03:25 -0500
Received: from mulgrave-w.il.steeleye.com (il-ppp.sc.steeleye.com [172.17.6.240])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id hAHI3Ma19514
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2003 13:03:22 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi All,

I've been looking at enforcing lifetime phases for SCSI devices
(primarily to try to get the mid layer to offload as much of the device
creation and hotplug pieces as it can).

I've hijacked the sdev_state field of the struct scsi_device (formerly
this was a bitmap, now it becomes an enumerated state).

I've also begun adding references sdev_gendev into the code to pin the
scsi_device---initially in the queue function, but possibly this should
also be done in the scsi_command_get/put, the idea being to prevent
scsi_device freeing while there's still device activity.

The object phases I identified are:

1. SDEV_CREATED - we've just allocated the device.  It may respond to
internally generated commands, but not to user ones (the user should
actually have no way to access a device in this state, but just in
case).

2. SDEV_RUNNING - the device is fully operational

3. SDEV_CANCEL - The device is cleanly shutting down.  It may respond to
internally generated commands (for cancellation/recovery) only; all user
commands are errored unless they have already been queued (QUEUE_FULL
handling and the like).

4. SDEV_DEL - The device is gone. *all* commands are errored out.

Ordinarily, the device should move through all four phases from creation
to destruction, but moving SDEV_RUNNING->SDEV_DEL because of surprise
ejection should work.

It's starting to look like the online flag should be absorbed into this
(offlined devices move essentially to SDEV_CANCEL and could be
reactivated by moving to SDEV_RUNNING).

I haven't altered the similar bitmap model that scsi_host has, although
this too should probably move to an enumerated state model.

I've tested this by physically yanking a module out from underneath a
running filesystem with no ill effects (other than a slew of I/O
errors).

The obvious problem is that this kills possible user error handling, but
we don't do any of that yet.

comments welcome.

James

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1440  -> 1.1442 
#	include/scsi/scsi_device.h	1.10    -> 1.12   
#	drivers/scsi/scsi_sysfs.c	1.37    -> 1.39   
#	drivers/scsi/scsi_lib.c	1.114   -> 1.116  
#	 drivers/scsi/scsi.c	1.130   -> 1.132  
#	drivers/scsi/scsi_scan.c	1.111   -> 1.112  
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/11/16	jejb@raven.il.steeleye.com	1.1441
# Move to fully enumerated state model for SCSI devices
# --------------------------------------------
# 03/11/17	jejb@raven.il.steeleye.com	1.1442
# bug fixes to refcnt
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Nov 17 11:43:26 2003
+++ b/drivers/scsi/scsi.c	Mon Nov 17 11:43:26 2003
@@ -367,6 +367,16 @@
 	unsigned long timeout;
 	int rtn = 0;
 
+	/* check if the device is still usable */
+	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
+		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
+		 * returns an immediate error upwards, and signals
+		 * that the device is no longer present */
+		cmd->result = DID_NO_CONNECT << 16;
+		scsi_done(cmd);
+		/* return 0 (because the command has been processed) */
+		goto out;
+	}
 	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
 	if (++serial_number == 0)
@@ -893,7 +903,7 @@
  */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (test_bit(SDEV_DEL, &sdev->sdev_state))
+	if (sdev->sdev_state == SDEV_DEL)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
@@ -1015,7 +1025,7 @@
 	struct list_head *lh, *lh_sf;
 	unsigned long flags;
 
-	set_bit(SDEV_CANCEL, &sdev->sdev_state);
+	sdev->sdev_state = SDEV_CANCEL;
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Nov 17 11:43:26 2003
+++ b/drivers/scsi/scsi_lib.c	Mon Nov 17 11:43:26 2003
@@ -923,6 +923,22 @@
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct scsi_cmnd *cmd;
+	int specials_only = 0;
+
+	if(unlikely(sdev->sdev_state != SDEV_RUNNING)) {
+		/* OK, we're not in a running state don't prep
+		 * user commands */
+		if(sdev->sdev_state == SDEV_DEL) {
+			/* Device is fully deleted, no commands
+			 * at all allowed down */
+			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to dead device\n",
+			       sdev->host->host_no, sdev->id, sdev->lun);
+			return BLKPREP_KILL;
+		}
+		/* OK, we only allow special commands (i.e. not
+		 * user initiated ones */
+		specials_only = 1;
+	}
 
 	/*
 	 * Find the actual device driver associated with this command.
@@ -945,6 +961,14 @@
 		} else
 			cmd = req->special;
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+
+		if(unlikely(specials_only)) {
+			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
+			       sdev->host->host_no, sdev->id, sdev->lun);
+			return BLKPREP_KILL;
+		}
+			
+			
 		/*
 		 * Just check to see if the device is online.  If
 		 * it isn't, we refuse to process ordinary commands
@@ -1127,6 +1151,10 @@
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
+	if(!get_device(&sdev->sdev_gendev))
+		/* We must be tearing the block queue down already */
+		return;
+
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
@@ -1199,7 +1227,7 @@
 		}
 	}
 
-	return;
+	goto out;
 
  not_ready:
 	spin_unlock_irq(shost->host_lock);
@@ -1217,6 +1245,12 @@
 	sdev->device_busy--;
 	if(sdev->device_busy == 0)
 		blk_plug_device(q);
+ out:
+	/* must be careful here...if we trigger the ->remove() function
+	 * we cannot be holding the q lock */
+	spin_unlock_irq(q->queue_lock);
+	put_device(&sdev->sdev_gendev);
+	spin_lock_irq(q->queue_lock);
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Nov 17 11:43:26 2003
+++ b/drivers/scsi/scsi_scan.c	Mon Nov 17 11:43:26 2003
@@ -205,6 +205,7 @@
 	sdev->lun = lun;
 	sdev->channel = channel;
 	sdev->online = TRUE;
+	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Mon Nov 17 11:43:25 2003
+++ b/drivers/scsi/scsi_sysfs.c	Mon Nov 17 11:43:26 2003
@@ -349,7 +349,7 @@
 {
 	int error = 0, i;
 
-	set_bit(SDEV_ADD, &sdev->sdev_state);
+	sdev->sdev_state = SDEV_RUNNING;
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
@@ -401,7 +401,7 @@
 void scsi_remove_device(struct scsi_device *sdev)
 {
 	class_device_unregister(&sdev->sdev_classdev);
-	set_bit(SDEV_DEL, &sdev->sdev_state);
+	sdev->sdev_state = SDEV_DEL;
 	device_del(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 }
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Mon Nov 17 11:43:25 2003
+++ b/include/scsi/scsi_device.h	Mon Nov 17 11:43:25 2003
@@ -14,11 +14,15 @@
 /*
  * sdev state
  */
-enum {
-	SDEV_ADD,
-	SDEV_DEL,
-	SDEV_CANCEL,
-	SDEV_RECOVERY,
+enum scsi_device_state {
+	SDEV_CREATED,		/* device created but not added to sysfs
+				 * Only internal commands allowed (for inq) */
+	SDEV_RUNNING,		/* device properly configured
+				 * All commands allowed */
+	SDEV_CANCEL,		/* beginning to delete device
+				 * Only error handler commands allowed */
+	SDEV_DEL,		/* device deleted 
+				 * no commands allowed */
 };
 
 struct scsi_device {
@@ -99,7 +103,7 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
-	unsigned long sdev_state;
+	enum scsi_device_state sdev_state;
 };
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)


