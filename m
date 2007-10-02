From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 03/16] gdth: split out isa probing
Date: Tue, 02 Oct 2007 22:48:16 +0200
Message-ID: <4702AE90.4020806@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1412 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752956AbXJBUsb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 16:48:31 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kerne>

From: Christoph Hellwig <hch@lst.de>

(note: this is ontop of Jeff's pci cleanup patch)

Split out isa probing into a helper of it's own.  Error handling is
cleaned up, but errors are not propagated yet.  Also enclose the isa
probe under the proper CONFIG_ISA symbol instead of the !IA64 hack.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |  296 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 162 insertions(+), 134 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index fe5db2d..add2ebb 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -445,13 +445,11 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive);
 
 static int gdth_search_eisa(ushort eisa_adr);
-static int gdth_search_isa(ulong32 bios_adr);
 static int gdth_search_pci(gdth_pci_str *pcistr);
 static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt, 
                             ushort vendor, ushort dev);
 static void gdth_sort_pci(gdth_pci_str *pcistr, int cnt);
 static int gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha);
-static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
 static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
 
 static void gdth_enable_int(int hanum);
@@ -476,6 +474,9 @@ static void gdth_flush(int hanum);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static void gdth_scsi_done(struct scsi_cmnd *scp);
+#ifdef CONFIG_ISA
+static int gdth_isa_probe_one(struct scsi_host_template *, ulong32);
+#endif
 
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
@@ -584,7 +585,10 @@ static struct timer_list gdth_timer;
 #define gdth_writew(b,addr)     writew((b),(addr))
 #define gdth_writel(b,addr)     writel((b),(addr))
 
+#ifdef CONFIG_ISA
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
+#endif
+
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 static unchar   gdth_polling;                           /* polling if TRUE */
 static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
@@ -838,7 +842,7 @@ static int __init gdth_search_eisa(ushort eisa_adr)
     return 0;                                   
 }
 
-
+#ifdef CONFIG_ISA
 static int __init gdth_search_isa(ulong32 bios_adr)
 {
     void __iomem *addr;
@@ -853,7 +857,7 @@ static int __init gdth_search_isa(ulong32 bios_adr)
     }
     return 0;
 }
-
+#endif /* CONFIG_ISA */
 
 static int __init gdth_search_pci(gdth_pci_str *pcistr)
 {
@@ -1064,7 +1068,7 @@ static int __init gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha)
     return 1;
 }
 
-       
+#ifdef CONFIG_ISA
 static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
 {
     register gdt2_dpram_str __iomem *dp2_ptr;
@@ -1163,7 +1167,7 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
     ha->dma64_support = 0;
     return 1;
 }
-
+#endif /* CONFIG_ISA */
 
 static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
 {
@@ -4282,6 +4286,7 @@ int __init option_setup(char *str)
     return 1;
 }
 
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int __init gdth_detect(struct scsi_host_template *shtp)
 #else
@@ -4291,7 +4296,6 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
     gdth_ha_str *ha;
-    ulong32 isa_bios;
     ushort eisa_slot;
     int i,hanum,cnt,ctr,err;
     unchar b;
@@ -4328,135 +4332,16 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
     /* As default we do not probe for EISA or ISA controllers */
     if (probe_eisa_isa) {    
         /* scanning for controllers, at first: ISA controller */
-        for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
-            dma_addr_t scratch_dma_handle;
-            scratch_dma_handle = 0;
-
-            if (gdth_ctr_count >= MAXHA) 
+#ifdef CONFIG_ISA
+        ulong32 isa_bios;
+        for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
+             isa_bios += 0x8000UL) {
+            if (gdth_ctr_count >= MAXHA)
                 break;
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
-            }
+            gdth_isa_probe_one(shtp, isa_bios);
         }
+#endif
 
-        /* scanning for EISA controllers */
         for (eisa_slot=0x1000; eisa_slot<=0x8000; eisa_slot+=0x1000) {
             dma_addr_t scratch_dma_handle;
             scratch_dma_handle = 0;
@@ -4754,7 +4639,7 @@ static int gdth_release(struct Scsi_Host *shp)
         if (shp->irq) {
             free_irq(shp->irq,ha);
         }
-#ifndef __ia64__
+#ifdef CONFIG_ISA
         if (shp->dma_channel != 0xff) {
             free_dma(shp->dma_channel);
         }
@@ -5674,6 +5559,149 @@ static Scsi_Host_Template driver_template = {
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
-- 
1.5.3.1


