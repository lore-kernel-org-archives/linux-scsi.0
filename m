From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 14/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:06:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415961C3.5020202@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:203 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267745AbUI1NGU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:06:20 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD6JW02938
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:06:19 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD6Im31150
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:06:18 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2437-2541)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#7 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx ====
--- /tmp/tmp.26656.0	2004-09-27 13:16:28.895541488 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx	2003-10-30 22:15:43.000000000 -0500
@@ -1,6 +1,6 @@
  #
  # AIC7XXX and AIC79XX 2.5.X Kernel configuration File.
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#7 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Kconfig.aic7xxx#8 $
  #
  config SCSI_AIC7XXX
  	tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
@@ -11,11 +11,6 @@
  	SCSI controllers (the 274x and 284x series).  For AAA and ARO based
  	configurations, only SCSI functionality is provided.

-	If you want to compile the driver as a module ( = code which can be
-	inserted in and removed from the running kernel whenever you want),
-	say M here and read <file:Documentation/modules.txt>.  The module
-	will be called aic7xxx.
-
  config AIC7XXX_CMDS_PER_DEVICE
  	int "Maximum number of TCQ commands per device"
  	depends on SCSI_AIC7XXX
==== //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#7 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Makefile ====
--- /tmp/tmp.26656.1	2004-09-27 13:16:28.922537384 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/Makefile	2003-11-04 14:05:52.000000000 -0500
@@ -1,7 +1,7 @@
  #
  # Makefile for the Linux aic7xxx SCSI driver.
  #
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#7 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#8 $
  #

  # Let kbuild descend into aicasm when cleaning
@@ -58,6 +58,13 @@
  	-p $(obj)/aic7xxx_reg_print.c -i aic7xxx_osm.h

  ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
+# Create a dependency chain in generated files
+# to avoid concurrent invocations of the single
+# rule that builds them all.
+aic7xxx_seq.h: aic7xxx_reg.h
+ifeq ($(CONFIG_AIC7XXX_REG_PRETTY_PRINT),y)
+aic7xxx_reg.h: aic7xxx_reg_print.c
+endif
  $(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
  	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
  			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
@@ -72,6 +79,13 @@
  	-p $(obj)/aic79xx_reg_print.c -i aic79xx_osm.h

  ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
+# Create a dependency chain in generated files
+# to avoid concurrent invocations of the single
+# rule that builds them all.
+aic79xx_seq.h: aic79xx_reg.h
+ifeq ($(CONFIG_AIC79XX_REG_PRETTY_PRINT),y)
+aic79xx_reg.h: aic79xx_reg_print.c
+endif
  $(aic79xx-gen-y): $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
  	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
  			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
==== //depot/aic7xxx/aic7xxx/aic7770.c#32 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770.c ====
--- /tmp/tmp.26656.2	2004-09-27 13:16:28.998525832 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770.c	2003-10-30 22:17:01.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7770.c#32 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7770.c#33 $
   *
   * $FreeBSD$
   */
@@ -175,7 +175,7 @@
  	case 15:
  		break;
  	default:
-		printf("aic7770_config: illegal irq setting %d\n", intdef);
+		printf("aic7770_config: invalid irq setting %d\n", intdef);
  		return (ENXIO);
  	}

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#15 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c ====
--- /tmp/tmp.26656.3	2004-09-27 13:16:29.062516104 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c	2003-10-30 23:50:24.000000000 -0500
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#15 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7770_osm.c#16 $
   */

  #include "aic7xxx_osm.h"
@@ -190,6 +190,7 @@
  		free(name, M_DEVBUF);
  		return (ENOMEM);
  	}
+	ahc->dev_softc = dev;
  	error = aic7770_config(ahc, entry, eisaBase);
  	if (error != 0) {
  		ahc->bsh.ioport = 0;
==== //depot/aic7xxx/aic7xxx/aic79xx.seq#105 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq ====
--- /tmp/tmp.26656.4	2004-09-27 13:16:29.587436304 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq	2003-12-04 00:13:47.000000000 -0500
@@ -40,7 +40,7 @@
   * $FreeBSD$
   */

-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#105 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#106 $"
  PATCH_ARG_LIST = "struct ahd_softc *ahd"
  PREFIX = "ahd_"

@@ -108,9 +108,9 @@
  	call	idle_loop_cchan;
  	jmp	idle_loop;

-BEGIN_CRITICAL;
  idle_loop_gsfifo:
  	SET_MODE(M_SCSI, M_SCSI)
+BEGIN_CRITICAL;
  idle_loop_gsfifo_in_scsi_mode:
  	test	LQISTAT2, LQIGSAVAIL jz return;
  	/*
@@ -159,11 +159,15 @@

  idle_loop_service_fifos:
  	SET_MODE(M_DFF0, M_DFF0)
+BEGIN_CRITICAL;
  	test	LONGJMP_ADDR[1], INVALID_ADDR jnz idle_loop_next_fifo;
  	call	longjmp;
+END_CRITICAL;
  idle_loop_next_fifo:
  	SET_MODE(M_DFF1, M_DFF1)
+BEGIN_CRITICAL;
  	test	LONGJMP_ADDR[1], INVALID_ADDR jz longjmp;
+END_CRITICAL;
  return:
  	ret;

@@ -177,7 +181,6 @@
  	test	CCSCBCTL, CCARREN|CCSCBEN jz scbdma_idle;
  	test	CCSCBCTL, CCSCBDIR jnz fetch_new_scb_inprog;
  	test	CCSCBCTL, CCSCBDONE jz return;
-END_CRITICAL;
  	/* FALLTHROUGH */
  scbdma_tohost_done:
  	test	CCSCBCTL, CCARREN jz fill_qoutfifo_dmadone;
@@ -207,6 +210,7 @@
  	test	QOFF_CTLSTA, SDSCB_ROLLOVR jz return;
  	bmov	QOUTFIFO_NEXT_ADDR, SHARED_DATA_ADDR, 4;
  	xor	QOUTFIFO_ENTRY_VALID_TAG, QOUTFIFO_ENTRY_VALID_TOGGLE ret;
+END_CRITICAL;

  qoutfifo_updated:
  	/*
@@ -541,6 +545,7 @@
  SET_SRC_MODE	M_SCSI;
  SET_DST_MODE	M_SCSI;
  select_out:
+BEGIN_CRITICAL;
  	if ((ahd->bugs & AHD_FAINT_LED_BUG) != 0) {
  		/*
  		 * On Rev A. hardware, the busy LED is only
@@ -556,7 +561,6 @@
  		 */
  		or	SBLKCTL, DIAGLEDEN|DIAGLEDON;
  	}
