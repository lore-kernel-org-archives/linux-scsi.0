From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/1] [SCSI] gdth: misc cleanups, preparation for ISA/EISA hotplug API
Date: Sat, 23 Feb 2008 23:44:44 -0500 (EST)
Message-ID: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760590AbYBXEpG@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Several misc. cleanups:

- remove recently-noop'd 'reverse_scan' module parm

- remove pointless function prototypes

- remove ha->pccb, its value always == &ha->cmdext

- move thrice-redundant DMA memory alloc and (in EISA's case, mapping)
  into common functions gdth_ha_alloc(), gdth_ha_free()

- delete pointless zero-initializations of ha struct members, as these
  are zeroed when ha is allocated (and never assigned any other value,
  prior to the explicit zero initializations)

- consolidate thrice-repeated spinlock init

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
NOTE: Applies on top of my previous two gdth patches (PCI hotplug prep,
PCI hotplug convert).

 drivers/scsi/gdth.c |  299 ++++++++++++++++++--------------------------------
 drivers/scsi/gdth.h |    1 -
 2 files changed, 108 insertions(+), 192 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index ad9aff2..b17eb15 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -51,8 +51,6 @@
  * reserve_list:h,b,t,l,h,b,t,l,...     reserve particular drive(s) with 
  *                              h- controller no., b- channel no., 
  *                              t- target ID, l- LUN
- * reverse_scan:Y               reverse scan order for PCI controllers         
- * reverse_scan:N               scan PCI controllers like BIOS
  * max_ids:x                    x - target ID count per channel (1..MAXID)
  * rescan:Y                     rescan all channels/IDs 
  * rescan:N                     use all devices found until now
@@ -66,7 +64,7 @@
  * force_dma32:Y                use only 32 bit DMA mode
  * force_dma32:N                use 64 bit DMA mode, if supported
  *
- * The default values are: "gdth=disable:N,reserve_mode:1,reverse_scan:N,
+ * The default values are: "gdth=disable:N,reserve_mode:1,
  *                          max_ids:127,rescan:N,hdr_channel:0,
  *                          shared_access:Y,probe_eisa_isa:N,force_dma32:N".
  * Here is another example: "gdth=reserve_list:0,1,2,0,0,1,3,0,rescan:Y".
@@ -77,7 +75,7 @@
  * with ' ' and all ':' with '=' and you must use 
  * '1' in place of 'Y' and '0' in place of 'N'.
  * 
- * Default: "modprobe gdth disable=0 reserve_mode=1 reverse_scan=0
+ * Default: "modprobe gdth disable=0 reserve_mode=1
  *           max_ids=127 rescan=0 hdr_channel=0 shared_access=0
  *           probe_eisa_isa=0 force_dma32=0"
  * The other example: "modprobe gdth reserve_list=0,1,2,0,0,1,3,0 rescan=1".
@@ -148,29 +146,13 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
 static int gdth_async_event(gdth_ha_str *ha);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
 
-static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority);
-static void gdth_next(gdth_ha_str *ha);
 static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b);
 static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
-static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, ushort source,
-                                      ushort idx, gdth_evt_data *evt);
 static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr);
-static void gdth_readapp_event(gdth_ha_str *ha, unchar application, 
-                               gdth_evt_str *estr);
-static void gdth_clear_events(void);
 
-static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer, ushort count, int to_buffer);
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
-static void gdth_enable_int(gdth_ha_str *ha);
-static int gdth_test_busy(gdth_ha_str *ha);
-static int gdth_get_cmd_index(gdth_ha_str *ha);
-static void gdth_release_event(gdth_ha_str *ha);
-static int gdth_wait(gdth_ha_str *ha, int index,ulong32 time);
-static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
-                                             ulong32 p1, ulong64 p2,ulong64 p3);
 static int gdth_search_drives(gdth_ha_str *ha);
 static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive);
 
@@ -181,7 +163,6 @@ static int gdth_close(struct inode *inode, struct file *filep);
 static int gdth_ioctl(struct inode *inode, struct file *filep,
                       unsigned int cmd, unsigned long arg);
 
-static void gdth_flush(gdth_ha_str *ha);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
@@ -336,8 +317,6 @@ static int reserve_list[MAX_RES_ARGS] =
 {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
  0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
  0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
-/* scan order for PCI controllers */
-static int reverse_scan = 0;
 /* virtual channel for the host drives */
 static int hdr_channel = 0;
 /* max. IDs per channel */
@@ -356,7 +335,6 @@ module_param_array(irq, int, NULL, 0);
 module_param(disable, int, 0);
 module_param(reserve_mode, int, 0);
 module_param_array(reserve_list, int, NULL, 0);
-module_param(reverse_scan, int, 0);
 module_param(hdr_channel, int, 0);
 module_param(max_ids, int, 0);
 module_param(rescan, int, 0);
@@ -1373,10 +1351,11 @@ static int gdth_get_cmd_index(gdth_ha_str *ha)
 
     for (i=0; i<GDTH_MAXCMDS; ++i) {
         if (ha->cmd_tab[i].cmnd == UNUSED_CMND) {
-            ha->cmd_tab[i].cmnd = ha->pccb->RequestBuffer;
-            ha->cmd_tab[i].service = ha->pccb->Service;
-            ha->pccb->CommandIndex = (ulong32)i+2;
-            return (i+2);
+	    ha->cmd_tab[i].cmnd = ha->cmdext.RequestBuffer;
+	    ha->cmd_tab[i].service = ha->cmdext.Service;
+	    ha->cmdext.CommandIndex = (ulong32) i + 2;
+
+	    return (i + 2);
         }
     }
     return 0;
@@ -1415,7 +1394,7 @@ static void gdth_copy_command(gdth_ha_str *ha)
     cp_count = ha->cmd_len;
     dp_offset= ha->cmd_offs_dpmem;
     cmd_no   = ha->cmd_cnt;
-    cmd_ptr  = ha->pccb;
+    cmd_ptr  = &ha->cmdext;
 
     ++ha->cmd_cnt;                                                      
     if (ha->type == GDT_EISA)
@@ -1478,13 +1457,13 @@ static void gdth_release_event(gdth_ha_str *ha)
     }
 #endif
 
-    if (ha->pccb->OpCode == GDT_INIT)
-        ha->pccb->Service |= 0x80;
+    if (ha->cmdext.OpCode == GDT_INIT)
+	ha->cmdext.Service |= 0x80;
 
     if (ha->type == GDT_EISA) {
-        if (ha->pccb->OpCode == GDT_INIT)               /* store DMA buffer */
-            outl(ha->ccb_phys, ha->bmic + MAILBOXREG);
-        outb(ha->pccb->Service, ha->bmic + LDOORREG);
+	if (ha->cmdext.OpCode == GDT_INIT)               /* store DMA buffer */
+	    outl(ha->ccb_phys, ha->bmic + MAILBOXREG);
+        outb(ha->cmdext.Service, ha->bmic + LDOORREG);
     } else if (ha->type == GDT_ISA) {
         writeb(0, &((gdt2_dpram_str __iomem *)ha->brd)->io.event);
     } else if (ha->type == GDT_PCI) {
@@ -1530,7 +1509,7 @@ static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
 
     TRACE2(("gdth_internal_cmd() service %d opcode %d\n",service,opcode));
 
-    cmd_ptr = ha->pccb;
+    cmd_ptr = &ha->cmdext;
     memset((char*)cmd_ptr,0,sizeof(gdth_cmd_str));
 
     /* make command  */
@@ -2493,7 +2472,7 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
     ulong64 no, blockno;
     int i, cmd_index, read_write, sgcnt, mode64;
 
-    cmdp = ha->pccb;
+    cmdp = &ha->cmdext;
     TRACE(("gdth_fill_cache_cmd() cmd 0x%x cmdsize %d hdrive %d\n",
                  scp->cmnd[0],scp->cmd_len,hdrive));
 
@@ -2673,7 +2652,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
 
     t = scp->device->id;
     l = scp->device->lun;
-    cmdp = ha->pccb;
+    cmdp = &ha->cmdext;
     TRACE(("gdth_fill_raw_cmd() cmd 0x%x bus %d ID %d LUN %d\n",
            scp->cmnd[0],b,t,l));
 
@@ -2838,7 +2817,7 @@ static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     register gdth_cmd_str *cmdp;
     int cmd_index;
 
-    cmdp= ha->pccb;
+    cmdp = &ha->cmdext;
     TRACE2(("gdth_special_cmd(): "));
 
     if (ha->type==GDT_EISA && ha->cmd_cnt>0) 
@@ -3292,7 +3271,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
     unchar b, t;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
 
-    cmdp = ha->pccb;
+    cmdp = &ha->cmdext;
     TRACE(("gdth_sync_event() serv %d status %d\n",
            service,ha->status));
 
@@ -3654,7 +3633,7 @@ static int gdth_async_event(gdth_ha_str *ha)
     gdth_cmd_str *cmdp;
     int cmd_index;
 
-    cmdp= ha->pccb;
+    cmdp = &ha->cmdext;
     TRACE2(("gdth_async_event() ha %d serv %d\n",
             ha->hanum, ha->service));
 
@@ -3833,8 +3812,6 @@ static void __init internal_setup(char *str,int *ints)
             disable = val;
         else if (!strncmp(argv, "reserve_mode:", 13))
             reserve_mode = val;
-        else if (!strncmp(argv, "reverse_scan:", 13))
-            reverse_scan = val;
         else if (!strncmp(argv, "hdr_channel:", 12))
             hdr_channel = val;
         else if (!strncmp(argv, "max_ids:", 8))
@@ -4718,12 +4695,78 @@ static struct scsi_host_template gdth_template = {
         .use_clustering         = ENABLE_CLUSTERING,
 };
 
+static void gdth_ha_free(gdth_ha_str *ha)
+{
+	if (ha->pscratch)
+		pci_free_consistent(ha->pdev, GDTH_SCRATCH,
+				    ha->pscratch, ha->scratch_phys);
+	if (ha->pmsg)
+		pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
+				    ha->pmsg, ha->msg_phys);
+
+#ifdef INT_COAL
+	if (ha->coal_stat)
+		pci_free_consistent(ha->pdev,
+				    sizeof(gdth_coal_status) * MAXOFFSETS,
+				    ha->coal_stat, ha->coal_stat_phys);
+#endif
+
+#ifdef CONFIG_EISA
+	if ((ha->type == GDT_EISA) && (ha->ccb_phys))
+		pci_unmap_single(ha->pdev, ha->ccb_phys, sizeof(gdth_cmd_str),
+				 PCI_DMA_BIDIRECTIONAL);
+#endif /* CONFIG_EISA */
+}
+
+static int gdth_ha_alloc(gdth_ha_str *ha)
+{
+	dma_addr_t scratch_dma_handle;
+	int rc = -ENOMEM;
+
+	spin_lock_init(&ha->smp_lock);
+
+	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
+						&scratch_dma_handle);
+	if (!ha->pscratch)
+		return rc;
+	ha->scratch_phys = scratch_dma_handle;
+
+	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str),
+						&scratch_dma_handle);
+	if (!ha->pmsg)
+		goto out_free;
+	ha->msg_phys = scratch_dma_handle;
+
+#ifdef INT_COAL
+	ha->coal_stat = pci_alloc_consistent(ha->pdev,
+				sizeof(gdth_coal_status) * MAXOFFSETS,
+				&scratch_dma_handle);
+	if (!ha->coal_stat)
+		goto out_free;
+	ha->coal_stat_phys = scratch_dma_handle;
+#endif
+
+#ifdef CONFIG_EISA
+	if (ha->type == GDT_EISA) {
+		ha->ccb_phys = pci_map_single(ha->pdev, &ha->cmdext,
+				sizeof(gdth_cmd_str), PCI_DMA_BIDIRECTIONAL);
+		if (!ha->ccb_phys)
+			goto out_free;
+	}
+#endif /* CONFIG_EISA */
+
+	return 0;
+
+out_free:
+	gdth_ha_free(ha);
+	return rc;
+}
+
 #ifdef CONFIG_ISA
 static int __init gdth_isa_probe_one(ulong32 isa_bios)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
-	dma_addr_t scratch_dma_handle = 0;
 	int error, i;
 
 	if (!gdth_search_isa(isa_bios))
@@ -4763,35 +4806,10 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	ha->hanum = gdth_ctr_count++;
 	ha->shost = shp;
 
-	ha->pccb = &ha->cmdext;
-	ha->ccb_phys = 0L;
-	ha->pdev = NULL;
-
-	error = -ENOMEM;
-
-	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
-						&scratch_dma_handle);
-	if (!ha->pscratch)
+	error = gdth_ha_alloc(ha);
+	if (error)
 		goto out_dec_counters;
-	ha->scratch_phys = scratch_dma_handle;
 
-	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str),
-						&scratch_dma_handle);
-	if (!ha->pmsg)
-		goto out_free_pscratch;
-	ha->msg_phys = scratch_dma_handle;
-
-#ifdef INT_COAL
-	ha->coal_stat = pci_alloc_consistent(ha->pdev,
-				sizeof(gdth_coal_status) * MAXOFFSETS,
-				&scratch_dma_handle);
-	if (!ha->coal_stat)
-		goto out_free_pmsg;
-	ha->coal_stat_phys = scratch_dma_handle;
-#endif
-
-	ha->scratch_busy = FALSE;
-	ha->req_first = NULL;
 	ha->tid_cnt = MAX_HDRIVES;
 	if (max_ids > 0 && max_ids < ha->tid_cnt)
 		ha->tid_cnt = max_ids;
@@ -4802,7 +4820,7 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	error = -ENODEV;
 	if (!gdth_search_drives(ha)) {
 		printk("GDT-ISA: Error during device scan\n");
-		goto out_free_coal_stat;
+		goto out_free_all;
 	}
 
 	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
@@ -4816,29 +4834,19 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = ha->bus_cnt;
 
-	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(ha);
 
 	error = scsi_add_host(shp, NULL);
 	if (error)
-		goto out_free_coal_stat;
+		goto out_free_all;
 	list_add_tail(&ha->list, &gdth_instances);
 
 	scsi_scan_host(shp);
 
 	return 0;
 
- out_free_coal_stat:
-#ifdef INT_COAL
-	pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) * MAXOFFSETS,
-				ha->coal_stat, ha->coal_stat_phys);
- out_free_pmsg:
-#endif
-	pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
-				ha->pmsg, ha->msg_phys);
- out_free_pscratch:
-	pci_free_consistent(ha->pdev, GDTH_SCRATCH,
-				ha->pscratch, ha->scratch_phys);
+ out_free_all:
+	gdth_ha_free(ha);
  out_dec_counters:
 	gdth_ctr_count--;
  out_free_irq:
@@ -4854,7 +4862,6 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
-	dma_addr_t scratch_dma_handle = 0;
 	int error, i;
 
 	if (!gdth_search_eisa(eisa_slot))
@@ -4888,40 +4895,10 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 
 	TRACE2(("EISA detect Bus 0: hanum %d\n", ha->hanum));
 
-	ha->pccb = &ha->cmdext;
-	ha->ccb_phys = 0L;
-
-	error = -ENOMEM;
-
-	ha->pdev = NULL;
-	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
-						&scratch_dma_handle);
-	if (!ha->pscratch)
+	error = gdth_ha_alloc(ha);
+	if (error)
 		goto out_free_irq;
-	ha->scratch_phys = scratch_dma_handle;
-
-	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str),
-						&scratch_dma_handle);
-	if (!ha->pmsg)
-		goto out_free_pscratch;
-	ha->msg_phys = scratch_dma_handle;
 
-#ifdef INT_COAL
-	ha->coal_stat = pci_alloc_consistent(ha->pdev,
-			sizeof(gdth_coal_status) * MAXOFFSETS,
-			&scratch_dma_handle);
-	if (!ha->coal_stat)
-		goto out_free_pmsg;
-	ha->coal_stat_phys = scratch_dma_handle;
-#endif
-
-	ha->ccb_phys = pci_map_single(ha->pdev,ha->pccb,
-			sizeof(gdth_cmd_str), PCI_DMA_BIDIRECTIONAL);
-	if (!ha->ccb_phys)
-		goto out_free_coal_stat;
-
-	ha->scratch_busy = FALSE;
-	ha->req_first = NULL;
 	ha->tid_cnt = MAX_HDRIVES;
 	if (max_ids > 0 && max_ids < ha->tid_cnt)
 		ha->tid_cnt = max_ids;
@@ -4932,7 +4909,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	if (!gdth_search_drives(ha)) {
 		printk("GDT-EISA: Error during device scan\n");
 		error = -ENODEV;
-		goto out_free_ccb_phys;
+		goto out_free_all;
 	}
 
 	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
@@ -4946,32 +4923,19 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = ha->bus_cnt;
 
-	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(ha);
 
 	error = scsi_add_host(shp, NULL);
 	if (error)
-		goto out_free_coal_stat;
+		goto out_free_all;
 	list_add_tail(&ha->list, &gdth_instances);
 
 	scsi_scan_host(shp);
 
 	return 0;
 
- out_free_ccb_phys:
-	pci_unmap_single(ha->pdev,ha->ccb_phys, sizeof(gdth_cmd_str),
-			PCI_DMA_BIDIRECTIONAL);
- out_free_coal_stat:
-#ifdef INT_COAL
-	pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) * MAXOFFSETS,
-				ha->coal_stat, ha->coal_stat_phys);
- out_free_pmsg:
-#endif
-	pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
-				ha->pmsg, ha->msg_phys);
- out_free_pscratch:
-	pci_free_consistent(ha->pdev, GDTH_SCRATCH,
-				ha->pscratch, ha->scratch_phys);
+ out_free_all:
+	gdth_ha_free(ha);
  out_free_irq:
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
@@ -4987,7 +4951,6 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
-	dma_addr_t scratch_dma_handle = 0;
 	int error, i;
 	struct pci_dev *pdev = pcistr->pdev;
 
