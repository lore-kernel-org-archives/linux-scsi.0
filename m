From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 16/34] iscsi-target: split iscsit_send_r2t()
Date: Sun, 14 Feb 2016 23:12:10 +0530
Message-ID: <693c85185570ea7202ed321f334246edef66ffc9.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

move code to form iscsi_r2t_rsp hdr to new function
iscsit_build_r2t_pdu() so that ISCSI_TCP_CXGB4 and
other transport drivers can reuse this code.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 34 ++++++++++++++++++++++------------
 include/target/iscsi/iscsi_transport.h |  2 ++
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 32af13b..6137e26 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3019,6 +3019,26 @@ iscsit_send_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	return 0;
 }
 
+void iscsit_build_r2t_pdu(struct iscsi_cmd *cmd,
+			  struct iscsi_conn *conn,
+			  struct iscsi_r2t *r2t,
+			  struct iscsi_r2t_rsp *hdr)
+{
+	hdr->opcode		= ISCSI_OP_R2T;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	int_to_scsilun(cmd->se_cmd.orig_fe_lun,	(struct scsi_lun *)&hdr->lun);
+	hdr->itt		= cmd->init_task_tag;
+	hdr->ttt		= cpu_to_be32(r2t->targ_xfer_tag);
+	hdr->statsn		= cpu_to_be32(conn->stat_sn);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(
+				  (u32)atomic_read(&conn->sess->max_cmd_sn));
+	hdr->r2tsn		= cpu_to_be32(r2t->r2t_sn);
+	hdr->data_offset	= cpu_to_be32(r2t->offset);
+	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
+}
+EXPORT_SYMBOL(iscsit_build_r2t_pdu);
+
 static int iscsit_send_r2t(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
@@ -3034,19 +3054,9 @@ static int iscsit_send_r2t(
 
 	hdr			= (struct iscsi_r2t_rsp *) cmd->pdu;
 	memset(hdr, 0, ISCSI_HDR_LEN);
-	hdr->opcode		= ISCSI_OP_R2T;
-	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
-	int_to_scsilun(cmd->se_cmd.orig_fe_lun,
-			(struct scsi_lun *)&hdr->lun);
-	hdr->itt		= cmd->init_task_tag;
 	r2t->targ_xfer_tag	= session_get_next_ttt(conn->sess);
-	hdr->ttt		= cpu_to_be32(r2t->targ_xfer_tag);
-	hdr->statsn		= cpu_to_be32(conn->stat_sn);
-	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
-	hdr->r2tsn		= cpu_to_be32(r2t->r2t_sn);
-	hdr->data_offset	= cpu_to_be32(r2t->offset);
-	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
+
+	iscsit_build_r2t_pdu(cmd, conn, r2t, hdr);
 
 	cmd->iov_misc[0].iov_base	= cmd->pdu;
 	cmd->iov_misc[0].iov_len	= ISCSI_HDR_LEN;
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 23695a3..746404a 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -87,6 +87,8 @@ extern void iscsit_build_datain_pdu(struct iscsi_cmd *, struct iscsi_conn *,
 				    struct iscsi_data_rsp *, bool);
 extern int iscsit_build_r2ts_for_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 				     bool);
+extern void iscsit_build_r2t_pdu(struct iscsi_cmd *, struct iscsi_conn *,
+				 struct iscsi_r2t *, struct iscsi_r2t_rsp *);
 /*
  * From iscsi_target_device.c
  */
-- 
2.0.2
