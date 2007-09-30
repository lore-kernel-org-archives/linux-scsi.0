From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/16] gdth: kill gdth_{read,write}[bwl] wrappers
Date: Sun, 30 Sep 2007 21:58:10 +0200
Message-ID: <46FFFFD2.2010604@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa2.bezeqint.net ([192.115.104.16]:40998 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXI3T6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 15:58:17 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  They are direct equivalents to {read,write}[bwl].

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/scsi/gdth.c |  313 +++++++++++++++++++++++++--------------------------
 1 files changed, 153 insertions(+), 160 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d0b2530..c911ebc 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -303,13 +303,6 @@ static struct timer_list gdth_timer;
 
 #define BUS_L2P(a,b)    ((b)>(a)->virt_bus ? (b-1):(b))
 
-#define gdth_readb(addr)        readb(addr)
-#define gdth_readw(addr)        readw(addr)
-#define gdth_readl(addr)        readl(addr)
-#define gdth_writeb(b,addr)     writeb((b),(addr))
-#define gdth_writew(b,addr)     writew((b),(addr))
-#define gdth_writel(b,addr)     writel((b),(addr))
-
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 static unchar   gdth_polling;                           /* polling if TRUE */
@@ -515,7 +508,7 @@ static int __init gdth_search_isa(ulong32 bios_adr)
 
     TRACE(("gdth_search_isa() bios adr. %x\n",bios_adr));
     if ((addr = ioremap(bios_adr+BIOS_ID_OFFS, sizeof(ulong32))) != NULL) {
-        id = gdth_readl(addr);
+        id = readl(addr);
         iounmap(addr);
         if (id == GDT2_ID)                          /* GDT2000 */
             return 1;
@@ -749,22 +742,22 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
         return 0;
     }
     dp2_ptr = ha->brd;
-    gdth_writeb(1, &dp2_ptr->io.memlock); /* switch off write protection */
+    writeb(1, &dp2_ptr->io.memlock); /* switch off write protection */
     /* reset interface area */
     memset_io(&dp2_ptr->u, 0, sizeof(dp2_ptr->u));
-    if (gdth_readl(&dp2_ptr->u) != 0) {
+    if (readl(&dp2_ptr->u) != 0) {
         printk("GDT-ISA: Initialization error (DPMEM write error)\n");
         iounmap(ha->brd);
         return 0;
     }
 
     /* disable board interrupts, read DRQ and IRQ */
-    gdth_writeb(0xff, &dp2_ptr->io.irqdel);
-    gdth_writeb(0x00, &dp2_ptr->io.irqen);
-    gdth_writeb(0x00, &dp2_ptr->u.ic.S_Status);
-    gdth_writeb(0x00, &dp2_ptr->u.ic.Cmd_Index);
+    writeb(0xff, &dp2_ptr->io.irqdel);
+    writeb(0x00, &dp2_ptr->io.irqen);
+    writeb(0x00, &dp2_ptr->u.ic.S_Status);
+    writeb(0x00, &dp2_ptr->u.ic.Cmd_Index);
 
-    irq_drq = gdth_readb(&dp2_ptr->io.rq);
+    irq_drq = readb(&dp2_ptr->io.rq);
     for (i=0; i<3; ++i) {
         if ((irq_drq & 1)==0)
             break;
@@ -772,7 +765,7 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
     }
     ha->drq = gdth_drq_tab[i];
 
-    irq_drq = gdth_readb(&dp2_ptr->io.rq) >> 3;
+    irq_drq = readb(&dp2_ptr->io.rq) >> 3;
     for (i=1; i<5; ++i) {
         if ((irq_drq & 1)==0)
             break;
@@ -781,12 +774,12 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
     ha->irq = gdth_irq_tab[i];
 
     /* deinitialize services */
-    gdth_writel(bios_adr, &dp2_ptr->u.ic.S_Info[0]);
-    gdth_writeb(0xff, &dp2_ptr->u.ic.S_Cmd_Indx);
-    gdth_writeb(0, &dp2_ptr->io.event);
+    writel(bios_adr, &dp2_ptr->u.ic.S_Info[0]);
+    writeb(0xff, &dp2_ptr->u.ic.S_Cmd_Indx);
+    writeb(0, &dp2_ptr->io.event);
     retries = INIT_RETRIES;
     gdth_delay(20);
-    while (gdth_readb(&dp2_ptr->u.ic.S_Status) != 0xff) {
+    while (readb(&dp2_ptr->u.ic.S_Status) != 0xff) {
         if (--retries == 0) {
             printk("GDT-ISA: Initialization error (DEINIT failed)\n");
             iounmap(ha->brd);
@@ -794,9 +787,9 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
         }
         gdth_delay(1);
     }
-    prot_ver = (unchar)gdth_readl(&dp2_ptr->u.ic.S_Info[0]);
-    gdth_writeb(0, &dp2_ptr->u.ic.Status);
-    gdth_writeb(0xff, &dp2_ptr->io.irqdel);
+    prot_ver = (unchar)readl(&dp2_ptr->u.ic.S_Info[0]);
+    writeb(0, &dp2_ptr->u.ic.Status);
+    writeb(0xff, &dp2_ptr->io.irqdel);
     if (prot_ver != PROTOCOL_VERSION) {
         printk("GDT-ISA: Illegal protocol version\n");
         iounmap(ha->brd);
@@ -810,15 +803,15 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
     ha->brd_phys = bios_adr >> 4;
 
     /* special request to controller BIOS */
-    gdth_writel(0x00, &dp2_ptr->u.ic.S_Info[0]);
-    gdth_writel(0x00, &dp2_ptr->u.ic.S_Info[1]);
-    gdth_writel(0x01, &dp2_ptr->u.ic.S_Info[2]);
-    gdth_writel(0x00, &dp2_ptr->u.ic.S_Info[3]);
-    gdth_writeb(0xfe, &dp2_ptr->u.ic.S_Cmd_Indx);
-    gdth_writeb(0, &dp2_ptr->io.event);
+    writel(0x00, &dp2_ptr->u.ic.S_Info[0]);
+    writel(0x00, &dp2_ptr->u.ic.S_Info[1]);
+    writel(0x01, &dp2_ptr->u.ic.S_Info[2]);
+    writel(0x00, &dp2_ptr->u.ic.S_Info[3]);
+    writeb(0xfe, &dp2_ptr->u.ic.S_Cmd_Indx);
+    writeb(0, &dp2_ptr->io.event);
     retries = INIT_RETRIES;
     gdth_delay(20);
-    while (gdth_readb(&dp2_ptr->u.ic.S_Status) != 0xfe) {
+    while (readb(&dp2_ptr->u.ic.S_Status) != 0xfe) {
         if (--retries == 0) {
             printk("GDT-ISA: Initialization error\n");
             iounmap(ha->brd);
@@ -826,8 +819,8 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
         }
         gdth_delay(1);
     }
-    gdth_writeb(0, &dp2_ptr->u.ic.Status);
-    gdth_writeb(0xff, &dp2_ptr->io.irqdel);
+    writeb(0, &dp2_ptr->u.ic.Status);
+    writeb(0xff, &dp2_ptr->io.irqdel);
 
     ha->dma64_support = 0;
     return 1;
@@ -864,8 +857,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         }
         /* check and reset interface area */
         dp6_ptr = ha->brd;
-        gdth_writel(DPMEM_MAGIC, &dp6_ptr->u);
-        if (gdth_readl(&dp6_ptr->u) != DPMEM_MAGIC) {
+        writel(DPMEM_MAGIC, &dp6_ptr->u);
+        if (readl(&dp6_ptr->u) != DPMEM_MAGIC) {
             printk("GDT-PCI: Cannot access DPMEM at 0x%lx (shadowed?)\n", 
                    pcistr->dpmem);
             found = FALSE;
@@ -876,7 +869,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
                     return 0;
                 }
-                if (gdth_readw(ha->brd) != 0xffff) {
+                if (readw(ha->brd) != 0xffff) {
                     TRACE2(("init_pci_old() address 0x%x busy\n", i));
                     continue;
                 }
@@ -889,8 +882,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     return 0;
                 }
                 dp6_ptr = ha->brd;
-                gdth_writel(DPMEM_MAGIC, &dp6_ptr->u);
-                if (gdth_readl(&dp6_ptr->u) == DPMEM_MAGIC) {
+                writel(DPMEM_MAGIC, &dp6_ptr->u);
+                if (readl(&dp6_ptr->u) == DPMEM_MAGIC) {
                     printk("GDT-PCI: Use free address at 0x%x\n", i);
                     found = TRUE;
                     break;
@@ -903,24 +896,24 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
         }
         memset_io(&dp6_ptr->u, 0, sizeof(dp6_ptr->u));
-        if (gdth_readl(&dp6_ptr->u) != 0) {
+        if (readl(&dp6_ptr->u) != 0) {
             printk("GDT-PCI: Initialization error (DPMEM write error)\n");
             iounmap(ha->brd);
             return 0;
         }
         
         /* disable board interrupts, deinit services */
-        gdth_writeb(0xff, &dp6_ptr->io.irqdel);
-        gdth_writeb(0x00, &dp6_ptr->io.irqen);
-        gdth_writeb(0x00, &dp6_ptr->u.ic.S_Status);
-        gdth_writeb(0x00, &dp6_ptr->u.ic.Cmd_Index);
-
-        gdth_writel(pcistr->dpmem, &dp6_ptr->u.ic.S_Info[0]);
-        gdth_writeb(0xff, &dp6_ptr->u.ic.S_Cmd_Indx);
-        gdth_writeb(0, &dp6_ptr->io.event);
+        writeb(0xff, &dp6_ptr->io.irqdel);
+        writeb(0x00, &dp6_ptr->io.irqen);
+        writeb(0x00, &dp6_ptr->u.ic.S_Status);
+        writeb(0x00, &dp6_ptr->u.ic.Cmd_Index);
+
+        writel(pcistr->dpmem, &dp6_ptr->u.ic.S_Info[0]);
+        writeb(0xff, &dp6_ptr->u.ic.S_Cmd_Indx);
+        writeb(0, &dp6_ptr->io.event);
         retries = INIT_RETRIES;
         gdth_delay(20);
-        while (gdth_readb(&dp6_ptr->u.ic.S_Status) != 0xff) {
+        while (readb(&dp6_ptr->u.ic.S_Status) != 0xff) {
             if (--retries == 0) {
                 printk("GDT-PCI: Initialization error (DEINIT failed)\n");
                 iounmap(ha->brd);
@@ -928,9 +921,9 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)gdth_readl(&dp6_ptr->u.ic.S_Info[0]);
-        gdth_writeb(0, &dp6_ptr->u.ic.S_Status);
-        gdth_writeb(0xff, &dp6_ptr->io.irqdel);
+        prot_ver = (unchar)readl(&dp6_ptr->u.ic.S_Info[0]);
+        writeb(0, &dp6_ptr->u.ic.S_Status);
+        writeb(0xff, &dp6_ptr->io.irqdel);
         if (prot_ver != PROTOCOL_VERSION) {
             printk("GDT-PCI: Illegal protocol version\n");
             iounmap(ha->brd);
@@ -941,15 +934,15 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         ha->ic_all_size = sizeof(dp6_ptr->u);
         
         /* special command to controller BIOS */
-        gdth_writel(0x00, &dp6_ptr->u.ic.S_Info[0]);
-        gdth_writel(0x00, &dp6_ptr->u.ic.S_Info[1]);
-        gdth_writel(0x00, &dp6_ptr->u.ic.S_Info[2]);
-        gdth_writel(0x00, &dp6_ptr->u.ic.S_Info[3]);
-        gdth_writeb(0xfe, &dp6_ptr->u.ic.S_Cmd_Indx);
-        gdth_writeb(0, &dp6_ptr->io.event);
+        writel(0x00, &dp6_ptr->u.ic.S_Info[0]);
+        writel(0x00, &dp6_ptr->u.ic.S_Info[1]);
+        writel(0x00, &dp6_ptr->u.ic.S_Info[2]);
+        writel(0x00, &dp6_ptr->u.ic.S_Info[3]);
+        writeb(0xfe, &dp6_ptr->u.ic.S_Cmd_Indx);
+        writeb(0, &dp6_ptr->io.event);
         retries = INIT_RETRIES;
         gdth_delay(20);
-        while (gdth_readb(&dp6_ptr->u.ic.S_Status) != 0xfe) {
+        while (readb(&dp6_ptr->u.ic.S_Status) != 0xfe) {
             if (--retries == 0) {
                 printk("GDT-PCI: Initialization error\n");
                 iounmap(ha->brd);
@@ -957,8 +950,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
             gdth_delay(1);
         }
-        gdth_writeb(0, &dp6_ptr->u.ic.S_Status);
-        gdth_writeb(0xff, &dp6_ptr->io.irqdel);
+        writeb(0, &dp6_ptr->u.ic.S_Status);
+        writeb(0xff, &dp6_ptr->io.irqdel);
 
         ha->dma64_support = 0;
 
@@ -974,8 +967,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         }
         /* check and reset interface area */
         dp6c_ptr = ha->brd;
-        gdth_writel(DPMEM_MAGIC, &dp6c_ptr->u);
-        if (gdth_readl(&dp6c_ptr->u) != DPMEM_MAGIC) {
+        writel(DPMEM_MAGIC, &dp6c_ptr->u);
+        if (readl(&dp6c_ptr->u) != DPMEM_MAGIC) {
             printk("GDT-PCI: Cannot access DPMEM at 0x%lx (shadowed?)\n", 
                    pcistr->dpmem);
             found = FALSE;
@@ -986,7 +979,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
                     return 0;
                 }
-                if (gdth_readw(ha->brd) != 0xffff) {
+                if (readw(ha->brd) != 0xffff) {
                     TRACE2(("init_pci_plx() address 0x%x busy\n", i));
                     continue;
                 }
@@ -999,8 +992,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     return 0;
                 }
                 dp6c_ptr = ha->brd;
-                gdth_writel(DPMEM_MAGIC, &dp6c_ptr->u);
-                if (gdth_readl(&dp6c_ptr->u) == DPMEM_MAGIC) {
+                writel(DPMEM_MAGIC, &dp6c_ptr->u);
+                if (readl(&dp6c_ptr->u) == DPMEM_MAGIC) {
                     printk("GDT-PCI: Use free address at 0x%x\n", i);
                     found = TRUE;
                     break;
@@ -1013,7 +1006,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
         }
         memset_io(&dp6c_ptr->u, 0, sizeof(dp6c_ptr->u));
-        if (gdth_readl(&dp6c_ptr->u) != 0) {
+        if (readl(&dp6c_ptr->u) != 0) {
             printk("GDT-PCI: Initialization error (DPMEM write error)\n");
             iounmap(ha->brd);
             return 0;
@@ -1023,17 +1016,17 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         outb(0x00,PTR2USHORT(&ha->plx->control1));
         outb(0xff,PTR2USHORT(&ha->plx->edoor_reg));
         
-        gdth_writeb(0x00, &dp6c_ptr->u.ic.S_Status);
-        gdth_writeb(0x00, &dp6c_ptr->u.ic.Cmd_Index);
+        writeb(0x00, &dp6c_ptr->u.ic.S_Status);
+        writeb(0x00, &dp6c_ptr->u.ic.Cmd_Index);
 
-        gdth_writel(pcistr->dpmem, &dp6c_ptr->u.ic.S_Info[0]);
-        gdth_writeb(0xff, &dp6c_ptr->u.ic.S_Cmd_Indx);
+        writel(pcistr->dpmem, &dp6c_ptr->u.ic.S_Info[0]);
+        writeb(0xff, &dp6c_ptr->u.ic.S_Cmd_Indx);
 
         outb(1,PTR2USHORT(&ha->plx->ldoor_reg));
 
         retries = INIT_RETRIES;
         gdth_delay(20);
-        while (gdth_readb(&dp6c_ptr->u.ic.S_Status) != 0xff) {
+        while (readb(&dp6c_ptr->u.ic.S_Status) != 0xff) {
             if (--retries == 0) {
                 printk("GDT-PCI: Initialization error (DEINIT failed)\n");
                 iounmap(ha->brd);
@@ -1041,8 +1034,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)gdth_readl(&dp6c_ptr->u.ic.S_Info[0]);
-        gdth_writeb(0, &dp6c_ptr->u.ic.Status);
+        prot_ver = (unchar)readl(&dp6c_ptr->u.ic.S_Info[0]);
+        writeb(0, &dp6c_ptr->u.ic.Status);
         if (prot_ver != PROTOCOL_VERSION) {
             printk("GDT-PCI: Illegal protocol version\n");
             iounmap(ha->brd);
@@ -1053,17 +1046,17 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         ha->ic_all_size = sizeof(dp6c_ptr->u);
 
         /* special command to controller BIOS */
-        gdth_writel(0x00, &dp6c_ptr->u.ic.S_Info[0]);
-        gdth_writel(0x00, &dp6c_ptr->u.ic.S_Info[1]);
-        gdth_writel(0x00, &dp6c_ptr->u.ic.S_Info[2]);
-        gdth_writel(0x00, &dp6c_ptr->u.ic.S_Info[3]);
-        gdth_writeb(0xfe, &dp6c_ptr->u.ic.S_Cmd_Indx);
+        writel(0x00, &dp6c_ptr->u.ic.S_Info[0]);
+        writel(0x00, &dp6c_ptr->u.ic.S_Info[1]);
+        writel(0x00, &dp6c_ptr->u.ic.S_Info[2]);
+        writel(0x00, &dp6c_ptr->u.ic.S_Info[3]);
+        writeb(0xfe, &dp6c_ptr->u.ic.S_Cmd_Indx);
         
         outb(1,PTR2USHORT(&ha->plx->ldoor_reg));
 
         retries = INIT_RETRIES;
         gdth_delay(20);
-        while (gdth_readb(&dp6c_ptr->u.ic.S_Status) != 0xfe) {
+        while (readb(&dp6c_ptr->u.ic.S_Status) != 0xfe) {
             if (--retries == 0) {
                 printk("GDT-PCI: Initialization error\n");
                 iounmap(ha->brd);
@@ -1071,7 +1064,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
             gdth_delay(1);
         }
-        gdth_writeb(0, &dp6c_ptr->u.ic.S_Status);
+        writeb(0, &dp6c_ptr->u.ic.S_Status);
 
         ha->dma64_support = 0;
 
@@ -1099,12 +1092,12 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
 
         /* Ensure that it is safe to access the non HW portions of DPMEM.
          * Aditional check needed for Xscale based RAID controllers */
-        while( ((int)gdth_readb(&dp6m_ptr->i960r.sema0_reg) ) & 3 )
+        while( ((int)readb(&dp6m_ptr->i960r.sema0_reg) ) & 3 )
             gdth_delay(1);
         
         /* check and reset interface area */
-        gdth_writel(DPMEM_MAGIC, &dp6m_ptr->u);
-        if (gdth_readl(&dp6m_ptr->u) != DPMEM_MAGIC) {
+        writel(DPMEM_MAGIC, &dp6m_ptr->u);
+        if (readl(&dp6m_ptr->u) != DPMEM_MAGIC) {
             printk("GDT-PCI: Cannot access DPMEM at 0x%lx (shadowed?)\n", 
                    pcistr->dpmem);
             found = FALSE;
@@ -1115,7 +1108,7 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
                     return 0;
                 }
-                if (gdth_readw(ha->brd) != 0xffff) {
+                if (readw(ha->brd) != 0xffff) {
                     TRACE2(("init_pci_mpr() address 0x%x busy\n", i));
                     continue;
                 }
@@ -1128,8 +1121,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
                     return 0;
                 }
                 dp6m_ptr = ha->brd;
-                gdth_writel(DPMEM_MAGIC, &dp6m_ptr->u);
-                if (gdth_readl(&dp6m_ptr->u) == DPMEM_MAGIC) {
+                writel(DPMEM_MAGIC, &dp6m_ptr->u);
+                if (readl(&dp6m_ptr->u) == DPMEM_MAGIC) {
                     printk("GDT-PCI: Use free address at 0x%x\n", i);
                     found = TRUE;
                     break;
@@ -1144,18 +1137,18 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         memset_io(&dp6m_ptr->u, 0, sizeof(dp6m_ptr->u));
         
         /* disable board interrupts, deinit services */
-        gdth_writeb(gdth_readb(&dp6m_ptr->i960r.edoor_en_reg) | 4,
+        writeb(readb(&dp6m_ptr->i960r.edoor_en_reg) | 4,
                     &dp6m_ptr->i960r.edoor_en_reg);
-        gdth_writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
-        gdth_writeb(0x00, &dp6m_ptr->u.ic.S_Status);
-        gdth_writeb(0x00, &dp6m_ptr->u.ic.Cmd_Index);
+        writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
+        writeb(0x00, &dp6m_ptr->u.ic.S_Status);
+        writeb(0x00, &dp6m_ptr->u.ic.Cmd_Index);
 
-        gdth_writel(pcistr->dpmem, &dp6m_ptr->u.ic.S_Info[0]);
-        gdth_writeb(0xff, &dp6m_ptr->u.ic.S_Cmd_Indx);
-        gdth_writeb(1, &dp6m_ptr->i960r.ldoor_reg);
+        writel(pcistr->dpmem, &dp6m_ptr->u.ic.S_Info[0]);
+        writeb(0xff, &dp6m_ptr->u.ic.S_Cmd_Indx);
+        writeb(1, &dp6m_ptr->i960r.ldoor_reg);
         retries = INIT_RETRIES;
         gdth_delay(20);
-        while (gdth_readb(&dp6m_ptr->u.ic.S_Status) != 0xff) {
+        while (readb(&dp6m_ptr->u.ic.S_Status) != 0xff) {
             if (--retries == 0) {
                 printk("GDT-PCI: Initialization error (DEINIT failed)\n");
                 iounmap(ha->brd);
@@ -1163,8 +1156,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)gdth_readl(&dp6m_ptr->u.ic.S_Info[0]);
-        gdth_writeb(0, &dp6m_ptr->u.ic.S_Status);
+        prot_ver = (unchar)readl(&dp6m_ptr->u.ic.S_Info[0]);
+        writeb(0, &dp6m_ptr->u.ic.S_Status);
         if (prot_ver != PROTOCOL_VERSION) {
             printk("GDT-PCI: Illegal protocol version\n");
             iounmap(ha->brd);
@@ -1175,15 +1168,15 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
         ha->ic_all_size = sizeof(dp6m_ptr->u);
         
         /* special command to controller BIOS */
-        gdth_writel(0x00, &dp6m_ptr->u.ic.S_Info[0]);
-        gdth_writel(0x00, &dp6m_ptr->u.ic.S_Info[1]);
-        gdth_writel(0x00, &dp6m_ptr->u.ic.S_Info[2]);
-        gdth_writel(0x00, &dp6m_ptr->u.ic.S_Info[3]);
-        gdth_writeb(0xfe, &dp6m_ptr->u.ic.S_Cmd_Indx);
-        gdth_writeb(1, &dp6m_ptr->i960r.ldoor_reg);
+        writel(0x00, &dp6m_ptr->u.ic.S_Info[0]);
+        writel(0x00, &dp6m_ptr->u.ic.S_Info[1]);
+        writel(0x00, &dp6m_ptr->u.ic.S_Info[2]);
+        writel(0x00, &dp6m_ptr->u.ic.S_Info[3]);
+        writeb(0xfe, &dp6m_ptr->u.ic.S_Cmd_Indx);
+        writeb(1, &dp6m_ptr->i960r.ldoor_reg);
         retries = INIT_RETRIES;
         gdth_delay(20);
-        while (gdth_readb(&dp6m_ptr->u.ic.S_Status) != 0xfe) {
+        while (readb(&dp6m_ptr->u.ic.S_Status) != 0xfe) {
             if (--retries == 0) {
                 printk("GDT-PCI: Initialization error\n");
                 iounmap(ha->brd);
@@ -1191,14 +1184,14 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
             gdth_delay(1);
         }
-        gdth_writeb(0, &dp6m_ptr->u.ic.S_Status);
+        writeb(0, &dp6m_ptr->u.ic.S_Status);
 
         /* read FW version to detect 64-bit DMA support */
-        gdth_writeb(0xfd, &dp6m_ptr->u.ic.S_Cmd_Indx);
-        gdth_writeb(1, &dp6m_ptr->i960r.ldoor_reg);
+        writeb(0xfd, &dp6m_ptr->u.ic.S_Cmd_Indx);
+        writeb(1, &dp6m_ptr->i960r.ldoor_reg);
         retries = INIT_RETRIES;
         gdth_delay(20);
-        while (gdth_readb(&dp6m_ptr->u.ic.S_Status) != 0xfd) {
+        while (readb(&dp6m_ptr->u.ic.S_Status) != 0xfd) {
             if (--retries == 0) {
                 printk("GDT-PCI: Initialization error (DEINIT failed)\n");
                 iounmap(ha->brd);
@@ -1206,8 +1199,8 @@ static int __init gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha)
             }
             gdth_delay(1);
         }
-        prot_ver = (unchar)(gdth_readl(&dp6m_ptr->u.ic.S_Info[0]) >> 16);
-        gdth_writeb(0, &dp6m_ptr->u.ic.S_Status);
+        prot_ver = (unchar)(readl(&dp6m_ptr->u.ic.S_Info[0]) >> 16);
+        writeb(0, &dp6m_ptr->u.ic.S_Status);
         if (prot_ver < 0x2b)      /* FW < x.43: no 64-bit DMA support */
             ha->dma64_support = 0;
         else 
@@ -1238,21 +1231,21 @@ static void __init gdth_enable_int(int hanum)
         outb(0x01, ha->bmic + EINTENABREG);
     } else if (ha->type == GDT_ISA) {
         dp2_ptr = ha->brd;
-        gdth_writeb(1, &dp2_ptr->io.irqdel);
-        gdth_writeb(0, &dp2_ptr->u.ic.Cmd_Index);
-        gdth_writeb(1, &dp2_ptr->io.irqen);
+        writeb(1, &dp2_ptr->io.irqdel);
+        writeb(0, &dp2_ptr->u.ic.Cmd_Index);
+        writeb(1, &dp2_ptr->io.irqen);
     } else if (ha->type == GDT_PCI) {
         dp6_ptr = ha->brd;
-        gdth_writeb(1, &dp6_ptr->io.irqdel);
-        gdth_writeb(0, &dp6_ptr->u.ic.Cmd_Index);
-        gdth_writeb(1, &dp6_ptr->io.irqen);
+        writeb(1, &dp6_ptr->io.irqdel);
+        writeb(0, &dp6_ptr->u.ic.Cmd_Index);
+        writeb(1, &dp6_ptr->io.irqen);
     } else if (ha->type == GDT_PCINEW) {
         outb(0xff, PTR2USHORT(&ha->plx->edoor_reg));
         outb(0x03, PTR2USHORT(&ha->plx->control1));
     } else if (ha->type == GDT_PCIMPR) {
         dp6m_ptr = ha->brd;
-        gdth_writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
-        gdth_writeb(gdth_readb(&dp6m_ptr->i960r.edoor_en_reg) & ~4,
+        writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
+        writeb(readb(&dp6m_ptr->i960r.edoor_en_reg) & ~4,
                     &dp6m_ptr->i960r.edoor_en_reg);
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -1276,15 +1269,15 @@ static int gdth_get_status(unchar *pIStatus,int irq)
             *pIStatus = inb((ushort)ha->bmic + EDOORREG);
         else if (ha->type == GDT_ISA)
             *pIStatus =
-                gdth_readb(&((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Cmd_Index);
+                readb(&((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Cmd_Index);
         else if (ha->type == GDT_PCI)
             *pIStatus =
-                gdth_readb(&((gdt6_dpram_str __iomem *)ha->brd)->u.ic.Cmd_Index);
+                readb(&((gdt6_dpram_str __iomem *)ha->brd)->u.ic.Cmd_Index);
         else if (ha->type == GDT_PCINEW) 
             *pIStatus = inb(PTR2USHORT(&ha->plx->edoor_reg));
         else if (ha->type == GDT_PCIMPR)
             *pIStatus =
-                gdth_readb(&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.edoor_reg);
+                readb(&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.edoor_reg);
    
         if (*pIStatus)                                  
             return i;                           /* board found */
@@ -1304,14 +1297,14 @@ static int gdth_test_busy(int hanum)
     if (ha->type == GDT_EISA)
         gdtsema0 = (int)inb(ha->bmic + SEMA0REG);
     else if (ha->type == GDT_ISA)
-        gdtsema0 = (int)gdth_readb(&((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
+        gdtsema0 = (int)readb(&((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
     else if (ha->type == GDT_PCI)
-        gdtsema0 = (int)gdth_readb(&((gdt6_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
+        gdtsema0 = (int)readb(&((gdt6_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
     else if (ha->type == GDT_PCINEW) 
         gdtsema0 = (int)inb(PTR2USHORT(&ha->plx->sema0_reg));
     else if (ha->type == GDT_PCIMPR)
         gdtsema0 = 
-            (int)gdth_readb(&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.sema0_reg);
+            (int)readb(&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.sema0_reg);
 
     return (gdtsema0 & 1);
 }
@@ -1347,13 +1340,13 @@ static void gdth_set_sema0(int hanum)
     if (ha->type == GDT_EISA) {
         outb(1, ha->bmic + SEMA0REG);
     } else if (ha->type == GDT_ISA) {
-        gdth_writeb(1, &((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
+        writeb(1, &((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
     } else if (ha->type == GDT_PCI) {
-        gdth_writeb(1, &((gdt6_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
+        writeb(1, &((gdt6_dpram_str __iomem *)ha->brd)->u.ic.Sema0);
     } else if (ha->type == GDT_PCINEW) { 
         outb(1, PTR2USHORT(&ha->plx->sema0_reg));
     } else if (ha->type == GDT_PCIMPR) {
-        gdth_writeb(1, &((gdt6m_dpram_str __iomem *)ha->brd)->i960r.sema0_reg);
+        writeb(1, &((gdt6m_dpram_str __iomem *)ha->brd)->i960r.sema0_reg);
     }
 }
 
@@ -1389,30 +1382,30 @@ static void gdth_copy_command(int hanum)
     /* set offset and service, copy command to DPMEM */
     if (ha->type == GDT_ISA) {
         dp2_ptr = ha->brd;
-        gdth_writew(dp_offset + DPMEM_COMMAND_OFFSET, 
+        writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp2_ptr->u.ic.comm_queue[cmd_no].offset);
-        gdth_writew((ushort)cmd_ptr->Service, 
+        writew((ushort)cmd_ptr->Service,
                     &dp2_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp2_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     } else if (ha->type == GDT_PCI) {
         dp6_ptr = ha->brd;
-        gdth_writew(dp_offset + DPMEM_COMMAND_OFFSET, 
+        writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp6_ptr->u.ic.comm_queue[cmd_no].offset);
-        gdth_writew((ushort)cmd_ptr->Service, 
+        writew((ushort)cmd_ptr->Service,
                     &dp6_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp6_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     } else if (ha->type == GDT_PCINEW) {
         dp6c_ptr = ha->brd;
-        gdth_writew(dp_offset + DPMEM_COMMAND_OFFSET, 
+        writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp6c_ptr->u.ic.comm_queue[cmd_no].offset);
-        gdth_writew((ushort)cmd_ptr->Service, 
+        writew((ushort)cmd_ptr->Service,
                     &dp6c_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp6c_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     } else if (ha->type == GDT_PCIMPR) {
         dp6m_ptr = ha->brd;
-        gdth_writew(dp_offset + DPMEM_COMMAND_OFFSET, 
+        writew(dp_offset + DPMEM_COMMAND_OFFSET,
                     &dp6m_ptr->u.ic.comm_queue[cmd_no].offset);
-        gdth_writew((ushort)cmd_ptr->Service, 
+        writew((ushort)cmd_ptr->Service,
                     &dp6m_ptr->u.ic.comm_queue[cmd_no].serv_id);
         memcpy_toio(&dp6m_ptr->u.ic.gdt_dpr_cmd[dp_offset],cmd_ptr,cp_count);
     }
@@ -1448,13 +1441,13 @@ static void gdth_release_event(int hanum)
             outl(ha->ccb_phys, ha->bmic + MAILBOXREG);
         outb(ha->pccb->Service, ha->bmic + LDOORREG);
     } else if (ha->type == GDT_ISA) {
-        gdth_writeb(0, &((gdt2_dpram_str __iomem *)ha->brd)->io.event);
+        writeb(0, &((gdt2_dpram_str __iomem *)ha->brd)->io.event);
     } else if (ha->type == GDT_PCI) {
-        gdth_writeb(0, &((gdt6_dpram_str __iomem *)ha->brd)->io.event);
+        writeb(0, &((gdt6_dpram_str __iomem *)ha->brd)->io.event);
     } else if (ha->type == GDT_PCINEW) { 
         outb(1, PTR2USHORT(&ha->plx->ldoor_reg));
     } else if (ha->type == GDT_PCIMPR) {
-        gdth_writeb(1, &((gdt6m_dpram_str __iomem *)ha->brd)->i960r.ldoor_reg);
+        writeb(1, &((gdt6m_dpram_str __iomem *)ha->brd)->i960r.ldoor_reg);
     }
 }
 
@@ -3137,32 +3130,32 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
             dp2_ptr = ha->brd;
             if (IStatus & 0x80) {                       /* error flag */
                 IStatus &= ~0x80;
-                ha->status = gdth_readw(&dp2_ptr->u.ic.Status);
+                ha->status = readw(&dp2_ptr->u.ic.Status);
                 TRACE2(("gdth_interrupt() error %d/%d\n",IStatus,ha->status));
             } else                                      /* no error */
                 ha->status = S_OK;
-            ha->info = gdth_readl(&dp2_ptr->u.ic.Info[0]);
-            ha->service = gdth_readw(&dp2_ptr->u.ic.Service);
-            ha->info2 = gdth_readl(&dp2_ptr->u.ic.Info[1]);
+            ha->info = readl(&dp2_ptr->u.ic.Info[0]);
+            ha->service = readw(&dp2_ptr->u.ic.Service);
+            ha->info2 = readl(&dp2_ptr->u.ic.Info[1]);
 
-            gdth_writeb(0xff, &dp2_ptr->io.irqdel); /* acknowledge interrupt */
-            gdth_writeb(0, &dp2_ptr->u.ic.Cmd_Index);/* reset command index */
-            gdth_writeb(0, &dp2_ptr->io.Sema1);     /* reset status semaphore */
+            writeb(0xff, &dp2_ptr->io.irqdel); /* acknowledge interrupt */
+            writeb(0, &dp2_ptr->u.ic.Cmd_Index);/* reset command index */
+            writeb(0, &dp2_ptr->io.Sema1);     /* reset status semaphore */
         } else if (ha->type == GDT_PCI) {
             dp6_ptr = ha->brd;
             if (IStatus & 0x80) {                       /* error flag */
                 IStatus &= ~0x80;
-                ha->status = gdth_readw(&dp6_ptr->u.ic.Status);
+                ha->status = readw(&dp6_ptr->u.ic.Status);
                 TRACE2(("gdth_interrupt() error %d/%d\n",IStatus,ha->status));
             } else                                      /* no error */
                 ha->status = S_OK;
-            ha->info = gdth_readl(&dp6_ptr->u.ic.Info[0]);
-            ha->service = gdth_readw(&dp6_ptr->u.ic.Service);
-            ha->info2 = gdth_readl(&dp6_ptr->u.ic.Info[1]);
+            ha->info = readl(&dp6_ptr->u.ic.Info[0]);
+            ha->service = readw(&dp6_ptr->u.ic.Service);
+            ha->info2 = readl(&dp6_ptr->u.ic.Info[1]);
 
-            gdth_writeb(0xff, &dp6_ptr->io.irqdel); /* acknowledge interrupt */
-            gdth_writeb(0, &dp6_ptr->u.ic.Cmd_Index);/* reset command index */
-            gdth_writeb(0, &dp6_ptr->io.Sema1);     /* reset status semaphore */
+            writeb(0xff, &dp6_ptr->io.irqdel); /* acknowledge interrupt */
+            writeb(0, &dp6_ptr->u.ic.Cmd_Index);/* reset command index */
+            writeb(0, &dp6_ptr->io.Sema1);     /* reset status semaphore */
         } else if (ha->type == GDT_PCINEW) {
             if (IStatus & 0x80) {                       /* error flag */
                 IStatus &= ~0x80;
@@ -3185,7 +3178,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
                     ha->status = pcs->ext_status & 0xffff;
                 else 
 #endif
-                    ha->status = gdth_readw(&dp6m_ptr->i960r.status);
+                    ha->status = readw(&dp6m_ptr->i960r.status);
                 TRACE2(("gdth_interrupt() error %d/%d\n",IStatus,ha->status));
             } else                                      /* no error */
                 ha->status = S_OK;
@@ -3198,18 +3191,18 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
             } else
 #endif
             {
-                ha->info = gdth_readl(&dp6m_ptr->i960r.info[0]);
-                ha->service = gdth_readw(&dp6m_ptr->i960r.service);
-                ha->info2 = gdth_readl(&dp6m_ptr->i960r.info[1]);
+                ha->info = readl(&dp6m_ptr->i960r.info[0]);
+                ha->service = readw(&dp6m_ptr->i960r.service);
+                ha->info2 = readl(&dp6m_ptr->i960r.info[1]);
             }
             /* event string */
             if (IStatus == ASYNCINDEX) {
                 if (ha->service != SCREENSERVICE &&
                     (ha->fw_vers & 0xff) >= 0x1a) {
-                    ha->dvr.severity = gdth_readb
+                    ha->dvr.severity = readb
                         (&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.severity);
                     for (i = 0; i < 256; ++i) {
-                        ha->dvr.event_string[i] = gdth_readb
+                        ha->dvr.event_string[i] = readb
                             (&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.evt_str[i]);
                         if (ha->dvr.event_string[i] == 0)
                             break;
@@ -3222,8 +3215,8 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
             if (!coalesced)
 #endif                          
             {
-                gdth_writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
-                gdth_writeb(0, &dp6m_ptr->i960r.sema1_reg);
+                writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
+                writeb(0, &dp6m_ptr->i960r.sema1_reg);
             }
         } else {
             TRACE2(("gdth_interrupt() unknown controller type\n"));
@@ -3308,8 +3301,8 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
 
     /* coalescing only for new GDT_PCIMPR controllers available */      
     if (ha->type == GDT_PCIMPR && coalesced) {
-        gdth_writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
-        gdth_writeb(0, &dp6m_ptr->i960r.sema1_reg);
+        writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
+        writeb(0, &dp6m_ptr->i960r.sema1_reg);
     }
 #endif
 
-- 
1.5.3.1


