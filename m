From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi v2] cxgb4i : Send abort_rpl correctly
Date: Thu,  6 Nov 2014 12:53:58 -0800
Message-ID: <1415307238-29010-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:33003
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750706AbaKFU4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 15:56:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com, Anish Bhatt <anish@chelsio.com>

Connection retries were not being cleaned up correctly if they failed as a
 result of link down. Applies on top of drivers-for-3.18.

v2 : Previous patch casued a build failure and was backed out. Fixed and
 verified with this patch.

Signed-off-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Karen Xie <kxie@chelsio.com>

---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 15 +++++++++------
 drivers/scsi/cxgbi/libcxgbi.c      | 18 ++++++++----------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 3e0a0d3..81bb3bd 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -936,20 +936,23 @@ static void do_abort_req_rss(struct cxgbi_device *cdev, struct sk_buff *skb)
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
 
-	if (!cxgbi_sock_flag(csk, CTPF_ABORT_REQ_RCVD)) {
-		cxgbi_sock_set_flag(csk, CTPF_ABORT_REQ_RCVD);
-		cxgbi_sock_set_state(csk, CTP_ABORTING);
-		goto done;
+	cxgbi_sock_clear_flag(csk, CTPF_ABORT_REQ_RCVD);
+
+	if (!cxgbi_sock_flag(csk, CTPF_TX_DATA_SENT)) {
+		send_tx_flowc_wr(csk);
+		cxgbi_sock_set_flag(csk, CTPF_TX_DATA_SENT);
 	}
 
-	cxgbi_sock_clear_flag(csk, CTPF_ABORT_REQ_RCVD);
+	cxgbi_sock_set_flag(csk, CTPF_ABORT_REQ_RCVD);
+	cxgbi_sock_set_state(csk, CTP_ABORTING);
+
 	send_abort_rpl(csk, rst_status);
 
 	if (!cxgbi_sock_flag(csk, CTPF_ABORT_RPL_PENDING)) {
 		csk->err = abort_status_to_errno(csk, req->status, &rst_status);
 		cxgbi_sock_closed(csk);
 	}
-done:
+
 	spin_unlock_bh(&csk->lock);
 	cxgbi_sock_put(csk);
 rel_skb:
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 674d498..13d869a 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -905,18 +905,16 @@ void cxgbi_sock_rcv_abort_rpl(struct cxgbi_sock *csk)
 {
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
+
+	cxgbi_sock_set_flag(csk, CTPF_ABORT_RPL_RCVD);
 	if (cxgbi_sock_flag(csk, CTPF_ABORT_RPL_PENDING)) {
-		if (!cxgbi_sock_flag(csk, CTPF_ABORT_RPL_RCVD))
-			cxgbi_sock_set_flag(csk, CTPF_ABORT_RPL_RCVD);
-		else {
-			cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_RCVD);
-			cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_PENDING);
-			if (cxgbi_sock_flag(csk, CTPF_ABORT_REQ_RCVD))
-				pr_err("csk 0x%p,%u,0x%lx,%u,ABT_RPL_RSS.\n",
-					csk, csk->state, csk->flags, csk->tid);
-			cxgbi_sock_closed(csk);
-		}
+		cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_PENDING);
+		if (cxgbi_sock_flag(csk, CTPF_ABORT_REQ_RCVD))
+			pr_err("csk 0x%p,%u,0x%lx,%u,ABT_RPL_RSS.\n",
+			       csk, csk->state, csk->flags, csk->tid);
+		cxgbi_sock_closed(csk);
 	}
+
 	spin_unlock_bh(&csk->lock);
 	cxgbi_sock_put(csk);
 }
-- 
2.1.3

