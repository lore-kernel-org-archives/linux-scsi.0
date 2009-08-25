From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/64] fcoe: split out per interface setup
Date: Tue, 25 Aug 2009 14:00:07 -0700
Message-ID: <20090825210007.1553.54017.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZHYVAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:05 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

fcoe_netdev_config() is called during initialization of a libfc instance.
Much of what was there only needs to be done once for each net_device.
The same goes for the corresponding cleanup.

The FIP controller initialization is moved to interface creation time.
Otherwise it will keep getting re-initialized for every VN_Port once NPIV is
enabled.

fcoe_if_destroy() has some reordering to deal with the changes.  Receives are
not stopped until after fcoe_interface_put() is called, but transmits must be
stopped before.  So there is some care to stop libfc transmits and the
transmit backlog timer, then call fcoe_interface_put which will stop receives
and cleanup the FIP controller, then the receive queues can be cleaned and the
port freed.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |  267 +++++++++++++++++++++++++---------------------
 1 files changed, 148 insertions(+), 119 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d1d6b3b..63aeeca 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -138,6 +138,82 @@ static struct scsi_host_template fcoe_shost_template = {
 	.max_sectors = 0xffff,
 };
 
+static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
+			 struct packet_type *ptype,
+			 struct net_device *orig_dev);
+/**
+ * fcoe_interface_setup()
+ * @fcoe: new fcoe_interface
+ * @netdev : ptr to the associated netdevice struct
+ *
+ * Returns : 0 for success
+ */
+static int fcoe_interface_setup(struct fcoe_interface *fcoe,
+				struct net_device *netdev)
+{
+	struct fcoe_ctlr *fip = &fcoe->ctlr;
+	struct netdev_hw_addr *ha;
+	u8 flogi_maddr[ETH_ALEN];
+
+	fcoe->netdev = netdev;
+
+	/* Do not support for bonding device */
+	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
+	    (netdev->priv_flags & IFF_SLAVE_INACTIVE) ||
+	    (netdev->priv_flags & IFF_MASTER_8023AD)) {
+		return -EOPNOTSUPP;
+	}
+
+	/* look for SAN MAC address, if multiple SAN MACs exist, only
+	 * use the first one for SPMA */
+	rcu_read_lock();
+	for_each_dev_addr(netdev, ha) {
+		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
+		    (is_valid_ether_addr(fip->ctl_src_addr))) {
+			memcpy(fip->ctl_src_addr, ha->addr, ETH_ALEN);
+			fip->spma = 1;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	/* setup Source Mac Address */
+	if (!fip->spma)
+		memcpy(fip->ctl_src_addr, netdev->dev_addr, netdev->addr_len);
+
+	/*
+	 * Add FCoE MAC address as second unicast MAC address
+	 * or enter promiscuous mode if not capable of listening
+	 * for multiple unicast MACs.
+	 */
+	rtnl_lock();
+	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
+	dev_unicast_add(netdev, flogi_maddr);
+	if (fip->spma)
+		dev_unicast_add(netdev, fip->ctl_src_addr);
+	dev_mc_add(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+	rtnl_unlock();
+
+	/*
+	 * setup the receive function from ethernet driver
+	 * on the ethertype for the given device
+	 */
+	fcoe->fcoe_packet_type.func = fcoe_rcv;
+	fcoe->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	fcoe->fcoe_packet_type.dev = netdev;
+	dev_add_pack(&fcoe->fcoe_packet_type);
+
+	fcoe->fip_packet_type.func = fcoe_fip_recv;
+	fcoe->fip_packet_type.type = htons(ETH_P_FIP);
+	fcoe->fip_packet_type.dev = netdev;
+	dev_add_pack(&fcoe->fip_packet_type);
+
+	return 0;
+}
+
+static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb);
+static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new);
+
 /**
  * fcoe_interface_create()
  * @netdev: network interface
@@ -155,12 +231,55 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
 	}
 
 	kref_init(&fcoe->kref);
-	fcoe->netdev = netdev;
+
+	/*
+	 * Initialize FIP.
+	 */
+	fcoe_ctlr_init(&fcoe->ctlr);
+	fcoe->ctlr.send = fcoe_fip_send;
+	fcoe->ctlr.update_mac = fcoe_update_src_mac;
+
+	fcoe_interface_setup(fcoe, netdev);
 
 	return fcoe;
 }
 
 /**
+ * fcoe_interface_cleanup() - clean up netdev configurations
+ * @fcoe:
+ */
+void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
+{
+	struct net_device *netdev = fcoe->netdev;
+	struct fcoe_ctlr *fip = &fcoe->ctlr;
+	u8 flogi_maddr[ETH_ALEN];
+
+	/*
+	 * Don't listen for Ethernet packets anymore.
+	 * synchronize_net() ensures that the packet handlers are not running
+	 * on another CPU. dev_remove_pack() would do that, this calls the
+	 * unsyncronized version __dev_remove_pack() to avoid multiple delays.
+	 */
+	__dev_remove_pack(&fcoe->fcoe_packet_type);
+	__dev_remove_pack(&fcoe->fip_packet_type);
+	synchronize_net();
+
+	/* tear-down the FCoE controller */
+	fcoe_ctlr_destroy(&fcoe->ctlr);
+
+	/* Delete secondary MAC addresses */
+	rtnl_lock();
+	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
+	dev_unicast_delete(netdev, flogi_maddr);
+	if (!is_zero_ether_addr(fip->data_src_addr))
+		dev_unicast_delete(netdev, fip->data_src_addr);
+	if (fip->spma)
+		dev_unicast_delete(netdev, fip->ctl_src_addr);
+	dev_mc_delete(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+	rtnl_unlock();
+}
+
+/**
  * fcoe_interface_release() - fcoe_port kref release function
  * @kref: embedded reference count in an fcoe_interface struct
  */
@@ -169,6 +288,7 @@ static void fcoe_interface_release(struct kref *kref)
 	struct fcoe_interface *fcoe;
 
 	fcoe = container_of(kref, struct fcoe_interface, kref);
+	fcoe_interface_cleanup(fcoe);
 	kfree(fcoe);
 }
 
