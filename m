From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 6/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:04:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596173.4080501@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:22730 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267725AbUI1NFA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:05:00 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD4xW02458
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:04:59 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD4wm30849
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:04:58 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2285-2294)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#175 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.26292.0	2004-09-27 12:52:08.017628688 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-08-27 12:45:31.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC79xx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#175 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#178 $
   *
   * --------------------------------------------------------------------------
   * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -62,6 +62,16 @@

  #include <linux/mm.h>		/* For fetching system memory size */

+/************************* Magic SysReq Support *******************************/
+static struct aic_sysrq_key_op ahd_sysrq_op =
+{
+	aic_sysrq_handler,
+	"aic79xxstatedump",
+	"Dump aic79xx controller information to Console"
+};
+
+static int ahd_sysrq_key;
+
  /*
   * Lock protecting manipulation of the ahd softc list.
   */
@@ -871,7 +881,7 @@
  	siginitsetinv(&current->blocked, 0);

  	daemonize();
-	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
+	sprintf(current->comm, "ahd_recovery_%d", ahd->unit);
  #else
  	daemonize("ahd_recovery_%d", ahd->unit);
  #endif
@@ -927,6 +937,10 @@
  {
  	ahd->platform_data->recovery_pid =
  	    kernel_thread(ahd_linux_recovery_thread, ahd, 0);
+	
+	if (ahd->platform_data->recovery_pid < 0)
+		return (-ahd->platform_data->recovery_pid);
+
  	return (0);
  }

@@ -1019,12 +1033,42 @@
  		ahd = scb->ahd_softc;
  		ahd_lock(ahd, &s);

