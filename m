From: Christoph Hellwig <hch@infradead.org>
Subject: Re: HEADS UP for gdth driver users
Date: Sat, 10 Jun 2006 11:14:14 +0100
Message-ID: <20060610101414.GD20526@infradead.org>
References: <EF6AF37986D67948AD48624A3E5D93AFAA967C@mtce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61110 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751467AbWFJKOR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 06:14:17 -0400
Content-Disposition: inline
In-Reply-To: <EF6AF37986D67948AD48624A3E5D93AFAA967C@mtce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 09, 2006 at 01:03:08PM +0200, Leubner, Achim wrote:
> Hi Christoph,
> 
> Attached you find a patch to remove the scsi_request interface from the
> gdth driver. The patch contains your first patch, the changes for
> removing the scsi_request interface and some changes to preserve the
> 2.4.x compatibility.
> We tested it and it should work fine. It would be great if it could be
> integrated in the 2.6.18 cycle.

ok.  some of that 2.4 compat code is rather messy and I'd prefer to get
rid of it mid-term.  But for now the scsi_request removal is the important
thing, so I'd be happy to get this in ASAP.


diff -u ./gdth.c new/gdth.c
--- ./gdth.c	2006-05-03 11:53:32.000000000 +0200
+++ new/gdth.c	2006-05-03 11:53:45.000000000 +0200
@@ -4,9 +4,9 @@
  * Intel Corporation:  Storage RAID Controllers                         *
  *                                                                      *
  * gdth.c                                                               *
- * Copyright (C) 1995-04 ICP vortex GmbH, Achim Leubner                 *
+ * Copyright (C) 1995-06 ICP vortex GmbH, Achim Leubner                 *
  * Copyright (C) 2002-04 Intel Corporation                              *
- * Copyright (C) 2003-04 Adaptec Inc.                                   *
+ * Copyright (C) 2003-06 Adaptec Inc.                                   *
  * <achim_leubner@adaptec.com>                                          *
  *                                                                      *
  * Additions/Fixes:                                                     *
@@ -27,9 +27,14 @@
  * along with this kernel; if not, write to the Free Software           *
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.            *
  *                                                                      *
- * Linux kernel 2.2.x, 2.4.x, 2.6.x supported                           *
+ * Linux kernel 2.4.x, 2.6.x supported                                  *
  *                                                                      *
  * $Log: gdth.c,v $
+ * Revision 1.74  2006/04/10 13:44:47  achim
+ * Community changes for 2.6.x 
+ * Kernel 2.2.x no longer supported
+ * scsi_request interface removed, thanks to Christoph Hellwig
+ *
  * Revision 1.73  2004/03/31 13:33:03  achim
  * Special command 0xfd implemented to detect 64-bit DMA support
  *
@@ -94,7 +99,7 @@
  * Bugfix free_irq()
  *
  * Revision 1.56  2001/08/09 11:19:39  achim
- * struct scsi_host_template changes
+ * Scsi_Host_Template changes
  *
  * Revision 1.55  2001/08/09 10:11:28  achim
  * Command HOST_UNFREEZE_IO before cache service init.
@@ -388,7 +393,13 @@
 #include <linux/proc_fs.h>
 #include <linux/time.h>
 #include <linux/timer.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
 #include <linux/dma-mapping.h>
+#else
+#define DMA_32BIT_MASK	0x00000000ffffffffULL
+#define DMA_64BIT_MASK	0xffffffffffffffffULL
+#endif
+
 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>
 #endif
@@ -408,8 +419,8 @@
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
-#include "gdth.h"
 #include "gdth_kcompat.h"
+#include "gdth.h"
 
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
@@ -464,6 +475,8 @@
 
 static void gdth_flush(int hanum);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
+static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
+static void gdth_scsi_done(struct scsi_cmnd *scp); 
 
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
@@ -643,6 +656,7 @@
 static int force_dma32 = 0;
 
 /* parameters for modprobe/insmod */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,11)
 module_param_array(irq, int, NULL, 0);
 module_param(disable, int, 0);
 module_param(reserve_mode, int, 0);
@@ -655,6 +669,20 @@
 module_param(shared_access, int, 0);
 module_param(probe_eisa_isa, int, 0);
 module_param(force_dma32, int, 0);
+#else
+MODULE_PARM(irq, "i");
+MODULE_PARM(disable, "i");
+MODULE_PARM(reserve_mode, "i");
+MODULE_PARM(reserve_list, "4-" __MODULE_STRING(MAX_RES_ARGS) "i");
+MODULE_PARM(reverse_scan, "i");
+MODULE_PARM(hdr_channel, "i");
+MODULE_PARM(max_ids, "i");
+MODULE_PARM(rescan, "i");
+MODULE_PARM(virt_ctr, "i");
+MODULE_PARM(shared_access, "i");
+MODULE_PARM(probe_eisa_isa, "i");
+MODULE_PARM(force_dma32, "i");
+#endif
 MODULE_AUTHOR("Achim Leubner");
 MODULE_LICENSE("GPL");
 
