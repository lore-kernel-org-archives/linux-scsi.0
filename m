From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] [LIO-Target/ConfigFS]: Convert layout to use generic configfs struct config_item_types WIP
Date: Mon, 22 Feb 2010 17:04:12 -0800
Message-ID: <1266887052-3850-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the iSCSI target fabric module configfs code in iscsi_target_configfs.c
to use the new generic configfs infrastructure provied in target_core_fabric_configfs.c.  With this
patch iscsi_target_configfs.c no longer defines it's own static struct config_item_type's, and uses
the generic 'cits' hanging off struct target_fabric_configfs->tf_cit_tmpl.  The following changes in
iscsi_target_register_configfs() shows the adapted fabric API functions, and how local static
attribute structures are setup to hang off the generic fabric cits.

       /*
        * Setup function pointers for generic logic in target_core_fabric_configfs.c
        */
       fabric->tf_ops.fabric_make_wwn = &lio_target_call_coreaddtiqn;
       fabric->tf_ops.fabric_drop_wwn = &lio_target_call_coredeltiqn;
       fabric->tf_ops.fabric_make_tpg = &lio_target_tiqn_addtpg;
       fabric->tf_ops.fabric_drop_tpg = &lio_target_tiqn_deltpg;
       fabric->tf_ops.fabric_post_link = NULL;
       fabric->tf_ops.fabric_pre_unlink = NULL;
       fabric->tf_ops.fabric_make_np = &lio_target_call_addnptotpg;
       fabric->tf_ops.fabric_drop_np = &lio_target_call_delnpfromtpg;
       /*
        * Setup default attribute lists for various fabric->tf_cit_tmpl
        * sturct config_item_type's
        */
       TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = lio_target_wwn_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = lio_target_tpg_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = lio_target_tpg_attrib_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = lio_target_tpg_param_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = lio_target_portal_attrs;

So far with iscsi_target_mod, everything aside from /sys/kernel/config/target/iscsi/$TIQN/tpgt_$TPGT/acls/
has been converted to use struct target_fabric_configfs->tf_cit_tmpl and generic attribute
CONFIGFS_EATTR() macros from include/target/target_core_fabric_configfs.h.

The remaining code for NodeACL and MappedLUN struct config_item_type's in iscsi_target_configfs.c will
be made generic and moved to target_core_fabric_configfs.c.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target.c          |    4 +-
 drivers/target/lio-target/iscsi_target_configfs.c | 1010 +++------------------
 drivers/target/lio-target/iscsi_target_core.h     |   15 +-
 drivers/target/lio-target/iscsi_target_erl0.c     |    4 +-
 drivers/target/lio-target/iscsi_target_login.c    |   10 +-
 drivers/target/lio-target/iscsi_target_nego.c     |    2 +-
 drivers/target/lio-target/iscsi_target_tpg.c      |   39 +-
 drivers/target/lio-target/iscsi_target_version.h  |    2 +-
 8 files changed, 166 insertions(+), 920 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target.c b/drivers/target/lio-target/iscsi_target.c