-		/*
-		 * Skip timeouts that fire just after
-		 * they have been cancelled.
-		 */
-		if ((scb->platform_data->flags & AHD_TIMEOUT_ACTIVE) != 0) {
+		if (scb == NULL
+		 || scb->flags == SCB_FLAG_NONE) {
+			int done_late;
+
+			/*
+			 * Handle timeout/completion races.
+			 * If the command is still sitting on
+			 * our completion queue, just re-instate
+			 * the timeout.  If we've already completed
+			 * the command, done_late will be set and
+			 * we will need to additionally complete it
+			 * again to the mid-layer.
+			 *
+			 * Since done_late is cleared by adding a
+			 * timer, we must save off its value first.
+			 */
+			done_late = cmd->done_late;
+			scsi_add_timer(cmd, 60*HZ, ahd_linux_midlayer_timeout);
+			if (done_late)
+				cmd->scsi_done(cmd);
+		} else if ((scb->platform_data->flags & AHD_TIMEOUT_ACTIVE)) {
+
+			/*
+			 * Handle the case of timeouts that expire just
+			 * as we delete timers during recovery by skipping
+			 * SCBs that don't have timers active.
+			 */
  			scb->platform_data->flags &= ~AHD_TIMEOUT_ACTIVE;
+
+			/*
+			 * We must clear out the function pointer so that
+			 * scsi_add_timer does not believe that a del_timer
+			 * is required before setting up a new timer for
+			 * this command.
+			 */
+			scb->io_ctx->eh_timeout.function = NULL;
  			ahd_timeout(scb);
  		}
  		ahd_unlock(ahd, &s);
@@ -1034,6 +1078,10 @@
  void
  ahd_linux_midlayer_timeout(struct scsi_cmnd *cmd)
  {
+	struct ahd_softc *ahd;
+
+	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
+	printf("%s: ahd_midlayer_timeout\n", ahd_name(ahd));
  }
  /********************** Host Template Entry Points ****************************/
  /*
@@ -2351,13 +2399,20 @@
  	ahd_linux_setup_user_rd_strm_settings(ahd);
  	ahd_linux_initialize_scsi_bus(ahd);
  	ahd_unlock(ahd, &s);
+	ahd_sysrq_key = aic_install_sysrq(&ahd_sysrq_op);
+	ahd_spawn_recovery_thread(ahd);
+	if (ahd->platform_data->recovery_pid < 0) {
+		printf("%s: Failed to create recovery thread, error= %d\n",
+		       ahd_name(ahd), ahd->platform_data->recovery_pid);
+		return (-ahd->platform_data->recovery_pid);
+	}
  	ahd->platform_data->dv_pid = kernel_thread(ahd_linux_dv_thread, ahd, 0);
-	ahd_lock(ahd, &s);
  	if (ahd->platform_data->dv_pid < 0) {
  		printf("%s: Failed to create DV thread, error= %d\n",
  		       ahd_name(ahd), ahd->platform_data->dv_pid);
  		return (-ahd->platform_data->dv_pid);
  	}
+	ahd_lock(ahd, &s);
  	/*
  	 * Initially allocate *all* of our linux target objects
  	 * so that the DV thread will scan them all in parallel
@@ -2521,6 +2576,7 @@
  	struct ahd_linux_device *dev;
  	int i, j;

+	aic_remove_sysrq(ahd_sysrq_key, &ahd_sysrq_op);
  	if (ahd->platform_data != NULL) {
  		del_timer_sync(&ahd->platform_data->completeq_timer);
  		ahd_linux_kill_dv_thread(ahd);
@@ -5102,7 +5158,17 @@
  			new_status = DID_PARITY;
  			break;
  		case CAM_CMD_TIMEOUT:
-			new_status = DID_TIME_OUT;
+			/*
+			 *  Returning DID_TIME_OUT will
+			 *  wake up the error recovery
+			 *  thread instead of doing the
+			 *  command retry we desire. Since
+			 *  we have already recovered the
+			 *  command, returning DID_ERROR
+			 *  will cause a retry up to the
+			 *  retry limit for this command.
+			 */
+			new_status = DID_ERROR;
  			break;
  		case CAM_UA_ABORT:
  		case CAM_REQ_CMP_ERR:
@@ -5334,12 +5400,22 @@
  void
  ahd_platform_dump_card_state(struct ahd_softc *ahd)
  {
+	struct Scsi_Host *host;
  	struct ahd_linux_device *dev;
  	int target;
  	int maxtarget;
  	int lun;
  	int i;

+	host = ahd->platform_data->host;
+	printf("%s: Host Status: %s%s%s%s%s\n",
+	       ahd_name(ahd),
+	       host->eh_active ? "eh_active " : "",
+	       host->in_recovery ? "in_recovery " : "",
+	       host->host_blocked ? "host_blocked " : "",
+	       host->host_self_blocked ? "host_self_blocked " : "",
+	       host->some_device_starved ? "some_device_starved" : "");
+	
  	maxtarget = (ahd->features & AHD_WIDE) ? 15 : 7;
  	for (target = 0; target <=maxtarget; target++) {

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#140 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.26292.1	2004-09-27 12:52:08.190602392 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2003-08-28 16:40:09.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#140 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#143 $
   *
   */
  #ifndef _AIC79XX_LINUX_H_
@@ -266,7 +266,7 @@
  #define AHD_SCSI_HAS_HOST_LOCK 0
  #endif

-#define AIC79XX_DRIVER_VERSION "2.0.0"
+#define AIC79XX_DRIVER_VERSION "2.0.1"

  /**************************** Front End Queues ********************************/
  /*
@@ -565,7 +565,7 @@
  	ahd = (struct ahd_softc *)arg;
  	del_timer(timer);
  	timer->data = (u_long)arg;
-	timer->expires = jiffies + (usec * HZ)/1000000;
+	timer->expires = jiffies + (usec / AIC_USECS_PER_JIFFY);
  	timer->function = (ahd_linux_callback_t*)func;
  	add_timer(timer);
  }
@@ -577,7 +577,7 @@
  	/*
  	 * Convert from jiffies to usec.
  	 */
-	return (scb->io_ctx->timeout_per_command * (1000000/HZ));
+	return (scb->io_ctx->timeout_per_command * AIC_USECS_PER_JIFFY);
  }

  static __inline void
@@ -591,8 +591,15 @@
  static __inline void
  ahd_scb_timer_reset(struct scb *scb, uint32_t usec)
  {
+	/*
+	 * Restore timer data that is clobbered by scsi_delete_timer().
+	 */
+	scb->io_ctx->eh_timeout.data = (unsigned long)scb->io_ctx;
+	scb->io_ctx->eh_timeout.function =
+	    (void (*)(unsigned long))ahd_platform_timeout;
  	scb->platform_data->flags |= AHD_TIMEOUT_ACTIVE;
-	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
+	mod_timer(&scb->io_ctx->eh_timeout,
+		  jiffies + (usec / AIC_USECS_PER_JIFFY));
  }

  /************************** Error Recovery ************************************/
@@ -849,74 +856,10 @@
  }

  /******************************* PCI Definitions ******************************/
-/*
- * PCIM_xxx: mask to locate subfield in register
- * PCIR_xxx: config register offset
- * PCIC_xxx: device class
- * PCIS_xxx: device subclass
- * PCIP_xxx: device programming interface
- * PCIV_xxx: PCI vendor ID (only required to fixup ancient devices)
- * PCID_xxx: device ID
- */
-#define PCIR_DEVVENDOR		0x00
-#define PCIR_VENDOR		0x00
-#define PCIR_DEVICE		0x02
-#define PCIR_COMMAND		0x04
-#define PCIM_CMD_PORTEN		0x0001
-#define PCIM_CMD_MEMEN		0x0002
-#define PCIM_CMD_BUSMASTEREN	0x0004
-#define PCIM_CMD_MWRICEN	0x0010
-#define PCIM_CMD_PERRESPEN	0x0040
-#define	PCIM_CMD_SERRESPEN	0x0100
-#define PCIR_STATUS		0x06
-#define PCIR_REVID		0x08
-#define PCIR_PROGIF		0x09
-#define PCIR_SUBCLASS		0x0a
-#define PCIR_CLASS		0x0b
-#define PCIR_CACHELNSZ		0x0c
-#define PCIR_LATTIMER		0x0d
-#define PCIR_HEADERTYPE		0x0e
-#define PCIM_MFDEV		0x80
-#define PCIR_BIST		0x0f
-#define PCIR_CAP_PTR		0x34
-
-/* config registers for header type 0 devices */
-#define PCIR_MAPS	0x10
-#define PCIR_SUBVEND_0	0x2c
-#define PCIR_SUBDEV_0	0x2e
-
-/****************************** PCI-X definitions *****************************/
-#define PCIXR_COMMAND	0x96
-#define PCIXR_DEVADDR	0x98
-#define PCIXM_DEVADDR_FNUM	0x0003	/* Function Number */
-#define PCIXM_DEVADDR_DNUM	0x00F8	/* Device Number */
-#define PCIXM_DEVADDR_BNUM	0xFF00	/* Bus Number */
-#define PCIXR_STATUS	0x9A
-#define PCIXM_STATUS_64BIT	0x0001	/* Active 64bit connection to device. */
-#define PCIXM_STATUS_133CAP	0x0002	/* Device is 133MHz capable */
-#define PCIXM_STATUS_SCDISC	0x0004	/* Split Completion Discarded */
-#define PCIXM_STATUS_UNEXPSC	0x0008	/* Unexpected Split Completion */
-#define PCIXM_STATUS_CMPLEXDEV	0x0010	/* Device Complexity (set == bridge) */
-#define PCIXM_STATUS_MAXMRDBC	0x0060	/* Maximum Burst Read Count */
-#define PCIXM_STATUS_MAXSPLITS	0x0380	/* Maximum Split Transactions */
-#define PCIXM_STATUS_MAXCRDS	0x1C00	/* Maximum Cumulative Read Size */
-#define PCIXM_STATUS_RCVDSCEM	0x2000	/* Received a Split Comp w/Error msg */
-
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  extern struct pci_driver aic79xx_pci_driver;
  #endif

-typedef enum
-{
-	AHD_POWER_STATE_D0,
-	AHD_POWER_STATE_D1,
-	AHD_POWER_STATE_D2,
-	AHD_POWER_STATE_D3
-} ahd_power_state;
-
-void ahd_power_state_change(struct ahd_softc *ahd,
-			    ahd_power_state new_state);
-
  /******************************* PCI Routines *********************************/
  int			 ahd_linux_pci_init(void);
  void			 ahd_linux_pci_exit(void);
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#25 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c ====
--- /tmp/tmp.26292.2	2004-09-27 12:52:08.259591904 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2003-08-14 15:03:47.000000000 -0400
@@ -36,12 +36,18 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#25 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#26 $
   */

  #include "aic79xx_osm.h"
  #include "aic79xx_inline.h"

+/*
+ * Include aiclib_pci.c as part of our
+ * "module dependencies are hard" work around.
+ */
+#include "aiclib_pci.c"
+
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
  struct pci_device_id
  {
@@ -404,42 +410,3 @@
  	
  	return (-error);
  }
-
-void
-ahd_power_state_change(struct ahd_softc *ahd, ahd_power_state new_state)
-{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-	pci_set_power_state(ahd->dev_softc, new_state);
-#else
-	uint32_t cap;
-	u_int cap_offset;
-
-	/*
-	 * Traverse the capability list looking for
-	 * the power management capability.
-	 */
-	cap = 0;
-	cap_offset = ahd_pci_read_config(ahd->dev_softc,
-					 PCIR_CAP_PTR, /*bytes*/1);
-	while (cap_offset != 0) {
-
-		cap = ahd_pci_read_config(ahd->dev_softc,
-					  cap_offset, /*bytes*/4);
-		if ((cap & 0xFF) == 1
-		 && ((cap >> 16) & 0x3) > 0) {
-			uint32_t pm_control;
-
-			pm_control = ahd_pci_read_config(ahd->dev_softc,
-							 cap_offset + 4,
-							 /*bytes*/4);
-			pm_control &= ~0x3;
-			pm_control |= new_state;
-			ahd_pci_write_config(ahd->dev_softc,
-					     cap_offset + 4,
-					     pm_control, /*bytes*/2);
-			break;
-		}
-		cap_offset = (cap >> 8) & 0xFF;
-	}
-#endif
-}
==== //depot/aic7xxx/aic7xxx/aic79xx_pci.c#78 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c ====
--- /tmp/tmp.26292.3	2004-09-27 12:52:08.439564544 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c	2003-08-14 15:00:34.000000000 -0400
@@ -38,7 +38,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#78 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#79 $
   *
   * $FreeBSD$
   */
@@ -340,7 +340,7 @@
  	}
  	ahd->bus_description = pci_bus_modes[PCI_BUS_MODES_INDEX(devconfig)];

