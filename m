From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/10] fcoe: add fip retry to avoid missing critical keep alive
Date: Wed, 27 Jul 2011 15:11:05 -0700
Message-ID: <20110727221105.23675.3526.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab1G0WLI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:11:08 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Use pending queue to retry FIP frame in case its tx
fails and use common pending queue for both fcoe
and fip frames using fcoe_port_send.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 945df21..528b86b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -487,6 +487,19 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *netdev,
 }
 
 /**
+ * fcoe_port_send() - Send an Ethernet-encapsulated FIP/FCoE frame
+ * @port: The FCoE port
+ * @skb: The FIP/FCoE packet to be sent
+ */
+static void fcoe_port_send(struct fcoe_port *port, struct sk_buff *skb)
+{
+	if (port->fcoe_pending_queue.qlen)
+		fcoe_check_wait_queue(port->lport, skb);
+	else if (fcoe_start_io(skb))
+		fcoe_check_wait_queue(port->lport, skb);
+}
+
+/**
  * fcoe_fip_send() - Send an Ethernet-encapsulated FIP frame
  * @fip: The FCoE controller
  * @skb: The FIP packet to be sent
@@ -494,7 +507,7 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *netdev,
 static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	skb->dev = fcoe_from_ctlr(fip)->netdev;
-	dev_queue_xmit(skb);
+	fcoe_port_send(lport_priv(fip->lp), skb);
 }
 
 /**
@@ -1575,11 +1588,7 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 
 	/* send down to lld */
 	fr_dev(fp) = lport;
-	if (port->fcoe_pending_queue.qlen)
-		fcoe_check_wait_queue(lport, skb);
-	else if (fcoe_start_io(skb))
-		fcoe_check_wait_queue(lport, skb);
-
+	fcoe_port_send(port, skb);
 	return 0;
 }
 

