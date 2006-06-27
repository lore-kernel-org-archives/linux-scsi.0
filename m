From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 2/2] fusion : mpi header update
Date: Tue, 27 Jun 2006 14:39:06 -0600
Message-ID: <20060627203905.GB24983@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46258 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161286AbWF0Utu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 16:49:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

MPI Header Update

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/lsi/fc_log.h a/drivers/message/fusion/lsi/fc_log.h
--- b/drivers/message/fusion/lsi/fc_log.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/fc_log.h	1969-12-31 17:00:00.000000000 -0700
@@ -1,89 +0,0 @@
-/*
- *  Copyright (c) 2000-2001 LSI Logic Corporation. All rights reserved.
- *
- *  NAME:           fc_log.h
- *  SUMMARY:        MPI IocLogInfo definitions for the SYMFC9xx chips
- *  DESCRIPTION:    Contains the enumerated list of values that may be returned
- *                  in the IOCLogInfo field of a MPI Default Reply Message.
- *
- *  CREATION DATE:  6/02/2000
- *  ID:             $Id: fc_log.h,v 4.6 2001/07/26 14:41:33 sschremm Exp $
- */
-
-
-/*
- * MpiIocLogInfo_t enum
- *
- * These 32 bit values are used in the IOCLogInfo field of the MPI reply
- * messages.
- * The value is 0xabcccccc where
- *          a = The type of log info as per the MPI spec. Since these codes are
- *              all for Fibre Channel this value will always be 2.
- *          b = Specifies a subclass of the firmware where
- *                  0 = FCP Initiator
- *                  1 = FCP Target
- *                  2 = LAN
- *                  3 = MPI Message Layer
- *                  4 = FC Link
- *                  5 = Context Manager
- *                  6 = Invalid Field Offset
- *                  7 = State Change Info
- *                  all others are reserved for future use
- *          c = A specific value within the subclass.
- *
- * NOTE: Any new values should be added to the end of each subclass so that the
- *       codes remain consistent across firmware releases.
- */
-typedef enum _MpiIocLogInfoFc
-{
-    MPI_IOCLOGINFO_FC_INIT_BASE                     = 0x20000000,
-    MPI_IOCLOGINFO_FC_INIT_ERROR_OUT_OF_ORDER_FRAME = 0x20000001, /* received an out of order frame - unsupported */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_BAD_START_OF_FRAME = 0x20000002, /* Bad Rx Frame, bad start of frame primative */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_BAD_END_OF_FRAME   = 0x20000003, /* Bad Rx Frame, bad end of frame primative */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_OVER_RUN           = 0x20000004, /* Bad Rx Frame, overrun */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_OTHER           = 0x20000005, /* Other errors caught by IOC which require retries */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_SUBPROC_DEAD       = 0x20000006, /* Main processor could not initialize sub-processor */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_OVERRUN         = 0x20000007, /* Scatter Gather overrun  */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_BAD_STATUS      = 0x20000008, /* Receiver detected context mismatch via invalid header */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_UNEXPECTED_FRAME= 0x20000009, /* CtxMgr detected unsupported frame type  */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_LINK_FAILURE       = 0x2000000A, /* Link failure occurred  */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_TX_TIMEOUT         = 0x2000000B, /* Transmitter timeout error */
-
-    MPI_IOCLOGINFO_FC_TARGET_BASE                   = 0x21000000,
-    MPI_IOCLOGINFO_FC_TARGET_NO_PDISC               = 0x21000001, /* not sent because we are waiting for a PDISC from the initiator */
-    MPI_IOCLOGINFO_FC_TARGET_NO_LOGIN               = 0x21000002, /* not sent because we are not logged in to the remote node */
-    MPI_IOCLOGINFO_FC_TARGET_DOAR_KILLED_BY_LIP     = 0x21000003, /* Data Out, Auto Response, not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DIAR_KILLED_BY_LIP     = 0x21000004, /* Data In, Auto Response, not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DIAR_MISSING_DATA      = 0x21000005, /* Data In, Auto Response, missing data frames */
-    MPI_IOCLOGINFO_FC_TARGET_DONR_KILLED_BY_LIP     = 0x21000006, /* Data Out, No Response, not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_WRSP_KILLED_BY_LIP     = 0x21000007, /* Auto-response after a write not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DINR_KILLED_BY_LIP     = 0x21000008, /* Data In, No Response, not completed due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DINR_MISSING_DATA      = 0x21000009, /* Data In, No Response, missing data frames */
-    MPI_IOCLOGINFO_FC_TARGET_MRSP_KILLED_BY_LIP     = 0x2100000a, /* Manual Response not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_NO_CLASS_3             = 0x2100000b, /* not sent because remote node does not support Class 3 */
-    MPI_IOCLOGINFO_FC_TARGET_LOGIN_NOT_VALID        = 0x2100000c, /* not sent because login to remote node not validated */
-    MPI_IOCLOGINFO_FC_TARGET_FROM_OUTBOUND          = 0x2100000e, /* cleared from the outbound queue after a logout */
-    MPI_IOCLOGINFO_FC_TARGET_WAITING_FOR_DATA_IN    = 0x2100000f, /* cleared waiting for data after a logout */
-
-    MPI_IOCLOGINFO_FC_LAN_BASE                      = 0x22000000,
-    MPI_IOCLOGINFO_FC_LAN_TRANS_SGL_MISSING         = 0x22000001, /* Transaction Context Sgl Missing */
-    MPI_IOCLOGINFO_FC_LAN_TRANS_WRONG_PLACE         = 0x22000002, /* Transaction Context found before an EOB */
-    MPI_IOCLOGINFO_FC_LAN_TRANS_RES_BITS_SET        = 0x22000003, /* Transaction Context value has reserved bits set */
-    MPI_IOCLOGINFO_FC_LAN_WRONG_SGL_FLAG            = 0x22000004, /* Invalid SGL Flags */
-
-    MPI_IOCLOGINFO_FC_MSG_BASE                      = 0x23000000,
-
-    MPI_IOCLOGINFO_FC_LINK_BASE                     = 0x24000000,
-    MPI_IOCLOGINFO_FC_LINK_LOOP_INIT_TIMEOUT        = 0x24000001, /* Loop initialization timed out */
-    MPI_IOCLOGINFO_FC_LINK_ALREADY_INITIALIZED      = 0x24000002, /* Another system controller already initialized the loop */
-    MPI_IOCLOGINFO_FC_LINK_LINK_NOT_ESTABLISHED     = 0x24000003, /* Not synchronized to signal or still negotiating (possible cable problem) */
-    MPI_IOCLOGINFO_FC_LINK_CRC_ERROR                = 0x24000004, /* CRC check detected error on received frame */
-
-    MPI_IOCLOGINFO_FC_CTX_BASE                      = 0x25000000,
-
-    MPI_IOCLOGINFO_FC_INVALID_FIELD_BYTE_OFFSET     = 0x26000000, /* The lower 24 bits give the byte offset of the field in the request message that is invalid */
-    MPI_IOCLOGINFO_FC_INVALID_FIELD_MAX_OFFSET      = 0x26ffffff,
-
-    MPI_IOCLOGINFO_FC_STATE_CHANGE                  = 0x27000000  /* The lower 24 bits give additional information concerning state change */
-
-} MpiIocLogInfoFc_t;
diff -uarN b/drivers/message/fusion/lsi/mpi.h a/drivers/message/fusion/lsi/mpi.h
--- b/drivers/message/fusion/lsi/mpi.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi.h	2006-05-08 11:20:02.000000000 -0600
@@ -6,7 +6,7 @@
  *          Title:  MPI Message independent structures and definitions
  *  Creation Date:  July 27, 2000
  *
