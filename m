From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: add initial device backend context target_core_stat.c code
Date: Mon, 31 Jan 2011 02:29:53 -0800
Message-ID: <1296469795-27632-2-git-send-email-nab@linux-iscsi.org>
References: <1296469795-27632-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1296469795-27632-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a target_core_mib.c statistics conversion for
backend context struct se_subsystem_dev + struct se_device config_group
based statistics in target_core_device.c using CONFIGFS_EATTR()
based struct config_item_types from target_core_stat.c code.

The conversion from backend /proc/scsi_target/mib/ context output to configfs
default groups+attributes include scsi_dev, scsi_lu, and scsi_tgt_dev output
from within individual:

	/sys/kernel/config/target/core/$HBA/DEV/

The legacy procfs output now appear as individual configfs attributes under:

*) $HBA/$DEV/statistics/scsi_dev:

|-- indx
|-- inst
|-- ports
`-- role

*) $HBA/$DEV/statistics/scsi_lu:

|-- creation_time
|-- dev
|-- dev_type
|-- full_stat
|-- hs_num_cmds
|-- indx
|-- inst
|-- lu_name
|-- lun
|-- num_cmds
|-- prod
|-- read_mbytes
|-- resets
|-- rev
|-- state_bit
|-- status
|-- vend
`-- write_mbytes

*) $HBA/$DEV/statistics/scsi_tgt_dev:

