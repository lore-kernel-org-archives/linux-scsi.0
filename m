From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 3/6] fcoe: move link speed checking into its own routine
Date: Wed, 27 Jan 2010 15:24:32 -0800
Message-ID: <20100127232432.10343.57051.stgit@localhost.localdomain>
References: <20100127232415.10343.86703.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab0A0XYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2010 18:24:32 -0500
In-Reply-To: <20100127232415.10343.86703.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.smart@emulex.com
Cc: giridhar.malavali@qlogic.com

It doesn't make sense to update the link speed in the is_link_ok()
routine. Move it to it's own routine and acquire the device speed
when we're configuring the device initially as well as if there are
any netdev events received.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   42 +++++++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 10be9f3..a719994 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -73,6 +73,7 @@ static int fcoe_rcv(struct sk_buff *, struct net_device *,
 static int fcoe_percpu_receive_thread(void *);
 static void fcoe_clean_pending_queue(struct fc_lport *);
 static void fcoe_percpu_clean(struct fc_lport *);
+static int fcoe_link_speed_update(struct fc_lport *);
 static int fcoe_link_ok(struct fc_lport *);
 
 static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
@@ -628,6 +629,8 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	port->fcoe_pending_queue_active = 0;
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lport);
 
+	fcoe_link_speed_update(lport);
+
 	if (!lport->vport) {
 		/*
 		 * Use NAA 1&2 (FC-FS Rev. 2.0, Sec. 15) to generate WWNN/WWPN:
@@ -1834,6 +1837,9 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		FCOE_NETDEV_DBG(netdev, "Unknown event %ld "
 				"from netdev netlink\n", event);
 	}
+
+	fcoe_link_speed_update(lport);
+
 	if (link_possible && !fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 	else if (fcoe_ctlr_link_down(&fcoe->ctlr)) {
@@ -2115,27 +2121,20 @@ out_nodev:
 }
 
 /**
- * fcoe_link_ok() - Check if the link is OK for a local port
- * @lport: The local port to check link on
- *
- * Any permanently-disqualifying conditions have been previously checked.
- * This also updates the speed setting, which may change with link for 100/1000.
+ * fcoe_link_speed_update() - Update the supported and actual link speeds
+ * @lport: The local port to update speeds for
  *
- * This function should probably be checking for PAUSE support at some point
- * in the future. Currently Per-priority-pause is not determinable using
- * ethtool, so we shouldn't be restrictive until that problem is resolved.
- *
- * Returns: 0 if link is OK for use by FCoE.
+ * Returns: 0 if the ethtool query was successful
+ *          -1 if the ethtool query failed
  *
  */
-int fcoe_link_ok(struct fc_lport *lport)
+int fcoe_link_speed_update(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
 	struct net_device *netdev = port->fcoe->netdev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
-	if ((netdev->flags & IFF_UP) && netif_carrier_ok(netdev) &&
-	    (!dev_ethtool_get_settings(netdev, &ecmd))) {
+	if (!dev_ethtool_get_settings(netdev, &ecmd)) {
 		lport->link_supported_speeds &=
 			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
 		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
@@ -2155,6 +2154,23 @@ int fcoe_link_ok(struct fc_lport *lport)
 }
 
 /**
+ * fcoe_link_ok() - Check if the link is OK for a local port
+ * @lport: The local port to check link on
+ *
+ * Returns: 0 if link is UP and OK, -1 if not
+ *
+ */
+int fcoe_link_ok(struct fc_lport *lport)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct net_device *netdev = port->fcoe->netdev;
+
+	if ((netdev->flags & IFF_UP) && netif_carrier_ok(netdev))
+		return 0;
+	return -1;
+}
+
+/**
  * fcoe_percpu_clean() - Clear all pending skbs for an local port
  * @lport: The local port whose skbs are to be cleared
  *

