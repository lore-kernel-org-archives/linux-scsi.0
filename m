From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH][RFC] rework aic79xx pci probing
Date: Sun, 12 Sep 2004 18:14:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040912161420.GA4424@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:17329 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268365AbUILQOZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2004 12:14:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Add a fully populated pci_device_id table as primary probing instrument.
It contains the PCI IDs in all detail and sets the chiptype in the
driver_data field.  By also always using the generic chip identifcation
string instead of the exact branding this allows to get rid of all the
matching in aic7xxx_pci.c.  While there is lots of code removed from
that common file I took great care to not introduce Linuxisms, FreeBSD
can be easily adapted to these changes by doing the work in their
OS-specific module.

I'd love to see someone from Adaptec double-check the PCI ID table, the
one in aic79xx_pci.c was inconsistant (the generic entires were
overlapping).


--- 1.13/drivers/scsi/aic7xxx/aic79xx.h	2003-12-30 19:12:34 +01:00
+++ edited/drivers/scsi/aic7xxx/aic79xx.h	2004-09-12 19:25:07 +02:00
@@ -1341,9 +1341,7 @@
 }
 
 /***************************** PCI Front End *********************************/
-struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
-int			  ahd_pci_config(struct ahd_softc *,
-					 struct ahd_pci_identity *);
+int			  ahd_pci_config(struct ahd_softc *);
 int	ahd_pci_test_register_access(struct ahd_softc *);
 
 /************************** SCB and SCB queue management **********************/
===== drivers/scsi/aic7xxx/aic79xx_osm_pci.c 1.12 vs edited =====
--- 1.12/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-08-21 15:27:19 +02:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-09-12 19:50:34 +02:00
@@ -58,17 +58,43 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
 
-/* We do our own ID filtering.  So, grab all SCSI storage class devices. */
 static struct pci_device_id ahd_linux_pci_id_table[] = {
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
-	},
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xFFFF00, 0
-	},
-	{ 0 }
+	/* aic7901 based controllers */
+	{ 0x9005, 0x8000, 0x9005, 0x0060, 0, 0, AHD_AIC7901 },	/* 29320A */
+	{ 0x9005, 0x8017, 0x9005, 0x0044, 0, 0, AHD_AIC7901 },	/* 29320ALP */
+
+	/* aic7902 based controllers */
+	{ 0x9005, 0x8012, 0x9005, 0x0042, 0, 0, AHD_AIC7902 },	/* 29320 */
+	{ 0x9005, 0x8013, 0x9005, 0x0043, 0, 0, AHD_AIC7902 },	/* 29320B */
+	{ 0x9005, 0x8014, 0x9005, 0x0044, 0, 0, AHD_AIC7902 },	/* 29320LP */
+	{ 0x9005, 0x8010, 0x9005, 0x0040, 0, 0, AHD_AIC7902 },	/* 39320 */
+	{ 0x9005, 0x8015, 0x9005, 0x0040, 0, 0, AHD_AIC7902 },	/* 39320_B */
+	{ 0x9005, 0x8016, 0x9005, 0x0040, 0, 0, AHD_AIC7902 },	/* 39320A */
+	{ 0x9005, 0x8011, 0x9005, 0x0041, 0, 0, AHD_AIC7902 },	/* 39320D */
+	{ 0x9005, 0x801c, 0x9005, 0x0041, 0, 0, AHD_AIC7902 },	/* 39320D_B */
+	{ 0x0e11, 0x8011, 0x9005, 0x00ac, 0, 0, AHD_AIC7902 },	/* 39320D_HP */
+	{ 0x0e11, 0x801c, 0x9005, 0x00ac, 0, 0, AHD_AIC7902 },	/* 39320D_B_HP */
+
+	/* generic chip probes for devices we don't know 'exactly' */
+	{ 0x9005, 0x800f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7901 },
+	{ 0x9005, 0x801e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7901A },
+	{ 0x9005, 0x8010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8011, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8012, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8013, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8014, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8015, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8016, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8017, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8018, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x8019, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x801a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x801b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x801c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x801d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+	{ 0x9005, 0x801f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AHD_AIC7902 },
+
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
@@ -111,7 +137,6 @@
 	char		 buf[80];
 	struct		 ahd_softc *ahd;
 	ahd_dev_softc_t	 pci;
-	struct		 ahd_pci_identity *entry;
 	char		*name;
 	int		 error;
 
@@ -132,9 +157,6 @@
 	}
 
 	pci = pdev;
