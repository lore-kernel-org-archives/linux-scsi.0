From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/8] bnx2fc: remove useless calls to memset().
Date: Fri, 21 Dec 2012 19:40:27 -0800
Message-ID: <1356147634-17252-2-git-send-email-bprakash@broadcom.com>
References: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2961 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2LVDkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:43 -0500
In-Reply-To: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Cyril Roelandt <tipecaml@gmail.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Cyril Roelandt <tipecaml@gmail.com>

These calls are followed by calls to memcpy() on the same memory area, so they
can be safely removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 6d6eee4..c31523b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -759,8 +759,6 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 		case FCOE_ERROR_CODE_DATA_SOFN_SEQ_ACTIVE_RESET:
 			BNX2FC_TGT_DBG(tgt, "REC TOV popped for xid - 0x%x\n",
 				   xid);
-			memset(&io_req->err_entry, 0,
-			       sizeof(struct fcoe_err_report_entry));
 			memcpy(&io_req->err_entry, err_entry,
 			       sizeof(struct fcoe_err_report_entry));
 			if (!test_bit(BNX2FC_FLAG_SRR_SENT,
@@ -847,8 +845,6 @@ ret_err_rqe:
 			goto ret_warn_rqe;
 		}
 
-		memset(&io_req->err_entry, 0,
-		       sizeof(struct fcoe_err_report_entry));
 		memcpy(&io_req->err_entry, err_entry,
 		       sizeof(struct fcoe_err_report_entry));
 
-- 
1.7.0.6


