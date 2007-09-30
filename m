From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 16/16] gdth: !use_sg cleanup and use of scsi accessors
Date: Sun, 30 Sep 2007 22:17:43 +0200
Message-ID: <47000467.70707@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:59048 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXI3URu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 16:17:50 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  gdth_execute() will issue an internal, none scsi-standard commands
  onto __gdth_queuecommand(). Since it is not recommended to set
  struct scsi_cmnd IO members in llds, gdth now uses internal IO
  members for IO. In the case of gdth_execute() these members will be
  set properly. In case the command was issued from scsi-ml
  (by gdth_queuecommand) they will be set from scsi IO accessors.

  * define gdth IO accessors and use them throughout the driver.
  * use an sg-of-one in gdth_execute() and fix gdth_special_cmd()
    accordingly.
  * Clean the not use_sg code path and company

Signed-off-by Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |  227 ++++++++++++++++++++++++---------------------------
 drivers/scsi/gdth.h |    7 --
 2 files changed, 108 insertions(+), 126 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c712794..0743a22 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -85,11 +85,11 @@
 
 /* The meaning of the Scsi_Pointer members in this driver is as follows:
  * ptr:                     Chaining
- * this_residual:           unused
- * buffer:                  unused
- * dma_handle:              will drop in !use_sg patch.
- * buffers_residual:        unused
- * Status:                  DMA mem. mappings (FIXME: drop in !use_sg patch.)
+ * this_residual:           gdth_bufflen
+ * buffer:                  gdth_sglist
+ * dma_handle:              unused
+ * buffers_residual:        gdth_sg_count
+ * Status:                  unused
  * Message:                 unused
  * have_data_in:            unused
  * sent_command:            unused
@@ -132,6 +132,7 @@
 #include <asm/uaccess.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
+#include <linux/scatterlist.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -157,7 +158,7 @@ static void gdth_readapp_event(gdth_ha_str *ha, unchar application,
 static void gdth_clear_events(void);
 
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer,ushort count);
+                                    char *buffer, ushort count, int to_buffer);
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
@@ -379,6 +380,47 @@ static const struct file_operations gdth_fops = {
     .release = gdth_close,
 };
 
+/*
+ * gdth scsi_command access wrappers.
+ *   below 6 functions are used throughout the driver to access scsi_command's
+ *   io parameters. The reason we do not use the regular accessors from
+ *   scsi_cmnd.h is because of gdth_execute(). Since it is unrecommended for
+ *   llds to directly set scsi_cmnd's IO members. This driver will use SCp
+ *   members for IO parameters, and will copy scsi_cmnd's members to Scp
+ *   members in queuecommand. For internal commands through gdth_execute()
+ *   SCp's members will be set directly.
+ */
+static inline unsigned gdth_bufflen(struct scsi_cmnd *cmd)
+{
+	return (unsigned)cmd->SCp.this_residual;
+}
+
+static inline void gdth_set_bufflen(struct scsi_cmnd *cmd, unsigned bufflen)
+{
+	cmd->SCp.this_residual = bufflen;
+}
+
+static inline unsigned gdth_sg_count(struct scsi_cmnd *cmd)
+{
+	return (unsigned)cmd->SCp.buffers_residual;
+}
+
+static inline void gdth_set_sg_count(struct scsi_cmnd *cmd, unsigned sg_count)
+{
+	cmd->SCp.buffers_residual = sg_count;
+}
+
+static inline struct scatterlist *gdth_sglist(struct scsi_cmnd *cmd)
+{
+	return cmd->SCp.buffer;
+}
+
+static inline void gdth_set_sglist(struct scsi_cmnd *cmd,
+                                   struct scatterlist *sglist)
+{
+	cmd->SCp.buffer = sglist;
+}
+
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
@@ -458,6 +500,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     gdth_ha_str *ha = shost_priv(sdev->host);
     Scsi_Cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
+    struct scatterlist one_sg;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
@@ -471,7 +514,9 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
     scp->timeout_per_command = timeout*HZ;
