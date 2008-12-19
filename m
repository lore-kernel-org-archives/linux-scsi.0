From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 10/14]: Update iscsi_target_login.c for
	generic target_core_mod logic
Date: Fri, 19 Dec 2008 15:35:49 -0800
Message-ID: <1229729749.4560.120.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751807AbYLSXgd@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From 367d4b8512fd1cea11e3a52be8dd388975b65c98 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:25:46 -0800
Subject: [PATCH] [LIO-Target]: Update iscsi_target_login.c for generic target_core_mod logic

This patch adds Target_Core_Mod:__transport_register_session() usage in
iscsi_post_login_handler().

This patch converts iSCSI Login logic to use se_portal_group_t->tpg_sess_list
in iscsi_check_for_session_reinstatement() and iscsi_login_non_zero_tsih_s2().

It also adds the uage of struct kmem_cache lio_sess_cache in
iscsi_login_zero_tsih_s1() and iscsi_target_login_thread().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_login.c |   90 +++++++++++++++++---------------
 1 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_login.c b/drivers/lio-core/iscsi_target_login.c
index 9434363..a28a314 100644
--- a/drivers/lio-core/iscsi_target_login.c
+++ b/drivers/lio-core/iscsi_target_login.c
@@ -47,12 +47,14 @@
 #include <iscsi_debug_opcodes.h>
 #include <iscsi_debug.h>
 #include <iscsi_lists.h>
-#include <iscsi_target_core.h>
 #include <target_core_base.h>
+#include <target_core_transport.h>
+#include <iscsi_target_core.h>
 #include <iscsi_target_device.h>
 #include <iscsi_target_nego.h>
 #include <iscsi_target_erl0.h>
 #include <iscsi_target_erl2.h>
+#include <iscsi_target_tpg.h>
 #include <iscsi_target_util.h>
 #include <iscsi_target.h>
 #include <iscsi_parameters.h>
@@ -60,8 +62,7 @@
 #undef ISCSI_TARGET_LOGIN_C
 
 extern iscsi_global_t *iscsi_global;
