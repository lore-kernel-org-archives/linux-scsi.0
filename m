From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 22/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:07:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596209.6040209@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:32971 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267769AbUI1NH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:07:29 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7SW03276
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:28 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7Sm31343
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:28 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2686-2789)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic79xx#4 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx ====
--- /tmp/tmp.27147.0	2004-09-27 13:35:28.007370168 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx	2004-02-09 12:10:50.000000000 -0500
@@ -1,10 +1,10 @@
  #
  # AIC79XX 2.5.X Kernel configuration File.
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic79xx#4 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic79xx#5 $
  #
  config SCSI_AIC79XX
  	tristate "Adaptec AIC79xx U320 support"
-	depends on PCI
+	depends on PCI && SCSI
  	help
  	This driver supports all of Adaptec's Ultra 320 PCI-X
  	based SCSI controllers.
==== //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#8 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx ====
--- /tmp/tmp.27147.1	2004-09-27 13:35:28.047364088 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx	2004-02-09 12:10:57.000000000 -0500
@@ -1,10 +1,10 @@
  #
  # AIC7XXX and AIC79XX 2.5.X Kernel configuration File.
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#8 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#9 $
  #
  config SCSI_AIC7XXX
  	tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
-	depends on PCI || EISA
+	depends on (PCI || EISA) && SCSI
  	---help---
  	This driver supports all of Adaptec's Fast through Ultra 160 PCI
  	based SCSI controllers as well as the aic7770 based EISA and VLB
==== //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#8 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Makefile ====
--- /tmp/tmp.27147.2	2004-09-27 13:35:28.051363480 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Makefile	2004-02-09 17:52:19.000000000 -0500
@@ -1,7 +1,7 @@
  #
  # Makefile for the Linux aic7xxx SCSI driver.
  #
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#8 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#9 $
  #

  # Let kbuild descend into aicasm when cleaning
==== //depot/aic7xxx/aic7xxx/aic79xx.c#238 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.27147.3	2004-09-27 13:35:29.495143992 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2004-02-12 15:11:43.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#238 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#239 $
   */

  #ifdef __linux__
@@ -338,6 +338,14 @@
  	ahd_outb(ahd, SCSISEQ1,
  		 ahd_inb(ahd, SCSISEQ_TEMPLATE) & (ENSELI|ENRSELI|ENAUTOATNP));
  	ahd_set_modes(ahd, AHD_MODE_CCHAN, AHD_MODE_CCHAN);
+
+	/*
+	 * Clear any pending sequencer interrupt.  It is no
+	 * longer relevant since we're resetting the Program
+	 * Counter.
+	 */
+	ahd_outb(ahd, CLRINT, CLRSEQINT);
+
  	ahd_outb(ahd, SEQCTL0, FASTMODE|SEQRESET);
  	ahd_unpause(ahd);
  }
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#200 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.27147.4	2004-09-27 13:35:30.097052488 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-02-22 13:26:49.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC79xx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#200 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#205 $
   *
   * --------------------------------------------------------------------------
   * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -480,8 +480,9 @@
  static void ahd_linux_filter_inquiry(struct ahd_softc *ahd,
  				     struct ahd_devinfo *devinfo);
  static int __init ahd_linux_init(void);
-static void __exit ahd_linux_exit(void);
+static void ahd_linux_exit(void);
  static void ahd_linux_dev_timed_unfreeze(u_long arg);
+static void ahd_linux_targ_timed_unfreeze(u_long arg);
  static void ahd_linux_sem_timeout(u_long arg);
  static void ahd_linux_initialize_scsi_bus(struct ahd_softc *ahd);
  static void ahd_linux_size_nseg(void);
@@ -1101,6 +1102,17 @@
  		printf("%s: aic79xx_linux_queue - Unable to allocate device!\n",
  		       ahd_name(ahd));
  		return (0);
