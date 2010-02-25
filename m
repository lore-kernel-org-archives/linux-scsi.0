From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] [LIO-Target/ConfigFS]: Convert NodeACl and MappedLUNs to use generic configfs struct config_item_types
Date: Thu, 25 Feb 2010 06:05:39 -0800
Message-ID: <1267106739-7075-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:48685 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932665Ab0BYOFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Feb 2010 09:05:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the iSCSI target fabric module configfs code in iscsi_target_configfs.c
to use new generic configfs infrastructure provided by target_core_fabric_configfs.c for the
handling of NodeACL and MappedLUN config groups.  This patch reproduces the existing v3.x
/sys/kernel/config/target/iscsi layout using the provided TF_* macros with existing code.

This includes the conversion of iscsi_target_configfs.c code to do the following:

*) Use struct target_core_fabric_ops calls lio_target_make_nodeacl() and lio_target_drop_nodeacl()
for handling allocation and release of explict NodeACLs.

*) Setup of existing iSCSI fabric dependent attributes for generic struct config_item_type->ct_attrs[]
in iscsi_target_register_configfs()

*) Convert NodeACL base, param and auth attributes to use TF_NACL_*_ATTR() macros from
target_core_fabric_configfs.h.

*) Setup the iSCSI fabric dependent attributes for the default tfc_discovery_cit attributes
in /sys/kernel/config/target/iscsi/discovery_auth

This patch also removes the following all iSCSI fabric dependent MappedLUN group, link, and
attribute code and the now unused 3.x configfs ACL add/delete functions from iscsi_target_tpg.c
Also all remaining internal usage of struct config_group in iscsi_target_core.h data structures
are now unused and have been removed.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_auth_kernel.h      |    5 +-
 drivers/target/lio-target/iscsi_target_configfs.c  |  956 ++++----------------
 drivers/target/lio-target/iscsi_target_core.h      |    6 +-
 .../target/lio-target/iscsi_target_nodeattrib.c    |    2 +-
 drivers/target/lio-target/iscsi_target_tpg.c       |   58 +-
 drivers/target/lio-target/iscsi_target_tpg.h       |    4 +-
 6 files changed, 216 insertions(+), 815 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_auth_kernel.h b/drivers/target/lio-target/iscsi_auth_kernel.h
index aa6f31e..3ac48b0 100644
--- a/drivers/target/lio-target/iscsi_auth_kernel.h
+++ b/drivers/target/lio-target/iscsi_auth_kernel.h
@@ -100,7 +100,8 @@ u32 iscsi_handle_authentication(
 					" CHAP auth\n");
 			return -1;
 		}
-		iscsi_nacl = (iscsi_node_acl_t *)se_nacl->fabric_acl_ptr;
+		iscsi_nacl = container_of(se_nacl, iscsi_node_acl_t,
+				se_node_acl);
 		if (!(iscsi_nacl)) {
 			printk(KERN_ERR "Unable to locate iscsi_node_acl_t for"
 					" CHAP auth\n");
@@ -112,7 +113,7 @@ u32 iscsi_handle_authentication(
 		/*
 		 * For SessionType=Discovery
 		 */
-		auth = &iscsi_global->discovery_auth;	
+		auth = &iscsi_global->discovery_acl.node_auth;	
 	}
 
 #ifdef SNMP_SUPPORT
diff --git a/drivers/target/lio-target/iscsi_target_configfs.c b/drivers/target/lio-target/iscsi_target_configfs.c
index ee078d8..da55e57 100644
--- a/drivers/target/lio-target/iscsi_target_configfs.c
+++ b/drivers/target/lio-target/iscsi_target_configfs.c
@@ -311,23 +311,25 @@ out:
 /* Start items for lio_target_nacl_attrib_cit */
 
 #define DEF_NACL_ATTRIB(name)						\
-static ssize_t lio_target_show_nacl_attrib_##name(			\
-	struct iscsi_node_attrib_s *na,					\
+static ssize_t iscsi_nacl_attrib_show_##name(				\
+	struct se_node_acl_s *se_nacl,					\
 	char *page)							\
 {									\
-	iscsi_node_acl_t *nacl = na->nacl;				\
+	iscsi_node_acl_t *nacl = container_of(se_nacl, iscsi_node_acl_t, \
+					se_node_acl);			\
 	ssize_t rb;							\
 									\
 	rb = sprintf(page, "%u\n", ISCSI_NODE_ATTRIB(nacl)->name);	\
 	return rb;							\
 }									\
 									\
-static ssize_t lio_target_store_nacl_attrib_##name(			\
-	struct iscsi_node_attrib_s *na,					\
+static ssize_t iscsi_nacl_attrib_store_##name(				\
+	struct se_node_acl_s *se_nacl,					\
 	const char *page,						\
 	size_t count)							\
 {									\
-	iscsi_node_acl_t *nacl = na->nacl;				\
+	iscsi_node_acl_t *nacl = container_of(se_nacl, iscsi_node_acl_t, \
+					se_node_acl);			\
 	char *endptr;							\
 	u32 val;							\
 	int ret;							\
@@ -340,16 +342,7 @@ static ssize_t lio_target_store_nacl_attrib_##name(			\
 	return count;							\
 }
 
