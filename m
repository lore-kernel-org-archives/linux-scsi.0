Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C2321345;
	Sun, 22 Dec 2024 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734903342; cv=none; b=UyURnZkB1K1BOLGfCJVDdb2GdhTVgNWC6f+H9z/7n1W3ny0m4wPAFh5zF8Ao8euW0a/YEa7sRzcKMa/Z8oUS8zYUvy1rzrZrU/p9xkbiMJFtD+BjULGqV8jBeJiIDETR9K+20/IWVXg34rf0QkqUTdBjOioDraXXu/ZCZobhDUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734903342; c=relaxed/simple;
	bh=LS9wHS2mb7tH1G+Ps53epe6HRBV5SLKkZ6PvZxm5A3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JzpgBr2ymsIvigt44u3c1QCNX6vOElAf1EuBsFheDXyxyCAGgs+CEfoBNsIOQ7mU35JffZAt9TPvzRzwwV0vx3vb8Su4yd/wvySeJlxYJCkQfY7M7yAKz+SrILyUaetfAxzm+P4a0Hwij265mKTDONSjxCfqZl8zv0VUsRFxaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=DXciSWsz; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="DXciSWsz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=SGOGMfUJLe8XlDJsZBEA10y067CfyeA6JOYMvP2AxMk=; b=DXciSWszaV0W+qnD
	YKB/dyFk0G23BmD8O2IcmcB9QHAZCGjlPZRg2gaJc3mNiCJFrlzAyqxLCXyzI+fsyBia65pVN+w+/
	VXND1ws9bA4Bp813svLhYlLECfjOgq/Lkxa6HDwRc2p+aFUrEjqk0PJOdhkc2fSASf7cidXl2L2zh
	vkYl4EwBLbEoneKj7rWvZ7mj8fhKODGfpFfUlHaCsOrGjpknCs12oJCpRR9iqq2B0KSNlmPFZZSX3
	09NxmCEhlJMD3bjrcLoQnYhG4UY1CqD0ITqKQ+8xk39Tl3mDBxo0Bc1VWGm2WB9lBWc3kEmncWPYc
	i1P1UEzMnxubq0VmbA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tPTbh-006nNS-0k;
	Sun, 22 Dec 2024 21:35:25 +0000
From: linux@treblig.org
To: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: a.kovaleva@yadro.com,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: target: Remove unused functions
Date: Sun, 22 Dec 2024 21:35:24 +0000
Message-ID: <20241222213524.270735-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

The functions:
  iscsit_check_unsolicited_dataout()
  iscsit_fail_session()
  iscsit_create_conn_recovery_datain_values()
  iscsit_create_conn_recovery_dataout_values()
  iscsit_tpg_dump_params()
  iscsit_print_session_params()

  were all added in 2011 by
commit e48354ce078c ("iscsi-target: Add iSCSI fabric support for
target v4.1")

but have remained unused.

Remove them.

Having deleted them, the functions:
  iscsi_print_params()
  iscsi_dump_conn_ops()
  iscsi_dump_sess_ops()

are also unused.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/target/iscsi/iscsi_target.c           | 15 -----
 drivers/target/iscsi/iscsi_target.h           |  1 -
 drivers/target/iscsi/iscsi_target_erl2.c      | 48 ---------------
 drivers/target/iscsi/iscsi_target_erl2.h      |  2 -
 .../target/iscsi/iscsi_target_parameters.c    | 48 ---------------
 .../target/iscsi/iscsi_target_parameters.h    |  3 -
 drivers/target/iscsi/iscsi_target_tpg.c       |  5 --
 drivers/target/iscsi/iscsi_target_tpg.h       |  1 -
 drivers/target/iscsi/iscsi_target_util.c      | 58 -------------------
 drivers/target/iscsi/iscsi_target_util.h      |  2 -
 10 files changed, 183 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6002283cbeba..3c889b26f099 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4727,21 +4727,6 @@ int iscsit_logout_post_handler(
 }
 EXPORT_SYMBOL(iscsit_logout_post_handler);
 
-void iscsit_fail_session(struct iscsit_session *sess)
-{
-	struct iscsit_conn *conn;
-
-	spin_lock_bh(&sess->conn_lock);
-	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
-		pr_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
-		conn->conn_state = TARG_CONN_STATE_CLEANUP_WAIT;
-	}
-	spin_unlock_bh(&sess->conn_lock);
-
-	pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
-	sess->session_state = TARG_SESS_STATE_FAILED;
-}
-
 void iscsit_stop_session(
 	struct iscsit_session *sess,
 	int session_sleep,
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 873411e95ed2..f4addae2aae4 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -40,7 +40,6 @@ extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsit_conn *);
 extern int iscsit_close_session(struct iscsit_session *, bool can_sleep);
