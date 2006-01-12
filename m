From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] [Resend] aic7xxx: New device ids
Date: Thu, 12 Jan 2006 12:04:28 +0100
Message-ID: <43C637BC.3090007@suse.de>
References: <ISX88H$7860D422B0F4A207532BB4F4448FF0FD@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000004030103070606000901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:988 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932169AbWALLEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 06:04:30 -0500
In-Reply-To: <ISX88H$7860D422B0F4A207532BB4F4448FF0FD@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "emmanuel.fuste" <emmanuel.fuste@laposte.net>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>

This is a multi-part message in MIME format.
--------------000004030103070606000901
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Add new device ids to aic7xxx and aic79xx.


--------------000004030103070606000901
Content-Type: text/plain;
 name="0001-aic7xxx-New-device-ids.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-aic7xxx-New-device-ids.txt"

[PATCH 1/4] aic7xxx: New device ids

Add new device ids to aic7xxx and aic79xx.
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |   24 +++++++++++++++---------
 drivers/scsi/aic7xxx/aic79xx_pci.h |    5 +++--
 drivers/scsi/aic7xxx/aic7xxx_pci.c |   24 +++++++++++++++++++++---
 drivers/scsi/aic7xxx/aic7xxx_pci.h |    1 +
 4 files changed, 40 insertions(+), 14 deletions(-)

b37c1ce0342c9d62cc2d318c14e2a29b3400cc67
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -38,9 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#77 $
- *
- * $FreeBSD$
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#89 $
  */
 
 #ifdef __linux__
@@ -114,6 +112,13 @@ struct ahd_pci_identity ahd_pci_ident_ta
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
 	/* aic7902 based controllers */	
 	{
 		ID_AHA_29320,
@@ -128,12 +133,6 @@ struct ahd_pci_identity ahd_pci_ident_ta
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
@@ -146,6 +145,12 @@ struct ahd_pci_identity ahd_pci_ident_ta
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
@@ -668,6 +673,7 @@ ahd_configure_termination(struct ahd_sof
 	 * Now set the termination based on what we found.
 	 */
 	sxfrctl1 = ahd_inb(ahd, SXFRCTL1) & ~STPWEN;
+	ahd->flags &= ~AHD_TERM_ENB_A;
 	if ((termctl & FLX_TERMCTL_ENPRILOW) != 0) {
 		ahd->flags |= AHD_TERM_ENB_A;
 		sxfrctl1 |= STPWEN;
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.h b/drivers/scsi/aic7xxx/aic79xx_pci.h
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
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
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
@@ -393,6 +391,12 @@ struct ahc_pci_identity ahc_pci_ident_ta
 		"Adaptec aic7892 Ultra160 SCSI adapter (ARO)",
 		ahc_aic7892_setup
 	},
+	{
+		ID_AHA_2915_30LP,
+		ID_ALL_MASK,
+		"Adaptec 2915/30LP Ultra160 SCSI adapter",
+		ahc_aic7892_setup
+	},
 	/* aic7895 based controllers */	
 	{
 		ID_AHA_2940U_DUAL,
@@ -1193,9 +1197,19 @@ ahc_pci_test_register_access(struct ahc_
 	 * use for this test.
 	 */
 	hcntrl = ahc_inb(ahc, HCNTRL);
+
 	if (hcntrl == 0xFF)
 		goto fail;
 
+	if ((hcntrl & CHIPRST) != 0) {
+		/*
+		 * The chip has not been initialized since
+		 * PCI/EISA/VLB bus reset.  Don't trust
+		 * "left over BIOS data".
+		 */
+		ahc->flags |= AHC_NO_BIOS_INIT;
+	}
+
 	/*
 	 * Next create a situation where write combining
 	 * or read prefetching could be initiated by the
@@ -1307,6 +1321,10 @@ check_extport(struct ahc_softc *ahc, u_i
 			sd.sd_chip = C56_66;
 		}
 		ahc_release_seeprom(&sd);
+
+		/* Remember the SEEPROM type for later */
+		if (sd.sd_chip == C56_66)
+			ahc->flags |= AHC_LARGE_SEEPROM;
 	}
 
 	if (!have_seeprom) {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.h b/drivers/scsi/aic7xxx/aic7xxx_pci.h
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.h
@@ -105,6 +105,7 @@
 #define ID_AHA_29160C			0x0080900562209005ull
 #define ID_AHA_29160B			0x00809005E2209005ull
 #define ID_AHA_19160B			0x0081900562A19005ull
+#define ID_AHA_2915_30LP		0x0082900502109005ull
 
 #define ID_AIC7896			0x005F9005FFFF9005ull
 #define ID_AIC7896_ARO			0x00539005FFFF9005ull

--------------000004030103070606000901--
