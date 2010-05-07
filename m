From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/10] fcoe: move link speed checking into its own routine
Date: Fri, 07 May 2010 15:18:35 -0700
Message-ID: <20100507221835.14971.89641.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0EGWSh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:37 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

It doesn't make sense to update the link speed in the is_link_ok()
routine. Move it to it's own routine and acquire the device speed
when we're configuring the device initially as well as if there are
any netdev events received.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   42 +++++++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 7022a16..4834d3c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -74,6 +74,7 @@ static int fcoe_rcv(struct sk_buff *, struct net_device *,
 static int fcoe_percpu_receive_thread(void *);
 static void fcoe_clean_pending_queue(struct fc_lport *);
 static void fcoe_percpu_clean(struct fc_lport *);
+static int fcoe_link_speed_update(struct fc_lport *);
 static int fcoe_link_ok(struct fc_lport *);
 
 static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
@@ -631,6 +632,8 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	port->fcoe_pending_queue_active = 0;
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lport);
 
+	fcoe_link_speed_update(lport);
+
 	if (!lport->vport) {
 		/*
 		 * Use NAA 1&2 (FC-FS Rev. 2.0, Sec. 15) to generate WWNN/WWPN:
@@ -1829,6 +1832,9 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		FCOE_NETDEV_DBG(netdev, "Unknown event %ld "
 				"from netdev netlink\n", event);
 	}
+
+	fcoe_link_speed_update(lport);
+
 	if (link_possible && !fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 	else if (fcoe_ctlr_link_down(&fcoe->ctlr)) {
@@ -2128,26 +2134,19 @@ out_nomod:
 }
 
 /**
- * fcoe_link_ok() - Check if the link is OK for a local port
- * @lport: The local port to check link on
- *
- * Any permanently-disqualifying conditions have been previously checked.
- * This also updates the speed setting, which may change with link for 100/1000.
- *
- * This function should probably be checking for PAUSE support at some point
- * in the future. Currently Per-priority-pause is not determinable using
- * ethtool, so we shouldn't be restrictive until that problem is resolved.
- *
- * Returns: 0 if link is OK for use by FCoE.
+ * fcoe_link_speed_update() - Update the supported and actual link speeds
+ * @lport: The local port to update speeds for
  *
+ * Returns: 0 if the ethtool query was successful
+ *          -1 if the ethtool query failed
  */
-int fcoe_link_ok(struct fc_lport *lport)
+int fcoe_link_speed_update(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
 	struct net_device *netdev = port->fcoe->netdev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
-	if (netif_oper_up(netdev) && !dev_ethtool_get_settings(netdev, &ecmd)) {
+	if (!dev_ethtool_get_settings(netdev, &ecmd)) {
 		lport->link_supported_speeds &=
 			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
 		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
@@ -2167,6 +2166,23 @@ int fcoe_link_ok(struct fc_lport *lport)
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
+	if (netif_oper_up(netdev))
+		return 0;
+	return -1;
+}
+
+/**
  * fcoe_percpu_clean() - Clear all pending skbs for an local port
  * @lport: The local port whose skbs are to be cleared
  *

