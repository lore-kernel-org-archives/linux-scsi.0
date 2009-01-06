From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/5] mpt fusion: Update MPI Headers to version 01.05.19
Date: Tue, 6 Jan 2009 14:56:31 +0530
Message-ID: <20090106092618.GC13033@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:59049 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZAFKGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 05:06:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com, sathyap@lsi.com, James.Bottomley@HansenPartnership.com


This Patch is submitted to increment the MPI headers used by LSI MPT fusion
drivers to the latest version 01.05.19.
Year is changed in CopyRight.
---

Signed-off-by: Kashyap Desai <kadesai@lsi.com>
---
diff --git a/drivers/message/fusion/lsi/mpi.h b/drivers/message/fusion/lsi/mpi.h
index 10b6ef7..11c0f46 100644
--- a/drivers/message/fusion/lsi/mpi.h
+++ b/drivers/message/fusion/lsi/mpi.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Message independent structures and definitions
  *  Creation Date:  July 27, 2000
  *
- *    mpi.h Version:  01.05.13
+ *    mpi.h Version:  01.05.16
  *
  *  Version History
  *  ---------------
@@ -79,6 +79,9 @@
  *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
  *  10-11-06  01.05.12  Bumped MPI_HEADER_VERSION_UNIT.
  *  05-24-07  01.05.13  Bumped MPI_HEADER_VERSION_UNIT.
+ *  08-07-07  01.05.14  Bumped MPI_HEADER_VERSION_UNIT.
+ *  01-15-08  01.05.15  Bumped MPI_HEADER_VERSION_UNIT.
+ *  03-28-08  01.05.16  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
  */
 
@@ -109,7 +112,7 @@
 /* Note: The major versions of 0xe0 through 0xff are reserved */
 
 /* versioning for this MPI header set */
-#define MPI_HEADER_VERSION_UNIT             (0x10)
+#define MPI_HEADER_VERSION_UNIT             (0x13)
 #define MPI_HEADER_VERSION_DEV              (0x00)
 #define MPI_HEADER_VERSION_UNIT_MASK        (0xFF00)
 #define MPI_HEADER_VERSION_UNIT_SHIFT       (8)
diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index b2db333..013c7d8 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Config message, structures, and Pages
  *  Creation Date:  July 27, 2000
  *
- *    mpi_cnfg.h Version:  01.05.15
+ *    mpi_cnfg.h Version:  01.05.18
  *
  *  Version History
  *  ---------------
@@ -308,6 +308,20 @@
  *                      Expander Page 0 Flags field.
  *                      Fixed define for
  *                      MPI_SAS_EXPANDER1_DISCINFO_BAD_PHY_DISABLED.
+ *  08-07-07  01.05.16  Added MPI_IOCPAGE6_CAP_FLAGS_MULTIPORT_DRIVE_SUPPORT
+ *                      define.
+ *                      Added BIOS Page 4 structure.
+ *                      Added MPI_RAID_PHYS_DISK1_PATH_MAX define for RAID
+ *                      Physcial Disk Page 1.
+ *  01-15-07  01.05.17  Added additional bit defines for ExtFlags field of
+ *                      Manufacturing Page 4.
+ *                      Added Solid State Drives Supported bit to IOC Page 6
+ *                      Capabilities Flags.
+ *                      Added new value for AccessStatus field of SAS Device
+ *                      Page 0 (_SATA_NEEDS_INITIALIZATION).
+ *  03-28-08  01.05.18  Defined new bits in Manufacturing Page 4 ExtFlags field
+ *                      to control coercion size and the mixing of SAS and SATA
+ *                      SSD drives.
  *  --------------------------------------------------------------------------
  */
 
@@ -686,6 +700,14 @@ typedef struct _CONFIG_PAGE_MANUFACTURING_4
 #define MPI_MANPAGE4_IR_NO_MIX_SAS_SATA                 (0x01)
 
 /* defines for the ExtFlags field */
+#define MPI_MANPAGE4_EXTFLAGS_MASK_COERCION_SIZE        (0x0180)
+#define MPI_MANPAGE4_EXTFLAGS_SHIFT_COERCION_SIZE       (7)
+#define MPI_MANPAGE4_EXTFLAGS_1GB_COERCION_SIZE         (0)
+#define MPI_MANPAGE4_EXTFLAGS_128MB_COERCION_SIZE       (1)
+
+#define MPI_MANPAGE4_EXTFLAGS_NO_MIX_SSD_SAS_SATA       (0x0040)
+#define MPI_MANPAGE4_EXTFLAGS_MIX_SSD_AND_NON_SSD       (0x0020)
+#define MPI_MANPAGE4_EXTFLAGS_DUAL_PORT_SUPPORT         (0x0010)
 #define MPI_MANPAGE4_EXTFLAGS_HIDE_NON_IR_METADATA      (0x0008)
 #define MPI_MANPAGE4_EXTFLAGS_SAS_CACHE_DISABLE         (0x0004)
 #define MPI_MANPAGE4_EXTFLAGS_SATA_CACHE_DISABLE        (0x0002)