-/*
- * Define the iSCSI Node attributes using hybrid wrappers from
- * include/linux/configfs.h
- */
-CONFIGFS_EATTR_STRUCT(iscsi_node_attrib, iscsi_node_attrib_s);
-#define NACL_ATTR(_name, _mode)						\
-static struct iscsi_node_attrib_attribute iscsi_node_attrib_##_name =	\
-		__CONFIGFS_EATTR(_name, _mode,				\
-		lio_target_show_nacl_attrib_##_name,			\
-		lio_target_store_nacl_attrib_##_name);
+#define NACL_ATTR(_name, _mode) TF_NACL_ATTRIB_ATTR(iscsi, _name, _mode);
 /*
  * Define iscsi_node_attrib_s_dataout_timeout
  */
@@ -390,44 +383,29 @@ NACL_ATTR(random_datain_seq_offsets, S_IRUGO | S_IWUSR);
  */
 DEF_NACL_ATTRIB(random_r2t_offsets);
 NACL_ATTR(random_r2t_offsets, S_IRUGO | S_IWUSR);
-/*
- * Finally, define functions iscsi_node_attrib_s_attr_show() and
- * iscsi_node_attrib_s_attr_store() for lio_target_nacl_attrib_ops below..
- */
-CONFIGFS_EATTR_OPS(iscsi_node_attrib, iscsi_node_attrib_s, acl_attrib_group);
 
 static struct configfs_attribute *lio_target_nacl_attrib_attrs[] = {
-	&iscsi_node_attrib_dataout_timeout.attr,
-	&iscsi_node_attrib_dataout_timeout_retries.attr,
-	&iscsi_node_attrib_default_erl.attr,
-	&iscsi_node_attrib_nopin_timeout.attr,
-	&iscsi_node_attrib_nopin_response_timeout.attr,
-	&iscsi_node_attrib_random_datain_pdu_offsets.attr,
-	&iscsi_node_attrib_random_datain_seq_offsets.attr,
-	&iscsi_node_attrib_random_r2t_offsets.attr,
+	&iscsi_nacl_attrib_dataout_timeout.attr,
+	&iscsi_nacl_attrib_dataout_timeout_retries.attr,
+	&iscsi_nacl_attrib_default_erl.attr,
+	&iscsi_nacl_attrib_nopin_timeout.attr,
+	&iscsi_nacl_attrib_nopin_response_timeout.attr,
+	&iscsi_nacl_attrib_random_datain_pdu_offsets.attr,
+	&iscsi_nacl_attrib_random_datain_seq_offsets.attr,
+	&iscsi_nacl_attrib_random_r2t_offsets.attr,
 	NULL,
 };
 
-static struct configfs_item_operations lio_target_nacl_attrib_ops = {
-	.show_attribute		= iscsi_node_attrib_attr_show,
-	.store_attribute	= iscsi_node_attrib_attr_store,
-};
-
-static struct config_item_type lio_target_nacl_attrib_cit = {
-	.ct_item_ops	= &lio_target_nacl_attrib_ops,
-	.ct_attrs	= lio_target_nacl_attrib_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_nacl_attrib_cit */
 
 /* Start items for lio_target_nacl_auth_cit */
 
-#define DEF_NACL_AUTH_STR(name, flags)					\
-static ssize_t lio_target_show_nacl_auth_##name(			\
-	struct iscsi_node_auth_s *auth,					\
+#define __DEF_NACL_AUTH_STR(prefix, name, flags)			\
+static ssize_t __iscsi_##prefix##_show_##name(				\
+	struct iscsi_node_acl_s *nacl,					\
 	char *page)							\
 {									\
+	struct iscsi_node_auth_s *auth = &nacl->node_auth;		\
 	ssize_t rb;							\
 									\
 	if (!capable(CAP_SYS_ADMIN))					\
@@ -435,11 +413,14 @@ static ssize_t lio_target_show_nacl_auth_##name(			\
 	rb = snprintf(page, PAGE_SIZE, "%s\n", auth->name);		\
 	return rb;							\
 }									\
-static ssize_t lio_target_store_nacl_auth_##name(			\
-	struct iscsi_node_auth_s *auth,					\
+									\
+static ssize_t __iscsi_##prefix##_store_##name(				\
+	struct iscsi_node_acl_s *nacl,					\
 	const char *page,						\
 	size_t count)							\
 {									\
+	struct iscsi_node_auth_s *auth = &nacl->node_auth;		\
+									\
 	if (!capable(CAP_SYS_ADMIN))					\
 		return -EPERM;						\
 									\
@@ -458,11 +439,12 @@ static ssize_t lio_target_store_nacl_auth_##name(			\
 	return count;							\
 }
 
-#define DEF_NACL_AUTH_INT(name)						\
-static ssize_t lio_target_show_nacl_auth_##name(			\
-	struct iscsi_node_auth_s *auth,					\
+#define __DEF_NACL_AUTH_INT(prefix, name)				\
+static ssize_t __iscsi_##prefix##_show_##name(				\
+	struct iscsi_node_acl_s *nacl,					\
 	char *page)							\
 {									\
+	struct iscsi_node_auth_s *auth = &nacl->node_auth;		\
 	ssize_t rb;							\
 									\
 	if (!capable(CAP_SYS_ADMIN))					\
@@ -472,17 +454,37 @@ static ssize_t lio_target_show_nacl_auth_##name(			\
 	return rb;							\
 }
 
-CONFIGFS_EATTR_STRUCT(iscsi_node_auth, iscsi_node_auth_s);
-#define AUTH_ATTR(_name, _mode)						\
-static struct iscsi_node_auth_attribute iscsi_node_auth_##_name =	\
-		__CONFIGFS_EATTR(_name, _mode,				\
-		lio_target_show_nacl_auth_##_name,			\
-		lio_target_store_nacl_auth_##_name);
-
-#define AUTH_ATTR_RO(_name)						\
-static struct iscsi_node_auth_attribute iscsi_node_auth_##_name =	\
-		__CONFIGFS_EATTR_RO(_name,				\
-		lio_target_show_nacl_auth_##_name);
+#define DEF_NACL_AUTH_STR(name, flags)					\
+	__DEF_NACL_AUTH_STR(nacl_auth, name, flags)			\
+static ssize_t iscsi_nacl_auth_show_##name(				\
+	struct se_node_acl_s *nacl,					\
+	char *page)							\
+{									\
+	return __iscsi_nacl_auth_show_##name(container_of(nacl,		\
+			iscsi_node_acl_t, se_node_acl), page);		\
+}									\
+static ssize_t iscsi_nacl_auth_store_##name(				\
+	struct se_node_acl_s *nacl,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	return __iscsi_nacl_auth_store_##name(container_of(nacl,	\
+			iscsi_node_acl_t, se_node_acl), page, count);	\
+}
+
+#define DEF_NACL_AUTH_INT(name)						\
+	__DEF_NACL_AUTH_INT(nacl_auth, name)				\
+static ssize_t iscsi_nacl_auth_show_##name(				\
+	struct se_node_acl_s *nacl,					\
+	char *page)							\
+{									\
+	return __iscsi_nacl_auth_show_##name(container_of(nacl,		\
+			iscsi_node_acl_t, se_node_acl), page);		\
+}
+
+#define AUTH_ATTR(_name, _mode)	TF_NACL_AUTH_ATTR(iscsi, _name, _mode);
+#define AUTH_ATTR_RO(_name) TF_NACL_AUTH_ATTR_RO(iscsi, _name);
+
 /*
  * One-way authentication userid
  */
@@ -509,34 +511,21 @@ AUTH_ATTR(userid_mutual, S_IRUGO | S_IWUSR);
 DEF_NACL_AUTH_STR(password_mutual, NAF_PASSWORD_IN_SET);
 AUTH_ATTR(password_mutual, S_IRUGO | S_IWUSR);
 
-CONFIGFS_EATTR_OPS(iscsi_node_auth, iscsi_node_auth_s, auth_attrib_group);
-
 static struct configfs_attribute *lio_target_nacl_auth_attrs[] = {
-	&iscsi_node_auth_userid.attr,
-	&iscsi_node_auth_password.attr,
-	&iscsi_node_auth_authenticate_target.attr,
-	&iscsi_node_auth_userid_mutual.attr,
-	&iscsi_node_auth_password_mutual.attr,
+	&iscsi_nacl_auth_userid.attr,
+	&iscsi_nacl_auth_password.attr,
+	&iscsi_nacl_auth_authenticate_target.attr,
+	&iscsi_nacl_auth_userid_mutual.attr,
+	&iscsi_nacl_auth_password_mutual.attr,
 	NULL,
 };
 
-static struct configfs_item_operations lio_target_nacl_auth_ops = {
-	.show_attribute		= iscsi_node_auth_attr_show,
-	.store_attribute	= iscsi_node_auth_attr_store,
-};
-
-static struct config_item_type lio_target_nacl_auth_cit = {
-	.ct_item_ops	= &lio_target_nacl_auth_ops,
-	.ct_attrs	= lio_target_nacl_auth_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_nacl_auth_cit */
 
 /* Start items for lio_target_nacl_param_cit */
 
 #define DEF_NACL_PARAM(name)						\
-static ssize_t lio_target_show_nacl_param_##name(			\
+static ssize_t iscsi_nacl_param_show_##name(				\
 	struct se_node_acl_s *se_nacl,					\
 	char *page)							\
 {									\
@@ -559,11 +548,7 @@ static ssize_t lio_target_show_nacl_param_##name(			\
 	return rb;							\
 }
 
