From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 2/6] mpt fusion: new mpi headers version 1.5.16
Date: Wed, 13 Jun 2007 16:32:20 -0600
Message-ID: <20070613223220.GA21055@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35575 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851AbXFMWge (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:36:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, DL-MPTFusionLinux@lsi.com

mpi header update

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/lsi/mpi.h a/drivers/message/fusion/lsi/mpi.h
--- b/drivers/message/fusion/lsi/mpi.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi.h	2007-06-12 15:29:07.000000000 -0600
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2006 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Logic Corporation.
  *
  *
  *           Name:  mpi.h
  *          Title:  MPI Message independent structures and definitions
  *  Creation Date:  July 27, 2000
  *
- *    mpi.h Version:  01.05.12
+ *    mpi.h Version:  01.05.13
  *
  *  Version History
  *  ---------------
@@ -78,6 +78,7 @@
  *  08-30-05  01.05.10  Added 2 new IOCStatus codes for Target.
  *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
  *  10-11-06  01.05.12  Bumped MPI_HEADER_VERSION_UNIT.
+ *  05-24-07  01.05.13  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
  */
 
@@ -108,7 +109,7 @@
 /* Note: The major versions of 0xe0 through 0xff are reserved */
 
 /* versioning for this MPI header set */
-#define MPI_HEADER_VERSION_UNIT             (0x0E)
+#define MPI_HEADER_VERSION_UNIT             (0x10)
 #define MPI_HEADER_VERSION_DEV              (0x00)
 #define MPI_HEADER_VERSION_UNIT_MASK        (0xFF00)
 #define MPI_HEADER_VERSION_UNIT_SHIFT       (8)
diff -uarpN b/drivers/message/fusion/lsi/mpi_cnfg.h a/drivers/message/fusion/lsi/mpi_cnfg.h
--- b/drivers/message/fusion/lsi/mpi_cnfg.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_cnfg.h	2007-06-12 15:29:07.000000000 -0600
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2006 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_cnfg.h
  *          Title:  MPI Config message, structures, and Pages
  *  Creation Date:  July 27, 2000
  *
- *    mpi_cnfg.h Version:  01.05.13
+ *    mpi_cnfg.h Version:  01.05.15
  *
  *  Version History
  *  ---------------
@@ -293,6 +293,21 @@
  *                      Added more AccessStatus values for SAS Device Page 0.
  *                      Added bit for SATA Asynchronous Notification Support in
  *                      Flags field of SAS Device Page 0.
+ *  02-28-07  01.05.14  Added ExtFlags field to Manufacturing Page 4.
+ *                      Added Disable SMART Polling for CapabilitiesFlags of
+ *                      IOC Page 6.
+ *                      Added Disable SMART Polling to DeviceSettings of BIOS
+ *                      Page 1.
+ *                      Added Multi-Port Domain bit for DiscoveryStatus field
+ *                      of SAS IO Unit Page.
+ *                      Added Multi-Port Domain Illegal flag for SAS IO Unit
+ *                      Page 1 AdditionalControlFlags field.
+ *  05-24-07  01.05.15  Added Hide Physical Disks with Non-Integrated RAID
+ *                      Metadata bit to Manufacturing Page 4 ExtFlags field.
+ *                      Added Internal Connector to End Device Present bit to
+ *                      Expander Page 0 Flags field.
+ *                      Fixed define for
+ *                      MPI_SAS_EXPANDER1_DISCINFO_BAD_PHY_DISABLED.
  *  --------------------------------------------------------------------------
  */
 
@@ -639,7 +654,7 @@ typedef struct _CONFIG_PAGE_MANUFACTURIN
     U8                              InfoSize1;          /* 0Bh */
     U8                              InquirySize;        /* 0Ch */
     U8                              Flags;              /* 0Dh */
-    U16                             Reserved2;          /* 0Eh */
+    U16                             ExtFlags;           /* 0Eh */
     U8                              InquiryData[56];    /* 10h */
     U32                             ISVolumeSettings;   /* 48h */
     U32                             IMEVolumeSettings;  /* 4Ch */
@@ -658,7 +673,7 @@ typedef struct _CONFIG_PAGE_MANUFACTURIN
 } CONFIG_PAGE_MANUFACTURING_4, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_4,
   ManufacturingPage4_t, MPI_POINTER pManufacturingPage4_t;
 
