From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/8] target/iscsi: Delete 36 error messages for a failed
 memory allocation
Date: Tue, 12 Dec 2017 22:45:20 +0100
Message-ID: <cc3b6e13-6377-b0c8-ebf0-5356fce09669@users.sourceforge.net>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 21:07:16 +0100

Omit extra messages for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target.c               |  2 --
 drivers/target/iscsi/iscsi_target_auth.c          | 17 +++------
 drivers/target/iscsi/iscsi_target_datain_values.c |  6 ++--
 drivers/target/iscsi/iscsi_target_erl1.c          | 12 +++----
 drivers/target/iscsi/iscsi_target_erl2.c          |  6 ++--
 drivers/target/iscsi/iscsi_target_login.c         | 23 +++----------
 drivers/target/iscsi/iscsi_target_nego.c          |  4 +--
 drivers/target/iscsi/iscsi_target_parameters.c    | 42 +++++++----------------
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  | 23 +++++--------
 drivers/target/iscsi/iscsi_target_tpg.c           |  9 ++---
 drivers/target/iscsi/iscsi_target_util.c          | 11 +++---
 11 files changed, 46 insertions(+), 109 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9eb10d34682c..f3c6ea556ea8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -812,7 +812,6 @@ int iscsit_add_reject(
 
 	cmd->buf_ptr = kmemdup(buf, ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
-		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_free_cmd(cmd, false);
 		return -1;
 	}
@@ -849,7 +848,6 @@ static int iscsit_add_reject_from_cmd(
 
 	cmd->buf_ptr = kmemdup(buf, ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
-		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_free_cmd(cmd, false);
 		return -1;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index d837fcbdbaf2..3a17343f43ed 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -80,10 +80,9 @@ static int chap_check_algorithm(const char *a_str)
 	char *tmp, *orig, *token;
 
 	tmp = kstrdup(a_str, GFP_KERNEL);
-	if (!tmp) {
-		pr_err("Memory allocation failed for CHAP_A temporary buffer\n");
+	if (!tmp)
 		return CHAP_DIGEST_UNKNOWN;
-	}
+
 	orig = tmp;
 
 	token = strsep(&tmp, "=");
@@ -198,16 +197,12 @@ static int chap_server_compute_md5(
 	int auth_ret = -1, ret, challenge_len;
 
 	challenge = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
-	if (!challenge) {
-		pr_err("Unable to allocate challenge buffer\n");
+	if (!challenge)
 		goto exit;
-	}
 
 	challenge_binhex = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
-	if (!challenge_binhex) {
-		pr_err("Unable to allocate challenge_binhex buffer\n");
+	if (!challenge_binhex)
 		goto free_challenge;
-	}
 
 	memset(chap_n, 0, MAX_CHAP_N_SIZE);
 
@@ -257,10 +252,8 @@ static int chap_server_compute_md5(
 	}
 
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
-	if (!desc) {
-		pr_err("Unable to allocate struct shash_desc\n");
+	if (!desc)
 		goto free_shash;
-	}
 
 	desc->tfm = tfm;
 	desc->flags = 0;
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index 173ddd93c757..c591165f9b1b 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -30,11 +30,9 @@ struct iscsi_datain_req *iscsit_allocate_datain_req(void)
 	struct iscsi_datain_req *dr;
 
 	dr = kmem_cache_zalloc(lio_dr_cache, GFP_ATOMIC);
-	if (!dr) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_datain_req\n");
+	if (!dr)
 		return NULL;
-	}
+
 	INIT_LIST_HEAD(&dr->cmd_datain_node);
 
 	return dr;
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 5efa42b939a1..ff3e08b6d4e1 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -59,11 +59,9 @@ int iscsit_dump_data_payload(
 	length = min(buf_len, OFFLOAD_BUF_SIZE);
 
 	buf = kzalloc(length, GFP_ATOMIC);
-	if (!buf) {
-		pr_err("Unable to allocate %u bytes for offload"
-				" buffer.\n", length);
+	if (!buf)
 		return -1;
-	}
+
 	memset(&iov, 0, sizeof(struct kvec));
 
 	while (offset < buf_len) {
@@ -787,11 +785,9 @@ static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 	struct iscsi_ooo_cmdsn *ooo_cmdsn = NULL;
 
 	ooo_cmdsn = kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC);
-	if (!ooo_cmdsn) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_ooo_cmdsn.\n");
+	if (!ooo_cmdsn)
 		return NULL;
-	}
+
 	INIT_LIST_HEAD(&ooo_cmdsn->ooo_list);
 
 	return ooo_cmdsn;
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 8df9c90f3db3..87c27e8d4f49 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -325,11 +325,9 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsi_conn *conn)
 	 * connection's command list for connection recovery.
 	 */
 	cr = kzalloc(sizeof(struct iscsi_conn_recovery), GFP_KERNEL);
-	if (!cr) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_conn_recovery.\n");
+	if (!cr)
 		return -1;
-	}
+
 	INIT_LIST_HEAD(&cr->cr_list);
 	INIT_LIST_HEAD(&cr->conn_recovery_cmd_list);
 	spin_lock_init(&cr->conn_recovery_cmd_lock);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 64c5a57b92e4..cfaf564825e0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -47,32 +47,24 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 	struct iscsi_login *login;
 
 	login = kzalloc(sizeof(struct iscsi_login), GFP_KERNEL);
-	if (!login) {
-		pr_err("Unable to allocate memory for struct iscsi_login.\n");
+	if (!login)
 		return NULL;
-	}
+
 	conn->login = login;
 	login->conn = conn;
 	login->first_request = 1;
 
 	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
-	if (!login->req_buf) {
-		pr_err("Unable to allocate memory for response buffer.\n");
+	if (!login->req_buf)
 		goto out_login;
-	}
 
 	login->rsp_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
-	if (!login->rsp_buf) {
-		pr_err("Unable to allocate memory for request buffer.\n");
+	if (!login->rsp_buf)
 		goto out_req_buf;
-	}
 
 	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
-	if (!conn->conn_ops) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_conn_ops.\n");
+	if (!conn->conn_ops)
 		goto out_rsp_buf;
-	}
 
 	init_waitqueue_head(&conn->queues_wq);
 	INIT_LIST_HEAD(&conn->conn_list);
