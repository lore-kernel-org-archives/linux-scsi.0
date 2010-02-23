From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] [TCM/Configfs]: Generic fabric module configfs infrastructure WIP
Date: Mon, 22 Feb 2010 17:04:04 -0800
Message-ID: <1266887044-3827-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:48317 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752946Ab0BWBKs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2010 20:10:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This commit contains the first running pieces of TCM generic fabric module
configfs infrastructure code for v4.0.  This involes the addition of
include/target/target_core_configfs.h:struct target_fabric_configfs_template
that contains struct config_item_type members used to define the new generic
layout in drivers/target/target_core_fabric_configfs.c code.

struct target_fabric_configfs_template {
       struct config_item_type tfc_wwn_cit;
       struct config_item_type tfc_tpg_cit;
       struct config_item_type tfc_tpg_base_cit;
       struct config_item_type tfc_tpg_lun_cit;
       struct config_item_type tfc_tpg_port_cit;
       struct config_item_type tfc_tpg_np_cit;
       struct config_item_type tfc_tpg_np_base_cit;
       struct config_item_type tfc_tpg_attrib_cit;
       struct config_item_type tfc_tpg_param_cit;
       struct config_item_type tfc_tpg_acl_cit;
};

So far, everything aside from tfc_tpg_acl_cit and NodeACL+MappedLUN ACLs are up and running
and able to reproduce existing 3.x fabric module configfs layout in demo mode with patched
LIO-Target and TCM_Loop fabric modules.  The following fabric module API calls in
include/target/target_core_fabric_ops.h:struct target_core_fabric_ops have been added and
are used by fabric modules to reproduce existing 3.x $WWN, tpgt_$TPGT and lun/np default
groups from /sys/kernel/config/target/$FABRIC/$WWN/tpgt_$TPGT/[lun,np]

       /*
        * fabric module calls for target_core_fabric_configfs.c
        */
       struct se_wwn_s *(*fabric_make_wwn)(struct target_fabric_configfs *,
                               struct config_group *, const char *);
       void (*fabric_drop_wwn)(struct se_wwn_s *);
       struct se_portal_group_s *(*fabric_make_tpg)(struct se_wwn_s *,
                               struct config_group *, const char *);
       void (*fabric_drop_tpg)(struct se_portal_group_s *);
       int (*fabric_post_link)(struct se_portal_group_s *,
                               struct se_lun_s *);
       void (*fabric_pre_unlink)(struct se_portal_group_s *,
                               struct se_lun_s *);
       struct se_tpg_np_s *(*fabric_make_np)(struct se_portal_group_s *,
                               struct config_group *, const char *);
       void (*fabric_drop_np)(struct se_tpg_np_s *);

This commit also includes a number of config_item_type context specific TF_* + CONFIGFS_EATTR()
macros in include/target/target_core_fabric_configfs.h that are used by fabric modules to
define attributes for 'cits' in the new target_core_fabric_configfs.c code hanging of
struct target_fabric_configfs_template.

There are also other relatively minor changes required to existing target_core_mod code
in order to get things up and running.  This includes:

Changing target_fabric_configfs_init() to accept a 'struct module *' instead of
'struct config_item_type', and saving it at struct target_fabric_configfs->tf_module.

and changing core_tpg_register() to accept the struct se_portal_group_s pointer
hanging off the fabric's internal struct $FABRIC_portal_group, and new parent struct se_wwn_s *

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kbuild                        |    1 +
 drivers/target/target_core_configfs.c        |   24 +-
 drivers/target/target_core_fabric_configfs.c |  612 ++++++++++++++++++++++++++
 drivers/target/target_core_tpg.c             |   18 +-
 include/target/target_core_base.h            |   22 +-
 include/target/target_core_configfs.h        |   20 +-
 include/target/target_core_fabric_configfs.h |   50 +++
 include/target/target_core_fabric_ops.h      |   19 +
 include/target/target_core_tpg.h             |    6 +-
 9 files changed, 748 insertions(+), 24 deletions(-)
 create mode 100644 drivers/target/target_core_fabric_configfs.c
 create mode 100644 include/target/target_core_fabric_configfs.h

diff --git a/drivers/target/Kbuild b/drivers/target/Kbuild
index e2048d6..e872e1a 100644
--- a/drivers/target/Kbuild
+++ b/drivers/target/Kbuild
@@ -2,6 +2,7 @@ EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
 
 target_core_mod-y		:= target_core_configfs.o \
 				   target_core_device.o \
+				   target_core_fabric_configfs.o \
 				   target_core_hba.o \
 				   target_core_plugin.o \
 				   target_core_pr.o \
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 17bd613..3d25b61 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -47,6 +47,7 @@
 #include <target/target_core_alua.h>
 #include <target/target_core_pr.h>
 #include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
 #include <target/target_core_configfs.h>
 #include <target/configfs_macros.h>
 
