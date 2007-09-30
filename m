From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 9/16] gdth: clean up host private data
Date: Sun, 30 Sep 2007 22:06:39 +0200
Message-ID: <470001CF.4090801@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:56858 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXI3UHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 16:07:10 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  - Get rid of all the indirection in the Scsi_Host private data and always
    put the gdth_ha_str directly into it.

  - Change all internal functions prototype to recieve an "gdth_ha_str *ha"
    pointer directlly and kill all that redundent access to the "gdth_ctr_tab[]"
    controller-table.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c      |  558 ++++++++++++++++++++--------------------------
 drivers/scsi/gdth.h      |   17 +--
 drivers/scsi/gdth_proc.c |   80 +++----
 drivers/scsi/gdth_proc.h |   20 +-
 4 files changed, 291 insertions(+), 384 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 4cda6a6..6fa7e27 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -139,14 +139,15 @@
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
-static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp);
-static int gdth_async_event(int hanum);
+static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
+                                                               Scsi_Cmnd *scp);
+static int gdth_async_event(gdth_ha_str *ha);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
 
-static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority);
-static void gdth_next(int hanum);
-static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b);
-static int gdth_special_cmd(int hanum,Scsi_Cmnd *scp);
+static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority);
+static void gdth_next(gdth_ha_str *ha);
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b);
+static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, ushort source,
                                       ushort idx, gdth_evt_data *evt);
 static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr);
@@ -154,10 +155,10 @@ static void gdth_readapp_event(gdth_ha_str *ha, unchar application,
                                gdth_evt_str *estr);
 static void gdth_clear_events(void);
 
-static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                                     char *buffer,ushort count);
-static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp);
-static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive);
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
 static int gdth_search_eisa(ushort eisa_adr);
 static int gdth_search_isa(ulong32 bios_adr);
@@ -169,25 +170,25 @@ static int gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha);
 static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
 static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
 
-static void gdth_enable_int(int hanum);
+static void gdth_enable_int(gdth_ha_str *ha);
 static int gdth_get_status(unchar *pIStatus,int irq);
-static int gdth_test_busy(int hanum);
-static int gdth_get_cmd_index(int hanum);
-static void gdth_release_event(int hanum);
-static int gdth_wait(int hanum,int index,ulong32 time);
-static int gdth_internal_cmd(int hanum,unchar service,ushort opcode,ulong32 p1,
-                             ulong64 p2,ulong64 p3);
-static int gdth_search_drives(int hanum);
-static int gdth_analyse_hdrive(int hanum, ushort hdrive);
+static int gdth_test_busy(gdth_ha_str *ha);
+static int gdth_get_cmd_index(gdth_ha_str *ha);
+static void gdth_release_event(gdth_ha_str *ha);
+static int gdth_wait(gdth_ha_str *ha, int index,ulong32 time);
+static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
+                                             ulong32 p1, ulong64 p2,ulong64 p3);
+static int gdth_search_drives(gdth_ha_str *ha);
+static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive);
 
-static const char *gdth_ctr_name(int hanum);
+static const char *gdth_ctr_name(gdth_ha_str *ha);
 
 static int gdth_open(struct inode *inode, struct file *filep);
 static int gdth_close(struct inode *inode, struct file *filep);
 static int gdth_ioctl(struct inode *inode, struct file *filep,
                       unsigned int cmd, unsigned long arg);
 
-static void gdth_flush(int hanum);
+static void gdth_flush(gdth_ha_str *ha);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static void gdth_scsi_done(struct scsi_cmnd *scp);
@@ -295,10 +296,6 @@ static struct timer_list gdth_timer;
 #define GDTOFFSOF(a,b)  (size_t)&(((a*)0)->b)
 #define INDEX_OK(i,t)   ((i)<ARRAY_SIZE(t))
 
-#define NUMDATA(a)      ( (gdth_num_str  *)((a)->hostdata))
-#define HADATA(a)       (&((gdth_ext_str *)((a)->hostdata))->haext)
-#define CMDDATA(a)      (&((gdth_ext_str *)((a)->hostdata))->cmdext)
-
 #define BUS_L2P(a,b)    ((b)>(a)->virt_bus ? (b-1):(b))
 
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
@@ -1206,16 +1203,14 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
 
 /* controller protocol functions */
 
