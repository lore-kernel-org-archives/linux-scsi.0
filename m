From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] - mpi header update - version 1.05.14
Date: Fri, 19 Jan 2007 18:41:13 -0700
Message-ID: <20070120014113.GA15536@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59537 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825AbXATAee (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jan 2007 19:34:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Here are latest mpi headers (firmware/driver interface).

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/lsi/mpi.h a/drivers/message/fusion/lsi/mpi.h
--- b/drivers/message/fusion/lsi/mpi.h	2006-11-29 14:57:37.000000000 -0700
+++ a/drivers/message/fusion/lsi/mpi.h	2007-01-05 16:52:08.000000000 -0700
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2005 LSI Logic Corporation.
+ *  Copyright (c) 2000-2006 LSI Logic Corporation.
  *
  *
  *           Name:  mpi.h
  *          Title:  MPI Message independent structures and definitions
  *  Creation Date:  July 27, 2000
  *
- *    mpi.h Version:  01.05.11
+ *    mpi.h Version:  01.05.12
  *
  *  Version History
  *  ---------------
@@ -77,6 +77,7 @@
  *  08-03-05  01.05.09  Bumped MPI_HEADER_VERSION_UNIT.
  *  08-30-05  01.05.10  Added 2 new IOCStatus codes for Target.
  *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
+ *  10-11-06  01.05.12  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
  */
 
@@ -107,7 +108,7 @@
 /* Note: The major versions of 0xe0 through 0xff are reserved */
 
 /* versioning for this MPI header set */
-#define MPI_HEADER_VERSION_UNIT             (0x0D)
+#define MPI_HEADER_VERSION_UNIT             (0x0E)
 #define MPI_HEADER_VERSION_DEV              (0x00)
 #define MPI_HEADER_VERSION_UNIT_MASK        (0xFF00)
 #define MPI_HEADER_VERSION_UNIT_SHIFT       (8)
diff -uarpN b/drivers/message/fusion/lsi/mpi_cnfg.h a/drivers/message/fusion/lsi/mpi_cnfg.h
--- b/drivers/message/fusion/lsi/mpi_cnfg.h	2006-11-29 14:57:37.000000000 -0700
+++ a/drivers/message/fusion/lsi/mpi_cnfg.h	2007-01-05 16:52:08.000000000 -0700
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2005 LSI Logic Corporation.
+ *  Copyright (c) 2000-2006 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_cnfg.h
  *          Title:  MPI Config message, structures, and Pages
  *  Creation Date:  July 27, 2000
  *
- *    mpi_cnfg.h Version:  01.05.12
+ *    mpi_cnfg.h Version:  01.05.13
  *
  *  Version History
  *  ---------------
@@ -276,6 +276,23 @@
  *                      Added AdditionalControlFlags, MaxTargetPortConnectTime,
  *                      ReportDeviceMissingDelay, and IODeviceMissingDelay
  *                      fields to SAS IO Unit Page 1.
+ *  10-11-06  01.05.13  Added NumForceWWID field and ForceWWID array to
+ *                      Manufacturing Page 5.
+ *                      Added Manufacturing pages 8 through 10.
+ *                      Added defines for supported metadata size bits in
+ *                      CapabilitiesFlags field of IOC Page 6.
+ *                      Added defines for metadata size bits in VolumeSettings
+ *                      field of RAID Volume Page 0.
+ *                      Added SATA Link Reset settings, Enable SATA Asynchronous
+ *                      Notification bit, and HideNonZeroAttachedPhyIdentifiers
+ *                      bit to AdditionalControlFlags field of SAS IO Unit
+ *                      Page 1.
+ *                      Added defines for Enclosure Devices Unmapped and
+ *                      Device Limit Exceeded bits in Status field of SAS IO
+ *                      Unit Page 2.
+ *                      Added more AccessStatus values for SAS Device Page 0.
+ *                      Added bit for SATA Asynchronous Notification Support in
+ *                      Flags field of SAS Device Page 0.
  *  --------------------------------------------------------------------------
  */
 
@@ -654,17 +671,24 @@ typedef struct _CONFIG_PAGE_MANUFACTURIN
 #define MPI_MANPAGE4_IR_NO_MIX_SAS_SATA                 (0x01)
 
 
+#ifndef MPI_MANPAGE5_NUM_FORCEWWID
+#define MPI_MANPAGE5_NUM_FORCEWWID      (1)
+#endif
+
 typedef struct _CONFIG_PAGE_MANUFACTURING_5
 {
     CONFIG_PAGE_HEADER              Header;             /* 00h */
     U64                             BaseWWID;           /* 04h */
     U8                              Flags;              /* 0Ch */
-    U8                              Reserved1;          /* 0Dh */
+    U8                              NumForceWWID;       /* 0Dh */
     U16                             Reserved2;          /* 0Eh */
+    U32                             Reserved3;          /* 10h */
+    U32                             Reserved4;          /* 14h */
+    U64                             ForceWWID[MPI_MANPAGE5_NUM_FORCEWWID]; /* 18h */
 } CONFIG_PAGE_MANUFACTURING_5, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_5,
   ManufacturingPage5_t, MPI_POINTER pManufacturingPage5_t;
 
-#define MPI_MANUFACTURING5_PAGEVERSION                  (0x01)
+#define MPI_MANUFACTURING5_PAGEVERSION                  (0x02)
 
 /* defines for the Flags field */
 #define MPI_MANPAGE5_TWO_WWID_PER_PHY                   (0x01)
@@ -740,6 +764,36 @@ typedef struct _CONFIG_PAGE_MANUFACTURIN
 #define MPI_MANPAGE7_FLAG_USE_SLOT_INFO                 (0x00000001)
 
 
+typedef struct _CONFIG_PAGE_MANUFACTURING_8
+{
+    CONFIG_PAGE_HEADER              Header;             /* 00h */
+    U32                             ProductSpecificInfo;/* 04h */
+} CONFIG_PAGE_MANUFACTURING_8, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_8,
+  ManufacturingPage8_t, MPI_POINTER pManufacturingPage8_t;
+
+#define MPI_MANUFACTURING8_PAGEVERSION                  (0x00)
+
+
+typedef struct _CONFIG_PAGE_MANUFACTURING_9
+{
+    CONFIG_PAGE_HEADER              Header;             /* 00h */
+    U32                             ProductSpecificInfo;/* 04h */
+} CONFIG_PAGE_MANUFACTURING_9, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_9,
+  ManufacturingPage9_t, MPI_POINTER pManufacturingPage9_t;
+
+#define MPI_MANUFACTURING6_PAGEVERSION                  (0x00)
+
+
+typedef struct _CONFIG_PAGE_MANUFACTURING_10
+{
+    CONFIG_PAGE_HEADER              Header;             /* 00h */
+    U32                             ProductSpecificInfo;/* 04h */
+} CONFIG_PAGE_MANUFACTURING_10, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_10,
+  ManufacturingPage10_t, MPI_POINTER pManufacturingPage10_t;
+
+#define MPI_MANUFACTURING10_PAGEVERSION                 (0x00)
+
+
 /****************************************************************************
 *   IO Unit Config Pages
 ****************************************************************************/
@@ -1080,10 +1134,14 @@ typedef struct _CONFIG_PAGE_IOC_6
 } CONFIG_PAGE_IOC_6, MPI_POINTER PTR_CONFIG_PAGE_IOC_6,
   IOCPage6_t, MPI_POINTER pIOCPage6_t;
 
-#define MPI_IOCPAGE6_PAGEVERSION                        (0x00)
+#define MPI_IOCPAGE6_PAGEVERSION                        (0x01)
 
 /* IOC Page 6 Capabilities Flags */
 
+#define MPI_IOCPAGE6_CAP_FLAGS_MASK_METADATA_SIZE       (0x00000006)
+#define MPI_IOCPAGE6_CAP_FLAGS_64MB_METADATA_SIZE       (0x00000000)
+#define MPI_IOCPAGE6_CAP_FLAGS_512MB_METADATA_SIZE      (0x00000002)
+
 #define MPI_IOCPAGE6_CAP_FLAGS_GLOBAL_HOT_SPARE         (0x00000001)
 
 
@@ -2160,6 +2218,11 @@ typedef struct _RAID_VOL0_SETTINGS
 #define MPI_RAIDVOL0_SETTING_AUTO_CONFIGURE             (0x0004)
 #define MPI_RAIDVOL0_SETTING_PRIORITY_RESYNC            (0x0008)
 #define MPI_RAIDVOL0_SETTING_FAST_DATA_SCRUBBING_0102   (0x0020) /* obsolete */