@@ -683,6 +711,91 @@
     }
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0) 
+static void gdth_scsi_done(struct scsi_cmnd *scp) 
+{
+    TRACE2(("gdth_scsi_done()\n"));
+
+    if (scp->sc_request)
+        complete((struct completion *)scp->sc_request);
+}
+
+int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
+                   int timeout, u32 *info)
+{
+    Scsi_Cmnd *scp;
+    DECLARE_COMPLETION(wait);
+    int rval;
+
+    scp = kmalloc(sizeof(*scp), GFP_KERNEL);
+    if (!scp)
+        return -ENOMEM;
+    memset(scp, 0, sizeof(*scp));
+    scp->device = sdev;
+    /* use sc_request field to save the ptr. to completion struct. */   
+    scp->sc_request = (struct scsi_request *)&wait;
+    scp->timeout_per_command = timeout*HZ;
+    scp->request_buffer = gdtcmd;
+    scp->cmd_len = 12;
+    memcpy(scp->cmnd, cmnd, 12);
+    scp->SCp.this_residual = IOCTL_PRI;   /* priority */        
+    scp->done = gdth_scsi_done; /* some fn. test this */
+    gdth_queuecommand(scp, gdth_scsi_done);
+    wait_for_completion(&wait);
+
+    rval = scp->SCp.Status;
+    if (info)
+        *info = scp->SCp.Message;
+    kfree(scp);
+    return rval;
+}
+#else
+static void gdth_scsi_done(Scsi_Cmnd *scp) 
+{
+    TRACE2(("gdth_scsi_done()\n"));
+
+    scp->request.rq_status = RQ_SCSI_DONE;
+    if (scp->request.waiting)
+        complete(scp->request.waiting);
+}
+
+int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
+                   int timeout, u32 *info)
+{
+    Scsi_Cmnd *scp = scsi_allocate_device(sdev, 1, FALSE);
+    unsigned bufflen = gdtcmd ? sizeof(gdth_cmd_str) : 0;
+    DECLARE_COMPLETION(wait);
+    int rval;
+
+    if (!scp)
+        return -ENOMEM;
+    scp->cmd_len = 12;
+    scp->use_sg = 0;
+    scp->SCp.this_residual = IOCTL_PRI;   /* priority */        
+    scp->request.rq_status = RQ_SCSI_BUSY;
+    scp->request.waiting = &wait;
+    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
+    wait_for_completion(&wait);
+
+    rval = scp->SCp.Status;
+    if (info)
+        *info = scp->SCp.Message;
+
+    scsi_release_command(scp);
+    return rval;
+}
+#endif
+
+int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
+                 int timeout, u32 *info)
+{
+    struct scsi_device *sdev = scsi_get_host_dev(shost);
+    int rval = __gdth_execute(sdev, gdtcmd, cmnd, timeout, info);
+
+    scsi_free_host_dev(sdev);
+    return rval;
+}
+
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs)
 {
     *cyls = size /HEADS/SECS;
@@ -773,7 +886,7 @@
 MODULE_DEVICE_TABLE(pci,gdthtable);
 
 static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
-                                           ushort vendor, ushort device)
+                                   ushort vendor, ushort device)
 {
     ulong base0, base1, base2;
     struct pci_dev *pdev;
@@ -2248,16 +2361,18 @@
     ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
-    scp->SCp.this_residual = (int)priority;
-    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-    t = scp->device->id;
-    if (priority >= DEFAULT_PRI) {
-        if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
-            (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) {
-            TRACE2(("gdth_putq(): locked IO -> update_timeout()\n"));
-            scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+    if (scp->done != gdth_scsi_done) {
+        scp->SCp.this_residual = (int)priority;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum:scp->device->channel;
+        t = scp->device->id;
+        if (priority >= DEFAULT_PRI) {
+            if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
+                (b==ha->virt_bus && t<MAX_HDRIVES && ha->hdr[t].lock)) {
+                TRACE2(("gdth_putq(): locked IO ->update_timeout()\n"));
+                scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+            }
         }
-    }
+    }   
 
     if (ha->req_first==NULL) {
         ha->req_first = scp;                    /* queue was empty */
@@ -2309,14 +2424,18 @@
     for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-        b = virt_ctr ? NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
-        t = nscp->device->id;
-        l = nscp->device->lun;
-        if (nscp->SCp.this_residual >= DEFAULT_PRI) {
-            if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
-                (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) 
-                continue;
-        }
+        if (nscp->done != gdth_scsi_done) {
+            b = virt_ctr ? 
+                NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
+            t = nscp->device->id;
+            l = nscp->device->lun;
+            if (nscp->SCp.this_residual >= DEFAULT_PRI) {
+                if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
+                    (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) 
+                    continue;
+            }
+        } else
+            b = t = l = 0;
 
         if (firsttime) {
             if (gdth_test_busy(hanum)) {        /* controller busy ? */
@@ -2331,7 +2450,7 @@
             firsttime = FALSE;
         }
 
-        if (nscp->done != gdth_scsi_done || nscp->cmnd[0] != 0xff) {        
+        if (nscp->done != gdth_scsi_done) {        
         if (nscp->SCp.phase == -1) {
             nscp->SCp.phase = CACHESERVICE;           /* default: cache svc. */ 
             if (nscp->cmnd[0] == TEST_UNIT_READY) {
@@ -2394,7 +2513,7 @@
                 else
                     nscp->scsi_done(nscp);
             }
-        } else if (nscp->done == gdth_scsi_done && nscp->cmnd[0] == 0xff) {
+        } else if (nscp->done == gdth_scsi_done) {
             if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
                 this_cmd = FALSE;
             next_cmd = FALSE;
@@ -2548,7 +2667,7 @@
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
         for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
-	    unsigned long flags;
+            unsigned long flags;
             cpnow = (ushort)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
                           cpnow,cpsum,cpcount,(ushort)scp->bufflen));
@@ -2560,12 +2679,19 @@
                        hanum);
                 return;
             }
-	    local_irq_save(flags);
-	    address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
+            local_irq_save(flags);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+            address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
+            memcpy(address,buffer,cpnow);
+            flush_dcache_page(sl->page);
+            kunmap_atomic(address, KM_BIO_SRC_IRQ);
+#else
+            address = kmap_atomic(sl->page, KM_BH_IRQ) + sl->offset;
             memcpy(address,buffer,cpnow);
-	    flush_dcache_page(sl->page);
-	    kunmap_atomic(address, KM_BIO_SRC_IRQ);
-	    local_irq_restore(flags);
+            flush_dcache_page(sl->page);
+            kunmap_atomic(address, KM_BH_IRQ);
+#endif
+            local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
             buffer += cpnow;
@@ -2946,9 +3072,9 @@
         offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
-        scp->SCp.buffer = (struct scatterlist *)((ulong32)sense_paddr);
+        *(ulong32 *)&scp->SCp.buffer = (ulong32)sense_paddr;
         /* high part, if 64bit */
-        scp->host_scribble = (char *)(ulong32)((ulong64)sense_paddr >> 32);
+        *(ulong32 *)&scp->host_scribble = (ulong32)((ulong64)sense_paddr >> 32);
         cmdp->OpCode           = GDT_WRITE;             /* always */
         cmdp->BoardNode        = LOCALBOARD;
         if (mode64) { 
@@ -3022,7 +3148,7 @@
             }
 #endif
 
-        } else {
+        } else if (scp->request_bufflen) {
             scp->SCp.Status = GDTH_MAP_SINGLE;
             scp->SCp.Message = PCI_DMA_BIDIRECTIONAL; 
             page = virt_to_page(scp->request_buffer);
@@ -3309,7 +3435,7 @@
     }
 
     if (!gdth_polling)
-	spin_lock_irqsave(&ha2->smp_lock, flags);
+        spin_lock_irqsave(&ha2->smp_lock, flags);
     wait_index = 0;
 
     /* search controller */
@@ -3642,9 +3768,10 @@
                            scp->request_bufflen,scp->SCp.Message);
         if (scp->SCp.buffer) {
             dma_addr_t addr;
-            addr = (dma_addr_t)(ulong32)scp->SCp.buffer;
+            addr = (dma_addr_t)*(ulong32 *)&scp->SCp.buffer;
             if (scp->host_scribble)
-                addr += (dma_addr_t)((ulong64)(ulong32)scp->host_scribble << 32);               
+                addr += (dma_addr_t)
+                    ((ulong64)(*(ulong32 *)&scp->host_scribble) << 32);               
             pci_unmap_page(ha->pdev,addr,16,PCI_DMA_FROMDEVICE);
         }
 
