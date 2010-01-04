From: Dave Jones <davej@redhat.com>
Subject: Convert gdth driver to use regular kernel types.
Date: Mon, 4 Jan 2010 10:19:34 -0500
Message-ID: <20100104151933.GA21931@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab0ADPTh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jan 2010 10:19:37 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o04FJbHl004062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 10:19:37 -0500
Received: from gelk.kernelslacker.org (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o04FJZlH007003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 10:19:36 -0500
Received: from gelk.kernelslacker.org (localhost [127.0.0.1])
	by gelk.kernelslacker.org (8.14.3/8.14.3) with ESMTP id o04FJYXg022286
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 10:19:34 -0500
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.3/8.14.3/Submit) id o04FJYaf022284
	for linux-scsi@vger.kernel.org; Mon, 4 Jan 2010 10:19:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

converted using this script..

 perl -p -i -e 's|ulong32|u32|g' drivers/scsi/gdth*
 perl -p -i -e 's|ulong64|u64|g' drivers/scsi/gdth*
 perl -p -i -e 's|ushort|u16|g' drivers/scsi/gdth*
 perl -p -i -e 's|unchar|u8|g' drivers/scsi/gdth*
 perl -p -i -e 's|ulong|unsigned long|g' drivers/scsi/gdth*
 perl -p -i -e 's|PACKED|__attribute__((packed))|g' drivers/scsi/gdth*

sha1sum of the generated code was identical before and after.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 185e6bc..276f42f 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -140,40 +140,40 @@
 #include "gdth.h"
 
 static void gdth_delay(int milliseconds);
-static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
+static void gdth_eval_mapping(u32 size, u32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
 static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex);
-static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
+static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
                                                                Scsi_Cmnd *scp);
 static int gdth_async_event(gdth_ha_str *ha);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
 
-static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority);
+static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority);
 static void gdth_next(gdth_ha_str *ha);
-static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b);
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b);
 static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
-static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, ushort source,
-                                      ushort idx, gdth_evt_data *evt);
+static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, u16 source,
+                                      u16 idx, gdth_evt_data *evt);
 static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr);
-static void gdth_readapp_event(gdth_ha_str *ha, unchar application, 
+static void gdth_readapp_event(gdth_ha_str *ha, u8 application, 
                                gdth_evt_str *estr);
 static void gdth_clear_events(void);
 
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer, ushort count);
+                                    char *buffer, u16 count);
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
 static int gdth_test_busy(gdth_ha_str *ha);
 static int gdth_get_cmd_index(gdth_ha_str *ha);
 static void gdth_release_event(gdth_ha_str *ha);
-static int gdth_wait(gdth_ha_str *ha, int index,ulong32 time);
-static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
-                                             ulong32 p1, ulong64 p2,ulong64 p3);
+static int gdth_wait(gdth_ha_str *ha, int index,u32 time);
+static int gdth_internal_cmd(gdth_ha_str *ha, u8 service, u16 opcode,
+                                             u32 p1, u64 p2,u64 p3);
 static int gdth_search_drives(gdth_ha_str *ha);
-static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive);
+static int gdth_analyse_hdrive(gdth_ha_str *ha, u16 hdrive);
 
 static const char *gdth_ctr_name(gdth_ha_str *ha);
 
@@ -189,7 +189,7 @@ static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 static void gdth_scsi_done(struct scsi_cmnd *scp);
 
 #ifdef DEBUG_GDTH
-static unchar   DebugState = DEBUG_GDTH;
+static u8   DebugState = DEBUG_GDTH;
 
 #ifdef __SERIAL__
 #define MAX_SERBUF 160
@@ -270,30 +270,30 @@ static int ser_printk(const char *fmt, ...)
 #endif
 
 #ifdef GDTH_STATISTICS
-static ulong32 max_rq=0, max_index=0, max_sg=0;
+static u32 max_rq=0, max_index=0, max_sg=0;
 #ifdef INT_COAL
-static ulong32 max_int_coal=0;
+static u32 max_int_coal=0;
 #endif
-static ulong32 act_ints=0, act_ios=0, act_stats=0, act_rq=0;
+static u32 act_ints=0, act_ios=0, act_stats=0, act_rq=0;
 static struct timer_list gdth_timer;
 #endif
 
-#define PTR2USHORT(a)   (ushort)(ulong)(a)
+#define PTR2USHORT(a)   (u16)(unsigned long)(a)
 #define GDTOFFSOF(a,b)  (size_t)&(((a*)0)->b)
 #define INDEX_OK(i,t)   ((i)<ARRAY_SIZE(t))
 
 #define BUS_L2P(a,b)    ((b)>(a)->virt_bus ? (b-1):(b))
 
 #ifdef CONFIG_ISA
-static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
+static u8   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 #endif
 #if defined(CONFIG_EISA) || defined(CONFIG_ISA)
-static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
+static u8   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 #endif
-static unchar   gdth_polling;                           /* polling if TRUE */
+static u8   gdth_polling;                           /* polling if TRUE */
 static int      gdth_ctr_count  = 0;                    /* controller count */
 static LIST_HEAD(gdth_instances);                       /* controller list */
-static unchar   gdth_write_through = FALSE;             /* write through */
+static u8   gdth_write_through = FALSE;             /* write through */
 static gdth_evt_str ebuffer[MAX_EVENTS];                /* event buffer */
 static int elastidx;
 static int eoldidx;
@@ -303,7 +303,7 @@ static int major;
 #define DOU     2                               /* OUT data direction */
 #define DNO     DIN                             /* no data transfer */
 #define DUN     DIN                             /* unknown data direction */
-static unchar gdth_direction_tab[0x100] = {
+static u8 gdth_direction_tab[0x100] = {
     DNO,DNO,DIN,DIN,DOU,DIN,DIN,DOU,DIN,DUN,DOU,DOU,DUN,DUN,DUN,DIN,
     DNO,DIN,DIN,DOU,DIN,DOU,DNO,DNO,DOU,DNO,DIN,DNO,DIN,DOU,DNO,DUN,
     DIN,DUN,DIN,DUN,DOU,DIN,DUN,DUN,DIN,DIN,DOU,DNO,DUN,DIN,DOU,DOU,
@@ -390,7 +390,7 @@ static gdth_ha_str *gdth_find_ha(int hanum)
 static struct gdth_cmndinfo *gdth_get_cmndinfo(gdth_ha_str *ha)
 {
 	struct gdth_cmndinfo *priv = NULL;
-	ulong flags;
+	unsigned long flags;
 	int i;
 
 	spin_lock_irqsave(&ha->smp_lock, flags);
@@ -493,7 +493,7 @@ int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
     return rval;
 }
 
-static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs)
+static void gdth_eval_mapping(u32 size, u32 *cyls, int *heads, int *secs)
 {
     *cyls = size /HEADS/SECS;
     if (*cyls <= MAXCYLS) {
@@ -514,9 +514,9 @@ static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs
 
 /* controller search and initialization functions */
 #ifdef CONFIG_EISA
-static int __init gdth_search_eisa(ushort eisa_adr)
+static int __init gdth_search_eisa(u16 eisa_adr)
 {
-    ulong32 id;
+    u32 id;
     
     TRACE(("gdth_search_eisa() adr. %x\n",eisa_adr));
     id = inl(eisa_adr+ID0REG);
@@ -533,13 +533,13 @@ static int __init gdth_search_eisa(ushort eisa_adr)
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_ISA
-static int __init gdth_search_isa(ulong32 bios_adr)
+static int __init gdth_search_isa(u32 bios_adr)
 {
     void __iomem *addr;
-    ulong32 id;
+    u32 id;
 
     TRACE(("gdth_search_isa() bios adr. %x\n",bios_adr));
-    if ((addr = ioremap(bios_adr+BIOS_ID_OFFS, sizeof(ulong32))) != NULL) {
+    if ((addr = ioremap(bios_adr+BIOS_ID_OFFS, sizeof(u32))) != NULL) {
         id = readl(addr);
         iounmap(addr);
         if (id == GDT2_ID)                          /* GDT2000 */
@@ -551,7 +551,7 @@ static int __init gdth_search_isa(ulong32 bios_adr)
 
 #ifdef CONFIG_PCI
 
-static bool gdth_search_vortex(ushort device)
+static bool gdth_search_vortex(u16 device)
 {
 	if (device <= PCI_DEVICE_ID_VORTEX_GDT6555)
 		return true;
@@ -603,9 +603,9 @@ static void __devexit gdth_pci_remove_one(struct pci_dev *pdev)
 static int __devinit gdth_pci_init_one(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
-	ushort vendor = pdev->vendor;
-	ushort device = pdev->device;
-	ulong base0, base1, base2;
+	u16 vendor = pdev->vendor;
+	u16 device = pdev->device;
+	unsigned long base0, base1, base2;
 	int rc;
 	gdth_pci_str gdth_pcistr;
 	gdth_ha_str *ha = NULL;
@@ -658,10 +658,10 @@ static int __devinit gdth_pci_init_one(struct pci_dev *pdev,
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_EISA
-static int __init gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha)
+static int __init gdth_init_eisa(u16 eisa_adr,gdth_ha_str *ha)
 {
-    ulong32 retries,id;
-    unchar prot_ver,eisacf,i,irq_found;
+    u32 retries,id;
+    u8 prot_ver,eisacf,i,irq_found;
 
     TRACE(("gdth_init_eisa() adr. %x\n",eisa_adr));
     
@@ -688,7 +688,7 @@ static int __init gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha)
         return 0;
     }
     ha->bmic = eisa_adr;
-    ha->brd_phys = (ulong32)eisa_adr >> 12;
+    ha->brd_phys = (u32)eisa_adr >> 12;
 
     outl(0,eisa_adr+MAILBOXREG);
     outl(0,eisa_adr+MAILBOXREG+4);
@@ -752,12 +752,12 @@ static int __init gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha)
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_ISA
-static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
+static int __init gdth_init_isa(u32 bios_adr,gdth_ha_str *ha)
 {
     register gdt2_dpram_str __iomem *dp2_ptr;
     int i;
-    unchar irq_drq,prot_ver;
-    ulong32 retries;
+    u8 irq_drq,prot_ver;
+    u32 retries;
 
     TRACE(("gdth_init_isa() bios adr. %x\n",bios_adr));
 
@@ -812,7 +812,7 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
         }
         gdth_delay(1);
     }
-    prot_ver = (unchar)readl(&dp2_ptr->u.ic.S_Info[0]);
+    prot_ver = (u8)readl(&dp2_ptr->u.ic.S_Info[0]);
     writeb(0, &dp2_ptr->u.ic.Status);
     writeb(0xff, &dp2_ptr->io.irqdel);
     if (prot_ver != PROTOCOL_VERSION) {
@@ -859,9 +859,9 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
     register gdt6_dpram_str __iomem *dp6_ptr;
     register gdt6c_dpram_str __iomem *dp6c_ptr;
     register gdt6m_dpram_str __iomem *dp6m_ptr;
-    ulong32 retries;
-    unchar prot_ver;
-    ushort command;
+    u32 retries;
+    u8 prot_ver;
+    u16 command;
     int i, found = FALSE;
 
     TRACE(("gdth_init_pci()\n"));
@@ -871,7 +871,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
     else
         ha->oem_id = OEM_ID_ICP;
     ha->brd_phys = (pdev->bus->number << 8) | (pdev->devfn & 0xf8);
-    ha->stype = (ulong32)pdev->device;
+    ha->stype = (u32)pdev->device;
     ha->irq = pdev->irq;
     ha->pdev = pdev;
     
@@ -891,7 +891,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
             found = FALSE;
             for (i = 0xC8000; i < 0xE8000; i += 0x4000) {
                 iounmap(ha->brd);
-                ha->brd = ioremap(i, sizeof(ushort)); 
+                ha->brd = ioremap(i, sizeof(u16)); 
                 if (ha->brd == NULL) {
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
                     return 0;
@@ -947,7 +947,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)readl(&dp6_ptr->u.ic.S_Info[0]);
+        prot_ver = (u8)readl(&dp6_ptr->u.ic.S_Info[0]);
         writeb(0, &dp6_ptr->u.ic.S_Status);
         writeb(0xff, &dp6_ptr->io.irqdel);
         if (prot_ver != PROTOCOL_VERSION) {
@@ -1000,7 +1000,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
             found = FALSE;
             for (i = 0xC8000; i < 0xE8000; i += 0x4000) {
                 iounmap(ha->brd);
-                ha->brd = ioremap(i, sizeof(ushort)); 
+                ha->brd = ioremap(i, sizeof(u16)); 
                 if (ha->brd == NULL) {
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
                     return 0;
@@ -1059,7 +1059,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)readl(&dp6c_ptr->u.ic.S_Info[0]);
+        prot_ver = (u8)readl(&dp6c_ptr->u.ic.S_Info[0]);
         writeb(0, &dp6c_ptr->u.ic.Status);
         if (prot_ver != PROTOCOL_VERSION) {
             printk("GDT-PCI: Illegal protocol version\n");
@@ -1128,7 +1128,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
             found = FALSE;
             for (i = 0xC8000; i < 0xE8000; i += 0x4000) {
                 iounmap(ha->brd);
-                ha->brd = ioremap(i, sizeof(ushort)); 
+                ha->brd = ioremap(i, sizeof(u16)); 
                 if (ha->brd == NULL) {
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
                     return 0;
@@ -1180,7 +1180,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)readl(&dp6m_ptr->u.ic.S_Info[0]);
+        prot_ver = (u8)readl(&dp6m_ptr->u.ic.S_Info[0]);
         writeb(0, &dp6m_ptr->u.ic.S_Status);
         if (prot_ver != PROTOCOL_VERSION) {
             printk("GDT-PCI: Illegal protocol version\n");
@@ -1223,7 +1223,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)(readl(&dp6m_ptr->u.ic.S_Info[0]) >> 16);
+        prot_ver = (u8)(readl(&dp6m_ptr->u.ic.S_Info[0]) >> 16);
         writeb(0, &dp6m_ptr->u.ic.S_Status);
         if (prot_ver < 0x2b)      /* FW < x.43: no 64-bit DMA support */
             ha->dma64_support = 0;
@@ -1239,7 +1239,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
 
 static void __devinit gdth_enable_int(gdth_ha_str *ha)
 {
-    ulong flags;
+    unsigned long flags;
     gdt2_dpram_str __iomem *dp2_ptr;
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt6m_dpram_str __iomem *dp6m_ptr;
@@ -1274,14 +1274,14 @@ static void __devinit gdth_enable_int(gdth_ha_str *ha)
 }
 
 /* return IStatus if interrupt was from this card else 0 */
-static unchar gdth_get_status(gdth_ha_str *ha)
+static u8 gdth_get_status(gdth_ha_str *ha)
 {
-    unchar IStatus = 0;
+    u8 IStatus = 0;
 
     TRACE(("gdth_get_status() irq %d ctr_count %d\n", ha->irq, gdth_ctr_count));
 
         if (ha->type == GDT_EISA)
-            IStatus = inb((ushort)ha->bmic + EDOORREG);
+            IStatus = inb((u16)ha->bmic + EDOORREG);
         else if (ha->type == GDT_ISA)
             IStatus =
                 readb(&((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Cmd_Index);
@@ -1329,7 +1329,7 @@ static int gdth_get_cmd_index(gdth_ha_str *ha)
         if (ha->cmd_tab[i].cmnd == UNUSED_CMND) {
             ha->cmd_tab[i].cmnd = ha->pccb->RequestBuffer;
             ha->cmd_tab[i].service = ha->pccb->Service;
-            ha->pccb->CommandIndex = (ulong32)i+2;
+            ha->pccb->CommandIndex = (u32)i+2;
             return (i+2);
         }
     }
@@ -1362,7 +1362,7 @@ static void gdth_copy_command(gdth_ha_str *ha)
     register gdt6c_dpram_str __iomem *dp6c_ptr;
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt2_dpram_str __iomem *dp2_ptr;
-    ushort cp_count,dp_offset,cmd_no;
+    u16 cp_count,dp_offset,cmd_no;
     
     TRACE(("gdth_copy_command() hanum %d\n", ha->hanum));
 
@@ -1386,28 +1386,28 @@ static void gdth_copy_command(gdth_ha_str *ha)
         dp2_ptr = ha->brd;
         writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp2_ptr->u.ic.comm_queue[cmd_no].offset);
-        writew((ushort)cmd_ptr->Service,
+        writew((u16)cmd_ptr->Service,
                     &dp2_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp2_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     } else if (ha->type == GDT_PCI) {
         dp6_ptr = ha->brd;
         writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp6_ptr->u.ic.comm_queue[cmd_no].offset);
-        writew((ushort)cmd_ptr->Service,
+        writew((u16)cmd_ptr->Service,
                     &dp6_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp6_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     } else if (ha->type == GDT_PCINEW) {
         dp6c_ptr = ha->brd;
         writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp6c_ptr->u.ic.comm_queue[cmd_no].offset);
-        writew((ushort)cmd_ptr->Service,
+        writew((u16)cmd_ptr->Service,
                     &dp6c_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp6c_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     } else if (ha->type == GDT_PCIMPR) {
         dp6m_ptr = ha->brd;
         writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp6m_ptr->u.ic.comm_queue[cmd_no].offset);
-        writew((ushort)cmd_ptr->Service,
+        writew((u16)cmd_ptr->Service,
                     &dp6m_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp6m_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     }
@@ -1420,14 +1420,14 @@ static void gdth_release_event(gdth_ha_str *ha)
 
 #ifdef GDTH_STATISTICS
     {
-        ulong32 i,j;
+        u32 i,j;
         for (i=0,j=0; j<GDTH_MAXCMDS; ++j) {
             if (ha->cmd_tab[j].cmnd != UNUSED_CMND)
                 ++i;
         }
         if (max_index < i) {
             max_index = i;
-            TRACE3(("GDT: max_index = %d\n",(ushort)i));
+            TRACE3(("GDT: max_index = %d\n",(u16)i));
         }
     }
 #endif
@@ -1450,7 +1450,7 @@ static void gdth_release_event(gdth_ha_str *ha)
     }
 }
 
-static int gdth_wait(gdth_ha_str *ha, int index, ulong32 time)
+static int gdth_wait(gdth_ha_str *ha, int index, u32 time)
 {
     int answer_found = FALSE;
     int wait_index = 0;
@@ -1476,8 +1476,8 @@ static int gdth_wait(gdth_ha_str *ha, int index, ulong32 time)
 }
 
 
-static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
-                                            ulong32 p1, ulong64 p2, ulong64 p3)
+static int gdth_internal_cmd(gdth_ha_str *ha, u8 service, u16 opcode,
+                                            u32 p1, u64 p2, u64 p3)
 {
     register gdth_cmd_str *cmd_ptr;
     int retries,index;
@@ -1501,35 +1501,35 @@ static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
         if (service == CACHESERVICE) {
             if (opcode == GDT_IOCTL) {
                 cmd_ptr->u.ioctl.subfunc = p1;
-                cmd_ptr->u.ioctl.channel = (ulong32)p2;
-                cmd_ptr->u.ioctl.param_size = (ushort)p3;
+                cmd_ptr->u.ioctl.channel = (u32)p2;
+                cmd_ptr->u.ioctl.param_size = (u16)p3;
                 cmd_ptr->u.ioctl.p_param = ha->scratch_phys;
             } else {
                 if (ha->cache_feat & GDT_64BIT) {
-                    cmd_ptr->u.cache64.DeviceNo = (ushort)p1;
+                    cmd_ptr->u.cache64.DeviceNo = (u16)p1;
                     cmd_ptr->u.cache64.BlockNo  = p2;
                 } else {
-                    cmd_ptr->u.cache.DeviceNo = (ushort)p1;
-                    cmd_ptr->u.cache.BlockNo  = (ulong32)p2;
+                    cmd_ptr->u.cache.DeviceNo = (u16)p1;
+                    cmd_ptr->u.cache.BlockNo  = (u32)p2;
                 }
             }
         } else if (service == SCSIRAWSERVICE) {
             if (ha->raw_feat & GDT_64BIT) {
                 cmd_ptr->u.raw64.direction  = p1;
-                cmd_ptr->u.raw64.bus        = (unchar)p2;
-                cmd_ptr->u.raw64.target     = (unchar)p3;
-                cmd_ptr->u.raw64.lun        = (unchar)(p3 >> 8);
+                cmd_ptr->u.raw64.bus        = (u8)p2;
+                cmd_ptr->u.raw64.target     = (u8)p3;
+                cmd_ptr->u.raw64.lun        = (u8)(p3 >> 8);
             } else {
                 cmd_ptr->u.raw.direction  = p1;
-                cmd_ptr->u.raw.bus        = (unchar)p2;
-                cmd_ptr->u.raw.target     = (unchar)p3;
-                cmd_ptr->u.raw.lun        = (unchar)(p3 >> 8);
+                cmd_ptr->u.raw.bus        = (u8)p2;
+                cmd_ptr->u.raw.target     = (u8)p3;
+                cmd_ptr->u.raw.lun        = (u8)(p3 >> 8);
             }
         } else if (service == SCREENSERVICE) {
             if (opcode == GDT_REALTIME) {
-                *(ulong32 *)&cmd_ptr->u.screen.su.data[0] = p1;
-                *(ulong32 *)&cmd_ptr->u.screen.su.data[4] = (ulong32)p2;
-                *(ulong32 *)&cmd_ptr->u.screen.su.data[8] = (ulong32)p3;
+                *(u32 *)&cmd_ptr->u.screen.su.data[0] = p1;
+                *(u32 *)&cmd_ptr->u.screen.su.data[4] = (u32)p2;
+                *(u32 *)&cmd_ptr->u.screen.su.data[8] = (u32)p3;
             }
         }
         ha->cmd_len          = sizeof(gdth_cmd_str);
@@ -1555,9 +1555,9 @@ static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
 
 static int __devinit gdth_search_drives(gdth_ha_str *ha)
 {
-    ushort cdev_cnt, i;
+    u16 cdev_cnt, i;
     int ok;
-    ulong32 bus_no, drv_cnt, drv_no, j;
+    u32 bus_no, drv_cnt, drv_no, j;
     gdth_getch_str *chn;
     gdth_drlist_str *drl;
     gdth_iochan_str *ioc;
@@ -1570,8 +1570,8 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
 #endif
 
 #ifdef GDTH_RTC
-    unchar rtc[12];
-    ulong flags;
+    u8 rtc[12];
+    unsigned long flags;
 #endif     
    
     TRACE(("gdth_search_drives() hanum %d\n", ha->hanum));
@@ -1584,7 +1584,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
         if (ok)
             ha->screen_feat = GDT_64BIT;
     }
-    if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
+    if (force_dma32 || (!ok && ha->status == (u16)S_NOFUNC))
         ok = gdth_internal_cmd(ha, SCREENSERVICE, GDT_INIT, 0, 0, 0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error screen service (code %d)\n",
@@ -1609,11 +1609,11 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
             rtc[j] = CMOS_READ(j);
     } while (rtc[0] != CMOS_READ(0));
     spin_unlock_irqrestore(&rtc_lock, flags);
-    TRACE2(("gdth_search_drives(): RTC: %x/%x/%x\n",*(ulong32 *)&rtc[0],
-            *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]));
+    TRACE2(("gdth_search_drives(): RTC: %x/%x/%x\n",*(u32 *)&rtc[0],
+            *(u32 *)&rtc[4], *(u32 *)&rtc[8]));
     /* 3. send to controller firmware */
-    gdth_internal_cmd(ha, SCREENSERVICE, GDT_REALTIME, *(ulong32 *)&rtc[0],
-                      *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]);
+    gdth_internal_cmd(ha, SCREENSERVICE, GDT_REALTIME, *(u32 *)&rtc[0],
+                      *(u32 *)&rtc[4], *(u32 *)&rtc[8]);
 #endif  
  
     /* unfreeze all IOs */
@@ -1627,7 +1627,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
         if (ok)
             ha->cache_feat = GDT_64BIT;
     }
-    if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
+    if (force_dma32 || (!ok && ha->status == (u16)S_NOFUNC))
         ok = gdth_internal_cmd(ha, CACHESERVICE, GDT_INIT, LINUX_OS, 0, 0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error cache service (code %d)\n",
@@ -1635,7 +1635,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
         return 0;
     }
     TRACE2(("gdth_search_drives(): CACHESERVICE initialized\n"));
-    cdev_cnt = (ushort)ha->info;
+    cdev_cnt = (u16)ha->info;
     ha->fw_vers = ha->service;
 
 #ifdef INT_COAL
@@ -1644,7 +1644,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
         pmod = (gdth_perf_modes *)ha->pscratch;
         pmod->version          = 1;
         pmod->st_mode          = 1;    /* enable one status buffer */
-        *((ulong64 *)&pmod->st_buff_addr1) = ha->coal_stat_phys;
+        *((u64 *)&pmod->st_buff_addr1) = ha->coal_stat_phys;
         pmod->st_buff_indx1    = COALINDEX;
         pmod->st_buff_addr2    = 0;
         pmod->st_buff_u_addr2  = 0;
@@ -1705,7 +1705,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
             else
                 ha->bus_id[bus_no] = 0xff;
         }       
-        ha->bus_cnt = (unchar)bus_no;
+        ha->bus_cnt = (u8)bus_no;
     }
     TRACE2(("gdth_search_drives() %d channels\n",ha->bus_cnt));
 
@@ -1789,12 +1789,12 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
 
         /* logical drives */
         if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, CACHE_DRV_CNT,
-                              INVALID_CHANNEL,sizeof(ulong32))) {
-            drv_cnt = *(ulong32 *)ha->pscratch;
+                              INVALID_CHANNEL,sizeof(u32))) {
+            drv_cnt = *(u32 *)ha->pscratch;
             if (gdth_internal_cmd(ha, CACHESERVICE, GDT_IOCTL, CACHE_DRV_LIST,
-                                  INVALID_CHANNEL,drv_cnt * sizeof(ulong32))) {
+                                  INVALID_CHANNEL,drv_cnt * sizeof(u32))) {
                 for (j = 0; j < drv_cnt; ++j) {
-                    drv_no = ((ulong32 *)ha->pscratch)[j];
+                    drv_no = ((u32 *)ha->pscratch)[j];
                     if (drv_no < MAX_LDRIVES) {
                         ha->hdr[drv_no].is_logdrv = TRUE;
                         TRACE2(("Drive %d is log. drive\n",drv_no));
@@ -1838,7 +1838,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
         if (ok)
             ha->raw_feat = GDT_64BIT;
     }
-    if (force_dma32 || (!ok && ha->status == (ushort)S_NOFUNC))
+    if (force_dma32 || (!ok && ha->status == (u16)S_NOFUNC))
         ok = gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_INIT, 0, 0, 0);
     if (!ok) {
         printk("GDT-HA %d: Initialization error raw service (code %d)\n",
@@ -1854,7 +1854,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
         if (gdth_internal_cmd(ha, SCSIRAWSERVICE, GDT_GET_FEAT, 0, 0, 0)) {
             TRACE2(("gdth_search_dr(): get feat RAWSERVICE %d\n",
                     ha->info));
-            ha->raw_feat |= (ushort)ha->info;
+            ha->raw_feat |= (u16)ha->info;
         }
     } 
 
@@ -1865,7 +1865,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
         if (gdth_internal_cmd(ha, CACHESERVICE, GDT_GET_FEAT, 0, 0, 0)) {
             TRACE2(("gdth_search_dr(): get feat CACHESERV. %d\n",
                     ha->info));
-            ha->cache_feat |= (ushort)ha->info;
+            ha->cache_feat |= (u16)ha->info;
         }
     }
 
@@ -1923,9 +1923,9 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
     return 1;
 }
 
-static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
+static int gdth_analyse_hdrive(gdth_ha_str *ha, u16 hdrive)
 {
-    ulong32 drv_cyls;
+    u32 drv_cyls;
     int drv_hds, drv_secs;
 
     TRACE(("gdth_analyse_hdrive() hanum %d drive %d\n", ha->hanum, hdrive));
@@ -1944,17 +1944,17 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
     } else {
         drv_hds = ha->info2 & 0xff;
         drv_secs = (ha->info2 >> 8) & 0xff;
-        drv_cyls = (ulong32)ha->hdr[hdrive].size / drv_hds / drv_secs;
+        drv_cyls = (u32)ha->hdr[hdrive].size / drv_hds / drv_secs;
     }
-    ha->hdr[hdrive].heads = (unchar)drv_hds;
-    ha->hdr[hdrive].secs  = (unchar)drv_secs;
+    ha->hdr[hdrive].heads = (u8)drv_hds;
+    ha->hdr[hdrive].secs  = (u8)drv_secs;
     /* round size */
     ha->hdr[hdrive].size  = drv_cyls * drv_hds * drv_secs;
     
     if (ha->cache_feat & GDT_64BIT) {
         if (gdth_internal_cmd(ha, CACHESERVICE, GDT_X_INFO, hdrive, 0, 0)
             && ha->info2 != 0) {
-            ha->hdr[hdrive].size = ((ulong64)ha->info2 << 32) | ha->info;
+            ha->hdr[hdrive].size = ((u64)ha->info2 << 32) | ha->info;
         }
     }
     TRACE2(("gdth_search_dr() cdr. %d size %d hds %d scs %d\n",
@@ -1964,7 +1964,7 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
     if (gdth_internal_cmd(ha, CACHESERVICE, GDT_DEVTYPE, hdrive, 0, 0)) {
         TRACE2(("gdth_search_dr() cache drive %d devtype %d\n",
                 hdrive,ha->info));
-        ha->hdr[hdrive].devtype = (ushort)ha->info;
+        ha->hdr[hdrive].devtype = (u16)ha->info;
     }
 
     /* cluster info */
@@ -1972,14 +1972,14 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
         TRACE2(("gdth_search_dr() cache drive %d cluster info %d\n",
                 hdrive,ha->info));
         if (!shared_access)
-            ha->hdr[hdrive].cluster_type = (unchar)ha->info;
+            ha->hdr[hdrive].cluster_type = (u8)ha->info;
     }
 
     /* R/W attributes */
     if (gdth_internal_cmd(ha, CACHESERVICE, GDT_RW_ATTRIBS, hdrive, 0, 0)) {
         TRACE2(("gdth_search_dr() cache drive %d r/w attrib. %d\n",
                 hdrive,ha->info));
-        ha->hdr[hdrive].rw_attribs = (unchar)ha->info;
+        ha->hdr[hdrive].rw_attribs = (u8)ha->info;
     }
 
     return 1;
@@ -1988,12 +1988,12 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
 
 /* command queueing/sending functions */
 
-static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
+static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
 {
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
-    ulong flags;
+    unsigned long flags;
 
     TRACE(("gdth_putq() priority %d\n",priority));
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -2023,7 +2023,7 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
         ++flags;
     if (max_rq < flags) {
         max_rq = flags;
-        TRACE3(("GDT: max_rq = %d\n",(ushort)max_rq));
+        TRACE3(("GDT: max_rq = %d\n",(u16)max_rq));
     }
 #endif
 }
@@ -2032,9 +2032,9 @@ static void gdth_next(gdth_ha_str *ha)
 {
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
-    unchar b, t, l, firsttime;
-    unchar this_cmd, next_cmd;
-    ulong flags = 0;
+    u8 b, t, l, firsttime;
+    u8 this_cmd, next_cmd;
+    unsigned long flags = 0;
     int cmd_index;
 
     TRACE(("gdth_next() hanum %d\n", ha->hanum));
@@ -2282,20 +2282,20 @@ static void gdth_next(gdth_ha_str *ha)
  * buffers, kmap_atomic() as needed.
  */
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer, ushort count)
+                                    char *buffer, u16 count)
 {
-    ushort cpcount,i, max_sg = scsi_sg_count(scp);
-    ushort cpsum,cpnow;
+    u16 cpcount,i, max_sg = scsi_sg_count(scp);
+    u16 cpsum,cpnow;
     struct scatterlist *sl;
     char *address;
 
-    cpcount = min_t(ushort, count, scsi_bufflen(scp));
+    cpcount = min_t(u16, count, scsi_bufflen(scp));
 
     if (cpcount) {
         cpsum=0;
         scsi_for_each_sg(scp, sl, max_sg, i) {
             unsigned long flags;
-            cpnow = (ushort)sl->length;
+            cpnow = (u16)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
                           cpnow, cpsum, cpcount, scsi_bufflen(scp)));
             if (cpsum+cpnow > cpcount) 
@@ -2325,7 +2325,7 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
 
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 {
-    unchar t;
+    u8 t;
     gdth_inq_data inq;
     gdth_rdcap_data rdc;
     gdth_sense_data sd;
@@ -2389,7 +2389,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 
       case READ_CAPACITY:
         TRACE2(("Read capacity hdrive %d\n",t));
-        if (ha->hdr[t].size > (ulong64)0xffffffff)
+        if (ha->hdr[t].size > (u64)0xffffffff)
             rdc.last_block_no = 0xffffffff;
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
@@ -2425,12 +2425,12 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     return 0;
 }
 
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-    ulong32 cnt, blockcnt;
-    ulong64 no, blockno;
+    u32 cnt, blockcnt;
+    u64 no, blockno;
     int i, cmd_index, read_write, sgcnt, mode64;
 
     cmdp = ha->pccb;
@@ -2498,17 +2498,17 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 
     if (read_write) {
         if (scp->cmd_len == 16) {
-            memcpy(&no, &scp->cmnd[2], sizeof(ulong64));
+            memcpy(&no, &scp->cmnd[2], sizeof(u64));
             blockno = be64_to_cpu(no);
-            memcpy(&cnt, &scp->cmnd[10], sizeof(ulong32));
+            memcpy(&cnt, &scp->cmnd[10], sizeof(u32));
             blockcnt = be32_to_cpu(cnt);
         } else if (scp->cmd_len == 10) {
-            memcpy(&no, &scp->cmnd[2], sizeof(ulong32));
+            memcpy(&no, &scp->cmnd[2], sizeof(u32));
             blockno = be32_to_cpu(no);
-            memcpy(&cnt, &scp->cmnd[7], sizeof(ushort));
+            memcpy(&cnt, &scp->cmnd[7], sizeof(u16));
             blockcnt = be16_to_cpu(cnt);
         } else {
-            memcpy(&no, &scp->cmnd[0], sizeof(ulong32));
+            memcpy(&no, &scp->cmnd[0], sizeof(u32));
             blockno = be32_to_cpu(no) & 0x001fffffUL;
             blockcnt= scp->cmnd[4]==0 ? 0x100 : scp->cmnd[4];
         }
@@ -2516,7 +2516,7 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
             cmdp->u.cache64.BlockNo = blockno;
             cmdp->u.cache64.BlockCnt = blockcnt;
         } else {
-            cmdp->u.cache.BlockNo = (ulong32)blockno;
+            cmdp->u.cache.BlockNo = (u32)blockno;
             cmdp->u.cache.BlockCnt = blockcnt;
         }
 
@@ -2528,12 +2528,12 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
             if (mode64) {
                 struct scatterlist *sl;
 
-                cmdp->u.cache64.DestAddr= (ulong64)-1;
+                cmdp->u.cache64.DestAddr= (u64)-1;
                 cmdp->u.cache64.sg_canz = sgcnt;
                 scsi_for_each_sg(scp, sl, sgcnt, i) {
                     cmdp->u.cache64.sg_lst[i].sg_ptr = sg_dma_address(sl);
 #ifdef GDTH_DMA_STATISTICS
-                    if (cmdp->u.cache64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
+                    if (cmdp->u.cache64.sg_lst[i].sg_ptr > (u64)0xffffffff)
                         ha->dma64_cnt++;
                     else
                         ha->dma32_cnt++;
@@ -2555,8 +2555,8 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
             }
 
 #ifdef GDTH_STATISTICS
-            if (max_sg < (ulong32)sgcnt) {
-                max_sg = (ulong32)sgcnt;
+            if (max_sg < (u32)sgcnt) {
+                max_sg = (u32)sgcnt;
                 TRACE3(("GDT: max_sg = %d\n",max_sg));
             }
 #endif
@@ -2572,7 +2572,7 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
         TRACE(("cache cmd: cmd %d blockno. %d, blockcnt %d\n",
                cmdp->OpCode,cmdp->u.cache64.BlockNo,cmdp->u.cache64.BlockCnt));
         ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.cache64.sg_lst) +
-            (ushort)cmdp->u.cache64.sg_canz * sizeof(gdth_sg64_str);
+            (u16)cmdp->u.cache64.sg_canz * sizeof(gdth_sg64_str);
     } else {
         TRACE(("cache cmd: addr. %x sganz %x sgptr0 %x sglen0 %x\n",
                cmdp->u.cache.DestAddr,cmdp->u.cache.sg_canz,
@@ -2581,7 +2581,7 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
         TRACE(("cache cmd: cmd %d blockno. %d, blockcnt %d\n",
                cmdp->OpCode,cmdp->u.cache.BlockNo,cmdp->u.cache.BlockCnt));
         ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.cache.sg_lst) +
-            (ushort)cmdp->u.cache.sg_canz * sizeof(gdth_sg_str);
+            (u16)cmdp->u.cache.sg_canz * sizeof(gdth_sg_str);
     }
     if (ha->cmd_len & 3)
         ha->cmd_len += (4 - (ha->cmd_len & 3));
@@ -2600,15 +2600,15 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
     return cmd_index;
 }
 
-static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b)
 {
     register gdth_cmd_str *cmdp;
-    ushort i;
+    u16 i;
     dma_addr_t sense_paddr;
     int cmd_index, sgcnt, mode64;
-    unchar t,l;
+    u8 t,l;
     struct page *page;
-    ulong offset;
+    unsigned long offset;
     struct gdth_cmndinfo *cmndinfo;
 
     t = scp->device->id;
@@ -2654,7 +2654,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
 
     } else {
         page = virt_to_page(scp->sense_buffer);
-        offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
+        offset = (unsigned long)scp->sense_buffer & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
 
@@ -2703,12 +2703,12 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
             if (mode64) {
                 struct scatterlist *sl;
 
-                cmdp->u.raw64.sdata = (ulong64)-1;
+                cmdp->u.raw64.sdata = (u64)-1;
                 cmdp->u.raw64.sg_ranz = sgcnt;
                 scsi_for_each_sg(scp, sl, sgcnt, i) {
                     cmdp->u.raw64.sg_lst[i].sg_ptr = sg_dma_address(sl);
 #ifdef GDTH_DMA_STATISTICS
-                    if (cmdp->u.raw64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
+                    if (cmdp->u.raw64.sg_lst[i].sg_ptr > (u64)0xffffffff)
                         ha->dma64_cnt++;
                     else
                         ha->dma32_cnt++;
@@ -2744,7 +2744,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
                    cmdp->u.raw64.sg_lst[0].sg_len));
             /* evaluate command size */
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.raw64.sg_lst) +
-                (ushort)cmdp->u.raw64.sg_ranz * sizeof(gdth_sg64_str);
+                (u16)cmdp->u.raw64.sg_ranz * sizeof(gdth_sg64_str);
         } else {
             TRACE(("raw cmd: addr. %x sganz %x sgptr0 %x sglen0 %x\n",
                    cmdp->u.raw.sdata,cmdp->u.raw.sg_ranz,
@@ -2752,7 +2752,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
                    cmdp->u.raw.sg_lst[0].sg_len));
             /* evaluate command size */
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.raw.sg_lst) +
-                (ushort)cmdp->u.raw.sg_ranz * sizeof(gdth_sg_str);
+                (u16)cmdp->u.raw.sg_ranz * sizeof(gdth_sg_str);
         }
     }
     /* check space */
@@ -2802,7 +2802,7 @@ static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     if (cmdp->OpCode == GDT_IOCTL) {
         TRACE2(("IOCTL\n"));
         ha->cmd_len = 
-            GDTOFFSOF(gdth_cmd_str,u.ioctl.p_param) + sizeof(ulong64);
+            GDTOFFSOF(gdth_cmd_str,u.ioctl.p_param) + sizeof(u64);
     } else if (cmdp->Service == CACHESERVICE) {
         TRACE2(("cache command %d\n",cmdp->OpCode));
         if (ha->cache_feat & GDT_64BIT)
@@ -2840,8 +2840,8 @@ static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 
 
 /* Controller event handling functions */
-static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, ushort source, 
-                                      ushort idx, gdth_evt_data *evt)
+static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, u16 source, 
+                                      u16 idx, gdth_evt_data *evt)
 {
     gdth_evt_str *e;
     struct timeval tv;
@@ -2890,7 +2890,7 @@ static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr)
 {
     gdth_evt_str *e;
     int eindex;
-    ulong flags;
+    unsigned long flags;
 
     TRACE2(("gdth_read_event() handle %d\n", handle));
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -2919,12 +2919,12 @@ static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr)
 }
 
 static void gdth_readapp_event(gdth_ha_str *ha,
-                               unchar application, gdth_evt_str *estr)
+                               u8 application, gdth_evt_str *estr)
 {
     gdth_evt_str *e;
     int eindex;
-    ulong flags;
-    unchar found = FALSE;
+    unsigned long flags;
+    u8 found = FALSE;
 
     TRACE2(("gdth_readapp_event() app. %d\n", application));
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -2969,9 +2969,9 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
     gdt2_dpram_str __iomem *dp2_ptr;
     Scsi_Cmnd *scp;
     int rval, i;
-    unchar IStatus;
-    ushort Service;
-    ulong flags = 0;
+    u8 IStatus;
+    u16 Service;
+    unsigned long flags = 0;
 #ifdef INT_COAL
     int coalesced = FALSE;
     int next = FALSE;
@@ -3018,7 +3018,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
         if (coalesced) {
             /* For coalesced requests all status
                information is found in the status buffer */
-            IStatus = (unchar)(pcs->status & 0xff);
+            IStatus = (u8)(pcs->status & 0xff);
         }
 #endif
     
@@ -3197,7 +3197,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
             ++act_int_coal;
             if (act_int_coal > max_int_coal) {
                 max_int_coal = act_int_coal;
-                printk("GDT: max_int_coal = %d\n",(ushort)max_int_coal);
+                printk("GDT: max_int_coal = %d\n",(u16)max_int_coal);
             }
 #endif      
             /* see if there is another status */
@@ -3225,12 +3225,12 @@ static irqreturn_t gdth_interrupt(int irq, void *dev_id)
 	return __gdth_interrupt(ha, false, NULL);
 }
 
-static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
+static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
                                                               Scsi_Cmnd *scp)
 {
     gdth_msg_str *msg;
     gdth_cmd_str *cmdp;
-    unchar b, t;
+    u8 b, t;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
 
     cmdp = ha->pccb;
@@ -3263,7 +3263,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
             cmdp->u.screen.su.msg.msg_addr  = ha->msg_phys;
             ha->cmd_offs_dpmem = 0;
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
-                + sizeof(ulong64);
+                + sizeof(u64);
             ha->cmd_cnt = 0;
             gdth_copy_command(ha);
             gdth_release_event(ha);
@@ -3297,7 +3297,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
             cmdp->u.screen.su.msg.msg_addr  = ha->msg_phys;
             ha->cmd_offs_dpmem = 0;
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
-                + sizeof(ulong64);
+                + sizeof(u64);
             ha->cmd_cnt = 0;
             gdth_copy_command(ha);
             gdth_release_event(ha);
@@ -3335,7 +3335,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                         cmndinfo->OpCode));
                 /* special commands GDT_CLUST_INFO/GDT_MOUNT ? */
                 if (cmndinfo->OpCode == GDT_CLUST_INFO) {
-                    ha->hdr[t].cluster_type = (unchar)ha->info;
+                    ha->hdr[t].cluster_type = (u8)ha->info;
                     if (!(ha->hdr[t].cluster_type & 
                         CLUSTER_MOUNTED)) {
                         /* NOT MOUNTED -> MOUNT */
@@ -3397,7 +3397,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                     ha->hdr[t].cluster_type &= ~CLUSTER_RESERVED;
                 }
                 memset((char*)scp->sense_buffer,0,16);
-                if (ha->status == (ushort)S_CACHE_RESERV) {
+                if (ha->status == (u16)S_CACHE_RESERV) {
                     scp->result = (DID_OK << 16) | (RESERVATION_CONFLICT << 1);
                 } else {
                     scp->sense_buffer[0] = 0x70;
@@ -3614,16 +3614,16 @@ static int gdth_async_event(gdth_ha_str *ha)
             cmdp->u.screen.su.msg.msg_addr  = ha->msg_phys;
             ha->cmd_offs_dpmem = 0;
             ha->cmd_len = GDTOFFSOF(gdth_cmd_str,u.screen.su.msg.msg_addr) 
-                + sizeof(ulong64);
+                + sizeof(u64);
             ha->cmd_cnt = 0;
             gdth_copy_command(ha);
             if (ha->type == GDT_EISA)
-                printk("[EISA slot %d] ",(ushort)ha->brd_phys);
+                printk("[EISA slot %d] ",(u16)ha->brd_phys);
             else if (ha->type == GDT_ISA)
-                printk("[DPMEM 0x%4X] ",(ushort)ha->brd_phys);
+                printk("[DPMEM 0x%4X] ",(u16)ha->brd_phys);
             else 
-                printk("[PCI %d/%d] ",(ushort)(ha->brd_phys>>8),
-                       (ushort)((ha->brd_phys>>3)&0x1f));
+                printk("[PCI %d/%d] ",(u16)(ha->brd_phys>>8),
+                       (u16)((ha->brd_phys>>3)&0x1f));
             gdth_release_event(ha);
         }
 
@@ -3640,7 +3640,7 @@ static int gdth_async_event(gdth_ha_str *ha)
             ha->dvr.eu.async.service = ha->service;
             ha->dvr.eu.async.status  = ha->status;
             ha->dvr.eu.async.info    = ha->info;
-            *(ulong32 *)ha->dvr.eu.async.scsi_coord  = ha->info2;
+            *(u32 *)ha->dvr.eu.async.scsi_coord  = ha->info2;
         }
         gdth_store_event( ha, ES_ASYNC, ha->service, &ha->dvr );
         gdth_log_event( &ha->dvr, NULL );
@@ -3648,8 +3648,8 @@ static int gdth_async_event(gdth_ha_str *ha)
         /* new host drive from expand? */
         if (ha->service == CACHESERVICE && ha->status == 56) {
             TRACE2(("gdth_async_event(): new host drive %d created\n",
-                    (ushort)ha->info));
-            /* gdth_analyse_hdrive(hanum, (ushort)ha->info); */
+                    (u16)ha->info));
+            /* gdth_analyse_hdrive(hanum, (u16)ha->info); */
         }   
     }
     return 1;
