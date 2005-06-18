From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Sat, 18 Jun 2005 16:14:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506181554270.3347-100000@netrider.rowland.org>
References: <1118930260.4998.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.247.233.35] ([140.247.233.35]:51185 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262191AbVFRUOI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Jun 2005 16:14:08 -0400
In-Reply-To: <1118930260.4998.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

James and Mike:

Here's my patch (as529), very lightly tested.  Among the changes:

	Introduce an SHOST_REMOVE state bit, set it at the start
	of scsi_remove_host, and check it every time scan_mutex is
	acquired.

	In scsi_remove_host, call scsi_host_cancel _before_ calling
	scsi_forget_host so that outstanding I/O really does get
	cancelled.  I don't think this will cause any problems,
	but you know the code better than I do.

	Fix an unchecked call to scsi_device_get in
	scsi_probe_and_add_lun.  The call can fail (if the LLD is
	being unloaded, for example) in which case the patch calls
	scsi_remove_device.  This worked, but I'm not certain it's
	exactly the right way to handle the failure.

	Rename scsi_scan_target to __scsi_scan_target, and introduce
	a new exported function named scsi_scan_target, which merely
	acquires the scan_mutex around a call to the old routine.
	Change existing calls so they refer to __scsi_scan_target.

	Don't acquire the scan_mutex in scsi_remove_device.  It's
	not needed since there's nothing wrong with removing devices
	during scanning, and it will cause deadlock under certain
	error conditions.  (I'm not certain about this either.  Will
	removing a device as it's being scanned cause a problem?
	Perhaps there should be a separate version of the routine
	that does acquire the scan_mutex.)

	Make scsi_forget_host remove all devices, not all targets.

	Make the loops to remove devices in scsi_forget_host and
	__scsi_remove_target restart from the beginning every time
	a device is removed (rather than using list_for_each_entry_safe,
	which is very definitely _unsafe_), and skip over devices
	that are already in the SDEV_DEL state.

This fixes several oopses I encountered during testing.  Do you think this 
is ready to be applied?

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

--- a/include/scsi/scsi_host.h	Mon Jun 13 14:57:26 2005
+++ b/include/scsi/scsi_host.h	Fri Jun 17 22:19:09 2005
@@ -411,6 +411,7 @@
 	SHOST_DEL,
 	SHOST_CANCEL,
 	SHOST_RECOVERY,
+	SHOST_REMOVE,
 };
 
 struct Scsi_Host {
--- a/drivers/scsi/hosts.c	Mon Jun 13 14:57:14 2005
+++ b/drivers/scsi/hosts.c	Fri Jun 17 22:20:19 2005
@@ -74,8 +74,13 @@
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
-	scsi_forget_host(shost);
+	set_bit(SHOST_REMOVE, &shost->shost_state);
 	scsi_host_cancel(shost, 0);
+
+	down(&shost->scan_mutex);	/* Wait for scanning to stop */
+	up(&shost->scan_mutex);
+
+	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
 	set_bit(SHOST_DEL, &shost->shost_state);
--- a/drivers/scsi/scsi_scan.c	Mon Jun 13 14:58:06 2005
+++ b/drivers/scsi/scsi_scan.c	Fri Jun 17 22:59:52 2005
@@ -843,8 +843,12 @@
  out_free_sdev:
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp) {
-			scsi_device_get(sdev);
-			*sdevp = sdev;
+			if (scsi_device_get(sdev) == 0) {
+				*sdevp = sdev;
+			} else {
+				scsi_remove_device(sdev);
+				res = SCSI_SCAN_NO_RESPONSE;
+			}
 		}
 	} else {
 		if (sdev->host->hostt->slave_destroy)
@@ -1186,22 +1190,28 @@
 				      uint id, uint lun, void *hostdata)
 {
 	struct scsi_device *sdev;
-	struct device *parent = &shost->shost_gendev;
 	int res;
-	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
+	struct scsi_target *starget;
 
-	if (!starget)
-		return ERR_PTR(-ENOMEM);
+	down(&shost->scan_mutex);
+	if (test_bit(SHOST_REMOVE, &shost->shost_state)) {
+		sdev = ERR_PTR(-ENODEV);
+		goto out;
+	}
+	starget = scsi_alloc_target(&shost->shost_gendev, channel, id);
+	if (!starget) {
+		sdev = ERR_PTR(-ENOMEM);
+		goto out;
+	}
 
 	get_device(&starget->dev);
-	down(&shost->scan_mutex);
 	res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	if (res != SCSI_SCAN_LUN_PRESENT)
 		sdev = ERR_PTR(-ENODEV);
-	up(&shost->scan_mutex);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
-
+out:
+	up(&shost->scan_mutex);
 	return sdev;
 }
 EXPORT_SYMBOL(__scsi_add_device);