+
+#define MPI_RAIDVOL0_SETTING_MASK_METADATA_SIZE         (0x00C0)
+#define MPI_RAIDVOL0_SETTING_64MB_METADATA_SIZE         (0x0000)
+#define MPI_RAIDVOL0_SETTING_512MB_METADATA_SIZE        (0x0040)
+
 #define MPI_RAIDVOL0_SETTING_USE_PRODUCT_ID_SUFFIX      (0x0010)
 #define MPI_RAIDVOL0_SETTING_USE_DEFAULTS               (0x8000)
 
@@ -2203,7 +2266,7 @@ typedef struct _CONFIG_PAGE_RAID_VOL_0
 } CONFIG_PAGE_RAID_VOL_0, MPI_POINTER PTR_CONFIG_PAGE_RAID_VOL_0,
   RaidVolumePage0_t, MPI_POINTER pRaidVolumePage0_t;
 
-#define MPI_RAIDVOLPAGE0_PAGEVERSION                    (0x06)
+#define MPI_RAIDVOLPAGE0_PAGEVERSION                    (0x07)
 
 /* values for RAID Volume Page 0 InactiveStatus field */
 #define MPI_RAIDVOLPAGE0_UNKNOWN_INACTIVE               (0x00)
@@ -2518,7 +2581,7 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_
 } CONFIG_PAGE_SAS_IO_UNIT_1, MPI_POINTER PTR_CONFIG_PAGE_SAS_IO_UNIT_1,
   SasIOUnitPage1_t, MPI_POINTER pSasIOUnitPage1_t;
 
-#define MPI_SASIOUNITPAGE1_PAGEVERSION      (0x06)
+#define MPI_SASIOUNITPAGE1_PAGEVERSION      (0x07)
 
 /* values for SAS IO Unit Page 1 ControlFlags */
 #define MPI_SAS_IOUNIT1_CONTROL_DEVICE_SELF_TEST            (0x8000)
@@ -2544,7 +2607,13 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_
 #define MPI_SAS_IOUNIT1_CONTROL_CLEAR_AFFILIATION           (0x0001)
 
 /* values for SAS IO Unit Page 1 AdditionalControlFlags */
-#define MPI_SAS_IOUNIT1_ACONTROL_ALLOW_TABLE_TO_TABLE       (0x0001)
+#define MPI_SAS_IOUNIT1_ACONTROL_SATA_ASYNCHROUNOUS_NOTIFICATION    (0x0040)
+#define MPI_SAS_IOUNIT1_ACONTROL_HIDE_NONZERO_ATTACHED_PHY_IDENT    (0x0020)
+#define MPI_SAS_IOUNIT1_ACONTROL_PORT_ENABLE_ONLY_SATA_LINK_RESET   (0x0010)
+#define MPI_SAS_IOUNIT1_ACONTROL_OTHER_AFFILIATION_SATA_LINK_RESET  (0x0008)
+#define MPI_SAS_IOUNIT1_ACONTROL_SELF_AFFILIATION_SATA_LINK_RESET   (0x0004)
+#define MPI_SAS_IOUNIT1_ACONTROL_NO_AFFILIATION_SATA_LINK_RESET     (0x0002)
+#define MPI_SAS_IOUNIT1_ACONTROL_ALLOW_TABLE_TO_TABLE               (0x0001)
 
 /* defines for SAS IO Unit Page 1 ReportDeviceMissingDelay */
 #define MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK         (0x7F)
@@ -2585,9 +2654,11 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_
 } CONFIG_PAGE_SAS_IO_UNIT_2, MPI_POINTER PTR_CONFIG_PAGE_SAS_IO_UNIT_2,
   SasIOUnitPage2_t, MPI_POINTER pSasIOUnitPage2_t;
 
-#define MPI_SASIOUNITPAGE2_PAGEVERSION      (0x05)
+#define MPI_SASIOUNITPAGE2_PAGEVERSION      (0x06)
 
 /* values for SAS IO Unit Page 2 Status field */
+#define MPI_SAS_IOUNIT2_STATUS_DEVICE_LIMIT_EXCEEDED        (0x08)
+#define MPI_SAS_IOUNIT2_STATUS_ENCLOSURE_DEVICES_UNMAPPED   (0x04)
 #define MPI_SAS_IOUNIT2_STATUS_DISABLED_PERSISTENT_MAPPINGS (0x02)
 #define MPI_SAS_IOUNIT2_STATUS_FULL_PERSISTENT_MAPPINGS     (0x01)
 
@@ -2739,24 +2810,38 @@ typedef struct _CONFIG_PAGE_SAS_DEVICE_0
 } CONFIG_PAGE_SAS_DEVICE_0, MPI_POINTER PTR_CONFIG_PAGE_SAS_DEVICE_0,
   SasDevicePage0_t, MPI_POINTER pSasDevicePage0_t;
 
-#define MPI_SASDEVICE0_PAGEVERSION          (0x04)
+#define MPI_SASDEVICE0_PAGEVERSION          (0x05)
 
 /* values for SAS Device Page 0 AccessStatus field */
-#define MPI_SAS_DEVICE0_ASTATUS_NO_ERRORS               (0x00)
-#define MPI_SAS_DEVICE0_ASTATUS_SATA_INIT_FAILED        (0x01)
-#define MPI_SAS_DEVICE0_ASTATUS_SATA_CAPABILITY_FAILED  (0x02)
+#define MPI_SAS_DEVICE0_ASTATUS_NO_ERRORS                   (0x00)
+#define MPI_SAS_DEVICE0_ASTATUS_SATA_INIT_FAILED            (0x01)
+#define MPI_SAS_DEVICE0_ASTATUS_SATA_CAPABILITY_FAILED      (0x02)
+#define MPI_SAS_DEVICE0_ASTATUS_SATA_AFFILIATION_CONFLICT   (0x03)
+/* specific values for SATA Init failures */
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_UNKNOWN                 (0x10)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_AFFILIATION_CONFLICT    (0x11)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_DIAG                    (0x12)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_IDENTIFICATION          (0x13)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_CHECK_POWER             (0x14)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_PIO_SN                  (0x15)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_MDMA_SN                 (0x16)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_UDMA_SN                 (0x17)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_ZONING_VIOLATION        (0x18)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_NOT_ADDRESSABLE         (0x19)
+#define MPI_SAS_DEVICE0_ASTATUS_SIF_MAX                     (0x1F)
 
 /* values for SAS Device Page 0 Flags field */
-#define MPI_SAS_DEVICE0_FLAGS_SATA_SW_PRESERVE          (0x0200)
-#define MPI_SAS_DEVICE0_FLAGS_UNSUPPORTED_DEVICE        (0x0100)
-#define MPI_SAS_DEVICE0_FLAGS_SATA_48BIT_LBA_SUPPORTED  (0x0080)
-#define MPI_SAS_DEVICE0_FLAGS_SATA_SMART_SUPPORTED      (0x0040)
-#define MPI_SAS_DEVICE0_FLAGS_SATA_NCQ_SUPPORTED        (0x0020)
-#define MPI_SAS_DEVICE0_FLAGS_SATA_FUA_SUPPORTED        (0x0010)
-#define MPI_SAS_DEVICE0_FLAGS_PORT_SELECTOR_ATTACH      (0x0008)
-#define MPI_SAS_DEVICE0_FLAGS_MAPPING_PERSISTENT        (0x0004)
-#define MPI_SAS_DEVICE0_FLAGS_DEVICE_MAPPED             (0x0002)
-#define MPI_SAS_DEVICE0_FLAGS_DEVICE_PRESENT            (0x0001)
+#define MPI_SAS_DEVICE0_FLAGS_SATA_ASYNCHRONOUS_NOTIFY      (0x0400)
+#define MPI_SAS_DEVICE0_FLAGS_SATA_SW_PRESERVE              (0x0200)
+#define MPI_SAS_DEVICE0_FLAGS_UNSUPPORTED_DEVICE            (0x0100)
+#define MPI_SAS_DEVICE0_FLAGS_SATA_48BIT_LBA_SUPPORTED      (0x0080)
+#define MPI_SAS_DEVICE0_FLAGS_SATA_SMART_SUPPORTED          (0x0040)
+#define MPI_SAS_DEVICE0_FLAGS_SATA_NCQ_SUPPORTED            (0x0020)
+#define MPI_SAS_DEVICE0_FLAGS_SATA_FUA_SUPPORTED            (0x0010)
+#define MPI_SAS_DEVICE0_FLAGS_PORT_SELECTOR_ATTACH          (0x0008)
+#define MPI_SAS_DEVICE0_FLAGS_MAPPING_PERSISTENT            (0x0004)
+#define MPI_SAS_DEVICE0_FLAGS_DEVICE_MAPPED                 (0x0002)
+#define MPI_SAS_DEVICE0_FLAGS_DEVICE_PRESENT                (0x0001)
 
 /* see mpi_sas.h for values for SAS Device Page 0 DeviceInfo values */
 
