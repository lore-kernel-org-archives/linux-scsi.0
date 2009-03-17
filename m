From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/14] fcoe: removes default sw transport code file fcoe_sw.c
Date: Tue, 17 Mar 2009 11:42:02 -0700
Message-ID: <20090317184202.22987.8958.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZCQSmG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:42:06 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

Moves only required code from fcoe_sw.c to libfcoe.c towards having
just one source file for fcoe module, this gets rid off default sw
transport code in a separate fcoe_sw.c file.

Very minor renaming along this move, dropped _sw_ or _SW_ use
in names and replaced them by _if_ as a auxiliary interface
functions. Now some of these funcs can be removed or merged with
other func after fcoe transport is gone, but that should be
in another patch to keep this patch simple.

Now the libfcoe.c file name for fcoe module doesn't go along well,
so the libfcoe.c file renaming to fcoe.c as the only single fcoe
module file is done in next patch to keep this patch clean
and small for review.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/Makefile  |    3 
 drivers/scsi/fcoe/fcoe_sw.c |  522 -------------------------------------------
 drivers/scsi/fcoe/libfcoe.c |  489 ++++++++++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h      |    6 
 4 files changed, 481 insertions(+), 539 deletions(-)
 delete mode 100644 drivers/scsi/fcoe/fcoe_sw.c

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index e950adf..2d9dae4 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -3,5 +3,4 @@
 obj-$(CONFIG_FCOE) += fcoe.o
 
 fcoe-y := \