@@ -4154,7 +4281,11 @@
     return 1;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int __init gdth_detect(struct scsi_host_template *shtp)
+#else
+static int __init gdth_detect(Scsi_Host_Template *shtp)
+#endif
 {
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
@@ -4188,7 +4319,7 @@
         return 0;
     }
 
-    printk("GDT-HA: Storage RAID Controller Driver. Version: %s \n",GDTH_VERSION_STR);
+    printk("GDT-HA: Storage RAID Controller Driver. Version: %s\n",GDTH_VERSION_STR);
     /* initializations */
     gdth_polling = TRUE; b = 0;
     gdth_clear_events();
@@ -4751,7 +4882,7 @@
         gdth_internal_cmd(hanum, SCSIRAWSERVICE, GDT_RESET_BUS,
                           BUS_L2P(ha,b), 0, 0);
         gdth_polling = FALSE;
-	spin_unlock_irqrestore(&ha->smp_lock, flags);
+        spin_unlock_irqrestore(&ha->smp_lock, flags);
     }
     return SUCCESS;
 }
@@ -4817,9 +4948,11 @@
 #endif
 
     priority = DEFAULT_PRI;
-    if (scp->done == gdth_scsi_done)
+    if (scp->done == gdth_scsi_done) 
         priority = scp->SCp.this_residual;
-    gdth_update_timeout(hanum, scp, scp->timeout_per_command * 6);
+    else 
+        gdth_update_timeout(hanum, scp, scp->timeout_per_command * 6);
+
     gdth_putq( hanum, scp, priority );
     gdth_next( hanum );
     return 0;
@@ -4922,11 +5055,7 @@
     gdth_cmd_str cmd;
     int hanum;
     gdth_ha_str *ha;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Request *srp;
-#else
-    Scsi_Cmnd *scp;
-#endif
+    int rval;
 
     if (copy_from_user(&res, arg, sizeof(gdth_ioctl_reset)) ||
         res.ionode >= gdth_ctr_count || res.number >= MAX_HDRIVES)
@@ -4943,25 +5072,11 @@
         cmd.u.cache64.DeviceNo = res.number;
     else
         cmd.u.cache.DeviceNo = res.number;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    srp  = scsi_allocate_request(ha->sdev, GFP_KERNEL);
-    if (!srp)
-        return -ENOMEM;
-    srp->sr_cmd_len = 12;
-    srp->sr_use_sg = 0;
-    gdth_do_req(srp, &cmd, cmnd, 30);
-    res.status = (ushort)srp->sr_command->SCp.Status;
-    scsi_release_request(srp);
-#else
-    scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
-    if (!scp)
-        return -ENOMEM;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-    gdth_do_cmd(scp, &cmd, cmnd, 30);
-    res.status = (ushort)scp->SCp.Status;
-    scsi_release_command(scp);
-#endif
+
+    rval = __gdth_execute(ha->sdev, &cmd, cmnd, 30, NULL);
+    if (rval < 0)
+        return rval;
+    res.status = rval;
 
     if (copy_to_user(arg, &res, sizeof(gdth_ioctl_reset)))
         return -EFAULT;
@@ -4974,12 +5089,8 @@
     char *buf = NULL;
     ulong64 paddr; 
     int hanum;
-        gdth_ha_str *ha; 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        Scsi_Request *srp;
-#else
-        Scsi_Cmnd *scp;
-#endif
+    gdth_ha_str *ha;
+    int rval;
         
     if (copy_from_user(&gen, arg, sizeof(gdth_ioctl_general)) ||
         gen.ionode >= gdth_ctr_count)
@@ -5071,27 +5182,10 @@
         }
     }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    srp  = scsi_allocate_request(ha->sdev, GFP_KERNEL);
