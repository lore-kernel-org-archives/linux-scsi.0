From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 25/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:07:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4159621A.6080000@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:40907 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267785AbUI1NHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:07:47 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7kW03349
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:46 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7jm31389
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:46 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (3707-4030)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic79xx#5 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx ====
--- /tmp/tmp.27244.0	2004-09-27 13:37:40.415241112 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx	2004-08-03 13:58:02.000000000 -0400
@@ -1,6 +1,6 @@
  #
  # AIC79XX 2.5.X Kernel configuration File.
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic79xx#5 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic79xx#6 $
  #
  config SCSI_AIC79XX
  	tristate "Adaptec AIC79xx U320 support"
@@ -46,7 +46,7 @@

  config AIC79XX_BUILD_FIRMWARE
  	bool "Build Adapter Firmware with Kernel Build"
-	depends on SCSI_AIC79XX
+	depends on SCSI_AIC79XX && !PREVENT_FIRMWARE_BUILD
  	help
  	This option should only be enabled if you are modifying the firmware
  	source to the aic79xx driver and wish to have the generated firmware
==== //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#9 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx ====
--- /tmp/tmp.27244.1	2004-09-27 13:37:40.444236704 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx	2004-08-03 13:57:59.000000000 -0400
@@ -1,6 +1,6 @@
  #
  # AIC7XXX and AIC79XX 2.5.X Kernel configuration File.
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#9 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#10 $
  #
  config SCSI_AIC7XXX
  	tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
@@ -58,7 +58,7 @@

  config AIC7XXX_BUILD_FIRMWARE
  	bool "Build Adapter Firmware with Kernel Build"
-	depends on SCSI_AIC7XXX
+	depends on SCSI_AIC7XXX && !PREVENT_FIRMWARE_BUILD
  	help
  	This option should only be enabled if you are modifying the firmware
  	source to the aic7xxx driver and wish to have the generated firmware
==== //depot/aic7xxx/aic7xxx/aic7770.c#34 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770.c ====
--- /tmp/tmp.27244.2	2004-09-27 13:37:40.732192928 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770.c	2004-05-13 13:37:20.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7770.c#34 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7770.c#35 $
   */

  #ifdef __linux__
@@ -64,7 +64,7 @@
  static int aic7770_resume(struct ahc_softc *ahc);
  static int aha2840_load_seeprom(struct ahc_softc *ahc);
  static ahc_device_setup_t ahc_aic7770_VL_setup;
-static ahc_device_setup_t ahc_aic7770_EISA_setup;;
+static ahc_device_setup_t ahc_aic7770_EISA_setup;
  static ahc_device_setup_t ahc_aic7770_setup;

  struct aic7770_identity aic7770_ident_table[] =
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#19 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c ====
--- /tmp/tmp.27244.3	2004-09-27 13:37:40.789184264 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c	2004-05-13 15:04:01.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#19 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#20 $
   */

  #include "aic7xxx_osm.h"
