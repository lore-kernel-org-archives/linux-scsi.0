From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: ServeRAID driver ( ips ) Version 7.10.18 ( for 2.4 kernels )
Date: Thu, 26 Aug 2004 15:21:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F01971E4B6@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C48BA1.DD4942FF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:34725 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269483AbUHZTVX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 15:21:23 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i7QJLMW25177
	for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2004 12:21:22 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i7QJLJo01806
	for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2004 12:21:19 -0700
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <'linux-scsi@vger.kernel.org'>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C48BA1.DD4942FF
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Attached is a patch to be applied to the 2.4.27 kernel ( on
www.kernel.org ) for Version 7.10.18 of the ServeRAID driver ( ips ).
One important bug was fixed ( the sorting of 7K adapters in function
ips_order_controllers ).  This also includes Arjan's recommendation for
2.6 to remove an unnecessary #ifdef around MODULE_DESCRIPTION.  The rest
of the patch is primarily concerned with IBM version numbers.

The patch to bring the 2.6 kernel driver up to the same 7.10.18 level
has already been issued.

Jack Hammer
RAID Device Driver Development
Adaptec, Inc.

=20
=20
=20
--- linux.orig/drivers/scsi/ips.c Wed Aug 25 10:21:45 2004
+++ linux/drivers/scsi/ips.c Wed Aug 25 10:22:07 2004
@@ -133,6 +133,10 @@
 /* 6.10.00  - Remove 1G Addressing Limitations
*/
 /* 6.11.xx  - Get VersionInfo buffer off the stack !              DDTS
60401 */
 /* 6.11.xx  - Make Logical Drive Info structure safe for DMA      DDTS
60639 */
+/* 7.10.xx  - Add highmem_io flag in SCSI Templete for 2.4 kernels
*/
+/*          - Fix path/name for scsi_hosts.h include for 2.6 kernels
*/
+/*          - Fix sort order of 7k
*/
+/*          - Remove 3 unused "inline" functions
*/
=20
/***********************************************************************
******/
=20
 /*
@@ -176,7 +180,13 @@
 #include <scsi/sg.h>
=20
 #include "scsi.h"
+
+#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,5,0)
 #include "hosts.h"
+#else
+#include <scsi/scsi_host.h>
+#endif
+
 #include "ips.h"
=20
 #include <linux/module.h>
@@ -197,8 +207,8 @@
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "7.00"
-#define IPS_VERSION_LOW         ".15 "
+#define IPS_VERSION_HIGH        "7.10"
+#define IPS_VERSION_LOW         ".18 "
=20
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
#warning "This driver has only been tested on the x86/ia64/x86_64
platforms"
@@ -277,9 +287,9 @@
  .use_clustering  =3D ENABLE_CLUSTERING,
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
  .use_new_eh_code =3D 1,
-#ifdef RHEL3
-    .vary_io            =3D 1,
 #endif
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,20)  &&
LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+    .highmem_io          =3D 1,  =20
 #endif
 };
=20
@@ -477,21 +487,17 @@
 static uint32_t ips_statupd_copperhead_memio(ips_ha_t *);  static
uint32_t ips_statupd_morpheus(ips_ha_t *);  static ips_scb_t
*ips_getscb(ips_ha_t *); -static inline void
ips_putq_scb_head(ips_scb_queue_t *, ips_scb_t *); -static inline void
ips_putq_scb_tail(ips_scb_queue_t *, ips_scb_t *); -static inline void
ips_putq_wait_head(ips_wait_queue_t *, Scsi_Cmnd *); -static inline void
ips_putq_wait_tail(ips_wait_queue_t *, Scsi_Cmnd *); -static inline void
ips_putq_copp_head(ips_copp_queue_t *,
-          ips_copp_wait_item_t *);
-static inline void ips_putq_copp_tail(ips_copp_queue_t *,
+static void ips_putq_scb_head(ips_scb_queue_t *, ips_scb_t *); static=20
+void ips_putq_wait_tail(ips_wait_queue_t *, Scsi_Cmnd *); static void=20
+ips_putq_copp_tail(ips_copp_queue_t *,
           ips_copp_wait_item_t *);
-static inline ips_scb_t *ips_removeq_scb_head(ips_scb_queue_t *);
-static inline ips_scb_t *ips_removeq_scb(ips_scb_queue_t *, ips_scb_t
*); -static inline Scsi_Cmnd *ips_removeq_wait_head(ips_wait_queue_t *);
-static inline Scsi_Cmnd *ips_removeq_wait(ips_wait_queue_t *, Scsi_Cmnd
*); -static inline ips_copp_wait_item_t
*ips_removeq_copp(ips_copp_queue_t *,
+static ips_scb_t *ips_removeq_scb_head(ips_scb_queue_t *); static=20
+ips_scb_t *ips_removeq_scb(ips_scb_queue_t *, ips_scb_t *); static=20
+Scsi_Cmnd *ips_removeq_wait_head(ips_wait_queue_t *); static Scsi_Cmnd=20
+*ips_removeq_wait(ips_wait_queue_t *, Scsi_Cmnd *); static=20
+ips_copp_wait_item_t *ips_removeq_copp(ips_copp_queue_t *,
            ips_copp_wait_item_t *);
-static inline ips_copp_wait_item_t
*ips_removeq_copp_head(ips_copp_queue_t *);
+static ips_copp_wait_item_t *ips_removeq_copp_head(ips_copp_queue_t *);
=20
 static int ips_is_passthru(Scsi_Cmnd *);  static int
ips_make_passthru(ips_ha_t *, Scsi_Cmnd *, ips_scb_t *, int); @@ -1888,7
+1894,7 @@
 /*   Fill in a single scb sg_list element from an address
*/
 /*   return a -1 if a breakup occurred
*/
=20
/***********************************************************************
*****/
-static inline int
+static int
 ips_fill_scb_sg_single(ips_ha_t * ha, dma_addr_t busaddr,
          ips_scb_t * scb, int indx, unsigned int e_len)  { @@ -2953,7
+2959,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline void
+static void
 ips_putq_scb_head(ips_scb_queue_t * queue, ips_scb_t * item)  {
  METHOD_TRACE("ips_putq_scb_head", 1);
@@ -2972,38 +2978,6 @@
=20
=20
/***********************************************************************
*****/
 /*
*/
-/* Routine Name: ips_putq_scb_tail
*/
-/*
*/
-/* Routine Description:
*/
-/*
*/
-/*   Add an item to the tail of the queue
*/
-/*
*/
-/* ASSUMED to be called from within the HA lock
*/
-/*
*/
-/**********************************************************************
******/
-static inline void
-ips_putq_scb_tail(ips_scb_queue_t * queue, ips_scb_t * item) -{
- METHOD_TRACE("ips_putq_scb_tail", 1);
-
- if (!item)
-  return;
-
- item->q_next =3D NULL;
-
- if (queue->tail)
-  queue->tail->q_next =3D item;
-
- queue->tail =3D item;
-
- if (!queue->head)
-  queue->head =3D item;
-
- queue->count++;
-}
-
-/**********************************************************************
******/
-/*
*/
 /* Routine Name: ips_removeq_scb_head
*/
 /*
*/
 /* Routine Description:
*/
@@ -3013,7 +2987,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline ips_scb_t *
+static ips_scb_t *
 ips_removeq_scb_head(ips_scb_queue_t * queue)  {
  ips_scb_t *item;
@@ -3048,7 +3022,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline ips_scb_t *
+static ips_scb_t *
 ips_removeq_scb(ips_scb_queue_t * queue, ips_scb_t * item)  {
  ips_scb_t *p;
@@ -3085,34 +3059,6 @@
=20
=20
/***********************************************************************
*****/
 /*
*/
-/* Routine Name: ips_putq_wait_head
*/
-/*
*/
-/* Routine Description:
*/
-/*
*/
-/*   Add an item to the head of the queue
*/
-/*
*/
-/* ASSUMED to be called from within the HA lock
*/
-/*
*/
-/**********************************************************************
******/
-static inline void
-ips_putq_wait_head(ips_wait_queue_t * queue, Scsi_Cmnd * item) -{
- METHOD_TRACE("ips_putq_wait_head", 1);
-
- if (!item)
-  return;
-
- item->host_scribble =3D (char *) queue->head;
- queue->head =3D item;
-
- if (!queue->tail)
-  queue->tail =3D item;
-
- queue->count++;
-}
-
-/**********************************************************************
******/
-/*
*/
 /* Routine Name: ips_putq_wait_tail
*/
 /*
*/
 /* Routine Description:
*/
@@ -3122,7 +3068,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline void
+static void
 ips_putq_wait_tail(ips_wait_queue_t * queue, Scsi_Cmnd * item)  {
  METHOD_TRACE("ips_putq_wait_tail", 1); @@ -3154,7 +3100,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline Scsi_Cmnd *
+static Scsi_Cmnd *
 ips_removeq_wait_head(ips_wait_queue_t * queue)  {
  Scsi_Cmnd *item;
@@ -3189,7 +3135,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline Scsi_Cmnd *
+static Scsi_Cmnd *
 ips_removeq_wait(ips_wait_queue_t * queue, Scsi_Cmnd * item)  {
  Scsi_Cmnd *p;
@@ -3226,34 +3172,6 @@
=20
=20
/***********************************************************************
*****/
 /*
*/
-/* Routine Name: ips_putq_copp_head
*/
-/*
*/
-/* Routine Description:
*/
-/*
*/
-/*   Add an item to the head of the queue
*/
-/*
*/
-/* ASSUMED to be called from within the HA lock
*/
-/*
*/
-/**********************************************************************
******/
-static inline void
-ips_putq_copp_head(ips_copp_queue_t * queue, ips_copp_wait_item_t *
item) -{
- METHOD_TRACE("ips_putq_copp_head", 1);
-
- if (!item)
-  return;
-
- item->next =3D queue->head;
- queue->head =3D item;
-
- if (!queue->tail)
-  queue->tail =3D item;
-
- queue->count++;
-}
-
-/**********************************************************************
******/
-/*
*/
 /* Routine Name: ips_putq_copp_tail
*/
 /*
*/
 /* Routine Description:
*/
@@ -3263,7 +3181,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline void
+static void
 ips_putq_copp_tail(ips_copp_queue_t * queue, ips_copp_wait_item_t *
item)  {
  METHOD_TRACE("ips_putq_copp_tail", 1); @@ -3295,7 +3213,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline ips_copp_wait_item_t *
+static ips_copp_wait_item_t *
 ips_removeq_copp_head(ips_copp_queue_t * queue)  {
  ips_copp_wait_item_t *item;
@@ -3330,7 +3248,7 @@
 /* ASSUMED to be called from within the HA lock
*/
 /*
*/
=20
/***********************************************************************
*****/
-static inline ips_copp_wait_item_t *
+static ips_copp_wait_item_t *
 ips_removeq_copp(ips_copp_queue_t * queue, ips_copp_wait_item_t * item)
{
  ips_copp_wait_item_t *p;
@@ -4014,7 +3932,7 @@
    scb->cmd.logical_info.reserved2 =3D 0;
    scb->cmd.logical_info.reserved3 =3D 0;
    scb->data_len =3D sizeof (IPS_LD_INFO);
-            scb->data_busaddr =3D ha->logical_drive_info_dma_addr;
+   scb->data_busaddr =3D ha->logical_drive_info_dma_addr;
    scb->flags =3D 0;
    scb->cmd.logical_info.buffer_addr =3D scb->data_busaddr;
    ret =3D IPS_SUCCESS;
@@ -4340,7 +4258,7 @@
=20
  if ((scb->basic_status & IPS_GSC_STATUS_MASK) > 1) {
   memset(ha->logical_drive_info, 0, sizeof (IPS_LD_INFO));
-        return (0);
+  return (0);
  }
=20
  if (ha->logical_drive_info->drive_info[scb->target_id].state !=3D @@
-4579,7 +4497,7 @@
   if (ha->logical_drive_info) {
    pci_free_consistent(ha->pcidev,
          sizeof (IPS_LD_INFO),
-                        ha->logical_drive_info,
+         ha->logical_drive_info,
          ha->logical_drive_info_dma_addr);
    ha->logical_drive_info =3D NULL;
   }
@@ -4773,7 +4691,7 @@
  }
=20
  ha->scb_freelist =3D scb->q_next;
-    scb->flags =3D 0;
+ scb->flags =3D 0;
  scb->q_next =3D NULL;
=20
  ips_init_scb(ha, scb);
@@ -6831,7 +6749,7 @@
=20
  METHOD_TRACE("ips_version_check", 1);
=20
-    VersionInfo =3D ( IPS_VERSION_DATA * ) ha->ioctl_data;
+ VersionInfo =3D ( IPS_VERSION_DATA * ) ha->ioctl_data;
=20
  memset(FirmwareVersion, 0, IPS_COMPAT_ID_LENGTH + 1);
  memset(BiosVersion, 0, IPS_COMPAT_ID_LENGTH + 1); @@ -6843,7 +6761,7
@@
  rc =3D IPS_FAILURE;
  if (ha->subsys->param[4] & IPS_GET_VERSION_SUPPORT) { /* If Versioning
is Supported */
   /* Get the Version Info with a Get Version Command */
-        memset( VersionInfo, 0, sizeof (IPS_VERSION_DATA));
+  memset( VersionInfo, 0, sizeof (IPS_VERSION_DATA));
   rc =3D ips_get_version_info(ha, ha->ioctl_busaddr, intr);
   if (rc =3D=3D IPS_SUCCESS)
    memcpy(FirmwareVersion, VersionInfo->compatibilityId, @@ -6999,7
+6917,6 @@
    for (j =3D position; j < ips_num_controllers; j++) {
     switch (ips_ha[j]->ad_type) {
     case IPS_ADTYPE_SERVERAID6M:
-    case IPS_ADTYPE_SERVERAID7k:
     case IPS_ADTYPE_SERVERAID7M:
      if (nvram->adapter_order[i] =3D=3D 'M') {
       ips_shift_controllers(position,
@@ -7020,6 +6937,7 @@
     case IPS_ADTYPE_SERVERAID6I:
     case IPS_ADTYPE_SERVERAID5I2:
     case IPS_ADTYPE_SERVERAID5I1:
+    case IPS_ADTYPE_SERVERAID7k:
      if (nvram->adapter_order[i] =3D=3D 'S') {
       ips_shift_controllers(position,
               j);
@@ -7547,6 +7465,13 @@
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,9)  =
MODULE_LICENSE("GPL");
#endif
+
+MODULE_DESCRIPTION("IBM ServeRAID Adapter Driver " IPS_VER_STRING);
+
+#ifdef MODULE_VERSION
+MODULE_VERSION(IPS_VER_STRING);
+#endif
+
=20
 /*
  * Overrides for Emacs so that we almost follow Linus's tabbing style.
--- linux.orig/drivers/scsi/ips.h Wed Aug 25 10:21:53 2004
+++ linux/drivers/scsi/ips.h Wed Aug 25 10:25:34 2004
@@ -95,14 +95,15 @@
       #define scsi_set_pci_device(sh,dev) (0)
    #endif
=20
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,23)
-      typedef void irqreturn_t;
+   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+  =20
+      #ifndef irqreturn_t
+         typedef void irqreturn_t;
+      #endif
+     =20
       #define IRQ_NONE
       #define IRQ_HANDLED
       #define IRQ_RETVAL(x)
-   #endif
-
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
       #define IPS_REGISTER_HOSTS(SHT)
scsi_register_module(MODULE_SCSI_HA,SHT)
       #define IPS_UNREGISTER_HOSTS(SHT)
scsi_unregister_module(MODULE_SCSI_HA,SHT)
       #define IPS_ADD_HOST(shost,device) @@ -1213,13 +1214,13 @@
=20
 #define IPS_VER_MAJOR 7
 #define IPS_VER_MAJOR_STRING "7"
-#define IPS_VER_MINOR 00
-#define IPS_VER_MINOR_STRING "00"
-#define IPS_VER_BUILD 15
-#define IPS_VER_BUILD_STRING "15"
-#define IPS_VER_STRING "7.00.15"
+#define IPS_VER_MINOR 10
+#define IPS_VER_MINOR_STRING "10"
+#define IPS_VER_BUILD 18
+#define IPS_VER_BUILD_STRING "18"
+#define IPS_VER_STRING "7.10.18"
 #define IPS_RELEASE_ID 0x00020000
-#define IPS_BUILD_IDENT 625
+#define IPS_BUILD_IDENT 731
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002.
All Rights Reserved."
 #define IPS_ADAPTECCOPYRIGHT_STRING "(c) Copyright Adaptec, Inc. 2002
to 2004. All Rights Reserved."
 #define IPS_DELLCOPYRIGHT_STRING "(c) Copyright Dell 2004. All Rights
Reserved."
@@ -1230,32 +1231,35 @@
 #define IPS_VER_SERVERAID2 "2.88.13"
 #define IPS_VER_NAVAJO "2.88.13"
 #define IPS_VER_SERVERAID3 "6.10.24"
-#define IPS_VER_SERVERAID4H "7.00.15"
-#define IPS_VER_SERVERAID4MLx "7.00.15"
-#define IPS_VER_SARASOTA "7.00.15"
-#define IPS_VER_MARCO "7.00.15"
-#define IPS_VER_SEBRING "7.00.15"
+#define IPS_VER_SERVERAID4H "7.10.11"
+#define IPS_VER_SERVERAID4MLx "7.10.18"
+#define IPS_VER_SARASOTA "7.10.18"
+#define IPS_VER_MARCO "7.10.18"
+#define IPS_VER_SEBRING "7.10.18"
+#define IPS_VER_KEYWEST "7.10.18"
=20
 /* Compatability IDs for various adapters */  #define
IPS_COMPAT_UNKNOWN ""
-#define IPS_COMPAT_CURRENT "SB610"
+#define IPS_COMPAT_CURRENT "KW710"
 #define IPS_COMPAT_SERVERAID1 "2.25.01"
 #define IPS_COMPAT_SERVERAID2 "2.88.13"
 #define IPS_COMPAT_NAVAJO  "2.88.13"
 #define IPS_COMPAT_KIOWA "2.88.13"
 #define IPS_COMPAT_SERVERAID3H  "SB610"
 #define IPS_COMPAT_SERVERAID3L  "SB610"
-#define IPS_COMPAT_SERVERAID4H  "SB610"
-#define IPS_COMPAT_SERVERAID4M  "SB610"
-#define IPS_COMPAT_SERVERAID4L  "SB610"
-#define IPS_COMPAT_SERVERAID4Mx "SB610"
-#define IPS_COMPAT_SERVERAID4Lx "SB610"
-#define IPS_COMPAT_SARASOTA     "SB610"
-#define IPS_COMPAT_MARCO        "SB610"
-#define IPS_COMPAT_SEBRING      "SB610"
-#define IPS_COMPAT_BIOS "SB610"
+#define IPS_COMPAT_SERVERAID4H  "KW710"
+#define IPS_COMPAT_SERVERAID4M  "KW710"
+#define IPS_COMPAT_SERVERAID4L  "KW710"
+#define IPS_COMPAT_SERVERAID4Mx "KW710"
+#define IPS_COMPAT_SERVERAID4Lx "KW710"
+#define IPS_COMPAT_SARASOTA     "KW710"
+#define IPS_COMPAT_MARCO        "KW710"
+#define IPS_COMPAT_SEBRING      "KW710"
+#define IPS_COMPAT_TAMPA        "KW710"
+#define IPS_COMPAT_KEYWEST      "KW710"
+#define IPS_COMPAT_BIOS "KW710"
=20
-#define IPS_COMPAT_MAX_ADAPTER_TYPE 16
+#define IPS_COMPAT_MAX_ADAPTER_TYPE 18
 #define IPS_COMPAT_ID_LENGTH 8
=20
 #define IPS_DEFINE_COMPAT_TABLE(tablename) \ @@ -1275,7 +1279,9 @@
       IPS_COMPAT_SARASOTA,         /* one-channel variety of SARASOTA
*/  \
       IPS_COMPAT_SARASOTA,         /* two-channel variety of SARASOTA
*/  \
       IPS_COMPAT_MARCO, \
-      IPS_COMPAT_SEBRING \
+      IPS_COMPAT_SEBRING, \
+   IPS_COMPAT_TAMPA, \
+      IPS_COMPAT_KEYWEST \
    }
=20


------_=_NextPart_001_01C48BA1.DD4942FF
Content-Type: application/octet-stream;
	name="ips-patch-2.4.27"
Content-Transfer-Encoding: base64
Content-Description: ips-patch-2.4.27
Content-Disposition: attachment;
	filename="ips-patch-2.4.27"

LS0tIGxpbnV4Lm9yaWcvZHJpdmVycy9zY3NpL2lwcy5jCVdlZCBBdWcgMjUgMTA6MjE6NDUgMjAw
NAorKysgbGludXgvZHJpdmVycy9zY3NpL2lwcy5jCVdlZCBBdWcgMjUgMTA6MjI6MDcgMjAwNApA
QCAtMTMzLDYgKzEzMywxMCBAQAogLyogNi4xMC4wMCAgLSBSZW1vdmUgMUcgQWRkcmVzc2luZyBM
aW1pdGF0aW9ucyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwogLyogNi4xMS54eCAg
LSBHZXQgVmVyc2lvbkluZm8gYnVmZmVyIG9mZiB0aGUgc3RhY2sgISAgICAgICAgICAgICAgRERU
UyA2MDQwMSAqLwogLyogNi4xMS54eCAgLSBNYWtlIExvZ2ljYWwgRHJpdmUgSW5mbyBzdHJ1Y3R1
cmUgc2FmZSBmb3IgRE1BICAgICAgRERUUyA2MDYzOSAqLworLyogNy4xMC54eCAgLSBBZGQgaGln
aG1lbV9pbyBmbGFnIGluIFNDU0kgVGVtcGxldGUgZm9yIDIuNCBrZXJuZWxzICAgICAgICAgICAq
LworLyogICAgICAgICAgLSBGaXggcGF0aC9uYW1lIGZvciBzY3NpX2hvc3RzLmggaW5jbHVkZSBm
b3IgMi42IGtlcm5lbHMgICAgICAgICAqLworLyogICAgICAgICAgLSBGaXggc29ydCBvcmRlciBv
ZiA3ayAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLworLyogICAg
ICAgICAgLSBSZW1vdmUgMyB1bnVzZWQgImlubGluZSIgZnVuY3Rpb25zICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqLwogLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwogCiAvKgpAQCAtMTc2LDcg
KzE4MCwxMyBAQAogI2luY2x1ZGUgPHNjc2kvc2cuaD4KIAogI2luY2x1ZGUgInNjc2kuaCIKKwor
I2lmIExJTlVYX1ZFUlNJT05fQ09ERSA8PSBLRVJORUxfVkVSU0lPTigyLDUsMCkKICNpbmNsdWRl
ICJob3N0cy5oIgorI2Vsc2UKKyNpbmNsdWRlIDxzY3NpL3Njc2lfaG9zdC5oPgorI2VuZGlmCisK
ICNpbmNsdWRlICJpcHMuaCIKIAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgpAQCAtMTk3LDgg
KzIwNyw4IEBACiAvKgogICogRFJJVkVSX1ZFUgogICovCi0jZGVmaW5lIElQU19WRVJTSU9OX0hJ
R0ggICAgICAgICI3LjAwIgotI2RlZmluZSBJUFNfVkVSU0lPTl9MT1cgICAgICAgICAiLjE1ICIK
KyNkZWZpbmUgSVBTX1ZFUlNJT05fSElHSCAgICAgICAgIjcuMTAiCisjZGVmaW5lIElQU19WRVJT
SU9OX0xPVyAgICAgICAgICIuMTggIgogCiAjaWYgIWRlZmluZWQoX19pMzg2X18pICYmICFkZWZp
bmVkKF9faWE2NF9fKSAmJiAhZGVmaW5lZChfX3g4Nl82NF9fKQogI3dhcm5pbmcgIlRoaXMgZHJp
dmVyIGhhcyBvbmx5IGJlZW4gdGVzdGVkIG9uIHRoZSB4ODYvaWE2NC94ODZfNjQgcGxhdGZvcm1z
IgpAQCAtMjc3LDkgKzI4Nyw5IEBACiAJLnVzZV9jbHVzdGVyaW5nCQk9IEVOQUJMRV9DTFVTVEVS
SU5HLAogI2lmIExJTlVYX1ZFUlNJT05fQ09ERSA8IEtFUk5FTF9WRVJTSU9OKDIsNSwwKQogCS51
c2VfbmV3X2VoX2NvZGUJPSAxLAotI2lmZGVmIFJIRUwzCi0gICAgLnZhcnlfaW8gICAgICAgICAg
ICA9IDEsCiAjZW5kaWYKKyNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPj0gS0VSTkVMX1ZFUlNJT04o
Miw0LDIwKSAgJiYgIExJTlVYX1ZFUlNJT05fQ09ERSA8IEtFUk5FTF9WRVJTSU9OKDIsNSwwKQor
ICAgIC5oaWdobWVtX2lvICAgICAgICAgID0gMSwgICAKICNlbmRpZgogfTsKIApAQCAtNDc3LDIx
ICs0ODcsMTcgQEAKIHN0YXRpYyB1aW50MzJfdCBpcHNfc3RhdHVwZF9jb3BwZXJoZWFkX21lbWlv
KGlwc19oYV90ICopOwogc3RhdGljIHVpbnQzMl90IGlwc19zdGF0dXBkX21vcnBoZXVzKGlwc19o
YV90ICopOwogc3RhdGljIGlwc19zY2JfdCAqaXBzX2dldHNjYihpcHNfaGFfdCAqKTsKLXN0YXRp
YyBpbmxpbmUgdm9pZCBpcHNfcHV0cV9zY2JfaGVhZChpcHNfc2NiX3F1ZXVlX3QgKiwgaXBzX3Nj
Yl90ICopOwotc3RhdGljIGlubGluZSB2b2lkIGlwc19wdXRxX3NjYl90YWlsKGlwc19zY2JfcXVl
dWVfdCAqLCBpcHNfc2NiX3QgKik7Ci1zdGF0aWMgaW5saW5lIHZvaWQgaXBzX3B1dHFfd2FpdF9o
ZWFkKGlwc193YWl0X3F1ZXVlX3QgKiwgU2NzaV9DbW5kICopOwotc3RhdGljIGlubGluZSB2b2lk
IGlwc19wdXRxX3dhaXRfdGFpbChpcHNfd2FpdF9xdWV1ZV90ICosIFNjc2lfQ21uZCAqKTsKLXN0
YXRpYyBpbmxpbmUgdm9pZCBpcHNfcHV0cV9jb3BwX2hlYWQoaXBzX2NvcHBfcXVldWVfdCAqLAot
CQkJCSAgICAgIGlwc19jb3BwX3dhaXRfaXRlbV90ICopOwotc3RhdGljIGlubGluZSB2b2lkIGlw
c19wdXRxX2NvcHBfdGFpbChpcHNfY29wcF9xdWV1ZV90ICosCitzdGF0aWMgdm9pZCBpcHNfcHV0
cV9zY2JfaGVhZChpcHNfc2NiX3F1ZXVlX3QgKiwgaXBzX3NjYl90ICopOworc3RhdGljIHZvaWQg
aXBzX3B1dHFfd2FpdF90YWlsKGlwc193YWl0X3F1ZXVlX3QgKiwgU2NzaV9DbW5kICopOworc3Rh
dGljIHZvaWQgaXBzX3B1dHFfY29wcF90YWlsKGlwc19jb3BwX3F1ZXVlX3QgKiwKIAkJCQkgICAg
ICBpcHNfY29wcF93YWl0X2l0ZW1fdCAqKTsKLXN0YXRpYyBpbmxpbmUgaXBzX3NjYl90ICppcHNf
cmVtb3ZlcV9zY2JfaGVhZChpcHNfc2NiX3F1ZXVlX3QgKik7Ci1zdGF0aWMgaW5saW5lIGlwc19z
Y2JfdCAqaXBzX3JlbW92ZXFfc2NiKGlwc19zY2JfcXVldWVfdCAqLCBpcHNfc2NiX3QgKik7Ci1z
dGF0aWMgaW5saW5lIFNjc2lfQ21uZCAqaXBzX3JlbW92ZXFfd2FpdF9oZWFkKGlwc193YWl0X3F1
ZXVlX3QgKik7Ci1zdGF0aWMgaW5saW5lIFNjc2lfQ21uZCAqaXBzX3JlbW92ZXFfd2FpdChpcHNf
d2FpdF9xdWV1ZV90ICosIFNjc2lfQ21uZCAqKTsKLXN0YXRpYyBpbmxpbmUgaXBzX2NvcHBfd2Fp
dF9pdGVtX3QgKmlwc19yZW1vdmVxX2NvcHAoaXBzX2NvcHBfcXVldWVfdCAqLAorc3RhdGljIGlw
c19zY2JfdCAqaXBzX3JlbW92ZXFfc2NiX2hlYWQoaXBzX3NjYl9xdWV1ZV90ICopOworc3RhdGlj
IGlwc19zY2JfdCAqaXBzX3JlbW92ZXFfc2NiKGlwc19zY2JfcXVldWVfdCAqLCBpcHNfc2NiX3Qg
Kik7CitzdGF0aWMgU2NzaV9DbW5kICppcHNfcmVtb3ZlcV93YWl0X2hlYWQoaXBzX3dhaXRfcXVl
dWVfdCAqKTsKK3N0YXRpYyBTY3NpX0NtbmQgKmlwc19yZW1vdmVxX3dhaXQoaXBzX3dhaXRfcXVl
dWVfdCAqLCBTY3NpX0NtbmQgKik7CitzdGF0aWMgaXBzX2NvcHBfd2FpdF9pdGVtX3QgKmlwc19y
ZW1vdmVxX2NvcHAoaXBzX2NvcHBfcXVldWVfdCAqLAogCQkJCQkJICAgICBpcHNfY29wcF93YWl0
X2l0ZW1fdCAqKTsKLXN0YXRpYyBpbmxpbmUgaXBzX2NvcHBfd2FpdF9pdGVtX3QgKmlwc19yZW1v
dmVxX2NvcHBfaGVhZChpcHNfY29wcF9xdWV1ZV90ICopOworc3RhdGljIGlwc19jb3BwX3dhaXRf
aXRlbV90ICppcHNfcmVtb3ZlcV9jb3BwX2hlYWQoaXBzX2NvcHBfcXVldWVfdCAqKTsKIAogc3Rh
dGljIGludCBpcHNfaXNfcGFzc3RocnUoU2NzaV9DbW5kICopOwogc3RhdGljIGludCBpcHNfbWFr
ZV9wYXNzdGhydShpcHNfaGFfdCAqLCBTY3NpX0NtbmQgKiwgaXBzX3NjYl90ICosIGludCk7CkBA
IC0xODg4LDcgKzE4OTQsNyBAQAogLyogICBGaWxsIGluIGEgc2luZ2xlIHNjYiBzZ19saXN0IGVs
ZW1lbnQgZnJvbSBhbiBhZGRyZXNzICAgICAgICAgICAgICAgICAgICovCiAvKiAgIHJldHVybiBh
IC0xIGlmIGEgYnJlYWt1cCBvY2N1cnJlZCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKi8KIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwotc3RhdGljIGlubGluZSBpbnQKK3N0YXRp
YyBpbnQKIGlwc19maWxsX3NjYl9zZ19zaW5nbGUoaXBzX2hhX3QgKiBoYSwgZG1hX2FkZHJfdCBi
dXNhZGRyLAogCQkgICAgICAgaXBzX3NjYl90ICogc2NiLCBpbnQgaW5keCwgdW5zaWduZWQgaW50
IGVfbGVuKQogewpAQCAtMjk1Myw3ICsyOTU5LDcgQEAKIC8qIEFTU1VNRUQgdG8gYmUgY2FsbGVk
IGZyb20gd2l0aGluIHRoZSBIQSBsb2NrICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwog
LyogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICovCiAvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8KLXN0YXRpYyBpbmxp
bmUgdm9pZAorc3RhdGljIHZvaWQKIGlwc19wdXRxX3NjYl9oZWFkKGlwc19zY2JfcXVldWVfdCAq
IHF1ZXVlLCBpcHNfc2NiX3QgKiBpdGVtKQogewogCU1FVEhPRF9UUkFDRSgiaXBzX3B1dHFfc2Ni
X2hlYWQiLCAxKTsKQEAgLTI5NzIsMzggKzI5NzgsNiBAQAogCiAvKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
Ki8KIC8qICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqLwotLyogUm91dGluZSBOYW1lOiBpcHNfcHV0cV9zY2Jf
dGFpbCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCi0vKiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKi8KLS8qIFJvdXRpbmUgRGVzY3JpcHRpb246ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwotLyogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICovCi0vKiAgIEFkZCBhbiBpdGVtIHRvIHRoZSB0YWlsIG9mIHRoZSBxdWV1ZSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKi8KLS8qICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwotLyogQVNT
VU1FRCB0byBiZSBjYWxsZWQgZnJvbSB3aXRoaW4gdGhlIEhBIGxvY2sgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICovCi0vKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KLS8qKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqLwotc3RhdGljIGlubGluZSB2b2lkCi1pcHNfcHV0cV9zY2JfdGFpbChpcHNfc2NiX3F1ZXVl
X3QgKiBxdWV1ZSwgaXBzX3NjYl90ICogaXRlbSkKLXsKLQlNRVRIT0RfVFJBQ0UoImlwc19wdXRx
X3NjYl90YWlsIiwgMSk7Ci0KLQlpZiAoIWl0ZW0pCi0JCXJldHVybjsKLQotCWl0ZW0tPnFfbmV4
dCA9IE5VTEw7Ci0KLQlpZiAocXVldWUtPnRhaWwpCi0JCXF1ZXVlLT50YWlsLT5xX25leHQgPSBp
dGVtOwotCi0JcXVldWUtPnRhaWwgPSBpdGVtOwotCi0JaWYgKCFxdWV1ZS0+aGVhZCkKLQkJcXVl
dWUtPmhlYWQgPSBpdGVtOwotCi0JcXVldWUtPmNvdW50Kys7Ci19Ci0KLS8qKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqLwotLyogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCiAvKiBSb3V0aW5lIE5hbWU6IGlwc19yZW1v
dmVxX3NjYl9oZWFkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KIC8q
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqLwogLyogUm91dGluZSBEZXNjcmlwdGlvbjogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCkBAIC0zMDEzLDcgKzI5
ODcsNyBAQAogLyogQVNTVU1FRCB0byBiZSBjYWxsZWQgZnJvbSB3aXRoaW4gdGhlIEhBIGxvY2sg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCiAvKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KIC8q
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqLwotc3RhdGljIGlubGluZSBpcHNfc2NiX3QgKgorc3RhdGljIGlw
c19zY2JfdCAqCiBpcHNfcmVtb3ZlcV9zY2JfaGVhZChpcHNfc2NiX3F1ZXVlX3QgKiBxdWV1ZSkK
IHsKIAlpcHNfc2NiX3QgKml0ZW07CkBAIC0zMDQ4LDcgKzMwMjIsNyBAQAogLyogQVNTVU1FRCB0
byBiZSBjYWxsZWQgZnJvbSB3aXRoaW4gdGhlIEhBIGxvY2sgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICovCiAvKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KIC8qKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwot
c3RhdGljIGlubGluZSBpcHNfc2NiX3QgKgorc3RhdGljIGlwc19zY2JfdCAqCiBpcHNfcmVtb3Zl
cV9zY2IoaXBzX3NjYl9xdWV1ZV90ICogcXVldWUsIGlwc19zY2JfdCAqIGl0ZW0pCiB7CiAJaXBz
X3NjYl90ICpwOwpAQCAtMzA4NSwzNCArMzA1OSw2IEBACiAKIC8qKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
LwogLyogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICovCi0vKiBSb3V0aW5lIE5hbWU6IGlwc19wdXRxX3dhaXRf
aGVhZCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KLS8qICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAqLwotLyogUm91dGluZSBEZXNjcmlwdGlvbjogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCi0vKiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Ki8KLS8qICAgQWRkIGFuIGl0ZW0gdG8gdGhlIGhlYWQgb2YgdGhlIHF1ZXVlICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqLwotLyogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCi0vKiBBU1NV
TUVEIHRvIGJlIGNhbGxlZCBmcm9tIHdpdGhpbiB0aGUgSEEgbG9jayAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKi8KLS8qICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwotLyoqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KiovCi1zdGF0aWMgaW5saW5lIHZvaWQKLWlwc19wdXRxX3dhaXRfaGVhZChpcHNfd2FpdF9xdWV1
ZV90ICogcXVldWUsIFNjc2lfQ21uZCAqIGl0ZW0pCi17Ci0JTUVUSE9EX1RSQUNFKCJpcHNfcHV0
cV93YWl0X2hlYWQiLCAxKTsKLQotCWlmICghaXRlbSkKLQkJcmV0dXJuOwotCi0JaXRlbS0+aG9z
dF9zY3JpYmJsZSA9IChjaGFyICopIHF1ZXVlLT5oZWFkOwotCXF1ZXVlLT5oZWFkID0gaXRlbTsK
LQotCWlmICghcXVldWUtPnRhaWwpCi0JCXF1ZXVlLT50YWlsID0gaXRlbTsKLQotCXF1ZXVlLT5j
b3VudCsrOwotfQotCi0vKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8KLS8qICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAq
LwogLyogUm91dGluZSBOYW1lOiBpcHNfcHV0cV93YWl0X3RhaWwgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICovCiAvKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KIC8qIFJvdXRp
bmUgRGVzY3JpcHRpb246ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAqLwpAQCAtMzEyMiw3ICszMDY4LDcgQEAKIC8qIEFTU1VNRUQgdG8gYmUgY2Fs
bGVkIGZyb20gd2l0aGluIHRoZSBIQSBsb2NrICAgICAgICAgICAgICAgICAgICAgICAgICAgICAq
LwogLyogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICovCiAvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8KLXN0YXRpYyBp
bmxpbmUgdm9pZAorc3RhdGljIHZvaWQKIGlwc19wdXRxX3dhaXRfdGFpbChpcHNfd2FpdF9xdWV1
ZV90ICogcXVldWUsIFNjc2lfQ21uZCAqIGl0ZW0pCiB7CiAJTUVUSE9EX1RSQUNFKCJpcHNfcHV0
cV93YWl0X3RhaWwiLCAxKTsKQEAgLTMxNTQsNyArMzEwMCw3IEBACiAvKiBBU1NVTUVEIHRvIGJl
IGNhbGxlZCBmcm9tIHdpdGhpbiB0aGUgSEEgbG9jayAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKi8KIC8qICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAqLwogLyoqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCi1zdGF0
aWMgaW5saW5lIFNjc2lfQ21uZCAqCitzdGF0aWMgU2NzaV9DbW5kICoKIGlwc19yZW1vdmVxX3dh
aXRfaGVhZChpcHNfd2FpdF9xdWV1ZV90ICogcXVldWUpCiB7CiAJU2NzaV9DbW5kICppdGVtOwpA
QCAtMzE4OSw3ICszMTM1LDcgQEAKIC8qIEFTU1VNRUQgdG8gYmUgY2FsbGVkIGZyb20gd2l0aGlu
IHRoZSBIQSBsb2NrICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwogLyogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICovCiAvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8KLXN0YXRpYyBpbmxpbmUgU2NzaV9DbW5k
ICoKK3N0YXRpYyBTY3NpX0NtbmQgKgogaXBzX3JlbW92ZXFfd2FpdChpcHNfd2FpdF9xdWV1ZV90
ICogcXVldWUsIFNjc2lfQ21uZCAqIGl0ZW0pCiB7CiAJU2NzaV9DbW5kICpwOwpAQCAtMzIyNiwz
NCArMzE3Miw2IEBACiAKIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwogLyogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICovCi0vKiBSb3V0aW5lIE5hbWU6IGlwc19wdXRxX2NvcHBfaGVhZCAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKi8KLS8qICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwotLyogUm91
dGluZSBEZXNjcmlwdGlvbjogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICovCi0vKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KLS8qICAgQWRkIGFuIGl0ZW0g
dG8gdGhlIGhlYWQgb2YgdGhlIHF1ZXVlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAqLwotLyogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICovCi0vKiBBU1NVTUVEIHRvIGJlIGNhbGxlZCBmcm9t
IHdpdGhpbiB0aGUgSEEgbG9jayAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KLS8qICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqLwotLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCi1zdGF0aWMgaW5saW5lIHZv
aWQKLWlwc19wdXRxX2NvcHBfaGVhZChpcHNfY29wcF9xdWV1ZV90ICogcXVldWUsIGlwc19jb3Bw
X3dhaXRfaXRlbV90ICogaXRlbSkKLXsKLQlNRVRIT0RfVFJBQ0UoImlwc19wdXRxX2NvcHBfaGVh
ZCIsIDEpOwotCi0JaWYgKCFpdGVtKQotCQlyZXR1cm47Ci0KLQlpdGVtLT5uZXh0ID0gcXVldWUt
PmhlYWQ7Ci0JcXVldWUtPmhlYWQgPSBpdGVtOwotCi0JaWYgKCFxdWV1ZS0+dGFpbCkKLQkJcXVl
dWUtPnRhaWwgPSBpdGVtOwotCi0JcXVldWUtPmNvdW50Kys7Ci19Ci0KLS8qKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqLwotLyogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCiAvKiBSb3V0aW5lIE5hbWU6IGlwc19wdXRx
X2NvcHBfdGFpbCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KIC8q
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqLwogLyogUm91dGluZSBEZXNjcmlwdGlvbjogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCkBAIC0zMjYzLDcgKzMx
ODEsNyBAQAogLyogQVNTVU1FRCB0byBiZSBjYWxsZWQgZnJvbSB3aXRoaW4gdGhlIEhBIGxvY2sg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCiAvKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8KIC8q
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqLwotc3RhdGljIGlubGluZSB2b2lkCitzdGF0aWMgdm9pZAogaXBz
X3B1dHFfY29wcF90YWlsKGlwc19jb3BwX3F1ZXVlX3QgKiBxdWV1ZSwgaXBzX2NvcHBfd2FpdF9p
dGVtX3QgKiBpdGVtKQogewogCU1FVEhPRF9UUkFDRSgiaXBzX3B1dHFfY29wcF90YWlsIiwgMSk7
CkBAIC0zMjk1LDcgKzMyMTMsNyBAQAogLyogQVNTVU1FRCB0byBiZSBjYWxsZWQgZnJvbSB3aXRo
aW4gdGhlIEhBIGxvY2sgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCiAvKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKi8KIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwotc3RhdGljIGlubGluZSBpcHNfY29w
cF93YWl0X2l0ZW1fdCAqCitzdGF0aWMgaXBzX2NvcHBfd2FpdF9pdGVtX3QgKgogaXBzX3JlbW92
ZXFfY29wcF9oZWFkKGlwc19jb3BwX3F1ZXVlX3QgKiBxdWV1ZSkKIHsKIAlpcHNfY29wcF93YWl0
X2l0ZW1fdCAqaXRlbTsKQEAgLTMzMzAsNyArMzI0OCw3IEBACiAvKiBBU1NVTUVEIHRvIGJlIGNh
bGxlZCBmcm9tIHdpdGhpbiB0aGUgSEEgbG9jayAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Ki8KIC8qICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqLwogLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCi1zdGF0aWMg
aW5saW5lIGlwc19jb3BwX3dhaXRfaXRlbV90ICoKK3N0YXRpYyBpcHNfY29wcF93YWl0X2l0ZW1f
dCAqCiBpcHNfcmVtb3ZlcV9jb3BwKGlwc19jb3BwX3F1ZXVlX3QgKiBxdWV1ZSwgaXBzX2NvcHBf
d2FpdF9pdGVtX3QgKiBpdGVtKQogewogCWlwc19jb3BwX3dhaXRfaXRlbV90ICpwOwpAQCAtNDAx
NCw3ICszOTMyLDcgQEAKIAkJCXNjYi0+Y21kLmxvZ2ljYWxfaW5mby5yZXNlcnZlZDIgPSAwOwog
CQkJc2NiLT5jbWQubG9naWNhbF9pbmZvLnJlc2VydmVkMyA9IDA7CiAJCQlzY2ItPmRhdGFfbGVu
ID0gc2l6ZW9mIChJUFNfTERfSU5GTyk7Ci0gICAgICAgICAgICBzY2ItPmRhdGFfYnVzYWRkciA9
IGhhLT5sb2dpY2FsX2RyaXZlX2luZm9fZG1hX2FkZHI7CisJCQlzY2ItPmRhdGFfYnVzYWRkciA9
IGhhLT5sb2dpY2FsX2RyaXZlX2luZm9fZG1hX2FkZHI7CiAJCQlzY2ItPmZsYWdzID0gMDsKIAkJ
CXNjYi0+Y21kLmxvZ2ljYWxfaW5mby5idWZmZXJfYWRkciA9IHNjYi0+ZGF0YV9idXNhZGRyOwog
CQkJcmV0ID0gSVBTX1NVQ0NFU1M7CkBAIC00MzQwLDcgKzQyNTgsNyBAQAogCiAJaWYgKChzY2It
PmJhc2ljX3N0YXR1cyAmIElQU19HU0NfU1RBVFVTX01BU0spID4gMSkgewogCQltZW1zZXQoaGEt
PmxvZ2ljYWxfZHJpdmVfaW5mbywgMCwgc2l6ZW9mIChJUFNfTERfSU5GTykpOwotICAgICAgICBy
ZXR1cm4gKDApOworCQlyZXR1cm4gKDApOwogCX0KIAogCWlmIChoYS0+bG9naWNhbF9kcml2ZV9p
bmZvLT5kcml2ZV9pbmZvW3NjYi0+dGFyZ2V0X2lkXS5zdGF0ZSAhPQpAQCAtNDU3OSw3ICs0NDk3
LDcgQEAKIAkJaWYgKGhhLT5sb2dpY2FsX2RyaXZlX2luZm8pIHsKIAkJCXBjaV9mcmVlX2NvbnNp
c3RlbnQoaGEtPnBjaWRldiwKIAkJCQkJICAgIHNpemVvZiAoSVBTX0xEX0lORk8pLAotICAgICAg
ICAgICAgICAgICAgICAgICAgaGEtPmxvZ2ljYWxfZHJpdmVfaW5mbywKKwkJCQkJICAgIGhhLT5s
b2dpY2FsX2RyaXZlX2luZm8sCiAJCQkJCSAgICBoYS0+bG9naWNhbF9kcml2ZV9pbmZvX2RtYV9h
ZGRyKTsKIAkJCWhhLT5sb2dpY2FsX2RyaXZlX2luZm8gPSBOVUxMOwogCQl9CkBAIC00NzczLDcg
KzQ2OTEsNyBAQAogCX0KIAogCWhhLT5zY2JfZnJlZWxpc3QgPSBzY2ItPnFfbmV4dDsKLSAgICBz
Y2ItPmZsYWdzID0gMDsKKwlzY2ItPmZsYWdzID0gMDsKIAlzY2ItPnFfbmV4dCA9IE5VTEw7CiAK
IAlpcHNfaW5pdF9zY2IoaGEsIHNjYik7CkBAIC02ODMxLDcgKzY3NDksNyBAQAogCiAJTUVUSE9E
X1RSQUNFKCJpcHNfdmVyc2lvbl9jaGVjayIsIDEpOwogCi0gICAgVmVyc2lvbkluZm8gPSAoIElQ
U19WRVJTSU9OX0RBVEEgKiApIGhhLT5pb2N0bF9kYXRhOworCVZlcnNpb25JbmZvID0gKCBJUFNf
VkVSU0lPTl9EQVRBICogKSBoYS0+aW9jdGxfZGF0YTsKIAogCW1lbXNldChGaXJtd2FyZVZlcnNp
b24sIDAsIElQU19DT01QQVRfSURfTEVOR1RIICsgMSk7CiAJbWVtc2V0KEJpb3NWZXJzaW9uLCAw
LCBJUFNfQ09NUEFUX0lEX0xFTkdUSCArIDEpOwpAQCAtNjg0Myw3ICs2NzYxLDcgQEAKIAlyYyA9
IElQU19GQUlMVVJFOwogCWlmIChoYS0+c3Vic3lzLT5wYXJhbVs0XSAmIElQU19HRVRfVkVSU0lP
Tl9TVVBQT1JUKSB7CS8qIElmIFZlcnNpb25pbmcgaXMgU3VwcG9ydGVkICovCiAJCS8qIEdldCB0
aGUgVmVyc2lvbiBJbmZvIHdpdGggYSBHZXQgVmVyc2lvbiBDb21tYW5kICovCi0gICAgICAgIG1l
bXNldCggVmVyc2lvbkluZm8sIDAsIHNpemVvZiAoSVBTX1ZFUlNJT05fREFUQSkpOworCQltZW1z
ZXQoIFZlcnNpb25JbmZvLCAwLCBzaXplb2YgKElQU19WRVJTSU9OX0RBVEEpKTsKIAkJcmMgPSBp
cHNfZ2V0X3ZlcnNpb25faW5mbyhoYSwgaGEtPmlvY3RsX2J1c2FkZHIsIGludHIpOwogCQlpZiAo
cmMgPT0gSVBTX1NVQ0NFU1MpCiAJCQltZW1jcHkoRmlybXdhcmVWZXJzaW9uLCBWZXJzaW9uSW5m
by0+Y29tcGF0aWJpbGl0eUlkLApAQCAtNjk5OSw3ICs2OTE3LDYgQEAKIAkJCWZvciAoaiA9IHBv
c2l0aW9uOyBqIDwgaXBzX251bV9jb250cm9sbGVyczsgaisrKSB7CiAJCQkJc3dpdGNoIChpcHNf
aGFbal0tPmFkX3R5cGUpIHsKIAkJCQljYXNlIElQU19BRFRZUEVfU0VSVkVSQUlENk06Ci0JCQkJ
Y2FzZSBJUFNfQURUWVBFX1NFUlZFUkFJRDdrOgogCQkJCWNhc2UgSVBTX0FEVFlQRV9TRVJWRVJB
SUQ3TToKIAkJCQkJaWYgKG52cmFtLT5hZGFwdGVyX29yZGVyW2ldID09ICdNJykgewogCQkJCQkJ
aXBzX3NoaWZ0X2NvbnRyb2xsZXJzKHBvc2l0aW9uLApAQCAtNzAyMCw2ICs2OTM3LDcgQEAKIAkJ
CQljYXNlIElQU19BRFRZUEVfU0VSVkVSQUlENkk6CiAJCQkJY2FzZSBJUFNfQURUWVBFX1NFUlZF
UkFJRDVJMjoKIAkJCQljYXNlIElQU19BRFRZUEVfU0VSVkVSQUlENUkxOgorCQkJCWNhc2UgSVBT
X0FEVFlQRV9TRVJWRVJBSUQ3azoKIAkJCQkJaWYgKG52cmFtLT5hZGFwdGVyX29yZGVyW2ldID09
ICdTJykgewogCQkJCQkJaXBzX3NoaWZ0X2NvbnRyb2xsZXJzKHBvc2l0aW9uLAogCQkJCQkJCQkg
ICAgICBqKTsKQEAgLTc1NDcsNiArNzQ2NSwxMyBAQAogI2lmIExJTlVYX1ZFUlNJT05fQ09ERSA+
PSBLRVJORUxfVkVSU0lPTigyLDQsOSkKIE1PRFVMRV9MSUNFTlNFKCJHUEwiKTsKICNlbmRpZgor
CitNT0RVTEVfREVTQ1JJUFRJT04oIklCTSBTZXJ2ZVJBSUQgQWRhcHRlciBEcml2ZXIgIiBJUFNf
VkVSX1NUUklORyk7CisKKyNpZmRlZiBNT0RVTEVfVkVSU0lPTgorTU9EVUxFX1ZFUlNJT04oSVBT
X1ZFUl9TVFJJTkcpOworI2VuZGlmCisKIAogLyoKICAqIE92ZXJyaWRlcyBmb3IgRW1hY3Mgc28g
dGhhdCB3ZSBhbG1vc3QgZm9sbG93IExpbnVzJ3MgdGFiYmluZyBzdHlsZS4KLS0tIGxpbnV4Lm9y
aWcvZHJpdmVycy9zY3NpL2lwcy5oCVdlZCBBdWcgMjUgMTA6MjE6NTMgMjAwNAorKysgbGludXgv
ZHJpdmVycy9zY3NpL2lwcy5oCVdlZCBBdWcgMjUgMTA6MjU6MzQgMjAwNApAQCAtOTUsMTQgKzk1
LDE1IEBACiAgICAgICAjZGVmaW5lIHNjc2lfc2V0X3BjaV9kZXZpY2Uoc2gsZGV2KSAoMCkKICAg
ICNlbmRpZgogCi0gICAjaWYgTElOVVhfVkVSU0lPTl9DT0RFIDwgS0VSTkVMX1ZFUlNJT04oMiw0
LDIzKQotICAgICAgdHlwZWRlZiB2b2lkIGlycXJldHVybl90OworICAgI2lmIExJTlVYX1ZFUlNJ
T05fQ09ERSA8IEtFUk5FTF9WRVJTSU9OKDIsNSwwKQorICAgCisgICAgICAjaWZuZGVmIGlycXJl
dHVybl90CisgICAgICAgICB0eXBlZGVmIHZvaWQgaXJxcmV0dXJuX3Q7CisgICAgICAjZW5kaWYg
CisgICAgICAKICAgICAgICNkZWZpbmUgSVJRX05PTkUKICAgICAgICNkZWZpbmUgSVJRX0hBTkRM
RUQKICAgICAgICNkZWZpbmUgSVJRX1JFVFZBTCh4KQotICAgI2VuZGlmCi0KLSAgICNpZiBMSU5V
WF9WRVJTSU9OX0NPREUgPCBLRVJORUxfVkVSU0lPTigyLDUsMCkKICAgICAgICNkZWZpbmUgSVBT
X1JFR0lTVEVSX0hPU1RTKFNIVCkgICAgICBzY3NpX3JlZ2lzdGVyX21vZHVsZShNT0RVTEVfU0NT
SV9IQSxTSFQpCiAgICAgICAjZGVmaW5lIElQU19VTlJFR0lTVEVSX0hPU1RTKFNIVCkgICAgc2Nz
aV91bnJlZ2lzdGVyX21vZHVsZShNT0RVTEVfU0NTSV9IQSxTSFQpCiAgICAgICAjZGVmaW5lIElQ
U19BRERfSE9TVChzaG9zdCxkZXZpY2UpCkBAIC0xMjEzLDEzICsxMjE0LDEzIEBACiAKICNkZWZp
bmUgSVBTX1ZFUl9NQUpPUiA3CiAjZGVmaW5lIElQU19WRVJfTUFKT1JfU1RSSU5HICI3IgotI2Rl
ZmluZSBJUFNfVkVSX01JTk9SIDAwCi0jZGVmaW5lIElQU19WRVJfTUlOT1JfU1RSSU5HICIwMCIK
LSNkZWZpbmUgSVBTX1ZFUl9CVUlMRCAxNQotI2RlZmluZSBJUFNfVkVSX0JVSUxEX1NUUklORyAi
MTUiCi0jZGVmaW5lIElQU19WRVJfU1RSSU5HICI3LjAwLjE1IgorI2RlZmluZSBJUFNfVkVSX01J
Tk9SIDEwCisjZGVmaW5lIElQU19WRVJfTUlOT1JfU1RSSU5HICIxMCIKKyNkZWZpbmUgSVBTX1ZF
Ul9CVUlMRCAxOAorI2RlZmluZSBJUFNfVkVSX0JVSUxEX1NUUklORyAiMTgiCisjZGVmaW5lIElQ
U19WRVJfU1RSSU5HICI3LjEwLjE4IgogI2RlZmluZSBJUFNfUkVMRUFTRV9JRCAweDAwMDIwMDAw
Ci0jZGVmaW5lIElQU19CVUlMRF9JREVOVCA2MjUKKyNkZWZpbmUgSVBTX0JVSUxEX0lERU5UIDcz
MQogI2RlZmluZSBJUFNfTEVHQUxDT1BZUklHSFRfU1RSSU5HICIoQykgQ29weXJpZ2h0IElCTSBD
b3JwLiAxOTk0LCAyMDAyLiBBbGwgUmlnaHRzIFJlc2VydmVkLiIKICNkZWZpbmUgSVBTX0FEQVBU
RUNDT1BZUklHSFRfU1RSSU5HICIoYykgQ29weXJpZ2h0IEFkYXB0ZWMsIEluYy4gMjAwMiB0byAy
MDA0LiBBbGwgUmlnaHRzIFJlc2VydmVkLiIKICNkZWZpbmUgSVBTX0RFTExDT1BZUklHSFRfU1RS
SU5HICIoYykgQ29weXJpZ2h0IERlbGwgMjAwNC4gQWxsIFJpZ2h0cyBSZXNlcnZlZC4iCkBAIC0x
MjMwLDMyICsxMjMxLDM1IEBACiAjZGVmaW5lIElQU19WRVJfU0VSVkVSQUlEMiAiMi44OC4xMyIK
ICNkZWZpbmUgSVBTX1ZFUl9OQVZBSk8gIjIuODguMTMiCiAjZGVmaW5lIElQU19WRVJfU0VSVkVS
QUlEMyAiNi4xMC4yNCIKLSNkZWZpbmUgSVBTX1ZFUl9TRVJWRVJBSUQ0SCAiNy4wMC4xNSIKLSNk
ZWZpbmUgSVBTX1ZFUl9TRVJWRVJBSUQ0TUx4ICI3LjAwLjE1IgotI2RlZmluZSBJUFNfVkVSX1NB
UkFTT1RBICI3LjAwLjE1IgotI2RlZmluZSBJUFNfVkVSX01BUkNPICI3LjAwLjE1IgotI2RlZmlu
ZSBJUFNfVkVSX1NFQlJJTkcgIjcuMDAuMTUiCisjZGVmaW5lIElQU19WRVJfU0VSVkVSQUlENEgg
IjcuMTAuMTEiCisjZGVmaW5lIElQU19WRVJfU0VSVkVSQUlENE1MeCAiNy4xMC4xOCIKKyNkZWZp
bmUgSVBTX1ZFUl9TQVJBU09UQSAiNy4xMC4xOCIKKyNkZWZpbmUgSVBTX1ZFUl9NQVJDTyAiNy4x
MC4xOCIKKyNkZWZpbmUgSVBTX1ZFUl9TRUJSSU5HICI3LjEwLjE4IgorI2RlZmluZSBJUFNfVkVS
X0tFWVdFU1QgIjcuMTAuMTgiCiAKIC8qIENvbXBhdGFiaWxpdHkgSURzIGZvciB2YXJpb3VzIGFk
YXB0ZXJzICovCiAjZGVmaW5lIElQU19DT01QQVRfVU5LTk9XTiAiIgotI2RlZmluZSBJUFNfQ09N
UEFUX0NVUlJFTlQgIlNCNjEwIgorI2RlZmluZSBJUFNfQ09NUEFUX0NVUlJFTlQgIktXNzEwIgog
I2RlZmluZSBJUFNfQ09NUEFUX1NFUlZFUkFJRDEgIjIuMjUuMDEiCiAjZGVmaW5lIElQU19DT01Q
QVRfU0VSVkVSQUlEMiAiMi44OC4xMyIKICNkZWZpbmUgSVBTX0NPTVBBVF9OQVZBSk8gICIyLjg4
LjEzIgogI2RlZmluZSBJUFNfQ09NUEFUX0tJT1dBICIyLjg4LjEzIgogI2RlZmluZSBJUFNfQ09N
UEFUX1NFUlZFUkFJRDNIICAiU0I2MTAiCiAjZGVmaW5lIElQU19DT01QQVRfU0VSVkVSQUlEM0wg
ICJTQjYxMCIKLSNkZWZpbmUgSVBTX0NPTVBBVF9TRVJWRVJBSUQ0SCAgIlNCNjEwIgotI2RlZmlu
ZSBJUFNfQ09NUEFUX1NFUlZFUkFJRDRNICAiU0I2MTAiCi0jZGVmaW5lIElQU19DT01QQVRfU0VS
VkVSQUlENEwgICJTQjYxMCIKLSNkZWZpbmUgSVBTX0NPTVBBVF9TRVJWRVJBSUQ0TXggIlNCNjEw
IgotI2RlZmluZSBJUFNfQ09NUEFUX1NFUlZFUkFJRDRMeCAiU0I2MTAiCi0jZGVmaW5lIElQU19D
T01QQVRfU0FSQVNPVEEgICAgICJTQjYxMCIKLSNkZWZpbmUgSVBTX0NPTVBBVF9NQVJDTyAgICAg
ICAgIlNCNjEwIgotI2RlZmluZSBJUFNfQ09NUEFUX1NFQlJJTkcgICAgICAiU0I2MTAiCi0jZGVm
aW5lIElQU19DT01QQVRfQklPUyAiU0I2MTAiCisjZGVmaW5lIElQU19DT01QQVRfU0VSVkVSQUlE
NEggICJLVzcxMCIKKyNkZWZpbmUgSVBTX0NPTVBBVF9TRVJWRVJBSUQ0TSAgIktXNzEwIgorI2Rl
ZmluZSBJUFNfQ09NUEFUX1NFUlZFUkFJRDRMICAiS1c3MTAiCisjZGVmaW5lIElQU19DT01QQVRf
U0VSVkVSQUlENE14ICJLVzcxMCIKKyNkZWZpbmUgSVBTX0NPTVBBVF9TRVJWRVJBSUQ0THggIktX
NzEwIgorI2RlZmluZSBJUFNfQ09NUEFUX1NBUkFTT1RBICAgICAiS1c3MTAiCisjZGVmaW5lIElQ
U19DT01QQVRfTUFSQ08gICAgICAgICJLVzcxMCIKKyNkZWZpbmUgSVBTX0NPTVBBVF9TRUJSSU5H
ICAgICAgIktXNzEwIgorI2RlZmluZSBJUFNfQ09NUEFUX1RBTVBBICAgICAgICAiS1c3MTAiCisj
ZGVmaW5lIElQU19DT01QQVRfS0VZV0VTVCAgICAgICJLVzcxMCIKKyNkZWZpbmUgSVBTX0NPTVBB
VF9CSU9TICJLVzcxMCIKIAotI2RlZmluZSBJUFNfQ09NUEFUX01BWF9BREFQVEVSX1RZUEUgMTYK
KyNkZWZpbmUgSVBTX0NPTVBBVF9NQVhfQURBUFRFUl9UWVBFIDE4CiAjZGVmaW5lIElQU19DT01Q
QVRfSURfTEVOR1RIIDgKIAogI2RlZmluZSBJUFNfREVGSU5FX0NPTVBBVF9UQUJMRSh0YWJsZW5h
bWUpIFwKQEAgLTEyNzUsNyArMTI3OSw5IEBACiAgICAgICBJUFNfQ09NUEFUX1NBUkFTT1RBLCAg
ICAgICAgIC8qIG9uZS1jaGFubmVsIHZhcmlldHkgb2YgU0FSQVNPVEEgKi8gIFwKICAgICAgIElQ
U19DT01QQVRfU0FSQVNPVEEsICAgICAgICAgLyogdHdvLWNoYW5uZWwgdmFyaWV0eSBvZiBTQVJB
U09UQSAqLyAgXAogICAgICAgSVBTX0NPTVBBVF9NQVJDTywgXAotICAgICAgSVBTX0NPTVBBVF9T
RUJSSU5HIFwKKyAgICAgIElQU19DT01QQVRfU0VCUklORywgXAorCSAgSVBTX0NPTVBBVF9UQU1Q
QSwgXAorICAgICAgSVBTX0NPTVBBVF9LRVlXRVNUIFwKICAgIH0KIAogCg==

------_=_NextPart_001_01C48BA1.DD4942FF--