-    scp->request_buffer = gdtcmd;
+    sg_init_one(&one_sg, gdtcmd, sizeof(*gdtcmd));
+    gdth_set_sglist(scp, &one_sg);
+    gdth_set_bufflen(scp, sizeof(*gdtcmd));
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     cmndinfo.priority = IOCTL_PRI;
@@ -2309,24 +2354,28 @@ static void gdth_next(gdth_ha_str *ha)
                    ha->hanum, cmd_index);
     }
 }
-   
+
+/*
+ * gdth_copy_internal_data() - copy to/from a buffer onto a scsi_cmnd's
+ * buffers, kmap_atomic() as needed.
+ */
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer,ushort count)
+                                    char *buffer, ushort count, int to_buffer)
 {
-    ushort cpcount,i;
+    ushort cpcount,i, max_sg = gdth_sg_count(scp);
     ushort cpsum,cpnow;
     struct scatterlist *sl;
     char *address;
 
-    cpcount = count<=(ushort)scp->request_bufflen ? count:(ushort)scp->request_bufflen;
+    cpcount = min_t(ushort, count, gdth_bufflen(scp));
 
-    if (scp->use_sg) {
-        sl = (struct scatterlist *)scp->request_buffer;
-        for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
+    if (cpcount) {
+        cpsum=0;
+        scsi_for_each_sg(scp, sl, max_sg, i) {
             unsigned long flags;
             cpnow = (ushort)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
-                          cpnow,cpsum,cpcount,(ushort)scp->bufflen));
+                          cpnow, cpsum, cpcount, gdth_bufflen(scp)));
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
@@ -2337,7 +2386,10 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
             }
             local_irq_save(flags);
             address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
-            memcpy(address,buffer,cpnow);
+            if (to_buffer)
+                memcpy(buffer, address, cpnow);
+            else
+                memcpy(address, buffer, cpnow);
             flush_dcache_page(sl->page);
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
             local_irq_restore(flags);
@@ -2345,9 +2397,10 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                 break;
             buffer += cpnow;
         }
-    } else {
-        TRACE(("copy_internal() count %d\n",cpcount));
-        memcpy((char*)scp->request_buffer,buffer,cpcount);
+    } else if (count) {
+        printk("GDT-HA %d: SCSI command with no buffers but data transfer expected!\n",
+               ha->hanum);
+        WARN_ON(1);
     }
 }
 
@@ -2390,7 +2443,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         strcpy(inq.vendor,ha->oem_name);
         sprintf(inq.product,"Host Drive  #%02d",t);
         strcpy(inq.revision,"   ");
-        gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data));
+        gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data), 0);
         break;
 
       case REQUEST_SENSE:
@@ -2400,7 +2453,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         sd.key       = NO_SENSE;
         sd.info      = 0;
         sd.add_length= 0;
-        gdth_copy_internal_data(ha, scp, (char*)&sd, sizeof(gdth_sense_data));
+        gdth_copy_internal_data(ha, scp, (char*)&sd, sizeof(gdth_sense_data), 0);
         break;
 
       case MODE_SENSE:
@@ -2412,7 +2465,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         mpd.bd.block_length[0] = (SECTOR_SIZE & 0x00ff0000) >> 16;
         mpd.bd.block_length[1] = (SECTOR_SIZE & 0x0000ff00) >> 8;
         mpd.bd.block_length[2] = (SECTOR_SIZE & 0x000000ff);
-        gdth_copy_internal_data(ha, scp, (char*)&mpd, sizeof(gdth_modep_data));
+        gdth_copy_internal_data(ha, scp, (char*)&mpd, sizeof(gdth_modep_data), 0);
         break;
 
       case READ_CAPACITY:
@@ -2422,7 +2475,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
         rdc.block_length  = cpu_to_be32(SECTOR_SIZE);
-        gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data));
+        gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data), 0);
         break;
 
       case SERVICE_ACTION_IN:
@@ -2434,7 +2487,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
             rdc16.last_block_no = cpu_to_be64(ha->hdr[t].size-1);
             rdc16.block_length  = cpu_to_be32(SECTOR_SIZE);
             gdth_copy_internal_data(ha, scp, (char*)&rdc16,
-                                                     sizeof(gdth_rdcap16_data));
+                                                 sizeof(gdth_rdcap16_data), 0);
         } else { 
             scp->result = DID_ABORT << 16;
         }
