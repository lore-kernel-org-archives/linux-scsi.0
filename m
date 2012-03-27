From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v4 1/4] fcoe: Allocate fcoe_ctlr with fcoe_interface,
 not as a member
Date: Tue, 27 Mar 2012 15:22:29 -0700
Message-ID: <20120327222229.7144.79107.stgit@localhost6.localdomain6>
References: <20120327222224.7144.6324.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab2C0WWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2012 18:22:38 -0400
In-Reply-To: <20120327222224.7144.6324.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

Currently the fcoe_ctlr associated with an interface is allocated
as a member of struct fcoe_interface. This causes problems when
attempting to use the new fcoe_sysfs APIs which allow us to allocate
the fcoe_interface as private data to the fcoe_ctlr_device instance.
The problem is that libfcoe wants to be able use pointer math to find a
fcoe_ctlr's fcoe_ctlr_device as well as finding a fcoe_ctlr_device's
assocated fcoe_ctlr. To do this we need to allocate the
fcoe_ctlr_device, with private data for the LLD. The private data
contains the fcoe_ctlr and its private data is the fcoe_interface.
This patch only allocates the fcoe_interface with the fcoe_ctlr, the
fcoe_ctlr_device will be added in a later patch, which will complete
the below diagram-

+------------------+
| fcoe_ctlr_device |
+------------------+
| fcoe_ctlr        |
+------------------+
| fcoe_interface   |
+------------------+

This prep work will allow us to go from a fcoe_ctlr_device instance
to its fcoe_ctlr as well as from a fcoe_ctlr to its fcoe_ctlr_device
once the fcoe_sysfs API is in use (later patches in this series).

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |  132 ++++++++++++++++++++++++++++++----------------
 drivers/scsi/fcoe/fcoe.h |    8 ++-
 include/scsi/libfcoe.h   |    9 +++
 3 files changed, 99 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 58c88b0..85ab965 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -282,7 +282,7 @@ static struct scsi_host_template fcoe_shost_template = {
 static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 				struct net_device *netdev)
 {
-	struct fcoe_ctlr *fip = &fcoe->ctlr;
+	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
 	struct netdev_hw_addr *ha;
 	struct net_device *real_dev;
 	u8 flogi_maddr[ETH_ALEN];
@@ -366,7 +366,9 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 						    enum fip_state fip_mode)
 {
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
+	int size;
 	int err;
 
 	if (!try_module_get(THIS_MODULE)) {
@@ -376,7 +378,9 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 		goto out;
 	}
 
-	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
+	size = sizeof(struct fcoe_ctlr) + sizeof(struct fcoe_interface);
+	ctlr = kzalloc(size, GFP_KERNEL);
+	fcoe = fcoe_ctlr_priv(ctlr);
 	if (!fcoe) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
 		fcoe = ERR_PTR(-ENOMEM);
@@ -388,15 +392,14 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	/*
 	 * Initialize FIP.
 	 */
-	fcoe_ctlr_init(&fcoe->ctlr, fip_mode);
-	fcoe->ctlr.send = fcoe_fip_send;
-	fcoe->ctlr.update_mac = fcoe_update_src_mac;
-	fcoe->ctlr.get_src_addr = fcoe_get_src_mac;
+	fcoe_ctlr_init(ctlr, fip_mode);
+	ctlr->send = fcoe_fip_send;
+	ctlr->update_mac = fcoe_update_src_mac;
+	ctlr->get_src_addr = fcoe_get_src_mac;
 
 	err = fcoe_interface_setup(fcoe, netdev);
 	if (err) {
-		fcoe_ctlr_destroy(&fcoe->ctlr);
-		kfree(fcoe);
+		fcoe_ctlr_destroy(ctlr);
 		dev_put(netdev);
 		fcoe = ERR_PTR(err);
 		goto out_putmod;
@@ -419,7 +422,7 @@ out:
 static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 {
 	struct net_device *netdev = fcoe->netdev;
-	struct fcoe_ctlr *fip = &fcoe->ctlr;
+	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
 	u8 flogi_maddr[ETH_ALEN];
 	const struct net_device_ops *ops;
 
@@ -459,7 +462,6 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	/* Release the self-reference taken during fcoe_interface_create() */
 	/* tear-down the FCoE controller */
 	fcoe_ctlr_destroy(fip);
-	kfree(fcoe);
 	dev_put(netdev);
 	module_put(THIS_MODULE);
 }
@@ -479,9 +481,11 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *netdev,
 			 struct net_device *orig_dev)
 {
 	struct fcoe_interface *fcoe;
+	struct fcoe_ctlr *ctlr;
 
 	fcoe = container_of(ptype, struct fcoe_interface, fip_packet_type);
-	fcoe_ctlr_recv(&fcoe->ctlr, skb);
+	ctlr = fcoe_to_ctlr(fcoe);
+	fcoe_ctlr_recv(ctlr, skb);
 	return 0;
 }
 
@@ -633,11 +637,13 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	u32 mfs;
 	u64 wwnn, wwpn;
 	struct fcoe_interface *fcoe;
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_port *port;
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lport);
 	fcoe = port->priv;
