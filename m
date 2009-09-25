From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] Resend mpt2sas: Update driver to MPI2 REV K headers.
Date: Fri, 25 Sep 2009 11:44:41 +0530
Message-ID: <20090925061441.GA25717@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44629 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbZIYGiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2009 02:38:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Resend Patch with original subject 
"[PATCH 1/9] mpt2sas: Update driver to MPI2 REV K headers."

Resending after updating compilation warning with Logging disabled as per
James comment on original patch.

Rest of the patches can still apply on top of this updated patch as it is.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
index 7bb2ece..f9f6c08 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                  scatter/gather formats.
  *  Creation Date:  June 21, 2006
  *
- *  mpi2.h Version:  02.00.11
+ *  mpi2.h Version:  02.00.12
  *
  *  Version History
  *  ---------------
@@ -45,6 +45,13 @@
  *  10-02-08  02.00.10  Bumped MPI2_HEADER_VERSION_UNIT.
  *                      Moved LUN field defines from mpi2_init.h.
  *  01-19-09  02.00.11  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  05-06-09  02.00.12  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      In all request and reply descriptors, replaced VF_ID
+ *                      field with MSIxIndex field.
+ *                      Removed DevHandle field from
+ *                      MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR and made those
+ *                      bytes reserved.
+ *                      Added RAID Accelerator functionality.
  *  --------------------------------------------------------------------------
  */
 
@@ -70,7 +77,7 @@
 #define MPI2_VERSION_02_00                  (0x0200)
 
 /* versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x0B)
+#define MPI2_HEADER_VERSION_UNIT            (0x0C)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
@@ -257,7 +264,7 @@ typedef volatile struct _MPI2_SYSTEM_INTERFACE_REGS
 typedef struct _MPI2_DEFAULT_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             DescriptorTypeDependent;    /* 0x06 */
@@ -271,6 +278,7 @@ typedef struct _MPI2_DEFAULT_REQUEST_DESCRIPTOR
 #define MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET             (0x02)
 #define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY           (0x06)
 #define MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE            (0x08)
+#define MPI2_REQ_DESCRIPT_FLAGS_RAID_ACCELERATOR        (0x0A)
 
 #define MPI2_REQ_DESCRIPT_FLAGS_IOC_FIFO_MARKER (0x01)
 
@@ -279,7 +287,7 @@ typedef struct _MPI2_DEFAULT_REQUEST_DESCRIPTOR
 typedef struct _MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             Reserved1;                  /* 0x06 */
@@ -293,7 +301,7 @@ typedef struct _MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR
 typedef struct _MPI2_SCSI_IO_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             DevHandle;                  /* 0x06 */
@@ -306,7 +314,7 @@ typedef struct _MPI2_SCSI_IO_REQUEST_DESCRIPTOR
 typedef struct _MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             IoIndex;                    /* 0x06 */
@@ -315,14 +323,29 @@ typedef struct _MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR
   Mpi2SCSITargetRequestDescriptor_t,
   MPI2_POINTER pMpi2SCSITargetRequestDescriptor_t;
 
+
+/* RAID Accelerator Request Descriptor */
+typedef struct _MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR {
+    U8              RequestFlags;               /* 0x00 */
+    U8              MSIxIndex;                  /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U16             LMID;                       /* 0x04 */
+    U16             Reserved;                   /* 0x06 */
+} MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR,
+  Mpi2RAIDAcceleratorRequestDescriptor_t,
+  MPI2_POINTER pMpi2RAIDAcceleratorRequestDescriptor_t;
+
+
 /* union of Request Descriptors */
 typedef union _MPI2_REQUEST_DESCRIPTOR_UNION
 {
-    MPI2_DEFAULT_REQUEST_DESCRIPTOR         Default;
-    MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR   HighPriority;
-    MPI2_SCSI_IO_REQUEST_DESCRIPTOR         SCSIIO;
-    MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR     SCSITarget;
-    U64                                     Words;
+    MPI2_DEFAULT_REQUEST_DESCRIPTOR             Default;
+    MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR       HighPriority;
+    MPI2_SCSI_IO_REQUEST_DESCRIPTOR             SCSIIO;
+    MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR         SCSITarget;
+    MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR          RAIDAccelerator;
+    U64                                         Words;
 } MPI2_REQUEST_DESCRIPTOR_UNION, MPI2_POINTER PTR_MPI2_REQUEST_DESCRIPTOR_UNION,
   Mpi2RequestDescriptorUnion_t, MPI2_POINTER pMpi2RequestDescriptorUnion_t;
 
@@ -333,19 +356,20 @@ typedef union _MPI2_REQUEST_DESCRIPTOR_UNION
 typedef struct _MPI2_DEFAULT_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             DescriptorTypeDependent1;   /* 0x02 */
     U32             DescriptorTypeDependent2;   /* 0x04 */
 } MPI2_DEFAULT_REPLY_DESCRIPTOR, MPI2_POINTER PTR_MPI2_DEFAULT_REPLY_DESCRIPTOR,
   Mpi2DefaultReplyDescriptor_t, MPI2_POINTER pMpi2DefaultReplyDescriptor_t;
 
 /* defines for the ReplyFlags field */
-#define MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK               (0x0F)
-#define MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS         (0x00)
-#define MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY           (0x01)
-#define MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS    (0x02)
-#define MPI2_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER   (0x03)
-#define MPI2_RPY_DESCRIPT_FLAGS_UNUSED                  (0x0F)
+#define MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK                   (0x0F)
+#define MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS             (0x00)
+#define MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY               (0x01)
+#define MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS        (0x02)
+#define MPI2_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER       (0x03)
+#define MPI2_RPY_DESCRIPT_FLAGS_RAID_ACCELERATOR_SUCCESS    (0x05)
+#define MPI2_RPY_DESCRIPT_FLAGS_UNUSED                      (0x0F)
 
 /* values for marking a reply descriptor as unused */
 #define MPI2_RPY_DESCRIPT_UNUSED_WORD0_MARK             (0xFFFFFFFF)
@@ -355,7 +379,7 @@ typedef struct _MPI2_DEFAULT_REPLY_DESCRIPTOR
 typedef struct _MPI2_ADDRESS_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U32             ReplyFrameAddress;          /* 0x04 */
 } MPI2_ADDRESS_REPLY_DESCRIPTOR, MPI2_POINTER PTR_MPI2_ADDRESS_REPLY_DESCRIPTOR,
@@ -368,10 +392,10 @@ typedef struct _MPI2_ADDRESS_REPLY_DESCRIPTOR
 typedef struct _MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             TaskTag;                    /* 0x04 */
-    U16             DevHandle;                  /* 0x06 */
+    U16             Reserved1;                  /* 0x06 */
 } MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR,
   MPI2_POINTER PTR_MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR,
   Mpi2SCSIIOSuccessReplyDescriptor_t,
@@ -382,7 +406,7 @@ typedef struct _MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR
 typedef struct _MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U8              SequenceNumber;             /* 0x04 */
     U8              Reserved1;                  /* 0x05 */
@@ -397,7 +421,7 @@ typedef struct _MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR
 typedef struct _MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U8              VP_ID;                      /* 0x02 */
     U8              Flags;                      /* 0x03 */
     U16             InitiatorDevHandle;         /* 0x04 */
@@ -411,15 +435,28 @@ typedef struct _MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR
 #define MPI2_RPY_DESCRIPT_TCB_FLAGS_PHYNUM_MASK     (0x3F)
 
 
+/* RAID Accelerator Success Reply Descriptor */
+typedef struct _MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR {
+    U8              ReplyFlags;                 /* 0x00 */
+    U8              MSIxIndex;                  /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U32             Reserved;                   /* 0x04 */
+} MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR,
+  Mpi2RAIDAcceleratorSuccessReplyDescriptor_t,
+  MPI2_POINTER pMpi2RAIDAcceleratorSuccessReplyDescriptor_t;
+
+
 /* union of Reply Descriptors */
 typedef union _MPI2_REPLY_DESCRIPTORS_UNION
 {
-    MPI2_DEFAULT_REPLY_DESCRIPTOR               Default;
-    MPI2_ADDRESS_REPLY_DESCRIPTOR               AddressReply;
-    MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR       SCSIIOSuccess;
-    MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR  TargetAssistSuccess;
-    MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR TargetCommandBuffer;
-    U64                                         Words;
+    MPI2_DEFAULT_REPLY_DESCRIPTOR                   Default;
+    MPI2_ADDRESS_REPLY_DESCRIPTOR                   AddressReply;
+    MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR           SCSIIOSuccess;
+    MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR      TargetAssistSuccess;
+    MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR     TargetCommandBuffer;
+    MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR  RAIDAcceleratorSuccess;
+    U64                                             Words;
 } MPI2_REPLY_DESCRIPTORS_UNION, MPI2_POINTER PTR_MPI2_REPLY_DESCRIPTORS_UNION,
   Mpi2ReplyDescriptorsUnion_t, MPI2_POINTER pMpi2ReplyDescriptorsUnion_t;
 
