From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 2/4] target/iscsi: Remove iscsi dereferencing macros
Date: Wed,  9 Oct 2013 11:05:57 -0700
Message-ID: <1381341959-22254-3-git-send-email-agrover@redhat.com>
References: <1381341959-22254-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab3JISGE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Oct 2013 14:06:04 -0400
In-Reply-To: <1381341959-22254-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

These are all straightforward.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c |   42 +++++++++++++-------------
 drivers/target/iscsi/iscsi_target_core.h     |    9 -----
 drivers/target/iscsi/iscsi_target_nego.c     |    8 ++--
 drivers/target/iscsi/iscsi_target_tpg.c      |    4 +-
 4 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index c2d5044..59a0241 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -372,7 +372,7 @@ static ssize_t iscsi_nacl_attrib_show_##name(				\
 	struct iscsi_node_acl *nacl = container_of(se_nacl, struct iscsi_node_acl, \
 					se_node_acl);			\
 									\
-	return sprintf(page, "%u\n", ISCSI_NODE_ATTRIB(nacl)->name);	\
+	return sprintf(page, "%u\n", nacl->node_attrib.name);		\
 }									\
 									\
 static ssize_t iscsi_nacl_attrib_store_##name(				\
@@ -897,7 +897,7 @@ static struct se_node_acl *lio_target_make_nodeacl(
 	if (!se_nacl_new)
 		return ERR_PTR(-ENOMEM);
 
-	cmdsn_depth = ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
+	cmdsn_depth = tpg->tpg_attrib.default_cmdsn_depth;
 	/*
 	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
 	 * when converting a NdoeACL from demo mode -> explict
@@ -920,9 +920,9 @@ static struct se_node_acl *lio_target_make_nodeacl(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	stats_cg->default_groups[0] = &NODE_STAT_GRPS(acl)->iscsi_sess_stats_group;
+	stats_cg->default_groups[0] = &acl->node_stat_grps.iscsi_sess_stats_group;
 	stats_cg->default_groups[1] = NULL;
-	config_group_init_type_name(&NODE_STAT_GRPS(acl)->iscsi_sess_stats_group,
+	config_group_init_type_name(&acl->node_stat_grps.iscsi_sess_stats_group,
 			"iscsi_sess_stats", &iscsi_stat_sess_cit);
 
 	return se_nacl;
@@ -967,7 +967,7 @@ static ssize_t iscsi_tpg_attrib_show_##name(				\
 	if (iscsit_get_tpg(tpg) < 0)					\
 		return -EINVAL;						\
 									\
-	rb = sprintf(page, "%u\n", ISCSI_TPG_ATTRIB(tpg)->name);	\
+	rb = sprintf(page, "%u\n", tpg->tpg_attrib.name);		\
 	iscsit_put_tpg(tpg);						\
 	return rb;							\
 }									\
@@ -1514,21 +1514,21 @@ static struct se_wwn *lio_target_call_coreaddtiqn(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	stats_cg->default_groups[0] = &WWN_STAT_GRPS(tiqn)->iscsi_instance_group;
-	stats_cg->default_groups[1] = &WWN_STAT_GRPS(tiqn)->iscsi_sess_err_group;
-	stats_cg->default_groups[2] = &WWN_STAT_GRPS(tiqn)->iscsi_tgt_attr_group;
-	stats_cg->default_groups[3] = &WWN_STAT_GRPS(tiqn)->iscsi_login_stats_group;
-	stats_cg->default_groups[4] = &WWN_STAT_GRPS(tiqn)->iscsi_logout_stats_group;
+	stats_cg->default_groups[0] = &tiqn->tiqn_stat_grps.iscsi_instance_group;
+	stats_cg->default_groups[1] = &tiqn->tiqn_stat_grps.iscsi_sess_err_group;
+	stats_cg->default_groups[2] = &tiqn->tiqn_stat_grps.iscsi_tgt_attr_group;
+	stats_cg->default_groups[3] = &tiqn->tiqn_stat_grps.iscsi_login_stats_group;
+	stats_cg->default_groups[4] = &tiqn->tiqn_stat_grps.iscsi_logout_stats_group;
 	stats_cg->default_groups[5] = NULL;
-	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_instance_group,
+	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_instance_group,
 			"iscsi_instance", &iscsi_stat_instance_cit);
-	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_sess_err_group,
+	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_sess_err_group,
 			"iscsi_sess_err", &iscsi_stat_sess_err_cit);
-	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_tgt_attr_group,
+	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_tgt_attr_group,
 			"iscsi_tgt_attr", &iscsi_stat_tgt_attr_cit);
-	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_login_stats_group,
+	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_login_stats_group,
 			"iscsi_login_stats", &iscsi_stat_login_cit);
-	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_logout_stats_group,
+	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_logout_stats_group,
 			"iscsi_logout_stats", &iscsi_stat_logout_cit);
 
 	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
@@ -1815,21 +1815,21 @@ static u32 lio_tpg_get_default_depth(struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
 
-	return ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
+	return tpg->tpg_attrib.default_cmdsn_depth;
 }
 
 static int lio_tpg_check_demo_mode(struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
 
-	return ISCSI_TPG_ATTRIB(tpg)->generate_node_acls;
+	return tpg->tpg_attrib.generate_node_acls;
 }
 
 static int lio_tpg_check_demo_mode_cache(struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
 
-	return ISCSI_TPG_ATTRIB(tpg)->cache_dynamic_acls;
+	return tpg->tpg_attrib.cache_dynamic_acls;
 }
 
 static int lio_tpg_check_demo_mode_write_protect(
@@ -1837,7 +1837,7 @@ static int lio_tpg_check_demo_mode_write_protect(
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
 
-	return ISCSI_TPG_ATTRIB(tpg)->demo_mode_write_protect;
+	return tpg->tpg_attrib.demo_mode_write_protect;
 }
 
 static int lio_tpg_check_prod_mode_write_protect(
@@ -1845,7 +1845,7 @@ static int lio_tpg_check_prod_mode_write_protect(
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
 
-	return ISCSI_TPG_ATTRIB(tpg)->prod_mode_write_protect;
+	return tpg->tpg_attrib.prod_mode_write_protect;
 }
 
 static void lio_tpg_release_fabric_acl(
@@ -1909,7 +1909,7 @@ static void lio_set_default_node_attributes(struct se_node_acl *se_acl)
 	struct iscsi_node_acl *acl = container_of(se_acl, struct iscsi_node_acl,
 				se_node_acl);
 
-	ISCSI_NODE_ATTRIB(acl)->nacl = acl;
+	acl->node_attrib.nacl = acl;
 	iscsit_set_default_node_attribues(acl);
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 9a5721b..1d14f77 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -755,11 +755,6 @@ struct iscsi_node_acl {
 	struct se_node_acl	se_node_acl;
 };
 
-#define NODE_STAT_GRPS(nacl)	(&(nacl)->node_stat_grps)
-
-#define ISCSI_NODE_ATTRIB(t)	(&(t)->node_attrib)
-#define ISCSI_NODE_AUTH(t)	(&(t)->node_auth)
-
 struct iscsi_tpg_attrib {
 	u32			authentication;
 	u32			login_timeout;
@@ -838,8 +833,6 @@ struct iscsi_portal_group {
 #define ISCSI_TPG_C(c)		((struct iscsi_portal_group *)(c)->tpg)
 #define ISCSI_TPG_LUN(c, l)  ((iscsi_tpg_list_t *)(c)->tpg->tpg_lun_list_t[l])
 #define ISCSI_TPG_S(s)		((struct iscsi_portal_group *)(s)->tpg)
-#define ISCSI_TPG_ATTRIB(t)	(&(t)->tpg_attrib)
-#define SE_TPG(tpg)		(&(tpg)->tpg_se_tpg)
 
 struct iscsi_wwn_stat_grps {
 	struct config_group	iscsi_stat_group;
@@ -871,8 +864,6 @@ struct iscsi_tiqn {
 	struct iscsi_logout_stats    logout_stats;
 } ____cacheline_aligned;
 
-#define WWN_STAT_GRPS(tiqn)	(&(tiqn)->tiqn_stat_grps)
-
 struct iscsit_global {
 	/* In core shutdown */
 	u32			in_shutdown;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 14d1aed..973a27f 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -140,7 +140,7 @@ static u32 iscsi_handle_authentication(
 			iscsi_nacl = container_of(se_nacl, struct iscsi_node_acl,
 						  se_node_acl);
 
-			auth = ISCSI_NODE_AUTH(iscsi_nacl);
+			auth = &iscsi_nacl->node_auth;
 		}
 	} else {
 		/*
@@ -789,7 +789,7 @@ static int iscsi_target_handle_csg_zero(
 		return -1;
 
 	if (!iscsi_check_negotiated_keys(conn->param_list)) {
-		if (ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication &&
+		if (ISCSI_TPG_C(conn)->tpg_attrib.authentication &&
 		    !strncmp(param->value, NONE, 4)) {
 			pr_err("Initiator sent AuthMethod=None but"
 				" Target is enforcing iSCSI Authentication,"
@@ -799,7 +799,7 @@ static int iscsi_target_handle_csg_zero(
 			return -1;
 		}
 
-		if (ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication &&
+		if (ISCSI_TPG_C(conn)->tpg_attrib.authentication &&
 		    !login->auth_complete)
 			return 0;
 
@@ -862,7 +862,7 @@ static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct iscsi_log
 	}
 
 	if (!login->auth_complete &&
-	     ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication) {
+	     ISCSI_TPG_C(conn)->tpg_attrib.authentication) {
 		pr_err("Initiator is requesting CSG: 1, has not been"
 			 " successfully authenticated, and the Target is"
 			" enforcing iSCSI Authentication, login failed.\n");
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 4faeb47..1ef5df0 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -237,7 +237,7 @@ int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_gro
 	if (iscsi_create_default_params(&tpg->param_list) < 0)
 		goto err_out;
 
-	ISCSI_TPG_ATTRIB(tpg)->tpg = tpg;
+	tpg->tpg_attrib.tpg = tpg;
 
 	spin_lock(&tpg->tpg_state_lock);
 	tpg->tpg_state	= TPG_STATE_INACTIVE;
@@ -330,7 +330,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 		return -EINVAL;
 	}
 
-	if (ISCSI_TPG_ATTRIB(tpg)->authentication) {
+	if (tpg->tpg_attrib.authentication) {
 		if (!strcmp(param->value, NONE)) {
 			ret = iscsi_update_param_value(param, CHAP);
 			if (ret)
-- 
1.7.1

