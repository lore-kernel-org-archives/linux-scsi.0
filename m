From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 5/6] fc_sysfs: Rearrange the FC transport to create FC
	sysfs
Date: Wed, 27 Jan 2010 15:24:43 -0800
Message-ID: <20100127232443.10343.63564.stgit@localhost.localdomain>
References: <20100127232415.10343.86703.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56049 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab0A0XYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2010 18:24:45 -0500
In-Reply-To: <20100127232415.10343.86703.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.smart@emulex.com
Cc: giridhar.malavali@qlogic.com

This patch moves code from scsi_transport_fc.[ch] into
drivers/scsi/fc/* and include/scsi/fc.h. It creates new
sysfs objects to represent various FC entities in the
FC/FCoE environment. Currently it only modifies FC objects
and attributes, but I would want FCoE attributes added
once the layout matures.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/Kconfig             |    6 
 drivers/scsi/Makefile            |    1 
 drivers/scsi/fc/Makefile         |    8 
 drivers/scsi/fc/fc_sysfs.h       |   35 +
 drivers/scsi/fc/fcfabric.c       |  441 ++++++++++++
 drivers/scsi/fc/fcfport.c        |   73 ++
 drivers/scsi/fc/fcpinit.c        |   66 ++
 drivers/scsi/fc/fcport.c         |  217 ++++++
 drivers/scsi/fc/fcsysfs.c        |   41 +
 drivers/scsi/fc/fcvport.c        |  485 +++++++++++++
 drivers/scsi/scsi_transport_fc.c | 1411 ++++++--------------------------------
 include/scsi/fc.h                |  461 ++++++++++++
 include/scsi/scsi_transport_fc.h |  329 ++-------
 13 files changed, 2140 insertions(+), 1434 deletions(-)
 create mode 100644 drivers/scsi/fc/Makefile
 create mode 100644 drivers/scsi/fc/fc_sysfs.h
 create mode 100644 drivers/scsi/fc/fcfabric.c
 create mode 100644 drivers/scsi/fc/fcfport.c
 create mode 100644 drivers/scsi/fc/fcpinit.c
 create mode 100644 drivers/scsi/fc/fcport.c
 create mode 100644 drivers/scsi/fc/fcsysfs.c
 create mode 100644 drivers/scsi/fc/fcvport.c
 create mode 100644 include/scsi/fc.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9191d1e..f9130ab 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -650,9 +650,15 @@ config VMWARE_PVSCSI
 	  To compile this driver as a module, choose M here: the
 	  module will be called vmw_pvscsi.
 
+config FC_SYSFS
+       tristate "Fibre Channel sysfs representation"
+       ---help---
+	 Expiramental representation of FC objects in sysfs
+
 config LIBFC
 	tristate "LibFC module"
 	select SCSI_FC_ATTRS
+	select FC_SYSFS
 	select CRC32
 	---help---
 	  Fibre Channel library module
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 92a8c50..071b757 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
+obj-$(CONFIG_FC_SYSFS)		+= fc/
 obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_LIBFCOE)		+= fcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
diff --git a/drivers/scsi/fc/Makefile b/drivers/scsi/fc/Makefile
new file mode 100644
index 0000000..c3393b6
--- /dev/null
+++ b/drivers/scsi/fc/Makefile
@@ -0,0 +1,8 @@
+obj-$(CONFIG_FC_SYSFS) += fc_sysfs.o
+
+fc_sysfs-objs := fcsysfs.o \
+		 fcport.o \
+		 fcfport.o \
+		 fcfabric.o \
+		 fcvport.o \
+		 fcpinit.o
\ No newline at end of file
diff --git a/drivers/scsi/fc/fc_sysfs.h b/drivers/scsi/fc/fc_sysfs.h
new file mode 100644
index 0000000..757d5c1
--- /dev/null
+++ b/drivers/scsi/fc/fc_sysfs.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _FC_SYSFS_H_
+#define _FC_SYSFS_H_
+
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <scsi/fc.h>
+
+extern struct class fc_class;
+
+int fc_class_del_children(struct device *dev, void *data);
+int fc_fcfport_del_children(struct device *dev, void *data);
+int fc_fcfabric_del_children(struct device *dev, void *data);
+int fc_fcvport_del_children(struct device *dev, void *data);
+int fc_fcpinit_del_children(struct device *dev, void *data);
+
+int fc_vport_terminate(struct fc_fcfabric *, struct fc_fcvport *vport);
+
+#endif /*_FC_SYSFS_H_*/
diff --git a/drivers/scsi/fc/fcfabric.c b/drivers/scsi/fc/fcfabric.c
new file mode 100644
index 0000000..d6b4b99
--- /dev/null
+++ b/drivers/scsi/fc/fcfabric.c
@@ -0,0 +1,441 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fc_sysfs.h"
+
+#define fc_private_fcfabric_rd_attr(field, format_string, sz)		\
+	fc_always_show_function(fcfabric, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcfabric, field, S_IRUGO,			\
+			      show_fcfabric_##field, NULL)
+
+#define fcfabric_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_conditional_show_function(fcfabric, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcfabric, field, S_IRUGO,			\
+			      show_fcfabric_##field, NULL)
+
+fcfabric_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+fc_private_fcfabric_rd_attr(max_npiv_vports, "%u\n", 20);
+fc_private_fcfabric_rd_attr(npiv_vports_inuse, "%u\n", 20);
+
+static int
+fc_parse_wwn(const char *ns, u64 *nm)
+{
+	unsigned int i, j;
+	u8 wwn[8];
+
+	memset(wwn, 0, sizeof(wwn));
+
+	/* Validate and store the new name */
+	for (i=0, j=0; i < 16; i++) {
+		if ((*ns >= 'a') && (*ns <= 'f'))
+			j = ((j << 4) | ((*ns++ -'a') + 10));
+		else if ((*ns >= 'A') && (*ns <= 'F'))
+			j = ((j << 4) | ((*ns++ -'A') + 10));
+		else if ((*ns >= '0') && (*ns <= '9'))
+			j = ((j << 4) | (*ns++ -'0'));
+		else
+			return -EINVAL;
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	*nm = wwn_to_u64(wwn);
+
+	return 0;
+}
+
+/**
+ * fc_vport_setup - allocates and creates a FC virtual port.
+ * @shost:	scsi host the virtual port is connected to.
+ * @channel:	Channel on shost port connected to.
+ * @pdev:	parent device for vport
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ * @ret_vport:	The pointer to the created vport.
+ *
+ * Allocates and creates the vport structure, calls the parent host
+ * to instantiate the vport, the completes w/ class and sysfs creation.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+static int
+fc_vport_setup(struct fc_fcfabric *fcfabric, int channel,
+	       struct fc_vport_identifiers  *ids, struct fc_fcvport **ret_vport)
+{
+	struct fc_fcvport *fcvport;
+	unsigned long flags;
+
+	*ret_vport = NULL;
+
+	if (!fcfabric->f->vport_create)
+		return -ENOENT;
+
+	fcvport = fc_fcvport_alloc(fcfabric, ids, fcfabric->fcvport_f,
+				   fcfabric->f->dd_fcvport_size);
+	if (unlikely(!fcvport)) {
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&fcfabric->lock, flags);
+
+	if (fcfabric->npiv_vports_inuse >= fcfabric->max_npiv_vports) {
+		spin_unlock_irqrestore(&fcfabric->lock, flags);
+		kfree(fcvport);
+		return -ENOSPC;
+	}
+
+	fcfabric->npiv_vports_inuse++;
+	fcvport->number = fcfabric->next_vport_number++;
+	list_add_tail(&fcvport->peers, &fcfabric->vports);
+
+	spin_unlock_irqrestore(&fcfabric->lock, flags);
+
+	/*
+	 * TODO: Make sure this is getting released
+
+	get_device(&fcfabric->gendev);	 for fc_host->vport list 
+
+	error = fc_fcvport_add(fcvport, fcfabric);
+	if (error) {
+		printk(KERN_ERR "FC Virtual Port device_add failed\n");
+		goto delete_vport;
+	}
+
+	*ret_vport = fcvport;
+*/
+	return 0;
+
+//delete_vport_all:
+//	device_del(dev);
+/*
+delete_vport:
+
+	 * TODO: This error handling is sketchy. It needs to
+	 * be examined.
+
+//	transport_destroy_device(dev);
+	spin_lock_irqsave(&fcfabric->lock, flags);
+	list_del(&fcvport->peers);
+//	put_device(&shost->shost_gendev);	 for fc_host->vport list 
+	fcfabric->npiv_vports_inuse--;
+
+	spin_unlock_irqrestore(&fcfabric->lock, flags);
+//	put_device(dev->parent);
+	kfree(fcvport);
+
+	return error;
+*/
+}
+
+/**
+ * fc_vport_create - Admin App or LLDD requests creation of a vport
+ * @shost:	scsi host the virtual port is connected to.
+ * @channel:	channel on shost port connected to.
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+struct fc_fcvport *
+fc_vport_create(struct fc_fcfabric *fcfabric, int channel,
+		struct fc_vport_identifiers *ids)
+{
+	int stat;
+	struct fc_fcvport *vport;
+
+	stat = fc_vport_setup(fcfabric, channel, ids, &vport);
+
+	return stat ? NULL : vport;
+}
+EXPORT_SYMBOL(fc_vport_create);
+
+/**
+ * fc_vport_terminate - Admin App or LLDD requests termination of a vport
+ * @vport:	fc_vport to be terminated
+ *
+ * Calls the LLDD vport_delete() function, then deallocates and removes
+ * the vport from the shost and object tree.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+int
+fc_vport_terminate(struct fc_fcfabric *fcfabric, struct fc_fcvport *vport)
+{
+	struct device *dev = &vport->gendev;
+	struct fc_fcvport *fcnport;
+	unsigned long flags;
+	int stat = 0;
+
+	spin_lock_irqsave(&vport->lock, flags);
+	if (vport->flags & FC_VPORT_CREATING) {
+		spin_unlock_irqrestore(&vport->lock, flags);
+		return -EBUSY;
+	}
+	if (vport->flags & (FC_VPORT_DEL)) {
+		spin_unlock_irqrestore(&vport->lock, flags);
+		return -EALREADY;
+	}
+	vport->flags |= FC_VPORT_DELETING;
+	spin_unlock_irqrestore(&vport->lock, flags);
+
+	if (fcfabric->f->vport_delete) {
+		fcnport = fc_fcfabric_find_nport(fcfabric);
+		if (fcnport)
+			stat = fcfabric->f->vport_delete(fcnport->priv_data, vport);
+	} else
+		stat = -ENOENT;
+
+	spin_lock_irqsave(&fcfabric->lock, flags);
+	vport->flags &= ~FC_VPORT_DELETING;
+	if (!stat) {
+		vport->flags |= FC_VPORT_DELETED;
+		list_del(&vport->peers);
+		vport->fcfabric->npiv_vports_inuse--;
+//		put_device(&shost->shost_gendev);  /* for fc_host->vport list */
+	}
+	spin_unlock_irqrestore(&fcfabric->lock, flags);
+
+	if (stat)
+		return stat;
+
+	/*
+	 * TODO: What is this stuff? I probably need to do something here.
+
+	if (dev->parent != &shost->shost_gendev)
+		sysfs_remove_link(&shost->shost_gendev.kobj, dev_name(dev));
+	*/
+//	transport_remove_device(dev);
+	device_del(dev);
+//	transport_destroy_device(dev);
+
+	/*
+	 * Removing our self-reference should mean our
+	 * release function gets called, which will drop the remaining
+	 * parent reference and free the data structure.
+	 */
+	put_device(dev);			/* for self-reference */
+
+	return 0; /* SUCCESS */
+}
+EXPORT_SYMBOL(fc_vport_terminate);
+
+/*
+ * "Short-cut" sysfs variable to create a new vport on a FC Host.
+ * Input is a string of the form "<WWPN>:<WWNN>". Other attributes
+ * will default to a NPIV-based FCP_Initiator; The WWNs are specified
+ * as hex characters, and may *not* contain any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fcfabric_vport_create(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct fc_fcfabric *fcfabric = dev_to_fcfabric(dev);
+	struct fc_vport_identifiers vid;
+	struct fc_fcvport *fcvport;
+	unsigned int cnt = count;
+	int stat;
+
+	memset(&vid, 0, sizeof(vid));
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &vid.port_name);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &vid.node_name);
+	if (stat)
+		return stat;
+
+	vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+	vid.vport_type = FC_PORTTYPE_NPIV;
+	/* vid.symbolic_name is already zero/NULL's */
+	vid.disable = false;		/* always enabled */
+
+	/* we only allow support on Channel 0 !!! */
+	stat = fc_vport_setup(fcfabric, 0, &vid, &fcvport);
+
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(fcfabric, vport_create, S_IWUSR, NULL,
+		      store_fcfabric_vport_create);
+
+
+/*
+ * "Short-cut" sysfs variable to delete a vport on a FC Host.
+ * Vport is identified by a string containing "<WWPN>:<WWNN>".
+ * The WWNs are specified as hex characters, and may *not* contain
+ * any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fcfabric_vport_delete(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct fc_fcfabric *fcfabric = dev_to_fcfabric(dev);
+	struct fc_fcvport *vport;
+	u64 wwpn, wwnn;
+	unsigned long flags;
+	unsigned int cnt=count;
+	int stat, match;
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &wwpn);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &wwnn);
+	if (stat)
+		return stat;
+
+	spin_lock_irqsave(&fcfabric->lock, flags);
+	match = 0;
+	/* we only allow support on Channel 0 !!! */
+	list_for_each_entry(vport, &fcfabric->vports, peers) {
+		if ((vport->channel == 0) &&
+		    (vport->port_name == wwpn) && (vport->node_name == wwnn)) {
+			match = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&fcfabric->lock, flags);
+
+	if (!match)
+		return -ENODEV;
+
+	stat = fc_vport_terminate(fcfabric, vport);
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(fcfabric, vport_delete, S_IWUSR, NULL,
+		      store_fcfabric_vport_delete);
+
+
+static void fc_fcfabric_release(struct device *dev)
+{
+	struct fc_fcfabric *fcfabric = dev_to_fcfabric(dev);
+	put_device(fcfabric->gendev.parent);
+	kfree(fcfabric);
+}
+
+void fc_fcfabric_del(struct fc_fcfabric *fcfabric)
+{
+	device_del(&fcfabric->gendev);
+	put_device(&fcfabric->gendev); /* self-reference */
+}
+
+struct fc_fcfabric *fc_fcfabric_add(struct fc_fcfport *fcfport,
+				    struct fcfabric_function_template *fcn_tmpl)
+{
+	struct fc_fcfabric *fcfabric;
+	int error = 0;
+	int count = 0;
+
+	fcfabric = kzalloc(sizeof(struct fc_fcfabric), GFP_KERNEL);
+
+	device_initialize(&fcfabric->gendev);
+	fcfabric->gendev.parent = get_device(&fcfport->gendev);
+	fcfabric->gendev.release = fc_fcfabric_release;
+	
+	fcfabric->f = fcn_tmpl;
+	dev_set_name(&fcfabric->gendev, "fcfabric_%d", 0);
+
+	spin_lock_init(&fcfabric->lock);
+	INIT_LIST_HEAD(&fcfabric->vports);
+
+	fcfabric->fabric_name = -1;
+	fcfabric->max_npiv_vports = 0;
+	fcfabric->next_vport_number = 0;
+	fcfabric->npiv_vports_inuse = 0;
+
+	error = device_add(&fcfabric->gendev);
+	if (error)
+		goto out_del_gendev;
+
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcfabric, fabric_name);
+	if (fcn_tmpl->vport_create) {
+		FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcfabric, max_npiv_vports);
+		FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcfabric, npiv_vports_inuse);
+	}
+
+	if (fcn_tmpl->vport_create)
+		FC_SETUP_ALWAYS_ATTRIBUTE_RW(fcfabric, vport_create);
+	if (fcn_tmpl->vport_delete)
+		FC_SETUP_ALWAYS_ATTRIBUTE_RW(fcfabric, vport_delete);
+
+	BUG_ON(count > FCFABRIC_NUM_ATTRS);
+	FC_CREATE_ATTRIBUTES(fcfabric);
+
+	if (error || count != 0)
+		goto out_del_gendev;
+
+	return fcfabric;
+
+out_del_gendev:
+	device_del(&fcfabric->gendev);
+	kfree(fcfabric);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcfabric_add);
+
+int fc_fcfabric_del_children(struct device *dev, void *data)
+{
+	struct fc_fcfabric *fcfabric = dev_to_fcfabric(dev);
+	int error = 0;
+
+	/*
+	 * TODO: How should I remove vports? Using the fcfabric list or
+	 * using the sysfs device_for_each_child() interface?
+	 *
+	 * Need to understand why these deletes are being queued.
+
+
+	 Remove any vports
+	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers)
+		fc_queue_work(shost, &vport->vport_delete_work);
+	*/
+	error = device_for_each_child(dev, NULL, fc_fcvport_del_children);
+	if (!error)
+		fc_fcfabric_del(fcfabric);
+	return error;
+}
+
+struct fc_fcvport *fc_fcfabric_find_nport(struct fc_fcfabric *fcfabric)
+{
+	struct device *dev = device_find_child(&fcfabric->gendev, NULL, fc_fcvport_is_nport);
+	if (!dev)
+		return NULL;
+	return dev_to_fcvport(dev);
+}
+EXPORT_SYMBOL(fc_fcfabric_find_nport);
diff --git a/drivers/scsi/fc/fcfport.c b/drivers/scsi/fc/fcfport.c
new file mode 100644
index 0000000..107bb5a
--- /dev/null
+++ b/drivers/scsi/fc/fcfport.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fc_sysfs.h"
+
+static void fc_fcfport_release(struct device *dev)
+{
+	struct fc_fcfport *fcfport = dev_to_fcfport(dev);
+	put_device(fcfport->gendev.parent);
+	kfree(fcfport);
+}
+
+void fc_fcfport_del(struct fc_fcfport *fcfport)
+{
+	device_del(&fcfport->gendev);
+	put_device(&fcfport->gendev); /* self-reference */
+}
+
+struct fc_fcfport *fc_fcfport_add(struct fc_fcport *fcport, const u64 name)
+{
+	struct fc_fcfport *fcfport;
+	int error = 0;
+
+	fcfport = kzalloc(sizeof(struct fc_fcfport), GFP_KERNEL);
+	device_initialize(&fcfport->gendev);
+	fcfport->gendev.parent = get_device(&fcport->gendev);
+	fcfport->gendev.release = fc_fcfport_release;
+	dev_set_name(&fcfport->gendev, "fcfport_%llx", name);
+
+	error = device_add(&fcfport->gendev); 
+	if (error)
+		goto out_del_gendev;
+
+	/*
+	 * TODO: The name is being embedded in the device's name, it's not
+	 * being exposed as an attribute. If the name stays in the device's
+	 * name then the 'name' member can be removed since its only purpose
+	 * is for the attr
+	 */
+	fcfport->name = name;
+
+	return fcfport;
+
+out_del_gendev:
+	device_del(&fcfport->gendev);
+	kfree(fcfport);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcfport_add);
+
+int fc_fcfport_del_children(struct device *dev, void *data)
+{
+	int error = 0;
+	struct fc_fcfport *fcfport = dev_to_fcfport(dev);
+	error = device_for_each_child(dev, NULL, fc_fcfabric_del_children);
+	if (!error)
+		fc_fcfport_del(fcfport);
+	return error;
+}
diff --git a/drivers/scsi/fc/fcpinit.c b/drivers/scsi/fc/fcpinit.c
new file mode 100644
index 0000000..e251cb1
--- /dev/null
+++ b/drivers/scsi/fc/fcpinit.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#include "fc_sysfs.h"
+
+static void fc_fcpinit_release(struct device *dev)
+{
+	struct fc_fcpinit *fcpinit = dev_to_fcpinit(dev);
+	put_device(fcpinit->gendev.parent);
+	kfree(fcpinit);
+}
+
+void fc_fcpinit_del(struct fc_fcpinit *fcpinit)
+{
+	device_del(&fcpinit->gendev);
+	put_device(&fcpinit->gendev); /* self-reference */
+}
+
+struct fc_fcpinit *fc_fcpinit_add(struct fc_fcvport *fcvport, int hostno)
+{
+	struct fc_fcpinit *fcpinit;
+	int error = 0;
+
+	fcpinit = kzalloc(sizeof(struct fc_fcpinit), GFP_KERNEL);
+
+	device_initialize(&fcpinit->gendev);
+	fcpinit->gendev.parent = get_device(&fcvport->gendev);
+	fcpinit->gendev.release = fc_fcpinit_release;
+	dev_set_name(&fcpinit->gendev, "fcpinit_%d", hostno);
+
+	error = device_add(&fcpinit->gendev);
+	if (error)
+		goto out_del_gendev;
+
+	return fcpinit;
+
+out_del_gendev:
+	printk(KERN_ERR "deleting device, error\n");
+	device_del(&fcpinit->gendev);
+	kfree(fcpinit);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcpinit_add);
+
+int fc_fcpinit_del_children(struct device *dev, void *data)
+{
+	struct fc_fcpinit *fcpinit = dev_to_fcpinit(dev);
+	fc_fcpinit_del(fcpinit);
+	return 0;
+}
diff --git a/drivers/scsi/fc/fcport.c b/drivers/scsi/fc/fcport.c
new file mode 100644
index 0000000..b8d8b37
--- /dev/null
+++ b/drivers/scsi/fc/fcport.c
@@ -0,0 +1,217 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fc_sysfs.h"
+
+static int fcport_count = 0;
+
+/* Convert FC_PORTSPEED bit values to ascii string name */
+static const struct {
+	u32 			value;
+	char			*name;
+} fc_port_speed_names[] = {
+	{ FC_PORTSPEED_1GBIT,		"1 Gbit" },
+	{ FC_PORTSPEED_2GBIT,		"2 Gbit" },
+	{ FC_PORTSPEED_4GBIT,		"4 Gbit" },
+	{ FC_PORTSPEED_10GBIT,		"10 Gbit" },
+	{ FC_PORTSPEED_8GBIT,		"8 Gbit" },
+	{ FC_PORTSPEED_16GBIT,		"16 Gbit" },
+	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
+};
+fc_bitfield_name_search(port_speed, fc_port_speed_names)
+
+#define fc_fcport_rd_attr(field, format_string, sz)			\
+	fc_always_show_function(fcport, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcport, field, S_IRUGO,			\
+			      show_fcport_##field, NULL)
+
+static int show_fc_fc4s(char *buf, u8 *fc4_list)
+{
+	int i, len=0;
+
+	for (i = 0; i < FC_FC4_LIST_SIZE; i++, fc4_list++)
+		len += sprintf(buf + len , "0x%02x ", *fc4_list);
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+
+static ssize_t show_fcport_supported_fc4s(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	return (ssize_t)show_fc_fc4s(buf, fcport_supported_fc4s(fcport));
+}
+static FC_DEVICE_ATTR(fcport, supported_fc4s, S_IRUGO,
+		      show_fcport_supported_fc4s, NULL);
+
+static ssize_t show_fcport_active_fc4s (struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	if (fcport->f->get_fcport_active_fc4s)
+		fcport->f->get_fcport_active_fc4s(fcport);
+
+	return (ssize_t)show_fc_fc4s(buf, fcport_active_fc4s(fcport));
+}
+static FC_DEVICE_ATTR(fcport, active_fc4s, S_IRUGO,
+		      show_fcport_active_fc4s, NULL);
+
+static ssize_t show_fcport_speed(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+
+	if (fcport->f->get_fcport_speed)
+		fcport->f->get_fcport_speed(fcport);
+
+	if (fcport_speed(fcport) == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(fcport_speed(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, speed, S_IRUGO, show_fcport_speed, NULL);
+
+fc_fcport_rd_attr(maxframe_size, "%u bytes\n", 20);
+fc_fcport_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
+
+static ssize_t show_fcport_supported_speeds(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	if (fcport_supported_speeds(fcport) == FC_PORTSPEED_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+
+	return get_fc_port_speed_names(fcport_supported_speeds(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, supported_speeds, S_IRUGO,
+		      show_fcport_supported_speeds, NULL);
+
+static ssize_t show_fcport_supported_classes(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+
+	if (fcport_supported_classes(fcport) == FC_COS_UNSPECIFIED)
+		return snprintf(buf, 20, "unspecified\n");
+
+	return get_fc_cos_names(fcport_supported_classes(fcport), buf);
+}
+static FC_DEVICE_ATTR(fcport, supported_classes, S_IRUGO,
+		      show_fcport_supported_classes, NULL);
+
+
+/*
+ * TODO: I think I should be using the classes' release function instead
+ * of setting it directly in fc_fcport_add.
+ *
+ * .dev_release = fc_fcport_cls_release,
+ */
+struct class fc_class = {
+	.name = "fcport",
+};
+EXPORT_SYMBOL(fc_class);
+
+static void fc_fcport_release(struct device *dev)
+{
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	put_device(fcport->gendev.parent);
+	kfree(fcport);
+}
+
+void fc_fcport_del(struct fc_fcport *fcport)
+{
+	device_del(&fcport->gendev);
+	put_device(&fcport->gendev); /* self-reference */
+}
+EXPORT_SYMBOL(fc_fcport_del);
+
+static inline int get_fcport_id(void)
+{
+	return fcport_count++;
+}
+
+struct fc_fcport *fc_fcport_add(struct device *pdev,
+				struct fcport_function_template *fcn_tmpl)
+{
+	struct fc_fcport *fcport;
+	int count = 0;
+	int error = 0;
+
+	fcport = kzalloc(sizeof(struct fc_fcport), GFP_KERNEL);
+	if (!fcport)
+		goto out;
+	fcport->id = get_fcport_id();
+	device_initialize(&fcport->gendev);
+	fcport->gendev.parent = get_device(pdev);
+	fcport->gendev.release = fc_fcport_release;
+	fcport->gendev.class = &fc_class;
+	fcport->f = fcn_tmpl;
+	dev_set_name(&fcport->gendev, "fcport%d", get_fcport_id());
+
+	error = device_add(&fcport->gendev);
+	if (error)
+		goto out_del_gendev;
+
+	fcport->maxframe_size = -1;
+	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	fcport->supported_speeds = FC_PORTSPEED_UNKNOWN;
+	fcport->speed = FC_PORTSPEED_UNKNOWN;
+	memset(fcport->supported_fc4s, 0,
+	       sizeof(fcport->supported_fc4s));
+	memset(fcport->active_fc4s, 0,
+	       sizeof(fcport->active_fc4s));
+	memset(fcport->serial_number, 0,
+	       sizeof(fcport->serial_number));
+
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, maxframe_size);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, supported_speeds);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, speed);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, supported_fc4s);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, active_fc4s);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, supported_classes);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcport, serial_number);
+
+	BUG_ON(count > FCPORT_NUM_ATTRS);
+	FC_CREATE_ATTRIBUTES(fcport);
+
+	if (error || count != 0)
+		goto out_del_gendev;
+
+	return fcport;
+
+out_del_gendev:
+	device_del(&fcport->gendev);
+	kfree(fcport);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcport_add);
+
+int fc_class_del_children(struct device *dev, void *data)
+{
+	int error = 0;
+	struct fc_fcport *fcport = dev_to_fcport(dev);
+	error = device_for_each_child(dev, NULL, fc_fcfport_del_children);
+	if (!error)
+		fc_fcport_del(fcport);
+	return error;
+}
diff --git a/drivers/scsi/fc/fcsysfs.c b/drivers/scsi/fc/fcsysfs.c
new file mode 100644
index 0000000..2b9293a
--- /dev/null
+++ b/drivers/scsi/fc/fcsysfs.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fc_sysfs.h"
+
+MODULE_AUTHOR("Robert Love");
+MODULE_DESCRIPTION("fc_sysfs");
+MODULE_LICENSE("GPL v2");
+
+static int __init fc_sysfs_init(void)
+{
+	int error = class_register(&fc_class);
+	if (error)
+		return error;
+
+	return 0;
+}
+module_init(fc_sysfs_init);
+
+static void __exit fc_sysfs_exit(void)
+{
+	class_for_each_device(&fc_class, NULL,
+			      NULL, fc_class_del_children);
+
+	class_unregister(&fc_class);
+}
+module_exit(fc_sysfs_exit);
diff --git a/drivers/scsi/fc/fcvport.c b/drivers/scsi/fc/fcvport.c
new file mode 100644
index 0000000..1208f38
--- /dev/null
+++ b/drivers/scsi/fc/fcvport.c
@@ -0,0 +1,485 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "fc_sysfs.h"
+
+static int fcvport_count = 0;
+
+static void fc_vport_sched_delete(struct work_struct *work);
+
+#define fcvport_rd_attr(field, format_string, sz)			\
+	fc_conditional_show_function(fcvport, field, format_string, sz, ) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fc_private_fcvport_rd_attr(field, format_string, sz)		\
+	fc_always_show_function(fcvport, field, format_string, sz, )	\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fc_private_fcvport_rd_attr_cast(field, format_string, sz, cast)	\
+	fc_always_show_function(fcvport, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+/* Convert fc_vport_state values to ascii string name */
+static struct {
+	enum fc_vport_state	value;
+	char			*name;
+} fc_vport_state_names[] = {
+	{ FC_VPORT_UNKNOWN,		"Unknown" },
+	{ FC_VPORT_ACTIVE,		"Active" },
+	{ FC_VPORT_DISABLED,		"Disabled" },
+	{ FC_VPORT_LINKDOWN,		"Linkdown" },
+	{ FC_VPORT_INITIALIZING,	"Initializing" },
+	{ FC_VPORT_NO_FABRIC_SUPP,	"No Fabric Support" },
+	{ FC_VPORT_NO_FABRIC_RSCS,	"No Fabric Resources" },
+	{ FC_VPORT_FABRIC_LOGOUT,	"Fabric Logout" },
+	{ FC_VPORT_FABRIC_REJ_WWN,	"Fabric Rejected WWN" },
+	{ FC_VPORT_FAILED,		"VPort Failed" },
+};
+fc_enum_name_search(vport_state, fc_vport_state, fc_vport_state_names)
+#define FC_VPORTSTATE_MAX_NAMELEN	24
+
+/* Reuse fc_vport_state enum function for vport_last_state */
+#define get_fc_vport_last_state_name get_fc_vport_state_name
+
+/*
+ * TODO: Notce that we're still using get_fc_##title##_name and not
+ * a get_fcvport_##title##_name routine. The port_type structure,
+ * related lookups and names need to be somewhere global for rports
+ * and other fc_host obects.
+ */
+#define fcvport_rd_enum_attr(title, maxlen)				\
+	static ssize_t show_fcvport_##title (struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	const char *name;						\
+	if (fcvport->f->get_fcvport_##title)				\
+		fcvport->f->get_fcvport_##title(fcvport);		\
+	name = get_fc_##title##_name(fcvport_##title(fcvport));		\
+	if (!name)							\
+		return -EINVAL;						\
+	return snprintf(buf, maxlen, "%s\n", name);			\
+}									\
+static FC_DEVICE_ATTR(fcvport, title, S_IRUGO, show_fcvport_##title, NULL)
+
+#define fcvport_store_function(field)					\
+	static ssize_t store_fcvport_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     const char *buf, size_t count) \
+{									\
+	int val;							\
+	struct fc_vport *vport = transport_class_to_vport(dev);		\
+	struct Scsi_Host *shost = vport_to_shost(vport);		\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	char *cp;							\
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	i->f->set_vport_##field(vport, val);				\
+	return count;							\
+}
+
+#define fcvport_store_str_function(field, slen)				\
+	static ssize_t store_fcvport_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     const char *buf, size_t count) \
+{									\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	unsigned int cnt = count;					\
+									\
+	/* count may include a LF at end of string */			\
+	if (buf[cnt-1] == '\n')						\
+		cnt--;							\
+	if (cnt > ((slen) - 1))						\
+		return -EINVAL;						\
+	memcpy(fcvport->field, buf, cnt);				\
+	fcvport->f->set_fcvport_##field(fcvport);			\
+	return count;							\
+}
+
+#define fcvport_rd_attr(field, format_string, sz)			\
+	fc_conditional_show_function(fcvport, field, format_string, sz, ) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fcvport_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_conditional_show_function(fcvport, field, format_string, sz, (cast)) \
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO,			\
+			      show_fcvport_##field, NULL)
+
+#define fc_vport_rw_attr(field, format_string, sz)			\
+	fc_conditional_show_function(fcvport, field, format_string, sz, ) \
+	fcvport_store_function(field)					\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO | S_IWUSR,	\
+			      show_fcvport_##field,			\
+			      store_fcvport_##field)
+
+#define fc_private_fcvport_store_u32_function(field)			\
+	static ssize_t store_fcvport_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     const char *buf, size_t count) \
+{									\
+	u32 val;							\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	char *cp;							\
+	if (fcvport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	fcvport->field = val;						\
+	return count;							\
+}
+
+
+#define fc_private_fcvport_rw_u32_attr(field, format_string, sz)	\
+	fc_always_show_function(fcvport, field, format_string, sz, )	\
+	fc_private_fcvport_store_u32_function(field)			\
+	static FC_DEVICE_ATTR(fcvport, field, S_IRUGO | S_IWUSR,	\
+			      show_fcvport_##field,			\
+			      store_fcvport_##field)
+
+
+#define fc_private_fcvport_rd_enum_attr(title, maxlen)			\
+	static ssize_t show_fcvport_##title (struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);		\
+	const char *name;						\
+	name = get_fc_##title##_name(fcvport->title);			\
+	if (!name)							\
+		return -EINVAL;						\
+	return snprintf(buf, maxlen, "%s\n", name);			\
+}									\
+	static FC_DEVICE_ATTR(fcvport, title, S_IRUGO,			\
+			      show_fcvport_##title, NULL)
+
+/*
+ * TODO: I'm not sure how this macro is supposed to work. Why would there
+ * be a "field" in the function template? It's for vport_delete and
+ * vport_destroy, but I don't get it!
+ */
+#define SETUP_FCVPORT_ATTRIBUTE_WR(field)				\
+	if (fcvport->f->field) {					\
+		fcvport->attrs[count] = device_attr_fcvport_##field;	\
+		device_create_file(&fcvport->gendev, &fcvport->attrs[count]); \
+		count++;						\
+	}
+	/* NOTE: Above MACRO differs: checks function */
+
+#define SETUP_FCVPORT_ATTRIBUTE_RW(field)				\
+	if (!fcvport->f->set_fcvport_##field) {				\
+		fcvport->attrs[count] = device_attr_fcvport_##field;	\
+		fcvport->attrs[count].attr.mode = S_IRUGO;		\
+		fcvport->attrs[count].store = NULL;			\
+		count++;						\
+	}
+	/* NOTE: Above MACRO differs: does not check show bit */
+
+#define SETUP_PRIVATE_FCVPORT_ATTRIBUTE_RW(field)			\
+{									\
+	fcvport->attrs[count] = device_attr_fcvport_##field;		\
+	count++;							\
+}
+
+
+/* The FC Transport Virtual Port Attributes: */
+
+/* Fixed Virtual Port Attributes */
+
+/* Dynamic Virtual Port Attributes */
+
+/* Private Virtual Port Attributes */
+
+fc_private_fcvport_rd_enum_attr(vport_state, FC_VPORTSTATE_MAX_NAMELEN);
+fc_private_fcvport_rd_enum_attr(vport_last_state, FC_VPORTSTATE_MAX_NAMELEN);
+fc_private_fcvport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
+fc_private_fcvport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+
+static ssize_t show_fcvport_roles(struct device *dev, struct device_attribute *attr,
+				  char *buf)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+
+	if (fcvport->roles == FC_PORT_ROLE_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+	return get_fc_port_roles_names(fcvport->roles, buf);
+}
+static FC_DEVICE_ATTR(fcvport, roles, S_IRUGO, show_fcvport_roles, NULL);
+
+fc_private_fcvport_rd_enum_attr(vport_type, FC_PORTTYPE_MAX_NAMELEN);
+
+fc_always_show_function(fcvport, symbolic_name, "%s\n",
+			FC_VPORT_SYMBOLIC_NAMELEN + 1, )
+fcvport_store_str_function(symbolic_name, FC_VPORT_SYMBOLIC_NAMELEN)
+static FC_DEVICE_ATTR(fcvport, symbolic_name, S_IRUGO | S_IWUSR,
+		      show_fcvport_symbolic_name, store_fcvport_symbolic_name);
+
+/*
+static ssize_t
+store_fc_vport_delete(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct fc_vport *vport = transport_class_to_vport(dev);
+	struct Scsi_Host *shost = vport_to_shost(vport);
+
+	fc_queue_work(shost, &vport->vport_delete_work);
+	return count;
+}
+static FC_DEVICE_ATTR(vport, vport_delete, S_IWUSR,
+			NULL, store_fc_vport_delete);
+
+
+*
+ * Enable/Disable vport
+ *  Write "1" to disable, write "0" to enable
+ *
+static ssize_t
+store_fc_vport_disable(struct device *dev, struct device_attribute *attr,
+		       const char *buf,
+			   size_t count)
+{
+	struct fc_vport *vport = transport_class_to_vport(dev);
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int stat;
+
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
+		return -EBUSY;
+
+	if (*buf == '0') {
+		if (vport->vport_state != FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else if (*buf == '1') {
+		if (vport->vport_state == FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else
+		return -EINVAL;
+
+	stat = i->f->vport_disable(vport, ((*buf == '0') ? false : true));
+	return stat ? stat : count;
+}
+static FC_DEVICE_ATTR(vport, vport_disable, S_IWUSR,
+		NULL, store_fc_vport_disable);
+*/
+
+fcvport_rd_attr(port_id, "0x%06x\n", 20);
+fcvport_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
+
+static void fc_fcvport_release(struct device *dev)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	put_device(fcvport->gendev.parent);
+	kfree(fcvport);
+}
+
+void fc_fcvport_del(struct fc_fcvport *fcvport)
+{
+	device_del(&fcvport->gendev);
+	put_device(&fcvport->gendev); /* self-reference */
+}
+
+static inline int get_fcvport_id(void)
+{
+	return fcvport_count++;
+}
+
+struct fc_fcvport *fc_fcvport_alloc(struct fc_fcfabric *fcfabric,
+				    struct fc_vport_identifiers *ids,
+				    struct fcvport_function_template *fcn_tmpl,
+				    int priv_size)
+{
+	struct fc_fcvport *fcvport, *fcnport;
+	unsigned long flags;
+	int error = 0;
+	int id = get_fcvport_id();
+
+	/*
+	 * TODO: Should probably pass in the WWPN to use as the fcvport's
+	 * id. Right now we're just using a counter.
+	 */
+	fcvport = kzalloc(sizeof(struct fc_fcvport) + priv_size, GFP_KERNEL);
+	if (!fcvport)
+		return NULL;
+
+	fcvport->vport_state = FC_VPORT_UNKNOWN;
+	fcvport->vport_last_state = FC_VPORT_UNKNOWN;
+	fcvport->node_name = ids->node_name;
+	fcvport->port_name = ids->port_name;
+	fcvport->roles = ids->roles;
+	fcvport->vport_type = ids->vport_type;
+	fcvport->id = id;
+	fcvport->port_type = FC_PORTTYPE_UNKNOWN;
+
+	/*
+	 * TODO: Another example of badness due to passing in NULL
+	 * for the fcfabric when creating a N_Port.
+	 */
+	if (fcfabric) {
+		if (fcfabric->f->dd_fcvport_size)
+			fcvport->dd_data = &fcvport[1];
+	}
+
+	/*
+	 * TODO: This is really bad. N_Ports will be passing NULL in
+	 * and vports will be passing a real fabric in. This must be
+	 * fixed.
+	 */
+	fcvport->fcfabric = fcfabric;
+
+	INIT_WORK(&fcvport->vport_delete_work, fc_vport_sched_delete);
+	spin_lock_init(&fcvport->lock);
+	device_initialize(&fcvport->gendev);
+
+	fcvport->gendev.release = fc_fcvport_release;
+	fcvport->f = fcn_tmpl;
+
+	dev_set_name(&fcvport->gendev, "fcvport_%d", id);
+
+	/*
+	 * TODO: This is ugly. We're doing different cases for N_Ports
+	 * and VN_Ports since there's no fcfabric passed in for N_Ports.
+	 */
+	if (fcfabric) {
+		/*
+		 * TODO: Is this correct? Should vports always be created
+		 * in the enabled (i.e. 0) state? The previous
+		 * store_fc_host_vport_create() was zero'ing the memory,
+		 * so I think they're always !disabled.
+		 */
+		fcnport = fc_fcfabric_find_nport(fcfabric);
+		if (!fcnport)
+			return NULL;
+
+		error = fcfabric->f->vport_create(fcnport->priv_data, fcvport, 0);
+		if (error)
+			goto delete_vport_all;
+	}
+
+	spin_lock_irqsave(&fcvport->lock, flags);
+	fcvport->flags &= ~FC_VPORT_CREATING;
+	spin_unlock_irqrestore(&fcvport->lock, flags);
+
+	/*
+	 * TODO: We probably want to re-add a dev_printk here
+	 dev_printk(KERN_NOTICE, pdev,
+	 "%s created via shost%d channel %d\n", dev_name(dev),
+	 shost->host_no, channel);
+	*/
+	return fcvport;
+
+delete_vport_all:
+/*
+ * TODO: Double check this routines error handling,
+ * we probably need to clean up more here.
+ */
+	kfree(fcvport);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_fcvport_alloc);
+
+int fc_fcvport_add(struct fc_fcvport *fcvport,
+		   struct fc_fcfabric *fcfabric)
+{
+	int count = 0;
+	int error = 0;
+
+	fcvport->gendev.parent = get_device(&fcfabric->gendev);
+
+	/*
+	 * TODO: Should the device be free'd if the
+	 * device_add() fails?
+	 */
+	error = device_add(&fcvport->gendev);
+	if (error)
+		return error;
+
+	/* TODO: Check for failure */
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, port_id);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, node_name);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, port_name);
+	FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(fcvport, port_type);
+
+	/*
+	 * Setup Virtual Port Attributes.
+	 */
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, vport_state);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, vport_last_state);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, roles);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, vport_type);
+	FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(fcvport, symbolic_name);
+
+	/* TODO: FIX THIS
+	SETUP_VPORT_ATTRIBUTE_WR(vport_delete);
+	SETUP_VPORT_ATTRIBUTE_WR(vport_disable);
+	*/
+
+	BUG_ON(count > FCVPORT_NUM_ATTRS);
+	FC_CREATE_ATTRIBUTES(fcvport);
+
+	if (error || count != 0)
+		return error;
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_fcvport_add);
+
+int fc_fcvport_del_children(struct device *dev, void *data)
+{
+	int error = 0;
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	error = device_for_each_child(dev, NULL, fc_fcpinit_del_children);
+	if (!error)
+		fc_fcvport_del(fcvport);
+	return error;
+}
+
+int fc_fcvport_is_nport(struct device *dev, void *data)
+{
+	struct fc_fcvport *fcvport = dev_to_fcvport(dev);
+	if (fcvport_port_type(fcvport) == FC_PORTTYPE_NPORT)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(fc_fcvport_is_nport);
+
+/**
+ * fc_vport_sched_delete - workq-based delete request for a vport
+ * @work:	vport to be deleted.
+ */
+static void
+fc_vport_sched_delete(struct work_struct *work)
+{
+	struct fc_fcvport *vport =
+		container_of(work, struct fc_fcvport, vport_delete_work);
+	int stat;
+
+	stat = fc_vport_terminate(vport->fcfabric, vport);
+	if (stat)
+		dev_printk(KERN_ERR, vport->gendev.parent,
+			"%s: %s could not be deleted created via "
+			"shost%d channel %d - error %d\n", __func__,
+			dev_name(&vport->gendev), vport->shost->host_no,
+			vport->channel, stat);
+}
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 653f22a..8d2f716 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -39,17 +39,56 @@
 #include <scsi/scsi_bsg_fc.h>
 #include "scsi_priv.h"
 #include "scsi_transport_fc_internal.h"
+#include <scsi/fc.h>
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
-static void fc_vport_sched_delete(struct work_struct *work);
-static int fc_vport_setup(struct Scsi_Host *shost, int channel,
-	struct device *pdev, struct fc_vport_identifiers  *ids,
-	struct fc_vport **vport);
-static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
+static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_fcpinit *);
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
 static void fc_bsg_goose_queue(struct fc_rport *);
 
