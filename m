From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: FW: [PATCH] 2.4.25-pre4 SCSI fusion driver
Date: Fri, 9 Jan 2004 18:46:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703A758C4@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C3D70A.D5BF6180"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45816 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264331AbUAIXrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2004 18:47:20 -0500
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C3D70A.D5BF6180
Content-Type: text/plain;
	charset="iso-8859-1"

Here's a patch for mpt fusion version 2.5.11 driver.
Thankyou Xose for creating the patch.

- Changes For Version 02.05.11 against kernel 2.4.25-pre4 
driver(02.05.05+)
 
   The driver now supports up 256 Luns per device Id.
 
   The Maximum Outstanding Split Transactions (MOST) is set to 
 1 for the
   919X and 929X chips.  This prevents a possible data corruption
   situation when using those chips.
 
   The ReqToChain fields are now properly set via a loop using 
 a defined
   value rather than a memset function call during adapter structure
   initialization. This prevents a panic situation seen on an Opteron
   x86_64 system.
 
   If a data underrun condition exists and the amount of data 
 transferred
   is less than the command?s underflow amount, an error 
 status is returned
   rather than a good status.  This prevents a false good 
 status from being
   returned and allows the upper SCSI layer to retry the 
 command if needed.
 
   A "for" loop replaces a "while" loop during adapter detection. This
   prevents a possible infinite loop during initialization.
 
   A generic compatible ioctl interface replaces a sparc 
 specific interface,
   to allow a fuller range of systems to work with the ioctl interface.
   The sys_ioctl linkage is now used.  The ioctl interface is 
 now properly
   unregistered if a failure occurs during ioctl initialization. This
   prevents a possible panic situation.
 
   Performance enhancements were made.
 
   Check SCSI Port Page 2 DV bits to either disable DV or limit DV to
   Inquiry only checks.
 
   Added sequence to allow the ID of a SAF-TE device to be stored in
   IOC Page 4.
 
   The driver now checks NVRAM data and performs Level 1 Domain
   Validation only if requested.  This limitation can be set on a
   per-device basis via the LSI Configuration Utility.
 
   The IOC Page 4 read is now done after the SCSI Port Settings
   and the SCSI Device Page Headers are obtained.
 
   The return code from pci_map_sg is checked and a FAILED
   status is returned if the return code indicates that a failure
   occurred, as Scatter/Gather entries are being obtained.
 
   If IOCStatus of MPI_IOCSTATUS_STATUS_RESIDUAL_MISMATCH
   is received, an error status is returned to the SCSI layer.
   This status is received when the Fibre Channel firmware detects
   a CRC error during a data transfer.
 
   If the SCSI layer request an abort or bus reset for an
   IO that is not currently running, an error status is returned
   and the scsi_done call is not performed.  This prevents problems
   when the IO has completed before the abort or bus reset is received.
 
   In a mixed device configuration (Ultra 320 and Non-Ultra
   320 devices are present on an HBA channel), code was fixed 
 to prevent
   negotiating for QAS on all Ultra 320 devices on that channel.
   This keeps the Ultra 320 devices from dominating the SCSI bus,
   preventing Non-Ultra 320 IOs from executing.
 
   The SenseBufferLength field is properly set when an IOCTL
   IO is processed.  This allows sense data to be obtained and returned
   to the application if a Check Condition occurs on the IO.
 
   Zero out unused CDB field on SCSI IO commands.


------_=_NextPart_000_01C3D70A.D5BF6180
Content-Type: text/plain;
	name="mptlinux-2.05.11.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-2.05.11.patch"

diff -Nuar linux/drivers/message/fusion/isense.c =
11/drivers/message/fusion/isense.c
--- linux/drivers/message/fusion/isense.c	2004-01-09 16:35:24.000000000 =
+0100
+++ 11/drivers/message/fusion/isense.c	2003-09-03 14:58:08.000000000 =
+0200
@@ -9,7 +9,7 @@
  *  Written By: Steven J. Ralston
  *  (yes I wrote some of the orig. code back in 1991!)
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: isense.c,v 1.34 2003/03/18 22:49:48 pdelaney Exp $
  */
diff -Nuar linux/drivers/message/fusion/linux_compat.h =
11/drivers/message/fusion/linux_compat.h
--- linux/drivers/message/fusion/linux_compat.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/linux_compat.h	2003-09-03 =
14:58:08.000000000 +0200
@@ -93,7 +93,7 @@
  * Used prior to schedule_timeout calls..
  */
 #define __set_current_state(state_value)	do { current->state =3D =
state_value; } while (0)
-#ifdef CONFIG_SMP
+#ifdef __SMP__
 #define set_current_state(state_value)		do { =
__set_current_state(state_value); mb(); } while (0)
 #else
 #define set_current_state(state_value)		=
__set_current_state(state_value)
@@ -267,9 +267,9 @@
 #endif
=20
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,5,28)
-#define mptscsih_sync_irq(_irq) synchronize_irq(_irq)
+#define mpt_sync_irq(_irq) synchronize_irq(_irq)
 #else
-#define mptscsih_sync_irq(_irq) synchronize_irq()
+#define mpt_sync_irq(_irq) synchronize_irq()
 #endif
=20
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,5,58)
diff -Nuar linux/drivers/message/fusion/lsi/mpi_cnfg.h =
11/drivers/message/fusion/lsi/mpi_cnfg.h
--- linux/drivers/message/fusion/lsi/mpi_cnfg.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/lsi/mpi_cnfg.h	2003-06-28 =
13:10:17.000000000 +0200
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2002 LSI Logic Corporation.
+ *  Copyright (c) 2000-2003 LSI Logic Corporation.
  *
  *
  *           Name:  MPI_CNFG.H
  *          Title:  MPI Config message, structures, and Pages
  *  Creation Date:  July 27, 2000
  *
- *    MPI_CNFG.H Version:  01.02.09
+ *    MPI_CNFG.H Version:  01.02.12
  *
  *  Version History
  *  ---------------
@@ -127,7 +127,24 @@
  *                      MPI_SCSIDEVPAGE1_CONF_EXTENDED_PARAMS_ENABLE.
  *                      Added new config page: =
CONFIG_PAGE_SCSI_DEVICE_3.
  *                      Modified MPI_FCPORTPAGE5_FLAGS_ defines.
- *  09-16-02 01.02.09   Added more MPI_SCSIDEVPAGE1_CONF_FORCE_PPR_MSG =
define.
+ *  09-16-02 01.02.09   Added MPI_SCSIDEVPAGE1_CONF_FORCE_PPR_MSG =
define.
+ *  11-15-02 01.02.10   Added ConnectedID defines for =
CONFIG_PAGE_SCSI_PORT_0.
+ *                      Added more Flags defines for =
CONFIG_PAGE_FC_PORT_1.
+ *                      Added more Flags defines for =
CONFIG_PAGE_FC_DEVICE_0.
+ *  04-01-03 01.02.11   Added RR_TOV field and additional Flags =
defines for
+ *                      CONFIG_PAGE_FC_PORT_1.
+ *                      Added define MPI_FCPORTPAGE5_FLAGS_DISABLE to =
disable
+ *                      an alias.
+ *                      Added more device id defines.
+ *  06-26-03 01.02.12   Added MPI_IOUNITPAGE1_IR_USE_STATIC_VOLUME_ID =
define.
+ *                      Added TargetConfig and IDConfig fields to
+ *                      CONFIG_PAGE_SCSI_PORT_1.
+ *                      Added more PortFlags defines for =
CONFIG_PAGE_SCSI_PORT_2
+ *                      to control DV.
+ *                      Added more Flags defines for =
CONFIG_PAGE_FC_PORT_1.
+ *                      In CONFIG_PAGE_FC_DEVICE_0, replaced Reserved1 =
field
+ *                      with ADISCHardALPA.
+ *                      Added MPI_FC_DEVICE_PAGE0_PROT_FCP_RETRY =
define.
  *  =
------------------------------------------------------------------------=
--
  */
=20
@@ -281,6 +298,9 @@
 =
/***********************************************************************=
*****
 *   Manufacturing Config pages
 =
************************************************************************=
****/
+#define MPI_MANUFACTPAGE_VENDORID_LSILOGIC          (0x1000)
+#define MPI_MANUFACTPAGE_VENDORID_TREBIA            (0x1783)
+
 #define MPI_MANUFACTPAGE_DEVICEID_FC909             (0x0621)
 #define MPI_MANUFACTPAGE_DEVICEID_FC919             (0x0624)
 #define MPI_MANUFACTPAGE_DEVICEID_FC929             (0x0622)
@@ -299,6 +319,10 @@
 #define MPI_MANUFACTPAGE_DEVID_SA2020               (0x0806)
 #define MPI_MANUFACTPAGE_DEVID_SA2020ZC             (0x0807)
=20
+#define MPI_MANUFACTPAGE_DEVID_SNP1000              (0x0010)
+#define MPI_MANUFACTPAGE_DEVID_SNP500               (0x0020)
+
+
=20
 typedef struct _CONFIG_PAGE_MANUFACTURING_0
 {
@@ -422,6 +446,7 @@
 #define MPI_IOUNITPAGE1_SINGLE_FUNCTION                 (0x00000001)
 #define MPI_IOUNITPAGE1_MULTI_PATHING                   (0x00000002)
 #define MPI_IOUNITPAGE1_SINGLE_PATHING                  (0x00000000)
+#define MPI_IOUNITPAGE1_IR_USE_STATIC_VOLUME_ID         (0x00000004)
 #define MPI_IOUNITPAGE1_DISABLE_IR                      (0x00000040)
 #define MPI_IOUNITPAGE1_FORCE_32                        (0x00000080)
=20
@@ -694,6 +719,10 @@
 #define MPI_SCSIPORTPAGE0_PHY_SIGNAL_HVD                (0x01)
 #define MPI_SCSIPORTPAGE0_PHY_SIGNAL_SE                 (0x02)
 #define MPI_SCSIPORTPAGE0_PHY_SIGNAL_LVD                (0x03)
+#define MPI_SCSIPORTPAGE0_PHY_MASK_CONNECTED_ID         (0xFF000000)
+#define MPI_SCSIPORTPAGE0_PHY_SHIFT_CONNECTED_ID        (24)
+#define MPI_SCSIPORTPAGE0_PHY_BUS_FREE_CONNECTED_ID     (0xFE)
+#define MPI_SCSIPORTPAGE0_PHY_UNKNOWN_CONNECTED_ID      (0xFF)
=20
=20
 typedef struct _CONFIG_PAGE_SCSI_PORT_1
@@ -701,14 +730,22 @@
     fCONFIG_PAGE_HEADER      Header;                     /* 00h */
     U32                     Configuration;              /* 04h */
     U32                     OnBusTimerValue;            /* 08h */
+    U8                      TargetConfig;               /* 0Ch */
+    U8                      Reserved1;                  /* 0Dh */
+    U16                     IDConfig;                   /* 0Eh */
 } fCONFIG_PAGE_SCSI_PORT_1, MPI_POINTER PTR_CONFIG_PAGE_SCSI_PORT_1,
   SCSIPortPage1_t, MPI_POINTER pSCSIPortPage1_t;
=20
 #define MPI_SCSIPORTPAGE1_PAGEVERSION                   (0x02)
=20
+/* Configuration values */
 #define MPI_SCSIPORTPAGE1_CFG_PORT_SCSI_ID_MASK         (0x000000FF)
 #define MPI_SCSIPORTPAGE1_CFG_PORT_RESPONSE_ID_MASK     (0xFFFF0000)
=20
+/* TargetConfig values */
+#define MPI_SCSIPORTPAGE1_TARGCONFIG_TARG_ONLY        (0x01)
+#define MPI_SCSIPORTPAGE1_TARGCONFIG_INIT_TARG        (0x02)
+
=20
 typedef struct _MPI_DEVICE_INFO
 {
@@ -727,13 +764,20 @@
 } fCONFIG_PAGE_SCSI_PORT_2, MPI_POINTER PTR_CONFIG_PAGE_SCSI_PORT_2,
   SCSIPortPage2_t, MPI_POINTER pSCSIPortPage2_t;
=20
-#define MPI_SCSIPORTPAGE2_PAGEVERSION                       (0x01)
+#define MPI_SCSIPORTPAGE2_PAGEVERSION                       (0x02)
=20
+/* PortFlags values */
 #define MPI_SCSIPORTPAGE2_PORT_FLAGS_SCAN_HIGH_TO_LOW       =
(0x00000001)
 #define MPI_SCSIPORTPAGE2_PORT_FLAGS_AVOID_SCSI_RESET       =
(0x00000004)
 #define MPI_SCSIPORTPAGE2_PORT_FLAGS_ALTERNATE_CHS          =
(0x00000008)
 #define MPI_SCSIPORTPAGE2_PORT_FLAGS_TERMINATION_DISABLE    =
(0x00000010)
=20
+#define MPI_SCSIPORTPAGE2_PORT_FLAGS_DV_MASK                =
(0x00000060)
+#define MPI_SCSIPORTPAGE2_PORT_FLAGS_FULL_DV                =
(0x00000000)
+#define MPI_SCSIPORTPAGE2_PORT_FLAGS_BASIC_DV_ONLY          =
(0x00000020)
+#define MPI_SCSIPORTPAGE2_PORT_FLAGS_OFF_DV                 =
(0x00000060)
+
+/* PortSettings values */
 #define MPI_SCSIPORTPAGE2_PORT_HOST_ID_MASK                 =
(0x0000000F)
 #define MPI_SCSIPORTPAGE2_PORT_MASK_INIT_HBA                =
(0x00000030)
 #define MPI_SCSIPORTPAGE2_PORT_DISABLE_INIT_HBA             =
(0x00000000)
@@ -915,7 +959,7 @@
=20
 #define MPI_FCPORTPAGE0_FLAGS_ALIAS_ALPA_SUPPORTED      (0x00000010)
 #define MPI_FCPORTPAGE0_FLAGS_ALIAS_WWN_SUPPORTED       (0x00000020)
-#define MPI_FCPORTPAGE0_FLAGS_FABRIC_WWN_VALID          (0x00000030)
+#define MPI_FCPORTPAGE0_FLAGS_FABRIC_WWN_VALID          (0x00000040)
=20
 #define MPI_FCPORTPAGE0_FLAGS_ATTACH_TYPE_MASK          (0x00000F00)
 #define MPI_FCPORTPAGE0_FLAGS_ATTACH_NO_INIT            (0x00000000)
@@ -974,15 +1018,23 @@
     U8                      TopologyConfig;             /* 1Ah */
     U8                      AltConnector;               /* 1Bh */
     U8                      NumRequestedAliases;        /* 1Ch */
-    U8                      Reserved1;                  /* 1Dh */
+    U8                      RR_TOV;                     /* 1Dh */
     U16                     Reserved2;                  /* 1Eh */
 } fCONFIG_PAGE_FC_PORT_1, MPI_POINTER PTR_CONFIG_PAGE_FC_PORT_1,
   FCPortPage1_t, MPI_POINTER pFCPortPage1_t;
=20
-#define MPI_FCPORTPAGE1_PAGEVERSION                     (0x04)
+#define MPI_FCPORTPAGE1_PAGEVERSION                     (0x05)
=20
 #define MPI_FCPORTPAGE1_FLAGS_EXT_FCP_STATUS_EN         (0x08000000)
 #define MPI_FCPORTPAGE1_FLAGS_IMMEDIATE_ERROR_REPLY     (0x04000000)