@@ -1159,6 +1181,8 @@ typedef struct _CONFIG_PAGE_IOC_6
 
 /* IOC Page 6 Capabilities Flags */
 
+#define MPI_IOCPAGE6_CAP_FLAGS_SSD_SUPPORT              (0x00000020)
+#define MPI_IOCPAGE6_CAP_FLAGS_MULTIPORT_DRIVE_SUPPORT  (0x00000010)
 #define MPI_IOCPAGE6_CAP_FLAGS_DISABLE_SMART_POLLING    (0x00000008)
 
 #define MPI_IOCPAGE6_CAP_FLAGS_MASK_METADATA_SIZE       (0x00000006)
@@ -1428,6 +1452,15 @@ typedef struct _CONFIG_PAGE_BIOS_2
 #define MPI_BIOSPAGE2_FORM_SAS_WWN                      (0x05)
 #define MPI_BIOSPAGE2_FORM_ENCLOSURE_SLOT               (0x06)
 
+typedef struct _CONFIG_PAGE_BIOS_4
+{
+    CONFIG_PAGE_HEADER      Header;                     /* 00h */
+    U64                     ReassignmentBaseWWID;       /* 04h */
+} CONFIG_PAGE_BIOS_4, MPI_POINTER PTR_CONFIG_PAGE_BIOS_4,
+  BIOSPage4_t, MPI_POINTER pBIOSPage4_t;
+
+#define MPI_BIOSPAGE4_PAGEVERSION                       (0x00)
+
 
 /****************************************************************************
 *   SCSI Port Config Pages
@@ -2419,6 +2452,15 @@ typedef struct _RAID_PHYS_DISK1_PATH
 #define MPI_RAID_PHYSDISK1_FLAG_BROKEN          (0x0002)
 #define MPI_RAID_PHYSDISK1_FLAG_INVALID         (0x0001)
 
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength or NumPhysDiskPaths at runtime.
+ */
+#ifndef MPI_RAID_PHYS_DISK1_PATH_MAX
+#define MPI_RAID_PHYS_DISK1_PATH_MAX    (1)
+#endif
+
 typedef struct _CONFIG_PAGE_RAID_PHYS_DISK_1
 {
     CONFIG_PAGE_HEADER              Header;             /* 00h */
@@ -2426,7 +2468,7 @@ typedef struct _CONFIG_PAGE_RAID_PHYS_DISK_1
     U8                              PhysDiskNum;        /* 05h */
     U16                             Reserved2;          /* 06h */
     U32                             Reserved1;          /* 08h */
-    RAID_PHYS_DISK1_PATH            Path[1];            /* 0Ch */
+    RAID_PHYS_DISK1_PATH            Path[MPI_RAID_PHYS_DISK1_PATH_MAX];/* 0Ch */
 } CONFIG_PAGE_RAID_PHYS_DISK_1, MPI_POINTER PTR_CONFIG_PAGE_RAID_PHYS_DISK_1,
   RaidPhysDiskPage1_t, MPI_POINTER pRaidPhysDiskPage1_t;
 
@@ -2844,6 +2886,7 @@ typedef struct _CONFIG_PAGE_SAS_DEVICE_0
 #define MPI_SAS_DEVICE0_ASTATUS_SATA_INIT_FAILED            (0x01)
 #define MPI_SAS_DEVICE0_ASTATUS_SATA_CAPABILITY_FAILED      (0x02)
 #define MPI_SAS_DEVICE0_ASTATUS_SATA_AFFILIATION_CONFLICT   (0x03)
+#define MPI_SAS_DEVICE0_ASTATUS_SATA_NEEDS_INITIALIZATION   (0x04)
 /* specific values for SATA Init failures */
 #define MPI_SAS_DEVICE0_ASTATUS_SIF_UNKNOWN                 (0x10)
 #define MPI_SAS_DEVICE0_ASTATUS_SIF_AFFILIATION_CONFLICT    (0x11)
diff --git a/drivers/message/fusion/lsi/mpi_fc.h b/drivers/message/fusion/lsi/mpi_fc.h
index 627acfb..7d663ce 100644
--- a/drivers/message/fusion/lsi/mpi_fc.h
+++ b/drivers/message/fusion/lsi/mpi_fc.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2004 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_fc.h
diff --git a/drivers/message/fusion/lsi/mpi_history.txt b/drivers/message/fusion/lsi/mpi_history.txt
index 3f15fcf..693e4b5 100644
--- a/drivers/message/fusion/lsi/mpi_history.txt
+++ b/drivers/message/fusion/lsi/mpi_history.txt
@@ -3,28 +3,28 @@
  MPI Header File Change History
  ==============================
 
- Copyright (c) 2000-2007 LSI Corporation.
+ Copyright (c) 2000-2008 LSI Corporation.
 
  ---------------------------------------
- Header Set Release Version:    01.05.16
- Header Set Release Date:       05-24-07
+ Header Set Release Version:    01.05.19
+ Header Set Release Date:       03-28-08
  ---------------------------------------
 
  Filename               Current version     Prior version
  ----------             ---------------     -------------
- mpi.h                  01.05.13            01.05.12
- mpi_ioc.h              01.05.14            01.05.13
- mpi_cnfg.h             01.05.15            01.05.14
+ mpi.h                  01.05.16            01.05.15
+ mpi_ioc.h              01.05.16            01.05.15
+ mpi_cnfg.h             01.05.18            01.05.17
  mpi_init.h             01.05.09            01.05.09
  mpi_targ.h             01.05.06            01.05.06
  mpi_fc.h               01.05.01            01.05.01
  mpi_lan.h              01.05.01            01.05.01
- mpi_raid.h             01.05.03            01.05.03
+ mpi_raid.h             01.05.05            01.05.05
  mpi_tool.h             01.05.03            01.05.03
  mpi_inb.h              01.05.01            01.05.01
- mpi_sas.h              01.05.04            01.05.04
+ mpi_sas.h              01.05.05            01.05.05
  mpi_type.h             01.05.02            01.05.02
- mpi_history.txt        01.05.14            01.05.14
+ mpi_history.txt        01.05.19            01.05.18
 
 
  *  Date      Version   Description
@@ -96,6 +96,9 @@ mpi.h
  *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
  *  10-11-06  01.05.12  Bumped MPI_HEADER_VERSION_UNIT.
  *  05-24-07  01.05.13  Bumped MPI_HEADER_VERSION_UNIT.
+ *  08-07-07  01.05.14  Bumped MPI_HEADER_VERSION_UNIT.
+ *  01-15-08  01.05.15  Bumped MPI_HEADER_VERSION_UNIT.
+ *  03-28-08  01.05.16  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
 
 mpi_ioc.h
@@ -127,7 +130,7 @@ mpi_ioc.h
  *  08-08-01  01.02.01  Original release for v1.2 work.
  *                      New format for FWVersion and ProductId in
  *                      MSG_IOC_FACTS_REPLY and MPI_FW_HEADER.
- *  08-31-01  01.02.02  Added event MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE and
+ *  08-31-01  01.02.02  Addded event MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE and
  *                      related structure and defines.
  *                      Added event MPI_EVENT_ON_BUS_TIMER_EXPIRED.
  *                      Added MPI_IOCINIT_FLAGS_DISCARD_FW_IMAGE.
@@ -187,7 +190,7 @@ mpi_ioc.h
  *  10-11-06  01.05.12  Added MPI_IOCFACTS_EXCEPT_METADATA_UNSUPPORTED.
  *                      Added MaxInitiators field to PortFacts reply.
  *                      Added SAS Device Status Change ReasonCode for
- *                      asynchronous notification.
+ *                      asynchronous notificaiton.
  *                      Added MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE and event
  *                      data structure.
  *                      Added new ImageType values for FWDownload and FWUpload
@@ -199,6 +202,16 @@ mpi_ioc.h
  *                      added _MULTI_PORT_DOMAIN.
  *  05-24-07  01.05.14  Added Common Boot Block type to FWDownload Request.
  *                      Added Common Boot Block type to FWUpload Request.
+ *  08-07-07  01.05.15  Added MPI_EVENT_SAS_INIT_RC_REMOVED define.
+ *                      Added MPI_EVENT_IR2_RC_DUAL_PORT_ADDED and
+ *                      MPI_EVENT_IR2_RC_DUAL_PORT_REMOVED for IR2 event data.
+ *                      Added SASAddress field to SAS Initiator Device Table
+ *                      Overflow event data structure.
+ *  03-28-08  01.05.16  Added two new ReasonCode values to SAS Device Status
+ *                      Change Event data to indicate completion of internally
+ *                      generated task management.
+ *                      Added MPI_EVENT_DSCVRY_ERR_DS_SATA_INIT_FAILURE define.
+ *                      Added MPI_EVENT_SAS_INIT_RC_INACCESSIBLE define.
  *  --------------------------------------------------------------------------
 
 mpi_cnfg.h
@@ -213,7 +226,7 @@ mpi_cnfg.h
  *                      Added _RESPONSE_ID_MASK definition to SCSI_PORT_1
  *                      page and updated the page version.
  *                      Added Information field and _INFO_PARAMS_NEGOTIATED
- *                      definition to SCSI_DEVICE_0 page.
+ *                      definitionto SCSI_DEVICE_0 page.
  *  06-22-00  01.00.03  Removed batch controls from LAN_0 page and updated the
  *                      page version.
  *                      Added BucketsRemaining to LAN_1 page, redefined the
@@ -496,6 +509,20 @@ mpi_cnfg.h
  *                      Expander Page 0 Flags field.
  *                      Fixed define for
  *                      MPI_SAS_EXPANDER1_DISCINFO_BAD_PHY_DISABLED.
