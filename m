From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] fcoe: move fcoe_interface_remove() out of fcoe_interface_cleanup()
Date: Thu, 31 Aug 2017 11:19:32 +0200
Message-ID: <1504171174-37989-2-git-send-email-hare@suse.de>
References: <1504171174-37989-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750918AbdHaJT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 05:19:58 -0400
In-Reply-To: <1504171174-37989-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 85f9a3e..135bdcf 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -501,11 +501,6 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	struct net_device *netdev = fcoe->netdev;
 	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
 
-	rtnl_lock();
-	if (!fcoe->removed)
-		fcoe_interface_remove(fcoe);
-	rtnl_unlock();
-
 	/* Release the self-reference taken during fcoe_interface_create() */
 	/* tear-down the FCoE controller */
 	fcoe_ctlr_destroy(fip);
@@ -2140,6 +2135,11 @@ static void fcoe_destroy_work(struct work_struct *work)
 	cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
 
 	fcoe_if_destroy(port->lport);
+
+	rtnl_lock();
+	if (!fcoe->removed)
+		fcoe_interface_remove(fcoe);
+	rtnl_unlock();
 	fcoe_interface_cleanup(fcoe);
 
 	mutex_unlock(&fcoe_config_mutex);
@@ -2254,6 +2254,8 @@ static int _fcoe_create(struct net_device *netdev, enum fip_mode fip_mode,
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
 		rc = -EIO;
+		if (!fcoe->removed)
+			fcoe_interface_remove(fcoe);
 		rtnl_unlock();
 		fcoe_interface_cleanup(fcoe);
 		mutex_unlock(&fcoe_config_mutex);
-- 
1.8.5.6