@@ -458,6 +495,7 @@ typedef union _MPI2_REPLY_DESCRIPTORS_UNION
 #define MPI2_FUNCTION_DIAG_RELEASE                  (0x1E) /* Diagnostic Release */
 #define MPI2_FUNCTION_TARGET_CMD_BUF_BASE_POST      (0x24) /* Target Command Buffer Post Base */
 #define MPI2_FUNCTION_TARGET_CMD_BUF_LIST_POST      (0x25) /* Target Command Buffer Post List */
+#define MPI2_FUNCTION_RAID_ACCELERATOR              (0x2C) /* RAID Accelerator*/
 
 
 
@@ -555,12 +593,17 @@ typedef union _MPI2_REPLY_DESCRIPTORS_UNION
 
 #define MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED          (0x00A0)
 
+/****************************************************************************
+*  RAID Accelerator values
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_RAID_ACCEL_ERROR             (0x00B0)
 
 /****************************************************************************
 *  IOCStatus flag to indicate that log info is available
 ****************************************************************************/
 
-#define MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE  (0x8000)
+#define MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE      (0x8000)
 
 /****************************************************************************
 *  IOCLogInfo Types
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
index 2f27cf6..ab47c46 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Configuration messages and pages
  *  Creation Date:  November 10, 2006
  *
- *    mpi2_cnfg.h Version:  02.00.10
+ *    mpi2_cnfg.h Version:  02.00.11
  *
  *  Version History
  *  ---------------
@@ -95,6 +95,11 @@
  *                      Added MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED define.
  *                      Added PortGroups, DmaGroup, and ControlGroup fields to
  *                      SAS Device Page 0.
+ *  05-06-09  02.00.11  Added structures and defines for IO Unit Page 5 and IO
+ *                      Unit Page 6.
+ *                      Added expander reduced functionality data to SAS
+ *                      Expander Page 0.
+ *                      Added SAS PHY Page 2 and SAS PHY Page 3.
  *  --------------------------------------------------------------------------
  */
 
@@ -723,6 +728,65 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3
 #define MPI2_IOUNITPAGE3_GPIO_SETTING_ON                (0x0001)
 
 
+/* IO Unit Page 5 */
+
+/*
+ * Upper layer code (drivers, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength or NumDmaEngines at runtime.
+ */
+#ifndef MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES
+#define MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_5 {
+    MPI2_CONFIG_PAGE_HEADER Header;				/* 0x00 */
+    U64                     RaidAcceleratorBufferBaseAddress;  /* 0x04 */
+    U64                     RaidAcceleratorBufferSize;         /* 0x0C */
+    U64                     RaidAcceleratorControlBaseAddress; /* 0x14 */
+    U8                      RAControlSize;                     /* 0x1C */
+    U8                      NumDmaEngines;                     /* 0x1D */
+    U8                      RAMinControlSize;                  /* 0x1E */
+    U8                      RAMaxControlSize;                  /* 0x1F */
+    U32                     Reserved1;                         /* 0x20 */
+    U32                     Reserved2;                         /* 0x24 */
+    U32                     Reserved3;                         /* 0x28 */
+    U32                     DmaEngineCapabilities
+				[MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES]; /* 0x2C */
+} MPI2_CONFIG_PAGE_IO_UNIT_5, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IO_UNIT_5,
+  Mpi2IOUnitPage5_t, MPI2_POINTER pMpi2IOUnitPage5_t;
+
+#define MPI2_IOUNITPAGE5_PAGEVERSION                    (0x00)
+
+/* defines for IO Unit Page 5 DmaEngineCapabilities field */
+#define MPI2_IOUNITPAGE5_DMA_CAP_MASK_MAX_REQUESTS      (0xFF00)
+#define MPI2_IOUNITPAGE5_DMA_CAP_SHIFT_MAX_REQUESTS     (16)
+
+#define MPI2_IOUNITPAGE5_DMA_CAP_EEDP                   (0x0008)
+#define MPI2_IOUNITPAGE5_DMA_CAP_PARITY_GENERATION      (0x0004)
+#define MPI2_IOUNITPAGE5_DMA_CAP_HASHING                (0x0002)
+#define MPI2_IOUNITPAGE5_DMA_CAP_ENCRYPTION             (0x0001)
+
+
+/* IO Unit Page 6 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_6 {
+    MPI2_CONFIG_PAGE_HEADER Header;                                 /* 0x00 */
+    U16                     Flags;                                  /* 0x04 */
+    U8                      RAHostControlSize;                      /* 0x06 */
+    U8                      Reserved0;                              /* 0x07 */
+    U64                     RaidAcceleratorHostControlBaseAddress;  /* 0x08 */
+    U32                     Reserved1;                              /* 0x10 */
+    U32                     Reserved2;                              /* 0x14 */
+    U32                     Reserved3;                              /* 0x18 */
+} MPI2_CONFIG_PAGE_IO_UNIT_6, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IO_UNIT_6,
+  Mpi2IOUnitPage6_t, MPI2_POINTER pMpi2IOUnitPage6_t;
+
+#define MPI2_IOUNITPAGE6_PAGEVERSION                    (0x00)
+
+/* defines for IO Unit Page 6 Flags field */
+#define MPI2_IOUNITPAGE6_FLAGS_ENABLE_RAID_ACCELERATOR  (0x0001)
+
+
 /****************************************************************************
 *   IOC Config Pages
 ****************************************************************************/
@@ -1709,10 +1773,14 @@ typedef struct _MPI2_CONFIG_PAGE_EXPANDER_0
     U64                                 ActiveZoneManagerSASAddress;/* 0x2C */
     U16                                 ZoneLockInactivityLimit;    /* 0x34 */
     U16                                 Reserved1;                  /* 0x36 */
+    U8                                  TimeToReducedFunc;          /* 0x38 */
+    U8                                  InitialTimeToReducedFunc;   /* 0x39 */
+    U8                                  MaxReducedFuncTime;         /* 0x3A */
+    U8                                  Reserved2;                  /* 0x3B */
 } MPI2_CONFIG_PAGE_EXPANDER_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_EXPANDER_0,
   Mpi2ExpanderPage0_t, MPI2_POINTER pMpi2ExpanderPage0_t;
 
-#define MPI2_SASEXPANDER0_PAGEVERSION       (0x05)
+#define MPI2_SASEXPANDER0_PAGEVERSION       (0x06)
 
 /* values for SAS Expander Page 0 DiscoveryStatus field */
 #define MPI2_SAS_EXPANDER0_DS_MAX_ENCLOSURES_EXCEED         (0x80000000)
@@ -1737,6 +1805,7 @@ typedef struct _MPI2_CONFIG_PAGE_EXPANDER_0
 #define MPI2_SAS_EXPANDER0_DS_LOOP_DETECTED                 (0x00000001)
 
 /* values for SAS Expander Page 0 Flags field */
+#define MPI2_SAS_EXPANDER0_FLAGS_REDUCED_FUNCTIONALITY      (0x2000)
 #define MPI2_SAS_EXPANDER0_FLAGS_ZONE_LOCKED                (0x1000)
 #define MPI2_SAS_EXPANDER0_FLAGS_SUPPORTED_PHYSICAL_PRES    (0x0800)
 #define MPI2_SAS_EXPANDER0_FLAGS_ASSERTED_PHYSICAL_PRES     (0x0400)
@@ -1944,6 +2013,133 @@ typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_1
 #define MPI2_SASPHY1_PAGEVERSION            (0x01)
 
 
