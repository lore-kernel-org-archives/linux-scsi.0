From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: [PATCH] gdth driver for 2.4.23-pre4
Date: Wed, 07 Jan 2004 19:56:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFC5644.9060200@wanadoo.es>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060902000602000705050509"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.eresmas.com ([62.81.235.113]:62921 "EHLO
	smtp13.eresmas.com") by vger.kernel.org with ESMTP id S265552AbUAGS5O
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 13:57:14 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

This is a multi-part message in MIME format.
--------------060902000602000705050509
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

hi,

latest driver update for 2.4 kernel:

- Disabled scan for EISA controllers
- Using CACHE_READ_OEM_STRING_RECORD_IOCTL to set vendor
  for SCSI inquiry.
- Added support for XSCALE based RAID controllers
- Reformated some code chunks

complete driver is at: http://www.icp-vortex.com/english/download/rz_neu/linux/linux_e.htm

-thanks-

--------------060902000602000705050509
Content-Type: text/plain;
 name="gdth.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gdth.patch"

diff -Nuar o/drivers/scsi/gdth.c n/drivers/scsi/gdth.c
--- o/drivers/scsi/gdth.c	2004-01-07 19:28:08.000000000 +0100
+++ n/drivers/scsi/gdth.c	2003-08-28 11:31:52.000000000 +0200
@@ -4,11 +4,12 @@
  * Intel Corporation:  Storage RAID Controllers                         *
  *                                                                      *
  * gdth.c                                                               *
- * Copyright (C) 1995-02 ICP vortex, an Intel company,  Achim Leubner   *
- * <achim.leubner@intel.com>                                            *
+ * Copyright (C) 1995-03 ICP vortex, Achim Leubner                      *
+ * <achim_leubner@adaptec.com>                                          *
  *                                                                      *
- * Additions/Fixes: Boji Tony Kannanthanam                              *
- * <boji.t.kannanthanam@intel.com>                                      *
+ * Additions/Fixes:                                                     * 
+ * Boji Tony Kannanthanam <boji.t.kannanthanam@intel.com>               *
+ * Johannes Dinner <johannes_dinner@adaptec.com>                        *
  *                                                                      *
  * This program is free software; you can redistribute it and/or modify *
  * it under the terms of the GNU General Public License as published    *
@@ -24,9 +25,19 @@
  * along with this kernel; if not, write to the Free Software           *
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.            *
  *                                                                      *
- * Tested with Linux 1.2.13, ..., 2.2.20, ..., 2.4.18                   *
+ * Tested with Linux 1.2.13, ..., 2.2.20, ..., 2.4.22                   *
  *                                                                      *
  * $Log: gdth.c,v $
+ * Revision 1.63.1  2003/08/04         johannes
+ * Disabled scan for EISA controllers
+ *
+ * Revision 1.63  2002/11/08 09:35:22  boji
+ * Using CACHE_READ_OEM_STRING_RECORD_IOCTL to set vendor
+ * for SCSI inquiry.
+ *
+ * Revision 1.62  2002/10/16 09:35:22  boji
+ * Added support for XSCALE based RAID controllers
+ *
  * Revision 1.61  2002/10/03 09:35:22  boji
  * Fixed SCREENSERVICE intialisation in SMP cases.
  * Added checks for gdth_polling before GDTH_HA_LOCK
@@ -282,10 +293,12 @@
  *                              access a shared resource from several nodes, 
  *                              appropiate controller firmware required
  * shared_access:N              enable driver reserve/release protocol
+ * probe_eisa_isa:Y             scan for EISA/ISA controllers
+ * probe_eisa_isa:N             do not scan for EISA/ISA controllers
  *
  * The default values are: "gdth=disable:N,reserve_mode:1,reverse_scan:N,
  *                          max_ids:127,rescan:N,virt_ctr:N,hdr_channel:0,
