From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 23/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:07:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4159620E.5090202@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:36043 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267772AbUI1NHf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:07:35 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7YW03307
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:34 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7Xm31361
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:33 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2789-3367)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/aic7xxx/aic79xx.c#239 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.27182.0	2004-09-27 13:36:04.580810160 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2004-03-29 11:31:10.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#239 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#242 $
   */

  #ifdef __linux__
@@ -1621,19 +1621,21 @@
  				       scbid);
  			}
  #endif
-			/*
-			 * Force a renegotiation with this target just in
-			 * case the cable was pulled and will later be
-			 * re-attached.  The target may forget its negotiation
-			 * settings with us should it attempt to reselect
-			 * during the interruption.  The target will not issue
-			 * a unit attention in this case, so we must always
-			 * renegotiate.
-			 */
  			ahd_scb_devinfo(ahd, &devinfo, scb);
-			ahd_force_renegotiation(ahd, &devinfo);
  			aic_set_transaction_status(scb, CAM_SEL_TIMEOUT);
  			ahd_freeze_devq(ahd, scb);
+
+			/*
+			 * Cancel any pending transactions on the device
+			 * now that it seems to be missing.  This will
+			 * also revert us to async/narrow transfers until
+			 * we can renegotiate with the device.
+			 */
+			ahd_handle_devreset(ahd, &devinfo,
+					    CAM_LUN_WILDCARD,
+					    CAM_SEL_TIMEOUT,
+					    "Selection Timeout",
+					    /*verbose_level*/0);
  		}
  		ahd_outb(ahd, CLRINT, CLRSCSIINT);
  		ahd_iocell_first_selection(ahd);
@@ -5067,10 +5069,12 @@
  	ahd_set_width(ahd, devinfo, MSG_EXT_WDTR_BUS_8_BIT,
  		      AHD_TRANS_CUR, /*paused*/TRUE);
  	ahd_set_syncrate(ahd, devinfo, /*period*/0, /*offset*/0,
-			 /*ppr_options*/0, AHD_TRANS_CUR, /*paused*/TRUE);
+			 /*ppr_options*/0, AHD_TRANS_CUR,
+			 /*paused*/TRUE);
  	
-	ahd_send_async(ahd, devinfo->channel, devinfo->target,
-		       lun, AC_SENT_BDR, NULL);
+	if (status != CAM_SEL_TIMEOUT)
+		ahd_send_async(ahd, devinfo->channel, devinfo->target,
+			       lun, AC_SENT_BDR, NULL);

  	if (message != NULL
  	 && (verbose_level <= bootverbose))
