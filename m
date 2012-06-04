From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/6] bnx2fc: Support interface creation on non-VLAN
 interface also.
Date: Mon, 4 Jun 2012 16:15:44 -0700
Message-ID: <1338851747-7240-4-git-send-email-bprakash@broadcom.com>
References: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3116 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761187Ab2FDXQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jun 2012 19:16:01 -0400
In-Reply-To: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

bnx2fc had an assumption that the fcoe interface will always start on the vlan
dev. However, some switch implementations (Eg., HP virtual connect FlexFabric)
expects the fcoe interface to be started on physical interface. Do not error
out if the netdev is not a vlan dev.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index dd28af7..f75308c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2019,11 +2019,11 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 	struct fcoe_ctlr *ctlr;
 	struct bnx2fc_interface *interface;
 	struct bnx2fc_hba *hba;
-	struct net_device *phys_dev;
+	struct net_device *phys_dev = netdev;
 	struct fc_lport *lport;
 	struct ethtool_drvinfo drvinfo;
 	int rc = 0;
-	int vlan_id;
+	int vlan_id = 0;
 
 	BNX2FC_MISC_DBG("Entered bnx2fc_create\n");
 	if (fip_mode != FIP_MODE_FABRIC) {
@@ -2041,14 +2041,9 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 	}
 
 	/* obtain physical netdev */
-	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
+	if (netdev->priv_flags & IFF_802_1Q_VLAN)
 		phys_dev = vlan_dev_real_dev(netdev);
-		vlan_id = vlan_dev_vlan_id(netdev);
-	} else {
-		printk(KERN_ERR PFX "Not a vlan device\n");
-		rc = -EINVAL;
-		goto netdev_err;
-	}
+
 	/* verify if the physical device is a netxtreme2 device */
 	if (phys_dev->ethtool_ops && phys_dev->ethtool_ops->get_drvinfo) {
 		memset(&drvinfo, 0, sizeof(drvinfo));
@@ -2083,9 +2078,13 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 		goto ifput_err;
 	}
 
+	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
+		vlan_id = vlan_dev_vlan_id(netdev);
+		interface->vlan_enabled = 1;
+	}
+
 	ctlr = bnx2fc_to_ctlr(interface);
 	interface->vlan_id = vlan_id;
-	interface->vlan_enabled = 1;
 
 	interface->timer_work_queue =
 			create_singlethread_workqueue("bnx2fc_timer_wq");
@@ -2252,15 +2251,17 @@ static int bnx2fc_fcoe_reset(struct Scsi_Host *shost)
 
 static bool bnx2fc_match(struct net_device *netdev)
 {
+	struct net_device *phys_dev = netdev;
+
 	mutex_lock(&bnx2fc_dev_lock);
-	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
-		struct net_device *phys_dev = vlan_dev_real_dev(netdev);
+	if (netdev->priv_flags & IFF_802_1Q_VLAN)
+		phys_dev = vlan_dev_real_dev(netdev);
 
-		if (bnx2fc_hba_lookup(phys_dev)) {
-			mutex_unlock(&bnx2fc_dev_lock);
-			return true;
-		}
+	if (bnx2fc_hba_lookup(phys_dev)) {
+		mutex_unlock(&bnx2fc_dev_lock);
+		return true;
 	}
+
 	mutex_unlock(&bnx2fc_dev_lock);
 	return false;
 }
-- 
1.7.0.6