-    if (!srp)
-        return -ENOMEM;
-    srp->sr_cmd_len = 12;
-    srp->sr_use_sg = 0;
-    gdth_do_req(srp, &gen.command, cmnd, gen.timeout);
-    gen.status = srp->sr_command->SCp.Status;
-    gen.info = srp->sr_command->SCp.Message;
-    scsi_release_request(srp);
-#else
-    scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
-    if (!scp)
-        return -ENOMEM;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-    gdth_do_cmd(scp, &gen.command, cmnd, gen.timeout);
-    gen.status = scp->SCp.Status;
-    gen.info = scp->SCp.Message;
-    scsi_release_command(scp);
-#endif
+    rval = __gdth_execute(ha->sdev, &gen.command, cmnd, gen.timeout, &gen.info);
+    if (rval < 0)
+        return rval;
+    gen.status = rval;
 
     if (copy_to_user(arg + sizeof(gdth_ioctl_general), buf, 
                      gen.data_len + gen.sense_len)) {
@@ -5114,40 +5208,22 @@
     gdth_ha_str *ha;
     unchar i;
     int hanum, rc = -ENOMEM;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Request *srp;
-#else
-    Scsi_Cmnd *scp;
-#endif
-        
+    u32 cluster_type = 0;
+
     rsc = kmalloc(sizeof(*rsc), GFP_KERNEL);
     cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
     if (!rsc || !cmd)
-	goto free_fail;
+        goto free_fail;
 
     if (copy_from_user(rsc, arg, sizeof(gdth_ioctl_rescan)) ||
         rsc->ionode >= gdth_ctr_count) {
         rc = -EFAULT;
-	goto free_fail;
+        goto free_fail;
     }
     hanum = rsc->ionode;
     ha = HADATA(gdth_ctr_tab[hanum]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
    
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    srp  = scsi_allocate_request(ha->sdev, GFP_KERNEL);
-    if (!srp)
-        goto free_fail;
-    srp->sr_cmd_len = 12;
-    srp->sr_use_sg = 0;
-#else
-    scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
-    if (!scp)
-        goto free_fail;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-#endif
-
     for (i = 0; i < MAX_HDRIVES; ++i) { 
         if (!ha->hdr[i].present) {
             rsc->hdr_list[i].bus = 0xff; 
@@ -5164,27 +5240,15 @@
                 cmd->u.cache64.DeviceNo = i;
             else
                 cmd->u.cache.DeviceNo = i;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(srp, cmd, cmnd, 30);
-            if (srp->sr_command->SCp.Status == S_OK)
-                rsc->hdr_list[i].cluster_type = srp->sr_command->SCp.Message;
-#else
-            gdth_do_cmd(scp, cmd, cmnd, 30);
-            if (scp->SCp.Status == S_OK)
-                rsc->hdr_list[i].cluster_type = scp->SCp.Message;
-#endif
+            if (__gdth_execute(ha->sdev, cmd, cmnd, 30, &cluster_type) == S_OK)
+                rsc->hdr_list[i].cluster_type = cluster_type;
         }
     } 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    scsi_release_request(srp);
-#else
-    scsi_release_command(scp);
-#endif       
- 
+
     if (copy_to_user(arg, rsc, sizeof(gdth_ioctl_rescan)))
         rc = -EFAULT;
     else
-	rc = 0;
+        rc = 0;
 
 free_fail:
     kfree(rsc);
@@ -5202,40 +5266,21 @@
     int rc = -ENOMEM;
     ulong flags;
     gdth_ha_str *ha; 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Request *srp;
-#else
-    Scsi_Cmnd *scp;
-#endif
 
     rsc = kmalloc(sizeof(*rsc), GFP_KERNEL);
     cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
     if (!cmd || !rsc)
-	goto free_fail;
+        goto free_fail;
 
     if (copy_from_user(rsc, arg, sizeof(gdth_ioctl_rescan)) ||
         rsc->ionode >= gdth_ctr_count) {
-	rc = -EFAULT;
-	goto free_fail;
+        rc = -EFAULT;
+        goto free_fail;
     }
     hanum = rsc->ionode;
     ha = HADATA(gdth_ctr_tab[hanum]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    srp  = scsi_allocate_request(ha->sdev, GFP_KERNEL);
-    if (!srp)
-        goto free_fail;
-    srp->sr_cmd_len = 12;
-    srp->sr_use_sg = 0;
-#else
-    scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
-    if (!scp)
-        goto free_fail;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-#endif
-     
     if (rsc->flag == 0) {
         /* old method: re-init. cache service */
         cmd->Service = CACHESERVICE;
@@ -5246,19 +5291,8 @@
             cmd->OpCode = GDT_INIT;
             cmd->u.cache.DeviceNo = LINUX_OS;
         }
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, cmd, cmnd, 30);
-        status = (ushort)srp->sr_command->SCp.Status;
-        info = (ulong32)srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        gdth_do_cmd(scp, cmd, cmnd, 30);
-        status = (ushort)scp->SCp.Status;
-        info = (ulong32)scp->SCp.Message;
-#else
-        gdth_do_cmd(&scp, cmd, cmnd, 30);
-        status = (ushort)scp.SCp.Status;
-        info = (ulong32)scp.SCp.Message;
-#endif
+
+        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
         i = 0;
         hdr_cnt = (status == S_OK ? (ushort)info : 0);
     } else {
@@ -5273,15 +5307,9 @@
             cmd->u.cache64.DeviceNo = i;
         else 
             cmd->u.cache.DeviceNo = i;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, cmd, cmnd, 30);
-        status = (ushort)srp->sr_command->SCp.Status;
-        info = (ulong32)srp->sr_command->SCp.Message;
-#else
-        gdth_do_cmd(scp, cmd, cmnd, 30);
-        status = (ushort)scp->SCp.Status;
-        info = (ulong32)scp->SCp.Message;
-#endif
+
+        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+
         spin_lock_irqsave(&ha->smp_lock, flags);
         rsc->hdr_list[i].bus = ha->virt_bus;
         rsc->hdr_list[i].target = i;
@@ -5313,15 +5341,9 @@
             cmd->u.cache64.DeviceNo = i;
         else
             cmd->u.cache.DeviceNo = i;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, cmd, cmnd, 30);