- *    mpi.h Version:  01.05.10
+ *    mpi.h Version:  01.05.11
  *
  *  Version History
  *  ---------------
@@ -76,6 +76,7 @@
  *                      Added EEDP IOCStatus codes.
  *  08-03-05  01.05.09  Bumped MPI_HEADER_VERSION_UNIT.
  *  08-30-05  01.05.10  Added 2 new IOCStatus codes for Target.
+ *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
  */
 
@@ -106,7 +107,7 @@
 /* Note: The major versions of 0xe0 through 0xff are reserved */
 
 /* versioning for this MPI header set */
-#define MPI_HEADER_VERSION_UNIT             (0x0C)
+#define MPI_HEADER_VERSION_UNIT             (0x0D)
 #define MPI_HEADER_VERSION_DEV              (0x00)
 #define MPI_HEADER_VERSION_UNIT_MASK        (0xFF00)
 #define MPI_HEADER_VERSION_UNIT_SHIFT       (8)
diff -uarN b/drivers/message/fusion/lsi/mpi_cnfg.h a/drivers/message/fusion/lsi/mpi_cnfg.h
--- b/drivers/message/fusion/lsi/mpi_cnfg.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_cnfg.h	2006-05-08 11:20:02.000000000 -0600
@@ -6,7 +6,7 @@
  *          Title:  MPI Config message, structures, and Pages
  *  Creation Date:  July 27, 2000
  *
- *    mpi_cnfg.h Version:  01.05.11
+ *    mpi_cnfg.h Version:  01.05.12
  *
  *  Version History
  *  ---------------
@@ -266,6 +266,16 @@
  *                      Added postpone SATA Init bit to SAS IO Unit Page 1
  *                      ControlFlags.
  *                      Changed LogEntry format for Log Page 0.
+ *  03-27-06  01.05.12  Added two new Flags defines for Manufacturing Page 4.
+ *                      Added Manufacturing Page 7.
+ *                      Added MPI_IOCPAGE2_CAP_FLAGS_RAID_64_BIT_ADDRESSING.
+ *                      Added IOC Page 6.
+ *                      Added PrevBootDeviceForm field to CONFIG_PAGE_BIOS_2.
+ *                      Added MaxLBAHigh field to RAID Volume Page 0.
+ *                      Added Nvdata version fields to SAS IO Unit Page 0.
+ *                      Added AdditionalControlFlags, MaxTargetPortConnectTime,
+ *                      ReportDeviceMissingDelay, and IODeviceMissingDelay
+ *                      fields to SAS IO Unit Page 1.
  *  --------------------------------------------------------------------------
  */
 
@@ -631,9 +641,11 @@
 } CONFIG_PAGE_MANUFACTURING_4, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_4,
   ManufacturingPage4_t, MPI_POINTER pManufacturingPage4_t;
 
-#define MPI_MANUFACTURING4_PAGEVERSION                  (0x03)
+#define MPI_MANUFACTURING4_PAGEVERSION                  (0x04)
 
 /* defines for the Flags field */
+#define MPI_MANPAGE4_FORCE_BAD_BLOCK_TABLE              (0x80)
+#define MPI_MANPAGE4_FORCE_OFFLINE_FAILOVER             (0x40)
 #define MPI_MANPAGE4_IME_DISABLE                        (0x20)
 #define MPI_MANPAGE4_IM_DISABLE                         (0x10)
 #define MPI_MANPAGE4_IS_DISABLE                         (0x08)
@@ -668,6 +680,66 @@
 #define MPI_MANUFACTURING6_PAGEVERSION                  (0x00)
 
 
+typedef struct _MPI_MANPAGE7_CONNECTOR_INFO
+{
+    U32                         Pinout;                 /* 00h */
+    U8                          Connector[16];          /* 04h */
+    U8                          Location;               /* 14h */
+    U8                          Reserved1;              /* 15h */
+    U16                         Slot;                   /* 16h */
+    U32                         Reserved2;              /* 18h */
+} MPI_MANPAGE7_CONNECTOR_INFO, MPI_POINTER PTR_MPI_MANPAGE7_CONNECTOR_INFO,
+  MpiManPage7ConnectorInfo_t, MPI_POINTER pMpiManPage7ConnectorInfo_t;
+
+/* defines for the Pinout field */
+#define MPI_MANPAGE7_PINOUT_SFF_8484_L4                 (0x00080000)
+#define MPI_MANPAGE7_PINOUT_SFF_8484_L3                 (0x00040000)
+#define MPI_MANPAGE7_PINOUT_SFF_8484_L2                 (0x00020000)
+#define MPI_MANPAGE7_PINOUT_SFF_8484_L1                 (0x00010000)
+#define MPI_MANPAGE7_PINOUT_SFF_8470_L4                 (0x00000800)
+#define MPI_MANPAGE7_PINOUT_SFF_8470_L3                 (0x00000400)
+#define MPI_MANPAGE7_PINOUT_SFF_8470_L2                 (0x00000200)
+#define MPI_MANPAGE7_PINOUT_SFF_8470_L1                 (0x00000100)
+#define MPI_MANPAGE7_PINOUT_SFF_8482                    (0x00000002)
+#define MPI_MANPAGE7_PINOUT_CONNECTION_UNKNOWN          (0x00000001)
+
+/* defines for the Location field */
+#define MPI_MANPAGE7_LOCATION_UNKNOWN                   (0x01)
+#define MPI_MANPAGE7_LOCATION_INTERNAL                  (0x02)
+#define MPI_MANPAGE7_LOCATION_EXTERNAL                  (0x04)
+#define MPI_MANPAGE7_LOCATION_SWITCHABLE                (0x08)
+#define MPI_MANPAGE7_LOCATION_AUTO                      (0x10)
+#define MPI_MANPAGE7_LOCATION_NOT_PRESENT               (0x20)
+#define MPI_MANPAGE7_LOCATION_NOT_CONNECTED             (0x80)
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check NumPhys at runtime.
+ */
+#ifndef MPI_MANPAGE7_CONNECTOR_INFO_MAX
+#define MPI_MANPAGE7_CONNECTOR_INFO_MAX   (1)
+#endif
+
+typedef struct _CONFIG_PAGE_MANUFACTURING_7
+{
+    CONFIG_PAGE_HEADER          Header;                 /* 00h */
+    U32                         Reserved1;              /* 04h */
+    U32                         Reserved2;              /* 08h */
+    U32                         Flags;                  /* 0Ch */
+    U8                          EnclosureName[16];      /* 10h */
+    U8                          NumPhys;                /* 20h */
+    U8                          Reserved3;              /* 21h */
+    U16                         Reserved4;              /* 22h */
+    MPI_MANPAGE7_CONNECTOR_INFO ConnectorInfo[MPI_MANPAGE7_CONNECTOR_INFO_MAX]; /* 24h */
+} CONFIG_PAGE_MANUFACTURING_7, MPI_POINTER PTR_CONFIG_PAGE_MANUFACTURING_7,
+  ManufacturingPage7_t, MPI_POINTER pManufacturingPage7_t;
+
+#define MPI_MANUFACTURING7_PAGEVERSION                  (0x00)
+
+/* defines for the Flags field */
+#define MPI_MANPAGE7_FLAG_USE_SLOT_INFO                 (0x00000001)
+
+
 /****************************************************************************
 *   IO Unit Config Pages
 ****************************************************************************/
@@ -867,7 +939,7 @@
 } CONFIG_PAGE_IOC_2, MPI_POINTER PTR_CONFIG_PAGE_IOC_2,
   IOCPage2_t, MPI_POINTER pIOCPage2_t;
 