index e052bc4..5521572 100644
--- a/drivers/target/lio-target/iscsi_target.c
+++ b/drivers/target/lio-target/iscsi_target.c
@@ -5123,7 +5123,7 @@ int iscsi_close_connection(
 int iscsi_close_session(iscsi_session_t *sess)
 {
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
-	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_portal_group_t *se_tpg = &tpg->tpg_se_tpg;
 
 	if (atomic_read(&sess->nconn)) {
 		printk(KERN_ERR "%d connection(s) still exist for iSCSI session"
@@ -5435,7 +5435,7 @@ void iscsi_stop_session(
 int iscsi_release_sessions_for_tpg(iscsi_portal_group_t *tpg, int force)
 {
 	iscsi_session_t *sess;
-	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_portal_group_t *se_tpg = &tpg->tpg_se_tpg;
 	se_session_t *se_sess, *se_sess_tmp;
 	int session_count = 0;
 
diff --git a/drivers/target/lio-target/iscsi_target_configfs.c b/drivers/target/lio-target/iscsi_target_configfs.c
index b2d21bf..ee078d8 100644
--- a/drivers/target/lio-target/iscsi_target_configfs.c
+++ b/drivers/target/lio-target/iscsi_target_configfs.c
@@ -4,10 +4,10 @@
  * This file contains the configfs implementation for iSCSI Target mode
  * from the LIO-Target Project.
  *
- * Copyright (c) 2008-2009 Rising Tide, Inc.
- * Copyright (c) 2008-2009 Linux-iSCSI.org
+ * Copyright (c) 2008, 2009, 2010 Rising Tide, Inc.
+ * Copyright (c) 2008, 2009, 2010 Linux-iSCSI.org
  *
- * Copyright (c) 2008-2009 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ * Copyright (c) 2008, 2009, 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -36,6 +36,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 #include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
@@ -89,22 +90,13 @@ iscsi_portal_group_t *lio_get_tpg_from_tpg_item(
 
 /* Start items for lio_target_portal_cit */
 
-static ssize_t lio_target_show_np_info(void *p, char *page)
-{
-	return 0;
-}
-
-static struct lio_target_configfs_attribute lio_target_attr_np_info = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "info",
-		    .ca_mode = S_IRUGO },
-	.show	= lio_target_show_np_info,
-	.store	= NULL,
-};
-
-static ssize_t lio_target_show_np_sctp(void *p, char *page)
+static ssize_t lio_target_np_show_sctp(
+	struct se_tpg_np_s *se_tpg_np,
+	char *page)
 {
-	iscsi_tpg_np_t *tpg_np = (iscsi_tpg_np_t *)p, *tpg_np_sctp;
+	struct iscsi_tpg_np_s *tpg_np = container_of(se_tpg_np,
+				struct iscsi_tpg_np_s, se_tpg_np);
+	struct iscsi_tpg_np_s *tpg_np_sctp;
 	ssize_t rb;
 
 	tpg_np_sctp = iscsi_tpg_locate_child_np(tpg_np, ISCSI_SCTP_TCP);
@@ -116,15 +108,18 @@ static ssize_t lio_target_show_np_sctp(void *p, char *page)
 	return rb;
 }
 
-static ssize_t lio_target_store_np_sctp(void *p, const char *page, size_t count)
+static ssize_t lio_target_np_store_sctp(
+	struct se_tpg_np_s *se_tpg_np,
+	const char *page,
+	size_t count)
 {
-	iscsi_np_t *np;
-	iscsi_portal_group_t *tpg;
-	iscsi_tpg_np_t *tpg_np = (iscsi_tpg_np_t *)p;
-	iscsi_tpg_np_t *tpg_np_sctp = NULL;
-	iscsi_tiqn_t *tiqn;
+	struct iscsi_np_s *np;
+	struct iscsi_portal_group_s *tpg;
+	struct iscsi_tpg_np_s *tpg_np = container_of(se_tpg_np,
+				struct iscsi_tpg_np_s, se_tpg_np);
+	struct iscsi_tpg_np_s *tpg_np_sctp = NULL;
+	struct iscsi_np_addr_s np_addr;
 	char *endptr;
-	iscsi_np_addr_t np_addr;
 	u32 op;
 	int ret;
 
@@ -140,9 +135,8 @@ static ssize_t lio_target_store_np_sctp(void *p, const char *page, size_t count)
 		return -EINVAL;
 	}
 
-	tpg = lio_get_tpg_from_tpg_item(
-			&tpg_np->tpg->tpg_se_tpg->tpg_group.cg_item, &tiqn);
-	if (!(tpg))
+	tpg = tpg_np->tpg;
+	if (iscsi_get_tpg(tpg) < 0)
 		return -EINVAL;
 
 	if (op) {
@@ -176,98 +170,32 @@ out:
 	return -EINVAL;
 }
 
-static struct lio_target_configfs_attribute lio_target_attr_np_sctp = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "sctp",
-		    .ca_mode = S_IRUGO | S_IWUSR },
-	.show	= lio_target_show_np_sctp,
-	.store	= lio_target_store_np_sctp,
-};
+TF_NP_BASE_ATTR(lio_target, sctp, S_IRUGO | S_IWUSR);
 
 static struct configfs_attribute *lio_target_portal_attrs[] = {
-	&lio_target_attr_np_info.attr,
-	&lio_target_attr_np_sctp.attr,
+	&lio_target_np_sctp.attr,
 	NULL,
 };
 
-static ssize_t lio_target_portal_show(
-	struct config_item *item,
-	struct configfs_attribute *attr,
-	char *page)
-{
-	iscsi_tpg_np_t *tpg_np = container_of(to_config_group(item),
-			iscsi_tpg_np_t, tpg_np_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->show))
-		return -EINVAL;
-
-	return lt_attr->show((void *)tpg_np, page);
-}
-
-static ssize_t lio_target_portal_store(
-	struct config_item *item,
-	struct configfs_attribute *attr,
-	const char *page,
-	size_t count)
-{
-	iscsi_tpg_np_t *tpg_np = container_of(to_config_group(item),
-			iscsi_tpg_np_t, tpg_np_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->store))
-		return -EINVAL;
-
-	 return lt_attr->store((void *)tpg_np, page, count);
-}
-
-static struct configfs_item_operations lio_target_portal_item_ops = {
-	.show_attribute		= lio_target_portal_show,
-	.store_attribute	= lio_target_portal_store,
-};
-
-static struct config_item_type lio_target_portal_cit = {
-	.ct_item_ops	= &lio_target_portal_item_ops,
-	.ct_attrs	= lio_target_portal_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* Stop items for lio_target_portal_cit */
 
 /* Start items for lio_target_np_cit */
 
 #define MAX_PORTAL_LEN		256
 
-static struct config_group *lio_target_call_addnptotpg(
+struct se_tpg_np_s *lio_target_call_addnptotpg(
+	struct se_portal_group_s *se_tpg,
 	struct config_group *group,
 	const char *name)
 {
 	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
 	iscsi_tpg_np_t *tpg_np;
-	struct config_item *np_ci, *tpg_ci, *tiqn_ci;
 	char *str, *str2, *end_ptr, *ip_str, *port_str;
 	iscsi_np_addr_t np_addr;
 	u32 ipv4 = 0;
+	int ret;
 	char buf[MAX_PORTAL_LEN];
 
-	np_ci = &group->cg_item;
-	if (!(np_ci)) {
-		printk(KERN_ERR "Unable to locate config_item np_ci\n");
-		return ERR_PTR(-EINVAL);
-	}
-	tpg_ci = &np_ci->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return ERR_PTR(-EINVAL);
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return ERR_PTR(-EINVAL);
-	}
 	if (strlen(name) > MAX_PORTAL_LEN) {
 		printk(KERN_ERR "strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
 			(int)strlen(name), MAX_PORTAL_LEN);
@@ -317,14 +245,15 @@ static struct config_group *lio_target_call_addnptotpg(
 		np_addr.np_ipv4 = htonl(ipv4);
 		np_addr.np_flags |= NPF_NET_IPV4;
 	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
+	tpg = container_of(se_tpg, struct iscsi_portal_group_s, tpg_se_tpg);
+	ret = iscsi_get_tpg(tpg);
+	if (ret < 0)
 		return ERR_PTR(-EINVAL);
 
 	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
-		" PORTAL: %s\n", config_item_name(tiqn_ci), tpg->tpgt, name);
-
+		" PORTAL: %s\n",
+		config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item),
+		tpg->tpgt, name);
 	/*
 	 * Assume ISCSI_TCP by default.  Other network portals for other
 	 * iSCSI fabrics:
@@ -343,57 +272,30 @@ static struct config_group *lio_target_call_addnptotpg(
 		iscsi_put_tpg(tpg);
 		return ERR_PTR(PTR_ERR(tpg_np));
 	}
-
-	config_group_init_type_name(&tpg_np->tpg_np_group, name,
-			&lio_target_portal_cit);
-
 	printk(KERN_INFO "LIO_Target_ConfigFS: addnptotpg done!\n");
 
 	iscsi_put_tpg(tpg);
-	return &tpg_np->tpg_np_group;
+	return &tpg_np->se_tpg_np;
 }
 
 static void lio_target_call_delnpfromtpg(
-	struct config_group *group,
-	struct config_item *item)
+	struct se_tpg_np_s *se_tpg_np)
 {
 	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
 	iscsi_tpg_np_t *tpg_np;
-	struct config_item *np_ci, *tpg_ci, *tiqn_ci;
+	struct se_portal_group_s *se_tpg;
 	int ret = 0;
 
-	np_ci = &group->cg_item;
-	if (!(np_ci)) {
-		printk(KERN_ERR "Unable to locate config_item np_ci\n");
-		return;
-	}
-	tpg_ci = &np_ci->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return;
-	}
-	tpg_np = container_of(to_config_group(item),
-			iscsi_tpg_np_t, tpg_np_group);
-	if (!(tpg_np)) {
-		printk(KERN_ERR "Unable to locate iscsi_tpg_np_t\n");
-		return;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
+	tpg_np = container_of(se_tpg_np, struct iscsi_tpg_np_s, se_tpg_np);
+	tpg = tpg_np->tpg;
+	ret = iscsi_get_tpg(tpg);
+	if (ret < 0)
 		return;
 
+	se_tpg = &tpg->tpg_se_tpg;
 	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
-		" PORTAL: %s\n", config_item_name(tiqn_ci), tpg->tpgt,
-		config_item_name(item));
-
-	config_item_put(item);
+		" PORTAL: %s\n", config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item),
+		tpg->tpgt, config_item_name(&se_tpg_np->tpg_np_group.cg_item));
 
 	ret = iscsi_tpg_del_network_portal(tpg, tpg_np);
 	if (ret < 0)
@@ -404,382 +306,8 @@ out:
 	iscsi_put_tpg(tpg);
 }
 
-static struct configfs_group_operations lio_target_np_group_ops = {
-	.make_group	= lio_target_call_addnptotpg,
-	.drop_item	= lio_target_call_delnpfromtpg,
-};
-
-static struct config_item_type lio_target_np_cit = {
-	.ct_item_ops	= NULL,
-	.ct_group_ops	= &lio_target_np_group_ops,
-	.ct_attrs	= NULL,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_np_cit */
 
-/* Start items for lio_target_port_cit */
-
-CONFIGFS_EATTR_STRUCT(lio_target_port, se_lun_s);
-#define LIO_PORT_ATTR(_name, _mode)					\
-static struct lio_target_port_attribute lio_target_port_##_name =	\
-	__CONFIGFS_EATTR(_name, _mode,					\
-	lio_target_port_show_attr_##_name,				\
-	lio_target_port_store_attr_##_name);
-
-#define LIO_PORT_ATTR_RO(_name, _mode)					\
-static struct lio_target_port_attribute lio_target_port_##_name =	\
-	__CONFIGFS_EATTR_RO(_name,					\
-	lio_target_port_show_attr_##_name);
-
-/*
- * alua_tg_pt_gp
- */
-static ssize_t lio_target_port_show_attr_alua_tg_pt_gp(
-	struct se_lun_s *lun,
-	char *page)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_show_tg_pt_gp_info(lun->lun_sep, page);
-}
-
-static ssize_t lio_target_port_store_attr_alua_tg_pt_gp(
-	struct se_lun_s *lun,
-	const char *page,
-	size_t count)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_store_tg_pt_gp_info(lun->lun_sep, page, count);
-}
-
-LIO_PORT_ATTR(alua_tg_pt_gp, S_IRUGO | S_IWUSR);
-
-/*
- * alua_tg_pt_offline
- */
-static ssize_t lio_target_port_show_attr_alua_tg_pt_offline(
-	struct se_lun_s *lun,
-	char *page)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_show_offline_bit(lun, page);
-}
-
-static ssize_t lio_target_port_store_attr_alua_tg_pt_offline(
-	struct se_lun_s *lun,
-	const char *page,
-	size_t count)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_store_offline_bit(lun, page, count);
-}
-
-LIO_PORT_ATTR(alua_tg_pt_offline, S_IRUGO | S_IWUSR);
-
-/*
- * alua_tg_pt_status
- */
-static ssize_t lio_target_port_show_attr_alua_tg_pt_status(
-	struct se_lun_s *lun,
-	char *page)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_show_secondary_status(lun, page);
-}
-
-static ssize_t lio_target_port_store_attr_alua_tg_pt_status(
-	struct se_lun_s *lun,
-	const char *page,
-	size_t count)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_store_secondary_status(lun, page, count);
-}
-
-LIO_PORT_ATTR(alua_tg_pt_status, S_IRUGO | S_IWUSR);
-
-/*
- * alua_tg_pt_write_md
- */
-static ssize_t lio_target_port_show_attr_alua_tg_pt_write_md(
-	struct se_lun_s *lun,
-	char *page)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_show_secondary_write_metadata(lun, page);
-}
-
-static ssize_t lio_target_port_store_attr_alua_tg_pt_write_md(
-	struct se_lun_s *lun,
-	const char *page,
-	size_t count)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_store_secondary_write_metadata(lun, page, count);
-}
-
-LIO_PORT_ATTR(alua_tg_pt_write_md, S_IRUGO | S_IWUSR);
-
-static struct configfs_attribute *lio_target_port_attrs[] = {
-	&lio_target_port_alua_tg_pt_gp.attr,
-	&lio_target_port_alua_tg_pt_offline.attr,
-	&lio_target_port_alua_tg_pt_status.attr,
-	&lio_target_port_alua_tg_pt_write_md.attr,
-	NULL,
-};
-
-CONFIGFS_EATTR_OPS(lio_target_port, se_lun_s, lun_group);
-
-static int lio_target_port_link(
-	struct config_item *lun_ci,
-	struct config_item *se_dev_ci)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_device_t *dev;
-	se_lun_t *lun = container_of(to_config_group(lun_ci),
-				se_lun_t, lun_group);
-	se_lun_t *lun_p;
-	se_subsystem_dev_t *se_dev = container_of(
-		to_config_group(se_dev_ci), se_subsystem_dev_t, se_dev_group);
-	struct config_item *tpg_ci, *tiqn_ci;
-	int ret = 0;
-
-	if (lun->lun_type_ptr != NULL) {
-		printk(KERN_ERR "Port Symlink already exists\n");
-		return -EEXIST;
-	}
-
-	tpg_ci = &lun_ci->ci_parent->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return -EINVAL;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return -EINVAL;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
-		return -EINVAL;
-
-	dev = se_dev->se_dev_ptr;
-	if (!(dev)) {
-		printk(KERN_ERR "Unable to locate se_device_t pointer from"
-			" %s\n", config_item_name(se_dev_ci));
-		ret = -ENODEV;
-		goto out;
-	}
-
-	lun_p = core_dev_add_lun(tpg->tpg_se_tpg, dev->se_hba, dev,
-			lun->unpacked_lun);
-	if ((IS_ERR(lun_p)) || !(lun_p)) {
-		printk(KERN_ERR "core_dev_add_lun() failed: %d\n", ret);
-		ret = -EINVAL;
-		goto out;
-	}
-	iscsi_put_tpg(tpg);
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: Created Port Symlink %s -> %s\n",
-		config_item_name(se_dev_ci), config_item_name(lun_ci));
-
-	return 0;
-out:
-	iscsi_put_tpg(tpg);
-	return ret;
-}
-
-static int lio_target_port_check_link(
-	struct config_item *lun_ci,
-	struct config_item *se_dev_ci)
-{
-	se_lun_t *lun = container_of(to_config_group(lun_ci),
-			se_lun_t, lun_group);
-
-	return atomic_read(&lun->lun_acl_count) ? -EPERM : 0;
-}
-
-static int lio_target_port_unlink(
-	struct config_item *lun_ci,
-	struct config_item *se_dev_ci)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_lun_t *lun = container_of(to_config_group(lun_ci),
-			se_lun_t, lun_group);
-	struct config_item *tpg_ci, *tiqn_ci;
-	int ret;
-
-	tpg_ci = &lun_ci->ci_parent->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return -EINVAL;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return -EINVAL;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
-		return -EINVAL;
-
-	ret = core_dev_del_lun(tpg->tpg_se_tpg, lun->unpacked_lun);
-	iscsi_put_tpg(tpg);
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: Removed Port Symlink %s -> %s\n",
-		config_item_name(se_dev_ci), config_item_name(lun_ci));
-
-	return 0;
-}
-
-static struct configfs_item_operations lio_target_port_item_ops = {
-	.release		= NULL,
-	.show_attribute		= lio_target_port_attr_show,
-	.store_attribute	= lio_target_port_attr_store,
-	.allow_link		= lio_target_port_link,
-	.check_link		= lio_target_port_check_link,
-	.drop_link		= lio_target_port_unlink,
-};
-
-static struct config_item_type lio_target_port_cit = {
-	.ct_item_ops		= &lio_target_port_item_ops,
-	.ct_attrs		= lio_target_port_attrs,
-	.ct_owner		= THIS_MODULE,
-};
-
-/* End items for lio_target_port_cit */
-
-/* Start items for lio_target_lun_cit */
-
-static struct config_group *lio_target_lun_make_group(
-	struct config_group *group,
-	const char *name)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_lun_t *lun_p;
-	struct config_item *lun_ci, *tpg_ci, *tiqn_ci;
-	char *str, *endptr;
-	u32 lun;
-
-	str = strstr(name, "_");
-	if (!(str)) {
-		printk(KERN_ERR "Unable to locate \'_\" in"
-				" \"lun_$LUN_NUMBER\"\n");
-		return NULL;
-	}
-	str++; /* Advance over _ delim.. */
-	lun = simple_strtoul(str, &endptr, 0);
-
-	lun_ci = &group->cg_item;
-	if (!(lun_ci)) {
-		printk(KERN_ERR "Unable to locate config_item lun_ci\n");
-		return NULL;
-	}
-	tpg_ci = &lun_ci->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return NULL;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return NULL;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
-		return NULL;
-
-	lun_p = core_get_lun_from_tpg(tpg->tpg_se_tpg, lun);
-	if (!(lun_p))
-		goto out;
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu LUN:"
-		" %u\n", config_item_name(tiqn_ci), tpg->tpgt, lun);
-
-	config_group_init_type_name(&lun_p->lun_group, name,
-			&lio_target_port_cit);
-
-	iscsi_put_tpg(tpg);
-	return &lun_p->lun_group;
-out:
-	iscsi_put_tpg(tpg);
-	return NULL;
-}
-
-static void lio_target_lun_drop_item(
-	struct config_group *group,
-	struct config_item *item)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_lun_t *lun = container_of(to_config_group(item),
-				se_lun_t, lun_group);
-	struct config_item *lun_ci, *tpg_ci, *tiqn_ci;
-
-	lun_ci = &group->cg_item;
-	if (!(lun_ci)) {
-		printk(KERN_ERR "Unable to locate config_item np_ci\n");
-		return;
-	}
-	tpg_ci = &lun_ci->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
-		return;
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s TPGT:"
-		" %hu LUN: %u\n", config_item_name(tiqn_ci), tpg->tpgt,
-		lun->unpacked_lun);
-
-	config_item_put(item);
-	iscsi_put_tpg(tpg);
-}
-
-static struct configfs_group_operations lio_target_lun_group_ops = {
-	.make_group	= lio_target_lun_make_group,
-	.drop_item	= lio_target_lun_drop_item,
-};
-
-static struct config_item_type lio_target_lun_cit = {
-	.ct_item_ops	= NULL,
-	.ct_group_ops	= &lio_target_lun_group_ops,
-	.ct_attrs	= NULL,
-	.ct_owner	= THIS_MODULE,
-};
-
-/* End items for lio_target_lun_cit */
-
 /* Start items for lio_target_nacl_attrib_cit */
 
 #define DEF_NACL_ATTRIB(name)						\