-#define MPI_MANUFACTURING4_PAGEVERSION                  (0x04)
+#define MPI_MANUFACTURING4_PAGEVERSION                  (0x05)
 
 /* defines for the Flags field */
 #define MPI_MANPAGE4_FORCE_BAD_BLOCK_TABLE              (0x80)
@@ -670,6 +685,12 @@ typedef struct _CONFIG_PAGE_MANUFACTURIN
 #define MPI_MANPAGE4_IM_RESYNC_CACHE_ENABLE             (0x02)
 #define MPI_MANPAGE4_IR_NO_MIX_SAS_SATA                 (0x01)
 
+/* defines for the ExtFlags field */
+#define MPI_MANPAGE4_EXTFLAGS_HIDE_NON_IR_METADATA      (0x0008)
+#define MPI_MANPAGE4_EXTFLAGS_SAS_CACHE_DISABLE         (0x0004)
+#define MPI_MANPAGE4_EXTFLAGS_SATA_CACHE_DISABLE        (0x0002)
+#define MPI_MANPAGE4_EXTFLAGS_LEGACY_MODE               (0x0001)
+
 
 #ifndef MPI_MANPAGE5_NUM_FORCEWWID
 #define MPI_MANPAGE5_NUM_FORCEWWID      (1)
@@ -781,7 +802,7 @@ typedef struct _CONFIG_PAGE_MANUFACTURIN
 } CONFIG_PAGE_MANUFACTURING_9, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_9,
   ManufacturingPage9_t, MPI_POINTER pManufacturingPage9_t;
 
-#define MPI_MANUFACTURING6_PAGEVERSION                  (0x00)
+#define MPI_MANUFACTURING9_PAGEVERSION                  (0x00)
 
 
 typedef struct _CONFIG_PAGE_MANUFACTURING_10
@@ -1138,6 +1159,8 @@ typedef struct _CONFIG_PAGE_IOC_6
 
 /* IOC Page 6 Capabilities Flags */
 
+#define MPI_IOCPAGE6_CAP_FLAGS_DISABLE_SMART_POLLING    (0x00000008)
+
 #define MPI_IOCPAGE6_CAP_FLAGS_MASK_METADATA_SIZE       (0x00000006)
 #define MPI_IOCPAGE6_CAP_FLAGS_64MB_METADATA_SIZE       (0x00000000)
 #define MPI_IOCPAGE6_CAP_FLAGS_512MB_METADATA_SIZE      (0x00000002)
@@ -1208,6 +1231,7 @@ typedef struct _CONFIG_PAGE_BIOS_1
 #define MPI_BIOSPAGE1_IOCSET_ALTERNATE_CHS              (0x00000008)
 
 /* values for the DeviceSettings field */
+#define MPI_BIOSPAGE1_DEVSET_DISABLE_SMART_POLLING      (0x00000010)
 #define MPI_BIOSPAGE1_DEVSET_DISABLE_SEQ_LUN            (0x00000008)
 #define MPI_BIOSPAGE1_DEVSET_DISABLE_RM_LUN             (0x00000004)
 #define MPI_BIOSPAGE1_DEVSET_DISABLE_NON_RM_LUN         (0x00000002)
@@ -2281,11 +2305,11 @@ typedef struct _CONFIG_PAGE_RAID_VOL_0
 typedef struct _CONFIG_PAGE_RAID_VOL_1
 {
     CONFIG_PAGE_HEADER      Header;         /* 00h */
-    U8                      VolumeID;       /* 01h */
-    U8                      VolumeBus;      /* 02h */
-    U8                      VolumeIOC;      /* 03h */
-    U8                      Reserved0;      /* 04h */
-    U8                      GUID[24];       /* 05h */
+    U8                      VolumeID;       /* 04h */
+    U8                      VolumeBus;      /* 05h */
+    U8                      VolumeIOC;      /* 06h */
+    U8                      Reserved0;      /* 07h */
+    U8                      GUID[24];       /* 08h */
     U8                      Name[32];       /* 20h */
     U64                     WWID;           /* 40h */
     U32                     Reserved1;      /* 48h */
@@ -2340,7 +2364,7 @@ typedef struct _RAID_PHYS_DISK0_STATUS
 } RAID_PHYS_DISK0_STATUS, MPI_POINTER PTR_RAID_PHYS_DISK0_STATUS,
   RaidPhysDiskStatus_t, MPI_POINTER pRaidPhysDiskStatus_t;
 
