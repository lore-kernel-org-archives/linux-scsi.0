From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/64] fcoe: move FIP controller from fcoe_port to
	fcoe_interface
Date: Tue, 25 Aug 2009 13:59:46 -0700
Message-ID: <20090825205946.1553.99415.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbZHYU7o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:44 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

There is only one FIP state per net_device, so the FIP controller needs to be
moved from the per-SCSI-host fcoe_port to the per-net_device fcoe_interface
structure.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   83 +++++++++++++++++++++-------------------------
 drivers/scsi/fcoe/fcoe.h |    4 +-
 2 files changed, 39 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c215235..01519c7 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -152,11 +152,9 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
 			 struct net_device *orig_dev)
 {
 	struct fcoe_interface *fcoe;
-	struct fcoe_port *port;
 
 	fcoe = container_of(ptype, struct fcoe_interface, fip_packet_type);
-	port = fcoe->priv;
-	fcoe_ctlr_recv(&port->ctlr, skb);
+	fcoe_ctlr_recv(&fcoe->ctlr, skb);
 	return 0;
 }
 
@@ -167,7 +165,7 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
  */
 static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
-	skb->dev = fcoe_from_ctlr(fip)->fcoe->netdev;
+	skb->dev = fcoe_from_ctlr(fip)->netdev;
 	dev_queue_xmit(skb);
 }
 
@@ -183,11 +181,8 @@ static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new)
 {
 	struct fcoe_interface *fcoe;
-	struct fcoe_port *port;
-
-	port = fcoe_from_ctlr(fip);
-	fcoe = port->fcoe;
 
+	fcoe = fcoe_from_ctlr(fip);
 	rtnl_lock();
 	if (!is_zero_ether_addr(old))
 		dev_unicast_delete(fcoe->netdev, old);
@@ -244,10 +239,10 @@ void fcoe_netdev_cleanup(struct fcoe_port *port)
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_delete(fcoe->netdev, flogi_maddr);
-	if (!is_zero_ether_addr(port->ctlr.data_src_addr))
-		dev_unicast_delete(fcoe->netdev, port->ctlr.data_src_addr);
-	if (port->ctlr.spma)
-		dev_unicast_delete(fcoe->netdev, port->ctlr.ctl_src_addr);
+	if (!is_zero_ether_addr(fcoe->ctlr.data_src_addr))
+		dev_unicast_delete(fcoe->netdev, fcoe->ctlr.data_src_addr);
+	if (fcoe->ctlr.spma)
+		dev_unicast_delete(fcoe->netdev, fcoe->ctlr.ctl_src_addr);
 	dev_mc_delete(fcoe->netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 }
@@ -285,7 +280,7 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lp);
 	fcoe = port->fcoe;
-	port->ctlr.lp = lp;
+	fcoe->ctlr.lp = lp;
 	fcoe->netdev = netdev;
 
 	/* Do not support for bonding device */
@@ -334,17 +329,17 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	rcu_read_lock();
 	for_each_dev_addr(netdev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
-		    (is_valid_ether_addr(port->ctlr.ctl_src_addr))) {
-			memcpy(port->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
-			port->ctlr.spma = 1;
+		    (is_valid_ether_addr(fcoe->ctlr.ctl_src_addr))) {
+			memcpy(fcoe->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
+			fcoe->ctlr.spma = 1;
 			break;
 		}
 	}
 	rcu_read_unlock();
 
 	/* setup Source Mac Address */
-	if (!port->ctlr.spma)
-		memcpy(port->ctlr.ctl_src_addr, netdev->dev_addr,
+	if (!fcoe->ctlr.spma)
+		memcpy(fcoe->ctlr.ctl_src_addr, netdev->dev_addr,
 		       netdev->addr_len);
 
 	wwnn = fcoe_wwn_from_mac(netdev->dev_addr, 1, 0);
@@ -361,8 +356,8 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_add(netdev, flogi_maddr);
-	if (port->ctlr.spma)
-		dev_unicast_add(netdev, port->ctlr.ctl_src_addr);
+	if (fcoe->ctlr.spma)
+		dev_unicast_add(netdev, fcoe->ctlr.ctl_src_addr);
 	dev_mc_add(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 
@@ -537,7 +532,7 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	fcoe_netdev_cleanup(port);
 
 	/* tear-down the FCoE controller */
-	fcoe_ctlr_destroy(&port->ctlr);
+	fcoe_ctlr_destroy(&fcoe->ctlr);
 
 	/* Free queued packets for the per-CPU receive threads */
 	fcoe_percpu_clean(lport);
@@ -662,9 +657,9 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 	/*
 	 * Initialize FIP.
 	 */
-	fcoe_ctlr_init(&port->ctlr);
-	port->ctlr.send = fcoe_fip_send;
-	port->ctlr.update_mac = fcoe_update_src_mac;
+	fcoe_ctlr_init(&fcoe->ctlr);
+	fcoe->ctlr.send = fcoe_fip_send;
+	fcoe->ctlr.update_mac = fcoe_update_src_mac;
 
 	/* configure lport network properties */
 	rc = fcoe_netdev_config(lport, netdev);
@@ -714,7 +709,7 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 	fc_fabric_login(lport);
 
 	if (!fcoe_link_ok(lport))
-		fcoe_ctlr_link_up(&port->ctlr);
+		fcoe_ctlr_link_up(&fcoe->ctlr);
 
 	dev_hold(netdev);
 
@@ -929,14 +924,12 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fc_lport *lp;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_interface *fcoe;
-	struct fcoe_port *port;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
 	unsigned int cpu;
 
 	fcoe = container_of(ptype, struct fcoe_interface, fcoe_packet_type);
-	port = fcoe->priv;
-	lp = port->ctlr.lp;
+	lp = fcoe->ctlr.lp;
 	if (unlikely(lp == NULL)) {
 		FCOE_NETDEV_DBG(dev, "Cannot find hba structure");
 		goto err2;
@@ -1137,13 +1130,13 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	unsigned int hlen;		/* header length implies the version */
 	unsigned int tlen;		/* trailer length */
 	unsigned int elen;		/* eth header, may include vlan */
-	struct fcoe_port *port;
+	struct fcoe_port *port = lport_priv(lp);
+	struct fcoe_interface *fcoe = port->fcoe;
 	u8 sof, eof;
 	struct fcoe_hdr *hp;
 
 	WARN_ON((fr_len(fp) % sizeof(u32)) != 0);
 
-	port = lport_priv(lp);
 	fh = fc_frame_header_get(fp);
 	skb = fp_skb(fp);
 	wlen = skb->len / FCOE_WORD_TO_BYTE;
@@ -1154,7 +1147,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	}
 
 	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ) &&
-	    fcoe_ctlr_els_send(&port->ctlr, skb))
+	    fcoe_ctlr_els_send(&fcoe->ctlr, skb))
 		return 0;
 
 	sof = fr_sof(fp);
