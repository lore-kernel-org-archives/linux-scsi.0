From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 5/14]: Make iscsi_target_util.c use generic
	target_core_mod code
Date: Fri, 19 Dec 2008 15:32:37 -0800
Message-ID: <1229729557.4560.110.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756012AbYLSXd2@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From db08ddfd02cfeb5ce792c5b0c00d4db3c9d09473 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:10:47 -0800
Subject: [PATCH] [LIO-Target]: Make iscsi_target_util.c use generic target_core_mod code

This patch removes the following functions that have been made generic in
Target_Core_Mod v3.0:

iscsi_remove_session_from_list()
iscsi_get_cmd_from_pool()
iscsi_dec_nacl_count()
iscsi_release_all_cmds_in_pool()
iscsi_get_tpg_session_from_sid()

Also, this patch updates iscsi_allocate_cmd() to use lio_cmd_cache, and
iscsi_allocate_se_cmd() to properly set iscsi_cmd_t->se_cmd from the return of
targe_core_mod:transport_alloc_se_cmd()

Also, convert NOPIN timer logic to use iscsi_node_attrib_t from iscsi_tpg_get_node_attrib(),
getting rid of the iscsi_node_acl_t.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_util.c |  227 +++++-----------------------------
 drivers/lio-core/iscsi_target_util.h |    5 -
 2 files changed, 34 insertions(+), 198 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_util.c b/drivers/lio-core/iscsi_target_util.c
index 491409a..cb679b8 100644
--- a/drivers/lio-core/iscsi_target_util.c
+++ b/drivers/lio-core/iscsi_target_util.c
@@ -48,12 +48,15 @@
 #include <iscsi_debug.h>
 #include <iscsi_protocol.h>
 #include <iscsi_serial.h>
-#include <iscsi_target_core.h>
+
 #include <target_core_base.h>
+#include <target_core_transport.h>
+
+#include <iscsi_target_core.h>
 #include <iscsi_target_erl0.h>
 #include <iscsi_target_erl1.h>
 #include <iscsi_target_erl2.h>
-#include <target_core_transport.h>
+#include <iscsi_target_tpg.h>
 #include <iscsi_target_util.h>
 #include <iscsi_target.h>
 #include <iscsi_parameters.h>
@@ -69,7 +72,8 @@
 
 extern struct target_fabric_configfs *lio_target_fabric_configfs;
 extern iscsi_global_t *iscsi_global;
