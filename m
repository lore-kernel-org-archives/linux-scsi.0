From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 22/22] fcoe: removes phys_dev and renames real_dev to netdev.
Date: Wed, 29 Jul 2009 17:05:45 -0700
Message-ID: <20090730000545.24658.40089.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:60014 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbZG3AFp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:45 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

The phys_dev was used only to locate common offload EM instance for all
FCoE instances on a eth devices in function fcoe_em_config, so just updated
fcoe_em_config to look for actual real eth device in locating common offload
EM instance and then no need to store phys_dev in fcoe_softc, so removes
phys_dev from fcoe_softc also.

Renames fcoe_softc real_dev to netdev and updates all its uses to use netdev.

So effectively no functional change, use of single netdev instead phys_dev
and real_dev saves one pointer memory in fcoe_softc, also real_dev used here
was confusing with vlan driver terminology since real_dev in vlan driver is
referred to physical eth device.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   93 ++++++++++++++++++++++++----------------------
 drivers/scsi/fcoe/fcoe.h |    5 +-
 2 files changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ad21e87..757aa28 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -159,7 +159,7 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
  */
 static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
-	skb->dev = fcoe_from_ctlr(fip)->real_dev;
+	skb->dev = fcoe_from_ctlr(fip)->netdev;
 	dev_queue_xmit(skb);
 }
 
@@ -179,8 +179,8 @@ static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new)
 	fc = fcoe_from_ctlr(fip);
 	rtnl_lock();
 	if (!is_zero_ether_addr(old))
-		dev_unicast_delete(fc->real_dev, old);
-	dev_unicast_add(fc->real_dev, new);
+		dev_unicast_delete(fc->netdev, old);
+	dev_unicast_add(fc->netdev, new);
 	rtnl_unlock();
 }
 
@@ -231,12 +231,12 @@ void fcoe_netdev_cleanup(struct fcoe_softc *fc)
 	/* Delete secondary MAC addresses */
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_delete(fc->real_dev, flogi_maddr);
+	dev_unicast_delete(fc->netdev, flogi_maddr);
 	if (!is_zero_ether_addr(fc->ctlr.data_src_addr))
-		dev_unicast_delete(fc->real_dev, fc->ctlr.data_src_addr);
+		dev_unicast_delete(fc->netdev, fc->ctlr.data_src_addr);
 	if (fc->ctlr.spma)
-		dev_unicast_delete(fc->real_dev, fc->ctlr.ctl_src_addr);
-	dev_mc_delete(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+		dev_unicast_delete(fc->netdev, fc->ctlr.ctl_src_addr);
+	dev_mc_delete(fc->netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 }
 
@@ -272,17 +272,12 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	/* Setup lport private data to point to fcoe softc */
 	fc = lport_priv(lp);
 	fc->ctlr.lp = lp;
-	fc->real_dev = netdev;
-	fc->phys_dev = netdev;
-
-	/* Require support for get_pauseparam ethtool op. */
-	if (netdev->priv_flags & IFF_802_1Q_VLAN)
-		fc->phys_dev = vlan_dev_real_dev(netdev);
+	fc->netdev = netdev;
 
 	/* Do not support for bonding device */
-	if ((fc->real_dev->priv_flags & IFF_MASTER_ALB) ||
-	    (fc->real_dev->priv_flags & IFF_SLAVE_INACTIVE) ||
-	    (fc->real_dev->priv_flags & IFF_MASTER_8023AD)) {
+	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
+	    (netdev->priv_flags & IFF_SLAVE_INACTIVE) ||
+	    (netdev->priv_flags & IFF_MASTER_8023AD)) {
 		return -EOPNOTSUPP;
 	}
 
@@ -291,13 +286,13 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	 * user-configured limit.  If the MFS is too low, fcoe_link_ok()
 	 * will return 0, so do this first.
 	 */
-	mfs = fc->real_dev->mtu - (sizeof(struct fcoe_hdr) +
-				   sizeof(struct fcoe_crc_eof));
+	mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
+			     sizeof(struct fcoe_crc_eof));
 	if (fc_set_mfs(lp, mfs))
 		return -EINVAL;
 
 	/* offload features support */