-#define MPI_IOCPAGE2_PAGEVERSION                        (0x03)
+#define MPI_IOCPAGE2_PAGEVERSION                        (0x04)
 
 /* IOC Page 2 Capabilities flags */
 
@@ -878,6 +950,7 @@
 #define MPI_IOCPAGE2_CAP_FLAGS_RAID_6_SUPPORT           (0x00000010)
 #define MPI_IOCPAGE2_CAP_FLAGS_RAID_10_SUPPORT          (0x00000020)
 #define MPI_IOCPAGE2_CAP_FLAGS_RAID_50_SUPPORT          (0x00000040)
+#define MPI_IOCPAGE2_CAP_FLAGS_RAID_64_BIT_ADDRESSING   (0x10000000)
 #define MPI_IOCPAGE2_CAP_FLAGS_SES_SUPPORT              (0x20000000)
 #define MPI_IOCPAGE2_CAP_FLAGS_SAFTE_SUPPORT            (0x40000000)
 #define MPI_IOCPAGE2_CAP_FLAGS_CROSS_CHANNEL_SUPPORT    (0x80000000)
@@ -975,6 +1048,44 @@
 
 #define MPI_IOCPAGE5_PAGEVERSION                        (0x00)
 
+typedef struct _CONFIG_PAGE_IOC_6
+{
+    CONFIG_PAGE_HEADER          Header;                         /* 00h */
+    U32                         CapabilitiesFlags;              /* 04h */
+    U8                          MaxDrivesIS;                    /* 08h */
+    U8                          MaxDrivesIM;                    /* 09h */
+    U8                          MaxDrivesIME;                   /* 0Ah */
+    U8                          Reserved1;                      /* 0Bh */
+    U8                          MinDrivesIS;                    /* 0Ch */
+    U8                          MinDrivesIM;                    /* 0Dh */
+    U8                          MinDrivesIME;                   /* 0Eh */
+    U8                          Reserved2;                      /* 0Fh */
+    U8                          MaxGlobalHotSpares;             /* 10h */
+    U8                          Reserved3;                      /* 11h */
+    U16                         Reserved4;                      /* 12h */
+    U32                         Reserved5;                      /* 14h */
+    U32                         SupportedStripeSizeMapIS;       /* 18h */
+    U32                         SupportedStripeSizeMapIME;      /* 1Ch */
+    U32                         Reserved6;                      /* 20h */
+    U8                          MetadataSize;                   /* 24h */
+    U8                          Reserved7;                      /* 25h */
+    U16                         Reserved8;                      /* 26h */
+    U16                         MaxBadBlockTableEntries;        /* 28h */
+    U16                         Reserved9;                      /* 2Ah */
+    U16                         IRNvsramUsage;                  /* 2Ch */
+    U16                         Reserved10;                     /* 2Eh */
+    U32                         IRNvsramVersion;                /* 30h */
+    U32                         Reserved11;                     /* 34h */
+    U32                         Reserved12;                     /* 38h */
+} CONFIG_PAGE_IOC_6, MPI_POINTER PTR_CONFIG_PAGE_IOC_6,
+  IOCPage6_t, MPI_POINTER pIOCPage6_t;
+
+#define MPI_IOCPAGE6_PAGEVERSION                        (0x00)
+
+/* IOC Page 6 Capabilities Flags */
+
+#define MPI_IOCPAGE6_CAP_FLAGS_GLOBAL_HOT_SPARE         (0x00000001)
+
 
 /****************************************************************************
 *   BIOS Config Pages
@@ -1218,13 +1329,13 @@
     U32                         Reserved5;              /* 14h */
     U32                         Reserved6;              /* 18h */
     U8                          BootDeviceForm;         /* 1Ch */
-    U8                          Reserved7;              /* 1Dh */
+    U8                          PrevBootDeviceForm;     /* 1Ch */
     U16                         Reserved8;              /* 1Eh */
     MPI_BIOSPAGE2_BOOT_DEVICE   BootDevice;             /* 20h */
 } CONFIG_PAGE_BIOS_2, MPI_POINTER PTR_CONFIG_PAGE_BIOS_2,
   BIOSPage2_t, MPI_POINTER pBIOSPage2_t;
 
-#define MPI_BIOSPAGE2_PAGEVERSION                       (0x01)
+#define MPI_BIOSPAGE2_PAGEVERSION                       (0x02)
 
 #define MPI_BIOSPAGE2_FORM_MASK                         (0x0F)
 #define MPI_BIOSPAGE2_FORM_ADAPTER_ORDER                (0x00)
@@ -2080,7 +2191,7 @@
     RAID_VOL0_STATUS        VolumeStatus;   /* 08h */
     RAID_VOL0_SETTINGS      VolumeSettings; /* 0Ch */
     U32                     MaxLBA;         /* 10h */
-    U32                     Reserved1;      /* 14h */
+    U32                     MaxLBAHigh;     /* 14h */
     U32                     StripeSize;     /* 18h */
     U32                     Reserved2;      /* 1Ch */
     U32                     Reserved3;      /* 20h */
@@ -2092,7 +2203,7 @@
 } CONFIG_PAGE_RAID_VOL_0, MPI_POINTER PTR_CONFIG_PAGE_RAID_VOL_0,
   RaidVolumePage0_t, MPI_POINTER pRaidVolumePage0_t;
 
-#define MPI_RAIDVOLPAGE0_PAGEVERSION                    (0x05)
+#define MPI_RAIDVOLPAGE0_PAGEVERSION                    (0x06)
 
 /* values for RAID Volume Page 0 InactiveStatus field */
 #define MPI_RAIDVOLPAGE0_UNKNOWN_INACTIVE               (0x00)
@@ -2324,7 +2435,8 @@
 typedef struct _CONFIG_PAGE_SAS_IO_UNIT_0
 {
     CONFIG_EXTENDED_PAGE_HEADER     Header;                             /* 00h */
-    U32                             Reserved1;                          /* 08h */
+    U16                             NvdataVersionDefault;               /* 08h */
+    U16                             NvdataVersionPersistent;            /* 0Ah */
     U8                              NumPhys;                            /* 0Ch */
     U8                              Reserved2;                          /* 0Dh */
     U16                             Reserved3;                          /* 0Eh */
@@ -2332,7 +2444,7 @@
 } CONFIG_PAGE_SAS_IO_UNIT_0, MPI_POINTER PTR_CONFIG_PAGE_SAS_IO_UNIT_0,
   SasIOUnitPage0_t, MPI_POINTER pSasIOUnitPage0_t;
 
-#define MPI_SASIOUNITPAGE0_PAGEVERSION      (0x03)
+#define MPI_SASIOUNITPAGE0_PAGEVERSION      (0x04)
 
 /* values for SAS IO Unit Page 0 PortFlags */
 #define MPI_SAS_IOUNIT0_PORT_FLAGS_DISCOVERY_IN_PROGRESS    (0x08)
@@ -2373,12 +2485,13 @@
 
 typedef struct _MPI_SAS_IO_UNIT1_PHY_DATA
 {
-    U8          Port;                   /* 00h */
-    U8          PortFlags;              /* 01h */
-    U8          PhyFlags;               /* 02h */
-    U8          MaxMinLinkRate;         /* 03h */
-    U32         ControllerPhyDeviceInfo;/* 04h */
-    U32         Reserved1;              /* 08h */
+    U8          Port;                       /* 00h */
+    U8          PortFlags;                  /* 01h */
+    U8          PhyFlags;                   /* 02h */
+    U8          MaxMinLinkRate;             /* 03h */
+    U32         ControllerPhyDeviceInfo;    /* 04h */
+    U16         MaxTargetPortConnectTime;   /* 08h */
+    U16         Reserved1;                  /* 0Ah */
 } MPI_SAS_IO_UNIT1_PHY_DATA, MPI_POINTER PTR_MPI_SAS_IO_UNIT1_PHY_DATA,
   SasIOUnit1PhyData, MPI_POINTER pSasIOUnit1PhyData;
 
