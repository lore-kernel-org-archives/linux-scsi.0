From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 2/5] fcoe: Add support for the FIP discovery and keep-alive
	protocol.
Date: Wed, 04 Mar 2009 10:53:47 -0800
Message-ID: <20090304185346.22010.13701.stgit@vi2.jf.intel.com>
References: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12599 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbZCDSxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 13:53:50 -0500
In-Reply-To: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Joe Eykholt <jeykholt@cisco.com>

FIP is the new standard way to discover Fibre-Channel Forwarders (FCFs).
It involves sending solicitations and listening for advertisements from FCFs.
It also provides for keep-alives and period advertisements so that both
parties know they have connectivity.  If the FCF loses connectivity to
the storage fabric, it can send a Link Reset to inform the E_node.

This version is also compatible with pre-FIP implementations, so no
configured selection between FIP mode and non-FIP mode is required.

We wait a couple seconds after sending the initial solicitation
and then send an old-style FLOGI.  If we receive any FIP frames,
we use FIP only mode.  If the old FLOGI receives a response,
we disable FIP mode.  After every reset or link up, this
determination is repeated.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/Kconfig             |   11 
 drivers/scsi/Makefile            |    1 
 drivers/scsi/fcoe/fcoe_sw.c      |   61 ++
 drivers/scsi/fcoe/libfcoe.c      |  159 ++---
 drivers/scsi/libfcoe/Makefile    |    6 
 drivers/scsi/libfcoe/fcoe_ctlr.c | 1206 ++++++++++++++++++++++++++++++++++++++
 include/scsi/fc_frame.h          |    1 
 include/scsi/fcoe_ctlr.h         |  103 +++
 include/scsi/libfcoe.h           |   24 -
 9 files changed, 1453 insertions(+), 119 deletions(-)
 create mode 100644 drivers/scsi/libfcoe/Makefile
 create mode 100644 drivers/scsi/libfcoe/fcoe_ctlr.c
 create mode 100644 include/scsi/fcoe_ctlr.h


diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 256c7be..2e7c05e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -611,10 +611,19 @@ config LIBFC
 	---help---
 	  Fibre Channel library module
 
+config LIBFCOE
+	tristate "LibFCoE module"
+	depends on SCSI
+	select LIBFC
+	---help---
+	  This contains support routines needed for FCoE HBAs and the
+	  FCoE module.  It is normally unnecessary to configure this separately,
+	  it is selected by the modules that require it.
+
 config FCOE
 	tristate "FCoE module"
 	depends on PCI
-	select LIBFC
+	select LIBFCOE
 	---help---
 	  Fibre Channel over Ethernet module
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 7461eb0..95e2bc0 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_LIBFC)		+= libfc/
+obj-$(CONFIG_LIBFCOE)		+= libfcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index da210eb..237bfe5 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -31,6 +31,7 @@
 #include <scsi/fc/fc_els.h>
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fs.h>
+#include <scsi/fc/fc_fip.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 
@@ -50,6 +51,8 @@
 #define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
 #define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
 
+static u8 fcoe_all_enodes[ETH_ALEN] = FIP_ALL_ENODE_MACS;
+
 static struct scsi_transport_template *scsi_transport_fcoe_sw;
 
 struct fc_function_template fcoe_sw_transport_function = {
@@ -136,8 +139,31 @@ static int fcoe_sw_lport_config(struct fc_lport *lp)
 	return 0;
 }
 
-/**
- * fcoe_sw_netdev_config() - Set up netdev for SW FCoE
+static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	skb->dev = fcoe_from_ctlr(fip)->real_dev;
+	dev_queue_xmit(skb);
+}
+
+/*
+ * Remove any previously-set unicast MAC filter.
+ * Add secondary FCoE MAC address filter for our OUI.
+ */
+static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new)
+{
+	struct fcoe_softc *fc;
+
+	fc = fcoe_from_ctlr(fip);
+	rtnl_lock();
+	if (!is_zero_ether_addr(old))
+		dev_unicast_delete(fc->real_dev, old, ETH_ALEN);
+	dev_unicast_add(fc->real_dev, new, ETH_ALEN);
+	rtnl_unlock();
+}
+
+/*
+ * fcoe_sw_netdev_config - sets up fcoe_softc for lport and network
+ * related properties
  * @lp : ptr to the fc_lport
  * @netdev : ptr to the associated netdevice struct
  *
@@ -154,7 +180,7 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 
 	/* Setup lport private data to point to fcoe softc */
 	fc = lport_priv(lp);
-	fc->lp = lp;
+	fc->ctlr.lp = lp;
 	fc->real_dev = netdev;
 	fc->phys_dev = netdev;
 
@@ -179,9 +205,6 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	if (fc_set_mfs(lp, mfs))
 		return -EINVAL;
 
-	if (!fcoe_link_ok(lp))
-		lp->link_up = 1;
-
 	/* offload features support */
 	if (fc->real_dev->features & NETIF_F_SG)
 		lp->sg_supp = 1;
@@ -191,7 +214,7 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	fc->fcoe_pending_queue_active = 0;
 
 	/* setup Source Mac Address */
-	memcpy(fc->ctl_src_addr, fc->real_dev->dev_addr,
+	memcpy(fc->ctlr.ctl_src_addr, fc->real_dev->dev_addr,
 	       fc->real_dev->addr_len);
 
 	wwnn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 1, 0);
@@ -208,9 +231,22 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_add(fc->real_dev, flogi_maddr, ETH_ALEN);
+	dev_mc_add(fc->real_dev, fcoe_all_enodes, ETH_ALEN, 0);
 	rtnl_unlock();
 
 	/*
+	 * Initialize FIP.
+	 */
+	fcoe_ctlr_init(&fc->ctlr);
+	fc->ctlr.send = fcoe_fip_send;
+	fc->ctlr.update_mac = fcoe_update_src_mac;
+
+	fc->fip_packet_type.func = fcoe_fip_recv;
+	fc->fip_packet_type.type = __constant_htons(ETH_P_FIP);
+	fc->fip_packet_type.dev = fc->real_dev;
+	dev_add_pack(&fc->fip_packet_type);
+
+	/*
 	 * setup the receive function from ethernet driver
 	 * on the ethertype for the given device
 	 */
@@ -308,6 +344,8 @@ static int fcoe_sw_destroy(struct net_device *netdev)
 
 	/* Don't listen for Ethernet packets anymore */
 	dev_remove_pack(&fc->fcoe_packet_type);
+	dev_remove_pack(&fc->fip_packet_type);
+	fcoe_ctlr_destroy(&fc->ctlr);
 
 	/* Cleanup the fc_lport */
 	fc_lport_destroy(lp);
@@ -325,8 +363,10 @@ static int fcoe_sw_destroy(struct net_device *netdev)
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_delete(fc->real_dev, flogi_maddr, ETH_ALEN);
-	if (compare_ether_addr(fc->data_src_addr, (u8[6]) { 0 }))
-		dev_unicast_delete(fc->real_dev, fc->data_src_addr, ETH_ALEN);
+	if (!is_zero_ether_addr(fc->ctlr.data_src_addr))
+		dev_unicast_delete(fc->real_dev,
+				   fc->ctlr.data_src_addr, ETH_ALEN);
+	dev_mc_delete(fc->real_dev, fcoe_all_enodes, ETH_ALEN, 0);
 	rtnl_unlock();
 
 	/* Free the per-CPU revieve threads */
@@ -426,6 +466,9 @@ static int fcoe_sw_create(struct net_device *netdev)
 
 	fc_fabric_login(lp);
 
+	if (!fcoe_link_ok(lp))
+		fcoe_ctlr_start(&fc->ctlr);
+
 	dev_hold(netdev);
 
 	return rc;
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 5548bf3..42aa7d5 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -70,7 +70,6 @@ struct fcoe_percpu_s *fcoe_percpu[NR_CPUS];
 
 /* Function Prototyes */
 static int fcoe_check_wait_queue(struct fc_lport *);
