From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] iscsi-target: Use kmemdup rather than duplicating its
 implementation
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.298.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
--- a/drivers/target/iscsi/iscsi_target.c 2011-11-07 19:39:05.771133928 +0100
+++ b/drivers/target/iscsi/iscsi_target.c 2011-11-08 10:52:55.794437559 +0100
@@ -614,13 +614,12 @@ int iscsit_add_reject(
 	hdr	= (struct iscsi_reject *) cmd->pdu;
 	hdr->reason = reason;
 
-	cmd->buf_ptr = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	cmd->buf_ptr = kmemdup(buf, ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
 		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_release_cmd(cmd);
 		return -1;
 	}
-	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
@@ -661,13 +660,12 @@ int iscsit_add_reject_from_cmd(
 	hdr	= (struct iscsi_reject *) cmd->pdu;
 	hdr->reason = reason;
 
-	cmd->buf_ptr = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	cmd->buf_ptr = kmemdup(buf, ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
 		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_release_cmd(cmd);
 		return -1;
 	}
-	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
 
 	if (add_to_conn) {
 		spin_lock_bh(&conn->cmd_lock);
diff -u -p a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
--- a/drivers/target/iscsi/iscsi_target_nego.c 2011-11-07 19:38:13.413671958 +0100
+++ b/drivers/target/iscsi/iscsi_target_nego.c 2011-11-08 10:52:59.521154183 +0100
@@ -981,14 +981,13 @@ struct iscsi_login *iscsi_target_init_ne
 		return NULL;
 	}
 
-	login->req = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	login->req = kmemdup(login_pdu, ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!login->req) {
 		pr_err("Unable to allocate memory for Login Request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		goto out;
 	}
-	memcpy(login->req, login_pdu, ISCSI_HDR_LEN);
 
 	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
 	if (!login->req_buf) {
