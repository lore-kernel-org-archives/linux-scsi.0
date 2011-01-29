From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/28] fcoe: Fix module reference count for vports
Date: Fri, 28 Jan 2011 16:03:47 -0800
Message-ID: <20110129000347.1784.60143.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5725 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1A2ADs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:48 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

vports are not grabbing module references but are
releasing them. This causes the module reference count
to decrement too many times and it wraps around past 0.

The solution is to do a module_put() in
fcoe_interface_release() so that the reference is only
released when the fcoe_interface is released. There is a
one-to-one relationship between the N_Port and the
fcoe_interface, so the module reference will only be
dropped when the N_Port is destroyed

To create symetry in the code this patch moves the
try_module_get() call into fcoe_interface_create(). This
means that only the N_Port will grab a reference to the
module when its corresponding fcoe_interface is created.

This patch also makes it so that the fcoe_interface_create()
routine encodes any error codes in the fcoe_interface
pointer returned. This way its caller, fcoe_create(), can
return an accurate error code.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9f9600b..452b421 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -356,10 +356,18 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	struct fcoe_interface *fcoe;
 	int err;
 
+	if (!try_module_get(THIS_MODULE)) {
+		FCOE_NETDEV_DBG(netdev,
+				"Could not get a reference to the module\n");
+		fcoe = ERR_PTR(-EBUSY);
+		goto out;
+	}
+
 	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
 	if (!fcoe) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
-		return NULL;
+		fcoe = ERR_PTR(-ENOMEM);
+		goto out_nomod;
 	}
 
 	dev_hold(netdev);
@@ -378,9 +386,15 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 		fcoe_ctlr_destroy(&fcoe->ctlr);
 		kfree(fcoe);
 		dev_put(netdev);
-		return NULL;
+		fcoe = ERR_PTR(err);
+		goto out_nomod;
 	}
 
+	goto out;
+
+out_nomod:
+	module_put(THIS_MODULE);
+out:
 	return fcoe;
 }
 
@@ -442,6 +456,7 @@ static void fcoe_interface_release(struct kref *kref)
 	fcoe_ctlr_destroy(&fcoe->ctlr);
 	kfree(fcoe);
 	dev_put(netdev);
+	module_put(THIS_MODULE);
 }
 
 /**
@@ -886,7 +901,6 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 
 	/* Release the Scsi_Host */
 	scsi_host_put(lport->host);
-	module_put(THIS_MODULE);
 }
 
 /**
@@ -2135,15 +2149,10 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	 */
 	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
 		rc = -ENODEV;
-		goto out_nomod;
+		goto out_nodev;
 	}
 #endif
 
-	if (!try_module_get(THIS_MODULE)) {
-		rc = -EINVAL;
-		goto out_nomod;
-	}
-
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
 		rc = -ENODEV;
@@ -2157,8 +2166,8 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 
 	fcoe = fcoe_interface_create(netdev, fip_mode);
-	if (!fcoe) {
-		rc = -ENOMEM;
+	if (IS_ERR(fcoe)) {
+		rc = PTR_ERR(fcoe);
 		goto out_putdev;
 	}
 
@@ -2198,8 +2207,6 @@ out_free:
 out_putdev:
 	dev_put(netdev);
 out_nodev:
-	module_put(THIS_MODULE);
-out_nomod:
 	rtnl_unlock();
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;