|-- indx
|-- inst
|-- non_access_lus
|-- num_lus
|-- resets
`-- status

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Makefile               |    3 +-
 drivers/target/target_core_configfs.c |   76 ++++-
 drivers/target/target_core_stat.c     |  685 +++++++++++++++++++++++++++++++++
 drivers/target/target_core_stat.h     |   15 +
 include/target/target_core_base.h     |   10 +
 5 files changed, 778 insertions(+), 11 deletions(-)
 create mode 100644 drivers/target/target_core_stat.c
 create mode 100644 drivers/target/target_core_stat.h

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index be702ad..e1ad29a 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -13,7 +13,8 @@ target_core_mod-y		:= target_core_configfs.o \
 				   target_core_cdb.o \
 				   target_core_ua.o \
 				   target_core_rd.o \
-				   target_core_mib.o
+				   target_core_stat.o \
+				   target_core_mib.o \
 
 obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 30ae3af..9ff1942 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3,8 +3,8 @@
  *
  * This file contains ConfigFS logic for the Generic Target Engine project.
  *
- * Copyright (c) 2008-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * Copyright (c) 2008-2011 Rising Tide Systems
+ * Copyright (c) 2008-2011 Linux-iSCSI.org
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
@@ -52,6 +52,7 @@
 #include "target_core_pr.h"
 #include "target_core_rd.h"
 #include "target_core_mib.h"
+#include "target_core_stat.h"
 
 static struct list_head g_tf_list;
 static struct mutex g_tf_lock;
@@ -2663,6 +2664,34 @@ static struct config_item_type target_core_alua_cit = {
 
 /* End functions for struct config_item_type target_core_alua_cit */
 
+/* Start functions for struct config_item_type target_core_stat_cit */
+
+static struct config_group *target_core_stat_mkdir(
+	struct config_group *group,
+	const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static void target_core_stat_rmdir(
+	struct config_group *group,
+	struct config_item *item)
+{
+	return;
+}
+
+static struct configfs_group_operations target_core_stat_group_ops = {
+	.make_group		= &target_core_stat_mkdir,
+	.drop_item		= &target_core_stat_rmdir,
+};
+
+static struct config_item_type target_core_stat_cit = {
+	.ct_group_ops		= &target_core_stat_group_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+/* End functions for struct config_item_type target_core_stat_cit */
+
 /* Start functions for struct config_item_type target_core_hba_cit */
 
 static struct config_group *target_core_make_subdev(
@@ -2675,10 +2704,12 @@ static struct config_group *target_core_make_subdev(
 	struct config_item *hba_ci = &group->cg_item;
 	struct se_hba *hba = item_to_hba(hba_ci);
 	struct config_group *dev_cg = NULL, *tg_pt_gp_cg = NULL;
+	struct config_group *dev_stat_grp = NULL;
+	int errno = -ENOMEM, ret;
 
-	if (mutex_lock_interruptible(&hba->hba_access_mutex))
-		return NULL;
-
+	ret = mutex_lock_interruptible(&hba->hba_access_mutex);
+	if (ret)
+		return ERR_PTR(ret);
 	/*
 	 * Locate the struct se_subsystem_api from parent's struct se_hba.
 	 */
@@ -2708,7 +2739,7 @@ static struct config_group *target_core_make_subdev(
 	se_dev->se_dev_hba = hba;
 	dev_cg = &se_dev->se_dev_group;
 
-	dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 6,
+	dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 7,
 			GFP_KERNEL);
 	if (!(dev_cg->default_groups))
 		goto out;
@@ -2740,13 +2771,17 @@ static struct config_group *target_core_make_subdev(
 			&target_core_dev_wwn_cit);
 	config_group_init_type_name(&se_dev->t10_alua.alua_tg_pt_gps_group,
 			"alua", &target_core_alua_tg_pt_gps_cit);
+	config_group_init_type_name(&se_dev->dev_stat_grps.stat_group,
+			"statistics", &target_core_stat_cit);
+			
 	dev_cg->default_groups[0] = &se_dev->se_dev_attrib.da_group;
 	dev_cg->default_groups[1] = &se_dev->se_dev_pr_group;
 	dev_cg->default_groups[2] = &se_dev->t10_wwn.t10_wwn_group;
 	dev_cg->default_groups[3] = &se_dev->t10_alua.alua_tg_pt_gps_group;
-	dev_cg->default_groups[4] = NULL;
+	dev_cg->default_groups[4] = &se_dev->dev_stat_grps.stat_group;
+	dev_cg->default_groups[5] = NULL;
 	/*
-	 * Add core/$HBA/$DEV/alua/tg_pt_gps/default_tg_pt_gp
+	 * Add core/$HBA/$DEV/alua/default_tg_pt_gp
 	 */
 	tg_pt_gp = core_alua_allocate_tg_pt_gp(se_dev, "default_tg_pt_gp", 1);
 	if (!(tg_pt_gp))
@@ -2766,6 +2801,17 @@ static struct config_group *target_core_make_subdev(
 	tg_pt_gp_cg->default_groups[0] = &tg_pt_gp->tg_pt_gp_group;
 	tg_pt_gp_cg->default_groups[1] = NULL;
 	T10_ALUA(se_dev)->default_tg_pt_gp = tg_pt_gp;
+	/*
+	 * Add core/$HBA/$DEV/statistics/ default groups
+	 */
+	dev_stat_grp = &DEV_STAT_GRP(se_dev)->stat_group;
+	dev_stat_grp->default_groups = kzalloc(sizeof(struct config_group) * 4,
+				GFP_KERNEL);
+	if (!dev_stat_grp->default_groups) {
+		printk(KERN_ERR "Unable to allocate dev_stat_grp->default_groups\n");
+		goto out;
+	}
+	target_stat_setup_dev_default_groups(se_dev);
 
 	printk(KERN_INFO "Target_Core_ConfigFS: Allocated struct se_subsystem_dev:"
 		" %p se_dev_su_ptr: %p\n", se_dev, se_dev->se_dev_su_ptr);
@@ -2777,6 +2823,8 @@ out:
 		core_alua_free_tg_pt_gp(T10_ALUA(se_dev)->default_tg_pt_gp);
 		T10_ALUA(se_dev)->default_tg_pt_gp = NULL;
 	}
+	if (dev_stat_grp)
+		kfree(dev_stat_grp->default_groups);
 	if (tg_pt_gp_cg)
 		kfree(tg_pt_gp_cg->default_groups);
 	if (dev_cg)
@@ -2786,7 +2834,7 @@ out:
 	kfree(se_dev);
 unlock:
 	mutex_unlock(&hba->hba_access_mutex);
-	return NULL;
+	return ERR_PTR(errno);
 }
 
 static void target_core_drop_subdev(
@@ -2798,7 +2846,7 @@ static void target_core_drop_subdev(
 	struct se_hba *hba;
 	struct se_subsystem_api *t;
 	struct config_item *df_item;
-	struct config_group *dev_cg, *tg_pt_gp_cg;
+	struct config_group *dev_cg, *tg_pt_gp_cg, *dev_stat_grp;
 	int i, ret;
 
 	hba = item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);
@@ -2812,6 +2860,14 @@ static void target_core_drop_subdev(
 	list_del(&se_dev->g_se_dev_list);
 	spin_unlock(&se_global->g_device_lock);
 
+	dev_stat_grp = &DEV_STAT_GRP(se_dev)->stat_group;
+	for (i = 0; dev_stat_grp->default_groups[i]; i++) {
+		df_item = &dev_stat_grp->default_groups[i]->cg_item;
+		dev_stat_grp->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+	kfree(dev_stat_grp->default_groups);
+
 	tg_pt_gp_cg = &T10_ALUA(se_dev)->alua_tg_pt_gps_group;
 	for (i = 0; tg_pt_gp_cg->default_groups[i]; i++) {
 		df_item = &tg_pt_gp_cg->default_groups[i]->cg_item;
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
new file mode 100644
index 0000000..9b2ea89
--- /dev/null
+++ b/drivers/target/target_core_stat.c
@@ -0,0 +1,685 @@
+/*******************************************************************************
+ * Filename:  target_core_stat.c
+ *
+ * Copyright (c) 2011 Rising Tide Systems
+ * Copyright (c) 2011 Linux-iSCSI.org
+ *
+ * Modern ConfigFS group context specific statistics based on original
+ * target_core_mib.c code
+ *
+ * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
+ *
+ * Nicholas A. Bellinger <nab@linux-iscsi.org>
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
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ ******************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/string.h>
+#include <linux/version.h>
+#include <generated/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/blkdev.h>
+#include <linux/configfs.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_configfs.h>
+#include <target/configfs_macros.h>
+
+#include "target_core_hba.h"
+#include "target_core_mib.h"
+
+#ifndef INITIAL_JIFFIES
+#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
+#endif
+
+#define NONE		"None"
+#define ISPRINT(a)   ((a >= ' ') && (a <= '~'))
+
+#define SCSI_LU_INDEX			1
+#define LU_COUNT			1
+
+/*
+ * SCSI Device Table
+ */
+
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_dev, se_dev_stat_grps);
+#define DEV_STAT_SCSI_DEV_ATTR(_name, _mode)				\
+static struct target_stat_scsi_dev_attribute				\
+			target_stat_scsi_dev_##_name =			\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_dev_show_attr_##_name,				\
+	target_stat_scsi_dev_store_attr_##_name);
+
+#define DEV_STAT_SCSI_DEV_ATTR_RO(_name)				\
+static struct target_stat_scsi_dev_attribute				\
+			target_stat_scsi_dev_##_name =			\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_dev_show_attr_##_name);
+
+static ssize_t target_stat_scsi_dev_show_attr_inst(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_hba *hba = se_subdev->se_dev_hba;
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+}
+DEV_STAT_SCSI_DEV_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_dev_show_attr_indx(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
+}
+DEV_STAT_SCSI_DEV_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_dev_show_attr_role(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "Target\n");
+}
+DEV_STAT_SCSI_DEV_ATTR_RO(role);
+
+static ssize_t target_stat_scsi_dev_show_attr_ports(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->dev_port_count);
+}
+DEV_STAT_SCSI_DEV_ATTR_RO(ports);
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_dev, se_dev_stat_grps, scsi_dev_group);
+
+static struct configfs_attribute *target_stat_scsi_dev_attrs[] = {
+	&target_stat_scsi_dev_inst.attr,
+	&target_stat_scsi_dev_indx.attr,
+	&target_stat_scsi_dev_role.attr,
+	&target_stat_scsi_dev_ports.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_dev_attrib_ops = {
+	.show_attribute		= target_stat_scsi_dev_attr_show,
+	.store_attribute	= target_stat_scsi_dev_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_dev_cit = {
+	.ct_item_ops		= &target_stat_scsi_dev_attrib_ops,
+	.ct_attrs		= target_stat_scsi_dev_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * SCSI Target Device Table
+ */
+
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_tgt_dev, se_dev_stat_grps);
+#define DEV_STAT_SCSI_TGT_DEV_ATTR(_name, _mode)			\
+static struct target_stat_scsi_tgt_dev_attribute			\
+			target_stat_scsi_tgt_dev_##_name =		\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_tgt_dev_show_attr_##_name,			\
+	target_stat_scsi_tgt_dev_store_attr_##_name);
+
+#define DEV_STAT_SCSI_TGT_DEV_ATTR_RO(_name)				\
+static struct target_stat_scsi_tgt_dev_attribute			\
+			target_stat_scsi_tgt_dev_##_name =		\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_tgt_dev_show_attr_##_name);
+
+static ssize_t target_stat_scsi_tgt_dev_show_attr_inst(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_hba *hba = se_subdev->se_dev_hba;
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+}
+DEV_STAT_SCSI_TGT_DEV_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_tgt_dev_show_attr_indx(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
+}
+DEV_STAT_SCSI_TGT_DEV_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_tgt_dev_show_attr_num_lus(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", LU_COUNT);
+}
+DEV_STAT_SCSI_TGT_DEV_ATTR_RO(num_lus);
+
+static ssize_t target_stat_scsi_tgt_dev_show_attr_status(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+	char status[16];
+
+	if (!dev)
+		return -ENODEV;
+
+	switch (dev->dev_status) {
+	case TRANSPORT_DEVICE_ACTIVATED:
+		strcpy(status, "activated");
+		break;
+	case TRANSPORT_DEVICE_DEACTIVATED:
+		strcpy(status, "deactivated");
+		break;
+	case TRANSPORT_DEVICE_SHUTDOWN:
+		strcpy(status, "shutdown");
+		break;
+	case TRANSPORT_DEVICE_OFFLINE_ACTIVATED:
+	case TRANSPORT_DEVICE_OFFLINE_DEACTIVATED:
+		strcpy(status, "offline");
+		break;
+	default:
+		sprintf(status, "unknown(%d)", dev->dev_status);
+		break;
+	}
+
+	return snprintf(page, PAGE_SIZE, "%s\n", status);
+}
+DEV_STAT_SCSI_TGT_DEV_ATTR_RO(status);
+
+static ssize_t target_stat_scsi_tgt_dev_show_attr_non_access_lus(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+	int non_accessible_lus;
+
+	if (!dev)
+		return -ENODEV;
+
+	switch (dev->dev_status) {
+	case TRANSPORT_DEVICE_ACTIVATED:
+		non_accessible_lus = 0;
+		break;
+	case TRANSPORT_DEVICE_DEACTIVATED:
+	case TRANSPORT_DEVICE_SHUTDOWN:
+	case TRANSPORT_DEVICE_OFFLINE_ACTIVATED:
+	case TRANSPORT_DEVICE_OFFLINE_DEACTIVATED:
+	default:
+		non_accessible_lus = 1;
+		break;
+	}
+
+	return snprintf(page, PAGE_SIZE, "%u\n", non_accessible_lus);
+}
+DEV_STAT_SCSI_TGT_DEV_ATTR_RO(non_access_lus);
+
+static ssize_t target_stat_scsi_tgt_dev_show_attr_resets(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+	
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->num_resets);
+}
+DEV_STAT_SCSI_TGT_DEV_ATTR_RO(resets);
+	
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_tgt_dev, se_dev_stat_grps, scsi_tgt_dev_group);
+
+static struct configfs_attribute *target_stat_scsi_tgt_dev_attrs[] = {
+	&target_stat_scsi_tgt_dev_inst.attr,
+	&target_stat_scsi_tgt_dev_indx.attr,
+	&target_stat_scsi_tgt_dev_num_lus.attr,
+	&target_stat_scsi_tgt_dev_status.attr,
+	&target_stat_scsi_tgt_dev_non_access_lus.attr,
+	&target_stat_scsi_tgt_dev_resets.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_tgt_dev_attrib_ops = {
+	.show_attribute		= target_stat_scsi_tgt_dev_attr_show,
+	.store_attribute	= target_stat_scsi_tgt_dev_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_tgt_dev_cit = {
+	.ct_item_ops		= &target_stat_scsi_tgt_dev_attrib_ops,
+	.ct_attrs		= target_stat_scsi_tgt_dev_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * SCSI Logical Unit Table
+ */
+
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_lu, se_dev_stat_grps);
+#define DEV_STAT_SCSI_LU_ATTR(_name, _mode)				\
+static struct target_stat_scsi_lu_attribute target_stat_scsi_lu_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_lu_show_attr_##_name,				\
+	target_stat_scsi_lu_store_attr_##_name);
+
+#define DEV_STAT_SCSI_LU_ATTR_RO(_name)					\
+static struct target_stat_scsi_lu_attribute target_stat_scsi_lu_##_name = \
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_lu_show_attr_##_name);
+
+static ssize_t target_stat_scsi_lu_show_attr_inst(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_hba *hba = se_subdev->se_dev_hba;
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_lu_show_attr_dev(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(dev);
+
+static ssize_t target_stat_scsi_lu_show_attr_indx(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%u\n", SCSI_LU_INDEX);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_lu_show_attr_lun(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+	/* FIXME: scsiLuDefaultLun */
+	return snprintf(page, PAGE_SIZE, "%llu\n", (unsigned long long)0);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(lun);
+
+static ssize_t target_stat_scsi_lu_show_attr_lu_name(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+	/* scsiLuWwnName */
+	return snprintf(page, PAGE_SIZE, "%s\n",
+			(strlen(DEV_T10_WWN(dev)->unit_serial)) ?
+			(char *)&DEV_T10_WWN(dev)->unit_serial[0] : "None");
+}
+DEV_STAT_SCSI_LU_ATTR_RO(lu_name);
+
+static ssize_t target_stat_scsi_lu_show_attr_vend(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+	int j;
+	char str[28];
+
+	if (!dev)
+		return -ENODEV;
+	/* scsiLuVendorId */
+	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
+	for (j = 0; j < 8; j++)
+		str[j] = ISPRINT(DEV_T10_WWN(dev)->vendor[j]) ?
+				DEV_T10_WWN(dev)->vendor[j] : 0x20;
+	str[8] = 0;
+	return snprintf(page, PAGE_SIZE, "%s\n", str);
+}	
+DEV_STAT_SCSI_LU_ATTR_RO(vend);
+
+static ssize_t target_stat_scsi_lu_show_attr_prod(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+	int j;
+	char str[28];
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuProductId */
+	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
+	for (j = 0; j < 16; j++)
+		str[j] = ISPRINT(DEV_T10_WWN(dev)->model[j]) ?
+				DEV_T10_WWN(dev)->model[j] : 0x20;
+	str[16] = 0;
+	return snprintf(page, PAGE_SIZE, "%s\n", str);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(prod);
+
+static ssize_t target_stat_scsi_lu_show_attr_rev(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+	int j;
+	char str[28];
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuRevisionId */
+	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
+	for (j = 0; j < 4; j++)
+		str[j] = ISPRINT(DEV_T10_WWN(dev)->revision[j]) ?
+				DEV_T10_WWN(dev)->revision[j] : 0x20;
+	str[4] = 0;
+	return snprintf(page, PAGE_SIZE, "%s\n", str);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(rev);
+
+static ssize_t target_stat_scsi_lu_show_attr_dev_type(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuPeripheralType */
+	return snprintf(page, PAGE_SIZE, "%u\n",
+			TRANSPORT(dev)->get_device_type(dev));
+}
+DEV_STAT_SCSI_LU_ATTR_RO(dev_type);
+
+static ssize_t target_stat_scsi_lu_show_attr_status(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuStatus */
+	return snprintf(page, PAGE_SIZE, "%s\n",
+		(dev->dev_status == TRANSPORT_DEVICE_ACTIVATED) ?
+		"available" : "notavailable");
+}
+DEV_STAT_SCSI_LU_ATTR_RO(status);
+
+static ssize_t target_stat_scsi_lu_show_attr_state_bit(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuState */
+	return snprintf(page, PAGE_SIZE, "exposed\n");
+}
+DEV_STAT_SCSI_LU_ATTR_RO(state_bit);
+
+static ssize_t target_stat_scsi_lu_show_attr_num_cmds(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuNumCommands */
+	return snprintf(page, PAGE_SIZE, "%llu\n",
+			(unsigned long long)dev->num_cmds);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(num_cmds);
+
+static ssize_t target_stat_scsi_lu_show_attr_read_mbytes(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuReadMegaBytes */
+	return snprintf(page, PAGE_SIZE, "%u\n", (u32)(dev->read_bytes >> 20));
+}
+DEV_STAT_SCSI_LU_ATTR_RO(read_mbytes);
+
+static ssize_t target_stat_scsi_lu_show_attr_write_mbytes(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuWrittenMegaBytes */
+	return snprintf(page, PAGE_SIZE, "%u\n", (u32)(dev->write_bytes >> 20));
+}
+DEV_STAT_SCSI_LU_ATTR_RO(write_mbytes);
+
+static ssize_t target_stat_scsi_lu_show_attr_resets(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuInResets */
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->num_resets);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(resets);
+
+static ssize_t target_stat_scsi_lu_show_attr_full_stat(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* FIXME: scsiLuOutTaskSetFullStatus */
+	return snprintf(page, PAGE_SIZE, "%u\n", 0);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(full_stat);
+
+static ssize_t target_stat_scsi_lu_show_attr_hs_num_cmds(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* FIXME: scsiLuHSInCommands */
+	return snprintf(page, PAGE_SIZE, "%u\n", 0);
+}
+DEV_STAT_SCSI_LU_ATTR_RO(hs_num_cmds);
+
+static ssize_t target_stat_scsi_lu_show_attr_creation_time(
+	struct se_dev_stat_grps *sgrps, char *page)
+{
+	struct se_subsystem_dev *se_subdev = container_of(sgrps,
+			struct se_subsystem_dev, dev_stat_grps);
+	struct se_device *dev = se_subdev->se_dev_ptr;
+
+	if (!dev)
+		return -ENODEV;
+
+	/* scsiLuCreationTime */
+	return snprintf(page, PAGE_SIZE, "%u\n", (u32)(((u32)dev->creation_time -
+				INITIAL_JIFFIES) * 100 / HZ));
+}
+DEV_STAT_SCSI_LU_ATTR_RO(creation_time);
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_lu, se_dev_stat_grps, scsi_lu_group);
+
+static struct configfs_attribute *target_stat_scsi_lu_attrs[] = {
+	&target_stat_scsi_lu_inst.attr,
+	&target_stat_scsi_lu_dev.attr,
+	&target_stat_scsi_lu_indx.attr,
+	&target_stat_scsi_lu_lun.attr,
+	&target_stat_scsi_lu_lu_name.attr,
+	&target_stat_scsi_lu_vend.attr,
+	&target_stat_scsi_lu_prod.attr,
+	&target_stat_scsi_lu_rev.attr,
+	&target_stat_scsi_lu_dev_type.attr,
+	&target_stat_scsi_lu_status.attr,
+	&target_stat_scsi_lu_state_bit.attr,
+	&target_stat_scsi_lu_num_cmds.attr,
+	&target_stat_scsi_lu_read_mbytes.attr,
+	&target_stat_scsi_lu_write_mbytes.attr,
+	&target_stat_scsi_lu_resets.attr,
+	&target_stat_scsi_lu_full_stat.attr,
+	&target_stat_scsi_lu_hs_num_cmds.attr,
+	&target_stat_scsi_lu_creation_time.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_lu_attrib_ops = {
+	.show_attribute		= target_stat_scsi_lu_attr_show,
+	.store_attribute	= target_stat_scsi_lu_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_lu_cit = {
+	.ct_item_ops		= &target_stat_scsi_lu_attrib_ops,
+	.ct_attrs		= target_stat_scsi_lu_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * Called from target_core_configfs.c:target_core_make_subdev() to setup
+ * the target statistics groups + configfs CITs located in target_core_stat.c
+ */
+void target_stat_setup_dev_default_groups(struct se_subsystem_dev *se_subdev)
+{
+	struct config_group *dev_stat_grp = &DEV_STAT_GRP(se_subdev)->stat_group;
+
+	config_group_init_type_name(&DEV_STAT_GRP(se_subdev)->scsi_dev_group,
+			"scsi_dev", &target_stat_scsi_dev_cit);
+	config_group_init_type_name(&DEV_STAT_GRP(se_subdev)->scsi_tgt_dev_group,
+			"scsi_tgt_dev", &target_stat_scsi_tgt_dev_cit);
+	config_group_init_type_name(&DEV_STAT_GRP(se_subdev)->scsi_lu_group,
+			"scsi_lu", &target_stat_scsi_lu_cit);
+
+	dev_stat_grp->default_groups[0] = &DEV_STAT_GRP(se_subdev)->scsi_dev_group;
+	dev_stat_grp->default_groups[1] = &DEV_STAT_GRP(se_subdev)->scsi_tgt_dev_group;
+	dev_stat_grp->default_groups[2] = &DEV_STAT_GRP(se_subdev)->scsi_lu_group;
+	dev_stat_grp->default_groups[3] = NULL;
+}
diff --git a/drivers/target/target_core_stat.h b/drivers/target/target_core_stat.h
new file mode 100644
index 0000000..6bc6a87
--- /dev/null
+++ b/drivers/target/target_core_stat.h
@@ -0,0 +1,15 @@
+#ifndef TARGET_CORE_STAT_H
+#define TARGET_CORE_STAT_H
+
+# if 0
+typedef enum {
+	SCSI_INST_INDEX,
+	SCSI_DEVICE_INDEX,
+	SCSI_AUTH_INTR_INDEX,
+	SCSI_INDEX_TYPE_MAX
+} scsi_index_t;
+#endif
+
+extern void target_stat_setup_dev_default_groups(struct se_subsystem_dev *);
+
+#endif   /*** TARGET_CORE_STAT_H ***/
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 574bafd..2d20b3f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -689,6 +689,13 @@ struct se_dev_attrib {
 	struct config_group da_group;
 } ____cacheline_aligned;
 
+struct se_dev_stat_grps {
+	struct config_group stat_group;
+	struct config_group scsi_dev_group;
+	struct config_group scsi_tgt_dev_group;
+	struct config_group scsi_lu_group;
+};
+
 struct se_subsystem_dev {
 /* Used for struct se_subsystem_dev-->se_dev_alias, must be less than PAGE_SIZE */
 #define SE_DEV_ALIAS_LEN		512
@@ -712,11 +719,14 @@ struct se_subsystem_dev {
 	struct config_group se_dev_group;
 	/* For T10 Reservations */
 	struct config_group se_dev_pr_group;
+	/* For target_core_stat.c groups */
+	struct se_dev_stat_grps dev_stat_grps;
 } ____cacheline_aligned;
 
 #define T10_ALUA(su_dev)	(&(su_dev)->t10_alua)
 #define T10_RES(su_dev)		(&(su_dev)->t10_reservation)
 #define T10_PR_OPS(su_dev)	(&(su_dev)->t10_reservation.pr_ops)
+#define DEV_STAT_GRP(dev)	(&(dev)->dev_stat_grps)
 
 struct se_device {
 	/* Set to 1 if thread is NOT sleeping on thread_sem */
-- 
1.5.6.5
