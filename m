From: Dave Olien <dmo@osdl.org>
Subject: [PATCH] 2.5.67 scsi/gdth.c compile warnings and stack usage
Date: Fri, 18 Apr 2003 14:08:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030418210851.GA12036@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:59047 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263241AbTDRU4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2003 16:56:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: achim.leubner@intel.com, joern@wohnheim.fh-wedel.de, boji.t.kannanthanam@intel.com, Randy Dunlap <rddunlap@osdl.org>


There are two components to this patch.  The first component fixes
with compilation warnings (which did uncover real bugs).  The other component 
(by Randy Dunlap) reduces stack size usage in gdth_ioctl().

The compilation warnings occur only when CONFIG_HIGHMEM=y in the kernel
configuration file (enable either 4gig or 64gig memory support).  This
changes the size of the dma_addr_t from u32 to u64.
The calls to pci_alloc_consistent return a value of type dma_addr_t.
But the code was casting a pointer to what was ony a 32-bit memory location.

This also reduces stack size in scsi/gdth.c::gdth_ioctl() by making
each separate ioctl have its own handler function, so that several
large data structs are all declared on the stack at the same time.

patch_name:     gdth-stack_warnings.patch
patch_version:  2003-04-14.16:31:30
author:         Randy.Dunlap <rddunlap@osdl.org>, Dave.Olien<dmo@osdl.org)
description:    reduce stack usage in drivers/scsi/gdth.c::gdth_ioctl()
                from 0xb50 to 0x5c (on P4, gcc 2.96); the large (ioctl)
                function sizes in gdth.o now are:
                        150 ioc_event
                        178 ioc_resetdrv
                        190 ioc_general
                        30c ioc_hdrlist
                        324 ioc_rescan
                so the largest cumulative size of calling gdth_ioctl() +
                a specific ioctl is 0x5c + 0x324 = 0x380.
		Fix compilation warnings in calls to pci_alloc_consistent()
		that occur only when CONFIG_HIGHMEM=y.  The compiler
		warnings result from dma_addr_t changing in size from u32
		to u64.
product:        Linux
product_versions: 2.5.67
changelog:      make each ioctl that uses large stack space into its own
                function;
                mostly moving lines of code around;
                duplicates some local data in multiple functions;
		fix compiler warnings by adding intermediate dma_addr_t local
		variables to hold returns from pci_alloc_consistent.
maintainer:     Achim Leubner (achim.leubner@intel.com)
diffstat:	=
 drivers/scsi/gdth.c      |  664 ++++++++++++++++++++++++++---------------------
 drivers/scsi/gdth_proc.c |    5 
 2 files changed, 374 insertions(+), 295 deletions(-)

FYI:  The killer data structs in gdth_ioctl() (on x86, P4, gcc 2.96) are:
                sizeof gdth_cmd_str: 336 bytes
                sizeof gdth_ioctl_general: 356 bytes
                sizeof gdth_ioctl_event: 308 bytes
                sizeof gdth_ioctl_lockdrv: 204 bytes
                sizeof gdth_ioctl_rescan: 406 bytes

###

diff -ur linux-2.5.67_original/drivers/scsi/gdth.c linux-2.5.67_gdth/drivers/scsi/gdth.c
--- linux-2.5.67_original/drivers/scsi/gdth.c	2003-04-07 10:31:51.000000000 -0700
+++ linux-2.5.67_gdth/drivers/scsi/gdth.c	2003-04-18 12:56:05.000000000 -0700
@@ -3672,9 +3672,9 @@
         else if (scp->SCp.Status == GDTH_MAP_SINGLE) 
             pci_unmap_single(ha->pdev,scp->SCp.dma_handle,
                          scp->request_bufflen,scp->SCp.Message);
-        if (scp->SCp.buffer)
-            pci_unmap_single(ha->pdev,(dma_addr_t)scp->SCp.buffer,
-                             16,PCI_DMA_FROMDEVICE);
+        if (scp->SCp.buffer) 
+            pci_unmap_single(ha->pdev,(dma_addr_t)(u32)scp->SCp.buffer,
+						16,PCI_DMA_FROMDEVICE);
 #endif
         if (ha->status == S_OK) {
             scp->SCp.Status = S_OK;
@@ -4226,6 +4226,9 @@
 
     /* scanning for controllers, at first: ISA controller */
     for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
+
+	dma_addr_t scratch_dma_handle;
+
         if (gdth_ctr_count >= MAXHA) 
             break;
         if (gdth_search_isa(isa_bios)) {        /* controller found */
@@ -4282,7 +4285,8 @@
 #if LINUX_VERSION_CODE >= 0x020400
             ha->pdev = NULL;
             ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
-                                                &ha->scratch_phys); 
+						&scratch_dma_handle);
+            ha->scratch_phys = (ulong32)scratch_dma_handle;
 #else
             ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
             if (ha->pscratch)