+ *  08-07-07  01.05.16  Added MPI_IOCPAGE6_CAP_FLAGS_MULTIPORT_DRIVE_SUPPORT
+ *                      define.
+ *                      Added BIOS Page 4 structure.
+ *                      Added MPI_RAID_PHYS_DISK1_PATH_MAX define for RAID
+ *                      Physcial Disk Page 1.
+ *  01-15-07  01.05.17  Added additional bit defines for ExtFlags field of
+ *                      Manufacturing Page 4.
+ *                      Added Solid State Drives Supported bit to IOC Page 6
+ *                      Capabilities Flags.
+ *                      Added new value for AccessStatus field of SAS Device
+ *                      Page 0 (_SATA_NEEDS_INITIALIZATION).
+ *  03-28-08  01.05.18  Defined new bits in Manufacturing Page 4 ExtFlags field
+ *                      to control coercion size and the mixing of SAS and SATA
+ *                      SSD drives.
  *  --------------------------------------------------------------------------
 
 mpi_init.h
@@ -661,6 +688,9 @@ mpi_raid.h
  *                      _SET_RESYNC_RATE and _SET_DATA_SCRUB_RATE.
  *  02-28-07  01.05.03  Added new RAID Action, Device FW Update Mode, and
  *                      associated defines.
+ *  08-07-07  01.05.04  Added Disable Full Rebuild bit to the ActionDataWord
+ *                      for the RAID Action MPI_RAID_ACTION_DISABLE_VOLUME.
+ *  01-15-08  01.05.05  Added define for MPI_RAID_ACTION_SET_VOLUME_NAME.
  *  --------------------------------------------------------------------------
 
 mpi_tool.h
@@ -694,6 +724,10 @@ mpi_sas.h
  *                      reply.
  *  10-11-06  01.05.04  Fixed the name of a define for Operation field of SAS IO
  *                      Unit Control request.
+ *  01-15-08  01.05.05  Added support for MPI_SAS_OP_SET_IOC_PARAMETER,
+ *                      including adding IOCParameter and IOCParameter value
+ *                      fields to SAS IO Unit Control Request.
+ *                      Added MPI_SAS_DEVICE_INFO_PRODUCT_SPECIFIC define.
  *  --------------------------------------------------------------------------
 
 mpi_type.h
@@ -709,20 +743,20 @@ mpi_type.h
 
 mpi_history.txt         Parts list history
 
-Filename    01.05.15   01.05.15
-----------  --------   --------
-mpi.h       01.05.12   01.05.13
-mpi_ioc.h   01.05.13   01.05.14
-mpi_cnfg.h  01.05.14   01.05.15
-mpi_init.h  01.05.09   01.05.09
-mpi_targ.h  01.05.06   01.05.06
-mpi_fc.h    01.05.01   01.05.01
-mpi_lan.h   01.05.01   01.05.01
-mpi_raid.h  01.05.03   01.05.03
-mpi_tool.h  01.05.03   01.05.03
-mpi_inb.h   01.05.01   01.05.01
-mpi_sas.h   01.05.04   01.05.04
-mpi_type.h  01.05.02   01.05.02
+Filename    01.05.19   01.05.18   01.05.17   01.05.16   01.05.15
+----------  --------   --------   --------   --------   --------
+mpi.h       01.05.16   01.05.15   01.05.14   01.05.13   01.05.12
+mpi_ioc.h   01.05.16   01.05.15   01.05.15   01.05.14   01.05.13
+mpi_cnfg.h  01.05.18   01.05.17   01.05.16   01.05.15   01.05.14
+mpi_init.h  01.05.09   01.05.09   01.05.09   01.05.09   01.05.09
+mpi_targ.h  01.05.06   01.05.06   01.05.06   01.05.06   01.05.06
+mpi_fc.h    01.05.01   01.05.01   01.05.01   01.05.01   01.05.01
+mpi_lan.h   01.05.01   01.05.01   01.05.01   01.05.01   01.05.01
+mpi_raid.h  01.05.05   01.05.05   01.05.04   01.05.03   01.05.03
+mpi_tool.h  01.05.03   01.05.03   01.05.03   01.05.03   01.05.03
+mpi_inb.h   01.05.01   01.05.01   01.05.01   01.05.01   01.05.01
+mpi_sas.h   01.05.05   01.05.05   01.05.04   01.05.04   01.05.04
+mpi_type.h  01.05.02   01.05.02   01.05.02   01.05.02   01.05.02
 
 Filename    01.05.14   01.05.13   01.05.12   01.05.11   01.05.10   01.05.09
 ----------  --------   --------   --------   --------   --------   --------
diff --git a/drivers/message/fusion/lsi/mpi_init.h b/drivers/message/fusion/lsi/mpi_init.h
index a9e3693..4295d06 100644
--- a/drivers/message/fusion/lsi/mpi_init.h
+++ b/drivers/message/fusion/lsi/mpi_init.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2007 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_init.h
diff --git a/drivers/message/fusion/lsi/mpi_ioc.h b/drivers/message/fusion/lsi/mpi_ioc.h
index 5cbb6bd..8faa4fa 100644
--- a/drivers/message/fusion/lsi/mpi_ioc.h
+++ b/drivers/message/fusion/lsi/mpi_ioc.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2007 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_ioc.h
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  *  Creation Date:  August 11, 2000
  *
