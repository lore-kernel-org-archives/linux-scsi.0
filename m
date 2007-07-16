From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 25/33] gdth: sg chaining support
Date: Mon, 16 Jul 2007 11:47:39 +0200
Message-ID: <11845792684097-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9352 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760032AbXGPJsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:42 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, achim_leubner@adaptec.com

Cc: achim_leubner@adaptec.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/gdth.c |   45 +++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d0b95ce..7225c95 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2656,7 +2656,7 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
 {
     ushort cpcount,i;
     ushort cpsum,cpnow;
-    struct scatterlist *sl;
+    struct scatterlist *sl, *sg;
     gdth_ha_str *ha;
     char *address;
 
@@ -2665,29 +2665,30 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
 
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
-        for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
+	cpsum = 0;
+	for_each_sg(sl, sg, scp->use_sg, i) {
             unsigned long flags;
-            cpnow = (ushort)sl->length;
+            cpnow = (ushort)sg->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
                           cpnow,cpsum,cpcount,(ushort)scp->bufflen));
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
-            if (!sl->page) {
+            if (!sg->page) {
                 printk("GDT-HA %d: invalid sc/gt element in gdth_copy_internal_data()\n",
                        hanum);
                 return;
             }
             local_irq_save(flags);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
+            address = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
             memcpy(address,buffer,cpnow);
-            flush_dcache_page(sl->page);
+            flush_dcache_page(sg->page);
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
 #else
-            address = kmap_atomic(sl->page, KM_BH_IRQ) + sl->offset;
+            address = kmap_atomic(sg->page, KM_BH_IRQ) + sg->offset;
             memcpy(address,buffer,cpnow);
-            flush_dcache_page(sl->page);
+            flush_dcache_page(sg->page);
             kunmap_atomic(address, KM_BH_IRQ);
 #endif
             local_irq_restore(flags);
@@ -2807,7 +2808,7 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
 {
     register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
-    struct scatterlist *sl;
+    struct scatterlist *sl, *sg;
     ulong32 cnt, blockcnt;
     ulong64 no, blockno;
     dma_addr_t phys_addr;
@@ -2913,25 +2914,25 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
             if (mode64) {
                 cmdp->u.cache64.DestAddr= (ulong64)-1;
                 cmdp->u.cache64.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.cache64.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.cache64.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     if (cmdp->u.cache64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
                         ha->dma64_cnt++;
                     else
                         ha->dma32_cnt++;
 #endif
-                    cmdp->u.cache64.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.cache64.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             } else {
                 cmdp->u.cache.DestAddr= 0xffffffff;
                 cmdp->u.cache.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.cache.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.cache.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     ha->dma32_cnt++;
 #endif
-                    cmdp->u.cache.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.cache.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             }
 
@@ -3017,7 +3018,7 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
 {
     register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
-    struct scatterlist *sl;
+    struct scatterlist *sl, *sg;
     ushort i;
     dma_addr_t phys_addr, sense_paddr;
     int cmd_index, sgcnt, mode64;
@@ -3120,25 +3121,25 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
             if (mode64) {
                 cmdp->u.raw64.sdata = (ulong64)-1;
                 cmdp->u.raw64.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.raw64.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.raw64.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     if (cmdp->u.raw64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
                         ha->dma64_cnt++;
                     else
                         ha->dma32_cnt++;
 #endif
-                    cmdp->u.raw64.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.raw64.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             } else {
                 cmdp->u.raw.sdata = 0xffffffff;
                 cmdp->u.raw.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.raw.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.raw.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     ha->dma32_cnt++;
 #endif
-                    cmdp->u.raw.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.raw.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             }
 
-- 
1.5.3.rc0.90.gbaa79

