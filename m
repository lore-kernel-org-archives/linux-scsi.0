From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 06/18] bnx2fc: Change function names of
 bnx2fc_netdev_setup/bnx2fc_netdev_cleanup
Date: Thu, 4 Aug 2011 17:38:40 -0700
Message-ID: <1312504732-4572-7-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2238 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab1HEAjM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:12 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Change them to bnx2fc_interface_setup/bnx2fc_interface_cleanup in preperation
for the patches to follow. Interface specific cleanup functionality will be
moved to bnx2fc_interface_cleanup.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 21792e7..407a9b8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1064,7 +1064,7 @@ static int bnx2fc_vport_disable(struct fc_vport *vport, bool disable)
 }
 
 
-static int bnx2fc_netdev_setup(struct bnx2fc_interface *interface)
+static int bnx2fc_interface_setup(struct bnx2fc_interface *interface)
 {
 	struct net_device *netdev = interface->netdev;
 	struct net_device *physdev = interface->hba->phys_dev;
@@ -1262,7 +1262,7 @@ struct bnx2fc_interface *bnx2fc_interface_create(struct bnx2fc_hba *hba,
 	interface->ctlr.get_src_addr = bnx2fc_get_src_mac;
 	set_bit(BNX2FC_CTLR_INIT_DONE, &interface->if_flags);
 
-	rc = bnx2fc_netdev_setup(interface);
+	rc = bnx2fc_interface_setup(interface);
 	if (!rc)
 		return interface;
 
@@ -1382,7 +1382,7 @@ free_blport:
 	return NULL;
 }
 
-static void bnx2fc_netdev_cleanup(struct bnx2fc_interface *interface)
+static void bnx2fc_interface_cleanup(struct bnx2fc_interface *interface)
 {
 	/* Dont listen for Ethernet packets anymore */
 	__dev_remove_pack(&interface->fcoe_packet_type);
@@ -1459,7 +1459,7 @@ static int bnx2fc_destroy(struct net_device *netdev)
 
 	hba = interface->hba;
 
-	bnx2fc_netdev_cleanup(interface);
+	bnx2fc_interface_cleanup(interface);
 	lport = interface->ctlr.lp;
 	bnx2fc_stop(interface);
 	list_del(&interface->list);
@@ -1938,7 +1938,7 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 	if (!lport) {
 		printk(KERN_ERR PFX "Failed to create interface (%s)\n",
 			netdev->name);
-		bnx2fc_netdev_cleanup(interface);
+		bnx2fc_interface_cleanup(interface);
 		rc = -EINVAL;
 		goto if_create_err;
 	}
@@ -2057,7 +2057,7 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 	list_for_each_entry_safe(interface, tmp, &if_list, list) {
 		/* destroy not called yet, move to quiesced list */
 		if (interface->hba == hba) {
-			bnx2fc_netdev_cleanup(interface);
+			bnx2fc_interface_cleanup(interface);
 			bnx2fc_stop(interface);
 
 			list_del(&interface->list);
-- 
1.7.0.6