@@ -3680,13 +3680,13 @@ static void gdth_log_event(gdth_evt_data *dvr, char *buffer)
         for (j=0,i=1; i < f[0]; i+=2) {
             switch (f[i+1]) {
               case 4:
-                stack.b[j++] = *(ulong32*)&dvr->eu.stream[(int)f[i]];
+                stack.b[j++] = *(u32*)&dvr->eu.stream[(int)f[i]];
                 break;
               case 2:
-                stack.b[j++] = *(ushort*)&dvr->eu.stream[(int)f[i]];
+                stack.b[j++] = *(u16*)&dvr->eu.stream[(int)f[i]];
                 break;
               case 1:
-                stack.b[j++] = *(unchar*)&dvr->eu.stream[(int)f[i]];
+                stack.b[j++] = *(u8*)&dvr->eu.stream[(int)f[i]];
                 break;
               default:
                 break;
@@ -3712,14 +3712,14 @@ static void gdth_log_event(gdth_evt_data *dvr, char *buffer)
 }
 
 #ifdef GDTH_STATISTICS
-static unchar	gdth_timer_running;
+static u8	gdth_timer_running;
 
-static void gdth_timeout(ulong data)
+static void gdth_timeout(unsigned long data)
 {
-    ulong32 i;
+    u32 i;
     Scsi_Cmnd *nscp;
     gdth_ha_str *ha;
-    ulong flags;
+    unsigned long flags;
 
     if(unlikely(list_empty(&gdth_instances))) {
 	    gdth_timer_running = 0;
@@ -3891,8 +3891,8 @@ static enum blk_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
 {
 	gdth_ha_str *ha = shost_priv(scp->device->host);
 	struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-	unchar b, t;
-	ulong flags;
+	u8 b, t;
+	unsigned long flags;
 	enum blk_eh_timer_return retval = BLK_EH_NOT_HANDLED;
 
 	TRACE(("%s() cmd 0x%x\n", scp->cmnd[0], __func__));
@@ -3924,9 +3924,9 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
     int i;
-    ulong flags;
+    unsigned long flags;
     Scsi_Cmnd *cmnd;
-    unchar b;
+    u8 b;
 
     TRACE2(("gdth_eh_bus_reset()\n"));
 
@@ -3974,7 +3974,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
 {
-    unchar b, t;
+    u8 b, t;
     gdth_ha_str *ha = shost_priv(sdev->host);
     struct scsi_device *sd;
     unsigned capacity;
@@ -4062,7 +4062,7 @@ static int ioc_event(void __user *arg)
 {
     gdth_ioctl_event evt;
     gdth_ha_str *ha;
-    ulong flags;
+    unsigned long flags;
 
     if (copy_from_user(&evt, arg, sizeof(gdth_ioctl_event)))
         return -EFAULT;
@@ -4098,8 +4098,8 @@ static int ioc_event(void __user *arg)
 static int ioc_lockdrv(void __user *arg)
 {
     gdth_ioctl_lockdrv ldrv;
-    unchar i, j;
-    ulong flags;
+    u8 i, j;
+    unsigned long flags;
     gdth_ha_str *ha;
 
     if (copy_from_user(&ldrv, arg, sizeof(gdth_ioctl_lockdrv)))
@@ -4165,7 +4165,7 @@ static int ioc_general(void __user *arg, char *cmnd)
 {
     gdth_ioctl_general gen;
     char *buf = NULL;
-    ulong64 paddr; 
+    u64 paddr; 
     gdth_ha_str *ha;
     int rval;
 
@@ -4194,7 +4194,7 @@ static int ioc_general(void __user *arg, char *cmnd)
                 gen.command.u.cache64.DeviceNo = gen.command.u.cache.DeviceNo;
                 /* addresses */
                 if (ha->cache_feat & SCATTER_GATHER) {
-                    gen.command.u.cache64.DestAddr = (ulong64)-1;
+                    gen.command.u.cache64.DestAddr = (u64)-1;
                     gen.command.u.cache64.sg_canz = 1;
                     gen.command.u.cache64.sg_lst[0].sg_ptr = paddr;
                     gen.command.u.cache64.sg_lst[0].sg_len = gen.data_len;
@@ -4207,7 +4207,7 @@ static int ioc_general(void __user *arg, char *cmnd)
                 if (ha->cache_feat & SCATTER_GATHER) {
                     gen.command.u.cache.DestAddr = 0xffffffff;
                     gen.command.u.cache.sg_canz = 1;
-                    gen.command.u.cache.sg_lst[0].sg_ptr = (ulong32)paddr;
+                    gen.command.u.cache.sg_lst[0].sg_ptr = (u32)paddr;
                     gen.command.u.cache.sg_lst[0].sg_len = gen.data_len;
                     gen.command.u.cache.sg_lst[1].sg_len = 0;
                 } else {
@@ -4230,7 +4230,7 @@ static int ioc_general(void __user *arg, char *cmnd)
                 gen.command.u.raw64.direction = gen.command.u.raw.direction;
                 /* addresses */
                 if (ha->raw_feat & SCATTER_GATHER) {
-                    gen.command.u.raw64.sdata = (ulong64)-1;
+                    gen.command.u.raw64.sdata = (u64)-1;
                     gen.command.u.raw64.sg_ranz = 1;
                     gen.command.u.raw64.sg_lst[0].sg_ptr = paddr;
                     gen.command.u.raw64.sg_lst[0].sg_len = gen.data_len;
@@ -4244,14 +4244,14 @@ static int ioc_general(void __user *arg, char *cmnd)
                 if (ha->raw_feat & SCATTER_GATHER) {
                     gen.command.u.raw.sdata = 0xffffffff;
                     gen.command.u.raw.sg_ranz = 1;
-                    gen.command.u.raw.sg_lst[0].sg_ptr = (ulong32)paddr;
+                    gen.command.u.raw.sg_lst[0].sg_ptr = (u32)paddr;
                     gen.command.u.raw.sg_lst[0].sg_len = gen.data_len;
                     gen.command.u.raw.sg_lst[1].sg_len = 0;
                 } else {
                     gen.command.u.raw.sdata = paddr;
                     gen.command.u.raw.sg_ranz = 0;
                 }
-                gen.command.u.raw.sense_data = (ulong32)paddr + gen.data_len;
+                gen.command.u.raw.sense_data = (u32)paddr + gen.data_len;
             }
         } else {
             gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
@@ -4283,7 +4283,7 @@ static int ioc_hdrlist(void __user *arg, char *cmnd)
     gdth_ioctl_rescan *rsc;
     gdth_cmd_str *cmd;
     gdth_ha_str *ha;
-    unchar i;
+    u8 i;
     int rc = -ENOMEM;
     u32 cluster_type = 0;
 
@@ -4335,11 +4335,11 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 {
     gdth_ioctl_rescan *rsc;
     gdth_cmd_str *cmd;
-    ushort i, status, hdr_cnt;
-    ulong32 info;
+    u16 i, status, hdr_cnt;
+    u32 info;
     int cyls, hds, secs;
     int rc = -ENOMEM;
-    ulong flags;
+    unsigned long flags;
     gdth_ha_str *ha; 
 
     rsc = kmalloc(sizeof(*rsc), GFP_KERNEL);
@@ -4367,7 +4367,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 
         status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
         i = 0;
-        hdr_cnt = (status == S_OK ? (ushort)info : 0);
+        hdr_cnt = (status == S_OK ? (u16)info : 0);
     } else {
         i = rsc->hdr_no;
         hdr_cnt = i + 1;
@@ -4418,7 +4418,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
 
         spin_lock_irqsave(&ha->smp_lock, flags);
-        ha->hdr[i].devtype = (status == S_OK ? (ushort)info : 0);
+        ha->hdr[i].devtype = (status == S_OK ? (u16)info : 0);
         spin_unlock_irqrestore(&ha->smp_lock, flags);
 
         cmd->Service = CACHESERVICE;
@@ -4432,7 +4432,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 
         spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].cluster_type = 
-            ((status == S_OK && !shared_access) ? (ushort)info : 0);
+            ((status == S_OK && !shared_access) ? (u16)info : 0);
         spin_unlock_irqrestore(&ha->smp_lock, flags);
         rsc->hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
 
@@ -4446,7 +4446,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
 
         spin_lock_irqsave(&ha->smp_lock, flags);
-        ha->hdr[i].rw_attribs = (status == S_OK ? (ushort)info : 0);
+        ha->hdr[i].rw_attribs = (status == S_OK ? (u16)info : 0);
         spin_unlock_irqrestore(&ha->smp_lock, flags);
     }
  
@@ -4466,7 +4466,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
 {
     gdth_ha_str *ha; 
     Scsi_Cmnd *scp;
-    ulong flags;
+    unsigned long flags;
     char cmnd[MAX_COMMAND_SIZE];   
     void __user *argp = (void __user *)arg;
 
@@ -4495,9 +4495,9 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
       { 
         gdth_ioctl_osvers osv; 
 
-        osv.version = (unchar)(LINUX_VERSION_CODE >> 16);
-        osv.subversion = (unchar)(LINUX_VERSION_CODE >> 8);
-        osv.revision = (ushort)(LINUX_VERSION_CODE & 0xff);
+        osv.version = (u8)(LINUX_VERSION_CODE >> 16);
+        osv.subversion = (u8)(LINUX_VERSION_CODE >> 8);
+        osv.revision = (u16)(LINUX_VERSION_CODE & 0xff);
         if (copy_to_user(argp, &osv, sizeof(gdth_ioctl_osvers)))
                 return -EFAULT;
         break;
@@ -4512,10 +4512,10 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
             return -EFAULT;
 
         if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
-            ctrt.type = (unchar)((ha->stype>>20) - 0x10);
+            ctrt.type = (u8)((ha->stype>>20) - 0x10);
         } else {
             if (ha->type != GDT_PCIMPR) {
-                ctrt.type = (unchar)((ha->stype<<4) + 6);
+                ctrt.type = (u8)((ha->stype<<4) + 6);
             } else {
                 ctrt.type = 
                     (ha->oem_id == OEM_ID_INTEL ? 0xfd : 0xfe);
@@ -4546,7 +4546,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
       case GDTIOCTL_LOCKCHN:
       {
         gdth_ioctl_lockchn lchn;
-        unchar i, j;
+        u8 i, j;
 
         if (copy_from_user(&lchn, argp, sizeof(gdth_ioctl_lockchn)) ||
             (NULL == (ha = gdth_find_ha(lchn.ionode))))
@@ -4670,7 +4670,7 @@ static struct scsi_host_template gdth_template = {
 };
 
 #ifdef CONFIG_ISA
-static int __init gdth_isa_probe_one(ulong32 isa_bios)
+static int __init gdth_isa_probe_one(u32 isa_bios)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -4802,7 +4802,7 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_EISA
-static int __init gdth_eisa_probe_one(ushort eisa_slot)
+static int __init gdth_eisa_probe_one(u16 eisa_slot)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -5120,7 +5120,7 @@ static void gdth_remove_one(gdth_ha_str *ha)
 	scsi_host_put(shp);
 }
 
-static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
+static int gdth_halt(struct notifier_block *nb, unsigned long event, void *buf)
 {
 	gdth_ha_str *ha;
 
@@ -5158,14 +5158,14 @@ static int __init gdth_init(void)
 	if (probe_eisa_isa) {
 		/* scanning for controllers, at first: ISA controller */
 #ifdef CONFIG_ISA
-		ulong32 isa_bios;
+		u32 isa_bios;
 		for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
 		                isa_bios += 0x8000UL)
 			gdth_isa_probe_one(isa_bios);
 #endif
 #ifdef CONFIG_EISA
 		{
-			ushort eisa_slot;
+			u16 eisa_slot;
 			for (eisa_slot = 0x1000; eisa_slot <= 0x8000;
 			                         eisa_slot += 0x1000)
 				gdth_eisa_probe_one(eisa_slot);
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1646444..120a062 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -321,524 +321,524 @@
 
 /* screenservice message */
 typedef struct {                               
-    ulong32     msg_handle;                     /* message handle */
-    ulong32     msg_len;                        /* size of message */
-    ulong32     msg_alen;                       /* answer length */
-    unchar      msg_answer;                     /* answer flag */
-    unchar      msg_ext;                        /* more messages */
-    unchar      msg_reserved[2];
+    u32     msg_handle;                     /* message handle */
+    u32     msg_len;                        /* size of message */
+    u32     msg_alen;                       /* answer length */
+    u8      msg_answer;                     /* answer flag */
+    u8      msg_ext;                        /* more messages */
+    u8      msg_reserved[2];
     char        msg_text[MSGLEN+2];             /* the message text */
-} PACKED gdth_msg_str;
+} __attribute__((packed)) gdth_msg_str;
 
 
 /* IOCTL data structures */
 
 /* Status coalescing buffer for returning multiple requests per interrupt */
 typedef struct {
-    ulong32     status;
-    ulong32     ext_status;
-    ulong32     info0;
-    ulong32     info1;
-} PACKED gdth_coal_status;
+    u32     status;
+    u32     ext_status;
+    u32     info0;
+    u32     info1;
+} __attribute__((packed)) gdth_coal_status;
 
 /* performance mode data structure */
 typedef struct {
-    ulong32     version;            /* The version of this IOCTL structure. */
-    ulong32     st_mode;            /* 0=dis., 1=st_buf_addr1 valid, 2=both  */
-    ulong32     st_buff_addr1;      /* physical address of status buffer 1 */
-    ulong32     st_buff_u_addr1;    /* reserved for 64 bit addressing */
-    ulong32     st_buff_indx1;      /* reserved command idx. for this buffer */
-    ulong32     st_buff_addr2;      /* physical address of status buffer 1 */
-    ulong32     st_buff_u_addr2;    /* reserved for 64 bit addressing */
-    ulong32     st_buff_indx2;      /* reserved command idx. for this buffer */
-    ulong32     st_buff_size;       /* size of each buffer in bytes */
-    ulong32     cmd_mode;           /* 0 = mode disabled, 1 = cmd_buff_addr1 */ 
-    ulong32     cmd_buff_addr1;     /* physical address of cmd buffer 1 */   
-    ulong32     cmd_buff_u_addr1;   /* reserved for 64 bit addressing */
-    ulong32     cmd_buff_indx1;     /* cmd buf addr1 unique identifier */
-    ulong32     cmd_buff_addr2;     /* physical address of cmd buffer 1 */   
-    ulong32     cmd_buff_u_addr2;   /* reserved for 64 bit addressing */
-    ulong32     cmd_buff_indx2;     /* cmd buf addr1 unique identifier */
-    ulong32     cmd_buff_size;      /* size of each cmd bufer in bytes */
-    ulong32     reserved1;
-    ulong32     reserved2;
-} PACKED gdth_perf_modes;
+    u32     version;            /* The version of this IOCTL structure. */
+    u32     st_mode;            /* 0=dis., 1=st_buf_addr1 valid, 2=both  */
+    u32     st_buff_addr1;      /* physical address of status buffer 1 */
+    u32     st_buff_u_addr1;    /* reserved for 64 bit addressing */
+    u32     st_buff_indx1;      /* reserved command idx. for this buffer */
+    u32     st_buff_addr2;      /* physical address of status buffer 1 */
+    u32     st_buff_u_addr2;    /* reserved for 64 bit addressing */
+    u32     st_buff_indx2;      /* reserved command idx. for this buffer */
+    u32     st_buff_size;       /* size of each buffer in bytes */
+    u32     cmd_mode;           /* 0 = mode disabled, 1 = cmd_buff_addr1 */ 
+    u32     cmd_buff_addr1;     /* physical address of cmd buffer 1 */   
+    u32     cmd_buff_u_addr1;   /* reserved for 64 bit addressing */
+    u32     cmd_buff_indx1;     /* cmd buf addr1 unique identifier */
+    u32     cmd_buff_addr2;     /* physical address of cmd buffer 1 */   
+    u32     cmd_buff_u_addr2;   /* reserved for 64 bit addressing */
+    u32     cmd_buff_indx2;     /* cmd buf addr1 unique identifier */
+    u32     cmd_buff_size;      /* size of each cmd bufer in bytes */
+    u32     reserved1;
+    u32     reserved2;
+} __attribute__((packed)) gdth_perf_modes;
 
 /* SCSI drive info */
 typedef struct {
-    unchar      vendor[8];                      /* vendor string */
-    unchar      product[16];                    /* product string */
-    unchar      revision[4];                    /* revision */
-    ulong32     sy_rate;                        /* current rate for sync. tr. */
-    ulong32     sy_max_rate;                    /* max. rate for sync. tr. */
-    ulong32     no_ldrive;                      /* belongs to this log. drv.*/
-    ulong32     blkcnt;                         /* number of blocks */
-    ushort      blksize;                        /* size of block in bytes */
-    unchar      available;                      /* flag: access is available */
-    unchar      init;                           /* medium is initialized */
-    unchar      devtype;                        /* SCSI devicetype */
-    unchar      rm_medium;                      /* medium is removable */
-    unchar      wp_medium;                      /* medium is write protected */
-    unchar      ansi;                           /* SCSI I/II or III? */
-    unchar      protocol;                       /* same as ansi */
-    unchar      sync;                           /* flag: sync. transfer enab. */
-    unchar      disc;                           /* flag: disconnect enabled */
-    unchar      queueing;                       /* flag: command queing enab. */
-    unchar      cached;                         /* flag: caching enabled */
-    unchar      target_id;                      /* target ID of device */
-    unchar      lun;                            /* LUN id of device */
-    unchar      orphan;                         /* flag: drive fragment */
-    ulong32     last_error;                     /* sense key or drive state */
-    ulong32     last_result;                    /* result of last command */
-    ulong32     check_errors;                   /* err. in last surface check */
-    unchar      percent;                        /* progress for surface check */
-    unchar      last_check;                     /* IOCTRL operation */
-    unchar      res[2];
-    ulong32     flags;                          /* from 1.19/2.19: raw reserv.*/
-    unchar      multi_bus;                      /* multi bus dev? (fibre ch.) */
-    unchar      mb_status;                      /* status: available? */
-    unchar      res2[2];
-    unchar      mb_alt_status;                  /* status on second bus */
-    unchar      mb_alt_bid;                     /* number of second bus */
-    unchar      mb_alt_tid;                     /* target id on second bus */
-    unchar      res3;
-    unchar      fc_flag;                        /* from 1.22/2.22: info valid?*/
-    unchar      res4;
-    ushort      fc_frame_size;                  /* frame size (bytes) */
+    u8      vendor[8];                      /* vendor string */
+    u8      product[16];                    /* product string */
+    u8      revision[4];                    /* revision */
+    u32     sy_rate;                        /* current rate for sync. tr. */
+    u32     sy_max_rate;                    /* max. rate for sync. tr. */
+    u32     no_ldrive;                      /* belongs to this log. drv.*/
+    u32     blkcnt;                         /* number of blocks */
+    u16      blksize;                        /* size of block in bytes */
+    u8      available;                      /* flag: access is available */
+    u8      init;                           /* medium is initialized */
+    u8      devtype;                        /* SCSI devicetype */
+    u8      rm_medium;                      /* medium is removable */
+    u8      wp_medium;                      /* medium is write protected */
+    u8      ansi;                           /* SCSI I/II or III? */
+    u8      protocol;                       /* same as ansi */
+    u8      sync;                           /* flag: sync. transfer enab. */
+    u8      disc;                           /* flag: disconnect enabled */
+    u8      queueing;                       /* flag: command queing enab. */
+    u8      cached;                         /* flag: caching enabled */
+    u8      target_id;                      /* target ID of device */
+    u8      lun;                            /* LUN id of device */
+    u8      orphan;                         /* flag: drive fragment */
+    u32     last_error;                     /* sense key or drive state */
+    u32     last_result;                    /* result of last command */
+    u32     check_errors;                   /* err. in last surface check */
+    u8      percent;                        /* progress for surface check */
+    u8      last_check;                     /* IOCTRL operation */
+    u8      res[2];
+    u32     flags;                          /* from 1.19/2.19: raw reserv.*/
+    u8      multi_bus;                      /* multi bus dev? (fibre ch.) */
+    u8      mb_status;                      /* status: available? */
+    u8      res2[2];
+    u8      mb_alt_status;                  /* status on second bus */
+    u8      mb_alt_bid;                     /* number of second bus */
+    u8      mb_alt_tid;                     /* target id on second bus */
+    u8      res3;
+    u8      fc_flag;                        /* from 1.22/2.22: info valid?*/
+    u8      res4;
+    u16      fc_frame_size;                  /* frame size (bytes) */
     char        wwn[8];                         /* world wide name */
-} PACKED gdth_diskinfo_str;
+} __attribute__((packed)) gdth_diskinfo_str;
 
 /* get SCSI channel count  */
 typedef struct {
-    ulong32     channel_no;                     /* number of channel */
-    ulong32     drive_cnt;                      /* drive count */
-    unchar      siop_id;                        /* SCSI processor ID */
-    unchar      siop_state;                     /* SCSI processor state */ 
-} PACKED gdth_getch_str;
+    u32     channel_no;                     /* number of channel */
+    u32     drive_cnt;                      /* drive count */
+    u8      siop_id;                        /* SCSI processor ID */
+    u8      siop_state;                     /* SCSI processor state */ 
+} __attribute__((packed)) gdth_getch_str;
 
 /* get SCSI drive numbers */
 typedef struct {
-    ulong32     sc_no;                          /* SCSI channel */
-    ulong32     sc_cnt;                         /* sc_list[] elements */
-    ulong32     sc_list[MAXID];                 /* minor device numbers */
-} PACKED gdth_drlist_str;
+    u32     sc_no;                          /* SCSI channel */
+    u32     sc_cnt;                         /* sc_list[] elements */
+    u32     sc_list[MAXID];                 /* minor device numbers */
+} __attribute__((packed)) gdth_drlist_str;
 
 /* get grown/primary defect count */
 typedef struct {
-    unchar      sddc_type;                      /* 0x08: grown, 0x10: prim. */
-    unchar      sddc_format;                    /* list entry format */
-    unchar      sddc_len;                       /* list entry length */
-    unchar      sddc_res;
-    ulong32     sddc_cnt;                       /* entry count */
-} PACKED gdth_defcnt_str;
+    u8      sddc_type;                      /* 0x08: grown, 0x10: prim. */
+    u8      sddc_format;                    /* list entry format */
+    u8      sddc_len;                       /* list entry length */
+    u8      sddc_res;
+    u32     sddc_cnt;                       /* entry count */
+} __attribute__((packed)) gdth_defcnt_str;
 
 /* disk statistics */
 typedef struct {
-    ulong32     bid;                            /* SCSI channel */
-    ulong32     first;                          /* first SCSI disk */
-    ulong32     entries;                        /* number of elements */
-    ulong32     count;                          /* (R) number of init. el. */
-    ulong32     mon_time;                       /* time stamp */
+    u32     bid;                            /* SCSI channel */
+    u32     first;                          /* first SCSI disk */
+    u32     entries;                        /* number of elements */
+    u32     count;                          /* (R) number of init. el. */
+    u32     mon_time;                       /* time stamp */
     struct {
-        unchar  tid;                            /* target ID */
-        unchar  lun;                            /* LUN */
-        unchar  res[2];
-        ulong32 blk_size;                       /* block size in bytes */
-        ulong32 rd_count;                       /* bytes read */
-        ulong32 wr_count;                       /* bytes written */
-        ulong32 rd_blk_count;                   /* blocks read */
-        ulong32 wr_blk_count;                   /* blocks written */
-        ulong32 retries;                        /* retries */
-        ulong32 reassigns;                      /* reassigns */
-    } PACKED list[1];
-} PACKED gdth_dskstat_str;
+        u8  tid;                            /* target ID */
+        u8  lun;                            /* LUN */
+        u8  res[2];
+        u32 blk_size;                       /* block size in bytes */
+        u32 rd_count;                       /* bytes read */
+        u32 wr_count;                       /* bytes written */
+        u32 rd_blk_count;                   /* blocks read */
+        u32 wr_blk_count;                   /* blocks written */
+        u32 retries;                        /* retries */
+        u32 reassigns;                      /* reassigns */
+    } __attribute__((packed)) list[1];
+} __attribute__((packed)) gdth_dskstat_str;
 
 /* IO channel header */
 typedef struct {
-    ulong32     version;                        /* version (-1UL: newest) */
-    unchar      list_entries;                   /* list entry count */
-    unchar      first_chan;                     /* first channel number */
-    unchar      last_chan;                      /* last channel number */
-    unchar      chan_count;                     /* (R) channel count */
-    ulong32     list_offset;                    /* offset of list[0] */
-} PACKED gdth_iochan_header;
+    u32     version;                        /* version (-1UL: newest) */
+    u8      list_entries;                   /* list entry count */
+    u8      first_chan;                     /* first channel number */
+    u8      last_chan;                      /* last channel number */
+    u8      chan_count;                     /* (R) channel count */
+    u32     list_offset;                    /* offset of list[0] */
+} __attribute__((packed)) gdth_iochan_header;
 
 /* get IO channel description */
 typedef struct {
     gdth_iochan_header  hdr;
     struct {
-        ulong32         address;                /* channel address */
-        unchar          type;                   /* type (SCSI, FCAL) */
-        unchar          local_no;               /* local number */
-        ushort          features;               /* channel features */
-    } PACKED list[MAXBUS];
-} PACKED gdth_iochan_str;
+        u32         address;                /* channel address */
+        u8          type;                   /* type (SCSI, FCAL) */
+        u8          local_no;               /* local number */
+        u16          features;               /* channel features */
+    } __attribute__((packed)) list[MAXBUS];
+} __attribute__((packed)) gdth_iochan_str;
 
 /* get raw IO channel description */
 typedef struct {
     gdth_iochan_header  hdr;
     struct {
-        unchar      proc_id;                    /* processor id */
-        unchar      proc_defect;                /* defect ? */
-        unchar      reserved[2];
-    } PACKED list[MAXBUS];
-} PACKED gdth_raw_iochan_str;
+        u8      proc_id;                    /* processor id */
+        u8      proc_defect;                /* defect ? */
+        u8      reserved[2];
+    } __attribute__((packed)) list[MAXBUS];
+} __attribute__((packed)) gdth_raw_iochan_str;
 
 /* array drive component */
 typedef struct {
-    ulong32     al_controller;                  /* controller ID */
-    unchar      al_cache_drive;                 /* cache drive number */
-    unchar      al_status;                      /* cache drive state */
-    unchar      al_res[2];     
-} PACKED gdth_arraycomp_str;
+    u32     al_controller;                  /* controller ID */
+    u8      al_cache_drive;                 /* cache drive number */
+    u8      al_status;                      /* cache drive state */
+    u8      al_res[2];     
+} __attribute__((packed)) gdth_arraycomp_str;
 
 /* array drive information */
 typedef struct {
-    unchar      ai_type;                        /* array type (RAID0,4,5) */
-    unchar      ai_cache_drive_cnt;             /* active cachedrives */
-    unchar      ai_state;                       /* array drive state */
-    unchar      ai_master_cd;                   /* master cachedrive */
-    ulong32     ai_master_controller;           /* ID of master controller */
-    ulong32     ai_size;                        /* user capacity [sectors] */
-    ulong32     ai_striping_size;               /* striping size [sectors] */
-    ulong32     ai_secsize;                     /* sector size [bytes] */
-    ulong32     ai_err_info;                    /* failed cache drive */
-    unchar      ai_name[8];                     /* name of the array drive */
-    unchar      ai_controller_cnt;              /* number of controllers */
-    unchar      ai_removable;                   /* flag: removable */
-    unchar      ai_write_protected;             /* flag: write protected */
-    unchar      ai_devtype;                     /* type: always direct access */
+    u8      ai_type;                        /* array type (RAID0,4,5) */
+    u8      ai_cache_drive_cnt;             /* active cachedrives */
+    u8      ai_state;                       /* array drive state */
+    u8      ai_master_cd;                   /* master cachedrive */
+    u32     ai_master_controller;           /* ID of master controller */
+    u32     ai_size;                        /* user capacity [sectors] */
+    u32     ai_striping_size;               /* striping size [sectors] */
+    u32     ai_secsize;                     /* sector size [bytes] */
+    u32     ai_err_info;                    /* failed cache drive */
+    u8      ai_name[8];                     /* name of the array drive */
+    u8      ai_controller_cnt;              /* number of controllers */
+    u8      ai_removable;                   /* flag: removable */
+    u8      ai_write_protected;             /* flag: write protected */
+    u8      ai_devtype;                     /* type: always direct access */
     gdth_arraycomp_str  ai_drives[35];          /* drive components: */
-    unchar      ai_drive_entries;               /* number of drive components */
-    unchar      ai_protected;                   /* protection flag */
-    unchar      ai_verify_state;                /* state of a parity verify */
-    unchar      ai_ext_state;                   /* extended array drive state */
-    unchar      ai_expand_state;                /* array expand state (>=2.18)*/
-    unchar      ai_reserved[3];
-} PACKED gdth_arrayinf_str;
+    u8      ai_drive_entries;               /* number of drive components */
+    u8      ai_protected;                   /* protection flag */
+    u8      ai_verify_state;                /* state of a parity verify */
+    u8      ai_ext_state;                   /* extended array drive state */
+    u8      ai_expand_state;                /* array expand state (>=2.18)*/
+    u8      ai_reserved[3];
+} __attribute__((packed)) gdth_arrayinf_str;
 
 /* get array drive list */
 typedef struct {
-    ulong32     controller_no;                  /* controller no. */
-    unchar      cd_handle;                      /* master cachedrive */
-    unchar      is_arrayd;                      /* Flag: is array drive? */
-    unchar      is_master;                      /* Flag: is array master? */
-    unchar      is_parity;                      /* Flag: is parity drive? */
-    unchar      is_hotfix;                      /* Flag: is hotfix drive? */
-    unchar      res[3];
-} PACKED gdth_alist_str;
+    u32     controller_no;                  /* controller no. */
+    u8      cd_handle;                      /* master cachedrive */
+    u8      is_arrayd;                      /* Flag: is array drive? */
+    u8      is_master;                      /* Flag: is array master? */
+    u8      is_parity;                      /* Flag: is parity drive? */
+    u8      is_hotfix;                      /* Flag: is hotfix drive? */
+    u8      res[3];
+} __attribute__((packed)) gdth_alist_str;
 
 typedef struct {
-    ulong32     entries_avail;                  /* allocated entries */
-    ulong32     entries_init;                   /* returned entries */
-    ulong32     first_entry;                    /* first entry number */
-    ulong32     list_offset;                    /* offset of following list */
+    u32     entries_avail;                  /* allocated entries */
+    u32     entries_init;                   /* returned entries */
+    u32     first_entry;                    /* first entry number */
+    u32     list_offset;                    /* offset of following list */
     gdth_alist_str list[1];                     /* list */
-} PACKED gdth_arcdl_str;
+} __attribute__((packed)) gdth_arcdl_str;
 
 /* cache info/config IOCTL */
 typedef struct {
-    ulong32     version;                        /* firmware version */
-    ushort      state;                          /* cache state (on/off) */
-    ushort      strategy;                       /* cache strategy */
-    ushort      write_back;                     /* write back state (on/off) */
-    ushort      block_size;                     /* cache block size */
-} PACKED gdth_cpar_str;
+    u32     version;                        /* firmware version */
+    u16      state;                          /* cache state (on/off) */
+    u16      strategy;                       /* cache strategy */
+    u16      write_back;                     /* write back state (on/off) */
+    u16      block_size;                     /* cache block size */
+} __attribute__((packed)) gdth_cpar_str;
 
 typedef struct {
-    ulong32     csize;                          /* cache size */
-    ulong32     read_cnt;                       /* read/write counter */
-    ulong32     write_cnt;
-    ulong32     tr_hits;                        /* hits */
-    ulong32     sec_hits;
-    ulong32     sec_miss;                       /* misses */
-} PACKED gdth_cstat_str;
+    u32     csize;                          /* cache size */
+    u32     read_cnt;                       /* read/write counter */
+    u32     write_cnt;
+    u32     tr_hits;                        /* hits */
+    u32     sec_hits;
+    u32     sec_miss;                       /* misses */
+} __attribute__((packed)) gdth_cstat_str;
 
 typedef struct {
     gdth_cpar_str   cpar;
     gdth_cstat_str  cstat;
-} PACKED gdth_cinfo_str;
+} __attribute__((packed)) gdth_cinfo_str;
 
 /* cache drive info */
 typedef struct {
-    unchar      cd_name[8];                     /* cache drive name */
-    ulong32     cd_devtype;                     /* SCSI devicetype */
-    ulong32     cd_ldcnt;                       /* number of log. drives */
-    ulong32     cd_last_error;                  /* last error */
-    unchar      cd_initialized;                 /* drive is initialized */
-    unchar      cd_removable;                   /* media is removable */
-    unchar      cd_write_protected;             /* write protected */
-    unchar      cd_flags;                       /* Pool Hot Fix? */
-    ulong32     ld_blkcnt;                      /* number of blocks */
-    ulong32     ld_blksize;                     /* blocksize */
-    ulong32     ld_dcnt;                        /* number of disks */
-    ulong32     ld_slave;                       /* log. drive index */
-    ulong32     ld_dtype;                       /* type of logical drive */
-    ulong32     ld_last_error;                  /* last error */
-    unchar      ld_name[8];                     /* log. drive name */
-    unchar      ld_error;                       /* error */
-} PACKED gdth_cdrinfo_str;
+    u8      cd_name[8];                     /* cache drive name */
+    u32     cd_devtype;                     /* SCSI devicetype */
+    u32     cd_ldcnt;                       /* number of log. drives */
+    u32     cd_last_error;                  /* last error */
+    u8      cd_initialized;                 /* drive is initialized */
+    u8      cd_removable;                   /* media is removable */
+    u8      cd_write_protected;             /* write protected */
+    u8      cd_flags;                       /* Pool Hot Fix? */
+    u32     ld_blkcnt;                      /* number of blocks */
+    u32     ld_blksize;                     /* blocksize */
+    u32     ld_dcnt;                        /* number of disks */
+    u32     ld_slave;                       /* log. drive index */
+    u32     ld_dtype;                       /* type of logical drive */
+    u32     ld_last_error;                  /* last error */
+    u8      ld_name[8];                     /* log. drive name */
+    u8      ld_error;                       /* error */
+} __attribute__((packed)) gdth_cdrinfo_str;
 
 /* OEM string */
 typedef struct {
-    ulong32     ctl_version;
-    ulong32     file_major_version;
-    ulong32     file_minor_version;
-    ulong32     buffer_size;
-    ulong32     cpy_count;
-    ulong32     ext_error;
-    ulong32     oem_id;
-    ulong32     board_id;
-} PACKED gdth_oem_str_params;
-
-typedef struct {
-    unchar      product_0_1_name[16];
-    unchar      product_4_5_name[16];
-    unchar      product_cluster_name[16];
-    unchar      product_reserved[16];
-    unchar      scsi_cluster_target_vendor_id[16];
-    unchar      cluster_raid_fw_name[16];
-    unchar      oem_brand_name[16];
-    unchar      oem_raid_type[16];
-    unchar      bios_type[13];
-    unchar      bios_title[50];
-    unchar      oem_company_name[37];
-    ulong32     pci_id_1;
-    ulong32     pci_id_2;
-    unchar      validation_status[80];
-    unchar      reserved_1[4];
-    unchar      scsi_host_drive_inquiry_vendor_id[16];
-    unchar      library_file_template[16];
-    unchar      reserved_2[16];
-    unchar      tool_name_1[32];
-    unchar      tool_name_2[32];
-    unchar      tool_name_3[32];
-    unchar      oem_contact_1[84];
-    unchar      oem_contact_2[84];
-    unchar      oem_contact_3[84];
-} PACKED gdth_oem_str;
+    u32     ctl_version;
+    u32     file_major_version;
+    u32     file_minor_version;
+    u32     buffer_size;
+    u32     cpy_count;
+    u32     ext_error;
+    u32     oem_id;
+    u32     board_id;
+} __attribute__((packed)) gdth_oem_str_params;
+
+typedef struct {
+    u8      product_0_1_name[16];
+    u8      product_4_5_name[16];
+    u8      product_cluster_name[16];
+    u8      product_reserved[16];
+    u8      scsi_cluster_target_vendor_id[16];
+    u8      cluster_raid_fw_name[16];
+    u8      oem_brand_name[16];
+    u8      oem_raid_type[16];
+    u8      bios_type[13];
+    u8      bios_title[50];
+    u8      oem_company_name[37];
+    u32     pci_id_1;
+    u32     pci_id_2;
+    u8      validation_status[80];
+    u8      reserved_1[4];
+    u8      scsi_host_drive_inquiry_vendor_id[16];
+    u8      library_file_template[16];
+    u8      reserved_2[16];
+    u8      tool_name_1[32];
+    u8      tool_name_2[32];
+    u8      tool_name_3[32];
+    u8      oem_contact_1[84];
+    u8      oem_contact_2[84];
+    u8      oem_contact_3[84];
+} __attribute__((packed)) gdth_oem_str;
 
 typedef struct {
     gdth_oem_str_params params;
     gdth_oem_str        text;
-} PACKED gdth_oem_str_ioctl;
+} __attribute__((packed)) gdth_oem_str_ioctl;
 
 /* board features */
 typedef struct {
-    unchar      chaining;                       /* Chaining supported */
-    unchar      striping;                       /* Striping (RAID-0) supp. */
-    unchar      mirroring;                      /* Mirroring (RAID-1) supp. */
-    unchar      raid;                           /* RAID-4/5/10 supported */
-} PACKED gdth_bfeat_str;
+    u8      chaining;                       /* Chaining supported */
+    u8      striping;                       /* Striping (RAID-0) supp. */
+    u8      mirroring;                      /* Mirroring (RAID-1) supp. */
+    u8      raid;                           /* RAID-4/5/10 supported */
+} __attribute__((packed)) gdth_bfeat_str;
 
 /* board info IOCTL */
 typedef struct {
-    ulong32     ser_no;                         /* serial no. */
-    unchar      oem_id[2];                      /* OEM ID */
-    ushort      ep_flags;                       /* eprom flags */
-    ulong32     proc_id;                        /* processor ID */
-    ulong32     memsize;                        /* memory size (bytes) */
-    unchar      mem_banks;                      /* memory banks */
-    unchar      chan_type;                      /* channel type */
-    unchar      chan_count;                     /* channel count */
-    unchar      rdongle_pres;                   /* dongle present? */
-    ulong32     epr_fw_ver;                     /* (eprom) firmware version */
-    ulong32     upd_fw_ver;                     /* (update) firmware version */
-    ulong32     upd_revision;                   /* update revision */
+    u32     ser_no;                         /* serial no. */
+    u8      oem_id[2];                      /* OEM ID */
+    u16      ep_flags;                       /* eprom flags */
+    u32     proc_id;                        /* processor ID */
+    u32     memsize;                        /* memory size (bytes) */
+    u8      mem_banks;                      /* memory banks */
+    u8      chan_type;                      /* channel type */
+    u8      chan_count;                     /* channel count */
+    u8      rdongle_pres;                   /* dongle present? */
+    u32     epr_fw_ver;                     /* (eprom) firmware version */
+    u32     upd_fw_ver;                     /* (update) firmware version */
+    u32     upd_revision;                   /* update revision */
     char        type_string[16];                /* controller name */
     char        raid_string[16];                /* RAID firmware name */
-    unchar      update_pres;                    /* update present? */
-    unchar      xor_pres;                       /* XOR engine present? */
-    unchar      prom_type;                      /* ROM type (eprom/flash) */
-    unchar      prom_count;                     /* number of ROM devices */
-    ulong32     dup_pres;                       /* duplexing module present? */
-    ulong32     chan_pres;                      /* number of expansion chn. */
-    ulong32     mem_pres;                       /* memory expansion inst. ? */
-    unchar      ft_bus_system;                  /* fault bus supported? */
-    unchar      subtype_valid;                  /* board_subtype valid? */
-    unchar      board_subtype;                  /* subtype/hardware level */
-    unchar      ramparity_pres;                 /* RAM parity check hardware? */
-} PACKED gdth_binfo_str; 
+    u8      update_pres;                    /* update present? */
+    u8      xor_pres;                       /* XOR engine present? */
+    u8      prom_type;                      /* ROM type (eprom/flash) */
+    u8      prom_count;                     /* number of ROM devices */
+    u32     dup_pres;                       /* duplexing module present? */
+    u32     chan_pres;                      /* number of expansion chn. */
+    u32     mem_pres;                       /* memory expansion inst. ? */
+    u8      ft_bus_system;                  /* fault bus supported? */
+    u8      subtype_valid;                  /* board_subtype valid? */
+    u8      board_subtype;                  /* subtype/hardware level */
+    u8      ramparity_pres;                 /* RAM parity check hardware? */
+} __attribute__((packed)) gdth_binfo_str; 
 
 /* get host drive info */
 typedef struct {
     char        name[8];                        /* host drive name */
-    ulong32     size;                           /* size (sectors) */
-    unchar      host_drive;                     /* host drive number */
-    unchar      log_drive;                      /* log. drive (master) */
-    unchar      reserved;
-    unchar      rw_attribs;                     /* r/w attribs */
-    ulong32     start_sec;                      /* start sector */
-} PACKED gdth_hentry_str;
-
-typedef struct {
-    ulong32     entries;                        /* entry count */
-    ulong32     offset;                         /* offset of entries */
-    unchar      secs_p_head;                    /* sectors/head */
-    unchar      heads_p_cyl;                    /* heads/cylinder */
-    unchar      reserved;
-    unchar      clust_drvtype;                  /* cluster drive type */
-    ulong32     location;                       /* controller number */
+    u32     size;                           /* size (sectors) */
+    u8      host_drive;                     /* host drive number */
+    u8      log_drive;                      /* log. drive (master) */
+    u8      reserved;
+    u8      rw_attribs;                     /* r/w attribs */
+    u32     start_sec;                      /* start sector */
+} __attribute__((packed)) gdth_hentry_str;
+
+typedef struct {
+    u32     entries;                        /* entry count */
+    u32     offset;                         /* offset of entries */
+    u8      secs_p_head;                    /* sectors/head */
+    u8      heads_p_cyl;                    /* heads/cylinder */
+    u8      reserved;
+    u8      clust_drvtype;                  /* cluster drive type */
+    u32     location;                       /* controller number */
     gdth_hentry_str entry[MAX_HDRIVES];         /* entries */
-} PACKED gdth_hget_str;    
+} __attribute__((packed)) gdth_hget_str;    
 
 
 /* DPRAM structures */
 
 /* interface area ISA/PCI */
 typedef struct {
-    unchar              S_Cmd_Indx;             /* special command */
-    unchar volatile     S_Status;               /* status special command */
-    ushort              reserved1;
-    ulong32             S_Info[4];              /* add. info special command */
-    unchar volatile     Sema0;                  /* command semaphore */
-    unchar              reserved2[3];
-    unchar              Cmd_Index;              /* command number */
-    unchar              reserved3[3];
-    ushort volatile     Status;                 /* command status */
-    ushort              Service;                /* service(for async.events) */
-    ulong32             Info[2];                /* additional info */
+    u8              S_Cmd_Indx;             /* special command */
+    u8 volatile     S_Status;               /* status special command */
+    u16              reserved1;
+    u32             S_Info[4];              /* add. info special command */
+    u8 volatile     Sema0;                  /* command semaphore */
+    u8              reserved2[3];
+    u8              Cmd_Index;              /* command number */
+    u8              reserved3[3];
+    u16 volatile     Status;                 /* command status */
+    u16              Service;                /* service(for async.events) */
+    u32             Info[2];                /* additional info */
     struct {
-        ushort          offset;                 /* command offs. in the DPRAM*/
-        ushort          serv_id;                /* service */
-    } PACKED comm_queue[MAXOFFSETS];            /* command queue */
-    ulong32             bios_reserved[2];
-    unchar              gdt_dpr_cmd[1];         /* commands */
-} PACKED gdt_dpr_if;
+        u16          offset;                 /* command offs. in the DPRAM*/
+        u16          serv_id;                /* service */
+    } __attribute__((packed)) comm_queue[MAXOFFSETS];            /* command queue */
+    u32             bios_reserved[2];
+    u8              gdt_dpr_cmd[1];         /* commands */
+} __attribute__((packed)) gdt_dpr_if;
 
 /* SRAM structure PCI controllers */
 typedef struct {
-    ulong32     magic;                          /* controller ID from BIOS */
-    ushort      need_deinit;                    /* switch betw. BIOS/driver */
-    unchar      switch_support;                 /* see need_deinit */
-    unchar      padding[9];
-    unchar      os_used[16];                    /* OS code per service */
-    unchar      unused[28];
-    unchar      fw_magic;                       /* contr. ID from firmware */
-} PACKED gdt_pci_sram;
+    u32     magic;                          /* controller ID from BIOS */
+    u16      need_deinit;                    /* switch betw. BIOS/driver */
+    u8      switch_support;                 /* see need_deinit */
+    u8      padding[9];
+    u8      os_used[16];                    /* OS code per service */
+    u8      unused[28];
+    u8      fw_magic;                       /* contr. ID from firmware */
+} __attribute__((packed)) gdt_pci_sram;
 
 /* SRAM structure EISA controllers (but NOT GDT3000/3020) */
 typedef struct {
-    unchar      os_used[16];                    /* OS code per service */
-    ushort      need_deinit;                    /* switch betw. BIOS/driver */
-    unchar      switch_support;                 /* see need_deinit */
-    unchar      padding;
-} PACKED gdt_eisa_sram;
+    u8      os_used[16];                    /* OS code per service */
+    u16      need_deinit;                    /* switch betw. BIOS/driver */
+    u8      switch_support;                 /* see need_deinit */
+    u8      padding;
+} __attribute__((packed)) gdt_eisa_sram;
 
 
 /* DPRAM ISA controllers */
 typedef struct {
     union {
         struct {
-            unchar      bios_used[0x3c00-32];   /* 15KB - 32Bytes BIOS */
-            ulong32     magic;                  /* controller (EISA) ID */
-            ushort      need_deinit;            /* switch betw. BIOS/driver */
-            unchar      switch_support;         /* see need_deinit */
-            unchar      padding[9];
-            unchar      os_used[16];            /* OS code per service */
-        } PACKED dp_sram;
-        unchar          bios_area[0x4000];      /* 16KB reserved for BIOS */
+            u8      bios_used[0x3c00-32];   /* 15KB - 32Bytes BIOS */
+            u32     magic;                  /* controller (EISA) ID */
+            u16      need_deinit;            /* switch betw. BIOS/driver */
+            u8      switch_support;         /* see need_deinit */
+            u8      padding[9];
+            u8      os_used[16];            /* OS code per service */
+        } __attribute__((packed)) dp_sram;
+        u8          bios_area[0x4000];      /* 16KB reserved for BIOS */
     } bu;
     union {
         gdt_dpr_if      ic;                     /* interface area */
-        unchar          if_area[0x3000];        /* 12KB for interface */
+        u8          if_area[0x3000];        /* 12KB for interface */
     } u;
     struct {
-        unchar          memlock;                /* write protection DPRAM */
-        unchar          event;                  /* release event */
-        unchar          irqen;                  /* board interrupts enable */
-        unchar          irqdel;                 /* acknowledge board int. */
-        unchar volatile Sema1;                  /* status semaphore */
-        unchar          rq;                     /* IRQ/DRQ configuration */
-    } PACKED io;
-} PACKED gdt2_dpram_str;
+        u8          memlock;                /* write protection DPRAM */
+        u8          event;                  /* release event */
+        u8          irqen;                  /* board interrupts enable */
+        u8          irqdel;                 /* acknowledge board int. */
+        u8 volatile Sema1;                  /* status semaphore */
+        u8          rq;                     /* IRQ/DRQ configuration */
+    } __attribute__((packed)) io;
+} __attribute__((packed)) gdt2_dpram_str;
 
 /* DPRAM PCI controllers */
 typedef struct {
     union {
         gdt_dpr_if      ic;                     /* interface area */
-        unchar          if_area[0xff0-sizeof(gdt_pci_sram)];
+        u8          if_area[0xff0-sizeof(gdt_pci_sram)];
     } u;
     gdt_pci_sram        gdt6sr;                 /* SRAM structure */
     struct {
-        unchar          unused0[1];
-        unchar volatile Sema1;                  /* command semaphore */
-        unchar          unused1[3];
-        unchar          irqen;                  /* board interrupts enable */
-        unchar          unused2[2];
-        unchar          event;                  /* release event */
-        unchar          unused3[3];
-        unchar          irqdel;                 /* acknowledge board int. */
-        unchar          unused4[3];
-    } PACKED io;
-} PACKED gdt6_dpram_str;
+        u8          unused0[1];
+        u8 volatile Sema1;                  /* command semaphore */
+        u8          unused1[3];
+        u8          irqen;                  /* board interrupts enable */
+        u8          unused2[2];
+        u8          event;                  /* release event */
+        u8          unused3[3];
+        u8          irqdel;                 /* acknowledge board int. */
+        u8          unused4[3];
+    } __attribute__((packed)) io;
+} __attribute__((packed)) gdt6_dpram_str;
 
 /* PLX register structure (new PCI controllers) */
 typedef struct {
-    unchar              cfg_reg;        /* DPRAM cfg.(2:below 1MB,0:anywhere)*/
-    unchar              unused1[0x3f];
-    unchar volatile     sema0_reg;              /* command semaphore */
-    unchar volatile     sema1_reg;              /* status semaphore */
-    unchar              unused2[2];
-    ushort volatile     status;                 /* command status */
-    ushort              service;                /* service */
-    ulong32             info[2];                /* additional info */
-    unchar              unused3[0x10];
-    unchar              ldoor_reg;              /* PCI to local doorbell */
-    unchar              unused4[3];
-    unchar volatile     edoor_reg;              /* local to PCI doorbell */
-    unchar              unused5[3];
-    unchar              control0;               /* control0 register(unused) */
-    unchar              control1;               /* board interrupts enable */
-    unchar              unused6[0x16];
-} PACKED gdt6c_plx_regs;
+    u8              cfg_reg;        /* DPRAM cfg.(2:below 1MB,0:anywhere)*/
+    u8              unused1[0x3f];
+    u8 volatile     sema0_reg;              /* command semaphore */
+    u8 volatile     sema1_reg;              /* status semaphore */
+    u8              unused2[2];
+    u16 volatile     status;                 /* command status */
+    u16              service;                /* service */
+    u32             info[2];                /* additional info */
+    u8              unused3[0x10];
+    u8              ldoor_reg;              /* PCI to local doorbell */
+    u8              unused4[3];
+    u8 volatile     edoor_reg;              /* local to PCI doorbell */
+    u8              unused5[3];
+    u8              control0;               /* control0 register(unused) */
+    u8              control1;               /* board interrupts enable */
+    u8              unused6[0x16];
+} __attribute__((packed)) gdt6c_plx_regs;
 
 /* DPRAM new PCI controllers */
 typedef struct {
     union {
         gdt_dpr_if      ic;                     /* interface area */
-        unchar          if_area[0x4000-sizeof(gdt_pci_sram)];
+        u8          if_area[0x4000-sizeof(gdt_pci_sram)];
     } u;
     gdt_pci_sram        gdt6sr;                 /* SRAM structure */
-} PACKED gdt6c_dpram_str;
+} __attribute__((packed)) gdt6c_dpram_str;
 
 /* i960 register structure (PCI MPR controllers) */
 typedef struct {
-    unchar              unused1[16];
-    unchar volatile     sema0_reg;              /* command semaphore */
-    unchar              unused2;
-    unchar volatile     sema1_reg;              /* status semaphore */
-    unchar              unused3;
-    ushort volatile     status;                 /* command status */
-    ushort              service;                /* service */
-    ulong32             info[2];                /* additional info */
-    unchar              ldoor_reg;              /* PCI to local doorbell */
-    unchar              unused4[11];
-    unchar volatile     edoor_reg;              /* local to PCI doorbell */
-    unchar              unused5[7];
-    unchar              edoor_en_reg;           /* board interrupts enable */
-    unchar              unused6[27];
-    ulong32             unused7[939];         
-    ulong32             severity;       
+    u8              unused1[16];
+    u8 volatile     sema0_reg;              /* command semaphore */
+    u8              unused2;
+    u8 volatile     sema1_reg;              /* status semaphore */
+    u8              unused3;
+    u16 volatile     status;                 /* command status */
+    u16              service;                /* service */
+    u32             info[2];                /* additional info */
+    u8              ldoor_reg;              /* PCI to local doorbell */
+    u8              unused4[11];
+    u8 volatile     edoor_reg;              /* local to PCI doorbell */
+    u8              unused5[7];
+    u8              edoor_en_reg;           /* board interrupts enable */
+    u8              unused6[27];
+    u32             unused7[939];         
+    u32             severity;       
     char                evt_str[256];           /* event string */
-} PACKED gdt6m_i960_regs;
+} __attribute__((packed)) gdt6m_i960_regs;
 
 /* DPRAM PCI MPR controllers */
 typedef struct {
     gdt6m_i960_regs     i960r;                  /* 4KB i960 registers */
     union {
         gdt_dpr_if      ic;                     /* interface area */
-        unchar          if_area[0x3000-sizeof(gdt_pci_sram)];
+        u8          if_area[0x3000-sizeof(gdt_pci_sram)];
     } u;
     gdt_pci_sram        gdt6sr;                 /* SRAM structure */
-} PACKED gdt6m_dpram_str;
+} __attribute__((packed)) gdt6m_dpram_str;
 
 
 /* PCI resources */
 typedef struct {
     struct pci_dev      *pdev;
-    ulong               dpmem;                  /* DPRAM address */
-    ulong               io;                     /* IO address */
+    unsigned long               dpmem;                  /* DPRAM address */
+    unsigned long               io;                     /* IO address */
 } gdth_pci_str;
 
 