@@ -4349,6 +4353,9 @@
 
     /* scanning for EISA controllers */
     for (eisa_slot=0x1000; eisa_slot<=0x8000; eisa_slot+=0x1000) {
+
+	dma_addr_t scratch_dma_handle;
+
         if (gdth_ctr_count >= MAXHA) 
             break;
         if (gdth_search_eisa(eisa_slot)) {      /* controller found */
@@ -4392,7 +4399,8 @@
 #if LINUX_VERSION_CODE >= 0x020400
             ha->pdev = NULL;
             ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
-                                                &ha->scratch_phys); 
+						&scratch_dma_handle);
+            ha->scratch_phys = (ulong32) scratch_dma_handle;
             ha->ccb_phys = 
                 pci_map_single(ha->pdev,ha->pccb,
                                sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
@@ -4475,6 +4483,9 @@
         printk("GDT: Found %d PCI Storage RAID Controllers\n",cnt);
         gdth_sort_pci(pcistr,cnt);
         for (ctr = 0; ctr < cnt; ++ctr) {
+
+	    dma_addr_t scratch_dma_handle;
+
             if (gdth_ctr_count >= MAXHA)
                 break;
             shp = scsi_register(shtp,sizeof(gdth_ext_str));
@@ -4516,7 +4527,8 @@
             ha->ccb_phys = 0L;
 #if LINUX_VERSION_CODE >= 0x020400
             ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
-                                                &ha->scratch_phys); 
+						&scratch_dma_handle);
+            ha->scratch_phys = (ulong32)scratch_dma_handle;
 #else
             ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
             if (ha->pscratch)
@@ -4892,90 +4904,156 @@
     return 0;
 }
 