- *                          shared_access:Y".
+ *                          shared_access:Y,probe_eisa_isa:N".
  * Here is another example: "gdth=reserve_list:0,1,2,0,0,1,3,0,rescan:Y".
  * 
  * When loading the gdth driver as a module, the same options are available. 
@@ -295,7 +308,8 @@
  * '1' in place of 'Y' and '0' in place of 'N'.
  * 
  * Default: "modprobe gdth disable=0 reserve_mode=1 reverse_scan=0
- *           max_ids=127 rescan=0 virt_ctr=0 hdr_channel=0 shared_access=0"
+ *           max_ids=127 rescan=0 virt_ctr=0 hdr_channel=0 shared_access=0 
+ *           probe_eisa_isa=0"
  * The other example: "modprobe gdth reserve_list=0,1,2,0,0,1,3,0 rescan=1".
  */
 
@@ -686,6 +700,8 @@
 static int virt_ctr = 0;
 /* shared access */
 static int shared_access = 1;
+/* enable support for EISA and ISA controllers */
+static int probe_eisa_isa = 0;
 
 #ifdef MODULE
 #if LINUX_VERSION_CODE >= 0x02011A
@@ -700,6 +716,7 @@
 MODULE_PARM(rescan, "i");
 MODULE_PARM(virt_ctr, "i");
 MODULE_PARM(shared_access, "i");
+MODULE_PARM(probe_eisa_isa, "i");
 MODULE_AUTHOR("Achim Leubner");
 #endif
 #if LINUX_VERSION_CODE >= 0x02040B
@@ -814,6 +831,8 @@
                     PCI_DEVICE_ID_VORTEX_GDTNEWRX);
     gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_INTEL,
                     PCI_DEVICE_ID_INTEL_SRC);
+    gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_INTEL,
+                    PCI_DEVICE_ID_INTEL_SRC_XSCALE);
     return cnt;
 }
 
@@ -824,6 +843,7 @@
 static struct pci_device_id gdthtable[] = {
 	{PCI_VENDOR_ID_VORTEX,PCI_ANY_ID,PCI_ANY_ID, PCI_ANY_ID },
 	{PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC,PCI_ANY_ID,PCI_ANY_ID }, 
+	{PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC_XSCALE,PCI_ANY_ID,PCI_ANY_ID }, 
 	{0}
 };
 MODULE_DEVICE_TABLE(pci,gdthtable);
@@ -1512,6 +1532,11 @@
                                    PCI_ROM_ADDRESS, rom_addr);
 #endif
         
+	/* Ensure that it is safe to access the non HW portions of DPMEM.
+	 * Aditional check needed for Xscale based RAID controllers */
+	while( ((int)gdth_readb(&((gdt6m_dpram_str *)ha->brd)->i960r.sema0_reg) ) & 3 )
+		gdth_delay(1);
+	
         /* check and reset interface area */
         dp6m_ptr = (gdt6m_dpram_str *)ha->brd;
         gdth_writel(DPMEM_MAGIC, &dp6m_ptr->u);
@@ -1966,6 +1991,8 @@
     gdth_raw_iochan_str *iocr;
     gdth_arcdl_str *alst;
     gdth_alist_str *alst2;
+    gdth_oem_str_ioctl *oemstr;
+
 #ifdef GDTH_RTC
     unchar rtc[12];
     ulong flags;
@@ -2234,6 +2261,28 @@
         }
     }
 
