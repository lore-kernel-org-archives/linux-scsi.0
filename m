From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] gdth: cleanup compat clutter
Date: Mon, 3 Jan 2005 16:50:57 +0100
Message-ID: <20050103155057.GA24467@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:65432 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261483AbVACPvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2005 10:51:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, achim_leubner@adaptec.com
Cc: linux-scsi@vger.kernel.org

This patch

 - removes support for 2.2.x and 2.4.x without the full dma API
   (<= 2.4.13 or 2.4.9rh)
 - makes sure we don't acquire or release unessecary locks around
   ->scsi_done - it's a small BH/softirq that doesn't care about
   the callers lock state
 - cleans up the 2.4 vs 2.6 compat code a little


--- 1.44/drivers/scsi/gdth.c	2004-10-01 04:44:10 +02:00
+++ edited/drivers/scsi/gdth.c	2005-01-03 16:46:48 +01:00
@@ -397,11 +397,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #include <linux/spinlock.h>
-#else
-#include <asm/spinlock.h>
-#endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <linux/blkdev.h>
 #else
@@ -412,14 +408,11 @@
 #include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "gdth.h"
+#include "gdth_kcompat.h"
 
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static irqreturn_t gdth_interrupt(int irq, void *dev_id, struct pt_regs *regs);
-#else
-static void gdth_interrupt(int irq, void *dev_id, struct pt_regs *regs);
-#endif
 static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp);
 static int gdth_async_event(int hanum);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
@@ -617,32 +610,6 @@
     DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN,DUN
 };
 
-/* __initfunc, __initdata macros */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-#define GDTH_INITFUNC(type, func)       type __init func 
-#include <linux/init.h>
-#else
-#define GDTH_INITFUNC(type, func)       __initfunc(type func)
-#include <linux/init.h>
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-#define GDTH_INIT_LOCK_HA(ha)           spin_lock_init(&(ha)->smp_lock)
-#define GDTH_LOCK_HA(ha,flags)          spin_lock_irqsave(&(ha)->smp_lock,flags)
-#define GDTH_UNLOCK_HA(ha,flags)        spin_unlock_irqrestore(&(ha)->smp_lock,flags)
-
-#define GDTH_LOCK_SCSI_DONE(dev, flags) spin_lock_irqsave(dev->host_lock,flags)
-#define GDTH_UNLOCK_SCSI_DONE(dev, flags) spin_unlock_irqrestore(dev->host_lock,flags)
-
-#else
-#define GDTH_INIT_LOCK_HA(ha)           spin_lock_init(&(ha)->smp_lock)
-#define GDTH_LOCK_HA(ha,flags)          spin_lock_irqsave(&(ha)->smp_lock,flags)
-#define GDTH_UNLOCK_HA(ha,flags)        spin_unlock_irqrestore(&(ha)->smp_lock,flags)
-
-#define GDTH_LOCK_SCSI_DONE(flags)      spin_lock_irqsave(&io_request_lock,flags)
-#define GDTH_UNLOCK_SCSI_DONE(flags)    spin_unlock_irqrestore(&io_request_lock,flags)
-#endif
-
 /* LILO and modprobe/insmod parameters */
 /* IRQ list for GDT3000/3020 EISA controllers */
 static int irq[MAXHA] __initdata = 
@@ -674,7 +641,6 @@
 /* 64 bit DMA mode, support for drives > 2 TB, if force_dma32 = 0 */
 static int force_dma32 = 0;
 
-#ifdef MODULE
 /* parameters for modprobe/insmod */
 MODULE_PARM(irq, "i");
 MODULE_PARM(disable, "i");
@@ -689,33 +655,15 @@
 MODULE_PARM(probe_eisa_isa, "i");
 MODULE_PARM(force_dma32, "i");
 MODULE_AUTHOR("Achim Leubner");
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,11)
 MODULE_LICENSE("GPL");
-#endif
-#endif
 
 /* ioctl interface */
 static struct file_operations gdth_fops = {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     .ioctl   = gdth_ioctl,
     .open    = gdth_open,
     .release = gdth_close,
-#else
-    ioctl:gdth_ioctl,
-    open:gdth_open,
-    release:gdth_close,
-#endif
 };
 
-/* /proc support */
-#include <linux/stat.h> 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-struct proc_dir_entry proc_scsi_gdth = {
-    PROC_SCSI_GDTH, 4, "gdth",
-    S_IFDIR | S_IRUGO | S_IXUGO, 2
-};
-#endif
-
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
@@ -755,7 +703,7 @@
 
 /* controller search and initialization functions */
 
-GDTH_INITFUNC(static int, gdth_search_eisa(ushort eisa_adr))
+static int __init gdth_search_eisa(ushort eisa_adr)
 {
     ulong32 id;
     
@@ -773,7 +721,7 @@
 }
 
 
-GDTH_INITFUNC(static int, gdth_search_isa(ulong32 bios_adr))
+static int __init gdth_search_isa(ulong32 bios_adr)
 {
     void __iomem *addr;
     ulong32 id;
@@ -789,7 +737,7 @@
 }
 
 
-GDTH_INITFUNC(static int, gdth_search_pci(gdth_pci_str *pcistr))
+static int __init gdth_search_pci(gdth_pci_str *pcistr)
 {
     ushort device, cnt;
     
@@ -812,21 +760,19 @@
     return cnt;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 /* Vortex only makes RAID controllers.
  * We do not really want to specify all 550 ids here, so wildcard match.
  */
-static struct pci_device_id gdthtable[] __devinitdata = {
+static struct pci_device_id gdthtable[] __attribute_used__ = {
     {PCI_VENDOR_ID_VORTEX,PCI_ANY_ID,PCI_ANY_ID, PCI_ANY_ID},
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC,PCI_ANY_ID,PCI_ANY_ID}, 
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC_XSCALE,PCI_ANY_ID,PCI_ANY_ID}, 
     {0}
 };
 MODULE_DEVICE_TABLE(pci,gdthtable);
-#endif
 
-GDTH_INITFUNC(static void, gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
-                                           ushort vendor, ushort device))
+static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
+                                           ushort vendor, ushort device)
 {
     ulong base0, base1, base2;
     struct pci_dev *pdev;
@@ -834,7 +780,6 @@
     TRACE(("gdth_search_dev() cnt %d vendor %x device %x\n",
           *cnt, vendor, device));
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     pdev = NULL;
     while ((pdev = pci_find_device(vendor, device, pdev)) 
            != NULL) {
@@ -872,52 +817,10 @@
                 pcistr[*cnt].irq, pcistr[*cnt].dpmem));
         (*cnt)++;
     }       
-#else
-    pdev = NULL;
-    while ((pdev = pci_find_device(vendor, device, pdev)) 
-           != NULL) {
-        if (*cnt >= MAXHA)
-            return;
-        /* GDT PCI controller found, resources are already in pdev */
-        pcistr[*cnt].pdev = pdev;
-        pcistr[*cnt].vendor_id = vendor;
-        pcistr[*cnt].device_id = device;
-        pcistr[*cnt].bus = pdev->bus->number;
-        pcistr[*cnt].device_fn = pdev->devfn;
-        pcibios_read_config_word(pcistr[*cnt].bus, pcistr[*cnt].device_fn,
-                                 PCI_SUBSYSTEM_ID, &pcistr[*cnt].subdevice_id);
-        pcistr[*cnt].irq = pdev->irq;
-        base0 = pdev->base_address[0];
-        base1 = pdev->base_address[1];
-        base2 = pdev->base_address[2];
-        if (device <= PCI_DEVICE_ID_VORTEX_GDT6000B ||   /* GDT6000/B */
-            device >= PCI_DEVICE_ID_VORTEX_GDT6x17RP) {  /* MPR */
-            if ((base0 & PCI_BASE_ADDRESS_SPACE) != 
-                PCI_BASE_ADDRESS_SPACE_MEMORY)
-                continue;
-            pcistr[*cnt].dpmem = base0 & PCI_BASE_ADDRESS_MEM_MASK;
-        } else {                                  /* GDT6110, GDT6120, .. */
-            if ((base0 & PCI_BASE_ADDRESS_SPACE) !=
-                PCI_BASE_ADDRESS_SPACE_MEMORY ||
-                (base2 & PCI_BASE_ADDRESS_SPACE) !=
-                PCI_BASE_ADDRESS_SPACE_MEMORY ||
-                (base1 & PCI_BASE_ADDRESS_SPACE) !=
-                PCI_BASE_ADDRESS_SPACE_IO)
-                continue;
-            pcistr[*cnt].dpmem = base2 & PCI_BASE_ADDRESS_MEM_MASK;
-            pcistr[*cnt].io_mm = base0 & PCI_BASE_ADDRESS_MEM_MASK;
-            pcistr[*cnt].io    = base1 & PCI_BASE_ADDRESS_IO_MASK;
-        }
-        TRACE2(("Controller found at %d/%d, irq %d, dpmem 0x%lx\n",
-                pcistr[*cnt].bus, PCI_SLOT(pcistr[*cnt].device_fn), 
-                pcistr[*cnt].irq, pcistr[*cnt].dpmem));
-        (*cnt)++;
-    }       
-#endif
 }   
 
 
-GDTH_INITFUNC(static void, gdth_sort_pci(gdth_pci_str *pcistr, int cnt))
+static void __init gdth_sort_pci(gdth_pci_str *pcistr, int cnt)
 {    
     gdth_pci_str temp;
     int i, changed;
@@ -955,7 +858,7 @@
 }
 
 
