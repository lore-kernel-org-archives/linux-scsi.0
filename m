From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx
 drivers
Date: Mon, 21 Jun 2004 18:24:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621182440.0743036f.ak@suse.de>
References: <20040621161441.20dfcee6.ak@suse.de>
	<20040621174408.012aa366.vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51841 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264098AbUFUOYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:24:14 -0400
In-Reply-To: <20040621174408.012aa366.vsu@altlinux.ru>
List-Id: linux-scsi@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: linux-scsi@vger.kernel.org

On Mon, 21 Jun 2004 17:44:08 +0400
Sergey Vlasov <vsu@altlinux.ru> wrote:

> On Mon, 21 Jun 2004 16:14:41 +0200 Andi Kleen wrote:
> 
> > This is needed for 2.6 hotplug where the driver is autoloaded. When you have
> > multiple conflicting entries the hotplug module loader usually loads
> > the first one listed, which may be correct or may be not.
> > 
> > With these changes the drivers announce the correct PCI IDs.
> 
> Unfortunately, the patch does not seem to be correct :(
> 
> struct pci_device_id does not have the mask field, therefore the
> ID_9005_GENERIC_MASK restriction cannot be specified other than by
> listing all 16 possible IDs as separate entries.  Your patch adds only
> one entry, thus losing 15 other possible IDs.

Hmm, good point.  Thanks for catching this.

Here is a new patch.  Does this one look better?

-Andi


diff -u linux/drivers/scsi/aic7xxx/aic79xx_pci.c-o linux/drivers/scsi/aic7xxx/aic79xx_pci.c
--- linux/drivers/scsi/aic7xxx/aic79xx_pci.c-o	2004-03-21 21:11:51.000000000 +0100
+++ linux/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-06-21 15:15:28.000000000 +0200
@@ -51,46 +51,7 @@
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
-#define ID_ALL_IROC_MASK		0xFFFFFF7FFFFFFFFFull
-#define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
-#define ID_9005_GENERIC_MASK		0xFFF0FFFF00000000ull
-#define ID_9005_GENERIC_IROC_MASK	0xFFF0FF7F00000000ull
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
-#define ID_AIC7902_PCI_REV_A4		0x3
-#define ID_AIC7902_PCI_REV_B0		0x10
-#define SUBID_HP			0x0E11
+#include "aic79xx_pci.h"
 
 #define DEVID_9005_TYPE(id) ((id) & 0xF)
 #define		DEVID_9005_TYPE_HBA		0x0	/* Standard Card */
diff -u linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c-o linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c-o	2004-03-21 21:11:51.000000000 +0100
+++ linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-06-21 18:23:15.000000000 +0200
@@ -41,6 +41,7 @@
 
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
+#include "aic79xx_pci.h"
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
 struct pci_device_id
@@ -58,12 +59,34 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
 
-/* We do our own ID filtering.  So, grab all SCSI storage class devices. */
 static struct pci_device_id ahd_linux_pci_id_table[] = {
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
-	},
+#define LINUXID(x,s) (unsigned)((((x) >> s) & 0xffff) ?: PCI_ANY_ID)
+#define ID(x) \
+	{ \
+		LINUXID(x,32), LINUXID(x,48), LINUXID(x,0), LINUXID(x,16), \
+		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0 \
+	}
+#define ID4(x,y) \
+	ID(x | ((y+0)<<48)), ID(x | ((y+1)<<48)), ID(x | ((y+2)<<48)), \
+	ID(x | ((y+3)<<48))
+#define ID16(x) ID4(x,0ULL), ID4(x,4ULL), ID4(x,8ULL), ID4(x,12ULL)
+	ID(ID_AHA_29320A),
+	ID(ID_AHA_29320ALP),
+	ID(ID_AHA_29320),
+	ID(ID_AHA_29320B),
+	ID(ID_AHA_29320LP),
+	ID(ID_AHA_39320),
+	ID(ID_AHA_39320_B),
+	ID(ID_AHA_39320A),
+	ID(ID_AHA_39320D),
+	ID(ID_AHA_39320D_HP),
+	ID(ID_AHA_39320D_B),
+	ID(ID_AHA_39320D_B_HP),
+	ID(ID_AHA_29320),
+	ID(ID_AHA_29320B),
+	ID(ID_AIC7901 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7901A & ID_DEV_VENDOR_MASK),
+	ID16(ID_AIC7902),
 	{ 0 }
 };
 
diff -u /dev/null linux/drivers/scsi/aic7xxx/aic79xx_pci.h
--- /dev/null	2004-02-18 23:32:57.000000000 +0100
+++ linux/drivers/scsi/aic7xxx/aic79xx_pci.h	2004-06-21 15:04:07.000000000 +0200
@@ -0,0 +1,41 @@
+
+static __inline uint64_t
+ahd_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
+{
+	uint64_t id;
+
+	id = subvendor
+	   | (subdevice << 16)
+	   | ((uint64_t)vendor << 32)
+	   | ((uint64_t)device << 48);
+
+	return (id);
+}
+
+#define ID_ALL_MASK			0xFFFFFFFFFFFFFFFFull
+#define ID_ALL_IROC_MASK		0xFFFFFF7FFFFFFFFFull
+#define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
+#define ID_9005_GENERIC_MASK		0xFFF0FFFF00000000ull
+#define ID_9005_GENERIC_IROC_MASK	0xFFF0FF7F00000000ull
+
+#define ID_AIC7901			0x800F9005FFFF9005ull
+#define ID_AHA_29320A			0x8000900500609005ull
+#define ID_AHA_29320ALP			0x8017900500449005ull
+
+#define ID_AIC7901A			0x801E9005FFFF9005ull
+#define ID_AHA_29320			0x8012900500429005ull
+#define ID_AHA_29320B			0x8013900500439005ull
+#define ID_AHA_29320LP			0x8014900500449005ull
+
+#define ID_AIC7902			0x801F9005FFFF9005ull
+#define ID_AIC7902_B			0x801D9005FFFF9005ull
+#define ID_AHA_39320			0x8010900500409005ull
+#define ID_AHA_39320_B			0x8015900500409005ull
+#define ID_AHA_39320A			0x8016900500409005ull
+#define ID_AHA_39320D			0x8011900500419005ull
+#define ID_AHA_39320D_B			0x801C900500419005ull
+#define ID_AHA_39320D_HP		0x8011900500AC0E11ull
+#define ID_AHA_39320D_B_HP		0x801C900500AC0E11ull
+#define ID_AIC7902_PCI_REV_A4		0x3
+#define ID_AIC7902_PCI_REV_B0		0x10
+#define SUBID_HP			0x0E11
diff -u /dev/null linux/drivers/scsi/aic7xxx/aic7xxx_pci.h
--- /dev/null	2004-02-18 23:32:57.000000000 +0100
+++ linux/drivers/scsi/aic7xxx/aic7xxx_pci.h	2004-06-21 15:05:13.000000000 +0200
@@ -0,0 +1,92 @@
+
+static __inline uint64_t
+ahc_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
+{
+	uint64_t id;
+
+	id = subvendor
+	   | (subdevice << 16)
+	   | ((uint64_t)vendor << 32)
+	   | ((uint64_t)device << 48);
+
+	return (id);
+}
+
+#define ID_ALL_MASK			0xFFFFFFFFFFFFFFFFull
+#define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
+#define ID_9005_GENERIC_MASK		0xFFF0FFFF00000000ull
+#define ID_9005_SISL_MASK		0x000FFFFF00000000ull
+#define ID_9005_SISL_ID			0x0005900500000000ull
+#define ID_AIC7850			0x5078900400000000ull
+#define ID_AHA_2902_04_10_15_20C_30C	0x5078900478509004ull
+#define ID_AIC7855			0x5578900400000000ull
+#define ID_AIC7859			0x3860900400000000ull
+#define ID_AHA_2930CU			0x3860900438699004ull
+#define ID_AIC7860			0x6078900400000000ull
+#define ID_AIC7860C			0x6078900478609004ull
+#define ID_AHA_1480A			0x6075900400000000ull
+#define ID_AHA_2940AU_0			0x6178900400000000ull
+#define ID_AHA_2940AU_1			0x6178900478619004ull
+#define ID_AHA_2940AU_CN		0x2178900478219004ull
+#define ID_AHA_2930C_VAR		0x6038900438689004ull
+
+#define ID_AIC7870			0x7078900400000000ull
+#define ID_AHA_2940			0x7178900400000000ull
+#define ID_AHA_3940			0x7278900400000000ull
+#define ID_AHA_398X			0x7378900400000000ull
+#define ID_AHA_2944			0x7478900400000000ull
+#define ID_AHA_3944			0x7578900400000000ull
+#define ID_AHA_4944			0x7678900400000000ull
+
+#define ID_AIC7880			0x8078900400000000ull
+#define ID_AIC7880_B			0x8078900478809004ull
+#define ID_AHA_2940U			0x8178900400000000ull
+#define ID_AHA_3940U			0x8278900400000000ull
+#define ID_AHA_2944U			0x8478900400000000ull
+#define ID_AHA_3944U			0x8578900400000000ull
+#define ID_AHA_398XU			0x8378900400000000ull
+#define ID_AHA_4944U			0x8678900400000000ull
+#define ID_AHA_2940UB			0x8178900478819004ull
+#define ID_AHA_2930U			0x8878900478889004ull
+#define ID_AHA_2940U_PRO		0x8778900478879004ull
+#define ID_AHA_2940U_CN			0x0078900478009004ull
+
+#define ID_AIC7895			0x7895900478959004ull
+#define ID_AIC7895_ARO			0x7890900478939004ull
+#define ID_AIC7895_ARO_MASK		0xFFF0FFFFFFFFFFFFull
+#define ID_AHA_2940U_DUAL		0x7895900478919004ull
+#define ID_AHA_3940AU			0x7895900478929004ull
+#define ID_AHA_3944AU			0x7895900478949004ull
+
+#define ID_AIC7890			0x001F9005000F9005ull
+#define ID_AIC7890_ARO			0x00139005000F9005ull
+#define ID_AAA_131U2			0x0013900500039005ull
+#define ID_AHA_2930U2			0x0011900501819005ull
+#define ID_AHA_2940U2B			0x00109005A1009005ull
+#define ID_AHA_2940U2_OEM		0x0010900521809005ull
+#define ID_AHA_2940U2			0x00109005A1809005ull
+#define ID_AHA_2950U2B			0x00109005E1009005ull
+
+#define ID_AIC7892			0x008F9005FFFF9005ull
+#define ID_AIC7892_ARO			0x00839005FFFF9005ull
+#define ID_AHA_29160			0x00809005E2A09005ull
+#define ID_AHA_29160_CPQ		0x00809005E2A00E11ull
+#define ID_AHA_29160N			0x0080900562A09005ull
+#define ID_AHA_29160C			0x0080900562209005ull
+#define ID_AHA_29160B			0x00809005E2209005ull
+#define ID_AHA_19160B			0x0081900562A19005ull
+
+#define ID_AIC7896			0x005F9005FFFF9005ull
+#define ID_AIC7896_ARO			0x00539005FFFF9005ull
+#define ID_AHA_3950U2B_0		0x00509005FFFF9005ull
+#define ID_AHA_3950U2B_1		0x00509005F5009005ull
+#define ID_AHA_3950U2D_0		0x00519005FFFF9005ull
+#define ID_AHA_3950U2D_1		0x00519005B5009005ull
+
+#define ID_AIC7899			0x00CF9005FFFF9005ull
+#define ID_AIC7899_ARO			0x00C39005FFFF9005ull
+#define ID_AHA_3960D			0x00C09005F6209005ull
+#define ID_AHA_3960D_CPQ		0x00C09005F6200E11ull
+
+#define ID_AIC7810			0x1078900400000000ull
+#define ID_AIC7815			0x7815900400000000ull
diff -u linux/drivers/scsi/aic7xxx/aic7xxx_pci.c-o linux/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- linux/drivers/scsi/aic7xxx/aic7xxx_pci.c-o	2004-03-21 21:11:51.000000000 +0100
+++ linux/drivers/scsi/aic7xxx/aic7xxx_pci.c	2004-06-21 15:15:24.000000000 +0200
@@ -54,101 +54,11 @@
 #include <dev/aic7xxx/aic7xxx_93cx6.h>
 #endif
 
+#include "aic7xxx_pci.h"
+
 #define AHC_PCI_IOADDR	PCIR_MAPS	/* I/O Address */
 #define AHC_PCI_MEMADDR	(PCIR_MAPS + 4)	/* Mem I/O Address */
 
-static __inline uint64_t
-ahc_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
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
-#define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
-#define ID_9005_GENERIC_MASK		0xFFF0FFFF00000000ull
-#define ID_9005_SISL_MASK		0x000FFFFF00000000ull
-#define ID_9005_SISL_ID			0x0005900500000000ull
-#define ID_AIC7850			0x5078900400000000ull
-#define ID_AHA_2902_04_10_15_20C_30C	0x5078900478509004ull
-#define ID_AIC7855			0x5578900400000000ull
-#define ID_AIC7859			0x3860900400000000ull
-#define ID_AHA_2930CU			0x3860900438699004ull
-#define ID_AIC7860			0x6078900400000000ull
-#define ID_AIC7860C			0x6078900478609004ull
-#define ID_AHA_1480A			0x6075900400000000ull
-#define ID_AHA_2940AU_0			0x6178900400000000ull
-#define ID_AHA_2940AU_1			0x6178900478619004ull
-#define ID_AHA_2940AU_CN		0x2178900478219004ull
-#define ID_AHA_2930C_VAR		0x6038900438689004ull
-
-#define ID_AIC7870			0x7078900400000000ull
-#define ID_AHA_2940			0x7178900400000000ull
-#define ID_AHA_3940			0x7278900400000000ull
-#define ID_AHA_398X			0x7378900400000000ull
-#define ID_AHA_2944			0x7478900400000000ull
-#define ID_AHA_3944			0x7578900400000000ull
-#define ID_AHA_4944			0x7678900400000000ull
-
-#define ID_AIC7880			0x8078900400000000ull
-#define ID_AIC7880_B			0x8078900478809004ull
-#define ID_AHA_2940U			0x8178900400000000ull
-#define ID_AHA_3940U			0x8278900400000000ull
-#define ID_AHA_2944U			0x8478900400000000ull
-#define ID_AHA_3944U			0x8578900400000000ull
-#define ID_AHA_398XU			0x8378900400000000ull
-#define ID_AHA_4944U			0x8678900400000000ull
-#define ID_AHA_2940UB			0x8178900478819004ull
-#define ID_AHA_2930U			0x8878900478889004ull
-#define ID_AHA_2940U_PRO		0x8778900478879004ull
-#define ID_AHA_2940U_CN			0x0078900478009004ull
-
-#define ID_AIC7895			0x7895900478959004ull
-#define ID_AIC7895_ARO			0x7890900478939004ull
-#define ID_AIC7895_ARO_MASK		0xFFF0FFFFFFFFFFFFull
-#define ID_AHA_2940U_DUAL		0x7895900478919004ull
-#define ID_AHA_3940AU			0x7895900478929004ull
-#define ID_AHA_3944AU			0x7895900478949004ull
-
-#define ID_AIC7890			0x001F9005000F9005ull
-#define ID_AIC7890_ARO			0x00139005000F9005ull
-#define ID_AAA_131U2			0x0013900500039005ull
-#define ID_AHA_2930U2			0x0011900501819005ull
-#define ID_AHA_2940U2B			0x00109005A1009005ull
-#define ID_AHA_2940U2_OEM		0x0010900521809005ull
-#define ID_AHA_2940U2			0x00109005A1809005ull
-#define ID_AHA_2950U2B			0x00109005E1009005ull
-
-#define ID_AIC7892			0x008F9005FFFF9005ull
-#define ID_AIC7892_ARO			0x00839005FFFF9005ull
-#define ID_AHA_29160			0x00809005E2A09005ull
-#define ID_AHA_29160_CPQ		0x00809005E2A00E11ull
-#define ID_AHA_29160N			0x0080900562A09005ull
-#define ID_AHA_29160C			0x0080900562209005ull
-#define ID_AHA_29160B			0x00809005E2209005ull
-#define ID_AHA_19160B			0x0081900562A19005ull
-
-#define ID_AIC7896			0x005F9005FFFF9005ull
-#define ID_AIC7896_ARO			0x00539005FFFF9005ull
-#define ID_AHA_3950U2B_0		0x00509005FFFF9005ull
-#define ID_AHA_3950U2B_1		0x00509005F5009005ull
-#define ID_AHA_3950U2D_0		0x00519005FFFF9005ull
-#define ID_AHA_3950U2D_1		0x00519005B5009005ull
-
-#define ID_AIC7899			0x00CF9005FFFF9005ull
-#define ID_AIC7899_ARO			0x00C39005FFFF9005ull
-#define ID_AHA_3960D			0x00C09005F6209005ull
-#define ID_AHA_3960D_CPQ		0x00C09005F6200E11ull
-
-#define ID_AIC7810			0x1078900400000000ull
-#define ID_AIC7815			0x7815900400000000ull
-
 #define DEVID_9005_TYPE(id) ((id) & 0xF)
 #define		DEVID_9005_TYPE_HBA		0x0	/* Standard Card */
 #define		DEVID_9005_TYPE_AAA		0x3	/* RAID Card */