@@ -846,93 +846,93 @@ typedef struct {
 typedef struct {
     struct Scsi_Host    *shost;
     struct list_head    list;
-    ushort      	hanum;
-    ushort              oem_id;                 /* OEM */
-    ushort              type;                   /* controller class */
-    ulong32             stype;                  /* subtype (PCI: device ID) */
-    ushort              fw_vers;                /* firmware version */
-    ushort              cache_feat;             /* feat. cache serv. (s/g,..)*/
-    ushort              raw_feat;               /* feat. raw service (s/g,..)*/
-    ushort              screen_feat;            /* feat. raw service (s/g,..)*/
-    ushort              bmic;                   /* BMIC address (EISA) */
+    u16      	hanum;
+    u16              oem_id;                 /* OEM */
+    u16              type;                   /* controller class */
+    u32             stype;                  /* subtype (PCI: device ID) */
+    u16              fw_vers;                /* firmware version */
+    u16              cache_feat;             /* feat. cache serv. (s/g,..)*/
+    u16              raw_feat;               /* feat. raw service (s/g,..)*/
+    u16              screen_feat;            /* feat. raw service (s/g,..)*/
+    u16              bmic;                   /* BMIC address (EISA) */
     void __iomem        *brd;                   /* DPRAM address */
-    ulong32             brd_phys;               /* slot number/BIOS address */
+    u32             brd_phys;               /* slot number/BIOS address */
     gdt6c_plx_regs      *plx;                   /* PLX regs (new PCI contr.) */
     gdth_cmd_str        cmdext;
     gdth_cmd_str        *pccb;                  /* address command structure */
-    ulong32             ccb_phys;               /* phys. address */
+    u32             ccb_phys;               /* phys. address */
 #ifdef INT_COAL
     gdth_coal_status    *coal_stat;             /* buffer for coalescing int.*/
-    ulong64             coal_stat_phys;         /* phys. address */
+    u64             coal_stat_phys;         /* phys. address */
 #endif
     char                *pscratch;              /* scratch (DMA) buffer */
-    ulong64             scratch_phys;           /* phys. address */
-    unchar              scratch_busy;           /* in use? */
-    unchar              dma64_support;          /* 64-bit DMA supported? */
+    u64             scratch_phys;           /* phys. address */
+    u8              scratch_busy;           /* in use? */
+    u8              dma64_support;          /* 64-bit DMA supported? */
     gdth_msg_str        *pmsg;                  /* message buffer */
-    ulong64             msg_phys;               /* phys. address */
-    unchar              scan_mode;              /* current scan mode */
-    unchar              irq;                    /* IRQ */
-    unchar              drq;                    /* DRQ (ISA controllers) */
-    ushort              status;                 /* command status */
-    ushort              service;                /* service/firmware ver./.. */
-    ulong32             info;
-    ulong32             info2;                  /* additional info */
+    u64             msg_phys;               /* phys. address */
+    u8              scan_mode;              /* current scan mode */
+    u8              irq;                    /* IRQ */
+    u8              drq;                    /* DRQ (ISA controllers) */
+    u16              status;                 /* command status */
+    u16              service;                /* service/firmware ver./.. */
+    u32             info;
+    u32             info2;                  /* additional info */
     Scsi_Cmnd           *req_first;             /* top of request queue */
     struct {
-        unchar          present;                /* Flag: host drive present? */
-        unchar          is_logdrv;              /* Flag: log. drive (master)? */
-        unchar          is_arraydrv;            /* Flag: array drive? */
-        unchar          is_master;              /* Flag: array drive master? */
-        unchar          is_parity;              /* Flag: parity drive? */
-        unchar          is_hotfix;              /* Flag: hotfix drive? */
-        unchar          master_no;              /* number of master drive */
-        unchar          lock;                   /* drive locked? (hot plug) */
-        unchar          heads;                  /* mapping */
-        unchar          secs;
-        ushort          devtype;                /* further information */
-        ulong64         size;                   /* capacity */
-        unchar          ldr_no;                 /* log. drive no. */
-        unchar          rw_attribs;             /* r/w attributes */
-        unchar          cluster_type;           /* cluster properties */
-        unchar          media_changed;          /* Flag:MOUNT/UNMOUNT occured */
-        ulong32         start_sec;              /* start sector */
+        u8          present;                /* Flag: host drive present? */
+        u8          is_logdrv;              /* Flag: log. drive (master)? */
+        u8          is_arraydrv;            /* Flag: array drive? */
+        u8          is_master;              /* Flag: array drive master? */
+        u8          is_parity;              /* Flag: parity drive? */
+        u8          is_hotfix;              /* Flag: hotfix drive? */
+        u8          master_no;              /* number of master drive */
+        u8          lock;                   /* drive locked? (hot plug) */
+        u8          heads;                  /* mapping */
+        u8          secs;
+        u16          devtype;                /* further information */
+        u64         size;                   /* capacity */
+        u8          ldr_no;                 /* log. drive no. */
+        u8          rw_attribs;             /* r/w attributes */
+        u8          cluster_type;           /* cluster properties */
+        u8          media_changed;          /* Flag:MOUNT/UNMOUNT occured */
+        u32         start_sec;              /* start sector */
     } hdr[MAX_LDRIVES];                         /* host drives */
     struct {
-        unchar          lock;                   /* channel locked? (hot plug) */
-        unchar          pdev_cnt;               /* physical device count */
-        unchar          local_no;               /* local channel number */
-        unchar          io_cnt[MAXID];          /* current IO count */
-        ulong32         address;                /* channel address */
-        ulong32         id_list[MAXID];         /* IDs of the phys. devices */
+        u8          lock;                   /* channel locked? (hot plug) */
+        u8          pdev_cnt;               /* physical device count */
+        u8          local_no;               /* local channel number */
+        u8          io_cnt[MAXID];          /* current IO count */
+        u32         address;                /* channel address */
+        u32         id_list[MAXID];         /* IDs of the phys. devices */
     } raw[MAXBUS];                              /* SCSI channels */
     struct {
         Scsi_Cmnd       *cmnd;                  /* pending request */
-        ushort          service;                /* service */
+        u16          service;                /* service */
     } cmd_tab[GDTH_MAXCMDS];                    /* table of pend. requests */
     struct gdth_cmndinfo {                      /* per-command private info */
         int index;
         int internal_command;                   /* don't call scsi_done */
         gdth_cmd_str *internal_cmd_str;         /* crier for internal messages*/
         dma_addr_t sense_paddr;                 /* sense dma-addr */
-        unchar priority;
+        u8 priority;
 	int timeout_count;			/* # of timeout calls */
         volatile int wait_for_completion;
-        ushort status;
-        ulong32 info;
+        u16 status;
+        u32 info;
         enum dma_data_direction dma_dir;
         int phase;                              /* ???? */
         int OpCode;
     } cmndinfo[GDTH_MAXCMDS];                   /* index==0 is free */
-    unchar              bus_cnt;                /* SCSI bus count */
-    unchar              tid_cnt;                /* Target ID count */
-    unchar              bus_id[MAXBUS];         /* IOP IDs */
-    unchar              virt_bus;               /* number of virtual bus */
-    unchar              more_proc;              /* more /proc info supported */
-    ushort              cmd_cnt;                /* command count in DPRAM */
-    ushort              cmd_len;                /* length of actual command */
-    ushort              cmd_offs_dpmem;         /* actual offset in DPRAM */
-    ushort              ic_all_size;            /* sizeof DPRAM interf. area */
+    u8              bus_cnt;                /* SCSI bus count */
+    u8              tid_cnt;                /* Target ID count */
+    u8              bus_id[MAXBUS];         /* IOP IDs */
+    u8              virt_bus;               /* number of virtual bus */
+    u8              more_proc;              /* more /proc info supported */
+    u16              cmd_cnt;                /* command count in DPRAM */
+    u16              cmd_len;                /* length of actual command */
+    u16              cmd_offs_dpmem;         /* actual offset in DPRAM */
+    u16              ic_all_size;            /* sizeof DPRAM interf. area */
     gdth_cpar_str       cpar;                   /* controller cache par. */
     gdth_bfeat_str      bfeat;                  /* controller features */
     gdth_binfo_str      binfo;                  /* controller info */
@@ -941,7 +941,7 @@ typedef struct {
     struct pci_dev      *pdev;
     char                oem_name[8];
 #ifdef GDTH_DMA_STATISTICS
-    ulong               dma32_cnt, dma64_cnt;   /* statistics: DMA buffer */
+    unsigned long               dma32_cnt, dma64_cnt;   /* statistics: DMA buffer */
 #endif
     struct scsi_device         *sdev;
 } gdth_ha_str;
@@ -953,65 +953,65 @@ static inline struct gdth_cmndinfo *gdth_cmnd_priv(struct scsi_cmnd* cmd)
 
 /* INQUIRY data format */
 typedef struct {
-    unchar      type_qual;
-    unchar      modif_rmb;
-    unchar      version;
-    unchar      resp_aenc;
-    unchar      add_length;
-    unchar      reserved1;
-    unchar      reserved2;
-    unchar      misc;
-    unchar      vendor[8];
-    unchar      product[16];
-    unchar      revision[4];
-} PACKED gdth_inq_data;
+    u8      type_qual;
+    u8      modif_rmb;
+    u8      version;
+    u8      resp_aenc;
+    u8      add_length;
+    u8      reserved1;
+    u8      reserved2;
+    u8      misc;
+    u8      vendor[8];
+    u8      product[16];
+    u8      revision[4];
+} __attribute__((packed)) gdth_inq_data;
 
 /* READ_CAPACITY data format */
 typedef struct {
-    ulong32     last_block_no;
-    ulong32     block_length;
-} PACKED gdth_rdcap_data;
+    u32     last_block_no;
+    u32     block_length;
+} __attribute__((packed)) gdth_rdcap_data;
 
 /* READ_CAPACITY (16) data format */
 typedef struct {
-    ulong64     last_block_no;
-    ulong32     block_length;
-} PACKED gdth_rdcap16_data;
+    u64     last_block_no;
+    u32     block_length;
+} __attribute__((packed)) gdth_rdcap16_data;
 
 /* REQUEST_SENSE data format */
 typedef struct {
-    unchar      errorcode;
-    unchar      segno;
-    unchar      key;
-    ulong32     info;
-    unchar      add_length;
-    ulong32     cmd_info;
-    unchar      adsc;
-    unchar      adsq;
-    unchar      fruc;
-    unchar      key_spec[3];
-} PACKED gdth_sense_data;
+    u8      errorcode;
+    u8      segno;
+    u8      key;
+    u32     info;
+    u8      add_length;
+    u32     cmd_info;
+    u8      adsc;
+    u8      adsq;
+    u8      fruc;
+    u8      key_spec[3];
+} __attribute__((packed)) gdth_sense_data;
 
 /* MODE_SENSE data format */
 typedef struct {
     struct {
-        unchar  data_length;
-        unchar  med_type;
-        unchar  dev_par;
-        unchar  bd_length;
-    } PACKED hd;
+        u8  data_length;
+        u8  med_type;
+        u8  dev_par;
+        u8  bd_length;
+    } __attribute__((packed)) hd;
     struct {
-        unchar  dens_code;
-        unchar  block_count[3];
-        unchar  reserved;
-        unchar  block_length[3];
-    } PACKED bd;
-} PACKED gdth_modep_data;
+        u8  dens_code;
+        u8  block_count[3];
+        u8  reserved;
+        u8  block_length[3];
+    } __attribute__((packed)) bd;
+} __attribute__((packed)) gdth_modep_data;
 
 /* stack frame */
 typedef struct {
-    ulong       b[10];                          /* 32/64 bit compiler ! */
-} PACKED gdth_stackframe;
+    unsigned long       b[10];                          /* 32/64 bit compiler ! */
+} __attribute__((packed)) gdth_stackframe;
 
 
 /* function prototyping */