-	ahd_power_state_change(ahd, AHD_POWER_STATE_D0);
+	ahd_power_state_change(ahd, AIC_POWER_STATE_D0);

  	error = ahd_pci_map_registers(ahd);
  	if (error != 0)
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#238 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.26292.4	2004-09-27 12:52:09.226444920 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-08-27 12:45:41.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#238 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#241 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -141,6 +141,16 @@
  #include <linux/mm.h>		/* For fetching system memory size */
  #include <linux/blk.h>		/* For block_size() */

+/************************* Magic SysReq Support *******************************/
+static struct aic_sysrq_key_op ahc_sysrq_op =
+{
+	aic_sysrq_handler,
+	"aic7xxxstatedump",
+	"Dump aic7xxx controller information to Console"
+};
+
+static int ahc_sysrq_key;
+
  /*
   * Lock protecting manipulation of the ahc softc list.
   */
@@ -859,7 +869,7 @@
  	siginitsetinv(&current->blocked, 0);

  	daemonize();
-	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
+	sprintf(current->comm, "ahc_recovery_%d", ahc->unit);
  #else
  	daemonize("ahc_recovery_%d", ahc->unit);
  #endif
@@ -914,6 +924,10 @@
  {
  	ahc->platform_data->recovery_pid =
  	    kernel_thread(ahc_linux_recovery_thread, ahc, 0);
+
+	if (ahc->platform_data->recovery_pid < 0)
+		return (-ahc->platform_data->recovery_pid);
+
  	return (0);
  }