-        status = (ushort)srp->sr_command->SCp.Status;
-        info = (ulong32)srp->sr_command->SCp.Message;
-#else
-        gdth_do_cmd(scp, cmd, cmnd, 30);
-        status = (ushort)scp->SCp.Status;
-        info = (ulong32)scp->SCp.Message;
-#endif
+
+        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+
         spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].devtype = (status == S_OK ? (ushort)info : 0);
         spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -5332,15 +5354,9 @@
             cmd->u.cache64.DeviceNo = i;
         else
             cmd->u.cache.DeviceNo = i;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, cmd, cmnd, 30);
-        status = (ushort)srp->sr_command->SCp.Status;
-        info = (ulong32)srp->sr_command->SCp.Message;
-#else
-        gdth_do_cmd(scp, cmd, cmnd, 30);
-        status = (ushort)scp->SCp.Status;
-        info = (ulong32)scp->SCp.Message;
-#endif
+
+        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+
         spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].cluster_type = 
             ((status == S_OK && !shared_access) ? (ushort)info : 0);
@@ -5353,29 +5369,18 @@
             cmd->u.cache64.DeviceNo = i;
         else
             cmd->u.cache.DeviceNo = i;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, cmd, cmnd, 30);
-        status = (ushort)srp->sr_command->SCp.Status;
-        info = (ulong32)srp->sr_command->SCp.Message;
-#else
-        gdth_do_cmd(scp, cmd, cmnd, 30);
-        status = (ushort)scp->SCp.Status;
-        info = (ulong32)scp->SCp.Message;
-#endif
+
+        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+
         spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].rw_attribs = (status == S_OK ? (ushort)info : 0);
         spin_unlock_irqrestore(&ha->smp_lock, flags);
     }
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    scsi_release_request(srp);
-#else
-    scsi_release_command(scp);
-#endif       
  
     if (copy_to_user(arg, rsc, sizeof(gdth_ioctl_rescan)))
         rc = -EFAULT;
     else
-	rc = 0;
+        rc = 0;
 
 free_fail:
     kfree(rsc);
@@ -5515,17 +5520,18 @@
         hanum = res.ionode; 
         ha = HADATA(gdth_ctr_tab[hanum]);
 
-        /* Because we need a Scsi_Cmnd struct., we make a scsi_allocate device also for kernels >=2.6.x */        
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        scp  = scsi_get_command(ha->sdev, GFP_KERNEL);
+        scp  = kmalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
             return -ENOMEM;
+        memset(scp, 0, sizeof(*scp));
+        scp->device = ha->sdev;
         scp->cmd_len = 12;
         scp->use_sg = 0;
         scp->device->channel = virt_ctr ? 0 : res.number;
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
-        scsi_put_command(scp);
+        kfree(scp);
 #else
         scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
         if (!scp)
@@ -5558,34 +5564,12 @@
     int             i;
     gdth_ha_str     *ha;
     gdth_cmd_str    gdtcmd;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Request    *srp;
-#else
-    Scsi_Cmnd       *scp;
-#endif
-    struct scsi_device     *sdev;
     char            cmnd[MAX_COMMAND_SIZE];   
     memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 
     TRACE2(("gdth_flush() hanum %d\n",hanum));
     ha = HADATA(gdth_ctr_tab[hanum]);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    srp  = scsi_allocate_request(sdev, GFP_KERNEL);
-    if (!srp)
-        return;
-    srp->sr_cmd_len = 12;
-    srp->sr_use_sg = 0;
-#else
-    sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    scp  = scsi_allocate_device(sdev, 1, FALSE);
-    if (!scp)
-        return;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-#endif
-
     for (i = 0; i < MAX_HDRIVES; ++i) {
         if (ha->hdr[i].present) {
             gdtcmd.BoardNode = LOCALBOARD;
@@ -5601,20 +5585,10 @@
                 gdtcmd.u.cache.sg_canz = 0;
             }
             TRACE2(("gdth_flush(): flush ha %d drive %d\n", hanum, i));
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(srp, &gdtcmd, cmnd, 30);
-#else
-            gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
-#endif
+
+            gdth_execute(gdth_ctr_tab[hanum], &gdtcmd, cmnd, 30, NULL);
         }
     }
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    scsi_release_request(srp);
-    scsi_free_host_dev(sdev);
-#else
-    scsi_release_command(scp);
-    scsi_free_host_dev(sdev);
-#endif
 }
 
 /* shutdown routine */
@@ -5623,18 +5597,11 @@
     int             hanum;
 #ifndef __alpha__
     gdth_cmd_str    gdtcmd;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Request    *srp;
-    struct scsi_device     *sdev;
-#else
-    Scsi_Cmnd       *scp;
-    struct scsi_device     *sdev;
-#endif
     char            cmnd[MAX_COMMAND_SIZE];   
 #endif
 
     if (notifier_disabled)
-    	return NOTIFY_OK;
+        return NOTIFY_OK;
 
     TRACE2(("gdth_halt() event %d\n",(int)event));
     if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
@@ -5652,31 +5619,7 @@
         gdtcmd.Service = CACHESERVICE;
         gdtcmd.OpCode = GDT_RESET;
         TRACE2(("gdth_halt(): reset controller %d\n", hanum));
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev, GFP_KERNEL);
-        if (!srp) {
-            unregister_reboot_notifier(&gdth_notifier);
-            return NOTIFY_OK;
-        }
-        srp->sr_cmd_len = 12;
-        srp->sr_use_sg = 0;
-        gdth_do_req(srp, &gdtcmd, cmnd, 10);
-        scsi_release_request(srp);
-        scsi_free_host_dev(sdev);
-#else
-        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        scp  = scsi_allocate_device(sdev, 1, FALSE);
-        if (!scp) {
-            unregister_reboot_notifier(&gdth_notifier);
-            return NOTIFY_OK;
-        }
-        scp->cmd_len = 12;
-        scp->use_sg = 0;
-        gdth_do_cmd(scp, &gdtcmd, cmnd, 10);
-        scsi_release_command(scp);
-        scsi_free_host_dev(sdev);
-#endif
+        gdth_execute(gdth_ctr_tab[hanum], &gdtcmd, cmnd, 10, NULL);
 #endif
     }
     printk("Done.\n");
