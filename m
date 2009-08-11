From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4/7 ver 2] Fix various bugs in the target code
Date: Tue, 11 Aug 2009 11:32:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111130220.2562-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52436 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751846AbZHKPcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 11:32:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1276b) fixes two bugs in the SCSI target code and
explains an obscure requirement:

	If we have to wait for an old target to disappear, instead of
	calling flush_scheduled_work() the patch calls
	schedule_timeout_uninterruptible(1).  After all, whatever is
	pinning the old target might not have anything to do with a
	workqueue.  Besides, flush_scheduled_work() is prone to
	deadlocks and should never be used by drivers.

	__scsi_add_device() called scsi_alloc_target() outside the
	protection of the host's scan_mutex, meaning that it might
	find an incompletely-initialized target or it might create
	a duplicate target.

	In scsi_sysfs_add_sdev(), the call to
	transport_configure_device() for the target appears wrong,
	since it will be called each time a device is added to the
	target.  But this is unavoidable for SPI, so a comment is
	added to explain the situation.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

The revision gets rid of a bunch of changes which weren't really 
needed.  The remaining ones do seem to be necessary.



Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -376,6 +376,9 @@ static struct scsi_target *__scsi_find_t
  *
  * The target is returned with an incremented reference, so the caller
  * is responsible for both reaping and doing a last put
+ *
+ * This routine should be called only under the protection of the host's
+ * scan_mutex.
  */
 static struct scsi_target *scsi_alloc_target(struct device *parent,
 					     int channel, uint id)
@@ -443,10 +446,12 @@ static struct scsi_target *scsi_alloc_ta
 		scsi_target_reap(starget);
 		return found_target;
 	}
-	/* Unfortunately, we found a dying target; need to
-	 * wait until it's dead before we can get a new one */
+
+	/* Unfortunately, we found a dying target; we need to
+	 * wait until it's gone before we can get a new one.
+	 */
 	put_device(&found_target->dev);
-	flush_scheduled_work();
+	schedule_timeout_uninterruptible(1);
 	goto retry;
 }
 
@@ -1485,27 +1490,29 @@ static int scsi_report_lun_scan(struct s
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 				      uint id, uint lun, void *hostdata)
 {
-	struct scsi_device *sdev = ERR_PTR(-ENODEV);
+	struct scsi_device *sdev = ERR_PTR(-ENOMEM);
 	struct device *parent = &shost->shost_gendev;
-	struct scsi_target *starget;
+	struct scsi_target *starget = NULL;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return ERR_PTR(-ENODEV);
 
-	starget = scsi_alloc_target(parent, channel, id);
-	if (!starget)
-		return ERR_PTR(-ENOMEM);
-
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost))
-		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
+	if (scsi_host_scan_allowed(shost)) {
+		starget = scsi_alloc_target(parent, channel, id);
+		if (starget)
+			scsi_probe_and_add_lun(starget, lun, NULL, &sdev,
+					1, hostdata);
+	}
 	mutex_unlock(&shost->scan_mutex);
-	scsi_target_reap(starget);
-	put_device(&starget->dev);
 
+	if (starget) {
+		scsi_target_reap(starget);
+		put_device(&starget->dev);
+	}
 	return sdev;
 }
 EXPORT_SYMBOL(__scsi_add_device);
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -850,6 +850,9 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	if (error)
 		return error;
 
+	/* SPI requires a device before the transport can be configured,
+	 * which prevents this call from being moved into scsi_target_add().
+	 */
 	transport_configure_device(&starget->dev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {

