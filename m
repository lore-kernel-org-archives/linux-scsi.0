From: akpm@osdl.org
Subject: [patch 3/3] aic7...: Fix bad __exit reference
Date: Mon, 26 Apr 2004 22:01:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404270501.i3R51h207741@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59817 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263596AbUD0FBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 01:01:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org, akpm@osdl.org, herbert@gondor.apana.org.au


From: Herbert Xu <herbert@gondor.apana.org.au>

>
> Error: ./drivers/scsi/aic7xxx/aic7xxx_osm.o .init.text refers to
> 0000000000000040 ELF_LITERAL       .exit.text
> Error: ./drivers/scsi/aic7xxx/aic7xxx_osm.o .init.text refers to
> 0000000000000044 HINT              .exit.text
> Error: ./drivers/scsi/aic7xxx/aic7xxx_osm.o .eh_frame refers to
> 0000000000000941 SREL32            .exit.text

That was my fault.  This patch should fix it.


---

 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c |   31 +++++++++++------------------
 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.h |    6 +++++
 2 files changed, 18 insertions(+), 19 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-section-fix drivers/scsi/aic7xxx/aic7xxx_osm.c
--- 25/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-section-fix	2004-04-25 23:09:39.707045720 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-04-25 23:09:39.715044504 -0700
@@ -891,21 +891,14 @@ ahc_linux_detect(Scsi_Host_Template *tem
 	 */
 	ahc_list_lockinit();
 
-#ifdef CONFIG_PCI
 	found = ahc_linux_pci_init();
 	if (found)
-		goto out;
-#endif
+		goto pci_err;
 
-#ifdef CONFIG_EISA
 	found = ahc_linux_eisa_init();
 	if (found) {
-#ifdef CONFIG_PCI
-		ahc_linux_pci_exit();
-#endif
-		goto out;
+		goto eisa_err;
 	}
-#endif
 
 	/*
 	 * Register with the SCSI layer all
@@ -921,7 +914,15 @@ ahc_linux_detect(Scsi_Host_Template *tem
 #endif
 	aic7xxx_detect_complete++;
 
-out:
+	if (!found) {
+		found = -ENODEV;
+
+		ahc_linux_eisa_exit();
+eisa_err:
+		ahc_linux_pci_exit();
+	}
+
+pci_err:
 	return (found);
 }
 
@@ -5091,11 +5092,7 @@ static int __init
 ahc_linux_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	int rc = ahc_linux_detect(&aic7xxx_driver_template);
-	if (rc)
-		return rc;
-	ahc_linux_exit();
-	return -ENODEV;
+	return ahc_linux_detect(&aic7xxx_driver_template);
 #else
 	scsi_register_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
 	if (aic7xxx_driver_template.present == 0) {
@@ -5135,12 +5132,8 @@ ahc_linux_exit(void)
 	 */
 	scsi_unregister_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
 #endif
-#ifdef CONFIG_PCI
 	ahc_linux_pci_exit();
-#endif
-#ifdef CONFIG_EISA
 	ahc_linux_eisa_exit();
-#endif
 }
 
 module_init(ahc_linux_init);
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~aic7xxx-section-fix drivers/scsi/aic7xxx/aic7xxx_osm.h
--- 25/drivers/scsi/aic7xxx/aic7xxx_osm.h~aic7xxx-section-fix	2004-04-25 23:09:39.708045568 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-04-25 23:09:39.716044352 -0700
@@ -845,6 +845,9 @@ void			 ahc_linux_eisa_exit(void);
 int			 aic7770_map_registers(struct ahc_softc *ahc,
 					       u_int port);
 int			 aic7770_map_int(struct ahc_softc *ahc, u_int irq);
+#else
+static __inline int ahc_linux_eisa_init(void) { return 0; }
+static __inline void ahc_linux_eisa_exit(void) {}
 #endif
 
 /******************************* PCI Routines *********************************/
@@ -960,6 +963,9 @@ ahc_flush_device_writes(struct ahc_softc
  */
 #define ahc_pci_set_dma_mask(dev_softc, mask)  			\
 	(((dev_softc)->dma_mask = mask) && 0)
+
+static __inline int ahc_linux_pci_init(void) { return 0; }
+static __inline void ahc_linux_pci_exit(void) {}
 #endif
 /**************************** Proc FS Support *********************************/
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)

_
