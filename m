From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH] Adding PCI ID tables to aic7xxx and aic79xxx
Date: Tue, 12 Oct 2004 13:35:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416C15E5.7030805@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6873 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266538AbUJLRfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 13:35:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>

Adding proper PCI ID tables to aic7xxx and aic79xx.

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/12 13:35:39-04:00 luben@lion.adaptec.com
#   Adding proper PCI ID tables to aic7xxx and aic79xx drivers.
#
# drivers/scsi/aic7xxx/aiclib.h
#   2004/10/12 13:35:25-04:00 luben@lion.adaptec.com +39 -0
#   Adding macros for generating the elements of PCI ID tables.
#
# drivers/scsi/aic7xxx/aic7xxx_pci.h
#   2004/10/12 13:35:25-04:00 luben@lion.adaptec.com +45 -13
#   Adding copyright and proper macro declarations.
#
# drivers/scsi/aic7xxx/aic7xxx_pci.c
#   2004/10/12 13:35:25-04:00 luben@lion.adaptec.com +13 -0
#   No need of this static function in this header file.
#
# drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
#   2004/10/12 13:35:25-04:00 luben@lion.adaptec.com +18 -15
#   Adding proper PCI ID table.
#
# drivers/scsi/aic7xxx/aic79xx_pci.c
#   2004/10/12 13:35:25-04:00 luben@lion.adaptec.com +2 -24
#   Moving ID definitions out of this file into their own.
#
# drivers/scsi/aic7xxx/aic79xx_osm_pci.c
#   2004/10/12 13:35:25-04:00 luben@lion.adaptec.com +25 -9
#   Adding PCI ID table.
#
# drivers/scsi/aic7xxx/aic79xx_osm.h
#   2004/10/12 13:35:25-04:00 luben@lion.adaptec.com +1 -0
#   Cosmetic.
#
# drivers/scsi/aic7xxx/aic79xx_pci.h
#   2004/10/12 11:09:00-04:00 luben@lion.adaptec.com +70 -0
#
# drivers/scsi/aic7xxx/aic79xx_pci.h
#   2004/10/12 11:08:59-04:00 luben@lion.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_pci.h
#
# drivers/scsi/aic7xxx/aic79xx_pci.c
#   2004/10/08 17:44:32-04:00 luben@lion.adaptec.com +0 -0
#   *** empty log message ***
#
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-10-12 13:37:14 -04:00
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-10-12 13:37:14 -04:00
@@ -1143,4 +1143,5 @@
  #endif
  #define bootverbose aic79xx_verbose
  extern uint32_t aic79xx_verbose;
+
  #endif /* _AIC79XX_LINUX_H_ */
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-10-12 13:37:14 -04:00
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-10-12 13:37:14 -04:00
@@ -41,6 +41,7 @@

  #include "aic79xx_osm.h"
  #include "aic79xx_inline.h"
+#include "aic79xx_pci.h"

  static int	ahd_linux_pci_dev_probe(struct pci_dev *pdev,
  					const struct pci_device_id *ent);
@@ -51,16 +52,31 @@
  						 uint8_t **maddr);
  static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);

-/* We do our own ID filtering.  So, grab all SCSI storage class devices. */
+/* Define the macro locally since it's different for different class of chips.
+ */
+#define ID(x)            \
+	ID2C(x),         \
+	ID2C(IDIROC(x))
+
  static struct pci_device_id ahd_linux_pci_id_table[] = {
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
-	},
-	{
-		0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xFFFF00, 0
-	},
+	/* aic7901 based controllers */
+	ID(ID_AHA_29320A),
+	ID(ID_AHA_29320ALP),
+	/* aic7902 based controllers */
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
+	/* Generic chip probes for devices we don't know exactly. */
+	ID16(ID_AIC7901 & ID_9005_GENERIC_MASK),
+	ID(ID_AIC7901A & ID_DEV_VENDOR_MASK),
+	ID16(ID_AIC7902 & ID_9005_GENERIC_MASK),
  	{ 0 }
  };

diff -Nru a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-10-12 13:37:14 -04:00
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-10-12 13:37:14 -04:00
@@ -51,6 +51,8 @@
  #include <dev/aic7xxx/aic79xx_inline.h>
  #endif

