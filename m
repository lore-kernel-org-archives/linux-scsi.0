From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [patch 2.5] ips driver 3/3: code cleanup
Date: Thu, 2 Jan 2003 13:15:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B037725@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2B28A.E00AA460"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h02IE3j16279
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jan 2003 10:14:03 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA22826
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jan 2003 10:14:02 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2B28A.E00AA460
Content-Type: text/plain;
	charset="iso-8859-1"

This patch does 3 small cleanups.

It moves some of the init code into a new helper function.

It simplifies the S/G path by using the scsi_to_pci_dma_dir()
macro directly instead of the more complex IPS_DMA_DIR() macro.

It deletes unused defines and structs from ips.h.

David Jeffery

 ips.c |  112
+++++++++++++++++++++++++++++++++++++-----------------------------
 ips.h |   33 -------------------
 2 files changed, 63 insertions(+), 82 deletions(-)


------_=_NextPart_000_01C2B28A.E00AA460
Content-Type: application/octet-stream;
	name="ips2.5.54.patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips2.5.54.patch3"

diff -ur linux-2.5.54_p2/drivers/scsi/ips.c =
linux-2.5.54_p3/drivers/scsi/ips.c=0A=
--- linux-2.5.54_p2/drivers/scsi/ips.c	Thu Jan  2 12:01:42 2003=0A=
+++ linux-2.5.54_p3/drivers/scsi/ips.c	Thu Jan  2 12:07:56 2003=0A=
@@ -456,6 +456,7 @@=0A=
 static void ips_free(ips_ha_t *);=0A=
 static void ips_init_scb(ips_ha_t *, ips_scb_t *);=0A=
 static void ips_freescb(ips_ha_t *, ips_scb_t *);=0A=
+static void ips_setup_funclist(ips_ha_t *);=0A=
 static void ips_statinit(ips_ha_t *);=0A=
 static void ips_statinit_memio(ips_ha_t *);=0A=
 static void ips_fix_ffdc_time(ips_ha_t *, ips_scb_t *, time_t);=0A=
@@ -604,6 +605,64 @@=0A=
    return (ips_num_controllers);=0A=
 }=0A=
 =0A=
+=0A=
+/**********************************************************************=
******/=0A=
+/*   configure the function pointers to use the functions that will =
work    */=0A=
+/*   with the found version of the adapter                             =
     */=0A=
+/**********************************************************************=
******/=0A=
+static void ips_setup_funclist(ips_ha_t *ha){=0A=
+=0A=
+   /*                                =0A=
+    * Setup Functions=0A=
+    */=0A=
+   if (IPS_IS_MORPHEUS(ha)) {=0A=
+      /* morpheus / marco / sebring */=0A=
+      ha->func.isintr =3D ips_isintr_morpheus;=0A=
+      ha->func.isinit =3D ips_isinit_morpheus;=0A=
+      ha->func.issue =3D ips_issue_i2o_memio;=0A=
+      ha->func.init =3D ips_init_morpheus;=0A=
+      ha->func.statupd =3D ips_statupd_morpheus;=0A=
+      ha->func.reset =3D ips_reset_morpheus;=0A=
+      ha->func.intr =3D ips_intr_morpheus;=0A=
+      ha->func.enableint =3D ips_enable_int_morpheus;=0A=
+   } else if (IPS_USE_MEMIO(ha)) {=0A=
+      /* copperhead w/MEMIO */=0A=
+      ha->func.isintr =3D ips_isintr_copperhead_memio;=0A=
+      ha->func.isinit =3D ips_isinit_copperhead_memio;=0A=
+      ha->func.init =3D ips_init_copperhead_memio;=0A=
+      ha->func.statupd =3D ips_statupd_copperhead_memio;=0A=
+      ha->func.statinit =3D ips_statinit_memio;=0A=
+      ha->func.reset =3D ips_reset_copperhead_memio;=0A=
+      ha->func.intr =3D ips_intr_copperhead;=0A=
+      ha->func.erasebios =3D ips_erase_bios_memio;=0A=
+      ha->func.programbios =3D ips_program_bios_memio;=0A=
+      ha->func.verifybios =3D ips_verify_bios_memio;=0A=
+      ha->func.enableint =3D ips_enable_int_copperhead_memio;=0A=
+      if (IPS_USE_I2O_DELIVER(ha))=0A=
+         ha->func.issue =3D ips_issue_i2o_memio;=0A=
+      else=0A=
+         ha->func.issue =3D ips_issue_copperhead_memio;=0A=
+   } else {=0A=
+      /* copperhead */=0A=
+      ha->func.isintr =3D ips_isintr_copperhead;=0A=
+      ha->func.isinit =3D ips_isinit_copperhead;=0A=
+      ha->func.init =3D ips_init_copperhead;=0A=
+      ha->func.statupd =3D ips_statupd_copperhead;=0A=
+      ha->func.statinit =3D ips_statinit;=0A=
+      ha->func.reset =3D ips_reset_copperhead;=0A=
+      ha->func.intr =3D ips_intr_copperhead;=0A=
+      ha->func.erasebios =3D ips_erase_bios;=0A=
+      ha->func.programbios =3D ips_program_bios;=0A=
+      ha->func.verifybios =3D ips_verify_bios;=0A=
+      ha->func.enableint =3D ips_enable_int_copperhead;=0A=
+=0A=
+      if (IPS_USE_I2O_DELIVER(ha))=0A=
+         ha->func.issue =3D ips_issue_i2o;=0A=
+      else=0A=
+         ha->func.issue =3D ips_issue_copperhead;=0A=
+   }=0A=
+}=0A=
+=0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=
 /* Routine Name: ips_release                                           =
     */=0A=
