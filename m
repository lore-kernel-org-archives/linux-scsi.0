From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/16] gdth: split out pci probing
Date: Sun, 30 Sep 2007 21:55:30 +0200
Message-ID: <46FFFF32.5080306@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa15.bezeqint.net ([192.115.104.30]:39609 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbXI3Tzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 15:55:38 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


Split out per-device pci probing and put it under proper CONFIG_PCI.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/gdth.c |  287 +++++++++++++++++++++++++++-----------------------
 1 files changed, 155 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5240acd..882479b 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -482,6 +482,9 @@ static int gdth_isa_probe_one(struct scsi_host_template *, ulong32);
 #ifdef CONFIG_EISA
 static int gdth_eisa_probe_one(struct scsi_host_template *, ushort);
 #endif
+#ifdef CONFIG_PCI
+static int gdth_pci_probe_one(struct scsi_host_template *, gdth_pci_str *, int);
+#endif
 
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
@@ -4290,12 +4293,10 @@ static int __init gdth_detect(struct scsi_host_template *shtp)
 static int __init gdth_detect(Scsi_Host_Template *shtp)
 #endif
 {
-    struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
-    gdth_ha_str *ha;
     ulong32 isa_bios;
     ushort eisa_slot;
-    int i,hanum,cnt,ctr,err;
+    int cnt,ctr;
     unchar b;
     
  
@@ -4347,143 +4348,17 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
     }
 #endif
 
+#ifdef CONFIG_PCI
     /* scanning for PCI controllers */
     cnt = gdth_search_pci(pcistr);
     printk("GDT-HA: Found %d PCI Storage RAID Controllers\n",cnt);
     gdth_sort_pci(pcistr,cnt);
     for (ctr = 0; ctr < cnt; ++ctr) {
-        dma_addr_t scratch_dma_handle;
-        scratch_dma_handle = 0;
-
         if (gdth_ctr_count >= MAXHA)
             break;
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
+        gdth_pci_probe_one(shtp, pcistr, ctr);
     }
+#endif
     
     TRACE2(("gdth_detect() %d controller detected\n",gdth_ctr_count));
     if (gdth_ctr_count > 0) {
@@ -5725,6 +5600,154 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 }
 #endif /* CONFIG_EISA */
 
+#ifdef CONFIG_PCI
+static int gdth_pci_probe_one(struct scsi_host_template *shtp,
+		gdth_pci_str *pcistr, int ctr)
+{
+	struct Scsi_Host *shp;
+	gdth_ha_str *ha;
+	dma_addr_t scratch_dma_handle = 0;
+	int error, hanum, i;
+	u8 b;
+
+	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	if (!shp)
+		return -ENOMEM;
+	ha = HADATA(shp);
+
+	error = -ENODEV;
+	if (!gdth_init_pci(&pcistr[ctr],ha))
+		goto out_host_put;
+
+	/* controller found and initialized */
+	printk("Configuring GDT-PCI HA at %d/%d IRQ %u\n",
+		pcistr[ctr].pdev->bus->number,
+		PCI_SLOT(pcistr[ctr].pdev->devfn),
+		ha->irq);
+
+	error = request_irq(ha->irq, gdth_interrupt,
+				IRQF_DISABLED|IRQF_SHARED, "gdth", ha);
+	if (error) {
+		printk("GDT-PCI: Unable to allocate IRQ\n");
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
+
+	ha->pccb = CMDDATA(shp);
+	ha->ccb_phys = 0L;
+
+	error = -ENOMEM;
+
+	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
+						&scratch_dma_handle);
+	if (!ha->pscratch)
+		goto out_free_irq;
+	ha->scratch_phys = scratch_dma_handle;
+
+	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str),
+					&scratch_dma_handle);
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
+	ha->scratch_busy = FALSE;
+	ha->req_first = NULL;
+	ha->tid_cnt = pcistr[ctr].pdev->device >= 0x200 ? MAXID : MAX_HDRIVES;
+	if (max_ids > 0 && max_ids < ha->tid_cnt)
+		ha->tid_cnt = max_ids;
+	for (i = 0; i < GDTH_MAXCMDS; ++i)
+		ha->cmd_tab[i].cmnd = UNUSED_CMND;
+	ha->scan_mode = rescan ? 0x10 : 0;
+
+	error = -ENODEV;
+	if (!gdth_search_drives(hanum)) {
+		printk("GDT-PCI %d: Error during device scan\n", hanum);
+		goto out_free_coal_stat;
+	}
+
+	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+		hdr_channel = ha->bus_cnt;
+	ha->virt_bus = hdr_channel;
+
+	/* 64-bit DMA only supported from FW >= x.43 */
+	if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) ||
+	    !ha->dma64_support) {
+		if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
+			printk(KERN_WARNING "GDT-PCI %d: "
+				"Unable to set 32-bit DMA\n", hanum);
+				goto out_free_coal_stat;
+		}
+	} else {
+		shp->max_cmd_len = 16;
+		if (!pci_set_dma_mask(pcistr[ctr].pdev, DMA_64BIT_MASK)) {
+			printk("GDT-PCI %d: 64-bit DMA enabled\n", hanum);
+		} else if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
+			printk(KERN_WARNING "GDT-PCI %d: "
+				"Unable to set 64/32-bit DMA\n", hanum);
+			goto out_free_coal_stat;
+		}
+	}
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
+#endif /* CONFIG_PCI */
+
 #include "scsi_module.c"
 #ifndef MODULE
 __setup("gdth=", option_setup);