-CONFIGFS_EATTR_STRUCT(iscsi_nacl_param, se_node_acl_s);
-#define NACL_PARAM_ATTR(_name)						\
-static struct iscsi_nacl_param_attribute iscsi_nacl_param_##_name =	\
-		__CONFIGFS_EATTR_RO(_name,				\
-		lio_target_show_nacl_param_##_name);			\
+#define NACL_PARAM_ATTR(_name) TF_NACL_PARAM_ATTR_RO(iscsi, _name);
 
 DEF_NACL_PARAM(MaxConnections);
 NACL_PARAM_ATTR(MaxConnections);
@@ -598,8 +583,6 @@ NACL_PARAM_ATTR(DataSequenceInOrder);
 DEF_NACL_PARAM(ErrorRecoveryLevel);
 NACL_PARAM_ATTR(ErrorRecoveryLevel);
 
-CONFIGFS_EATTR_OPS_RO(iscsi_nacl_param, se_node_acl_s, acl_param_group);
-
 static struct configfs_attribute *lio_target_nacl_param_attrs[] = {
 	&iscsi_nacl_param_MaxConnections.attr,
 	&iscsi_nacl_param_InitialR2T.attr,
@@ -615,394 +598,16 @@ static struct configfs_attribute *lio_target_nacl_param_attrs[] = {
 	NULL,
 };
 
-static struct configfs_item_operations lio_target_nacl_param_ops = {
-	.show_attribute		= iscsi_nacl_param_attr_show,
-	.store_attribute	= NULL,
-};
-
-static struct config_item_type lio_target_nacl_param_cit = {
-	.ct_item_ops	= &lio_target_nacl_param_ops,
-	.ct_attrs	= lio_target_nacl_param_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_nacl_param_cit */
 
-/* Start items for lio_target_initiator_cit */
-
-static int lio_target_initiator_lacl_link(
-	struct config_item *lun_acl_ci,
-	struct config_item *lun_ci)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_dev_entry_t *deve;
-	se_lun_t *lun;
-	se_lun_acl_t *lacl;
-	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *tiqn_ci, *tiqn_ci_s;
-	int ret = 0, lun_access;
-
-	nacl_ci = &lun_acl_ci->ci_parent->ci_group->cg_item;
-	if (!(nacl_ci)) {
-		printk(KERN_ERR "Unable to locate config_item nacl_ci\n");
-		return -EINVAL;
-	}
-	tpg_ci = &nacl_ci->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return -EINVAL;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return -EINVAL;
-	}
-	tpg_ci_s = &lun_ci->ci_parent->ci_group->cg_item;
-	if (!(tpg_ci_s)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci_s\n");
-		return -EINVAL;
-	}
-	tiqn_ci_s = &tpg_ci_s->ci_group->cg_item;
-	if (!(tiqn_ci_s)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci_s\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * Make sure the SymLink is going to the same iscsi/$IQN/$TPGT
-	 */
-	if (strcmp(config_item_name(tiqn_ci), config_item_name(tiqn_ci_s))) {
-		printk(KERN_ERR "Illegal Initiator ACL SymLink outside of %s\n",
-			config_item_name(tiqn_ci));
-		return -EINVAL;
-	}
-	if (strcmp(config_item_name(tpg_ci), config_item_name(tpg_ci_s))) {
-		printk(KERN_ERR "Illegal Initiator ACL Symlink outside of %s"
-			" TPGT: %s\n", config_item_name(tiqn_ci),
-			config_item_name(tpg_ci));
-		return -EINVAL;
-	}
-	/*
-	 * Now that we have validated the iscsi/$IQN/$TPGT patch,
-	 * grab the se_lun_t
-	 */
-	lacl = container_of(to_config_group(lun_acl_ci), se_lun_acl_t,
-			se_lun_group);
-	if (!(lacl)) {
-		printk(KERN_ERR "Unable to locate se_lun_acl_t\n");
-		return -EINVAL;
-	}
-	lun = container_of(to_config_group(lun_ci), se_lun_t, lun_group);
-	if (!(lun)) {
-		printk(KERN_ERR "Unable to locate se_lun_t\n");
-		return -EINVAL;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
-		return -EINVAL;
-
-	/*
-	 * If this iscsi_node_acl was dynamically generated with
-	 * tpg_1/attrib/generate_node_acls=1, use the existing deve->lun_flags,
-	 * which be will write protected (READ-ONLY) when
-	 * tpg_1/attrib/demo_mode_write_protect=1
-	 */
-	spin_lock_bh(&lacl->se_lun_nacl->device_list_lock);
-	deve = &lacl->se_lun_nacl->device_list[lacl->mapped_lun];
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
-		lun_access = deve->lun_flags;
-	else
-		lun_access = (ISCSI_TPG_ATTRIB(tpg)->prod_mode_write_protect) ?
-			TRANSPORT_LUNFLAGS_READ_ONLY :
-			TRANSPORT_LUNFLAGS_READ_WRITE;
-	spin_unlock_bh(&lacl->se_lun_nacl->device_list_lock);
-
-	/*
-	 * Determine the actual mapped LUN value user wants..
-	 *
-	 * This value is what the iSCSI Initiator actually sees the
-	 * iscsi/$IQN/$TPGT/lun/lun_* as on their iSCSI Initiator Ports.
-	 */
-	ret = core_dev_add_initiator_node_lun_acl(&tpg->tpg_se_tpg, lacl,
-				lun->unpacked_lun, lun_access);
-	if (ret < 0)
-		goto out;
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: Created Initiator LUN ACL"
-		" Symlink: %s TPG LUN: %s Mapped LUN: %s Write Protect: %s\n",
-		lacl->initiatorname, config_item_name(lun_ci),
-		config_item_name(lun_acl_ci),
-		(lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ? "ON" : "OFF");
-
-	iscsi_put_tpg(tpg);
-	return 0;
-out:
-	iscsi_put_tpg(tpg);
-	return ret;
-}
-
-static int lio_target_initiator_lacl_unlink(
-	struct config_item *lun_acl_ci,
-	struct config_item *lun_ci)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_lun_t *lun;
-	se_lun_acl_t *lacl;
-	struct config_item *nacl_ci, *tpg_ci, *tiqn_ci;
-	int ret = 0;
-
-	nacl_ci = &lun_acl_ci->ci_parent->ci_group->cg_item;
-	if (!(nacl_ci)) {
-		printk(KERN_ERR "Unable to locate config_item nacl_ci\n");
-		return -EINVAL;
-	}
-	tpg_ci = &nacl_ci->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return -EINVAL;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return -EINVAL;
-	}
-	lacl = container_of(to_config_group(lun_acl_ci), se_lun_acl_t,
-			se_lun_group);
-	if (!(lacl)) {
-		printk(KERN_ERR "Unable to locate se_lun_acl_t\n");
-		return -EINVAL;
-	}
-	lun = container_of(to_config_group(lun_ci), se_lun_t, lun_group);
-	if (!(lun)) {
-		printk(KERN_ERR "Unable to locate se_lun_t\n");
-		return -EINVAL;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
-		return -EINVAL;
-
-	ret = core_dev_del_initiator_node_lun_acl(&tpg->tpg_se_tpg, lun, lacl);
-	if (ret < 0)
-		goto out;
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: Removed Initiator LUN ACL"
-		" Symlink: %s TPG LUN: %s Mapped LUN: %s\n",
-		lacl->initiatorname, config_item_name(lun_acl_ci),
-		config_item_name(lun_ci));
-
-	iscsi_put_tpg(tpg);
-	return 0;
-out:
-	iscsi_put_tpg(tpg);
-	return ret;
-}
+/* Start items for lio_target_acl_cit */
 
-/*
- * Define the LUN ACL Attributes using configfs extended attributes.
- */
-CONFIGFS_EATTR_STRUCT(lio_target_lacl, se_lun_acl_s);
-#define LACL_ATTR(_name, _mode)					\
-static struct lio_target_lacl_attribute lacl_attrib_##_name =	\
-	__CONFIGFS_EATTR(_name, _mode,				\
-	lacl_show_attrib_##_name,				\
-	lacl_store_attrib_##_name);
-
-static ssize_t lacl_show_attrib_write_protect(
-	struct se_lun_acl_s *lacl,
+static ssize_t lio_target_nacl_show_info(
+	struct se_node_acl_s *se_nacl,
 	char *page)
 {
-	se_node_acl_t *nacl = lacl->se_lun_nacl;
-	se_dev_entry_t *deve;
-	ssize_t len;
-
-	spin_lock_bh(&nacl->device_list_lock);
-	deve = &nacl->device_list[lacl->mapped_lun];
-	len = sprintf(page, "%d\n",
-			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
-			1 : 0);
-	spin_unlock_bh(&nacl->device_list_lock);
-
-	return len;
-}
-
-static ssize_t lacl_store_attrib_write_protect(
-	struct se_lun_acl_s *lacl,
-	const char *page,
-	size_t count)
-{
-	char *endptr;
-	u32 op;
-
-	op = simple_strtoul(page, &endptr, 0);
-	if ((op != 1) && (op != 0)) {
-		printk(KERN_ERR "Illegal value for access: %u\n", op);
-		return -EINVAL;
-	}
-	core_update_device_list_access(lacl->mapped_lun, (op) ?
-			TRANSPORT_LUNFLAGS_READ_ONLY :
-			TRANSPORT_LUNFLAGS_READ_WRITE,
-			lacl->se_lun_nacl);
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: Changed Initiator ACL: %s"
-		" Mapped LUN: %u Write Protect bit to %s\n",
-		lacl->initiatorname, lacl->mapped_lun, (op) ? "ON" : "OFF");
-
-	return count;
-}
-
-LACL_ATTR(write_protect, S_IRUGO | S_IWUSR);
-
-CONFIGFS_EATTR_OPS(lio_target_lacl, se_lun_acl_s, se_lun_group)
-
-static struct configfs_attribute *lio_target_initiator_lacl_attrs[] = {
-	&lacl_attrib_write_protect.attr,
-	NULL,
-};
-
-static struct configfs_item_operations lio_target_initiator_lacl_item_ops = {
-	.show_attribute		= lio_target_lacl_attr_show,
-	.store_attribute	= lio_target_lacl_attr_store,
-	.allow_link		= lio_target_initiator_lacl_link,
-	.drop_link		= lio_target_initiator_lacl_unlink,
-};
-
-static struct config_item_type lio_target_initiator_lacl_cit = {
-	.ct_item_ops		= &lio_target_initiator_lacl_item_ops,
-	.ct_attrs		= lio_target_initiator_lacl_attrs,
-	.ct_owner		= THIS_MODULE,
-};
-
-static struct config_group *lio_target_initiator_lacl_make_group(
-	struct config_group *group,
-	const char *name)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_lun_acl_t *lacl;
-	struct config_item *acl_ci, *tpg_ci, *tiqn_ci;
-	char *buf, *endptr, *ptr;
-	u32 mapped_lun;
-	int ret = 0;
-
-	acl_ci = &group->cg_item;
-	if (!(acl_ci)) {
-		printk(KERN_ERR "Unable to locatel acl_ci\n");
-		return NULL;
-	}
-	tpg_ci = &acl_ci->ci_parent->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate tpg_ci\n");
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
-	buf = kzalloc(strlen(name) + 1, GFP_KERNEL);
-	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for name buf\n");
-		goto out;
-	}
-	snprintf(buf, strlen(name) + 1, "%s", name);
-	/*
-	 * Make sure user is creating iscsi/$IQN/$TPGT/acls/$INITIATOR/lun_$ID.
-	 */
-	ptr = strstr(buf, "lun_");
-	if (!(ptr)) {
-		printk(KERN_ERR "Unable to locate \"lun_\" from buf: %s"
-			" name: %s\n", buf, name);
-		goto out;
-	}
-	ptr += 3; /* Skip to "_" */
-	*ptr = '\0'; /* Terminate the string */
-	ptr++; /* Advance pointer to next characater */
-
-	/*
-	 * Determine the Mapped LUN value.  This is what the iSCSI Initiator
-	 * will actually see.
-	 */
-	mapped_lun = simple_strtoul(ptr, &endptr, 0);
-
-	lacl = core_dev_init_initiator_node_lun_acl(&tpg->tpg_se_tpg,
-			mapped_lun, config_item_name(acl_ci), &ret);
-	if (!(lacl))
-		goto out;
-
-	config_group_init_type_name(&lacl->se_lun_group, name,
-			&lio_target_initiator_lacl_cit);
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: Initialized Initiator LUN ACL:"
-		" %s Mapped LUN: %s\n", config_item_name(acl_ci), name);
-
-	kfree(buf);
-	iscsi_put_tpg(tpg);
-	return &lacl->se_lun_group;
-out:
-	kfree(buf);
-	iscsi_put_tpg(tpg);
-	return NULL;
-}
-
-static void lio_target_initiator_lacl_drop_item(
-	struct config_group *group,
-	struct config_item *item)
-{
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_lun_acl_t *lacl;
-	struct config_item *acl_ci, *tpg_ci, *tiqn_ci;
-
-	acl_ci = &group->cg_item;
-	if (!(acl_ci)) {
-		printk(KERN_ERR "Unable to locatel acl_ci\n");
-		return;
-	}
-	tpg_ci = &acl_ci->ci_parent->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate tpg_ci\n");
-		return;
-	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
-		return;
-	}
-
-	lacl = container_of(to_config_group(item), se_lun_acl_t,
-				se_lun_group);
-	if (!(lacl)) {
-		printk(KERN_ERR "Unable to locate se_lun_acl_t\n");
-		return;
-	}
-
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
-		return;
-
-	printk(KERN_INFO "LIO_Target_ConfigFS: Freeing Initiator LUN ACL:"
-		" %s Mapped LUN: %s\n", lacl->initiatorname,
-		config_item_name(item));
-
-	config_item_put(item);
-
-	core_dev_free_initiator_node_lun_acl(&tpg->tpg_se_tpg, lacl);
-	iscsi_put_tpg(tpg);
-}
-
-static ssize_t lio_target_initiator_nacl_info(void *p, char *page)
-{
 	iscsi_session_t *sess;
 	iscsi_conn_t *conn;
-	se_node_acl_t *se_nacl = (se_node_acl_t *)p;
 	se_session_t *se_sess;
 	unsigned char *ip, buf_ipv4[IPV4_BUF_SIZE];
 	ssize_t rb = 0;
@@ -1125,30 +730,24 @@ static ssize_t lio_target_initiator_nacl_info(void *p, char *page)
 	return rb;
 }
 