@@ -275,31 +395,6 @@ static int fcoe_lport_config(struct fc_lport *lp)
 }
 
 /**
- * fcoe_netdev_cleanup() - clean up netdev configurations
- * @port: ptr to the fcoe_port
- */
-void fcoe_netdev_cleanup(struct fcoe_port *port)
-{
-	u8 flogi_maddr[ETH_ALEN];
-	struct fcoe_interface *fcoe = port->fcoe;
-
-	/* Don't listen for Ethernet packets anymore */
-	dev_remove_pack(&fcoe->fcoe_packet_type);
-	dev_remove_pack(&fcoe->fip_packet_type);
-
-	/* Delete secondary MAC addresses */
-	rtnl_lock();
-	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_delete(fcoe->netdev, flogi_maddr);
-	if (!is_zero_ether_addr(fcoe->ctlr.data_src_addr))
-		dev_unicast_delete(fcoe->netdev, fcoe->ctlr.data_src_addr);
-	if (fcoe->ctlr.spma)
-		dev_unicast_delete(fcoe->netdev, fcoe->ctlr.ctl_src_addr);
-	dev_mc_delete(fcoe->netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
-	rtnl_unlock();
-}
-
-/**
  * fcoe_queue_timer() - fcoe queue timer
  * @lp: the fc_lport pointer
  *
@@ -326,21 +421,10 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	u64 wwnn, wwpn;
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
-	u8 flogi_maddr[ETH_ALEN];
-	struct netdev_hw_addr *ha;
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lp);
 	fcoe = port->fcoe;
-	fcoe->ctlr.lp = lp;
-	fcoe->netdev = netdev;
-
-	/* Do not support for bonding device */
-	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
-	    (netdev->priv_flags & IFF_SLAVE_INACTIVE) ||
-	    (netdev->priv_flags & IFF_MASTER_8023AD)) {
-		return -EOPNOTSUPP;
-	}
 
 	/*
 	 * Determine max frame size based on underlying device and optional
@@ -376,57 +460,12 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	port->fcoe_pending_queue_active = 0;
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lp);
 
-	/* look for SAN MAC address, if multiple SAN MACs exist, only
-	 * use the first one for SPMA */
-	rcu_read_lock();
-	for_each_dev_addr(netdev, ha) {
-		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
-		    (is_valid_ether_addr(fcoe->ctlr.ctl_src_addr))) {
-			memcpy(fcoe->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
-			fcoe->ctlr.spma = 1;
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	/* setup Source Mac Address */
-	if (!fcoe->ctlr.spma)
-		memcpy(fcoe->ctlr.ctl_src_addr, netdev->dev_addr,
-		       netdev->addr_len);
-
 	wwnn = fcoe_wwn_from_mac(netdev->dev_addr, 1, 0);
 	fc_set_wwnn(lp, wwnn);
 	/* XXX - 3rd arg needs to be vlan id */
 	wwpn = fcoe_wwn_from_mac(netdev->dev_addr, 2, 0);
 	fc_set_wwpn(lp, wwpn);
 
-	/*
-	 * Add FCoE MAC address as second unicast MAC address
-	 * or enter promiscuous mode if not capable of listening
-	 * for multiple unicast MACs.
-	 */
-	rtnl_lock();
-	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_add(netdev, flogi_maddr);
-	if (fcoe->ctlr.spma)
-		dev_unicast_add(netdev, fcoe->ctlr.ctl_src_addr);
-	dev_mc_add(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
-	rtnl_unlock();
-
-	/*
-	 * setup the receive function from ethernet driver
-	 * on the ethertype for the given device
-	 */
-	fcoe->fcoe_packet_type.func = fcoe_rcv;
-	fcoe->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
-	fcoe->fcoe_packet_type.dev = netdev;
-	dev_add_pack(&fcoe->fcoe_packet_type);
-
-	fcoe->fip_packet_type.func = fcoe_fip_recv;
-	fcoe->fip_packet_type.type = htons(ETH_P_FIP);
-	fcoe->fip_packet_type.dev = netdev;
-	dev_add_pack(&fcoe->fip_packet_type);
-
 	return 0;
 }
 
@@ -578,19 +617,22 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Remove the instance from fcoe's list */
 	fcoe_hostlist_remove(lport);
 
-	/* clean up netdev configurations */
-	fcoe_netdev_cleanup(port);
+	/* Cleanup the fc_lport */
+	fc_lport_destroy(lport);
+	fc_fcp_destroy(lport);
+
+	/* Stop the transmit retry timer */
+	del_timer_sync(&port->timer);
 
-	/* tear-down the FCoE controller */
-	fcoe_ctlr_destroy(&fcoe->ctlr);
+	/* Free existing transmit skbs */
+	fcoe_clean_pending_queue(lport);
+
+	/* receives may not be stopped until after this */
+	fcoe_interface_put(fcoe);
 
 	/* Free queued packets for the per-CPU receive threads */
 	fcoe_percpu_clean(lport);
 
-	/* Cleanup the fc_lport */
-	fc_lport_destroy(lport);
-	fc_fcp_destroy(lport);
-
 	/* Detach from the scsi-ml */
 	fc_remove_host(lport->host);
 	scsi_remove_host(lport->host);
@@ -598,19 +640,12 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* There are no more rports or I/O, free the EM */
 	fc_exch_mgr_free(lport);
 
-	/* Free existing skbs */
-	fcoe_clean_pending_queue(lport);
-
-	/* Stop the timer */
-	del_timer_sync(&port->timer);
-
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
 
 	/* Release the net_device and Scsi_Host */
 	dev_put(netdev);
 	scsi_host_put(lport->host);
-	fcoe_interface_put(fcoe);
 }
 
 /*
@@ -660,8 +695,7 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
  * @fcoe: fcoe_interface structure to create an fc_lport instance on
  * @parent: device pointer to be the parent in sysfs for the SCSI host
  *
- * Creates fc_lport struct and scsi_host for lport, configures lport
- * and starts fabric login.
+ * Creates fc_lport struct and scsi_host for lport, configures lport.
  *
  * Returns : The allocated fc_lport or an error pointer
  */
@@ -695,19 +729,12 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_host_put;
 	}
 
