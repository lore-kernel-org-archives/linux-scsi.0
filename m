From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 14/16] iscsi-target: export symbols
Date: Sat,  9 Apr 2016 18:41:24 +0530
Message-ID: <c69aa8c4daf965ae1dab9f2cea3417fdcc8e36cd.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:19921 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754734AbcDINNw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2016 09:13:52 -0400
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

export symbols for ISCSI_HW_OFFLOAD
transport drivers.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c               | 25 ++++++++++-------
 drivers/target/iscsi/iscsi_target_datain_values.c |  1 +
 drivers/target/iscsi/iscsi_target_login.c         |  3 ++-
 drivers/target/iscsi/iscsi_target_nego.c          |  1 +
 drivers/target/iscsi/iscsi_target_parameters.c    |  1 +
 drivers/target/iscsi/iscsi_target_util.c          |  2 ++
 include/target/iscsi/iscsi_transport.h            | 33 +++++++++++++++++++++++
 7 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index edce5af..941f676 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -478,17 +478,16 @@ int iscsit_del_np(struct iscsi_np *np)
 	return 0;
 }
 
-static int iscsit_immediate_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
-static int iscsit_response_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
 static void iscsit_get_rx_pdu(struct iscsi_conn *);
 
-static int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
+int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_queue_rsp);
 
-static void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
+void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	bool scsi_cmd = (cmd->iscsi_opcode == ISCSI_OP_SCSI_CMD);
 
@@ -499,6 +498,7 @@ static void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 
 	__iscsit_free_cmd(cmd, scsi_cmd, true);
 }
+EXPORT_SYMBOL(iscsit_aborted_task);
 
 static void *iscsit_alloc_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
@@ -795,7 +795,7 @@ static void __exit iscsi_target_cleanup_module(void)
 	kfree(iscsit_global);
 }
 
