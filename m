From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 07/13] iscsi-target: move iscsit_thread_check_cpumask()
Date: Wed, 20 Apr 2016 00:00:14 +0530
Message-ID: <85d0f369652ed7ae04e5267bb2abff09e0d4d710.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Move iscsit_thread_check_cpumask() to header
file so that ISCSI_HW_OFFLOAD and other transport drivers
can call this function to ensure both tx and rx thread
runs on same cpu.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c      | 26 --------------------------
 include/target/iscsi/iscsi_target_core.h | 26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a28eb87..28fc7fb 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3580,32 +3580,6 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
 	cpumask_setall(conn->conn_cpumask);
 }
 
-static inline void iscsit_thread_check_cpumask(
-	struct iscsi_conn *conn,
-	struct task_struct *p,
-	int mode)
-{
-	/*
-	 * mode == 1 signals iscsi_target_tx_thread() usage.
-	 * mode == 0 signals iscsi_target_rx_thread() usage.
-	 */
-	if (mode == 1) {
-		if (!conn->conn_tx_reset_cpumask)
-			return;
-		conn->conn_tx_reset_cpumask = 0;
-	} else {
-		if (!conn->conn_rx_reset_cpumask)
-			return;
-		conn->conn_rx_reset_cpumask = 0;
-	}
-	/*
-	 * Update the CPU mask for this single kthread so that
-	 * both TX and RX kthreads are scheduled to run on the
-	 * same CPU.
-	 */
-	set_cpus_allowed_ptr(p, conn->conn_cpumask);
-}
-
 static int
 iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 {
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index c3371fa..01c41f2 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -890,4 +890,30 @@ static inline u32 session_get_next_ttt(struct iscsi_session *session)
 }
 
 extern struct iscsi_cmd *iscsit_find_cmd_from_itt(struct iscsi_conn *, itt_t);
+
+static inline void iscsit_thread_check_cpumask(
+	struct iscsi_conn *conn,
+	struct task_struct *p,
+	int mode)
+{
+	/*
+	 * mode == 1 signals iscsi_target_tx_thread() usage.
+	 * mode == 0 signals iscsi_target_rx_thread() usage.
+	 */
+	if (mode == 1) {
+		if (!conn->conn_tx_reset_cpumask)
+			return;
+		conn->conn_tx_reset_cpumask = 0;
+	} else {
+		if (!conn->conn_rx_reset_cpumask)
+			return;
+		conn->conn_rx_reset_cpumask = 0;
+	}
+	/*
+	 * Update the CPU mask for this single kthread so that
+	 * both TX and RX kthreads are scheduled to run on the
+	 * same CPU.
+	 */
+	set_cpus_allowed_ptr(p, conn->conn_cpumask);
+}
 #endif /* ISCSI_TARGET_CORE_H */
-- 
2.0.2
