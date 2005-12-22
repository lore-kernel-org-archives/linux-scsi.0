From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] aic7xxx: New device ids
Date: Thu, 22 Dec 2005 15:14:14 +0100
Message-ID: <43AAB4B6.3040403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:29101 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932502AbVLVOOP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 09:14:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

[PATCH 1/6] aic7xxx: New device ids

Add new device id to aic7xxx and aic79xx.
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |   28 ++++++++++++++++++----------
 drivers/scsi/aic7xxx/aic79xx_pci.h |    5 +++--
 drivers/scsi/aic7xxx/aic7xxx_pci.c |   28 ++++++++++++++++++++++++----
 drivers/scsi/aic7xxx/aic7xxx_pci.h |    1 +
 4 files changed, 46 insertions(+), 16 deletions(-)

a7910fe6a5d4fc2dd85f06e973e2214b39cc4172
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c
b/drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -2,7 +2,7 @@
  * Product specific probe and attach routines for:
  *	aic7901 and aic7902 SCSI controllers
  *
- * Copyright (c) 1994-2001 Justin T. Gibbs.
+ * Copyright (c) 1994-2000 Justin T. Gibbs.
  * Copyright (c) 2000-2002 Adaptec Inc.
  * All rights reserved.
  *
@@ -38,15 +38,15 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#77 $
- *
- * $FreeBSD$
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#89 $
  */

 #ifdef __linux__
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
 #else
+#include <sys/cdefs.h>
+__FBSDID("$FreeBSD$");
 #include <dev/aic7xxx/aic79xx_osm.h>
 #include <dev/aic7xxx/aic79xx_inline.h>
 #endif
@@ -114,6 +114,13 @@ struct ahd_pci_identity ahd_pci_ident_ta
 		"Adaptec 29320ALP Ultra320 SCSI adapter",
 		ahd_aic7901_setup
 	},
