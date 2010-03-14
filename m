From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] [TCM/PR]: Add TPG, NodeACL and MappedLUN wrappers for configfs_[un]depend_item()
Date: Sun, 14 Mar 2010 01:17:45 -0800
Message-ID: <1268558265-10761-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:45213 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756363Ab0CNJSr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2010 05:18:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.co>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds TPG, NodeACL and MappedLUN wrappers for configfs_depend_item() and
configfs_undepend_item() to properly handler the reference counting of *pr_ref_count
during multi-fabric SPEC_I_PT=1 TransportID and REGISTER_AND_MOVE processing.

For the NodeACL and MappedLUN wrappers, there is also logic to handle the
NAF_DYNAMIC_NODE_ACL case so that demo-mode (eg: no explict node ACLs) works for
SPEC_I_PT=1 TransportID and REGISTER_AND_MOVE as well.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |   85 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5b23767..03f40e3 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -54,6 +54,7 @@
 struct pr_transport_id_holder {
 	int dest_local_nexus;
 	struct t10_pr_registration_s *dest_pr_reg;
+	struct se_portal_group_s *dest_tpg;
 	struct se_node_acl_s *dest_node_acl;
 	struct se_dev_entry_s *dest_se_deve;
 	struct list_head dest_list;
@@ -1035,6 +1036,90 @@ void core_scsi3_free_all_registrations(
 	spin_unlock(&pr_tmpl->aptpl_reg_lock);
 }
 
+static int core_scsi3_tpg_depend_item(se_portal_group_t *tpg)
+{
+	return configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
+			&tpg->tpg_group.cg_item);
+}
+
+static void core_scsi3_tpg_undepend_item(se_portal_group_t *tpg)
+{
+	configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+			&tpg->tpg_group.cg_item);
+
+	atomic_dec(&tpg->tpg_pr_ref_count);
+	smp_mb__after_atomic_dec();
+}
+
+static int core_scsi3_nodeacl_depend_item(se_node_acl_t *nacl)
+{
+	se_portal_group_t *tpg = nacl->se_tpg;
+
+	if (nacl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL)
+		return 0;
+
+	return configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
+			&nacl->acl_group.cg_item);
+}
+
+static void core_scsi3_nodeacl_undepend_item(se_node_acl_t *nacl)
+{
+	se_portal_group_t *tpg = nacl->se_tpg;
+
+	if (nacl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
+		atomic_dec(&nacl->acl_pr_ref_count);
+		smp_mb__after_atomic_dec();
+		return;
+	}
+
+	configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+			&nacl->acl_group.cg_item);	
+
+	atomic_dec(&nacl->acl_pr_ref_count);
+	smp_mb__after_atomic_dec();
+}
+
+static int core_scsi3_lunacl_depend_item(se_dev_entry_t *se_deve)
+{
+	se_lun_acl_t *lun_acl = se_deve->se_lun_acl;
+	se_node_acl_t *nacl;
+	se_portal_group_t *tpg;
+	/*
+	 * For nacl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL)
+	 */
+	if (!(lun_acl))
+		return 0;
+
+	nacl = lun_acl->se_lun_nacl;
+	tpg = nacl->se_tpg;
+
+	return configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
+			&lun_acl->se_lun_group.cg_item);
+}
+
+static void core_scsi3_lunacl_undepend_item(se_dev_entry_t *se_deve)
+{
+	se_lun_acl_t *lun_acl = se_deve->se_lun_acl;
+	se_node_acl_t *nacl;
+	se_portal_group_t *tpg;
+	/*
+	 * For nacl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL)
+	 */
+	if (!(lun_acl)) {
+		atomic_dec(&se_deve->pr_ref_count);
+		smp_mb__after_atomic_dec();
+		return;	
+	}
+	nacl = lun_acl->se_lun_nacl;
+	tpg = nacl->se_tpg;
+
+	configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+			&lun_acl->se_lun_group.cg_item);
+
+	atomic_dec(&se_deve->pr_ref_count);
+	smp_mb__after_atomic_dec();
+}
+
 static int core_scsi3_decode_spec_i_port(
 	se_cmd_t *cmd,
 	se_portal_group_t *tpg,
-- 
1.5.6.5

