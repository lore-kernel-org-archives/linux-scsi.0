From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: add initial fabric port context target_core_stat.c code
Date: Mon, 31 Jan 2011 02:29:54 -0800
Message-ID: <1296469795-27632-3-git-send-email-nab@linux-iscsi.org>
References: <1296469795-27632-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1296469795-27632-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a target_core_mib.c statistics conversion for
TCM fabric port/LUN context struct se_lun + struct se_port config_group
based statistics in target_core_fabric_configfs.c using CONFIGFS_EATTR()
based struct config_item_types from existing generic target fabric
TF_CIT_SETUP() wrapper code in target_core_fabric_configfs.c.

The conversion from backend /proc/scsi_target/mib/ context output to configfs
default groups+attributes include scsi_port, scsi_tgt_port and scsi_transport
output from within individual:

	/sys/kernel/config/target/fabric/$WWN/tpgt_$TPGT/lun/lun_$LUN_ID/statistics/

The legacy procfs output now appear as individual configfs attributes under:

*) fabric/$WWN/tpgt_$TPGT/lun/lun_$LUN_ID/statistics/scsi_port

|-- busy_count
|-- dev
|-- indx
|-- inst
`-- role

*) fabric/$WWN/tpgt_$TPGT/lun/lun_$LUN_ID/statistics/scsi_tgt_port

|-- dev
|-- hs_in_cmds
|-- in_cmds
|-- indx
|-- inst
|-- name
|-- port_index
|-- read_mbytes
`-- write_mbytes

*) fabric/$WWN/tpgt_$TPGT/lun/lun_$LUN_ID/statistics/scsi_transport