-extern int iscsi_check_acl_for_lun (se_device_t *, iscsi_conn_t *);
+extern struct kmem_cache *lio_cmd_cache;
+
 extern int iscsi_add_nopin (iscsi_conn_t *, int);
 
 /*	iscsi_attach_cmd_to_queue():
@@ -179,21 +183,6 @@ extern void iscsi_remove_conn_from_list (iscsi_session_t *sess, iscsi_conn_t *co
 	return;
 }
 
-/*	iscsi_remove_session_from_list():
- *
- *
- */
-extern void iscsi_remove_session_from_list (iscsi_session_t *sess)
-{
-	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
-	
-	spin_lock_bh(&tpg->session_lock);
-	REMOVE_ENTRY_FROM_LIST(sess, tpg->session_head, tpg->session_tail);
-	spin_unlock_bh(&tpg->session_lock);
-		
-	return;
-}
-
 /*	iscsi_add_r2t_to_list():
  *
  *	Called with cmd->r2t_lock held.
@@ -316,22 +305,19 @@ extern void iscsi_free_r2ts_from_list (
 	return;
 }
 
-/*	__iscsi_allocate_cmd():
- *
+/*	iscsi_allocate_cmd():
  *
+ *	May be called from interrupt context.
  */
 extern iscsi_cmd_t *iscsi_allocate_cmd (
 	iscsi_conn_t *conn)
 {
 	iscsi_cmd_t *cmd;
 
-	if (!(cmd = iscsi_get_cmd_from_pool(SESS(conn)))) {
-		if (!(cmd = (iscsi_cmd_t *)
-				kzalloc(sizeof(iscsi_cmd_t), GFP_ATOMIC))) {
-			TRACE_ERROR("Unable to allocate memory"
-				" for iscsi_cmd_t.\n");
-			return(NULL);
-		}
+	if (!(cmd = (iscsi_cmd_t *)kmem_cache_zalloc(lio_cmd_cache,
+			GFP_ATOMIC))) {
+		TRACE_ERROR("Unable to allocate memory for iscsi_cmd_t.\n");
+		return(NULL);
 	}
 
 	cmd->conn	= conn;	
@@ -355,7 +341,6 @@ extern iscsi_cmd_t *iscsi_allocate_se_cmd (
 	int data_direction)
 {
 	iscsi_cmd_t *cmd;
-	se_cmd_t *se_cmd;
 
 	if (!(cmd = iscsi_allocate_cmd(conn))) 
 		return(NULL);
@@ -365,18 +350,10 @@ extern iscsi_cmd_t *iscsi_allocate_se_cmd (
 	/*
 	 * Use struct target_fabric_configfs->tf_ops for lio_target_fabric_configfs
 	 */
-	if (!(se_cmd = transport_alloc_se_cmd(&lio_target_fabric_configfs->tf_ops,
-			(void *)cmd, data_length, data_direction))) 
+	if (!(cmd->se_cmd = transport_alloc_se_cmd(&lio_target_fabric_configfs->tf_ops,
+			SESS(conn)->se_sess, (void *)cmd, data_length, data_direction))) 
 		goto out;
-#if 0
-	INIT_LIST_HEAD(&T_TASK(cmd)->t_task_list);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->transport_lun_fe_stop_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->transport_lun_stop_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->t_transport_stop_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->t_transport_passthrough_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->t_transport_passthrough_wsem);
-	spin_lock_init(&T_TASK(cmd)->t_state_lock);
-#endif
+
 	return(cmd);
 out:
 	iscsi_release_cmd_to_pool(cmd);
@@ -410,8 +387,8 @@ extern int iscsi_decide_list_to_build (
 {
 	iscsi_build_list_t bl;
 	iscsi_conn_t *conn = CONN(cmd);
-	iscsi_node_acl_t *acl;
 	iscsi_session_t *sess = SESS(conn);
+	iscsi_node_attrib_t *na;
 	
 	TRACE_ENTER
 		
@@ -422,20 +399,20 @@ extern int iscsi_decide_list_to_build (
 	if (cmd->data_direction == ISCSI_NONE)
 		return(0);
 	
-	acl = sess->node_acl;
+	na = iscsi_tpg_get_node_attrib(sess);
 	memset(&bl, 0, sizeof(iscsi_build_list_t));
 
 	if (cmd->data_direction == ISCSI_READ) {
 		bl.data_direction = ISCSI_PDU_READ;
 		bl.type = PDULIST_NORMAL;
-		if (ISCSI_NODE_ATTRIB(acl)->random_datain_pdu_offsets)
+		if (na->random_datain_pdu_offsets)
 			bl.randomize |= RANDOM_DATAIN_PDU_OFFSETS;
-		if (ISCSI_NODE_ATTRIB(acl)->random_datain_seq_offsets)
+		if (na->random_datain_seq_offsets)
 			bl.randomize |= RANDOM_DATAIN_SEQ_OFFSETS;
 	} else {
 		bl.data_direction = ISCSI_PDU_WRITE;
 		bl.immediate_data_length = immediate_data_length;
-		if (ISCSI_NODE_ATTRIB(acl)->random_r2t_offsets)
+		if (na->random_r2t_offsets)
 			bl.randomize |= RANDOM_R2T_OFFSETS;
 
 		if (!cmd->immediate_data && !cmd->unsolicited_data)
@@ -1079,32 +1056,6 @@ extern void iscsi_free_queue_reqs_for_conn (iscsi_conn_t *conn)
 	return;
 }
 
-/*	iscsi_get_cmd_from_pool():
- *
- *
- */
-extern iscsi_cmd_t *iscsi_get_cmd_from_pool (iscsi_session_t *sess)
-{
-	iscsi_cmd_t *cmd;
-
-	spin_lock_bh(&sess->pool_lock);
-	if (!sess->pool_head) {
-		spin_unlock_bh(&sess->pool_lock);
-		return (NULL);
-	}
-
-	cmd = sess->pool_head;
-	sess->pool_head = sess->pool_head->next;
-
-	if (!sess->pool_head)
-		sess->pool_tail = NULL;
-	spin_unlock_bh(&sess->pool_lock);
-
-	atomic_dec(&sess->pool_count);
-
-	return(cmd);
-}
-
 /*	iscsi_release_cmd_direct():
  *
  *
@@ -1120,10 +1071,7 @@ extern void iscsi_release_cmd_direct (iscsi_cmd_t *cmd)
 	if (cmd->seq_list)
 		kfree(cmd->seq_list);
 
-	memset(cmd, 0, sizeof(iscsi_cmd_t));
-	
-	kfree(cmd);
-	
+	kmem_cache_free(lio_cmd_cache, cmd);
 	return;
 }
 
@@ -1132,25 +1080,6 @@ extern void lio_release_cmd_direct (se_cmd_t *se_cmd)
 	iscsi_release_cmd_direct((iscsi_cmd_t *)se_cmd->se_fabric_cmd_ptr);
 }
 
-#warning FIXME: iscsi_dec_nacl_count() is broken
-extern void iscsi_dec_nacl_count (iscsi_node_acl_t *nacl, iscsi_cmd_t *cmd)
-{
-	se_dev_entry_t *deve;
-
-	if (!cmd)
-		return;
-#if 0
-	deve = &nacl->device_list[cmd->orig_fe_lun];
-	spin_lock_bh(&nacl->device_list_lock);
-	deve->deve_cmds--;
-	spin_unlock_bh(&nacl->device_list_lock);
-#else
-	BUG();
-#endif
-
-	return;
-}
-
 /*	__iscsi_release_cmd_to_pool():
  *
  *
@@ -1171,18 +1100,7 @@ extern void __iscsi_release_cmd_to_pool (iscsi_cmd_t *cmd, iscsi_session_t *sess
 	if (conn)
 		iscsi_remove_cmd_from_tx_queues(cmd, conn);
 
-	memset(cmd, 0, sizeof(iscsi_cmd_t));
-
-	spin_lock_bh(&sess->pool_lock);
-	if (!sess->pool_head && !sess->pool_tail)
-		sess->pool_head		= cmd;
-	else
-		sess->pool_tail->next	= cmd;
-	sess->pool_tail			= cmd;
-	spin_unlock_bh(&sess->pool_lock);
-
-	atomic_inc(&sess->pool_count);
-
+	kmem_cache_free(lio_cmd_cache, cmd);
 	return;
 }
 
@@ -1210,47 +1128,6 @@ extern void lio_release_cmd_to_pool (se_cmd_t *se_cmd)
 	iscsi_release_cmd_to_pool((iscsi_cmd_t *)se_cmd->se_fabric_cmd_ptr);
 }
 
-/*	iscsi_release_all_cmds_in_pool():
- *
- *
- */
-extern void iscsi_release_all_cmds_in_pool (iscsi_session_t *sess)
-{
-	__u32 release_cmd_count = 0;
-	iscsi_cmd_t *cmd, *cmd_next;
-
-	spin_lock_bh(&sess->pool_lock);
-	cmd = sess->pool_head;
-	while (cmd) {
-		cmd_next = cmd->next;
-		
-		if (cmd->buf_ptr) 
-			kfree(cmd->buf_ptr);
-		if (cmd->pdu_list)
-			kfree(cmd->pdu_list);
-		if (cmd->seq_list)
-			kfree(cmd->seq_list);
-		
-		kfree(cmd);
-
-		cmd = cmd_next;
-		release_cmd_count++;
-	}
-	spin_unlock_bh(&sess->pool_lock);
-
-	if (release_cmd_count != atomic_read(&sess->pool_count)) {
-		TRACE_ERROR("Released cmd pool count %d does not equal"
-			" saved value %d.\n", release_cmd_count,
-				atomic_read(&sess->pool_count));
-	} else {
-		TRACE(TRACE_ISCSI, "Released %d cmds from iSCSI Session"
-			" Pool.\n", release_cmd_count);
-		atomic_set(&sess->pool_count, 0);
-	}
-
-	return;
-}
-
 /*	iscsi_pack_lun():
  *
  *	Routine to pack an ordinary (LINUX) LUN 32-bit number
@@ -1324,32 +1201,6 @@ inline __u32 iscsi_unpack_lun (unsigned char *lun_ptr)
 	return(result);
 }
 
-/*	iscsi_get_tpg_session_from_sid():
- *
- *
- */
-extern iscsi_session_t *iscsi_get_tpg_session_from_sid (iscsi_portal_group_t *tpg, u32 sid)
-{
-	iscsi_session_t *sess;
-
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
-		if (sess->sid == sid) {
-			iscsi_inc_session_usage_count(sess);
-			break;
-		}
-	}
-	spin_unlock_bh(&tpg->session_lock);
-
-	if (!sess) {
-		TRACE_ERROR("Unable to locate iSBE SID: %u on iSCSI TPG: %hu,"
-			" ignoring request.\n", sid, tpg->tpgt);
-		return(NULL);
-	}
-	
-	return(sess);
-}
-
 /*	iscsi_check_session_usage_count():
  *
  *
@@ -1940,7 +1791,7 @@ static void iscsi_update_counters (iscsi_conn_t *conn, u32 timeout)
 	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
 		deve = &node_acl->device_list[i];
 
-		if (!(deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS))
+		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
 			continue;
 		
 		this_count = deve->total_bytes;
@@ -2144,7 +1995,7 @@ extern void iscsi_mod_nopin_response_timer (
 	iscsi_conn_t *conn)
 {
 	iscsi_session_t *sess = SESS(conn);
-	iscsi_node_acl_t *acl = sess->node_acl;
+	iscsi_node_attrib_t *na = iscsi_tpg_get_node_attrib(sess);
 	
 	TRACE_ENTER
 
@@ -2154,8 +2005,7 @@ extern void iscsi_mod_nopin_response_timer (
 		return;
 	}
 
-	MOD_TIMER(&conn->nopin_response_timer,
-		ISCSI_NODE_ATTRIB(acl)->nopin_response_timeout);	
+	MOD_TIMER(&conn->nopin_response_timer, na->nopin_response_timeout);	
 	spin_unlock_bh(&conn->nopin_timer_lock);
 	
 	TRACE_LEAVE
@@ -2170,7 +2020,7 @@ extern void iscsi_start_nopin_response_timer (
 	iscsi_conn_t *conn)
 {
 	iscsi_session_t *sess = SESS(conn);
-	iscsi_node_acl_t *acl = sess->node_acl;
+	iscsi_node_attrib_t *na = iscsi_tpg_get_node_attrib(sess);
 	
 	TRACE_ENTER
 
@@ -2181,16 +2031,14 @@ extern void iscsi_start_nopin_response_timer (
 	}
 
 	init_timer(&conn->nopin_response_timer);
-	SETUP_TIMER(conn->nopin_response_timer,
-		ISCSI_NODE_ATTRIB(acl)->nopin_response_timeout,
+	SETUP_TIMER(conn->nopin_response_timer, na->nopin_response_timeout,
 		conn, iscsi_handle_nopin_response_timeout);
 	conn->nopin_response_timer_flags &= ~NOPIN_RESPONSE_TF_STOP;
 	conn->nopin_response_timer_flags |= NOPIN_RESPONSE_TF_RUNNING;
 	add_timer(&conn->nopin_response_timer);
 
 	TRACE(TRACE_TIMER, "Started NOPIN Response Timer on CID: %d to %u"
-		" seconds\n", conn->cid,
-		ISCSI_NODE_ATTRIB(acl)->nopin_response_timeout);
+		" seconds\n", conn->cid, na->nopin_response_timeout);
 	spin_unlock_bh(&conn->nopin_timer_lock);
 		
 	TRACE_LEAVE
@@ -2229,10 +2077,6 @@ static void iscsi_handle_nopin_timeout (
 	unsigned long data)
 {
 	iscsi_conn_t *conn = (iscsi_conn_t *) data;
-#if 0
-	iscsi_session_t *sess = SESS(conn);
-	iscsi_node_acl_t *acl = sess->node_acl;
-#endif
 	
 	iscsi_inc_conn_usage_count(conn);
 		
@@ -2244,9 +2088,7 @@ static void iscsi_handle_nopin_timeout (
 	}
 	conn->nopin_timer_flags &= ~NOPIN_TF_RUNNING;
 	spin_unlock_bh(&conn->nopin_timer_lock);
-#if 0	
-	iscsi_update_counters(conn, ISCSI_NODE_ATTRIB(acl)->nopin_timeout);
-#endif
+
 	iscsi_add_nopin(conn, 1);
 	iscsi_dec_conn_usage_count(conn);
 	
@@ -2261,7 +2103,7 @@ extern void iscsi_start_nopin_timer (
 	iscsi_conn_t *conn)
 {
 	iscsi_session_t *sess = SESS(conn);
-	iscsi_node_acl_t *acl = sess->node_acl;
+	iscsi_node_attrib_t *na = iscsi_tpg_get_node_attrib(sess);
 	
 	TRACE_ENTER
 
@@ -2272,15 +2114,14 @@ extern void iscsi_start_nopin_timer (
 	}
 
 	init_timer(&conn->nopin_timer);
-	SETUP_TIMER(conn->nopin_timer, ISCSI_NODE_ATTRIB(acl)->nopin_timeout,
-			conn, iscsi_handle_nopin_timeout);
+	SETUP_TIMER(conn->nopin_timer, na->nopin_timeout, conn,
+			iscsi_handle_nopin_timeout);
 	conn->nopin_timer_flags &= ~NOPIN_TF_STOP;
 	conn->nopin_timer_flags |= NOPIN_TF_RUNNING;
 	add_timer(&conn->nopin_timer);
 
 	TRACE(TRACE_TIMER, "Started NOPIN Timer on CID: %d at %u second"
-			" interval\n", conn->cid,
-			ISCSI_NODE_ATTRIB(acl)->nopin_timeout);
+			" interval\n", conn->cid, na->nopin_timeout);
 	spin_unlock_bh(&conn->nopin_timer_lock);
 		
 	TRACE_LEAVE
diff --git a/drivers/lio-core/iscsi_target_util.h b/drivers/lio-core/iscsi_target_util.h
index 18afd1c..93ba4c0 100644
--- a/drivers/lio-core/iscsi_target_util.h
+++ b/drivers/lio-core/iscsi_target_util.h
@@ -38,7 +38,6 @@ extern void iscsi_attach_cmd_to_queue (iscsi_conn_t *, iscsi_cmd_t *);
 extern void iscsi_remove_cmd_from_conn_list (iscsi_cmd_t *, iscsi_conn_t *);
 extern void iscsi_ack_from_expstatsn (iscsi_conn_t *, __u32);
 extern void iscsi_remove_conn_from_list (iscsi_session_t *, iscsi_conn_t *);
-extern void iscsi_remove_session_from_list (iscsi_session_t *);
 extern int iscsi_add_r2t_to_list (iscsi_cmd_t *, __u32, __u32, int, __u32);
 extern iscsi_r2t_t *iscsi_get_r2t_for_eos (iscsi_cmd_t *, __u32, __u32);
 extern iscsi_r2t_t *iscsi_get_r2t_from_list (iscsi_cmd_t *);
@@ -63,17 +62,13 @@ extern void iscsi_add_cmd_to_response_queue (iscsi_cmd_t *, iscsi_conn_t *, u8);
 extern iscsi_queue_req_t *iscsi_get_cmd_from_response_queue (iscsi_conn_t *);
 extern void iscsi_remove_cmd_from_tx_queues (iscsi_cmd_t *, iscsi_conn_t *);
 extern void iscsi_free_queue_reqs_for_conn (iscsi_conn_t *);
-extern iscsi_cmd_t *iscsi_get_cmd_from_pool (iscsi_session_t *);
 extern void iscsi_release_cmd_direct (iscsi_cmd_t *);
 extern void lio_release_cmd_direct (struct se_cmd_s *);
-extern void iscsi_dec_nacl_count (iscsi_node_acl_t *, iscsi_cmd_t *);
 extern void __iscsi_release_cmd_to_pool (iscsi_cmd_t *, iscsi_session_t *);
 extern void iscsi_release_cmd_to_pool (iscsi_cmd_t *);
 extern void lio_release_cmd_to_pool (struct se_cmd_s *);
-extern void iscsi_release_all_cmds_in_pool (iscsi_session_t *);
 extern __u64 iscsi_pack_lun (unsigned int);
 extern __u32 iscsi_unpack_lun (unsigned char *);
-extern iscsi_session_t *iscsi_get_tpg_session_from_sid (iscsi_portal_group_t *, __u32);
 extern int iscsi_check_session_usage_count (iscsi_session_t *);
 extern void iscsi_dec_session_usage_count (iscsi_session_t *);
 extern void iscsi_inc_session_usage_count (iscsi_session_t *);
-- 
1.5.4.1