@@ -306,7 +298,6 @@ static int iscsi_login_zero_tsih_s1(
 	if (!sess) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		pr_err("Could not allocate memory for session\n");
 		return -ENOMEM;
 	}
 
@@ -363,8 +354,6 @@ static int iscsi_login_zero_tsih_s1(
 	if (!sess->sess_ops) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_sess_ops.\n");
 		kfree(sess);
 		return -ENOMEM;
 	}
@@ -1257,8 +1246,6 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
 	if (!conn) {
-		pr_err("Could not allocate memory for"
-			" new connection\n");
 		/* Get another socket */
 		return 1;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b686e2ce9c0e..694842c772eb 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1075,10 +1075,8 @@ int iscsi_target_locate_portal(
 	payload_length = ntoh24(login_req->dlength);
 
 	tmpbuf = kzalloc(payload_length + 1, GFP_KERNEL);
-	if (!tmpbuf) {
-		pr_err("Unable to allocate memory for tmpbuf.\n");
+	if (!tmpbuf)
 		return -1;
-	}
 
 	memcpy(tmpbuf, login->req_buf, payload_length);
 	tmpbuf[payload_length] = '\0';
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 29a37b242d30..06310b2c4e26 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -130,23 +130,18 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 	struct iscsi_param *param = NULL;
 
 	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
-	if (!param) {
-		pr_err("Unable to allocate memory for parameter.\n");
+	if (!param)
 		goto out;
-	}
+
 	INIT_LIST_HEAD(&param->p_list);
 
 	param->name = kstrdup(name, GFP_KERNEL);
-	if (!param->name) {
-		pr_err("Unable to allocate memory for parameter name.\n");
+	if (!param->name)
 		goto out;
-	}
 
 	param->value = kstrdup(value, GFP_KERNEL);
-	if (!param->value) {
-		pr_err("Unable to allocate memory for parameter value.\n");
+	if (!param->value)
 		goto out;
-	}
 
 	param->phase		= phase;
 	param->scope		= scope;
@@ -205,11 +200,9 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 	struct iscsi_param_list *pl;
 
 	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
-	if (!pl) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_param_list.\n");
+	if (!pl)
 		return -ENOMEM;
-	}
+
 	INIT_LIST_HEAD(&pl->param_list);
 	INIT_LIST_HEAD(&pl->extra_response_list);
 
@@ -576,10 +569,9 @@ int iscsi_copy_param_list(
 	struct iscsi_param_list *param_list = NULL;
 
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
-	if (!param_list) {
-		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
+	if (!param_list)
 		return -ENOMEM;
-	}
+
 	INIT_LIST_HEAD(&param_list->param_list);
 	INIT_LIST_HEAD(&param_list->extra_response_list);
 
@@ -592,10 +584,8 @@ int iscsi_copy_param_list(
 		}
 
 		new_param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
-		if (!new_param) {
-			pr_err("Unable to allocate memory for struct iscsi_param.\n");
+		if (!new_param)
 			goto err_out;
-		}
 
 		new_param->name = kstrdup(param->name, GFP_KERNEL);
 		new_param->value = kstrdup(param->value, GFP_KERNEL);
@@ -703,10 +693,8 @@ int iscsi_update_param_value(struct iscsi_param *param, char *value)
 	kfree(param->value);
 
 	param->value = kstrdup(value, GFP_KERNEL);
-	if (!param->value) {
-		pr_err("Unable to allocate memory for value.\n");
+	if (!param->value)
 		return -ENOMEM;
-	}
 
 	pr_debug("iSCSI Parameter updated to %s=%s\n",
 			param->name, param->value);
@@ -727,11 +715,9 @@ static int iscsi_add_notunderstood_response(
 	}
 
 	extra_response = kzalloc(sizeof(struct iscsi_extra_response), GFP_KERNEL);
-	if (!extra_response) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_extra_response.\n");
+	if (!extra_response)
 		return -ENOMEM;
-	}
+
 	INIT_LIST_HEAD(&extra_response->er_list);
 
 	strlcpy(extra_response->key, key, sizeof(extra_response->key));
@@ -1366,10 +1352,8 @@ int iscsi_decode_text_input(
 	char *tmpbuf, *start = NULL, *end = NULL;
 
 	tmpbuf = kzalloc(length + 1, GFP_KERNEL);
-	if (!tmpbuf) {
-		pr_err("Unable to allocate %u + 1 bytes for tmpbuf.\n", length);
+	if (!tmpbuf)
 		return -ENOMEM;
-	}
 
 	memcpy(tmpbuf, textbuf, length);
 	tmpbuf[length] = '\0';
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index f65e5e584212..3a6e619bb30e 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -138,11 +138,9 @@ static int iscsit_randomize_pdu_lists(
 			continue;
 		}
 		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
-		if (!array) {
-			pr_err("Unable to allocate memory"
-				" for random array.\n");
+		if (!array)
 			return -ENOMEM;
-		}
+
 		iscsit_create_random_array(array, seq_count);
 
 		for (i = 0; i < seq_count; i++)
@@ -158,11 +156,9 @@ static int iscsit_randomize_pdu_lists(
 
 	if (seq_count) {
 		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
-		if (!array) {
-			pr_err("Unable to allocate memory for"
-				" random array.\n");
+		if (!array)
 			return -ENOMEM;
-		}
+
 		iscsit_create_random_array(array, seq_count);
 
 		for (i = 0; i < seq_count; i++)
@@ -190,10 +186,9 @@ static int iscsit_randomize_seq_lists(
 		return 0;
 
 	array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
-	if (!array) {
-		pr_err("Unable to allocate memory for random array.\n");
+	if (!array)
 		return -ENOMEM;
-	}
+
 	iscsit_create_random_array(array, seq_count);
 
 	for (i = 0; i < cmd->seq_count; i++) {
@@ -544,10 +539,9 @@ int iscsit_build_pdu_and_seq_lists(
 
 	if (!conn->sess->sess_ops->DataSequenceInOrder) {
 		seq = kcalloc(seq_count, sizeof(struct iscsi_seq), GFP_ATOMIC);
-		if (!seq) {
-			pr_err("Unable to allocate struct iscsi_seq list\n");
+		if (!seq)
 			return -ENOMEM;
-		}
+
 		cmd->seq_list = seq;
 		cmd->seq_count = seq_count;
 	}
@@ -555,7 +549,6 @@ int iscsit_build_pdu_and_seq_lists(
 	if (!conn->sess->sess_ops->DataPDUInOrder) {
 		pdu = kcalloc(pdu_count, sizeof(struct iscsi_pdu), GFP_ATOMIC);
 		if (!pdu) {
-			pr_err("Unable to allocate struct iscsi_pdu list.\n");
 			kfree(seq);
 			return -ENOMEM;
 		}
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 4b34f71547c6..c3a607b3ccc8 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -35,10 +35,8 @@ struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn *tiqn, u1
 	struct iscsi_portal_group *tpg;
 
 	tpg = kzalloc(sizeof(struct iscsi_portal_group), GFP_KERNEL);
-	if (!tpg) {
-		pr_err("Unable to allocate struct iscsi_portal_group\n");
+	if (!tpg)
 		return NULL;
-	}
 
 	tpg->tpgt = tpgt;
 	tpg->tpg_state = TPG_STATE_FREE;
@@ -477,11 +475,8 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 	}
 
 	tpg_np = kzalloc(sizeof(struct iscsi_tpg_np), GFP_KERNEL);
-	if (!tpg_np) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_tpg_np.\n");
+	if (!tpg_np)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	np = iscsit_add_np(sockaddr, network_transport);
 	if (IS_ERR(np)) {
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 4435bf374d2d..30175e1f4672 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -69,10 +69,9 @@ int iscsit_add_r2t_to_list(
 	struct iscsi_r2t *r2t;
 
 	r2t = kmem_cache_zalloc(lio_r2t_cache, GFP_ATOMIC);
-	if (!r2t) {
-		pr_err("Unable to allocate memory for struct iscsi_r2t.\n");
+	if (!r2t)
 		return -1;
-	}
+
 	INIT_LIST_HEAD(&r2t->r2t_list);
 
 	r2t->recovery_r2t = recovery;
@@ -577,11 +576,9 @@ int iscsit_add_cmd_to_response_queue(
 	struct iscsi_queue_req *qr;
 
 	qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
-	if (!qr) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_queue_req\n");
+	if (!qr)
 		return -ENOMEM;
-	}
+
 	INIT_LIST_HEAD(&qr->qr_list);
 	qr->cmd = cmd;
 	qr->state = state;
-- 
2.15.1