diff --git a/drivers/scsi/gdth_ioctl.h b/drivers/scsi/gdth_ioctl.h
index 783fae7..b004c61 100644
--- a/drivers/scsi/gdth_ioctl.h
+++ b/drivers/scsi/gdth_ioctl.h
@@ -32,109 +32,101 @@
 #define MAX_HDRIVES     MAX_LDRIVES             /* max. host drive count */
 #endif
 
-/* typedefs */
-#ifdef __KERNEL__
-typedef u32     ulong32;
-typedef u64     ulong64;
-#endif
-
-#define PACKED  __attribute__((packed))
-
 /* scatter/gather element */
 typedef struct {
-    ulong32     sg_ptr;                         /* address */
-    ulong32     sg_len;                         /* length */
-} PACKED gdth_sg_str;
+    u32     sg_ptr;                         /* address */
+    u32     sg_len;                         /* length */
+} __attribute__((packed)) gdth_sg_str;
 
 /* scatter/gather element - 64bit addresses */
 typedef struct {
-    ulong64     sg_ptr;                         /* address */
-    ulong32     sg_len;                         /* length */
-} PACKED gdth_sg64_str;
+    u64     sg_ptr;                         /* address */
+    u32     sg_len;                         /* length */
+} __attribute__((packed)) gdth_sg64_str;
 
 /* command structure */
 typedef struct {
-    ulong32     BoardNode;                      /* board node (always 0) */
-    ulong32     CommandIndex;                   /* command number */
-    ushort      OpCode;                         /* the command (READ,..) */
+    u32     BoardNode;                      /* board node (always 0) */
+    u32     CommandIndex;                   /* command number */
+    u16      OpCode;                         /* the command (READ,..) */
     union {
         struct {
-            ushort      DeviceNo;               /* number of cache drive */
-            ulong32     BlockNo;                /* block number */
-            ulong32     BlockCnt;               /* block count */
-            ulong32     DestAddr;               /* dest. addr. (if s/g: -1) */
-            ulong32     sg_canz;                /* s/g element count */
+            u16      DeviceNo;               /* number of cache drive */
+            u32     BlockNo;                /* block number */
+            u32     BlockCnt;               /* block count */
+            u32     DestAddr;               /* dest. addr. (if s/g: -1) */
+            u32     sg_canz;                /* s/g element count */
             gdth_sg_str sg_lst[GDTH_MAXSG];     /* s/g list */
-        } PACKED cache;                         /* cache service cmd. str. */
+        } __attribute__((packed)) cache;                         /* cache service cmd. str. */
         struct {
-            ushort      DeviceNo;               /* number of cache drive */
-            ulong64     BlockNo;                /* block number */
-            ulong32     BlockCnt;               /* block count */
-            ulong64     DestAddr;               /* dest. addr. (if s/g: -1) */
-            ulong32     sg_canz;                /* s/g element count */
+            u16      DeviceNo;               /* number of cache drive */
+            u64     BlockNo;                /* block number */
+            u32     BlockCnt;               /* block count */
+            u64     DestAddr;               /* dest. addr. (if s/g: -1) */
+            u32     sg_canz;                /* s/g element count */
             gdth_sg64_str sg_lst[GDTH_MAXSG];   /* s/g list */
-        } PACKED cache64;                       /* cache service cmd. str. */
+        } __attribute__((packed)) cache64;                       /* cache service cmd. str. */
         struct {
-            ushort      param_size;             /* size of p_param buffer */
-            ulong32     subfunc;                /* IOCTL function */
-            ulong32     channel;                /* device */
-            ulong64     p_param;                /* buffer */
-        } PACKED ioctl;                         /* IOCTL command structure */
+            u16      param_size;             /* size of p_param buffer */
+            u32     subfunc;                /* IOCTL function */
+            u32     channel;                /* device */
+            u64     p_param;                /* buffer */
+        } __attribute__((packed)) ioctl;                         /* IOCTL command structure */
         struct {
-            ushort      reserved;
+            u16      reserved;
             union {
                 struct {
-                    ulong32  msg_handle;        /* message handle */
-                    ulong64  msg_addr;          /* message buffer address */
-                } PACKED msg;
-                unchar       data[12];          /* buffer for rtc data, ... */
+                    u32  msg_handle;        /* message handle */
+                    u64  msg_addr;          /* message buffer address */
+                } __attribute__((packed)) msg;
+                u8       data[12];          /* buffer for rtc data, ... */
             } su;
