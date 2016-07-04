From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] fcoe: Use default VLAN for FIP VLAN discovery
Date: Mon,  4 Jul 2016 10:29:23 +0200
Message-ID: <1467620963-67047-7-git-send-email-hare@suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbcGDI3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 04:29:34 -0400
In-Reply-To: <1467620963-67047-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

FC-BB-6 states:
FIP protocols shall be performed on a per-VLAN basis. It is
recommended to use the FIP VLAN discovery protocol on the
default VLAN.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/fcoe/fcoe.h |  1 +
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c8a4305..197dc62 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -92,6 +92,8 @@ static struct fcoe_interface
 
 static int fcoe_fip_recv(struct sk_buff *, struct net_device *,
 			 struct packet_type *, struct net_device *);
+static int fcoe_fip_vlan_recv(struct sk_buff *, struct net_device *,
+			      struct packet_type *, struct net_device *);
 
 static void fcoe_fip_send(struct fcoe_ctlr *, struct sk_buff *);
 static void fcoe_update_src_mac(struct fc_lport *, u8 *);
@@ -363,6 +365,12 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	fcoe->fip_packet_type.dev = netdev;
 	dev_add_pack(&fcoe->fip_packet_type);
 
+	if (netdev != real_dev) {
+		fcoe->fip_vlan_packet_type.func = fcoe_fip_vlan_recv;
+		fcoe->fip_vlan_packet_type.type = htons(ETH_P_FIP);
+		fcoe->fip_vlan_packet_type.dev = real_dev;
+		dev_add_pack(&fcoe->fip_vlan_packet_type);
+	}
 	return 0;
 }
 
@@ -450,6 +458,8 @@ static void fcoe_interface_remove(struct fcoe_interface *fcoe)
 	 */
 	__dev_remove_pack(&fcoe->fcoe_packet_type);
 	__dev_remove_pack(&fcoe->fip_packet_type);
+	if (netdev != fcoe->realdev)
+		__dev_remove_pack(&fcoe->fip_vlan_packet_type);
 	synchronize_net();
 
 	/* Delete secondary MAC addresses */
@@ -520,6 +530,29 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *netdev,
 }
 
 /**
+ * fcoe_fip_vlan_recv() - Handler for received FIP VLAN discovery frames
+ * @skb:      The receive skb
+ * @netdev:   The associated net device
+ * @ptype:    The packet_type structure which was used to register this handler
+ * @orig_dev: The original net_device the the skb was received on.
+ *	      (in case dev is a bond)
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_fip_vlan_recv(struct sk_buff *skb, struct net_device *netdev,
+			      struct packet_type *ptype,
+			      struct net_device *orig_dev)
+{
+	struct fcoe_interface *fcoe;
+	struct fcoe_ctlr *ctlr;
+
+	fcoe = container_of(ptype, struct fcoe_interface, fip_vlan_packet_type);
+	ctlr = fcoe_to_ctlr(fcoe);
+	fcoe_ctlr_recv(ctlr, skb);
+	return 0;
+}
+
+/**
  * fcoe_port_send() - Send an Ethernet-encapsulated FIP/FCoE frame
  * @port: The FCoE port
  * @skb: The FIP/FCoE packet to be sent
@@ -539,7 +572,21 @@ static void fcoe_port_send(struct fcoe_port *port, struct sk_buff *skb)
  */
 static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
-	skb->dev = fcoe_from_ctlr(fip)->netdev;
+	struct fcoe_interface *fcoe = fcoe_from_ctlr(fip);
+	struct fip_frame {
+		struct ethhdr eth;
+		struct fip_header fip;
+	} __packed *frame;
+
+	/*
+	 * Use default VLAN for FIP VLAN discovery protocol
+	 */
+	frame = (struct fip_frame *)skb->data;
+	if (frame->fip.fip_op == ntohs(FIP_OP_VLAN) &&
+	    fcoe->realdev != fcoe->netdev)
+		skb->dev = fcoe->realdev;
+	else
+		skb->dev = fcoe->netdev;
 	fcoe_port_send(lport_priv(fip->lp), skb);
 }
 
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 2b53672..6aa4820 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -80,6 +80,7 @@ struct fcoe_interface {
 	struct net_device  *realdev;
 	struct packet_type fcoe_packet_type;
 	struct packet_type fip_packet_type;
+	struct packet_type fip_vlan_packet_type;
 	struct fc_exch_mgr *oem;
 	u8	removed;
 	u8	priority;
-- 
1.8.5.6

