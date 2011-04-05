From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names in
 Kernel.
Date: Tue, 05 Apr 2011 21:49:46 +0900
Message-ID: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@suse.de>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp, Nao Nishijima <nao.nishijima.xt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

This patch series provides a SCSI option for persistent device
names in kernel. With this option, user can always assign a
same device name (e.g. sda) to a specific device according to
udev rules and device id.

Issue:
Recently, kernel registers block devices in parallel. As a result,
different device names will be assigned at each boot time. This
will confuse file-system mounter, thus we usually use persistent
symbolic links provided by udev. However, dmesg and procfs outputs
show device names instead of the symbolic link names. This causes
a serious problem when managing multiple devices (e.g. on a
large-scale storage), because usually, device errors are output
with device names on dmesg. We also concern about some commands
which output device names, as well as kernel messages.

Solution:
To assign a persistent device name, I create unnamed devices (not
a block device, but an intermediate device. users cannot read/write
this device). When scsi device driver finds a LU, the LU is registered
as an unnamed device and inform to udev. After udev finds the unnamed
device, udev assigns a persistent device name to a specific device
according to udev rules and registers it as a block device. Hence,
this is just a naming, not a renaming.

Some users are satisfied with current udev solution. Therefore, my
proposal is implemented as an option.

If using this option, add the following kernel parameter.

	scsi_mod.persistent_name=1

Also, if you want to assign a device name with sda, add the
following udev rules.

SUBSYSTEM=="scsi_unnamed", ATTR{disk_id}=="xxx", PROGRAM="/bin/sh
-c 'echo -n sda > /sys/%p/disk_name'"

Todo:
- usb support
- hot-remove support

I've already started discussion about device naming at LKML.
https://lkml.org/lkml/2010/10/8/31

Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 drivers/scsi/Makefile       |    1 
 drivers/scsi/scsi_sysfs.c   |   26 +++
 drivers/scsi/scsi_unnamed.c |  340 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_unnamed.h |   25 +++
 4 files changed, 387 insertions(+), 5 deletions(-)
 create mode 100644 drivers/scsi/scsi_unnamed.c
 create mode 100644 drivers/scsi/scsi_unnamed.h

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 7ad0b8a..782adc1 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -167,6 +167,7 @@ scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-y			+= scsi_trace.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
+scsi_mod-y			+= scsi_unnamed.o
 
 scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e44ff64..7959f5d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -22,6 +22,7 @@
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
+#include "scsi_unnamed.h"
 
 static struct device_type scsi_dev_type;
 
@@ -393,13 +394,27 @@ int scsi_sysfs_register(void)
 {
 	int error;
 
+	error = scsi_unnamed_register(&scsi_bus_type);
+	if (error)
+		goto cleanup;
+
 	error = bus_register(&scsi_bus_type);
-	if (!error) {
-		error = class_register(&sdev_class);
-		if (error)
-			bus_unregister(&scsi_bus_type);
-	}
+	if (error)
+		goto cleanup_scsi_unnamed;
+
+	error = class_register(&sdev_class);
+	if (error)
+		goto cleanup_bus;
+
+	return 0;
+
+cleanup_bus:
+	bus_unregister(&scsi_bus_type);
+
+cleanup_scsi_unnamed:
+	scsi_unnamed_unregister();
 
+cleanup:
 	return error;
 }
 
