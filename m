From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/21] bnx2fc: use fcoe_link_speed_update() from the exported
 symbol in libfcoe
Date: Tue, 19 Feb 2013 11:31:48 -0800
Message-ID: <20130219193148.10192.99765.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8111 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416Ab3BSTbv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:31:51 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

We have fcoe_link_speed_update() in libfcoe ready for use now, take out the
bnx2fc version which is almost the same.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 9b9ccc9..a1c687c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -738,35 +738,6 @@ static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev)
 	return 0;
 }
 
-static void bnx2fc_link_speed_update(struct fc_lport *lport)
-{
-	struct fcoe_port *port = lport_priv(lport);
-	struct bnx2fc_interface *interface = port->priv;
-	struct net_device *netdev = interface->netdev;
-	struct ethtool_cmd ecmd;
-
-	if (!__ethtool_get_settings(netdev, &ecmd)) {
-		lport->link_supported_speeds &=
-			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
-		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
-				      SUPPORTED_1000baseT_Full))
-			lport->link_supported_speeds |= FC_PORTSPEED_1GBIT;
-		if (ecmd.supported & SUPPORTED_10000baseT_Full)
-			lport->link_supported_speeds |= FC_PORTSPEED_10GBIT;
-
-		switch (ethtool_cmd_speed(&ecmd)) {
-		case SPEED_1000:
-			lport->link_speed = FC_PORTSPEED_1GBIT;
-			break;
-		case SPEED_2500:
-			lport->link_speed = FC_PORTSPEED_2GBIT;
-			break;
-		case SPEED_10000:
-			lport->link_speed = FC_PORTSPEED_10GBIT;
-			break;
-		}
-	}
-}
 static int bnx2fc_link_ok(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
@@ -824,7 +795,7 @@ static int bnx2fc_net_config(struct fc_lport *lport, struct net_device *netdev)
 	port->fcoe_pending_queue_active = 0;
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long) lport);
 
-	bnx2fc_link_speed_update(lport);
+	fcoe_link_speed_update(lport);
 
 	if (!lport->vport) {
 		if (fcoe_get_wwn(netdev, &wwnn, NETDEV_FCOE_WWNN))
@@ -928,7 +899,7 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 		BNX2FC_HBA_DBG(lport, "netevent handler - event=%s %ld\n",
 				interface->netdev->name, event);
 
-		bnx2fc_link_speed_update(lport);
+		fcoe_link_speed_update(lport);
 
 		cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
 