+	} else if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
+		&& cmd->device->type != -1) {
+		/*
+		 * Configure devices that have already successfully
+		 * completed an inquiry. This  handles the case of
+		 * devices being destroyed due to transient selection
+		 * timeouts.
+		 */
+		dev->flags &= ~AIC_DEV_UNCONFIGURED;
+	 	dev->scsi_device = cmd->device;
+		aic_linux_device_queue_depth(ahd, dev);
  	}

  	if (cmd->cmd_len > MAX_CDB_LEN) {
@@ -2026,7 +2038,6 @@
  	ahd_linux_setup_user_rd_strm_settings(ahd);
  	ahd_linux_initialize_scsi_bus(ahd);
  	ahd_unlock(ahd, &s);
-	ahd_sysrq_key = aic_install_sysrq(&ahd_sysrq_op);
  	ahd_spawn_recovery_thread(ahd);
  	if (ahd->platform_data->recovery_pid < 0) {
  		printf("%s: Failed to create recovery thread, error= %d\n",
@@ -2190,7 +2201,6 @@
  	struct aic_linux_device *dev;
  	int i, j;

-	aic_remove_sysrq(ahd_sysrq_key, &ahd_sysrq_op);
  	if (ahd->platform_data != NULL) {
  		del_timer_sync(&ahd->platform_data->completeq_timer);
  		ahd_linux_kill_dv_thread(ahd);
@@ -2208,7 +2218,19 @@
  		for (i = 0; i < AHD_NUM_TARGETS; i++) {
  			targ = ahd->platform_data->targets[i];
  			if (targ != NULL) {
-				/* Keep target around through the loop. */
+
+				/*
+				 * Stop any unfreeze timer from running.
+				 */
+				del_timer_sync(&targ->timer);
+
+				/*
+				 * Keep target around through the loop.
+				 * The timer above may also have held
+				 * a refcount, but since we forcibly
+				 * delete the target, we don't care
+				 * about the extra reference.
+				 */
  				targ->refcount++;
  				for (j = 0; j < AHD_NUM_LUNS; j++) {

@@ -3955,7 +3977,8 @@
  		panic("running device on run list");

  	while ((acmd = TAILQ_FIRST(&dev->busyq)) != NULL
-	    && dev->openings > 0 && dev->qfrozen == 0) {
+	    && dev->openings > 0 && dev->qfrozen == 0
+	    && dev->target->qfrozen == 0) {

  		/*
  		 * Schedule us to run later.  The only reason we are not
@@ -4170,6 +4193,7 @@
  	targ->target = target;
  	targ->softc = ahd;
  	targ->flags = AIC_DV_REQUIRED;
+	init_timer(&targ->timer);
  	ahd->platform_data->targets[target] = targ;
  	return (targ);
  }
@@ -4250,7 +4274,6 @@
  {
  	struct aic_linux_target *targ;

-	del_timer(&dev->timer);
  	targ = dev->target;
  	targ->devices[dev->lun] = NULL;
  	free(dev, M_DEVBUF);
@@ -4325,7 +4348,10 @@
  	}
          case AC_SENT_BDR:
  	{
+		struct	aic_linux_target *targ;
+		int	target_offset;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+
  		WARN_ON(lun != CAM_LUN_WILDCARD);
  		scsi_report_device_reset(ahd->platform_data->host,
  					 channel - 'A', target);
@@ -4347,6 +4373,36 @@
  			}
  		}
  #endif
+		/*
+		 * Freeze the target for a 500ms to give the
+		 * target some time to recover from this BDR.
+		 */
+		target_offset = target;
+		if (channel == 'B')
+			target_offset += 8;
+		targ = ahd->platform_data->targets[target_offset];
+		if (targ == NULL)
+			break;
+		if ((targ->flags & AIC_TARG_TIMER_ACTIVE) != 0) {
+			printf("%s:%c:%d: Target Timer still active during "
+			       "BDR processing\n", ahd_name(ahd),
+				targ->channel, targ->target);
+			break;
+		}
+		/*
+		 * Keep the reference count non-zero during
+		 * the lifetime of the timer.  This
+		 * guarantees that the target will not
+		 * be freed before our timer executes.
+		 */
+		targ->refcount++;
+		targ->flags |= AIC_TARG_TIMER_ACTIVE;
+		targ->qfrozen++;
+		init_timer(&targ->timer);
+		targ->timer.data = (u_long)targ;
+		targ->timer.expires = jiffies + (HZ/2);
+		targ->timer.function = ahd_linux_targ_timed_unfreeze;
+		add_timer(&targ->timer);
  		break;
  	}
          case AC_BUS_RESET:
@@ -4454,7 +4510,33 @@
  	} else if (aic_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
  		ahd_linux_handle_scsi_status(ahd, dev, scb);
  	} else if (aic_get_transaction_status(scb) == CAM_SEL_TIMEOUT) {
-		dev->flags |= AIC_DEV_UNCONFIGURED;
+		struct aic_linux_target *targ;
+		struct aic_linux_device *cur_dev;
+		int i;
+
+		/*
+		 * Mark all devices linked off this target
+		 * as unconfigured.
+		 */
+		targ = dev->target;
+		for (i = 0; i < AHD_NUM_LUNS; i++) {
+
+			if (targ->devices[i] == NULL)
+				continue;
+			cur_dev = targ->devices[i];
+			cur_dev->flags |= AIC_DEV_UNCONFIGURED;
+
+			/*
+			 * Don't free the dev for this
+			 * command prematurely.
+			 */
+			if (cur_dev == dev)
+				continue;
+
+			if (TAILQ_EMPTY(&cur_dev->busyq)
+			 && dev->active == 0)
+				ahd_linux_free_device(ahd, cur_dev);
+		}
  		if (AIC_DV_CMD(cmd) == FALSE)
  			dev->target->flags &= ~AIC_DV_REQUIRED;
  	}
@@ -4719,8 +4801,15 @@
  				dev->target->channel, dev->target->target);
  			break;
  		}
-		dev->flags |= AIC_DEV_TIMER_ACTIVE;
  		dev->qfrozen++;
+		/*
+		 * Keep the active count non-zero during
+		 * the lifetime of the timer.  This
+		 * guarantees that the device will not
+		 * be freed before our timer executes.
+		 */
+		dev->active++;
+		dev->flags |= AIC_DEV_TIMER_ACTIVE;
  		init_timer(&dev->timer);
  		dev->timer.data = (u_long)dev;
  		dev->timer.expires = jiffies + (HZ/2);
@@ -5030,10 +5119,17 @@
  	dev = (struct aic_linux_device *)arg;
  	ahd = dev->target->softc;
  	ahd_lock(ahd, &s);
+
+	/*
+	 * Release our hold on the device.
+	 */
  	dev->flags &= ~AIC_DEV_TIMER_ACTIVE;
+	dev->active--;
+
  	if (dev->qfrozen > 0)
  		dev->qfrozen--;
  	if (dev->qfrozen == 0
+	 && dev->target->qfrozen == 0
  	 && (dev->flags & AIC_DEV_ON_RUN_LIST) == 0)
  		ahd_linux_run_device_queue(ahd, dev);
  	if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
@@ -5043,6 +5139,42 @@
  	ahd_unlock(ahd, &s);
  }

+static void
+ahd_linux_targ_timed_unfreeze(u_long arg)
+{
+	struct aic_linux_target *targ;
+	struct ahd_softc *ahd;
+	u_long s;
+
+	targ = (struct aic_linux_target *)arg;
+	ahd = targ->softc;
+	ahd_lock(ahd, &s);
+
+	/*
+	 * Release our hold on the target.
+	 */
+	targ->flags &= ~AIC_TARG_TIMER_ACTIVE;
+	targ->refcount--;
+
+	if (targ->qfrozen > 0)
+		targ->qfrozen--;
+	if (targ->qfrozen == 0) {
+		u_int i;
+
+		for (i = 0; i < AHD_NUM_LUNS; i++) {
+			struct aic_linux_device *dev;
+		
+			dev = targ->devices[i];
+			if (dev == NULL
+	 		 || (dev->flags & AIC_DEV_ON_RUN_LIST) != 0)
+				continue;
+
+			aic_linux_check_device_queue(ahd, dev);
+		}
+	}
+	ahd_unlock(ahd, &s);
+}
+
  void
  ahd_platform_dump_card_state(struct ahd_softc *ahd)
  {
@@ -5088,6 +5220,8 @@
  {
  	int	found;

+	ahd_sysrq_key = aic_install_sysrq(&ahd_sysrq_op);
+
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
  	found = ahd_linux_detect(&aic79xx_driver_template);
  #else
@@ -5100,17 +5234,17 @@
  #endif
  	if (ahd_init_status != 0) {
  		/*
-		 * Linux will only call our exit
-		 * routine if our init function
-		 * returns 0 status.  Force cleanup
-		 * if initialization is not successful.
+		 * Linux will not call our exit
+		 * routine if we fail to load.
+		 * Force cleanup if initialization
+		 * is not successful.
  		 */
  		ahd_linux_exit();
  	}
  	return (ahd_init_status);
  }

-static void __exit
+static void
  ahd_linux_exit(void)
  {
  	struct ahd_softc *ahd;
@@ -5135,6 +5269,8 @@
  	scsi_unregister_module(MODULE_SCSI_HA, &aic79xx_driver_template);
  #endif
  	ahd_linux_pci_exit();
+
+	aic_remove_sysrq(ahd_sysrq_key, &ahd_sysrq_op);
  }

  module_init(ahd_linux_init);
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#156 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.27147.5	2004-09-27 13:35:30.145045192 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-02-04 17:38:21.000000000 -0500
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#156 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#157 $
   *
   */
  #ifndef _AIC79XX_LINUX_H_
@@ -94,7 +94,7 @@
  #include <linux/smp.h>
  #endif

-#define AIC79XX_DRIVER_VERSION "2.0.5"
+#define AIC79XX_DRIVER_VERSION "2.0.6"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/aic7xxx/aic7xxx.c#148 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c ====
--- /tmp/tmp.27147.6	2004-09-27 13:35:30.998915384 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c	2004-02-19 16:52:54.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#148 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#150 $
   */

  #ifdef __linux__
@@ -290,10 +290,19 @@
  		ahc_outb(ahc, SEQ_FLAGS2,
  			 ahc_inb(ahc, SEQ_FLAGS2) & ~SCB_DMA);
  	}
+
+	/*
+	 * Clear any pending sequencer interrupt.  It is no
+	 * longer relevant since we're resetting the Program
+	 * Counter.
+	 */
+	ahc_outb(ahc, CLRINT, CLRSEQINT);
+
  	ahc_outb(ahc, MWI_RESIDUAL, 0);
  	ahc_outb(ahc, SEQCTL, ahc->seqctl);
  	ahc_outb(ahc, SEQADDR0, 0);
  	ahc_outb(ahc, SEQADDR1, 0);
+
  	ahc_unpause(ahc);
  }

@@ -365,6 +374,7 @@
  	if ((scb = TAILQ_FIRST(queue)) != NULL
  	 && (scb->flags & SCB_ACTIVE) == 0) {
  		scb->flags |= SCB_ACTIVE;
+		aic_scb_timer_start(scb);
  		ahc_queue_scb(ahc, scb);
  	}
  }
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#263 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.27147.7	2004-09-27 13:35:31.557830416 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-02-22 13:27:04.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#263 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#268 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -494,8 +494,9 @@
  static void ahc_linux_filter_inquiry(struct ahc_softc*, struct ahc_devinfo*);
  static void ahc_linux_sem_timeout(u_long arg);
  static void ahc_linux_dev_timed_unfreeze(u_long arg);
+static void ahc_linux_targ_timed_unfreeze(u_long arg);
  static int __init ahc_linux_init(void);
-static void __exit ahc_linux_exit(void);
+static void ahc_linux_exit(void);
  static int  ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag);
  static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
  static void ahc_linux_size_nseg(void);