-static void __init gdth_enable_int(int hanum)
+static void __init gdth_enable_int(gdth_ha_str *ha)
 {
-    gdth_ha_str *ha;
     ulong flags;
     gdt2_dpram_str __iomem *dp2_ptr;
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt6m_dpram_str __iomem *dp6m_ptr;
 
-    TRACE(("gdth_enable_int() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_enable_int() hanum %d\n",ha->hanum));
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (ha->type == GDT_EISA) {
@@ -1255,7 +1250,7 @@ static int gdth_get_status(unchar *pIStatus,int irq)
     
     *pIStatus = 0;
     for (i=0; i<gdth_ctr_count; ++i) {
-        ha = HADATA(gdth_ctr_tab[i]);
+        ha = shost_priv(gdth_ctr_tab[i]);
         if (ha->irq != (unchar)irq)             /* check IRQ */
             continue;
         if (ha->type == GDT_EISA)
@@ -1279,14 +1274,12 @@ static int gdth_get_status(unchar *pIStatus,int irq)
 }
                  
     
-static int gdth_test_busy(int hanum)
+static int gdth_test_busy(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     register int gdtsema0 = 0;
 
-    TRACE(("gdth_test_busy() hanum %d\n",hanum));
-    
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_test_busy() hanum %d\n", ha->hanum));
+
     if (ha->type == GDT_EISA)
         gdtsema0 = (int)inb(ha->bmic + SEMA0REG);
     else if (ha->type == GDT_ISA)
@@ -1303,14 +1296,12 @@ static int gdth_test_busy(int hanum)
 }
 
 
-static int gdth_get_cmd_index(int hanum)
+static int gdth_get_cmd_index(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     int i;
 
-    TRACE(("gdth_get_cmd_index() hanum %d\n",hanum));
+    TRACE(("gdth_get_cmd_index() hanum %d\n", ha->hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     for (i=0; i<GDTH_MAXCMDS; ++i) {
         if (ha->cmd_tab[i].cmnd == UNUSED_CMND) {
             ha->cmd_tab[i].cmnd = ha->pccb->RequestBuffer;
@@ -1323,13 +1314,10 @@ static int gdth_get_cmd_index(int hanum)
 }
 
 
-static void gdth_set_sema0(int hanum)
+static void gdth_set_sema0(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
-
-    TRACE(("gdth_set_sema0() hanum %d\n",hanum));
+    TRACE(("gdth_set_sema0() hanum %d\n", ha->hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     if (ha->type == GDT_EISA) {
         outb(1, ha->bmic + SEMA0REG);
     } else if (ha->type == GDT_ISA) {
@@ -1344,9 +1332,8 @@ static void gdth_set_sema0(int hanum)
 }
 
 
-static void gdth_copy_command(int hanum)
+static void gdth_copy_command(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmd_ptr;
     register gdt6m_dpram_str __iomem *dp6m_ptr;
     register gdt6c_dpram_str __iomem *dp6c_ptr;
@@ -1354,9 +1341,8 @@ static void gdth_copy_command(int hanum)
     gdt2_dpram_str __iomem *dp2_ptr;
     ushort cp_count,dp_offset,cmd_no;
     
-    TRACE(("gdth_copy_command() hanum %d\n",hanum));
+    TRACE(("gdth_copy_command() hanum %d\n", ha->hanum));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     cp_count = ha->cmd_len;
     dp_offset= ha->cmd_offs_dpmem;
     cmd_no   = ha->cmd_cnt;
@@ -1405,12 +1391,9 @@ static void gdth_copy_command(int hanum)
 }
 
 
-static void gdth_release_event(int hanum)
+static void gdth_release_event(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
-
-    TRACE(("gdth_release_event() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_release_event() hanum %d\n", ha->hanum));
 
 #ifdef GDTH_STATISTICS
     {
@@ -1444,46 +1427,41 @@ static void gdth_release_event(int hanum)
     }
 }
 
-    
-static int gdth_wait(int hanum,int index,ulong32 time)
+static int gdth_wait(gdth_ha_str *ha, int index, ulong32 time)
 {
-    gdth_ha_str *ha;
     int answer_found = FALSE;
 
-    TRACE(("gdth_wait() hanum %d index %d time %d\n",hanum,index,time));
+    TRACE(("gdth_wait() hanum %d index %d time %d\n", ha->hanum, index, time));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     if (index == 0)
         return 1;                               /* no wait required */
 
     gdth_from_wait = TRUE;
     do {
         gdth_interrupt((int)ha->irq,ha);
-        if (wait_hanum==hanum && wait_index==index) {
+        if (wait_hanum==ha->hanum && wait_index==index) {
             answer_found = TRUE;
             break;
         }
         gdth_delay(1);
     } while (--time);
     gdth_from_wait = FALSE;
-    
-    while (gdth_test_busy(hanum))
+
+    while (gdth_test_busy(ha))
         gdth_delay(0);
 
     return (answer_found);
 }
 
 
-static int gdth_internal_cmd(int hanum,unchar service,ushort opcode,ulong32 p1,
-                             ulong64 p2,ulong64 p3)
+static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
+                                            ulong32 p1, ulong64 p2, ulong64 p3)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmd_ptr;
     int retries,index;
 
     TRACE2(("gdth_internal_cmd() service %d opcode %d\n",service,opcode));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     cmd_ptr = ha->pccb;
     memset((char*)cmd_ptr,0,sizeof(gdth_cmd_str));
 
@@ -1491,11 +1469,11 @@ static int gdth_internal_cmd(int hanum,unchar service,ushort opcode,ulong32 p1,
     for (retries = INIT_RETRIES;;) {
         cmd_ptr->Service          = service;
         cmd_ptr->RequestBuffer    = INTERNAL_CMND;
-        if (!(index=gdth_get_cmd_index(hanum))) {
+        if (!(index=gdth_get_cmd_index(ha))) {
             TRACE(("GDT: No free command index found\n"));
             return 0;
         }
-        gdth_set_sema0(hanum);
+        gdth_set_sema0(ha);
         cmd_ptr->OpCode           = opcode;
         cmd_ptr->BoardNode        = LOCALBOARD;
         if (service == CACHESERVICE) {
@@ -1535,10 +1513,10 @@ static int gdth_internal_cmd(int hanum,unchar service,ushort opcode,ulong32 p1,
         ha->cmd_len          = sizeof(gdth_cmd_str);
         ha->cmd_offs_dpmem   = 0;
         ha->cmd_cnt          = 0;
-        gdth_copy_command(hanum);
-        gdth_release_event(hanum);
+        gdth_copy_command(ha);
+        gdth_release_event(ha);
         gdth_delay(20);
-        if (!gdth_wait(hanum,index,INIT_TIMEOUT)) {
+        if (!gdth_wait(ha, index, INIT_TIMEOUT)) {
             printk("GDT: Initialization error (timeout service %d)\n",service);
             return 0;
         }
@@ -1553,9 +1531,8 @@ static int gdth_internal_cmd(int hanum,unchar service,ushort opcode,ulong32 p1,
 
 /* search for devices */
 
-static int __init gdth_search_drives(int hanum)
+static int __init gdth_search_drives(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     ushort cdev_cnt, i;
     int ok;
     ulong32 bus_no, drv_cnt, drv_no, j;
@@ -1575,22 +1552,21 @@ static int __init gdth_search_drives(int hanum)
     ulong flags;
 #endif     
    
-    TRACE(("gdth_search_drives() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_search_drives() hanum %d\n", ha->hanum));
     ok = 0;
 
     /* initialize controller services, at first: screen service */
     ha->screen_feat = 0;
     if (!force_dma32) {
-        ok = gdth_internal_cmd(hanum,SCREENSERVICE,GDT_X_INIT_SCR,0,0,0);
+        ok = gdth_internal_cmd(ha, SCREENSERVICE, GDT_X_INIT_SCR, 0, 0, 0);
         if (ok)
             ha->screen_feat = GDT_64BIT;
     }
     if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
-        ok = gdth_internal_cmd(hanum,SCREENSERVICE,GDT_INIT,0,0,0);
+        ok = gdth_internal_cmd(ha, SCREENSERVICE, GDT_INIT, 0, 0, 0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error screen service (code %d)\n",
-               hanum, ha->status);
+               ha->hanum, ha->status);
         return 0;
     }
     TRACE2(("gdth_search_drives(): SCREENSERVICE initialized\n"));
@@ -1614,25 +1590,26 @@ static int __init gdth_search_drives(int hanum)
     TRACE2(("gdth_search_drives(): RTC: %x/%x/%x\n",*(ulong32 *)&rtc[0],
             *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]));
     /* 3. send to controller firmware */
-    gdth_internal_cmd(hanum,SCREENSERVICE,GDT_REALTIME, *(ulong32 *)&rtc[0],
+    gdth_internal_cmd(ha, SCREENSERVICE, GDT_REALTIME, *(ulong32 *)&rtc[0],
                       *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]);
 #endif  
  
     /* unfreeze all IOs */
-    gdth_internal_cmd(hanum,CACHESERVICE,GDT_UNFREEZE_IO,0,0,0);
+    gdth_internal_cmd(ha, CACHESERVICE, GDT_UNFREEZE_IO, 0, 0, 0);
  
     /* initialize cache service */
     ha->cache_feat = 0;
     if (!force_dma32) {
-        ok = gdth_internal_cmd(hanum,CACHESERVICE,GDT_X_INIT_HOST,LINUX_OS,0,0);
+        ok = gdth_internal_cmd(ha, CACHESERVICE, GDT_X_INIT_HOST, LINUX_OS,
+                                                                         0, 0);
         if (ok)
             ha->cache_feat = GDT_64BIT;
     }
     if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
-        ok = gdth_internal_cmd(hanum,CACHESERVICE,GDT_INIT,LINUX_OS,0,0);
+        ok = gdth_internal_cmd(ha, CACHESERVICE, GDT_INIT, LINUX_OS, 0, 0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error cache service (code %d)\n",
-               hanum, ha->status);
+               ha->hanum, ha->status);
         return 0;
     }
     TRACE2(("gdth_search_drives(): CACHESERVICE initialized\n"));
@@ -1661,9 +1638,9 @@ static int __init gdth_search_drives(int hanum)
         pmod->cmd_buff_size    = 0;
         pmod->reserved1        = 0;            
         pmod->reserved2        = 0;            
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,SET_PERF_MODES,
+        if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, SET_PERF_MODES,
                               INVALID_CHANNEL,sizeof(gdth_perf_modes))) {
-            printk("GDT-HA %d: Interrupt coalescing activated\n", hanum);
+            printk("GDT-HA %d: Interrupt coalescing activated\n", ha->hanum);
         }
     }
 #endif
@@ -1675,7 +1652,7 @@ static int __init gdth_search_drives(int hanum)
     iocr->hdr.first_chan     = 0;
     iocr->hdr.last_chan      = MAXBUS-1;
     iocr->hdr.list_offset    = GDTOFFSOF(gdth_raw_iochan_str, list[0]);
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,IOCHAN_RAW_DESC,
+    if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, IOCHAN_RAW_DESC,
                           INVALID_CHANNEL,sizeof(gdth_raw_iochan_str))) {
         TRACE2(("IOCHAN_RAW_DESC supported!\n"));
         ha->bus_cnt = iocr->hdr.chan_count;
@@ -1690,13 +1667,13 @@ static int __init gdth_search_drives(int hanum)
         chn = (gdth_getch_str *)ha->pscratch;
         for (bus_no = 0; bus_no < MAXBUS; ++bus_no) {
             chn->channel_no = bus_no;
-            if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            if (!gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL,
                                    SCSI_CHAN_CNT | L_CTRL_PATTERN,
                                    IO_CHANNEL | INVALID_CHANNEL,
                                    sizeof(gdth_getch_str))) {
                 if (bus_no == 0) {
                     printk("GDT-HA %d: Error detecting channel count (0x%x)\n",
-                           hanum, ha->status);
+                           ha->hanum, ha->status);
                     return 0;
                 }
                 break;
@@ -1711,10 +1688,10 @@ static int __init gdth_search_drives(int hanum)
     TRACE2(("gdth_search_drives() %d channels\n",ha->bus_cnt));
 
     /* read cache configuration */
-    if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,CACHE_INFO,
+    if (!gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, CACHE_INFO,
                            INVALID_CHANNEL,sizeof(gdth_cinfo_str))) {
         printk("GDT-HA %d: Initialization error cache service (code %d)\n",
-               hanum, ha->status);
+               ha->hanum, ha->status);
         return 0;
     }
     ha->cpar = ((gdth_cinfo_str *)ha->pscratch)->cpar;
@@ -1724,11 +1701,11 @@ static int __init gdth_search_drives(int hanum)
 
     /* read board info and features */
     ha->more_proc = FALSE;
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,BOARD_INFO,
+    if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, BOARD_INFO,
                           INVALID_CHANNEL,sizeof(gdth_binfo_str))) {
         memcpy(&ha->binfo, (gdth_binfo_str *)ha->pscratch,
                sizeof(gdth_binfo_str));
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,BOARD_FEATURES,
+        if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, BOARD_FEATURES,
                               INVALID_CHANNEL,sizeof(gdth_bfeat_str))) {
             TRACE2(("BOARD_INFO/BOARD_FEATURES supported\n"));
             ha->bfeat = *(gdth_bfeat_str *)ha->pscratch;
@@ -1736,7 +1713,7 @@ static int __init gdth_search_drives(int hanum)
         }
     } else {
         TRACE2(("BOARD_INFO requires firmware >= 1.10/2.08\n"));
-        strcpy(ha->binfo.type_string, gdth_ctr_name(hanum));
+        strcpy(ha->binfo.type_string, gdth_ctr_name(ha));
     }
     TRACE2(("Controller name: %s\n",ha->binfo.type_string));
 
@@ -1749,7 +1726,7 @@ static int __init gdth_search_drives(int hanum)
         ioc->hdr.first_chan     = 0;
         ioc->hdr.last_chan      = MAXBUS-1;
         ioc->hdr.list_offset    = GDTOFFSOF(gdth_iochan_str, list[0]);
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,IOCHAN_DESC,
+        if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, IOCHAN_DESC,
                               INVALID_CHANNEL,sizeof(gdth_iochan_str))) {
             for (bus_no = 0; bus_no < ha->bus_cnt; ++bus_no) {
                 ha->raw[bus_no].address = ioc->list[bus_no].address;
@@ -1764,7 +1741,7 @@ static int __init gdth_search_drives(int hanum)
         for (bus_no = 0; bus_no < ha->bus_cnt; ++bus_no) {
             chn = (gdth_getch_str *)ha->pscratch;
             chn->channel_no = ha->raw[bus_no].local_no;
-            if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL,
                                   SCSI_CHAN_CNT | L_CTRL_PATTERN,
                                   ha->raw[bus_no].address | INVALID_CHANNEL,
                                   sizeof(gdth_getch_str))) {
@@ -1776,7 +1753,7 @@ static int __init gdth_search_drives(int hanum)
                 drl = (gdth_drlist_str *)ha->pscratch;
                 drl->sc_no = ha->raw[bus_no].local_no;
                 drl->sc_cnt = ha->raw[bus_no].pdev_cnt;
-                if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+                if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL,
                                       SCSI_DR_LIST | L_CTRL_PATTERN,
                                       ha->raw[bus_no].address | INVALID_CHANNEL,
                                       sizeof(gdth_drlist_str))) {
@@ -1789,10 +1766,10 @@ static int __init gdth_search_drives(int hanum)
         }
 
         /* logical drives */
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,CACHE_DRV_CNT,
+        if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, CACHE_DRV_CNT,
                               INVALID_CHANNEL,sizeof(ulong32))) {
             drv_cnt = *(ulong32 *)ha->pscratch;
-            if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,CACHE_DRV_LIST,
+            if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, CACHE_DRV_LIST,
                                   INVALID_CHANNEL,drv_cnt * sizeof(ulong32))) {
                 for (j = 0; j < drv_cnt; ++j) {
                     drv_no = ((ulong32 *)ha->pscratch)[j];
@@ -1806,7 +1783,7 @@ static int __init gdth_search_drives(int hanum)
             alst->entries_avail = MAX_LDRIVES;
             alst->first_entry = 0;
             alst->list_offset = GDTOFFSOF(gdth_arcdl_str, list[0]);
-            if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL,
                                   ARRAY_DRV_LIST2 | LA_CTRL_PATTERN, 
                                   INVALID_CHANNEL, sizeof(gdth_arcdl_str) +
                                   (alst->entries_avail-1) * sizeof(gdth_alist_str))) { 
@@ -1817,7 +1794,7 @@ static int __init gdth_search_drives(int hanum)
                     ha->hdr[j].is_hotfix = alst->list[j].is_hotfix;
                     ha->hdr[j].master_no = alst->list[j].cd_handle;
                 }
