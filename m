From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:03:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4159611C.4030106@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:35529 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267536AbUI1NDe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:03:34 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD3WW01898
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:03:32 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD3Vm30504
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:03:31 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

This and the following 28 patches sync up the
http://linux.bkbits.net/linux-2.5 tree as of
2004/09/27 (2.6.9-rc2) to the latest
drivers/scsi/aic7xxx/ which we have here.

This patch syncs up the kernel version
of aic7xxx/ to the "original" version which
is in our SCM.  The following patches are
a difference off of this patch.

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/Kconfig.aic79xx linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx
--- linux-2.5/drivers/scsi/aic7xxx_orig/Kconfig.aic79xx	2004-09-27 09:41:42.849518248 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic79xx	2003-03-10 19:12:41.000000000 -0500
@@ -4,7 +4,7 @@
#
config SCSI_AIC79XX
	tristate "Adaptec AIC79xx U320 support"
-	depends on PCI && SCSI
+	depends on PCI
	help
	This driver supports all of Adaptec's Ultra 320 PCI-X
	based SCSI controllers.
@@ -46,7 +46,7 @@

config AIC79XX_BUILD_FIRMWARE
	bool "Build Adapter Firmware with Kernel Build"
-	depends on SCSI_AIC79XX && !PREVENT_FIRMWARE_BUILD
+	depends on SCSI_AIC79XX
	help
	This option should only be enabled if you are modifying the firmware
	source to the aic79xx driver and wish to have the generated firmware
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/Kconfig.aic7xxx linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx
--- linux-2.5/drivers/scsi/aic7xxx_orig/Kconfig.aic7xxx	2004-09-27 09:41:42.850518096 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/Kconfig.aic7xxx	2003-05-27 17:26:17.000000000 -0400
@@ -4,15 +4,17 @@
#
config SCSI_AIC7XXX
	tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
-	depends on (PCI || EISA) && SCSI
+	depends on PCI || EISA
	---help---
	This driver supports all of Adaptec's Fast through Ultra 160 PCI
	based SCSI controllers as well as the aic7770 based EISA and VLB
	SCSI controllers (the 274x and 284x series).  For AAA and ARO based
	configurations, only SCSI functionality is provided.

-	To compile this driver as a module, choose M here: the
-	module will be called aic7xxx.
+	If you want to compile the driver as a module ( = code which can be
+	inserted in and removed from the running kernel whenever you want),
+	say M here and read <file:Documentation/modules.txt>.  The module
+	will be called aic7xxx.

config AIC7XXX_CMDS_PER_DEVICE
	int "Maximum number of TCQ commands per device"
@@ -61,7 +63,7 @@

config AIC7XXX_BUILD_FIRMWARE
	bool "Build Adapter Firmware with Kernel Build"
-	depends on SCSI_AIC7XXX && !PREVENT_FIRMWARE_BUILD
+	depends on SCSI_AIC7XXX
	help
	This option should only be enabled if you are modifying the firmware
	source to the aic7xxx driver and wish to have the generated firmware
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/Makefile linux-2.5/drivers/scsi/aic7xxx/Makefile
--- linux-2.5/drivers/scsi/aic7xxx_orig/Makefile	2004-09-27 09:41:42.851517944 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/Makefile	2003-05-27 17:06:54.000000000 -0400
@@ -1,7 +1,7 @@
#
# Makefile for the Linux aic7xxx SCSI driver.
#
-# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#8 $
+# $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#7 $
#

# Let kbuild descend into aicasm when cleaning
@@ -33,10 +33,7 @@
						   aic79xx_proc.o	\
						   aic79xx_osm_pci.o

-EXTRA_CFLAGS += -Idrivers/scsi
-ifdef WARNINGS_BECOME_ERRORS
-EXTRA_CFLAGS += -Werror
-endif
+EXTRA_CFLAGS += -Idrivers/scsi -Werror
#EXTRA_CFLAGS += -g