@@ -1117,6 +1118,17 @@
  		printf("%s: aic7xxx_linux_queue - Unable to allocate device!\n",
  		       ahc_name(ahc));
  		return (0);
+	} else if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
+		&& cmd->device->type != -1) {
+		/*
+		 * Configure devices that have already successfully
+		 * completed an inquiry. This  handles the case of
+		 * devices being destroyed due to transient selection
+		 * timeouts.
+		 */
+		dev->flags &= ~AIC_DEV_UNCONFIGURED;
+	 	dev->scsi_device = cmd->device;
+		aic_linux_device_queue_depth(ahc, dev);
  	}

  	if (cmd->cmd_len > MAX_CDB_LEN) {
@@ -1675,7 +1687,6 @@
  #endif
  	ahc_linux_initialize_scsi_bus(ahc);
  	ahc_unlock(ahc, &s);
-	ahc_sysrq_key = aic_install_sysrq(&ahc_sysrq_op);
  	ahc_spawn_recovery_thread(ahc);
  	if (ahc->platform_data->recovery_pid < 0) {
  		printf("%s: Failed to create recovery thread, error= %d\n",
@@ -1878,7 +1889,6 @@
  	struct aic_linux_device *dev;
  	int i, j;

-	aic_remove_sysrq(ahc_sysrq_key, &ahc_sysrq_op);
  	if (ahc->platform_data != NULL) {
  		del_timer_sync(&ahc->platform_data->completeq_timer);
  		ahc_linux_kill_dv_thread(ahc);
@@ -1896,7 +1906,19 @@
  		for (i = 0; i < AHC_NUM_TARGETS; i++) {
  			targ = ahc->platform_data->targets[i];
  			if (targ != NULL) {
-				/* Keep target around through the loop. */
+
+				/*
+				 * Stop any unfreeze timer from running.
+				 */
+				del_timer_sync(&targ->timer);
+
+				/*
+				 * Keep target around through the loop.
+				 * The timer above may also have held
+				 * a refcount, but since we forcibly
+				 * delete the target, we don't care
+				 * about the extra reference.
+				 */
  				targ->refcount++;
  				for (j = 0; j < AHC_NUM_LUNS; j++) {

@@ -3594,7 +3616,8 @@
  		panic("running device on run list");

  	while ((acmd = TAILQ_FIRST(&dev->busyq)) != NULL
-	    && dev->openings > 0 && dev->qfrozen == 0) {
+	    && dev->openings > 0 && dev->qfrozen == 0
+	    && dev->target->qfrozen == 0) {

  		/*
  		 * Schedule us to run later.  The only reason we are not
@@ -3863,6 +3886,7 @@
  	targ->target = target;
  	targ->softc = ahc;
  	targ->flags = AIC_DV_REQUIRED;
+	init_timer(&targ->timer);
  	ahc->platform_data->targets[target_offset] = targ;
  	return (targ);
  }
@@ -3936,7 +3960,7 @@
  	 * a tagged queuing capable device.
  	 */
  	dev->maxtags = 0;
-	
+
  	targ->refcount++;
  	targ->devices[lun] = dev;
  	return (dev);
@@ -3947,7 +3971,6 @@
  {
  	struct aic_linux_target *targ;

-	del_timer(&dev->timer);
  	targ = dev->target;
  	targ->devices[dev->lun] = NULL;
  	free(dev, M_DEVBUF);
@@ -4028,7 +4051,10 @@
  	}
          case AC_SENT_BDR:
  	{
+		struct	aic_linux_target *targ;
+		int	target_offset;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+
  		WARN_ON(lun != CAM_LUN_WILDCARD);
  		scsi_report_device_reset(ahc->platform_data->host,
  					 channel - 'A', target);
@@ -4050,6 +4076,36 @@
  			}
  		}
  #endif
+		/*
+		 * Freeze the target for a 500ms to give the
+		 * target some time to recover from this BDR.
+		 */
+		target_offset = target;
+		if (channel == 'B')
+			target_offset += 8;
+		targ = ahc->platform_data->targets[target_offset];
+		if (targ == NULL)
+			break;
+		if ((targ->flags & AIC_TARG_TIMER_ACTIVE) != 0) {
+			printf("%s:%c:%d: Target Timer still active during "
+			       "BDR processing\n", ahc_name(ahc),
+				targ->channel, targ->target);
+			break;
+		}
+		/*
+		 * Keep the reference count non-zero during
+		 * the lifetime of the timer.  This
+		 * guarantees that the target will not
+		 * be freed before our timer executes.
+		 */
+		targ->refcount++;
+		targ->flags |= AIC_TARG_TIMER_ACTIVE;
+		targ->qfrozen++;
+		init_timer(&targ->timer);
+		targ->timer.data = (u_long)targ;
+		targ->timer.expires = jiffies + (HZ/2);
+		targ->timer.function = ahc_linux_targ_timed_unfreeze;
+		add_timer(&targ->timer);
  		break;
  	}
          case AC_BUS_RESET:
@@ -4169,7 +4225,33 @@
  	} else if (aic_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
  		ahc_linux_handle_scsi_status(ahc, dev, scb);
  	} else if (aic_get_transaction_status(scb) == CAM_SEL_TIMEOUT) {
-		dev->flags |= AIC_DEV_UNCONFIGURED;
+		struct aic_linux_target *targ;
+		struct aic_linux_device *cur_dev;
+		int i;
+
+		/*
+		 * Mark all devices linked off this target
+		 * as unconfigured.
+		 */
+		targ = dev->target;
+		for (i = 0; i < AHC_NUM_LUNS; i++) {
+
+			if (targ->devices[i] == NULL)
+				continue;
+			cur_dev = targ->devices[i];
+			cur_dev->flags |= AIC_DEV_UNCONFIGURED;
+
+			/*
+			 * Don't free the dev for this
+			 * command prematurely.
+			 */
+			if (cur_dev == dev)
+				continue;
+
+			if (TAILQ_EMPTY(&cur_dev->busyq)
+			 && dev->active == 0)
+				ahc_linux_free_device(ahc, cur_dev);
+		}
  		if (AIC_DV_CMD(cmd) == FALSE)
  			dev->target->flags &= ~AIC_DV_REQUIRED;
  	}
@@ -4417,8 +4499,15 @@
  				dev->target->channel, dev->target->target);
  			break;
  		}
-		dev->flags |= AIC_DEV_TIMER_ACTIVE;
  		dev->qfrozen++;
+		/*
+		 * Keep the active count non-zero during
+		 * the lifetime of the timer.  This
+		 * guarantees that the device will not
+		 * be freed before our timer executes.
+		 */
+		dev->active++;
+		dev->flags |= AIC_DEV_TIMER_ACTIVE;
  		init_timer(&dev->timer);
  		dev->timer.data = (u_long)dev;
  		dev->timer.expires = jiffies + (HZ/2);
@@ -4699,10 +4788,17 @@
  	dev = (struct aic_linux_device *)arg;
  	ahc = dev->target->softc;
  	ahc_lock(ahc, &s);
+
+	/*
+	 * Release our hold on the device.
+	 */
  	dev->flags &= ~AIC_DEV_TIMER_ACTIVE;
+	dev->active--;
+
  	if (dev->qfrozen > 0)
  		dev->qfrozen--;
  	if (dev->qfrozen == 0
+	 && dev->target->qfrozen == 0
  	 && (dev->flags & AIC_DEV_ON_RUN_LIST) == 0)
  		ahc_linux_run_device_queue(ahc, dev);
  	if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
@@ -4712,6 +4808,43 @@
  	ahc_unlock(ahc, &s);
  }

+static void
+ahc_linux_targ_timed_unfreeze(u_long arg)
+{
+	struct aic_linux_target *targ;
+	struct ahc_softc *ahc;
+	u_long s;
+
+	targ = (struct aic_linux_target *)arg;
+	ahc = targ->softc;
+	ahc_lock(ahc, &s);
+
+	/*
+	 * Release our hold on the target.
+	 */
+	targ->flags &= ~AIC_TARG_TIMER_ACTIVE;
+	targ->refcount--;
+
+	targ->flags &= ~AIC_TARG_TIMER_ACTIVE;
+	if (targ->qfrozen > 0)
+		targ->qfrozen--;
+	if (targ->qfrozen == 0) {
+		u_int i;
+
+		for (i = 0; i < AHC_NUM_LUNS; i++) {
+			struct aic_linux_device *dev;
+		
+			dev = targ->devices[i];
+			if (dev == NULL
+	 		 || (dev->flags & AIC_DEV_ON_RUN_LIST) != 0)
+				continue;
+
+			aic_linux_check_device_queue(ahc, dev);
+		}
+	}
+	ahc_unlock(ahc, &s);
+}
+
  static int
  ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag)
  {
@@ -5107,6 +5240,8 @@
  {
  	int found;

+	ahc_sysrq_key = aic_install_sysrq(&ahc_sysrq_op);
+
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
  	found = ahc_linux_detect(&aic7xxx_driver_template);
  #else
@@ -5119,17 +5254,17 @@
  #endif
  	if (ahc_init_status != 0) {
  		/*
-		 * Linux will only call our exit
-		 * routine if our init function
-		 * returns 0 status.  Force cleanup
-		 * if initialization is not successful.
+		 * Linux will not call our exit
+		 * routine if we fail to load.
+		 * Force cleanup if initialization
+		 * is not successful.
  		 */
  		ahc_linux_exit();
  	}
  	return (ahc_init_status);
  }

-static void __exit
+static void
  ahc_linux_exit(void)
  {
  	struct ahc_softc *ahc;
@@ -5160,6 +5295,7 @@
  #ifdef CONFIG_EISA
  	ahc_linux_eisa_exit();
  #endif
+	aic_remove_sysrq(ahc_sysrq_key, &ahc_sysrq_op);
  }

  module_init(ahc_linux_init);
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#168 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.27147.8	2004-09-27 13:35:31.610822360 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-02-04 12:33:27.000000000 -0500
@@ -53,7 +53,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#168 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#169 $
   *
   */
  #ifndef _AIC7XXX_LINUX_H_
@@ -113,7 +113,7 @@
  #include <linux/smp.h>
  #endif

-#define AIC7XXX_DRIVER_VERSION "6.3.4"
+#define AIC7XXX_DRIVER_VERSION "6.3.5"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/aic7xxx/aicasm/aicasm_gram.y#29 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y ====
--- /tmp/tmp.27147.9	2004-09-27 13:35:31.786795608 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	2004-02-12 19:29:06.000000000 -0500
@@ -38,7 +38,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_gram.y#29 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_gram.y#30 $
   *
   * $FreeBSD$
   */
@@ -157,6 +157,8 @@

  %token T_END_CS

+%token T_PAD_PAGE
+
  %token T_FIELD

  %token T_ENUM
@@ -189,6 +191,10 @@

  %token <value> T_OR

+/* 16 bit extensions */
+%token <value> T_OR16 T_AND16 T_XOR16 T_ADD16
+%token <value> T_ADC16 T_MVI16 T_TEST16 T_CMP16 T_CMPXCHG
+
  %token T_RET

  %token T_NOP
@@ -207,7 +213,7 @@

  %type <expression> expression immediate immediate_or_a

-%type <value> export ret f1_opcode f2_opcode jmp_jc_jnc_call jz_jnz je_jne
+%type <value> export ret f1_opcode f2_opcode f4_opcode jmp_jc_jnc_call jz_jnz je_jne

  %type <value> mode_value mode_list macro_arglist

@@ -1304,6 +1310,15 @@
  |	T_ROR { $$ = AIC_OP_ROR; }
  ;

+f4_opcode:
+	T_OR16	{ $$ = AIC_OP_OR16; }
+|	T_AND16 { $$ = AIC_OP_AND16; }
+|	T_XOR16 { $$ = AIC_OP_XOR16; }
+|	T_ADD16 { $$ = AIC_OP_ADD16; }
+|	T_ADC16 { $$ = AIC_OP_ADC16; }
+|	T_MVI16 { $$ = AIC_OP_MVI16; }
+;
+
  code:
  	f2_opcode destination ',' expression opt_source ret ';'
  	{
==== //depot/aic7xxx/aic7xxx/aicasm/aicasm_insformat.h#11 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h ====
--- /tmp/tmp.27147.10	2004-09-27 13:35:31.795794240 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h	2004-02-12 19:28:11.000000000 -0500
@@ -37,11 +37,12 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_insformat.h#11 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_insformat.h#12 $
   *
   * $FreeBSD$
   */

+/* 8bit ALU logic operations */
  struct ins_format1 {
  #if BYTE_ORDER == LITTLE_ENDIAN
  	uint32_t	immediate	: 8,
@@ -60,6 +61,7 @@
  #endif
  };

+/* 8bit ALU shift/rotate operations */
  struct ins_format2 {
  #if BYTE_ORDER == LITTLE_ENDIAN
  	uint32_t	shift_control	: 8,
@@ -78,6 +80,7 @@
  #endif
  };

+/* 8bit branch control operations */
  struct ins_format3 {
  #if BYTE_ORDER == LITTLE_ENDIAN
  	uint32_t	immediate	: 8,
@@ -94,10 +97,68 @@
  #endif
  };

+/* 16bit ALU logic operations */
+struct ins_format4 {
+#if BYTE_ORDER == LITTLE_ENDIAN
+	uint32_t	opcode_ext	: 8,
+			source		: 9,
+			destination	: 9,
+			ret		: 1,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			ret		: 1,
+			destination	: 9,
+			source		: 9,
+			opcode_ext	: 8;
+#endif
+};
+
+/* 16bit branch control operations */
+struct ins_format5 {
+#if BYTE_ORDER == LITTLE_ENDIAN
+	uint32_t	opcode_ext	: 8,
+			source		: 9,
+			address		: 10,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			address		: 10,
+			source		: 9,
+			opcode_ext	: 8;
+#endif
+};
+
+/*  Far branch operations */
+struct ins_format6 {
+#if BYTE_ORDER == LITTLE_ENDIAN
+	uint32_t	page		: 3,
+			opcode_ext	: 5,
+			source		: 9,
+			address		: 10,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			address		: 10,
+			source		: 9,
+			opcode_ext	: 5,
+			page		: 3;
+#endif
+};
+
  union ins_formats {
  		struct ins_format1 format1;
  		struct ins_format2 format2;
  		struct ins_format3 format3;
+		struct ins_format4 format4;
+		struct ins_format5 format5;
+		struct ins_format6 format6;
  		uint8_t		   bytes[4];
  		uint32_t	   integer;
  };
@@ -116,6 +177,8 @@
  #define	AIC_OP_ROL	0x5
  #define	AIC_OP_BMOV	0x6

+#define	AIC_OP_MVI16	0x7
+
  #define	AIC_OP_JMP	0x8
  #define AIC_OP_JC	0x9
  #define AIC_OP_JNC	0xa
@@ -129,3 +192,26 @@
  #define	AIC_OP_SHL	0x10
  #define	AIC_OP_SHR	0x20
  #define	AIC_OP_ROR	0x30
+
+/* 16bit Ops. Low byte main opcode.  High byte extended opcode. */
+#define	AIC_OP_OR16	0x8005
+#define	AIC_OP_AND16	0x8105
+#define	AIC_OP_XOR16	0x8205
+#define	AIC_OP_ADD16	0x8305
+#define	AIC_OP_ADC16	0x8405
+#define AIC_OP_JNE16	0x8805
+#define AIC_OP_JNZ16	0x8905
+#define AIC_OP_JE16	0x8C05
+#define AIC_OP_JZ16	0x8B05
+#define AIC_OP_JMP16	0x9005
+#define AIC_OP_JC16	0x9105
+#define AIC_OP_JNC16	0x9205
+#define AIC_OP_CALL16	0x9305
+#define AIC_OP_CALL16	0x9305
+
+/* Page extension is low three bits of second opcode byte. */
+#define AIC_OP_JMPF	0xA005
+#define AIC_OP_CALLF	0xB005
+#define AIC_OP_JCF	0xC005
+#define AIC_OP_JNCF	0xD005
+#define AIC_OP_CMPXCHG	0xE005
==== //depot/aic7xxx/aic7xxx/aicasm/aicasm_scan.l#19 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l ====
--- /tmp/tmp.27147.11	2004-09-27 13:35:31.851785728 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l	2004-02-12 19:08:30.000000000 -0500
@@ -38,7 +38,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_scan.l#19 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_scan.l#20 $
   *
   * $FreeBSD$
   */
@@ -132,7 +132,7 @@
  						*string_buf_ptr++ = *yptr++;
  				}
  			}
-
+else			{ return T_ELSE; }
  VERSION			{ return T_VERSION; }
  PREFIX			{ return T_PREFIX; }
  PATCH_ARG_LIST		{ return T_PATCH_ARG_LIST; }
@@ -173,10 +173,6 @@
  					yylval.value = WO;
  				 return T_MODE;
  			}