+#define MPI_FCPORTPAGE1_FLAGS_FORCE_USE_NOSEEPROM_WWNS  (0x02000000)
+#define MPI_FCPORTPAGE1_FLAGS_VERBOSE_RESCAN_EVENTS     (0x01000000)
+#define MPI_FCPORTPAGE1_FLAGS_TARGET_MODE_OXID          (0x00800000)
+#define MPI_FCPORTPAGE1_FLAGS_PORT_OFFLINE              (0x00400000)
+#define MPI_FCPORTPAGE1_FLAGS_MASK_RR_TOV_UNITS         (0x00000070)
+#define MPI_FCPORTPAGE1_FLAGS_SUPPRESS_PROT_REG         (0x00000008)
+#define MPI_FCPORTPAGE1_FLAGS_PLOGI_ON_LOGO             (0x00000004)
+#define MPI_FCPORTPAGE1_FLAGS_MAINTAIN_LOGINS           (0x00000002)
 #define MPI_FCPORTPAGE1_FLAGS_SORT_BY_DID               (0x00000001)
 #define MPI_FCPORTPAGE1_FLAGS_SORT_BY_WWN               (0x00000000)
=20
@@ -993,6 +1045,11 @@
 #define MPI_FCPORTPAGE1_FLAGS_PROT_LAN                  =
((U32)MPI_PORTFACTS_PROTOCOL_LAN << MPI_FCPORTPAGE1_FLAGS_PROT_SHIFT)
 #define MPI_FCPORTPAGE1_FLAGS_PROT_LOGBUSADDR           =
((U32)MPI_PORTFACTS_PROTOCOL_LOGBUSADDR << =
MPI_FCPORTPAGE1_FLAGS_PROT_SHIFT)
=20
+#define MPI_FCPORTPAGE1_FLAGS_NONE_RR_TOV_UNITS         (0x00000000)
+#define MPI_FCPORTPAGE1_FLAGS_THOUSANDTH_RR_TOV_UNITS   (0x00000010)
+#define MPI_FCPORTPAGE1_FLAGS_TENTH_RR_TOV_UNITS        (0x00000030)
+#define MPI_FCPORTPAGE1_FLAGS_TEN_RR_TOV_UNITS          (0x00000050)
+
 #define MPI_FCPORTPAGE1_HARD_ALPA_NOT_USED              (0xFF)
=20
 #define MPI_FCPORTPAGE1_LCONFIG_SPEED_MASK              (0x0F)
@@ -1108,12 +1165,13 @@
 } fCONFIG_PAGE_FC_PORT_5, MPI_POINTER PTR_CONFIG_PAGE_FC_PORT_5,
   FCPortPage5_t, MPI_POINTER pFCPortPage5_t;
=20
-#define MPI_FCPORTPAGE5_PAGEVERSION                     (0x01)
+#define MPI_FCPORTPAGE5_PAGEVERSION                     (0x02)
=20
 #define MPI_FCPORTPAGE5_FLAGS_ALPA_ACQUIRED             (0x01)
 #define MPI_FCPORTPAGE5_FLAGS_HARD_ALPA                 (0x02)
 #define MPI_FCPORTPAGE5_FLAGS_HARD_WWNN                 (0x04)
 #define MPI_FCPORTPAGE5_FLAGS_HARD_WWPN                 (0x08)
+#define MPI_FCPORTPAGE5_FLAGS_DISABLE                   (0x10)
=20
 typedef struct _CONFIG_PAGE_FC_PORT_6
 {
@@ -1322,7 +1380,7 @@
     U8                      Flags;                      /* 19h */
     U16                     BBCredit;                   /* 1Ah */
     U16                     MaxRxFrameSize;             /* 1Ch */
-    U8                      Reserved1;                  /* 1Eh */
+    U8                      ADISCHardALPA;              /* 1Eh */
     U8                      PortNumber;                 /* 1Fh */
     U8                      FcPhLowestVersion;          /* 20h */
     U8                      FcPhHighestVersion;         /* 21h */
@@ -1331,13 +1389,16 @@
 } fCONFIG_PAGE_FC_DEVICE_0, MPI_POINTER PTR_CONFIG_PAGE_FC_DEVICE_0,
   FCDevicePage0_t, MPI_POINTER pFCDevicePage0_t;
=20
-#define MPI_FC_DEVICE_PAGE0_PAGEVERSION                 (0x02)
+#define MPI_FC_DEVICE_PAGE0_PAGEVERSION                 (0x03)
=20
 #define MPI_FC_DEVICE_PAGE0_FLAGS_TARGETID_BUS_VALID    (0x01)
+#define MPI_FC_DEVICE_PAGE0_FLAGS_PLOGI_INVALID         (0x02)
+#define MPI_FC_DEVICE_PAGE0_FLAGS_PRLI_INVALID          (0x04)
=20
 #define MPI_FC_DEVICE_PAGE0_PROT_IP                     (0x01)
 #define MPI_FC_DEVICE_PAGE0_PROT_FCP_TARGET             (0x02)
 #define MPI_FC_DEVICE_PAGE0_PROT_FCP_INITIATOR          (0x04)
+#define MPI_FC_DEVICE_PAGE0_PROT_FCP_RETRY              (0x08)
=20
 #define MPI_FC_DEVICE_PAGE0_PGAD_PORT_MASK      =
(MPI_FC_DEVICE_PGAD_PORT_MASK)
 #define MPI_FC_DEVICE_PAGE0_PGAD_FORM_MASK      =
(MPI_FC_DEVICE_PGAD_FORM_MASK)
@@ -1348,6 +1409,7 @@
 #define MPI_FC_DEVICE_PAGE0_PGAD_BUS_SHIFT      =
(MPI_FC_DEVICE_PGAD_BT_BUS_SHIFT)
 #define MPI_FC_DEVICE_PAGE0_PGAD_TID_MASK       =
(MPI_FC_DEVICE_PGAD_BT_TID_MASK)
=20
+#define MPI_FC_DEVICE_PAGE0_HARD_ALPA_UNKNOWN   (0xFF)
=20
 =
/***********************************************************************=
*****
 *   RAID Volume Config Pages
diff -Nuar linux/drivers/message/fusion/lsi/mpi.h =
11/drivers/message/fusion/lsi/mpi.h
--- linux/drivers/message/fusion/lsi/mpi.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/lsi/mpi.h	2003-06-28 13:10:17.000000000 =
+0200
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2002 LSI Logic Corporation.
+ *  Copyright (c) 2000-2003 LSI Logic Corporation.
  *
  *
  *           Name:  MPI.H
  *          Title:  MPI Message independent structures and definitions
  *  Creation Date:  July 27, 2000
  *
- *    MPI.H Version:  01.02.07
+ *    MPI.H Version:  01.02.10
  *
  *  Version History
  *  ---------------
@@ -48,6 +48,10 @@
  *  05-31-02  01.02.05  Bumped MPI_HEADER_VERSION_UNIT.
  *  07-12-02  01.02.06  Added define for MPI_FUNCTION_MAILBOX.
  *  09-16-02  01.02.07  Bumped value for MPI_HEADER_VERSION_UNIT.
+ *  11-15-02  01.02.08  Added define =
MPI_IOCSTATUS_TARGET_INVALID_IO_INDEX and
+ *                      obsoleted define =
MPI_IOCSTATUS_TARGET_INVALID_IOCINDEX.
+ *  04-01-03  01.02.09  New IOCStatus code: =
MPI_IOCSTATUS_FC_EXCHANGE_CANCELED
+ *  06-26-03  01.02.10  Bumped MPI_HEADER_VERSION_UNIT value.
  *  =
------------------------------------------------------------------------=
--
  */
=20
@@ -76,7 +80,7 @@
 /* Note: The major versions of 0xe0 through 0xff are reserved */
=20
 /* versioning for this MPI header set */
-#define MPI_HEADER_VERSION_UNIT             (0x09)
+#define MPI_HEADER_VERSION_UNIT             (0x0C)
 #define MPI_HEADER_VERSION_DEV              (0x00)
 #define MPI_HEADER_VERSION_UNIT_MASK        (0xFF00)
 #define MPI_HEADER_VERSION_UNIT_SHIFT       (8)
@@ -618,7 +622,8 @@
=20
 #define MPI_IOCSTATUS_TARGET_PRIORITY_IO         (0x0060)
 #define MPI_IOCSTATUS_TARGET_INVALID_PORT        (0x0061)
-#define MPI_IOCSTATUS_TARGET_INVALID_IOCINDEX    (0x0062)
+#define MPI_IOCSTATUS_TARGET_INVALID_IOCINDEX    (0x0062)   /* =
obsolete */
+#define MPI_IOCSTATUS_TARGET_INVALID_IO_INDEX    (0x0062)
 #define MPI_IOCSTATUS_TARGET_ABORTED             (0x0063)
 #define MPI_IOCSTATUS_TARGET_NO_CONN_RETRYABLE   (0x0064)
 #define MPI_IOCSTATUS_TARGET_NO_CONNECTION       (0x0065)
@@ -642,6 +647,7 @@
 #define MPI_IOCSTATUS_FC_RX_ID_INVALID          (0x0067)
 #define MPI_IOCSTATUS_FC_DID_INVALID            (0x0068)
 #define MPI_IOCSTATUS_FC_NODE_LOGGED_OUT        (0x0069)
+#define MPI_IOCSTATUS_FC_EXCHANGE_CANCELED      (0x006C)
=20
 =
/***********************************************************************=
*****/
 /*  LAN values                                                         =
     */
diff -Nuar linux/drivers/message/fusion/lsi/mpi_init.h =
11/drivers/message/fusion/lsi/mpi_init.h
--- linux/drivers/message/fusion/lsi/mpi_init.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/lsi/mpi_init.h	2003-06-28 =
13:10:17.000000000 +0200
@@ -6,7 +6,7 @@
  *          Title:  MPI initiator mode messages and structures
  *  Creation Date:  June 8, 2000
  *
- *    MPI_INIT.H Version:  01.02.05
+ *    MPI_INIT.H Version:  01.02.07
  *
  *  Version History
  *  ---------------
@@ -31,6 +31,8 @@
  *  10-04-01  01.02.04  Added defines for SEP request Action field.
  *  05-31-02  01.02.05  Added =
MPI_SCSIIO_MSGFLGS_CMD_DETERMINES_DATA_DIR define
  *                      for SCSI IO requests.
+ *  11-15-02  01.02.06  Added special extended SCSI Status defines for =
FCP.
+ *  06-26-03  01.02.07  Added MPI_SCSI_STATUS_FCPEXT_UNASSIGNED =
define.
  *  =
------------------------------------------------------------------------=
--
  */
=20
@@ -153,6 +155,10 @@
 #define MPI_SCSI_STATUS_TASK_SET_FULL           (0x28)
 #define MPI_SCSI_STATUS_ACA_ACTIVE              (0x30)
=20
+#define MPI_SCSI_STATUS_FCPEXT_DEVICE_LOGGED_OUT    (0x80)
+#define MPI_SCSI_STATUS_FCPEXT_NO_LINK              (0x81)
+#define MPI_SCSI_STATUS_FCPEXT_UNASSIGNED           (0x82)
+
=20
 /* SCSI IO Reply SCSIState values */
=20
diff -Nuar linux/drivers/message/fusion/lsi/mpi_ioc.h =
11/drivers/message/fusion/lsi/mpi_ioc.h
--- linux/drivers/message/fusion/lsi/mpi_ioc.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/lsi/mpi_ioc.h	2003-06-28 =
13:10:17.000000000 +0200
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2002 LSI Logic Corporation.
+ *  Copyright (c) 2000-2003 LSI Logic Corporation.
  *
  *
  *           Name:  MPI_IOC.H
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload =
messages
  *  Creation Date:  August 11, 2000
  *
- *    MPI_IOC.H Version:  01.02.06
+ *    MPI_IOC.H Version:  01.02.08
  *
  *  Version History
  *  ---------------
@@ -55,6 +55,8 @@
  *  05-31-02  01.02.06  Added define for
  *                      MPI_IOCFACTS_EXCEPT_RAID_CONFIG_INVALID.
  *                      Added AliasIndex to EVENT_DATA_LOGOUT =
structure.
+ *  04-01-03  01.02.07  Added defines for MPI_FW_HEADER_SIGNATURE_.
+ *  06-26-03  01.02.08  Added new values to the product family =
defines.
  *  =
------------------------------------------------------------------------=
--
  */
=20
@@ -654,6 +656,10 @@
 #define MPI_FW_HEADER_PID_TYPE_SCSI             (0x0000)
 #define MPI_FW_HEADER_PID_TYPE_FC               (0x1000)
=20
+#define MPI_FW_HEADER_SIGNATURE_0               (0x5AEAA55A)
+#define MPI_FW_HEADER_SIGNATURE_1               (0xA55AEAA5)
+#define MPI_FW_HEADER_SIGNATURE_2               (0x5AA55AEA)
+
 #define MPI_FW_HEADER_PID_PROD_MASK                     (0x0F00)
 #define MPI_FW_HEADER_PID_PROD_INITIATOR_SCSI           (0x0100)
 #define MPI_FW_HEADER_PID_PROD_TARGET_INITIATOR_SCSI    (0x0200)
@@ -673,6 +679,8 @@
 #define MPI_FW_HEADER_PID_FAMILY_1020C0_SCSI    (0x0008)
 #define MPI_FW_HEADER_PID_FAMILY_1035A0_SCSI    (0x0009)
 #define MPI_FW_HEADER_PID_FAMILY_1035B0_SCSI    (0x000A)
+#define MPI_FW_HEADER_PID_FAMILY_1030TA0_SCSI   (0x000B)
+#define MPI_FW_HEADER_PID_FAMILY_1020TA0_SCSI   (0x000C)
 #define MPI_FW_HEADER_PID_FAMILY_909_FC         (0x0000)
 #define MPI_FW_HEADER_PID_FAMILY_919_FC         (0x0001)
 #define MPI_FW_HEADER_PID_FAMILY_919X_FC        (0x0002)
diff -Nuar linux/drivers/message/fusion/lsi/mpi_raid.h =
11/drivers/message/fusion/lsi/mpi_raid.h
--- linux/drivers/message/fusion/lsi/mpi_raid.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/lsi/mpi_raid.h	2003-06-28 =
13:10:17.000000000 +0200
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2001-2002 LSI Logic Corporation.
+ *  Copyright (c) 2001-2003 LSI Logic Corporation.
  *
  *
  *           Name:  MPI_RAID.H
  *          Title:  MPI RAID message and structures
  *  Creation Date:  February 27, 2001
  *
- *    MPI_RAID.H Version:  01.02.07
+ *    MPI_RAID.H Version:  01.02.09
  *
  *  Version History
  *  ---------------
@@ -25,6 +25,9 @@
  *                      MPI_RAID_ACTION_INACTIVATE_VOLUME, and
  *                      MPI_RAID_ACTION_ADATA_INACTIVATE_ALL.
  *  07-12-02  01.02.07  Added structures for Mailbox request and =
reply.
+ *  11-15-02  01.02.08  Added missing MsgContext field to =
MSG_MAILBOX_REQUEST.
+ *  04-01-03  01.02.09  New action data option flag for
+ *                      MPI_RAID_ACTION_DELETE_VOLUME.
  *  =
------------------------------------------------------------------------=
--
  */
=20
@@ -90,6 +93,9 @@
 #define MPI_RAID_ACTION_ADATA_KEEP_PHYS_DISKS       (0x00000000)
 #define MPI_RAID_ACTION_ADATA_DEL_PHYS_DISKS        (0x00000001)
=20
+#define MPI_RAID_ACTION_ADATA_KEEP_LBA0             (0x00000000)
+#define MPI_RAID_ACTION_ADATA_ZERO_LBA0             (0x00000002)
+
 /* ActionDataWord defines for use with MPI_RAID_ACTION_ACTIVATE_VOLUME =
action */
 #define MPI_RAID_ACTION_ADATA_INACTIVATE_ALL        (0x00000001)
