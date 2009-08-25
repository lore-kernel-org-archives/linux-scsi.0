From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/64] fcoe: Introduce and allocate fcoe_interface structure,
	1:1 with net_device
Date: Tue, 25 Aug 2009 13:59:30 -0700
Message-ID: <20090825205929.1553.18833.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22999 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbZHYU72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:28 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

In preparation for NPIV support, I'm splitting the fcoe instance structure
into two to remove the assumptions about it being 1:1 with the net_device.
There will now be two structures, one which is 1:1 with the underlying
net_device and one which is allocated per virtual SCSI/FC host.

fcoe_softc is renamed to fcoe_port for the per Scsi_Host FCoE private data.

Later patches with start moving shared stuff from fcoe_port to fcoe_interface

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |  326 ++++++++++++++++++++++++----------------------
 drivers/scsi/fcoe/fcoe.h |   19 ++-
 2 files changed, 188 insertions(+), 157 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 7492796..0ae54b2 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -151,10 +151,10 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
 			 struct packet_type *ptype,
 			 struct net_device *orig_dev)
 {
-	struct fcoe_softc *fc;
+	struct fcoe_port *port;
 
-	fc = container_of(ptype, struct fcoe_softc, fip_packet_type);
-	fcoe_ctlr_recv(&fc->ctlr, skb);
+	port = container_of(ptype, struct fcoe_port, fip_packet_type);
+	fcoe_ctlr_recv(&port->ctlr, skb);
 	return 0;
 }
 
@@ -180,13 +180,13 @@ static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
  */
 static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new)
 {
-	struct fcoe_softc *fc;
+	struct fcoe_port *port;
 
-	fc = fcoe_from_ctlr(fip);
+	port = fcoe_from_ctlr(fip);
 	rtnl_lock();
 	if (!is_zero_ether_addr(old))
-		dev_unicast_delete(fc->netdev, old);
-	dev_unicast_add(fc->netdev, new);
+		dev_unicast_delete(port->netdev, old);
+	dev_unicast_add(port->netdev, new);
 	rtnl_unlock();
 }
 
@@ -224,25 +224,25 @@ static int fcoe_lport_config(struct fc_lport *lp)
 
 /**
  * fcoe_netdev_cleanup() - clean up netdev configurations
- * @fc: ptr to the fcoe_softc
+ * @port: ptr to the fcoe_port
  */
