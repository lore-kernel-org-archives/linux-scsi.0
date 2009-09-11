From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/35] libfc: Move libfc_init and libfc_exit to fc_libfc.c
Date: Fri, 11 Sep 2009 16:57:27 -0700
Message-ID: <20090911235727.27223.81341.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18953 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbZIKX5Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:57:24 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

These routines are for the libfc kernel module and should be in
the libfc .c file.

Moving the libfc __init routine into fc_libfc.c caused the creation
of the fc_setup_fcp() and fc_destroy_fcp() routines so that
scsi_pkt_cachep was not exposed outside of fc_fcp.c.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c   |   63 +++++++++++++++--------------------------
 drivers/scsi/libfc/fc_libfc.c |   39 +++++++++++++++++++++++++
 drivers/scsi/libfc/fc_libfc.h |    2 +
 3 files changed, 64 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5cd81ff..389c9d5 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -41,7 +41,7 @@
 
 #include "fc_libfc.h"
 
-static struct kmem_cache *scsi_pkt_cachep;
+struct kmem_cache *scsi_pkt_cachep;
 
 /* SRB state definitions */
 #define FC_SRB_FREE		0		/* cmd is free */
@@ -2072,6 +2072,28 @@ void fc_fcp_destroy(struct fc_lport *lp)
 }
 EXPORT_SYMBOL(fc_fcp_destroy);
 
+int fc_setup_fcp()
+{
+	int rc = 0;
+
+	scsi_pkt_cachep = kmem_cache_create("libfc_fcp_pkt",
+					    sizeof(struct fc_fcp_pkt),
+					    0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!scsi_pkt_cachep) {
+		printk(KERN_ERR "libfc: Unable to allocate SRB cache, "
+		       "module load failed!");
+		rc = -ENOMEM;
+	}
+
+	return rc;
+}
+
+void fc_destroy_fcp()
+{
+	if (scsi_pkt_cachep)
+		kmem_cache_destroy(scsi_pkt_cachep);
+}
+
 int fc_fcp_init(struct fc_lport *lp)
 {
 	int rc;
@@ -2104,42 +2126,3 @@ free_internal:
 	return rc;
 }
 EXPORT_SYMBOL(fc_fcp_init);
-
-static int __init libfc_init(void)
-{
-	int rc;
-
-	scsi_pkt_cachep = kmem_cache_create("libfc_fcp_pkt",
-					    sizeof(struct fc_fcp_pkt),
-					    0, SLAB_HWCACHE_ALIGN, NULL);
-	if (scsi_pkt_cachep == NULL) {
-		printk(KERN_ERR "libfc: Unable to allocate SRB cache, "
-		       "module load failed!");
-		return -ENOMEM;
-	}
-
-	rc = fc_setup_exch_mgr();
-	if (rc)
-		goto destroy_pkt_cache;
-
-	rc = fc_setup_rport();
-	if (rc)
-		goto destroy_em;
-
-	return rc;
-destroy_em:
-	fc_destroy_exch_mgr();
-destroy_pkt_cache:
-	kmem_cache_destroy(scsi_pkt_cachep);
-	return rc;
-}
-
-static void __exit libfc_exit(void)
-{
-	kmem_cache_destroy(scsi_pkt_cachep);
-	fc_destroy_exch_mgr();
-	fc_destroy_rport();
-}
-
-module_init(libfc_init);
-module_exit(libfc_exit);
diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index e64ea87..01418ae 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -33,3 +33,42 @@ MODULE_LICENSE("GPL v2");
 unsigned int fc_debug_logging;
 module_param_named(debug_logging, fc_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
+
+/**
+ * libfc_init() - Initialize libfc.ko
+ */
+static int __init libfc_init(void)
+{
+	int rc = 0;
+
+	rc = fc_setup_fcp();
+	if (rc)
+		return rc;
+
+	rc = fc_setup_exch_mgr();
+	if (rc)
+		goto destroy_pkt_cache;
+
+	rc = fc_setup_rport();
+	if (rc)
+		goto destroy_em;
+
+	return rc;
+destroy_em:
+	fc_destroy_exch_mgr();
+destroy_pkt_cache:
+	fc_destroy_fcp();
+	return rc;
+}
+module_init(libfc_init);
+
+/**
+ * libfc_exit() - Tear down libfc.ko
+ */
+static void __exit libfc_exit(void)
+{
+	fc_destroy_fcp();
+	fc_destroy_exch_mgr();
+	fc_destroy_rport();
+}
+module_exit(libfc_exit);
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index 388fae4..0530149 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -93,6 +93,8 @@ int fc_setup_exch_mgr(void);
 void fc_destroy_exch_mgr(void);
 int fc_setup_rport(void);
 void fc_destroy_rport(void);
+int fc_setup_fcp(void);
+void fc_destroy_fcp(void);
 
 /*
  * Internal libfc functions

