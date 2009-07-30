From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/22] fcoe: Remove ifdef for NETIF_F_FCOE_CRC and NETIF_F_FSO
Date: Wed, 29 Jul 2009 17:05:26 -0700
Message-ID: <20090730000526.24658.49846.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41555 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbZG3AF0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:26 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Remove the extra ifdef for NETIF_F_FSO and NETIF_F_FCOE_CRC since they are
already defined in the current kernel as in include/linux/netdevice.h.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0306aa9..ad21e87 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -300,20 +300,16 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	if (fc->real_dev->features & NETIF_F_SG)
 		lp->sg_supp = 1;
 
-#ifdef NETIF_F_FCOE_CRC
 	if (netdev->features & NETIF_F_FCOE_CRC) {
 		lp->crc_offload = 1;
 		FCOE_NETDEV_DBG(netdev, "Supports FCCRC offload\n");
 	}
-#endif
-#ifdef NETIF_F_FSO
 	if (netdev->features & NETIF_F_FSO) {
 		lp->seq_offload = 1;
 		lp->lso_max = netdev->gso_max_size;
 		FCOE_NETDEV_DBG(netdev, "Supports LSO for max len 0x%x\n",
 				lp->lso_max);
 	}
-#endif
 	if (netdev->fcoe_ddp_xid) {
 		lp->lro_enabled = 1;
 		lp->lro_xid = netdev->fcoe_ddp_xid;
@@ -1205,7 +1201,6 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		FC_FCOE_ENCAPS_VER(hp, FC_FCOE_VER);
 	hp->fcoe_sof = sof;
 
-#ifdef NETIF_F_FSO
 	/* fcoe lso, mss is in max_payload which is non-zero for FCP data */
 	if (lp->seq_offload && fr_max_payload(fp)) {
 		skb_shinfo(skb)->gso_type = SKB_GSO_FCOE;
@@ -1214,7 +1209,6 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		skb_shinfo(skb)->gso_type = 0;
 		skb_shinfo(skb)->gso_size = 0;
 	}
-#endif
 	/* update tx stats: regardless if LLD fails */
 	stats = fc_lport_get_stats(lp);
 	stats->TxFrames++;