+#include "aic79xx_pci.h"
+
  static __inline uint64_t
  ahd_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
  {
@@ -64,30 +66,6 @@
  	return (id);
  }

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
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_pci.h b/drivers/scsi/aic7xxx/aic79xx_pci.h
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.h	2004-10-12 13:37:14 -04:00
@@ -0,0 +1,70 @@
+/*
+ * Adaptec AIC79xx device driver for Linux.
+ *
+ * Copyright (c) 2000-2001 Adaptec Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ * $Id$
+ *
+ */
+#ifndef _AIC79XX_PCI_H_
+#define _AIC79XX_PCI_H_
+
+#define ID_ALL_MASK			0xFFFFFFFFFFFFFFFFull
+#define ID_ALL_IROC_MASK		0xFF7FFFFFFFFFFFFFull
+#define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
+#define ID_9005_GENERIC_MASK		0xFFF0FFFF00000000ull
+#define ID_9005_GENERIC_IROC_MASK	0xFF70FFFF00000000ull
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
+
+#endif /* _AIC79XX_PCI_H_ */
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-10-12 13:37:14 -04:00
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-10-12 13:37:14 -04:00
@@ -58,29 +58,27 @@
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);

+/* Define the macro locally since it's different for different class of chips.
+*/
+#define ID(x)	ID_C(x, PCI_CLASS_STORAGE_SCSI)
+
  static struct pci_device_id ahc_linux_pci_id_table[] = {
-#define LINUXID(x,s) (unsigned)((((x) >> s) & 0xffff) ?: PCI_ANY_ID)
-#define ID(x) \
-	{ \
-		LINUXID(x,32), LINUXID(x,48), LINUXID(x,0), LINUXID(x,16), \
-		PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0 \
-	}
-#define ID4(x,y) \
-	ID(x | ((y+0)<<48)), ID(x | ((y+1)<<48)), ID(x | ((y+2)<<48)), \
-	ID(x | ((y+3)<<48))
-#define ID16(x) ID4(x,0ULL), ID4(x,4ULL), ID4(x,8ULL), ID4(x,12ULL)
+	/* aic7850 based controllers */
  	ID(ID_AHA_2902_04_10_15_20C_30C),
+	/* aic7860 based controllers */
  	ID(ID_AHA_2930CU),
  	ID(ID_AHA_1480A & ID_DEV_VENDOR_MASK),
  	ID(ID_AHA_2940AU_0 & ID_DEV_VENDOR_MASK),
  	ID(ID_AHA_2940AU_CN & ID_DEV_VENDOR_MASK),
  	ID(ID_AHA_2930C_VAR & ID_DEV_VENDOR_MASK),
+	/* aic7870 based controllers */
  	ID(ID_AHA_2940),
  	ID(ID_AHA_3940),
  	ID(ID_AHA_398X),
  	ID(ID_AHA_2944),
  	ID(ID_AHA_3944),
  	ID(ID_AHA_4944),
+	/* aic7880 based controllers */
  	ID(ID_AHA_2940U & ID_DEV_VENDOR_MASK),
  	ID(ID_AHA_3940U & ID_DEV_VENDOR_MASK),
  	ID(ID_AHA_2944U & ID_DEV_VENDOR_MASK),
@@ -90,13 +88,15 @@
  	ID(ID_AHA_2930U & ID_DEV_VENDOR_MASK),
  	ID(ID_AHA_2940U_PRO & ID_DEV_VENDOR_MASK),
  	ID(ID_AHA_2940U_CN & ID_DEV_VENDOR_MASK),
+	/* aic7890 based controllers */
  	ID(ID_AHA_2930U2),
  	ID(ID_AHA_2940U2B),
  	ID(ID_AHA_2940U2_OEM),
  	ID(ID_AHA_2940U2),
  	ID(ID_AHA_2950U2B),
-	ID(ID_AIC7890_ARO),
+	ID16(ID_AIC7890_ARO & ID_AIC7895_ARO_MASK),
  	ID(ID_AAA_131U2),
+	/* aic7890 based controllers */
  	ID(ID_AHA_29160),
  	ID(ID_AHA_29160_CPQ),
  	ID(ID_AHA_29160N),
@@ -104,6 +104,7 @@
  	ID(ID_AHA_29160B),
  	ID(ID_AHA_19160B),
  	ID(ID_AIC7892_ARO),
+	/* aic7892 based controllers */
  	ID(ID_AHA_2940U_DUAL),
  	ID(ID_AHA_3940AU),
  	ID(ID_AHA_3944AU),
@@ -113,20 +114,22 @@
  	ID(ID_AHA_3950U2D_0),
  	ID(ID_AHA_3950U2D_1),
  	ID(ID_AIC7896_ARO),
+	/* aic7899 based controllers */
  	ID(ID_AHA_3960D),
  	ID(ID_AHA_3960D_CPQ),
  	ID(ID_AIC7899_ARO),
+	/* Generic chip probes for devices we don't know exactly. */
  	ID(ID_AIC7850 & ID_DEV_VENDOR_MASK),
  	ID(ID_AIC7855 & ID_DEV_VENDOR_MASK),
  	ID(ID_AIC7859 & ID_DEV_VENDOR_MASK),
  	ID(ID_AIC7860 & ID_DEV_VENDOR_MASK),
  	ID(ID_AIC7870 & ID_DEV_VENDOR_MASK),
  	ID(ID_AIC7880 & ID_DEV_VENDOR_MASK),
-	ID16(ID_AIC7890),
-	ID16(ID_AIC7892),
+ 	ID16(ID_AIC7890 & ID_9005_GENERIC_MASK),
+ 	ID16(ID_AIC7892 & ID_9005_GENERIC_MASK),
  	ID(ID_AIC7895 & ID_DEV_VENDOR_MASK),
-	ID(ID_AIC7896),
-	ID(ID_AIC7899),
+	ID16(ID_AIC7896 & ID_9005_GENERIC_MASK),
+	ID16(ID_AIC7899 & ID_9005_GENERIC_MASK),
  	ID(ID_AIC7810 & ID_DEV_VENDOR_MASK),
  	ID(ID_AIC7815 & ID_DEV_VENDOR_MASK),
  	{ 0 }
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c	2004-10-12 13:37:14 -04:00
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c	2004-10-12 13:37:14 -04:00
@@ -56,6 +56,19 @@

  #include "aic7xxx_pci.h"

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
  #define AHC_PCI_IOADDR	PCIR_MAPS	/* I/O Address */
  #define AHC_PCI_MEMADDR	(PCIR_MAPS + 4)	/* Mem I/O Address */

diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_pci.h b/drivers/scsi/aic7xxx/aic7xxx_pci.h
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.h	2004-10-12 13:37:14 -04:00
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.h	2004-10-12 13:37:14 -04:00
@@ -1,16 +1,46 @@
-
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
+/*
+ * Adaptec AIC7xxx device driver for Linux.
+ *
+ * Copyright (c) 2000-2001 Adaptec Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ * $Id$
+ *
+ */
+#ifndef _AIC7XXX_PCI_H_
+#define _AIC7XXX_PCI_H_

  #define ID_ALL_MASK			0xFFFFFFFFFFFFFFFFull
  #define ID_DEV_VENDOR_MASK		0xFFFFFFFF00000000ull
@@ -90,3 +120,5 @@

  #define ID_AIC7810			0x1078900400000000ull
  #define ID_AIC7815			0x7815900400000000ull
+
+#endif /* _AIC7XXX_PCI_H_ */
diff -Nru a/drivers/scsi/aic7xxx/aiclib.h b/drivers/scsi/aic7xxx/aiclib.h
--- a/drivers/scsi/aic7xxx/aiclib.h	2004-10-12 13:37:14 -04:00
+++ b/drivers/scsi/aic7xxx/aiclib.h	2004-10-12 13:37:14 -04:00
@@ -1043,4 +1043,43 @@
  	return (rv);
  }

