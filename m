From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 4/5] target/qla2xxx: Define NPIV ops in terms of normal ops
Date: Tue, 20 Aug 2013 18:00:06 -0700
Message-ID: <1377046807-15860-5-git-send-email-agrover@redhat.com>
References: <1377046807-15860-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377046807-15860-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Instead of defining a second target_core_fabric_ops struct, use the
same one as normal (tcm_qla2xxx_ops) and then fixup the changed methods.

This should make it a little easier to pick out the npiv differences, and
also save a little space.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   62 +++++++----------------------------
 1 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 947edef..070f3d6 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1792,53 +1792,6 @@ static struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.fabric_drop_nodeacl		= tcm_qla2xxx_drop_nodeacl,
 };
 
-static struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
-	.get_fabric_name		= tcm_qla2xxx_npiv_get_fabric_name,
-	.get_fabric_proto_ident		= tcm_qla2xxx_get_fabric_proto_ident,
-	.tpg_get_wwn			= tcm_qla2xxx_npiv_get_fabric_wwn,
-	.tpg_get_tag			= tcm_qla2xxx_get_tag,
-	.tpg_get_default_depth		= tcm_qla2xxx_get_default_depth,
-	.tpg_get_pr_transport_id	= tcm_qla2xxx_get_pr_transport_id,
-	.tpg_get_pr_transport_id_len	= tcm_qla2xxx_get_pr_transport_id_len,
-	.tpg_parse_pr_out_transport_id	= tcm_qla2xxx_parse_pr_out_transport_id,
-	.tpg_check_demo_mode		= tcm_qla2xxx_check_false,
-	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_true,
-	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_true,
-	.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_false,
-	.tpg_check_demo_mode_login_only	= tcm_qla2xxx_check_demo_mode_login_only,
-	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
-	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
-	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
-	.release_cmd			= tcm_qla2xxx_release_cmd,
-	.put_session			= tcm_qla2xxx_put_session,
-	.shutdown_session		= tcm_qla2xxx_shutdown_session,
-	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
-	.write_pending			= tcm_qla2xxx_write_pending,
-	.write_pending_status		= tcm_qla2xxx_write_pending_status,
-	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
-	.get_task_tag			= tcm_qla2xxx_get_task_tag,
-	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
-	.queue_data_in			= tcm_qla2xxx_queue_data_in,
-	.queue_status			= tcm_qla2xxx_queue_status,
-	.queue_tm_rsp			= tcm_qla2xxx_queue_tm_rsp,
-	/*
-	 * Setup function pointers for generic logic in
-	 * target_core_fabric_configfs.c
-	 */
-	.fabric_make_wwn		= tcm_qla2xxx_npiv_make_lport,
-	.fabric_drop_wwn		= tcm_qla2xxx_npiv_drop_lport,
-	.fabric_make_tpg		= tcm_qla2xxx_npiv_make_tpg,
-	.fabric_drop_tpg		= tcm_qla2xxx_drop_tpg,
-	.fabric_post_link		= NULL,
-	.fabric_pre_unlink		= NULL,
-	.fabric_make_np			= NULL,
-	.fabric_drop_np			= NULL,
-	.fabric_make_nodeacl		= tcm_qla2xxx_make_nodeacl,
-	.fabric_drop_nodeacl		= tcm_qla2xxx_drop_nodeacl,
-};
-
 static int tcm_qla2xxx_register_configfs(void)
 {
 	struct target_fabric_configfs *fabric, *npiv_fabric;
@@ -1895,10 +1848,21 @@ static int tcm_qla2xxx_register_configfs(void)
 		ret = PTR_ERR(npiv_fabric);
 		goto out_fabric;
 	}
+
 	/*
-	 * Setup fabric->tf_ops from our local tcm_qla2xxx_npiv_ops
+	 * NPIV is the same as regular, except for a few functions.
 	 */
-	npiv_fabric->tf_ops = tcm_qla2xxx_npiv_ops;
+	npiv_fabric->tf_ops = tcm_qla2xxx_ops;
+	npiv_fabric->tf_ops.get_fabric_name = tcm_qla2xxx_npiv_get_fabric_name;
+	npiv_fabric->tf_ops.tpg_get_wwn = tcm_qla2xxx_npiv_get_fabric_wwn;
+	npiv_fabric->tf_ops.tpg_check_demo_mode = tcm_qla2xxx_check_false;
+	npiv_fabric->tf_ops.tpg_check_demo_mode_cache = tcm_qla2xxx_check_true;
+	npiv_fabric->tf_ops.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_true;
+	npiv_fabric->tf_ops.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_false;
+	npiv_fabric->tf_ops.fabric_make_wwn = tcm_qla2xxx_npiv_make_lport;
+	npiv_fabric->tf_ops.fabric_drop_wwn = tcm_qla2xxx_npiv_drop_lport;
+	npiv_fabric->tf_ops.fabric_make_tpg = tcm_qla2xxx_npiv_make_tpg;
+
 	/*
 	 * Setup default attribute lists for various npiv_fabric->tf_cit_tmpl
 	 */
-- 
1.7.1