-GDTH_INITFUNC(static int, gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha))
+static int __init gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha)
 {
     ulong32 retries,id;
     unchar prot_ver,eisacf,i,irq_found;
@@ -1048,7 +951,7 @@
 }
 
        
-GDTH_INITFUNC(static int, gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha))
+static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
 {
     register gdt2_dpram_str __iomem *dp2_ptr;
     int i;
@@ -1148,7 +1051,7 @@
 }
 
 
-GDTH_INITFUNC(static int, gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha))
+static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
 {
     register gdt6_dpram_str __iomem *dp6_ptr;
     register gdt6c_dpram_str __iomem *dp6c_ptr;
@@ -1168,9 +1071,7 @@
     ha->stype = (ulong32)pcistr->device_id;
     ha->subdevice_id = pcistr->subdevice_id;
     ha->irq = pcistr->irq;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     ha->pdev = pcistr->pdev;
-#endif
     
     if (ha->stype <= PCI_DEVICE_ID_VORTEX_GDT6000B) {  /* GDT6000/B */
         TRACE2(("init_pci() dpmem %lx irq %d\n",pcistr->dpmem,ha->irq));
@@ -1401,7 +1302,6 @@
         }
 
         /* manipulate config. space to enable DPMEM, start RP controller */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
         pci_read_config_word(pcistr->pdev, PCI_COMMAND, &command);
         command |= 6;
         pci_write_config_word(pcistr->pdev, PCI_COMMAND, command);
@@ -1412,18 +1312,6 @@
         gdth_delay(1);
         pci_write_config_dword(pcistr->pdev, PCI_ROM_ADDRESS,
                                pci_resource_start(pcistr->pdev, 8));
-#else
-        pci_read_config_word(pcistr->pdev, PCI_COMMAND, &command);
-        command |= 6;
-        pci_write_config_word(pcistr->pdev, PCI_COMMAND, command);
-        if (pcistr->pdev->rom_address == 1UL)
-            pcistr->pdev->rom_address = 0UL;
-        i = 0xFEFF0001UL;
-        pci_write_config_dword(pcistr->pdev, PCI_ROM_ADDRESS, i);
-        gdth_delay(1);
-        pci_write_config_dword(pcistr->pdev, PCI_ROM_ADDRESS,
-                               pcistr->pdev->rom_address);
-#endif
         
         dp6m_ptr = ha->brd;
 
@@ -1550,7 +1438,7 @@
 
 /* controller protocol functions */
 
-GDTH_INITFUNC(static void, gdth_enable_int(int hanum))
+static void __init gdth_enable_int(int hanum)
 {
     gdth_ha_str *ha;
     ulong flags;
@@ -1560,7 +1448,7 @@
 
     TRACE(("gdth_enable_int() hanum %d\n",hanum));
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (ha->type == GDT_EISA) {
         outb(0xff, ha->bmic + EDOORREG);
@@ -1585,7 +1473,7 @@
         gdth_writeb(gdth_readb(&dp6m_ptr->i960r.edoor_en_reg) & ~4,
                     &dp6m_ptr->i960r.edoor_en_reg);
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
 
@@ -1897,7 +1785,7 @@
 
 /* search for devices */
 
-GDTH_INITFUNC(static int, gdth_search_drives(int hanum))
+static int __init gdth_search_drives(int hanum)
 {
     register gdth_ha_str *ha;
     ushort cdev_cnt, i;
@@ -2357,16 +2245,11 @@
 
     TRACE(("gdth_putq() priority %d\n",priority));
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     scp->SCp.this_residual = (int)priority;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
     t = scp->device->id;
-#else
-    b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->channel;
-    t = scp->target;
-#endif
     if (priority >= DEFAULT_PRI) {
         if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
             (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) {
@@ -2389,7 +2272,7 @@
         pscp->SCp.ptr = (char *)scp;
         scp->SCp.ptr  = (char *)nscp;
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 
 #ifdef GDTH_STATISTICS
     flags = 0;
@@ -2415,7 +2298,7 @@
     TRACE(("gdth_next() hanum %d\n",hanum));
     ha = HADATA(gdth_ctr_tab[hanum]);
     if (!gdth_polling) 
-        GDTH_LOCK_HA(ha, flags);
+        spin_lock_irqsave(&ha->smp_lock, flags);
 
     ha->cmd_cnt = ha->cmd_offs_dpmem = 0;
     this_cmd = firsttime = TRUE;
@@ -2425,15 +2308,9 @@
     for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         b = virt_ctr ? NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
         t = nscp->device->id;
         l = nscp->device->lun;
-#else
-        b = virt_ctr ? NUMDATA(nscp->host)->busnum : nscp->channel;
-        t = nscp->target;
-        l = nscp->lun;
-#endif
         if (nscp->SCp.this_residual >= DEFAULT_PRI) {
             if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
                 (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) 
@@ -2444,7 +2321,7 @@
             if (gdth_test_busy(hanum)) {        /* controller busy ? */
                 TRACE(("gdth_next() controller %d busy !\n",hanum));
                 if (!gdth_polling) {
-                    GDTH_UNLOCK_HA(ha, flags);
+                    spin_unlock_irqrestore(&ha->smp_lock, flags);
                     return;
                 }
                 while (gdth_test_busy(hanum))
@@ -2513,14 +2390,8 @@
                 nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
-                else {
-                    if (!gdth_polling) 
-                        GDTH_UNLOCK_HA(ha,flags);
-                    /* io_request_lock already active ! */
+                else
                     nscp->scsi_done(nscp);
-                    if (!gdth_polling) 
-                        GDTH_LOCK_HA(ha,flags);
-                }
             }
         } else if (nscp->done == gdth_scsi_done && nscp->cmnd[0] == 0xff) {
             if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
@@ -2538,14 +2409,8 @@
             nscp->result = DID_BAD_TARGET << 16;
             if (!nscp->SCp.have_data_in)
                 nscp->SCp.have_data_in++;
-            else {
-                if (!gdth_polling) 
-                    GDTH_UNLOCK_HA(ha,flags);
-                /* io_request_lock already active ! */      
+            else
                 nscp->scsi_done(nscp);
-                if (!gdth_polling) 
-                    GDTH_LOCK_HA(ha,flags);
-            }
         } else {
             switch (nscp->cmnd[0]) {
               case TEST_UNIT_READY:
@@ -2555,9 +2420,7 @@
               case VERIFY:
               case START_STOP:
               case MODE_SENSE:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
               case SERVICE_ACTION_IN:
-#endif
                 TRACE(("cache cmd %x/%x/%x/%x/%x/%x\n",nscp->cmnd[0],
                        nscp->cmnd[1],nscp->cmnd[2],nscp->cmnd[3],
                        nscp->cmnd[4],nscp->cmnd[5]));
@@ -2572,22 +2435,10 @@
                     nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
-                    else {
-                        if (!gdth_polling) 
-                            GDTH_UNLOCK_HA(ha,flags);
-                        /* io_request_lock already active ! */      
+                    else
                         nscp->scsi_done(nscp);
-                        if (!gdth_polling) 
-                            GDTH_LOCK_HA(ha,flags);
-                    }
-                } else if (gdth_internal_cache_cmd(hanum,nscp)) {
-                    if (!gdth_polling) 
-                        GDTH_UNLOCK_HA(ha,flags);
-                    /* io_request_lock already active ! */      
+                } else if (gdth_internal_cache_cmd(hanum,nscp))
                     nscp->scsi_done(nscp);
-                    if (!gdth_polling) 
-                        GDTH_LOCK_HA(ha,flags);
-                }
                 break;
 
               case ALLOW_MEDIUM_REMOVAL:
@@ -2600,14 +2451,8 @@
                     nscp->sense_buffer[0] = 0;
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
-                    else {
-                        if (!gdth_polling) 
-                            GDTH_UNLOCK_HA(ha,flags);
-                        /* io_request_lock already active ! */      
+                    else
                         nscp->scsi_done(nscp);
-                        if (!gdth_polling) 
-                            GDTH_LOCK_HA(ha,flags);
-                    }
                 } else {
                     nscp->cmnd[3] = (ha->hdr[t].devtype&1) ? 1:0;
                     TRACE(("Prevent/allow r. %d rem. drive %d\n",
@@ -2629,10 +2474,8 @@
               case WRITE_6:
               case READ_10:
               case WRITE_10:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
               case READ_16:
               case WRITE_16:
-#endif
                 if (ha->hdr[t].media_changed) {
                     /* return UNIT_ATTENTION */
                     TRACE2(("cmd 0x%x target %d: UNIT_ATTENTION\n",
@@ -2644,14 +2487,8 @@
                     nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
-                    else {
-                        if (!gdth_polling) 
-                            GDTH_UNLOCK_HA(ha,flags);
-                        /* io_request_lock already active ! */      
+                    else
                         nscp->scsi_done(nscp);
-                        if (!gdth_polling) 
-                            GDTH_LOCK_HA(ha,flags);
-                    }
                 } else if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
                     this_cmd = FALSE;
                 break;
@@ -2665,14 +2502,8 @@
                 nscp->result = DID_ABORT << 16;
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
-                else {
-                    if (!gdth_polling) 
-                        GDTH_UNLOCK_HA(ha,flags);
-                    /* io_request_lock already active ! */  
+                else
                     nscp->scsi_done(nscp);
-                    if (!gdth_polling) 
-                        GDTH_LOCK_HA(ha,flags);
-                }
                 break;
             }
         }
@@ -2692,7 +2523,7 @@
     }
 
     if (!gdth_polling) 
-        GDTH_UNLOCK_HA(ha, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
 
     if (gdth_polling && ha->cmd_cnt > 0) {
         if (!gdth_wait(hanum,cmd_index,POLL_TIMEOUT))
@@ -2716,7 +2547,6 @@
 
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
         sgcnt = pci_map_sg(ha->pdev,sl,scp->use_sg,PCI_DMA_FROMDEVICE);
         for (i=0,cpsum=0; i<sgcnt; ++i,++sl) {
             cpnow = (ushort)sg_dma_len(sl);
@@ -2738,22 +2568,6 @@
         }
         pci_unmap_sg(ha->pdev,scp->request_buffer,
                      scp->use_sg,PCI_DMA_FROMDEVICE);
-#else
-        sgcnt = scp->use_sg;
-        for (i=0,cpsum=0; i<sgcnt; ++i,++sl) {
-            cpnow = (ushort)sl->length;
-            TRACE(("copy_internal() now %d sum %d count %d %d\n",
-                          cpnow,cpsum,cpcount,(ushort)scp->bufflen));
-            if (cpsum+cpnow > cpcount) 
-               cpnow = cpcount - cpsum;
-            cpsum += cpnow;
-            address = (char *)sl->address;
-            memcpy(address,buffer,cpnow);
-            if (cpsum == cpcount)
-                break;
-            buffer += cpnow;
-        }
-#endif
     } else {
         TRACE(("copy_internal() count %d\n",cpcount));
         memcpy((char*)scp->request_buffer,buffer,cpcount);
@@ -2770,11 +2584,7 @@
     gdth_modep_data mpd;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     t  = scp->device->id;
-#else
-    t  = scp->target;
-#endif
     TRACE(("gdth_internal_cache_cmd() cmd 0x%x hdrive %d\n",
            scp->cmnd[0],t));
 
@@ -2839,7 +2649,6 @@
         gdth_copy_internal_data(hanum,scp,(char*)&rdc,sizeof(gdth_rdcap_data));
         break;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
       case SERVICE_ACTION_IN:
         if ((scp->cmnd[1] & 0x1f) == SAI_READ_CAPACITY_16 &&
             (ha->cache_feat & GDT_64BIT)) {
@@ -2853,7 +2662,6 @@
             scp->result = DID_ABORT << 16;
         }
         break;
-#endif
 
       default:
         TRACE2(("Internal cache cmd 0x%x unknown\n",scp->cmnd[0]));
@@ -2877,10 +2685,8 @@
     ulong64 no, blockno;
     dma_addr_t phys_addr;
     int i, cmd_index, read_write, sgcnt, mode64;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
     struct page *page;
     ulong offset;
-#endif
 
     ha = HADATA(gdth_ctr_tab[hanum]);
     cmdp = ha->pccb;
@@ -2922,10 +2728,7 @@
         else
             cmdp->OpCode = GDT_FLUSH;
     } else if (scp->cmnd[0] == WRITE_6 || scp->cmnd[0] == WRITE_10 ||
-               scp->cmnd[0] == WRITE_12 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-               || scp->cmnd[0] == WRITE_16
-#endif
+               scp->cmnd[0] == WRITE_12 || scp->cmnd[0] == WRITE_16
     ) {
         read_write = 1;
         if (gdth_write_through || ((ha->hdr[hdrive].rw_attribs & 1) && 
@@ -2976,7 +2779,6 @@
         if (scp->use_sg) {
             sl = (struct scatterlist *)scp->request_buffer;
             sgcnt = scp->use_sg;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
             scp->SCp.Status = GDTH_MAP_SG;
             scp->SCp.Message = (read_write == 1 ? 
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);   
@@ -3005,23 +2807,6 @@
                     cmdp->u.cache.sg_lst[i].sg_len = sg_dma_len(sl);
                 }
             }
-#else
-            if (mode64) {
-                cmdp->u.cache64.DestAddr= (ulong64)-1;
-                cmdp->u.cache64.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.cache64.sg_lst[i].sg_ptr = virt_to_bus(sl->address);
-                    cmdp->u.cache64.sg_lst[i].sg_len = (ulong32)sl->length;
-                }
-            } else {
-                cmdp->u.cache.DestAddr= 0xffffffff;
-                cmdp->u.cache.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.cache.sg_lst[i].sg_ptr = virt_to_bus(sl->address);
-                    cmdp->u.cache.sg_lst[i].sg_len = (ulong32)sl->length;
-                }
-            }
-#endif
 
 #ifdef GDTH_STATISTICS
             if (max_sg < (ulong32)sgcnt) {
@@ -3031,7 +2816,6 @@
 #endif
 
         } else {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
             scp->SCp.Status = GDTH_MAP_SINGLE;
             scp->SCp.Message = (read_write == 1 ? 
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
@@ -3040,9 +2824,6 @@
             phys_addr = pci_map_page(ha->pdev,page,offset,
                                      scp->request_bufflen,scp->SCp.Message);
             scp->SCp.dma_handle = phys_addr;
-#else
-            phys_addr = virt_to_bus(scp->request_buffer);
-#endif
             if (mode64) {
                 if (ha->cache_feat & SCATTER_GATHER) {
                     cmdp->u.cache64.DestAddr = (ulong64)-1;
@@ -3114,19 +2895,12 @@
     dma_addr_t phys_addr, sense_paddr;
     int cmd_index, sgcnt, mode64;
     unchar t,l;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
     struct page *page;
     ulong offset;
-#endif
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     t = scp->device->id;
     l = scp->device->lun;
-#else
-    t = scp->target;
-    l = scp->lun;
-#endif
     cmdp = ha->pccb;
     TRACE(("gdth_fill_raw_cmd() cmd 0x%x bus %d ID %d LUN %d\n",
            scp->cmnd[0],b,t,l));
@@ -3166,7 +2940,6 @@
         }
 
     } else {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
         page = virt_to_page(scp->sense_buffer);
         offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
@@ -3174,9 +2947,6 @@
         scp->SCp.buffer = (struct scatterlist *)((ulong32)sense_paddr);
         /* high part, if 64bit */
         scp->host_scribble = (char *)(ulong32)((ulong64)sense_paddr >> 32);
-#else
-        sense_paddr = virt_to_bus(scp->sense_buffer);
-#endif
         cmdp->OpCode           = GDT_WRITE;             /* always */
         cmdp->BoardNode        = LOCALBOARD;
         if (mode64) { 
@@ -3215,7 +2985,6 @@
         if (scp->use_sg) {
             sl = (struct scatterlist *)scp->request_buffer;
             sgcnt = scp->use_sg;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
             scp->SCp.Status = GDTH_MAP_SG;
             scp->SCp.Message = PCI_DMA_BIDIRECTIONAL; 
             sgcnt = pci_map_sg(ha->pdev,sl,scp->use_sg,scp->SCp.Message);
@@ -3243,23 +3012,6 @@
                     cmdp->u.raw.sg_lst[i].sg_len = sg_dma_len(sl);
                 }
             }
-#else
-            if (mode64) {
-                cmdp->u.raw64.sdata = (ulong64)-1;
-                cmdp->u.raw64.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.raw64.sg_lst[i].sg_ptr = virt_to_bus(sl->address);
-                    cmdp->u.raw64.sg_lst[i].sg_len = (ulong32)sl->length;
-                }
-            } else {
-                cmdp->u.raw.sdata = 0xffffffff;
-                cmdp->u.raw.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.raw.sg_lst[i].sg_ptr = virt_to_bus(sl->address);
-                    cmdp->u.raw.sg_lst[i].sg_len = (ulong32)sl->length;
-                }
-            }
-#endif
 
 #ifdef GDTH_STATISTICS
             if (max_sg < sgcnt) {
@@ -3269,7 +3021,6 @@
 #endif
 
         } else {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
             scp->SCp.Status = GDTH_MAP_SINGLE;
             scp->SCp.Message = PCI_DMA_BIDIRECTIONAL; 
             page = virt_to_page(scp->request_buffer);
@@ -3277,9 +3028,7 @@
             phys_addr = pci_map_page(ha->pdev,page,offset,
                                      scp->request_bufflen,scp->SCp.Message);
             scp->SCp.dma_handle = phys_addr;
-#else
-            phys_addr = virt_to_bus(scp->request_buffer);
-#endif
+
             if (mode64) {
                 if (ha->raw_feat & SCATTER_GATHER) {
                     cmdp->u.raw64.sdata  = (ulong64)-1;
@@ -3461,7 +3210,7 @@
     ulong flags;
 
     TRACE2(("gdth_read_event() handle %d\n", handle));
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
     if (handle == -1)
         eindex = eoldidx;
     else
@@ -3469,7 +3218,7 @@
     estr->event_source = 0;
 
     if (eindex >= MAX_EVENTS) {
-        GDTH_UNLOCK_HA(ha, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
         return eindex;
     }
     e = &ebuffer[eindex];
@@ -3482,7 +3231,7 @@
         }
         memcpy(estr, e, sizeof(gdth_evt_str));
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
     return eindex;
 }
 
@@ -3495,7 +3244,7 @@
     unchar found = FALSE;
 
     TRACE2(("gdth_readapp_event() app. %d\n", application));
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
     eindex = eoldidx;
     for (;;) {
         e = &ebuffer[eindex];
@@ -3515,7 +3264,7 @@
         memcpy(estr, e, sizeof(gdth_evt_str));
     else
         estr->event_source = 0;
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
 static void gdth_clear_events(void)
@@ -3529,12 +3278,9 @@
 
 /* SCSI interface functions */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static irqreturn_t gdth_interrupt(int irq,void *dev_id,struct pt_regs *regs)
-#else
-static void gdth_interrupt(int irq,void *dev_id,struct pt_regs *regs)
-#endif
 {
+    gdth_ha_str *ha2 = (gdth_ha_str *)dev_id;
     register gdth_ha_str *ha;
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
     gdt6_dpram_str __iomem *dp6_ptr;
@@ -3556,28 +3302,20 @@
     /* if polling and not from gdth_wait() -> return */
     if (gdth_polling) {
         if (!gdth_from_wait) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             return IRQ_HANDLED;
-#else
-            return;             
-#endif
         }
     }
 
     if (!gdth_polling)
-        GDTH_LOCK_HA((gdth_ha_str *)dev_id,flags);
+	spin_lock_irqsave(&ha2->smp_lock, flags);
     wait_index = 0;
 
     /* search controller */
     if ((hanum = gdth_get_status(&IStatus,irq)) == -1) {
         /* spurious interrupt */
         if (!gdth_polling)
-            GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+            spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
-#else
-            return;             
-#endif
     }
     ha = HADATA(gdth_ctr_tab[hanum]);
 
@@ -3711,12 +3449,8 @@
         } else {
             TRACE2(("gdth_interrupt() unknown controller type\n"));
             if (!gdth_polling)
-                GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+                spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
-#else
-            return;             
-#endif
         }
 
         TRACE(("gdth_interrupt() index %d stat %d info %d\n",
@@ -3731,13 +3465,9 @@
             TRACE2(("gdth_interrupt() async. event\n"));
             gdth_async_event(hanum);
             if (!gdth_polling)
-                GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
+                spin_unlock_irqrestore(&ha2->smp_lock, flags);
             gdth_next(hanum);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             return IRQ_HANDLED;
-#else
-            return;             
-#endif
         } 
 
         if (IStatus == SPEZINDEX) {
@@ -3746,12 +3476,8 @@
             ha->dvr.eu.driver.ionode = hanum;
             gdth_store_event(ha, ES_DRIVER, 4, &ha->dvr);
             if (!gdth_polling)
-                GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+                spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
-#else
-            return;             
-#endif
         }
         scp     = ha->cmd_tab[IStatus-2].cmnd;
         Service = ha->cmd_tab[IStatus-2].service;
@@ -3763,40 +3489,24 @@
             ha->dvr.eu.driver.index = IStatus;
             gdth_store_event(ha, ES_DRIVER, 1, &ha->dvr);
             if (!gdth_polling)
-                GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+                spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
-#else
-            return;             
-#endif
         }
         if (scp == INTERNAL_CMND) {
             TRACE(("gdth_interrupt() answer to internal command\n"));
             if (!gdth_polling)
-                GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+                spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
-#else
-            return;             
-#endif
         }
 
         TRACE(("gdth_interrupt() sync. status\n"));
         rval = gdth_sync_event(hanum,Service,IStatus,scp);
         if (!gdth_polling)
-            GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
+            spin_unlock_irqrestore(&ha2->smp_lock, flags);
         if (rval == 2) {
             gdth_putq(hanum,scp,scp->SCp.this_residual);
         } else if (rval == 1) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            GDTH_LOCK_SCSI_DONE(scp->device->host, flags);
             scp->scsi_done(scp);
-            GDTH_UNLOCK_SCSI_DONE(scp->device->host, flags);
-#else
-            GDTH_LOCK_SCSI_DONE(flags);
-            scp->scsi_done(scp);
-            GDTH_UNLOCK_SCSI_DONE(flags);
-#endif
         }
 
 #ifdef INT_COAL
@@ -3825,9 +3535,7 @@
 #endif
 
     gdth_next(hanum);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     return IRQ_HANDLED;
-#endif
 }
 
 static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
@@ -3911,13 +3619,8 @@
         printk("\n");
 
     } else {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
         t = scp->device->id;
-#else
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->channel;
-        t = scp->target;
-#endif
         if (scp->SCp.sent_command == -1 && b != ha->virt_bus) {
             ha->raw[BUS_L2P(ha,b)].io_cnt[t]--;
         }
@@ -3929,7 +3632,6 @@
             /* retry */
             return 2;
         }
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
         if (scp->SCp.Status == GDTH_MAP_SG) 
             pci_unmap_sg(ha->pdev,scp->request_buffer,
                          scp->use_sg,scp->SCp.Message);
@@ -3943,7 +3645,7 @@
                 addr += (dma_addr_t)((ulong64)(ulong32)scp->host_scribble << 32);               
             pci_unmap_page(ha->pdev,addr,16,PCI_DMA_FROMDEVICE);
         }
-#endif
+
         if (ha->status == S_OK) {
             scp->SCp.Status = S_OK;
             scp->SCp.Message = ha->info;
@@ -4340,7 +4042,7 @@
     int hanum = 0;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (act_stats=0,i=0; i<GDTH_MAXCMDS; ++i) 
         if (ha->cmd_tab[i].cmnd != UNUSED_CMND)
@@ -4355,11 +4057,11 @@
 
     gdth_timer.expires = jiffies + 30 * HZ;
     add_timer(&gdth_timer);
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 #endif
 
-GDTH_INITFUNC(void, internal_setup(char *str,int *ints))
+void __init internal_setup(char *str,int *ints)
 {
     int i, argc;
     char *cur_str, *argv;
@@ -4432,7 +4134,7 @@
     }
 }
 
-GDTH_INITFUNC(int, option_setup(char *str))
+int __init option_setup(char *str)
 {
     int ints[MAXHA];
     char *cur = str;
@@ -4450,7 +4152,7 @@
     return 1;
 }
 
-GDTH_INITFUNC(int, gdth_detect(Scsi_Host_Template *shtp))
+int __init gdth_detect(Scsi_Host_Template *shtp)
 {
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
@@ -4540,7 +4242,6 @@
 
                 ha->pccb = CMDDATA(shp);
                 ha->ccb_phys = 0L;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
                 ha->pdev = NULL;
                 ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
                                                     &scratch_dma_handle);
@@ -4554,21 +4255,7 @@
                         MAXOFFSETS, &scratch_dma_handle);
                 ha->coal_stat_phys = scratch_dma_handle;
 #endif
-#else
-                ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
-                if (ha->pscratch)
-                    ha->scratch_phys = virt_to_bus(ha->pscratch);
-                ha->pmsg = scsi_init_malloc(sizeof(gdth_msg_str), GFP_ATOMIC | GFP_DMA);
-                if (ha->pmsg)
-                    ha->msg_phys = virt_to_bus(ha->pmsg);
-#ifdef INT_COAL
-                ha->coal_stat = 
-                    scsi_init_malloc(sizeof(gdth_coal_status) * MAXOFFSETS, 
-                                     GFP_ATOMIC | GFP_DMA);
-                if (ha->coal_stat)
-                    ha->coal_stat_phys = virt_to_bus(ha->coal_stat);
-#endif
-#endif
+
                 ha->scratch_busy = FALSE;
                 ha->req_first = NULL;
                 ha->tid_cnt = MAX_HDRIVES;
@@ -4583,7 +4270,7 @@
                     printk("GDT-ISA: Error during device scan\n");
                     --gdth_ctr_count;
                     --gdth_ctr_vcount;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+
 #ifdef INT_COAL
                     if (ha->coal_stat)
                         pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
@@ -4596,17 +4283,7 @@
                     if (ha->pmsg)
                         pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
                                             ha->pmsg, ha->msg_phys);
-#else
-#ifdef INT_COAL
-                    if (ha->coal_stat)
-                        scsi_init_free((void *)ha->coal_stat, 
-                                       sizeof(gdth_coal_status) * MAXOFFSETS);
-#endif
-                    if (ha->pscratch)
-                        scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
-                    if (ha->pmsg)
-                        scsi_init_free((void *)ha->pmsg, sizeof(gdth_msg_str));
-#endif
+
                     free_irq(ha->irq,ha);
                     scsi_unregister(shp);
                     continue;
@@ -4615,14 +4292,13 @@
                     hdr_channel = ha->bus_cnt;
                 ha->virt_bus = hdr_channel;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
     LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
                 shp->highmem_io  = 0;
 #endif
                 if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
                     shp->max_cmd_len = 16;
-#endif
+
                 shp->max_id      = ha->tid_cnt;
                 shp->max_lun     = MAXLUN;
                 shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
@@ -4640,7 +4316,7 @@
                     }
                 }  
 
-                GDTH_INIT_LOCK_HA(ha);
+                spin_lock_init(&ha->smp_lock);
                 gdth_enable_int(hanum);
 #endif /* !__ia64__ */
             }
@@ -4686,7 +4362,7 @@
 
                 ha->pccb = CMDDATA(shp);
                 ha->ccb_phys = 0L; 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+
                 ha->pdev = NULL;
                 ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
                                                     &scratch_dma_handle);
@@ -4703,22 +4379,6 @@
                 ha->ccb_phys = 
                     pci_map_single(ha->pdev,ha->pccb,
                                    sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
-#else
-                ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
-                if (ha->pscratch)
-                    ha->scratch_phys = virt_to_bus(ha->pscratch);
-                ha->pmsg = scsi_init_malloc(sizeof(gdth_msg_str), GFP_ATOMIC | GFP_DMA);
-                if (ha->pmsg)
-                    ha->msg_phys = virt_to_bus(ha->pmsg);
-#ifdef INT_COAL
-                ha->coal_stat = 
-                    scsi_init_malloc(sizeof(gdth_coal_status) * MAXOFFSETS, 
-                                     GFP_ATOMIC | GFP_DMA);
-                if (ha->coal_stat)
-                    ha->coal_stat_phys = virt_to_bus(ha->coal_stat);
-#endif
-                ha->ccb_phys = virt_to_bus(ha->pccb);
-#endif
                 ha->scratch_busy = FALSE;
                 ha->req_first = NULL;
                 ha->tid_cnt = MAX_HDRIVES;
@@ -4733,7 +4393,6 @@
                     printk("GDT-EISA: Error during device scan\n");
                     --gdth_ctr_count;
                     --gdth_ctr_vcount;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #ifdef INT_COAL
                     if (ha->coal_stat)
                         pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
@@ -4749,17 +4408,6 @@
                     if (ha->ccb_phys)
                         pci_unmap_single(ha->pdev,ha->ccb_phys,
                                         sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
-#else
-#ifdef INT_COAL
-                    if (ha->coal_stat)
-                        scsi_init_free((void *)ha->coal_stat, 
-                                       sizeof(gdth_coal_status) * MAXOFFSETS);
-#endif
-                    if (ha->pscratch)
-                        scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
-                    if (ha->pmsg)
-                        scsi_init_free((void *)ha->pmsg, sizeof(gdth_msg_str));
-#endif
                     free_irq(ha->irq,ha);
                     scsi_unregister(shp);
                     continue;
@@ -4768,14 +4416,13 @@
                     hdr_channel = ha->bus_cnt;
                 ha->virt_bus = hdr_channel;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
     LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
                 shp->highmem_io  = 0;
 #endif
                 if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
                     shp->max_cmd_len = 16;
-#endif
+
                 shp->max_id      = ha->tid_cnt;
                 shp->max_lun     = MAXLUN;
                 shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
@@ -4793,7 +4440,7 @@
                     }
                 }  
 
-                GDTH_INIT_LOCK_HA(ha);
+                spin_lock_init(&ha->smp_lock);
                 gdth_enable_int(hanum);
             }
         }
