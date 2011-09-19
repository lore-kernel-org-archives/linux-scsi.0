From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/3] bnx2fc: Handle bnx2fc_map_sg failure
Date: Mon, 19 Sep 2011 16:52:13 -0700
Message-ID: <1316476334-13232-2-git-send-email-bprakash@broadcom.com>
References: <1316476334-13232-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3221 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab1ISXwV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2011 19:52:21 -0400
In-Reply-To: <1316476334-13232-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Gracefully handle bnx2fc_map_sg failure, so that queuecommand returns host busy
and SCSI-ml can retry the IO.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 86da301..0c64d18 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -17,7 +17,7 @@
 static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
 			   int bd_index);
 static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req);
-static void bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req);
+static int bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req);
 static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req);
 static void bnx2fc_free_mp_resc(struct bnx2fc_cmd *io_req);
 static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
@@ -1607,20 +1607,24 @@ static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
 	return bd_count;
 }
 
-static void bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req)
+static int bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req)
 {
 	struct scsi_cmnd *sc = io_req->sc_cmd;
 	struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
 	int bd_count;
 
-	if (scsi_sg_count(sc))
+	if (scsi_sg_count(sc)) {
 		bd_count = bnx2fc_map_sg(io_req);
-	else {
+		if (bd_count == 0)
+			return -ENOMEM;
+	} else {
 		bd_count = 0;
 		bd[0].buf_addr_lo = bd[0].buf_addr_hi = 0;
 		bd[0].buf_len = bd[0].flags = 0;
 	}
 	io_req->bd_tbl->bd_valid = bd_count;
+
+	return 0;
 }
 
 static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
@@ -1942,7 +1946,13 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	xid = io_req->xid;
 
 	/* Build buffer descriptor list for firmware from sg list */
-	bnx2fc_build_bd_list_from_sg(io_req);
+	if (bnx2fc_build_bd_list_from_sg(io_req)) {
+		printk(KERN_ERR PFX "BD list creation failed\n");
+		spin_lock_bh(&tgt->tgt_lock);
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
+		return -EAGAIN;
+	}
 
 	task_idx = xid / BNX2FC_TASKS_PER_PAGE;
 	index = xid % BNX2FC_TASKS_PER_PAGE;
-- 
1.7.0.6