+/* SAS PHY Page 2 */
+
+typedef struct _MPI2_SASPHY2_PHY_EVENT {
+    U8          PhyEventCode;       /* 0x00 */
+    U8          Reserved1;          /* 0x01 */
+    U16         Reserved2;          /* 0x02 */
+    U32         PhyEventInfo;       /* 0x04 */
+} MPI2_SASPHY2_PHY_EVENT, MPI2_POINTER PTR_MPI2_SASPHY2_PHY_EVENT,
+  Mpi2SasPhy2PhyEvent_t, MPI2_POINTER pMpi2SasPhy2PhyEvent_t;
+
+/* use MPI2_SASPHY3_EVENT_CODE_ for the PhyEventCode field */
+
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhyEvents at runtime.
+ */
+#ifndef MPI2_SASPHY2_PHY_EVENT_MAX
+#define MPI2_SASPHY2_PHY_EVENT_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_2 {
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U32                                 Reserved1;                  /* 0x08 */
+    U8                                  NumPhyEvents;               /* 0x0C */
+    U8                                  Reserved2;                  /* 0x0D */
+    U16                                 Reserved3;                  /* 0x0E */
+    MPI2_SASPHY2_PHY_EVENT              PhyEvent[MPI2_SASPHY2_PHY_EVENT_MAX];
+								/* 0x10 */
+} MPI2_CONFIG_PAGE_SAS_PHY_2, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_PHY_2,
+  Mpi2SasPhyPage2_t, MPI2_POINTER pMpi2SasPhyPage2_t;
+
+#define MPI2_SASPHY2_PAGEVERSION            (0x00)
+
+
+/* SAS PHY Page 3 */
+
+typedef struct _MPI2_SASPHY3_PHY_EVENT_CONFIG {
+    U8          PhyEventCode;       /* 0x00 */
+    U8          Reserved1;          /* 0x01 */
+    U16         Reserved2;          /* 0x02 */
+    U8          CounterType;        /* 0x04 */
+    U8          ThresholdWindow;    /* 0x05 */
+    U8          TimeUnits;          /* 0x06 */
+    U8          Reserved3;          /* 0x07 */
+    U32         EventThreshold;     /* 0x08 */
+    U16         ThresholdFlags;     /* 0x0C */
+    U16         Reserved4;          /* 0x0E */
+} MPI2_SASPHY3_PHY_EVENT_CONFIG, MPI2_POINTER PTR_MPI2_SASPHY3_PHY_EVENT_CONFIG,
+  Mpi2SasPhy3PhyEventConfig_t, MPI2_POINTER pMpi2SasPhy3PhyEventConfig_t;
+
+/* values for PhyEventCode field */
+#define MPI2_SASPHY3_EVENT_CODE_NO_EVENT                    (0x00)
+#define MPI2_SASPHY3_EVENT_CODE_INVALID_DWORD               (0x01)
+#define MPI2_SASPHY3_EVENT_CODE_RUNNING_DISPARITY_ERROR     (0x02)
+#define MPI2_SASPHY3_EVENT_CODE_LOSS_DWORD_SYNC             (0x03)
+#define MPI2_SASPHY3_EVENT_CODE_PHY_RESET_PROBLEM           (0x04)
+#define MPI2_SASPHY3_EVENT_CODE_ELASTICITY_BUF_OVERFLOW     (0x05)
+#define MPI2_SASPHY3_EVENT_CODE_RX_ERROR                    (0x06)
+#define MPI2_SASPHY3_EVENT_CODE_RX_ADDR_FRAME_ERROR         (0x20)
+#define MPI2_SASPHY3_EVENT_CODE_TX_AC_OPEN_REJECT           (0x21)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AC_OPEN_REJECT           (0x22)
+#define MPI2_SASPHY3_EVENT_CODE_TX_RC_OPEN_REJECT           (0x23)
+#define MPI2_SASPHY3_EVENT_CODE_RX_RC_OPEN_REJECT           (0x24)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP_PARTIAL_WAITING_ON   (0x25)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP_CONNECT_WAITING_ON   (0x26)
+#define MPI2_SASPHY3_EVENT_CODE_TX_BREAK                    (0x27)
+#define MPI2_SASPHY3_EVENT_CODE_RX_BREAK                    (0x28)
+#define MPI2_SASPHY3_EVENT_CODE_BREAK_TIMEOUT               (0x29)
+#define MPI2_SASPHY3_EVENT_CODE_CONNECTION                  (0x2A)
+#define MPI2_SASPHY3_EVENT_CODE_PEAKTX_PATHWAY_BLOCKED      (0x2B)
+#define MPI2_SASPHY3_EVENT_CODE_PEAKTX_ARB_WAIT_TIME        (0x2C)
+#define MPI2_SASPHY3_EVENT_CODE_PEAK_ARB_WAIT_TIME          (0x2D)
+#define MPI2_SASPHY3_EVENT_CODE_PEAK_CONNECT_TIME           (0x2E)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SSP_FRAMES               (0x40)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SSP_FRAMES               (0x41)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SSP_ERROR_FRAMES         (0x42)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SSP_ERROR_FRAMES         (0x43)
+#define MPI2_SASPHY3_EVENT_CODE_TX_CREDIT_BLOCKED           (0x44)
+#define MPI2_SASPHY3_EVENT_CODE_RX_CREDIT_BLOCKED           (0x45)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SATA_FRAMES              (0x50)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SATA_FRAMES              (0x51)
+#define MPI2_SASPHY3_EVENT_CODE_SATA_OVERFLOW               (0x52)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SMP_FRAMES               (0x60)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SMP_FRAMES               (0x61)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SMP_ERROR_FRAMES         (0x63)
+#define MPI2_SASPHY3_EVENT_CODE_HOTPLUG_TIMEOUT             (0xD0)
+#define MPI2_SASPHY3_EVENT_CODE_MISALIGNED_MUX_PRIMITIVE    (0xD1)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP                      (0xD2)
+
+/* values for the CounterType field */
+#define MPI2_SASPHY3_COUNTER_TYPE_WRAPPING                  (0x00)
+#define MPI2_SASPHY3_COUNTER_TYPE_SATURATING                (0x01)
+#define MPI2_SASPHY3_COUNTER_TYPE_PEAK_VALUE                (0x02)
+
+/* values for the TimeUnits field */
+#define MPI2_SASPHY3_TIME_UNITS_10_MICROSECONDS             (0x00)
+#define MPI2_SASPHY3_TIME_UNITS_100_MICROSECONDS            (0x01)
+#define MPI2_SASPHY3_TIME_UNITS_1_MILLISECOND               (0x02)
+#define MPI2_SASPHY3_TIME_UNITS_10_MILLISECONDS             (0x03)
+
+/* values for the ThresholdFlags field */
+#define MPI2_SASPHY3_TFLAGS_PHY_RESET                       (0x0002)
+#define MPI2_SASPHY3_TFLAGS_EVENT_NOTIFY                    (0x0001)
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhyEvents at runtime.
+ */
+#ifndef MPI2_SASPHY3_PHY_EVENT_MAX
+#define MPI2_SASPHY3_PHY_EVENT_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_3 {
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U32                                 Reserved1;                  /* 0x08 */
+    U8                                  NumPhyEvents;               /* 0x0C */
+    U8                                  Reserved2;                  /* 0x0D */
+    U16                                 Reserved3;                  /* 0x0E */
+    MPI2_SASPHY3_PHY_EVENT_CONFIG       PhyEventConfig
+					[MPI2_SASPHY3_PHY_EVENT_MAX]; /* 0x10 */
+} MPI2_CONFIG_PAGE_SAS_PHY_3, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_PHY_3,
+  Mpi2SasPhyPage3_t, MPI2_POINTER pMpi2SasPhyPage3_t;
+
+#define MPI2_SASPHY3_PAGEVERSION            (0x00)
+
+
 /****************************************************************************
 *   SAS Port Config Pages
 ****************************************************************************/
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_init.h b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
index f1115f0..563e56d 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2008 LSI Corporation.
+ *  Copyright (c) 2000-2009 LSI Corporation.
  *
  *
  *           Name:  mpi2_init.h
  *          Title:  MPI SCSI initiator mode messages and structures
  *  Creation Date:  June 23, 2006
  *
- *    mpi2_init.h Version:  02.00.06
+ *    mpi2_init.h Version:  02.00.07
  *
  *  Version History
  *  ---------------
@@ -23,6 +23,10 @@
  *                      Control field Task Attribute flags.
  *                      Moved LUN field defines to mpi2.h becasue they are
  *                      common to many structures.
+ *  05-06-09  02.00.07  Changed task management type of Query Unit Attention to
+ *                      Query Asynchronous Event.
+ *                      Defined two new bits in the SlotStatus field of the SCSI
+ *                      Enclosure Processor Request and Reply.
  *  --------------------------------------------------------------------------
  */
 
@@ -289,7 +293,11 @@ typedef struct _MPI2_SCSI_TASK_MANAGE_REQUEST
 #define MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK           (0x07)
 #define MPI2_SCSITASKMGMT_TASKTYPE_CLR_ACA              (0x08)
 #define MPI2_SCSITASKMGMT_TASKTYPE_QRY_TASK_SET         (0x09)