diff -uarpN b/drivers/message/fusion/lsi/mpi_history.txt a/drivers/message/fusion/lsi/mpi_history.txt
--- b/drivers/message/fusion/lsi/mpi_history.txt	2006-11-29 14:57:37.000000000 -0700
+++ a/drivers/message/fusion/lsi/mpi_history.txt	2007-01-05 16:52:08.000000000 -0700
@@ -3,28 +3,28 @@
  MPI Header File Change History
  ==============================
 
- Copyright (c) 2000-2005 LSI Logic Corporation.
+ Copyright (c) 2000-2006 LSI Logic Corporation.
 
  ---------------------------------------
- Header Set Release Version:    01.05.13
- Header Set Release Date:       03-27-06
+ Header Set Release Version:    01.05.14
+ Header Set Release Date:       10-11-06
  ---------------------------------------
 
  Filename               Current version     Prior version
  ----------             ---------------     -------------
- mpi.h                  01.05.11            01.05.10
- mpi_ioc.h              01.05.11            01.05.10
- mpi_cnfg.h             01.05.12            01.05.11
- mpi_init.h             01.05.07            01.05.06
- mpi_targ.h             01.05.06            01.05.05
+ mpi.h                  01.05.12            01.05.11
+ mpi_ioc.h              01.05.12            01.05.11
+ mpi_cnfg.h             01.05.13            01.05.12
+ mpi_init.h             01.05.08            01.05.07
+ mpi_targ.h             01.05.06            01.05.06
  mpi_fc.h               01.05.01            01.05.01
  mpi_lan.h              01.05.01            01.05.01
  mpi_raid.h             01.05.02            01.05.02
  mpi_tool.h             01.05.03            01.05.03
  mpi_inb.h              01.05.01            01.05.01
- mpi_sas.h              01.05.03            01.05.02
+ mpi_sas.h              01.05.04            01.05.03
  mpi_type.h             01.05.02            01.05.02
- mpi_history.txt        01.05.13            01.05.12
+ mpi_history.txt        01.05.14            01.05.13
 
 
  *  Date      Version   Description
@@ -94,6 +94,7 @@ mpi.h
  *  08-03-05  01.05.09  Bumped MPI_HEADER_VERSION_UNIT.
  *  08-30-05  01.05.10  Added 2 new IOCStatus codes for Target.
  *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
+ *  10-11-06  01.05.12  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
 
 mpi_ioc.h
@@ -182,6 +183,14 @@ mpi_ioc.h
  *                      Added MPI_EVENT_SAS_INIT_TABLE_OVERFLOW and event
  *                      data structure.
  *                      Added MPI_EXT_IMAGE_TYPE_INITIALIZATION.
+ *  10-11-06  01.05.12  Added MPI_IOCFACTS_EXCEPT_METADATA_UNSUPPORTED.
+ *                      Added MaxInitiators field to PortFacts reply.
+ *                      Added SAS Device Status Change ReasonCode for
+ *                      asynchronous notificaiton.
+ *                      Added MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE and event
+ *                      data structure.
+ *                      Added new ImageType values for FWDownload and FWUpload
+ *                      requests.
  *  --------------------------------------------------------------------------
 
 mpi_cnfg.h
@@ -447,6 +456,23 @@ mpi_cnfg.h
  *                      Added AdditionalControlFlags, MaxTargetPortConnectTime,
  *                      ReportDeviceMissingDelay, and IODeviceMissingDelay
  *                      fields to SAS IO Unit Page 1.
+ *  10-11-06  01.05.13  Added NumForceWWID field and ForceWWID array to
+ *                      Manufacturing Page 5.
+ *                      Added Manufacturing pages 8 through 10.
+ *                      Added defines for supported metadata size bits in
+ *                      CapabilitiesFlags field of IOC Page 6.
+ *                      Added defines for metadata size bits in VolumeSettings
+ *                      field of RAID Volume Page 0.
+ *                      Added SATA Link Reset settings, Enable SATA Asynchronous
+ *                      Notification bit, and HideNonZeroAttachedPhyIdentifiers
+ *                      bit to AdditionalControlFlags field of SAS IO Unit
+ *                      Page 1.
+ *                      Added defines for Enclosure Devices Unmapped and
+ *                      Device Limit Exceeded bits in Status field of SAS IO
+ *                      Unit Page 2.
+ *                      Added more AccessStatus values for SAS Device Page 0.
+ *                      Added bit for SATA Asynchronous Notification Support in
+ *                      Flags field of SAS Device Page 0.
  *  --------------------------------------------------------------------------
 
 mpi_init.h
@@ -490,6 +516,7 @@ mpi_init.h
  *  08-03-05  01.05.06  Fixed some MPI_SCSIIO32_MSGFLGS_ defines to make them
  *                      unique in the first 32 characters.
  *  03-27-06  01.05.07  Added Task Management type of Clear ACA.
+ *  10-11-06  01.05.08  Shortened define for Task Management type of Clear ACA.
  *  --------------------------------------------------------------------------
 
 mpi_targ.h
@@ -638,6 +665,8 @@ mpi_sas.h
  *                      and Remove Device operations to SAS IO Unit Control.
  *                      Added DevHandle field to SAS IO Unit Control request and
  *                      reply.
+ *  10-11-06  01.05.04  Fixed the name of a define for Operation field of SAS IO
+ *                      Unit Control request.
  *  --------------------------------------------------------------------------
 
 mpi_type.h
@@ -653,20 +682,20 @@ mpi_type.h
 
 mpi_history.txt         Parts list history
 
-Filename    01.05.13  01.05.12  01.05.11  01.05.10  01.05.09
-----------  --------  --------  --------  --------  --------
-mpi.h       01.05.11  01.05.10  01.05.09  01.05.08  01.05.07
-mpi_ioc.h   01.05.11  01.05.10  01.05.09  01.05.09  01.05.08
-mpi_cnfg.h  01.05.12  01.05.11  01.05.10  01.05.09  01.05.08
-mpi_init.h  01.05.07  01.05.06  01.05.06  01.05.05  01.05.04
-mpi_targ.h  01.05.06  01.05.05  01.05.05  01.05.05  01.05.04
-mpi_fc.h    01.05.01  01.05.01  01.05.01  01.05.01  01.05.01
-mpi_lan.h   01.05.01  01.05.01  01.05.01  01.05.01  01.05.01
-mpi_raid.h  01.05.02  01.05.02  01.05.02  01.05.02  01.05.02
-mpi_tool.h  01.05.03  01.05.03  01.05.03  01.05.03  01.05.03
-mpi_inb.h   01.05.01  01.05.01  01.05.01  01.05.01  01.05.01
-mpi_sas.h   01.05.03  01.05.02  01.05.01  01.05.01  01.05.01
-mpi_type.h  01.05.02  01.05.02  01.05.01  01.05.01  01.05.01
+Filename    01.05.13   01.05.13   01.05.12   01.05.11   01.05.10   01.05.09
+----------  --------   --------   --------   --------   --------   --------
+mpi.h       01.05.12   01.05.11   01.05.10   01.05.09   01.05.08   01.05.07
+mpi_ioc.h   01.05.12   01.05.11   01.05.10   01.05.09   01.05.09   01.05.08
+mpi_cnfg.h  01.05.13   01.05.12   01.05.11   01.05.10   01.05.09   01.05.08
+mpi_init.h  01.05.08   01.05.07   01.05.06   01.05.06   01.05.05   01.05.04
+mpi_targ.h  01.05.06   01.05.06   01.05.05   01.05.05   01.05.05   01.05.04
+mpi_fc.h    01.05.01   01.05.01   01.05.01   01.05.01   01.05.01   01.05.01
+mpi_lan.h   01.05.01   01.05.01   01.05.01   01.05.01   01.05.01   01.05.01
+mpi_raid.h  01.05.02   01.05.02   01.05.02   01.05.02   01.05.02   01.05.02
+mpi_tool.h  01.05.03   01.05.03   01.05.03   01.05.03   01.05.03   01.05.03
+mpi_inb.h   01.05.01   01.05.01   01.05.01   01.05.01   01.05.01   01.05.01
+mpi_sas.h   01.05.04   01.05.03   01.05.02   01.05.01   01.05.01   01.05.01
+mpi_type.h  01.05.02   01.05.02   01.05.02   01.05.01   01.05.01   01.05.01
 
 Filename    01.05.08   01.05.07   01.05.06   01.05.05   01.05.04   01.05.03
 ----------  --------   --------   --------   --------   --------   --------
