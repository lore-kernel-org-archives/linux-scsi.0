From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from aic7xxx_osm.c
Date: Mon, 21 Jun 2004 20:16:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621181623.GT1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:61662 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266376AbUFUSQW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:16:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id CC4205C0A4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:16:21 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 06350-01 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:16:20 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id DB78F5C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:16:19 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcTLD-0004Iz-GW
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:16:23 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx_osm.c |   95 +++------------------
 1 files changed, 14 insertions(+), 81 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~remove-old-ifdefs-aic7xxx_osm.c drivers/scsi/aic7xxx/aic7xxx_osm.c
--- linux-2.6.7/drivers/scsi/aic7xxx/aic7xxx_osm.c~remove-old-ifdefs-aic7xxx_osm.c	2004-06-18 09:14:29.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-06-18 09:14:29.000000000 +0200
@@ -129,10 +129,7 @@
  */
 #include "aiclib.c"
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 #include <linux/init.h>		/* __setup */
-#endif
-
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 #include "sd.h"			/* For geometry detection */
@@ -151,14 +148,6 @@ spinlock_t ahc_list_spinlock;
 u_int ahc_linux_nseg;
 #endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
-struct proc_dir_entry proc_scsi_aic7xxx = {
-	PROC_SCSI_AIC7XXX, 7, "aic7xxx",
-	S_IFDIR | S_IRUGO | S_IXUGO, 2,
-	0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL
-};
-#endif
-
 /*
  * Set this to the delay in seconds after SCSI bus reset.
  * Note, we honor this only for the initial bus reset.
@@ -574,7 +563,7 @@ static __inline void ahc_linux_unmap_scb
 
 static __inline int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
 		 		      struct ahc_dma_seg *sg,
-				      bus_addr_t addr, bus_size_t len);
+				      dma_addr_t addr, bus_size_t len);
 
 static __inline void
 ahc_schedule_completeq(struct ahc_softc *ahc)
@@ -592,14 +581,7 @@ ahc_schedule_completeq(struct ahc_softc 
 static __inline void
 ahc_schedule_runq(struct ahc_softc *ahc)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	tasklet_schedule(&ahc->platform_data->runq_tasklet);
-#else
-	/*
-	 * Tasklets are not available, so run inline.
-	 */
-	ahc_runq_tasklet((unsigned long)ahc);
-#endif
 }
 
 static __inline struct ahc_linux_device*
@@ -730,7 +712,7 @@ ahc_linux_unmap_scb(struct ahc_softc *ah
 
 static __inline int
 ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
-		  struct ahc_dma_seg *sg, bus_addr_t addr, bus_size_t len)
+		  struct ahc_dma_seg *sg, dma_addr_t addr, bus_size_t len)
 {
 	int	 consumed;
 
@@ -742,7 +724,7 @@ ahc_linux_map_seg(struct ahc_softc *ahc,
 	sg->addr = ahc_htole32(addr & 0xFFFFFFFF);
 	scb->platform_data->xfer_len += len;
 
-	if (sizeof(bus_addr_t) > 4
+	if (sizeof(dma_addr_t) > 4
 	 && (ahc->flags & AHC_39BIT_ADDRESSING) != 0)
 		len |= (addr >> 8) & AHC_SG_HIGH_ADDR_MASK;
 
@@ -880,11 +862,7 @@ ahc_linux_detect(Scsi_Host_Template *tem
 "aic7xxx: insmod or else it might trash certain memory areas.\n");
 #endif
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,3,0)
 	template->proc_name = "aic7xxx";
-#else
-	template->proc_dir = &proc_scsi_aic7xxx;
-#endif
 
 	/*
 	 * Initialize our softc list lock prior to
@@ -1330,28 +1308,20 @@ ahc_runq_tasklet(unsigned long data)
 {
 	struct ahc_softc* ahc;
 	struct ahc_linux_device *dev;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	u_long flags;
-#endif
 
 	ahc = (struct ahc_softc *)data;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	ahc_lock(ahc, &flags);
-#endif
 	while ((dev = ahc_linux_next_device_to_run(ahc)) != NULL) {
 	
 		TAILQ_REMOVE(&ahc->platform_data->device_runq, dev, links);
 		dev->flags &= ~AHC_DEV_ON_RUN_LIST;
 		ahc_linux_check_device_queue(ahc, dev);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		/* Yeild to our interrupt handler */
 		ahc_unlock(ahc, &flags);
 		ahc_lock(ahc, &flags);
-#endif
 	}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	ahc_unlock(ahc, &flags);
-#endif
 }
 
 /******************************** Macros **************************************/
@@ -1364,7 +1334,7 @@ ahc_runq_tasklet(unsigned long data)
 int
 ahc_dma_tag_create(struct ahc_softc *ahc, bus_dma_tag_t parent,
 		   bus_size_t alignment, bus_size_t boundary,
-		   bus_addr_t lowaddr, bus_addr_t highaddr,
+		   dma_addr_t lowaddr, dma_addr_t highaddr,
 		   bus_dma_filter_t *filter, void *filterarg,
 		   bus_size_t maxsize, int nsegments,
 		   bus_size_t maxsegsz, int flags, bus_dma_tag_t *ret_tag)
@@ -1401,7 +1371,6 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, 
 {
 	bus_dmamap_t map;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	map = malloc(sizeof(*map), M_DEVBUF, M_NOWAIT);
 	if (map == NULL)
 		return (ENOMEM);
@@ -1413,28 +1382,18 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahc->dev_softc != NULL)
-		if (ahc_pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
 			return (ENODEV);
 		}
 	*vaddr = pci_alloc_consistent(ahc->dev_softc,
 				      dmat->maxsize, &map->bus_addr);
 	if (ahc->dev_softc != NULL)
