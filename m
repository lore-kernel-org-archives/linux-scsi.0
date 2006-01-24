From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] aic79xx: SLOWCRC fix
Date: Tue, 24 Jan 2006 10:44:38 +0100
Message-ID: <43D5F706.30009@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080301090903060303050500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:56255 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030429AbWAXJoj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 04:44:39 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 74EA0EB42
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 10:44:38 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080301090903060303050500
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch introduces the SLOWCRC handling for certain buggy chipsets.


--------------080301090903060303050500
Content-Type: text/plain;
 name="0003-aic79xx-slowcrc-fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-aic79xx-slowcrc-fix"

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#108 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#109 $
  *
  * $FreeBSD$
  */
@@ -222,6 +222,7 @@ typedef enum {
 typedef enum {
 	AHD_FENONE		= 0x00000,
 	AHD_WIDE  		= 0x00001,/* Wide Channel */
+	AHD_AIC79XXB_SLOWCRC    = 0x00002,/* SLOWCRC bit should be set */
 	AHD_MULTI_FUNC		= 0x00100,/* Multi-Function/Channel Device */
 	AHD_TARGETMODE		= 0x01000,/* Has tested target mode support */
 	AHD_MULTIROLE		= 0x02000,/* Space for two roles at a time */
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3332,6 +3332,15 @@ ahd_update_neg_table(struct ahd_softc *a
 		con_opts |= WIDEXFER;
 
 	/*
+	 * Slow down our CRC interval to be
+	 * compatible with packetized U320 devices
+	 * that can't handle a CRC at full speed
+	 */
+	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
+		con_opts |= ENSLOWCRC;
+	}
+
+	/*
 	 * During packetized transfers, the target will
 	 * give us the oportunity to send command packets
 	 * without us asserting attention.
@@ -6740,6 +6749,18 @@ ahd_chip_init(struct ahd_softc *ahd)
 
 	ahd_loadseq(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
+
+	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
+		u_int negodat3 = ahd_inb(ahd, NEGCONOPTS);
+
+		negodat3 |= ENSLOWCRC;
+		ahd_outb(ahd, NEGCONOPTS, negodat3);
+		negodat3 = ahd_inb(ahd, NEGCONOPTS);
+		if (!(negodat3 & ENSLOWCRC))
+			printf("aic79xx: failed to set the SLOWCRC bit\n");
+		else
+			printf("aic79xx: SLOWCRC bit set\n");
+	}
 }
 
 /*
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -314,6 +314,21 @@ static uint32_t aic79xx_seltime;
  */
 uint32_t aic79xx_periodic_otag;
 
+/* Some storage boxes are using an LSI chip which has a bug making it
+ * impossible to use aic79xx Rev B chip in 320 speeds.  The following
+ * storage boxes have been reported to be buggy:
+ * EonStor 3U 16-Bay: U16U-G3A3
+ * EonStor 2U 12-Bay: U12U-G3A3
+ * SentinelRAID: 2500F R5 / R6
+ * SentinelRAID: 2500F R1
+ * SentinelRAID: 2500F/1500F
+ * SentinelRAID: 150F
+ * 
+ * To get around this LSI bug, you can set your board to 160 mode
+ * or you can enable the SLOWCRC bit.
+ */
+uint32_t aic79xx_slowcrc;
+
 /*
  * Module information and settable options.
  */
@@ -343,6 +358,7 @@ MODULE_PARM_DESC(aic79xx,
 "	amplitude:<int>		Set the signal amplitude (0-7).\n"
 "	seltime:<int>		Selection Timeout:\n"
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
+"	slowcrc			Turn on the SLOWCRC bit (Rev B only)\n"		 
 "\n"
 "	Sample /etc/modprobe.conf line:\n"
 "		Enable verbose logging\n"
@@ -1003,6 +1019,7 @@ aic79xx_setup(char *s)
 		{ "slewrate", NULL },
 		{ "precomp", NULL },
 		{ "amplitude", NULL },
+		{ "slowcrc", &aic79xx_slowcrc },
 	};
 
 	end = strchr(s, '\0');
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -38,7 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#89 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#92 $
  */
 
 #ifdef __linux__
@@ -950,12 +950,19 @@ ahd_aic790X_setup(struct ahd_softc *ahd)
 		if ((ahd->flags & AHD_HP_BOARD) == 0)
 			AHD_SET_SLEWRATE(ahd, AHD_SLEWRATE_DEF_REVA);
 	} else {
+		/* This is revision B and newer. */
+		extern uint32_t aic79xx_slowcrc;
 		u_int devconfig1;
 
 		ahd->features |= AHD_RTI|AHD_NEW_IOCELL_OPTS
-			      |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY;
+			      |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY
+			      |  AHD_BUSFREEREV_BUG;
 		ahd->bugs |= AHD_LQOOVERRUN_BUG|AHD_EARLY_REQ_BUG;
 
+		/* If the user requested the the SLOWCRC bit to be set. */
+		if (aic79xx_slowcrc)
+			ahd->features |= AHD_AIC79XXB_SLOWCRC;
+
 		/*
 		 * Some issues have been resolved in the 7901B.
 		 */

--------------080301090903060303050500--