+	ctlr = fcoe_to_ctlr(fcoe);
 
 	/*
 	 * Determine max frame size based on underlying device and optional
@@ -664,10 +670,10 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 
 	if (!lport->vport) {
 		if (fcoe_get_wwn(netdev, &wwnn, NETDEV_FCOE_WWNN))
-			wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
+			wwnn = fcoe_wwn_from_mac(ctlr->ctl_src_addr, 1, 0);
 		fc_set_wwnn(lport, wwnn);
 		if (fcoe_get_wwn(netdev, &wwpn, NETDEV_FCOE_WWPN))
-			wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr,
+			wwpn = fcoe_wwn_from_mac(ctlr->ctl_src_addr,
 						 2, 0);
 		fc_set_wwpn(lport, wwpn);
 	}
@@ -1036,6 +1042,7 @@ static int fcoe_ddp_done(struct fc_lport *lport, u16 xid)
 static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 				       struct device *parent, int npiv)
 {
+	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
 	struct net_device *netdev = fcoe->netdev;
 	struct fc_lport *lport, *n_port;
 	struct fcoe_port *port;
@@ -1099,7 +1106,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	}
 
 	/* Initialize the library */
-	rc = fcoe_libfc_config(lport, &fcoe->ctlr, &fcoe_libfc_fcn_templ, 1);
+	rc = fcoe_libfc_config(lport, ctlr, &fcoe_libfc_fcn_templ, 1);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
 				"interface\n");
