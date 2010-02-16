From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/9] fcoe: Only rmmod fcoe.ko if there are no active
	connections
Date: Tue, 16 Feb 2010 12:15:39 -0800
Message-ID: <20100216201539.26581.4392.stgit@localhost.localdomain>
References: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49472 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0BPUPk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:15:40 -0500
In-Reply-To: <20100216201513.26581.83756.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Currently we're gracefully tearing down each active connection
when fcoe.ko is removed. We shouldn't allow the user to destroy
connections by removing the module. We should force the user to
destroy each connection and then the module can be removed.

This patch makes it so a refrerence count on the module is taken
each time a fcoe_interface is created. The reference count
is dropped when the fcoe_interface is destroyed. This makes it
so that module_exit() doesn't get called unless all fcoe_interfaces
have been destroyed.

This patch leaves the removal of interfaces in the module_exit
routine so that if the user does a 'rmmod -f' we'll clean everything
up before removing the module.

The module_put line was put before the out_putdev goto line because
we should only be decrementing the reference count if a
fcoe_interface is actually destroyed. If we can't find the netdev
or the fcoe_interface then it's assumed that something else has
destroyed the fcoe_interface and it would have decremented the
reference count at that time.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 10be9f3..2f47ae7 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2009,6 +2009,8 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	fcoe_interface_cleanup(fcoe);
 	rtnl_unlock();
 	fcoe_if_destroy(fcoe->ctlr.lp);
+	module_put(THIS_MODULE);
+
 out_putdev:
 	dev_put(netdev);
 out_nodev:
@@ -2059,6 +2061,11 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 #endif
 
+	if (!try_module_get(THIS_MODULE)) {
+		rc = -EINVAL;
+		goto out_nomod;
+	}
+
 	rtnl_lock();
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
@@ -2099,17 +2106,24 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	if (!fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 
-	rc = 0;
-out_free:
 	/*
 	 * Release from init in fcoe_interface_create(), on success lport
 	 * should be holding a reference taken in fcoe_if_create().
 	 */
 	fcoe_interface_put(fcoe);
+	dev_put(netdev);
+	rtnl_unlock();
+	mutex_unlock(&fcoe_config_mutex);
+
+	return 0;
+out_free:
+	fcoe_interface_put(fcoe);
 out_putdev:
 	dev_put(netdev);
 out_nodev:
 	rtnl_unlock();
+	module_put(THIS_MODULE);
+out_nomod:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }

