From: janitor@sternwelten.at
Subject: [patch 11/11]  remove old ifdefs aic7xxx
Date: Wed, 01 Sep 2004 22:46:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2c0M-00076X-Rk@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:20389 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267846AbUIAUrA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 16:47:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic7xxx_osm.h |   81 -------------
 1 files changed, 6 insertions(+), 75 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~remove-old-ifdefs-aic7xxx_osm.h drivers/scsi/aic7xxx/aic7xxx_osm.h
--- linux-2.6.9-rc1-bk7/drivers/scsi/aic7xxx/aic7xxx_osm.h~remove-old-ifdefs-aic7xxx_osm.h	2004-08-31 17:42:02.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-08-31 17:42:02.000000000 +0200
@@ -70,17 +70,9 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 
-#ifndef KERNEL_VERSION
-#define KERNEL_VERSION(x,y,z) (((x)<<16)+((y)<<8)+(z))
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #include <linux/interrupt.h> /* For tasklet support. */
 #include <linux/config.h>
 #include <linux/slab.h>
-#else
-#include <linux/malloc.h>
-#endif
 
 /* Core SCSI definitions */
 #define AIC_LIB_PREFIX ahc
@@ -156,11 +148,6 @@ extern Scsi_Host_Template aic7xxx_driver
 
 /***************************** Bus Space/DMA **********************************/
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,2,17)
-typedef dma_addr_t bus_addr_t;
-#else
-typedef uint32_t bus_addr_t;
-#endif
 typedef uint32_t bus_size_t;
 
 typedef enum {
@@ -175,7 +162,7 @@ typedef union {
 
 typedef struct bus_dma_segment
 {
-	bus_addr_t	ds_addr;
+	dma_addr_t	ds_addr;
 	bus_size_t	ds_len;
 } bus_dma_segment_t;
 
@@ -189,11 +176,11 @@ typedef struct ahc_linux_dma_tag* bus_dm
 
 struct ahc_linux_dmamap
 {
-	bus_addr_t	bus_addr;
+	dma_addr_t	bus_addr;
 };
 typedef struct ahc_linux_dmamap* bus_dmamap_t;
 
-typedef int bus_dma_filter_t(void*, bus_addr_t);
+typedef int bus_dma_filter_t(void*, dma_addr_t);
 typedef void bus_dmamap_callback_t(void *, bus_dma_segment_t *, int, int);
 
 #define BUS_DMA_WAITOK		0x0
@@ -210,7 +197,7 @@ typedef void bus_dmamap_callback_t(void 
 
 int	ahc_dma_tag_create(struct ahc_softc *, bus_dma_tag_t /*parent*/,
 			   bus_size_t /*alignment*/, bus_size_t /*boundary*/,
-			   bus_addr_t /*lowaddr*/, bus_addr_t /*highaddr*/,
+			   dma_addr_t /*lowaddr*/, dma_addr_t /*highaddr*/,
 			   bus_dma_filter_t*/*filter*/, void */*filterarg*/,
 			   bus_size_t /*maxsize*/, int /*nsegments*/,
 			   bus_size_t /*maxsegsz*/, int /*flags*/,
@@ -292,11 +279,7 @@ ahc_scb_timer_reset(struct scb *scb, u_i
 }
 
 /***************************** SMP support ************************************/
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
 #include <linux/spinlock.h>
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
-#include <linux/smp.h>
-#endif
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) || defined(SCSI_HAS_HOST_LOCK))
 #define AHC_SCSI_HAS_HOST_LOCK 1
@@ -515,11 +498,8 @@ typedef enum {
 
 struct scb_platform_data {
 	struct ahc_linux_device	*dev;
-	bus_addr_t		 buf_busaddr;
+	dma_addr_t		 buf_busaddr;
 	uint32_t		 xfer_len;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
-	uint32_t		 resid;		/* Transfer residual */
-#endif
 	uint32_t		 sense_resid;	/* Auto-Sense residual */
 	ahc_linux_scb_flags	 flags;
 };
@@ -549,9 +529,7 @@ struct ahc_platform_data {
 	struct ahc_completeq	 completeq;
 
 	spinlock_t		 spin_lock;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	struct tasklet_struct	 runq_tasklet;
-#endif
 	u_int			 qfrozen;
 	pid_t			 dv_pid;
 	struct timer_list	 completeq_timer;
@@ -567,7 +545,7 @@ struct ahc_platform_data {
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-	bus_addr_t		 hw_dma_mask;
+	dma_addr_t		 hw_dma_mask;
 	ahc_linux_softc_flags	 flags;
 };
 
@@ -819,9 +797,7 @@ ahc_list_unlock(unsigned long *flags)
 #define PCIR_SUBVEND_0	0x2c
 #define PCIR_SUBDEV_0	0x2e
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 extern struct pci_driver aic7xxx_pci_driver;
-#endif
 
 typedef enum
 {
@@ -954,25 +930,6 @@ ahc_flush_device_writes(struct ahc_softc
 	ahc_inb(ahc, INTSTAT);
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
-#define ahc_pci_set_dma_mask pci_set_dma_mask
-#else
-/*
- * Always "return" 0 for success.
- */
-#define ahc_pci_set_dma_mask(dev_softc, mask)  			\
-	(((dev_softc)->dma_mask = mask) && 0)
-#endif
 /**************************** Proc FS Support *********************************/
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 int	ahc_linux_proc_info(char *, char **, off_t, int, int, int);
@@ -1080,35 +1037,13 @@ u_long ahc_get_transfer_length(struct sc
 static __inline
 int ahc_get_transfer_dir(struct scb *scb)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,40)
 	return (scb->io_ctx->sc_data_direction);
-#else
-	if (scb->io_ctx->bufflen == 0)
-		return (CAM_DIR_NONE);
-
-	switch(scb->io_ctx->cmnd[0]) {
-	case 0x08:  /* READ(6)  */
-	case 0x28:  /* READ(10) */
-	case 0xA8:  /* READ(12) */
-		return (CAM_DIR_IN);
-        case 0x0A:  /* WRITE(6)  */
-        case 0x2A:  /* WRITE(10) */
-        case 0xAA:  /* WRITE(12) */
-		return (CAM_DIR_OUT);
-        default:
-		return (CAM_DIR_NONE);
-        }
-#endif
 }
 
 static __inline
 void ahc_set_residual(struct scb *scb, u_long resid)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	scb->io_ctx->resid = resid;
-#else
-	scb->platform_data->resid = resid;
-#endif
 }
 
 static __inline
@@ -1120,11 +1055,7 @@ void ahc_set_sense_residual(struct scb *
 static __inline
 u_long ahc_get_residual(struct scb *scb)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	return (scb->io_ctx->resid);
-#else
-	return (scb->platform_data->resid);
-#endif
 }
 
 static __inline

_
