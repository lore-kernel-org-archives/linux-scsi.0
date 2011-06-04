From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] iscsi-target: Convert to cmdsn_mutex and transport_handle_cdb_direct usage
Date: Fri,  3 Jun 2011 23:01:30 -0700
Message-ID: <1307167290-24832-3-git-send-email-nab@linux-iscsi.org>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm15-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.17]:37223
	"HELO nm15-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751535Ab1FDGBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2011 02:01:53 -0400
In-Reply-To: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts iscsi-target from a spinning sess->cmdsn_lock to a
sleeping sess->cmdsn_mutex which has been done to allow direct RX thread
context task queueing using the new transport_handle_cdb_direct() caller
into target core.

This conversion was necessary in order to queue tasks directly with
transport_handle_cdb_direct() -> transport_generic_new_cmd(), which
may end up sleeping in the following execution path:

	iscsit_handle_scsi_cmd() ->
		iscsit_sequence_cmd() ->
			iscsit_execute_cmd() ->
				transport_handle_cdb_direct()
					transport_generic_new_cmd()

This patch converts iscsit_execute_cmd() to be protected by a sleeping
->cmdsn_mutex so that transport_generic_new_cmd() can be called while
protecting the session wide CmdSN list.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_core.h   |    2 +-
 drivers/target/iscsi/iscsi_target_device.c |    4 ++--
 drivers/target/iscsi/iscsi_target_erl1.c   |   18 +++++++++---------
 drivers/target/iscsi/iscsi_target_erl2.c   |    4 ++--
 drivers/target/iscsi/iscsi_target_login.c  |    2 +-
 drivers/target/iscsi/iscsi_target_nego.c   |    4 ++--
 drivers/target/iscsi/iscsi_target_util.c   |    4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 4aef392..5bf2f7a 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -613,7 +613,7 @@ struct iscsi_session {
 	u32			cmdsn_window;
 
 	/* protects cmdsn values */
-	spinlock_t		cmdsn_lock;
+	struct mutex		cmdsn_mutex;
 	/* session wide counter: expected command sequence number */
 	u32			exp_cmd_sn;
 	/* session wide counter: maximum allowed command sequence number */
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 3693258..b855c68 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -81,8 +81,8 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess
 
 	cmd->maxcmdsn_inc = 1;
 
-	spin_lock(&sess->cmdsn_lock);
+	mutex_lock(&sess->cmdsn_mutex);
 	sess->max_cmd_sn += 1;
 	TRACE(TRACE_ISCSI, "Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
-	spin_unlock(&sess->cmdsn_lock);
+	mutex_unlock(&sess->cmdsn_mutex);
 }
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 9d66ada..c4242d8 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -803,7 +803,7 @@ static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 }
 
 /*
- *	Called with sess->cmdsn_lock held.
+ *	Called with sess->cmdsn_mutex held.
  */
 static int iscsit_attach_ooo_cmdsn(
 	struct iscsi_session *sess,
@@ -850,7 +850,7 @@ static int iscsit_attach_ooo_cmdsn(
 
 /*
  *	Removes an struct iscsi_ooo_cmdsn from a session's list,
- *	called with struct iscsi_session->cmdsn_lock held.
+ *	called with struct iscsi_session->cmdsn_mutex held.
  */
 void iscsit_remove_ooo_cmdsn(
 	struct iscsi_session *sess,
@@ -865,18 +865,18 @@ void iscsit_clear_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 	struct iscsi_ooo_cmdsn *ooo_cmdsn;
 	struct iscsi_session *sess = conn->sess;
 
-	spin_lock(&sess->cmdsn_lock);
+	mutex_lock(&sess->cmdsn_mutex);
 	list_for_each_entry(ooo_cmdsn, &sess->sess_ooo_cmdsn_list, ooo_list) {
 		if (ooo_cmdsn->cid != conn->cid)
 			continue;
 
 		ooo_cmdsn->cmd = NULL;
 	}
-	spin_unlock(&sess->cmdsn_lock);
+	mutex_unlock(&sess->cmdsn_mutex);
 }
 
 /*
- *	Called with sess->cmdsn_lock held.
+ *	Called with sess->cmdsn_mutex held.
  */
 int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
 {
@@ -917,7 +917,7 @@ int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
 /*
  *	Called either:
  *
- *	1. With sess->cmdsn_lock held from iscsi_execute_ooo_cmdsns()
+ *	1. With sess->cmdsn_mutex held from iscsi_execute_ooo_cmdsns()
  *	or iscsi_check_received_cmdsn().
  *	2. With no locks held directly from iscsi_handle_XXX_pdu() functions
  *	for immediate commands.
@@ -1012,7 +1012,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 			iscsit_start_dataout_timer(cmd, cmd->conn);
 			spin_unlock_bh(&cmd->dataout_timeout_lock);
 		}
-		return transport_generic_handle_cdb(&cmd->se_cmd);
+		return transport_handle_cdb_direct(&cmd->se_cmd);
 
 	case ISCSI_OP_NOOP_OUT:
 	case ISCSI_OP_TEXT:
@@ -1062,14 +1062,14 @@ void iscsit_free_all_ooo_cmdsns(struct iscsi_session *sess)
 {
 	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
 
-	spin_lock(&sess->cmdsn_lock);
+	mutex_lock(&sess->cmdsn_mutex);
 	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
 			&sess->sess_ooo_cmdsn_list, ooo_list) {
 
 		list_del(&ooo_cmdsn->ooo_list);
 		kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
 	}
-	spin_unlock(&sess->cmdsn_lock);
+	mutex_unlock(&sess->cmdsn_mutex);
 }
 
 int iscsit_handle_ooo_cmdsn(
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index ad7d7ce..a810e59 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -300,7 +300,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
 	struct iscsi_session *sess = conn->sess;
 
-	spin_lock(&sess->cmdsn_lock);
+	mutex_lock(&sess->cmdsn_mutex);
 	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
 			&sess->sess_ooo_cmdsn_list, ooo_list) {
 
@@ -313,7 +313,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 			ooo_cmdsn->cmdsn, conn->cid);
 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
 	}
-	spin_unlock(&sess->cmdsn_lock);
+	mutex_unlock(&sess->cmdsn_mutex);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 44642ff..1b2ffe0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -240,7 +240,7 @@ static int iscsi_login_zero_tsih_s1(
 	init_completion(&sess->reinstatement_comp);
 	init_completion(&sess->session_wait_comp);
 	init_completion(&sess->session_waiting_on_uc_comp);
-	spin_lock_init(&sess->cmdsn_lock);
+	mutex_init(&sess->cmdsn_mutex);
 	spin_lock_init(&sess->conn_lock);
 	spin_lock_init(&sess->cr_a_lock);
 	spin_lock_init(&sess->cr_i_lock);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index ab387c9..565dbea 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -368,10 +368,10 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 	login_rsp->tsih			= be16_to_cpu(login_rsp->tsih);
 	login_rsp->itt			= be32_to_cpu(login_rsp->itt);
 	login_rsp->statsn		= be32_to_cpu(login_rsp->statsn);
-	spin_lock(&sess->cmdsn_lock);
+	mutex_lock(&sess->cmdsn_mutex);
 	login_rsp->exp_cmdsn		= be32_to_cpu(sess->exp_cmd_sn);
 	login_rsp->max_cmdsn		= be32_to_cpu(sess->max_cmd_sn);
-	spin_unlock(&sess->cmdsn_lock);
+	mutex_unlock(&sess->cmdsn_mutex);
 
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 7eeddd2..e677fa0 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -435,7 +435,7 @@ int iscsit_sequence_cmd(
 	int ret;
 	int cmdsn_ret;
 
-	spin_lock(&conn->sess->cmdsn_lock);
+	mutex_lock(&conn->sess->cmdsn_mutex);
 
 	cmdsn_ret = iscsit_check_received_cmdsn(conn->sess, cmdsn);
 	switch (cmdsn_ret) {
@@ -456,7 +456,7 @@ int iscsit_sequence_cmd(
 		ret = cmdsn_ret;
 		break;
 	}
-	spin_unlock(&conn->sess->cmdsn_lock);
+	mutex_unlock(&conn->sess->cmdsn_mutex);
 
 	return ret;
 }
-- 
1.7.2.5

