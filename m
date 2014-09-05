From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Fri, 5 Sep 2014 13:32:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409051329400.879-100000@iolanthe.rowland.org>
References: <1409782054.6571.27.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49621 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754479AbaIERc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 13:32:57 -0400
In-Reply-To: <1409782054.6571.27.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 3 Sep 2014, James Bottomley wrote:

> On Wed, 2014-09-03 at 16:30 -0400, Alan Stern wrote:
> > On Wed, 3 Sep 2014, James Bottomley wrote:
> > 
> > > Before we embark on elaborate hacks, why don't we just make the capacity
> > > writeable (by root) in sysfs from userspace (will require block change)?
> > > We can then encode all the nasty heuristics (including gpt reading) in
> > > userspace as a udev rule.
> > 
> > That's what I'm working on.  Except that I don't know where to do it in
> > the block layer, so for now I'm adding the attribute to sd.c.
> > 
> > Where in the block layer would the right place be?  We want this to
> > apply only to entire devices, not to individual partitions.
> 
> The bottom layer for this is part0.nr_sects which is the size attribute
> you see in the block sysfs.  However, it looks like we keep a separate
> value in sdkp, but we don't ever seem to use it (except to see if the
> capacity has changed).
> 
> So this could be done in two ways: add a writeable capacity attribute in
> sd.c, as you were originally thinking (it would call set_capacity() on
> write and that would update the block layer) or make the size parameter
> writeable.

Here's my patch to the sd driver.  It seems to work -- writing to the
capacity_override attribute does change the device size.  But then you
have to force the kernel to re-read the partition table manually, for
example by running

	blockdev --rereadpt /dev/sdX

because I couldn't see any reasonable way to make this happen 
automatically.

Alan Stern



Index: usb-3.17/drivers/scsi/sd.h
===================================================================
--- usb-3.17.orig/drivers/scsi/sd.h
+++ usb-3.17/drivers/scsi/sd.h
@@ -66,6 +66,7 @@ struct scsi_disk {
 	struct gendisk	*disk;
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
+	sector_t	capacity_override;	/* in native-size blocks */
 	u32		max_xfer_blocks;
 	u32		max_ws_blocks;
 	u32		max_unmap_blocks;
Index: usb-3.17/drivers/scsi/sd.c
===================================================================
--- usb-3.17.orig/drivers/scsi/sd.c
+++ usb-3.17/drivers/scsi/sd.c
@@ -477,6 +477,38 @@ max_write_same_blocks_store(struct devic
 }
 static DEVICE_ATTR_RW(max_write_same_blocks);
 
+static ssize_t
+capacity_override_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return sprintf(buf, "%llu\n",
+			(unsigned long long) sdkp->capacity_override);
+}
+
+static ssize_t
+capacity_override_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	unsigned long long cap;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	err = kstrtoull(buf, 10, &cap);
+	if (err)
+		return err;
+
+	sdkp->capacity_override = cap;
+	revalidate_disk(sdkp->disk);
+
+	return count;
+}
+static DEVICE_ATTR_RW(capacity_override);
+
 static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_cache_type.attr,
 	&dev_attr_FUA.attr,
@@ -489,6 +521,7 @@ static struct attribute *sd_disk_attrs[]
 	&dev_attr_provisioning_mode.attr,
 	&dev_attr_max_write_same_blocks.attr,
 	&dev_attr_max_medium_access_timeouts.attr,
+	&dev_attr_capacity_override.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sd_disk);
@@ -2158,6 +2191,13 @@ sd_read_capacity(struct scsi_disk *sdkp,
 	struct scsi_device *sdp = sdkp->device;
 	sector_t old_capacity = sdkp->capacity;
 
+	/* Did the user override the reported capacity? */
+	if (!sdkp->first_scan && sdkp->capacity_override) {
+		sector_size = sdkp->device->sector_size;
+		sdkp->capacity = sdkp->capacity_override;
+		goto got_data;
+	}
+
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
 		if (sector_size == -EOVERFLOW)