-static void fcoe_recv_flogi(struct fcoe_softc *, struct fc_frame *, u8 *);
 #ifdef CONFIG_HOTPLUG_CPU
 static int fcoe_cpu_callback(struct notifier_block *, ulong, void *);
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -104,7 +103,7 @@ static void fcoe_create_percpu_data(int cpu)
 
 	write_lock_bh(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		lp = fc->lp;
+		lp = fc->ctlr.lp;
 		if (lp->dev_stats[cpu] == NULL)
 			lp->dev_stats[cpu] =
 				kzalloc(sizeof(struct fcoe_dev_stats),
@@ -128,7 +127,7 @@ static void fcoe_destroy_percpu_data(int cpu)
 
 	write_lock_bh(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		lp = fc->lp;
+		lp = fc->ctlr.lp;
 		kfree(lp->dev_stats[cpu]);
 		lp->dev_stats[cpu] = NULL;
 	}
@@ -188,11 +187,13 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fcoe_percpu_s *fps;
 
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
-	lp = fc->lp;
+	lp = fc->ctlr.lp;
 	if (unlikely(lp == NULL)) {
 		FC_DBG("cannot find hba structure");
 		goto err2;
 	}
+	if (!lp->link_up)
+		goto err2;
 
 	if (unlikely(debug_fcoe)) {
 		FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
@@ -225,6 +226,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	fr = fcoe_dev_from_skb(skb);
 	fr->fr_dev = lp;
 	fr->ptype = ptype;
+	fr->fr_flags = 0;
 	cpu_idx = 0;
 #ifdef CONFIG_SMP
 	/*
@@ -263,6 +265,28 @@ err2:
 }
 EXPORT_SYMBOL_GPL(fcoe_rcv);
 
+int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
+		  struct packet_type *ptype,
+		  struct net_device *orig_dev)
+{
+	struct fcoe_softc *fc;
+	struct fcoe_rcv_info *fr;
+	struct fcoe_percpu_s *fps;
+
+	fc = container_of(ptype, struct fcoe_softc, fip_packet_type);
+	fr = fcoe_dev_from_skb(skb);
+	fr->fr_dev = fc->ctlr.lp;
+	fr->fr_flags = FCPHF_FIP;
+
+	fps = fcoe_percpu[smp_processor_id()];
+	spin_lock_bh(&fps->fcoe_rx_list.lock);
+	__skb_queue_tail(&fps->fcoe_rx_list, skb);
+	if (fps->fcoe_rx_list.qlen == 1)
+		wake_up_process(fps->thread);
+	spin_unlock_bh(&fps->fcoe_rx_list.lock);
+	return 0;
+}
+
 /**
  * fcoe_start_io() - pass to netdev to start xmit for fcoe
  * @skb: the skb to be xmitted
@@ -379,7 +403,6 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	unsigned int hlen;		/* header length implies the version */
 	unsigned int tlen;		/* trailer length */
 	unsigned int elen;		/* eth header, may include vlan */
-	int flogi_in_progress = 0;
 	struct fcoe_softc *fc;
 	u8 sof, eof;
 	struct fcoe_hdr *hp;
@@ -392,26 +415,18 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	 * and my own fcid
 	 */
 	fh = fc_frame_header_get(fp);
-	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ)) {
-		if (fc_frame_payload_op(fp) == ELS_FLOGI) {
-			fc->flogi_oxid = ntohs(fh->fh_ox_id);
-			fc->address_mode = FCOE_FCOUI_ADDR_MODE;
-			fc->flogi_progress = 1;
-			flogi_in_progress = 1;
-		} else if (fc->flogi_progress && ntoh24(fh->fh_s_id) != 0) {
-			/*
-			 * Here we must've gotten an SID by accepting an FLOGI
-			 * from a point-to-point connection.  Switch to using
-			 * the source mac based on the SID.  The destination
-			 * MAC in this case would have been set by receving the
-			 * FLOGI.
-			 */
-			fc_fcoe_set_mac(fc->data_src_addr, fh->fh_s_id);
-			fc->flogi_progress = 0;
-		}
+	skb = fp_skb(fp);
+	wlen = skb->len / FCOE_WORD_TO_BYTE;
+
+	if (!lp->link_up) {
+		kfree(skb);
+		return 0;
 	}
 
-	skb = fp_skb(fp);
+	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ) &&
+	    fcoe_ctlr_els_send(&fc->ctlr, skb))
+		return 0;
+
 	sof = fr_sof(fp);
 	eof = fr_eof(fp);
 
@@ -466,16 +481,16 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
 	eh->h_proto = htons(ETH_P_FCOE);
-	if (fc->address_mode == FCOE_FCOUI_ADDR_MODE)
+	if (fc->ctlr.map_dest)
 		fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
 	else
 		/* insert GW address */
-		memcpy(eh->h_dest, fc->dest_addr, ETH_ALEN);
+		memcpy(eh->h_dest, fc->ctlr.dest_addr, ETH_ALEN);
 
-	if (unlikely(flogi_in_progress))
-		memcpy(eh->h_source, fc->ctl_src_addr, ETH_ALEN);
+	if (unlikely(fc->ctlr.flogi_oxid != FC_XID_UNKNOWN))
+		memcpy(eh->h_source, fc->ctlr.ctl_src_addr, ETH_ALEN);
 	else
-		memcpy(eh->h_source, fc->data_src_addr, ETH_ALEN);
+		memcpy(eh->h_source, fc->ctlr.data_src_addr, ETH_ALEN);
 
 	hp = (struct fcoe_hdr *)(eh + 1);
 	memset(hp, 0, sizeof(*hp));
@@ -553,6 +568,11 @@ int fcoe_percpu_receive_thread(void *arg)
 			kfree_skb(skb);
 			continue;
 		}
+		fc = fcoe_softc(lp);
+		if (fr->fr_flags & FCPHF_FIP) {
+			fcoe_ctlr_recv(&fc->ctlr, skb);
+			continue;
+		}
 
 		stats = lp->dev_stats[smp_processor_id()];
 
@@ -568,12 +588,9 @@ int fcoe_percpu_receive_thread(void *arg)
 		/*
 		 * Save source MAC address before discarding header.
 		 */
-		fc = lport_priv(lp);
-		if (unlikely(fc->flogi_progress))
-			mac = eth_hdr(skb)->h_source;
-
 		if (skb_is_nonlinear(skb))
 			skb_linearize(skb);	/* not ideal */
+		mac = eth_hdr(skb)->h_source;
 
 		/*
 		 * Frame length checks and setting up the header pointers
@@ -647,73 +664,19 @@ int fcoe_percpu_receive_thread(void *arg)
 			}
 			fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 		}
+		if (unlikely(fc->ctlr.flogi_oxid != FC_XID_UNKNOWN) &&
+		    fcoe_ctlr_recv_flogi(&fc->ctlr, fp, mac)) {
+			fc_frame_free(fp);
+			continue;
+		}
 		/* non flogi and non data exchanges are handled here */
