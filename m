From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 2/4: initialization reordering
Date: Thu, 6 Feb 2003 13:14:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03773C@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2CE0B.9C787FA0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h16IEhD24610
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:14:43 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA08651
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:14:41 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2CE0B.9C787FA0
Content-Type: text/plain;
	charset="iso-8859-1"

This large patch reworks much of the adapter initialization
code.

It splits the scsi initialization code from the pci
initialization.  It adds support for working with some
future cards.  It also removes the use of multiple pci_driver
registrations and instead does its own adapter ordering.

The patch was made against 2.5.59.

David Jeffery

 ips.c |  472
++++++++++++++++++++++++++++++++++++++++++++----------------------
 ips.h |  148 ++++++++++++--------
 2 files changed, 408 insertions(+), 212 deletions(-)


------_=_NextPart_000_01C2CE0B.9C787FA0
Content-Type: application/octet-stream;
	name="ips.patch2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips.patch2"

diff -ur linux-2.5.59_p1/drivers/scsi/ips.c =
linux-2.5.59_p2/drivers/scsi/ips.c=0A=
--- linux-2.5.59_p1/drivers/scsi/ips.c	Mon Jan 20 09:44:35 2003=0A=
+++ linux-2.5.59_p2/drivers/scsi/ips.c	Mon Jan 20 09:46:27 2003=0A=
@@ -6,7 +6,7 @@=0A=
 /*             David Jeffery, Adaptec, Inc.                            =
      */=0A=
 /*                                                                     =
      */=0A=
 /* Copyright (C) 2000 IBM Corporation                                  =
      */ =0A=
-/* Copyright (C) 2002 Adaptec, Inc.                                    =
      */ =0A=
+/* Copyright (C) 2002,2003 Adaptec, Inc.                               =
      */ =0A=
 /*                                                                     =
      */=0A=
 /* This program is free software; you can redistribute it and/or =
modify      */=0A=
 /* it under the terms of the GNU General Public License as published =
by      */=0A=
@@ -127,6 +127,9 @@=0A=
 /*          - Get rid on IOCTL_NEW_COMMAND code                        =
      */=0A=
 /*          - Add Extended DCDB Commands for Tape Support in 5I        =
      */=0A=
 /* 5.10.12  - use pci_dma interfaces, update for 2.5 kernel changes    =
      */=0A=
+/* 5.10.15  - remove unused code (sem, macros, etc.)                   =
      */=0A=
+/* 5.30.00  - use __devexit_p()                                        =
      */=0A=
+/* 6.00.00  - Add 6x Adapters and Battery Flash                        =
      */=0A=
 =
/***********************************************************************=
******/=0A=
 =0A=
 /*=0A=
@@ -191,14 +194,16 @@=0A=
 /*=0A=
  * DRIVER_VER=0A=
  */=0A=
-#define IPS_VERSION_HIGH        "5.10"=0A=
-#define IPS_VERSION_LOW         ".13-BETA "=0A=
+#define IPS_VERSION_HIGH        "5.99"=0A=
+#define IPS_VERSION_LOW         ".00-BETA"=0A=
+=0A=
 =0A=
 #if !defined(__i386__) && !defined(__ia64__)=0A=
    #error "This driver has only been tested on the x86/ia64 =
platforms"=0A=
 #endif=0A=
 =0A=
 #if LINUX_VERSION_CODE <=3D LinuxVersionCode(2,5,0)=0A=
+    #include "sd.h"=0A=
     #define IPS_SG_ADDRESS(sg)       ((sg)->address)=0A=
     #define IPS_LOCK_SAVE(lock,flags) =
spin_lock_irqsave(&io_request_lock,flags)=0A=
     #define IPS_UNLOCK_RESTORE(lock,flags) =
spin_unlock_irqrestore(&io_request_lock,flags)=0A=
@@ -241,34 +246,23 @@=0A=
 static int          ips_force_memio =3D 1;             /* Always use =
Memory Mapped I/O    */=0A=
 static int          ips_force_i2o =3D 1;               /* Always use =
I2O command delivery */=0A=
 static int          ips_ioctlsize =3D IPS_IOCTL_SIZE;  /* Size of the =
ioctl buffer        */=0A=
-static int          ips_cd_boot =3D 0;                 /* Booting from =
ServeRAID Manager CD */=0A=
+static int          ips_cd_boot =3D 0;                 /* Booting from =
Manager CD         */=0A=
 static char        *ips_FlashData =3D NULL;            /* CD Boot - =
Flash Data Buffer      */=0A=
-static long          ips_FlashDataInUse =3D 0;          /* CD Boot - =
Flash Data In Use Flag */=0A=
+static long         ips_FlashDataInUse =3D 0;          /* CD Boot - =
Flash Data In Use Flag */=0A=
 static uint32_t     MaxLiteCmds =3D 32;                /* Max Active =
Cmds for a Lite Adapter */  =0A=
+static Scsi_Host_Template ips_driver_template =3D IPS;=0A=
 =0A=
 IPS_DEFINE_COMPAT_TABLE( Compatable );               /* Version =
Compatability Table      */=0A=
 =0A=
 =0A=
-   /* This table describes any / all ServeRAID Adapters */=0A=
+   /* This table describes all ServeRAID Adapters */=0A=
    static struct  pci_device_id  ips_pci_table[]  __devinitdata =3D =
{=0A=
            { 0x1014, 0x002E, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },=0A=
            { 0x1014, 0x01BD, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },=0A=
+           { 0x9005, 0x0250, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },=0A=
            { 0, }=0A=
    };=0A=
 =0A=
-   /* This table describes only Sarasota ( ServeRAID 5i ) Adapters =
*/=0A=
-   static struct  pci_device_id  ips_pci_table_5i[]  __devinitdata =3D =
{=0A=
-                   { 0x1014, 0x01BD, PCI_ANY_ID, 0x259, 0, 0 },=0A=
-                   { 0x1014, 0x01BD, PCI_ANY_ID, 0x258, 0, 0 },=0A=
-                   { 0, }=0A=
-                   };   =0A=
-    =0A=
-   /* This table describes all i960 Adapters */=0A=
-   static struct  pci_device_id  ips_pci_table_i960[]  __devinitdata =
=3D {=0A=
-                   { 0x1014, 0x01BD, PCI_ANY_ID, PCI_ANY_ID, 0, 0 =
},=0A=
-                   { 0, }=0A=
-                   };   =0A=
-=0A=
    MODULE_DEVICE_TABLE( pci, ips_pci_table );=0A=
 =0A=
    static char ips_hot_plug_name[] =3D "ips";=0A=
@@ -283,27 +277,13 @@=0A=
        .remove		=3D __devexit_p(ips_remove_device),=0A=
    }; =0A=
            =0A=