@@ -1196,7 +724,7 @@ static int lio_target_initiator_lacl_link(
 	 * This value is what the iSCSI Initiator actually sees the
 	 * iscsi/$IQN/$TPGT/lun/lun_* as on their iSCSI Initiator Ports.
 	 */
-	ret = core_dev_add_initiator_node_lun_acl(tpg->tpg_se_tpg, lacl,
+	ret = core_dev_add_initiator_node_lun_acl(&tpg->tpg_se_tpg, lacl,
 				lun->unpacked_lun, lun_access);
 	if (ret < 0)
 		goto out;
@@ -1256,7 +784,7 @@ static int lio_target_initiator_lacl_unlink(
 	if (!(tpg))
 		return -EINVAL;
 
-	ret = core_dev_del_initiator_node_lun_acl(tpg->tpg_se_tpg, lun, lacl);
+	ret = core_dev_del_initiator_node_lun_acl(&tpg->tpg_se_tpg, lun, lacl);
 	if (ret < 0)
 		goto out;
 
@@ -1404,7 +932,7 @@ static struct config_group *lio_target_initiator_lacl_make_group(
 	 */
 	mapped_lun = simple_strtoul(ptr, &endptr, 0);
 
-	lacl = core_dev_init_initiator_node_lun_acl(tpg->tpg_se_tpg,
+	lacl = core_dev_init_initiator_node_lun_acl(&tpg->tpg_se_tpg,
 			mapped_lun, config_item_name(acl_ci), &ret);
 	if (!(lacl))
 		goto out;
@@ -1466,7 +994,7 @@ static void lio_target_initiator_lacl_drop_item(
 
 	config_item_put(item);
 
-	core_dev_free_initiator_node_lun_acl(tpg->tpg_se_tpg, lacl);
+	core_dev_free_initiator_node_lun_acl(&tpg->tpg_se_tpg, lacl);
 	iscsi_put_tpg(tpg);
 }
 
@@ -1900,17 +1428,15 @@ static struct config_item_type lio_target_acl_cit = {
 
 #define DEF_TPG_ATTRIB(name)						\
 									\
-static ssize_t lio_target_show_tpg_attrib_##name(			\
-	struct iscsi_tpg_attrib_s *ta,					\
+static ssize_t iscsi_tpg_attrib_show_##name(				\
+	struct se_portal_group_s *se_tpg,				\
 	char *page)							\
 {									\
-	iscsi_portal_group_t *tpg;					\
-	iscsi_tiqn_t *tiqn;						\
+	iscsi_portal_group_t *tpg = container_of(se_tpg,		\
+			struct iscsi_portal_group_s, tpg_se_tpg);	\
 	ssize_t rb;							\
 									\
-	tpg = lio_get_tpg_from_tpg_item(				\
-			&ta->tpg->tpg_se_tpg->tpg_group.cg_item, &tiqn); \
-	if (!(tpg))							\
+	if (iscsi_get_tpg(tpg) < 0)					\
 		return -EINVAL;						\
 									\
 	rb = sprintf(page, "%u\n", ISCSI_TPG_ATTRIB(tpg)->name);	\
@@ -1918,20 +1444,18 @@ static ssize_t lio_target_show_tpg_attrib_##name(			\
 	return rb;							\
 }									\
 									\
-static ssize_t lio_target_store_tpg_attrib_##name(			\
-	struct iscsi_tpg_attrib_s *ta,					\
+static ssize_t iscsi_tpg_attrib_store_##name(				\
+	struct se_portal_group_s *se_tpg,				\
 	const char *page,						\
 	size_t count)							\
 {									\
-	iscsi_portal_group_t *tpg = ta->tpg;				\
-	iscsi_tiqn_t *tiqn;						\
+	iscsi_portal_group_t *tpg = container_of(se_tpg,		\
+			struct iscsi_portal_group_s, tpg_se_tpg);	\
 	char *endptr;							\
 	u32 val;							\
 	int ret;							\
 									\
-	tpg = lio_get_tpg_from_tpg_item(				\
-			&ta->tpg->tpg_se_tpg->tpg_group.cg_item, &tiqn); \
-	if (!(tpg))							\
+	if (iscsi_get_tpg(tpg) < 0)					\
 		return -EINVAL;						\
 									\
 	val = simple_strtoul(page, &endptr, 0);				\
@@ -1946,16 +1470,7 @@ out:									\
 	return ret;							\
 }
 
-/*
- * Define the iSCSI TPG attributes using hybrid wrappers from
- * include/linux/configfs.h
- */
-CONFIGFS_EATTR_STRUCT(iscsi_tpg_attrib, iscsi_tpg_attrib_s);
-#define TPG_ATTR(_name, _mode)						\
-static struct iscsi_tpg_attrib_attribute iscsi_tpg_attrib_##_name =	\
-	__CONFIGFS_EATTR(_name, _mode,					\
-		lio_target_show_tpg_attrib_##_name,			\
-		lio_target_store_tpg_attrib_##_name);
+#define TPG_ATTR(_name, _mode) TF_TPG_ATTRIB_ATTR(iscsi, _name, _mode);
 
 /*
  * Define iscsi_tpg_attrib_s_authentication
@@ -1998,12 +1513,6 @@ TPG_ATTR(demo_mode_write_protect, S_IRUGO | S_IWUSR);
 DEF_TPG_ATTRIB(prod_mode_write_protect);
 TPG_ATTR(prod_mode_write_protect, S_IRUGO | S_IWUSR);
 
-/*
- * Finally, define functions iscsi_tpg_attrib_s_attr_show() and
- * iscsi_tpg_attrib_s_attr_store() for lio_target_tpg_attrib_ops below..
- */
-CONFIGFS_EATTR_OPS(iscsi_tpg_attrib, iscsi_tpg_attrib_s, tpg_attrib_group);
-
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_authentication.attr,
 	&iscsi_tpg_attrib_login_timeout.attr,
@@ -2016,34 +1525,21 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	NULL,
 };
 
-static struct configfs_item_operations lio_target_tpg_attrib_ops = {
-	.show_attribute		= iscsi_tpg_attrib_attr_show,
-	.store_attribute	= iscsi_tpg_attrib_attr_store,
-};
-
-static struct config_item_type lio_target_tpg_attrib_cit = {
-	.ct_item_ops	= &lio_target_tpg_attrib_ops,
-	.ct_attrs	= lio_target_tpg_attrib_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_tpg_attrib_cit */
 
 /* Start items for lio_target_tpg_param_cit */
 
 #define DEF_TPG_PARAM(name)						\
-static ssize_t lio_target_show_tpg_param_##name(			\
-	struct iscsi_portal_group_s *tpg_p,				\
+static ssize_t iscsi_tpg_param_show_##name(				\
+	struct se_portal_group_s *se_tpg,				\
 	char *page)							\
 {									\
-	iscsi_portal_group_t *tpg;					\
-	iscsi_tiqn_t *tiqn;						\
+	iscsi_portal_group_t *tpg = container_of(se_tpg,		\
+			struct iscsi_portal_group_s, tpg_se_tpg);	\
 	iscsi_param_t *param;						\
 	ssize_t rb;							\
 									\
-	tpg = lio_get_tpg_from_tpg_item(				\
-			&tpg_p->tpg_se_tpg->tpg_group.cg_item, &tiqn);	\
-	if (!(tpg))							\
+	if (iscsi_get_tpg(tpg) < 0)					\
 		return -EINVAL;						\
 									\
 	param = iscsi_find_param_from_key(__stringify(name),		\
@@ -2057,13 +1553,13 @@ static ssize_t lio_target_show_tpg_param_##name(			\
 	iscsi_put_tpg(tpg);						\
 	return rb;							\
 }									\
-static ssize_t lio_target_store_tpg_param_##name(			\
-	struct iscsi_portal_group_s *tpg_p,				\
+static ssize_t iscsi_tpg_param_store_##name(				\
+	struct se_portal_group_s *se_tpg,				\
 	const char *page,						\
 	size_t count)							\
 {									\
-	iscsi_portal_group_t *tpg;					\
-	iscsi_tiqn_t *tiqn;						\
+	iscsi_portal_group_t *tpg = container_of(se_tpg,		\
+			struct iscsi_portal_group_s, tpg_se_tpg);	\
 	char *buf;							\
 	int ret;							\
 									\
@@ -2073,12 +1569,9 @@ static ssize_t lio_target_store_tpg_param_##name(			\
 	snprintf(buf, PAGE_SIZE, "%s=%s", __stringify(name), page);	\
 	buf[strlen(buf)-1] = '\0'; /* Kill newline */			\
 									\
-	tpg = lio_get_tpg_from_tpg_item(				\
-			&tpg_p->tpg_se_tpg->tpg_group.cg_item, &tiqn);	\
-	if (!(tpg)) {							\
-		kfree(buf);						\
+	if (iscsi_get_tpg(tpg) < 0)					\
 		return -EINVAL;						\
-	}								\
+									\
 	ret = iscsi_change_param_value(buf, SENDER_TARGET,		\
 				tpg->param_list, 1);			\
 	if (ret < 0)							\
@@ -2093,12 +1586,7 @@ out:									\
 	return -EINVAL;						\
 }
 
-CONFIGFS_EATTR_STRUCT(iscsi_tpg_param, iscsi_portal_group_s);
-#define TPG_PARAM_ATTR(_name, _mode)					\
-static struct iscsi_tpg_param_attribute iscsi_tpg_param_##_name =	\
-	__CONFIGFS_EATTR(_name, _mode,					\
-		lio_target_show_tpg_param_##_name,			\
-		lio_target_store_tpg_param_##_name)
+#define TPG_PARAM_ATTR(_name, _mode) TF_TPG_PARAM_ATTR(iscsi, _name, _mode);
 
 DEF_TPG_PARAM(AuthMethod);
 TPG_PARAM_ATTR(AuthMethod, S_IRUGO | S_IWUSR);
@@ -2160,8 +1648,6 @@ TPG_PARAM_ATTR(IFMarkInt, S_IRUGO | S_IWUSR);
 DEF_TPG_PARAM(OFMarkInt);
 TPG_PARAM_ATTR(OFMarkInt, S_IRUGO | S_IWUSR);
 
-CONFIGFS_EATTR_OPS(iscsi_tpg_param, iscsi_portal_group_s, tpg_param_group);
-
 static struct configfs_attribute *lio_target_tpg_param_attrs[] = {
 	&iscsi_tpg_param_AuthMethod.attr,
 	&iscsi_tpg_param_HeaderDigest.attr,
@@ -2186,44 +1672,16 @@ static struct configfs_attribute *lio_target_tpg_param_attrs[] = {
 	NULL,
 };
 
-static struct configfs_item_operations lio_target_tpg_param_ops = {
-	.show_attribute		= iscsi_tpg_param_attr_show,
-	.store_attribute	= iscsi_tpg_param_attr_store,
-};
-
-static struct config_item_type lio_target_tpg_param_cit = {
-	.ct_item_ops	= &lio_target_tpg_param_ops,
-	.ct_attrs	= lio_target_tpg_param_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_tpg_param_cit */
 
 /* Start items for lio_target_tpg_cit */
 
-static ssize_t lio_target_store_tpg_control(
-	void *p,
-	const char *page,
-	size_t count)
-{
-	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)p;
-
-	printk(KERN_INFO "lio_target_store_tpg_control(): tpg: %p %s\n",
-			tpg, page);
-	return count;
-}
-
-static struct lio_target_configfs_attribute lio_target_attr_tpg_control = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "control",
-		    .ca_mode = S_IWUSR },
-	.show	= NULL,
-	.store	= lio_target_store_tpg_control,
-};
-
-static ssize_t lio_target_show_tpg_enable(void *p, char *page)
+static ssize_t lio_target_tpg_show_enable(
+	struct se_portal_group_s *se_tpg,
+	char *page)
 {
-	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)p;
+	iscsi_portal_group_t *tpg = container_of(se_tpg,
+			struct iscsi_portal_group_s, tpg_se_tpg);
 	ssize_t len = 0;
 
 	spin_lock(&tpg->tpg_state_lock);
@@ -2234,14 +1692,13 @@ static ssize_t lio_target_show_tpg_enable(void *p, char *page)
 	return len;
 }
 
-static ssize_t lio_target_store_tpg_enable(
-	void *p,
+static ssize_t lio_target_tpg_store_enable(
+	struct se_portal_group_s *se_tpg,
 	const char *page,
 	size_t count)
 {
-	iscsi_portal_group_t *tpg_p = (iscsi_portal_group_t *)p, *tpg;
-	iscsi_tiqn_t *tiqn;
-	struct config_item *tpg_ci, *tiqn_ci;
+	iscsi_portal_group_t *tpg = container_of(se_tpg,
+			struct iscsi_portal_group_s, tpg_se_tpg);
 	char *endptr;
 	u32 op;
 	int ret = 0;
@@ -2252,20 +1709,8 @@ static ssize_t lio_target_store_tpg_enable(
 		return -EINVAL;
 	}
 
-	tpg_ci = &tpg_p->tpg_se_tpg->tpg_group.cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate tpg_ci\n");
-		return -EINVAL;
-	}
-
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return -EINVAL;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
+	ret = iscsi_get_tpg(tpg);
+	if (ret < 0)
 		return -EINVAL;
 
 	if (op) {
@@ -2288,113 +1733,29 @@ out:
 	return -EINVAL;
 }
 
-static struct lio_target_configfs_attribute lio_target_attr_tpg_enable = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "enable",
-		    .ca_mode = S_IRUGO | S_IWUSR },
-	.show	= lio_target_show_tpg_enable,
-	.store	= lio_target_store_tpg_enable,
-};
+TF_TPG_BASE_ATTR(lio_target, enable, S_IRUGO | S_IWUSR);
 
 static struct configfs_attribute *lio_target_tpg_attrs[] = {
-	&lio_target_attr_tpg_control.attr,
-	&lio_target_attr_tpg_enable.attr,
+	&lio_target_tpg_enable.attr,
 	NULL,
 };
 
-static void lio_target_tpg_release(struct config_item *item)
-{
-	se_portal_group_t *se_tpg = container_of(to_config_group(item),
-				se_portal_group_t, tpg_group);
-	struct config_group *tpg_cg;
-
-	if (!(se_tpg))
-		return;
-
-	tpg_cg = &se_tpg->tpg_group;
-	kfree(tpg_cg->default_groups);
-}
-
-static ssize_t lio_target_tpg_show(
-	struct config_item *item,
-	struct configfs_attribute *attr,
-	char *page)
-{
-	se_portal_group_t *se_tpg = container_of(
-			to_config_group(item), se_portal_group_t, tpg_group);
-	iscsi_portal_group_t *tpg =
-		(iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
-	struct lio_target_configfs_attribute *lt_attr = container_of(attr,
-			struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->show))
-		return -EINVAL;
-
-	return lt_attr->show((void *)tpg, page);
-}
-
-static ssize_t lio_target_tpg_store(
-	struct config_item *item,
-	struct configfs_attribute *attr,
-	const char *page,
-	size_t count)
-{
-	se_portal_group_t *se_tpg = container_of(
-			to_config_group(item), se_portal_group_t, tpg_group);
-	iscsi_portal_group_t *tpg =
-			(iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->store))
-		return -EINVAL;
-
-	return lt_attr->store((void *)tpg, page, count);
-}
-
-static struct configfs_item_operations lio_target_tpg_item_ops = {
-	.release		= lio_target_tpg_release,
-	.show_attribute		= lio_target_tpg_show,
-	.store_attribute	= lio_target_tpg_store,
-};
-
-static struct config_item_type lio_target_tpg_cit = {
-	.ct_item_ops	= &lio_target_tpg_item_ops,
-	.ct_attrs	= lio_target_tpg_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
-
 /* End items for lio_target_tpg_cit */
 
 /* Start items for lio_target_tiqn_cit */
 
-static struct config_group *lio_target_tiqn_addtpg(
+struct se_portal_group_s *lio_target_tiqn_addtpg(
+	struct se_wwn_s *wwn,
 	struct config_group *group,
 	const char *name)
 {
 	iscsi_portal_group_t *tpg;
 	iscsi_tiqn_t *tiqn;
-	iscsi_tpg_attrib_t *tattr;
-	struct config_group *tpg_cg;
-	struct config_item *tiqn_ci;
 	char *tpgt_str, *end_ptr;
 	int ret = 0;
 	unsigned short int tpgt;
 
-	tiqn_ci = &group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate valid group->cg_item"
-			" pointer\n");
-		return NULL;
-	}
-	printk(KERN_INFO "lio_target_tiqn_addtpg() parent name: %s\n",
-			config_item_name(tiqn_ci));
-	tiqn = container_of(to_config_group(tiqn_ci), iscsi_tiqn_t, tiqn_group);
-	if (!(tiqn)) {
-		printk(KERN_ERR "Unable to locate iscsi_tiqn_t\n");
-		return NULL;
-	}
+	tiqn = container_of(wwn, struct iscsi_tiqn_s, tiqn_wwn);
 	/*
 	 * Only tpgt_# directory groups can be created below
 	 * target/iscsi/iqn.superturodiskarry/
@@ -2412,116 +1773,34 @@ static struct config_group *lio_target_tiqn_addtpg(
 	if (!(tpg))
 		return NULL;
 
-	tpg->tpg_se_tpg = core_tpg_register(
-			&lio_target_fabric_configfs->tf_ops, (void *)tpg,
+	ret = core_tpg_register(
+			&lio_target_fabric_configfs->tf_ops,
+			wwn, &tpg->tpg_se_tpg, (void *)tpg,
 			TRANSPORT_TPG_TYPE_NORMAL);
-	if (IS_ERR(tpg->tpg_se_tpg))
+	if (ret < 0)
 		return NULL;
 
-	tpg_cg = &tpg->tpg_se_tpg->tpg_group;
-	/*
-	 * Create default configfs groups for iscsi_portal_group_t..
-	 */
-	tpg_cg->default_groups = kzalloc(sizeof(struct config_group) * 6,
-			GFP_KERNEL);
-	if (!(tpg_cg->default_groups))
-		goto out;
-
-	tattr = &tpg->tpg_attrib;
-
-	config_group_init_type_name(&tpg->tpg_np_group, "np",
-			&lio_target_np_cit);
-	config_group_init_type_name(&tpg->tpg_lun_group, "lun",
-			&lio_target_lun_cit);
-	config_group_init_type_name(&tpg->tpg_acl_group, "acls",
-			&lio_target_acl_cit);
-	config_group_init_type_name(&tpg->tpg_param_group, "param",
-			&lio_target_tpg_param_cit);
-	config_group_init_type_name(&tattr->tpg_attrib_group, "attrib",
-			&lio_target_tpg_attrib_cit);
-	tpg_cg->default_groups[0] = &tpg->tpg_np_group;
-	tpg_cg->default_groups[1] = &tpg->tpg_lun_group;
-	tpg_cg->default_groups[2] = &tpg->tpg_acl_group;
-	tpg_cg->default_groups[3] = &tpg->tpg_param_group;
-	tpg_cg->default_groups[4] = &tattr->tpg_attrib_group;
-	tpg_cg->default_groups[5] = NULL;
-
 	ret = iscsi_tpg_add_portal_group(tiqn, tpg);
 	if (ret != 0)
 		goto out;
 
 	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	config_group_init_type_name(tpg_cg, name, &lio_target_tpg_cit);
 	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> Allocated TPG: %s\n",
-			tpg_cg->cg_item.ci_name);
-
-	return tpg_cg;
+			name);	
+	return &tpg->tpg_se_tpg;
 out:
