From: kxie@chelsio.com
Subject: [PATCH 1/2] cxgbi: set ulpmode only if digest is on
Date: Fri, 07 Jan 2011 14:45:39 -0800
Message-ID: <201101072245.p07Mjdea027574@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:28257 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab1AGWpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 17:45:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH 1/2] cxgbi: set ulpmode only if digest is on

From: Karen Xie <kxie@chelsio.com>

There is need to set ulpmode on the tx skbs if no digest is enabled.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index be56617..17dcada 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1908,13 +1908,16 @@ EXPORT_SYMBOL_GPL(cxgbi_conn_alloc_pdu);
 
 static inline void tx_skb_setmode(struct sk_buff *skb, int hcrc, int dcrc)
 {
-	u8 submode = 0;
-
-	if (hcrc)
-		submode |= 1;
-	if (dcrc)
-		submode |= 2;
-	cxgbi_skcb_ulp_mode(skb) = (ULP2_MODE_ISCSI << 4) | submode;
+	if (hcrc || dcrc) {
+		u8 submode = 0;
+
+		if (hcrc)
+			submode |= 1;
+		if (dcrc)
+			submode |= 2;
+		cxgbi_skcb_ulp_mode(skb) = (ULP2_MODE_ISCSI << 4) | submode;
+	} else
+		cxgbi_skcb_ulp_mode(skb) = 0;
 }
 
 int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
