From: janitor@sternwelten.at
Subject: [patch 04/11]  remove old ifdefs aic79xxx
Date: Wed, 01 Sep 2004 22:46:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bzk-00071Z-Hi@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:57990 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267785AbUIAUqS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 16:46:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic79xx_osm.c |   89 +------------
 1 files changed, 11 insertions(+), 78 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~remove-old-ifdefs-aic79xx_osm.c drivers/scsi/aic7xxx/aic79xx_osm.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/aic7xxx/aic79xx_osm.c~remove-old-ifdefs-aic79xx_osm.c	2004-08-31 17:41:22.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-08-31 17:41:22.000000000 +0200
@@ -52,9 +52,7 @@
  */
 #include "aiclib.c"
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 #include <linux/init.h>		/* __setup */
-#endif
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 #include "sd.h"			/* For geometry detection */
@@ -68,14 +66,6 @@
  */
 spinlock_t ahd_list_spinlock;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
-struct proc_dir_entry proc_scsi_aic79xx = {
-	PROC_SCSI_AIC79XX, 7, "aic79xx",
-	S_IFDIR | S_IRUGO | S_IXUGO, 2,
-	0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL
-};
-#endif
-
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 /* For dynamic sglist size calculation. */
 u_int ahd_linux_nseg;
@@ -561,7 +551,7 @@ static __inline void ahd_linux_unmap_scb
 
 static __inline int ahd_linux_map_seg(struct ahd_softc *ahd, struct scb *scb,
 		 		      struct ahd_dma_seg *sg,
-				      bus_addr_t addr, bus_size_t len);
+				      dma_addr_t addr, bus_size_t len);
 
 static __inline void
 ahd_schedule_completeq(struct ahd_softc *ahd)
@@ -579,31 +569,20 @@ ahd_schedule_completeq(struct ahd_softc 
 static __inline void
 ahd_schedule_runq(struct ahd_softc *ahd)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	tasklet_schedule(&ahd->platform_data->runq_tasklet);
-#else
-	/*
-	 * Tasklets are not available, so run inline.
-	 */
-	ahd_runq_tasklet((unsigned long)ahd);
-#endif
 }
 
 static __inline
 void ahd_setup_runq_tasklet(struct ahd_softc *ahd)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	tasklet_init(&ahd->platform_data->runq_tasklet, ahd_runq_tasklet,
 		     (unsigned long)ahd);
-#endif
 }
 
 static __inline void
 ahd_teardown_runq_tasklet(struct ahd_softc *ahd)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	tasklet_kill(&ahd->platform_data->runq_tasklet);
-#endif
 }
 
 static __inline struct ahd_linux_device*
@@ -734,7 +713,7 @@ ahd_linux_unmap_scb(struct ahd_softc *ah
 
 static __inline int
 ahd_linux_map_seg(struct ahd_softc *ahd, struct scb *scb,
-		  struct ahd_dma_seg *sg, bus_addr_t addr, bus_size_t len)
+		  struct ahd_dma_seg *sg, dma_addr_t addr, bus_size_t len)
 {
 	int	 consumed;
 
@@ -746,7 +725,7 @@ ahd_linux_map_seg(struct ahd_softc *ahd,
 	sg->addr = ahd_htole32(addr & 0xFFFFFFFF);
 	scb->platform_data->xfer_len += len;
 
-	if (sizeof(bus_addr_t) > 4
+	if (sizeof(dma_addr_t) > 4
 	 && (ahd->flags & AHD_39BIT_ADDRESSING) != 0)
 		len |= (addr >> 8) & AHD_SG_HIGH_ADDR_MASK;
 
@@ -889,11 +868,7 @@ ahd_linux_detect(Scsi_Host_Template *tem
 "aic79xx: insmod or else it might trash certain memory areas.\n");
 #endif
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,3,0)
 	template->proc_name = "aic79xx";
-#else
-	template->proc_dir = &proc_scsi_aic79xx;
-#endif
 
 	/*
 	 * Initialize our softc list lock prior to
@@ -1694,35 +1669,27 @@ ahd_runq_tasklet(unsigned long data)
 {
 	struct ahd_softc* ahd;
 	struct ahd_linux_device *dev;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	u_long flags;
-#endif
 
 	ahd = (struct ahd_softc *)data;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	ahd_lock(ahd, &flags);
-#endif
 	while ((dev = ahd_linux_next_device_to_run(ahd)) != NULL) {
 	
 		TAILQ_REMOVE(&ahd->platform_data->device_runq, dev, links);
 		dev->flags &= ~AHD_DEV_ON_RUN_LIST;
 		ahd_linux_check_device_queue(ahd, dev);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		/* Yeild to our interrupt handler */
 		ahd_unlock(ahd, &flags);
 		ahd_lock(ahd, &flags);
-#endif
 	}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	ahd_unlock(ahd, &flags);
-#endif
 }
 
 /******************************** Bus DMA *************************************/
 int
 ahd_dma_tag_create(struct ahd_softc *ahd, bus_dma_tag_t parent,
 		   bus_size_t alignment, bus_size_t boundary,
-		   bus_addr_t lowaddr, bus_addr_t highaddr,
+		   dma_addr_t lowaddr, dma_addr_t highaddr,
 		   bus_dma_filter_t *filter, void *filterarg,
 		   bus_size_t maxsize, int nsegments,
 		   bus_size_t maxsegsz, int flags, bus_dma_tag_t *ret_tag)
