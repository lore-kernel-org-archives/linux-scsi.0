From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 8/8] fcoe: Fix broken NPIV with correction to MAC validation
Date: Fri, 08 Oct 2010 17:12:46 -0700
Message-ID: <20101009001246.7744.57021.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAMr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:47 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

A previous patch attempted to validate the destination
MAC address of a FCoE frame by checking that MAC
address against the received port's MAC address. The
implementation seems fine on the surface, but any
VN_Ports added using the NPIV feature will have their
own MAC addresses and these MACs were not being checked,
which prevented any NPIV VN_Ports from receiving frames.

In other words, the following patch has broken NPIV.

519e5135e2537c9dbc1cbcc0891b0a936ff5dcd2
 [SCSI] fcoe: adds src and dest mac address
              checking for fcoe frames

Part of the offending patch is correct, but the part
that broke NPIV was attempting to satisfy FC-BB-5
section D.5, 2.1-

(discard frames that) "contain a destination MAC
address/destination N_Port_ID pair that was not
assigned by an FCF to one of the VN_Ports on the ENode"

The language does _not_ say to compare the destination
=46C-MAP/destination N_Port_ID, but instead to compare
the destination MAC address/destination N_Port_ID.

>From the FC-BB-5 specification,

"A properly formed FPMA is one in which the 24 most
significant bits equal the Fabric=E2=80=99s FC-MAP value and
the least significant 24 bits equal the N_Port_ID
assigned to the VN_Port by the FCF."

This means that we need to compare the FC Frame's
destination FCID against the embedded FCID in the
destination MAC address. This patch checks the lower
24 bits of the destination MAC address against
destination FCID in the Fibre Channel frame.

=46or MAC validation the first line of defense is the
hardware MAC filtering. Each VN_Port will have a
unicast MAC addresses added to the hardware's
filtering table. The Ethernet driver should drop any
MACs not destined for a programmed MAC. This patch
adds a second line of defense that very specfically
compares an element in the FC frame against an element
in the Ethernet header, which is appropriate for the
=46CoE layer.

Many alternative approaches were considered, including
a LLD callback from libfc. The second most reasonable
approach seemed to be walking the list of NPIV ports
and check each of their MAC addresses against the
destination MAC address of the received frame. The
problem with this approach was that it is likely that
performance would suffer with the more NPIV ports added
to the system since every received frame would need to
walk this list, comparing each entry's MAC.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8225b82..d23a538 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1243,7 +1243,6 @@ int fcoe_rcv(struct sk_buff *skb, struct net_devi=
ce *netdev,
 	struct fcoe_interface *fcoe;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
-	struct fcoe_port *port;
 	struct ethhdr *eh;
 	unsigned int cpu;
=20
@@ -1262,16 +1261,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_dev=
ice *netdev,
 			skb_tail_pointer(skb), skb_end_pointer(skb),
 			skb->csum, skb->dev ? skb->dev->name : "<NULL>");
=20
-	/* check for mac addresses */
 	eh =3D eth_hdr(skb);
-	port =3D lport_priv(lport);
-	if (compare_ether_addr(eh->h_dest, port->data_src_addr) &&
-	    compare_ether_addr(eh->h_dest, fcoe->ctlr.ctl_src_addr) &&
-	    compare_ether_addr(eh->h_dest, (u8[6])FC_FCOE_FLOGI_MAC)) {
-		FCOE_NETDEV_DBG(netdev, "wrong destination mac address:%pM\n",
-				eh->h_dest);
-		goto err;
-	}
=20
 	if (is_fip_mode(&fcoe->ctlr) &&
 	    compare_ether_addr(eh->h_source, fcoe->ctlr.dest_addr)) {
@@ -1291,6 +1281,12 @@ int fcoe_rcv(struct sk_buff *skb, struct net_dev=
ice *netdev,
 	skb_set_transport_header(skb, sizeof(struct fcoe_hdr));
 	fh =3D (struct fc_frame_header *) skb_transport_header(skb);
=20
+	if (ntoh24(&eh->h_dest[3]) !=3D ntoh24(fh->fh_d_id)) {
+		FCOE_NETDEV_DBG(netdev, "FC frame d_id mismatch with MAC:%pM\n",
+				eh->h_dest);
+		goto err;
+	}
+
 	fr =3D fcoe_dev_from_skb(skb);
 	fr->fr_dev =3D lport;
 	fr->ptype =3D ptype;

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
