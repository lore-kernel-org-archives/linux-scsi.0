From: Arjan van de Ven <arjanv@redhat.com>
Subject: [patch] aic79xx hostraid support
Date: Sat, 21 Aug 2004 15:32:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040821133214.GA28890@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:24523 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265264AbUHUNcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 09:32:15 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.10/8.12.10) with ESMTP id i7LDWFe1012092
	for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2004 09:32:15 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id i7LDWFa16802
	for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2004 09:32:15 -0400
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.10) with ESMTP id i7LDWEca030995
	for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2004 09:32:14 -0400
Received: (from arjanv@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id i7LDWE92030993
	for linux-scsi@vger.kernel.org; Sat, 21 Aug 2004 15:32:14 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Below is a patch ported to 2.6.8 by John A. Hull (john_hull@dell.com) to add
support for the aic79xx hostraid family support. Please consider.

Greetings,
    Arjan van de Ven

diff -purN linux-2.6.8/drivers/scsi/aic7xxx/aic79xx.h linux/drivers/scsi/aic7xxx/aic79xx.h
--- linux-2.6.8/drivers/scsi/aic7xxx/aic79xx.h	2004-08-14 07:37:25.000000000 +0200
+++ linux/drivers/scsi/aic7xxx/aic79xx.h	2004-08-21 15:29:58.977305228 +0200
@@ -375,7 +375,8 @@ typedef enum {
 	AHD_RESET_POLL_ACTIVE = 0x200000,
 	AHD_UPDATE_PEND_CMDS  = 0x400000,
 	AHD_RUNNING_QOUTFIFO  = 0x800000,
-	AHD_HAD_FIRST_SEL     = 0x1000000
+	AHD_HAD_FIRST_SEL     = 0x1000000,
+ 	AHD_HOSTRAID_BOARD    = 0x2000000
 } ahd_flag;
 
 /************************* Hardware  SCB Definition ***************************/
diff -purN linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_osm_pci.c linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-08-14 07:36:33.000000000 +0200
+++ linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-08-21 15:27:18.902556250 +0200
@@ -64,6 +64,10 @@ static struct pci_device_id ahd_linux_pc
 		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
 	},
+	{
+		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_RAID << 8, 0xFFFF00, 0
+	},
 	{ 0 }
 };
 
diff -purN linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_pci.c linux/drivers/scsi/aic7xxx/aic79xx_pci.c
--- linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-08-14 07:36:57.000000000 +0200
+++ linux/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-08-21 15:27:18.903556130 +0200
@@ -65,10 +65,10 @@ ahd_compose_id(u_int device, u_int vendo
 }
 
 #define ID_ALL_MASK			0xFFFFFFFFFFFFFFFFull
-#define ID_ALL_IROC_MASK		0xFFFFFF7FFFFFFFFFull
+#define ID_ALL_IROC_MASK		0xFF7FFFFFFFFFFFFFull
 #define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
 #define ID_9005_GENERIC_MASK		0xFFF0FFFF00000000ull
-#define ID_9005_GENERIC_IROC_MASK	0xFFF0FF7F00000000ull
+#define ID_9005_GENERIC_IROC_MASK	0xFF70FFFF00000000ull
 
 #define ID_AIC7901			0x800F9005FFFF9005ull
 #define ID_AHA_29320A			0x8000900500609005ull
@@ -92,6 +92,8 @@ ahd_compose_id(u_int device, u_int vendo
 #define ID_AIC7902_PCI_REV_B0		0x10
 #define SUBID_HP			0x0E11
 
+#define DEVID_9005_HOSTRAID(id) ((id) & 0x80)
+
 #define DEVID_9005_TYPE(id) ((id) & 0xF)
 #define		DEVID_9005_TYPE_HBA		0x0	/* Standard Card */
 #define		DEVID_9005_TYPE_HBA_2EXT	0x1	/* 2 External Ports */
@@ -134,18 +136,18 @@ struct ahd_pci_identity ahd_pci_ident_ta
 		"Adaptec 29320ALP Ultra320 SCSI adapter",
 		ahd_aic7901_setup
 	},
-	/* aic7901A based controllers */
+	/* aic7902 based controllers */	
 	{
 		ID_AHA_29320,
 		ID_ALL_MASK,
 		"Adaptec 29320 Ultra320 SCSI adapter",
-		ahd_aic7901A_setup
+		ahd_aic7902_setup
 	},
 	{
 		ID_AHA_29320B,
 		ID_ALL_MASK,
 		"Adaptec 29320B Ultra320 SCSI adapter",
-		ahd_aic7901A_setup
+		ahd_aic7902_setup
 	},
 	{
 		ID_AHA_29320LP,
@@ -153,7 +155,6 @@ struct ahd_pci_identity ahd_pci_ident_ta
 		"Adaptec 29320LP Ultra320 SCSI adapter",
 		ahd_aic7901A_setup
 	},
-	/* aic7902 based controllers */	
 	{
 		ID_AHA_39320,
 		ID_ALL_MASK,
@@ -196,22 +197,10 @@ struct ahd_pci_identity ahd_pci_ident_ta
 		"Adaptec (HP OEM) 39320D Ultra320 SCSI adapter",
 		ahd_aic7902_setup
 	},
-	{
-		ID_AHA_29320,
-		ID_ALL_MASK,
-		"Adaptec 29320 Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_29320B,
-		ID_ALL_MASK,
-		"Adaptec 29320B Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
 	/* Generic chip probes for devices we don't know 'exactly' */
 	{
-		ID_AIC7901 & ID_DEV_VENDOR_MASK,
-		ID_DEV_VENDOR_MASK,
+		ID_AIC7901 & ID_9005_GENERIC_MASK,
+		ID_9005_GENERIC_MASK,
 		"Adaptec AIC7901 Ultra320 SCSI adapter",
 		ahd_aic7901_setup
 	},
@@ -294,6 +283,12 @@ ahd_find_pci_device(ahd_dev_softc_t pci)
 				 subdevice,
 				 subvendor);
 
+	/*
+	 * Controllers, mask out the IROC/HostRAID bit
+	 */
+	
+	full_id &= ID_ALL_IROC_MASK;
+
 	for (i = 0; i < ahd_num_pci_devs; i++) {
 		entry = &ahd_pci_ident_table[i];
 		if (entry->full_id == (full_id & entry->id_mask)) {
@@ -313,12 +308,21 @@ ahd_pci_config(struct ahd_softc *ahd, st
 	u_long		 l;
 	u_int		 command;
 	uint32_t	 devconfig;
+	uint16_t	 device; 
 	uint16_t	 subvendor; 
 	int		 error;
 
 	shared_scb_data = NULL;
 	ahd->description = entry->name;
 	/*
+	 * Record if this is a HostRAID board.
+	 */
+	device = ahd_pci_read_config(ahd->dev_softc,
+				     PCIR_DEVICE, /*bytes*/2);
+	if (DEVID_9005_HOSTRAID(device))
+		ahd->flags |= AHD_HOSTRAID_BOARD;
+
+	/*
 	 * Record if this is an HP board.
 	 */
 	subvendor = ahd_pci_read_config(ahd->dev_softc,
