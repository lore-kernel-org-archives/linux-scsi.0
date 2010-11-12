From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 06/11] mpt2sas: MPI 2.0 Header updated
Date: Sat, 13 Nov 2010 04:36:14 +0530
Message-ID: <20101112230606.GH853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:46050 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073Ab0KLXsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:48:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

MPI2 Rev header files.

1) Removed Task Set Full Event. Modified description of Disable SCSI
Initiator Task Set Full Handling bit in the Flags field of IO Unit
Page 1. Modified the descriptions for the three queue depth fields in
SAS IO Unit Page 1.
(2) Added new value for the Current Operation bits of the Flags field
in the RAID Volume Indicator Structure to indicate that the Make Data
Consistent operation is running.
(3) Added a value of 0x6 to various SAS link rate fields to indicate an
attached PHY that is not using any commonly supported settings.
(4) Added Volume Not Consistent bit to the VolumeStatusFlags field of
RAID Volume Page 0.
(5) Added a new value for the IncompatibleReason field of RAID Physical
Disk Page 0 to indicate an incompatible media type.
(6) Added Diagnostic Data Upload tool for the Toolbox Request.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
index 4b1c2f0..8be75e6 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                  scatter/gather formats.
  *  Creation Date:  June 21, 2006
  *
- *  mpi2.h Version:  02.00.15
+ *  mpi2.h Version:  02.00.16
  *
  *  Version History
  *  ---------------
@@ -61,6 +61,8 @@
  *                      Added define for MPI2_FUNCTION_PWR_MGMT_CONTROL.
  *                      Added defines for product-specific range of message
  *                      function codes, 0xF0 to 0xFF.
+ *  05-12-10  02.00.16  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Added alternative defines for the SGE Direction bit.
  *  --------------------------------------------------------------------------
  */
 
@@ -86,7 +88,7 @@
 #define MPI2_VERSION_02_00                  (0x0200)
 
 /* versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x0F)
+#define MPI2_HEADER_VERSION_UNIT            (0x10)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
@@ -929,6 +931,9 @@ typedef struct _MPI2_MPI_SGE_UNION
 #define MPI2_SGE_FLAGS_IOC_TO_HOST              (0x00)
 #define MPI2_SGE_FLAGS_HOST_TO_IOC              (0x04)
 
+#define MPI2_SGE_FLAGS_DEST                     (MPI2_SGE_FLAGS_IOC_TO_HOST)
+#define MPI2_SGE_FLAGS_SOURCE                   (MPI2_SGE_FLAGS_HOST_TO_IOC)
+
 /* Address Size */
 
 #define MPI2_SGE_FLAGS_32_BIT_ADDRESSING        (0x00)
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
index e3728d7..d76a658 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Configuration messages and pages
  *  Creation Date:  November 10, 2006
  *
- *    mpi2_cnfg.h Version:  02.00.14
+ *    mpi2_cnfg.h Version:  02.00.15
  *
  *  Version History
  *  ---------------
@@ -121,6 +121,10 @@
  *                      Added MPI2_CONFIG_PAGE_SASIOUNIT_6 and related defines.
  *                      Added MPI2_CONFIG_PAGE_SASIOUNIT_7 and related defines.
  *                      Added MPI2_CONFIG_PAGE_SASIOUNIT_8 and related defines.
+ *  05-12-10  02.00.15  Added MPI2_RAIDVOL0_STATUS_FLAG_VOL_NOT_CONSISTENT
+ *                      define.
+ *                      Added MPI2_PHYSDISK0_INCOMPATIBLE_MEDIA_TYPE define.
+ *                      Added MPI2_SAS_NEG_LINK_RATE_UNSUPPORTED_PHY define.
  *  --------------------------------------------------------------------------
  */
 
@@ -333,7 +337,7 @@ typedef struct _MPI2_CONFIG_REQUEST
 #define MPI2_CONFIG_ACTION_PAGE_READ_NVRAM          (0x06)
 #define MPI2_CONFIG_ACTION_PAGE_GET_CHANGEABLE      (0x07)
 
