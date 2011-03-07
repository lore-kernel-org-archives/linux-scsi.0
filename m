From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH 4/6] [SCSI] bnx2fc: Call bnx2fc_return_rqe and
 bnx2fc_get_next_rqe with tgt lock held
Date: Mon, 7 Mar 2011 15:42:27 -0800
Message-ID: <1299541349-2438-4-git-send-email-mchan@broadcom.com>
References: <1299541349-2438-1-git-send-email-mchan@broadcom.com>
 <1299541349-2438-2-git-send-email-mchan@broadcom.com>
 <1299541349-2438-3-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2145 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1CHAgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 19:36:38 -0500
In-Reply-To: <1299541349-2438-3-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, michaelc@cs.wisc.edu, bprakash@broadcom.com, nsujir@broadcom.com, Michael Chan <mchan@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

tgt lock is needed during -
        bnx2fc_return_rqe to protect the rq_prod_idx.
        bnx2fc_get_next_rqe to protect rq_cons_idx

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 4f40968..3de1ce7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -590,7 +590,10 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 
 		num_rq = (frame_len + BNX2FC_RQ_BUF_SZ - 1) / BNX2FC_RQ_BUF_SZ;
 
+		spin_lock_bh(&tgt->tgt_lock);
 		rq_data = (unsigned char *)bnx2fc_get_next_rqe(tgt, num_rq);
+		spin_unlock_bh(&tgt->tgt_lock);
+
 		if (rq_data) {
 			buf = rq_data;
 		} else {
@@ -603,8 +606,10 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 			}
 
 			for (i = 0; i < num_rq; i++) {
+				spin_lock_bh(&tgt->tgt_lock);
 				rq_data = (unsigned char *)
 					   bnx2fc_get_next_rqe(tgt, 1);
+				spin_unlock_bh(&tgt->tgt_lock);
 				len = BNX2FC_RQ_BUF_SZ;
 				memcpy(buf1, rq_data, len);
 				buf1 += len;
@@ -615,13 +620,15 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 
 		if (buf != rq_data)
 			kfree(buf);
+		spin_lock_bh(&tgt->tgt_lock);
 		bnx2fc_return_rqe(tgt, num_rq);
+		spin_unlock_bh(&tgt->tgt_lock);
 		break;
 
 	case FCOE_ERROR_DETECTION_CQE_TYPE:
 		/*
-		 *In case of error reporting CQE a single RQ entry
-		 * is consumes.
+		 * In case of error reporting CQE a single RQ entry
+		 * is consumed.
 		 */
 		spin_lock_bh(&tgt->tgt_lock);
 		num_rq = 1;
@@ -705,6 +712,7 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 		 *In case of warning reporting CQE a single RQ entry
 		 * is consumes.
 		 */
+		spin_lock_bh(&tgt->tgt_lock);
 		num_rq = 1;
 		err_entry = (struct fcoe_err_report_entry *)
 			     bnx2fc_get_next_rqe(tgt, 1);
@@ -717,6 +725,7 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 			err_entry->tx_buf_off, err_entry->rx_buf_off);
 
 		bnx2fc_return_rqe(tgt, 1);
+		spin_unlock_bh(&tgt->tgt_lock);
 		break;
 
 	default:
-- 
1.6.4.GIT


