From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] gdth: remove gdth cooked up command accessors
Date: Wed, 27 Feb 2008 15:31:20 -0800
Message-ID: <47C5F2C8.6090702@panasas.com>
References: <47C5EF80.4080600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:54841 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYB0Wby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 17:31:54 -0500
Received: by wr-out-0506.google.com with SMTP id c48so4524705wra.23
        for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 14:31:53 -0800 (PST)
In-Reply-To: <47C5EF80.4080600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>


Last patch rendered these, to stupid status. So bye bye

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain: <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
---
 drivers/scsi/gdth.c |   73 ++++++++++-----------------------------------------
 1 files changed, 14 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 077f972..cfce0fe 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -85,10 +85,10 @@
 
 /* The meaning of the Scsi_Pointer members in this driver is as follows:
  * ptr:                     Chaining
- * this_residual:           gdth_bufflen
- * buffer:                  gdth_sglist
+ * this_residual:           unused
+ * buffer:                  unused
  * dma_handle:              unused
- * buffers_residual:        gdth_sg_count
+ * buffers_residual:        unused
  * Status:                  unused
  * Message:                 unused
  * have_data_in:            unused
@@ -373,47 +373,6 @@ static const struct file_operations gdth_fops = {
     .release = gdth_close,
 };
 
-/*
- * gdth scsi_command access wrappers.
- *   below 6 functions are used throughout the driver to access scsi_command's
- *   io parameters. The reason we do not use the regular accessors from
- *   scsi_cmnd.h is because of gdth_execute(). Since it is unrecommended for
- *   llds to directly set scsi_cmnd's IO members. This driver will use SCp
- *   members for IO parameters, and will copy scsi_cmnd's members to Scp
- *   members in queuecommand. For internal commands through gdth_execute()
- *   SCp's members will be set directly.
- */
-static inline unsigned gdth_bufflen(struct scsi_cmnd *cmd)
-{
-	return (unsigned)cmd->SCp.this_residual;
-}
-
-static inline void gdth_set_bufflen(struct scsi_cmnd *cmd, unsigned bufflen)
-{
-	cmd->SCp.this_residual = bufflen;
-}
-
-static inline unsigned gdth_sg_count(struct scsi_cmnd *cmd)
-{
-	return (unsigned)cmd->SCp.buffers_residual;
-}
-
-static inline void gdth_set_sg_count(struct scsi_cmnd *cmd, unsigned sg_count)
-{
-	cmd->SCp.buffers_residual = sg_count;
-}
-
-static inline struct scatterlist *gdth_sglist(struct scsi_cmnd *cmd)
-{
-	return cmd->SCp.buffer;
-}
-
-static inline void gdth_set_sglist(struct scsi_cmnd *cmd,
-                                   struct scatterlist *sglist)
-{
-	cmd->SCp.buffer = sglist;
-}
-
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
@@ -2349,12 +2308,12 @@ static void gdth_next(gdth_ha_str *ha)
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                                     char *buffer, ushort count)
 {
-    ushort cpcount,i, max_sg = gdth_sg_count(scp);
+    ushort cpcount,i, max_sg = scsi_sg_count(scp);
     ushort cpsum,cpnow;
     struct scatterlist *sl;
     char *address;
 
-    cpcount = min_t(ushort, count, gdth_bufflen(scp));
+    cpcount = min_t(ushort, count, scsi_bufflen(scp));
 
     if (cpcount) {
         cpsum=0;
@@ -2362,7 +2321,7 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
             unsigned long flags;
             cpnow = (ushort)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
-                          cpnow, cpsum, cpcount, gdth_bufflen(scp)));
+                          cpnow, cpsum, cpcount, scsi_bufflen(scp)));
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
@@ -2585,10 +2544,10 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
             cmdp->u.cache.BlockCnt = blockcnt;
         }
 
-        if (gdth_bufflen(scp)) {
+        if (scsi_bufflen(scp)) {
             cmndinfo->dma_dir = (read_write == 1 ?
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);   
-            sgcnt = pci_map_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                                cmndinfo->dma_dir);
             if (mode64) {
                 struct scatterlist *sl;
@@ -2735,7 +2694,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             cmdp->u.raw64.lun        = l;
             cmdp->u.raw64.bus        = b;
             cmdp->u.raw64.priority   = 0;
-            cmdp->u.raw64.sdlen      = gdth_bufflen(scp);
+            cmdp->u.raw64.sdlen      = scsi_bufflen(scp);
             cmdp->u.raw64.sense_len  = 16;
             cmdp->u.raw64.sense_data = sense_paddr;
             cmdp->u.raw64.direction  = 
@@ -2752,7 +2711,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             cmdp->u.raw.bus        = b;
             cmdp->u.raw.priority   = 0;
             cmdp->u.raw.link_p     = 0;
-            cmdp->u.raw.sdlen      = gdth_bufflen(scp);
+            cmdp->u.raw.sdlen      = scsi_bufflen(scp);
             cmdp->u.raw.sense_len  = 16;
             cmdp->u.raw.sense_data = sense_paddr;
             cmdp->u.raw.direction  = 
@@ -2761,9 +2720,9 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             cmdp->u.raw.sg_ranz    = 0;
         }
 
-        if (gdth_bufflen(scp)) {
+        if (scsi_bufflen(scp)) {
             cmndinfo->dma_dir = PCI_DMA_BIDIRECTIONAL;
-            sgcnt = pci_map_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                                cmndinfo->dma_dir);
             if (mode64) {
                 struct scatterlist *sl;
@@ -3383,8 +3342,8 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
             /* retry */
             return 2;
         }
-        if (gdth_bufflen(scp))
-            pci_unmap_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+        if (scsi_bufflen(scp))
+            pci_unmap_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                          cmndinfo->dma_dir);
 
         if (cmndinfo->sense_paddr)
@@ -4026,10 +3985,6 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
     gdth_update_timeout(scp, scp->timeout_per_command * 6);
     cmndinfo->priority = DEFAULT_PRI;
 
-    gdth_set_bufflen(scp, scsi_bufflen(scp));
-    gdth_set_sg_count(scp, scsi_sg_count(scp));
-    gdth_set_sglist(scp, scsi_sglist(scp));
-
     return __gdth_queuecommand(ha, scp, cmndinfo);
 }
 
-- 
1.5.3.3