- *    mpi_ioc.h Version:  01.05.14
+ *    mpi_ioc.h Version:  01.05.16
  *
  *  Version History
  *  ---------------
@@ -113,6 +113,16 @@
  *                      added _MULTI_PORT_DOMAIN.
  *  05-24-07  01.05.14  Added Common Boot Block type to FWDownload Request.
  *                      Added Common Boot Block type to FWUpload Request.
+ *  08-07-07  01.05.15  Added MPI_EVENT_SAS_INIT_RC_REMOVED define.
+ *                      Added MPI_EVENT_IR2_RC_DUAL_PORT_ADDED and
+ *                      MPI_EVENT_IR2_RC_DUAL_PORT_REMOVED for IR2 event data.
+ *                      Added SASAddress field to SAS Initiator Device Table
+ *                      Overflow event data structure.
+ *  03-28-08  01.05.16  Added two new ReasonCode values to SAS Device Status
+ *                      Change Event data to indicate completion of internally
+ *                      generated task management.
+ *                      Added MPI_EVENT_DSCVRY_ERR_DS_SATA_INIT_FAILURE define.
+ *                      Added MPI_EVENT_SAS_INIT_RC_INACCESSIBLE define.
  *  --------------------------------------------------------------------------
  */
 
@@ -612,6 +622,8 @@ typedef struct _EVENT_DATA_SAS_DEVICE_STATUS_CHANGE
 #define MPI_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL   (0x0B)
 #define MPI_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL       (0x0C)
 #define MPI_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION        (0x0D)
+#define MPI_EVENT_SAS_DEV_STAT_RC_CMPL_INTERNAL_DEV_RESET   (0x0E)
+#define MPI_EVENT_SAS_DEV_STAT_RC_CMPL_TASK_ABORT_INTERNAL  (0x0F)
 
 
 /* SCSI Event data for Queue Full event */
@@ -708,6 +720,8 @@ typedef struct _MPI_EVENT_DATA_IR2
 #define MPI_EVENT_IR2_RC_PD_REMOVED                 (0x05)
 #define MPI_EVENT_IR2_RC_FOREIGN_CFG_DETECTED       (0x06)
 #define MPI_EVENT_IR2_RC_REBUILD_MEDIUM_ERROR       (0x07)
+#define MPI_EVENT_IR2_RC_DUAL_PORT_ADDED            (0x08)
+#define MPI_EVENT_IR2_RC_DUAL_PORT_REMOVED          (0x09)
 
 /* defines for logical disk states */
 #define MPI_LD_STATE_OPTIMAL                        (0x00)
@@ -867,6 +881,7 @@ typedef struct _EVENT_DATA_DISCOVERY_ERROR
 #define MPI_EVENT_DSCVRY_ERR_DS_UNSUPPORTED_DEVICE          (0x00000800)
 #define MPI_EVENT_DSCVRY_ERR_DS_MAX_SATA_TARGETS            (0x00001000)
 #define MPI_EVENT_DSCVRY_ERR_DS_MULTI_PORT_DOMAIN           (0x00002000)
+#define MPI_EVENT_DSCVRY_ERR_DS_SATA_INIT_FAILURE           (0x00004000)
 
 /* SAS SMP Error Event data */
 
@@ -902,6 +917,8 @@ typedef struct _EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE
 
 /* defines for the ReasonCode field of the SAS Initiator Device Status Change event */
 #define MPI_EVENT_SAS_INIT_RC_ADDED                 (0x01)
+#define MPI_EVENT_SAS_INIT_RC_REMOVED               (0x02)
+#define MPI_EVENT_SAS_INIT_RC_INACCESSIBLE          (0x03)
 
 /* SAS Initiator Device Table Overflow Event data */
 
@@ -910,6 +927,7 @@ typedef struct _EVENT_DATA_SAS_INIT_TABLE_OVERFLOW
     U8                      MaxInit;                    /* 00h */
     U8                      CurrentInit;                /* 01h */
     U16                     Reserved1;                  /* 02h */
+    U64                     SASAddress;                 /* 04h */
 } EVENT_DATA_SAS_INIT_TABLE_OVERFLOW,
   MPI_POINTER PTR_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW,
   MpiEventDataSasInitTableOverflow_t,
diff --git a/drivers/message/fusion/lsi/mpi_lan.h b/drivers/message/fusion/lsi/mpi_lan.h
index 03253b5..f41fcb6 100644
--- a/drivers/message/fusion/lsi/mpi_lan.h
+++ b/drivers/message/fusion/lsi/mpi_lan.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2004 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_lan.h
diff --git a/drivers/message/fusion/lsi/mpi_log_fc.h b/drivers/message/fusion/lsi/mpi_log_fc.h
index e4dafce..face6e7 100644
--- a/drivers/message/fusion/lsi/mpi_log_fc.h
+++ b/drivers/message/fusion/lsi/mpi_log_fc.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2001 LSI Corporation. All rights reserved.
+ *  Copyright (c) 2000-2008 LSI Corporation. All rights reserved.
  *
  *  NAME:           fc_log.h
  *  SUMMARY:        MPI IocLogInfo definitions for the SYMFC9xx chips
diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
index af9da03..691620d 100644
--- a/drivers/message/fusion/lsi/mpi_log_sas.h
+++ b/drivers/message/fusion/lsi/mpi_log_sas.h
@@ -1,6 +1,6 @@
 /***************************************************************************
  *                                                                         *
- *  Copyright 2003 LSI Corporation.  All rights reserved.            *
+ *  Copyright (c) 2000-2008 LSI Corporation.  All rights reserved.         *
  *                                                                         *
  * Description                                                             *
  * ------------                                                            *
@@ -73,6 +73,8 @@
 #define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_EXACT_IO          (0x00070004)
 #define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_EXACT_IO_REQ      (0x00070005)
 
+#define IOP_LOGINFO_CODE_LOG_TIMESTAMP_EVENT                 (0x00080000)
+
 /****************************************************************************/
 /* PL LOGINFO_CODE defines, valid if IOC_LOGINFO_ORIGINATOR = PL            */
 /****************************************************************************/
@@ -92,7 +94,7 @@
 #define PL_LOGINFO_SUB_CODE_OPEN_FAIL_OPEN_TIMEOUT_EXP       (0x0000000C)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAIL_UNUSED_0D              (0x0000000D)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAIL_DVTBLE_ACCSS_FAIL      (0x0000000E)
-#define PL_LOGINFO_SUB CODE_OPEN_FAIL_BAD_DEST               (0x00000011)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_BAD_DEST               (0x00000011)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RATE_NOT_SUPP          (0x00000012)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAIL_PROT_NOT_SUPP          (0x00000013)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RESERVED_ABANDON0      (0x00000014)
@@ -159,10 +161,11 @@
 
 #define PL_LOGINFO_SUB_CODE_INVALID_SGL                      (0x00000200)
 #define PL_LOGINFO_SUB_CODE_WRONG_REL_OFF_OR_FRAME_LENGTH    (0x00000300)
-#define PL_LOGINFO_SUB_CODE_FRAME_XFER_ERROR                 (0x00000400) /* Bits 0-3 encode Transport Status Register (offset 0x08) */
-                                                                          /* Bit 0 is Status Bit 0: FrameXferErr */
-                                                                          /* Bit 1 & 2 are Status Bits 16 and 17: FrameXmitErrStatus */
-                                                                          /* Bit 3 is Status Bit 18 WriteDataLengthGTDataLengthErr */
+#define PL_LOGINFO_SUB_CODE_FRAME_XFER_ERROR                 (0x00000400)
+/* Bits 0-3 encode Transport Status Register (offset 0x08) */
+/* Bit 0 is Status Bit 0: FrameXferErr */
+/* Bit 1 & 2 are Status Bits 16 and 17: FrameXmitErrStatus */
+/* Bit 3 is Status Bit 18 WriteDataLenghtGTDataLengthErr */
 
 #define PL_LOGINFO_SUB_CODE_TX_FM_CONNECTED_LOW              (0x00000500)
 #define PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET      (0x00000600)
@@ -177,6 +180,11 @@
 #define PL_LOGINFO_SUB_CODE_DISCOVERY_REMOTE_SEP_RESET       (0x00000E01)
 #define PL_LOGINFO_SUB_CODE_SECOND_OPEN                      (0x00000F00)
 #define PL_LOGINFO_SUB_CODE_DSCVRY_SATA_INIT_TIMEOUT         (0x00001000)
+#define PL_LOGINFO_SUB_CODE_BREAK_ON_SATA_CONNECTION         (0x00002000)
+/* not currently used in mainline */
+#define PL_LOGINFO_SUB_CODE_BREAK_ON_STUCK_LINK              (0x00003000)
+#define PL_LOGINFO_SUB_CODE_BREAK_ON_STUCK_LINK_AIP          (0x00004000)
+#define PL_LOGINFO_SUB_CODE_BREAK_ON_INCOMPLETE_BREAK_RCVD   (0x00005000)
 
 #define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_FAILURE          (0x00200000) /* Can't get SMP Frame */
 #define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occured on SMP Read */
@@ -243,6 +251,8 @@
 #define IR_LOGINFO_VOLUME_ACTIVATE_VOLUME_FAILED               (0x00010014)
 /* Activation failed trying to import the volume */
 #define IR_LOGINFO_VOLUME_ACTIVATING_IMPORT_VOLUME_FAILED      (0x00010015)
+/* Activation failed trying to import the volume */
+#define IR_LOGINFO_VOLUME_ACTIVATING_TOO_MANY_PHYS_DISKS       (0x00010016)
 
 /* Phys Disk failed, too many phys disks */
 #define IR_LOGINFO_PHYSDISK_CREATE_TOO_MANY_DISKS              (0x00010020)