@@ -2395,15 +2508,17 @@
     CONFIG_EXTENDED_PAGE_HEADER Header;                             /* 00h */
     U16                         ControlFlags;                       /* 08h */
     U16                         MaxNumSATATargets;                  /* 0Ah */
-    U32                         Reserved1;                          /* 0Ch */
+    U16                         AdditionalControlFlags;             /* 0Ch */
+    U16                         Reserved1;                          /* 0Eh */
     U8                          NumPhys;                            /* 10h */
     U8                          SATAMaxQDepth;                      /* 11h */
-    U16                         Reserved2;                          /* 12h */
+    U8                          ReportDeviceMissingDelay;           /* 12h */
+    U8                          IODeviceMissingDelay;               /* 13h */
     MPI_SAS_IO_UNIT1_PHY_DATA   PhyData[MPI_SAS_IOUNIT1_PHY_MAX];   /* 14h */
 } CONFIG_PAGE_SAS_IO_UNIT_1, MPI_POINTER PTR_CONFIG_PAGE_SAS_IO_UNIT_1,
   SasIOUnitPage1_t, MPI_POINTER pSasIOUnitPage1_t;
 
-#define MPI_SASIOUNITPAGE1_PAGEVERSION      (0x05)
+#define MPI_SASIOUNITPAGE1_PAGEVERSION      (0x06)
 
 /* values for SAS IO Unit Page 1 ControlFlags */
 #define MPI_SAS_IOUNIT1_CONTROL_DEVICE_SELF_TEST            (0x8000)
@@ -2428,6 +2543,13 @@
 #define MPI_SAS_IOUNIT1_CONTROL_FIRST_LVL_DISC_ONLY         (0x0002)
 #define MPI_SAS_IOUNIT1_CONTROL_CLEAR_AFFILIATION           (0x0001)
 
+/* values for SAS IO Unit Page 1 AdditionalControlFlags */
+#define MPI_SAS_IOUNIT1_ACONTROL_ALLOW_TABLE_TO_TABLE       (0x0001)
+
+/* defines for SAS IO Unit Page 1 ReportDeviceMissingDelay */
+#define MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK         (0x7F)
+#define MPI_SAS_IOUNIT1_REPORT_MISSING_UNIT_16              (0x80)
+
 /* values for SAS IO Unit Page 1 PortFlags */
 #define MPI_SAS_IOUNIT1_PORT_FLAGS_0_TARGET_IOC_NUM         (0x00)
 #define MPI_SAS_IOUNIT1_PORT_FLAGS_1_TARGET_IOC_NUM         (0x04)
diff -uarN b/drivers/message/fusion/lsi/mpi_history.txt a/drivers/message/fusion/lsi/mpi_history.txt
--- b/drivers/message/fusion/lsi/mpi_history.txt	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_history.txt	2006-05-08 11:20:02.000000000 -0600
@@ -6,25 +6,25 @@
  Copyright (c) 2000-2005 LSI Logic Corporation.
 
  ---------------------------------------
- Header Set Release Version:    01.05.12
- Header Set Release Date:       08-30-05
+ Header Set Release Version:    01.05.13
+ Header Set Release Date:       03-27-06
  ---------------------------------------
 
  Filename               Current version     Prior version
  ----------             ---------------     -------------
- mpi.h                  01.05.10            01.05.09
- mpi_ioc.h              01.05.10            01.05.09
- mpi_cnfg.h             01.05.11            01.05.10
- mpi_init.h             01.05.06            01.05.06
- mpi_targ.h             01.05.05            01.05.05
+ mpi.h                  01.05.11            01.05.10
+ mpi_ioc.h              01.05.11            01.05.10
+ mpi_cnfg.h             01.05.12            01.05.11
+ mpi_init.h             01.05.07            01.05.06
+ mpi_targ.h             01.05.06            01.05.05
  mpi_fc.h               01.05.01            01.05.01
  mpi_lan.h              01.05.01            01.05.01
  mpi_raid.h             01.05.02            01.05.02
  mpi_tool.h             01.05.03            01.05.03
  mpi_inb.h              01.05.01            01.05.01
- mpi_sas.h              01.05.02            01.05.01
- mpi_type.h             01.05.02            01.05.01
- mpi_history.txt        01.05.12            01.05.11
+ mpi_sas.h              01.05.03            01.05.02
+ mpi_type.h             01.05.02            01.05.02
+ mpi_history.txt        01.05.13            01.05.12
 
 
  *  Date      Version   Description
@@ -93,6 +93,7 @@
  *                      Added EEDP IOCStatus codes.
  *  08-03-05  01.05.09  Bumped MPI_HEADER_VERSION_UNIT.
  *  08-30-05  01.05.10  Added 2 new IOCStatus codes for Target.
+ *  03-27-06  01.05.11  Bumped MPI_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
 
 mpi_ioc.h
@@ -170,6 +171,17 @@
  *                      Added new ReasonCode value for SAS Device Status Change
  *                      event.
  *                      Added new family code for FC949E.
+ *  03-27-06  01.05.11  Added MPI_IOCFACTS_CAPABILITY_TLR.
+ *                      Added additional Reason Codes and more event data fields
+ *                      to EVENT_DATA_SAS_DEVICE_STATUS_CHANGE.
+ *                      Added EVENT_DATA_SAS_BROADCAST_PRIMITIVE structure and
+ *                      new event.
+ *                      Added MPI_EVENT_SAS_SMP_ERROR and event data structure.
+ *                      Added MPI_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE and event
+ *                      data structure.
+ *                      Added MPI_EVENT_SAS_INIT_TABLE_OVERFLOW and event
+ *                      data structure.
+ *                      Added MPI_EXT_IMAGE_TYPE_INITIALIZATION.
  *  --------------------------------------------------------------------------
 
 mpi_cnfg.h
@@ -425,6 +437,16 @@
  *                      Added postpone SATA Init bit to SAS IO Unit Page 1
  *                      ControlFlags.
  *                      Changed LogEntry format for Log Page 0.
+ *  03-27-06  01.05.12  Added two new Flags defines for Manufacturing Page 4.
+ *                      Added Manufacturing Page 7.
+ *                      Added MPI_IOCPAGE2_CAP_FLAGS_RAID_64_BIT_ADDRESSING.
+ *                      Added IOC Page 6.
+ *                      Added PrevBootDeviceForm field to CONFIG_PAGE_BIOS_2.
+ *                      Added MaxLBAHigh field to RAID Volume Page 0.
+ *                      Added Nvdata version fields to SAS IO Unit Page 0.
+ *                      Added AdditionalControlFlags, MaxTargetPortConnectTime,
+ *                      ReportDeviceMissingDelay, and IODeviceMissingDelay
+ *                      fields to SAS IO Unit Page 1.
  *  --------------------------------------------------------------------------
 
 mpi_init.h
@@ -467,6 +489,7 @@
  *                      Added four new defines for SEP SlotStatus.
  *  08-03-05  01.05.06  Fixed some MPI_SCSIIO32_MSGFLGS_ defines to make them
  *                      unique in the first 32 characters.
+ *  03-27-06  01.05.07  Added Task Management type of Clear ACA.
  *  --------------------------------------------------------------------------
 
 mpi_targ.h