-BEGIN_CRITICAL;
  	/* Clear out all SCBs that have been successfully sent. */
  	if ((ahd->bugs & AHD_SENT_SCB_UPDATE_BUG) != 0) {
  		/*
@@ -1868,7 +1872,6 @@
  	dec	SCB_FIFO_USE_COUNT;
  	test	SCB_CONTROL, STATUS_RCVD jnz pkt_complete_scb_if_fifos_idle;
  	mvi	DFFSXFRCTL, CLRCHN ret;
-END_CRITICAL;

  /*
   * LAST_SEG_DONE status has been seen in the current FIFO.
@@ -1877,7 +1880,6 @@
   * Check for overrun and see if we can complete this command.
   */
  pkt_last_seg_done:
-BEGIN_CRITICAL;
  	/*
  	 * Mark transfer as completed.
  	 */
==== //depot/aic7xxx/aic7xxx/aic79xx.c#219 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.26656.5	2004-09-27 13:16:31.763105552 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2003-12-04 00:47:22.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#219 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#220 $
   *
   * $FreeBSD$
   */
@@ -3190,11 +3190,13 @@
  		iocell_opts[AHD_PRECOMP_SLEW_INDEX] &= ~AHD_PRECOMP_MASK;

  		if ((ahd->features & AHD_NEW_IOCELL_OPTS) != 0
-		 && (ppr_opts & MSG_EXT_PPR_DT_REQ) != 0) {
+		 && (ppr_opts & MSG_EXT_PPR_DT_REQ) != 0
+		 && (ppr_opts & MSG_EXT_PPR_IU_REQ) == 0) {
  			/*
  			 * Slow down our CRC interval to be
-			 * compatible with devices that can't
-			 * handle a CRC at full speed.
+			 * compatible with non-packetized
+			 * U160 devices that can't handle a
+			 * CRC at full speed.
  			 */
  			con_opts |= ENSLOWCRC;
  		}
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#188 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c ====
--- /tmp/tmp.26656.6	2004-09-27 13:16:32.967922392 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-11-06 17:10:19.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC79xx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#188 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.c#192 $
   *
   * --------------------------------------------------------------------------
   * Copyright (c) 1994-2000 Justin T. Gibbs.
@@ -651,9 +651,9 @@
  		struct scatterlist *sg;

  		sg = (struct scatterlist *)cmd->request_buffer;
-		pci_unmap_sg(ahd->dev_softc, sg, cmd->use_sg, direction);
+		aic_unmap_sg(ahd, sg, cmd->use_sg, direction);
  	} else if (cmd->request_bufflen != 0) {
-		pci_unmap_single(ahd->dev_softc,
+		aic_unmap_single(ahd,
  				 scb->platform_data->buf_busaddr,
  				 cmd->request_bufflen, direction);
  	}
@@ -1215,8 +1215,7 @@
  	 && (dev->flags & AIC_DEV_SLAVE_CONFIGURED) != 0) {
  		dev->flags |= AIC_DEV_UNCONFIGURED;
  		if (TAILQ_EMPTY(&dev->busyq)
-		 && dev->active == 0
-		 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
  			ahd_linux_free_device(ahd, dev);
  	}
  	ahd_midlayer_entrypoint_unlock(ahd, &flags);
@@ -1777,50 +1776,8 @@
  	return (SUCCESS);
  }

-Scsi_Host_Template aic79xx_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= "aic79xx",
-	.proc_info		= ahd_linux_proc_info,
-	.info			= ahd_linux_info,
-	.queuecommand		= ahd_linux_queue,
-	.eh_abort_handler	= ahd_linux_abort,
-	.eh_device_reset_handler = ahd_linux_dev_reset,
-	.eh_bus_reset_handler	= ahd_linux_bus_reset,
-#if defined(__i386__)
-	.bios_param		= ahd_linux_biosparam,
-#endif
-	.can_queue		= AHD_MAX_QUEUE,
-	.this_id		= -1,
-	.cmd_per_lun		= 2,
-	.use_clustering		= ENABLE_CLUSTERING,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
-	/*
-	 * We can only map 16MB per-SG
-	 * so create a sector limit of
-	 * "16MB" in 2K sectors.
-	 */
-	.max_sectors		= 8192,
-#endif
-#if defined CONFIG_HIGHIO || LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,10)
-/* Assume RedHat Distribution with its different HIGHIO conventions. */
-	.can_dma_32		= 1,
-	.single_sg_okay		= 1,
-#else
-	.highmem_io		= 1,
-#endif
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	.slave_alloc		= ahd_linux_slave_alloc,
-	.slave_configure	= ahd_linux_slave_configure,
-	.slave_destroy		= ahd_linux_slave_destroy,
-#else
-	.detect			= ahd_linux_detect,
-	.release		= ahd_linux_release,
-	.select_queue_depths	= ahd_linux_select_queue_depth,
-	.use_new_eh_code	= 1,
-#endif
-};
+Scsi_Host_Template aic79xx_driver_template =
+	AIC_TEMPLATE_INITIALIZER("aic79xx", /*max_sectors*/8192);

  /********************* Platform Dependent Functions ***************************/
  /*
@@ -2045,9 +2002,16 @@
  	char	*new_name;
  	u_long	s;
  	u_long	target;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	int	error;
+#endif

  	template->name = ahd->description;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	host = scsi_host_alloc(template, sizeof(struct ahd_softc *));
+#else
  	host = scsi_register(template, sizeof(struct ahd_softc *));
+#endif
  	if (host == NULL)
  		return (ENOMEM);

@@ -2133,7 +2097,10 @@
  	ahd_unlock(ahd, &s);

  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_add_host(host, &ahd->dev_softc->dev);
+	error = scsi_add_host(host, ahd->dev_softc);
+	if (error != 0)
+		return (-error);
+	scsi_scan_host(host);
  #endif
  	return (0);
  }
@@ -2265,8 +2232,10 @@
  		if (ahd->platform_data->host != NULL) {
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
  			scsi_remove_host(ahd->platform_data->host);
-#endif
+			scsi_host_put(ahd->platform_data->host);
+#else
  			scsi_unregister(ahd->platform_data->host);
+#endif
  		}

  		/* destroy all of the device and target objects */
@@ -2280,6 +2249,7 @@
  					if (targ->devices[j] == NULL)
  						continue;
  					dev = targ->devices[j];
+					del_timer_sync(&dev->timer);
  					ahd_linux_free_device(ahd, dev);
  				}
  				/*
@@ -4122,8 +4092,7 @@

  			cur_seg = (struct scatterlist *)cmd->request_buffer;
  			dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
-			nseg = pci_map_sg(ahd->dev_softc, cur_seg,
-					  cmd->use_sg, dir);
+			nseg = aic_map_sg(ahd, cur_seg, cmd->use_sg, dir);
  			scb->platform_data->xfer_len = 0;
  			for (sg = scb->sg_list; nseg > 0; nseg--, cur_seg++) {
  				bus_addr_t addr;
@@ -4142,7 +4111,7 @@

  			sg = scb->sg_list;
  			dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
-			addr = pci_map_single(ahd->dev_softc,
+			addr = aic_map_single(ahd,
  					      cmd->request_buffer,
  					      cmd->request_bufflen, dir);
  			scb->platform_data->xfer_len = cmd->request_bufflen;
@@ -4532,8 +4501,7 @@

  	if (TAILQ_EMPTY(&dev->busyq)) {
  		if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
-		 && dev->active == 0
-		 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
  			ahd_linux_free_device(ahd, dev);
  	} else if ((dev->flags & AIC_DEV_ON_RUN_LIST) == 0) {
  		TAILQ_INSERT_TAIL(&ahd->platform_data->device_runq, dev, links);
@@ -5055,6 +5023,7 @@
  	 && (dev->flags & AIC_DEV_ON_RUN_LIST) == 0)
  		ahd_linux_run_device_queue(ahd, dev);
  	if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
+	 && TAILQ_EMPTY(&dev->busyq)
  	 && dev->active == 0)
  		ahd_linux_free_device(ahd, dev);
  	ahd_unlock(ahd, &s);
@@ -5071,13 +5040,12 @@
  	int i;

  	host = ahd->platform_data->host;
-	printf("%s: Host Status: %s%s%s%s%s\n",
+	printf("%s: Host Status: Failed(%d) %s%s%s\n",
  	       ahd_name(ahd),
+	       host->host_failed,
  	       host->eh_active ? "eh_active " : "",
-	       host->in_recovery ? "in_recovery " : "",
  	       host->host_blocked ? "host_blocked " : "",
-	       host->host_self_blocked ? "host_self_blocked " : "",
-	       host->some_device_starved ? "some_device_starved" : "");
+	       host->host_self_blocked ? "host_self_blocked " : "");
  	
  	maxtarget = (ahd->features & AHD_WIDE) ? 15 : 7;
  	for (target = 0; target <=maxtarget; target++) {
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#149 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.26656.7	2004-09-27 13:16:33.711809304 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2003-11-04 14:17:43.000000000 -0500
@@ -36,23 +36,13 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#149 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#152 $
   *
   */
  #ifndef _AIC79XX_LINUX_H_
  #define _AIC79XX_LINUX_H_

-#include <linux/types.h>
-#include <linux/blk.h>
-#include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <linux/ioport.h>
-#include <linux/pci.h>
-#include <linux/smp_lock.h>
  #include <linux/version.h>
-#include <linux/module.h>
-#include <asm/byteorder.h>
-#include <asm/io.h>

  #ifndef KERNEL_VERSION
  #define KERNEL_VERSION(x,y,z) (((x)<<16)+((y)<<8)+(z))
@@ -60,27 +50,8 @@

  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  #include <linux/config.h>