-BEGIN_CRITICAL		{ return T_BEGIN_CS; }
-END_CRITICAL		{ return T_END_CS; }
-SET_SRC_MODE		{ return T_SET_SRC_MODE; }
-SET_DST_MODE		{ return T_SET_DST_MODE; }
  field			{ return T_FIELD; }
  enum			{ return T_ENUM; }
  mask			{ return T_MASK; }
@@ -192,6 +188,13 @@
  sindex			{ return T_SINDEX; }
  A			{ return T_A; }

+	/* Instruction Formatting */
+PAD_PAGE		{ return T_PAD_PAGE; }
+BEGIN_CRITICAL		{ return T_BEGIN_CS; }
+END_CRITICAL		{ return T_END_CS; }
+SET_SRC_MODE		{ return T_SET_SRC_MODE; }
+SET_DST_MODE		{ return T_SET_DST_MODE; }
+
  	/* Opcodes */
  shl			{ return T_SHL; }
  shr			{ return T_SHR; }
@@ -223,7 +226,17 @@
  or			{ return T_OR;	}
  ret			{ return T_RET; }
  nop			{ return T_NOP; }
-else			{ return T_ELSE; }
+
+	/* ARP2 16bit extensions */
+or16			{ return T_OR16; }
+and16			{ return T_AND16; }
+xor16			{ return T_XOR16; }
+add16			{ return T_ADD16; }
+adc16			{ return T_ADC16; }
+mvi16			{ return T_MVI16; }
+test16			{ return T_TEST16; }
+cmp16			{ return T_CMP16; }
+cmpxchg			{ return T_CMPXCHG; }

  	/* Allowed Symbols */
  \<\<			{ return T_EXPR_LSHIFT; }
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.h#37 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h ====
--- /tmp/tmp.27147.12	2004-09-27 13:35:32.182735416 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h	2004-02-20 16:48:43.000000000 -0500
@@ -648,7 +648,8 @@
  	AIC_DV_REQUIRED		 = 0x01,
  	AIC_INQ_VALID		 = 0x02,
  	AIC_BASIC_DV		 = 0x04,
