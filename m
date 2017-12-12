From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 8/8] target/iscsi: Improve 16 size determinations
Date: Tue, 12 Dec 2017 22:52:04 +0100
Message-ID: <5ec6d156-1b73-e0de-2c38-a8e3bc133e68@users.sourceforge.net>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 22:06:00 +0100

Replace the specification of data types by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_erl2.c         |  2 +-
 drivers/target/iscsi/iscsi_target_login.c        |  6 +++---
 drivers/target/iscsi/iscsi_target_parameters.c   | 10 +++++-----
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c | 11 ++++++-----
 drivers/target/iscsi/iscsi_target_tpg.c          |  4 ++--
 5 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 87c27e8d4f49..80b8297f4b05 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -324,7 +324,7 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsi_conn *conn)
 	 * (struct iscsi_cmd->cr) so we need to allocate this before preparing the
 	 * connection's command list for connection recovery.
 	 */
-	cr = kzalloc(sizeof(struct iscsi_conn_recovery), GFP_KERNEL);
+	cr = kzalloc(sizeof(*cr), GFP_KERNEL);
 	if (!cr)
 		return -1;
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index cfaf564825e0..095651e48f36 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -46,7 +46,7 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 {
 	struct iscsi_login *login;
 
-	login = kzalloc(sizeof(struct iscsi_login), GFP_KERNEL);
+	login = kzalloc(sizeof(*login), GFP_KERNEL);
 	if (!login)
 		return NULL;
 
@@ -294,7 +294,7 @@ static int iscsi_login_zero_tsih_s1(
 	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
 	int ret;
 
-	sess = kzalloc(sizeof(struct iscsi_session), GFP_KERNEL);
+	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
 	if (!sess) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -1244,7 +1244,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 
-	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
+	conn = kzalloc(sizeof(*conn), GFP_KERNEL);
 	if (!conn) {
 		/* Get another socket */
 		return 1;
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index a49b0b2a4f6c..110e81a0c97d 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -129,7 +129,7 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 {
 	struct iscsi_param *param;
 
-	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param)
 		goto out;
 
@@ -199,7 +199,7 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 	struct iscsi_param *param;
 	struct iscsi_param_list *pl;
 
-	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
+	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
 	if (!pl)
 		return -ENOMEM;
 
@@ -568,7 +568,7 @@ int iscsi_copy_param_list(
 	struct iscsi_param *new_param = NULL;
 	struct iscsi_param_list *param_list;
 
-	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
+	param_list = kzalloc(sizeof(*param_list), GFP_KERNEL);
 	if (!param_list)
 		return -ENOMEM;
 
@@ -583,7 +583,7 @@ int iscsi_copy_param_list(
 				continue;
 		}
 
-		new_param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
+		new_param = kzalloc(sizeof(*new_param), GFP_KERNEL);
 		if (!new_param)
 			goto err_out;
 
@@ -714,7 +714,7 @@ static int iscsi_add_notunderstood_response(
 		return -1;
 	}
 
-	extra_response = kzalloc(sizeof(struct iscsi_extra_response), GFP_KERNEL);
+	extra_response = kzalloc(sizeof(*extra_response), GFP_KERNEL);
 	if (!extra_response)
 		return -ENOMEM;
 
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index 3a6e619bb30e..0fd914d92f4f 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -137,7 +137,8 @@ static int iscsit_randomize_pdu_lists(
 			seq_count++;
 			continue;
 		}
-		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
+
+		array = kcalloc(seq_count, sizeof(*array), GFP_KERNEL);
 		if (!array)
 			return -ENOMEM;
 
@@ -155,7 +156,7 @@ static int iscsit_randomize_pdu_lists(
 	}
 
 	if (seq_count) {
-		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
+		array = kcalloc(seq_count, sizeof(*array), GFP_KERNEL);
 		if (!array)
 			return -ENOMEM;
 
@@ -185,7 +186,7 @@ static int iscsit_randomize_seq_lists(
 	if (!seq_count)
 		return 0;
 
-	array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
+	array = kcalloc(seq_count, sizeof(*array), GFP_KERNEL);
 	if (!array)
 		return -ENOMEM;
 
@@ -538,7 +539,7 @@ int iscsit_build_pdu_and_seq_lists(
 	iscsit_determine_counts_for_list(cmd, &bl, &seq_count, &pdu_count);
 
 	if (!conn->sess->sess_ops->DataSequenceInOrder) {
-		seq = kcalloc(seq_count, sizeof(struct iscsi_seq), GFP_ATOMIC);
+		seq = kcalloc(seq_count, sizeof(*seq), GFP_ATOMIC);
 		if (!seq)
 			return -ENOMEM;
 
@@ -547,7 +548,7 @@ int iscsit_build_pdu_and_seq_lists(
 	}
 
 	if (!conn->sess->sess_ops->DataPDUInOrder) {
-		pdu = kcalloc(pdu_count, sizeof(struct iscsi_pdu), GFP_ATOMIC);
+		pdu = kcalloc(pdu_count, sizeof(*pdu), GFP_ATOMIC);
 		if (!pdu) {
 			kfree(seq);
 			return -ENOMEM;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index c3a607b3ccc8..3298145f74f5 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -34,7 +34,7 @@ struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn *tiqn, u1
 {
 	struct iscsi_portal_group *tpg;
 
-	tpg = kzalloc(sizeof(struct iscsi_portal_group), GFP_KERNEL);
+	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
 	if (!tpg)
 		return NULL;
 
@@ -474,7 +474,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 		}
 	}
 
-	tpg_np = kzalloc(sizeof(struct iscsi_tpg_np), GFP_KERNEL);
+	tpg_np = kzalloc(sizeof(*tpg_np), GFP_KERNEL);
 	if (!tpg_np)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.15.1
