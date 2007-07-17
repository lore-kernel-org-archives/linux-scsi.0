From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] gdth: remove redundant PCI stuff
Date: Tue, 17 Jul 2007 05:25:17 -0400
Message-ID: <20070717092517.GA28201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758921AbXGQJZb@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch

* removes struct members that duplicate pci_dev members
* replaces ha->stype usage with ha->pdev->device usage where feasible
* removes PCI IDs that are already in include/linux/pci_ids.h

I did this because I was bored.  If this interferes with Christoph's
stuff in any way, feel free to ignore.  I thought it would be a good
preparation for PCI hotplug API.  (or at the very least, proper pci_dev
refcounting)

Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/gdth.c |   48 ++++++++++++++++++++++--------------------------
 drivers/scsi/gdth.h |   45 +--------------------------------------------
 2 files changed, 23 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d0b95ce..b0f5687 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -902,11 +902,6 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
             return;
         /* GDT PCI controller found, resources are already in pdev */
         pcistr[*cnt].pdev = pdev;
-        pcistr[*cnt].vendor_id = vendor;
-        pcistr[*cnt].device_id = device;
-        pcistr[*cnt].subdevice_id = pdev->subsystem_device;
-        pcistr[*cnt].bus = pdev->bus->number;
-        pcistr[*cnt].device_fn = pdev->devfn;
         pcistr[*cnt].irq = pdev->irq;
         base0 = pci_resource_flags(pdev, 0);
         base1 = pci_resource_flags(pdev, 1);
@@ -926,7 +921,8 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
             pcistr[*cnt].io    = pci_resource_start(pdev, 1);
         }
         TRACE2(("Controller found at %d/%d, irq %d, dpmem 0x%lx\n",
-                pcistr[*cnt].bus, PCI_SLOT(pcistr[*cnt].device_fn), 
+                pcistr[*cnt].pdev->bus->number,
+		PCI_SLOT(pcistr[*cnt].pdev->devfn), 
                 pcistr[*cnt].irq, pcistr[*cnt].dpmem));
         (*cnt)++;
     }       