diff -uarpN b/drivers/message/fusion/lsi/mpi_init.h a/drivers/message/fusion/lsi/mpi_init.h
--- b/drivers/message/fusion/lsi/mpi_init.h	2006-11-29 14:57:37.000000000 -0700
+++ a/drivers/message/fusion/lsi/mpi_init.h	2007-01-05 16:52:08.000000000 -0700
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2005 LSI Logic Corporation.
+ *  Copyright (c) 2000-2006 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_init.h
  *          Title:  MPI initiator mode messages and structures
  *  Creation Date:  June 8, 2000
  *
- *    mpi_init.h Version:  01.05.07
+ *    mpi_init.h Version:  01.05.08
  *
  *  Version History
  *  ---------------
@@ -53,6 +53,7 @@
  *  08-03-05  01.05.06  Fixed some MPI_SCSIIO32_MSGFLGS_ defines to make them
  *                      unique in the first 32 characters.
  *  03-27-06  01.05.07  Added Task Management type of Clear ACA.
+ *  10-11-06  01.05.08  Shortened define for Task Management type of Clear ACA.
  *  --------------------------------------------------------------------------
  */
 
@@ -428,7 +429,7 @@ typedef struct _MSG_SCSI_TASK_MGMT
 #define MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET    (0x05)
 #define MPI_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET        (0x06)
 #define MPI_SCSITASKMGMT_TASKTYPE_QUERY_TASK            (0x07)
-#define MPI_SCSITASKMGMT_TASKTYPE_CLEAR_ACA             (0x08)
+#define MPI_SCSITASKMGMT_TASKTYPE_CLR_ACA               (0x08)
 
 /* MsgFlags bits */
 #define MPI_SCSITASKMGMT_MSGFLAGS_TARGET_RESET_OPTION   (0x00)
diff -uarpN b/drivers/message/fusion/lsi/mpi_ioc.h a/drivers/message/fusion/lsi/mpi_ioc.h
--- b/drivers/message/fusion/lsi/mpi_ioc.h	2006-11-29 14:57:37.000000000 -0700
+++ a/drivers/message/fusion/lsi/mpi_ioc.h	2007-01-05 16:52:08.000000000 -0700
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2005 LSI Logic Corporation.
+ *  Copyright (c) 2000-2006 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_ioc.h
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  *  Creation Date:  August 11, 2000
  *
- *    mpi_ioc.h Version:  01.05.11
+ *    mpi_ioc.h Version:  01.05.12
  *
  *  Version History
  *  ---------------
@@ -98,6 +98,14 @@
  *                      Added MPI_EVENT_SAS_INIT_TABLE_OVERFLOW and event
  *                      data structure.
  *                      Added MPI_EXT_IMAGE_TYPE_INITIALIZATION.
+ *  10-11-06  01.05.12  Added MPI_IOCFACTS_EXCEPT_METADATA_UNSUPPORTED.
+ *                      Added MaxInitiators field to PortFacts reply.
+ *                      Added SAS Device Status Change ReasonCode for
+ *                      asynchronous notificaiton.
+ *                      Added MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE and event
+ *                      data structure.
+ *                      Added new ImageType values for FWDownload and FWUpload
+ *                      requests.
  *  --------------------------------------------------------------------------
  */
 
@@ -264,6 +272,7 @@ typedef struct _MSG_IOC_FACTS_REPLY
 #define MPI_IOCFACTS_EXCEPT_RAID_CONFIG_INVALID         (0x0002)
 #define MPI_IOCFACTS_EXCEPT_FW_CHECKSUM_FAIL            (0x0004)
 #define MPI_IOCFACTS_EXCEPT_PERSISTENT_TABLE_FULL       (0x0008)
+#define MPI_IOCFACTS_EXCEPT_METADATA_UNSUPPORTED        (0x0010)
 
 #define MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT             (0x01)
 #define MPI_IOCFACTS_FLAGS_REPLY_FIFO_HOST_SIGNAL       (0x02)
@@ -328,7 +337,8 @@ typedef struct _MSG_PORT_FACTS_REPLY
      U16                    MaxPostedCmdBuffers;        /* 1Ch */
      U16                    MaxPersistentIDs;           /* 1Eh */
      U16                    MaxLanBuckets;              /* 20h */
-     U16                    Reserved4;                  /* 22h */
+     U8                     MaxInitiators;              /* 22h */
+     U8                     Reserved4;                  /* 23h */
      U32                    Reserved5;                  /* 24h */
 } MSG_PORT_FACTS_REPLY, MPI_POINTER PTR_MSG_PORT_FACTS_REPLY,
   PortFactsReply_t, MPI_POINTER pPortFactsReply_t;
@@ -487,6 +497,7 @@ typedef struct _MSG_EVENT_ACK_REPLY
 #define MPI_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE (0x00000018)
 #define MPI_EVENT_SAS_INIT_TABLE_OVERFLOW       (0x00000019)
 #define MPI_EVENT_SAS_SMP_ERROR                 (0x0000001A)
+#define MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE    (0x0000001B)
 #define MPI_EVENT_LOG_ENTRY_ADDED               (0x00000021)
 
 /* AckRequired field values */
@@ -593,6 +604,7 @@ typedef struct _EVENT_DATA_SAS_DEVICE_ST
 #define MPI_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL   (0x0A)
 #define MPI_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL   (0x0B)
 #define MPI_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL       (0x0C)
+#define MPI_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION        (0x0D)
 
 
 /* SCSI Event data for Queue Full event */
@@ -895,6 +907,54 @@ typedef struct _EVENT_DATA_SAS_INIT_TABL
   MpiEventDataSasInitTableOverflow_t,
   MPI_POINTER pMpiEventDataSasInitTableOverflow_t;
 