-		if (unlikely(fc->flogi_progress))
-			fcoe_recv_flogi(fc, fp, mac);
 		fc_exch_recv(lp, lp->emp, fp);
 	}
 	return 0;
 }
 
 /**
- * fcoe_recv_flogi() - flogi receive function
- * @fc: associated fcoe_softc
- * @fp: the recieved frame
- * @sa: the source address of this flogi
- *
- * This is responsible to parse the flogi response and sets the corresponding
- * mac address for the initiator, eitehr OUI based or GW based.
- *
- * Returns: none
- */
-static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
-{
-	struct fc_frame_header *fh;
-	u8 op;
-
-	fh = fc_frame_header_get(fp);
-	if (fh->fh_type != FC_TYPE_ELS)
-		return;
-	op = fc_frame_payload_op(fp);
-	if (op == ELS_LS_ACC && fh->fh_r_ctl == FC_RCTL_ELS_REP &&
-	    fc->flogi_oxid == ntohs(fh->fh_ox_id)) {
-		/*
-		 * FLOGI accepted.
-		 * If the src mac addr is FC_OUI-based, then we mark the
-		 * address_mode flag to use FC_OUI-based Ethernet DA.
-		 * Otherwise we use the FCoE gateway addr
-		 */
-		if (!compare_ether_addr(sa, (u8[6]) FC_FCOE_FLOGI_MAC)) {
-			fc->address_mode = FCOE_FCOUI_ADDR_MODE;
-		} else {
-			memcpy(fc->dest_addr, sa, ETH_ALEN);
-			fc->address_mode = FCOE_GW_ADDR_MODE;
-		}
-
-		/*
-		 * Remove any previously-set unicast MAC filter.
-		 * Add secondary FCoE MAC address filter for our OUI.
-		 */
-		rtnl_lock();
-		if (compare_ether_addr(fc->data_src_addr, (u8[6]) { 0 }))
-			dev_unicast_delete(fc->real_dev, fc->data_src_addr,
-					   ETH_ALEN);
-		fc_fcoe_set_mac(fc->data_src_addr, fh->fh_d_id);
-		dev_unicast_add(fc->real_dev, fc->data_src_addr, ETH_ALEN);
-		rtnl_unlock();
-
-		fc->flogi_progress = 0;
-	} else if (op == ELS_FLOGI && fh->fh_r_ctl == FC_RCTL_ELS_REQ && sa) {
-		/*
-		 * Save source MAC for point-to-point responses.
-		 */
-		memcpy(fc->dest_addr, sa, ETH_ALEN);
-		fc->address_mode = FCOE_GW_ADDR_MODE;
-	}
-}
-
-/**
- * fcoe_watchdog() - fcoe timer callback
+ * fcoe_watchdog - fcoe timer callback
  * @vp:
  *
  * This checks the pending queue length for fcoe and set lport qfull
@@ -728,8 +691,8 @@ void fcoe_watchdog(ulong vp)
 
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		if (fc->lp)
-			fcoe_check_wait_queue(fc->lp);
+		if (fc->ctlr.lp)
+			fcoe_check_wait_queue(fc->ctlr.lp);
 	}
 	read_unlock(&fcoe_hostlist_lock);
 
@@ -837,7 +800,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
 		if (fc->real_dev == real_dev) {
-			lp = fc->lp;
+			lp = fc->ctlr.lp;
 			break;
 		}
 	}
@@ -872,12 +835,12 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	}
 	if (lp->link_up != new_link_up) {
 		if (new_link_up)
-			fc_linkup(lp);
+			fcoe_ctlr_start(&fc->ctlr);
 		else {
 			stats = lp->dev_stats[smp_processor_id()];
 			if (stats)
 				stats->LinkFailureCount++;
-			fc_linkdown(lp);
+			fcoe_ctlr_stop(&fc->ctlr);
 			fcoe_clean_pending_queue(lp);
 		}
 	}
@@ -1277,7 +1240,7 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 
 	fc = fcoe_hostlist_lookup_softc(netdev);
 
-	return (fc) ? fc->lp : NULL;
+	return (fc) ? fc->ctlr.lp : NULL;
 }
 EXPORT_SYMBOL_GPL(fcoe_hostlist_lookup);
 
diff --git a/drivers/scsi/libfcoe/Makefile b/drivers/scsi/libfcoe/Makefile
new file mode 100644
index 0000000..46e91da
--- /dev/null
+++ b/drivers/scsi/libfcoe/Makefile
@@ -0,0 +1,6 @@
+# $Id: Makefile
+
+obj-$(CONFIG_LIBFCOE) += libfcoe.o
+
+libfcoe-y := \
+	fcoe_ctlr.o
diff --git a/drivers/scsi/libfcoe/fcoe_ctlr.c b/drivers/scsi/libfcoe/fcoe_ctlr.c
new file mode 100644
index 0000000..42a67e0
--- /dev/null
+++ b/drivers/scsi/libfcoe/fcoe_ctlr.c
@@ -0,0 +1,1206 @@
+/*
+ * Copyright (c) 2008 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+#include <linux/netdevice.h>
+#include <linux/errno.h>
+#include <linux/bitops.h>
+#include <net/rtnetlink.h>
+
+#include <scsi/fc/fc_els.h>
+#include <scsi/fc/fc_fs.h>
+#include <scsi/fc/fc_fip.h>
+#include <scsi/fc/fc_encaps.h>
+#include <scsi/fc/fc_fcoe.h>
+
+#include <scsi/libfc.h>
+#include <scsi/fcoe_ctlr.h>
+
+MODULE_AUTHOR("Joe Eykholt (jeykholt@cisco.com)");
+MODULE_DESCRIPTION("FIP discovery protocol support for FCoE HBAs");
+MODULE_LICENSE("GPL");
+
+#define	FCOE_CTLR_MIN_FKA	500		/* min keep alive (mS) */
+#define	FCOE_CTLR_DEF_FKA	FIP_DEF_FKA	/* default keep alive (mS) */
+
+static void fcoe_ctlr_timeout(unsigned long);
+static void fcoe_ctlr_work(struct work_struct *);
+
+static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
+
+static u32 logging_level;		/* 1 for basic, 2 for noisy debug */
+module_param(logging_level, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(logging_level, "1 for basic, 2 for detailed debug");
+
+#define FIP_DBG_LVL(level, fmt, args...) 				\
+		do {						\
+			if (logging_level >= (level))		\
+				printk(KERN_INFO "%s " fmt, __func__, ##args); \
+		} while (0)
+
+#define FIP_DBG(fmt...)	FIP_DBG_LVL(1, fmt)
+
+/*
+ * Handle unaligned __be64 as two __be32s.
+ */
+static inline u64 fip_ntoh64(__be32 *pp)
+{
+	return ((u64)ntohl(pp[0]) << 32) | ntohl(pp[1]);
+}
+
+/*
+ * Return non-zero if FCF fcoe_size has been validated.
+ */
+static inline int fcoe_ctlr_mtu_valid(const struct fcoe_fcf *fcf)
+{
+	return (fcf->flags & FIP_FL_SOL) != 0;
+}
+
+/*
+ * Return non-zero if the FCF is usable.
+ */
+static inline int fcoe_ctlr_fcf_usable(struct fcoe_fcf *fcf)
+{
+	u16 flags = FIP_FL_SOL | FIP_FL_AVAIL;
+
+	return (fcf->flags & flags) == flags;
+}
+
+/*
+ * Initialize the FCoE Controller instance for an interface.
+ */
+void fcoe_ctlr_init(struct fcoe_ctlr *fip)
+{
+	fip->state = FIP_ST_LINK_WAIT;
+	INIT_LIST_HEAD(&fip->fcfs);
+	spin_lock_init(&fip->lock);
+	fip->flogi_oxid = FC_XID_UNKNOWN;
+	setup_timer(&fip->timer, fcoe_ctlr_timeout, (unsigned long)fip);
+	INIT_WORK(&fip->work, fcoe_ctlr_work);
+}
+EXPORT_SYMBOL(fcoe_ctlr_init);
+
+/*
+ * Reset and free all FCFs.
+ * Called with lock held.
+ */
+static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
+{
+	struct fcoe_fcf *fcf;
+	struct fcoe_fcf *next;
+
+	fip->sel_fcf = NULL;
+	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
+		list_del(&fcf->list);
+		kfree(fcf);
+	}
+	fip->fcf_count = 0;
+	fip->sel_time = 0;
+}
+
+/*
+ * Disable and tear-down the FCoE controller.
+ */
+void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
+{
+	spin_lock_bh(&fip->lock);
+	fip->state = FIP_ST_DISABLED;
+	fcoe_ctlr_reset_fcfs(fip);
+	del_timer_sync(&fip->timer);
+	spin_unlock_bh(&fip->lock);
+}
+EXPORT_SYMBOL(fcoe_ctlr_destroy);
+
+/*
+ * Return the maximum FCoE size required for VN_Port.
+ */
+static inline u32 fcoe_ctlr_fcoe_size(struct fcoe_ctlr *fip)
+{
+	/*
+	 * Determine the max FCoE frame size allowed, including
+	 * FCoE header and trailer.
+	 * Note:  lp->mfs is currently the payload size, not the frame size.
+	 */
+	return fip->lp->mfs + sizeof(struct fc_frame_header) +
+		sizeof(struct fcoe_hdr) + sizeof(struct fcoe_crc_eof);
+}
+
+/*
+ * Send a solicitation to specified FCF or all FCFs if NULL.
+ */
+static void fcoe_ctlr_solicit(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
+{
+	struct sk_buff *skb;
+	struct fip_sol {
+		struct ethhdr eth;
+		struct fip_header fip;
+		struct {
+			struct fip_mac_desc mac;
+			struct fip_wwn_desc wwnn;
+			struct fip_size_desc size;
+		} desc;
+	} *sol;
+	u32 fcoe_size;
+
+	skb = dev_alloc_skb(sizeof(*sol));
+	if (!skb)
+		return;
+
+	sol = (struct fip_sol *)skb->data;
+
+	memset(sol, 0, sizeof(*sol));
+	memcpy(sol->eth.h_dest, fcf ? fcf->fcf_mac : fcoe_all_fcfs, ETH_ALEN);
+	memcpy(sol->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
+	sol->eth.h_proto = __constant_htons(ETH_P_FIP);
+
+	sol->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
+	sol->fip.fip_op = __constant_htons(FIP_OP_DISC);
+	sol->fip.fip_subcode = FIP_SC_SOL;
+	sol->fip.fip_dl_len = __constant_htons(sizeof(sol->desc) / FIP_BPW);
+	sol->fip.fip_flags = __constant_htons(FIP_FL_FPMA);
+
+	sol->desc.mac.fd_desc.fip_dtype = FIP_DT_MAC;
+	sol->desc.mac.fd_desc.fip_dlen = sizeof(sol->desc.mac) / FIP_BPW;
+	memcpy(sol->desc.mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
+
+	sol->desc.wwnn.fd_desc.fip_dtype = FIP_DT_NAME;
+	sol->desc.wwnn.fd_desc.fip_dlen = sizeof(sol->desc.wwnn) / FIP_BPW;
+	sol->desc.wwnn.fd_wwn[0] = ntohl(fip->lp->wwnn >> 32);
+	sol->desc.wwnn.fd_wwn[1] = ntohl(fip->lp->wwnn & 0xffffffff);
+
+	fcoe_size = fcoe_ctlr_fcoe_size(fip);
+	sol->desc.size.fd_desc.fip_dtype = FIP_DT_FCOE_SIZE;
+	sol->desc.size.fd_desc.fip_dlen = sizeof(sol->desc.size) / FIP_BPW;
+	sol->desc.size.fd_size = htons(fcoe_size);
+
+	skb_put(skb, sizeof(*sol));
+	skb->protocol = __constant_htons(ETH_P_802_3);
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	fip->send(fip, skb);
+
+	if (!fcf)
+		fip->sol_time = jiffies;
+}
+
+/*
+ * Start FCoE controller.
+ * Called when network link is ready.
+ */
+void fcoe_ctlr_start(struct fcoe_ctlr *fip)
+{
+	spin_lock_bh(&fip->lock);
+	if (fip->state == FIP_ST_NON_FIP || fip->state == FIP_ST_AUTO) {
+		fip->last_link = 1;
+		fip->link = 1;
+		spin_unlock_bh(&fip->lock);
+		fc_linkup(fip->lp);
+	} else if (fip->state == FIP_ST_LINK_WAIT) {
+		fip->state = FIP_ST_AUTO;
+		fip->last_link = 1;
+		fip->link = 1;
+		spin_unlock_bh(&fip->lock);
+		FIP_DBG("setting AUTO mode.\n");
+		fc_linkup(fip->lp);
+		fcoe_ctlr_solicit(fip, NULL);
+	} else
+		spin_unlock_bh(&fip->lock);
+}
+EXPORT_SYMBOL(fcoe_ctlr_start);
+
+/*
+ * Reset FIP.
+ * Returns non-zero if the link was up and now isn't.
+ */
+static int fcoe_ctlr_reset(struct fcoe_ctlr *fip, enum fip_state new_state)
+{
+	struct fc_lport *lp = fip->lp;
+	int link_dropped;
+
+	spin_lock_bh(&fip->lock);
+	fcoe_ctlr_reset_fcfs(fip);
+	del_timer(&fip->timer);
+	fip->state = new_state;
+	fip->ctlr_ka_time = 0;
+	fip->port_ka_time = 0;
+	fip->sel_time = 0;
+	fip->sol_time = 0;
+	fip->flogi_oxid = FC_XID_UNKNOWN;
+	fip->map_dest = 0;
+	fip->last_link = 0;
+	link_dropped = fip->link;
+	fip->link = 0;
+	spin_unlock_bh(&fip->lock);
+
+	if (link_dropped)
+		fc_linkdown(lp);
+
+	if (new_state == FIP_ST_ENABLED) {
+		fcoe_ctlr_solicit(fip, NULL);
+		fc_linkup(lp);
+		link_dropped = 0;
+	}
+	return link_dropped;
+}
+
+/*
+ * Stop FCoE controller.
+ * Called when network link is not ready.
+ */
+int fcoe_ctlr_stop(struct fcoe_ctlr *fip)
+{
+	return fcoe_ctlr_reset(fip, FIP_ST_LINK_WAIT);
+}
+EXPORT_SYMBOL(fcoe_ctlr_stop);
+
+/*
+ * Send an N-port keep-alive to the selected FCF.
+ * This is sent every 90 seconds while logged in.
+ * The source MAC is the assigned mapped source address.
+ * The destination is the FCF's F-port.
+ */
+static void fcoe_ctlr_port_keep_alive(struct fcoe_ctlr *fip)
+{
+	struct sk_buff *skb;
+	struct fip_kal {
+		struct ethhdr eth;
+		struct fip_header fip;
+		struct {
+			struct fip_mac_desc mac;
+			struct fip_vn_desc vn;
+		} desc;
+	} *kal;
+	u32 len;
+	struct fc_lport *lp;
+	struct fcoe_fcf *fcf;
+
+	fcf = fip->sel_fcf;
+	lp = fip->lp;
+	if (!fcf || !fc_host_port_id(lp->host))
+		return;
+
+	len = fcoe_ctlr_fcoe_size(fip) + sizeof(struct ethhdr);
+	skb = dev_alloc_skb(len);
+	if (!skb)
+		return;
+
+	kal = (struct fip_kal *)skb->data;
+	memset(kal, 0, len);
+	memcpy(kal->eth.h_dest, fcf->fcf_mac, ETH_ALEN);
+	memcpy(kal->eth.h_source, fip->data_src_addr, ETH_ALEN);
+	kal->eth.h_proto = __constant_htons(ETH_P_FIP);
+
+	kal->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
+	kal->fip.fip_op = __constant_htons(FIP_OP_CTRL);
+	kal->fip.fip_subcode = FIP_SC_KEEP_ALIVE;
+	kal->fip.fip_dl_len = __constant_htons(sizeof(kal->desc) / FIP_BPW);
+	kal->fip.fip_flags = __constant_htons(FIP_FL_FPMA);
+
+	kal->desc.mac.fd_desc.fip_dtype = FIP_DT_MAC;
+	kal->desc.mac.fd_desc.fip_dlen = sizeof(kal->desc.mac) / FIP_BPW;
+	memcpy(kal->desc.mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
+
+	kal->desc.vn.fd_desc.fip_dtype = FIP_DT_VN_ID;
+	kal->desc.vn.fd_desc.fip_dlen = sizeof(kal->desc.vn) / FIP_BPW;
+	memcpy(kal->desc.vn.fd_mac, fip->data_src_addr, ETH_ALEN);
+	hton24(kal->desc.vn.fd_fc_id, fc_host_port_id(lp->host));
+	kal->desc.vn.fd_wwpn[0] = ntohl(lp->wwpn >> 32);
+	kal->desc.vn.fd_wwpn[1] = ntohl(lp->wwpn & 0xffffffff);
+
+	skb_put(skb, len);
+	skb->protocol = __constant_htons(ETH_P_802_3);
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	fip->send(fip, skb);
+}
+
+/*
+ * Send an fcoe_ctlr keep-alive to the selected FCF.
+ * The source MAC is the native control source address.
+ * The destination is the FCF's F-port address.
+ */
+static void fcoe_ctlr_keep_alive(struct fcoe_ctlr *fip)
+{
+	struct sk_buff *skb;
+	struct fip_kal {
+		struct ethhdr eth;
+		struct fip_header fip;
+		struct {
+			struct fip_mac_desc mac;
+		} desc;
+	} *kal;
+	u32 len;
+	struct fc_lport *lp;
+	struct fcoe_fcf *fcf;
+
+	fcf = fip->sel_fcf;
+	lp = fip->lp;
+	if (!fcf || !fc_host_port_id(lp->host))
+		return;
+
+	len = fcoe_ctlr_fcoe_size(fip) + sizeof(struct ethhdr);
+	skb = dev_alloc_skb(len);
+	if (!skb)
+		return;
+
+	kal = (struct fip_kal *)skb->data;
+	memset(kal, 0, len);
+	memcpy(kal->eth.h_dest, fcf->fcf_mac, ETH_ALEN);
+	memcpy(kal->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
+	kal->eth.h_proto = __constant_htons(ETH_P_FIP);
+
+	kal->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
+	kal->fip.fip_op = __constant_htons(FIP_OP_CTRL);
+	kal->fip.fip_subcode = FIP_SC_KEEP_ALIVE;
+	kal->fip.fip_dl_len = __constant_htons(sizeof(kal->desc) / FIP_BPW);
+	kal->fip.fip_flags = __constant_htons(FIP_FL_FPMA);
+
+	kal->desc.mac.fd_desc.fip_dtype = FIP_DT_MAC;
+	kal->desc.mac.fd_desc.fip_dlen = sizeof(kal->desc.mac) / FIP_BPW;
+	memcpy(kal->desc.mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
+
+	skb_put(skb, len);
+	skb->protocol = __constant_htons(ETH_P_802_3);
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	fip->send(fip, skb);
+}
+
+/*
+ * Encapsulate an ELS frame for FIP, without sending it.
+ *
+ * Returns non-zero error code on failure.
+ * The caller must check that the length is a multiple of 4.
+ * The SKB must have enough headroom (28 bytes) and tailroom (8).
+ */
+static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip,
+			    u8 dtype, struct sk_buff *skb)
+{
+	struct fip_encaps_head {
+		struct ethhdr eth;
+		struct fip_header fip;
+		struct fip_encaps encaps;
+	} *cap;
+	struct fip_mac_desc *mac;
+	struct fcoe_fcf *fcf;
+	size_t dlen;
+
+	fcf = fip->sel_fcf;
+	if (!fcf)
+		return ENODEV;
+	dlen = sizeof(struct fip_encaps) + skb->len;	/* len before push */
+	cap = (struct fip_encaps_head *)skb_push(skb, sizeof(*cap));
+
+	memset(cap, 0, sizeof(*cap));
+	memcpy(cap->eth.h_dest, fcf->fcf_mac, ETH_ALEN);
+	memcpy(cap->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
+	cap->eth.h_proto = __constant_htons(ETH_P_FIP);
+
+	cap->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
+	cap->fip.fip_op = __constant_htons(FIP_OP_LS);
+	cap->fip.fip_subcode = FIP_SC_REQ;
+	cap->fip.fip_dl_len = htons((dlen + sizeof(*mac)) / FIP_BPW);
+	cap->fip.fip_flags = __constant_htons(FIP_FL_FPMA);
+
+	cap->encaps.fd_desc.fip_dtype = dtype;
+	cap->encaps.fd_desc.fip_dlen = dlen / FIP_BPW;
+
+	mac = (struct fip_mac_desc *)skb_put(skb, sizeof(*mac));
+	memset(mac, 0, sizeof(mac));
+	mac->fd_desc.fip_dtype = FIP_DT_MAC;
+	mac->fd_desc.fip_dlen = sizeof(*mac) / FIP_BPW;
+	if (dtype != ELS_FLOGI)
+		memcpy(mac->fd_mac, fip->data_src_addr, ETH_ALEN);
+
+	skb->protocol = __constant_htons(ETH_P_802_3);
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	return 0;
+}
+
+/*
+ * Send an ELS frame encapsulated by FIP if appropriate.
+ *
+ * Returns error code if frame should not be sent.
+ * Returns zero if the caller should send the frame with FCoE encapsulation.
+ *
+ * The caller must check that the length is a multiple of 4.
+ * The SKB must have enough headroom (28 bytes) and tailroom (8).
+ */
+int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	struct fc_frame_header *fh;
+	u16 old_xid;
+	u8 op;
+
+	if (fip->state == FIP_ST_NON_FIP)
+		return 0;
+
+	fh = (struct fc_frame_header *)skb->data;
+	op = *(u8 *)(fh + 1);
+
+	switch (op) {
+	case ELS_FLOGI:
+		old_xid = fip->flogi_oxid;
+		fip->flogi_oxid = ntohs(fh->fh_ox_id);
+		if (fip->state == FIP_ST_AUTO) {
+			if (old_xid == FC_XID_UNKNOWN)
+				fip->flogi_count = 0;
+			fip->flogi_count++;
+			if (fip->flogi_count < 3)
+				goto drop;
+			fip->map_dest = 1;
+			return 0;
+		}
+		op = FIP_DT_FLOGI;
+		break;
+	case ELS_FDISC:
+		if (ntoh24(fh->fh_s_id))
+			return 0;
+		op = FIP_DT_FDISC;
+		break;
+	case ELS_LOGO:
+		if (fip->state != FIP_ST_ENABLED)
+			return 0;
+		if (ntoh24(fh->fh_d_id) != FC_FID_FLOGI)
+			return 0;
+		op = FIP_DT_LOGO;
+		break;
+	case ELS_LS_ACC:
+		if (fip->flogi_oxid == FC_XID_UNKNOWN)
+			return 0;
+		if (!ntoh24(fh->fh_s_id))
+			return 0;
+		if (fip->state == FIP_ST_AUTO)
+			return 0;
+		/*
+		 * Here we must've gotten an SID by accepting an FLOGI
+		 * from a point-to-point connection.  Switch to using
+		 * the source mac based on the SID.  The destination
+		 * MAC in this case would have been set by receving the
+		 * FLOGI.
+		 */
+		fip->flogi_oxid = FC_XID_UNKNOWN;
+		fc_fcoe_set_mac(fip->data_src_addr, fh->fh_s_id);
+		return 0;
+	default:
+		if (fip->state != FIP_ST_ENABLED)
+			goto drop;
+		return 0;
+	}
+	if (fcoe_ctlr_encaps(fip, op, skb))
+		goto drop;
+	fip->send(fip, skb);
+	return EINPROGRESS;
+drop:
+	kfree_skb(skb);
+	return EINVAL;
+}
+EXPORT_SYMBOL(fcoe_ctlr_els_send);
+
+/*
+ * Reset and free all old FCFs.
+ * Called with lock held.
+ */
+static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
+{
+	struct fcoe_fcf *fcf;
+	struct fcoe_fcf *next;
+	unsigned long sel_time = 0;
+
+	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
+		if (time_after(jiffies, fcf->time + fcf->fka_period * 3 +
+			       msecs_to_jiffies(FIP_FCF_FUZZ * 3))) {
+			if (fip->sel_fcf == fcf)
+				fip->sel_fcf = NULL;
+			list_del(&fcf->list);
+			WARN_ON(!fip->fcf_count);
+			fip->fcf_count--;
+			kfree(fcf);
+		} else if (fcoe_ctlr_mtu_valid(fcf) &&
+			   (!sel_time || time_before(sel_time, fcf->time))) {
+			sel_time = fcf->time;
+		}
+	}
+	if (sel_time) {
+		sel_time += msecs_to_jiffies(FCOE_CTLR_START_DELAY);
+		fip->sel_time = sel_time;
+		if (time_before(sel_time, fip->timer.expires))
+			mod_timer(&fip->timer, sel_time);
+	} else {
+		fip->sel_time = 0;
+	}
+}
+
+/*
+ * Decode a FIP advertisement into a new FCF entry.
+ */
+static struct fcoe_fcf *fcoe_ctlr_parse_adv(struct sk_buff *skb)
+{
+	struct fip_header *fiph;
+	struct fcoe_fcf *fcf;
+	struct fip_desc *desc = NULL;
+	struct fip_wwn_desc *wwn;
+	struct fip_fab_desc *fab;
+	struct fip_fka_desc *fka;
+	unsigned long t;
+	size_t rlen;
+	size_t dlen;
+
+	fcf = kzalloc(sizeof(*fcf), GFP_ATOMIC);
+	if (!fcf)
+		return fcf;
+	fcf->fka_period = msecs_to_jiffies(FCOE_CTLR_DEF_FKA);
+
+	fiph = (struct fip_header *)skb->data;
+	fcf->flags = ntohs(fiph->fip_flags);
+
+	rlen = ntohs(fiph->fip_dl_len) * 4;
+	if (rlen + sizeof(*fiph) > skb->len)
+		goto bad_adv;
+
+	desc = (struct fip_desc *)(fiph + 1);
+	while (rlen > 0) {
+		dlen = desc->fip_dlen * FIP_BPW;
+		if (dlen < sizeof(*desc) || dlen > rlen)
+			goto bad_adv;
+		switch (desc->fip_dtype) {
+		case FIP_DT_PRI:
+			if (dlen != sizeof(struct fip_pri_desc))
+				goto len_err;
+			fcf->pri = ((struct fip_pri_desc *)desc)->fd_pri;
+			break;
+		case FIP_DT_MAC:
+			if (dlen != sizeof(struct fip_mac_desc))
+				goto len_err;
+			memcpy(fcf->fcf_mac,
+			       ((struct fip_mac_desc *)desc)->fd_mac,
+			       ETH_ALEN);
+			if (!is_valid_ether_addr(fcf->fcf_mac)) {
+				FIP_DBG("invalid MAC addr in FIP adv\n");
+				goto bad_adv;
+			}
+			break;
+		case FIP_DT_NAME:
+			if (dlen != sizeof(struct fip_wwn_desc))
+				goto len_err;
+			wwn = (struct fip_wwn_desc *)desc;
+			fcf->switch_name = fip_ntoh64(wwn->fd_wwn);
+			break;
+		case FIP_DT_FAB:
+			if (dlen != sizeof(struct fip_fab_desc))
+				goto len_err;
+			fab = (struct fip_fab_desc *)desc;
+			fcf->fabric_name = fip_ntoh64(fab->fd_wwn);
+			fcf->vfid = ntohs(fab->fd_vfid);
+			fcf->fc_map = ntoh24(fab->fd_map);
+			break;
+		case FIP_DT_FKA:
+			if (dlen != sizeof(struct fip_fka_desc))
+				goto len_err;
+			fka = (struct fip_fka_desc *)desc;
+			t = ntohl(fka->fd_fka_period);
+			if (t >= FCOE_CTLR_MIN_FKA)
+				fcf->fka_period = msecs_to_jiffies(t);
+			break;
+		case FIP_DT_MAP_OUI:
+		case FIP_DT_FCOE_SIZE:
+		case FIP_DT_FLOGI:
+		case FIP_DT_FDISC:
+		case FIP_DT_LOGO:
+		case FIP_DT_ELP:
+		default:
+			FIP_DBG("unexpected descriptor type %x in FIP adv\n",
+				  desc->fip_dtype);
+			/* standard says ignore unknown descriptors >= 128 */
+			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
+				goto bad_adv;
+			continue;
+		}
+		desc = (struct fip_desc *)((char *)desc + dlen);
+		rlen -= dlen;
+	}
+	if (!fcf->fc_map || (fcf->fc_map & 0x10000))
+		goto bad_adv;
+	if (!fcf->switch_name || !fcf->fabric_name)
+		goto bad_adv;
+	return fcf;
+
+len_err:
+	FIP_DBG("FIP length error in descriptor type %x len %zu\n",
+		  desc->fip_dtype, dlen);
+bad_adv:
+	kfree(fcf);
+	return NULL;
+}
+
+/*
+ * Handle an incoming advertisement.
+ */
+static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	struct fcoe_fcf *fcf;
+	struct fcoe_fcf *new;
+	struct fcoe_fcf *found;
+	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTRL_SOL_TOV);
+	int first = 0;
+	int mtu_valid;
+
+	new = fcoe_ctlr_parse_adv(skb);
+	if (!new)
+		return;
+
+	spin_lock_bh(&fip->lock);
+	first = list_empty(&fip->fcfs);
+	found = NULL;
+	list_for_each_entry(fcf, &fip->fcfs, list) {
+		if (fcf->switch_name == new->switch_name &&
+		    fcf->fabric_name == new->fabric_name &&
+		    fcf->fc_map == new->fc_map &&
+		    compare_ether_addr(fcf->fcf_mac, new->fcf_mac) == 0) {
+			found = fcf;
+			break;
+		}
+	}
+	if (!found) {
+		if (fip->fcf_count >= FCOE_CTLR_FCF_LIMIT) {
+			spin_unlock_bh(&fip->lock);
+			kfree(new);
+			return;
+		}
+		fip->fcf_count++;
+		fcf = new;
+		list_add(&fcf->list, &fip->fcfs);
+	} else {
+		/*
+		 * Once we've received a solicited advertisement, we should
+		 * ignore the flags from multicast advertisments.
+		 */
+		if ((new->flags & FIP_FL_SOL) || !(fcf->flags & FIP_FL_SOL))
+			fcf->flags = new->flags;
+
+		if (fcf == fip->sel_fcf) {
+			fip->ctlr_ka_time -= fcf->fka_period;
+			fip->ctlr_ka_time += new->fka_period;
+			if (time_before(fip->ctlr_ka_time, fip->timer.expires))
+				mod_timer(&fip->timer, fip->ctlr_ka_time);
+		}
+		fcf->fka_period = new->fka_period;
+		memcpy(fcf->fcf_mac, new->fcf_mac, ETH_ALEN);
+		kfree(new);
+	}
+	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
+	fcf->time = jiffies;
+	FIP_DBG_LVL(found ? 2 : 1, "%s FCF for fab %llx map %x val %d\n",
+		      found ? "old" : "new",
+		      fcf->fabric_name, fcf->fc_map, mtu_valid);
+
+	/*
+	 * If this advertisement is not solicited and our max receive size
+	 * hasn't been verified, send a solicited advertisement.
+	 */
+	if (!mtu_valid)
+		fcoe_ctlr_solicit(fip, fcf);
+
+	/*
+	 * If its been a while since we did a solicit, and this is
+	 * the first advertisement we've received, do a multicast
+	 * solicitation to gather as many advertisements as we can
+	 * before selection occurs.
+	 */
+	if (first && time_after(jiffies, fip->sol_time + sol_tov))
+		fcoe_ctlr_solicit(fip, NULL);
+
+	/*
+	 * If this is the first validated FCF, note the time and
+	 * set a timer to trigger selection.
+	 */
+	if (mtu_valid && !fip->sel_time && fcoe_ctlr_fcf_usable(fcf)) {
+		fip->sel_time = jiffies +
+				msecs_to_jiffies(FCOE_CTLR_START_DELAY);
+		if (!timer_pending(&fip->timer) ||
+		    time_before(fip->sel_time, fip->timer.expires))
+			mod_timer(&fip->timer, fip->sel_time);
+	}
+	spin_unlock_bh(&fip->lock);
+}
+
+static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	struct fc_lport *lp = fip->lp;
+	struct fip_header *fiph;
+	struct fc_frame *fp;
+	struct fc_frame_header *fh = NULL;
+	struct fip_desc *desc;
+	struct fip_encaps *els;
+	struct fcoe_dev_stats *stats;
+	enum fip_desc_type els_dtype = 0;
+	u8 els_op;
+	u8 sub;
+	u8 granted_mac[ETH_ALEN] = { 0 };
+	size_t els_len = 0;
+	size_t rlen;
+	size_t dlen;
+
+	fiph = (struct fip_header *)skb->data;
+	sub = fiph->fip_subcode;
+	if (sub != FIP_SC_REQ && sub != FIP_SC_REP)
+		goto drop;
+
+	rlen = ntohs(fiph->fip_dl_len) * 4;
+	if (rlen + sizeof(*fiph) > skb->len)
+		goto drop;
+
+	desc = (struct fip_desc *)(fiph + 1);
+	while (rlen > 0) {
+		dlen = desc->fip_dlen * FIP_BPW;
+		if (dlen < sizeof(*desc) || dlen > rlen)
+			goto drop;
+		switch (desc->fip_dtype) {
+		case FIP_DT_MAC:
+			if (dlen != sizeof(struct fip_mac_desc))
+				goto len_err;
+			memcpy(granted_mac,
+			       ((struct fip_mac_desc *)desc)->fd_mac,
+			       ETH_ALEN);
+			if (!is_valid_ether_addr(granted_mac)) {
+				FIP_DBG("invalid MAC addr in FIP ELS\n");
+				goto drop;
+			}
+			break;
+		case FIP_DT_FLOGI:
+		case FIP_DT_FDISC:
+		case FIP_DT_LOGO:
+		case FIP_DT_ELP:
+			if (fh)
+				goto drop;
+			if (dlen < sizeof(*els) + sizeof(*fh) + 1)
+				goto len_err;
+			els_len = dlen - sizeof(*els);
+			els = (struct fip_encaps *)desc;
+			fh = (struct fc_frame_header *)(els + 1);
+			els_dtype = desc->fip_dtype;
+			break;
+		default:
+			FIP_DBG("unexpected descriptor type %x "
+				    "in FIP adv\n", desc->fip_dtype);
+			/* standard says ignore unknown descriptors >= 128 */
+			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
+				goto drop;
+			continue;
+		}
+		desc = (struct fip_desc *)((char *)desc + dlen);
+		rlen -= dlen;
+	}
+
+	if (!fh)
+		goto drop;
+	els_op = *(u8 *)(fh + 1);
+
+	if (els_dtype == FIP_DT_FLOGI && sub == FIP_SC_REP &&
+	    fip->flogi_oxid == ntohs(fh->fh_ox_id) &&
+	    els_op == ELS_LS_ACC && is_valid_ether_addr(granted_mac)) {
+		fip->flogi_oxid = FC_XID_UNKNOWN;
+		fip->update_mac(fip, fip->data_src_addr, granted_mac);
+		memcpy(fip->data_src_addr, granted_mac, ETH_ALEN);
+	}
+
+	/*
+	 * Convert skb into an fc_frame containing only the ELS.
+	 */
+	skb_pull(skb, (u8 *)fh - skb->data);
+	skb_trim(skb, els_len);
+	fp = (struct fc_frame *)skb;
+	fc_frame_init(fp);
+	fr_sof(fp) = FC_SOF_I3;
+	fr_eof(fp) = FC_EOF_T;
+	fr_dev(fp) = lp;
+
+	stats = lp->dev_stats[smp_processor_id()];
+	stats->RxFrames++;
+	stats->RxWords += skb->len / FIP_BPW;
+	fc_exch_recv(lp, lp->emp, fp);
+	return;
+
+len_err:
+	FIP_DBG("FIP length error in descriptor type %x len %zu\n",
+		  desc->fip_dtype, dlen);
+drop:
+	kfree_skb(skb);
+}
+
+/*
+ * Handle an incoming link reset.
+ * There may be multiple VN_Port descriptors.
+ * The overall length has already been checked.
+ */
+static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
+				      struct fip_header *fh)
+{
+	struct fip_desc *desc;
+	struct fip_mac_desc *mp;
+	struct fip_wwn_desc *wp;
+	struct fip_vn_desc *vp;
+	size_t rlen;
+	size_t dlen;
+	struct fcoe_fcf *fcf = fip->sel_fcf;
+	struct fc_lport *lp = fip->lp;
+	u32	desc_mask;
+
+	FIP_DBG("Clear Virtual Link received\n");
+	if (!fcf)
+		return;
+	if (!fcf || !fc_host_port_id(lp->host))
+		return;
+
+	/*
+	 * mask of required descriptors.  Validating each one clears its bit.
+	 */
+	desc_mask = BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME) | BIT(FIP_DT_VN_ID);
+
+	rlen = ntohs(fh->fip_dl_len) * FIP_BPW;
+	desc = (struct fip_desc *)(fh + 1);
+	while (rlen >= sizeof(*desc)) {
+		dlen = desc->fip_dlen * FIP_BPW;
+		if (dlen > rlen)
+			return;
+		switch (desc->fip_dtype) {
+		case FIP_DT_MAC:
+			mp = (struct fip_mac_desc *)desc;
+			if (dlen < sizeof(*mp))
+				return;
+			if (compare_ether_addr(mp->fd_mac, fcf->fcf_mac))
+				return;
+			desc_mask &= ~BIT(FIP_DT_MAC);
+			break;
+		case FIP_DT_NAME:
+			wp = (struct fip_wwn_desc *)desc;
+			if (dlen < sizeof(*wp))
+				return;
+			if (fip_ntoh64(wp->fd_wwn) != fcf->switch_name)
+				return;
+			desc_mask &= ~BIT(FIP_DT_NAME);
+			break;
+		case FIP_DT_VN_ID:
+			vp = (struct fip_vn_desc *)desc;
+			if (dlen < sizeof(*vp))
+				return;
+			if (compare_ether_addr(vp->fd_mac,
+			    fip->data_src_addr) == 0 &&
+			    fip_ntoh64(vp->fd_wwpn) == lp->wwpn &&
+			    ntoh24(vp->fd_fc_id) == fc_host_port_id(lp->host))
+				desc_mask &= ~BIT(FIP_DT_VN_ID);
+			break;
+		default:
+			/* standard says ignore unknown descriptors >= 128 */
+			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
+				return;
+			break;
+		}
+		desc = (struct fip_desc *)((char *)desc + dlen);
+		rlen -= dlen;
+	}
+
+	/*
+	 * reset only if all required descriptors were present and valid.
+	 */
+	if (desc_mask) {
+		FIP_DBG("missing descriptors mask %x\n", desc_mask);
+	} else {
+		FIP_DBG("performing Clear Virtual Link\n");
+		fcoe_ctlr_reset(fip, FIP_ST_ENABLED);
+	}
+}
+
+/*
+ * Receive a FIP frame.
+ * This is called from NET_RX_SOFTIRQ.
+ */
+int fcoe_ctlr_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	struct fip_header *fiph;
+	struct ethhdr *eh;
+	enum fip_state state;
+	u16 op;
+	u8 sub;
+
+	if (skb_linearize(skb))
+		goto drop;
+	if (skb->len < sizeof(*fiph))
+		goto drop;
+	eh = eth_hdr(skb);
+	if (compare_ether_addr(eh->h_dest, fip->ctl_src_addr) &&
+	    compare_ether_addr(eh->h_dest, FIP_ALL_ENODE_MACS))
+		goto drop;
+	fiph = (struct fip_header *)skb->data;
+	op = ntohs(fiph->fip_op);
+	sub = fiph->fip_subcode;
+
+	FIP_DBG_LVL(2, "ver %x op %x/%x dl %x fl %x\n",
+		      FIP_VER_DECAPS(fiph->fip_ver), op, sub,
+		      ntohs(fiph->fip_dl_len), ntohs(fiph->fip_flags));
+
+	if (FIP_VER_DECAPS(fiph->fip_ver) != FIP_VER)
+		goto drop;
+	if (ntohs(fiph->fip_dl_len) * FIP_BPW + sizeof(*fiph) > skb->len)
+		goto drop;
+
+	spin_lock_bh(&fip->lock);
+	state = fip->state;
+	if (state == FIP_ST_AUTO) {
+		fip->map_dest = 0;
+		fip->state = FIP_ST_ENABLED;
+		state = FIP_ST_ENABLED;
+		FIP_DBG("using FIP mode\n");
+	}
+	spin_unlock_bh(&fip->lock);
+	if (state != FIP_ST_ENABLED)
+		goto drop;
+
+	if (op == FIP_OP_LS) {
+		fcoe_ctlr_recv_els(fip, skb);	/* consumes skb */
+		return 0;
+	}
+	if (op == FIP_OP_DISC && sub == FIP_SC_ADV)
+		fcoe_ctlr_recv_adv(fip, skb);
+	else if (op == FIP_OP_CTRL && sub == FIP_SC_CLR_VLINK)
+		fcoe_ctlr_recv_clr_vlink(fip, fiph);
+	kfree_skb(skb);
+	return 0;
+drop:
+	kfree_skb(skb);
+	return -1;
+}
+EXPORT_SYMBOL(fcoe_ctlr_recv);
+
+/*
+ * Choose the best FCF, if possible.
+ * If there are conflicting advertisements, no FCF can be chosen.
+ *
+ * Called with lock held.
+ */
+static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
+{
+	struct fcoe_fcf *fcf;
+	struct fcoe_fcf *best = NULL;
+
+	list_for_each_entry(fcf, &fip->fcfs, list) {
+		FIP_DBG_LVL(1, "consider FCF for fab %llx "
+			      "VFID %d map %x val %d\n",
+			      fcf->fabric_name, fcf->vfid,
+			      fcf->fc_map, fcoe_ctlr_mtu_valid(fcf));
+		if (!fcoe_ctlr_fcf_usable(fcf)) {
+			FIP_DBG_LVL(1, "FCF for fab %llx "
+				      "map %x %svalid %savailable\n",
+				      fcf->fabric_name, fcf->fc_map,
+				      (fcf->flags & FIP_FL_SOL) ? "" : "in",
+				      (fcf->flags & FIP_FL_AVAIL) ? "" : "un");
+			continue;
+		}
+		if (!best) {
+			best = fcf;
+			continue;
+		}
+		if (fcf->fabric_name != best->fabric_name ||
+		    fcf->vfid != best->vfid ||
+		    fcf->fc_map != best->fc_map) {
+			FIP_DBG("conflicting fabric, VFID, or FC-MAP\n");
+			return;
+		}
+		if (fcf->pri < best->pri)
+			best = fcf;
+	}
+	fip->sel_fcf = best;
+}
+
+static void fcoe_ctlr_timeout(unsigned long arg)
+{
+	struct fcoe_ctlr *fip = (struct fcoe_ctlr *)arg;
+	struct fcoe_fcf *sel;
+	struct fcoe_fcf *fcf;
+	unsigned long next_timer = jiffies + msecs_to_jiffies(FIP_VN_KA_PERIOD);
+	DECLARE_MAC_BUF(buf);
+	u8 send_ctlr_ka;
+	u8 send_port_ka;
+
+	spin_lock_bh(&fip->lock);
+	fcf = fip->sel_fcf;
+	fcoe_ctlr_age_fcfs(fip);
+
+	sel = fip->sel_fcf;
+	if (!sel && fip->sel_time && time_after_eq(jiffies, fip->sel_time)) {
+		fcoe_ctlr_select(fip);
+		sel = fip->sel_fcf;
+		fip->sel_time = 0;
+	}
+
+	if (sel != fcf) {
+		fcf = sel;		/* the old FCF may have been freed */
+		if (sel) {
+			printk(KERN_INFO "host%d: FIP selected "
+			       "Fibre-Channel Forwarder MAC %s\n",
+			       fip->lp->host->host_no,
+			       print_mac(buf, sel->fcf_mac));
+			memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
+			fip->port_ka_time = jiffies +
+					    msecs_to_jiffies(FIP_VN_KA_PERIOD);
+			fip->ctlr_ka_time = jiffies + sel->fka_period;
+			fip->link = 1;
+		} else {
+			printk(KERN_NOTICE "host%d: "
+			       "FIP Fibre-Channel Forwarder timed out.  "
+			       "Starting FCF discovery.\n",
+			       fip->lp->host->host_no);
+			fip->link = 0;
+		}
+		schedule_work(&fip->work);
+	}
+
+	send_ctlr_ka = 0;
+	send_port_ka = 0;
+	if (sel) {
+		if (time_after_eq(jiffies, fip->ctlr_ka_time)) {
+			fip->ctlr_ka_time = jiffies + sel->fka_period;
+			send_ctlr_ka = 1;
+		}
+		if (time_after(next_timer, fip->ctlr_ka_time))
+			next_timer = fip->ctlr_ka_time;
+
+		if (time_after_eq(jiffies, fip->port_ka_time)) {
+			fip->port_ka_time += jiffies +
+					msecs_to_jiffies(FIP_VN_KA_PERIOD);
+			send_port_ka = 1;
+		}
+		if (time_after(next_timer, fip->port_ka_time))
+			next_timer = fip->port_ka_time;
+		mod_timer(&fip->timer, next_timer);
+	} else if (fip->sel_time) {
+		next_timer = fip->sel_time +
+				msecs_to_jiffies(FCOE_CTLR_START_DELAY);
+		mod_timer(&fip->timer, next_timer);
+	}
+	spin_unlock_bh(&fip->lock);
+
+	if (send_ctlr_ka)
+		fcoe_ctlr_keep_alive(fip);
+	if (send_port_ka)
+		fcoe_ctlr_port_keep_alive(fip);
+}
+
+/*
+ * Worker thread function.
+ * See if the link status has changed and if so, report it.
+ *
+ * This is here because fc_linkup() and fc_linkdown() must not
+ * be called from the timer directly, since it uses a mutex.
+ */
+static void fcoe_ctlr_work(struct work_struct *work)
+{
+	struct fcoe_ctlr *fip;
+	int link;
+	int last_link;
+
+	fip = container_of(work, struct fcoe_ctlr, work);
+	spin_lock_bh(&fip->lock);
+	last_link = fip->last_link;
+	link = fip->link;
+	fip->last_link = link;
+	spin_unlock_bh(&fip->lock);
+
+	if (last_link != link) {
+		if (link)
+			fc_linkup(fip->lp);
+		else
+			fcoe_ctlr_reset(fip, FIP_ST_LINK_WAIT);
+	}
+}
+
+/*
+ * Pre-FIP FCoE-encapsulated FLOGI receive.
+ *
+ * Snoop potential response to FLOGI or even incoming FLOGI.
+ * Return non-zero error if frame should not be delivered to libfc.
+ * Caller has checked that we are waiting for login.
+ */
+int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_frame *fp, u8 *sa)
+{
+	struct fc_frame_header *fh;
+	u8 op;
+	u8 mac[ETH_ALEN];
+
+	fh = fc_frame_header_get(fp);
+	if (fh->fh_type != FC_TYPE_ELS)
+		return 0;
+
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC && fh->fh_r_ctl == FC_RCTL_ELS_REP &&
+	    fip->flogi_oxid == ntohs(fh->fh_ox_id)) {
+
+		spin_lock_bh(&fip->lock);
+		if (fip->state != FIP_ST_AUTO && fip->state != FIP_ST_NON_FIP) {
+			spin_unlock_bh(&fip->lock);
+			return EINVAL;
+		}
+		fip->state = FIP_ST_NON_FIP;
+		FIP_DBG("received FLOGI LS_ACC using non-FIP mode\n");
+
+		/*
+		 * FLOGI accepted.
+		 * If the src mac addr is FC_OUI-based, then we mark the
+		 * address_mode flag to use FC_OUI-based Ethernet DA.
+		 * Otherwise we use the FCoE gateway addr
+		 */
+		if (!compare_ether_addr(sa, (u8[6])FC_FCOE_FLOGI_MAC)) {
+			fip->map_dest = 1;
+		} else {
+			memcpy(fip->dest_addr, sa, ETH_ALEN);
+			fip->map_dest = 0;
+		}
+		fip->flogi_oxid = FC_XID_UNKNOWN;
+		memcpy(mac, fip->data_src_addr, ETH_ALEN);
+		fc_fcoe_set_mac(fip->data_src_addr, fh->fh_d_id);
+		spin_unlock_bh(&fip->lock);
+
+		fip->update_mac(fip, mac, fip->data_src_addr);
+	} else if (op == ELS_FLOGI && fh->fh_r_ctl == FC_RCTL_ELS_REQ && sa) {
+		/*
+		 * Save source MAC for point-to-point responses.
+		 */
+		spin_lock_bh(&fip->lock);
+		if (fip->state == FIP_ST_AUTO || fip->state == FIP_ST_NON_FIP) {
+			memcpy(fip->dest_addr, sa, ETH_ALEN);
+			fip->map_dest = 0;
+			if (fip->state == FIP_ST_NON_FIP)
+				FIP_DBG("received FLOGI REQ, "
+						"using non-FIP mode\n");
+			fip->state = FIP_ST_NON_FIP;
+		}
+		spin_unlock_bh(&fip->lock);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fcoe_ctlr_recv_flogi);
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index 04d34a7..0c982a4 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -88,6 +88,7 @@ static inline struct fcoe_rcv_info *fcoe_dev_from_skb(const struct sk_buff *skb)
  * fr_flags.
  */
 #define	FCPHF_CRC_UNCHECKED	0x01	/* CRC not computed, still appended */
