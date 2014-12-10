From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH net v6 4/7] cxgb4i: additional types of negative advice
Date: Wed, 10 Dec 2014 08:25:19 -0800
Message-ID: <201412101625.sBAGPJHP011092@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Cc: kxie@chelsio.com, hariprasad@chelsio.com, anish@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, davem@davemloft.net
List-Id: linux-scsi@vger.kernel.org

[PATCH net v6 4/7] cxgb4i: additional types of negative advice

From: Karen Xie <kxie@chelsio.com>

Treat both CPL_ERR_KEEPALV_NEG_ADVICE and CPL_ERR_PERSIST_NEG_ADVICE as negative advice.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 5f31eb7..2880f200 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -846,6 +846,13 @@ static void csk_act_open_retry_timer(unsigned long data)
 
 }
 
+static inline bool is_neg_adv(unsigned int status)
+{
+	return status == CPL_ERR_RTX_NEG_ADVICE ||
+		status == CPL_ERR_KEEPALV_NEG_ADVICE ||
+		status == CPL_ERR_PERSIST_NEG_ADVICE;
+}
+
 static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 {
 	struct cxgbi_sock *csk;
@@ -867,7 +874,7 @@ static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 		       "csk 0x%p,%u,0x%lx. ", (&csk->saddr), (&csk->daddr),
 		       atid, tid, status, csk, csk->state, csk->flags);
 
-	if (status == CPL_ERR_RTX_NEG_ADVICE)
+	if (is_neg_adv(status))
 		goto rel_skb;
 
 	module_put(THIS_MODULE);
@@ -973,8 +980,7 @@ static void do_abort_req_rss(struct cxgbi_device *cdev, struct sk_buff *skb)
 		       (&csk->saddr), (&csk->daddr),
 		       csk, csk->state, csk->flags, csk->tid, req->status);
 
-	if (req->status == CPL_ERR_RTX_NEG_ADVICE ||
-	    req->status == CPL_ERR_PERSIST_NEG_ADVICE)
+	if (is_neg_adv(req->status))
 		goto rel_skb;
 
 	cxgbi_sock_get(csk);