# Files generated that shall be removed upon make clean
@@ -61,13 +58,6 @@
	-p $(obj)/aic7xxx_reg_print.c -i aic7xxx_osm.h

ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-aic7xxx_seq.h: aic7xxx_reg.h
-ifeq ($(CONFIG_AIC7XXX_REG_PRETTY_PRINT),y)
-aic7xxx_reg.h: aic7xxx_reg_print.c
-endif
$(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
@@ -82,13 +72,6 @@
	-p $(obj)/aic79xx_reg_print.c -i aic79xx_osm.h

ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-aic79xx_seq.h: aic79xx_reg.h
-ifeq ($(CONFIG_AIC79XX_REG_PRETTY_PRINT),y)
-aic79xx_reg.h: aic79xx_reg_print.c
-endif
$(aic79xx-gen-y): $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic7770.c linux-2.5/drivers/scsi/aic7xxx/aic7770.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic7770.c	2004-09-27 09:41:42.853517640 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic7770.c	2003-05-31 19:43:21.000000000 -0400
@@ -64,7 +64,7 @@
static int aic7770_resume(struct ahc_softc *ahc);
static int aha2840_load_seeprom(struct ahc_softc *ahc);
static ahc_device_setup_t ahc_aic7770_VL_setup;
-static ahc_device_setup_t ahc_aic7770_EISA_setup;
+static ahc_device_setup_t ahc_aic7770_EISA_setup;;
static ahc_device_setup_t ahc_aic7770_setup;

struct aic7770_identity aic7770_ident_table[] =
@@ -175,7 +175,7 @@
	case 15:
		break;
	default:
-		printf("aic7770_config: invalid irq setting %d\n", intdef);
+		printf("aic7770_config: illegal irq setting %d\n", intdef);
		return (ENXIO);
	}

diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic7770_osm.c linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic7770_osm.c	2004-09-27 09:41:42.854517488 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic7770_osm.c	2003-05-27 18:25:08.000000000 -0400
@@ -73,7 +73,7 @@
static int aic7770_linux_config(struct aic7770_identity *entry,
				aic7770_dev_t dev, u_int eisaBase);

-int
+void
ahc_linux_eisa_init(void)
{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -82,7 +82,7 @@
	int i;

	if (aic7xxx_probe_eisa_vl == 0)
-		return -ENODEV;
+		return;

	/*
	 * Linux requires the EISA IDs to be specified in
@@ -93,7 +93,7 @@
					 (ahc_num_aic7770_devs + 1),
					 M_DEVBUF, M_NOWAIT);
	if (aic7770_driver.id_table == NULL)
-		return -ENOMEM;
+		return;

	for (eid = (struct eisa_device_id *)aic7770_driver.id_table,
	     id = aic7770_ident_table, i = 0;
@@ -109,16 +109,15 @@
	}
	eid->sig[0] = 0;

-	return eisa_driver_register(&aic7770_driver);
+	eisa_driver_register(&aic7770_driver);
#else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0) */
	struct aic7770_identity *entry;
	u_int  slot;
	u_int  eisaBase;
	u_int  i;
-	int ret = -ENODEV;

	if (aic7xxx_probe_eisa_vl == 0)
-		return ret;
+		return;

	eisaBase = 0x1000 + AHC_EISA_SLOT_OFFSET;
	for (slot = 1; slot < NUMSLOTS; eisaBase+=0x1000, slot++) {
@@ -147,22 +146,24 @@
			continue;  /* no EISA card in slot */

		entry = aic7770_find_device(eisa_id);
-		if (entry != NULL) {
+		if (entry != NULL)
			aic7770_linux_config(entry, NULL, eisaBase);
-			ret = 0;
-		}
	}
-	return ret;
#endif
}

void
ahc_linux_eisa_exit(void)
{
-	if(aic7xxx_probe_eisa_vl != 0 && aic7770_driver.id_table != NULL) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	if (aic7xxx_probe_eisa_vl == 0)
+		return;
+
+	if (aic7770_driver.id_table != NULL) {
		eisa_driver_unregister(&aic7770_driver);
		free(aic7770_driver.id_table, M_DEVBUF);
	}
+#endif
}

static int
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_core.c linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_core.c	2004-09-27 09:41:42.902510192 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2003-06-27 11:59:06.000000000 -0400
@@ -173,7 +173,7 @@
					    struct ahd_devinfo *devinfo,
					    u_int lun, cam_status status,
					    char *message, int verbose_level);
-#ifdef AHD_TARGET_MODE
+#if AHD_TARGET_MODE
static void		ahd_setup_target_msgin(struct ahd_softc *ahd,
					       struct ahd_devinfo *devinfo,
					       struct scb *scb);
@@ -1190,7 +1190,7 @@
					ahd->msgin_index = 0;
				}
			}