@@ -285,6 +295,21 @@
 /* Compatibility Error : IME size limited to < 2TB */
 #define IR_LOGINFO_COMPAT_ERROR_IME_VOL_NOT_CURRENTLY_SUPPORTED (0x0001003D)
 
+/* Device Firmware Update: DFU can only be started once */
+#define IR_LOGINFO_DEV_FW_UPDATE_ERR_DFU_IN_PROGRESS            (0x00010050)
+/* Device Firmware Update: Volume must be Optimal/Active/non-Quiesced */
+#define IR_LOGINFO_DEV_FW_UPDATE_ERR_DEVICE_IN_INVALID_STATE    (0x00010051)
+/* Device Firmware Update: DFU Timeout cannot be zero */
+#define IR_LOGINFO_DEV_FW_UPDATE_ERR_INVALID_TIMEOUT            (0x00010052)
+/* Device Firmware Update: CREATE TIMER FAILED */
+#define IR_LOGINFO_DEV_FW_UPDATE_ERR_NO_TIMERS                  (0x00010053)
+/* Device Firmware Update: Failed to read SAS_IO_UNIT_PG_1 */
+#define IR_LOGINFO_DEV_FW_UPDATE_ERR_READING_CFG_PAGE           (0x00010054)
+/* Device Firmware Update: Invalid SAS_IO_UNIT_PG_1 value(s) */
+#define IR_LOGINFO_DEV_FW_UPDATE_ERR_PORT_IO_TIMEOUTS_REQUIRED  (0x00010055)
+/* Device Firmware Update: Unable to allocate memory for page */
+#define IR_LOGINFO_DEV_FW_UPDATE_ERR_ALLOC_CFG_PAGE             (0x00010056)
+
 
 /****************************************************************************/
 /* Defines for convenience                                                  */
diff --git a/drivers/message/fusion/lsi/mpi_raid.h b/drivers/message/fusion/lsi/mpi_raid.h
index 2856108..add60cc 100644
--- a/drivers/message/fusion/lsi/mpi_raid.h
+++ b/drivers/message/fusion/lsi/mpi_raid.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2001-2007 LSI Corporation.
+ *  Copyright (c) 2001-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_raid.h
  *          Title:  MPI RAID message and structures
  *  Creation Date:  February 27, 2001
  *
- *    mpi_raid.h Version:  01.05.03
+ *    mpi_raid.h Version:  01.05.05
  *
  *  Version History
  *  ---------------
@@ -34,6 +34,9 @@
  *                      _SET_RESYNC_RATE and _SET_DATA_SCRUB_RATE.
  *  02-28-07  01.05.03  Added new RAID Action, Device FW Update Mode, and
  *                      associated defines.
+ *  08-07-07  01.05.04  Added Disable Full Rebuild bit to the ActionDataWord
+ *                      for the RAID Action MPI_RAID_ACTION_DISABLE_VOLUME.
+ *  01-15-08  01.05.05  Added define for MPI_RAID_ACTION_SET_VOLUME_NAME.
  *  --------------------------------------------------------------------------
  */
 
@@ -93,6 +96,7 @@ typedef struct _MSG_RAID_ACTION
 #define MPI_RAID_ACTION_SET_RESYNC_RATE             (0x13)
 #define MPI_RAID_ACTION_SET_DATA_SCRUB_RATE         (0x14)
 #define MPI_RAID_ACTION_DEVICE_FW_UPDATE_MODE       (0x15)
+#define MPI_RAID_ACTION_SET_VOLUME_NAME             (0x16)
 
 /* ActionDataWord defines for use with MPI_RAID_ACTION_CREATE_VOLUME action */
 #define MPI_RAID_ACTION_ADATA_DO_NOT_SYNC           (0x00000001)
@@ -105,6 +109,9 @@ typedef struct _MSG_RAID_ACTION
 #define MPI_RAID_ACTION_ADATA_KEEP_LBA0             (0x00000000)
 #define MPI_RAID_ACTION_ADATA_ZERO_LBA0             (0x00000002)
 
+/* ActionDataWord defines for use with MPI_RAID_ACTION_DISABLE_VOLUME action */
+#define MPI_RAID_ACTION_ADATA_DISABLE_FULL_REBUILD  (0x00000001)
+
 /* ActionDataWord defines for use with MPI_RAID_ACTION_ACTIVATE_VOLUME action */
 #define MPI_RAID_ACTION_ADATA_INACTIVATE_ALL        (0x00000001)
 
diff --git a/drivers/message/fusion/lsi/mpi_sas.h b/drivers/message/fusion/lsi/mpi_sas.h
index 33fca83..ab41003 100644
--- a/drivers/message/fusion/lsi/mpi_sas.h
+++ b/drivers/message/fusion/lsi/mpi_sas.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2004-2006 LSI Corporation.
+ *  Copyright (c) 2004-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_sas.h
  *          Title:  MPI Serial Attached SCSI structures and definitions
  *  Creation Date:  August 19, 2004
  *