@@ -407,6 +422,7 @@ void scsi_sysfs_unregister(void)
 {
 	class_unregister(&sdev_class);
 	bus_unregister(&scsi_bus_type);
+	scsi_unnamed_unregister();
 }
 
 /*
diff --git a/drivers/scsi/scsi_unnamed.c b/drivers/scsi/scsi_unnamed.c
new file mode 100644
index 0000000..ed96945
--- /dev/null
+++ b/drivers/scsi/scsi_unnamed.c
@@ -0,0 +1,340 @@
+/*
+ * scsi_unnamed.c - SCSI driver for unnmaed device
+ *
+ * Copyright: Copyright (c) Hitachi, Ltd. 2011
+ *            Authors: Nao Nishijima <nao.nishijima.xt@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 USA
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/kobject.h>
+#include <linux/kdev_t.h>
+#include <linux/sysdev.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi.h>
+
+#define MAX_BUFFER_LEN	256
+#define DISK_NAME_LEN	32
+
+#define SCSI_ID_BINARY	1
+#define SCSI_ID_ASCII	2
+#define SCSI_ID_UTF8	3
+
+static LIST_HEAD(su_list);
+static DEFINE_MUTEX(su_list_lock);
+
+static int persistent_name;
+MODULE_PARM_DESC(persistent_name, "SCSI unnamed device support");
+module_param(persistent_name, bool, S_IRUGO);
+
+static struct class su_sysfs_class = {
+	.name	= "scsi_unnamed",
+};
+
+struct scsi_unnamed {
+	struct list_head list;
+	struct device dev;
+	char disk_name[DISK_NAME_LEN];
+	char disk_lun[MAX_BUFFER_LEN];
+	char disk_id[MAX_BUFFER_LEN];
+	bool assigned;
+};
+
+#define to_scsi_unnamed(d) \
+	container_of(d, struct scsi_unnamed, dev)
+
+/* Get device identification VPD page */
+static void store_disk_id(struct scsi_device *sdev, char *disk_id)
+{
+	unsigned char *page_83;
+	int page_len, id_len, j = 0, i = 8;
+	static const char hex_str[] = "0123456789abcdef";
+
+	page_83 = kmalloc(MAX_BUFFER_LEN, GFP_KERNEL);
+	if (!page_83)
+		return;
+
+	if (scsi_get_vpd_page(sdev, 0x83, page_83, MAX_BUFFER_LEN))
+		goto err;
+
+	page_len = ((page_83[2] << 8) | page_83[3]) + 4;
+	if (page_len > 0) {
+		if ((page_83[5] & 0x30) != 0)
+			goto err;
+
+		id_len = page_83[7];
+		if (id_len > 0) {
+			switch (page_83[4] & 0x0f) {
+			case SCSI_ID_BINARY:
+				while (i < id_len) {
+					disk_id[j++] = hex_str[(page_83[i]
+						& 0xf0) >> 4];
+					disk_id[j++] = hex_str[page_83[i]
+						& 0x0f];
+					i++;
+				}
+				break;
+			case SCSI_ID_ASCII:
+			case SCSI_ID_UTF8:
+				strncpy(disk_id, strim(page_83 + 8), id_len);
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
+err:
+	kfree(page_83);
+	return;
+}
+
+static ssize_t show_disk_name(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_scsi_unnamed(dev)->disk_name);
+}
+
+static ssize_t show_disk_lun(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_scsi_unnamed(dev)->disk_lun);
+}
+
+static ssize_t show_disk_id(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_scsi_unnamed(dev)->disk_id);
+}
+
+/* Assign a persistent device name */
+static ssize_t store_disk_name(struct device *dev,
+		struct device_attribute *attr, char *buf, size_t count)
+{
+	struct scsi_unnamed *su = to_scsi_unnamed(dev);
+	struct scsi_unnamed *tmp;
+	struct device *lu = dev->parent;
+	int ret = -EINVAL;
+
+	if (count >= DISK_NAME_LEN) {
+		printk(KERN_WARNING "su: Too long a persistent name!\n");
+		return -EINVAL;
+	}
+
+	if (su->assigned) {
+		printk(KERN_WARNING "su: Already assigned a persistent name!\n");
+		return -EINVAL;
+	}
+
+	if (strncmp(lu->driver->name, buf, 2)) {
+		printk(KERN_WARNING "su: Wrong prefix!\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&su_list_lock);
+	list_for_each_entry(tmp, &su_list, list) {
+		if (!strncmp(tmp->disk_name, buf, DISK_NAME_LEN)) {
+			printk(KERN_WARNING "su: Duplicate name exsists!\n");
+			return -EINVAL;
+		}
+	}
+	strncpy(su->disk_name, buf, DISK_NAME_LEN);
+	mutex_unlock(&su_list_lock);
+
+	if (!lu->driver->probe)
+		return -EINVAL;
+
+	lu->init_name = buf;
+
+	ret = lu->driver->probe(lu);
+	if (ret) {
+		lu->init_name = NULL;
+		su->disk_name[0] = '\0';
+		return ret;
+	}
+
+	su->assigned = true;
+	return count;
+}
+
+static DEVICE_ATTR(disk_name, S_IRUGO|S_IWUSR, show_disk_name,
+			store_disk_name);
+static DEVICE_ATTR(disk_lun, S_IRUGO, show_disk_lun, NULL);
+static DEVICE_ATTR(disk_id, S_IRUGO, show_disk_id, NULL);
+
+/* Confirm the driver name and the device type */
+static int check_device_type(char type, const char *name)
+{
+	switch (type) {
+	case TYPE_DISK:
+	case TYPE_MOD:
+	case TYPE_RBC:
+		if (strncmp("sd", name, 2))
+			return -ENODEV;
+		break;
+	case TYPE_ROM:
+	case TYPE_WORM:
+		if (strncmp("sr", name, 2))
+			return -ENODEV;
+		break;
+	case TYPE_TAPE:
+		if (strncmp("st", name, 2))
+			return -ENODEV;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/**
+ * scsi_unnamed_probe - Setup the unnamed device.
+ * @dev: parent scsi device
+ *
+ * This function adds a unnamed device to the device model and
+ * gets a number of device information by scsi inquiry commands.
+ * Udev identify a device by those information.
+ *
+ * Unnamed devices:
+ * This device is not a block device and user can not read/write
+ * this device. But it can advertise device information in sysfs.
+ */
+int scsi_unnamed_probe(struct device *dev)
+{
+	struct scsi_unnamed *su;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int ret = -EINVAL;
+	static int i;
+
+	if (check_device_type(sdev->type, dev->driver->name))
+		return -ENODEV;
+
+	su = kzalloc(sizeof(*su), GFP_KERNEL);
+	if (!su)
+		return -ENOMEM;
+
+	device_initialize(&su->dev);
+	su->dev.parent = dev;
+	su->dev.class = &su_sysfs_class;
+	dev_set_name(&su->dev, "su%d", i++);
+	strncpy(su->disk_lun, dev_name(dev), MAX_BUFFER_LEN);
+
+	ret = device_add(&su->dev);
+	if (ret)
+		goto err;
+
+	ret = device_create_file(&su->dev, &dev_attr_disk_name);
+	if (ret)
+		goto err_disk_name;
+
+	ret = device_create_file(&su->dev, &dev_attr_disk_lun);
+	if (ret)
+		goto err_disk_lun;
+
+	store_disk_id(sdev, su->disk_id);
+	if (su->disk_id[0] != '\0') {
+		ret = device_create_file(&su->dev, &dev_attr_disk_id);
+		if (ret)
+			goto err_disk_id;
+	}
+
+	su->assigned = false;
+	mutex_lock(&su_list_lock);
+	list_add(&su->list, &su_list);
+	mutex_unlock(&su_list_lock);
+
+	return 0;
+
+err_disk_id:
+	device_remove_file(&su->dev, &dev_attr_disk_lun);
+
+err_disk_lun:
+	device_remove_file(&su->dev, &dev_attr_disk_name);
+
+err_disk_name:
+	device_del(&su->dev);
+
+err:
+	kfree(su);
+	return ret;
+}
+
+/* Remove a unnamed device from su_list and release resources */
+void scsi_unnamed_remove(struct device *dev)
+{
+	struct scsi_unnamed *tmp;
+
+	mutex_lock(&su_list_lock);
+	list_for_each_entry(tmp, &su_list, list) {
+		if (dev == tmp->dev.parent) {
+			list_del(&tmp->list);
+			break;
+		}
+	}
+	mutex_unlock(&su_list_lock);
+
+	if (tmp->disk_id[0] != '\0')
+		device_remove_file(&tmp->dev, &dev_attr_disk_id);
+	device_remove_file(&tmp->dev, &dev_attr_disk_name);
+	device_remove_file(&tmp->dev, &dev_attr_disk_lun);
+	device_del(&tmp->dev);
+
+	device_release_driver(dev);
+
+	kfree(tmp);
+}
+
+/**
+ * copy_persistent_name - Copy the device name
+ * @disk_name: allocate to
+ * @dev: scsi device
+ *
+ * Copy an initial name of the device to disk_name.
+ */
+int copy_persistent_name(char *disk_name, struct device *dev)
+{
+	if (persistent_name) {
+		strncpy(disk_name, dev->init_name, DISK_NAME_LEN);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(copy_persistent_name);
+
+int scsi_unnamed_register(struct bus_type *bus)
+{
+	if (persistent_name) {
+		bus->probe = scsi_unnamed_probe;
+		bus->remove = scsi_unnamed_remove;
+		return class_register(&su_sysfs_class);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(scsi_unnamed_register);
+
+void scsi_unnamed_unregister(void)
+{
+	if (persistent_name)
+		class_unregister(&su_sysfs_class);
+}
+EXPORT_SYMBOL(scsi_unnamed_unregister);
diff --git a/drivers/scsi/scsi_unnamed.h b/drivers/scsi/scsi_unnamed.h
new file mode 100644
index 0000000..ca4e852
--- /dev/null
+++ b/drivers/scsi/scsi_unnamed.h
@@ -0,0 +1,25 @@
+/*
+ * scsi_unnamed.h - SCSI driver for unnmaed device
+ *
+ * Copyright: Copyright (c) Hitachi, Ltd. 2011
+ *            Authors: Nao Nishijima <nao.nishijima.xt@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 USA
+ */
+
+extern int check_disk_name_prefix(char *, struct device *);
+extern int copy_persistent_name(char *, struct device *);
+extern int scsi_unnamed_register(struct bus_type *);
+extern void scsi_unnamed_unregister(void);