-#include <linux/slab.h>
-#else
-#include <linux/malloc.h>
-#endif
-
-/* Core SCSI definitions */
-#define AIC_LIB_PREFIX ahd
-#define AIC_CONST_PREFIX AHD
-#include "scsi.h"
-#include "hosts.h"
-
-/* Name space conflict with BSD queue macros */
-#ifdef LIST_HEAD
-#undef LIST_HEAD
  #endif

-#include "cam.h"
-#include "queue.h"
-#include "scsi_message.h"
-#include "scsi_iu.h"
-
  /*********************************** Debugging ********************************/
  #ifdef CONFIG_AIC79XX_DEBUG_ENABLE
  #ifdef CONFIG_AIC79XX_DEBUG_MASK
@@ -96,16 +67,11 @@
  /* No debugging code. */
  #endif

-/************************* Configuration Data *********************************/
-extern uint32_t aic79xx_allow_memio;
-extern int aic79xx_detect_complete;
-extern Scsi_Host_Template aic79xx_driver_template;
-
-/***************************** Domain Validation ******************************/
-void ahd_linux_dv_complete(Scsi_Cmnd *cmd);
-void ahd_linux_dv_timeout(struct scsi_cmnd *cmd);
-
  /********************************** Includes **********************************/
+/* Core SCSI definitions */
+#define AIC_LIB_PREFIX ahd
+#define AIC_CONST_PREFIX AHD
+
  #ifdef CONFIG_AIC79XX_REG_PRETTY_PRINT
  #define AIC_DEBUG_REGISTERS 1
  #else
@@ -114,6 +80,15 @@
  #define AIC_CORE_INCLUDE "aic79xx.h"
  #include "aiclib.h"

+/************************* Configuration Data *********************************/
+extern uint32_t aic79xx_allow_memio;
+extern int aic79xx_detect_complete;
+extern Scsi_Host_Template aic79xx_driver_template;
+
+/***************************** Domain Validation ******************************/
+void ahd_linux_dv_complete(Scsi_Cmnd *cmd);
+void ahd_linux_dv_timeout(struct scsi_cmnd *cmd);
+
  /***************************** SMP support ************************************/
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
  #include <linux/spinlock.h>
@@ -127,7 +102,7 @@
  #define AHD_SCSI_HAS_HOST_LOCK 0
  #endif

-#define AIC79XX_DRIVER_VERSION "2.0.3"
+#define AIC79XX_DRIVER_VERSION "2.0.4"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#28 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c ====
--- /tmp/tmp.26656.8	2004-09-27 13:16:34.612672352 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2003-10-31 18:32:28.000000000 -0500
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#28 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c#29 $
   */

  #include "aic79xx_osm.h"
@@ -76,10 +76,10 @@
  MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);

  struct pci_driver aic79xx_pci_driver = {
-	name:		"aic79xx",
-	probe:		ahd_linux_pci_dev_probe,
-	remove:		ahd_linux_pci_dev_remove,
-	id_table:	ahd_linux_pci_id_table
+	.name		= "aic79xx",
+	.probe		= ahd_linux_pci_dev_probe,
+	.remove		= ahd_linux_pci_dev_remove,
+	.id_table	= ahd_linux_pci_id_table
  };

  static void
@@ -114,7 +114,7 @@
  {
  	char		 buf[80];
  	struct		 ahd_softc *ahd;
-	aic_dev_softc_t	 pci;
+	aic_dev_softc_t	 dev;
  	struct		 ahd_pci_identity *entry;
  	char		*name;
  	int		 error;
@@ -125,7 +125,7 @@
  	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
  		struct pci_dev *probed_pdev;

-		probed_pdev = ahd->dev_softc;
+		probed_pdev = aic_pci_dev(ahd);
  		if (probed_pdev->bus->number == pdev->bus->number
  		 && probed_pdev->devfn == pdev->devfn)
  			break;
@@ -135,8 +135,8 @@
  		return (-ENODEV);
  	}

-	pci = pdev;
-	entry = ahd_find_pci_device(pci);
+	dev = aic_pci_dev_to_dev(pdev);
+	entry = ahd_find_pci_device(dev);
  	if (entry == NULL)
  		return (-ENODEV);

@@ -146,9 +146,9 @@
  	 * common detect routine.
  	 */
  	sprintf(buf, "ahd_pci:%d:%d:%d",
-		aic_get_pci_bus(pci),
-		aic_get_pci_slot(pci),
-		aic_get_pci_function(pci));
+		aic_get_pci_bus(dev),
+		aic_get_pci_slot(dev),
+		aic_get_pci_function(dev));
  	name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
  	if (name == NULL)
  		return (-ENOMEM);
@@ -156,6 +156,7 @@
  	ahd = ahd_alloc(NULL, name);
  	if (ahd == NULL)
  		return (-ENOMEM);
+	ahd->dev_softc = dev;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  	if (pci_enable_device(pdev)) {
  		ahd_free(ahd);
@@ -172,20 +173,19 @@
  		mask_64bit = (bus_addr_t)0xFFFFFFFFFFFFFFFFULL;
  		mask_39bit = (bus_addr_t)0x7FFFFFFFFFULL;
  		if (memsize >= 0x8000000000ULL
-	 	 && aic_pci_set_dma_mask(pdev, mask_64bit) == 0) {
+	 	 && aic_set_dma_mask(ahd, mask_64bit) == 0) {
  			ahd->flags |= AHD_64BIT_ADDRESSING;
  			ahd->platform_data->hw_dma_mask = mask_64bit;
  		} else if (memsize > 0x80000000
-			&& aic_pci_set_dma_mask(pdev, mask_39bit) == 0) {
+			&& aic_set_dma_mask(ahd, mask_39bit) == 0) {
  			ahd->flags |= AHD_39BIT_ADDRESSING;
  			ahd->platform_data->hw_dma_mask = mask_39bit;
  		}
  	} else {
-		aic_pci_set_dma_mask(pdev, 0xFFFFFFFF);
+		aic_set_dma_mask(ahd, 0xFFFFFFFF);
  		ahd->platform_data->hw_dma_mask = 0xFFFFFFFF;
  	}
  #endif
-	ahd->dev_softc = pci;
  	error = ahd_pci_config(ahd, entry);
  	if (error != 0) {
  		ahd_free(ahd);
@@ -224,10 +224,8 @@
  	pdev = NULL;
  	class = PCI_CLASS_STORAGE_SCSI << 8;
  	while ((pdev = pci_find_class(class, pdev)) != NULL) {
-		aic_dev_softc_t pci;
  		int error;

-		pci = pdev;
  		error = ahd_linux_pci_dev_probe(pdev, /*pci_devid*/NULL);
  		if (error == 0)
  			found++;
@@ -246,14 +244,15 @@
  ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd, u_long *base,
  				 u_long *base2)
  {
+
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
-	*base = pci_resource_start(ahd->dev_softc, 0);
+	*base = pci_resource_start(aic_pci_dev(ahd), 0);
  	/*
  	 * This is really the 3rd bar and should be at index 2,
  	 * but the Linux PCI code doesn't know how to "count" 64bit
  	 * bars.
  	 */
-	*base2 = pci_resource_start(ahd->dev_softc, 3);
+	*base2 = pci_resource_start(aic_pci_dev(ahd), 3);
  #else
  	*base = aic_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR0, 4);
  	*base2 = aic_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR1, 4);
@@ -297,7 +296,7 @@

  	error = 0;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
-	start = pci_resource_start(ahd->dev_softc, 1);
+	start = pci_resource_start(aic_pci_dev(ahd), 1);
  	base_page = start & PAGE_MASK;
  	base_offset = start - base_page;
  #else