-/* values for SGLFlags field are in the SGL section of mpi2.h */
+/* use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
 
 
 /* Config Reply Message */
@@ -379,6 +383,8 @@ typedef struct _MPI2_CONFIG_REPLY
 #define MPI2_MFGPAGE_DEVID_SAS2116_1                (0x0064)
 #define MPI2_MFGPAGE_DEVID_SAS2116_2                (0x0065)
 
+#define MPI2_MFGPAGE_DEVID_SSS6200                  (0x007E)
+
 #define MPI2_MFGPAGE_DEVID_SAS2208_1                (0x0080)
 #define MPI2_MFGPAGE_DEVID_SAS2208_2                (0x0081)
 #define MPI2_MFGPAGE_DEVID_SAS2208_3                (0x0082)
@@ -390,6 +396,8 @@ typedef struct _MPI2_CONFIG_REPLY
 #define MPI2_MFGPAGE_DEVID_SAS2308_3                (0x006E)
 
 
+
+
 /* Manufacturing Page 0 */
 
 typedef struct _MPI2_CONFIG_PAGE_MAN_0
@@ -729,6 +737,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1
 /* IO Unit Page 1 Flags defines */
 #define MPI2_IOUNITPAGE1_ENABLE_HOST_BASED_DISCOVERY    (0x00000800)
 #define MPI2_IOUNITPAGE1_MASK_SATA_WRITE_CACHE          (0x00000600)
+#define MPI2_IOUNITPAGE1_SATA_WRITE_CACHE_SHIFT         (9)
 #define MPI2_IOUNITPAGE1_ENABLE_SATA_WRITE_CACHE        (0x00000000)
 #define MPI2_IOUNITPAGE1_DISABLE_SATA_WRITE_CACHE       (0x00000200)
 #define MPI2_IOUNITPAGE1_UNCHANGED_SATA_WRITE_CACHE     (0x00000400)
@@ -1347,6 +1356,7 @@ typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_0
 #define MPI2_RAIDVOL0_STATUS_FLAG_CAPACITY_EXPANSION        (0x00040000)
 #define MPI2_RAIDVOL0_STATUS_FLAG_BACKGROUND_INIT           (0x00020000)
 #define MPI2_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS        (0x00010000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_VOL_NOT_CONSISTENT        (0x00000080)
 #define MPI2_RAIDVOL0_STATUS_FLAG_OCE_ALLOWED               (0x00000040)
 #define MPI2_RAIDVOL0_STATUS_FLAG_BGI_COMPLETE              (0x00000020)
 #define MPI2_RAIDVOL0_STATUS_FLAG_1E_OFFSET_MIRROR          (0x00000000)
@@ -1469,11 +1479,15 @@ typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_0
 #define MPI2_PHYSDISK0_INCOMPATIBLE_MAX_LBA             (0x03)
 #define MPI2_PHYSDISK0_INCOMPATIBLE_SATA_EXTENDED_CMD   (0x04)
 #define MPI2_PHYSDISK0_INCOMPATIBLE_REMOVEABLE_MEDIA    (0x05)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_MEDIA_TYPE          (0x06)
 #define MPI2_PHYSDISK0_INCOMPATIBLE_UNKNOWN             (0xFF)
 
 /* PhysDiskAttributes defines */
+#define MPI2_PHYSDISK0_ATTRIB_MEDIA_MASK                (0x0C)
 #define MPI2_PHYSDISK0_ATTRIB_SOLID_STATE_DRIVE         (0x08)
 #define MPI2_PHYSDISK0_ATTRIB_HARD_DISK_DRIVE           (0x04)
+
+#define MPI2_PHYSDISK0_ATTRIB_PROTOCOL_MASK             (0x03)
 #define MPI2_PHYSDISK0_ATTRIB_SAS_PROTOCOL              (0x02)
 #define MPI2_PHYSDISK0_ATTRIB_SATA_PROTOCOL             (0x01)
 