+    /* Determine OEM string using IOCTL*/
+        oemstr = (gdth_oem_str_ioctl *)ha->pscratch;
+	    oemstr->params.ctl_version=0x01;
+	    oemstr->params.buffer_size= (sizeof(oemstr->text));
+	    if (gdth_internal_cmd(hanum,CACHESERVICE,GDT_IOCTL,CACHE_READ_OEM_STRING_RECORD,
+		INVALID_CHANNEL,sizeof(gdth_oem_str_ioctl))) {
+		TRACE2("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD IOCTL Successful. \n");
+		printk("GDT CTR%d Vendor: %s \n", hanum, oemstr->text.oem_company_name);
+		/* Save the Host Drive inquiry data */
+		strncpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,7);
+		ha->oem_name[7]='\0';
+	    }
+	    else
+	    {
+		/* Old method, based on PCI ID */
+		TRACE2("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD IOCTL Failed. \n");
+        	if (ha->oem_id == OEM_ID_INTEL)
+            		strcpy(ha->oem_name,"Intel  ");
+        	else 
+            		strcpy(ha->oem_name,"ICP    ");
+	    }
+    
     /* scanning for host drives */
     for (i = 0; i < cdev_cnt; ++i) 
         gdth_analyse_hdrive(hanum,i);
@@ -2707,10 +2756,7 @@
         inq.version   = 2;
         inq.resp_aenc = 2;
         inq.add_length= 32;
-        if (ha->oem_id == OEM_ID_INTEL)
-            strcpy(inq.vendor,"Intel  ");
-        else 
-            strcpy(inq.vendor,"ICP    ");
+	strcpy(inq.vendor,ha->oem_name);
         sprintf(inq.product,"Host Drive  #%02d",t);
         strcpy(inq.revision,"   ");
         gdth_copy_internal_data(scp,(char*)&inq,sizeof(gdth_inq_data));
@@ -3943,6 +3989,8 @@
             virt_ctr = val;
         else if (!strncmp(argv, "shared_access:", 14))
             shared_access = val;
