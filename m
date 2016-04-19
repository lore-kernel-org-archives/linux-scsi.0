From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 12/13] iscsi-target: export symbols
Date: Wed, 20 Apr 2016 00:00:19 +0530
Message-ID: <ffce9253a38b0940721c5a827f0872f4d56719d3.1461088673.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

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
index 8021223..487d8f3 100644
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
 
 static void iscsit_do_crypto_hash_buf(struct ahash_request *, const void *,
 				      u32, u32, u8 *, u8 *);
@@ -799,7 +799,7 @@ static void __exit iscsi_target_cleanup_module(void)
 	kfree(iscsit_global);
 }
 
-static int iscsit_add_reject(
+int iscsit_add_reject(
 	struct iscsi_conn *conn,
 	u8 reason,
 	unsigned char *buf)
@@ -829,6 +829,7 @@ static int iscsit_add_reject(
 
 	return -1;
 }
+EXPORT_SYMBOL(iscsit_add_reject);
 
 static int iscsit_add_reject_from_cmd(
 	struct iscsi_cmd *cmd,
@@ -884,6 +885,7 @@ int iscsit_reject_cmd(struct iscsi_cmd *cmd, u8 reason, unsigned char *buf)
 {
 	return iscsit_add_reject_from_cmd(cmd, reason, false, buf);
 }
+EXPORT_SYMBOL(iscsit_reject_cmd);
 
 /*
  * Map some portion of the allocated scatterlist to an iovec, suitable for
@@ -2500,7 +2502,7 @@ iscsit_handle_logout_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 }
 EXPORT_SYMBOL(iscsit_handle_logout_cmd);
 
-static int iscsit_handle_snack(
+int iscsit_handle_snack(
 	struct iscsi_conn *conn,
 	unsigned char *buf)
 {
@@ -2553,6 +2555,7 @@ static int iscsit_handle_snack(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_handle_snack);
 
 static void iscsit_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
 {
@@ -2733,7 +2736,7 @@ static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
 	}
 }
 
-static void
+void
 iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 			struct iscsi_datain *datain, struct iscsi_data_rsp *hdr,
 			bool set_statsn)
@@ -2777,6 +2780,7 @@ iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
 		ntohl(hdr->offset), datain->length, conn->cid);
 }
+EXPORT_SYMBOL(iscsit_build_datain_pdu);
 
 static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
@@ -3153,6 +3157,7 @@ int iscsit_build_r2ts_for_cmd(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_build_r2ts_for_cmd);
 
 void iscsit_build_rsp_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 			bool inc_stat_sn, struct iscsi_scsi_rsp *hdr)
@@ -3581,7 +3586,7 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
 	cpumask_setall(conn->conn_cpumask);
 }
 
-static int
+int
 iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 {
 	int ret;
@@ -3623,6 +3628,7 @@ iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state
 err:
 	return -1;
 }
+EXPORT_SYMBOL(iscsit_immediate_queue);
 
 static int
 iscsit_handle_immediate_queue(struct iscsi_conn *conn)
@@ -3647,7 +3653,7 @@ iscsit_handle_immediate_queue(struct iscsi_conn *conn)
 	return 0;
 }
 
-static int
+int
 iscsit_response_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 {
 	int ret;
@@ -3752,6 +3758,7 @@ check_rsp_state:
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
index 32704b2..3c2e10a 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -84,6 +84,18 @@ extern void iscsit_build_reject(struct iscsi_cmd *, struct iscsi_conn *,
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
@@ -109,3 +121,24 @@ extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, int);
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