@@ -1545,6 +1559,7 @@ typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_1
 #define MPI2_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE        (0x03)
 #define MPI2_SAS_NEG_LINK_RATE_PORT_SELECTOR            (0x04)
 #define MPI2_SAS_NEG_LINK_RATE_SMP_RESET_IN_PROGRESS    (0x05)
+#define MPI2_SAS_NEG_LINK_RATE_UNSUPPORTED_PHY          (0x06)
 #define MPI2_SAS_NEG_LINK_RATE_1_5                      (0x08)
 #define MPI2_SAS_NEG_LINK_RATE_3_0                      (0x09)
 #define MPI2_SAS_NEG_LINK_RATE_6_0                      (0x0A)
@@ -1571,6 +1586,7 @@ typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_1
 #define MPI2_SAS_PHYINFO_PHY_VACANT                     (0x80000000)
 
 #define MPI2_SAS_PHYINFO_PHY_POWER_CONDITION_MASK       (0x18000000)
+#define MPI2_SAS_PHYINFO_SHIFT_PHY_POWER_CONDITION      (27)
 #define MPI2_SAS_PHYINFO_PHY_POWER_ACTIVE               (0x00000000)
 #define MPI2_SAS_PHYINFO_PHY_POWER_PARTIAL              (0x08000000)
 #define MPI2_SAS_PHYINFO_PHY_POWER_SLUMBER              (0x10000000)
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
index bd6c92b..b1e88f2 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
@@ -291,6 +291,7 @@ mpi2_raid.h
  *                      can be sized by the build environment.
  *  07-30-09  02.00.04  Added proper define for the Use Default Settings bit of
  *                      VolumeCreationFlags and marked the old one as obsolete.
+ *  05-12-10  02.00.05  Added MPI2_RAID_VOL_FLAGS_OP_MDC define.
  *  --------------------------------------------------------------------------
 
 mpi2_sas.h
@@ -301,6 +302,7 @@ mpi2_sas.h
  *                      Request.
  *  10-28-09  02.00.03  Changed the type of SGL in MPI2_SATA_PASSTHROUGH_REQUEST
  *                      to MPI2_SGE_IO_UNION since it supports chained SGLs.
+ *  05-12-10  02.00.04  Modified some comments.
  *  --------------------------------------------------------------------------
 
 mpi2_targ.h
@@ -324,6 +326,7 @@ mpi2_tool.h
  *                      and reply messages.
  *                      Added MPI2_DIAG_BUF_TYPE_EXTENDED.
  *                      Incremented MPI2_DIAG_BUF_TYPE_COUNT.
+ *  05-12-10  02.00.05  Added Diagnostic Data Upload tool.
  *  --------------------------------------------------------------------------
 
 mpi2_type.h
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_init.h b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
index c4c99df..eabe1b3 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
@@ -6,7 +6,7 @@
  *          Title:  MPI SCSI initiator mode messages and structures
  *  Creation Date:  June 23, 2006
  *
- *    mpi2_init.h Version:  02.00.09
+ *    mpi2_init.h Version:  02.00.10
  *
  *  Version History
  *  ---------------
@@ -32,6 +32,7 @@
  *                      Added ResponseInfo field to MPI2_SCSI_TASK_MANAGE_REPLY.
  *                      Added MPI2_SCSITASKMGMT_RSP_TM_OVERLAPPED_TAG define.
  *  02-10-10  02.00.09  Removed unused structure that had "#if 0" around it.
+ *  05-12-10  02.00.10  Added optional vendor-unique region to SCSI IO Request.
  *  --------------------------------------------------------------------------
  */
 
@@ -98,7 +99,13 @@ typedef struct _MPI2_SCSI_IO_REQUEST
     U8                      LUN[8];                         /* 0x34 */
     U32                     Control;                        /* 0x3C */
     MPI2_SCSI_IO_CDB_UNION  CDB;                            /* 0x40 */
