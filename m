From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 15/16] gdth: Move members from SCp to gdth_cmndinfo, stage
 2
Date: Tue, 02 Oct 2007 23:16:01 +0200
Message-ID: <4702B511.4090808@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15419 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754630AbXJBVQQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:16:16 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kern>


  - Cleanup the rest of the scsi_cmnd->SCp members and move them
    to gdth_cmndinfo:
    SCp.this_residual 	 => priority
    SCp.buffers_residual => timeout
    SCp.Status 		 => status and dma_dir
    SCp.Message 	 => info
    SCp.have_data_in 	 => volatile wait_for_completion
    SCp.sent_command 	 => OpCode
    SCp.phase 		 => phase

  - Two more members will be naturally removed in the !use_sg cleanup

  TODO: What is the meaning of gdth_cmndinfo.phase? (rhetorically)

Signed-off-by Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c      |  177 +++++++++++++++++++++++----------------------
 drivers/scsi/gdth.h      |    8 ++
 drivers/scsi/gdth_proc.c |   10 ++-
 3 files changed, 104 insertions(+), 91 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 966f632..803ca93 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -85,15 +85,15 @@
 
 /* The meaning of the Scsi_Pointer members in this driver is as follows:
  * ptr:                     Chaining
- * this_residual:           Command priority
+ * this_residual:           unused
  * buffer:                  unused
  * dma_handle:              will drop in !use_sg patch.
- * buffers_residual:        Timeout value
- * Status:                  Command status (gdth_do_cmd()), DMA mem. mappings
- * Message:                 Additional info (gdth_do_cmd()), DMA direction
- * have_data_in:            Flag for gdth_wait_completion()
- * sent_command:            Opcode special command
- * phase:                   Service/parameter/return code special command
+ * buffers_residual:        unused
+ * Status:                  DMA mem. mappings (FIXME: drop in !use_sg patch.)
+ * Message:                 unused
+ * have_data_in:            unused
+ * sent_command:            unused
+ * phase:                   unused
  */
 
 
@@ -468,7 +468,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     scp->request_buffer = gdtcmd;
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
-    scp->SCp.this_residual = IOCTL_PRI;   /* priority */
+    cmndinfo.priority = IOCTL_PRI;
     cmndinfo.internal_command = 1;
 
     TRACE(("__gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
@@ -476,9 +476,9 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
 
     wait_for_completion(&wait);
 
-    rval = scp->SCp.Status;
+    rval = cmndinfo.status;
     if (info)
-        *info = scp->SCp.Message;
+        *info = cmndinfo.info;
     kfree(scp);
     return rval;
 }
@@ -2016,14 +2016,14 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (!cmndinfo->internal_command) {
-        scp->SCp.this_residual = (int)priority;
+        cmndinfo->priority = priority;
         b = scp->device->channel;
         t = scp->device->id;
         if (priority >= DEFAULT_PRI) {
             if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
                 (b==ha->virt_bus && t<MAX_HDRIVES && ha->hdr[t].lock)) {
                 TRACE2(("gdth_putq(): locked IO ->update_timeout()\n"));
-                scp->SCp.buffers_residual = gdth_update_timeout(scp, 0);
+                cmndinfo->timeout = gdth_update_timeout(scp, 0);
             }
         }
     }
@@ -2035,7 +2035,7 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
         pscp = ha->req_first;
         nscp = (Scsi_Cmnd *)pscp->SCp.ptr;
         /* priority: 0-highest,..,0xff-lowest */
