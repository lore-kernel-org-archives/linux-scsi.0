From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] [TCM/ConfigFS]: Add generic NodeACL and MappedLUN configfs logic
Date: Thu, 25 Feb 2010 06:05:32 -0800
Message-ID: <1267106732-7052-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the following generic struct config_item_types to
include/target/garget_core_configfs.h:struct target_fabric_configfs_template for
allowing generic fabric module usage of NodeACL group and MappedLUN group+link
operations using the 4.x target_core_fabric_configfs.c code.

These configfs groups are represented using target_core_fabric_configfs.c directory and attribute
names following existing v3.x LIO-Target fabric module code layout in:

/sys/kernel/config/target/$FABRIC/$WWN/tpgt_$TPGT/acls/$INITIATOR_WWN/[attrib,param,auth]

The new structure members in struct target_fabric_configfs_template are:

       struct config_item_type tfc_tpg_nacl_cit;
       struct config_item_type tfc_tpg_nacl_base_cit;
       struct config_item_type tfc_tpg_nacl_attrib_cit;
       struct config_item_type tfc_tpg_nacl_auth_cit;
       struct config_item_type tfc_tpg_nacl_param_cit;
       struct config_item_type tfc_tpg_mappedlun_cit;

This patch then adds the following calls to struct target_core_fabric_ops to handle allocation
and release in target_core_fabric_configfs.c of the fabric dependent acl structure that the
target_core_mod struct se_node_acl_s is intended to hang from:

       struct se_node_acl_s *(*fabric_make_nodeacl)(struct se_portal_group_s *,
                               struct config_group *, const char *);
       void (*fabric_drop_nodeacl)(struct se_node_acl_s *);

This patch also adds the acl_attrib_group, acl_auth_group, and acl_param_group members to
include/target/target_core_base.h:struct se_node_acl_s that are used by the generic
struct config_item_types.  Along with these new default struct config_item_types are matching
macros in include/target/target_core_fabric_configfs.h that are used by fabric module configfs
code to (optionally) define fabric dependent attributes on a per struct config_item_type context.

Finally, this patch updates support for target_core_tpg.c to handle se_node_acl_s
allocation from fabric module dependent structures, demo mode -> explict NodeACL
conversion logic with core_tpg_check_initiator_node_acl(), and the properly handling the
existing TPG attribute prod_mode_write_protect.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |  381 +++++++++++++++++++++++++-
 drivers/target/target_core_tpg.c             |   54 ++--
 include/target/target_core_base.h            |    4 +-
 include/target/target_core_configfs.h        |    7 +-
 include/target/target_core_fabric_configfs.h |   44 +++
 include/target/target_core_fabric_ops.h      |    8 +-
 include/target/target_core_tpg.h             |    6 +-
 7 files changed, 459 insertions(+), 45 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index d2cb051..0312947 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -41,6 +41,7 @@
 #include <target/target_core_hba.h>
 #include <target/target_core_plugin.h>
 #include <target/target_core_seobj.h>
+#include <target/target_core_tpg.h>
 #include <target/target_core_transport.h>
 #include <target/target_core_alua.h>
 #include <target/target_core_pr.h>
@@ -62,16 +63,360 @@ static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf)
 	printk("Setup generic %s\n", __stringify(_name));		\
 }
 
-/* Start of tfc_tpg_acl_cit */
+/* Start of tfc_tpg_mappedlun_cit */
 