=20
@@ -195,6 +201,7 @@
     U16                     Reserved2;
     U8                      Reserved3;
     U8                      MsgFlags;
+    U32                     MsgContext;
     U8                      Command[10];
     U16                     Reserved4;
     SGE_IO_UNION            SGL;
diff -Nuar linux/drivers/message/fusion/lsi/mpi_targ.h =
11/drivers/message/fusion/lsi/mpi_targ.h
--- linux/drivers/message/fusion/lsi/mpi_targ.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/lsi/mpi_targ.h	2003-06-28 =
13:10:17.000000000 +0200
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2002 LSI Logic Corporation.
+ *  Copyright (c) 2000-2003 LSI Logic Corporation.
  *
  *
  *           Name:  MPI_TARG.H
  *          Title:  MPI Target mode messages and structures
  *  Creation Date:  June 22, 2000
  *
- *    MPI_TARG.H Version:  01.02.07
+ *    MPI_TARG.H Version:  01.02.09
  *
  *  Version History
  *  ---------------
@@ -41,6 +41,8 @@
  *                      Added AliasIndex field to =
MPI_TARGET_FCP_CMD_BUFFER.
  *  09-16-02  01.02.07  Added flags for confirmed completion.
  *                      Added PRIORITY_REASON_TARGET_BUSY.
+ *  11-15-02  01.02.08  Added AliasID field to =
MPI_TARGET_SCSI_SPI_CMD_BUFFER.
+ *  04-01-03  01.02.09  Added OptionalOxid field to =
MPI_TARGET_FCP_CMD_BUFFER.
  *  =
------------------------------------------------------------------------=
--
  */
=20
@@ -171,7 +173,7 @@
     U32     FcpDl;                                      /* 1Ch */
     U8      AliasIndex;                                 /* 20h */
     U8      Reserved1;                                  /* 21h */
-    U16     Reserved2;                                  /* 22h */
+    U16     OptionalOxid;                               /* 22h */
 } MPI_TARGET_FCP_CMD_BUFFER, MPI_POINTER =
PTR_MPI_TARGET_FCP_CMD_BUFFER,
   MpiTargetFcpCmdBuffer, MPI_POINTER pMpiTargetFcpCmdBuffer;
=20
@@ -190,6 +192,10 @@
     U8      TaskManagementFlags;                        /* 12h */
     U8      AdditionalCDBLength;                        /* 13h */
     U8      CDB[16];                                    /* 14h */
+    /* Alias ID */
+    U8      AliasID;                                    /* 24h */
+    U8      Reserved1;                                  /* 25h */
+    U16     Reserved2;                                  /* 26h */
 } MPI_TARGET_SCSI_SPI_CMD_BUFFER,
   MPI_POINTER PTR_MPI_TARGET_SCSI_SPI_CMD_BUFFER,
   MpiTargetScsiSpiCmdBuffer, MPI_POINTER pMpiTargetScsiSpiCmdBuffer;
diff -Nuar linux/drivers/message/fusion/lsi/mpi_tool.h =
11/drivers/message/fusion/lsi/mpi_tool.h
--- linux/drivers/message/fusion/lsi/mpi_tool.h	1970-01-01 =
01:00:00.000000000 +0100
+++ 11/drivers/message/fusion/lsi/mpi_tool.h	2002-08-03 =
02:39:44.000000000 +0200
@@ -0,0 +1,129 @@
+/*
+ *  Copyright (c) 2001 LSI Logic Corporation.
+ *
+ *
+ *           Name:  MPI_TOOL.H
+ *          Title:  MPI Toolbox structures and definitions
+ *  Creation Date:  July 30, 2001
+ *
+ *    MPI Version:  01.02.02
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  =
------------------------------------------------------
+ *  08-08-01  01.02.01  Original release.
+ *  08-29-01  01.02.02  Added DIAG_DATA_UPLOAD_HEADER and related =
defines.
+ *  =
------------------------------------------------------------------------=
--
+ */
+
+#ifndef MPI_TOOL_H
+#define MPI_TOOL_H
+
+#define MPI_TOOLBOX_CLEAN_TOOL                      (0x00)
+#define MPI_TOOLBOX_MEMORY_MOVE_TOOL                (0x01)
+#define MPI_TOOLBOX_DIAG_DATA_UPLOAD_TOOL           (0x02)
+
+
+/**********************************************************************=
******/
+/* Toolbox reply                                                       =
     */
+/**********************************************************************=
******/
+
+typedef struct _MSG_TOOLBOX_REPLY
+{
+    U8                      Tool;                       /* 00h */
+    U8                      Reserved;                   /* 01h */
+    U8                      MsgLength;                  /* 02h */
+    U8                      Function;                   /* 03h */
+    U16                     Reserved1;                  /* 04h */
+    U8                      Reserved2;                  /* 06h */
+    U8                      MsgFlags;                   /* 07h */
+    U32                     MsgContext;                 /* 08h */
+    U16                     Reserved3;                  /* 0Ch */
+    U16                     IOCStatus;                  /* 0Eh */
+    U32                     IOCLogInfo;                 /* 10h */
+} MSG_TOOLBOX_REPLY, MPI_POINTER PTR_MSG_TOOLBOX_REPLY,
+  ToolboxReply_t, MPI_POINTER pToolboxReply_t;
+
+
+/**********************************************************************=
******/
+/* Toolbox Clean Tool request                                          =
     */
+/**********************************************************************=
******/
+
+typedef struct _MSG_TOOLBOX_CLEAN_REQUEST
+{
+    U8                      Tool;                       /* 00h */
+    U8                      Reserved;                   /* 01h */
+    U8                      ChainOffset;                /* 02h */
+    U8                      Function;                   /* 03h */
+    U16                     Reserved1;                  /* 04h */
+    U8                      Reserved2;                  /* 06h */
+    U8                      MsgFlags;                   /* 07h */
+    U32                     MsgContext;                 /* 08h */
+    U32                     Flags;                      /* 0Ch */
+} MSG_TOOLBOX_CLEAN_REQUEST, MPI_POINTER =
PTR_MSG_TOOLBOX_CLEAN_REQUEST,
+  ToolboxCleanRequest_t, MPI_POINTER pToolboxCleanRequest_t;
+
+#define MPI_TOOLBOX_CLEAN_NVSRAM                    (0x00000001)
+#define MPI_TOOLBOX_CLEAN_SEEPROM                   (0x00000002)
+#define MPI_TOOLBOX_CLEAN_FLASH                     (0x00000004)
+
+
+/**********************************************************************=
******/
+/* Toolbox Memory Move request                                         =
     */
+/**********************************************************************=
******/
+
+typedef struct _MSG_TOOLBOX_MEM_MOVE_REQUEST
+{
+    U8                      Tool;                       /* 00h */
+    U8                      Reserved;                   /* 01h */
+    U8                      ChainOffset;                /* 02h */
+    U8                      Function;                   /* 03h */
+    U16                     Reserved1;                  /* 04h */
+    U8                      Reserved2;                  /* 06h */
+    U8                      MsgFlags;                   /* 07h */
+    U32                     MsgContext;                 /* 08h */
+    SGE_SIMPLE_UNION        SGL;                        /* 0Ch */
+} MSG_TOOLBOX_MEM_MOVE_REQUEST, MPI_POINTER =
PTR_MSG_TOOLBOX_MEM_MOVE_REQUEST,
+  ToolboxMemMoveRequest_t, MPI_POINTER pToolboxMemMoveRequest_t;
+
+
+/**********************************************************************=
******/
+/* Toolbox Diagnostic Data Upload request                              =
     */
+/**********************************************************************=
******/
+
+typedef struct _MSG_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST
+{
+    U8                      Tool;                       /* 00h */
+    U8                      Reserved;                   /* 01h */
+    U8                      ChainOffset;                /* 02h */
+    U8                      Function;                   /* 03h */
+    U16                     Reserved1;                  /* 04h */
+    U8                      Reserved2;                  /* 06h */
+    U8                      MsgFlags;                   /* 07h */
+    U32                     MsgContext;                 /* 08h */
+    U32                     Flags;                      /* 0Ch */
+    U32                     Reserved3;                  /* 10h */
+    SGE_SIMPLE_UNION        SGL;                        /* 14h */
+} MSG_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST, MPI_POINTER =
PTR_MSG_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST,
+  ToolboxDiagDataUploadRequest_t, MPI_POINTER =
pToolboxDiagDataUploadRequest_t;
+
+typedef struct _DIAG_DATA_UPLOAD_HEADER
+{
+    U32                     DiagDataLength;             /* 00h */
+    U8                      FormatCode;                 /* 04h */
+    U8                      Reserved;                   /* 05h */
+    U16                     Reserved1;                  /* 06h */
+} DIAG_DATA_UPLOAD_HEADER, MPI_POINTER PTR_DIAG_DATA_UPLOAD_HEADER,
+  DiagDataUploadHeader_t, MPI_POINTER pDiagDataUploadHeader_t;
+
+#define MPI_TB_DIAG_FORMAT_SCSI_PRINTF_1            (0x01)
+#define MPI_TB_DIAG_FORMAT_SCSI_2                   (0x02)
+#define MPI_TB_DIAG_FORMAT_SCSI_3                   (0x03)
+#define MPI_TB_DIAG_FORMAT_FC_TRACE_1               (0x04)
+
+
+#endif
+
+
diff -Nuar linux/drivers/message/fusion/mptbase.c =
11/drivers/message/fusion/mptbase.c
--- linux/drivers/message/fusion/mptbase.c	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/mptbase.c	2003-12-04 18:15:04.000000000 =
+0100
@@ -47,7 +47,7 @@
  *  Copyright (c) 1999-2002 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptbase.c,v 1.130 2003/05/07 14:08:30 pdelaney Exp $
  */
@@ -211,6 +211,7 @@
 static int	mpt_readScsiDevicePageHeaders(MPT_ADAPTER *ioc, int =
portnum);
 static int	mpt_findImVolumes(MPT_ADAPTER *ioc);
 static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
+static void 	mpt_read_ioc_pg_4(MPT_ADAPTER *ioc);
 static void	mpt_timer_expired(unsigned long data);
 static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t =
*evnp);
@@ -319,14 +320,14 @@
 	MPT_FRAME_HDR	*mf;
 	MPT_FRAME_HDR	*mr;
 	u32		 pa;
-	int		 req_idx =3D -1;
+	int		 req_idx;
 	int		 cb_idx;
 	int		 type;
 	int		 freeme;
-	int		 count =3D 0;
=20
 	ioc =3D bus_id;
=20
+#ifdef MPT_DEBUG_IRQ
 	/*
 	 * Verify ioc pointer is ok
 	 */
@@ -341,6 +342,7 @@
 			return;
 		}
 	}
+#endif
=20
 	/*
 	 *  Drain the reply FIFO!
@@ -493,17 +495,7 @@
 			spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 		}
=20
-		count++;
-		dirqprintk((MYIOC_s_INFO_FMT "ISR processed frame #%d\n", ioc->name, =
count));
 		mb();
-
-		if (count >=3D MPT_MAX_REPLIES_PER_ISR) {
-			dirqprintk((MYIOC_s_INFO_FMT "ISR processed %d replies.",
-					ioc->name, count));
-			dirqprintk((" Giving this ISR a break!\n"));
-			return;
-		}
-
 	}	/* drain reply FIFO */
 }
=20
@@ -814,7 +806,7 @@
 MPT_FRAME_HDR*
 mpt_get_msg_frame(int handle, int iocid)
 {
-	MPT_FRAME_HDR *mf =3D NULL;
+	MPT_FRAME_HDR *mf;
 	MPT_ADAPTER *iocp;
 	unsigned long flags;
=20
@@ -846,6 +838,8 @@
 		iocp->mfcnt++;
 #endif
 	}
+	else
+		mf =3D NULL;
 	spin_unlock_irqrestore(&iocp->FreeQlock, flags);
=20
 #ifdef MFCNT
@@ -1114,10 +1108,12 @@
 MPT_ADAPTER *
 mpt_adapter_find_first(void)
 {
-	MPT_ADAPTER *this =3D NULL;
+	MPT_ADAPTER *this;
=20
 	if (! Q_IS_EMPTY(&MptAdapters))
 		this =3D MptAdapters.head;
+	else
+		this =3D NULL;
=20
 	return this;
 }
@@ -1132,10 +1128,12 @@
 MPT_ADAPTER *
 mpt_adapter_find_next(MPT_ADAPTER *prev)
 {
-	MPT_ADAPTER *next =3D NULL;
+	MPT_ADAPTER *next;
=20
 	if (prev && (prev->forw !=3D (MPT_ADAPTER*)&MptAdapters.head))
 		next =3D prev->forw;
+	else
+		next =3D NULL;
=20
 	return next;
 }
@@ -1285,7 +1283,11 @@
 	if (pci_enable_device(pdev))
 		return r;
=20
-	if (!pci_set_dma_mask(pdev, mask)) {
+	/* For some kernels, broken kernel limits memory allocation for =
target mode
+	 * driver. Shirron. Fixed in 2.4.20-8
+	 * if ((sizeof(dma_addr_t) =3D=3D sizeof(u64)) && =
(!pci_set_dma_mask(pdev, mask))) {
+	 */
+	if ((!pci_set_dma_mask(pdev, mask))) {
 		dprintk((KERN_INFO MYNAM ": 64 BIT PCI BUS DMA ADDRESSING =
SUPPORTED\n"));
 	} else {
 		if (pci_set_dma_mask(pdev, (u64) 0xffffffff)) {
@@ -1300,10 +1302,10 @@
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add =
adapter!\n");
 		return -ENOMEM;
 	}
-	memset(ioc, 0, sizeof(*ioc));
+	memset(ioc, 0, sizeof(MPT_ADAPTER));
 	ioc->alloc_total =3D sizeof(MPT_ADAPTER);
 	ioc->req_sz =3D MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
-	ioc->reply_sz =3D ioc->req_sz;
+	ioc->reply_sz =3D MPT_REPLY_FRAME_SIZE;
=20
 	ioc->pcidev =3D pdev;
 	ioc->diagPending =3D 0;
@@ -1419,13 +1421,12 @@
 		ioc->prod_name =3D "LSIFC929X";
 		{
 			/* 929X Chip Fix. Set Split transactions level
-			 * for PCIX. Set bits 5 - 6 to zero, turn on bit 4.
+			 * for PCIX. Set MOST bits to zero.
 			 */
-			u16 pcixcmd =3D 0;
-			pci_read_config_word(pdev, 0x6a, &pcixcmd);
-			pcixcmd &=3D 0xFF9F;
-			pcixcmd |=3D 0x0010;
-			pci_write_config_word(pdev, 0x6a, pcixcmd);
+			u8 pcixcmd;
+			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
+			pcixcmd &=3D 0x8F;
+			pci_write_config_byte(pdev, 0x6a, pcixcmd);
 		}
 	}
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC919X) {
@@ -1433,13 +1434,12 @@
 		ioc->prod_name =3D "LSIFC919X";
 		{
 			/* 919X Chip Fix. Set Split transactions level
-			 * for PCIX. Set bits 5 - 6 to zero, turn on bit 4.
+			 * for PCIX. Set MOST bits to zero.
 			 */
-			u16 pcixcmd =3D 0;
-			pci_read_config_word(pdev, 0x6a, &pcixcmd);
-			pcixcmd &=3D 0xFF9F;
-			pcixcmd |=3D 0x0010;
-			pci_write_config_word(pdev, 0x6a, pcixcmd);
+			u8 pcixcmd;
+			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
+			pcixcmd &=3D 0x8F;
+			pci_write_config_byte(pdev, 0x6a, pcixcmd);
 		}
 	}
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVID_53C1030) {
@@ -1449,14 +1449,14 @@
 			u8 revision;
=20
 			/* 1030 Chip Fix. Disable Split transactions
-			 * for PCIX. Set bits 4 - 6 to zero if Rev < C0( =3D 8)
+			 * for PCIX. Set MOST bits to zero if Rev < C0( =3D 8).
 			 */
 			pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 			if (revision < 0x08) {
-				u16 pcixcmd =3D 0;
-				pci_read_config_word(pdev, 0x6a, &pcixcmd);
-				pcixcmd &=3D 0xFF8F;
-				pci_write_config_word(pdev, 0x6a, pcixcmd);
+				u8 pcixcmd;
+				pci_read_config_byte(pdev, 0x6a, &pcixcmd);
+				pcixcmd &=3D 0x8F;
+				pci_write_config_byte(pdev, 0x6a, pcixcmd);
 			}
 		}
 	}