-/* RAID Volume 2 IM Physical Disk DiskStatus flags */
+/* RAID Physical Disk PhysDiskStatus flags */
 
 #define MPI_PHYSDISK0_STATUS_FLAG_OUT_OF_SYNC           (0x01)
 #define MPI_PHYSDISK0_STATUS_FLAG_QUIESCED              (0x02)
@@ -2544,6 +2568,7 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_
 #define MPI_SAS_IOUNIT0_DS_TABLE_LINK                       (0x00000400)
 #define MPI_SAS_IOUNIT0_DS_UNSUPPORTED_DEVICE               (0x00000800)
 #define MPI_SAS_IOUNIT0_DS_MAX_SATA_TARGETS                 (0x00001000)
+#define MPI_SAS_IOUNIT0_DS_MULTI_PORT_DOMAIN                (0x00002000)
 
 
 typedef struct _MPI_SAS_IO_UNIT1_PHY_DATA
@@ -2607,6 +2632,7 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_
 #define MPI_SAS_IOUNIT1_CONTROL_CLEAR_AFFILIATION           (0x0001)
 
 /* values for SAS IO Unit Page 1 AdditionalControlFlags */
+#define MPI_SAS_IOUNIT1_ACONTROL_MULTI_PORT_DOMAIN_ILLEGAL          (0x0080)
 #define MPI_SAS_IOUNIT1_ACONTROL_SATA_ASYNCHROUNOUS_NOTIFICATION    (0x0040)
 #define MPI_SAS_IOUNIT1_ACONTROL_HIDE_NONZERO_ATTACHED_PHY_IDENT    (0x0020)
 #define MPI_SAS_IOUNIT1_ACONTROL_PORT_ENABLE_ONLY_SATA_LINK_RESET   (0x0010)
@@ -2734,6 +2760,7 @@ typedef struct _CONFIG_PAGE_SAS_EXPANDER
 #define MPI_SAS_EXPANDER0_DS_UNSUPPORTED_DEVICE         (0x00000800)
 
 /* values for SAS Expander Page 0 Flags field */
+#define MPI_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE    (0x04)
 #define MPI_SAS_EXPANDER0_FLAGS_ROUTE_TABLE_CONFIG      (0x02)
 #define MPI_SAS_EXPANDER0_FLAGS_CONFIG_IN_PROGRESS      (0x01)
 
@@ -2774,7 +2801,7 @@ typedef struct _CONFIG_PAGE_SAS_EXPANDER
 /* see mpi_sas.h for values for SAS Expander Page 1 AttachedDeviceInfo values */
 
 /* values for SAS Expander Page 1 DiscoveryInfo field */
-#define MPI_SAS_EXPANDER1_DISCINFO_BAD_PHY DISABLED     (0x04)
+#define MPI_SAS_EXPANDER1_DISCINFO_BAD_PHY_DISABLED     (0x04)
 #define MPI_SAS_EXPANDER1_DISCINFO_LINK_STATUS_CHANGE   (0x02)
 #define MPI_SAS_EXPANDER1_DISCINFO_NO_ROUTING_ENTRIES   (0x01)
 
@@ -2895,11 +2922,11 @@ typedef struct _CONFIG_PAGE_SAS_PHY_0
     U8                                  AttachedPhyIdentifier;  /* 16h */
     U8                                  Reserved2;              /* 17h */
     U32                                 AttachedDeviceInfo;     /* 18h */
-    U8                                  ProgrammedLinkRate;     /* 20h */
-    U8                                  HwLinkRate;             /* 21h */
-    U8                                  ChangeCount;            /* 22h */
-    U8                                  Flags;                  /* 23h */
-    U32                                 PhyInfo;                /* 24h */
+    U8                                  ProgrammedLinkRate;     /* 1Ch */
+    U8                                  HwLinkRate;             /* 1Dh */
+    U8                                  ChangeCount;            /* 1Eh */
+    U8                                  Flags;                  /* 1Fh */
+    U32                                 PhyInfo;                /* 20h */
 } CONFIG_PAGE_SAS_PHY_0, MPI_POINTER PTR_CONFIG_PAGE_SAS_PHY_0,
   SasPhyPage0_t, MPI_POINTER pSasPhyPage0_t;
 
diff -uarpN b/drivers/message/fusion/lsi/mpi_history.txt a/drivers/message/fusion/lsi/mpi_history.txt
--- b/drivers/message/fusion/lsi/mpi_history.txt	2007-06-12 12:21:57.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_history.txt	2007-06-12 15:29:07.000000000 -0600
@@ -3,28 +3,28 @@
  MPI Header File Change History
  ==============================
 
