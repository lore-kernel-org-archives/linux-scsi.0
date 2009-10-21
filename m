From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/20] fcoe: Call ndo_fcoe_enable/disable to turn FCoE feature
	on/off in LLD
Date: Wed, 21 Oct 2009 16:28:03 -0700
Message-ID: <20091021232803.12986.70299.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52447 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZJUX2b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:28:31 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Calls ndo_fcoe_enabled() of the associated netdev upon creating the FCoE
instance to make sure LLD has all necessary resources allocated and setup
properly before passing FCoE traffic. Similarly, calls ndo_fcoe_disable()
upon destroying the FCoE instance on the associated netdev to allow the LLD
to release all allocated resources for FCoE.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c66b9fa..aef29af 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -161,9 +161,18 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
 	struct netdev_hw_addr *ha;
 	u8 flogi_maddr[ETH_ALEN];
+	const struct net_device_ops *ops;
 
 	fcoe->netdev = netdev;
 
+	/* Let LLD initialize for FCoE */
+	ops = netdev->netdev_ops;
+	if (ops->ndo_fcoe_enable) {
+		if (ops->ndo_fcoe_enable(netdev))
+			FCOE_NETDEV_DBG(netdev, "Failed to enable FCoE"
+					" specific feature for LLD.\n");
+	}
+
 	/* Do not support for bonding device */
 	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
 	    (netdev->priv_flags & IFF_SLAVE_INACTIVE) ||
@@ -262,6 +271,7 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	struct net_device *netdev = fcoe->netdev;
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
 	u8 flogi_maddr[ETH_ALEN];
+	const struct net_device_ops *ops;
 
 	/*
 	 * Don't listen for Ethernet packets anymore.
@@ -281,6 +291,14 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	if (fip->spma)
 		dev_unicast_delete(netdev, fip->ctl_src_addr);
 	dev_mc_delete(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+
+	/* Tell the LLD we are done w/ FCoE */
+	ops = netdev->netdev_ops;
+	if (ops->ndo_fcoe_disable) {
+		if (ops->ndo_fcoe_disable(netdev))
+			FCOE_NETDEV_DBG(netdev, "Failed to disable FCoE"
+					" specific feature for LLD.\n");
+	}
 }
 
 /**