-            } else if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            } else if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL,
                                          ARRAY_DRV_LIST | LA_CTRL_PATTERN,
                                          0, 35 * sizeof(gdth_alist_str))) {
                 for (j = 0; j < 35; ++j) {
@@ -1835,24 +1812,24 @@ static int __init gdth_search_drives(int hanum)
     /* initialize raw service */
     ha->raw_feat = 0;
     if (!force_dma32) {
-        ok = gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_X_INIT_RAW,0,0,0);
+        ok = gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_X_INIT_RAW, 0, 0, 0);
         if (ok)
             ha->raw_feat = GDT_64BIT;
     }
     if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
-        ok = gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_INIT,0,0,0);
+        ok = gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_INIT, 0, 0, 0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error raw service (code %d)\n",
-               hanum, ha->status);
+               ha->hanum, ha->status);
         return 0;
     }
     TRACE2(("gdth_search_drives(): RAWSERVICE initialized\n"));
 
     /* set/get features raw service (scatter/gather) */
-    if (gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_SET_FEAT,SCATTER_GATHER,
-                          0,0)) {
+    if (gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_SET_FEAT, SCATTER_GATHER,
+                          0, 0)) {
         TRACE2(("gdth_search_drives(): set features RAWSERVICE OK\n"));
-        if (gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_GET_FEAT,0,0,0)) {
+        if (gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_GET_FEAT, 0, 0, 0)) {
             TRACE2(("gdth_search_dr(): get feat RAWSERVICE %d\n",
                     ha->info));
             ha->raw_feat |= (ushort)ha->info;
@@ -1860,10 +1837,10 @@ static int __init gdth_search_drives(int hanum)
     } 
 
     /* set/get features cache service (equal to raw service) */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_SET_FEAT,0,
+    if (gdth_internal_cmd(ha, CACHESERVICE, GDT_SET_FEAT, 0,
                           SCATTER_GATHER,0)) {
         TRACE2(("gdth_search_drives(): set features CACHESERVICE OK\n"));
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_GET_FEAT,0,0,0)) {
+        if (gdth_internal_cmd(ha, CACHESERVICE, GDT_GET_FEAT, 0, 0, 0)) {
             TRACE2(("gdth_search_dr(): get feat CACHESERV. %d\n",
                     ha->info));
             ha->cache_feat |= (ushort)ha->info;
@@ -1872,22 +1849,22 @@ static int __init gdth_search_drives(int hanum)
 
     /* reserve drives for raw service */
     if (reserve_mode != 0) {
-        gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_RESERVE_ALL,
+        gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_RESERVE_ALL,
                           reserve_mode == 1 ? 1 : 3, 0, 0);
         TRACE2(("gdth_search_drives(): RESERVE_ALL code %d\n", 
                 ha->status));
     }
     for (i = 0; i < MAX_RES_ARGS; i += 4) {
-        if (reserve_list[i] == hanum && reserve_list[i+1] < ha->bus_cnt && 
+        if (reserve_list[i] == ha->hanum && reserve_list[i+1] < ha->bus_cnt &&
             reserve_list[i+2] < ha->tid_cnt && reserve_list[i+3] < MAXLUN) {
             TRACE2(("gdth_search_drives(): reserve ha %d bus %d id %d lun %d\n",
                     reserve_list[i], reserve_list[i+1],
                     reserve_list[i+2], reserve_list[i+3]));
-            if (!gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_RESERVE,0,
+            if (!gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_RESERVE, 0,
                                    reserve_list[i+1], reserve_list[i+2] | 
                                    (reserve_list[i+3] << 8))) {
                 printk("GDT-HA %d: Error raw service (RESERVE, code %d)\n",
-                       hanum, ha->status);
+                       ha->hanum, ha->status);
              }
         }
     }
@@ -1896,12 +1873,12 @@ static int __init gdth_search_drives(int hanum)
     oemstr = (gdth_oem_str_ioctl *)ha->pscratch;
     oemstr->params.ctl_version = 0x01;
     oemstr->params.buffer_size = sizeof(oemstr->text);
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+    if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL,
                           CACHE_READ_OEM_STRING_RECORD,INVALID_CHANNEL,
                           sizeof(gdth_oem_str_ioctl))) {
         TRACE2(("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD OK\n"));
         printk("GDT-HA %d: Vendor: %s Name: %s\n",
-               hanum,oemstr->text.oem_company_name,ha->binfo.type_string);
+               ha->hanum, oemstr->text.oem_company_name, ha->binfo.type_string);
         /* Save the Host Drive inquiry data */
         strlcpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,
                 sizeof(ha->oem_name));
@@ -1909,7 +1886,7 @@ static int __init gdth_search_drives(int hanum)
         /* Old method, based on PCI ID */
         TRACE2(("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD failed\n"));
         printk("GDT-HA %d: Name: %s\n",
-               hanum,ha->binfo.type_string);
+               ha->hanum, ha->binfo.type_string);
         if (ha->oem_id == OEM_ID_INTEL)
             strlcpy(ha->oem_name,"Intel  ", sizeof(ha->oem_name));
         else
@@ -1918,24 +1895,22 @@ static int __init gdth_search_drives(int hanum)
 
     /* scanning for host drives */
     for (i = 0; i < cdev_cnt; ++i) 
-        gdth_analyse_hdrive(hanum,i);
+        gdth_analyse_hdrive(ha, i);
     
     TRACE(("gdth_search_drives() OK\n"));
     return 1;
 }
 
-static int gdth_analyse_hdrive(int hanum,ushort hdrive)
+static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
 {
-    register gdth_ha_str *ha;
     ulong32 drv_cyls;
     int drv_hds, drv_secs;
 
-    TRACE(("gdth_analyse_hdrive() hanum %d drive %d\n",hanum,hdrive));
+    TRACE(("gdth_analyse_hdrive() hanum %d drive %d\n", ha->hanum, hdrive));
     if (hdrive >= MAX_HDRIVES)
         return 0;
-    ha = HADATA(gdth_ctr_tab[hanum]);
 
-    if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_INFO,hdrive,0,0)) 
+    if (!gdth_internal_cmd(ha, CACHESERVICE, GDT_INFO, hdrive, 0, 0))
         return 0;
     ha->hdr[hdrive].present = TRUE;
     ha->hdr[hdrive].size = ha->info;
@@ -1955,7 +1930,7 @@ static int gdth_analyse_hdrive(int hanum,ushort hdrive)
     ha->hdr[hdrive].size  = drv_cyls * drv_hds * drv_secs;
     
     if (ha->cache_feat & GDT_64BIT) {
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_X_INFO,hdrive,0,0)
+        if (gdth_internal_cmd(ha, CACHESERVICE, GDT_X_INFO, hdrive, 0, 0)
             && ha->info2 != 0) {
             ha->hdr[hdrive].size = ((ulong64)ha->info2 << 32) | ha->info;
         }
@@ -1964,14 +1939,14 @@ static int gdth_analyse_hdrive(int hanum,ushort hdrive)
             hdrive,ha->hdr[hdrive].size,drv_hds,drv_secs));
 
     /* get informations about device */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_DEVTYPE,hdrive,0,0)) {
+    if (gdth_internal_cmd(ha, CACHESERVICE, GDT_DEVTYPE, hdrive, 0, 0)) {
         TRACE2(("gdth_search_dr() cache drive %d devtype %d\n",
                 hdrive,ha->info));
         ha->hdr[hdrive].devtype = (ushort)ha->info;
     }
 
     /* cluster info */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_CLUST_INFO,hdrive,0,0)) {
+    if (gdth_internal_cmd(ha, CACHESERVICE, GDT_CLUST_INFO, hdrive, 0, 0)) {
         TRACE2(("gdth_search_dr() cache drive %d cluster info %d\n",
                 hdrive,ha->info));
         if (!shared_access)
@@ -1979,7 +1954,7 @@ static int gdth_analyse_hdrive(int hanum,ushort hdrive)
     }
 
     /* R/W attributes */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_RW_ATTRIBS,hdrive,0,0)) {
+    if (gdth_internal_cmd(ha, CACHESERVICE, GDT_RW_ATTRIBS, hdrive, 0, 0)) {
         TRACE2(("gdth_search_dr() cache drive %d r/w attrib. %d\n",
                 hdrive,ha->info));
         ha->hdr[hdrive].rw_attribs = (unchar)ha->info;
@@ -1991,16 +1966,14 @@ static int gdth_analyse_hdrive(int hanum,ushort hdrive)
 
 /* command queueing/sending functions */
 
-static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
+static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
 {
-    register gdth_ha_str *ha;
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
     ulong flags;
     unchar b, t;
 
     TRACE(("gdth_putq() priority %d\n",priority));
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (scp->done != gdth_scsi_done) {
@@ -2011,7 +1984,7 @@ static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
             if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
                 (b==ha->virt_bus && t<MAX_HDRIVES && ha->hdr[t].lock)) {
                 TRACE2(("gdth_putq(): locked IO ->update_timeout()\n"));
-                scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+                scp->SCp.buffers_residual = gdth_update_timeout(scp, 0);
             }
         }
     }
@@ -2043,9 +2016,8 @@ static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
 #endif
 }
 
