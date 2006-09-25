From: akpm@osdl.org
Subject: [patch 13/28] pci_module_init conversion in scsi subsystem
Date: Mon, 25 Sep 2006 16:58:58 -0700
Message-ID: <200609252358.k8PNwwHH003488@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:33467 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751767AbWIYX7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de, hch@lst.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Converts pci_module_init() to pci_register_driver() in the scsi subsys on
23 drivers which only return the value of pci_module_init().

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/3w-9xxx.c                 |    2 +-
 drivers/scsi/3w-xxxx.c                 |    2 +-
 drivers/scsi/a100u2w.c                 |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    3 +--
 drivers/scsi/dc395x.c                  |    2 +-
 drivers/scsi/dmx3191d.c                |    2 +-
 drivers/scsi/ipr.c                     |    2 +-
 drivers/scsi/nsp32.c                   |    2 +-
 drivers/scsi/qla1280.c                 |    2 +-
 10 files changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/3w-9xxx.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/3w-9xxx.c
@@ -2211,7 +2211,7 @@ static int __init twa_init(void)
 {
 	printk(KERN_WARNING "3ware 9000 Storage Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
 
-	return pci_module_init(&twa_driver);
+	return pci_register_driver(&twa_driver);
 } /* End twa_init() */
 
 /* This function is called on driver exit */
diff -puN drivers/scsi/3w-xxxx.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/3w-xxxx.c
@@ -2486,7 +2486,7 @@ static int __init tw_init(void)
 {
 	printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
 
-	return pci_module_init(&tw_driver);
+	return pci_register_driver(&tw_driver);
 } /* End tw_init() */
 
 /* This function is called on driver exit */
diff -puN drivers/scsi/a100u2w.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/a100u2w.c
--- a/drivers/scsi/a100u2w.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/a100u2w.c
@@ -1187,7 +1187,7 @@ static struct pci_driver inia100_pci_dri
 
 static int __init inia100_init(void)
 {
-	return pci_module_init(&inia100_pci_driver);
+	return pci_register_driver(&inia100_pci_driver);
 }
 
 static void __exit inia100_exit(void)
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -198,7 +198,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 int
 ahd_linux_pci_init(void)
 {
-	return (pci_module_init(&aic79xx_pci_driver));
+	return pci_register_driver(&aic79xx_pci_driver);
 }
 
 void
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -246,8 +246,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 int
 ahc_linux_pci_init(void)
 {
-	/* Translate error or zero return into zero or one */
-	return pci_module_init(&aic7xxx_pci_driver) ? 0 : 1;
+	return pci_register_driver(&aic7xxx_pci_driver);
 }
 
 void
diff -puN drivers/scsi/dc395x.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/dc395x.c
@@ -4949,7 +4949,7 @@ static struct pci_driver dc395x_driver =
  **/
 static int __init dc395x_module_init(void)
 {
-	return pci_module_init(&dc395x_driver);
+	return pci_register_driver(&dc395x_driver);
 }
 
 
diff -puN drivers/scsi/dmx3191d.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/dmx3191d.c
--- a/drivers/scsi/dmx3191d.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/dmx3191d.c
@@ -155,7 +155,7 @@ static struct pci_driver dmx3191d_pci_dr
 
 static int __init dmx3191d_init(void)
 {
-	return pci_module_init(&dmx3191d_pci_driver);
+	return pci_register_driver(&dmx3191d_pci_driver);
 }
 
 static void __exit dmx3191d_exit(void)
diff -puN drivers/scsi/ipr.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/ipr.c
@@ -6749,7 +6749,7 @@ static int __init ipr_init(void)
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);
 
-	return pci_module_init(&ipr_driver);
+	return pci_register_driver(&ipr_driver);
 }
 
 /**
diff -puN drivers/scsi/nsp32.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/nsp32.c
@@ -3581,7 +3581,7 @@ static struct pci_driver nsp32_driver = 
  */
 static int __init init_nsp32(void) {
 	nsp32_msg(KERN_INFO, "loading...");
-	return pci_module_init(&nsp32_driver);
+	return pci_register_driver(&nsp32_driver);
 }
 
 static void __exit exit_nsp32(void) {
diff -puN drivers/scsi/qla1280.c~pci_module_init-conversion-in-scsi-subsys-2nd-try drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~pci_module_init-conversion-in-scsi-subsys-2nd-try
+++ a/drivers/scsi/qla1280.c
@@ -4484,7 +4484,7 @@ qla1280_init(void)
 		qla1280_setup(qla1280);
 #endif
 
-	return pci_module_init(&qla1280_pci_driver);
+	return pci_register_driver(&qla1280_pci_driver);
 }
 
 static void __exit
_
