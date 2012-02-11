From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/12] fcoe: Rename out_nomod label to out_putmod
Date: Fri, 10 Feb 2012 17:18:36 -0800
Message-ID: <20120211011836.7668.98422.stgit@localhost6.localdomain6>
References: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59649 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761210Ab2BKBSh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 20:18:37 -0500
In-Reply-To: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

The label implies that it should be called when
there is 'nomod.' I read that to mean that the
module reference 'get' failed. However, it's only
called when the module reference 'get' succeeded.

I think it makes more sense to name the label,
'out_putmod' since it should be called when we
need to 'put' the module reference taken in the
routine before returning.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 5e77f23..449df17 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -372,7 +372,7 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	if (!fcoe) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
 		fcoe = ERR_PTR(-ENOMEM);
-		goto out_nomod;
+		goto out_putmod;
 	}
 
 	dev_hold(netdev);
@@ -392,12 +392,12 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 		kfree(fcoe);
 		dev_put(netdev);
 		fcoe = ERR_PTR(err);
-		goto out_nomod;
+		goto out_putmod;
 	}
 
 	goto out;
 
-out_nomod:
+out_putmod:
 	module_put(THIS_MODULE);
 out:
 	return fcoe;