-void fcoe_netdev_cleanup(struct fcoe_softc *fc)
+void fcoe_netdev_cleanup(struct fcoe_port *port)
 {
 	u8 flogi_maddr[ETH_ALEN];
 
 	/* Don't listen for Ethernet packets anymore */
-	dev_remove_pack(&fc->fcoe_packet_type);
-	dev_remove_pack(&fc->fip_packet_type);
+	dev_remove_pack(&port->fcoe_packet_type);
+	dev_remove_pack(&port->fip_packet_type);
 
 	/* Delete secondary MAC addresses */
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_delete(fc->netdev, flogi_maddr);
-	if (!is_zero_ether_addr(fc->ctlr.data_src_addr))
-		dev_unicast_delete(fc->netdev, fc->ctlr.data_src_addr);
-	if (fc->ctlr.spma)
-		dev_unicast_delete(fc->netdev, fc->ctlr.ctl_src_addr);
-	dev_mc_delete(fc->netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+	dev_unicast_delete(port->netdev, flogi_maddr);
+	if (!is_zero_ether_addr(port->ctlr.data_src_addr))
+		dev_unicast_delete(port->netdev, port->ctlr.data_src_addr);
+	if (port->ctlr.spma)
+		dev_unicast_delete(port->netdev, port->ctlr.ctl_src_addr);
+	dev_mc_delete(port->netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 }
 
@@ -271,14 +271,14 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 {
 	u32 mfs;
 	u64 wwnn, wwpn;
-	struct fcoe_softc *fc;
+	struct fcoe_port *port;
 	u8 flogi_maddr[ETH_ALEN];
 	struct netdev_hw_addr *ha;
 
 	/* Setup lport private data to point to fcoe softc */
-	fc = lport_priv(lp);
-	fc->ctlr.lp = lp;
-	fc->netdev = netdev;
+	port = lport_priv(lp);
+	port->ctlr.lp = lp;
+	port->netdev = netdev;
 
 	/* Do not support for bonding device */
 	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
@@ -317,27 +317,27 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 		FCOE_NETDEV_DBG(netdev, "Supports LRO for max xid 0x%x\n",
 				lp->lro_xid);
 	}
-	skb_queue_head_init(&fc->fcoe_pending_queue);
-	fc->fcoe_pending_queue_active = 0;
-	setup_timer(&fc->timer, fcoe_queue_timer, (unsigned long)lp);
+	skb_queue_head_init(&port->fcoe_pending_queue);
+	port->fcoe_pending_queue_active = 0;
+	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lp);
 
 	/* look for SAN MAC address, if multiple SAN MACs exist, only
 	 * use the first one for SPMA */
 	rcu_read_lock();
 	for_each_dev_addr(netdev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
-		    (is_valid_ether_addr(ha->addr))) {
-			memcpy(fc->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
-			fc->ctlr.spma = 1;
+		    (is_valid_ether_addr(port->ctlr.ctl_src_addr))) {
+			memcpy(port->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
+			port->ctlr.spma = 1;
 			break;
 		}
 	}
 	rcu_read_unlock();
 
 	/* setup Source Mac Address */
-	if (!fc->ctlr.spma)
-		memcpy(fc->ctlr.ctl_src_addr, netdev->dev_addr,
-		       fc->netdev->addr_len);
+	if (!port->ctlr.spma)
+		memcpy(port->ctlr.ctl_src_addr, netdev->dev_addr,
+		       netdev->addr_len);
 
 	wwnn = fcoe_wwn_from_mac(netdev->dev_addr, 1, 0);
 	fc_set_wwnn(lp, wwnn);
@@ -353,8 +353,8 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_add(netdev, flogi_maddr);
-	if (fc->ctlr.spma)
-		dev_unicast_add(netdev, fc->ctlr.ctl_src_addr);
+	if (port->ctlr.spma)
+		dev_unicast_add(netdev, port->ctlr.ctl_src_addr);
 	dev_mc_add(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 
@@ -362,15 +362,15 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	 * setup the receive function from ethernet driver
 	 * on the ethertype for the given device
 	 */
-	fc->fcoe_packet_type.func = fcoe_rcv;
-	fc->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
-	fc->fcoe_packet_type.dev = netdev;
-	dev_add_pack(&fc->fcoe_packet_type);
+	port->fcoe_packet_type.func = fcoe_rcv;
+	port->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	port->fcoe_packet_type.dev = netdev;
+	dev_add_pack(&port->fcoe_packet_type);
 
-	fc->fip_packet_type.func = fcoe_fip_recv;
-	fc->fip_packet_type.type = htons(ETH_P_FIP);
-	fc->fip_packet_type.dev = netdev;
-	dev_add_pack(&fc->fip_packet_type);
+	port->fip_packet_type.func = fcoe_fip_recv;
+	port->fip_packet_type.type = htons(ETH_P_FIP);
+	port->fip_packet_type.dev = netdev;
+	dev_add_pack(&port->fip_packet_type);
 
 	return 0;
 }
@@ -426,7 +426,7 @@ bool fcoe_oem_match(struct fc_frame *fp)
 
 /**
  * fcoe_em_config() - allocates em for this lport
- * @lp: the port that em is to allocated for
+ * @lp: the fcoe that em is to allocated for
  *
  * Called with write fcoe_hostlist_lock held.
  *
@@ -434,8 +434,9 @@ bool fcoe_oem_match(struct fc_frame *fp)
  */
 static inline int fcoe_em_config(struct fc_lport *lp)
 {
-	struct fcoe_softc *fc = lport_priv(lp);
-	struct fcoe_softc *oldfc = NULL;
+	struct fcoe_interface *fcoe;
+	struct fcoe_port *port = lport_priv(lp);
+	struct fcoe_port *oldfc = NULL;
 	struct net_device *old_real_dev, *cur_real_dev;
 	u16 min_xid = FCOE_MIN_XID;
 	u16 max_xid = FCOE_MAX_XID;
@@ -453,38 +454,39 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 	 * Reuse existing offload em instance in case
 	 * it is already allocated on real eth device
 	 */
-	if (fc->netdev->priv_flags & IFF_802_1Q_VLAN)
-		cur_real_dev = vlan_dev_real_dev(fc->netdev);
+	if (port->netdev->priv_flags & IFF_802_1Q_VLAN)
+		cur_real_dev = vlan_dev_real_dev(port->netdev);
 	else
-		cur_real_dev = fc->netdev;
+		cur_real_dev = port->netdev;
 
-	list_for_each_entry(oldfc, &fcoe_hostlist, list) {
+	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
+		oldfc = fcoe->priv;
 		if (oldfc->netdev->priv_flags & IFF_802_1Q_VLAN)
 			old_real_dev = vlan_dev_real_dev(oldfc->netdev);
 		else
 			old_real_dev = oldfc->netdev;
 
 		if (cur_real_dev == old_real_dev) {
-			fc->oem = oldfc->oem;
+			port->oem = oldfc->oem;
 			break;
 		}
 	}
 
-	if (fc->oem) {
-		if (!fc_exch_mgr_add(lp, fc->oem, fcoe_oem_match)) {
+	if (port->oem) {
+		if (!fc_exch_mgr_add(lp, port->oem, fcoe_oem_match)) {
 			printk(KERN_ERR "fcoe_em_config: failed to add "
 			       "offload em:%p on interface:%s\n",
-			       fc->oem, fc->netdev->name);
+			       port->oem, port->netdev->name);
 			return -ENOMEM;
 		}
 	} else {
-		fc->oem = fc_exch_mgr_alloc(lp, FC_CLASS_3,
+		port->oem = fc_exch_mgr_alloc(lp, FC_CLASS_3,
 					    FCOE_MIN_XID, lp->lro_xid,
 					    fcoe_oem_match);
-		if (!fc->oem) {
+		if (!port->oem) {
 			printk(KERN_ERR "fcoe_em_config: failed to allocate "
 			       "em for offload exches on interface:%s\n",
-			       fc->netdev->name);
+			       port->netdev->name);
 			return -ENOMEM;
 		}
 	}
@@ -497,7 +499,7 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 skip_oem:
 	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, min_xid, max_xid, NULL)) {
 		printk(KERN_ERR "fcoe_em_config: failed to "
-		       "allocate em on interface %s\n", fc->netdev->name);
+		       "allocate em on interface %s\n", port->netdev->name);
 		return -ENOMEM;
 	}
 
@@ -510,8 +512,9 @@ skip_oem:
  */
 static void fcoe_if_destroy(struct fc_lport *lport)
 {
-	struct fcoe_softc *fc = lport_priv(lport);
-	struct net_device *netdev = fc->netdev;
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+	struct net_device *netdev = port->netdev;
 
 	FCOE_NETDEV_DBG(netdev, "Destroying interface\n");
 
@@ -522,10 +525,10 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	fcoe_hostlist_remove(lport);
 
 	/* clean up netdev configurations */
-	fcoe_netdev_cleanup(fc);
+	fcoe_netdev_cleanup(port);
 
 	/* tear-down the FCoE controller */
-	fcoe_ctlr_destroy(&fc->ctlr);
+	fcoe_ctlr_destroy(&port->ctlr);
 
 	/* Free queued packets for the per-CPU receive threads */
 	fcoe_percpu_clean(lport);
@@ -545,7 +548,7 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	fcoe_clean_pending_queue(lport);
 
 	/* Stop the timer */
-	del_timer_sync(&fc->timer);
+	del_timer_sync(&port->timer);
 
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
@@ -553,6 +556,7 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Release the net_device and Scsi_Host */
 	dev_put(netdev);
 	scsi_host_put(lport->host);
+	kfree(fcoe);		/* TODO, should be refcounted */
 }
 
 /*
@@ -612,20 +616,31 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 {
 	int rc;
 	struct fc_lport *lport = NULL;
-	struct fcoe_softc *fc;
+	struct fcoe_port *port;
+	struct fcoe_interface *fcoe;
 	struct Scsi_Host *shost;
 
 	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
+	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
+	if (!fcoe) {
+		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	shost = libfc_host_alloc(&fcoe_shost_template,
-				 sizeof(struct fcoe_softc));
+				 sizeof(struct fcoe_port));
 	if (!shost) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
 		rc = -ENOMEM;
-		goto out;
+		goto out_kfree_port;
 	}
 	lport = shost_priv(shost);
-	fc = lport_priv(lport);
+	port = lport_priv(lport);
+
+	port->fcoe = fcoe;
+	fcoe->priv = port;
 
 	/* configure fc_lport, e.g., em */
 	rc = fcoe_lport_config(lport);
@@ -638,9 +653,9 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 	/*
 	 * Initialize FIP.
 	 */
-	fcoe_ctlr_init(&fc->ctlr);
-	fc->ctlr.send = fcoe_fip_send;
-	fc->ctlr.update_mac = fcoe_update_src_mac;
+	fcoe_ctlr_init(&port->ctlr);
+	port->ctlr.send = fcoe_fip_send;
+	port->ctlr.update_mac = fcoe_update_src_mac;
 
 	/* configure lport network properties */
 	rc = fcoe_netdev_config(lport, netdev);
@@ -690,7 +705,7 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 	fc_fabric_login(lport);
 
 	if (!fcoe_link_ok(lport))
-		fcoe_ctlr_link_up(&fc->ctlr);
+		fcoe_ctlr_link_up(&port->ctlr);
 
 	dev_hold(netdev);
 
@@ -699,9 +714,11 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 out_lp_destroy:
 	fc_exch_mgr_free(lport);
 out_netdev_cleanup:
-	fcoe_netdev_cleanup(fc);
+	fcoe_netdev_cleanup(port);
 out_host_put:
 	scsi_host_put(lport->host);
+out_kfree_port:
+	kfree(fcoe);
 out:
 	return ERR_PTR(rc);
 }
@@ -902,13 +919,13 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct fc_lport *lp;
 	struct fcoe_rcv_info *fr;
-	struct fcoe_softc *fc;
+	struct fcoe_port *port;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
 	unsigned int cpu;
 
-	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
-	lp = fc->ctlr.lp;
+	port = container_of(ptype, struct fcoe_port, fcoe_packet_type);
+	lp = port->ctlr.lp;
 	if (unlikely(lp == NULL)) {
 		FCOE_NETDEV_DBG(dev, "Cannot find hba structure");
 		goto err2;
@@ -1059,7 +1076,7 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
  * fcoe_fc_crc() - calculates FC CRC in this fcoe skb
  * @fp: the fc_frame containing data to be checksummed
  *
- * This uses crc32() to calculate the crc for fc frame
+ * This uses crc32() to calculate the crc for port frame
  * Return   : 32 bit crc
  */
 u32 fcoe_fc_crc(struct fc_frame *fp)
@@ -1092,7 +1109,7 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 
 /**
  * fcoe_xmit() - FCoE frame transmit function
- * @lp:	the associated local port
+ * @lp:	the associated local fcoe
  * @fp: the fc_frame to be transmitted
  *
  * Return   : 0 for success
@@ -1109,13 +1126,13 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	unsigned int hlen;		/* header length implies the version */
 	unsigned int tlen;		/* trailer length */
 	unsigned int elen;		/* eth header, may include vlan */
-	struct fcoe_softc *fc;
+	struct fcoe_port *port;
 	u8 sof, eof;
 	struct fcoe_hdr *hp;
 
 	WARN_ON((fr_len(fp) % sizeof(u32)) != 0);
 
-	fc = lport_priv(lp);
+	port = lport_priv(lp);
 	fh = fc_frame_header_get(fp);
 	skb = fp_skb(fp);
 	wlen = skb->len / FCOE_WORD_TO_BYTE;
@@ -1126,7 +1143,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	}
 
 	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ) &&
