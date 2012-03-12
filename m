From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/4] libfcoe: Add fcoe_sysfs
Date: Mon, 12 Mar 2012 16:09:31 -0700
Message-ID: <20120312230931.10580.58845.stgit@localhost6.localdomain6>
References: <20120312230915.10580.52548.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab2CLXKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Mar 2012 19:10:22 -0400
In-Reply-To: <20120312230915.10580.52548.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, james.smart@emulex.com, giridhar.malavali@qlogic.com

This patch adds infrastructure to libfcoe allow LLDs to
present FIP (FCoE Initialization Protocol) discovered
entities and their attributes to user space via sysfs.

This patch adds the following APIs-

fcoe_ctlr_attrs_add
fcoe_ctlr_attrs_delete
fcoe_fcf_attrs_add
fcoe_fcf_attrs_delete

They allow the LLD to expose the FCoE ENode Controller
and any discovered FCFs (Fibre Channel Forwarders, e.g.
FCoE switches) to the user. Each of these new devices
has their own class so that they are grouped together
for easy lookup from a user space application. Each
new class has an attribute_group to expose attributes
for any created instances. The attributes are-

fcoe_ctlr_attrs
* fcf_dev_loss_tmo
* lesb_link_fail
* lesb_vlink_fail
* lesb_miss_fka
* lesb_symb_err
* lesb_err_block
* lesb_fcs_error

fcoe_fcf_attrs
* fabric_name
* switch_name
* priority
* selected
* fc_map
* vfid
* mac
* fka_peroid
* fabric_state
* dev_loss_tmo

A device loss infrastructre similar to the FC Transport's
is also added by this patch. It is nice to have so that a
link flapping adapter doesn't continually advance the count
used to identify the discovered FCF. FCFs will exist in a
"Disconnected" state until either the timer expires or the
FCF is rediscovered and becomes "Connected."

This patch generates a few checkpatch.pl WARNINGS that
I'm not sure what to do about. They're macros modeled
around the FC Transport attribute building macros, which
have the same 'feature' where the caller can ommit a cast
in the argument list and no cast occurs in the code. I'm
not sure how to keep the code condensed while keeping the
macros. Any advice would be appreciated.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/Makefile         |    2 
 drivers/scsi/fcoe/fcoe_sysfs.c     |  793 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_transport.c |   13 -
 include/scsi/fcoe_sysfs.h          |  174 ++++++++
 include/scsi/libfcoe.h             |    1 
 5 files changed, 980 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe_sysfs.c
 create mode 100644 include/scsi/fcoe_sysfs.h

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index f6d37d0..aed0f5d 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_FCOE) += fcoe.o
 obj-$(CONFIG_LIBFCOE) += libfcoe.o
 