@@ -4841,7 +4488,7 @@
 
         ha->pccb = CMDDATA(shp);
         ha->ccb_phys = 0L;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+
         ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
                                             &scratch_dma_handle);
         ha->scratch_phys = scratch_dma_handle;
@@ -4854,21 +4501,6 @@
                                  MAXOFFSETS, &scratch_dma_handle);
         ha->coal_stat_phys = scratch_dma_handle;
 #endif
-#else
-        ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
-        if (ha->pscratch)
-            ha->scratch_phys = virt_to_bus(ha->pscratch);
-        ha->pmsg = scsi_init_malloc(sizeof(gdth_msg_str), GFP_ATOMIC | GFP_DMA);
-        if (ha->pmsg)
-            ha->msg_phys = virt_to_bus(ha->pmsg);
-#ifdef INT_COAL
-        ha->coal_stat = 
-            scsi_init_malloc(sizeof(gdth_coal_status) * MAXOFFSETS, 
-                             GFP_ATOMIC | GFP_DMA);
-        if (ha->coal_stat)
-            ha->coal_stat_phys = virt_to_bus(ha->coal_stat);
-#endif
-#endif
         ha->scratch_busy = FALSE;
         ha->req_first = NULL;
         ha->tid_cnt = pcistr[ctr].device_id >= 0x200 ? MAXID : MAX_HDRIVES;