+	/* aic7901A based controllers */
+	{
+		ID_AHA_29320LP,
+		ID_ALL_MASK,
+		"Adaptec 29320LP Ultra320 SCSI adapter",
+		ahd_aic7901A_setup
+	},
 	/* aic7902 based controllers */=09
 	{
 		ID_AHA_29320,
@@ -128,12 +135,6 @@ struct ahd_pci_identity ahd_pci_ident_ta
 		ahd_aic7902_setup
 	},
 	{
-		ID_AHA_29320LP,
-		ID_ALL_MASK,
-		"Adaptec 29320LP Ultra320 SCSI adapter",
-		ahd_aic7901A_setup
-	},
-	{
 		ID_AHA_39320,
 		ID_ALL_MASK,
 		"Adaptec 39320 Ultra320 SCSI adapter",
@@ -146,6 +147,12 @@ struct ahd_pci_identity ahd_pci_ident_ta
 		ahd_aic7902_setup
 	},
 	{
+		ID_AHA_39320_B_DELL,
+		ID_ALL_MASK,
+		"Adaptec (Dell OEM) 39320 Ultra320 SCSI adapter",
+		ahd_aic7902_setup
+	},
+	{
 		ID_AHA_39320A,
 		ID_ALL_MASK,
 		"Adaptec 39320A Ultra320 SCSI adapter",
@@ -668,6 +675,7 @@ ahd_configure_termination(struct ahd_sof
 	 * Now set the termination based on what we found.
 	 */
 	sxfrctl1 =3D ahd_inb(ahd, SXFRCTL1) & ~STPWEN;
+	ahd->flags &=3D ~AHD_TERM_ENB_A;
 	if ((termctl & FLX_TERMCTL_ENPRILOW) !=3D 0) {
 		ahd->flags |=3D AHD_TERM_ENB_A;
 		sxfrctl1 |=3D STPWEN;
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.h
b/drivers/scsi/aic7xxx/aic79xx_pci.h
--- a/drivers/scsi/aic7xxx/aic79xx_pci.h
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.h
@@ -53,14 +53,15 @@
 #define ID_AHA_29320ALP			0x8017900500449005ull

 #define ID_AIC7901A			0x801E9005FFFF9005ull
-#define ID_AHA_29320			0x8012900500429005ull
-#define ID_AHA_29320B			0x8013900500439005ull
 #define ID_AHA_29320LP			0x8014900500449005ull

 #define ID_AIC7902			0x801F9005FFFF9005ull
 #define ID_AIC7902_B			0x801D9005FFFF9005ull
 #define ID_AHA_39320			0x8010900500409005ull
+#define ID_AHA_29320			0x8012900500429005ull
+#define ID_AHA_29320B			0x8013900500439005ull
 #define ID_AHA_39320_B			0x8015900500409005ull
+#define ID_AHA_39320_B_DELL		0x8015900501681028ull
 #define ID_AHA_39320A			0x8016900500409005ull
 #define ID_AHA_39320D			0x8011900500419005ull
 #define ID_AHA_39320D_B			0x801C900500419005ull
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c
b/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -3,7 +3,7 @@
  *      3940, 2940, aic7895, aic7890, aic7880,
  *	aic7870, aic7860 and aic7850 SCSI controllers
  *
- * Copyright (c) 1994-2001 Justin T. Gibbs.
+ * Copyright (c) 1994-2000 Justin T. Gibbs.
  * Copyright (c) 2000-2001 Adaptec Inc.
  * All rights reserved.
  *
@@ -39,9 +39,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#69 $
- *
- * $FreeBSD$
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#79 $
  */

 #ifdef __linux__
@@ -49,6 +47,8 @@
 #include "aic7xxx_inline.h"
 #include "aic7xxx_93cx6.h"
 #else
+#include <sys/cdefs.h>
+__FBSDID("$FreeBSD$");
 #include <dev/aic7xxx/aic7xxx_osm.h>
 #include <dev/aic7xxx/aic7xxx_inline.h>
 #include <dev/aic7xxx/aic7xxx_93cx6.h>
@@ -393,6 +393,12 @@ struct ahc_pci_identity ahc_pci_ident_ta
 		"Adaptec aic7892 Ultra160 SCSI adapter (ARO)",
 		ahc_aic7892_setup
 	},
+	{
+		ID_AHA_2915_30LP,
+		ID_ALL_MASK,
+		"Adaptec 2915/30LP Ultra160 SCSI adapter",
+		ahc_aic7892_setup
+	},
 	/* aic7895 based controllers */=09
 	{
 		ID_AHA_2940U_DUAL,
@@ -1193,9 +1199,19 @@ ahc_pci_test_register_access(struct ahc_
 	 * use for this test.
 	 */
 	hcntrl =3D ahc_inb(ahc, HCNTRL);
+
 	if (hcntrl =3D=3D 0xFF)
 		goto fail;

+	if ((hcntrl & CHIPRST) !=3D 0) {
+		/*
+		 * The chip has not been initialized since
+		 * PCI/EISA/VLB bus reset.  Don't trust
+		 * "left over BIOS data".
+		 */
+		ahc->flags |=3D AHC_NO_BIOS_INIT;
+	}
+
 	/*
 	 * Next create a situation where write combining
 	 * or read prefetching could be initiated by the
@@ -1307,6 +1323,10 @@ check_extport(struct ahc_softc *ahc, u_i
 			sd.sd_chip =3D C56_66;
 		}
 		ahc_release_seeprom(&sd);
+
+		/* Remember the SEEPROM type for later */
+		if (sd.sd_chip =3D=3D C56_66)
+			ahc->flags |=3D AHC_LARGE_SEEPROM;
 	}

 	if (!have_seeprom) {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.h
b/drivers/scsi/aic7xxx/aic7xxx_pci.h
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.h
@@ -105,6 +105,7 @@
 #define ID_AHA_29160C			0x0080900562209005ull
 #define ID_AHA_29160B			0x00809005E2209005ull
 #define ID_AHA_19160B			0x0081900562A19005ull
+#define ID_AHA_2915_30LP		0x0082900502109005ull

 #define ID_AIC7896			0x005F9005FFFF9005ull
 #define ID_AIC7896_ARO			0x00539005FFFF9005ull

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