@@ -5687,7 +5630,22 @@
     return NOTIFY_OK;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+/* configure lun */
+static int gdth_slave_configure(struct scsi_device *sdev)
+{
+    scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+    sdev->skip_ms_page_3f = 1;
+    sdev->skip_ms_page_8 = 1;
+    return 0;
+}
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static struct scsi_host_template driver_template = {
+#else
+static Scsi_Host_Template driver_template = {
+#endif
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
@@ -5698,6 +5656,9 @@
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
         .bios_param             = gdth_bios_param,
         .can_queue              = GDTH_MAXCMDS,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+        .slave_configure        = gdth_slave_configure,
+#endif
         .this_id                = -1,
         .sg_tablesize           = GDTH_MAXSG,
         .cmd_per_lun            = GDTH_MAXC_P_L,
diff -u ./gdth.h new/gdth.h
--- ./gdth.h	2006-05-03 11:53:32.000000000 +0200
+++ new/gdth.h	2006-05-02 16:02:00.000000000 +0200
@@ -4,13 +4,13 @@
 /*
  * Header file for the GDT Disk Array/Storage RAID controllers driver for Linux
  * 
- * gdth.h Copyright (C) 1995-03 ICP vortex, Achim Leubner
+ * gdth.h Copyright (C) 1995-06 ICP vortex, Achim Leubner
  * See gdth.c for further informations and 
  * below for supported controller types
  *
  * <achim_leubner@adaptec.com>
  *
- * $Id: gdth.h,v 1.57 2004/03/31 11:52:09 achim Exp $
+ * $Id: gdth.h,v 1.58 2006/01/11 16:14:09 achim Exp $
  */
 
 #include <linux/version.h>
@@ -26,9 +26,9 @@
 /* defines, macros */
 
 /* driver version */
-#define GDTH_VERSION_STR        "3.04"
+#define GDTH_VERSION_STR        "3.05"
 #define GDTH_VERSION            3
-#define GDTH_SUBVERSION         4
+#define GDTH_SUBVERSION         5
 
 /* protocol version */
 #define PROTOCOL_VERSION        1
diff -u ./gdth_kcompat.h new/gdth_kcompat.h
--- ./gdth_kcompat.h	2006-05-03 11:53:32.000000000 +0200
+++ new/gdth_kcompat.h	2006-05-02 16:02:00.000000000 +0200
@@ -1,5 +1,3 @@
-
-
 #ifndef IRQ_HANDLED
 typedef void irqreturn_t;
 #define IRQ_NONE
@@ -10,6 +8,18 @@
 #define MODULE_LICENSE(x)
 #endif
 
+#ifndef __iomem
+#define __iomem
+#endif
+
+#ifndef __attribute_used__
+#define __attribute_used__	__devinitdata
+#endif
+
+#ifndef __user
+#define __user
+#endif
+
 #ifndef SERVICE_ACTION_IN
 #define SERVICE_ACTION_IN	0x9e
 #endif
diff -u ./gdth_proc.c new/gdth_proc.c
--- ./gdth_proc.c	2006-05-03 11:53:32.000000000 +0200
+++ new/gdth_proc.c	2006-05-02 16:01:58.000000000 +0200
@@ -1,5 +1,5 @@
 /* gdth_proc.c 
- * $Id: gdth_proc.c,v 1.42 2004/03/05 15:50:20 achim Exp $
+ * $Id: gdth_proc.c,v 1.43 2006/01/11 16:15:00 achim Exp $
  */
 
 #include <linux/completion.h>
@@ -51,57 +51,26 @@
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          int hanum,int busnum)
 {
-    int             ret_val = -EINVAL;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Request    *scp;
-    struct scsi_device     *sdev;
-#else
-    Scsi_Cmnd       *scp;
-    struct scsi_device     *sdev;
-#endif
-    TRACE2(("gdth_set_info() ha %d bus %d\n",hanum,busnum));
+    int ret_val = -EINVAL;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    sdev = scsi_get_host_dev(host);
-    scp  = scsi_allocate_request(sdev, GFP_KERNEL);
-    if (!scp)
-        return -ENOMEM;
-    scp->sr_cmd_len = 12;
-    scp->sr_use_sg = 0;
-#else
-    sdev = scsi_get_host_dev(host);
-    scp  = scsi_allocate_device(sdev, 1, FALSE);
-    if (!scp)
-        return -ENOMEM;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-#endif
+    TRACE2(("gdth_set_info() ha %d bus %d\n",hanum,busnum));
 
     if (length >= 4) {
         if (strncmp(buffer,"gdth",4) == 0) {
             buffer += 5;
             length -= 5;
-            ret_val = gdth_set_asc_info( buffer, length, hanum, scp );
+            ret_val = gdth_set_asc_info(host, buffer, length, hanum);
         }
     }
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    scsi_release_request(scp);
-    scsi_free_host_dev(sdev);
-#else
-    scsi_release_command(scp);
-    scsi_free_host_dev(sdev);
-#endif
+
     return ret_val;
 }
          
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Request *scp)
-#else
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd *scp)
-#endif
+static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
+                        int length,int hanum)
 {
-    int             orig_length, drive, wb_mode;
-    int             i, found;
+    int orig_length, drive, wb_mode;
+    int i, found;
     gdth_ha_str     *ha;
     gdth_cmd_str    gdtcmd;
     gdth_cpar_str   *pcpar;
@@ -146,11 +115,8 @@
                     gdtcmd.u.cache.DeviceNo = i;
                     gdtcmd.u.cache.BlockNo = 1;
                 }
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-                gdth_do_req(scp, &gdtcmd, cmnd, 30);
-#else
-                gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
-#endif
+
+                gdth_execute(host, &gdtcmd, cmnd, 30, NULL);
             }
         }
         if (!found)