- Copyright (c) 2000-2006 LSI Logic Corporation.
+ Copyright (c) 2000-2007 LSI Logic Corporation.
 
  ---------------------------------------
- Header Set Release Version:    01.05.14
- Header Set Release Date:       10-11-06
+ Header Set Release Version:    01.05.16
+ Header Set Release Date:       05-24-07
  ---------------------------------------
 
  Filename               Current version     Prior version
  ----------             ---------------     -------------
- mpi.h                  01.05.12            01.05.11
- mpi_ioc.h              01.05.12            01.05.11
- mpi_cnfg.h             01.05.13            01.05.12
- mpi_init.h             01.05.08            01.05.07
+ mpi.h                  01.05.13            01.05.12
+ mpi_ioc.h              01.05.14            01.05.13
+ mpi_cnfg.h             01.05.15            01.05.14
+ mpi_init.h             01.05.09            01.05.09
  mpi_targ.h             01.05.06            01.05.06
  mpi_fc.h               01.05.01            01.05.01
  mpi_lan.h              01.05.01            01.05.01
- mpi_raid.h             01.05.02            01.05.02
+ mpi_raid.h             01.05.03            01.05.03
  mpi_tool.h             01.05.03            01.05.03
  mpi_inb.h              01.05.01            01.05.01
- mpi_sas.h              01.05.04            01.05.03
+ mpi_sas.h              01.05.04            01.05.04
  mpi_type.h             01.05.02            01.05.02
- mpi_history.txt        01.05.14            01.05.13
+ mpi_history.txt        01.05.14            01.05.14
 
 
  *  Date      Version   Description
@@ -95,6 +95,7 @@ mpi.h
  *  08-30-05  01.05.10  Added 2 new IOCStatus codes for Target.
  *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
  *  10-11-06  01.05.12  Bumped MPI_HEADER_VERSION_UNIT.
+ *  05-24-07  01.05.13  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
 
 mpi_ioc.h
@@ -191,6 +192,13 @@ mpi_ioc.h
  *                      data structure.
  *                      Added new ImageType values for FWDownload and FWUpload
  *                      requests.
+ *  02-28-07  01.05.13  Added MPI_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT for SAS
+ *                      Broadcast Event Data (replacing _RESERVED2).
+ *                      For Discovery Error Event Data DiscoveryStatus field,
+ *                      replaced _MULTPL_PATHS with _UNSUPPORTED_DEVICE and
+ *                      added _MULTI_PORT_DOMAIN.
+ *  05-24-07  01.05.14  Added Common Boot Block type to FWDownload Request.
+ *                      Added Common Boot Block type to FWUpload Request.
  *  --------------------------------------------------------------------------
 
 mpi_cnfg.h
@@ -473,6 +481,21 @@ mpi_cnfg.h
  *                      Added more AccessStatus values for SAS Device Page 0.
  *                      Added bit for SATA Asynchronous Notification Support in
  *                      Flags field of SAS Device Page 0.
+ *  02-28-07  01.05.14  Added ExtFlags field to Manufacturing Page 4.
+ *                      Added Disable SMART Polling for CapabilitiesFlags of
+ *                      IOC Page 6.
+ *                      Added Disable SMART Polling to DeviceSettings of BIOS
+ *                      Page 1.
+ *                      Added Multi-Port Domain bit for DiscoveryStatus field
+ *                      of SAS IO Unit Page.
+ *                      Added Multi-Port Domain Illegal flag for SAS IO Unit
+ *                      Page 1 AdditionalControlFlags field.
+ *  05-24-07  01.05.15  Added Hide Physical Disks with Non-Integrated RAID
+ *                      Metadata bit to Manufacturing Page 4 ExtFlags field.
+ *                      Added Internal Connector to End Device Present bit to
+ *                      Expander Page 0 Flags field.
+ *                      Fixed define for
+ *                      MPI_SAS_EXPANDER1_DISCINFO_BAD_PHY_DISABLED.
  *  --------------------------------------------------------------------------
 
 mpi_init.h
@@ -517,6 +540,8 @@ mpi_init.h
  *                      unique in the first 32 characters.
  *  03-27-06  01.05.07  Added Task Management type of Clear ACA.
  *  10-11-06  01.05.08  Shortened define for Task Management type of Clear ACA.