@@ -151,10 +151,8 @@
  ahc_linux_eisa_exit(void)
  {
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	if (aic7xxx_probe_eisa_vl == 0)
-		return;
-
-	if (aic7770_driver.id_table != NULL) {
+	if (aic7xxx_probe_eisa_vl != 0
+	 && aic7770_driver.id_table != NULL) {
  		eisa_driver_unregister(&aic7770_driver);
  		free(aic7770_driver.id_table, M_DEVBUF);
  	}
==== //depot/aic7xxx/aic7xxx/aic79xx.h#107 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.h ====
--- /tmp/tmp.27244.4	2004-09-27 13:37:41.639055064 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.h	2004-05-11 19:06:44.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Core definitions and data structures shareable across OS platforms.
   *
- * Copyright (c) 1994-2002 Justin T. Gibbs.
+ * Copyright (c) 1994-2001 Justin T. Gibbs.
   * Copyright (c) 2000-2002 Adaptec Inc.
   * All rights reserved.
   *
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#107 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#108 $
   *
   * $FreeBSD$
   */
==== //depot/aic7xxx/aic7xxx/aic79xx.c#245 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.27244.5	2004-09-27 13:37:44.777577936 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2004-05-22 15:25:49.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#245 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#247 $
   */

  #ifdef __linux__
@@ -1551,9 +1551,6 @@
  	 && (ahd_inb(ahd, SEQ_FLAGS) & NOT_IDENTIFIED) != 0)
  		scb = NULL;

-	/* Make sure the sequencer is in a safe location. */
-	ahd_clear_critical_section(ahd);
-
  	if ((status0 & IOERR) != 0) {
  		u_int now_lvd;

@@ -1569,26 +1566,35 @@
  		ahd_setup_iocell_workaround(ahd);
  		ahd_unpause(ahd);
  	} else if ((status0 & OVERRUN) != 0) {
+
  		printf("%s: SCSI offset overrun detected.  Resetting bus.\n",
  		       ahd_name(ahd));
  		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
  	} else if ((status & SCSIRSTI) != 0) {
+
  		printf("%s: Someone reset channel A\n", ahd_name(ahd));
  		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/FALSE);
  	} else if ((status & SCSIPERR) != 0) {
+
+		/* Make sure the sequencer is in a safe location. */
+		ahd_clear_critical_section(ahd);
+
  		ahd_handle_transmission_error(ahd);
  	} else if (lqostat0 != 0) {
+
  		printf("%s: lqostat0 == 0x%x!\n", ahd_name(ahd), lqostat0);
  		ahd_outb(ahd, CLRLQOINT0, lqostat0);
-		if ((ahd->bugs & AHD_CLRLQO_AUTOCLR_BUG) != 0) {
+		if ((ahd->bugs & AHD_CLRLQO_AUTOCLR_BUG) != 0)
  			ahd_outb(ahd, CLRLQOINT1, 0);
-		}
  	} else if ((status & SELTO) != 0) {
  		u_int  scbid;

  		/* Stop the selection */
  		ahd_outb(ahd, SCSISEQ0, 0);

+		/* Make sure the sequencer is in a safe location. */
+		ahd_clear_critical_section(ahd);
+
  		/* No more pending messages */
  		ahd_clear_msg_state(ahd);

@@ -1641,6 +1647,7 @@
  		ahd_iocell_first_selection(ahd);
  		ahd_unpause(ahd);
  	} else if ((status0 & (SELDI|SELDO)) != 0) {
+
  		ahd_iocell_first_selection(ahd);
  		ahd_unpause(ahd);
  	} else if (status3 != 0) {
@@ -1648,6 +1655,10 @@
  		       ahd_name(ahd), status3);
  		ahd_outb(ahd, CLRSINT3, status3);
  	} else if ((lqistat1 & (LQIPHASE_LQ|LQIPHASE_NLQ)) != 0) {
+
+		/* Make sure the sequencer is in a safe location. */
+		ahd_clear_critical_section(ahd);
+
  		ahd_handle_lqiphase_error(ahd, lqistat1);
  	} else if ((lqistat1 & LQICRCI_NLQ) != 0) {
  		/*
@@ -1672,6 +1683,9 @@
  		 */
  		ahd_outb(ahd, SCSISEQ0, 0);

+		/* Make sure the sequencer is in a safe location. */
+		ahd_clear_critical_section(ahd);
+
  		/*
  		 * Determine what we were up to at the time of
  		 * the busfree.
@@ -1710,6 +1724,7 @@
  			packetized =  (lqostat1 & LQOBUSFREE) != 0;
  			if (!packetized
  			 && ahd_inb(ahd, LASTPHASE) == P_BUSFREE
+			 && (ahd_inb(ahd, SSTAT0) & SELDI) == 0
  			 && ((ahd_inb(ahd, SSTAT0) & SELDO) == 0
  			  || (ahd_inb(ahd, SCSISEQ0) & ENSELO) == 0))
  				/*
@@ -3359,11 +3374,15 @@
  	 * Force the sequencer to reinitialize the selection for
  	 * the command at the head of the execution queue if it
  	 * has already been setup.  The negotiation changes may
-	 * effect whether we select-out with ATN.
+	 * effect whether we select-out with ATN.  It is only
+	 * safe to clear ENSELO when the bus is not free and no
+	 * selection is in progres or completed.
  	 */
  	saved_modes = ahd_save_modes(ahd);
  	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-	ahd_outb(ahd, SCSISEQ0, ahd_inb(ahd, SCSISEQ0) & ~ENSELO);
+	if ((ahd_inb(ahd, SCSISIGI) & BSYI) != 0
+	 && (ahd_inb(ahd, SSTAT0) & (SELDO|SELINGO)) == 0)
+		ahd_outb(ahd, SCSISEQ0, ahd_inb(ahd, SCSISEQ0) & ~ENSELO);
  	saved_scbptr = ahd_get_scbptr(ahd);
  	/* Ensure that the hscbs down on the card match the new information */
  	for (scb_tag = 0; scb_tag < ahd->scb_data.maxhscbs; scb_tag++) {
@@ -6104,9 +6123,6 @@
  	newcount = MIN(scb_data->sense_left, scb_data->scbs_left);
  	newcount = MIN(newcount, scb_data->sgs_left);
  	newcount = MIN(newcount, (AHD_SCB_MAX_ALLOC - scb_data->numscbs));
-	scb_data->sense_left -= newcount;
-	scb_data->scbs_left -= newcount;
-	scb_data->sgs_left -= newcount;
  	for (i = 0; i < newcount; i++) {
  		struct scb_platform_data *pdata;
  		u_int col_tag;
@@ -6170,6 +6186,9 @@
  		sense_data += AHD_SENSE_BUFSIZE;
  		sense_busaddr += AHD_SENSE_BUFSIZE;
  		scb_data->numscbs++;
+		scb_data->sense_left--;
+		scb_data->scbs_left--;
+		scb_data->sgs_left--;
  	}
  }

==== //depot/aic7xxx/aic7xxx/aic79xx_inline.h#57 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h ====
--- /tmp/tmp.27244.6	2004-09-27 13:37:45.013542064 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h	2004-05-07 18:02:40.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#57 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#58 $
   *
   * $FreeBSD$
   */
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#209 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.27244.7	2004-09-27 13:37:46.367336256 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-07-30 16:47:03.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC79xx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#209 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#213 $
   *
   * --------------------------------------------------------------------------
   * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -430,7 +430,7 @@
   */
  static char dummy_buffer[60] = "Please don't trounce on me insmod!!\n";

-MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
+MODULE_AUTHOR("Maintainer: Luben Tuikov <luben_tuikov@adaptec.com>");
  MODULE_DESCRIPTION("Adaptec Aic790X U320 SCSI Host Bus Adapter driver");
  #ifdef MODULE_LICENSE
  MODULE_LICENSE("Dual BSD/GPL");
@@ -778,6 +778,7 @@
  	sprintf(current->comm, "ahd_recovery_%d", ahd->unit);
  #else
  	daemonize("ahd_recovery_%d", ahd->unit);
+	current->flags |= PF_FREEZE;
  #endif
  	unlock_kernel();

@@ -968,11 +969,9 @@
  	 */
  	ahd_list_lockinit();

-#ifdef CONFIG_PCI
  	ahd_init_status = ahd_linux_pci_init();
  	if (ahd_init_status != 0)
  		goto done;
-#endif

  	/*
  	 * Register with the SCSI layer all
@@ -2022,6 +2021,7 @@
  	host->max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
  	host->max_lun = AHD_NUM_LUNS;
  	host->max_channel = 0;
+	host->max_cmd_len = MAX_CDB_LEN;
  	host->sg_tablesize = AHD_NSEG;
  	ahd_set_unit(ahd, ahd_linux_next_unit());
  	sprintf(buf, "scsi%d", host->host_no);
@@ -2543,6 +2543,7 @@
  	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
  #else
  	daemonize("ahd_dv_%d", ahd->unit);
+	current->flags |= PF_FREEZE;
  #endif
  	unlock_kernel();

@@ -4071,10 +4072,11 @@

  		if ((dev->flags & (AIC_DEV_Q_TAGGED|AIC_DEV_Q_BASIC)) != 0) {
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-			int	msg_bytes;
+			int	msg_bytes = 0;
  			uint8_t tag_msgs[2];

-			msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
+			if (cmd->request)
+				msg_bytes =scsi_populate_tag_msg(cmd,tag_msgs);
  			if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
  				hscb->control |= tag_msgs[0];
  				if (tag_msgs[0] == MSG_ORDERED_TASK)
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#161 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.27244.8	2004-09-27 13:37:46.468320904 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-07-22 14:34:04.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#161 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#164 $
   *
   */
  #ifndef _AIC79XX_LINUX_H_
@@ -94,7 +94,7 @@
  #include <linux/smp.h>
  #endif

-#define AIC79XX_DRIVER_VERSION "2.0.10"
+#define AIC79XX_DRIVER_VERSION "2.0.13"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/aic7xxx/aic79xx_pci.c#88 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c ====
--- /tmp/tmp.27244.9	2004-09-27 13:37:46.704285032 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-05-11 18:55:47.000000000 -0400
@@ -2,7 +2,7 @@
   * Product specific probe and attach routines for:
   *	aic7901 and aic7902 SCSI controllers
   *
- * Copyright (c) 1994-2001 Justin T. Gibbs.
+ * Copyright (c) 1994-2000 Justin T. Gibbs.
   * Copyright (c) 2000-2002 Adaptec Inc.
   * All rights reserved.
   *
@@ -38,7 +38,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#88 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#89 $
   */

  #ifdef __linux__
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_reg.h#86 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped ====
--- /tmp/tmp.27244.10	2004-09-27 13:37:47.385181520 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped	2004-05-07 17:34:28.000000000 -0400
@@ -2,8 +2,8 @@
   * DO NOT EDIT - This file is automatically generated
   *		 from the following source files:
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#118 $
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#75 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#119 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#76 $
   */
  typedef int (ahd_reg_print_t)(u_int, u_int *, u_int);
  typedef struct ahd_reg_parse_entry {
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_seq.h#87 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped ====
--- /tmp/tmp.27244.11	2004-09-27 13:37:47.530159480 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	2004-05-07 17:34:28.000000000 -0400
@@ -2,8 +2,8 @@
   * DO NOT EDIT - This file is automatically generated
   *		 from the following source files:
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#118 $
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#75 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#119 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#76 $
   */
  static uint8_t seqprog[] = {
  	0xff, 0x02, 0x06, 0x78,
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#271 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.27244.12	2004-09-27 13:37:48.399027392 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-07-22 16:11:05.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#271 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#276 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -450,7 +450,7 @@
   */
  static char dummy_buffer[60] = "Please don't trounce on me insmod!!\n";

-MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
+MODULE_AUTHOR("Maintainer: Luben Tuikov <luben_tuikov@adaptec.com>");
  MODULE_DESCRIPTION("Adaptec Aic77XX/78XX SCSI Host Bus Adapter driver");
  #ifdef MODULE_LICENSE
  MODULE_LICENSE("Dual BSD/GPL");
@@ -793,6 +793,7 @@
  	sprintf(current->comm, "ahc_recovery_%d", ahc->unit);
  #else
  	daemonize("ahc_recovery_%d", ahc->unit);
+	current->flags |= PF_FREEZE;
  #endif
  	unlock_kernel();

@@ -979,23 +980,18 @@
  	 */
  	ahc_list_lockinit();

-#ifdef CONFIG_PCI
  	ahc_init_status = ahc_linux_pci_init();
  	if (ahc_init_status != 0)
  		goto done;
-#endif

-#ifdef CONFIG_EISA
  	ahc_init_status = ahc_linux_eisa_init();
  	if (ahc_init_status != 0)
  		goto done;
-#endif

  	/*
  	 * Register with the SCSI layer all
  	 * controllers we've found.
  	 */
-	found = 0;
  	TAILQ_FOREACH(ahc, &ahc_tailq, links) {

  		if (ahc_linux_register_host(ahc, template) == 0)
@@ -1672,6 +1668,7 @@
  	host->max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
  	host->max_lun = AHC_NUM_LUNS;
  	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
+	host->max_cmd_len = MAX_CDB_LEN;
  	host->sg_tablesize = AHC_NSEG;
  	ahc_set_unit(ahc, ahc_linux_next_unit());
  	sprintf(buf, "scsi%d", host->host_no);
@@ -2265,6 +2262,7 @@
  	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
  #else
  	daemonize("ahc_dv_%d", ahc->unit);
+	current->flags |= PF_FREEZE;
  #endif
  	unlock_kernel();

@@ -5303,12 +5301,8 @@
  	 */
  	scsi_unregister_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
  #endif
-#ifdef CONFIG_PCI
  	ahc_linux_pci_exit();
-#endif
-#ifdef CONFIG_EISA
  	ahc_linux_eisa_exit();
-#endif
  	aic_remove_sysrq(ahc_sysrq_key, &ahc_sysrq_op);
  }

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#172 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.27244.13	2004-09-27 13:37:48.475015840 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-07-22 14:34:29.000000000 -0400
@@ -53,7 +53,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#172 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#176 $
   *
   */
  #ifndef _AIC7XXX_LINUX_H_
@@ -113,7 +113,7 @@
  #include <linux/smp.h>
  #endif

-#define AIC7XXX_DRIVER_VERSION "6.3.8"
+#define AIC7XXX_DRIVER_VERSION "6.3.10"

  /********************* Definitions Required by the Core ***********************/
  /*
@@ -255,6 +255,9 @@
  int			 aic7770_map_registers(struct ahc_softc *ahc,
  					       u_int port);
  int			 aic7770_map_int(struct ahc_softc *ahc, u_int irq);
+#else
+#define	ahc_linux_eisa_init() (0)
+#define	ahc_linux_eisa_exit() while(0)
  #endif

  /******************************* PCI Routines *********************************/
@@ -263,6 +266,9 @@
  void			 ahc_linux_pci_exit(void);
  int			 ahc_pci_map_registers(struct ahc_softc *ahc);
  int			 ahc_pci_map_int(struct ahc_softc *ahc);
+#else
+#define	ahc_linux_pci_init() (0)
+#define	ahc_linux_pci_exit() while(0)
  #endif

  /**************************** Proc FS Support *********************************/
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#56 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c ====
--- /tmp/tmp.27244.14	2004-09-27 13:37:48.514009912 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-05-22 15:19:50.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#56 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#57 $
   */

  #include "aic7xxx_osm.h"
@@ -321,11 +321,12 @@
  	if (maddr == NULL) {

  		error = ahc_linux_pci_reserve_io_region(ahc, &base);
+		ahc->tag = BUS_SPACE_PIO;
+		ahc->bsh.ioport = base;
  		if (error == 0 && ahc_pci_test_register_access(ahc) == 0) {
-			ahc->tag = BUS_SPACE_PIO;
-			ahc->bsh.ioport = base;
  			command |= PCIM_CMD_PORTEN;
  		} else {
+			ahc->bsh.ioport = 0;
  			printf("aic7xxx: PCI%d:%d:%d IO region 0x%lx[0..255] "
  			       "unavailable. Cannot map device.\n",
  			       aic_get_pci_bus(ahc->dev_softc),
==== //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#78 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c ====
--- /tmp/tmp.27244.15	2004-09-27 13:37:48.982938624 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c	2004-05-11 18:55:33.000000000 -0400
@@ -3,7 +3,7 @@
   *      3940, 2940, aic7895, aic7890, aic7880,
   *	aic7870, aic7860 and aic7850 SCSI controllers
   *
- * Copyright (c) 1994-2001 Justin T. Gibbs.
+ * Copyright (c) 1994-2000 Justin T. Gibbs.
   * Copyright (c) 2000-2001 Adaptec Inc.
   * All rights reserved.
   *
@@ -39,7 +39,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#78 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#79 $
   */

  #ifdef __linux__
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.c#17 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c ====
--- /tmp/tmp.27244.16	2004-09-27 13:37:49.591846056 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c	2004-05-13 17:48:52.000000000 -0400
@@ -1519,8 +1519,10 @@
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  	aic_set_dma_mask(aic, aic->platform_data->hw_dma_mask);
  #endif
-	if (*vaddr == NULL)
+	if (*vaddr == NULL) {
+		free(map, M_DEVBUF);
  		return (ENOMEM);
+	}
  	*mapp = map;
  	return(0);
  }
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.h#38 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h ====
--- /tmp/tmp.27244.17	2004-09-27 13:37:50.120765648 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h	2004-07-22 15:53:05.000000000 -0400
@@ -76,7 +76,11 @@
  #include <linux/blkdev.h>

  #include "scsi.h"
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,6)
+#include <scsi/scsi_host.h>
+#else
  #include "hosts.h"
+#endif

  /* Name space conflict with BSD queue macros */
  #ifdef LIST_HEAD