-static int gdth_ioctl(struct inode *inode, struct file *filep,
-                      unsigned int cmd, unsigned long arg)
+static int ioc_event(unsigned long arg)
 {
-    gdth_ha_str *ha; 
-#if LINUX_VERSION_CODE >= 0x020503
-    Scsi_Request *srp;
-    Scsi_Cmnd *scp;
-    Scsi_Device *sdev;
-#elif LINUX_VERSION_CODE >= 0x020322
-    Scsi_Cmnd *scp;
-    Scsi_Device *sdev;
-#else
-    Scsi_Cmnd scp;
-    Scsi_Device sdev;
-#endif
-    ulong flags;
-    char cmnd[MAX_COMMAND_SIZE];   
-    memset(cmnd, 0xff, 12);
-    
-    TRACE(("gdth_ioctl() cmd 0x%x\n", cmd));
- 
-    switch (cmd) {
-      case GDTIOCTL_CTRCNT:
-      { 
-        int cnt = gdth_ctr_count;
-        put_user(cnt, (int *)arg);
-        break;
-      }
+        gdth_ioctl_event evt;
+        gdth_ha_str *ha;
+        ulong flags;
 
-      case GDTIOCTL_DRVERS:
-      { 
-        int ver = (GDTH_VERSION<<8) | GDTH_SUBVERSION;
-        put_user(ver, (int *)arg);
-        break;
-      }
-      
-      case GDTIOCTL_OSVERS:
-      { 
-        gdth_ioctl_osvers osv; 
+        if (copy_from_user(&evt, (char *)arg, sizeof(gdth_ioctl_event)) ||
+            evt.ionode >= gdth_ctr_count)
+            return -EFAULT;
+        ha = HADATA(gdth_ctr_tab[evt.ionode]);
 
-        osv.version = (unchar)(LINUX_VERSION_CODE >> 16);
-        osv.subversion = (unchar)(LINUX_VERSION_CODE >> 8);
-        osv.revision = (ushort)(LINUX_VERSION_CODE & 0xff);
-        copy_to_user((char *)arg, &osv, sizeof(gdth_ioctl_osvers));
-        break;
-      }
+        if (evt.erase == 0xff) {
+            if (evt.event.event_source == ES_TEST)
+                evt.event.event_data.size=sizeof(evt.event.event_data.eu.test); 
+            else if (evt.event.event_source == ES_DRIVER)
+                evt.event.event_data.size=sizeof(evt.event.event_data.eu.driver); 
+            else if (evt.event.event_source == ES_SYNC)
+                evt.event.event_data.size=sizeof(evt.event.event_data.eu.sync); 
+            else
+                evt.event.event_data.size=sizeof(evt.event.event_data.eu.async);
+            GDTH_LOCK_HA(ha, flags);
+            gdth_store_event(ha, evt.event.event_source, evt.event.event_idx,
+                             &evt.event.event_data);
+            GDTH_UNLOCK_HA(ha, flags);
+        } else if (evt.erase == 0xfe) {
+            gdth_clear_events();
+        } else if (evt.erase == 0) {
+            evt.handle = gdth_read_event(ha, evt.handle, &evt.event);
+        } else {
+            gdth_readapp_event(ha, evt.erase, &evt.event);
+        }     
+        if (copy_to_user((char *)arg, &evt, sizeof(gdth_ioctl_event)))
+            return -EFAULT;
+        return 0;
+}
 
-      case GDTIOCTL_CTRTYPE:
-      { 
-        gdth_ioctl_ctrtype ctrt;
-        
-        if (copy_from_user(&ctrt, (char *)arg, sizeof(gdth_ioctl_ctrtype)) ||
-            ctrt.ionode >= gdth_ctr_count)
+static int ioc_lockdrv(unsigned long arg)
+{
+        gdth_ioctl_lockdrv ldrv;
+        unchar i, j;
+        ulong flags;
+        gdth_ha_str *ha;
+
+        if (copy_from_user(&ldrv, (char *)arg, sizeof(gdth_ioctl_lockdrv)) ||
+            ldrv.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[ctrt.ionode]);
-        if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
-            ctrt.type = (unchar)((ha->stype>>20) - 0x10);
-        } else {
-            if (ha->type != GDT_PCIMPR) {
-                ctrt.type = (unchar)((ha->stype<<4) + 6);
+        ha = HADATA(gdth_ctr_tab[ldrv.ionode]);
+ 
+        for (i = 0; i < ldrv.drive_cnt && i < MAX_HDRIVES; ++i) {
+            j = ldrv.drives[i];
+            if (j >= MAX_HDRIVES || !ha->hdr[j].present)
+                continue;
+            if (ldrv.lock) {
+                GDTH_LOCK_HA(ha, flags);
+                ha->hdr[j].lock = 1;
+                GDTH_UNLOCK_HA(ha, flags);
+                gdth_wait_completion(ldrv.ionode, ha->bus_cnt, j); 
+                gdth_stop_timeout(ldrv.ionode, ha->bus_cnt, j); 
             } else {
-                ctrt.type = 
-                    (ha->oem_id == OEM_ID_INTEL ? 0xfd : 0xfe);
-                if (ha->stype >= 0x300)
-                    ctrt.ext_type = 0x6000 | ha->subdevice_id;
-                else 
-                    ctrt.ext_type = 0x6000 | ha->stype;
+                GDTH_LOCK_HA(ha, flags);
+                ha->hdr[j].lock = 0;
+                GDTH_UNLOCK_HA(ha, flags);
+                gdth_start_timeout(ldrv.ionode, ha->bus_cnt, j); 
+                gdth_next(ldrv.ionode); 
             }
-            ctrt.device_id = ha->stype;
-            ctrt.sub_device_id = ha->subdevice_id;
-        }
-        ctrt.info = ha->brd_phys;
-        ctrt.oem_id = ha->oem_id;
-        if (copy_to_user((char *)arg, &ctrt, sizeof(gdth_ioctl_ctrtype)))
+        } 
+        return 0;
+}
+
+static int ioc_resetdrv(unsigned long arg, char *cmnd)
+{
+        gdth_ioctl_reset res;
+        gdth_cmd_str cmd;
+        int hanum;
+        gdth_ha_str *ha;
+#if LINUX_VERSION_CODE >= 0x020503
+	Scsi_Request *srp;
+	Scsi_Device *sdev;
+#elif LINUX_VERSION_CODE >= 0x020322
+	Scsi_Cmnd *scp;
+	Scsi_Device *sdev;
+#else
+	Scsi_Cmnd scp;
+	Scsi_Device sdev;
+#endif
+
+        if (copy_from_user(&res, (char *)arg, sizeof(gdth_ioctl_reset)) ||
+            res.ionode >= gdth_ctr_count || res.number >= MAX_HDRIVES)
             return -EFAULT;
-        break;
-      }
-        
-      case GDTIOCTL_GENERAL:
-      {
+        hanum = res.ionode;
+        ha = HADATA(gdth_ctr_tab[hanum]);
+ 
+        if (!ha->hdr[res.number].present)
+            return 0;
+        cmd.Service = CACHESERVICE;
+        cmd.OpCode = GDT_CLUST_RESET;
+        cmd.u.cache.DeviceNo = res.number;
+#if LINUX_VERSION_CODE >= 0x020503
+        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
+        srp  = scsi_allocate_request(sdev);
+        if (!srp)
+            return -ENOMEM;
+        srp->sr_cmd_len = 12;
+        srp->sr_use_sg = 0;
+        gdth_do_req(srp, &cmd, cmnd, 30);
+        res.status = (ushort)srp->sr_command->SCp.Status;
+        scsi_release_request(srp);
+        scsi_free_host_dev(sdev);
+#elif LINUX_VERSION_CODE >= 0x020322
+        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
+        scp  = scsi_allocate_device(sdev, 1, FALSE);
+        if (!scp)
+            return -ENOMEM;
+        scp->cmd_len = 12;
+        scp->use_sg = 0;
+        gdth_do_cmd(scp, &cmd, cmnd, 30);
+        res.status = (ushort)scp->SCp.Status;
+        scsi_release_command(scp);
+        scsi_free_host_dev(sdev);
+#else
+        memset(&sdev,0,sizeof(Scsi_Device));
+        memset(&scp, 0,sizeof(Scsi_Cmnd));
+        sdev.host = scp.host = gdth_ctr_tab[hanum];
+        sdev.id = scp.target = sdev.host->this_id;
+        scp.device = &sdev;
+        gdth_do_cmd(&scp, &cmd, cmnd, 30);
+        res.status = (ushort)scp.SCp.Status;
+#endif
+        if (copy_to_user((char *)arg, &res, sizeof(gdth_ioctl_reset)))
+            return -EFAULT;
+        return 0;
+}
+
+static int ioc_general(unsigned long arg, char *cmnd)
+{
         gdth_ioctl_general gen;
         char *buf = NULL;
         ulong32 paddr; 
         int hanum;
+	gdth_ha_str *ha; 
+#if LINUX_VERSION_CODE >= 0x020503
+	Scsi_Request *srp;
+	Scsi_Device *sdev;
+#elif LINUX_VERSION_CODE >= 0x020322
+	Scsi_Cmnd *scp;
+	Scsi_Device *sdev;
+#else
+	Scsi_Cmnd scp;
+	Scsi_Device sdev;
+#endif
         
         if (copy_from_user(&gen, (char *)arg, sizeof(gdth_ioctl_general)) ||
             gen.ionode >= gdth_ctr_count)
@@ -5070,116 +5148,115 @@
             return -EFAULT;
         }
         gdth_ioctl_free(hanum, gen.data_len+gen.sense_len, buf, paddr);
-        break;
-      }
+        return 0;
+}
  
