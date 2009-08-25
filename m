From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/64] fcoe: move netdev to fcoe_interface
Date: Tue, 25 Aug 2009 13:59:35 -0700
Message-ID: <20090825205935.1553.86574.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54975 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbZHYU7q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:46 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

The network interface needs to be shared between all NPIV VN_Ports, therefor
it should be tracked in the fcoe_interface and not for each SCSI host in
fcoe_port.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   61 ++++++++++++++++++++++++++--------------------
 drivers/scsi/fcoe/fcoe.h |    9 +++----
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0ae54b2..44c963c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -165,7 +165,7 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
  */
 static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
-	skb->dev = fcoe_from_ctlr(fip)->netdev;
+	skb->dev = fcoe_from_ctlr(fip)->fcoe->netdev;
 	dev_queue_xmit(skb);
 }
 
@@ -180,13 +180,16 @@ static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
  */
 static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new)
 {
+	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
 
 	port = fcoe_from_ctlr(fip);
+	fcoe = port->fcoe;
+
 	rtnl_lock();
 	if (!is_zero_ether_addr(old))
-		dev_unicast_delete(port->netdev, old);
-	dev_unicast_add(port->netdev, new);
+		dev_unicast_delete(fcoe->netdev, old);
+	dev_unicast_add(fcoe->netdev, new);
 	rtnl_unlock();
 }
 
@@ -229,6 +232,7 @@ static int fcoe_lport_config(struct fc_lport *lp)
 void fcoe_netdev_cleanup(struct fcoe_port *port)
 {
 	u8 flogi_maddr[ETH_ALEN];
+	struct fcoe_interface *fcoe = port->fcoe;
 
 	/* Don't listen for Ethernet packets anymore */
 	dev_remove_pack(&port->fcoe_packet_type);
@@ -237,12 +241,12 @@ void fcoe_netdev_cleanup(struct fcoe_port *port)
 	/* Delete secondary MAC addresses */
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_delete(port->netdev, flogi_maddr);
+	dev_unicast_delete(fcoe->netdev, flogi_maddr);
 	if (!is_zero_ether_addr(port->ctlr.data_src_addr))
-		dev_unicast_delete(port->netdev, port->ctlr.data_src_addr);
+		dev_unicast_delete(fcoe->netdev, port->ctlr.data_src_addr);
 	if (port->ctlr.spma)
-		dev_unicast_delete(port->netdev, port->ctlr.ctl_src_addr);
-	dev_mc_delete(port->netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+		dev_unicast_delete(fcoe->netdev, port->ctlr.ctl_src_addr);
+	dev_mc_delete(fcoe->netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 }
 
@@ -271,14 +275,16 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 {
 	u32 mfs;
 	u64 wwnn, wwpn;
+	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
 	u8 flogi_maddr[ETH_ALEN];
 	struct netdev_hw_addr *ha;
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lp);
+	fcoe = port->fcoe;
 	port->ctlr.lp = lp;
-	port->netdev = netdev;
+	fcoe->netdev = netdev;
 
 	/* Do not support for bonding device */
 	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
@@ -434,9 +440,10 @@ bool fcoe_oem_match(struct fc_frame *fp)
  */
 static inline int fcoe_em_config(struct fc_lport *lp)
 {
-	struct fcoe_interface *fcoe;
 	struct fcoe_port *port = lport_priv(lp);
-	struct fcoe_port *oldfc = NULL;
+	struct fcoe_port *oldport = NULL;
+	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *oldfcoe = NULL;
 	struct net_device *old_real_dev, *cur_real_dev;
 	u16 min_xid = FCOE_MIN_XID;
 	u16 max_xid = FCOE_MAX_XID;
@@ -454,20 +461,20 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 	 * Reuse existing offload em instance in case
 	 * it is already allocated on real eth device
 	 */
-	if (port->netdev->priv_flags & IFF_802_1Q_VLAN)
-		cur_real_dev = vlan_dev_real_dev(port->netdev);
+	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN)
+		cur_real_dev = vlan_dev_real_dev(fcoe->netdev);
 	else
-		cur_real_dev = port->netdev;
+		cur_real_dev = fcoe->netdev;
 
-	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
-		oldfc = fcoe->priv;
-		if (oldfc->netdev->priv_flags & IFF_802_1Q_VLAN)
-			old_real_dev = vlan_dev_real_dev(oldfc->netdev);
+	list_for_each_entry(oldfcoe, &fcoe_hostlist, list) {
+		oldport = oldfcoe->priv;
+		if (oldfcoe->netdev->priv_flags & IFF_802_1Q_VLAN)
+			old_real_dev = vlan_dev_real_dev(oldfcoe->netdev);
 		else
-			old_real_dev = oldfc->netdev;
+			old_real_dev = oldfcoe->netdev;
 
 		if (cur_real_dev == old_real_dev) {
-			port->oem = oldfc->oem;
+			port->oem = oldport->oem;
 			break;
 		}
 	}
@@ -476,7 +483,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 		if (!fc_exch_mgr_add(lp, port->oem, fcoe_oem_match)) {
 			printk(KERN_ERR "fcoe_em_config: failed to add "
 			       "offload em:%p on interface:%s\n",
-			       port->oem, port->netdev->name);
+			       port->oem, fcoe->netdev->name);
 			return -ENOMEM;
 		}
 	} else {
@@ -486,7 +493,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 		if (!port->oem) {
 			printk(KERN_ERR "fcoe_em_config: failed to allocate "
 			       "em for offload exches on interface:%s\n",
-			       port->netdev->name);
+			       fcoe->netdev->name);
 			return -ENOMEM;
 		}
 	}