- *    mpi_sas.h Version:  01.05.04
+ *    mpi_sas.h Version:  01.05.05
  *
  *  Version History
  *  ---------------
@@ -23,6 +23,10 @@
  *                      reply.
  *  10-11-06  01.05.04  Fixed the name of a define for Operation field of SAS IO
  *                      Unit Control request.
+ *  01-15-08  01.05.05  Added support for MPI_SAS_OP_SET_IOC_PARAMETER,
+ *                      including adding IOCParameter and IOCParameter value
+ *                      fields to SAS IO Unit Control Request.
+ *                      Added MPI_SAS_DEVICE_INFO_PRODUCT_SPECIFIC define.
  *  --------------------------------------------------------------------------
  */
 
@@ -60,6 +64,8 @@
  * Values for the SAS DeviceInfo field used in SAS Device Status Change Event
  * data and SAS IO Unit Configuration pages.
  */
+#define MPI_SAS_DEVICE_INFO_PRODUCT_SPECIFIC    (0xF0000000)
+
 #define MPI_SAS_DEVICE_INFO_SEP                 (0x00004000)
 #define MPI_SAS_DEVICE_INFO_ATAPI_DEVICE        (0x00002000)
 #define MPI_SAS_DEVICE_INFO_LSI_DEVICE          (0x00001000)
@@ -216,7 +222,7 @@ typedef struct _MSG_SAS_IOUNIT_CONTROL_REQUEST
     U8                      ChainOffset;        /* 02h */
     U8                      Function;           /* 03h */
     U16                     DevHandle;          /* 04h */
-    U8                      Reserved3;          /* 06h */
+    U8                      IOCParameter;       /* 06h */
     U8                      MsgFlags;           /* 07h */
     U32                     MsgContext;         /* 08h */
     U8                      TargetID;           /* 0Ch */
@@ -225,7 +231,7 @@ typedef struct _MSG_SAS_IOUNIT_CONTROL_REQUEST
     U8                      PrimFlags;          /* 0Fh */
     U32                     Primitive;          /* 10h */
     U64                     SASAddress;         /* 14h */
-    U32                     Reserved4;          /* 1Ch */
+    U32                     IOCParameterValue;  /* 1Ch */
 } MSG_SAS_IOUNIT_CONTROL_REQUEST, MPI_POINTER PTR_MSG_SAS_IOUNIT_CONTROL_REQUEST,
   SasIoUnitControlRequest_t, MPI_POINTER pSasIoUnitControlRequest_t;
 
@@ -241,6 +247,8 @@ typedef struct _MSG_SAS_IOUNIT_CONTROL_REQUEST
 #define MPI_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL  (0x0C)
 #define MPI_SAS_OP_TRANSMIT_REMOVE_DEVICE       (0x0D)  /* obsolete name */
 #define MPI_SAS_OP_REMOVE_DEVICE                (0x0D)
+#define MPI_SAS_OP_SET_IOC_PARAMETER            (0x0E)
+#define MPI_SAS_OP_PRODUCT_SPECIFIC_MIN         (0x80)
 
 /* values for the PrimFlags field */
 #define MPI_SAS_PRIMFLAGS_SINGLE                (0x08)
@@ -256,7 +264,7 @@ typedef struct _MSG_SAS_IOUNIT_CONTROL_REPLY
     U8                      MsgLength;          /* 02h */
     U8                      Function;           /* 03h */
     U16                     DevHandle;          /* 04h */
-    U8                      Reserved3;          /* 06h */
+    U8                      IOCParameter;       /* 06h */
     U8                      MsgFlags;           /* 07h */
     U32                     MsgContext;         /* 08h */
     U16                     Reserved4;          /* 0Ch */
diff --git a/drivers/message/fusion/lsi/mpi_targ.h b/drivers/message/fusion/lsi/mpi_targ.h
index ff8c37d..c3dea7f 100644
--- a/drivers/message/fusion/lsi/mpi_targ.h
+++ b/drivers/message/fusion/lsi/mpi_targ.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2004 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_targ.h
diff --git a/drivers/message/fusion/lsi/mpi_tool.h b/drivers/message/fusion/lsi/mpi_tool.h
index 8834ae6..53cd715 100644
--- a/drivers/message/fusion/lsi/mpi_tool.h
+++ b/drivers/message/fusion/lsi/mpi_tool.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2001-2005 LSI Corporation.
+ *  Copyright (c) 2001-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_tool.h
diff --git a/drivers/message/fusion/lsi/mpi_type.h b/drivers/message/fusion/lsi/mpi_type.h
index 08dad9c..888b26d 100644
--- a/drivers/message/fusion/lsi/mpi_type.h
+++ b/drivers/message/fusion/lsi/mpi_type.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2004 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_type.h
  *          Title:  MPI Basic type definitions
  *  Creation Date:  June 6, 2000
  *
- *    mpi_type.h Version:  01.05.01
+ *    mpi_type.h Version:  01.05.02
  *
  *  Version History
  *  ---------------
