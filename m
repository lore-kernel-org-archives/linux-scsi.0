From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] scsi: sd: add a capacity_override attribute
Date: Tue, 17 Mar 2015 14:08:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1503171406070.1061-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35632 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752069AbbCQSIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 14:08:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch provides a sysfs interface allowing users to override the
capacity of a SCSI disk.  This will help in situations where a buggy
USB-SATA adapter fails to support READ CAPACITY(16) and reports only
the low 32 bits of the capacity in its READ CAPACITY(10) reply.  For
an example, see this thread:

	http://marc.info/?l=linux-scsi&m=140908235510961&w=2

The interface is awkward because it requires the user to tell the
system to re-read the disk's partition table afterward, but at least
it provides a way to handle deficient hardware.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Dale R. Worley <worley@alum.mit.edu>

---


[as1777]


 Documentation/ABI/testing/sysfs-class-scsi_disk |   19 ++++++++++++
 drivers/scsi/sd.c                               |   37 ++++++++++++++++++++++++
 drivers/scsi/sd.h                               |    1 
 3 files changed, 57 insertions(+)

Index: usb-4.0/Documentation/ABI/testing/sysfs-class-scsi_disk
===================================================================
--- /dev/null
+++ usb-4.0/Documentation/ABI/testing/sysfs-class-scsi_disk
@@ -0,0 +1,19 @@
+What:		/sys/class/scsi_disk/HOST:CHANNEL:TARGET:LUN/capacity_override
+Date:		March 2015
+KernelVersion:	4.1
+Contact:	Alan Stern <stern@rowland.harvard.edu>
+Description:
+		This file provides a way for users to override the
+		automatically determined disk capacity.  For example, some
+		buggy USB-SATA adapters report only the low 32 bits of a
+		drive's block count, resulting in a calculated capacity
+		value that is the actual capacity modulo 2 TB.
+
+		After the correct capacity (in native-size blocks -- often
+		512 bytes per block but sometimes 4096) is written to this
+		file, the user must tell the system to re-read the disk's
+		partition table by running the command:
+
+			/usr/sbin/blockdev --rereadpt /dev/sdX
+
+		where X is the disk's drive letter.
Index: usb-4.0/drivers/scsi/sd.h
===================================================================
--- usb-4.0.orig/drivers/scsi/sd.h
+++ usb-4.0/drivers/scsi/sd.h
@@ -66,6 +66,7 @@ struct scsi_disk {
 	struct gendisk	*disk;
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
+	sector_t	capacity_override;	/* in native-size blocks */
 	u32		max_xfer_blocks;
 	u32		max_ws_blocks;
 	u32		max_unmap_blocks;
Index: usb-4.0/drivers/scsi/sd.c
===================================================================
--- usb-4.0.orig/drivers/scsi/sd.c
+++ usb-4.0/drivers/scsi/sd.c
@@ -477,6 +477,35 @@ max_write_same_blocks_store(struct devic
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
+	sdkp->capacity_override = cap;
+	return count;
+}
+static DEVICE_ATTR_RW(capacity_override);
+
 static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_cache_type.attr,
 	&dev_attr_FUA.attr,
@@ -489,6 +518,7 @@ static struct attribute *sd_disk_attrs[]
 	&dev_attr_provisioning_mode.attr,
 	&dev_attr_max_write_same_blocks.attr,
 	&dev_attr_max_medium_access_timeouts.attr,
+	&dev_attr_capacity_override.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sd_disk);
@@ -2152,6 +2182,13 @@ sd_read_capacity(struct scsi_disk *sdkp,
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