@@ -405,10 +404,10 @@
  {
  	int error;

-	error = request_irq(ahd->dev_softc->irq, ahd_linux_isr,
+	error = request_irq(aic_pci_dev(ahd)->irq, ahd_linux_isr,
  			    SA_SHIRQ, "aic79xx", ahd);
  	if (error == 0)
-		ahd->platform_data->irq = ahd->dev_softc->irq;
+		ahd->platform_data->irq = aic_pci_dev(ahd)->irq;
  	
  	return (-error);
  }
==== //depot/aic7xxx/aic7xxx/aic7xxx.reg#39 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.reg ====
--- /tmp/tmp.26656.9	2004-09-27 13:16:35.165588296 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.reg	2003-11-03 14:00:18.000000000 -0500
@@ -39,7 +39,7 @@
   *
   * $FreeBSD$
   */
-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#39 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $"

  /*
   * This file is processed by the aic7xxx_asm utility for use in assembling
@@ -1306,7 +1306,6 @@
  	 */
  	MWI_RESIDUAL {
  		size		1
-		alias	TARG_IMMEDIATE_SCB
  	}
  	/*
  	 * SCBID of the next SCB to be started by the controller.
@@ -1461,6 +1460,7 @@
  	 */
  	LAST_MSG {
  		size		1
+		alias	TARG_IMMEDIATE_SCB
  	}

  	/*
==== //depot/aic7xxx/aic7xxx/aic7xxx.c#144 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c ====
--- /tmp/tmp.26656.10	2004-09-27 13:16:36.640364096 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c	2003-11-07 14:07:15.000000000 -0500
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#144 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#145 $
   *
   * $FreeBSD$
   */
@@ -5115,8 +5115,14 @@
  	ahc->flags |= AHC_ALL_INTERRUPTS;
  	paused = FALSE;
  	do {
-		if (paused)
+		if (paused) {
  			ahc_unpause(ahc);
+			/*
+			 * Give the sequencer some time to service
+			 * any active selections.
+			 */
+			aic_delay(200);
+		}
  		ahc_intr(ahc);
  		ahc_pause(ahc);
  		paused = TRUE;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#251 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.26656.11	2004-09-27 13:16:37.476237024 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-11-06 17:11:24.000000000 -0500
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#251 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#255 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -139,7 +139,6 @@
  #endif

  #include <linux/mm.h>		/* For fetching system memory size */
-#include <linux/blk.h>		/* For block_size() */

  /************************* Magic SysReq Support *******************************/
  static struct aic_sysrq_key_op ahc_sysrq_op =
@@ -658,10 +657,10 @@
  		struct scatterlist *sg;

  		sg = (struct scatterlist *)cmd->request_buffer;
-		pci_unmap_sg(ahc->dev_softc, sg, cmd->use_sg,
+		aic_unmap_sg(ahc, sg, cmd->use_sg,
  			     scsi_to_pci_dma_dir(cmd->sc_data_direction));
  	} else if (cmd->request_bufflen != 0) {
-		pci_unmap_single(ahc->dev_softc,
+		aic_unmap_single(ahc,
  				 scb->platform_data->buf_busaddr,
  				 cmd->request_bufflen,
  				 scsi_to_pci_dma_dir(cmd->sc_data_direction));
@@ -1218,8 +1217,7 @@
  	 && (dev->flags & AIC_DEV_SLAVE_CONFIGURED) != 0) {
  		dev->flags |= AIC_DEV_UNCONFIGURED;
  		if (TAILQ_EMPTY(&dev->busyq)
-		 && dev->active == 0
-	 	 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
  			ahc_linux_free_device(ahc, dev);
  	}
  	ahc_midlayer_entrypoint_unlock(ahc, &flags);
@@ -1413,50 +1411,8 @@
  	return SUCCESS;
  }

-Scsi_Host_Template aic7xxx_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= "aic7xxx",
-	.proc_info		= ahc_linux_proc_info,
-	.info			= ahc_linux_info,
-	.queuecommand		= ahc_linux_queue,
-	.eh_abort_handler	= ahc_linux_abort,
-	.eh_device_reset_handler = ahc_linux_dev_reset,
-	.eh_bus_reset_handler	= ahc_linux_bus_reset,
-#if defined(__i386__)
-	.bios_param		= ahc_linux_biosparam,
-#endif
-	.can_queue		= AHC_MAX_QUEUE,
-	.this_id		= -1,
-	.cmd_per_lun		= 2,
-	.use_clustering		= ENABLE_CLUSTERING,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
-	/*
-	 * We can only map 16MB per-SG
-	 * so create a sector limit of
-	 * "16MB" in 2K sectors.
-	 */
-	.max_sectors		= 8192,
-#endif
-#if defined CONFIG_HIGHIO || LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,10)
-/* Assume RedHat Distribution with its different HIGHIO conventions. */
-	.can_dma_32		= 1,
-	.single_sg_okay		= 1,
-#else
-	.highmem_io		= 1,
-#endif
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	.slave_alloc		= ahc_linux_slave_alloc,
-	.slave_configure	= ahc_linux_slave_configure,
-	.slave_destroy		= ahc_linux_slave_destroy,
-#else
-	.detect			= ahc_linux_detect,
-	.release		= ahc_linux_release,
-	.select_queue_depths	= ahc_linux_select_queue_depth,
-	.use_new_eh_code	= 1,
-#endif
-};
+Scsi_Host_Template aic7xxx_driver_template =
+	AIC_TEMPLATE_INITIALIZER("aic7xxx", /* max_sectors*/8192);

  /******************************** Macros **************************************/
  #define BUILD_SCSIID(ahc, cmd)						    \
@@ -1686,9 +1642,16 @@
  	char	*new_name;
  	u_long	 s;
  	u_int	 targ_offset;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	int	 error;
+#endif

  	template->name = ahc->description;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	host = scsi_host_alloc(template, sizeof(struct ahc_softc *));
+#else
  	host = scsi_register(template, sizeof(struct ahc_softc *));
+#endif
  	if (host == NULL)
  		return (ENOMEM);

@@ -1785,7 +1748,10 @@
  	ahc_unlock(ahc, &s);

  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL));
+	error = scsi_add_host(host, ahc->dev_softc);
+	if (error != 0)
+		return (-error);
+	scsi_scan_host(host);
  #endif
  	return (0);
  }
@@ -1944,8 +1910,10 @@
  		if (ahc->platform_data->host != NULL) {
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
  			scsi_remove_host(ahc->platform_data->host);
-#endif
+			scsi_host_put(ahc->platform_data->host);
+#else
  			scsi_unregister(ahc->platform_data->host);
+#endif
  		}

  		/* destroy all of the device and target objects */
@@ -1959,6 +1927,7 @@
  					if (targ->devices[j] == NULL)
  						continue;
  					dev = targ->devices[j];
+					del_timer_sync(&dev->timer);
  					ahc_linux_free_device(ahc, dev);
  				}
  				/*
@@ -3748,7 +3717,7 @@
  			int	nseg;

  			cur_seg = (struct scatterlist *)cmd->request_buffer;
-			nseg = pci_map_sg(ahc->dev_softc, cur_seg, cmd->use_sg,
+			nseg = aic_map_sg(ahc, cur_seg, cmd->use_sg,
  			    scsi_to_pci_dma_dir(cmd->sc_data_direction));
  			end_seg = cur_seg + nseg;
  			/* Copy the segments into the SG list. */
@@ -3790,7 +3759,7 @@
  			bus_addr_t addr;

  			sg = scb->sg_list;
