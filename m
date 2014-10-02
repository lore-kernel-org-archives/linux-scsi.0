From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH] cxgb4i : fix rtnl lock assertion
Date: Thu,  2 Oct 2014 13:59:34 -0700
Message-ID: <1412283574-23119-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:36147
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751282AbaJBVCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 17:02:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com, Anish Bhatt <anish@chelsio.com>

We should have been calling netdev_master_upper_dev_get_rcu() instead of
netdev_master_upper_dev_get() all along since this is called with an 
rcu_read_lock()

Please queue up for the next set of fixes for 3.17 as well.
-Anish

Signed-off-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Karen Xie <kxie@chelsio.com>

Fixes: 759a0cc5a3e1 ("cxgb4i: Add ipv6 code to driver, call into libcxgbi")
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 79788a1..963c764 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1720,7 +1720,7 @@ static int update_root_dev_clip(struct net_device *dev)
 		return ret;
 
 	/* Parse all bond and vlan devices layered on top of the physical dev */
-	root_dev = netdev_master_upper_dev_get(dev);
+	root_dev = netdev_master_upper_dev_get_rcu(dev);
 	if (root_dev) {
 		ret = update_dev_clip(root_dev, dev);
 		if (ret)
-- 
2.1.2

