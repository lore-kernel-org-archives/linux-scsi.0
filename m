From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Mon, 20 Jun 2005 15:24:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506201519080.4824-100000@iolanthe.rowland.org>
References: <20050620173106.GA22086@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33983 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261535AbVFTTYx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 15:24:53 -0400
In-Reply-To: <20050620173106.GA22086@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Brian King <brking@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 20 Jun 2005, Patrick Mansfield wrote:

> > -	starget = scsi_alloc_target(parent, channel, id);
> > +	starget = scsi_alloc_target(&shost->shost_gendev, channel, id);
> 
> For FC (and iSCSI), parent != &shost->shost_gendev. See user scanning
> on FC thread / patches. 
> 
> [kernel scsi]$ grep scsi_scan_target scsi_transport_fc.c
> 	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
> 
> And &rport->dev is not &shost->shost_gendev :-(

> And so parent still has to be passed down to __scsi_scan_target.

Okay.  It's a good thing you guys are able to find the bugs I've
inadvertently introduced.  Here's the next revision of the patch.  
Patrick, you may be able to suggest a better kerneldoc explanation for the
"parent" parameter in scsi_scan_target.  (The kerneldoc there now is way
out of date!)

Alan Stern



Index: usb-2.6/include/scsi/scsi_host.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_host.h
+++ usb-2.6/include/scsi/scsi_host.h
@@ -411,6 +411,7 @@ enum {
 	SHOST_DEL,
 	SHOST_CANCEL,
 	SHOST_RECOVERY,
+	SHOST_REMOVE,
 };
 
 struct Scsi_Host {
Index: usb-2.6/drivers/scsi/hosts.c
===================================================================
--- usb-2.6.orig/drivers/scsi/hosts.c
+++ usb-2.6/drivers/scsi/hosts.c
@@ -74,8 +74,13 @@ void scsi_host_cancel(struct Scsi_Host *
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
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -843,8 +843,12 @@ static int scsi_probe_and_add_lun(struct
  out_free_sdev:
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp) {
-			scsi_device_get(sdev);
-			*sdevp = sdev;
+			if (scsi_device_get(sdev) == 0) {
+				*sdevp = sdev;
+			} else {
+				__scsi_remove_device(sdev);
+				res = SCSI_SCAN_NO_RESPONSE;
+			}
 		}
 	} else {
 		if (sdev->host->hostt->slave_destroy)
@@ -1186,22 +1190,28 @@ struct scsi_device *__scsi_add_device(st
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
@@ -1222,27 +1232,8 @@ void scsi_rescan_device(struct device *d
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
+static void __scsi_scan_target(struct device *parent, unsigned int channel,
+		unsigned int id, unsigned int lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
@@ -1256,9 +1247,7 @@ void scsi_scan_target(struct device *par
 		 */
 		return;
 
-
 	starget = scsi_alloc_target(parent, channel, id);
-
 	if (!starget)
 		return;
 
@@ -1304,6 +1293,32 @@ void scsi_scan_target(struct device *par
 
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
+		__scsi_scan_target(parent, channel, id, lun, rescan);
+	up(&shost->scan_mutex);
+}
 EXPORT_SYMBOL(scsi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
@@ -1329,10 +1344,12 @@ static void scsi_scan_channel(struct Scs
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(&shost->shost_gendev, channel, order_id, lun, rescan);
+			__scsi_scan_target(&shost->shost_gendev, channel,
+					order_id, lun, rescan);
 		}
 	else
-		scsi_scan_target(&shost->shost_gendev, channel, id, lun, rescan);
+		__scsi_scan_target(&shost->shost_gendev, channel,
+				id, lun, rescan);
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
@@ -1347,11 +1364,14 @@ int scsi_scan_host_selected(struct Scsi_
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
@@ -1383,23 +1403,17 @@ EXPORT_SYMBOL(scsi_scan_single_target);
 
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
+		__scsi_remove_device(sdev);
+		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
@@ -1426,12 +1440,16 @@ void scsi_forget_host(struct Scsi_Host *
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
@@ -1439,6 +1457,8 @@ struct scsi_device *scsi_get_host_dev(st
 		sdev->borken = 0;
 	}
 	put_device(&starget->dev);
+out:
+	up(&shost->scan_mutex);
 	return sdev;
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -591,7 +591,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = attr_add(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
-				scsi_remove_device(sdev);
+				__scsi_remove_device(sdev);
 				goto out;
 			}
 		}
@@ -605,7 +605,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 							scsi_sysfs_sdev_attrs[i]);
 			error = device_create_file(&sdev->sdev_gendev, attr);
 			if (error) {
-				scsi_remove_device(sdev);
+				__scsi_remove_device(sdev);
 				goto out;
 			}
 		}
@@ -625,17 +625,10 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	return error;
 }
 
-/**
- * scsi_remove_device - unregister a device from the scsi bus
- * @sdev:	scsi_device to unregister
- **/
-void scsi_remove_device(struct scsi_device *sdev)
+void __scsi_remove_device(struct scsi_device *sdev)
 {
-	struct Scsi_Host *shost = sdev->host;
-
-	down(&shost->scan_mutex);
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-		goto out;
+		return;
 
 	class_device_unregister(&sdev->sdev_classdev);
 	device_del(&sdev->sdev_gendev);
@@ -644,8 +637,17 @@ void scsi_remove_device(struct scsi_devi
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_unregister_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
-out:
-	up(&shost->scan_mutex);
+}
+
+/**
+ * scsi_remove_device - unregister a device from the scsi bus
+ * @sdev:	scsi_device to unregister
+ **/
+void scsi_remove_device(struct scsi_device *sdev)
+{
+	down(&sdev->host->scan_mutex);
+	__scsi_remove_device(sdev);
+	up(&sdev->host->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
@@ -653,17 +655,20 @@ void __scsi_remove_target(struct scsi_ta
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
Index: usb-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_priv.h
+++ usb-2.6/drivers/scsi/scsi_priv.h
@@ -144,6 +144,7 @@ extern void scsi_sysfs_unregister(void);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
+extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;