-			addr = pci_map_single(ahc->dev_softc,
+			addr = aic_map_single(ahc,
  			       cmd->request_buffer,
  			       cmd->request_bufflen,
  			       scsi_to_pci_dma_dir(cmd->sc_data_direction));
@@ -3981,7 +3950,7 @@
  {
  	struct aic_linux_target *targ;

-	del_timer_sync(&dev->timer);
+	del_timer(&dev->timer);
  	targ = dev->target;
  	targ->devices[dev->lun] = NULL;
  	free(dev, M_DEVBUF);
@@ -4234,8 +4203,7 @@

  	if (TAILQ_EMPTY(&dev->busyq)) {
  		if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
-		 && dev->active == 0
-	 	 && (dev->flags & AIC_DEV_TIMER_ACTIVE) == 0)
+		 && dev->active == 0)
  			ahc_linux_free_device(ahc, dev);
  	} else if ((dev->flags & AIC_DEV_ON_RUN_LIST) == 0) {
  		TAILQ_INSERT_TAIL(&ahc->platform_data->device_runq, dev, links);
@@ -4710,7 +4678,8 @@
  	if (dev->qfrozen == 0
  	 && (dev->flags & AIC_DEV_ON_RUN_LIST) == 0)
  		ahc_linux_run_device_queue(ahc, dev);
-	if (TAILQ_EMPTY(&dev->busyq)
+	if ((dev->flags & AIC_DEV_UNCONFIGURED) != 0
+	 && TAILQ_EMPTY(&dev->busyq)
  	 && dev->active == 0)
  		ahc_linux_free_device(ahc, dev);
  	ahc_unlock(ahc, &s);
@@ -5071,13 +5040,12 @@
  	int i;

  	host = ahc->platform_data->host;
-	printf("%s: Host Status: %s%s%s%s%s\n",
+	printf("%s: Host Status: Failed(%d) %s%s%s\n",
  	       ahc_name(ahc),
+	       host->host_failed,
  	       host->eh_active ? "eh_active " : "",
-	       host->in_recovery ? "in_recovery " : "",
  	       host->host_blocked ? "host_blocked " : "",
-	       host->host_self_blocked ? "host_self_blocked " : "",
-	       host->some_device_starved ? "some_device_starved" : "");
+	       host->host_self_blocked ? "host_self_blocked " : "");
  	
  	maxchannel = (ahc->features & AHC_TWIN) ? 1 : 0;
  	maxtarget = (ahc->features & AHC_WIDE) ? 15 : 7;
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#162 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.26656.12	2004-09-27 13:16:37.561224104 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2003-11-04 14:17:11.000000000 -0500
@@ -53,23 +53,13 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#162 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#165 $
   *
   */
  #ifndef _AIC7XXX_LINUX_H_
  #define _AIC7XXX_LINUX_H_

-#include <linux/types.h>
-#include <linux/blk.h>
-#include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <linux/ioport.h>
-#include <linux/pci.h>
-#include <linux/smp_lock.h>
  #include <linux/version.h>
-#include <linux/module.h>
-#include <asm/byteorder.h>
-#include <asm/io.h>

  #ifndef KERNEL_VERSION
  #define KERNEL_VERSION(x,y,z) (((x)<<16)+((y)<<8)+(z))
@@ -77,26 +67,8 @@

  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  #include <linux/config.h>
-#include <linux/slab.h>
-#else
-#include <linux/malloc.h>
-#endif
-
-/* Core SCSI definitions */
-#define AIC_LIB_PREFIX ahc
-#define AIC_CONST_PREFIX AHC
-#include "scsi.h"
-#include "hosts.h"
-
-/* Name space conflict with BSD queue macros */
-#ifdef LIST_HEAD
-#undef LIST_HEAD
  #endif

-#include "cam.h"
-#include "queue.h"
-#include "scsi_message.h"
-
  /*********************************** Debugging ********************************/
  #ifdef CONFIG_AIC7XXX_DEBUG_ENABLE
  #ifdef CONFIG_AIC7XXX_DEBUG_MASK
@@ -111,6 +83,19 @@
  /* No debugging code. */
  #endif

+/********************************** Includes **********************************/
+/* Core SCSI definitions */
+#define AIC_LIB_PREFIX ahc
+#define AIC_CONST_PREFIX AHC
+
+#ifdef CONFIG_AIC7XXX_REG_PRETTY_PRINT
+#define AIC_DEBUG_REGISTERS 1
+#else
+#define AIC_DEBUG_REGISTERS 0
+#endif
+#define	AIC_CORE_INCLUDE "aic7xxx.h"
+#include "aiclib.h"
+
  /************************* Configuration Data *********************************/
  extern u_int aic7xxx_no_probe;
  extern u_int aic7xxx_allow_memio;
@@ -121,15 +106,6 @@
  void ahc_linux_dv_complete(Scsi_Cmnd *cmd);
  void ahc_linux_dv_timeout(struct scsi_cmnd *cmd);

-/********************************** Includes **********************************/
-#ifdef CONFIG_AIC7XXX_REG_PRETTY_PRINT
-#define AIC_DEBUG_REGISTERS 1
-#else
-#define AIC_DEBUG_REGISTERS 0
-#endif
-#define	AIC_CORE_INCLUDE "aic7xxx.h"
-#include "aiclib.h"
-
  /***************************** SMP support ************************************/
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
  #include <linux/spinlock.h>
@@ -143,7 +119,7 @@
  #define AHC_SCSI_HAS_HOST_LOCK 0
  #endif

-#define AIC7XXX_DRIVER_VERSION "6.3.2"
+#define AIC7XXX_DRIVER_VERSION "6.3.3"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#51 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c ====
--- /tmp/tmp.26656.13	2004-09-27 13:16:37.609216808 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2003-10-31 18:32:05.000000000 -0500
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#51 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c#52 $
   */

  #include "aic7xxx_osm.h"
@@ -79,10 +79,10 @@
  MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);

  struct pci_driver aic7xxx_pci_driver = {
-	name:		"aic7xxx",
-	probe:		ahc_linux_pci_dev_probe,
-	remove:		ahc_linux_pci_dev_remove,
-	id_table:	ahc_linux_pci_id_table
+	.name		= "aic7xxx",
+	.probe		= ahc_linux_pci_dev_probe,
+	.remove		= ahc_linux_pci_dev_remove,
+	.id_table	= ahc_linux_pci_id_table
  };

  static void
@@ -118,7 +118,7 @@
  	char		 buf[80];
  	bus_addr_t	 mask_39bit;
  	struct		 ahc_softc *ahc;
-	aic_dev_softc_t	 pci;
+	aic_dev_softc_t	 dev;
  	struct		 ahc_pci_identity *entry;
  	char		*name;
  	int		 error;
@@ -129,7 +129,7 @@
  	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
  		struct pci_dev *probed_pdev;

-		probed_pdev = ahc->dev_softc;
+		probed_pdev = aic_dev_to_pci_dev(ahc->dev_softc);
  		if (probed_pdev->bus->number == pdev->bus->number
  		 && probed_pdev->devfn == pdev->devfn)
  			break;
@@ -139,8 +139,8 @@
  		return (-ENODEV);
  	}

-	pci = pdev;
-	entry = ahc_find_pci_device(pci);
+	dev = aic_pci_dev_to_dev(pdev);
+	entry = ahc_find_pci_device(dev);
  	if (entry == NULL)
  		return (-ENODEV);

@@ -150,9 +150,9 @@
  	 * common detect routine.
  	 */
  	sprintf(buf, "ahc_pci:%d:%d:%d",
-		aic_get_pci_bus(pci),
-		aic_get_pci_slot(pci),
-		aic_get_pci_function(pci));
+		aic_get_pci_bus(dev),
+		aic_get_pci_slot(dev),
+		aic_get_pci_function(dev));
  	name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
  	if (name == NULL)
  		return (-ENOMEM);
@@ -160,6 +160,8 @@
  	ahc = ahc_alloc(NULL, name);
  	if (ahc == NULL)
  		return (-ENOMEM);
