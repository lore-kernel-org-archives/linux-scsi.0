From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/11] fcoe: have fcoe log off and lport destroy before
	ndo_fcoe_disable
Date: Fri, 01 Apr 2011 16:06:45 -0700
Message-ID: <20110401230645.15001.30212.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46372 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab1DAXGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:46 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently fcoe interface cleanup is done after ndo_fcoe_disable
and that prevents logoff going out to the peer, so this patch
moves all netdev cleanup and its releasing inside
fcoe_interface_cleanup to have log off before ndo_fcoe_disable
disables the fcoe.

This patch also fixes asymmetric rtnl locking around fcoe_if_destroy,
as currently this function requires rtnl held by its caller
and then have this func drops the lock, instead now don't have
any processing under rtnl inside fcoe_if_destroy, this required
moving few func to get build working again.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |  131 +++++++++++++++++++++-------------------------
 1 files changed, 60 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 34408d9..5d3700d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -381,6 +381,42 @@ out:
 }
 
 /**
+ * fcoe_interface_release() - fcoe_port kref release function
+ * @kref: Embedded reference count in an fcoe_interface struct
+ */
+static void fcoe_interface_release(struct kref *kref)
+{
+	struct fcoe_interface *fcoe;
+	struct net_device *netdev;
+
+	fcoe = container_of(kref, struct fcoe_interface, kref);
+	netdev = fcoe->netdev;
+	/* tear-down the FCoE controller */
+	fcoe_ctlr_destroy(&fcoe->ctlr);
+	kfree(fcoe);
+	dev_put(netdev);
+	module_put(THIS_MODULE);
+}
+
+/**
+ * fcoe_interface_get() - Get a reference to a FCoE interface
+ * @fcoe: The FCoE interface to be held
+ */
+static inline void fcoe_interface_get(struct fcoe_interface *fcoe)
+{
+	kref_get(&fcoe->kref);
+}
+
+/**
+ * fcoe_interface_put() - Put a reference to a FCoE interface
+ * @fcoe: The FCoE interface to be released
+ */
+static inline void fcoe_interface_put(struct fcoe_interface *fcoe)
+{
+	kref_put(&fcoe->kref, fcoe_interface_release);
+}
+
+/**
  * fcoe_interface_cleanup() - Clean up a FCoE interface
  * @fcoe: The FCoE interface to be cleaned up
  *
@@ -392,6 +428,21 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
 	u8 flogi_maddr[ETH_ALEN];
 	const struct net_device_ops *ops;
+	struct fcoe_port *port = lport_priv(fcoe->ctlr.lp);
+
+	FCOE_NETDEV_DBG(netdev, "Destroying interface\n");
+
+	/* Logout of the fabric */
+	fc_fabric_logoff(fcoe->ctlr.lp);
+
+	/* Cleanup the fc_lport */
+	fc_lport_destroy(fcoe->ctlr.lp);
+
+	/* Stop the transmit retry timer */
+	del_timer_sync(&port->timer);
+
+	/* Free existing transmit skbs */
+	fcoe_clean_pending_queue(fcoe->ctlr.lp);
 
 	/*
 	 * Don't listen for Ethernet packets anymore.
@@ -414,6 +465,9 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	} else
 		dev_mc_del(netdev, FIP_ALL_ENODE_MACS);
 
+	if (!is_zero_ether_addr(port->data_src_addr))
+		dev_uc_del(netdev, port->data_src_addr);
+
 	/* Tell the LLD we are done w/ FCoE */
 	ops = netdev->netdev_ops;
 	if (ops->ndo_fcoe_disable) {
@@ -421,42 +475,7 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 			FCOE_NETDEV_DBG(netdev, "Failed to disable FCoE"
 					" specific feature for LLD.\n");
 	}
-}
-
-/**
- * fcoe_interface_release() - fcoe_port kref release function
- * @kref: Embedded reference count in an fcoe_interface struct
- */
-static void fcoe_interface_release(struct kref *kref)
-{
-	struct fcoe_interface *fcoe;
-	struct net_device *netdev;
-
-	fcoe = container_of(kref, struct fcoe_interface, kref);
-	netdev = fcoe->netdev;
-	/* tear-down the FCoE controller */
-	fcoe_ctlr_destroy(&fcoe->ctlr);
-	kfree(fcoe);
-	dev_put(netdev);
-	module_put(THIS_MODULE);
-}
-
-/**
- * fcoe_interface_get() - Get a reference to a FCoE interface
- * @fcoe: The FCoE interface to be held
- */
-static inline void fcoe_interface_get(struct fcoe_interface *fcoe)
-{
-	kref_get(&fcoe->kref);
-}
-
-/**
- * fcoe_interface_put() - Put a reference to a FCoE interface
- * @fcoe: The FCoE interface to be released
- */
-static inline void fcoe_interface_put(struct fcoe_interface *fcoe)
-{
-	kref_put(&fcoe->kref, fcoe_interface_release);
+	fcoe_interface_put(fcoe);
 }
 
 /**
@@ -821,39 +840,9 @@ skip_oem:
  * fcoe_if_destroy() - Tear down a SW FCoE instance
  * @lport: The local port to be destroyed
  *
- * Locking: must be called with the RTNL mutex held and RTNL mutex
- * needed to be dropped by this function since not dropping RTNL
- * would cause circular locking warning on synchronous fip worker
- * cancelling thru fcoe_interface_put invoked by this function.
- *
  */
 static void fcoe_if_destroy(struct fc_lport *lport)
 {
-	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->priv;
-	struct net_device *netdev = fcoe->netdev;
-
-	FCOE_NETDEV_DBG(netdev, "Destroying interface\n");
-
-	/* Logout of the fabric */
-	fc_fabric_logoff(lport);
-
-	/* Cleanup the fc_lport */
-	fc_lport_destroy(lport);
-
-	/* Stop the transmit retry timer */
-	del_timer_sync(&port->timer);
-
-	/* Free existing transmit skbs */
-	fcoe_clean_pending_queue(lport);
-
-	if (!is_zero_ether_addr(port->data_src_addr))
-		dev_uc_del(netdev, port->data_src_addr);
-	rtnl_unlock();
-
-	/* receives may not be stopped until after this */
-	fcoe_interface_put(fcoe);
-
 	/* Free queued packets for the per-CPU receive threads */
 	fcoe_percpu_clean(lport);
 
@@ -1836,6 +1825,7 @@ static int fcoe_enable(struct net_device *netdev)
 static int fcoe_destroy(struct net_device *netdev)
 {
 	struct fcoe_interface *fcoe;
+	struct fc_lport *lport;
 	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
@@ -1846,10 +1836,11 @@ static int fcoe_destroy(struct net_device *netdev)
 		rc = -ENODEV;
 		goto out_nodev;
 	}
-	fcoe_interface_cleanup(fcoe);
+	lport = fcoe->ctlr.lp;
 	list_del(&fcoe->list);
-	/* RTNL mutex is dropped by fcoe_if_destroy */
-	fcoe_if_destroy(fcoe->ctlr.lp);
+	fcoe_interface_cleanup(fcoe);
+	rtnl_unlock();
+	fcoe_if_destroy(lport);
 out_nodev:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
@@ -1865,8 +1856,6 @@ static void fcoe_destroy_work(struct work_struct *work)
 
 	port = container_of(work, struct fcoe_port, destroy_work);
 	mutex_lock(&fcoe_config_mutex);
-	rtnl_lock();
-	/* RTNL mutex is dropped by fcoe_if_destroy */
 	fcoe_if_destroy(port->lport);
 	mutex_unlock(&fcoe_config_mutex);
 }