+        else if (!strncmp(argv, "probe_eisa_isa:", 15))
+            probe_eisa_isa = val;
         else if (!strncmp(argv, "reserve_list:", 13)) {
             reserve_list[0] = val;
             for (i = 1; i < MAX_RES_ARGS; i++) {
@@ -4023,222 +4071,223 @@
     gdth_polling = TRUE; b = 0;
     gdth_clear_events();
 
-    /* scanning for controllers, at first: ISA controller */
-    for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
-        if (gdth_ctr_count >= MAXHA) 
-            break;
-        if (gdth_search_isa(isa_bios)) {        /* controller found */
-            shp = scsi_register(shtp,sizeof(gdth_ext_str));
-            if(shp == NULL)
-            	continue;
-            ha = HADATA(shp);
-            if (!gdth_init_isa(isa_bios,ha)) {
-                scsi_unregister(shp);
-                continue;
-            }
+    if(probe_eisa_isa) {    /* As default we do not probe for EISA or ISA controllers */
+        /* scanning for controllers, at first: ISA controller */
+        for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
+            if (gdth_ctr_count >= MAXHA) 
+                break;
+            if (gdth_search_isa(isa_bios)) {        /* controller found */
+                shp = scsi_register(shtp,sizeof(gdth_ext_str));
+                if (shp == NULL)
+                    continue;
+                ha = HADATA(shp);
+                if (!gdth_init_isa(isa_bios,ha)) {
+                    scsi_unregister(shp);
+                    continue;
+                }
 #ifdef __ia64__
-            break;
+                break;
 #else
-            /* controller found and initialized */
-            printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
-                   isa_bios,ha->irq,ha->drq);
+                /* controller found and initialized */
+                printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
+                       isa_bios,ha->irq,ha->drq);
 
 #if LINUX_VERSION_CODE >= 0x010346 
-            if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth",ha))
+                if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth",ha))
 #else
-            if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth")) 
+                if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth")) 
 #endif
-            {
-                printk("GDT-ISA: Unable to allocate IRQ\n");
-                scsi_unregister(shp);
-                continue;
-            }
-            if (request_dma(ha->drq,"gdth")) {
-                printk("GDT-ISA: Unable to allocate DMA channel\n");
+                {
+                    printk("GDT-ISA: Unable to allocate IRQ\n");
+                    scsi_unregister(shp);
+                    continue;
+                }
+                if (request_dma(ha->drq,"gdth")) {
+                    printk("GDT-ISA: Unable to allocate DMA channel\n");
 #if LINUX_VERSION_CODE >= 0x010346 
-                free_irq(ha->irq,ha);
+                    free_irq(ha->irq,ha);
 #else
-                free_irq(ha->irq);
+                    free_irq(ha->irq);
 #endif
-                scsi_unregister(shp);
-                continue;
-            }
-            set_dma_mode(ha->drq,DMA_MODE_CASCADE);
-            enable_dma(ha->drq);
-            shp->unchecked_isa_dma = 1;
-            shp->irq = ha->irq;
-            shp->dma_channel = ha->drq;
-            hanum = gdth_ctr_count;         
-            gdth_ctr_tab[gdth_ctr_count++] = shp;
-            gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+                    scsi_unregister(shp);
+                    continue;
+                }
+                set_dma_mode(ha->drq,DMA_MODE_CASCADE);
+                enable_dma(ha->drq);
+                shp->unchecked_isa_dma = 1;
+                shp->irq = ha->irq;
+                shp->dma_channel = ha->drq;
+                hanum = gdth_ctr_count;         
+                gdth_ctr_tab[gdth_ctr_count++] = shp;
+                gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
 
-            NUMDATA(shp)->hanum = (ushort)hanum;
-            NUMDATA(shp)->busnum= 0;
+                NUMDATA(shp)->hanum = (ushort)hanum;
+                NUMDATA(shp)->busnum= 0;
 
-            ha->pccb = CMDDATA(shp);
+                ha->pccb = CMDDATA(shp);
 #if LINUX_VERSION_CODE >= 0x020322
-            ha->pscratch = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 
-                                                     GDTH_SCRATCH_ORD);
+                ha->pscratch = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 
+                                                         GDTH_SCRATCH_ORD);
 #else
-            ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
+                ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
 #endif
-            ha->scratch_busy = FALSE;
-            ha->req_first = NULL;
-            ha->tid_cnt = MAX_HDRIVES;
-            if (max_ids > 0 && max_ids < ha->tid_cnt)
-                ha->tid_cnt = max_ids;
-            for (i=0; i<GDTH_MAXCMDS; ++i)
-                ha->cmd_tab[i].cmnd = UNUSED_CMND;
-            ha->scan_mode = rescan ? 0x10 : 0;
-
-            if (ha->pscratch == NULL || !gdth_search_drives(hanum)) {
-                printk("GDT-ISA: Error during device scan\n");
-                --gdth_ctr_count;
-                --gdth_ctr_vcount;
-                if (ha->pscratch != NULL)
+                ha->scratch_busy = FALSE;
+                ha->req_first = NULL;
+                ha->tid_cnt = MAX_HDRIVES;
+                if (max_ids > 0 && max_ids < ha->tid_cnt)
+                    ha->tid_cnt = max_ids;
+                for (i=0; i<GDTH_MAXCMDS; ++i)
+                    ha->cmd_tab[i].cmnd = UNUSED_CMND;
+                ha->scan_mode = rescan ? 0x10 : 0;
+
+                if (ha->pscratch == NULL || !gdth_search_drives(hanum)) {
+                    printk("GDT-ISA: Error during device scan\n");
+                    --gdth_ctr_count;
+                    --gdth_ctr_vcount;
+                    if (ha->pscratch != NULL)
 #if LINUX_VERSION_CODE >= 0x020322
-                    free_pages((unsigned long)ha->pscratch, GDTH_SCRATCH_ORD);
+                        free_pages((unsigned long)ha->pscratch, GDTH_SCRATCH_ORD);
 #else
-                    scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
+                        scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
 #endif
 #if LINUX_VERSION_CODE >= 0x010346 
-                free_irq(ha->irq,ha);
+                    free_irq(ha->irq,ha);
 #else
-                free_irq(ha->irq);
+                    free_irq(ha->irq);
 #endif
-                scsi_unregister(shp);
-                continue;
-            }
-            if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
-                hdr_channel = ha->bus_cnt;
-            ha->virt_bus = hdr_channel;
+                    scsi_unregister(shp);
+                    continue;
+                }
+                if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+                    hdr_channel = ha->bus_cnt;
+                ha->virt_bus = hdr_channel;
 
 #if LINUX_VERSION_CODE >= 0x020000
-            shp->max_id      = ha->tid_cnt;
-            shp->max_lun     = MAXLUN;
-            shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-            if (virt_ctr)  
+                shp->max_id      = ha->tid_cnt;
+                shp->max_lun     = MAXLUN;
+                shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
+                if (virt_ctr)  
 #endif
-            {
-                virt_ctr = 1;
-                /* register addit. SCSI channels as virtual controllers */
-                for (b = 1; b < ha->bus_cnt + 1; ++b) {
-                    shp = scsi_register(shtp,sizeof(gdth_num_str));
-                    shp->unchecked_isa_dma = 1;
-                    shp->irq = ha->irq;
-                    shp->dma_channel = ha->drq;
-                    gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-                    NUMDATA(shp)->hanum = (ushort)hanum;
-                    NUMDATA(shp)->busnum = b;
-                }
-            }  
+                {
+                    virt_ctr = 1;
+                    /* register addit. SCSI channels as virtual controllers */
+                    for (b = 1; b < ha->bus_cnt + 1; ++b) {
+                        shp = scsi_register(shtp,sizeof(gdth_num_str));
+                        shp->unchecked_isa_dma = 1;
+                        shp->irq = ha->irq;
+                        shp->dma_channel = ha->drq;
+                        gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+                        NUMDATA(shp)->hanum = (ushort)hanum;
+                        NUMDATA(shp)->busnum = b;
+                    }
+                }  
 
-            GDTH_INIT_LOCK_HA(ha);
-            gdth_enable_int(hanum);
+                GDTH_INIT_LOCK_HA(ha);
+                gdth_enable_int(hanum);
 #endif /* !__ia64__ */
+            }
         }
