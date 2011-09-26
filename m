From: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC] Pass information about device open/close to low-level driver
Date: Mon, 26 Sep 2011 16:10:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109261543240.1773-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49122 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753214Ab1IZUKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2011 16:10:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <htejun@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

James:

Something like the patch below has been requested by the virtualization
people.  They face a problem when exporting a SCSI host adapter
(typically a USB drive) from the host OS to a guest VM: They don't have
a good way of knowing whether any of the devices on the SCSI bus are
currently being used by the host OS.  For example, they don't want to
unbind a host adapter from its low-level driver if the SCSI bus
includes a storage device with a mounted filesystem.

Checking for this in userspace is awkward at best, and it is subject to 
races (a filesystem could get mounted after the check was made and 
before the host adapter was unbound).  Putting it in the kernel seems 
best.

This is vaguely similar to the problem faced by the Logical Volume
Manager.  When a block device is used as part of a RAID array,
everybody else has to be prevented from accessing it directly.  The
solution used by LVM is to open the underlying block device for
exclusive access using FMODE_EXCL.  Clearly that approach won't work 
here because we don't have an underlying block device -- we have a host 
adapter.

Instead this patch adds a couple of new methods to the SCSI host 
template.  The methods are called whenever a SCSI device is opened or 
closed.  The enables the low-level driver to keep track of whether or 
not any device on its bus is currently in use.  The LLD can then refuse 
an unbind request if there are any busy devices, and it can refuse to 
allow a device to be opened if an unbind has been requested.

Does this seem like a reasonable implementation?  Is there a better way 
to achieve the same end?

Alan Stern



 drivers/scsi/hosts.c       |   32 ++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          |    7 +++++++
 drivers/scsi/sg.c          |    9 ++++++++-
 drivers/scsi/sr.c          |   12 +++++++++---
 include/scsi/scsi_device.h |    2 ++
 include/scsi/scsi_host.h   |   19 +++++++++++++++++++
 6 files changed, 77 insertions(+), 4 deletions(-)

Index: usb-3.1/include/scsi/scsi_host.h
===================================================================
--- usb-3.1.orig/include/scsi/scsi_host.h
+++ usb-3.1/include/scsi/scsi_host.h
@@ -356,6 +356,25 @@ struct scsi_host_template {
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 
 	/*
+	 * This function is called when a device file is about to be opened;
+	 * if the function returns nonzero then the open fails.  The low
+	 * level driver can use this to track the number of open device file
+	 * references (including mounts), and thereby know when it is safe to
+	 * unregister the host without disrupting mounted filesystems or the
+	 * like.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (*device_open)(struct Scsi_Host *, struct scsi_device *);
+
+	/*
+	 * This function is called after a device file is closed.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (*device_close)(struct Scsi_Host *, struct scsi_device *);
+
+	/*
 	 * Name of proc directory
 	 */
 	const char *proc_name;
Index: usb-3.1/include/scsi/scsi_device.h
===================================================================
--- usb-3.1.orig/include/scsi/scsi_device.h
+++ usb-3.1/include/scsi/scsi_device.h
@@ -361,6 +361,8 @@ extern struct scsi_event *sdev_evt_alloc
 extern void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt);
 extern void sdev_evt_send_simple(struct scsi_device *sdev,
 			  enum scsi_device_event evt_type, gfp_t gfpflags);
+extern int scsi_device_open(struct scsi_device *sdev);
+extern void scsi_device_close(struct scsi_device *sdev);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
Index: usb-3.1/drivers/scsi/hosts.c
===================================================================
--- usb-3.1.orig/drivers/scsi/hosts.c
+++ usb-3.1/drivers/scsi/hosts.c
@@ -577,3 +577,35 @@ void scsi_flush_work(struct Scsi_Host *s
 	flush_workqueue(shost->work_q);
 }
 EXPORT_SYMBOL_GPL(scsi_flush_work);