@@ -1764,6 +1764,8 @@
 			/* Check, and possibly reset, the coalescing value
 			 */
 			mpt_read_ioc_pg_1(ioc);
+
+			mpt_read_ioc_pg_4(ioc);
 		}
=20
 		GetIoUnitPage2(ioc);
@@ -1950,6 +1952,15 @@
 			kfree(this->spi_data.pIocPg3);
 			this->spi_data.pIocPg3 =3D NULL;
 		}
+
+		if (freeup && this->spi_data.pIocPg4 !=3D NULL) {
+			sz =3D this->spi_data.IocPg4Sz;
+			pci_free_consistent(this->pcidev, sz,=20
+				this->spi_data.pIocPg4,
+				this->spi_data.IocPg4_dma);
+			this->spi_data.pIocPg4 =3D NULL;
+			this->alloc_total -=3D sz;
+		}
 	}
 }
=20
@@ -2346,7 +2357,7 @@
 			 */
 			ioc->req_sz =3D MIN(MPT_DEFAULT_FRAME_SIZE, facts->RequestFrameSize =
* 4);
 			ioc->req_depth =3D MIN(MPT_MAX_REQ_DEPTH, facts->GlobalCredits);
-			ioc->reply_sz =3D ioc->req_sz;
+			ioc->reply_sz =3D MPT_REPLY_FRAME_SIZE;
 			ioc->reply_depth =3D MIN(MPT_DEFAULT_REPLY_DEPTH, =
facts->ReplyQueueDepth);
=20
 			dprintk((MYIOC_s_INFO_FMT "reply_sz=3D%3d, reply_depth=3D%4d\n",
@@ -2609,8 +2620,8 @@
 void *
 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size, int *frags, int =
*alloc_sz)
 {
-	fw_image_t	**cached_fw =3D NULL;
-	u8		*mem =3D NULL;
+	fw_image_t	**cached_fw;
+	u8		*mem;
 	dma_addr_t	fw_dma;
 	int		alloc_total =3D 0;
 	int		bytes_left, bytes, num_frags;
@@ -2758,7 +2769,7 @@
 	u8			 reply[sizeof(FWUploadReply_t)];
 	FWUpload_t		*prequest;
 	FWUploadReply_t		*preply;
-	FWUploadTCSGE_t		*ptcsge =3D NULL;
+	FWUploadTCSGE_t		*ptcsge;
 	int			 sgeoffset;
 	int			 ii, sz, reply_sz;
 	int			 cmdStatus, freeMem =3D 0;
@@ -2890,16 +2901,16 @@
 static int
 mpt_downloadboot(MPT_ADAPTER *ioc, int sleepFlag)
 {
-	MpiFwHeader_t		*FwHdr =3D NULL;
+	MpiFwHeader_t		*FwHdr;
 	MpiExtImageHeader_t 	*ExtHdr;
-	fw_image_t		**pCached =3D NULL;
+	fw_image_t		**pCached;
 	int			 fw_sz;
 	u32			 diag0val;
 #ifdef MPT_DEBUG
 	u32			 diag1val =3D 0;
 #endif
 	int			 count =3D 0;
-	u32			*ptru32 =3D NULL;
+	u32			*ptru32;
 	u32			 diagRwData;
 	u32			 nextImage;
 	u32			 ext_offset;
@@ -4301,7 +4312,7 @@
 static int
 mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 {
-	u8			*pbuf =3D NULL;
+	u8			*pbuf;
 	dma_addr_t		 buf_dma;
 	CONFIGPARMS		 cfg;
 	ConfigPageHeader_t	 header;
@@ -4387,7 +4398,6 @@
 			}
 			if (pbuf) {
 				pci_free_consistent(ioc->pcidev, header.PageLength * 4, pbuf, =
buf_dma);
-				pbuf =3D NULL;
 			}
 		}
 	}
@@ -4424,6 +4434,8 @@
 				/* Save the Port Page 2 data
 				 * (reformat into a 32bit quantity)
 				 */
+				data =3D le32_to_cpu(pPP2->PortFlags) & =
MPI_SCSIPORTPAGE2_PORT_FLAGS_DV_MASK;
+				ioc->spi_data.PortFlags =3D data;
 				for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
 					pdevice =3D &pPP2->DeviceSettings[ii];
 					data =3D (le16_to_cpu(pdevice->DeviceFlags) << 16) |
@@ -4433,7 +4445,6 @@
 			}
=20
 			pci_free_consistent(ioc->pcidev, header.PageLength * 4, pbuf, =
buf_dma);
-			pbuf =3D NULL;
 		}
 	}
=20
@@ -4509,8 +4520,8 @@
 static int
 mpt_findImVolumes(MPT_ADAPTER *ioc)
 {
-	IOCPage2_t		*pIoc2 =3D NULL;
-	ConfigPageIoc2RaidVol_t	*pIocRv =3D NULL;
+	IOCPage2_t		*pIoc2;
+	ConfigPageIoc2RaidVol_t	*pIocRv;
 	dma_addr_t		 ioc2_dma;
 	CONFIGPARMS		 cfg;
 	ConfigPageHeader_t	 header;
@@ -4587,10 +4598,7 @@
 	}
=20
 done_and_free:
-	if (pIoc2) {
-		pci_free_consistent(ioc->pcidev, iocpage2sz, pIoc2, ioc2_dma);
-		pIoc2 =3D NULL;
-	}
+	pci_free_consistent(ioc->pcidev, iocpage2sz, pIoc2, ioc2_dma);
=20
 	return rc;
 }
@@ -4598,7 +4606,7 @@
 int
 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc)
 {
-	IOCPage3_t		*pIoc3 =3D NULL;
+	IOCPage3_t		*pIoc3;
 	u8			*mem;
 	CONFIGPARMS		 cfg;
 	ConfigPageHeader_t	 header;
@@ -4651,18 +4659,66 @@
 		}
 	}
=20
-	if (pIoc3) {
-		pci_free_consistent(ioc->pcidev, iocpage3sz, pIoc3, ioc3_dma);
-		pIoc3 =3D NULL;
-	}
+	pci_free_consistent(ioc->pcidev, iocpage3sz, pIoc3, ioc3_dma);
=20
 	return 0;
 }
=20
 static void
+mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
+{
+	IOCPage4_t		*pIoc4;
+	CONFIGPARMS		 cfg;
+	ConfigPageHeader_t	 header;
+	dma_addr_t		 ioc4_dma;
+	int			 iocpage4sz;
+
+	/* Read and save IOC Page 4
+	 */
+	header.PageVersion =3D 0;
+	header.PageLength =3D 0;
+	header.PageNumber =3D 4;
+	header.PageType =3D MPI_CONFIG_PAGETYPE_IOC;
+	cfg.hdr =3D &header;
+	cfg.physAddr =3D -1;
+	cfg.pageAddr =3D 0;
+	cfg.action =3D MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir =3D 0;
+	cfg.timeout =3D 0;
+	if (mpt_config(ioc, &cfg) !=3D 0)
+		return;
+
+	if (header.PageLength =3D=3D 0)
+		return;
+
+	if ( (pIoc4 =3D ioc->spi_data.pIocPg4) =3D=3D NULL ) {
+		iocpage4sz =3D (header.PageLength + 4) * 4; /* Allow 4 additional =
SEP's */
+		pIoc4 =3D pci_alloc_consistent(ioc->pcidev, iocpage4sz, &ioc4_dma);
+		if (!pIoc4)
+			return;
+	} else {
+		ioc4_dma =3D ioc->spi_data.IocPg4_dma;
+		iocpage4sz =3D ioc->spi_data.IocPg4Sz;
+	}
+
+	/* Read the Page into dma memory.
+	 */
+	cfg.physAddr =3D ioc4_dma;
+	cfg.action =3D MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	if (mpt_config(ioc, &cfg) =3D=3D 0) {
+		ioc->spi_data.pIocPg4 =3D (IOCPage4_t *) pIoc4;
+		ioc->spi_data.IocPg4_dma =3D ioc4_dma;
+		ioc->spi_data.IocPg4Sz =3D iocpage4sz;
+	} else {
+		pci_free_consistent(ioc->pcidev, iocpage4sz, pIoc4, ioc4_dma);
+		ioc->spi_data.pIocPg4 =3D NULL;
+	}
+}
+
+static void
 mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 {
-	IOCPage1_t		*pIoc1 =3D NULL;
+	IOCPage1_t		*pIoc1;
 	CONFIGPARMS		 cfg;
 	ConfigPageHeader_t	 header;
 	dma_addr_t		 ioc1_dma;
@@ -4738,10 +4794,7 @@
 		}
 	}
=20
-	if (pIoc1) {
-		pci_free_consistent(ioc->pcidev, iocpage1sz, pIoc1, ioc1_dma);
-		pIoc1 =3D NULL;
-	}
+	pci_free_consistent(ioc->pcidev, iocpage1sz, pIoc1, ioc1_dma);
=20
 	return;
 }
@@ -5428,7 +5481,7 @@
 	int		 rc;
 	unsigned long	 flags;