@@ -2457,13 +2510,9 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-    struct scatterlist *sl;
     ulong32 cnt, blockcnt;
     ulong64 no, blockno;
-    dma_addr_t phys_addr;
     int i, cmd_index, read_write, sgcnt, mode64;
-    struct page *page;
-    ulong offset;
 
     cmdp = ha->pccb;
     TRACE(("gdth_fill_cache_cmd() cmd 0x%x cmdsize %d hdrive %d\n",
@@ -2552,17 +2601,17 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
             cmdp->u.cache.BlockCnt = blockcnt;
         }
 
-        if (scp->use_sg) {
-            sl = (struct scatterlist *)scp->request_buffer;
-            sgcnt = scp->use_sg;
-            scp->SCp.Status = GDTH_MAP_SG;
+        if (gdth_bufflen(scp)) {
             cmndinfo->dma_dir = (read_write == 1 ?
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);   
-            sgcnt = pci_map_sg(ha->pdev, sl, scp->use_sg, cmndinfo->dma_dir);
+            sgcnt = pci_map_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+                               cmndinfo->dma_dir);
             if (mode64) {
+                struct scatterlist *sl;
+
                 cmdp->u.cache64.DestAddr= (ulong64)-1;
                 cmdp->u.cache64.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
+                scsi_for_each_sg(scp, sl, sgcnt, i) {
                     cmdp->u.cache64.sg_lst[i].sg_ptr = sg_dma_address(sl);
 #ifdef GDTH_DMA_STATISTICS
                     if (cmdp->u.cache64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
@@ -2573,9 +2622,11 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
                     cmdp->u.cache64.sg_lst[i].sg_len = sg_dma_len(sl);
                 }
             } else {
+                struct scatterlist *sl;
+
                 cmdp->u.cache.DestAddr= 0xffffffff;
                 cmdp->u.cache.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
+                scsi_for_each_sg(scp, sl, sgcnt, i) {
                     cmdp->u.cache.sg_lst[i].sg_ptr = sg_dma_address(sl);
 #ifdef GDTH_DMA_STATISTICS
                     ha->dma32_cnt++;
@@ -2591,38 +2642,6 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
             }
 #endif
 
-        } else if (scp->request_bufflen) {
-            scp->SCp.Status = GDTH_MAP_SINGLE;
-            cmndinfo->dma_dir = (read_write == 1 ?
-                PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
-            page = virt_to_page(scp->request_buffer);
-            offset = (ulong)scp->request_buffer & ~PAGE_MASK;
-            phys_addr = pci_map_page(ha->pdev,page,offset,
-                                     scp->request_bufflen, cmndinfo->dma_dir);
-            scp->SCp.dma_handle = phys_addr;
-            if (mode64) {
-                if (ha->cache_feat & SCATTER_GATHER) {
-                    cmdp->u.cache64.DestAddr = (ulong64)-1;
-                    cmdp->u.cache64.sg_canz = 1;
-                    cmdp->u.cache64.sg_lst[0].sg_ptr = phys_addr;
-                    cmdp->u.cache64.sg_lst[0].sg_len = scp->request_bufflen;
-                    cmdp->u.cache64.sg_lst[1].sg_len = 0;
-                } else {
-                    cmdp->u.cache64.DestAddr  = phys_addr;
-                    cmdp->u.cache64.sg_canz= 0;
-                }
-            } else {
-                if (ha->cache_feat & SCATTER_GATHER) {
-                    cmdp->u.cache.DestAddr = 0xffffffff;
-                    cmdp->u.cache.sg_canz = 1;
-                    cmdp->u.cache.sg_lst[0].sg_ptr = phys_addr;
-                    cmdp->u.cache.sg_lst[0].sg_len = scp->request_bufflen;
-                    cmdp->u.cache.sg_lst[1].sg_len = 0;
-                } else {
-                    cmdp->u.cache.DestAddr  = phys_addr;
-                    cmdp->u.cache.sg_canz= 0;
-                }
-            }
         }
     }
     /* evaluate command size, check space */
@@ -2665,9 +2684,8 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
 {
     register gdth_cmd_str *cmdp;
-    struct scatterlist *sl;
     ushort i;
-    dma_addr_t phys_addr, sense_paddr;
+    dma_addr_t sense_paddr;
     int cmd_index, sgcnt, mode64;
     unchar t,l;
     struct page *page;
@@ -2733,7 +2751,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             cmdp->u.raw64.lun        = l;
             cmdp->u.raw64.bus        = b;
             cmdp->u.raw64.priority   = 0;
-            cmdp->u.raw64.sdlen      = scp->request_bufflen;
+            cmdp->u.raw64.sdlen      = gdth_bufflen(scp);
             cmdp->u.raw64.sense_len  = 16;
             cmdp->u.raw64.sense_data = sense_paddr;
             cmdp->u.raw64.direction  = 
@@ -2750,7 +2768,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             cmdp->u.raw.bus        = b;
             cmdp->u.raw.priority   = 0;
             cmdp->u.raw.link_p     = 0;
-            cmdp->u.raw.sdlen      = scp->request_bufflen;
+            cmdp->u.raw.sdlen      = gdth_bufflen(scp);
             cmdp->u.raw.sense_len  = 16;
             cmdp->u.raw.sense_data = sense_paddr;
             cmdp->u.raw.direction  = 
@@ -2759,16 +2777,16 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             cmdp->u.raw.sg_ranz    = 0;
         }
 
-        if (scp->use_sg) {
-            sl = (struct scatterlist *)scp->request_buffer;
-            sgcnt = scp->use_sg;
-            scp->SCp.Status = GDTH_MAP_SG;
+        if (gdth_bufflen(scp)) {
             cmndinfo->dma_dir = PCI_DMA_BIDIRECTIONAL;
-            sgcnt = pci_map_sg(ha->pdev,sl, scp->use_sg, cmndinfo->dma_dir);
+            sgcnt = pci_map_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+                               cmndinfo->dma_dir);
             if (mode64) {
+                struct scatterlist *sl;
+
                 cmdp->u.raw64.sdata = (ulong64)-1;
                 cmdp->u.raw64.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
+                scsi_for_each_sg(scp, sl, sgcnt, i) {
                     cmdp->u.raw64.sg_lst[i].sg_ptr = sg_dma_address(sl);
 #ifdef GDTH_DMA_STATISTICS
                     if (cmdp->u.raw64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
@@ -2779,9 +2797,11 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
                     cmdp->u.raw64.sg_lst[i].sg_len = sg_dma_len(sl);
                 }
             } else {
+                struct scatterlist *sl;
+
                 cmdp->u.raw.sdata = 0xffffffff;
                 cmdp->u.raw.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
+                scsi_for_each_sg(scp, sl, sgcnt, i) {
                     cmdp->u.raw.sg_lst[i].sg_ptr = sg_dma_address(sl);
 #ifdef GDTH_DMA_STATISTICS
                     ha->dma32_cnt++;
@@ -2797,38 +2817,6 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             }
 #endif
 
-        } else if (scp->request_bufflen) {
-            scp->SCp.Status = GDTH_MAP_SINGLE;
-            cmndinfo->dma_dir = PCI_DMA_BIDIRECTIONAL;
-            page = virt_to_page(scp->request_buffer);
-            offset = (ulong)scp->request_buffer & ~PAGE_MASK;
-            phys_addr = pci_map_page(ha->pdev,page,offset,
-                                     scp->request_bufflen, cmndinfo->dma_dir);
-            scp->SCp.dma_handle = phys_addr;
-
-            if (mode64) {
-                if (ha->raw_feat & SCATTER_GATHER) {
-                    cmdp->u.raw64.sdata  = (ulong64)-1;
-                    cmdp->u.raw64.sg_ranz= 1;
-                    cmdp->u.raw64.sg_lst[0].sg_ptr = phys_addr;
-                    cmdp->u.raw64.sg_lst[0].sg_len = scp->request_bufflen;
-                    cmdp->u.raw64.sg_lst[1].sg_len = 0;
-                } else {
-                    cmdp->u.raw64.sdata  = phys_addr;
-                    cmdp->u.raw64.sg_ranz= 0;
-                }
-            } else {
-                if (ha->raw_feat & SCATTER_GATHER) {
-                    cmdp->u.raw.sdata  = 0xffffffff;
-                    cmdp->u.raw.sg_ranz= 1;
-                    cmdp->u.raw.sg_lst[0].sg_ptr = phys_addr;
-                    cmdp->u.raw.sg_lst[0].sg_len = scp->request_bufflen;
-                    cmdp->u.raw.sg_lst[1].sg_len = 0;
-                } else {
-                    cmdp->u.raw.sdata  = phys_addr;
-                    cmdp->u.raw.sg_ranz= 0;
-                }
-            }
         }
         if (mode64) {
             TRACE(("raw cmd: addr. %x sganz %x sgptr0 %x sglen0 %x\n",
@@ -2877,7 +2865,7 @@ static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     if (ha->type==GDT_EISA && ha->cmd_cnt>0) 
         return 0;
 
-    memcpy( cmdp, scp->request_buffer, sizeof(gdth_cmd_str));
+    gdth_copy_internal_data(ha, scp, (char *)cmdp, sizeof(gdth_cmd_str), 1);
     cmdp->RequestBuffer = scp;
 
     /* search free command index */
@@ -3406,12 +3394,10 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
             /* retry */
             return 2;
         }
-        if (scp->SCp.Status == GDTH_MAP_SG) 
-            pci_unmap_sg(ha->pdev,scp->request_buffer,
-                         scp->use_sg, cmndinfo->dma_dir);
-        else if (scp->SCp.Status == GDTH_MAP_SINGLE) 
-            pci_unmap_page(ha->pdev,scp->SCp.dma_handle,
-                           scp->request_bufflen, cmndinfo->dma_dir);
+        if (gdth_bufflen(scp))
+            pci_unmap_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+                         cmndinfo->dma_dir);
+
         if (cmndinfo->sense_paddr)
             pci_unmap_page(ha->pdev, cmndinfo->sense_paddr, 16,
                                                            PCI_DMA_FROMDEVICE);
@@ -4048,6 +4034,11 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
     scp->scsi_done = done;
     gdth_update_timeout(scp, scp->timeout_per_command * 6);
     cmndinfo->priority = DEFAULT_PRI;
+
+    gdth_set_bufflen(scp, scsi_bufflen(scp));
+    gdth_set_sg_count(scp, scsi_sg_count(scp));
+    gdth_set_sglist(scp, scsi_sglist(scp));
+
     return __gdth_queuecommand(ha, scp, cmndinfo);
 }
 
@@ -4058,7 +4049,6 @@ static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
     cmndinfo->wait_for_completion = 1;
     cmndinfo->phase = -1;
     cmndinfo->OpCode = -1;
-    scp->SCp.Status = GDTH_MAP_NONE;
 
 #ifdef GDTH_STATISTICS
     ++act_ios;
@@ -4628,7 +4618,6 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
             return -ENOMEM;
         scp->device = ha->sdev;
         scp->cmd_len = 12;
-        scp->use_sg = 0;
         scp->device->channel = res.number;
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 25803a8..1434c6b 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -303,15 +303,8 @@
 #define MAILBOXREG      0x0c90                  /* mailbox reg. (16 bytes) */
 #define EISAREG         0x0cc0                  /* EISA configuration */
 
-/* DMA memory mappings */
-#define GDTH_MAP_NONE   0
-#define GDTH_MAP_SINGLE 1
-#define GDTH_MAP_SG     2
-#define GDTH_MAP_IOCTL  3 
-
 /* other defines */
 #define LINUX_OS        8                       /* used for cache optim. */
-#define SCATTER_GATHER  1                       /* s/g feature */
 #define SECS32          0x1f                    /* round capacity */
 #define BIOS_ID_OFFS    0x10                    /* offset contr-ID in ISABIOS */
 #define LOCALBOARD      0                       /* board node always 0 */
-- 
1.5.3.1


