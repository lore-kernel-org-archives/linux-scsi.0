From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/22] zfcp: Implement module unloading
Date: Tue, 24 Nov 2009 16:54:04 +0100
Message-ID: <20091124160137.139085000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:59645 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=706-zfcp-module-unload.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With the reference counting for zfcp data structures, it is now
possible to implement module unloading again. Module unloading
requires to free all data structures in the module exit function. This
is done by unregistering zfcp from s390 cio and the SCSI midlayer
first in the module exit function.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   15 ++++++++++++++-
 drivers/s390/scsi/zfcp_ccw.c |   11 -----------
 drivers/s390/scsi/zfcp_ext.h |    1 -
 3 files changed, 14 insertions(+), 13 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:40.000000000 +0100
@@ -189,7 +189,7 @@ static int __init zfcp_module_init(void)
 		goto out_misc;
 	}
 
-	retval = zfcp_ccw_register();
+	retval = ccw_driver_register(&zfcp_ccw_driver);
 	if (retval) {
 		pr_err("The zfcp device driver could not register with "
 		       "the common I/O layer\n");
@@ -218,6 +218,19 @@ out:
 
 module_init(zfcp_module_init);
 
+static void __exit zfcp_module_exit(void)
+{
+	ccw_driver_unregister(&zfcp_ccw_driver);
+	misc_deregister(&zfcp_cfdc_misc);
+	fc_release_transport(zfcp_data.scsi_transport_template);
+	kmem_cache_destroy(zfcp_data.gid_pn_cache);
+	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
+	kmem_cache_destroy(zfcp_data.qtcb_cache);
+	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
+}
+
+module_exit(zfcp_module_exit);
+
 /**
  * zfcp_get_unit_by_lun - find unit in unit list of port by FCP LUN
  * @port: pointer to port to search for unit
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:40.000000000 +0100
@@ -279,14 +279,3 @@ struct ccw_driver zfcp_ccw_driver = {
 	.thaw	     = zfcp_ccw_activate,
 	.restore     = zfcp_ccw_activate,
 };
-
-/**
- * zfcp_ccw_register - ccw register function
- *
- * Registers the driver at the common i/o layer. This function will be called
- * at module load time/system start.
- */
-int __init zfcp_ccw_register(void)
-{
-	return ccw_driver_register(&zfcp_ccw_driver);
-}
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2009-11-23 09:59:40.000000000 +0100
@@ -27,7 +27,6 @@ extern void zfcp_adapter_release(struct 
 extern void zfcp_adapter_unregister(struct zfcp_adapter *);
 
 /* zfcp_ccw.c */
-extern int zfcp_ccw_register(void);
 extern int zfcp_ccw_priv_sch(struct zfcp_adapter *);
 extern struct ccw_driver zfcp_ccw_driver;
 extern struct zfcp_adapter *zfcp_ccw_adapter_by_cdev(struct ccw_device *);