-	entry = ahd_find_pci_device(pci);
-	if (entry == NULL)
-		return (-ENODEV);
 
 	/*
 	 * Allocate a softc for this card and
@@ -182,7 +204,8 @@
 	}
 #endif
 	ahd->dev_softc = pci;
-	error = ahd_pci_config(ahd, entry);
+	ahd->chip = ent->driver_data;
+	error = ahd_pci_config(ahd);
 	if (error != 0) {
 		ahd_free(ahd);
 		return (-error);
===== drivers/scsi/aic7xxx/aic79xx_pci.c 1.15 vs edited =====
--- 1.15/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-08-21 15:27:19 +02:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-09-12 19:33:49 +02:00
@@ -51,175 +51,12 @@
 #include <dev/aic7xxx/aic79xx_inline.h>
 #endif
 
-static __inline uint64_t
-ahd_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
-{
-	uint64_t id;
-
-	id = subvendor
-	   | (subdevice << 16)
-	   | ((uint64_t)vendor << 32)
-	   | ((uint64_t)device << 48);
-
-	return (id);
-}
-
-#define ID_ALL_MASK			0xFFFFFFFFFFFFFFFFull
-#define ID_ALL_IROC_MASK		0xFF7FFFFFFFFFFFFFull
-#define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
-#define ID_9005_GENERIC_MASK		0xFFF0FFFF00000000ull
-#define ID_9005_GENERIC_IROC_MASK	0xFF70FFFF00000000ull
-
-#define ID_AIC7901			0x800F9005FFFF9005ull
-#define ID_AHA_29320A			0x8000900500609005ull
-#define ID_AHA_29320ALP			0x8017900500449005ull
-
-#define ID_AIC7901A			0x801E9005FFFF9005ull
-#define ID_AHA_29320			0x8012900500429005ull
-#define ID_AHA_29320B			0x8013900500439005ull
-#define ID_AHA_29320LP			0x8014900500449005ull
-
-#define ID_AIC7902			0x801F9005FFFF9005ull
-#define ID_AIC7902_B			0x801D9005FFFF9005ull
-#define ID_AHA_39320			0x8010900500409005ull
-#define ID_AHA_39320_B			0x8015900500409005ull
-#define ID_AHA_39320A			0x8016900500409005ull
-#define ID_AHA_39320D			0x8011900500419005ull
-#define ID_AHA_39320D_B			0x801C900500419005ull
-#define ID_AHA_39320D_HP		0x8011900500AC0E11ull
-#define ID_AHA_39320D_B_HP		0x801C900500AC0E11ull
 #define ID_AIC7902_PCI_REV_A4		0x3
 #define ID_AIC7902_PCI_REV_B0		0x10
 #define SUBID_HP			0x0E11
 
-#define DEVID_9005_HOSTRAID(id) ((id) & 0x80)
-
-#define DEVID_9005_TYPE(id) ((id) & 0xF)
-#define		DEVID_9005_TYPE_HBA		0x0	/* Standard Card */
-#define		DEVID_9005_TYPE_HBA_2EXT	0x1	/* 2 External Ports */
-#define		DEVID_9005_TYPE_IROC		0x8	/* Raid(0,1,10) Card */
-#define		DEVID_9005_TYPE_MB		0xF	/* On Motherboard */
-
-#define DEVID_9005_MFUNC(id) ((id) & 0x10)
-
-#define DEVID_9005_PACKETIZED(id) ((id) & 0x8000)
-
-#define SUBID_9005_TYPE(id) ((id) & 0xF)
-#define		SUBID_9005_TYPE_HBA		0x0	/* Standard Card */
-#define		SUBID_9005_TYPE_MB		0xF	/* On Motherboard */
-
-#define SUBID_9005_AUTOTERM(id)	(((id) & 0x10) == 0)
-
-#define SUBID_9005_LEGACYCONN_FUNC(id) ((id) & 0x20)
-
-#define SUBID_9005_SEEPTYPE(id) ((id) & 0x0C0) >> 6)
-#define		SUBID_9005_SEEPTYPE_NONE	0x0
-#define		SUBID_9005_SEEPTYPE_4K		0x1
-
-static ahd_device_setup_t ahd_aic7901_setup;
-static ahd_device_setup_t ahd_aic7901A_setup;
-static ahd_device_setup_t ahd_aic7902_setup;
 static ahd_device_setup_t ahd_aic790X_setup;
 
-struct ahd_pci_identity ahd_pci_ident_table [] =
-{
-	/* aic7901 based controllers */
-	{
-		ID_AHA_29320A,
-		ID_ALL_MASK,
-		"Adaptec 29320A Ultra320 SCSI adapter",
-		ahd_aic7901_setup
-	},
-	{
-		ID_AHA_29320ALP,
-		ID_ALL_MASK,
-		"Adaptec 29320ALP Ultra320 SCSI adapter",
-		ahd_aic7901_setup
-	},
-	/* aic7902 based controllers */	
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
-	{
-		ID_AHA_29320LP,
-		ID_ALL_MASK,
-		"Adaptec 29320LP Ultra320 SCSI adapter",
-		ahd_aic7901A_setup
-	},
-	{
-		ID_AHA_39320,
-		ID_ALL_MASK,
-		"Adaptec 39320 Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_39320_B,
-		ID_ALL_MASK,
-		"Adaptec 39320 Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_39320A,
-		ID_ALL_MASK,
-		"Adaptec 39320A Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_39320D,
-		ID_ALL_MASK,
-		"Adaptec 39320D Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_39320D_HP,
-		ID_ALL_MASK,
-		"Adaptec (HP OEM) 39320D Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_39320D_B,
-		ID_ALL_MASK,
-		"Adaptec 39320D Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	{
-		ID_AHA_39320D_B_HP,
-		ID_ALL_MASK,
-		"Adaptec (HP OEM) 39320D Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	},
-	/* Generic chip probes for devices we don't know 'exactly' */
-	{
-		ID_AIC7901 & ID_9005_GENERIC_MASK,
-		ID_9005_GENERIC_MASK,
-		"Adaptec AIC7901 Ultra320 SCSI adapter",
-		ahd_aic7901_setup
-	},
-	{
-		ID_AIC7901A & ID_DEV_VENDOR_MASK,
-		ID_DEV_VENDOR_MASK,
-		"Adaptec AIC7901A Ultra320 SCSI adapter",
-		ahd_aic7901A_setup
-	},
-	{
-		ID_AIC7902 & ID_9005_GENERIC_MASK,
-		ID_9005_GENERIC_MASK,
-		"Adaptec AIC7902 Ultra320 SCSI adapter",
-		ahd_aic7902_setup
-	}
-};
-
-const u_int ahd_num_pci_devs = NUM_ELEMENTS(ahd_pci_ident_table);
-		
 #define	DEVCONFIG		0x40
 #define		PCIXINITPAT	0x0000E000ul
 #define			PCIXINIT_PCI33_66	0x0000E000ul
@@ -263,46 +100,8 @@
 					  u_int adapter_control);
 static void	ahd_pci_split_intr(struct ahd_softc *ahd, u_int intstat);
 
