From: Matt Domsch <Matt_Domsch@dell.com>
Subject: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Mon, 7 Feb 2005 12:27:53 -0600
Message-ID: <20050207182753.GA16526@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from lists.us.dell.com ([143.166.224.162]:58539 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261221AbVBGS16
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 13:27:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

Below is a patch to add some hotplug infrastructure to the Linux SCSI
subsystem.

New files:
include/scsi/scsi_hotplug.h
drivers/scsi/scsi_hotplug.c
implements a new exported function:

extern int scsi_topology_hctl_action(struct Scsi_Host *shost, unsigned int channel,
			      unsigned int id, unsigned int lun, enum scsi_topology_action action);

which invokes kobject_hotplug() on a temporary "scsi_topology"
device.  This device represents a target that exists on a topology
(i.e. was just inserted into a hot plug enclosure, or was just created
by a RAID controller management application) but is not yet hooked
into the kernel.

Modified files:
drivers/scsi/Kconfig
drivers/scsi/Makefile
drivers/scsi/megaraid/megaraid_mbox.c
 (will follow in a separate patch)
 is the user of this new function.

In addition, two more infrastructure pieces are necessary:
udev-050-scsi_topology.patch - adds the subsystem name "scsi_topology"
to the list of devices *not* to wait for the creation of files in
sysfs for - scsi_topology devices aren't to be registered in sysfs.

/etc/hotplug/scsi_topology.agent
 handles the hotplug call, and invokes /sys/class/scsi_host/hostX/scan
 and /sys/class/scsi_device/H:C:T:L:/device/delete as appropriate.


The flow is as follows:

# echo "2" > /sys/class/scsi_host/host2/logical_drive_created
(to be done by a management application that knows it just created
logical drive #2 on the controller)

megaraid_mbox.c sysfs method converts logical drive number to HCTL
value, calls scsi_topology_hctl_action().

scsi_topology_hctl_action() invokes kobject_hotplug() with a
scsi_topology subsystem device.

kobject_hotplug() calls /sbin/hotplug or /sbin/udevsend (more likely
the latter), which invokes /etc/hotplug/scsi_topology.agent with the
ACTION={add,remove}.

scsi_topology.agent invokes /sys/class/scsi_host/hostX/scan or
 /sys/class/scsi_device/H:C:T:L:/device/delete as appropriate.

>From this point, we're back into known territory, with the device
being made known, or deleted from, the kernel's view.

Thoughts?

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

===== drivers/scsi/Kconfig 1.95 vs edited =====
--- 1.95/drivers/scsi/Kconfig	2005-01-28 11:14:29 -06:00
+++ edited/drivers/scsi/Kconfig	2005-02-05 13:58:45 -06:00
@@ -185,6 +185,16 @@
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+config SCSI_HOTPLUG
+	bool "Hot Plug SCSI devices"
+	depends on SCSI && EXPERIMENTAL
+	default y
+	help
+	  If your driver or management applications know about
+	  device hot plugging (insertion/removal of physical disks in
+	  a topology, or creation/deletion of logical disks on a RAID
+	  controller), say Y here.  Otherwise, say N.
+
 menu "SCSI Transport Attributes"
 	depends on SCSI
 
===== drivers/scsi/Makefile 1.72 vs edited =====
--- 1.72/drivers/scsi/Makefile	2004-11-20 14:26:17 -06:00
+++ edited/drivers/scsi/Makefile	2005-02-05 13:58:15 -06:00
@@ -147,6 +147,7 @@
 				   scsi_devinfo.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
+scsi_mod-$(CONFIG_SCSI_HOTPLUG)	+= scsi_hotplug.o
 
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
--- /dev/null	Thu Apr 11 09:25:15 2002
+++ include/scsi/scsi_hotplug.h	Sun Feb  6 23:29:51 2005
@@ -0,0 +1,41 @@
+/*
+ *  SCSI Hotplug
+ *
+ *  Copyright (c) 2005 Dell, Inc <Matt_Domsch@dell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _SCSI_SCSI_HOTPLUG_H
+#define _SCSI_SCSI_HOTPLUG_H
+
+#include <linux/config.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+
+enum scsi_topology_action {
+	SCSI_TOPOLOGY_ADDED    = 1,  /* device added in the topology */
+	SCSI_TOPOLOGY_REMOVED  = 2,  /* device removed from the topology */
+};
+
+#if defined (CONFIG_SCSI_HOTPLUG) || defined(CONFIG_SCSI_HOTPLUG_MODULE)
+extern int scsi_topology_hctl_action(struct Scsi_Host *shost, unsigned int channel,
+			      unsigned int id, unsigned int lun, enum scsi_topology_action action);
+#else
+static inline int scsi_topology_hctl_action(struct Scsi_Host *shost, unsigned int channel,
+				    unsigned int id, unsigned int lun, enum scsi_topology_action action)
+{return -ENOSYS;}
+#endif
+
+#endif /* _SCSI_SCSI_HOTPLUG_H */
--- /dev/null	Thu Apr 11 09:25:15 2002
+++ drivers/scsi/scsi_hotplug.c	Sun Feb  6 23:42:21 2005
@@ -0,0 +1,138 @@
+/*
+ *  SCSI Hotplug
+ *
+ *  Copyright (c) 2005 Dell, Inc <Matt_Domsch@dell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/kobject.h>
+#include <scsi/scsi_hotplug.h>
+
+/*
+ * TODO:
+ * - if CONFIG_SCSI_HOTPLUG=y and CONFIG_SCSI=y, then the exported
+ * functions here get dropped by the vmlinux linker, as there are no
+ * vmlinux users of them (only modules).
+ *
+ */
+
+/* This belongs in include/device.h, as drivers/base/core.c defines it too */
+#define to_dev(obj) container_of(obj, struct device, kobj)
+
+static int scsi_topology_device_hotplug(struct kset *kset, struct kobject *kobj, char **envp,
+			       int num_envp, char *buffer, int buffer_size)
+{
+
+	struct device *dev = to_dev(kobj);
+	struct device *parent_dev = dev->parent;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct Scsi_Host *shost = dev_to_shost(parent_dev);
+	int length = 0;
+	int i = 0;
+
+	add_hotplug_env_var(envp, num_envp, &i, buffer, buffer_size, &length,
+			    "SCSI_TOPOLOGY_EVENT=1");
+	add_hotplug_env_var(envp, num_envp, &i, buffer, buffer_size, &length,
+			    "SCSI_TOPOLOGY_EVENT_HCTL=1");
+	add_hotplug_env_var(envp, num_envp, &i, buffer, buffer_size, &length,
+			    "SCSI_HOST=%u", shost->host_no);
+	add_hotplug_env_var(envp, num_envp, &i, buffer, buffer_size, &length,
+			    "SCSI_CHANNEL=%u", sdev->channel);
+	add_hotplug_env_var(envp, num_envp, &i, buffer, buffer_size, &length,
+			    "SCSI_ID=%u", sdev->id);
+	add_hotplug_env_var(envp, num_envp, &i, buffer, buffer_size, &length,
+			    "SCSI_LUN=%u", sdev->lun);
+
+	envp[i] = NULL;
+	return 0;
+}
+
+static struct kset_hotplug_ops scsi_topology_device_kset_ops =
+{
+	.hotplug = scsi_topology_device_hotplug,
+};
+
+static struct kset scsi_topology_device_kset = {
+	.hotplug_ops = &scsi_topology_device_kset_ops,
+	.kobj = {
+		.name = "scsi_topology",
+	},
+};
+
+static void scsi_topology_device_release(struct device *dev)
+{
+	put_device(dev->parent);
+}
+
+static int scsi_topology_device_init(struct scsi_device *sdev,
+				     struct Scsi_Host *shost,
+				     unsigned int channel,
+				     unsigned int id,
+				     unsigned int lun)
+{
+	struct device *dev;
+	memset(sdev, 0, sizeof(*sdev));
+	dev = &sdev->sdev_gendev;
+	snprintf(dev->bus_id, BUS_ID_SIZE, "topology-%u:%u:%u:%u",
+		 shost->host_no, channel, id, lun);
+	dev->parent     = get_device(&shost->shost_gendev);
+	dev->release    = scsi_topology_device_release;
+	sdev->channel = channel;
+	sdev->id = id;
+	sdev->lun = lun;
+	device_initialize(dev);
+	kobject_set_name(&dev->kobj, "%s", dev->bus_id);
+	dev->kobj.parent = &dev->parent->kobj;
+	dev->kobj.kset  = &scsi_topology_device_kset;
+	return 0;
+}
+
+static inline enum kobject_action scsi_topology_action_to_kobject_action(enum scsi_topology_action action)
+{
+	enum kobject_action kaction = KOBJ_CHANGE; /* should there be a KOBJ_NOOP? */
+	switch (action)	{
+	case SCSI_TOPOLOGY_ADDED:
+		kaction = KOBJ_ADD;
+		break;
+	case SCSI_TOPOLOGY_REMOVED:
+		kaction = KOBJ_REMOVE;
+		break;
+	}
+	return kaction;
+}
+
+
+int scsi_topology_hctl_action(struct Scsi_Host *shost, unsigned int channel,
+			      unsigned int id, unsigned int lun, enum scsi_topology_action action)
+{
+	struct scsi_device *sdev;
+	enum kobject_action kaction;
+	int error;
+
+	sdev = kmalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!sdev)
+		return -ENOMEM;
+	error = scsi_topology_device_init(sdev, shost, channel, id, lun);
+	if (error)
+		return error;
+	kaction = scsi_topology_action_to_kobject_action(action);
+	kobject_hotplug(&sdev->sdev_gendev.kobj, kaction);
+	kfree(sdev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_topology_hctl_action);