+ *  02-28-07  01.05.09  Defined two new MsgFlags bits for SCSI Task Management
+ *                      Request: Do Not Send Task IU and Soft Reset Option.
  *  --------------------------------------------------------------------------
 
 mpi_targ.h
@@ -571,7 +596,7 @@ mpi_fc.h
  *  11-02-00  01.01.01  Original release for post 1.0 work
  *  12-04-00  01.01.02  Added messages for Common Transport Send and
  *                      Primitive Send.
- *  01-09-01  01.01.03  Modified some of the new flags to have an MPI prefix
+ *  01-09-01  01.01.03  Modifed some of the new flags to have an MPI prefix
  *                      and modified the FcPrimitiveSend flags.
  *  01-25-01  01.01.04  Move InitiatorIndex in LinkServiceRsp reply to a larger
  *                      field.
@@ -634,6 +659,8 @@ mpi_raid.h
  *  08-19-04  01.05.01  Original release for MPI v1.5.
  *  01-15-05  01.05.02  Added defines for the two new RAID Actions for
  *                      _SET_RESYNC_RATE and _SET_DATA_SCRUB_RATE.
+ *  02-28-07  01.05.03  Added new RAID Action, Device FW Update Mode, and
+ *                      associated defines.
  *  --------------------------------------------------------------------------
 
 mpi_tool.h
@@ -682,7 +709,22 @@ mpi_type.h
 
 mpi_history.txt         Parts list history
 
-Filename    01.05.13   01.05.13   01.05.12   01.05.11   01.05.10   01.05.09
+Filename    01.05.15   01.05.15
+----------  --------   --------
+mpi.h       01.05.12   01.05.13
+mpi_ioc.h   01.05.13   01.05.14
+mpi_cnfg.h  01.05.14   01.05.15
+mpi_init.h  01.05.09   01.05.09
+mpi_targ.h  01.05.06   01.05.06
+mpi_fc.h    01.05.01   01.05.01
+mpi_lan.h   01.05.01   01.05.01
+mpi_raid.h  01.05.03   01.05.03
+mpi_tool.h  01.05.03   01.05.03
+mpi_inb.h   01.05.01   01.05.01
+mpi_sas.h   01.05.04   01.05.04
+mpi_type.h  01.05.02   01.05.02
+
+Filename    01.05.14   01.05.13   01.05.12   01.05.11   01.05.10   01.05.09
 ----------  --------   --------   --------   --------   --------   --------
 mpi.h       01.05.12   01.05.11   01.05.10   01.05.09   01.05.08   01.05.07
 mpi_ioc.h   01.05.12   01.05.11   01.05.10   01.05.09   01.05.09   01.05.08
diff -uarpN b/drivers/message/fusion/lsi/mpi_init.h a/drivers/message/fusion/lsi/mpi_init.h
--- b/drivers/message/fusion/lsi/mpi_init.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_init.h	2007-06-12 15:29:07.000000000 -0600
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2006 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_init.h
  *          Title:  MPI initiator mode messages and structures
  *  Creation Date:  June 8, 2000
  *
- *    mpi_init.h Version:  01.05.08
+ *    mpi_init.h Version:  01.05.09
  *
  *  Version History
  *  ---------------
@@ -54,6 +54,8 @@
  *                      unique in the first 32 characters.
  *  03-27-06  01.05.07  Added Task Management type of Clear ACA.
  *  10-11-06  01.05.08  Shortened define for Task Management type of Clear ACA.
+ *  02-28-07  01.05.09  Defined two new MsgFlags bits for SCSI Task Management
+ *                      Request: Do Not Send Task IU and Soft Reset Option.
  *  --------------------------------------------------------------------------
  */
 
@@ -432,10 +434,14 @@ typedef struct _MSG_SCSI_TASK_MGMT
 #define MPI_SCSITASKMGMT_TASKTYPE_CLR_ACA               (0x08)
 
 /* MsgFlags bits */
+#define MPI_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU   (0x01)
+
 #define MPI_SCSITASKMGMT_MSGFLAGS_TARGET_RESET_OPTION   (0x00)
 #define MPI_SCSITASKMGMT_MSGFLAGS_LIP_RESET_OPTION      (0x02)
 #define MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION (0x04)
 