@@ -7066,35 +7070,21 @@
  	ahd_outw(ahd, KERNEL_QFREEZE_COUNT, ahd->qfreeze_cnt);
  	ahd_outb(ahd, SEQ_FLAGS2, ahd_inb(ahd, SEQ_FLAGS2) | SELECTOUT_QFROZEN);
  	do {
-		struct scb *waiting_scb;

  		ahd_unpause(ahd);
  		/*
  		 * Give the sequencer some time to service
  		 * any active selections.
  		 */
-		aic_delay(200);
+		aic_delay(500);

  		ahd_intr(ahd);
  		ahd_pause(ahd);
-		ahd_clear_critical_section(ahd);
  		intstat = ahd_inb(ahd, INTSTAT);
-		ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-		if ((ahd_inb(ahd, SSTAT0) & (SELDO|SELINGO)) == 0)
-			ahd_outb(ahd, SCSISEQ0,
-				 ahd_inb(ahd, SCSISEQ0) & ~ENSELO);
-		/*
-		 * In the non-packetized case, the sequencer (for Rev A),
-		 * relies on ENSELO remaining set after SELDO.  The hardware
-		 * auto-clears ENSELO in the packetized case.
-		 */
-		waiting_scb = ahd_lookup_scb(ahd,
-					     ahd_inw(ahd, WAITING_TID_HEAD));
-		if (waiting_scb != NULL
-		 && (waiting_scb->flags & SCB_PACKETIZED) == 0
-		 && (ahd_inb(ahd, SSTAT0) & (SELDO|SELINGO)) != 0)
-			ahd_outb(ahd, SCSISEQ0,
-				 ahd_inb(ahd, SCSISEQ0) | ENSELO);
+		if ((intstat & INT_PEND) == 0) {
+			ahd_clear_critical_section(ahd);
+			intstat = ahd_inb(ahd, INTSTAT);
+		}
  	} while (--maxloops
  	      && (intstat != 0xFF || (ahd->features & AHD_REMOVABLE) == 0)
  	      && ((intstat & INT_PEND) != 0
==== //depot/aic7xxx/aic7xxx/aic79xx_inline.h#56 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h ====
--- /tmp/tmp.27182.1	2004-09-27 13:36:04.735786600 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h	2004-03-18 16:16:43.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#56 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#57 $
   *
   * $FreeBSD$
   */
@@ -693,7 +693,7 @@
  	 * Razor #528
  	 */
  	value = ahd_inb(ahd, offset);
-	if ((ahd->flags & AHD_PCIX_SCBRAM_RD_BUG) != 0)
+	if ((ahd->bugs & AHD_PCIX_SCBRAM_RD_BUG) != 0)
  		ahd_inb(ahd, MODE_PTR);
  	return (value);
  }
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#205 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.27182.2	2004-09-27 13:36:05.411683848 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-03-16 23:57:55.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC79xx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#205 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#208 $
   *
   * --------------------------------------------------------------------------
   * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -459,14 +459,14 @@
  "	seltime:<int>		Selection Timeout:\n"
  "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
  "\n"
-"	Sample /etc/modules.conf line:\n"
+"	Sample module configuration line:\n"
  "		Enable verbose logging\n"
  "		Set tag depth on Controller 2/Target 2 to 10 tags\n"
  "		Shorten the selection timeout to 128ms\n"
  "\n"
  "	options aic79xx 'aic79xx=verbose.tag_info:{{}.{}.{..10}}.seltime:1'\n"
  "\n"
-"	Sample /etc/modules.conf line:\n"
+"	Sample module configuration line:\n"
  "		Change Read Streaming for Controller's 2 and 3\n"
  "\n"
  "	options aic79xx 'aic79xx=rd_strm:{..0xFFF0.0xC0F0}'");
@@ -4534,7 +4534,7 @@
  				continue;

  			if (TAILQ_EMPTY(&cur_dev->busyq)
-			 && dev->active == 0)
+			 && cur_dev->active == 0)
  				ahd_linux_free_device(ahd, cur_dev);
  		}
  		if (AIC_DV_CMD(cmd) == FALSE)
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#157 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.27182.3	2004-09-27 13:36:05.445678680 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-03-07 17:06:23.000000000 -0500
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#157 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#159 $
   *
   */
  #ifndef _AIC79XX_LINUX_H_
@@ -94,7 +94,7 @@
  #include <linux/smp.h>
  #endif

-#define AIC79XX_DRIVER_VERSION "2.0.6"
+#define AIC79XX_DRIVER_VERSION "2.0.8"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/aic7xxx/aic79xx_pci.c#86 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c ====
--- /tmp/tmp.27182.4	2004-09-27 13:36:05.591656488 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-03-07 17:05:41.000000000 -0500
@@ -38,7 +38,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#86 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#87 $
   */

  #ifdef __linux__
@@ -200,7 +200,7 @@
  	/* Generic chip probes for devices we don't know 'exactly' */
  	{
  		ID_AIC7901 & ID_9005_GENERIC_MASK,
-		ID_DEV_VENDOR_MASK,
+		ID_9005_GENERIC_MASK,
  		"Adaptec AIC7901 Ultra320 SCSI adapter",
  		ahd_aic7901_setup
  	},
==== //depot/aic7xxx/aic7xxx/aic7xxx.c#150 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c ====
--- /tmp/tmp.27182.5	2004-09-27 13:36:06.540512240 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c	2004-03-29 11:30:28.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#150 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#153 $
   */

  #ifdef __linux__
@@ -1187,19 +1187,20 @@
  				       scb_index);
  			}
  #endif