-#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_UNIT_ATTENTION   (0x0A)
+#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_ASYNC_EVENT      (0x0A)
+
+/* obsolete TaskType name */
+#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_UNIT_ATTENTION	\
+	(MPI2_SCSITASKMGMT_TASKTYPE_QRY_ASYNC_EVENT)
 
 /* MsgFlags bits */
 
@@ -375,6 +383,8 @@ typedef struct _MPI2_SEP_REQUEST
 #define MPI2_SEP_REQ_SLOTSTATUS_HOT_SPARE               (0x00000100)
 #define MPI2_SEP_REQ_SLOTSTATUS_UNCONFIGURED            (0x00000080)
 #define MPI2_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT         (0x00000040)
+#define MPI2_SEP_REQ_SLOTSTATUS_IN_CRITICAL_ARRAY       (0x00000010)
+#define MPI2_SEP_REQ_SLOTSTATUS_IN_FAILED_ARRAY         (0x00000008)
 #define MPI2_SEP_REQ_SLOTSTATUS_DEV_REBUILDING          (0x00000004)
 #define MPI2_SEP_REQ_SLOTSTATUS_DEV_FAULTY              (0x00000002)
 #define MPI2_SEP_REQ_SLOTSTATUS_NO_ERROR                (0x00000001)
@@ -410,6 +420,8 @@ typedef struct _MPI2_SEP_REPLY
 #define MPI2_SEP_REPLY_SLOTSTATUS_HOT_SPARE             (0x00000100)
 #define MPI2_SEP_REPLY_SLOTSTATUS_UNCONFIGURED          (0x00000080)
 #define MPI2_SEP_REPLY_SLOTSTATUS_PREDICTED_FAULT       (0x00000040)
+#define MPI2_SEP_REPLY_SLOTSTATUS_IN_CRITICAL_ARRAY     (0x00000010)
+#define MPI2_SEP_REPLY_SLOTSTATUS_IN_FAILED_ARRAY       (0x00000008)
 #define MPI2_SEP_REPLY_SLOTSTATUS_DEV_REBUILDING        (0x00000004)
 #define MPI2_SEP_REPLY_SLOTSTATUS_DEV_FAULTY            (0x00000002)
 #define MPI2_SEP_REPLY_SLOTSTATUS_NO_ERROR              (0x00000001)
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
index 8c5d818..c294128 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
@@ -6,7 +6,7 @@
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  *  Creation Date:  October 11, 2006
  *
- *  mpi2_ioc.h Version:  02.00.10
+ *  mpi2_ioc.h Version:  02.00.11
  *
  *  Version History
  *  ---------------
@@ -79,6 +79,11 @@
  *                      Added MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE
  *                      define.
  *                      Removed MPI2_EVENT_SAS_DISC_DS_SATA_INIT_FAILURE define.
+ *  05-06-09  02.00.11  Added MPI2_IOCFACTS_CAPABILITY_RAID_ACCELERATOR define.
+ *                      Added MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX define.
+ *                      Added two new reason codes for SAS Device Status Change
+ *                      Event.
+ *                      Added new event: SAS PHY Counter.
  *  --------------------------------------------------------------------------
  */
 
@@ -261,6 +266,8 @@ typedef struct _MPI2_IOC_FACTS_REPLY
 /* ProductID field uses MPI2_FW_HEADER_PID_ */
 
 /* IOCCapabilities */
+#define MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX            (0x00008000)
+#define MPI2_IOCFACTS_CAPABILITY_RAID_ACCELERATOR       (0x00004000)
 #define MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY           (0x00002000)
 #define MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID        (0x00001000)
 #define MPI2_IOCFACTS_CAPABILITY_TLR                    (0x00000800)
@@ -440,6 +447,7 @@ typedef struct _MPI2_EVENT_NOTIFICATION_REPLY
 #define MPI2_EVENT_IR_PHYSICAL_DISK                 (0x001F)
 #define MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST     (0x0020)
 #define MPI2_EVENT_LOG_ENTRY_ADDED                  (0x0021)
+#define MPI2_EVENT_SAS_PHY_COUNTER                  (0x0022)
 
 
 /* Log Entry Added Event data */
@@ -502,17 +510,19 @@ typedef struct _MPI2_EVENT_DATA_SAS_DEVICE_STATUS_CHANGE
   MPI2_POINTER pMpi2EventDataSasDeviceStatusChange_t;
 
 /* SAS Device Status Change Event data ReasonCode values */
-#define MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA               (0x05)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED              (0x07)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET    (0x08)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL      (0x09)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL  (0x0A)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL  (0x0B)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL      (0x0C)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION       (0x0D)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET   (0x0E)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_TASK_ABORT_INTERNAL  (0x0F)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE        (0x10)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA                           (0x05)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED                          (0x07)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET                (0x08)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL                  (0x09)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL              (0x0A)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL              (0x0B)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL                  (0x0C)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION                   (0x0D)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET               (0x0E)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_TASK_ABORT_INTERNAL              (0x0F)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE                    (0x10)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_EXPANDER_REDUCED_FUNCTIONALITY       (0x11)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_EXPANDER_REDUCED_FUNCTIONALITY   (0x12)
 
 
 /* Integrated RAID Operation Status Event data */
@@ -822,6 +832,37 @@ typedef struct _MPI2_EVENT_DATA_SAS_ENCL_DEV_STATUS_CHANGE
 #define MPI2_EVENT_SAS_ENCL_RC_NOT_RESPONDING       (0x02)
 
 
+/* SAS PHY Counter Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_PHY_COUNTER {
+    U64         TimeStamp;          /* 0x00 */
+    U32         Reserved1;          /* 0x08 */
+    U8          PhyEventCode;       /* 0x0C */
+    U8          PhyNum;             /* 0x0D */
+    U16         Reserved2;          /* 0x0E */
+    U32         PhyEventInfo;       /* 0x10 */
+    U8          CounterType;        /* 0x14 */
+    U8          ThresholdWindow;    /* 0x15 */
+    U8          TimeUnits;          /* 0x16 */
+    U8          Reserved3;          /* 0x17 */
+    U32         EventThreshold;     /* 0x18 */
+    U16         ThresholdFlags;     /* 0x1C */
+    U16         Reserved4;          /* 0x1E */
+} MPI2_EVENT_DATA_SAS_PHY_COUNTER,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_PHY_COUNTER,
+  Mpi2EventDataSasPhyCounter_t, MPI2_POINTER pMpi2EventDataSasPhyCounter_t;
+
+/* use MPI2_SASPHY3_EVENT_CODE_ values from mpi2_cnfg.h for the
+ * PhyEventCode field
+ * use MPI2_SASPHY3_COUNTER_TYPE_ values from mpi2_cnfg.h for the
+ * CounterType field
+ * use MPI2_SASPHY3_TIME_UNITS_ values from mpi2_cnfg.h for the
+ * TimeUnits field
+ * use MPI2_SASPHY3_TFLAGS_ values from mpi2_cnfg.h for the
+ * ThresholdFlags field
+ * */
+
+
 /****************************************************************************
 *  EventAck message
 ****************************************************************************/
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
index 2ff4e93..007e950 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2008 LSI Corporation.
+ *  Copyright (c) 2000-2009 LSI Corporation.
  *
  *
  *           Name:  mpi2_tool.h
  *          Title:  MPI diagnostic tool structures and definitions
  *  Creation Date:  March 26, 2007
  *
- *    mpi2_tool.h Version:  02.00.02
+ *    mpi2_tool.h Version:  02.00.03
  *
  *  Version History
  *  ---------------
@@ -17,6 +17,7 @@
  *  12-18-07  02.00.01  Added Diagnostic Buffer Post and Diagnostic Release
  *                      structures and defines.
  *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  05-06-09  02.00.03  Added ISTWI Read Write Tool and Diagnostic CLI Tool.
  *  --------------------------------------------------------------------------
  */
 
@@ -32,7 +33,10 @@
 /* defines for the Tools */
 #define MPI2_TOOLBOX_CLEAN_TOOL                     (0x00)
 #define MPI2_TOOLBOX_MEMORY_MOVE_TOOL               (0x01)
+#define MPI2_TOOLBOX_ISTWI_READ_WRITE_TOOL          (0x03)
 #define MPI2_TOOLBOX_BEACON_TOOL                    (0x05)
