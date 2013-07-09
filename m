From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/8] fcoe: fix the link error status block sparse warnings
Date: Tue, 09 Jul 2013 12:47:21 -0700
Message-ID: <20130709194721.10724.81339.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28408 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab3GITrV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:47:21 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Both fcoe_fc_els_lesb and fc_els_lesb are in __be32 already, and both are
exactly the same size in bytes, with somewhat different member names to
reflect the fact the former is for Ethernet media the latter is for Fiber
Channel, so, remove conversion and use __be32 directly. This fixes the warning
from sparse check.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index f3a5a53..bedd422 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -180,24 +180,10 @@ void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev)
 {
 	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr_dev);
 	struct net_device *netdev = fcoe_get_netdev(fip->lp);
-	struct fcoe_fc_els_lesb *fcoe_lesb;
-	struct fc_els_lesb fc_lesb;
-
-	__fcoe_get_lesb(fip->lp, &fc_lesb, netdev);
-	fcoe_lesb = (struct fcoe_fc_els_lesb *)(&fc_lesb);
-
-	ctlr_dev->lesb.lesb_link_fail =
-		ntohl(fcoe_lesb->lesb_link_fail);
-	ctlr_dev->lesb.lesb_vlink_fail =
-		ntohl(fcoe_lesb->lesb_vlink_fail);
-	ctlr_dev->lesb.lesb_miss_fka =
-		ntohl(fcoe_lesb->lesb_miss_fka);
-	ctlr_dev->lesb.lesb_symb_err =
-		ntohl(fcoe_lesb->lesb_symb_err);
-	ctlr_dev->lesb.lesb_err_block =
-		ntohl(fcoe_lesb->lesb_err_block);
-	ctlr_dev->lesb.lesb_fcs_error =
-		ntohl(fcoe_lesb->lesb_fcs_error);
+	struct fc_els_lesb *fc_lesb;
+
+	fc_lesb = (struct fc_els_lesb *)(&ctlr_dev->lesb);
+	__fcoe_get_lesb(fip->lp, fc_lesb, netdev);
 }
 EXPORT_SYMBOL_GPL(fcoe_ctlr_get_lesb);
 