-#ifdef AHD_TARGET_MODE
+#if AHD_TARGET_MODE
			else {
				if (bus_phase == P_MESGOUT) {
					ahd->msg_type =
@@ -5303,7 +5303,7 @@

		tstate = ahd->enabled_targets[i];
		if (tstate != NULL) {
-#ifdef AHD_TARGET_MODE
+#if AHD_TARGET_MODE
			int j;

			for (j = 0; j < AHD_NUM_LUNS; j++) {
@@ -5319,7 +5319,7 @@
			free(tstate, M_DEVBUF);
		}
	}
-#ifdef AHD_TARGET_MODE
+#if AHD_TARGET_MODE
	if (ahd->black_hole != NULL) {
		xpt_free_path(ahd->black_hole->path);
		free(ahd->black_hole, M_DEVBUF);
@@ -6575,7 +6575,7 @@
	ahd_outb(ahd, CLRSINT3, NTRAMPERR|OSRAMPERR);
	ahd_outb(ahd, CLRINT, CLRSCSIINT);

-#ifdef NEEDS_MORE_TESTING
+#if NEEDS_MORE_TESTING
	/*
	 * Always enable abort on incoming L_Qs if this feature is
	 * supported.  We use this to catch invalid SCB references.
@@ -7157,7 +7157,7 @@
	if (match != 0)
		match = ((lun == slun) || (lun == CAM_LUN_WILDCARD));
	if (match != 0) {
-#ifdef AHD_TARGET_MODE
+#if AHD_TARGET_MODE
		int group;

		group = XPT_FC_GROUP(scb->io_ctx->ccb_h.func_code);
@@ -7768,7 +7768,7 @@
	/* Make sure the sequencer is in a safe location. */
	ahd_clear_critical_section(ahd);

-#ifdef AHD_TARGET_MODE
+#if AHD_TARGET_MODE
	if ((ahd->flags & AHD_TARGETROLE) != 0) {
		ahd_run_tqinfifo(ahd, /*paused*/TRUE);
	}
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_osm.c linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_osm.c	2004-09-27 09:41:42.929506088 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-07-28 16:21:49.000000000 -0400
@@ -61,7 +61,6 @@
#endif

#include <linux/mm.h>		/* For fetching system memory size */
-#include <linux/delay.h>	/* For ssleep/msleep */

/*
* Lock protecting manipulation of the ahd softc list.
@@ -416,6 +415,7 @@
/*
* Module information and settable options.
*/
+#ifdef MODULE
static char *aic79xx = NULL;
/*
* Just in case someone uses commas to separate items on the insmod
@@ -426,8 +426,9 @@

MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
MODULE_DESCRIPTION("Adaptec Aic790X U320 SCSI Host Bus Adapter driver");
+#ifdef MODULE_LICENSE
MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(AIC79XX_DRIVER_VERSION);
+#endif
MODULE_PARM(aic79xx, "s");
MODULE_PARM_DESC(aic79xx,
"period delimited, options string.\n"
@@ -451,17 +452,18 @@
"	seltime:<int>		Selection Timeout:\n"
"				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
"\n"
-"	Sample /etc/modprobe.conf line:\n"
+"	Sample /etc/modules.conf line:\n"
"		Enable verbose logging\n"
"		Set tag depth on Controller 2/Target 2 to 10 tags\n"
"		Shorten the selection timeout to 128ms\n"
"\n"
"	options aic79xx 'aic79xx=verbose.tag_info:{{}.{}.{..10}}.seltime:1'\n"
"\n"
-"	Sample /etc/modprobe.conf line:\n"
+"	Sample /etc/modules.conf line:\n"
"		Change Read Streaming for Controller's 2 and 3\n"
"\n"
"	options aic79xx 'aic79xx=rd_strm:{..0xFFF0.0xC0F0}'");
+#endif

static void ahd_linux_handle_scsi_status(struct ahd_softc *,
					 struct ahd_linux_device *,
@@ -511,6 +513,9 @@
			    struct scsi_cmnd *cmd,
			    struct ahd_devinfo *devinfo,
			    struct ahd_linux_target *targ);
+static __inline int
+	   ahd_linux_dv_fallback(struct ahd_softc *ahd,
+				 struct ahd_devinfo *devinfo);
static int ahd_linux_fallback(struct ahd_softc *ahd,
			      struct ahd_devinfo *devinfo);
static __inline int ahd_linux_dv_fallback(struct ahd_softc *ahd,
@@ -1676,9 +1681,33 @@
	.this_id		= -1,
	.cmd_per_lun		= 2,
	.use_clustering		= ENABLE_CLUSTERING,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
+	/*
+	 * We can only map 16MB per-SG
+	 * so create a sector limit of
+	 * "16MB" in 2K sectors.
+	 */
+	.max_sectors		= 8192,
+#endif
+#if defined CONFIG_HIGHIO || LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,10)
+/* Assume RedHat Distribution with its different HIGHIO conventions. */
+	.can_dma_32		= 1,
+	.single_sg_okay		= 1,
+#else
+	.highmem_io		= 1,
+#endif
+#endif
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
	.slave_alloc		= ahd_linux_slave_alloc,
	.slave_configure	= ahd_linux_slave_configure,
	.slave_destroy		= ahd_linux_slave_destroy,
+#else
+	.detect			= ahd_linux_detect,
+	.release		= ahd_linux_release,
+	.select_queue_depths	= ahd_linux_select_queue_depth,
+	.use_new_eh_code	= 1,
+#endif
};

/**************************** Tasklet Handler *********************************/
@@ -1771,18 +1800,12 @@
	 * our dma mask when doing allocations.
	 */
	if (ahd->dev_softc != NULL)
-		if (ahd_pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
-			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
-			return (ENODEV);
-		}
+		ahd_pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF);
	*vaddr = pci_alloc_consistent(ahd->dev_softc,
				      dmat->maxsize, &map->bus_addr);
	if (ahd->dev_softc != NULL)
-		if (ahd_pci_set_dma_mask(ahd->dev_softc,
-				     ahd->platform_data->hw_dma_mask)) {
-			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
-			return (ENODEV);
-		}
+		ahd_pci_set_dma_mask(ahd->dev_softc,
+				     ahd->platform_data->hw_dma_mask);
#else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
	/*
	 * At least in 2.2.14, malloc is a slab allocator so all
@@ -2075,7 +2098,7 @@
	u_long	target;

	template->name = ahd->description;
-	host = scsi_host_alloc(template, sizeof(struct ahd_softc *));
+	host = scsi_register(template, sizeof(struct ahd_softc *));
	if (host == NULL)
		return (ENOMEM);

@@ -2150,8 +2173,7 @@
	ahd_unlock(ahd, &s);

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_add_host(host, &ahd->dev_softc->dev); /* XXX handle failure */
-	scsi_scan_host(host);
+	scsi_add_host(host, &ahd->dev_softc->dev);
#endif
	return (0);
}
@@ -2286,7 +2308,7 @@
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
			scsi_remove_host(ahd->platform_data->host);