-    }
 
-    /* scanning for EISA controllers */
-    for (eisa_slot=0x1000; eisa_slot<=0x8000; eisa_slot+=0x1000) {
-        if (gdth_ctr_count >= MAXHA) 
-            break;
-        if (gdth_search_eisa(eisa_slot)) {      /* controller found */
-            shp = scsi_register(shtp,sizeof(gdth_ext_str));
-	    if(shp == NULL)
-		    continue;
-
-            ha = HADATA(shp);
-            if (!gdth_init_eisa(eisa_slot,ha)) {
-                scsi_unregister(shp);
-                continue;
-            }
-            /* controller found and initialized */
-            printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
-                   eisa_slot>>12,ha->irq);
+        /* scanning for EISA controllers */
+        for (eisa_slot=0x1000; eisa_slot<=0x8000; eisa_slot+=0x1000) {
+            if (gdth_ctr_count >= MAXHA) 
+                break;
+            if (gdth_search_eisa(eisa_slot)) {      /* controller found */
+                shp = scsi_register(shtp,sizeof(gdth_ext_str));
+                if (shp == NULL)
+                    continue;
+                ha = HADATA(shp);
+                if (!gdth_init_eisa(eisa_slot,ha)) {
+                    scsi_unregister(shp);
+                    continue;
+                }
+                /* controller found and initialized */
+                printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
+                       eisa_slot>>12,ha->irq);
 
 #if LINUX_VERSION_CODE >= 0x010346 
-            if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth",ha))
+                if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth",ha))
 #else
-            if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth")) 
+                if (request_irq(ha->irq,gdth_interrupt,SA_INTERRUPT,"gdth")) 
 #endif
-            {
-                printk("GDT-EISA: Unable to allocate IRQ\n");
-                scsi_unregister(shp);
-                continue;
-            }
-            shp->unchecked_isa_dma = 0;
-            shp->irq = ha->irq;
-            shp->dma_channel = 0xff;
-            hanum = gdth_ctr_count;
-            gdth_ctr_tab[gdth_ctr_count++] = shp;
-            gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-
-            NUMDATA(shp)->hanum = (ushort)hanum;
-            NUMDATA(shp)->busnum= 0;
-            TRACE2(("EISA detect Bus 0: hanum %d\n",
-                    NUMDATA(shp)->hanum));
+                {
+                    printk("GDT-EISA: Unable to allocate IRQ\n");
+                    scsi_unregister(shp);
+                    continue;
+                }
+                shp->unchecked_isa_dma = 0;
+                shp->irq = ha->irq;
+                shp->dma_channel = 0xff;
+                hanum = gdth_ctr_count;
+                gdth_ctr_tab[gdth_ctr_count++] = shp;
+                gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+
+                NUMDATA(shp)->hanum = (ushort)hanum;
+                NUMDATA(shp)->busnum= 0;
+                TRACE2(("EISA detect Bus 0: hanum %d\n",
+                        NUMDATA(shp)->hanum));
 
-            ha->pccb = CMDDATA(shp);
+                ha->pccb = CMDDATA(shp);
 #if LINUX_VERSION_CODE >= 0x020322
-            ha->pscratch = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 
-                                                     GDTH_SCRATCH_ORD);
+                ha->pscratch = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 
+                                                         GDTH_SCRATCH_ORD);
 #else