-extern int iscsi_close_session (iscsi_session_t *);
-extern int iscsi_stop_session (iscsi_session_t *, int, int);
+extern struct kmem_cache *lio_sess_cache;
 
 /*	iscsi_login_init_conn():
  *
@@ -119,6 +120,8 @@ extern int iscsi_check_for_session_reinstatement (iscsi_conn_t *conn)
 	iscsi_param_t *initiatorname_param = NULL, *sessiontype_param = NULL;
 	iscsi_portal_group_t *tpg = conn->tpg;
 	iscsi_session_t *sess = NULL;
+	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_session_t *se_sess, *se_sess_tmp;
 	
 	if (!(initiatorname_param = iscsi_find_param_from_key(
 			INITIATORNAME, conn->param_list)))
@@ -130,8 +133,11 @@ extern int iscsi_check_for_session_reinstatement (iscsi_conn_t *conn)
 
 	sessiontype = (strncmp(sessiontype_param->value, NORMAL, 6)) ? 1 : 0;
 	
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
+	spin_lock_bh(&se_tpg->session_lock);
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
+			sess_list) {
+
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
 		spin_lock(&sess->conn_lock);
 		if (atomic_read(&sess->session_fall_back_to_erl0) ||
 		    atomic_read(&sess->session_logout) ||
@@ -151,7 +157,7 @@ extern int iscsi_check_for_session_reinstatement (iscsi_conn_t *conn)
 		}
 		spin_unlock(&sess->conn_lock);
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 
 	/*              
 	 * If the Time2Retain handler has expired, the session is already gone.
@@ -208,12 +214,11 @@ static int iscsi_login_zero_tsih_s1 (
 	iscsi_session_t *sess = NULL;
 	struct iscsi_init_login_cmnd *pdu = (struct iscsi_init_login_cmnd *) buf;
 
-	if (!(sess = (iscsi_session_t *) kmalloc(sizeof(iscsi_session_t), GFP_KERNEL))) {
+	if (!(sess = kmem_cache_zalloc(lio_sess_cache, GFP_KERNEL))) {
 		iscsi_tx_login_rsp(conn, STAT_CLASS_TARGET, STAT_DETAIL_OUT_OF_RESOURCE);
 		TRACE_ERROR("Could not allocate memory for session\n");
 		return(-1);
 	}
-	memset(sess, 0, sizeof(iscsi_session_t));
 
 	iscsi_login_set_conn_values(sess, conn, pdu->cid);
 	sess->init_task_tag	= pdu->init_task_tag;
@@ -227,7 +232,6 @@ static int iscsi_login_zero_tsih_s1 (
 	spin_lock_init(&sess->conn_lock);
 	spin_lock_init(&sess->cr_a_lock);
 	spin_lock_init(&sess->cr_i_lock);
-	spin_lock_init(&sess->pool_lock);
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
 #ifdef SNMP_SUPPORT
@@ -243,12 +247,16 @@ static int iscsi_login_zero_tsih_s1 (
 	sess->max_cmd_sn	= pdu->cmd_sn;
 
 	if (!(sess->sess_ops = (iscsi_sess_ops_t *)
-			kmalloc(sizeof(iscsi_sess_ops_t), GFP_KERNEL))) {
+			kzalloc(sizeof(iscsi_sess_ops_t), GFP_KERNEL))) {
 		iscsi_tx_login_rsp(conn, STAT_CLASS_TARGET, STAT_DETAIL_OUT_OF_RESOURCE);
 		TRACE_ERROR("Unable to allocate memory for iscsi_sess_ops_t.\n");
 		return(-1);
 	}
-	memset(sess->sess_ops, 0, sizeof(iscsi_sess_ops_t));
+
+	if (!(sess->se_sess = transport_allocate_session())) {
+		iscsi_tx_login_rsp(conn, STAT_CLASS_TARGET, STAT_DETAIL_OUT_OF_RESOURCE);
+		return(-1);
+	}
 
 	return(0);
 }
@@ -256,7 +264,7 @@ static int iscsi_login_zero_tsih_s1 (
 static int iscsi_login_zero_tsih_s2 (
 	iscsi_conn_t *conn)
 {
-	iscsi_node_acl_t *acl;
+	iscsi_node_attrib_t *na;
 	iscsi_session_t *sess = conn->sess;
 	unsigned char buf[32];
 
@@ -282,7 +290,7 @@ static int iscsi_login_zero_tsih_s2 (
 	if (SESS_OPS(sess)->SessionType)
 		return(iscsi_set_keys_irrelevant_for_discovery(conn->param_list));
 
-	acl = sess->node_acl;
+	na = iscsi_tpg_get_node_attrib(sess);
 
 	/*
 	 * Need to send TargetPortalGroupTag back in first login response
@@ -304,7 +312,7 @@ static int iscsi_login_zero_tsih_s2 (
 	 * "We would really like to get rid of this." Linux-iSCSI.org team
 	 */
 	memset(buf, 0, 32);
