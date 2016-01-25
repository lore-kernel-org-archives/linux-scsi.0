From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 08/12] sbp-target: Convert to TARGET_SCF_ACK_KREF I/O krefs
Date: Mon, 25 Jan 2016 08:11:02 +0000
Message-ID: <1453709466-6308-9-git-send-email-nab@daterainc.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1453709466-6308-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Cc: Chris Boot <bootc@bootc.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/sbp/sbp_target.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 756e87f..251d532 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -893,7 +893,6 @@ static void tgt_agent_process_work(struct work_struct *work)
 					STATUS_BLOCK_SBP_STATUS(
 						SBP_STATUS_REQ_TYPE_NOTSUPP));
 			sbp_send_status(req);
-			sbp_free_request(req);
 			return;
 		case 3: /* Dummy ORB */
 			req->status.status |= cpu_to_be32(
@@ -904,7 +903,6 @@ static void tgt_agent_process_work(struct work_struct *work)
 					STATUS_BLOCK_SBP_STATUS(
 						SBP_STATUS_DUMMY_ORB_COMPLETE));
 			sbp_send_status(req);
-			sbp_free_request(req);
 			return;
 		default:
 			BUG();
@@ -988,7 +986,6 @@ static void tgt_agent_fetch_work(struct work_struct *work)
 			spin_unlock_bh(&agent->lock);
 
 			sbp_send_status(req);
-			sbp_free_request(req);
 			return;
 		}
 
@@ -1235,7 +1232,7 @@ static void sbp_handle_command(struct sbp_target_request *req)
 	req->se_cmd.tag = req->orb_pointer;
 	if (target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
 			      req->sense_buf, unpacked_lun, data_length,
-			      TCM_SIMPLE_TAG, data_dir, 0))
+			      TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF))
 		goto err;
 
 	return;
@@ -1247,7 +1244,6 @@ err:
 		STATUS_BLOCK_LEN(1) |
 		STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
 	sbp_send_status(req);
-	sbp_free_request(req);
 }
 
 /*
@@ -1346,22 +1342,29 @@ static int sbp_rw_data(struct sbp_target_request *req)
 
 static int sbp_send_status(struct sbp_target_request *req)
 {
-	int ret, length;
+	int rc, ret = 0, length;
 	struct sbp_login_descriptor *login = req->login;
 
 	length = (((be32_to_cpu(req->status.status) >> 24) & 0x07) + 1) * 4;
 
-	ret = sbp_run_request_transaction(req, TCODE_WRITE_BLOCK_REQUEST,
+	rc = sbp_run_request_transaction(req, TCODE_WRITE_BLOCK_REQUEST,
 			login->status_fifo_addr, &req->status, length);
-	if (ret != RCODE_COMPLETE) {
-		pr_debug("sbp_send_status: write failed: 0x%x\n", ret);
-		return -EIO;
+	if (rc != RCODE_COMPLETE) {
+		pr_debug("sbp_send_status: write failed: 0x%x\n", rc);
+		ret = -EIO;
+		goto put_ref;
 	}
 
 	pr_debug("sbp_send_status: status write complete for ORB: 0x%llx\n",
 			req->orb_pointer);
-
-	return 0;
+	/*
+	 * Drop the extra ACK_KREF reference taken by target_submit_cmd()
+	 * ahead of sbp_check_stop_free() -> transport_generic_free_cmd()
+	 * final se_cmd->cmd_kref put.
+	 */
+put_ref:
+	target_put_sess_cmd(&req->se_cmd);
+	return ret;
 }
 
 static void sbp_sense_mangle(struct sbp_target_request *req)
@@ -1826,8 +1829,7 @@ static int sbp_check_stop_free(struct se_cmd *se_cmd)
 	struct sbp_target_request *req = container_of(se_cmd,
 			struct sbp_target_request, se_cmd);
 
-	transport_generic_free_cmd(&req->se_cmd, 0);
-	return 1;
+	return transport_generic_free_cmd(&req->se_cmd, 0);
 }
 
 static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
-- 
1.9.1