#endif
-			scsi_host_put(ahd->platform_data->host);
+			scsi_unregister(ahd->platform_data->host);
		}

		/* destroy all of the device and target objects */
@@ -2586,7 +2608,6 @@
	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
#else
	daemonize("ahd_dv_%d", ahd->unit);
-	current->flags |= PF_FREEZE;
#endif
	unlock_kernel();

@@ -2910,19 +2931,6 @@
	ahd_unlock(ahd, &s);
}

-static __inline int
-ahd_linux_dv_fallback(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
-{
-	u_long s;
-	int retval;
-
-	ahd_lock(ahd, &s);
-	retval = ahd_linux_fallback(ahd, devinfo);
-	ahd_unlock(ahd, &s);
-
-	return (retval);
-}
-
static void
ahd_linux_dv_transition(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
			struct ahd_devinfo *devinfo,
@@ -3171,7 +3179,7 @@
				break;
			}
			if (status & SSQ_DELAY)
-				ssleep(1);
+				scsi_sleep(1 * HZ);

			break;
		case SS_START:
@@ -3331,7 +3339,7 @@
			}
			if (targ->dv_state_retry <= 10) {
				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					msleep(ahd->our_id*1000/10);
+					scsi_sleep(ahd->our_id*HZ/10);
				break;
			}