-static struct lio_target_configfs_attribute lio_target_attr_initiator_info = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "info",
-		    .ca_mode = S_IRUGO },
-	.show	= lio_target_initiator_nacl_info,
-	.store	= NULL,
-};
+TF_NACL_BASE_ATTR_RO(lio_target, info);
 
-static ssize_t lio_target_initiator_nacl_cmdsn_window_show(void *p, char *page)
+static ssize_t lio_target_nacl_show_cmdsn_depth(
+	struct se_node_acl_s *se_nacl,
+	char *page)
 {
-	se_node_acl_t *se_nacl = (se_node_acl_t *)p;
-
 	return sprintf(page, "%u\n", se_nacl->queue_depth);
 }
 
-static ssize_t lio_target_initiator_nacl_cmdsn_window_store(
-	void *p,
+static ssize_t lio_target_nacl_store_cmdsn_depth(
+	struct se_node_acl_s *se_nacl,
 	const char *page,
 	size_t count)
 {
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_node_acl_t *se_nacl = (se_node_acl_t *)p;
-	struct config_item *acl_ci, *tpg_ci, *tiqn_ci;
+	struct se_portal_group_s *se_tpg = se_nacl->se_tpg;
+	iscsi_portal_group_t *tpg = container_of(se_tpg,
+			iscsi_portal_group_t, tpg_se_tpg);
+	struct config_item *acl_ci, *tpg_ci, *wwn_ci;
 	char *endptr;
 	u32 cmdsn_depth = 0;
 	int ret = 0;
@@ -1170,16 +769,14 @@ static ssize_t lio_target_initiator_nacl_cmdsn_window_store(
 		printk(KERN_ERR "Unable to locate tpg_ci\n");
 		return -EINVAL;
 	}
-	tiqn_ci = &tpg_ci->ci_group->cg_item;
-	if (!(tiqn_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tiqn_ci\n");
+	wwn_ci = &tpg_ci->ci_group->cg_item;
+	if (!(wwn_ci)) {
+		printk(KERN_ERR "Unable to locate config_item wwn_ci\n");
 		return -EINVAL;
 	}
 
-	tpg = lio_get_tpg_from_tpg_item(tpg_ci, &tiqn);
-	if (!(tpg))
+	if (iscsi_get_tpg(tpg) < 0)
 		return -EINVAL;
-
 	/*
 	 * iscsi_tpg_set_initiator_node_queue_depth() assumes force=1
 	 */
@@ -1187,7 +784,7 @@ static ssize_t lio_target_initiator_nacl_cmdsn_window_store(
 				config_item_name(acl_ci), cmdsn_depth, 1);
 
 	printk(KERN_INFO "LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
-		"InitiatorName: %s\n", config_item_name(tiqn_ci),
+		"InitiatorName: %s\n", config_item_name(wwn_ci),
 		config_item_name(tpg_ci), cmdsn_depth,
 		config_item_name(acl_ci));
 
@@ -1195,233 +792,54 @@ static ssize_t lio_target_initiator_nacl_cmdsn_window_store(
 	return (!ret) ? count : (ssize_t)ret;
 }
 
-static struct lio_target_configfs_attribute
-				lio_target_attr_initiator_control = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "cmdsn_depth",
-		    .ca_mode = S_IRUGO | S_IWUSR },
-	.show	= lio_target_initiator_nacl_cmdsn_window_show,
-	.store	= lio_target_initiator_nacl_cmdsn_window_store,
-};
-
-static void lio_target_initiator_nacl_release(struct config_item *item)
-{
-	se_node_acl_t *se_nacl = container_of(
-			to_config_group(item), se_node_acl_t, acl_group);
-	struct config_group *nacl_cg;
-
-	if (!(se_nacl))
-		return;
-
-	nacl_cg = &se_nacl->acl_group;
-	kfree(nacl_cg->default_groups);
-}
-
-static ssize_t lio_target_initiator_nacl_show(
-	struct config_item *item,
-	struct configfs_attribute *attr,
-	char *page)
-{
-	se_node_acl_t *se_nacl = container_of(
-			to_config_group(item), se_node_acl_t, acl_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->show))
-		return -EINVAL;
-
-	return lt_attr->show((void *)se_nacl, page);
-}
-
-static ssize_t lio_target_initiator_nacl_store(
-	struct config_item *item,
-	struct configfs_attribute *attr,
-	const char *page,
-	size_t count)
-{
-	se_node_acl_t *se_nacl = container_of(
-			to_config_group(item), se_node_acl_t, acl_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->store))
-		return -EINVAL;
-
-	return lt_attr->store((void *)se_nacl, page, count);
-}
+TF_NACL_BASE_ATTR(lio_target, cmdsn_depth, S_IRUGO | S_IWUSR);
 
 static struct configfs_attribute *lio_target_initiator_attrs[] = {
-	&lio_target_attr_initiator_info.attr,
-	&lio_target_attr_initiator_control.attr,
+	&lio_target_nacl_info.attr,
+	&lio_target_nacl_cmdsn_depth.attr,
 	NULL,
 };
 
