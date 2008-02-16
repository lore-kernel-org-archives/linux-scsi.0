From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/2] SCSI/gdth: PCI probe cleanups, prep for PCI hotplug API conversion
Date: Fri, 15 Feb 2008 21:35:26 -0500
Message-ID: <464f0fc5a3e43386b8b2d03812339b1046ae70a1.1203132579.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:57671 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYBPDdd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 22:33:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

- Reduce uses of gdth_pci_str::pdev, preferring a local variable
  (or function arg) 'pdev' instead.

- Reduce uses of gdth_pcistr array, preferring local variable
  (or function arg) 'pcistr' instead.

- Eliminate lone use of gdth_pci_str::irq, using equivalent
  pdev->irq instead

- Eliminate assign-only gdth_pci_str::io_mm

Note:  If the indentation seems weird, that's because a line was
converted from spaces to tabs, when it was modified.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
NOTE: this patch series supercedes the previous "gdth: convert to PCI
hotplug API" patch.

 drivers/scsi/gdth.c |   59 ++++++++++++++++++++++++--------------------------
 drivers/scsi/gdth.h |    2 -
 2 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6d67f5c..56c2b91 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -653,7 +653,6 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
 
         /* GDT PCI controller found, resources are already in pdev */
         pcistr[*cnt].pdev = pdev;
-        pcistr[*cnt].irq = pdev->irq;
         base0 = pci_resource_flags(pdev, 0);
         base1 = pci_resource_flags(pdev, 1);
         base2 = pci_resource_flags(pdev, 2);
@@ -668,7 +667,6 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
                 !(base1 & IORESOURCE_IO)) 
                 continue;
             pcistr[*cnt].dpmem = pci_resource_start(pdev, 2);
-            pcistr[*cnt].io_mm = pci_resource_start(pdev, 0);
             pcistr[*cnt].io    = pci_resource_start(pdev, 1);
         }
         TRACE2(("Controller found at %d/%d, irq %d, dpmem 0x%lx\n",
@@ -913,7 +911,8 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
+static int __init gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
+				gdth_ha_str *ha)
 {
     register gdt6_dpram_str __iomem *dp6_ptr;
     register gdt6c_dpram_str __iomem *dp6c_ptr;
@@ -925,14 +924,14 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
 
     TRACE(("gdth_init_pci()\n"));
 
-    if (pcistr->pdev->vendor == PCI_VENDOR_ID_INTEL)
+    if (pdev->vendor == PCI_VENDOR_ID_INTEL)
         ha->oem_id = OEM_ID_INTEL;
     else
         ha->oem_id = OEM_ID_ICP;
-    ha->brd_phys = (pcistr->pdev->bus->number << 8) | (pcistr->pdev->devfn & 0xf8);
-    ha->stype = (ulong32)pcistr->pdev->device;
-    ha->irq = pcistr->irq;
-    ha->pdev = pcistr->pdev;
+    ha->brd_phys = (pdev->bus->number << 8) | (pdev->devfn & 0xf8);
+    ha->stype = (ulong32)pdev->device;
+    ha->irq = pdev->irq;
+    ha->pdev = pdev;
     
     if (ha->pdev->device <= PCI_DEVICE_ID_VORTEX_GDT6000B) {  /* GDT6000/B */
         TRACE2(("init_pci() dpmem %lx irq %d\n",pcistr->dpmem,ha->irq));
@@ -960,8 +959,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     continue;
                 }
                 iounmap(ha->brd);
-                pci_write_config_dword(pcistr->pdev, 
-                                       PCI_BASE_ADDRESS_0, i);
+		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, i);
                 ha->brd = ioremap(i, sizeof(gdt6_dpram_str)); 
                 if (ha->brd == NULL) {
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
@@ -1070,8 +1068,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     continue;
                 }
                 iounmap(ha->brd);
-                pci_write_config_dword(pcistr->pdev, 
-                                       PCI_BASE_ADDRESS_2, i);
+		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_2, i);
                 ha->brd = ioremap(i, sizeof(gdt6c_dpram_str)); 
                 if (ha->brd == NULL) {
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
@@ -1163,16 +1160,16 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         }
 
         /* manipulate config. space to enable DPMEM, start RP controller */
-        pci_read_config_word(pcistr->pdev, PCI_COMMAND, &command);
+	pci_read_config_word(pdev, PCI_COMMAND, &command);
         command |= 6;