+/* Macros for generating the elements of the PCI ID tables. */
+
+#define GETID(v, s) (unsigned)(((v) >> (s)) & 0xFFFF ?: PCI_ANY_ID)
+
+#define ID_C(x, c)						\
+{								\
+	GETID(x,32), GETID(x,48), GETID(x,0), GETID(x,16),	\
+	(c) << 8, 0xFFFF00, 0					\
+}
+
+#define ID2C(x)                          \
+	ID_C(x, PCI_CLASS_STORAGE_SCSI), \
+	ID_C(x, PCI_CLASS_STORAGE_RAID)
+
+#define IDIROC(x)  ((x) | ~ID_ALL_IROC_MASK)
+
+/* Generate IDs for all 16 possibilites.
+ * The argument has already masked out
+ * the 4 least significant bits of the device id.
+ * (e.g., mask: ID_9005_GENERIC_MASK).
+ */
+#define ID16(x)                          \
+	ID(x),                           \
+	ID((x) | 0x0001000000000000ull), \
+	ID((x) | 0x0002000000000000ull), \
+	ID((x) | 0x0003000000000000ull), \
+	ID((x) | 0x0004000000000000ull), \
+	ID((x) | 0x0005000000000000ull), \
+	ID((x) | 0x0006000000000000ull), \
+	ID((x) | 0x0007000000000000ull), \
+	ID((x) | 0x0008000000000000ull), \
+	ID((x) | 0x0009000000000000ull), \
+	ID((x) | 0x000A000000000000ull), \
+	ID((x) | 0x000B000000000000ull), \
+	ID((x) | 0x000C000000000000ull), \
+	ID((x) | 0x000D000000000000ull), \
+	ID((x) | 0x000E000000000000ull), \
+	ID((x) | 0x000F000000000000ull)
+
  #endif /*_AICLIB_H */