#ifdef AHD_DEBUG
@@ -3375,7 +3383,7 @@
				targ->dv_state_retry--;
			} else if (targ->dv_state_retry < 60) {
				if ((status & SSQ_DELAY) != 0)
-					ssleep(1);
+					scsi_sleep(1 * HZ);
			} else {
#ifdef AHD_DEBUG
				if (ahd_debug & AHD_SHOW_DV) {
@@ -3559,6 +3567,19 @@
	cmd->cmnd[4] = le | SSS_START;
}

+static __inline int
+ahd_linux_dv_fallback(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
+{
+	u_long s;
+	int retval;
+
+	ahd_lock(ahd, &s);
+	retval = ahd_linux_fallback(ahd, devinfo);
+	ahd_unlock(ahd, &s);
+
+	return (retval);
+}
+
static int
ahd_linux_fallback(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
{
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_osm.h linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_osm.h	2004-09-27 09:41:42.931505784 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2003-07-11 16:46:23.000000000 -0400
@@ -43,6 +43,7 @@
#define _AIC79XX_LINUX_H_

#include <linux/types.h>
+#include <linux/blk.h>
#include <linux/blkdev.h>
#include <linux/delay.h>
#include <linux/ioport.h>
@@ -68,7 +69,7 @@
/* Core SCSI definitions */
#define AIC_LIB_PREFIX ahd
#include "scsi.h"
-#include <scsi/scsi_host.h>
+#include "hosts.h"

/* Name space conflict with BSD queue macros */
#ifdef LIST_HEAD
@@ -788,7 +789,7 @@
}

static __inline void
-ahd_list_lockinit(void)
+ahd_list_lockinit()
{
	spin_lock_init(&ahd_list_spinlock);
}
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_osm_pci.c linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_osm_pci.c	2004-09-27 09:41:42.933505480 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2003-06-05 14:02:40.000000000 -0400
@@ -70,10 +70,10 @@
MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);

struct pci_driver aic79xx_pci_driver = {
-	.name		= "aic79xx",
-	.probe		= ahd_linux_pci_dev_probe,
-	.remove		= ahd_linux_pci_dev_remove,
-	.id_table	= ahd_linux_pci_id_table
+	name:		"aic79xx",
+	probe:		ahd_linux_pci_dev_probe,
+	remove:		ahd_linux_pci_dev_remove,
+	id_table:	ahd_linux_pci_id_table
};

static void
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_pci.c linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic79xx_pci.c	2004-09-27 09:41:42.949503048 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c	2003-06-30 12:09:41.000000000 -0400
@@ -452,10 +452,8 @@
	 * or read prefetching could be initiated by the
	 * CPU or host bridge.  Our device does not support
	 * either, so look for data corruption and/or flaged
-	 * PCI errors.  First pause without causing another
-	 * chip reset.
+	 * PCI errors.
	 */
-	hcntrl &= ~CHIPRST;
	ahd_outb(ahd, HCNTRL, hcntrl|PAUSE);
	while (ahd_is_paused(ahd) == 0)
		;
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_osm.c linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_osm.c	2004-09-27 09:41:43.055486936 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-07-28 12:20:13.000000000 -0400
@@ -139,8 +139,7 @@
#endif

#include <linux/mm.h>		/* For fetching system memory size */
-#include <linux/blkdev.h>		/* For block_size() */
-#include <linux/delay.h>	/* For ssleep/msleep */
+#include <linux/blk.h>		/* For block_size() */

/*
* Lock protecting manipulation of the ahc softc list.
@@ -437,6 +436,7 @@
/*
* Module information and settable options.
*/
+#ifdef MODULE
static char *aic7xxx = NULL;
/*
* Just in case someone uses commas to separate items on the insmod
@@ -447,8 +447,9 @@

MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
MODULE_DESCRIPTION("Adaptec Aic77XX/78XX SCSI Host Bus Adapter driver");
+#ifdef MODULE_LICENSE
MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
+#endif
MODULE_PARM(aic7xxx, "s");
MODULE_PARM_DESC(aic7xxx,
"period delimited, options string.\n"
@@ -471,13 +472,14 @@
"	seltime:<int>		Selection Timeout\n"
"				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
"\n"
-"	Sample /etc/modprobe.conf line:\n"
+"	Sample /etc/modules.conf line:\n"
"		Toggle EISA/VLB probing\n"
"		Set tag depth on Controller 1/Target 1 to 10 tags\n"
"		Shorten the selection timeout to 128ms\n"
"\n"
"	options aic7xxx 'aic7xxx=probe_eisa_vl.tag_info:{{}.{.10}}.seltime:1'\n"
);
+#endif

static void ahc_linux_handle_scsi_status(struct ahc_softc *,
					 struct ahc_linux_device *,
@@ -841,7 +843,7 @@
ahc_linux_detect(Scsi_Host_Template *template)
{
	struct	ahc_softc *ahc;
-	int     found = 0;
+	int     found;

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
	/*
@@ -889,25 +891,28 @@
	 */
	ahc_list_lockinit();

-	found = ahc_linux_pci_init();
-	if (!ahc_linux_eisa_init())
-		found++;
-	
+#ifdef CONFIG_PCI
+	ahc_linux_pci_init();
+#endif
+
+#ifdef CONFIG_EISA
+	ahc_linux_eisa_init();
+#endif
+
	/*
	 * Register with the SCSI layer all
	 * controllers we've found.
	 */
+	found = 0;
	TAILQ_FOREACH(ahc, &ahc_tailq, links) {

		if (ahc_linux_register_host(ahc, template) == 0)
			found++;
	}
-
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
	spin_lock_irq(&io_request_lock);
#endif
	aic7xxx_detect_complete++;
-
	return (found);
}

@@ -1305,9 +1310,33 @@
	.this_id		= -1,
	.cmd_per_lun		= 2,
	.use_clustering		= ENABLE_CLUSTERING,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
+	/*
+	 * We can only map 16MB per-SG
+	 * so create a sector limit of
+	 * "16MB" in 2K sectors.
+	 */
+	.max_sectors		= 8192,
+#endif
+#if defined CONFIG_HIGHIO || LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,10)
+/* Assume RedHat Distribution with its different HIGHIO conventions. */
+	.can_dma_32		= 1,
+	.single_sg_okay		= 1,
+#else
+	.highmem_io		= 1,
+#endif
+#endif
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
	.slave_alloc		= ahc_linux_slave_alloc,
	.slave_configure	= ahc_linux_slave_configure,
	.slave_destroy		= ahc_linux_slave_destroy,
+#else
+	.detect			= ahc_linux_detect,
+	.release		= ahc_linux_release,
+	.select_queue_depths	= ahc_linux_select_queue_depth,
+	.use_new_eh_code	= 1,
+#endif
};