@@ -2645,7 +2704,7 @@=0A=
 =0A=
          sg =3D SC->request_buffer;=0A=
          scb->sg_count =3D pci_map_sg(ha->pcidev, sg, SC->use_sg,=0A=
-                                    IPS_DMA_DIR(scb));=0A=
+                                    =
scsi_to_pci_dma_dir(SC->sc_data_direction));=0A=
          scb->flags |=3D IPS_SCB_MAP_SG;=0A=
          if (scb->sg_count =3D=3D 1) {=0A=
             if (sg_dma_len(sg) > ha->max_xfer) {=0A=
@@ -2705,7 +2764,8 @@=0A=
 =0A=
             scb->dcdb.transfer_length =3D scb->data_len;=0A=
             scb->data_busaddr =3D pci_map_single(ha->pcidev, =
SC->request_buffer,=0A=
-                                               scb->data_len, =
IPS_DMA_DIR(scb));=0A=
+                                               scb->data_len,=0A=
+                                               =
scsi_to_pci_dma_dir(SC->sc_data_direction));=0A=
             scb->flags |=3D IPS_SCB_MAP_SINGLE;=0A=
             scb->sg_len =3D 0;=0A=
          } else {=0A=
@@ -6820,53 +6880,7 @@=0A=
     /*=0A=
      * Setup Functions=0A=
      */=0A=
-    if (IPS_IS_MORPHEUS(ha)) {=0A=
-       /* morpheus */=0A=
-       ha->func.isintr =3D ips_isintr_morpheus;=0A=
-       ha->func.isinit =3D ips_isinit_morpheus;=0A=
-       ha->func.issue =3D ips_issue_i2o_memio;=0A=
-       ha->func.init =3D ips_init_morpheus;=0A=
-       ha->func.statupd =3D ips_statupd_morpheus;=0A=
-       ha->func.reset =3D ips_reset_morpheus;=0A=
-       ha->func.intr =3D ips_intr_morpheus;=0A=
-       ha->func.enableint =3D ips_enable_int_morpheus;=0A=
-    } else if (IPS_USE_MEMIO(ha)) {=0A=
-       /* copperhead w/MEMIO */=0A=
-       ha->func.isintr =3D ips_isintr_copperhead_memio;=0A=
-       ha->func.isinit =3D ips_isinit_copperhead_memio;=0A=
-       ha->func.init =3D ips_init_copperhead_memio;=0A=
-       ha->func.statupd =3D ips_statupd_copperhead_memio;=0A=
-       ha->func.statinit =3D ips_statinit_memio;=0A=
-       ha->func.reset =3D ips_reset_copperhead_memio;=0A=
-       ha->func.intr =3D ips_intr_copperhead;=0A=
-       ha->func.erasebios =3D ips_erase_bios_memio;=0A=
-       ha->func.programbios =3D ips_program_bios_memio;=0A=
-       ha->func.verifybios =3D ips_verify_bios_memio;=0A=
-       ha->func.enableint =3D ips_enable_int_copperhead_memio;=0A=
-=0A=
-       if (IPS_USE_I2O_DELIVER(ha))=0A=
-          ha->func.issue =3D ips_issue_i2o_memio;=0A=
-       else=0A=
-          ha->func.issue =3D ips_issue_copperhead_memio;=0A=
-    } else {=0A=
-       /* copperhead */=0A=
-       ha->func.isintr =3D ips_isintr_copperhead;=0A=
-       ha->func.isinit =3D ips_isinit_copperhead;=0A=
-       ha->func.init =3D ips_init_copperhead;=0A=
-       ha->func.statupd =3D ips_statupd_copperhead;=0A=
-       ha->func.statinit =3D ips_statinit;=0A=
-       ha->func.reset =3D ips_reset_copperhead;=0A=
-       ha->func.intr =3D ips_intr_copperhead;=0A=
-       ha->func.erasebios =3D ips_erase_bios;=0A=
-       ha->func.programbios =3D ips_program_bios;=0A=
-       ha->func.verifybios =3D ips_verify_bios;=0A=
-       ha->func.enableint =3D ips_enable_int_copperhead;=0A=
-=0A=
-       if (IPS_USE_I2O_DELIVER(ha))=0A=
-          ha->func.issue =3D ips_issue_i2o;=0A=
-       else=0A=
-          ha->func.issue =3D ips_issue_copperhead;=0A=
-    }=0A=
+    ips_setup_funclist(ha);=0A=
 =0A=
     if ( IPS_IS_MORPHEUS( ha ) ) {=0A=
         /* If Morpheus appears dead, reset it */=0A=
diff -ur linux-2.5.54_p2/drivers/scsi/ips.h =
linux-2.5.54_p3/drivers/scsi/ips.h=0A=
--- linux-2.5.54_p2/drivers/scsi/ips.h	Thu Jan  2 11:06:26 2003=0A=
+++ linux-2.5.54_p3/drivers/scsi/ips.h	Thu Jan  2 12:07:56 2003=0A=
@@ -350,27 +350,8 @@=0A=
    #define IPS_SCSI_MP3_AllocateSurface 0x08=0A=
 =0A=
    /*=0A=
-    * Configuration Structure Flags=0A=
-    */=0A=
-   #define IPS_CFG_USEROPT_UPDATECOUNT(cfg)   (((cfg)->UserOpt & =
0xffff000) >> 16)=0A=
-   #define IPS_CFG_USEROPT_CONCURSTART(cfg)   (((cfg)->UserOpt & =
0xf000) >> 12)=0A=
-   #define IPS_CFG_USEROPT_STARTUPDELAY(cfg)  (((cfg)->UserOpt & =
0xf00) >> 8)=0A=
-   #define IPS_CFG_USEROPT_REARRANGE(cfg)     ((cfg)->UserOpt & =
0x80)=0A=
-   #define IPS_CFG_USEROPT_CDBOOT(cfg)        ((cfg)->UserOpt & =
0x40)=0A=
-   #define IPS_CFG_USEROPT_CLUSTER(cfg)       ((cfg)->UserOpt & =
0x20)=0A=
-=0A=
-   /*=0A=
-    * Host adapter Flags (bit numbers)=0A=
-    */=0A=
-   #define IPS_IN_INTR                  0=0A=
-   #define IPS_IN_ABORT                 1=0A=
-   #define IPS_IN_RESET                 2=0A=
-=0A=
-   /*=0A=
     * SCB Flags=0A=
     */=0A=
