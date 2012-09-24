From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/3] fcoe: Fix write errors on NPIV ports
Date: Mon, 24 Sep 2012 11:52:45 -0700
Message-ID: <20120924185245.521.89525.stgit@fritz>
References: <20120924185240.521.22975.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab2IXSwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2012 14:52:46 -0400
In-Reply-To: <20120924185240.521.22975.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: John Fastabend <john.r.fastabend@intel.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Neerav Parikh <Neerav.Parikh@intel.com>, Yi Zou <yi.zou@intel.com>

From: Neerav Parikh <Neerav.Parikh@intel.com>

SCSI errors were generated while writing to LUNs
connected via NPIV ports.

Debugging this it was found that the FCoE packets
transmitted via the NPIV ports were not tagged with
correct user priority as negotiated with peer by DCB
agent. This resulted in FCoE traffic going with priority
zero(0) that did not have priority flow control (PFC)
enabled for it. The initiator after transferring data
to the target never saw any reply indicating the transfer
was complete. This resulted in error recovery (ABTS) and
SCSI command retries by the scsi-mid layer; eventually
resulting in I/O errors.

This patch fixes this issue by keeping the FCoE user
priority information in the fcoe_interface instance
that is common for both the physical port as well as
NPIV ports connected to that physical port; instead
of storing it in fcoe_port structure that has a per
port instance.

Signed-off-by: Neerav Parikh <Neerav.Parikh@intel.com>
Acked-by: Yi Zou <yi.zou@intel.com>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   14 +++++---------
 drivers/scsi/fcoe/fcoe.h |    2 ++
 include/scsi/libfcoe.h   |    2 --
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 078d262..666b7ac 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1643,7 +1643,7 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	skb_reset_network_header(skb);
 	skb->mac_len = elen;
 	skb->protocol = htons(ETH_P_FCOE);
-	skb->priority = port->priority;
+	skb->priority = fcoe->priority;
 
 	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN &&
 	    fcoe->realdev->features & NETIF_F_HW_VLAN_TX) {
@@ -1917,7 +1917,6 @@ static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
 	struct net_device *netdev;
-	struct fcoe_port *port;
 	int prio;
 
 	if (entry->app.selector != DCB_APP_IDTYPE_ETHTYPE)
@@ -1946,10 +1945,8 @@ static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 	    entry->app.protocol == ETH_P_FCOE)
 		ctlr->priority = prio;
 
-	if (entry->app.protocol == ETH_P_FCOE) {
-		port = lport_priv(ctlr->lp);
-		port->priority = prio;
-	}
+	if (entry->app.protocol == ETH_P_FCOE)
+		fcoe->priority = prio;
 
 	return NOTIFY_OK;
 }
@@ -2180,7 +2177,6 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 	u8 fup, up;
 	struct net_device *netdev = fcoe->realdev;
 	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
-	struct fcoe_port *port = lport_priv(ctlr->lp);
 	struct dcb_app app = {
 				.priority = 0,
 				.protocol = ETH_P_FCOE
@@ -2202,8 +2198,8 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 			fup = dcb_getapp(netdev, &app);
 		}
 
-		port->priority = ffs(up) ? ffs(up) - 1 : 0;
-		ctlr->priority = ffs(fup) ? ffs(fup) - 1 : port->priority;
+		fcoe->priority = ffs(up) ? ffs(up) - 1 : 0;
+		ctlr->priority = ffs(fup) ? ffs(fup) - 1 : fcoe->priority;
 	}
 #endif
 }
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index a624add..b42dc32 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -71,6 +71,7 @@ do {                                                            	\
  * @oem:	      The offload exchange manager for all local port
  *		      instances associated with this port
  * @removed:	      Indicates fcoe interface removed from net device
+ * @priority:	      Priority for the FCoE packet (DCB)
  * This structure is 1:1 with a net device.
  */
 struct fcoe_interface {
@@ -81,6 +82,7 @@ struct fcoe_interface {
 	struct packet_type fip_packet_type;
 	struct fc_exch_mgr *oem;
 	u8	removed;
+	u8	priority;
 };
 
 #define fcoe_to_ctlr(x)						\
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 22b07cc..8742d85 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -327,7 +327,6 @@ struct fcoe_percpu_s {
  * @lport:		       The associated local port
  * @fcoe_pending_queue:	       The pending Rx queue of skbs
  * @fcoe_pending_queue_active: Indicates if the pending queue is active
- * @priority:		       Packet priority (DCB)
  * @max_queue_depth:	       Max queue depth of pending queue
  * @min_queue_depth:	       Min queue depth of pending queue
  * @timer:		       The queue timer
@@ -343,7 +342,6 @@ struct fcoe_port {
 	struct fc_lport	      *lport;
 	struct sk_buff_head   fcoe_pending_queue;
 	u8		      fcoe_pending_queue_active;
-	u8		      priority;
 	u32		      max_queue_depth;
 	u32		      min_queue_depth;
 	struct timer_list     timer;