+
+/**
+ * scsi_device_open - Check whether it's okay to open a device file
+ * @sdev:	Device whose file will be opened.
+ *
+ * Return value:
+ *	0 if open is allowed; negative errno otherwise
+ **/
+int scsi_device_open(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_host_template *sht = shost->hostt;
+
+	if (!sht->device_open)
+		return 0;
+	return sht->device_open(shost, sdev);
+}
+EXPORT_SYMBOL_GPL(scsi_device_open);
+
+/**
+ * scsi_device_close - Announce that a device file has been closed
+ * @sdev:	Device whose file has been closed.
+ **/
+void scsi_device_close(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_host_template *sht = shost->hostt;
+
+	if (sht->device_close)
+		sht->device_close(shost, sdev);
+}
+EXPORT_SYMBOL_GPL(scsi_device_close);
Index: usb-3.1/drivers/scsi/sd.c
===================================================================
--- usb-3.1.orig/drivers/scsi/sd.c
+++ usb-3.1/drivers/scsi/sd.c
@@ -935,6 +935,10 @@ static int sd_open(struct block_device *
 
 	sdev = sdkp->device;
 
+	retval = scsi_device_open(sdev);
+	if (retval)
+		goto error_open;
+
 	retval = scsi_autopm_get_device(sdev);
 	if (retval)
 		goto error_autopm;
@@ -985,6 +989,8 @@ static int sd_open(struct block_device *
 error_out:
 	scsi_autopm_put_device(sdev);
 error_autopm:
+	scsi_device_close(sdev);
+error_open:
 	scsi_disk_put(sdkp);
 	return retval;	
 }
@@ -1020,6 +1026,7 @@ static int sd_release(struct gendisk *di
 	 */
 
 	scsi_autopm_put_device(sdev);
+	scsi_device_close(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
Index: usb-3.1/drivers/scsi/sr.c
===================================================================
--- usb-3.1.orig/drivers/scsi/sr.c
+++ usb-3.1/drivers/scsi/sr.c
@@ -514,9 +514,13 @@ static int sr_block_open(struct block_de
 	mutex_lock(&sr_mutex);
 	cd = scsi_cd_get(bdev->bd_disk);
 	if (cd) {
-		ret = cdrom_open(&cd->cdi, bdev, mode);
-		if (ret)
+		ret = scsi_device_open(cd->device);
+		if (ret == 0)
+			ret = cdrom_open(&cd->cdi, bdev, mode);
+		if (ret) {
+			scsi_device_close(cd->device);
 			scsi_cd_put(cd);
+		}
 	}
 	mutex_unlock(&sr_mutex);
 	return ret;
@@ -527,6 +531,7 @@ static int sr_block_release(struct gendi
 	struct scsi_cd *cd = scsi_cd(disk);
 	mutex_lock(&sr_mutex);
 	cdrom_release(&cd->cdi, mode);
+	scsi_device_close(cd->device);
 	scsi_cd_put(cd);
 	mutex_unlock(&sr_mutex);
 	return 0;
@@ -623,7 +628,7 @@ static int sr_open(struct cdrom_device_i
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	return 0;
+	retval = scsi_device_open(sdev);
 
 error_out:
 	return retval;	
@@ -636,6 +641,7 @@ static void sr_release(struct cdrom_devi
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
 
+	scsi_device_close(cd->device);
 }
 
 static int sr_probe(struct device *dev)
Index: usb-3.1/drivers/scsi/sg.c
===================================================================
--- usb-3.1.orig/drivers/scsi/sg.c
+++ usb-3.1/drivers/scsi/sg.c
@@ -247,10 +247,14 @@ sg_open(struct inode *inode, struct file
 	if (retval)
 		goto sg_put;
 
-	retval = scsi_autopm_get_device(sdp->device);
+	retval = scsi_device_open(sdp->device);
 	if (retval)
 		goto sdp_put;
 
+	retval = scsi_autopm_get_device(sdp->device);
+	if (retval)
+		goto scsi_device_close;
+
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -310,6 +314,8 @@ sg_open(struct inode *inode, struct file
 error_out:
 	if (retval) {
 		scsi_autopm_put_device(sdp->device);
+scsi_device_close:
+		scsi_device_close(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
 	}
@@ -337,6 +343,7 @@ sg_release(struct inode *inode, struct f
 	wake_up_interruptible(&sdp->o_excl_wait);
 
 	scsi_autopm_put_device(sdp->device);
+	scsi_device_close(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }


