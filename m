From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/3] bnx2fc: Handle SRR LS_ACC drop scenario
Date: Sun, 23 Oct 2011 23:23:57 -0700
Message-ID: <1319437438-7596-2-git-send-email-bprakash@broadcom.com>
References: <1319437438-7596-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2760 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab1JXGYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2011 02:24:11 -0400
In-Reply-To: <1319437438-7596-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com

When SRR LS_ACC is dropped, the driver was not issuing ABTS for SRR when it
times out. Since the target received SRR, it was able to send the XFER_RDY and
the the original IO request completed successfully. In this condition ABTS was
not sent during bnx2fc_srr_compl(). Fix this by first checking for ELS timeout
and issue ABTS before checking if original IO request is complete.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index fd382fe..ce0ce3e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -268,17 +268,6 @@ void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 
 	orig_io_req = cb_arg->aborted_io_req;
 	srr_req = cb_arg->io_req;
-	if (test_bit(BNX2FC_FLAG_IO_COMPL, &orig_io_req->req_flags)) {
-		BNX2FC_IO_DBG(srr_req, "srr_compl: xid - 0x%x completed",
-			orig_io_req->xid);
-		goto srr_compl_done;
-	}
-	if (test_bit(BNX2FC_FLAG_ISSUE_ABTS, &orig_io_req->req_flags)) {
-		BNX2FC_IO_DBG(srr_req, "rec abts in prog "
-		       "orig_io - 0x%x\n",
-			orig_io_req->xid);
-		goto srr_compl_done;
-	}
 	if (test_and_clear_bit(BNX2FC_FLAG_ELS_TIMEOUT, &srr_req->req_flags)) {
 		/* SRR timedout */
 		BNX2FC_IO_DBG(srr_req, "srr timed out, abort "
@@ -290,6 +279,12 @@ void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 				"failed. issue cleanup\n");
 			bnx2fc_initiate_cleanup(srr_req);
 		}
+		if (test_bit(BNX2FC_FLAG_IO_COMPL, &orig_io_req->req_flags) ||
+		    test_bit(BNX2FC_FLAG_ISSUE_ABTS, &orig_io_req->req_flags)) {
+			BNX2FC_IO_DBG(srr_req, "srr_compl:xid 0x%x flags = %lx",
+				      orig_io_req->xid, orig_io_req->req_flags);
+			goto srr_compl_done;
+		}
 		orig_io_req->srr_retry++;
 		if (orig_io_req->srr_retry <= SRR_RETRY_COUNT) {
 			struct bnx2fc_rport *tgt = orig_io_req->tgt;
@@ -311,6 +306,12 @@ void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 		}
 		goto srr_compl_done;
 	}
+	if (test_bit(BNX2FC_FLAG_IO_COMPL, &orig_io_req->req_flags) ||
+	    test_bit(BNX2FC_FLAG_ISSUE_ABTS, &orig_io_req->req_flags)) {
+		BNX2FC_IO_DBG(srr_req, "srr_compl:xid - 0x%x flags = %lx",
+			      orig_io_req->xid, orig_io_req->req_flags);
+		goto srr_compl_done;
+	}
 	mp_req = &(srr_req->mp_req);
 	fc_hdr = &(mp_req->resp_fc_hdr);
 	resp_len = mp_req->resp_len;
-- 
1.7.0.6


