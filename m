From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 5/6] fcoe: use real dev in case of HW vlan acceleration
Date: Tue, 27 Sep 2011 21:38:13 -0700
Message-ID: <20110928043813.13004.17664.stgit@localhost6.localdomain6>
References: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56002 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1I1Erb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 00:47:31 -0400
In-Reply-To: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Yi Zou <yi.zou@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Use real dev in case it has HW vlan acceleration
support since in this case the real dev would
do needed vlan processing, this way unnecessary
vlan layer processing avoided and it gives
slightly better IOPS with 512B size IOs.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    9 ++++++++-
 drivers/scsi/fcoe/fcoe.h |    1 +
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 5a28940..cd203d7 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -281,6 +281,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	 * use the first one for SPMA */
 	real_dev = (netdev->priv_flags & IFF_802_1Q_VLAN) ?
 		vlan_dev_real_dev(netdev) : netdev;
+	fcoe->realdev = real_dev;
 	rcu_read_lock();
 	for_each_dev_addr(real_dev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
@@ -1540,7 +1541,13 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	skb_reset_network_header(skb);
 	skb->mac_len = elen;
 	skb->protocol = htons(ETH_P_FCOE);
-	skb->dev = fcoe->netdev;
+	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN &&
+	    fcoe->realdev->features & NETIF_F_HW_VLAN_TX) {
+		skb->vlan_tci = VLAN_TAG_PRESENT |
+				vlan_dev_vlan_id(fcoe->netdev);
+		skb->dev = fcoe->realdev;
+	} else
+		skb->dev = fcoe->netdev;
 
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index c4a9399..e4c9afe 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -80,6 +80,7 @@ do {                                                            	\
 struct fcoe_interface {
 	struct list_head   list;
 	struct net_device  *netdev;
+	struct net_device  *realdev;
 	struct packet_type fcoe_packet_type;
 	struct packet_type fip_packet_type;
 	struct fcoe_ctlr   ctlr;

