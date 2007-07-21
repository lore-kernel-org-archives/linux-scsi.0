From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/4] gdth: Split out PCI register code
Date: Fri, 20 Jul 2007 22:21:21 -0400
Message-ID: <20070721022121.GB7264@havoc.gtf.org>
References: <20070721022032.GA7264@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:59080 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726AbXGUCbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 22:31:08 -0400
Content-Disposition: inline
In-Reply-To: <20070721022032.GA7264@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>


No code changes, just indentation and blank line addition.

commit 098f6915936406179b27a9f448d65953383ad628
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Jul 20 20:23:20 2007 -0400

    [SCSI] gdth: Split out PCI register into separate function
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/gdth.c |  296 ++++++++++++++++++++++++++++------------------------
 1 file changed, 160 insertions(+), 136 deletions(-)

098f6915936406179b27a9f448d65953383ad628
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 08f91d9..9d38108 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4545,16 +4545,167 @@ LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	return 1;	/* continue looping */
 }
 
+static int __init gdth_start_pci(struct scsi_host_template *shtp,
+				 gdth_pci_str *pcistr, int ctr)
+{
+	struct Scsi_Host *shp;
+	dma_addr_t scratch_dma_handle = 0;
+	gdth_ha_str *ha;
+	int i, hanum, err;
+
+	if (gdth_ctr_count >= MAXHA)
+		return 0;	/* end loop: success */
+	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	if (shp == NULL)
+		return 1;	/* continue looping */
+
+	ha = HADATA(shp);
+	if (!gdth_init_pci(&pcistr[ctr],ha)) {
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+	/* controller found and initialized */
+	printk("Configuring GDT-PCI HA at %d/%d IRQ %u\n",
+	       pcistr[ctr].pdev->bus->number,
+	       PCI_SLOT(pcistr[ctr].pdev->devfn), ha->irq);
+
+	if (request_irq(ha->irq, gdth_interrupt,
+			IRQF_DISABLED | IRQF_SHARED, "gdth", ha)) {
+		printk("GDT-PCI: Unable to allocate IRQ\n");
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
+
+	ha->pccb = CMDDATA(shp);
+	ha->ccb_phys = 0L;
+
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
+	ha->scratch_busy = FALSE;
+	ha->req_first = NULL;
+	ha->tid_cnt = pcistr[ctr].pdev->device >= 0x200 ? MAXID : MAX_HDRIVES;
+	if (max_ids > 0 && max_ids < ha->tid_cnt)
+		ha->tid_cnt = max_ids;
+	for (i=0; i<GDTH_MAXCMDS; ++i)
+		ha->cmd_tab[i].cmnd = UNUSED_CMND;
+	ha->scan_mode = rescan ? 0x10 : 0;
+
+	err = FALSE;
+	if (ha->pscratch == NULL || ha->pmsg == NULL || 
+	    !gdth_search_drives(hanum)) {
+		err = TRUE;
+	} else {
+		if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+			hdr_channel = ha->bus_cnt;
+		ha->virt_bus = hdr_channel;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+		scsi_set_pci_device(shp, pcistr[ctr].pdev);
+#endif
+
+		if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &
+		      GDT_64BIT) ||
+			/* 64-bit DMA only supported from FW >= x.43 */
+		    (!ha->dma64_support)) {
+			if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)){
+				printk(KERN_WARNING "GDT-PCI %d: Unable to "
+				       "set 32-bit DMA\n", hanum);
+				err = TRUE;
+			}
+		} else {
+			shp->max_cmd_len = 16;
+			if (!pci_set_dma_mask(pcistr[ctr].pdev,DMA_64BIT_MASK)){
+				printk("GDT-PCI %d: 64-bit DMA enabled\n",
+				       hanum);
+			} else if (pci_set_dma_mask(pcistr[ctr].pdev,
+						    DMA_32BIT_MASK)) {
+				printk(KERN_WARNING "GDT-PCI %d: Unable to set "
+				       "64/32-bit DMA\n", hanum);
+				err = TRUE;
+			}
+		}
+	}
+
+	if (err) {
+		printk("GDT-PCI %d: Error during device scan\n", hanum);
+		--gdth_ctr_count;
+		--gdth_ctr_vcount;
+
+#ifdef INT_COAL
+		if (ha->coal_stat)
+			pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
+					MAXOFFSETS, ha->coal_stat,
+					ha->coal_stat_phys);
+#endif
+
+		if (ha->pscratch)
+			pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
+					ha->pscratch, ha->scratch_phys);
+		if (ha->pmsg)
+			pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
+					ha->pmsg, ha->msg_phys);
+		free_irq(ha->irq,ha);
+		scsi_unregister(shp);
+		return 1;	/* continue looping */
+	}
+
+	shp->max_id      = ha->tid_cnt;
+	shp->max_lun     = MAXLUN;
+	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
+
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
 static int __init gdth_detect(Scsi_Host_Template *shtp)
 #endif
 {
-    struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
-    gdth_ha_str *ha;
-    int i,hanum,cnt,ctr,err;
+    int cnt,ctr;
     unchar b;
  
 #ifdef DEBUG_GDTH
@@ -4595,7 +4746,7 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
             if (gdth_ctr_count >= MAXHA) 
                 break;
             if (gdth_search_isa(isa_bios)) {        /* controller found */
-	        err = gdth_start_isa(shtp, isa_bios);
+	        int err = gdth_start_isa(shtp, isa_bios);
 		if (err <= 0)
 			break;
 	    	/* err > 0 == continue looping */
@@ -4607,7 +4758,7 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
             if (gdth_ctr_count >= MAXHA) 
                 break;
             if (gdth_search_eisa(eisa_slot)) {      /* controller found */
-	        err = gdth_start_eisa(shtp, eisa_slot);
+	        int err = gdth_start_eisa(shtp, eisa_slot);
 		if (err <= 0)
 			break;
 	    	/* err > 0 == continue looping */
@@ -4620,137 +4771,10 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
     printk("GDT-HA: Found %d PCI Storage RAID Controllers\n",cnt);
     gdth_sort_pci(pcistr,cnt);
     for (ctr = 0; ctr < cnt; ++ctr) {
-        dma_addr_t scratch_dma_handle;
-        scratch_dma_handle = 0;
-
-        if (gdth_ctr_count >= MAXHA)
-            break;
-        shp = scsi_register(shtp,sizeof(gdth_ext_str));
-        if (shp == NULL)
-            continue;  
-
-        ha = HADATA(shp);
-        if (!gdth_init_pci(&pcistr[ctr],ha)) {
-            scsi_unregister(shp);
-            continue;
-        }
-        /* controller found and initialized */
-        printk("Configuring GDT-PCI HA at %d/%d IRQ %u\n",
-               pcistr[ctr].pdev->bus->number,
-	       PCI_SLOT(pcistr[ctr].pdev->devfn), ha->irq);
-
-        if (request_irq(ha->irq, gdth_interrupt,
-                        IRQF_DISABLED|IRQF_SHARED, "gdth", ha))
-        {
-            printk("GDT-PCI: Unable to allocate IRQ\n");
-            scsi_unregister(shp);
-            continue;
-        }
-        shp->unchecked_isa_dma = 0;
-        shp->irq = ha->irq;
-        shp->dma_channel = 0xff;
-        hanum = gdth_ctr_count;
-        gdth_ctr_tab[gdth_ctr_count++] = shp;
-        gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-
-        NUMDATA(shp)->hanum = (ushort)hanum;
-        NUMDATA(shp)->busnum= 0;
-
-        ha->pccb = CMDDATA(shp);
-        ha->ccb_phys = 0L;
-
-        ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
-                                            &scratch_dma_handle);
-        ha->scratch_phys = scratch_dma_handle;
-        ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str), 
-                                        &scratch_dma_handle);
-        ha->msg_phys = scratch_dma_handle;
-#ifdef INT_COAL
-        ha->coal_stat = (gdth_coal_status *)
-            pci_alloc_consistent(ha->pdev, sizeof(gdth_coal_status) *
-                                 MAXOFFSETS, &scratch_dma_handle);
-        ha->coal_stat_phys = scratch_dma_handle;
-#endif
-        ha->scratch_busy = FALSE;
-        ha->req_first = NULL;
-        ha->tid_cnt = pcistr[ctr].pdev->device >= 0x200 ? MAXID : MAX_HDRIVES;
-        if (max_ids > 0 && max_ids < ha->tid_cnt)
-            ha->tid_cnt = max_ids;
-        for (i=0; i<GDTH_MAXCMDS; ++i)
-            ha->cmd_tab[i].cmnd = UNUSED_CMND;
-        ha->scan_mode = rescan ? 0x10 : 0;
-
-        err = FALSE;
-        if (ha->pscratch == NULL || ha->pmsg == NULL || 
-            !gdth_search_drives(hanum)) {
-            err = TRUE;
-        } else {
-            if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
-                hdr_channel = ha->bus_cnt;
-            ha->virt_bus = hdr_channel;
-
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-            scsi_set_pci_device(shp, pcistr[ctr].pdev);
-#endif
-            if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &GDT_64BIT)||
-                /* 64-bit DMA only supported from FW >= x.43 */
-                (!ha->dma64_support)) {
-                if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
-                    printk(KERN_WARNING "GDT-PCI %d: Unable to set 32-bit DMA\n", hanum);
-                    err = TRUE;
-                }
-            } else {
-                shp->max_cmd_len = 16;
-                if (!pci_set_dma_mask(pcistr[ctr].pdev, DMA_64BIT_MASK)) {
-                    printk("GDT-PCI %d: 64-bit DMA enabled\n", hanum);
-                } else if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
-                    printk(KERN_WARNING "GDT-PCI %d: Unable to set 64/32-bit DMA\n", hanum);
-                    err = TRUE;
-                }
-            }
-        }
-
-        if (err) {
-            printk("GDT-PCI %d: Error during device scan\n", hanum);
-            --gdth_ctr_count;
-            --gdth_ctr_vcount;
-#ifdef INT_COAL
-            if (ha->coal_stat)
-                pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-                                    MAXOFFSETS, ha->coal_stat,
-                                    ha->coal_stat_phys);
-#endif
-            if (ha->pscratch)
-                pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
-                                    ha->pscratch, ha->scratch_phys);
-            if (ha->pmsg)
-                pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
-                                    ha->pmsg, ha->msg_phys);
-            free_irq(ha->irq,ha);
-            scsi_unregister(shp);
-            continue;
-        }
-
-        shp->max_id      = ha->tid_cnt;
-        shp->max_lun     = MAXLUN;
-        shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-        if (virt_ctr) {
-            virt_ctr = 1;
-            /* register addit. SCSI channels as virtual controllers */
-            for (b = 1; b < ha->bus_cnt + 1; ++b) {
-                shp = scsi_register(shtp,sizeof(gdth_num_str));
-                shp->unchecked_isa_dma = 0;
-                shp->irq = ha->irq;
-                shp->dma_channel = 0xff;
-                gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-                NUMDATA(shp)->hanum = (ushort)hanum;
-                NUMDATA(shp)->busnum = b;
-            }
-        }  
-
-        spin_lock_init(&ha->smp_lock);
-        gdth_enable_int(hanum);
+        int err = gdth_start_pci(shtp, pcistr, ctr);
+	if (err <= 0)
+		break;
+    	/* err > 0 == continue looping */
     }
     
     TRACE2(("gdth_detect() %d controller detected\n",gdth_ctr_count));