-extern void iscsit_fail_session(struct iscsit_session *);
 extern void iscsit_stop_session(struct iscsit_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, int);
 
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 18e88d2ea5fd..56d78af7cec7 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -25,54 +25,6 @@
 /*
  *	FIXME: Does RData SNACK apply here as well?
  */
-void iscsit_create_conn_recovery_datain_values(
-	struct iscsit_cmd *cmd,
-	__be32 exp_data_sn)
-{
-	u32 data_sn = 0;
-	struct iscsit_conn *conn = cmd->conn;
-
-	cmd->next_burst_len = 0;
-	cmd->read_data_done = 0;
-
-	while (be32_to_cpu(exp_data_sn) > data_sn) {
-		if ((cmd->next_burst_len +
-		     conn->conn_ops->MaxRecvDataSegmentLength) <
-		     conn->sess->sess_ops->MaxBurstLength) {
-			cmd->read_data_done +=
-			       conn->conn_ops->MaxRecvDataSegmentLength;
-			cmd->next_burst_len +=
-			       conn->conn_ops->MaxRecvDataSegmentLength;
-		} else {
-			cmd->read_data_done +=
-				(conn->sess->sess_ops->MaxBurstLength -
-				cmd->next_burst_len);
-			cmd->next_burst_len = 0;
-		}
-		data_sn++;
-	}
-}
-
-void iscsit_create_conn_recovery_dataout_values(
-	struct iscsit_cmd *cmd)
-{
-	u32 write_data_done = 0;
-	struct iscsit_conn *conn = cmd->conn;
-
-	cmd->data_sn = 0;
-	cmd->next_burst_len = 0;
-
-	while (cmd->write_data_done > write_data_done) {
-		if ((write_data_done + conn->sess->sess_ops->MaxBurstLength) <=
-		     cmd->write_data_done)
-			write_data_done += conn->sess->sess_ops->MaxBurstLength;
-		else
-			break;
-	}
-
-	cmd->write_data_done = write_data_done;
-}
-
 static int iscsit_attach_active_connection_recovery_entry(
 	struct iscsit_session *sess,
 	struct iscsi_conn_recovery *cr)
diff --git a/drivers/target/iscsi/iscsi_target_erl2.h b/drivers/target/iscsi/iscsi_target_erl2.h
index 6655e4bcf893..9064c74eef7a 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.h
+++ b/drivers/target/iscsi/iscsi_target_erl2.h
@@ -9,8 +9,6 @@ struct iscsit_conn;
 struct iscsi_conn_recovery;
 struct iscsit_session;
 
-extern void iscsit_create_conn_recovery_datain_values(struct iscsit_cmd *, __be32);
-extern void iscsit_create_conn_recovery_dataout_values(struct iscsit_cmd *);
 extern struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
 			struct iscsit_session *, u16);
 extern void iscsit_free_connection_recovery_entries(struct iscsit_session *);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 5b90c22ee3dc..1d4e1788e073 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -67,54 +67,6 @@ int iscsi_login_tx_data(
 	return 0;
 }
 
