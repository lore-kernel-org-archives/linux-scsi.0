From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/11] fcoe: remove unnecessary module state check
Date: Fri, 01 Apr 2011 16:06:04 -0700
Message-ID: <20110401230604.15001.56084.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab1DAXGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:15 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

The check of module state being MODULE_STATE_LIVE is no longer needed for the
individual fcoe transport driver, e.g., fcoe.ko, as sysfs entries now go to
libfcoe now, if it reaches fcoe.ko, it has to be already registered. The module
state check for libfcoe will guard the possible race condition of sysfs being
writable before module_init function is called and after module_exit.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   47 ----------------------------------------------
 1 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9e7206e..34408d9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1783,17 +1783,6 @@ static int fcoe_disable(struct net_device *netdev)
 	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
-#ifdef CONFIG_FCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module paramter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-#endif
 
 	rtnl_lock();
 	fcoe = fcoe_hostlist_lookup_port(netdev);
@@ -1805,7 +1794,6 @@ static int fcoe_disable(struct net_device *netdev)
 	} else
 		rc = -ENODEV;
 
-out_nodev:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
@@ -1824,17 +1812,6 @@ static int fcoe_enable(struct net_device *netdev)
 	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
-#ifdef CONFIG_FCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module paramter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-#endif
 	rtnl_lock();
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
@@ -1844,7 +1821,6 @@ static int fcoe_enable(struct net_device *netdev)
 	else if (!fcoe_link_ok(fcoe->ctlr.lp))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 
-out_nodev:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
@@ -1863,17 +1839,6 @@ static int fcoe_destroy(struct net_device *netdev)
 	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
-#ifdef CONFIG_FCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module paramter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-#endif
 	rtnl_lock();
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	if (!fcoe) {
@@ -1938,18 +1903,6 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	mutex_lock(&fcoe_config_mutex);
 	rtnl_lock();
 
-#ifdef CONFIG_FCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module paramter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-#endif
-
 	/* look for existing lport */
 	if (fcoe_hostlist_lookup(netdev)) {
 		rc = -EEXIST;

