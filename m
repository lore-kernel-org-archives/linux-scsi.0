From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 50/54] fcoe: Fix using VLAN ID in creating lport's WWWN/WWPN
Date: Tue, 03 Nov 2009 11:49:59 -0800
Message-ID: <20091103194959.4085.81317.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbZKCTtz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:55 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

If the underlying netdev is a VLAN device, make sure the VLAN ID is integrated
into the WWNN/WWPN name generation. Also added/updated the comments to reflect
this change.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index fba7ba0..28029a3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -555,6 +555,7 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	u64 wwnn, wwpn;
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
+	int vid = 0;
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lport);
@@ -599,10 +600,16 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lport);
 
 	if (!lport->vport) {
+		/*
+		 * Use NAA 1&2 (FC-FS Rev. 2.0, Sec. 15) to generate WWNN/WWPN:
+		 * For WWNN, we use NAA 1 w/ bit 27-16 of word 0 as 0.
+		 * For WWPN, we use NAA 2 w/ bit 27-16 of word 0 from VLAN ID
+		 */
+		if (netdev->priv_flags & IFF_802_1Q_VLAN)
+			vid = vlan_dev_vlan_id(netdev);
 		wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
 		fc_set_wwnn(lport, wwnn);
-		/* XXX - 3rd arg needs to be vlan id */
-		wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, 0);
+		wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, vid);
 		fc_set_wwpn(lport, wwpn);
 	}
 

