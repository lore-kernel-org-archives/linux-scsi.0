From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/28] fcoe: adds src and dest mac address checking for fcoe
	frames
Date: Tue, 20 Jul 2010 15:19:32 -0700
Message-ID: <20100720221932.17116.31504.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761900Ab0GTWTc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:32 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

This is  per FC-BB-5 Annex-D recommendation and per that
if address checking fails then drop the frame.

FIP code paths are already doing this so only needed for fcoe
frames.

The src address checking is limited to only fip mode since
this might break non-fip mode used in p2p due to used OUI
based addressing in some p2p code paths, going forward FIP
will be the only mode, therefore limited this to only FIP
mode so that it won't break non-fip p2p mode for now.

-v2
Removes FCOE packet type checking since fcoe_rcv is
registered to receive only FCoE type packets from netdev
and it is already checked by netdev.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   20 +++++++++++++++++---
 include/scsi/libfcoe.h   |   10 ++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d340cf2..a120962 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1210,6 +1210,8 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	struct fcoe_interface *fcoe;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
+	struct fcoe_port *port;
+	struct ethhdr *eh;
 	unsigned int cpu;
 
 	fcoe = container_of(ptype, struct fcoe_interface, fcoe_packet_type);
@@ -1227,9 +1229,21 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 			skb_tail_pointer(skb), skb_end_pointer(skb),
 			skb->csum, skb->dev ? skb->dev->name : "<NULL>");
 
-	/* check for FCOE packet type */
-	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
-		FCOE_NETDEV_DBG(netdev, "Wrong FC type frame");
+	/* check for mac addresses */
+	eh = eth_hdr(skb);
+	port = lport_priv(lport);
+	if (compare_ether_addr(eh->h_dest, port->data_src_addr) &&
+	    compare_ether_addr(eh->h_dest, fcoe->ctlr.ctl_src_addr) &&
+	    compare_ether_addr(eh->h_dest, (u8[6])FC_FCOE_FLOGI_MAC)) {
+		FCOE_NETDEV_DBG(netdev, "wrong destination mac address:%pM\n",
+				eh->h_dest);
+		goto err;
+	}
+
+	if (is_fip_mode(&fcoe->ctlr) &&
+	    compare_ether_addr(eh->h_source, fcoe->ctlr.dest_addr)) {
+		FCOE_NETDEV_DBG(netdev, "wrong source mac address:%pM\n",
+				eh->h_source);
 		goto err;
 	}
 
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index ec13f51..81aee1c 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -170,4 +170,14 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
 
+/**
+ * is_fip_mode() - returns true if FIP mode selected.
+ * @fip:	FCoE controller.
+ */
+static inline bool is_fip_mode(struct fcoe_ctlr *fip)
+{
+	return fip->state == FIP_ST_ENABLED;
+}
+
+
 #endif /* _LIBFCOE_H */