+#define MPI2_TOOLBOX_DIAGNOSTIC_CLI_TOOL            (0x06)
+
 
 /****************************************************************************
 *  Toolbox reply
@@ -112,6 +116,77 @@ typedef struct _MPI2_TOOLBOX_MEM_MOVE_REQUEST
 
 
 /****************************************************************************
+*  Toolbox ISTWI Read Write Tool
+****************************************************************************/
+
+/* Toolbox ISTWI Read Write Tool request message */
+typedef struct _MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U32                     Reserved5;                  /* 0x0C */
+    U32                     Reserved6;                  /* 0x10 */
+    U8                      DevIndex;                   /* 0x14 */
+    U8                      Action;                     /* 0x15 */
+    U8                      SGLFlags;                   /* 0x16 */
+    U8                      Reserved7;                  /* 0x17 */
+    U16                     TxDataLength;               /* 0x18 */
+    U16                     RxDataLength;               /* 0x1A */
+    U32                     Reserved8;                  /* 0x1C */
+    U32                     Reserved9;                  /* 0x20 */
+    U32                     Reserved10;                 /* 0x24 */
+    U32                     Reserved11;                 /* 0x28 */
+    U32                     Reserved12;                 /* 0x2C */
+    MPI2_SGE_SIMPLE_UNION   SGL;                        /* 0x30 */
+} MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST,
+  MPI2_POINTER PTR_MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST,
+  Mpi2ToolboxIstwiReadWriteRequest_t,
+  MPI2_POINTER pMpi2ToolboxIstwiReadWriteRequest_t;
+
+/* values for the Action field */
+#define MPI2_TOOL_ISTWI_ACTION_READ_DATA            (0x01)
+#define MPI2_TOOL_ISTWI_ACTION_WRITE_DATA           (0x02)
+#define MPI2_TOOL_ISTWI_ACTION_SEQUENCE             (0x03)
+#define MPI2_TOOL_ISTWI_ACTION_RESERVE_BUS          (0x10)
+#define MPI2_TOOL_ISTWI_ACTION_RELEASE_BUS          (0x11)
+#define MPI2_TOOL_ISTWI_ACTION_RESET                (0x12)
+
+/* values for SGLFlags field are in the SGL section of mpi2.h */
+
+
+/* Toolbox ISTWI Read Write Tool reply message */
+typedef struct _MPI2_TOOLBOX_ISTWI_REPLY {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      MsgLength;                  /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U16                     Reserved5;                  /* 0x0C */
+    U16                     IOCStatus;                  /* 0x0E */
+    U32                     IOCLogInfo;                 /* 0x10 */
+    U8                      DevIndex;                   /* 0x14 */
+    U8                      Action;                     /* 0x15 */
+    U8                      IstwiStatus;                /* 0x16 */
+    U8                      Reserved6;                  /* 0x17 */
+    U16                     TxDataCount;                /* 0x18 */
+    U16                     RxDataCount;                /* 0x1A */
+} MPI2_TOOLBOX_ISTWI_REPLY, MPI2_POINTER PTR_MPI2_TOOLBOX_ISTWI_REPLY,
+  Mpi2ToolboxIstwiReply_t, MPI2_POINTER pMpi2ToolboxIstwiReply_t;
+
+
+/****************************************************************************
 *  Toolbox Beacon Tool request
 ****************************************************************************/
 
@@ -139,6 +214,61 @@ typedef struct _MPI2_TOOLBOX_BEACON_REQUEST
 #define MPI2_TOOLBOX_FLAGS_BEACONMODE_ON        (0x01)
 
 
+/****************************************************************************
+*  Toolbox Diagnostic CLI Tool
+****************************************************************************/
+
+#define MPI2_TOOLBOX_DIAG_CLI_CMD_LENGTH    (0x5C)
+
+/* Toolbox Diagnostic CLI Tool request message */
+typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U8                      SGLFlags;                   /* 0x0C */
+    U8                      Reserved5;                  /* 0x0D */
+    U16                     Reserved6;                  /* 0x0E */
+    U32                     DataLength;                 /* 0x10 */
+    U8                      DiagnosticCliCommand
+		[MPI2_TOOLBOX_DIAG_CLI_CMD_LENGTH];     /* 0x14 */
+    MPI2_SGE_SIMPLE_UNION   SGL;                        /* 0x70 */
+} MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+  MPI2_POINTER PTR_MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+  Mpi2ToolboxDiagnosticCliRequest_t,
+  MPI2_POINTER pMpi2ToolboxDiagnosticCliRequest_t;
+
+/* values for SGLFlags field are in the SGL section of mpi2.h */
+
+
+/* Toolbox Diagnostic CLI Tool reply message */
+typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REPLY {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      MsgLength;                  /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U16                     Reserved5;                  /* 0x0C */
+    U16                     IOCStatus;                  /* 0x0E */
+    U32                     IOCLogInfo;                 /* 0x10 */
+    U32                     ReturnedDataLength;         /* 0x14 */
+} MPI2_TOOLBOX_DIAGNOSTIC_CLI_REPLY,
+  MPI2_POINTER PTR_MPI2_TOOLBOX_DIAG_CLI_REPLY,
+  Mpi2ToolboxDiagnosticCliReply_t,
+  MPI2_POINTER pMpi2ToolboxDiagnosticCliReply_t;
+
+
 /*****************************************************************************
 *
 *       Diagnostic Buffer Messages
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d95d2f2..10de370 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -543,13 +543,13 @@ mpt2sas_base_fault_info(struct MPT2SAS_ADAPTER *ioc , u16 fault_code)
  * _base_display_reply_info -
  * @ioc: pointer to scsi command object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
  * Return nothing.
  */
 static void
-_base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
+_base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
@@ -572,13 +572,14 @@ _base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
  * mpt2sas_base_done - base internal command completion routine
  * @ioc: pointer to scsi command object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
  * Return nothing.
  */
 void
-mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
@@ -601,13 +602,13 @@ mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 /**
  * _base_async_event - main callback handler for firmware asyn events
  * @ioc: pointer to scsi command object
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
  * Return nothing.
  */
 static void
-_base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
+_base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 {
 	Mpi2EventNotificationReply_t *mpi_reply;
 	Mpi2EventAckRequest_t *ack_request;
@@ -635,16 +636,17 @@ _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 	ack_request->Function = MPI2_FUNCTION_EVENT_ACK;
 	ack_request->Event = mpi_reply->Event;
 	ack_request->EventContext = mpi_reply->EventContext;
-	ack_request->VF_ID = VF_ID;
-	mpt2sas_base_put_smid_default(ioc, smid, VF_ID);
+	ack_request->VF_ID = 0;  /* TODO */
+	ack_request->VP_ID = 0;
+	mpt2sas_base_put_smid_default(ioc, smid);
 
  out:
 
 	/* scsih callback handler */
-	mpt2sas_scsih_event_callback(ioc, VF_ID, reply);
+	mpt2sas_scsih_event_callback(ioc, msix_index, reply);
 
 	/* ctl callback handler */
-	mpt2sas_ctl_event_callback(ioc, VF_ID, reply);
+	mpt2sas_ctl_event_callback(ioc, msix_index, reply);
 }
 
 /**
@@ -712,7 +714,7 @@ _base_interrupt(int irq, void *bus_id)
 	u16 smid;
 	u8 cb_idx;
 	u32 reply;
-	u8 VF_ID;
+	u8 msix_index;
 	struct MPT2SAS_ADAPTER *ioc = bus_id;
 	Mpi2ReplyDescriptorsUnion_t *rpf;
 
@@ -733,7 +735,7 @@ _base_interrupt(int irq, void *bus_id)
 		reply = 0;
 		cb_idx = 0xFF;
 		smid = le16_to_cpu(rpf->Default.DescriptorTypeDependent1);
-		VF_ID = rpf->Default.VF_ID;
+		msix_index = rpf->Default.MSIxIndex;
 		if (request_desript_type ==
 		    MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY) {
 			reply = le32_to_cpu
@@ -747,14 +749,14 @@ _base_interrupt(int irq, void *bus_id)
 		if (smid)
 			cb_idx = ioc->scsi_lookup[smid - 1].cb_idx;
 		if (smid && cb_idx != 0xFF) {
-			mpt_callbacks[cb_idx](ioc, smid, VF_ID, reply);
+			mpt_callbacks[cb_idx](ioc, smid, msix_index, reply);
 			if (reply)
-				_base_display_reply_info(ioc, smid, VF_ID,
+				_base_display_reply_info(ioc, smid, msix_index,
 				    reply);
 			mpt2sas_base_free_smid(ioc, smid);
 		}
 		if (!smid)
-			_base_async_event(ioc, VF_ID, reply);
+			_base_async_event(ioc, msix_index, reply);
 
 		/* reply free queue handling */
 		if (reply) {
@@ -1352,21 +1354,19 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
  * mpt2sas_base_put_smid_scsi_io - send SCSI_IO request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  * @handle: device handle
  *
  * Return nothing.
  */
 void
-mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id,
-    u16 handle)
+mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 
 	descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