-            ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
+                ha->pscratch = scsi_init_malloc(GDTH_SCRATCH, GFP_ATOMIC | GFP_DMA);
 #endif
-            ha->scratch_busy = FALSE;
-            ha->req_first = NULL;
-            ha->tid_cnt = MAX_HDRIVES;
-            if (max_ids > 0 && max_ids < ha->tid_cnt)
-                ha->tid_cnt = max_ids;
-            for (i=0; i<GDTH_MAXCMDS; ++i)
-                ha->cmd_tab[i].cmnd = UNUSED_CMND;
-            ha->scan_mode = rescan ? 0x10 : 0;
-
-            if (ha->pscratch == NULL || !gdth_search_drives(hanum)) {
-                printk("GDT-EISA: Error during device scan\n");
-                --gdth_ctr_count;
-                --gdth_ctr_vcount;
-                if (ha->pscratch != NULL)
+                ha->scratch_busy = FALSE;
+                ha->req_first = NULL;
+                ha->tid_cnt = MAX_HDRIVES;
+                if (max_ids > 0 && max_ids < ha->tid_cnt)
+                    ha->tid_cnt = max_ids;
+                for (i=0; i<GDTH_MAXCMDS; ++i)
+                    ha->cmd_tab[i].cmnd = UNUSED_CMND;
+                ha->scan_mode = rescan ? 0x10 : 0;
+
+                if (ha->pscratch == NULL || !gdth_search_drives(hanum)) {
+                    printk("GDT-EISA: Error during device scan\n");
+                    --gdth_ctr_count;
+                    --gdth_ctr_vcount;
+                    if (ha->pscratch != NULL)
 #if LINUX_VERSION_CODE >= 0x020322
-                    free_pages((unsigned long)ha->pscratch, GDTH_SCRATCH_ORD);
+                        free_pages((unsigned long)ha->pscratch, GDTH_SCRATCH_ORD);
 #else
-                    scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
+                        scsi_init_free((void *)ha->pscratch, GDTH_SCRATCH);
 #endif
 #if LINUX_VERSION_CODE >= 0x010346 
-                free_irq(ha->irq,ha);
+                    free_irq(ha->irq,ha);
 #else
-                free_irq(ha->irq);
+                    free_irq(ha->irq);
 #endif
-                scsi_unregister(shp);
-                continue;
-            }
-            if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
-                hdr_channel = ha->bus_cnt;
-            ha->virt_bus = hdr_channel;
+                    scsi_unregister(shp);
+                    continue;
+                }
+                if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+                    hdr_channel = ha->bus_cnt;
+                ha->virt_bus = hdr_channel;
 
 #if LINUX_VERSION_CODE >= 0x020000