@@ -4887,7 +4519,7 @@
                 hdr_channel = ha->bus_cnt;
             ha->virt_bus = hdr_channel;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             scsi_set_device(shp, &pcistr[ctr].pdev->dev);
 #else
@@ -4909,14 +4541,12 @@
                     err = TRUE;
                 }
             }
-#endif
         }
 
         if (err) {
             printk("GDT-PCI %d: Error during device scan\n", hanum);
             --gdth_ctr_count;
             --gdth_ctr_vcount;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #ifdef INT_COAL
             if (ha->coal_stat)
                 pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
@@ -4929,17 +4559,6 @@
             if (ha->pmsg)
                 pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
                                     ha->pmsg, ha->msg_phys);
-#else
-#ifdef INT_COAL
-            if (ha->coal_stat)
-                scsi_init_free((void *)ha->coal_stat, 
-                               sizeof(gdth_coal_status) * MAXOFFSETS);
-#endif
-            if (ha->pscratch)
-                scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
-            if (ha->pmsg)
-                scsi_init_free((void *)ha->pmsg, sizeof(gdth_msg_str));
-#endif
             free_irq(ha->irq,ha);
             scsi_unregister(shp);
             continue;
@@ -4962,8 +4581,7 @@
             }
         }  
 
-
-        GDTH_INIT_LOCK_HA(ha);
+        spin_lock_init(&ha->smp_lock);
         gdth_enable_int(hanum);
     }
     