-	descriptor.SCSIIO.VF_ID = vf_id;
+	descriptor.SCSIIO.MSIxIndex = 0; /* TODO */
 	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
 	descriptor.SCSIIO.DevHandle = cpu_to_le16(handle);
 	descriptor.SCSIIO.LMID = 0;
@@ -1379,20 +1379,18 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id,
  * mpt2sas_base_put_smid_hi_priority - send Task Managment request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  *
  * Return nothing.
  */
 void
-mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 vf_id)
+mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.HighPriority.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
-	descriptor.HighPriority.VF_ID = vf_id;
+	descriptor.HighPriority.MSIxIndex = 0; /* TODO */
 	descriptor.HighPriority.SMID = cpu_to_le16(smid);
 	descriptor.HighPriority.LMID = 0;
 	descriptor.HighPriority.Reserved1 = 0;
@@ -1404,18 +1402,17 @@ mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid,
  * mpt2sas_base_put_smid_default - Default, primarily used for config pages
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  *
  * Return nothing.
  */
 void
-mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id)
+mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
-	descriptor.Default.VF_ID = vf_id;
+	descriptor.Default.MSIxIndex = 0; /* TODO */
 	descriptor.Default.SMID = cpu_to_le16(smid);
 	descriptor.Default.LMID = 0;
 	descriptor.Default.DescriptorTypeDependent = 0;
@@ -1427,21 +1424,20 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id)
  * mpt2sas_base_put_smid_target_assist - send Target Assist/Status to firmware
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  * @io_index: value used to track the IO
  *
  * Return nothing.
  */
 void
 mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 vf_id, u16 io_index)
+    u16 io_index)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.SCSITarget.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET;
-	descriptor.SCSITarget.VF_ID = vf_id;
+	descriptor.SCSITarget.MSIxIndex = 0; /* TODO */
 	descriptor.SCSITarget.SMID = cpu_to_le16(smid);
 	descriptor.SCSITarget.LMID = 0;
 	descriptor.SCSITarget.IoIndex = cpu_to_le16(io_index);
@@ -2454,7 +2450,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 	if (mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
 	    mpi_request->Operation == MPI2_SAS_OP_PHY_LINK_RESET)
 		ioc->ioc_link_reset_in_progress = 1;
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if ((mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
@@ -2555,7 +2551,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 	request = mpt2sas_base_get_msg_frame(ioc, smid);
 	ioc->base_cmds.smid = smid;
 	memcpy(request, mpi_request, sizeof(Mpi2SepReply_t));
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -2701,13 +2697,12 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 /**
  * _base_send_ioc_init - send ioc_init to firmware
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
+_base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	Mpi2IOCInitRequest_t mpi_request;
 	Mpi2IOCInitReply_t mpi_reply;
@@ -2719,7 +2714,8 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 	memset(&mpi_request, 0, sizeof(Mpi2IOCInitRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_IOC_INIT;
 	mpi_request.WhoInit = MPI2_WHOINIT_HOST_DRIVER;
-	mpi_request.VF_ID = VF_ID;
+	mpi_request.VF_ID = 0; /* TODO */
+	mpi_request.VP_ID = 0;
 	mpi_request.MsgVersion = cpu_to_le16(MPI2_VERSION);
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
 
@@ -2795,13 +2791,12 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 /**
  * _base_send_port_enable - send port_enable(discovery stuff) to firmware
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
+_base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	Mpi2PortEnableRequest_t *mpi_request;
 	u32 ioc_state;
@@ -2829,9 +2824,10 @@ _base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 	ioc->base_cmds.smid = smid;
 	memset(mpi_request, 0, sizeof(Mpi2PortEnableRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_PORT_ENABLE;
-	mpi_request->VF_ID = VF_ID;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid, VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    300*HZ);
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -2892,13 +2888,12 @@ _base_unmask_events(struct MPT2SAS_ADAPTER *ioc, u16 event)
 /**
  * _base_event_notification - send event notification
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_event_notification(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
+_base_event_notification(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	Mpi2EventNotificationRequest_t *mpi_request;
 	unsigned long timeleft;
@@ -2926,11 +2921,12 @@ _base_event_notification(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 	ioc->base_cmds.smid = smid;
 	memset(mpi_request, 0, sizeof(Mpi2EventNotificationRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_EVENT_NOTIFICATION;
-	mpi_request->VF_ID = VF_ID;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		mpi_request->EventMasks[i] =
 		    le32_to_cpu(ioc->event_masks[i]);
-	mpt2sas_base_put_smid_default(ioc, smid, VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
 		printk(MPT2SAS_ERR_FMT "%s: timeout\n",
@@ -2981,7 +2977,7 @@ mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_type)
 		return;
 
 	mutex_lock(&ioc->base_cmds.mutex);
-	_base_event_notification(ioc, 0, CAN_SLEEP);
+	_base_event_notification(ioc, CAN_SLEEP);
 	mutex_unlock(&ioc->base_cmds.mutex);
 }
 
@@ -3160,14 +3156,12 @@ _base_make_ioc_ready(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 /**
  * _base_make_ioc_operational - put controller in OPERATIONAL state
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    int sleep_flag)
+_base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	int r, i;
 	unsigned long	flags;
@@ -3196,7 +3190,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	for (i = 0; i < ioc->reply_post_queue_depth; i++)
 		ioc->reply_post_free[i].Words = ULLONG_MAX;
 
-	r = _base_send_ioc_init(ioc, VF_ID, sleep_flag);
+	r = _base_send_ioc_init(ioc, sleep_flag);
 	if (r)
 		return r;
 
@@ -3207,14 +3201,14 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	writel(0, &ioc->chip->ReplyPostHostIndex);
 
 	_base_unmask_interrupts(ioc);
-	r = _base_event_notification(ioc, VF_ID, sleep_flag);
+	r = _base_event_notification(ioc, sleep_flag);
 	if (r)
 		return r;
 
 	if (sleep_flag == CAN_SLEEP)
 		_base_static_config_pages(ioc);
 
-	r = _base_send_port_enable(ioc, VF_ID, sleep_flag);
+	r = _base_send_port_enable(ioc, sleep_flag);
 	if (r)
 		return r;
 
@@ -3338,7 +3332,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		if (r)
 			goto out_free_resources;
 	}
-	r = _base_make_ioc_operational(ioc, 0, CAN_SLEEP);
+	r = _base_make_ioc_operational(ioc, CAN_SLEEP);
 	if (r)
 		goto out_free_resources;
 
@@ -3490,7 +3484,7 @@ int
 mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
     enum reset_type type)
 {
-	int r, i;
+	int r;
 	unsigned long flags;
 
 	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
@@ -3513,9 +3507,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT2_IOC_AFTER_RESET);
-	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++)
-		r = _base_make_ioc_operational(ioc, ioc->pfacts[i].VF_ID,
-		    sleep_flag);
+	r = _base_make_ioc_operational(ioc, sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
  out:
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 2faab1e..39e50e9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -701,8 +701,8 @@ struct MPT2SAS_ADAPTER {
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
 };
 
-typedef void (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
-    u32 reply);
+typedef void (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid,
+    u8 msix_index, u32 reply);
 
 
 /* base shared API */
@@ -725,17 +725,18 @@ dma_addr_t mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc, u16 sm
 
 u16 mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid);
-void mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id,
+void mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid,
     u16 handle);
-void mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id);
+void mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 vf_id, u16 io_index);
-void mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id);
+    u16 io_index);
+void mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_initialize_callback_handler(void);
 u8 mpt2sas_base_register_callback_handler(MPT_CALLBACK cb_func);
 void mpt2sas_base_release_callback_handler(u8 cb_idx);
 
-void mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+void mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 void *mpt2sas_base_get_reply_virt_addr(struct MPT2SAS_ADAPTER *ioc, u32 phys_addr);
 
 u32 mpt2sas_base_get_iocstate(struct MPT2SAS_ADAPTER *ioc, int cooked);
@@ -760,11 +761,13 @@ struct _sas_node *mpt2sas_scsih_expander_find_by_sas_address(struct MPT2SAS_ADAP
 struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
     struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
 
-void mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply);
+void mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+    u32 reply);
 void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
 
 /* config shared API */
-void mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+void mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 int mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys);
 int mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
     Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage0_t *config_page);
@@ -817,14 +820,17 @@ extern struct device_attribute *mpt2sas_host_attrs[];
 extern struct device_attribute *mpt2sas_dev_attrs[];
 void mpt2sas_ctl_init(void);
 void mpt2sas_ctl_exit(void);
