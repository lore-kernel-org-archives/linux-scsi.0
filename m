From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 3/4: remove LinuxVersionCode
Date: Thu, 13 Feb 2003 09:35:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B037750@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2D36D.2771F170"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h1DEXvD27690
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:57 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id GAA14527
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:56 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2D36D.2771F170
Content-Type: text/plain;
	charset="iso-8859-1"

This patch removes the old LinuxVersionCode()
and replaces it with KERNEL_VERSION().  Thanks
go to Adrian Bunk for sending the initial version.

David Jeffery

 ips.c |   10 +++++-----
 ips.h |   12 ++++--------
 2 files changed, 9 insertions(+), 13 deletions(-)


------_=_NextPart_000_01C2D36D.2771F170
Content-Type: text/plain;
	name="ipspatch3.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ipspatch3.txt"

diff -ur linux-2.5.60_p2/drivers/scsi/ips.c =
linux-2.5.60_p3/drivers/scsi/ips.c=0A=
--- linux-2.5.60_p2/drivers/scsi/ips.c	Tue Feb 11 11:47:23 2003=0A=
+++ linux-2.5.60_p3/drivers/scsi/ips.c	Tue Feb 11 11:47:41 2003=0A=
@@ -202,7 +202,7 @@=0A=
    #error "This driver has only been tested on the x86/ia64 =
platforms"=0A=
 #endif=0A=
 =0A=
-#if LINUX_VERSION_CODE <=3D LinuxVersionCode(2,5,0)=0A=
+#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,5,0)=0A=
     #include "sd.h"=0A=
     #define IPS_SG_ADDRESS(sg)       ((sg)->address)=0A=
     #define IPS_LOCK_SAVE(lock,flags) =
spin_lock_irqsave(&io_request_lock,flags)=0A=
@@ -1136,7 +1136,7 @@=0A=
 /*                                                                     =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
 static int=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)=0A=
 ips_biosparam(Disk *disk, kdev_t dev, int geom[]) {=0A=
    ips_ha_t         *ha =3D (ips_ha_t *) =
disk->device->host->hostdata;=0A=
    unsigned long     capacity =3D disk->capacity;=0A=
@@ -1182,7 +1182,7 @@=0A=
 =0A=
    return (0);=0A=
 }=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)=0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=
 /* Routine Name: ips_select_queue_depth                                =
     */=0A=
@@ -6755,7 +6755,7 @@=0A=
 	sh->unchecked_isa_dma =3D sh->hostt->unchecked_isa_dma;=0A=
 	sh->use_clustering =3D sh->hostt->use_clustering;=0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,7)=0A=
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,7)=0A=
 	sh->max_sectors =3D 128;=0A=
 #endif =0A=
 =0A=
@@ -7138,7 +7138,7 @@=0A=
 }=0A=
 =0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,9)=0A=
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,9)=0A=
 MODULE_LICENSE("GPL");=0A=
 #endif=0A=
 =0A=
diff -ur linux-2.5.60_p2/drivers/scsi/ips.h =
linux-2.5.60_p3/drivers/scsi/ips.h=0A=
--- linux-2.5.60_p2/drivers/scsi/ips.h	Tue Feb 11 08:26:38 2003=0A=
+++ linux-2.5.60_p3/drivers/scsi/ips.h	Tue Feb 11 11:01:33 2003=0A=
@@ -64,11 +64,7 @@=0A=
    /*=0A=
     * Some handy macros=0A=
     */=0A=
-   #ifndef LinuxVersionCode=0A=
-      #define LinuxVersionCode(x,y,z)  (((x)<<16)+((y)<<8)+(z))=0A=
-   #endif=0A=
-=0A=
-   #if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,20) || defined =
CONFIG_HIGHIO=0A=
+   #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,20) || defined =
CONFIG_HIGHIO=0A=
       #define IPS_HIGHIO=0A=
       #define IPS_HIGHMEM_IO     .highmem_io =3D 1,=0A=
    #else=0A=
@@ -97,12 +93,12 @@=0A=
     #define IPS_SGLIST_SIZE(ha)       (IPS_USE_ENH_SGLIST(ha) ? \=0A=
                                          sizeof(IPS_ENH_SG_LIST) : =
sizeof(IPS_STD_SG_LIST))=0A=
 =0A=
-   #if LINUX_VERSION_CODE < LinuxVersionCode(2,4,4)=0A=
+   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,4)=0A=
       #define pci_set_dma_mask(dev,mask) (1)=0A=
       #define scsi_set_pci_device(sh,dev) (0)=0A=
    #endif=0A=
 =0A=
-   #if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
+   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)=0A=
       #define scsi_register_host(x)    =
scsi_register_module(MODULE_SCSI_HA,x)=0A=
       #define scsi_unregister_host(x)  =
scsi_unregister_module(MODULE_SCSI_HA,x)=0A=
    #endif=0A=
@@ -439,7 +435,7 @@=0A=
    /*=0A=
     * Scsi_Host Template=0A=
     */=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)=0A=
    static void ips_select_queue_depth(struct Scsi_Host *, Scsi_Device =
*);=0A=
    static int ips_biosparam(Disk *disk, kdev_t dev, int geom[]);=0A=
 #define IPS {	\=0A=

------_=_NextPart_000_01C2D36D.2771F170--
