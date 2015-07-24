From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/4] iscsi-target: Fix iscsit_start_kthreads failure OOPs
Date: Fri, 24 Jul 2015 02:51:17 +0000
Message-ID: <1437706279-10580-3-git-send-email-nab@daterainc.com>
References: <1437706279-10580-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437706279-10580-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression introduced with the following commit
in v4.0-rc1 code, where a iscsit_start_kthreads() failure triggers
a NULL pointer dereference OOPs:

    commit 88dcd2dab5c23b1c9cfc396246d8f476c872f0ca
    Author: Nicholas Bellinger <nab@linux-iscsi.org>
    Date:   Thu Feb 26 22:19:15 2015 -0800

        iscsi-target: Convert iscsi_thread_set usage to kthread.h

To address this bug, move iscsit_start_kthreads() immediately
preceeding the transmit of last login response, before signaling
a successful transition into full-feature-phase within existing
iscsi_target_do_tx_login_io() logic.

This ensures that no target-side resource allocation failures can
occur after the final login response has been successfully sent.

Also, it adds a iscsi_conn->rx_login_comp to allow the RX thread
to sleep to prevent other socket related failures until the final
iscsi_post_login_handler() call is able to complete.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: <stable@vger.kernel.org> # v3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c       | 18 ++++++++++---
 drivers/target/iscsi/iscsi_target_login.c | 45 ++++++++++++-------------------
 drivers/target/iscsi/iscsi_target_login.h |  3 ++-
 drivers/target/iscsi/iscsi_target_nego.c  | 34 ++++++++++++++++++++++-
 include/target/iscsi/iscsi_target_core.h  |  1 +
 5 files changed, 68 insertions(+), 33 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index afab323..202a428 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3998,7 +3998,13 @@ get_immediate:
 	}
 
 transport_err:
-	iscsit_take_action_for_connection_exit(conn);
+	/*
+	 * Avoid the normal connection failure code-path if this connection
+	 * is still within LOGIN mode, and iscsi_np process context is
+	 * responsible for cleaning up the early connection failure.
+	 */
+	if (conn->conn_state != TARG_CONN_STATE_IN_LOGIN)
+		iscsit_take_action_for_connection_exit(conn);
 out:
 	return 0;
 }
@@ -4082,7 +4088,7 @@ reject:
 
 int iscsi_target_rx_thread(void *arg)
 {
-	int ret;
+	int ret, rc;
 	u8 buffer[ISCSI_HDR_LEN], opcode;
 	u32 checksum = 0, digest = 0;
 	struct iscsi_conn *conn = arg;
@@ -4092,10 +4098,16 @@ int iscsi_target_rx_thread(void *arg)
 	 * connection recovery / failure event can be triggered externally.
 	 */
 	allow_signal(SIGINT);
+	/*
+	 * Wait for iscsi_post_login_handler() to complete before allowing
+	 * incoming iscsi/tcp socket I/O, and/or failing the connection.
+	 */
+	rc = wait_for_completion_interruptible(&conn->rx_login_comp);
+	if (rc < 0)
+		return 0;
 
 	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND) {
 		struct completion comp;
-		int rc;
 
 		init_completion(&comp);
 		rc = wait_for_completion_interruptible(&comp);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 3d0fe4f..7e8f65e 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -82,6 +82,7 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 	init_completion(&conn->conn_logout_comp);
 	init_completion(&conn->rx_half_close_comp);
 	init_completion(&conn->tx_half_close_comp);
+	init_completion(&conn->rx_login_comp);
 	spin_lock_init(&conn->cmd_lock);
 	spin_lock_init(&conn->conn_usage_lock);
 	spin_lock_init(&conn->immed_queue_lock);
@@ -644,7 +645,7 @@ static void iscsi_post_login_start_timers(struct iscsi_conn *conn)
 		iscsit_start_nopin_timer(conn);
 }
 
-static int iscsit_start_kthreads(struct iscsi_conn *conn)
+int iscsit_start_kthreads(struct iscsi_conn *conn)
 {
 	int ret = 0;
 
@@ -679,6 +680,7 @@ static int iscsit_start_kthreads(struct iscsi_conn *conn)
 
 	return 0;
 out_tx:
+	send_sig(SIGINT, conn->tx_thread, 1);
 	kthread_stop(conn->tx_thread);
 	conn->tx_thread_active = false;
 out_bitmap:
@@ -689,7 +691,7 @@ out_bitmap:
 	return ret;
 }
 
-int iscsi_post_login_handler(
+void iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsi_conn *conn,
 	u8 zero_tsih)