-   struct pci_driver ips_pci_driver_5i =3D {=0A=
-       .name		=3D ips_hot_plug_name,=0A=
-       .id_table	=3D ips_pci_table_5i,=0A=
-       .probe		=3D ips_insert_device,=0A=
-       .remove		=3D __devexit_p(ips_remove_device),=0A=
-   };=0A=
-=0A=
-   struct pci_driver ips_pci_driver_i960 =3D {=0A=
-       .name		=3D ips_hot_plug_name,=0A=
-       .id_table	=3D ips_pci_table_i960,=0A=
-       .probe		=3D ips_insert_device,=0A=
-       .remove		=3D __devexit_p(ips_remove_device),=0A=
-   };=0A=
-=0A=
 =0A=
 /*=0A=
  * Necessary forward function protoypes=0A=
  */=0A=
 static int ips_halt(struct notifier_block *nb, ulong event, void =
*buf);=0A=
 =0A=
-#define MAX_ADAPTER_NAME 11=0A=
+#define MAX_ADAPTER_NAME 15=0A=
 =0A=
 static char ips_adapter_name[][30] =3D {=0A=
    "ServeRAID",=0A=
@@ -318,9 +298,12 @@=0A=
    "ServeRAID 4Mx",=0A=
    "ServeRAID 4Lx",=0A=
    "ServeRAID 5i",=0A=
-   "ServeRAID 5i"=0A=
+   "ServeRAID 5i",=0A=
+   "ServeRAID 00",=0A=
+   "ServeRAID 00"=0A=
 };=0A=
 =0A=
+=0A=
 static struct notifier_block ips_notifier =3D {=0A=
    ips_halt, NULL, 0=0A=
 };=0A=
@@ -390,9 +373,6 @@=0A=
 int ips_eh_abort(Scsi_Cmnd *);=0A=
 int ips_eh_reset(Scsi_Cmnd *);=0A=
 int ips_queue(Scsi_Cmnd *, void (*) (Scsi_Cmnd *));=0A=
-int ips_biosparam(struct scsi_device *, struct block_device *,=0A=
-		sector_t, int *);=0A=
-int ips_slave_configure(Scsi_Device *);=0A=
 const char * ips_info(struct Scsi_Host *);=0A=
 void do_ipsintr(int, void *, struct pt_regs *);=0A=
 static int ips_hainit(ips_ha_t *);=0A=
@@ -441,7 +421,6 @@=0A=
 static void ips_free_flash_copperhead(ips_ha_t *ha);=0A=
 static void ips_get_bios_version(ips_ha_t *, int);=0A=
 static void ips_identify_controller(ips_ha_t *);=0A=
-//static void ips_select_queue_depth(struct Scsi_Host *, Scsi_Device =
*);=0A=
 static void ips_chkstatus(ips_ha_t *, IPS_STATUS *);=0A=
 static void ips_enable_int_copperhead(ips_ha_t *);=0A=
 static void ips_enable_int_copperhead_memio(ips_ha_t *);=0A=
@@ -489,11 +468,11 @@=0A=
 static int copy_info(IPS_INFOSTR *, char *, ...);=0A=
 static int ips_get_version_info(ips_ha_t *ha, IPS_VERSION_DATA =
*Buffer, int intr );=0A=
 static void ips_version_check(ips_ha_t *ha, int intr);=0A=
-static int ips_abort_init(ips_ha_t *ha, struct Scsi_Host *sh, int =
index);=0A=
+static int ips_abort_init(ips_ha_t *ha, int index);=0A=
 static int ips_init_phase2( int index );=0A=
 =0A=
 static int ips_init_phase1( struct pci_dev *pci_dev, int *indexPtr =
);=0A=
-=0A=
+static int ips_register_scsi(int index);=0A=
 =
/*----------------------------------------------------------------------=
----*/=0A=
 /* Exported Functions                                                  =
     */=0A=
 =
/*----------------------------------------------------------------------=
----*/=0A=
@@ -562,6 +541,7 @@=0A=
 =
/***********************************************************************=
*****/=0A=
 int=0A=
 ips_detect(Scsi_Host_Template *SHT) {=0A=
+   int  i;=0A=
 =0A=
    METHOD_TRACE("ips_detect", 1);=0A=
 =0A=
@@ -570,36 +550,26 @@=0A=
       ips_setup(ips);=0A=
 #endif=0A=
 =0A=
-   /* If Booting from the ServeRAID Manager CD, Allocate a large Flash =
 */=0A=
-   /* Buffer ( so we won't need to allocate one for each adapter ).    =
 */=0A=
+   /* If Booting from the Manager CD, Allocate a large Flash        =
*/=0A=
+   /* Buffer ( so we won't need to allocate one for each adapter ). =
*/=0A=
     if ( ips_cd_boot ) {            =0A=
-      ips_FlashData =3D ( char * ) __get_free_pages( GFP_KERNEL, 7 );  =
 =0A=
+      ips_FlashData =3D ( char * ) __get_free_pages( GFP_ATOMIC, 7 );  =
 =0A=
       if (ips_FlashData =3D=3D NULL) {=0A=
          /* The validity of this pointer is checked in =
ips_make_passthru() before it is used */=0A=
          printk( KERN_WARNING "ERROR: Can't Allocate Large Buffer for =
Flashing\n" );=0A=
       }=0A=
    }                                                                   =
            =0A=
+   if (!pci_present())=0A=
+      return (0);=0A=
 =0A=
    SHT->proc_info =3D ips_proc_info;=0A=
    SHT->proc_name =3D "ips";=0A=
 =0A=
- #if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
-   spin_unlock_irq(&io_request_lock);=0A=
- #endif=0A=
-   /* By definition, a Sarasota ( 5i ) Adapter MUST be enumerated =
first or the */=0A=
-   /* server may not boot properly. The adapters must be enumerated in =
exactly */=0A=
-   /* the same order as ServeRAID BIOS for the machine to come up =
properly.    */=0A=
-=0A=
-   pci_module_init(&ips_pci_driver_5i);          /* Ask for 5i =
Adapters First  */=0A=
-   if (ips_num_controllers)                      /* If there is a 5i =
Adapter   */=0A=
-      pci_module_init(&ips_pci_driver_i960);     /*    Get all i960's =
next     */=0A=
-   pci_module_init(&ips_pci_driver);             /* Get all remaining =
Adapters */=0A=
-                                                 /*  ( in normal BUS =
order )   */=0A=
- #if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
-   spin_lock_irq(&io_request_lock);=0A=
- #endif=0A=
-   if (ips_num_controllers > 0) =0A=
-      register_reboot_notifier(&ips_notifier);=0A=
+   for(i =3D 0; i < ips_num_controllers; i++){=0A=
+      if ( ips_register_scsi(i) )=0A=
+         ips_free(ips_ha[i]);=0A=
+         ips_released_controllers++;=0A=
+   } =0A=
 =0A=
    return (ips_num_controllers);=0A=
 }=0A=
@@ -614,7 +584,7 @@=0A=
    /*                                =0A=
     * Setup Functions=0A=
     */=0A=
-   if (IPS_IS_MORPHEUS(ha)) {=0A=
+   if (IPS_IS_MORPHEUS(ha) || IPS_IS_MARCO(ha)) {=0A=
       /* morpheus / marco / sebring */=0A=
       ha->func.isintr =3D ips_isintr_morpheus;=0A=
       ha->func.isinit =3D ips_isinit_morpheus;=0A=
@@ -734,10 +704,6 @@=0A=
 =0A=
    ips_released_controllers++;=0A=
 =0A=
-   if (ips_num_controllers =3D=3D ips_released_controllers){=0A=
-      unregister_reboot_notifier(&ips_notifier);=0A=
-      pci_unregister_driver(&ips_pci_driver);=0A=
-   }=0A=
    return (FALSE);=0A=
 }=0A=
 =0A=
@@ -1167,7 +1133,7 @@=0A=
 /*   Set bios geometry for the controller                              =
     */=0A=
 /*                                                                     =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
-int=0A=
+static int=0A=
 ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,=0A=
 		sector_t capacity, int geom[]) {=0A=
    ips_ha_t         *ha;=0A=
@@ -1301,6 +1267,12 @@=0A=
    if (!ha) =0A=
       return;=0A=
    host =3D ips_sh[ha->host_num];=0A=
+   /* interrupt during initialization */=0A=
+   if(!host){=0A=
+      (*ha->func.intr)(ha);=0A=
+      return;=0A=
+   }=0A=
+=0A=
    IPS_LOCK_SAVE(host->host_lock, cpu_flags);=0A=
 =0A=
    if (!ha->active) {=0A=
@@ -2238,6 +2210,17 @@=0A=
       }=0A=
 =0A=
       break;=0A=
+=0A=
+   case IPS_DEVICEID_MARCO:=0A=
+      switch (ha->subdevice_id) {=0A=
+      case IPS_SUBDEVICEID_6M:=0A=
+          ha->ad_type =3D IPS_ADTYPE_SERVERAID6M;=0A=
+          break;=0A=
+      case IPS_SUBDEVICEID_6I:=0A=
+          ha->ad_type =3D IPS_ADTYPE_SERVERAID6I;=0A=
+          break;=0A=
+      }=0A=
+      break;=0A=
    }=0A=
 }=0A=
 =0A=