-        pci_write_config_word(pcistr->pdev, PCI_COMMAND, command);
-        if (pci_resource_start(pcistr->pdev, 8) == 1UL)
-            pci_resource_start(pcistr->pdev, 8) = 0UL;
+	pci_write_config_word(pdev, PCI_COMMAND, command);
+	if (pci_resource_start(pdev, 8) == 1UL)
+	    pci_resource_start(pdev, 8) = 0UL;
         i = 0xFEFF0001UL;
-        pci_write_config_dword(pcistr->pdev, PCI_ROM_ADDRESS, i);
+	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, i);
         gdth_delay(1);
-        pci_write_config_dword(pcistr->pdev, PCI_ROM_ADDRESS,
-                               pci_resource_start(pcistr->pdev, 8));
+	pci_write_config_dword(pdev, PCI_ROM_ADDRESS,
+			       pci_resource_start(pdev, 8));
         
         dp6m_ptr = ha->brd;
 
@@ -1199,8 +1196,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     continue;
                 }
                 iounmap(ha->brd);
-                pci_write_config_dword(pcistr->pdev, 
-                                       PCI_BASE_ADDRESS_0, i);
+		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, i);
                 ha->brd = ioremap(i, sizeof(gdt6m_dpram_str)); 
                 if (ha->brd == NULL) {
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
@@ -4998,12 +4994,13 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
+static int __init gdth_pci_probe_one(gdth_pci_str *pcistr)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
 	int error, i;
+	struct pci_dev *pdev = pcistr->pdev;
 
 	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
@@ -5011,13 +5008,13 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	ha = shost_priv(shp);
 
 	error = -ENODEV;
-	if (!gdth_init_pci(&pcistr[ctr],ha))
+	if (!gdth_init_pci(pdev, pcistr, ha))
 		goto out_host_put;
 
 	/* controller found and initialized */
 	printk("Configuring GDT-PCI HA at %d/%d IRQ %u\n",
-		pcistr[ctr].pdev->bus->number,
-		PCI_SLOT(pcistr[ctr].pdev->devfn),
+		pdev->bus->number,
+		PCI_SLOT(pdev->devfn),
 		ha->irq);
 
 	error = request_irq(ha->irq, gdth_interrupt,
@@ -5062,7 +5059,7 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 
 	ha->scratch_busy = FALSE;
 	ha->req_first = NULL;
-	ha->tid_cnt = pcistr[ctr].pdev->device >= 0x200 ? MAXID : MAX_HDRIVES;
+	ha->tid_cnt = pdev->device >= 0x200 ? MAXID : MAX_HDRIVES;
 	if (max_ids > 0 && max_ids < ha->tid_cnt)
 		ha->tid_cnt = max_ids;
 	for (i = 0; i < GDTH_MAXCMDS; ++i)
@@ -5082,16 +5079,16 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	/* 64-bit DMA only supported from FW >= x.43 */
 	if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) ||
 	    !ha->dma64_support) {
-		if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "GDT-PCI %d: "
 				"Unable to set 32-bit DMA\n", ha->hanum);
 				goto out_free_coal_stat;
 		}
 	} else {
 		shp->max_cmd_len = 16;
-		if (!pci_set_dma_mask(pcistr[ctr].pdev, DMA_64BIT_MASK)) {
+		if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
 			printk("GDT-PCI %d: 64-bit DMA enabled\n", ha->hanum);
-		} else if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
+		} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "GDT-PCI %d: "
 				"Unable to set 64/32-bit DMA\n", ha->hanum);
 			goto out_free_coal_stat;
@@ -5105,7 +5102,7 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(ha);
 
-	error = scsi_add_host(shp, &pcistr[ctr].pdev->dev);
+	error = scsi_add_host(shp, &pdev->dev);
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
@@ -5218,7 +5215,7 @@ static int __init gdth_init(void)
 		printk("GDT-HA: Found %d PCI Storage RAID Controllers\n", cnt);
 		gdth_sort_pci(pcistr,cnt);
 		for (ctr = 0; ctr < cnt; ++ctr)
-			gdth_pci_probe_one(pcistr, ctr);
+			gdth_pci_probe_one(&pcistr[ctr]);
 	}
 #endif /* CONFIG_PCI */
 
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1434c6b..8193f4b 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -839,8 +839,6 @@ typedef struct {
     struct pci_dev      *pdev;
     ulong               dpmem;                  /* DPRAM address */
     ulong               io;                     /* IO address */
-    ulong               io_mm;                  /* IO address mem. mapped */
-    unchar              irq;                    /* IRQ */
 } gdth_pci_str;
 
 
-- 
1.5.3.8

