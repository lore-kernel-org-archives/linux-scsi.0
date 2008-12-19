From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 12/14]: Updates for iscsi_target.c for generic
	target_core_mod v3.0
Date: Fri, 19 Dec 2008 15:37:06 -0800
Message-ID: <1229729826.4560.124.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:32496 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751891AbYLSXhg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:37:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From e021cdd91d39687fdd2ba5fbe5f7fed495f35961 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:38:38 -0800
Subject: [PATCH] [LIO-Target]: Updates for iscsi_target.c for generic target_core_mod v3.0

This patch adds struct kmem_cache *lio_cmd_cache and struct kmem_cache *lio_sess_cache
for iscsi_cmd_t and iscsi_session_t respectively.

It adds iscsi_get_fabric_name(), which is used in struct target_core_fabric_ops.

Also, added a check for SE_CMD(iscsi_cmd_t) in iscsi_target_tx_thread():ISTATE_REMOVE
to determine if the iscsi_cmd_t has an assoicated se_cmd_t that needs to be freed
by target_core_mod logic.

Updated iscsi_close_session() to use transport_deregister_session_configfs() and
transport_deregister_session(), and got rid of some logic that has now been
made generic to target_core_mod v3.0.

Made iscsi_stop_session() return 'void', and made iscsi_release_sessions_for_tpg()
use se_portal_group_t->tpg_sess_list with struct list_head.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c |  128 ++++++++++++++++++++-------------------
 drivers/lio-core/iscsi_target.h |    3 +-
 2 files changed, 68 insertions(+), 63 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index e393cd1..d234fe0 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -94,7 +94,8 @@
 
 iscsi_global_t *iscsi_global = NULL;
 
-extern struct miscdevice iscsi_dev;
+struct kmem_cache *lio_cmd_cache = NULL;
+struct kmem_cache *lio_sess_cache = NULL;
 
 extern int se_allocate_rl_cmd (se_cmd_t *, unsigned char *, u64);
 extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
@@ -444,7 +445,6 @@ extern int core_access_np (iscsi_np_t *np, iscsi_portal_group_t *tpg)
 
 	spin_lock_bh(&np->np_thread_lock);
 	np->np_login_tpg = tpg;
-	printk("Set np->np_login_tpg to %p\n", tpg);
 	spin_unlock_bh(&np->np_thread_lock);
 
 	return(0);
@@ -456,7 +456,6 @@ extern int core_deaccess_np (iscsi_np_t *np, iscsi_portal_group_t *tpg)
 
 	spin_lock_bh(&np->np_thread_lock);
 	np->np_login_tpg = NULL;	
-	printk("Cleared np->np_login_tpg\n");
 	spin_unlock_bh(&np->np_thread_lock);
 
 	up(&tpg->np_login_sem);
@@ -1104,6 +1103,20 @@ static int iscsi_target_detect(void)
 	plugin_register_class(PLUGIN_TYPE_FRONTEND, "FRONTEND", MAX_PLUGINS);
 	frontend_load_plugins();
 
+	if (!(lio_cmd_cache = kmem_cache_create("lio_cmd_cache",
+			sizeof(iscsi_cmd_t), __alignof__(iscsi_cmd_t),
+			0, NULL))) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for lio_cmd_cache\n");
+		goto out;
+	}
+
+	if (!(lio_sess_cache = kmem_cache_create("lio_sess_cache",
+			sizeof(iscsi_session_t), __alignof__(iscsi_session_t),
+			0, NULL))) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for lio_sess_cache\n");
+		goto out;
+	}
+
 	if (core_load_discovery_tpg() < 0)
 		goto out;
 
@@ -1113,6 +1126,10 @@ static int iscsi_target_detect(void)
 out:
 	plugin_deregister_class(PLUGIN_TYPE_FRONTEND);
 	core_release_discovery_tpg();
+	if (lio_cmd_cache)
+		kmem_cache_destroy(lio_cmd_cache);
+	if (lio_sess_cache)
+		kmem_cache_destroy(lio_sess_cache);
 	iscsi_deallocate_thread_sets(TARGET);
 	iscsi_target_deregister_configfs();
 #ifdef CONFIG_PROC_FS
@@ -1163,6 +1180,8 @@ extern void iscsi_target_release_phase2 (void)
 	iscsi_remove_all_tpgs();
 	core_release_nps();
 	iscsi_hba_del_all_hbas();
+	kmem_cache_destroy(lio_cmd_cache);
+	kmem_cache_destroy(lio_sess_cache);
 	core_release_discovery_tpg();
 	core_release_tiqns();
 	plugin_deregister_class(PLUGIN_TYPE_FRONTEND);
@@ -1249,6 +1268,11 @@ extern void frontend_load_plugins (void)
 	return;
 }
 