-void mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+void mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 void mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
-void mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply);
+void mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+    u32 reply);
 void mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
     Mpi2EventNotificationReply_t *mpi_reply);
 
 /* transport shared API */
-void mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+void mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid,
+    u8 msix_index, u32 reply);
 struct _sas_port *mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc,
     u16 handle, u16 parent_handle);
 void mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index ab8c560..2e018c9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -227,7 +227,7 @@ _config_free_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
  * mpt2sas_config_done - config page completion routine
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: none.
  *
@@ -236,7 +236,8 @@ _config_free_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
  * Return nothing.
  */
 void
-mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
@@ -303,6 +304,9 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	retry_count = 0;
 	memset(&mem, 0, sizeof(struct config_request));
 
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
+
 	if (config_page) {
 		mpi_request->Header.PageVersion = mpi_reply->Header.PageVersion;
 		mpi_request->Header.PageNumber = mpi_reply->Header.PageNumber;
@@ -380,7 +384,7 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	_config_display_some_debug(ioc, smid, "config_request", NULL);
 #endif
 	init_completion(&ioc->config_cmds.done);
-	mpt2sas_base_put_smid_default(ioc, smid, config_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
 	    timeout*HZ);
 	if (!(ioc->config_cmds.status & MPT2_CMD_COMPLETE)) {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index c2a5101..af26926 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -219,7 +219,7 @@ _ctl_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
  * mpt2sas_ctl_done - ctl module completion routine
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: none.
  *
@@ -228,7 +228,8 @@ _ctl_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
  * Return nothing.
  */
 void
-mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+	u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
@@ -328,7 +329,7 @@ mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
 /**
  * mpt2sas_ctl_event_callback - firmware event handler (called at ISR time)
  * @ioc: per adapter object
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: interrupt.
  *
@@ -338,7 +339,8 @@ mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
  * Return nothing.
  */
 void
-mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
+mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+	u32 reply)
 {
 	Mpi2EventNotificationReply_t *mpi_reply;
 
@@ -737,7 +739,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		    (u32)mpt2sas_base_get_sense_buffer_dma(ioc, smid);
 		priv_sense = mpt2sas_base_get_sense_buffer(ioc, smid);
 		memset(priv_sense, 0, SCSI_SENSE_BUFFERSIZE);
-		mpt2sas_base_put_smid_scsi_io(ioc, smid, 0,
+		mpt2sas_base_put_smid_scsi_io(ioc, smid,
 		    le16_to_cpu(mpi_request->FunctionDependent1));
 		break;
 	}
@@ -759,8 +761,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		mutex_lock(&ioc->tm_cmds.mutex);
 		mpt2sas_scsih_set_tm_flag(ioc, le16_to_cpu(
 		    tm_request->DevHandle));
-		mpt2sas_base_put_smid_hi_priority(ioc, smid,
-		    mpi_request->VF_ID);
+		mpt2sas_base_put_smid_hi_priority(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SMP_PASSTHROUGH:
@@ -781,7 +782,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 			ioc->ioc_link_reset_in_progress = 1;
 			ioc->ignore_loginfos = 1;
 		}
-		mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+		mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SAS_IO_UNIT_CONTROL:
@@ -795,11 +796,11 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 			ioc->ioc_link_reset_in_progress = 1;
 			ioc->ignore_loginfos = 1;
 		}
-		mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+		mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	default:
-		mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+		mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 
@@ -1371,6 +1372,8 @@ _ctl_diag_register(void __user *arg, enum block_state state)
 	mpi_request->Flags = cpu_to_le32(karg.diagnostic_flags);
 	mpi_request->BufferAddress = cpu_to_le64(request_data_dma);
 	mpi_request->BufferLength = cpu_to_le32(request_data_sz);
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: diag_buffer(0x%p), "
 	    "dma(0x%llx), sz(%d)\n", ioc->name, __func__, request_data,
@@ -1380,7 +1383,7 @@ _ctl_diag_register(void __user *arg, enum block_state state)
 		mpi_request->ProductSpecific[i] =
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
 
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1643,8 +1646,10 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 
 	mpi_request->Function = MPI2_FUNCTION_DIAG_RELEASE;
 	mpi_request->BufferType = buffer_type;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1902,8 +1907,10 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	for (i = 0; i < MPT2_PRODUCT_SPECIFIC_DWORDS; i++)
 		mpi_request->ProductSpecific[i] =
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -2069,6 +2076,7 @@ static long
 _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
+
 	lock_kernel();
 	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg);
 	unlock_kernel();
@@ -2143,6 +2151,7 @@ static long
 _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