-		if (ahc_pci_set_dma_mask(ahc->dev_softc,
+		if (pci_set_dma_mask(ahc->dev_softc,
 				     ahc->platform_data->hw_dma_mask)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
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
@@ -1445,12 +1404,8 @@ void
 ahc_dmamem_free(struct ahc_softc *ahc, bus_dma_tag_t dmat,
 		void* vaddr, bus_dmamap_t map)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	pci_free_consistent(ahc->dev_softc, dmat->maxsize,
 			    vaddr, map->bus_addr);
-#else
-	free(vaddr, M_DEVBUF);
-#endif
 }
 
 int
@@ -1464,12 +1419,7 @@ ahc_dmamap_load(struct ahc_softc *ahc, b
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
@@ -1480,9 +1430,10 @@ ahc_dmamap_destroy(struct ahc_softc *ahc
 {
 	/*
 	 * The map may is NULL in our < 2.3.X implementation.
+	 * Now it's 2.6.5, but just in case...
 	 */
-	if (map != NULL)
-		free(map, M_DEVBUF);
+	BUG_ON(map == NULL);
+	free(map, M_DEVBUF);
 }
 
 int
@@ -1698,9 +1649,7 @@ aic7xxx_setup(char *s)
 	return 1;
 }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,3,0)
 __setup("aic7xxx=", aic7xxx_setup);
-#endif
 
 uint32_t aic7xxx_verbose;
 
@@ -1743,8 +1692,7 @@ ahc_linux_register_host(struct ahc_softc
 		ahc_set_name(ahc, new_name);
 	}
 	host->unique_id = ahc->unit;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4) && \
-    LINUX_VERSION_CODE  < KERNEL_VERSION(2,5,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	scsi_set_pci_device(host, ahc->dev_softc);
 #endif
 	ahc_linux_initialize_scsi_bus(ahc);
@@ -1930,19 +1878,11 @@ ahc_platform_alloc(struct ahc_softc *ahc
 	ahc->platform_data->completeq_timer.data = (u_long)ahc;
 	ahc->platform_data->completeq_timer.function =
 	    (ahc_linux_callback_t *)ahc_linux_thread_run_complete_queue;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	init_MUTEX_LOCKED(&ahc->platform_data->eh_sem);
 	init_MUTEX_LOCKED(&ahc->platform_data->dv_sem);
 	init_MUTEX_LOCKED(&ahc->platform_data->dv_cmd_sem);
-#else
-	ahc->platform_data->eh_sem = MUTEX_LOCKED;
-	ahc->platform_data->dv_sem = MUTEX_LOCKED;
-	ahc->platform_data->dv_cmd_sem = MUTEX_LOCKED;
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	tasklet_init(&ahc->platform_data->runq_tasklet, ahc_runq_tasklet,
 		     (unsigned long)ahc);
-#endif
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
 	ahc->seltime_b = (aic7xxx_seltime & 0x3) << 4;
 	if (aic7xxx_pci_parity == 0)
@@ -1961,9 +1901,7 @@ ahc_platform_free(struct ahc_softc *ahc)
 	if (ahc->platform_data != NULL) {
 		del_timer_sync(&ahc->platform_data->completeq_timer);
 		ahc_linux_kill_dv_thread(ahc);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		tasklet_kill(&ahc->platform_data->runq_tasklet);
-#endif
 		if (ahc->platform_data->host != NULL) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 			scsi_remove_host(ahc->platform_data->host);
@@ -2004,13 +1942,10 @@ ahc_platform_free(struct ahc_softc *ahc)
 			base_addr = (u_long)ahc->bsh.maddr;
 			base_addr &= PAGE_MASK;
 			iounmap((void *)base_addr);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 			release_mem_region(ahc->platform_data->mem_busaddr,
 					   0x1000);
-#endif
 		}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0) && \
-    LINUX_VERSION_CODE  < KERNEL_VERSION(2,5,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 		/*
 		 * In 2.4 we detach from the scsi midlayer before the PCI
 		 * layer invokes our remove callback.  No per-instance
@@ -3756,7 +3691,7 @@ ahc_linux_run_device_queue(struct ahc_so
 			 * a transfer crosses a 32bit page.
 			 */ 
 			while (cur_seg < end_seg) {
-				bus_addr_t addr;
+				dma_addr_t addr;
 				bus_size_t len;
 				int consumed;
 
@@ -3785,7 +3720,7 @@ ahc_linux_run_device_queue(struct ahc_so
 			scb->hscb->datacnt = scb->sg_list->len;
 		} else if (cmd->request_bufflen != 0) {
 			struct	 ahc_dma_seg *sg;
-			bus_addr_t addr;
+			dma_addr_t addr;
 
 			sg = scb->sg_list;
 			addr = pci_map_single(ahc->dev_softc,
@@ -4069,7 +4004,7 @@ ahc_send_async(struct ahc_softc *ahc, ch
 		WARN_ON(lun != CAM_LUN_WILDCARD);
 		scsi_report_device_reset(ahc->platform_data->host,
 					 channel - 'A', target);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
+#else
 		Scsi_Device *scsi_dev;
 
 		/*
@@ -4090,12 +4025,10 @@ ahc_send_async(struct ahc_softc *ahc, ch
 		break;
 	}
         case AC_BUS_RESET:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 		if (ahc->platform_data->host != NULL) {
 			scsi_report_bus_reset(ahc->platform_data->host,
 					      channel - 'A');
 		}
-#endif
                 break;
         default:
                 panic("ahc_send_async: Unexpected async event");

_