@@ -511,6 +534,7 @@
  *  02-22-05  01.05.03  Changed a comment.
  *  03-11-05  01.05.04  Removed TargetAssistExtended Request.
  *  06-24-05  01.05.05  Added TargetAssistExtended structures and defines.
+ *  03-27-06  01.05.06  Added a comment.
  *  --------------------------------------------------------------------------
 
 mpi_fc.h
@@ -610,6 +634,10 @@
  *  08-30-05  01.05.02  Added DeviceInfo bit for SEP.
  *                      Added PrimFlags and Primitive field to SAS IO Unit
  *                      Control request, and added a new operation code.
+ *  03-27-06  01.05.03  Added Force Full Discovery, Transmit Port Select Signal,
+ *                      and Remove Device operations to SAS IO Unit Control.
+ *                      Added DevHandle field to SAS IO Unit Control request and
+ *                      reply.
  *  --------------------------------------------------------------------------
 
 mpi_type.h
@@ -625,20 +653,20 @@
 
 mpi_history.txt         Parts list history
 
-Filename    01.05.12  01.05.11  01.05.10  01.05.09
-----------  --------  --------  --------  --------
-mpi.h       01.05.10  01.05.09  01.05.08  01.05.07
-mpi_ioc.h   01.05.10  01.05.09  01.05.09  01.05.08
-mpi_cnfg.h  01.05.11  01.05.10  01.05.09  01.05.08
-mpi_init.h  01.05.06  01.05.06  01.05.05  01.05.04
-mpi_targ.h  01.05.05  01.05.05  01.05.05  01.05.04
-mpi_fc.h    01.05.01  01.05.01  01.05.01  01.05.01
-mpi_lan.h   01.05.01  01.05.01  01.05.01  01.05.01
-mpi_raid.h  01.05.02  01.05.02  01.05.02  01.05.02
-mpi_tool.h  01.05.03  01.05.03  01.05.03  01.05.03
-mpi_inb.h   01.05.01  01.05.01  01.05.01  01.05.01
-mpi_sas.h   01.05.02  01.05.01  01.05.01  01.05.01
-mpi_type.h  01.05.02  01.05.01  01.05.01  01.05.01
+Filename    01.05.13  01.05.12  01.05.11  01.05.10  01.05.09
+----------  --------  --------  --------  --------  --------
+mpi.h       01.05.11  01.05.10  01.05.09  01.05.08  01.05.07
+mpi_ioc.h   01.05.11  01.05.10  01.05.09  01.05.09  01.05.08
+mpi_cnfg.h  01.05.12  01.05.11  01.05.10  01.05.09  01.05.08
+mpi_init.h  01.05.07  01.05.06  01.05.06  01.05.05  01.05.04
+mpi_targ.h  01.05.06  01.05.05  01.05.05  01.05.05  01.05.04
+mpi_fc.h    01.05.01  01.05.01  01.05.01  01.05.01  01.05.01
+mpi_lan.h   01.05.01  01.05.01  01.05.01  01.05.01  01.05.01
+mpi_raid.h  01.05.02  01.05.02  01.05.02  01.05.02  01.05.02
+mpi_tool.h  01.05.03  01.05.03  01.05.03  01.05.03  01.05.03
+mpi_inb.h   01.05.01  01.05.01  01.05.01  01.05.01  01.05.01
+mpi_sas.h   01.05.03  01.05.02  01.05.01  01.05.01  01.05.01
+mpi_type.h  01.05.02  01.05.02  01.05.01  01.05.01  01.05.01
 
 Filename    01.05.08   01.05.07   01.05.06   01.05.05   01.05.04   01.05.03
 ----------  --------   --------   --------   --------   --------   --------
diff -uarN b/drivers/message/fusion/lsi/mpi_init.h a/drivers/message/fusion/lsi/mpi_init.h
--- b/drivers/message/fusion/lsi/mpi_init.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_init.h	2006-05-08 11:20:02.000000000 -0600
@@ -6,7 +6,7 @@
  *          Title:  MPI initiator mode messages and structures
  *  Creation Date:  June 8, 2000
  *
- *    mpi_init.h Version:  01.05.06
+ *    mpi_init.h Version:  01.05.07
  *
  *  Version History
  *  ---------------
@@ -52,6 +52,7 @@
  *                      Added four new defines for SEP SlotStatus.
  *  08-03-05  01.05.06  Fixed some MPI_SCSIIO32_MSGFLGS_ defines to make them
  *                      unique in the first 32 characters.
+ *  03-27-06  01.05.07  Added Task Management type of Clear ACA.
  *  --------------------------------------------------------------------------
  */
 
@@ -427,6 +428,7 @@
 #define MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET    (0x05)
 #define MPI_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET        (0x06)
 #define MPI_SCSITASKMGMT_TASKTYPE_QUERY_TASK            (0x07)
+#define MPI_SCSITASKMGMT_TASKTYPE_CLEAR_ACA             (0x08)
 
 /* MsgFlags bits */
 #define MPI_SCSITASKMGMT_MSGFLAGS_TARGET_RESET_OPTION   (0x00)
diff -uarN b/drivers/message/fusion/lsi/mpi_ioc.h a/drivers/message/fusion/lsi/mpi_ioc.h
--- b/drivers/message/fusion/lsi/mpi_ioc.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_ioc.h	2006-05-08 11:20:02.000000000 -0600
@@ -6,7 +6,7 @@
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  *  Creation Date:  August 11, 2000
  *
- *    mpi_ioc.h Version:  01.05.10
+ *    mpi_ioc.h Version:  01.05.11
  *
  *  Version History
  *  ---------------
@@ -87,6 +87,17 @@
  *                      Added new ReasonCode value for SAS Device Status Change
  *                      event.
  *                      Added new family code for FC949E.
+ *  03-27-06  01.05.11  Added MPI_IOCFACTS_CAPABILITY_TLR.
+ *                      Added additional Reason Codes and more event data fields
+ *                      to EVENT_DATA_SAS_DEVICE_STATUS_CHANGE.
+ *                      Added EVENT_DATA_SAS_BROADCAST_PRIMITIVE structure and
+ *                      new event.
+ *                      Added MPI_EVENT_SAS_SMP_ERROR and event data structure.
+ *                      Added MPI_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE and event
+ *                      data structure.
+ *                      Added MPI_EVENT_SAS_INIT_TABLE_OVERFLOW and event
+ *                      data structure.
+ *                      Added MPI_EXT_IMAGE_TYPE_INITIALIZATION.
  *  --------------------------------------------------------------------------
  */
 
@@ -272,6 +283,7 @@
 #define MPI_IOCFACTS_CAPABILITY_MULTICAST               (0x00000100)
 #define MPI_IOCFACTS_CAPABILITY_SCSIIO32                (0x00000200)
 #define MPI_IOCFACTS_CAPABILITY_NO_SCSIIO16             (0x00000400)
+#define MPI_IOCFACTS_CAPABILITY_TLR                     (0x00000800)
 
 
 /*****************************************************************************
@@ -448,30 +460,34 @@
 
 /* Event */
 
