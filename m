From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 20/22] target: Rename LUN lookup/add/remove to target_* prefix
Date: Fri, 27 Mar 2015 08:05:10 +0000
Message-ID: <1427443512-8925-21-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This includes:

  - target_add_lun
  - target_remove_lun
  - target_lookup_cmd_lun
  - target_lookup_tmr_lun
  - target_clear_lun_from_tpg

Also, update fabric drivers for loopback, iscsi/iser-target,
xen-scsiback.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c    |  8 ++++----
 drivers/target/loopback/tcm_loop.c     |  2 +-
 drivers/target/target_core_device.c    | 16 ++++++++--------
 drivers/target/target_core_internal.h  |  6 +++---
 drivers/target/target_core_tpg.c       | 10 +++++-----
 drivers/target/target_core_transport.c |  4 ++--
 drivers/xen/xen-scsiback.c             |  2 +-
 include/target/target_core_fabric.h    |  4 ++--
 8 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 75e24ef..9a5d56a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -995,8 +995,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(conn->sess->se_sess, &cmd->se_cmd, true);
 
-	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
-						     scsilun_to_int(&hdr->lun));
+	cmd->sense_reason = target_lookup_cmd_lun(&cmd->se_cmd,
+						  scsilun_to_int(&hdr->lun));
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
@@ -1857,8 +1857,8 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 * Locate the struct se_lun for all TMRs not related to ERL=2 TASK_REASSIGN
 	 */
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
-		ret = transport_lookup_tmr_lun(&cmd->se_cmd,
-					       scsilun_to_int(&hdr->lun));
+		ret = target_lookup_tmr_lun(&cmd->se_cmd,
+					    scsilun_to_int(&hdr->lun));
 		if (ret < 0) {
 			se_tmr->response = ISCSI_TMF_RSP_NO_LUN;
 			goto attach;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index a05b86c..1510380 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -271,7 +271,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	/*
 	 * Locate the underlying TCM struct se_lun
 	 */
-	if (transport_lookup_tmr_lun(se_cmd, lun) < 0) {
+	if (target_lookup_tmr_lun(se_cmd, lun) < 0) {
 		ret = TMR_LUN_DOES_NOT_EXIST;
 		goto release;
 	}
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 80d1b04..3647e7c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -55,7 +55,7 @@ static struct se_hba *lun0_hba;
 struct se_device *g_lun0_dev;
 
 sense_reason_t
-transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
+target_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
@@ -147,9 +147,9 @@ check_lun:
 
 	return 0;
 }
-EXPORT_SYMBOL(transport_lookup_cmd_lun);
+EXPORT_SYMBOL(target_lookup_cmd_lun);
 
-int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
+int target_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
@@ -200,7 +200,7 @@ check_lun:
 
 	return 0;
 }
-EXPORT_SYMBOL(transport_lookup_tmr_lun);
+EXPORT_SYMBOL(target_lookup_tmr_lun);
 
 /*
  * This function is called from core_scsi3_emulate_pro_register_and_move()
@@ -456,11 +456,11 @@ int core_disable_device_list_for_node(
 	return 0;
 }
 
-/*      core_clear_lun_from_tpg():
+/*      target_clear_lun_from_tpg():
  *
  *
  */
-void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
+void target_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 {
 	struct se_node_acl *nacl;
 	struct se_dev_entry *deve;
@@ -1211,7 +1211,7 @@ struct se_lun *core_dev_add_lun(
 	if (IS_ERR(lun))
 		return lun;
 
-	rc = core_tpg_add_lun(tpg, lun,
+	rc = target_add_lun(tpg, lun,
 				TRANSPORT_LUNFLAGS_READ_WRITE, dev);
 	if (rc < 0)
 		return ERR_PTR(rc);
@@ -1254,7 +1254,7 @@ void core_dev_del_lun(
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name());
 
-	core_tpg_remove_lun(tpg, lun);
+	target_remove_lun(tpg, lun);
 }
 
 struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_lun)
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 574b396..70190e2 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -13,7 +13,7 @@ int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 		u32, u32, struct se_node_acl *, struct se_portal_group *);
 int	core_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 		u32, u32, struct se_node_acl *, struct se_portal_group *);
-void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
+void	target_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
 int	core_dev_export(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
 void	core_dev_unexport(struct se_device *, struct se_portal_group *,
@@ -53,9 +53,9 @@ struct se_node_acl *__target_get_initiator_node_acl(struct se_portal_group *tpg,
 void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
-int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
+int	target_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
-void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
+void target_remove_lun(struct se_portal_group *, struct se_lun *);
 
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 513e6bd..9d31434 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -637,7 +637,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 
-	ret = core_tpg_add_lun(se_tpg, lun, lun_access, dev);
+	ret = target_add_lun(se_tpg, lun, lun_access, dev);
 	if (ret < 0)
 		return ret;
 
@@ -744,7 +744,7 @@ int target_deregister_tpg(struct se_portal_group *se_tpg)
 	}
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
-		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
+		target_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
 
 	se_tpg->se_tpg_fabric_ptr = NULL;
 	array_free(se_tpg->tpg_lun_list, TRANSPORT_MAX_LUNS_PER_TPG);
@@ -782,7 +782,7 @@ struct se_lun *core_tpg_alloc_lun(
 	return lun;
 }
 
-int core_tpg_add_lun(
+int target_add_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun,
 	u32 lun_access,
@@ -809,11 +809,11 @@ int core_tpg_add_lun(
 	return 0;
 }
 
-void core_tpg_remove_lun(
+void target_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-	core_clear_lun_from_tpg(lun, tpg);
+	target_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
 
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dfd78dd..86d4aeb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1398,7 +1398,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
-	rc = transport_lookup_cmd_lun(se_cmd, unpacked_lun);
+	rc = target_lookup_cmd_lun(se_cmd, unpacked_lun);
 	if (rc) {
 		transport_send_check_condition_and_sense(se_cmd, rc, 0);
 		target_put_sess_cmd(se_sess, se_cmd);
@@ -1558,7 +1558,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		return ret;
 	}
 
-	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
+	ret = target_lookup_tmr_lun(se_cmd, unpacked_lun);
 	if (ret) {
 		/*
 		 * For callback during failure handling, push this work off
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 00772de..a2062b6 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -616,7 +616,7 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 
 	se_cmd->se_tmr_req->ref_task_tag = tag;
 
-	if (transport_lookup_tmr_lun(se_cmd, pending_req->v2p->lun) < 0)
+	if (target_lookup_tmr_lun(se_cmd, pending_req->v2p->lun) < 0)
 		goto out;
 
 	transport_generic_handle_tmr(se_cmd);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 9b4dc7a..e06613d 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -111,7 +111,7 @@ void	transport_deregister_session(struct se_session *);
 
 void	transport_init_se_cmd(struct se_cmd *, struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *);
-sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u32);
+sense_reason_t target_lookup_cmd_lun(struct se_cmd *, u32);
 sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u32, u32, int, int, int,
@@ -146,7 +146,7 @@ void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
 void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
 void	__target_execute_cmd(struct se_cmd *);
-int	transport_lookup_tmr_lun(struct se_cmd *, u32);
+int	target_lookup_tmr_lun(struct se_cmd *, u32);
 
 struct se_node_acl *target_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
-- 
1.9.1
