From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 4/8] fc: Add FCoE attributes to FC sysfs
Date: Mon, 07 Mar 2011 18:32:05 -0800
Message-ID: <20110308023205.6205.91641.stgit@localhost6.localdomain6>
References: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19327 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab1CHCcP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 21:32:15 -0500
In-Reply-To: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

This patch adds fcoe attributes to the FC subsystem.

 fcport: Represents physical port
   Attributes: enode_mac_address
   	       vlan_id
	       vn_port_mac_address

 fcfabric: Represents the FC fabric and switch (FCF for FCoE)
   Attributes: fc_map
   	       fka_period
	       mac_address
	       priority
	       vfid

 fcvport: Represents either an N_Port or VN_Port
   Attributes: err_block_count (Link Error Status Block)
   	       fcs_err_count (LESB)
	       link_failure_count (LESB)
	       miss_fka_count (LESB)
	       symb_err_count (LESB)
	       vlink_failure_count (LESB)

NOTE: Currently I'm using kobj directly to add a fcoe/
subdirectory under the fc devices. I don't think this is
the right thing to do. I would appreciate any advice on
the correct way to add a subdirectory.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/fc/Makefile           |    5 +-
 drivers/fc/fcfabric.c         |    9 ++-
 drivers/fc/fcfabric_fcoe.c    |  123 ++++++++++++++++++++++++++++++++++++++
 drivers/fc/fcport.c           |    8 ++
 drivers/fc/fcport_fcoe.c      |  134 +++++++++++++++++++++++++++++++++++++++++
 drivers/fc/fcsysfs.h          |   10 +++
 drivers/fc/fcvport.c          |   10 +++
 drivers/fc/fcvport_fcoe.c     |  118 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe.c      |    2 -
 drivers/scsi/fcoe/fcoe_ctlr.c |    5 +-
 drivers/scsi/libfc/fc_lport.c |    4 +
 include/fc/fc.h               |  103 ++++++++++++++++++++++++++++++--
 12 files changed, 518 insertions(+), 13 deletions(-)
 create mode 100644 drivers/fc/fcfabric_fcoe.c
 create mode 100644 drivers/fc/fcport_fcoe.c
 create mode 100644 drivers/fc/fcvport_fcoe.c

diff --git a/drivers/fc/Makefile b/drivers/fc/Makefile
index fa1d60e..5b4bc8f 100644
--- a/drivers/fc/Makefile
+++ b/drivers/fc/Makefile
@@ -4,4 +4,7 @@ fc-objs := fcsysfs.o \
 	   fcport.o \
 	   fcfabric.o \
 	   fcvport.o \
-	   fcrport.o
+	   fcrport.o \
+	   fcport_fcoe.o \
+	   fcfabric_fcoe.o \
+	   fcvport_fcoe.o
diff --git a/drivers/fc/fcfabric.c b/drivers/fc/fcfabric.c
index b275351..ef4f5df 100644
--- a/drivers/fc/fcfabric.c
+++ b/drivers/fc/fcfabric.c
@@ -383,6 +383,9 @@ static void fc_fabric_final_delete(struct work_struct *work)
 
 	mutex_unlock(&fcport->lock);
 
+	if (fcfabric->private_fcfabric_fcoe_kobj)
+		fc_fabric_del_fcoe_attrs(fcfabric);
+
 	device_del(&fcfabric->dev);
 	put_device(&fcfabric->dev); /* self-reference */
 }
