From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/19] fcoe: make sure fcoe frames are unshared prior to
 manipulating them
Date: Mon, 21 Oct 2013 11:00:35 -0700
Message-ID: <20131021180035.31563.75430.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3JUSAj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:00:39 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>

From: Neil Horman <nhorman@tuxdriver.com>

Based on my last patch I noticed that fcoe_rcv has a simmilar problem, in that
it manipulates the passed in skb without checking to see if it has other users.
Making manipulations to a shared skb can result in various corruptions.

Easy fix, just make sure the skb is unshared prior to doing anything with it.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 07453bb..f9b0302 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1452,6 +1452,12 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 			skb_tail_pointer(skb), skb_end_pointer(skb),
 			skb->csum, skb->dev ? skb->dev->name : "<NULL>");
 
+
+	skb = skb_share_check(skb, GFP_ATOMIC);
+
+	if (skb == NULL)
+		return NET_RX_DROP;
+
 	eh = eth_hdr(skb);
 
 	if (is_fip_mode(ctlr) &&

