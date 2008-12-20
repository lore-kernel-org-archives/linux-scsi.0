From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/8] [LIO-Target/ConfigFS]: Add lio_tpg_shutdown_session()
	and lio_tpg_close_session()
Date: Sat, 20 Dec 2008 15:03:46 -0800
Message-ID: <1229814226.4560.206.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:28701 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751799AbYLTXEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2008 18:04:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From ea00424b724c550338c019e9846027e19d26c1e6 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 14:04:57 -0800
Subject: [PATCH 7/8] [LIO-Target/ConfigFS]: Add lio_tpg_shutdown_session() and lio_tpg_close_session()

This patch adds the above functions for use with struct target_core_fabric_ops,
and sets function pointers in iscsi_target_register_configfs().  This was
required in order to get session shutdown functionality working in a $FABRIC_MOD
independent manner in core_tpg_del_initiator_node_acl() and
core_tpg_set_initiator_node_queue_depth() from target_core_tpg.c.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |    2 +
 drivers/lio-core/iscsi_target_tpg.c      |   43 ++++++++++++++++++++++++++++++
 drivers/lio-core/iscsi_target_tpg.h      |    2 +
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 6e71822..9906ad8 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -2297,6 +2297,8 @@ extern int iscsi_target_register_configfs (void)
 	fabric->tf_ops.tpg_release_node_acl = &lio_tpg_release_node_acl;
 	fabric->tf_ops.release_cmd_to_pool = &lio_release_cmd_to_pool;
 	fabric->tf_ops.release_cmd_direct = &lio_release_cmd_direct;
+	fabric->tf_ops.shutdown_session = &lio_tpg_shutdown_session;
+	fabric->tf_ops.close_session = &lio_tpg_close_session;
 	fabric->tf_ops.stop_session = &lio_tpg_stop_session;
 	fabric->tf_ops.fall_back_to_erl0 = &lio_tpg_fall_back_to_erl0;
 	fabric->tf_ops.write_pending = &lio_write_pending;
diff --git a/drivers/lio-core/iscsi_target_tpg.c b/drivers/lio-core/iscsi_target_tpg.c
index 4def3cb..3068aba 100644
--- a/drivers/lio-core/iscsi_target_tpg.c
+++ b/drivers/lio-core/iscsi_target_tpg.c
@@ -129,6 +129,49 @@ extern void lio_tpg_release_node_acl (se_portal_group_t *se_tpg, se_node_acl_t *
 	return;
 }
 
+/*
+ * Called with spin_lock_bh(se_portal_group_t->session_lock) held..
+ *
+ * Also, this function calls iscsi_inc_session_usage_count() on the
+ * iscsi_session_t in question.
+ */
+extern int lio_tpg_shutdown_session (se_session_t *se_sess)
+{
+	iscsi_session_t *sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+
+	spin_lock(&sess->conn_lock);
+	if (atomic_read(&sess->session_fall_back_to_erl0) ||
+	    atomic_read(&sess->session_logout) ||
+	    (sess->time2retain_timer_flags & T2R_TF_EXPIRED)) {
+		spin_unlock(&sess->conn_lock);
+		return(0);
+	}
+	atomic_set(&sess->session_reinstatement, 1);
+	spin_unlock(&sess->conn_lock);
+
+	iscsi_inc_session_usage_count(sess);
+	iscsi_stop_time2retain_timer(sess);
+
+	return(1);
+}
+
+/*
+ * Calls iscsi_dec_session_usage_count() as inverse of lio_tpg_shutdown_session()
+ */
+extern void lio_tpg_close_session (se_session_t *se_sess)
+{
+	iscsi_session_t *sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+	/*
+	 * If the iSCSI Session for the iSCSI Initiator Node exists,
+	 * forcefully shutdown the iSCSI NEXUS.
+	 */
+	iscsi_stop_session(sess, 1, 1);
+	iscsi_dec_session_usage_count(sess);
+	iscsi_close_session(sess);
+
+	return;
+}
+
 extern void lio_tpg_stop_session (se_session_t *se_sess, int sess_sleep, int conn_sleep)
 {
 	iscsi_session_t *sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
diff --git a/drivers/lio-core/iscsi_target_tpg.h b/drivers/lio-core/iscsi_target_tpg.h
index 6b4554f..68fb2a8 100644
--- a/drivers/lio-core/iscsi_target_tpg.h
+++ b/drivers/lio-core/iscsi_target_tpg.h
@@ -36,6 +36,8 @@ extern int lio_tpg_check_demo_mode (struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_cache (struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_write_protect (struct se_portal_group_s *);
 extern void lio_tpg_release_node_acl (struct se_portal_group_s *, struct se_node_acl_s *);
+extern int lio_tpg_shutdown_session (struct se_session_s *);
+extern void lio_tpg_close_session (struct se_session_s *);
 extern void lio_tpg_stop_session (struct se_session_s *, int, int);
 extern void lio_tpg_fall_back_to_erl0 (struct se_session_s *);
 extern u32 lio_tpg_get_inst_index (struct se_portal_group_s *);
-- 
1.5.4.1