+#define	FCPHF_FIP		0x02	/* FIP protocol not FC */
 
 /*
  * Initialize a frame.
diff --git a/include/scsi/fcoe_ctlr.h b/include/scsi/fcoe_ctlr.h
new file mode 100644
index 0000000..6312f60
--- /dev/null
+++ b/include/scsi/fcoe_ctlr.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#ifndef _FCOE_CTLR_H_
+#define _FCOE_CTLR_H_
+
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
+#include <linux/workqueue.h>
+#include <scsi/libfc.h>
+
+/*
+ * FIP tunable parameters.
+ */
+#define FCOE_CTLR_START_DELAY	2000	/* mS after first adv. to choose FCF */
+#define FCOE_CTRL_SOL_TOV	2000	/* min. solicitation interval (mS) */
+#define FCOE_CTLR_FCF_LIMIT	20	/* max. number of FCF entries */
+
+enum fip_state {
+	FIP_ST_DISABLED =	0,	/* don't do anything */
+	FIP_ST_LINK_WAIT =	1,	/* wait for link to be usable */
+	FIP_ST_AUTO =		2,	/* determining which mode to use */
+	FIP_ST_NON_FIP =	3,	/* operate in pre-FIP mode */
+	FIP_ST_ENABLED =	4,	/* operate in FIP mode only */
+};
+
+/*
+ * FCoE Controller and FIP state.
+ */
+struct fcoe_ctlr {
+	enum fip_state state;		/* state */
+	struct fc_lport *lp;
+	struct fcoe_fcf *sel_fcf;	/* selected FCF if any */
+	struct list_head fcfs;		/* list of discovered FCFs */
+	u16 fcf_count;			/* count of FCF entries */
+	unsigned long sol_time;		/* time of last multicast solicit */
+	unsigned long sel_time;		/* time after which to select */
+	unsigned long port_ka_time;	/* time of next port keep-alive */
+	unsigned long ctlr_ka_time;	/* time of next ctlr keep-alive */
+	struct timer_list timer;
+	struct work_struct work;
+	u16 user_mfs;			/* configured max frame size */
+	u16 flogi_oxid;			/* FLOGI OX_ID */
+	u8 flogi_count;			/* number of FLOGI attempts */
+	u8 link:1;			/* current link status for libfc */
+	u8 last_link:1;			/* last link state reported to libfc */
+	u8 map_dest:1;			/* form Ether DA with FC-OUI || FC_ID */
+	u8 dest_addr[ETH_ALEN];
+	u8 ctl_src_addr[ETH_ALEN];
+	u8 data_src_addr[ETH_ALEN];
+
+	void (*send)(struct fcoe_ctlr *, struct sk_buff *);
+	void (*update_mac)(struct fcoe_ctlr *, u8 *old, u8 *new);
+	spinlock_t lock;		/* lock covering FIP state */
+};
+
+/*
+ * FCF entry.
+ */
+struct fcoe_fcf {
+	struct list_head list;
+	unsigned long time;		/* time of last advertisement */
+
+	/*
+	 * The switch, fabric, map, and mac together form the lookup key.
+	 */
+	u64 switch_name;
+	u64 fabric_name;
+	u32 fc_map;			/* FC-MAP / OUI */
+	u8 fcf_mac[ETH_ALEN]; 		/* MAC address of FCF */
+	u16 vfid;			/* virtual fabric ID */
+
+	u8 pri;				/* selection priority */
+	u16 flags;			/* flags received */
+	u32 fka_period;			/* FIP keep-alive period in jiffies */
+};
+
+void fcoe_ctlr_init(struct fcoe_ctlr *);
+void fcoe_ctlr_destroy(struct fcoe_ctlr *);
+void fcoe_ctlr_start(struct fcoe_ctlr *);
+int fcoe_ctlr_stop(struct fcoe_ctlr *);
+int fcoe_ctlr_els_send(struct fcoe_ctlr *, struct sk_buff *);
+int fcoe_ctlr_recv(struct fcoe_ctlr *, struct sk_buff *);
+int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_frame *fp, u8 *sa);
+
+#endif /* _FCOE_CTLR_H_ */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 941818f..0c10982 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -24,6 +24,7 @@
 #include <linux/skbuff.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