-	    fcoe_ctlr_els_send(&fc->ctlr, skb))
+	    fcoe_ctlr_els_send(&port->ctlr, skb))
 		return 0;
 
 	sof = fr_sof(fp);
@@ -1148,7 +1165,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		crc = fcoe_fc_crc(fp);
 	}
 
-	/* copy fc crc and eof to the skb buff */
+	/* copy port crc and eof to the skb buff */
 	if (skb_is_nonlinear(skb)) {
 		skb_frag_t *frag;
 		if (fcoe_get_paged_crc_eof(skb, tlen)) {
@@ -1171,27 +1188,27 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		cp = NULL;
 	}
 
-	/* adjust skb network/transport offsets to match mac/fcoe/fc */
+	/* adjust skb network/transport offsets to match mac/fcoe/port */
 	skb_push(skb, elen + hlen);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
 	skb->mac_len = elen;
 	skb->protocol = htons(ETH_P_FCOE);
-	skb->dev = fc->netdev;
+	skb->dev = port->netdev;
 
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
 	eh->h_proto = htons(ETH_P_FCOE);
-	if (fc->ctlr.map_dest)
+	if (port->ctlr.map_dest)
 		fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
 	else
 		/* insert GW address */
-		memcpy(eh->h_dest, fc->ctlr.dest_addr, ETH_ALEN);
+		memcpy(eh->h_dest, port->ctlr.dest_addr, ETH_ALEN);
 
-	if (unlikely(fc->ctlr.flogi_oxid != FC_XID_UNKNOWN))
-		memcpy(eh->h_source, fc->ctlr.ctl_src_addr, ETH_ALEN);
+	if (unlikely(port->ctlr.flogi_oxid != FC_XID_UNKNOWN))
+		memcpy(eh->h_source, port->ctlr.ctl_src_addr, ETH_ALEN);
 	else
-		memcpy(eh->h_source, fc->ctlr.data_src_addr, ETH_ALEN);
+		memcpy(eh->h_source, port->ctlr.data_src_addr, ETH_ALEN);
 
 	hp = (struct fcoe_hdr *)(eh + 1);
 	memset(hp, 0, sizeof(*hp));
@@ -1214,7 +1231,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 
 	/* send down to lld */
 	fr_dev(fp) = lp;
-	if (fc->fcoe_pending_queue.qlen)
+	if (port->fcoe_pending_queue.qlen)
 		fcoe_check_wait_queue(lp, skb);
 	else if (fcoe_start_io(skb))
 		fcoe_check_wait_queue(lp, skb);
@@ -1240,7 +1257,7 @@ int fcoe_percpu_receive_thread(void *arg)
 	struct fcoe_crc_eof crc_eof;
 	struct fc_frame *fp;
 	u8 *mac = NULL;
-	struct fcoe_softc *fc;
+	struct fcoe_port *port;
 	struct fcoe_hdr *hp;
 
 	set_user_nice(current, -20);
@@ -1276,7 +1293,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		/*
 		 * Save source MAC address before discarding header.
 		 */
-		fc = lport_priv(lp);
+		port = lport_priv(lp);
 		if (skb_is_nonlinear(skb))
 			skb_linearize(skb);	/* not ideal */
 		mac = eth_hdr(skb)->h_source;
@@ -1354,8 +1371,8 @@ int fcoe_percpu_receive_thread(void *arg)
 			}
 			fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 		}
