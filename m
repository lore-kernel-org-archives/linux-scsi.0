From: akpm@osdl.org
Subject: [patch 1/1] aic7xxx: fix oops whe hardware is not present
Date: Mon, 12 Apr 2004 22:30:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404130531.i3D5VB220213@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:45752 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263325AbUDMFbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 01:31:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, herbert@gondor.apana.org.au


From: Herbert Xu <herbert@gondor.apana.org.au>

This is because aic7xxx does not unregister itself properly if no devices
are found.  This patch fixes the problem.


---

 25-akpm/drivers/scsi/aic7xxx/aic7770_osm.c |   25 ++++++++++++-------------
 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c |   23 +++++++++++++++++++----
 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.h |    2 +-
 3 files changed, 32 insertions(+), 18 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7770_osm.c~aic7xxx-unload-fix drivers/scsi/aic7xxx/aic7770_osm.c
--- 25/drivers/scsi/aic7xxx/aic7770_osm.c~aic7xxx-unload-fix	2004-04-06 21:09:31.106206568 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic7770_osm.c	2004-04-06 21:09:31.114205352 -0700
@@ -73,7 +73,7 @@ typedef void *aic7770_dev_t;
 static int aic7770_linux_config(struct aic7770_identity *entry,
 				aic7770_dev_t dev, u_int eisaBase);
 
-void
+int
 ahc_linux_eisa_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -82,7 +82,7 @@ ahc_linux_eisa_init(void)
 	int i;
 
 	if (aic7xxx_probe_eisa_vl == 0)
-		return;
+		return -ENODEV;
 
 	/*
 	 * Linux requires the EISA IDs to be specified in
@@ -93,7 +93,7 @@ ahc_linux_eisa_init(void)
 					 (ahc_num_aic7770_devs + 1),
 					 M_DEVBUF, M_NOWAIT);
 	if (aic7770_driver.id_table == NULL)
-		return;
+		return -ENOMEM;
 
 	for (eid = (struct eisa_device_id *)aic7770_driver.id_table,
 	     id = aic7770_ident_table, i = 0;
@@ -109,15 +109,16 @@ ahc_linux_eisa_init(void)
 	}
 	eid->sig[0] = 0;
 
-	eisa_driver_register(&aic7770_driver);
+	return eisa_driver_register(&aic7770_driver);
 #else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0) */
 	struct aic7770_identity *entry;
 	u_int  slot;
 	u_int  eisaBase;
 	u_int  i;
+	int ret = -ENODEV;
 
 	if (aic7xxx_probe_eisa_vl == 0)
-		return;
+		return ret;
 
 	eisaBase = 0x1000 + AHC_EISA_SLOT_OFFSET;
 	for (slot = 1; slot < NUMSLOTS; eisaBase+=0x1000, slot++) {
@@ -146,9 +147,12 @@ ahc_linux_eisa_init(void)
 			continue;  /* no EISA card in slot */
 
 		entry = aic7770_find_device(eisa_id);
-		if (entry != NULL)
+		if (entry != NULL) {
 			aic7770_linux_config(entry, NULL, eisaBase);
+			ret = 0;
+		}
 	}
+	return ret;
 #endif
 }
 
@@ -156,13 +160,8 @@ void
 ahc_linux_eisa_exit(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	if (aic7xxx_probe_eisa_vl == 0)
-		return;
-
-	if (aic7770_driver.id_table != NULL) {
-		eisa_driver_unregister(&aic7770_driver);
-		free(aic7770_driver.id_table, M_DEVBUF);
-	}
+	eisa_driver_unregister(&aic7770_driver);
+	free(aic7770_driver.id_table, M_DEVBUF);
 #endif
 }
 
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-unload-fix drivers/scsi/aic7xxx/aic7xxx_osm.c
--- 25/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-unload-fix	2004-04-06 21:09:31.108206264 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-04-06 21:09:31.118204744 -0700
@@ -892,18 +892,25 @@ ahc_linux_detect(Scsi_Host_Template *tem
 	ahc_list_lockinit();
 
 #ifdef CONFIG_PCI
-	ahc_linux_pci_init();
+	found = ahc_linux_pci_init();
+	if (found)
+		goto out;
 #endif
 
 #ifdef CONFIG_EISA
-	ahc_linux_eisa_init();
+	found = ahc_linux_eisa_init();
+	if (found) {
+#ifdef CONFIG_PCI
+		ahc_linux_pci_exit();
+#endif
+		goto out;
+	}
 #endif
 
 	/*
 	 * Register with the SCSI layer all
 	 * controllers we've found.
 	 */
-	found = 0;
 	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
 
 		if (ahc_linux_register_host(ahc, template) == 0)
@@ -913,6 +920,8 @@ ahc_linux_detect(Scsi_Host_Template *tem
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic7xxx_detect_complete++;
+
+out:
 	return (found);
 }
 
@@ -5073,11 +5082,17 @@ ahc_platform_dump_card_state(struct ahc_
 	}
 }
 
+static void __exit ahc_linux_exit(void);
+
 static int __init
 ahc_linux_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	return (ahc_linux_detect(&aic7xxx_driver_template) ? 0 : -ENODEV);
+	int rc = ahc_linux_detect(&aic7xxx_driver_template);
+	if (rc)
+		return rc;
+	ahc_linux_exit();
+	return -ENODEV;
 #else
 	scsi_register_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
 	if (aic7xxx_driver_template.present == 0) {
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~aic7xxx-unload-fix drivers/scsi/aic7xxx/aic7xxx_osm.h
--- 25/drivers/scsi/aic7xxx/aic7xxx_osm.h~aic7xxx-unload-fix	2004-04-06 21:09:31.110205960 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-04-06 21:09:31.119204592 -0700
@@ -840,7 +840,7 @@ typedef enum
 
 #ifdef CONFIG_EISA
 extern uint32_t aic7xxx_probe_eisa_vl;
-void			 ahc_linux_eisa_init(void);
+int			 ahc_linux_eisa_init(void);
 void			 ahc_linux_eisa_exit(void);
 int			 aic7770_map_registers(struct ahc_softc *ahc,
 					       u_int port);

_