+
+struct _fc_port_types fc_port_type_names[] = {
+	{ FC_PORTTYPE_UNKNOWN,		"Unknown" },
+	{ FC_PORTTYPE_OTHER,		"Other" },
+	{ FC_PORTTYPE_NOTPRESENT,	"Not Present" },
+	{ FC_PORTTYPE_NPORT,	"NPort (fabric via point-to-point)" },
+	{ FC_PORTTYPE_NLPORT,	"NLPort (fabric via loop)" },
+	{ FC_PORTTYPE_LPORT,	"LPort (private loop)" },
+	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection)" },
+	{ FC_PORTTYPE_NPIV,		"NPIV VPORT" },
+};
+/* Convert fc_port_type values to ascii string name */
+fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
+EXPORT_SYMBOL(get_fc_port_type_name);
+fc_enum_name_search(vport_type, fc_port_type, fc_port_type_names)
+EXPORT_SYMBOL(get_fc_vport_type_name);
+
+struct _fc_port_role_names  fc_port_role_names[] = {
+	{ FC_PORT_ROLE_FCP_TARGET,	"FCP Target" },
+	{ FC_PORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
+	{ FC_PORT_ROLE_IP_PORT,		"IP Port" },
+};
+/* Convert FC_PORT_ROLE bit values to ascii string name */
+fc_bitfield_name_search(port_roles, fc_port_role_names)
+EXPORT_SYMBOL(get_fc_port_roles_names);
+
+struct _fc_cos_names fc_cos_names[] = {
+	{ FC_COS_CLASS1,	"Class 1" },
+	{ FC_COS_CLASS2,	"Class 2" },
+	{ FC_COS_CLASS3,	"Class 3" },
+	{ FC_COS_CLASS4,	"Class 4" },
+	{ FC_COS_CLASS6,	"Class 6" },
+};
+
+/* Convert FC_COS bit values to ascii string name */
+fc_bitfield_name_search(cos, fc_cos_names)
+EXPORT_SYMBOL(get_fc_cos_names);
+
+/* Reuse fc_port_type enum function for vport_type */
+//#define get_fc_vport_type_name get_fc_port_type_name
+
+
 /*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
@@ -58,21 +97,6 @@ static void fc_bsg_goose_queue(struct fc_rport *);
 struct device_attribute device_attr_##_prefix##_##_name = 	\
 	__ATTR(_name,_mode,_show,_store)
 
-#define fc_enum_name_search(title, table_type, table)			\
-static const char *get_fc_##title##_name(enum table_type table_key)	\
-{									\
-	int i;								\
-	char *name = NULL;						\
-									\
-	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
-		if (table[i].value == table_key) {			\
-			name = table[i].name;				\
-			break;						\
-		}							\
-	}								\
-	return name;							\
-}
-
 #define fc_enum_name_match(title, table_type, table)			\
 static int get_fc_##title##_match(const char *table_key,		\
 		enum table_type *value)					\
@@ -89,33 +113,11 @@ static int get_fc_##title##_match(const char *table_key,		\
 	return 1; /* failure */						\
 }
 