@@ -1006,12 +1020,42 @@
  		ahc = scb->ahc_softc;
  		ahc_lock(ahc, &s);

-		/*
-		 * Skip timeouts that fire just after
-		 * they have been cancelled.
-		 */
-		if ((scb->platform_data->flags & AHC_TIMEOUT_ACTIVE) != 0) {
+		if (scb == NULL
+		 || scb->flags == SCB_FLAG_NONE) {
+			int done_late;
+
+			/*
+			 * Handle timeout/completion races.
+			 * If the command is still sitting on
+			 * our completion queue, just re-instate
+			 * the timeout.  If we've already completed
+			 * the command, done_late will be set and
+			 * we will need to additionally complete it
+			 * again to the mid-layer.
+			 *
+			 * Since done_late is cleared by adding a
+			 * timer, we must save off its value first.
+			 */
+			done_late = cmd->done_late;
+			scsi_add_timer(cmd, 60*HZ, ahc_linux_midlayer_timeout);
+			if (done_late)
+				cmd->scsi_done(cmd);
+		} else if ((scb->platform_data->flags & AHC_TIMEOUT_ACTIVE)) {
+
+			/*
+			 * Handle the case of timeouts that expire just
+			 * as we delete timers during recovery by skipping
+			 * SCBs that don't have timers active.
+			 */
  			scb->platform_data->flags &= ~AHC_TIMEOUT_ACTIVE;
+
+			/*
+			 * We must clear out the function pointer so that
+			 * scsi_add_timer does not believe that a del_timer
+			 * is required before setting up a new timer for
+			 * this command.
+			 */
+			scb->io_ctx->eh_timeout.function = NULL;
  			ahc_timeout(scb);
  		}
  		ahc_unlock(ahc, &s);
@@ -1021,6 +1065,10 @@
  void
  ahc_linux_midlayer_timeout(struct scsi_cmnd *cmd)
  {
+	struct ahc_softc *ahc;
+
+	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
+	printf("%s: ahc_midlayer_timeout\n", ahc_name(ahc));
  }
  /************************ Linux Entry Points **********************************/
  /*
@@ -1969,13 +2017,20 @@
  #endif
  	ahc_linux_initialize_scsi_bus(ahc);
  	ahc_unlock(ahc, &s);
+	ahc_sysrq_key = aic_install_sysrq(&ahc_sysrq_op);
+	ahc_spawn_recovery_thread(ahc);
+	if (ahc->platform_data->recovery_pid < 0) {
+		printf("%s: Failed to create recovery thread, error= %d\n",
+		       ahc_name(ahc), ahc->platform_data->recovery_pid);
+		return (-ahc->platform_data->recovery_pid);
+	}
  	ahc->platform_data->dv_pid = kernel_thread(ahc_linux_dv_thread, ahc, 0);
-	ahc_lock(ahc, &s);
  	if (ahc->platform_data->dv_pid < 0) {
  		printf("%s: Failed to create DV thread, error= %d\n",
  		       ahc_name(ahc), ahc->platform_data->dv_pid);
  		return (-ahc->platform_data->dv_pid);
  	}
+	ahc_lock(ahc, &s);
  	/*
  	 * Initially allocate *all* of our linux target objects
  	 * so that the DV thread will scan them all in parallel
@@ -2181,6 +2236,7 @@
  	struct ahc_linux_device *dev;
  	int i, j;

+	aic_remove_sysrq(ahc_sysrq_key, &ahc_sysrq_op);
  	if (ahc->platform_data != NULL) {
  		del_timer_sync(&ahc->platform_data->completeq_timer);
  		ahc_linux_kill_dv_thread(ahc);
@@ -4730,7 +4786,17 @@
  			new_status = DID_PARITY;
  			break;
  		case CAM_CMD_TIMEOUT:
-			new_status = DID_TIME_OUT;
+			/*
+			 *  Returning DID_TIME_OUT will
+			 *  wake up the error recovery
+			 *  thread instead of doing the
+			 *  command retry we desire. Since
+			 *  we have already recovered the
+			 *  command, returning DID_ERROR
+			 *  will cause a retry up to the
+			 *  retry limit for this command.
+			 */
+			new_status = DID_ERROR;
  			break;
  		case CAM_UA_ABORT:
  		case CAM_REQ_CMP_ERR:
@@ -5316,6 +5382,7 @@
  void
  ahc_platform_dump_card_state(struct ahc_softc *ahc)
  {
+	struct Scsi_Host *host;
  	struct ahc_linux_device *dev;
  	int channel;
  	int maxchannel;
@@ -5324,6 +5391,15 @@
  	int lun;
  	int i;

+	host = ahc->platform_data->host;
+	printf("%s: Host Status: %s%s%s%s%s\n",
+	       ahc_name(ahc),
+	       host->eh_active ? "eh_active " : "",
+	       host->in_recovery ? "in_recovery " : "",
+	       host->host_blocked ? "host_blocked " : "",
+	       host->host_self_blocked ? "host_self_blocked " : "",
+	       host->some_device_starved ? "some_device_starved" : "");
+	
  	maxchannel = (ahc->features & AHC_TWIN) ? 1 : 0;
  	maxtarget = (ahc->features & AHC_WIDE) ? 15 : 7;
  	for (channel = 0; channel <= maxchannel; channel++) {
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#153 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.26292.5	2004-09-27 12:52:09.431413760 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2003-08-28 16:40:53.000000000 -0400
@@ -53,7 +53,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#153 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#155 $
   *
   */
  #ifndef _AIC7XXX_LINUX_H_
@@ -570,7 +570,7 @@
  	ahc = (struct ahc_softc *)arg;
  	del_timer(timer);
  	timer->data = (u_long)arg;
-	timer->expires = jiffies + (usec * HZ)/1000000;
+	timer->expires = jiffies + (usec / AIC_USECS_PER_JIFFY);
  	timer->function = (ahc_linux_callback_t*)func;
  	add_timer(timer);
  }
@@ -580,10 +580,9 @@
  {

  	/*
-	 * Convert from jiffies to usec avoiding
-	 * overflow and truncation.
+	 * Convert from jiffies to usec.
  	 */
-	return (scb->io_ctx->timeout_per_command * (1000000/HZ));
+	return (scb->io_ctx->timeout_per_command * AIC_USECS_PER_JIFFY);
  }

  static __inline void
@@ -597,8 +596,15 @@
  static __inline void
  ahc_scb_timer_reset(struct scb *scb, uint32_t usec)
  {
+	/*
+	 * Restore timer data that is clobbered by scsi_delete_timer().
+	 */
+	scb->io_ctx->eh_timeout.data = (unsigned long)scb->io_ctx;
+	scb->io_ctx->eh_timeout.function =
+	    (void (*)(unsigned long))ahc_platform_timeout;
  	scb->platform_data->flags |= AHC_TIMEOUT_ACTIVE;
-	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
+	mod_timer(&scb->io_ctx->eh_timeout,
+		  jiffies + (usec / AIC_USECS_PER_JIFFY));
  }

  /************************** Error Recovery ************************************/
@@ -827,54 +833,10 @@
  }

  /******************************* PCI Definitions ******************************/
-/*
- * PCIM_xxx: mask to locate subfield in register
- * PCIR_xxx: config register offset
- * PCIC_xxx: device class
- * PCIS_xxx: device subclass
- * PCIP_xxx: device programming interface
- * PCIV_xxx: PCI vendor ID (only required to fixup ancient devices)
- * PCID_xxx: device ID
- */
-#define PCIR_DEVVENDOR		0x00
-#define PCIR_VENDOR		0x00
-#define PCIR_DEVICE		0x02
-#define PCIR_COMMAND		0x04
-#define PCIM_CMD_PORTEN		0x0001
-#define PCIM_CMD_MEMEN		0x0002
-#define PCIM_CMD_BUSMASTEREN	0x0004
-#define PCIM_CMD_MWRICEN	0x0010
-#define PCIM_CMD_PERRESPEN	0x0040
-#define	PCIM_CMD_SERRESPEN	0x0100
-#define PCIR_STATUS		0x06
-#define PCIR_REVID		0x08
-#define PCIR_PROGIF		0x09
-#define PCIR_SUBCLASS		0x0a
-#define PCIR_CLASS		0x0b
-#define PCIR_CACHELNSZ		0x0c
-#define PCIR_LATTIMER		0x0d
-#define PCIR_HEADERTYPE		0x0e
-#define PCIM_MFDEV		0x80
-#define PCIR_BIST		0x0f
-#define PCIR_CAP_PTR		0x34
-
-/* config registers for header type 0 devices */
-#define PCIR_MAPS	0x10
-#define PCIR_SUBVEND_0	0x2c
-#define PCIR_SUBDEV_0	0x2e
-
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  extern struct pci_driver aic7xxx_pci_driver;
  #endif

-typedef enum
-{
-	AHC_POWER_STATE_D0,
-	AHC_POWER_STATE_D1,
-	AHC_POWER_STATE_D2,
-	AHC_POWER_STATE_D3
-} ahc_power_state;
-
  /**************************** VL/EISA Routines ********************************/
  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0) \
    && (defined(__i386__) || defined(__alpha__)) \