-static struct configfs_item_operations lio_target_initiator_item_ops = {
-	.release		= lio_target_initiator_nacl_release,
-	.show_attribute		= lio_target_initiator_nacl_show,
-	.store_attribute	= lio_target_initiator_nacl_store,
-};
-
-static struct configfs_group_operations lio_target_initiator_group_ops = {
-	.make_group		= lio_target_initiator_lacl_make_group,
-	.drop_item		= lio_target_initiator_lacl_drop_item,
-};
-
-static struct config_item_type lio_target_initiator_cit = {
-	.ct_item_ops		= &lio_target_initiator_item_ops,
-	.ct_group_ops		= &lio_target_initiator_group_ops,
-	.ct_attrs		= lio_target_initiator_attrs,
-	.ct_owner		= THIS_MODULE,
-};
-
-/* End items for lio_target_initiator_cit */
-
-/* Start items for lio_target_acl_cit */
-
-static struct config_group *lio_target_call_addnodetotpg(
+static struct se_node_acl_s *lio_target_make_nodeacl(
+	struct se_portal_group_s *se_tpg,
 	struct config_group *group,
 	const char *name)
 {
-	iscsi_node_acl_t *acl;
-	iscsi_node_attrib_t *nattr;
-	iscsi_node_auth_t *auth;
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_node_acl_t *se_nacl;
-	struct config_group *nacl_cg;
-	struct config_item *acl_ci, *tpg_ci, *tiqn_ci;
+	struct iscsi_node_acl_s *acl;
+	struct se_node_acl_s *se_nacl_new, *se_nacl;
+	struct iscsi_portal_group_s *tpg = container_of(se_tpg,
+			struct iscsi_portal_group_s, tpg_se_tpg);
 	u32 cmdsn_depth;
 
-	acl_ci = &group->cg_item;
-	if (!(acl_ci)) {
-		printk(KERN_ERR "Unable to locate config_item acl_ci_ci\n");
-		return NULL;
-	}
-	tpg_ci = &acl_ci->ci_group->cg_item;
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
-	/*
-	 * ISCSI_TPG_ATTRIB(tpg)->default_cmdsn is used for the default.
-	 * This can be changed in either with or without an active session.
-	 * $FABRIC/$IQN/$TPGT/acl/$INITIATOR_IQN/cmdsn_depth
-	 */
-	cmdsn_depth = ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
-
-	acl = iscsi_tpg_add_initiator_node_acl(tpg, name, cmdsn_depth);
-	if (!(acl))
-		goto out;
+	se_nacl_new = lio_tpg_alloc_fabric_acl(se_tpg);
 
-	se_nacl = acl->se_node_acl;
-	nacl_cg = &se_nacl->acl_group;
-	nattr = &acl->node_attrib;
-	auth = &acl->node_auth;
+	acl = container_of(se_nacl_new, struct iscsi_node_acl_s,
+				se_node_acl);
 
+	cmdsn_depth = ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
 	/*
-	 * Create the default groups for iscsi_node_acl_t
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NdoeACL from demo mode -> explict
 	 */
-	nacl_cg->default_groups = kzalloc(sizeof(struct config_group) * 4,
-			GFP_KERNEL);
-	if (!(nacl_cg->default_groups))
-		goto node_out;
-
-	config_group_init_type_name(&se_nacl->acl_group, name,
-			&lio_target_initiator_cit);
-	config_group_init_type_name(&se_nacl->acl_param_group, "param",
-			&lio_target_nacl_param_cit);
-	config_group_init_type_name(&nattr->acl_attrib_group, "attrib",
-			&lio_target_nacl_attrib_cit);
-	config_group_init_type_name(&auth->auth_attrib_group, "auth",
-			&lio_target_nacl_auth_cit);
-	nacl_cg->default_groups[0] = &se_nacl->acl_param_group;
-	nacl_cg->default_groups[1] = &nattr->acl_attrib_group;
-	nacl_cg->default_groups[2] = &auth->auth_attrib_group;
-	nacl_cg->default_groups[3] = NULL;
+	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
+				name, cmdsn_depth);
+	if (IS_ERR(se_nacl))
+		return ERR_PTR(PTR_ERR(se_nacl));
 
-	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
-		" Initiator: %s CmdSN Depth: %u\n", config_item_name(tiqn_ci),
-		tpg->tpgt, name, se_nacl->queue_depth);
-
-	iscsi_put_tpg(tpg);
-	return &se_nacl->acl_group;
-node_out:
-	iscsi_tpg_del_initiator_node_acl(tpg, se_nacl);
-out:
-	iscsi_put_tpg(tpg);
-	return NULL;
+	return se_nacl;
 }
 