@@ -699,7 +701,6 @@ int iscsi_post_login_handler(
 	struct se_session *se_sess = sess->se_sess;
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
-	int rc;
 
 	iscsit_inc_conn_usage_count(conn);
 
@@ -739,10 +740,6 @@ int iscsi_post_login_handler(
 			sess->sess_ops->InitiatorName);
 		spin_unlock_bh(&sess->conn_lock);
 
-		rc = iscsit_start_kthreads(conn);
-		if (rc)
-			return rc;
-
 		iscsi_post_login_start_timers(conn);
 		/*
 		 * Determine CPU mask to ensure connection's RX and TX kthreads
@@ -751,15 +748,20 @@ int iscsi_post_login_handler(
 		iscsit_thread_get_cpumask(conn);
 		conn->conn_rx_reset_cpumask = 1;
 		conn->conn_tx_reset_cpumask = 1;
-
+		/*
+		 * Wakeup the sleeping iscsi_target_rx_thread() now that
+		 * iscsi_conn is in TARG_CONN_STATE_LOGGED_IN state.
+		 */
+		complete(&conn->rx_login_comp);
 		iscsit_dec_conn_usage_count(conn);
+
 		if (stop_timer) {
 			spin_lock_bh(&se_tpg->session_lock);
 			iscsit_stop_time2retain_timer(sess);
 			spin_unlock_bh(&se_tpg->session_lock);
 		}
 		iscsit_dec_session_usage_count(sess);
-		return 0;
+		return;
 	}
 
 	iscsi_set_session_parameters(sess->sess_ops, conn->param_list, 1);
@@ -800,10 +802,6 @@ int iscsi_post_login_handler(
 		" iSCSI Target Portal Group: %hu\n", tpg->nsessions, tpg->tpgt);
 	spin_unlock_bh(&se_tpg->session_lock);
 
-	rc = iscsit_start_kthreads(conn);
-	if (rc)
-		return rc;
-
 	iscsi_post_login_start_timers(conn);
 	/*
 	 * Determine CPU mask to ensure connection's RX and TX kthreads
@@ -812,10 +810,12 @@ int iscsi_post_login_handler(
 	iscsit_thread_get_cpumask(conn);
 	conn->conn_rx_reset_cpumask = 1;
 	conn->conn_tx_reset_cpumask = 1;
-
+	/*
+	 * Wakeup the sleeping iscsi_target_rx_thread() now that
+	 * iscsi_conn is in TARG_CONN_STATE_LOGGED_IN state.
+	 */
+	complete(&conn->rx_login_comp);
 	iscsit_dec_conn_usage_count(conn);
-
-	return 0;
 }
 
 static void iscsi_handle_login_thread_timeout(unsigned long data)
@@ -1380,23 +1380,12 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	if (ret < 0)
 		goto new_sess_out;
 
-	if (!conn->sess) {
-		pr_err("struct iscsi_conn session pointer is NULL!\n");
-		goto new_sess_out;
-	}
-
 	iscsi_stop_login_thread_timer(np);
 
-	if (signal_pending(current))
-		goto new_sess_out;
-
 	if (ret == 1) {
 		tpg_np = conn->tpg_np;
 
-		ret = iscsi_post_login_handler(np, conn, zero_tsih);
-		if (ret < 0)
-			goto new_sess_out;
-
+		iscsi_post_login_handler(np, conn, zero_tsih);
 		iscsit_deaccess_np(np, tpg, tpg_np);
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 1c73580..57aa0d0 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -12,7 +12,8 @@ extern int iscsit_accept_np(struct iscsi_np *, struct iscsi_conn *);
 extern int iscsit_get_login_rx(struct iscsi_conn *, struct iscsi_login *);
 extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
 extern void iscsit_free_conn(struct iscsi_np *, struct iscsi_conn *);
-extern int iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
+extern int iscsit_start_kthreads(struct iscsi_conn *);
+extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
 extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
 				bool, bool);
 extern int iscsi_target_login_thread(void *);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 8c02fa3..f9cde91 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -17,6 +17,7 @@
  ******************************************************************************/
 
 #include <linux/ctype.h>
+#include <linux/kthread.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
@@ -361,10 +362,24 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 		ntohl(login_rsp->statsn), login->rsp_length);
 
 	padding = ((-login->rsp_length) & 3);
+	/*
+	 * Before sending the last login response containing the transition
+	 * bit for full-feature-phase, go ahead and start up TX/RX threads
+	 * now to avoid potential resource allocation failures after the
+	 * final login response has been sent.
+	 */
+	if (login->login_complete) {
+		int rc = iscsit_start_kthreads(conn);
+		if (rc) {
+			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
+			return -1;
+		}
+	}
 
 	if (conn->conn_transport->iscsit_put_login_tx(conn, login,
 					login->rsp_length + padding) < 0)
-		return -1;
+		goto err;
 
 	login->rsp_length		= 0;
 	mutex_lock(&sess->cmdsn_mutex);
@@ -373,6 +388,23 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 	mutex_unlock(&sess->cmdsn_mutex);
 
 	return 0;
+
+err:
+	if (login->login_complete) {
+		if (conn->rx_thread && conn->rx_thread_active) {
+			send_sig(SIGINT, conn->rx_thread, 1);
+			kthread_stop(conn->rx_thread);
+		}
+		if (conn->tx_thread && conn->tx_thread_active) {
+			send_sig(SIGINT, conn->tx_thread, 1);
+			kthread_stop(conn->tx_thread);
+		}
+		spin_lock(&iscsit_global->ts_bitmap_lock);
+		bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
+				      get_order(1));
+		spin_unlock(&iscsit_global->ts_bitmap_lock);
+	}
+	return -1;
 }
 
 static void iscsi_target_sk_data_ready(struct sock *sk)
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 34117b8..0aedbb2 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -595,6 +595,7 @@ struct iscsi_conn {
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
+	struct completion	rx_login_comp;
 	int			tx_thread_active;
 	struct task_struct	*tx_thread;
 	/* list_head for session connection list */
-- 
1.9.1
