From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] scsi: fnic: use kzalloc in fnic_fcoe_process_vlan_resp
Date: Tue,  9 Jan 2018 00:11:15 +0100
Message-ID: <20180108231115.17459-1-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This saves a little .text and gets rid of the unmotivated line break and
the sizeof(...) style inconsistency.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/fnic/fnic_fcs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 999fc7547560..c7bf316d8e83 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -442,15 +442,13 @@ static void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct sk_buff *skb)
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
2.15.1