@@ -2470,6 +2453,10 @@=0A=
       return (0);=0A=
    }=0A=
 =0A=
+   /* If there are Logical Drives and a Reset Occurred, then an =
EraseStripeLock is Needed */=0A=
+   if ( (ha->conf->ucLogDriveCount > 0) && (ha->requires_esl =3D=3D 1) =
) =0A=
+      ips_clear_adapter(ha, IPS_INTR_IORL);=0A=
+   =0A=
    /* set limits on SID, LUN, BUS */=0A=
    ha->ntargets =3D IPS_MAX_TARGETS + 1;=0A=
    ha->nlun =3D 1;=0A=
@@ -4946,6 +4933,13 @@=0A=
    writel(Oimr, ha->mem_ptr + IPS_REG_I960_OIMR);=0A=
 =0A=
    /* if we get here then everything went OK */=0A=
+=0A=
+   /* Since we did a RESET, an EraseStripeLock may be needed */=0A=
+   if (Post =3D=3D 0xEF10) {=0A=
+      if ( (Config =3D=3D 0x000F) || (Config =3D=3D 0x0009) )=0A=
+         ha->requires_esl =3D 1;=0A=
+   }=0A=
+=0A=
    return (1);=0A=
 }=0A=
 =0A=
@@ -6598,20 +6592,185 @@=0A=
    return( rc );=0A=
 }=0A=
 =0A=
