From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/2] iscsi-target: Fix rx_login_comp hang after login failure
Date: Sun, 15 Nov 2015 00:21:42 +0000
Message-ID: <1447546903-15305-2-git-send-email-nab@daterainc.com>
References: <1447546903-15305-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447546903-15305-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a case where iscsi_target_do_tx_login_io()
fails sending the last login response PDU, after the RX/TX
threads have already been started.

The case centers around iscsi_target_rx_thread() not invoking
allow_signal(SIGINT) before the send_sig(SIGINT, ...) occurs
from the failure path, resulting in RX thread hanging
indefinately on iscsi_conn->rx_login_comp.

Note this bug is a regression introduced by:

  commit e54198657b65625085834847ab6271087323ffea
  Author: Nicholas Bellinger <nab@linux-iscsi.org>
  Date:   Wed Jul 22 23:14:19 2015 -0700

      iscsi-target: Fix iscsit_start_kthreads failure OOPs

To address this bug, complete ->rx_login_complete for good
measure in the failure path, and immediately return from
RX thread context if connection state did not actually reach
full feature phase (TARG_CONN_STATE_LOGGED_IN).

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: <stable@vger.kernel.org> # v3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c      | 13 ++++++++++++-
 drivers/target/iscsi/iscsi_target_nego.c |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 342a07c..72204fb 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4074,6 +4074,17 @@ reject:
 	return iscsit_add_reject(conn, ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 }
 
+static bool iscsi_target_check_conn_state(struct iscsi_conn *conn)
+{
+	bool ret;
+
+	spin_lock_bh(&conn->state_lock);
+	ret = (conn->conn_state != TARG_CONN_STATE_LOGGED_IN);
+	spin_unlock_bh(&conn->state_lock);
+
+	return ret;
+}
+
 int iscsi_target_rx_thread(void *arg)
 {
 	int ret, rc;
@@ -4091,7 +4102,7 @@ int iscsi_target_rx_thread(void *arg)
 	 * incoming iscsi/tcp socket I/O, and/or failing the connection.
 	 */
 	rc = wait_for_completion_interruptible(&conn->rx_login_comp);
-	if (rc < 0)
+	if (rc < 0 || iscsi_target_check_conn_state(conn))
 		return 0;
 
 	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND) {
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 5c964c0..9fc9117 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -388,6 +388,7 @@ err:
 	if (login->login_complete) {
 		if (conn->rx_thread && conn->rx_thread_active) {
 			send_sig(SIGINT, conn->rx_thread, 1);
+			complete(&conn->rx_login_comp);
 			kthread_stop(conn->rx_thread);
 		}
 		if (conn->tx_thread && conn->tx_thread_active) {
-- 
1.9.1