@@ -946,20 +942,20 @@ static void __init gdth_sort_pci(gdth_pci_str *pcistr, int cnt)
         changed = FALSE;
         for (i = 0; i < cnt-1; ++i) {
             if (!reverse_scan) {
-                if ((pcistr[i].bus > pcistr[i+1].bus) ||
-                    (pcistr[i].bus == pcistr[i+1].bus &&
-                     PCI_SLOT(pcistr[i].device_fn) > 
-                     PCI_SLOT(pcistr[i+1].device_fn))) {
+                if ((pcistr[i].pdev->bus->number > pcistr[i+1].pdev->bus->number) ||
+                    (pcistr[i].pdev->bus->number == pcistr[i+1].pdev->bus->number &&
+                     PCI_SLOT(pcistr[i].pdev->devfn) > 
+                     PCI_SLOT(pcistr[i+1].pdev->devfn))) {
                     temp = pcistr[i];
                     pcistr[i] = pcistr[i+1];
                     pcistr[i+1] = temp;
                     changed = TRUE;
                 }
             } else {
-                if ((pcistr[i].bus < pcistr[i+1].bus) ||
-                    (pcistr[i].bus == pcistr[i+1].bus &&
-                     PCI_SLOT(pcistr[i].device_fn) < 
-                     PCI_SLOT(pcistr[i+1].device_fn))) {
+                if ((pcistr[i].pdev->bus->number < pcistr[i+1].pdev->bus->number) ||
+                    (pcistr[i].pdev->bus->number == pcistr[i+1].pdev->bus->number &&
+                     PCI_SLOT(pcistr[i].pdev->devfn) < 
+                     PCI_SLOT(pcistr[i+1].pdev->devfn))) {
                     temp = pcistr[i];
                     pcistr[i] = pcistr[i+1];
                     pcistr[i+1] = temp;
@@ -1176,17 +1172,16 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
 
     TRACE(("gdth_init_pci()\n"));
 
-    if (pcistr->vendor_id == PCI_VENDOR_ID_INTEL)
+    if (pcistr->pdev->vendor == PCI_VENDOR_ID_INTEL)
         ha->oem_id = OEM_ID_INTEL;
     else
         ha->oem_id = OEM_ID_ICP;
-    ha->brd_phys = (pcistr->bus << 8) | (pcistr->device_fn & 0xf8);
-    ha->stype = (ulong32)pcistr->device_id;
-    ha->subdevice_id = pcistr->subdevice_id;
+    ha->brd_phys = (pcistr->pdev->bus->number << 8) | (pcistr->pdev->devfn & 0xf8);
+    ha->stype = (ulong32)pcistr->pdev->device;
     ha->irq = pcistr->irq;
     ha->pdev = pcistr->pdev;
     
-    if (ha->stype <= PCI_DEVICE_ID_VORTEX_GDT6000B) {  /* GDT6000/B */
+    if (ha->pdev->device <= PCI_DEVICE_ID_VORTEX_GDT6000B) {  /* GDT6000/B */
         TRACE2(("init_pci() dpmem %lx irq %d\n",pcistr->dpmem,ha->irq));
         ha->brd = ioremap(pcistr->dpmem, sizeof(gdt6_dpram_str));
         if (ha->brd == NULL) {
@@ -1293,7 +1288,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
 
         ha->dma64_support = 0;
 
-    } else if (ha->stype <= PCI_DEVICE_ID_VORTEX_GDT6555) { /* GDT6110, ... */
+    } else if (ha->pdev->device <= PCI_DEVICE_ID_VORTEX_GDT6555) { /* GDT6110, ... */
         ha->plx = (gdt6c_plx_regs *)pcistr->io;
         TRACE2(("init_pci_new() dpmem %lx irq %d\n",
             pcistr->dpmem,ha->irq));
@@ -4601,7 +4596,8 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
         }
         /* controller found and initialized */
         printk("Configuring GDT-PCI HA at %d/%d IRQ %u\n",
-               pcistr[ctr].bus,PCI_SLOT(pcistr[ctr].device_fn),ha->irq);
+               pcistr[ctr].pdev->bus->number,
+	       PCI_SLOT(pcistr[ctr].pdev->devfn), ha->irq);
 
         if (request_irq(ha->irq, gdth_interrupt,
                         IRQF_DISABLED|IRQF_SHARED, "gdth", ha))
@@ -4637,7 +4633,7 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
 #endif
         ha->scratch_busy = FALSE;
         ha->req_first = NULL;
-        ha->tid_cnt = pcistr[ctr].device_id >= 0x200 ? MAXID : MAX_HDRIVES;
+        ha->tid_cnt = pcistr[ctr].pdev->device >= 0x200 ? MAXID : MAX_HDRIVES;
         if (max_ids > 0 && max_ids < ha->tid_cnt)
             ha->tid_cnt = max_ids;
         for (i=0; i<GDTH_MAXCMDS; ++i)
@@ -4810,7 +4806,7 @@ static const char *gdth_ctr_name(int hanum)
     } else if (ha->type == GDT_ISA) {
         return("GDT2000/2020");
     } else if (ha->type == GDT_PCI) {
-        switch (ha->stype) {
+        switch (ha->pdev->device) {
           case PCI_DEVICE_ID_VORTEX_GDT60x0:
             return("GDT6000/6020/6050");
           case PCI_DEVICE_ID_VORTEX_GDT6000B:
@@ -5448,12 +5444,12 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
                 ctrt.type = 
                     (ha->oem_id == OEM_ID_INTEL ? 0xfd : 0xfe);
                 if (ha->stype >= 0x300)
-                    ctrt.ext_type = 0x6000 | ha->subdevice_id;
+                    ctrt.ext_type = 0x6000 | ha->pdev->subsystem_device;
                 else 
                     ctrt.ext_type = 0x6000 | ha->stype;
             }
-            ctrt.device_id = ha->stype;
-            ctrt.sub_device_id = ha->subdevice_id;
+            ctrt.device_id = ha->pdev->device;
+            ctrt.sub_device_id = ha->pdev->subsystem_device;
         }
         ctrt.info = ha->brd_phys;
         ctrt.oem_id = ha->oem_id;
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 8c29eaf..068017c 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -51,45 +51,8 @@
 #define GDT2_ID         0x0120941c              /* GDT2000/2020 */
 
 /* vendor ID, device IDs (PCI) */
-/* these defines should already exist in <linux/pci.h> */
-#ifndef PCI_VENDOR_ID_VORTEX
-#define PCI_VENDOR_ID_VORTEX            0x1119  /* PCI controller vendor ID */
-#endif
-#ifndef PCI_VENDOR_ID_INTEL
-#define PCI_VENDOR_ID_INTEL             0x8086  
-#endif
+/* these defines should be moved to <linux/pci.h> */
 
-#ifndef PCI_DEVICE_ID_VORTEX_GDT60x0
-/* GDT_PCI */
-#define PCI_DEVICE_ID_VORTEX_GDT60x0    0       /* GDT6000/6020/6050 */
-#define PCI_DEVICE_ID_VORTEX_GDT6000B   1       /* GDT6000B/6010 */
-/* GDT_PCINEW */
-#define PCI_DEVICE_ID_VORTEX_GDT6x10    2       /* GDT6110/6510 */
-#define PCI_DEVICE_ID_VORTEX_GDT6x20    3       /* GDT6120/6520 */
-#define PCI_DEVICE_ID_VORTEX_GDT6530    4       /* GDT6530 */
-#define PCI_DEVICE_ID_VORTEX_GDT6550    5       /* GDT6550 */
-/* GDT_PCINEW, wide/ultra SCSI controllers */
-#define PCI_DEVICE_ID_VORTEX_GDT6x17    6       /* GDT6117/6517 */
-#define PCI_DEVICE_ID_VORTEX_GDT6x27    7       /* GDT6127/6527 */
-#define PCI_DEVICE_ID_VORTEX_GDT6537    8       /* GDT6537 */
-#define PCI_DEVICE_ID_VORTEX_GDT6557    9       /* GDT6557/6557-ECC */
-/* GDT_PCINEW, wide SCSI controllers */
-#define PCI_DEVICE_ID_VORTEX_GDT6x15    10      /* GDT6115/6515 */
-#define PCI_DEVICE_ID_VORTEX_GDT6x25    11      /* GDT6125/6525 */
-#define PCI_DEVICE_ID_VORTEX_GDT6535    12      /* GDT6535 */
-#define PCI_DEVICE_ID_VORTEX_GDT6555    13      /* GDT6555/6555-ECC */
-#endif
-
-#ifndef PCI_DEVICE_ID_VORTEX_GDT6x17RP
-/* GDT_MPR, RP series, wide/ultra SCSI */
-#define PCI_DEVICE_ID_VORTEX_GDT6x17RP  0x100   /* GDT6117RP/GDT6517RP */
-#define PCI_DEVICE_ID_VORTEX_GDT6x27RP  0x101   /* GDT6127RP/GDT6527RP */
-#define PCI_DEVICE_ID_VORTEX_GDT6537RP  0x102   /* GDT6537RP */
-#define PCI_DEVICE_ID_VORTEX_GDT6557RP  0x103   /* GDT6557RP */
-/* GDT_MPR, RP series, narrow/ultra SCSI */
-#define PCI_DEVICE_ID_VORTEX_GDT6x11RP  0x104   /* GDT6111RP/GDT6511RP */
-#define PCI_DEVICE_ID_VORTEX_GDT6x21RP  0x105   /* GDT6121RP/GDT6521RP */
-#endif
 #ifndef PCI_DEVICE_ID_VORTEX_GDT6x17RD
 /* GDT_MPR, RD series, wide/ultra SCSI */
 #define PCI_DEVICE_ID_VORTEX_GDT6x17RD  0x110   /* GDT6117RD/GDT6517RD */
@@ -845,11 +808,6 @@ typedef struct {
 /* PCI resources */
 typedef struct {
     struct pci_dev      *pdev;
-    ushort              vendor_id;              /* vendor (ICP, Intel, ..) */
-    ushort              device_id;              /* device ID (0,..,9) */
-    ushort              subdevice_id;           /* sub device ID */
-    unchar              bus;                    /* PCI bus */
-    unchar              device_fn;              /* PCI device/function no. */
     ulong               dpmem;                  /* DPRAM address */
     ulong               io;                     /* IO address */
     ulong               io_mm;                  /* IO address mem. mapped */
@@ -862,7 +820,6 @@ typedef struct {
     ushort              oem_id;                 /* OEM */
     ushort              type;                   /* controller class */
     ulong32             stype;                  /* subtype (PCI: device ID) */
-    ushort              subdevice_id;           /* sub device ID (PCI) */
     ushort              fw_vers;                /* firmware version */
     ushort              cache_feat;             /* feat. cache serv. (s/g,..)*/
     ushort              raw_feat;               /* feat. raw service (s/g,..)*/