-static void gdth_next(int hanum)
+static void gdth_next(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
     unchar b, t, l, firsttime;
@@ -2053,8 +2025,7 @@ static void gdth_next(int hanum)
     ulong flags = 0;
     int cmd_index;
 
-    TRACE(("gdth_next() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_next() hanum %d\n", ha->hanum));
     if (!gdth_polling) 
         spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -2079,13 +2050,13 @@ static void gdth_next(int hanum)
             b = t = l = 0;
 
         if (firsttime) {
-            if (gdth_test_busy(hanum)) {        /* controller busy ? */
-                TRACE(("gdth_next() controller %d busy !\n",hanum));
+            if (gdth_test_busy(ha)) {        /* controller busy ? */
+                TRACE(("gdth_next() controller %d busy !\n", ha->hanum));
                 if (!gdth_polling) {
                     spin_unlock_irqrestore(&ha->smp_lock, flags);
                     return;
                 }
-                while (gdth_test_busy(hanum))
+                while (gdth_test_busy(ha))
                     gdth_delay(1);
             }   
             firsttime = FALSE;
@@ -2137,11 +2108,11 @@ static void gdth_next(int hanum)
 
         if (nscp->SCp.sent_command != -1) {
             if ((nscp->SCp.phase & 0xff) == CACHESERVICE) {
-                if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                if (!(cmd_index=gdth_fill_cache_cmd(ha, nscp, t)))
                     this_cmd = FALSE;
                 next_cmd = FALSE;
             } else if ((nscp->SCp.phase & 0xff) == SCSIRAWSERVICE) {
-                if (!(cmd_index=gdth_fill_raw_cmd(hanum,nscp,BUS_L2P(ha,b))))
+                if (!(cmd_index=gdth_fill_raw_cmd(ha, nscp, BUS_L2P(ha, b))))
                     this_cmd = FALSE;
                 next_cmd = FALSE;
             } else {
@@ -2155,12 +2126,12 @@ static void gdth_next(int hanum)
                     nscp->scsi_done(nscp);
             }
         } else if (nscp->done == gdth_scsi_done) {
-            if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
+            if (!(cmd_index=gdth_special_cmd(ha, nscp)))
                 this_cmd = FALSE;
             next_cmd = FALSE;
         } else if (b != ha->virt_bus) {
             if (ha->raw[BUS_L2P(ha,b)].io_cnt[t] >= GDTH_MAX_RAW ||
-                !(cmd_index=gdth_fill_raw_cmd(hanum,nscp,BUS_L2P(ha,b)))) 
+                !(cmd_index=gdth_fill_raw_cmd(ha, nscp, BUS_L2P(ha, b))))
                 this_cmd = FALSE;
             else 
                 ha->raw[BUS_L2P(ha,b)].io_cnt[t]++;
@@ -2198,7 +2169,7 @@ static void gdth_next(int hanum)
                         nscp->SCp.have_data_in++;
                     else
                         nscp->scsi_done(nscp);
-                } else if (gdth_internal_cache_cmd(hanum,nscp))
+                } else if (gdth_internal_cache_cmd(ha, nscp))
                     nscp->scsi_done(nscp);
                 break;
 
@@ -2218,7 +2189,7 @@ static void gdth_next(int hanum)
                     nscp->cmnd[3] = (ha->hdr[t].devtype&1) ? 1:0;
                     TRACE(("Prevent/allow r. %d rem. drive %d\n",
                            nscp->cmnd[4],nscp->cmnd[3]));
-                    if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                    if (!(cmd_index=gdth_fill_cache_cmd(ha, nscp, t)))
                         this_cmd = FALSE;
                 }
                 break;
@@ -2227,7 +2198,7 @@ static void gdth_next(int hanum)
               case RELEASE:
                 TRACE2(("cache cmd %s\n",nscp->cmnd[0] == RESERVE ?
                         "RESERVE" : "RELEASE"));
-                if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                if (!(cmd_index=gdth_fill_cache_cmd(ha, nscp, t)))
                     this_cmd = FALSE;
                 break;
                 
@@ -2250,7 +2221,7 @@ static void gdth_next(int hanum)
                         nscp->SCp.have_data_in++;
                     else
                         nscp->scsi_done(nscp);
-                } else if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                } else if (!(cmd_index=gdth_fill_cache_cmd(ha, nscp, t)))
                     this_cmd = FALSE;
                 break;
 
@@ -2259,7 +2230,7 @@ static void gdth_next(int hanum)
                         nscp->cmnd[1],nscp->cmnd[2],nscp->cmnd[3],
                         nscp->cmnd[4],nscp->cmnd[5]));
                 printk("GDT-HA %d: Unknown SCSI command 0x%x to cache service !\n",
-                       hanum, nscp->cmnd[0]);
+                       ha->hanum, nscp->cmnd[0]);
                 nscp->result = DID_ABORT << 16;
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
@@ -2280,30 +2251,28 @@ static void gdth_next(int hanum)
     }
 
     if (ha->cmd_cnt > 0) {
-        gdth_release_event(hanum);
+        gdth_release_event(ha);
     }
 
     if (!gdth_polling) 
         spin_unlock_irqrestore(&ha->smp_lock, flags);
 
     if (gdth_polling && ha->cmd_cnt > 0) {
-        if (!gdth_wait(hanum,cmd_index,POLL_TIMEOUT))
+        if (!gdth_wait(ha, cmd_index, POLL_TIMEOUT))
             printk("GDT-HA %d: Command %d timed out !\n",
-                   hanum,cmd_index);
+                   ha->hanum, cmd_index);
     }
 }
    
-static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                                     char *buffer,ushort count)
 {
     ushort cpcount,i;
     ushort cpsum,cpnow;
     struct scatterlist *sl;
-    gdth_ha_str *ha;
     char *address;
 
     cpcount = count<=(ushort)scp->request_bufflen ? count:(ushort)scp->request_bufflen;
-    ha = HADATA(gdth_ctr_tab[hanum]);
 
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
@@ -2317,7 +2286,7 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
             cpsum += cpnow;
             if (!sl->page) {
                 printk("GDT-HA %d: invalid sc/gt element in gdth_copy_internal_data()\n",
-                       hanum);
+                       ha->hanum);
                 return;
             }
             local_irq_save(flags);
@@ -2336,16 +2305,14 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
     }
 }
 
-static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 {
-    register gdth_ha_str *ha;
     unchar t;
     gdth_inq_data inq;
     gdth_rdcap_data rdc;
     gdth_sense_data sd;
     gdth_modep_data mpd;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     t  = scp->device->id;
     TRACE(("gdth_internal_cache_cmd() cmd 0x%x hdrive %d\n",
            scp->cmnd[0],t));
@@ -2376,7 +2343,7 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
         strcpy(inq.vendor,ha->oem_name);
         sprintf(inq.product,"Host Drive  #%02d",t);
         strcpy(inq.revision,"   ");
-        gdth_copy_internal_data(hanum,scp,(char*)&inq,sizeof(gdth_inq_data));
+        gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data));
         break;
 
       case REQUEST_SENSE:
@@ -2386,7 +2353,7 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
         sd.key       = NO_SENSE;
         sd.info      = 0;
         sd.add_length= 0;
-        gdth_copy_internal_data(hanum,scp,(char*)&sd,sizeof(gdth_sense_data));
+        gdth_copy_internal_data(ha, scp, (char*)&sd, sizeof(gdth_sense_data));
         break;
 
       case MODE_SENSE:
@@ -2398,7 +2365,7 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
         mpd.bd.block_length[0] = (SECTOR_SIZE & 0x00ff0000) >> 16;
         mpd.bd.block_length[1] = (SECTOR_SIZE & 0x0000ff00) >> 8;
         mpd.bd.block_length[2] = (SECTOR_SIZE & 0x000000ff);
-        gdth_copy_internal_data(hanum,scp,(char*)&mpd,sizeof(gdth_modep_data));
+        gdth_copy_internal_data(ha, scp, (char*)&mpd, sizeof(gdth_modep_data));
         break;
 
       case READ_CAPACITY:
@@ -2408,7 +2375,7 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
         rdc.block_length  = cpu_to_be32(SECTOR_SIZE);
-        gdth_copy_internal_data(hanum,scp,(char*)&rdc,sizeof(gdth_rdcap_data));
+        gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data));
         break;
 
       case SERVICE_ACTION_IN:
@@ -2419,7 +2386,8 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
             TRACE2(("Read capacity (16) hdrive %d\n",t));
             rdc16.last_block_no = cpu_to_be64(ha->hdr[t].size-1);
             rdc16.block_length  = cpu_to_be32(SECTOR_SIZE);
-            gdth_copy_internal_data(hanum,scp,(char*)&rdc16,sizeof(gdth_rdcap16_data));
+            gdth_copy_internal_data(ha, scp, (char*)&rdc16,
+                                                     sizeof(gdth_rdcap16_data));
         } else { 
             scp->result = DID_ABORT << 16;
         }
@@ -2437,10 +2405,9 @@ static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
 
     return 0;
 }
-    
-static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
+
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
     struct scatterlist *sl;
     ulong32 cnt, blockcnt;
@@ -2450,7 +2417,6 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     cmdp = ha->pccb;
     TRACE(("gdth_fill_cache_cmd() cmd 0x%x cmdsize %d hdrive %d\n",
                  scp->cmnd[0],scp->cmd_len,hdrive));
@@ -2466,13 +2432,13 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
     cmdp->Service = CACHESERVICE;
     cmdp->RequestBuffer = scp;
     /* search free command index */
-    if (!(cmd_index=gdth_get_cmd_index(hanum))) {
+    if (!(cmd_index=gdth_get_cmd_index(ha))) {
         TRACE(("GDT: No free command index found\n"));
         return 0;
     }
     /* if it's the first command, set command semaphore */
     if (ha->cmd_cnt == 0)
-        gdth_set_sema0(hanum);
+        gdth_set_sema0(ha);
 
     /* fill command */
     read_write = 0;
@@ -2644,13 +2610,12 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
     }
 
     /* copy command */
