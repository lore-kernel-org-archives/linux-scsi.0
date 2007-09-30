From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/16] gdth: split out eisa probing
Date: Sun, 30 Sep 2007 21:50:57 +0200
Message-ID: <46FFFE21.4030902@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11804 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751723AbXI3TyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 15:54:21 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


Split eisa probing into it's own helper, and do proper error unwinding.
Protect EISA probind by the proper CONFIG_EISA symbol.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/gdth.c |  270 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 150 insertions(+), 120 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 9f82c01..5240acd 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -479,6 +479,9 @@ static void gdth_scsi_done(struct scsi_cmnd *scp);
 #ifdef CONFIG_ISA
 static int gdth_isa_probe_one(struct scsi_host_template *, ulong32);
 #endif
+#ifdef CONFIG_EISA
+static int gdth_eisa_probe_one(struct scsi_host_template *, ushort);
+#endif
 
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
@@ -4335,129 +4338,14 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
             gdth_isa_probe_one(shtp, isa_bios);
         }
 #endif
-
-        for (eisa_slot=0x1000; eisa_slot<=0x8000; eisa_slot+=0x1000) {
-            dma_addr_t scratch_dma_handle;
-            scratch_dma_handle = 0;
-
-            if (gdth_ctr_count >= MAXHA) 
+#ifdef CONFIG_EISA
+        for (eisa_slot = 0x1000; eisa_slot <= 0x8000; eisa_slot += 0x1000) {
+            if (gdth_ctr_count >= MAXHA)
                 break;
-            if (gdth_search_eisa(eisa_slot)) {      /* controller found */
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
-            }
+            gdth_eisa_probe_one(shtp, eisa_slot);
         }
     }
+#endif
 
     /* scanning for PCI controllers */
     cnt = gdth_search_pci(pcistr);
@@ -5694,6 +5582,148 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 }
 #endif /* CONFIG_ISA */
 
+#ifdef CONFIG_EISA
+static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
+		ushort eisa_slot)
+{
+	struct Scsi_Host *shp;
+	gdth_ha_str *ha;
+	dma_addr_t scratch_dma_handle = 0;
+	int error, hanum, i;
+	u8 b;
+
+	if (!gdth_search_eisa(eisa_slot))
+		return -ENXIO;
+
+	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	if (!shp)
+		return -ENOMEM;
+	ha = HADATA(shp);
+
+	error = -ENODEV;
+	if (!gdth_init_eisa(eisa_slot,ha))
+		goto out_host_put;
+
+	/* controller found and initialized */
+	printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
+		eisa_slot >> 12, ha->irq);
+
+	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	if (error) {
+		printk("GDT-EISA: Unable to allocate IRQ\n");
+		goto out_host_put;
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
+		NUMDATA(shp)->hanum));
+
+	ha->pccb = CMDDATA(shp);
+	ha->ccb_phys = 0L;
+
+	error = -ENOMEM;
+
+	ha->pdev = NULL;
+	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
+						&scratch_dma_handle);
+	if (!ha->pscratch)
+		goto out_free_irq;
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
+			sizeof(gdth_coal_status) * MAXOFFSETS,
+			&scratch_dma_handle);
+	if (!ha->coal_stat)
+		goto out_free_pmsg;
+	ha->coal_stat_phys = scratch_dma_handle;
+#endif
+
+	ha->ccb_phys = pci_map_single(ha->pdev,ha->pccb,
+			sizeof(gdth_cmd_str), PCI_DMA_BIDIRECTIONAL);
+	if (!ha->ccb_phys)
+		goto out_free_coal_stat;
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
+	if (!gdth_search_drives(hanum)) {
+		printk("GDT-EISA: Error during device scan\n");
+		error = -ENODEV;
+		goto out_free_ccb_phys;
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
+	return 0;
+
+ out_free_ccb_phys:
+	pci_unmap_single(ha->pdev,ha->ccb_phys, sizeof(gdth_cmd_str),
+			PCI_DMA_BIDIRECTIONAL);
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
+ out_free_irq:
+	free_irq(ha->irq, ha);
+	gdth_ctr_count--;
+	gdth_ctr_vcount--;
+ out_host_put:
+	scsi_unregister(shp);
+	return error;
+}
+#endif /* CONFIG_EISA */
 
 #include "scsi_module.c"
 #ifndef MODULE
-- 
1.5.3.1


