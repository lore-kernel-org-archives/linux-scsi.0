From: giridhar.malavali@qlogic.com
Subject: [PATCH 04/16] qla2xxx: Add char device to increase driver use count
Date: Tue,  4 May 2010 15:01:24 -0700
Message-ID: <1273010496-43045-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47142 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754927Ab0EDWBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:38 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

The driver should not be unloaded if any application is using it.
To disallow driver unload, driver use count must be incremented.
Application uses this char device as handle and increases driver
use count to avoid possible driver unload.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 ++-
 drivers/scsi/qla2xxx/qla_os.c  |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index edb7a70..d4a53e5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -35,7 +35,8 @@
 
 #include "qla_bsg.h"
 #include "qla_nx.h"
-#define QLA2XXX_DRIVER_NAME  "qla2xxx"
+#define QLA2XXX_DRIVER_NAME	"qla2xxx"
+#define QLA2XXX_APIDEV		"ql2xapidev"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f2102db..10c14af 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -24,6 +24,8 @@
  */
 char qla2x00_version_str[40];
 
+static int apidev_major;
+
 /*
  * SRB allocation cache
  */
@@ -3763,6 +3765,10 @@ static struct pci_driver qla2xxx_pci_driver = {
 	.err_handler	= &qla2xxx_err_handler,
 };
 
+static struct file_operations apidev_fops = {
+	.owner = THIS_MODULE,
+};
+
 /**
  * qla2x00_module_init - Module initialization.
  **/
@@ -3791,6 +3797,13 @@ qla2x00_module_init(void)
 		kmem_cache_destroy(srb_cachep);
 		return -ENODEV;
 	}
+
+	apidev_major = register_chrdev(0, QLA2XXX_APIDEV, &apidev_fops);
+	if (apidev_major < 0) {
+		printk(KERN_WARNING "qla2xxx: Unable to register char device "
+		    "%s\n", QLA2XXX_APIDEV);
+	}
+
 	qla2xxx_transport_vport_template =
 	    fc_attach_transport(&qla2xxx_transport_vport_functions);
 	if (!qla2xxx_transport_vport_template) {
@@ -3816,6 +3829,7 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
+	unregister_chrdev(apidev_major, QLA2XXX_APIDEV);
 	pci_unregister_driver(&qla2xxx_pci_driver);
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
-- 
1.6.2.rc1.30.gd43c

