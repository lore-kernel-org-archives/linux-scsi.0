From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/8] bnx2fc: No abort issued for REC when it times out
Date: Tue, 30 Aug 2011 15:54:49 -0700
Message-ID: <1314744894-24710-4-git-send-email-bprakash@broadcom.com>
References: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3579 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1H3WzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:08 -0400
In-Reply-To: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, nsujir@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

ABTS was not issued for timed out REC, as REC completion handler exits out if
the IO completed. Check for timed out REC and issue ABTS before proceeding with
further processing in REC completion handler. Also, initialize rec_retry and
srr_retry before starting the IO.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c |   26 ++++++++++++++------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    6 ++++--
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index d66dcbd..fd382fe 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -391,18 +391,6 @@ void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
 	BNX2FC_IO_DBG(rec_req, "rec_compl: orig xid = 0x%x", orig_io_req->xid);
 	tgt = orig_io_req->tgt;
 
-	if (test_bit(BNX2FC_FLAG_IO_COMPL, &orig_io_req->req_flags)) {
-		BNX2FC_IO_DBG(rec_req, "completed"
-		       "orig_io - 0x%x\n",
-			orig_io_req->xid);
-		goto rec_compl_done;
-	}
-	if (test_bit(BNX2FC_FLAG_ISSUE_ABTS, &orig_io_req->req_flags)) {
-		BNX2FC_IO_DBG(rec_req, "abts in prog "
-		       "orig_io - 0x%x\n",
-			orig_io_req->xid);
-		goto rec_compl_done;
-	}
 	/* Handle REC timeout case */
 	if (test_and_clear_bit(BNX2FC_FLAG_ELS_TIMEOUT, &rec_req->req_flags)) {
 		BNX2FC_IO_DBG(rec_req, "timed out, abort "
@@ -433,6 +421,20 @@ void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
 		}
 		goto rec_compl_done;
 	}
+
+	if (test_bit(BNX2FC_FLAG_IO_COMPL, &orig_io_req->req_flags)) {
+		BNX2FC_IO_DBG(rec_req, "completed"
+		       "orig_io - 0x%x\n",
+			orig_io_req->xid);
+		goto rec_compl_done;
+	}
+	if (test_bit(BNX2FC_FLAG_ISSUE_ABTS, &orig_io_req->req_flags)) {
+		BNX2FC_IO_DBG(rec_req, "abts in prog "
+		       "orig_io - 0x%x\n",
+			orig_io_req->xid);
+		goto rec_compl_done;
+	}
+
 	mp_req = &(rec_req->mp_req);
 	fc_hdr = &(mp_req->resp_fc_hdr);
 	resp_len = mp_req->resp_len;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index b241f3d..1923a25 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1743,11 +1743,13 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 	/* Init state to NORMAL */
 	task->txwr_rxrd.const_ctx.init_flags |= task_type <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_TASK_TYPE_SHIFT;
-	if (dev_type == TYPE_TAPE)
+	if (dev_type == TYPE_TAPE) {
 		task->txwr_rxrd.const_ctx.init_flags |=
 				FCOE_TASK_DEV_TYPE_TAPE <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
-	else
+		io_req->rec_retry = 0;
+		io_req->rec_retry = 0;
+	} else
 		task->txwr_rxrd.const_ctx.init_flags |=
 				FCOE_TASK_DEV_TYPE_DISK <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
-- 
1.7.0.6


