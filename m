From: Eric Sproul <esproul@ntelos.net>
Subject: [PATCH] gdth driver: selectively enable EISA/ISA/PCI support
Date: Fri, 26 Mar 2004 13:57:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080327459.14874.126.camel@thunderbolt.oss.ntelos.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-LOqsCaV7bXDNtGbYOngx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrtr01.ntelos.net ([216.12.0.101]:28376 "EHLO
	mailrtr01.ntelos.net") by vger.kernel.org with ESMTP
	id S262138AbUCZS5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 13:57:41 -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>
Cc: PA-RISC Linux <parisc-linux@lists.parisc-linux.org>


--=-LOqsCaV7bXDNtGbYOngx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,
I'm new here, but I was encouraged to post the following patch which
helped me get the gdth driver to compile on a PA-RISC system.  The
original driver assumes that EISA/ISA/PCI are all enabled, but on
PA-RISC there is no ISA (8237A) support, so compilation broke trying to
implement ISA-style DMA (DMA_MODE_CASCADE).

The following patch breaks out the bus-dependent portions of the driver
and only enables them when the corresponding CONFIG_ option is set.  For
example, this allows the driver to compile when only CONFIG_PCI is set.

ftp://ftp.parisc-linux.org/patches/diff-2.6.5-gdth-01
This patch was written by Grant Grundler <grundler@parisc-linux.org> and
tested by me.  Attached is a 2.4.25 version of the patch which I created
from Grant's 2.6.5 original.  He gets all the credit. ;)

Cheers,
Eric



--=-LOqsCaV7bXDNtGbYOngx
Content-Disposition: attachment; filename=gdth-2.6-noisa.patch
Content-Type: text/x-patch; name=gdth-2.6-noisa.patch; charset=
Content-Transfer-Encoding: 7bit

--- a/drivers/scsi/gdth.c	7 Feb 2004 14:02:43 -0000	1.8
+++ b/drivers/scsi/gdth.c	24 Mar 2004 17:19:06 -0000
@@ -401,16 +401,21 @@ static void gdth_copy_internal_data(int 
                                     char *buffer,ushort count);
 static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive);
-
+#ifdef CONFIG_EISA
 static int gdth_search_eisa(ushort eisa_adr);
+static int gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha);
+#endif
+#ifdef CONFIG_ISA
 static int gdth_search_isa(ulong32 bios_adr);
+static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
+#endif
+#ifdef CONFIG_PCI
 static int gdth_search_pci(gdth_pci_str *pcistr);
+static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
+static void gdth_sort_pci(gdth_pci_str *pcistr, int cnt);
+#endif
 static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt, 
                             ushort vendor, ushort dev);
-static void gdth_sort_pci(gdth_pci_str *pcistr, int cnt);
-static int gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha);
-static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
-static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
 
 static void gdth_enable_int(int hanum);
 static int gdth_get_status(unchar *pIStatus,int irq);
@@ -617,8 +622,10 @@ static void gdth_munmap(void *addr) 
 #endif
 
 
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
+#endif
 static unchar   gdth_polling;                           /* polling if TRUE */
 static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
 static int      wait_index,wait_hanum;                  /* gdth_wait() */
@@ -728,8 +735,11 @@ static int rescan = 0;
 static int virt_ctr = 0;
 /* shared access */
 static int shared_access = 1;
+
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 /* enable support for EISA and ISA controllers */
 static int probe_eisa_isa = 0;
+#endif
 
 #ifdef MODULE
 #if LINUX_VERSION_CODE >= 0x02011A
@@ -744,7 +754,9 @@ MODULE_PARM(max_ids, "i");
 MODULE_PARM(rescan, "i");
 MODULE_PARM(virt_ctr, "i");
 MODULE_PARM(shared_access, "i");
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 MODULE_PARM(probe_eisa_isa, "i");
+#endif
 MODULE_AUTHOR("Achim Leubner");
 #endif
 #if LINUX_VERSION_CODE >= 0x02040B