-	if (fc->real_dev->features & NETIF_F_SG)
+	if (netdev->features & NETIF_F_SG)
 		lp->sg_supp = 1;
 
 	if (netdev->features & NETIF_F_FCOE_CRC) {
@@ -335,13 +330,13 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 
 	/* setup Source Mac Address */
 	if (!fc->ctlr.spma)
-		memcpy(fc->ctlr.ctl_src_addr, fc->real_dev->dev_addr,
-		       fc->real_dev->addr_len);
+		memcpy(fc->ctlr.ctl_src_addr, netdev->dev_addr,
+		       fc->netdev->addr_len);
 
-	wwnn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 1, 0);
+	wwnn = fcoe_wwn_from_mac(netdev->dev_addr, 1, 0);
 	fc_set_wwnn(lp, wwnn);
 	/* XXX - 3rd arg needs to be vlan id */
-	wwpn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 2, 0);
+	wwpn = fcoe_wwn_from_mac(netdev->dev_addr, 2, 0);
 	fc_set_wwpn(lp, wwpn);
 
 	/*
@@ -351,10 +346,10 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	 */
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_add(fc->real_dev, flogi_maddr);
+	dev_unicast_add(netdev, flogi_maddr);
 	if (fc->ctlr.spma)
-		dev_unicast_add(fc->real_dev, fc->ctlr.ctl_src_addr);
-	dev_mc_add(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+		dev_unicast_add(netdev, fc->ctlr.ctl_src_addr);
+	dev_mc_add(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 
 	/*
@@ -363,12 +358,12 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	 */
 	fc->fcoe_packet_type.func = fcoe_rcv;
 	fc->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
-	fc->fcoe_packet_type.dev = fc->real_dev;
+	fc->fcoe_packet_type.dev = netdev;
 	dev_add_pack(&fc->fcoe_packet_type);
 
 	fc->fip_packet_type.func = fcoe_fip_recv;
 	fc->fip_packet_type.type = htons(ETH_P_FIP);
-	fc->fip_packet_type.dev = fc->real_dev;
+	fc->fip_packet_type.dev = netdev;
 	dev_add_pack(&fc->fip_packet_type);
 
 	return 0;
@@ -434,6 +429,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 {
 	struct fcoe_softc *fc = lport_priv(lp);
 	struct fcoe_softc *oldfc = NULL;
+	struct net_device *old_real_dev, *cur_real_dev;
 	u16 min_xid = FCOE_MIN_XID;
 	u16 max_xid = FCOE_MAX_XID;
 
@@ -448,10 +444,20 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 
 	/*
 	 * Reuse existing offload em instance in case
-	 * it is already allocated on phys_dev.
+	 * it is already allocated on real eth device
 	 */
+	if (fc->netdev->priv_flags & IFF_802_1Q_VLAN)
+		cur_real_dev = vlan_dev_real_dev(fc->netdev);
+	else
+		cur_real_dev = fc->netdev;
+
 	list_for_each_entry(oldfc, &fcoe_hostlist, list) {
-		if (oldfc->phys_dev == fc->phys_dev) {
+		if (oldfc->netdev->priv_flags & IFF_802_1Q_VLAN)
+			old_real_dev = vlan_dev_real_dev(oldfc->netdev);
+		else
+			old_real_dev = oldfc->netdev;
+
+		if (cur_real_dev == old_real_dev) {
 			fc->oem = oldfc->oem;
 			break;
 		}
@@ -461,7 +467,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 		if (!fc_exch_mgr_add(lp, fc->oem, fcoe_oem_match)) {
 			printk(KERN_ERR "fcoe_em_config: failed to add "
 			       "offload em:%p on interface:%s\n",
-			       fc->oem, fc->real_dev->name);
+			       fc->oem, fc->netdev->name);
 			return -ENOMEM;
 		}
 	} else {
@@ -471,7 +477,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 		if (!fc->oem) {
 			printk(KERN_ERR "fcoe_em_config: failed to allocate "
 			       "em for offload exches on interface:%s\n",
-			       fc->real_dev->name);
+			       fc->netdev->name);
 			return -ENOMEM;
 		}
 	}
@@ -484,7 +490,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 skip_oem:
 	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, min_xid, max_xid, NULL)) {
 		printk(KERN_ERR "fcoe_em_config: failed to "
-		       "allocate em on interface %s\n", fc->real_dev->name);
+		       "allocate em on interface %s\n", fc->netdev->name);
 		return -ENOMEM;
 	}
 
