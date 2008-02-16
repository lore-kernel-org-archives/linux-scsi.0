From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/2 v2] SCSI/gdth: convert to PCI hotplug API
Date: Fri, 15 Feb 2008 22:20:09 -0500
Message-ID: <eb1e790a17cc01eaf22614989b92f1125d23b732.1203132579.git.jeff@garzik.org>
References: <464f0fc5a3e43386b8b2d03812339b1046ae70a1.1203132579.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:52259 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYBPDde (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 22:33:34 -0500
In-Reply-To: <464f0fc5a3e43386b8b2d03812339b1046ae70a1.1203132579.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Version 2:
- rediff'd against latest kernel (fix akpm-noticed conflicts)

- remove PCI device sort, which greatly simplifies PCI probe,
  permitting direct, per-HBA function calls rather than an indirect
  route to the same end result.

- remove need for pcistr[]

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
NOTE: MAXHA is still used after this, and must be removed in a separate
patch (after other code is updated).

 drivers/scsi/gdth.c |  196 ++++++++++++++++++++++++--------------------------
 1 files changed, 94 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 56c2b91..ad9aff2 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -595,123 +595,111 @@ static int __init gdth_search_isa(ulong32 bios_adr)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
-                            ushort vendor, ushort dev);
+static bool gdth_pci_registered;
 
-static int __init gdth_search_pci(gdth_pci_str *pcistr)
+static bool gdth_search_vortex(ushort device)
 {
-    ushort device, cnt;
-    
-    TRACE(("gdth_search_pci()\n"));
-
-    cnt = 0;
-    for (device = 0; device <= PCI_DEVICE_ID_VORTEX_GDT6555; ++device)
-        gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_VORTEX, device);
-    for (device = PCI_DEVICE_ID_VORTEX_GDT6x17RP; 
-         device <= PCI_DEVICE_ID_VORTEX_GDTMAXRP; ++device)
-        gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_VORTEX, device);
-    gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_VORTEX, 
-                    PCI_DEVICE_ID_VORTEX_GDTNEWRX);
-    gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_VORTEX, 
-                    PCI_DEVICE_ID_VORTEX_GDTNEWRX2);
-    gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_INTEL,
-                    PCI_DEVICE_ID_INTEL_SRC);
-    gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_INTEL,
-                    PCI_DEVICE_ID_INTEL_SRC_XSCALE);
-    return cnt;
+	if (device <= PCI_DEVICE_ID_VORTEX_GDT6555)
+		return true;
+	if (device >= PCI_DEVICE_ID_VORTEX_GDT6x17RP &&
+	    device <= PCI_DEVICE_ID_VORTEX_GDTMAXRP)
+		return true;
+	if (device == PCI_DEVICE_ID_VORTEX_GDTNEWRX ||
+	    device == PCI_DEVICE_ID_VORTEX_GDTNEWRX2)
+		return true;
+	return false;
 }
 
+static int gdth_pci_probe_one(gdth_pci_str *pcistr, gdth_ha_str **ha_out);
+static int gdth_pci_init_one(struct pci_dev *pdev,
+			     const struct pci_device_id *ent);
+static void gdth_pci_remove_one(struct pci_dev *pdev);
+static void gdth_remove_one(gdth_ha_str *ha);
+
 /* Vortex only makes RAID controllers.
  * We do not really want to specify all 550 ids here, so wildcard match.
  */
-static struct pci_device_id gdthtable[] __maybe_unused = {
-    {PCI_VENDOR_ID_VORTEX,PCI_ANY_ID,PCI_ANY_ID, PCI_ANY_ID},
-    {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC,PCI_ANY_ID,PCI_ANY_ID}, 
-    {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC_XSCALE,PCI_ANY_ID,PCI_ANY_ID}, 
-    {0}
+static const struct pci_device_id gdthtable[] = {
+	{ PCI_VDEVICE(VORTEX, PCI_ANY_ID) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC_XSCALE) },
+	{ }	/* terminate list */
 };
