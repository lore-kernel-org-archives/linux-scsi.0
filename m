From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: Drop iSCSI use of mutex around max_cmd_sn increment
Date: Wed, 22 Jul 2015 15:08:16 -0700
Message-ID: <1437602898-15229-2-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Alexei Potashnik <alexei@purestorage.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, James Bottomley <JBottomley@Odin.com>, Evgenii Lepikhin <johnlepikhin@gmail.com>, Hannes Reinecke <hare@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

In a performance profile, taking a mutex in iscsit_increment_maxcmdsn()
shows up very high.  However taking a mutex around "sess->max_cmd_sn += 1"
seems pretty silly: we're not serializing against other contexts in
any useful way.

I did a quick audit and there don't appear to be any other places that
use max_cmd_sn within the mutex more than once, so this lock can't be
providing any useful serialization.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/iscsi/iscsi_target.c          | 18 +++++++++---------
 drivers/target/iscsi/iscsi_target_configfs.c |  4 ++--
 drivers/target/iscsi/iscsi_target_device.c   |  8 +++-----
 drivers/target/iscsi/iscsi_target_login.c    |  2 +-
 drivers/target/iscsi/iscsi_target_nego.c     |  9 +++------
 drivers/target/iscsi/iscsi_target_tmr.c      |  2 +-
 drivers/target/iscsi/iscsi_target_util.c     |  7 ++++---
 include/target/iscsi/iscsi_target_core.h     |  2 +-
 8 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index ebb1ece..635ec06c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2555,7 +2555,7 @@ static int iscsit_send_conn_drop_async_message(
 	cmd->stat_sn		= conn->stat_sn++;
 	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 	hdr->async_event	= ISCSI_ASYNC_MSG_DROPPING_CONNECTION;
 	hdr->param1		= cpu_to_be16(cmd->logout_cid);
 	hdr->param2		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
@@ -2627,7 +2627,7 @@ iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 		hdr->statsn		= cpu_to_be32(0xFFFFFFFF);
 
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 	hdr->datasn		= cpu_to_be32(datain->data_sn);
 	hdr->offset		= cpu_to_be32(datain->offset);
 
@@ -2838,7 +2838,7 @@ iscsit_build_logout_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 
 	iscsit_increment_maxcmdsn(cmd, conn->sess);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
 	pr_debug("Built Logout Response ITT: 0x%08x StatSN:"
 		" 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
@@ -2901,7 +2901,7 @@ iscsit_build_nopin_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 		iscsit_increment_maxcmdsn(cmd, conn->sess);
 
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
 	pr_debug("Built NOPIN %s Response ITT: 0x%08x, TTT: 0x%08x,"
 		" StatSN: 0x%08x, Length %u\n", (nopout_response) ?
@@ -3048,7 +3048,7 @@ static int iscsit_send_r2t(
 	hdr->ttt		= cpu_to_be32(r2t->targ_xfer_tag);
 	hdr->statsn		= cpu_to_be32(conn->stat_sn);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 	hdr->r2tsn		= cpu_to_be32(r2t->r2t_sn);
 	hdr->data_offset	= cpu_to_be32(r2t->offset);
 	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
@@ -3201,7 +3201,7 @@ void iscsit_build_rsp_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 
 	iscsit_increment_maxcmdsn(cmd, conn->sess);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
 	pr_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
 		" Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
@@ -3320,7 +3320,7 @@ iscsit_build_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 
 	iscsit_increment_maxcmdsn(cmd, conn->sess);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
 	pr_debug("Built Task Management Response ITT: 0x%08x,"
 		" StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
@@ -3575,7 +3575,7 @@ iscsit_build_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 	 */
 	cmd->maxcmdsn_inc = 0;
 	hdr->exp_cmdsn = cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn = cpu_to_be32(conn->sess->max_cmd_sn);
+        hdr->max_cmdsn = cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
 	pr_debug("Built Text Response: ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x,"
 		" Length: %u, CID: %hu F: %d C: %d\n", cmd->init_task_tag,
@@ -3653,7 +3653,7 @@ iscsit_build_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 	cmd->stat_sn		= conn->stat_sn++;
 	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
 }
 EXPORT_SYMBOL(iscsit_build_reject);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index c1898c8..29d5930 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -706,8 +706,8 @@ static ssize_t lio_target_nacl_show_info(
 		rb += sprintf(page+rb, " 0x%08x   0x%08x   0x%08x   0x%08x"
 				"   0x%08x   0x%08x\n",
 			sess->cmdsn_window,
-			(sess->max_cmd_sn - sess->exp_cmd_sn) + 1,
-			sess->exp_cmd_sn, sess->max_cmd_sn,
+			((u32) atomic_read(&sess->max_cmd_sn) - sess->exp_cmd_sn) + 1,
+			sess->exp_cmd_sn, (u32) atomic_read(&sess->max_cmd_sn),
 			sess->init_task_tag, sess->targ_xfer_tag);
 		rb += sprintf(page+rb, "----------------------[iSCSI"
 				" Connections]-------------------------\n");
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 5fabcd3..a526904 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -47,7 +47,7 @@ void iscsit_determine_maxcmdsn(struct iscsi_session *sess)
 	 * core_set_queue_depth_for_node().
 	 */
 	sess->cmdsn_window = se_nacl->queue_depth;
-	sess->max_cmd_sn = (sess->max_cmd_sn + se_nacl->queue_depth) - 1;
+	atomic_set(&sess->max_cmd_sn, (u32) atomic_read(&sess->max_cmd_sn) + se_nacl->queue_depth - 1);
 }
 
 void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess)
@@ -57,9 +57,7 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess
 
 	cmd->maxcmdsn_inc = 1;
 
-	mutex_lock(&sess->cmdsn_mutex);
-	sess->max_cmd_sn += 1;
-	pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
-	mutex_unlock(&sess->cmdsn_mutex);
+	atomic_inc(&sess->max_cmd_sn);
+	pr_debug("Updated MaxCmdSN to 0x%08x\n", atomic_read(&sess->max_cmd_sn));
 }
 EXPORT_SYMBOL(iscsit_increment_maxcmdsn);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 3d0fe4f..bd192f8 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -330,7 +330,7 @@ static int iscsi_login_zero_tsih_s1(
 	 * The FFP CmdSN window values will be allocated from the TPG's
 	 * Initiator Node's ACL once the login has been successfully completed.
 	 */
-	sess->max_cmd_sn	= be32_to_cpu(pdu->cmdsn);
+	atomic_set(&sess->max_cmd_sn, be32_to_cpu(pdu->cmdsn));
 
 	sess->sess_ops = kzalloc(sizeof(struct iscsi_sess_ops), GFP_KERNEL);
 	if (!sess->sess_ops) {
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 8c02fa3..74d041e 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -340,7 +340,6 @@ static int iscsi_target_check_first_request(
 static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_login *login)
 {
 	u32 padding = 0;
-	struct iscsi_session *sess = conn->sess;
 	struct iscsi_login_rsp *login_rsp;
 
 	login_rsp = (struct iscsi_login_rsp *) login->rsp;
@@ -352,7 +351,7 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 	login_rsp->itt			= login->init_task_tag;
 	login_rsp->statsn		= cpu_to_be32(conn->stat_sn++);
 	login_rsp->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
-	login_rsp->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	login_rsp->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
 	pr_debug("Sending Login Response, Flags: 0x%02x, ITT: 0x%08x,"
 		" ExpCmdSN; 0x%08x, MaxCmdSN: 0x%08x, StatSN: 0x%08x, Length:"
@@ -367,10 +366,8 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 		return -1;
 
 	login->rsp_length		= 0;
-	mutex_lock(&sess->cmdsn_mutex);
-	login_rsp->exp_cmdsn		= cpu_to_be32(sess->exp_cmd_sn);
-	login_rsp->max_cmdsn		= cpu_to_be32(sess->max_cmd_sn);
-	mutex_unlock(&sess->cmdsn_mutex);
+	login_rsp->exp_cmdsn		= cpu_to_be32(login_rsp->exp_cmdsn);
+	login_rsp->max_cmdsn		= cpu_to_be32(login_rsp->max_cmdsn);
 
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index cf59c39..11320df 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -50,7 +50,7 @@ u8 iscsit_tmr_abort_task(
 		pr_err("Unable to locate RefTaskTag: 0x%08x on CID:"
 			" %hu.\n", hdr->rtt, conn->cid);
 		return (iscsi_sna_gte(be32_to_cpu(hdr->refcmdsn), conn->sess->exp_cmd_sn) &&
-			iscsi_sna_lte(be32_to_cpu(hdr->refcmdsn), conn->sess->max_cmd_sn)) ?
+			iscsi_sna_lte(be32_to_cpu(hdr->refcmdsn), (u32) atomic_read(&conn->sess->max_cmd_sn))) ?
 			ISCSI_TMF_RSP_COMPLETE : ISCSI_TMF_RSP_NO_TASK;
 	}
 	if (ref_cmd->cmd_sn != be32_to_cpu(hdr->refcmdsn)) {
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index a2bff07..7df4fac 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -233,6 +233,7 @@ struct iscsi_r2t *iscsit_get_holder_for_r2tsn(
 
 static inline int iscsit_check_received_cmdsn(struct iscsi_session *sess, u32 cmdsn)
 {
+	u32 max_cmdsn;
 	int ret;
 
 	/*
@@ -241,10 +242,10 @@ static inline int iscsit_check_received_cmdsn(struct iscsi_session *sess, u32 cm
 	 * or order CmdSNs due to multiple connection sessions and/or
 	 * CRC failures.
 	 */
-	if (iscsi_sna_gt(cmdsn, sess->max_cmd_sn)) {
+	max_cmdsn = atomic_read(&sess->max_cmd_sn);
+	if (iscsi_sna_gt(cmdsn, max_cmdsn)) {
 		pr_err("Received CmdSN: 0x%08x is greater than"
-		       " MaxCmdSN: 0x%08x, ignoring.\n", cmdsn,
-		       sess->max_cmd_sn);
+		       " MaxCmdSN: 0x%08x, ignoring.\n", cmdsn, max_cmdsn);
 		ret = CMDSN_MAXCMDSN_OVERRUN;
 
 	} else if (cmdsn == sess->exp_cmd_sn) {
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 34117b8..11abe3a 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -635,7 +635,7 @@ struct iscsi_session {
 	/* session wide counter: expected command sequence number */
 	u32			exp_cmd_sn;
 	/* session wide counter: maximum allowed command sequence number */
-	u32			max_cmd_sn;
+	atomic_t		max_cmd_sn;
 	struct list_head	sess_ooo_cmdsn_list;
 
 	/* LIO specific session ID */
-- 
2.5.0.rc3
