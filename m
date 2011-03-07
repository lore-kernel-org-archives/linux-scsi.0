From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH 2/6] [SCSI] bnx2fc: Return ERESTARTSYS on rtnl_trylock
 failure
Date: Mon, 7 Mar 2011 15:42:25 -0800
Message-ID: <1299541349-2438-2-git-send-email-mchan@broadcom.com>
References: <1299541349-2438-1-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4224 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab1CHAgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 19:36:42 -0500
In-Reply-To: <1299541349-2438-1-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, michaelc@cs.wisc.edu, bprakash@broadcom.com, nsujir@broadcom.com, Michael Chan <mchan@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

This is needed so that the user request is retried and does not fail.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e476e87..cfb49b1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1433,7 +1433,7 @@ static int bnx2fc_destroy(struct net_device *netdev)
 	int rc = 0;
 
 	if (!rtnl_trylock())
-		return restart_syscall();
+		return -ERESTARTSYS;
 
 	mutex_lock(&bnx2fc_dev_lock);
 #ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
@@ -1805,10 +1805,8 @@ static int bnx2fc_disable(struct net_device *netdev)
 	struct ethtool_drvinfo drvinfo;
 	int rc = 0;
 
-	if (!rtnl_trylock()) {
-		printk(KERN_ERR PFX "retrying for rtnl_lock\n");
-		return -EIO;
-	}
+	if (!rtnl_trylock())
+		return -ERESTARTSYS;
 
 	mutex_lock(&bnx2fc_dev_lock);
 
@@ -1867,10 +1865,8 @@ static int bnx2fc_enable(struct net_device *netdev)
 	struct ethtool_drvinfo drvinfo;
 	int rc = 0;
 
-	if (!rtnl_trylock()) {
-		printk(KERN_ERR PFX "retrying for rtnl_lock\n");
-		return -EIO;
-	}
+	if (!rtnl_trylock())
+		return -ERESTARTSYS;
 
 	BNX2FC_MISC_DBG("Entered %s\n", __func__);
 	mutex_lock(&bnx2fc_dev_lock);
@@ -1942,10 +1938,9 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
 		return -EIO;
 	}
 
-	if (!rtnl_trylock()) {
-		printk(KERN_ERR "trying for rtnl_lock\n");
-		return -EIO;
-	}
+	if (!rtnl_trylock())
+		return -ERESTARTSYS;
+
 	mutex_lock(&bnx2fc_dev_lock);
 
 #ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
-- 
1.6.4.GIT


