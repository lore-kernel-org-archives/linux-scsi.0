From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/64] fcoe: move packet handlers from fcoe_port to
	fcoe_interface
Date: Tue, 25 Aug 2009 13:59:41 -0700
Message-ID: <20090825205941.1553.67661.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbZHYU7j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:39 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

The packet handlers need to be tracked in fcoe_interface so there is only one
set per net_device.  When NPIV is enabled there will be multiple SCSI hosts
and multiple fcoe_port structures on a single net_device.

The packet handlers match by ethertype and netdev.  If the same handler gets
registered on a single netdev multiple times, the receive function will be
called multiple times for each frame.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   28 ++++++++++++++++------------
 drivers/scsi/fcoe/fcoe.h |    4 ++--
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 44c963c..c215235 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -151,9 +151,11 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
 			 struct packet_type *ptype,
 			 struct net_device *orig_dev)
 {
+	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
 
-	port = container_of(ptype, struct fcoe_port, fip_packet_type);
+	fcoe = container_of(ptype, struct fcoe_interface, fip_packet_type);
+	port = fcoe->priv;
 	fcoe_ctlr_recv(&port->ctlr, skb);
 	return 0;
 }
@@ -235,8 +237,8 @@ void fcoe_netdev_cleanup(struct fcoe_port *port)
 	struct fcoe_interface *fcoe = port->fcoe;
 
 	/* Don't listen for Ethernet packets anymore */
-	dev_remove_pack(&port->fcoe_packet_type);
-	dev_remove_pack(&port->fip_packet_type);
+	dev_remove_pack(&fcoe->fcoe_packet_type);
+	dev_remove_pack(&fcoe->fip_packet_type);
 
 	/* Delete secondary MAC addresses */
 	rtnl_lock();
@@ -368,15 +370,15 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	 * setup the receive function from ethernet driver
 	 * on the ethertype for the given device
 	 */
-	port->fcoe_packet_type.func = fcoe_rcv;
-	port->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
-	port->fcoe_packet_type.dev = netdev;
-	dev_add_pack(&port->fcoe_packet_type);
+	fcoe->fcoe_packet_type.func = fcoe_rcv;
+	fcoe->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	fcoe->fcoe_packet_type.dev = netdev;
+	dev_add_pack(&fcoe->fcoe_packet_type);
 
-	port->fip_packet_type.func = fcoe_fip_recv;
-	port->fip_packet_type.type = htons(ETH_P_FIP);
-	port->fip_packet_type.dev = netdev;
-	dev_add_pack(&port->fip_packet_type);
+	fcoe->fip_packet_type.func = fcoe_fip_recv;
+	fcoe->fip_packet_type.type = htons(ETH_P_FIP);
+	fcoe->fip_packet_type.dev = netdev;
+	dev_add_pack(&fcoe->fip_packet_type);
 
 	return 0;
 }
@@ -926,12 +928,14 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct fc_lport *lp;
 	struct fcoe_rcv_info *fr;
+	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
 	unsigned int cpu;
 
-	port = container_of(ptype, struct fcoe_port, fcoe_packet_type);
+	fcoe = container_of(ptype, struct fcoe_interface, fcoe_packet_type);
+	port = fcoe->priv;
 	lp = port->ctlr.lp;
 	if (unlikely(lp == NULL)) {
 		FCOE_NETDEV_DBG(dev, "Cannot find hba structure");
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 3b3886e..685aa9d 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -83,6 +83,8 @@ struct fcoe_interface {
 	 * moved out of fcoe_port */
 	struct fcoe_port *priv;
 	struct net_device *netdev;
+	struct packet_type  fcoe_packet_type;
+	struct packet_type  fip_packet_type;
 };
 
 /*
@@ -92,8 +94,6 @@ struct fcoe_interface {
 struct fcoe_port {
 	struct fcoe_interface *fcoe;
 	struct fc_exch_mgr *oem;		/* offload exchange manger */
-	struct packet_type  fcoe_packet_type;
-	struct packet_type  fip_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
 	u8	fcoe_pending_queue_active;
 	struct timer_list timer;		/* queue timer */