-            shp->max_id      = ha->tid_cnt;
-            shp->max_lun     = MAXLUN;
-            shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-            if (virt_ctr)  
+                shp->max_id      = ha->tid_cnt;
+                shp->max_lun     = MAXLUN;
+                shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
+                if (virt_ctr)  
 #endif
-            {
-                virt_ctr = 1;
-                /* register addit. SCSI channels as virtual controllers */
-                for (b = 1; b < ha->bus_cnt + 1; ++b) {
-                    shp = scsi_register(shtp,sizeof(gdth_num_str));
-                    shp->unchecked_isa_dma = 0;
-                    shp->irq = ha->irq;
-                    shp->dma_channel = 0xff;
-                    gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-                    NUMDATA(shp)->hanum = (ushort)hanum;
-                    NUMDATA(shp)->busnum = b;
-                }
-            }  
+                {
+                    virt_ctr = 1;
+                    /* register addit. SCSI channels as virtual controllers */
+                    for (b = 1; b < ha->bus_cnt + 1; ++b) {
+                        shp = scsi_register(shtp,sizeof(gdth_num_str));
+                        shp->unchecked_isa_dma = 0;
+                        shp->irq = ha->irq;
+                        shp->dma_channel = 0xff;
+                        gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
+                        NUMDATA(shp)->hanum = (ushort)hanum;
+                        NUMDATA(shp)->busnum = b;
+                    }
+                }  
 
-            GDTH_INIT_LOCK_HA(ha);
-            gdth_enable_int(hanum);
+                GDTH_INIT_LOCK_HA(ha);
+                gdth_enable_int(hanum);
+            }
         }
     }
 
@@ -4258,9 +4307,8 @@
             if (gdth_ctr_count >= MAXHA)
                 break;
             shp = scsi_register(shtp,sizeof(gdth_ext_str));
-	    if(shp == NULL)
-		    continue;
-
+            if (shp == NULL)
+                continue;
             ha = HADATA(shp);
             if (!gdth_init_pci(&pcistr[ctr],ha)) {
                 scsi_unregister(shp);
diff -Nuar o/drivers/scsi/gdth.h n/drivers/scsi/gdth.h
--- o/drivers/scsi/gdth.h	2004-01-07 19:28:08.000000000 +0100
+++ n/drivers/scsi/gdth.h	2003-08-14 17:02:59.000000000 +0200
@@ -4,11 +4,18 @@
 /*
  * Header file for the GDT Disk Array/Storage RAID controllers driver for Linux
  * 
- * gdth.h Copyright (C) 1995-02 ICP vortex, an Intel company, Achim Leubner
+ * gdth.h Copyright (C) 1995-03 ICP vortex, Achim Leubner
  * See gdth.c for further informations and 
  * below for supported controller types
  *
- * <achim.leubner@intel.com>
+ * <achim_leubner@adaptec.com>
+ *
+ * Additions/Fixes: Boji Tony Kannanthanam
+ * <boji.t.kannanthanam@intel.com>
+ * 
+ * $Log: gdth.h,v $
+ * Revision 1.47  2002/11/08 09:35:22  boji
+ * Added definitions for gdth_oem_str_ioctl
  *
  * $Id: gdth.h,v 1.46 2002/02/05 09:39:53 achim Exp $
  */
@@ -29,9 +36,9 @@
 /* defines, macros */
 
 /* driver version */
-#define GDTH_VERSION_STR        "2.05"
+#define GDTH_VERSION_STR        "2.06a"
 #define GDTH_VERSION            2
-#define GDTH_SUBVERSION         5
+#define GDTH_SUBVERSION         6
 
 /* protocol version */
 #define PROTOCOL_VERSION        1
@@ -142,6 +149,11 @@
 #define PCI_DEVICE_ID_INTEL_SRC		0x600
 #endif
 
+#ifndef PCI_DEVICE_ID_INTEL_SRC_XSCALE
+/* Intel Storage RAID Controller */
+#define PCI_DEVICE_ID_INTEL_SRC_XSCALE	0x601
+#endif
+
 /* limits */
 #define GDTH_SCRATCH    PAGE_SIZE               /* 4KB scratch buffer */
 #define GDTH_SCRATCH_ORD 0                      /* order 0 means 1 page */
@@ -252,6 +264,7 @@
 #define CACHE_INFO      0x04                    /* cache info */
 #define CACHE_CONFIG    0x05                    /* cache configuration */
 #define CACHE_DRV_INFO  0x07                    /* cache drive info */
+#define CACHE_READ_OEM_STRING_RECORD  0x84      /* Read the OEM String record */
 #define BOARD_FEATURES  0x15                    /* controller features */
 #define BOARD_INFO      0x28                    /* controller info */
 #define HOST_GET        0x10001L                /* get host drive list */
@@ -535,6 +548,48 @@
     unchar      ld_error;                       /* error */
 } PACKED gdth_cdrinfo_str;
 