@@ -4994,12 +4612,10 @@
     if (NUMDATA(shp)->busnum == 0) {
         hanum = NUMDATA(shp)->hanum;
         ha    = HADATA(gdth_ctr_tab[hanum]);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
         if (ha->sdev) {
             scsi_free_host_dev(ha->sdev);
             ha->sdev = NULL;
         }
-#endif
         gdth_flush(hanum);
 
         if (shp->irq) {
@@ -5010,7 +4626,6 @@
             free_dma(shp->dma_channel);
         }
 #endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 #ifdef INT_COAL
         if (ha->coal_stat)
             pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
@@ -5025,17 +4640,6 @@
         if (ha->ccb_phys)
             pci_unmap_single(ha->pdev,ha->ccb_phys,
                              sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
-#else
-#ifdef INT_COAL
-        if (ha->coal_stat)
-            scsi_init_free((void *)ha->coal_stat, 
-                           sizeof(gdth_coal_status) * MAXOFFSETS);
-#endif
-        if (ha->pscratch)
-            scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
-        if (ha->pmsg)
-            scsi_init_free((void *)ha->pmsg, sizeof(gdth_msg_str));
-#endif
         gdth_ctr_released++;
         TRACE2(("gdth_release(): HA %d of %d\n", 
                 gdth_ctr_released, gdth_ctr_count));
@@ -5098,21 +4702,6 @@
     return ((const char *)ha->binfo.type_string);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-/* old error handling */
-int gdth_abort(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_abort() reason %d\n",scp->abort_reason));
-    return SCSI_ABORT_SNOOZE;
-}
-
-int gdth_reset(Scsi_Cmnd *scp, unsigned int reset_flags)
-{
-    TRACE2(("gdth_reset()\n"));
-    return SCSI_RESET_PUNT;
-}
-#endif
-
 /* new error handling */
 int gdth_eh_abort(Scsi_Cmnd *scp)
 {
@@ -5135,33 +4724,25 @@
     unchar b;
 
     TRACE2(("gdth_eh_bus_reset()\n"));
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+
     hanum = NUMDATA(scp->device->host)->hanum;
     b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-#else
-    hanum = NUMDATA(scp->host)->hanum;
-    b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->channel;
-#endif
     ha    = HADATA(gdth_ctr_tab[hanum]);
 
     /* clear command tab */
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         cmnd = ha->cmd_tab[i].cmnd;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         if (!SPECIAL_SCP(cmnd) && cmnd->device->channel == b)
-#else
-        if (!SPECIAL_SCP(cmnd) && cmnd->channel == b)
-#endif
             ha->cmd_tab[i].cmnd = UNUSED_CMND;
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 
     if (b == ha->virt_bus) {
         /* host drives */
         for (i = 0; i < MAX_HDRIVES; ++i) {
             if (ha->hdr[i].present) {
-                GDTH_LOCK_HA(ha, flags);
+                spin_lock_irqsave(&ha->smp_lock, flags);
                 gdth_polling = TRUE;
                 while (gdth_test_busy(hanum))
                     gdth_delay(0);
@@ -5169,12 +4750,12 @@
                                       GDT_CLUST_RESET, i, 0, 0))
                     ha->hdr[i].cluster_type &= ~CLUSTER_RESERVED;
                 gdth_polling = FALSE;
-                GDTH_UNLOCK_HA(ha, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
             }
         }
     } else {
         /* raw devices */
-        GDTH_LOCK_HA(ha, flags);
+        spin_lock_irqsave(&ha->smp_lock, flags);
         for (i = 0; i < MAXID; ++i)
             ha->raw[BUS_L2P(ha,b)].io_cnt[i] = 0;
         gdth_polling = TRUE;
@@ -5183,7 +4764,7 @@
         gdth_internal_cmd(hanum, SCSIRAWSERVICE, GDT_RESET_BUS,
                           BUS_L2P(ha,b), 0, 0);
         gdth_polling = FALSE;
-        GDTH_UNLOCK_HA(ha, flags);
+	spin_unlock_irqrestore(&ha->smp_lock, flags);
     }
     return SUCCESS;
 }
@@ -5249,11 +4830,8 @@
     scp->SCp.sent_command = -1;
     scp->SCp.Status = GDTH_MAP_NONE;
     scp->SCp.buffer = (struct scatterlist *)NULL;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+
     hanum = NUMDATA(scp->device->host)->hanum;
-#else
-    hanum = NUMDATA(scp->host)->hanum;
-#endif
 #ifdef GDTH_STATISTICS
     ++act_ios;
 #endif
@@ -5270,7 +4848,6 @@
 
 static int gdth_open(struct inode *inode, struct file *filep)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     gdth_ha_str *ha;
     int i;
 
@@ -5279,7 +4856,6 @@
         if (!ha->sdev)
             ha->sdev = scsi_get_host_dev(gdth_ctr_tab[i]);
     }