-MODULE_DEVICE_TABLE(pci,gdthtable);
+MODULE_DEVICE_TABLE(pci, gdthtable);
 
-static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
-                                   ushort vendor, ushort device)
+static struct pci_driver gdth_pci_driver = {
+	.name		= "gdth",
+	.id_table	= gdthtable,
+	.probe		= gdth_pci_init_one,
+	.remove		= gdth_pci_remove_one,
+};
+
+static void gdth_pci_remove_one(struct pci_dev *pdev)
 {
-    ulong base0, base1, base2;
-    struct pci_dev *pdev;
+	gdth_ha_str *ha = pci_get_drvdata(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+
+	list_del(&ha->list);
+	gdth_remove_one(ha);
+
+	pci_disable_device(pdev);
+}
+
+static int gdth_pci_init_one(struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
+{
+	ushort vendor = pdev->vendor;
+	ushort device = pdev->device;
+	ulong base0, base1, base2;
+	int rc;
+	gdth_pci_str gdth_pcistr;
+	gdth_ha_str *ha = NULL;
     
-    TRACE(("gdth_search_dev() cnt %d vendor %x device %x\n",
-          *cnt, vendor, device));
+	TRACE(("gdth_search_dev() cnt %d vendor %x device %x\n",
+	       gdth_ctr_count, vendor, device));
 
-    pdev = NULL;
-    while ((pdev = pci_get_device(vendor, device, pdev))
-           != NULL) {
-        if (pci_enable_device(pdev))
-            continue;
-        if (*cnt >= MAXHA) {
-            pci_dev_put(pdev);
-            return;
-        }
+	memset(&gdth_pcistr, 0, sizeof(gdth_pcistr));
+
+	if (vendor == PCI_VENDOR_ID_VORTEX && !gdth_search_vortex(device))
+		return -ENODEV;
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	if (gdth_ctr_count >= MAXHA)
+		return -EBUSY;
 
         /* GDT PCI controller found, resources are already in pdev */
-        pcistr[*cnt].pdev = pdev;
+	gdth_pcistr.pdev = pdev;
         base0 = pci_resource_flags(pdev, 0);
         base1 = pci_resource_flags(pdev, 1);
         base2 = pci_resource_flags(pdev, 2);
         if (device <= PCI_DEVICE_ID_VORTEX_GDT6000B ||   /* GDT6000/B */
             device >= PCI_DEVICE_ID_VORTEX_GDT6x17RP) {  /* MPR */
             if (!(base0 & IORESOURCE_MEM)) 
-                continue;
-            pcistr[*cnt].dpmem = pci_resource_start(pdev, 0);
+		return -ENODEV;
+	    gdth_pcistr.dpmem = pci_resource_start(pdev, 0);
         } else {                                  /* GDT6110, GDT6120, .. */
             if (!(base0 & IORESOURCE_MEM) ||
                 !(base2 & IORESOURCE_MEM) ||
                 !(base1 & IORESOURCE_IO)) 
-                continue;
-            pcistr[*cnt].dpmem = pci_resource_start(pdev, 2);
-            pcistr[*cnt].io    = pci_resource_start(pdev, 1);
+		return -ENODEV;
+	    gdth_pcistr.dpmem = pci_resource_start(pdev, 2);
+	    gdth_pcistr.io    = pci_resource_start(pdev, 1);
         }
         TRACE2(("Controller found at %d/%d, irq %d, dpmem 0x%lx\n",
-                pcistr[*cnt].pdev->bus->number,
-		PCI_SLOT(pcistr[*cnt].pdev->devfn),
-                pcistr[*cnt].irq, pcistr[*cnt].dpmem));
-        (*cnt)++;
-    }       
-}   
+		gdth_pcistr.pdev->bus->number,
+		PCI_SLOT(gdth_pcistr.pdev->devfn),
+		gdth_pcistr.irq,
+		gdth_pcistr.dpmem));
 