-#define MPI_EVENT_NONE                      (0x00000000)
-#define MPI_EVENT_LOG_DATA                  (0x00000001)
-#define MPI_EVENT_STATE_CHANGE              (0x00000002)
-#define MPI_EVENT_UNIT_ATTENTION            (0x00000003)
-#define MPI_EVENT_IOC_BUS_RESET             (0x00000004)
-#define MPI_EVENT_EXT_BUS_RESET             (0x00000005)
-#define MPI_EVENT_RESCAN                    (0x00000006)
-#define MPI_EVENT_LINK_STATUS_CHANGE        (0x00000007)
-#define MPI_EVENT_LOOP_STATE_CHANGE         (0x00000008)
-#define MPI_EVENT_LOGOUT                    (0x00000009)
-#define MPI_EVENT_EVENT_CHANGE              (0x0000000A)
-#define MPI_EVENT_INTEGRATED_RAID           (0x0000000B)
-#define MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE (0x0000000C)
-#define MPI_EVENT_ON_BUS_TIMER_EXPIRED      (0x0000000D)
-#define MPI_EVENT_QUEUE_FULL                (0x0000000E)
-#define MPI_EVENT_SAS_DEVICE_STATUS_CHANGE  (0x0000000F)
-#define MPI_EVENT_SAS_SES                   (0x00000010)
-#define MPI_EVENT_PERSISTENT_TABLE_FULL     (0x00000011)
-#define MPI_EVENT_SAS_PHY_LINK_STATUS       (0x00000012)
-#define MPI_EVENT_SAS_DISCOVERY_ERROR       (0x00000013)
-#define MPI_EVENT_IR_RESYNC_UPDATE          (0x00000014)
-#define MPI_EVENT_IR2                       (0x00000015)
-#define MPI_EVENT_SAS_DISCOVERY             (0x00000016)
-#define MPI_EVENT_LOG_ENTRY_ADDED           (0x00000021)
+#define MPI_EVENT_NONE                          (0x00000000)
+#define MPI_EVENT_LOG_DATA                      (0x00000001)
+#define MPI_EVENT_STATE_CHANGE                  (0x00000002)
+#define MPI_EVENT_UNIT_ATTENTION                (0x00000003)
+#define MPI_EVENT_IOC_BUS_RESET                 (0x00000004)
+#define MPI_EVENT_EXT_BUS_RESET                 (0x00000005)
+#define MPI_EVENT_RESCAN                        (0x00000006)
+#define MPI_EVENT_LINK_STATUS_CHANGE            (0x00000007)
+#define MPI_EVENT_LOOP_STATE_CHANGE             (0x00000008)
+#define MPI_EVENT_LOGOUT                        (0x00000009)
+#define MPI_EVENT_EVENT_CHANGE                  (0x0000000A)
+#define MPI_EVENT_INTEGRATED_RAID               (0x0000000B)
+#define MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE     (0x0000000C)
+#define MPI_EVENT_ON_BUS_TIMER_EXPIRED          (0x0000000D)
+#define MPI_EVENT_QUEUE_FULL                    (0x0000000E)
+#define MPI_EVENT_SAS_DEVICE_STATUS_CHANGE      (0x0000000F)
+#define MPI_EVENT_SAS_SES                       (0x00000010)
+#define MPI_EVENT_PERSISTENT_TABLE_FULL         (0x00000011)
+#define MPI_EVENT_SAS_PHY_LINK_STATUS           (0x00000012)
+#define MPI_EVENT_SAS_DISCOVERY_ERROR           (0x00000013)
+#define MPI_EVENT_IR_RESYNC_UPDATE              (0x00000014)
+#define MPI_EVENT_IR2                           (0x00000015)
+#define MPI_EVENT_SAS_DISCOVERY                 (0x00000016)
+#define MPI_EVENT_SAS_BROADCAST_PRIMITIVE       (0x00000017)
+#define MPI_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE (0x00000018)
+#define MPI_EVENT_SAS_INIT_TABLE_OVERFLOW       (0x00000019)
+#define MPI_EVENT_SAS_SMP_ERROR                 (0x0000001A)
+#define MPI_EVENT_LOG_ENTRY_ADDED               (0x00000021)
 
 /* AckRequired field values */
 
@@ -558,18 +574,25 @@
     U8                      PhyNum;                     /* 0Eh */
     U8                      Reserved1;                  /* 0Fh */
     U64                     SASAddress;                 /* 10h */
+    U8                      LUN[8];                     /* 18h */
+    U16                     TaskTag;                    /* 20h */
+    U16                     Reserved2;                  /* 22h */
 } EVENT_DATA_SAS_DEVICE_STATUS_CHANGE,
   MPI_POINTER PTR_EVENT_DATA_SAS_DEVICE_STATUS_CHANGE,
   MpiEventDataSasDeviceStatusChange_t,
   MPI_POINTER pMpiEventDataSasDeviceStatusChange_t;
 
 /* MPI SAS Device Status Change Event data ReasonCode values */
-#define MPI_EVENT_SAS_DEV_STAT_RC_ADDED                 (0x03)
-#define MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING        (0x04)
-#define MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA            (0x05)
-#define MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED      (0x06)
-#define MPI_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED           (0x07)
-#define MPI_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET (0x08)
+#define MPI_EVENT_SAS_DEV_STAT_RC_ADDED                     (0x03)
+#define MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING            (0x04)
+#define MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA                (0x05)
+#define MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED          (0x06)
+#define MPI_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED               (0x07)
+#define MPI_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET     (0x08)
+#define MPI_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL       (0x09)
+#define MPI_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL   (0x0A)
+#define MPI_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL   (0x0B)
+#define MPI_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL       (0x0C)
 
 
 /* SCSI Event data for Queue Full event */
@@ -742,6 +765,27 @@
 } EVENT_DATA_SAS_SES, MPI_POINTER PTR_EVENT_DATA_SAS_SES,
   MpiEventDataSasSes_t, MPI_POINTER pMpiEventDataSasSes_t;
 
+/* SAS Broadcast Primitive Event data */
+
+typedef struct _EVENT_DATA_SAS_BROADCAST_PRIMITIVE
+{
+    U8                      PhyNum;                     /* 00h */
+    U8                      Port;                       /* 01h */
+    U8                      PortWidth;                  /* 02h */
+    U8                      Primitive;                  /* 04h */
+} EVENT_DATA_SAS_BROADCAST_PRIMITIVE,
+  MPI_POINTER PTR_EVENT_DATA_SAS_BROADCAST_PRIMITIVE,
+  MpiEventDataSasBroadcastPrimitive_t,
+  MPI_POINTER pMpiEventDataSasBroadcastPrimitive_t;
+
+#define MPI_EVENT_PRIMITIVE_CHANGE              (0x01)
+#define MPI_EVENT_PRIMITIVE_EXPANDER            (0x03)
+#define MPI_EVENT_PRIMITIVE_RESERVED2           (0x04)
+#define MPI_EVENT_PRIMITIVE_RESERVED3           (0x05)
+#define MPI_EVENT_PRIMITIVE_RESERVED4           (0x06)
+#define MPI_EVENT_PRIMITIVE_CHANGE0_RESERVED    (0x07)
+#define MPI_EVENT_PRIMITIVE_CHANGE1_RESERVED    (0x08)
+
 /* SAS Phy Link Status Event data */
 
 typedef struct _EVENT_DATA_SAS_PHY_LINK_STATUS
@@ -804,6 +848,53 @@
 #define MPI_EVENT_DSCVRY_ERR_DS_MULTPL_PATHS                (0x00000800)
 #define MPI_EVENT_DSCVRY_ERR_DS_MAX_SATA_TARGETS            (0x00001000)
 
