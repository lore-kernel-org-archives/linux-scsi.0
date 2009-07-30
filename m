From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/22] fcoe: Call dev_ethtool_get_settings() in fcoe_link_ok
Date: Wed, 29 Jul 2009 17:04:01 -0700
Message-ID: <20090730000400.24658.32062.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:7967 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZG3AED (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:03 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

No need to check phys_dev here, just call dev_ethtool_get_settings() directly
will take care of this.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index b7dfc6e..8160126 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1635,29 +1635,25 @@ int fcoe_link_ok(struct fc_lport *lp)
 	struct fcoe_softc *fc = lport_priv(lp);
 	struct net_device *dev = fc->real_dev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
-	int rc = 0;
 
-	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev)) {
-		dev = fc->phys_dev;
-		if (dev->ethtool_ops->get_settings) {
-			dev->ethtool_ops->get_settings(dev, &ecmd);
-			lp->link_supported_speeds &=
-				~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
-			if (ecmd.supported & (SUPPORTED_1000baseT_Half |
-					      SUPPORTED_1000baseT_Full))
-				lp->link_supported_speeds |= FC_PORTSPEED_1GBIT;
-			if (ecmd.supported & SUPPORTED_10000baseT_Full)
-				lp->link_supported_speeds |=
-					FC_PORTSPEED_10GBIT;
-			if (ecmd.speed == SPEED_1000)
-				lp->link_speed = FC_PORTSPEED_1GBIT;
-			if (ecmd.speed == SPEED_10000)
-				lp->link_speed = FC_PORTSPEED_10GBIT;
-		}
-	} else
-		rc = -1;
+	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev) &&
+	    (!dev_ethtool_get_settings(dev, &ecmd))) {
+		lp->link_supported_speeds &=
+			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
+		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
+				      SUPPORTED_1000baseT_Full))
+			lp->link_supported_speeds |= FC_PORTSPEED_1GBIT;
+		if (ecmd.supported & SUPPORTED_10000baseT_Full)
+			lp->link_supported_speeds |=
+				FC_PORTSPEED_10GBIT;
+		if (ecmd.speed == SPEED_1000)
+			lp->link_speed = FC_PORTSPEED_1GBIT;
+		if (ecmd.speed == SPEED_10000)
+			lp->link_speed = FC_PORTSPEED_10GBIT;
 
-	return rc;
+		return 0;
+	}
+	return -1;
 }
 
 /**