-        while (nscp && (unchar)nscp->SCp.this_residual <= priority) {
+        while (nscp && gdth_cmnd_priv(nscp)->priority <= priority) {
             pscp = nscp;
             nscp = (Scsi_Cmnd *)pscp->SCp.ptr;
         }
@@ -2074,13 +2074,14 @@ static void gdth_next(gdth_ha_str *ha)
     cmd_index = 0;
 
     for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
+        struct gdth_cmndinfo *nscp_cmndinfo = gdth_cmnd_priv(nscp);
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-        if (!gdth_cmnd_priv(nscp)->internal_command) {
+        if (!nscp_cmndinfo->internal_command) {
             b = nscp->device->channel;
             t = nscp->device->id;
             l = nscp->device->lun;
-            if (nscp->SCp.this_residual >= DEFAULT_PRI) {
+            if (nscp_cmndinfo->priority >= DEFAULT_PRI) {
                 if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
                     (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock))
                     continue;
@@ -2101,9 +2102,9 @@ static void gdth_next(gdth_ha_str *ha)
             firsttime = FALSE;
         }
 
-        if (!gdth_cmnd_priv(nscp)->internal_command) {
-        if (nscp->SCp.phase == -1) {
-            nscp->SCp.phase = CACHESERVICE;           /* default: cache svc. */ 
+        if (!nscp_cmndinfo->internal_command) {
+        if (nscp_cmndinfo->phase == -1) {
+            nscp_cmndinfo->phase = CACHESERVICE;           /* default: cache svc. */
             if (nscp->cmnd[0] == TEST_UNIT_READY) {
                 TRACE2(("TEST_UNIT_READY Bus %d Id %d LUN %d\n", 
                         b, t, l));
@@ -2116,8 +2117,8 @@ static void gdth_next(gdth_ha_str *ha)
                 } else if ((ha->scan_mode & 0x0f) == 1) {
                     if (b == 0 && ((t == 0 && l == 1) ||
                          (t == 1 && l == 0))) {
-                        nscp->SCp.sent_command = GDT_SCAN_START;
-                        nscp->SCp.phase = ((ha->scan_mode & 0x10 ? 1:0) << 8) 
+                        nscp_cmndinfo->OpCode = GDT_SCAN_START;
+                        nscp_cmndinfo->phase = ((ha->scan_mode & 0x10 ? 1:0) << 8)
                             | SCSIRAWSERVICE;
                         ha->scan_mode = 0x12;
                         TRACE2(("Scan mode: 0x%x (SCAN_START)\n", 
@@ -2128,8 +2129,8 @@ static void gdth_next(gdth_ha_str *ha)
                     }                   
                 } else if (ha->scan_mode == 0x12) {
                     if (b == ha->bus_cnt && t == ha->tid_cnt-1) {
-                        nscp->SCp.phase = SCSIRAWSERVICE;
-                        nscp->SCp.sent_command = GDT_SCAN_END;
+                        nscp_cmndinfo->phase = SCSIRAWSERVICE;
+                        nscp_cmndinfo->OpCode = GDT_SCAN_END;
                         ha->scan_mode &= 0x10;
                         TRACE2(("Scan mode: 0x%x (SCAN_END)\n", 
                                 ha->scan_mode));
@@ -2140,17 +2141,17 @@ static void gdth_next(gdth_ha_str *ha)
                 nscp->cmnd[0] != READ_CAPACITY && nscp->cmnd[0] != MODE_SENSE &&
                 (ha->hdr[t].cluster_type & CLUSTER_DRIVE)) {
                 /* always GDT_CLUST_INFO! */
-                nscp->SCp.sent_command = GDT_CLUST_INFO;
+                nscp_cmndinfo->OpCode = GDT_CLUST_INFO;
             }
         }
         }
 
-        if (nscp->SCp.sent_command != -1) {
-            if ((nscp->SCp.phase & 0xff) == CACHESERVICE) {
+        if (nscp_cmndinfo->OpCode != -1) {
+            if ((nscp_cmndinfo->phase & 0xff) == CACHESERVICE) {
                 if (!(cmd_index=gdth_fill_cache_cmd(ha, nscp, t)))
                     this_cmd = FALSE;
                 next_cmd = FALSE;
-            } else if ((nscp->SCp.phase & 0xff) == SCSIRAWSERVICE) {
+            } else if ((nscp_cmndinfo->phase & 0xff) == SCSIRAWSERVICE) {
                 if (!(cmd_index=gdth_fill_raw_cmd(ha, nscp, BUS_L2P(ha, b))))
                     this_cmd = FALSE;
                 next_cmd = FALSE;
@@ -2159,8 +2160,8 @@ static void gdth_next(gdth_ha_str *ha)
                 nscp->sense_buffer[0] = 0x70;
                 nscp->sense_buffer[2] = NOT_READY;
                 nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
-                if (!nscp->SCp.have_data_in)
-                    nscp->SCp.have_data_in++;
+                if (!nscp_cmndinfo->wait_for_completion)
+                    nscp_cmndinfo->wait_for_completion++;
                 else
                     gdth_scsi_done(nscp);
             }
@@ -2178,8 +2179,8 @@ static void gdth_next(gdth_ha_str *ha)
             TRACE2(("Command 0x%x to bus %d id %d lun %d -> IGNORE\n",
                     nscp->cmnd[0], b, t, l));
             nscp->result = DID_BAD_TARGET << 16;
-            if (!nscp->SCp.have_data_in)
-                nscp->SCp.have_data_in++;
+            if (!nscp_cmndinfo->wait_for_completion)
+                nscp_cmndinfo->wait_for_completion++;
             else
                 gdth_scsi_done(nscp);
         } else {
@@ -2204,8 +2205,8 @@ static void gdth_next(gdth_ha_str *ha)
                     nscp->sense_buffer[0] = 0x70;
                     nscp->sense_buffer[2] = UNIT_ATTENTION;
                     nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
-                    if (!nscp->SCp.have_data_in)
-                        nscp->SCp.have_data_in++;
+                    if (!nscp_cmndinfo->wait_for_completion)
+                        nscp_cmndinfo->wait_for_completion++;
                     else
                         gdth_scsi_done(nscp);
                 } else if (gdth_internal_cache_cmd(ha, nscp))
@@ -2220,8 +2221,8 @@ static void gdth_next(gdth_ha_str *ha)
                     TRACE(("Prevent r. nonremov. drive->do nothing\n"));
                     nscp->result = DID_OK << 16;
                     nscp->sense_buffer[0] = 0;
-                    if (!nscp->SCp.have_data_in)
-                        nscp->SCp.have_data_in++;
+                    if (!nscp_cmndinfo->wait_for_completion)
+                        nscp_cmndinfo->wait_for_completion++;
                     else
                         gdth_scsi_done(nscp);
                 } else {
@@ -2256,8 +2257,8 @@ static void gdth_next(gdth_ha_str *ha)
                     nscp->sense_buffer[0] = 0x70;
                     nscp->sense_buffer[2] = UNIT_ATTENTION;
                     nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
-                    if (!nscp->SCp.have_data_in)
-                        nscp->SCp.have_data_in++;
+                    if (!nscp_cmndinfo->wait_for_completion)
+                        nscp_cmndinfo->wait_for_completion++;
                     else
                         gdth_scsi_done(nscp);
                 } else if (!(cmd_index=gdth_fill_cache_cmd(ha, nscp, t)))
@@ -2271,8 +2272,8 @@ static void gdth_next(gdth_ha_str *ha)
                 printk("GDT-HA %d: Unknown SCSI command 0x%x to cache service !\n",
                        ha->hanum, nscp->cmnd[0]);
                 nscp->result = DID_ABORT << 16;
-                if (!nscp->SCp.have_data_in)
-                    nscp->SCp.have_data_in++;
+                if (!nscp_cmndinfo->wait_for_completion)
+                    nscp_cmndinfo->wait_for_completion++;
                 else
                     gdth_scsi_done(nscp);
                 break;
@@ -2351,6 +2352,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     gdth_rdcap_data rdc;
     gdth_sense_data sd;
     gdth_modep_data mpd;
+    struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
 
     t  = scp->device->id;
     TRACE(("gdth_internal_cache_cmd() cmd 0x%x hdrive %d\n",
@@ -2437,8 +2439,8 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         break;
     }
 
-    if (!scp->SCp.have_data_in)
-        scp->SCp.have_data_in++;
+    if (!cmndinfo->wait_for_completion)
+        cmndinfo->wait_for_completion++;
     else 
         return 1;
 
@@ -2448,6 +2450,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 {
     register gdth_cmd_str *cmdp;
+    struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
     struct scatterlist *sl;
     ulong32 cnt, blockcnt;
     ulong64 no, blockno;
@@ -2481,8 +2484,8 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 
     /* fill command */
     read_write = 0;
-    if (scp->SCp.sent_command != -1) 
-        cmdp->OpCode = scp->SCp.sent_command;   /* special cache cmd. */
+    if (cmndinfo->OpCode != -1)
+        cmdp->OpCode = cmndinfo->OpCode;   /* special cache cmd. */
     else if (scp->cmnd[0] == RESERVE) 
         cmdp->OpCode = GDT_RESERVE_DRV;
     else if (scp->cmnd[0] == RELEASE)
@@ -2547,9 +2550,9 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
             sl = (struct scatterlist *)scp->request_buffer;
             sgcnt = scp->use_sg;
             scp->SCp.Status = GDTH_MAP_SG;
-            scp->SCp.Message = (read_write == 1 ? 
+            cmndinfo->dma_dir = (read_write == 1 ?
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);   
-            sgcnt = pci_map_sg(ha->pdev,sl,scp->use_sg,scp->SCp.Message);
+            sgcnt = pci_map_sg(ha->pdev, sl, scp->use_sg, cmndinfo->dma_dir);
             if (mode64) {
                 cmdp->u.cache64.DestAddr= (ulong64)-1;
                 cmdp->u.cache64.sg_canz = sgcnt;
@@ -2584,12 +2587,12 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 
         } else if (scp->request_bufflen) {
             scp->SCp.Status = GDTH_MAP_SINGLE;
-            scp->SCp.Message = (read_write == 1 ? 
+            cmndinfo->dma_dir = (read_write == 1 ?
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
             page = virt_to_page(scp->request_buffer);
             offset = (ulong)scp->request_buffer & ~PAGE_MASK;
             phys_addr = pci_map_page(ha->pdev,page,offset,
-                                     scp->request_bufflen,scp->SCp.Message);
+                                     scp->request_bufflen, cmndinfo->dma_dir);
             scp->SCp.dma_handle = phys_addr;
             if (mode64) {
                 if (ha->cache_feat & SCATTER_GATHER) {
@@ -2689,17 +2692,17 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
 
     cmndinfo = gdth_cmnd_priv(scp);
     /* fill command */  
-    if (scp->SCp.sent_command != -1) {
-        cmdp->OpCode           = scp->SCp.sent_command; /* special raw cmd. */
+    if (cmndinfo->OpCode != -1) {
+        cmdp->OpCode           = cmndinfo->OpCode; /* special raw cmd. */
         cmdp->BoardNode        = LOCALBOARD;
         if (mode64) {
-            cmdp->u.raw64.direction = (scp->SCp.phase >> 8);
+            cmdp->u.raw64.direction = (cmndinfo->phase >> 8);
             TRACE2(("special raw cmd 0x%x param 0x%x\n", 
                     cmdp->OpCode, cmdp->u.raw64.direction));
             /* evaluate command size */
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.raw64.sg_lst);
         } else {
-            cmdp->u.raw.direction  = (scp->SCp.phase >> 8);
+            cmdp->u.raw.direction  = (cmndinfo->phase >> 8);
             TRACE2(("special raw cmd 0x%x param 0x%x\n", 
                     cmdp->OpCode, cmdp->u.raw.direction));
             /* evaluate command size */
@@ -2754,8 +2757,8 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             sl = (struct scatterlist *)scp->request_buffer;
             sgcnt = scp->use_sg;
             scp->SCp.Status = GDTH_MAP_SG;
-            scp->SCp.Message = PCI_DMA_BIDIRECTIONAL; 
-            sgcnt = pci_map_sg(ha->pdev,sl,scp->use_sg,scp->SCp.Message);
+            cmndinfo->dma_dir = PCI_DMA_BIDIRECTIONAL;
+            sgcnt = pci_map_sg(ha->pdev,sl, scp->use_sg, cmndinfo->dma_dir);
             if (mode64) {
                 cmdp->u.raw64.sdata = (ulong64)-1;
                 cmdp->u.raw64.sg_ranz = sgcnt;
@@ -2790,11 +2793,11 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
 
         } else if (scp->request_bufflen) {
             scp->SCp.Status = GDTH_MAP_SINGLE;
-            scp->SCp.Message = PCI_DMA_BIDIRECTIONAL; 
+            cmndinfo->dma_dir = PCI_DMA_BIDIRECTIONAL;
             page = virt_to_page(scp->request_buffer);
             offset = (ulong)scp->request_buffer & ~PAGE_MASK;
             phys_addr = pci_map_page(ha->pdev,page,offset,
-                                     scp->request_bufflen,scp->SCp.Message);
+                                     scp->request_bufflen, cmndinfo->dma_dir);
             scp->SCp.dma_handle = phys_addr;
 
             if (mode64) {
@@ -3266,7 +3269,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha->smp_lock, flags);
         if (rval == 2) {
-            gdth_putq(ha, scp,scp->SCp.this_residual);
+            gdth_putq(ha, scp, gdth_cmnd_priv(scp)->priority);
         } else if (rval == 1) {
             gdth_scsi_done(scp);
         }
@@ -3390,60 +3393,60 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
     } else {
         b = scp->device->channel;
         t = scp->device->id;
-        if (scp->SCp.sent_command == -1 && b != ha->virt_bus) {
+        if (cmndinfo->OpCode == -1 && b != ha->virt_bus) {
             ha->raw[BUS_L2P(ha,b)].io_cnt[t]--;
         }
         /* cache or raw service */
         if (ha->status == S_BSY) {
             TRACE2(("Controller busy -> retry !\n"));
-            if (scp->SCp.sent_command == GDT_MOUNT)
-                scp->SCp.sent_command = GDT_CLUST_INFO;
+            if (cmndinfo->OpCode == GDT_MOUNT)
+                cmndinfo->OpCode = GDT_CLUST_INFO;
             /* retry */
             return 2;
         }
         if (scp->SCp.Status == GDTH_MAP_SG) 
             pci_unmap_sg(ha->pdev,scp->request_buffer,
-                         scp->use_sg,scp->SCp.Message);
+                         scp->use_sg, cmndinfo->dma_dir);
         else if (scp->SCp.Status == GDTH_MAP_SINGLE) 
             pci_unmap_page(ha->pdev,scp->SCp.dma_handle,
-                           scp->request_bufflen,scp->SCp.Message);
+                           scp->request_bufflen, cmndinfo->dma_dir);
         if (cmndinfo->sense_paddr)
             pci_unmap_page(ha->pdev, cmndinfo->sense_paddr, 16,
                                                            PCI_DMA_FROMDEVICE);
 
         if (ha->status == S_OK) {
-            scp->SCp.Status = S_OK;
-            scp->SCp.Message = ha->info;
-            if (scp->SCp.sent_command != -1) {
+            cmndinfo->status = S_OK;
+            cmndinfo->info = ha->info;
+            if (cmndinfo->OpCode != -1) {
                 TRACE2(("gdth_sync_event(): special cmd 0x%x OK\n",
-                        scp->SCp.sent_command));
+                        cmndinfo->OpCode));
                 /* special commands GDT_CLUST_INFO/GDT_MOUNT ? */
-                if (scp->SCp.sent_command == GDT_CLUST_INFO) {
+                if (cmndinfo->OpCode == GDT_CLUST_INFO) {
                     ha->hdr[t].cluster_type = (unchar)ha->info;
                     if (!(ha->hdr[t].cluster_type & 
                         CLUSTER_MOUNTED)) {
                         /* NOT MOUNTED -> MOUNT */
-                        scp->SCp.sent_command = GDT_MOUNT;
+                        cmndinfo->OpCode = GDT_MOUNT;
                         if (ha->hdr[t].cluster_type & 
                             CLUSTER_RESERVED) {
                             /* cluster drive RESERVED (on the other node) */
-                            scp->SCp.phase = -2;      /* reservation conflict */
+                            cmndinfo->phase = -2;      /* reservation conflict */
                         }
                     } else {
-                        scp->SCp.sent_command = -1;
+                        cmndinfo->OpCode = -1;
                     }
                 } else {
-                    if (scp->SCp.sent_command == GDT_MOUNT) {
+                    if (cmndinfo->OpCode == GDT_MOUNT) {
                         ha->hdr[t].cluster_type |= CLUSTER_MOUNTED;
                         ha->hdr[t].media_changed = TRUE;
-                    } else if (scp->SCp.sent_command == GDT_UNMOUNT) {
+                    } else if (cmndinfo->OpCode == GDT_UNMOUNT) {
                         ha->hdr[t].cluster_type &= ~CLUSTER_MOUNTED;
                         ha->hdr[t].media_changed = TRUE;
                     } 
-                    scp->SCp.sent_command = -1;
+                    cmndinfo->OpCode = -1;
                 }
                 /* retry */
-                scp->SCp.this_residual = HIGH_PRI;
+                cmndinfo->priority = HIGH_PRI;
                 return 2;
             } else {
                 /* RESERVE/RELEASE ? */
@@ -3456,17 +3459,17 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                 scp->sense_buffer[0] = 0;
             }
         } else {
-            scp->SCp.Status = ha->status;
-            scp->SCp.Message = ha->info;
+            cmndinfo->status = ha->status;
+            cmndinfo->info = ha->info;
 
-            if (scp->SCp.sent_command != -1) {
+            if (cmndinfo->OpCode != -1) {
                 TRACE2(("gdth_sync_event(): special cmd 0x%x error 0x%x\n",
-                        scp->SCp.sent_command, ha->status));
-                if (scp->SCp.sent_command == GDT_SCAN_START ||
-                    scp->SCp.sent_command == GDT_SCAN_END) {
-                    scp->SCp.sent_command = -1;
+                        cmndinfo->OpCode, ha->status));
+                if (cmndinfo->OpCode == GDT_SCAN_START ||
+                    cmndinfo->OpCode == GDT_SCAN_END) {
+                    cmndinfo->OpCode = -1;
                     /* retry */
-                    scp->SCp.this_residual = HIGH_PRI;
+                    cmndinfo->priority = HIGH_PRI;
                     return 2;
                 }
                 memset((char*)scp->sense_buffer,0,16);
@@ -3509,8 +3512,8 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                 }
             }
         }
-        if (!scp->SCp.have_data_in)
-            scp->SCp.have_data_in++;
+        if (!cmndinfo->wait_for_completion)
+            cmndinfo->wait_for_completion++;
         else 
             return 1;
     }
@@ -4042,7 +4045,7 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
 
     scp->scsi_done = done;
     gdth_update_timeout(scp, scp->timeout_per_command * 6);
-    scp->SCp.this_residual = DEFAULT_PRI;
+    cmndinfo->priority = DEFAULT_PRI;
     return __gdth_queuecommand(ha, scp, cmndinfo);
 }
 
@@ -4050,16 +4053,16 @@ static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo)
 {
     scp->host_scribble = (unsigned char *)cmndinfo;
-    scp->SCp.have_data_in = 1;
-    scp->SCp.phase = -1;
-    scp->SCp.sent_command = -1;
+    cmndinfo->wait_for_completion = 1;
+    cmndinfo->phase = -1;
+    cmndinfo->OpCode = -1;
     scp->SCp.Status = GDTH_MAP_NONE;
 
 #ifdef GDTH_STATISTICS
     ++act_ios;
 #endif
 
-    gdth_putq(ha, scp, scp->SCp.this_residual);
+    gdth_putq(ha, scp, cmndinfo->priority);
     gdth_next(ha);
     return 0;
 }
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index be4ae5a..25803a8 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -923,6 +923,14 @@ typedef struct {
         int index;
         int internal_command;                   /* don't call scsi_done */
         dma_addr_t sense_paddr;                 /* sense dma-addr */
+        unchar priority;
+        int timeout;
+        volatile int wait_for_completion;
+        ushort status;
+        ulong32 info;
+        enum dma_data_direction dma_dir;
+        int phase;                              /* ???? */
+        int OpCode;
     } cmndinfo[GDTH_MAXCMDS];                   /* index==0 is free */
     unchar              bus_cnt;                /* SCSI bus count */
     unchar              tid_cnt;                /* Target ID count */
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index ad1b60d..de57734 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -728,20 +728,22 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
     ulong flags;
     int i;
     Scsi_Cmnd *scp;
+    struct gdth_cmndinfo *cmndinfo;
     unchar b, t;
 
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         scp = ha->cmd_tab[i].cmnd;
+        cmndinfo = gdth_cmnd_priv(scp);
 
         b = scp->device->channel;
         t = scp->device->id;
         if (!SPECIAL_SCP(scp) && t == (unchar)id && 
             b == (unchar)busnum) {
-            scp->SCp.have_data_in = 0;
+            cmndinfo->wait_for_completion = 0;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
-            while (!scp->SCp.have_data_in)
+            while (!cmndinfo->wait_for_completion)
                 barrier();
             spin_lock_irqsave(&ha->smp_lock, flags);
         }
@@ -764,7 +766,7 @@ static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id)
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
-                scp->SCp.buffers_residual = gdth_update_timeout(scp, 0);
+                cmndinfo->timeout = gdth_update_timeout(scp, 0);
             }
         }
     }
@@ -786,7 +788,7 @@ static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id)
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_start_timeout(): update_timeout()\n"));
-                gdth_update_timeout(scp, scp->SCp.buffers_residual);
+                gdth_update_timeout(scp, cmndinfo->timeout);
             }
         }
     }
-- 
1.5.3.1