@@ -499,7 +506,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 skip_oem:
 	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, min_xid, max_xid, NULL)) {
 		printk(KERN_ERR "fcoe_em_config: failed to "
-		       "allocate em on interface %s\n", port->netdev->name);
+		       "allocate em on interface %s\n", fcoe->netdev->name);
 		return -ENOMEM;
 	}
 
@@ -514,7 +521,7 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
 	struct fcoe_interface *fcoe = port->fcoe;
-	struct net_device *netdev = port->netdev;
+	struct net_device *netdev = fcoe->netdev;
 
 	FCOE_NETDEV_DBG(netdev, "Destroying interface\n");
 
@@ -1194,7 +1201,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	skb_reset_network_header(skb);
 	skb->mac_len = elen;
 	skb->protocol = htons(ETH_P_FCOE);
-	skb->dev = port->netdev;
+	skb->dev = port->fcoe->netdev;
 
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
@@ -1480,7 +1487,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
 		port = fcoe->priv;
-		if (port->netdev == netdev) {
+		if (fcoe->netdev == netdev) {
 			lp = port->ctlr.lp;
 			break;
 		}
@@ -1709,7 +1716,7 @@ MODULE_PARM_DESC(destroy, "Destroy fcoe fcoe");
 int fcoe_link_ok(struct fc_lport *lp)
 {
 	struct fcoe_port *port = lport_priv(lp);
-	struct net_device *dev = port->netdev;
+	struct net_device *dev = port->fcoe->netdev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
 	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev) &&
@@ -1810,7 +1817,7 @@ fcoe_hostlist_lookup_port(const struct net_device *dev)
 	struct fcoe_interface *fcoe;
 
 	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
-		if (fcoe->priv->netdev == dev)
+		if (fcoe->netdev == dev)
 			return fcoe;
 	}
 	return NULL;
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 060a6dc..3b3886e 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -82,6 +82,7 @@ struct fcoe_interface {
 	/* This will be removed once all the shared values are
 	 * moved out of fcoe_port */
 	struct fcoe_port *priv;
+	struct net_device *netdev;
 };
 
 /*
@@ -90,7 +91,6 @@ struct fcoe_interface {
  */
 struct fcoe_port {
 	struct fcoe_interface *fcoe;
-	struct net_device *netdev;
 	struct fc_exch_mgr *oem;		/* offload exchange manger */
 	struct packet_type  fcoe_packet_type;
 	struct packet_type  fip_packet_type;
@@ -100,12 +100,11 @@ struct fcoe_port {
 	struct fcoe_ctlr ctlr;
 };
 
-#define fcoe_from_ctlr(port) container_of(port, struct fcoe_port, ctlr)
+#define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_port, ctlr)
 
-static inline struct net_device *fcoe_netdev(
-	const struct fc_lport *lp)
+static inline struct net_device *fcoe_netdev(const struct fc_lport *lp)
 {
-	return ((struct fcoe_port *)lport_priv(lp))->netdev;
+	return ((struct fcoe_port *)lport_priv(lp))->fcoe->netdev;
 }
 
 #endif /* _FCOE_H_ */

