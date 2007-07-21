From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/4] gdth: Split out EISA and ISA register code
Date: Fri, 20 Jul 2007 22:20:32 -0400
Message-ID: <20070721022032.GA7264@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:44793 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758936AbXGUCbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 22:31:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>


No code changes, only indentation and blank line additions, plus code to
call the new split-out functions.

commit 61b41cec514e93a06e56869b78c2f86b01c0c594
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Jul 20 20:05:32 2007 -0400

    [SCSI] gdth: Split out EISA and ISA register into separate functions
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/gdth.c |  518 ++++++++++++++++++++++++++++------------------------
 1 file changed, 279 insertions(+), 239 deletions(-)

61b41cec514e93a06e56869b78c2f86b01c0c594
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b0f5687..08f91d9 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4277,6 +4277,274 @@ int __init option_setup(char *str)
     return 1;
 }
 
+static int __init gdth_start_isa(struct scsi_host_template *shtp,
+				 ulong32 isa_bios)
+{
+	struct Scsi_Host *shp;
+	gdth_ha_str *ha;
+	int i, hanum;
+	dma_addr_t scratch_dma_handle = 0;
+
+	shp = scsi_register(shtp, sizeof(gdth_ext_str));
+	if (shp == NULL)
+		return 1;	/* continue looping */
+
+	ha = HADATA(shp);
+	if (!gdth_init_isa(isa_bios, ha)) {
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+#ifdef __ia64__
+	return 0;		/* end loop: success */
+#else
+	/* controller found and initialized */
+	printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
+	       isa_bios, ha->irq, ha->drq);
+
+	if (request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha)) {
+		printk("GDT-ISA: Unable to allocate IRQ\n");
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+	if (request_dma(ha->drq, "gdth")) {
+		printk("GDT-ISA: Unable to allocate DMA channel\n");
+		free_irq(ha->irq, ha);
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+	set_dma_mode(ha->drq, DMA_MODE_CASCADE);
+	enable_dma(ha->drq);
+	shp->unchecked_isa_dma = 1;
+	shp->irq = ha->irq;
+	shp->dma_channel = ha->drq;
+	hanum = gdth_ctr_count;         
+	gdth_ctr_tab[gdth_ctr_count++] = shp;
+	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+
+	NUMDATA(shp)->hanum = (ushort)hanum;
+	NUMDATA(shp)->busnum= 0;
+
+	ha->pccb = CMDDATA(shp);
+	ha->ccb_phys = 0L;
+	ha->pdev = NULL;
+	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
+					    &scratch_dma_handle);
+	ha->scratch_phys = scratch_dma_handle;
+	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str), 
+					&scratch_dma_handle);
+	ha->msg_phys = scratch_dma_handle;
+
+#ifdef INT_COAL
+	ha->coal_stat = (gdth_coal_status *)
+	pci_alloc_consistent(ha->pdev, sizeof(gdth_coal_status) *
+			     MAXOFFSETS, &scratch_dma_handle);
+	ha->coal_stat_phys = scratch_dma_handle;
+#endif
+
+	ha->scratch_busy = FALSE;
+	ha->req_first = NULL;
+	ha->tid_cnt = MAX_HDRIVES;
+	if (max_ids > 0 && max_ids < ha->tid_cnt)
+		ha->tid_cnt = max_ids;
+	for (i=0; i<GDTH_MAXCMDS; ++i)
+		ha->cmd_tab[i].cmnd = UNUSED_CMND;
+	ha->scan_mode = rescan ? 0x10 : 0;
+
+	if (ha->pscratch == NULL || ha->pmsg == NULL || 
+	    !gdth_search_drives(hanum)) {
+		printk("GDT-ISA: Error during device scan\n");
+		--gdth_ctr_count;
+		--gdth_ctr_vcount;
+
+#ifdef INT_COAL
+		if (ha->coal_stat)
+			pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
+					    MAXOFFSETS, ha->coal_stat,
+					    ha->coal_stat_phys);
+#endif
+
+		if (ha->pscratch)
+			pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
+					    ha->pscratch, ha->scratch_phys);
+		if (ha->pmsg)
+			pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
+					    ha->pmsg, ha->msg_phys);
+
+		free_irq(ha->irq,ha);
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+		hdr_channel = ha->bus_cnt;
+	ha->virt_bus = hdr_channel;
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
+    LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+	shp->highmem_io  = 0;
+#endif
+	if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
+		shp->max_cmd_len = 16;
+
+	shp->max_id      = ha->tid_cnt;
+	shp->max_lun     = MAXLUN;
+	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
+	if (virt_ctr) {
+		unchar b;
+
+		virt_ctr = 1;
+		/* register addit. SCSI channels as virtual controllers */
+		for (b = 1; b < ha->bus_cnt + 1; ++b) {
+			shp = scsi_register(shtp,sizeof(gdth_num_str));
+			shp->unchecked_isa_dma = 1;
+			shp->irq = ha->irq;
+			shp->dma_channel = ha->drq;
+			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+			NUMDATA(shp)->hanum = (ushort)hanum;
+			NUMDATA(shp)->busnum = b;
+		}
+	}  
+
+	spin_lock_init(&ha->smp_lock);
+	gdth_enable_int(hanum);
+#endif /* !__ia64__ */
+
+	return 1;	/* continue looping */
+}
+
+static int __init gdth_start_eisa(struct scsi_host_template *shtp,
+				  ushort eisa_slot)
+{
+	struct Scsi_Host *shp;
+	gdth_ha_str *ha;
+	int i, hanum;
+	dma_addr_t scratch_dma_handle = 0;
+
+	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	if (shp == NULL)
+		return 1;	/* continue looping */
+
+	ha = HADATA(shp);
+	if (!gdth_init_eisa(eisa_slot,ha)) {
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+	/* controller found and initialized */
+	printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
+	       eisa_slot >> 12, ha->irq);
+
+	if (request_irq(ha->irq,gdth_interrupt,IRQF_DISABLED,"gdth",ha)) {
+		printk("GDT-EISA: Unable to allocate IRQ\n");
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+	shp->unchecked_isa_dma = 0;
+	shp->irq = ha->irq;
+	shp->dma_channel = 0xff;
+	hanum = gdth_ctr_count;
+	gdth_ctr_tab[gdth_ctr_count++] = shp;
+	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+
+	NUMDATA(shp)->hanum = (ushort)hanum;
+	NUMDATA(shp)->busnum= 0;
+	TRACE2(("EISA detect Bus 0: hanum %d\n",
+	NUMDATA(shp)->hanum));
+
+	ha->pccb = CMDDATA(shp);
+	ha->ccb_phys = 0L; 
+
+	ha->pdev = NULL;
+	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
+					&scratch_dma_handle);
+	ha->scratch_phys = scratch_dma_handle;
+	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str), 
+					&scratch_dma_handle);
+	ha->msg_phys = scratch_dma_handle;
+
+#ifdef INT_COAL
+	ha->coal_stat = (gdth_coal_status *)
+		pci_alloc_consistent(ha->pdev, sizeof(gdth_coal_status) *
+					MAXOFFSETS, &scratch_dma_handle);
+	ha->coal_stat_phys = scratch_dma_handle;
+#endif
+
+	ha->ccb_phys = 
+		pci_map_single(ha->pdev,ha->pccb,
+				sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
+	ha->scratch_busy = FALSE;
+	ha->req_first = NULL;
+	ha->tid_cnt = MAX_HDRIVES;
+	if (max_ids > 0 && max_ids < ha->tid_cnt)
+		ha->tid_cnt = max_ids;
+	for (i=0; i<GDTH_MAXCMDS; ++i)
+		ha->cmd_tab[i].cmnd = UNUSED_CMND;
+	ha->scan_mode = rescan ? 0x10 : 0;
+
+	if (ha->pscratch == NULL || ha->pmsg == NULL || 
+	    !gdth_search_drives(hanum)) {
+		printk("GDT-EISA: Error during device scan\n");
+		--gdth_ctr_count;
+		--gdth_ctr_vcount;
+#ifdef INT_COAL
+		if (ha->coal_stat)
+			pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
+					MAXOFFSETS, ha->coal_stat,
+					ha->coal_stat_phys);
+#endif
+		if (ha->pscratch)
+			pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
+					ha->pscratch, ha->scratch_phys);
+		if (ha->pmsg)
+			pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
+					ha->pmsg, ha->msg_phys);
+		if (ha->ccb_phys)
+			pci_unmap_single(ha->pdev,ha->ccb_phys,
+				    sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
+		free_irq(ha->irq,ha);
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+		hdr_channel = ha->bus_cnt;
+	ha->virt_bus = hdr_channel;
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
+LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+	shp->highmem_io  = 0;
+#endif
+	if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
+		shp->max_cmd_len = 16;
+
+	shp->max_id      = ha->tid_cnt;
+	shp->max_lun     = MAXLUN;
+	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
+	if (virt_ctr) {
+		unchar b;
+
+		virt_ctr = 1;
+		/* register addit. SCSI channels as virtual controllers */
+		for (b = 1; b < ha->bus_cnt + 1; ++b) {
+			shp = scsi_register(shtp,sizeof(gdth_num_str));
+			shp->unchecked_isa_dma = 0;
+			shp->irq = ha->irq;
+			shp->dma_channel = 0xff;
+			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+			NUMDATA(shp)->hanum = (ushort)hanum;
+			NUMDATA(shp)->busnum = b;
+		}
+	}  
+
+	spin_lock_init(&ha->smp_lock);
+	gdth_enable_int(hanum);
+
+	return 1;	/* continue looping */
+}
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int __init gdth_detect(struct scsi_host_template *shtp)
 #else