@@ -457,7 +460,8 @@ struct class fcfabric_class = {
  */
 struct fc_fabric *fc_fabric_add(struct fc_port *fcport,
 				struct fc_fabric_function_template *fcn_tmpl,
-				struct fc_fabric *new_fcfabric)
+				struct fc_fabric *new_fcfabric,
+				struct fc_fabric_fcoe_attrs *fcoe_attrs)
 {
 	struct fc_fabric *fcfabric;
 	int error = 0;
@@ -526,6 +530,9 @@ struct fc_fabric *fc_fabric_add(struct fc_port *fcport,
 	if (error || count != 0)
 		goto out_del_dev;
 
+	if (fcoe_attrs)
+		fc_fabric_add_fcoe_attrs(fcfabric, fcoe_attrs);
+
 	return fcfabric;
 
 out_del_dev:
diff --git a/drivers/fc/fcfabric_fcoe.c b/drivers/fc/fcfabric_fcoe.c
new file mode 100644
index 0000000..c8b85c7
--- /dev/null
+++ b/drivers/fc/fcfabric_fcoe.c
@@ -0,0 +1,123 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
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
+#include <linux/genhd.h>
+#include "fcsysfs.h"
+
+/*
+ * Kobject attributes defined for /sys/class/fc_host/hostx/fcoe
+ * and /sys/class/fc_host/hostx/fcoe/statistics objects
+ */
+#define FCOE_KOBJECT_ATTR(_prefix, _name, _mode, _show, _store)		\
+	struct kobj_attribute kobject_attr_fcoe_##_prefix##_##_name =	\
+		__ATTR(_name, _mode, _show, _store)
+
+
+static ssize_t fc_fcoe_mac_addr_show(const struct kobject *kobj, char *buf,
+				     unsigned long offset)
+{
+	struct device *dev = kobj_to_dev(kobj->parent);
+	struct fc_fabric *fcfabric = dev_to_fcfabric(dev);
+	ssize_t ret = -ENOENT;
+
+	if (fcfabric->f->show_fcfabric_mac_address)
+		ret = sysfs_format_mac(
+			buf, fcfabric->fcoe_attrs.mac_address, 6);
+
+	return ret;
+}
+
+/* generate a read-only FCoE MAC address host attribute */
+#define fc_fcoe_mac_addr(name)					\
+static ssize_t fc_show_fcoe_mac_addr_##name(struct kobject *cd,	\
+					    struct kobj_attribute *attr, \
+					    char *buf)			\
+{									\
+	return fc_fcoe_mac_addr_show(					\
+		cd, buf, offsetof(struct fc_fabric_fcoe_attrs, name));	\
+}									\
+static FCOE_KOBJECT_ATTR(fcfabric, name, S_IRUGO,			\
+			 fc_show_fcoe_mac_addr_##name, NULL)
+
+fc_fcoe_mac_addr(mac_address);
+
+#define fc_fcoe_rd(name, format_string)				\
+static ssize_t fc_show_fcoe_##name(struct kobject *kobj,	\
+				   struct kobj_attribute *attr,		\
+				   char *buf)				\
+{									\
+	struct device *dev = kobj_to_dev(kobj->parent);			\
+	struct fc_fabric *fcfabric = dev_to_fcfabric(dev);		\
+									\
+	if (fcfabric->f->show_fcfabric_##name)				\
+		return snprintf(buf, 20, format_string,			\
+				fcfabric->fcoe_attrs.name);		\
+	return -ENOENT;							\
+}									\
+static FCOE_KOBJECT_ATTR(fcfabric, name, S_IRUGO, fc_show_fcoe_##name, NULL)
+
+fc_fcoe_rd(fc_map, "0x%x\n");
+fc_fcoe_rd(vfid, "0x%x\n");
+fc_fcoe_rd(priority, "%u\n");
+fc_fcoe_rd(fka_period, "%u\n");
+
+#define FCOE_SETUP_COND_ATTR_RD(_var, field)			\
+if (_var->f->show_##_var##_##field) {				\
+	_var->fcfabric_fcoe_attrs[count] =				\
+		&kobject_attr_fcoe_##_var##_##field.attr;		\
+	count++;							\
+}
+
+void fc_fabric_del_fcoe_attrs(struct fc_fabric *fcfabric)
+{
+	kobject_put(fcfabric->private_fcfabric_fcoe_kobj);
+	fcfabric->private_fcfabric_fcoe_kobj = NULL;
+}
+
+int fc_fabric_add_fcoe_attrs(struct fc_fabric *fcfabric,
+			     struct fc_fabric_fcoe_attrs *fcoe_attrs)
+{
+	int count = 0;
+	int error;
+
+	memcpy(&fcfabric->fcoe_attrs, fcoe_attrs,
+	       sizeof(struct fc_fabric_fcoe_attrs));
+
+	FCOE_SETUP_COND_ATTR_RD(fcfabric, fc_map);
+	FCOE_SETUP_COND_ATTR_RD(fcfabric, vfid);
+	FCOE_SETUP_COND_ATTR_RD(fcfabric, mac_address);
+	FCOE_SETUP_COND_ATTR_RD(fcfabric, priority);
+	FCOE_SETUP_COND_ATTR_RD(fcfabric, fka_period);
+
+	fcfabric->fcoe_attrs_group.attrs = fcfabric->fcfabric_fcoe_attrs;
+
+	/* Create a fcoe sub-directory under /sys/class/fc_host/hostX/ */
+	fcfabric->private_fcfabric_fcoe_kobj =
+		kobject_create_and_add("fcoe", &fcfabric->dev.kobj);
+	if (fcfabric->private_fcfabric_fcoe_kobj) {
+		/* Create the files associated with this kobject */
+		error = sysfs_create_group(fcfabric->private_fcfabric_fcoe_kobj,
+					   &fcfabric->fcoe_attrs_group);
+		if (error) {
+			kobject_put(fcfabric->private_fcfabric_fcoe_kobj);
+			goto error;
+		}
+	}
+
+error:
+	return 0;
+}
diff --git a/drivers/fc/fcport.c b/drivers/fc/fcport.c
index e9dc2b7..299f220 100644
--- a/drivers/fc/fcport.c
+++ b/drivers/fc/fcport.c
@@ -225,6 +225,9 @@ void fc_port_del(struct fc_port *fcport)
 	destroy_workqueue(fcport->work_q);
 	fcport->work_q = NULL;
 
+	if (fcport->private_fcport_fcoe_kobj)
+		fc_port_del_fcoe_attrs(fcport);
+
 	device_del(&fcport->dev);
 	put_device(&fcport->dev); /* self-reference */
 }
@@ -242,7 +245,7 @@ EXPORT_SYMBOL(fc_port_del);
  */
 struct fc_port *fc_port_add(struct device *pdev,
 			    struct fc_port_function_template *fcn_tmpl,
-			    void *fc4_f)
+			    void *fc4_f, struct fc_port_fcoe_attrs *fcoe_attrs)
 {
 	struct fc_port *fcport;
 	int count = 0;
@@ -316,6 +319,9 @@ struct fc_port *fc_port_add(struct device *pdev,
 	if (error || count != 0)
 		goto out_del_dev;
 
+	if (fcoe_attrs)
+		fc_port_add_fcoe_attrs(fcport, fcoe_attrs);
+
 	return fcport;
 
 out_del_dev:
diff --git a/drivers/fc/fcport_fcoe.c b/drivers/fc/fcport_fcoe.c
new file mode 100644
index 0000000..94609dc
--- /dev/null
+++ b/drivers/fc/fcport_fcoe.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
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
+#include <linux/genhd.h>
+#include "fcsysfs.h"
+
+/*
+ * Kobject attributes defined for /sys/class/fc_host/hostx/fcoe
+ * and /sys/class/fc_host/hostx/fcoe/statistics objects
+ */
+#define FCOE_KOBJECT_ATTR(_prefix, _name, _mode, _show, _store)		\
+	struct kobj_attribute kobject_attr_fcoe_##_prefix##_##_name =	\
+		__ATTR(_name, _mode, _show, _store)
+
+#define fc_fcoe_rd(name, format_string)					\
+static ssize_t fc_show_fcoe_##name(struct kobject *kobj,		\
+				   struct kobj_attribute *attr,		\
+				   char *buf)				\
+{									\
+	struct device *dev = kobj_to_dev(kobj->parent);			\
+	struct fc_port *fcport = dev_to_fcport(dev);			\
+									\
+	if (fcport->f->show_fcport_##name)				\
+		return snprintf(buf, 20, format_string,			\
+				fcport->fcoe_attrs.name);		\
+	return -ENOENT;							\
+}									\
+static FCOE_KOBJECT_ATTR(fcport, name, S_IRUGO, fc_show_fcoe_##name, NULL)
+
+fc_fcoe_rd(vlan_id, "%u\n");
+
+#define fc_fcoe_static_mac_addr(name)					\
+static ssize_t fc_show_fcoe_static_mac_addr_##name(struct kobject *kobj, \
+						   struct kobj_attribute *attr,\
+						   char *buf)		\
+{									\
+	struct device *dev = kobj_to_dev(kobj->parent);			\
+	struct fc_port *fcport = dev_to_fcport(dev);			\
+	ssize_t ret = -ENOENT;						\
+									\
+	if (fcport->f->show_fcport_##name)				\
+		return sysfs_format_mac(buf, fcport->fcoe_attrs.name, 6); \
+	return ret;							\
+}									\
+static FCOE_KOBJECT_ATTR(fcport, name, S_IRUGO,				\
+			 fc_show_fcoe_static_mac_addr_##name, NULL)
+
+fc_fcoe_static_mac_addr(enode_mac_address);
+
+#define fc_fcoe_dyn_mac_addr(name)				      \
+static ssize_t fc_show_fcoe_dyn_mac_addr_##name(struct kobject *kobj, \
+						struct kobj_attribute *attr, \
+						char *buf)		\
+{									\
+	struct device *dev = kobj_to_dev(kobj->parent);			\
+	struct fc_port *fcport = dev_to_fcport(dev);			\
+	ssize_t ret = -ENOENT;						\
+									\
+	if (fcport->f->get_fcport_##name) {				\
+		fcport->f->get_fcport_##name(fcport);			\
+		return sysfs_format_mac(buf, fcport->fcoe_attrs.name, 6); \
+	}								\
+	return ret;							\
+}									\
+static FCOE_KOBJECT_ATTR(fcport, name, S_IRUGO,				\
+			 fc_show_fcoe_dyn_mac_addr_##name, NULL)
+
+fc_fcoe_dyn_mac_addr(vn_port_mac_address);
+
+#define FCOE_SETUP_COND_ATTR_RD(_var, field)				\
+	if (_var->f->show_##_var##_##field) {				\
+		_var->fcport_fcoe_attrs[count] =			\
+			&kobject_attr_fcoe_##_var##_##field.attr;	\
+		count++;						\
+	}
+
+#define FCOE_SETUP_ATTR_RD_NS(_var, field)				\
+	do {								\
+		_var->fcport_fcoe_attrs[count] =			\
+			&kobject_attr_fcoe_##_var##_##field.attr;	\
+		count++;						\
+	} while (0)
+
+void fc_port_del_fcoe_attrs(struct fc_port *fcport)
+{
+	kobject_put(fcport->private_fcport_fcoe_kobj);
+	fcport->private_fcport_fcoe_kobj = NULL;
+}
+
+int fc_port_add_fcoe_attrs(struct fc_port *fcport,
+			   struct fc_port_fcoe_attrs *fcoe_attrs)
+{
+	int count = 0;
+	int error;
+
+	memcpy(&fcport->fcoe_attrs, fcoe_attrs,
+	       sizeof(struct fc_port_fcoe_attrs));
+
+	FCOE_SETUP_COND_ATTR_RD(fcport, enode_mac_address);
+	FCOE_SETUP_ATTR_RD_NS(fcport, vn_port_mac_address);
+	FCOE_SETUP_COND_ATTR_RD(fcport, vlan_id);
+
+	fcport->fcoe_attrs_group.attrs = fcport->fcport_fcoe_attrs;
+
+	/* Create a fcoe sub-directory under /sys/class/fc_host/hostX/ */
+	fcport->private_fcport_fcoe_kobj =
+		kobject_create_and_add("fcoe", &fcport->dev.kobj);
+	if (fcport->private_fcport_fcoe_kobj) {
+		/* Create the files associated with this kobject */
+		error = sysfs_create_group(fcport->private_fcport_fcoe_kobj,
+					   &fcport->fcoe_attrs_group);
+		if (error) {
+			kobject_put(fcport->private_fcport_fcoe_kobj);
+			goto error;
+		}
+	}
+
+error:
+	return 0;
+}
diff --git a/drivers/fc/fcsysfs.h b/drivers/fc/fcsysfs.h
index 9bd7936..2f00775 100644
--- a/drivers/fc/fcsysfs.h
+++ b/drivers/fc/fcsysfs.h
@@ -89,4 +89,14 @@ const char *get_fc_port_state_name(enum fc_port_state table_key);
 
 const char *get_fc_vport_state_name(enum fc_vport_state table_key);
 
+/* FCoE Attribute Interfaces */
+int fc_port_add_fcoe_attrs(struct fc_port *fcport,
+			   struct fc_port_fcoe_attrs *fcoe_attrs);
+void fc_port_del_fcoe_attrs(struct fc_port *fcport);
+int fc_fabric_add_fcoe_attrs(struct fc_fabric *fcfabric,
+			     struct fc_fabric_fcoe_attrs *fcoe_attrs);
+void fc_fabric_del_fcoe_attrs(struct fc_fabric *fcfabric);
+int fc_vport_add_fcoe_attrs(struct fc_vport *fcvport);
+void fc_vport_del_fcoe_attrs(struct fc_vport *fcvport);
+
 #endif /*_FC_SYSFS_H_*/
diff --git a/drivers/fc/fcvport.c b/drivers/fc/fcvport.c
index 3dcfb49..112303c 100644
--- a/drivers/fc/fcvport.c
+++ b/drivers/fc/fcvport.c
@@ -356,6 +356,9 @@ void fc_vport_del(struct fc_vport *fcvport)
 
 	fc_vport_flush_work(fcvport);
 
+	if (fcvport->private_fcvport_fcoe_kobj)
+		fc_vport_del_fcoe_attrs(fcvport);
+
 	put_device(&fcvport->dev); /* For rports list */
 	device_del(&fcvport->dev);
 	put_device(fcvport->dev.parent);
@@ -481,13 +484,15 @@ EXPORT_SYMBOL(fc_vport_alloc);
 
 /**
  * fc_vport_add() - Add a FC vport to a FC fabric
+ * @fcfabric: The Fabric to add the vport to
  * @fcvport:  The FC vport to add
+ * @fcoe:     Is the FC vport a FCoE vport?
  *
  * Add the device to sysfs and then populate it with
  * attributes.
  */
 int fc_vport_add(struct fc_fabric *fcfabric,
-		 struct fc_vport *fcvport)
+		 struct fc_vport *fcvport, int fcoe)
 {
 	int count = 0;
 	int error = 0;
@@ -545,6 +550,9 @@ int fc_vport_add(struct fc_fabric *fcfabric,
 	if (error || count != 0)
 		goto out_del_dev;
 
+	if (fcoe)
+		fc_vport_add_fcoe_attrs(fcvport);
+
 	return 0;
 
 out_del_dev:
diff --git a/drivers/fc/fcvport_fcoe.c b/drivers/fc/fcvport_fcoe.c
new file mode 100644
index 0000000..3fdc6dd
--- /dev/null
+++ b/drivers/fc/fcvport_fcoe.c
@@ -0,0 +1,118 @@
+/*
+ * Copyright(c) 2010 Intel Corporation. All rights reserved.
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
+#include <linux/genhd.h>
+#include "fcsysfs.h"
+
+/*
+ * Kobject attributes defined for /sys/class/fc_host/hostx/fcoe
+ * and /sys/class/fc_host/hostx/fcoe/statistics objects
+ */
+#define FCOE_KOBJECT_ATTR(_name, _mode, _show, _store)		\
+	struct kobj_attribute kobject_attr_vport_fcoe_##_name =	\
+		__ATTR(_name, _mode, _show, _store)
+
+/* Read FCoE host statistics */
+static ssize_t fc_vport_fcoe_lesb_show(const struct kobject *kobj,
+				       char *buf,
+				       unsigned long offset)
+{
+	struct device *dev = kobj_to_dev(kobj->parent);
+	struct fc_vport *fcvport = dev_to_fcvport(dev);
+	struct fc_vport_fcoe_lesb lesb;
+	ssize_t ret = -ENOENT;
+
+	if (offset > sizeof(struct fc_vport_fcoe_lesb) ||
+	    offset % sizeof(u32) != 0)
+		WARN_ON(1);
+
+	if (fcvport->f->get_fcvport_fcoe_lesb) {
+		if (!(fcvport->f->get_fcvport_fcoe_lesb)(fcvport, &lesb))
+			ret = snprintf(buf, 20, "0x%x\n",
+				       (unsigned int)*(u32 *)(((u8 *) &lesb)
+							      + offset));
+	}
+
+	return ret;
+}
+
+/* generate a read-only FCoE host staistics attribute */
+#define fc_vport_fcoe_lesb(name)				  \
+static ssize_t fc_show_vport_fcoe_lesb_##name(struct kobject *cd, \
+					      struct kobj_attribute *attr, \
+					      char *buf)		\
+{									\
+	return fc_vport_fcoe_lesb_show(cd, buf,				\
+				       offsetof(struct fc_vport_fcoe_lesb, \
+						name));			\
+}									\
+static FCOE_KOBJECT_ATTR(name, S_IRUGO,	fc_show_vport_fcoe_lesb_##name, NULL)
+
+fc_vport_fcoe_lesb(link_failure_count);
+fc_vport_fcoe_lesb(vlink_failure_count);
+fc_vport_fcoe_lesb(miss_fka_count);
+fc_vport_fcoe_lesb(symb_err_count);
+fc_vport_fcoe_lesb(err_block_count);
+fc_vport_fcoe_lesb(fcs_err_count);
+
+static struct attribute *fcvport_fcoe_lesb[] = {
+	&kobject_attr_vport_fcoe_link_failure_count.attr,
+	&kobject_attr_vport_fcoe_vlink_failure_count.attr,
+	&kobject_attr_vport_fcoe_miss_fka_count.attr,
+	&kobject_attr_vport_fcoe_symb_err_count.attr,
+	&kobject_attr_vport_fcoe_err_block_count.attr,
+	&kobject_attr_vport_fcoe_fcs_err_count.attr,
+	NULL
+};
+
+static struct attribute_group fcvport_fcoe_lesb_group = {
+	.attrs = fcvport_fcoe_lesb,
+};
+
+void fc_vport_del_fcoe_attrs(struct fc_vport *fcvport)
+{
+	kobject_put(fcvport->private_fcvport_fcoe_kobj);
+	fcvport->private_fcvport_fcoe_kobj = NULL;
+}
+
+int fc_vport_add_fcoe_attrs(struct fc_vport *fcvport)
+{
+	int error = 0;
+
+	if (fcvport->f->get_fcvport_fcoe_lesb) {
+		/*
+		 * Create a fcoe sub-directory under
+		 * /sys/class/fc_host/hostX/
+		 */
+		fcvport->private_fcvport_fcoe_kobj =
+			kobject_create_and_add("fcoe",
+					       &fcvport->dev.kobj);
+		if (fcvport->private_fcvport_fcoe_kobj) {
+			/* Create the files associated with this kobject */
+			error = sysfs_create_group(
+				fcvport->private_fcvport_fcoe_kobj,
+				&fcvport_fcoe_lesb_group);
+			if (error) {
+				kobject_put(fcvport->private_fcvport_fcoe_kobj);
+				goto error;
+			}
+		}
+	}
+
+error:
+	return error;
+}
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index baed0f4..5064086 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -399,7 +399,7 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	}
 
 	fcport = fc_port_add((struct device *)&netdev->dev.parent,
-			     &fcoe_fcport_fcn_tmpl, &fcoe_fcp_template);
+			     &fcoe_fcport_fcn_tmpl, &fcoe_fcp_template, NULL);
 	if (!fcport) {
 		printk(KERN_ERR "Failed to add a fcport\n");
 		fcoe = ERR_PTR(-ENOMEM);
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 501fcc0..27c5e67 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -956,7 +956,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	first = list_empty(&fcport->fabrics);
 
 	fcfabric = fc_fabric_add(fcport, fip->fcfabric_f,
-				 new_fcfabric);
+				 new_fcfabric, NULL);
 	if (unlikely(!fcfabric))
 		goto out;
 
@@ -2733,7 +2733,8 @@ unlock:
 
 	/* If port ID is new, notify local port after dropping ctlr_mutex */
 	if (new_port_id) {
-		fcvport->fcfabric = fc_fabric_add(fcport, fip->fcfabric_f, 0);
+		fcvport->fcfabric = fc_fabric_add(fcport, fip->fcfabric_f,
+						  0, NULL);
 		fc_lport_set_local_id(fip->lp, new_port_id);
 	}
 }
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index d3f2b0c..37a4bad 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -760,7 +760,7 @@ void fc_lport_set_local_id(struct fc_lport *lport, u32 port_id)
 	case LPORT_ST_FLOGI:
 		if (port_id) {
 			mutex_lock(&fcport->lock);
-			fc_vport_add(lport->fcfabric, fcvport);
+			fc_vport_add(lport->fcfabric, fcvport, 0);
 			mutex_unlock(&fcport->lock);
 
 			fc_lport_enter_ready(lport);
@@ -1554,7 +1554,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				fc_lport_set_port_id(lport, did, fp);
 
 				mutex_lock(&fcport->lock);
-				fc_vport_add(lport->fcfabric, fcvport);
+				fc_vport_add(lport->fcfabric, fcvport, 0);
 				mutex_unlock(&fcport->lock);
 
 				fc_lport_enter_dns(lport);
diff --git a/include/fc/fc.h b/include/fc/fc.h
index c59d191..6158095 100644
--- a/include/fc/fc.h
+++ b/include/fc/fc.h
@@ -18,6 +18,7 @@
 #ifndef _FC_H_
 #define _FC_H_
 
+#include <linux/etherdevice.h>
 #include <linux/device.h>
 #include <linux/sched.h>
 
@@ -26,8 +27,65 @@ struct fc_fabric;
 struct fc_vport;
 struct fc_rport;
 
+struct fc_port_function_template;
 struct fc_vport_function_template;
 
+struct fc_fabric_fcoe_attrs;
+
+/*
+ * mac_addressing_mode: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fcoe_mac_addressing_mode {
+	FCF_SELECTED,
+	SPMA_ONLY,
+	FPMA_ONLY,
+	SPMA_PREFERRED,
+	FPMA_PREFERRED,
+};
+
+/*
+ * FCoE Local Port (Host) Attributes
+ *
+ * Fixed attributes are not expected to change. The driver is
+ * expected to set these values after successfully calling scsi_add_host().
+ * The transport fully manages all get functions w/o driver interaction.
+ *
+ * Dynamic attributes are expected to change. The driver participates
+ * in all get/set operations via functions provided by the driver.
+ *
+ */
+struct fc_port_fcoe_attrs {
+	/* Static Attributes */
+	uint8_t enode_mac_address[ETH_ALEN];
+	u16 vlan_id;
+
+	/* Dynamic Attributes */
+	uint8_t vn_port_mac_address[ETH_ALEN];
+};
+
+struct fc_fabric_fcoe_attrs {
+	/* Static Attributes */
+	u32 fc_map;
+	u16 vfid;
+	uint8_t mac_address[ETH_ALEN];
+	uint8_t priority;
+	u32 fka_period;
+};
+
+/*
+ * FCoE Statistics - Following proposal for FC_BB_E FC Link error
+ * status block representation from T11/09-204v0 guidelines
+ */
+struct fc_vport_fcoe_lesb {
+	u32 link_failure_count;
+	u32 vlink_failure_count;
+	u32 miss_fka_count;
+	u32 symb_err_count;
+	u32 err_block_count;
+	u32 fcs_err_count;
+};
+
 /*
  * FC Port definitions - Following FC HBAAPI guidelines
  *
@@ -306,6 +364,13 @@ struct _fc_cos_names {
 #define FC_RPORT_NUM_ATTRS   9
 #define FC_FABRIC_NUM_ATTRS  6
 
+/*
+ * These defines are FCoE attributes + 1 so the last
+ * entry in the attribute_group is NULL
+ */
+#define FC_PORT_FCOE_NUM_ATTRS   4
+#define FC_FABRIC_FCOE_NUM_ATTRS 6
+
 struct fc_rport_function_template {
 	void (*get_rport_dev_loss_tmo)(struct fc_rport *);
 	void (*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
@@ -430,6 +495,9 @@ struct fc_vport_function_template {
 
 	int (*issue_fcvport_lip)(struct fc_vport *);
 
+	int (*get_fcvport_fcoe_lesb)(struct fc_vport *,
+				     struct fc_vport_fcoe_lesb *);
+
 	unsigned long show_fcvport_permanent_port_name:1;
 	unsigned long show_fcvport_port_id:1;
 	unsigned long show_fcvport_symbolic_name:1;
@@ -448,6 +516,13 @@ struct fc_fabric_function_template {
 	unsigned long show_fcfabric_fabric_name:1;
 	unsigned long show_fcfabric_dev_loss_tmo:1;
 
+	/* FCoE Static Attributes */
+	unsigned long show_fcfabric_fc_map:1;
+	unsigned long show_fcfabric_vfid:1;
+	unsigned long show_fcfabric_mac_address:1;
+	unsigned long show_fcfabric_priority:1;
+	unsigned long show_fcfabric_fka_period:1;
+
 	u32 dd_fcfabric_size;
 };
 
@@ -489,6 +564,11 @@ struct fc_fabric {
 
 	struct list_head vports; /* uses the fcport->lock */
 	struct device_attribute attrs[FC_FABRIC_NUM_ATTRS];
+	struct attribute *fcfabric_fcoe_attrs[FC_FABRIC_FCOE_NUM_ATTRS];
+	struct kobject *private_fcfabric_fcoe_kobj;
+	struct attribute_group fcoe_attrs_group;
+
+	struct fc_fabric_fcoe_attrs fcoe_attrs;
 };
 
 static inline void *fc_fabric_priv(const struct fc_fabric *fcfabric)
@@ -529,6 +609,13 @@ struct fc_port_function_template {
 	u32 dd_fcport_size;
 
 	struct fc_vport_function_template fcvport_f;
+
+	/* Static Attributes */
+	unsigned long show_fcport_enode_mac_address:1;
+	unsigned long show_fcport_vlan_id:1;
+
+	/* Dynamic Attributes */
+	void (*get_fcport_vn_port_mac_address)(struct fc_port *);
 };
 
 struct fc_port {
@@ -542,7 +629,11 @@ struct fc_port {
 	struct mutex                    lock;
 	struct fc_port_function_template *f;
 	void *fc4_f;
+
 	struct device_attribute attrs[FC_PORT_NUM_ATTRS];
+	struct attribute *fcport_fcoe_attrs[FC_PORT_FCOE_NUM_ATTRS];
+	struct kobject *private_fcport_fcoe_kobj;
+	struct attribute_group fcoe_attrs_group;
 
 	/* Fixed Attributes */
 	u8   supported_fc4s[FC_FC4_LIST_SIZE];
@@ -562,6 +653,8 @@ struct fc_port {
 	u32 speed;
 
 	int fab_dev_loss_tmo;
+
+	struct fc_port_fcoe_attrs fcoe_attrs;
 };
 
 static inline void *fc_port_priv(const struct fc_port *fcport)
@@ -644,6 +737,8 @@ struct fc_vport {
 	struct fc_fabric *fcfabric; /* fabric on which the
 				       vport was created */
 	struct device_attribute attrs[FC_VPORT_NUM_ATTRS];
+	struct kobject *private_fcvport_fcoe_kobj;
+	struct attribute_group fcoe_attrs_group;
 
 	struct fc4_template *fc4_f;
 
@@ -811,10 +906,11 @@ struct fc_vport *fc_vport_lookup(struct fc_fabric *fcfabric,
 
 struct fc_port *fc_port_add(struct device *pdev,
 			    struct fc_port_function_template *,
-			    void *fc4_f);
+			    void *fc4_f, struct fc_port_fcoe_attrs *);
 struct fc_fabric *fc_fabric_add(struct fc_port *fcport,
 				struct fc_fabric_function_template *,
-				struct fc_fabric *);
+				struct fc_fabric *,
+				struct fc_fabric_fcoe_attrs *);
 struct fc_vport *fc_vport_alloc(struct fc_vport *fcnport,
 				struct fc_vport_identifiers *ids,
 				struct fc_vport_function_template *fcn_tmpl,
@@ -822,8 +918,7 @@ struct fc_vport *fc_vport_alloc(struct fc_vport *fcnport,
 struct fc_vport *fc_vport_create(struct fc_fabric *, int channel,
 				 struct fc_vport_identifiers *);
 int fc_vport_add(struct fc_fabric *fcfabric,
-		 struct fc_vport *fcvport);
-
+		 struct fc_vport *fcvport, int fcoe);
 void fc_port_del(struct fc_port *fcport);
 void fc_port_del_fabrics(struct fc_port *fcport);
 void fc_fabric_del(struct fc_fabric *fcfabric);