@@ -1759,7 +1726,6 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, 
 {
 	bus_dmamap_t map;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	map = malloc(sizeof(*map), M_DEVBUF, M_NOWAIT);
 	if (map == NULL)
 		return (ENOMEM);
@@ -1771,28 +1737,18 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahd->dev_softc != NULL)
-		if (ahd_pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
 			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
 			return (ENODEV);
 		}
 	*vaddr = pci_alloc_consistent(ahd->dev_softc,
 				      dmat->maxsize, &map->bus_addr);
 	if (ahd->dev_softc != NULL)
-		if (ahd_pci_set_dma_mask(ahd->dev_softc,
+		if (pci_set_dma_mask(ahd->dev_softc,
 				     ahd->platform_data->hw_dma_mask)) {
 			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
 			return (ENODEV);
 		}
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
 	if (*vaddr == NULL)
 		return (ENOMEM);
 	*mapp = map;
@@ -1803,12 +1759,8 @@ void
 ahd_dmamem_free(struct ahd_softc *ahd, bus_dma_tag_t dmat,
 		void* vaddr, bus_dmamap_t map)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	pci_free_consistent(ahd->dev_softc, dmat->maxsize,
 			    vaddr, map->bus_addr);
-#else
-	free(vaddr, M_DEVBUF);
-#endif
 }
 
 int
@@ -1822,12 +1774,7 @@ ahd_dmamap_load(struct ahd_softc *ahd, b
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
@@ -2059,9 +2006,7 @@ aic79xx_setup(char *s)
 	return 1;
 }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,3,0)
 __setup("aic79xx=", aic79xx_setup);
-#endif
 
 uint32_t aic79xx_verbose;
 
@@ -2104,8 +2049,7 @@ ahd_linux_register_host(struct ahd_softc
 		ahd_set_name(ahd, new_name);
 	}
 	host->unique_id = ahd->unit;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4) && \
-    LINUX_VERSION_CODE  < KERNEL_VERSION(2,5,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	scsi_set_pci_device(host, ahd->dev_softc);
 #endif
 	ahd_linux_setup_user_rd_strm_settings(ahd);
@@ -2257,15 +2201,9 @@ ahd_platform_alloc(struct ahd_softc *ahd
 	ahd->platform_data->completeq_timer.data = (u_long)ahd;
 	ahd->platform_data->completeq_timer.function =
 	    (ahd_linux_callback_t *)ahd_linux_thread_run_complete_queue;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	init_MUTEX_LOCKED(&ahd->platform_data->eh_sem);
 	init_MUTEX_LOCKED(&ahd->platform_data->dv_sem);
 	init_MUTEX_LOCKED(&ahd->platform_data->dv_cmd_sem);
-#else
-	ahd->platform_data->eh_sem = MUTEX_LOCKED;
-	ahd->platform_data->dv_sem = MUTEX_LOCKED;
-	ahd->platform_data->dv_cmd_sem = MUTEX_LOCKED;
-#endif
 	ahd_setup_runq_tasklet(ahd);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
 	return (0);
@@ -2325,13 +2263,10 @@ ahd_platform_free(struct ahd_softc *ahd)
 			base_addr = (u_long)ahd->bshs[0].maddr;
 			base_addr &= PAGE_MASK;
 			iounmap((void *)base_addr);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 			release_mem_region(ahd->platform_data->mem_busaddr,
 					   0x1000);
-#endif
 		}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0) && \
-    LINUX_VERSION_CODE  < KERNEL_VERSION(2,5,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
     		/*
 		 * In 2.4 we detach from the scsi midlayer before the PCI
 		 * layer invokes our remove callback.  No per-instance
@@ -4121,7 +4056,7 @@ ahd_linux_run_device_queue(struct ahd_so
 					  cmd->use_sg, dir);
 			scb->platform_data->xfer_len = 0;
 			for (sg = scb->sg_list; nseg > 0; nseg--, cur_seg++) {
-				bus_addr_t addr;
+				dma_addr_t addr;
 				bus_size_t len;
 
 				addr = sg_dma_address(cur_seg);
@@ -4132,7 +4067,7 @@ ahd_linux_run_device_queue(struct ahd_so
 			}
 		} else if (cmd->request_bufflen != 0) {
 			void *sg;
-			bus_addr_t addr;
+			dma_addr_t addr;
 			int dir;
 
 			sg = scb->sg_list;
@@ -4366,7 +4301,7 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		WARN_ON(lun != CAM_LUN_WILDCARD);
 		scsi_report_device_reset(ahd->platform_data->host,
 					 channel - 'A', target);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
+#else
 		Scsi_Device *scsi_dev;
 
 		/*
@@ -4387,12 +4322,10 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		break;
 	}
         case AC_BUS_RESET:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 		if (ahd->platform_data->host != NULL) {
 			scsi_report_bus_reset(ahd->platform_data->host,
 					      channel - 'A');
 		}
-#endif
                 break;
         default:
                 panic("ahd_send_async: Unexpected async event");

_