-libfcoe-objs := fcoe_ctlr.o fcoe_transport.o
+libfcoe-objs := fcoe_ctlr.o fcoe_transport.o fcoe_sysfs.o
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
new file mode 100644
index 0000000..ee36aa3
--- /dev/null
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -0,0 +1,793 @@
+/*
+ * Copyright(c) 2011 - 2012 Intel Corporation. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/etherdevice.h>
+
+#include <scsi/fcoe_sysfs.h>
+
+static atomic_t ctlr_num;
+static atomic_t fcf_num;
+
+/*
+ * fcoe_fcf_dev_loss_tmo: the default number of seconds that fcoe sysfs
+ * should insulate the loss of a fcf.
+ */
+static unsigned int fcoe_fcf_dev_loss_tmo = 1800;  /* seconds */
+
+module_param_named(fcf_dev_loss_tmo, fcoe_fcf_dev_loss_tmo,
+		   uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(fcf_dev_loss_tmo,
+		 "Maximum number of seconds that libfcoe should"
+		 " insulate the loss of a fcf. Once this value is"
+		 " exceeded, the fcf is removed.");
+
+
+/*
+ * dev_loss_tmo attribute (stolen from SCSI FC Transport)
+ */
+static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val)
+{
+	char *cp;
+
+	*val = simple_strtoul(buf, &cp, 0);
+	if ((*cp && (*cp != '\n')) || (*val < 0))
+		return -EINVAL;
+	/*
+	 * Check for overflow; dev_loss_tmo is u32
+	 */
+	if (*val > UINT_MAX)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fcoe_fcf_set_dev_loss_tmo(struct fcoe_fcf_attrs *fcf,
+				     unsigned long val)
+{
+	if ((fcf->state == FCOE_FCF_STATE_UNKNOWN) ||
+	    (fcf->state == FCOE_FCF_STATE_DISCONNECTED) ||
+	    (fcf->state == FCOE_FCF_STATE_DELETED))
+		return -EBUSY;
+	/*
+	 * Check for overflow; dev_loss_tmo is u32
+	 */
+	if (val > UINT_MAX)
+		return -EINVAL;
+
+	fcoe_fcf_dev_loss_tmo(fcf) = val;
+	return 0;
+}
+
+#define FCOE_DEVICE_ATTR(_prefix, _name, _mode, _show, _store)	\
+struct device_attribute device_attr_fcoe_##_prefix##_##_name =	\
+	__ATTR(_name, _mode, _show, _store)
+
+#define fcoe_ctlr_show_function(field, format_string, sz, cast)	\
+static ssize_t show_fcoe_ctlr_attrs_##field(struct device *dev, \
+					    struct device_attribute *attr, \
+					    char *buf)			\
+{									\
+	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);		\
+	if (ctlr->f->get_fcoe_ctlr_##field)				\
+		ctlr->f->get_fcoe_ctlr_##field(ctlr);			\
+	return snprintf(buf, sz, format_string,				\
+			cast fcoe_ctlr_##field(ctlr));			\
+}
+
+#define fcoe_fcf_show_function(field, format_string, sz, cast)	\
+static ssize_t show_fcoe_fcf_attrs_##field(struct device *dev,	\
+					   struct device_attribute *attr, \
+					   char *buf)			\
+{									\
+	struct fcoe_fcf_attrs *fcf = dev_to_fcf(dev);			\
+	struct fcoe_ctlr_attrs *ctlr = fcoe_fcf_to_ctlr(fcf);		\
+	if (ctlr->f->get_fcoe_fcf_##field)				\
+		ctlr->f->get_fcoe_fcf_##field(fcf);			\
+	return snprintf(buf, sz, format_string,				\
+			cast fcoe_fcf_##field(fcf));			\
+}
+
+#define fcoe_ctlr_private_show_function(field, format_string, sz, cast)	\
+static ssize_t show_fcoe_ctlr_attrs_##field(struct device *dev, \
+					    struct device_attribute *attr, \
+					    char *buf)			\
+{									\
+	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);		\
+	return snprintf(buf, sz, format_string, cast fcoe_ctlr_##field(ctlr)); \
+}
+
+#define fcoe_fcf_private_show_function(field, format_string, sz, cast)	\
+static ssize_t show_fcoe_fcf_attrs_##field(struct device *dev,	\
+					   struct device_attribute *attr, \
+					   char *buf)			\
+{								\
+	struct fcoe_fcf_attrs *fcf = dev_to_fcf(dev);			\
+	return snprintf(buf, sz, format_string, cast fcoe_fcf_##field(fcf)); \
+}
+
+#define fcoe_ctlr_private_rd_attr(field, format_string, sz)		\
+	fcoe_ctlr_private_show_function(field, format_string, sz, )	\
+	static FCOE_DEVICE_ATTR(ctlr, field, S_IRUGO,			\
+				show_fcoe_ctlr_attrs_##field, NULL)
+
+#define fcoe_ctlr_rd_attr(field, format_string, sz)			\
+	fcoe_ctlr_show_function(field, format_string, sz, )		\
+	static FCOE_DEVICE_ATTR(ctlr, field, S_IRUGO,			\
+				show_fcoe_ctlr_attrs_##field, NULL)
+
+#define fcoe_fcf_rd_attr(field, format_string, sz)			\
+	fcoe_fcf_show_function(field, format_string, sz, )		\
+	static FCOE_DEVICE_ATTR(fcf, field, S_IRUGO,			\
+				show_fcoe_fcf_attrs_##field, NULL)
+
+#define fcoe_fcf_private_rd_attr(field, format_string, sz)		\
+	fcoe_fcf_private_show_function(field, format_string, sz, )	\
+	static FCOE_DEVICE_ATTR(fcf, field, S_IRUGO,			\
+				show_fcoe_fcf_attrs_##field, NULL)
+
+#define fcoe_ctlr_private_rd_attr_cast(field, format_string, sz, cast)	\
+	fcoe_ctlr_private_show_function(field, format_string, sz, (cast)) \
+	static FCOE_DEVICE_ATTR(ctlr, field, S_IRUGO,			\
+				show_fcoe_ctlr_attrs_##field, NULL)
+
+#define fcoe_fcf_private_rd_attr_cast(field, format_string, sz, cast)	\
+	fcoe_fcf_private_show_function(field, format_string, sz, (cast)) \
+	static FCOE_DEVICE_ATTR(fcf, field, S_IRUGO,			\
+				show_fcoe_fcf_attrs_##field, NULL)
+
+#define fcoe_enum_name_search(title, table_type, table)			\
+static const char *get_fcoe_##title##_name(enum table_type table_key)	\
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
+static struct {
+	enum fcf_state value;
+	char           *name;
+} fcf_state_names[] = {
+	{ FCOE_FCF_STATE_UNKNOWN,      "Unknown" },
+	{ FCOE_FCF_STATE_DISCONNECTED, "Disconnected" },
+	{ FCOE_FCF_STATE_CONNECTED,    "Connected" },
+};
+fcoe_enum_name_search(fcf_state, fcf_state, fcf_state_names)
+#define FCOE_FCF_STATE_MAX_NAMELEN 50
+
+static ssize_t show_fcf_state(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct fcoe_fcf_attrs *fcf = dev_to_fcf(dev);
+	const char *name;
+	name = get_fcoe_fcf_state_name(fcf->state);
+	if (!name)
+		return -EINVAL;
+	return snprintf(buf, FCOE_FCF_STATE_MAX_NAMELEN, "%s\n", name);
+}
+static FCOE_DEVICE_ATTR(fcf, state, S_IRUGO, show_fcf_state, NULL);
+
+static struct {
+	enum fip_conn_type value;
+	char               *name;
+} fip_conn_type_names[] = {
+	{ FIP_CONN_TYPE_UNKNOWN, "Unknown" },
+	{ FIP_CONN_TYPE_FABRIC, "Fabric" },
+	{ FIP_CONN_TYPE_VN2VN, "VN2VN" },
+};
+fcoe_enum_name_search(ctlr_mode, fip_conn_type, fip_conn_type_names)
+#define FCOE_CTLR_MODE_MAX_NAMELEN 50
+
+static ssize_t show_ctlr_mode(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);
+	const char *name;
+
+	if (ctlr->f->get_fcoe_ctlr_mode)
+		ctlr->f->get_fcoe_ctlr_mode(ctlr);
+
+	name = get_fcoe_ctlr_mode_name(ctlr->mode);
+	if (!name)
+		return -EINVAL;
+	return snprintf(buf, FCOE_CTLR_MODE_MAX_NAMELEN,
+			"%s\n", name);
+}
+static FCOE_DEVICE_ATTR(ctlr, mode, S_IRUGO,
+			show_ctlr_mode, NULL);
+
+static ssize_t
+store_private_fcoe_ctlr_fcf_dev_loss_tmo(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);
+	struct fcoe_fcf_attrs *fcf;
+	unsigned long val;
+	int rc;
+
+	rc = fcoe_str_to_dev_loss(buf, &val);
+	if (rc)
+		return rc;
+
+	fcoe_ctlr_fcf_dev_loss_tmo(ctlr) = val;
+	mutex_lock(&ctlr->lock);
+	list_for_each_entry(fcf, &ctlr->fcfs, peers)
+		fcoe_fcf_set_dev_loss_tmo(fcf, val);
+	mutex_unlock(&ctlr->lock);
+	return count;
+}
+fcoe_ctlr_private_show_function(fcf_dev_loss_tmo, "%d\n", 20, );
+static FCOE_DEVICE_ATTR(ctlr, fcf_dev_loss_tmo, S_IRUGO | S_IWUSR,
+			show_fcoe_ctlr_attrs_fcf_dev_loss_tmo,
+			store_private_fcoe_ctlr_fcf_dev_loss_tmo);
+
+/* Link Error Status Block (LESB) */
+fcoe_ctlr_rd_attr(link_fail, "%u\n", 20);
+fcoe_ctlr_rd_attr(vlink_fail, "%u\n", 20);
+fcoe_ctlr_rd_attr(miss_fka, "%u\n", 20);
+fcoe_ctlr_rd_attr(symb_err, "%u\n", 20);
+fcoe_ctlr_rd_attr(err_block, "%u\n", 20);
+fcoe_ctlr_rd_attr(fcs_error, "%u\n", 20);
+
+fcoe_fcf_private_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+fcoe_fcf_private_rd_attr_cast(switch_name, "0x%llx\n", 20, unsigned long long);
+fcoe_fcf_private_rd_attr(priority, "%u\n", 20);
+fcoe_fcf_private_rd_attr(fc_map, "0x%x\n", 20);
+fcoe_fcf_private_rd_attr(vfid, "%u\n", 20);
+fcoe_fcf_private_rd_attr(mac, "%pM\n", 20);
+fcoe_fcf_private_rd_attr(fka_period, "%u\n", 20);
+fcoe_fcf_rd_attr(selected, "%u\n", 20);
+fcoe_fcf_rd_attr(vlan_id, "%u\n", 20);
+
+fcoe_fcf_private_show_function(dev_loss_tmo, "%d\n", 20, )
+static ssize_t
+store_fcoe_fcf_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct fcoe_fcf_attrs *fcf = dev_to_fcf(dev);
+	unsigned long val;
+	int rc;
+
+	rc = fcoe_str_to_dev_loss(buf, &val);
+	if (rc)
+		return rc;
+
+	rc = fcoe_fcf_set_dev_loss_tmo(fcf, val);
+	if (rc)
+		return rc;
+	return count;
+}
+static FCOE_DEVICE_ATTR(fcf, dev_loss_tmo, S_IRUGO | S_IWUSR,
+			show_fcoe_fcf_attrs_dev_loss_tmo,
+			store_fcoe_fcf_dev_loss_tmo);
+
+static struct attribute *fcoe_ctlr_lesb_attributes[] = {
+	&device_attr_fcoe_ctlr_link_fail.attr,
+	&device_attr_fcoe_ctlr_vlink_fail.attr,
+	&device_attr_fcoe_ctlr_miss_fka.attr,
+	&device_attr_fcoe_ctlr_symb_err.attr,
+	&device_attr_fcoe_ctlr_err_block.attr,
+	&device_attr_fcoe_ctlr_fcs_error.attr,
+	NULL
+};
+
+static struct attribute_group fcoe_ctlr_lesb_attribute_group = {
+	.name = "lesb",
+	.attrs = fcoe_ctlr_lesb_attributes,
+};
+
+static struct attribute *fcoe_ctlr_attributes[] = {
+	&device_attr_fcoe_ctlr_fcf_dev_loss_tmo.attr,
+	&device_attr_fcoe_ctlr_mode.attr,
+	NULL
+};
+
+static struct attribute_group fcoe_ctlr_attribute_group = {
+	.attrs = fcoe_ctlr_attributes,
+};
+
+static struct attribute *fcoe_fcf_attributes[] = {
+	&device_attr_fcoe_fcf_fabric_name.attr,
+	&device_attr_fcoe_fcf_switch_name.attr,
+	&device_attr_fcoe_fcf_dev_loss_tmo.attr,
+	&device_attr_fcoe_fcf_fc_map.attr,
+	&device_attr_fcoe_fcf_vfid.attr,
+	&device_attr_fcoe_fcf_mac.attr,
+	&device_attr_fcoe_fcf_priority.attr,
+	&device_attr_fcoe_fcf_fka_period.attr,
+	&device_attr_fcoe_fcf_state.attr,
+	&device_attr_fcoe_fcf_selected.attr,
+	&device_attr_fcoe_fcf_vlan_id.attr,
+	NULL
+};
+
+static struct attribute_group fcoe_fcf_attribute_group = {
+	.attrs = fcoe_fcf_attributes,
+};
+
+/**
+ * fcoe_ctlr_attrs_flush_work() - Flush a FIP ctlr's workqueue
+ * @ctlr: Pointer to the FIP ctlr whose workqueue is to be flushed
+ */
+void fcoe_ctlr_attrs_flush_work(struct fcoe_ctlr_attrs *ctlr)
+{
+	if (!fcoe_ctlr_work_q(ctlr)) {
+		printk(KERN_ERR
+		       "ERROR: FIP Ctlr '%d' attempted to flush work, "
+		       "when no workqueue created.\n", ctlr->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fcoe_ctlr_work_q(ctlr));
+}
+
+/**
+ * fcoe_ctlr_attrs_queue_work() - Schedule work for a FIP ctlr's workqueue
+ * @ctlr: Pointer to the FIP ctlr who owns the devloss workqueue
+ * @work:   Work to queue for execution
+ *
+ * Return value:
+ *	1 on success / 0 already queued / < 0 for error
+ */
+int fcoe_ctlr_attrs_queue_work(struct fcoe_ctlr_attrs *ctlr,
+			       struct work_struct *work)
+{
+	if (unlikely(!fcoe_ctlr_work_q(ctlr))) {
+		printk(KERN_ERR
+		       "ERROR: FIP Ctlr '%d' attempted to queue work, "
+		       "when no workqueue created.\n", ctlr->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_work(fcoe_ctlr_work_q(ctlr), work);
+}
+
+/**
+ * fcoe_ctlr_attrs_flush_devloss() - Flush a FIP ctlr's devloss workqueue
+ * @ctlr: Pointer to FIP ctlr whose workqueue is to be flushed
+ */
+void fcoe_ctlr_attrs_flush_devloss(struct fcoe_ctlr_attrs *ctlr)
+{
+	if (!fcoe_ctlr_devloss_work_q(ctlr)) {
+		printk(KERN_ERR
+		       "ERROR: FIP Ctlr '%d' attempted to flush work, "
+		       "when no workqueue created.\n", ctlr->id);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(fcoe_ctlr_devloss_work_q(ctlr));
+}
+
+/**
+ * fcoe_ctlr_attrs_queue_devloss_work() - Schedule work for a FIP ctlr's devloss workqueue
+ * @ctlr: Pointer to the FIP ctlr who owns the devloss workqueue
+ * @work:   Work to queue for execution
+ * @delay:  jiffies to delay the work queuing
+ *
+ * Return value:
+ *	1 on success / 0 already queued / < 0 for error
+ */
+int fcoe_ctlr_attrs_queue_devloss_work(struct fcoe_ctlr_attrs *ctlr,
+				       struct delayed_work *work,
+				       unsigned long delay)
+{
+	if (unlikely(!fcoe_ctlr_devloss_work_q(ctlr))) {
+		printk(KERN_ERR
+		       "ERROR: FIP Ctlr '%d' attempted to queue work, "
+		       "when no workqueue created.\n", ctlr->id);
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_delayed_work(fcoe_ctlr_devloss_work_q(ctlr), work, delay);
+}
+
+/**
+ * fcoe_ctlr_attrs_release() - Release the FIP ctlr memory
+ * @dev: Pointer to the FIP ctlr's embedded device
+ *
+ * Called when the last FIP ctlr reference is released.
+ */
+static void fcoe_ctlr_attrs_release(struct device *dev)
+{
+	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);
+
+	put_device(ctlr->dev.parent);
+	ctlr->dev.parent = NULL;
+	memset(ctlr, 0, sizeof(struct fcoe_ctlr_attrs));
+	kfree(ctlr);
+}
+
+struct class fcoe_ctlr_class = {
+	.name = "fcoe_ctlr",
+	.dev_release = fcoe_ctlr_attrs_release,
+};
+
+static int fcoe_fcf_attrs_match(struct fcoe_fcf_attrs *new,
+				struct fcoe_fcf_attrs *old)
+{
+	if (new->switch_name == old->switch_name &&
+	    new->fabric_name == old->fabric_name &&
+	    new->fc_map == old->fc_map &&
+	    compare_ether_addr(new->mac, old->mac) == 0)
+		return 1;
+	return 0;
+}
+
+/**
+ * fcoe_ctlr_attrs_add() - Add a FIP ctlr to sysfs
+ * @parent:    The parent device to which the fcoe_ctlr instance
+ *             should be attached
+ * @f:         The LLD's FCoE sysfs function template pointer
+ * @priv_size: Size to be allocated with the fcoe_ctlr_attrs for the LLD
+ *
+ * This routine allocates a FIP ctlr object with some additional memory
+ * for the LLD. The FIP ctlr is initialized, added to sysfs and then
+ * attributes are added to it.
+ */
+struct fcoe_ctlr_attrs *fcoe_ctlr_attrs_add(struct device *parent,
+				    struct fcoe_sysfs_function_template *f,
+				    int priv_size)
+{
+	struct fcoe_ctlr_attrs *ctlr;
+	int error = 0;
+
+	ctlr = kzalloc(sizeof(struct fcoe_ctlr_attrs) + priv_size,
+		       GFP_KERNEL);
+	if (!ctlr)
+		goto out;
+
+	ctlr->id = atomic_inc_return(&ctlr_num) - 1;
+	ctlr->f = f;
+	INIT_LIST_HEAD(&ctlr->fcfs);
+	mutex_init(&ctlr->lock);
+	device_initialize(&ctlr->dev);
+	ctlr->dev.parent = get_device(parent);
+	ctlr->dev.class = &fcoe_ctlr_class;
+
+	ctlr->fcf_dev_loss_tmo = fcoe_fcf_dev_loss_tmo;
+
+
+	snprintf(ctlr->work_q_name, sizeof(ctlr->work_q_name),
+		 "ctlr_wq_%d", ctlr->id);
+	ctlr->work_q = create_singlethread_workqueue(
+		ctlr->work_q_name);
+	if (!ctlr->work_q)
+		goto out_del;
+
+	snprintf(ctlr->devloss_work_q_name,
+		 sizeof(ctlr->devloss_work_q_name),
+		 "ctlr_dl_wq_%d", ctlr->id);
+	ctlr->devloss_work_q = create_singlethread_workqueue(
+		ctlr->devloss_work_q_name);
+	if (!ctlr->devloss_work_q)
+		goto out_del_q;
+
+	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
+	error = device_add(&ctlr->dev);
+	if (error)
+		goto out_del_q2;
+
+	error = sysfs_create_group(&ctlr->dev.kobj,
+				   &fcoe_ctlr_attribute_group);
+	if (error)
+		goto out_del_dev;
+
+	error = sysfs_create_group(&ctlr->dev.kobj,
+				   &fcoe_ctlr_lesb_attribute_group);
+	if (error)
+		goto out_del_dev;
+
+	return ctlr;
+
+out_del_dev:
+	device_del(&ctlr->dev);
+out_del_q2:
+	destroy_workqueue(ctlr->devloss_work_q);
+	ctlr->devloss_work_q = NULL;
+out_del_q:
+	destroy_workqueue(ctlr->work_q);
+	ctlr->work_q = NULL;
+out_del:
+	put_device(parent);
+	kfree(ctlr);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fcoe_ctlr_attrs_add);
+
+/**
+ * fcoe_ctlr_attrs_delete() - Delete a FIP ctlr and its subtree from sysfs
+ * @ctlr: A pointer to the ctlr to be deleted
+ *
+ * Deletes a FIP ctlr and any fcfs attached
+ * to it. Deleting fcfs will cause their childen
+ * to be deleted as well.
+ *
+ * The ctlr is detached from sysfs and it's resources
+ * are freed (work q), but the memory is not freed
+ * until its last reference is released.
+ *
+ * This routine expects no locks to be held before
+ * calling.
+ *
+ * TODO: Currently there are no callbacks to clean up LLD data
+ * for a fcoe_fcf_attrs. LLDs must keep this in mind as they need
+ * to clean up each of their LLD data for all fcoe_fcf_attrs before
+ * calling fcoe_ctlr_attrs_delete.
+ */
+void fcoe_ctlr_attrs_delete(struct fcoe_ctlr_attrs *ctlr)
+{
+	struct fcoe_fcf_attrs *fcf, *next;
+	/* Remove any attached fcfs */
+	mutex_lock(&ctlr->lock);
+	list_for_each_entry_safe(fcf, next,
+				 &ctlr->fcfs, peers) {
+		list_del(&fcf->peers);
+		fcf->state = FCOE_FCF_STATE_DELETED;
+		fcoe_ctlr_attrs_queue_work(ctlr, &fcf->delete_work);
+	}
+	mutex_unlock(&ctlr->lock);
+
+	fcoe_ctlr_attrs_flush_work(ctlr);
+
+	destroy_workqueue(ctlr->devloss_work_q);
+	ctlr->devloss_work_q = NULL;
+	destroy_workqueue(ctlr->work_q);
+	ctlr->work_q = NULL;
+
+	device_del(&ctlr->dev);
+	put_device(&ctlr->dev); /* self-reference */
+}
+EXPORT_SYMBOL(fcoe_ctlr_attrs_delete);
+
+/**
+ * fcoe_fcf_attrs_release() - Release the FIP fcf memory
+ * @dev: Pointer to the fcf's embedded device
+ *
+ * Called when the last FIP fcf reference is released.
+ */
+static void fcoe_fcf_attrs_release(struct device *dev)
+{
+	struct fcoe_fcf_attrs *fcf = dev_to_fcf(dev);
+	put_device(fcf->dev.parent);
+	fcf->dev.parent = NULL;
+	memset(fcf, 0, sizeof(struct fcoe_fcf_attrs));
+	kfree(fcf);
+}
+
+/**
+ * fcoe_fcf_attrs_final_delete() - Final delete routine
+ * @work: The FIP fcf's embedded work struct
+ *
+ * It is expected that the fcf has been removed from
+ * the FIP ctlr's list before calling this routine.
+ */
+static void fcoe_fcf_attrs_final_delete(struct work_struct *work)
+{
+	struct fcoe_fcf_attrs *fcf =
+		container_of(work, struct fcoe_fcf_attrs, delete_work);
+	struct fcoe_ctlr_attrs *ctlr = fcoe_fcf_to_ctlr(fcf);
+
+	/*
+	 * Cancel any outstanding timers. These should really exist
+	 * only when rmmod'ing the LLDD and we're asking for
+	 * immediate termination of the rports
+	 */
+	if (!cancel_delayed_work(&fcf->dev_loss_work))
+		fcoe_ctlr_attrs_flush_devloss(ctlr);
+
+	device_del(&fcf->dev);
+	put_device(&fcf->dev); /* self-reference */
+}
+
+/**
+ * fip_timeout_deleted_fcf() - Delete a fcf when the devloss timer fires
+ * @work: The FIP fcf's embedded work struct
+ *
+ * Removes the fcf from the FIP ctlr's list of fcfs and
+ * queues the final deletion.
+ */
+static void fip_timeout_deleted_fcf(struct work_struct *work)
+{
+	struct fcoe_fcf_attrs *fcf =
+		container_of(work, struct fcoe_fcf_attrs, dev_loss_work.work);
+	struct fcoe_ctlr_attrs *ctlr = fcoe_fcf_to_ctlr(fcf);
+
+	mutex_lock(&ctlr->lock);
+
+	/*
+	 * If the fcf is deleted or reconnected before the timer
+	 * fires the devloss queue will be flushed, but the state will
+	 * either be CONNECTED or DELETED. If that is the case we
+	 * cancel deleting the fcf.
+	 */
+	if (fcf->state != FCOE_FCF_STATE_DISCONNECTED)
+		goto out;
+
+	dev_printk(KERN_ERR, &fcf->dev,
+		   "FIP fcf connection time out: removing fcf\n");
+
+	list_del(&fcf->peers);
+	fcf->state = FCOE_FCF_STATE_DELETED;
+	fcoe_ctlr_attrs_queue_work(ctlr, &fcf->delete_work);
+
+out:
+	mutex_unlock(&ctlr->lock);
+}
+
+/**
+ * fcoe_fcf_attrs_delete() - Delete a FIP fcf
+ * @fcf: Pointer to the fcf which is to be deleted
+ *
+ * Queues the FIP fcf on the devloss workqueue
+ *
+ * Expects the ctlr_attrs mutex to be held for fcf
+ * state change.
+ */
+void fcoe_fcf_attrs_delete(struct fcoe_fcf_attrs *fcf)
+{
+	struct fcoe_ctlr_attrs *ctlr = fcoe_fcf_to_ctlr(fcf);
+	int timeout = fcf->dev_loss_tmo;
+
+	if (fcf->state != FCOE_FCF_STATE_CONNECTED)
+		return;
+
+	fcf->state = FCOE_FCF_STATE_DISCONNECTED;
+
+	/*
+	 * FCF will only be re-connected by the LLD calling
+	 * fcoe_fcf_attrs_add, and it should be setting up
+	 * priv then.
+	 */
+	fcf->priv = NULL;
+
+	fcoe_ctlr_attrs_queue_devloss_work(ctlr, &fcf->dev_loss_work,
+					   timeout * HZ);
+}
+EXPORT_SYMBOL(fcoe_fcf_attrs_delete);
+
+struct class fcoe_fcf_class = {
+	.name = "fcoe_fcf",
+	.dev_release = fcoe_fcf_attrs_release,
+};
+
+
+/**
+ * fcoe_fcf_attrs_add() - Add a FCoE sysfs fcoe_fcf_attrs to the system
+ * @ctlr:    The fcoe_ctlr_attrs that will be the fcoe_fcf_attrs parent
+ * @new_fcf: A temporary FCF used for lookups on the current list of fcfs
+ *
+ * Expects to be called with the ctlr->lock held
+ */
+struct fcoe_fcf_attrs *fcoe_fcf_attrs_add(struct fcoe_ctlr_attrs *ctlr,
+					  struct fcoe_fcf_attrs *new_fcf)
+{
+	struct fcoe_fcf_attrs *fcf;
+	int error = 0;
+
+	list_for_each_entry(fcf, &ctlr->fcfs, peers) {
+		if (fcoe_fcf_attrs_match(new_fcf, fcf)) {
+			if (fcf->state == FCOE_FCF_STATE_CONNECTED)
+				return fcf;
+
+			fcf->state = FCOE_FCF_STATE_CONNECTED;
+
+			if (!cancel_delayed_work(&fcf->dev_loss_work))
+				fcoe_ctlr_attrs_flush_devloss(ctlr);
+
+			return fcf;
+		}
+	}
+
+	fcf = kzalloc(sizeof(struct fcoe_fcf_attrs), GFP_ATOMIC);
+	if (unlikely(!fcf))
+		goto out;
+
+	INIT_WORK(&fcf->delete_work, fcoe_fcf_attrs_final_delete);
+	INIT_DELAYED_WORK(&fcf->dev_loss_work, fip_timeout_deleted_fcf);
+
+	device_initialize(&fcf->dev);
+	fcf->dev.parent = get_device(&ctlr->dev);
+	fcf->dev.class = &fcoe_fcf_class;
+	fcf->id = atomic_inc_return(&fcf_num) - 1;
+	fcf->state = FCOE_FCF_STATE_UNKNOWN;
+
+	fcf->dev_loss_tmo = ctlr->fcf_dev_loss_tmo;
+
+	dev_set_name(&fcf->dev, "fcf_%d", fcf->id);
+
+	fcf->fabric_name = new_fcf->fabric_name;
+	fcf->switch_name = new_fcf->switch_name;
+	fcf->fc_map = new_fcf->fc_map;
+	fcf->vfid = new_fcf->vfid;
+	memcpy(fcf->mac, new_fcf->mac, ETH_ALEN);
+	fcf->priority = new_fcf->priority;
+	fcf->fka_period = new_fcf->fka_period;
+	fcf->selected = new_fcf->selected;
+
+	error = device_add(&fcf->dev);
+	if (error)
+		goto out_del;
+
+	error = sysfs_create_group(&fcf->dev.kobj,
+				   &fcoe_fcf_attribute_group);
+	if (error)
+		goto out_del_dev;
+
+	fcf->state = FCOE_FCF_STATE_CONNECTED;
+	list_add_tail(&fcf->peers, &ctlr->fcfs);
+
+	return fcf;
+
+out_del_dev:
+	device_del(&fcf->dev);
+	list_del(&fcf->peers);
+out_del:
+	put_device(&ctlr->dev);
+	kfree(fcf);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(fcoe_fcf_attrs_add);
+
+int __init fcoe_sysfs_setup(void)
+{
+	int error;
+
+	atomic_set(&ctlr_num, 0);
+	atomic_set(&fcf_num, 0);
+
+	error = class_register(&fcoe_ctlr_class);
+	if (error)
+		return error;
+
+	error = class_register(&fcoe_fcf_class);
+	if (error)
+		goto unreg_ctlr;
+
+	return 0;
+
+unreg_ctlr:
+	class_unregister(&fcoe_ctlr_class);
+	return error;
+}
+
+void __exit fcoe_sysfs_teardown(void)
+{
+	class_unregister(&fcoe_fcf_class);
+	class_unregister(&fcoe_ctlr_class);
+}
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 0897be0..58b6753 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -816,9 +816,17 @@ out_nodev:
  */
 static int __init libfcoe_init(void)
 {
-	fcoe_transport_init();
+	int rc = 0;
 
-	return 0;
+	rc = fcoe_transport_init();
+	if (rc)
+		return rc;
+
+	rc = fcoe_sysfs_setup();
+	if (rc)
+		fcoe_transport_exit();
+
+	return rc;
 }
 module_init(libfcoe_init);
 
@@ -827,6 +835,7 @@ module_init(libfcoe_init);
  */
 static void __exit libfcoe_exit(void)
 {
+	fcoe_sysfs_teardown();
 	fcoe_transport_exit();
 }
 module_exit(libfcoe_exit);
diff --git a/include/scsi/fcoe_sysfs.h b/include/scsi/fcoe_sysfs.h
new file mode 100644
index 0000000..8a2433e
--- /dev/null
+++ b/include/scsi/fcoe_sysfs.h
@@ -0,0 +1,174 @@
+/*
+ * Copyright (c) 2011-2012 Intel Corporation.  All rights reserved.
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
+#ifndef FCOE_SYSFS
+#define FCOE_SYSFS
+
+#include <linux/if_ether.h>
+#include <linux/device.h>
+#include <scsi/fc/fc_fcoe.h>
+
+struct fcoe_ctlr_attrs;
+struct fcoe_fcf_attrs;
+
+struct fcoe_sysfs_function_template {
+	void (*get_fcoe_ctlr_link_fail)(struct fcoe_ctlr_attrs *);
+	void (*get_fcoe_ctlr_vlink_fail)(struct fcoe_ctlr_attrs *);
+	void (*get_fcoe_ctlr_miss_fka)(struct fcoe_ctlr_attrs *);
+	void (*get_fcoe_ctlr_symb_err)(struct fcoe_ctlr_attrs *);
+	void (*get_fcoe_ctlr_err_block)(struct fcoe_ctlr_attrs *);
+	void (*get_fcoe_ctlr_fcs_error)(struct fcoe_ctlr_attrs *);
+	void (*get_fcoe_ctlr_mode)(struct fcoe_ctlr_attrs *);
+	void (*get_fcoe_fcf_selected)(struct fcoe_fcf_attrs *);
+	void (*get_fcoe_fcf_vlan_id)(struct fcoe_fcf_attrs *);
+};
+
+enum fip_conn_type {
+	FIP_CONN_TYPE_UNKNOWN,
+	FIP_CONN_TYPE_FABRIC,
+	FIP_CONN_TYPE_VN2VN,
+};
+
+struct fcoe_ctlr_attrs {
+	u32				id;
+
+	struct device			dev;
+	struct fcoe_sysfs_function_template *f;
+
+	struct list_head		fcfs;
+	char				work_q_name[20];
+	struct workqueue_struct		*work_q;
+	char				devloss_work_q_name[20];
+	struct workqueue_struct		*devloss_work_q;
+	struct mutex			lock;
+
+	int                             fcf_dev_loss_tmo;
+	enum fip_conn_type              mode;
+
+	/* expected in host order for displaying */
+	struct fcoe_fc_els_lesb         lesb;
+};
+
+#define dev_to_ctlr(d)					\
+	container_of((d), struct fcoe_ctlr_attrs, dev)
+#define fcoe_ctlr_id(x)				\
+	((x)->id)
+#define fcoe_ctlr_work_q_name(x)		\
+	((x)->work_q_name)
+#define fcoe_ctlr_work_q(x)			\
+	((x)->work_q)
+#define fcoe_ctlr_devloss_work_q_name(x)	\
+	((x)->devloss_work_q_name)
+#define fcoe_ctlr_devloss_work_q(x)		\
+	((x)->devloss_work_q)
+#define fcoe_ctlr_mode(x)			\
+	((x)->mode)
+#define fcoe_ctlr_fcf_dev_loss_tmo(x)		\
+	((x)->fcf_dev_loss_tmo)
+#define fcoe_ctlr_link_fail(x)			\
+	((x)->lesb.lesb_link_fail)
+#define fcoe_ctlr_vlink_fail(x)			\
+	((x)->lesb.lesb_vlink_fail)
+#define fcoe_ctlr_miss_fka(x)			\
+	((x)->lesb.lesb_miss_fka)
+#define fcoe_ctlr_symb_err(x)			\
+	((x)->lesb.lesb_symb_err)
+#define fcoe_ctlr_err_block(x)			\
+	((x)->lesb.lesb_err_block)
+#define fcoe_ctlr_fcs_error(x)			\
+	((x)->lesb.lesb_fcs_error)
+
+static inline void *fcoe_ctlr_attrs_priv(const struct fcoe_ctlr_attrs *ctlr)
+{
+	return (void *)(ctlr + 1);
+}
+
+/* fcf states */
+enum fcf_state {
+	FCOE_FCF_STATE_UNKNOWN,
+	FCOE_FCF_STATE_DISCONNECTED,
+	FCOE_FCF_STATE_CONNECTED,
+	FCOE_FCF_STATE_DELETED,
+};
+
+struct fcoe_fcf_attrs {
+	u32		    id;
+	struct device	    dev;
+	struct list_head    peers;
+	struct work_struct  delete_work;
+	struct delayed_work dev_loss_work;
+	u32		    dev_loss_tmo;
+	void                *priv;
+	enum fcf_state      state;
+
+	u64                 fabric_name;
+	u64                 switch_name;
+	u32                 fc_map;
+	u16                 vfid;
+	u8                  mac[ETH_ALEN];
+	u8                  priority;
+	u32                 fka_period;
+	u8                  selected;
+	u16                 vlan_id;
+};
+
+#define dev_to_fcf(d)					\
+	container_of((d), struct fcoe_fcf_attrs, dev)
+
+#define fcoe_fcf_attrs_priv(x)			\
+	((x)->priv)
+
+/* parentage should never be missing */
+#define fcoe_fcf_to_ctlr(x)			\
+	dev_to_ctlr((x)->dev.parent)
+#define fcoe_fcf_state(x)			\
+	((x)->state)
+#define fcoe_fcf_fabric_name(x)			\
+	((x)->fabric_name)
+#define fcoe_fcf_switch_name(x)			\
+	((x)->switch_name)
+#define fcoe_fcf_fc_map(x)			\
+	((x)->fc_map)
+#define fcoe_fcf_vfid(x)			\
+	((x)->vfid)
+#define fcoe_fcf_mac(x)				\
+	((x)->mac)
+#define fcoe_fcf_priority(x)			\
+	((x)->priority)
+#define fcoe_fcf_fka_period(x)			\
+	((x)->fka_period)
+#define fcoe_fcf_dev_loss_tmo(x)		\
+	((x)->dev_loss_tmo)
+#define fcoe_fcf_selected(x)			\
+	((x)->selected)
+#define fcoe_fcf_vlan_id(x)			\
+	((x)->vlan_id)
+
+struct fcoe_ctlr_attrs *fcoe_ctlr_attrs_add(struct device *parent,
+			    struct fcoe_sysfs_function_template *f,
+			    int priv_size);
+void fcoe_ctlr_attrs_delete(struct fcoe_ctlr_attrs *);
+struct fcoe_fcf_attrs *fcoe_fcf_attrs_add(struct fcoe_ctlr_attrs *,
+					  struct fcoe_fcf_attrs *);
+void fcoe_fcf_attrs_delete(struct fcoe_fcf_attrs *);
+
+int __init fcoe_sysfs_setup(void);
+void __exit fcoe_sysfs_teardown(void);
+
+#endif /* FCOE_SYSFS */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 69eca4b..7b93f21 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -29,6 +29,7 @@
 #include <linux/random.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
+#include <scsi/fcoe_sysfs.h>
 
 #define FCOE_MAX_CMD_LEN	16	/* Supported CDB length */
 