@@ -5022,34 +4985,10 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 	ha->hanum = gdth_ctr_count++;
 	ha->shost = shp;
 
-	ha->pccb = &ha->cmdext;
-	ha->ccb_phys = 0L;
-
-	error = -ENOMEM;
-
-	ha->pscratch = pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
-						&scratch_dma_handle);
-	if (!ha->pscratch)
+	error = gdth_ha_alloc(ha);
+	if (error)
 		goto out_free_irq;
-	ha->scratch_phys = scratch_dma_handle;
-
-	ha->pmsg = pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str),
-					&scratch_dma_handle);
-	if (!ha->pmsg)
-		goto out_free_pscratch;
-	ha->msg_phys = scratch_dma_handle;
-
-#ifdef INT_COAL
-	ha->coal_stat = pci_alloc_consistent(ha->pdev,
-			sizeof(gdth_coal_status) * MAXOFFSETS,
-			&scratch_dma_handle);
-	if (!ha->coal_stat)
-		goto out_free_pmsg;
-	ha->coal_stat_phys = scratch_dma_handle;
-#endif
 
-	ha->scratch_busy = FALSE;
-	ha->req_first = NULL;
 	ha->tid_cnt = pdev->device >= 0x200 ? MAXID : MAX_HDRIVES;
 	if (max_ids > 0 && max_ids < ha->tid_cnt)
 		ha->tid_cnt = max_ids;
@@ -5060,7 +4999,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 	error = -ENODEV;
 	if (!gdth_search_drives(ha)) {
 		printk("GDT-PCI %d: Error during device scan\n", ha->hanum);
-		goto out_free_coal_stat;
+		goto out_free_all;
 	}
 
 	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
@@ -5073,7 +5012,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "GDT-PCI %d: "
 				"Unable to set 32-bit DMA\n", ha->hanum);
-				goto out_free_coal_stat;
+				goto out_free_all;
 		}
 	} else {
 		shp->max_cmd_len = 16;
@@ -5082,7 +5021,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 		} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "GDT-PCI %d: "
 				"Unable to set 64/32-bit DMA\n", ha->hanum);
-			goto out_free_coal_stat;
+			goto out_free_all;
 		}
 	}
 
@@ -5090,12 +5029,11 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = ha->bus_cnt;
 
-	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(ha);
 
 	error = scsi_add_host(shp, &pdev->dev);
 	if (error)
-		goto out_free_coal_stat;
+		goto out_free_all;
 	list_add_tail(&ha->list, &gdth_instances);
 
 	pci_set_drvdata(ha->pdev, ha);
@@ -5106,17 +5044,8 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 
 	return 0;
 
- out_free_coal_stat:
-#ifdef INT_COAL
-	pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) * MAXOFFSETS,
-				ha->coal_stat, ha->coal_stat_phys);
- out_free_pmsg:
-#endif
-	pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
-				ha->pmsg, ha->msg_phys);
- out_free_pscratch:
-	pci_free_consistent(ha->pdev, GDTH_SCRATCH,
-				ha->pscratch, ha->scratch_phys);
+ out_free_all:
+	gdth_ha_free(ha);
  out_free_irq:
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
@@ -5148,20 +5077,8 @@ static void gdth_remove_one(gdth_ha_str *ha)
 	if (shp->dma_channel != 0xff)
 		free_dma(shp->dma_channel);
 #endif
-#ifdef INT_COAL
-	if (ha->coal_stat)
-		pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-			MAXOFFSETS, ha->coal_stat, ha->coal_stat_phys);
-#endif
-	if (ha->pscratch)
-		pci_free_consistent(ha->pdev, GDTH_SCRATCH,
-			ha->pscratch, ha->scratch_phys);
-	if (ha->pmsg)
-		pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
-			ha->pmsg, ha->msg_phys);
-	if (ha->ccb_phys)
-		pci_unmap_single(ha->pdev,ha->ccb_phys,
-			sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
+
+	gdth_ha_free(ha);
 
 	scsi_host_put(shp);
 }
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 8193f4b..4be6c53 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -859,7 +859,6 @@ typedef struct {
     ulong32             brd_phys;               /* slot number/BIOS address */
     gdt6c_plx_regs      *plx;                   /* PLX regs (new PCI contr.) */
     gdth_cmd_str        cmdext;
-    gdth_cmd_str        *pccb;                  /* address command structure */
     ulong32             ccb_phys;               /* phys. address */
 #ifdef INT_COAL
     gdth_coal_status    *coal_stat;             /* buffer for coalescing int.*/
-- 
1.5.3.8