/**************************** Tasklet Handler *********************************/
@@ -1406,18 +1435,12 @@
	 * our dma mask when doing allocations.
	 */
	if (ahc->dev_softc != NULL)
-		if (ahc_pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
-			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
-			return (ENODEV);
-		}
+		ahc_pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF);
	*vaddr = pci_alloc_consistent(ahc->dev_softc,
				      dmat->maxsize, &map->bus_addr);
	if (ahc->dev_softc != NULL)
-		if (ahc_pci_set_dma_mask(ahc->dev_softc,
-				     ahc->platform_data->hw_dma_mask)) {
-			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
-			return (ENODEV);
-		}
+		ahc_pci_set_dma_mask(ahc->dev_softc,
+				     ahc->platform_data->hw_dma_mask);
#else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
	/*
	 * At least in 2.2.14, malloc is a slab allocator so all
@@ -1529,7 +1552,6 @@

	/* Still equal.  Sort by BIOS address, ioport, or bus/slot/func. */
	switch (rvalue) {
-#ifdef CONFIG_PCI
	case AHC_PCI:
	{
		char primary_channel;
@@ -1562,7 +1584,6 @@
			value = 1;
		break;
	}
-#endif
	case AHC_EISA:
		if ((rahc->flags & AHC_BIOS_ENABLED) != 0) {
			value = rahc->platform_data->bios_address
@@ -1707,7 +1728,7 @@
	u_int	 targ_offset;

	template->name = ahc->description;
-	host = scsi_host_alloc(template, sizeof(struct ahc_softc *));
+	host = scsi_register(template, sizeof(struct ahc_softc *));
	if (host == NULL)
		return (ENOMEM);

@@ -1793,8 +1814,7 @@
	ahc_unlock(ahc, &s);

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle failure */
-	scsi_scan_host(host);
+	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL));
#endif
	return (0);
}
@@ -1961,7 +1981,7 @@
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
			scsi_remove_host(ahc->platform_data->host);
#endif
-			scsi_host_put(ahc->platform_data->host);
+			scsi_unregister(ahc->platform_data->host);
		}

		/* destroy all of the device and target objects */
@@ -2293,7 +2313,6 @@
	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
#else
	daemonize("ahc_dv_%d", ahc->unit);
-	current->flags |= PF_FREEZE;
#endif
	unlock_kernel();

@@ -2823,7 +2842,7 @@
				break;
			}
			if (status & SSQ_DELAY)
-				ssleep(1);
+				scsi_sleep(1 * HZ);

			break;
		case SS_START:
@@ -2983,7 +3002,7 @@
			}
			if (targ->dv_state_retry <= 10) {
				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					msleep(ahc->our_id*1000/10);
+					scsi_sleep(ahc->our_id*HZ/10);
				break;
			}