-static struct configfs_group_operations target_fabric_acl_group_ops = {
-	.make_group	= NULL,
-	.drop_item	= NULL,
+static int target_fabric_mappedlun_link(
+	struct config_item *lun_acl_ci,
+	struct config_item *lun_ci)
+{
+	struct se_dev_entry_s *deve;
+	struct se_lun_s *lun = container_of(to_config_group(lun_ci),
+			struct se_lun_s, lun_group);
+	struct se_lun_acl_s *lacl = container_of(to_config_group(lun_acl_ci),
+			struct se_lun_acl_s, se_lun_group);
+	struct se_portal_group_s *se_tpg = lun->lun_sep->sep_tpg;
+	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *wwn_ci, *wwn_ci_s;
+	int ret = 0, lun_access;
+
+	nacl_ci = &lun_acl_ci->ci_parent->ci_group->cg_item;
+	tpg_ci = &nacl_ci->ci_group->cg_item;
+	wwn_ci = &tpg_ci->ci_group->cg_item;
+	tpg_ci_s = &lun_ci->ci_parent->ci_group->cg_item;
+	wwn_ci_s = &tpg_ci_s->ci_group->cg_item;
+	/*
+	 * Make sure the SymLink is going to the same $FABRIC/$WWN/tpgt_$TPGT
+	 */
+	if (strcmp(config_item_name(wwn_ci), config_item_name(wwn_ci_s))) {
+		printk(KERN_ERR "Illegal Initiator ACL SymLink outside of %s\n",
+			config_item_name(wwn_ci));
+		return -EINVAL;
+	}
+	if (strcmp(config_item_name(tpg_ci), config_item_name(tpg_ci_s))) {
+		printk(KERN_ERR "Illegal Initiator ACL Symlink outside of %s"
+			" TPGT: %s\n", config_item_name(wwn_ci),
+			config_item_name(tpg_ci));
+		return -EINVAL;
+	}
+	/*
+	 * If this struct se_node_acl_s was dynamically generated with
+	 * tpg_1/attrib/generate_node_acls=1, use the existing deve->lun_flags,
+	 * which be will write protected (READ-ONLY) when
+	 * tpg_1/attrib/demo_mode_write_protect=1
+	 */
+	spin_lock_bh(&lacl->se_lun_nacl->device_list_lock);
+	deve = &lacl->se_lun_nacl->device_list[lacl->mapped_lun];
+	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
+		lun_access = deve->lun_flags;
+	else
+		lun_access =
+			(TPG_TFO(se_tpg)->tpg_check_prod_mode_write_protect(
+				se_tpg)) ? TRANSPORT_LUNFLAGS_READ_ONLY :
+					   TRANSPORT_LUNFLAGS_READ_WRITE;
+	spin_unlock_bh(&lacl->se_lun_nacl->device_list_lock);
+	/*
+	 * Determine the actual mapped LUN value user wants..
+	 *
+	 * This value is what the SCSI Initiator actually sees the
+	 * iscsi/$IQN/$TPGT/lun/lun_* as on their SCSI Initiator Ports.
+	 */
+	ret = core_dev_add_initiator_node_lun_acl(se_tpg, lacl,
+			lun->unpacked_lun, lun_access);
+
+	return (ret < 0) ? -EINVAL : 0;
+}
+
+static int target_fabric_mappedlun_unlink(
+	struct config_item *lun_acl_ci,
+	struct config_item *lun_ci)
+{
+	struct se_lun_s *lun = container_of(to_config_group(lun_ci),
+			struct se_lun_s, lun_group);
+	struct se_lun_acl_s *lacl = container_of(to_config_group(lun_acl_ci),
+			struct se_lun_acl_s, se_lun_group);
+	struct se_portal_group_s *se_tpg = lun->lun_sep->sep_tpg;
+
+	core_dev_del_initiator_node_lun_acl(se_tpg, lun, lacl);
+	return 0;
+}
+
+CONFIGFS_EATTR_STRUCT(target_fabric_mappedlun, se_lun_acl_s);
+#define TCM_MAPPEDLUN_ATTR(_name, _mode)				\
+static struct target_fabric_mappedlun_attribute target_fabric_mappedlun_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_fabric_mappedlun_show_##_name,				\
+	target_fabric_mappedlun_store_##_name);
+
+static ssize_t target_fabric_mappedlun_show_write_protect(
+	struct se_lun_acl_s *lacl,
+	char *page)
+{
+	struct se_node_acl_s *se_nacl = lacl->se_lun_nacl;
+	struct se_dev_entry_s *deve;
+	ssize_t len;
+
+	spin_lock_bh(&se_nacl->device_list_lock);
+	deve = &se_nacl->device_list[lacl->mapped_lun];
+	len = sprintf(page, "%d\n",
+			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
+			1 : 0);
+	spin_unlock_bh(&se_nacl->device_list_lock);
+
+	return len;
+}
+
+static ssize_t target_fabric_mappedlun_store_write_protect(
+	struct se_lun_acl_s *lacl,
+	const char *page,
+	size_t count)
+{
+	struct se_node_acl_s *se_nacl = lacl->se_lun_nacl;
+	struct se_portal_group_s *se_tpg = se_nacl->se_tpg;
+	char *endptr;
+	u32 op;
+
+	op = simple_strtoul(page, &endptr, 0);
+	if ((op != 1) && (op != 0)) {
+		printk(KERN_ERR "Illegal value for access: %u\n", op);
+		return -EINVAL;
+	}
+	core_update_device_list_access(lacl->mapped_lun, (op) ?
+			TRANSPORT_LUNFLAGS_READ_ONLY :
+			TRANSPORT_LUNFLAGS_READ_WRITE,
+			lacl->se_lun_nacl);
+
+	printk(KERN_INFO "%s_ConfigFS: Changed Initiator ACL: %s"
+		" Mapped LUN: %u Write Protect bit to %s\n",
+		TPG_TFO(se_tpg)->get_fabric_name(), 
+		lacl->initiatorname, lacl->mapped_lun, (op) ? "ON" : "OFF");
+
+        return count;
+
+}
+
+TCM_MAPPEDLUN_ATTR(write_protect, S_IRUGO | S_IWUSR);
+
+CONFIGFS_EATTR_OPS(target_fabric_mappedlun, se_lun_acl_s, se_lun_group);
+
+static struct configfs_attribute *target_fabric_mappedlun_attrs[] = {
+	&target_fabric_mappedlun_write_protect.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_fabric_mappedlun_item_ops = {
+	.show_attribute		= target_fabric_mappedlun_attr_show,
+	.store_attribute	= target_fabric_mappedlun_attr_store,
+	.allow_link		= target_fabric_mappedlun_link,
+	.drop_link		= target_fabric_mappedlun_unlink,
+};
+
+TF_CIT_SETUP(tpg_mappedlun, &target_fabric_mappedlun_item_ops, NULL,
+		target_fabric_mappedlun_attrs);
+
+/* End of tfc_tpg_mappedlun_cit */
+
+/* Start of tfc_tpg_nacl_attrib_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_nacl_attrib, se_node_acl_s, acl_attrib_group);
+
+static struct configfs_item_operations target_fabric_nacl_attrib_item_ops = {
+	.show_attribute		= target_fabric_nacl_attrib_attr_show,
+	.store_attribute	= target_fabric_nacl_attrib_attr_store,
+};
+
+TF_CIT_SETUP(tpg_nacl_attrib, &target_fabric_nacl_attrib_item_ops, NULL, NULL);
+
+/* End of tfc_tpg_nacl_attrib_cit */
+
+/* Start of tfc_tpg_nacl_auth_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_nacl_auth, se_node_acl_s, acl_auth_group);
+
+static struct configfs_item_operations target_fabric_nacl_auth_item_ops = {
+	.show_attribute		= target_fabric_nacl_auth_attr_show,
+	.store_attribute	= target_fabric_nacl_auth_attr_store,
+};
+
+TF_CIT_SETUP(tpg_nacl_auth, &target_fabric_nacl_auth_item_ops, NULL, NULL);
+
+/* End of tfc_tpg_nacl_auth_cit */
+
+/* Start of tfc_tpg_nacl_param_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_nacl_param, se_node_acl_s, acl_param_group);
+
+static struct configfs_item_operations target_fabric_nacl_param_item_ops = {
+	.show_attribute		= target_fabric_nacl_param_attr_show,
+	.store_attribute	= target_fabric_nacl_param_attr_store,
+};
+
+TF_CIT_SETUP(tpg_nacl_param, &target_fabric_nacl_param_item_ops, NULL, NULL);
+
+/* End of tfc_tpg_nacl_param_cit */
+
+/* Start of tfc_tpg_nacl_base_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_nacl_base, se_node_acl_s, acl_group);
+
+static struct config_group *target_fabric_make_mappedlun(
+	struct config_group *group,
+	const char *name)
+{
+	struct se_node_acl_s *se_nacl = container_of(group,
+			struct se_node_acl_s, acl_group);
+	struct se_portal_group_s *se_tpg = se_nacl->se_tpg;
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+	struct se_lun_acl_s *lacl;
+	struct config_item *acl_ci;
+	char *buf, *endptr, *ptr;
+	u32 mapped_lun;
+	int ret = 0;
+
+	acl_ci = &group->cg_item;
+	if (!(acl_ci)) {
+		printk(KERN_ERR "Unable to locatel acl_ci\n");
+		return NULL;
+	}
+
+	buf = kzalloc(strlen(name) + 1, GFP_KERNEL);
+	if (!(buf)) {
+		printk(KERN_ERR "Unable to allocate memory for name buf\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	snprintf(buf, strlen(name) + 1, "%s", name);
+	/*
+	 * Make sure user is creating iscsi/$IQN/$TPGT/acls/$INITIATOR/lun_$ID.
+	 */
+	ptr = strstr(buf, "lun_");
+	if (!(ptr)) {
+		printk(KERN_ERR "Unable to locate \"lun_\" from buf: %s"
+			" name: %s\n", buf, name);
+		ret = -EINVAL;
+		goto out;
+	}
+	ptr += 3; /* Skip to "_" */
+	*ptr = '\0'; /* Terminate the string */
+	ptr++; /* Advance pointer to next characater */
+
+	/*
+	 * Determine the Mapped LUN value.  This is what the SCSI Initiator
+	 * Port will actually see.
+	 */
+	mapped_lun = simple_strtoul(ptr, &endptr, 0);
+
+	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
+			config_item_name(acl_ci), &ret);
+        if (!(lacl))
+                goto out;
+
+	config_group_init_type_name(&lacl->se_lun_group, name,
+			&TF_CIT_TMPL(tf)->tfc_tpg_mappedlun_cit);		
+
+	kfree(buf);
+	return &lacl->se_lun_group;
+out:
+	kfree(buf);
+	return ERR_PTR(ret);
+}
+
+static void target_fabric_drop_mappedlun(
+	struct config_group *group,
+	struct config_item *item)
+{
+	struct se_lun_acl_s *lacl = container_of(to_config_group(item),
+			struct se_lun_acl_s, se_lun_group);
+	struct se_portal_group_s *se_tpg = lacl->se_lun_nacl->se_tpg; 
+
+	config_item_put(item);
+	core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
+}
+
+static struct configfs_item_operations target_fabric_nacl_base_item_ops = {
+	.show_attribute		= target_fabric_nacl_base_attr_show,
+	.store_attribute	= target_fabric_nacl_base_attr_store,
+};
+
+static struct configfs_group_operations target_fabric_nacl_base_group_ops = {
+	.make_group		= target_fabric_make_mappedlun,
+	.drop_item		= target_fabric_drop_mappedlun,
+};
+
+TF_CIT_SETUP(tpg_nacl_base, &target_fabric_nacl_base_item_ops,
+		&target_fabric_nacl_base_group_ops, NULL);
+
+/* End of tfc_tpg_nacl_base_cit */
+
+/* Start of tfc_tpg_nacl_cit */
+
+static struct config_group *target_fabric_make_nodeacl(
+	struct config_group *group,
+	const char *name)
+{
+	struct se_portal_group_s *se_tpg = container_of(group,
+			struct se_portal_group_s, tpg_acl_group);
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+	struct se_node_acl_s *se_nacl;
+	struct config_group *nacl_cg;
+
+	if (!(tf->tf_ops.fabric_make_nodeacl)) {
+		printk(KERN_ERR "tf->tf_ops.fabric_make_nodeacl is NULL\n");
+		return ERR_PTR(-ENOSYS);
+	}
+
+	se_nacl = tf->tf_ops.fabric_make_nodeacl(se_tpg, group, name);
+	if (IS_ERR(se_nacl))
+		return ERR_PTR(PTR_ERR(se_nacl));	
+
+	nacl_cg = &se_nacl->acl_group;
+	nacl_cg->default_groups = se_nacl->acl_default_groups;
+	nacl_cg->default_groups[0] = &se_nacl->acl_attrib_group;
+	nacl_cg->default_groups[1] = &se_nacl->acl_auth_group; 
+	nacl_cg->default_groups[2] = &se_nacl->acl_param_group;
+	nacl_cg->default_groups[3] = NULL;
+
+	config_group_init_type_name(&se_nacl->acl_group, name,
+			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_base_cit);			
+	config_group_init_type_name(&se_nacl->acl_attrib_group, "attrib",
+			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_attrib_cit);
+	config_group_init_type_name(&se_nacl->acl_auth_group, "auth",
+			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_auth_cit);
+	config_group_init_type_name(&se_nacl->acl_param_group, "param",
+			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_param_cit);
+		
+	return &se_nacl->acl_group;
+}
+
+static void target_fabric_drop_nodeacl(
+	struct config_group *group,
+	struct config_item *item)
+{
+	struct se_portal_group_s *se_tpg = container_of(group,
+			struct se_portal_group_s, tpg_acl_group);
+	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
+	struct se_node_acl_s *se_nacl = container_of(to_config_group(item),
+			struct se_node_acl_s, acl_group);
+	struct config_item *df_item;
+	struct config_group *nacl_cg;
+	int i;
+
+	nacl_cg = &se_nacl->acl_group;
+	for (i = 0; nacl_cg->default_groups[i]; i++) {
+		df_item = &nacl_cg->default_groups[i]->cg_item;
+		nacl_cg->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+
+	config_item_put(item);
+	tf->tf_ops.fabric_drop_nodeacl(se_nacl);	
+}
+
+static struct configfs_group_operations target_fabric_nacl_group_ops = {
+	.make_group	= target_fabric_make_nodeacl,
+	.drop_item	= target_fabric_drop_nodeacl,
 };
 
-TF_CIT_SETUP(tpg_acl, NULL, &target_fabric_acl_group_ops, NULL);
+TF_CIT_SETUP(tpg_nacl, NULL, &target_fabric_nacl_group_ops, NULL);
 
-/* End of tfc_tpg_acl_cit */
+/* End of tfc_tpg_nacl_cit */
 
 /* Start of tfc_tpg_np_base_cit */
 
@@ -495,7 +840,7 @@ static struct config_group *target_fabric_make_tpg(
 	config_group_init_type_name(&se_tpg->tpg_np_group, "np",
 			&TF_CIT_TMPL(tf)->tfc_tpg_np_cit);
 	config_group_init_type_name(&se_tpg->tpg_acl_group, "acls",
-			&TF_CIT_TMPL(tf)->tfc_tpg_acl_cit);
+			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_cit);
 	config_group_init_type_name(&se_tpg->tpg_attrib_group, "attrib",
 			&TF_CIT_TMPL(tf)->tfc_tpg_attrib_cit);
 	config_group_init_type_name(&se_tpg->tpg_param_group, "param",
@@ -595,8 +940,23 @@ TF_CIT_SETUP(wwn, &target_fabric_wwn_item_ops, &target_fabric_wwn_group_ops, NUL
 
 /* End of tfc_wwn_cit */
 
+/* Start of tfc_discovery_cit */
+
+CONFIGFS_EATTR_OPS(target_fabric_discovery, target_fabric_configfs,
+		tf_disc_group);
+
+static struct configfs_item_operations target_fabric_discovery_item_ops = {
+	.show_attribute		= target_fabric_discovery_attr_show,
+	.store_attribute	= target_fabric_discovery_attr_store,
+};
+
+TF_CIT_SETUP(discovery, &target_fabric_discovery_item_ops, NULL, NULL);
+
+/* End of tfc_discovery_cit */
+
 int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 {
+	target_fabric_setup_discovery_cit(tf);
 	target_fabric_setup_wwn_cit(tf);	
 	target_fabric_setup_tpg_cit(tf);
 	target_fabric_setup_tpg_base_cit(tf);
@@ -606,7 +966,12 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 	target_fabric_setup_tpg_np_base_cit(tf);
 	target_fabric_setup_tpg_attrib_cit(tf);
 	target_fabric_setup_tpg_param_cit(tf);
-	target_fabric_setup_tpg_acl_cit(tf);
+	target_fabric_setup_tpg_nacl_cit(tf);
+	target_fabric_setup_tpg_nacl_base_cit(tf);
+	target_fabric_setup_tpg_nacl_attrib_cit(tf);
+	target_fabric_setup_tpg_nacl_auth_cit(tf);
+	target_fabric_setup_tpg_nacl_param_cit(tf);
+	target_fabric_setup_tpg_mappedlun_cit(tf);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 9ec5cdd..30fefce 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -274,12 +274,9 @@ se_node_acl_t *core_tpg_check_initiator_node_acl(
 	if (!(TPG_TFO(tpg)->tpg_check_demo_mode(tpg)))
 		return NULL;
 
-	acl = kzalloc(sizeof(se_node_acl_t), GFP_KERNEL);
-	if (!(acl)) {
-		printk(KERN_ERR "Unable to allocate memory for"
-			" se_node_acl_t.\n");
+	acl =  TPG_TFO(tpg)->tpg_alloc_fabric_acl(tpg);
+	if (!(acl))
 		return NULL;
-	}
 
 	INIT_LIST_HEAD(&acl->acl_list);
 	spin_lock_init(&acl->device_list_lock);
@@ -293,24 +290,16 @@ se_node_acl_t *core_tpg_check_initiator_node_acl(
 #endif /* SNMP_SUPPORT */
 	acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
 
-	acl->fabric_acl_ptr = TPG_TFO(tpg)->tpg_alloc_fabric_acl(tpg,
-			acl);
-	if (!(acl->fabric_acl_ptr)) {
-		kfree(acl);
-		return NULL;
-	}
 	TPG_TFO(tpg)->set_default_node_attributes(acl);
 
 	if (core_create_device_list_for_node(acl) < 0) {
 		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
-		kfree(acl);
 		return NULL;
 	}
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
 		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
-		kfree(acl);
 		return NULL;
 	}
 
@@ -379,8 +368,9 @@ EXPORT_SYMBOL(core_tpg_clear_object_luns);
  *
  *
  */
-se_node_acl_t *core_tpg_add_initiator_node_acl(
-	se_portal_group_t *tpg,
+struct se_node_acl_s *core_tpg_add_initiator_node_acl(
+	struct se_portal_group_s *tpg,
+	struct se_node_acl_s *se_nacl,
 	const char *initiatorname,
 	u32 queue_depth)
 {
@@ -395,6 +385,14 @@ se_node_acl_t *core_tpg_add_initiator_node_acl(
 				" for %s\n", TPG_TFO(tpg)->get_fabric_name(),
 				TPG_TFO(tpg)->tpg_get_tag(tpg), initiatorname);
 			spin_unlock_bh(&tpg->acl_node_lock);
+			/*
+			 * Release the locally allocated struct se_node_acl_s
+			 * because * core_tpg_add_initiator_node_acl() returned
+			 * a pointer to an existing demo mode node ACL.
+			 */
+			if (se_nacl)
+				TPG_TFO(tpg)->tpg_release_fabric_acl(tpg,
+							se_nacl);
 			goto done;
 		}
 
@@ -407,11 +405,16 @@ se_node_acl_t *core_tpg_add_initiator_node_acl(
 	}
 	spin_unlock_bh(&tpg->acl_node_lock);
 
-	acl = kzalloc(sizeof(se_node_acl_t), GFP_KERNEL);
-	if (!(acl)) {
-		printk(KERN_ERR "Unable to allocate memory for senode_acl_t.\n");
-		return ERR_PTR(-ENOMEM);
+	if (!(se_nacl)) {
+		printk("struct se_node_acl_s pointer is NULL\n");
+		return ERR_PTR(-EINVAL);
 	}
+	/*
+	 * For v4.x logic the se_node_acl_s is hanging off a fabric
+	 * dependent structure allocated via
+	 * struct target_core_fabric_ops->fabric_make_nodeacl()
+	 */
+	acl = se_nacl;
 
 	INIT_LIST_HEAD(&acl->acl_list);
 	spin_lock_init(&acl->device_list_lock);
@@ -423,25 +426,17 @@ se_node_acl_t *core_tpg_add_initiator_node_acl(
 	acl->acl_index = scsi_get_new_index(SCSI_AUTH_INTR_INDEX);
 	spin_lock_init(&acl->stats_lock);
 #endif /* SNMP_SUPPORT */
-
-	acl->fabric_acl_ptr = TPG_TFO(tpg)->tpg_alloc_fabric_acl(tpg,
-			acl);
-	if (!(acl->fabric_acl_ptr)) {
-		kfree(acl);
-		return ERR_PTR(-ENOMEM);
-	}
+	
 	TPG_TFO(tpg)->set_default_node_attributes(acl);
 
 	if (core_create_device_list_for_node(acl) < 0) {
 		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
-		kfree(acl);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
 		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
-		kfree(acl);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -506,9 +501,6 @@ int core_tpg_del_initiator_node_acl(
 	core_clear_initiator_node_from_tpg(acl, tpg);
 	core_free_device_list_for_node(acl, tpg);
 
-	TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
-	acl->fabric_acl_ptr = NULL;
-
 	printk(KERN_INFO "%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
 		" Initiator Node: %s\n", TPG_TFO(tpg)->get_fabric_name(),
 		TPG_TFO(tpg)->tpg_get_tag(tpg), acl->queue_depth,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e140136..4f93184 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -647,11 +647,13 @@ typedef struct se_node_acl_s {
 	struct se_dev_entry_s	*device_list;
 	struct se_session_s	*nacl_sess;
 	struct se_portal_group_s *se_tpg;
-	void			*fabric_acl_ptr;
 	spinlock_t		device_list_lock;
 	spinlock_t		nacl_sess_lock;
 	struct config_group	acl_group;
+	struct config_group	acl_attrib_group;
+	struct config_group	acl_auth_group;
 	struct config_group	acl_param_group;
+	struct config_group	*acl_default_groups[4];
 	struct list_head	acl_list;
 } ____cacheline_aligned se_node_acl_t;
 
diff --git a/include/target/target_core_configfs.h b/include/target/target_core_configfs.h
index 28565a1..77d85e3 100644
--- a/include/target/target_core_configfs.h
+++ b/include/target/target_core_configfs.h
@@ -54,7 +54,12 @@ struct target_fabric_configfs_template {
 	struct config_item_type tfc_tpg_np_base_cit;
 	struct config_item_type tfc_tpg_attrib_cit;
 	struct config_item_type tfc_tpg_param_cit;
-	struct config_item_type tfc_tpg_acl_cit;
+	struct config_item_type tfc_tpg_nacl_cit;
+	struct config_item_type tfc_tpg_nacl_base_cit;
+	struct config_item_type tfc_tpg_nacl_attrib_cit;
+	struct config_item_type tfc_tpg_nacl_auth_cit;
+	struct config_item_type tfc_tpg_nacl_param_cit;
+	struct config_item_type tfc_tpg_mappedlun_cit;
 };
 
 struct target_fabric_configfs {
diff --git a/include/target/target_core_fabric_configfs.h b/include/target/target_core_fabric_configfs.h
index f876f56..c1bb861 100644
--- a/include/target/target_core_fabric_configfs.h
+++ b/include/target/target_core_fabric_configfs.h
@@ -4,6 +4,50 @@
 
 #include <target/configfs_macros.h>
 
+CONFIGFS_EATTR_STRUCT(target_fabric_nacl_attrib, se_node_acl_s);
+#define TF_NACL_ATTRIB_ATTR(_fabric, _name, _mode)			\
+static struct target_fabric_nacl_attrib_attribute _fabric##_nacl_attrib_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_nacl_attrib_show_##_name,				\
+	_fabric##_nacl_attrib_store_##_name);
+
+CONFIGFS_EATTR_STRUCT(target_fabric_nacl_auth, se_node_acl_s);
+#define TF_NACL_AUTH_ATTR(_fabric, _name, _mode)			\
+static struct target_fabric_nacl_auth_attribute _fabric##_nacl_auth_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_nacl_auth_show_##_name,				\
+	_fabric##_nacl_auth_store_##_name);
+
+#define TF_NACL_AUTH_ATTR_RO(_fabric, _name)				\
+static struct target_fabric_nacl_auth_attribute _fabric##_nacl_auth_##_name = \
+	__CONFIGFS_EATTR_RO(_name,					\
+	_fabric##_nacl_auth_show_##_name);
+
+CONFIGFS_EATTR_STRUCT(target_fabric_nacl_param, se_node_acl_s);
+#define TF_NACL_PARAM_ATTR(_fabric, _name, _mode)			\
+static struct target_fabric_nacl_param_attribute _fabric##_nacl_param_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_nacl_param_show_##_name,				\
+	_fabric##_nacl_param_store_##_name);
+
+#define TF_NACL_PARAM_ATTR_RO(_fabric, _name)				\
+static struct target_fabric_nacl_param_attribute _fabric##_nacl_param_##_name = \
+	__CONFIGFS_EATTR_RO(_name,					\
+	_fabric##_nacl_param_show_##_name);
+
+
+CONFIGFS_EATTR_STRUCT(target_fabric_nacl_base, se_node_acl_s);
+#define TF_NACL_BASE_ATTR(_fabric, _name, _mode)			\
+static struct target_fabric_nacl_base_attribute _fabric##_nacl_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_nacl_show_##_name,					\
+	_fabric##_nacl_store_##_name);
+
+#define TF_NACL_BASE_ATTR_RO(_fabric, _name)				\
+static struct target_fabric_nacl_base_attribute _fabric##_nacl_##_name = \
+	__CONFIGFS_EATTR_RO(_name,					\
+	_fabric##_nacl_show_##_name);
+
 CONFIGFS_EATTR_STRUCT(target_fabric_np_base, se_tpg_np_s);
 #define TF_NP_BASE_ATTR(_fabric, _name, _mode)				\
 static struct target_fabric_np_base_attribute _fabric##_np_##_name =	\
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 725a530..b56f7af 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -16,8 +16,9 @@ struct target_core_fabric_ops {
 	int (*tpg_check_demo_mode)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_cache)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group_s *);
-	void *(*tpg_alloc_fabric_acl)(struct se_portal_group_s *,
-					struct se_node_acl_s *);
+	int (*tpg_check_prod_mode_write_protect)(struct se_portal_group_s *);
+	struct se_node_acl_s *(*tpg_alloc_fabric_acl)(
+					struct se_portal_group_s *);
 	void (*tpg_release_fabric_acl)(struct se_portal_group_s *,
 					struct se_node_acl_s *);
 	u32 (*tpg_get_inst_index)(struct se_portal_group_s *);
@@ -74,4 +75,7 @@ struct target_core_fabric_ops {
 	struct se_tpg_np_s *(*fabric_make_np)(struct se_portal_group_s *,
 				struct config_group *, const char *);
 	void (*fabric_drop_np)(struct se_tpg_np_s *);
+	struct se_node_acl_s *(*fabric_make_nodeacl)(struct se_portal_group_s *,
+				struct config_group *, const char *);
+	void (*fabric_drop_nodeacl)(struct se_node_acl_s *);
 };
diff --git a/include/target/target_core_tpg.h b/include/target/target_core_tpg.h
index 8326b8b..a523cbf 100644
--- a/include/target/target_core_tpg.h
+++ b/include/target/target_core_tpg.h
@@ -41,8 +41,10 @@ extern struct se_node_acl_s *core_tpg_check_initiator_node_acl(
 						unsigned char *);
 extern void core_tpg_free_node_acls(struct se_portal_group_s *);
 extern void core_tpg_clear_object_luns(struct se_portal_group_s *);
-extern se_node_acl_t *core_tpg_add_initiator_node_acl(se_portal_group_t *,
-						const char *, u32);
+extern struct se_node_acl_s *core_tpg_add_initiator_node_acl(
+					struct se_portal_group_s *,
+					struct se_node_acl_s *,
+					const char *, u32);
 extern int core_tpg_del_initiator_node_acl(se_portal_group_t *,
 						se_node_acl_t *, int);
 extern int core_tpg_set_initiator_node_queue_depth(se_portal_group_t *,
-- 
1.5.6.5

