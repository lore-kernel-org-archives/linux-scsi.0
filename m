From: Christoph Hellwig <hch@lst.de>
Subject: [CFT] another try at getting the aic79xx pci table right
Date: Sun, 10 Oct 2004 13:49:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041010114932.GA1949@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:65193 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268260AbUJJLus (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Oct 2004 07:50:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Avery Fay <afay@student.umass.edu>, linux-scsi@vger.kernel.org

[Patch vs current scsi BK, if someone needs it again=DFt a kernel it
doesn't apply against ping me]

This is a revision of the previous patch, I've now added a AHD_DEV()
macro so we automatically get the fakeraid HBAs that have 0x80 added
to their PCI IDs vs the base ones, and I've removed all subdevice
matching.  It's now matching all HBAs mentioned in pci.ids and some
more (generic matches from the existing aic79xx driver)


--- 1.14/drivers/scsi/aic7xxx/aic79xx.h	2004-09-23 19:36:11 +02:00
+++ edited/drivers/scsi/aic7xxx/aic79xx.h	2004-10-09 14:49:02 +02:00
@@ -1341,9 +1341,7 @@
 }
=20
 /***************************** PCI Front End *************************=
********/
-struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
-int			  ahd_pci_config(struct ahd_softc *,
-					 struct ahd_pci_identity *);
+int			  ahd_pci_config(struct ahd_softc *);
 int	ahd_pci_test_register_access(struct ahd_softc *);
=20
 /************************** SCB and SCB queue management *************=
*********/
=3D=3D=3D=3D=3D drivers/scsi/aic7xxx/aic79xx_osm_pci.c 1.13 vs edited =3D=
=3D=3D=3D=3D
--- 1.13/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-09-23 19:36:11 +02=
:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-10-09 15:12:55 +=
02:00
@@ -51,17 +51,32 @@
 						 uint8_t **maddr);
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
=20
-/* We do our own ID filtering.  So, grab all SCSI storage class device=
s. */
+#define AHD_DEV(dev, type)						\
+	/* regular HBA */						\
+	{ 0x9005, (dev), PCI_ANY_ID, PCI_ANY_ID, 0, 0, (type) },	\
+	/* fakeraid HBA */						\
+	{ 0x9005, (dev) + 0x80, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (type) }
+
 static struct pci_device_id ahd_linux_pci_id_table[] =3D {
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
-	},
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xFFFF00, 0
-	},
-	{ 0 }
+	AHD_DEV(0x8000, AHD_AIC7901),
+	AHD_DEV(0x800f, AHD_AIC7901),
+	AHD_DEV(0x8010, AHD_AIC7902),
+	AHD_DEV(0x8011, AHD_AIC7902),
+	AHD_DEV(0x8012, AHD_AIC7902),
+	AHD_DEV(0x8013, AHD_AIC7902),
+	AHD_DEV(0x8014, AHD_AIC7902),
+	AHD_DEV(0x8015, AHD_AIC7902),
+	AHD_DEV(0x8016, AHD_AIC7902),
+	AHD_DEV(0x8017, AHD_AIC7901),
+	AHD_DEV(0x8018, AHD_AIC7902),
+	AHD_DEV(0x8019, AHD_AIC7902),
+	AHD_DEV(0x801a, AHD_AIC7902),
+	AHD_DEV(0x801c, AHD_AIC7902),
+	AHD_DEV(0x801b, AHD_AIC7902),
+	AHD_DEV(0x801d, AHD_AIC7902),
+	AHD_DEV(0x801e, AHD_AIC7901A),
+	AHD_DEV(0x801f, AHD_AIC7902),
+	{ }
 };
=20
 MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
@@ -103,7 +118,6 @@
 	char		 buf[80];
 	struct		 ahd_softc *ahd;
 	ahd_dev_softc_t	 pci;
-	struct		 ahd_pci_identity *entry;
 	char		*name;
 	int		 error;
=20
@@ -124,9 +138,6 @@
 	}
=20
 	pci =3D pdev;