+extern char *iscsi_get_fabric_name (void)
+{
+	return("iSCSI");
+}
+
 extern iscsi_cmd_t *iscsi_get_cmd (se_cmd_t *se_cmd)
 {
         return((iscsi_cmd_t *)se_cmd->se_fabric_cmd_ptr);
@@ -2364,8 +2388,6 @@ static inline int iscsi_handle_task_mgt_cmd (
 
 	cmd->iscsi_opcode		= ISCSI_INIT_TASK_MGMT_CMND;
 	cmd->i_state			= ISTATE_SEND_TASKMGTRSP;
-// Already set in transport_generic_handle_tmr()
-//	cmd->t_state			= TRANSPORT_PROCESS_TMR;
 	cmd->immediate_cmd		= ((hdr->opcode & I_BIT) ? 1:0);
 #warning FIXME: iscsi_handle_task_mgt_cmd() broken for iscsi_lun
 //	cmd->iscsi_lun			= lun;
@@ -4257,8 +4279,14 @@ get_immediate:
 				spin_lock_bh(&conn->cmd_lock);
 				iscsi_remove_cmd_from_conn_list(cmd, conn);
 				spin_unlock_bh(&conn->cmd_lock);
-
-				transport_generic_free_cmd(SE_CMD(cmd), 1, 1, 0);
+				/*
+				 * Determine if a se_cmd_t is assoicated with
+				 * this iscsi_cmd_t.
+				 */
+				if (!(SE_CMD(cmd)))
+					iscsi_release_cmd_to_pool(cmd);
+				else
+					transport_generic_free_cmd(SE_CMD(cmd), 1, 1, 0);
 				goto get_immediate;
 			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
 				spin_unlock_bh(&cmd->istate_lock);
@@ -4365,7 +4393,7 @@ check_rsp_state:
 					break;
 				ret = iscsi_tmr_post_handler(cmd, conn);
 				if (ret != 0)
-					iscsi_fall_back_to_erl0(conn);
+					iscsi_fall_back_to_erl0(SESS(conn));
 				break;
 			case ISTATE_SEND_TEXTRSP:
 				spin_unlock_bh(&cmd->istate_lock);
@@ -4700,7 +4728,8 @@ static void iscsi_release_commands_from_conn (iscsi_conn_t *conn)
 	while (cmd) {
 		cmd_next = cmd->i_next;
 
-		if (!(cmd->cmd_flags & ICF_SE_LUN_CMD)) {
+		if (!(SE_CMD(cmd)) ||
+		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)) {
 			/*
 			 * CLOSESESSION and CLOSECONNECTION with a matching
 			 * logout_cid will be freed in iscsi_logout_post_handler().
@@ -4981,8 +5010,8 @@ extern int iscsi_close_connection (
 extern int iscsi_close_session (
 	iscsi_session_t *sess)
 {
-	iscsi_node_acl_t *acl;
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
+	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
 	
 	if (atomic_read(&sess->nconn)) {
 		TRACE_ERROR("%d connection(s) still exist for iSCSI session"
@@ -4991,22 +5020,20 @@ extern int iscsi_close_session (
 		BUG();
 	}
 	
-	spin_lock_bh(&tpg->session_lock);
+	spin_lock_bh(&se_tpg->session_lock);
 	atomic_set(&sess->session_logout, 1);
 	atomic_set(&sess->session_reinstatement, 1);
 	iscsi_stop_time2retain_timer(sess);
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 
 	/*
-	 * Clear the iscsi_node_acl->nacl_sess pointer now as a iscsi_np
-	 * context can be setting in iscsi_post_login_handler()  again
-	 * after out iscsi_stop_session() below.
+	 * transport_deregister_session_configfs() will clear the
+	 * se_node_acl_t->nacl_sess pointer now as a iscsi_np process context
+	 * can be setting it again with __transport_register_session() in
+	 * iscsi_post_login_handler() again after the iscsi_stop_session()
+	 * completes in iscsi_np context.
 	 */
-	if ((acl = sess->node_acl)) {
-		spin_lock(&acl->nacl_sess_lock);
-		acl->nacl_sess = NULL;
-		spin_unlock(&acl->nacl_sess_lock);
-	}
+        transport_deregister_session_configfs(sess->se_sess);
 
 	/*
 	 * If any other processes are accessing this session pointer we must wait until
@@ -5023,38 +5050,15 @@ extern int iscsi_close_session (
 			return(0);
 		}
 	}
-	
-	iscsi_remove_session_from_list(sess);
+
+	transport_deregister_session(sess->se_sess);
 
 	if (SESS_OPS(sess)->ErrorRecoveryLevel == 2)
 		iscsi_free_connection_recovery_entires(sess);
 
-	/*
-	 * Determine if we need to do extra work for this initiator
-	 * nodes iscsi_node_acl_t if it had been previously dynamically
-	 * generated.
-	 */
-	spin_lock_bh(&tpg->acl_node_lock);
-	if (acl) {
-		if (acl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
-			if (!(ISCSI_TPG_ATTRIB(tpg)->cache_dynamic_acls)) {
-				REMOVE_ENTRY_FROM_LIST(acl, tpg->acl_node_head,
-						tpg->acl_node_tail);
-				tpg->num_node_acls--;
-				spin_unlock_bh(&tpg->acl_node_lock);
-				iscsi_free_device_list_for_node(acl, tpg);
-				kfree(acl);
-				spin_lock_bh(&tpg->acl_node_lock);
-			}
-		}
-		sess->node_acl = NULL;
-	}
-	spin_unlock_bh(&tpg->acl_node_lock);
-
 	iscsi_free_all_ooo_cmdsns(sess);
-	iscsi_release_all_cmds_in_pool(sess);
 
-	spin_lock_bh(&tpg->session_lock);
+	spin_lock_bh(&se_tpg->session_lock);
 	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FREE.\n");
 	sess->session_state = TARG_SESS_STATE_FREE;
 	PYXPRINT("Released iSCSI session from node: %s\n",
@@ -5067,9 +5071,9 @@ extern int iscsi_close_session (
 		kfree(sess->sess_ops);
 		sess->sess_ops = NULL;
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 	
-	kfree(sess);
+	kmem_cache_free(lio_sess_cache, sess);
 	sess = NULL;
 
 	return(0);
@@ -5307,7 +5311,7 @@ extern int iscsi_free_session (iscsi_session_t *sess)
  *
  *
  */
-extern int iscsi_stop_session (iscsi_session_t *sess, int session_sleep, int connection_sleep)
+extern void iscsi_stop_session (iscsi_session_t *sess, int session_sleep, int connection_sleep)
 {
 	u16 conn_count = atomic_read(&sess->nconn);
 	iscsi_conn_t *conn, *conn_next = NULL;
@@ -5357,7 +5361,7 @@ extern int iscsi_stop_session (iscsi_session_t *sess, int session_sleep, int con
 		spin_unlock_bh(&sess->conn_lock);
 
 	TRACE_LEAVE
-	return(0);
+	return;
 }	
 
 /*	iscsi_release_sessions_for_tpg():
@@ -5366,40 +5370,40 @@ extern int iscsi_stop_session (iscsi_session_t *sess, int session_sleep, int con
  */
 extern int iscsi_release_sessions_for_tpg (iscsi_portal_group_t *tpg, int force)
 {
+	iscsi_session_t *sess;
+	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_session_t *se_sess, *se_sess_tmp;
 	int session_count = 0;
-	iscsi_session_t *sess = NULL, *sess_next = NULL;
 
 	TRACE_ENTER
 
-	spin_lock_bh(&tpg->session_lock);
+	spin_lock_bh(&se_tpg->session_lock);
 	if (tpg->nsessions && !force) {
-		spin_unlock_bh(&tpg->session_lock);
+		spin_unlock_bh(&se_tpg->session_lock);
 		return(-1);
 	}
 	
-	sess = tpg->session_head;
-	while (sess) {
-		sess_next = sess->next;
-		
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
+			sess_list) {
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;		
+
                 spin_lock(&sess->conn_lock);
                 if (atomic_read(&sess->session_fall_back_to_erl0) ||
                     atomic_read(&sess->session_logout) ||
                     (sess->time2retain_timer_flags & T2R_TF_EXPIRED)) {
 			spin_unlock(&sess->conn_lock);
-			sess = sess_next;
 			continue;
 		}
 		atomic_set(&sess->session_reinstatement, 1);
 		spin_unlock(&sess->conn_lock);
-		spin_unlock_bh(&tpg->session_lock);
+		spin_unlock_bh(&se_tpg->session_lock);
 
 		iscsi_free_session(sess);
-		spin_lock_bh(&tpg->session_lock);
+		spin_lock_bh(&se_tpg->session_lock);
 		
 		session_count++;
-		sess = sess_next;
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 
 	TRACE(TRACE_ISCSI, "Released %d iSCSI Session(s) from Target Portal"
 			" Group: %hu\n", session_count, tpg->tpgt);
diff --git a/drivers/lio-core/iscsi_target.h b/drivers/lio-core/iscsi_target.h
index c84a93f..91b3cb5 100644
--- a/drivers/lio-core/iscsi_target.h
+++ b/drivers/lio-core/iscsi_target.h
@@ -46,6 +46,7 @@ extern int __core_del_np_ex (iscsi_np_t *, iscsi_np_ex_t *);
 extern struct iscsi_np_s *core_add_np (iscsi_np_addr_t *, int, int *);
 extern int core_reset_np_thread (struct iscsi_np_s *, struct iscsi_tpg_np_s *, struct iscsi_portal_group_s *, int);
 extern int core_del_np (iscsi_np_t *);
+extern char *iscsi_get_fabric_name (void);
 extern iscsi_cmd_t *iscsi_get_cmd (struct se_cmd_s *);
 extern u32 iscsi_get_task_tag (struct se_cmd_s *);
 extern int iscsi_get_cmd_state (struct se_cmd_s *);
@@ -64,7 +65,7 @@ extern int iscsi_close_connection (iscsi_conn_t *);
 extern int iscsi_close_session (iscsi_session_t *);
 extern void iscsi_fail_session (iscsi_session_t *);
 extern int iscsi_free_session (iscsi_session_t *);
-extern int iscsi_stop_session (iscsi_session_t *, int, int);
+extern void iscsi_stop_session (iscsi_session_t *, int, int);
 extern int iscsi_release_sessions_for_tpg (iscsi_portal_group_t *, int);
 
 #endif   /*** ISCSI_TARGET_H ***/
-- 
1.5.4.1



