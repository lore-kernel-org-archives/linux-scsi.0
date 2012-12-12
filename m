From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/16] bnx2fc: use fcoe_get_lesb/fcoe_ctlr_get_lesb() directly
 from libfcoe
Date: Wed, 12 Dec 2012 15:23:24 -0800
Message-ID: <20121212232324.13084.65058.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44563 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LLXXZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:23:25 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Drop the bnx2fc_xxx versions as they are basically the same.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   53 +++++--------------------------------
 1 file changed, 7 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a1c687c..4d5c721 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -93,7 +93,6 @@ static void bnx2fc_port_shutdown(struct fc_lport *lport);
 static void bnx2fc_stop(struct bnx2fc_interface *interface);
 static int __init bnx2fc_mod_init(void);
 static void __exit bnx2fc_mod_exit(void);
-static void bnx2fc_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev);
 
 unsigned int bnx2fc_debug_level;
 module_param_named(debug_logging, bnx2fc_debug_level, int, S_IRUGO|S_IWUSR);
@@ -111,44 +110,6 @@ static inline struct net_device *bnx2fc_netdev(const struct fc_lport *lport)
 		((struct fcoe_port *)lport_priv(lport))->priv)->netdev;
 }
 
-/**
- * bnx2fc_get_lesb() - Fill the FCoE Link Error Status Block
- * @lport: the local port
- * @fc_lesb: the link error status block
- */
-static void bnx2fc_get_lesb(struct fc_lport *lport,
-			    struct fc_els_lesb *fc_lesb)
-{
-	struct net_device *netdev = fcoe_get_netdev(lport);
-
-	__fcoe_get_lesb(lport, fc_lesb, netdev);
-}
-
-static void bnx2fc_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev)
-{
-	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr_dev);
-	struct net_device *netdev = fcoe_get_netdev(fip->lp);
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
-}
-EXPORT_SYMBOL(bnx2fc_ctlr_get_lesb);
-
 static void bnx2fc_fcf_get_vlan_id(struct fcoe_fcf_device *fcf_dev)
 {
 	struct fcoe_ctlr_device *ctlr_dev =
@@ -2637,12 +2598,12 @@ module_exit(bnx2fc_mod_exit);
 
 static struct fcoe_sysfs_function_template bnx2fc_fcoe_sysfs_templ = {
 	.set_fcoe_ctlr_enabled = bnx2fc_ctlr_enabled,
-	.get_fcoe_ctlr_link_fail = bnx2fc_ctlr_get_lesb,
-	.get_fcoe_ctlr_vlink_fail = bnx2fc_ctlr_get_lesb,
-	.get_fcoe_ctlr_miss_fka = bnx2fc_ctlr_get_lesb,
-	.get_fcoe_ctlr_symb_err = bnx2fc_ctlr_get_lesb,
-	.get_fcoe_ctlr_err_block = bnx2fc_ctlr_get_lesb,
-	.get_fcoe_ctlr_fcs_error = bnx2fc_ctlr_get_lesb,
+	.get_fcoe_ctlr_link_fail = fcoe_ctlr_get_lesb,
+	.get_fcoe_ctlr_vlink_fail = fcoe_ctlr_get_lesb,
+	.get_fcoe_ctlr_miss_fka = fcoe_ctlr_get_lesb,
+	.get_fcoe_ctlr_symb_err = fcoe_ctlr_get_lesb,
+	.get_fcoe_ctlr_err_block = fcoe_ctlr_get_lesb,
+	.get_fcoe_ctlr_fcs_error = fcoe_ctlr_get_lesb,
 
 	.get_fcoe_fcf_selected = fcoe_fcf_get_selected,
 	.get_fcoe_fcf_vlan_id = bnx2fc_fcf_get_vlan_id,
@@ -2749,7 +2710,7 @@ static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
 	.elsct_send		= bnx2fc_elsct_send,
 	.fcp_abort_io		= bnx2fc_abort_io,
 	.fcp_cleanup		= bnx2fc_cleanup,
-	.get_lesb		= bnx2fc_get_lesb,
+	.get_lesb		= fcoe_get_lesb,
 	.rport_event_callback	= bnx2fc_rport_event_handler,
 };
 