-	if (tpg->tpg_se_tpg)
-		core_tpg_deregister(tpg->tpg_se_tpg);
-	kfree(tpg_cg->default_groups);
+	core_tpg_deregister(&tpg->tpg_se_tpg);
 	kmem_cache_free(lio_tpg_cache, tpg);
 	return NULL;
 }
 
-static void lio_target_tiqn_deltpg(
-	struct config_group *group,
-	struct config_item *item)
+void lio_target_tiqn_deltpg(struct se_portal_group_s *se_tpg)
 {
-	se_portal_group_t *se_tpg;
 	iscsi_portal_group_t *tpg;
 	iscsi_tiqn_t *tiqn;
-	struct config_item *tiqn_ci, *df_item;
-	struct config_group *tpg_cg;
-	char *tpgt_str, *end_ptr;
-	int i;
-	unsigned short int tpgt;
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s\n",
-			config_item_name(item));
-	tiqn_ci = &group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate group_cg_item\n");
-		return;
-	}
-
-	tiqn = container_of(to_config_group(tiqn_ci), iscsi_tiqn_t, tiqn_group);
-	if (!(tiqn)) {
-		printk(KERN_ERR "Unable to locate iscsi_tiqn_t\n");
-		return;
-	}
-
-	tpgt_str = strstr(config_item_name(item), "tpgt_");
-	if (!(tpgt_str)) {
-		printk(KERN_ERR "Unable to locate \"tpgt_#\" directory"
-			" group\n");
-		return;
-	}
-	tpgt_str += 5; /* Skip ahead of "tpgt_" */
-	tpgt = (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
-
-	se_tpg = container_of(to_config_group(item), se_portal_group_t,
-				tpg_group);
-	if (!(se_tpg))
-		return;
-	tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
-
-	printk(KERN_INFO "lio_target_tiqn_deltpg() got container_of: TPGT:"
-			" %hu\n", tpg->tpgt);
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> calling"
-			" config_item_put()\n");
-	/*
-	 * Release the default groups the fabric module is using for
-	 * se_portal_group_t->tpg_group.
-	 */
-	tpg_cg = &tpg->tpg_se_tpg->tpg_group;
-	for (i = 0; tpg_cg->default_groups[i]; i++) {
-		df_item = &tpg_cg->default_groups[i]->cg_item;
-		tpg_cg->default_groups[i] = NULL;
-		config_item_put(df_item);
-	}
-
-	config_item_put(item);
+	tpg = container_of(se_tpg, struct iscsi_portal_group_s, tpg_se_tpg);
+	tiqn = tpg->tpg_tiqn;
 	/*
 	 * iscsi_tpg_del_portal_group() assumes force=1
 	 */