-      case GDTIOCTL_EVENT:
-      {
-        gdth_ioctl_event evt;
+static int ioc_hdrlist(unsigned long arg, char *cmnd)
+{
+        gdth_ioctl_rescan rsc;
+        gdth_cmd_str cmd;
         gdth_ha_str *ha;
-        ulong flags;
-
-        if (copy_from_user(&evt, (char *)arg, sizeof(gdth_ioctl_event)) ||
-            evt.ionode >= gdth_ctr_count)
+        unchar i;
+        int hanum;
+#if LINUX_VERSION_CODE >= 0x020503
+	Scsi_Request *srp;
+	Scsi_Device *sdev;
+#elif LINUX_VERSION_CODE >= 0x020322
+	Scsi_Cmnd *scp;
+	Scsi_Device *sdev;
+#else
+	Scsi_Cmnd scp;
+	Scsi_Device sdev;
+#endif
+        
+        if (copy_from_user(&rsc, (char *)arg, sizeof(gdth_ioctl_rescan)) ||
+            rsc.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[evt.ionode]);
+        hanum = rsc.ionode;
+        ha = HADATA(gdth_ctr_tab[hanum]);
+   
+#if LINUX_VERSION_CODE >= 0x020503
+        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
+        srp  = scsi_allocate_request(sdev);
+        if (!srp)
+            return -ENOMEM;
+        srp->sr_cmd_len = 12;
+        srp->sr_use_sg = 0;
+#elif LINUX_VERSION_CODE >= 0x020322
+        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
+        scp  = scsi_allocate_device(sdev, 1, FALSE);
+        if (!scp)
+            return -ENOMEM;
+        scp->cmd_len = 12;
+        scp->use_sg = 0;
+#else
+        memset(&sdev,0,sizeof(Scsi_Device));
+        memset(&scp, 0,sizeof(Scsi_Cmnd));
+        sdev.host = scp.host = gdth_ctr_tab[hanum];
+        sdev.id = scp.target = sdev.host->this_id;
+        scp.device = &sdev;
+#endif
 
-        if (evt.erase == 0xff) {
-            if (evt.event.event_source == ES_TEST)
-                evt.event.event_data.size=sizeof(evt.event.event_data.eu.test); 
-            else if (evt.event.event_source == ES_DRIVER)
-                evt.event.event_data.size=sizeof(evt.event.event_data.eu.driver); 
-            else if (evt.event.event_source == ES_SYNC)
-                evt.event.event_data.size=sizeof(evt.event.event_data.eu.sync); 
-            else
-                evt.event.event_data.size=sizeof(evt.event.event_data.eu.async);
-            GDTH_LOCK_HA(ha, flags);
-            gdth_store_event(ha, evt.event.event_source, evt.event.event_idx,
-                             &evt.event.event_data);
-            GDTH_UNLOCK_HA(ha, flags);
-        } else if (evt.erase == 0xfe) {
-            gdth_clear_events();
-        } else if (evt.erase == 0) {
-            evt.handle = gdth_read_event(ha, evt.handle, &evt.event);
-        } else {
-            gdth_readapp_event(ha, evt.erase, &evt.event);
-        }     
-        if (copy_to_user((char *)arg, &evt, sizeof(gdth_ioctl_event)))
-            return -EFAULT;
-        break;
-      }
-
-      case GDTIOCTL_LOCKDRV:
-      {
-        gdth_ioctl_lockdrv ldrv;
-        unchar i, j;
-
-        if (copy_from_user(&ldrv, (char *)arg, sizeof(gdth_ioctl_lockdrv)) ||
-            ldrv.ionode >= gdth_ctr_count)
-            return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[ldrv.ionode]);
- 
-        for (i = 0; i < ldrv.drive_cnt && i < MAX_HDRIVES; ++i) {
-            j = ldrv.drives[i];
-            if (j >= MAX_HDRIVES || !ha->hdr[j].present)
+        for (i = 0; i < MAX_HDRIVES; ++i) { 
+            if (!ha->hdr[i].present) {
+                rsc.hdr_list[i].bus = 0xff; 
                 continue;
-            if (ldrv.lock) {
-                GDTH_LOCK_HA(ha, flags);
-                ha->hdr[j].lock = 1;
-                GDTH_UNLOCK_HA(ha, flags);
-                gdth_wait_completion(ldrv.ionode, ha->bus_cnt, j); 
-                gdth_stop_timeout(ldrv.ionode, ha->bus_cnt, j); 
-            } else {
-                GDTH_LOCK_HA(ha, flags);
-                ha->hdr[j].lock = 0;
-                GDTH_UNLOCK_HA(ha, flags);
-                gdth_start_timeout(ldrv.ionode, ha->bus_cnt, j); 
-                gdth_next(ldrv.ionode); 
+            } 
+            rsc.hdr_list[i].bus = ha->virt_bus;
+            rsc.hdr_list[i].target = i;
+            rsc.hdr_list[i].lun = 0;
+            rsc.hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
+            if (ha->hdr[i].cluster_type & CLUSTER_DRIVE) { 
+                cmd.Service = CACHESERVICE;
+                cmd.OpCode = GDT_CLUST_INFO;
+                cmd.u.cache.DeviceNo = i;
+#if LINUX_VERSION_CODE >= 0x020503
+                gdth_do_req(srp, &cmd, cmnd, 30);
+                if (srp->sr_command->SCp.Status == S_OK)
+                    rsc.hdr_list[i].cluster_type = srp->sr_command->SCp.Message;
+#elif LINUX_VERSION_CODE >= 0x020322
+                gdth_do_cmd(scp, &cmd, cmnd, 30);
+                if (scp->SCp.Status == S_OK)
+                    rsc.hdr_list[i].cluster_type = scp->SCp.Message;
+#else
+                gdth_do_cmd(&scp, &cmd, cmnd, 30);
+                if (scp.SCp.Status == S_OK)
+                    rsc.hdr_list[i].cluster_type = scp.SCp.Message;
+#endif
             }
         } 
-        break;
-      }
-
-      case GDTIOCTL_LOCKCHN:
-      {
-        gdth_ioctl_lockchn lchn;
-        unchar i, j;
-
-        if (copy_from_user(&lchn, (char *)arg, sizeof(gdth_ioctl_lockchn)) ||
-            lchn.ionode >= gdth_ctr_count)
+#if LINUX_VERSION_CODE >= 0x020503
+        scsi_release_request(srp);
+        scsi_free_host_dev(sdev);
+#elif LINUX_VERSION_CODE >= 0x020322
+        scsi_release_command(scp);
+        scsi_free_host_dev(sdev);
+#endif       
+ 
+        if (copy_to_user((char *)arg, &rsc, sizeof(gdth_ioctl_rescan)))
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[lchn.ionode]);
-        
-        i = lchn.channel;
-        if (i < ha->bus_cnt) {
-            if (lchn.lock) {
-                GDTH_LOCK_HA(ha, flags);
-                ha->raw[i].lock = 1;
-                GDTH_UNLOCK_HA(ha, flags);
-                for (j = 0; j < ha->tid_cnt; ++j) {
-                    gdth_wait_completion(lchn.ionode, i, j); 
-                    gdth_stop_timeout(lchn.ionode, i, j); 
-                }
-            } else {
-                GDTH_LOCK_HA(ha, flags);
-                ha->raw[i].lock = 0;
-                GDTH_UNLOCK_HA(ha, flags);
-                for (j = 0; j < ha->tid_cnt; ++j) {
-                    gdth_start_timeout(lchn.ionode, i, j); 
-                    gdth_next(lchn.ionode); 
-                }
-            }
-        } 
-        break;
-      }
+        return 0;
+}
 