-#endif
 
     TRACE(("gdth_open()\n"));
     return 0;
@@ -5311,10 +4887,10 @@
             evt.event.event_data.size=sizeof(evt.event.event_data.eu.sync); 
         else
             evt.event.event_data.size=sizeof(evt.event.event_data.eu.async);
-        GDTH_LOCK_HA(ha, flags);
+        spin_lock_irqsave(&ha->smp_lock, flags);
         gdth_store_event(ha, evt.event.event_source, evt.event.event_idx,
                          &evt.event.event_data);
-        GDTH_UNLOCK_HA(ha, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
     } else if (evt.erase == 0xfe) {
         gdth_clear_events();
     } else if (evt.erase == 0) {
@@ -5344,15 +4920,15 @@
         if (j >= MAX_HDRIVES || !ha->hdr[j].present)
             continue;
         if (ldrv.lock) {
-            GDTH_LOCK_HA(ha, flags);
+            spin_lock_irqsave(&ha->smp_lock, flags);
             ha->hdr[j].lock = 1;
-            GDTH_UNLOCK_HA(ha, flags);
+            spin_unlock_irqrestore(&ha->smp_lock, flags);
             gdth_wait_completion(ldrv.ionode, ha->bus_cnt, j); 
             gdth_stop_timeout(ldrv.ionode, ha->bus_cnt, j); 
         } else {
-            GDTH_LOCK_HA(ha, flags);
+            spin_lock_irqsave(&ha->smp_lock, flags);
             ha->hdr[j].lock = 0;
-            GDTH_UNLOCK_HA(ha, flags);
+            spin_unlock_irqrestore(&ha->smp_lock, flags);
             gdth_start_timeout(ldrv.ionode, ha->bus_cnt, j); 
             gdth_next(ldrv.ionode); 
         }
@@ -5367,11 +4943,9 @@
     int hanum;
     gdth_ha_str *ha;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        Scsi_Request *srp;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        Scsi_Cmnd *scp;
+    Scsi_Request *srp;
 #else
-        Scsi_Cmnd scp;
+    Scsi_Cmnd *scp;
 #endif
 
     if (copy_from_user(&res, arg, sizeof(gdth_ioctl_reset)) ||
@@ -5398,7 +4972,7 @@
     gdth_do_req(srp, &cmd, cmnd, 30);
     res.status = (ushort)srp->sr_command->SCp.Status;
     scsi_release_request(srp);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
     if (!scp)
         return -ENOMEM;
@@ -5407,15 +4981,8 @@
     gdth_do_cmd(scp, &cmd, cmnd, 30);
     res.status = (ushort)scp->SCp.Status;
     scsi_release_command(scp);
-#else
-    memset(&ha->sdev,0,sizeof(Scsi_Device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    ha->sdev.host = scp.host = gdth_ctr_tab[hanum];
-    ha->sdev.id = scp.target = ha->sdev.host->this_id;
-    scp.device = &ha->sdev;
-    gdth_do_cmd(&scp, &cmd, cmnd, 30);
-    res.status = (ushort)scp.SCp.Status;
 #endif
+
     if (copy_to_user(arg, &res, sizeof(gdth_ioctl_reset)))
         return -EFAULT;
     return 0;
@@ -5430,10 +4997,8 @@
         gdth_ha_str *ha; 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         Scsi_Request *srp;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        Scsi_Cmnd *scp;
 #else
-        Scsi_Cmnd scp;
+        Scsi_Cmnd *scp;
 #endif
         
     if (copy_from_user(&gen, arg, sizeof(gdth_ioctl_general)) ||
@@ -5536,7 +5101,7 @@
     gen.status = srp->sr_command->SCp.Status;
     gen.info = srp->sr_command->SCp.Message;
     scsi_release_request(srp);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
     if (!scp)
         return -ENOMEM;
@@ -5546,15 +5111,6 @@
     gen.status = scp->SCp.Status;
     gen.info = scp->SCp.Message;
     scsi_release_command(scp);
-#else
-    memset(&ha->sdev,0,sizeof(Scsi_Device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    ha->sdev.host = scp.host = gdth_ctr_tab[hanum];
-    ha->sdev.id = scp.target = ha->sdev.host->this_id;
-    scp.device = &ha->sdev;
-    gdth_do_cmd(&scp, &gen.command, cmnd, gen.timeout);
-    gen.status = scp.SCp.Status;
-    gen.info = scp.SCp.Message;
 #endif
 
     if (copy_to_user(arg + sizeof(gdth_ioctl_general), buf, 
@@ -5580,10 +5136,8 @@
     int hanum;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request *srp;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-    Scsi_Cmnd *scp;
 #else
-    Scsi_Cmnd scp;
+    Scsi_Cmnd *scp;
 #endif
         
     if (copy_from_user(&rsc, arg, sizeof(gdth_ioctl_rescan)) ||
@@ -5599,18 +5153,12 @@
         return -ENOMEM;
     srp->sr_cmd_len = 12;
     srp->sr_use_sg = 0;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
     scp->use_sg = 0;
-#else
-    memset(&ha->sdev,0,sizeof(Scsi_Device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    ha->sdev.host = scp.host = gdth_ctr_tab[hanum];
-    ha->sdev.id = scp.target = ha->sdev.host->this_id;
-    scp.device = &ha->sdev;
 #endif
 
     for (i = 0; i < MAX_HDRIVES; ++i) { 
@@ -5633,20 +5181,16 @@
             gdth_do_req(srp, &cmd, cmnd, 30);
             if (srp->sr_command->SCp.Status == S_OK)
                 rsc.hdr_list[i].cluster_type = srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
             gdth_do_cmd(scp, &cmd, cmnd, 30);
             if (scp->SCp.Status == S_OK)
                 rsc.hdr_list[i].cluster_type = scp->SCp.Message;
-#else
-            gdth_do_cmd(&scp, &cmd, cmnd, 30);
-            if (scp.SCp.Status == S_OK)
-                rsc.hdr_list[i].cluster_type = scp.SCp.Message;
 #endif
         }
     } 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     scsi_release_request(srp);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scsi_release_command(scp);
 #endif       
  
@@ -5666,10 +5210,8 @@
     gdth_ha_str *ha; 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request *srp;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-    Scsi_Cmnd *scp;
 #else
-    Scsi_Cmnd scp;
+    Scsi_Cmnd *scp;
 #endif
         
     if (copy_from_user(&rsc, arg, sizeof(gdth_ioctl_rescan)) ||
@@ -5685,18 +5227,12 @@
         return -ENOMEM;
     srp->sr_cmd_len = 12;
     srp->sr_use_sg = 0;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
     scp->use_sg = 0;
-#else
-    memset(&ha->sdev,0,sizeof(Scsi_Device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    ha->sdev.host = scp.host = gdth_ctr_tab[hanum];
-    ha->sdev.id = scp.target = ha->sdev.host->this_id;
-    scp.device = &ha->sdev;
 #endif
      
     if (rsc.flag == 0) {
@@ -5713,14 +5249,10 @@
         gdth_do_req(srp, &cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
         gdth_do_cmd(scp, &cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
-#else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
-        status = (ushort)scp.SCp.Status;
-        info = (ulong32)scp.SCp.Message;
 #endif
         i = 0;
         hdr_cnt = (status == S_OK ? (ushort)info : 0);
@@ -5739,16 +5271,12 @@
         gdth_do_req(srp, &cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
         gdth_do_cmd(scp, &cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
-#else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
-        status = (ushort)scp.SCp.Status;
-        info = (ulong32)scp.SCp.Message;
 #endif
-        GDTH_LOCK_HA(ha, flags);
+        spin_lock_irqsave(&ha->smp_lock, flags);
         rsc.hdr_list[i].bus = ha->virt_bus;
         rsc.hdr_list[i].target = i;
         rsc.hdr_list[i].lun = 0;
@@ -5765,7 +5293,7 @@
             /* round size */
             ha->hdr[i].size = cyls * hds * secs;
         }
-        GDTH_UNLOCK_HA(ha, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
         if (status != S_OK)
             continue; 
         
@@ -5783,18 +5311,14 @@
         gdth_do_req(srp, &cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
         gdth_do_cmd(scp, &cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
-#else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
-        status = (ushort)scp.SCp.Status;
-        info = (ulong32)scp.SCp.Message;
 #endif
-        GDTH_LOCK_HA(ha, flags);
+        spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].devtype = (status == S_OK ? (ushort)info : 0);
-        GDTH_UNLOCK_HA(ha, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
 
         cmd.Service = CACHESERVICE;
         cmd.OpCode = GDT_CLUST_INFO;
@@ -5806,19 +5330,15 @@
         gdth_do_req(srp, &cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
         gdth_do_cmd(scp, &cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
-#else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
-        status = (ushort)scp.SCp.Status;
-        info = (ulong32)scp.SCp.Message;
 #endif
-        GDTH_LOCK_HA(ha, flags);
+        spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].cluster_type = 
             ((status == S_OK && !shared_access) ? (ushort)info : 0);
-        GDTH_UNLOCK_HA(ha, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
         rsc.hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
 
         cmd.Service = CACHESERVICE;
@@ -5831,22 +5351,19 @@
         gdth_do_req(srp, &cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
         gdth_do_cmd(scp, &cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
-#else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
-        status = (ushort)scp.SCp.Status;
-        info = (ulong32)scp.SCp.Message;
 #endif
-        GDTH_LOCK_HA(ha, flags);
+        spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].rw_attribs = (status == S_OK ? (ushort)info : 0);
-        GDTH_UNLOCK_HA(ha, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
     }
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     scsi_release_request(srp);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scsi_release_command(scp);
 #endif       
  
@@ -5859,13 +5376,7 @@
                       unsigned int cmd, unsigned long arg)
 {
     gdth_ha_str *ha; 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Cmnd *scp;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     Scsi_Cmnd *scp;
-#else
-    Scsi_Cmnd scp;
-#endif
     ulong flags;
     char cmnd[MAX_COMMAND_SIZE];   
     void __user *argp = (void __user *)arg;
@@ -5956,17 +5467,17 @@
         i = lchn.channel;
         if (i < ha->bus_cnt) {
             if (lchn.lock) {
-                GDTH_LOCK_HA(ha, flags);
+                spin_lock_irqsave(&ha->smp_lock, flags);
                 ha->raw[i].lock = 1;
-                GDTH_UNLOCK_HA(ha, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
                 for (j = 0; j < ha->tid_cnt; ++j) {
                     gdth_wait_completion(lchn.ionode, i, j); 
                     gdth_stop_timeout(lchn.ionode, i, j); 
                 }
             } else {
-                GDTH_LOCK_HA(ha, flags);
+                spin_lock_irqsave(&ha->smp_lock, flags);
                 ha->raw[i].lock = 0;
-                GDTH_UNLOCK_HA(ha, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
                 for (j = 0; j < ha->tid_cnt; ++j) {
                     gdth_start_timeout(lchn.ionode, i, j); 
                     gdth_next(lchn.ionode); 
@@ -6004,7 +5515,7 @@
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
         scsi_put_command(scp);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
         scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
         if (!scp)
             return -ENOMEM;
@@ -6014,15 +5525,6 @@
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
         scsi_release_command(scp);
-#else 
-        memset(&ha->sdev,0,sizeof(Scsi_Device));
-        memset(&scp, 0,sizeof(Scsi_Cmnd));
-        ha->sdev.host = scp.host = gdth_ctr_tab[hanum];
-        ha->sdev.id = scp.target = ha->sdev.host->this_id;
-        scp.device = &ha->sdev;
-        scp.channel = virt_ctr ? 0 : res.number;
-        rval = gdth_eh_bus_reset(&scp);
-        res.status = (rval == SUCCESS ? S_OK : S_GENERR);
 #endif
         if (copy_to_user(argp, &res, sizeof(gdth_ioctl_reset)))
             return -EFAULT;
@@ -6047,14 +5549,10 @@
     gdth_cmd_str    gdtcmd;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request    *srp;
-    Scsi_Device     *sdev;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-    Scsi_Cmnd       *scp;
-    Scsi_Device     *sdev;
 #else
-    Scsi_Cmnd       scp;
-    Scsi_Device     sdev;
+    Scsi_Cmnd       *scp;
 #endif
+    Scsi_Device     *sdev;
     char            cmnd[MAX_COMMAND_SIZE];   
     memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 
@@ -6068,19 +5566,13 @@
         return;
     srp->sr_cmd_len = 12;
     srp->sr_use_sg = 0;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
     scp  = scsi_allocate_device(sdev, 1, FALSE);
     if (!scp)
         return;
     scp->cmd_len = 12;
     scp->use_sg = 0;
-#else
-    memset(&sdev,0,sizeof(Scsi_Device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    sdev.host = scp.host = gdth_ctr_tab[hanum];
-    sdev.id = scp.target = sdev.host->this_id;
-    scp.device = &sdev;
 #endif
 
     for (i = 0; i < MAX_HDRIVES; ++i) {
@@ -6100,17 +5592,15 @@
             TRACE2(("gdth_flush(): flush ha %d drive %d\n", hanum, i));
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             gdth_do_req(srp, &gdtcmd, cmnd, 30);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-            gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
 #else
-            gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+            gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
 #endif
         }
     }
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     scsi_release_request(srp);
     scsi_free_host_dev(sdev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scsi_release_command(scp);
     scsi_free_host_dev(sdev);
 #endif
@@ -6125,12 +5615,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request    *srp;
     Scsi_Device     *sdev;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     Scsi_Cmnd       *scp;
     Scsi_Device     *sdev;
-#else
-    Scsi_Cmnd       scp;
-    Scsi_Device     sdev;
 #endif
     char            cmnd[MAX_COMMAND_SIZE];   
 #endif
@@ -6162,7 +5649,7 @@
         gdth_do_req(srp, &gdtcmd, cmnd, 10);
         scsi_release_request(srp);
         scsi_free_host_dev(sdev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
         scp  = scsi_allocate_device(sdev, 1, FALSE);
         if (!scp) {
@@ -6174,13 +5661,6 @@
         gdth_do_cmd(scp, &gdtcmd, cmnd, 10);
         scsi_release_command(scp);
         scsi_free_host_dev(sdev);
-#else
-        memset(&sdev,0,sizeof(Scsi_Device));
-        memset(&scp, 0,sizeof(Scsi_Cmnd));
-        sdev.host = scp.host = gdth_ctr_tab[hanum];
-        sdev.id = scp.target = sdev.host->this_id;
-        scp.device = &sdev;
-        gdth_do_cmd(&scp, &gdtcmd, cmnd, 10);
 #endif
 #endif
     }
@@ -6193,19 +5673,6 @@
     return NOTIFY_OK;
 }
 
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0) && !defined(MODULE)
-
-GDTH_INITFUNC(void, gdth_setup(char *str,int *ints)) 
-{    
-    TRACE2(("gdth_setup() str %s ints[0] %d\n", 
-            str ? str:"NULL", ints ? ints[0]:0));
-    internal_setup(str, ints);
-}
-
-#else
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static Scsi_Host_Template driver_template = {
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
@@ -6232,13 +5699,8 @@
 #endif
 #endif
 };
-#else
-static Scsi_Host_Template driver_template = GDTH;
-#endif
 
 #include "scsi_module.c"
 #ifndef MODULE
 __setup("gdth=", option_setup);
-#endif
-
 #endif
===== drivers/scsi/gdth_proc.c 1.17 vs edited =====
--- 1.17/drivers/scsi/gdth_proc.c	2004-05-13 22:02:45 +02:00
+++ edited/drivers/scsi/gdth_proc.c	2005-01-03 16:41:27 +01:00
@@ -2,9 +2,7 @@
  * $Id: gdth_proc.c,v 1.42 2004/03/05 15:50:20 achim Exp $
  */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
 #include <linux/completion.h>
-#endif
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offset,int length,   
@@ -57,12 +55,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request    *scp;
     Scsi_Device     *sdev;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     Scsi_Cmnd       *scp;
     Scsi_Device     *sdev;
-#else
-    Scsi_Cmnd       scp;
-    Scsi_Device     sdev;
 #endif
     TRACE2(("gdth_set_info() ha %d bus %d\n",hanum,busnum));
 
@@ -73,19 +68,13 @@
         return -ENOMEM;
     scp->sr_cmd_len = 12;
     scp->sr_use_sg = 0;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     sdev = scsi_get_host_dev(host);
     scp  = scsi_allocate_device(sdev, 1, FALSE);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
     scp->use_sg = 0;
-#else
-    memset(&sdev,0,sizeof(Scsi_Device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    sdev.host = scp.host = host;
-    sdev.id = scp.target = sdev.host->this_id;
-    scp.device = &sdev;
 #endif
 
     if (length >= 4) {
@@ -98,7 +87,7 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     scsi_release_request(scp);
     scsi_free_host_dev(sdev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scsi_release_command(scp);
     scsi_free_host_dev(sdev);
 #endif
@@ -107,10 +96,8 @@
          
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Request *scp)
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd *scp)
 #else
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd scp)
+static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd *scp)
 #endif
 {
     int             orig_length, drive, wb_mode;
@@ -161,10 +148,8 @@
                 }
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
                 gdth_do_req(scp, &gdtcmd, cmnd, 30);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-                gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
 #else
-                gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+                gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
 #endif
             }
         }
@@ -219,10 +204,8 @@
         pcpar->write_back = wb_mode==1 ? 0:1;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         gdth_do_req(scp, &gdtcmd, cmnd, 30);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
 #else
-        gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+        gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
 #endif
         gdth_ioctl_free(hanum, GDTH_SCRATCH, ha->pscratch, paddr);
         printk("Done.\n");
@@ -249,12 +232,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request *scp;
     Scsi_Device *sdev; 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     Scsi_Cmnd *scp;
     Scsi_Device *sdev;
-#else
-    Scsi_Cmnd scp;
-    Scsi_Device sdev;
 #endif
     char hrec[161];
     struct timeval tv;
@@ -281,22 +261,15 @@
         return -ENOMEM;
     scp->sr_cmd_len = 12;
     scp->sr_use_sg = 0;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     sdev = scsi_get_host_dev(host);
     scp  = scsi_allocate_device(sdev, 1, FALSE);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
     scp->use_sg = 0;
-#else
-    memset(&sdev,0,sizeof(Scsi_Device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    sdev.host = scp.host = host;
-    sdev.id = scp.target = sdev.host->this_id;
-    scp.device = &sdev;
 #endif
     
-    
     /* request is i.e. "cat /proc/scsi/gdth/0" */ 
     /* format: %-15s\t%-10s\t%-15s\t%s */
     /* driver parameters */
@@ -403,12 +376,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             gdth_do_req(scp, &gdtcmd, cmnd, 30);
             if (scp->sr_command->SCp.Status != S_OK) 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
             gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
             if (scp->SCp.Status != S_OK) 
-#else
-            gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
-            if (scp.SCp.Status != S_OK) 
 #endif
             { 
                 pds->count = 0;
@@ -430,12 +400,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
                 gdth_do_req(scp, &gdtcmd, cmnd, 30);
                 if (scp->sr_command->SCp.Status == S_OK) 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
                 gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
                 if (scp->SCp.Status == S_OK) 
-#else
-                gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
-                if (scp.SCp.Status == S_OK) 
 #endif
                 {
                     strncpy(hrec,pdi->vendor,8);
@@ -489,12 +456,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
                     gdth_do_req(scp, &gdtcmd, cmnd, 30);
                     if (scp->sr_command->SCp.Status == S_OK) 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
                     gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
                     if (scp->SCp.Status == S_OK) 
-#else
-                    gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
-                    if (scp.SCp.Status == S_OK) 
 #endif
                     {
                         size = sprintf(buffer+len,
@@ -545,12 +509,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
                 gdth_do_req(scp, &gdtcmd, cmnd, 30);
                 if (scp->sr_command->SCp.Status != S_OK) 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
                 gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
                 if (scp->SCp.Status != S_OK)
-#else
-                gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
-                if (scp.SCp.Status != S_OK)
 #endif
                 {
                     break;
@@ -658,12 +619,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             gdth_do_req(scp, &gdtcmd, cmnd, 30);
             if (scp->sr_command->SCp.Status == S_OK) 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
             gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
             if (scp->SCp.Status == S_OK) 
-#else
-            gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
-            if (scp.SCp.Status == S_OK) 
 #endif
             {
                 if (pai->ai_state == 0)
@@ -742,12 +700,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             gdth_do_req(scp, &gdtcmd, cmnd, 30);
             if (scp->sr_command->SCp.Status != S_OK) 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
             gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
             if (scp->SCp.Status != S_OK) 
-#else
-            gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
-            if (scp.SCp.Status != S_OK) 
 #endif
             {
                 ha->hdr[i].ldr_no = i;
@@ -826,7 +781,7 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     scsi_release_request(scp);
     scsi_free_host_dev(sdev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
     scsi_release_command(scp);
     scsi_free_host_dev(sdev);
 #endif
@@ -864,13 +819,7 @@
                         char *cmnd, int timeout)
 {
     unsigned bufflen;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
     DECLARE_COMPLETION(wait);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-    DECLARE_MUTEX_LOCKED(sem);
-#else
-    struct semaphore sem = MUTEX_LOCKED;
-#endif
 
     TRACE2(("gdth_do_cmd()\n"));
     if (gdtcmd != NULL) { 
@@ -880,22 +829,11 @@
         scp->SCp.this_residual = DEFAULT_PRI;
         bufflen = 0;
     }
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
+
     scp->request.rq_status = RQ_SCSI_BUSY;
     scp->request.waiting = &wait;
     scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
     wait_for_completion(&wait);
-#else
-    scp->request.sem = &sem;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-#else
-    spin_lock_irq(&io_request_lock);
-    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-    spin_unlock_irq(&io_request_lock);
-#endif
-    down(&sem);
-#endif
 }
 #endif
 
@@ -907,14 +845,10 @@
     scp->request->rq_status = RQ_SCSI_DONE;
     if (scp->request->waiting != NULL)
         complete(scp->request->waiting);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
+#else
     scp->request.rq_status = RQ_SCSI_DONE;
     if (scp->request.waiting != NULL)
         complete(scp->request.waiting);
-#else
-    scp->request.rq_status = RQ_SCSI_DONE;
-    if (scp->request.sem != NULL)
-        up(scp->request.sem);
 #endif
 }
 
@@ -929,7 +863,7 @@
         return NULL;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (!ha->scratch_busy && size <= GDTH_SCRATCH) {
         ha->scratch_busy = TRUE;
@@ -938,19 +872,13 @@
     } else if (scratch) {
         ret_val = NULL;
     } else {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
         dma_addr_t dma_addr;
 
         ret_val = pci_alloc_consistent(ha->pdev, size, &dma_addr);
         *paddr = dma_addr;
-#else
-        ret_val = scsi_init_malloc(size, GFP_ATOMIC | GFP_DMA);
-        if (ret_val)
-            *paddr = virt_to_bus(ret_val);
-#endif
     }
 
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
     return ret_val;
 }
 
@@ -960,19 +888,15 @@
     ulong flags;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (buf == ha->pscratch) {
         ha->scratch_busy = FALSE;
     } else {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
         pci_free_consistent(ha->pdev, size, buf, paddr);
-#else
-        scsi_init_free((void *)buf, size);
-#endif
     }
 
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
 #ifdef GDTH_IOCTL_PROC
@@ -983,14 +907,14 @@
     int ret_val;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     ret_val = FALSE;
     if (ha->scratch_busy) {
         if (((gdth_iord_str *)ha->pscratch)->size == (ulong32)size)
             ret_val = TRUE;
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
     return ret_val;
 }
 #endif
@@ -1004,36 +928,23 @@
     unchar b, t;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         scp = ha->cmd_tab[i].cmnd;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+
         b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
         t = scp->device->id;
-#else
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->channel;
-        t = scp->target;
-#endif
         if (!SPECIAL_SCP(scp) && t == (unchar)id && 
             b == (unchar)busnum) {
             scp->SCp.have_data_in = 0;
-            GDTH_UNLOCK_HA(ha, flags);
+            spin_unlock_irqrestore(&ha->smp_lock, flags);
             while (!scp->SCp.have_data_in)
                 barrier();
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            GDTH_LOCK_SCSI_DONE(scp->device->host, flags);
-            scp->scsi_done(scp);
-            GDTH_UNLOCK_SCSI_DONE(scp->device->host, flags);
-#else
-            GDTH_LOCK_SCSI_DONE(flags);
-            scp->scsi_done(scp);
-            GDTH_UNLOCK_SCSI_DONE(flags);
-#endif
-        GDTH_LOCK_HA(ha, flags);
+            spin_lock_irqsave(&ha->smp_lock, flags);
         }
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
 static void gdth_stop_timeout(int hanum, int busnum, int id)
@@ -1044,22 +955,17 @@
     unchar b, t;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
         t = scp->device->id;
-#else
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->channel;
-        t = scp->target;
-#endif
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
             scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
         }
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
 static void gdth_start_timeout(int hanum, int busnum, int id)
@@ -1070,22 +976,17 @@
     unchar b, t;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    GDTH_LOCK_HA(ha, flags);
+    spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
         t = scp->device->id;
-#else
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->channel;
-        t = scp->target;
-#endif
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_start_timeout(): update_timeout()\n"));
             gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
         }
     }
-    GDTH_UNLOCK_HA(ha, flags);
+    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
 static int gdth_update_timeout(int hanum, Scsi_Cmnd *scp, int timeout)
===== drivers/scsi/gdth_proc.h 1.7 vs edited =====
--- 1.7/drivers/scsi/gdth_proc.h	2004-05-13 22:02:45 +02:00
+++ edited/drivers/scsi/gdth_proc.h	2005-01-03 16:19:42 +01:00
@@ -14,14 +14,10 @@
 static void gdth_do_req(Scsi_Request *srp, gdth_cmd_str *cmd, 
                         char *cmnd, int timeout);
 static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Request *scp);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
+#else
 static void gdth_do_cmd(Scsi_Cmnd *scp, gdth_cmd_str *cmd, 
                         char *cmnd, int timeout);
 static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd *scp);
-#else 
-static void gdth_do_cmd(Scsi_Cmnd *scp, gdth_cmd_str *cmd, 
-                        char *cmnd, int timeout);
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd scp);
 #endif
 
 static char *gdth_ioctl_alloc(int hanum, int size, int scratch,
--- /dev/null	2004-08-20 00:05:11.000000000 +0200
+++ edited/drivers/scsi/gdth_kcompat.h	2005-01-03 16:11:16.025989472 +0100
@@ -0,0 +1,21 @@
+
+
+#ifndef IRQ_HANDLED
+typedef void irqreturn_t;
+#define IRQ_NONE
+#define IRQ_HANDLED
+#endif
+
+#ifndef MODULE_LICENSE
+#define MODULE_LICENSE(x)
+#endif
+
+#ifndef SERVICE_ACTION_IN
+#define SERVICE_ACTION_IN	0x9e
+#endif
+#ifndef READ_16
+#define READ_16			0x88
+#endif
+#ifndef WRITE_16
+#define WRITE_16		0x8a
+#endif