-        } PACKED screen;                        /* screen service cmd. str. */
+        } __attribute__((packed)) screen;                        /* screen service cmd. str. */
         struct {
-            ushort      reserved;
-            ulong32     direction;              /* data direction */
-            ulong32     mdisc_time;             /* disc. time (0: no timeout)*/
-            ulong32     mcon_time;              /* connect time(0: no to.) */
-            ulong32     sdata;                  /* dest. addr. (if s/g: -1) */
-            ulong32     sdlen;                  /* data length (bytes) */
-            ulong32     clen;                   /* SCSI cmd. length(6,10,12) */
-            unchar      cmd[12];                /* SCSI command */
-            unchar      target;                 /* target ID */
-            unchar      lun;                    /* LUN */
-            unchar      bus;                    /* SCSI bus number */
-            unchar      priority;               /* only 0 used */
-            ulong32     sense_len;              /* sense data length */
-            ulong32     sense_data;             /* sense data addr. */
-            ulong32     link_p;                 /* linked cmds (not supp.) */
-            ulong32     sg_ranz;                /* s/g element count */
+            u16      reserved;
+            u32     direction;              /* data direction */
+            u32     mdisc_time;             /* disc. time (0: no timeout)*/
+            u32     mcon_time;              /* connect time(0: no to.) */
+            u32     sdata;                  /* dest. addr. (if s/g: -1) */
+            u32     sdlen;                  /* data length (bytes) */
+            u32     clen;                   /* SCSI cmd. length(6,10,12) */
+            u8      cmd[12];                /* SCSI command */
+            u8      target;                 /* target ID */
+            u8      lun;                    /* LUN */
+            u8      bus;                    /* SCSI bus number */
+            u8      priority;               /* only 0 used */
+            u32     sense_len;              /* sense data length */
+            u32     sense_data;             /* sense data addr. */
+            u32     link_p;                 /* linked cmds (not supp.) */
+            u32     sg_ranz;                /* s/g element count */
             gdth_sg_str sg_lst[GDTH_MAXSG];     /* s/g list */
-        } PACKED raw;                           /* raw service cmd. struct. */
+        } __attribute__((packed)) raw;                           /* raw service cmd. struct. */
         struct {
-            ushort      reserved;
-            ulong32     direction;              /* data direction */
-            ulong32     mdisc_time;             /* disc. time (0: no timeout)*/
-            ulong32     mcon_time;              /* connect time(0: no to.) */
-            ulong64     sdata;                  /* dest. addr. (if s/g: -1) */
-            ulong32     sdlen;                  /* data length (bytes) */
-            ulong32     clen;                   /* SCSI cmd. length(6,..,16) */
-            unchar      cmd[16];                /* SCSI command */
-            unchar      target;                 /* target ID */
-            unchar      lun;                    /* LUN */
-            unchar      bus;                    /* SCSI bus number */
-            unchar      priority;               /* only 0 used */
-            ulong32     sense_len;              /* sense data length */
-            ulong64     sense_data;             /* sense data addr. */
-            ulong32     sg_ranz;                /* s/g element count */
+            u16      reserved;
+            u32     direction;              /* data direction */
+            u32     mdisc_time;             /* disc. time (0: no timeout)*/
+            u32     mcon_time;              /* connect time(0: no to.) */
+            u64     sdata;                  /* dest. addr. (if s/g: -1) */
+            u32     sdlen;                  /* data length (bytes) */
+            u32     clen;                   /* SCSI cmd. length(6,..,16) */
+            u8      cmd[16];                /* SCSI command */
+            u8      target;                 /* target ID */
+            u8      lun;                    /* LUN */
+            u8      bus;                    /* SCSI bus number */
+            u8      priority;               /* only 0 used */
+            u32     sense_len;              /* sense data length */
+            u64     sense_data;             /* sense data addr. */
+            u32     sg_ranz;                /* s/g element count */
             gdth_sg64_str sg_lst[GDTH_MAXSG];   /* s/g list */
-        } PACKED raw64;                         /* raw service cmd. struct. */
+        } __attribute__((packed)) raw64;                         /* raw service cmd. struct. */
     } u;
     /* additional variables */