-    gdth_copy_command(hanum);
+    gdth_copy_command(ha);
     return cmd_index;
 }
 
-static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
     struct scatterlist *sl;
     ushort i;
@@ -2660,7 +2625,6 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     t = scp->device->id;
     l = scp->device->lun;
     cmdp = ha->pccb;
@@ -2675,13 +2639,13 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
     cmdp->Service = SCSIRAWSERVICE;
     cmdp->RequestBuffer = scp;
     /* search free command index */
-    if (!(cmd_index=gdth_get_cmd_index(hanum))) {
+    if (!(cmd_index=gdth_get_cmd_index(ha))) {
         TRACE(("GDT: No free command index found\n"));
         return 0;
     }
     /* if it's the first command, set command semaphore */
     if (ha->cmd_cnt == 0)
-        gdth_set_sema0(hanum);
+        gdth_set_sema0(ha);
 
     /* fill command */  
     if (scp->SCp.sent_command != -1) {
@@ -2849,17 +2813,15 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
     }
 
     /* copy command */
-    gdth_copy_command(hanum);
+    gdth_copy_command(ha);
     return cmd_index;
 }
 
-static int gdth_special_cmd(int hanum,Scsi_Cmnd *scp)
+static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
     int cmd_index;
 
-    ha  = HADATA(gdth_ctr_tab[hanum]);
     cmdp= ha->pccb;
     TRACE2(("gdth_special_cmd(): "));
 
@@ -2870,14 +2832,14 @@ static int gdth_special_cmd(int hanum,Scsi_Cmnd *scp)
     cmdp->RequestBuffer = scp;
 
     /* search free command index */
-    if (!(cmd_index=gdth_get_cmd_index(hanum))) {
+    if (!(cmd_index=gdth_get_cmd_index(ha))) {
         TRACE(("GDT: No free command index found\n"));
         return 0;
     }
 
     /* if it's the first command, set command semaphore */
     if (ha->cmd_cnt == 0)
-       gdth_set_sema0(hanum);
+       gdth_set_sema0(ha);
 
     /* evaluate command size, check space */
     if (cmdp->OpCode == GDT_IOCTL) {
@@ -2915,7 +2877,7 @@ static int gdth_special_cmd(int hanum,Scsi_Cmnd *scp)
     }
 
     /* copy command */
-    gdth_copy_command(hanum);
+    gdth_copy_command(ha);
     return cmd_index;
 }    
 
@@ -3081,7 +3043,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
             spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
     }
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[hanum]);
 
 #ifdef GDTH_STATISTICS
     ++act_ints;
@@ -3227,10 +3189,10 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
 
         if (IStatus == ASYNCINDEX) {
             TRACE2(("gdth_interrupt() async. event\n"));
-            gdth_async_event(hanum);
+            gdth_async_event(ha);
             if (!gdth_polling)
                 spin_unlock_irqrestore(&ha2->smp_lock, flags);
-            gdth_next(hanum);
+            gdth_next(ha);
             return IRQ_HANDLED;
         } 
 
@@ -3264,11 +3226,11 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         }
 
         TRACE(("gdth_interrupt() sync. status\n"));
-        rval = gdth_sync_event(hanum,Service,IStatus,scp);
+        rval = gdth_sync_event(ha,Service,IStatus,scp);
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha2->smp_lock, flags);
         if (rval == 2) {
-            gdth_putq(hanum,scp,scp->SCp.this_residual);
+            gdth_putq(ha, scp,scp->SCp.this_residual);
         } else if (rval == 1) {
             scp->scsi_done(scp);
         }
@@ -3298,18 +3260,17 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
     }
 #endif
 
-    gdth_next(hanum);
+    gdth_next(ha);
     return IRQ_HANDLED;
 }
 
-static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
+static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
+                                                              Scsi_Cmnd *scp)
 {
-    register gdth_ha_str *ha;
     gdth_msg_str *msg;
     gdth_cmd_str *cmdp;
     unchar b, t;
 
-    ha   = HADATA(gdth_ctr_tab[hanum]);
     cmdp = ha->pccb;
     TRACE(("gdth_sync_event() serv %d status %d\n",
            service,ha->status));
@@ -3327,12 +3288,12 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
             }
 
         if (msg->msg_ext && !msg->msg_answer) {
-            while (gdth_test_busy(hanum))
+            while (gdth_test_busy(ha))
                 gdth_delay(0);
             cmdp->Service       = SCREENSERVICE;
             cmdp->RequestBuffer = SCREEN_CMND;
-            gdth_get_cmd_index(hanum);
-            gdth_set_sema0(hanum);
+            gdth_get_cmd_index(ha);
+            gdth_set_sema0(ha);
             cmdp->OpCode        = GDT_READ;
             cmdp->BoardNode     = LOCALBOARD;
             cmdp->u.screen.reserved  = 0;
@@ -3342,8 +3303,8 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
                 + sizeof(ulong64);
             ha->cmd_cnt = 0;
-            gdth_copy_command(hanum);
-            gdth_release_event(hanum);
+            gdth_copy_command(ha);
+            gdth_release_event(ha);
             return 0;
         }
 
@@ -3361,12 +3322,12 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
             }
             msg->msg_ext    = 0;
             msg->msg_answer = 0;
-            while (gdth_test_busy(hanum))
+            while (gdth_test_busy(ha))
                 gdth_delay(0);
             cmdp->Service       = SCREENSERVICE;
             cmdp->RequestBuffer = SCREEN_CMND;
-            gdth_get_cmd_index(hanum);
-            gdth_set_sema0(hanum);
+            gdth_get_cmd_index(ha);
+            gdth_set_sema0(ha);
             cmdp->OpCode        = GDT_WRITE;
             cmdp->BoardNode     = LOCALBOARD;
             cmdp->u.screen.reserved  = 0;
@@ -3376,8 +3337,8 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
                 + sizeof(ulong64);
             ha->cmd_cnt = 0;
-            gdth_copy_command(hanum);
-            gdth_release_event(hanum);
+            gdth_copy_command(ha);
+            gdth_release_event(ha);
             return 0;
         }
         printk("\n");
