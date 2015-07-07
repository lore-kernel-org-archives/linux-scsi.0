From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] iscsi-target: Fix iscsit_start_kthreads failure OOPs
Date: Tue,  7 Jul 2015 08:50:23 +0000
Message-ID: <1436259023-1561-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression introduced with the following commit
in v4.0-rc1 code:

    commit 88dcd2dab5c23b1c9cfc396246d8f476c872f0ca
    Author: Nicholas Bellinger <nab@linux-iscsi.org>
    Date:   Thu Feb 26 22:19:15 2015 -0800

        iscsi-target: Convert iscsi_thread_set usage to kthread.h

where iscsit_start_kthreads() failure would result in a NULL pointer
dereference OOPs.

To address this bug, it adds a iscsit_kthread_err() helper to cleanup
both zero_tsih and !zero_tsih cases, and a iscsi_target_tx_thread()
special case to avoid iscsit_take_action_for_connection_exit() during
the late iscsit_start_kthreads() -> kthread_run() failure case for
iscsi_target_rx_thread().

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: <stable@vger.kernel.org> # v3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c       |  3 ++-
 drivers/target/iscsi/iscsi_target_login.c | 39 +++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 4e68b62..66655b7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3998,7 +3998,8 @@ get_immediate:
 	}
 
 transport_err:
-	iscsit_take_action_for_connection_exit(conn);
+	if (conn->rx_thread_active)
+		iscsit_take_action_for_connection_exit(conn);
 out:
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 3d0fe4f..76dedb6 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -679,6 +679,7 @@ static int iscsit_start_kthreads(struct iscsi_conn *conn)
 
 	return 0;
 out_tx:
+	send_sig(SIGINT, conn->tx_thread, 1);
 	kthread_stop(conn->tx_thread);
 	conn->tx_thread_active = false;
 out_bitmap:
@@ -689,6 +690,23 @@ out_bitmap:
 	return ret;
 }
 
+static void iscsit_kthread_err(struct iscsi_session *sess,
+			       struct iscsi_conn *conn, bool new_sess)
+{
+	spin_lock_bh(&sess->conn_lock);
+	list_del(&conn->conn_list);
+	if (atomic_dec_and_test(&sess->nconn))
+		sess->session_state = TARG_SESS_STATE_FAILED;
+	spin_unlock_bh(&sess->conn_lock);
+
+	if (!new_sess)
+		return;
+
+	transport_deregister_session_configfs(sess->se_sess);
+	transport_deregister_session(sess->se_sess);
+	sess->se_sess = NULL;
+}
+
 int iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsi_conn *conn,
@@ -740,8 +758,10 @@ int iscsi_post_login_handler(
 		spin_unlock_bh(&sess->conn_lock);
 
 		rc = iscsit_start_kthreads(conn);
-		if (rc)
-			return rc;
+		if (rc) {
+			iscsit_kthread_err(sess, conn, false);
+			goto out_old_sess;
+		}
 
 		iscsi_post_login_start_timers(conn);
 		/*
@@ -751,7 +771,7 @@ int iscsi_post_login_handler(
 		iscsit_thread_get_cpumask(conn);
 		conn->conn_rx_reset_cpumask = 1;
 		conn->conn_tx_reset_cpumask = 1;
-
+out_old_sess:
 		iscsit_dec_conn_usage_count(conn);
 		if (stop_timer) {
 			spin_lock_bh(&se_tpg->session_lock);
@@ -759,7 +779,7 @@ int iscsi_post_login_handler(
 			spin_unlock_bh(&se_tpg->session_lock);
 		}
 		iscsit_dec_session_usage_count(sess);
-		return 0;
+		return rc;
 	}
 
 	iscsi_set_session_parameters(sess->sess_ops, conn->param_list, 1);
@@ -801,8 +821,17 @@ int iscsi_post_login_handler(
 	spin_unlock_bh(&se_tpg->session_lock);
 
 	rc = iscsit_start_kthreads(conn);
-	if (rc)
+	if (rc) {
+		spin_lock_bh(&se_tpg->session_lock);
+		if (tpg->tpg_tiqn)
+			tpg->tpg_tiqn->tiqn_nsessions--;
+		tpg->nsessions--;
+		spin_unlock_bh(&se_tpg->session_lock);
+
+		iscsit_kthread_err(sess, conn, true);
+		iscsit_dec_conn_usage_count(conn);
 		return rc;
+	}
 
 	iscsi_post_login_start_timers(conn);
 	/*
-- 
1.9.1