@@ -893,8 +855,6 @@

  /******************************* PCI Routines *********************************/
  #ifdef CONFIG_PCI
-void			 ahc_power_state_change(struct ahc_softc *ahc,
-						ahc_power_state new_state);
  int			 ahc_linux_pci_init(void);
  void			 ahc_linux_pci_exit(void);
  int			 ahc_pci_map_registers(struct ahc_softc *ahc);
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#47 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c ====
--- /tmp/tmp.26292.6	2004-09-27 12:52:09.522399928 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2003-08-14 15:04:10.000000000 -0400
@@ -36,11 +36,17 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#47 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#48 $
   */

  #include "aic7xxx_osm.h"

+/*
+ * Include aiclib_pci.c as part of our
+ * "module dependencies are hard" work around.
+ */
+#include "aiclib_pci.c"
+
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
  struct pci_device_id
  {
@@ -381,42 +387,3 @@
  	
  	return (-error);
  }
-
-void
-ahc_power_state_change(struct ahc_softc *ahc, ahc_power_state new_state)
-{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-	pci_set_power_state(ahc->dev_softc, new_state);
-#else
-	uint32_t cap;
-	u_int cap_offset;
-
-	/*
-	 * Traverse the capability list looking for
-	 * the power management capability.
-	 */
-	cap = 0;
-	cap_offset = ahc_pci_read_config(ahc->dev_softc,
-					 PCIR_CAP_PTR, /*bytes*/1);
-	while (cap_offset != 0) {
-
-		cap = ahc_pci_read_config(ahc->dev_softc,
-					  cap_offset, /*bytes*/4);
-		if ((cap & 0xFF) == 1
-		 && ((cap >> 16) & 0x3) > 0) {
-			uint32_t pm_control;
-
-			pm_control = ahc_pci_read_config(ahc->dev_softc,
-							 cap_offset + 4,
-							 /*bytes*/4);
-			pm_control &= ~0x3;
-			pm_control |= new_state;
-			ahc_pci_write_config(ahc->dev_softc,
-					     cap_offset + 4,
-					     pm_control, /*bytes*/2);
-			break;
-		}
-		cap_offset = (cap >> 8) & 0xFF;
-	}
-#endif
-}
==== //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#70 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c ====
--- /tmp/tmp.26292.7	2004-09-27 12:52:09.965332592 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c	2003-08-15 12:37:51.000000000 -0400
@@ -39,7 +39,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#70 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx_pci.c#71 $
   *
   * $FreeBSD$
   */
