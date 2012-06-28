From: kxie@chelsio.com
Subject: [PATCH] cxgb4i: tcp push bit fix
Date: Thu, 28 Jun 2012 16:49:07 -0700
Message-ID: <201206282349.q5SNn7H9017422@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:20734 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2F1XtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jun 2012 19:49:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH] cxgb4i: tcp push bit fix

From: Karen Xie <kxie@chelsio.com>

Fixed the parentheses so the tcp push bit would be sent properly.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 5a4a3bf..9bfc348 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -438,8 +438,8 @@ static inline void make_tx_data_wr(struct cxgbi_sock *csk, struct sk_buff *skb,
 	if (submode)
 		wr_ulp_mode = FW_OFLD_TX_DATA_WR_ULPMODE(ULP2_MODE_ISCSI) |
 				FW_OFLD_TX_DATA_WR_ULPSUBMODE(submode);
-	req->tunnel_to_proxy = htonl(wr_ulp_mode) |
-		 FW_OFLD_TX_DATA_WR_SHOVE(skb_peek(&csk->write_queue) ? 0 : 1);
+	req->tunnel_to_proxy = htonl(wr_ulp_mode |
+		 FW_OFLD_TX_DATA_WR_SHOVE(skb_peek(&csk->write_queue) ? 0 : 1));
 	req->plen = htonl(len);
 	if (!cxgbi_sock_flag(csk, CTPF_TX_DATA_SENT))
 		cxgbi_sock_set_flag(csk, CTPF_TX_DATA_SENT);