-	libfcoe.o \
-	fcoe_sw.o
+	libfcoe.o
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
deleted file mode 100644
index a2b3418..0000000
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ /dev/null
@@ -1,522 +0,0 @@
-/*
- * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * Maintained at www.Open-FCoE.org
- */
-
-#include <linux/module.h>
-#include <linux/version.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/if_vlan.h>
-#include <net/rtnetlink.h>
-
-#include <scsi/fc/fc_els.h>
-#include <scsi/fc/fc_encaps.h>
-#include <scsi/fc/fc_fs.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
-
-#include <scsi/libfc.h>
-#include <scsi/libfcoe.h>
-
-#define FCOE_SW_VERSION	"0.1"
-#define	FCOE_SW_NAME	"fcoesw"
-#define	FCOE_SW_VENDOR	"Open-FCoE.org"
-
-#define FCOE_MAX_LUN		255
-#define FCOE_MAX_FCP_TARGET	256
-
-#define FCOE_MAX_OUTSTANDING_COMMANDS	1024
-
-#define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
-#define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
-
-static struct scsi_transport_template *scsi_transport_fcoe_sw;
-
-struct fc_function_template fcoe_sw_transport_function = {
-	.show_host_node_name = 1,
-	.show_host_port_name = 1,
-	.show_host_supported_classes = 1,
-	.show_host_supported_fc4s = 1,
-	.show_host_active_fc4s = 1,
-	.show_host_maxframe_size = 1,
-
-	.show_host_port_id = 1,
-	.show_host_supported_speeds = 1,
-	.get_host_speed = fc_get_host_speed,
-	.show_host_speed = 1,
-	.show_host_port_type = 1,
-	.get_host_port_state = fc_get_host_port_state,
-	.show_host_port_state = 1,
-	.show_host_symbolic_name = 1,
-
-	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
-	.show_rport_maxframe_size = 1,
-	.show_rport_supported_classes = 1,
-
-	.show_host_fabric_name = 1,
-	.show_starget_node_name = 1,
-	.show_starget_port_name = 1,
-	.show_starget_port_id = 1,
-	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
-	.show_rport_dev_loss_tmo = 1,
-	.get_fc_host_stats = fc_get_host_stats,
-	.issue_fc_host_lip = fcoe_reset,
-
-	.terminate_rport_io = fc_rport_terminate_io,
-};
-
-static struct scsi_host_template fcoe_sw_shost_template = {
-	.module = THIS_MODULE,
-	.name = "FCoE Driver",
-	.proc_name = FCOE_SW_NAME,
-	.queuecommand = fc_queuecommand,
-	.eh_abort_handler = fc_eh_abort,
-	.eh_device_reset_handler = fc_eh_device_reset,
-	.eh_host_reset_handler = fc_eh_host_reset,
-	.slave_alloc = fc_slave_alloc,
-	.change_queue_depth = fc_change_queue_depth,
-	.change_queue_type = fc_change_queue_type,
-	.this_id = -1,
-	.cmd_per_lun = 32,
-	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
-	.use_clustering = ENABLE_CLUSTERING,
-	.sg_tablesize = SG_ALL,
-	.max_sectors = 0xffff,
-};
-
-/**
- * fcoe_sw_lport_config() - sets up the fc_lport
- * @lp: ptr to the fc_lport
- * @shost: ptr to the parent scsi host
- *
- * Returns: 0 for success
- */
-static int fcoe_sw_lport_config(struct fc_lport *lp)
-{
-	lp->link_up = 0;
-	lp->qfull = 0;
-	lp->max_retry_count = 3;
-	lp->e_d_tov = 2 * 1000;	/* FC-FS default */
-	lp->r_a_tov = 2 * 2 * 1000;
-	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
-			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
-
-	fc_lport_init_stats(lp);
-
-	/* lport fc_lport related configuration */
-	fc_lport_config(lp);
-
-	/* offload related configuration */
-	lp->crc_offload = 0;
-	lp->seq_offload = 0;
-	lp->lro_enabled = 0;
-	lp->lro_xid = 0;
-	lp->lso_max = 0;
-
-	return 0;
-}
-
-/**
- * fcoe_sw_netdev_config() - Set up netdev for SW FCoE
- * @lp : ptr to the fc_lport
- * @netdev : ptr to the associated netdevice struct
- *
- * Must be called after fcoe_sw_lport_config() as it will use lport mutex
- *
- * Returns : 0 for success
- */
-static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
-{
-	u32 mfs;
-	u64 wwnn, wwpn;
-	struct fcoe_softc *fc;
-	u8 flogi_maddr[ETH_ALEN];
-
-	/* Setup lport private data to point to fcoe softc */
-	fc = lport_priv(lp);
-	fc->lp = lp;
-	fc->real_dev = netdev;
-	fc->phys_dev = netdev;
-
-	/* Require support for get_pauseparam ethtool op. */
-	if (netdev->priv_flags & IFF_802_1Q_VLAN)
-		fc->phys_dev = vlan_dev_real_dev(netdev);
-
-	/* Do not support for bonding device */
-	if ((fc->real_dev->priv_flags & IFF_MASTER_ALB) ||
-	    (fc->real_dev->priv_flags & IFF_SLAVE_INACTIVE) ||
-	    (fc->real_dev->priv_flags & IFF_MASTER_8023AD)) {
-		return -EOPNOTSUPP;
-	}
-
-	/*
-	 * Determine max frame size based on underlying device and optional
-	 * user-configured limit.  If the MFS is too low, fcoe_link_ok()
-	 * will return 0, so do this first.
-	 */
-	mfs = fc->real_dev->mtu - (sizeof(struct fcoe_hdr) +
-				   sizeof(struct fcoe_crc_eof));
-	if (fc_set_mfs(lp, mfs))
-		return -EINVAL;
-
-	if (!fcoe_link_ok(lp))
-		lp->link_up = 1;
-
-	/* offload features support */
-	if (fc->real_dev->features & NETIF_F_SG)
-		lp->sg_supp = 1;
-
-#ifdef NETIF_F_FCOE_CRC
-	if (netdev->features & NETIF_F_FCOE_CRC) {
-		lp->crc_offload = 1;
-		printk(KERN_DEBUG "fcoe:%s supports FCCRC offload\n",
-		       netdev->name);
-	}
-#endif
-#ifdef NETIF_F_FSO
-	if (netdev->features & NETIF_F_FSO) {
-		lp->seq_offload = 1;
-		lp->lso_max = netdev->gso_max_size;
-		printk(KERN_DEBUG "fcoe:%s supports LSO for max len 0x%x\n",
-		       netdev->name, lp->lso_max);
-	}
-#endif
-	if (netdev->fcoe_ddp_xid) {
-		lp->lro_enabled = 1;
-		lp->lro_xid = netdev->fcoe_ddp_xid;
-		printk(KERN_DEBUG "fcoe:%s supports LRO for max xid 0x%x\n",
-		       netdev->name, lp->lro_xid);
-	}
-	skb_queue_head_init(&fc->fcoe_pending_queue);
-	fc->fcoe_pending_queue_active = 0;
-
-	/* setup Source Mac Address */
-	memcpy(fc->ctl_src_addr, fc->real_dev->dev_addr,
-	       fc->real_dev->addr_len);
-
-	wwnn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 1, 0);
-	fc_set_wwnn(lp, wwnn);
-	/* XXX - 3rd arg needs to be vlan id */
-	wwpn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 2, 0);
-	fc_set_wwpn(lp, wwpn);
-
-	/*
-	 * Add FCoE MAC address as second unicast MAC address
-	 * or enter promiscuous mode if not capable of listening
-	 * for multiple unicast MACs.
-	 */
-	rtnl_lock();
-	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_add(fc->real_dev, flogi_maddr, ETH_ALEN);
-	rtnl_unlock();
-
-	/*
-	 * setup the receive function from ethernet driver
-	 * on the ethertype for the given device
-	 */
-	fc->fcoe_packet_type.func = fcoe_rcv;
-	fc->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
-	fc->fcoe_packet_type.dev = fc->real_dev;
-	dev_add_pack(&fc->fcoe_packet_type);
-
-	return 0;
-}
-
-/**
- * fcoe_sw_shost_config() - Sets up fc_lport->host
- * @lp : ptr to the fc_lport
- * @shost : ptr to the associated scsi host
- * @dev : device associated to scsi host
- *
- * Must be called after fcoe_sw_lport_config() and fcoe_sw_netdev_config()
- *
- * Returns : 0 for success
- */
-static int fcoe_sw_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
-				struct device *dev)
-{
-	int rc = 0;
-
-	/* lport scsi host config */
-	lp->host = shost;
-
-	lp->host->max_lun = FCOE_MAX_LUN;
-	lp->host->max_id = FCOE_MAX_FCP_TARGET;
-	lp->host->max_channel = 0;
-	lp->host->transportt = scsi_transport_fcoe_sw;
-
-	/* add the new host to the SCSI-ml */
-	rc = scsi_add_host(lp->host, dev);
-	if (rc) {
-		FC_DBG("fcoe_sw_shost_config:error on scsi_add_host\n");
-		return rc;
-	}
-	sprintf(fc_host_symbolic_name(lp->host), "%s v%s over %s",
-		FCOE_SW_NAME, FCOE_SW_VERSION,
-		fcoe_netdev(lp)->name);
-
-	return 0;
-}
-
-/**
- * fcoe_sw_em_config() - allocates em for this lport
- * @lp: the port that em is to allocated for
- *
- * Returns : 0 on success
- */
-static inline int fcoe_sw_em_config(struct fc_lport *lp)
-{
-	BUG_ON(lp->emp);
-
-	lp->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3,
-				    FCOE_MIN_XID, FCOE_MAX_XID);
-	if (!lp->emp)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/**
- * fcoe_sw_destroy() - FCoE software HBA tear-down function
- * @netdev: ptr to the associated net_device
- *
- * Returns: 0 if link is OK for use by FCoE.
- */
-int fcoe_sw_destroy(struct net_device *netdev)
-{
-	struct fc_lport *lp = NULL;
-	struct fcoe_softc *fc;
-	u8 flogi_maddr[ETH_ALEN];
-
-	BUG_ON(!netdev);
-
-	printk(KERN_DEBUG "fcoe_sw_destroy:interface on %s\n",
-	       netdev->name);
-
-	lp = fcoe_hostlist_lookup(netdev);
-	if (!lp)
-		return -ENODEV;
-
-	fc = lport_priv(lp);
-
-	/* Logout of the fabric */
-	fc_fabric_logoff(lp);
-
-	/* Remove the instance from fcoe's list */
-	fcoe_hostlist_remove(lp);
-
-	/* Don't listen for Ethernet packets anymore */
-	dev_remove_pack(&fc->fcoe_packet_type);
-
-	/* Cleanup the fc_lport */
-	fc_lport_destroy(lp);
-	fc_fcp_destroy(lp);
-
-	/* Detach from the scsi-ml */
-	fc_remove_host(lp->host);
-	scsi_remove_host(lp->host);
-
-	/* There are no more rports or I/O, free the EM */
-	if (lp->emp)
-		fc_exch_mgr_free(lp->emp);
-
-	/* Delete secondary MAC addresses */
-	rtnl_lock();
-	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
-	dev_unicast_delete(fc->real_dev, flogi_maddr, ETH_ALEN);
-	if (compare_ether_addr(fc->data_src_addr, (u8[6]) { 0 }))
-		dev_unicast_delete(fc->real_dev, fc->data_src_addr, ETH_ALEN);
-	rtnl_unlock();
-
-	/* Free the per-CPU revieve threads */
-	fcoe_percpu_clean(lp);
-
-	/* Free existing skbs */
-	fcoe_clean_pending_queue(lp);
-
-	/* Free memory used by statistical counters */
-	fc_lport_free_stats(lp);
-
-	/* Release the net_device and Scsi_Host */
-	dev_put(fc->real_dev);
-	scsi_host_put(lp->host);
-
-	return 0;
-}
-
-/*
- * fcoe_sw_ddp_setup - calls LLD's ddp_setup through net_device
- * @lp:	the corresponding fc_lport
- * @xid: the exchange id for this ddp transfer
- * @sgl: the scatterlist describing this transfer
- * @sgc: number of sg items
- *
- * Returns : 0 no ddp
- */
-static int fcoe_sw_ddp_setup(struct fc_lport *lp, u16 xid,
-			     struct scatterlist *sgl, unsigned int sgc)
-{
-	struct net_device *n = fcoe_netdev(lp);
-
-	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_setup)
-		return n->netdev_ops->ndo_fcoe_ddp_setup(n, xid, sgl, sgc);
-
-	return 0;
-}
-
-/*
- * fcoe_sw_ddp_done - calls LLD's ddp_done through net_device
- * @lp:	the corresponding fc_lport
- * @xid: the exchange id for this ddp transfer
- *
- * Returns : the length of data that have been completed by ddp
- */
-static int fcoe_sw_ddp_done(struct fc_lport *lp, u16 xid)
-{
-	struct net_device *n = fcoe_netdev(lp);
-
-	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_done)
-		return n->netdev_ops->ndo_fcoe_ddp_done(n, xid);
-	return 0;
-}
-
-static struct libfc_function_template fcoe_sw_libfc_fcn_templ = {
-	.frame_send = fcoe_xmit,
-	.ddp_setup = fcoe_sw_ddp_setup,
-	.ddp_done = fcoe_sw_ddp_done,
-};
-
-/**
- * fcoe_sw_create() - this function creates the fcoe interface
- * @netdev: pointer the associated netdevice
- *
- * Creates fc_lport struct and scsi_host for lport, configures lport
- * and starts fabric login.
- *
- * Returns : 0 on success
- */
-int fcoe_sw_create(struct net_device *netdev)
-{
-	int rc;
-	struct fc_lport *lp = NULL;
-	struct fcoe_softc *fc;
-	struct Scsi_Host *shost;
-
-	BUG_ON(!netdev);
-
-	printk(KERN_DEBUG "fcoe_sw_create:interface on %s\n",
-	       netdev->name);
-
-	lp = fcoe_hostlist_lookup(netdev);
-	if (lp)
-		return -EEXIST;
-
-	shost = fcoe_host_alloc(&fcoe_sw_shost_template,
-				sizeof(struct fcoe_softc));
-	if (!shost) {
-		FC_DBG("Could not allocate host structure\n");
-		return -ENOMEM;
-	}
-	lp = shost_priv(shost);
-	fc = lport_priv(lp);
-
-	/* configure fc_lport, e.g., em */
-	rc = fcoe_sw_lport_config(lp);
-	if (rc) {
-		FC_DBG("Could not configure lport\n");
-		goto out_host_put;
-	}
-
-	/* configure lport network properties */
-	rc = fcoe_sw_netdev_config(lp, netdev);
-	if (rc) {
-		FC_DBG("Could not configure netdev for lport\n");
-		goto out_host_put;
-	}
-
-	/* configure lport scsi host properties */
-	rc = fcoe_sw_shost_config(lp, shost, &netdev->dev);
-	if (rc) {
-		FC_DBG("Could not configure shost for lport\n");
-		goto out_host_put;
-	}
-
-	/* lport exch manager allocation */
-	rc = fcoe_sw_em_config(lp);
-	if (rc) {
-		FC_DBG("Could not configure em for lport\n");
-		goto out_host_put;
-	}
-
-	/* Initialize the library */
-	rc = fcoe_libfc_config(lp, &fcoe_sw_libfc_fcn_templ);
-	if (rc) {
-		FC_DBG("Could not configure libfc for lport!\n");
-		goto out_lp_destroy;
-	}
-
-	/* add to lports list */
-	fcoe_hostlist_add(lp);
-
-	lp->boot_time = jiffies;
-
-	fc_fabric_login(lp);
-
-	dev_hold(netdev);
-
-	return rc;
-
-out_lp_destroy:
-	fc_exch_mgr_free(lp->emp); /* Free the EM */
-out_host_put:
-	scsi_host_put(lp->host);
-	return rc;
-}
-
-/**
- * fcoe_sw_init() - attach to scsi transport
- *
- * Returns : 0 on success
- */
-int __init fcoe_sw_init(void)
-{
-	/* attach to scsi transport */
-	scsi_transport_fcoe_sw =
-		fc_attach_transport(&fcoe_sw_transport_function);
-
-	if (!scsi_transport_fcoe_sw) {
-		printk(KERN_ERR "fcoe_sw_init:fc_attach_transport() failed\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-/**
- * fcoe_sw_exit() - dummy for now
- *
- * Returns : 0 on success
- */
-int __exit fcoe_sw_exit(void)
-{
-	return 0;
-}
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 334db95..cbebbf7 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -56,6 +56,18 @@ static int debug_fcoe;
 
 #define FCOE_WORD_TO_BYTE  4
 
+#define FCOE_VERSION	"0.1"
+#define	FCOE_NAME	"fcoe"
+#define	FCOE_VENDOR	"Open-FCoE.org"
+
+#define FCOE_MAX_LUN		255
+#define FCOE_MAX_FCP_TARGET	256
+
+#define FCOE_MAX_OUTSTANDING_COMMANDS	1024
+
+#define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
+#define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
+
 MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FCoE");
 MODULE_LICENSE("GPL");
@@ -79,6 +91,468 @@ static struct notifier_block fcoe_notifier = {
 	.notifier_call = fcoe_device_notification,
 };
 
+static struct scsi_transport_template *scsi_transport_fcoe_sw;
+
+struct fc_function_template fcoe_transport_function = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_active_fc4s = 1,
+	.show_host_maxframe_size = 1,
+
+	.show_host_port_id = 1,
+	.show_host_supported_speeds = 1,
+	.get_host_speed = fc_get_host_speed,
+	.show_host_speed = 1,
+	.show_host_port_type = 1,
+	.get_host_port_state = fc_get_host_port_state,
+	.show_host_port_state = 1,
+	.show_host_symbolic_name = 1,
+
+	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+
+	.show_host_fabric_name = 1,
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo = 1,
+	.get_fc_host_stats = fc_get_host_stats,
+	.issue_fc_host_lip = fcoe_reset,
+
+	.terminate_rport_io = fc_rport_terminate_io,
+};
+
+static struct scsi_host_template fcoe_shost_template = {
+	.module = THIS_MODULE,
+	.name = "FCoE Driver",
+	.proc_name = FCOE_NAME,
+	.queuecommand = fc_queuecommand,
+	.eh_abort_handler = fc_eh_abort,
+	.eh_device_reset_handler = fc_eh_device_reset,
+	.eh_host_reset_handler = fc_eh_host_reset,
+	.slave_alloc = fc_slave_alloc,
+	.change_queue_depth = fc_change_queue_depth,
+	.change_queue_type = fc_change_queue_type,
+	.this_id = -1,
+	.cmd_per_lun = 32,
+	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
+	.use_clustering = ENABLE_CLUSTERING,
+	.sg_tablesize = SG_ALL,
+	.max_sectors = 0xffff,
+};
+
+/**
+ * fcoe_lport_config() - sets up the fc_lport
+ * @lp: ptr to the fc_lport
+ * @shost: ptr to the parent scsi host
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_lport_config(struct fc_lport *lp)
+{
+	lp->link_up = 0;
+	lp->qfull = 0;
+	lp->max_retry_count = 3;
+	lp->e_d_tov = 2 * 1000;	/* FC-FS default */
+	lp->r_a_tov = 2 * 2 * 1000;
+	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
+			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
+
+	fc_lport_init_stats(lp);
+
+	/* lport fc_lport related configuration */
+	fc_lport_config(lp);
+
+	/* offload related configuration */
+	lp->crc_offload = 0;
+	lp->seq_offload = 0;
+	lp->lro_enabled = 0;
+	lp->lro_xid = 0;
+	lp->lso_max = 0;
+
+	return 0;
+}
+
+/**
+ * fcoe_netdev_config() - Set up netdev for SW FCoE
+ * @lp : ptr to the fc_lport
+ * @netdev : ptr to the associated netdevice struct
+ *
+ * Must be called after fcoe_lport_config() as it will use lport mutex
+ *
+ * Returns : 0 for success
+ */
+static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
+{
+	u32 mfs;
+	u64 wwnn, wwpn;
+	struct fcoe_softc *fc;
+	u8 flogi_maddr[ETH_ALEN];
+
+	/* Setup lport private data to point to fcoe softc */
+	fc = lport_priv(lp);
+	fc->lp = lp;
+	fc->real_dev = netdev;
+	fc->phys_dev = netdev;
+
+	/* Require support for get_pauseparam ethtool op. */
+	if (netdev->priv_flags & IFF_802_1Q_VLAN)
+		fc->phys_dev = vlan_dev_real_dev(netdev);
+
+	/* Do not support for bonding device */
+	if ((fc->real_dev->priv_flags & IFF_MASTER_ALB) ||
+	    (fc->real_dev->priv_flags & IFF_SLAVE_INACTIVE) ||
+	    (fc->real_dev->priv_flags & IFF_MASTER_8023AD)) {
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * Determine max frame size based on underlying device and optional
+	 * user-configured limit.  If the MFS is too low, fcoe_link_ok()
+	 * will return 0, so do this first.
+	 */
+	mfs = fc->real_dev->mtu - (sizeof(struct fcoe_hdr) +
+				   sizeof(struct fcoe_crc_eof));
+	if (fc_set_mfs(lp, mfs))
+		return -EINVAL;
+
+	if (!fcoe_link_ok(lp))
+		lp->link_up = 1;
+
+	/* offload features support */
+	if (fc->real_dev->features & NETIF_F_SG)
+		lp->sg_supp = 1;
+
+#ifdef NETIF_F_FCOE_CRC
+	if (netdev->features & NETIF_F_FCOE_CRC) {
+		lp->crc_offload = 1;
+		printk(KERN_DEBUG "fcoe:%s supports FCCRC offload\n",
+		       netdev->name);
+	}
+#endif
+#ifdef NETIF_F_FSO
+	if (netdev->features & NETIF_F_FSO) {
+		lp->seq_offload = 1;
+		lp->lso_max = netdev->gso_max_size;
+		printk(KERN_DEBUG "fcoe:%s supports LSO for max len 0x%x\n",
+		       netdev->name, lp->lso_max);
+	}
+#endif
+	if (netdev->fcoe_ddp_xid) {
+		lp->lro_enabled = 1;
+		lp->lro_xid = netdev->fcoe_ddp_xid;
+		printk(KERN_DEBUG "fcoe:%s supports LRO for max xid 0x%x\n",
+		       netdev->name, lp->lro_xid);
+	}
+	skb_queue_head_init(&fc->fcoe_pending_queue);
+	fc->fcoe_pending_queue_active = 0;
+
+	/* setup Source Mac Address */
+	memcpy(fc->ctl_src_addr, fc->real_dev->dev_addr,
+	       fc->real_dev->addr_len);
+
+	wwnn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 1, 0);
+	fc_set_wwnn(lp, wwnn);
+	/* XXX - 3rd arg needs to be vlan id */
+	wwpn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 2, 0);
+	fc_set_wwpn(lp, wwpn);
+
+	/*
+	 * Add FCoE MAC address as second unicast MAC address
+	 * or enter promiscuous mode if not capable of listening
+	 * for multiple unicast MACs.
+	 */
+	rtnl_lock();
+	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
+	dev_unicast_add(fc->real_dev, flogi_maddr, ETH_ALEN);
+	rtnl_unlock();
+
+	/*
+	 * setup the receive function from ethernet driver
+	 * on the ethertype for the given device
+	 */
+	fc->fcoe_packet_type.func = fcoe_rcv;
+	fc->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	fc->fcoe_packet_type.dev = fc->real_dev;
+	dev_add_pack(&fc->fcoe_packet_type);
+
+	return 0;
+}
+
+/**
+ * fcoe_shost_config() - Sets up fc_lport->host
+ * @lp : ptr to the fc_lport
+ * @shost : ptr to the associated scsi host
+ * @dev : device associated to scsi host
+ *
+ * Must be called after fcoe_lport_config() and fcoe_netdev_config()
+ *
+ * Returns : 0 for success
+ */
+static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
+				struct device *dev)
+{
+	int rc = 0;
+
+	/* lport scsi host config */
+	lp->host = shost;
+
+	lp->host->max_lun = FCOE_MAX_LUN;
+	lp->host->max_id = FCOE_MAX_FCP_TARGET;
+	lp->host->max_channel = 0;
+	lp->host->transportt = scsi_transport_fcoe_sw;
+
+	/* add the new host to the SCSI-ml */
+	rc = scsi_add_host(lp->host, dev);
+	if (rc) {
+		FC_DBG("fcoe_shost_config:error on scsi_add_host\n");
+		return rc;
+	}
+	sprintf(fc_host_symbolic_name(lp->host), "%s v%s over %s",
+		FCOE_NAME, FCOE_VERSION,
+		fcoe_netdev(lp)->name);
+
+	return 0;
+}
+
+/**
+ * fcoe_em_config() - allocates em for this lport
+ * @lp: the port that em is to allocated for
+ *
+ * Returns : 0 on success
+ */
+static inline int fcoe_em_config(struct fc_lport *lp)
+{
+	BUG_ON(lp->emp);
+
+	lp->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3,
+				    FCOE_MIN_XID, FCOE_MAX_XID);
+	if (!lp->emp)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * fcoe_if_destroy() - FCoE software HBA tear-down function
+ * @netdev: ptr to the associated net_device
+ *
+ * Returns: 0 if link is OK for use by FCoE.
+ */
+static int fcoe_if_destroy(struct net_device *netdev)
+{
+	struct fc_lport *lp = NULL;
+	struct fcoe_softc *fc;
+	u8 flogi_maddr[ETH_ALEN];
+
+	BUG_ON(!netdev);
+
+	printk(KERN_DEBUG "fcoe_if_destroy:interface on %s\n",
+	       netdev->name);
+
+	lp = fcoe_hostlist_lookup(netdev);
+	if (!lp)
+		return -ENODEV;
+
+	fc = lport_priv(lp);
+
+	/* Logout of the fabric */
+	fc_fabric_logoff(lp);
+
+	/* Remove the instance from fcoe's list */
+	fcoe_hostlist_remove(lp);
+
+	/* Don't listen for Ethernet packets anymore */
+	dev_remove_pack(&fc->fcoe_packet_type);
+
+	/* Cleanup the fc_lport */
+	fc_lport_destroy(lp);
+	fc_fcp_destroy(lp);
+
+	/* Detach from the scsi-ml */
+	fc_remove_host(lp->host);
+	scsi_remove_host(lp->host);
+
+	/* There are no more rports or I/O, free the EM */
+	if (lp->emp)
+		fc_exch_mgr_free(lp->emp);
+
+	/* Delete secondary MAC addresses */
+	rtnl_lock();
+	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
+	dev_unicast_delete(fc->real_dev, flogi_maddr, ETH_ALEN);
+	if (compare_ether_addr(fc->data_src_addr, (u8[6]) { 0 }))
+		dev_unicast_delete(fc->real_dev, fc->data_src_addr, ETH_ALEN);
+	rtnl_unlock();
+
+	/* Free the per-CPU revieve threads */
+	fcoe_percpu_clean(lp);
+
+	/* Free existing skbs */
+	fcoe_clean_pending_queue(lp);
+
+	/* Free memory used by statistical counters */
+	fc_lport_free_stats(lp);
+
+	/* Release the net_device and Scsi_Host */
+	dev_put(fc->real_dev);
+	scsi_host_put(lp->host);
+
+	return 0;
+}
+
+/*
+ * fcoe_ddp_setup - calls LLD's ddp_setup through net_device
+ * @lp:	the corresponding fc_lport
+ * @xid: the exchange id for this ddp transfer
+ * @sgl: the scatterlist describing this transfer
+ * @sgc: number of sg items
+ *
+ * Returns : 0 no ddp
+ */
+static int fcoe_ddp_setup(struct fc_lport *lp, u16 xid,
+			     struct scatterlist *sgl, unsigned int sgc)
+{
+	struct net_device *n = fcoe_netdev(lp);
+
+	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_setup)
+		return n->netdev_ops->ndo_fcoe_ddp_setup(n, xid, sgl, sgc);
+
+	return 0;
+}
+
+/*
+ * fcoe_ddp_done - calls LLD's ddp_done through net_device
+ * @lp:	the corresponding fc_lport
+ * @xid: the exchange id for this ddp transfer
+ *
+ * Returns : the length of data that have been completed by ddp
+ */
+static int fcoe_ddp_done(struct fc_lport *lp, u16 xid)
+{
+	struct net_device *n = fcoe_netdev(lp);
+
+	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_done)
+		return n->netdev_ops->ndo_fcoe_ddp_done(n, xid);
+	return 0;
+}
+
+static struct libfc_function_template fcoe_libfc_fcn_templ = {
+	.frame_send = fcoe_xmit,
+	.ddp_setup = fcoe_ddp_setup,
+	.ddp_done = fcoe_ddp_done,
+};
+
+/**
+ * fcoe_if_create() - this function creates the fcoe interface
+ * @netdev: pointer the associated netdevice
+ *
+ * Creates fc_lport struct and scsi_host for lport, configures lport
+ * and starts fabric login.
+ *
+ * Returns : 0 on success
+ */
+static int fcoe_if_create(struct net_device *netdev)
+{
+	int rc;
+	struct fc_lport *lp = NULL;
+	struct fcoe_softc *fc;
+	struct Scsi_Host *shost;
+
+	BUG_ON(!netdev);
+
+	printk(KERN_DEBUG "fcoe_if_create:interface on %s\n",
+	       netdev->name);
+
+	lp = fcoe_hostlist_lookup(netdev);
+	if (lp)
+		return -EEXIST;
+
+	shost = fcoe_host_alloc(&fcoe_shost_template,
+				sizeof(struct fcoe_softc));
+	if (!shost) {
+		FC_DBG("Could not allocate host structure\n");
+		return -ENOMEM;
+	}
+	lp = shost_priv(shost);
+	fc = lport_priv(lp);
+
+	/* configure fc_lport, e.g., em */
+	rc = fcoe_lport_config(lp);
+	if (rc) {
+		FC_DBG("Could not configure lport\n");
+		goto out_host_put;
+	}
+
+	/* configure lport network properties */
+	rc = fcoe_netdev_config(lp, netdev);
+	if (rc) {
+		FC_DBG("Could not configure netdev for lport\n");
+		goto out_host_put;
+	}
+
+	/* configure lport scsi host properties */
+	rc = fcoe_shost_config(lp, shost, &netdev->dev);
+	if (rc) {
+		FC_DBG("Could not configure shost for lport\n");
+		goto out_host_put;
+	}
+
+	/* lport exch manager allocation */
+	rc = fcoe_em_config(lp);
+	if (rc) {
+		FC_DBG("Could not configure em for lport\n");
+		goto out_host_put;
+	}
+
+	/* Initialize the library */
+	rc = fcoe_libfc_config(lp, &fcoe_libfc_fcn_templ);
+	if (rc) {
+		FC_DBG("Could not configure libfc for lport!\n");
+		goto out_lp_destroy;
+	}
+
+	/* add to lports list */
+	fcoe_hostlist_add(lp);
+
+	lp->boot_time = jiffies;
+
+	fc_fabric_login(lp);
+
+	dev_hold(netdev);
+
+	return rc;
+
+out_lp_destroy:
+	fc_exch_mgr_free(lp->emp); /* Free the EM */
+out_host_put:
+	scsi_host_put(lp->host);
+	return rc;
+}
+
+/**
+ * fcoe_if_init() - attach to scsi transport
+ *
+ * Returns : 0 on success
+ */
+static int __init fcoe_if_init(void)
+{
+	/* attach to scsi transport */
+	scsi_transport_fcoe_sw =
+		fc_attach_transport(&fcoe_transport_function);
+
+	if (!scsi_transport_fcoe_sw) {
+		printk(KERN_ERR "fcoe_init:fc_attach_transport() failed\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 /**
  * fcoe_percpu_thread_create() - Create a receive thread for an online cpu
  * @cpu: cpu index for the online cpu
@@ -1080,9 +1554,9 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		rc = -ENODEV;
 		goto out_putdev;
 	}
-	rc = fcoe_sw_destroy(netdev);
+	rc = fcoe_if_destroy(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_sw_destroy(%s) failed\n",
+		printk(KERN_ERR "fcoe: fcoe_if_destroy(%s) failed\n",
 		       netdev->name);
 		rc = -EIO;
 		goto out_putdev;
@@ -1119,9 +1593,9 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 	fcoe_ethdrv_get(netdev);
 
-	rc = fcoe_sw_create(netdev);
+	rc = fcoe_if_create(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_sw_create(%s) failed\n",
+		printk(KERN_ERR "fcoe: fcoe_if_create(%s) failed\n",
 		       netdev->name);
 		fcoe_ethdrv_put(netdev);
 		rc = -EIO;
@@ -1457,7 +1931,7 @@ static int __init fcoe_init(void)
 
 	mod_timer(&fcoe_timer, jiffies + (10 * HZ));
 
-	fcoe_sw_init();
+	fcoe_if_init();
 
 	return 0;
 
@@ -1487,15 +1961,12 @@ static void __exit fcoe_exit(void)
 
 	/* releases the associated fcoe hosts */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
-		fcoe_sw_destroy(fc->real_dev);
+		fcoe_if_destroy(fc->real_dev);
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 
 	for_each_online_cpu(cpu) {
 		fcoe_percpu_thread_destroy(cpu);
 	}
-
-	/* remove sw trasnport */
-	fcoe_sw_exit();
 }
 module_exit(fcoe_exit);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index dc64405..e99633c 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -145,10 +145,4 @@ int fcoe_hostlist_remove(const struct fc_lport *);
 
 struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *, int);
 int fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
-
-/* fcoe sw hba */
-int __init fcoe_sw_init(void);
-int __exit fcoe_sw_exit(void);
-int fcoe_sw_create(struct net_device *);
-int fcoe_sw_destroy(struct net_device *);
 #endif /* _LIBFCOE_H */

