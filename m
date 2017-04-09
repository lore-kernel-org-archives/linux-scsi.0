From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] iscsi-target: Delete error messages for failed memory
 allocations
Date: Sun, 9 Apr 2017 16:26:26 +0200
Message-ID: <feaea14d-9e1e-4a64-4734-811195f31bd2@users.sourceforge.net>
References: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 15:34:50 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Possible unnecessary 'out of memory' message

Thus remove such statements here.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 536b939afe9d..196e9dd138ca 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -129,10 +129,8 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	}
 
 	tiqn = kzalloc(sizeof(struct iscsi_tiqn), GFP_KERNEL);
-	if (!tiqn) {
-		pr_err("Unable to allocate struct iscsi_tiqn\n");
+	if (!tiqn)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	sprintf(tiqn->tiqn, "%s", buf);
 	INIT_LIST_HEAD(&tiqn->tiqn_list);
@@ -364,7 +362,6 @@ struct iscsi_np *iscsit_add_np(
 
 	np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
 	if (!np) {
-		pr_err("Unable to allocate memory for struct iscsi_np\n");
 		mutex_unlock(&np_lock);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -699,10 +696,9 @@ static int __init iscsi_target_init_module(void)
 	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
 
 	iscsit_global = kzalloc(sizeof(struct iscsit_global), GFP_KERNEL);
-	if (!iscsit_global) {
-		pr_err("Unable to allocate memory for iscsit_global\n");
+	if (!iscsit_global)
 		return -1;
-	}
+
 	spin_lock_init(&iscsit_global->ts_bitmap_lock);
 	mutex_init(&auth_id_lock);
 	spin_lock_init(&sess_idr_lock);
@@ -715,10 +711,8 @@ static int __init iscsi_target_init_module(void)
 
 	size = BITS_TO_LONGS(ISCSIT_BITMAP_BITS) * sizeof(long);
 	iscsit_global->ts_bitmap = vzalloc(size);
-	if (!iscsit_global->ts_bitmap) {
-		pr_err("Unable to allocate iscsit_global->ts_bitmap\n");
+	if (!iscsit_global->ts_bitmap)
 		goto configfs_out;
-	}
 
 	lio_qr_cache = kmem_cache_create("lio_qr_cache",
 			sizeof(struct iscsi_queue_req),
@@ -986,10 +980,8 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 
 	iov_count += ISCSI_IOV_DATA_BUFFER;
 	cmd->iov_data = kcalloc(iov_count, sizeof(*cmd->iov_data), GFP_KERNEL);
-	if (!cmd->iov_data) {
-		pr_err("Unable to allocate cmd->iov_data\n");
+	if (!cmd->iov_data)
 		return -ENOMEM;
-	}
 
 	cmd->orig_iov_data_count = iov_count;
 	return 0;
@@ -1850,8 +1842,6 @@ static int iscsit_handle_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 		ping_data = kzalloc(payload_length + 1, GFP_KERNEL);
 		if (!ping_data) {
-			pr_err("Unable to allocate memory for"
-				" NOPOUT ping data.\n");
 			ret = -1;
 			goto out;
 		}
@@ -1999,13 +1989,10 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	cmd->data_direction = DMA_NONE;
 
 	cmd->tmr_req = kzalloc(sizeof(struct iscsi_tmr_req), GFP_KERNEL);
-	if (!cmd->tmr_req) {
-		pr_err("Unable to allocate memory for"
-			" Task Management command!\n");
+	if (!cmd->tmr_req)
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_NO_RESOURCES,
 					     buf);
-	}
 
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
@@ -2265,11 +2252,9 @@ iscsit_handle_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		struct kvec iov[3];
 
 		text_in = kzalloc(payload_length, GFP_KERNEL);
-		if (!text_in) {
-			pr_err("Unable to allocate memory for"
-				" incoming text parameters\n");
+		if (!text_in)
 			goto reject;
-		}
+
 		cmd->text_in_ptr = text_in;
 
 		memset(iov, 0, 3 * sizeof(struct kvec));
@@ -3353,11 +3338,9 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 			 SENDTARGETS_BUF_LIMIT);
 
 	payload = kzalloc(buffer_len, GFP_KERNEL);
-	if (!payload) {
-		pr_err("Unable to allocate memory for sendtargets"
-				" response.\n");
+	if (!payload)
 		return -ENOMEM;
-	}
+
 	/*
 	 * Locate pointer to iqn./eui. string for ICF_SENDTARGETS_SINGLE
 	 * explicit case..
-- 
2.12.2