-    unchar      Service;                        /* controller service */
-    unchar      reserved;
-    ushort      Status;                         /* command result */
-    ulong32     Info;                           /* additional information */
+    u8      Service;                        /* controller service */
+    u8      reserved;
+    u16      Status;                         /* command result */
+    u32     Info;                           /* additional information */
     void        *RequestBuffer;                 /* request buffer */
-} PACKED gdth_cmd_str;
+} __attribute__((packed)) gdth_cmd_str;
 
 /* controller event structure */
 #define ES_ASYNC    1
@@ -142,129 +134,129 @@ typedef struct {
 #define ES_TEST     3
 #define ES_SYNC     4
 typedef struct {
-    ushort                  size;               /* size of structure */
+    u16                  size;               /* size of structure */
     union {
         char                stream[16];
         struct {
-            ushort          ionode;
-            ushort          service;
-            ulong32         index;
-        } PACKED driver;
+            u16          ionode;
+            u16          service;
+            u32         index;
+        } __attribute__((packed)) driver;
         struct {
-            ushort          ionode;
-            ushort          service;
-            ushort          status;
-            ulong32         info;
-            unchar          scsi_coord[3];
-        } PACKED async;
+            u16          ionode;
+            u16          service;
+            u16          status;
+            u32         info;
+            u8          scsi_coord[3];
+        } __attribute__((packed)) async;
         struct {
-            ushort          ionode;
-            ushort          service;
-            ushort          status;
-            ulong32         info;
-            ushort          hostdrive;
-            unchar          scsi_coord[3];
-            unchar          sense_key;
-        } PACKED sync;
+            u16          ionode;
+            u16          service;
+            u16          status;
+            u32         info;
+            u16          hostdrive;
+            u8          scsi_coord[3];
+            u8          sense_key;
+        } __attribute__((packed)) sync;
         struct {
-            ulong32         l1, l2, l3, l4;
-        } PACKED test;
+            u32         l1, l2, l3, l4;
+        } __attribute__((packed)) test;
     } eu;