@@ -1222,29 +1232,9 @@
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-/**
- * scsi_scan_target - scan a target id, possibly including all LUNs on the
- *     target.
- * @sdevsca:	Scsi_Device handle for scanning
- * @shost:	host to scan
- * @channel:	channel to scan
- * @id:		target id to scan
- *
- * Description:
- *     Scan the target id on @shost, @channel, and @id. Scan at least LUN
- *     0, and possibly all LUNs on the target id.
- *
- *     Use the pre-allocated @sdevscan as a handle for the scanning. This
- *     function sets sdevscan->host, sdevscan->id and sdevscan->lun; the
- *     scanning functions modify sdevscan->lun.
- *
- *     First try a REPORT LUN scan, if that does not scan the target, do a
- *     sequential scan of LUNs on the target id.
- **/
-void scsi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
+static void __scsi_scan_target(struct Scsi_Host *shost, unsigned int channel,
+		unsigned int id, unsigned int lun, int rescan)
 {
-	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
 	int res;
 	struct scsi_device *sdev = NULL;
@@ -1257,7 +1247,7 @@
 		return;
 
 
-	starget = scsi_alloc_target(parent, channel, id);
+	starget = scsi_alloc_target(&shost->shost_gendev, channel, id);
 
 	if (!starget)
 		return;
@@ -1304,6 +1294,32 @@
 
 	put_device(&starget->dev);
 }
+
+/**
+ * scsi_scan_target - scan a target id, possibly including all LUNs on the
+ *     target.
+ * @parent:	host to scan
+ * @channel:	channel to scan
+ * @id:		target id to scan
+ * @rescan:	passed to LUN scanning routines
+ *
+ * Description:
+ *     Scan the target id on @shost, @channel, and @id. Scan at least LUN
+ *     0, and possibly all LUNs on the target id.
+ *
+ *     First try a REPORT LUN scan, if that does not scan the target, do a
+ *     sequential scan of LUNs on the target id.
+ **/
+void scsi_scan_target(struct device *parent, unsigned int channel,
+		      unsigned int id, unsigned int lun, int rescan)
+{
+	struct Scsi_Host *shost = dev_to_shost(parent);
+
+	down(&shost->scan_mutex);
+	if (!test_bit(SHOST_REMOVE, &shost->shost_state))
+		__scsi_scan_target(shost, channel, id, lun, rescan);
+	up(&shost->scan_mutex);
+}
 EXPORT_SYMBOL(scsi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
@@ -1329,10 +1345,10 @@
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(&shost->shost_gendev, channel, order_id, lun, rescan);
+			__scsi_scan_target(shost, channel, order_id, lun, rescan);
 		}
 	else
-		scsi_scan_target(&shost->shost_gendev, channel, id, lun, rescan);
+		__scsi_scan_target(shost, channel, id, lun, rescan);
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
@@ -1347,11 +1363,14 @@
 		return -EINVAL;
 
 	down(&shost->scan_mutex);
+	if (test_bit(SHOST_REMOVE, &shost->shost_state))
+		goto out;
 	if (channel == SCAN_WILD_CARD) 
 		for (channel = 0; channel <= shost->max_channel; channel++)
 			scsi_scan_channel(shost, channel, id, lun, rescan);
 	else
 		scsi_scan_channel(shost, channel, id, lun, rescan);
+out:
 	up(&shost->scan_mutex);
 
 	return 0;
@@ -1383,23 +1402,17 @@
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_target *starget, *tmp;
+	struct scsi_device *sdev;
 	unsigned long flags;
 
-	/*
-	 * Ok, this look a bit strange.  We always look for the first device
-	 * on the list as scsi_remove_device removes them from it - thus we
-	 * also have to release the lock.
-	 * We don't need to get another reference to the device before
-	 * releasing the lock as we already own the reference from
-	 * scsi_register_device that's release in scsi_remove_device.  And
-	 * after that we don't look at sdev anymore.
-	 */
+restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
+	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_remove_target(&starget->dev);
-		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_remove_device(sdev);
+		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
@@ -1426,12 +1439,16 @@
  */
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = NULL;
 	struct scsi_target *starget;
 
+	down(&shost->scan_mutex);
+	if (test_bit(SHOST_REMOVE, &shost->shost_state))
+		goto out;
+
 	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
 	if (!starget)
-		return NULL;
+		goto out;
 
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
 	if (sdev) {
@@ -1439,6 +1456,8 @@
 		sdev->borken = 0;
 	}
 	put_device(&starget->dev);
+out:
+	up(&shost->scan_mutex);
 	return sdev;
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
--- a/drivers/scsi/scsi_sysfs.c	Fri Jun 17 22:23:37 2005
+++ b/drivers/scsi/scsi_sysfs.c	Fri Jun 17 22:25:18 2005
@@ -631,11 +631,8 @@
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	struct Scsi_Host *shost = sdev->host;
-
-	down(&shost->scan_mutex);
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-		goto out;
+		return;
 
 	class_device_unregister(&sdev->sdev_classdev);
 	device_del(&sdev->sdev_gendev);
@@ -644,8 +641,6 @@
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_unregister_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
-out:
-	up(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
@@ -653,17 +648,20 @@
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
-	struct scsi_device *sdev, *tmp;
+	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->reap_ref++;
-	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
+restart:
+	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
-		    sdev->id != starget->id)
+		    sdev->id != starget->id ||
+		    sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
+		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	scsi_target_reap(starget);

