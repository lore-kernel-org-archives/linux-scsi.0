From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 26/28] Revert "[SCSI] fcoe: Fix using VLAN ID in creating
	lport's WWWN/WWPN"
Date: Tue, 20 Jul 2010 15:21:22 -0700
Message-ID: <20100720222122.17116.49253.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab0GTWVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:23 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

This reverts commit cc0136c2e9c10e889cb36e39710c0eb10707b396.

That commit introduced vlan id info to WWPN but WWPN needs to
remain static as an unique port identifier in the fabric, therefore
variable fabric vlan id info doesn't need to be coded inside WWPN.

After this revert, port arg to fcoe_wwn_from_mac is always zero
but still leaving it as-is okay to later allow users to use NAA 2
scheme with this additional port arg.

Note with this patch, existing zoning using WWPN would require
re-zoning this time only and later no more re-zoning due to any
vlan id changes.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cf9d718..ddd2ca2 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -647,7 +647,6 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	u64 wwnn, wwpn;
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
-	int vid = 0;
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lport);
@@ -677,20 +676,12 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	fcoe_link_speed_update(lport);
 
 	if (!lport->vport) {
-		/*
-		 * Use NAA 1&2 (FC-FS Rev. 2.0, Sec. 15) to generate WWNN/WWPN:
-		 * For WWNN, we use NAA 1 w/ bit 27-16 of word 0 as 0.
-		 * For WWPN, we use NAA 2 w/ bit 27-16 of word 0 from VLAN ID
-		 */
-		if (netdev->priv_flags & IFF_802_1Q_VLAN)
-			vid = vlan_dev_vlan_id(netdev);
-
 		if (fcoe_get_wwn(netdev, &wwnn, NETDEV_FCOE_WWNN))
 			wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
 		fc_set_wwnn(lport, wwnn);
 		if (fcoe_get_wwn(netdev, &wwpn, NETDEV_FCOE_WWPN))
 			wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr,
-						 2, vid);
+						 2, 0);
 		fc_set_wwpn(lport, wwpn);
 	}
 

