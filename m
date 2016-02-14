From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 14/34] iscsi-target: export symbols
Date: Sun, 14 Feb 2016 23:12:08 +0530
Message-ID: <4e5a7630ec492ff510404fb1ad0f011634518d04.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:22058 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751745AbcBNRm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:42:28 -0500
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

export multiple symbols for
ISCSI_TCP_CXGB4 transport driver.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_datain_values.c |  3 ++
 drivers/target/iscsi/iscsi_target_erl0.c          |  1 +
 drivers/target/iscsi/iscsi_target_erl1.c          |  1 +
 drivers/target/iscsi/iscsi_target_login.c         |  3 +-
 drivers/target/iscsi/iscsi_target_nego.c          |  1 +
 drivers/target/iscsi/iscsi_target_parameters.c    |  1 +
 drivers/target/iscsi/iscsi_target_util.c          |  4 +++
 include/target/iscsi/iscsi_transport.h            | 34 +++++++++++++++++++++++
 8 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index fb3b52b..73253e3 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -55,6 +55,7 @@ void iscsit_free_datain_req(struct iscsi_cmd *cmd, struct iscsi_datain_req *dr)
 
 	kmem_cache_free(lio_dr_cache, dr);
 }
+EXPORT_SYMBOL(iscsit_free_datain_req);
 
 void iscsit_free_all_datain_reqs(struct iscsi_cmd *cmd)
 {
@@ -79,6 +80,7 @@ struct iscsi_datain_req *iscsit_get_datain_req(struct iscsi_cmd *cmd)
 	return list_first_entry(&cmd->datain_list, struct iscsi_datain_req,
 				cmd_datain_node);
 }
+EXPORT_SYMBOL(iscsit_get_datain_req);
 
 /*
  *	For Normal and Recovery DataSequenceInOrder=Yes and DataPDUInOrder=Yes.
@@ -524,3 +526,4 @@ struct iscsi_datain_req *iscsit_get_datain_values(
 
 	return NULL;
 }
+EXPORT_SYMBOL(iscsit_get_datain_values);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 210f6e4..4a66317 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -913,6 +913,7 @@ void iscsit_fall_back_to_erl0(struct iscsi_session *sess)
 
 	atomic_set(&sess->session_fall_back_to_erl0, 1);
 }
+EXPORT_SYMBOL(iscsit_fall_back_to_erl0);
 
 static void iscsit_handle_connection_cleanup(struct iscsi_conn *conn)
 {
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 9214c9da..42aaaea 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1271,6 +1271,7 @@ void iscsit_start_dataout_timer(
 	cmd->dataout_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&cmd->dataout_timer);
 }
+EXPORT_SYMBOL(iscsit_start_dataout_timer);
 
 void iscsit_stop_dataout_timer(struct iscsi_cmd *cmd)
 {
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 96e78c8..616ec9e 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -249,7 +249,7 @@ static void iscsi_login_set_conn_values(
 	mutex_unlock(&auth_id_lock);
 }
 
-static __printf(2, 3) int iscsi_change_param_sprintf(
+__printf(2, 3) int iscsi_change_param_sprintf(
 	struct iscsi_conn *conn,
 	const char *fmt, ...)
 {
@@ -270,6 +270,7 @@ static __printf(2, 3) int iscsi_change_param_sprintf(
 
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
index 428b0d9..5cab517 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -126,6 +126,7 @@ struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *cmd)
 			" 0x%08x.\n", cmd->init_task_tag);
 	return NULL;
 }
+EXPORT_SYMBOL(iscsit_get_r2t_from_list);
 
 /*
  *	Called with cmd->r2t_lock held.
@@ -514,6 +515,7 @@ void iscsit_add_cmd_to_immediate_queue(
 
 	wake_up(&conn->queues_wq);
 }
+EXPORT_SYMBOL(iscsit_add_cmd_to_immediate_queue);
 
 struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsi_conn *conn)
 {
@@ -773,6 +775,7 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 		break;
 	}
 }
+EXPORT_SYMBOL(iscsit_free_cmd);
 
 int iscsit_check_session_usage_count(struct iscsi_session *sess)
 {
@@ -958,6 +961,7 @@ void iscsit_mod_nopin_response_timer(struct iscsi_conn *conn)
 		(get_jiffies_64() + na->nopin_response_timeout * HZ));
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
+EXPORT_SYMBOL(iscsit_mod_nopin_response_timer);
 
 /*
  *	Called with conn->nopin_timer_lock held.
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 90e37fa..a17e07a 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -85,9 +85,11 @@ extern void iscsit_increment_maxcmdsn(struct iscsi_cmd *, struct iscsi_session *
  * From iscsi_target_erl0.c
  */
 extern void iscsit_cause_connection_reinstatement(struct iscsi_conn *, int);
+extern void iscsit_fall_back_to_erl0(struct iscsi_session *);
 /*
  * From iscsi_target_erl1.c
  */
+extern void iscsit_start_dataout_timer(struct iscsi_cmd *, struct iscsi_conn *);
 extern void iscsit_stop_dataout_timer(struct iscsi_cmd *);
 
 /*
@@ -102,3 +104,35 @@ extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, int);
 extern int iscsit_sequence_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 			       unsigned char *, __be32);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
+extern struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *);
+extern void iscsit_free_cmd(struct iscsi_cmd *, bool);
+extern void iscsit_mod_nopin_response_timer(struct iscsi_conn *);
+extern void iscsit_add_cmd_to_immediate_queue(struct iscsi_cmd *,
+					      struct iscsi_conn *, u8);
+
+/*
+ * From iscsi_target_datain_values.c
+ */
+extern void iscsit_free_datain_req(struct iscsi_cmd *,
+				   struct iscsi_datain_req *);
+extern struct iscsi_datain_req *iscsit_get_datain_req(struct iscsi_cmd *);
+extern struct iscsi_datain_req *iscsit_get_datain_values(struct iscsi_cmd *,
+							 struct iscsi_datain *);
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