-
-/* Convert fc_port_type values to ascii string name */
-static struct {
-	enum fc_port_type	value;
-	char			*name;
-} fc_port_type_names[] = {
-	{ FC_PORTTYPE_UNKNOWN,		"Unknown" },
-	{ FC_PORTTYPE_OTHER,		"Other" },
-	{ FC_PORTTYPE_NOTPRESENT,	"Not Present" },
-	{ FC_PORTTYPE_NPORT,	"NPort (fabric via point-to-point)" },
-	{ FC_PORTTYPE_NLPORT,	"NLPort (fabric via loop)" },
-	{ FC_PORTTYPE_LPORT,	"LPort (private loop)" },
-	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection)" },
-	{ FC_PORTTYPE_NPIV,		"NPIV VPORT" },
-};
-fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
-#define FC_PORTTYPE_MAX_NAMELEN		50
-
-/* Reuse fc_port_type enum function for vport_type */
-#define get_fc_vport_type_name get_fc_port_type_name
-
-
-/* Convert fc_host_event_code values to ascii string name */
+/* Convert fcpinit_event_code values to ascii string name */
 static const struct {
-	enum fc_host_event_code		value;
+	enum fcpinit_event_code		value;
 	char				*name;
-} fc_host_event_code_names[] = {
+} fcpinit_event_code_names[] = {
 	{ FCH_EVT_LIP,			"lip" },
 	{ FCH_EVT_LINKUP,		"link_up" },
 	{ FCH_EVT_LINKDOWN,		"link_down" },
@@ -129,9 +131,9 @@ static const struct {
 	{ FCH_EVT_LINK_UNKNOWN,		"link_unknown" },
 	{ FCH_EVT_VENDOR_UNIQUE,	"vendor_unique" },
 };
-fc_enum_name_search(host_event_code, fc_host_event_code,
-		fc_host_event_code_names)
-#define FC_HOST_EVENT_CODE_MAX_NAMELEN	30
+fc_enum_name_search(fcpinit_event_code, fcpinit_event_code,
+		    fcpinit_event_code_names)
+#define FCPINIT_EVENT_CODE_MAX_NAMELEN	30
 
 
 /* Convert fc_port_state values to ascii string name */
@@ -154,30 +156,6 @@ static struct {
 fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
 #define FC_PORTSTATE_MAX_NAMELEN	20
 
-
-/* Convert fc_vport_state values to ascii string name */
-static struct {
-	enum fc_vport_state	value;
-	char			*name;
-} fc_vport_state_names[] = {
-	{ FC_VPORT_UNKNOWN,		"Unknown" },
-	{ FC_VPORT_ACTIVE,		"Active" },
-	{ FC_VPORT_DISABLED,		"Disabled" },
-	{ FC_VPORT_LINKDOWN,		"Linkdown" },
-	{ FC_VPORT_INITIALIZING,	"Initializing" },
-	{ FC_VPORT_NO_FABRIC_SUPP,	"No Fabric Support" },
-	{ FC_VPORT_NO_FABRIC_RSCS,	"No Fabric Resources" },
-	{ FC_VPORT_FABRIC_LOGOUT,	"Fabric Logout" },
-	{ FC_VPORT_FABRIC_REJ_WWN,	"Fabric Rejected WWN" },
-	{ FC_VPORT_FAILED,		"VPort Failed" },
-};
-fc_enum_name_search(vport_state, fc_vport_state, fc_vport_state_names)
-#define FC_VPORTSTATE_MAX_NAMELEN	24
-
-/* Reuse fc_vport_state enum function for vport_last_state */
-#define get_fc_vport_last_state_name get_fc_vport_state_name
-
-
 /* Convert fc_tgtid_binding_type values to ascii string name */
 static const struct {
 	enum fc_tgtid_binding_type	value;
@@ -195,80 +173,6 @@ fc_enum_name_match(tgtid_bind_type, fc_tgtid_binding_type,
 		fc_tgtid_binding_type_names)
 #define FC_BINDTYPE_MAX_NAMELEN	30
 
-
-#define fc_bitfield_name_search(title, table)			\
-static ssize_t							\
-get_fc_##title##_names(u32 table_key, char *buf)		\
-{								\
-	char *prefix = "";					\
-	ssize_t len = 0;					\
-	int i;							\
-								\
-	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
-		if (table[i].value & table_key) {		\
-			len += sprintf(buf + len, "%s%s",	\
-				prefix, table[i].name);		\
-			prefix = ", ";				\
-		}						\
-	}							\
-	len += sprintf(buf + len, "\n");			\
-	return len;						\
-}
-
-
-/* Convert FC_COS bit values to ascii string name */
-static const struct {
-	u32 			value;
-	char			*name;
-} fc_cos_names[] = {
-	{ FC_COS_CLASS1,	"Class 1" },
-	{ FC_COS_CLASS2,	"Class 2" },
-	{ FC_COS_CLASS3,	"Class 3" },
-	{ FC_COS_CLASS4,	"Class 4" },
-	{ FC_COS_CLASS6,	"Class 6" },
-};
-fc_bitfield_name_search(cos, fc_cos_names)
-
-
-/* Convert FC_PORTSPEED bit values to ascii string name */
-static const struct {
-	u32 			value;
-	char			*name;
-} fc_port_speed_names[] = {
-	{ FC_PORTSPEED_1GBIT,		"1 Gbit" },
-	{ FC_PORTSPEED_2GBIT,		"2 Gbit" },
-	{ FC_PORTSPEED_4GBIT,		"4 Gbit" },
-	{ FC_PORTSPEED_10GBIT,		"10 Gbit" },
-	{ FC_PORTSPEED_8GBIT,		"8 Gbit" },
-	{ FC_PORTSPEED_16GBIT,		"16 Gbit" },
-	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
-};
-fc_bitfield_name_search(port_speed, fc_port_speed_names)
-
-
-static int
-show_fc_fc4s (char *buf, u8 *fc4_list)
-{
-	int i, len=0;
-
-	for (i = 0; i < FC_FC4_LIST_SIZE; i++, fc4_list++)
-		len += sprintf(buf + len , "0x%02x ", *fc4_list);
-	len += sprintf(buf + len, "\n");
-	return len;
-}
-
-
-/* Convert FC_PORT_ROLE bit values to ascii string name */
-static const struct {
-	u32 			value;
-	char			*name;
-} fc_port_role_names[] = {
-	{ FC_PORT_ROLE_FCP_TARGET,	"FCP Target" },
-	{ FC_PORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
-	{ FC_PORT_ROLE_IP_PORT,		"IP Port" },
-};
-fc_bitfield_name_search(port_roles, fc_port_role_names)
-
 /*
  * Define roles that are specific to port_id. Values are relative to ROLE_MASK.
  */
@@ -291,8 +195,6 @@ static void fc_scsi_scan_rport(struct work_struct *work);
  */
 #define FC_STARGET_NUM_ATTRS 	3
 #define FC_RPORT_NUM_ATTRS	10
-#define FC_VPORT_NUM_ATTRS	9
-#define FC_HOST_NUM_ATTRS	22
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -308,20 +210,16 @@ struct fc_internal {
 	 * part of the midlayer. As the remote port is specific to the
 	 * fc transport, we must provide the attribute container.
 	 */
-	struct device_attribute private_starget_attrs[
-							FC_STARGET_NUM_ATTRS];
+	struct device_attribute private_starget_attrs[FC_STARGET_NUM_ATTRS];
 	struct device_attribute *starget_attrs[FC_STARGET_NUM_ATTRS + 1];
 
-	struct device_attribute private_host_attrs[FC_HOST_NUM_ATTRS];
-	struct device_attribute *host_attrs[FC_HOST_NUM_ATTRS + 1];
+	/* These are the fcpinit attributes */
+	struct device_attribute private_host_attrs[FCPINIT_NUM_ATTRS];
+	struct device_attribute *host_attrs[FCPINIT_NUM_ATTRS + 1];
 
 	struct transport_container rport_attr_cont;
 	struct device_attribute private_rport_attrs[FC_RPORT_NUM_ATTRS];
 	struct device_attribute *rport_attrs[FC_RPORT_NUM_ATTRS + 1];
-
-	struct transport_container vport_attr_cont;
-	struct device_attribute private_vport_attrs[FC_VPORT_NUM_ATTRS];
-	struct device_attribute *vport_attrs[FC_VPORT_NUM_ATTRS + 1];
 };
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
@@ -356,87 +254,67 @@ static DECLARE_TRANSPORT_CLASS(fc_transport_class,
 			       NULL,
 			       NULL);
 
-static int fc_host_setup(struct transport_container *tc, struct device *dev,
+static int fcpinit_setup(struct transport_container *tc, struct device *dev,
 			 struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fcpinit *fcpinit = shost_to_fcpinit(shost);
 
 	/*
 	 * Set default values easily detected by the midlayer as
 	 * failure cases.  The scsi lldd is responsible for initializing
 	 * all transport attributes to valid values per host.
 	 */
-	fc_host->node_name = -1;
-	fc_host->port_name = -1;
-	fc_host->permanent_port_name = -1;
-	fc_host->supported_classes = FC_COS_UNSPECIFIED;
-	memset(fc_host->supported_fc4s, 0,
-		sizeof(fc_host->supported_fc4s));
-	fc_host->supported_speeds = FC_PORTSPEED_UNKNOWN;
-	fc_host->maxframe_size = -1;
-	fc_host->max_npiv_vports = 0;
-	memset(fc_host->serial_number, 0,
-		sizeof(fc_host->serial_number));
-
-	fc_host->port_id = -1;
-	fc_host->port_type = FC_PORTTYPE_UNKNOWN;
-	fc_host->port_state = FC_PORTSTATE_UNKNOWN;
-	memset(fc_host->active_fc4s, 0,
-		sizeof(fc_host->active_fc4s));
-	fc_host->speed = FC_PORTSPEED_UNKNOWN;
-	fc_host->fabric_name = -1;
-	memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
-	memset(fc_host->system_hostname, 0, sizeof(fc_host->system_hostname));
-
-	fc_host->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
-
-	INIT_LIST_HEAD(&fc_host->rports);
-	INIT_LIST_HEAD(&fc_host->rport_bindings);
-	INIT_LIST_HEAD(&fc_host->vports);
-	fc_host->next_rport_number = 0;
-	fc_host->next_target_id = 0;
-	fc_host->next_vport_number = 0;
-	fc_host->npiv_vports_inuse = 0;
-
-	snprintf(fc_host->work_q_name, sizeof(fc_host->work_q_name),
+	fcpinit->permanent_port_name = -1;
+
+	fcpinit->port_state = FC_PORTSTATE_UNKNOWN;
+	memset(fcpinit->system_hostname, 0, sizeof(fcpinit->system_hostname));
+
+	fcpinit->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
+
+	INIT_LIST_HEAD(&fcpinit->rports);
+	INIT_LIST_HEAD(&fcpinit->rport_bindings);
+	fcpinit->next_rport_number = 0;
+	fcpinit->next_target_id = 0;
+
+	snprintf(fcpinit->work_q_name, sizeof(fcpinit->work_q_name),
 		 "fc_wq_%d", shost->host_no);
-	fc_host->work_q = create_singlethread_workqueue(
-					fc_host->work_q_name);
-	if (!fc_host->work_q)
+	fcpinit->work_q = create_singlethread_workqueue(
+					fcpinit->work_q_name);
+	if (!fcpinit->work_q)
 		return -ENOMEM;
 
-	snprintf(fc_host->devloss_work_q_name,
-		 sizeof(fc_host->devloss_work_q_name),
+	snprintf(fcpinit->devloss_work_q_name,
+		 sizeof(fcpinit->devloss_work_q_name),
 		 "fc_dl_%d", shost->host_no);
-	fc_host->devloss_work_q = create_singlethread_workqueue(
-					fc_host->devloss_work_q_name);
-	if (!fc_host->devloss_work_q) {
-		destroy_workqueue(fc_host->work_q);
-		fc_host->work_q = NULL;
+	fcpinit->devloss_work_q = create_singlethread_workqueue(
+					fcpinit->devloss_work_q_name);
+	if (!fcpinit->devloss_work_q) {
+		destroy_workqueue(fcpinit->work_q);
+		fcpinit->work_q = NULL;
 		return -ENOMEM;
 	}
 
-	fc_bsg_hostadd(shost, fc_host);
+	fc_bsg_hostadd(shost, fcpinit);
 	/* ignore any bsg add error - we just can't do sgio */
 
 	return 0;
 }
 
-static int fc_host_remove(struct transport_container *tc, struct device *dev,
-			 struct device *cdev)
+static int fcpinit_remove(struct transport_container *tc, struct device *dev,
+			  struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fcpinit *fcpinit = shost_to_fcpinit(shost);
 
-	fc_bsg_remove(fc_host->rqst_q);
+	fc_bsg_remove(fcpinit->rqst_q);
 	return 0;
 }
 
-static DECLARE_TRANSPORT_CLASS(fc_host_class,
-			       "fc_host",
-			       fc_host_setup,
-			       fc_host_remove,
+static DECLARE_TRANSPORT_CLASS(fcpinit_class,
+			       "fcpinit",
+			       fcpinit_setup,
+			       fcpinit_remove,
 			       NULL);
 
 /*
@@ -450,16 +328,6 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_class,
 			       NULL);
 
 /*
- * Setup and Remove actions for virtual ports are handled
- * in the service functions below.
- */
-static DECLARE_TRANSPORT_CLASS(fc_vport_class,
-			       "fc_vports",
-			       NULL,
-			       NULL,
-			       NULL);
-
-/*
  * Module Parameters
  */
 
@@ -500,18 +368,18 @@ EXPORT_SYMBOL(fc_get_event_number);
 
 
 /**
- * fc_host_post_event - called to post an even on an fc_host.
+ * fcpinit_post_event - called to post an even on an fcpinit.
  * @shost:		host the event occurred on
  * @event_number:	fc event number obtained from get_fc_event_number()
- * @event_code:		fc_host event being posted
+ * @event_code:		fcpinit event being posted
  * @event_data:		32bits of data for the event being posted
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
  */
 void
-fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
-		enum fc_host_event_code event_code, u32 event_data)
+fcpinit_post_event(struct Scsi_Host *shost, u32 event_number,
+		   enum fcpinit_event_code event_code, u32 event_data)
 {
 	struct sk_buff *skb;
 	struct nlmsghdr	*nlh;
@@ -559,18 +427,18 @@ fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
 send_fail_skb:
 	kfree_skb(skb);
 send_fail:
-	name = get_fc_host_event_code_name(event_code);
+	name = get_fc_fcpinit_event_code_name(event_code);
 	printk(KERN_WARNING
 		"%s: Dropped Event : host %d %s data 0x%08x - err %d\n",
 		__func__, shost->host_no,
 		(name) ? name : "<unknown>", event_data, err);
 	return;
 }
-EXPORT_SYMBOL(fc_host_post_event);
+EXPORT_SYMBOL(fcpinit_post_event);
 
 
 /**
- * fc_host_post_vendor_event - called to post a vendor unique event on an fc_host
+ * fcpinit_post_vendor_event - called to post a vendor unique event on an fcpinit
  * @shost:		host the event occurred on
  * @event_number:	fc event number obtained from get_fc_event_number()
  * @data_len:		amount, in bytes, of vendor unique data
@@ -581,8 +449,8 @@ EXPORT_SYMBOL(fc_host_post_event);
  *	This routine assumes no locks are held on entry.
  */
 void
-fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
-		u32 data_len, char * data_buf, u64 vendor_id)
+fcpinit_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
+			  u32 data_len, char * data_buf, u64 vendor_id)
 {
 	struct sk_buff *skb;
 	struct nlmsghdr	*nlh;
@@ -634,7 +502,7 @@ send_vendor_fail:
 		__func__, shost->host_no, err);
 	return;
 }
-EXPORT_SYMBOL(fc_host_post_vendor_event);
+EXPORT_SYMBOL(fcpinit_post_vendor_event);
 
 
 
@@ -644,15 +512,12 @@ static __init int fc_transport_init(void)
 
 	atomic_set(&fc_event_seq, 0);
 
-	error = transport_class_register(&fc_host_class);
+	error = transport_class_register(&fcpinit_class);
 	if (error)
 		return error;
-	error = transport_class_register(&fc_vport_class);
-	if (error)
-		goto unreg_host_class;
 	error = transport_class_register(&fc_rport_class);
 	if (error)
-		goto unreg_vport_class;
+		goto unreg_host_class;
 	error = transport_class_register(&fc_transport_class);
 	if (error)
 		goto unreg_rport_class;
@@ -660,10 +525,8 @@ static __init int fc_transport_init(void)
 
 unreg_rport_class:
 	transport_class_unregister(&fc_rport_class);
-unreg_vport_class:
-	transport_class_unregister(&fc_vport_class);
 unreg_host_class:
-	transport_class_unregister(&fc_host_class);
+	transport_class_unregister(&fcpinit_class);
 	return error;
 }
 
@@ -671,8 +534,7 @@ static void __exit fc_transport_exit(void)
 {
 	transport_class_unregister(&fc_transport_class);
 	transport_class_unregister(&fc_rport_class);
-	transport_class_unregister(&fc_host_class);
-	transport_class_unregister(&fc_vport_class);
+	transport_class_unregister(&fcpinit_class);
 }
 
 /*
@@ -996,286 +858,25 @@ fc_starget_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
 fc_starget_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
 fc_starget_rd_attr(port_id, "0x%06x\n", 20);
 
-
-/*
- * FC Virtual Port Attribute Management
- */
-
-#define fc_vport_show_function(field, format_string, sz, cast)		\
-static ssize_t								\
-show_fc_vport_##field (struct device *dev, 				\
-		       struct device_attribute *attr, char *buf)	\
-{									\
-	struct fc_vport *vport = transport_class_to_vport(dev);		\
-	struct Scsi_Host *shost = vport_to_shost(vport);		\
-	struct fc_internal *i = to_fc_internal(shost->transportt);	\
-	if ((i->f->get_vport_##field) &&				\
-	    !(vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)))	\
-		i->f->get_vport_##field(vport);				\
-	return snprintf(buf, sz, format_string, cast vport->field); 	\
-}
-
-#define fc_vport_store_function(field)					\
-static ssize_t								\
-store_fc_vport_##field(struct device *dev,				\
-		       struct device_attribute *attr,			\
-		       const char *buf,	size_t count)			\
-{									\
-	int val;							\
-	struct fc_vport *vport = transport_class_to_vport(dev);		\
-	struct Scsi_Host *shost = vport_to_shost(vport);		\
-	struct fc_internal *i = to_fc_internal(shost->transportt);	\
-	char *cp;							\
-	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
-		return -EBUSY;						\
-	val = simple_strtoul(buf, &cp, 0);				\
-	if (*cp && (*cp != '\n'))					\
-		return -EINVAL;						\
-	i->f->set_vport_##field(vport, val);				\
-	return count;							\
-}
-
-#define fc_vport_store_str_function(field, slen)			\
-static ssize_t								\
-store_fc_vport_##field(struct device *dev,				\
-		       struct device_attribute *attr, 			\
-		       const char *buf,	size_t count)			\
-{									\
-	struct fc_vport *vport = transport_class_to_vport(dev);		\
-	struct Scsi_Host *shost = vport_to_shost(vport);		\
-	struct fc_internal *i = to_fc_internal(shost->transportt);	\
-	unsigned int cnt=count;						\
-									\
-	/* count may include a LF at end of string */			\
-	if (buf[cnt-1] == '\n')						\
-		cnt--;							\
-	if (cnt > ((slen) - 1))						\
-		return -EINVAL;						\
-	memcpy(vport->field, buf, cnt);					\
-	i->f->set_vport_##field(vport);					\
-	return count;							\
-}
-
-#define fc_vport_rd_attr(field, format_string, sz)			\
-	fc_vport_show_function(field, format_string, sz, )		\
-static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
-			 show_fc_vport_##field, NULL)
-
-#define fc_vport_rd_attr_cast(field, format_string, sz, cast)		\
-	fc_vport_show_function(field, format_string, sz, (cast))	\
-static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
-			  show_fc_vport_##field, NULL)
-
-#define fc_vport_rw_attr(field, format_string, sz)			\
-	fc_vport_show_function(field, format_string, sz, )		\
-	fc_vport_store_function(field)					\
-static FC_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
-			show_fc_vport_##field,				\
-			store_fc_vport_##field)
-
-#define fc_private_vport_show_function(field, format_string, sz, cast)	\
-static ssize_t								\
-show_fc_vport_##field (struct device *dev,				\
-		       struct device_attribute *attr, char *buf)	\
-{									\
-	struct fc_vport *vport = transport_class_to_vport(dev);		\
-	return snprintf(buf, sz, format_string, cast vport->field); 	\
-}
-
-#define fc_private_vport_store_u32_function(field)			\
-static ssize_t								\
-store_fc_vport_##field(struct device *dev,				\
-		       struct device_attribute *attr,			\
-		       const char *buf,	size_t count)			\
-{									\
-	u32 val;							\
-	struct fc_vport *vport = transport_class_to_vport(dev);		\
-	char *cp;							\
-	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))		\
-		return -EBUSY;						\
-	val = simple_strtoul(buf, &cp, 0);				\
-	if (*cp && (*cp != '\n'))					\
-		return -EINVAL;						\
-	vport->field = val;						\
-	return count;							\
-}
-
-
-#define fc_private_vport_rd_attr(field, format_string, sz)		\
-	fc_private_vport_show_function(field, format_string, sz, )	\
-static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
-			 show_fc_vport_##field, NULL)
-
-#define fc_private_vport_rd_attr_cast(field, format_string, sz, cast)	\
-	fc_private_vport_show_function(field, format_string, sz, (cast)) \
-static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
-			  show_fc_vport_##field, NULL)
-
-#define fc_private_vport_rw_u32_attr(field, format_string, sz)		\
-	fc_private_vport_show_function(field, format_string, sz, )	\
-	fc_private_vport_store_u32_function(field)			\
-static FC_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
-			show_fc_vport_##field,				\
-			store_fc_vport_##field)
-
-
-#define fc_private_vport_rd_enum_attr(title, maxlen)			\
-static ssize_t								\
-show_fc_vport_##title (struct device *dev,				\
-		       struct device_attribute *attr,			\
-		       char *buf)					\
-{									\
-	struct fc_vport *vport = transport_class_to_vport(dev);		\
-	const char *name;						\
-	name = get_fc_##title##_name(vport->title);			\
-	if (!name)							\
-		return -EINVAL;						\
-	return snprintf(buf, maxlen, "%s\n", name);			\
-}									\
-static FC_DEVICE_ATTR(vport, title, S_IRUGO,			\
-			show_fc_vport_##title, NULL)
-
-
-#define SETUP_VPORT_ATTRIBUTE_RD(field)					\
-	i->private_vport_attrs[count] = device_attr_vport_##field; \
-	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
-	i->private_vport_attrs[count].store = NULL;			\
-	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
-	if (i->f->get_##field)						\
-		count++
-	/* NOTE: Above MACRO differs: checks function not show bit */
-
-#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(field)				\
-	i->private_vport_attrs[count] = device_attr_vport_##field; \
-	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
-	i->private_vport_attrs[count].store = NULL;			\
-	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
-	count++
-
-#define SETUP_VPORT_ATTRIBUTE_WR(field)					\
-	i->private_vport_attrs[count] = device_attr_vport_##field; \
-	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
-	if (i->f->field)						\
-		count++
-	/* NOTE: Above MACRO differs: checks function */
-
-#define SETUP_VPORT_ATTRIBUTE_RW(field)					\
-	i->private_vport_attrs[count] = device_attr_vport_##field; \
-	if (!i->f->set_vport_##field) {					\
-		i->private_vport_attrs[count].attr.mode = S_IRUGO;	\
-		i->private_vport_attrs[count].store = NULL;		\
-	}								\
-	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
-	count++
-	/* NOTE: Above MACRO differs: does not check show bit */
-
-#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RW(field)				\
-{									\
-	i->private_vport_attrs[count] = device_attr_vport_##field; \
-	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
-	count++;							\
-}
-
-
-/* The FC Transport Virtual Port Attributes: */
-
-/* Fixed Virtual Port Attributes */
-
-/* Dynamic Virtual Port Attributes */
-
-/* Private Virtual Port Attributes */
-
-fc_private_vport_rd_enum_attr(vport_state, FC_VPORTSTATE_MAX_NAMELEN);
-fc_private_vport_rd_enum_attr(vport_last_state, FC_VPORTSTATE_MAX_NAMELEN);
-fc_private_vport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
-fc_private_vport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
-
-static ssize_t
-show_fc_vport_roles (struct device *dev, struct device_attribute *attr,
-		     char *buf)
-{
-	struct fc_vport *vport = transport_class_to_vport(dev);
-
-	if (vport->roles == FC_PORT_ROLE_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
-	return get_fc_port_roles_names(vport->roles, buf);
-}
-static FC_DEVICE_ATTR(vport, roles, S_IRUGO, show_fc_vport_roles, NULL);
-
-fc_private_vport_rd_enum_attr(vport_type, FC_PORTTYPE_MAX_NAMELEN);
-
-fc_private_vport_show_function(symbolic_name, "%s\n",
-		FC_VPORT_SYMBOLIC_NAMELEN + 1, )
-fc_vport_store_str_function(symbolic_name, FC_VPORT_SYMBOLIC_NAMELEN)
-static FC_DEVICE_ATTR(vport, symbolic_name, S_IRUGO | S_IWUSR,
-		show_fc_vport_symbolic_name, store_fc_vport_symbolic_name);
-
-static ssize_t
-store_fc_vport_delete(struct device *dev, struct device_attribute *attr,
-		      const char *buf, size_t count)
-{
-	struct fc_vport *vport = transport_class_to_vport(dev);
-	struct Scsi_Host *shost = vport_to_shost(vport);
-
-	fc_queue_work(shost, &vport->vport_delete_work);
-	return count;
-}
-static FC_DEVICE_ATTR(vport, vport_delete, S_IWUSR,
-			NULL, store_fc_vport_delete);
-
-
-/*
- * Enable/Disable vport
- *  Write "1" to disable, write "0" to enable
- */
-static ssize_t
-store_fc_vport_disable(struct device *dev, struct device_attribute *attr,
-		       const char *buf,
-			   size_t count)
-{
-	struct fc_vport *vport = transport_class_to_vport(dev);
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-	int stat;
-
-	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
-		return -EBUSY;
-
-	if (*buf == '0') {
-		if (vport->vport_state != FC_VPORT_DISABLED)
-			return -EALREADY;
-	} else if (*buf == '1') {
-		if (vport->vport_state == FC_VPORT_DISABLED)
-			return -EALREADY;
-	} else
-		return -EINVAL;
-
-	stat = i->f->vport_disable(vport, ((*buf == '0') ? false : true));
-	return stat ? stat : count;
-}
-static FC_DEVICE_ATTR(vport, vport_disable, S_IWUSR,
-			NULL, store_fc_vport_disable);
-
-
 /*
  * Host Attribute Management
  */
 
-#define fc_host_show_function(field, format_string, sz, cast)		\
+#define fcpinit_show_function(field, format_string, sz, cast)		\
 static ssize_t								\
-show_fc_host_##field (struct device *dev,				\
+show_fcpinit_##field (struct device *dev,				\
 		      struct device_attribute *attr, char *buf)		\
 {									\
 	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
 	struct fc_internal *i = to_fc_internal(shost->transportt);	\
 	if (i->f->get_host_##field)					\
 		i->f->get_host_##field(shost);				\
-	return snprintf(buf, sz, format_string, cast fc_host_##field(shost)); \
+	return snprintf(buf, sz, format_string, cast fcpinit_##field(shost)); \
 }
 
-#define fc_host_store_function(field)					\
+#define fcpinit_store_function(field)					\
 static ssize_t								\
-store_fc_host_##field(struct device *dev, 				\
+store_fcpinit_##field(struct device *dev, 				\
 		      struct device_attribute *attr,			\
 		      const char *buf,	size_t count)			\
 {									\
@@ -1291,9 +892,9 @@ store_fc_host_##field(struct device *dev, 				\
 	return count;							\
 }
 
-#define fc_host_store_str_function(field, slen)				\
+#define fcpinit_store_str_function(field, slen)				\
 static ssize_t								\
-store_fc_host_##field(struct device *dev,				\
+store_fcpinit_##field(struct device *dev,				\
 		      struct device_attribute *attr,			\
 		      const char *buf, size_t count)			\
 {									\
@@ -1306,31 +907,31 @@ store_fc_host_##field(struct device *dev,				\
 		cnt--;							\
 	if (cnt > ((slen) - 1))						\
 		return -EINVAL;						\
-	memcpy(fc_host_##field(shost), buf, cnt);			\
+	memcpy(fcpinit_##field(shost), buf, cnt);			\
 	i->f->set_host_##field(shost);					\
 	return count;							\
 }
 
-#define fc_host_rd_attr(field, format_string, sz)			\
-	fc_host_show_function(field, format_string, sz, )		\
+#define fcpinit_rd_attr(field, format_string, sz)			\
+	fcpinit_show_function(field, format_string, sz, )		\
 static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
-			 show_fc_host_##field, NULL)
+			 show_fcpinit_##field, NULL)
 
-#define fc_host_rd_attr_cast(field, format_string, sz, cast)		\
-	fc_host_show_function(field, format_string, sz, (cast))		\
+#define fcpinit_rd_attr_cast(field, format_string, sz, cast)		\
+	fcpinit_show_function(field, format_string, sz, (cast))		\
 static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
-			  show_fc_host_##field, NULL)
+			  show_fcpinit_##field, NULL)
 
-#define fc_host_rw_attr(field, format_string, sz)			\
-	fc_host_show_function(field, format_string, sz, )		\
-	fc_host_store_function(field)					\
+#define fcpinit_rw_attr(field, format_string, sz)			\
+	fcpinit_show_function(field, format_string, sz, )		\
+	fcpinit_store_function(field)					\
 static FC_DEVICE_ATTR(host, field, S_IRUGO | S_IWUSR,		\
-			show_fc_host_##field,				\
-			store_fc_host_##field)
+			show_fcpinit_##field,				\
+			store_fcpinit_##field)
 
-#define fc_host_rd_enum_attr(title, maxlen)				\
+#define fcpinit_rd_enum_attr(title, maxlen)				\
 static ssize_t								\
-show_fc_host_##title (struct device *dev,				\
+show_fcpinit_##title (struct device *dev,				\
 		      struct device_attribute *attr, char *buf)		\
 {									\
 	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
@@ -1338,12 +939,12 @@ show_fc_host_##title (struct device *dev,				\
 	const char *name;						\
 	if (i->f->get_host_##title)					\
 		i->f->get_host_##title(shost);				\
-	name = get_fc_##title##_name(fc_host_##title(shost));		\
+	name = get_fc_##title##_name(fcpinit_##title(shost));		\
 	if (!name)							\
 		return -EINVAL;						\
 	return snprintf(buf, maxlen, "%s\n", name);			\
 }									\
-static FC_DEVICE_ATTR(host, title, S_IRUGO, show_fc_host_##title, NULL)
+static FC_DEVICE_ATTR(host, title, S_IRUGO, show_fcpinit_##title, NULL)
 
 #define SETUP_HOST_ATTRIBUTE_RD(field)					\
 	i->private_host_attrs[count] = device_attr_host_##field;	\
@@ -1373,22 +974,22 @@ static FC_DEVICE_ATTR(host, title, S_IRUGO, show_fc_host_##title, NULL)
 
 #define fc_private_host_show_function(field, format_string, sz, cast)	\
 static ssize_t								\
-show_fc_host_##field (struct device *dev,				\
+show_fcpinit_##field (struct device *dev,				\
 		      struct device_attribute *attr, char *buf)		\
 {									\
 	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
-	return snprintf(buf, sz, format_string, cast fc_host_##field(shost)); \
+	return snprintf(buf, sz, format_string, cast fcpinit_##field(shost)); \
 }
 
 #define fc_private_host_rd_attr(field, format_string, sz)		\
 	fc_private_host_show_function(field, format_string, sz, )	\
 static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
-			 show_fc_host_##field, NULL)
+			 show_fcpinit_##field, NULL)
 
 #define fc_private_host_rd_attr_cast(field, format_string, sz, cast)	\
 	fc_private_host_show_function(field, format_string, sz, (cast)) \
 static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
-			  show_fc_host_##field, NULL)
+		      show_fcpinit_##field, NULL)
 
 #define SETUP_PRIVATE_HOST_ATTRIBUTE_RD(field)			\
 	i->private_host_attrs[count] = device_attr_host_##field;	\
@@ -1407,101 +1008,18 @@ static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
 
 /* Fixed Host Attributes */
 
-static ssize_t
-show_fc_host_supported_classes (struct device *dev,
-			        struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(dev);
-
-	if (fc_host_supported_classes(shost) == FC_COS_UNSPECIFIED)
-		return snprintf(buf, 20, "unspecified\n");
-
-	return get_fc_cos_names(fc_host_supported_classes(shost), buf);
-}
-static FC_DEVICE_ATTR(host, supported_classes, S_IRUGO,
-		show_fc_host_supported_classes, NULL);
-
-static ssize_t
-show_fc_host_supported_fc4s (struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(dev);
-	return (ssize_t)show_fc_fc4s(buf, fc_host_supported_fc4s(shost));
-}
-static FC_DEVICE_ATTR(host, supported_fc4s, S_IRUGO,
-		show_fc_host_supported_fc4s, NULL);
-
-static ssize_t
-show_fc_host_supported_speeds (struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(dev);
-
-	if (fc_host_supported_speeds(shost) == FC_PORTSPEED_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
-
-	return get_fc_port_speed_names(fc_host_supported_speeds(shost), buf);
-}
-static FC_DEVICE_ATTR(host, supported_speeds, S_IRUGO,
-		show_fc_host_supported_speeds, NULL);
-
-
-fc_private_host_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
-fc_private_host_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
 fc_private_host_rd_attr_cast(permanent_port_name, "0x%llx\n", 20,
 			     unsigned long long);
-fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
-fc_private_host_rd_attr(max_npiv_vports, "%u\n", 20);
-fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
-
 
 /* Dynamic Host Attributes */
 
-static ssize_t
-show_fc_host_active_fc4s (struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(dev);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-
-	if (i->f->get_host_active_fc4s)
-		i->f->get_host_active_fc4s(shost);
-
-	return (ssize_t)show_fc_fc4s(buf, fc_host_active_fc4s(shost));
-}
-static FC_DEVICE_ATTR(host, active_fc4s, S_IRUGO,
-		show_fc_host_active_fc4s, NULL);
-
-static ssize_t
-show_fc_host_speed (struct device *dev,
-		    struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(dev);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-
-	if (i->f->get_host_speed)
-		i->f->get_host_speed(shost);
-
-	if (fc_host_speed(shost) == FC_PORTSPEED_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
-
-	return get_fc_port_speed_names(fc_host_speed(shost), buf);
-}
-static FC_DEVICE_ATTR(host, speed, S_IRUGO,
-		show_fc_host_speed, NULL);
-
-
-fc_host_rd_attr(port_id, "0x%06x\n", 20);
-fc_host_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
-fc_host_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
-fc_host_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
-fc_host_rd_attr(symbolic_name, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
+fcpinit_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
 
 fc_private_host_show_function(system_hostname, "%s\n",
 		FC_SYMBOLIC_NAME_SIZE + 1, )
-fc_host_store_str_function(system_hostname, FC_SYMBOLIC_NAME_SIZE)
+fcpinit_store_str_function(system_hostname, FC_SYMBOLIC_NAME_SIZE)
 static FC_DEVICE_ATTR(host, system_hostname, S_IRUGO | S_IWUSR,
-		show_fc_host_system_hostname, store_fc_host_system_hostname);
+		show_fcpinit_system_hostname, store_fcpinit_system_hostname);
 
 
 /* Private Host Attributes */
@@ -1513,7 +1031,7 @@ show_fc_private_host_tgtid_bind_type(struct device *dev,
 	struct Scsi_Host *shost = transport_class_to_shost(dev);
 	const char *name;
 
-	name = get_fc_tgtid_bind_type_name(fc_host_tgtid_bind_type(shost));
+	name = get_fc_tgtid_bind_type_name(fcpinit_tgtid_bind_type(shost));
 	if (!name)
 		return -EINVAL;
 	return snprintf(buf, FC_BINDTYPE_MAX_NAMELEN, "%s\n", name);
@@ -1535,11 +1053,11 @@ store_fc_private_host_tgtid_bind_type(struct device *dev,
 		return -EINVAL;
 
 	/* if changing bind type, purge all unused consistent bindings */
-	if (val != fc_host_tgtid_bind_type(shost)) {
+	if (val != fcpinit_tgtid_bind_type(shost)) {
 		spin_lock_irqsave(shost->host_lock, flags);
-		while (!list_empty(&fc_host_rport_bindings(shost))) {
+		while (!list_empty(&fcpinit_rport_bindings(shost))) {
 			get_list_head_entry(rport,
-				&fc_host_rport_bindings(shost), peers);
+				&fcpinit_rport_bindings(shost), peers);
 			list_del(&rport->peers);
 			rport->port_state = FC_PORTSTATE_DELETED;
 			fc_queue_work(shost, &rport->rport_delete_work);
@@ -1547,7 +1065,7 @@ store_fc_private_host_tgtid_bind_type(struct device *dev,
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
-	fc_host_tgtid_bind_type(shost) = val;
+	fcpinit_tgtid_bind_type(shost) = val;
 	return count;
 }
 
@@ -1564,8 +1082,8 @@ store_fc_private_host_issue_lip(struct device *dev,
 	int ret;
 
 	/* ignore any data value written to the attribute */
-	if (i->f->issue_fc_host_lip) {
-		ret = i->f->issue_fc_host_lip(shost);
+	if (i->f->issue_fcpinit_lip) {
+		ret = i->f->issue_fcpinit_lip(shost);
 		return ret ? ret: count;
 	}
 
@@ -1575,8 +1093,6 @@ store_fc_private_host_issue_lip(struct device *dev,
 static FC_DEVICE_ATTR(host, issue_lip, S_IWUSR, NULL,
 			store_fc_private_host_issue_lip);
 
-fc_private_host_rd_attr(npiv_vports_inuse, "%u\n", 20);
-
 
 /*
  * Host Statistics Management
@@ -1588,15 +1104,15 @@ fc_stat_show(const struct device *dev, char *buf, unsigned long offset)
 {
 	struct Scsi_Host *shost = transport_class_to_shost(dev);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
-	struct fc_host_statistics *stats;
+	struct fcpinit_statistics *stats;
 	ssize_t ret = -ENOENT;
 
-	if (offset > sizeof(struct fc_host_statistics) ||
+	if (offset > sizeof(struct fcpinit_statistics) ||
 	    offset % sizeof(u64) != 0)
 		WARN_ON(1);
 
-	if (i->f->get_fc_host_stats) {
-		stats = (i->f->get_fc_host_stats)(shost);
+	if (i->f->get_fcpinit_stats) {
+		stats = (i->f->get_fcpinit_stats)(shost);
 		if (stats)
 			ret = snprintf(buf, 20, "0x%llx\n",
 			      (unsigned long long)*(u64 *)(((u8 *) stats) + offset));
@@ -1606,36 +1122,36 @@ fc_stat_show(const struct device *dev, char *buf, unsigned long offset)
 
 
 /* generate a read-only statistics attribute */
-#define fc_host_statistic(name)						\
+#define fcpinit_statistic(name)						\
 static ssize_t show_fcstat_##name(struct device *cd,			\
 				  struct device_attribute *attr,	\
 				  char *buf)				\
 {									\
 	return fc_stat_show(cd, buf, 					\
-			    offsetof(struct fc_host_statistics, name));	\
+			    offsetof(struct fcpinit_statistics, name));	\
 }									\
 static FC_DEVICE_ATTR(host, name, S_IRUGO, show_fcstat_##name, NULL)
 
-fc_host_statistic(seconds_since_last_reset);
-fc_host_statistic(tx_frames);
-fc_host_statistic(tx_words);
-fc_host_statistic(rx_frames);
-fc_host_statistic(rx_words);
-fc_host_statistic(lip_count);
-fc_host_statistic(nos_count);
-fc_host_statistic(error_frames);
-fc_host_statistic(dumped_frames);
-fc_host_statistic(link_failure_count);
-fc_host_statistic(loss_of_sync_count);
-fc_host_statistic(loss_of_signal_count);
-fc_host_statistic(prim_seq_protocol_err_count);
-fc_host_statistic(invalid_tx_word_count);
-fc_host_statistic(invalid_crc_count);
-fc_host_statistic(fcp_input_requests);
-fc_host_statistic(fcp_output_requests);
-fc_host_statistic(fcp_control_requests);
-fc_host_statistic(fcp_input_megabytes);
-fc_host_statistic(fcp_output_megabytes);
+fcpinit_statistic(seconds_since_last_reset);
+fcpinit_statistic(tx_frames);
+fcpinit_statistic(tx_words);
+fcpinit_statistic(rx_frames);
+fcpinit_statistic(rx_words);
+fcpinit_statistic(lip_count);
+fcpinit_statistic(nos_count);
+fcpinit_statistic(error_frames);
+fcpinit_statistic(dumped_frames);
+fcpinit_statistic(link_failure_count);
+fcpinit_statistic(loss_of_sync_count);
+fcpinit_statistic(loss_of_signal_count);
+fcpinit_statistic(prim_seq_protocol_err_count);
+fcpinit_statistic(invalid_tx_word_count);
+fcpinit_statistic(invalid_crc_count);
+fcpinit_statistic(fcp_input_requests);
+fcpinit_statistic(fcp_output_requests);
+fcpinit_statistic(fcp_control_requests);
+fcpinit_statistic(fcp_input_megabytes);
+fcpinit_statistic(fcp_output_megabytes);
 
 static ssize_t
 fc_reset_statistics(struct device *dev, struct device_attribute *attr,
@@ -1645,8 +1161,8 @@ fc_reset_statistics(struct device *dev, struct device_attribute *attr,
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 
 	/* ignore any data value written to the attribute */
-	if (i->f->reset_fc_host_stats) {
-		i->f->reset_fc_host_stats(shost);
+	if (i->f->reset_fcpinit_stats) {
+		i->f->reset_fcpinit_stats(shost);
 		return count;
 	}
 
@@ -1688,141 +1204,8 @@ static struct attribute_group fc_statistics_group = {
 
 /* Host Vport Attributes */
 
-static int
-fc_parse_wwn(const char *ns, u64 *nm)
-{
-	unsigned int i, j;
-	u8 wwn[8];
-
-	memset(wwn, 0, sizeof(wwn));
-
-	/* Validate and store the new name */
-	for (i=0, j=0; i < 16; i++) {
-		if ((*ns >= 'a') && (*ns <= 'f'))
-			j = ((j << 4) | ((*ns++ -'a') + 10));
-		else if ((*ns >= 'A') && (*ns <= 'F'))
-			j = ((j << 4) | ((*ns++ -'A') + 10));
-		else if ((*ns >= '0') && (*ns <= '9'))
-			j = ((j << 4) | (*ns++ -'0'));
-		else
-			return -EINVAL;
-		if (i % 2) {
-			wwn[i/2] = j & 0xff;
-			j = 0;
-		}
-	}
-
-	*nm = wwn_to_u64(wwn);
-
-	return 0;
-}
-
-
-/*
- * "Short-cut" sysfs variable to create a new vport on a FC Host.
- * Input is a string of the form "<WWPN>:<WWNN>". Other attributes
- * will default to a NPIV-based FCP_Initiator; The WWNs are specified
- * as hex characters, and may *not* contain any prefixes (e.g. 0x, x, etc)
- */
-static ssize_t
-store_fc_host_vport_create(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(dev);
-	struct fc_vport_identifiers vid;
-	struct fc_vport *vport;
-	unsigned int cnt=count;
-	int stat;
-
-	memset(&vid, 0, sizeof(vid));
-
-	/* count may include a LF at end of string */
-	if (buf[cnt-1] == '\n')
-		cnt--;
-
-	/* validate we have enough characters for WWPN */
-	if ((cnt != (16+1+16)) || (buf[16] != ':'))
-		return -EINVAL;
-
-	stat = fc_parse_wwn(&buf[0], &vid.port_name);
-	if (stat)
-		return stat;
-
-	stat = fc_parse_wwn(&buf[17], &vid.node_name);
-	if (stat)
-		return stat;
-
-	vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
-	vid.vport_type = FC_PORTTYPE_NPIV;
-	/* vid.symbolic_name is already zero/NULL's */
-	vid.disable = false;		/* always enabled */
-
-	/* we only allow support on Channel 0 !!! */
-	stat = fc_vport_setup(shost, 0, &shost->shost_gendev, &vid, &vport);
-	return stat ? stat : count;
-}
-static FC_DEVICE_ATTR(host, vport_create, S_IWUSR, NULL,
-			store_fc_host_vport_create);
-
-
-/*
- * "Short-cut" sysfs variable to delete a vport on a FC Host.
- * Vport is identified by a string containing "<WWPN>:<WWNN>".
- * The WWNs are specified as hex characters, and may *not* contain
- * any prefixes (e.g. 0x, x, etc)
- */
-static ssize_t
-store_fc_host_vport_delete(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(dev);
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
-	struct fc_vport *vport;
-	u64 wwpn, wwnn;
-	unsigned long flags;
-	unsigned int cnt=count;
-	int stat, match;
-
-	/* count may include a LF at end of string */
-	if (buf[cnt-1] == '\n')
-		cnt--;
-
-	/* validate we have enough characters for WWPN */
-	if ((cnt != (16+1+16)) || (buf[16] != ':'))
-		return -EINVAL;
-
-	stat = fc_parse_wwn(&buf[0], &wwpn);
-	if (stat)
-		return stat;
-
-	stat = fc_parse_wwn(&buf[17], &wwnn);
-	if (stat)
-		return stat;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	match = 0;
-	/* we only allow support on Channel 0 !!! */
-	list_for_each_entry(vport, &fc_host->vports, peers) {
-		if ((vport->channel == 0) &&
-		    (vport->port_name == wwpn) && (vport->node_name == wwnn)) {
-			match = 1;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (!match)
-		return -ENODEV;
-
-	stat = fc_vport_terminate(vport);
-	return stat ? stat : count;
-}
-static FC_DEVICE_ATTR(host, vport_delete, S_IWUSR, NULL,
-			store_fc_host_vport_delete);
-
-
-static int fc_host_match(struct attribute_container *cont,
-			  struct device *dev)
+static int fc_fcpinit_match(struct attribute_container *cont,
+			    struct device *dev)
 {
 	struct Scsi_Host *shost;
 	struct fc_internal *i;
@@ -1832,7 +1215,7 @@ static int fc_host_match(struct attribute_container *cont,
 
 	shost = dev_to_shost(dev);
 	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
-	    != &fc_host_class.class)
+	    != &fcpinit_class.class)
 		return 0;
 
 	i = to_fc_internal(shost->transportt);
@@ -1851,7 +1234,7 @@ static int fc_target_match(struct attribute_container *cont,
 
 	shost = dev_to_shost(dev->parent);
 	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
-	    != &fc_host_class.class)
+	    != &fcpinit_class.class)
 		return 0;
 
 	i = to_fc_internal(shost->transportt);
@@ -1883,7 +1266,7 @@ static int fc_rport_match(struct attribute_container *cont,
 
 	shost = dev_to_shost(dev->parent);
 	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
-	    != &fc_host_class.class)
+	    != &fcpinit_class.class)
 		return 0;
 
 	i = to_fc_internal(shost->transportt);
@@ -1891,41 +1274,6 @@ static int fc_rport_match(struct attribute_container *cont,
 	return &i->rport_attr_cont.ac == cont;
 }
 
-
-static void fc_vport_dev_release(struct device *dev)
-{
-	struct fc_vport *vport = dev_to_vport(dev);
-	put_device(dev->parent);		/* release kobj parent */
-	kfree(vport);
-}
-
-int scsi_is_fc_vport(const struct device *dev)
-{
-	return dev->release == fc_vport_dev_release;
-}
-EXPORT_SYMBOL(scsi_is_fc_vport);
-
-static int fc_vport_match(struct attribute_container *cont,
-			    struct device *dev)
-{
-	struct fc_vport *vport;
-	struct Scsi_Host *shost;
-	struct fc_internal *i;
-
-	if (!scsi_is_fc_vport(dev))
-		return 0;
-	vport = dev_to_vport(dev);
-
-	shost = vport_to_shost(vport);
-	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
-	    != &fc_host_class.class)
-		return 0;
-
-	i = to_fc_internal(shost->transportt);
-	return &i->vport_attr_cont.ac == cont;
-}
-
-
 /**
  * fc_timed_out - FC Transport I/O timeout intercept handler
  * @scmd:	The SCSI command which timed out
@@ -1972,7 +1320,7 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint lun)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
+	list_for_each_entry(rport, &fcpinit_rports(shost), peers) {
 		if (rport->scsi_target_id == -1)
 			continue;
 
@@ -2060,10 +1408,10 @@ fc_attach_transport(struct fc_function_template *ft)
 	transport_container_register(&i->t.target_attrs);
 
 	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
-	i->t.host_attrs.ac.class = &fc_host_class.class;
-	i->t.host_attrs.ac.match = fc_host_match;
-	i->t.host_size = sizeof(struct fc_host_attrs);
-	if (ft->get_fc_host_stats)
+	i->t.host_attrs.ac.class = &fcpinit_class.class;
+	i->t.host_attrs.ac.match = fc_fcpinit_match;
+	i->t.host_size = sizeof(struct fc_fcpinit);
+	if (ft->get_fcpinit_stats)
 		i->t.host_attrs.statistics = &fc_statistics_group;
 	transport_container_register(&i->t.host_attrs);
 
@@ -2072,11 +1420,6 @@ fc_attach_transport(struct fc_function_template *ft)
 	i->rport_attr_cont.ac.match = fc_rport_match;
 	transport_container_register(&i->rport_attr_cont);
 
-	i->vport_attr_cont.ac.attrs = &i->vport_attrs[0];
-	i->vport_attr_cont.ac.class = &fc_vport_class.class;
-	i->vport_attr_cont.ac.match = fc_vport_match;
-	transport_container_register(&i->vport_attr_cont);
-
 	i->f = ft;
 
 	/* Transport uses the shost workq for scsi scanning */
@@ -2107,38 +1450,16 @@ fc_attach_transport(struct fc_function_template *ft)
 	 * Setup SCSI Host Attributes.
 	 */
 	count=0;
-	SETUP_HOST_ATTRIBUTE_RD(node_name);
-	SETUP_HOST_ATTRIBUTE_RD(port_name);
 	SETUP_HOST_ATTRIBUTE_RD(permanent_port_name);
-	SETUP_HOST_ATTRIBUTE_RD(supported_classes);
-	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
-	SETUP_HOST_ATTRIBUTE_RD(supported_speeds);
-	SETUP_HOST_ATTRIBUTE_RD(maxframe_size);
-	if (ft->vport_create) {
-		SETUP_HOST_ATTRIBUTE_RD_NS(max_npiv_vports);
-		SETUP_HOST_ATTRIBUTE_RD_NS(npiv_vports_inuse);
-	}
-	SETUP_HOST_ATTRIBUTE_RD(serial_number);
 
-	SETUP_HOST_ATTRIBUTE_RD(port_id);
-	SETUP_HOST_ATTRIBUTE_RD(port_type);
 	SETUP_HOST_ATTRIBUTE_RD(port_state);
-	SETUP_HOST_ATTRIBUTE_RD(active_fc4s);
-	SETUP_HOST_ATTRIBUTE_RD(speed);
-	SETUP_HOST_ATTRIBUTE_RD(fabric_name);
-	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
 	SETUP_HOST_ATTRIBUTE_RW(system_hostname);
 
 	/* Transport-managed attributes */
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
-	if (ft->issue_fc_host_lip)
+	if (ft->issue_fcpinit_lip)
 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
-	if (ft->vport_create)
-		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_create);
-	if (ft->vport_delete)
-		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
-
-	BUG_ON(count > FC_HOST_NUM_ATTRS);
+	BUG_ON(count > FCPINIT_NUM_ATTRS);
 
 	i->host_attrs[count] = NULL;
 
@@ -2161,24 +1482,6 @@ fc_attach_transport(struct fc_function_template *ft)
 
 	i->rport_attrs[count] = NULL;
 
-	/*
-	 * Setup Virtual Port Attributes.
-	 */
-	count=0;
-	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_state);
-	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_last_state);
-	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(node_name);
-	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(port_name);
-	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(roles);
-	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_type);
-	SETUP_VPORT_ATTRIBUTE_RW(symbolic_name);
-	SETUP_VPORT_ATTRIBUTE_WR(vport_delete);
-	SETUP_VPORT_ATTRIBUTE_WR(vport_disable);
-
-	BUG_ON(count > FC_VPORT_NUM_ATTRS);
-
-	i->vport_attrs[count] = NULL;
-
 	return &i->t;
 }
 EXPORT_SYMBOL(fc_attach_transport);
@@ -2190,15 +1493,14 @@ void fc_release_transport(struct scsi_transport_template *t)
 	transport_container_unregister(&i->t.target_attrs);
 	transport_container_unregister(&i->t.host_attrs);
 	transport_container_unregister(&i->rport_attr_cont);
-	transport_container_unregister(&i->vport_attr_cont);
 
 	kfree(i);
 }
 EXPORT_SYMBOL(fc_release_transport);
 
 /**
- * fc_queue_work - Queue work to the fc_host workqueue.
- * @shost:	Pointer to Scsi_Host bound to fc_host.
+ * fc_queue_work - Queue work to the fcpinit workqueue.
+ * @shost:	Pointer to Scsi_Host bound to fcpinit.
  * @work:	Work to queue for execution.
  *
  * Return value:
@@ -2209,7 +1511,7 @@ EXPORT_SYMBOL(fc_release_transport);
 static int
 fc_queue_work(struct Scsi_Host *shost, struct work_struct *work)
 {
-	if (unlikely(!fc_host_work_q(shost))) {
+	if (unlikely(!fcpinit_work_q(shost))) {
 		printk(KERN_ERR
 			"ERROR: FC host '%s' attempted to queue work, "
 			"when no workqueue created.\n", shost->hostt->name);
@@ -2218,17 +1520,17 @@ fc_queue_work(struct Scsi_Host *shost, struct work_struct *work)
 		return -EINVAL;
 	}
 
-	return queue_work(fc_host_work_q(shost), work);
+	return queue_work(fcpinit_work_q(shost), work);
 }
 
 /**
- * fc_flush_work - Flush a fc_host's workqueue.
- * @shost:	Pointer to Scsi_Host bound to fc_host.
+ * fc_flush_work - Flush a fcpinit's workqueue.
+ * @shost:	Pointer to Scsi_Host bound to fcpinit.
  */
 static void
 fc_flush_work(struct Scsi_Host *shost)
 {
-	if (!fc_host_work_q(shost)) {
+	if (!fcpinit_work_q(shost)) {
 		printk(KERN_ERR
 			"ERROR: FC host '%s' attempted to flush work, "
 			"when no workqueue created.\n", shost->hostt->name);
@@ -2236,12 +1538,12 @@ fc_flush_work(struct Scsi_Host *shost)
 		return;
 	}
 
-	flush_workqueue(fc_host_work_q(shost));
+	flush_workqueue(fcpinit_work_q(shost));
 }
 
 /**
- * fc_queue_devloss_work - Schedule work for the fc_host devloss workqueue.
- * @shost:	Pointer to Scsi_Host bound to fc_host.
+ * fc_queue_devloss_work - Schedule work for the fcpinit devloss workqueue.
+ * @shost:	Pointer to Scsi_Host bound to fcpinit.
  * @work:	Work to queue for execution.
  * @delay:	jiffies to delay the work queuing
  *
@@ -2252,7 +1554,7 @@ static int
 fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
 				unsigned long delay)
 {
-	if (unlikely(!fc_host_devloss_work_q(shost))) {
+	if (unlikely(!fcpinit_devloss_work_q(shost))) {
 		printk(KERN_ERR
 			"ERROR: FC host '%s' attempted to queue work, "
 			"when no workqueue created.\n", shost->hostt->name);
@@ -2261,17 +1563,17 @@ fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
 		return -EINVAL;
 	}
 
-	return queue_delayed_work(fc_host_devloss_work_q(shost), work, delay);
+	return queue_delayed_work(fcpinit_devloss_work_q(shost), work, delay);
 }
 
 /**
- * fc_flush_devloss - Flush a fc_host's devloss workqueue.
- * @shost:	Pointer to Scsi_Host bound to fc_host.
+ * fc_flush_devloss - Flush a fcpinit's devloss workqueue.
+ * @shost:	Pointer to Scsi_Host bound to fcpinit.
  */
 static void
 fc_flush_devloss(struct Scsi_Host *shost)
 {
-	if (!fc_host_devloss_work_q(shost)) {
+	if (!fcpinit_devloss_work_q(shost)) {
 		printk(KERN_ERR
 			"ERROR: FC host '%s' attempted to flush work, "
 			"when no workqueue created.\n", shost->hostt->name);
@@ -2279,7 +1581,7 @@ fc_flush_devloss(struct Scsi_Host *shost)
 		return;
 	}
 
-	flush_workqueue(fc_host_devloss_work_q(shost));
+	flush_workqueue(fcpinit_devloss_work_q(shost));
 }
 
 
@@ -2301,28 +1603,23 @@ fc_flush_devloss(struct Scsi_Host *shost)
 void
 fc_remove_host(struct Scsi_Host *shost)
 {
-	struct fc_vport *vport = NULL, *next_vport = NULL;
 	struct fc_rport *rport = NULL, *next_rport = NULL;
 	struct workqueue_struct *work_q;
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fcpinit *fcpinit = shost_to_fcpinit(shost);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	/* Remove any vports */
-	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers)
-		fc_queue_work(shost, &vport->vport_delete_work);
-
 	/* Remove any remote ports */
 	list_for_each_entry_safe(rport, next_rport,
-			&fc_host->rports, peers) {
+			&fcpinit->rports, peers) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
 		fc_queue_work(shost, &rport->rport_delete_work);
 	}
 
 	list_for_each_entry_safe(rport, next_rport,
-			&fc_host->rport_bindings, peers) {
+			&fcpinit->rport_bindings, peers) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
 		fc_queue_work(shost, &rport->rport_delete_work);
@@ -2334,16 +1631,16 @@ fc_remove_host(struct Scsi_Host *shost)
 	scsi_flush_work(shost);
 
 	/* flush all stgt delete, and rport delete work items, then kill it  */
-	if (fc_host->work_q) {
-		work_q = fc_host->work_q;
-		fc_host->work_q = NULL;
+	if (fcpinit->work_q) {
+		work_q = fcpinit->work_q;
+		fcpinit->work_q = NULL;
 		destroy_workqueue(work_q);
 	}
 
 	/* flush all devloss work items, then kill it  */
-	if (fc_host->devloss_work_q) {
-		work_q = fc_host->devloss_work_q;
-		fc_host->devloss_work_q = NULL;
+	if (fcpinit->devloss_work_q) {
+		work_q = fcpinit->devloss_work_q;
+		fcpinit->devloss_work_q = NULL;
 		destroy_workqueue(work_q);
 	}
 }
@@ -2451,7 +1748,7 @@ fc_rport_final_delete(struct work_struct *work)
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
-	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
+	put_device(&shost->shost_gendev);	/* for fcpinit->rport list */
 	put_device(dev);			/* for self-reference */
 }
 
@@ -2473,7 +1770,7 @@ static struct fc_rport *
 fc_rport_create(struct Scsi_Host *shost, int channel,
 	struct fc_rport_identifiers  *ids)
 {
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fcpinit *fcpinit = shost_to_fcpinit(shost);
 	struct fc_internal *fci = to_fc_internal(shost->transportt);
 	struct fc_rport *rport;
 	struct device *dev;
@@ -2509,13 +1806,13 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	rport->number = fc_host->next_rport_number++;
+	rport->number = fcpinit->next_rport_number++;
 	if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
-		rport->scsi_target_id = fc_host->next_target_id++;
+		rport->scsi_target_id = fcpinit->next_target_id++;
 	else
 		rport->scsi_target_id = -1;
-	list_add_tail(&rport->peers, &fc_host->rports);
-	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
+	list_add_tail(&rport->peers, &fcpinit->rports);
+	get_device(&shost->shost_gendev);	/* for fcpinit->rport list */
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -2550,7 +1847,7 @@ delete_rport:
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_del(&rport->peers);
-	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
+	put_device(&shost->shost_gendev);	/* for fcpinit->rport list */
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev->parent);
 	kfree(rport);
@@ -2600,7 +1897,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	struct fc_rport_identifiers  *ids)
 {
 	struct fc_internal *fci = to_fc_internal(shost->transportt);
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fcpinit *fcpinit = shost_to_fcpinit(shost);
 	struct fc_rport *rport;
 	unsigned long flags;
 	int match = 0;
@@ -2615,12 +1912,12 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	 */
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	list_for_each_entry(rport, &fc_host->rports, peers) {
+	list_for_each_entry(rport, &fcpinit->rports, peers) {
 
 		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
 			(rport->channel == channel)) {
 
-			switch (fc_host->tgtid_bind_type) {
+			switch (fcpinit->tgtid_bind_type) {
 			case FC_TGTID_BIND_BY_WWPN:
 			case FC_TGTID_BIND_NONE:
 				if (rport->port_name == ids->port_name)
@@ -2713,16 +2010,16 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	 * Search the bindings array
 	 * Note: if never a FCP target, you won't be on this list
 	 */
-	if (fc_host->tgtid_bind_type != FC_TGTID_BIND_NONE) {
+	if (fcpinit->tgtid_bind_type != FC_TGTID_BIND_NONE) {
 
 		/* search for a matching consistent binding */
 
-		list_for_each_entry(rport, &fc_host->rport_bindings,
+		list_for_each_entry(rport, &fcpinit->rport_bindings,
 					peers) {
 			if (rport->channel != channel)
 				continue;
 
-			switch (fc_host->tgtid_bind_type) {
+			switch (fcpinit->tgtid_bind_type) {
 			case FC_TGTID_BIND_BY_WWPN:
 				if (rport->port_name == ids->port_name)
 					match = 1;
@@ -2740,7 +2037,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 			}
 
 			if (match) {
-				list_move_tail(&rport->peers, &fc_host->rports);
+				list_move_tail(&rport->peers, &fcpinit->rports);
 				break;
 			}
 		}
@@ -2789,7 +2086,7 @@ EXPORT_SYMBOL(fc_remote_port_add);
  * The LLDD calls this routine to notify the transport that a remote
  * port is no longer part of the topology. Note: Although a port
  * may no longer be part of the topology, it may persist in the remote
- * ports displayed by the fc_host. We do this under 2 conditions:
+ * ports displayed by the fcpinit. We do this under 2 conditions:
  * 1) If the port was a scsi target, we delay its deletion by "blocking" it.
  *   This allows the port to temporarily disappear, then reappear without
  *   disrupting the SCSI device tree attached to it. During the "blocked"
@@ -2840,7 +2137,7 @@ fc_remote_port_delete(struct fc_rport  *rport)
 	unsigned long flags;
 
 	/*
-	 * No need to flush the fc_host work_q's, as all adds are synchronous.
+	 * No need to flush the fcpinit work_q's, as all adds are synchronous.
 	 *
 	 * We do need to reclaim the rport scan work element, so eventually
 	 * (in fc_rport_final_delete()) we'll flush the scsi host work_q if
@@ -2914,7 +2211,7 @@ void
 fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fcpinit *fcpinit = shost_to_fcpinit(shost);
 	unsigned long flags;
 	int create = 0;
 	int ret;
@@ -2922,7 +2219,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (roles & FC_PORT_ROLE_FCP_TARGET) {
 		if (rport->scsi_target_id == -1) {
-			rport->scsi_target_id = fc_host->next_target_id++;
+			rport->scsi_target_id = fcpinit->next_target_id++;
 			create = 1;
 		} else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
 			create = 1;
@@ -2988,7 +2285,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 		container_of(work, struct fc_rport, dev_loss_work.work);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fcpinit *fcpinit = shost_to_fcpinit(shost);
 	unsigned long flags;
 	int do_callback = 0;
 
@@ -3023,7 +2320,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 		return;
 	}
 
-	if ((fc_host->tgtid_bind_type == FC_TGTID_BIND_NONE) ||
+	if ((fcpinit->tgtid_bind_type == FC_TGTID_BIND_NONE) ||
 	    (rport->scsi_target_id == -1)) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
@@ -3040,7 +2337,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 		"blocked FC remote port time out: removing target and "
 		"saving binding\n");
 
-	list_move_tail(&rport->peers, &fc_host->rport_bindings);
+	list_move_tail(&rport->peers, &fcpinit->rport_bindings);
 
 	/*
 	 * Note: We do not remove or clear the hostdata area. This allows
@@ -3070,7 +2367,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) {	/* still missing */
 
 		/* remove the identifiers that aren't used in the consisting binding */
-		switch (fc_host->tgtid_bind_type) {
+		switch (fcpinit->tgtid_bind_type) {
 		case FC_TGTID_BIND_BY_WWPN:
 			rport->node_name = -1;
 			rport->port_id = -1;
@@ -3182,246 +2479,6 @@ void fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
-/**
- * fc_vport_setup - allocates and creates a FC virtual port.
- * @shost:	scsi host the virtual port is connected to.
- * @channel:	Channel on shost port connected to.
- * @pdev:	parent device for vport
- * @ids:	The world wide names, FC4 port roles, etc for
- *              the virtual port.
- * @ret_vport:	The pointer to the created vport.
- *
- * Allocates and creates the vport structure, calls the parent host
- * to instantiate the vport, the completes w/ class and sysfs creation.
- *
- * Notes:
- *	This routine assumes no locks are held on entry.
- */
-static int
-fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
-	struct fc_vport_identifiers  *ids, struct fc_vport **ret_vport)
-{
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
-	struct fc_internal *fci = to_fc_internal(shost->transportt);
-	struct fc_vport *vport;
-	struct device *dev;
-	unsigned long flags;
-	size_t size;
-	int error;
-
-	*ret_vport = NULL;
-
-	if ( ! fci->f->vport_create)
-		return -ENOENT;
-
-	size = (sizeof(struct fc_vport) + fci->f->dd_fcvport_size);
-	vport = kzalloc(size, GFP_KERNEL);
-	if (unlikely(!vport)) {
-		printk(KERN_ERR "%s: allocation failure\n", __func__);
-		return -ENOMEM;
-	}
-
-	vport->vport_state = FC_VPORT_UNKNOWN;
-	vport->vport_last_state = FC_VPORT_UNKNOWN;
-	vport->node_name = ids->node_name;
-	vport->port_name = ids->port_name;
-	vport->roles = ids->roles;
-	vport->vport_type = ids->vport_type;
-	if (fci->f->dd_fcvport_size)
-		vport->dd_data = &vport[1];
-	vport->shost = shost;
-	vport->channel = channel;
-	vport->flags = FC_VPORT_CREATING;
-	INIT_WORK(&vport->vport_delete_work, fc_vport_sched_delete);
-
-	spin_lock_irqsave(shost->host_lock, flags);
-
-	if (fc_host->npiv_vports_inuse >= fc_host->max_npiv_vports) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		kfree(vport);
-		return -ENOSPC;
-	}
-	fc_host->npiv_vports_inuse++;
-	vport->number = fc_host->next_vport_number++;
-	list_add_tail(&vport->peers, &fc_host->vports);
-	get_device(&shost->shost_gendev);	/* for fc_host->vport list */
-
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	dev = &vport->dev;
-	device_initialize(dev);			/* takes self reference */
-	dev->parent = get_device(pdev);		/* takes parent reference */
-	dev->release = fc_vport_dev_release;
-	dev_set_name(dev, "vport-%d:%d-%d",
-		     shost->host_no, channel, vport->number);
-	transport_setup_device(dev);
-
-	error = device_add(dev);
-	if (error) {
-		printk(KERN_ERR "FC Virtual Port device_add failed\n");
-		goto delete_vport;
-	}
-	transport_add_device(dev);
-	transport_configure_device(dev);
-
-	error = fci->f->vport_create(vport, ids->disable);
-	if (error) {
-		printk(KERN_ERR "FC Virtual Port LLDD Create failed\n");
-		goto delete_vport_all;
-	}
-
-	/*
-	 * if the parent isn't the physical adapter's Scsi_Host, ensure
-	 * the Scsi_Host at least contains ia symlink to the vport.
-	 */
-	if (pdev != &shost->shost_gendev) {
-		error = sysfs_create_link(&shost->shost_gendev.kobj,
-				 &dev->kobj, dev_name(dev));
-		if (error)
-			printk(KERN_ERR
-				"%s: Cannot create vport symlinks for "
-				"%s, err=%d\n",
-				__func__, dev_name(dev), error);
-	}
-	spin_lock_irqsave(shost->host_lock, flags);
-	vport->flags &= ~FC_VPORT_CREATING;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	dev_printk(KERN_NOTICE, pdev,
-			"%s created via shost%d channel %d\n", dev_name(dev),
-			shost->host_no, channel);
-
-	*ret_vport = vport;
-
-	return 0;
-
-delete_vport_all:
-	transport_remove_device(dev);
-	device_del(dev);
-delete_vport:
-	transport_destroy_device(dev);
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_del(&vport->peers);
-	put_device(&shost->shost_gendev);	/* for fc_host->vport list */
-	fc_host->npiv_vports_inuse--;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(dev->parent);
-	kfree(vport);
-
-	return error;
-}
-
-/**
- * fc_vport_create - Admin App or LLDD requests creation of a vport
- * @shost:	scsi host the virtual port is connected to.
- * @channel:	channel on shost port connected to.
- * @ids:	The world wide names, FC4 port roles, etc for
- *              the virtual port.
- *
- * Notes:
- *	This routine assumes no locks are held on entry.
- */
-struct fc_vport *
-fc_vport_create(struct Scsi_Host *shost, int channel,
-	struct fc_vport_identifiers *ids)
-{
-	int stat;
-	struct fc_vport *vport;
-
-	stat = fc_vport_setup(shost, channel, &shost->shost_gendev,
-		 ids, &vport);
-	return stat ? NULL : vport;
-}
-EXPORT_SYMBOL(fc_vport_create);
-
-/**
- * fc_vport_terminate - Admin App or LLDD requests termination of a vport
- * @vport:	fc_vport to be terminated
- *
- * Calls the LLDD vport_delete() function, then deallocates and removes
- * the vport from the shost and object tree.
- *
- * Notes:
- *	This routine assumes no locks are held on entry.
- */
-int
-fc_vport_terminate(struct fc_vport *vport)
-{
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-	struct device *dev = &vport->dev;
-	unsigned long flags;
-	int stat;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (vport->flags & FC_VPORT_CREATING) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return -EBUSY;
-	}
-	if (vport->flags & (FC_VPORT_DEL)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return -EALREADY;
-	}
-	vport->flags |= FC_VPORT_DELETING;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (i->f->vport_delete)
-		stat = i->f->vport_delete(vport);
-	else
-		stat = -ENOENT;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	vport->flags &= ~FC_VPORT_DELETING;
-	if (!stat) {
-		vport->flags |= FC_VPORT_DELETED;
-		list_del(&vport->peers);
-		fc_host->npiv_vports_inuse--;
-		put_device(&shost->shost_gendev);  /* for fc_host->vport list */
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (stat)
-		return stat;
-
-	if (dev->parent != &shost->shost_gendev)
-		sysfs_remove_link(&shost->shost_gendev.kobj, dev_name(dev));
-	transport_remove_device(dev);
-	device_del(dev);
-	transport_destroy_device(dev);
-
-	/*
-	 * Removing our self-reference should mean our
-	 * release function gets called, which will drop the remaining
-	 * parent reference and free the data structure.
-	 */
-	put_device(dev);			/* for self-reference */
-
-	return 0; /* SUCCESS */
-}
-EXPORT_SYMBOL(fc_vport_terminate);
-
-/**
- * fc_vport_sched_delete - workq-based delete request for a vport
- * @work:	vport to be deleted.
- */
-static void
-fc_vport_sched_delete(struct work_struct *work)
-{
-	struct fc_vport *vport =
-		container_of(work, struct fc_vport, vport_delete_work);
-	int stat;
-
-	stat = fc_vport_terminate(vport);
-	if (stat)
-		dev_printk(KERN_ERR, vport->dev.parent,
-			"%s: %s could not be deleted created via "
-			"shost%d channel %d - error %d\n", __func__,
-			dev_name(&vport->dev), vport->shost->host_no,
-			vport->channel, stat);
-}
-
-
 /*
  * BSG support
  */
@@ -3914,11 +2971,11 @@ fc_bsg_rport_handler(struct request_queue *q)
 
 /**
  * fc_bsg_hostadd - Create and add the bsg hooks so we can receive requests
- * @shost:	shost for fc_host
- * @fc_host:	fc_host adding the structures to
+ * @shost:	shost for fcpinit
+ * @fcpinit:	fcpinit adding the structures to
  */
 static int
-fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
+fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_fcpinit *fcpinit)
 {
 	struct device *dev = &shost->shost_gendev;
 	struct fc_internal *i = to_fc_internal(shost->transportt);
@@ -3926,17 +2983,17 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	int err;
 	char bsg_name[20];
 
-	fc_host->rqst_q = NULL;
+	fcpinit->rqst_q = NULL;
 
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
 	snprintf(bsg_name, sizeof(bsg_name),
-		 "fc_host%d", shost->host_no);
+		 "fcpinit%d", shost->host_no);
 
 	q = __scsi_alloc_queue(shost, fc_bsg_host_handler);
 	if (!q) {
-		printk(KERN_ERR "fc_host%d: bsg interface failed to "
+		printk(KERN_ERR "fcpinit%d: bsg interface failed to "
 				"initialize - no request queue\n",
 				 shost->host_no);
 		return -ENOMEM;
@@ -3950,14 +3007,14 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 
 	err = bsg_register_queue(q, dev, bsg_name, NULL);
 	if (err) {
-		printk(KERN_ERR "fc_host%d: bsg interface failed to "
+		printk(KERN_ERR "fcpinit%d: bsg interface failed to "
 				"initialize - register queue\n",
 				shost->host_no);
 		blk_cleanup_queue(q);
 		return err;
 	}
 
-	fc_host->rqst_q = q;
+	fcpinit->rqst_q = q;
 	return 0;
 }
 
diff --git a/include/scsi/fc.h b/include/scsi/fc.h
new file mode 100644
index 0000000..7ca20fb
--- /dev/null
+++ b/include/scsi/fc.h
@@ -0,0 +1,461 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _FC_H_
+#define _FC_H_
+
+#include <linux/device.h>
+#include <scsi/scsi_transport_fc.h>
+
+struct fc_fcport;
+struct fc_fcvport;
+struct fc_fcfabric;
+struct fcvport_function_template;
+
+/*
+ * fc_vport_state: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fc_vport_state {
+	FC_VPORT_UNKNOWN,
+	FC_VPORT_ACTIVE,
+	FC_VPORT_DISABLED,
+	FC_VPORT_LINKDOWN,
+	FC_VPORT_INITIALIZING,
+	FC_VPORT_NO_FABRIC_SUPP,
+	FC_VPORT_NO_FABRIC_RSCS,
+	FC_VPORT_FABRIC_LOGOUT,
+	FC_VPORT_FABRIC_REJ_WWN,
+	FC_VPORT_FAILED,
+};
+
+#define FC_SERIAL_NUMBER_SIZE		80
+
+#define dev_to_fcport(d)				\
+	container_of(d, struct fc_fcport, gendev)
+
+#define dev_to_fcfport(d)				\
+	container_of(d, struct fc_fcfport, gendev)
+
+#define dev_to_fcfabric(d)				\
+	container_of(d, struct fc_fcfabric, gendev)
+
+#define dev_to_fcvport(d)				\
+	container_of(d, struct fc_fcvport, gendev)
+
+#define dev_to_fcpinit(d)				\
+	container_of(d, struct fc_fcpinit, gendev)
+
+/*
+ * TODO: Double check these maximum attribute defines
+ */
+#define FCPORT_NUM_ATTRS 7
+#define FCVPORT_NUM_ATTRS 9
+#define FCFABRIC_NUM_ATTRS 5
+#define FCPINIT_NUM_ATTRS 4
+
+struct fcport_function_template {
+	void	(*get_fcport_speed)(struct fc_fcport *);
+	void	(*get_fcport_active_fc4s)(struct fc_fcport *);
+
+	unsigned long	show_fcport_maxframe_size:1;
+	unsigned long	show_fcport_supported_speeds:1;
+	unsigned long	show_fcport_speed:1;
+	unsigned long	show_fcport_supported_fc4s:1;
+	unsigned long	show_fcport_active_fc4s:1;
+	unsigned long	show_fcport_supported_classes:1;
+	unsigned long	show_fcport_serial_number:1;
+};
+
+struct fc_fcport {
+	int              id;
+	struct device    gendev;
+	struct fcport_function_template *f;
+	struct device_attribute attrs[FCPORT_NUM_ATTRS];
+
+	/* Fixed Attributes */
+	u8  supported_fc4s[FC_FC4_LIST_SIZE];
+	u32 maxframe_size;
+	u32 supported_classes;
+	char serial_number[FC_SERIAL_NUMBER_SIZE];
+
+	/* Dynamic Attributes*/
+	u8  active_fc4s[FC_FC4_LIST_SIZE];
+
+	/*
+	 * TODO: For FCoE supported_speeds and speed
+	 * can change on a link event. Previously they
+	 * were listed under the "Fixed Attributes" comment,
+	 * but maybe they should be moved under the
+	 * "Dynamic Attributes" comment. Does this have
+	 * an impact on the functionality?
+	 */
+	u32 supported_speeds;
+	u32 speed;
+};
+#define fcport_maxframe_size(x)			\
+	(x)->maxframe_size
+#define fcport_supported_speeds(x)		\
+	(x)->supported_speeds
+#define fcport_speed(x)				\
+	(x)->speed
+#define fcport_supported_fc4s(x)		\
+	(x)->supported_fc4s
+#define fcport_active_fc4s(x)			\
+	(x)->active_fc4s
+#define fcport_supported_classes(x)		\
+	(x)->supported_classes
+#define fcport_serial_number(x)			\
+	(x)->serial_number
+
+struct fc_fcfport {
+	struct device    gendev;
+	int              name;
+};
+
+struct fcfabric_function_template {
+	void	(*get_fcfabric_fabric_name)(struct fc_fcfabric *);
+	int  	(*vport_create)(void *, struct fc_fcvport *, bool);
+	int	(*vport_disable)(struct fc_fcvport *, bool);
+	int  	(*vport_delete)(void *, struct fc_fcvport *);
+
+	unsigned long	show_fcfabric_fabric_name:1;
+
+	/*
+	 * TODO: This seems misplaced, but the vport_create
+	 * code in fcfabric needs it.
+	 */
+	u32	 			dd_fcvport_size;
+};
+
+struct fc_fcfabric {
+	struct device    gendev;
+	struct fcfabric_function_template *f;
+
+	/* Fixed Attributes */
+	u64 fabric_name;
+	u16 max_npiv_vports;
+
+	/* Dynamic Attributes */
+	u16 npiv_vports_inuse;
+
+	/* Internal Data */
+	u32 next_vport_number;
+
+	/*
+	 * TODO: This violates layering, but is necessary until
+	 * the fcfabric has some locking to protect it's list
+	 * of vports. Right now the host_lock is used for that
+	 * protection so we need the Scsi_Host until there is
+	 * a replacement lock.
+	 */
+	struct Scsi_Host *shost;
+
+	/* TODO: This must be moved out of here!!!! */
+	struct fcvport_function_template *fcvport_f;
+
+	struct list_head vports;
+
+	/* Replacement for shost->host_lock, protects vports list */
+	spinlock_t              lock;
+
+	struct device_attribute attrs[FCFABRIC_NUM_ATTRS];
+};
+
+#define fcfabric_fabric_name(x)			\
+	(x)->fabric_name
+#define fcfabric_max_npiv_vports(x)		\
+	(x)->max_npiv_vports
+#define fcfabric_next_vport_number(x)		\
+	(x)->next_vport_number
+#define fcfabric_npiv_vports_inuse(x)		\
+	(x)->npiv_vports_inuse
+#define fcfabric_vports(x)			\
+	(x)->vports
+
+
+struct fcvport_function_template {
+	void 	(*get_fcvport_port_id)(struct fc_fcvport *);
+	void	(*get_fcvport_symbolic_name)(struct fc_fcvport *);
+	void	(*get_fcvport_port_type)(struct fc_fcvport *);
+	void	(*set_fcvport_symbolic_name)(struct fc_fcvport *);
+
+	unsigned long	                 show_fcvport_port_id:1;
+	unsigned long	                 show_fcvport_symbolic_name:1;
+	unsigned long	                 show_fcvport_node_name:1;
+	unsigned long	                 show_fcvport_port_name:1;
+	unsigned long	                 show_fcvport_port_type:1;
+};
+
+/*
+ * FC Virtual Port Attributes
+ *
+ * This structure exists for each FC port is a virtual FC port. Virtual
+ * ports share the physical link with the Physical port. Each virtual
+ * ports has a unique presense on the SAN, and may be instantiated via
+ * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
+ * unique presense, each vport has it's own view of the fabric,
+ * authentication privilege, and priorities.
+ *
+ * A virtual port may support 1 or more FC4 roles. Typically it is a
+ * FCP Initiator. It could be a FCP Target, or exist sole for an IP over FC
+ * roles. FC port attributes for the vport will be reported on any
+ * fc_host class object allocated for an FCP Initiator.
+ *
+ * --
+ *
+ * Fixed attributes are not expected to change. The driver is
+ * expected to set these values after receiving the fc_vport structure
+ * via the vport_create() call from the transport.
+ * The transport fully manages all get functions w/o driver interaction.
+ *
+ * Dynamic attributes are expected to change. The driver participates
+ * in all get/set operations via functions provided by the driver.
+ *
+ * Private attributes are transport-managed values. They are fully
+ * managed by the transport w/o driver interaction.
+ */
+struct fc_fcvport {
+	struct device                    gendev;
+	struct fcvport_function_template *f;
+	u32                              id;
+
+	u32                              port_id;
+	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+	u64                              node_name;
+	u64                              port_name;
+	enum fc_port_type                port_type;
+
+	struct device_attribute attrs[FCVPORT_NUM_ATTRS];
+
+	/*
+	 * TODO: Sort these members out, they are from
+	 * the FC transport's vport definition.
+	 */
+	/* Fixed Attributes */
+
+	/* Dynamic Attributes */
+
+	/* Private (Transport-managed) Attributes */
+	enum fc_vport_state vport_state;
+	enum fc_vport_state vport_last_state;
+	u32 roles;
+	u32 vport_id;		/* Admin Identifier for the vport */
+	enum fc_port_type vport_type;
+
+	/* exported data */
+	void *dd_data;			/* Used for driver-specific storage */
+
+	/* internal data */
+	struct Scsi_Host *shost;	/* Physical Port Parent */
+	unsigned int channel;
+	u32 number;
+	u8 flags;
+
+	/*
+	 * TODO: This is a temporary workaround, the vport structures
+	 * need to be merged to remove hacks like this.
+	 */
+	struct fc_fcfabric *fcfabric;
+
+	/*
+	 * TODO: This is a libfc/fcoe workaround so that we can get at
+	 * the lport for a N_Port in fcoe_vport_create. We really need
+	 * to fix the FIP/fabric_login sequence so that the lport can
+	 * be allocated with the fcvport and then we can use container_of.
+	 */
+	void *priv_data;
+
+	/* Replacement for shost->host_lock, protects vport_state */
+	spinlock_t              lock;
+
+	struct list_head peers;
+
+	struct work_struct vport_delete_work;
+
+} __attribute__((aligned(sizeof(unsigned long))));
+
+#define fcvport_port_id(x)			\
+	(x)->port_id
+#define fcvport_symbolic_name(x)		\
+	(x)->symbolic_name
+#define fcvport_node_name(x)			\
+	(x)->node_name
+#define fcvport_port_name(x)			\
+	(x)->port_name
+#define fcvport_port_type(x)			\
+	(x)->port_type
+	
+struct fc_fcpinit {
+	struct device    gendev;
+
+	/* Fixed Attributes */
+	u64 permanent_port_name;
+
+	/* Dynamic Attributes */
+	enum fc_port_state port_state;
+	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
+
+	/* Private (Transport-managed) Attributes */
+	enum fc_tgtid_binding_type  tgtid_bind_type;
+
+	/* internal data */
+	struct list_head rports;
+	struct list_head rport_bindings;
+	u32 next_rport_number;
+	u32 next_target_id;
+
+	/* work queues for rport state manipulation */
+	char work_q_name[20];
+	struct workqueue_struct *work_q;
+	char devloss_work_q_name[20];
+	struct workqueue_struct *devloss_work_q;
+
+	/* bsg support */
+	struct request_queue *rqst_q;
+};
+
+#define shost_to_fcpinit(x)			\
+	((struct fc_fcpinit *)(x)->shost_data)
+#define fcpinit_permanent_port_name(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->permanent_port_name)
+#define fcpinit_port_state(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->port_state)
+#define fcpinit_system_hostname(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->system_hostname)
+#define fcpinit_tgtid_bind_type(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->tgtid_bind_type)
+#define fcpinit_rports(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->rports)
+#define fcpinit_rport_bindings(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->rport_bindings)
+#define fcpinit_next_rport_number(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->next_rport_number)
+#define fcpinit_next_target_id(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->next_target_id)
+#define fcpinit_work_q_name(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->work_q_name)
+#define fcpinit_work_q(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->work_q)
+#define fcpinit_devloss_work_q_name(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->devloss_work_q_name)
+#define fcpinit_devloss_work_q(x)					\
+	(((struct fc_fcpinit *)(x)->shost_data)->devloss_work_q)
+
+
+/**
+ * fc_vport_set_state() - called to set a vport's state. Saves the old state,
+ *   excepting the transitory states of initializing and sending the ELS
+ *   traffic to instantiate the vport on the link.
+ *
+ * Assumes the driver has surrounded this with the proper locking to ensure
+ * a coherent state change.
+ *
+ * @vport:	virtual port whose state is changing
+ * @new_state:  new state
+ **/
+static inline void
+fc_vport_set_state(struct fc_fcvport *fcvport, enum fc_vport_state new_state)
+{
+	if ((new_state != FC_VPORT_UNKNOWN) &&
+	    (new_state != FC_VPORT_INITIALIZING))
+		fcvport->vport_last_state = fcvport->vport_state;
+	fcvport->vport_state = new_state;
+}
+
+struct fc_fcfport *fc_fcfport_lookup(struct fc_fcport *fcport, const u64 name);
+struct fc_fcvport *fc_fcvport_lookup(struct fc_fcfabric *fcfabric, const u32 id);
+
+struct fc_fcport *fc_fcport_add(struct device *pdev, 
+				struct fcport_function_template *,
+				int priv_size);
+struct fc_fcfport *fc_fcfport_add(struct fc_fcport *fcport, const u64 name);
+struct fc_fcfabric *fc_fcfabric_add(struct fc_fcfport *fcfport,
+				    struct fcfabric_function_template *);
+struct fc_fcvport *fc_fcvport_alloc(struct fc_fcfabric *fcfabric,
+				    struct fc_vport_identifiers *ids,
+				    struct fcvport_function_template *fcn_tmpl,
+				    int priv_size);
+struct fc_fcvport *fc_vport_create(struct fc_fcfabric *, int channel,
+				   struct fc_vport_identifiers *);
+int fc_fcvport_add(struct fc_fcvport *fcvport,
+		   struct fc_fcfabric *fcfabric);
+
+struct fc_fcpinit *fc_fcpinit_add(struct fc_fcvport *fcvport, int hostno);
+
+void fc_fcport_del(struct fc_fcport *fcport);
+void fc_fcfport_del(struct fc_fcfport *fcfport);
+void fc_fcfabric_del(struct fc_fcfabric *fcfabric);
+void fc_fcvport_del(struct fc_fcvport *fcvport);
+void fc_fcpinit_del(struct fc_fcpinit *fcpinit);
+
+int fc_fcvport_is_nport(struct device *dev, void *data);
+struct fc_fcvport *fc_fcfabric_find_nport(struct fc_fcfabric *fcfabric);
+
+#define FC_DEVICE_ATTR(_prefix,_name,_mode,_show,_store)		\
+	struct device_attribute device_attr_##_prefix##_##_name = 	\
+		__ATTR(_name,_mode,_show,_store)
+
+#define FC_CREATE_ATTRIBUTES(_var)					\
+	while (count > 0) {						\
+		error = device_create_file(&_var->gendev, &_var->attrs[count-1]); \
+		if (error)						\
+			break;						\
+		count--;						\
+	}
+
+#define FC_SETUP_CONDITIONAL_ATTRIBUTE_RD(_var, field)			\
+	if (_var->f->show_##_var##_##field) {				\
+		_var->attrs[count] = device_attr_##_var##_##field;	\
+		_var->attrs[count].attr.mode = S_IRUGO;			\
+		_var->attrs[count].store = NULL;			\
+		count++;						\
+	}
+
+#define FC_SETUP_ALWAYS_ATTRIBUTE_RW(_var, field)			\
+{									\
+	_var->attrs[count] = device_attr_##_var##_##field;		\
+	count++;							\
+}
+
+#define FC_SETUP_ALWAYS_ATTRIBUTE_RD_NS(_var, field)			\
+	_var->attrs[count] = device_attr_##_var##_##field;		\
+	_var->attrs[count].attr.mode = S_IRUGO;				\
+	_var->attrs[count].store = NULL;				\
+	count++
+
+#define fc_always_show_function(_obj, field, format_string, sz, cast)	\
+	static ssize_t show_##_obj##_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_##_obj *_obj = dev_to_##_obj(dev);		\
+	return snprintf(buf, sz, format_string, cast _obj##_##field(_obj)); \
+}
+
+#define fc_conditional_show_function(_obj, field, format_string, sz, cast) \
+	static ssize_t show_##_obj##_##field(struct device *dev,	\
+					     struct device_attribute *attr, \
+					     char *buf)			\
+{									\
+	struct fc_##_obj *_obj = dev_to_##_obj(dev);			\
+	if (_obj->f->get_##_obj##_##field)				\
+		_obj->f->get_##_obj##_##field(_obj);			\
+	return snprintf(buf, sz, format_string, cast _obj##_##field(_obj)); \
+}
+
+#endif /* _FC_H_ */
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 8e86a94..88d027d 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -83,26 +83,6 @@ enum fc_port_state {
 	FC_PORTSTATE_DELETED,
 };
 
-
-/*
- * fc_vport_state: If you alter this, you also need to alter
- * scsi_transport_fc.c (for the ascii descriptions).
- */
-enum fc_vport_state {
-	FC_VPORT_UNKNOWN,
-	FC_VPORT_ACTIVE,
-	FC_VPORT_DISABLED,
-	FC_VPORT_LINKDOWN,
-	FC_VPORT_INITIALIZING,
-	FC_VPORT_NO_FABRIC_SUPP,
-	FC_VPORT_NO_FABRIC_RSCS,
-	FC_VPORT_FABRIC_LOGOUT,
-	FC_VPORT_FABRIC_REJ_WWN,
-	FC_VPORT_FAILED,
-};
-
-
-
 /*
  * FC Classes of Service
  * Note: values are not enumerated, as they can be "or'd" together
@@ -160,11 +140,13 @@ enum fc_tgtid_binding_type  {
 #define FC_RPORT_ROLE_FCP_INITIATOR		FC_PORT_ROLE_FCP_INITIATOR
 #define FC_RPORT_ROLE_IP_PORT			FC_PORT_ROLE_IP_PORT
 
+/* TODO: Delete this macro, is duplicated in fcvport.c
 
-/* Macro for use in defining Virtual Port attributes */
+ Macro for use in defining Virtual Port attributes
 #define FC_VPORT_ATTR(_name,_mode,_show,_store)		\
 struct device_attribute dev_attr_vport_##_name = 	\
 	__ATTR(_name,_mode,_show,_store)
+*/
 
 /*
  * fc_vport_identifiers: This set of data contains all elements
@@ -187,81 +169,12 @@ struct fc_vport_identifiers {
 	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
 };
 
-/*
- * FC Virtual Port Attributes
- *
- * This structure exists for each FC port is a virtual FC port. Virtual
- * ports share the physical link with the Physical port. Each virtual
- * ports has a unique presense on the SAN, and may be instantiated via
- * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
- * unique presense, each vport has it's own view of the fabric,
- * authentication privilege, and priorities.
- *
- * A virtual port may support 1 or more FC4 roles. Typically it is a
- * FCP Initiator. It could be a FCP Target, or exist sole for an IP over FC
- * roles. FC port attributes for the vport will be reported on any
- * fc_host class object allocated for an FCP Initiator.
- *
- * --
- *
- * Fixed attributes are not expected to change. The driver is
- * expected to set these values after receiving the fc_vport structure
- * via the vport_create() call from the transport.
- * The transport fully manages all get functions w/o driver interaction.
- *
- * Dynamic attributes are expected to change. The driver participates
- * in all get/set operations via functions provided by the driver.
- *
- * Private attributes are transport-managed values. They are fully
- * managed by the transport w/o driver interaction.
- */
-
-struct fc_vport {
-	/* Fixed Attributes */
-
-	/* Dynamic Attributes */
-
-	/* Private (Transport-managed) Attributes */
-	enum fc_vport_state vport_state;
-	enum fc_vport_state vport_last_state;
-	u64 node_name;
-	u64 port_name;
-	u32 roles;
-	u32 vport_id;		/* Admin Identifier for the vport */
-	enum fc_port_type vport_type;
-	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
-
-	/* exported data */
-	void *dd_data;			/* Used for driver-specific storage */
-
-	/* internal data */
-	struct Scsi_Host *shost;	/* Physical Port Parent */
-	unsigned int channel;
-	u32 number;
-	u8 flags;
-	struct list_head peers;
-	struct device dev;
-	struct work_struct vport_delete_work;
-} __attribute__((aligned(sizeof(unsigned long))));
-
 /* bit field values for struct fc_vport "flags" field: */
 #define FC_VPORT_CREATING		0x01
 #define FC_VPORT_DELETING		0x02
 #define FC_VPORT_DELETED		0x04
 #define FC_VPORT_DEL			0x06	/* Any DELETE state */
 
-#define	dev_to_vport(d)				\
-	container_of(d, struct fc_vport, dev)
-#define transport_class_to_vport(dev)		\
-	dev_to_vport(dev->parent)
-#define vport_to_shost(v)			\
-	(v->shost)
-#define vport_to_shost_channel(v)		\
-	(v->channel)
-#define vport_to_parent(v)			\
-	(v->dev.parent)
-
-
 /* Error return codes for vport_create() callback */
 #define VPCERR_UNSUPPORTED		-ENOSYS		/* no driver/adapter
 							   support */
@@ -402,7 +315,7 @@ struct fc_starget_attrs {	/* aka fc_target_attrs */
  */
 
 /* FC Statistics - Following FC HBAAPI v2.0 guidelines */
-struct fc_host_statistics {
+struct fcpinit_statistics {
 	/* port statistics */
 	u64 seconds_since_last_reset;
 	u64 tx_frames;
@@ -434,10 +347,10 @@ struct fc_host_statistics {
  */
 
 /*
- * fc_host_event_code: If you alter this, you also need to alter
+ * fcpinit_event_code: If you alter this, you also need to alter
  * scsi_transport_fc.c (for the ascii descriptions).
  */
-enum fc_host_event_code  {
+enum fcpinit_event_code  {
 	FCH_EVT_LIP			= 0x1,
 	FCH_EVT_LINKUP			= 0x2,
 	FCH_EVT_LINKDOWN		= 0x3,
@@ -473,114 +386,6 @@ enum fc_host_event_code  {
 #define FC_FC4_LIST_SIZE		32
 #define FC_SYMBOLIC_NAME_SIZE		256
 #define FC_VERSION_STRING_SIZE		64
-#define FC_SERIAL_NUMBER_SIZE		80
-
-struct fc_host_attrs {
-	/* Fixed Attributes */
-	u64 node_name;
-	u64 port_name;
-	u64 permanent_port_name;
-	u32 supported_classes;
-	u8  supported_fc4s[FC_FC4_LIST_SIZE];
-	u32 supported_speeds;
-	u32 maxframe_size;
-	u16 max_npiv_vports;
-	char serial_number[FC_SERIAL_NUMBER_SIZE];
-
-	/* Dynamic Attributes */
-	u32 port_id;
-	enum fc_port_type port_type;
-	enum fc_port_state port_state;
-	u8  active_fc4s[FC_FC4_LIST_SIZE];
-	u32 speed;
-	u64 fabric_name;
-	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
-	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
-
-	/* Private (Transport-managed) Attributes */
-	enum fc_tgtid_binding_type  tgtid_bind_type;
-
-	/* internal data */
-	struct list_head rports;
-	struct list_head rport_bindings;
-	struct list_head vports;
-	u32 next_rport_number;
-	u32 next_target_id;
-	u32 next_vport_number;
-	u16 npiv_vports_inuse;
-
-	/* work queues for rport state manipulation */
-	char work_q_name[20];
-	struct workqueue_struct *work_q;
-	char devloss_work_q_name[20];
-	struct workqueue_struct *devloss_work_q;
-
-	/* bsg support */
-	struct request_queue *rqst_q;
-};
-
-#define shost_to_fc_host(x) \
-	((struct fc_host_attrs *)(x)->shost_data)
-
-#define fc_host_node_name(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->node_name)
-#define fc_host_port_name(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->port_name)
-#define fc_host_permanent_port_name(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->permanent_port_name)
-#define fc_host_supported_classes(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->supported_classes)
-#define fc_host_supported_fc4s(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->supported_fc4s)
-#define fc_host_supported_speeds(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->supported_speeds)
-#define fc_host_maxframe_size(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->maxframe_size)
-#define fc_host_max_npiv_vports(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->max_npiv_vports)
-#define fc_host_serial_number(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->serial_number)
-#define fc_host_port_id(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->port_id)
-#define fc_host_port_type(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->port_type)
-#define fc_host_port_state(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->port_state)
-#define fc_host_active_fc4s(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->active_fc4s)
-#define fc_host_speed(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->speed)
-#define fc_host_fabric_name(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->fabric_name)
-#define fc_host_symbolic_name(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->symbolic_name)
-#define fc_host_system_hostname(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->system_hostname)
-#define fc_host_tgtid_bind_type(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->tgtid_bind_type)
-#define fc_host_rports(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->rports)
-#define fc_host_rport_bindings(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->rport_bindings)
-#define fc_host_vports(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->vports)
-#define fc_host_next_rport_number(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->next_rport_number)
-#define fc_host_next_target_id(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->next_target_id)
-#define fc_host_next_vport_number(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->next_vport_number)
-#define fc_host_npiv_vports_inuse(x)	\
-	(((struct fc_host_attrs *)(x)->shost_data)->npiv_vports_inuse)
-#define fc_host_work_q_name(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->work_q_name)
-#define fc_host_work_q(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->work_q)
-#define fc_host_devloss_work_q_name(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q_name)
-#define fc_host_devloss_work_q(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
-
 
 struct fc_bsg_buffer {
 	unsigned int payload_len;
@@ -632,28 +437,17 @@ struct fc_function_template {
 	void	(*get_starget_port_name)(struct scsi_target *);
 	void 	(*get_starget_port_id)(struct scsi_target *);
 
-	void 	(*get_host_port_id)(struct Scsi_Host *);
-	void	(*get_host_port_type)(struct Scsi_Host *);
 	void	(*get_host_port_state)(struct Scsi_Host *);
-	void	(*get_host_active_fc4s)(struct Scsi_Host *);
-	void	(*get_host_speed)(struct Scsi_Host *);
-	void	(*get_host_fabric_name)(struct Scsi_Host *);
-	void	(*get_host_symbolic_name)(struct Scsi_Host *);
 	void	(*set_host_system_hostname)(struct Scsi_Host *);
 
-	struct fc_host_statistics * (*get_fc_host_stats)(struct Scsi_Host *);
-	void	(*reset_fc_host_stats)(struct Scsi_Host *);
+	struct fcpinit_statistics * (*get_fcpinit_stats)(struct Scsi_Host *);
+	void	(*reset_fcpinit_stats)(struct Scsi_Host *);
 
-	int	(*issue_fc_host_lip)(struct Scsi_Host *);
+	int	(*issue_fcpinit_lip)(struct Scsi_Host *);
 
 	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
 	void	(*terminate_rport_io)(struct fc_rport *);
 
-	void	(*set_vport_symbolic_name)(struct fc_vport *);
-	int  	(*vport_create)(struct fc_vport *, bool);
-	int	(*vport_disable)(struct fc_vport *, bool);
-	int  	(*vport_delete)(struct fc_vport *);
-
 	/* target-mode drivers' functions */
 	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
@@ -664,7 +458,6 @@ struct fc_function_template {
 
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
-	u32	 			dd_fcvport_size;
 	u32				dd_bsg_size;
 
 	/*
@@ -689,22 +482,10 @@ struct fc_function_template {
 	unsigned long	show_starget_port_id:1;
 
 	/* host fixed attributes */
-	unsigned long	show_host_node_name:1;
-	unsigned long	show_host_port_name:1;
 	unsigned long	show_host_permanent_port_name:1;
-	unsigned long	show_host_supported_classes:1;
-	unsigned long	show_host_supported_fc4s:1;
-	unsigned long	show_host_supported_speeds:1;
-	unsigned long	show_host_maxframe_size:1;
-	unsigned long	show_host_serial_number:1;
+
 	/* host dynamic attributes */
-	unsigned long	show_host_port_id:1;
-	unsigned long	show_host_port_type:1;
 	unsigned long	show_host_port_state:1;
-	unsigned long	show_host_active_fc4s:1;
-	unsigned long	show_host_speed:1;
-	unsigned long	show_host_fabric_name:1;
-	unsigned long	show_host_symbolic_name:1;
 	unsigned long	show_host_system_hostname:1;
 
 	unsigned long	disable_target_scan:1;
@@ -766,26 +547,6 @@ static inline void u64_to_wwn(u64 inm, u8 *wwn)
 	wwn[7] = inm & 0xff;
 }
 
-/**
- * fc_vport_set_state() - called to set a vport's state. Saves the old state,
- *   excepting the transitory states of initializing and sending the ELS
- *   traffic to instantiate the vport on the link.
- *
- * Assumes the driver has surrounded this with the proper locking to ensure
- * a coherent state change.
- *
- * @vport:	virtual port whose state is changing
- * @new_state:  new state
- **/
-static inline void
-fc_vport_set_state(struct fc_vport *vport, enum fc_vport_state new_state)
-{
-	if ((new_state != FC_VPORT_UNKNOWN) &&
-	    (new_state != FC_VPORT_INITIALIZING))
-		vport->vport_last_state = vport->vport_state;
-	vport->vport_state = new_state;
-}
-
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
@@ -796,17 +557,71 @@ void fc_remote_port_delete(struct fc_rport  *rport);
 void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
 int scsi_is_fc_rport(const struct device *);
 u32 fc_get_event_number(void);
-void fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
-		enum fc_host_event_code event_code, u32 event_data);
-void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
-		u32 data_len, char * data_buf, u64 vendor_id);
-	/* Note: when specifying vendor_id to fc_host_post_vendor_event()
+void fcpinit_post_event(struct Scsi_Host *shost, u32 event_number,
+			enum fcpinit_event_code event_code, u32 event_data);
+void fcpinit_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
+			       u32 data_len, char * data_buf, u64 vendor_id);
+	/* Note: when specifying vendor_id to fcpinit_post_vendor_event()
 	 *   be sure to read the Vendor Type and ID formatting requirements
 	 *   specified in scsi_netlink.h
 	 */
-struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
-		struct fc_vport_identifiers *);
-int fc_vport_terminate(struct fc_vport *vport);
 void fc_block_scsi_eh(struct scsi_cmnd *cmnd);
 
+/* RWL - Temporarily add this to the common header */
+
+#define fc_enum_name_search(title, table_type, table)			\
+	const char *get_fc_##title##_name(enum table_type table_key)	\
+{									\
+	int i;								\
+	char *name = NULL;						\
+									\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
+		if (table[i].value == table_key) {			\
+			name = table[i].name;				\
+			break;						\
+		}							\
+	}								\
+	return name;							\
+}
+
+#define fc_bitfield_name_search(title, table)			\
+ssize_t get_fc_##title##_names(u32 table_key, char *buf)	\
+{								\
+	char *prefix = "";					\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+		if (table[i].value & table_key) {		\
+			len += sprintf(buf + len, "%s%s",	\
+				prefix, table[i].name);		\
+			prefix = ", ";				\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+struct _fc_port_types {
+	enum fc_port_type	value;
+	char			*name;
+};
+
+struct _fc_port_role_names {
+	u32 			value;
+	char			*name;
+};
+
+struct _fc_cos_names {
+	u32 			value;
+	char			*name;
+};
+
+#define FC_PORTTYPE_MAX_NAMELEN		50
+
+const char *get_fc_port_type_name(enum fc_port_type table_key);
+const char *get_fc_vport_type_name(enum fc_port_type table_key);
+ssize_t get_fc_port_roles_names(u32 table_key, char *buf);
+ssize_t get_fc_cos_names(u32 table_key, char *buf);
+
 #endif /* SCSI_TRANSPORT_FC_H */

