From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH/for-next 2/3] iscsi-target: Fix iscsit_handle_scsi_cmd() exception se_cmd leak
Date: Thu, 25 Apr 2013 07:40:30 +0000
Message-ID: <1366875631-18795-3-git-send-email-nab@linux-iscsi.org>
References: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression where failures before backend se_cmd
execution in iscsit_handle_scsi_cmd() is leaking iscsi_cmd due to
a missing target_put_sess_cmd() call to drop the extra kref.

Introduced during the RX PDU refactoring in v3.10 for-next code.

Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 5eee9b7..ffbc6a9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1069,12 +1069,17 @@ int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 */
 	if (!cmd->immediate_data) {
 		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
-		if (cmdsn_ret == CMDSN_LOWER_THAN_EXP)
+		if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
+			if (!cmd->sense_reason)
+				return 0;
+
+			target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 			return 0;
-		else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+		} else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER) {
 			return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_PROTOCOL_ERROR,
 				1, 0, (unsigned char *)hdr, cmd);
+		}
 	}
 
 	iscsit_ack_from_expstatsn(conn, be32_to_cpu(hdr->exp_statsn));
@@ -1085,24 +1090,31 @@ int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	if (!cmd->immediate_data) {
 		if (!cmd->sense_reason && cmd->unsolicited_data)
 			iscsit_set_unsoliticed_dataout(cmd);
+		if (!cmd->sense_reason)
+			return 0;
 
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 		return 0;
 	}
 
 	/*
-	 * Early CHECK_CONDITIONs never make it to the transport processing
-	 * thread.  They are processed in CmdSN order by
-	 * iscsit_check_received_cmdsn() below.
+	 * Early CHECK_CONDITIONs with ImmediateData never make it to command
+	 * execution.  These exceptions are processed in CmdSN order using
+	 * iscsit_check_received_cmdsn() in iscsit_get_immediate_data() below.
 	 */
-	if (cmd->sense_reason)
+	if (cmd->sense_reason) {
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 		return 1;
+	}
 	/*
 	 * Call directly into transport_generic_new_cmd() to perform
 	 * the backend memory allocation.
 	 */
 	cmd->sense_reason = transport_generic_new_cmd(&cmd->se_cmd);
-	if (cmd->sense_reason)
+	if (cmd->sense_reason) {
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 		return 1;
+	}
 
 	return 0;
 }
-- 
1.7.2.5