+/* SAS SMP Error Event data */
+
+typedef struct _EVENT_DATA_SAS_SMP_ERROR
+{
+    U8                      Status;                     /* 00h */
+    U8                      Port;                       /* 01h */
+    U8                      SMPFunctionResult;          /* 02h */
+    U8                      Reserved1;                  /* 03h */
+    U64                     SASAddress;                 /* 04h */
+} EVENT_DATA_SAS_SMP_ERROR, MPI_POINTER PTR_EVENT_DATA_SAS_SMP_ERROR,
+  MpiEventDataSasSmpError_t, MPI_POINTER pMpiEventDataSasSmpError_t;
+
+/* defines for the Status field of the SAS SMP Error event */
+#define MPI_EVENT_SAS_SMP_FUNCTION_RESULT_VALID         (0x00)
+#define MPI_EVENT_SAS_SMP_CRC_ERROR                     (0x01)
+#define MPI_EVENT_SAS_SMP_TIMEOUT                       (0x02)
+#define MPI_EVENT_SAS_SMP_NO_DESTINATION                (0x03)
+#define MPI_EVENT_SAS_SMP_BAD_DESTINATION               (0x04)
+
+/* SAS Initiator Device Status Change Event data */
+
+typedef struct _EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE
+{
+    U8                      ReasonCode;                 /* 00h */
+    U8                      Port;                       /* 01h */
+    U16                     DevHandle;                  /* 02h */
+    U64                     SASAddress;                 /* 04h */
+} EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE,
+  MPI_POINTER PTR_EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE,
+  MpiEventDataSasInitDevStatusChange_t,
+  MPI_POINTER pMpiEventDataSasInitDevStatusChange_t;
+
+/* defines for the ReasonCode field of the SAS Initiator Device Status Change event */
+#define MPI_EVENT_SAS_INIT_RC_ADDED                 (0x01)
+
+/* SAS Initiator Device Table Overflow Event data */
+
+typedef struct _EVENT_DATA_SAS_INIT_TABLE_OVERFLOW
+{
+    U8                      MaxInit;                    /* 00h */
+    U8                      CurrentInit;                /* 01h */
+    U16                     Reserved1;                  /* 02h */
+} EVENT_DATA_SAS_INIT_TABLE_OVERFLOW,
+  MPI_POINTER PTR_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW,
+  MpiEventDataSasInitTableOverflow_t,
+  MPI_POINTER pMpiEventDataSasInitTableOverflow_t;
+
 
 /*****************************************************************************
 *
@@ -1013,5 +1104,6 @@
 #define MPI_EXT_IMAGE_TYPE_FW                   (0x01)
 #define MPI_EXT_IMAGE_TYPE_NVDATA               (0x03)
 #define MPI_EXT_IMAGE_TYPE_BOOTLOADER           (0x04)
+#define MPI_EXT_IMAGE_TYPE_INITIALIZATION       (0x05)
 
 #endif
diff -uarN b/drivers/message/fusion/lsi/mpi_log_sas.h a/drivers/message/fusion/lsi/mpi_log_sas.h
--- b/drivers/message/fusion/lsi/mpi_log_sas.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_log_sas.h	2006-05-22 17:15:25.000000000 -0600
@@ -13,6 +13,8 @@
 #ifndef IOPI_IOCLOGINFO_H_INCLUDED
 #define IOPI_IOCLOGINFO_H_INCLUDED
 
+#define SAS_LOGINFO_NEXUS_LOSS		0x31170000
+#define SAS_LOGINFO_MASK			0xFFFF0000
 
 /****************************************************************************/
 /*  IOC LOGINFO defines, 0x00000000 - 0x0FFFFFFF                            */
@@ -51,6 +53,9 @@
 #define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_DNM        (0x00030500) /* Device Not Mapped */
 #define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_PERSIST    (0x00030600) /* Persistent Page not found */
 #define IOP_LOGINFO_CODE_CONFIG_INVALID_PAGE_DEFAULT    (0x00030700) /* Default Page not found */
+
+#define IOP_LOGINFO_CODE_DIAG_MSG_ERROR                 (0x00040000) /* Error handling diag msg - or'd with diag status */
+
 #define IOP_LOGINFO_CODE_TASK_TERMINATED                (0x00050000)
 
 #define IOP_LOGINFO_CODE_ENCL_MGMT_READ_ACTION_ERR0R    (0x00060001) /* Read Action not supported for SEP msg */
@@ -103,6 +108,7 @@
 #define PL_LOGINFO_CODE_IO_EXECUTED                         (0x00140000)
 #define PL_LOGINFO_CODE_PERS_RESV_OUT_NOT_AFFIL_OWNER       (0x00150000)
 #define PL_LOGINFO_CODE_OPEN_TXDMA_ABORT                    (0x00160000)
+#define PL_LOGINFO_CODE_IO_DEVICE_MISSING_DELAY_RETRY       (0x00170000)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAILURE                    (0x00000100)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_NO_DEST_TIMEOUT    (0x00000101)
 #define PL_LOGINFO_SUB_CODE_OPEN_FAILURE_ORR_TIMEOUT        (0x0000011A) /* Open Reject (Retry) Timeout */
@@ -165,11 +171,81 @@
 /****************************************************************************/
 /* IR LOGINFO_CODE defines, valid if IOC_LOGINFO_ORIGINATOR = IR            */
 /****************************************************************************/
