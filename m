From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 15 Apr 2008 16:43:15 -0700
Message-ID: <1208302995.21877.12.camel@dwillia2-linux.ch.intel.com>
References: <47E875AD.1000901@rtr.ca> <47E88A13.70808@zytor.com>
	 <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com>
	 <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de>
	 <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com>
	 <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
	 <47EBF7D0.6000901@zytor.com>
	 <e9c3a7c20804111625w68b21b24p6fbd85864713d62f@mail.gmail.com>
	 <20080415001828.b0c9ed64.akpm@linux-foundation.org>
	 <1208269202.3131.3.camel@localhost.localdomain>
	 <4804F108.6020505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752765AbYDOXnc@vger.kernel.org>
In-Reply-To: <4804F108.6020505@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

Subject: sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor

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

Cc: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>
Acked-by: Mark Lord <lkml@rtr.ca>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: SL Baur <steve@xemacs.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Andrew here is an updated patch with some presumptive acked-by's from Mark and hpa.

* fixed up ENOMEM handling in devices_init()
* added a short blurb in Documentation/filesystems/sysfs.txt
* dropped the size of the buffer passed to format_dev_t a bit

 Documentation/filesystems/sysfs.txt |    6 +++++
 drivers/base/core.c                 |   46 ++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletions(-)


diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 7f27b8f..9e9c348 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -248,6 +248,7 @@ The top level sysfs directory looks like:
 block/
 bus/
 class/
+dev/
 devices/
 firmware/
 net/
@@ -274,6 +275,11 @@ fs/ contains a directory for some filesystems.  Currently each
 filesystem wanting to export attributes must create its own hierarchy
 below fs/ (see ./fuse.txt for an example).
 
+dev/ contains two directories char/ and block/. Inside these two
+directories there are symlinks named <major>:<minor>.  These symlinks
+point to the sysfs directory for the given device.  /sys/dev provides a
+quick way to lookup the sysfs interface for a device from the result of
+a stat(2) operation.
 
 More information can driver-model specific features can be found in
 Documentation/driver-model/. 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 24198ad..ba21118 100644
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
@@ -759,6 +762,11 @@ static void device_remove_class_symlinks(struct device *dev)
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
@@ -775,6 +783,7 @@ int device_add(struct device *dev)
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
 	int error;
+	char devt_str[15];
 
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
@@ -806,9 +815,16 @@ int device_add(struct device *dev)
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
@@ -1380,4 +1421,7 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+	kobject_put(char_kobj);
+	kobject_put(block_kobj);
+	kobject_put(dev_kobj);
 }