-	/*
-	 * Initialize FIP.
-	 */
-	fcoe_ctlr_init(&fcoe->ctlr);
-	fcoe->ctlr.send = fcoe_fip_send;
-	fcoe->ctlr.update_mac = fcoe_update_src_mac;
-
 	/* configure lport network properties */
 	rc = fcoe_netdev_config(lport, netdev);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure netdev for the "
 				"interface\n");
-		goto out_netdev_cleanup;
+		goto out_lp_destroy;
 	}
 
 	/* configure lport scsi host properties */
@@ -715,7 +742,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
 				"interface\n");
-		goto out_netdev_cleanup;
+		goto out_lp_destroy;
 	}
 
 	/* Initialize the library */
@@ -745,21 +772,12 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	fcoe_hostlist_add(lport);
 	write_unlock(&fcoe_hostlist_lock);
 
-	lport->boot_time = jiffies;
-
-	fc_fabric_login(lport);
-
-	if (!fcoe_link_ok(lport))
-		fcoe_ctlr_link_up(&fcoe->ctlr);
-
 	dev_hold(netdev);
 	fcoe_interface_get(fcoe);
 	return lport;
 
 out_lp_destroy:
 	fc_exch_mgr_free(lport);
-out_netdev_cleanup:
-	fcoe_netdev_cleanup(port);
 out_host_put:
 	scsi_host_put(lport->host);
 out:
@@ -1731,10 +1749,21 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 		goto out_free;
 	}
 
-	dev_put(netdev);
-	return 0;
+	/* Make this the "master" N_Port */
+	fcoe->ctlr.lp = lport;
+
+	/* start FIP Discovery and FLOGI */
+	lport->boot_time = jiffies;
+	fc_fabric_login(lport);
+	if (!fcoe_link_ok(lport))
+		fcoe_ctlr_link_up(&fcoe->ctlr);
 
+	rc = 0;
 out_free:
+	/*
+	 * Release from init in fcoe_interface_create(), on success lport
+	 * should be holding a reference taken in fcoe_if_create().
+	 */
 	fcoe_interface_put(fcoe);
 out_putdev:
 	dev_put(netdev);