-#define IR_LOGINFO_CODE_UNUSED1                         (0x00010000)
-#define IR_LOGINFO_CODE_UNUSED2                         (0x00020000)
+#define IR_LOGINFO_RAID_ACTION_ERROR                           (0x00010000)
+#define IR_LOGINFO_CODE_UNUSED2                                (0x00020000)
+
+/* Amount of information passed down for Create Volume is too large */
+#define IR_LOGINFO_VOLUME_CREATE_INVALID_LENGTH                (0x00010001)
+/* Creation of duplicate volume attempted (Bus/Target ID checked) */
+#define IR_LOGINFO_VOLUME_CREATE_DUPLICATE                     (0x00010002)
+/* Creation failed due to maximum number of supported volumes exceeded */
+#define IR_LOGINFO_VOLUME_CREATE_NO_SLOTS                      (0x00010003)
+/* Creation failed due to DMA error in trying to read from host */
+#define IR_LOGINFO_VOLUME_CREATE_DMA_ERROR                     (0x00010004)
+/* Creation failed due to invalid volume type passed down */
+#define IR_LOGINFO_VOLUME_CREATE_INVALID_VOLUME_TYPE           (0x00010005)
+/* Creation failed due to error reading MFG Page 4 */
+#define IR_LOGINFO_VOLUME_MFG_PAGE4_ERROR                      (0x00010006)
+/* Creation failed when trying to create internal structures */
+#define IR_LOGINFO_VOLUME_INTERNAL_CONFIG_STRUCTURE_ERROR      (0x00010007)
+
+/* Activation failed due to trying to activate an already active volume */
+#define IR_LOGINFO_VOLUME_ACTIVATING_AN_ACTIVE_VOLUME          (0x00010010)
+/* Activation failed due to trying to active unsupported volume type  */
+#define IR_LOGINFO_VOLUME_ACTIVATING_INVALID_VOLUME_TYPE       (0x00010011)
+/* Activation failed due to trying to active too many volumes  */
+#define IR_LOGINFO_VOLUME_ACTIVATING_TOO_MANY_VOLUMES          (0x00010012)
+/* Activation failed due to Volume ID in use already */
+#define IR_LOGINFO_VOLUME_ACTIVATING_VOLUME_ID_IN_USE          (0x00010013)
+/* Activation failed call to activateVolume returned failure */
+#define IR_LOGINFO_VOLUME_ACTIVATE_VOLUME_FAILED               (0x00010014)
+/* Activation failed trying to import the volume */
+#define IR_LOGINFO_VOLUME_ACTIVATING_IMPORT_VOLUME_FAILED      (0x00010015)
+
+/* Phys Disk failed, too many phys disks */
+#define IR_LOGINFO_PHYSDISK_CREATE_TOO_MANY_DISKS              (0x00010020)
+/* Amount of information passed down for Create Pnysdisk is too large */
+#define IR_LOGINFO_PHYSDISK_CREATE_INVALID_LENGTH              (0x00010021)
+/* Creation failed due to DMA error in trying to read from host */
+#define IR_LOGINFO_PHYSDISK_CREATE_DMA_ERROR                   (0x00010022)
+/* Creation failed due to invalid Bus TargetID passed down */
+#define IR_LOGINFO_PHYSDISK_CREATE_BUS_TID_INVALID             (0x00010023)
+/* Creation failed due to error in creating RAID Phys Disk Config Page */
+#define IR_LOGINFO_PHYSDISK_CREATE_CONFIG_PAGE_ERROR           (0x00010024)
+
+
+/* Compatibility Error : IR Disabled */
+#define IR_LOGINFO_COMPAT_ERROR_RAID_DISABLED                  (0x00010030)
+/* Compatibility Error : Inquiry Comand failed */
+#define IR_LOGINFO_COMPAT_ERROR_INQUIRY_FAILED                 (0x00010031)
+/* Compatibility Error : Device not direct access device */
+#define IR_LOGINFO_COMPAT_ERROR_NOT_DIRECT_ACCESS              (0x00010032)
+/* Compatibility Error : Removable device found */
+#define IR_LOGINFO_COMPAT_ERROR_REMOVABLE_FOUND                (0x00010033)
+/* Compatibility Error : Device SCSI Version not 2 or higher */
+#define IR_LOGINFO_COMPAT_ERROR_NEED_SCSI_2_OR_HIGHER          (0x00010034)
+/* Compatibility Error : SATA device, 48 BIT LBA not supported */
+#define IR_LOGINFO_COMPAT_ERROR_SATA_48BIT_LBA_NOT_SUPPORTED   (0x00010035)
+/* Compatibility Error : Device does not have 512 byte block sizes */
+#define IR_LOGINFO_COMPAT_ERROR_DEVICE_NOT_512_BYTE_BLOCK      (0x00010036)
+/* Compatibility Error : Volume Type check failed */
+#define IR_LOGINFO_COMPAT_ERROR_VOLUME_TYPE_CHECK_FAILED       (0x00010037)
+/* Compatibility Error : Volume Type is unsupported by FW */
+#define IR_LOGINFO_COMPAT_ERROR_UNSUPPORTED_VOLUME_TYPE        (0x00010038)
+/* Compatibility Error : Disk drive too small for use in volume */
+#define IR_LOGINFO_COMPAT_ERROR_DISK_TOO_SMALL                 (0x00010039)
+/* Compatibility Error : Phys disk for Create Volume not found */
+#define IR_LOGINFO_COMPAT_ERROR_PHYS_DISK_NOT_FOUND            (0x0001003A)
+/* Compatibility Error : membership count error, too many or too few disks for volume type */
+#define IR_LOGINFO_COMPAT_ERROR_MEMBERSHIP_COUNT               (0x0001003B)
+/* Compatibility Error : Disk stripe sizes must be 64KB */
+#define IR_LOGINFO_COMPAT_ERROR_NON_64K_STRIPE_SIZE            (0x0001003C)
+/* Compatibility Error : IME size limited to < 2TB */
+#define IR_LOGINFO_COMPAT_ERROR_IME_VOL_NOT_CURRENTLY_SUPPORTED (0x0001003D)
+
 
 /****************************************************************************/
-/* Defines for convienence                                                  */
+/* Defines for convenience                                                  */
 /****************************************************************************/
 #define IOC_LOGINFO_PREFIX_IOP                          ((MPI_IOCLOGINFO_TYPE_SAS << MPI_IOCLOGINFO_TYPE_SHIFT) | IOC_LOGINFO_ORIGINATOR_IOP)
 #define IOC_LOGINFO_PREFIX_PL                           ((MPI_IOCLOGINFO_TYPE_SAS << MPI_IOCLOGINFO_TYPE_SHIFT) | IOC_LOGINFO_ORIGINATOR_PL)
diff -uarN b/drivers/message/fusion/lsi/mpi_sas.h a/drivers/message/fusion/lsi/mpi_sas.h
--- b/drivers/message/fusion/lsi/mpi_sas.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_sas.h	2006-05-08 11:20:02.000000000 -0600
@@ -6,7 +6,7 @@
  *          Title:  MPI Serial Attached SCSI structures and definitions
  *  Creation Date:  August 19, 2004
  *
- *    mpi_sas.h Version:  01.05.02
+ *    mpi_sas.h Version:  01.05.03
  *
  *  Version History
  *  ---------------
@@ -17,6 +17,10 @@
  *  08-30-05  01.05.02  Added DeviceInfo bit for SEP.
  *                      Added PrimFlags and Primitive field to SAS IO Unit
  *                      Control request, and added a new operation code.
+ *  03-27-06  01.05.03  Added Force Full Discovery, Transmit Port Select Signal,
+ *                      and Remove Device operations to SAS IO Unit Control.
+ *                      Added DevHandle field to SAS IO Unit Control request and
+ *                      reply.
  *  --------------------------------------------------------------------------
  */
 
@@ -209,7 +213,7 @@
     U8                      Reserved1;          /* 01h */
     U8                      ChainOffset;        /* 02h */
     U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
+    U16                     DevHandle;          /* 04h */
     U8                      Reserved3;          /* 06h */
     U8                      MsgFlags;           /* 07h */
     U32                     MsgContext;         /* 08h */
@@ -231,6 +235,9 @@
 #define MPI_SAS_OP_PHY_CLEAR_ERROR_LOG          (0x08)
 #define MPI_SAS_OP_MAP_CURRENT                  (0x09)
 #define MPI_SAS_OP_SEND_PRIMITIVE               (0x0A)
+#define MPI_SAS_OP_FORCE_FULL_DISCOVERY         (0x0B)
+#define MPI_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL  (0x0C)
+#define MPI_SAS_OP_TRANSMIT_REMOVE_DEVICE       (0x0D)
 
 /* values for the PrimFlags field */
 #define MPI_SAS_PRIMFLAGS_SINGLE                (0x08)
@@ -245,7 +252,7 @@
     U8                      Reserved1;          /* 01h */
     U8                      MsgLength;          /* 02h */
     U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
+    U16                     DevHandle;          /* 04h */
     U8                      Reserved3;          /* 06h */
     U8                      MsgFlags;           /* 07h */
     U32                     MsgContext;         /* 08h */
diff -uarN b/drivers/message/fusion/lsi/mpi_targ.h a/drivers/message/fusion/lsi/mpi_targ.h
--- b/drivers/message/fusion/lsi/mpi_targ.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/lsi/mpi_targ.h	2006-05-08 11:20:02.000000000 -0600
@@ -6,7 +6,7 @@
  *          Title:  MPI Target mode messages and structures
  *  Creation Date:  June 22, 2000
  *
- *    mpi_targ.h Version:  01.05.05
+ *    mpi_targ.h Version:  01.05.06
  *
  *  Version History
  *  ---------------
@@ -54,6 +54,7 @@
  *  02-22-05  01.05.03  Changed a comment.
  *  03-11-05  01.05.04  Removed TargetAssistExtended Request.
  *  06-24-05  01.05.05  Added TargetAssistExtended structures and defines.
+ *  03-27-06  01.05.06  Added a comment.
  *  --------------------------------------------------------------------------
  */
 
@@ -351,7 +352,7 @@
 #define TARGET_ASSIST_FLAGS_CONFIRMED               (0x08)
 #define TARGET_ASSIST_FLAGS_REPOST_CMD_BUFFER       (0x80)
 
-
+/* Standard Target Mode Reply message */
 typedef struct _MSG_TARGET_ERROR_REPLY
 {
     U16                     Reserved;                   /* 00h */
