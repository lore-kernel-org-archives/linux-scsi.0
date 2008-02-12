From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] gdth: convert to PCI hotplug API
Date: Tue, 12 Feb 2008 18:49:28 -0500
Message-ID: <20080212234928.GA13892@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762023AbYBLXtj@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/gdth.c |  143 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 86 insertions(+), 57 deletions(-)

06196f50915da97bb897495863f9f084d785c1e4
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c825239..1b53e92 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -595,85 +595,107 @@ static int __init gdth_search_isa(ulong32 bios_adr)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
-                            ushort vendor, ushort dev);
+static gdth_pci_str gdth_pcistr[MAXHA];
+static int gdth_pci_cnt;
+static bool gdth_pci_registered;
 
-static int __init gdth_search_pci(gdth_pci_str *pcistr)
+static bool __init gdth_search_vortex(ushort device)
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
+static struct pci_device_id gdthtable[] __devinitdata = {
+	{ PCI_VDEVICE(VORTEX, PCI_ANY_ID) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC_XSCALE) },
+	{ }	/* terminate list */
+};
+MODULE_DEVICE_TABLE(pci, gdthtable);
+
+static struct pci_driver gdth_pci_driver = {
+	.name		= "gdth",
+	.id_table	= gdthtable,
+	.probe		= gdth_pci_init_one,
+	.remove		= gdth_pci_remove_one,
 };
-MODULE_DEVICE_TABLE(pci,gdthtable);
 
-static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
-                                   ushort vendor, ushort device)
+static void gdth_pci_remove_one(struct pci_dev *pdev)
+{
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
+static int __devinit gdth_pci_init_one(struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
 {
-    ulong base0, base1, base2;
-    struct pci_dev *pdev;
+	ushort vendor = pdev->vendor;
+	ushort device = pdev->device;
+	ulong base0, base1, base2;
+	int rc;
     
-    TRACE(("gdth_search_dev() cnt %d vendor %x device %x\n",
-          *cnt, vendor, device));
+	TRACE(("gdth_search_dev() cnt %d vendor %x device %x\n",
+	       gdth_pci_cnt, vendor, device));
+
+	if (vendor == PCI_VENDOR_ID_VORTEX && !gdth_search_vortex(device))
+		return -ENODEV;
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	if (gdth_pci_cnt >= MAXHA)
+		return -EBUSY;
 
-    pdev = NULL;
-    while ((pdev = pci_find_device(vendor, device, pdev)) 
-           != NULL) {
-        if (pci_enable_device(pdev))
-            continue;
-        if (*cnt >= MAXHA)
-            return;
         /* GDT PCI controller found, resources are already in pdev */
-        pcistr[*cnt].pdev = pdev;
-        pcistr[*cnt].irq = pdev->irq;
+	gdth_pcistr[gdth_pci_cnt].pdev = pdev;
+	gdth_pcistr[gdth_pci_cnt].irq = pdev->irq;
         base0 = pci_resource_flags(pdev, 0);
         base1 = pci_resource_flags(pdev, 1);
         base2 = pci_resource_flags(pdev, 2);
         if (device <= PCI_DEVICE_ID_VORTEX_GDT6000B ||   /* GDT6000/B */
             device >= PCI_DEVICE_ID_VORTEX_GDT6x17RP) {  /* MPR */
             if (!(base0 & IORESOURCE_MEM)) 
-                continue;
-            pcistr[*cnt].dpmem = pci_resource_start(pdev, 0);
+		return -ENODEV;
+	    gdth_pcistr[gdth_pci_cnt].dpmem = pci_resource_start(pdev, 0);
         } else {                                  /* GDT6110, GDT6120, .. */
             if (!(base0 & IORESOURCE_MEM) ||
                 !(base2 & IORESOURCE_MEM) ||
                 !(base1 & IORESOURCE_IO)) 
-                continue;
-            pcistr[*cnt].dpmem = pci_resource_start(pdev, 2);
-            pcistr[*cnt].io_mm = pci_resource_start(pdev, 0);
-            pcistr[*cnt].io    = pci_resource_start(pdev, 1);
+		return -ENODEV;
+	    gdth_pcistr[gdth_pci_cnt].dpmem = pci_resource_start(pdev, 2);
+	    gdth_pcistr[gdth_pci_cnt].io_mm = pci_resource_start(pdev, 0);
+	    gdth_pcistr[gdth_pci_cnt].io    = pci_resource_start(pdev, 1);
         }
         TRACE2(("Controller found at %d/%d, irq %d, dpmem 0x%lx\n",
-                pcistr[*cnt].pdev->bus->number,
-		PCI_SLOT(pcistr[*cnt].pdev->devfn),
-                pcistr[*cnt].irq, pcistr[*cnt].dpmem));
-        (*cnt)++;
-    }       
+		gdth_pcistr[gdth_pci_cnt].pdev->bus->number,
+		PCI_SLOT(gdth_pcistr[gdth_pci_cnt].pdev->devfn),
+		gdth_pcistr[gdth_pci_cnt].irq,
+		gdth_pcistr[gdth_pci_cnt].dpmem));
+	gdth_pci_cnt++;
+
+	return 0;
 }   
 
 static void __init gdth_sort_pci(gdth_pci_str *pcistr, int cnt)
@@ -5100,6 +5122,7 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+	pci_set_drvdata(ha->pdev, ha);
 	return 0;
 
  out_free_coal_stat:
@@ -5198,15 +5221,16 @@ static int __init gdth_init(void)
 
 #ifdef CONFIG_PCI
 	/* scanning for PCI controllers */
-	{
-		gdth_pci_str pcistr[MAXHA];
+	if (pci_register_driver(&gdth_pci_driver) == 0) {
 		int cnt,ctr;
+		gdth_pci_str *pcistr = gdth_pcistr;
 
-		cnt = gdth_search_pci(pcistr);
+		cnt = gdth_pci_cnt;
 		printk("GDT-HA: Found %d PCI Storage RAID Controllers\n", cnt);
 		gdth_sort_pci(pcistr,cnt);
 		for (ctr = 0; ctr < cnt; ++ctr)
 			gdth_pci_probe_one(pcistr, ctr);
+		gdth_pci_registered = true;
 	}
 #endif /* CONFIG_PCI */
 
@@ -5234,6 +5258,11 @@ static void __exit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
+#ifdef CONFIG_PCI
+	if (gdth_pci_registered)
+		pci_unregister_driver(&gdth_pci_driver);
+#endif
+
 	list_for_each_entry(ha, &gdth_instances, list)
 		gdth_remove_one(ha);
 
