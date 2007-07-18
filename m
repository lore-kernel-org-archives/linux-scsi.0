From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] Re: + gdth-remove-redundant-pci-stuff.patch added to -mm
 tree
Date: Wed, 18 Jul 2007 19:51:01 -0400
Message-ID: <469EA765.3020707@garzik.org>
References: <200707182249.l6IMnF6M000557@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080209010106070104090105"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33799 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759992AbXGRXvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 19:51:06 -0400
In-Reply-To: <200707182249.l6IMnF6M000557@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, hch@lst.de, achim_leubner@adaptec.com

This is a multi-part message in MIME format.
--------------080209010106070104090105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

akpm@linux-foundation.org wrote:
> The patch titled
>      gdth: remove redundant PCI stuff
> has been added to the -mm tree.  Its filename is
>      gdth-remove-redundant-pci-stuff.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: gdth: remove redundant PCI stuff
> From: Jeff Garzik <jeff@garzik.org>
> 
> This patch
> 
> * removes struct members that duplicate pci_dev members
> * replaces ha->stype usage with ha->pdev->device usage where feasible
> * removes PCI IDs that are already in include/linux/pci_ids.h
> 
> I thought it would be a good preparation for PCI hotplug API.  (or at the very
> least, proper pci_dev refcounting)
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Attached is the version updated with Christoph's "don't lose info 
contained in PCI_DEVICE_ID constants" request.

	Jeff



--------------080209010106070104090105
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

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
index 8c29eaf..3742330 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -845,11 +845,6 @@ typedef struct {
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
@@ -862,7 +857,6 @@ typedef struct {
     ushort              oem_id;                 /* OEM */
     ushort              type;                   /* controller class */
     ulong32             stype;                  /* subtype (PCI: device ID) */
-    ushort              subdevice_id;           /* sub device ID (PCI) */
     ushort              fw_vers;                /* firmware version */
     ushort              cache_feat;             /* feat. cache serv. (s/g,..)*/
     ushort              raw_feat;               /* feat. raw service (s/g,..)*/

--------------080209010106070104090105--