-static void __init gdth_sort_pci(gdth_pci_str *pcistr, int cnt)
-{    
-    gdth_pci_str temp;
-    int i, changed;
-    
-    TRACE(("gdth_sort_pci() cnt %d\n",cnt));
-    if (cnt == 0)
-        return;
+	rc = gdth_pci_probe_one(&gdth_pcistr, &ha);
+	if (rc)
+		return rc;
 
-    do {
-        changed = FALSE;
-        for (i = 0; i < cnt-1; ++i) {
-            if (!reverse_scan) {
-                if ((pcistr[i].pdev->bus->number > pcistr[i+1].pdev->bus->number) ||
-                    (pcistr[i].pdev->bus->number == pcistr[i+1].pdev->bus->number &&
-                     PCI_SLOT(pcistr[i].pdev->devfn) >
-                     PCI_SLOT(pcistr[i+1].pdev->devfn))) {
-                    temp = pcistr[i];
-                    pcistr[i] = pcistr[i+1];
-                    pcistr[i+1] = temp;
-                    changed = TRUE;
-                }
-            } else {
-                if ((pcistr[i].pdev->bus->number < pcistr[i+1].pdev->bus->number) ||
-                    (pcistr[i].pdev->bus->number == pcistr[i+1].pdev->bus->number &&
-                     PCI_SLOT(pcistr[i].pdev->devfn) <
-                     PCI_SLOT(pcistr[i+1].pdev->devfn))) {
-                    temp = pcistr[i];
-                    pcistr[i] = pcistr[i+1];
-                    pcistr[i+1] = temp;
-                    changed = TRUE;
-                }
-            }
-        }
-    } while (changed);
+	return 0;
 }
 #endif /* CONFIG_PCI */
 
@@ -911,8 +899,8 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static int __init gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
-				gdth_ha_str *ha)
+static int gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
+				   gdth_ha_str *ha)
 {
     register gdt6_dpram_str __iomem *dp6_ptr;
     register gdt6c_dpram_str __iomem *dp6c_ptr;
@@ -4994,7 +4982,8 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int __init gdth_pci_probe_one(gdth_pci_str *pcistr)
+static int gdth_pci_probe_one(gdth_pci_str *pcistr,
+			     gdth_ha_str **ha_out)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -5002,6 +4991,8 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr)
 	int error, i;
 	struct pci_dev *pdev = pcistr->pdev;
 
+	*ha_out = NULL;
+
 	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
@@ -5107,8 +5098,12 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
 
+	pci_set_drvdata(ha->pdev, ha);
+
 	scsi_scan_host(shp);
 
+	*ha_out = ha;
+
 	return 0;
 
  out_free_coal_stat:
@@ -5207,16 +5202,8 @@ static int __init gdth_init(void)
 
 #ifdef CONFIG_PCI
 	/* scanning for PCI controllers */
-	{
-		gdth_pci_str pcistr[MAXHA];
-		int cnt,ctr;
-
-		cnt = gdth_search_pci(pcistr);
-		printk("GDT-HA: Found %d PCI Storage RAID Controllers\n", cnt);
-		gdth_sort_pci(pcistr,cnt);
-		for (ctr = 0; ctr < cnt; ++ctr)
-			gdth_pci_probe_one(&pcistr[ctr]);
-	}
+	if (pci_register_driver(&gdth_pci_driver) == 0)
+		gdth_pci_registered = true;
 #endif /* CONFIG_PCI */
 
 	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
@@ -5243,6 +5230,11 @@ static void __exit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
+#ifdef CONFIG_PCI
+	if (gdth_pci_registered)
+		pci_unregister_driver(&gdth_pci_driver);
+#endif
+
 	list_for_each_entry(ha, &gdth_instances, list)
 		gdth_remove_one(ha);
 
-- 
1.5.3.8

