From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Wed, 5 Mar 2008 15:34:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803051528270.2085-100000@iolanthe.rowland.org>
References: <47CEF45B.2080701@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48778 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752790AbYCEUeQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 15:34:16 -0500
In-Reply-To: <47CEF45B.2080701@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 5 Mar 2008, Stefan Richter wrote:

> > Would it be acceptable to add a similar pair of callbacks to the host
> > template, invoked by the upper-level driver's open and release
> > routines?
> 
> This would actually be nice for that sbp2 thing which I mentioned as well.

James and Stefan, what do you think of this patch?

(Unfortunately it won't quite apply as is, because it touches a region
of documentation that was changed by the SCSI dynamic power management
patch.)

Alan Stern

--------------------------------------------------------------------

This patch (as1050b) adds two new methods to the SCSI host template
structure.  These methods are called to notify lower-level drivers
when a block device below one of their hosts has been opened or
released.

This information is useful for host drivers that want to know whether
a device on one of its buses contains a mounted filesystem.  The
open/release information isn't quite the same as mount/unmount, but it
will suffice.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- usb-2.6.orig/Documentation/scsi/scsi_mid_low_api.txt
+++ usb-2.6/Documentation/scsi/scsi_mid_low_api.txt
@@ -785,6 +785,8 @@ Summary:
    autoresume - perform dynamic (runtime) host resume
    autosuspend - perform dynamic (runtime) host suspend
    bios_param - fetch head, sector, cylinder info for a disk
+   blockdev_open - notify the host about a block-device open
+   blockdev_release - notify the host about a block-device release
    detect - detects HBAs this driver wants to control
    eh_timed_out - notify the host that a command timer expired
    eh_abort_handler - abort given command
@@ -882,6 +884,48 @@ Details:
 
 
 /**
+ *	blockdev_open - notify the host about a block-device open
+ *	@sdev: the SCSI device being opened
+ *	@disk: the gendisk corresponding to the block device
+ *
+ *	Block device opens occur primarily when a filesystem on the
+ *	device is mounted (although they crop up occasionally at other
+ *	times, such as when a partition table is edited).  An LLD
+ *	can define this function and blockdev_release below to keep
+ *	track of whether or not a device below one of its hosts has
+ *	been mounted.
+ *
+ *	Locks: none
+ *
+ *	Calling context: process
+ *
+ *	Optionally defined in: LLD
+ **/
+    void blockdev_open(struct scsi_device *sdev, struct gendisk *disk)
+
+
+/**
+ *	blockdev_release - notify the host about a block-device release
+ *	@sdev: the SCSI device being released
+ *	@disk: the gendisk corresponding to the block device
+ *
+ *	Block device releases occur primarily when a filesystem on the
+ *	device is unmounted (although they crop up occasionally at other
+ *	times, such as when a partition table is edited).  An LLD
+ *	can define this function and blockdev_open above to keep
+ *	track of whether or not a device below one of its hosts has
+ *	been mounted.
+ *
+ *	Locks: none
+ *
+ *	Calling context: process
+ *
+ *	Optionally defined in: LLD
+ **/
+    void blockdev_release(struct scsi_device *sdev, struct gendisk *disk)
+
+
+/**
  *      detect - detects HBAs this driver wants to control
  *      @shtp: host template for this driver.
  *
Index: usb-2.6/include/scsi/scsi_host.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_host.h
+++ usb-2.6/include/scsi/scsi_host.h
@@ -306,6 +306,27 @@ struct scsi_host_template {
 	void (* scan_start)(struct Scsi_Host *);
 
 	/*
+	 * If the host driver wants to know about block-device open
+	 * calls, it can fill in this function.  Note that these calls
+	 * are made only for the first opener, not for opens that occur
+	 * when the device is already open.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (* blockdev_open)(struct scsi_device *, struct gendisk *);
+
+	/*
+	 * If the host driver wants to know about block-device release
+	 * calls, it can fill in this function.  Note that these calls
+	 * are made only for the last closer, not for closes that leave
+	 * the device still open (i.e., these exactly balance the
+	 * block-device open calls).
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (* blockdev_release)(struct scsi_device *, struct gendisk *);
+
+	/*
 	 * Fill in this function to allow the queue depth of this host
 	 * to be changeable (on a per device basis).  Returns either
 	 * the current queue depth setting (may be different from what
Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -606,6 +606,9 @@ static int sd_open(struct inode *inode, 
 	if (!scsi_device_online(sdev))
 		goto error_out;
 
+	if (sdev->host->hostt->blockdev_open)
+		(sdev->host->hostt->blockdev_open)(sdev, disk);
+
 	if (!sdkp->openers++ && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
@@ -642,6 +645,9 @@ static int sd_release(struct inode *inod
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
 
+	if (sdev->host->hostt->blockdev_release)
+		(sdev->host->hostt->blockdev_release)(sdev, disk);
+
 	/*
 	 * XXX and what if there are packets in flight and this close()
 	 * XXX is followed by a "rmmod sd_mod"?
Index: usb-2.6/drivers/scsi/sr.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sr.c
+++ usb-2.6/drivers/scsi/sr.c
@@ -473,13 +473,17 @@ static int sr_block_open(struct inode *i
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct scsi_cd *cd;
+	struct scsi_device *sdev;
 	int ret = 0;
 
 	if(!(cd = scsi_cd_get(disk)))
 		return -ENXIO;
+	sdev = cd->device;
 
 	if((ret = cdrom_open(&cd->cdi, inode, file)) != 0)
 		scsi_cd_put(cd);
+	else if (sdev->host->hostt->blockdev_open)
+		(sdev->host->hostt->blockdev_open)(sdev, disk);
 
 	return ret;
 }
@@ -487,11 +491,16 @@ static int sr_block_open(struct inode *i
 static int sr_block_release(struct inode *inode, struct file *file)
 {
 	int ret;
-	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
+	struct gendisk *disk = inode->i_bdev->bd_disk;
+	struct scsi_cd *cd = scsi_cd(disk);
+	struct scsi_device *sdev = cd->device;
+
 	ret = cdrom_release(&cd->cdi, file);
 	if(ret)
 		return ret;
-	
+
+	if (sdev->host->hostt->blockdev_release)
+		(sdev->host->hostt->blockdev_release)(sdev, disk);
 	scsi_cd_put(cd);
 
 	return 0;