-	sprintf(buf, "ErrorRecoveryLevel=%d", ISCSI_NODE_ATTRIB(acl)->default_erl);
+	sprintf(buf, "ErrorRecoveryLevel=%d", na->default_erl);
 	if (iscsi_change_param_value(buf, TARGET, conn->param_list, 0) < 0) {
 		iscsi_tx_login_rsp(conn, STAT_CLASS_TARGET, STAT_DETAIL_OUT_OF_RESOURCE);
 		return(-1);
@@ -375,10 +383,15 @@ static int iscsi_login_non_zero_tsih_s2 (
 {
 	iscsi_portal_group_t *tpg = conn->tpg;
 	iscsi_session_t *sess = NULL;
+	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
+	se_session_t *se_sess, *se_sess_tmp;
 	struct iscsi_init_login_cmnd *pdu = (struct iscsi_init_login_cmnd *) buf;
 	
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
+	spin_lock_bh(&se_tpg->session_lock);
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
+			sess_list) {
+
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
 		if (atomic_read(&sess->session_fall_back_to_erl0) ||
 		    atomic_read(&sess->session_logout) ||
 		   (sess->time2retain_timer_flags & T2R_TF_EXPIRED))
@@ -391,7 +404,7 @@ static int iscsi_login_non_zero_tsih_s2 (
 			break;
 		}
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 
 	/*
 	 * If the Time2Retain handler has expired, the session is already gone.
@@ -540,7 +553,9 @@ static int iscsi_post_login_handler (iscsi_np_t *np, iscsi_conn_t *conn, __u8 ze
 	unsigned char buf_ipv4[IPV4_BUF_SIZE], buf1_ipv4[IPV4_BUF_SIZE];
 	unsigned char *ip, *ip_np;
 	iscsi_session_t *sess = SESS(conn);
+	se_session_t *se_sess = sess->se_sess;
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
+	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
 	se_thread_set_t *ts;
 
 	iscsi_inc_conn_usage_count(conn);
@@ -598,9 +613,9 @@ static int iscsi_post_login_handler (iscsi_np_t *np, iscsi_conn_t *conn, __u8 ze
 		iscsi_activate_thread_set(conn, ts);
 		iscsi_dec_conn_usage_count(conn);
 		if (stop_timer) {
-			spin_lock_bh(&tpg->session_lock);
+			spin_lock_bh(&se_tpg->session_lock);
 			iscsi_stop_time2retain_timer(sess);
-			spin_unlock_bh(&tpg->session_lock);
+			spin_unlock_bh(&se_tpg->session_lock);
 		}
 		iscsi_dec_session_usage_count(sess);
 		return(0);
@@ -610,16 +625,11 @@ static int iscsi_post_login_handler (iscsi_np_t *np, iscsi_conn_t *conn, __u8 ze
 	iscsi_release_param_list(conn->param_list);
 	conn->param_list = NULL;
 
-	iscsi_determine_maxcmdsn(sess, sess->node_acl);
-		
-	if (!(SESS_OPS(sess)->SessionType)) {
-		spin_lock_bh(&sess->node_acl->nacl_sess_lock);
-		sess->node_acl->nacl_sess = sess;
-		spin_unlock_bh(&sess->node_acl->nacl_sess_lock);
-	}
+	iscsi_determine_maxcmdsn(sess);
 
-	spin_lock_bh(&tpg->session_lock);
-	ADD_ENTRY_TO_LIST(sess, tpg->session_head, tpg->session_tail);
+	spin_lock_bh(&se_tpg->session_lock);
+	__transport_register_session(sess->tpg->tpg_se_tpg, se_sess->se_node_acl,
+			se_sess, (void *)sess);
 	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 	sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 	
@@ -642,7 +652,7 @@ static int iscsi_post_login_handler (iscsi_np_t *np, iscsi_conn_t *conn, __u8 ze
 	tpg->nsessions++;
 	PYXPRINT("Incremented number of active iSCSI sessions to %u on iSCSI"
 		" Target Portal Group: %hu\n", tpg->nsessions, tpg->tpgt); 
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 
 	iscsi_post_login_start_timers(conn);
 	iscsi_activate_thread_set(conn, ts);
@@ -776,13 +786,11 @@ static struct socket *iscsi_target_setup_login_socket (iscsi_np_t *np)
 	if ((np->np_network_transport == ISCSI_SCTP_TCP) ||
 	    (np->np_network_transport == ISCSI_SCTP_UDP)) {
 		if (!sock->file) {
-			if (!(sock->file = kmalloc(
+			if (!(sock->file = kzalloc(
 					sizeof(struct file), GFP_KERNEL))) {
 				TRACE_ERROR("Unable to allocate struct file for SCTP\n");
 				goto fail;
 			}
-			memset(sock->file, 0, sizeof(struct file));
-
 			np->np_flags |= NPF_SCTP_STRUCT_FILE;
 		}
 	}
@@ -942,7 +950,7 @@ get_new_sock:
 	if ((np->np_network_transport == ISCSI_SCTP_TCP) ||
 	    (np->np_network_transport == ISCSI_SCTP_UDP)) {
 		if (!new_sock->file) {
-			if (!(new_sock->file = kmalloc(
+			if (!(new_sock->file = kzalloc(
 					sizeof(struct file), GFP_KERNEL))) {
 				TRACE_ERROR("Unable to allocate struct file for SCTP\n");
 				if (start) {
@@ -951,8 +959,6 @@ get_new_sock:
 				}
 				goto get_new_sock;
 			}
-			memset(new_sock->file, 0, sizeof(struct file));
-
 			set_sctp_conn_flag = 1;
 		}
 	}
@@ -1007,7 +1013,7 @@ get_new_sock:
 
 	iscsi_start_login_thread_timer(np);
 	
-	if (!(conn = (iscsi_conn_t *) kmalloc(
+	if (!(conn = (iscsi_conn_t *) kzalloc(
 			sizeof(iscsi_conn_t), GFP_KERNEL))) {
 		TRACE_ERROR("Could not allocate memory for"
 			" new connection\n");
@@ -1020,7 +1026,6 @@ get_new_sock:
 		}
 		goto get_new_sock;
 	}
-	memset(conn, 0, sizeof(iscsi_conn_t));
 	
 	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
@@ -1036,13 +1041,12 @@ get_new_sock:
 	 * Allocate conn->conn_ops early as a failure calling
 	 * iscsi_tx_login_rsp() below will call tx_data().
 	 */     
-	if (!(conn->conn_ops = (iscsi_conn_ops_t *)kmalloc(
+	if (!(conn->conn_ops = (iscsi_conn_ops_t *)kzalloc(
 			sizeof(iscsi_conn_ops_t), GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate memory for"
 			" iscsi_conn_ops_t.\n");
 		goto new_sess_out;
 	}	
-	memset(conn->conn_ops, 0, sizeof(iscsi_conn_ops_t));
 
         iscsi_login_init_conn(conn);
 
@@ -1240,7 +1244,7 @@ new_sess_out:
 	if (SESS(conn)->sess_ops)
 		kfree(SESS(conn)->sess_ops);
 	if (SESS(conn))
-		kfree(SESS(conn));
+		kmem_cache_free(lio_sess_cache, SESS(conn));
 old_sess_out:
 	iscsi_stop_login_thread_timer(np);
 	/*
@@ -1250,11 +1254,13 @@ old_sess_out:
 	if (!zero_tsih && SESS(conn)) {
 		spin_lock_bh(&SESS(conn)->conn_lock);
 		if (SESS(conn)->session_state == TARG_SESS_STATE_FAILED) {
+			se_portal_group_t *se_tpg = ISCSI_TPG_C(conn)->tpg_se_tpg;
+
 			atomic_set(&SESS(conn)->session_continuation, 0);
 			spin_unlock_bh(&SESS(conn)->conn_lock);
-			spin_lock_bh(&ISCSI_TPG_C(conn)->session_lock);
+			spin_lock_bh(&se_tpg->session_lock);
 			iscsi_start_time2retain_handler(SESS(conn));
-			spin_unlock_bh(&ISCSI_TPG_C(conn)->session_lock);
+			spin_unlock_bh(&se_tpg->session_lock);
 		} else
 			spin_unlock_bh(&SESS(conn)->conn_lock);
 		iscsi_dec_session_usage_count(SESS(conn));
-- 
1.5.4.1