@@ -186,9 +187,10 @@ static struct config_group *target_core_register_fabric(
 	 * On a successful target_core_get_fabric() look, the returned
 	 * struct target_fabric_configfs *tf will contain a usage reference.
 	 */
-	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> %p\n",
-			tf->tf_fabric_cit);
-	config_group_init_type_name(&tf->tf_group, name, tf->tf_fabric_cit);
+	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n",
+			&TF_CIT_TMPL(tf)->tfc_wwn_cit);
+	config_group_init_type_name(&tf->tf_group, name,
+			&TF_CIT_TMPL(tf)->tfc_wwn_cit);
 	/*
 	 * Setup any default configfs groups in the top level directory of
 	 * this fabric module.
@@ -285,13 +287,13 @@ static struct configfs_subsystem *target_core_subsystem[] = {
  *    into target_fabric_configfs_register().
  */
 struct target_fabric_configfs *target_fabric_configfs_init(
-	struct config_item_type *fabric_cit,
+	struct module *fabric_mod,
 	const char *name)
 {
 	struct target_fabric_configfs *tf;
 
-	if (!(fabric_cit)) {
-		printk(KERN_ERR "Missing struct config_item_type * pointer\n");
+	if (!(fabric_mod)) {
+		printk(KERN_ERR "Missing struct module *fabric_mod pointer\n");
 		return NULL;
 	}
 	if (!(name)) {
@@ -310,7 +312,13 @@ struct target_fabric_configfs *target_fabric_configfs_init(
 
 	INIT_LIST_HEAD(&tf->tf_list);
 	atomic_set(&tf->tf_access_cnt, 0);
-	tf->tf_fabric_cit = fabric_cit;
+	/*
+	 * Setup the default generic struct config_item_type's (cits) in
+	 * struct target_fabric_configfs->tf_cit_tmpl
+	 */
+	tf->tf_module = fabric_mod;
+	target_fabric_setup_cits(tf);
+
 	tf->tf_subsys = target_core_subsystem[0];
 	snprintf(tf->tf_name, TARGET_FABRIC_NAME_SIZE, "%s", name);
 
@@ -433,7 +441,7 @@ void target_fabric_configfs_deregister(
 
 	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> Releasing tf:"
 			" %s\n", tf->tf_name);
-	tf->tf_fabric_cit = NULL;
+	tf->tf_module = NULL;
 	tf->tf_subsys = NULL;
 	kfree(tf->tf_group.default_groups);
 	kfree(tf);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
new file mode 100644
index 0000000..d2cb051
--- /dev/null
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -0,0 +1,612 @@
+/*******************************************************************************
+* Filename: target_core_fabric_configfs.c
+ *
+ * This file contains generic fabric module configfs infrastructure for
+ * TCM v4.x code
+ *
+ * Copyright (c) 2010 Rising Tide Systems
+ * Copyright (c) 2010 Linux-iSCSI.org
+ *
+ * Copyright (c) 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
+*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ****************************************************************************/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <linux/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/unistd.h>
+#include <linux/string.h>
+#include <linux/syscalls.h>
+#include <linux/configfs.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_device.h>
+#include <target/target_core_hba.h>
+#include <target/target_core_plugin.h>
+#include <target/target_core_seobj.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_alua.h>
+#include <target/target_core_pr.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
+#include <target/target_core_configfs.h>
+#include <target/configfs_macros.h>
+
+#define TF_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
+static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
+{									\
+	struct target_fabric_configfs_template *tfc = &tf->tf_cit_tmpl;	\
+	struct config_item_type *cit = &tfc->tfc_##_name##_cit;		\
+									\
+	cit->ct_item_ops = _item_ops;					\
+	cit->ct_group_ops = _group_ops;					\
+	cit->ct_attrs = _attrs;						\
+	cit->ct_owner = tf->tf_module;					\
+	printk("Setup generic %s\n", __stringify(_name));		\
+}
+
+/* Start of tfc_tpg_acl_cit */
+
+static struct configfs_group_operations target_fabric_acl_group_ops = {
+	.make_group	= NULL,
+	.drop_item	= NULL,
+};
+
+TF_CIT_SETUP(tpg_acl, NULL, &target_fabric_acl_group_ops, NULL);
+
+/* End of tfc_tpg_acl_cit */
+
+/* Start of tfc_tpg_np_base_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_np_base, se_tpg_np_s, tpg_np_group);
+
+static struct configfs_item_operations target_fabric_np_base_item_ops = {
+	.show_attribute		= target_fabric_np_base_attr_show,
+	.store_attribute	= target_fabric_np_base_attr_store,
+};
+
+TF_CIT_SETUP(tpg_np_base, &target_fabric_np_base_item_ops, NULL, NULL);
+
+/* End of tfc_tpg_np_base_cit */
+
+/* Start of tfc_tpg_np_cit */
+
+static struct config_group *target_fabric_make_np(
+	struct config_group *group,
+	const char *name)
+{
+	struct se_portal_group_s *se_tpg = container_of(group,
+				struct se_portal_group_s, tpg_np_group);
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+	struct se_tpg_np_s *se_tpg_np;
+
+	if (!(tf->tf_ops.fabric_make_np)) {
+		printk(KERN_ERR "tf->tf_ops.fabric_make_np is NULL\n");
+		return ERR_PTR(-ENOSYS);
+	}
+
+	se_tpg_np = tf->tf_ops.fabric_make_np(se_tpg, group, name);
+	if (!(se_tpg_np) || IS_ERR(se_tpg_np))
+		return ERR_PTR(-EINVAL);
+
+	config_group_init_type_name(&se_tpg_np->tpg_np_group, name,
+			&TF_CIT_TMPL(tf)->tfc_tpg_np_base_cit);						
+
+	return &se_tpg_np->tpg_np_group;
+}
+
+static void target_fabric_drop_np(
+	struct config_group *group,
+	struct config_item *item)
+{
+	struct se_portal_group_s *se_tpg = container_of(group,
+				struct se_portal_group_s, tpg_np_group);
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+	struct se_tpg_np_s *se_tpg_np = container_of(to_config_group(item),
+				struct se_tpg_np_s, tpg_np_group);
+
+	config_item_put(item);
+	tf->tf_ops.fabric_drop_np(se_tpg_np);
+}
+
+static struct configfs_group_operations target_fabric_np_group_ops = {
+	.make_group	= &target_fabric_make_np,
+	.drop_item	= &target_fabric_drop_np,
+};
+
+TF_CIT_SETUP(tpg_np, NULL, &target_fabric_np_group_ops, NULL);
+
+/* End of tfc_tpg_np_cit */
+
+/* Start of tfc_tpg_port_cit */
+
+CONFIGFS_EATTR_STRUCT(target_fabric_port, se_lun_s);
+#define TCM_PORT_ATTR(_name, _mode)					\
+static struct target_fabric_port_attribute target_fabric_port_##_name =	\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_fabric_port_show_attr_##_name,				\
+	target_fabric_port_store_attr_##_name);
+
+#define TCM_PORT_ATTOR_RO(_name)					\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_fabric_port_show_attr_##_name);
+
+/*
+ * alua_tg_pt_gp
+ */
+static ssize_t target_fabric_port_show_attr_alua_tg_pt_gp(
+	struct se_lun_s *lun,
+	char *page)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_show_tg_pt_gp_info(lun->lun_sep, page);
+}
+
+static ssize_t target_fabric_port_store_attr_alua_tg_pt_gp(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_store_tg_pt_gp_info(lun->lun_sep, page, count);
+}
+
+TCM_PORT_ATTR(alua_tg_pt_gp, S_IRUGO | S_IWUSR);
+
+/*
+ * alua_tg_pt_offline
+ */
+static ssize_t target_fabric_port_show_attr_alua_tg_pt_offline(
+	struct se_lun_s *lun,
+	char *page)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_show_offline_bit(lun, page);
+}
+
+static ssize_t target_fabric_port_store_attr_alua_tg_pt_offline(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_store_offline_bit(lun, page, count);
+}
+
+TCM_PORT_ATTR(alua_tg_pt_offline, S_IRUGO | S_IWUSR);
+
+/*
+ * alua_tg_pt_status
+ */
+static ssize_t target_fabric_port_show_attr_alua_tg_pt_status(
+	struct se_lun_s *lun,
+	char *page)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_show_secondary_status(lun, page);
+}
+
+static ssize_t target_fabric_port_store_attr_alua_tg_pt_status(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_store_secondary_status(lun, page, count);
+}
+
+TCM_PORT_ATTR(alua_tg_pt_status, S_IRUGO | S_IWUSR);
+
+/*
+ * alua_tg_pt_write_md
+ */
+static ssize_t target_fabric_port_show_attr_alua_tg_pt_write_md(
+	struct se_lun_s *lun,
+	char *page)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_show_secondary_write_metadata(lun, page);
+}
+
+static ssize_t target_fabric_port_store_attr_alua_tg_pt_write_md(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_store_secondary_write_metadata(lun, page, count);
+}
+
+TCM_PORT_ATTR(alua_tg_pt_write_md, S_IRUGO | S_IWUSR);
+
+
+static struct configfs_attribute *target_fabric_port_attrs[] = {
+	&target_fabric_port_alua_tg_pt_gp.attr,
+	&target_fabric_port_alua_tg_pt_offline.attr,
+	&target_fabric_port_alua_tg_pt_status.attr,
+	&target_fabric_port_alua_tg_pt_write_md.attr,
+	NULL,
+};
+
+CONFIGFS_EATTR_OPS(target_fabric_port, se_lun_s, lun_group);
+
+static int target_fabric_port_link(
+	struct config_item *lun_ci,
+	struct config_item *se_dev_ci)
+{
+	struct config_item *tpg_ci;
+	struct se_device_s *dev;
+	struct se_lun_s *lun = container_of(to_config_group(lun_ci),
+				struct se_lun_s, lun_group);
+	struct se_lun_s *lun_p;
+	struct se_portal_group_s *se_tpg;
+	struct se_subsystem_dev_s *se_dev = container_of(
+				to_config_group(se_dev_ci), se_subsystem_dev_t,
+				se_dev_group);
+	struct target_fabric_configfs *tf;
+	int ret;
+
+	tpg_ci = &lun_ci->ci_parent->ci_group->cg_item;
+	se_tpg = container_of(to_config_group(tpg_ci),
+				struct se_portal_group_s, tpg_group);
+	tf = se_tpg->se_tpg_wwn->wwn_tf;
+
+	if (lun->lun_type_ptr != NULL) {
+		printk(KERN_ERR "Port Symlink already exists\n");
+		return -EEXIST;
+	}
+	
+	dev = se_dev->se_dev_ptr;
+	if (!(dev)) {
+		printk(KERN_ERR "Unable to locate se_device_t pointer from"
+			" %s\n", config_item_name(se_dev_ci));
+		ret = -ENODEV;
+		goto out;
+	}
+
+	lun_p = core_dev_add_lun(se_tpg, dev->se_hba, dev,
+				lun->unpacked_lun);
+	if ((IS_ERR(lun_p)) || !(lun_p)) {
+		printk(KERN_ERR "core_dev_add_lun() failed\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (tf->tf_ops.fabric_post_link) {
+		/*
+		 * Call the optional fabric_post_link() to allow a
+		 * fabric module to setup any additional state once
+		 * core_dev_add_lun() has been called..
+		 */
+		tf->tf_ops.fabric_post_link(se_tpg, lun);
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+static int target_fabric_port_check_link(
+	struct config_item *lun_ci,
+	struct config_item *se_dev_ci)
+{
+	struct se_lun_s *lun = container_of(to_config_group(lun_ci),
+				struct se_lun_s, lun_group);
+
+	return atomic_read(&lun->lun_acl_count) ? -EPERM : 0;
+}
+
+static int target_fabric_port_unlink(
+	struct config_item *lun_ci,
+	struct config_item *se_dev_ci)
+{
+	struct se_lun_s *lun = container_of(to_config_group(lun_ci),
+				struct se_lun_s, lun_group);
+	struct se_portal_group_s *se_tpg = lun->lun_sep->sep_tpg;
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+
+	if (tf->tf_ops.fabric_pre_unlink) {
+		/*
+		 * Call the optional fabric_pre_unlink() to allow a
+		 * fabric module to release any additional stat before
+		 * core_dev_del_lun() is called.
+		*/
+		tf->tf_ops.fabric_pre_unlink(se_tpg, lun);
+	}
+
+	core_dev_del_lun(se_tpg, lun->unpacked_lun);
+	return 0;
+}
+
+static struct configfs_item_operations target_fabric_port_item_ops = {
+	.show_attribute		= target_fabric_port_attr_show,
+	.store_attribute	= target_fabric_port_attr_store,
+	.allow_link		= target_fabric_port_link,
+	.check_link		= target_fabric_port_check_link,
+	.drop_link		= target_fabric_port_unlink,
+};
+
+TF_CIT_SETUP(tpg_port, &target_fabric_port_item_ops, NULL, target_fabric_port_attrs);
+
+/* End of tfc_tpg_port_cit */
+
+/* Start of tfc_tpg_lun_cit */
+
+static struct config_group *target_fabric_make_lun(
+	struct config_group *group,
+	const char *name)
+{
+	struct se_lun_s *lun;
+	struct se_portal_group_s *se_tpg = container_of(group,
+			struct se_portal_group_s, tpg_lun_group);
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+	
+	char *str, *endptr;
+	u32 unpacked_lun;
+	int ret;
+
+	str = strstr(name, "_");
+	if (!(str)) {
+		printk(KERN_ERR "Unable to locate \'_\" in"
+				" \"lun_$LUN_NUMBER\"\n");
+		return NULL;
+	}
+	str++; /* Advance over _ delim.. */
+	unpacked_lun = simple_strtoul(str, &endptr, 0);
+
+	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
+	if (!(lun))
+		return ERR_PTR(-EINVAL);
+
+	config_group_init_type_name(&lun->lun_group, name,
+			&TF_CIT_TMPL(tf)->tfc_tpg_port_cit);
+
+	return &lun->lun_group;
+}
+
+static void target_fabric_drop_lun(
+	struct config_group *group,
+	struct config_item *item)
+{
+	struct se_portal_group_s *se_tpg = container_of(group,
+			struct se_portal_group_s, tpg_lun_group);
+	struct se_lun_s *lun = container_of(to_config_group(item),
+			se_lun_t, lun_group);
+
+	config_item_put(item);
+}
+
+static struct configfs_group_operations target_fabric_lun_group_ops = {
+	.make_group	= &target_fabric_make_lun,
+	.drop_item	= &target_fabric_drop_lun,
+};
+
+TF_CIT_SETUP(tpg_lun, NULL, &target_fabric_lun_group_ops, NULL);
+
+/* End of tfc_tpg_lun_cit */
+
+/* Start of tfc_tpg_attrib_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_tpg_attrib, se_portal_group_s, tpg_attrib_group);
+
+static struct configfs_item_operations target_fabric_tpg_attrib_item_ops = {
+	.show_attribute		= target_fabric_tpg_attrib_attr_show,
+	.store_attribute	= target_fabric_tpg_attrib_attr_store,
+};
+
+TF_CIT_SETUP(tpg_attrib, &target_fabric_tpg_attrib_item_ops, NULL, NULL);
+
+/* End of tfc_tpg_attrib_cit */
+
+/* Start of tfc_tpg_param_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_tpg_param, se_portal_group_s, tpg_param_group);
+
+static struct configfs_item_operations target_fabric_tpg_param_item_ops = {
+	.show_attribute		= target_fabric_tpg_param_attr_show,
+	.store_attribute	= target_fabric_tpg_param_attr_store,
+};
+
+TF_CIT_SETUP(tpg_param, &target_fabric_tpg_param_item_ops, NULL, NULL);
+
+/* End of tfc_tpg_param_cit */
+
+/* Start of tfc_tpg_base_cit */
+/*
+ * For use with TF_TPG_ATTR() and TF_TPG_ATTR_RO()
+ */
+CONFIGFS_EATTR_OPS(target_fabric_tpg, se_portal_group_s, tpg_group);
+
+static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
+	.show_attribute		= target_fabric_tpg_attr_show,
+	.store_attribute	= target_fabric_tpg_attr_store,
+};
+
+TF_CIT_SETUP(tpg_base, &target_fabric_tpg_base_item_ops, NULL, NULL);
+
+/* End of tfc_tpg_base_cit */
+
+/* Start of tfc_tpg_cit */
+
+static struct config_group *target_fabric_make_tpg(
+	struct config_group *group,
+	const char *name)
+{
+	struct se_wwn_s *wwn = container_of(group, struct se_wwn_s, wwn_group);
+	struct target_fabric_configfs *tf = wwn->wwn_tf;
+	struct se_portal_group_s *se_tpg;
+
+	if (!(tf->tf_ops.fabric_make_tpg)) {
+		printk(KERN_ERR "tf->tf_ops.fabric_make_tpg is NULL\n");
+		return ERR_PTR(-ENOSYS);
+	}
+
+	se_tpg = tf->tf_ops.fabric_make_tpg(wwn, group, name);
+	if (!(se_tpg) || IS_ERR(se_tpg))
+		return ERR_PTR(-EINVAL);
+	/*
+	 * Setup default groups from pre-allocated se_tpg->tpg_default_groups
+	 */
+	se_tpg->tpg_group.default_groups = se_tpg->tpg_default_groups;
+	se_tpg->tpg_group.default_groups[0] = &se_tpg->tpg_lun_group;
+	se_tpg->tpg_group.default_groups[1] = &se_tpg->tpg_np_group;
+	se_tpg->tpg_group.default_groups[2] = &se_tpg->tpg_acl_group;
+	se_tpg->tpg_group.default_groups[3] = &se_tpg->tpg_attrib_group;
+	se_tpg->tpg_group.default_groups[4] = &se_tpg->tpg_param_group;
+	se_tpg->tpg_group.default_groups[5] = NULL;
+
+	config_group_init_type_name(&se_tpg->tpg_group, name,
+			&TF_CIT_TMPL(tf)->tfc_tpg_base_cit);
+	config_group_init_type_name(&se_tpg->tpg_lun_group, "lun",
+			&TF_CIT_TMPL(tf)->tfc_tpg_lun_cit);
+	config_group_init_type_name(&se_tpg->tpg_np_group, "np",
+			&TF_CIT_TMPL(tf)->tfc_tpg_np_cit);
+	config_group_init_type_name(&se_tpg->tpg_acl_group, "acls",
+			&TF_CIT_TMPL(tf)->tfc_tpg_acl_cit);
+	config_group_init_type_name(&se_tpg->tpg_attrib_group, "attrib",
+			&TF_CIT_TMPL(tf)->tfc_tpg_attrib_cit);
+	config_group_init_type_name(&se_tpg->tpg_param_group, "param",
+			&TF_CIT_TMPL(tf)->tfc_tpg_param_cit);
+			
+	return &se_tpg->tpg_group;
+}
+
+static void target_fabric_drop_tpg(
+	struct config_group *group,
+	struct config_item *item)
+{
+	struct se_wwn_s *wwn = container_of(group, struct se_wwn_s, wwn_group);
+	struct target_fabric_configfs *tf = wwn->wwn_tf;
+	struct se_portal_group_s *se_tpg = container_of(to_config_group(item),
+				struct se_portal_group_s, tpg_group);
+	struct config_group *tpg_cg = &se_tpg->tpg_group;
+	struct config_item *df_item;
+	int i;
+	/*
+	 * Release default groups, but do not release tpg_cg->default_groups
+	 * memory as it is statically allocated at se_tpg->tpg_default_groups.
+	 */
+	for (i = 0; tpg_cg->default_groups[i]; i++) {
+		df_item = &tpg_cg->default_groups[i]->cg_item;
+		tpg_cg->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+
+	config_item_put(item);
+	tf->tf_ops.fabric_drop_tpg(se_tpg);	
+}
+
+static struct configfs_group_operations target_fabric_tpg_group_ops = {
+	.make_group	= target_fabric_make_tpg,
+	.drop_item	= target_fabric_drop_tpg,
+};
+
+TF_CIT_SETUP(tpg, NULL, &target_fabric_tpg_group_ops, NULL);
+
+/* End of tfc_tpg_cit */
+
+/* Start of tfc_wwn_cit */
+
+static struct config_group *target_fabric_make_wwn(
+	struct config_group *group,
+	const char *name)
+{
+	struct target_fabric_configfs *tf = container_of(group,
+				struct target_fabric_configfs, tf_group);
+	struct se_wwn_s *wwn;
+
+	if (!(tf->tf_ops.fabric_make_wwn)) {
+		printk(KERN_ERR "tf->tf_ops.fabric_make_wwn is NULL\n");
+		return ERR_PTR(-ENOSYS);
+	}
+
+	wwn = tf->tf_ops.fabric_make_wwn(tf, group, name);
+	if (!(wwn) || IS_ERR(wwn))
+		return ERR_PTR(-EINVAL);
+
+	wwn->wwn_tf = tf;
+	config_group_init_type_name(&wwn->wwn_group, name,
+			&TF_CIT_TMPL(tf)->tfc_tpg_cit);
+
+	return &wwn->wwn_group;
+}
+
+static void target_fabric_drop_wwn(
+	struct config_group *group,
+	struct config_item *item)
+{
+	struct target_fabric_configfs *tf = container_of(group,
+				struct target_fabric_configfs, tf_group);
+	struct se_wwn_s *wwn = container_of(to_config_group(item),
+				se_wwn_t, wwn_group);
+	
+	config_item_put(item);
+	tf->tf_ops.fabric_drop_wwn(wwn);
+}
+
+static struct configfs_group_operations target_fabric_wwn_group_ops = {
+	.make_group	= target_fabric_make_wwn,
+	.drop_item	= target_fabric_drop_wwn,
+};
+/*
+ * For use with TF_WWN_ATTR() and TF_WWN_ATTR_RO()
+ */
+CONFIGFS_EATTR_OPS(target_fabric_wwn, target_fabric_configfs, tf_group);
+
+static struct configfs_item_operations target_fabric_wwn_item_ops = {
+	.show_attribute		= target_fabric_wwn_attr_show,
+	.store_attribute	= target_fabric_wwn_attr_store,
+};	
+
+TF_CIT_SETUP(wwn, &target_fabric_wwn_item_ops, &target_fabric_wwn_group_ops, NULL);
+
+/* End of tfc_wwn_cit */
+
+int target_fabric_setup_cits(struct target_fabric_configfs *tf)
+{
+	target_fabric_setup_wwn_cit(tf);	
+	target_fabric_setup_tpg_cit(tf);
+	target_fabric_setup_tpg_base_cit(tf);
+	target_fabric_setup_tpg_port_cit(tf);
+	target_fabric_setup_tpg_lun_cit(tf);
+	target_fabric_setup_tpg_np_cit(tf);
+	target_fabric_setup_tpg_np_base_cit(tf);
+	target_fabric_setup_tpg_attrib_cit(tf);
+	target_fabric_setup_tpg_param_cit(tf);
+	target_fabric_setup_tpg_acl_cit(tf);
+
+	return 0;
+}
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 1eb4b98..9ec5cdd 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -629,28 +629,22 @@ int core_tpg_set_initiator_node_queue_depth(
 }
 EXPORT_SYMBOL(core_tpg_set_initiator_node_queue_depth);
 
-se_portal_group_t *core_tpg_register(
+int core_tpg_register(
 	struct target_core_fabric_ops *tfo,
+	struct se_wwn_s *se_wwn,
+	struct se_portal_group_s *se_tpg,
 	void *tpg_fabric_ptr,
 	int se_tpg_type)
 {
 	se_lun_t *lun;
-	se_portal_group_t *se_tpg;
 	u32 i;
 
-	se_tpg = kzalloc(sizeof(se_portal_group_t), GFP_KERNEL);
-	if (!(se_tpg)) {
-		printk(KERN_ERR "Unable to allocate se_portal_group_t\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
 	se_tpg->tpg_lun_list = kzalloc((sizeof(se_lun_t) *
 				TRANSPORT_MAX_LUNS_PER_TPG), GFP_KERNEL);
 	if (!(se_tpg->tpg_lun_list)) {
 		printk(KERN_ERR "Unable to allocate se_portal_group_t->"
 				"tpg_lun_list\n");
-		kfree(se_tpg);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
@@ -669,6 +663,7 @@ se_portal_group_t *core_tpg_register(
 	se_tpg->se_tpg_type = se_tpg_type;
 	se_tpg->se_tpg_fabric_ptr = tpg_fabric_ptr;
 	se_tpg->se_tpg_tfo = tfo;
+	se_tpg->se_tpg_wwn = se_wwn;
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
 	INIT_LIST_HEAD(&se_tpg->se_tpg_list);
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
@@ -686,7 +681,7 @@ se_portal_group_t *core_tpg_register(
 		"Normal" : "Discovery", (tfo->tpg_get_wwn(se_tpg) == NULL) ?
 		"None" : tfo->tpg_get_wwn(se_tpg), tfo->tpg_get_tag(se_tpg));
 
-	return se_tpg;
+	return 0;
 }
 EXPORT_SYMBOL(core_tpg_register);
 
@@ -705,7 +700,6 @@ int core_tpg_deregister(se_portal_group_t *se_tpg)
 
 	se_tpg->se_tpg_fabric_ptr = NULL;
 	kfree(se_tpg->tpg_lun_list);
-	kfree(se_tpg);
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 74772cd..e140136 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -38,7 +38,7 @@
 #include <target/target_core_mib.h>
 #endif /* SNMP_SUPPORT */
 
-#define TARGET_CORE_MOD_VERSION		"v3.2.2"
+#define TARGET_CORE_MOD_VERSION		"v3.9.8"
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
 
 /* SCSI Command Descriptor Block Size a la SCSI's MAX_COMMAND_SIZE */
@@ -936,6 +936,10 @@ typedef struct se_port_s {
 	struct list_head sep_list;
 } ____cacheline_aligned se_port_t;
 
+typedef struct se_tpg_np_s {
+	struct config_group	tpg_np_group;
+} ____cacheline_aligned se_tpg_np_t;
+
 typedef struct se_portal_group_s {
 	/* Type of target portal group */
 	int			se_tpg_type;
@@ -956,11 +960,27 @@ typedef struct se_portal_group_s {
 	struct list_head	tpg_sess_list;
 	/* Pointer to $FABRIC_MOD dependent code */
 	struct target_core_fabric_ops *se_tpg_tfo;
+	struct se_wwn_s		*se_tpg_wwn;
 	struct config_group	tpg_group;
+	struct config_group	*tpg_default_groups[6];
+	struct config_group	tpg_lun_group;
+	struct config_group	tpg_np_group;
+	struct config_group	tpg_acl_group;
+	struct config_group	tpg_attrib_group;
+	struct config_group	tpg_param_group;
 } ____cacheline_aligned se_portal_group_t;
 
 #define TPG_TFO(se_tpg)	((struct target_core_fabric_ops *)(se_tpg)->se_tpg_tfo)
 
+typedef struct se_auth_s {
+	struct config_group	auth_group;
+} ____cacheline_aligned se_auth_t;
+
+typedef struct se_wwn_s {
+	struct target_fabric_configfs *wwn_tf;
+	struct config_group	wwn_group;
+} ____cacheline_aligned se_wwn_t;
+
 typedef struct se_global_s {
 	u16			alua_lu_gps_counter;
 	u32			in_shutdown;
diff --git a/include/target/target_core_configfs.h b/include/target/target_core_configfs.h
index 73c1b88..0a5a8a4 100644
--- a/include/target/target_core_configfs.h
+++ b/include/target/target_core_configfs.h
@@ -36,13 +36,26 @@ extern se_global_t *se_global;
 
 extern struct se_hba_s *target_core_get_hba_from_item(struct config_item *);
 extern struct target_fabric_configfs *target_fabric_configfs_init(
-				struct config_item_type *, const char *name);
+				struct module *, const char *);
 extern void target_fabric_configfs_free(struct target_fabric_configfs *);
 extern int target_fabric_configfs_register(struct target_fabric_configfs *);
 extern void target_fabric_configfs_deregister(struct target_fabric_configfs *);
 extern int target_core_init_configfs(void);
 extern void target_core_exit_configfs(void);
 
+struct target_fabric_configfs_template {
+	struct config_item_type	tfc_wwn_cit;
+	struct config_item_type tfc_tpg_cit;
+	struct config_item_type tfc_tpg_base_cit;
+	struct config_item_type tfc_tpg_lun_cit;
+	struct config_item_type tfc_tpg_port_cit;
+	struct config_item_type tfc_tpg_np_cit;
+	struct config_item_type tfc_tpg_np_base_cit;
+	struct config_item_type tfc_tpg_attrib_cit;
+	struct config_item_type tfc_tpg_param_cit;
+	struct config_item_type tfc_tpg_acl_cit;
+};
+
 struct target_fabric_configfs {
 	char			tf_name[TARGET_FABRIC_NAME_SIZE];
 	atomic_t		tf_access_cnt;
@@ -55,5 +68,10 @@ struct target_fabric_configfs {
 	struct config_item_type	*tf_fabric_cit;
 	/* Pointer to target core subsystem */
 	struct configfs_subsystem *tf_subsys;
+	/* Pointer to fabric's struct module */
+	struct module *tf_module;
 	struct target_core_fabric_ops tf_ops;
+	struct target_fabric_configfs_template tf_cit_tmpl;
 };
+
+#define TF_CIT_TMPL(tf) (&(tf)->tf_cit_tmpl)
diff --git a/include/target/target_core_fabric_configfs.h b/include/target/target_core_fabric_configfs.h
new file mode 100644
index 0000000..6d177ca
--- /dev/null
+++ b/include/target/target_core_fabric_configfs.h
@@ -0,0 +1,50 @@
+/*
+ * Used for tfc_wwn_cit attributes
+ */
+
+#include <target/configfs_macros.h>
+
+CONFIGFS_EATTR_STRUCT(target_fabric_np_base, se_tpg_np_s);
+#define TF_NP_BASE_ATTR(_fabric, _name, _mode)				\
+static struct target_fabric_np_base_attribute _fabric##_np_##_name =	\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_np_show_##_name,					\
+	_fabric##_np_store_##_name);
+
+CONFIGFS_EATTR_STRUCT(target_fabric_tpg_attrib, se_portal_group_s);
+#define TF_TPG_ATTRIB_ATTR(_fabric, _name, _mode)			\
+static struct target_fabric_tpg_attrib_attribute _fabric##_tpg_attrib_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_tpg_attrib_show_##_name,				\
+	_fabric##_tpg_attrib_store_##_name);
+
+
+CONFIGFS_EATTR_STRUCT(target_fabric_tpg_param, se_portal_group_s);
+#define TF_TPG_PARAM_ATTR(_fabric, _name, _mode)			\
+static struct target_fabric_tpg_param_attribute _fabric##_tpg_param_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_tpg_param_show_##_name,				\
+	_fabric##_tpg_param_store_##_name);
+
+
+CONFIGFS_EATTR_STRUCT(target_fabric_tpg, se_portal_group_s);
+#define TF_TPG_BASE_ATTR(_fabric, _name, _mode)				\
+static struct target_fabric_tpg_attribute _fabric##_tpg_##_name =	\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_tpg_show_##_name,					\
+	_fabric##_tpg_store_##_name);
+
+
+CONFIGFS_EATTR_STRUCT(target_fabric_wwn, target_fabric_configfs);
+#define TF_WWN_ATTR(_fabric, _name, _mode)				\
+static struct target_fabric_wwn_attribute _fabric##_wwn_##_name =	\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_wwn_show_attr_##_name,				\
+	_fabric##_wwn_store_attr_##_name);
+
+#define TF_WWN_ATTR_RO(_fabric, _name)					\
+static struct target_fabric_wwn_attribute _fabric##_wwn_##_name =	\
+	__CONFIGFS_EATTR_RO(_name,					\
+	_fabric##_wwn_show_attr_##_name);
+
+extern int target_fabric_setup_cits(struct target_fabric_configfs *);
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 2633158..725a530 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -1,3 +1,6 @@
+/* Defined in target_core_configfs.h */
+struct target_fabric_configfs;
+
 struct target_core_fabric_ops {
 	struct configfs_subsystem *tf_subsys;
 	char *(*get_fabric_name)(void);
@@ -55,4 +58,20 @@ struct target_core_fabric_ops {
 	u16 (*get_fabric_sense_len)(void);
 	int (*is_state_remove)(struct se_cmd_s *);
 	u64 (*pack_lun)(unsigned int);
+	/*
+	 * fabric module calls for target_core_fabric_configfs.c
+	 */
+	struct se_wwn_s *(*fabric_make_wwn)(struct target_fabric_configfs *,
+				struct config_group *, const char *);
+	void (*fabric_drop_wwn)(struct se_wwn_s *);
+	struct se_portal_group_s *(*fabric_make_tpg)(struct se_wwn_s *,
+				struct config_group *, const char *);
+	void (*fabric_drop_tpg)(struct se_portal_group_s *);
+	int (*fabric_post_link)(struct se_portal_group_s *,
+				struct se_lun_s *);
+	void (*fabric_pre_unlink)(struct se_portal_group_s *,
+				struct se_lun_s *);
+	struct se_tpg_np_s *(*fabric_make_np)(struct se_portal_group_s *,
+				struct config_group *, const char *);
+	void (*fabric_drop_np)(struct se_tpg_np_s *);
 };
diff --git a/include/target/target_core_tpg.h b/include/target/target_core_tpg.h
index a521ae3..8326b8b 100644
--- a/include/target/target_core_tpg.h
+++ b/include/target/target_core_tpg.h
@@ -47,8 +47,10 @@ extern int core_tpg_del_initiator_node_acl(se_portal_group_t *,
 						se_node_acl_t *, int);
 extern int core_tpg_set_initiator_node_queue_depth(se_portal_group_t *,
 						unsigned char *, u32, int);
-extern se_portal_group_t *core_tpg_register(struct target_core_fabric_ops *,
-					void *, int);
+extern int core_tpg_register(struct target_core_fabric_ops *,
+					struct se_wwn_s *,
+					struct se_portal_group_s *, void *,
+					int);
 extern int core_tpg_deregister(struct se_portal_group_s *);
 extern se_lun_t *core_tpg_pre_addlun(se_portal_group_t *, u32);
 extern int core_tpg_post_addlun(se_portal_group_t *, se_lun_t *, int, u32,
-- 
1.5.6.5

