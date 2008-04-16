From: <gregkh@suse.de>
Subject: patch sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch added to gregkh-2.6 tree
Date: Wed, 16 Apr 2008 13:55:53 -0700
Message-ID: <12083793533386@kroah.org>
References: <1208302995.21877.12.camel@dwillia2-linux.ch.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYDPU5d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Apr 2008 16:57:33 -0400
In-Reply-To: <1208302995.21877.12.camel@dwillia2-linux.ch.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, axboe@kernel.dk, gregkh@suse.de, hpa@zytor.com, htejun@gmail.com, jgarzik@pobox.com, kay.si


This is a note to let you know that I've just added the patch titled

     Subject: sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor

to my gregkh-2.6 tree.  Its filename is

     sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From dan.j.williams@intel.com  Wed Apr 16 13:49:38 2008
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Apr 2008 16:43:15 -0700
Subject: sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <1208302995.21877.12.camel@dwillia2-linux.ch.intel.com>


From: Dan Williams <dan.j.williams@intel.com>

Why?:
There are occasions where userspace would like to access sysfs
attributes for a device but it may not know how sysfs has named the
device or the path.  For example what is the sysfs path for
/dev/disk/by-id/ata-ST3160827AS_5MT004CK?  With this change a call to
stat(2) returns the major:minor then userspace can see that
/sys/dev/block/8:32 links to /sys/block/sdc.

What are the alternatives?:
1/ Add an ioctl to return the path: Doable, but sysfs is meant to reduce
   the need to proliferate ioctl interfaces into the kernel, so this
   seems counter productive.

2/ Use udev to create these symlinks: Also doable, but it adds a
   udev dependency to utilities that might be running in a limited
   environment like an initramfs.

3/ Do a full-tree search of sysfs.

Cc: Neil Brown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>
Acked-by: Mark Lord <lkml@rtr.ca>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: SL Baur <steve@xemacs.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/filesystems/sysfs.txt |    6 ++++
 drivers/base/core.c                 |   46 +++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -248,6 +248,7 @@ The top level sysfs directory looks like
 block/
 bus/
 class/
+dev/
 devices/
 firmware/
 net/
@@ -274,6 +275,11 @@ fs/ contains a directory for some filesy
 filesystem wanting to export attributes must create its own hierarchy
 below fs/ (see ./fuse.txt for an example).
 
+dev/ contains two directories char/ and block/. Inside these two
+directories there are symlinks named <major>:<minor>.  These symlinks
+point to the sysfs directory for the given device.  /sys/dev provides a
+quick way to lookup the sysfs interface for a device from the result of
+a stat(2) operation.
 
 More information can driver-model specific features can be found in
 Documentation/driver-model/. 
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -27,6 +27,9 @@
 
 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
+static struct kobject *dev_kobj;
+static struct kobject *char_kobj;
+static struct kobject *block_kobj;
 
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
@@ -760,6 +763,11 @@ static void device_remove_class_symlinks
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }
 
+static struct kobject *device_to_dev_kobj(struct device *dev)
+{
+	return dev->class == &block_class ? block_kobj : char_kobj;
+}
+
 /**
  * device_add - add device to device hierarchy.
  * @dev: device.
@@ -776,6 +784,7 @@ int device_add(struct device *dev)
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
 	int error;
+	char devt_str[15];
 
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
@@ -807,9 +816,16 @@ int device_add(struct device *dev)
 		goto attrError;
 
 	if (MAJOR(dev->devt)) {
+		struct kobject *kobj = device_to_dev_kobj(dev);
+
 		error = device_create_file(dev, &devt_attr);
 		if (error)
 			goto ueventattrError;
+
+		format_dev_t(devt_str, dev->devt);
+		error = sysfs_create_link(kobj, &dev->kobj, devt_str);
+		if (error)
+			goto devtattrError;
 	}
 
 	error = device_add_class_symlinks(dev);
@@ -854,6 +870,9 @@ int device_add(struct device *dev)
 	device_remove_class_symlinks(dev);
  SymlinkError:
 	if (MAJOR(dev->devt))
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
+ devtattrError:
+	if (MAJOR(dev->devt))
 		device_remove_file(dev, &devt_attr);
  ueventattrError:
 	device_remove_file(dev, &uevent_attr);
@@ -925,12 +944,16 @@ void device_del(struct device *dev)
 {
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
+	char devt_str[15];
 
 	device_pm_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (MAJOR(dev->devt))
+	if (MAJOR(dev->devt)) {
+		format_dev_t(devt_str, dev->devt);
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
 		device_remove_file(dev, &devt_attr);
+	}
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
@@ -1055,7 +1078,25 @@ int __init devices_init(void)
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
 	if (!devices_kset)
 		return -ENOMEM;
+	dev_kobj = kobject_create_and_add("dev", NULL);
+	if (!dev_kobj)
+		goto dev_kobj_err;
+	block_kobj = kobject_create_and_add("block", dev_kobj);
+	if (!block_kobj)
+		goto block_kobj_err;
+	char_kobj = kobject_create_and_add("char", dev_kobj);
+	if (!char_kobj)
+		goto char_kobj_err;
+
 	return 0;
+
+ char_kobj_err:
+	kobject_put(block_kobj);
+ block_kobj_err:
+	kobject_put(dev_kobj);
+ dev_kobj_err:
+	kset_unregister(devices_kset);
+	return -ENOMEM;
 }
 
 EXPORT_SYMBOL_GPL(device_for_each_child);
@@ -1351,4 +1392,7 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+	kobject_put(char_kobj);
+	kobject_put(block_kobj);
+	kobject_put(dev_kobj);
 }


Patches currently in gregkh-2.6 which might be from dan.j.williams@intel.com are

driver-core/sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
driver-core/sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch
