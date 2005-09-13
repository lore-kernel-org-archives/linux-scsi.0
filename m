From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] gdth: pass around gdth_ha_str pointers
Date: Tue, 13 Sep 2005 19:56:00 +0200
Message-ID: <20050913175600.GB25746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:15576 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964947AbVIMR4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 13:56:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: achim_leubner@adaptec.com
Cc: linux-scsi@vger.kernel.org

convert calling convention from hba array indices to pointers in most
of the driver.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c	2005-09-11 18:12:04.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.c	2005-09-11 18:14:25.000000000 +0200
@@ -413,14 +413,15 @@
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id, struct pt_regs *regs);
-static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp);
-static int gdth_async_event(int hanum);
+static int gdth_sync_event(gdth_ha_str *ha, int service,
+		unchar index,Scsi_Cmnd *scp);
+static int gdth_async_event(gdth_ha_str *ha);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
 
-static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority);
-static void gdth_next(int hanum);
-static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b);
-static int gdth_special_cmd(int hanum,Scsi_Cmnd *scp);
+static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp,unchar priority);
+static void gdth_next(gdth_ha_str *ha);
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp,unchar b);
+static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, ushort source,
                                       ushort idx, gdth_evt_data *evt);
 static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr);
@@ -428,10 +429,10 @@
                                gdth_evt_str *estr);
 static void gdth_clear_events(void);
 
-static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                                     char *buffer,ushort count);
-static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp);
-static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive);
+static int gdth_internal_cache_cmd(gdth_ha_str *ha,Scsi_Cmnd *scp);
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp,ushort hdrive);
 
 static int gdth_search_eisa(ushort eisa_adr);
 static int gdth_search_isa(ulong32 bios_adr);
@@ -443,25 +444,25 @@
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
+			     ulong32 p1, ulong64 p2, ulong64 p3);
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
 
 #ifdef DEBUG_GDTH
@@ -575,7 +576,8 @@
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 static unchar   gdth_polling;                           /* polling if TRUE */
 static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
-static int      wait_index,wait_hanum;                  /* gdth_wait() */
+static int      wait_index;                             /* gdth_wait() */
+static gdth_ha_str *wait_ha;				/* gdth_wait() */
 static int      gdth_ctr_count  = 0;                    /* controller count */
 static int      gdth_ctr_vcount = 0;                    /* virt. ctr. count */
 static int      gdth_ctr_released = 0;                  /* gdth_release() */
@@ -1438,16 +1440,14 @@
 
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
+    TRACE(("gdth_enable_int() hanum %d\n", ha->ha_num));
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (ha->type == GDT_EISA) {
@@ -1511,14 +1511,12 @@
 }
                  
     
-static int gdth_test_busy(int hanum)
+static int gdth_test_busy(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     register int gdtsema0 = 0;
 
-    TRACE(("gdth_test_busy() hanum %d\n",hanum));
+    TRACE(("gdth_test_busy() hanum %d\n", ha->ha_num));
     
-    ha = HADATA(gdth_ctr_tab[hanum]);
     if (ha->type == GDT_EISA)
         gdtsema0 = (int)inb(ha->bmic + SEMA0REG);
     else if (ha->type == GDT_ISA)
@@ -1535,14 +1533,12 @@
 }
 
 
-static int gdth_get_cmd_index(int hanum)
+static int gdth_get_cmd_index(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     int i;
 
-    TRACE(("gdth_get_cmd_index() hanum %d\n",hanum));
+    TRACE(("gdth_get_cmd_index() hanum %d\n", ha->ha_num));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     for (i=0; i<GDTH_MAXCMDS; ++i) {
         if (ha->cmd_tab[i].cmnd == UNUSED_CMND) {
             ha->cmd_tab[i].cmnd = ha->pccb->RequestBuffer;
@@ -1555,13 +1551,10 @@
 }
 
 
-static void gdth_set_sema0(int hanum)
+static void gdth_set_sema0(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
-
-    TRACE(("gdth_set_sema0() hanum %d\n",hanum));
+    TRACE(("gdth_set_sema0() hanum %d\n", ha->ha_num));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     if (ha->type == GDT_EISA) {
         outb(1, ha->bmic + SEMA0REG);
     } else if (ha->type == GDT_ISA) {
@@ -1576,9 +1569,8 @@
 }
 
 
-static void gdth_copy_command(int hanum)
+static void gdth_copy_command(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmd_ptr;
     register gdt6m_dpram_str __iomem *dp6m_ptr;
     register gdt6c_dpram_str __iomem *dp6c_ptr;
@@ -1586,9 +1578,8 @@
     gdt2_dpram_str __iomem *dp2_ptr;
     ushort cp_count,dp_offset,cmd_no;
     
-    TRACE(("gdth_copy_command() hanum %d\n",hanum));
+    TRACE(("gdth_copy_command() hanum %d\n", ha->ha_num));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     cp_count = ha->cmd_len;
     dp_offset= ha->cmd_offs_dpmem;
     cmd_no   = ha->cmd_cnt;
@@ -1637,12 +1628,9 @@
 }
 
 
-static void gdth_release_event(int hanum)
+static void gdth_release_event(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
-
-    TRACE(("gdth_release_event() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_release_event() hanum %d\n", ha->ha_num));
 
 #ifdef GDTH_STATISTICS
     {
@@ -1677,21 +1665,20 @@
 }
 
     
-static int gdth_wait(int hanum,int index,ulong32 time)
+static int gdth_wait(gdth_ha_str *ha, int index,ulong32 time)
 {
-    gdth_ha_str *ha;
     int answer_found = FALSE;
 
-    TRACE(("gdth_wait() hanum %d index %d time %d\n",hanum,index,time));
+    TRACE(("gdth_wait() hanum %d index %d time %d\n",
+			    ha->ha_num, index, time));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     if (index == 0)
         return 1;                               /* no wait required */
 
     gdth_from_wait = TRUE;
     do {
         gdth_interrupt((int)ha->irq,ha,NULL);
-        if (wait_hanum==hanum && wait_index==index) {
+        if (wait_ha==ha && wait_index==index) {
             answer_found = TRUE;
             break;
         }
@@ -1699,23 +1686,21 @@
     } while (--time);
     gdth_from_wait = FALSE;
     
-    while (gdth_test_busy(hanum))
+    while (gdth_test_busy(ha))
         gdth_delay(0);
 
     return (answer_found);
 }
 
 
-static int gdth_internal_cmd(int hanum,unchar service,ushort opcode,ulong32 p1,
-                             ulong64 p2,ulong64 p3)
+static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
+			     ulong32 p1, ulong64 p2, ulong64 p3)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmd_ptr;
     int retries,index;
 
     TRACE2(("gdth_internal_cmd() service %d opcode %d\n",service,opcode));
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     cmd_ptr = ha->pccb;
     memset((char*)cmd_ptr,0,sizeof(gdth_cmd_str));
 
@@ -1723,11 +1708,11 @@
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
@@ -1767,10 +1752,10 @@
         ha->cmd_len          = sizeof(gdth_cmd_str);
         ha->cmd_offs_dpmem   = 0;
         ha->cmd_cnt          = 0;
-        gdth_copy_command(hanum);
-        gdth_release_event(hanum);
+        gdth_copy_command(ha);
+        gdth_release_event(ha);
         gdth_delay(20);
-        if (!gdth_wait(hanum,index,INIT_TIMEOUT)) {
+        if (!gdth_wait(ha,index,INIT_TIMEOUT)) {
             printk("GDT: Initialization error (timeout service %d)\n",service);
             return 0;
         }
@@ -1785,9 +1770,8 @@
 
 /* search for devices */
 
-static int __init gdth_search_drives(int hanum)
+static int __init gdth_search_drives(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     ushort cdev_cnt, i;
     int ok;
     ulong32 bus_no, drv_cnt, drv_no, j;
@@ -1807,22 +1791,21 @@
     ulong flags;
 #endif     
    
-    TRACE(("gdth_search_drives() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_search_drives() hanum %d\n", ha->ha_num));
     ok = 0;
 
     /* initialize controller services, at first: screen service */
     ha->screen_feat = 0;
     if (!force_dma32) {
-        ok = gdth_internal_cmd(hanum,SCREENSERVICE,GDT_X_INIT_SCR,0,0,0);
+        ok = gdth_internal_cmd(ha, SCREENSERVICE,GDT_X_INIT_SCR, 0, 0, 0);
         if (ok)
             ha->screen_feat = GDT_64BIT;
     }
     if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
-        ok = gdth_internal_cmd(hanum,SCREENSERVICE,GDT_INIT,0,0,0);
+        ok = gdth_internal_cmd(ha, SCREENSERVICE, GDT_INIT, 0, 0, 0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error screen service (code %d)\n",
-               hanum, ha->status);
+               ha->ha_num, ha->status);
         return 0;
     }
     TRACE2(("gdth_search_drives(): SCREENSERVICE initialized\n"));
@@ -1846,25 +1829,25 @@
     TRACE2(("gdth_search_drives(): RTC: %x/%x/%x\n",*(ulong32 *)&rtc[0],
             *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]));
     /* 3. send to controller firmware */
-    gdth_internal_cmd(hanum,SCREENSERVICE,GDT_REALTIME, *(ulong32 *)&rtc[0],
+    gdth_internal_cmd(ha, SCREENSERVICE, GDT_REALTIME, *(ulong32 *)&rtc[0],
                       *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]);
 #endif  
  
     /* unfreeze all IOs */
-    gdth_internal_cmd(hanum,CACHESERVICE,GDT_UNFREEZE_IO,0,0,0);
+    gdth_internal_cmd(ha,CACHESERVICE,GDT_UNFREEZE_IO,0,0,0);
  
     /* initialize cache service */
     ha->cache_feat = 0;
     if (!force_dma32) {
-        ok = gdth_internal_cmd(hanum,CACHESERVICE,GDT_X_INIT_HOST,LINUX_OS,0,0);
+        ok = gdth_internal_cmd(ha,CACHESERVICE,GDT_X_INIT_HOST,LINUX_OS,0,0);
         if (ok)
             ha->cache_feat = GDT_64BIT;
     }
     if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
-        ok = gdth_internal_cmd(hanum,CACHESERVICE,GDT_INIT,LINUX_OS,0,0);
+        ok = gdth_internal_cmd(ha,CACHESERVICE,GDT_INIT,LINUX_OS,0,0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error cache service (code %d)\n",
-               hanum, ha->status);
+               ha->ha_num, ha->status);
         return 0;
     }
     TRACE2(("gdth_search_drives(): CACHESERVICE initialized\n"));
@@ -1893,9 +1876,9 @@
         pmod->cmd_buff_size    = 0;
         pmod->reserved1        = 0;            
         pmod->reserved2        = 0;            
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,SET_PERF_MODES,
+        if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,SET_PERF_MODES,
                               INVALID_CHANNEL,sizeof(gdth_perf_modes))) {
-            printk("GDT-HA %d: Interrupt coalescing activated\n", hanum);
+            printk("GDT-HA %d: Interrupt coalescing activated\n", ha->ha_num);
         }
     }
 #endif
@@ -1907,7 +1890,7 @@
     iocr->hdr.first_chan     = 0;
     iocr->hdr.last_chan      = MAXBUS-1;
     iocr->hdr.list_offset    = GDTOFFSOF(gdth_raw_iochan_str, list[0]);
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,IOCHAN_RAW_DESC,
+    if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,IOCHAN_RAW_DESC,
                           INVALID_CHANNEL,sizeof(gdth_raw_iochan_str))) {
         TRACE2(("IOCHAN_RAW_DESC supported!\n"));
         ha->bus_cnt = iocr->hdr.chan_count;
@@ -1922,13 +1905,13 @@
         chn = (gdth_getch_str *)ha->pscratch;
         for (bus_no = 0; bus_no < MAXBUS; ++bus_no) {
             chn->channel_no = bus_no;
-            if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            if (!gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,
                                    SCSI_CHAN_CNT | L_CTRL_PATTERN,
                                    IO_CHANNEL | INVALID_CHANNEL,
                                    sizeof(gdth_getch_str))) {
                 if (bus_no == 0) {
                     printk("GDT-HA %d: Error detecting channel count (0x%x)\n",
-                           hanum, ha->status);
+                           ha->ha_num, ha->status);
                     return 0;
                 }
                 break;
@@ -1943,10 +1926,10 @@
     TRACE2(("gdth_search_drives() %d channels\n",ha->bus_cnt));
 
     /* read cache configuration */
-    if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,CACHE_INFO,
+    if (!gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,CACHE_INFO,
                            INVALID_CHANNEL,sizeof(gdth_cinfo_str))) {
         printk("GDT-HA %d: Initialization error cache service (code %d)\n",
-               hanum, ha->status);
+               ha->ha_num, ha->status);
         return 0;
     }
     ha->cpar = ((gdth_cinfo_str *)ha->pscratch)->cpar;
@@ -1956,11 +1939,11 @@
 
     /* read board info and features */
     ha->more_proc = FALSE;
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,BOARD_INFO,
+    if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,BOARD_INFO,
                           INVALID_CHANNEL,sizeof(gdth_binfo_str))) {
         memcpy(&ha->binfo, (gdth_binfo_str *)ha->pscratch,
                sizeof(gdth_binfo_str));
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,BOARD_FEATURES,
+        if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,BOARD_FEATURES,
                               INVALID_CHANNEL,sizeof(gdth_bfeat_str))) {
             TRACE2(("BOARD_INFO/BOARD_FEATURES supported\n"));
             ha->bfeat = *(gdth_bfeat_str *)ha->pscratch;
@@ -1968,7 +1951,7 @@
         }
     } else {
         TRACE2(("BOARD_INFO requires firmware >= 1.10/2.08\n"));
-        strcpy(ha->binfo.type_string, gdth_ctr_name(hanum));
+        strcpy(ha->binfo.type_string, gdth_ctr_name(ha));
     }
     TRACE2(("Controller name: %s\n",ha->binfo.type_string));
 
@@ -1981,7 +1964,7 @@
         ioc->hdr.first_chan     = 0;
         ioc->hdr.last_chan      = MAXBUS-1;
         ioc->hdr.list_offset    = GDTOFFSOF(gdth_iochan_str, list[0]);
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,IOCHAN_DESC,
+        if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,IOCHAN_DESC,
                               INVALID_CHANNEL,sizeof(gdth_iochan_str))) {
             for (bus_no = 0; bus_no < ha->bus_cnt; ++bus_no) {
                 ha->raw[bus_no].address = ioc->list[bus_no].address;
@@ -1996,7 +1979,7 @@
         for (bus_no = 0; bus_no < ha->bus_cnt; ++bus_no) {
             chn = (gdth_getch_str *)ha->pscratch;
             chn->channel_no = ha->raw[bus_no].local_no;
-            if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,
                                   SCSI_CHAN_CNT | L_CTRL_PATTERN,
                                   ha->raw[bus_no].address | INVALID_CHANNEL,
                                   sizeof(gdth_getch_str))) {
@@ -2008,7 +1991,7 @@
                 drl = (gdth_drlist_str *)ha->pscratch;
                 drl->sc_no = ha->raw[bus_no].local_no;
                 drl->sc_cnt = ha->raw[bus_no].pdev_cnt;
-                if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+                if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,
                                       SCSI_DR_LIST | L_CTRL_PATTERN,
                                       ha->raw[bus_no].address | INVALID_CHANNEL,
                                       sizeof(gdth_drlist_str))) {
@@ -2021,10 +2004,10 @@
         }
 
         /* logical drives */
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,CACHE_DRV_CNT,
+        if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,CACHE_DRV_CNT,
                               INVALID_CHANNEL,sizeof(ulong32))) {
             drv_cnt = *(ulong32 *)ha->pscratch;
-            if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,CACHE_DRV_LIST,
+            if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,CACHE_DRV_LIST,
                                   INVALID_CHANNEL,drv_cnt * sizeof(ulong32))) {
                 for (j = 0; j < drv_cnt; ++j) {
                     drv_no = ((ulong32 *)ha->pscratch)[j];
@@ -2038,7 +2021,7 @@
             alst->entries_avail = MAX_LDRIVES;
             alst->first_entry = 0;
             alst->list_offset = GDTOFFSOF(gdth_arcdl_str, list[0]);
-            if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,
                                   ARRAY_DRV_LIST2 | LA_CTRL_PATTERN, 
                                   INVALID_CHANNEL, sizeof(gdth_arcdl_str) +
                                   (alst->entries_avail-1) * sizeof(gdth_alist_str))) { 
@@ -2049,7 +2032,7 @@
                     ha->hdr[j].is_hotfix = alst->list[j].is_hotfix;
                     ha->hdr[j].master_no = alst->list[j].cd_handle;
                 }
-            } else if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+            } else if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,
                                          ARRAY_DRV_LIST | LA_CTRL_PATTERN,
                                          0, 35 * sizeof(gdth_alist_str))) {
                 for (j = 0; j < 35; ++j) {
@@ -2067,24 +2050,24 @@
     /* initialize raw service */
     ha->raw_feat = 0;
     if (!force_dma32) {
-        ok = gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_X_INIT_RAW,0,0,0);
+        ok = gdth_internal_cmd(ha,SCSIRAWSERVICE,GDT_X_INIT_RAW,0,0,0);
         if (ok)
             ha->raw_feat = GDT_64BIT;
     }
     if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
-        ok = gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_INIT,0,0,0);
+        ok = gdth_internal_cmd(ha,SCSIRAWSERVICE,GDT_INIT,0,0,0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error raw service (code %d)\n",
-               hanum, ha->status);
+               ha->ha_num, ha->status);
         return 0;
     }
     TRACE2(("gdth_search_drives(): RAWSERVICE initialized\n"));
 
     /* set/get features raw service (scatter/gather) */
-    if (gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_SET_FEAT,SCATTER_GATHER,
+    if (gdth_internal_cmd(ha,SCSIRAWSERVICE,GDT_SET_FEAT,SCATTER_GATHER,
                           0,0)) {
         TRACE2(("gdth_search_drives(): set features RAWSERVICE OK\n"));
-        if (gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_GET_FEAT,0,0,0)) {
+        if (gdth_internal_cmd(ha,SCSIRAWSERVICE,GDT_GET_FEAT,0,0,0)) {
             TRACE2(("gdth_search_dr(): get feat RAWSERVICE %d\n",
                     ha->info));
             ha->raw_feat |= (ushort)ha->info;
@@ -2092,10 +2075,10 @@
     } 
 
     /* set/get features cache service (equal to raw service) */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_SET_FEAT,0,
+    if (gdth_internal_cmd(ha,CACHESERVICE,GDT_SET_FEAT,0,
                           SCATTER_GATHER,0)) {
         TRACE2(("gdth_search_drives(): set features CACHESERVICE OK\n"));
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_GET_FEAT,0,0,0)) {
+        if (gdth_internal_cmd(ha,CACHESERVICE,GDT_GET_FEAT,0,0,0)) {
             TRACE2(("gdth_search_dr(): get feat CACHESERV. %d\n",
                     ha->info));
             ha->cache_feat |= (ushort)ha->info;
@@ -2104,22 +2087,22 @@
 
     /* reserve drives for raw service */
     if (reserve_mode != 0) {
-        gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_RESERVE_ALL,
+        gdth_internal_cmd(ha,SCSIRAWSERVICE,GDT_RESERVE_ALL,
                           reserve_mode == 1 ? 1 : 3, 0, 0);
         TRACE2(("gdth_search_drives(): RESERVE_ALL code %d\n", 
                 ha->status));
     }
     for (i = 0; i < MAX_RES_ARGS; i += 4) {
-        if (reserve_list[i] == hanum && reserve_list[i+1] < ha->bus_cnt && 
+        if (reserve_list[i] == ha->ha_num && reserve_list[i+1] < ha->bus_cnt &&
             reserve_list[i+2] < ha->tid_cnt && reserve_list[i+3] < MAXLUN) {
             TRACE2(("gdth_search_drives(): reserve ha %d bus %d id %d lun %d\n",
                     reserve_list[i], reserve_list[i+1],
                     reserve_list[i+2], reserve_list[i+3]));
-            if (!gdth_internal_cmd(hanum,SCSIRAWSERVICE,GDT_RESERVE,0,
+            if (!gdth_internal_cmd(ha,SCSIRAWSERVICE,GDT_RESERVE,0,
                                    reserve_list[i+1], reserve_list[i+2] | 
                                    (reserve_list[i+3] << 8))) {
                 printk("GDT-HA %d: Error raw service (RESERVE, code %d)\n",
-                       hanum, ha->status);
+                       ha->ha_num, ha->status);
              }
         }
     }
@@ -2128,12 +2111,12 @@
     oemstr = (gdth_oem_str_ioctl *)ha->pscratch;
     oemstr->params.ctl_version = 0x01;
     oemstr->params.buffer_size = sizeof(oemstr->text);
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,
+    if (gdth_internal_cmd(ha,CACHESERVICE,GDT_IOCTL,
                           CACHE_READ_OEM_STRING_RECORD,INVALID_CHANNEL,
                           sizeof(gdth_oem_str_ioctl))) {
         TRACE2(("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD OK\n"));
         printk("GDT-HA %d: Vendor: %s Name: %s\n",
-               hanum,oemstr->text.oem_company_name,ha->binfo.type_string);
+               ha->ha_num,oemstr->text.oem_company_name,ha->binfo.type_string);
         /* Save the Host Drive inquiry data */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         strlcpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,
@@ -2146,7 +2129,7 @@
         /* Old method, based on PCI ID */
         TRACE2(("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD failed\n"));
         printk("GDT-HA %d: Name: %s\n",
-               hanum,ha->binfo.type_string);
+               ha->ha_num,ha->binfo.type_string);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         if (ha->oem_id == OEM_ID_INTEL)
             strlcpy(ha->oem_name,"Intel  ", sizeof(ha->oem_name));
@@ -2162,24 +2145,23 @@
 
     /* scanning for host drives */
     for (i = 0; i < cdev_cnt; ++i) 
-        gdth_analyse_hdrive(hanum,i);
+        gdth_analyse_hdrive(ha,i);
     
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
+    TRACE(("gdth_analyse_hdrive() hanum %d drive %d\n",
+			    ha->ha_num, hdrive));
     if (hdrive >= MAX_HDRIVES)
         return 0;
-    ha = HADATA(gdth_ctr_tab[hanum]);
 
-    if (!gdth_internal_cmd(hanum,CACHESERVICE,GDT_INFO,hdrive,0,0)) 
+    if (!gdth_internal_cmd(ha,CACHESERVICE,GDT_INFO,hdrive,0,0))
         return 0;
     ha->hdr[hdrive].present = TRUE;
     ha->hdr[hdrive].size = ha->info;
@@ -2199,7 +2181,7 @@
     ha->hdr[hdrive].size  = drv_cyls * drv_hds * drv_secs;
     
     if (ha->cache_feat & GDT_64BIT) {
-        if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_X_INFO,hdrive,0,0)
+        if (gdth_internal_cmd(ha,CACHESERVICE,GDT_X_INFO,hdrive,0,0)
             && ha->info2 != 0) {
             ha->hdr[hdrive].size = ((ulong64)ha->info2 << 32) | ha->info;
         }
@@ -2208,14 +2190,14 @@
             hdrive,ha->hdr[hdrive].size,drv_hds,drv_secs));
 
     /* get informations about device */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_DEVTYPE,hdrive,0,0)) {
+    if (gdth_internal_cmd(ha,CACHESERVICE,GDT_DEVTYPE,hdrive,0,0)) {
         TRACE2(("gdth_search_dr() cache drive %d devtype %d\n",
                 hdrive,ha->info));
         ha->hdr[hdrive].devtype = (ushort)ha->info;
     }
 
     /* cluster info */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_CLUST_INFO,hdrive,0,0)) {
+    if (gdth_internal_cmd(ha,CACHESERVICE,GDT_CLUST_INFO,hdrive,0,0)) {
         TRACE2(("gdth_search_dr() cache drive %d cluster info %d\n",
                 hdrive,ha->info));
         if (!shared_access)
@@ -2223,7 +2205,7 @@
     }
 
     /* R/W attributes */
-    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_RW_ATTRIBS,hdrive,0,0)) {
+    if (gdth_internal_cmd(ha,CACHESERVICE,GDT_RW_ATTRIBS,hdrive,0,0)) {
         TRACE2(("gdth_search_dr() cache drive %d r/w attrib. %d\n",
                 hdrive,ha->info));
         ha->hdr[hdrive].rw_attribs = (unchar)ha->info;
@@ -2235,16 +2217,14 @@
 
 /* command queueing/sending functions */
 
-static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
+static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp,unchar priority)
 {
-    register gdth_ha_str *ha;
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
     ulong flags;
     unchar b, t;
 
     TRACE(("gdth_putq() priority %d\n",priority));
-    ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     scp->SCp.this_residual = (int)priority;
@@ -2254,7 +2234,7 @@
         if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
             (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) {
             TRACE2(("gdth_putq(): locked IO -> update_timeout()\n"));
-            scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+            scp->SCp.buffers_residual = gdth_update_timeout(scp, 0);
         }
     }
 
@@ -2285,9 +2265,8 @@
 #endif
 }
 
-static void gdth_next(int hanum)
+static void gdth_next(gdth_ha_str *ha)
 {
-    register gdth_ha_str *ha;
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
     unchar b, t, l, firsttime;
@@ -2295,8 +2274,7 @@
     ulong flags = 0;
     int cmd_index;
 
-    TRACE(("gdth_next() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE(("gdth_next() hanum %d\n", ha->ha_num));
     if (!gdth_polling) 
         spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -2318,13 +2296,13 @@
         }
 
         if (firsttime) {
-            if (gdth_test_busy(hanum)) {        /* controller busy ? */
-                TRACE(("gdth_next() controller %d busy !\n",hanum));
+            if (gdth_test_busy(ha)) {        /* controller busy ? */
+                TRACE(("gdth_next() controller %d busy !\n", ha->ha_num));
                 if (!gdth_polling) {
                     spin_unlock_irqrestore(&ha->smp_lock, flags);
                     return;
                 }
-                while (gdth_test_busy(hanum))
+                while (gdth_test_busy(ha))
                     gdth_delay(1);
             }   
             firsttime = FALSE;
@@ -2376,11 +2354,11 @@
 
         if (nscp->SCp.sent_command != -1) {
             if ((nscp->SCp.phase & 0xff) == CACHESERVICE) {
-                if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                if (!(cmd_index=gdth_fill_cache_cmd(ha,nscp,t)))
                     this_cmd = FALSE;
                 next_cmd = FALSE;
             } else if ((nscp->SCp.phase & 0xff) == SCSIRAWSERVICE) {
-                if (!(cmd_index=gdth_fill_raw_cmd(hanum,nscp,BUS_L2P(ha,b))))
+                if (!(cmd_index=gdth_fill_raw_cmd(ha,nscp,BUS_L2P(ha,b))))
                     this_cmd = FALSE;
                 next_cmd = FALSE;
             } else {
@@ -2394,12 +2372,12 @@
                     nscp->scsi_done(nscp);
             }
         } else if (nscp->done == gdth_scsi_done && nscp->cmnd[0] == 0xff) {
-            if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
+            if (!(cmd_index=gdth_special_cmd(ha,nscp)))
                 this_cmd = FALSE;
             next_cmd = FALSE;
         } else if (b != ha->virt_bus) {
             if (ha->raw[BUS_L2P(ha,b)].io_cnt[t] >= GDTH_MAX_RAW ||
-                !(cmd_index=gdth_fill_raw_cmd(hanum,nscp,BUS_L2P(ha,b)))) 
+                !(cmd_index=gdth_fill_raw_cmd(ha,nscp,BUS_L2P(ha,b))))
                 this_cmd = FALSE;
             else 
                 ha->raw[BUS_L2P(ha,b)].io_cnt[t]++;
@@ -2437,7 +2415,7 @@
                         nscp->SCp.have_data_in++;
                     else
                         nscp->scsi_done(nscp);
-                } else if (gdth_internal_cache_cmd(hanum,nscp))
+                } else if (gdth_internal_cache_cmd(ha, nscp))
                     nscp->scsi_done(nscp);
                 break;
 
@@ -2457,7 +2435,7 @@
                     nscp->cmnd[3] = (ha->hdr[t].devtype&1) ? 1:0;
                     TRACE(("Prevent/allow r. %d rem. drive %d\n",
                            nscp->cmnd[4],nscp->cmnd[3]));
-                    if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                    if (!(cmd_index=gdth_fill_cache_cmd(ha,nscp,t)))
                         this_cmd = FALSE;
                 }
                 break;
@@ -2466,7 +2444,7 @@
               case RELEASE:
                 TRACE2(("cache cmd %s\n",nscp->cmnd[0] == RESERVE ?
                         "RESERVE" : "RELEASE"));
-                if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                if (!(cmd_index=gdth_fill_cache_cmd(ha,nscp,t)))
                     this_cmd = FALSE;
                 break;
                 
@@ -2489,7 +2467,7 @@
                         nscp->SCp.have_data_in++;
                     else
                         nscp->scsi_done(nscp);
-                } else if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                } else if (!(cmd_index=gdth_fill_cache_cmd(ha,nscp,t)))
                     this_cmd = FALSE;
                 break;
 
@@ -2498,7 +2476,7 @@
                         nscp->cmnd[1],nscp->cmnd[2],nscp->cmnd[3],
                         nscp->cmnd[4],nscp->cmnd[5]));
                 printk("GDT-HA %d: Unknown SCSI command 0x%x to cache service !\n",
-                       hanum, nscp->cmnd[0]);
+                       ha->ha_num, nscp->cmnd[0]);
                 nscp->result = DID_ABORT << 16;
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
@@ -2519,30 +2497,28 @@
     }
 
     if (ha->cmd_cnt > 0) {
-        gdth_release_event(hanum);
+        gdth_release_event(ha);
     }
 
     if (!gdth_polling) 
         spin_unlock_irqrestore(&ha->smp_lock, flags);
 
     if (gdth_polling && ha->cmd_cnt > 0) {
-        if (!gdth_wait(hanum,cmd_index,POLL_TIMEOUT))
+        if (!gdth_wait(ha,cmd_index,POLL_TIMEOUT))
             printk("GDT-HA %d: Command %d timed out !\n",
-                   hanum,cmd_index);
+                   ha->ha_num,cmd_index);
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
 
     cpcount = count<=(ushort)scp->bufflen ? count:(ushort)scp->bufflen;
-    ha = HADATA(gdth_ctr_tab[hanum]);
 
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
@@ -2555,8 +2531,8 @@
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
             if (!sl->page) {
-                printk("GDT-HA %d: invalid sc/gt element in gdth_copy_internal_data()\n",
-                       hanum);
+                printk("GDT-HA %p: invalid sc/gt element in gdth_copy_internal_data()\n",
+                       ha);
                 return;
             }
 	    local_irq_save(flags);
@@ -2575,16 +2551,14 @@
     }
 }
 
-static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp)
+static int gdth_internal_cache_cmd(gdth_ha_str *ha ,Scsi_Cmnd *scp)
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
@@ -2615,7 +2589,7 @@
         strcpy(inq.vendor,ha->oem_name);
         sprintf(inq.product,"Host Drive  #%02d",t);
         strcpy(inq.revision,"   ");
-        gdth_copy_internal_data(hanum,scp,(char*)&inq,sizeof(gdth_inq_data));
+        gdth_copy_internal_data(ha,scp,(char*)&inq,sizeof(gdth_inq_data));
         break;
 
       case REQUEST_SENSE:
@@ -2625,7 +2599,7 @@
         sd.key       = NO_SENSE;
         sd.info      = 0;
         sd.add_length= 0;
-        gdth_copy_internal_data(hanum,scp,(char*)&sd,sizeof(gdth_sense_data));
+        gdth_copy_internal_data(ha,scp,(char*)&sd,sizeof(gdth_sense_data));
         break;
 
       case MODE_SENSE:
@@ -2637,7 +2611,7 @@
         mpd.bd.block_length[0] = (SECTOR_SIZE & 0x00ff0000) >> 16;
         mpd.bd.block_length[1] = (SECTOR_SIZE & 0x0000ff00) >> 8;
         mpd.bd.block_length[2] = (SECTOR_SIZE & 0x000000ff);
-        gdth_copy_internal_data(hanum,scp,(char*)&mpd,sizeof(gdth_modep_data));
+        gdth_copy_internal_data(ha,scp,(char*)&mpd,sizeof(gdth_modep_data));
         break;
 
       case READ_CAPACITY:
@@ -2647,7 +2621,7 @@
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
         rdc.block_length  = cpu_to_be32(SECTOR_SIZE);
-        gdth_copy_internal_data(hanum,scp,(char*)&rdc,sizeof(gdth_rdcap_data));
+        gdth_copy_internal_data(ha,scp,(char*)&rdc,sizeof(gdth_rdcap_data));
         break;
 
       case SERVICE_ACTION_IN:
@@ -2658,7 +2632,7 @@
             TRACE2(("Read capacity (16) hdrive %d\n",t));
             rdc16.last_block_no = cpu_to_be64(ha->hdr[t].size-1);
             rdc16.block_length  = cpu_to_be32(SECTOR_SIZE);
-            gdth_copy_internal_data(hanum,scp,(char*)&rdc16,sizeof(gdth_rdcap16_data));
+            gdth_copy_internal_data(ha,scp,(char*)&rdc16,sizeof(gdth_rdcap16_data));
         } else { 
             scp->result = DID_ABORT << 16;
         }
@@ -2677,9 +2651,8 @@
     return 0;
 }
     
-static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
+static int gdth_fill_cache_cmd(gdth_ha_str *ha,Scsi_Cmnd *scp,ushort hdrive)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
     struct scatterlist *sl;
     ulong32 cnt, blockcnt;
@@ -2689,7 +2662,6 @@
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     cmdp = ha->pccb;
     TRACE(("gdth_fill_cache_cmd() cmd 0x%x cmdsize %d hdrive %d\n",
                  scp->cmnd[0],scp->cmd_len,hdrive));
@@ -2705,13 +2677,13 @@
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
@@ -2883,13 +2855,12 @@
     }
 
     /* copy command */
-    gdth_copy_command(hanum);
+    gdth_copy_command(ha);
     return cmd_index;
 }
 
-static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp,unchar b)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
     struct scatterlist *sl;
     ushort i;
@@ -2899,7 +2870,6 @@
     struct page *page;
     ulong offset;
 
-    ha = HADATA(gdth_ctr_tab[hanum]);
     t = scp->device->id;
     l = scp->device->lun;
     cmdp = ha->pccb;
@@ -2914,13 +2884,13 @@
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
@@ -3086,17 +3056,15 @@
     }
 
     /* copy command */
-    gdth_copy_command(hanum);
+    gdth_copy_command(ha);
     return cmd_index;
 }
 
-static int gdth_special_cmd(int hanum,Scsi_Cmnd *scp)
+static int gdth_special_cmd(gdth_ha_str *ha,Scsi_Cmnd *scp)
 {
-    register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
     int cmd_index;
 
-    ha  = HADATA(gdth_ctr_tab[hanum]);
     cmdp= ha->pccb;
     TRACE2(("gdth_special_cmd(): "));
 
@@ -3107,14 +3075,14 @@
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
@@ -3152,7 +3120,7 @@
     }
 
     /* copy command */
-    gdth_copy_command(hanum);
+    gdth_copy_command(ha);
     return cmd_index;
 }    
 
@@ -3458,16 +3426,16 @@
                IStatus,ha->status,ha->info));
 
         if (gdth_from_wait) {
-            wait_hanum = hanum;
+            wait_ha = ha2;
             wait_index = (int)IStatus;
         }
 
         if (IStatus == ASYNCINDEX) {
             TRACE2(("gdth_interrupt() async. event\n"));
-            gdth_async_event(hanum);
+            gdth_async_event(ha2);
             if (!gdth_polling)
                 spin_unlock_irqrestore(&ha2->smp_lock, flags);
-            gdth_next(hanum);
+            gdth_next(ha2);
             return IRQ_HANDLED;
         } 
 
@@ -3501,11 +3469,11 @@
         }
 
         TRACE(("gdth_interrupt() sync. status\n"));
-        rval = gdth_sync_event(hanum,Service,IStatus,scp);
+        rval = gdth_sync_event(ha, Service, IStatus, scp);
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha2->smp_lock, flags);
         if (rval == 2) {
-            gdth_putq(hanum,scp,scp->SCp.this_residual);
+            gdth_putq(ha2, scp,scp->SCp.this_residual);
         } else if (rval == 1) {
             scp->scsi_done(scp);
         }
@@ -3535,18 +3503,17 @@
     }
 #endif
 
-    gdth_next(hanum);
+    gdth_next(ha);
     return IRQ_HANDLED;
 }
 
-static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
+static int gdth_sync_event(gdth_ha_str *ha, int service,
+		unchar index, Scsi_Cmnd *scp)
 {
-    register gdth_ha_str *ha;
     gdth_msg_str *msg;
     gdth_cmd_str *cmdp;
     unchar b, t;
 
-    ha   = HADATA(gdth_ctr_tab[hanum]);
     cmdp = ha->pccb;
     TRACE(("gdth_sync_event() serv %d status %d\n",
            service,ha->status));
@@ -3564,12 +3531,12 @@
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
@@ -3579,8 +3546,8 @@
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
                 + sizeof(ulong64);
             ha->cmd_cnt = 0;
-            gdth_copy_command(hanum);
-            gdth_release_event(hanum);
+            gdth_copy_command(ha);
+            gdth_release_event(ha);
             return 0;
         }
 
@@ -3598,12 +3565,12 @@
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
@@ -3613,8 +3580,8 @@
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
@@ -3726,7 +3693,7 @@
                 }
                 if (scp->done != gdth_scsi_done) {
                     ha->dvr.size = sizeof(ha->dvr.eu.sync);
-                    ha->dvr.eu.sync.ionode  = hanum;
+                    ha->dvr.eu.sync.ionode  = ha->ha_num;
                     ha->dvr.eu.sync.service = service;
                     ha->dvr.eu.sync.status  = ha->status;
                     ha->dvr.eu.sync.info    = ha->info;
@@ -3910,25 +3877,23 @@
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
+            ha->ha_num,ha->service));
 
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
@@ -3938,7 +3903,7 @@
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
                 + sizeof(ulong64);
             ha->cmd_cnt = 0;
-            gdth_copy_command(hanum);
+            gdth_copy_command(ha);
             if (ha->type == GDT_EISA)
                 printk("[EISA slot %d] ",(ushort)ha->brd_phys);
             else if (ha->type == GDT_ISA)
@@ -3946,19 +3911,19 @@
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
+            ha->dvr.eu.async.ionode = ha->ha_num;
             ha->dvr.eu.async.status  = ha->status;
             /* severity and event_string already set! */
         } else {        
             ha->dvr.size = sizeof(ha->dvr.eu.async);
-            ha->dvr.eu.async.ionode   = hanum;
+            ha->dvr.eu.async.ionode   = ha->ha_num;
             ha->dvr.eu.async.service = ha->service;
             ha->dvr.eu.async.status  = ha->status;
             ha->dvr.eu.async.info    = ha->info;
@@ -4241,6 +4206,7 @@
                 NUMDATA(shp)->hanum = (ushort)hanum;
                 NUMDATA(shp)->busnum= 0;
 
+		ha->ha_num = hanum;
                 ha->pccb = CMDDATA(shp);
                 ha->ccb_phys = 0L;
                 ha->pdev = NULL;
@@ -4267,7 +4233,7 @@
                 ha->scan_mode = rescan ? 0x10 : 0;
 
                 if (ha->pscratch == NULL || ha->pmsg == NULL || 
-                    !gdth_search_drives(hanum)) {
+                    !gdth_search_drives(ha)) {
                     printk("GDT-ISA: Error during device scan\n");
                     --gdth_ctr_count;
                     --gdth_ctr_vcount;
@@ -4318,7 +4284,7 @@
                 }  
 
                 spin_lock_init(&ha->smp_lock);
-                gdth_enable_int(hanum);
+                gdth_enable_int(ha);
 #endif /* !__ia64__ */
             }
         }
@@ -4363,6 +4329,7 @@
 
                 ha->pccb = CMDDATA(shp);
                 ha->ccb_phys = 0L; 
+		ha->ha_num = hanum;
 
                 ha->pdev = NULL;
                 ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH, 
@@ -4390,7 +4357,7 @@
                 ha->scan_mode = rescan ? 0x10 : 0;
 
                 if (ha->pscratch == NULL || ha->pmsg == NULL || 
-                    !gdth_search_drives(hanum)) {
+                    !gdth_search_drives(ha)) {
                     printk("GDT-EISA: Error during device scan\n");
                     --gdth_ctr_count;
                     --gdth_ctr_vcount;
@@ -4442,7 +4409,7 @@
                 }  
 
                 spin_lock_init(&ha->smp_lock);
-                gdth_enable_int(hanum);
+                gdth_enable_int(ha);
             }
         }
     }
@@ -4487,6 +4454,7 @@
         NUMDATA(shp)->hanum = (ushort)hanum;
         NUMDATA(shp)->busnum= 0;
 
+	ha->ha_num = hanum;
         ha->pccb = CMDDATA(shp);
         ha->ccb_phys = 0L;
 
@@ -4513,7 +4481,7 @@
 
         err = FALSE;
         if (ha->pscratch == NULL || ha->pmsg == NULL || 
-            !gdth_search_drives(hanum)) {
+            !gdth_search_drives(ha)) {
             err = TRUE;
         } else {
             if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
@@ -4581,7 +4549,7 @@
         }  
 
         spin_lock_init(&ha->smp_lock);
-        gdth_enable_int(hanum);
+        gdth_enable_int(ha);
     }
     
     TRACE2(("gdth_detect() %d controller detected\n",gdth_ctr_count));
@@ -4615,7 +4583,7 @@
             scsi_free_host_dev(ha->sdev);
             ha->sdev = NULL;
         }
-        gdth_flush(hanum);
+        gdth_flush(ha);
 
         if (shp->irq) {
             free_irq(shp->irq,ha);
@@ -4657,14 +4625,10 @@
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
@@ -4730,9 +4694,9 @@
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
@@ -4745,9 +4709,9 @@
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
@@ -4798,6 +4762,7 @@
 
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
 {
+    gdth_ha_str *ha;
     int hanum;
     int priority;
 
@@ -4811,6 +4776,7 @@
     scp->SCp.buffer = (struct scatterlist *)NULL;
 
     hanum = NUMDATA(scp->device->host)->hanum;
+    ha = HADATA(gdth_ctr_tab[hanum]);
 #ifdef GDTH_STATISTICS
     ++act_ios;
 #endif
@@ -4818,9 +4784,9 @@
     priority = DEFAULT_PRI;
     if (scp->done == gdth_scsi_done)
         priority = scp->SCp.this_residual;
-    gdth_update_timeout(hanum, scp, scp->timeout_per_command * 6);
-    gdth_putq( hanum, scp, priority );
-    gdth_next( hanum );
+    gdth_update_timeout(scp, scp->timeout_per_command * 6);
+    gdth_putq( ha, scp, priority );
+    gdth_next( ha );
     return 0;
 }
 
@@ -4902,14 +4868,14 @@
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
@@ -4986,12 +4952,12 @@
     hanum = gen.ionode; 
     ha = HADATA(gdth_ctr_tab[hanum]);
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
 
@@ -5065,7 +5031,7 @@
                 gen.command.u.raw.sense_data = (ulong32)paddr + gen.data_len;
             }
         } else {
-            gdth_ioctl_free(hanum, gen.data_len+gen.sense_len, buf, paddr);
+            gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
             return -EFAULT;
         }
     }
@@ -5094,15 +5060,15 @@
 
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
  
@@ -5481,16 +5447,16 @@
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
@@ -5552,10 +5518,9 @@
 
 
 /* flush routine */
-static void gdth_flush(int hanum)
+static void gdth_flush(gdth_ha_str *ha)
 {
     int             i;
-    gdth_ha_str     *ha;
     gdth_cmd_str    gdtcmd;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request    *srp;
@@ -5566,18 +5531,17 @@
     char            cmnd[MAX_COMMAND_SIZE];   
     memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 
-    TRACE2(("gdth_flush() hanum %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE2(("gdth_flush() hanum %d\n", ha->ha_num));
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-    sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
+    sdev = scsi_get_host_dev(gdth_ctr_tab[ha->ha_num]);
     srp  = scsi_allocate_request(sdev, GFP_KERNEL);
     if (!srp)
         return;
     srp->sr_cmd_len = 12;
     srp->sr_use_sg = 0;
 #else
-    sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
+    sdev = scsi_get_host_dev(gdth_ctr_tab[ha->ha_num]);
     scp  = scsi_allocate_device(sdev, 1, FALSE);
     if (!scp)
         return;
@@ -5599,7 +5563,7 @@
                 gdtcmd.u.cache.BlockNo = 1;
                 gdtcmd.u.cache.sg_canz = 0;
             }
-            TRACE2(("gdth_flush(): flush ha %d drive %d\n", hanum, i));
+            TRACE2(("gdth_flush(): flush ha %d drive %d\n", ha->ha_num, i));
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             gdth_do_req(srp, &gdtcmd, cmnd, 30);
 #else
@@ -5638,7 +5602,7 @@
 
     printk("GDT-HA: Flushing all host drives .. ");
     for (hanum = 0; hanum < gdth_ctr_count; ++hanum) {
-        gdth_flush(hanum);
+        gdth_flush(HADATA(gdth_ctr_tab[hanum]));
 
 #ifndef __alpha__
         /* controller reset */
Index: linux-2.6/drivers/scsi/gdth_proc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth_proc.c	2005-09-11 18:12:04.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth_proc.c	2005-09-11 18:12:50.000000000 +0200
@@ -51,6 +51,7 @@
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          int hanum,int busnum)
 {
+    gdth_ha_str     *ha = HADATA(gdth_ctr_tab[hanum]);
     int             ret_val = -EINVAL;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request    *scp;
@@ -59,7 +60,7 @@
     Scsi_Cmnd       *scp;
     Scsi_Device     *sdev;
 #endif
-    TRACE2(("gdth_set_info() ha %d bus %d\n",hanum,busnum));
+    TRACE2(("gdth_set_info() ha %p bus %d\n",ha,busnum));
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     sdev = scsi_get_host_dev(host);
@@ -81,7 +82,7 @@
         if (strncmp(buffer,"gdth",4) == 0) {
             buffer += 5;
             length -= 5;
-            ret_val = gdth_set_asc_info( buffer, length, hanum, scp );
+            ret_val = gdth_set_asc_info(ha, buffer, length, scp);
         }
     }
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
@@ -95,14 +96,13 @@
 }
          
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Request *scp)
+static int gdth_set_asc_info(gdth_ha_str *ha, char *buffer, int length, Scsi_Request *scp)
 #else
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd *scp)
+static int gdth_set_asc_info(gdth_ha_str *ha, char *buffer, int length, Scsi_Cmnd *scp)
 #endif
 {
     int             orig_length, drive, wb_mode;
     int             i, found;
-    gdth_ha_str     *ha;
     gdth_cmd_str    gdtcmd;
     gdth_cpar_str   *pcpar;
     ulong64         paddr;
@@ -111,8 +111,7 @@
     memset(cmnd, 0xff, 12);
     memset(&gdtcmd, 0, sizeof(gdth_cmd_str));
 
-    TRACE2(("gdth_set_asc_info() ha %d\n",hanum));
-    ha = HADATA(gdth_ctr_tab[hanum]);
+    TRACE2(("gdth_set_asc_info() ha %p\n",ha));
     orig_length = length + 5;
     drive = -1;
     wb_mode = 0;
@@ -191,7 +190,7 @@
     }
 
     if (wb_mode) {
-        if (!gdth_ioctl_alloc(hanum, sizeof(gdth_cpar_str), TRUE, &paddr))
+        if (!gdth_ioctl_alloc(ha, sizeof(gdth_cpar_str), TRUE, &paddr))
             return(-EBUSY);
         pcpar = (gdth_cpar_str *)ha->pscratch;
         memcpy( pcpar, &ha->cpar, sizeof(gdth_cpar_str) );
@@ -207,7 +206,7 @@
 #else
         gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
 #endif
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, ha->pscratch, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, ha->pscratch, paddr);
         printk("Done.\n");
         return(orig_length);
     }
@@ -366,7 +365,7 @@
         len += size;  pos = begin + len;
         flag = FALSE;
             
-        buf = gdth_ioctl_alloc(hanum, GDTH_SCRATCH, FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < ha->bus_cnt; ++i) {
@@ -488,7 +487,7 @@
                     goto stop_output;
             }
         }
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, buf, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
 
         if (!flag) {
             size = sprintf(buffer+len, "\n --\n");
@@ -500,7 +499,7 @@
         len += size;  pos = begin + len;
         flag = FALSE;
 
-        buf = gdth_ioctl_alloc(hanum, GDTH_SCRATCH, FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < MAX_LDRIVES; ++i) {
@@ -602,7 +601,7 @@
             if (pos > offset + length)
                 goto stop_output;
         }       
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, buf, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
         
         if (!flag) {
             size = sprintf(buffer+len, "\n --\n");
@@ -614,7 +613,7 @@
         len += size;  pos = begin + len;
         flag = FALSE;
 
-        buf = gdth_ioctl_alloc(hanum, GDTH_SCRATCH, FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < MAX_LDRIVES; ++i) {
@@ -680,7 +679,7 @@
                     goto stop_output;
             }
         }
-        gdth_ioctl_free(hanum, GDTH_SCRATCH, buf, paddr);
+        gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
         
         if (!flag) {
             size = sprintf(buffer+len, "\n --\n");
@@ -692,7 +691,7 @@
         len += size;  pos = begin + len;
         flag = FALSE;
 
-        buf = gdth_ioctl_alloc(hanum, sizeof(gdth_hget_str), FALSE, &paddr);
+        buf = gdth_ioctl_alloc(ha, sizeof(gdth_hget_str), FALSE, &paddr);
         if (!buf) 
             goto stop_output;
         for (i = 0; i < MAX_LDRIVES; ++i) {
@@ -732,7 +731,7 @@
                 }
             }
         }
-        gdth_ioctl_free(hanum, sizeof(gdth_hget_str), buf, paddr);
+        gdth_ioctl_free(ha, sizeof(gdth_hget_str), buf, paddr);
 
         for (i = 0; i < MAX_HDRIVES; ++i) {
             if (!(ha->hdr[i].present))
@@ -870,17 +869,15 @@
 #endif
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
@@ -900,12 +897,10 @@
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
@@ -918,13 +913,11 @@
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
@@ -937,15 +930,13 @@
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
@@ -965,14 +956,12 @@
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
@@ -980,20 +969,18 @@
         t = scp->device->id;
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
-            scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
+            scp->SCp.buffers_residual = gdth_update_timeout(scp, 0);
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
@@ -1001,13 +988,13 @@
         t = scp->device->id;
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_start_timeout(): update_timeout()\n"));
-            gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
+            gdth_update_timeout(scp, scp->SCp.buffers_residual);
         }
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
-static int gdth_update_timeout(int hanum, Scsi_Cmnd *scp, int timeout)
+static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout)
 {
     int oldto;
 
Index: linux-2.6/drivers/scsi/gdth_proc.h
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth_proc.h	2005-09-11 18:12:04.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth_proc.h	2005-09-11 18:12:24.000000000 +0200
@@ -13,20 +13,20 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static void gdth_do_req(Scsi_Request *srp, gdth_cmd_str *cmd, 
                         char *cmnd, int timeout);
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Request *scp);
+static int gdth_set_asc_info(gdth_ha_str *ha, char *buffer,int length,Scsi_Request *scp);
 #else
 static void gdth_do_cmd(Scsi_Cmnd *scp, gdth_cmd_str *cmd, 
                         char *cmnd, int timeout);
-static int gdth_set_asc_info(char *buffer,int length,int hanum,Scsi_Cmnd *scp);
+static int gdth_set_asc_info(gdth_ha_str *ha, char *buffer,int length,Scsi_Cmnd *scp);
 #endif
 
-static char *gdth_ioctl_alloc(int hanum, int size, int scratch,
+static char *gdth_ioctl_alloc(gdth_ha_str *ha, int size, int scratch,
                               ulong64 *paddr);  
-static void gdth_ioctl_free(int hanum, int size, char *buf, ulong64 paddr);
-static void gdth_wait_completion(int hanum, int busnum, int id);
-static void gdth_stop_timeout(int hanum, int busnum, int id);
-static void gdth_start_timeout(int hanum, int busnum, int id);
-static int gdth_update_timeout(int hanum, Scsi_Cmnd *scp, int timeout);
+static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr);
+static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id);
+static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id);
+static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id);
+static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout);
 
 void gdth_scsi_done(Scsi_Cmnd *scp);
 
Index: linux-2.6/drivers/scsi/gdth.h
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.h	2005-09-11 18:12:04.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.h	2005-09-11 18:12:24.000000000 +0200
@@ -922,6 +922,7 @@
         Scsi_Cmnd       *cmnd;                  /* pending request */
         ushort          service;                /* service */
     } cmd_tab[GDTH_MAXCMDS];                    /* table of pend. requests */
+    unsigned int	ha_num;			/* HA index */
     unchar              bus_cnt;                /* SCSI bus count */
     unchar              tid_cnt;                /* Target ID count */
     unchar              bus_id[MAXBUS];         /* IOP IDs */