-struct ahd_pci_identity *
-ahd_find_pci_device(ahd_dev_softc_t pci)
-{
-	uint64_t  full_id;
-	uint16_t  device;
-	uint16_t  vendor;
-	uint16_t  subdevice;
-	uint16_t  subvendor;
-	struct	  ahd_pci_identity *entry;
-	u_int	  i;
-
-	vendor = ahd_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
-	device = ahd_pci_read_config(pci, PCIR_DEVICE, /*bytes*/2);
-	subvendor = ahd_pci_read_config(pci, PCIR_SUBVEND_0, /*bytes*/2);
-	subdevice = ahd_pci_read_config(pci, PCIR_SUBDEV_0, /*bytes*/2);
-	full_id = ahd_compose_id(device,
-				 vendor,
-				 subdevice,
-				 subvendor);
-
-	/*
-	 * Controllers, mask out the IROC/HostRAID bit
-	 */
-	
-	full_id &= ID_ALL_IROC_MASK;
-
-	for (i = 0; i < ahd_num_pci_devs; i++) {
-		entry = &ahd_pci_ident_table[i];
-		if (entry->full_id == (full_id & entry->id_mask)) {
-			/* Honor exclusion entries. */
-			if (entry->name == NULL)
-				return (NULL);
-			return (entry);
-		}
-	}
-	return (NULL);
-}
-
 int
-ahd_pci_config(struct ahd_softc *ahd, struct ahd_pci_identity *entry)
+ahd_pci_config(struct ahd_softc *ahd)
 {
 	struct scb_data *shared_scb_data;
 	u_long		 l;
@@ -312,7 +111,7 @@
 	int		 error;
 
 	shared_scb_data = NULL;
-	ahd->description = entry->name;
+
 	/*
 	 * Record if this is an HP board.
 	 */
@@ -321,7 +120,22 @@
 	if (subvendor == SUBID_HP)
 		ahd->flags |= AHD_HP_BOARD;
 
-	error = entry->setup(ahd);
+	switch (ahd->chip & AHD_CHIPID_MASK) {
+	case AHD_AIC7901:
+		ahd->features = AHD_AIC7901_FE;
+		ahd->description = "Adaptec AIC7901 Ultra320 SCSI adapter";
+		break;
+	case AHD_AIC7901A:
+		ahd->features = AHD_AIC7901A_FE;
+		ahd->description = "Adaptec AIC7901A Ultra320 SCSI adapter";
+		break;
+	case AHD_AIC7902:
+		ahd->features = AHD_AIC7902_FE;
+		ahd->description = "Adaptec AIC7902 Ultra320 SCSI adapter";
+		break;
+	}
+
+	error = ahd_aic790X_setup(ahd);
 	if (error != 0)
 		return (error);
 	
@@ -907,32 +721,6 @@
 			     pcix_status, /*bytes*/2);
 	ahd_outb(ahd, CLRINT, CLRSPLTINT);
 	ahd_restore_modes(ahd, saved_modes);
-}
-
-static int
-ahd_aic7901_setup(struct ahd_softc *ahd)
-{
-
-	ahd->chip = AHD_AIC7901;
-	ahd->features = AHD_AIC7901_FE;
-	return (ahd_aic790X_setup(ahd));
-}
-
-static int
-ahd_aic7901A_setup(struct ahd_softc *ahd)
-{
-
-	ahd->chip = AHD_AIC7901A;
-	ahd->features = AHD_AIC7901A_FE;
-	return (ahd_aic790X_setup(ahd));
-}
-
-static int
-ahd_aic7902_setup(struct ahd_softc *ahd)
-{
-	ahd->chip = AHD_AIC7902;
-	ahd->features = AHD_AIC7902_FE;
-	return (ahd_aic790X_setup(ahd));
 }
 
 static int