-      case GDTIOCTL_RESCAN:
-      {
+static int ioc_rescan(unsigned long arg, char *cmnd)
+{
         gdth_ioctl_rescan rsc;
         gdth_cmd_str cmd;
         ushort i, status, hdr_cnt;
         ulong32 info;
         int hanum, cyls, hds, secs;
+	ulong flags;
+	gdth_ha_str *ha; 
+#if LINUX_VERSION_CODE >= 0x020503
+	Scsi_Request *srp;
+	Scsi_Device *sdev;
+#elif LINUX_VERSION_CODE >= 0x020322
+	Scsi_Cmnd *scp;
+	Scsi_Device *sdev;
+#else
+	Scsi_Cmnd scp;
+	Scsi_Device sdev;
+#endif
         
         if (copy_from_user(&rsc, (char *)arg, sizeof(gdth_ioctl_rescan)) ||
             rsc.ionode >= gdth_ctr_count)
@@ -5344,85 +5421,134 @@
  
         if (copy_to_user((char *)arg, &rsc, sizeof(gdth_ioctl_rescan)))
             return -EFAULT;
-        break;
-      }
+        return 0;
+}
   
-      case GDTIOCTL_HDRLIST:
-      {
-        gdth_ioctl_rescan rsc;
-        gdth_cmd_str cmd;
-        gdth_ha_str *ha;
-        unchar i;
-        int hanum;
-        
-        if (copy_from_user(&rsc, (char *)arg, sizeof(gdth_ioctl_rescan)) ||
-            rsc.ionode >= gdth_ctr_count)
-            return -EFAULT;
-        hanum = rsc.ionode;
-        ha = HADATA(gdth_ctr_tab[hanum]);
-   
+static int gdth_ioctl(struct inode *inode, struct file *filep,
+                      unsigned int cmd, unsigned long arg)
+{
+    gdth_ha_str *ha; 
 #if LINUX_VERSION_CODE >= 0x020503
-        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev);
-        if (!srp)
-            return -ENOMEM;
-        srp->sr_cmd_len = 12;
-        srp->sr_use_sg = 0;
+    Scsi_Cmnd *scp;
+    Scsi_Device *sdev;
 #elif LINUX_VERSION_CODE >= 0x020322
-        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        scp  = scsi_allocate_device(sdev, 1, FALSE);
-        if (!scp)
-            return -ENOMEM;
-        scp->cmd_len = 12;
-        scp->use_sg = 0;
+    Scsi_Cmnd *scp;
+    Scsi_Device *sdev;
 #else
-        memset(&sdev,0,sizeof(Scsi_Device));
-        memset(&scp, 0,sizeof(Scsi_Cmnd));
-        sdev.host = scp.host = gdth_ctr_tab[hanum];
-        sdev.id = scp.target = sdev.host->this_id;
-        scp.device = &sdev;
+    Scsi_Cmnd scp;
+    Scsi_Device sdev;
 #endif
+    ulong flags;
+    char cmnd[MAX_COMMAND_SIZE];   
 
-        for (i = 0; i < MAX_HDRIVES; ++i) { 
-            if (!ha->hdr[i].present) {
-                rsc.hdr_list[i].bus = 0xff; 
-                continue;
-            } 
-            rsc.hdr_list[i].bus = ha->virt_bus;
-            rsc.hdr_list[i].target = i;
-            rsc.hdr_list[i].lun = 0;
-            rsc.hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
-            if (ha->hdr[i].cluster_type & CLUSTER_DRIVE) { 
-                cmd.Service = CACHESERVICE;
-                cmd.OpCode = GDT_CLUST_INFO;
-                cmd.u.cache.DeviceNo = i;
-#if LINUX_VERSION_CODE >= 0x020503
-                gdth_do_req(srp, &cmd, cmnd, 30);
-                if (srp->sr_command->SCp.Status == S_OK)
-                    rsc.hdr_list[i].cluster_type = srp->sr_command->SCp.Message;
-#elif LINUX_VERSION_CODE >= 0x020322
-                gdth_do_cmd(scp, &cmd, cmnd, 30);
-                if (scp->SCp.Status == S_OK)
-                    rsc.hdr_list[i].cluster_type = scp->SCp.Message;
-#else
-                gdth_do_cmd(&scp, &cmd, cmnd, 30);
-                if (scp.SCp.Status == S_OK)
-                    rsc.hdr_list[i].cluster_type = scp.SCp.Message;
-#endif
-            }
-        } 
-#if LINUX_VERSION_CODE >= 0x020503
-        scsi_release_request(srp);
-        scsi_free_host_dev(sdev);
-#elif LINUX_VERSION_CODE >= 0x020322
-        scsi_release_command(scp);
-        scsi_free_host_dev(sdev);
-#endif       
+    memset(cmnd, 0xff, 12);
+    
+    TRACE(("gdth_ioctl() cmd 0x%x\n", cmd));
  
-        if (copy_to_user((char *)arg, &rsc, sizeof(gdth_ioctl_rescan)))
+    switch (cmd) {
+      case GDTIOCTL_CTRCNT:
+      { 
+        int cnt = gdth_ctr_count;
+        put_user(cnt, (int *)arg);
+        break;
+      }
+
+      case GDTIOCTL_DRVERS:
+      { 
+        int ver = (GDTH_VERSION<<8) | GDTH_SUBVERSION;
+        put_user(ver, (int *)arg);
+        break;
+      }
+      
+      case GDTIOCTL_OSVERS:
+      { 
+        gdth_ioctl_osvers osv; 
+
+        osv.version = (unchar)(LINUX_VERSION_CODE >> 16);
+        osv.subversion = (unchar)(LINUX_VERSION_CODE >> 8);
+        osv.revision = (ushort)(LINUX_VERSION_CODE & 0xff);
+        copy_to_user((char *)arg, &osv, sizeof(gdth_ioctl_osvers));
+        break;
+      }
+
+      case GDTIOCTL_CTRTYPE:
+      { 
+        gdth_ioctl_ctrtype ctrt;
+        
+        if (copy_from_user(&ctrt, (char *)arg, sizeof(gdth_ioctl_ctrtype)) ||
+            ctrt.ionode >= gdth_ctr_count)
+            return -EFAULT;
+        ha = HADATA(gdth_ctr_tab[ctrt.ionode]);
+        if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
+            ctrt.type = (unchar)((ha->stype>>20) - 0x10);
+        } else {
+            if (ha->type != GDT_PCIMPR) {
+                ctrt.type = (unchar)((ha->stype<<4) + 6);
+            } else {
+                ctrt.type = 
+                    (ha->oem_id == OEM_ID_INTEL ? 0xfd : 0xfe);
+                if (ha->stype >= 0x300)
+                    ctrt.ext_type = 0x6000 | ha->subdevice_id;
+                else 
+                    ctrt.ext_type = 0x6000 | ha->stype;
+            }
+            ctrt.device_id = ha->stype;
+            ctrt.sub_device_id = ha->subdevice_id;
+        }
+        ctrt.info = ha->brd_phys;
+        ctrt.oem_id = ha->oem_id;
+        if (copy_to_user((char *)arg, &ctrt, sizeof(gdth_ioctl_ctrtype)))
             return -EFAULT;
         break;
       }
+        
+      case GDTIOCTL_GENERAL:
+	return ioc_general(arg, cmnd);
+
+      case GDTIOCTL_EVENT:
+	return ioc_event(arg);
+
+      case GDTIOCTL_LOCKDRV:
+	return ioc_lockdrv(arg);
+
+      case GDTIOCTL_LOCKCHN:
+      {
+        gdth_ioctl_lockchn lchn;
+        unchar i, j;
+
+        if (copy_from_user(&lchn, (char *)arg, sizeof(gdth_ioctl_lockchn)) ||
+            lchn.ionode >= gdth_ctr_count)
+            return -EFAULT;
+        ha = HADATA(gdth_ctr_tab[lchn.ionode]);
+        
+        i = lchn.channel;
+        if (i < ha->bus_cnt) {
+            if (lchn.lock) {
+                GDTH_LOCK_HA(ha, flags);
+                ha->raw[i].lock = 1;
+                GDTH_UNLOCK_HA(ha, flags);
+                for (j = 0; j < ha->tid_cnt; ++j) {
+                    gdth_wait_completion(lchn.ionode, i, j); 
+                    gdth_stop_timeout(lchn.ionode, i, j); 
+                }
+            } else {
+                GDTH_LOCK_HA(ha, flags);
+                ha->raw[i].lock = 0;
+                GDTH_UNLOCK_HA(ha, flags);
+                for (j = 0; j < ha->tid_cnt; ++j) {
+                    gdth_start_timeout(lchn.ionode, i, j); 
+                    gdth_next(lchn.ionode); 
+                }
+            }
+        } 
+        break;
+      }
+
+      case GDTIOCTL_RESCAN:
+	return ioc_rescan(arg, cmnd);
+
+      case GDTIOCTL_HDRLIST:
+	return ioc_hdrlist(arg, cmnd);
 
       case GDTIOCTL_RESET_BUS:
       {
@@ -5481,57 +5607,7 @@
       }
 
       case GDTIOCTL_RESET_DRV:
-      {
-        gdth_ioctl_reset res;
-        gdth_cmd_str cmd;
-        int hanum;
-
-        if (copy_from_user(&res, (char *)arg, sizeof(gdth_ioctl_reset)) ||
-            res.ionode >= gdth_ctr_count || res.number >= MAX_HDRIVES)
-            return -EFAULT;
-        hanum = res.ionode;
-        ha = HADATA(gdth_ctr_tab[hanum]);
- 
-        if (!ha->hdr[res.number].present)
-            return 0;
-        cmd.Service = CACHESERVICE;
-        cmd.OpCode = GDT_CLUST_RESET;
-        cmd.u.cache.DeviceNo = res.number;
-#if LINUX_VERSION_CODE >= 0x020503
-        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev);
-        if (!srp)
-            return -ENOMEM;
-        srp->sr_cmd_len = 12;
-        srp->sr_use_sg = 0;
-        gdth_do_req(srp, &cmd, cmnd, 30);
-        res.status = (ushort)srp->sr_command->SCp.Status;
-        scsi_release_request(srp);
-        scsi_free_host_dev(sdev);
-#elif LINUX_VERSION_CODE >= 0x020322
-        sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        scp  = scsi_allocate_device(sdev, 1, FALSE);
-        if (!scp)
-            return -ENOMEM;
-        scp->cmd_len = 12;
-        scp->use_sg = 0;
-        gdth_do_cmd(scp, &cmd, cmnd, 30);
-        res.status = (ushort)scp->SCp.Status;
-        scsi_release_command(scp);
-        scsi_free_host_dev(sdev);
-#else
-        memset(&sdev,0,sizeof(Scsi_Device));
-        memset(&scp, 0,sizeof(Scsi_Cmnd));
-        sdev.host = scp.host = gdth_ctr_tab[hanum];
-        sdev.id = scp.target = sdev.host->this_id;
-        scp.device = &sdev;
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
-        res.status = (ushort)scp.SCp.Status;
-#endif
-        if (copy_to_user((char *)arg, &res, sizeof(gdth_ioctl_reset)))
-            return -EFAULT;
-        break;
-      }
+	return ioc_resetdrv(arg, cmnd);
 
       default:
         break; 
diff -ur linux-2.5.67_original/drivers/scsi/gdth_proc.c linux-2.5.67_gdth/drivers/scsi/gdth_proc.c
--- linux-2.5.67_original/drivers/scsi/gdth_proc.c	2003-04-07 10:31:18.000000000 -0700
+++ linux-2.5.67_gdth/drivers/scsi/gdth_proc.c	2003-04-17 15:01:39.000000000 -0700
@@ -1471,7 +1471,10 @@
         ret_val = NULL;
     } else {
 #if LINUX_VERSION_CODE >= 0x020400
-        ret_val = pci_alloc_consistent(ha->pdev, size, paddr);
+	dma_addr_t dma_addr;
+
+        ret_val = pci_alloc_consistent(ha->pdev, size, &dma_addr);
+	*paddr = (ulong32)dma_addr;
 #else
         ret_val = scsi_init_malloc(size, GFP_ATOMIC | GFP_DMA);
         if (ret_val)
