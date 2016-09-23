From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] cxgb4i: set completion bit in work request
Date: Fri, 23 Sep 2016 20:07:40 +0530
Message-ID: <1474641460-23106-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:51911 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034627AbcIWOiB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2016 10:38:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, indranil@chelsio.com, varun@chelsio.com

If SKCBF_TX_FLAG_COMPL flag is set and unacknowledged
credits are >= max credits / 2, set completion bit
in work request to reclaim credits.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 7c0d7af..0039beb 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -685,6 +685,11 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 					req_completion);
 			csk->snd_nxt += len;
 			cxgbi_skcb_clear_flag(skb, SKCBF_TX_NEED_HDR);
+		} else if (cxgbi_skcb_test_flag(skb, SKCBF_TX_FLAG_COMPL) &&
+			   (csk->wr_una_cred >= (csk->wr_max_cred / 2))) {
+			struct cpl_close_con_req *req =
+				(struct cpl_close_con_req *)skb->data;
+			req->wr.wr_hi |= htonl(FW_WR_COMPL_F);
 		}
 		total_size += skb->truesize;
 		t4_set_arp_err_handler(skb, csk, arp_failure_skb_discard);
-- 
2.0.2