+/* SAS Expander Status Change Event data */
+
+typedef struct _EVENT_DATA_SAS_EXPANDER_STATUS_CHANGE
+{
+    U8                      ReasonCode;             /* 00h */
+    U8                      Reserved1;              /* 01h */
+    U16                     Reserved2;              /* 02h */
+    U8                      PhysicalPort;           /* 04h */
+    U8                      Reserved3;              /* 05h */
+    U16                     EnclosureHandle;        /* 06h */
+    U64                     SASAddress;             /* 08h */
+    U32                     DiscoveryStatus;        /* 10h */
+    U16                     DevHandle;              /* 14h */
+    U16                     ParentDevHandle;        /* 16h */
+    U16                     ExpanderChangeCount;    /* 18h */
+    U16                     ExpanderRouteIndexes;   /* 1Ah */
+    U8                      NumPhys;                /* 1Ch */
+    U8                      SASLevel;               /* 1Dh */
+    U8                      Flags;                  /* 1Eh */
+    U8                      Reserved4;              /* 1Fh */
+} EVENT_DATA_SAS_EXPANDER_STATUS_CHANGE,
+  MPI_POINTER PTR_EVENT_DATA_SAS_EXPANDER_STATUS_CHANGE,
+  MpiEventDataSasExpanderStatusChange_t,
+  MPI_POINTER pMpiEventDataSasExpanderStatusChange_t;
+
+/* values for ReasonCode field of SAS Expander Status Change Event data */
+#define MPI_EVENT_SAS_EXP_RC_ADDED                      (0x00)
+#define MPI_EVENT_SAS_EXP_RC_NOT_RESPONDING             (0x01)
+
+/* values for DiscoveryStatus field of SAS Expander Status Change Event data */
+#define MPI_EVENT_SAS_EXP_DS_LOOP_DETECTED              (0x00000001)
+#define MPI_EVENT_SAS_EXP_DS_UNADDRESSABLE_DEVICE       (0x00000002)
+#define MPI_EVENT_SAS_EXP_DS_MULTIPLE_PORTS             (0x00000004)
+#define MPI_EVENT_SAS_EXP_DS_EXPANDER_ERR               (0x00000008)
+#define MPI_EVENT_SAS_EXP_DS_SMP_TIMEOUT                (0x00000010)
+#define MPI_EVENT_SAS_EXP_DS_OUT_ROUTE_ENTRIES          (0x00000020)
+#define MPI_EVENT_SAS_EXP_DS_INDEX_NOT_EXIST            (0x00000040)
+#define MPI_EVENT_SAS_EXP_DS_SMP_FUNCTION_FAILED        (0x00000080)
+#define MPI_EVENT_SAS_EXP_DS_SMP_CRC_ERROR              (0x00000100)
+#define MPI_EVENT_SAS_EXP_DS_SUBTRACTIVE_LINK           (0x00000200)
+#define MPI_EVENT_SAS_EXP_DS_TABLE_LINK                 (0x00000400)
+#define MPI_EVENT_SAS_EXP_DS_UNSUPPORTED_DEVICE         (0x00000800)
+
+/* values for Flags field of SAS Expander Status Change Event data */
+#define MPI_EVENT_SAS_EXP_FLAGS_ROUTE_TABLE_CONFIG      (0x02)
+#define MPI_EVENT_SAS_EXP_FLAGS_CONFIG_IN_PROGRESS      (0x01)
+
+
 
 /*****************************************************************************
 *
@@ -926,6 +986,10 @@ typedef struct _MSG_FW_DOWNLOAD
 #define MPI_FW_DOWNLOAD_ITYPE_BIOS              (0x02)
 #define MPI_FW_DOWNLOAD_ITYPE_NVDATA            (0x03)
 #define MPI_FW_DOWNLOAD_ITYPE_BOOTLOADER        (0x04)
+#define MPI_FW_DOWNLOAD_ITYPE_MANUFACTURING     (0x06)
+#define MPI_FW_DOWNLOAD_ITYPE_CONFIG_1          (0x07)
+#define MPI_FW_DOWNLOAD_ITYPE_CONFIG_2          (0x08)
+#define MPI_FW_DOWNLOAD_ITYPE_MEGARAID          (0x09)
 
 
 typedef struct _FWDownloadTCSGE
@@ -980,6 +1044,11 @@ typedef struct _MSG_FW_UPLOAD
 #define MPI_FW_UPLOAD_ITYPE_NVDATA          (0x03)
 #define MPI_FW_UPLOAD_ITYPE_BOOTLOADER      (0x04)
 #define MPI_FW_UPLOAD_ITYPE_FW_BACKUP       (0x05)
+#define MPI_FW_UPLOAD_ITYPE_MANUFACTURING   (0x06)
+#define MPI_FW_UPLOAD_ITYPE_CONFIG_1        (0x07)
+#define MPI_FW_UPLOAD_ITYPE_CONFIG_2        (0x08)
+#define MPI_FW_UPLOAD_ITYPE_MEGARAID        (0x09)
+#define MPI_FW_UPLOAD_ITYPE_COMPLETE        (0x0A)
 
 typedef struct _FWUploadTCSGE
 {
diff -uarpN b/drivers/message/fusion/lsi/mpi_log_sas.h a/drivers/message/fusion/lsi/mpi_log_sas.h
--- b/drivers/message/fusion/lsi/mpi_log_sas.h	2006-11-29 14:57:37.000000000 -0700
+++ a/drivers/message/fusion/lsi/mpi_log_sas.h	2007-01-05 16:52:08.000000000 -0700
@@ -1,4 +1,3 @@
-
 /***************************************************************************
  *                                                                         *
  *  Copyright 2003 LSI Logic Corporation.  All rights reserved.            *
@@ -14,7 +13,7 @@
 #define IOPI_IOCLOGINFO_H_INCLUDED
 
 #define SAS_LOGINFO_NEXUS_LOSS		0x31170000
-#define SAS_LOGINFO_MASK			0xFFFF0000
+#define SAS_LOGINFO_MASK		0xFFFF0000
 
 /****************************************************************************/
 /*  IOC LOGINFO defines, 0x00000000 - 0x0FFFFFFF                            */
@@ -43,129 +42,172 @@
 /****************************************************************************/
 /* IOP LOGINFO_CODE defines, valid if IOC_LOGINFO_ORIGINATOR = IOP          */
 /****************************************************************************/
-#define IOP_LOGINFO_CODE_INVALID_SAS_ADDRESS            (0x00010000)
-#define IOP_LOGINFO_CODE_UNUSED2                        (0x00020000)
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE            (0x00030000)
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_RT         (0x00030100) /* Route Table Entry not found */
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_PN         (0x00030200) /* Invalid Page Number */
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_FORM       (0x00030300) /* Invalid FORM */
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_PT         (0x00030400) /* Invalid Page Type */
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_DNM        (0x00030500) /* Device Not Mapped */
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_PERSIST    (0x00030600) /* Persistent Page not found */
-#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_DEFAULT    (0x00030700) /* Default Page not found */
-
-#define IOP_LOGINFO_CODE_DIAG_MSG_ERROR                 (0x00040000) /* Error handling diag msg - or'd with diag status */
-
-#define IOP_LOGINFO_CODE_TASK_TERMINATED                (0x00050000)
-
-#define IOP_LOGINFO_CODE_ENCL_MGMT_READ_ACTION_ERR0R    (0x00060001) /* Read Action not supported for SEP msg */
-#define IOP_LOGINFO_CODE_ENCL_MGMT_INVALID_BUS_ID_ERR0R (0x00060002) /* Invalid Bus/ID in SEP msg */
-
-#define IOP_LOGINFO_CODE_TARGET_ASSIST_TERMINATED       (0x00070001)
-#define IOP_LOGINFO_CODE_TARGET_STATUS_SEND_TERMINATED  (0x00070002)
-#define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_ALL_IO       (0x00070003)
-#define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_EXACT_IO     (0x00070004)
-#define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_EXACT_IO_REQ (0x00070005)
+#define IOP_LOGINFO_CODE_INVALID_SAS_ADDRESS                 (0x00010000)
+#define IOP_LOGINFO_CODE_UNUSED2                             (0x00020000)
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE                 (0x00030000)
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_RT              (0x00030100) /* Route Table Entry not found */
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_PN              (0x00030200) /* Invalid Page Number */
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_FORM            (0x00030300) /* Invalid FORM */
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_PT              (0x00030400) /* Invalid Page Type */
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_DNM             (0x00030500) /* Device Not Mapped */
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_PERSIST         (0x00030600) /* Persistent Page not found */
+#define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_DEFAULT         (0x00030700) /* Default Page not found */
+
+#define IOP_LOGINFO_CODE_FWUPLOAD_NO_FLASH_AVAILABLE         (0x0003E000) /* Tried to upload from flash, but there is none */
+#define IOP_LOGINFO_CODE_FWUPLOAD_UNKNOWN_IMAGE_TYPE         (0x0003E001) /* ImageType field contents were invalid */
+#define IOP_LOGINFO_CODE_FWUPLOAD_WRONG_IMAGE_SIZE           (0x0003E002) /* ImageSize field in TCSGE was bad/offset in MfgPg 4 was wrong */
+#define IOP_LOGINFO_CODE_FWUPLOAD_ENTIRE_FLASH_UPLOAD_FAILED (0x0003E003) /* Error occured while attempting to upload the entire flash */
+#define IOP_LOGINFO_CODE_FWUPLOAD_REGION_UPLOAD_FAILED       (0x0003E004) /* Error occured while attempting to upload single flash region */
+#define IOP_LOGINFO_CODE_FWUPLOAD_DMA_FAILURE                (0x0003E005) /* Problem occured while DMAing FW to host memory */
+
+#define IOP_LOGINFO_CODE_DIAG_MSG_ERROR                      (0x00040000) /* Error handling diag msg - or'd with diag status */
+
+#define IOP_LOGINFO_CODE_TASK_TERMINATED                     (0x00050000)
+
+#define IOP_LOGINFO_CODE_ENCL_MGMT_READ_ACTION_ERR0R         (0x00060001) /* Read Action not supported for SEP msg */
+#define IOP_LOGINFO_CODE_ENCL_MGMT_INVALID_BUS_ID_ERR0R      (0x00060002) /* Invalid Bus/ID in SEP msg */
+
+#define IOP_LOGINFO_CODE_TARGET_ASSIST_TERMINATED            (0x00070001)
+#define IOP_LOGINFO_CODE_TARGET_STATUS_SEND_TERMINATED       (0x00070002)
+#define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_ALL_IO            (0x00070003)
+#define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_EXACT_IO          (0x00070004)
+#define IOP_LOGINFO_CODE_TARGET_MODE_ABORT_EXACT_IO_REQ      (0x00070005)
 
 /****************************************************************************/
 /* PL LOGINFO_CODE defines, valid if IOC_LOGINFO_ORIGINATOR = PL            */
 /****************************************************************************/