+#define MPI_SCSITASKMGMT_MSGFLAGS_SOFT_RESET_OPTION     (0x08)
+
 /* SCSI Task Management Reply */
 typedef struct _MSG_SCSI_TASK_MGMT_REPLY
 {
diff -uarpN b/drivers/message/fusion/lsi/mpi_ioc.h a/drivers/message/fusion/lsi/mpi_ioc.h
--- b/drivers/message/fusion/lsi/mpi_ioc.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_ioc.h	2007-06-12 15:29:07.000000000 -0600
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2006 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_ioc.h
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  *  Creation Date:  August 11, 2000
  *
- *    mpi_ioc.h Version:  01.05.12
+ *    mpi_ioc.h Version:  01.05.14
  *
  *  Version History
  *  ---------------
@@ -106,6 +106,13 @@
  *                      data structure.
  *                      Added new ImageType values for FWDownload and FWUpload
  *                      requests.
+ *  02-28-07  01.05.13  Added MPI_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT for SAS
+ *                      Broadcast Event Data (replacing _RESERVED2).
+ *                      For Discovery Error Event Data DiscoveryStatus field,
+ *                      replaced _MULTPL_PATHS with _UNSUPPORTED_DEVICE and
+ *                      added _MULTI_PORT_DOMAIN.
+ *  05-24-07  01.05.14  Added Common Boot Block type to FWDownload Request.
+ *                      Added Common Boot Block type to FWUpload Request.
  *  --------------------------------------------------------------------------
  */
 
@@ -792,7 +799,7 @@ typedef struct _EVENT_DATA_SAS_BROADCAST
 
 #define MPI_EVENT_PRIMITIVE_CHANGE              (0x01)
 #define MPI_EVENT_PRIMITIVE_EXPANDER            (0x03)
-#define MPI_EVENT_PRIMITIVE_RESERVED2           (0x04)
+#define MPI_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT  (0x04)
 #define MPI_EVENT_PRIMITIVE_RESERVED3           (0x05)
 #define MPI_EVENT_PRIMITIVE_RESERVED4           (0x06)
 #define MPI_EVENT_PRIMITIVE_CHANGE0_RESERVED    (0x07)
@@ -857,8 +864,9 @@ typedef struct _EVENT_DATA_DISCOVERY_ERR
 #define MPI_EVENT_DSCVRY_ERR_DS_SMP_CRC_ERROR               (0x00000100)
 #define MPI_EVENT_DSCVRY_ERR_DS_MULTPL_SUBTRACTIVE          (0x00000200)
 #define MPI_EVENT_DSCVRY_ERR_DS_TABLE_TO_TABLE              (0x00000400)
-#define MPI_EVENT_DSCVRY_ERR_DS_MULTPL_PATHS                (0x00000800)
+#define MPI_EVENT_DSCVRY_ERR_DS_UNSUPPORTED_DEVICE          (0x00000800)
 #define MPI_EVENT_DSCVRY_ERR_DS_MAX_SATA_TARGETS            (0x00001000)
+#define MPI_EVENT_DSCVRY_ERR_DS_MULTI_PORT_DOMAIN           (0x00002000)
 
 /* SAS SMP Error Event data */
 
@@ -990,6 +998,7 @@ typedef struct _MSG_FW_DOWNLOAD
 #define MPI_FW_DOWNLOAD_ITYPE_CONFIG_1          (0x07)
 #define MPI_FW_DOWNLOAD_ITYPE_CONFIG_2          (0x08)
 #define MPI_FW_DOWNLOAD_ITYPE_MEGARAID          (0x09)
+#define MPI_FW_DOWNLOAD_ITYPE_COMMON_BOOT_BLOCK (0x0B)
 
 
 typedef struct _FWDownloadTCSGE
@@ -1038,17 +1047,18 @@ typedef struct _MSG_FW_UPLOAD
 } MSG_FW_UPLOAD, MPI_POINTER PTR_MSG_FW_UPLOAD,
   FWUpload_t, MPI_POINTER pFWUpload_t;
 
