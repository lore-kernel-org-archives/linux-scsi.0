From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 4/4] gdth: Isolate driver-global variables using helpers
Date: Fri, 20 Jul 2007 22:23:03 -0400
Message-ID: <20070721022303.GD7264@havoc.gtf.org>
References: <20070721022032.GA7264@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:57139 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758947AbXGUCbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 22:31:08 -0400
Content-Disposition: inline
In-Reply-To: <20070721022032.GA7264@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>


commit fa82107fcc8bb738d3be1a0786302d54d483900f
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Jul 20 22:13:36 2007 -0400

    [SCSI] gdth: Isolate driver-global variables using helpers
    
    Sanitizes access to some driver-global variables, in preparation for
    making them dynamic rather than statically-sized.
    
    This equivalent-transform style change blissfully ignores the fact that
    gdth_ctr_vtab[] is never used (only assigned), and that the driver
    itself seems to get a bit confused between gdth_ctr_count and
    gdth_ctr_vcount.  The whole virtual-controller stuff needs reviewing
    for edge cases.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/gdth.c      |  150 ++++++++++++++++++++++++++++-------------------
 drivers/scsi/gdth_proc.c |   16 ++---
 2 files changed, 99 insertions(+), 67 deletions(-)

fa82107fcc8bb738d3be1a0786302d54d483900f
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index bc8b40a..a6636b8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -394,6 +394,44 @@ static const struct file_operations gdth_fops = {
     .release = gdth_close,
 };
 
