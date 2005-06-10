From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: clean up eisa support
Date: Sat, 11 Jun 2005 00:17:03 +0200
Message-ID: <20050610221703.GD8706@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60339 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261287AbVFJWRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 18:17:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - the eisa layer only probes when it's actually safe, no need for
   a driver option
 - store the id table directly in linux format instead of convering
   at runtime


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-11 00:02:50.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-11 00:03:21.000000000 +0200
@@ -330,22 +330,6 @@
 static uint32_t aic7xxx_pci_parity = ~0;
 
 /*
- * Certain newer motherboards have put new PCI based devices into the
- * IO spaces that used to typically be occupied by VLB or EISA cards.
- * This overlap can cause these newer motherboards to lock up when scanned
- * for older EISA and VLB devices.  Setting this option to non-0 will
- * cause the driver to skip scanning for any VLB or EISA controllers and
- * only support the PCI controllers.  NOTE: this means that if the kernel
- * os compiled with PCI support disabled, then setting this to non-0
- * would result in never finding any devices :)
- */
-#ifndef CONFIG_AIC7XXX_PROBE_EISA_VL
-uint32_t aic7xxx_probe_eisa_vl;
-#else
-uint32_t aic7xxx_probe_eisa_vl = ~0;
-#endif
-
-/*
  * There are lots of broken chipsets in the world.  Some of them will
  * violate the PCI spec when we issue byte sized memory writes to our
  * controller.  I/O mapped register access, if allowed by the given
@@ -1101,8 +1085,6 @@
 		{ "debug", &ahc_debug },
 #endif
 		{ "reverse_scan", &aic7xxx_reverse_scan },
-		{ "no_probe", &aic7xxx_probe_eisa_vl },
-		{ "probe_eisa_vl", &aic7xxx_probe_eisa_vl },
 		{ "periodic_otag", &aic7xxx_periodic_otag },
 		{ "pci_parity", &aic7xxx_pci_parity },
 		{ "seltime", &aic7xxx_seltime },
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-11 00:02:50.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-11 00:03:21.000000000 +0200
@@ -622,7 +622,6 @@
 
 /**************************** VL/EISA Routines ********************************/
 #ifdef CONFIG_EISA