@@ -202,11 +168,9 @@
         gdtcmd.u.ioctl.subfunc = CACHE_CONFIG;
         gdtcmd.u.ioctl.channel = INVALID_CHANNEL;
         pcpar->write_back = wb_mode==1 ? 0:1;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(scp, &gdtcmd, cmnd, 30);
-#else
-        gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
-#endif
+
+        gdth_execute(host, &gdtcmd, cmnd, 30, NULL);
+
         gdth_ioctl_free(hanum, GDTH_SCRATCH, ha->pscratch, paddr);
         printk("Done.\n");
         return(orig_length);
@@ -230,13 +194,6 @@
 
     gdth_cmd_str *gdtcmd;
     gdth_evt_str *estr;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    Scsi_Request *scp;
-    struct scsi_device *sdev;
-#else
-    Scsi_Cmnd *scp;
-    struct scsi_device *sdev;
-#endif
     char hrec[161];
     struct timeval tv;
 
@@ -252,7 +209,7 @@
     gdtcmd = kmalloc(sizeof(*gdtcmd), GFP_KERNEL);
     estr = kmalloc(sizeof(*estr), GFP_KERNEL);
     if (!gdtcmd || !estr)
-	goto free_fail;
+        goto free_fail;
 
     memset(cmnd, 0xff, 12);
     memset(gdtcmd, 0, sizeof(gdth_cmd_str));
@@ -260,28 +217,6 @@
     TRACE2(("gdth_get_info() ha %d bus %d\n",hanum,busnum));
     ha = HADATA(gdth_ctr_tab[hanum]);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    sdev = scsi_get_host_dev(host);
-    scp  = scsi_allocate_request(sdev, GFP_KERNEL);
-    if (!scp)
-        goto free_fail;
-    scp->sr_cmd_len = 12;
-    scp->sr_use_sg = 0;
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-    sdev = scsi_get_host_dev(host);
-    scp  = scsi_allocate_device(sdev, 1, FALSE);
-    if (!scp)
-        goto free_fail;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-#else
-    memset(&sdev,0,sizeof(struct scsi_device));
-    memset(&scp, 0,sizeof(Scsi_Cmnd));
-    sdev.host = scp.host = host;
-    sdev.id = scp.target = sdev.host->this_id;
-    scp.device = &sdev;
-#endif
-    
     
     /* request is i.e. "cat /proc/scsi/gdth/0" */ 
     /* format: %-15s\t%-10s\t%-15s\t%s */
@@ -386,16 +321,9 @@
                 sizeof(pds->list[0]);
             if (pds->entries > cnt)
                 pds->entries = cnt;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(scp, gdtcmd, cmnd, 30);
-            if (scp->sr_command->SCp.Status != S_OK) 
-#else
-            gdth_do_cmd(scp, gdtcmd, cmnd, 30);
-            if (scp->SCp.Status != S_OK) 
-#endif
-            { 
+
+            if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) != S_OK)
                 pds->count = 0;