-	entry =3D ahd_find_pci_device(pci);
-	if (entry =3D=3D NULL)
-		return (-ENODEV);
=20
 	/*
 	 * Allocate a softc for this card and
@@ -172,7 +183,8 @@
 		ahd->platform_data->hw_dma_mask =3D 0xFFFFFFFF;
 	}
 	ahd->dev_softc =3D pci;
-	error =3D ahd_pci_config(ahd, entry);
+	ahd->chip =3D ent->driver_data;
+	error =3D ahd_pci_config(ahd);
 	if (error !=3D 0) {
 		ahd_free(ahd);
 		return (-error);
=3D=3D=3D=3D=3D drivers/scsi/aic7xxx/aic79xx_pci.c 1.15 vs edited =3D=3D=
=3D=3D=3D
--- 1.15/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-08-21 15:27:19 +02:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-10-09 14:49:03 +02:0=
0
@@ -51,175 +51,12 @@
 #include <dev/aic7xxx/aic79xx_inline.h>
 #endif
=20
-static __inline uint64_t
-ahd_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subv=
endor)
-{
-	uint64_t id;
-
-	id =3D subvendor
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
=20
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
-#define SUBID_9005_AUTOTERM(id)	(((id) & 0x10) =3D=3D 0)
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
=20
-struct ahd_pci_identity ahd_pci_ident_table [] =3D
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
-	/* aic7902 based controllers */=09
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
-const u_int ahd_num_pci_devs =3D NUM_ELEMENTS(ahd_pci_ident_table);
-	=09
 #define	DEVCONFIG		0x40
 #define		PCIXINITPAT	0x0000E000ul
 #define			PCIXINIT_PCI33_66	0x0000E000ul
@@ -263,46 +100,8 @@
 					  u_int adapter_control);
 static void	ahd_pci_split_intr(struct ahd_softc *ahd, u_int intstat);
=20
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
-	vendor =3D ahd_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
-	device =3D ahd_pci_read_config(pci, PCIR_DEVICE, /*bytes*/2);
-	subvendor =3D ahd_pci_read_config(pci, PCIR_SUBVEND_0, /*bytes*/2);
-	subdevice =3D ahd_pci_read_config(pci, PCIR_SUBDEV_0, /*bytes*/2);
-	full_id =3D ahd_compose_id(device,
-				 vendor,
-				 subdevice,
-				 subvendor);
-
-	/*
-	 * Controllers, mask out the IROC/HostRAID bit
-	 */
-=09
-	full_id &=3D ID_ALL_IROC_MASK;
-
-	for (i =3D 0; i < ahd_num_pci_devs; i++) {
-		entry =3D &ahd_pci_ident_table[i];
-		if (entry->full_id =3D=3D (full_id & entry->id_mask)) {
-			/* Honor exclusion entries. */
-			if (entry->name =3D=3D NULL)
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
=20
 	shared_scb_data =3D NULL;
-	ahd->description =3D entry->name;
+
 	/*
 	 * Record if this is an HP board.
 	 */
@@ -321,7 +120,22 @@
 	if (subvendor =3D=3D SUBID_HP)
 		ahd->flags |=3D AHD_HP_BOARD;
=20
-	error =3D entry->setup(ahd);
+	switch (ahd->chip & AHD_CHIPID_MASK) {
+	case AHD_AIC7901:
+		ahd->features =3D AHD_AIC7901_FE;
+		ahd->description =3D "Adaptec AIC7901 Ultra320 SCSI adapter";
+		break;
+	case AHD_AIC7901A:
+		ahd->features =3D AHD_AIC7901A_FE;
+		ahd->description =3D "Adaptec AIC7901A Ultra320 SCSI adapter";
+		break;
+	case AHD_AIC7902:
+		ahd->features =3D AHD_AIC7902_FE;
+		ahd->description =3D "Adaptec AIC7902 Ultra320 SCSI adapter";
+		break;
+	}
+
+	error =3D ahd_aic790X_setup(ahd);
 	if (error !=3D 0)
 		return (error);
 =09
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
-	ahd->chip =3D AHD_AIC7901;
-	ahd->features =3D AHD_AIC7901_FE;
-	return (ahd_aic790X_setup(ahd));
-}
-
-static int
-ahd_aic7901A_setup(struct ahd_softc *ahd)
-{
-
-	ahd->chip =3D AHD_AIC7901A;
-	ahd->features =3D AHD_AIC7901A_FE;
-	return (ahd_aic790X_setup(ahd));
-}
-
-static int
-ahd_aic7902_setup(struct ahd_softc *ahd)
-{
-	ahd->chip =3D AHD_AIC7902;
-	ahd->features =3D AHD_AIC7902_FE;
-	return (ahd_aic790X_setup(ahd));
 }
=20
 static int
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