-#define PL_LOGINFO_CODE_OPEN_FAILURE                        (0x00010000)
-#define PL_LOG_INFO_CODE_OPEN_FAILURE_NO_DEST_TIME_OUT      (0x00010001)
-#define PL_LOGINFO_CODE_OPEN_FAILURE_BAD_DESTINATION        (0x00010011)
-#define PL_LOGINFO_CODE_OPEN_FAILURE_PROTOCOL_NOT_SUPPORTED (0x00010013)
-#define PL_LOGINFO_CODE_OPEN_FAILURE_STP_RESOURCES_BSY      (0x00010018)
-#define PL_LOGINFO_CODE_OPEN_FAILURE_WRONG_DESTINATION      (0x00010019)
-#define PL_LOGINFO_CODE_OPEN_FAILURE_ORR_TIMEOUT            (0X0001001A)
-#define PL_LOGINFO_CODE_OPEN_FAILURE_PATHWAY_BLOCKED        (0x0001001B)
-#define PL_LOGINFO_CODE_OPEN_FAILURE_AWT_MAXED              (0x0001001C)
-#define PL_LOGINFO_CODE_INVALID_SGL                         (0x00020000)
-#define PL_LOGINFO_CODE_WRONG_REL_OFF_OR_FRAME_LENGTH       (0x00030000)
-#define PL_LOGINFO_CODE_FRAME_XFER_ERROR                    (0x00040000)
-#define PL_LOGINFO_CODE_TX_FM_CONNECTED_LOW                 (0x00050000)
-#define PL_LOGINFO_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET         (0x00060000)
-#define PL_LOGINFO_CODE_SATA_READ_LOG_RECEIVE_DATA_ERR      (0x00070000)
-#define PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR     (0x00080000)
-#define PL_LOGINFO_CODE_SATA_ERR_IN_RCV_SET_DEV_BIT_FIS     (0x00090000)
-#define PL_LOGINFO_CODE_RX_FM_INVALID_MESSAGE               (0x000A0000)
-#define PL_LOGINFO_CODE_RX_CTX_MESSAGE_VALID_ERROR          (0x000B0000)
-#define PL_LOGINFO_CODE_RX_FM_CURRENT_FRAME_ERROR           (0x000C0000)
-#define PL_LOGINFO_CODE_SATA_LINK_DOWN                      (0x000D0000)
-#define PL_LOGINFO_CODE_DISCOVERY_SATA_INIT_W_IOS           (0x000E0000)
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE                 (0x000F0000)
-#define PL_LOGINFO_CODE_CONFIG_PL_NOT_INITIALIZED           (0x000F0001) /* PL not yet initialized, can't do config page req. */
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_PT              (0x000F0100) /* Invalid Page Type */
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NUM_PHYS        (0x000F0200) /* Invalid Number of Phys */
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NOT_IMP         (0x000F0300) /* Case Not Handled */
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NO_DEV          (0x000F0400) /* No Device Found */
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_FORM            (0x000F0500) /* Invalid FORM */
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_PHY             (0x000F0600) /* Invalid Phy */
-#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NO_OWNER        (0x000F0700) /* No Owner Found */
-#define PL_LOGINFO_CODE_DSCVRY_SATA_INIT_TIMEOUT            (0x00100000)
-#define PL_LOGINFO_CODE_RESET                               (0x00110000) /* See Sub-Codes below */
-#define PL_LOGINFO_CODE_ABORT                               (0x00120000) /* See Sub-Codes below */
-#define PL_LOGINFO_CODE_IO_NOT_YET_EXECUTED                 (0x00130000)
-#define PL_LOGINFO_CODE_IO_EXECUTED                         (0x00140000)
-#define PL_LOGINFO_CODE_PERS_RESV_OUT_NOT_AFFIL_OWNER       (0x00150000)
-#define PL_LOGINFO_CODE_OPEN_TXDMA_ABORT                    (0x00160000)
-#define PL_LOGINFO_CODE_IO_DEVICE_MISSING_DELAY_RETRY       (0x00170000)
-#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE                    (0x00000100)
-#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_NO_DEST_TIMEOUT    (0x00000101)
-#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ORR_TIMEOUT        (0x0000011A) /* Open Reject (Retry) Timeout */
-#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_PATHWAY_BLOCKED    (0x0000011B)
-#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_AWT_MAXED          (0x0000011C) /* Arbitration Wait Timer Maxed */
-
-#define PL_LOGINFO_SUB_CODE_TARGET_BUS_RESET                (0x00000120)
-#define PL_LOGINFO_SUB_CODE_TRANSPORT_LAYER                 (0x00000130)  /* Leave lower nibble (1-f) reserved. */
-#define PL_LOGINFO_SUB_CODE_PORT_LAYER                      (0x00000140)  /* Leave lower nibble (1-f) reserved. */
-
-
-#define PL_LOGINFO_SUB_CODE_INVALID_SGL                     (0x00000200)
-#define PL_LOGINFO_SUB_CODE_WRONG_REL_OFF_OR_FRAME_LENGTH   (0x00000300)
-#define PL_LOGINFO_SUB_CODE_FRAME_XFER_ERROR                (0x00000400)
-#define PL_LOGINFO_SUB_CODE_TX_FM_CONNECTED_LOW             (0x00000500)
-#define PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET     (0x00000600)
-#define PL_LOGINFO_SUB_CODE_SATA_READ_LOG_RECEIVE_DATA_ERR  (0x00000700)
-#define PL_LOGINFO_SUB_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR (0x00000800)
-#define PL_LOGINFO_SUB_CODE_SATA_ERR_IN_RCV_SET_DEV_BIT_FIS (0x00000900)
-#define PL_LOGINFO_SUB_CODE_RX_FM_INVALID_MESSAGE           (0x00000A00)
-#define PL_LOGINFO_SUB_CODE_RX_CTX_MESSAGE_VALID_ERROR      (0x00000B00)
-#define PL_LOGINFO_SUB_CODE_RX_FM_CURRENT_FRAME_ERROR       (0x00000C00)
-#define PL_LOGINFO_SUB_CODE_SATA_LINK_DOWN                  (0x00000D00)
-#define PL_LOGINFO_SUB_CODE_DISCOVERY_SATA_INIT_W_IOS       (0x00000E00)
-#define PL_LOGINFO_SUB_CODE_DISCOVERY_REMOTE_SEP_RESET      (0x00000E01)
-#define PL_LOGINFO_SUB_CODE_SECOND_OPEN                     (0x00000F00)
-#define PL_LOGINFO_SUB_CODE_DSCVRY_SATA_INIT_TIMEOUT        (0x00001000)
-
-
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_FAILURE         (0x00200000) /* Can't get SMP Frame */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR            (0x00200010) /* Error occured on SMP Read */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR           (0x00200020) /* Error occured on SMP Write */
-#define PL_LOGINFO_CODE_ENCL_MGMT_NOT_SUPPORTED_ON_ENCL     (0x00200040) /* Encl Mgmt services not available for this WWID */
-#define PL_LOGINFO_CODE_ENCL_MGMT_ADDR_MODE_NOT_SUPPORTED   (0x00200050) /* Address Mode not suppored */
-#define PL_LOGINFO_CODE_ENCL_MGMT_BAD_SLOT_NUM              (0x00200060) /* Invalid Slot Number in SEP Msg */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SGPIO_NOT_PRESENT         (0x00200070) /* SGPIO not present/enabled */
-#define PL_LOGINFO_CODE_ENCL_MGMT_GPIO_NOT_CONFIGURED       (0x00200080) /* GPIO not configured */
-#define PL_LOGINFO_CODE_ENCL_MGMT_GPIO_FRAME_ERROR          (0x00200090) /* GPIO can't allocate a frame */
-#define PL_LOGINFO_CODE_ENCL_MGMT_GPIO_CONFIG_PAGE_ERROR    (0x002000A0) /* GPIO failed config page request */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SES_FRAME_ALLOC_ERROR     (0x002000B0) /* Can't get frame for SES command */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SES_IO_ERROR              (0x002000C0) /* I/O execution error */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SES_RETRIES_EXHAUSTED     (0x002000D0) /* SEP I/O retries exhausted */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_ALLOC_ERROR     (0x002000E0) /* Can't get frame for SMP command */
-
-#define PL_LOGINFO_DA_SEP_NOT_PRESENT                       (0x00200100) /* SEP not present when msg received */
-#define PL_LOGINFO_DA_SEP_SINGLE_THREAD_ERROR               (0x00200101) /* Can only accept 1 msg at a time */
-#define PL_LOGINFO_DA_SEP_ISTWI_INTR_IN_IDLE_STATE          (0x00200102) /* ISTWI interrupt recvd. while IDLE */
-#define PL_LOGINFO_DA_SEP_RECEIVED_NACK_FROM_SLAVE          (0x00200103) /* SEP NACK'd, it is busy */
-#define PL_LOGINFO_DA_SEP_DID_NOT_RECEIVE_ACK               (0x00200104) /* SEP didn't rcv. ACK (Last Rcvd Bit = 1) */
-#define PL_LOGINFO_DA_SEP_BAD_STATUS_HDR_CHKSUM             (0x00200105) /* SEP stopped or sent bad chksum in Hdr */
-#define PL_LOGINFO_DA_SEP_STOP_ON_DATA                      (0x00200106) /* SEP stopped while transfering data */
-#define PL_LOGINFO_DA_SEP_STOP_ON_SENSE_DATA                (0x00200107) /* SEP stopped while transfering sense data */
-#define PL_LOGINFO_DA_SEP_UNSUPPORTED_SCSI_STATUS_1         (0x00200108) /* SEP returned unknown scsi status */
-#define PL_LOGINFO_DA_SEP_UNSUPPORTED_SCSI_STATUS_2         (0x00200109) /* SEP returned unknown scsi status */
-#define PL_LOGINFO_DA_SEP_CHKSUM_ERROR_AFTER_STOP           (0x0020010A) /* SEP returned bad chksum after STOP */
-#define PL_LOGINFO_DA_SEP_CHKSUM_ERROR_AFTER_STOP_GETDATA   (0x0020010B) /* SEP returned bad chksum after STOP while gettin data*/
-#define PL_LOGINFO_DA_SEP_UNSUPPORTED_COMMAND               (0x0020010C) /* SEP doesn't support CDB opcode */
+#define PL_LOGINFO_CODE_OPEN_FAILURE                         (0x00010000) /* see SUB_CODE_OPEN_FAIL_ below */
+
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_NO_DEST_TIME_OUT       (0x00000001)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_PATHWAY_BLOCKED        (0x00000002)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RES_CONTINUE0          (0x00000003)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RES_CONTINUE1          (0x00000004)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RES_INITIALIZE0        (0x00000005)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RES_INITIALIZE1        (0x00000006)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RES_STOP0              (0x00000007)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RES_STOP1              (0x00000008)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RETRY                  (0x00000009)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_BREAK                  (0x0000000A)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_UNUSED_0B              (0x0000000B)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_OPEN_TIMEOUT_EXP       (0x0000000C)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_UNUSED_0D              (0x0000000D)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_DVTBLE_ACCSS_FAIL      (0x0000000E)
+#define PL_LOGINFO_SUB CODE_OPEN_FAIL_BAD_DEST               (0x00000011)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RATE_NOT_SUPP          (0x00000012)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_PROT_NOT_SUPP          (0x00000013)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RESERVED_ABANDON0      (0x00000014)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RESERVED_ABANDON1      (0x00000015)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RESERVED_ABANDON2      (0x00000016)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_RESERVED_ABANDON3      (0x00000017)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_STP_RESOURCES_BSY      (0x00000018)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_WRONG_DESTINATION      (0x00000019)
+
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_PATH_BLOCKED           (0x0000001B) /* Retry Timeout */
+#define PL_LOGINFO_SUB_CODE_OPEN_FAIL_AWT_MAXED              (0x0000001C) /* Retry Timeout */
+
+
+
+#define PL_LOGINFO_CODE_INVALID_SGL                          (0x00020000)
+#define PL_LOGINFO_CODE_WRONG_REL_OFF_OR_FRAME_LENGTH        (0x00030000)
+#define PL_LOGINFO_CODE_FRAME_XFER_ERROR                     (0x00040000)
+#define PL_LOGINFO_CODE_TX_FM_CONNECTED_LOW                  (0x00050000)
+#define PL_LOGINFO_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET          (0x00060000)
+#define PL_LOGINFO_CODE_SATA_READ_LOG_RECEIVE_DATA_ERR       (0x00070000)
+#define PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR      (0x00080000)
+#define PL_LOGINFO_CODE_SATA_ERR_IN_RCV_SET_DEV_BIT_FIS      (0x00090000)
+#define PL_LOGINFO_CODE_RX_FM_INVALID_MESSAGE                (0x000A0000)
+#define PL_LOGINFO_CODE_RX_CTX_MESSAGE_VALID_ERROR           (0x000B0000)
+#define PL_LOGINFO_CODE_RX_FM_CURRENT_FRAME_ERROR            (0x000C0000)
+#define PL_LOGINFO_CODE_SATA_LINK_DOWN                       (0x000D0000)
+#define PL_LOGINFO_CODE_DISCOVERY_SATA_INIT_W_IOS            (0x000E0000)
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE                  (0x000F0000)
+#define PL_LOGINFO_CODE_CONFIG_PL_NOT_INITIALIZED            (0x000F0001) /* PL not yet initialized, can't do config page req. */
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_PT               (0x000F0100) /* Invalid Page Type */
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NUM_PHYS         (0x000F0200) /* Invalid Number of Phys */
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NOT_IMP          (0x000F0300) /* Case Not Handled */
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NO_DEV           (0x000F0400) /* No Device Found */
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_FORM             (0x000F0500) /* Invalid FORM */
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_PHY              (0x000F0600) /* Invalid Phy */
+#define PL_LOGINFO_CODE_CONFIG_INVALID_PAGE_NO_OWNER         (0x000F0700) /* No Owner Found */
+#define PL_LOGINFO_CODE_DSCVRY_SATA_INIT_TIMEOUT             (0x00100000)
+#define PL_LOGINFO_CODE_RESET                                (0x00110000) /* See Sub-Codes below (PL_LOGINFO_SUB_CODE) */
+#define PL_LOGINFO_CODE_ABORT                                (0x00120000) /* See Sub-Codes below  (PL_LOGINFO_SUB_CODE)*/
+#define PL_LOGINFO_CODE_IO_NOT_YET_EXECUTED                  (0x00130000)
+#define PL_LOGINFO_CODE_IO_EXECUTED                          (0x00140000)
+#define PL_LOGINFO_CODE_PERS_RESV_OUT_NOT_AFFIL_OWNER        (0x00150000)
+#define PL_LOGINFO_CODE_OPEN_TXDMA_ABORT                     (0x00160000)
+#define PL_LOGINFO_CODE_IO_DEVICE_MISSING_DELAY_RETRY        (0x00170000)
+#define PL_LOGINFO_CODE_IO_CANCELLED_DUE_TO_R_ERR            (0x00180000)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE                     (0x00000100)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_NO_DEST_TIMEOUT     (0x00000101)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_SATA_NEG_RATE_2HI   (0x00000102)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_RATE_NOT_SUPPORTED  (0x00000103)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_BREAK               (0x00000104)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ZONE_VIOLATION      (0x00000114)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ABANDON0            (0x00000114) /* Open Reject (Zone Violation) - available on SAS-2 devices */
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ABANDON1            (0x00000115)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ABANDON2            (0x00000116)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ABANDON3            (0x00000117)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ORR_TIMEOUT         (0x0000011A) /* Open Reject (Retry) Timeout */
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_PATH_BLOCKED        (0x0000011B)
+#define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_AWT_MAXED           (0x0000011C) /* Arbitration Wait Timer Maxed */
+
+#define PL_LOGINFO_SUB_CODE_TARGET_BUS_RESET                 (0x00000120)
+#define PL_LOGINFO_SUB_CODE_TRANSPORT_LAYER                  (0x00000130)  /* Leave lower nibble (1-f) reserved. */
+#define PL_LOGINFO_SUB_CODE_PORT_LAYER                       (0x00000140)  /* Leave lower nibble (1-f) reserved. */
+
+
+#define PL_LOGINFO_SUB_CODE_INVALID_SGL                      (0x00000200)
+#define PL_LOGINFO_SUB_CODE_WRONG_REL_OFF_OR_FRAME_LENGTH    (0x00000300)
+#define PL_LOGINFO_SUB_CODE_FRAME_XFER_ERROR                 (0x00000400) /* Bits 0-3 encode Transport Status Register (offset 0x08) */
+                                                                          /* Bit 0 is Status Bit 0: FrameXferErr */
+                                                                          /* Bit 1 & 2 are Status Bits 16 and 17: FrameXmitErrStatus */
+                                                                          /* Bit 3 is Status Bit 18 WriteDataLenghtGTDataLengthErr */
+
+#define PL_LOGINFO_SUB_CODE_TX_FM_CONNECTED_LOW              (0x00000500)
+#define PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET      (0x00000600)
+#define PL_LOGINFO_SUB_CODE_SATA_READ_LOG_RECEIVE_DATA_ERR   (0x00000700)
+#define PL_LOGINFO_SUB_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR  (0x00000800)
+#define PL_LOGINFO_SUB_CODE_SATA_ERR_IN_RCV_SET_DEV_BIT_FIS  (0x00000900)
+#define PL_LOGINFO_SUB_CODE_RX_FM_INVALID_MESSAGE            (0x00000A00)
+#define PL_LOGINFO_SUB_CODE_RX_CTX_MESSAGE_VALID_ERROR       (0x00000B00)
+#define PL_LOGINFO_SUB_CODE_RX_FM_CURRENT_FRAME_ERROR        (0x00000C00)
+#define PL_LOGINFO_SUB_CODE_SATA_LINK_DOWN                   (0x00000D00)
+#define PL_LOGINFO_SUB_CODE_DISCOVERY_SATA_INIT_W_IOS        (0x00000E00)
+#define PL_LOGINFO_SUB_CODE_DISCOVERY_REMOTE_SEP_RESET       (0x00000E01)
+#define PL_LOGINFO_SUB_CODE_SECOND_OPEN                      (0x00000F00)
+#define PL_LOGINFO_SUB_CODE_DSCVRY_SATA_INIT_TIMEOUT         (0x00001000)
+
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_FAILURE          (0x00200000) /* Can't get SMP Frame */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occured on SMP Read */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occured on SMP Write */
+#define PL_LOGINFO_CODE_ENCL_MGMT_NOT_SUPPORTED_ON_ENCL      (0x00200040) /* Encl Mgmt services not available for this WWID */
+#define PL_LOGINFO_CODE_ENCL_MGMT_ADDR_MODE_NOT_SUPPORTED    (0x00200050) /* Address Mode not suppored */
+#define PL_LOGINFO_CODE_ENCL_MGMT_BAD_SLOT_NUM               (0x00200060) /* Invalid Slot Number in SEP Msg */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SGPIO_NOT_PRESENT          (0x00200070) /* SGPIO not present/enabled */
+#define PL_LOGINFO_CODE_ENCL_MGMT_GPIO_NOT_CONFIGURED        (0x00200080) /* GPIO not configured */
+#define PL_LOGINFO_CODE_ENCL_MGMT_GPIO_FRAME_ERROR           (0x00200090) /* GPIO can't allocate a frame */
+#define PL_LOGINFO_CODE_ENCL_MGMT_GPIO_CONFIG_PAGE_ERROR     (0x002000A0) /* GPIO failed config page request */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SES_FRAME_ALLOC_ERROR      (0x002000B0) /* Can't get frame for SES command */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SES_IO_ERROR               (0x002000C0) /* I/O execution error */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SES_RETRIES_EXHAUSTED      (0x002000D0) /* SEP I/O retries exhausted */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_ALLOC_ERROR      (0x002000E0) /* Can't get frame for SMP command */
+
+#define PL_LOGINFO_DA_SEP_NOT_PRESENT                        (0x00200100) /* SEP not present when msg received */
+#define PL_LOGINFO_DA_SEP_SINGLE_THREAD_ERROR                (0x00200101) /* Can only accept 1 msg at a time */
+#define PL_LOGINFO_DA_SEP_ISTWI_INTR_IN_IDLE_STATE           (0x00200102) /* ISTWI interrupt recvd. while IDLE */
+#define PL_LOGINFO_DA_SEP_RECEIVED_NACK_FROM_SLAVE           (0x00200103) /* SEP NACK'd, it is busy */
+#define PL_LOGINFO_DA_SEP_DID_NOT_RECEIVE_ACK                (0x00200104) /* SEP didn't rcv. ACK (Last Rcvd Bit = 1) */
+#define PL_LOGINFO_DA_SEP_BAD_STATUS_HDR_CHKSUM              (0x00200105) /* SEP stopped or sent bad chksum in Hdr */
+#define PL_LOGINFO_DA_SEP_STOP_ON_DATA                       (0x00200106) /* SEP stopped while transfering data */
+#define PL_LOGINFO_DA_SEP_STOP_ON_SENSE_DATA                 (0x00200107) /* SEP stopped while transfering sense data */
+#define PL_LOGINFO_DA_SEP_UNSUPPORTED_SCSI_STATUS_1          (0x00200108) /* SEP returned unknown scsi status */
+#define PL_LOGINFO_DA_SEP_UNSUPPORTED_SCSI_STATUS_2          (0x00200109) /* SEP returned unknown scsi status */
+#define PL_LOGINFO_DA_SEP_CHKSUM_ERROR_AFTER_STOP            (0x0020010A) /* SEP returned bad chksum after STOP */
+#define PL_LOGINFO_DA_SEP_CHKSUM_ERROR_AFTER_STOP_GETDATA    (0x0020010B) /* SEP returned bad chksum after STOP while gettin data*/
+#define PL_LOGINFO_DA_SEP_UNSUPPORTED_COMMAND                (0x0020010C) /* SEP doesn't support CDB opcode f/w location 1 */
+#define PL_LOGINFO_DA_SEP_UNSUPPORTED_COMMAND_2              (0x0020010D) /* SEP doesn't support CDB opcode f/w location 2 */
+#define PL_LOGINFO_DA_SEP_UNSUPPORTED_COMMAND_3              (0x0020010E) /* SEP doesn't support CDB opcode f/w location 3 */
 
 
 /****************************************************************************/