-			/*
-			 * Force a renegotiation with this target just in
-			 * case the cable was pulled and will later be
-			 * re-attached.  The target may forget its negotiation
-			 * settings with us should it attempt to reselect
-			 * during the interruption.  The target will not issue
-			 * a unit attention in this case, so we must always
-			 * renegotiate.
-			 */
  			ahc_scb_devinfo(ahc, &devinfo, scb);
-			ahc_force_renegotiation(ahc, &devinfo);
  			aic_set_transaction_status(scb, CAM_SEL_TIMEOUT);
  			ahc_freeze_devq(ahc, scb);
+
+			/*
+			 * Cancel any pending transactions on the device
+			 * now that it seems to be missing.  This will
+			 * also revert us to async/narrow transfers until
+			 * we can renegotiate with the device.
+			 */
+			ahc_handle_devreset(ahc, &devinfo,
+					    CAM_SEL_TIMEOUT,
+					    "Selection Timeout",
+					    /*verbose_level*/0);
  		}
  		ahc_outb(ahc, CLRINT, CLRSCSIINT);
  		ahc_restart(ahc);
@@ -3776,8 +3777,9 @@
  			 /*period*/0, /*offset*/0, /*ppr_options*/0,
  			 AHC_TRANS_CUR, /*paused*/TRUE);
  	
-	ahc_send_async(ahc, devinfo->channel, devinfo->target,
-		       CAM_LUN_WILDCARD, AC_SENT_BDR, NULL);
+	if (status != CAM_SEL_TIMEOUT)
+		ahc_send_async(ahc, devinfo->channel, devinfo->target,
+			       CAM_LUN_WILDCARD, AC_SENT_BDR, NULL);

  	if (message != NULL
  	 && (verbose_level <= bootverbose))
@@ -5128,14 +5130,17 @@
  			 * Give the sequencer some time to service
  			 * any active selections.
  			 */
-			aic_delay(200);
+			aic_delay(500);
  		}
  		ahc_intr(ahc);
  		ahc_pause(ahc);
  		paused = TRUE;
  		ahc_outb(ahc, SCSISEQ, ahc_inb(ahc, SCSISEQ) & ~ENSELO);
-		ahc_clear_critical_section(ahc);
  		intstat = ahc_inb(ahc, INTSTAT);
+		if ((intstat & INT_PEND) == 0) {
+			ahc_clear_critical_section(ahc);
+			intstat = ahc_inb(ahc, INTSTAT);
+		}
  	} while (--maxloops
  	      && (intstat != 0xFF || (ahc->features & AHC_REMOVABLE) == 0)
  	      && ((intstat & INT_PEND) != 0
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#268 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.27182.6	2004-09-27 13:36:07.281399608 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-03-16 23:45:31.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#268 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#270 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -477,7 +477,7 @@
  "	seltime:<int>		Selection Timeout\n"
  "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
  "\n"
-"	Sample /etc/modules.conf line:\n"
+"	Sample module configuration line:\n"
  "		Toggle EISA/VLB probing\n"
  "		Set tag depth on Controller 1/Target 1 to 10 tags\n"
  "		Shorten the selection timeout to 128ms\n"
@@ -4249,7 +4249,7 @@
  				continue;

  			if (TAILQ_EMPTY(&cur_dev->busyq)
-			 && dev->active == 0)
+			 && cur_dev->active == 0)
  				ahc_linux_free_device(ahc, cur_dev);
  		}
  		if (AIC_DV_CMD(cmd) == FALSE)
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#169 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.27182.7	2004-09-27 13:36:07.462372096 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-02-24 20:21:36.000000000 -0500
@@ -53,7 +53,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#169 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#170 $
   *
   */
  #ifndef _AIC7XXX_LINUX_H_
@@ -113,7 +113,7 @@
  #include <linux/smp.h>
  #endif

-#define AIC7XXX_DRIVER_VERSION "6.3.5"
+#define AIC7XXX_DRIVER_VERSION "6.3.6"

  /********************* Definitions Required by the Core ***********************/
  /*


