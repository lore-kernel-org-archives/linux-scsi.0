From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] [TCM/ConfigFS]: Add generic tfc_discovery_cit to target_core_register_fabric()
Date: Thu, 25 Feb 2010 06:05:25 -0800
Message-ID: <1267106725-7029-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds fabric independent struct config_item_type tfc_discovery_cit to
to target_core_register_fabric() and include/target/target_core_configfs.h:target_fabric_configfs_template
in order to use statically allocated default groups from struct target_fabric_configfs->tf_default_groups[]
for the discovery authentication group in /sys/kernel/config/target/$FABRIC/discovery_auth.

This patch also adds TF_DISC_ATTR() and TF_DISC_ATTR_RO() macros in include/target/target_core_fabric_configfs.h
that are used by fabric module configfs code when setting up fabric dependent attributes for
/sys/kernel/config/target/$FABRIC/discovery_auth.

Also, this patch removes the legacy v3.x method via struct target_fabric_configfs->reg_default_groups_callback()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c        |   25 +++++++++++++++++--------
 include/target/target_core_configfs.h        |    4 +++-
 include/target/target_core_fabric_configfs.h |   12 ++++++++++++
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3d25b61..8655fbf 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -189,14 +189,15 @@ static struct config_group *target_core_register_fabric(
 	 */
 	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n",
 			&TF_CIT_TMPL(tf)->tfc_wwn_cit);
+
+	tf->tf_group.default_groups = tf->tf_default_groups;
+	tf->tf_group.default_groups[0] = &tf->tf_disc_group;
+	tf->tf_group.default_groups[1] = NULL;
+
 	config_group_init_type_name(&tf->tf_group, name,
 			&TF_CIT_TMPL(tf)->tfc_wwn_cit);
-	/*
-	 * Setup any default configfs groups in the top level directory of
-	 * this fabric module.
-	 */
-	if (tf->reg_default_groups_callback != NULL)
-		tf->reg_default_groups_callback(tf);
+	config_group_init_type_name(&tf->tf_disc_group, "discovery_auth",
+			&TF_CIT_TMPL(tf)->tfc_discovery_cit);
 
 	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> Allocated Fabric:"
 			" %s\n", tf->tf_group.cg_item.ci_name);
@@ -220,6 +221,9 @@ static void target_core_deregister_fabric(
 {
 	struct target_fabric_configfs *tf = container_of(
 		to_config_group(item), struct target_fabric_configfs, tf_group);
+	struct config_group *tf_group;
+	struct config_item *df_item;
+	int i;
 
 	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> Looking up %s in"
 		" tf list\n", config_item_name(item));
@@ -234,6 +238,13 @@ static void target_core_deregister_fabric(
 
 	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
 			" %s\n", config_item_name(item));
+
+	tf_group = &tf->tf_group;
+	for (i = 0; tf_group->default_groups[i]; i++) {
+		df_item = &tf_group->default_groups[i]->cg_item;
+		tf_group->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
 	config_item_put(item);
 }
 
@@ -344,7 +355,6 @@ void target_fabric_configfs_free(
 	list_del(&tf->tf_list);
 	mutex_unlock(&g_tf_lock);
 
-	kfree(tf->tf_group.default_groups);
 	kfree(tf);
 }
 EXPORT_SYMBOL(target_fabric_configfs_free);
@@ -443,7 +453,6 @@ void target_fabric_configfs_deregister(
 			" %s\n", tf->tf_name);
 	tf->tf_module = NULL;
 	tf->tf_subsys = NULL;
-	kfree(tf->tf_group.default_groups);
 	kfree(tf);
 
 	printk("<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>"
diff --git a/include/target/target_core_configfs.h b/include/target/target_core_configfs.h
index 0a5a8a4..28565a1 100644
--- a/include/target/target_core_configfs.h
+++ b/include/target/target_core_configfs.h
@@ -44,6 +44,7 @@ extern int target_core_init_configfs(void);
 extern void target_core_exit_configfs(void);
 
 struct target_fabric_configfs_template {
+	struct config_item_type tfc_discovery_cit;
 	struct config_item_type	tfc_wwn_cit;
 	struct config_item_type tfc_tpg_cit;
 	struct config_item_type tfc_tpg_base_cit;
@@ -59,9 +60,10 @@ struct target_fabric_configfs_template {
 struct target_fabric_configfs {
 	char			tf_name[TARGET_FABRIC_NAME_SIZE];
 	atomic_t		tf_access_cnt;
-	void (*reg_default_groups_callback)(struct target_fabric_configfs *);
 	struct list_head	tf_list;
 	struct config_group	tf_group;
+	struct config_group	tf_disc_group;
+	struct config_group	*tf_default_groups[2];
 	/* Pointer to fabric's config_item */
 	struct config_item	*tf_fabric;
 	/* Passed from fabric modules */
diff --git a/include/target/target_core_fabric_configfs.h b/include/target/target_core_fabric_configfs.h
index 6d177ca..f876f56 100644
--- a/include/target/target_core_fabric_configfs.h
+++ b/include/target/target_core_fabric_configfs.h
@@ -47,4 +47,16 @@ static struct target_fabric_wwn_attribute _fabric##_wwn_##_name =	\
 	__CONFIGFS_EATTR_RO(_name,					\
 	_fabric##_wwn_show_attr_##_name);
 
+CONFIGFS_EATTR_STRUCT(target_fabric_discovery, target_fabric_configfs);
+#define TF_DISC_ATTR(_fabric, _name, _mode)				\
+static struct target_fabric_discovery_attribute _fabric##_disc_##_name = \
+	__CONFIGFS_EATTR(_name, _mode,					\
+	_fabric##_disc_show_##_name,					\
+	_fabric##_disc_store_##_name);
+
+#define TF_DISC_ATTR_RO(_fabric, _name)					\
+static struct target_fabric_discovery_attribute _fabric##_disc_##_name = \
+	__CONFIGFS_EATTR_RO(_name,					\
+	_fabric##_disc_show_##_name);					
+
 extern int target_fabric_setup_cits(struct target_fabric_configfs *);
-- 
1.5.6.5

