From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/21] bnx2fc: add support to get_netdev for bnx2f_interface
Date: Tue, 19 Feb 2013 11:31:42 -0800
Message-ID: <20130219193142.10192.66667.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416Ab3BSTbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:31:43 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
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

