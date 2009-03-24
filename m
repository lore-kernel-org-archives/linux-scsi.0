From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fcoe: prep work to completely remove fc_transport_fcoe code
Date: Tue, 24 Mar 2009 16:19:14 -0700
Message-ID: <20090324231914.25065.44829.stgit@fritz>
References: <20090317184151.22987.73806.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbZCXXTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 19:19:16 -0400
In-Reply-To: <20090317184151.22987.73806.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomeley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

The fcoe transport code was added for generic FCoE transport
infrastructure to allow additional offload related module loading
on demand, this is not required anymore after recently added
different offload approach by having offload related func ops
in netdev.

This patch removes fcoe transport related code use, calls functions
directly between existing libfcoe.c and fcoe_sw.c for now, for
example fcoe_sw_destroy and fcoe_sw_create calling.

The fcoe_sw.c and libfcoe.c code will be further consolidated in
later patches and then also the default fcoe sw transport code
file fcoe_sw.c will be completely removed.

The fcoe transport code files are completely removed in next
patch to keep this patch simple for reviewing.

--

This patch is an update to a previous patch. This update
resolves a build error as well as fixes a defect related to
not calling fc_release_transport().

The following updates to the other patches in the series
are just adjustments to the changes this update introduces.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/Makefile  |    3 +--
 drivers/scsi/fcoe/fcoe_sw.c |   37 ++++---------------------------------
 drivers/scsi/fcoe/libfcoe.c |   25 ++++++-------------------
 include/scsi/libfcoe.h      |    2 ++
 4 files changed, 13 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index b78da06..e950adf 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -4,5 +4,4 @@ obj-$(CONFIG_FCOE) += fcoe.o
 
 fcoe-y := \
 	libfcoe.o \
-	fcoe_sw.o \
-	fc_transport_fcoe.o
+	fcoe_sw.o
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index a675390..f060220 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -36,7 +36,6 @@
 
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
-#include <scsi/fc_transport_fcoe.h>
 
 #define FCOE_SW_VERSION	"0.1"
 #define	FCOE_SW_NAME	"fcoesw"
@@ -302,7 +301,7 @@ static inline int fcoe_sw_em_config(struct fc_lport *lp)
  *
  * Returns: 0 if link is OK for use by FCoE.
  */
-static int fcoe_sw_destroy(struct net_device *netdev)
+int fcoe_sw_destroy(struct net_device *netdev)
 {
 	struct fc_lport *lp = NULL;
 	struct fcoe_softc *fc;
@@ -415,7 +414,7 @@ static struct libfc_function_template fcoe_sw_libfc_fcn_templ = {
  *
  * Returns : 0 on success
  */
-static int fcoe_sw_create(struct net_device *netdev)
+int fcoe_sw_create(struct net_device *netdev)
 {
 	int rc;
 	struct fc_lport *lp = NULL;
@@ -494,28 +493,7 @@ out_host_put:
 }
 
 /**
- * fcoe_sw_match() - The FCoE SW transport match function
- *
- * Returns : false always
- */
-static bool fcoe_sw_match(struct net_device *netdev)
-{
-	/* FIXME - for sw transport, always return false */
-	return false;
-}
-
-/* the sw hba fcoe transport */
-struct fcoe_transport fcoe_sw_transport = {
-	.name = "fcoesw",
-	.create = fcoe_sw_create,
-	.destroy = fcoe_sw_destroy,
-	.match = fcoe_sw_match,
-	.vendor = 0x0,
-	.device = 0xffff,
-};
-
-/**
- * fcoe_sw_init() - Registers fcoe_sw_transport
+ * fcoe_sw_init() - attach to scsi transport
  *
  * Returns : 0 on success
  */
@@ -530,23 +508,16 @@ int __init fcoe_sw_init(void)
 		return -ENODEV;
 	}
 
-	mutex_init(&fcoe_sw_transport.devlock);
-	INIT_LIST_HEAD(&fcoe_sw_transport.devlist);
-
-	/* register sw transport */
-	fcoe_transport_register(&fcoe_sw_transport);
 	return 0;
 }
 
 /**
- * fcoe_sw_exit() - Unregisters fcoe_sw_transport
+ * fcoe_sw_exit() - detach from scsi transport
  *
  * Returns : 0 on success
  */
 int __exit fcoe_sw_exit(void)
 {
-	/* dettach the transport */
 	fc_release_transport(scsi_transport_fcoe_sw);
-	fcoe_transport_unregister(&fcoe_sw_transport);
 	return 0;
 }
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 951d244..334db95 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -44,7 +44,6 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_frame.h>
 #include <scsi/libfcoe.h>
-#include <scsi/fc_transport_fcoe.h>
 
 static int debug_fcoe;
 
@@ -1081,10 +1080,9 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		rc = -ENODEV;
 		goto out_putdev;
 	}
-	/* pass to transport */
-	rc = fcoe_transport_release(netdev);
+	rc = fcoe_sw_destroy(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_transport_release(%s) failed\n",
+		printk(KERN_ERR "fcoe: fcoe_sw_destroy(%s) failed\n",
 		       netdev->name);
 		rc = -EIO;
 		goto out_putdev;
@@ -1121,10 +1119,9 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 	fcoe_ethdrv_get(netdev);
 
-	/* pass to transport */
-	rc = fcoe_transport_attach(netdev);
+	rc = fcoe_sw_create(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_transport_attach(%s) failed\n",
+		printk(KERN_ERR "fcoe: fcoe_sw_create(%s) failed\n",
 		       netdev->name);
 		fcoe_ethdrv_put(netdev);
 		rc = -EIO;
@@ -1429,10 +1426,6 @@ EXPORT_SYMBOL_GPL(fcoe_libfc_config);
 /**
  * fcoe_init() - fcoe module loading initialization
  *
- * Initialization routine
- * 1. Will create fc transport software structure
- * 2. initialize the link list of port information structure
- *
  * Returns 0 on success, negative on failure
  */
 static int __init fcoe_init(void)
@@ -1464,9 +1457,6 @@ static int __init fcoe_init(void)
 
 	mod_timer(&fcoe_timer, jiffies + (10 * HZ));
 
-	/* initiatlize the fcoe transport */
-	fcoe_transport_init();
-
 	fcoe_sw_init();
 
 	return 0;
@@ -1495,9 +1485,9 @@ static void __exit fcoe_exit(void)
 	/* Stop the timer */
 	del_timer_sync(&fcoe_timer);
 
-	/* releases the associated fcoe transport for each lport */
+	/* releases the associated fcoe hosts */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
-		fcoe_transport_release(fc->real_dev);
+		fcoe_sw_destroy(fc->real_dev);
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 
@@ -1507,8 +1497,5 @@ static void __exit fcoe_exit(void)
 
 	/* remove sw trasnport */
 	fcoe_sw_exit();
-
-	/* detach the transport */
-	fcoe_transport_exit();
 }
 module_exit(fcoe_exit);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 1ad4f93..dc64405 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -149,4 +149,6 @@ int fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
 /* fcoe sw hba */
 int __init fcoe_sw_init(void);
 int __exit fcoe_sw_exit(void);
+int fcoe_sw_create(struct net_device *);
+int fcoe_sw_destroy(struct net_device *);
 #endif /* _LIBFCOE_H */

