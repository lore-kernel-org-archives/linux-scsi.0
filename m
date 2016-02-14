From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 15/34] iscsi-target: export symbols from iscsi_target.c
Date: Sun, 14 Feb 2016 23:12:09 +0530
Message-ID: <a52145ef75173d293b229cab3e3eba08528aefdc.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:36114 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751760AbcBNRmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:42:36 -0500
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

export symbols from iscsi_target.c for
ISCSI_TCP_CXGB4 transport driver.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 17 ++++++++++++-----
 include/target/iscsi/iscsi_transport.h | 10 ++++++++++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 576a7a4..32af13b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -481,13 +481,14 @@ int iscsit_del_np(struct iscsi_np *np)
 static int iscsit_immediate_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
 static int iscsit_response_queue(struct iscsi_conn *, struct iscsi_cmd *, int);
 
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
 
@@ -498,6 +499,7 @@ static void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 
 	__iscsit_free_cmd(cmd, scsi_cmd, true);
 }
+EXPORT_SYMBOL(iscsit_aborted_task);
 
 static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)
 {
@@ -634,7 +636,7 @@ static void __exit iscsi_target_cleanup_module(void)
 	kfree(iscsit_global);
 }
 
-static int iscsit_add_reject(
+int iscsit_add_reject(
 	struct iscsi_conn *conn,
 	u8 reason,
 	unsigned char *buf)
@@ -664,6 +666,7 @@ static int iscsit_add_reject(
 
 	return -1;
 }
+EXPORT_SYMBOL(iscsit_add_reject);
 
 static int iscsit_add_reject_from_cmd(
 	struct iscsi_cmd *cmd,
@@ -719,6 +722,7 @@ int iscsit_reject_cmd(struct iscsi_cmd *cmd, u8 reason, unsigned char *buf)
 {
 	return iscsit_add_reject_from_cmd(cmd, reason, false, buf);
 }
+EXPORT_SYMBOL(iscsit_reject_cmd);
 
 /*
  * Map some portion of the allocated scatterlist to an iovec, suitable for
@@ -2333,7 +2337,7 @@ iscsit_handle_logout_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 }
 EXPORT_SYMBOL(iscsit_handle_logout_cmd);
 
-static int iscsit_handle_snack(
+int iscsit_handle_snack(
 	struct iscsi_conn *conn,
 	unsigned char *buf)
 {
@@ -2386,6 +2390,7 @@ static int iscsit_handle_snack(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_handle_snack);
 
 static void iscsit_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
 {
@@ -2581,7 +2586,7 @@ static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
 	}
 }
 
-static void
+void
 iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 			struct iscsi_datain *datain, struct iscsi_data_rsp *hdr,
 			bool set_statsn)
@@ -2625,6 +2630,7 @@ iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
 		ntohl(hdr->offset), datain->length, conn->cid);
 }
+EXPORT_SYMBOL(iscsit_build_datain_pdu);
 
 static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
@@ -3164,6 +3170,7 @@ int iscsit_build_r2ts_for_cmd(
 
 	return 0;
 }
+EXPORT_SYMBOL(iscsit_build_r2ts_for_cmd);
 
 void iscsit_build_rsp_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 			bool inc_stat_sn, struct iscsi_scsi_rsp *hdr)
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index a17e07a..23695a3 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -77,6 +77,16 @@ extern void iscsit_build_reject(struct iscsi_cmd *, struct iscsi_conn *,
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
 /*
  * From iscsi_target_device.c
  */
-- 
2.0.2

