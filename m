From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [V2 PATCH 2/8] bnx2fc: Remove rtnl_trylock/restart_syscall
 checks
Date: Thu, 17 Mar 2011 17:13:27 -0700
Message-ID: <1300407207.644.405.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1899 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab1CRANl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 20:13:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Nithin Sujir <nsujir@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>Nithin Sujir <nsujir@broadcom.com>

From: Nithin Sujir <nsujir@broadcom.com>

Call rtnl_lock instead of rtnl_trylock & restart_syscall. This is bnx2fc
counterpart of fcoe fixes, here is the reference:
https://lists.open-fcoe.org/pipermail/devel/2011-March/011199.html

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e476e87..13271a4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1432,8 +1432,7 @@ static int bnx2fc_destroy(struct net_device *netdev)
 	struct net_device *phys_dev;
 	int rc = 0;
 
-	if (!rtnl_trylock())
-		return restart_syscall();
+	rtnl_lock();
 
 	mutex_lock(&bnx2fc_dev_lock);
 #ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
@@ -1805,10 +1804,7 @@ static int bnx2fc_disable(struct net_device *netdev)
 	struct ethtool_drvinfo drvinfo;
 	int rc = 0;
 
-	if (!rtnl_trylock()) {
-		printk(KERN_ERR PFX "retrying for rtnl_lock\n");
-		return -EIO;
-	}
+	rtnl_lock();
 
 	mutex_lock(&bnx2fc_dev_lock);
 
@@ -1867,10 +1863,7 @@ static int bnx2fc_enable(struct net_device *netdev)
 	struct ethtool_drvinfo drvinfo;
 	int rc = 0;
 
-	if (!rtnl_trylock()) {
-		printk(KERN_ERR PFX "retrying for rtnl_lock\n");
-		return -EIO;
-	}
+	rtnl_lock();
 
 	BNX2FC_MISC_DBG("Entered %s\n", __func__);
 	mutex_lock(&bnx2fc_dev_lock);
@@ -1942,10 +1935,8 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 		return -EIO;
 	}
 
-	if (!rtnl_trylock()) {
-		printk(KERN_ERR "trying for rtnl_lock\n");
-		return -EIO;
-	}
+	rtnl_lock();
+
 	mutex_lock(&bnx2fc_dev_lock);
 
 #ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
-- 
1.7.0.6




