From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/3] fcoe: Remove match() and is_vendor fields in
 fcoe_transport structure
Date: Thu, 23 Dec 2010 21:35:53 -0800
Message-ID: <1293168953.4676.511.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1496 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0LXFg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:36:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, michaelc@cs.wisc.edu, yi.zou@intel.com

Based on the previous patch, match and is_vendor are no longer required.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/fcoe.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 711d441..79c6653 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2318,20 +2318,11 @@ static int fcoe_hostlist_add(const struct fc_lport *lport)
 	return 0;
 }
 
-static bool fcoe_match(struct net_device *netdev)
-{
-	/* SW transport, returns true always */
-	printk(KERN_ERR "SW FCoE transport:supports all netdev:input dev %s\n",
-		netdev->name);
-	return true;
-}
 
 static struct fcoe_transport fcoe_sw_transport = {
 	.name = {"fcoe"},
 	.attached = false,
-	.is_vendor = false,
 	.list = LIST_HEAD_INIT(fcoe_sw_transport.list),
-	.match = fcoe_match,
 	.create = fcoe_create,
 	.destroy = fcoe_destroy,
 	.enable = fcoe_enable,
@@ -2354,7 +2345,7 @@ static int __init fcoe_init(void)
 	if (rc) {
 		printk(KERN_ERR "failed to register an fcoe transport, check "
 			"if libfcoe is loaded\n");
-		goto out_return;
+		return rc;
 	}
 
 	mutex_lock(&fcoe_config_mutex);
@@ -2387,7 +2378,7 @@ out_free:
 		fcoe_percpu_thread_destroy(cpu);
 	}
 	mutex_unlock(&fcoe_config_mutex);
-out_return:
+
 	return rc;
 }
 module_init(fcoe_init);
-- 
1.7.0.6