@@ -2529,25 +1808,12 @@ static void lio_target_tiqn_deltpg(
 	iscsi_tpg_del_portal_group(tiqn, tpg, 1);
 }
 
-static struct configfs_group_operations lio_target_tiqn_group_ops = {
-	.make_group	= &lio_target_tiqn_addtpg,
-	.drop_item	= &lio_target_tiqn_deltpg,
-};
-
-static struct config_item_type lio_target_tiqn_cit = {
-	.ct_item_ops	= NULL,
-	.ct_group_ops	= &lio_target_tiqn_group_ops,
-	.ct_attrs	= NULL,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_tiqn_cit */
 
 /* Start LIO-Target TIQN struct contig_item lio_target_cit */
 
-static ssize_t lio_target_attr_show(
-	struct config_item *item,
-	struct configfs_attribute *attr,
+static ssize_t lio_target_wwn_show_attr_lio_version(
+	struct target_fabric_configfs *tf,
 	char *page)
 {
 	return sprintf(page, "Linux-iSCSI.org Target "PYX_ISCSI_VERSION""
@@ -2555,72 +1821,43 @@ static ssize_t lio_target_attr_show(
 		utsname()->machine);
 }
 
-static struct configfs_item_operations lio_target_item_ops = {
-	.show_attribute = lio_target_attr_show,
-};
+TF_WWN_ATTR_RO(lio_target, lio_version);
 
-static struct configfs_attribute lio_target_item_attr_version = {
-	.ca_owner	= THIS_MODULE,
-	.ca_name	= "lio_version",
-	.ca_mode	= S_IRUGO,
+static struct configfs_attribute *lio_target_wwn_attrs[] = {
+	&lio_target_wwn_lio_version.attr,
+	NULL,
 };
 
-static struct config_group *lio_target_call_coreaddtiqn(
+struct se_wwn_s *lio_target_call_coreaddtiqn(
+	struct target_fabric_configfs *tf,
 	struct config_group *group,
 	const char *name)
 {
 	iscsi_tiqn_t *tiqn;
 	int ret = 0;
 
-	printk(KERN_INFO "lio_target_call_coreaddtiqn(): name: %s\n", name);
-
 	tiqn = core_add_tiqn((unsigned char *)name, &ret);
 	if (!(tiqn))
 		return NULL;
 
 	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	config_group_init_type_name(&tiqn->tiqn_group, tiqn->tiqn,
-			&lio_target_tiqn_cit);
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> Allocated Node: %s\n",
-			tiqn->tiqn_group.cg_item.ci_name);
-
-	return &tiqn->tiqn_group;
+	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
+			" %s\n", name);
+	return &tiqn->tiqn_wwn;
 }
 
-static void lio_target_call_coredeltiqn(
-	struct config_group *group,
-	struct config_item *item)
+void lio_target_call_coredeltiqn(
+	struct se_wwn_s *wwn)
 {
-	iscsi_tiqn_t *tiqn = container_of(to_config_group(item),
-				iscsi_tiqn_t, tiqn_group);
-
+	iscsi_tiqn_t *tiqn = container_of(wwn, iscsi_tiqn_t, tiqn_wwn);
+	
 	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s\n",
-			config_item_name(item));
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> calling"
-			" config_item_put()\n");
-	config_item_put(item);
+			tiqn->tiqn);
 	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> Releasing"
 			" core_del_tiqn()\n");
 	core_del_tiqn(tiqn);
 }
 
