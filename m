From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] 2.5.67 scsi/gdth.c stack usage
Date: Mon, 14 Apr 2003 17:13:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414171301.4c9823f4.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:33729 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263996AbTDOACJ (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 20:02:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: achim.leubner@intel.com, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@wohnheim.fh-wedel.de>


This patch reduces stack size in scsi/gdth.c::gdth_ioctl() by making
each separate ioctl have its own handler function, so that several
large data structs are all declared on the stack at the same time.

As described below, there are still several issues with making this
driver ready for 2.6.

Comments?

Thanks,
--
~Randy


patch_name:	gdth-stack.patch
patch_version:	2003-04-14.16:31:30
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	reduce stack usage in drivers/scsi/gdth.c::gdth_ioctl()
		from 0xb50 to 0x5c (on P4, gcc 2.96); the large (ioctl)
		function sizes in gdth.o now are:
			150 ioc_event
			178 ioc_resetdrv
			190 ioc_general
			30c ioc_hdrlist
			324 ioc_rescan
		so the largest cumulative size of calling gdth_ioctl() +
		a specific ioctl is 0x5c + 0x324 = 0x380.
product:	Linux
product_versions: 2.5.67
changelog:	make each ioctl that uses large stack space into its own
		function;
		mostly moving lines of code around;
		duplicates some local data in multiple functions;
maintainer:	Achim Leubner (achim.leubner@intel.com)
diffstat:	=
 drivers/scsi/gdth.c |  642 ++++++++++++++++++++++++++++------------------------
 1 files changed, 353 insertions(+), 289 deletions(-)

FYI:  The killer data structs in gdth_ioctl() (on x86, P4, gcc 2.96) are:
		sizeof gdth_cmd_str: 336 bytes
		sizeof gdth_ioctl_general: 356 bytes
		sizeof gdth_ioctl_event: 308 bytes
		sizeof gdth_ioctl_lockdrv: 204 bytes
		sizeof gdth_ioctl_rescan: 406 bytes

This leaves some other outstanding issues regarding making this driver
ready for 2.6:
In file included from drivers/scsi/gdth.c:766:
drivers/scsi/gdth_proc.c: In function `gdth_ioctl_alloc':
drivers/scsi/gdth_proc.c:1474: warning: passing arg 3 of `pci_alloc_consistent' from incompatible pointer type
drivers/scsi/gdth.c: In function `gdth_sync_event':
drivers/scsi/gdth.c:3676: warning: cast from pointer to integer of different size
drivers/scsi/gdth.c: In function `gdth_detect':
drivers/scsi/gdth.c:4285: warning: passing arg 3 of `pci_alloc_consistent' from incompatible pointer type
drivers/scsi/gdth.c:4395: warning: passing arg 3 of `pci_alloc_consistent' from incompatible pointer type
drivers/scsi/gdth.c:4519: warning: passing arg 3 of `pci_alloc_consistent' from incompatible pointer type
_AND_
it needs/uses scsi_get_command() and scsi_put_command(), which are not
exported for modules.  I did a patch to export these for 2.5.60 but
there was some objection to it.

###

diff -Naur ./drivers/scsi/gdth.c%GDTH ./drivers/scsi/gdth.c
--- ./drivers/scsi/gdth.c%GDTH	Mon Apr  7 11:11:56 2003
+++ ./drivers/scsi/gdth.c	Mon Apr 14 16:29:35 2003
@@ -4892,90 +4892,156 @@
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
@@ -5070,116 +5136,115 @@
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
-            return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[evt.ionode]);
-
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
-        break;
-      }
-
-      case GDTIOCTL_LOCKDRV:
-      {
-        gdth_ioctl_lockdrv ldrv;
-        unchar i, j;
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
-            }
-        } 
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
-            return -EFAULT;
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
+#if LINUX_VERSION_CODE >= 0x020503
+        scsi_release_request(srp);
+        scsi_free_host_dev(sdev);
+#elif LINUX_VERSION_CODE >= 0x020322
+        scsi_release_command(scp);
+        scsi_free_host_dev(sdev);
+#endif       
+ 
+        if (copy_to_user((char *)arg, &rsc, sizeof(gdth_ioctl_rescan)))
+            return -EFAULT;
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
@@ -5344,86 +5409,135 @@
  
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
+            return -EFAULT;
+        break;
+      }
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
             return -EFAULT;
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
         break;
       }
 
+      case GDTIOCTL_RESCAN:
+	return ioc_rescan(arg, cmnd);
+
+      case GDTIOCTL_HDRLIST:
+	return ioc_hdrlist(arg, cmnd);
+
       case GDTIOCTL_RESET_BUS:
       {
         gdth_ioctl_reset res;
@@ -5481,57 +5595,7 @@
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
