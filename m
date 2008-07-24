From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 03/14] osd_uld: OSD scsi ULD
Date: Thu, 24 Jul 2008 20:47:15 +0300
Message-ID: <4888C023.7070105@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18119 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407AbYGXRrv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:47:51 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@i>


Add a Linux driver module that registers as a SCSI ULD and probes for OSD type
SCSI devices.

When an OSD-type SCSI device is found a character device is created in the form
of /dev/osdX - where X goes from 0 up to hard coded 64.
The Major character device number used is *232*, which is free (as of Linux
v2.6.27). The same Major was used by the old IBM initiator project.

TODO: How to dynamically allocate a Major and have a /dev/osdX entry linked
to it? Do I need/should reserve the minor range in advance, if not how?

A single ioctl is currently supported that will invoke an in-kernel test on
the specified OSD device (lun).

osd_test: Also included is the bare bones user-mode program - osd_test - that
will open a given osd device and issue the test ioctl to kernel.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/Makefile     |   10 ++
 drivers/scsi/osd/osd_ktests.h |   31 ++++
 drivers/scsi/osd/osd_test.c   |   74 +++++++++
 drivers/scsi/osd/osd_uld.c    |  331 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 446 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/osd/osd_ktests.h
 create mode 100644 drivers/scsi/osd/osd_test.c
 create mode 100644 drivers/scsi/osd/osd_uld.c

diff --git a/drivers/scsi/osd/Makefile b/drivers/scsi/osd/Makefile
index 8ff2283..f89135d 100755
--- a/drivers/scsi/osd/Makefile
+++ b/drivers/scsi/osd/Makefile
@@ -22,6 +22,13 @@ endif
 libosd-objs := osd_initiator.o
 obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
 
+# osd.ko - SCSI ULD and char-device for testing
+ifeq ($(in_tree),0)
+CONFIG_SCSI_OSD_ULD=m
+endif
+osd-objs := osd_uld.o
+obj-$(CONFIG_SCSI_OSD_ULD) += osd.o
+
 # Everything beyond this point is used to call the kernel Makefile in case of
 # an out-of-tree build
 
@@ -42,3 +49,6 @@ all:
 
 clean:
 	$(KBUILD_BASE) in_tree=0 clean
