From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/2] iscsi-target: Convert to per-cpu ida_alloc + ida_free command map
Date: Sun, 18 Aug 2013 02:47:31 +0000
Message-ID: <1376794051-9835-3-git-send-email-nab@daterainc.com>
References: <1376794051-9835-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376794051-9835-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tejun Heo <tj@kernel.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch changes iscsi-target to use transport_alloc_session_tags()
pre-allocation logic for per-cpu session tag pooling with internal
ida_alloc() + ida_free() calls based upon the saved se_cmd->map_tag id.

This includes tag pool setup based upon per NodeACL queue_depth after
locating se_node_acl in iscsi_target_locate_portal().

Also update iscsit_allocate_cmd() and iscsit_release_cmd() to use
percpu_ida_alloc() and percpu_ida_free() respectively.

Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/iscsi/iscsi_target_core.h |    2 ++
 drivers/target/iscsi/iscsi_target_nego.c |   22 ++++++++++++++++++++--
 drivers/target/iscsi/iscsi_target_util.c |   27 ++++++++++++++++++++-------
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 5e1a068..e37b3b0 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -17,6 +17,8 @@
 #define SECONDS_FOR_ASYNC_TEXT		10
 #define SECONDS_FOR_LOGOUT_COMP		15
 #define WHITE_SPACE			" \t\v\f\n\r"
+#define ISCSIT_MIN_TAGS			16
+#define ISCSIT_EXTRA_TAGS		8
 
 /* struct iscsi_node_attrib sanity values */
 #define NA_DATAOUT_TIMEOUT		3
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 6f95910..03e1483 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -873,8 +873,9 @@ int iscsi_target_locate_portal(
 	struct iscsi_tiqn *tiqn;
 	struct iscsi_tpg_np *tpg_np = NULL;
 	struct iscsi_login_req *login_req;
+	struct se_node_acl *se_nacl;
 	u32 payload_length;
-	int sessiontype = 0, ret = 0;
+	int sessiontype = 0, ret = 0, tag_num, tag_size;
 
 	login->np = np;
 
@@ -1067,8 +1068,25 @@ get_target:
 		ret = -1;
 		goto out;
 	}
+	se_nacl = sess->se_sess->se_node_acl;
+	/*
+	 * Setup pre-allocated tags based upon allowed per NodeACL CmdSN
+	 * depth for non immediate commands, plus extra tags for immediate
+	 * commands.
+	 *
+	 * Also enforce a ISCSIT_MIN_TAGS to prevent unnecessary contention
+	 * in per-cpu-ida tag allocation logic + small se_nacl->queue_depth.
+	 */
+	tag_num = max_t(u32, ISCSIT_MIN_TAGS, se_nacl->queue_depth);
+	tag_num += ISCSIT_EXTRA_TAGS;
+	tag_size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 
-	ret = 0;
+	ret = transport_alloc_session_tags(sess->se_sess, tag_num, tag_size);
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				    ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		ret = -1;
+	}
 out:
 	kfree(tmpbuf);
 	return ret;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5784cad..68f5644 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -19,6 +19,7 @@
  ******************************************************************************/
 
 #include <linux/list.h>
+#include <linux/idr.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
@@ -156,13 +157,15 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
 struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 {
 	struct iscsi_cmd *cmd;
-	int priv_size = conn->conn_transport->priv_size;
+	struct se_session *se_sess = conn->sess->se_sess;
+	int size, tag;
 
-	cmd = kzalloc(sizeof(struct iscsi_cmd) + priv_size, gfp_mask);
-	if (!cmd) {
-		pr_err("Unable to allocate memory for struct iscsi_cmd.\n");
-		return NULL;
-	}
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, gfp_mask);
+	size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
+	cmd = (struct iscsi_cmd *)(se_sess->sess_cmd_map + (tag * size));
+	memset(cmd, 0, size);
+
+	cmd->se_cmd.map_tag = tag;
 	cmd->conn = conn;
 	INIT_LIST_HEAD(&cmd->i_conn_node);
 	INIT_LIST_HEAD(&cmd->datain_list);
@@ -678,6 +681,16 @@ void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *conn)
 
 void iscsit_release_cmd(struct iscsi_cmd *cmd)
 {
+	struct iscsi_session *sess;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+
+	if (cmd->conn)
+		sess = cmd->conn->sess;
+	else
+		sess = cmd->sess;
+
+	BUG_ON(!sess || !sess->se_sess);
+
 	kfree(cmd->buf_ptr);
 	kfree(cmd->pdu_list);
 	kfree(cmd->seq_list);
@@ -685,7 +698,7 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 	kfree(cmd->iov_data);
 	kfree(cmd->text_in_ptr);
 
-	kfree(cmd);
+	percpu_ida_free(&sess->se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 EXPORT_SYMBOL(iscsit_release_cmd);
 
-- 
1.7.2.5
