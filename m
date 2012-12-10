From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 02/10] fnic: fix for trusted cos
Date: Mon, 10 Dec 2012 01:21:30 -0800
Message-ID: <1355131299-3313-2-git-send-email-hiralpat@cisco.com>
References: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-4.cisco.com ([173.36.130.15]:5876 "EHLO
	mtv-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2LJJ0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Dec 2012 04:26:23 -0500
In-Reply-To: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>, Narsimhulu Musini <nmusini@cisco.com>

Modified fnic driver to let hardware insert the COS value. Set bit
in descriptor to 0 telling hardware to use its lif COS configurations
to insert the COS value in the frames.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_fcs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 3c53c34..483eb9d 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -495,7 +495,8 @@ void fnic_eth_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	}
 
 	fnic_queue_wq_eth_desc(wq, skb, pa, skb->len,
-			       fnic->vlan_hw_insert, fnic->vlan_id, 1);
+			       0 /* hw inserts cos value */,
+			       fnic->vlan_id, 1);
 	spin_unlock_irqrestore(&fnic->wq_lock[0], flags);
 }
 
@@ -563,7 +564,8 @@ static int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
 	}
 
 	fnic_queue_wq_desc(wq, skb, pa, tot_len, fr_eof(fp),
-			   fnic->vlan_hw_insert, fnic->vlan_id, 1, 1, 1);
+			   0 /* hw inserts cos value */,
+			   fnic->vlan_id, 1, 1, 1);
 fnic_send_frame_end:
 	spin_unlock_irqrestore(&fnic->wq_lock[0], flags);
 
-- 
1.7.9.5