+
+osd_test: osd_test.o
+	$(CC) -o $@ $<
diff --git a/drivers/scsi/osd/osd_ktests.h b/drivers/scsi/osd/osd_ktests.h
new file mode 100644
index 0000000..b57ca86
--- /dev/null
+++ b/drivers/scsi/osd/osd_ktests.h
@@ -0,0 +1,31 @@
+/*
+ * osd_ktests.h - Define the ktests.c API
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ *
+ */
+#ifndef __OSD_KTESTS_H__
+#define __OSD_KTESTS_H__
+
+/* Tests from osd_ktests.c */
+/* TODO: Only one simple test for now. Later I will add a test definition
+ *	structure that will define what tests to preform and with some
+ *	parametrization, so concurrent tests could be run on same OSD lun
+ *	without stepping on each other. (E.g. Format called when other tests
+ *	are in progress)
+ */
+
+enum { OSD_TEST_ALL = 17 };
+
+#ifdef __KERNEL__
+extern int do_test_17(struct scsi_device *osd_dev);
+#endif /* __KERNEL__ */
+
+#endif /*ndef __OSD_KTESTS_H__*/
diff --git a/drivers/scsi/osd/osd_test.c b/drivers/scsi/osd/osd_test.c
new file mode 100644
index 0000000..dc74865
--- /dev/null
+++ b/drivers/scsi/osd/osd_test.c
@@ -0,0 +1,74 @@
+/*
+ * osd_test.c - A user-mode program that calls into the osd ULD
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  1. Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *  2. Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *  3. Neither the name of the Panasas company nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+
+#include "osd_ktests.h"
+
+void usage(void)
+{
+	printf("usage: osd_test /dev/osdX testNo\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int osd_file, ret;
+
+	if (argc <= 1) {
+		usage();
+		return -2;
+	}
+
+	osd_file = open(argv[1], O_RDWR);
+	if (osd_file < 0) {
+		printf("Error opening <%s>\n", argv[1]);
+		return -3;
+	}
+
+	ret = ioctl(osd_file, OSD_TEST_ALL, 0);
+	if (ret) {
+		printf("ioctl 17 returned %d\n", ret);
+		return ret;
+	}
+
+	close(osd_file);
+	return 0;
+}
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
new file mode 100644
index 0000000..37797d4
--- /dev/null
+++ b/drivers/scsi/osd/osd_uld.c
@@ -0,0 +1,331 @@
+/*
+ * osd_uld.c - OSD Upper Layer Driver
+ *
+ * A Linux driver module that registers as a SCSI ULD and probes
+ * for OSD type SCSI devices.
+ * Currently only used for tests. Does not export any useful
+ * user-mode API.
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  1. Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *  2. Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *  3. Neither the name of the Panasas company nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/idr.h>
+
+/* FIXME: #include <scsi/scsi.h> move below to scsi.h when
+ * submitting upstream
+ */
+#define TYPE_OSD            0x11
+
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_ioctl.h>
+
+/* FIXME: #include <linux/major.h> move below to major.h when
+ * submitting upstream
+ */
+#define SCSI_OSD_MAJOR 232
+#define SCSI_OSD_MAX_MINOR 64
+
+#include "osd_ktests.h"
+#include "osd_debug.h"
+
+static const char osd_name[] = "osd";
+static const char *osd_version_string = "open-osd 0.0.6";
+const char osd_symlink[] = "scsi_osd";
+
+MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
+MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(SCSI_OSD_MAJOR);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_OSD);
+
+/*
+ * Device operations
+ */
+
+struct osd_uld_device {
+	int minor;
+	struct cdev cdev;
+	struct scsi_device *scsi_dev;
+	struct gendisk *disk;
+	struct device *class_member;
+};
+
+static int osd_uld_open(struct inode *inode, struct file *file)
+{
+	struct osd_uld_device *osd_dev = container_of(inode->i_cdev,
+					struct osd_uld_device, cdev);
+
+	/* cache osd_dev on file handle */
+	file->private_data = osd_dev;
+	OSD_DEBUG("osd_uld_open %p\n", osd_dev);
+	return 0;
+}
+
+static int osd_uld_release(struct inode *inode, struct file *file)
+{
+	OSD_DEBUG("osd_uld_release %p\n", file->private_data);
+	file->private_data = NULL;
+	return 0;
+}
+
+static long osd_uld_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	struct osd_uld_device *osd_dev = file->private_data;
+	int ret;
+
+	switch (cmd) {
+	case OSD_TEST_ALL:
+		OSD_DEBUG("Kernel test %d: osd_dev=%p\n", cmd, osd_dev);
+		/* TODO: Add some tests code here */
+		ret = 0;
+		break;
+	default:
+		OSD_ERR("Unknown osd_uld_ioctl %d\n", cmd);
+		ret = -ENOIOCTLCMD;
+	}
+	return ret;
+}
+
+/*
+ * Driver operation
+ */
+
+static const struct file_operations osd_fops = {
+	.owner          = THIS_MODULE,
+	.open           = osd_uld_open,
+	.release        = osd_uld_release,
+	.unlocked_ioctl = osd_uld_ioctl,
+};
+
+static struct class *osd_sysfs_class;
+static DEFINE_IDA(osd_minor_ida);
+
+static int osd_probe(struct device *dev)
+{
+	struct scsi_device *scsi_dev = to_scsi_device(dev);
+	struct gendisk *disk;
+	struct osd_uld_device *osd_dev;
+	int minor;
+	int error;
+
+	if (scsi_dev->type != TYPE_OSD)
+		return -ENODEV;
+
+	do {
+		if (!ida_pre_get(&osd_minor_ida, GFP_KERNEL))
+			return -ENODEV;
+
+		error = ida_get_new(&osd_minor_ida, &minor);
+	} while (error == -EAGAIN);
+
+	if (error)
+		return error;
+	if (minor >= SCSI_OSD_MAX_MINOR) {
+		error = -EBUSY;
+		goto err_retract_minor;
+	}
+
+	error = -ENOMEM;
+	osd_dev = kzalloc(sizeof(*osd_dev), GFP_KERNEL);
+	if (NULL == osd_dev)
+		goto err_retract_minor;
+
+	dev_set_drvdata(dev, osd_dev);
+	osd_dev->minor = minor;
+	osd_dev->scsi_dev = scsi_dev;
+
+	/* allocate a disk and set it up */
+	/* FIXME: do we need this since sg has already done that */
+	disk = alloc_disk(1);
+	if (!disk) {
+		OSD_ERR("alloc_disk failed\n");
+		goto err_free_osd;
+	}
+	disk->major = SCSI_OSD_MAJOR;
+	disk->first_minor = osd_dev->minor;
+	sprintf(disk->disk_name, "osd%d", osd_dev->minor);
+	osd_dev->disk = disk;
+
+	OSD_DEBUG("start SCSI_IOCTL_TEST_UNIT_READY %p %p %p\n",
+			osd_dev, scsi_dev, scsi_dev->request_queue);
+
+	/* FIXME: this should go away eventually */
+	error = scsi_test_unit_ready(scsi_dev, 10*HZ, 5, NULL);
+	if (error)
+		OSD_ERR("warning: scsi_test_unit_ready failed\n");
+
+	/* init the char-device for communication with user-mode */
+	cdev_init(&osd_dev->cdev, &osd_fops);
+	osd_dev->cdev.owner = THIS_MODULE;
+	error = cdev_add(&osd_dev->cdev,
+			 MKDEV(SCSI_OSD_MAJOR, osd_dev->minor), 1);
+	if (error) {
+		OSD_ERR("cdev_add failed\n");
+		goto err_put_disk;
+	}
+
+	/* class_member */
+	osd_dev->class_member = device_create(osd_sysfs_class, dev,
+		MKDEV(SCSI_OSD_MAJOR, osd_dev->minor), "%s", disk->disk_name);
+	if (IS_ERR(osd_dev->class_member)) {
+		OSD_ERR("class_device_create failed\n");
+		error = PTR_ERR(osd_dev->class_member);
+		goto err_put_cdev;
+	}
+
+	dev_set_drvdata(osd_dev->class_member, osd_dev);
+	error = sysfs_create_link(&scsi_dev->sdev_gendev.kobj,
+				  &osd_dev->class_member->kobj, osd_symlink);
+	if (error)
+		OSD_ERR("warning: unable to make symlink\n");
+
+	OSD_INFO("osd_probe %s\n", disk->disk_name);
+	return 0;
+
+err_put_cdev:
+	cdev_del(&osd_dev->cdev);
+err_put_disk:
+	put_disk(disk);
+err_free_osd:
+	dev_set_drvdata(dev, NULL);
+	kfree(osd_dev);
+	scsi_device_put(scsi_dev);
+err_retract_minor:
+	ida_remove(&osd_minor_ida, minor);
+	return error;
+}
+
+static int osd_remove(struct device *dev)
+{
+	struct scsi_device *scsi_dev = to_scsi_device(dev);
+	struct osd_uld_device *osd_dev = dev_get_drvdata(dev);
+
+	if (!osd_dev || (osd_dev->scsi_dev != scsi_dev)) {
+		OSD_ERR("Half cooked osd-device %p,%p || %p!=%p",
+			dev, osd_dev, osd_dev ? osd_dev->scsi_dev : NULL,
+			scsi_dev);
+	}
+
+	OSD_INFO("osd_remove %s\n",
+		 osd_dev->disk ? osd_dev->disk->disk_name : NULL);
+
+	sysfs_remove_link(&scsi_dev->sdev_gendev.kobj, osd_symlink);
+
+	if (osd_dev->class_member)
+		device_destroy(osd_sysfs_class,
+			       MKDEV(SCSI_OSD_MAJOR, osd_dev->minor));
+	if (osd_dev->cdev.owner)
+		cdev_del(&osd_dev->cdev);
+	if (osd_dev->disk)
+		put_disk(osd_dev->disk);
+
+	ida_remove(&osd_minor_ida, osd_dev->minor);
+	kfree(osd_dev);
+	return 0;
+}
+
+/*
+ * Global driver registration
+ */
+static struct scsi_driver osd_driver = {
+	.owner			= THIS_MODULE,
+	.gendrv = {
+		.name		= osd_name,
+		.probe		= osd_probe,
+		.remove		= osd_remove,
+	}
+};
+
+static int __init osd_uld_init(void)
+{
+	int err;
+
+	osd_sysfs_class = class_create(THIS_MODULE, osd_symlink);
+	if (IS_ERR(osd_sysfs_class)) {
+		OSD_ERR("Unable to register sysfs class => %ld\n",
+			PTR_ERR(osd_sysfs_class));
+		return PTR_ERR(osd_sysfs_class);
+	}
+
+	err = register_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0),
+				     SCSI_OSD_MAX_MINOR, osd_name);
+	if (err) {
+		OSD_ERR("Unable to register major %d for osd ULD => %d\n",
+			SCSI_OSD_MAJOR, err);
+		goto err_out;
+	}
+
+	err = scsi_register_driver(&osd_driver.gendrv);
+	if (err) {
+		OSD_ERR("scsi_register_driver failed => %d\n", err);
+		goto err_out_chrdev;
+	}
+
+/* TODO: Add osd_specific sysfs nodes here
+	err = osd_create_sysfs_files(&osd_driver.gendrv);
+	if (err)
+		goto err_out_scsidrv; */
+
+	OSD_INFO("LOADED %s\n", osd_version_string);
+	return 0;
+
+/* err_out_scsidrv:
+	scsi_unregister_driver(&osd_driver.gendrv); */
+err_out_chrdev:
+	unregister_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0), SCSI_OSD_MAX_MINOR);
+err_out:
+	class_destroy(osd_sysfs_class);
+	return err;
+}
+
+static void __exit osd_uld_exit(void)
+{
+/*	TODO: Remove osd_specific sysfs nodes
+	osd_remove_sysfs_files(&osd_driver.gendrv);*/
+
+	scsi_unregister_driver(&osd_driver.gendrv);
+	unregister_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0), SCSI_OSD_MAX_MINOR);
+	class_destroy(osd_sysfs_class);
+	OSD_INFO("UNLOADED %s\n", osd_version_string);
+}
+
+module_init(osd_uld_init);
+module_exit(osd_uld_exit);
-- 
1.5.6.rc1.5.gadf6