-static int iscsit_add_reject(
+int iscsit_add_reject(
 	struct iscsi_conn *conn,
 	u8 reason,
 	unsigned char *buf)
@@ -825,6 +825,7 @@ static int iscsit_add_reject(
 
 	return -1;
 }
+EXPORT_SYMBOL(iscsit_add_reject);
 
 static int iscsit_add_reject_from_cmd(
 	struct iscsi_cmd *cmd,
@@ -880,6 +881,7 @@ int iscsit_reject_cmd(struct iscsi_cmd *cmd, u8 reason, unsigned char *buf)
 {
 	return iscsit_add_reject_from_cmd(cmd, reason, false, buf);
 }
+EXPORT_SYMBOL(iscsit_reject_cmd);
 
 /*
  * Map some portion of the allocated scatterlist to an iovec, suitable for
@@ -2496,7 +2498,7 @@ iscsit_handle_logout_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 }
 EXPORT_SYMBOL(iscsit_handle_logout_cmd);
 
-static int iscsit_handle_snack(
+int iscsit_handle_snack(
 	struct iscsi_conn *conn,
 	unsigned char *buf)
 {
@@ -2549,6 +2551,7 @@ static int iscsit_handle_snack(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_handle_snack);
 
 static void iscsit_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
 {
@@ -2732,7 +2735,7 @@ static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
 	}
 }
 
-static void
+void
 iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 			struct iscsi_datain *datain, struct iscsi_data_rsp *hdr,
 			bool set_statsn)
@@ -2776,6 +2779,7 @@ iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
 		ntohl(hdr->offset), datain->length, conn->cid);
 }
+EXPORT_SYMBOL(iscsit_build_datain_pdu);
 
 static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
@@ -3174,6 +3178,7 @@ int iscsit_build_r2ts_for_cmd(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_build_r2ts_for_cmd);
 
 void iscsit_build_rsp_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 			bool inc_stat_sn, struct iscsi_scsi_rsp *hdr)
@@ -3619,7 +3624,7 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
 	cpumask_setall(conn->conn_cpumask);
 }
 
-static int
+int
 iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 {
 	int ret;
@@ -3661,6 +3666,7 @@ iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state
 err:
 	return -1;
 }
+EXPORT_SYMBOL(iscsit_immediate_queue);
 
 static int
 iscsit_handle_immediate_queue(struct iscsi_conn *conn)
@@ -3685,7 +3691,7 @@ iscsit_handle_immediate_queue(struct iscsi_conn *conn)
 	return 0;
 }
 
-static int
+int
 iscsit_response_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 {
 	int ret;
@@ -3790,6 +3796,7 @@ check_rsp_state:
 err:
 	return -1;
 }
+EXPORT_SYMBOL(iscsit_response_queue);
 
 static int iscsit_handle_response_queue(struct iscsi_conn *conn)
 {
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index fb3b52b..647d4a5 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -524,3 +524,4 @@ struct iscsi_datain_req *iscsit_get_datain_values(
 
 	return NULL;
 }
+EXPORT_SYMBOL(iscsit_get_datain_values);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 83574eea..a09498f 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -258,7 +258,7 @@ static void iscsi_login_set_conn_values(
 	mutex_unlock(&auth_id_lock);
 }
 
-static __printf(2, 3) int iscsi_change_param_sprintf(
+__printf(2, 3) int iscsi_change_param_sprintf(
 	struct iscsi_conn *conn,
 	const char *fmt, ...)
 {
@@ -279,6 +279,7 @@ static __printf(2, 3) int iscsi_change_param_sprintf(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsi_change_param_sprintf);
 
 /*
  *	This is the leading connection of a new session,
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 9fc9117..ca06132 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -269,6 +269,7 @@ int iscsi_target_check_login_request(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsi_target_check_login_request);
 
 static int iscsi_target_check_first_request(
 	struct iscsi_conn *conn,
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 3a1f9a7..0efa80b 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -680,6 +680,7 @@ struct iscsi_param *iscsi_find_param_from_key(
 	pr_err("Unable to locate key \"%s\".\n", key);
 	return NULL;
 }
+EXPORT_SYMBOL(iscsi_find_param_from_key);
 
 int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 {
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index a533017..43e176f 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -514,6 +514,7 @@ void iscsit_add_cmd_to_immediate_queue(
 
 	wake_up(&conn->queues_wq);
 }
+EXPORT_SYMBOL(iscsit_add_cmd_to_immediate_queue);
 
 struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsi_conn *conn)
 {
@@ -776,6 +777,7 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 		break;
 	}
 }
+EXPORT_SYMBOL(iscsit_free_cmd);
 
 int iscsit_check_session_usage_count(struct iscsi_session *sess)
 {
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index f949e70..05aeedc 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -89,6 +89,18 @@ extern void iscsit_build_reject(struct iscsi_cmd *, struct iscsi_conn *,
 extern int iscsit_build_logout_rsp(struct iscsi_cmd *, struct iscsi_conn *,
 				struct iscsi_logout_rsp *);
 extern int iscsit_logout_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
+extern int iscsit_queue_rsp(struct iscsi_conn *, struct iscsi_cmd *);
+extern void iscsit_aborted_task(struct iscsi_conn *, struct iscsi_cmd *);
+extern int iscsit_add_reject(struct iscsi_conn *, u8, unsigned char *);
+extern int iscsit_reject_cmd(struct iscsi_cmd *, u8, unsigned char *);
+extern int iscsit_handle_snack(struct iscsi_conn *, unsigned char *);
+extern void iscsit_build_datain_pdu(struct iscsi_cmd *, struct iscsi_conn *,
+				    struct iscsi_datain *,
+				    struct iscsi_data_rsp *, bool);
+extern int iscsit_build_r2ts_for_cmd(struct iscsi_conn *, struct iscsi_cmd *,
+				     bool);
+extern int iscsit_immediate_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
+extern int iscsit_response_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
 /*
  * From iscsi_target_device.c
  */
@@ -114,3 +126,24 @@ extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, int);
 extern int iscsit_sequence_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 			       unsigned char *, __be32);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
+extern void iscsit_free_cmd(struct iscsi_cmd *, bool);
+extern void iscsit_add_cmd_to_immediate_queue(struct iscsi_cmd *,
+					      struct iscsi_conn *, u8);
+
+/*
+ * From iscsi_target_nego.c
+ */
+extern int iscsi_target_check_login_request(struct iscsi_conn *,
+					    struct iscsi_login *);
+
+/*
+ * From iscsi_target_login.c
+ */
+extern __printf(2, 3) int iscsi_change_param_sprintf(
+	struct iscsi_conn *, const char *, ...);
+
+/*
+ * From iscsi_target_parameters.c
+ */
+extern struct iscsi_param *iscsi_find_param_from_key(
+	char *, struct iscsi_param_list *);
-- 
2.0.2