-void iscsi_dump_conn_ops(struct iscsi_conn_ops *conn_ops)
-{
-	pr_debug("HeaderDigest: %s\n", (conn_ops->HeaderDigest) ?
-				"CRC32C" : "None");
-	pr_debug("DataDigest: %s\n", (conn_ops->DataDigest) ?
-				"CRC32C" : "None");
-	pr_debug("MaxRecvDataSegmentLength: %u\n",
-				conn_ops->MaxRecvDataSegmentLength);
-}
-
-void iscsi_dump_sess_ops(struct iscsi_sess_ops *sess_ops)
-{
-	pr_debug("InitiatorName: %s\n", sess_ops->InitiatorName);
-	pr_debug("InitiatorAlias: %s\n", sess_ops->InitiatorAlias);
-	pr_debug("TargetName: %s\n", sess_ops->TargetName);
-	pr_debug("TargetAlias: %s\n", sess_ops->TargetAlias);
-	pr_debug("TargetPortalGroupTag: %hu\n",
-			sess_ops->TargetPortalGroupTag);
-	pr_debug("MaxConnections: %hu\n", sess_ops->MaxConnections);
-	pr_debug("InitialR2T: %s\n",
-			(sess_ops->InitialR2T) ? "Yes" : "No");
-	pr_debug("ImmediateData: %s\n", (sess_ops->ImmediateData) ?
-			"Yes" : "No");
-	pr_debug("MaxBurstLength: %u\n", sess_ops->MaxBurstLength);
-	pr_debug("FirstBurstLength: %u\n", sess_ops->FirstBurstLength);
-	pr_debug("DefaultTime2Wait: %hu\n", sess_ops->DefaultTime2Wait);
-	pr_debug("DefaultTime2Retain: %hu\n",
-			sess_ops->DefaultTime2Retain);
-	pr_debug("MaxOutstandingR2T: %hu\n",
-			sess_ops->MaxOutstandingR2T);
-	pr_debug("DataPDUInOrder: %s\n",
-			(sess_ops->DataPDUInOrder) ? "Yes" : "No");
-	pr_debug("DataSequenceInOrder: %s\n",
-			(sess_ops->DataSequenceInOrder) ? "Yes" : "No");
-	pr_debug("ErrorRecoveryLevel: %hu\n",
-			sess_ops->ErrorRecoveryLevel);
-	pr_debug("SessionType: %s\n", (sess_ops->SessionType) ?
-			"Discovery" : "Normal");
-}
-
-void iscsi_print_params(struct iscsi_param_list *param_list)
-{
-	struct iscsi_param *param;
-
-	list_for_each_entry(param, &param_list->param_list, p_list)
-		pr_debug("%s: %s\n", param->name, param->value);
-}
-
 static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *param_list,
 		char *name, char *value, u8 phase, u8 scope, u8 sender,
 		u16 type_range, u8 use)
diff --git a/drivers/target/iscsi/iscsi_target_parameters.h b/drivers/target/iscsi/iscsi_target_parameters.h
index 00fbbebb8c75..c672a971fcb7 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -32,9 +32,6 @@ struct iscsi_sess_ops;
 
 extern int iscsi_login_rx_data(struct iscsit_conn *, char *, int);
 extern int iscsi_login_tx_data(struct iscsit_conn *, char *, char *, int);
-extern void iscsi_dump_conn_ops(struct iscsi_conn_ops *);
-extern void iscsi_dump_sess_ops(struct iscsi_sess_ops *);
-extern void iscsi_print_params(struct iscsi_param_list *);
 extern int iscsi_create_default_params(struct iscsi_param_list **);
 extern int iscsi_set_keys_to_negotiate(struct iscsi_param_list *, bool);
 extern int iscsi_set_keys_irrelevant_for_discovery(struct iscsi_param_list *);
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index f7bac98fd4fe..bf06cfdfb012 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -200,11 +200,6 @@ static void iscsit_clear_tpg_np_login_threads(
 	spin_unlock(&tpg->tpg_np_lock);
 }
 
-void iscsit_tpg_dump_params(struct iscsi_portal_group *tpg)
-{
-	iscsi_print_params(tpg->param_list);
-}
-
 static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 {
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index d44d09f2dde9..1155b7b3164a 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -18,7 +18,6 @@ extern struct iscsi_portal_group *iscsit_get_tpg_from_np(struct iscsi_tiqn *,
 			struct iscsi_np *, struct iscsi_tpg_np **);
 extern int iscsit_get_tpg(struct iscsi_portal_group *);
 extern void iscsit_put_tpg(struct iscsi_portal_group *);
-extern void iscsit_tpg_dump_params(struct iscsi_portal_group *);
 extern int iscsit_tpg_add_portal_group(struct iscsi_tiqn *, struct iscsi_portal_group *);
 extern int iscsit_tpg_del_portal_group(struct iscsi_tiqn *, struct iscsi_portal_group *,
 			int);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 91a75a4a7cc1..ed2dadb21f75 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -333,50 +333,6 @@ int iscsit_sequence_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 }
 EXPORT_SYMBOL(iscsit_sequence_cmd);
 