+	ahc->dev_softc = dev;
+
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  	if (pci_enable_device(pdev)) {
  		ahc_free(ahc);
@@ -170,15 +172,14 @@
  	mask_39bit = (bus_addr_t)0x7FFFFFFFFFULL;
  	if (sizeof(bus_addr_t) > 4
  	 && ahc_linux_get_memsize() > 0x80000000
-	 && aic_pci_set_dma_mask(pdev, mask_39bit) == 0) {
+	 && aic_set_dma_mask(ahc, mask_39bit) == 0) {
  		ahc->flags |= AHC_39BIT_ADDRESSING;
  		ahc->platform_data->hw_dma_mask = mask_39bit;
  	} else {
-		aic_pci_set_dma_mask(pdev, 0xFFFFFFFF);
+		aic_set_dma_mask(ahc, 0xFFFFFFFF);
  		ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
  	}
  #endif
-	ahc->dev_softc = pci;
  	error = ahc_pci_config(ahc, entry);
  	if (error != 0) {
  		ahc_free(ahc);
@@ -217,10 +218,8 @@
  	pdev = NULL;
  	class = PCI_CLASS_STORAGE_SCSI << 8;
  	while ((pdev = pci_find_class(class, pdev)) != NULL) {
-		aic_dev_softc_t pci;
  		int error;

-		pci = pdev;
  		error = ahc_linux_pci_dev_probe(pdev, /*pci_devid*/NULL);
  		if (error == 0)
  			found++;
@@ -242,7 +241,7 @@
  		return (ENOMEM);

  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
-	*base = pci_resource_start(ahc->dev_softc, 0);
+	*base = pci_resource_start(aic_pci_dev(ahc), 0);
  #else
  	*base = aic_pci_read_config(ahc->dev_softc, PCIR_MAPS, 4);
  	*base &= PCI_BASE_ADDRESS_IO_MASK;
@@ -272,7 +271,7 @@

  	error = 0;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
-	start = pci_resource_start(ahc->dev_softc, 1);
+	start = pci_resource_start(aic_pci_dev(ahc), 1);
  	base_page = start & PAGE_MASK;
  	base_offset = start - base_page;
  #else
@@ -382,10 +381,10 @@
  {
  	int error;

-	error = request_irq(ahc->dev_softc->irq, ahc_linux_isr,
+	error = request_irq(aic_pci_dev(ahc)->irq, ahc_linux_isr,
  			    SA_SHIRQ, "aic7xxx", ahc);
  	if (error == 0)
-		ahc->platform_data->irq = ahc->dev_softc->irq;
+		ahc->platform_data->irq = aic_pci_dev(ahc)->irq;
  	
  	return (-error);
  }
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_reg.h#28 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped ====
--- /tmp/tmp.26656.14	2004-09-27 13:16:37.835182456 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped	2003-11-03 15:03:57.000000000 -0500
@@ -3,7 +3,7 @@
   *		 from the following source files:
   *
   * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#39 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $
   */
  typedef int (ahc_reg_print_t)(u_int, u_int *, u_int);
  typedef struct ahc_reg_parse_entry {
@@ -1298,7 +1298,6 @@
  #define	CMDSIZE_TABLE_TAIL		0x34

  #define	MWI_RESIDUAL    		0x38
-#define	TARG_IMMEDIATE_SCB		0x38

  #define	NEXT_QUEUED_SCB 		0x39

@@ -1380,6 +1379,7 @@
  #define	RETURN_2        		0x52

  #define	LAST_MSG        		0x53
+#define	TARG_IMMEDIATE_SCB		0x53

  #define	SCSISEQ_TEMPLATE		0x54
  #define		ENSELO          	0x40
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_reg_print.c#15 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped ====
--- /tmp/tmp.26656.15	2004-09-27 13:16:38.064147648 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped	2003-11-03 15:03:57.000000000 -0500
@@ -3,7 +3,7 @@
   *		 from the following source files:
   *
   * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#39 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $
   */

  #include "aic7xxx_osm.h"
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_seq.h#29 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped ====
--- /tmp/tmp.26656.16	2004-09-27 13:16:38.249119528 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped	2003-11-03 15:03:57.000000000 -0500
@@ -3,7 +3,7 @@
   *		 from the following source files:
   *
   * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#39 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $
   */
  static uint8_t seqprog[] = {
  	0xb2, 0x00, 0x00, 0x08,
@@ -155,12 +155,12 @@
  	0x04, 0x3c, 0x92, 0x69,
  	0x02, 0x3c, 0x98, 0x69,
  	0x01, 0x3c, 0x44, 0x79,
-	0xff, 0x6a, 0x70, 0x00,
+	0xff, 0x6a, 0xa6, 0x00,
  	0x00, 0x65, 0xa4, 0x59,
  	0x00, 0x6a, 0xc2, 0x5e,
-	0xff, 0x38, 0x30, 0x71,
+	0xff, 0x53, 0x30, 0x71,
  	0x0d, 0x6a, 0x76, 0x00,
-	0x00, 0x38, 0x14, 0x5e,
+	0x00, 0x53, 0x14, 0x5e,
  	0x00, 0x65, 0xea, 0x58,
  	0x12, 0x01, 0x02, 0x00,
  	0x00, 0x65, 0x18, 0x41,
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.c#14 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c ====
--- /tmp/tmp.26656.17	2004-09-27 13:16:38.644059488 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.c	2003-10-31 19:04:09.000000000 -0500
@@ -30,17 +30,6 @@
   * $Id$
   */

-#include <linux/blk.h>
-#include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <linux/version.h>
-
-/* Core SCSI definitions */
-#include "scsi.h"
-#include "hosts.h"
-#include "aiclib.h"
-#include "cam.h"
-
  #ifndef FALSE
  #define FALSE   0
  #endif /* FALSE */
@@ -1414,8 +1403,12 @@

  /************************* Magic SysReq Support *******************************/
  void
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  aic_sysrq_handler(int key, struct pt_regs *unused, struct kbd_struct *unused1,
  		  struct tty_struct *unused2)
+#else
+aic_sysrq_handler(int key, struct pt_regs *unused, struct tty_struct *unused2)
+#endif
  {
  #ifdef CONFIG_MAGIC_SYSRQ
  	struct aic_softc *aic;
@@ -1508,34 +1501,19 @@
  {
  	bus_dmamap_t map;

-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
  	map = malloc(sizeof(*map), M_DEVBUF, M_NOWAIT);
  	if (map == NULL)
  		return (ENOMEM);
  	/*
  	 * Although we can dma data above 4GB, our
-	 * "consistent" memory is below 4GB for
+	 * coherent memory is below 4GB for
  	 * space efficiency reasons (only need a 4byte
  	 * address).  For this reason, we have to reset
  	 * our dma mask when doing allocations.
  	 */
-	if (aic->dev_softc != NULL)
-		aic_pci_set_dma_mask(aic->dev_softc, 0xFFFFFFFF);
-	*vaddr = pci_alloc_consistent(aic->dev_softc,
-				      dmat->maxsize, &map->bus_addr);
-	if (aic->dev_softc != NULL)
-		aic_pci_set_dma_mask(aic->dev_softc,
-				     aic->platform_data->hw_dma_mask);
-#else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
-	/*
-	 * At least in 2.2.14, malloc is a slab allocator so all
-	 * allocations are aligned.  We assume for these kernel versions
-	 * that all allocations will be bellow 4Gig, physically contiguous,
-	 * and accessible via DMA by the controller.
-	 */
-	map = NULL; /* No additional information to store */
-	*vaddr = malloc(dmat->maxsize, M_DEVBUF, M_NOWAIT);
-#endif
+	aic_set_dma_mask(aic, 0xFFFFFFFF);
+	*vaddr = aic_alloc_coherent(aic, dmat->maxsize, &map->bus_addr);
+	aic_set_dma_mask(aic, aic->platform_data->hw_dma_mask);
  	if (*vaddr == NULL)
  		return (ENOMEM);
  	*mapp = map;
@@ -1547,8 +1525,7 @@
  		void* vaddr, bus_dmamap_t map)
  {
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
-	pci_free_consistent(aic->dev_softc, dmat->maxsize,
-			    vaddr, map->bus_addr);
+	aic_free_coherent(aic, dmat->maxsize, vaddr, map->bus_addr);
  #else
  	free(vaddr, M_DEVBUF);
  #endif
@@ -1565,12 +1542,7 @@
  	 */
  	bus_dma_segment_t stack_sg;

-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
  	stack_sg.ds_addr = map->bus_addr;
-#else
-#define VIRT_TO_BUS(a) (uint32_t)virt_to_bus((void *)(a))
-	stack_sg.ds_addr = VIRT_TO_BUS(buf);
-#endif
  	stack_sg.ds_len = dmat->maxsize;
  	cb(cb_arg, &stack_sg, /*nseg*/1, /*error*/0);
  	return (0);
@@ -1579,11 +1551,7 @@
  void
  aic_dmamap_destroy(struct aic_softc *aic, bus_dma_tag_t dmat, bus_dmamap_t map)
  {
-	/*
-	 * The map may is NULL in our < 2.3.X implementation.
-	 */
-	if (map != NULL)
-		free(map, M_DEVBUF);
+	free(map, M_DEVBUF);
  }

  int
@@ -1724,14 +1692,14 @@
  			 * If the command is still sitting on
  			 * our completion queue, just re-instate
  			 * the timeout.  If we've already completed
-			 * the command, done_late will be set and
-			 * we will need to additionally complete it
-			 * again to the mid-layer.
+			 * the command, the function pointer in our
+			 * timer will be cleared and we will need to
+			 * additionally complete it again to the mid-layer.
  			 *
  			 * Since done_late is cleared by adding a
  			 * timer, we must save off its value first.
  			 */
-			done_late = cmd->done_late;
+			done_late = cmd->eh_timeout.function == NULL;
  			scsi_add_timer(cmd, 60*HZ, aic_linux_midlayer_timeout);
  			if (done_late)
  				cmd->scsi_done(cmd);
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib.h#20 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h ====
--- /tmp/tmp.26656.18	2004-09-27 13:16:39.007004312 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib.h	2003-11-04 16:24:29.000000000 -0500
@@ -58,10 +58,42 @@
  #ifndef	_AICLIB_H
  #define _AICLIB_H

+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/smp_lock.h>
+#include <linux/module.h>
+#include <asm/byteorder.h>
+#include <asm/io.h>
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#include <linux/slab.h>
+#else
+#include <linux/malloc.h>
+#endif
+
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
  #include <linux/interrupt.h> /* For tasklet support. */
  #endif

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+#include <linux/blk.h>
+#endif
+#include <linux/blkdev.h>
+
+#include "scsi.h"
+#include "hosts.h"
+
+/* Name space conflict with BSD queue macros */
+#ifdef LIST_HEAD
+#undef LIST_HEAD
+#endif
+#include "cam.h"
+#include "queue.h"
+#include "scsi_message.h"
+#include "scsi_iu.h"
+
  /*
   * Linux Interrupt Support.
   */
@@ -153,8 +185,13 @@

  /*************************** Forward Declarations *****************************/
  struct aic_softc;
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+typedef struct device *aic_dev_softc_t;
+#else
  typedef struct pci_dev *aic_dev_softc_t;
-typedef Scsi_Cmnd      *aic_io_ctx_t;
+#endif
+typedef Scsi_Cmnd     *aic_io_ctx_t;

  /*************************** Timer DataStructures *****************************/
  typedef struct timer_list aic_timer_t;
@@ -258,6 +295,165 @@
   */
  #define aic_dmamap_sync(aic, dma_tag, dmamap, offset, len, op)

+/*************************** Linux DMA Wrappers *******************************/
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+#define	aic_alloc_coherent(aic, size, bus_addr_ptr) \
+	dma_alloc_coherent(aic->dev_softc, size, bus_addr_ptr, /*flag*/0)
+
+#define	aic_free_coherent(aic, size, vaddr, bus_addr) \
+	dma_free_coherent(aic->dev_softc, size, vaddr, bus_addr)
+
+#define	aic_map_single(aic, buf, size, direction) \
+	dma_map_single(aic->dev_softc, buf, size, direction)
+
+#define	aic_unmap_single(aic, busaddr, size, direction) \
+	dma_unmap_single(aic->dev_softc, busaddr, size, direction)
+
+#define	aic_map_sg(aic, sg_list, num_sg, direction) \
+	dma_map_sg(aic->dev_softc, sg_list, num_sg, direction)
+
+#define	aic_unmap_sg(aic, sg_list, num_sg, direction) \
+	dma_unmap_sg(aic->dev_softc, sg_list, num_sg, direction)
+
+#elif LINUX_VERSION_CODE > KERNEL_VERSION(2,3,0)
+
+#define	aic_alloc_coherent(aic, size, bus_addr_ptr) \
+	pci_alloc_consistent(aic->dev_softc, size, bus_addr_ptr)
+
+#define	aic_free_coherent(aic, size, vaddr, bus_addr) \
+	pci_free_consistent(aic->dev_softc, size, vaddr, bus_addr)
+
+#define	aic_map_single(aic, buf, size, direction) \
+	pci_map_single(aic->dev_softc, buf, size, direction)
+
+#define	aic_unmap_single(aic, busaddr, size, direction) \
+	pci_unmap_single(aic->dev_softc, busaddr, size, direction)
+
+#define	aic_map_sg(aic, sg_list, num_sg, direction) \
+	pci_map_sg(aic->dev_softc, sg_list, num_sg, direction)
+
+#define	aic_unmap_sg(aic, sg_list, num_sg, direction) \
+	pci_unmap_sg(aic->dev_softc, sg_list, num_sg, direction)
+
+#else
+
+static __inline void *aic_alloc_coherent(struct aic_softc *aic,
+					 bus_size_t size, bus_addr_t *baddrp);
+
+/*
+ * At least in 2.2.14, malloc is a slab allocator so all
+ * allocations are aligned.  We assume for these kernel versions
+ * that all allocations will be bellow 4Gig, physically contiguous,
+ * and accessible via DMA by the controller.
+ */
+static __inline void *
+aic_alloc_coherent(struct aic_softc *aic, bus_size_t size, bus_addr_t *baddrp)
+{
+	void *vaddr;
+
+	vaddr_ = malloc(size, M_DEVBUF, M_NOWAIT);
+	if (vaddr != NULL)
+		*baddrp = virt_to_bus(vaddr);
+	return (vaddr);
+}
+
+#define	aic_free_coherent(aic, size, vaddr, bus_addr) \
+	free(vaddr, M_DEVBUF)
+
+#define aic_map_sg(pdev, sg_list, nseg, direction) (nseg)
+#define aic_unmap_sg(pdev, sg_list, nseg, direction)
+#define aic_map_single(pdev, buffer, bufflen, direction) \
+	(VIRT_TO_BUS(buffer))
+#define aic_unmap_single(pdev, buffer, buflen, direction)
+#define sg_dma_address(sg) (VIRT_TO_BUS((sg)->address))
+#define sg_dma_len(sg) ((sg)->length)
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+
+#define aic_set_dma_mask(aic, mask) dma_set_mask(aic->dev_softc, mask)
+
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,3)
+
+/*
+ * Device softc is NULL for EISA devices.
+ */
+#define aic_set_dma_mask(aic, mask) 			\
+	((aic)->dev_softc == NULL ? 0 : pci_set_dma_mask(aic->dev_softc, mask))
+
+#else
+/*
+ * Device softc is NULL for EISA devices.
+ * Always "return" 0 for success.
+ */
+#define aic_set_dma_mask(aic, mask)			\
+    (((aic)->dev_softc == NULL)				\
+     ? 0						\
+     : (((aic)->dev_softc->dma_mask = mask) && 0))
+#endif
+
+/************************* Host Template Macros *******************************/
+#if defined CONFIG_HIGHIO
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,10)
+/* Assume RedHat Distribution with its different HIGHIO conventions. */
+#define	AIC_TEMPLATE_DMA_SETTINGS()	\
+	.can_dma_32		= 1,	\
+	.single_sg_okay		= 1,
+#else
+#define	AIC_TEMPLATE_DMA_SETTINGS()	\
+	.highmem_io		= 1,
+#endif
+#else
+#define	AIC_TEMPLATE_DMA_SETTINGS()
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
+#define	AIC_TEMPLATE_MAX_SECTORS(sectors) \
+	.max_sectors		= (sectors),
+#else
+#define	AIC_TEMPLATE_MAX_SECTORS(sectors)
+#endif
+
+#if defined(__i386__)
+#define	AIC_TEMPLATE_BIOSPARAM() \
+	.bios_param		= AIC_LIB_ENTRY(_linux_biosparam),
+#else
+#define	AIC_TEMPLATE_BIOSPARAM()
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+#define	AIC_TEMPLATE_VERSIONED_ENTRIES() \
+	.slave_alloc		= AIC_LIB_ENTRY(_linux_slave_alloc), \
+	.slave_configure	= AIC_LIB_ENTRY(_linux_slave_configure), \
+	.slave_destroy		= AIC_LIB_ENTRY(_linux_slave_destroy)
+#else
+#define	AIC_TEMPLATE_VERSIONED_ENTRIES() \
+	.detect			= AIC_LIB_ENTRY(_linux_detect), \
+	.release		= AIC_LIB_ENTRY(_linux_release), \
+	.select_queue_depths	= AIC_LIB_ENTRY(_linux_select_queue_depth), \
+	.use_new_eh_code	= 1
+#endif
+
+#define AIC_TEMPLATE_INITIALIZER(NAME, MAX_SECTORS)			\
+{									\
+	.module			= THIS_MODULE,				\
+	.name			= NAME,					\
+	.proc_info		= AIC_LIB_ENTRY(_linux_proc_info),	\
+	.info			= AIC_LIB_ENTRY(_linux_info),		\
+	.queuecommand		= AIC_LIB_ENTRY(_linux_queue),		\
+	.eh_abort_handler	= AIC_LIB_ENTRY(_linux_abort),		\
+	.eh_device_reset_handler = AIC_LIB_ENTRY(_linux_dev_reset),	\
+	.eh_bus_reset_handler	= AIC_LIB_ENTRY(_linux_bus_reset),	\
+	.can_queue		= AIC_CONST_ENTRY(_MAX_QUEUE),		\
+	.this_id		= -1,					\
+	.cmd_per_lun		= 2,					\
+	.use_clustering		= ENABLE_CLUSTERING,			\
+	AIC_TEMPLATE_MAX_SECTORS(MAX_SECTORS)				\
+	AIC_TEMPLATE_DMA_SETTINGS()					\
+	AIC_TEMPLATE_BIOSPARAM()					\
+	AIC_TEMPLATE_VERSIONED_ENTRIES()				\
+}
+
  /************************** OS Utility Wrappers *******************************/
  #define printf printk
  #define M_NOWAIT GFP_ATOMIC
@@ -1686,10 +1882,25 @@
  #define PCIXM_STATUS_MAXCRDS	0x1C00	/* Maximum Cumulative Read Size */
  #define PCIXM_STATUS_RCVDSCEM	0x2000	/* Received a Split Comp w/Error msg */

-/******************************* PCI Routines *********************************/
-static __inline uint32_t aic_pci_read_config(aic_dev_softc_t pci,
+/**************************** KObject Wrappers ********************************/
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+#define	aic_dev_to_pci_dev(dev)		to_pci_dev(dev)
+#define	aic_dev_to_eisa_dev(dev)	to_eisa_dev(dev)
+#define	aic_pci_dev_to_dev(pci)		(&pci->dev)
+#define	aic_eisa_dev_to_dev(eisa)	(&eisa->dev)
+#else
+#define	aic_dev_to_pci_dev(dev)		(dev)
+#define	aic_dev_to_eisa_dev(dev)	(NULL)
+#define	aic_pci_dev_to_dev(pci)		(pci)
+#define	aic_eisa_dev_to_dev(eisa)	(NULL)
+#endif
+
+#define	aic_pci_dev(aic)		aic_dev_to_pci_dev((aic)->dev_softc)
+#define	aic_eisa_dev(aic)		aic_dev_to_eisa_dev((aic)->dev_softc)
+/***************************** PCI Routines ***********************************/
+static __inline uint32_t aic_pci_read_config(aic_dev_softc_t dev,
  					     int reg, int width);
-static __inline void aic_pci_write_config(aic_dev_softc_t pci,
+static __inline void aic_pci_write_config(aic_dev_softc_t dev,
  					  int reg, uint32_t value,
  					  int width);
  static __inline int aic_get_pci_function(aic_dev_softc_t);
@@ -1697,8 +1908,11 @@
  static __inline int aic_get_pci_bus(aic_dev_softc_t);

  static __inline uint32_t
-aic_pci_read_config(aic_dev_softc_t pci, int reg, int width)
+aic_pci_read_config(aic_dev_softc_t dev, int reg, int width)
  {
+	struct pci_dev *pci;
+
+	pci = aic_dev_to_pci_dev(dev);
  	switch (width) {
  	case 1:
  	{
@@ -1727,8 +1941,11 @@
  }

  static __inline void
-aic_pci_write_config(aic_dev_softc_t pci, int reg, uint32_t value, int width)
+aic_pci_write_config(aic_dev_softc_t dev, int reg, uint32_t value, int width)
  {
+	struct pci_dev *pci;
+
+	pci = aic_dev_to_pci_dev(dev);
  	switch (width) {
  	case 1:
  		pci_write_config_byte(pci, reg, value);
@@ -1746,42 +1963,32 @@
  }

  static __inline int
-aic_get_pci_function(aic_dev_softc_t pci)
+aic_get_pci_function(aic_dev_softc_t dev)
  {
+	struct pci_dev *pci;
+
+	pci = aic_dev_to_pci_dev(dev);
  	return (PCI_FUNC(pci->devfn));
  }

  static __inline int
-aic_get_pci_slot(aic_dev_softc_t pci)
+aic_get_pci_slot(aic_dev_softc_t dev)
  {
+	struct pci_dev *pci;
+
+	pci = aic_dev_to_pci_dev(dev);
  	return (PCI_SLOT(pci->devfn));
  }

  static __inline int
-aic_get_pci_bus(aic_dev_softc_t pci)
+aic_get_pci_bus(aic_dev_softc_t dev)
  {
+	struct pci_dev *pci;
+
+	pci = aic_dev_to_pci_dev(dev);
  	return (pci->bus->number);
  }

-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,3,0)
-#define pci_map_sg(pdev, sg_list, nseg, direction) (nseg)
-#define pci_unmap_sg(pdev, sg_list, nseg, direction)
-#define sg_dma_address(sg) (VIRT_TO_BUS((sg)->address))
-#define sg_dma_len(sg) ((sg)->length)
-#define pci_map_single(pdev, buffer, bufflen, direction) \
-	(VIRT_TO_BUS(buffer))
-#define pci_unmap_single(pdev, buffer, buflen, direction)
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,3)
-#define aic_pci_set_dma_mask pci_set_dma_mask
-#else
-/*
- * Always "return" 0 for success.
- */
-#define aic_pci_set_dma_mask(dev_softc, mask)	\
-	(((dev_softc)->dma_mask = mask) && 0)
-#endif
  /************************* Large Disk Handling ********************************/
  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  static __inline int aic_sector_div(u_long capacity, int heads, int sectors);
@@ -1806,23 +2013,27 @@
  /************************* Magic SysReq Support *******************************/
  #include <linux/sysrq.h>

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+typedef void aic_sysrq_handler_t (int, struct pt_regs *, struct kbd_struct *,
+				  struct tty_struct *);
+#else
+typedef void aic_sysrq_handler_t (int, struct pt_regs *, struct tty_struct *);
+#endif
+
  #ifdef CONFIG_MAGIC_SYSRQ
-#define aic_sysrq_key_op sysrq_key_op
+#define	aic_sysrq_key_op sysrq_key_op
  #else
  struct aic_sysrq_key_op {
-	void (*handler)(int, struct pt_regs *, struct kbd_struct *,
-			struct tty_struct *);
+	aic_sysrq_handler_t *handler;
  	char *help_msg;
  	char *action_msg;
  };
  #endif
-void			aic_sysrq_handler(int, struct pt_regs *,
-					  struct kbd_struct *,
-					  struct tty_struct *);
+
+aic_sysrq_handler_t	aic_sysrq_handler;
  int			aic_install_sysrq(struct aic_sysrq_key_op *);
  void			aic_remove_sysrq(int key,
  					 struct aic_sysrq_key_op *key_op);
-
  /************************ SCSI Library Functions *****************************/
  void			aic_sense_desc(int /*sense_key*/, int /*asc*/,
  				       int /*ascq*/, struct scsi_inquiry_data*,
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aiclib_pci.c#1 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib_pci.c ====
--- /tmp/tmp.26656.19	2004-09-27 13:16:39.156981512 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aiclib_pci.c	2003-10-31 17:16:10.000000000 -0500
@@ -43,7 +43,7 @@
  aic_power_state_change(struct aic_softc *aic, aic_power_state new_state)
  {
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-	pci_set_power_state(aic->dev_softc, new_state);
+	pci_set_power_state(aic_dev_to_pci_dev(aic->dev_softc), new_state);
  #else
  	uint32_t cap;
  	u_int cap_offset;