=20
-	dprintk((MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", ioc->name));
+	dtmprintk((MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", =
ioc->name));
 #ifdef MFCNT
 	printk(MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", ioc->name);
 	printk("MF count 0x%x !\n", ioc->mfcnt);
@@ -5460,11 +5513,11 @@
=20
 		for (ii=3DMPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
 			if (MptResetHandlers[ii]) {
-				dprintk((MYIOC_s_INFO_FMT "Calling IOC reset_setup handler #%d\n",
+				dtmprintk((MYIOC_s_INFO_FMT "Calling IOC reset_setup handler =
#%d\n",
 						ioc->name, ii));
 				r +=3D (*(MptResetHandlers[ii]))(ioc, MPT_IOC_SETUP_RESET);
 				if (ioc->alt_ioc) {
-					dprintk((MYIOC_s_INFO_FMT "Calling alt-%s setup reset handler =
#%d\n",
+					dtmprintk((MYIOC_s_INFO_FMT "Calling alt-%s setup reset handler =
#%d\n",
 							ioc->name, ioc->alt_ioc->name, ii));
 					r +=3D (*(MptResetHandlers[ii]))(ioc->alt_ioc, =
MPT_IOC_SETUP_RESET);
 				}
@@ -5486,7 +5539,7 @@
 		ioc->alt_ioc->diagPending =3D 0;
 	spin_unlock_irqrestore(&ioc->diagLock, flags);
=20
-	dprintk((MYIOC_s_INFO_FMT "HardResetHandler rc =3D %d!\n", ioc->name, =
rc));
+	dtmprintk((MYIOC_s_INFO_FMT "HardResetHandler rc =3D %d!\n", =
ioc->name, rc));
=20
 	return rc;
 }
@@ -5495,7 +5548,7 @@
 static char *
 EventDescriptionStr(u8 event, u32 evData0)
 {
-	char *ds =3D NULL;
+	char *ds;
=20
 	switch(event) {
 	case MPI_EVENT_NONE:
@@ -6001,7 +6054,7 @@
 fusion_exit(void)
 {
 	MPT_ADAPTER *this;
-	struct pci_dev *pdev =3D NULL;
+	struct pci_dev *pdev;
=20
 	dprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));
=20
@@ -6021,7 +6074,7 @@
 		this->active =3D 0;
=20
 		pdev =3D (struct pci_dev *)this->pcidev;
-		mptscsih_sync_irq(pdev->irq);
+		mpt_sync_irq(pdev->irq);
=20
 		/* Clear any lingering interrupt */
 		CHIPREG_WRITE32(&this->chip->IntStatus, 0);
diff -Nuar linux/drivers/message/fusion/mptbase.h =
11/drivers/message/fusion/mptbase.h
--- linux/drivers/message/fusion/mptbase.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/mptbase.h	2003-12-04 16:03:06.000000000 =
+0100
@@ -11,7 +11,7 @@
  *  Copyright (c) 1999-2002 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptbase.h,v 1.149 2003/05/07 14:08:31 pdelaney Exp $
  */
@@ -77,11 +77,11 @@
 #endif
=20
 #ifndef COPYRIGHT
-#define COPYRIGHT	"Copyright (c) 1999-2002 " MODULEAUTHOR
+#define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR
 #endif
=20
-#define MPT_LINUX_VERSION_COMMON	"2.05.05+"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.05+"
+#define MPT_LINUX_VERSION_COMMON	"2.05.11"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.11"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
=20
 #define show_mptmod_ver(s,ver)  \
@@ -96,7 +96,7 @@
 #define MPT_MAX_BUS			1	/* Do not change */
 #define MPT_MAX_FC_DEVICES		255
 #define MPT_MAX_SCSI_DEVICES		16
-#define MPT_LAST_LUN			31
+#define MPT_LAST_LUN			255
 #define MPT_SENSE_BUFFER_ALLOC		64
 	/* allow for 256 max sense alloc, but only 255 max request */
 #if MPT_SENSE_BUFFER_ALLOC >=3D 256
@@ -127,6 +127,8 @@
 #define  MPT_MAX_FRAME_SIZE		128
 #define  MPT_DEFAULT_FRAME_SIZE		128
=20
+#define  MPT_REPLY_FRAME_SIZE		0x40  /* Must be a multiple of 8 */
+
 #define  MPT_SG_REQ_128_SCALE		1
 #define  MPT_SG_REQ_96_SCALE		2
 #define  MPT_SG_REQ_64_SCALE		4
@@ -245,6 +247,7 @@
 		MPIHeader_t		hdr;
 		SCSIIORequest_t		scsireq;
 		SCSIIOReply_t		sreply;
+		ConfigReply_t		configreply;
 		MPIDefaultReply_t	reply;
 		MPT_FRAME_TRACKER	frame;
 	} u;
@@ -398,12 +401,9 @@
 	ScsiCmndTracker		 SentQ;
 	ScsiCmndTracker		 DoneQ;
 	u32			 num_luns;
-//--- LUN split here?
-	u32			 luns;		/* Max LUNs is 32 */
-	u8			 inq_data[SCSI_STD_INQUIRY_BYTES];	/* 36 */
-	u8			 pad0[4];
-	u8			 inq00_data[20];
-	u8			 pad1[4];
+	u32			 luns[8];		/* Max LUNs is 256 */
+	u8			 pad[4];
+	u8			 inq_data[8];
 		/* IEEE Registered Extended Identifier
 		   obtained via INQUIRY VPD page 0x83 */
 		/* NOTE: Do not separate uniq_prepad and uniq_data
@@ -411,11 +411,6 @@
 	u8			 uniq_prepad[8];
 	u8			 uniq_data[20];
 	u8			 pad2[4];
-	u8			 inqC3_data[12];
-	u8			 pad3[4];
-	u8			 inqC9_data[12];
-	u8			 pad4[4];
-	u8			 dev_vol_name[64];
 } VirtDevice;
=20
 /*
@@ -430,6 +425,7 @@
 #define MPT_TARGET_FLAGS_VALID_INQUIRY	0x02
 #define MPT_TARGET_FLAGS_Q_YES		0x08
 #define MPT_TARGET_FLAGS_VALID_56	0x10
+#define MPT_TARGET_FLAGS_SAF_TE_ISSUED	0x20
 #endif
=20
 #define MPT_TARGET_NO_NEGO_WIDE		0x01
@@ -529,8 +525,12 @@
 /* #define MPT_SCSICFG_BLK_NEGO		0x10	   WriteSDP1 with WDTR and SDTR =
disabled */
=20
 typedef	struct _ScsiCfgData {
+	u32		 PortFlags;
 	int		*nvram;			/* table of device NVRAM values */
 	IOCPage3_t	*pIocPg3;		/* table of physical disks */
+	IOCPage4_t	*pIocPg4;		/* SEP devices addressing */
+	dma_addr_t	 IocPg4_dma;		/* Phys Addr of IOCPage4 data */
+	int		 IocPg4Sz;		/* IOCPage4 size */
 	u8		 dvStatus[MPT_MAX_SCSI_DEVICES];
 	int		 isRaid;		/* bit field, 1 if RAID */
 	u8		 minSyncFactor;		/* 0xFF if async */
@@ -544,7 +544,8 @@
 	u8		 dvScheduled;		/* 1 if scheduled */
 	u8		 forceDv;		/* 1 to force DV scheduling */
 	u8		 noQas;			/* Disable QAS for this adapter */
-	u8		 rsvd[2];
+	u8		 Saf_Te;		/* 1 to force all Processors as SAF-TE if Inquiry data =
length is too short to check for SAF-TE */
+	u8		 rsvd[1];
 } ScsiCfgData;
=20
 typedef struct _fw_image {
diff -Nuar linux/drivers/message/fusion/mptctl.c =
11/drivers/message/fusion/mptctl.c
--- linux/drivers/message/fusion/mptctl.c	2004-01-09 16:35:24.000000000 =
+0100
+++ 11/drivers/message/fusion/mptctl.c	2003-11-07 17:08:30.000000000 =
+0100
@@ -32,7 +32,7 @@
  *  Copyright (c) 1999-2002 LSI Logic Corporation
  *  Originally By: Steven J. Ralston, Noah Romer
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptctl.c,v 1.66 2003/05/07 14:08:32 pdelaney Exp $
  */
@@ -208,14 +208,6 @@
 		return -EBUSY;
 	}
=20
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
-	if (!nonblock) {
-		if (down_interruptible(&mptctl_syscall_sem_ioc[ioc->id]))
-			rc =3D -ERESTARTSYS;
-	} else {
-		rc =3D -EPERM;
-	}
-#else
 	if (nonblock) {
 		if (down_trylock(&mptctl_syscall_sem_ioc[ioc->id]))
 			rc =3D -EAGAIN;
@@ -223,7 +215,6 @@
 		if (down_interruptible(&mptctl_syscall_sem_ioc[ioc->id]))
 			rc =3D -ERESTARTSYS;
 	}
-#endif
 	dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down return %d\n", =
rc));
 	return rc;
 }
@@ -1275,10 +1266,10 @@
 	/* Fill in the data and return the structure to the calling
 	 * program
 	 */
-	if (ioc->chip_type =3D=3D C1030)
-		karg.adapterType =3D MPT_IOCTL_INTERFACE_SCSI;
-	else
+	if ((int)ioc->chip_type <=3D (int) FC929)
 		karg.adapterType =3D MPT_IOCTL_INTERFACE_FC;
+	else
+		karg.adapterType =3D MPT_IOCTL_INTERFACE_SCSI;
=20
 	port =3D karg.hdr.port;
=20
@@ -1329,6 +1320,7 @@
 	/* Set the Version Strings.
 	 */
 	strncpy (karg.driverVersion, MPT_LINUX_PACKAGE_NAME, =
MPT_IOCTL_VERSION_LENGTH);
+	karg.driverVersion[MPT_IOCTL_VERSION_LENGTH-1]=3D'\0';
=20
 	karg.busChangeEvent =3D 0;
 	karg.hostId =3D ioc->pfacts[port].PortSCSIID;
@@ -1369,7 +1361,8 @@
 	int			iocnum;
 	int			numDevices =3D 0;
 	unsigned int		max_id;
-	int			ii, jj, lun;
+	int			ii, jj, indexed_lun, lun_index;
+	u32			lun;
 	int			maxWordsLeft;
 	int			numBytes;
 	u8			port;
@@ -1443,8 +1436,10 @@
 			while (ii <=3D max_id) {
 				if (hd->Targets[ii]) {
 					for (jj =3D 0; jj <=3D MPT_LAST_LUN; jj++) {
-						lun =3D (1 << jj);
-						if (hd->Targets[ii]->luns & lun) {
+						lun_index =3D (jj >> 5);
+						indexed_lun =3D (jj % 32);
+						lun =3D (1 << indexed_lun);
+						if (hd->Targets[ii]->luns[lun_index] & lun) {
 							numDevices++;
 							*pdata =3D (jj << 16) | ii;
 							--maxWordsLeft;
@@ -1529,7 +1524,9 @@
 	karg.chip_type =3D ioc->chip_type;
 #endif
 	strncpy (karg.name, ioc->name, MPT_MAX_NAME);
+	karg.name[MPT_MAX_NAME-1]=3D'\0';
 	strncpy (karg.product, ioc->prod_name, MPT_PRODUCT_LENGTH);
+	karg.product[MPT_PRODUCT_LENGTH-1]=3D'\0';
=20
 	/* Copy the data from kernel memory to user memory
 	 */
@@ -1950,6 +1947,8 @@
 			 */
 			if (karg.maxSenseBytes > MPT_SENSE_BUFFER_SIZE)
 				pScsiReq->SenseBufferLength =3D MPT_SENSE_BUFFER_SIZE;
+			else
+				pScsiReq->SenseBufferLength =3D karg.maxSenseBytes;
=20
 			pScsiReq->SenseBufferLowAddr =3D
 				cpu_to_le32(ioc->sense_buf_low_dma
@@ -2011,6 +2010,8 @@
 			 */
 			if (karg.maxSenseBytes > MPT_SENSE_BUFFER_SIZE)
 				pScsiReq->SenseBufferLength =3D MPT_SENSE_BUFFER_SIZE;
+			else
+				pScsiReq->SenseBufferLength =3D karg.maxSenseBytes;
=20
 			pScsiReq->SenseBufferLowAddr =3D
 				cpu_to_le32(ioc->sense_buf_low_dma
@@ -2471,8 +2472,10 @@
 				cfg.physAddr =3D buf_dma;
 				if (mpt_config(ioc, &cfg) =3D=3D 0) {
 					ManufacturingPage0_t *pdata =3D (ManufacturingPage0_t *) pbuf;
-					if (strlen(pdata->BoardTracerNumber) > 1)
+					if (strlen(pdata->BoardTracerNumber) > 1) {
 						strncpy(karg.serial_number, pdata->BoardTracerNumber, 24);
+						karg.serial_number[24-1]=3D'\0';
+					}
 				}
 				pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, =
buf_dma);
 				pbuf =3D NULL;
@@ -2705,10 +2708,7 @@
=20
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
=20
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
-
-/* The dynamic ioctl32 compat. registry only exists in >2.3.x sparc64 =
kernels */
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,3,0)		/*{*/
+#ifdef CONFIG_COMPAT
 extern int register_ioctl32_conversion(unsigned int cmd,
 				       int (*handler)(unsigned int,
 						      unsigned int,
@@ -2718,14 +2718,14 @@
 extern asmlinkage int sys_ioctl(unsigned int fd, unsigned int cmd, =
unsigned long arg);
=20
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
-/* sparc32_XXX functions are used to provide a conversion between
+/* compat_XXX functions are used to provide a conversion between
  * pointers and u32's. If the arg does not contain any pointers, then
- * a specialized function (sparc32_XXX) is not needed. If the arg
+ * a specialized function (compat_XXX) is not needed. If the arg
  * does contain pointer(s), then the specialized function is used
  * to ensure the structure contents is properly processed by mptctl.
  */
 static int
-sparc32_mptfwxfer_ioctl(unsigned int fd, unsigned int cmd,
+compat_mptfwxfer_ioctl(unsigned int fd, unsigned int cmd,
 			unsigned long arg, struct file *filp)
 {
 	struct mpt_fw_xfer32 kfw32;
@@ -2735,7 +2735,7 @@
 	int nonblock =3D (filp->f_flags & O_NONBLOCK);
 	int ret;
=20
-	dctlprintk((KERN_INFO MYNAM "::sparc32_mptfwxfer_ioctl() called\n"));
+	dctlprintk((KERN_INFO MYNAM "::compat_mptfwxfer_ioctl() called\n"));
=20
 	if (copy_from_user(&kfw32, (char *)arg, sizeof(kfw32)))
 		return -EFAULT;
@@ -2744,7 +2744,7 @@
 	iocnumX =3D kfw32.iocnum & 0xFF;
 	if (((iocnum =3D mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp =3D=3D NULL)) {
-		dctlprintk((KERN_ERR MYNAM "::sparc32_mptfwxfer_ioctl @%d - ioc%d =
not found!\n",
+		dctlprintk((KERN_ERR MYNAM "::compat_mptfwxfer_ioctl @%d - ioc%d not =
found!\n",
 				__LINE__, iocnumX));
 		return -ENODEV;
 	}
@@ -2764,7 +2764,7 @@
 }
=20
 static int
-sparc32_mpt_command(unsigned int fd, unsigned int cmd,
+compat_mpt_command(unsigned int fd, unsigned int cmd,
 			unsigned long arg, struct file *filp)
 {
 	struct mpt_ioctl_command32 karg32;
@@ -2775,7 +2775,7 @@
 	int nonblock =3D (filp->f_flags & O_NONBLOCK);
 	int ret;
=20
-	dctlprintk((KERN_INFO MYNAM "::sparc32_mpt_command() called\n"));
+	dctlprintk((KERN_INFO MYNAM "::compat_mpt_command() called\n"));
=20
 	if (copy_from_user(&karg32, (char *)arg, sizeof(karg32)))
 		return -EFAULT;
@@ -2784,7 +2784,7 @@
 	iocnumX =3D karg32.hdr.iocnum & 0xFF;
 	if (((iocnum =3D mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp =3D=3D NULL)) {
-		dctlprintk((KERN_ERR MYNAM "::sparc32_mpt_command @%d - ioc%d not =
found!\n",
+		dctlprintk((KERN_ERR MYNAM "::compat_mpt_command @%d - ioc%d not =
found!\n",
 				__LINE__, iocnumX));
 		return -ENODEV;
 	}
@@ -2817,8 +2817,7 @@
 	return ret;
 }
=20
-#endif		/*} linux >=3D 2.3.x */
-#endif		/*} sparc */
+#endif
=20
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
 int __init mptctl_init(void)
@@ -2864,35 +2863,33 @@
 		}
 	}
=20
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,3,0)		/*{*/
-	err =3D register_ioctl32_conversion(MPTIOCINFO, NULL);
+#ifdef CONFIG_COMPAT
+	err =3D register_ioctl32_conversion(MPTIOCINFO, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTIOCINFO1, NULL);
+	err =3D register_ioctl32_conversion(MPTIOCINFO1, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTTARGETINFO, NULL);
+	err =3D register_ioctl32_conversion(MPTTARGETINFO, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTTEST, NULL);
+	err =3D register_ioctl32_conversion(MPTTEST, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTEVENTQUERY, NULL);
+	err =3D register_ioctl32_conversion(MPTEVENTQUERY, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTEVENTENABLE, NULL);
+	err =3D register_ioctl32_conversion(MPTEVENTENABLE, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTEVENTREPORT, NULL);
+	err =3D register_ioctl32_conversion(MPTEVENTREPORT, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTHARDRESET, NULL);
+	err =3D register_ioctl32_conversion(MPTHARDRESET, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(MPTCOMMAND32, =
sparc32_mpt_command);
+	err =3D register_ioctl32_conversion(MPTCOMMAND32, =
compat_mpt_command);
 	if (++where && err) goto out_fail;
 	err =3D register_ioctl32_conversion(MPTFWDOWNLOAD32,
-					  sparc32_mptfwxfer_ioctl);
+					  compat_mptfwxfer_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(HP_GETHOSTINFO, NULL);
+	err =3D register_ioctl32_conversion(HP_GETHOSTINFO, sys_ioctl);
 	if (++where && err) goto out_fail;
-	err =3D register_ioctl32_conversion(HP_GETTARGETINFO, NULL);
+	err =3D register_ioctl32_conversion(HP_GETTARGETINFO, sys_ioctl);
 	if (++where && err) goto out_fail;
-#endif		/*} linux >=3D 2.3.x */
-#endif		/*} sparc */
+#endif
=20
 	/* Register this device */
 	err =3D misc_register(&mptctl_miscdev);
@@ -2925,8 +2922,7 @@
=20
 out_fail:
=20
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,3,0)		/*{*/
+#ifdef CONFIG_COMPAT
 	printk(KERN_ERR MYNAM ": ERROR: Failed to register =
ioctl32_conversion!"
 			" (%d:err=3D%d)\n", where, err);
 	unregister_ioctl32_conversion(MPTIOCINFO);
@@ -2941,8 +2937,7 @@
 	unregister_ioctl32_conversion(MPTFWDOWNLOAD32);
 	unregister_ioctl32_conversion(HP_GETHOSTINFO);
 	unregister_ioctl32_conversion(HP_GETTARGETINFO);
-#endif		/*} linux >=3D 2.3.x */
-#endif		/*} sparc */
+#endif
=20
 	for (i=3D0; i<MPT_MAX_ADAPTERS; i++) {
 		ioc =3D NULL;
@@ -2979,6 +2974,21 @@
 	mpt_deregister(mptctl_id);
 	printk(KERN_INFO MYNAM ": Deregistered from Fusion MPT base =
driver\n");
=20
+#ifdef CONFIG_COMPAT
+	unregister_ioctl32_conversion(MPTIOCINFO);
+	unregister_ioctl32_conversion(MPTIOCINFO1);
+	unregister_ioctl32_conversion(MPTTARGETINFO);
+	unregister_ioctl32_conversion(MPTTEST);
+	unregister_ioctl32_conversion(MPTEVENTQUERY);
+	unregister_ioctl32_conversion(MPTEVENTENABLE);
+	unregister_ioctl32_conversion(MPTEVENTREPORT);
+	unregister_ioctl32_conversion(MPTHARDRESET);
+	unregister_ioctl32_conversion(MPTCOMMAND32);
+	unregister_ioctl32_conversion(MPTFWDOWNLOAD32);
+	unregister_ioctl32_conversion(HP_GETHOSTINFO);
+	unregister_ioctl32_conversion(HP_GETTARGETINFO);
+#endif
+
 	/* Free allocated memory */
 	for (i=3D0; i<MPT_MAX_ADAPTERS; i++) {
 		ioc =3D NULL;
diff -Nuar linux/drivers/message/fusion/mptctl.h =
11/drivers/message/fusion/mptctl.h
--- linux/drivers/message/fusion/mptctl.h	2004-01-09 16:35:24.000000000 =
+0100
+++ 11/drivers/message/fusion/mptctl.h	2003-10-27 21:10:22.000000000 =
+0100
@@ -18,7 +18,7 @@
  *  Copyright (c) 1999-2002 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptctl.h,v 1.14 2003/03/18 22:49:51 pdelaney Exp $
  */
@@ -84,10 +84,10 @@
 #define MPTFWDOWNLOAD		_IOWR(MPT_MAGIC_NUMBER,15,struct mpt_fw_xfer)
 #define MPTCOMMAND		_IOWR(MPT_MAGIC_NUMBER,20,struct =
mpt_ioctl_command)
=20
-#if defined(__KERNEL__) && defined(__sparc__) && defined(__sparc_v9__)	=
	/*{*/
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 #define MPTFWDOWNLOAD32		_IOWR(MPT_MAGIC_NUMBER,15,struct =
mpt_fw_xfer32)
 #define MPTCOMMAND32		_IOWR(MPT_MAGIC_NUMBER,20,struct =
mpt_ioctl_command32)
-#endif	/*}*/
+#endif
=20
 #define MPTIOCINFO		_IOWR(MPT_MAGIC_NUMBER,17,struct =
mpt_ioctl_iocinfo)
 #define MPTIOCINFO1		_IOWR(MPT_MAGIC_NUMBER,17,struct =
mpt_ioctl_iocinfo_rev0)
@@ -117,13 +117,13 @@
 	void		*bufp;		/* Pointer to firmware buffer */
 };
=20
-#if defined(__KERNEL__) && defined(__sparc__) && defined(__sparc_v9__)	=
	/*{*/
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 struct mpt_fw_xfer32 {
 	unsigned int iocnum;
 	unsigned int fwlen;
 	u32 bufp;
 };
-#endif	/*}*/
+#endif
=20
 /*
  *  IOCTL header structure.
@@ -316,7 +316,7 @@
 /*
  * SPARC PLATFORM: See earlier remark.
  */
-#if defined(__KERNEL__) && defined(__sparc__) && defined(__sparc_v9__)	=
	/*{*/
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 struct mpt_ioctl_command32 {
 	mpt_ioctl_header hdr;
 	int	timeout;
@@ -331,7 +331,7 @@
 	int	dataSgeOffset;
 	char	MF[1];
 };
-#endif	/*}*/
+#endif
=20
=20
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
diff -Nuar linux/drivers/message/fusion/mptscsih.c =
11/drivers/message/fusion/mptscsih.c
--- linux/drivers/message/fusion/mptscsih.c	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/mptscsih.c	2003-12-04 18:27:40.000000000 =
+0100
@@ -24,7 +24,7 @@
  *  Copyright (c) 1999-2002 LSI Logic Corporation
  *  Original author: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptscsih.c,v 1.1.2.4 2003/05/07 14:08:34 pdelaney Exp $
  */
@@ -180,12 +180,13 @@
 static int	mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 static int	mptscsih_event_process(MPT_ADAPTER *ioc, =
EventNotificationReply_t *pEvReply);
=20
-static VirtDevice	*mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, =
int target_id, u8 lun, char *data, int dlen);
+static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int =
target_id, u8 lun, char *data, int dlen);
 void		mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice =
*target, char byte56);
 static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t =
*pReq);
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 =
offset, int *requestedPtr, int *configurationPtr, u8 flags);
 static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id);
 static int	mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int =
target, int flags);
+static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, =
int bus);
 static int	mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR =
*mf, MPT_FRAME_HDR *r);
 static void	mptscsih_timer_expired(unsigned long data);
 static void	mptscsih_taskmgmt_timeout(unsigned long data);
@@ -438,10 +439,10 @@
 static inline int
 mptscsih_getFreeChainBuffer(MPT_SCSI_HOST *hd, int *retIndex)
 {
-	MPT_FRAME_HDR *chainBuf =3D NULL;
+	MPT_FRAME_HDR *chainBuf;
 	unsigned long flags;
-	int rc =3D FAILED;
-	int chain_idx =3D MPT_HOST_NO_CHAIN;
+	int rc;
+	int chain_idx;
=20
 	spin_lock_irqsave(&hd->ioc->FreeQlock, flags);
 	if (!Q_IS_EMPTY(&hd->FreeChainQ)) {
@@ -454,6 +455,10 @@
 		chain_idx =3D offset / hd->ioc->req_sz;
 		rc =3D SUCCESS;
 	}
+	else {
+		rc =3D FAILED;
+		chain_idx =3D MPT_HOST_NO_CHAIN;
+	}
 	spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
=20
=20
@@ -506,12 +511,13 @@
 	/* Map the data portion, if any.
 	 * sges_left  =3D 0 if no data transfer.
 	 */
-	sges_left =3D SCpnt->use_sg;
-	if (SCpnt->use_sg) {
-		sges_left =3D pci_map_sg(hd->ioc->pcidev,
+	if ( (sges_left =3D SCpnt->use_sg) ) {
+		if ( (sges_left =3D pci_map_sg(hd->ioc->pcidev,
 			       (struct scatterlist *) SCpnt->request_buffer,
 			       SCpnt->use_sg,
-			       scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+			       scsi_to_pci_dma_dir(SCpnt->sc_data_direction)))
+			=3D=3D 0 )
+				return FAILED;
 	} else if (SCpnt->request_bufflen) {
 		dma_addr_t	 buf_dma_addr;
 		scPrivate	*my_priv;
@@ -730,13 +736,6 @@
=20
 	hd =3D (MPT_SCSI_HOST *) ioc->sh->hostdata;
=20
-	if ((mf =3D=3D NULL) ||
-	    (mf >=3D MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))) {
-		printk(MYIOC_s_ERR_FMT "%s req frame ptr! (=3D%p)!\n",
-				ioc->name, mf?"BAD":"NULL", (void *) mf);
-		return 0;
-	}
-
 	req_idx =3D le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
 	sc =3D hd->ScsiLookup[req_idx];
 	if (sc =3D=3D NULL) {
@@ -878,7 +877,6 @@
 				mptscsih_no_negotiate(hd, sc->target);
 			break;
=20
-		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
 			/*
 			 *  YIKES!  I just discovered that SCSI IO which
@@ -916,6 +914,9 @@
 			sc->resid =3D sc->request_bufflen - xfer_cnt;
 			dprintk((KERN_NOTICE "  SET sc->resid=3D%02xh\n", sc->resid));
 #endif
+			if (sc->underflow > xfer_cnt) {
+				sc->result =3D DID_SOFT_ERROR;
+			}
=20
 			/* Report Queue Full
 			 */
@@ -1036,6 +1037,7 @@
 		case MPI_IOCSTATUS_INVALID_STATE:		/* 0x0008 */
 		case MPI_IOCSTATUS_SCSI_DATA_OVERRUN:		/* 0x0044 */
 		case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR:		/* 0x0046 */
+		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
 		case MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED:	/* 0x004A */
 		default:
 			/*
@@ -1156,8 +1158,8 @@
 static void
 clean_taskQ(MPT_SCSI_HOST *hd)
 {
-	MPT_FRAME_HDR *mf =3D NULL;
-	MPT_FRAME_HDR *nextmf =3D NULL;
+	MPT_FRAME_HDR *mf;
+	MPT_FRAME_HDR *nextmf;
 	MPT_ADAPTER *ioc =3D hd->ioc;
 	unsigned long flags;
=20
@@ -1196,7 +1198,7 @@
 static void
 search_taskQ_for_cmd(Scsi_Cmnd *sc, MPT_SCSI_HOST *hd)
 {
-	MPT_FRAME_HDR *mf =3D NULL;
+	MPT_FRAME_HDR *mf;
 	unsigned long flags;
 	int count =3D 0;
=20
@@ -1320,7 +1322,7 @@
 static void
 mptscsih_reset_timeouts (MPT_SCSI_HOST *hd)
 {
-	Scsi_Cmnd	*SCpnt =3D NULL;
+	Scsi_Cmnd	*SCpnt;
 	int		 ii;
 	int		 max =3D hd->ioc->req_depth;
=20
@@ -1346,9 +1348,9 @@
 static void
 mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 {
-	Scsi_Cmnd	*SCpnt =3D NULL;
-	MPT_FRAME_HDR	*mf =3D NULL;
-	MPT_DONE_Q	*buffer =3D NULL;
+	Scsi_Cmnd	*SCpnt;
+	MPT_FRAME_HDR	*mf;
+	MPT_DONE_Q	*buffer;
 	int		 ii;
 	int		 max =3D hd->ioc->req_depth;
=20
@@ -1457,18 +1459,16 @@
 	/* ReqToChain size must equal the req_depth
 	 * index =3D req_idx
 	 */
-	sz =3D hd->ioc->req_depth * sizeof(int);
 	if (hd->ReqToChain =3D=3D NULL) {
+		sz =3D hd->ioc->req_depth * sizeof(int);
 		mem =3D kmalloc(sz, GFP_ATOMIC);
 		if (mem =3D=3D NULL)
 			return -1;
=20
 		hd->ReqToChain =3D (int *) mem;
-	} else {
-		mem =3D (u8 *) hd->ReqToChain;
 	}
-	memset(mem, 0xFF, sz);
-
+	for (ii =3D 0; ii < hd->ioc->req_depth; ii++)
+		hd->ReqToChain[ii] =3D MPT_HOST_NO_CHAIN;
=20
 	/* ChainToChain size must equal the total number
 	 * of chain buffers to be allocated.
@@ -1606,9 +1606,9 @@
 int
 mptscsih_detect(Scsi_Host_Template *tpnt)
 {
-	struct Scsi_Host	*sh =3D NULL;
-	MPT_SCSI_HOST		*hd =3D NULL;
-	MPT_ADAPTER		*this;
+	struct Scsi_Host	*sh;
+	MPT_SCSI_HOST		*hd;
+	MPT_ADAPTER		*ioc;
 	MPT_DONE_Q		*freedoneQ;
 	unsigned long		 flags;
 	int			 sz, ii;
@@ -1651,20 +1651,19 @@
 	atomic_set(&mpt_taskQdepth, 0);
 #endif
=20
-	this =3D mpt_adapter_find_first();
-	while (this !=3D NULL) {
+	for (ioc =3D mpt_adapter_find_first(); ioc !=3D NULL; ioc =3D =
mpt_adapter_find_next(ioc)) {
 		/* 20010202 -sralston
 		 *  Added sanity check on readiness of the MPT adapter.
 		 */
-		if (this->last_state !=3D MPI_IOC_STATE_OPERATIONAL) {
+		if (ioc->last_state !=3D MPI_IOC_STATE_OPERATIONAL) {
 			printk(MYIOC_s_WARN_FMT "Skipping because it's not operational!\n",
-					this->name);
+					ioc->name);
 			continue;
 		}
=20
-		if (!this->active) {
+		if (!ioc->active) {
 			printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",
-					this->name);
+					ioc->name);
 			continue;
 		}
=20
@@ -1672,14 +1671,14 @@
 		/*  Sanity check - ensure at least 1 port is INITIATOR capable
 		 */
 		ioc_cap =3D 0;
-		for (ii=3D0; ii < this->facts.NumberOfPorts; ii++) {
-			if (this->pfacts[ii].ProtocolFlags & =
MPI_PORTFACTS_PROTOCOL_INITIATOR)
+		for (ii=3D0; ii < ioc->facts.NumberOfPorts; ii++) {
+			if (ioc->pfacts[ii].ProtocolFlags & =
MPI_PORTFACTS_PROTOCOL_INITIATOR)
 				ioc_cap ++;
 		}
=20
 		if (!ioc_cap) {
-			printk(MYIOC_s_WARN_FMT "Skipping because SCSI Initiator mode is =
NOT enabled!\n",
-					this->name);
+			printk(MYIOC_s_WARN_FMT "Skipping ioc=3D%p because SCSI Initiator =
mode is NOT enabled!\n",
+					ioc->name, ioc);
 			continue;
 		}
=20
@@ -1690,7 +1689,7 @@
 		tpnt->proc_info =3D mptscsih_proc_info;
 		sh =3D scsi_register(tpnt, sizeof(MPT_SCSI_HOST));
 		if (sh !=3D NULL) {
-			spin_lock_irqsave(&this->FreeQlock, flags);
+			spin_lock_irqsave(&ioc->FreeQlock, flags);
 			sh->io_port =3D 0;
 			sh->n_io_port =3D 0;
 			sh->irq =3D 0;
@@ -1705,7 +1704,7 @@
 			 * max_lun =3D 1 + actual last lun,
 			 *	see hosts.h :o(
 			 */
-			if ((int)this->chip_type > (int)FC929)
+			if ((int)ioc->chip_type > (int)FC929)
 				sh->max_id =3D MPT_MAX_SCSI_DEVICES;
 			else {
 				/* For FC, increase the queue depth
@@ -1732,7 +1731,7 @@
 			 * and all access to VirtDev
 			 */
 			sh->max_channel =3D 0;
-			sh->this_id =3D this->pfacts[0].PortSCSIID;
+			sh->this_id =3D ioc->pfacts[0].PortSCSIID;
=20
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,44)
 			/* OS entry to allow host drivers to force
@@ -1742,7 +1741,7 @@
 #endif
 			/* Required entry.
 			 */
-			sh->unique_id =3D this->id;
+			sh->unique_id =3D ioc->id;
=20
 			/* Verify that we won't exceed the maximum
 			 * number of chain buffers
@@ -1753,38 +1752,38 @@
 			 * A slightly different algorithm is required for
 			 * 64bit SGEs.
 			 */
-			scale =3D this->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
+			scale =3D ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
 			if (sizeof(dma_addr_t) =3D=3D sizeof(u64)) {
-				numSGE =3D (scale - 1) * (this->facts.MaxChainDepth-1) + scale +
-					(this->req_sz - 60) / (sizeof(dma_addr_t) + sizeof(u32));
+				numSGE =3D (scale - 1) * (ioc->facts.MaxChainDepth-1) + scale +
+					(ioc->req_sz - 60) / (sizeof(dma_addr_t) + sizeof(u32));
 			} else {
-				numSGE =3D 1 + (scale - 1) * (this->facts.MaxChainDepth-1) + scale =
+
-					(this->req_sz - 64) / (sizeof(dma_addr_t) + sizeof(u32));
+				numSGE =3D 1 + (scale - 1) * (ioc->facts.MaxChainDepth-1) + scale =
+
+					(ioc->req_sz - 64) / (sizeof(dma_addr_t) + sizeof(u32));
 			}
=20
 			if (numSGE < sh->sg_tablesize) {
 				/* Reset this value */
 				dprintk((MYIOC_s_INFO_FMT
 					 "Resetting sg_tablesize to %d from %d\n",
-					 this->name, numSGE, sh->sg_tablesize));
+					 ioc->name, numSGE, sh->sg_tablesize));
 				sh->sg_tablesize =3D numSGE;
 			}
=20
 			/* Set the pci device pointer in Scsi_Host structure.
 			 */
-			scsi_set_pci_device(sh, this->pcidev);
+			scsi_set_pci_device(sh, ioc->pcidev);
=20
-			spin_unlock_irqrestore(&this->FreeQlock, flags);
+			spin_unlock_irqrestore(&ioc->FreeQlock, flags);
=20
 			hd =3D (MPT_SCSI_HOST *) sh->hostdata;
-			hd->ioc =3D this;
+			hd->ioc =3D ioc;
 			hd->max_sge =3D sh->sg_tablesize;
=20
-			if ((int)this->chip_type > (int)FC929)
+			if ((int)ioc->chip_type > (int)FC929)
 				hd->is_spi =3D 1;
=20
 			if (DmpService &&
-			    (this->chip_type =3D=3D FC919 || this->chip_type =3D=3D FC929))
+			    (ioc->chip_type =3D=3D FC919 || ioc->chip_type =3D=3D FC929))
 				hd->is_multipath =3D 1;
=20
 			/* SCSI needs Scsi_Cmnd lookup table!
@@ -1799,7 +1798,7 @@
 			hd->ScsiLookup =3D (struct scsi_cmnd **) mem;
=20
 			dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=3D%d\n",
-				 this->name, hd->ScsiLookup, sz));
+				 ioc->name, hd->ScsiLookup, sz));
=20
 			if (mptscsih_initChainBuffers(hd, 1) < 0)
 				goto done;
@@ -1870,7 +1869,7 @@
=20
 			/* Attach the SCSI Host to the IOC structure
 			 */
-			this->sh =3D sh;
+			ioc->sh =3D sh;
=20
 			/* Initialize this SCSI Hosts' timers
 			 * To use, set the timer expires field
@@ -1886,7 +1885,7 @@
 			hd->qtag_tick =3D jiffies;
=20
 			/* Moved Earlier Pam D */
-			/* this->sh =3D sh;	*/
+			/* ioc->sh =3D sh;	*/
=20
 #ifdef MPTSCSIH_DBG_TIMEOUT
 			hd->ioc->timeout_hard =3D 0;
@@ -1909,6 +1908,8 @@
 				if (hd->ioc->spi_data.minSyncFactor =3D=3D MPT_ASYNC)
 					hd->ioc->spi_data.maxSyncOffset =3D 0;
=20
+				hd->ioc->spi_data.Saf_Te =3D driver_setup.saf_te;
+
 				hd->negoNvram =3D 0;
 #ifdef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
 				hd->negoNvram =3D MPT_SCSICFG_USE_NVRAM;
@@ -1926,16 +1927,15 @@
 				}
=20
 				ddvprintk((MYIOC_s_INFO_FMT
-					"dv %x width %x factor %x \n",
+					"dv %x width %x factor %x saf_te %x\n",
 					hd->ioc->name, driver_setup.dv,
 					driver_setup.max_width,
-					driver_setup.min_sync_fac));
+					driver_setup.min_sync_fac,
+					driver_setup.saf_te));
 			}
=20
 			mpt_scsi_hosts++;
 		}
-
-		this =3D mpt_adapter_find_next(this);
 	}
=20
 done:
@@ -2146,8 +2146,8 @@
 static int
 mptscsih_halt(struct notifier_block *nb, ulong event, void *buf)
 {
-	MPT_ADAPTER *ioc =3D NULL;
-	MPT_SCSI_HOST *hd =3D NULL;
+	MPT_ADAPTER *ioc;
+	MPT_SCSI_HOST *hd;
=20
 	/* Ignore all messages other than reboot message
 	 */
@@ -2182,7 +2182,7 @@
 const char *
 mptscsih_info(struct Scsi_Host *SChost)
 {
-	MPT_SCSI_HOST *h =3D NULL;
+	MPT_SCSI_HOST *h;
 	int size =3D 0;
=20
 	if (info_kbuf =3D=3D NULL)
@@ -2398,7 +2398,7 @@
 int mptscsih_proc_info(char *buffer, char **start, off_t offset,
 			int length, int hostno, int func)
 {
-	MPT_ADAPTER	*ioc =3D NULL;
+	MPT_ADAPTER	*ioc;
 	MPT_SCSI_HOST	*hd =3D NULL;
 	int size =3D 0;
=20
@@ -2489,7 +2489,7 @@
 	MPT_FRAME_HDR		*mf;
 	SCSIIORequest_t		*pScsiReq;
 	VirtDevice		*pTarget;
-	MPT_DONE_Q		*buffer =3D NULL;
+	MPT_DONE_Q		*buffer;
 	unsigned long		 flags;
 	int	 target;
 	int	 lun;
@@ -2774,7 +2774,7 @@
 static void
 mptscsih_freeChainBuffers(MPT_SCSI_HOST *hd, int req_idx)
 {
-	MPT_FRAME_HDR *chain =3D NULL;
+	MPT_FRAME_HDR *chain;
 	unsigned long flags;
 	int chain_idx;
 	int next;
@@ -2839,7 +2839,7 @@
 static int
 mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, =
u8 lun, int ctx2abort, int sleepFlag)
 {
-	MPT_ADAPTER	*ioc =3D NULL;
+	MPT_ADAPTER	*ioc;
 	int		 rc =3D -1;
 	int		 doTask =3D 1;
 	u32		 ioc_raw_state;
@@ -3088,7 +3088,6 @@
 		search_doneQ_for_cmd(hd, SCpnt);
=20
 		SCpnt->result =3D DID_RESET << 16;
-		SCpnt->scsi_done(SCpnt);
 		nehprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
 			   "Command not in the active list! (sc=3D%p)\n",
 			   hd->ioc->name, SCpnt));
@@ -3345,7 +3344,6 @@
 	if ((hd =3D (MPT_SCSI_HOST *) SCpnt->host->hostdata) =3D=3D NULL) {
 		printk(KERN_WARNING "  WARNING - OldAbort, NULL hostdata ptr!!\n");
 		SCpnt->result =3D DID_ERROR << 16;
-		SCpnt->scsi_done(SCpnt);
 		return SCSI_ABORT_NOT_RUNNING;
 	}
=20
@@ -3359,18 +3357,19 @@
 		 */
 		search_doneQ_for_cmd(hd, SCpnt);
=20
-		SCpnt->result =3D DID_RESET << 16;
-		SCpnt->scsi_done(SCpnt);
+		SCpnt->result =3D DID_ABORT << 16;
 		return SCSI_ABORT_SUCCESS;
 	} else {
 		/* If this command is pended, then timeout/hang occurred
 		 * during DV. Force bus reset by posting command to F/W
 		 * and then following up with the reset request.
 		 */
+#ifndef MPTSCSIH_DBG_TIMEOUT
 		if ((mf =3D mptscsih_search_pendingQ(hd, scpnt_idx)) !=3D NULL) {
 			mptscsih_put_msgframe(ScsiDoneCtx, hd->ioc->id, mf);
 			post_pendingQ_commands(hd);
 		}
+#endif
 	}
=20
 	/*
@@ -3476,8 +3475,7 @@
 	printk(KERN_WARNING "  IOs outstanding =3D %d\n", =
atomic_read(&queue_depth));
=20
 	if ((hd =3D (MPT_SCSI_HOST *) SCpnt->host->hostdata) =3D=3D NULL) {
-		SCpnt->result =3D DID_RESET << 16;
-		SCpnt->scsi_done(SCpnt);
+		SCpnt->result =3D DID_ERROR << 16;
 		return SCSI_RESET_SUCCESS;
 	}
=20
@@ -3492,17 +3490,18 @@
 		search_doneQ_for_cmd(hd, SCpnt);
=20
 		SCpnt->result =3D DID_RESET << 16;
-		SCpnt->scsi_done(SCpnt);
 		return SCSI_RESET_SUCCESS;
 	} else {
 		/* If this command is pended, then timeout/hang occurred
 		 * during DV. Force bus reset by posting command to F/W
 		 * and then following up with the reset request.
 		 */
+#ifndef MPTSCSIH_DBG_TIMEOUT
 		if ((mf =3D mptscsih_search_pendingQ(hd, scpnt_idx)) !=3D NULL) {
 			mptscsih_put_msgframe(ScsiDoneCtx, hd->ioc->id, mf);
 			post_pendingQ_commands(hd);
 		}
+#endif
 	}
=20
 	/*
@@ -3628,8 +3627,8 @@
=20
 #ifdef MPTSCSIH_DBG_TIMEOUT
 				if (ioc->timeout_hard =3D=3D 1) {
-					mptscsih_TMHandler(hd,=20
-						MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,=20
+					mptscsih_TMHandler(hd,
+						MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 						0, 0, 0, 0, CAN_SLEEP);
=20
 				}
@@ -3727,6 +3726,9 @@
 				mpt_free_msg_frame(ScsiTaskCtx, hd->ioc->id, mf);
 				mf =3D NULL;
=20
+#ifndef MPTSCSIH_DBG_TIMEOUT
+				post_pendingQ_commands(hd);
+#endif
 				if (mptscsih_TMHandler(hd, task_type, SCpnt->channel,
 						      SCpnt->target, SCpnt->lun,
 						       ctx2abort, CAN_SLEEP) < 0) {
@@ -3784,7 +3786,7 @@
 {
 	SCSITaskMgmtReply_t	*pScsiTmReply;
 	SCSITaskMgmt_t		*pScsiTmReq;
-	MPT_SCSI_HOST		*hd =3D NULL;
+	MPT_SCSI_HOST		*hd;
 	unsigned long		 flags;
 	u8			 tmType =3D 0;
=20
@@ -3962,10 +3964,10 @@
 			}
=20
 			if (pTarget !=3D NULL) {
-				printk(MYIOC_s_INFO_FMT
+				dprintk((MYIOC_s_INFO_FMT
 					 "scsi%d: Id=3D%d Lun=3D%d: Queue depth=3D%d\n",
-					 hd->ioc->name, sh->host_no,
-					 device->id, device->lun, device->queue_depth);
+					 hd->ioc->name,=20
+					 device->id, device->lun, device->queue_depth));
=20
 				dprintk((MYIOC_s_INFO_FMT
 					 "Id =3D %d, sync factor =3D %x\n",
@@ -4041,11 +4043,10 @@
 		thisIo.SCSIStatus =3D pScsiReply->SCSIStatus;
 		thisIo.DoDisplay =3D 1;
 		if (hd->is_multipath)
-			sprintf(devFoo, "%d:%d:%d \"%s\"",
+			sprintf(devFoo, "%d:%d:%d",
 					hd->ioc->id,
 					pReq->TargetID,
-					pReq->LUN[1],
-					target->dev_vol_name);
+					pReq->LUN[1]);
 		else
 			sprintf(devFoo, "%d:%d:%d", hd->ioc->id, sc->target, sc->lun);
 		thisIo.DevIDStr =3D devFoo;
@@ -4102,7 +4103,7 @@
 	unsigned long	 flags;
 	MPT_DONE_Q	*buffer;
 	MPT_FRAME_HDR	*mf =3D NULL;
-	MPT_FRAME_HDR	*cmdMfPtr =3D NULL;
+	MPT_FRAME_HDR	*cmdMfPtr;
=20
 	ddvtprintk((MYIOC_s_INFO_FMT ": search_pendingQ ...", =
hd->ioc->name));
 	cmdMfPtr =3D MPT_INDEX_2_MFPTR(hd->ioc, scpnt_idx);
@@ -4190,7 +4191,7 @@
 static int
 mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	MPT_SCSI_HOST	*hd =3D NULL;
+	MPT_SCSI_HOST	*hd;
 	unsigned long	 flags;
=20
 	dtmprintk((KERN_WARNING MYNAM
@@ -4263,7 +4264,7 @@
=20
 		dtmprintk((MYIOC_s_WARN_FMT "Pre-Reset complete.\n", ioc->name));
 	} else {
-		ScsiCfgData	*pSpi =3D NULL;
+		ScsiCfgData	*pSpi;
=20
 		dtmprintk((MYIOC_s_WARN_FMT "Post-Diag Reset\n", ioc->name));
=20
@@ -4971,13 +4972,12 @@
  *	Allocate and initialize memory for this target.
  *	Save inquiry data.
  *
- *	Returns pointer to VirtDevice structure.
  */
-static VirtDevice *
+static void=20
 mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 =
lun, char *data, int dlen)
 {
+	int		indexed_lun, lun_index;
 	VirtDevice	*vdev;
-	int		 sz;
=20
 	dprintk((MYIOC_s_INFO_FMT "initTarget (%d,%d,%d) called, hd=3D%p\n",
 			hd->ioc->name, bus_id, target_id, lun, hd));
@@ -4986,6 +4986,7 @@
 		if ((vdev =3D kmalloc(sizeof(VirtDevice), GFP_ATOMIC)) =3D=3D NULL) =
{
 			printk(MYIOC_s_ERR_FMT "initTarget kmalloc(%d) FAILED!\n",
 					hd->ioc->name, (int)sizeof(VirtDevice));
+			return;
 		} else {
 			memset(vdev, 0, sizeof(VirtDevice));
 			rwlock_init(&vdev->VdevLock);
@@ -5004,24 +5005,44 @@
 	}
=20
 	vdev->raidVolume =3D 0;
-	if (vdev && hd->is_spi) {
+	if (hd->is_spi) {
 		if (hd->ioc->spi_data.isRaid & (1 << target_id)) {
 			vdev->raidVolume =3D 1;
 			ddvtprintk((KERN_INFO "RAID Volume @ id %d\n", target_id));
 		}
 	}
=20
-	if (vdev && data) {
-		if ((!(vdev->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY)) ||
-		((dlen > 56) && (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_56)))) {
-
-			/* Copy the inquiry data  - if we haven't yet.
-			*/
-			sz =3D MIN(dlen, SCSI_STD_INQUIRY_BYTES);
+	if (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY)) {
+		/* Copy the inquiry data  - if we haven't yet.
+		*/
+
+		memcpy (vdev->inq_data, data, 8);
=20
-			memcpy (vdev->inq_data, data, sz);
+		if ( (data[0] =3D=3D SCSI_TYPE_PROC) &&=20
+			!(vdev->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
+			if ( dlen > 49 ) {
+				vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;
+				if ( data[44] =3D=3D 'S' &&=20
+				     data[45] =3D=3D 'A' &&=20
+				     data[46] =3D=3D 'F' &&=20
+				     data[47] =3D=3D '-' &&=20
+				     data[48] =3D=3D 'T' &&=20
+				     data[49] =3D=3D 'E' ) {
+					vdev->tflags |=3D MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+					mptscsih_writeIOCPage4(hd, target_id, bus_id);
+				}
+			} else {
+				/* Treat all Processors as SAF-TE if=20
+				 * command line option is set */
+				if ( hd->ioc->spi_data.Saf_Te ) {
+					vdev->tflags |=3D MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+					mptscsih_writeIOCPage4(hd, target_id, bus_id);
+				}
+			}
+		} else=20
 			vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;
=20
+		if ((dlen > 56) && (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_56))) {
 			/* Update the target capabilities
 			 */
 			if (dlen > 56) {
@@ -5038,17 +5059,19 @@
 					pSpi->dvStatus[target_id] |=3D MPT_SCSICFG_NEED_DV;
 			}
 		}
-
-		/* Is LUN supported? If so, upper 3 bits will be 0
-		 * in first byte of inquiry data.
-		 */
-		if ((*data & 0xe0) =3D=3D 0)
-			vdev->luns |=3D (1 << lun);
 	}
=20
+	/* Is LUN supported? If so, upper 3 bits will be 0
+	 * in first byte of inquiry data.
+	 */
+	if ((*data & 0xe0) =3D=3D 0) {
+		lun_index =3D (lun >> 5);  /* 32 luns per lun_index */
+		indexed_lun =3D (lun % 32);
+		vdev->luns[lun_index] |=3D (1 << indexed_lun);
+	}
=20
 	dprintk((KERN_INFO "  target =3D %p\n", vdev));
-	return vdev;
+	return;
 }
=20
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
@@ -5063,13 +5086,13 @@
 	int  id =3D (int) target->target_id;
 	int  nvram;
 	char canQ =3D 0;
+	VirtDevice	*vdev;
+	int ii;
 	u8 width =3D MPT_NARROW;
 	u8 factor =3D MPT_ASYNC;
 	u8 offset =3D 0;
 	u8 version, nfactor;
-	u8 noQas =3D 0;
-
-	ddvtprintk((KERN_INFO "set Target: (id %d) byte56 0x%x\n", id, =
byte56));
+	u8 noQas =3D 1;
=20
 	if (!hd->is_spi) {
 		if (target->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
@@ -5079,19 +5102,16 @@
 		return;
 	}
=20
+	target->negoFlags =3D pspi_data->noQas;
+
 	/* noQas =3D=3D 0 =3D> device supports QAS. Need byte 56 of Inq to =
determine
 	 * support. If available, default QAS to off and allow enabling.
 	 * If not available, default QAS to on, turn off for non-disks.
 	 */
-	if (target->tflags & MPT_TARGET_FLAGS_VALID_56)
-		noQas =3D 1;
=20
 	/* Set flags based on Inquiry data
 	 */
 	if (target->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
-		if ((target->inq_data[0] & 0x1F) !=3D 0x00)
-			noQas =3D 1;
-
 		version =3D target->inq_data[2] & 0x07;
 		if (version < 2) {
 			width =3D 0;
@@ -5111,6 +5131,7 @@
 					factor =3D MPT_ULTRA160;
 				else
 					factor =3D MPT_ULTRA320;
+				offset =3D pspi_data->maxSyncOffset;
=20
 				/* If RAID, never disable QAS
 				 * else if non RAID, do not disable
@@ -5120,8 +5141,6 @@
 				 */
 				if ((target->raidVolume =3D=3D 1) || ((byte56 & 0x02) !=3D 0))
 					noQas =3D 0;
-
-				offset =3D pspi_data->maxSyncOffset;
 			} else {
 				factor =3D MPT_ASYNC;
 				offset =3D 0;
@@ -5180,35 +5199,31 @@
=20
 		/* Disable unused features.
 		 */
-		target->negoFlags =3D pspi_data->noQas;
 		if (!width)
 			target->negoFlags |=3D MPT_TARGET_NO_NEGO_WIDE;
=20
 		if (!offset)
 			target->negoFlags |=3D MPT_TARGET_NO_NEGO_SYNC;
=20
-		if (noQas)
-			target->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;
-
 		/* GEM, processor WORKAROUND
 		 */
-		if (((target->inq_data[0] & 0x1F) =3D=3D 0x03) || =
((target->inq_data[0] & 0x1F) > 0x08)){
+		if (((target->inq_data[0] & 0x1F) =3D=3D 0x03) || =
((target->inq_data[0] & 0x1F) > 0x08)) {
 			target->negoFlags |=3D (MPT_TARGET_NO_NEGO_WIDE | =
MPT_TARGET_NO_NEGO_SYNC);
 			pspi_data->dvStatus[id] |=3D MPT_SCSICFG_BLK_NEGO;
-		}
-
-		/* Disable QAS if mixed configuration case
-		 */
-		if ((noQas) && (!pspi_data->noQas) && ((target->inq_data[0] & 0x1F) =
!=3D 0x03)){
-			VirtDevice	*vdev;
-			int ii;
-
-			ddvtprintk((KERN_INFO "Disabling QAS!\n"));
-			pspi_data->noQas =3D MPT_TARGET_NO_NEGO_QAS;
-			for (ii =3D 0; ii < id; ii++) {
-				vdev =3D hd->Targets[id];
-				if (vdev !=3D NULL)
-					vdev->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;
+		} else {
+			if (noQas && (pspi_data->noQas =3D=3D 0)) {
+				pspi_data->noQas |=3D MPT_TARGET_NO_NEGO_QAS;
+				target->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;
+
+				/* Disable QAS in a mixed configuration case
+		 		*/
+
+//				ddvtprintk((KERN_INFO "Disabling QAS!\n"));
+				for (ii =3D 0; ii < id; ii++) {
+					if ( (vdev =3D hd->Targets[ii]) ) {
+						vdev->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;
+					}=09
+				}
 			}
 		}
 	}
@@ -5334,9 +5349,9 @@
 mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int target_id, int =
flags)
 {
 	MPT_ADAPTER		*ioc =3D hd->ioc;
-	Config_t		*pReq =3D NULL;
-	SCSIDevicePage1_t	*pData =3D NULL;
-	VirtDevice		*pTarget =3D NULL;
+	Config_t		*pReq;
+	SCSIDevicePage1_t	*pData;
+	VirtDevice		*pTarget;
 	MPT_FRAME_HDR		*mf;
 	dma_addr_t		 dataDma;
 	u16			 req_idx;
@@ -5432,7 +5447,6 @@
 			factor =3D pTarget->minSyncFactor;
 			offset =3D pTarget->maxOffset;
 			negoFlags =3D pTarget->negoFlags;
-			pTarget =3D NULL;
 		}
=20
 		if (flags & MPT_SCSICFG_BLK_NEGO)
@@ -5515,6 +5529,86 @@
 }
=20
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
+/*	mptscsih_writeIOCPage4  - write IOC Page 4
+ *	@hd: Pointer to a SCSI Host Structure
+ *	@target_id: write IOC Page4 for this ID & Bus
+ *
+ *	Return: -EAGAIN if unable to obtain a Message Frame
+ *		or 0 if success.
+ *
+ *	Remark: We do not wait for a return, write pages sequentially.
+ */
+static int
+mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus)
+{
+	MPT_ADAPTER		*ioc =3D hd->ioc;
+	Config_t		*pReq;
+	IOCPage4_t		*IOCPage4Ptr;
+	MPT_FRAME_HDR		*mf;
+	dma_addr_t		 dataDma;
+	u16			 req_idx;
+	u32			 frameOffset;
+	u32			 flagsLength;
+	int			 ii;
+
+	/* Get a MF for this command.
+	 */
+	if ((mf =3D mpt_get_msg_frame(ScsiDoneCtx, ioc->id)) =3D=3D NULL) {
+		dprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",
+					ioc->name));
+		return -EAGAIN;
+	}
+
+	ddvprintk((MYIOC_s_INFO_FMT "writeIOCPage4 (mf=3D%p, id=3D%d)\n",
+		ioc->name, mf, target_id));
+
+	/* Set the request and the data pointers.
+	 * Place data at end of MF.
+	 */
+	pReq =3D (Config_t *)mf;
+
+	req_idx =3D le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
+	frameOffset =3D ioc->req_sz - sizeof(IOCPage4_t);
+
+	/* Complete the request frame (same for all requests).
+	 */
+	pReq->Action =3D MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	pReq->Reserved =3D 0;
+	pReq->ChainOffset =3D 0;
+	pReq->Function =3D MPI_FUNCTION_CONFIG;
+	pReq->Reserved1[0] =3D 0;
+	pReq->Reserved1[1] =3D 0;
+	pReq->Reserved1[2] =3D 0;
+	pReq->MsgFlags =3D 0;
+	for (ii=3D0; ii < 8; ii++) {
+		pReq->Reserved2[ii] =3D 0;
+	}
+
+       	IOCPage4Ptr =3D ioc->spi_data.pIocPg4;
+       	dataDma =3D ioc->spi_data.IocPg4_dma;
+       	ii =3D IOCPage4Ptr->ActiveSEP++;
+       	IOCPage4Ptr->SEP[ii].SEPTargetID =3D target_id;
+       	IOCPage4Ptr->SEP[ii].SEPBus =3D bus;
+       	pReq->Header =3D IOCPage4Ptr->Header;
+	pReq->PageAddress =3D cpu_to_le32(target_id | (bus << 8 ));
+
+	/* Add a SGE to the config request.
+	 */
+	flagsLength =3D MPT_SGE_FLAGS_SSIMPLE_WRITE |=20
+		(IOCPage4Ptr->Header.PageLength + ii) * 4;
+
+	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
+
+	dsprintk((MYIOC_s_INFO_FMT
+		"writeIOCPage4: pgaddr 0x%x\n",
+			ioc->name, (target_id | (bus<<8))));
+
+	mptscsih_put_msgframe(ScsiDoneCtx, ioc->id, mf);
+
+	return 0;
+}
+
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
 /*	mptscsih_taskmgmt_timeout - Call back for timeout on a
  *	task management request.
  *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long
@@ -6138,7 +6232,7 @@
 mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int portnum)
 {
 	MPT_ADAPTER		*ioc=3D hd->ioc;
-	VirtDevice		*pTarget =3D NULL;
+	VirtDevice		*pTarget;
 	SCSIDevicePage1_t	*pcfg1Data =3D NULL;
 	INTERNAL_CMD		 iocmd;
 	CONFIGPARMS		 cfg;
@@ -6146,7 +6240,8 @@
 	ConfigPageHeader_t	 header1;
 	int			 bus =3D 0;
 	int			 id =3D 0;
-	int			 lun =3D 0;
+	int			 lun;
+	int			 indexed_lun, lun_index;
 	int			 hostId =3D ioc->pfacts[portnum].PortSCSIID;
 	int			 max_id;
 	int			 requested, configuration, data;
@@ -6237,12 +6332,13 @@
=20
 		/* If target Ptr NULL or if this target is NOT a disk, skip.
 		 */
-	//	if (pTarget && ((pTarget->inq_data[0] & 0x1F) =3D=3D 0)) {
 		if ((pTarget) && (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)){
 			for (lun=3D0; lun <=3D MPT_LAST_LUN; lun++) {
 				/* If LUN present, issue the command
 				 */
-				if (pTarget->luns & (1<<lun)) {
+				lun_index =3D (lun >> 5);  /* 32 luns per lun_index */
+				indexed_lun =3D (lun % 32);
+				if (pTarget->luns[lun_index] & (1<<indexed_lun)) {
 					iocmd.lun =3D lun;
 					(void) mptscsih_do_cmd(hd, &iocmd);
 				}
@@ -6283,8 +6379,8 @@
 static void
 mptscsih_domainValidation(void *arg)
 {
-	MPT_SCSI_HOST		*hd =3D NULL;
-	MPT_ADAPTER		*ioc =3D NULL;
+	MPT_SCSI_HOST		*hd;
+	MPT_ADAPTER		*ioc;
 	unsigned long		 flags;
 	int 			 id, maxid, dvStatus, did;
 	int			 ii, isPhysDisk;
@@ -6441,7 +6537,7 @@
  */
 static void mptscsih_qas_check(MPT_SCSI_HOST *hd, int id)
 {
-	VirtDevice *pTarget =3D NULL;
+	VirtDevice *pTarget;
 	int ii;
=20
 	if (hd->Targets =3D=3D NULL)
@@ -6495,12 +6591,12 @@
 mptscsih_doDv(MPT_SCSI_HOST *hd, int bus_number, int id)
 {
 	MPT_ADAPTER		*ioc =3D hd->ioc;
-	VirtDevice		*pTarget =3D NULL;
-	SCSIDevicePage1_t	*pcfg1Data =3D NULL;
-	SCSIDevicePage0_t	*pcfg0Data =3D NULL;
-	u8			*pbuf1 =3D NULL;
-	u8			*pbuf2 =3D NULL;
-	u8			*pDvBuf =3D NULL;
+	VirtDevice		*pTarget;
+	SCSIDevicePage1_t	*pcfg1Data;
+	SCSIDevicePage0_t	*pcfg0Data;
+	u8			*pbuf1;
+	u8			*pbuf2;
+	u8			*pDvBuf;
 	dma_addr_t		 dvbuf_dma =3D -1;
 	dma_addr_t		 buf1_dma =3D -1;
 	dma_addr_t		 buf2_dma =3D -1;
@@ -6653,7 +6749,8 @@
 			if (nfactor < pspi_data->minSyncFactor )
 				nfactor =3D pspi_data->minSyncFactor;
 =09
-			if (!(pspi_data->nvram[id] & MPT_NVRAM_ID_SCAN_ENABLE)) {
+			if (!(pspi_data->nvram[id] & MPT_NVRAM_ID_SCAN_ENABLE) ||
+				(pspi_data->PortFlags =3D=3D MPI_SCSIPORTPAGE2_PORT_FLAGS_OFF_DV) =
) {
 =09
 				ddvprintk((MYIOC_s_NOTE_FMT "DV Skipped: bus, id, lun (%d, %d, =
%d)\n",
 					ioc->name, bus, id, lun));
@@ -6921,6 +7018,9 @@
 	if (inq0 !=3D 0)
 		goto target_done;
=20
+	if ( ioc->spi_data.PortFlags =3D=3D =
MPI_SCSIPORTPAGE2_PORT_FLAGS_BASIC_DV_ONLY )
+		goto target_done;
+
 	/* Start the Enhanced Test.
 	 * 0) issue TUR to clear out check conditions
 	 * 1) read capacity of echo (regular) buffer
@@ -7377,9 +7477,9 @@
 static void
 mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage)
 {
-	VirtDevice		*pTarget =3D NULL;
-	SCSIDevicePage0_t	*pPage0 =3D NULL;
-	SCSIDevicePage1_t	*pPage1 =3D NULL;
+	VirtDevice		*pTarget;
+	SCSIDevicePage0_t	*pPage0;
+	SCSIDevicePage1_t	*pPage1;
 	int			val =3D 0, data, configuration;
 	u8			width =3D 0;
 	u8			offset =3D 0;
@@ -7762,9 +7862,9 @@
 /* Commandline Parsing routines and defines.
  *
  * insmod format:
- *	insmod mptscsih mptscsih=3D"width:1 dv:n factor:0x09"
+ *	insmod mptscsih mptscsih=3D"width:1 dv:n factor:0x09 saf-te:1"
  *  boot format:
- *	mptscsih=3Dwidth:1,dv:n,factor:0x8
+ *	mptscsih=3Dwidth:1,dv:n,factor:0x8,saf-te:1
  *
  */
 #ifdef MODULE
@@ -7777,11 +7877,13 @@
 	"dv:"
 	"width:"
 	"factor:"
-       ;	/* DONNOT REMOVE THIS ';' */
+	"saf-te:"
+       ;	/* DO NOT REMOVE THIS ';' */
=20
 #define OPT_DV			1
 #define OPT_MAX_WIDTH		2
 #define OPT_MIN_SYNC_FACTOR	3
+#define OPT_SAF_TE		4
=20
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
*/
 static int
@@ -7838,6 +7940,10 @@
 			driver_setup.min_sync_fac =3D val;
 			break;
=20
+		case OPT_SAF_TE:
+			driver_setup.saf_te =3D val;
+			break;
+
 		default:
 			printk("mptscsih_setup: unexpected boot option '%.*s' ignored\n", =
(int)(pc-cur+1), cur);
 			break;
diff -Nuar linux/drivers/message/fusion/mptscsih.h =
11/drivers/message/fusion/mptscsih.h
--- linux/drivers/message/fusion/mptscsih.h	2004-01-09 =
16:35:24.000000000 +0100
+++ 11/drivers/message/fusion/mptscsih.h	2003-09-03 14:58:08.000000000 =
+0200
@@ -18,7 +18,7 @@
  *  Copyright (c) 1999-2002 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptscsih.h,v 1.1.2.2 2003/05/07 14:08:35 pdelaney Exp $
  */
@@ -116,12 +116,14 @@
 #define MPTSCSIH_DOMAIN_VALIDATION      1
 #define MPTSCSIH_MAX_WIDTH              1
 #define MPTSCSIH_MIN_SYNC               0x08
+#define MPTSCSIH_SAF_TE                 0
=20
 struct mptscsih_driver_setup
 {
         u8      dv;
         u8      max_width;
         u8      min_sync_fac;
+        u8      saf_te;
 };
=20
=20
@@ -130,6 +132,7 @@
         MPTSCSIH_DOMAIN_VALIDATION,             \
         MPTSCSIH_MAX_WIDTH,                     \
         MPTSCSIH_MIN_SYNC,                      \
+        MPTSCSIH_SAF_TE,                        \
 }
=20
=20
diff -Nuar linux/drivers/message/fusion/scsi3.h =
11/drivers/message/fusion/scsi3.h
--- linux/drivers/message/fusion/scsi3.h	2004-01-09 16:35:24.000000000 =
+0100
+++ 11/drivers/message/fusion/scsi3.h	2003-09-03 14:58:08.000000000 =
+0200
@@ -7,7 +7,7 @@
  *  Copyright (c) 1996-2002 Steven J. Ralston
  *  Written By: Steven J. Ralston (19960517)
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:lstephens@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: scsi3.h,v 1.9 2002/02/27 18:45:02 sralston Exp $
  */

------_=_NextPart_000_01C3D70A.D5BF6180--