|-- dev_name
|-- device
|-- indx
`-- inst

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   83 ++++-
 drivers/target/target_core_stat.c            |  544 ++++++++++++++++++++++++++
 drivers/target/target_core_stat.h            |    1 +
 include/target/target_core_base.h            |   11 +-
 include/target/target_core_configfs.h        |    1 +
 5 files changed, 636 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 32b148d..1357592 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -4,10 +4,10 @@
  * This file contains generic fabric module configfs infrastructure for
  * TCM v4.x code
  *
- * Copyright (c) 2010 Rising Tide Systems
- * Copyright (c) 2010 Linux-iSCSI.org
+ * Copyright (c) 2010,2011 Rising Tide Systems
+ * Copyright (c) 2010,2011 Linux-iSCSI.org
  *
- * Copyright (c) 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ * Copyright (c) Nicholas A. Bellinger <nab@linux-iscsi.org>
 *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -48,6 +48,7 @@
 #include "target_core_alua.h"
 #include "target_core_hba.h"
 #include "target_core_pr.h"
+#include "target_core_stat.h"
 
 #define TF_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
 static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
@@ -736,6 +737,31 @@ TF_CIT_SETUP(tpg_port, &target_fabric_port_item_ops, NULL, target_fabric_port_at
 
 /* End of tfc_tpg_port_cit */
 
+/* Start of tfc_tpg_port_stat_cit */
+
+static struct config_group *target_core_port_stat_mkdir(
+	struct config_group *group,
+	const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static void target_core_port_stat_rmdir(
+	struct config_group *group,
+	struct config_item *item)
+{
+	return;
+}
+
+static struct configfs_group_operations target_fabric_port_stat_group_ops = {
+	.make_group		= target_core_port_stat_mkdir,
+	.drop_item		= target_core_port_stat_rmdir,
+};
+
+TF_CIT_SETUP(tpg_port_stat, NULL, &target_fabric_port_stat_group_ops, NULL);
+
+/* End of tfc_tpg_port_stat_cit */
+
 /* Start of tfc_tpg_lun_cit */
 
 static struct config_group *target_fabric_make_lun(
@@ -746,7 +772,9 @@ static struct config_group *target_fabric_make_lun(
 	struct se_portal_group *se_tpg = container_of(group,
 			struct se_portal_group, tpg_lun_group);
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+	struct config_group *lun_cg = NULL, *port_stat_grp = NULL;
 	unsigned long unpacked_lun;
+	int errno;
 
 	if (strstr(name, "lun_") != name) {
 		printk(KERN_ERR "Unable to locate \'_\" in"
@@ -760,16 +788,64 @@ static struct config_group *target_fabric_make_lun(
 	if (!(lun))
 		return ERR_PTR(-EINVAL);
 
+	lun_cg = &lun->lun_group;
+	lun_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+				GFP_KERNEL);
+	if (!lun_cg->default_groups) {
+		printk(KERN_ERR "Unable to allocate lun_cg->default_groups\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
 	config_group_init_type_name(&lun->lun_group, name,
 			&TF_CIT_TMPL(tf)->tfc_tpg_port_cit);
+	config_group_init_type_name(&lun->port_stat_grps.stat_group,
+			"statistics", &TF_CIT_TMPL(tf)->tfc_tpg_port_stat_cit);
+	lun_cg->default_groups[0] = &lun->port_stat_grps.stat_group;	
+	lun_cg->default_groups[1] = NULL;
+
+	port_stat_grp = &PORT_STAT_GRP(lun)->stat_group;
+	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 3,
+				GFP_KERNEL);
+	if (!port_stat_grp->default_groups) {
+		printk(KERN_ERR "Unable to allocate port_stat_grp->default_groups\n");
+		errno = -ENOMEM;
+		goto out;
+	}
+	target_stat_setup_port_default_groups(lun);
 
 	return &lun->lun_group;
+out:
+	if (lun_cg)
+		kfree(lun_cg->default_groups);
+	return ERR_PTR(errno);
 }
 
 static void target_fabric_drop_lun(
 	struct config_group *group,
 	struct config_item *item)
 {
+	struct se_lun *lun = container_of(to_config_group(item),
+				struct se_lun, lun_group);
+	struct config_item *df_item;
+	struct config_group *lun_cg, *port_stat_grp;
+	int i;
+
+	port_stat_grp = &PORT_STAT_GRP(lun)->stat_group;
+	for (i = 0; port_stat_grp->default_groups[i]; i++) {
+		df_item = &port_stat_grp->default_groups[i]->cg_item;
+		port_stat_grp->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+	kfree(port_stat_grp->default_groups);
+
+	lun_cg = &lun->lun_group;
+	for (i = 0; lun_cg->default_groups[i]; i++) {
+		df_item = &lun_cg->default_groups[i]->cg_item;
+		lun_cg->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+	kfree(lun_cg->default_groups);
+
 	config_item_put(item);
 }
 
@@ -980,6 +1056,7 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 	target_fabric_setup_tpg_cit(tf);
 	target_fabric_setup_tpg_base_cit(tf);
 	target_fabric_setup_tpg_port_cit(tf);
+	target_fabric_setup_tpg_port_stat_cit(tf);
 	target_fabric_setup_tpg_lun_cit(tf);
 	target_fabric_setup_tpg_np_cit(tf);
 	target_fabric_setup_tpg_np_base_cit(tf);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 9b2ea89..667efe6 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -683,3 +683,547 @@ void target_stat_setup_dev_default_groups(struct se_subsystem_dev *se_subdev)
 	dev_stat_grp->default_groups[2] = &DEV_STAT_GRP(se_subdev)->scsi_lu_group;
 	dev_stat_grp->default_groups[3] = NULL;
 }
+
+/*
+ * SCSI Port Table
+ */
+
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_port, se_port_stat_grps);
+#define DEV_STAT_SCSI_PORT_ATTR(_name, _mode)				\
+static struct target_stat_scsi_port_attribute				\
+			target_stat_scsi_port_##_name =			\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_port_show_attr_##_name,			\
+	target_stat_scsi_port_store_attr_##_name);
+
+#define DEV_STAT_SCSI_PORT_ATTR_RO(_name)				\
+static struct target_stat_scsi_port_attribute				\
+			target_stat_scsi_port_##_name =			\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_port_show_attr_##_name);
+
+static ssize_t target_stat_scsi_port_show_attr_inst(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_device *dev = lun->lun_se_dev;
+	struct se_hba *hba;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	hba = dev->se_hba;
+	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_PORT_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_port_show_attr_dev(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_device *dev = lun->lun_se_dev;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_PORT_ATTR_RO(dev);
+
+static ssize_t target_stat_scsi_port_show_attr_indx(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	ret = snprintf(page, PAGE_SIZE, "%u\n", sep->sep_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_PORT_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_port_show_attr_role(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_device *dev = lun->lun_se_dev;
+	struct se_port *sep;
+	ssize_t ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	ret = snprintf(page, PAGE_SIZE, "%s%u\n", "Device", dev->dev_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_PORT_ATTR_RO(role);
+
+static ssize_t target_stat_scsi_port_show_attr_busy_count(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	/* FIXME: scsiPortBusyStatuses  */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_PORT_ATTR_RO(busy_count);
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_port, se_port_stat_grps, scsi_port_group);
+
+static struct configfs_attribute *target_stat_scsi_port_attrs[] = {
+	&target_stat_scsi_port_inst.attr,
+	&target_stat_scsi_port_dev.attr,
+	&target_stat_scsi_port_indx.attr,
+	&target_stat_scsi_port_role.attr,
+	&target_stat_scsi_port_busy_count.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_port_attrib_ops = {
+	.show_attribute		= target_stat_scsi_port_attr_show,
+	.store_attribute	= target_stat_scsi_port_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_port_cit = {
+	.ct_item_ops		= &target_stat_scsi_port_attrib_ops,
+	.ct_attrs		= target_stat_scsi_port_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * SCSI Target Port Table
+ */
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_tgt_port, se_port_stat_grps);
+#define DEV_STAT_SCSI_TGT_PORT_ATTR(_name, _mode)			\
+static struct target_stat_scsi_tgt_port_attribute			\
+			target_stat_scsi_tgt_port_##_name =		\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_tgt_port_show_attr_##_name,			\
+	target_stat_scsi_tgt_port_store_attr_##_name);
+
+#define DEV_STAT_SCSI_TGT_PORT_ATTR_RO(_name)				\
+static struct target_stat_scsi_tgt_port_attribute			\
+			target_stat_scsi_tgt_port_##_name =		\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_tgt_port_show_attr_##_name);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_inst(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_device *dev = lun->lun_se_dev;
+	struct se_port *sep;
+	struct se_hba *hba;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}	
+	hba = dev->se_hba;
+	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_dev(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_device *dev = lun->lun_se_dev;
+	struct se_port *sep;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(dev);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_indx(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) { 
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV; 
+	}
+	ret = snprintf(page, PAGE_SIZE, "%u\n", sep->sep_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_name(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+
+	ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
+		TPG_TFO(tpg)->get_fabric_name(), sep->sep_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(name);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_port_index(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+
+	ret = snprintf(page, PAGE_SIZE, "%s%s%d\n",
+		TPG_TFO(tpg)->tpg_get_wwn(tpg), "+t+",
+		TPG_TFO(tpg)->tpg_get_tag(tpg));
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(port_index);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_in_cmds(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+	
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", sep->sep_stats.cmd_pdus);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(in_cmds);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_write_mbytes(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+			(u32)(sep->sep_stats.rx_data_octets >> 20));
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(write_mbytes);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_read_mbytes(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+			(u32)(sep->sep_stats.tx_data_octets >> 20));
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(read_mbytes);
+
+static ssize_t target_stat_scsi_tgt_port_show_attr_hs_in_cmds(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+
+	/* FIXME: scsiTgtPortHsInCommands */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TGT_PORT_ATTR_RO(hs_in_cmds);
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_tgt_port, se_port_stat_grps,
+		scsi_tgt_port_group);
+
+static struct configfs_attribute *target_stat_scsi_tgt_port_attrs[] = {
+	&target_stat_scsi_tgt_port_inst.attr,
+	&target_stat_scsi_tgt_port_dev.attr,
+	&target_stat_scsi_tgt_port_indx.attr,
+	&target_stat_scsi_tgt_port_name.attr,
+	&target_stat_scsi_tgt_port_port_index.attr,
+	&target_stat_scsi_tgt_port_in_cmds.attr,
+	&target_stat_scsi_tgt_port_write_mbytes.attr,
+	&target_stat_scsi_tgt_port_read_mbytes.attr,
+	&target_stat_scsi_tgt_port_hs_in_cmds.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_tgt_port_attrib_ops = {
+	.show_attribute		= target_stat_scsi_tgt_port_attr_show,
+	.store_attribute	= target_stat_scsi_tgt_port_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_tgt_port_cit = {
+	.ct_item_ops		= &target_stat_scsi_tgt_port_attrib_ops,
+	.ct_attrs		= target_stat_scsi_tgt_port_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * SCSI Transport Table
+o */
+
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_transport, se_port_stat_grps);
+#define DEV_STAT_SCSI_TRANSPORT_ATTR(_name, _mode)			\
+static struct target_stat_scsi_transport_attribute			\
+			target_stat_scsi_transport_##_name =		\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_transport_show_attr_##_name,			\
+	target_stat_scsi_transport_store_attr_##_name);
+
+#define DEV_STAT_SCSI_TRANSPORT_ATTR_RO(_name)				\
+static struct target_stat_scsi_transport_attribute			\
+			target_stat_scsi_transport_##_name =		\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_transport_show_attr_##_name);
+
+static ssize_t target_stat_scsi_transport_show_attr_inst(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_device *dev = lun->lun_se_dev;
+	struct se_port *sep;
+	struct se_hba *hba;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+
+	hba = dev->se_hba; 
+	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TRANSPORT_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_transport_show_attr_device(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+	/* scsiTransportType */
+	ret = snprintf(page, PAGE_SIZE, "scsiTransport%s\n",
+			TPG_TFO(tpg)->get_fabric_name());
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TRANSPORT_ATTR_RO(device);
+
+static ssize_t target_stat_scsi_transport_show_attr_indx(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+			TPG_TFO(tpg)->tpg_get_inst_index(tpg));
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TRANSPORT_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_transport_show_attr_dev_name(
+	struct se_port_stat_grps *pgrps, char *page)
+{
+	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
+	struct se_device *dev = lun->lun_se_dev;
+	struct se_port *sep;
+	struct se_portal_group *tpg;
+	struct t10_wwn *wwn;
+	ssize_t ret;
+
+	spin_lock(&lun->lun_sep_lock);
+	sep = lun->lun_sep;
+	if (!sep) {
+		spin_unlock(&lun->lun_sep_lock);
+		return -ENODEV;
+	}
+	tpg = sep->sep_tpg;
+	wwn = DEV_T10_WWN(dev);
+	/* scsiTransportDevName */
+	ret = snprintf(page, PAGE_SIZE, "%s+%s\n",
+			TPG_TFO(tpg)->tpg_get_wwn(tpg),
+			(strlen(wwn->unit_serial)) ? wwn->unit_serial :
+			wwn->vendor);
+	spin_unlock(&lun->lun_sep_lock);
+	return ret;
+}
+DEV_STAT_SCSI_TRANSPORT_ATTR_RO(dev_name);
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_transport, se_port_stat_grps,
+		scsi_transport_group);
+
+static struct configfs_attribute *target_stat_scsi_transport_attrs[] = {
+	&target_stat_scsi_transport_inst.attr,
+	&target_stat_scsi_transport_device.attr,
+	&target_stat_scsi_transport_indx.attr,
+	&target_stat_scsi_transport_dev_name.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_transport_attrib_ops = {
+	.show_attribute		= target_stat_scsi_transport_attr_show,
+	.store_attribute	= target_stat_scsi_transport_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_transport_cit = {
+	.ct_item_ops		= &target_stat_scsi_transport_attrib_ops,
+	.ct_attrs		= target_stat_scsi_transport_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * Called from target_core_fabric_configfs.c:target_fabric_make_lun() to setup
+ * the target port statistics groups + configfs CITs located in target_core_stat.c
+ */
+void target_stat_setup_port_default_groups(struct se_lun *lun)
+{
+	struct config_group *port_stat_grp = &PORT_STAT_GRP(lun)->stat_group;
+
+	config_group_init_type_name(&PORT_STAT_GRP(lun)->scsi_port_group,
+			"scsi_port", &target_stat_scsi_port_cit);
+	config_group_init_type_name(&PORT_STAT_GRP(lun)->scsi_tgt_port_group,
+			"scsi_tgt_port", &target_stat_scsi_tgt_port_cit);
+	config_group_init_type_name(&PORT_STAT_GRP(lun)->scsi_transport_group,
+			"scsi_transport", &target_stat_scsi_transport_cit);
+
+	port_stat_grp->default_groups[0] = &PORT_STAT_GRP(lun)->scsi_port_group;
+	port_stat_grp->default_groups[1] = &PORT_STAT_GRP(lun)->scsi_tgt_port_group;
+	port_stat_grp->default_groups[2] = &PORT_STAT_GRP(lun)->scsi_transport_group;
+	port_stat_grp->default_groups[3] = NULL;
+}
diff --git a/drivers/target/target_core_stat.h b/drivers/target/target_core_stat.h
index 6bc6a87..31cb3c0 100644
--- a/drivers/target/target_core_stat.h
+++ b/drivers/target/target_core_stat.h
@@ -11,5 +11,6 @@ typedef enum {
 #endif
 
 extern void target_stat_setup_dev_default_groups(struct se_subsystem_dev *);
+extern void target_stat_setup_port_default_groups(struct se_lun *);
 
 #endif   /*** TARGET_CORE_STAT_H ***/
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2d20b3f..d153d1d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -841,6 +841,13 @@ struct se_hba {
 
 #define SE_HBA(dev)		((dev)->se_hba)
 
+struct se_port_stat_grps {
+	struct config_group stat_group;
+	struct config_group scsi_port_group;
+	struct config_group scsi_tgt_port_group;
+	struct config_group scsi_transport_group;
+};
+
 struct se_lun {
 	/* See transport_lun_status_table */
 	enum transport_lun_status_table lun_status;
@@ -855,11 +862,13 @@ struct se_lun {
 	struct list_head	lun_cmd_list;
 	struct list_head	lun_acl_list;
 	struct se_device	*lun_se_dev;
+	struct se_port		*lun_sep;
 	struct config_group	lun_group;
-	struct se_port	*lun_sep;
+	struct se_port_stat_grps port_stat_grps;
 } ____cacheline_aligned;
 
 #define SE_LUN(cmd)		((cmd)->se_lun)
+#define PORT_STAT_GRP(lun)	(&(lun)->port_stat_grps)
 
 struct se_port {
 	/* RELATIVE TARGET PORT IDENTIFER */
diff --git a/include/target/target_core_configfs.h b/include/target/target_core_configfs.h
index 40e6e74..06c5b1d 100644
--- a/include/target/target_core_configfs.h
+++ b/include/target/target_core_configfs.h
@@ -18,6 +18,7 @@ struct target_fabric_configfs_template {
 	struct config_item_type tfc_tpg_base_cit;
 	struct config_item_type tfc_tpg_lun_cit;
 	struct config_item_type tfc_tpg_port_cit;
+	struct config_item_type tfc_tpg_port_stat_cit;
 	struct config_item_type tfc_tpg_np_cit;
 	struct config_item_type tfc_tpg_np_base_cit;
 	struct config_item_type tfc_tpg_attrib_cit;
-- 
1.5.6.5
