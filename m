From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 08/14] sbp-target: Convert to TARGET_SCF_ACK_KREF I/O krefs
Date: Fri, 11 Mar 2016 06:30:04 +0000
Message-ID: <1457677810-2478-9-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33901 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbcCKGep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 01:34:45 -0500
Received: by mail-oi0-f52.google.com with SMTP id m82so78982705oif.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 22:34:45 -0800 (PST)
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts sbp-target to modern TARGET_SCF_ACK_KREF
usage for sbp_send_status() callback path, and drops the now
obsolete sbp_free_request() failure path calls.

Acked-by: Chris Boot <bootc@bootc.net>
Tested-by: Chris Boot <bootc@bootc.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/sbp/sbp_target.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 627044f2..c57e788 100644
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
@@ -989,7 +987,6 @@ static void tgt_agent_fetch_work(struct work_struct *work)
 			spin_unlock_bh(&agent->lock);
 
 			sbp_send_status(req);
-			sbp_free_request(req);
 			return;
 		}
 
@@ -1236,7 +1233,7 @@ static void sbp_handle_command(struct sbp_target_request *req)
 	req->se_cmd.tag = req->orb_pointer;
 	if (target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
 			      req->sense_buf, unpacked_lun, data_length,
-			      TCM_SIMPLE_TAG, data_dir, 0))
+			      TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF))
 		goto err;
 
 	return;
@@ -1248,7 +1245,6 @@ err:
 		STATUS_BLOCK_LEN(1) |
 		STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
 	sbp_send_status(req);
-	sbp_free_request(req);
 }
 
 /*
@@ -1347,22 +1343,29 @@ static int sbp_rw_data(struct sbp_target_request *req)
 
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
@@ -1822,8 +1825,7 @@ static int sbp_check_stop_free(struct se_cmd *se_cmd)
 	struct sbp_target_request *req = container_of(se_cmd,
 			struct sbp_target_request, se_cmd);
 
-	transport_generic_free_cmd(&req->se_cmd, 0);
-	return 1;
+	return transport_generic_free_cmd(&req->se_cmd, 0);
 }
 
 static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
-- 
1.9.1

