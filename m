From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/6] fcoe: remove lport from net device before doing per cpu
 rx thread cleanup
Date: Fri, 20 Apr 2012 12:16:27 -0700
Message-ID: <20120420191627.4634.59539.stgit@localhost6.localdomain6>
References: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2DTTQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 15:16:28 -0400
In-Reply-To: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Neil Horman <nhorman@tuxdriver.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Remove lport from net device and then do synchronize net device to flush
inflight rx frames for the lport before doing fcoe_percpu_clean.

In case of master lport, remove all rx packet handlers completely and
then only do fcoe_percpu_clean. This required splitting fcoe_interface_cleanup
to do remove part separately and for that added func fcoe_interface_remove
and then  call it from fcoe_if_destory before doing fcoe_percpu_clean.
However if fcoe_interface_remove() is already called then
don't call again from fcoe_interface_cleanup() to preserve its
existing flows.

This patch along with Neil's other patch to avoid soft irq context
on ingress will avoid passing up frames on disabled lport as
discussed in this mail thread:-
http://lists.open-fcoe.org/pipermail/devel/2012-February/011947.html

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   25 +++++++++++++++++++++----
 drivers/scsi/fcoe/fcoe.h |    4 +++-
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 335e851..09a6a26 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -411,20 +411,18 @@ out:
 }
 
 /**
- * fcoe_interface_cleanup() - Clean up a FCoE interface
+ * fcoe_interface_remove() - remove FCoE interface from netdev
  * @fcoe: The FCoE interface to be cleaned up
  *
  * Caller must be holding the RTNL mutex
  */
-static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
+static void fcoe_interface_remove(struct fcoe_interface *fcoe)
 {
 	struct net_device *netdev = fcoe->netdev;
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
 	u8 flogi_maddr[ETH_ALEN];
 	const struct net_device_ops *ops;
 
-	rtnl_lock();
-
 	/*
 	 * Don't listen for Ethernet packets anymore.
 	 * synchronize_net() ensures that the packet handlers are not running
@@ -453,7 +451,22 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 			FCOE_NETDEV_DBG(netdev, "Failed to disable FCoE"
 					" specific feature for LLD.\n");
 	}
+	fcoe->removed = 1;
+}
+
+
+/**
+ * fcoe_interface_cleanup() - Clean up a FCoE interface
+ * @fcoe: The FCoE interface to be cleaned up
+ */
+static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
+{
+	struct net_device *netdev = fcoe->netdev;
+	struct fcoe_ctlr *fip = &fcoe->ctlr;
 
+	rtnl_lock();
+	if (!fcoe->removed)
+		fcoe_interface_remove(fcoe);
 	rtnl_unlock();
 
 	/* Release the self-reference taken during fcoe_interface_create() */
@@ -941,6 +954,10 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	rtnl_lock();
 	if (!is_zero_ether_addr(port->data_src_addr))
 		dev_uc_del(netdev, port->data_src_addr);
+	if (lport->vport)
+		synchronize_net();
+	else
+		fcoe_interface_remove(fcoe);
 	rtnl_unlock();
 
 	/* Free queued packets for the per-CPU receive threads */
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 3c2733a..96ac938 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -71,7 +71,8 @@ do {                                                            	\
  * @ctlr:	      The FCoE controller (for FIP)
  * @oem:	      The offload exchange manager for all local port
  *		      instances associated with this port
- * This structure is 1:1 with a net devive.
+ * @removed:	      Indicates fcoe interface removed from net device
+ * This structure is 1:1 with a net device.
  */
 struct fcoe_interface {
 	struct list_head   list;
@@ -81,6 +82,7 @@ struct fcoe_interface {
 	struct packet_type fip_packet_type;
 	struct fcoe_ctlr   ctlr;
 	struct fc_exch_mgr *oem;
+	u8	removed;
 };
 
 #define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)

