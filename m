From: James.Smart@Emulex.Com
Subject: [PATCH] add transport class symlink to device object
Date: Sat, 13 Aug 2005 11:34:17 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD35@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:9860 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1751339AbVHMPeW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Aug 2005 11:34:22 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j7DFYJr7005143
	for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2005 08:34:19 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In prior conversations with folks doing utilities such as lsscsi, it became
rather apparent that it is difficult to establish the relationships between
the class device and its base device. The class->device symlink is good for
one direction, but the reverse direction didn't exist. In order to go from
the device to its class device, you needed to either search all class
devices to search for a device backlink that pointed to you, or had to build
in name relationships what the subset class devices that you need to look at.

This patch adds a symlink from the base device to the class device. The name
of the symlink is "class:<classname>".  I had originally considered just
<classname> for the symlink name, but it seemed to get lost in the attributes.

-- James S

Example:

# cd /sys/class/scsi_host/host0
# ls -ld device
lrwxrwxrwx  1 root root 0 Aug 13 11:11 device -> ../../../devices/platform/host0
# cd ../../../devices/platform/host0
# pwd
/sys/devices/platform/host0
# ls
class:scsi_host  power  target0:0:0  target0:0:1  target0:0:2  target0:0:3
# ls -ld class*
lrwxrwxrwx  1 root root 0 Aug 13 07:08 class:scsi_host -> ../../../class/scsi_host/host0




diff -upNr a/drivers/base/class.c b/drivers/base/class.c
--- a/drivers/base/class.c	2005-08-13 10:46:33.000000000 -0400
+++ b/drivers/base/class.c	2005-08-13 11:06:51.000000000 -0400
@@ -495,9 +495,13 @@ int class_device_add(struct class_device
 	}
 
 	class_device_add_attrs(class_dev);
-	if (class_dev->dev)
+	if (class_dev->dev) {
+		char buf[40];
 		sysfs_create_link(&class_dev->kobj,
 				  &class_dev->dev->kobj, "device");
+		snprintf(buf, 40, "class:%s", class_dev->class->name);
+		sysfs_create_link(&class_dev->dev->kobj, &class_dev->kobj, buf);
+	}
 
 	/* notify any interfaces this device is now here */
 	if (parent) {
@@ -589,8 +593,12 @@ void class_device_del(struct class_devic
 		up(&parent->sem);
 	}
 
-	if (class_dev->dev)
+	if (class_dev->dev) {
+		char buf[40];
+		snprintf(buf, 40, "class:%s", class_dev->class->name);
+		sysfs_remove_link(&class_dev->dev->kobj, buf);
 		sysfs_remove_link(&class_dev->kobj, "device");
+	}
 	if (class_dev->devt_attr) {
 		class_device_remove_file(class_dev, class_dev->devt_attr);
 		kfree(class_dev->devt_attr);
