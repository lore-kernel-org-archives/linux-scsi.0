From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [V2 PATCH 7/8] bnx2fc: Remove unnecessary module state checks
Date: Thu, 17 Mar 2011 17:13:35 -0700
Message-ID: <1300407215.644.410.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1899 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab1CRANq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 20:13:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Nithin Sujir <nsujir@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>Nithin Sujir <nsujir@broadcom.com>

The check for module state MODULE_STATE_LIVE is no longer required for LLDs, as
libfcoe transport takes care of it. Reference:
http://marc.info/?l=linux-scsi&m=129989565903046&w=2

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index aab55e2..38a00fe 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1395,12 +1395,6 @@ static int bnx2fc_destroy(struct net_device *netdev)
 	rtnl_lock();
 
 	mutex_lock(&bnx2fc_dev_lock);
-#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto netdev_err;
-	}
-#endif
 	/* obtain physical netdev */
 	if (netdev->priv_flags & IFF_802_1Q_VLAN)
 		phys_dev = vlan_dev_real_dev(netdev);
@@ -1768,11 +1762,6 @@ static int bnx2fc_disable(struct net_device *netdev)
 
 	mutex_lock(&bnx2fc_dev_lock);
 
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto nodev;
-	}
-
 	/* obtain physical netdev */
 	if (netdev->priv_flags & IFF_802_1Q_VLAN)
 		phys_dev = vlan_dev_real_dev(netdev);
@@ -1828,11 +1817,6 @@ static int bnx2fc_enable(struct net_device *netdev)
 	BNX2FC_MISC_DBG("Entered %s\n", __func__);
 	mutex_lock(&bnx2fc_dev_lock);
 
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto nodev;
-	}
-
 	/* obtain physical netdev */
 	if (netdev->priv_flags & IFF_802_1Q_VLAN)
 		phys_dev = vlan_dev_real_dev(netdev);
@@ -1899,13 +1883,6 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 
 	mutex_lock(&bnx2fc_dev_lock);
 
-#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto mod_err;
-	}
-#endif
-
 	if (!try_module_get(THIS_MODULE)) {
 		rc = -EINVAL;
 		goto mod_err;
-- 
1.7.0.6




