From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 25/34] iscsi-target: move iscsit_thread_check_cpumask()
Date: Sun, 14 Feb 2016 23:15:32 +0530
Message-ID: <ef1ba538d9532c70e573e0fd662cd3ad4f410882.1455467089.git.varun@chelsio.com>
References: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:15113 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751317AbcBNRqD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:46:03 -0500
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

move iscsit_thread_check_cpumask() to header
file so that ISCSI_TCP_CXGB4 and other transport drivers
can call this function to ensure both tx and rx thread
runs on same cpu.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c      | 26 --------------------------
 include/target/iscsi/iscsi_target_core.h | 26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 485e33a..a3b9397 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3751,32 +3751,6 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
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
index 0edf18b..7ca3cce 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -891,4 +891,30 @@ static inline u32 session_get_next_ttt(struct iscsi_session *session)
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

