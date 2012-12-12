From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/16] bnx2fc: add support to get_netdev for bnx2f_interface
Date: Wed, 12 Dec 2012 15:23:13 -0800
Message-ID: <20121212232313.13084.34379.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12428 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LLXXO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:23:14 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Adds support to fcoe_port's newly added get_netdev fucntion pointer for bnx2fc.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8d975ef..9b9ccc9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -119,7 +119,7 @@ static inline struct net_device *bnx2fc_netdev(const struct fc_lport *lport)
 static void bnx2fc_get_lesb(struct fc_lport *lport,
 			    struct fc_els_lesb *fc_lesb)
 {
-	struct net_device *netdev = bnx2fc_netdev(lport);
+	struct net_device *netdev = fcoe_get_netdev(lport);
 
 	__fcoe_get_lesb(lport, fc_lesb, netdev);
 }
@@ -127,7 +127,7 @@ static void bnx2fc_get_lesb(struct fc_lport *lport,
 static void bnx2fc_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev)
 {
 	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr_dev);
-	struct net_device *netdev = bnx2fc_netdev(fip->lp);
+	struct net_device *netdev = fcoe_get_netdev(fip->lp);
 	struct fcoe_fc_els_lesb *fcoe_lesb;
 	struct fc_els_lesb fc_lesb;
 
@@ -1499,6 +1499,7 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 	port = lport_priv(lport);
 	port->lport = lport;
 	port->priv = interface;
+	port->get_netdev = bnx2fc_netdev;
 	INIT_WORK(&port->destroy_work, bnx2fc_destroy_work);
 
 	/* Configure fcoe_port */

