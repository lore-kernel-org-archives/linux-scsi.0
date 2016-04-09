From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 08/16] iscsi-target: add void (*iscsit_get_r2t_ttt)()
Date: Sat,  9 Apr 2016 18:41:18 +0530
Message-ID: <2f71b7720d07231faa12ffba830681f1d7ac07da.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Add void (*iscsit_get_r2t_ttt)() to
struct iscsit_transport, iscsi-target
uses this callback to get
r2t->targ_xfer_tag.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 5 ++++-
 include/target/iscsi/iscsi_transport.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 98d96d4..ec785c8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3060,7 +3060,10 @@ static int iscsit_send_r2t(
 	int_to_scsilun(cmd->se_cmd.orig_fe_lun,
 			(struct scsi_lun *)&hdr->lun);
 	hdr->itt		= cmd->init_task_tag;
-	r2t->targ_xfer_tag	= session_get_next_ttt(conn->sess);
+	if (conn->conn_transport->iscsit_get_r2t_ttt)
+		conn->conn_transport->iscsit_get_r2t_ttt(conn, cmd, r2t);
+	else
+		r2t->targ_xfer_tag = session_get_next_ttt(conn->sess);
 	hdr->ttt		= cpu_to_be32(r2t->targ_xfer_tag);
 	hdr->statsn		= cpu_to_be32(conn->stat_sn);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index dbef892..f949e70 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -32,6 +32,8 @@ struct iscsit_transport {
 	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
 	void (*iscsit_get_rx_pdu)(struct iscsi_conn *);
 	int (*iscsit_validate_params)(struct iscsi_conn *);
+	void (*iscsit_get_r2t_ttt)(struct iscsi_conn *, struct iscsi_cmd *,
+				   struct iscsi_r2t *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2
