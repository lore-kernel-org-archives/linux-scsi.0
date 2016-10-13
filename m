From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/24] fcoe: correct sending FIP VLAN packets on VLAN 0
Date: Thu, 13 Oct 2016 15:10:59 +0200
Message-ID: <1476364260-12191-24-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752475AbcJMNeD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:34:03 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The FIP VLAN frame consists of an ethernet header followed
by the FIP VLAN frame, so we need to skip the ethernet header
if we want to check the FIP opcode.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9876fca..cf4adaa 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -590,7 +590,8 @@ static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
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