-		if (unlikely(fc->ctlr.flogi_oxid != FC_XID_UNKNOWN) &&
-		    fcoe_ctlr_recv_flogi(&fc->ctlr, fp, mac)) {
+		if (unlikely(port->ctlr.flogi_oxid != FC_XID_UNKNOWN) &&
+		    fcoe_ctlr_recv_flogi(&port->ctlr, fp, mac)) {
 			fc_frame_free(fp);
 			continue;
 		}
@@ -1379,46 +1396,46 @@ int fcoe_percpu_receive_thread(void *arg)
  */
 static void fcoe_check_wait_queue(struct fc_lport *lp, struct sk_buff *skb)
 {
-	struct fcoe_softc *fc = lport_priv(lp);
+	struct fcoe_port *port = lport_priv(lp);
 	int rc;
 
-	spin_lock_bh(&fc->fcoe_pending_queue.lock);
+	spin_lock_bh(&port->fcoe_pending_queue.lock);
 
 	if (skb)
-		__skb_queue_tail(&fc->fcoe_pending_queue, skb);
+		__skb_queue_tail(&port->fcoe_pending_queue, skb);
 
-	if (fc->fcoe_pending_queue_active)
+	if (port->fcoe_pending_queue_active)
 		goto out;
-	fc->fcoe_pending_queue_active = 1;
+	port->fcoe_pending_queue_active = 1;
 
-	while (fc->fcoe_pending_queue.qlen) {
+	while (port->fcoe_pending_queue.qlen) {
 		/* keep qlen > 0 until fcoe_start_io succeeds */
-		fc->fcoe_pending_queue.qlen++;
-		skb = __skb_dequeue(&fc->fcoe_pending_queue);
+		port->fcoe_pending_queue.qlen++;
+		skb = __skb_dequeue(&port->fcoe_pending_queue);
 
-		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+		spin_unlock_bh(&port->fcoe_pending_queue.lock);
 		rc = fcoe_start_io(skb);
-		spin_lock_bh(&fc->fcoe_pending_queue.lock);
+		spin_lock_bh(&port->fcoe_pending_queue.lock);
 
 		if (rc) {
-			__skb_queue_head(&fc->fcoe_pending_queue, skb);
+			__skb_queue_head(&port->fcoe_pending_queue, skb);
 			/* undo temporary increment above */
-			fc->fcoe_pending_queue.qlen--;
+			port->fcoe_pending_queue.qlen--;
 			break;
 		}
 		/* undo temporary increment above */
-		fc->fcoe_pending_queue.qlen--;
+		port->fcoe_pending_queue.qlen--;
 	}
 
-	if (fc->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
+	if (port->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
 		lp->qfull = 0;
-	if (fc->fcoe_pending_queue.qlen && !timer_pending(&fc->timer))
-		mod_timer(&fc->timer, jiffies + 2);
-	fc->fcoe_pending_queue_active = 0;
+	if (port->fcoe_pending_queue.qlen && !timer_pending(&port->timer))
+		mod_timer(&port->timer, jiffies + 2);
+	port->fcoe_pending_queue_active = 0;
 out:
-	if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
+	if (port->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
 		lp->qfull = 1;
-	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+	spin_unlock_bh(&port->fcoe_pending_queue.lock);
 	return;
 }
 
@@ -1453,16 +1470,18 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 {
 	struct fc_lport *lp = NULL;
 	struct net_device *netdev = ptr;
-	struct fcoe_softc *fc;
+	struct fcoe_interface *fcoe;
+	struct fcoe_port *port = NULL;
 	struct fcoe_dev_stats *stats;
 	u32 link_possible = 1;
 	u32 mfs;
 	int rc = NOTIFY_OK;
 
 	read_lock(&fcoe_hostlist_lock);
-	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		if (fc->netdev == netdev) {
-			lp = fc->ctlr.lp;
+	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
+		port = fcoe->priv;
+		if (port->netdev == netdev) {
+			lp = port->ctlr.lp;
 			break;
 		}
 	}
@@ -1493,8 +1512,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 				"from netdev netlink\n", event);
 	}
 	if (link_possible && !fcoe_link_ok(lp))
-		fcoe_ctlr_link_up(&fc->ctlr);
-	else if (fcoe_ctlr_link_down(&fc->ctlr)) {
+		fcoe_ctlr_link_up(&port->ctlr);
+	else if (fcoe_ctlr_link_down(&port->ctlr)) {
 		stats = fc_lport_get_stats(lp);
 		stats->LinkFailureCount++;
 		fcoe_clean_pending_queue(lp);
@@ -1668,10 +1687,10 @@ out_nodev:
 
 module_param_call(create, fcoe_create, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(create, "string");
-MODULE_PARM_DESC(create, "Create fcoe port using net device passed in.");
+MODULE_PARM_DESC(create, "Create fcoe fcoe using net device passed in.");
 module_param_call(destroy, fcoe_destroy, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(destroy, "string");
-MODULE_PARM_DESC(destroy, "Destroy fcoe port");
+MODULE_PARM_DESC(destroy, "Destroy fcoe fcoe");
 
 /**
  * fcoe_link_ok() - Check if link is ok for the fc_lport
@@ -1689,8 +1708,8 @@ MODULE_PARM_DESC(destroy, "Destroy fcoe port");
  */
 int fcoe_link_ok(struct fc_lport *lp)
 {
-	struct fcoe_softc *fc = lport_priv(lp);
-	struct net_device *dev = fc->netdev;
+	struct fcoe_port *port = lport_priv(lp);
+	struct net_device *dev = port->netdev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
 	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev) &&
@@ -1752,16 +1771,16 @@ void fcoe_percpu_clean(struct fc_lport *lp)
  */
 void fcoe_clean_pending_queue(struct fc_lport *lp)
 {
-	struct fcoe_softc  *fc = lport_priv(lp);
+	struct fcoe_port  *port = lport_priv(lp);
 	struct sk_buff *skb;
 
-	spin_lock_bh(&fc->fcoe_pending_queue.lock);
-	while ((skb = __skb_dequeue(&fc->fcoe_pending_queue)) != NULL) {
-		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+	spin_lock_bh(&port->fcoe_pending_queue.lock);
+	while ((skb = __skb_dequeue(&port->fcoe_pending_queue)) != NULL) {
+		spin_unlock_bh(&port->fcoe_pending_queue.lock);
 		kfree_skb(skb);
-		spin_lock_bh(&fc->fcoe_pending_queue.lock);
+		spin_lock_bh(&port->fcoe_pending_queue.lock);
 	}
-	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+	spin_unlock_bh(&port->fcoe_pending_queue.lock);
 }
 
 /**
@@ -1778,21 +1797,21 @@ int fcoe_reset(struct Scsi_Host *shost)
 }
 
 /**
- * fcoe_hostlist_lookup_softc() - find the corresponding lport by a given device
+ * fcoe_hostlist_lookup_port() - find the corresponding lport by a given device
  * @dev: this is currently ptr to net_device
  *
  * Called with fcoe_hostlist_lock held.
  *
- * Returns: NULL or the located fcoe_softc
+ * Returns: NULL or the located fcoe_port
  */
-static struct fcoe_softc *
-fcoe_hostlist_lookup_softc(const struct net_device *dev)
+static struct fcoe_interface *
+fcoe_hostlist_lookup_port(const struct net_device *dev)
 {
-	struct fcoe_softc *fc;
+	struct fcoe_interface *fcoe;
 
-	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		if (fc->netdev == dev)
-			return fc;
+	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
+		if (fcoe->priv->netdev == dev)
+			return fcoe;
 	}
 	return NULL;
 }
@@ -1805,13 +1824,13 @@ fcoe_hostlist_lookup_softc(const struct net_device *dev)
  */
 struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 {
-	struct fcoe_softc *fc;
+	struct fcoe_interface *fcoe;
 
 	read_lock(&fcoe_hostlist_lock);
-	fc = fcoe_hostlist_lookup_softc(netdev);
+	fcoe = fcoe_hostlist_lookup_port(netdev);
 	read_unlock(&fcoe_hostlist_lock);
 
-	return (fc) ? fc->ctlr.lp : NULL;
+	return (fcoe) ? fcoe->priv->ctlr.lp : NULL;
 }
 
 /**
@@ -1822,14 +1841,16 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
  *
  * Returns: 0 for success
  */
-int fcoe_hostlist_add(const struct fc_lport *lp)
+int fcoe_hostlist_add(const struct fc_lport *lport)
 {
-	struct fcoe_softc *fc;
-
-	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
-	if (!fc) {
-		fc = lport_priv(lp);
-		list_add_tail(&fc->list, &fcoe_hostlist);
+	struct fcoe_interface *fcoe;
+	struct fcoe_port *port;
+
+	fcoe = fcoe_hostlist_lookup_port(fcoe_netdev(lport));
+	if (!fcoe) {
+		port = lport_priv(lport);
+		fcoe = port->fcoe;
+		list_add_tail(&fcoe->list, &fcoe_hostlist);
 	}
 	return 0;
 }
@@ -1840,14 +1861,14 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
  *
  * Returns: 0 for success
  */
-int fcoe_hostlist_remove(const struct fc_lport *lp)
+int fcoe_hostlist_remove(const struct fc_lport *lport)
 {
-	struct fcoe_softc *fc;
+	struct fcoe_interface *fcoe;
 
 	write_lock_bh(&fcoe_hostlist_lock);
-	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
-	BUG_ON(!fc);
-	list_del(&fc->list);
+	fcoe = fcoe_hostlist_lookup_port(fcoe_netdev(lport));
+	BUG_ON(!fcoe);
+	list_del(&fcoe->list);
 	write_unlock_bh(&fcoe_hostlist_lock);
 
 	return 0;
@@ -1903,19 +1924,18 @@ module_init(fcoe_init);
 static void __exit fcoe_exit(void)
 {
 	unsigned int cpu;
-	struct fcoe_softc *fc, *tmp;
+	struct fcoe_interface *fcoe, *tmp;
 
 	fcoe_dev_cleanup();
 
 	/* releases the associated fcoe hosts */
-	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
-		fcoe_if_destroy(fc->ctlr.lp);
+	list_for_each_entry_safe(fcoe, tmp, &fcoe_hostlist, list)
+		fcoe_if_destroy(fcoe->priv->ctlr.lp);
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 
-	for_each_online_cpu(cpu) {
+	for_each_online_cpu(cpu)
 		fcoe_percpu_thread_destroy(cpu);
-	}
 
 	/* detach from scsi transport */
 	fcoe_if_exit();
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 550d1e4..060a6dc 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -75,10 +75,21 @@ struct fcoe_percpu_s {
 };
 
 /*
- * the fcoe sw transport private data
+ * an FCoE interface, 1:1 with netdev
  */
-struct fcoe_softc {
+struct fcoe_interface {
 	struct list_head list;
+	/* This will be removed once all the shared values are
+	 * moved out of fcoe_port */
+	struct fcoe_port *priv;
+};
+
+/*
+ * the FCoE private structure that's allocated along with the
+ * Scsi_Host and libfc fc_lport structures
+ */
+struct fcoe_port {
+	struct fcoe_interface *fcoe;
 	struct net_device *netdev;
 	struct fc_exch_mgr *oem;		/* offload exchange manger */
 	struct packet_type  fcoe_packet_type;
@@ -89,12 +100,12 @@ struct fcoe_softc {
 	struct fcoe_ctlr ctlr;
 };
 
-#define fcoe_from_ctlr(fc) container_of(fc, struct fcoe_softc, ctlr)
+#define fcoe_from_ctlr(port) container_of(port, struct fcoe_port, ctlr)
 
 static inline struct net_device *fcoe_netdev(
 	const struct fc_lport *lp)
 {
-	return ((struct fcoe_softc *)lport_priv(lp))->netdev;
+	return ((struct fcoe_port *)lport_priv(lp))->netdev;
 }
 
 #endif /* _FCOE_H_ */