-   #define IPS_SCB_ACTIVE               0x00001=0A=
-   #define IPS_SCB_WAITING              0x00002=0A=
    #define IPS_SCB_MAP_SG               0x00008=0A=
    #define IPS_SCB_MAP_SINGLE           0X00010=0A=
 =0A=
@@ -381,7 +362,6 @@=0A=
    #define IPS_COPPIOCCMD              (('C'<<8) | 66)=0A=
    #define IPS_NUMCTRLS                (('C'<<8) | 68)=0A=
    #define IPS_CTRLINFO                (('C'<<8) | 69)=0A=
-   #define IPS_FLASHBIOS               (('C'<<8) | 70)=0A=
 =0A=
    /* flashing defines */=0A=
    #define IPS_FW_IMAGE                0x00=0A=
@@ -976,19 +956,6 @@=0A=
    int   option_value;=0A=
 } IPS_OPTION;=0A=
 =0A=
-typedef struct {=0A=
-   void             *userbuffer;=0A=
-   uint32_t          usersize;=0A=
-   void             *kernbuffer;=0A=
-   uint32_t          kernsize;=0A=
-   void             *ha;=0A=
-   void             *SC;=0A=
-   void             *pt;=0A=
-   struct semaphore *sem;=0A=
-   uint32_t          offset;=0A=
-   uint32_t          retcode;=0A=
-} IPS_FLASH_DATA;=0A=
-=0A=
 /*=0A=
  * Status Info=0A=
  */=0A=

------_=_NextPart_000_01C2B28A.E00AA460--