@@ -1205,21 +1198,21 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	skb_reset_network_header(skb);
 	skb->mac_len = elen;
 	skb->protocol = htons(ETH_P_FCOE);
-	skb->dev = port->fcoe->netdev;
+	skb->dev = fcoe->netdev;
 
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
 	eh->h_proto = htons(ETH_P_FCOE);
-	if (port->ctlr.map_dest)
+	if (fcoe->ctlr.map_dest)
 		fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
 	else
 		/* insert GW address */
-		memcpy(eh->h_dest, port->ctlr.dest_addr, ETH_ALEN);
+		memcpy(eh->h_dest, fcoe->ctlr.dest_addr, ETH_ALEN);
 
-	if (unlikely(port->ctlr.flogi_oxid != FC_XID_UNKNOWN))
-		memcpy(eh->h_source, port->ctlr.ctl_src_addr, ETH_ALEN);
+	if (unlikely(fcoe->ctlr.flogi_oxid != FC_XID_UNKNOWN))
+		memcpy(eh->h_source, fcoe->ctlr.ctl_src_addr, ETH_ALEN);
 	else
-		memcpy(eh->h_source, port->ctlr.data_src_addr, ETH_ALEN);
+		memcpy(eh->h_source, fcoe->ctlr.data_src_addr, ETH_ALEN);
 
 	hp = (struct fcoe_hdr *)(eh + 1);
 	memset(hp, 0, sizeof(*hp));
@@ -1382,8 +1375,8 @@ int fcoe_percpu_receive_thread(void *arg)
 			}
 			fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 		}
-		if (unlikely(port->ctlr.flogi_oxid != FC_XID_UNKNOWN) &&
-		    fcoe_ctlr_recv_flogi(&port->ctlr, fp, mac)) {
+		if (unlikely(port->fcoe->ctlr.flogi_oxid != FC_XID_UNKNOWN) &&
+		    fcoe_ctlr_recv_flogi(&port->fcoe->ctlr, fp, mac)) {
 			fc_frame_free(fp);
 			continue;
 		}
@@ -1482,7 +1475,6 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	struct fc_lport *lp = NULL;
 	struct net_device *netdev = ptr;
 	struct fcoe_interface *fcoe;
-	struct fcoe_port *port = NULL;
 	struct fcoe_dev_stats *stats;
 	u32 link_possible = 1;
 	u32 mfs;
@@ -1490,9 +1482,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
-		port = fcoe->priv;
 		if (fcoe->netdev == netdev) {
-			lp = port->ctlr.lp;
+			lp = fcoe->ctlr.lp;
 			break;
 		}
 	}
@@ -1523,8 +1514,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 				"from netdev netlink\n", event);
 	}
 	if (link_possible && !fcoe_link_ok(lp))
-		fcoe_ctlr_link_up(&port->ctlr);
-	else if (fcoe_ctlr_link_down(&port->ctlr)) {
+		fcoe_ctlr_link_up(&fcoe->ctlr);
+	else if (fcoe_ctlr_link_down(&fcoe->ctlr)) {
 		stats = fc_lport_get_stats(lp);
 		stats->LinkFailureCount++;
 		fcoe_clean_pending_queue(lp);
@@ -1841,7 +1832,7 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	read_unlock(&fcoe_hostlist_lock);
 
-	return (fcoe) ? fcoe->priv->ctlr.lp : NULL;
+	return (fcoe) ? fcoe->ctlr.lp : NULL;
 }
 
 /**
@@ -1941,7 +1932,7 @@ static void __exit fcoe_exit(void)
 
 	/* releases the associated fcoe hosts */
 	list_for_each_entry_safe(fcoe, tmp, &fcoe_hostlist, list)
-		fcoe_if_destroy(fcoe->priv->ctlr.lp);
+		fcoe_if_destroy(fcoe->ctlr.lp);
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 685aa9d..5b190b5 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -85,6 +85,7 @@ struct fcoe_interface {
 	struct net_device *netdev;
 	struct packet_type  fcoe_packet_type;
 	struct packet_type  fip_packet_type;
+	struct fcoe_ctlr ctlr;
 };
 
 /*
@@ -97,10 +98,9 @@ struct fcoe_port {
 	struct sk_buff_head fcoe_pending_queue;
 	u8	fcoe_pending_queue_active;
 	struct timer_list timer;		/* queue timer */
-	struct fcoe_ctlr ctlr;
 };
 
-#define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_port, ctlr)
+#define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)
 
 static inline struct net_device *fcoe_netdev(const struct fc_lport *lp)
 {