+/* OEM String */
+typedef struct {
+    ulong32   ctl_version;
+    ulong32   file_major_version;
+    ulong32   file_minor_version;
+    ulong32   buffer_size;
+    ulong32   cpy_count;
+    ulong32   ext_error;
+    ulong32   oem_id;
+    ulong32   board_id;
+} PACKED gdth_oem_str_params ;
+
+typedef struct {
+    unchar            product_0_1_name[16];
+    unchar            product_4_5_name[16];
+    unchar            product_cluster_name[16];
+    unchar            product_reserved[16];
+    unchar            scsi_cluster_target_vendor_id[16];
+    unchar            cluster_raid_fw_name[16];
+    unchar            oem_brand_name[16];
+    unchar            oem_raid_type[16];
+    unchar            bios_type[13];
+    unchar            bios_title[50];
+    unchar            oem_company_name[37];
+    ulong32           pci_id_1;
+    ulong32           pci_id_2;
+    unchar            validation_status[84];
+    unchar            scsi_host_drive_inquiry_vendor_id[16];
+    unchar            library_file_template[32];
+    unchar            tool_name_1[32];
+    unchar            tool_name_2[32];
+    unchar            tool_name_3[32];
+    unchar            oem_contact_1[84];
+    unchar            oem_contact_2[84];
+    unchar            oem_contact_3[84];
+} gdth_oem_str;
+
+typedef struct {
+    gdth_oem_str_params  params;
+    gdth_oem_str             text;
+} gdth_oem_str_ioctl;
+
 /* board features */
 typedef struct {
     unchar      chaining;                       /* Chaining supported */
@@ -946,6 +1001,7 @@
 #if LINUX_VERSION_CODE >= 0x02015F
     spinlock_t          smp_lock;
 #endif
+    char		oem_name[8];
 } gdth_ha_str;
 
 /* structure for scsi_register(), SCSI bus != 0 */
diff -Nuar o/drivers/scsi/gdth_proc.c n/drivers/scsi/gdth_proc.c
--- o/drivers/scsi/gdth_proc.c	2004-01-07 19:28:08.000000000 +0100
+++ n/drivers/scsi/gdth_proc.c	2003-08-28 11:32:34.000000000 +0200
@@ -1464,7 +1464,7 @@
             timer_table[SCSI_TIMER].expires = jiffies + timeout;
             timer_active |= 1 << SCSI_TIMER;
         } else {
-            if (time_before(jiffies + timeout < timer_table[SCSI_TIMER].expires))
+            if (time_before(jiffies + timeout, timer_table[SCSI_TIMER].expires))
                 timer_table[SCSI_TIMER].expires = jiffies + timeout;
         }
     }


--------------060902000602000705050509--