+static struct Scsi_Host *gdth_find_shp(int ha_idx)
+{
+	return gdth_ctr_tab[ha_idx];
+}
+
+static gdth_ha_str *gdth_find_ha(int ha_idx)
+{
+	struct Scsi_Host *shp = gdth_find_shp(ha_idx);
+	if (!shp)
+		return NULL;
+	return HADATA(shp);
+}
+
+static void gdth_push_vshp(struct Scsi_Host *shp)
+{
+	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+}
+
+static int gdth_push_shp(struct Scsi_Host *shp)
+{
+	int idx;
+
+	idx = gdth_ctr_count;
+	gdth_ctr_count++;
+
+	gdth_ctr_tab[idx] = shp;
+
+	gdth_push_vshp(shp);
+
+	return idx;
+}
+
+static void gdth_pop_shp(void)
+{
+	gdth_ctr_count--;
+	gdth_ctr_vcount--;
+}
+
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
@@ -1220,7 +1258,7 @@ static void __init gdth_enable_int(int hanum)
     gdt6m_dpram_str __iomem *dp6m_ptr;
 
     TRACE(("gdth_enable_int() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (ha->type == GDT_EISA) {
@@ -1260,7 +1298,7 @@ static int gdth_get_status(unchar *pIStatus,int irq)
     
     *pIStatus = 0;
     for (i=0; i<gdth_ctr_count; ++i) {
-        ha = HADATA(gdth_ctr_tab[i]);
+        ha = gdth_find_ha(i);
         if (ha->irq != (unchar)irq)             /* check IRQ */
             continue;
         if (ha->type == GDT_EISA)
@@ -1291,7 +1329,7 @@ static int gdth_test_busy(int hanum)
 
     TRACE(("gdth_test_busy() hanum %d\n",hanum));
     
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     if (ha->type == GDT_EISA)
         gdtsema0 = (int)inb(ha->bmic + SEMA0REG);
     else if (ha->type == GDT_ISA)
@@ -1315,7 +1353,7 @@ static int gdth_get_cmd_index(int hanum)
 
     TRACE(("gdth_get_cmd_index() hanum %d\n",hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     for (i=0; i<GDTH_MAXCMDS; ++i) {
         if (ha->cmd_tab[i].cmnd == UNUSED_CMND) {
             ha->cmd_tab[i].cmnd = ha->pccb->RequestBuffer;
@@ -1334,7 +1372,7 @@ static void gdth_set_sema0(int hanum)
 
     TRACE(("gdth_set_sema0() hanum %d\n",hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     if (ha->type == GDT_EISA) {
         outb(1, ha->bmic + SEMA0REG);
     } else if (ha->type == GDT_ISA) {
@@ -1361,7 +1399,7 @@ static void gdth_copy_command(int hanum)
     
     TRACE(("gdth_copy_command() hanum %d\n",hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     cp_count = ha->cmd_len;
     dp_offset= ha->cmd_offs_dpmem;
     cmd_no   = ha->cmd_cnt;
@@ -1415,7 +1453,7 @@ static void gdth_release_event(int hanum)
     register gdth_ha_str *ha;
 
     TRACE(("gdth_release_event() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
 
 #ifdef GDTH_STATISTICS
     {
@@ -1457,7 +1495,7 @@ static int gdth_wait(int hanum,int index,ulong32 time)
 
     TRACE(("gdth_wait() hanum %d index %d time %d\n",hanum,index,time));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     if (index == 0)
         return 1;                               /* no wait required */
 
@@ -1488,7 +1526,7 @@ static int gdth_internal_cmd(int hanum,unchar service,ushort opcode,ulong32 p1,
 
     TRACE2(("gdth_internal_cmd() service %d opcode %d\n",service,opcode));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     cmd_ptr = ha->pccb;
     memset((char*)cmd_ptr,0,sizeof(gdth_cmd_str));
 
@@ -1581,7 +1619,7 @@ static int __init gdth_search_drives(int hanum)
 #endif     
    
     TRACE(("gdth_search_drives() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     ok = 0;
 
     /* initialize controller services, at first: screen service */
@@ -1938,7 +1976,7 @@ static int gdth_analyse_hdrive(int hanum,ushort hdrive)
     TRACE(("gdth_analyse_hdrive() hanum %d drive %d\n",hanum,hdrive));
     if (hdrive >= MAX_HDRIVES)
         return 0;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
 
     if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_INFO,hdrive,0,0)) 
         return 0;
@@ -2005,7 +2043,7 @@ static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
     unchar b, t;
 
     TRACE(("gdth_putq() priority %d\n",priority));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (scp->done != gdth_scsi_done) {
@@ -2059,7 +2097,7 @@ static void gdth_next(int hanum)
     int cmd_index;
 
     TRACE(("gdth_next() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     if (!gdth_polling) 
         spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -2309,7 +2347,7 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
     char *address;
 
     cpcount = count<=(ushort)scp->request_bufflen ? count:(ushort)scp->request_bufflen;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
 
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
@@ -2351,7 +2389,7 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
     gdth_sense_data sd;
     gdth_modep_data mpd;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     t  = scp->device->id;
     TRACE(("gdth_internal_cache_cmd() cmd 0x%x hdrive %d\n",
            scp->cmnd[0],t));
@@ -2456,7 +2494,7 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     cmdp = ha->pccb;
     TRACE(("gdth_fill_cache_cmd() cmd 0x%x cmdsize %d hdrive %d\n",
                  scp->cmnd[0],scp->cmd_len,hdrive));
@@ -2666,7 +2704,7 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     t = scp->device->id;
     l = scp->device->lun;
     cmdp = ha->pccb;
@@ -2865,7 +2903,7 @@ static int gdth_special_cmd(int hanum,Scsi_Cmnd *scp)
     register gdth_cmd_str *cmdp;
     int cmd_index;
 
-    ha  = HADATA(gdth_ctr_tab[hanum]);
+    ha  = gdth_find_ha(hanum);
     cmdp= ha->pccb;
     TRACE2(("gdth_special_cmd(): "));
 
@@ -3087,7 +3125,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
             spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
     }
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
 
 #ifdef GDTH_STATISTICS
     ++act_ints;
@@ -3315,7 +3353,7 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
     gdth_cmd_str *cmdp;
     unchar b, t;
 
-    ha   = HADATA(gdth_ctr_tab[hanum]);
+    ha   = gdth_find_ha(hanum);
     cmdp = ha->pccb;
     TRACE(("gdth_sync_event() serv %d status %d\n",
            service,ha->status));
@@ -3686,7 +3724,7 @@ static int gdth_async_event(int hanum)
     gdth_cmd_str *cmdp;
     int cmd_index;
 
-    ha  = HADATA(gdth_ctr_tab[hanum]);
+    ha  = gdth_find_ha(hanum);
     cmdp= ha->pccb;
     TRACE2(("gdth_async_event() ha %d serv %d\n",
             hanum,ha->service));
@@ -3812,7 +3850,7 @@ static void gdth_timeout(ulong data)
     ulong flags;
     int hanum = 0;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (act_stats=0,i=0; i<GDTH_MAXCMDS; ++i) 
@@ -3965,9 +4003,7 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 	shp->unchecked_isa_dma = 1;
 	shp->irq = ha->irq;
 	shp->dma_channel = ha->drq;
-	hanum = gdth_ctr_count;         
-	gdth_ctr_tab[gdth_ctr_count++] = shp;
-	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+	hanum = gdth_push_shp(shp);
 
 	NUMDATA(shp)->hanum = (ushort)hanum;
 	NUMDATA(shp)->busnum= 0;
@@ -4001,8 +4037,7 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 	if (ha->pscratch == NULL || ha->pmsg == NULL || 
 	    !gdth_search_drives(hanum)) {
 		printk("GDT-ISA: Error during device scan\n");
-		--gdth_ctr_count;
-		--gdth_ctr_vcount;
+		gdth_pop_shp();
 
 #ifdef INT_COAL
 		if (ha->coal_stat)
@@ -4043,7 +4078,7 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 			shp->unchecked_isa_dma = 1;
 			shp->irq = ha->irq;
 			shp->dma_channel = ha->drq;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+			gdth_push_vshp(shp);
 			NUMDATA(shp)->hanum = (ushort)hanum;
 			NUMDATA(shp)->busnum = b;
 		}
@@ -4087,9 +4122,7 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
-	hanum = gdth_ctr_count;
-	gdth_ctr_tab[gdth_ctr_count++] = shp;
-	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+	hanum = gdth_push_shp(shp);
 
 	NUMDATA(shp)->hanum = (ushort)hanum;
 	NUMDATA(shp)->busnum= 0;
@@ -4129,8 +4162,8 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 	if (ha->pscratch == NULL || ha->pmsg == NULL || 
 	    !gdth_search_drives(hanum)) {
 		printk("GDT-EISA: Error during device scan\n");
-		--gdth_ctr_count;
-		--gdth_ctr_vcount;
+		gdth_pop_shp();
+
 #ifdef INT_COAL
 		if (ha->coal_stat)
 			pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
@@ -4171,7 +4204,7 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 			shp->unchecked_isa_dma = 0;
 			shp->irq = ha->irq;
 			shp->dma_channel = 0xff;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+			gdth_push_vshp(shp);
 			NUMDATA(shp)->hanum = (ushort)hanum;
 			NUMDATA(shp)->busnum = b;
 		}
@@ -4218,9 +4251,7 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
-	hanum = gdth_ctr_count;
-	gdth_ctr_tab[gdth_ctr_count++] = shp;
-	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+	hanum = gdth_push_shp(shp);
 
 	NUMDATA(shp)->hanum = (ushort)hanum;
 	NUMDATA(shp)->busnum= 0;
@@ -4285,8 +4316,7 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 
 	if (err) {
 		printk("GDT-PCI %d: Error during device scan\n", hanum);
-		--gdth_ctr_count;
-		--gdth_ctr_vcount;
+		gdth_pop_shp();
 
 #ifdef INT_COAL
 		if (ha->coal_stat)
@@ -4320,7 +4350,7 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 			shp->unchecked_isa_dma = 0;
 			shp->irq = ha->irq;
 			shp->dma_channel = 0xff;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+			gdth_push_vshp(shp);
 			NUMDATA(shp)->hanum = (ushort)hanum;
 			NUMDATA(shp)->busnum = b;
 		}
@@ -4433,7 +4463,7 @@ static int gdth_release(struct Scsi_Host *shp)
     TRACE2(("gdth_release()\n"));
     if (NUMDATA(shp)->busnum == 0) {
         hanum = NUMDATA(shp)->hanum;
-        ha    = HADATA(gdth_ctr_tab[hanum]);
+        ha    = gdth_find_ha(hanum);
         if (ha->sdev) {
             scsi_free_host_dev(ha->sdev);
             ha->sdev = NULL;
@@ -4486,7 +4516,7 @@ static const char *gdth_ctr_name(int hanum)
 
     TRACE2(("gdth_ctr_name()\n"));
 
-    ha    = HADATA(gdth_ctr_tab[hanum]);
+    ha    = gdth_find_ha(hanum);
 
     if (ha->type == GDT_EISA) {
         switch (ha->stype) {
@@ -4519,7 +4549,7 @@ static const char *gdth_info(struct Scsi_Host *shp)
 
     TRACE2(("gdth_info()\n"));
     hanum = NUMDATA(shp)->hanum;
-    ha    = HADATA(gdth_ctr_tab[hanum]);
+    ha    = gdth_find_ha(hanum);
 
     return ((const char *)ha->binfo.type_string);
 }
@@ -4536,7 +4566,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 
     hanum = NUMDATA(scp->device->host)->hanum;
     b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-    ha    = HADATA(gdth_ctr_tab[hanum]);
+    ha    = gdth_find_ha(hanum);
 
     /* clear command tab */
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -4592,7 +4622,7 @@ static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,se
     b = virt_ctr ? NUMDATA(sd->host)->busnum : sd->channel;
     t = sd->id;
     TRACE2(("gdth_bios_param() ha %d bus %d target %d\n", hanum, b, t)); 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
 
     if (b != ha->virt_bus || ha->hdr[t].heads == 0) {
         /* raw device or host drive without mapping information */
@@ -4643,13 +4673,15 @@ static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
 
 static int gdth_open(struct inode *inode, struct file *filep)
 {
+    struct Scsi_Host *shp;
     gdth_ha_str *ha;
     int i;
 
     for (i = 0; i < gdth_ctr_count; i++) {
-        ha = HADATA(gdth_ctr_tab[i]);
+	shp = gdth_find_shp(i);
+	ha = HADATA(shp);
         if (!ha->sdev)
-            ha->sdev = scsi_get_host_dev(gdth_ctr_tab[i]);
+            ha->sdev = scsi_get_host_dev(shp);
     }
 
     TRACE(("gdth_open()\n"));
@@ -4671,7 +4703,7 @@ static int ioc_event(void __user *arg)
     if (copy_from_user(&evt, arg, sizeof(gdth_ioctl_event)) ||
         evt.ionode >= gdth_ctr_count)
         return -EFAULT;
-    ha = HADATA(gdth_ctr_tab[evt.ionode]);
+    ha = gdth_find_ha(evt.ionode);
 
     if (evt.erase == 0xff) {
         if (evt.event.event_source == ES_TEST)
@@ -4708,7 +4740,7 @@ static int ioc_lockdrv(void __user *arg)
     if (copy_from_user(&ldrv, arg, sizeof(gdth_ioctl_lockdrv)) ||
         ldrv.ionode >= gdth_ctr_count)
         return -EFAULT;
-    ha = HADATA(gdth_ctr_tab[ldrv.ionode]);
+    ha = gdth_find_ha(ldrv.ionode);
  
     for (i = 0; i < ldrv.drive_cnt && i < MAX_HDRIVES; ++i) {
         j = ldrv.drives[i];
@@ -4743,7 +4775,7 @@ static int ioc_resetdrv(void __user *arg, char *cmnd)
         res.ionode >= gdth_ctr_count || res.number >= MAX_HDRIVES)
         return -EFAULT;
     hanum = res.ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
  
     if (!ha->hdr[res.number].present)
         return 0;
@@ -4778,7 +4810,7 @@ static int ioc_general(void __user *arg, char *cmnd)
         gen.ionode >= gdth_ctr_count)
         return -EFAULT;
     hanum = gen.ionode; 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     if (gen.data_len + gen.sense_len != 0) {
         if (!(buf = gdth_ioctl_alloc(hanum, gen.data_len + gen.sense_len, 
                                      FALSE, &paddr)))
@@ -4903,7 +4935,7 @@ static int ioc_hdrlist(void __user *arg, char *cmnd)
         goto free_fail;
     }
     hanum = rsc->ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     memset(cmd, 0, sizeof(gdth_cmd_str));
    
     for (i = 0; i < MAX_HDRIVES; ++i) { 
@@ -4960,7 +4992,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         goto free_fail;
     }
     hanum = rsc->ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     memset(cmd, 0, sizeof(gdth_cmd_str));
 
     if (rsc->flag == 0) {
@@ -5119,7 +5151,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         if (copy_from_user(&ctrt, argp, sizeof(gdth_ioctl_ctrtype)) ||
             ctrt.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[ctrt.ionode]);
+        ha = gdth_find_ha(ctrt.ionode);
         if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
             ctrt.type = (unchar)((ha->stype>>20) - 0x10);
         } else {
@@ -5160,7 +5192,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         if (copy_from_user(&lchn, argp, sizeof(gdth_ioctl_lockchn)) ||
             lchn.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[lchn.ionode]);
+        ha = gdth_find_ha(lchn.ionode);
         
         i = lchn.channel;
         if (i < ha->bus_cnt) {
@@ -5200,7 +5232,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
             res.ionode >= gdth_ctr_count)
             return -EFAULT;
         hanum = res.ionode; 
-        ha = HADATA(gdth_ctr_tab[hanum]);
+        ha = gdth_find_ha(hanum);
 
         scp  = kmalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
@@ -5239,7 +5271,7 @@ static void gdth_flush(int hanum)
     memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 
     TRACE2(("gdth_flush() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
 
     for (i = 0; i < MAX_HDRIVES; ++i) {
         if (ha->hdr[i].present) {
@@ -5257,7 +5289,7 @@ static void gdth_flush(int hanum)
             }
             TRACE2(("gdth_flush(): flush ha %d drive %d\n", hanum, i));
 
-            gdth_execute(gdth_ctr_tab[hanum], &gdtcmd, cmnd, 30, NULL);
+            gdth_execute(gdth_find_shp(hanum), &gdtcmd, cmnd, 30, NULL);
         }
     }
 }
@@ -5290,7 +5322,7 @@ static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
         gdtcmd.Service = CACHESERVICE;
         gdtcmd.OpCode = GDT_RESET;
         TRACE2(("gdth_halt(): reset controller %d\n", hanum));
-        gdth_execute(gdth_ctr_tab[hanum], &gdtcmd, cmnd, 10, NULL);
+        gdth_execute(gdth_find_shp(hanum), &gdtcmd, cmnd, 10, NULL);
 #endif
     }
     printk("Done.\n");
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 5fccb15..0c7696f 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -54,7 +54,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
     memset(&gdtcmd, 0, sizeof(gdth_cmd_str));
 
     TRACE2(("gdth_set_asc_info() ha %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     orig_length = length + 5;
     drive = -1;
     wb_mode = 0;
@@ -188,7 +188,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     memset(gdtcmd, 0, sizeof(gdth_cmd_str));
 
     TRACE2(("gdth_get_info() ha %d bus %d\n",hanum,busnum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
 
     
     /* request is i.e. "cat /proc/scsi/gdth/0" */ 
@@ -682,7 +682,7 @@ static char *gdth_ioctl_alloc(int hanum, int size, int scratch,
     if (size == 0)
         return NULL;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (!ha->scratch_busy && size <= GDTH_SCRATCH) {
@@ -707,7 +707,7 @@ static void gdth_ioctl_free(int hanum, int size, char *buf, ulong64 paddr)
     gdth_ha_str *ha;
     ulong flags;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (buf == ha->pscratch) {
@@ -726,7 +726,7 @@ static int gdth_ioctl_check_bin(int hanum, ushort size)
     ulong flags;
     int ret_val;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     ret_val = FALSE;
@@ -747,7 +747,7 @@ static void gdth_wait_completion(int hanum, int busnum, int id)
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
@@ -774,7 +774,7 @@ static void gdth_stop_timeout(int hanum, int busnum, int id)
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
@@ -798,7 +798,7 @@ static void gdth_start_timeout(int hanum, int busnum, int id)
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = gdth_find_ha(hanum);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