@@ -1366,6 +1373,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 {
 	struct fc_lport *lport;
 	struct fcoe_rcv_info *fr;
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
@@ -1373,7 +1381,8 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	unsigned int cpu;
 
 	fcoe = container_of(ptype, struct fcoe_interface, fcoe_packet_type);
-	lport = fcoe->ctlr.lp;
+	ctlr = fcoe_to_ctlr(fcoe);
+	lport = ctlr->lp;
 	if (unlikely(!lport)) {
 		FCOE_NETDEV_DBG(netdev, "Cannot find hba structure");
 		goto err2;
@@ -1389,8 +1398,8 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 
 	eh = eth_hdr(skb);
 
-	if (is_fip_mode(&fcoe->ctlr) &&
-	    compare_ether_addr(eh->h_source, fcoe->ctlr.dest_addr)) {
+	if (is_fip_mode(ctlr) &&
+	    compare_ether_addr(eh->h_source, ctlr->dest_addr)) {
 		FCOE_NETDEV_DBG(netdev, "wrong source mac address:%pM\n",
 				eh->h_source);
 		goto err;
@@ -1524,6 +1533,7 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	unsigned int elen;		/* eth header, may include vlan */
 	struct fcoe_port *port = lport_priv(lport);
 	struct fcoe_interface *fcoe = port->priv;
+	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
 	u8 sof, eof;
 	struct fcoe_hdr *hp;
 
@@ -1539,7 +1549,7 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	}
 
 	if (unlikely(fh->fh_type == FC_TYPE_ELS) &&
-	    fcoe_ctlr_els_send(&fcoe->ctlr, lport, skb))
+	    fcoe_ctlr_els_send(ctlr, lport, skb))
 		return 0;
 
 	sof = fr_sof(fp);
@@ -1603,12 +1613,12 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
 	eh->h_proto = htons(ETH_P_FCOE);
-	memcpy(eh->h_dest, fcoe->ctlr.dest_addr, ETH_ALEN);
-	if (fcoe->ctlr.map_dest)
+	memcpy(eh->h_dest, ctlr->dest_addr, ETH_ALEN);
+	if (ctlr->map_dest)
 		memcpy(eh->h_dest + 3, fh->fh_d_id, 3);
 
-	if (unlikely(fcoe->ctlr.flogi_oxid != FC_XID_UNKNOWN))
-		memcpy(eh->h_source, fcoe->ctlr.ctl_src_addr, ETH_ALEN);
+	if (unlikely(ctlr->flogi_oxid != FC_XID_UNKNOWN))
+		memcpy(eh->h_source, ctlr->ctl_src_addr, ETH_ALEN);
 	else
 		memcpy(eh->h_source, port->data_src_addr, ETH_ALEN);
 
@@ -1657,6 +1667,7 @@ static void fcoe_percpu_flush_done(struct sk_buff *skb)
 static inline int fcoe_filter_frames(struct fc_lport *lport,
 				     struct fc_frame *fp)
 {
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	struct fc_frame_header *fh;
 	struct sk_buff *skb = (struct sk_buff *)fp;
@@ -1678,7 +1689,8 @@ static inline int fcoe_filter_frames(struct fc_lport *lport,
 		return 0;
 
 	fcoe = ((struct fcoe_port *)lport_priv(lport))->priv;
-	if (is_fip_mode(&fcoe->ctlr) && fc_frame_payload_op(fp) == ELS_LOGO &&
+	ctlr = fcoe_to_ctlr(fcoe);
+	if (is_fip_mode(ctlr) && fc_frame_payload_op(fp) == ELS_LOGO &&
 	    ntoh24(fh->fh_s_id) == FC_FID_FLOGI) {
 		FCOE_DBG("fcoe: dropping FCoE lport LOGO in fip mode\n");
 		return -EINVAL;
@@ -1857,6 +1869,7 @@ static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 				     ulong event, void *ptr)
 {
 	struct dcb_app_type *entry = ptr;
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	struct net_device *netdev;
 	struct fcoe_port *port;
@@ -1874,6 +1887,8 @@ static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 	if (!fcoe)
 		return NOTIFY_OK;
 
+	ctlr = fcoe_to_ctlr(fcoe);
+
 	if (entry->dcbx & DCB_CAP_DCBX_VER_CEE)
 		prio = ffs(entry->app.priority) - 1;
 	else
@@ -1884,10 +1899,10 @@ static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 
 	if (entry->app.protocol == ETH_P_FIP ||
 	    entry->app.protocol == ETH_P_FCOE)
-		fcoe->ctlr.priority = prio;
+		ctlr->priority = prio;
 
 	if (entry->app.protocol == ETH_P_FCOE) {
-		port = lport_priv(fcoe->ctlr.lp);
+		port = lport_priv(ctlr->lp);
 		port->priority = prio;
 	}
 
@@ -1909,6 +1924,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 {
 	struct fc_lport *lport = NULL;
 	struct net_device *netdev = ptr;
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
 	struct fcoe_dev_stats *stats;
@@ -1918,7 +1934,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 
 	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
 		if (fcoe->netdev == netdev) {
-			lport = fcoe->ctlr.lp;
+			ctlr = fcoe_to_ctlr(fcoe);
+			lport = ctlr->lp;
 			break;
 		}
 	}
@@ -1947,7 +1964,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		break;
 	case NETDEV_UNREGISTER:
 		list_del(&fcoe->list);
-		port = lport_priv(fcoe->ctlr.lp);
+		port = lport_priv(ctlr->lp);
 		queue_work(fcoe_wq, &port->destroy_work);
 		goto out;
 		break;
@@ -1962,8 +1979,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	fcoe_link_speed_update(lport);
 
 	if (link_possible && !fcoe_link_ok(lport))
-		fcoe_ctlr_link_up(&fcoe->ctlr);
-	else if (fcoe_ctlr_link_down(&fcoe->ctlr)) {
+		fcoe_ctlr_link_up(ctlr);
+	else if (fcoe_ctlr_link_down(ctlr)) {
 		stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 		stats->LinkFailureCount++;
 		put_cpu();
@@ -1983,6 +2000,7 @@ out:
  */
 static int fcoe_disable(struct net_device *netdev)
 {
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	int rc = 0;
 
@@ -1993,8 +2011,9 @@ static int fcoe_disable(struct net_device *netdev)
 	rtnl_unlock();
 
 	if (fcoe) {
-		fcoe_ctlr_link_down(&fcoe->ctlr);
-		fcoe_clean_pending_queue(fcoe->ctlr.lp);
+		ctlr = fcoe_to_ctlr(fcoe);
+		fcoe_ctlr_link_down(ctlr);
+		fcoe_clean_pending_queue(ctlr->lp);
 	} else
 		rc = -ENODEV;
 
@@ -2012,6 +2031,7 @@ static int fcoe_disable(struct net_device *netdev)
  */
 static int fcoe_enable(struct net_device *netdev)
 {
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	int rc = 0;
 
@@ -2020,11 +2040,17 @@ static int fcoe_enable(struct net_device *netdev)
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
-	if (!fcoe)
+	if (!fcoe) {
 		rc = -ENODEV;
-	else if (!fcoe_link_ok(fcoe->ctlr.lp))
-		fcoe_ctlr_link_up(&fcoe->ctlr);
+		goto out;
+	}
 
+	ctlr = fcoe_to_ctlr(fcoe);
+
+	if (!fcoe_link_ok(ctlr->lp))
+		fcoe_ctlr_link_up(ctlr);
+
+out:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
@@ -2039,6 +2065,7 @@ static int fcoe_enable(struct net_device *netdev)
  */
 static int fcoe_destroy(struct net_device *netdev)
 {
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	struct fc_lport *lport;
 	struct fcoe_port *port;
@@ -2051,7 +2078,8 @@ static int fcoe_destroy(struct net_device *netdev)
 		rc = -ENODEV;
 		goto out_nodev;
 	}
-	lport = fcoe->ctlr.lp;
+	ctlr = fcoe_to_ctlr(fcoe);
+	lport = ctlr->lp;
 	port = lport_priv(lport);
 	list_del(&fcoe->list);
 	queue_work(fcoe_wq, &port->destroy_work);
@@ -2106,7 +2134,8 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 	int dcbx;
 	u8 fup, up;
 	struct net_device *netdev = fcoe->realdev;
-	struct fcoe_port *port = lport_priv(fcoe->ctlr.lp);
+	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
+	struct fcoe_port *port = lport_priv(ctlr->lp);
 	struct dcb_app app = {
 				.priority = 0,
 				.protocol = ETH_P_FCOE
@@ -2129,7 +2158,7 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 		}
 
 		port->priority = ffs(up) ? ffs(up) - 1 : 0;
-		fcoe->ctlr.priority = ffs(fup) ? ffs(fup) - 1 : port->priority;
+		ctlr->priority = ffs(fup) ? ffs(fup) - 1 : port->priority;
 	}
 #endif
 }
@@ -2146,6 +2175,7 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 {
 	int rc = 0;
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	struct fc_lport *lport;
 
@@ -2164,6 +2194,8 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 		goto out_nodev;
 	}
 
+	ctlr = fcoe_to_ctlr(fcoe);
+
 	lport = fcoe_if_create(fcoe, &netdev->dev, 0);
 	if (IS_ERR(lport)) {
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
@@ -2175,7 +2207,7 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	}
 
 	/* Make this the "master" N_Port */
-	fcoe->ctlr.lp = lport;
+	ctlr->lp = lport;
 
 	/* setup DCB priority attributes. */
 	fcoe_dcb_create(fcoe);
@@ -2187,7 +2219,7 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	lport->boot_time = jiffies;
 	fc_fabric_login(lport);
 	if (!fcoe_link_ok(lport))
-		fcoe_ctlr_link_up(&fcoe->ctlr);
+		fcoe_ctlr_link_up(ctlr);
 
 out_nodev:
 	rtnl_unlock();
@@ -2297,11 +2329,12 @@ static int fcoe_reset(struct Scsi_Host *shost)
 	struct fc_lport *lport = shost_priv(shost);
 	struct fcoe_port *port = lport_priv(lport);
 	struct fcoe_interface *fcoe = port->priv;
+	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
 
-	fcoe_ctlr_link_down(&fcoe->ctlr);
-	fcoe_clean_pending_queue(fcoe->ctlr.lp);
-	if (!fcoe_link_ok(fcoe->ctlr.lp))
-		fcoe_ctlr_link_up(&fcoe->ctlr);
+	fcoe_ctlr_link_down(ctlr);
+	fcoe_clean_pending_queue(ctlr->lp);
+	if (!fcoe_link_ok(ctlr->lp))
+		fcoe_ctlr_link_up(ctlr);
 	return 0;
 }
 
@@ -2336,10 +2369,12 @@ fcoe_hostlist_lookup_port(const struct net_device *netdev)
  */
 static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 {
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 
 	fcoe = fcoe_hostlist_lookup_port(netdev);
-	return (fcoe) ? fcoe->ctlr.lp : NULL;
+	ctlr = fcoe_to_ctlr(fcoe);
+	return (fcoe) ? ctlr->lp : NULL;
 }
 
 /**
@@ -2443,6 +2478,7 @@ module_init(fcoe_init);
 static void __exit fcoe_exit(void)
 {
 	struct fcoe_interface *fcoe, *tmp;
+	struct fcoe_ctlr *ctlr;
 	struct fcoe_port *port;
 	unsigned int cpu;
 
@@ -2454,7 +2490,8 @@ static void __exit fcoe_exit(void)
 	rtnl_lock();
 	list_for_each_entry_safe(fcoe, tmp, &fcoe_hostlist, list) {
 		list_del(&fcoe->list);
-		port = lport_priv(fcoe->ctlr.lp);
+		ctlr = fcoe_to_ctlr(fcoe);
+		port = lport_priv(ctlr->lp);
 		queue_work(fcoe_wq, &port->destroy_work);
 	}
 	rtnl_unlock();
@@ -2550,7 +2587,7 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
 {
 	struct fcoe_port *port = lport_priv(lport);
 	struct fcoe_interface *fcoe = port->priv;
-	struct fcoe_ctlr *fip = &fcoe->ctlr;
+	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 
 	switch (op) {
@@ -2724,7 +2761,8 @@ static void fcoe_set_port_id(struct fc_lport *lport,
 {
 	struct fcoe_port *port = lport_priv(lport);
 	struct fcoe_interface *fcoe = port->priv;
+	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
 
 	if (fp && fc_frame_payload_op(fp) == ELS_FLOGI)
-		fcoe_ctlr_recv_flogi(&fcoe->ctlr, lport, fp);
+		fcoe_ctlr_recv_flogi(ctlr, lport, fp);
 }
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 3c2733a..55fdbdc 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -68,7 +68,6 @@ do {                                                            	\
  * @netdev:	      The associated net device
  * @fcoe_packet_type: FCoE packet type
  * @fip_packet_type:  FIP packet type
- * @ctlr:	      The FCoE controller (for FIP)
  * @oem:	      The offload exchange manager for all local port
  *		      instances associated with this port
  * This structure is 1:1 with a net devive.
@@ -79,11 +78,14 @@ struct fcoe_interface {
 	struct net_device  *realdev;
 	struct packet_type fcoe_packet_type;
 	struct packet_type fip_packet_type;
-	struct fcoe_ctlr   ctlr;
 	struct fc_exch_mgr *oem;
 };
 
-#define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)
+#define fcoe_to_ctlr(x)						\
+	(struct fcoe_ctlr *)(((struct fcoe_ctlr *)(x)) - 1)
+
+#define fcoe_from_ctlr(x)			\
+	((struct fcoe_interface *)((x) + 1))
 
 /**
  * fcoe_netdev() - Return the net device associated with a local port
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index cfdb55f..69eca4b 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -159,6 +159,15 @@ struct fcoe_ctlr {
 };
 
 /**
+ * fcoe_ctlr_priv() - Return the private data from a fcoe_ctlr
+ * @cltr: The fcoe_ctlr whose private data will be returned
+ */
+static inline void *fcoe_ctlr_priv(const struct fcoe_ctlr *ctlr)
+{
+	return (void *)(ctlr + 1);
+}
+
+/**
  * struct fcoe_fcf - Fibre-Channel Forwarder
  * @list:	 list linkage
  * @time:	 system time (jiffies) when an advertisement was last received