@@ -548,7 +554,7 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	fc_lport_free_stats(lp);
 
 	/* Release the net_device and Scsi_Host */
-	dev_put(fc->real_dev);
+	dev_put(netdev);
 	scsi_host_put(lp->host);
 
 	return 0;
@@ -1179,7 +1185,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	skb_reset_network_header(skb);
 	skb->mac_len = elen;
 	skb->protocol = htons(ETH_P_FCOE);
-	skb->dev = fc->real_dev;
+	skb->dev = fc->netdev;
 
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
@@ -1454,7 +1460,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 				    ulong event, void *ptr)
 {
 	struct fc_lport *lp = NULL;
-	struct net_device *real_dev = ptr;
+	struct net_device *netdev = ptr;
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *stats;
 	u32 link_possible = 1;
@@ -1463,7 +1469,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		if (fc->real_dev == real_dev) {
+		if (fc->netdev == netdev) {
 			lp = fc->ctlr.lp;
 			break;
 		}
@@ -1483,16 +1489,15 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	case NETDEV_CHANGE:
 		break;
 	case NETDEV_CHANGEMTU:
-		mfs = fc->real_dev->mtu -
-			(sizeof(struct fcoe_hdr) +
-			 sizeof(struct fcoe_crc_eof));
+		mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
+				     sizeof(struct fcoe_crc_eof));
 		if (mfs >= FC_MIN_MAX_FRAME)
 			fc_set_mfs(lp, mfs);
 		break;
 	case NETDEV_REGISTER:
 		break;
 	default:
-		FCOE_NETDEV_DBG(real_dev, "Unknown event %ld "
+		FCOE_NETDEV_DBG(netdev, "Unknown event %ld "
 				"from netdev netlink\n", event);
 	}
 	if (link_possible && !fcoe_link_ok(lp))
@@ -1696,7 +1701,7 @@ MODULE_PARM_DESC(destroy, "Destroy fcoe port");
 int fcoe_link_ok(struct fc_lport *lp)
 {
 	struct fcoe_softc *fc = lport_priv(lp);
-	struct net_device *dev = fc->real_dev;
+	struct net_device *dev = fc->netdev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
 	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev) &&
@@ -1797,7 +1802,7 @@ fcoe_hostlist_lookup_softc(const struct net_device *dev)
 	struct fcoe_softc *fc;
 
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		if (fc->real_dev == dev)
+		if (fc->netdev == dev)
 			return fc;
 	}
 	return NULL;
@@ -1916,7 +1921,7 @@ static void __exit fcoe_exit(void)
 
 	/* releases the associated fcoe hosts */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
-		fcoe_if_destroy(fc->real_dev);
+		fcoe_if_destroy(fc->netdev);
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 6905efc..5ae8ca7 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -79,8 +79,7 @@ struct fcoe_percpu_s {
  */
 struct fcoe_softc {
 	struct list_head list;
-	struct net_device *real_dev;
-	struct net_device *phys_dev;		/* device with ethtool_ops */
+	struct net_device *netdev;
 	struct fc_exch_mgr *oem;		/* offload exchange manger */
 	struct packet_type  fcoe_packet_type;
 	struct packet_type  fip_packet_type;
@@ -95,7 +94,7 @@ struct fcoe_softc {
 static inline struct net_device *fcoe_netdev(
 	const struct fc_lport *lp)
 {
-	return ((struct fcoe_softc *)lport_priv(lp))->real_dev;
+	return ((struct fcoe_softc *)lport_priv(lp))->netdev;
 }
 
 #endif /* _FCOE_H_ */

