From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] gdth: clean up host private data
Date: Sat, 21 Jul 2007 19:02:09 +0200
Message-ID: <20070721170209.GG4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:58108 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbXGURCT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 13:02:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: leubner@adaptec.com, jeff@garzik.org, linux-scsi@vger.kernel.org

Get rid of all the indirection in the Scsi_Host private data and always
but the gdth_ha_str directly into it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/gdth.h
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.h	2007-07-21 12:40:41.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.h	2007-07-21 18:50:15.000000000 +0200
@@ -853,6 +853,8 @@ typedef struct {
 
 /* controller information structure */
 typedef struct {
+    struct Scsi_Host    *shost;
+    ushort      	hanum;
     ushort              oem_id;                 /* OEM */
     ushort              type;                   /* controller class */
     ulong32             stype;                  /* subtype (PCI: device ID) */
@@ -864,6 +866,7 @@ typedef struct {
     void __iomem        *brd;                   /* DPRAM address */
     ulong32             brd_phys;               /* slot number/BIOS address */
     gdt6c_plx_regs      *plx;                   /* PLX regs (new PCI contr.) */
+    gdth_cmd_str        cmdext;
     gdth_cmd_str        *pccb;                  /* address command structure */
     ulong32             ccb_phys;               /* phys. address */
 #ifdef INT_COAL
@@ -937,19 +940,6 @@ typedef struct {
     struct scsi_device         *sdev;
 } gdth_ha_str;
 
-/* structure for scsi_register(), SCSI bus != 0 */
-typedef struct {
-    ushort      hanum;
-} gdth_num_str;
-
-/* structure for scsi_register() */
-typedef struct {
-    gdth_num_str        numext;                 /* must be the first element */
-    gdth_ha_str         haext;
-    gdth_cmd_str        cmdext;
-} gdth_ext_str;
-
-
 /* INQUIRY data format */
 typedef struct {
     unchar      type_qual;
Index: linux-2.6/drivers/scsi/gdth_proc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth_proc.c	2007-07-21 12:40:41.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth_proc.c	2007-07-21 12:53:44.000000000 +0200
@@ -7,17 +7,15 @@
 int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offset,int length,   
                    int inout)
 {
-    int hanum;
+    gdth_ha_str *ha = shost_priv(host);
 
     TRACE2(("gdth_proc_info() length %d offs %d inout %d\n",
             length,(int)offset,inout));
 
-    hanum = NUMDATA(host)->hanum;
-
     if (inout)
-        return(gdth_set_info(buffer,length,host,hanum));
+        return(gdth_set_info(buffer,length,host,ha->hanum));
     else
-        return(gdth_get_info(buffer,start,offset,length,host,hanum));
+        return(gdth_get_info(buffer,start,offset,length,host,ha->hanum));
 }
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
@@ -53,7 +51,7 @@ static int gdth_set_asc_info(struct Scsi
     memset(&gdtcmd, 0, sizeof(gdth_cmd_str));
 
     TRACE2(("gdth_set_asc_info() ha %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     orig_length = length + 5;
     drive = -1;
     wb_mode = 0;
@@ -187,7 +185,7 @@ static int gdth_get_info(char *buffer,ch
     memset(gdtcmd, 0, sizeof(gdth_cmd_str));
 
     TRACE2(("gdth_get_info() ha %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
 
     
     /* request is i.e. "cat /proc/scsi/gdth/0" */ 
@@ -678,7 +676,7 @@ static char *gdth_ioctl_alloc(int hanum,
     if (size == 0)
         return NULL;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (!ha->scratch_busy && size <= GDTH_SCRATCH) {
@@ -703,7 +701,7 @@ static void gdth_ioctl_free(int hanum, i
     gdth_ha_str *ha;
     ulong flags;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (buf == ha->pscratch) {
@@ -722,7 +720,7 @@ static int gdth_ioctl_check_bin(int hanu
     ulong flags;
     int ret_val;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     ret_val = FALSE;
@@ -743,7 +741,7 @@ static void gdth_wait_completion(int han
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
@@ -770,7 +768,7 @@ static void gdth_stop_timeout(int hanum,
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
@@ -793,7 +791,7 @@ static void gdth_start_timeout(int hanum
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c	2007-07-21 12:41:12.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.c	2007-07-21 18:50:15.000000000 +0200
@@ -295,10 +295,6 @@ static struct timer_list gdth_timer;
 #define GDTOFFSOF(a,b)  (size_t)&(((a*)0)->b)
 #define INDEX_OK(i,t)   ((i)<ARRAY_SIZE(t))
 
-#define NUMDATA(a)      ( (gdth_num_str  *)((a)->hostdata))
-#define HADATA(a)       (&((gdth_ext_str *)((a)->hostdata))->haext)
-#define CMDDATA(a)      (&((gdth_ext_str *)((a)->hostdata))->cmdext)
-
 #define BUS_L2P(a,b)    ((b)>(a)->virt_bus ? (b-1):(b))
 
 #define gdth_readb(addr)        readb(addr)
@@ -1222,7 +1218,7 @@ static void __init gdth_enable_int(int h
     gdt6m_dpram_str __iomem *dp6m_ptr;
 
     TRACE(("gdth_enable_int() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (ha->type == GDT_EISA) {
@@ -1262,7 +1258,7 @@ static int gdth_get_status(unchar *pISta
     
     *pIStatus = 0;
     for (i=0; i<gdth_ctr_count; ++i) {
-        ha = HADATA(gdth_ctr_tab[i]);
+        ha = shost_priv(gdth_ctr_tab[i]);
         if (ha->irq != (unchar)irq)             /* check IRQ */
             continue;
         if (ha->type == GDT_EISA)
@@ -1293,7 +1289,7 @@ static int gdth_test_busy(int hanum)
 
     TRACE(("gdth_test_busy() hanum %d\n",hanum));
     
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     if (ha->type == GDT_EISA)
         gdtsema0 = (int)inb(ha->bmic + SEMA0REG);
     else if (ha->type == GDT_ISA)
@@ -1317,7 +1313,7 @@ static int gdth_get_cmd_index(int hanum)
 
     TRACE(("gdth_get_cmd_index() hanum %d\n",hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     for (i=0; i<GDTH_MAXCMDS; ++i) {
         if (ha->cmd_tab[i].cmnd == UNUSED_CMND) {
             ha->cmd_tab[i].cmnd = ha->pccb->RequestBuffer;
@@ -1336,7 +1332,7 @@ static void gdth_set_sema0(int hanum)
 
     TRACE(("gdth_set_sema0() hanum %d\n",hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     if (ha->type == GDT_EISA) {
         outb(1, ha->bmic + SEMA0REG);
     } else if (ha->type == GDT_ISA) {
@@ -1363,7 +1359,7 @@ static void gdth_copy_command(int hanum)
     
     TRACE(("gdth_copy_command() hanum %d\n",hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     cp_count = ha->cmd_len;
     dp_offset= ha->cmd_offs_dpmem;
     cmd_no   = ha->cmd_cnt;
@@ -1417,7 +1413,7 @@ static void gdth_release_event(int hanum
     register gdth_ha_str *ha;
 
     TRACE(("gdth_release_event() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
 
 #ifdef GDTH_STATISTICS
     {
@@ -1459,7 +1455,7 @@ static int gdth_wait(int hanum,int index
 
     TRACE(("gdth_wait() hanum %d index %d time %d\n",hanum,index,time));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     if (index == 0)
         return 1;                               /* no wait required */
 
@@ -1490,7 +1486,7 @@ static int gdth_internal_cmd(int hanum,u
 
     TRACE2(("gdth_internal_cmd() service %d opcode %d\n",service,opcode));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     cmd_ptr = ha->pccb;
     memset((char*)cmd_ptr,0,sizeof(gdth_cmd_str));
 
@@ -1583,7 +1579,7 @@ static int __init gdth_search_drives(int
 #endif     
    
     TRACE(("gdth_search_drives() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     ok = 0;
 
     /* initialize controller services, at first: screen service */
@@ -1940,7 +1936,7 @@ static int gdth_analyse_hdrive(int hanum
     TRACE(("gdth_analyse_hdrive() hanum %d drive %d\n",hanum,hdrive));
     if (hdrive >= MAX_HDRIVES)
         return 0;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
 
     if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_INFO,hdrive,0,0)) 
         return 0;
@@ -2007,7 +2003,7 @@ static void gdth_putq(int hanum,Scsi_Cmn
     unchar b, t;
 
     TRACE(("gdth_putq() priority %d\n",priority));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (scp->done != gdth_scsi_done) {
@@ -2061,7 +2057,7 @@ static void gdth_next(int hanum)
     int cmd_index;
 
     TRACE(("gdth_next() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     if (!gdth_polling) 
         spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -2310,7 +2306,7 @@ static void gdth_copy_internal_data(int 
     char *address;
 
     cpcount = count<=(ushort)scp->request_bufflen ? count:(ushort)scp->request_bufflen;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
 
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
@@ -2352,7 +2348,7 @@ static int gdth_internal_cache_cmd(int h
     gdth_sense_data sd;
     gdth_modep_data mpd;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     t  = scp->device->id;
     TRACE(("gdth_internal_cache_cmd() cmd 0x%x hdrive %d\n",
            scp->cmnd[0],t));
@@ -2457,7 +2453,7 @@ static int gdth_fill_cache_cmd(int hanum
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     cmdp = ha->pccb;
     TRACE(("gdth_fill_cache_cmd() cmd 0x%x cmdsize %d hdrive %d\n",
                  scp->cmnd[0],scp->cmd_len,hdrive));
@@ -2667,7 +2663,7 @@ static int gdth_fill_raw_cmd(int hanum,S
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     t = scp->device->id;
     l = scp->device->lun;
     cmdp = ha->pccb;
@@ -2866,7 +2862,7 @@ static int gdth_special_cmd(int hanum,Sc
     register gdth_cmd_str *cmdp;
     int cmd_index;
 
-    ha  = HADATA(gdth_ctr_tab[hanum]);
+    ha  = shost_priv(gdth_ctr_tab[hanum]);
     cmdp= ha->pccb;
     TRACE2(("gdth_special_cmd(): "));
 
@@ -3088,7 +3084,7 @@ static irqreturn_t gdth_interrupt(int ir
             spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
     }
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
 
 #ifdef GDTH_STATISTICS
     ++act_ints;
@@ -3316,7 +3312,7 @@ static int gdth_sync_event(int hanum,int
     gdth_cmd_str *cmdp;
     unchar b, t;
 
-    ha   = HADATA(gdth_ctr_tab[hanum]);
+    ha   = shost_priv(gdth_ctr_tab[hanum]);
     cmdp = ha->pccb;
     TRACE(("gdth_sync_event() serv %d status %d\n",
            service,ha->status));
@@ -3687,7 +3683,7 @@ static int gdth_async_event(int hanum)
     gdth_cmd_str *cmdp;
     int cmd_index;
 
-    ha  = HADATA(gdth_ctr_tab[hanum]);
+    ha  = shost_priv(gdth_ctr_tab[hanum]);
     cmdp= ha->pccb;
     TRACE2(("gdth_async_event() ha %d serv %d\n",
             hanum,ha->service));
@@ -3813,7 +3809,7 @@ static void gdth_timeout(ulong data)
     ulong flags;
     int hanum = 0;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (act_stats=0,i=0; i<GDTH_MAXCMDS; ++i) 
@@ -4012,12 +4008,10 @@ static int __init gdth_detect(struct scs
 
 static int gdth_release(struct Scsi_Host *shp)
 {
-    int hanum;
-    gdth_ha_str *ha;
+    gdth_ha_str *ha = shost_priv(shp);
+    int hanum = ha->hanum;
 
     TRACE2(("gdth_release()\n"));
-        hanum = NUMDATA(shp)->hanum;
-        ha    = HADATA(gdth_ctr_tab[hanum]);
         if (ha->sdev) {
             scsi_free_host_dev(ha->sdev);
             ha->sdev = NULL;
@@ -4069,7 +4063,7 @@ static const char *gdth_ctr_name(int han
 
     TRACE2(("gdth_ctr_name()\n"));
 
-    ha    = HADATA(gdth_ctr_tab[hanum]);
+    ha    = shost_priv(gdth_ctr_tab[hanum]);
 
     if (ha->type == GDT_EISA) {
         switch (ha->stype) {
@@ -4097,29 +4091,25 @@ static const char *gdth_ctr_name(int han
 
 static const char *gdth_info(struct Scsi_Host *shp)
 {
-    int hanum;
-    gdth_ha_str *ha;
+    gdth_ha_str *ha = shost_priv(shp);
 
     TRACE2(("gdth_info()\n"));
-    hanum = NUMDATA(shp)->hanum;
-    ha    = HADATA(gdth_ctr_tab[hanum]);
 
     return ((const char *)ha->binfo.type_string);
 }
 
 static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
+    gdth_ha_str *ha = shost_priv(scp->device->host);
     int i, hanum;
-    gdth_ha_str *ha;
     ulong flags;
     Scsi_Cmnd *cmnd;
     unchar b;
 
     TRACE2(("gdth_eh_bus_reset()\n"));
 
-    hanum = NUMDATA(scp->device->host)->hanum;
+    hanum = ha->hanum;
     b = scp->device->channel;
-    ha    = HADATA(gdth_ctr_tab[hanum]);
 
     /* clear command tab */
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -4164,18 +4154,15 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
 {
     unchar b, t;
-    int hanum;
-    gdth_ha_str *ha;
+    gdth_ha_str *ha = shost_priv(sdev->host);
     struct scsi_device *sd;
     unsigned capacity;
 
     sd = sdev;
     capacity = cap;
-    hanum = NUMDATA(sd->host)->hanum;
     b = sd->channel;
     t = sd->id;
     TRACE2(("gdth_bios_param() ha %d bus %d target %d\n", hanum, b, t)); 
-    ha = HADATA(gdth_ctr_tab[hanum]);
 
     if (b != ha->virt_bus || ha->hdr[t].heads == 0) {
         /* raw device or host drive without mapping information */
@@ -4195,7 +4182,8 @@ static int gdth_bios_param(struct scsi_d
 
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
 {
-    int hanum;
+    gdth_ha_str *ha = shost_priv(scp->device->host);
+    int hanum = ha->hanum;
     int priority;
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
@@ -4207,7 +4195,6 @@ static int gdth_queuecommand(Scsi_Cmnd *
     scp->SCp.Status = GDTH_MAP_NONE;
     scp->SCp.buffer = (struct scatterlist *)NULL;
 
-    hanum = NUMDATA(scp->device->host)->hanum;
 #ifdef GDTH_STATISTICS
     ++act_ios;
 #endif
@@ -4230,7 +4217,7 @@ static int gdth_open(struct inode *inode
     int i;
 
     for (i = 0; i < gdth_ctr_count; i++) {
-        ha = HADATA(gdth_ctr_tab[i]);
+        ha = shost_priv(gdth_ctr_tab[i]);
         if (!ha->sdev)
             ha->sdev = scsi_get_host_dev(gdth_ctr_tab[i]);
     }
@@ -4254,7 +4241,7 @@ static int ioc_event(void __user *arg)
     if (copy_from_user(&evt, arg, sizeof(gdth_ioctl_event)) ||
         evt.ionode >= gdth_ctr_count)
         return -EFAULT;
-    ha = HADATA(gdth_ctr_tab[evt.ionode]);
+    ha = shost_priv(gdth_ctr_tab[evt.ionode]);
 
     if (evt.erase == 0xff) {
         if (evt.event.event_source == ES_TEST)
@@ -4291,7 +4278,7 @@ static int ioc_lockdrv(void __user *arg)
     if (copy_from_user(&ldrv, arg, sizeof(gdth_ioctl_lockdrv)) ||
         ldrv.ionode >= gdth_ctr_count)
         return -EFAULT;
-    ha = HADATA(gdth_ctr_tab[ldrv.ionode]);
+    ha = shost_priv(gdth_ctr_tab[ldrv.ionode]);
  
     for (i = 0; i < ldrv.drive_cnt && i < MAX_HDRIVES; ++i) {
         j = ldrv.drives[i];
@@ -4326,7 +4313,7 @@ static int ioc_resetdrv(void __user *arg
         res.ionode >= gdth_ctr_count || res.number >= MAX_HDRIVES)
         return -EFAULT;
     hanum = res.ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
  
     if (!ha->hdr[res.number].present)
         return 0;
@@ -4361,7 +4348,7 @@ static int ioc_general(void __user *arg,
         gen.ionode >= gdth_ctr_count)
         return -EFAULT;
     hanum = gen.ionode; 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     if (gen.data_len + gen.sense_len != 0) {
         if (!(buf = gdth_ioctl_alloc(hanum, gen.data_len + gen.sense_len, 
                                      FALSE, &paddr)))
@@ -4486,7 +4473,7 @@ static int ioc_hdrlist(void __user *arg,
         goto free_fail;
     }
     hanum = rsc->ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
    
     for (i = 0; i < MAX_HDRIVES; ++i) { 
@@ -4543,7 +4530,7 @@ static int ioc_rescan(void __user *arg, 
         goto free_fail;
     }
     hanum = rsc->ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
 
     if (rsc->flag == 0) {
@@ -4702,7 +4689,7 @@ static int gdth_ioctl(struct inode *inod
         if (copy_from_user(&ctrt, argp, sizeof(gdth_ioctl_ctrtype)) ||
             ctrt.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[ctrt.ionode]);
+        ha = shost_priv(gdth_ctr_tab[ctrt.ionode]);
         if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
             ctrt.type = (unchar)((ha->stype>>20) - 0x10);
         } else {
@@ -4743,7 +4730,7 @@ static int gdth_ioctl(struct inode *inod
         if (copy_from_user(&lchn, argp, sizeof(gdth_ioctl_lockchn)) ||
             lchn.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[lchn.ionode]);
+        ha = shost_priv(gdth_ctr_tab[lchn.ionode]);
         
         i = lchn.channel;
         if (i < ha->bus_cnt) {
@@ -4783,7 +4770,7 @@ static int gdth_ioctl(struct inode *inod
             res.ionode >= gdth_ctr_count)
             return -EFAULT;
         hanum = res.ionode; 
-        ha = HADATA(gdth_ctr_tab[hanum]);
+        ha = shost_priv(gdth_ctr_tab[hanum]);
 
         scp  = kmalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
@@ -4822,7 +4809,7 @@ static void gdth_flush(int hanum)
     memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 
     TRACE2(("gdth_flush() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
 
     for (i = 0; i < MAX_HDRIVES; ++i) {
         if (ha->hdr[i].present) {
@@ -4923,10 +4910,10 @@ static int gdth_isa_probe_one(struct scs
 	if (!gdth_search_isa(isa_bios))
 		return -ENXIO;
 
-	shp = scsi_register(shtp, sizeof(gdth_ext_str));
+	shp = scsi_register(shtp, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
-	ha = HADATA(shp);
+	ha = shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_isa(isa_bios,ha))
@@ -4956,9 +4943,9 @@ static int gdth_isa_probe_one(struct scs
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	NUMDATA(shp)->hanum = (ushort)hanum;
+	ha->hanum = (ushort)hanum;
 
-	ha->pccb = CMDDATA(shp);
+	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
 	ha->pdev = NULL;
 
@@ -5049,10 +5036,10 @@ static int gdth_eisa_probe_one(struct sc
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
 
-	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	shp = scsi_register(shtp, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
-	ha = HADATA(shp);
+	ha = shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_eisa(eisa_slot,ha))
@@ -5074,11 +5061,10 @@ static int gdth_eisa_probe_one(struct sc
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	NUMDATA(shp)->hanum = (ushort)hanum;
-	TRACE2(("EISA detect Bus 0: hanum %d\n",
-		NUMDATA(shp)->hanum));
+	ha->hanum = (ushort)hanum;
+	TRACE2(("EISA detect Bus 0: hanum %d\n", hanum));
 
-	ha->pccb = CMDDATA(shp);
+	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
 
 	error = -ENOMEM;
@@ -5172,10 +5158,10 @@ static int gdth_pci_probe_one(struct scs
 	dma_addr_t scratch_dma_handle = 0;
 	int error, hanum, i;
 
-	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	shp = scsi_register(shtp, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
-        ha = HADATA(shp);
+        ha = shost_priv(shp);
 
 	error = -ENODEV;
         if (!gdth_init_pci(&pcistr[ctr],ha))
@@ -5200,9 +5186,9 @@ static int gdth_pci_probe_one(struct scs
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	NUMDATA(shp)->hanum = (ushort)hanum;
+	ha->hanum = (ushort)hanum;
 
-	ha->pccb = CMDDATA(shp);
+	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
 
 	error = -ENOMEM;