-int iscsit_check_unsolicited_dataout(struct iscsit_cmd *cmd, unsigned char *buf)
-{
-	struct iscsit_conn *conn = cmd->conn;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct iscsi_data *hdr = (struct iscsi_data *) buf;
-	u32 payload_length = ntoh24(hdr->dlength);
-
-	if (conn->sess->sess_ops->InitialR2T) {
-		pr_err("Received unexpected unsolicited data"
-			" while InitialR2T=Yes, protocol error.\n");
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
-		return -1;
-	}
-
-	if ((cmd->first_burst_len + payload_length) >
-	     conn->sess->sess_ops->FirstBurstLength) {
-		pr_err("Total %u bytes exceeds FirstBurstLength: %u"
-			" for this Unsolicited DataOut Burst.\n",
-			(cmd->first_burst_len + payload_length),
-				conn->sess->sess_ops->FirstBurstLength);
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
-		return -1;
-	}
-
-	if (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))
-		return 0;
-
-	if (((cmd->first_burst_len + payload_length) != cmd->se_cmd.data_length) &&
-	    ((cmd->first_burst_len + payload_length) !=
-	      conn->sess->sess_ops->FirstBurstLength)) {
-		pr_err("Unsolicited non-immediate data received %u"
-			" does not equal FirstBurstLength: %u, and does"
-			" not equal ExpXferLen %u.\n",
-			(cmd->first_burst_len + payload_length),
-			conn->sess->sess_ops->FirstBurstLength, cmd->se_cmd.data_length);
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
-		return -1;
-	}
-	return 0;
-}
-
 struct iscsit_cmd *iscsit_find_cmd_from_itt(
 	struct iscsit_conn *conn,
 	itt_t init_task_tag)
@@ -1252,20 +1208,6 @@ int iscsit_tx_login_rsp(struct iscsit_conn *conn, u8 status_class, u8 status_det
 	return conn->conn_transport->iscsit_put_login_tx(conn, login, 0);
 }
 
-void iscsit_print_session_params(struct iscsit_session *sess)
-{
-	struct iscsit_conn *conn;
-
-	pr_debug("-----------------------------[Session Params for"
-		" SID: %u]-----------------------------\n", sess->sid);
-	spin_lock_bh(&sess->conn_lock);
-	list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
-		iscsi_dump_conn_ops(conn->conn_ops);
-	spin_unlock_bh(&sess->conn_lock);
-
-	iscsi_dump_sess_ops(sess->sess_ops);
-}
-
 int rx_data(
 	struct iscsit_conn *conn,
 	struct kvec *iov,
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 336da4fb0a77..7ae48a8a5cbf 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -23,7 +23,6 @@ extern struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsit_cmd *);
 extern struct iscsi_r2t *iscsit_get_holder_for_r2tsn(struct iscsit_cmd *, u32);
 extern int iscsit_sequence_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			       unsigned char * ,__be32 cmdsn);
-extern int iscsit_check_unsolicited_dataout(struct iscsit_cmd *, unsigned char *);
 extern struct iscsit_cmd *iscsit_find_cmd_from_itt_or_dump(struct iscsit_conn *,
 			itt_t, u32);
 extern struct iscsit_cmd *iscsit_find_cmd_from_ttt(struct iscsit_conn *, u32);
@@ -61,7 +60,6 @@ extern int iscsit_set_login_timer_kworker(struct iscsit_conn *, struct task_stru
 extern int iscsit_send_tx_data(struct iscsit_cmd *, struct iscsit_conn *, int);
 extern int iscsit_fe_sendpage_sg(struct iscsit_cmd *, struct iscsit_conn *);
 extern int iscsit_tx_login_rsp(struct iscsit_conn *, u8, u8);
-extern void iscsit_print_session_params(struct iscsit_session *);
 extern int rx_data(struct iscsit_conn *, struct kvec *, int, int);
 extern int tx_data(struct iscsit_conn *, struct kvec *, int, int);
 extern void iscsit_collect_login_stats(struct iscsit_conn *, u8, u8);
-- 
2.47.1