+#include <scsi/fcoe_ctlr.h>
 
 /*
  * this percpu struct for fcoe
@@ -41,24 +42,23 @@ struct fcoe_percpu_s {
  */
 struct fcoe_softc {
 	struct list_head list;
-	struct fc_lport *lp;
 	struct net_device *real_dev;
 	struct net_device *phys_dev;		/* device with ethtool_ops */
 	struct packet_type  fcoe_packet_type;
+	struct packet_type fip_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
 	u8	fcoe_pending_queue_active;
-
-	u8 dest_addr[ETH_ALEN];
-	u8 ctl_src_addr[ETH_ALEN];
-	u8 data_src_addr[ETH_ALEN];
-	/*
-	 * fcoe protocol address learning related stuff
-	 */
-	u16 flogi_oxid;
-	u8 flogi_progress;
-	u8 address_mode;
+	struct fcoe_ctlr ctlr;
 };
 
+#define fcoe_from_ctlr(fc) container_of(fc, struct fcoe_softc, ctlr)
+
+static inline struct fcoe_softc *fcoe_softc(
+	const struct fc_lport *lp)
+{
+	return (struct fcoe_softc *)lport_priv(lp);
+}
+
 static inline struct net_device *fcoe_netdev(
 	const struct fc_lport *lp)
 {
@@ -156,6 +156,8 @@ int fcoe_percpu_receive_thread(void *arg);
 void fcoe_clean_pending_queue(struct fc_lport *lp);
 void fcoe_percpu_clean(struct fc_lport *lp);
 void fcoe_watchdog(ulong vp);
+int fcoe_fip_recv(struct sk_buff *, struct net_device *,
+	     struct packet_type *, struct net_device *);
 int fcoe_link_ok(struct fc_lport *lp);
 
 struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);

