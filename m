From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/64] fcoe: interface changes to fcoe_if_create and
	fcoe_if_destroy
Date: Tue, 25 Aug 2009 13:59:24 -0700
Message-ID: <20090825205924.1553.41830.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbZHYU7W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:22 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

By passing in the parent device instead of assuming the netdev is what
should be used, fcoe_if_create becomes usable for NPIV vports as well.
You still need a netdev, because that's how FCoE works.  Also removed some
duplicate checks from fcoe_if_create that are already in fcoe_create.

fcoe_if_destroy needs to take an lport as it's only argument, not a netdev.
That removes the 1:1 netdev:lport assumption from the destroy path.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |  113 ++++++++++++++++++++--------------------------
 1 files changed, 48 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index e481882..7492796 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -506,30 +506,20 @@ skip_oem:
 
 /**
  * fcoe_if_destroy() - FCoE software HBA tear-down function
- * @netdev: ptr to the associated net_device
- *
- * Returns: 0 if link is OK for use by FCoE.
+ * @lport: fc_lport to destroy
  */
-static int fcoe_if_destroy(struct net_device *netdev)
+static void fcoe_if_destroy(struct fc_lport *lport)
 {
-	struct fc_lport *lp = NULL;
-	struct fcoe_softc *fc;
-
-	BUG_ON(!netdev);
+	struct fcoe_softc *fc = lport_priv(lport);
+	struct net_device *netdev = fc->netdev;
 
 	FCOE_NETDEV_DBG(netdev, "Destroying interface\n");
 
-	lp = fcoe_hostlist_lookup(netdev);
-	if (!lp)
-		return -ENODEV;
-
-	fc = lport_priv(lp);
-
 	/* Logout of the fabric */
-	fc_fabric_logoff(lp);
+	fc_fabric_logoff(lport);
 
 	/* Remove the instance from fcoe's list */
-	fcoe_hostlist_remove(lp);
+	fcoe_hostlist_remove(lport);
 
 	/* clean up netdev configurations */
 	fcoe_netdev_cleanup(fc);
@@ -538,33 +528,31 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	fcoe_ctlr_destroy(&fc->ctlr);
 
 	/* Free queued packets for the per-CPU receive threads */
-	fcoe_percpu_clean(lp);
+	fcoe_percpu_clean(lport);
 
 	/* Cleanup the fc_lport */
-	fc_lport_destroy(lp);
-	fc_fcp_destroy(lp);
+	fc_lport_destroy(lport);
+	fc_fcp_destroy(lport);
 
 	/* Detach from the scsi-ml */
-	fc_remove_host(lp->host);
-	scsi_remove_host(lp->host);
+	fc_remove_host(lport->host);
+	scsi_remove_host(lport->host);
 
 	/* There are no more rports or I/O, free the EM */
-	fc_exch_mgr_free(lp);
+	fc_exch_mgr_free(lport);
 
 	/* Free existing skbs */
-	fcoe_clean_pending_queue(lp);
+	fcoe_clean_pending_queue(lport);
 
 	/* Stop the timer */
 	del_timer_sync(&fc->timer);
 
 	/* Free memory used by statistical counters */
-	fc_lport_free_stats(lp);
+	fc_lport_free_stats(lport);
 
 	/* Release the net_device and Scsi_Host */
 	dev_put(netdev);
-	scsi_host_put(lp->host);
-
-	return 0;
+	scsi_host_put(lport->host);
 }
 
 /*
@@ -612,38 +600,35 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 /**
  * fcoe_if_create() - this function creates the fcoe interface
  * @netdev: pointer the associated netdevice
+ * @parent: device pointer to be the parent in sysfs for the SCSI host
  *
  * Creates fc_lport struct and scsi_host for lport, configures lport
  * and starts fabric login.
  *
- * Returns : 0 on success
+ * Returns : The allocated fc_lport or an error pointer
  */
-static int fcoe_if_create(struct net_device *netdev)
+static struct fc_lport *fcoe_if_create(struct net_device *netdev,
+				       struct device *parent)
 {
 	int rc;
-	struct fc_lport *lp = NULL;
+	struct fc_lport *lport = NULL;
 	struct fcoe_softc *fc;
 	struct Scsi_Host *shost;
 
-	BUG_ON(!netdev);
-
 	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
-	lp = fcoe_hostlist_lookup(netdev);
-	if (lp)
-		return -EEXIST;
-
 	shost = libfc_host_alloc(&fcoe_shost_template,
 				 sizeof(struct fcoe_softc));
 	if (!shost) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
-	lp = shost_priv(shost);
-	fc = lport_priv(lp);
+	lport = shost_priv(shost);
+	fc = lport_priv(lport);
 
 	/* configure fc_lport, e.g., em */
-	rc = fcoe_lport_config(lp);
+	rc = fcoe_lport_config(lport);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure lport for the "
 				"interface\n");
