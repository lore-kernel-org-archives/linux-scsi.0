From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/7] gdth: split out isa probing
Date: Sat, 21 Jul 2007 19:01:41 +0200
Message-ID: <20070721170141.GB4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:58082 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXGURCA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 13:02:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: leubner@adaptec.com, jeff@garzik.org, linux-scsi@vger.kernel.org

(note: this is ontop of Jeff's pci cleanup patch)

Split out isa probing into a helper of it's own.  Error handling is
cleaned up, but errors are not propagated yet.  Also enclose the isa
probe under the proper CONFIG_ISA symbol instead of the !IA64 hack.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c	2007-07-11 17:34:31.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.c	2007-07-11 18:19:01.000000000 +0200
@@ -476,6 +476,9 @@ static void gdth_flush(int hanum);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static void gdth_scsi_done(struct scsi_cmnd *scp);
+#ifdef CONFIG_ISA
+static int gdth_isa_probe_one(struct scsi_host_template *, ulong32);
+#endif
 
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
@@ -4282,6 +4285,7 @@ int __init option_setup(char *str)
     return 1;
 }
 
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int __init gdth_detect(struct scsi_host_template *shtp)
 #else
@@ -4328,135 +4332,15 @@ static int __init gdth_detect(Scsi_Host_
     /* As default we do not probe for EISA or ISA controllers */
     if (probe_eisa_isa) {    
         /* scanning for controllers, at first: ISA controller */
-        for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
-            dma_addr_t scratch_dma_handle;
-            scratch_dma_handle = 0;
-
-            if (gdth_ctr_count >= MAXHA) 
-                break;
-            if (gdth_search_isa(isa_bios)) {        /* controller found */
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
+#ifdef CONFIG_ISA
+        for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
+	     isa_bios += 0x8000UL) {
+		if (gdth_ctr_count >= MAXHA)
+                	break;
+		gdth_isa_probe_one(shtp, isa_bios);
+	}
 #endif
-                if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
-                    shp->max_cmd_len = 16;
 
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
-            }
-        }
-
-        /* scanning for EISA controllers */
         for (eisa_slot=0x1000; eisa_slot<=0x8000; eisa_slot+=0x1000) {
             dma_addr_t scratch_dma_handle;
             scratch_dma_handle = 0;
@@ -4753,7 +4637,7 @@ static int gdth_release(struct Scsi_Host
         if (shp->irq) {
             free_irq(shp->irq,ha);
         }
-#ifndef __ia64__
+#ifdef CONFIG_ISA
         if (shp->dma_channel != 0xff) {
             free_dma(shp->dma_channel);
         }
@@ -5673,6 +5557,149 @@ static Scsi_Host_Template driver_templat
 #endif
 };
 
+#ifdef CONFIG_ISA
+static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
+{
+	struct Scsi_Host *shp;
+	gdth_ha_str *ha;
+	dma_addr_t scratch_dma_handle = 0;
+	int error, hanum, i;
+	u8 b;
+
+	if (!gdth_search_isa(isa_bios))
+		return -ENXIO;
+
+	shp = scsi_register(shtp, sizeof(gdth_ext_str));
+	if (!shp)
+		return -ENOMEM;
+	ha = HADATA(shp);
+
+	error = -ENODEV;
+	if (!gdth_init_isa(isa_bios,ha))
+		goto out_host_put;
+
+	/* controller found and initialized */
+	printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
+		isa_bios, ha->irq, ha->drq);
+
+	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	if (error) {
+		printk("GDT-ISA: Unable to allocate IRQ\n");
+		goto out_host_put;
+	}
+
+	error = request_dma(ha->drq, "gdth");
+	if (error) {
+		printk("GDT-ISA: Unable to allocate DMA channel\n");
+		goto out_free_irq;
+	}
+
+	set_dma_mode(ha->drq,DMA_MODE_CASCADE);
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
+
+	error = -ENOMEM;
+
+	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
+						&scratch_dma_handle);
+	if (!ha->pscratch)
+		goto out_dec_counters;
+	ha->scratch_phys = scratch_dma_handle;
+
+	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str),
+						&scratch_dma_handle);
+	if (!ha->pmsg)
+		goto out_free_pscratch;
+	ha->msg_phys = scratch_dma_handle;
+
+#ifdef INT_COAL
+	ha->coal_stat = pci_alloc_consistent(ha->pdev,
+				sizeof(gdth_coal_status) * MAXOFFSETS,
+				&scratch_dma_handle);
+	if (!ha->coal_stat)
+		goto out_free_pmsg;
+	ha->coal_stat_phys = scratch_dma_handle;
+#endif
+
+	ha->scratch_busy = FALSE;
+	ha->req_first = NULL;
+	ha->tid_cnt = MAX_HDRIVES;
+	if (max_ids > 0 && max_ids < ha->tid_cnt)
+		ha->tid_cnt = max_ids;
+	for (i = 0; i < GDTH_MAXCMDS; ++i)
+		ha->cmd_tab[i].cmnd = UNUSED_CMND;
+	ha->scan_mode = rescan ? 0x10 : 0;
+
+	error = -ENODEV;
+	if (!gdth_search_drives(hanum)) {
+		printk("GDT-ISA: Error during device scan\n");
+		goto out_free_coal_stat;
+	}
+
+	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+		hdr_channel = ha->bus_cnt;
+	ha->virt_bus = hdr_channel;
+
+	if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT)
+		shp->max_cmd_len = 16;
+
+	shp->max_id      = ha->tid_cnt;
+	shp->max_lun     = MAXLUN;
+	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
+	if (virt_ctr) {
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
+
+	return 0;
+
+ out_free_coal_stat:
+#ifdef INT_COAL
+	pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) * MAXOFFSETS,
+				ha->coal_stat, ha->coal_stat_phys);
+ out_free_pmsg:
+#endif
+	pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
+				ha->pmsg, ha->msg_phys);
+ out_free_pscratch:
+	pci_free_consistent(ha->pdev, GDTH_SCRATCH,
+				ha->pscratch, ha->scratch_phys);
+ out_dec_counters:
+	gdth_ctr_count--;
+	gdth_ctr_vcount--;
+ out_free_irq:
+	free_irq(ha->irq, ha);
+ out_host_put:
+	scsi_unregister(shp);
+	return error;
+}
+#endif /* CONFIG_ISA */
+
+
 #include "scsi_module.c"
 #ifndef MODULE
 __setup("gdth=", option_setup);