#ifdef AHC_DEBUG
@@ -3027,7 +3046,7 @@
				targ->dv_state_retry--;
			} else if (targ->dv_state_retry < 60) {
				if ((status & SSQ_DELAY) != 0)
-					ssleep(1);
+					scsi_sleep(1 * HZ);
			} else {
#ifdef AHC_DEBUG
				if (ahc_debug & AHC_SHOW_DV) {
@@ -3967,10 +3986,11 @@
}

static void
-__ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
+ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
{
	struct ahc_linux_target *targ;

+	del_timer_sync(&dev->timer);
	targ = dev->target;
	targ->devices[dev->lun] = NULL;
	free(dev, M_DEVBUF);
@@ -3980,13 +4000,6 @@
		ahc_linux_free_target(ahc, targ);
}

-static void
-ahc_linux_free_device(struct ahc_softc *ahc, struct ahc_linux_device *dev)
-{
-	del_timer_sync(&dev->timer);
-	__ahc_linux_free_device(ahc, dev);
-}
-
void
ahc_send_async(struct ahc_softc *ahc, char channel,
	       u_int target, u_int lun, ac_code code, void *arg)
@@ -4697,7 +4710,7 @@
		ahc_linux_run_device_queue(ahc, dev);
	if (TAILQ_EMPTY(&dev->busyq)
	 && dev->active == 0)
-		__ahc_linux_free_device(ahc, dev);
+		ahc_linux_free_device(ahc, dev);
	ahc_unlock(ahc, &s);
}

@@ -5071,17 +5084,11 @@
	}
}

-static void ahc_linux_exit(void);
-
static int __init
ahc_linux_init(void)
{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	int rc = ahc_linux_detect(&aic7xxx_driver_template);
-	if (rc)
-		return rc;
-	ahc_linux_exit();
-	return -ENODEV;
+	return (ahc_linux_detect(&aic7xxx_driver_template) ? 0 : -ENODEV);
#else
	scsi_register_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
	if (aic7xxx_driver_template.present == 0) {
@@ -5094,7 +5101,7 @@
#endif
}

-static void
+static void __exit
ahc_linux_exit(void)
{
	struct ahc_softc *ahc;
@@ -5121,8 +5128,12 @@
	 */
	scsi_unregister_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
#endif
+#ifdef CONFIG_PCI
	ahc_linux_pci_exit();
+#endif
+#ifdef CONFIG_EISA
	ahc_linux_eisa_exit();
+#endif
}

module_init(ahc_linux_init);
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_osm.h linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_osm.h	2004-09-27 09:41:43.058486480 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2003-06-05 14:03:55.000000000 -0400
@@ -60,6 +60,7 @@
#define _AIC7XXX_LINUX_H_

#include <linux/types.h>
+#include <linux/blk.h>
#include <linux/blkdev.h>
#include <linux/delay.h>
#include <linux/ioport.h>
@@ -85,7 +86,7 @@
/* Core SCSI definitions */
#define AIC_LIB_PREFIX ahc
#include "scsi.h"
-#include <scsi/scsi_host.h>
+#include "hosts.h"

/* Name space conflict with BSD queue macros */
#ifdef LIST_HEAD
@@ -840,17 +841,11 @@

#ifdef CONFIG_EISA
extern uint32_t aic7xxx_probe_eisa_vl;
-int			 ahc_linux_eisa_init(void);
+void			 ahc_linux_eisa_init(void);
void			 ahc_linux_eisa_exit(void);
int			 aic7770_map_registers(struct ahc_softc *ahc,
					       u_int port);
int			 aic7770_map_int(struct ahc_softc *ahc, u_int irq);
-#else
-static inline int	ahc_linux_eisa_init(void) {
-	return -ENODEV;
-}
-static inline void	ahc_linux_eisa_exit(void) {
-}
#endif

/******************************* PCI Routines *********************************/
@@ -938,12 +933,6 @@
{
	return (pci->bus->number);
}
-#else
-static inline int ahc_linux_pci_init(void) {
-	return 0;
-}
-static inline void ahc_linux_pci_exit(void) {
-}
#endif

static __inline void ahc_flush_device_writes(struct ahc_softc *);
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_osm_pci.c linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_osm_pci.c	2004-09-27 09:41:43.059486328 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2003-06-05 14:04:25.000000000 -0400
@@ -73,10 +73,10 @@
MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);

struct pci_driver aic7xxx_pci_driver = {
-	.name		= "aic7xxx",
-	.probe		= ahc_linux_pci_dev_probe,
-	.remove		= ahc_linux_pci_dev_remove,
-	.id_table	= ahc_linux_pci_id_table
+	name:		"aic7xxx",
+	probe:		ahc_linux_pci_dev_probe,
+	remove:		ahc_linux_pci_dev_remove,
+	id_table:	ahc_linux_pci_id_table
};