-	AIC_ENHANCED_DV		 = 0x08
+	AIC_ENHANCED_DV		 = 0x08,
+	AIC_TARG_TIMER_ACTIVE	 = 0x10
  } aic_linux_targ_flags;

  /* DV States */
@@ -667,6 +668,12 @@
  } aic_dv_state;

  struct aic_linux_target {
+	/*
+	 * A positive count indicates that this
+	 * target's queue is halted.
+	 */
+	u_int			  qfrozen;
+
  	struct aic_linux_device	 *devices[AIC_NUM_LUNS];
  	int			  channel;
  	int			  target;
@@ -676,6 +683,11 @@
  	aic_linux_targ_flags	  flags;
  	struct scsi_inquiry_data *inq_data;
  	/*
+	 * Per target timer.
+	 */
+	struct timer_list	timer;
+
+	/*
  	 * The next "fallback" period to use for narrow/wide transfers.
  	 */
  	uint8_t			  dv_next_narrow_period;
@@ -2106,7 +2118,8 @@
  	}

  	if (TAILQ_FIRST(&dev->busyq) == NULL
-	 || dev->openings == 0 || dev->qfrozen != 0)
+	 || dev->openings == 0 || dev->qfrozen != 0
+	 || dev->target->qfrozen != 0)
  		return;

  	aic_linux_run_device_queue(aic, dev);



