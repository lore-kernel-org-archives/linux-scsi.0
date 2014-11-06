From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi] cxgb4i : Fix build failure
Date: Thu,  6 Nov 2014 09:49:17 -0800
Message-ID: <1415296157-26776-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:60897
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881AbaKFRvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 12:51:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com, Anish Bhatt <anish@chelsio.com>

Christoph, this fixes the build failure from the previous patch. Sorry about
that. Please apply to drivers-for-3.18 as well.
-Anish

Signed-off-by: Anish Bhatt <anish@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2d2f3d0..81bb3bd 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -939,7 +939,7 @@ static void do_abort_req_rss(struct cxgbi_device *cdev, struct sk_buff *skb)
 	cxgbi_sock_clear_flag(csk, CTPF_ABORT_REQ_RCVD);
 
 	if (!cxgbi_sock_flag(csk, CTPF_TX_DATA_SENT)) {
-		send_tx_flowc_wr(csk, 0);
+		send_tx_flowc_wr(csk);
 		cxgbi_sock_set_flag(csk, CTPF_TX_DATA_SENT);
 	}
 
-- 
2.1.3

