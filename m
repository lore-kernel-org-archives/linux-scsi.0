From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 6/8] bnx2fc: Fix panic caused because of incorrect
 errror handling in create().
Date: Tue, 30 Aug 2011 15:54:52 -0700
Message-ID: <1314744894-24710-7-git-send-email-bprakash@broadcom.com>
References: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3373 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1H3WzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:06 -0400
In-Reply-To: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, nsujir@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Driver incorrectly calls bnx2fc_interface_cleanup() when bnx2fc_if_create fails
which accesses bad pointer. Handle bnx2fc_if_create failure by directly calling
bnx2fc_net_cleanup.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a5111f3..330f9f0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1441,6 +1441,14 @@ free_blport:
 	return NULL;
 }
 
+static void bnx2fc_net_cleanup(struct bnx2fc_interface *interface)
+{
+	/* Dont listen for Ethernet packets anymore */
+	__dev_remove_pack(&interface->fcoe_packet_type);
+	__dev_remove_pack(&interface->fip_packet_type);
+	synchronize_net();
+}
+
 static void bnx2fc_interface_cleanup(struct bnx2fc_interface *interface)
 {
 	struct fc_lport *lport = interface->ctlr.lp;
@@ -1453,10 +1461,7 @@ static void bnx2fc_interface_cleanup(struct bnx2fc_interface *interface)
 	/* Free existing transmit skbs */
 	fcoe_clean_pending_queue(lport);
 
-	/* Dont listen for Ethernet packets anymore */
-	__dev_remove_pack(&interface->fcoe_packet_type);
-	__dev_remove_pack(&interface->fip_packet_type);
-	synchronize_net();
+	bnx2fc_net_cleanup(interface);
 
 	bnx2fc_free_vport(hba, lport);
 }
@@ -1991,7 +1996,6 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 	if (!lport) {
 		printk(KERN_ERR PFX "Failed to create interface (%s)\n",
 			netdev->name);
-		bnx2fc_interface_cleanup(interface);
 		rc = -EINVAL;
 		goto if_create_err;
 	}
@@ -2026,6 +2030,7 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 if_create_err:
 	destroy_workqueue(interface->timer_work_queue);
 ifput_err:
+	bnx2fc_net_cleanup(interface);
 	bnx2fc_interface_put(interface);
 netdev_err:
 	module_put(THIS_MODULE);
-- 
1.7.0.6