@@ -818,6 +830,7 @@ static void gdth_eval_mapping(ulong32 si
 
 /* controller search and initialization functions */
 
+#ifdef CONFIG_EISA
 GDTH_INITFUNC(static int, gdth_search_eisa(ushort eisa_adr))
 {
     ulong32 id;
@@ -834,8 +847,9 @@ GDTH_INITFUNC(static int, gdth_search_ei
 
     return 0;                                   
 }
+#endif
 
-
+#ifdef CONFIG_ISA
 GDTH_INITFUNC(static int, gdth_search_isa(ulong32 bios_adr))
 {
     void *addr;
@@ -850,8 +864,9 @@ GDTH_INITFUNC(static int, gdth_search_is
     }
     return 0;
 }
+#endif
 
-
+#ifdef CONFIG_PCI
 GDTH_INITFUNC(static int, gdth_search_pci(gdth_pci_str *pcistr))
 {
     ushort device, cnt;
@@ -872,6 +887,7 @@ GDTH_INITFUNC(static int, gdth_search_pc
                     PCI_DEVICE_ID_INTEL_SRC_XSCALE);
     return cnt;
 }
+#endif
 
 #if LINUX_VERSION_CODE >= 0x20363
 /* Vortex only makes RAID controllers.
@@ -1081,6 +1097,7 @@ GDTH_INITFUNC(static void, gdth_sort_pci
 }
 
 
+#ifdef CONFIG_EISA
 GDTH_INITFUNC(static int, gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha))
 {
     ulong32 retries,id;
@@ -1170,8 +1187,9 @@ GDTH_INITFUNC(static int, gdth_init_eisa
     }
     return 1;
 }
+#endif
 
-       
+#ifdef CONFIG_ISA
 GDTH_INITFUNC(static int, gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha))
 {
     register gdt2_dpram_str *dp2_ptr;
@@ -1268,8 +1286,9 @@ GDTH_INITFUNC(static int, gdth_init_isa(
     gdth_writeb(0xff, &dp2_ptr->io.irqdel);
     return 1;
 }
+#endif
 
-
+#ifdef CONFIG_PCI
 GDTH_INITFUNC(static int, gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha))
 {
     register gdt6_dpram_str *dp6_ptr;
@@ -1677,6 +1696,7 @@ GDTH_INITFUNC(static int, gdth_init_pci(
 
     return 1;
 }
+#endif
 
 
 /* controller protocol functions */
@@ -4145,8 +4165,10 @@ GDTH_INITFUNC(void, internal_setup(char 
             virt_ctr = val;
         else if (!strncmp(argv, "shared_access:", 14))
             shared_access = val;
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
         else if (!strncmp(argv, "probe_eisa_isa:", 15))
             probe_eisa_isa = val;
+#endif
         else if (!strncmp(argv, "reserve_list:", 13)) {
             reserve_list[0] = val;
             for (i = 1; i < MAX_RES_ARGS; i++) {
@@ -4193,8 +4215,6 @@ GDTH_INITFUNC(int, gdth_detect(Scsi_Host
 {
     struct Scsi_Host *shp;
     gdth_ha_str *ha;
-    ulong32 isa_bios;
-    ushort eisa_slot;
     int i,hanum,cnt,ctr;
     unchar b;
     
@@ -4227,8 +4247,12 @@ GDTH_INITFUNC(int, gdth_detect(Scsi_Host
     gdth_polling = TRUE; b = 0;
     gdth_clear_events();
 
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
     /* As default we do not probe for EISA or ISA controllers */
-    if (probe_eisa_isa) {    
+    if (probe_eisa_isa) {
+	ulong32 isa_bios;
+	ushort eisa_slot;
+
         /* scanning for controllers, at first: ISA controller */
         for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
             dma_addr_t scratch_dma_handle;
@@ -4473,6 +4497,7 @@ GDTH_INITFUNC(int, gdth_detect(Scsi_Host
             }
         }
     }
+#endif
 
     /* scanning for PCI controllers */
 #if LINUX_VERSION_CODE < 0x2015C

--=-LOqsCaV7bXDNtGbYOngx
Content-Disposition: attachment; filename=gdth-2.4.25-noisa.patch
Content-Type: text/x-patch; name=gdth-2.4.25-noisa.patch; charset=
Content-Transfer-Encoding: 7bit

--- drivers/scsi/gdth.c.orig	2003-08-30 02:01:42.000000000 -0400
+++ drivers/scsi/gdth.c	2004-03-25 08:42:07.000000000 -0500
@@ -380,16 +380,21 @@
 static void gdth_copy_internal_data(Scsi_Cmnd *scp,char *buffer,ushort count);
 static int gdth_internal_cache_cmd(int hanum,Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive);
-
+#ifdef CONFIG_EISA
 static int gdth_search_eisa(ushort eisa_adr);
+static int gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha);
+#endif
+#ifdef CONFIG_ISA
 static int gdth_search_isa(ulong32 bios_adr);
+static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
+#endif
+#ifdef CONFIG_PCI
 static int gdth_search_pci(gdth_pci_str *pcistr);
+static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
+static void gdth_sort_pci(gdth_pci_str *pcistr, int cnt);
+#endif
 static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt, 
                             ushort vendor, ushort dev);
-static void gdth_sort_pci(gdth_pci_str *pcistr, int cnt);
-static int gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha);
-static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
-static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
 
 static void gdth_enable_int(int hanum);
 static int gdth_get_status(unchar *pIStatus,int irq);
@@ -589,8 +594,10 @@
 #endif
 
 
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
+#endif
 static unchar   gdth_polling;                           /* polling if TRUE */
 static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
 static int      wait_index,wait_hanum;                  /* gdth_wait() */
@@ -687,6 +694,11 @@
 /* shared access */
 static int shared_access = 1;
 
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
+/* enable support for EISA and ISA controllers */
+static int probe_eisa_isa = 0;
+#endif
+
 #ifdef MODULE
 #if LINUX_VERSION_CODE >= 0x02011A
 /* parameters for modprobe/insmod */
@@ -700,6 +712,9 @@
 MODULE_PARM(rescan, "i");
 MODULE_PARM(virt_ctr, "i");
 MODULE_PARM(shared_access, "i");
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
+MODULE_PARM(probe_eisa_isa, "i");
+#endif
 MODULE_AUTHOR("Achim Leubner");
 #endif
 #if LINUX_VERSION_CODE >= 0x02040B
@@ -764,6 +779,7 @@
 
 /* controller search and initialization functions */
 
+#ifdef CONFIG_EISA
 GDTH_INITFUNC(static int, gdth_search_eisa(ushort eisa_adr))
 {
     ulong32 id;
@@ -780,8 +796,9 @@
 
     return 0;                                   
 }
+#endif
 
-
+#ifdef CONFIG_ISA
 GDTH_INITFUNC(static int, gdth_search_isa(ulong32 bios_adr))
 {
     void *addr;
@@ -796,8 +813,9 @@
     }
     return 0;
 }
+#endif
 
-
+#ifdef CONFIG_PCI
 GDTH_INITFUNC(static int, gdth_search_pci(gdth_pci_str *pcistr))
 {
     ushort device, cnt;
@@ -816,6 +834,7 @@
                     PCI_DEVICE_ID_INTEL_SRC);
     return cnt;
 }
+#endif
 
 #if LINUX_VERSION_CODE >= 0x20363
 /* Vortex only makes RAID controllers.
@@ -1024,6 +1043,7 @@
 }
 
 
+#ifdef CONFIG_EISA
 GDTH_INITFUNC(static int, gdth_init_eisa(ushort eisa_adr,gdth_ha_str *ha))
 {
     ulong32 retries,id;
@@ -1113,8 +1133,9 @@
     }
     return 1;
 }
+#endif
 
-       
+#ifdef CONFIG_ISA       
 GDTH_INITFUNC(static int, gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha))
 {
     register gdt2_dpram_str *dp2_ptr;
@@ -1211,8 +1232,9 @@
     gdth_writeb(0xff, &dp2_ptr->io.irqdel);
     return 1;
 }
+#endif
 
-
+#ifdef CONFIG_PCI
 GDTH_INITFUNC(static int, gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha))
 {
     register gdt6_dpram_str *dp6_ptr;
@@ -1612,6 +1634,7 @@
 
     return 1;
 }
+#endif
 
 
 /* controller protocol functions */
@@ -3943,6 +3966,10 @@
             virt_ctr = val;
         else if (!strncmp(argv, "shared_access:", 14))
             shared_access = val;
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
+	else if (!strncmp(argv, "probe_eisa_isa:", 15))
+	    probe_eisa_isa = val;
+#endif
         else if (!strncmp(argv, "reserve_list:", 13)) {
             reserve_list[0] = val;
             for (i = 1; i < MAX_RES_ARGS; i++) {
@@ -3989,8 +4016,6 @@
 {
     struct Scsi_Host *shp;
     gdth_ha_str *ha;
-    ulong32 isa_bios;
-    ushort eisa_slot;
     int i,hanum,cnt,ctr;
     unchar b;
     
@@ -4023,6 +4048,12 @@
     gdth_polling = TRUE; b = 0;
     gdth_clear_events();
 
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
+    /* As default we do not probe for EISA or ISA controllers */
+    if (probe_eisa_isa) {
+       ulong32 isa_bios;
+       ushort eisa_slot;
+
     /* scanning for controllers, at first: ISA controller */
     for (isa_bios=0xc8000UL; isa_bios<=0xd8000UL; isa_bios+=0x8000UL) {
         if (gdth_ctr_count >= MAXHA) 
@@ -4241,6 +4272,7 @@
             gdth_enable_int(hanum);
         }
     }
+#endif
 
     /* scanning for PCI controllers */
 #if LINUX_VERSION_CODE >= 0x2015C

--=-LOqsCaV7bXDNtGbYOngx--

