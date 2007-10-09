From: Dave Jones <davej@redhat.com>
Subject: [GDTH] Remove pre 2.6 ifdefs
Date: Tue, 9 Oct 2007 16:43:14 -0400
Message-ID: <20071009204314.GA26942@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbXJIUnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2007 16:43:16 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l99KhGgM003305
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 16:43:16 -0400
Received: from gelk.kernelslacker.org (vpn-14-33.rdu.redhat.com [10.11.14.33])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l99KhFbt010730
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 16:43:15 -0400
Received: from gelk.kernelslacker.org (localhost.localdomain [127.0.0.1])
	by gelk.kernelslacker.org (8.14.1/8.13.8) with ESMTP id l99KhFrm027132
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 16:43:15 -0400
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.1/8.14.1/Submit) id l99KhFje027131
	for linux-scsi@vger.kernel.org; Tue, 9 Oct 2007 16:43:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 55e4d2d..bfba877 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -392,12 +392,7 @@
 #include <linux/proc_fs.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
 #include <linux/dma-mapping.h>
-#else
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#endif
 
 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>
@@ -409,12 +404,7 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/spinlock.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <linux/blkdev.h>
-#else
-#include <linux/blk.h>
-#include "sd.h"
-#endif
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -655,7 +645,6 @@ static int probe_eisa_isa = 0;
 static int force_dma32 = 0;
 
 /* parameters for modprobe/insmod */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,11)
 module_param_array(irq, int, NULL, 0);
 module_param(disable, int, 0);
 module_param(reserve_mode, int, 0);
@@ -668,20 +657,7 @@ module_param(virt_ctr, int, 0);
 module_param(shared_access, int, 0);
 module_param(probe_eisa_isa, int, 0);
 module_param(force_dma32, int, 0);
-#else
-MODULE_PARM(irq, "i");
-MODULE_PARM(disable, "i");
-MODULE_PARM(reserve_mode, "i");
-MODULE_PARM(reserve_list, "4-" __MODULE_STRING(MAX_RES_ARGS) "i");
-MODULE_PARM(reverse_scan, "i");
-MODULE_PARM(hdr_channel, "i");
-MODULE_PARM(max_ids, "i");
-MODULE_PARM(rescan, "i");
-MODULE_PARM(virt_ctr, "i");
-MODULE_PARM(shared_access, "i");
-MODULE_PARM(probe_eisa_isa, "i");
-MODULE_PARM(force_dma32, "i");
-#endif
+
 MODULE_AUTHOR("Achim Leubner");
 MODULE_LICENSE("GPL");
 
@@ -710,7 +686,6 @@ static void gdth_delay(int milliseconds)
     }
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static void gdth_scsi_done(struct scsi_cmnd *scp)
 {
     TRACE2(("gdth_scsi_done()\n"));
@@ -748,42 +723,6 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     kfree(scp);
     return rval;
 }
-#else
-static void gdth_scsi_done(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_scsi_done()\n"));
-
-    scp->request.rq_status = RQ_SCSI_DONE;
-    if (scp->request.waiting)
-        complete(scp->request.waiting);
-}
-
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
-                   int timeout, u32 *info)
-{
-    Scsi_Cmnd *scp = scsi_allocate_device(sdev, 1, FALSE);
-    unsigned bufflen = gdtcmd ? sizeof(gdth_cmd_str) : 0;
-    DECLARE_COMPLETION_ONSTACK(wait);
-    int rval;
-
-    if (!scp)
-        return -ENOMEM;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-    scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->request.rq_status = RQ_SCSI_BUSY;
-    scp->request.waiting = &wait;
-    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-    wait_for_completion(&wait);
-
-    rval = scp->SCp.Status;
-    if (info)
-        *info = scp->SCp.Message;
-
-    scsi_release_command(scp);
-    return rval;
-}
-#endif
 
 int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
                  int timeout, u32 *info)
@@ -2243,29 +2182,17 @@ static int __init gdth_search_drives(int hanum)
         printk("GDT-HA %d: Vendor: %s Name: %s\n",
                hanum,oemstr->text.oem_company_name,ha->binfo.type_string);
         /* Save the Host Drive inquiry data */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         strlcpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,
                 sizeof(ha->oem_name));
-#else
-        strncpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,7);
-        ha->oem_name[7] = '\0';
-#endif
     } else {
         /* Old method, based on PCI ID */
         TRACE2(("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD failed\n"));
         printk("GDT-HA %d: Name: %s\n",
                hanum,ha->binfo.type_string);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         if (ha->oem_id == OEM_ID_INTEL)
             strlcpy(ha->oem_name,"Intel  ", sizeof(ha->oem_name));
         else
             strlcpy(ha->oem_name,"ICP    ", sizeof(ha->oem_name));
-#else 
-        if (ha->oem_id == OEM_ID_INTEL)
-            strcpy(ha->oem_name,"Intel  ");
-        else
-            strcpy(ha->oem_name,"ICP    ");
-#endif
     }
 
     /* scanning for host drives */