-static void lio_target_call_delnodefromtpg(
-	struct config_group *group,
-	struct config_item *item)
+static void lio_target_drop_nodeacl(
+	struct se_node_acl_s *se_nacl)
 {
-	iscsi_portal_group_t *tpg;
-	iscsi_tiqn_t *tiqn;
-	se_node_acl_t *se_nacl = container_of(to_config_group(item),
-				se_node_acl_t, acl_group);
-	struct config_item *acl_ci, *tpg_ci, *tiqn_ci, *df_item;
-	struct config_group *nacl_cg;
-	int i;
+	struct se_portal_group_s *se_tpg = se_nacl->se_tpg;
+	struct iscsi_node_acl_s *acl = container_of(se_nacl,
+			struct iscsi_node_acl_s, se_node_acl);
 
-	acl_ci = &group->cg_item;
-	if (!(acl_ci)) {
-		printk(KERN_ERR "Unable to locate config_item acl_ci_ci\n");
-		return;
-	}
-	tpg_ci = &acl_ci->ci_group->cg_item;
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
-	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
-		" Initiator: %s\n", config_item_name(tiqn_ci), tpg->tpgt,
-		config_item_name(item));
-
-	nacl_cg = &se_nacl->acl_group;
-	for (i = 0; nacl_cg->default_groups[i]; i++) {
-		df_item = &nacl_cg->default_groups[i]->cg_item;
-		nacl_cg->default_groups[i] = NULL;
-		config_item_put(df_item);
-	}
-
-	config_item_put(item);
-
-	iscsi_tpg_del_initiator_node_acl(tpg, se_nacl);
-	iscsi_put_tpg(tpg);
+	core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
+	kfree(acl);
 }
 
-static struct configfs_group_operations lio_target_acl_group_ops = {
-	.make_group	= lio_target_call_addnodetotpg,
-	.drop_item	= lio_target_call_delnodefromtpg,
-};
-
-static struct config_item_type lio_target_acl_cit = {
-	.ct_item_ops	= NULL,
-	.ct_group_ops	= &lio_target_acl_group_ops,
-	.ct_attrs	= NULL,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for lio_target_acl_cit */
 
 /* Start items for lio_target_tpg_attrib_cit */
@@ -1862,27 +1280,77 @@ void lio_target_call_coredeltiqn(
 
 /* Start lio_target_discovery_auth_cit */
 
-CONFIGFS_EATTR_STRUCT(iscsi_discovery_auth, iscsi_node_auth_s);
-#define DISC_AUTH_ATTR(_name, _mode)					\
-static struct iscsi_node_auth_attribute iscsi_disc_auth_##_name =	\
-		__CONFIGFS_EATTR(_name, _mode,				\
-		lio_target_show_da_attr_##_name,			\
-		lio_target_store_da_attr_##_name);
+#define DEF_DISC_AUTH_STR(name, flags)					\
+	__DEF_NACL_AUTH_STR(disc, name, flags)				\
+static ssize_t iscsi_disc_show_##name(					\
+	struct target_fabric_configfs *tf,				\
+	char *page)							\
+{									\
+	return __iscsi_disc_show_##name(&iscsi_global->discovery_acl,	\
+		page);							\
+}									\
+static ssize_t iscsi_disc_store_##name(					\
+	struct target_fabric_configfs *tf,				\
+	const char *page,						\
+	size_t count)							\
+{									\
+	return __iscsi_disc_store_##name(&iscsi_global->discovery_acl,	\
+		page, count);						\
+}
+
+#define DEF_DISC_AUTH_INT(name)						\
+	__DEF_NACL_AUTH_INT(disc, name)					\
+static ssize_t iscsi_disc_show_##name(					\
+        struct target_fabric_configfs *tf,				\
+        char *page)							\
+{									\
+	return __iscsi_disc_show_##name(&iscsi_global->discovery_acl, 	\
+			page);						\
+}
+
+#define DISC_AUTH_ATTR(_name, _mode) TF_DISC_ATTR(iscsi, _name, _mode)
+#define DISC_AUTH_ATTR_RO(_name) TF_DISC_ATTR_RO(iscsi, _name)
+
+/*
+ * One-way authentication userid
+ */
+DEF_DISC_AUTH_STR(userid, NAF_USERID_SET);
+DISC_AUTH_ATTR(userid, S_IRUGO | S_IWUSR);
+/*
+ * One-way authentication password
+ */
+DEF_DISC_AUTH_STR(password, NAF_PASSWORD_SET);
+DISC_AUTH_ATTR(password, S_IRUGO | S_IWUSR);
+/*
+ * Enforce mutual authentication
+ */
+DEF_DISC_AUTH_INT(authenticate_target);
+DISC_AUTH_ATTR_RO(authenticate_target);
+/*
+ * Mutual authentication userid
+ */
+DEF_DISC_AUTH_STR(userid_mutual, NAF_USERID_IN_SET);
+DISC_AUTH_ATTR(userid_mutual, S_IRUGO | S_IWUSR);
+/*
+ * Mutual authentication password
+ */
+DEF_DISC_AUTH_STR(password_mutual, NAF_PASSWORD_IN_SET);
+DISC_AUTH_ATTR(password_mutual, S_IRUGO | S_IWUSR);
 
 /*
  * enforce_discovery_auth
  */