-            }
 
             /* other IOCTLs must fit into area GDTH_SCRATCH/4 */
             for (j = 0; j < ha->raw[i].pdev_cnt; ++j) {
@@ -410,14 +338,8 @@
                 gdtcmd->u.ioctl.subfunc = SCSI_DR_INFO | L_CTRL_PATTERN;
                 gdtcmd->u.ioctl.channel = 
                     ha->raw[i].address | ha->raw[i].id_list[j];
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-                gdth_do_req(scp, gdtcmd, cmnd, 30);
-                if (scp->sr_command->SCp.Status == S_OK) 
-#else
-                gdth_do_cmd(scp, gdtcmd, cmnd, 30);
-                if (scp->SCp.Status == S_OK) 
-#endif
-                {
+
+                if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
                     strncpy(hrec,pdi->vendor,8);
                     strncpy(hrec+8,pdi->product,16);
                     strncpy(hrec+24,pdi->revision,4);
@@ -466,14 +388,8 @@
                     gdtcmd->u.ioctl.channel = 
                         ha->raw[i].address | ha->raw[i].id_list[j];
                     pdef->sddc_type = 0x08;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-                    gdth_do_req(scp, gdtcmd, cmnd, 30);
-                    if (scp->sr_command->SCp.Status == S_OK) 
-#else
-                    gdth_do_cmd(scp, gdtcmd, cmnd, 30);
-                    if (scp->SCp.Status == S_OK) 
-#endif
-                    {
+
+                    if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
                         size = sprintf(buffer+len,
                                        " Grown Defects:\t%d\n",
                                        pdef->sddc_cnt);
@@ -519,16 +435,8 @@
                 gdtcmd->u.ioctl.param_size = sizeof(gdth_cdrinfo_str);
                 gdtcmd->u.ioctl.subfunc = CACHE_DRV_INFO;
                 gdtcmd->u.ioctl.channel = drv_no;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-                gdth_do_req(scp, gdtcmd, cmnd, 30);
-                if (scp->sr_command->SCp.Status != S_OK) 
-#else
-                gdth_do_cmd(scp, gdtcmd, cmnd, 30);
-                if (scp->SCp.Status != S_OK)
-#endif
-                {
+                if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) != S_OK)
                     break;
-                }
                 pcdi->ld_dtype >>= 16;
                 j++;
                 if (pcdi->ld_dtype > 2) {
@@ -629,14 +537,7 @@
             gdtcmd->u.ioctl.param_size = sizeof(gdth_arrayinf_str);
             gdtcmd->u.ioctl.subfunc = ARRAY_INFO | LA_CTRL_PATTERN;
             gdtcmd->u.ioctl.channel = i;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(scp, gdtcmd, cmnd, 30);
-            if (scp->sr_command->SCp.Status == S_OK) 
-#else
-            gdth_do_cmd(scp, gdtcmd, cmnd, 30);
-            if (scp->SCp.Status == S_OK) 
-#endif
-            {
+            if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
                 if (pai->ai_state == 0)
                     strcpy(hrec, "idle");
                 else if (pai->ai_state == 2)
@@ -710,14 +611,7 @@
             gdtcmd->u.ioctl.channel = i;
             phg->entries = MAX_HDRIVES;
             phg->offset = GDTOFFSOF(gdth_hget_str, entry[0]); 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(scp, gdtcmd, cmnd, 30);
-            if (scp->sr_command->SCp.Status != S_OK) 
-#else
-            gdth_do_cmd(scp, gdtcmd, cmnd, 30);
-            if (scp->SCp.Status != S_OK) 
-#endif
-            {
+            if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
                 ha->hdr[i].ldr_no = i;
                 ha->hdr[i].rw_attribs = 0;
                 ha->hdr[i].start_sec = 0;
@@ -791,13 +685,6 @@
     }
 
 stop_output:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    scsi_release_request(scp);
-    scsi_free_host_dev(sdev);
-#else
-    scsi_release_command(scp);
-    scsi_free_host_dev(sdev);
-#endif
     *start = buffer +(offset-begin);
     len -= (offset-begin);
     if (len > length)
@@ -812,64 +699,6 @@
     return rc;
 }
 
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static void gdth_do_req(Scsi_Request *scp, gdth_cmd_str *gdtcmd, 
-                        char *cmnd, int timeout)
-{
-    unsigned bufflen;
-    DECLARE_COMPLETION(wait);
-
-    TRACE2(("gdth_do_req()\n"));
-    if (gdtcmd != NULL) { 
-        bufflen = sizeof(gdth_cmd_str);
-    } else {
-        bufflen = 0;
-    }
-    scp->sr_request->rq_status = RQ_SCSI_BUSY;
-    scp->sr_request->waiting = &wait;
-    scsi_do_req(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-    wait_for_completion(&wait);
-}
-
-#else
-static void gdth_do_cmd(Scsi_Cmnd *scp, gdth_cmd_str *gdtcmd, 
-                        char *cmnd, int timeout)
-{
-    unsigned bufflen;
-    DECLARE_COMPLETION(wait);
-
-    TRACE2(("gdth_do_cmd()\n"));
-    if (gdtcmd != NULL) { 
-        scp->SCp.this_residual = IOCTL_PRI;
-        bufflen = sizeof(gdth_cmd_str);
-    } else {
-        scp->SCp.this_residual = DEFAULT_PRI;
-        bufflen = 0;
-    }
-
-    scp->request.rq_status = RQ_SCSI_BUSY;
-    scp->request.waiting = &wait;
-    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-    wait_for_completion(&wait);
-}
-#endif
-
-void gdth_scsi_done(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_scsi_done()\n"));
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    scp->request->rq_status = RQ_SCSI_DONE;
-    if (scp->request->waiting != NULL)
-        complete(scp->request->waiting);
-#else
-    scp->request.rq_status = RQ_SCSI_DONE;
-    if (scp->request.waiting != NULL)
-        complete(scp->request.waiting);
-#endif
-}
-
 static char *gdth_ioctl_alloc(int hanum, int size, int scratch, 
                               ulong64 *paddr)
 {
@@ -976,11 +805,14 @@
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-        t = scp->device->id;
-        if (t == (unchar)id && b == (unchar)busnum) {
-            TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
-            scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+        if (scp->done != gdth_scsi_done) {
+            b = virt_ctr ? 
+                NUMDATA(scp->device->host)->busnum : scp->device->channel;
+            t = scp->device->id;
+            if (t == (unchar)id && b == (unchar)busnum) {
+                TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
+                scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+            }
         }
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -997,11 +829,14 @@
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-        t = scp->device->id;
-        if (t == (unchar)id && b == (unchar)busnum) {
-            TRACE2(("gdth_start_timeout(): update_timeout()\n"));
-            gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
+        if (scp->done != gdth_scsi_done) {
+            b = virt_ctr ? 
+                NUMDATA(scp->device->host)->busnum : scp->device->channel;
+            t = scp->device->id;
+            if (t == (unchar)id && b == (unchar)busnum) {
+                TRACE2(("gdth_start_timeout(): update_timeout()\n"));
+                gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
+            }
         }
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
diff -u ./gdth_proc.h new/gdth_proc.h
--- ./gdth_proc.h	2006-05-03 11:53:32.000000000 +0200
+++ new/gdth_proc.h	2006-05-02 16:02:00.000000000 +0200
@@ -5,20 +5,16 @@
  * $Id: gdth_proc.h,v 1.16 2004/01/14 13:09:01 achim Exp $
  */
 
+int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
+                 int timeout, u32 *info);
+
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          int hanum,int busnum);
 static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                          struct Scsi_Host *host,int hanum,int busnum);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static void gdth_do_req(Scsi_Request *srp, gdth_cmd_str *cmd, 
-                        char *cmnd, int timeout);
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Request *scp);
-#else
-static void gdth_do_cmd(Scsi_Cmnd *scp, gdth_cmd_str *cmd, 
-                        char *cmnd, int timeout);
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd *scp);
-#endif
+static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
+                             int length, int hanum);
 
 static char *gdth_ioctl_alloc(int hanum, int size, int scratch,
                               ulong64 *paddr);  
@@ -28,7 +24,5 @@
 static void gdth_start_timeout(int hanum, int busnum, int id);
 static int gdth_update_timeout(int hanum, Scsi_Cmnd *scp, int timeout);
 
-void gdth_scsi_done(Scsi_Cmnd *scp);
-
 #endif
 