-  =0A=
-=0A=
-static Scsi_Host_Template driver_template =3D IPS;=0A=
-#include "scsi_module.c"=0A=
-=0A=
-static int ips_abort_init(ips_ha_t *ha, struct Scsi_Host *sh, int =
index){=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_abort_init                                        =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   cleanup routine for a failed adapter initialization               =
     */=0A=
+/**********************************************************************=
******/ =0A=
+static int ips_abort_init(ips_ha_t *ha, int index){=0A=
    ha->active =3D 0;=0A=
    ips_free(ha);=0A=
-   scsi_unregister(sh);=0A=
    ips_ha[index] =3D 0;=0A=
    ips_sh[index] =3D 0;=0A=
    return -1;=0A=
 }=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_shift_controllers                                 =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   helper function for ordering adapters                             =
     */=0A=
+/**********************************************************************=
******/=0A=
+static void=0A=
+ips_shift_controllers(int lowindex, int highindex){=0A=
+	ips_ha_t *ha_sav =3D ips_ha[highindex];=0A=
+	struct Scsi_Host *sh_sav =3D ips_sh[highindex];=0A=
+	int i;=0A=
+=0A=
+	for ( i =3D highindex; i > lowindex; i--){=0A=
+		ips_ha[i] =3D ips_ha[i - 1];=0A=
+		ips_sh[i] =3D ips_sh[i - 1];=0A=
+		ips_ha[i]->host_num =3D i;=0A=
+	}=0A=
+	ha_sav->host_num =3D lowindex;=0A=
+	ips_ha[lowindex] =3D ha_sav;=0A=
+	ips_sh[lowindex] =3D sh_sav;=0A=
+}=0A=
+=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_order_controllers                                 =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   place controllers is the "proper" boot order                      =
     */=0A=
+/**********************************************************************=
******/=0A=
+static void=0A=
+ips_order_controllers(void){=0A=
+	int i, j, tmp, position =3D 0;=0A=
+	IPS_NVRAM_P5 *nvram;=0A=
+	if(!ips_ha[0])=0A=
+		return;=0A=
+	nvram =3D ips_ha[0]->nvram;=0A=
+=0A=
+	if(nvram->adapter_order[0]){=0A=
+		for(i =3D 1; i <=3D nvram->adapter_order[0]; i++){=0A=
+			for(j =3D position; j < ips_num_controllers; j++){=0A=
+				switch(ips_ha[j]->ad_type){=0A=
+				case IPS_ADTYPE_SERVERAID6M:=0A=
+					if(nvram->adapter_order[i] =3D=3D 'M'){=0A=
+						ips_shift_controllers(position, j);=0A=
+						position++;=0A=
+					}=0A=
+					break;=0A=
+				case IPS_ADTYPE_SERVERAID4L:=0A=
+				case IPS_ADTYPE_SERVERAID4M:=0A=
+				case IPS_ADTYPE_SERVERAID4MX:=0A=
+				case IPS_ADTYPE_SERVERAID4LX:=0A=
+					if(nvram->adapter_order[i] =3D=3D 'N'){=0A=
+						ips_shift_controllers(position, j);=0A=
+						position++;=0A=
+					}=0A=
+					break;=0A=
+				case IPS_ADTYPE_SERVERAID6I:=0A=
+				case IPS_ADTYPE_SERVERAID5I2:=0A=
+				case IPS_ADTYPE_SERVERAID5I1:=0A=
+					if(nvram->adapter_order[i] =3D=3D 'S'){=0A=
+						ips_shift_controllers(position, j);=0A=
+						position++;=0A=
+					}=0A=
+					break;=0A=
+				case IPS_ADTYPE_SERVERAID:=0A=
+				case IPS_ADTYPE_SERVERAID2:=0A=
+				case IPS_ADTYPE_NAVAJO:=0A=
+				case IPS_ADTYPE_KIOWA:=0A=
+				case IPS_ADTYPE_SERVERAID3L:=0A=
+				case IPS_ADTYPE_SERVERAID3:=0A=
+				case IPS_ADTYPE_SERVERAID4H:=0A=
+					if(nvram->adapter_order[i] =3D=3D 'A'){=0A=
+						ips_shift_controllers(position, j);=0A=
+						position++;=0A=
+					}=0A=
+					break;=0A=
+				default:=0A=
+				}=0A=
+			}=0A=
+		}=0A=
+		/* if adapter_order[0], then ordering is complete */=0A=
+		return;=0A=
+	}=0A=
+	/* old bios, use older ordering */=0A=
+	tmp =3D 0;=0A=
+	for(i =3D position; i < ips_num_controllers; i++){=0A=
+		if (ips_ha[i]->ad_type =3D=3D IPS_ADTYPE_SERVERAID5I2 ||=0A=
+		    ips_ha[i]->ad_type =3D=3D IPS_ADTYPE_SERVERAID5I1){=0A=
+			ips_shift_controllers(position, i);=0A=
+			position++;=0A=
+			tmp =3D 1;=0A=
+		}=0A=
+	}=0A=
+	/* if there were no 5I cards, then don't do any extra ordering */=0A=
+	if (!tmp)=0A=
+		return;=0A=
+	for(i =3D position; i < ips_num_controllers; i++){=0A=
+		if (ips_ha[i]->ad_type =3D=3D IPS_ADTYPE_SERVERAID4L ||=0A=
+		    ips_ha[i]->ad_type =3D=3D IPS_ADTYPE_SERVERAID4M ||=0A=
+		    ips_ha[i]->ad_type =3D=3D IPS_ADTYPE_SERVERAID4LX ||=0A=
+		    ips_ha[i]->ad_type =3D=3D IPS_ADTYPE_SERVERAID4MX){=0A=
+			ips_shift_controllers(position, i);=0A=
+			position++;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return;=0A=
+}=0A=
+=0A=
+=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_register_scsi                                     =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   perform any registration and setup with the scsi layer            =
     */=0A=
+/**********************************************************************=
******/=0A=
+static int=0A=
+ips_register_scsi( int index){=0A=
+	struct Scsi_Host *sh;=0A=
+	ips_ha_t *ha, *oldha;=0A=
+	sh =3D scsi_register(&ips_driver_template, sizeof(ips_ha_t));=0A=
+	if(!sh) {=0A=
+		printk(KERN_WARNING "Unable to register controller with SCSI =
subsystem\n" );=0A=
+		return -1;=0A=
+	}=0A=
+	oldha =3D ips_ha[index];=0A=
+	ha =3D IPS_HA(sh);=0A=
+	memcpy(ha, oldha, sizeof(ips_ha_t));=0A=
+	free_irq(oldha->irq, oldha);=0A=
+	/* Install the interrupt handler with the new ha */=0A=
+	if (request_irq(ha->irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) {=0A=
+		printk(KERN_WARNING "Unable to install interrupt handler\n" );=0A=
+		scsi_unregister(sh);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	kfree(oldha);=0A=
+	ips_sh[index] =3D sh;=0A=
+	ips_ha[index] =3D ha;=0A=
+	scsi_set_pci_device(sh, ha->pcidev);=0A=
+=0A=
+	/* Store away needed values for later use */=0A=
+	sh->io_port =3D ha->io_addr;=0A=
+	sh->n_io_port =3D ha->io_addr ? 255 : 0;=0A=
+	sh->unique_id =3D (ha->io_addr) ? ha->io_addr : ha->mem_addr;=0A=
+	sh->irq =3D ha->irq;=0A=
+	sh->sg_tablesize =3D sh->hostt->sg_tablesize;=0A=
+	sh->can_queue =3D sh->hostt->can_queue;=0A=
+	sh->cmd_per_lun =3D sh->hostt->cmd_per_lun;=0A=
+	sh->unchecked_isa_dma =3D sh->hostt->unchecked_isa_dma;=0A=
+	sh->use_clustering =3D sh->hostt->use_clustering;=0A=
+=0A=
+#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,7)=0A=
+	sh->max_sectors =3D 128;=0A=
+#endif =0A=
 =0A=
+	sh->max_id =3D ha->ntargets;=0A=
+	sh->max_lun =3D ha->nlun;=0A=
+	sh->max_channel =3D ha->nbus - 1;=0A=
+	sh->can_queue =3D ha->max_cmds-1;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
 =0A=
 =
/*----------------------------------------------------------------------=
-----*/=0A=
 /*   Routine Name: ips_remove_device                                   =
      */=0A=
@@ -6637,6 +6796,43 @@=0A=
    }=0A=
 }=0A=
 =0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_module_init                                       =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   function called on module load                                    =
     */=0A=
+/**********************************************************************=
******/=0A=
+static int __init=0A=
+ips_module_init(void){=0A=
+	if( pci_module_init(&ips_pci_driver) < 0 )=0A=
+		return -ENODEV;=0A=
+	ips_driver_template.module =3D THIS_MODULE;=0A=
+	ips_order_controllers();=0A=
+	if( scsi_register_host(&ips_driver_template) ){=0A=
+		pci_unregister_driver(&ips_pci_driver);=0A=
+		return -ENODEV;=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_module_exit                                       =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   function called on module unload                                  =
     */=0A=
+/**********************************************************************=
******/=0A=
+static void __exit=0A=
+ips_module_exit(void){=0A=
+	scsi_unregister_host(&ips_driver_template);=0A=
+	pci_unregister_driver(&ips_pci_driver);=0A=
+	unregister_reboot_notifier(&ips_notifier);=0A=
+}=0A=
+=0A=
+module_init(ips_module_init);=0A=
+module_exit(ips_module_exit);=0A=
 =0A=
 =
/*----------------------------------------------------------------------=
-----*/=0A=
 /*   Routine Name: ips_insert_device                                   =
      */=0A=
@@ -6679,7 +6875,6 @@=0A=
 =
/*----------------------------------------------------------------------=
-----*/=0A=
 static int ips_init_phase1( struct pci_dev *pci_dev, int *indexPtr =
)=0A=
 {         =0A=
-   struct Scsi_Host *sh;=0A=
    ips_ha_t         *ha;=0A=
    uint32_t          io_addr;=0A=
    uint32_t          mem_addr;=0A=
@@ -6770,35 +6965,47 @@=0A=
     subdevice_id =3D pci_dev->subsystem_device;=0A=
 =0A=
     /* found a controller */=0A=
-    sh =3D scsi_register(&driver_template, sizeof(ips_ha_t));=0A=
-#if LINUX_VERSION_CODE > LinuxVersionCode(2,5,0) =0A=
-    pci_set_dma_mask(pci_dev, (u64)0xffffffff);=0A=
-    scsi_set_pci_device(sh, pci_dev);=0A=
-#endif=0A=
-    if (sh =3D=3D NULL) {=0A=
-       printk(KERN_WARNING "Unable to register controller with SCSI =
subsystem\n" );=0A=
+    ha =3D kmalloc(sizeof(ips_ha_t), GFP_KERNEL);=0A=
+    if (ha =3D=3D NULL) {=0A=
+       printk(KERN_WARNING "Unable to allocate temporary ha struct\n" =
);=0A=
        return -1;=0A=
     }=0A=
 =0A=
-    ha =3D IPS_HA(sh);=0A=
     memset(ha, 0, sizeof(ips_ha_t));=0A=
     =0A=
-    ips_sh[index] =3D sh;=0A=
+    ips_sh[index] =3D NULL;=0A=
     ips_ha[index] =3D ha;=0A=
     ha->active =3D 1;=0A=
 =0A=
+    /* Store info in HA structure */=0A=
+    ha->irq =3D irq;=0A=
+    ha->io_addr =3D io_addr;=0A=
+    ha->io_len =3D io_len;=0A=
+    ha->mem_addr =3D mem_addr;=0A=
+    ha->mem_len =3D mem_len;=0A=
+    ha->mem_ptr =3D mem_ptr;=0A=
+    ha->ioremap_ptr =3D ioremap_ptr;=0A=
+    ha->host_num =3D ( uint32_t) index;=0A=
+    ha->revision_id =3D revision_id;=0A=
+    ha->slot_num =3D PCI_SLOT(pci_dev->devfn);=0A=
+    ha->device_id =3D pci_dev->device;=0A=
+    ha->subdevice_id =3D subdevice_id;=0A=
+    ha->pcidev =3D pci_dev;=0A=
+=0A=
+    pci_set_dma_mask(ha->pcidev, (u64)0xffffffff);=0A=
+=0A=
     ha->enq =3D kmalloc(sizeof(IPS_ENQ), GFP_KERNEL);=0A=
 =0A=
     if (!ha->enq) {=0A=
        printk(KERN_WARNING "Unable to allocate host inquiry =
structure\n" );=0A=
-       return ips_abort_init(ha, sh, index);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     ha->adapt =3D pci_alloc_consistent(pci_dev, sizeof(IPS_ADAPTER) =
+=0A=
                                      sizeof(IPS_IO_CMD), =
&dma_address);=0A=
     if (!ha->adapt) {=0A=
        printk(KERN_WARNING "Unable to allocate host adapt & dummy =
structures\n");=0A=
-       return ips_abort_init(ha, sh, index);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
     ha->adapt->hw_status_start =3D dma_address;=0A=
     ha->dummy =3D (void *)(ha->adapt + 1);=0A=
@@ -6807,21 +7014,21 @@=0A=
 =0A=
     if (!ha->conf) {=0A=
        printk(KERN_WARNING "Unable to allocate host conf structure\n" =
);=0A=
-       return ips_abort_init(ha, sh, index);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     ha->nvram =3D kmalloc(sizeof(IPS_NVRAM_P5), GFP_KERNEL);=0A=
 =0A=
     if (!ha->nvram) {=0A=
        printk(KERN_WARNING "Unable to allocate host NVRAM structure\n" =
);=0A=
-       return ips_abort_init(ha, sh, index);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     ha->subsys =3D kmalloc(sizeof(IPS_SUBSYS), GFP_KERNEL);=0A=
 =0A=
     if (!ha->subsys) {=0A=
        printk(KERN_WARNING "Unable to allocate host subsystem =
structure\n" );=0A=
-       return ips_abort_init(ha, sh, index);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     for (count =3D PAGE_SIZE, ha->ioctl_order =3D 0;=0A=
@@ -6838,49 +7045,19 @@=0A=
        ha->ioctl_datasize =3D 0;=0A=
     }=0A=
 =0A=
-    /* Store away needed values for later use */=0A=
-    sh->io_port =3D io_addr;=0A=
-    sh->n_io_port =3D io_addr ? 255 : 0;=0A=
-    sh->unique_id =3D (io_addr) ? io_addr : mem_addr;=0A=
-    sh->irq =3D irq;=0A=
-    //sh->select_queue_depths =3D ips_select_queue_depth;=0A=
-    sh->sg_tablesize =3D sh->hostt->sg_tablesize;=0A=
-    sh->can_queue =3D sh->hostt->can_queue;=0A=
-    sh->cmd_per_lun =3D sh->hostt->cmd_per_lun;=0A=
-    sh->unchecked_isa_dma =3D sh->hostt->unchecked_isa_dma;=0A=
-    sh->use_clustering =3D sh->hostt->use_clustering;=0A=
-=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,7)=0A=
-    sh->max_sectors =3D 128;=0A=
-#endif                      =0A=
-=0A=
-    /* Store info in HA structure */=0A=
-    ha->irq =3D irq;=0A=
-    ha->io_addr =3D io_addr;=0A=
-    ha->io_len =3D io_len;=0A=
-    ha->mem_addr =3D mem_addr;=0A=
-    ha->mem_len =3D mem_len;=0A=
-    ha->mem_ptr =3D mem_ptr;=0A=
-    ha->ioremap_ptr =3D ioremap_ptr;=0A=
-    ha->host_num =3D ( uint32_t) index;=0A=
-    ha->revision_id =3D revision_id;=0A=
-    ha->slot_num =3D PCI_SLOT(pci_dev->devfn);=0A=
-    ha->device_id =3D pci_dev->device;=0A=
-    ha->subdevice_id =3D subdevice_id;=0A=
-    ha->pcidev =3D pci_dev;=0A=
-=0A=
     /*=0A=
      * Setup Functions=0A=
      */=0A=
     ips_setup_funclist(ha);=0A=
 =0A=
-    if ( IPS_IS_MORPHEUS( ha ) ) {=0A=
+    if ( ( IPS_IS_MORPHEUS( ha ) ) || ( IPS_IS_MARCO( ha ) ) ) {=0A=
         /* If Morpheus appears dead, reset it */=0A=
         IsDead =3D readl( ha->mem_ptr + IPS_REG_I960_MSG1 );=0A=
         if ( IsDead =3D=3D 0xDEADBEEF ) {=0A=
             ips_reset_morpheus( ha );=0A=
         }=0A=
     }=0A=
+=0A=
     /*=0A=
      * Initialize the card if it isn't already=0A=
      */=0A=
@@ -6891,31 +7068,14 @@=0A=
            * Initialization failed=0A=
            */=0A=
           printk(KERN_WARNING "Unable to initialize controller\n" =
);=0A=
-          return ips_abort_init(ha, sh, index);=0A=
+          return ips_abort_init(ha, index);=0A=
        }=0A=
     }=0A=
 =0A=
-    /* Install the interrupt handler */=0A=
-     if (request_irq(irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) {=0A=
-       printk(KERN_WARNING "Unable to install interrupt handler\n" =
);=0A=
-       return ips_abort_init(ha, sh, index);=0A=
-    }=0A=
-=0A=
-    /*=0A=
-     * Allocate a temporary SCB for initialization=0A=
-     */=0A=
-    ha->max_cmds =3D 1;=0A=
-    if (!ips_allocatescbs(ha)) {=0A=
-       printk(KERN_WARNING "Unable to allocate a CCB\n" );=0A=
-       free_irq(ha->irq, ha);=0A=
-       return ips_abort_init(ha, sh, index);=0A=
-    }=0A=
-=0A=
     *indexPtr =3D index;=0A=
     return SUCCESS;=0A=
 }=0A=
 =0A=
-=0A=
 =
/*----------------------------------------------------------------------=
-----*/=0A=
 /*   Routine Name: ips_init_phase2                                     =
      */=0A=
 /*                                                                     =
      */=0A=
@@ -6927,24 +7087,36 @@=0A=
 =
/*----------------------------------------------------------------------=
-----*/=0A=
 static int ips_init_phase2( int index )=0A=
 {         =0A=
-    struct Scsi_Host *sh;=0A=
     ips_ha_t         *ha;=0A=
 =0A=
     ha =3D ips_ha[index];=0A=
-    sh =3D ips_sh[index];=0A=
 =0A=
     METHOD_TRACE("ips_init_phase2", 1);=0A=
     if (!ha->active) {=0A=
-       scsi_unregister(sh);=0A=
        ips_ha[index] =3D NULL;=0A=
-       ips_sh[index] =3D NULL;=0A=
-       return -1;;=0A=
+       return -1;=0A=
+    }=0A=
+=0A=
+    /* Install the interrupt handler */=0A=
+     if (request_irq(ha->irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) =
{=0A=
+       printk(KERN_WARNING "Unable to install interrupt handler\n" =
);=0A=
+       return ips_abort_init(ha, index);=0A=
+    }=0A=
+=0A=
+    /*=0A=
+     * Allocate a temporary SCB for initialization=0A=
+     */=0A=
+    ha->max_cmds =3D 1;=0A=
+    if (!ips_allocatescbs(ha)) {=0A=
+       printk(KERN_WARNING "Unable to allocate a CCB\n" );=0A=
+       free_irq(ha->irq, ha);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     if (!ips_hainit(ha)) {=0A=
        printk(KERN_WARNING "Unable to initialize controller\n" );=0A=
        free_irq(ha->irq, ha);=0A=
-       return ips_abort_init(ha, sh, index);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
     /* Free the temporary SCB */=0A=
     ips_deallocatescbs(ha, 1);=0A=
@@ -6953,20 +7125,16 @@=0A=
     if (!ips_allocatescbs(ha)) {=0A=
        printk(KERN_WARNING "Unable to allocate CCBs\n" );=0A=
        free_irq(ha->irq, ha);=0A=
-       return ips_abort_init(ha, sh, index);=0A=
+       return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
-    /* finish setting values */=0A=
-    sh->max_id =3D ha->ntargets;=0A=
-    sh->max_lun =3D ha->nlun;=0A=
-    sh->max_channel =3D ha->nbus - 1;=0A=
-    sh->can_queue =3D ha->max_cmds-1;=0A=
-=0A=
     return SUCCESS;=0A=
 }=0A=
 =0A=
 =0A=
+#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,9)=0A=
 MODULE_LICENSE("GPL");=0A=
+#endif=0A=
 =0A=
 /*=0A=
  * Overrides for Emacs so that we almost follow Linus's tabbing =
style.=0A=
diff -ur linux-2.5.59_p1/drivers/scsi/ips.h =
linux-2.5.59_p2/drivers/scsi/ips.h=0A=
--- linux-2.5.59_p1/drivers/scsi/ips.h	Mon Jan 20 09:45:04 2003=0A=
+++ linux-2.5.59_p2/drivers/scsi/ips.h	Mon Jan 20 09:46:27 2003=0A=
@@ -59,8 +59,6 @@=0A=
    extern int ips_eh_abort(Scsi_Cmnd *);=0A=
    extern int ips_eh_reset(Scsi_Cmnd *);=0A=
    extern int ips_queue(Scsi_Cmnd *, void (*) (Scsi_Cmnd *));=0A=
-   extern int ips_biosparam(struct scsi_device *, struct block_device =
*,=0A=
-		   sector_t, int *);=0A=
    extern int ips_slave_configure(Scsi_Device *);=0A=
    extern const char * ips_info(struct Scsi_Host *);=0A=
    extern void do_ips(int, void *, struct pt_regs *);=0A=
@@ -81,18 +79,32 @@=0A=
                                          (ha->revision_id >=3D =
IPS_REVID_CLARINETP1) && \=0A=
                                          (ha->revision_id <=3D =
IPS_REVID_CLARINETP3)) ? 1 : 0)=0A=
    #define IPS_IS_MORPHEUS(ha)         (ha->device_id =3D=3D =
IPS_DEVICEID_MORPHEUS)=0A=
+   #define IPS_IS_MARCO(ha)            (ha->device_id =3D=3D =
IPS_DEVICEID_MARCO)=0A=
    #define IPS_USE_I2O_DELIVER(ha)     ((IPS_IS_MORPHEUS(ha) || \=0A=
                                          (IPS_IS_TROMBONE(ha) && \=0A=
                                           (ips_force_i2o))) ? 1 : =
0)=0A=
-   #define IPS_USE_I2O_STATUS(ha)      (IPS_IS_MORPHEUS(ha))=0A=
    #define IPS_USE_MEMIO(ha)           ((IPS_IS_MORPHEUS(ha) || \=0A=
                                          ((IPS_IS_TROMBONE(ha) || =
IPS_IS_CLARINET(ha)) && \=0A=
                                           (ips_force_memio))) ? 1 : =
0)=0A=
 =0A=
+   #if LINUX_VERSION_CODE < LinuxVersionCode(2,4,4)=0A=
+      #define pci_set_dma_mask(dev,mask) (1)=0A=
+      #define scsi_set_pci_device(sh,dev) (0)=0A=
+   #endif=0A=
+=0A=
+   #if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
+      #define scsi_register_host(x)    =
scsi_register_module(MODULE_SCSI_HA,x)=0A=
+      #define scsi_unregister_host(x)  =
scsi_unregister_module(MODULE_SCSI_HA,x)=0A=
+   #endif=0A=
+=0A=
    #ifndef MDELAY=0A=
       #define MDELAY mdelay=0A=
    #endif=0A=
-   =0A=
+=0A=
+   #ifndef min=0A=
+      #define min(x,y) ((x) < (y) ? x : y)=0A=
+   #endif=0A=
+=0A=
    /*=0A=
     * Adapter address map equates=0A=
     */=0A=
@@ -152,7 +164,7 @@=0A=
    #define IPS_CMD_DCDB                 0x04=0A=
    #define IPS_CMD_DCDB_SG              0x84=0A=
    #define IPS_CMD_EXTENDED_DCDB 	    0x95=0A=
-	#define IPS_CMD_EXTENDED_DCDB_SG		 0x96=0A=
+   #define IPS_CMD_EXTENDED_DCDB_SG	    0x96=0A=
    #define IPS_CMD_CONFIG_SYNC          0x58=0A=
    #define IPS_CMD_ERROR_TABLE          0x17=0A=
    #define IPS_CMD_DOWNLOAD             0x20=0A=
@@ -166,6 +178,7 @@=0A=
    #define IPS_CSL                      0xFF=0A=
    #define IPS_POCL                     0x30=0A=
    #define IPS_NORM_STATE               0x00=0A=
+   #define IPS_MAX_ADAPTER_TYPES        3=0A=
    #define IPS_MAX_ADAPTERS             16=0A=
    #define IPS_MAX_IOCTL                1=0A=
    #define IPS_MAX_IOCTL_QUEUE          8=0A=
@@ -188,15 +201,19 @@=0A=
    #define IPS_INTR_IORL                1=0A=
    #define IPS_FFDC                     99=0A=
    #define IPS_ADAPTER_ID               0xF=0A=
-   #define IPS_VENDORID                 0x1014=0A=
+   #define IPS_VENDORID_IBM             0x1014=0A=
+   #define IPS_VENDORID_ADAPTEC         0x9005=0A=
    #define IPS_DEVICEID_COPPERHEAD      0x002E=0A=
    #define IPS_DEVICEID_MORPHEUS        0x01BD=0A=
+   #define IPS_DEVICEID_MARCO           0x0250=0A=
    #define IPS_SUBDEVICEID_4M           0x01BE=0A=
    #define IPS_SUBDEVICEID_4L           0x01BF=0A=
    #define IPS_SUBDEVICEID_4MX          0x0208=0A=
    #define IPS_SUBDEVICEID_4LX          0x020E=0A=
    #define IPS_SUBDEVICEID_5I2          0x0259=0A=
    #define IPS_SUBDEVICEID_5I1          0x0258=0A=
+   #define IPS_SUBDEVICEID_6M           0x0279=0A=
+   #define IPS_SUBDEVICEID_6I           0x028C=0A=
    #define IPS_IOCTL_SIZE               8192=0A=
    #define IPS_STATUS_SIZE              4=0A=
    #define IPS_STATUS_Q_SIZE            (IPS_MAX_CMDS+1) * =
IPS_STATUS_SIZE=0A=
@@ -279,6 +296,8 @@=0A=
    #define IPS_ADTYPE_SERVERAID4LX      0x0B=0A=
    #define IPS_ADTYPE_SERVERAID5I2      0x0C=0A=
    #define IPS_ADTYPE_SERVERAID5I1      0x0D=0A=
+   #define IPS_ADTYPE_SERVERAID6M       0x0E=0A=
+   #define IPS_ADTYPE_SERVERAID6I       0x0F=0A=
 =0A=
    /*=0A=
     * Adapter Command/Status Packet Definitions=0A=
@@ -350,6 +369,12 @@=0A=
    #define IPS_SCSI_MP3_AllocateSurface 0x08=0A=
 =0A=
    /*=0A=
+    * HA Flags=0A=
+    */=0A=
+=0A=
+   #define IPS_HA_ENH_SG                0x1=0A=
+=0A=
+   /*=0A=
     * SCB Flags=0A=
     */=0A=
    #define IPS_SCB_MAP_SG               0x00008=0A=
@@ -387,34 +412,31 @@=0A=
     * Scsi_Host Template=0A=
     */=0A=
 #if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
-#define IPS{	\=0A=
-	.module				=3D NULL,		\=0A=
-	.proc_info			=3D NULL,		\=0A=
-	.name				=3D NULL,		\=0A=
+   static void ips_select_queue_depth(struct Scsi_Host *, Scsi_Device =
*);=0A=
+   static int ips_biosparam(Disk *disk, kdev_t dev, int geom[]);=0A=
+#define IPS {	\=0A=
 	.detect				=3D ips_detect,	\=0A=
 	.release			=3D ips_release,	\=0A=
 	.info				=3D ips_info,	\=0A=
-	.command			=3D NULL,		\=0A=
 	.queuecommand			=3D ips_queue,	\=0A=
-	.eh_strategy_handler		=3D NULL,		\=0A=
 	.eh_abort_handler		=3D ips_eh_abort,	\=0A=
-	.eh_device_reset_handler	=3D NULL,		\=0A=
-	.eh_bus_reset_handler		=3D NULL,		\=0A=
 	.eh_host_reset_handler		=3D ips_eh_reset,	\=0A=
-	.abort				=3D NULL,		\=0A=
-	.reset				=3D NULL,		\=0A=
-	.slave_attach			=3D NULL,		\=0A=
 	.bios_param			=3D ips_biosparam,\=0A=
+	.select_queue_depths		=3D ips_select_queue_depth, \=0A=
 	.can_queue			=3D 0,		\=0A=
 	.this_id			=3D -1,		\=0A=
 	.sg_tablesize			=3D IPS_MAX_SG,	\=0A=
-	.cmd_per_lun			=3D 3,		\=0A=
+	.cmd_per_lun			=3D 16,		\=0A=
 	.present			=3D 0,		\=0A=
 	.unchecked_isa_dma		=3D 0,		\=0A=
 	.use_clustering			=3D ENABLE_CLUSTERING,\=0A=
-	.use_new_eh_code		=3D 1 \=0A=
+	.use_new_eh_code		=3D 1, \=0A=
+	IPS_HIGHMEM_IO \=0A=
 }=0A=
 #else=0A=
+   static int ips_biosparam(struct scsi_device *sdev, struct =
block_device *bdev,=0A=
+		sector_t capacity, int geom[]);=0A=
+   int ips_slave_configure(Scsi_Device *SDptr);=0A=
 #define IPS {	\=0A=
 	.detect			=3D ips_detect,		\=0A=
 	.release		=3D ips_release,		\=0A=
@@ -790,7 +812,8 @@=0A=
    uint8_t   ReservedForOS2[8];=0A=
    uint8_t   bios_high[4];                 /* Adapter's Flashed BIOS =
Version   */=0A=
    uint8_t   bios_low[4];=0A=
-   uint8_t   Filler[76];=0A=
+   uint8_t   adapter_order[16];            /* BIOS Telling us the Sort =
Order   */=0A=
+   uint8_t   Filler[60];=0A=
 } IPS_NVRAM_P5, *PIPS_NVRAM_P5;=0A=
 =0A=
 =
/*----------------------------------------------------------------------=
----*/=0A=
@@ -1050,7 +1073,6 @@=0A=
    uint8_t            slot_num;           /* PCI Slot Number           =
 */=0A=
    uint16_t           subdevice_id;       /* Subsystem device ID       =
 */=0A=
    uint8_t            ioctl_order;        /* Number of pages in ioctl  =
 */=0A=
-   uint8_t            reserved2;          /* Empty                     =
 */=0A=
    uint8_t            bios_version[8];    /* BIOS Revision             =
 */=0A=
    uint32_t           mem_addr;           /* Memory mapped address     =
 */=0A=
    uint32_t           io_len;             /* Size of IO Address        =
 */=0A=
@@ -1060,8 +1082,9 @@=0A=
    ips_hw_func_t      func;               /* hw function pointers      =
 */=0A=
    struct pci_dev    *pcidev;             /* PCI device handle         =
 */=0A=
    char              *flash_data;         /* Save Area for flash data  =
 */=0A=
-   u8                 flash_order;        /* Save Area for flash size =
order  */=0A=
-   u32                flash_datasize;   /* Save Area for flash data =
size */=0A=
+   u8                 flash_order;        /* Save Area for flash size =
order */=0A=
+   u32                flash_datasize;     /* Save Area for flash data =
size */=0A=
+   uint8_t            requires_esl;       /* Requires an =
EraseStripeLock */=0A=
 } ips_ha_t;=0A=
 =0A=
 typedef void (*ips_scb_callback) (ips_ha_t *, struct ips_scb *);=0A=
@@ -1148,58 +1171,63 @@=0A=
 =0A=
 #define IPS_VER_MAJOR 5=0A=
 #define IPS_VER_MAJOR_STRING "5"=0A=
-#define IPS_VER_MINOR 10=0A=
-#define IPS_VER_MINOR_STRING "10"=0A=
-#define IPS_VER_BUILD_STRING "13"=0A=
-#define IPS_VER_STRING  "5.10.13-BETA"=0A=
-#define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002. =
All Rights Reserved."=0A=
-#define IPS_NT_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, =
2002."=0A=
+#define IPS_VER_MINOR 99=0A=
+#define IPS_VER_MINOR_STRING "99"=0A=
+#define IPS_VER_BUILD 00=0A=
+#define IPS_VER_BUILD_STRING "00"=0A=
+#define IPS_VER_STRING "5.99.00"=0A=
 =0A=
 /* Version numbers for various adapters */=0A=
-#define IPS_VER_SERVERAID1    "2.25.01"=0A=
-#define IPS_VER_SERVERAID2    "2.88.13"=0A=
-#define IPS_VER_NAVAJO        "2.88.13"=0A=
-#define IPS_VER_SERVERAID3    "5.10.01"=0A=
-#define IPS_VER_SERVERAID4H   "5.10.01"=0A=
-#define IPS_VER_SERVERAID4MLx "5.10.01"=0A=
-#define IPS_VER_SARASOTA      "5.10.05"=0A=
+#define IPS_VER_SERVERAID1 "2.25.01"=0A=
+#define IPS_VER_SERVERAID2 "2.88.13"=0A=
+#define IPS_VER_NAVAJO "2.88.13"=0A=
+#define IPS_VER_SERVERAID3 "5.11.05"=0A=
+#define IPS_VER_SERVERAID4H "5.11.05"=0A=
+#define IPS_VER_SERVERAID4MLx "5.11.05"=0A=
+#define IPS_VER_SARASOTA "5.11.05"=0A=
+#define IPS_VER_MARCO "0.00.00"=0A=
+#define IPS_VER_SEBRING "0.00.00"=0A=
 =0A=
 /* Compatability IDs for various adapters */=0A=
-#define IPS_COMPAT_UNKNOWN      ""=0A=
-#define IPS_COMPAT_CURRENT      "SA510"=0A=
-#define IPS_COMPAT_SERVERAID1   "2.25.01"=0A=
-#define IPS_COMPAT_SERVERAID2   "2.88.13"=0A=
-#define IPS_COMPAT_NAVAJO       "2.88.13"=0A=
-#define IPS_COMPAT_KIOWA        "2.88.13"=0A=
-#define IPS_COMPAT_SERVERAID3H  "5.10.01"=0A=
-#define IPS_COMPAT_SERVERAID3L  "5.10.01"=0A=
-#define IPS_COMPAT_SERVERAID4H  "5.10.01"=0A=
+#define IPS_COMPAT_UNKNOWN ""=0A=
+#define IPS_COMPAT_CURRENT "SB610"=0A=
+#define IPS_COMPAT_SERVERAID1 "2.25.01"=0A=
+#define IPS_COMPAT_SERVERAID2 "2.88.13"=0A=
+#define IPS_COMPAT_NAVAJO  "2.88.13"=0A=
+#define IPS_COMPAT_KIOWA "2.88.13"=0A=
+#define IPS_COMPAT_SERVERAID3H  "SA510"=0A=
+#define IPS_COMPAT_SERVERAID3L  "SA510"=0A=
+#define IPS_COMPAT_SERVERAID4H  "SA510"=0A=
 #define IPS_COMPAT_SERVERAID4M  "SA510"=0A=
 #define IPS_COMPAT_SERVERAID4L  "SA510"=0A=
 #define IPS_COMPAT_SERVERAID4Mx "SA510"=0A=
 #define IPS_COMPAT_SERVERAID4Lx "SA510"=0A=
 #define IPS_COMPAT_SARASOTA     "SA510"=0A=
-#define IPS_COMPAT_BIOS         "SA510"=0A=
+#define IPS_COMPAT_MARCO        "SA000"=0A=
+#define IPS_COMPAT_SEBRING      "SA000"=0A=
+#define IPS_COMPAT_BIOS "SA510"=0A=
 =0A=
-#define IPS_COMPAT_MAX_ADAPTER_TYPE 14=0A=
-#define IPS_COMPAT_ID_LENGTH         8=0A=
+#define IPS_COMPAT_MAX_ADAPTER_TYPE 16=0A=
+#define IPS_COMPAT_ID_LENGTH 8=0A=
 =0A=
 #define IPS_DEFINE_COMPAT_TABLE(tablename) \=0A=
    char tablename[IPS_COMPAT_MAX_ADAPTER_TYPE] [IPS_COMPAT_ID_LENGTH] =
=3D { \=0A=
-      IPS_COMPAT_UNKNOWN,      \=0A=
-      IPS_COMPAT_SERVERAID1,   \=0A=
-      IPS_COMPAT_SERVERAID2,   \=0A=
-      IPS_COMPAT_NAVAJO,       \=0A=
-      IPS_COMPAT_KIOWA,        \=0A=
-      IPS_COMPAT_SERVERAID3H,  \=0A=
-      IPS_COMPAT_SERVERAID3L,  \=0A=
-      IPS_COMPAT_SERVERAID4H,  \=0A=
-      IPS_COMPAT_SERVERAID4M,  \=0A=
-      IPS_COMPAT_SERVERAID4L,  \=0A=
+      IPS_COMPAT_UNKNOWN, \=0A=
+      IPS_COMPAT_SERVERAID1, \=0A=
+      IPS_COMPAT_SERVERAID2, \=0A=
+      IPS_COMPAT_NAVAJO, \=0A=
+      IPS_COMPAT_KIOWA, \=0A=
+      IPS_COMPAT_SERVERAID3H, \=0A=
+      IPS_COMPAT_SERVERAID3L, \=0A=
+      IPS_COMPAT_SERVERAID4H, \=0A=
+      IPS_COMPAT_SERVERAID4M, \=0A=
+      IPS_COMPAT_SERVERAID4L, \=0A=
       IPS_COMPAT_SERVERAID4Mx, \=0A=
       IPS_COMPAT_SERVERAID4Lx, \=0A=
-      IPS_COMPAT_SARASOTA,     \=0A=
-      IPS_COMPAT_SARASOTA      \=0A=
+      IPS_COMPAT_SARASOTA,         /* one-channel variety of SARASOTA =
*/  \=0A=
+      IPS_COMPAT_SARASOTA,         /* two-channel variety of SARASOTA =
*/  \=0A=
+      IPS_COMPAT_MARCO, \=0A=
+      IPS_COMPAT_SEBRING \=0A=
    }=0A=
 =0A=
 =0A=

------_=_NextPart_000_01C2CE0B.9C787FA0--