@@ -3490,7 +3451,7 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
                 }
                 if (scp->done != gdth_scsi_done) {
                     ha->dvr.size = sizeof(ha->dvr.eu.sync);
-                    ha->dvr.eu.sync.ionode  = hanum;
+                    ha->dvr.eu.sync.ionode  = ha->hanum;
                     ha->dvr.eu.sync.service = service;
                     ha->dvr.eu.sync.status  = ha->status;
                     ha->dvr.eu.sync.info    = ha->info;
@@ -3674,25 +3635,23 @@ static char *async_cache_tab[] = {
 };
 
 
-static int gdth_async_event(int hanum)
+static int gdth_async_event(gdth_ha_str *ha)
 {
-    gdth_ha_str *ha;
     gdth_cmd_str *cmdp;
     int cmd_index;
 
-    ha  = HADATA(gdth_ctr_tab[hanum]);
     cmdp= ha->pccb;
     TRACE2(("gdth_async_event() ha %d serv %d\n",
-            hanum,ha->service));
+            ha->hanum, ha->service));
 
     if (ha->service == SCREENSERVICE) {
         if (ha->status == MSG_REQUEST) {
-            while (gdth_test_busy(hanum))
+            while (gdth_test_busy(ha))
                 gdth_delay(0);
             cmdp->Service       = SCREENSERVICE;
             cmdp->RequestBuffer = SCREEN_CMND;
-            cmd_index = gdth_get_cmd_index(hanum);
-            gdth_set_sema0(hanum);
+            cmd_index = gdth_get_cmd_index(ha);
+            gdth_set_sema0(ha);
             cmdp->OpCode        = GDT_READ;
             cmdp->BoardNode     = LOCALBOARD;
             cmdp->u.screen.reserved  = 0;
@@ -3702,7 +3661,7 @@ static int gdth_async_event(int hanum)
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
                 + sizeof(ulong64);
             ha->cmd_cnt = 0;
-            gdth_copy_command(hanum);
+            gdth_copy_command(ha);
             if (ha->type == GDT_EISA)
                 printk("[EISA slot %d] ",(ushort)ha->brd_phys);
             else if (ha->type == GDT_ISA)
@@ -3710,19 +3669,19 @@ static int gdth_async_event(int hanum)
             else 
                 printk("[PCI %d/%d] ",(ushort)(ha->brd_phys>>8),
                        (ushort)((ha->brd_phys>>3)&0x1f));
-            gdth_release_event(hanum);
+            gdth_release_event(ha);
         }
 
     } else {
         if (ha->type == GDT_PCIMPR && 
             (ha->fw_vers & 0xff) >= 0x1a) {
             ha->dvr.size = 0;
-            ha->dvr.eu.async.ionode = hanum;
+            ha->dvr.eu.async.ionode = ha->hanum;
             ha->dvr.eu.async.status  = ha->status;
             /* severity and event_string already set! */
         } else {        
             ha->dvr.size = sizeof(ha->dvr.eu.async);
-            ha->dvr.eu.async.ionode   = hanum;
+            ha->dvr.eu.async.ionode   = ha->hanum;
             ha->dvr.eu.async.service = ha->service;
             ha->dvr.eu.async.status  = ha->status;
             ha->dvr.eu.async.info    = ha->info;
@@ -3804,9 +3763,8 @@ static void gdth_timeout(ulong data)
     Scsi_Cmnd *nscp;
     gdth_ha_str *ha;
     ulong flags;
-    int hanum = 0;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[0]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (act_stats=0,i=0; i<GDTH_MAXCMDS; ++i) 
@@ -4004,17 +3962,14 @@ static int __init gdth_detect(struct scsi_host_template *shtp)
 
 static int gdth_release(struct Scsi_Host *shp)
 {
-    int hanum;
-    gdth_ha_str *ha;
+    gdth_ha_str *ha = shost_priv(shp);
 
     TRACE2(("gdth_release()\n"));
-        hanum = NUMDATA(shp)->hanum;
-        ha    = HADATA(gdth_ctr_tab[hanum]);
         if (ha->sdev) {
             scsi_free_host_dev(ha->sdev);
             ha->sdev = NULL;
         }
-        gdth_flush(hanum);
+        gdth_flush(ha);
 
         if (shp->irq) {
             free_irq(shp->irq,ha);
@@ -4055,14 +4010,10 @@ static int gdth_release(struct Scsi_Host *shp)
 }
             
 
-static const char *gdth_ctr_name(int hanum)
+static const char *gdth_ctr_name(gdth_ha_str *ha)
 {
-    gdth_ha_str *ha;
-
     TRACE2(("gdth_ctr_name()\n"));
 
-    ha    = HADATA(gdth_ctr_tab[hanum]);
-
     if (ha->type == GDT_EISA) {
         switch (ha->stype) {
           case GDT3_ID:
@@ -4089,29 +4040,23 @@ static const char *gdth_ctr_name(int hanum)
 
 static const char *gdth_info(struct Scsi_Host *shp)
 {
-    int hanum;
-    gdth_ha_str *ha;
+    gdth_ha_str *ha = shost_priv(shp);
 
     TRACE2(("gdth_info()\n"));
-    hanum = NUMDATA(shp)->hanum;
-    ha    = HADATA(gdth_ctr_tab[hanum]);
-
     return ((const char *)ha->binfo.type_string);
 }
 
 static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
-    int i, hanum;
-    gdth_ha_str *ha;
+    gdth_ha_str *ha = shost_priv(scp->device->host);
+    int i;
     ulong flags;
     Scsi_Cmnd *cmnd;
     unchar b;
 
     TRACE2(("gdth_eh_bus_reset()\n"));
 
-    hanum = NUMDATA(scp->device->host)->hanum;
     b = scp->device->channel;
-    ha    = HADATA(gdth_ctr_tab[hanum]);
 
     /* clear command tab */
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -4128,9 +4073,9 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
             if (ha->hdr[i].present) {
                 spin_lock_irqsave(&ha->smp_lock, flags);
                 gdth_polling = TRUE;
-                while (gdth_test_busy(hanum))
+                while (gdth_test_busy(ha))
                     gdth_delay(0);
-                if (gdth_internal_cmd(hanum, CACHESERVICE, 
+                if (gdth_internal_cmd(ha, CACHESERVICE,
                                       GDT_CLUST_RESET, i, 0, 0))
                     ha->hdr[i].cluster_type &= ~CLUSTER_RESERVED;
                 gdth_polling = FALSE;
@@ -4143,9 +4088,9 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
         for (i = 0; i < MAXID; ++i)
             ha->raw[BUS_L2P(ha,b)].io_cnt[i] = 0;
         gdth_polling = TRUE;
-        while (gdth_test_busy(hanum))
+        while (gdth_test_busy(ha))
             gdth_delay(0);
-        gdth_internal_cmd(hanum, SCSIRAWSERVICE, GDT_RESET_BUS,
+        gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_RESET_BUS,
                           BUS_L2P(ha,b), 0, 0);
         gdth_polling = FALSE;
         spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -4156,18 +4101,15 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
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
-    TRACE2(("gdth_bios_param() ha %d bus %d target %d\n", hanum, b, t)); 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE2(("gdth_bios_param() ha %d bus %d target %d\n", ha->hanum, b, t));
 
     if (b != ha->virt_bus || ha->hdr[t].heads == 0) {
         /* raw device or host drive without mapping information */
@@ -4187,7 +4129,7 @@ static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,se
 
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
 {
-    int hanum;
+    gdth_ha_str *ha = shost_priv(scp->device->host);
     int priority;
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
@@ -4199,7 +4141,6 @@ static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
     scp->SCp.Status = GDTH_MAP_NONE;
     scp->SCp.buffer = (struct scatterlist *)NULL;
 
-    hanum = NUMDATA(scp->device->host)->hanum;
 #ifdef GDTH_STATISTICS
     ++act_ios;
 #endif
@@ -4208,10 +4149,10 @@ static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
     if (scp->done == gdth_scsi_done)
         priority = scp->SCp.this_residual;
     else
-        gdth_update_timeout(hanum, scp, scp->timeout_per_command * 6);
+        gdth_update_timeout(scp, scp->timeout_per_command * 6);
 
-    gdth_putq( hanum, scp, priority );
-    gdth_next( hanum );
+    gdth_putq(ha, scp, priority);
+    gdth_next(ha);
     return 0;
 }
 
@@ -4222,7 +4163,7 @@ static int gdth_open(struct inode *inode, struct file *filep)
     int i;
 
     for (i = 0; i < gdth_ctr_count; i++) {
-        ha = HADATA(gdth_ctr_tab[i]);
+        ha = shost_priv(gdth_ctr_tab[i]);
         if (!ha->sdev)
             ha->sdev = scsi_get_host_dev(gdth_ctr_tab[i]);
     }
@@ -4246,7 +4187,7 @@ static int ioc_event(void __user *arg)
     if (copy_from_user(&evt, arg, sizeof(gdth_ioctl_event)) ||
         evt.ionode >= gdth_ctr_count)
         return -EFAULT;
-    ha = HADATA(gdth_ctr_tab[evt.ionode]);
+    ha = shost_priv(gdth_ctr_tab[evt.ionode]);
 
     if (evt.erase == 0xff) {
         if (evt.event.event_source == ES_TEST)
@@ -4283,7 +4224,7 @@ static int ioc_lockdrv(void __user *arg)
     if (copy_from_user(&ldrv, arg, sizeof(gdth_ioctl_lockdrv)) ||
         ldrv.ionode >= gdth_ctr_count)
         return -EFAULT;
-    ha = HADATA(gdth_ctr_tab[ldrv.ionode]);
+    ha = shost_priv(gdth_ctr_tab[ldrv.ionode]);
  
     for (i = 0; i < ldrv.drive_cnt && i < MAX_HDRIVES; ++i) {
         j = ldrv.drives[i];
@@ -4293,14 +4234,14 @@ static int ioc_lockdrv(void __user *arg)
             spin_lock_irqsave(&ha->smp_lock, flags);
             ha->hdr[j].lock = 1;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
-            gdth_wait_completion(ldrv.ionode, ha->bus_cnt, j); 
-            gdth_stop_timeout(ldrv.ionode, ha->bus_cnt, j); 
+            gdth_wait_completion(ha, ha->bus_cnt, j);
+            gdth_stop_timeout(ha, ha->bus_cnt, j);
         } else {
             spin_lock_irqsave(&ha->smp_lock, flags);
             ha->hdr[j].lock = 0;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
-            gdth_start_timeout(ldrv.ionode, ha->bus_cnt, j); 
-            gdth_next(ldrv.ionode); 
+            gdth_start_timeout(ha, ha->bus_cnt, j);
+            gdth_next(ha);
         }
     } 
     return 0;
@@ -4310,16 +4251,14 @@ static int ioc_resetdrv(void __user *arg, char *cmnd)
 {
     gdth_ioctl_reset res;
     gdth_cmd_str cmd;
-    int hanum;
     gdth_ha_str *ha;
     int rval;
 
     if (copy_from_user(&res, arg, sizeof(gdth_ioctl_reset)) ||
         res.ionode >= gdth_ctr_count || res.number >= MAX_HDRIVES)
         return -EFAULT;
-    hanum = res.ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
- 
+    ha = shost_priv(gdth_ctr_tab[res.ionode]);
+
     if (!ha->hdr[res.number].present)
         return 0;
     memset(&cmd, 0, sizeof(gdth_cmd_str));
@@ -4345,22 +4284,20 @@ static int ioc_general(void __user *arg, char *cmnd)
     gdth_ioctl_general gen;
     char *buf = NULL;
     ulong64 paddr; 
-    int hanum;
     gdth_ha_str *ha;
     int rval;
         
     if (copy_from_user(&gen, arg, sizeof(gdth_ioctl_general)) ||
         gen.ionode >= gdth_ctr_count)
         return -EFAULT;
-    hanum = gen.ionode; 
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[gen.ionode]);
     if (gen.data_len + gen.sense_len != 0) {
-        if (!(buf = gdth_ioctl_alloc(hanum, gen.data_len + gen.sense_len, 
+        if (!(buf = gdth_ioctl_alloc(ha, gen.data_len + gen.sense_len,
                                      FALSE, &paddr)))
             return -EFAULT;
         if (copy_from_user(buf, arg + sizeof(gdth_ioctl_general),  
                            gen.data_len + gen.sense_len)) {
-            gdth_ioctl_free(hanum, gen.data_len+gen.sense_len, buf, paddr);
+            gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
             return -EFAULT;
         }
 
@@ -4434,7 +4371,7 @@ static int ioc_general(void __user *arg, char *cmnd)
                 gen.command.u.raw.sense_data = (ulong32)paddr + gen.data_len;
             }
         } else {
-            gdth_ioctl_free(hanum, gen.data_len+gen.sense_len, buf, paddr);
+            gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
             return -EFAULT;
         }
     }
@@ -4446,15 +4383,15 @@ static int ioc_general(void __user *arg, char *cmnd)
 
     if (copy_to_user(arg + sizeof(gdth_ioctl_general), buf, 
                      gen.data_len + gen.sense_len)) {
-        gdth_ioctl_free(hanum, gen.data_len+gen.sense_len, buf, paddr);
+        gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
         return -EFAULT; 
     } 
     if (copy_to_user(arg, &gen, 
         sizeof(gdth_ioctl_general) - sizeof(gdth_cmd_str))) {
-        gdth_ioctl_free(hanum, gen.data_len+gen.sense_len, buf, paddr);
+        gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
         return -EFAULT;
     }
-    gdth_ioctl_free(hanum, gen.data_len+gen.sense_len, buf, paddr);
+    gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
     return 0;
 }
  
@@ -4464,7 +4401,7 @@ static int ioc_hdrlist(void __user *arg, char *cmnd)
     gdth_cmd_str *cmd;
     gdth_ha_str *ha;
     unchar i;
-    int hanum, rc = -ENOMEM;
+    int rc = -ENOMEM;
     u32 cluster_type = 0;
 
     rsc = kmalloc(sizeof(*rsc), GFP_KERNEL);
@@ -4477,8 +4414,7 @@ static int ioc_hdrlist(void __user *arg, char *cmnd)
         rc = -EFAULT;
         goto free_fail;
     }
-    hanum = rsc->ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[rsc->ionode]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
    
     for (i = 0; i < MAX_HDRIVES; ++i) { 
@@ -4519,7 +4455,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
     gdth_cmd_str *cmd;
     ushort i, status, hdr_cnt;
     ulong32 info;
-    int hanum, cyls, hds, secs;
+    int cyls, hds, secs;
     int rc = -ENOMEM;
     ulong flags;
     gdth_ha_str *ha; 
@@ -4534,8 +4470,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         rc = -EFAULT;
         goto free_fail;
     }
-    hanum = rsc->ionode;
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    ha = shost_priv(gdth_ctr_tab[rsc->ionode]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
 
     if (rsc->flag == 0) {
@@ -4694,7 +4629,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         if (copy_from_user(&ctrt, argp, sizeof(gdth_ioctl_ctrtype)) ||
             ctrt.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[ctrt.ionode]);
+        ha = shost_priv(gdth_ctr_tab[ctrt.ionode]);
         if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
             ctrt.type = (unchar)((ha->stype>>20) - 0x10);
         } else {
@@ -4735,7 +4670,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         if (copy_from_user(&lchn, argp, sizeof(gdth_ioctl_lockchn)) ||
             lchn.ionode >= gdth_ctr_count)
             return -EFAULT;
-        ha = HADATA(gdth_ctr_tab[lchn.ionode]);
+        ha = shost_priv(gdth_ctr_tab[lchn.ionode]);
         
         i = lchn.channel;
         if (i < ha->bus_cnt) {
@@ -4744,16 +4679,16 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
                 ha->raw[i].lock = 1;
                 spin_unlock_irqrestore(&ha->smp_lock, flags);
                 for (j = 0; j < ha->tid_cnt; ++j) {
-                    gdth_wait_completion(lchn.ionode, i, j); 
-                    gdth_stop_timeout(lchn.ionode, i, j); 
+                    gdth_wait_completion(ha, i, j);
+                    gdth_stop_timeout(ha, i, j);
                 }
             } else {
                 spin_lock_irqsave(&ha->smp_lock, flags);
                 ha->raw[i].lock = 0;
                 spin_unlock_irqrestore(&ha->smp_lock, flags);
                 for (j = 0; j < ha->tid_cnt; ++j) {
-                    gdth_start_timeout(lchn.ionode, i, j); 
-                    gdth_next(lchn.ionode); 
+                    gdth_start_timeout(ha, i, j);
+                    gdth_next(ha);
                 }
             }
         } 
@@ -4769,13 +4704,12 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
       case GDTIOCTL_RESET_BUS:
       {
         gdth_ioctl_reset res;
-        int hanum, rval;
+        int rval;
 
         if (copy_from_user(&res, argp, sizeof(gdth_ioctl_reset)) ||
             res.ionode >= gdth_ctr_count)
             return -EFAULT;
-        hanum = res.ionode; 
-        ha = HADATA(gdth_ctr_tab[hanum]);
+        ha = shost_priv(gdth_ctr_tab[res.ionode]);
 
         scp  = kzalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
@@ -4804,16 +4738,14 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
 
 
 /* flush routine */
-static void gdth_flush(int hanum)
+static void gdth_flush(gdth_ha_str *ha)
 {
     int             i;
-    gdth_ha_str     *ha;
     gdth_cmd_str    gdtcmd;
     char            cmnd[MAX_COMMAND_SIZE];   
     memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 
-    TRACE2(("gdth_flush() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE2(("gdth_flush() hanum %d\n", ha->hanum));
 
     for (i = 0; i < MAX_HDRIVES; ++i) {
         if (ha->hdr[i].present) {
@@ -4829,9 +4761,9 @@ static void gdth_flush(int hanum)
                 gdtcmd.u.cache.BlockNo = 1;
                 gdtcmd.u.cache.sg_canz = 0;
             }
-            TRACE2(("gdth_flush(): flush ha %d drive %d\n", hanum, i));
+            TRACE2(("gdth_flush(): flush ha %d drive %d\n", ha->hanum, i));
 
-            gdth_execute(gdth_ctr_tab[hanum], &gdtcmd, cmnd, 30, NULL);
+            gdth_execute(ha->shost, &gdtcmd, cmnd, 30, NULL);
         }
     }
 }
@@ -4855,7 +4787,8 @@ static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
     notifier_disabled = 1;
     printk("GDT-HA: Flushing all host drives .. ");
     for (hanum = 0; hanum < gdth_ctr_count; ++hanum) {
-        gdth_flush(hanum);
+        gdth_ha_str *ha = shost_priv(gdth_ctr_tab[hanum]);
+        gdth_flush(ha);
 
 #ifndef __alpha__
         /* controller reset */
@@ -4863,8 +4796,8 @@ static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
         gdtcmd.BoardNode = LOCALBOARD;
         gdtcmd.Service = CACHESERVICE;
         gdtcmd.OpCode = GDT_RESET;
-        TRACE2(("gdth_halt(): reset controller %d\n", hanum));
-        gdth_execute(gdth_ctr_tab[hanum], &gdtcmd, cmnd, 10, NULL);
+        TRACE2(("gdth_halt(): reset controller %d\n", ha->hanum));
+        gdth_execute(ha->shost, &gdtcmd, cmnd, 10, NULL);
 #endif
     }
     printk("Done.\n");
@@ -4914,10 +4847,10 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
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
@@ -4947,9 +4880,10 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	NUMDATA(shp)->hanum = (ushort)hanum;
+	ha->hanum = (ushort)hanum;
+	ha->shost = shp;
 
-	ha->pccb = CMDDATA(shp);
+	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
 	ha->pdev = NULL;
 
@@ -4986,7 +4920,7 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	ha->scan_mode = rescan ? 0x10 : 0;
 
 	error = -ENODEV;
-	if (!gdth_search_drives(hanum)) {
+	if (!gdth_search_drives(ha)) {
 		printk("GDT-ISA: Error during device scan\n");
 		goto out_free_coal_stat;
 	}
@@ -5003,7 +4937,7 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	shp->max_channel = ha->bus_cnt;
 
 	spin_lock_init(&ha->smp_lock);
-	gdth_enable_int(hanum);
+	gdth_enable_int(ha);
 
 	return 0;
 
@@ -5040,10 +4974,10 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
 
-	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	shp = scsi_register(shtp,sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
-	ha = HADATA(shp);
+	ha = shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_eisa(eisa_slot,ha))
@@ -5065,11 +4999,12 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	NUMDATA(shp)->hanum = (ushort)hanum;
-	TRACE2(("EISA detect Bus 0: hanum %d\n",
-		NUMDATA(shp)->hanum));
+	ha->hanum = (ushort)hanum;
+	ha->shost = shp;
+
+	TRACE2(("EISA detect Bus 0: hanum %d\n", ha->hanum));
 
-	ha->pccb = CMDDATA(shp);
+	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
 
 	error = -ENOMEM;
@@ -5110,7 +5045,7 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 		ha->cmd_tab[i].cmnd = UNUSED_CMND;
 	ha->scan_mode = rescan ? 0x10 : 0;
 
-	if (!gdth_search_drives(hanum)) {
+	if (!gdth_search_drives(ha)) {
 		printk("GDT-EISA: Error during device scan\n");
 		error = -ENODEV;
 		goto out_free_ccb_phys;
@@ -5128,7 +5063,7 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 	shp->max_channel = ha->bus_cnt;
 
 	spin_lock_init(&ha->smp_lock);
-	gdth_enable_int(hanum);
+	gdth_enable_int(ha);
 	return 0;
 
  out_free_ccb_phys:
@@ -5163,10 +5098,10 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	dma_addr_t scratch_dma_handle = 0;
 	int error, hanum, i;
 
-	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	shp = scsi_register(shtp,sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
-	ha = HADATA(shp);
+	ha = shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_pci(&pcistr[ctr],ha))
@@ -5191,9 +5126,10 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	NUMDATA(shp)->hanum = (ushort)hanum;
+	ha->hanum = (ushort)hanum;
+	ha->shost = shp;
 
-	ha->pccb = CMDDATA(shp);
+	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
 
 	error = -ENOMEM;
@@ -5229,8 +5165,8 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	ha->scan_mode = rescan ? 0x10 : 0;
 
 	error = -ENODEV;
-	if (!gdth_search_drives(hanum)) {
-		printk("GDT-PCI %d: Error during device scan\n", hanum);
+	if (!gdth_search_drives(ha)) {
+		printk("GDT-PCI %d: Error during device scan\n", ha->hanum);
 		goto out_free_coal_stat;
 	}
 
@@ -5243,16 +5179,16 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	    !ha->dma64_support) {
 		if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "GDT-PCI %d: "
-				"Unable to set 32-bit DMA\n", hanum);
+				"Unable to set 32-bit DMA\n", ha->hanum);
 				goto out_free_coal_stat;
 		}
 	} else {
 		shp->max_cmd_len = 16;
 		if (!pci_set_dma_mask(pcistr[ctr].pdev, DMA_64BIT_MASK)) {
-			printk("GDT-PCI %d: 64-bit DMA enabled\n", hanum);
+			printk("GDT-PCI %d: 64-bit DMA enabled\n", ha->hanum);
 		} else if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "GDT-PCI %d: "
-				"Unable to set 64/32-bit DMA\n", hanum);
+				"Unable to set 64/32-bit DMA\n", ha->hanum);
 			goto out_free_coal_stat;
 		}
 	}
@@ -5262,7 +5198,7 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	shp->max_channel = ha->bus_cnt;
 
 	spin_lock_init(&ha->smp_lock);
-	gdth_enable_int(hanum);
+	gdth_enable_int(ha);
 	return 0;
 
  out_free_coal_stat:
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 6884587..e8b9eb7 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
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
@@ -937,20 +940,6 @@ typedef struct {
     struct scsi_device         *sdev;
 } gdth_ha_str;
 
-/* structure for scsi_register(), SCSI bus != 0 */
-typedef struct {
-    ushort      hanum;
-    ushort      busnum;
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
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 07c1622..bb6dce4 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -7,31 +7,29 @@
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
+        return(gdth_set_info(buffer,length,host,ha));
     else
-        return(gdth_get_info(buffer,start,offset,length,host,hanum));
+        return(gdth_get_info(buffer,start,offset,length,host,ha));
 }
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
-                         int hanum)
+                         gdth_ha_str *ha)
 {
     int ret_val = -EINVAL;
 
-    TRACE2(("gdth_set_info() ha %d\n",hanum,));
+    TRACE2(("gdth_set_info() ha %d\n",ha->hanum,));
 
     if (length >= 4) {
         if (strncmp(buffer,"gdth",4) == 0) {
             buffer += 5;
             length -= 5;
-            ret_val = gdth_set_asc_info(host, buffer, length, hanum);
+            ret_val = gdth_set_asc_info(host, buffer, length, ha);
         }
     }
 
@@ -39,11 +37,10 @@ static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
 }
          
 static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
-                        int length,int hanum)
+                        int length, gdth_ha_str *ha)
 {
     int orig_length, drive, wb_mode;
     int i, found;
-    gdth_ha_str     *ha;
     gdth_cmd_str    gdtcmd;
     gdth_cpar_str   *pcpar;
     ulong64         paddr;
@@ -52,8 +49,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
     memset(cmnd, 0xff, 12);
     memset(&gdtcmd, 0, sizeof(gdth_cmd_str));
 
-    TRACE2(("gdth_set_asc_info() ha %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE2(("gdth_set_asc_info() ha %d\n",ha->hanum));
     orig_length = length + 5;
     drive = -1;
     wb_mode = 0;
@@ -129,7 +125,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
     }
 
     if (wb_mode) {
-        if (!gdth_ioctl_alloc(hanum, sizeof(gdth_cpar_str), TRUE, &paddr))
+        if (!gdth_ioctl_alloc(ha, sizeof(gdth_cpar_str), TRUE, &paddr))
             return(-EBUSY);
         pcpar = (gdth_cpar_str *)ha->pscratch;
         memcpy( pcpar, &ha->cpar, sizeof(gdth_cpar_str) );
@@ -143,7 +139,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
 
         gdth_execute(host, &gdtcmd, cmnd, 30, NULL);
 
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, ha->pscratch, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, ha->pscratch, paddr);
         printk("Done.\n");
         return(orig_length);
     }
@@ -153,11 +149,10 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
 }
 
 static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
-                         struct Scsi_Host *host,int hanum)
+                         struct Scsi_Host *host, gdth_ha_str *ha)
 {
     int size = 0,len = 0;
     off_t begin = 0,pos = 0;
-    gdth_ha_str *ha;
     int id, i, j, k, sec, flag;
     int no_mdrv = 0, drv_no, is_mirr;
     ulong32 cnt;
@@ -186,8 +181,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     memset(cmnd, 0xff, 12);
     memset(gdtcmd, 0, sizeof(gdth_cmd_str));
 
-    TRACE2(("gdth_get_info() ha %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE2(("gdth_get_info() ha %d\n",ha->hanum));
 
     
     /* request is i.e. "cat /proc/scsi/gdth/0" */ 
@@ -220,7 +214,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     strcpy(hrec, ha->binfo.type_string);
     size = sprintf(buffer+len,
                    " Number:       \t%d         \tName:          \t%s\n",
-                   hanum, hrec);
+                   ha->hanum, hrec);
     len += size;  pos = begin + len;
 
     if (ha->more_proc)
@@ -270,7 +264,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
         len += size;  pos = begin + len;
         flag = FALSE;
             
-        buf = gdth_ioctl_alloc(hanum, GDTH_SCRATCH, FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < ha->bus_cnt; ++i) {
@@ -373,7 +367,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     goto stop_output;
             }
         }
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, buf, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
 
         if (!flag) {
             size = sprintf(buffer+len, "\n --\n");
@@ -385,7 +379,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
         len += size;  pos = begin + len;
         flag = FALSE;
 
-        buf = gdth_ioctl_alloc(hanum, GDTH_SCRATCH, FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < MAX_LDRIVES; ++i) {
@@ -479,7 +473,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             if (pos > offset + length)
                 goto stop_output;
         }       
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, buf, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
         
         if (!flag) {
             size = sprintf(buffer+len, "\n --\n");
@@ -491,7 +485,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
         len += size;  pos = begin + len;
         flag = FALSE;
 
-        buf = gdth_ioctl_alloc(hanum, GDTH_SCRATCH, FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < MAX_LDRIVES; ++i) {
@@ -550,7 +544,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     goto stop_output;
             }
         }
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, buf, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
         
         if (!flag) {
             size = sprintf(buffer+len, "\n --\n");
@@ -562,7 +556,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
         len += size;  pos = begin + len;
         flag = FALSE;
 
-        buf = gdth_ioctl_alloc(hanum, sizeof(gdth_hget_str), FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, sizeof(gdth_hget_str), FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < MAX_LDRIVES; ++i) {
@@ -595,7 +589,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                 }
             }
         }
-        gdth_ioctl_free(hanum, sizeof(gdth_hget_str), buf, paddr);
+        gdth_ioctl_free(ha, sizeof(gdth_hget_str), buf, paddr);
 
         for (i = 0; i < MAX_HDRIVES; ++i) {
             if (!(ha->hdr[i].present))
@@ -633,7 +627,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
         id = gdth_read_event(ha, id, estr);
         if (estr->event_source == 0)
             break;
-        if (estr->event_data.eu.driver.ionode == hanum &&
+        if (estr->event_data.eu.driver.ionode == ha->hanum &&
             estr->event_source == ES_ASYNC) { 
             gdth_log_event(&estr->event_data, hrec);
             do_gettimeofday(&tv);
@@ -668,17 +662,15 @@ free_fail:
     return rc;
 }
 
-static char *gdth_ioctl_alloc(int hanum, int size, int scratch, 
+static char *gdth_ioctl_alloc(gdth_ha_str *ha, int size, int scratch,
                               ulong64 *paddr)
 {
-    gdth_ha_str *ha;
     ulong flags;
     char *ret_val;
 
     if (size == 0)
         return NULL;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (!ha->scratch_busy && size <= GDTH_SCRATCH) {
@@ -698,12 +690,10 @@ static char *gdth_ioctl_alloc(int hanum, int size, int scratch,
     return ret_val;
 }
 
-static void gdth_ioctl_free(int hanum, int size, char *buf, ulong64 paddr)
+static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr)
 {
-    gdth_ha_str *ha;
     ulong flags;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (buf == ha->pscratch) {
@@ -716,13 +706,11 @@ static void gdth_ioctl_free(int hanum, int size, char *buf, ulong64 paddr)
 }
 
 #ifdef GDTH_IOCTL_PROC
-static int gdth_ioctl_check_bin(int hanum, ushort size)
+static int gdth_ioctl_check_bin(gdth_ha_str *ha, ushort size)
 {
-    gdth_ha_str *ha;
     ulong flags;
     int ret_val;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     ret_val = FALSE;
@@ -735,15 +723,13 @@ static int gdth_ioctl_check_bin(int hanum, ushort size)
 }
 #endif
 
-static void gdth_wait_completion(int hanum, int busnum, int id)
+static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
-    gdth_ha_str *ha;
     ulong flags;
     int i;
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
@@ -763,14 +749,12 @@ static void gdth_wait_completion(int hanum, int busnum, int id)
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
-static void gdth_stop_timeout(int hanum, int busnum, int id)
+static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id)
 {
-    gdth_ha_str *ha;
     ulong flags;
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
@@ -779,21 +763,19 @@ static void gdth_stop_timeout(int hanum, int busnum, int id)
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
-                scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+                scp->SCp.buffers_residual = gdth_update_timeout(scp, 0);
             }
         }
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
-static void gdth_start_timeout(int hanum, int busnum, int id)
+static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id)
 {
-    gdth_ha_str *ha;
     ulong flags;
     Scsi_Cmnd *scp;
     unchar b, t;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
@@ -802,14 +784,14 @@ static void gdth_start_timeout(int hanum, int busnum, int id)
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_start_timeout(): update_timeout()\n"));
-                gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
+                gdth_update_timeout(scp, scp->SCp.buffers_residual);
             }
         }
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
-static int gdth_update_timeout(int hanum, Scsi_Cmnd *scp, int timeout)
+static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout)
 {
     int oldto;
 
diff --git a/drivers/scsi/gdth_proc.h b/drivers/scsi/gdth_proc.h
index dd71777..45e6fda 100644
--- a/drivers/scsi/gdth_proc.h
+++ b/drivers/scsi/gdth_proc.h
@@ -9,20 +9,20 @@ int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
                  int timeout, u32 *info);
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
-                         int hanum);
+                         gdth_ha_str *ha);
 static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
-                         struct Scsi_Host *host,int hanum);
+                         struct Scsi_Host *host, gdth_ha_str *ha);
 
 static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
-                             int length, int hanum);
+                             int length, gdth_ha_str *ha);
 
-static char *gdth_ioctl_alloc(int hanum, int size, int scratch,
-                              ulong64 *paddr);  
-static void gdth_ioctl_free(int hanum, int size, char *buf, ulong64 paddr);
-static void gdth_wait_completion(int hanum, int busnum, int id);
-static void gdth_stop_timeout(int hanum, int busnum, int id);
-static void gdth_start_timeout(int hanum, int busnum, int id);
-static int gdth_update_timeout(int hanum, Scsi_Cmnd *scp, int timeout);
+static char *gdth_ioctl_alloc(gdth_ha_str *ha, int size, int scratch,
+                              ulong64 *paddr);
+static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr);
+static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id);
+static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id);
+static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id);
+static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout);
 
 #endif
 