@@ -4286,11 +4554,8 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
     gdth_ha_str *ha;
-    ulong32 isa_bios;
-    ushort eisa_slot;
     int i,hanum,cnt,ctr,err;
     unchar b;
-    
  
 #ifdef DEBUG_GDTH
     printk("GDT: This driver contains debugging information !! Trace level = %d\n",
@@ -4322,255 +4587,30 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
 
     /* As default we do not probe for EISA or ISA controllers */
     if (probe_eisa_isa) {    
+        ulong32 isa_bios;
+        ushort eisa_slot;
+
         /* scanning for controllers, at first: ISA controller */
         for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
-            dma_addr_t scratch_dma_handle;
-            scratch_dma_handle = 0;
-
             if (gdth_ctr_count >= MAXHA) 
                 break;
             if (gdth_search_isa(isa_bios)) {        /* controller found */
-                shp = scsi_register(shtp,sizeof(gdth_ext_str));
-                if (shp == NULL)
-                    continue;  
-
-                ha = HADATA(shp);
-                if (!gdth_init_isa(isa_bios,ha)) {
-                    scsi_unregister(shp);
-                    continue;
-                }
-#ifdef __ia64__
-                break;
-#else
-                /* controller found and initialized */
-                printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
-                       isa_bios,ha->irq,ha->drq);
-
-                if (request_irq(ha->irq,gdth_interrupt,IRQF_DISABLED,"gdth",ha)) {
-                    printk("GDT-ISA: Unable to allocate IRQ\n");
-                    scsi_unregister(shp);
-                    continue;
-                }
-                if (request_dma(ha->drq,"gdth")) {
-                    printk("GDT-ISA: Unable to allocate DMA channel\n");
-                    free_irq(ha->irq,ha);
-                    scsi_unregister(shp);
-                    continue;
-                }
-                set_dma_mode(ha->drq,DMA_MODE_CASCADE);
-                enable_dma(ha->drq);
-                shp->unchecked_isa_dma = 1;
-                shp->irq = ha->irq;
-                shp->dma_channel = ha->drq;
-                hanum = gdth_ctr_count;         
-                gdth_ctr_tab[gdth_ctr_count++] = shp;
-                gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-
-                NUMDATA(shp)->hanum = (ushort)hanum;
-                NUMDATA(shp)->busnum= 0;
-
-                ha->pccb = CMDDATA(shp);
-                ha->ccb_phys = 0L;
-                ha->pdev = NULL;
-                ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
-                                                    &scratch_dma_handle);
-                ha->scratch_phys = scratch_dma_handle;
-                ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str), 
-                                                &scratch_dma_handle);
-                ha->msg_phys = scratch_dma_handle;
-#ifdef INT_COAL
-                ha->coal_stat = (gdth_coal_status *)
-                    pci_alloc_consistent(ha->pdev, sizeof(gdth_coal_status) *
-                        MAXOFFSETS, &scratch_dma_handle);
-                ha->coal_stat_phys = scratch_dma_handle;
-#endif
-
-                ha->scratch_busy = FALSE;
-                ha->req_first = NULL;
-                ha->tid_cnt = MAX_HDRIVES;
-                if (max_ids > 0 && max_ids < ha->tid_cnt)
-                    ha->tid_cnt = max_ids;
-                for (i=0; i<GDTH_MAXCMDS; ++i)
-                    ha->cmd_tab[i].cmnd = UNUSED_CMND;
-                ha->scan_mode = rescan ? 0x10 : 0;
-
-                if (ha->pscratch == NULL || ha->pmsg == NULL || 
-                    !gdth_search_drives(hanum)) {
-                    printk("GDT-ISA: Error during device scan\n");
-                    --gdth_ctr_count;
-                    --gdth_ctr_vcount;
-
-#ifdef INT_COAL
-                    if (ha->coal_stat)
-                        pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-                                            MAXOFFSETS, ha->coal_stat,
-                                            ha->coal_stat_phys);
-#endif
-                    if (ha->pscratch)
-                        pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
-                                            ha->pscratch, ha->scratch_phys);
-                    if (ha->pmsg)
-                        pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
-                                            ha->pmsg, ha->msg_phys);
-
-                    free_irq(ha->irq,ha);
-                    scsi_unregister(shp);
-                    continue;
-                }
-                if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
-                    hdr_channel = ha->bus_cnt;
-                ha->virt_bus = hdr_channel;
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
-    LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-                shp->highmem_io  = 0;
-#endif
-                if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
-                    shp->max_cmd_len = 16;
-
-                shp->max_id      = ha->tid_cnt;
-                shp->max_lun     = MAXLUN;
-                shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-                if (virt_ctr) {
-                    virt_ctr = 1;
-                    /* register addit. SCSI channels as virtual controllers */
-                    for (b = 1; b < ha->bus_cnt + 1; ++b) {
-                        shp = scsi_register(shtp,sizeof(gdth_num_str));
-                        shp->unchecked_isa_dma = 1;
-                        shp->irq = ha->irq;
-                        shp->dma_channel = ha->drq;
-                        gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-                        NUMDATA(shp)->hanum = (ushort)hanum;
-                        NUMDATA(shp)->busnum = b;
-                    }
-                }  
-
-                spin_lock_init(&ha->smp_lock);
-                gdth_enable_int(hanum);
-#endif /* !__ia64__ */
+	        err = gdth_start_isa(shtp, isa_bios);
+		if (err <= 0)
+			break;
+	    	/* err > 0 == continue looping */
             }
         }
 
         /* scanning for EISA controllers */
         for (eisa_slot=0x1000; eisa_slot<=0x8000; eisa_slot+=0x1000) {
-            dma_addr_t scratch_dma_handle;
-            scratch_dma_handle = 0;
-
             if (gdth_ctr_count >= MAXHA) 
                 break;
             if (gdth_search_eisa(eisa_slot)) {      /* controller found */
-                shp = scsi_register(shtp,sizeof(gdth_ext_str));
-                if (shp == NULL)
-                    continue;  
-
-                ha = HADATA(shp);
-                if (!gdth_init_eisa(eisa_slot,ha)) {
-                    scsi_unregister(shp);
-                    continue;
-                }
-                /* controller found and initialized */
-                printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
-                       eisa_slot>>12,ha->irq);
-
-                if (request_irq(ha->irq,gdth_interrupt,IRQF_DISABLED,"gdth",ha)) {
-                    printk("GDT-EISA: Unable to allocate IRQ\n");
-                    scsi_unregister(shp);
-                    continue;
-                }
-                shp->unchecked_isa_dma = 0;
-                shp->irq = ha->irq;
-                shp->dma_channel = 0xff;
-                hanum = gdth_ctr_count;
-                gdth_ctr_tab[gdth_ctr_count++] = shp;
-                gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-
-                NUMDATA(shp)->hanum = (ushort)hanum;
-                NUMDATA(shp)->busnum= 0;
-                TRACE2(("EISA detect Bus 0: hanum %d\n",
-                        NUMDATA(shp)->hanum));
-
-                ha->pccb = CMDDATA(shp);
-                ha->ccb_phys = 0L; 
-
-                ha->pdev = NULL;
-                ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
-                                                    &scratch_dma_handle);
-                ha->scratch_phys = scratch_dma_handle;
-                ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str), 
-                                                &scratch_dma_handle);
-                ha->msg_phys = scratch_dma_handle;
-#ifdef INT_COAL
-                ha->coal_stat = (gdth_coal_status *)
-                    pci_alloc_consistent(ha->pdev, sizeof(gdth_coal_status) *
-                                         MAXOFFSETS, &scratch_dma_handle);
-                ha->coal_stat_phys = scratch_dma_handle;
-#endif
-                ha->ccb_phys = 
-                    pci_map_single(ha->pdev,ha->pccb,
-                                   sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
-                ha->scratch_busy = FALSE;
-                ha->req_first = NULL;
-                ha->tid_cnt = MAX_HDRIVES;
-                if (max_ids > 0 && max_ids < ha->tid_cnt)
-                    ha->tid_cnt = max_ids;
-                for (i=0; i<GDTH_MAXCMDS; ++i)
-                    ha->cmd_tab[i].cmnd = UNUSED_CMND;
-                ha->scan_mode = rescan ? 0x10 : 0;
-
-                if (ha->pscratch == NULL || ha->pmsg == NULL || 
-                    !gdth_search_drives(hanum)) {
-                    printk("GDT-EISA: Error during device scan\n");
-                    --gdth_ctr_count;
-                    --gdth_ctr_vcount;
-#ifdef INT_COAL
-                    if (ha->coal_stat)
-                        pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-                                            MAXOFFSETS, ha->coal_stat,
-                                            ha->coal_stat_phys);
-#endif
-                    if (ha->pscratch)
-                        pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
-                                            ha->pscratch, ha->scratch_phys);
-                    if (ha->pmsg)
-                        pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
-                                            ha->pmsg, ha->msg_phys);
-                    if (ha->ccb_phys)
-                        pci_unmap_single(ha->pdev,ha->ccb_phys,
-                                        sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
-                    free_irq(ha->irq,ha);
-                    scsi_unregister(shp);
-                    continue;
-                }
-                if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
-                    hdr_channel = ha->bus_cnt;
-                ha->virt_bus = hdr_channel;
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
-    LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-                shp->highmem_io  = 0;
-#endif
-                if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
-                    shp->max_cmd_len = 16;
-
-                shp->max_id      = ha->tid_cnt;
-                shp->max_lun     = MAXLUN;
-                shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-                if (virt_ctr) {
-                    virt_ctr = 1;
-                    /* register addit. SCSI channels as virtual controllers */
-                    for (b = 1; b < ha->bus_cnt + 1; ++b) {
-                        shp = scsi_register(shtp,sizeof(gdth_num_str));
-                        shp->unchecked_isa_dma = 0;
-                        shp->irq = ha->irq;
-                        shp->dma_channel = 0xff;
-                        gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-                        NUMDATA(shp)->hanum = (ushort)hanum;
-                        NUMDATA(shp)->busnum = b;
-                    }
-                }  
-
-                spin_lock_init(&ha->smp_lock);
-                gdth_enable_int(hanum);
+	        err = gdth_start_eisa(shtp, eisa_slot);
+		if (err <= 0)
+			break;
+	    	/* err > 0 == continue looping */
             }
         }
     }