-static struct configfs_group_operations lio_target_group_ops = {
-	.make_group	= lio_target_call_coreaddtiqn,
-	.drop_item	= lio_target_call_coredeltiqn,
-};
-
-static struct configfs_attribute *lio_target_attrs[] = {
-	&lio_target_item_attr_version,
-	NULL,
-};
-
-static struct config_item_type lio_target_cit = {
-	.ct_item_ops	= &lio_target_item_ops,
-	.ct_group_ops	= &lio_target_group_ops,
-	.ct_attrs	= lio_target_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End LIO-Target TIQN struct contig_lio_target_cit */
 
 /* Start lio_target_discovery_auth_cit */
@@ -2751,8 +1988,7 @@ int iscsi_target_register_configfs(void)
 	int ret;
 
 	lio_target_fabric_configfs = NULL;
-
-	fabric = target_fabric_configfs_init(&lio_target_cit, "iscsi");
+	fabric = target_fabric_configfs_init(THIS_MODULE, "iscsi");
 	if (!(fabric)) {
 		printk(KERN_ERR "target_fabric_configfs_init() for"
 				" LIO-Target failed!\n");
@@ -2831,6 +2067,26 @@ int iscsi_target_register_configfs(void)
 	tf_cg->default_groups[0] =
 			&iscsi_global->discovery_auth.auth_attrib_group;
 	tf_cg->default_groups[1] = NULL;
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	fabric->tf_ops.fabric_make_wwn = &lio_target_call_coreaddtiqn;
+	fabric->tf_ops.fabric_drop_wwn = &lio_target_call_coredeltiqn;
+	fabric->tf_ops.fabric_make_tpg = &lio_target_tiqn_addtpg;
+	fabric->tf_ops.fabric_drop_tpg = &lio_target_tiqn_deltpg;
+	fabric->tf_ops.fabric_post_link	= NULL;
+	fabric->tf_ops.fabric_pre_unlink = NULL;
+	fabric->tf_ops.fabric_make_np = &lio_target_call_addnptotpg;
+	fabric->tf_ops.fabric_drop_np = &lio_target_call_delnpfromtpg;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 * sturct config_item_type's
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = lio_target_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = lio_target_tpg_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = lio_target_tpg_attrib_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = lio_target_tpg_param_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = lio_target_portal_attrs;
 
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index 712e4bf..1136c82 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -8,6 +8,8 @@
 #include <iscsi_linux_defs.h>
 #include <iscsi_target_version.h>	    /* get version definition */
 
+#include <target/target_core_base.h>
+
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
 #define ISCSI_MISC_IOVECS		5
 #define ISCSI_MAX_DATASN_MISSING_COUNT	16
@@ -771,7 +773,6 @@ typedef struct iscsi_tpg_attrib_s {
 	u32			prod_mode_write_protect;
 	u32			cache_core_nps;
 	struct iscsi_portal_group_s *tpg;
-	struct config_group	tpg_attrib_group;
 }  ____cacheline_aligned iscsi_tpg_attrib_t;
 
 typedef struct iscsi_np_ex_s {
@@ -822,7 +823,7 @@ typedef struct iscsi_tpg_np_s {
 	struct list_head	tpg_np_list;
 	struct list_head	tpg_np_child_list;
 	struct list_head	tpg_np_parent_list;
-	struct config_group	tpg_np_group;
+	struct se_tpg_np_s	se_tpg_np;
 	spinlock_t		tpg_np_parent_lock;
 } ____cacheline_aligned iscsi_tpg_np_t;
 
@@ -850,11 +851,7 @@ typedef struct iscsi_portal_group_s {
 	/* Spinlock for adding/removing Network Portals */
 	spinlock_t		tpg_np_lock;
 	spinlock_t		tpg_state_lock;
-	struct se_portal_group_s *tpg_se_tpg;
-	struct config_group	tpg_np_group;
-	struct config_group	tpg_lun_group;
-	struct config_group	tpg_acl_group;
-	struct config_group	tpg_param_group;
+	struct se_portal_group_s tpg_se_tpg;
 	struct semaphore	tpg_access_sem;
 	struct semaphore	np_login_sem;
 	iscsi_tpg_attrib_t	tpg_attrib;
@@ -873,7 +870,7 @@ typedef struct iscsi_portal_group_s {
 #define ISCSI_TPG_LUN(c, l)  ((iscsi_tpg_list_t *)(c)->tpg->tpg_lun_list_t[l])
 #define ISCSI_TPG_S(s)		((iscsi_portal_group_t *)(s)->tpg)
 #define ISCSI_TPG_ATTRIB(t)	(&(t)->tpg_attrib)
-#define SE_TPG(tpg)		((struct se_portal_group_s *)(tpg)->tpg_se_tpg)
+#define SE_TPG(tpg)		(&(tpg)->tpg_se_tpg)
 
 typedef struct iscsi_tiqn_s {
 	unsigned char		tiqn[ISCSI_TIQN_LEN];
@@ -887,7 +884,7 @@ typedef struct iscsi_tiqn_s {
 	atomic_t		tiqn_access_count;
 	spinlock_t		tiqn_state_lock;
 	spinlock_t		tiqn_tpg_lock;
-	struct config_group	tiqn_group;
+	struct se_wwn_s		tiqn_wwn;
 #ifdef SNMP_SUPPORT
 	u32			tiqn_index;
 	iscsi_sess_err_stats_t  sess_err_stats;
diff --git a/drivers/target/lio-target/iscsi_target_erl0.c b/drivers/target/lio-target/iscsi_target_erl0.c
index cbb1a96..d51b07f 100644
--- a/drivers/target/lio-target/iscsi_target_erl0.c
+++ b/drivers/target/lio-target/iscsi_target_erl0.c
@@ -818,7 +818,7 @@ static void iscsi_handle_time2retain_timeout(unsigned long data)
 {
 	iscsi_session_t *sess = (iscsi_session_t *) data;
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
-	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_portal_group_t *se_tpg = &tpg->tpg_se_tpg;
 
 	spin_lock_bh(&se_tpg->session_lock);
 	if (sess->time2retain_timer_flags & T2R_TF_STOP) {
@@ -898,7 +898,7 @@ extern void iscsi_start_time2retain_handler (iscsi_session_t *sess)
 extern int iscsi_stop_time2retain_timer(iscsi_session_t *sess)
 {
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
-	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_portal_group_t *se_tpg = &tpg->tpg_se_tpg;
 
 	if (sess->time2retain_timer_flags & T2R_TF_EXPIRED)
 		return -1;
diff --git a/drivers/target/lio-target/iscsi_target_login.c b/drivers/target/lio-target/iscsi_target_login.c
index f13a5cb..6e17f32 100644
--- a/drivers/target/lio-target/iscsi_target_login.c
+++ b/drivers/target/lio-target/iscsi_target_login.c
@@ -117,7 +117,7 @@ int iscsi_check_for_session_reinstatement(iscsi_conn_t *conn)
 	iscsi_param_t *initiatorname_param = NULL, *sessiontype_param = NULL;
 	iscsi_portal_group_t *tpg = conn->tpg;
 	iscsi_session_t *sess = NULL, *sess_p = NULL;
-	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_portal_group_t *se_tpg = &tpg->tpg_se_tpg;
 	se_session_t *se_sess, *se_sess_tmp;
 
 	initiatorname_param = iscsi_find_param_from_key(
@@ -412,7 +412,7 @@ static int iscsi_login_non_zero_tsih_s2(
 {
 	iscsi_portal_group_t *tpg = conn->tpg;
 	iscsi_session_t *sess = NULL, *sess_p = NULL;
-	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_portal_group_t *se_tpg = &tpg->tpg_se_tpg;
 	se_session_t *se_sess, *se_sess_tmp;
 	struct iscsi_init_login_cmnd *pdu = (struct iscsi_init_login_cmnd *)buf;
 
@@ -591,7 +591,7 @@ static int iscsi_post_login_handler(
 	iscsi_session_t *sess = SESS(conn);
 	se_session_t *se_sess = sess->se_sess;
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
-	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_portal_group_t *se_tpg = &tpg->tpg_se_tpg;
 	se_thread_set_t *ts;
 
 	iscsi_inc_conn_usage_count(conn);
@@ -668,7 +668,7 @@ static int iscsi_post_login_handler(
 	iscsi_determine_maxcmdsn(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-	__transport_register_session(sess->tpg->tpg_se_tpg,
+	__transport_register_session(&sess->tpg->tpg_se_tpg,
 			se_sess->se_node_acl, se_sess, (void *)sess);
 	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 	sess->session_state = TARG_SESS_STATE_LOGGED_IN;
@@ -1285,7 +1285,7 @@ old_sess_out:
 		spin_lock_bh(&SESS(conn)->conn_lock);
 		if (SESS(conn)->session_state == TARG_SESS_STATE_FAILED) {
 			se_portal_group_t *se_tpg =
-					ISCSI_TPG_C(conn)->tpg_se_tpg;
+					&ISCSI_TPG_C(conn)->tpg_se_tpg;
 
 			atomic_set(&SESS(conn)->session_continuation, 0);
 			spin_unlock_bh(&SESS(conn)->conn_lock);
diff --git a/drivers/target/lio-target/iscsi_target_nego.c b/drivers/target/lio-target/iscsi_target_nego.c
index 4ea7bcf..36cc600 100644
--- a/drivers/target/lio-target/iscsi_target_nego.c
+++ b/drivers/target/lio-target/iscsi_target_nego.c
@@ -845,7 +845,7 @@ get_target:
 	 * Locate incoming Initiator IQN reference from Storage Node.
 	 */
 	sess->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-			conn->tpg->tpg_se_tpg, i_buf);
+			&conn->tpg->tpg_se_tpg, i_buf);
 	if (!(sess->se_sess->se_node_acl)) {
 		printk(KERN_ERR "iSCSI Initiator Node: %s is not authorized to"
 			" access iSCSI target portal group: %hu.\n",
diff --git a/drivers/target/lio-target/iscsi_target_tpg.c b/drivers/target/lio-target/iscsi_target_tpg.c
index 59eab6b..130c090 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.c
+++ b/drivers/target/lio-target/iscsi_target_tpg.c
@@ -465,7 +465,6 @@ iscsi_portal_group_t *core_alloc_portal_group(iscsi_tiqn_t *tiqn, u16 tpgt)
 	init_MUTEX(&tpg->np_login_sem);
 	spin_lock_init(&tpg->tpg_state_lock);
 	spin_lock_init(&tpg->tpg_np_lock);
-	tpg->sid        = 1; /* First Assigned LIO-Target Session ID */
 
 	return tpg;
 }
@@ -476,6 +475,7 @@ int core_load_discovery_tpg(void)
 {
 	iscsi_param_t *param;
 	iscsi_portal_group_t *tpg;
+	int ret;
 
 	tpg = core_alloc_portal_group(NULL, 1);
 	if (!(tpg)) {
@@ -483,23 +483,16 @@ int core_load_discovery_tpg(void)
 		return -1;
 	}
 
-	tpg->tpg_se_tpg = core_tpg_register(
-			&lio_target_fabric_configfs->tf_ops, (void *)tpg,
+	ret = core_tpg_register(
+			&lio_target_fabric_configfs->tf_ops,
+			NULL, &tpg->tpg_se_tpg, (void *)tpg,
 			TRANSPORT_TPG_TYPE_DISCOVERY);
-	if (IS_ERR(tpg->tpg_se_tpg)) {
+	if (ret < 0) {
 		kfree(tpg);
 		return -1;
 	}
 
-	tpg->sid        = 1; /* First Assigned LIO Session ID */
-	INIT_LIST_HEAD(&tpg->tpg_gnp_list);
-	INIT_LIST_HEAD(&tpg->g_tpg_list);
-	INIT_LIST_HEAD(&tpg->tpg_list);
-	init_MUTEX(&tpg->tpg_access_sem);
-	init_MUTEX(&tpg->np_login_sem);
-	spin_lock_init(&tpg->tpg_state_lock);
-	spin_lock_init(&tpg->tpg_np_lock);
-
+	tpg->sid = 1; /* First Assigned LIO Session ID */
 	iscsi_set_default_tpg_attribs(tpg);
 
 	if (iscsi_create_default_params(&tpg->param_list) < 0)
@@ -528,8 +521,8 @@ int core_load_discovery_tpg(void)
 
 	return 0;
 out:
-	if (tpg->tpg_se_tpg)
-		core_tpg_deregister(tpg->tpg_se_tpg);
+	if (tpg->sid == 1)
+		core_tpg_deregister(&tpg->tpg_se_tpg);
 	kfree(tpg);
 	return -1;
 }
@@ -541,7 +534,7 @@ void core_release_discovery_tpg(void)
 	if (!(tpg))
 		return;
 
-	core_tpg_deregister(tpg->tpg_se_tpg);
+	core_tpg_deregister(&tpg->tpg_se_tpg);
 
 	kmem_cache_free(lio_tpg_cache, tpg);
 	iscsi_global->discovery_tpg = NULL;
@@ -774,9 +767,9 @@ int iscsi_tpg_del_portal_group(
 		return -EPERM;
 	}
 
-	core_tpg_clear_object_luns(tpg->tpg_se_tpg);
+	core_tpg_clear_object_luns(&tpg->tpg_se_tpg);
 	iscsi_tpg_free_network_portals(tpg);
-	core_tpg_free_node_acls(tpg->tpg_se_tpg);
+	core_tpg_free_node_acls(&tpg->tpg_se_tpg);
 
 	spin_lock_bh(&iscsi_global->g_tpg_lock);
 	list_del(&tpg->g_tpg_list);
@@ -787,8 +780,8 @@ int iscsi_tpg_del_portal_group(
 		tpg->param_list = NULL;
 	}
 
-	core_tpg_deregister(tpg->tpg_se_tpg);
-	tpg->tpg_se_tpg = NULL;
+	core_tpg_deregister(&tpg->tpg_se_tpg);
+//	tpg->tpg_se_tpg = NULL;
 
 	spin_lock(&tpg->tpg_state_lock);
 	tpg->tpg_state = TPG_STATE_FREE;
@@ -908,7 +901,7 @@ iscsi_node_acl_t *iscsi_tpg_add_initiator_node_acl(
 {
 	se_node_acl_t *se_nacl;
 
-	se_nacl = core_tpg_add_initiator_node_acl(tpg->tpg_se_tpg,
+	se_nacl = core_tpg_add_initiator_node_acl(&tpg->tpg_se_tpg,
 			initiatorname, queue_depth);
 	if ((IS_ERR(se_nacl)) || !(se_nacl))
 		return NULL;
@@ -927,7 +920,7 @@ void iscsi_tpg_del_initiator_node_acl(
 	/*
 	 * TPG_TFO(tpg)->tpg_release_acl() will kfree the iscsi_node_acl_t..
 	 */
-	core_tpg_del_initiator_node_acl(tpg->tpg_se_tpg, se_nacl, 1);
+	core_tpg_del_initiator_node_acl(&tpg->tpg_se_tpg, se_nacl, 1);
 }
 
 iscsi_node_attrib_t *iscsi_tpg_get_node_attrib(
@@ -1151,7 +1144,7 @@ int iscsi_tpg_set_initiator_node_queue_depth(
 	u32 queue_depth,
 	int force)
 {
-	return core_tpg_set_initiator_node_queue_depth(tpg->tpg_se_tpg,
+	return core_tpg_set_initiator_node_queue_depth(&tpg->tpg_se_tpg,
 		initiatorname, queue_depth, force);
 }
 
diff --git a/drivers/target/lio-target/iscsi_target_version.h b/drivers/target/lio-target/iscsi_target_version.h
index dac9b3f..c80f341 100644
--- a/drivers/target/lio-target/iscsi_target_version.h
+++ b/drivers/target/lio-target/iscsi_target_version.h
@@ -1,6 +1,6 @@
 #ifndef ISCSI_TARGET_VERSION_H
 #define ISCSI_TARGET_VERSION_H
 
-#define PYX_ISCSI_VERSION		"v3.2.2"
+#define PYX_ISCSI_VERSION		"v3.9.8"
 
 #endif   /*** ISCSI_TARGET_VERSION_H ***/
-- 
1.5.6.5