@@ -658,7 +643,7 @@ static int fcoe_if_create(struct net_device *netdev)
 	fc->ctlr.update_mac = fcoe_update_src_mac;
 
 	/* configure lport network properties */
-	rc = fcoe_netdev_config(lp, netdev);
+	rc = fcoe_netdev_config(lport, netdev);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure netdev for the "
 				"interface\n");
@@ -666,7 +651,7 @@ static int fcoe_if_create(struct net_device *netdev)
 	}
 
 	/* configure lport scsi host properties */
-	rc = fcoe_shost_config(lp, shost, &netdev->dev);
+	rc = fcoe_shost_config(lport, shost, parent);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
 				"interface\n");
@@ -674,7 +659,7 @@ static int fcoe_if_create(struct net_device *netdev)
 	}
 
 	/* Initialize the library */
-	rc = fcoe_libfc_config(lp, &fcoe_libfc_fcn_templ);
+	rc = fcoe_libfc_config(lport, &fcoe_libfc_fcn_templ);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
 				"interface\n");
@@ -689,7 +674,7 @@ static int fcoe_if_create(struct net_device *netdev)
 	 */
 	write_lock(&fcoe_hostlist_lock);
 	/* lport exch manager allocation */
-	rc = fcoe_em_config(lp);
+	rc = fcoe_em_config(lport);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure the EM for the "
 				"interface\n");
@@ -697,27 +682,28 @@ static int fcoe_if_create(struct net_device *netdev)
 	}
 
 	/* add to lports list */
-	fcoe_hostlist_add(lp);
+	fcoe_hostlist_add(lport);
 	write_unlock(&fcoe_hostlist_lock);
 
-	lp->boot_time = jiffies;
+	lport->boot_time = jiffies;
 
-	fc_fabric_login(lp);
+	fc_fabric_login(lport);
 
-	if (!fcoe_link_ok(lp))
+	if (!fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fc->ctlr);
 
 	dev_hold(netdev);
 
-	return rc;
+	return lport;
 
 out_lp_destroy:
-	fc_exch_mgr_free(lp);
+	fc_exch_mgr_free(lport);
 out_netdev_cleanup:
 	fcoe_netdev_cleanup(fc);
 out_host_put:
-	scsi_host_put(lp->host);
-	return rc;
+	scsi_host_put(lport->host);
+out:
+	return ERR_PTR(rc);
 }
 
 /**
@@ -1616,8 +1602,9 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
  */
 static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 {
-	int rc;
 	struct net_device *netdev;
+	struct fc_lport *lport;
+	int rc;
 
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
@@ -1625,17 +1612,12 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 	}
 	/* look for existing lport */
-	if (!fcoe_hostlist_lookup(netdev)) {
+	lport = fcoe_hostlist_lookup(netdev);
+	if (!lport) {
 		rc = -ENODEV;
 		goto out_putdev;
 	}
-	rc = fcoe_if_destroy(netdev);
-	if (rc) {
-		printk(KERN_ERR "fcoe: Failed to destroy interface (%s)\n",
-		       netdev->name);
-		rc = -EIO;
-		goto out_putdev;
-	}
+	fcoe_if_destroy(lport);
 	fcoe_ethdrv_put(netdev);
 	rc = 0;
 out_putdev:
@@ -1654,6 +1636,7 @@ out_nodev:
 static int fcoe_create(const char *buffer, struct kernel_param *kp)
 {
 	int rc;
+	struct fc_lport *lport;
 	struct net_device *netdev;
 
 	netdev = fcoe_if_to_netdev(buffer);
@@ -1668,8 +1651,8 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 	fcoe_ethdrv_get(netdev);
 
-	rc = fcoe_if_create(netdev);
-	if (rc) {
+	lport = fcoe_if_create(netdev, &netdev->dev);
+	if (IS_ERR(lport)) {
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
 		fcoe_ethdrv_put(netdev);
@@ -1926,7 +1909,7 @@ static void __exit fcoe_exit(void)
 
 	/* releases the associated fcoe hosts */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
-		fcoe_if_destroy(fc->netdev);
+		fcoe_if_destroy(fc->ctlr.lp);
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 