diff -u linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c-o linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c-o	2004-03-21 21:11:51.000000000 +0100
+++ linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-06-21 18:23:44.000000000 +0200
@@ -40,6 +40,7 @@
  */
 
 #include "aic7xxx_osm.h"
+#include "aic7xxx_pci.h"
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
 struct pci_device_id
@@ -57,16 +58,77 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
 
-/* We do our own ID filtering.  So, grab all SCSI storage class devices. */
 static struct pci_device_id ahc_linux_pci_id_table[] = {
-	{
-		0x9004, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
-	},
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
-	},
+#define LINUXID(x,s) (unsigned)((((x) >> s) & 0xffff) ?: PCI_ANY_ID)
+#define ID(x) \
+	{ \
+		LINUXID(x,32), LINUXID(x,48), LINUXID(x,0), LINUXID(x,16), \
+		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0 \
+	}
+#define ID4(x,y) \
+	ID(x | ((y+0)<<48)), ID(x | ((y+1)<<48)), ID(x | ((y+2)<<48)), \
+	ID(x | ((y+3)<<48))
+#define ID16(x) ID4(x,0ULL), ID4(x,4ULL), ID4(x,8ULL), ID4(x,12ULL)
+	ID(ID_AHA_2902_04_10_15_20C_30C),
+	ID(ID_AHA_2930CU),
+	ID(ID_AHA_1480A & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2940AU_0 & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2940AU_CN & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2930C_VAR & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2940),
+	ID(ID_AHA_3940),
+	ID(ID_AHA_398X),
+	ID(ID_AHA_2944),
+	ID(ID_AHA_3944),
+	ID(ID_AHA_4944),
+	ID(ID_AHA_2940U & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_3940U & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2944U & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_3944U & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_398XU & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_4944U & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2930U & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2940U_PRO & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2940U_CN & ID_DEV_VENDOR_MASK),
+	ID(ID_AHA_2930U2),
+	ID(ID_AHA_2940U2B),
+	ID(ID_AHA_2940U2_OEM),
+	ID(ID_AHA_2940U2),
+	ID(ID_AHA_2950U2B),
+	ID(ID_AIC7890_ARO),
+	ID(ID_AAA_131U2),
+	ID(ID_AHA_29160),
+	ID(ID_AHA_29160_CPQ),
+	ID(ID_AHA_29160N),
+	ID(ID_AHA_29160C),
+	ID(ID_AHA_29160B),
+	ID(ID_AHA_19160B),
+	ID(ID_AIC7892_ARO),
+	ID(ID_AHA_2940U_DUAL),
+	ID(ID_AHA_3940AU),
+	ID(ID_AHA_3944AU),
+	ID(ID_AIC7895_ARO),
+	ID(ID_AHA_3950U2B_0),
+	ID(ID_AHA_3950U2B_1),
+	ID(ID_AHA_3950U2D_0),
+	ID(ID_AHA_3950U2D_1),
+	ID(ID_AIC7896_ARO),
+	ID(ID_AHA_3960D),
+	ID(ID_AHA_3960D_CPQ),
+	ID(ID_AIC7899_ARO),
+	ID(ID_AIC7850 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7855 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7859 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7860 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7870 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7880 & ID_DEV_VENDOR_MASK),
+	ID16(ID_AIC7890),
+	ID16(ID_AIC7892),
+	ID(ID_AIC7895 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7896),
+	ID(ID_AIC7899),
+	ID(ID_AIC7810 & ID_DEV_VENDOR_MASK),
+	ID(ID_AIC7815 & ID_DEV_VENDOR_MASK),
 	{ 0 }
 };
 