+
 	lock_kernel();
 	if (cmd == MPT2COMMAND32)
 		ret = _ctl_compat_mpt_command(file, cmd, arg);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 774b345..8277fa3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -109,6 +109,7 @@ struct sense_info {
  * @work: work object (ioc->fault_reset_work_q)
  * @ioc: per adapter object
  * @VF_ID: virtual function id
+ * @VP_ID: virtual port id
  * @host_reset_handling: handling events during host reset
  * @ignore: flag meaning this event has been marked to ignore
  * @event: firmware event MPI2_EVENT_XXX defined in mpt2_ioc.h
@@ -121,6 +122,7 @@ struct fw_event_work {
 	struct work_struct	work;
 	struct MPT2SAS_ADAPTER *ioc;
 	u8			VF_ID;
+	u8			VP_ID;
 	u8			host_reset_handling;
 	u8			ignore;
 	u16			event;
@@ -138,8 +140,10 @@ struct fw_event_work {
  * @lun: lun number
  * @cdb_length: cdb length
  * @cdb: cdb contents
- * @valid_reply: flag set for reply message
  * @timeout: timeout for this command
+ * @VF_ID: virtual function id
+ * @VP_ID: virtual port id
+ * @valid_reply: flag set for reply message
  * @sense_length: sense length
  * @ioc_status: ioc status
  * @scsi_state: scsi state
@@ -161,6 +165,8 @@ struct _scsi_io_transfer {
 	u8	cdb_length;
 	u8	cdb[32];
 	u8	timeout;
+	u8	VF_ID;
+	u8	VP_ID;
 	u8	valid_reply;
   /* the following bits are only valid when 'valid_reply = 1' */
 	u32	sense_length;
@@ -1679,7 +1685,7 @@ _scsih_response_code(struct MPT2SAS_ADAPTER *ioc, u8 response_code)
  * _scsih_tm_done - tm completion routine
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: none.
  *
@@ -1688,7 +1694,7 @@ _scsih_response_code(struct MPT2SAS_ADAPTER *ioc, u8 response_code)
  * Return nothing.
  */
 static void
-_scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+_scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
@@ -1790,7 +1796,6 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	u16 smid = 0;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 VF_ID = 0;
 
 	if (ioc->tm_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_INFO_FMT "%s: tm_cmd busy!!!\n",
@@ -1834,10 +1839,12 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = type;
 	mpi_request->TaskMID = cpu_to_le16(smid_task);
+	mpi_request->VP_ID = 0;  /* TODO */
+	mpi_request->VF_ID = 0;
 	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
 	mpt2sas_scsih_set_tm_flag(ioc, handle);
 	init_completion(&ioc->tm_cmds.done);
-	mpt2sas_base_put_smid_hi_priority(ioc, smid, VF_ID);
+	mpt2sas_base_put_smid_hi_priority(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	mpt2sas_scsih_clear_tm_flag(ioc, handle);
 	if (!(ioc->tm_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -2643,7 +2650,8 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	mpi_request->SGLOffset0 = offsetof(Mpi2SCSIIORequest_t, SGL) / 4;
 	mpi_request->SGLFlags = cpu_to_le16(MPI2_SCSIIO_SGLFLAGS_TYPE_MPI +
 	    MPI2_SCSIIO_SGLFLAGS_SYSTEM_ADDR);
-
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	int_to_scsilun(sas_device_priv_data->lun, (struct scsi_lun *)
 	    mpi_request->LUN);
 	memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
@@ -2658,7 +2666,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	_scsih_scsi_lookup_set(ioc, smid, scmd);
-	mpt2sas_base_put_smid_scsi_io(ioc, smid, 0,
+	mpt2sas_base_put_smid_scsi_io(ioc, smid,
 	    sas_device_priv_data->sas_target->handle);
 	return 0;
 
@@ -2954,7 +2962,7 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
  * _scsih_io_done - scsi request callback
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
  * Callback handler when using scsih_qcmd.
@@ -2962,7 +2970,7 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
  * Return nothing.
  */
 static void
-_scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+_scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 {
 	Mpi2SCSIIORequest_t *mpi_request;
 	Mpi2SCSIIOReply_t *mpi_reply;
@@ -3690,7 +3698,8 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	mpi_request.Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
 	mpi_request.Operation = MPI2_SAS_OP_REMOVE_DEVICE;
 	mpi_request.DevHandle = handle;
-	mpi_request.VF_ID = 0;
+	mpi_request.VF_ID = 0; /* TODO */
+	mpi_request.VP_ID = 0;
 	if ((mpt2sas_base_sas_iounit_control(ioc, &mpi_reply,
 	    &mpi_request)) != 0) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
@@ -3800,15 +3809,12 @@ _scsih_sas_topology_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_topology_change_event - handle topology changes
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
- * fw_event:
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  */
 static void
-_scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasTopologyChangeList_t *event_data,
+_scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
     struct fw_event_work *fw_event)
 {
 	int i;
@@ -3818,6 +3824,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	struct _sas_node *sas_expander;
 	unsigned long flags;
 	u8 link_rate_;
+	Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -3971,19 +3978,19 @@ _scsih_sas_device_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_device_status_change_event - handle device status change
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasDeviceStatusChange_t *event_data)
+_scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
-		_scsih_sas_device_status_change_event_debug(ioc, event_data);
+		_scsih_sas_device_status_change_event_debug(ioc,
+		     fw_event->event_data);
 #endif
 }
 
@@ -4026,34 +4033,33 @@ _scsih_sas_enclosure_dev_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_enclosure_dev_status_change_event - handle enclosure events
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
 _scsih_sas_enclosure_dev_status_change_event(struct MPT2SAS_ADAPTER *ioc,
-    u8 VF_ID, Mpi2EventDataSasEnclDevStatusChange_t *event_data)
+    struct fw_event_work *fw_event)
 {
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
-		     event_data);
+		     fw_event->event_data);
 #endif
 }
 
 /**
  * _scsih_sas_broadcast_primative_event - handle broadcast events
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasBroadcastPrimitive_t *event_data)
+_scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	struct scsi_cmnd *scmd;
 	u16 smid, handle;
@@ -4062,11 +4068,12 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-
+#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
+	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
+#endif
 	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "broadcast primative: "
 	    "phy number(%d), width(%d)\n", ioc->name, event_data->PhyNum,
 	    event_data->PortWidth));
-
 	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
@@ -4121,15 +4128,17 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 /**
  * _scsih_sas_discovery_event - handle discovery events
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasDiscovery_t *event_data)
+_scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
+	Mpi2EventDataSasDiscovery_t *event_data = fw_event->event_data;
+
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
 		printk(MPT2SAS_DEBUG_FMT "discovery event: (%s)", ioc->name,
@@ -4488,19 +4497,19 @@ _scsih_sas_ir_config_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_ir_config_change_event - handle ir configuration change events
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataIrConfigChangeList_t *event_data)
+_scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	Mpi2EventIrConfigElement_t *element;
 	int i;
 	u8 foreign_config;
+	Mpi2EventDataIrConfigChangeList_t *event_data = fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -4543,14 +4552,14 @@ _scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 /**
  * _scsih_sas_ir_volume_event - IR volume event
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataIrVolume_t *event_data)
+_scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	u64 wwid;
 	unsigned long flags;
@@ -4559,6 +4568,7 @@ _scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	u32 state;
 	int rc;
 	struct MPT2SAS_TARGET *sas_target_priv_data;
+	Mpi2EventDataIrVolume_t *event_data = fw_event->event_data;
 
 	if (event_data->ReasonCode != MPI2_EVENT_IR_VOLUME_RC_STATE_CHANGED)
 		return;
@@ -4628,14 +4638,14 @@ _scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 /**
  * _scsih_sas_ir_physical_disk_event - PD event
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-   Mpi2EventDataIrPhysicalDisk_t *event_data)
+_scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	u16 handle;
 	u32 state;
@@ -4644,6 +4654,7 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	u32 ioc_status;
+	Mpi2EventDataIrPhysicalDisk_t *event_data = fw_event->event_data;
 
 	if (event_data->ReasonCode != MPI2_EVENT_IR_PHYSDISK_RC_STATE_CHANGED)
 		return;
@@ -4743,33 +4754,33 @@ _scsih_sas_ir_operation_status_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_ir_operation_status_event - handle RAID operation events
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_operation_status_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataIrOperationStatus_t *event_data)
+_scsih_sas_ir_operation_status_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
-		_scsih_sas_ir_operation_status_event_debug(ioc, event_data);
+		_scsih_sas_ir_operation_status_event_debug(ioc,
+		     fw_event->event_data);
 #endif
 }
 
 /**
  * _scsih_task_set_full - handle task set full
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Throttle back qdepth.
  */
 static void
-_scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataTaskSetFull_t *event_data)
+_scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
+	*fw_event)
 {
 	unsigned long flags;
 	struct _sas_device *sas_device;
@@ -4780,6 +4791,7 @@ _scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	u16 handle;
 	int id, channel;
 	u64 sas_address;
+	Mpi2EventDataTaskSetFull_t *event_data = fw_event->event_data;
 
 	current_depth = le16_to_cpu(event_data->CurrentDepth);
 	handle = le16_to_cpu(event_data->DevHandle);
@@ -5227,44 +5239,38 @@ _firmware_event_work(struct work_struct *work)
 
 	switch (fw_event->event) {
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
-		_scsih_sas_topology_change_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data, fw_event);
+		_scsih_sas_topology_change_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
-		_scsih_sas_device_status_change_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_device_status_change_event(ioc,
+		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_DISCOVERY:
-		_scsih_sas_discovery_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_discovery_event(ioc,
+		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-		_scsih_sas_broadcast_primative_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_broadcast_primative_event(ioc,
+		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
 		_scsih_sas_enclosure_dev_status_change_event(ioc,
-		    fw_event->VF_ID, fw_event->event_data);
+		    fw_event);
 		break;
 	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
-		_scsih_sas_ir_config_change_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_config_change_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_IR_VOLUME:
-		_scsih_sas_ir_volume_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_volume_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_IR_PHYSICAL_DISK:
-		_scsih_sas_ir_physical_disk_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_physical_disk_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_IR_OPERATION_STATUS:
-		_scsih_sas_ir_operation_status_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_operation_status_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_TASK_SET_FULL:
-		_scsih_task_set_full(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_task_set_full(ioc, fw_event);
 		break;
 	}
 	_scsih_fw_event_free(ioc, fw_event);
@@ -5273,7 +5279,7 @@ _firmware_event_work(struct work_struct *work)
 /**
  * mpt2sas_scsih_event_callback - firmware event handler (called at ISR time)
  * @ioc: per adapter object
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: interrupt.
  *
@@ -5283,7 +5289,8 @@ _firmware_event_work(struct work_struct *work)
  * Return nothing.
  */
 void
-mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
+mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+	u32 reply)
 {
 	struct fw_event_work *fw_event;
 	Mpi2EventNotificationReply_t *mpi_reply;
@@ -5355,7 +5362,8 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 	memcpy(fw_event->event_data, mpi_reply->EventData,
 	    mpi_reply->EventDataLength*4);
 	fw_event->ioc = ioc;
-	fw_event->VF_ID = VF_ID;
+	fw_event->VF_ID = mpi_reply->VF_ID;
+	fw_event->VP_ID = mpi_reply->VP_ID;
 	fw_event->event = event;
 	_scsih_fw_event_add(ioc, fw_event);
 }
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 742324a..4b0e90e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -212,7 +212,7 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
  * mpt2sas_transport_done -  internal transport layer callback handler.
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
  * Callback handler when sending internal generated transport cmds.
@@ -221,7 +221,7 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
  * Return nothing.
  */
 void
-mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
+mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
@@ -369,6 +369,8 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
 	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	sas_address_le = (u64 *)&mpi_request->SASAddress;
 	*sas_address_le = cpu_to_le64(sas_address);
 	mpi_request->RequestDataLength = sizeof(struct rep_manu_request);
@@ -396,7 +398,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "report_manufacture - "
 	    "send to sas_addr(0x%016llx)\n", ioc->name,
 	    (unsigned long long)sas_address));
-	mpt2sas_base_put_smid_default(ioc, smid, 0 /* VF_ID */);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
@@ -1106,6 +1108,8 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
 	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	*((u64 *)&mpi_request->SASAddress) = (rphy) ?
 	    cpu_to_le64(rphy->identify.sas_address) :
 	    cpu_to_le64(ioc->sas_hba.sas_address);
@@ -1147,7 +1151,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s - "
 	    "sending smp request\n", ioc->name, __func__));
 
-	mpt2sas_base_put_smid_default(ioc, smid, 0 /* VF_ID */);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