static void
@@ -166,10 +166,7 @@
		ahc->flags |= AHC_39BIT_ADDRESSING;
		ahc->platform_data->hw_dma_mask = mask_39bit;
	} else {
-		if (ahc_pci_set_dma_mask(pdev, 0xFFFFFFFF)) {
-			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
-                	return (-ENODEV);
-		}
+		ahc_pci_set_dma_mask(pdev, 0xFFFFFFFF);
		ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
	}
#endif
@@ -198,8 +195,7 @@
ahc_linux_pci_init(void)
{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-	/* Translate error or zero return into zero or one */
-	return pci_module_init(&aic7xxx_pci_driver) ? 0 : 1;
+	return (pci_module_init(&aic7xxx_pci_driver));
#else
	struct pci_dev *pdev;
	u_int class;
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_pci.c linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aic7xxx_pci.c	2004-09-27 09:41:43.077483592 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aic7xxx_pci.c	2003-05-31 22:59:34.000000000 -0400
@@ -1284,10 +1284,8 @@
	 * or read prefetching could be initiated by the
	 * CPU or host bridge.  Our device does not support
	 * either, so look for data corruption and/or flagged
-	 * PCI errors.  First pause without causing another
-	 * chip reset.
+	 * PCI errors.
	 */
-	hcntrl &= ~CHIPRST;
	ahc_outb(ahc, HCNTRL, hcntrl|PAUSE);
	while (ahc_is_paused(ahc) == 0)
		;
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aicasm/Makefile linux-2.5/drivers/scsi/aic7xxx/aicasm/Makefile
--- linux-2.5/drivers/scsi/aic7xxx_orig/aicasm/Makefile	2004-09-27 09:41:43.176468544 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aicasm/Makefile	2003-02-18 16:00:16.000000000 -0500
@@ -34,14 +34,10 @@
	$(AICASM_CC) $(AICASM_CFLAGS) $(SRCS) -o $(PROG) $(LIBS)

aicdb.h:
-	@if [ -e "/usr/include/db4/db_185.h" ]; then		\
-		echo "#include <db4/db_185.h>" > aicdb.h;	\
-	 elif [ -e "/usr/include/db3/db_185.h" ]; then		\
+	@if [ -e "/usr/include/db3/db_185.h" ]; then		\
		echo "#include <db3/db_185.h>" > aicdb.h;	\
	 elif [ -e "/usr/include/db2/db_185.h" ]; then		\
		echo "#include <db2/db_185.h>" > aicdb.h;	\
-	 elif [ -e "/usr/include/db1/db_185.h" ]; then		\
-		echo "#include <db1/db_185.h>" > aicdb.h;	\
	 elif [ -e "/usr/include/db/db_185.h" ]; then		\
		echo "#include <db/db_185.h>" > aicdb.h;	\
	 elif [ -e "/usr/include/db_185.h" ]; then		\
@@ -53,19 +49,11 @@
clean:
	rm -f $(clean-files)

-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-aicasm_gram.c: aicasm_gram.h
aicasm_gram.c aicasm_gram.h: aicasm_gram.y
	$(YACC) $(YFLAGS) -b $(<:.y=) $<
	mv $(<:.y=).tab.c $(<:.y=.c)
	mv $(<:.y=).tab.h $(<:.y=.h)

-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-aicasm_macro_gram.c: aicasm_macro_gram.h
aicasm_macro_gram.c aicasm_macro_gram.h: aicasm_macro_gram.y
	$(YACC) $(YFLAGS) -b $(<:.y=) -p mm $<
	mv $(<:.y=).tab.c $(<:.y=.c)
diff -ruN -X exclude-files linux-2.5/drivers/scsi/aic7xxx_orig/aiclib.c linux-2.5/drivers/scsi/aic7xxx/aiclib.c
--- linux-2.5/drivers/scsi/aic7xxx_orig/aiclib.c	2004-09-27 09:41:43.155471736 -0400
+++ linux-2.5/drivers/scsi/aic7xxx/aiclib.c	2003-03-27 22:58:54.000000000 -0500
@@ -30,13 +30,14 @@
* $Id$
*/

+#include <linux/blk.h>
#include <linux/blkdev.h>
#include <linux/delay.h>
#include <linux/version.h>

/* Core SCSI definitions */
#include "scsi.h"
-#include <scsi/scsi_host.h>
+#include "hosts.h"
#include "aiclib.h"
#include "cam.h"




