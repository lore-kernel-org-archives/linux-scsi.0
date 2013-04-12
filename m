From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 5/9] iscsi-target: Add per transport iscsi_cmd alloc/free
Date: Fri, 12 Apr 2013 20:52:38 +0000
Message-ID: <1365799962-13543-6-git-send-email-nab@linux-iscsi.org>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts struct iscsi_cmd memory allocation + free to use
->iscsit_alloc_cmd() iscsit_transport API caller, and export
iscsit_allocate_cmd() symbols

Also add iscsi_cmd->release_cmd() to be used seperately from
iscsit_transport for connection/session shutdown.

v2 changes:

- Remove unnecessary checks in iscsit_alloc_cmd (asias)
- Drop iscsit_transport->iscsit_free_cmd() usage
- Drop iscsit_transport->iscsit_unmap_cmd() usage
- Add iscsi_cmd->release_cmd()
- Convert lio_release_cmd() to use iscsi_cmd->release_cmd()

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c          |    1 +
 drivers/target/iscsi/iscsi_target_configfs.c |    3 ++-
 drivers/target/iscsi/iscsi_target_core.h     |    1 +
 drivers/target/iscsi/iscsi_target_util.c     |   25 +++++++++++++++++++++----
 drivers/target/iscsi/iscsi_target_util.h     |    1 +
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8203bf3..b01a10e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -489,6 +489,7 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_setup_np	= iscsit_setup_np,
 	.iscsit_accept_np	= iscsit_accept_np,
 	.iscsit_free_np		= iscsit_free_np,
+	.iscsit_alloc_cmd	= iscsit_alloc_cmd,
 	.iscsit_get_login_rx	= iscsit_get_login_rx,
 	.iscsit_put_login_tx	= iscsit_put_login_tx,
 };
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 78d75c8..c78b824 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1700,7 +1700,8 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
-	iscsit_release_cmd(cmd);
+	pr_debug("Entering lio_release_cmd for se_cmd: %p\n", se_cmd);
+	cmd->release_cmd(cmd);
 }
 
 /* End functions for target_core_fabric_ops */
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 53400b0..60ec4b9 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -485,6 +485,7 @@ struct iscsi_cmd {
 	u32			first_data_sg_off;
 	u32			kmapped_nents;
 	sense_reason_t		sense_reason;
+	void (*release_cmd)(struct iscsi_cmd *);
 }  ____cacheline_aligned;
 
 struct iscsi_tmr_req {
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 4cf1e7f..0b73f90 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -149,6 +149,18 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
 	spin_unlock_bh(&cmd->r2t_lock);
 }
 
+struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
+{
+	struct iscsi_cmd *cmd;
+
+	cmd = kmem_cache_zalloc(lio_cmd_cache, gfp_mask);
+	if (!cmd)
+		return NULL;
+
+	cmd->release_cmd = &iscsit_release_cmd;
+	return cmd;
+}
+
 /*
  * May be called from software interrupt (timer) context for allocating
  * iSCSI NopINs.
@@ -157,13 +169,12 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 {
 	struct iscsi_cmd *cmd;
 
-	cmd = kmem_cache_zalloc(lio_cmd_cache, gfp_mask);
+	cmd = conn->conn_transport->iscsit_alloc_cmd(conn, gfp_mask);
 	if (!cmd) {
 		pr_err("Unable to allocate memory for struct iscsi_cmd.\n");
 		return NULL;
 	}
-
-	cmd->conn	= conn;
+	cmd->conn = conn;
 	INIT_LIST_HEAD(&cmd->i_conn_node);
 	INIT_LIST_HEAD(&cmd->datain_list);
 	INIT_LIST_HEAD(&cmd->cmd_r2t_list);
@@ -176,6 +187,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 
 	return cmd;
 }
+EXPORT_SYMBOL(iscsit_allocate_cmd);
 
 struct iscsi_seq *iscsit_get_seq_holder_for_datain(
 	struct iscsi_cmd *cmd,
@@ -690,6 +702,11 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd)
 	 */
 	switch (cmd->iscsi_opcode) {
 	case ISCSI_OP_SCSI_CMD:
+		if (cmd->data_direction == DMA_TO_DEVICE)
+			iscsit_stop_dataout_timer(cmd);
+		/*
+		 * Fallthrough
+		 */
 	case ISCSI_OP_SCSI_TMFUNC:
 		transport_generic_free_cmd(&cmd->se_cmd, 1);
 		break;
@@ -705,7 +722,7 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd)
 		}
 		/* Fall-through */
 	default:
-		iscsit_release_cmd(cmd);
+		cmd->release_cmd(cmd);
 		break;
 	}
 }
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 894d0f8..4f8e01a 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -8,6 +8,7 @@ extern struct iscsi_r2t *iscsit_get_r2t_for_eos(struct iscsi_cmd *, u32, u32);
 extern struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *);
 extern void iscsit_free_r2t(struct iscsi_r2t *, struct iscsi_cmd *);
 extern void iscsit_free_r2ts_from_list(struct iscsi_cmd *);
+extern struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *, gfp_t);
 extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, gfp_t);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_datain(struct iscsi_cmd *, u32);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsi_cmd *);
-- 
1.7.2.5