+
+#ifdef MPI2_SCSI_IO_VENDOR_UNIQUE_REGION /* typically this is left undefined */
+	MPI2_SCSI_IO_VENDOR_UNIQUE VendorRegion;
+#endif
+
     MPI2_SGE_IO_UNION       SGL;                            /* 0x60 */
+
 } MPI2_SCSI_IO_REQUEST, MPI2_POINTER PTR_MPI2_SCSI_IO_REQUEST,
   Mpi2SCSIIORequest_t, MPI2_POINTER pMpi2SCSIIORequest_t;
 
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
index 495bedc..761cbdb 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
@@ -6,7 +6,7 @@
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  *  Creation Date:  October 11, 2006
  *
- *  mpi2_ioc.h Version:  02.00.14
+ *  mpi2_ioc.h Version:  02.00.15
  *
  *  Version History
  *  ---------------
@@ -101,6 +101,8 @@
  *  02-10-10  02.00.14  Added SAS Quiesce Event structure and defines.
  *                      Added PowerManagementControl Request structures and
  *                      defines.
+ *  05-12-10  02.00.15  Marked Task Set Full Event as obsolete.
+ *                      Added MPI2_EVENT_SAS_TOPO_LR_UNSUPPORTED_PHY define.
  *  --------------------------------------------------------------------------
  */
 
@@ -456,7 +458,7 @@ typedef struct _MPI2_EVENT_NOTIFICATION_REPLY
 #define MPI2_EVENT_STATE_CHANGE                     (0x0002)
 #define MPI2_EVENT_HARD_RESET_RECEIVED              (0x0005)
 #define MPI2_EVENT_EVENT_CHANGE                     (0x000A)
-#define MPI2_EVENT_TASK_SET_FULL                    (0x000E)
+#define MPI2_EVENT_TASK_SET_FULL                    (0x000E) /* obsolete */
 #define MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE         (0x000F)
 #define MPI2_EVENT_IR_OPERATION_STATUS              (0x0014)
 #define MPI2_EVENT_SAS_DISCOVERY                    (0x0016)
@@ -517,6 +519,7 @@ typedef struct _MPI2_EVENT_DATA_HARD_RESET_RECEIVED
   MPI2_POINTER pMpi2EventDataHardResetReceived_t;
 
 /* Task Set Full Event data */
+/*   this event is obsolete */
 
 typedef struct _MPI2_EVENT_DATA_TASK_SET_FULL
 {
@@ -831,6 +834,7 @@ typedef struct _MPI2_EVENT_DATA_SAS_TOPOLOGY_CHANGE_LIST
 #define MPI2_EVENT_SAS_TOPO_LR_SATA_OOB_COMPLETE            (0x03)
 #define MPI2_EVENT_SAS_TOPO_LR_PORT_SELECTOR                (0x04)
 #define MPI2_EVENT_SAS_TOPO_LR_SMP_RESET_IN_PROGRESS        (0x05)
+#define MPI2_EVENT_SAS_TOPO_LR_UNSUPPORTED_PHY              (0x06)
 #define MPI2_EVENT_SAS_TOPO_LR_RATE_1_5                     (0x08)
 #define MPI2_EVENT_SAS_TOPO_LR_RATE_3_0                     (0x09)
 #define MPI2_EVENT_SAS_TOPO_LR_RATE_6_0                     (0x0A)
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_raid.h b/drivers/scsi/mpt2sas/mpi/mpi2_raid.h
index 5160c33..bd61a7b 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_raid.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_raid.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2008 LSI Corporation.
+ *  Copyright (c) 2000-2010 LSI Corporation.
  *
  *
  *           Name:  mpi2_raid.h
  *          Title:  MPI Integrated RAID messages and structures
  *  Creation Date:  April 26, 2007
  *
- *    mpi2_raid.h Version:  02.00.04
+ *    mpi2_raid.h Version:  02.00.05
  *
  *  Version History
  *  ---------------
@@ -22,6 +22,7 @@
  *                      can be sized by the build environment.
  *  07-30-09  02.00.04  Added proper define for the Use Default Settings bit of
  *                      VolumeCreationFlags and marked the old one as obsolete.
+ *  05-12-10  02.00.05  Added MPI2_RAID_VOL_FLAGS_OP_MDC define.
  *  --------------------------------------------------------------------------
  */
 
@@ -260,6 +261,7 @@ typedef struct _MPI2_RAID_VOL_INDICATOR
 #define MPI2_RAID_VOL_FLAGS_OP_ONLINE_CAP_EXPANSION (0x00000001)
 #define MPI2_RAID_VOL_FLAGS_OP_CONSISTENCY_CHECK    (0x00000002)
 #define MPI2_RAID_VOL_FLAGS_OP_RESYNC               (0x00000003)
+#define MPI2_RAID_VOL_FLAGS_OP_MDC                  (0x00000004)
 
 
 /* RAID Action Reply ActionData union */
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_sas.h b/drivers/scsi/mpt2sas/mpi/mpi2_sas.h
index 2d8aeed..608f6d6 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_sas.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_sas.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2007 LSI Corporation.
+ *  Copyright (c) 2000-2010 LSI Corporation.
  *
  *
  *           Name:  mpi2_sas.h
  *          Title:  MPI Serial Attached SCSI structures and definitions
  *  Creation Date:  February 9, 2007
  *
- *  mpi2.h Version:  02.00.03
+ *  mpi2_sas.h Version:  02.00.04
  *
  *  Version History
  *  ---------------
@@ -20,6 +20,7 @@
  *                      Request.
  *  10-28-09  02.00.03  Changed the type of SGL in MPI2_SATA_PASSTHROUGH_REQUEST
  *                      to MPI2_SGE_IO_UNION since it supports chained SGLs.
+ *  05-12-10  02.00.04  Modified some comments.
  *  --------------------------------------------------------------------------
  */
 
@@ -110,7 +111,7 @@ typedef struct _MPI2_SMP_PASSTHROUGH_REQUEST
 /* values for PassthroughFlags field */
 #define MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE      (0x80)
 
-/* values for SGLFlags field are in the SGL section of mpi2.h */
+/* use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
 
 
 /* SMP Passthrough Reply Message */
@@ -174,7 +175,7 @@ typedef struct _MPI2_SATA_PASSTHROUGH_REQUEST
 #define MPI2_SATA_PT_REQ_PT_FLAGS_WRITE             (0x0002)
 #define MPI2_SATA_PT_REQ_PT_FLAGS_READ              (0x0001)
 
-/* values for SGLFlags field are in the SGL section of mpi2.h */
+/* use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
 
 
 /* SATA Passthrough Reply Message */
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
index 686b09b..fd9a0f9 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
@@ -6,7 +6,7 @@
  *          Title:  MPI diagnostic tool structures and definitions
  *  Creation Date:  March 26, 2007
  *
- *    mpi2_tool.h Version:  02.00.04
+ *    mpi2_tool.h Version:  02.00.05
  *
  *  Version History
  *  ---------------
@@ -22,6 +22,7 @@
  *                      and reply messages.
  *                      Added MPI2_DIAG_BUF_TYPE_EXTENDED.
  *                      Incremented MPI2_DIAG_BUF_TYPE_COUNT.
+ *  05-12-10  02.00.05  Added Diagnostic Data Upload tool.
  *  --------------------------------------------------------------------------
  */
 
@@ -37,6 +38,7 @@
 /* defines for the Tools */
 #define MPI2_TOOLBOX_CLEAN_TOOL                     (0x00)
 #define MPI2_TOOLBOX_MEMORY_MOVE_TOOL               (0x01)
+#define MPI2_TOOLBOX_DIAG_DATA_UPLOAD_TOOL          (0x02)
 #define MPI2_TOOLBOX_ISTWI_READ_WRITE_TOOL          (0x03)
 #define MPI2_TOOLBOX_BEACON_TOOL                    (0x05)
 #define MPI2_TOOLBOX_DIAGNOSTIC_CLI_TOOL            (0x06)
@@ -102,8 +104,7 @@ typedef struct _MPI2_TOOLBOX_CLEAN_REQUEST
 *  Toolbox Memory Move request
 ****************************************************************************/
 
-typedef struct _MPI2_TOOLBOX_MEM_MOVE_REQUEST
-{
+typedef struct _MPI2_TOOLBOX_MEM_MOVE_REQUEST {
     U8                      Tool;                       /* 0x00 */
     U8                      Reserved1;                  /* 0x01 */
     U8                      ChainOffset;                /* 0x02 */
@@ -120,6 +121,44 @@ typedef struct _MPI2_TOOLBOX_MEM_MOVE_REQUEST
 
 
 /****************************************************************************
+*  Toolbox Diagnostic Data Upload request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST {
+	U8                      Tool;                       /* 0x00 */
+	U8                      Reserved1;                  /* 0x01 */
+	U8                      ChainOffset;                /* 0x02 */
+	U8                      Function;                   /* 0x03 */
+	U16                     Reserved2;                  /* 0x04 */
+	U8                      Reserved3;                  /* 0x06 */
+	U8                      MsgFlags;                   /* 0x07 */
+	U8                      VP_ID;                      /* 0x08 */
+	U8                      VF_ID;                      /* 0x09 */
+	U16                     Reserved4;                  /* 0x0A */
+	U8                      SGLFlags;                   /* 0x0C */
+	U8                      Reserved5;                  /* 0x0D */
+	U16                     Reserved6;                  /* 0x0E */
+	U32                     Flags;                      /* 0x10 */
+	U32                     DataLength;                 /* 0x14 */
+	MPI2_SGE_SIMPLE_UNION   SGL;                        /* 0x18 */
+} MPI2_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST,
+MPI2_POINTER PTR_MPI2_TOOLBOX_DIAG_DATA_UPLOAD_REQUEST,
+Mpi2ToolboxDiagDataUploadRequest_t,
+MPI2_POINTER pMpi2ToolboxDiagDataUploadRequest_t;
+
+/* use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
+
+
+typedef struct _MPI2_DIAG_DATA_UPLOAD_HEADER {
+	U32                     DiagDataLength;             /* 00h */
+	U8                      FormatCode;                 /* 04h */
+	U8                      Reserved1;                  /* 05h */
+	U16                     Reserved2;                  /* 06h */
+} MPI2_DIAG_DATA_UPLOAD_HEADER, MPI2_POINTER PTR_MPI2_DIAG_DATA_UPLOAD_HEADER,
+Mpi2DiagDataUploadHeader_t, MPI2_POINTER pMpi2DiagDataUploadHeader_t;
+
+
+/****************************************************************************
 *  Toolbox ISTWI Read Write Tool
 ****************************************************************************/
 
@@ -162,7 +201,7 @@ typedef struct _MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST {
 #define MPI2_TOOL_ISTWI_ACTION_RELEASE_BUS          (0x11)
 #define MPI2_TOOL_ISTWI_ACTION_RESET                (0x12)
 
-/* values for SGLFlags field are in the SGL section of mpi2.h */
+/* use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
 
 
 /* Toolbox ISTWI Read Write Tool reply message */
@@ -248,7 +287,7 @@ typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST {
   Mpi2ToolboxDiagnosticCliRequest_t,
   MPI2_POINTER pMpi2ToolboxDiagnosticCliRequest_t;
 
-/* values for SGLFlags field are in the SGL section of mpi2.h */
+/* use MPI2_SGLFLAGS_ defines from mpi2.h for the SGLFlags field */
 
 
 /* Toolbox Diagnostic CLI Tool reply message */
