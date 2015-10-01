From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] [SCSI] fnic: use kzalloc in fnic_fcoe_process_vlan_resp
Date: Thu,  1 Oct 2015 21:59:02 +0200
Message-ID: <1443729543-19362-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This saves a little .text and avoids the sizeof(...) style
inconsistency.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/fnic/fnic_fcs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index bf0bbd42efb5..2d013076bfba 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -415,15 +415,13 @@ static void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct sk_buff *skb)
 			vid = ntohs(((struct fip_vlan_desc *)desc)->fd_vlan);
 			shost_printk(KERN_INFO, fnic->lport->host,
 				  "process_vlan_resp: FIP VLAN %d\n", vid);
-			vlan = kmalloc(sizeof(*vlan),
-							GFP_ATOMIC);
+			vlan = kzalloc(sizeof(*vlan), GFP_ATOMIC);
 			if (!vlan) {
 				/* retry from timer */
 				spin_unlock_irqrestore(&fnic->vlans_lock,
 							flags);
 				goto out;
 			}
-			memset(vlan, 0, sizeof(struct fcoe_vlan));
 			vlan->vid = vid & 0x0fff;
 			vlan->state = FIP_VLAN_AVAIL;
 			list_add_tail(&vlan->list, &fnic->vlans);
-- 
2.1.3