@@ -798,7 +798,7 @@
  	ahc->chip |= AHC_PCI;
  	ahc->description = entry->name;

-	ahc_power_state_change(ahc, AHC_POWER_STATE_D0);
+	ahc_power_state_change(ahc, AIC_POWER_STATE_D0);

  	error = ahc_pci_map_registers(ahc);
  	if (error != 0)
@@ -2095,7 +2095,7 @@
  ahc_pci_resume(struct ahc_softc *ahc)
  {

-	ahc_power_state_change(ahc, AHC_POWER_STATE_D0);
+	ahc_power_state_change(ahc, AIC_POWER_STATE_D0);

  	/*
  	 * We assume that the OS has restored our register
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.c#9 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c ====
--- /tmp/tmp.26292.8	2004-09-27 12:52:10.227292768 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c	2003-08-27 12:49:21.000000000 -0400
@@ -1417,6 +1417,7 @@
  aic_sysrq_handler(int key, struct pt_regs *unused, struct kbd_struct *unused1,
  		  struct tty_struct *unused2)
  {
+#ifdef CONFIG_MAGIC_SYSRQ
  	struct aic_softc *aic;
  	u_long l;

@@ -1430,11 +1431,13 @@
  		aic_unlock(aic, &s);
  	}
  	aic_list_unlock(&l);
+#endif
  }

  int
-aic_install_sysrq(struct sysrq_key_op *key_op)
+aic_install_sysrq(struct aic_sysrq_key_op *key_op)
  {
+#ifdef CONFIG_MAGIC_SYSRQ
  	char *str;
  	int len;
  	int i;
@@ -1452,12 +1455,15 @@
  			return (key);
  		}
  	}
+#endif
  	return (0);
  }

  void
-aic_remove_sysrq(int key, struct sysrq_key_op *key_op)
+aic_remove_sysrq(int key, struct aic_sysrq_key_op *key_op)
  {
+#ifdef CONFIG_MAGIC_SYSRQ
  	unregister_sysrq_key(key, key_op);
+#endif
  }

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.h#11 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h ====
--- /tmp/tmp.26292.9	2004-09-27 12:52:10.457257808 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h	2003-08-28 16:37:39.000000000 -0400
@@ -1,4 +1,5 @@
  /*
+ * SCSI definitions...
   * Largely written by Julian Elischer (julian@tfs.com)
   * for TRW Financial Systems.
   *
@@ -867,6 +868,68 @@

  extern const char *scsi_sense_key_text[];

+/******************************* PCI Definitions ******************************/
+/*
+ * PCIM_xxx: mask to locate subfield in register
+ * PCIR_xxx: config register offset
+ * PCIC_xxx: device class
+ * PCIS_xxx: device subclass
+ * PCIP_xxx: device programming interface
+ * PCIV_xxx: PCI vendor ID (only required to fixup ancient devices)
+ * PCID_xxx: device ID
+ */
+#define PCIR_DEVVENDOR		0x00
+#define PCIR_VENDOR		0x00
+#define PCIR_DEVICE		0x02
+#define PCIR_COMMAND		0x04
+#define PCIM_CMD_PORTEN		0x0001
+#define PCIM_CMD_MEMEN		0x0002
+#define PCIM_CMD_BUSMASTEREN	0x0004
+#define PCIM_CMD_MWRICEN	0x0010
+#define PCIM_CMD_PERRESPEN	0x0040
+#define	PCIM_CMD_SERRESPEN	0x0100
+#define PCIR_STATUS		0x06
+#define PCIR_REVID		0x08
+#define PCIR_PROGIF		0x09
+#define PCIR_SUBCLASS		0x0a
+#define PCIR_CLASS		0x0b
+#define PCIR_CACHELNSZ		0x0c
+#define PCIR_LATTIMER		0x0d
+#define PCIR_HEADERTYPE		0x0e
+#define PCIM_MFDEV		0x80
+#define PCIR_BIST		0x0f
+#define PCIR_CAP_PTR		0x34
+
+/* config registers for header type 0 devices */
+#define PCIR_MAPS	0x10
+#define PCIR_SUBVEND_0	0x2c
+#define PCIR_SUBDEV_0	0x2e
+
+typedef enum
+{
+	AIC_POWER_STATE_D0,
+	AIC_POWER_STATE_D1,
+	AIC_POWER_STATE_D2,
+	AIC_POWER_STATE_D3
+} aic_power_state;
+
+/****************************** PCI-X definitions *****************************/
+#define PCIXR_COMMAND	0x96
+#define PCIXR_DEVADDR	0x98
+#define PCIXM_DEVADDR_FNUM	0x0003	/* Function Number */
+#define PCIXM_DEVADDR_DNUM	0x00F8	/* Device Number */
+#define PCIXM_DEVADDR_BNUM	0xFF00	/* Bus Number */
+#define PCIXR_STATUS	0x9A
+#define PCIXM_STATUS_64BIT	0x0001	/* Active 64bit connection to device. */
+#define PCIXM_STATUS_133CAP	0x0002	/* Device is 133MHz capable */
+#define PCIXM_STATUS_SCDISC	0x0004	/* Split Completion Discarded */
+#define PCIXM_STATUS_UNEXPSC	0x0008	/* Unexpected Split Completion */
+#define PCIXM_STATUS_CMPLEXDEV	0x0010	/* Device Complexity (set == bridge) */
+#define PCIXM_STATUS_MAXMRDBC	0x0060	/* Maximum Burst Read Count */
+#define PCIXM_STATUS_MAXSPLITS	0x0380	/* Maximum Split Transactions */
+#define PCIXM_STATUS_MAXCRDS	0x1C00	/* Maximum Cumulative Read Size */
+#define PCIXM_STATUS_RCVDSCEM	0x2000	/* Received a Split Comp w/Error msg */
+
  /************************* Large Disk Handling ********************************/
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  static __inline int aic_sector_div(u_long capacity, int heads, int sectors);
@@ -913,6 +976,7 @@
  #define	aic_inquiry_match		AIC_LIB_ENTRY(_inquiry_match)
  #define	aic_static_inquiry_match	AIC_LIB_ENTRY(_static_inquiry_match)
  #define	aic_parse_brace_option		AIC_LIB_ENTRY(_parse_brace_option)
+#define	aic_power_state_change		AIC_LIB_ENTRY(_power_state_change)
  #define	aic_sysrq_handler		AIC_LIB_ENTRY(_sysrq_handler)
  #define	aic_install_sysrq		AIC_LIB_ENTRY(_install_sysrq)
  #define	aic_remove_sysrq		AIC_LIB_ENTRY(_remove_sysrq)
@@ -929,12 +993,22 @@
  /************************* Magic SysReq Support *******************************/
  #include <linux/sysrq.h>

+#ifdef CONFIG_MAGIC_SYSRQ
+#define aic_sysrq_key_op sysrq_key_op
+#else
+struct aic_sysrq_key_op {
+	void (*handler)(int, struct pt_regs *, struct kbd_struct *,
+			struct tty_struct *);
+	char *help_msg;
+	char *action_msg;
+};
+#endif
  void			aic_sysrq_handler(int, struct pt_regs *,
  					  struct kbd_struct *,
  					  struct tty_struct *);
-int			aic_install_sysrq(struct sysrq_key_op *);
+int			aic_install_sysrq(struct aic_sysrq_key_op *);
  void			aic_remove_sysrq(int key,
-					 struct sysrq_key_op *key_op);
+					 struct aic_sysrq_key_op *key_op);

  /************************ SCSI Library Functions *****************************/
  void			aic_sense_desc(int /*sense_key*/, int /*asc*/,
@@ -1066,4 +1140,10 @@
  	return (rv);
  }

+/*************************** Forward Declarations *****************************/
+struct aic_softc;
+
+/******************************* PCI Funcitons ******************************/
+void aic_power_state_change(struct aic_softc *aic, aic_power_state new_state);
+
  #endif /*_AICLIB_H */