-    ulong32                 severity;
-    unchar                  event_string[256];          
-} PACKED gdth_evt_data;
+    u32                 severity;
+    u8                  event_string[256];          
+} __attribute__((packed)) gdth_evt_data;
 
 typedef struct {
-    ulong32         first_stamp;
-    ulong32         last_stamp;
-    ushort          same_count;
-    ushort          event_source;
-    ushort          event_idx;
-    unchar          application;
-    unchar          reserved;
+    u32         first_stamp;
+    u32         last_stamp;
+    u16          same_count;
+    u16          event_source;
+    u16          event_idx;
+    u8          application;
+    u8          reserved;
     gdth_evt_data   event_data;
-} PACKED gdth_evt_str;
+} __attribute__((packed)) gdth_evt_str;
 
 
 #ifdef GDTH_IOCTL_PROC
 /* IOCTL structure (write) */
 typedef struct {
-    ulong32                 magic;              /* IOCTL magic */
-    ushort                  ioctl;              /* IOCTL */
-    ushort                  ionode;             /* controller number */
-    ushort                  service;            /* controller service */
-    ushort                  timeout;            /* timeout */
+    u32                 magic;              /* IOCTL magic */
+    u16                  ioctl;              /* IOCTL */
+    u16                  ionode;             /* controller number */
+    u16                  service;            /* controller service */
+    u16                  timeout;            /* timeout */
     union {
         struct {
-            unchar          command[512];       /* controller command */
-            unchar          data[1];            /* add. data */
+            u8          command[512];       /* controller command */
+            u8          data[1];            /* add. data */
         } general;
         struct {
-            unchar          lock;               /* lock/unlock */
-            unchar          drive_cnt;          /* drive count */
-            ushort          drives[MAX_HDRIVES];/* drives */
+            u8          lock;               /* lock/unlock */
+            u8          drive_cnt;          /* drive count */
+            u16          drives[MAX_HDRIVES];/* drives */
         } lockdrv;
         struct {
-            unchar          lock;               /* lock/unlock */
-            unchar          channel;            /* channel */
+            u8          lock;               /* lock/unlock */
+            u8          channel;            /* channel */
         } lockchn;
         struct {
             int             erase;              /* erase event ? */
             int             handle;
-            unchar          evt[EVENT_SIZE];    /* event structure */
+            u8          evt[EVENT_SIZE];    /* event structure */
         } event;
         struct {
-            unchar          bus;                /* SCSI bus */
-            unchar          target;             /* target ID */
-            unchar          lun;                /* LUN */
-            unchar          cmd_len;            /* command length */
-            unchar          cmd[12];            /* SCSI command */
+            u8          bus;                /* SCSI bus */
+            u8          target;             /* target ID */
+            u8          lun;                /* LUN */
+            u8          cmd_len;            /* command length */
+            u8          cmd[12];            /* SCSI command */
         } scsi;
         struct {
-            ushort          hdr_no;             /* host drive number */
-            unchar          flag;               /* old meth./add/remove */
+            u16          hdr_no;             /* host drive number */
+            u8          flag;               /* old meth./add/remove */
         } rescan;
     } iu;
 } gdth_iowr_str;
 
 /* IOCTL structure (read) */
 typedef struct {
-    ulong32                 size;               /* buffer size */
-    ulong32                 status;             /* IOCTL error code */
+    u32                 size;               /* buffer size */
+    u32                 status;             /* IOCTL error code */
     union {
         struct {
-            unchar          data[1];            /* data */
+            u8          data[1];            /* data */
         } general;
         struct {
-            ushort          version;            /* driver version */
+            u16          version;            /* driver version */
         } drvers;
         struct {
-            unchar          type;               /* controller type */
-            ushort          info;               /* slot etc. */
-            ushort          oem_id;             /* OEM ID */
-            ushort          bios_ver;           /* not used */
-            ushort          access;             /* not used */
-            ushort          ext_type;           /* extended type */
-            ushort          device_id;          /* device ID */
-            ushort          sub_device_id;      /* sub device ID */
+            u8          type;               /* controller type */
+            u16          info;               /* slot etc. */
+            u16          oem_id;             /* OEM ID */
+            u16          bios_ver;           /* not used */
+            u16          access;             /* not used */
+            u16          ext_type;           /* extended type */
+            u16          device_id;          /* device ID */
+            u16          sub_device_id;      /* sub device ID */
         } ctrtype;
         struct {
-            unchar          version;            /* OS version */
-            unchar          subversion;         /* OS subversion */
-            ushort          revision;           /* revision */
+            u8          version;            /* OS version */
+            u8          subversion;         /* OS subversion */
+            u16          revision;           /* revision */
         } osvers;
         struct {
-            ushort          count;              /* controller count */
+            u16          count;              /* controller count */
         } ctrcnt;
         struct {
             int             handle;
-            unchar          evt[EVENT_SIZE];    /* event structure */
+            u8          evt[EVENT_SIZE];    /* event structure */
         } event;
         struct {
-            unchar          bus;                /* SCSI bus, 0xff: invalid */
-            unchar          target;             /* target ID */
-            unchar          lun;                /* LUN */
-            unchar          cluster_type;       /* cluster properties */
+            u8          bus;                /* SCSI bus, 0xff: invalid */
+            u8          target;             /* target ID */
+            u8          lun;                /* LUN */
+            u8          cluster_type;       /* cluster properties */
         } hdr_list[MAX_HDRIVES];                /* index is host drive number */
     } iu;
 } gdth_iord_str;
@@ -272,53 +264,53 @@ typedef struct {
 
 /* GDTIOCTL_GENERAL */
 typedef struct {
-    ushort ionode;                              /* controller number */
-    ushort timeout;                             /* timeout */
-    ulong32 info;                               /* error info */ 
-    ushort status;                              /* status */
-    ulong data_len;                             /* data buffer size */
-    ulong sense_len;                            /* sense buffer size */
+    u16 ionode;                              /* controller number */
+    u16 timeout;                             /* timeout */
+    u32 info;                               /* error info */ 
+    u16 status;                              /* status */
+    unsigned long data_len;                             /* data buffer size */
+    unsigned long sense_len;                            /* sense buffer size */
     gdth_cmd_str command;                       /* command */                   
 } gdth_ioctl_general;
 
 /* GDTIOCTL_LOCKDRV */
 typedef struct {
-    ushort ionode;                              /* controller number */
-    unchar lock;                                /* lock/unlock */
-    unchar drive_cnt;                           /* drive count */
-    ushort drives[MAX_HDRIVES];                 /* drives */
+    u16 ionode;                              /* controller number */
+    u8 lock;                                /* lock/unlock */
+    u8 drive_cnt;                           /* drive count */
+    u16 drives[MAX_HDRIVES];                 /* drives */
 } gdth_ioctl_lockdrv;
 
 /* GDTIOCTL_LOCKCHN */
 typedef struct {
-    ushort ionode;                              /* controller number */
-    unchar lock;                                /* lock/unlock */
-    unchar channel;                             /* channel */
+    u16 ionode;                              /* controller number */
+    u8 lock;                                /* lock/unlock */
+    u8 channel;                             /* channel */
 } gdth_ioctl_lockchn;
 
 /* GDTIOCTL_OSVERS */
 typedef struct {
-    unchar version;                             /* OS version */
-    unchar subversion;                          /* OS subversion */
-    ushort revision;                            /* revision */
+    u8 version;                             /* OS version */
+    u8 subversion;                          /* OS subversion */
+    u16 revision;                            /* revision */
 } gdth_ioctl_osvers;
 
 /* GDTIOCTL_CTRTYPE */
 typedef struct {
-    ushort ionode;                              /* controller number */
-    unchar type;                                /* controller type */
-    ushort info;                                /* slot etc. */
-    ushort oem_id;                              /* OEM ID */
-    ushort bios_ver;                            /* not used */
-    ushort access;                              /* not used */
-    ushort ext_type;                            /* extended type */
-    ushort device_id;                           /* device ID */
-    ushort sub_device_id;                       /* sub device ID */
+    u16 ionode;                              /* controller number */
+    u8 type;                                /* controller type */
+    u16 info;                                /* slot etc. */
+    u16 oem_id;                              /* OEM ID */
+    u16 bios_ver;                            /* not used */
+    u16 access;                              /* not used */
+    u16 ext_type;                            /* extended type */
+    u16 device_id;                           /* device ID */
+    u16 sub_device_id;                       /* sub device ID */
 } gdth_ioctl_ctrtype;
 
 /* GDTIOCTL_EVENT */
 typedef struct {
-    ushort ionode;
+    u16 ionode;
     int erase;                                  /* erase event? */
     int handle;                                 /* event handle */
     gdth_evt_str event;
@@ -326,22 +318,22 @@ typedef struct {
 
 /* GDTIOCTL_RESCAN/GDTIOCTL_HDRLIST */
 typedef struct {
-    ushort ionode;                              /* controller number */
-    unchar flag;                                /* add/remove */
-    ushort hdr_no;                              /* drive no. */
+    u16 ionode;                              /* controller number */
+    u8 flag;                                /* add/remove */
+    u16 hdr_no;                              /* drive no. */
     struct {
-        unchar bus;                             /* SCSI bus */
-        unchar target;                          /* target ID */
-        unchar lun;                             /* LUN */
-        unchar cluster_type;                    /* cluster properties */
+        u8 bus;                             /* SCSI bus */
+        u8 target;                          /* target ID */
+        u8 lun;                             /* LUN */
+        u8 cluster_type;                    /* cluster properties */
     } hdr_list[MAX_HDRIVES];                    /* index is host drive number */
 } gdth_ioctl_rescan;
 
 /* GDTIOCTL_RESET_BUS/GDTIOCTL_RESET_DRV */
 typedef struct {
-    ushort ionode;                              /* controller number */
-    ushort number;                              /* bus/host drive number */
-    ushort status;                              /* status */
+    u16 ionode;                              /* controller number */
+    u16 number;                              /* bus/host drive number */
+    u16 status;                              /* status */
 } gdth_ioctl_reset;
 
 #endif
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 1258da3..ffb2b21 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -43,7 +43,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
     int i, found;
     gdth_cmd_str    gdtcmd;
     gdth_cpar_str   *pcpar;
-    ulong64         paddr;
+    u64         paddr;
 
     char            cmnd[MAX_COMMAND_SIZE];
     memset(cmnd, 0xff, 12);
@@ -156,8 +156,8 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     off_t begin = 0,pos = 0;
     int id, i, j, k, sec, flag;
     int no_mdrv = 0, drv_no, is_mirr;
-    ulong32 cnt;
-    ulong64 paddr;
+    u32 cnt;
+    u64 paddr;
     int rc = -ENOMEM;
 
     gdth_cmd_str *gdtcmd;
@@ -220,14 +220,14 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
 
     if (ha->more_proc)
         sprintf(hrec, "%d.%02d.%02d-%c%03X", 
-                (unchar)(ha->binfo.upd_fw_ver>>24),
-                (unchar)(ha->binfo.upd_fw_ver>>16),
-                (unchar)(ha->binfo.upd_fw_ver),
+                (u8)(ha->binfo.upd_fw_ver>>24),
+                (u8)(ha->binfo.upd_fw_ver>>16),
+                (u8)(ha->binfo.upd_fw_ver),
                 ha->bfeat.raid ? 'R':'N',
                 ha->binfo.upd_revision);
     else
-        sprintf(hrec, "%d.%02d", (unchar)(ha->cpar.version>>8),
-                (unchar)(ha->cpar.version));
+        sprintf(hrec, "%d.%02d", (u8)(ha->cpar.version>>8),
+                (u8)(ha->cpar.version));
 
     size = sprintf(buffer+len,
                    " Driver Ver.:  \t%-10s\tFirmware Ver.: \t%s\n",
@@ -281,7 +281,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             pds->bid = ha->raw[i].local_no;
             pds->first = 0;
             pds->entries = ha->raw[i].pdev_cnt;
-            cnt = (3*GDTH_SCRATCH/4 - 5 * sizeof(ulong32)) /
+            cnt = (3*GDTH_SCRATCH/4 - 5 * sizeof(u32)) /
                 sizeof(pds->list[0]);
             if (pds->entries > cnt)
                 pds->entries = cnt;
@@ -604,7 +604,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
 
             size = sprintf(buffer+len,
                            " Capacity [MB]:\t%-6d    \tStart Sector:  \t%d\n",
-                           (ulong32)(ha->hdr[i].size/2048), ha->hdr[i].start_sec);
+                           (u32)(ha->hdr[i].size/2048), ha->hdr[i].start_sec);
             len += size;  pos = begin + len;
             if (pos < offset) {
                 len = 0;
@@ -664,9 +664,9 @@ free_fail:
 }
 
 static char *gdth_ioctl_alloc(gdth_ha_str *ha, int size, int scratch,
-                              ulong64 *paddr)
+                              u64 *paddr)
 {
-    ulong flags;
+    unsigned long flags;
     char *ret_val;
 
     if (size == 0)
@@ -691,9 +691,9 @@ static char *gdth_ioctl_alloc(gdth_ha_str *ha, int size, int scratch,
     return ret_val;
 }
 
-static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr)
+static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, u64 paddr)
 {
-    ulong flags;
+    unsigned long flags;
 
     if (buf == ha->pscratch) {
 	spin_lock_irqsave(&ha->smp_lock, flags);
@@ -705,16 +705,16 @@ static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr)
 }
 
 #ifdef GDTH_IOCTL_PROC
-static int gdth_ioctl_check_bin(gdth_ha_str *ha, ushort size)
+static int gdth_ioctl_check_bin(gdth_ha_str *ha, u16 size)
 {
-    ulong flags;
+    unsigned long flags;
     int ret_val;
 
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     ret_val = FALSE;
     if (ha->scratch_busy) {
-        if (((gdth_iord_str *)ha->pscratch)->size == (ulong32)size)
+        if (((gdth_iord_str *)ha->pscratch)->size == (u32)size)
             ret_val = TRUE;
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -724,11 +724,11 @@ static int gdth_ioctl_check_bin(gdth_ha_str *ha, ushort size)
 
 static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
-    ulong flags;
+    unsigned long flags;
     int i;
     Scsi_Cmnd *scp;
     struct gdth_cmndinfo *cmndinfo;
-    unchar b, t;
+    u8 b, t;
 
     spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -738,8 +738,8 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 
         b = scp->device->channel;
         t = scp->device->id;
-        if (!SPECIAL_SCP(scp) && t == (unchar)id && 
-            b == (unchar)busnum) {
+        if (!SPECIAL_SCP(scp) && t == (u8)id && 
+            b == (u8)busnum) {
             cmndinfo->wait_for_completion = 0;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
             while (!cmndinfo->wait_for_completion)
diff --git a/drivers/scsi/gdth_proc.h b/drivers/scsi/gdth_proc.h
index 9b900cc..dab15f5 100644
--- a/drivers/scsi/gdth_proc.h
+++ b/drivers/scsi/gdth_proc.h
@@ -17,8 +17,8 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
                              int length, gdth_ha_str *ha);
 
 static char *gdth_ioctl_alloc(gdth_ha_str *ha, int size, int scratch,
-                              ulong64 *paddr);
-static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr);
+                              u64 *paddr);
+static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, u64 paddr);
 static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id);
 
 #endif