diff -uarpN b/drivers/message/fusion/lsi/mpi_sas.h a/drivers/message/fusion/lsi/mpi_sas.h
--- b/drivers/message/fusion/lsi/mpi_sas.h	2006-11-29 14:57:37.000000000 -0700
+++ a/drivers/message/fusion/lsi/mpi_sas.h	2007-01-05 16:52:08.000000000 -0700
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2004 LSI Logic Corporation.
+ *  Copyright (c) 2004-2006 LSI Logic Corporation.
  *
  *
  *           Name:  mpi_sas.h
  *          Title:  MPI Serial Attached SCSI structures and definitions
  *  Creation Date:  August 19, 2004
  *
- *    mpi_sas.h Version:  01.05.03
+ *    mpi_sas.h Version:  01.05.04
  *
  *  Version History
  *  ---------------
@@ -21,6 +21,8 @@
  *                      and Remove Device operations to SAS IO Unit Control.
  *                      Added DevHandle field to SAS IO Unit Control request and
  *                      reply.
+ *  10-11-06  01.05.04  Fixed the name of a define for Operation field of SAS IO
+ *                      Unit Control request.
  *  --------------------------------------------------------------------------
  */
 
@@ -237,7 +239,8 @@ typedef struct _MSG_SAS_IOUNIT_CONTROL_R
 #define MPI_SAS_OP_SEND_PRIMITIVE               (0x0A)
 #define MPI_SAS_OP_FORCE_FULL_DISCOVERY         (0x0B)
 #define MPI_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL  (0x0C)
-#define MPI_SAS_OP_TRANSMIT_REMOVE_DEVICE       (0x0D)
+#define MPI_SAS_OP_TRANSMIT_REMOVE_DEVICE       (0x0D)  /* obsolete name */
+#define MPI_SAS_OP_REMOVE_DEVICE                (0x0D)
 
 /* values for the PrimFlags field */
 #define MPI_SAS_PRIMFLAGS_SINGLE                (0x08)
