From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/5] target: Add fabric_stat_group for fabric module statistics default_group
Date: Mon, 28 Feb 2011 16:17:30 -0800
Message-ID: <1298938651-18784-5-git-send-email-nab@linux-iscsi.org>
References: <1298938651-18784-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298938651-18784-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for struct se_wwn->fabric_stat_group in
target_fabric_make_wwn() and target_fabric_drop_wwn() to allow fabric
modules to access fabric_stat_group->default_groups[] for dependent
/sys/kernel/config/target/$FABRIC_WWN/fabric_statistics groups.

It also adds support for struct se_node_acl->acl_fabric_stat_group
in target_fabric_make_nodeacl() to allow fabric modules to access
acl_fabric_stat_group->default_groups[] for fabric dependent fabric
groups as well.

ALso, this includes adding struct target_fabric_configfs_template->
tfc_wwn_fabric_stats_cit and ->tfc_tpg_nacl_stat_cit respectively for
use during target_core_fabric_configfs.c:target_fabric_setup_cits()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   47 +++++++++++++++++++++++++-
 include/target/target_core_base.h            |    5 ++-
 include/target/target_core_configfs.h        |    2 +
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7d58be3..07ab5a3 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -453,6 +453,15 @@ TF_CIT_SETUP(tpg_nacl_base, &target_fabric_nacl_base_item_ops,
 
 /* End of tfc_tpg_nacl_base_cit */
 
+/* Start of tfc_node_fabric_stats_cit */
+/*
+ * This is used as a placeholder for struct se_node_acl->acl_fabric_stat_group
+ * to allow fabrics access to ->acl_fabric_stat_group->default_groups[]
+ */
+TF_CIT_SETUP(tpg_nacl_stat, NULL, NULL, NULL);
+
+/* End of tfc_wwn_fabric_stats_cit */
+
 /* Start of tfc_tpg_nacl_cit */
 
 static struct config_group *target_fabric_make_nodeacl(
@@ -479,7 +488,8 @@ static struct config_group *target_fabric_make_nodeacl(
 	nacl_cg->default_groups[0] = &se_nacl->acl_attrib_group;
 	nacl_cg->default_groups[1] = &se_nacl->acl_auth_group;
 	nacl_cg->default_groups[2] = &se_nacl->acl_param_group;
-	nacl_cg->default_groups[3] = NULL;
+	nacl_cg->default_groups[3] = &se_nacl->acl_fabric_stat_group;
+	nacl_cg->default_groups[4] = NULL;
 
 	config_group_init_type_name(&se_nacl->acl_group, name,
 			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_base_cit);
@@ -489,6 +499,9 @@ static struct config_group *target_fabric_make_nodeacl(
 			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_auth_cit);
 	config_group_init_type_name(&se_nacl->acl_param_group, "param",
 			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_param_cit);
+	config_group_init_type_name(&se_nacl->acl_fabric_stat_group,
+			"fabric_statistics",
+			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_stat_cit);
 
 	return &se_nacl->acl_group;
 }
@@ -1098,6 +1111,15 @@ TF_CIT_SETUP(tpg, &target_fabric_tpg_item_ops, &target_fabric_tpg_group_ops,
 
 /* End of tfc_tpg_cit */
 
+/* Start of tfc_wwn_fabric_stats_cit */
+/*
+ * This is used as a placeholder for struct se_wwn->fabric_stat_group
+ * to allow fabrics access to ->fabric_stat_group->default_groups[]
+ */
+TF_CIT_SETUP(wwn_fabric_stats, NULL, NULL, NULL);
+
+/* End of tfc_wwn_fabric_stats_cit */
+
 /* Start of tfc_wwn_cit */
 
 static struct config_group *target_fabric_make_wwn(
@@ -1118,8 +1140,17 @@ static struct config_group *target_fabric_make_wwn(
 		return ERR_PTR(-EINVAL);
 
 	wwn->wwn_tf = tf;
+	/*
+	 * Setup default groups from pre-allocated wwn->wwn_default_groups
+	 */
+	wwn->wwn_group.default_groups = wwn->wwn_default_groups;
+	wwn->wwn_group.default_groups[0] = &wwn->fabric_stat_group;
+	wwn->wwn_group.default_groups[1] = NULL;
+
 	config_group_init_type_name(&wwn->wwn_group, name,
 			&TF_CIT_TMPL(tf)->tfc_tpg_cit);
+	config_group_init_type_name(&wwn->fabric_stat_group, "fabric_statistics",
+			&TF_CIT_TMPL(tf)->tfc_wwn_fabric_stats_cit);
 
 	return &wwn->wwn_group;
 }
@@ -1128,6 +1159,18 @@ static void target_fabric_drop_wwn(
 	struct config_group *group,
 	struct config_item *item)
 {
+	struct se_wwn *wwn = container_of(to_config_group(item),
+				struct se_wwn, wwn_group);
+	struct config_item *df_item;
+	struct config_group *cg = &wwn->wwn_group;
+	int i;
+
+	for (i = 0; cg->default_groups[i]; i++) {
+		df_item = &cg->default_groups[i]->cg_item;
+		cg->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+
 	config_item_put(item);
 }
 
@@ -1167,6 +1210,7 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 {
 	target_fabric_setup_discovery_cit(tf);
 	target_fabric_setup_wwn_cit(tf);
+	target_fabric_setup_wwn_fabric_stats_cit(tf);
 	target_fabric_setup_tpg_cit(tf);
 	target_fabric_setup_tpg_base_cit(tf);
 	target_fabric_setup_tpg_port_cit(tf);
@@ -1181,6 +1225,7 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 	target_fabric_setup_tpg_nacl_attrib_cit(tf);
 	target_fabric_setup_tpg_nacl_auth_cit(tf);
 	target_fabric_setup_tpg_nacl_param_cit(tf);
+	target_fabric_setup_tpg_nacl_stat_cit(tf);
 	target_fabric_setup_tpg_mappedlun_cit(tf);
 	target_fabric_setup_tpg_mappedlun_stat_cit(tf);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9c2b90c..c15ed50 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -601,7 +601,8 @@ struct se_node_acl {
 	struct config_group	acl_attrib_group;
 	struct config_group	acl_auth_group;
 	struct config_group	acl_param_group;
-	struct config_group	*acl_default_groups[4];
+	struct config_group	acl_fabric_stat_group;
+	struct config_group	*acl_default_groups[5];
 	struct list_head	acl_list;
 	struct list_head	acl_sess_list;
 } ____cacheline_aligned;
@@ -952,6 +953,8 @@ struct se_portal_group {
 struct se_wwn {
 	struct target_fabric_configfs *wwn_tf;
 	struct config_group	wwn_group;
+	struct config_group	*wwn_default_groups[2];
+	struct config_group	fabric_stat_group;
 } ____cacheline_aligned;
 
 struct se_global {
diff --git a/include/target/target_core_configfs.h b/include/target/target_core_configfs.h
index fc3bb9f..6125095 100644
--- a/include/target/target_core_configfs.h
+++ b/include/target/target_core_configfs.h
@@ -14,6 +14,7 @@ extern void target_fabric_configfs_deregister(struct target_fabric_configfs *);
 struct target_fabric_configfs_template {
 	struct config_item_type tfc_discovery_cit;
 	struct config_item_type	tfc_wwn_cit;
+	struct config_item_type tfc_wwn_fabric_stats_cit;
 	struct config_item_type tfc_tpg_cit;
 	struct config_item_type tfc_tpg_base_cit;
 	struct config_item_type tfc_tpg_lun_cit;
@@ -28,6 +29,7 @@ struct target_fabric_configfs_template {
 	struct config_item_type tfc_tpg_nacl_attrib_cit;
 	struct config_item_type tfc_tpg_nacl_auth_cit;
 	struct config_item_type tfc_tpg_nacl_param_cit;
+	struct config_item_type tfc_tpg_nacl_stat_cit;
 	struct config_item_type tfc_tpg_mappedlun_cit;
 	struct config_item_type tfc_tpg_mappedlun_stat_cit;
 };
-- 
1.7.4.1
