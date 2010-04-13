From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [TCM-FC/ConfigFS]: Convert layout to use generic configfs struct config_item_types
Date: Tue, 13 Apr 2010 05:15:42 -0700
Message-ID: <1271160942-17968-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:47975 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751099Ab0DMMDi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 08:03:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Open-FCoE devel <devel@open-fcoe.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.co>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings SCSI and Open-FCoE.org folks,

Attached is a patch to lio-core-2.6.git/lio-4.0 to convert the TCM-FC / Open-FCoE.org fabric
code in drivers/target/tcm_fc/tfc_conf.c to TCM 4.0 using the new fabric independent configfs
infrastructure in drivers/target/target_core_fabric_configfs.c.

Information about the TCM 4.0 configfs code can be found here along with links to the
two previous patch series implementing core 4.0 functionalty and conversion of existing
LIO-Target and TCM_Loop fabric modules to use the new infrastructure.

http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/f3391e9bb0fefcd9

With this patch tfc_conf.c no longer defines it's own static struct config_item_type's, and uses
the generic 'cits' hanging off struct target_fabric_configfs->tf_cit_tmpl.  The following changes in
struct ft_fabric_ops and ft_register_configfs() shows the adapted fabric API functions, and how
local static attribute structures are setup to hang off the generic fabric cits..

>From struct target_core_fabric_ops ft_fabric_ops:

       /*
        * Setup function pointers for generic logic in target_core_fabric_configfs.c
        */
       .fabric_make_wwn =              &ft_add_lport,
       .fabric_drop_wwn =              &ft_del_lport,
       .fabric_make_tpg =              &ft_add_tpg,
       .fabric_drop_tpg =              &ft_del_tpg,
       .fabric_post_link =             NULL,
       .fabric_pre_unlink =            NULL,
       .fabric_make_np =               NULL,
       .fabric_drop_np =               NULL,
       .fabric_make_nodeacl =          &ft_add_acl,
       .fabric_drop_nodeacl =          &ft_del_acl,

 and from ft_register_configfs()

       /*
        * Setup default attribute lists for various fabric->tf_cit_tmpl
        */
       TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = ft_wwn_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = ft_nacl_base_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;

The existing TCM_FC fabric layout of /sys/kernel/config/target/fc/$LPORT_WWN/tpgt_$TPGT
is up and running with this patch.  Here is how it looks using TCM v4.0 fabric independent
configfs infrastructure:

target:~# tree /sys/kernel/config/target/fc/
	/sys/kernel/config/target/fc/
	|-- 20:00:00:0c:29:43:d5:7b
	|   `-- tpgt_1
	|       |-- acls
	|       |   `-- 20:00:00:0c:29:43:d5:ff
	|       |       |-- attrib
	|       |       |-- auth
	|       |       |-- node_name
	|       |       |-- param
	|       |       `-- port_name
	|       |-- attrib
	|       |-- lun
	|       |   `-- lun_0
	|       |       |-- alua_tg_pt_gp
	|       |       |-- alua_tg_pt_offline
	|       |       |-- alua_tg_pt_status
	|       |       |-- alua_tg_pt_write_md
	|       |       `-- tcm_fc_port -> ../../../../../../target/core/iblock_0/lvm_test0
	|       |-- np
	|       `-- param
	|-- discovery_auth
	`-- version

target:~# dmesg  | tail -n 15
<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
Initialized struct target_fabric_configfs: c895a850 for fc
<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
Target_Core_ConfigFS: REGISTER -> group: e121cb80 name: fc
Target_Core_ConfigFS: REGISTER -> Located fabric: fc
Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> c895a9f8
Target_Core_ConfigFS: REGISTER -> Allocated Fabric: fc
Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for fc
tcm_fc: ft_add_lport: add lport 20:00:00:0c:29:43:d5:7b
tcm_fc: ft_add_tpg: tcm_fc: add tpg tpgt_1
TARGET_CORE[fc]: Allocated Normal se_portal_group_t for endpoint: 20:00:00:0c:29:43:d5:7b, Portal Tag: 1
tcm_fc: ft_add_acl: add acl 20:00:00:0c:29:43:d5:ff
fc_TPG[1] - Added ACL with TCQ Depth: 32 for fc Initiator Node: 20:00:00:0c:29:43:d5:ff
iblock/fc: Adding to default ALUA Target Port Group: alua/default_tg_pt_gp
fc_TPG[1]_LUN[0] - Activated fc Logical Unit from CORE HBA: 4

target:~# cat /sys/kernel/config/target/fc/version
TCM FC 0.2 on Linux/i686 on 2.6.34-rc3
target:~# lsmod
Module                  Size  Used by
tcm_fc                 16300  5
libfc                  70996  1 tcm_fc
target_core_mod       247964  30 tcm_fc
scsi_tgt                8646  1 target_core_mod
configfs               20504  2 target_core_mod

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tcm_fc.h   |   13 +-
 drivers/target/tcm_fc/tfc_conf.c |  784 +++++++-------------------------------
 drivers/target/tcm_fc/tfc_sess.c |    3 +-
 3 files changed, 134 insertions(+), 666 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index bef518c..f7400e9 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -104,10 +104,7 @@ struct ft_node_auth {
  */
 struct ft_node_acl {
 	struct ft_node_auth node_auth;
-	struct se_node_acl_s *se_node_acl;
-
-	struct config_group auth_group;
-	struct config_group *groups[2];	/* NULL-terminator pointers to above */
+	struct se_node_acl_s se_node_acl;
 };
 
 struct ft_lun {
@@ -124,11 +121,7 @@ struct ft_tpg {
 	struct ft_tport *tport;		/* active tport or NULL */
 	struct list_head list;		/* linkage in ft_lport_acl tpg_list */
 	struct list_head lun_list;	/* head of LUNs */
-	struct se_portal_group_s *se_tpg;
-	struct config_group lun_group;	/* lun subdir */
-	struct config_group acl_group;	/* acl subdir */
-	struct config_group *groups[3];	/* pointers to subdirs, NULL-term */
-
+	struct se_portal_group_s se_tpg;
 	struct task_struct *thread;	/* processing thread */
 	struct se_queue_obj_s qobj;	/* queue for processing thread */
 };
@@ -138,7 +131,7 @@ struct ft_lport_acl {
 	char name[FT_NAMELEN];
 	struct list_head list;
 	struct list_head tpg_list;
-	struct config_group group;
+	struct se_wwn_s fc_lport_wwn;
 };
 
 enum ft_cmd_state {
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index ca6a2c5..5608e3c 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -43,6 +43,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 #include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
@@ -63,58 +64,6 @@ module_param_named(debug_logging, ft_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
 /*
- * Configfs infrastructure, possibly.
- */
-struct ft_attr {
-	struct configfs_attribute attr;
-	u32	offset;		/* offset of attribute value in parent struct */
-	void *(*obj_from_item)(struct config_item *);
-	ssize_t	(*show)(void *, char *);
-	ssize_t	(*store)(void *, const char *, size_t);
-};
-
-static ssize_t ft_show_item(struct config_item *item,
-			    struct configfs_attribute *attr, char *buf)
-{
-	struct ft_attr *ft_attr;
-	void *ptr;
-
-	ft_attr = container_of(attr, struct ft_attr, attr);
-	ptr = ft_attr->obj_from_item(item) + ft_attr->offset;
-	return ft_attr->show(ptr, buf);
-}
-
-static ssize_t ft_store_item(struct config_item *item,
-			     struct configfs_attribute *attr,
-			     const char *buf, size_t len)
-{
-	struct ft_attr *ft_attr;
-	void *ptr;
-
-	ft_attr = container_of(attr, struct ft_attr, attr);
-	ptr = ft_attr->obj_from_item(item) + ft_attr->offset;
-	return ft_attr->store(ptr, buf, len);
-}
-
-static struct configfs_item_operations ft_item_ops = {
-	.show_attribute = ft_show_item,
-	.store_attribute = ft_store_item,
-};
-
-#define FT_ATTR(_name, _type, _field, _mode, _find, _show, _store)	\
-	{								\
-		.attr = {						\
-			.ca_name = (_name),				\
-			.ca_mode = (_mode),				\
-			.ca_owner = THIS_MODULE,			\
-		},							\
-		.offset = offsetof(struct _type, _field),		\
-		.obj_from_item = (_find),				\
-		.show = (_show),					\
-		.store = (_store),					\
-	}
-
-/*
  * Parse WWN.
  * If strict, we require lower-case hex and colon separators to be sure
  * the name is the same as what would be generated by ft_format_wwn()
@@ -195,488 +144,61 @@ static ssize_t ft_wwn_store(void *arg, const char *buf, size_t len)
 }
 
 /*
- * Target port LUN port ops.
- */
-
-static struct ft_tpg *ft_tpg_from_lun_ci(struct config_item *lun_ci)
-{
-	struct config_item *tpg_ci;
-	struct se_portal_group_s *se_tpg;
-
-	tpg_ci = &lun_ci->ci_parent->ci_group->cg_item;
-	se_tpg = container_of(to_config_group(tpg_ci),
-			      struct se_portal_group_s, tpg_group);
-	return se_tpg->se_tpg_fabric_ptr;
-}
-
-/*
- * For ALUA Target port attributes for port LUN
- */
-CONFIGFS_EATTR_STRUCT(ft_lun_port, se_lun_s);
-#define FT_PORT_ATTR(_name, _mode)					\
-static struct ft_lun_port_attribute ft_lun_port_##_name =		\
-	__CONFIGFS_EATTR(_name, _mode,					\
-	ft_lun_port_show_attr_##_name,					\
-	ft_lun_port_store_attr_##_name);
-
-/*
- * alua_tg_pt_gp
- */
-static ssize_t ft_lun_port_show_attr_alua_tg_pt_gp(
-	struct se_lun_s *lun,
-	char *page)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
-	
-	return core_alua_show_tg_pt_gp_info(lun->lun_sep, page);
-}
-
-static ssize_t ft_lun_port_store_attr_alua_tg_pt_gp(
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
-FT_PORT_ATTR(alua_tg_pt_gp, S_IRUGO | S_IWUSR);
-
-/*
- * alua_tg_pt_offline
+ * ACL auth ops.
  */
-static ssize_t ft_lun_port_show_attr_alua_tg_pt_offline(
-	struct se_lun_s *lun,
-	char *page)
-{
-	if (!(lun->lun_sep))
-		return -ENODEV;
 
-	return core_alua_show_offline_bit(lun, page);
-}
-
-static ssize_t ft_lun_port_store_attr_alua_tg_pt_offline(
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
-FT_PORT_ATTR(alua_tg_pt_offline, S_IRUGO | S_IWUSR);
-
-/*
- * alua_tg_pt_status
- */
-static ssize_t ft_lun_port_show_attr_alua_tg_pt_status(
-	struct se_lun_s *lun,
+static ssize_t ft_nacl_show_port_name(
+	struct se_node_acl_s *se_nacl,
 	char *page)
 {
-	if (!(lun->lun_sep))
-		return -ENODEV;
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
 
-	return core_alua_show_secondary_status(lun, page);
+	return ft_wwn_show(&acl->node_auth.port_name, page);
 }
 
-static ssize_t ft_lun_port_store_attr_alua_tg_pt_status(
-	struct se_lun_s *lun,
+static ssize_t ft_nacl_store_port_name(
+	struct se_node_acl_s *se_nacl,
 	const char *page,
 	size_t count)
 {
-	if (!(lun->lun_sep))
-		return -ENODEV;
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
 
-	return core_alua_store_secondary_status(lun, page, count);
+	return ft_wwn_store(&acl->node_auth.port_name, page, count);
 }
 
-FT_PORT_ATTR(alua_tg_pt_status, S_IRUGO | S_IWUSR);
+TF_NACL_BASE_ATTR(ft, port_name, S_IRUGO | S_IWUSR);
 
-/*
- * alua_tg_pt_write_md
- */
-static ssize_t ft_lun_port_show_attr_alua_tg_pt_write_md(
-	struct se_lun_s *lun,
+static ssize_t ft_nacl_show_node_name(
+	struct se_node_acl_s *se_nacl,
 	char *page)
 {
-	if (!(lun->lun_sep))
-		return -ENODEV;
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
 
-	return core_alua_show_secondary_write_metadata(lun, page);
+	return ft_wwn_show(&acl->node_auth.node_name, page);
 }
 
-static ssize_t ft_lun_port_store_attr_alua_tg_pt_write_md(
-	struct se_lun_s *lun,
+static ssize_t ft_nacl_store_node_name(
+	struct se_node_acl_s *se_nacl,
 	const char *page,
 	size_t count)
 {
-	if (!(lun->lun_sep))
-		return -ENODEV;
-
-	return core_alua_store_secondary_write_metadata(lun, page, count);
-}
-
-FT_PORT_ATTR(alua_tg_pt_write_md, S_IRUGO | S_IWUSR);
-
-static struct configfs_attribute *ft_lun_port_attrs[] = {
-	&ft_lun_port_alua_tg_pt_gp.attr,
-	&ft_lun_port_alua_tg_pt_offline.attr,
-	&ft_lun_port_alua_tg_pt_status.attr,
-	&ft_lun_port_alua_tg_pt_write_md.attr,
-	NULL,
-};
-
-CONFIGFS_EATTR_OPS(ft_lun_port, se_lun_s, lun_group);
-
-static int ft_lun_port_link(struct config_item *lun_ci,
-			    struct config_item *se_dev_ci)
-{
-	struct ft_tpg *tpg;
-	se_device_t *dev;
-	se_lun_t *lun = container_of(to_config_group(lun_ci),
-				se_lun_t, lun_group);
-	se_lun_t *lun_p;
-	se_subsystem_dev_t *se_dev = container_of(
-		to_config_group(se_dev_ci), se_subsystem_dev_t, se_dev_group);
-
-	if (lun->lun_type_ptr != NULL) {
-		FT_CONF_DBG("Port Symlink already exists\n");
-		return -EEXIST;
-	}
-
-	tpg = ft_tpg_from_lun_ci(lun_ci);
-	if (!tpg)
-		return -EINVAL;
-
-	dev = se_dev->se_dev_ptr;
-	if (!dev) {
-		FT_CONF_DBG("Unable to locate se_device_t pointer from %s\n",
-			    config_item_name(se_dev_ci));
-		return -ENODEV;
-	}
-
-	lun_p = core_dev_add_lun(tpg->se_tpg, dev->se_hba, dev,
-				 lun->unpacked_lun);
-	if (IS_ERR(lun_p) || !lun_p) {
-		FT_CONF_DBG("core_dev_add_lun() failed: %ld\n", PTR_ERR(lun_p));
-		return -EINVAL;
-	}
-
-	FT_CONF_DBG("Created Port Symlink %s -> %s\n",
-		    config_item_name(se_dev_ci), config_item_name(lun_ci));
-	return 0;
-}
-
-static int ft_lun_port_check_link(struct config_item *lun_ci,
-				  struct config_item *se_dev_ci)
-{
-	se_lun_t *lun = container_of(to_config_group(lun_ci),
-			se_lun_t, lun_group);
-
-	return atomic_read(&lun->lun_acl_count) ? -EPERM : 0;
-}
-
-static int ft_lun_port_unlink(struct config_item *lun_ci,
-			      struct config_item *se_dev_ci)
-{
-	struct ft_tpg *tpg;
-	se_lun_t *lun = container_of(to_config_group(lun_ci),
-			se_lun_t, lun_group);
-	int ret;
-
-	tpg = ft_tpg_from_lun_ci(lun_ci);
-	if (!tpg)
-		return -EINVAL;
-
-	ret = core_dev_del_lun(tpg->se_tpg, lun->unpacked_lun);
-
-	FT_CONF_DBG("Removed Port Symlink %s -> %s\n",
-		config_item_name(se_dev_ci), config_item_name(lun_ci));
-	return ret;
-}
-
-static struct configfs_item_operations ft_lun_port_item_ops = {
-	.show_attribute = ft_lun_port_attr_show,
-	.store_attribute = ft_lun_port_attr_store,
-	.allow_link = ft_lun_port_link,
-	.check_link = ft_lun_port_check_link,
-	.drop_link = ft_lun_port_unlink,
-};
-
-static struct config_item_type ft_lun_port_cit = {
-	.ct_item_ops = &ft_lun_port_item_ops,
-	.ct_attrs = ft_lun_port_attrs,
-	.ct_owner = THIS_MODULE,
-};
-
-/*
- * LUN ops.
- */
-
-static struct config_group *ft_add_lun(struct config_group *group,
-				       const char *name)
-{
-	struct se_lun_s *lun;
-	struct ft_tpg *tpg;
-	unsigned long index;
-
-	FT_CONF_DBG("add lun %s\n", name);
-
-	/*
-	 * Name must be "lun_" followed by the index.
-	 */
-	if (strstr(name, "lun_") != name)
-		return NULL;
-
-	if (strict_strtoul(name + 4, 10, &index) || index > UINT_MAX)
-		return NULL;
-
-	tpg = container_of(group, struct ft_tpg, lun_group);
-	lun = core_get_lun_from_tpg(tpg->se_tpg, index);
-	if (!lun)
-		return NULL;
-	config_group_init_type_name(&lun->lun_group, name, &ft_lun_port_cit);
-	return &lun->lun_group;
-}
-
-static void ft_del_lun(struct config_group *group, struct config_item *item)
-{
-	FT_CONF_DBG("del lun %s p %p\n", config_item_name(item), item);
-	config_item_put(item);
-}
-
-static struct configfs_group_operations ft_lun_group_ops = {
-	.make_group = ft_add_lun,
-	.drop_item = ft_del_lun,
-};
-
-static struct config_item_type ft_lun_cit = {
-	.ct_group_ops = &ft_lun_group_ops,
-	.ct_owner = THIS_MODULE,
-};
-
-/*
- * LUN ACL item ops.
- */
-
-static int ft_lun_acl_link(struct config_item *lun_acl_ci,
-			   struct config_item *lun_ci)
-{
-	struct se_node_acl_s *se_nacl;
-	struct se_lun_s *lun;
-	struct se_lun_acl_s *lun_acl;
-	struct se_portal_group_s *se_tpg;
-	struct se_dev_entry_s *deve;
-	struct config_item *item;
-	struct config_group *tpg_group;
-	int lun_access;
-	int ret;
-
-	FT_CONF_DBG("links %s to %s\n",
-		    config_item_name(lun_acl_ci), config_item_name(lun_ci));
-
-	/*
-	 * Make sure parent of lun_ci is same TPG as parent of lun_acl_ci.
-	 * lun_acl_ci is fc/<tpg>/acl/<wwpn>/lun_<x>
-	 * lun_ci     is fc/<tpg>/lun/lun_<y>
-	 * tpg should be equal.
-	 */
-	item = lun_acl_ci->ci_parent;	/* node acl <wwpn> */
-	item = item->ci_parent;		/* "acl" */
-	tpg_group = item->ci_group;	/* <tpg> */
-	item = lun_ci->ci_parent;	/* "lun" */
-	if (!item)
-		return -EINVAL;
-
-	FT_CONF_DBG("tpg_group %s to lun_tpg %s\n",
-		    config_item_name(&tpg_group->cg_item),
-		    config_item_name(&item->ci_group->cg_item));
-
-	if (tpg_group != item->ci_group) {
-		FT_CONF_DBG("links not in same tpg\n");
-		return -EINVAL;
-	}
-
-	lun_acl = container_of(to_config_group(lun_acl_ci),
-				   struct se_lun_acl_s, se_lun_group);
-	lun = container_of(to_config_group(lun_ci), se_lun_t, lun_group);
-
-	se_tpg = container_of(tpg_group, struct se_portal_group_s, tpg_group);
-
-	se_nacl = lun_acl->se_lun_nacl;
-	spin_lock_bh(&se_nacl->device_list_lock);
-	deve = &se_nacl->device_list[lun_acl->mapped_lun];
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
-		lun_access = deve->lun_flags;
-	else
-		lun_access = TRANSPORT_LUNFLAGS_READ_WRITE;	/* XXX */
-	spin_unlock_bh(&se_nacl->device_list_lock);
-
-	ret = core_dev_add_initiator_node_lun_acl(se_tpg, lun_acl,
-			lun->unpacked_lun, lun_access);
-	if (ret < 0) {
-		FT_CONF_DBG("link %s to %s ret %d\n",
-			config_item_name(lun_acl_ci),
-			config_item_name(lun_ci), ret);
-		return ret;
-	}
-	return 0;
-}
-
-static int ft_lun_acl_unlink(struct config_item *lun_acl_ci,
-			     struct config_item *lun_ci)
-{
-	struct se_lun_s *lun;
-	struct se_lun_acl_s *lun_acl;
-	struct se_portal_group_s *se_tpg;
-	struct config_group *tpg_group;
-	int ret;
-
-	FT_CONF_DBG("unlink %s and %s\n",
-		    config_item_name(lun_acl_ci),
-		    config_item_name(lun_ci));
-	/*
-	 * lun_acl_ci is fc/<tpg>/acl/<wwpn>/lun_<x>
-	 * lun_ci     is fc/<tpg>/lun/lun_<y>
-	 */
-	tpg_group = lun_acl_ci->ci_parent->ci_parent->ci_group;
-
-	FT_CONF_DBG("tpg_group %s delete lun_acl %s\n",
-		    config_item_name(&tpg_group->cg_item),
-		    config_item_name(lun_acl_ci));
-
-	lun_acl = container_of(to_config_group(lun_acl_ci),
-				   struct se_lun_acl_s, se_lun_group);
-	lun = container_of(to_config_group(lun_ci), se_lun_t, lun_group);
-
-	se_tpg = container_of(tpg_group, struct se_portal_group_s, tpg_group);
-
-	ret = core_dev_del_initiator_node_lun_acl(se_tpg, lun, lun_acl);
-	if (ret < 0) {
-		FT_CONF_DBG("link %s to %s ret %d\n",
-			    config_item_name(lun_acl_ci),
-			    config_item_name(lun_ci), ret);
-		return ret;
-	}
-	return 0;
-}
-
-static struct configfs_item_operations ft_lun_acl_item_ops = {
-	.allow_link =	ft_lun_acl_link,
-	.drop_link =	ft_lun_acl_unlink,
-};
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
 
-static struct config_item_type ft_lun_acl_cit = {
-	.ct_item_ops =	&ft_lun_acl_item_ops,
-	.ct_attrs = NULL,
-	.ct_owner = THIS_MODULE,
-};
-
-/*
- * LUN ACL group ops.
- */
-
-static struct config_group *ft_add_lun_acl(struct config_group *group,
-					   const char *name)
-{
-	struct se_lun_acl_s *lun_acl;
-	struct se_node_acl_s *se_nacl;
-	struct se_portal_group_s *se_tpg;
-	unsigned long index;
-	int ret;
-
-	FT_CONF_DBG("add lun acl %s\n", name);
-
-	/*
-	 * Name must be "lun_" followed by the index.
-	 */
-	if (strstr(name, "lun_") != name)
-		return NULL;
-
-	if (strict_strtoul(name + 4, 10, &index) || index > UINT_MAX)
-		return NULL;
-
-	se_nacl = container_of(group, struct se_node_acl_s, acl_group);
-	se_tpg = se_nacl->se_tpg;
-
-	FT_CONF_DBG("add lun acl %s init name %s\n", name,
-		    config_item_name(&se_nacl->acl_group.cg_item));
-
-	lun_acl = core_dev_init_initiator_node_lun_acl(se_tpg, index,
-			config_item_name(&se_nacl->acl_group.cg_item), &ret);
-	if (!lun_acl)
-		return NULL;
-
-	config_group_init_type_name(&lun_acl->se_lun_group, name,
-				    &ft_lun_acl_cit);
-
-	return &lun_acl->se_lun_group;
+	return ft_wwn_store(&acl->node_auth.node_name, page, count);
 }
 
-static void ft_del_lun_acl(struct config_group *group,
-			   struct config_item *item)
-{
-	struct se_lun_acl_s *lun_acl;
-	struct se_node_acl_s *se_nacl;
-	struct se_portal_group_s *se_tpg;
+TF_NACL_BASE_ATTR(ft, node_name, S_IRUGO | S_IWUSR);
 
-	FT_CONF_DBG("del lun acl %s p %p\n", config_item_name(item), item);
-
-	se_nacl = container_of(group, struct se_node_acl_s, acl_group);
-	se_tpg = se_nacl->se_tpg;
-	lun_acl = container_of(to_config_group(item),
-				struct se_lun_acl_s, se_lun_group);
-
-	core_dev_free_initiator_node_lun_acl(se_tpg, lun_acl);
-	config_item_put(item);
-}
-
-static struct configfs_group_operations ft_lun_acl_group_ops = {
-	.make_group = ft_add_lun_acl,
-	.drop_item = ft_del_lun_acl,
-};
-
-/*
- * ACL auth ops.
- */
-
-static void *ft_acl_from_auth(struct config_item *item)
-{
-	return container_of(item->ci_group, struct se_node_acl_s, acl_group);
-}
-
-static struct ft_attr ft_acl_port_name_attr =
-		FT_ATTR("port_name", ft_node_acl, node_auth.port_name,
-				S_IRUGO, ft_acl_from_auth,
-				ft_wwn_show, ft_wwn_store);
-
-static struct ft_attr ft_acl_node_name_attr =
-		FT_ATTR("node_name", ft_node_acl, node_auth.node_name,
-				S_IRUGO | S_IWUSR, ft_acl_from_auth,
-				ft_wwn_show, ft_wwn_store);
-
-static struct configfs_attribute *ft_nacl_auth_attrs[] = {
-	&ft_acl_port_name_attr.attr,
-	&ft_acl_node_name_attr.attr,
+static struct configfs_attribute *ft_nacl_base_attrs[] = {
+	&ft_nacl_port_name.attr,
+	&ft_nacl_node_name.attr,
 	NULL,
 };
 
-static struct config_item_type ft_nacl_auth_cit = {
-	.ct_item_ops = &ft_item_ops,
-	.ct_attrs = ft_nacl_auth_attrs,
-	.ct_owner = THIS_MODULE,
-};
-
-static struct config_item_type ft_nacl_cit = {
-	.ct_group_ops = &ft_lun_acl_group_ops,
-	.ct_owner = THIS_MODULE,
-};
-
 /*
  * ACL ops.
  */
@@ -685,8 +207,10 @@ static struct config_item_type ft_nacl_cit = {
  * Add ACL for an initiator.  The ACL is named arbitrarily.
  * The port_name and/or node_name are attributes.
  */
-static struct config_group *ft_add_acl(struct config_group *group,
-				       const char *name)
+static struct se_node_acl_s *ft_add_acl(
+	struct se_portal_group_s *se_tpg,
+	struct config_group *group,
+	const char *name)
 {
 	struct ft_node_acl *acl;
 	struct se_node_acl_s *se_nacl;
@@ -695,64 +219,55 @@ static struct config_group *ft_add_acl(struct config_group *group,
 	u32 q_depth;
 
 	FT_CONF_DBG("add acl %s\n", name);
-	tpg = container_of(group, struct ft_tpg, acl_group);
+	tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
 
 	if (ft_parse_wwn(name, &wwpn, 1) < 0)
-		return NULL;
+		return ERR_PTR(-EINVAL);
+
+	acl = kzalloc(sizeof(struct ft_node_acl), GFP_KERNEL);
+	if (!(acl))
+		return ERR_PTR(-ENOMEM);
 
 	q_depth = 32;		/* XXX bogus default - get from tpg? */
-	se_nacl = core_tpg_add_initiator_node_acl(tpg->se_tpg, name, q_depth);
-	if (IS_ERR(se_nacl) || !se_nacl)
-		return NULL;
+	se_nacl = core_tpg_add_initiator_node_acl(&tpg->se_tpg,
+				&acl->se_node_acl, name, q_depth);
+	if (IS_ERR(se_nacl) || !se_nacl) {
+		kfree(acl);
+		return se_nacl;
+	}
 
-	acl = se_nacl->fabric_acl_ptr;
 	acl->node_auth.port_name = wwpn;
-	config_group_init_type_name(&se_nacl->acl_group, name, &ft_nacl_cit);
-	config_group_init_type_name(&acl->auth_group, "auth",
-				    &ft_nacl_auth_cit);
-/* XXXX TBD add se_acl->param_group to groups */
-	acl->groups[0] = &acl->auth_group;
-	acl->groups[3] = NULL;
-	se_nacl->acl_group.default_groups = acl->groups;
-
-	return &se_nacl->acl_group;
+	return &acl->se_node_acl;
 }
 
-static void ft_del_acl(struct config_group *group, struct config_item *item)
+static void ft_del_acl(struct se_node_acl_s *se_acl)
 {
+	struct se_portal_group_s *se_tpg = se_acl->se_tpg;
 	struct ft_tpg *tpg;
-	struct ft_node_acl *acl;
-	struct se_node_acl_s *se_acl;
+	struct ft_node_acl *acl = container_of(se_acl,
+				struct ft_node_acl, se_node_acl);
 
-	FT_CONF_DBG("del acl %s\n", config_item_name(item));
-
-	tpg = container_of(group, struct ft_tpg, acl_group);
-	se_acl = container_of(to_config_group(item), struct se_node_acl_s,
-			acl_group);
-	acl = se_acl->fabric_acl_ptr;
+	FT_CONF_DBG("del acl %s\n",
+		config_item_name(&se_acl->acl_group.cg_item));
 
+	tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
 	FT_CONF_DBG("del acl %p se_acl %p tpg %p se_tpg %p\n",
-		    acl, se_acl, tpg, tpg->se_tpg);
+		    acl, se_acl, tpg, &tpg->se_tpg);
 
-	core_tpg_del_initiator_node_acl(tpg->se_tpg, se_acl, 1);
-	config_item_put(item);
+	core_tpg_del_initiator_node_acl(&tpg->se_tpg, se_acl, 1);
+	kfree(acl);
 }
 
 struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 {
 	struct ft_node_acl *found = NULL;
 	struct ft_node_acl *acl;
-	struct se_portal_group_s *se_tpg;
+	struct se_portal_group_s *se_tpg = &tpg->se_tpg;
 	struct se_node_acl_s *se_acl;
 
-	se_tpg = tpg->se_tpg;
-	if (!se_tpg) {
-		FT_CONF_DBG("tpg %p se_tpg NULL\n", tpg);
-		return NULL;
-	}
 	spin_lock_bh(&se_tpg->acl_node_lock);
 	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_list) {
-		acl = se_acl->fabric_acl_ptr;
+		acl = container_of(se_acl, struct ft_node_acl, se_node_acl);
 		FT_CONF_DBG("acl %p port_name %llx\n",
 			acl, (unsigned long long)acl->node_auth.port_name);
 		if (acl->node_auth.port_name == rdata->ids.port_name ||
@@ -768,56 +283,41 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 	return found;
 }
 
-static void *ft_tpg_alloc_fabric_acl(se_portal_group_t *se_tpg,
-				     se_node_acl_t *se_nacl)
+struct se_node_acl_s *ft_tpg_alloc_fabric_acl(se_portal_group_t *se_tpg)
 {
 	struct ft_node_acl *acl;
 
 	acl = kzalloc(sizeof(*acl), GFP_KERNEL);
-	if (acl)
-		acl->se_node_acl = se_nacl;
+	if (!(acl)) {
+		printk(KERN_ERR "Unable to allocate struct ft_node_acl\n");
+		return NULL;
+	}
 	FT_CONF_DBG("acl %p\n", acl);
-	return acl;
+	return &acl->se_node_acl;
 }
 
 static void ft_tpg_release_fabric_acl(se_portal_group_t *se_tpg,
 				      se_node_acl_t *se_acl)
 {
-	struct ft_node_acl *acl = se_acl->fabric_acl_ptr;
+	struct ft_node_acl *acl = container_of(se_acl,
+				struct ft_node_acl, se_node_acl);
 
 	FT_CONF_DBG(KERN_INFO "acl %p\n", acl);
-	/* freed after put item in del_acl now */
+	kfree(acl);
 }
 
-static struct configfs_group_operations ft_acl_group_ops = {
-	.make_group = ft_add_acl,
-	.drop_item = ft_del_acl,
-};
-
-static struct config_item_type ft_acl_cit = {
-	.ct_group_ops = &ft_acl_group_ops,
-	.ct_owner = THIS_MODULE,
-};
-
-/*
- * Target port group ops.
- * Nothing for now - add enable/disable to protect during setup, eventually.
- */
-static struct config_item_type ft_tpg_cit = {
-	.ct_owner = THIS_MODULE,
-};
-
 /*
  * local_port port_group (tpg) ops.
  */
-static struct config_group *ft_add_tpg(struct config_group *group,
-				       const char *name)
+static struct se_portal_group_s *ft_add_tpg(
+	struct se_wwn_s *wwn,
+	struct config_group *group,
+	const char *name)
 {
 	struct ft_lport_acl *lacl;
 	struct ft_tpg *tpg;
-	struct se_portal_group_s *se_tpg;
-	struct config_group *tpg_cg;
 	unsigned long index;
+	int ret;
 
 	FT_CONF_DBG("tcm_fc: add tpg %s\n", name);
 
@@ -829,7 +329,7 @@ static struct config_group *ft_add_tpg(struct config_group *group,
 	if (strict_strtoul(name + 5, 10, &index) || index > UINT_MAX)
 		return NULL;
 
-	lacl = container_of(group, struct ft_lport_acl, group);
+	lacl = container_of(wwn, struct ft_lport_acl, fc_lport_wwn);
 	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
 	if (!tpg)
 		return NULL;
@@ -838,18 +338,15 @@ static struct config_group *ft_add_tpg(struct config_group *group,
 	INIT_LIST_HEAD(&tpg->lun_list);
 	transport_init_queue_obj(&tpg->qobj);
 
-	se_tpg = core_tpg_register(&ft_configfs->tf_ops, tpg,
-					TRANSPORT_TPG_TYPE_NORMAL);
-	if (IS_ERR(se_tpg)) {
+	ret = core_tpg_register(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
+				(void *)tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
 	}
-	tpg->se_tpg = se_tpg;
-	se_tpg->se_tpg_fabric_ptr = tpg;
 
 	tpg->thread = kthread_run(ft_thread, tpg, "ft_tpg%lu", index);
 	if (IS_ERR(tpg->thread)) {
-		core_tpg_deregister(se_tpg);
 		kfree(tpg);
 		return NULL;
 	}
@@ -859,27 +356,16 @@ static struct config_group *ft_add_tpg(struct config_group *group,
 	list_add_tail(&tpg->list, &lacl->tpg_list);
 	mutex_unlock(&ft_lport_lock);
 
-	tpg_cg = &se_tpg->tpg_group;
-	tpg_cg->default_groups = tpg->groups;
-	config_group_init_type_name(&tpg->lun_group, "lun", &ft_lun_cit);
-	config_group_init_type_name(&tpg->acl_group, "acl", &ft_acl_cit);
-	tpg->groups[0] = &tpg->lun_group;
-	tpg->groups[1] = &tpg->acl_group;
-	tpg->groups[2] = NULL;
-
-	config_group_init_type_name(tpg_cg, name, &ft_tpg_cit);
-	return tpg_cg;
+	return &tpg->se_tpg;
 }
 
-static void ft_del_tpg(struct config_group *group, struct config_item *item)
+static void ft_del_tpg(struct se_portal_group_s *se_tpg)
 {
-	struct se_portal_group_s *se_tpg;
-	struct ft_tpg *tpg;
+	struct ft_tpg *tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
 
-	FT_CONF_DBG("del tpg %s\n", config_item_name(item));
-	se_tpg = container_of(to_config_group(item), se_portal_group_t,
-			      tpg_group);
-	tpg = se_tpg->se_tpg_fabric_ptr;
+	FT_CONF_DBG("del tpg %s\n",
+		config_item_name(&tpg->se_tpg.tpg_group.cg_item));
+	
 	kthread_stop(tpg->thread);
 	wait_for_completion(&tpg->qobj.thread_done_comp);
 
@@ -894,7 +380,6 @@ static void ft_del_tpg(struct config_group *group, struct config_item *item)
 	}
 	mutex_unlock(&ft_lport_lock);
 
-	config_item_put(item);
 	core_tpg_deregister(se_tpg);
 	kfree(tpg);
 }
@@ -920,26 +405,6 @@ struct ft_tpg *ft_lport_find_tpg(struct fc_lport *lport)
 	return NULL;
 }
 
-static void ft_free_lport(struct config_item *item)
-{
-	kfree(container_of(item, struct ft_lport_acl, group.cg_item));
-}
-
-static struct configfs_item_operations ft_lport_item_ops = {
-	.release = ft_free_lport,
-};
-
-static struct configfs_group_operations ft_lport_group_ops = {
-	.make_group = ft_add_tpg,
-	.drop_item = ft_del_tpg,
-};
-
-static struct config_item_type ft_lport_cit = {
-	.ct_item_ops = &ft_lport_item_ops,
-	.ct_group_ops = &ft_lport_group_ops,
-	.ct_owner = THIS_MODULE,
-};
-
 /*
  * target config instance ops.
  */
@@ -948,8 +413,10 @@ static struct config_item_type ft_lport_cit = {
  * Add lport to allowed config.
  * The name is the WWPN in lower-case ASCII, colon-separated bytes.
  */
-static struct config_group *ft_add_lport(struct config_group *group,
-					 const char *name)
+static struct se_wwn_s *ft_add_lport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
 {
 	struct ft_lport_acl *lacl;
 	struct ft_lport_acl *old_lacl;
@@ -975,56 +442,39 @@ static struct config_group *ft_add_lport(struct config_group *group,
 	list_add_tail(&lacl->list, &ft_lport_list);
 	ft_format_wwn(lacl->name, sizeof(lacl->name), wwpn);
 	mutex_unlock(&ft_lport_lock);
-	config_group_init_type_name(&lacl->group, lacl->name,
-				    &ft_lport_cit);
-	return &lacl->group;
+
+	return &lacl->fc_lport_wwn;
 }
 
-static void ft_del_lport(struct config_group *group, struct config_item *item)
+static void ft_del_lport(struct se_wwn_s *wwn)
 {
-	struct ft_lport_acl *lacl = container_of(to_config_group(item),
-						struct ft_lport_acl, group);
+	struct ft_lport_acl *lacl = container_of(wwn,
+				struct ft_lport_acl, fc_lport_wwn);
 
-	FT_CONF_DBG("del lport %s\n", config_item_name(item));
+	FT_CONF_DBG("del lport %s\n",
+			config_item_name(&wwn->wwn_group.cg_item));
 	mutex_lock(&ft_lport_lock);
 	list_del(&lacl->list);
 	mutex_unlock(&ft_lport_lock);
-	config_item_put(item);
-}
 
-static struct configfs_group_operations ft_group_ops = {
-	.make_group = ft_add_lport,
-	.drop_item = ft_del_lport,
-};
+	kfree(lacl);
+}
 
-static ssize_t ft_version_show(struct config_item *item,
-			       struct configfs_attribute *attr, char *page)
+static ssize_t ft_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
 {
-	return sprintf(page, "TCM FC " FT_VERSION "\n");
+	return sprintf(page, "TCM FC " FT_VERSION " on %s/%s on "
+		""UTS_RELEASE"\n",  utsname()->sysname, utsname()->machine);
 }
 
-static struct configfs_item_operations ft_item_attr_version_ops = {
-	.show_attribute = ft_version_show,
-};
-
-static struct configfs_attribute ft_item_attr_version = {
-	.ca_owner = THIS_MODULE,
-	.ca_name = "version",
-	.ca_mode = S_IRUGO,
-};
+TF_WWN_ATTR_RO(ft, version);
 
-static struct configfs_attribute *ft_attrs[] = {
-	&ft_item_attr_version,
+static struct configfs_attribute *ft_wwn_attrs[] = {
+	&ft_wwn_version.attr,
 	NULL,
 };
 
-static struct config_item_type ft_cit = {
-	.ct_item_ops = &ft_item_attr_version_ops,
-	.ct_group_ops = &ft_group_ops,
-	.ct_attrs = ft_attrs,
-	.ct_owner = THIS_MODULE,
-};
-
 static char *ft_get_fabric_name(void)
 {
 	return "fc";
@@ -1072,7 +522,8 @@ static u32 ft_get_pr_transport_id(se_portal_group_t *se_tpg,
 				  t10_pr_registration_t *pr_reg,
 				  int *format_code, unsigned char *buf)
 {
-	struct ft_node_acl *acl = (struct ft_node_acl *)se_nacl->fabric_acl_ptr;
+	struct ft_node_acl *acl = container_of(se_nacl, struct ft_node_acl,
+					se_node_acl);
 	struct ft_transport_id *id = (struct ft_transport_id *)buf;
 	/*
 	 * PROTOCOL IDENTIFIER is 0h for FCP-2
@@ -1171,6 +622,20 @@ static struct target_core_fabric_ops ft_fabric_ops = {
 	.set_fabric_sense_len =		ft_set_fabric_sense_len,
 	.is_state_remove =		ft_is_state_remove,
 	.pack_lun =			ft_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn =		&ft_add_lport,
+	.fabric_drop_wwn =		&ft_del_lport,
+	.fabric_make_tpg =		&ft_add_tpg,
+	.fabric_drop_tpg =		&ft_del_tpg,
+	.fabric_post_link =		NULL,
+	.fabric_pre_unlink =		NULL,
+	.fabric_make_np =		NULL,
+	.fabric_drop_np =		NULL,
+	.fabric_make_nodeacl =		&ft_add_acl,
+	.fabric_drop_nodeacl =		&ft_del_acl,
+	
 };
 
 int ft_register_configfs(void)
@@ -1181,14 +646,25 @@ int ft_register_configfs(void)
 	/*
 	 * Register the top level struct config_item_type with TCM core
 	 */
-	fabric = target_fabric_configfs_init(&ft_cit, "fc");
+	fabric = target_fabric_configfs_init(THIS_MODULE, "fc");
 	if (!fabric) {
 		printk(KERN_INFO "%s: target_fabric_configfs_init() failed!\n",
 		       __func__);
 		return -1;
 	}
 	fabric->tf_ops = ft_fabric_ops;
-
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = ft_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = ft_nacl_base_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
 	/*
 	 * register the fabric for use within TCM
 	 */
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index b3d9383..8074d85 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -243,8 +243,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 
 	FT_SESS_DBG("port_id %x sess %p\n", port_id, sess);
 
-	sess->se_sess->se_node_acl = acl->se_node_acl;
-	transport_register_session(tport->tpg->se_tpg, acl->se_node_acl,
+	__transport_register_session(&tport->tpg->se_tpg, &acl->se_node_acl,
 				   sess->se_sess, sess);
 	return sess;
 }
-- 
1.5.6.5