-#define MPI_FW_UPLOAD_ITYPE_FW_IOC_MEM      (0x00)
-#define MPI_FW_UPLOAD_ITYPE_FW_FLASH        (0x01)
-#define MPI_FW_UPLOAD_ITYPE_BIOS_FLASH      (0x02)
-#define MPI_FW_UPLOAD_ITYPE_NVDATA          (0x03)
-#define MPI_FW_UPLOAD_ITYPE_BOOTLOADER      (0x04)
-#define MPI_FW_UPLOAD_ITYPE_FW_BACKUP       (0x05)
-#define MPI_FW_UPLOAD_ITYPE_MANUFACTURING   (0x06)
-#define MPI_FW_UPLOAD_ITYPE_CONFIG_1        (0x07)
-#define MPI_FW_UPLOAD_ITYPE_CONFIG_2        (0x08)
-#define MPI_FW_UPLOAD_ITYPE_MEGARAID        (0x09)
-#define MPI_FW_UPLOAD_ITYPE_COMPLETE        (0x0A)
+#define MPI_FW_UPLOAD_ITYPE_FW_IOC_MEM          (0x00)
+#define MPI_FW_UPLOAD_ITYPE_FW_FLASH            (0x01)
+#define MPI_FW_UPLOAD_ITYPE_BIOS_FLASH          (0x02)
+#define MPI_FW_UPLOAD_ITYPE_NVDATA              (0x03)
+#define MPI_FW_UPLOAD_ITYPE_BOOTLOADER          (0x04)
+#define MPI_FW_UPLOAD_ITYPE_FW_BACKUP           (0x05)
+#define MPI_FW_UPLOAD_ITYPE_MANUFACTURING       (0x06)
+#define MPI_FW_UPLOAD_ITYPE_CONFIG_1            (0x07)
+#define MPI_FW_UPLOAD_ITYPE_CONFIG_2            (0x08)
+#define MPI_FW_UPLOAD_ITYPE_MEGARAID            (0x09)
+#define MPI_FW_UPLOAD_ITYPE_COMPLETE            (0x0A)
+#define MPI_FW_UPLOAD_ITYPE_COMMON_BOOT_BLOCK   (0x0B)
 
 typedef struct _FWUploadTCSGE
 {
diff -uarpN b/drivers/message/fusion/lsi/mpi_raid.h a/drivers/message/fusion/lsi/mpi_raid.h
--- b/drivers/message/fusion/lsi/mpi_raid.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_raid.h	2007-06-12 15:29:07.000000000 -0600
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2001-2005 LSI Logic Corporation.
+ *  Copyright (c) 2001-2007 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_raid.h
  *          Title:  MPI RAID message and structures
  *  Creation Date:  February 27, 2001
  *
- *    mpi_raid.h Version:  01.05.02
+ *    mpi_raid.h Version:  01.05.03
  *
  *  Version History
  *  ---------------
@@ -32,6 +32,8 @@
  *  08-19-04  01.05.01  Original release for MPI v1.5.
  *  01-15-05  01.05.02  Added defines for the two new RAID Actions for
  *                      _SET_RESYNC_RATE and _SET_DATA_SCRUB_RATE.
+ *  02-28-07  01.05.03  Added new RAID Action, Device FW Update Mode, and
+ *                      associated defines.
  *  --------------------------------------------------------------------------
  */
 
@@ -90,6 +92,7 @@ typedef struct _MSG_RAID_ACTION
 #define MPI_RAID_ACTION_INACTIVATE_VOLUME           (0x12)
 #define MPI_RAID_ACTION_SET_RESYNC_RATE             (0x13)
 #define MPI_RAID_ACTION_SET_DATA_SCRUB_RATE         (0x14)
+#define MPI_RAID_ACTION_DEVICE_FW_UPDATE_MODE       (0x15)
 
 /* ActionDataWord defines for use with MPI_RAID_ACTION_CREATE_VOLUME action */
 #define MPI_RAID_ACTION_ADATA_DO_NOT_SYNC           (0x00000001)
@@ -111,6 +114,10 @@ typedef struct _MSG_RAID_ACTION
 /* ActionDataWord defines for use with MPI_RAID_ACTION_SET_DATA_SCRUB_RATE action */
 #define MPI_RAID_ACTION_ADATA_DATA_SCRUB_RATE_MASK  (0x000000FF)
 
+/* ActionDataWord defines for use with MPI_RAID_ACTION_DEVICE_FW_UPDATE_MODE action */
+#define MPI_RAID_ACTION_ADATA_ENABLE_FW_UPDATE          (0x00000001)
+#define MPI_RAID_ACTION_ADATA_MASK_FW_UPDATE_TIMEOUT    (0x0000FF00)
+#define MPI_RAID_ACTION_ADATA_SHIFT_FW_UPDATE_TIMEOUT   (8)
 
 
 /* RAID Action reply message */