@@ -2674,17 +2601,10 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
                 return;
             }
             local_irq_save(flags);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
             memcpy(address,buffer,cpnow);
             flush_dcache_page(sl->page);
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
-#else
-            address = kmap_atomic(sl->page, KM_BH_IRQ) + sl->offset;
-            memcpy(address,buffer,cpnow);
-            flush_dcache_page(sl->page);
-            kunmap_atomic(address, KM_BH_IRQ);
-#endif
             local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
@@ -4277,11 +4197,7 @@ int __init option_setup(char *str)
     return 1;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int __init gdth_detect(struct scsi_host_template *shtp)
-#else
-static int __init gdth_detect(Scsi_Host_Template *shtp)
-#endif
 {
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
@@ -4421,10 +4337,6 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
                     hdr_channel = ha->bus_cnt;
                 ha->virt_bus = hdr_channel;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
-    LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-                shp->highmem_io  = 0;
-#endif
                 if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
                     shp->max_cmd_len = 16;
 
@@ -4545,10 +4457,6 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
                     hdr_channel = ha->bus_cnt;
                 ha->virt_bus = hdr_channel;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && \
-    LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-                shp->highmem_io  = 0;
-#endif
                 if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) 
                     shp->max_cmd_len = 16;
 
@@ -4649,10 +4557,6 @@ static int __init gdth_detect(Scsi_Host_Template *shtp)
                 hdr_channel = ha->bus_cnt;
             ha->virt_bus = hdr_channel;
 
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-            scsi_set_pci_device(shp, pcistr[ctr].pdev);
-#endif
             if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &GDT_64BIT)||
                 /* 64-bit DMA only supported from FW >= x.43 */
                 (!ha->dma64_support)) {
@@ -4884,11 +4788,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
     return SUCCESS;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
-#else
-static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
-#endif
 {
     unchar b, t;
     int hanum;
@@ -4896,13 +4796,8 @@ static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
     struct scsi_device *sd;
     unsigned capacity;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     sd = sdev;
     capacity = cap;
-#else
-    sd = disk->device;
-    capacity = disk->capacity;
-#endif
     hanum = NUMDATA(sd->host)->hanum;
     b = virt_ctr ? NUMDATA(sd->host)->busnum : sd->channel;
     t = sd->id;
@@ -5517,7 +5412,6 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         hanum = res.ionode; 
         ha = HADATA(gdth_ctr_tab[hanum]);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         scp  = kmalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
             return -ENOMEM;
@@ -5529,17 +5423,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
         kfree(scp);
-#else
-        scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
-        if (!scp)
-            return -ENOMEM;
-        scp->cmd_len = 12;
-        scp->use_sg = 0;
-        scp->channel = virt_ctr ? 0 : res.number;
-        rval = gdth_eh_bus_reset(scp);
-        res.status = (rval == SUCCESS ? S_OK : S_GENERR);
-        scsi_release_command(scp);
-#endif
+
         if (copy_to_user(argp, &res, sizeof(gdth_ioctl_reset)))
             return -EFAULT;
         break;
@@ -5627,7 +5511,6 @@ static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
     return NOTIFY_OK;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /* configure lun */
 static int gdth_slave_configure(struct scsi_device *sdev)
 {
@@ -5636,13 +5519,8 @@ static int gdth_slave_configure(struct scsi_device *sdev)
     sdev->skip_ms_page_8 = 1;
     return 0;
 }
-#endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static struct scsi_host_template driver_template = {
-#else
-static Scsi_Host_Template driver_template = {
-#endif
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
@@ -5653,20 +5531,12 @@ static Scsi_Host_Template driver_template = {
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
         .bios_param             = gdth_bios_param,
         .can_queue              = GDTH_MAXCMDS,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         .slave_configure        = gdth_slave_configure,
-#endif
         .this_id                = -1,
         .sg_tablesize           = GDTH_MAXSG,
         .cmd_per_lun            = GDTH_MAXC_P_L,
         .unchecked_isa_dma      = 1,
         .use_clustering         = ENABLE_CLUSTERING,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-        .use_new_eh_code        = 1,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20)
-        .highmem_io             = 1,
-#endif
-#endif
 };
 
 #include "scsi_module.c"

-- 
http://www.codemonkey.org.uk