-static ssize_t lio_target_show_da_attr_enforce_discovery_auth(
-	struct iscsi_node_auth_s *auth,
+static ssize_t iscsi_disc_show_enforce_discovery_auth(
+	struct target_fabric_configfs *tf,
 	char *page)
 {
-	iscsi_node_auth_t *discovery_auth = &iscsi_global->discovery_auth;
+	iscsi_node_auth_t *discovery_auth = &iscsi_global->discovery_acl.node_auth;
 
 	return sprintf(page, "%d\n", discovery_auth->enforce_discovery_auth);
 }
 
-static ssize_t lio_target_store_da_attr_enforce_discovery_auth(
-	struct iscsi_node_auth_s *auth,
+static ssize_t iscsi_disc_store_enforce_discovery_auth(
+	struct target_fabric_configfs *tf,
 	const char *page,
 	size_t count)
 {
@@ -1916,7 +1384,7 @@ static ssize_t lio_target_store_da_attr_enforce_discovery_auth(
 			return -EINVAL;
 
 		discovery_tpg->tpg_attrib.authentication = 1;
-		iscsi_global->discovery_auth.enforce_discovery_auth = 1;
+		iscsi_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
 		printk(KERN_INFO "LIO-CORE[0] Successfully enabled"
 			" authentication enforcement for iSCSI"
 			" Discovery TPG\n");
@@ -1928,7 +1396,7 @@ static ssize_t lio_target_store_da_attr_enforce_discovery_auth(
 			return -EINVAL;
 
 		discovery_tpg->tpg_attrib.authentication = 0;
-		iscsi_global->discovery_auth.enforce_discovery_auth = 0;
+		iscsi_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
 		printk(KERN_INFO "LIO-CORE[0] Successfully disabled"
 			" authentication enforcement for iSCSI"
 			" Discovery TPG\n");
@@ -1939,48 +1407,18 @@ static ssize_t lio_target_store_da_attr_enforce_discovery_auth(
 
 DISC_AUTH_ATTR(enforce_discovery_auth, S_IRUGO | S_IWUSR);
 
-CONFIGFS_EATTR_OPS(iscsi_discovery_auth, iscsi_node_auth_s, auth_attrib_group);
-
-/*
- * Note that we reuse some of the same configfs structure defines for
- * iscsi_node_auth from lio_target_nacl_auth_cit for the normal iSCSI
- * Initiator Node authentication here the discovery auth group that lives in
- * iscsi_global_t->discovery_auth
- */
 static struct configfs_attribute *lio_target_discovery_auth_attrs[] = {
-	&iscsi_node_auth_userid.attr,
-	&iscsi_node_auth_password.attr,
-	&iscsi_node_auth_authenticate_target.attr,
-	&iscsi_node_auth_userid_mutual.attr,
-	&iscsi_node_auth_password_mutual.attr,
-	&iscsi_disc_auth_enforce_discovery_auth.attr,
+	&iscsi_disc_userid.attr,
+	&iscsi_disc_password.attr,
+	&iscsi_disc_authenticate_target.attr,
+	&iscsi_disc_userid_mutual.attr,
+	&iscsi_disc_password_mutual.attr,
+	&iscsi_disc_enforce_discovery_auth.attr,
 	NULL,
 };
 
-static struct configfs_item_operations lio_target_discovery_auth_ops = {
-	.show_attribute		= iscsi_discovery_auth_attr_show,
-	.store_attribute	= iscsi_discovery_auth_attr_store,
-};
-
-static struct config_item_type lio_target_discovery_auth_cit = {
-	.ct_item_ops	= &lio_target_discovery_auth_ops,
-	.ct_attrs	= lio_target_discovery_auth_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End lio_target_discovery_auth_cit */
 
-/*
- * Callback for top level fabric module default configfs groups.
- */
-void lio_target_reg_defgroups(struct target_fabric_configfs *fabric)
-{
-	iscsi_node_auth_t *discovery_auth = &iscsi_global->discovery_auth;
-
-	config_group_init_type_name(&discovery_auth->auth_attrib_group,
-			"discovery_auth", &lio_target_discovery_auth_cit);
-}
-
 int iscsi_target_register_configfs(void)
 {
 	struct target_fabric_configfs *fabric;
@@ -2012,6 +1450,8 @@ int iscsi_target_register_configfs(void)
 				&lio_tpg_check_demo_mode_cache;
 	fabric->tf_ops.tpg_check_demo_mode_write_protect =
 				&lio_tpg_check_demo_mode_write_protect;
+	fabric->tf_ops.tpg_check_prod_mode_write_protect =
+				&lio_tpg_check_prod_mode_write_protect;
 	fabric->tf_ops.tpg_alloc_fabric_acl = &lio_tpg_alloc_fabric_acl;
 	fabric->tf_ops.tpg_release_fabric_acl = &lio_tpg_release_fabric_acl;
 #ifdef SNMP_SUPPORT
@@ -2047,27 +1487,6 @@ int iscsi_target_register_configfs(void)
 	fabric->tf_ops.is_state_remove = &iscsi_is_state_remove;
 	fabric->tf_ops.pack_lun = &iscsi_pack_lun;
 	/*
-	 * Setup default configfs group for iSCSI Discovery Authentication.
-	 *
-	 * Note that the tf_cg->default_groups[] will be registered when
-	 * config_group_init_type_name() gets called for fabric->tf_groups
-	 * in the local callback lio_target_reg_defgroups() in generic
-	 * target_core_mod code in target_core_register_fabric().
-	 */
-	fabric->reg_default_groups_callback = &lio_target_reg_defgroups;
-	tf_cg = &fabric->tf_group;
-
-	tf_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
-			GFP_KERNEL);
-	if (!(tf_cg->default_groups)) {
-		printk(KERN_ERR "Unable to allocate default fabric groups\n");
-		target_fabric_configfs_free(fabric);
-		return -1;
-	}
-	tf_cg->default_groups[0] =
-			&iscsi_global->discovery_auth.auth_attrib_group;
-	tf_cg->default_groups[1] = NULL;
-	/*
 	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
 	 */
 	fabric->tf_ops.fabric_make_wwn = &lio_target_call_coreaddtiqn;
@@ -2078,15 +1497,22 @@ int iscsi_target_register_configfs(void)
 	fabric->tf_ops.fabric_pre_unlink = NULL;
 	fabric->tf_ops.fabric_make_np = &lio_target_call_addnptotpg;
 	fabric->tf_ops.fabric_drop_np = &lio_target_call_delnpfromtpg;
+	fabric->tf_ops.fabric_make_nodeacl = &lio_target_make_nodeacl;
+	fabric->tf_ops.fabric_drop_nodeacl = &lio_target_drop_nodeacl;
 	/*
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 * sturct config_item_type's
 	 */
+	TF_CIT_TMPL(fabric)->tfc_discovery_cit.ct_attrs = lio_target_discovery_auth_attrs;
 	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = lio_target_wwn_attrs;
 	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = lio_target_tpg_attrs;
 	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = lio_target_tpg_attrib_attrs;
 	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = lio_target_tpg_param_attrs;
 	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = lio_target_portal_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = lio_target_initiator_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = lio_target_nacl_attrib_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = lio_target_nacl_auth_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = lio_target_nacl_param_attrs;
 
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index 1136c82..3bb26f7 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -735,7 +735,6 @@ typedef struct iscsi_node_attrib_s {
 	u32			tmr_cold_reset;
 	u32			tmr_warm_reset;
 	struct iscsi_node_acl_s *nacl;
-	struct config_group	acl_attrib_group;
 } ____cacheline_aligned iscsi_node_attrib_t;
 
 struct se_dev_entry_s;
@@ -750,13 +749,12 @@ typedef struct iscsi_node_auth_s {
 	char			password[MAX_PASS_LEN];
 	char			userid_mutual[MAX_USER_LEN];
 	char			password_mutual[MAX_PASS_LEN];
-	struct config_group	auth_attrib_group;
 } ____cacheline_aligned iscsi_node_auth_t;
 
 typedef struct iscsi_node_acl_s {
 	iscsi_node_attrib_t	node_attrib;
 	iscsi_node_auth_t	node_auth;
-	struct se_node_acl_s	*se_node_acl;
+	struct se_node_acl_s	se_node_acl;
 } ____cacheline_aligned iscsi_node_acl_t;
 
 #define ISCSI_NODE_ATTRIB(t)	(&(t)->node_attrib)
@@ -933,7 +931,7 @@ typedef struct iscsi_global_s {
 	/* Semaphore used for allocate of iscsi_conn_t->auth_id */
 	struct semaphore	auth_id_sem;
 	/* Used for iSCSI discovery session authentication */
-	iscsi_node_auth_t	discovery_auth;
+	iscsi_node_acl_t	discovery_acl;
 	iscsi_portal_group_t	*discovery_tpg;
 #ifdef DEBUG_ERL
 	iscsi_debug_erl_t	*debug_erl;
diff --git a/drivers/target/lio-target/iscsi_target_nodeattrib.c b/drivers/target/lio-target/iscsi_target_nodeattrib.c
index 886bd36..085f554 100644
--- a/drivers/target/lio-target/iscsi_target_nodeattrib.c
+++ b/drivers/target/lio-target/iscsi_target_nodeattrib.c
@@ -136,7 +136,7 @@ extern int iscsi_na_nopin_timeout(
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 	iscsi_session_t *sess;
 	iscsi_conn_t *conn;
-	se_node_acl_t *se_nacl = a->nacl->se_node_acl;
+	se_node_acl_t *se_nacl = &a->nacl->se_node_acl;
 	se_session_t *se_sess;
 	u32 orig_nopin_timeout = a->nopin_timeout;
 
diff --git a/drivers/target/lio-target/iscsi_target_tpg.c b/drivers/target/lio-target/iscsi_target_tpg.c
index 130c090..3a0e89c 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.c
+++ b/drivers/target/lio-target/iscsi_target_tpg.c
@@ -347,9 +347,16 @@ int lio_tpg_check_demo_mode_write_protect(se_portal_group_t *se_tpg)
 	return ISCSI_TPG_ATTRIB(tpg)->demo_mode_write_protect;
 }
 
-void *lio_tpg_alloc_fabric_acl(
-	se_portal_group_t *se_tpg,
-	se_node_acl_t *se_nacl)
+int lio_tpg_check_prod_mode_write_protect(se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg =
+			(iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return ISCSI_TPG_ATTRIB(tpg)->prod_mode_write_protect;
+}
+
+struct se_node_acl_s *lio_tpg_alloc_fabric_acl(
+	se_portal_group_t *se_tpg)
 {
 	iscsi_node_acl_t *acl;
 
@@ -358,16 +365,16 @@ void *lio_tpg_alloc_fabric_acl(
 		printk(KERN_ERR "Unable to allocate memory for iscsi_node_acl_t\n");
 		return NULL;
 	}
-	acl->se_node_acl = se_nacl;
 
-	return acl;
+	return &acl->se_node_acl;
 }
 
 void lio_tpg_release_fabric_acl(
 	se_portal_group_t *se_tpg,
 	se_node_acl_t *se_acl)
 {
-	iscsi_node_acl_t *acl = (iscsi_node_acl_t *)se_acl->fabric_acl_ptr;
+	struct iscsi_node_acl_s *acl = container_of(se_acl,
+			struct iscsi_node_acl_s, se_node_acl);
 	kfree(acl);
 }
 
@@ -439,7 +446,8 @@ u32 lio_tpg_get_inst_index(se_portal_group_t *se_tpg)
 
 void lio_set_default_node_attributes(se_node_acl_t *se_acl)
 {
-	iscsi_node_acl_t *acl = (iscsi_node_acl_t *)se_acl->fabric_acl_ptr;
+	iscsi_node_acl_t *acl = container_of(se_acl, iscsi_node_acl_t,
+				se_node_acl);
 
 	ISCSI_NODE_ATTRIB(acl)->nacl = acl;
 	iscsi_set_default_node_attribues(acl);
@@ -890,45 +898,13 @@ int iscsi_tpg_disable_portal_group(iscsi_portal_group_t *tpg, int force)
 	return 0;
 }
 
-/*	iscsi_tpg_add_initiator_node_acl():
- *
- *
- */
-iscsi_node_acl_t *iscsi_tpg_add_initiator_node_acl(
-	iscsi_portal_group_t *tpg,
-	const char *initiatorname,
-	u32 queue_depth)
-{
-	se_node_acl_t *se_nacl;
-
-	se_nacl = core_tpg_add_initiator_node_acl(&tpg->tpg_se_tpg,
-			initiatorname, queue_depth);
-	if ((IS_ERR(se_nacl)) || !(se_nacl))
-		return NULL;
-
-	return (iscsi_node_acl_t *)se_nacl->fabric_acl_ptr;
-}
-
-/*	iscsi_tpg_del_initiator_node_acl():
- *
- *
- */
-void iscsi_tpg_del_initiator_node_acl(
-	iscsi_portal_group_t *tpg,
-	se_node_acl_t *se_nacl)
-{
-	/*
-	 * TPG_TFO(tpg)->tpg_release_acl() will kfree the iscsi_node_acl_t..
-	 */
-	core_tpg_del_initiator_node_acl(&tpg->tpg_se_tpg, se_nacl, 1);
-}
-
 iscsi_node_attrib_t *iscsi_tpg_get_node_attrib(
 	iscsi_session_t *sess)
 {
 	se_session_t *se_sess = sess->se_sess;
 	se_node_acl_t *se_nacl = se_sess->se_node_acl;
-	iscsi_node_acl_t *acl = (iscsi_node_acl_t *)se_nacl->fabric_acl_ptr;
+	iscsi_node_acl_t *acl = container_of(se_nacl, iscsi_node_acl_t,
+					se_node_acl);
 
 	return &acl->node_attrib;
 }
diff --git a/drivers/target/lio-target/iscsi_target_tpg.h b/drivers/target/lio-target/iscsi_target_tpg.h
index ab44cfd..3141d7e 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.h
+++ b/drivers/target/lio-target/iscsi_target_tpg.h
@@ -12,8 +12,8 @@ extern char *lio_tpg_parse_pr_out_transport_id(const char *, u32 *, char **);
 extern int lio_tpg_check_demo_mode(struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_cache(struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_write_protect(struct se_portal_group_s *);
-extern void *lio_tpg_alloc_fabric_acl(struct se_portal_group_s *,
-			struct se_node_acl_s *);
+extern int lio_tpg_check_prod_mode_write_protect(struct se_portal_group_s *);
+extern struct se_node_acl_s *lio_tpg_alloc_fabric_acl(struct se_portal_group_s *);
 extern void lio_tpg_release_fabric_acl(struct se_portal_group_s *,
 			struct se_node_acl_s *);
 extern int lio_tpg_shutdown_session(struct se_session_s *);
-- 
1.5.6.5

