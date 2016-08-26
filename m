From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/30] fcoe: correct sending FIP VLAN packets on VLAN 0
Date: Fri, 26 Aug 2016 14:01:50 +0200
Message-ID: <1472212913-39810-28-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35223 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751969AbcHZMCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:14 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The FIP VLAN frame consists of an ethernet header followed
by the FIP VLAN frame, so we need to skip the ethernet header
if we want to check the FIP opcode.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 81e7f99..706de91 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -582,7 +582,8 @@ static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	 * Use default VLAN for FIP VLAN discovery protocol
 	 */
 	frame = (struct fip_frame *)skb->data;
-	if (frame->fip.fip_op == ntohs(FIP_OP_VLAN) &&
+	if (ntohs(frame->eth.h_proto) == ETH_P_FIP &&
+	    ntohs(frame->fip.fip_op) == FIP_OP_VLAN &&
 	    fcoe->realdev != fcoe->netdev)
 		skb->dev = fcoe->realdev;
 	else
-- 
1.8.5.6