-extern uint32_t aic7xxx_probe_eisa_vl;
 int			 ahc_linux_eisa_init(void);
 void			 ahc_linux_eisa_exit(void);
 int			 aic7770_map_registers(struct ahc_softc *ahc,
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7770_osm.c	2005-06-11 00:02:50.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770_osm.c	2005-06-11 00:11:49.000000000 +0200
@@ -44,109 +44,6 @@
 #include <linux/device.h>
 #include <linux/eisa.h>
 
-#define EISA_MFCTR_CHAR0(ID) (char)(((ID>>26) & 0x1F) | '@')  /* Bits 26-30 */
-#define EISA_MFCTR_CHAR1(ID) (char)(((ID>>21) & 0x1F) | '@')  /* Bits 21-25 */
-#define EISA_MFCTR_CHAR2(ID) (char)(((ID>>16) & 0x1F) | '@')  /* Bits 16-20 */
-#define EISA_PRODUCT_ID(ID)  (short)((ID>>4)  & 0xFFF)        /* Bits  4-15 */
-#define EISA_REVISION_ID(ID) (uint8_t)(ID & 0x0F)             /* Bits  0-3  */
-
-static int aic7770_eisa_dev_probe(struct device *dev);
-static int aic7770_eisa_dev_remove(struct device *dev);
-static struct eisa_driver aic7770_driver = {
-	.driver = {
-		.name   = "aic7xxx",
-		.probe  = aic7770_eisa_dev_probe,
-		.remove = aic7770_eisa_dev_remove,
-	}
-};
-
-typedef  struct device *aic7770_dev_t;
-
-static int aic7770_linux_config(struct aic7770_identity *entry,
-				aic7770_dev_t dev, u_int eisaBase);
-
-int
-ahc_linux_eisa_init(void)
-{
-	struct eisa_device_id *eid;
-	struct aic7770_identity *id;
-	int i;
-
-	if (aic7xxx_probe_eisa_vl == 0)
-		return -ENODEV;
-
-	/*
-	 * Linux requires the EISA IDs to be specified in
-	 * the EISA ID string format.  Perform the conversion
-	 * and setup a table with a NUL terminal entry.
-	 */
-	aic7770_driver.id_table = malloc(sizeof(struct eisa_device_id) *
-					 (ahc_num_aic7770_devs + 1),
-					 M_DEVBUF, M_NOWAIT);
-	if (aic7770_driver.id_table == NULL)
-		return -ENOMEM;
-
-	for (eid = (struct eisa_device_id *)aic7770_driver.id_table,
-	     id = aic7770_ident_table, i = 0;
-	     i < ahc_num_aic7770_devs; eid++, id++, i++) {
-
-		sprintf(eid->sig, "%c%c%c%03X%01X",
-			EISA_MFCTR_CHAR0(id->full_id),
-			EISA_MFCTR_CHAR1(id->full_id),
-			EISA_MFCTR_CHAR2(id->full_id),
-			EISA_PRODUCT_ID(id->full_id),
-			EISA_REVISION_ID(id->full_id));
-		eid->driver_data = i;
-	}
-	eid->sig[0] = 0;
-
-	return eisa_driver_register(&aic7770_driver);
-}
-
-void
-ahc_linux_eisa_exit(void)
-{
-	if(aic7xxx_probe_eisa_vl != 0 && aic7770_driver.id_table != NULL) {
-		eisa_driver_unregister(&aic7770_driver);
-		free(aic7770_driver.id_table, M_DEVBUF);
-	}
-}
-
-static int
-aic7770_linux_config(struct aic7770_identity *entry, aic7770_dev_t dev,
-		     u_int eisaBase)
-{
-	struct	ahc_softc *ahc;
-	char	buf[80];
-	char   *name;
-	int	error;
-
-	/*
-	 * Allocate a softc for this card and
-	 * set it up for attachment by our
-	 * common detect routine.
-	 */
-	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
-	name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
-	if (name == NULL)
-		return (ENOMEM);
-	strcpy(name, buf);
-	ahc = ahc_alloc(&aic7xxx_driver_template, name);
-	if (ahc == NULL)
-		return (ENOMEM);
-	error = aic7770_config(ahc, entry, eisaBase);
-	if (error != 0) {
-		ahc->bsh.ioport = 0;
-		ahc_free(ahc);
-		return (error);
-	}
-
-	dev->driver_data = (void *)ahc;
-	if (aic7xxx_detect_complete)
-		error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
-	return (error);
-}
-
 int
 aic7770_map_registers(struct ahc_softc *ahc, u_int port)
 {
@@ -178,25 +75,79 @@
 }
 
 static int
-aic7770_eisa_dev_probe(struct device *dev)
+aic7770_probe(struct device *dev)
 {
-	struct eisa_device *edev;
+	struct eisa_device *edev = to_eisa_device(dev);
+	u_int eisaBase = edev->base_addr+AHC_EISA_SLOT_OFFSET;
+	struct	ahc_softc *ahc;
+	char	buf[80];
+	char   *name;
+	int	error;
 
-	edev = to_eisa_device(dev);
-	return (aic7770_linux_config(aic7770_ident_table + edev->id.driver_data,
-				    dev, edev->base_addr+AHC_EISA_SLOT_OFFSET));
+	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
+	name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
+	if (name == NULL)
+		return (ENOMEM);
+	strcpy(name, buf);
+	ahc = ahc_alloc(&aic7xxx_driver_template, name);
+	if (ahc == NULL)
+		return (ENOMEM);
+	error = aic7770_config(ahc, aic7770_ident_table + edev->id.driver_data,
+			       eisaBase);
+	if (error != 0) {
+		ahc->bsh.ioport = 0;
+		ahc_free(ahc);
+		return (error);
+	}
+
+ 	dev_set_drvdata(dev, ahc);
+
+	if (aic7xxx_detect_complete)
+		error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
+	return (error);
 }
 
 static int
-aic7770_eisa_dev_remove(struct device *dev)
+aic7770_remove(struct device *dev)
 {
-	struct ahc_softc *ahc = dev_get_drvata(dev);
+	struct ahc_softc *ahc = dev_get_drvdata(dev);
 	u_long s;
 
 	ahc_lock(ahc, &s);
 	ahc_intr_enable(ahc, FALSE);
 	ahc_unlock(ahc, &s);
-	ahc_free(ahc);
 
-	return (0);
+	ahc_free(ahc);
+	return 0;
+}
+ 
+static struct eisa_device_id aic7770_ids[] = {
+	{ "ADP7771", 0 }, /* AHA 274x */
+	{ "ADP7756", 1 }, /* AHA 284x BIOS enabled */
+	{ "ADP7757", 2 }, /* AHA 284x BIOS disabled */
+	{ "ADP7782", 3 }, /* AHA 274x Olivetti OEM */
+	{ "ADP7783", 4 }, /* AHA 274x Olivetti OEM (Differential) */
+	{ "ADP7770", 5 }, /* AIC7770 generic */
+	{ "" }
+};
+  
+static struct eisa_driver aic7770_driver = {
+	.id_table	= aic7770_ids,
+	.driver = {
+		.name   = "aic7xxx",
+		.probe  = aic7770_probe,
+		.remove = aic7770_remove,
+	}
+};
+  
+int
+ahc_linux_eisa_init(void)
+{
+	return eisa_driver_register(&aic7770_driver);
+}
+  
+void
+ahc_linux_eisa_exit(void)
+{
+	eisa_driver_unregister(&aic7770_driver);
 }
