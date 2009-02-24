From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 7/11] mpt2sas: mpi headers
Date: Tue, 24 Feb 2009 02:36:57 -0700
Message-ID: <20090224093652.GG11813@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:42541 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZBXXSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 18:18:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

mpi headers

Common MPI (Message Passing Interface) Headers.

Signed-off-by: Eric Moore <eric.moore@lsi.com>
---

diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,1067 @@
+/*
+ *  Copyright (c) 2000-2009 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2.h
+ *          Title:  MPI Message independent structures and definitions
+ *                  including System Interface Register Set and
+ *                  scatter/gather formats.
+ *  Creation Date:  June 21, 2006
+ *
+ *  mpi2.h Version:  02.00.11
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  06-26-07  02.00.02  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  08-31-07  02.00.03  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Moved ReplyPostHostIndex register to offset 0x6C of the
+ *                      MPI2_SYSTEM_INTERFACE_REGS and modified the define for
+ *                      MPI2_REPLY_POST_HOST_INDEX_OFFSET.
+ *                      Added union of request descriptors.
+ *                      Added union of reply descriptors.
+ *  10-31-07  02.00.04  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Added define for MPI2_VERSION_02_00.
+ *                      Fixed the size of the FunctionDependent5 field in the
+ *                      MPI2_DEFAULT_REPLY structure.
+ *  12-18-07  02.00.05  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Removed the MPI-defined Fault Codes and extended the
+ *                      product specific codes up to 0xEFFF.
+ *                      Added a sixth key value for the WriteSequence register
+ *                      and changed the flush value to 0x0.
+ *                      Added message function codes for Diagnostic Buffer Post
+ *                      and Diagnsotic Release.
+ *                      New IOCStatus define: MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED
+ *                      Moved MPI2_VERSION_UNION from mpi2_ioc.h.
+ *  02-29-08  02.00.06  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  03-03-08  02.00.07  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  05-21-08  02.00.08  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Added #defines for marking a reply descriptor as unused.
+ *  06-27-08  02.00.09  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  10-02-08  02.00.10  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Moved LUN field defines from mpi2_init.h.
+ *  01-19-09  02.00.11  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_H
+#define MPI2_H
+
+
+/*****************************************************************************
+*
+*        MPI Version Definitions
+*
+*****************************************************************************/
+
+#define MPI2_VERSION_MAJOR                  (0x02)
+#define MPI2_VERSION_MINOR                  (0x00)
+#define MPI2_VERSION_MAJOR_MASK             (0xFF00)
+#define MPI2_VERSION_MAJOR_SHIFT            (8)
+#define MPI2_VERSION_MINOR_MASK             (0x00FF)
+#define MPI2_VERSION_MINOR_SHIFT            (0)
+#define MPI2_VERSION ((MPI2_VERSION_MAJOR << MPI2_VERSION_MAJOR_SHIFT) |   \
+                                      MPI2_VERSION_MINOR)
+
+#define MPI2_VERSION_02_00                  (0x0200)
+
+/* versioning for this MPI header set */
+#define MPI2_HEADER_VERSION_UNIT            (0x0B)
+#define MPI2_HEADER_VERSION_DEV             (0x00)
+#define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
+#define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
+#define MPI2_HEADER_VERSION_DEV_MASK        (0x00FF)
+#define MPI2_HEADER_VERSION_DEV_SHIFT       (0)
+#define MPI2_HEADER_VERSION ((MPI2_HEADER_VERSION_UNIT << 8) | MPI2_HEADER_VERSION_DEV)
+
+
+/*****************************************************************************
+*
+*        IOC State Definitions
+*
+*****************************************************************************/
+
+#define MPI2_IOC_STATE_RESET               (0x00000000)
+#define MPI2_IOC_STATE_READY               (0x10000000)
+#define MPI2_IOC_STATE_OPERATIONAL         (0x20000000)
+#define MPI2_IOC_STATE_FAULT               (0x40000000)
+
+#define MPI2_IOC_STATE_MASK                (0xF0000000)
+#define MPI2_IOC_STATE_SHIFT               (28)
+
+/* Fault state range for prodcut specific codes */
+#define MPI2_FAULT_PRODUCT_SPECIFIC_MIN                 (0x0000)
+#define MPI2_FAULT_PRODUCT_SPECIFIC_MAX                 (0xEFFF)
+
+
+/*****************************************************************************
+*
+*        System Interface Register Definitions
+*
+*****************************************************************************/
+
+typedef volatile struct _MPI2_SYSTEM_INTERFACE_REGS
+{
+    U32         Doorbell;                   /* 0x00 */
+    U32         WriteSequence;              /* 0x04 */
+    U32         HostDiagnostic;             /* 0x08 */
+    U32         Reserved1;                  /* 0x0C */
+    U32         DiagRWData;                 /* 0x10 */
+    U32         DiagRWAddressLow;           /* 0x14 */
+    U32         DiagRWAddressHigh;          /* 0x18 */
+    U32         Reserved2[5];               /* 0x1C */
+    U32         HostInterruptStatus;        /* 0x30 */
+    U32         HostInterruptMask;          /* 0x34 */
+    U32         DCRData;                    /* 0x38 */
+    U32         DCRAddress;                 /* 0x3C */
+    U32         Reserved3[2];               /* 0x40 */
+    U32         ReplyFreeHostIndex;         /* 0x48 */
+    U32         Reserved4[8];               /* 0x4C */
+    U32         ReplyPostHostIndex;         /* 0x6C */
+    U32         Reserved5;                  /* 0x70 */
+    U32         HCBSize;                    /* 0x74 */
+    U32         HCBAddressLow;              /* 0x78 */
+    U32         HCBAddressHigh;             /* 0x7C */
+    U32         Reserved6[16];              /* 0x80 */
+    U32         RequestDescriptorPostLow;   /* 0xC0 */
+    U32         RequestDescriptorPostHigh;  /* 0xC4 */
+    U32         Reserved7[14];              /* 0xC8 */
+} MPI2_SYSTEM_INTERFACE_REGS, MPI2_POINTER PTR_MPI2_SYSTEM_INTERFACE_REGS,
+  Mpi2SystemInterfaceRegs_t, MPI2_POINTER pMpi2SystemInterfaceRegs_t;
+
+/*
+ * Defines for working with the Doorbell register.
+ */
+#define MPI2_DOORBELL_OFFSET                    (0x00000000)
+
+/* IOC --> System values */
+#define MPI2_DOORBELL_USED                      (0x08000000)
+#define MPI2_DOORBELL_WHO_INIT_MASK             (0x07000000)
+#define MPI2_DOORBELL_WHO_INIT_SHIFT            (24)
+#define MPI2_DOORBELL_FAULT_CODE_MASK           (0x0000FFFF)
+#define MPI2_DOORBELL_DATA_MASK                 (0x0000FFFF)
+
+/* System --> IOC values */
+#define MPI2_DOORBELL_FUNCTION_MASK             (0xFF000000)
+#define MPI2_DOORBELL_FUNCTION_SHIFT            (24)
+#define MPI2_DOORBELL_ADD_DWORDS_MASK           (0x00FF0000)
+#define MPI2_DOORBELL_ADD_DWORDS_SHIFT          (16)
+
+
+/*
+ * Defines for the WriteSequence register
+ */
+#define MPI2_WRITE_SEQUENCE_OFFSET              (0x00000004)
+#define MPI2_WRSEQ_KEY_VALUE_MASK               (0x0000000F)
+#define MPI2_WRSEQ_FLUSH_KEY_VALUE              (0x0)
+#define MPI2_WRSEQ_1ST_KEY_VALUE                (0xF)
+#define MPI2_WRSEQ_2ND_KEY_VALUE                (0x4)
+#define MPI2_WRSEQ_3RD_KEY_VALUE                (0xB)
+#define MPI2_WRSEQ_4TH_KEY_VALUE                (0x2)
+#define MPI2_WRSEQ_5TH_KEY_VALUE                (0x7)
+#define MPI2_WRSEQ_6TH_KEY_VALUE                (0xD)
+
+/*
+ * Defines for the HostDiagnostic register
+ */
+#define MPI2_HOST_DIAGNOSTIC_OFFSET             (0x00000008)
+
+#define MPI2_DIAG_BOOT_DEVICE_SELECT_MASK       (0x00001800)
+#define MPI2_DIAG_BOOT_DEVICE_SELECT_DEFAULT    (0x00000000)
+#define MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW       (0x00000800)
+
+#define MPI2_DIAG_CLEAR_FLASH_BAD_SIG           (0x00000400)
+#define MPI2_DIAG_FORCE_HCB_ON_RESET            (0x00000200)
+#define MPI2_DIAG_HCB_MODE                      (0x00000100)
+#define MPI2_DIAG_DIAG_WRITE_ENABLE             (0x00000080)
+#define MPI2_DIAG_FLASH_BAD_SIG                 (0x00000040)
+#define MPI2_DIAG_RESET_HISTORY                 (0x00000020)
+#define MPI2_DIAG_DIAG_RW_ENABLE                (0x00000010)
+#define MPI2_DIAG_RESET_ADAPTER                 (0x00000004)
+#define MPI2_DIAG_HOLD_IOC_RESET                (0x00000002)
+
+/*
+ * Offsets for DiagRWData and address
+ */
+#define MPI2_DIAG_RW_DATA_OFFSET                (0x00000010)
+#define MPI2_DIAG_RW_ADDRESS_LOW_OFFSET         (0x00000014)
+#define MPI2_DIAG_RW_ADDRESS_HIGH_OFFSET        (0x00000018)
+
+/*
+ * Defines for the HostInterruptStatus register
+ */
+#define MPI2_HOST_INTERRUPT_STATUS_OFFSET       (0x00000030)
+#define MPI2_HIS_SYS2IOC_DB_STATUS              (0x80000000)
+#define MPI2_HIS_IOP_DOORBELL_STATUS            MPI2_HIS_SYS2IOC_DB_STATUS
+#define MPI2_HIS_RESET_IRQ_STATUS               (0x40000000)
+#define MPI2_HIS_REPLY_DESCRIPTOR_INTERRUPT     (0x00000008)
+#define MPI2_HIS_IOC2SYS_DB_STATUS              (0x00000001)
+#define MPI2_HIS_DOORBELL_INTERRUPT             MPI2_HIS_IOC2SYS_DB_STATUS
+
+/*
+ * Defines for the HostInterruptMask register
+ */
+#define MPI2_HOST_INTERRUPT_MASK_OFFSET         (0x00000034)
+#define MPI2_HIM_RESET_IRQ_MASK                 (0x40000000)
+#define MPI2_HIM_REPLY_INT_MASK                 (0x00000008)
+#define MPI2_HIM_RIM                            MPI2_HIM_REPLY_INT_MASK
+#define MPI2_HIM_IOC2SYS_DB_MASK                (0x00000001)
+#define MPI2_HIM_DIM                            MPI2_HIM_IOC2SYS_DB_MASK
+
+/*
+ * Offsets for DCRData and address
+ */
+#define MPI2_DCR_DATA_OFFSET                    (0x00000038)
+#define MPI2_DCR_ADDRESS_OFFSET                 (0x0000003C)
+
+/*
+ * Offset for the Reply Free Queue
+ */
+#define MPI2_REPLY_FREE_HOST_INDEX_OFFSET       (0x00000048)
+
+/*
+ * Offset for the Reply Descriptor Post Queue
+ */
+#define MPI2_REPLY_POST_HOST_INDEX_OFFSET       (0x0000006C)
+
+/*
+ * Defines for the HCBSize and address
+ */
+#define MPI2_HCB_SIZE_OFFSET                    (0x00000074)
+#define MPI2_HCB_SIZE_SIZE_MASK                 (0xFFFFF000)
+#define MPI2_HCB_SIZE_HCB_ENABLE                (0x00000001)
+
+#define MPI2_HCB_ADDRESS_LOW_OFFSET             (0x00000078)
+#define MPI2_HCB_ADDRESS_HIGH_OFFSET            (0x0000007C)
+
+/*
+ * Offsets for the Request Queue
+ */
+#define MPI2_REQUEST_DESCRIPTOR_POST_LOW_OFFSET     (0x000000C0)
+#define MPI2_REQUEST_DESCRIPTOR_POST_HIGH_OFFSET    (0x000000C4)
+
+
+/*****************************************************************************
+*
+*        Message Descriptors
+*
+*****************************************************************************/
+
+/* Request Descriptors */
+
+/* Default Request Descriptor */
+typedef struct _MPI2_DEFAULT_REQUEST_DESCRIPTOR
+{
+    U8              RequestFlags;               /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U16             LMID;                       /* 0x04 */
+    U16             DescriptorTypeDependent;    /* 0x06 */
+} MPI2_DEFAULT_REQUEST_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_DEFAULT_REQUEST_DESCRIPTOR,
+  Mpi2DefaultRequestDescriptor_t, MPI2_POINTER pMpi2DefaultRequestDescriptor_t;
+
+/* defines for the RequestFlags field */
+#define MPI2_REQ_DESCRIPT_FLAGS_TYPE_MASK               (0x0E)
+#define MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO                 (0x00)
+#define MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET             (0x02)
+#define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY           (0x06)
+#define MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE            (0x08)
+
+#define MPI2_REQ_DESCRIPT_FLAGS_IOC_FIFO_MARKER (0x01)
+
+
+/* High Priority Request Descriptor */
+typedef struct _MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR
+{
+    U8              RequestFlags;               /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U16             LMID;                       /* 0x04 */
+    U16             Reserved1;                  /* 0x06 */
+} MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR,
+  Mpi2HighPriorityRequestDescriptor_t,
+  MPI2_POINTER pMpi2HighPriorityRequestDescriptor_t;
+
+
+/* SCSI IO Request Descriptor */
+typedef struct _MPI2_SCSI_IO_REQUEST_DESCRIPTOR
+{
+    U8              RequestFlags;               /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U16             LMID;                       /* 0x04 */
+    U16             DevHandle;                  /* 0x06 */
+} MPI2_SCSI_IO_REQUEST_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_SCSI_IO_REQUEST_DESCRIPTOR,
+  Mpi2SCSIIORequestDescriptor_t, MPI2_POINTER pMpi2SCSIIORequestDescriptor_t;
+
+
+/* SCSI Target Request Descriptor */
+typedef struct _MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR
+{
+    U8              RequestFlags;               /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U16             LMID;                       /* 0x04 */
+    U16             IoIndex;                    /* 0x06 */
+} MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR,
+  Mpi2SCSITargetRequestDescriptor_t,
+  MPI2_POINTER pMpi2SCSITargetRequestDescriptor_t;
+
+/* union of Request Descriptors */
+typedef union _MPI2_REQUEST_DESCRIPTOR_UNION
+{
+    MPI2_DEFAULT_REQUEST_DESCRIPTOR         Default;
+    MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR   HighPriority;
+    MPI2_SCSI_IO_REQUEST_DESCRIPTOR         SCSIIO;
+    MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR     SCSITarget;
+    U64                                     Words;
+} MPI2_REQUEST_DESCRIPTOR_UNION, MPI2_POINTER PTR_MPI2_REQUEST_DESCRIPTOR_UNION,
+  Mpi2RequestDescriptorUnion_t, MPI2_POINTER pMpi2RequestDescriptorUnion_t;
+
+
+/* Reply Descriptors */
+
+/* Default Reply Descriptor */
+typedef struct _MPI2_DEFAULT_REPLY_DESCRIPTOR
+{
+    U8              ReplyFlags;                 /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             DescriptorTypeDependent1;   /* 0x02 */
+    U32             DescriptorTypeDependent2;   /* 0x04 */
+} MPI2_DEFAULT_REPLY_DESCRIPTOR, MPI2_POINTER PTR_MPI2_DEFAULT_REPLY_DESCRIPTOR,
+  Mpi2DefaultReplyDescriptor_t, MPI2_POINTER pMpi2DefaultReplyDescriptor_t;
+
+/* defines for the ReplyFlags field */
+#define MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK               (0x0F)
+#define MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS         (0x00)
+#define MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY           (0x01)
+#define MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS    (0x02)
+#define MPI2_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER   (0x03)
+#define MPI2_RPY_DESCRIPT_FLAGS_UNUSED                  (0x0F)
+
+/* values for marking a reply descriptor as unused */
+#define MPI2_RPY_DESCRIPT_UNUSED_WORD0_MARK             (0xFFFFFFFF)
+#define MPI2_RPY_DESCRIPT_UNUSED_WORD1_MARK             (0xFFFFFFFF)
+
+/* Address Reply Descriptor */
+typedef struct _MPI2_ADDRESS_REPLY_DESCRIPTOR
+{
+    U8              ReplyFlags;                 /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U32             ReplyFrameAddress;          /* 0x04 */
+} MPI2_ADDRESS_REPLY_DESCRIPTOR, MPI2_POINTER PTR_MPI2_ADDRESS_REPLY_DESCRIPTOR,
+  Mpi2AddressReplyDescriptor_t, MPI2_POINTER pMpi2AddressReplyDescriptor_t;
+
+#define MPI2_ADDRESS_REPLY_SMID_INVALID                 (0x00)
+
+
+/* SCSI IO Success Reply Descriptor */
+typedef struct _MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR
+{
+    U8              ReplyFlags;                 /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U16             TaskTag;                    /* 0x04 */
+    U16             DevHandle;                  /* 0x06 */
+} MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR,
+  Mpi2SCSIIOSuccessReplyDescriptor_t,
+  MPI2_POINTER pMpi2SCSIIOSuccessReplyDescriptor_t;
+
+
+/* TargetAssist Success Reply Descriptor */
+typedef struct _MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR
+{
+    U8              ReplyFlags;                 /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U8              SequenceNumber;             /* 0x04 */
+    U8              Reserved1;                  /* 0x05 */
+    U16             IoIndex;                    /* 0x06 */
+} MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR,
+  Mpi2TargetAssistSuccessReplyDescriptor_t,
+  MPI2_POINTER pMpi2TargetAssistSuccessReplyDescriptor_t;
+
+
+/* Target Command Buffer Reply Descriptor */
+typedef struct _MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR
+{
+    U8              ReplyFlags;                 /* 0x00 */
+    U8              VF_ID;                      /* 0x01 */
+    U8              VP_ID;                      /* 0x02 */
+    U8              Flags;                      /* 0x03 */
+    U16             InitiatorDevHandle;         /* 0x04 */
+    U16             IoIndex;                    /* 0x06 */
+} MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR,
+  Mpi2TargetCommandBufferReplyDescriptor_t,
+  MPI2_POINTER pMpi2TargetCommandBufferReplyDescriptor_t;
+
+/* defines for Flags field */
+#define MPI2_RPY_DESCRIPT_TCB_FLAGS_PHYNUM_MASK     (0x3F)
+
+
+/* union of Reply Descriptors */
+typedef union _MPI2_REPLY_DESCRIPTORS_UNION
+{
+    MPI2_DEFAULT_REPLY_DESCRIPTOR               Default;
+    MPI2_ADDRESS_REPLY_DESCRIPTOR               AddressReply;
+    MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR       SCSIIOSuccess;
+    MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR  TargetAssistSuccess;
+    MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR TargetCommandBuffer;
+    U64                                         Words;
+} MPI2_REPLY_DESCRIPTORS_UNION, MPI2_POINTER PTR_MPI2_REPLY_DESCRIPTORS_UNION,
+  Mpi2ReplyDescriptorsUnion_t, MPI2_POINTER pMpi2ReplyDescriptorsUnion_t;
+
+
+
+/*****************************************************************************
+*
+*        Message Functions
+*              0x80 -> 0x8F reserved for private message use per product
+*
+*
+*****************************************************************************/
+
+#define MPI2_FUNCTION_SCSI_IO_REQUEST               (0x00) /* SCSI IO */
+#define MPI2_FUNCTION_SCSI_TASK_MGMT                (0x01) /* SCSI Task Management */
+#define MPI2_FUNCTION_IOC_INIT                      (0x02) /* IOC Init */
+#define MPI2_FUNCTION_IOC_FACTS                     (0x03) /* IOC Facts */
+#define MPI2_FUNCTION_CONFIG                        (0x04) /* Configuration */
+#define MPI2_FUNCTION_PORT_FACTS                    (0x05) /* Port Facts */
+#define MPI2_FUNCTION_PORT_ENABLE                   (0x06) /* Port Enable */
+#define MPI2_FUNCTION_EVENT_NOTIFICATION            (0x07) /* Event Notification */
+#define MPI2_FUNCTION_EVENT_ACK                     (0x08) /* Event Acknowledge */
+#define MPI2_FUNCTION_FW_DOWNLOAD                   (0x09) /* FW Download */
+#define MPI2_FUNCTION_TARGET_ASSIST                 (0x0B) /* Target Assist */
+#define MPI2_FUNCTION_TARGET_STATUS_SEND            (0x0C) /* Target Status Send */
+#define MPI2_FUNCTION_TARGET_MODE_ABORT             (0x0D) /* Target Mode Abort */
+#define MPI2_FUNCTION_FW_UPLOAD                     (0x12) /* FW Upload */
+#define MPI2_FUNCTION_RAID_ACTION                   (0x15) /* RAID Action */
+#define MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH      (0x16) /* SCSI IO RAID Passthrough */
+#define MPI2_FUNCTION_TOOLBOX                       (0x17) /* Toolbox */
+#define MPI2_FUNCTION_SCSI_ENCLOSURE_PROCESSOR      (0x18) /* SCSI Enclosure Processor */
+#define MPI2_FUNCTION_SMP_PASSTHROUGH               (0x1A) /* SMP Passthrough */
+#define MPI2_FUNCTION_SAS_IO_UNIT_CONTROL           (0x1B) /* SAS IO Unit Control */
+#define MPI2_FUNCTION_SATA_PASSTHROUGH              (0x1C) /* SATA Passthrough */
+#define MPI2_FUNCTION_DIAG_BUFFER_POST              (0x1D) /* Diagnostic Buffer Post */
+#define MPI2_FUNCTION_DIAG_RELEASE                  (0x1E) /* Diagnostic Release */
+#define MPI2_FUNCTION_TARGET_CMD_BUF_BASE_POST      (0x24) /* Target Command Buffer Post Base */
+#define MPI2_FUNCTION_TARGET_CMD_BUF_LIST_POST      (0x25) /* Target Command Buffer Post List */
+
+
+
+/* Doorbell functions */
+#define MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET        (0x40)
+/* #define MPI2_FUNCTION_IO_UNIT_RESET                 (0x41) */
+#define MPI2_FUNCTION_HANDSHAKE                     (0x42)
+
+
+/*****************************************************************************
+*
+*        IOC Status Values
+*
+*****************************************************************************/
+
+/* mask for IOCStatus status value */
+#define MPI2_IOCSTATUS_MASK                     (0x7FFF)
+
+/****************************************************************************
+*  Common IOCStatus values for all replies
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_SUCCESS                      (0x0000)
+#define MPI2_IOCSTATUS_INVALID_FUNCTION             (0x0001)
+#define MPI2_IOCSTATUS_BUSY                         (0x0002)
+#define MPI2_IOCSTATUS_INVALID_SGL                  (0x0003)
+#define MPI2_IOCSTATUS_INTERNAL_ERROR               (0x0004)
+#define MPI2_IOCSTATUS_INVALID_VPID                 (0x0005)
+#define MPI2_IOCSTATUS_INSUFFICIENT_RESOURCES       (0x0006)
+#define MPI2_IOCSTATUS_INVALID_FIELD                (0x0007)
+#define MPI2_IOCSTATUS_INVALID_STATE                (0x0008)
+#define MPI2_IOCSTATUS_OP_STATE_NOT_SUPPORTED       (0x0009)
+
+/****************************************************************************
+*  Config IOCStatus values
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_CONFIG_INVALID_ACTION        (0x0020)
+#define MPI2_IOCSTATUS_CONFIG_INVALID_TYPE          (0x0021)
+#define MPI2_IOCSTATUS_CONFIG_INVALID_PAGE          (0x0022)
+#define MPI2_IOCSTATUS_CONFIG_INVALID_DATA          (0x0023)
+#define MPI2_IOCSTATUS_CONFIG_NO_DEFAULTS           (0x0024)
+#define MPI2_IOCSTATUS_CONFIG_CANT_COMMIT           (0x0025)
+
+/****************************************************************************
+*  SCSI IO Reply
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR         (0x0040)
+#define MPI2_IOCSTATUS_SCSI_INVALID_DEVHANDLE       (0x0042)
+#define MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE        (0x0043)
+#define MPI2_IOCSTATUS_SCSI_DATA_OVERRUN            (0x0044)
+#define MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN           (0x0045)
+#define MPI2_IOCSTATUS_SCSI_IO_DATA_ERROR           (0x0046)
+#define MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR          (0x0047)
+#define MPI2_IOCSTATUS_SCSI_TASK_TERMINATED         (0x0048)
+#define MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH       (0x0049)
+#define MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED        (0x004A)
+#define MPI2_IOCSTATUS_SCSI_IOC_TERMINATED          (0x004B)
+#define MPI2_IOCSTATUS_SCSI_EXT_TERMINATED          (0x004C)
+
+/****************************************************************************
+*  For use by SCSI Initiator and SCSI Target end-to-end data protection
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_EEDP_GUARD_ERROR             (0x004D)
+#define MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR           (0x004E)
+#define MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR           (0x004F)
+
+/****************************************************************************
+*  SCSI Target values
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_TARGET_INVALID_IO_INDEX      (0x0062)
+#define MPI2_IOCSTATUS_TARGET_ABORTED               (0x0063)
+#define MPI2_IOCSTATUS_TARGET_NO_CONN_RETRYABLE     (0x0064)
+#define MPI2_IOCSTATUS_TARGET_NO_CONNECTION         (0x0065)
+#define MPI2_IOCSTATUS_TARGET_XFER_COUNT_MISMATCH   (0x006A)
+#define MPI2_IOCSTATUS_TARGET_DATA_OFFSET_ERROR     (0x006D)
+#define MPI2_IOCSTATUS_TARGET_TOO_MUCH_WRITE_DATA   (0x006E)
+#define MPI2_IOCSTATUS_TARGET_IU_TOO_SHORT          (0x006F)
+#define MPI2_IOCSTATUS_TARGET_ACK_NAK_TIMEOUT       (0x0070)
+#define MPI2_IOCSTATUS_TARGET_NAK_RECEIVED          (0x0071)
+
+/****************************************************************************
+*  Serial Attached SCSI values
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_SAS_SMP_REQUEST_FAILED       (0x0090)
+#define MPI2_IOCSTATUS_SAS_SMP_DATA_OVERRUN         (0x0091)
+
+/****************************************************************************
+*  Diagnostic Buffer Post / Diagnostic Release values
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED          (0x00A0)
+
+
+/****************************************************************************
+*  IOCStatus flag to indicate that log info is available
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE  (0x8000)
+
+/****************************************************************************
+*  IOCLogInfo Types
+****************************************************************************/
+
+#define MPI2_IOCLOGINFO_TYPE_MASK               (0xF0000000)
+#define MPI2_IOCLOGINFO_TYPE_SHIFT              (28)
+#define MPI2_IOCLOGINFO_TYPE_NONE               (0x0)
+#define MPI2_IOCLOGINFO_TYPE_SCSI               (0x1)
+#define MPI2_IOCLOGINFO_TYPE_FC                 (0x2)
+#define MPI2_IOCLOGINFO_TYPE_SAS                (0x3)
+#define MPI2_IOCLOGINFO_TYPE_ISCSI              (0x4)
+#define MPI2_IOCLOGINFO_LOG_DATA_MASK           (0x0FFFFFFF)
+
+
+/*****************************************************************************
+*
+*        Standard Message Structures
+*
+*****************************************************************************/
+
+/****************************************************************************
+* Request Message Header for all request messages
+****************************************************************************/
+
+typedef struct _MPI2_REQUEST_HEADER
+{
+    U16             FunctionDependent1;         /* 0x00 */
+    U8              ChainOffset;                /* 0x02 */
+    U8              Function;                   /* 0x03 */
+    U16             FunctionDependent2;         /* 0x04 */
+    U8              FunctionDependent3;         /* 0x06 */
+    U8              MsgFlags;                   /* 0x07 */
+    U8              VP_ID;                      /* 0x08 */
+    U8              VF_ID;                      /* 0x09 */
+    U16             Reserved1;                  /* 0x0A */
+} MPI2_REQUEST_HEADER, MPI2_POINTER PTR_MPI2_REQUEST_HEADER,
+  MPI2RequestHeader_t, MPI2_POINTER pMPI2RequestHeader_t;
+
+
+/****************************************************************************
+*  Default Reply
+****************************************************************************/
+
+typedef struct _MPI2_DEFAULT_REPLY
+{
+    U16             FunctionDependent1;         /* 0x00 */
+    U8              MsgLength;                  /* 0x02 */
+    U8              Function;                   /* 0x03 */
+    U16             FunctionDependent2;         /* 0x04 */
+    U8              FunctionDependent3;         /* 0x06 */
+    U8              MsgFlags;                   /* 0x07 */
+    U8              VP_ID;                      /* 0x08 */
+    U8              VF_ID;                      /* 0x09 */
+    U16             Reserved1;                  /* 0x0A */
+    U16             FunctionDependent5;         /* 0x0C */
+    U16             IOCStatus;                  /* 0x0E */
+    U32             IOCLogInfo;                 /* 0x10 */
+} MPI2_DEFAULT_REPLY, MPI2_POINTER PTR_MPI2_DEFAULT_REPLY,
+  MPI2DefaultReply_t, MPI2_POINTER pMPI2DefaultReply_t;
+
+
+/* common version structure/union used in messages and configuration pages */
+
+typedef struct _MPI2_VERSION_STRUCT
+{
+    U8                      Dev;                        /* 0x00 */
+    U8                      Unit;                       /* 0x01 */
+    U8                      Minor;                      /* 0x02 */
+    U8                      Major;                      /* 0x03 */
+} MPI2_VERSION_STRUCT;
+
+typedef union _MPI2_VERSION_UNION
+{
+    MPI2_VERSION_STRUCT     Struct;
+    U32                     Word;
+} MPI2_VERSION_UNION;
+
+
+/* LUN field defines, common to many structures */
+#define MPI2_LUN_FIRST_LEVEL_ADDRESSING             (0x0000FFFF)
+#define MPI2_LUN_SECOND_LEVEL_ADDRESSING            (0xFFFF0000)
+#define MPI2_LUN_THIRD_LEVEL_ADDRESSING             (0x0000FFFF)
+#define MPI2_LUN_FOURTH_LEVEL_ADDRESSING            (0xFFFF0000)
+#define MPI2_LUN_LEVEL_1_WORD                       (0xFF00)
+#define MPI2_LUN_LEVEL_1_DWORD                      (0x0000FF00)
+
+
+/*****************************************************************************
+*
+*        Fusion-MPT MPI Scatter Gather Elements
+*
+*****************************************************************************/
+
+/****************************************************************************
+*  MPI Simple Element structures
+****************************************************************************/
+
+typedef struct _MPI2_SGE_SIMPLE32
+{
+    U32                     FlagsLength;
+    U32                     Address;
+} MPI2_SGE_SIMPLE32, MPI2_POINTER PTR_MPI2_SGE_SIMPLE32,
+  Mpi2SGESimple32_t, MPI2_POINTER pMpi2SGESimple32_t;
+
+typedef struct _MPI2_SGE_SIMPLE64
+{
+    U32                     FlagsLength;
+    U64                     Address;
+} MPI2_SGE_SIMPLE64, MPI2_POINTER PTR_MPI2_SGE_SIMPLE64,
+  Mpi2SGESimple64_t, MPI2_POINTER pMpi2SGESimple64_t;
+
+typedef struct _MPI2_SGE_SIMPLE_UNION
+{
+    U32                     FlagsLength;
+    union
+    {
+        U32                 Address32;
+        U64                 Address64;
+    } u;
+} MPI2_SGE_SIMPLE_UNION, MPI2_POINTER PTR_MPI2_SGE_SIMPLE_UNION,
+  Mpi2SGESimpleUnion_t, MPI2_POINTER pMpi2SGESimpleUnion_t;
+
+
+/****************************************************************************
+*  MPI Chain Element structures
+****************************************************************************/
+
+typedef struct _MPI2_SGE_CHAIN32
+{
+    U16                     Length;
+    U8                      NextChainOffset;
+    U8                      Flags;
+    U32                     Address;
+} MPI2_SGE_CHAIN32, MPI2_POINTER PTR_MPI2_SGE_CHAIN32,
+  Mpi2SGEChain32_t, MPI2_POINTER pMpi2SGEChain32_t;
+
+typedef struct _MPI2_SGE_CHAIN64
+{
+    U16                     Length;
+    U8                      NextChainOffset;
+    U8                      Flags;
+    U64                     Address;
+} MPI2_SGE_CHAIN64, MPI2_POINTER PTR_MPI2_SGE_CHAIN64,
+  Mpi2SGEChain64_t, MPI2_POINTER pMpi2SGEChain64_t;
+
+typedef struct _MPI2_SGE_CHAIN_UNION
+{
+    U16                     Length;
+    U8                      NextChainOffset;
+    U8                      Flags;
+    union
+    {
+        U32                 Address32;
+        U64                 Address64;
+    } u;
+} MPI2_SGE_CHAIN_UNION, MPI2_POINTER PTR_MPI2_SGE_CHAIN_UNION,
+  Mpi2SGEChainUnion_t, MPI2_POINTER pMpi2SGEChainUnion_t;
+
+
+/****************************************************************************
+*  MPI Transaction Context Element structures
+****************************************************************************/
+
+typedef struct _MPI2_SGE_TRANSACTION32
+{
+    U8                      Reserved;
+    U8                      ContextSize;
+    U8                      DetailsLength;
+    U8                      Flags;
+    U32                     TransactionContext[1];
+    U32                     TransactionDetails[1];
+} MPI2_SGE_TRANSACTION32, MPI2_POINTER PTR_MPI2_SGE_TRANSACTION32,
+  Mpi2SGETransaction32_t, MPI2_POINTER pMpi2SGETransaction32_t;
+
+typedef struct _MPI2_SGE_TRANSACTION64
+{
+    U8                      Reserved;
+    U8                      ContextSize;
+    U8                      DetailsLength;
+    U8                      Flags;
+    U32                     TransactionContext[2];
+    U32                     TransactionDetails[1];
+} MPI2_SGE_TRANSACTION64, MPI2_POINTER PTR_MPI2_SGE_TRANSACTION64,
+  Mpi2SGETransaction64_t, MPI2_POINTER pMpi2SGETransaction64_t;
+
+typedef struct _MPI2_SGE_TRANSACTION96
+{
+    U8                      Reserved;
+    U8                      ContextSize;
+    U8                      DetailsLength;
+    U8                      Flags;
+    U32                     TransactionContext[3];
+    U32                     TransactionDetails[1];
+} MPI2_SGE_TRANSACTION96, MPI2_POINTER PTR_MPI2_SGE_TRANSACTION96,
+  Mpi2SGETransaction96_t, MPI2_POINTER pMpi2SGETransaction96_t;
+
+typedef struct _MPI2_SGE_TRANSACTION128
+{
+    U8                      Reserved;
+    U8                      ContextSize;
+    U8                      DetailsLength;
+    U8                      Flags;
+    U32                     TransactionContext[4];
+    U32                     TransactionDetails[1];
+} MPI2_SGE_TRANSACTION128, MPI2_POINTER PTR_MPI2_SGE_TRANSACTION128,
+  Mpi2SGETransaction_t128, MPI2_POINTER pMpi2SGETransaction_t128;
+
+typedef struct _MPI2_SGE_TRANSACTION_UNION
+{
+    U8                      Reserved;
+    U8                      ContextSize;
+    U8                      DetailsLength;
+    U8                      Flags;
+    union
+    {
+        U32                 TransactionContext32[1];
+        U32                 TransactionContext64[2];
+        U32                 TransactionContext96[3];
+        U32                 TransactionContext128[4];
+    } u;
+    U32                     TransactionDetails[1];
+} MPI2_SGE_TRANSACTION_UNION, MPI2_POINTER PTR_MPI2_SGE_TRANSACTION_UNION,
+  Mpi2SGETransactionUnion_t, MPI2_POINTER pMpi2SGETransactionUnion_t;
+
+
+/****************************************************************************
+*  MPI SGE union for IO SGL's
+****************************************************************************/
+
+typedef struct _MPI2_MPI_SGE_IO_UNION
+{
+    union
+    {
+        MPI2_SGE_SIMPLE_UNION   Simple;
+        MPI2_SGE_CHAIN_UNION    Chain;
+    } u;
+} MPI2_MPI_SGE_IO_UNION, MPI2_POINTER PTR_MPI2_MPI_SGE_IO_UNION,
+  Mpi2MpiSGEIOUnion_t, MPI2_POINTER pMpi2MpiSGEIOUnion_t;
+
+
+/****************************************************************************
+*  MPI SGE union for SGL's with Simple and Transaction elements
+****************************************************************************/
+
+typedef struct _MPI2_SGE_TRANS_SIMPLE_UNION
+{
+    union
+    {
+        MPI2_SGE_SIMPLE_UNION       Simple;
+        MPI2_SGE_TRANSACTION_UNION  Transaction;
+    } u;
+} MPI2_SGE_TRANS_SIMPLE_UNION, MPI2_POINTER PTR_MPI2_SGE_TRANS_SIMPLE_UNION,
+  Mpi2SGETransSimpleUnion_t, MPI2_POINTER pMpi2SGETransSimpleUnion_t;
+
+
+/****************************************************************************
+*  All MPI SGE types union
+****************************************************************************/
+
+typedef struct _MPI2_MPI_SGE_UNION
+{
+    union
+    {
+        MPI2_SGE_SIMPLE_UNION       Simple;
+        MPI2_SGE_CHAIN_UNION        Chain;
+        MPI2_SGE_TRANSACTION_UNION  Transaction;
+    } u;
+} MPI2_MPI_SGE_UNION, MPI2_POINTER PTR_MPI2_MPI_SGE_UNION,
+  Mpi2MpiSgeUnion_t, MPI2_POINTER pMpi2MpiSgeUnion_t;
+
+
+/****************************************************************************
+*  MPI SGE field definition and masks
+****************************************************************************/
+
+/* Flags field bit definitions */
+
+#define MPI2_SGE_FLAGS_LAST_ELEMENT             (0x80)
+#define MPI2_SGE_FLAGS_END_OF_BUFFER            (0x40)
+#define MPI2_SGE_FLAGS_ELEMENT_TYPE_MASK        (0x30)
+#define MPI2_SGE_FLAGS_LOCAL_ADDRESS            (0x08)
+#define MPI2_SGE_FLAGS_DIRECTION                (0x04)
+#define MPI2_SGE_FLAGS_ADDRESS_SIZE             (0x02)
+#define MPI2_SGE_FLAGS_END_OF_LIST              (0x01)
+
+#define MPI2_SGE_FLAGS_SHIFT                    (24)
+
+#define MPI2_SGE_LENGTH_MASK                    (0x00FFFFFF)
+#define MPI2_SGE_CHAIN_LENGTH_MASK              (0x0000FFFF)
+
+/* Element Type */
+
+#define MPI2_SGE_FLAGS_TRANSACTION_ELEMENT      (0x00)
+#define MPI2_SGE_FLAGS_SIMPLE_ELEMENT           (0x10)
+#define MPI2_SGE_FLAGS_CHAIN_ELEMENT            (0x30)
+#define MPI2_SGE_FLAGS_ELEMENT_MASK             (0x30)
+
+/* Address location */
+
+#define MPI2_SGE_FLAGS_SYSTEM_ADDRESS           (0x00)
+
+/* Direction */
+
+#define MPI2_SGE_FLAGS_IOC_TO_HOST              (0x00)
+#define MPI2_SGE_FLAGS_HOST_TO_IOC              (0x04)
+
+/* Address Size */
+
+#define MPI2_SGE_FLAGS_32_BIT_ADDRESSING        (0x00)
+#define MPI2_SGE_FLAGS_64_BIT_ADDRESSING        (0x02)
+
+/* Context Size */
+
+#define MPI2_SGE_FLAGS_32_BIT_CONTEXT           (0x00)
+#define MPI2_SGE_FLAGS_64_BIT_CONTEXT           (0x02)
+#define MPI2_SGE_FLAGS_96_BIT_CONTEXT           (0x04)
+#define MPI2_SGE_FLAGS_128_BIT_CONTEXT          (0x06)
+
+#define MPI2_SGE_CHAIN_OFFSET_MASK              (0x00FF0000)
+#define MPI2_SGE_CHAIN_OFFSET_SHIFT             (16)
+
+/****************************************************************************
+*  MPI SGE operation Macros
+****************************************************************************/
+
+/* SIMPLE FlagsLength manipulations... */
+#define MPI2_SGE_SET_FLAGS(f)          ((U32)(f) << MPI2_SGE_FLAGS_SHIFT)
+#define MPI2_SGE_GET_FLAGS(f)          (((f) & ~MPI2_SGE_LENGTH_MASK) >> MPI2_SGE_FLAGS_SHIFT)
+#define MPI2_SGE_LENGTH(f)             ((f) & MPI2_SGE_LENGTH_MASK)
+#define MPI2_SGE_CHAIN_LENGTH(f)       ((f) & MPI2_SGE_CHAIN_LENGTH_MASK)
+
+#define MPI2_SGE_SET_FLAGS_LENGTH(f,l) (MPI2_SGE_SET_FLAGS(f) | MPI2_SGE_LENGTH(l))
+
+#define MPI2_pSGE_GET_FLAGS(psg)            MPI2_SGE_GET_FLAGS((psg)->FlagsLength)
+#define MPI2_pSGE_GET_LENGTH(psg)           MPI2_SGE_LENGTH((psg)->FlagsLength)
+#define MPI2_pSGE_SET_FLAGS_LENGTH(psg,f,l) (psg)->FlagsLength = MPI2_SGE_SET_FLAGS_LENGTH(f,l)
+
+/* CAUTION - The following are READ-MODIFY-WRITE! */
+#define MPI2_pSGE_SET_FLAGS(psg,f)      (psg)->FlagsLength |= MPI2_SGE_SET_FLAGS(f)
+#define MPI2_pSGE_SET_LENGTH(psg,l)     (psg)->FlagsLength |= MPI2_SGE_LENGTH(l)
+
+#define MPI2_GET_CHAIN_OFFSET(x)    ((x & MPI2_SGE_CHAIN_OFFSET_MASK) >> MPI2_SGE_CHAIN_OFFSET_SHIFT)
+
+
+/*****************************************************************************
+*
+*        Fusion-MPT IEEE Scatter Gather Elements
+*
+*****************************************************************************/
+
+/****************************************************************************
+*  IEEE Simple Element structures
+****************************************************************************/
+
+typedef struct _MPI2_IEEE_SGE_SIMPLE32
+{
+    U32                     Address;
+    U32                     FlagsLength;
+} MPI2_IEEE_SGE_SIMPLE32, MPI2_POINTER PTR_MPI2_IEEE_SGE_SIMPLE32,
+  Mpi2IeeeSgeSimple32_t, MPI2_POINTER pMpi2IeeeSgeSimple32_t;
+
+typedef struct _MPI2_IEEE_SGE_SIMPLE64
+{
+    U64                     Address;
+    U32                     Length;
+    U16                     Reserved1;
+    U8                      Reserved2;
+    U8                      Flags;
+} MPI2_IEEE_SGE_SIMPLE64, MPI2_POINTER PTR_MPI2_IEEE_SGE_SIMPLE64,
+  Mpi2IeeeSgeSimple64_t, MPI2_POINTER pMpi2IeeeSgeSimple64_t;
+
+typedef union _MPI2_IEEE_SGE_SIMPLE_UNION
+{
+    MPI2_IEEE_SGE_SIMPLE32  Simple32;
+    MPI2_IEEE_SGE_SIMPLE64  Simple64;
+} MPI2_IEEE_SGE_SIMPLE_UNION, MPI2_POINTER PTR_MPI2_IEEE_SGE_SIMPLE_UNION,
+  Mpi2IeeeSgeSimpleUnion_t, MPI2_POINTER pMpi2IeeeSgeSimpleUnion_t;
+
+
+/****************************************************************************
+*  IEEE Chain Element structures
+****************************************************************************/
+
+typedef MPI2_IEEE_SGE_SIMPLE32  MPI2_IEEE_SGE_CHAIN32;
+
+typedef MPI2_IEEE_SGE_SIMPLE64  MPI2_IEEE_SGE_CHAIN64;
+
+typedef union _MPI2_IEEE_SGE_CHAIN_UNION
+{
+    MPI2_IEEE_SGE_CHAIN32   Chain32;
+    MPI2_IEEE_SGE_CHAIN64   Chain64;
+} MPI2_IEEE_SGE_CHAIN_UNION, MPI2_POINTER PTR_MPI2_IEEE_SGE_CHAIN_UNION,
+  Mpi2IeeeSgeChainUnion_t, MPI2_POINTER pMpi2IeeeSgeChainUnion_t;
+
+
+/****************************************************************************
+*  All IEEE SGE types union
+****************************************************************************/
+
+typedef struct _MPI2_IEEE_SGE_UNION
+{
+    union
+    {
+        MPI2_IEEE_SGE_SIMPLE_UNION  Simple;
+        MPI2_IEEE_SGE_CHAIN_UNION   Chain;
+    } u;
+} MPI2_IEEE_SGE_UNION, MPI2_POINTER PTR_MPI2_IEEE_SGE_UNION,
+  Mpi2IeeeSgeUnion_t, MPI2_POINTER pMpi2IeeeSgeUnion_t;
+
+
+/****************************************************************************
+*  IEEE SGE field definitions and masks
+****************************************************************************/
+
+/* Flags field bit definitions */
+
+#define MPI2_IEEE_SGE_FLAGS_ELEMENT_TYPE_MASK   (0x80)
+
+#define MPI2_IEEE32_SGE_FLAGS_SHIFT             (24)
+
+#define MPI2_IEEE32_SGE_LENGTH_MASK             (0x00FFFFFF)
+
+/* Element Type */
+
+#define MPI2_IEEE_SGE_FLAGS_SIMPLE_ELEMENT      (0x00)
+#define MPI2_IEEE_SGE_FLAGS_CHAIN_ELEMENT       (0x80)
+
+/* Data Location Address Space */
+
+#define MPI2_IEEE_SGE_FLAGS_ADDR_MASK           (0x03)
+#define MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR         (0x00)
+#define MPI2_IEEE_SGE_FLAGS_IOCDDR_ADDR         (0x01)
+#define MPI2_IEEE_SGE_FLAGS_IOCPLB_ADDR         (0x02)
+#define MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR      (0x03)
+
+
+/****************************************************************************
+*  IEEE SGE operation Macros
+****************************************************************************/
+
+/* SIMPLE FlagsLength manipulations... */
+#define MPI2_IEEE32_SGE_SET_FLAGS(f)     ((U32)(f) << MPI2_IEEE32_SGE_FLAGS_SHIFT)
+#define MPI2_IEEE32_SGE_GET_FLAGS(f)     (((f) & ~MPI2_IEEE32_SGE_LENGTH_MASK) >> MPI2_IEEE32_SGE_FLAGS_SHIFT)
+#define MPI2_IEEE32_SGE_LENGTH(f)        ((f) & MPI2_IEEE32_SGE_LENGTH_MASK)
+
+#define MPI2_IEEE32_SGE_SET_FLAGS_LENGTH(f, l)      (MPI2_IEEE32_SGE_SET_FLAGS(f) | MPI2_IEEE32_SGE_LENGTH(l))
+
+#define MPI2_IEEE32_pSGE_GET_FLAGS(psg)             MPI2_IEEE32_SGE_GET_FLAGS((psg)->FlagsLength)
+#define MPI2_IEEE32_pSGE_GET_LENGTH(psg)            MPI2_IEEE32_SGE_LENGTH((psg)->FlagsLength)
+#define MPI2_IEEE32_pSGE_SET_FLAGS_LENGTH(psg,f,l)  (psg)->FlagsLength = MPI2_IEEE32_SGE_SET_FLAGS_LENGTH(f,l)
+
+/* CAUTION - The following are READ-MODIFY-WRITE! */
+#define MPI2_IEEE32_pSGE_SET_FLAGS(psg,f)    (psg)->FlagsLength |= MPI2_IEEE32_SGE_SET_FLAGS(f)
+#define MPI2_IEEE32_pSGE_SET_LENGTH(psg,l)   (psg)->FlagsLength |= MPI2_IEEE32_SGE_LENGTH(l)
+
+
+
+
+/*****************************************************************************
+*
+*        Fusion-MPT MPI/IEEE Scatter Gather Unions
+*
+*****************************************************************************/
+
+typedef union _MPI2_SIMPLE_SGE_UNION
+{
+    MPI2_SGE_SIMPLE_UNION       MpiSimple;
+    MPI2_IEEE_SGE_SIMPLE_UNION  IeeeSimple;
+} MPI2_SIMPLE_SGE_UNION, MPI2_POINTER PTR_MPI2_SIMPLE_SGE_UNION,
+  Mpi2SimpleSgeUntion_t, MPI2_POINTER pMpi2SimpleSgeUntion_t;
+
+
+typedef union _MPI2_SGE_IO_UNION
+{
+    MPI2_SGE_SIMPLE_UNION       MpiSimple;
+    MPI2_SGE_CHAIN_UNION        MpiChain;
+    MPI2_IEEE_SGE_SIMPLE_UNION  IeeeSimple;
+    MPI2_IEEE_SGE_CHAIN_UNION   IeeeChain;
+} MPI2_SGE_IO_UNION, MPI2_POINTER PTR_MPI2_SGE_IO_UNION,
+  Mpi2SGEIOUnion_t, MPI2_POINTER pMpi2SGEIOUnion_t;
+
+
+/****************************************************************************
+*
+*  Values for SGLFlags field, used in many request messages with an SGL
+*
+****************************************************************************/
+
+/* values for MPI SGL Data Location Address Space subfield */
+#define MPI2_SGLFLAGS_ADDRESS_SPACE_MASK            (0x0C)
+#define MPI2_SGLFLAGS_SYSTEM_ADDRESS_SPACE          (0x00)
+#define MPI2_SGLFLAGS_IOCDDR_ADDRESS_SPACE          (0x04)
+#define MPI2_SGLFLAGS_IOCPLB_ADDRESS_SPACE          (0x08)
+#define MPI2_SGLFLAGS_IOCPLBNTA_ADDRESS_SPACE       (0x0C)
+/* values for SGL Type subfield */
+#define MPI2_SGLFLAGS_SGL_TYPE_MASK                 (0x03)
+#define MPI2_SGLFLAGS_SGL_TYPE_MPI                  (0x00)
+#define MPI2_SGLFLAGS_SGL_TYPE_IEEE32               (0x01)
+#define MPI2_SGLFLAGS_SGL_TYPE_IEEE64               (0x02)
+
+
+#endif
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,2151 @@
+/*
+ *  Copyright (c) 2000-2009 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_cnfg.h
+ *          Title:  MPI Configuration messages and pages
+ *  Creation Date:  November 10, 2006
+ *
+ *    mpi2_cnfg.h Version:  02.00.10
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  Added defines for SAS IO Unit Page 2 PhyFlags.
+ *                      Added Manufacturing Page 11.
+ *                      Added MPI2_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE
+ *                      define.
+ *  06-26-07  02.00.02  Adding generic structure for product-specific
+ *                      Manufacturing pages: MPI2_CONFIG_PAGE_MANUFACTURING_PS.
+ *                      Rework of BIOS Page 2 configuration page.
+ *                      Fixed MPI2_BIOSPAGE2_BOOT_DEVICE to be a union of the
+ *                      forms.
+ *                      Added configuration pages IOC Page 8 and Driver
+ *                      Persistent Mapping Page 0.
+ *  08-31-07  02.00.03  Modified configuration pages dealing with Integrated
+ *                      RAID (Manufacturing Page 4, RAID Volume Pages 0 and 1,
+ *                      RAID Physical Disk Pages 0 and 1, RAID Configuration
+ *                      Page 0).
+ *                      Added new value for AccessStatus field of SAS Device
+ *                      Page 0 (_SATA_NEEDS_INITIALIZATION).
+ *  10-31-07  02.00.04  Added missing SEPDevHandle field to
+ *                      MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
+ *  12-18-07  02.00.05  Modified IO Unit Page 0 to use 32-bit version fields for
+ *                      NVDATA.
+ *                      Modified IOC Page 7 to use masks and added field for
+ *                      SASBroadcastPrimitiveMasks.
+ *                      Added MPI2_CONFIG_PAGE_BIOS_4.
+ *                      Added MPI2_CONFIG_PAGE_LOG_0.
+ *  02-29-08  02.00.06  Modified various names to make them 32-character unique.
+ *                      Added SAS Device IDs.
+ *                      Updated Integrated RAID configuration pages including
+ *                      Manufacturing Page 4, IOC Page 6, and RAID Configuration
+ *                      Page 0.
+ *  05-21-08  02.00.07  Added define MPI2_MANPAGE4_MIX_SSD_SAS_SATA.
+ *                      Added define MPI2_MANPAGE4_PHYSDISK_128MB_COERCION.
+ *                      Fixed define MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING.
+ *                      Added missing MaxNumRoutedSasAddresses field to
+ *                      MPI2_CONFIG_PAGE_EXPANDER_0.
+ *                      Added SAS Port Page 0.
+ *                      Modified structure layout for
+ *                      MPI2_CONFIG_PAGE_DRIVER_MAPPING_0.
+ *  06-27-08  02.00.08  Changed MPI2_CONFIG_PAGE_RD_PDISK_1 to use
+ *                      MPI2_RAID_PHYS_DISK1_PATH_MAX to size the array.
+ *  10-02-08  02.00.09  Changed MPI2_RAID_PGAD_CONFIGNUM_MASK from 0x0000FFFF
+ *                      to 0x000000FF.
+ *                      Added two new values for the Physical Disk Coercion Size
+ *                      bits in the Flags field of Manufacturing Page 4.
+ *                      Added product-specific Manufacturing pages 16 to 31.
+ *                      Modified Flags bits for controlling write cache on SATA
+ *                      drives in IO Unit Page 1.
+ *                      Added new bit to AdditionalControlFlags of SAS IO Unit
+ *                      Page 1 to control Invalid Topology Correction.
+ *                      Added additional defines for RAID Volume Page 0
+ *                      VolumeStatusFlags field.
+ *                      Modified meaning of RAID Volume Page 0 VolumeSettings
+ *                      define for auto-configure of hot-swap drives.
+ *                      Added SupportedPhysDisks field to RAID Volume Page 1 and
+ *                      added related defines.
+ *                      Added PhysDiskAttributes field (and related defines) to
+ *                      RAID Physical Disk Page 0.
+ *                      Added MPI2_SAS_PHYINFO_PHY_VACANT define.
+ *                      Added three new DiscoveryStatus bits for SAS IO Unit
+ *                      Page 0 and SAS Expander Page 0.
+ *                      Removed multiplexing information from SAS IO Unit pages.
+ *                      Added BootDeviceWaitTime field to SAS IO Unit Page 4.
+ *                      Removed Zone Address Resolved bit from PhyInfo and from
+ *                      Expander Page 0 Flags field.
+ *                      Added two new AccessStatus values to SAS Device Page 0
+ *                      for indicating routing problems. Added 3 reserved words
+ *                      to this page.
+ *  01-19-09  02.00.10  Fixed defines for GPIOVal field of IO Unit Page 3.
+ *                      Inserted missing reserved field into structure for IOC
+ *                      Page 6.
+ *                      Added more pending task bits to RAID Volume Page 0
+ *                      VolumeStatusFlags defines.
+ *                      Added MPI2_PHYSDISK0_STATUS_FLAG_NOT_CERTIFIED define.
+ *                      Added a new DiscoveryStatus bit for SAS IO Unit Page 0
+ *                      and SAS Expander Page 0 to flag a downstream initiator
+ *                      when in simplified routing mode.
+ *                      Removed SATA Init Failure defines for DiscoveryStatus
+ *                      fields of SAS IO Unit Page 0 and SAS Expander Page 0.
+ *                      Added MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED define.
+ *                      Added PortGroups, DmaGroup, and ControlGroup fields to
+ *                      SAS Device Page 0.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_CNFG_H
+#define MPI2_CNFG_H
+
+/*****************************************************************************
+*   Configuration Page Header and defines
+*****************************************************************************/
+
+/* Config Page Header */
+typedef struct _MPI2_CONFIG_PAGE_HEADER
+{
+    U8                 PageVersion;                /* 0x00 */
+    U8                 PageLength;                 /* 0x01 */
+    U8                 PageNumber;                 /* 0x02 */
+    U8                 PageType;                   /* 0x03 */
+} MPI2_CONFIG_PAGE_HEADER, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_HEADER,
+  Mpi2ConfigPageHeader_t, MPI2_POINTER pMpi2ConfigPageHeader_t;
+
+typedef union _MPI2_CONFIG_PAGE_HEADER_UNION
+{
+   MPI2_CONFIG_PAGE_HEADER  Struct;
+   U8                       Bytes[4];
+   U16                      Word16[2];
+   U32                      Word32;
+} MPI2_CONFIG_PAGE_HEADER_UNION, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_HEADER_UNION,
+  Mpi2ConfigPageHeaderUnion, MPI2_POINTER pMpi2ConfigPageHeaderUnion;
+
+/* Extended Config Page Header */
+typedef struct _MPI2_CONFIG_EXTENDED_PAGE_HEADER
+{
+    U8                  PageVersion;                /* 0x00 */
+    U8                  Reserved1;                  /* 0x01 */
+    U8                  PageNumber;                 /* 0x02 */
+    U8                  PageType;                   /* 0x03 */
+    U16                 ExtPageLength;              /* 0x04 */
+    U8                  ExtPageType;                /* 0x06 */
+    U8                  Reserved2;                  /* 0x07 */
+} MPI2_CONFIG_EXTENDED_PAGE_HEADER,
+  MPI2_POINTER PTR_MPI2_CONFIG_EXTENDED_PAGE_HEADER,
+  Mpi2ConfigExtendedPageHeader_t, MPI2_POINTER pMpi2ConfigExtendedPageHeader_t;
+
+typedef union _MPI2_CONFIG_EXT_PAGE_HEADER_UNION
+{
+   MPI2_CONFIG_PAGE_HEADER          Struct;
+   MPI2_CONFIG_EXTENDED_PAGE_HEADER Ext;
+   U8                               Bytes[8];
+   U16                              Word16[4];
+   U32                              Word32[2];
+} MPI2_CONFIG_EXT_PAGE_HEADER_UNION, MPI2_POINTER PTR_MPI2_CONFIG_EXT_PAGE_HEADER_UNION,
+  Mpi2ConfigPageExtendedHeaderUnion, MPI2_POINTER pMpi2ConfigPageExtendedHeaderUnion;
+
+
+/* PageType field values */
+#define MPI2_CONFIG_PAGEATTR_READ_ONLY              (0x00)
+#define MPI2_CONFIG_PAGEATTR_CHANGEABLE             (0x10)
+#define MPI2_CONFIG_PAGEATTR_PERSISTENT             (0x20)
+#define MPI2_CONFIG_PAGEATTR_MASK                   (0xF0)
+
+#define MPI2_CONFIG_PAGETYPE_IO_UNIT                (0x00)
+#define MPI2_CONFIG_PAGETYPE_IOC                    (0x01)
+#define MPI2_CONFIG_PAGETYPE_BIOS                   (0x02)
+#define MPI2_CONFIG_PAGETYPE_RAID_VOLUME            (0x08)
+#define MPI2_CONFIG_PAGETYPE_MANUFACTURING          (0x09)
+#define MPI2_CONFIG_PAGETYPE_RAID_PHYSDISK          (0x0A)
+#define MPI2_CONFIG_PAGETYPE_EXTENDED               (0x0F)
+#define MPI2_CONFIG_PAGETYPE_MASK                   (0x0F)
+
+#define MPI2_CONFIG_TYPENUM_MASK                    (0x0FFF)
+
+
+/* ExtPageType field values */
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_IO_UNIT         (0x10)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_EXPANDER        (0x11)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_DEVICE          (0x12)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_PHY             (0x13)
+#define MPI2_CONFIG_EXTPAGETYPE_LOG                 (0x14)
+#define MPI2_CONFIG_EXTPAGETYPE_ENCLOSURE           (0x15)
+#define MPI2_CONFIG_EXTPAGETYPE_RAID_CONFIG         (0x16)
+#define MPI2_CONFIG_EXTPAGETYPE_DRIVER_MAPPING      (0x17)
+#define MPI2_CONFIG_EXTPAGETYPE_SAS_PORT            (0x18)
+
+
+/*****************************************************************************
+*   PageAddress defines
+*****************************************************************************/
+
+/* RAID Volume PageAddress format */
+#define MPI2_RAID_VOLUME_PGAD_FORM_MASK             (0xF0000000)
+#define MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE  (0x00000000)
+#define MPI2_RAID_VOLUME_PGAD_FORM_HANDLE           (0x10000000)
+
+#define MPI2_RAID_VOLUME_PGAD_HANDLE_MASK           (0x0000FFFF)
+
+
+/* RAID Physical Disk PageAddress format */
+#define MPI2_PHYSDISK_PGAD_FORM_MASK                    (0xF0000000)
+#define MPI2_PHYSDISK_PGAD_FORM_GET_NEXT_PHYSDISKNUM    (0x00000000)
+#define MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM             (0x10000000)
+#define MPI2_PHYSDISK_PGAD_FORM_DEVHANDLE               (0x20000000)
+
+#define MPI2_PHYSDISK_PGAD_PHYSDISKNUM_MASK             (0x000000FF)
+#define MPI2_PHYSDISK_PGAD_DEVHANDLE_MASK               (0x0000FFFF)
+
+
+/* SAS Expander PageAddress format */
+#define MPI2_SAS_EXPAND_PGAD_FORM_MASK              (0xF0000000)
+#define MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL     (0x00000000)
+#define MPI2_SAS_EXPAND_PGAD_FORM_HNDL_PHY_NUM      (0x10000000)
+#define MPI2_SAS_EXPAND_PGAD_FORM_HNDL              (0x20000000)
+
+#define MPI2_SAS_EXPAND_PGAD_HANDLE_MASK            (0x0000FFFF)
+#define MPI2_SAS_EXPAND_PGAD_PHYNUM_MASK            (0x00FF0000)
+#define MPI2_SAS_EXPAND_PGAD_PHYNUM_SHIFT           (16)
+
+
+/* SAS Device PageAddress format */
+#define MPI2_SAS_DEVICE_PGAD_FORM_MASK              (0xF0000000)
+#define MPI2_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE   (0x00000000)
+#define MPI2_SAS_DEVICE_PGAD_FORM_HANDLE            (0x20000000)
+
+#define MPI2_SAS_DEVICE_PGAD_HANDLE_MASK            (0x0000FFFF)
+
+
+/* SAS PHY PageAddress format */
+#define MPI2_SAS_PHY_PGAD_FORM_MASK                 (0xF0000000)
+#define MPI2_SAS_PHY_PGAD_FORM_PHY_NUMBER           (0x00000000)
+#define MPI2_SAS_PHY_PGAD_FORM_PHY_TBL_INDEX        (0x10000000)
+
+#define MPI2_SAS_PHY_PGAD_PHY_NUMBER_MASK           (0x000000FF)
+#define MPI2_SAS_PHY_PGAD_PHY_TBL_INDEX_MASK        (0x0000FFFF)
+
+
+/* SAS Port PageAddress format */
+#define MPI2_SASPORT_PGAD_FORM_MASK                 (0xF0000000)
+#define MPI2_SASPORT_PGAD_FORM_GET_NEXT_PORT        (0x00000000)
+#define MPI2_SASPORT_PGAD_FORM_PORT_NUM             (0x10000000)
+
+#define MPI2_SASPORT_PGAD_PORTNUMBER_MASK           (0x00000FFF)
+
+
+/* SAS Enclosure PageAddress format */
+#define MPI2_SAS_ENCLOS_PGAD_FORM_MASK              (0xF0000000)
+#define MPI2_SAS_ENCLOS_PGAD_FORM_GET_NEXT_HANDLE   (0x00000000)
+#define MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE            (0x10000000)
+
+#define MPI2_SAS_ENCLOS_PGAD_HANDLE_MASK            (0x0000FFFF)
+
+
+/* RAID Configuration PageAddress format */
+#define MPI2_RAID_PGAD_FORM_MASK                    (0xF0000000)
+#define MPI2_RAID_PGAD_FORM_GET_NEXT_CONFIGNUM      (0x00000000)
+#define MPI2_RAID_PGAD_FORM_CONFIGNUM               (0x10000000)
+#define MPI2_RAID_PGAD_FORM_ACTIVE_CONFIG           (0x20000000)
+
+#define MPI2_RAID_PGAD_CONFIGNUM_MASK               (0x000000FF)
+
+
+/* Driver Persistent Mapping PageAddress format */
+#define MPI2_DPM_PGAD_FORM_MASK                     (0xF0000000)
+#define MPI2_DPM_PGAD_FORM_ENTRY_RANGE              (0x00000000)
+
+#define MPI2_DPM_PGAD_ENTRY_COUNT_MASK              (0x0FFF0000)
+#define MPI2_DPM_PGAD_ENTRY_COUNT_SHIFT             (16)
+#define MPI2_DPM_PGAD_START_ENTRY_MASK              (0x0000FFFF)
+
+
+/****************************************************************************
+*   Configuration messages
+****************************************************************************/
+
+/* Configuration Request Message */
+typedef struct _MPI2_CONFIG_REQUEST
+{
+    U8                      Action;                     /* 0x00 */
+    U8                      SGLFlags;                   /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     ExtPageLength;              /* 0x04 */
+    U8                      ExtPageType;                /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved1;                  /* 0x0A */
+    U32                     Reserved2;                  /* 0x0C */
+    U32                     Reserved3;                  /* 0x10 */
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x14 */
+    U32                     PageAddress;                /* 0x18 */
+    MPI2_SGE_IO_UNION       PageBufferSGE;              /* 0x1C */
+} MPI2_CONFIG_REQUEST, MPI2_POINTER PTR_MPI2_CONFIG_REQUEST,
+  Mpi2ConfigRequest_t, MPI2_POINTER pMpi2ConfigRequest_t;
+
+/* values for the Action field */
+#define MPI2_CONFIG_ACTION_PAGE_HEADER              (0x00)
+#define MPI2_CONFIG_ACTION_PAGE_READ_CURRENT        (0x01)
+#define MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT       (0x02)
+#define MPI2_CONFIG_ACTION_PAGE_DEFAULT             (0x03)
+#define MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM         (0x04)
+#define MPI2_CONFIG_ACTION_PAGE_READ_DEFAULT        (0x05)
+#define MPI2_CONFIG_ACTION_PAGE_READ_NVRAM          (0x06)
+#define MPI2_CONFIG_ACTION_PAGE_GET_CHANGEABLE      (0x07)
+
+/* values for SGLFlags field are in the SGL section of mpi2.h */
+
+
+/* Config Reply Message */
+typedef struct _MPI2_CONFIG_REPLY
+{
+    U8                      Action;                     /* 0x00 */
+    U8                      SGLFlags;                   /* 0x01 */
+    U8                      MsgLength;                  /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     ExtPageLength;              /* 0x04 */
+    U8                      ExtPageType;                /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved1;                  /* 0x0A */
+    U16                     Reserved2;                  /* 0x0C */
+    U16                     IOCStatus;                  /* 0x0E */
+    U32                     IOCLogInfo;                 /* 0x10 */
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x14 */
+} MPI2_CONFIG_REPLY, MPI2_POINTER PTR_MPI2_CONFIG_REPLY,
+  Mpi2ConfigReply_t, MPI2_POINTER pMpi2ConfigReply_t;
+
+
+
+/*****************************************************************************
+*
+*               C o n f i g u r a t i o n    P a g e s
+*
+*****************************************************************************/
+
+/****************************************************************************
+*   Manufacturing Config pages
+****************************************************************************/
+
+#define MPI2_MFGPAGE_VENDORID_LSI                   (0x1000)
+
+/* SAS */
+#define MPI2_MFGPAGE_DEVID_SAS2004                  (0x0070)
+#define MPI2_MFGPAGE_DEVID_SAS2008                  (0x0072)
+#define MPI2_MFGPAGE_DEVID_SAS2108_1                (0x0074)
+#define MPI2_MFGPAGE_DEVID_SAS2108_2                (0x0076)
+#define MPI2_MFGPAGE_DEVID_SAS2108_3                (0x0077)
+#define MPI2_MFGPAGE_DEVID_SAS2116_1                (0x0064)
+#define MPI2_MFGPAGE_DEVID_SAS2116_2                (0x0065)
+
+
+/* Manufacturing Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_0
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U8                      ChipName[16];               /* 0x04 */
+    U8                      ChipRevision[8];            /* 0x14 */
+    U8                      BoardName[16];              /* 0x1C */
+    U8                      BoardAssembly[16];          /* 0x2C */
+    U8                      BoardTracerNumber[16];      /* 0x3C */
+} MPI2_CONFIG_PAGE_MAN_0,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_0,
+  Mpi2ManufacturingPage0_t, MPI2_POINTER pMpi2ManufacturingPage0_t;
+
+#define MPI2_MANUFACTURING0_PAGEVERSION                (0x00)
+
+
+/* Manufacturing Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_1
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U8                      VPD[256];                   /* 0x04 */
+} MPI2_CONFIG_PAGE_MAN_1,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_1,
+  Mpi2ManufacturingPage1_t, MPI2_POINTER pMpi2ManufacturingPage1_t;
+
+#define MPI2_MANUFACTURING1_PAGEVERSION                (0x00)
+
+
+typedef struct _MPI2_CHIP_REVISION_ID
+{
+    U16 DeviceID;                                       /* 0x00 */
+    U8  PCIRevisionID;                                  /* 0x02 */
+    U8  Reserved;                                       /* 0x03 */
+} MPI2_CHIP_REVISION_ID, MPI2_POINTER PTR_MPI2_CHIP_REVISION_ID,
+  Mpi2ChipRevisionId_t, MPI2_POINTER pMpi2ChipRevisionId_t;
+
+
+/* Manufacturing Page 2 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength at runtime.
+ */
+#ifndef MPI2_MAN_PAGE_2_HW_SETTINGS_WORDS
+#define MPI2_MAN_PAGE_2_HW_SETTINGS_WORDS   (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_2
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    MPI2_CHIP_REVISION_ID   ChipId;                     /* 0x04 */
+    U32                     HwSettings[MPI2_MAN_PAGE_2_HW_SETTINGS_WORDS];/* 0x08 */
+} MPI2_CONFIG_PAGE_MAN_2,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_2,
+  Mpi2ManufacturingPage2_t, MPI2_POINTER pMpi2ManufacturingPage2_t;
+
+#define MPI2_MANUFACTURING2_PAGEVERSION                 (0x00)
+
+
+/* Manufacturing Page 3 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength at runtime.
+ */
+#ifndef MPI2_MAN_PAGE_3_INFO_WORDS
+#define MPI2_MAN_PAGE_3_INFO_WORDS          (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_3
+{
+    MPI2_CONFIG_PAGE_HEADER             Header;         /* 0x00 */
+    MPI2_CHIP_REVISION_ID               ChipId;         /* 0x04 */
+    U32                                 Info[MPI2_MAN_PAGE_3_INFO_WORDS];/* 0x08 */
+} MPI2_CONFIG_PAGE_MAN_3,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_3,
+  Mpi2ManufacturingPage3_t, MPI2_POINTER pMpi2ManufacturingPage3_t;
+
+#define MPI2_MANUFACTURING3_PAGEVERSION                 (0x00)
+
+
+/* Manufacturing Page 4 */
+
+typedef struct _MPI2_MANPAGE4_PWR_SAVE_SETTINGS
+{
+    U8                          PowerSaveFlags;                 /* 0x00 */
+    U8                          InternalOperationsSleepTime;    /* 0x01 */
+    U8                          InternalOperationsRunTime;      /* 0x02 */
+    U8                          HostIdleTime;                   /* 0x03 */
+} MPI2_MANPAGE4_PWR_SAVE_SETTINGS,
+  MPI2_POINTER PTR_MPI2_MANPAGE4_PWR_SAVE_SETTINGS,
+  Mpi2ManPage4PwrSaveSettings_t, MPI2_POINTER pMpi2ManPage4PwrSaveSettings_t;
+
+/* defines for the PowerSaveFlags field */
+#define MPI2_MANPAGE4_MASK_POWERSAVE_MODE               (0x03)
+#define MPI2_MANPAGE4_POWERSAVE_MODE_DISABLED           (0x00)
+#define MPI2_MANPAGE4_CUSTOM_POWERSAVE_MODE             (0x01)
+#define MPI2_MANPAGE4_FULL_POWERSAVE_MODE               (0x02)
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_4
+{
+    MPI2_CONFIG_PAGE_HEADER             Header;                 /* 0x00 */
+    U32                                 Reserved1;              /* 0x04 */
+    U32                                 Flags;                  /* 0x08 */
+    U8                                  InquirySize;            /* 0x0C */
+    U8                                  Reserved2;              /* 0x0D */
+    U16                                 Reserved3;              /* 0x0E */
+    U8                                  InquiryData[56];        /* 0x10 */
+    U32                                 RAID0VolumeSettings;    /* 0x48 */
+    U32                                 RAID1EVolumeSettings;   /* 0x4C */
+    U32                                 RAID1VolumeSettings;    /* 0x50 */
+    U32                                 RAID10VolumeSettings;   /* 0x54 */
+    U32                                 Reserved4;              /* 0x58 */
+    U32                                 Reserved5;              /* 0x5C */
+    MPI2_MANPAGE4_PWR_SAVE_SETTINGS     PowerSaveSettings;      /* 0x60 */
+    U8                                  MaxOCEDisks;            /* 0x64 */
+    U8                                  ResyncRate;             /* 0x65 */
+    U16                                 DataScrubDuration;      /* 0x66 */
+    U8                                  MaxHotSpares;           /* 0x68 */
+    U8                                  MaxPhysDisksPerVol;     /* 0x69 */
+    U8                                  MaxPhysDisks;           /* 0x6A */
+    U8                                  MaxVolumes;             /* 0x6B */
+} MPI2_CONFIG_PAGE_MAN_4,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_4,
+  Mpi2ManufacturingPage4_t, MPI2_POINTER pMpi2ManufacturingPage4_t;
+
+#define MPI2_MANUFACTURING4_PAGEVERSION                 (0x0A)
+
+/* Manufacturing Page 4 Flags field */
+#define MPI2_MANPAGE4_METADATA_SIZE_MASK                (0x00030000)
+#define MPI2_MANPAGE4_METADATA_512MB                    (0x00000000)
+
+#define MPI2_MANPAGE4_MIX_SSD_SAS_SATA                  (0x00008000)
+#define MPI2_MANPAGE4_MIX_SSD_AND_NON_SSD               (0x00004000)
+#define MPI2_MANPAGE4_HIDE_PHYSDISK_NON_IR              (0x00002000)
+
+#define MPI2_MANPAGE4_MASK_PHYSDISK_COERCION            (0x00001C00)
+#define MPI2_MANPAGE4_PHYSDISK_COERCION_1GB             (0x00000000)
+#define MPI2_MANPAGE4_PHYSDISK_128MB_COERCION           (0x00000400)
+#define MPI2_MANPAGE4_PHYSDISK_ADAPTIVE_COERCION        (0x00000800)
+#define MPI2_MANPAGE4_PHYSDISK_ZERO_COERCION            (0x00000C00)
+
+#define MPI2_MANPAGE4_MASK_BAD_BLOCK_MARKING            (0x00000300)
+#define MPI2_MANPAGE4_DEFAULT_BAD_BLOCK_MARKING         (0x00000000)
+#define MPI2_MANPAGE4_TABLE_BAD_BLOCK_MARKING           (0x00000100)
+#define MPI2_MANPAGE4_WRITE_LONG_BAD_BLOCK_MARKING      (0x00000200)
+
+#define MPI2_MANPAGE4_FORCE_OFFLINE_FAILOVER            (0x00000080)
+#define MPI2_MANPAGE4_RAID10_DISABLE                    (0x00000040)
+#define MPI2_MANPAGE4_RAID1E_DISABLE                    (0x00000020)
+#define MPI2_MANPAGE4_RAID1_DISABLE                     (0x00000010)
+#define MPI2_MANPAGE4_RAID0_DISABLE                     (0x00000008)
+#define MPI2_MANPAGE4_IR_MODEPAGE8_DISABLE              (0x00000004)
+#define MPI2_MANPAGE4_IM_RESYNC_CACHE_ENABLE            (0x00000002)
+#define MPI2_MANPAGE4_IR_NO_MIX_SAS_SATA                (0x00000001)
+
+
+/* Manufacturing Page 5 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength or NumPhys at runtime.
+ */
+#ifndef MPI2_MAN_PAGE_5_PHY_ENTRIES
+#define MPI2_MAN_PAGE_5_PHY_ENTRIES         (1)
+#endif
+
+typedef struct _MPI2_MANUFACTURING5_ENTRY
+{
+    U64                                 WWID;           /* 0x00 */
+    U64                                 DeviceName;     /* 0x08 */
+} MPI2_MANUFACTURING5_ENTRY, MPI2_POINTER PTR_MPI2_MANUFACTURING5_ENTRY,
+  Mpi2Manufacturing5Entry_t, MPI2_POINTER pMpi2Manufacturing5Entry_t;
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_5
+{
+    MPI2_CONFIG_PAGE_HEADER             Header;         /* 0x00 */
+    U8                                  NumPhys;        /* 0x04 */
+    U8                                  Reserved1;      /* 0x05 */
+    U16                                 Reserved2;      /* 0x06 */
+    U32                                 Reserved3;      /* 0x08 */
+    U32                                 Reserved4;      /* 0x0C */
+    MPI2_MANUFACTURING5_ENTRY           Phy[MPI2_MAN_PAGE_5_PHY_ENTRIES];/* 0x08 */
+} MPI2_CONFIG_PAGE_MAN_5,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_5,
+  Mpi2ManufacturingPage5_t, MPI2_POINTER pMpi2ManufacturingPage5_t;
+
+#define MPI2_MANUFACTURING5_PAGEVERSION                 (0x03)
+
+
+/* Manufacturing Page 6 */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_6
+{
+    MPI2_CONFIG_PAGE_HEADER         Header;             /* 0x00 */
+    U32                             ProductSpecificInfo;/* 0x04 */
+} MPI2_CONFIG_PAGE_MAN_6,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_6,
+  Mpi2ManufacturingPage6_t, MPI2_POINTER pMpi2ManufacturingPage6_t;
+
+#define MPI2_MANUFACTURING6_PAGEVERSION                 (0x00)
+
+
+/* Manufacturing Page 7 */
+
+typedef struct _MPI2_MANPAGE7_CONNECTOR_INFO
+{
+    U32                         Pinout;                 /* 0x00 */
+    U8                          Connector[16];          /* 0x04 */
+    U8                          Location;               /* 0x14 */
+    U8                          Reserved1;              /* 0x15 */
+    U16                         Slot;                   /* 0x16 */
+    U32                         Reserved2;              /* 0x18 */
+} MPI2_MANPAGE7_CONNECTOR_INFO, MPI2_POINTER PTR_MPI2_MANPAGE7_CONNECTOR_INFO,
+  Mpi2ManPage7ConnectorInfo_t, MPI2_POINTER pMpi2ManPage7ConnectorInfo_t;
+
+/* defines for the Pinout field */
+#define MPI2_MANPAGE7_PINOUT_SFF_8484_L4                (0x00080000)
+#define MPI2_MANPAGE7_PINOUT_SFF_8484_L3                (0x00040000)
+#define MPI2_MANPAGE7_PINOUT_SFF_8484_L2                (0x00020000)
+#define MPI2_MANPAGE7_PINOUT_SFF_8484_L1                (0x00010000)
+#define MPI2_MANPAGE7_PINOUT_SFF_8470_L4                (0x00000800)
+#define MPI2_MANPAGE7_PINOUT_SFF_8470_L3                (0x00000400)
+#define MPI2_MANPAGE7_PINOUT_SFF_8470_L2                (0x00000200)
+#define MPI2_MANPAGE7_PINOUT_SFF_8470_L1                (0x00000100)
+#define MPI2_MANPAGE7_PINOUT_SFF_8482                   (0x00000002)
+#define MPI2_MANPAGE7_PINOUT_CONNECTION_UNKNOWN         (0x00000001)
+
+/* defines for the Location field */
+#define MPI2_MANPAGE7_LOCATION_UNKNOWN                  (0x01)
+#define MPI2_MANPAGE7_LOCATION_INTERNAL                 (0x02)
+#define MPI2_MANPAGE7_LOCATION_EXTERNAL                 (0x04)
+#define MPI2_MANPAGE7_LOCATION_SWITCHABLE               (0x08)
+#define MPI2_MANPAGE7_LOCATION_AUTO                     (0x10)
+#define MPI2_MANPAGE7_LOCATION_NOT_PRESENT              (0x20)
+#define MPI2_MANPAGE7_LOCATION_NOT_CONNECTED            (0x80)
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check NumPhys at runtime.
+ */
+#ifndef MPI2_MANPAGE7_CONNECTOR_INFO_MAX
+#define MPI2_MANPAGE7_CONNECTOR_INFO_MAX  (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_7
+{
+    MPI2_CONFIG_PAGE_HEADER         Header;             /* 0x00 */
+    U32                             Reserved1;          /* 0x04 */
+    U32                             Reserved2;          /* 0x08 */
+    U32                             Flags;              /* 0x0C */
+    U8                              EnclosureName[16];  /* 0x10 */
+    U8                              NumPhys;            /* 0x20 */
+    U8                              Reserved3;          /* 0x21 */
+    U16                             Reserved4;          /* 0x22 */
+    MPI2_MANPAGE7_CONNECTOR_INFO    ConnectorInfo[MPI2_MANPAGE7_CONNECTOR_INFO_MAX]; /* 0x24 */
+} MPI2_CONFIG_PAGE_MAN_7,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_7,
+  Mpi2ManufacturingPage7_t, MPI2_POINTER pMpi2ManufacturingPage7_t;
+
+#define MPI2_MANUFACTURING7_PAGEVERSION                 (0x00)
+
+/* defines for the Flags field */
+#define MPI2_MANPAGE7_FLAG_USE_SLOT_INFO                (0x00000001)
+
+
+/*
+ * Generic structure to use for product-specific manufacturing pages
+ * (currently Manufacturing Page 8 through Manufacturing Page 31).
+ */
+
+typedef struct _MPI2_CONFIG_PAGE_MAN_PS
+{
+    MPI2_CONFIG_PAGE_HEADER         Header;             /* 0x00 */
+    U32                             ProductSpecificInfo;/* 0x04 */
+} MPI2_CONFIG_PAGE_MAN_PS,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_PS,
+  Mpi2ManufacturingPagePS_t, MPI2_POINTER pMpi2ManufacturingPagePS_t;
+
+#define MPI2_MANUFACTURING8_PAGEVERSION                 (0x00)
+#define MPI2_MANUFACTURING9_PAGEVERSION                 (0x00)
+#define MPI2_MANUFACTURING10_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING11_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING12_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING13_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING14_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING15_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING16_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING17_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING18_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING19_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING20_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING21_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING22_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING23_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING24_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING25_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING26_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING27_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING28_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING29_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING30_PAGEVERSION                (0x00)
+#define MPI2_MANUFACTURING31_PAGEVERSION                (0x00)
+
+
+/****************************************************************************
+*   IO Unit Config Pages
+****************************************************************************/
+
+/* IO Unit Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_0
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U64                     UniqueValue;                /* 0x04 */
+    MPI2_VERSION_UNION      NvdataVersionDefault;       /* 0x08 */
+    MPI2_VERSION_UNION      NvdataVersionPersistent;    /* 0x0A */
+} MPI2_CONFIG_PAGE_IO_UNIT_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IO_UNIT_0,
+  Mpi2IOUnitPage0_t, MPI2_POINTER pMpi2IOUnitPage0_t;
+
+#define MPI2_IOUNITPAGE0_PAGEVERSION                    (0x02)
+
+
+/* IO Unit Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U32                     Flags;                      /* 0x04 */
+} MPI2_CONFIG_PAGE_IO_UNIT_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IO_UNIT_1,
+  Mpi2IOUnitPage1_t, MPI2_POINTER pMpi2IOUnitPage1_t;
+
+#define MPI2_IOUNITPAGE1_PAGEVERSION                    (0x04)
+
+/* IO Unit Page 1 Flags defines */
+#define MPI2_IOUNITPAGE1_MASK_SATA_WRITE_CACHE          (0x00000600)
+#define MPI2_IOUNITPAGE1_ENABLE_SATA_WRITE_CACHE        (0x00000000)
+#define MPI2_IOUNITPAGE1_DISABLE_SATA_WRITE_CACHE       (0x00000200)
+#define MPI2_IOUNITPAGE1_UNCHANGED_SATA_WRITE_CACHE     (0x00000400)
+#define MPI2_IOUNITPAGE1_NATIVE_COMMAND_Q_DISABLE       (0x00000100)
+#define MPI2_IOUNITPAGE1_DISABLE_IR                     (0x00000040)
+#define MPI2_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING (0x00000020)
+#define MPI2_IOUNITPAGE1_IR_USE_STATIC_VOLUME_ID        (0x00000004)
+#define MPI2_IOUNITPAGE1_MULTI_PATHING                  (0x00000002)
+#define MPI2_IOUNITPAGE1_SINGLE_PATHING                 (0x00000000)
+
+
+/* IO Unit Page 3 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength at runtime.
+ */
+#ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
+#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                                   /* 0x00 */
+    U8                      GPIOCount;                                /* 0x04 */
+    U8                      Reserved1;                                /* 0x05 */
+    U16                     Reserved2;                                /* 0x06 */
+    U16                     GPIOVal[MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX];/* 0x08 */
+} MPI2_CONFIG_PAGE_IO_UNIT_3, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IO_UNIT_3,
+  Mpi2IOUnitPage3_t, MPI2_POINTER pMpi2IOUnitPage3_t;
+
+#define MPI2_IOUNITPAGE3_PAGEVERSION                    (0x01)
+
+/* defines for IO Unit Page 3 GPIOVal field */
+#define MPI2_IOUNITPAGE3_GPIO_FUNCTION_MASK             (0xFFFC)
+#define MPI2_IOUNITPAGE3_GPIO_FUNCTION_SHIFT            (2)
+#define MPI2_IOUNITPAGE3_GPIO_SETTING_OFF               (0x0000)
+#define MPI2_IOUNITPAGE3_GPIO_SETTING_ON                (0x0001)
+
+
+/****************************************************************************
+*   IOC Config Pages
+****************************************************************************/
+
+/* IOC Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_0
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U32                     Reserved1;                  /* 0x04 */
+    U32                     Reserved2;                  /* 0x08 */
+    U16                     VendorID;                   /* 0x0C */
+    U16                     DeviceID;                   /* 0x0E */
+    U8                      RevisionID;                 /* 0x10 */
+    U8                      Reserved3;                  /* 0x11 */
+    U16                     Reserved4;                  /* 0x12 */
+    U32                     ClassCode;                  /* 0x14 */
+    U16                     SubsystemVendorID;          /* 0x18 */
+    U16                     SubsystemID;                /* 0x1A */
+} MPI2_CONFIG_PAGE_IOC_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IOC_0,
+  Mpi2IOCPage0_t, MPI2_POINTER pMpi2IOCPage0_t;
+
+#define MPI2_IOCPAGE0_PAGEVERSION                       (0x02)
+
+
+/* IOC Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_1
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U32                     Flags;                      /* 0x04 */
+    U32                     CoalescingTimeout;          /* 0x08 */
+    U8                      CoalescingDepth;            /* 0x0C */
+    U8                      PCISlotNum;                 /* 0x0D */
+    U8                      PCIBusNum;                  /* 0x0E */
+    U8                      PCIDomainSegment;           /* 0x0F */
+    U32                     Reserved1;                  /* 0x10 */
+    U32                     Reserved2;                  /* 0x14 */
+} MPI2_CONFIG_PAGE_IOC_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IOC_1,
+  Mpi2IOCPage1_t, MPI2_POINTER pMpi2IOCPage1_t;
+
+#define MPI2_IOCPAGE1_PAGEVERSION                       (0x05)
+
+/* defines for IOC Page 1 Flags field */
+#define MPI2_IOCPAGE1_REPLY_COALESCING                  (0x00000001)
+
+#define MPI2_IOCPAGE1_PCISLOTNUM_UNKNOWN                (0xFF)
+#define MPI2_IOCPAGE1_PCIBUSNUM_UNKNOWN                 (0xFF)
+#define MPI2_IOCPAGE1_PCIDOMAIN_UNKNOWN                 (0xFF)
+
+/* IOC Page 6 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_6
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                         /* 0x00 */
+    U32                     CapabilitiesFlags;              /* 0x04 */
+    U8                      MaxDrivesRAID0;                 /* 0x08 */
+    U8                      MaxDrivesRAID1;                 /* 0x09 */
+    U8                      MaxDrivesRAID1E;                /* 0x0A */
+    U8                      MaxDrivesRAID10;                /* 0x0B */
+    U8                      MinDrivesRAID0;                 /* 0x0C */
+    U8                      MinDrivesRAID1;                 /* 0x0D */
+    U8                      MinDrivesRAID1E;                /* 0x0E */
+    U8                      MinDrivesRAID10;                /* 0x0F */
+    U32                     Reserved1;                      /* 0x10 */
+    U8                      MaxGlobalHotSpares;             /* 0x14 */
+    U8                      MaxPhysDisks;                   /* 0x15 */
+    U8                      MaxVolumes;                     /* 0x16 */
+    U8                      MaxConfigs;                     /* 0x17 */
+    U8                      MaxOCEDisks;                    /* 0x18 */
+    U8                      Reserved2;                      /* 0x19 */
+    U16                     Reserved3;                      /* 0x1A */
+    U32                     SupportedStripeSizeMapRAID0;    /* 0x1C */
+    U32                     SupportedStripeSizeMapRAID1E;   /* 0x20 */
+    U32                     SupportedStripeSizeMapRAID10;   /* 0x24 */
+    U32                     Reserved4;                      /* 0x28 */
+    U32                     Reserved5;                      /* 0x2C */
+    U16                     DefaultMetadataSize;            /* 0x30 */
+    U16                     Reserved6;                      /* 0x32 */
+    U16                     MaxBadBlockTableEntries;        /* 0x34 */
+    U16                     Reserved7;                      /* 0x36 */
+    U32                     IRNvsramVersion;                /* 0x38 */
+} MPI2_CONFIG_PAGE_IOC_6, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IOC_6,
+  Mpi2IOCPage6_t, MPI2_POINTER pMpi2IOCPage6_t;
+
+#define MPI2_IOCPAGE6_PAGEVERSION                       (0x04)
+
+/* defines for IOC Page 6 CapabilitiesFlags */
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID10_SUPPORT          (0x00000010)
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID1_SUPPORT           (0x00000008)
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID1E_SUPPORT          (0x00000004)
+#define MPI2_IOCPAGE6_CAP_FLAGS_RAID0_SUPPORT           (0x00000002)
+#define MPI2_IOCPAGE6_CAP_FLAGS_GLOBAL_HOT_SPARE        (0x00000001)
+
+
+/* IOC Page 7 */
+
+#define MPI2_IOCPAGE7_EVENTMASK_WORDS       (4)
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_7
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U32                     Reserved1;                  /* 0x04 */
+    U32                     EventMasks[MPI2_IOCPAGE7_EVENTMASK_WORDS];/* 0x08 */
+    U16                     SASBroadcastPrimitiveMasks; /* 0x18 */
+    U16                     Reserved2;                  /* 0x1A */
+    U32                     Reserved3;                  /* 0x1C */
+} MPI2_CONFIG_PAGE_IOC_7, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IOC_7,
+  Mpi2IOCPage7_t, MPI2_POINTER pMpi2IOCPage7_t;
+
+#define MPI2_IOCPAGE7_PAGEVERSION                       (0x01)
+
+
+/* IOC Page 8 */
+
+typedef struct _MPI2_CONFIG_PAGE_IOC_8
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U8                      NumDevsPerEnclosure;        /* 0x04 */
+    U8                      Reserved1;                  /* 0x05 */
+    U16                     Reserved2;                  /* 0x06 */
+    U16                     MaxPersistentEntries;       /* 0x08 */
+    U16                     MaxNumPhysicalMappedIDs;    /* 0x0A */
+    U16                     Flags;                      /* 0x0C */
+    U16                     Reserved3;                  /* 0x0E */
+    U16                     IRVolumeMappingFlags;       /* 0x10 */
+    U16                     Reserved4;                  /* 0x12 */
+    U32                     Reserved5;                  /* 0x14 */
+} MPI2_CONFIG_PAGE_IOC_8, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IOC_8,
+  Mpi2IOCPage8_t, MPI2_POINTER pMpi2IOCPage8_t;
+
+#define MPI2_IOCPAGE8_PAGEVERSION                       (0x00)
+
+/* defines for IOC Page 8 Flags field */
+#define MPI2_IOCPAGE8_FLAGS_DA_START_SLOT_1             (0x00000020)
+#define MPI2_IOCPAGE8_FLAGS_RESERVED_TARGETID_0         (0x00000010)
+
+#define MPI2_IOCPAGE8_FLAGS_MASK_MAPPING_MODE           (0x0000000E)
+#define MPI2_IOCPAGE8_FLAGS_DEVICE_PERSISTENCE_MAPPING  (0x00000000)
+#define MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING      (0x00000002)
+
+#define MPI2_IOCPAGE8_FLAGS_DISABLE_PERSISTENT_MAPPING  (0x00000001)
+#define MPI2_IOCPAGE8_FLAGS_ENABLE_PERSISTENT_MAPPING   (0x00000000)
+
+/* defines for IOC Page 8 IRVolumeMappingFlags */
+#define MPI2_IOCPAGE8_IRFLAGS_MASK_VOLUME_MAPPING_MODE  (0x00000003)
+#define MPI2_IOCPAGE8_IRFLAGS_LOW_VOLUME_MAPPING        (0x00000000)
+#define MPI2_IOCPAGE8_IRFLAGS_HIGH_VOLUME_MAPPING       (0x00000001)
+
+
+/****************************************************************************
+*   BIOS Config Pages
+****************************************************************************/
+
+/* BIOS Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_1
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U32                     BiosOptions;                /* 0x04 */
+    U32                     IOCSettings;                /* 0x08 */
+    U32                     Reserved1;                  /* 0x0C */
+    U32                     DeviceSettings;             /* 0x10 */
+    U16                     NumberOfDevices;            /* 0x14 */
+    U16                     Reserved2;                  /* 0x16 */
+    U16                     IOTimeoutBlockDevicesNonRM; /* 0x18 */
+    U16                     IOTimeoutSequential;        /* 0x1A */
+    U16                     IOTimeoutOther;             /* 0x1C */
+    U16                     IOTimeoutBlockDevicesRM;    /* 0x1E */
+} MPI2_CONFIG_PAGE_BIOS_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_BIOS_1,
+  Mpi2BiosPage1_t, MPI2_POINTER pMpi2BiosPage1_t;
+
+#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x04)
+
+/* values for BIOS Page 1 BiosOptions field */
+#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_BIOS             (0x00000001)
+
+/* values for BIOS Page 1 IOCSettings field */
+#define MPI2_BIOSPAGE1_IOCSET_MASK_BOOT_PREFERENCE      (0x00030000)
+#define MPI2_BIOSPAGE1_IOCSET_ENCLOSURE_SLOT_BOOT       (0x00000000)
+#define MPI2_BIOSPAGE1_IOCSET_SAS_ADDRESS_BOOT          (0x00010000)
+
+#define MPI2_BIOSPAGE1_IOCSET_MASK_RM_SETTING           (0x000000C0)
+#define MPI2_BIOSPAGE1_IOCSET_NONE_RM_SETTING           (0x00000000)
+#define MPI2_BIOSPAGE1_IOCSET_BOOT_RM_SETTING           (0x00000040)
+#define MPI2_BIOSPAGE1_IOCSET_MEDIA_RM_SETTING          (0x00000080)
+
+#define MPI2_BIOSPAGE1_IOCSET_MASK_ADAPTER_SUPPORT      (0x00000030)
+#define MPI2_BIOSPAGE1_IOCSET_NO_SUPPORT                (0x00000000)
+#define MPI2_BIOSPAGE1_IOCSET_BIOS_SUPPORT              (0x00000010)
+#define MPI2_BIOSPAGE1_IOCSET_OS_SUPPORT                (0x00000020)
+#define MPI2_BIOSPAGE1_IOCSET_ALL_SUPPORT               (0x00000030)
+
+#define MPI2_BIOSPAGE1_IOCSET_ALTERNATE_CHS             (0x00000008)
+
+/* values for BIOS Page 1 DeviceSettings field */
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_SMART_POLLING     (0x00000010)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_SEQ_LUN           (0x00000008)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_RM_LUN            (0x00000004)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_NON_RM_LUN        (0x00000002)
+#define MPI2_BIOSPAGE1_DEVSET_DISABLE_OTHER_LUN         (0x00000001)
+
+
+/* BIOS Page 2 */
+
+typedef struct _MPI2_BOOT_DEVICE_ADAPTER_ORDER
+{
+    U32         Reserved1;                              /* 0x00 */
+    U32         Reserved2;                              /* 0x04 */
+    U32         Reserved3;                              /* 0x08 */
+    U32         Reserved4;                              /* 0x0C */
+    U32         Reserved5;                              /* 0x10 */
+    U32         Reserved6;                              /* 0x14 */
+} MPI2_BOOT_DEVICE_ADAPTER_ORDER,
+  MPI2_POINTER PTR_MPI2_BOOT_DEVICE_ADAPTER_ORDER,
+  Mpi2BootDeviceAdapterOrder_t, MPI2_POINTER pMpi2BootDeviceAdapterOrder_t;
+
+typedef struct _MPI2_BOOT_DEVICE_SAS_WWID
+{
+    U64         SASAddress;                             /* 0x00 */
+    U8          LUN[8];                                 /* 0x08 */
+    U32         Reserved1;                              /* 0x10 */
+    U32         Reserved2;                              /* 0x14 */
+} MPI2_BOOT_DEVICE_SAS_WWID, MPI2_POINTER PTR_MPI2_BOOT_DEVICE_SAS_WWID,
+  Mpi2BootDeviceSasWwid_t, MPI2_POINTER pMpi2BootDeviceSasWwid_t;
+
+typedef struct _MPI2_BOOT_DEVICE_ENCLOSURE_SLOT
+{
+    U64         EnclosureLogicalID;                     /* 0x00 */
+    U32         Reserved1;                              /* 0x08 */
+    U32         Reserved2;                              /* 0x0C */
+    U16         SlotNumber;                             /* 0x10 */
+    U16         Reserved3;                              /* 0x12 */
+    U32         Reserved4;                              /* 0x14 */
+} MPI2_BOOT_DEVICE_ENCLOSURE_SLOT,
+  MPI2_POINTER PTR_MPI2_BOOT_DEVICE_ENCLOSURE_SLOT,
+  Mpi2BootDeviceEnclosureSlot_t, MPI2_POINTER pMpi2BootDeviceEnclosureSlot_t;
+
+typedef struct _MPI2_BOOT_DEVICE_DEVICE_NAME
+{
+    U64         DeviceName;                             /* 0x00 */
+    U8          LUN[8];                                 /* 0x08 */
+    U32         Reserved1;                              /* 0x10 */
+    U32         Reserved2;                              /* 0x14 */
+} MPI2_BOOT_DEVICE_DEVICE_NAME, MPI2_POINTER PTR_MPI2_BOOT_DEVICE_DEVICE_NAME,
+  Mpi2BootDeviceDeviceName_t, MPI2_POINTER pMpi2BootDeviceDeviceName_t;
+
+typedef union _MPI2_MPI2_BIOSPAGE2_BOOT_DEVICE
+{
+    MPI2_BOOT_DEVICE_ADAPTER_ORDER  AdapterOrder;
+    MPI2_BOOT_DEVICE_SAS_WWID       SasWwid;
+    MPI2_BOOT_DEVICE_ENCLOSURE_SLOT EnclosureSlot;
+    MPI2_BOOT_DEVICE_DEVICE_NAME    DeviceName;
+} MPI2_BIOSPAGE2_BOOT_DEVICE, MPI2_POINTER PTR_MPI2_BIOSPAGE2_BOOT_DEVICE,
+  Mpi2BiosPage2BootDevice_t, MPI2_POINTER pMpi2BiosPage2BootDevice_t;
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_2
+{
+    MPI2_CONFIG_PAGE_HEADER     Header;                 /* 0x00 */
+    U32                         Reserved1;              /* 0x04 */
+    U32                         Reserved2;              /* 0x08 */
+    U32                         Reserved3;              /* 0x0C */
+    U32                         Reserved4;              /* 0x10 */
+    U32                         Reserved5;              /* 0x14 */
+    U32                         Reserved6;              /* 0x18 */
+    U8                          ReqBootDeviceForm;      /* 0x1C */
+    U8                          Reserved7;              /* 0x1D */
+    U16                         Reserved8;              /* 0x1E */
+    MPI2_BIOSPAGE2_BOOT_DEVICE  RequestedBootDevice;    /* 0x20 */
+    U8                          ReqAltBootDeviceForm;   /* 0x38 */
+    U8                          Reserved9;              /* 0x39 */
+    U16                         Reserved10;             /* 0x3A */
+    MPI2_BIOSPAGE2_BOOT_DEVICE  RequestedAltBootDevice; /* 0x3C */
+    U8                          CurrentBootDeviceForm;  /* 0x58 */
+    U8                          Reserved11;             /* 0x59 */
+    U16                         Reserved12;             /* 0x5A */
+    MPI2_BIOSPAGE2_BOOT_DEVICE  CurrentBootDevice;      /* 0x58 */
+} MPI2_CONFIG_PAGE_BIOS_2, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_BIOS_2,
+  Mpi2BiosPage2_t, MPI2_POINTER pMpi2BiosPage2_t;
+
+#define MPI2_BIOSPAGE2_PAGEVERSION                      (0x04)
+
+/* values for BIOS Page 2 BootDeviceForm fields */
+#define MPI2_BIOSPAGE2_FORM_MASK                        (0x0F)
+#define MPI2_BIOSPAGE2_FORM_NO_DEVICE_SPECIFIED         (0x00)
+#define MPI2_BIOSPAGE2_FORM_SAS_WWID                    (0x05)
+#define MPI2_BIOSPAGE2_FORM_ENCLOSURE_SLOT              (0x06)
+#define MPI2_BIOSPAGE2_FORM_DEVICE_NAME                 (0x07)
+
+
+/* BIOS Page 3 */
+
+typedef struct _MPI2_ADAPTER_INFO
+{
+    U8      PciBusNumber;                               /* 0x00 */
+    U8      PciDeviceAndFunctionNumber;                 /* 0x01 */
+    U16     AdapterFlags;                               /* 0x02 */
+} MPI2_ADAPTER_INFO, MPI2_POINTER PTR_MPI2_ADAPTER_INFO,
+  Mpi2AdapterInfo_t, MPI2_POINTER pMpi2AdapterInfo_t;
+
+#define MPI2_ADAPTER_INFO_FLAGS_EMBEDDED                (0x0001)
+#define MPI2_ADAPTER_INFO_FLAGS_INIT_STATUS             (0x0002)
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_3
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U32                     GlobalFlags;                /* 0x04 */
+    U32                     BiosVersion;                /* 0x08 */
+    MPI2_ADAPTER_INFO       AdapterOrder[4];            /* 0x0C */
+    U32                     Reserved1;                  /* 0x1C */
+} MPI2_CONFIG_PAGE_BIOS_3, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_BIOS_3,
+  Mpi2BiosPage3_t, MPI2_POINTER pMpi2BiosPage3_t;
+
+#define MPI2_BIOSPAGE3_PAGEVERSION                      (0x00)
+
+/* values for BIOS Page 3 GlobalFlags */
+#define MPI2_BIOSPAGE3_FLAGS_PAUSE_ON_ERROR             (0x00000002)
+#define MPI2_BIOSPAGE3_FLAGS_VERBOSE_ENABLE             (0x00000004)
+#define MPI2_BIOSPAGE3_FLAGS_HOOK_INT_40_DISABLE        (0x00000010)
+
+#define MPI2_BIOSPAGE3_FLAGS_DEV_LIST_DISPLAY_MASK      (0x000000E0)
+#define MPI2_BIOSPAGE3_FLAGS_INSTALLED_DEV_DISPLAY      (0x00000000)
+#define MPI2_BIOSPAGE3_FLAGS_ADAPTER_DISPLAY            (0x00000020)
+#define MPI2_BIOSPAGE3_FLAGS_ADAPTER_DEV_DISPLAY        (0x00000040)
+
+
+/* BIOS Page 4 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength or NumPhys at runtime.
+ */
+#ifndef MPI2_BIOS_PAGE_4_PHY_ENTRIES
+#define MPI2_BIOS_PAGE_4_PHY_ENTRIES        (1)
+#endif
+
+typedef struct _MPI2_BIOS4_ENTRY
+{
+    U64                     ReassignmentWWID;       /* 0x00 */
+    U64                     ReassignmentDeviceName; /* 0x08 */
+} MPI2_BIOS4_ENTRY, MPI2_POINTER PTR_MPI2_BIOS4_ENTRY,
+  Mpi2MBios4Entry_t, MPI2_POINTER pMpi2Bios4Entry_t;
+
+typedef struct _MPI2_CONFIG_PAGE_BIOS_4
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                             /* 0x00 */
+    U8                      NumPhys;                            /* 0x04 */
+    U8                      Reserved1;                          /* 0x05 */
+    U16                     Reserved2;                          /* 0x06 */
+    MPI2_BIOS4_ENTRY        Phy[MPI2_BIOS_PAGE_4_PHY_ENTRIES];  /* 0x08 */
+} MPI2_CONFIG_PAGE_BIOS_4, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_BIOS_4,
+  Mpi2BiosPage4_t, MPI2_POINTER pMpi2BiosPage4_t;
+
+#define MPI2_BIOSPAGE4_PAGEVERSION                      (0x01)
+
+
+/****************************************************************************
+*   RAID Volume Config Pages
+****************************************************************************/
+
+/* RAID Volume Page 0 */
+
+typedef struct _MPI2_RAIDVOL0_PHYS_DISK
+{
+    U8                      RAIDSetNum;                 /* 0x00 */
+    U8                      PhysDiskMap;                /* 0x01 */
+    U8                      PhysDiskNum;                /* 0x02 */
+    U8                      Reserved;                   /* 0x03 */
+} MPI2_RAIDVOL0_PHYS_DISK, MPI2_POINTER PTR_MPI2_RAIDVOL0_PHYS_DISK,
+  Mpi2RaidVol0PhysDisk_t, MPI2_POINTER pMpi2RaidVol0PhysDisk_t;
+
+/* defines for the PhysDiskMap field */
+#define MPI2_RAIDVOL0_PHYSDISK_PRIMARY                  (0x01)
+#define MPI2_RAIDVOL0_PHYSDISK_SECONDARY                (0x02)
+
+typedef struct _MPI2_RAIDVOL0_SETTINGS
+{
+    U16                     Settings;                   /* 0x00 */
+    U8                      HotSparePool;               /* 0x01 */
+    U8                      Reserved;                   /* 0x02 */
+} MPI2_RAIDVOL0_SETTINGS, MPI2_POINTER PTR_MPI2_RAIDVOL0_SETTINGS,
+  Mpi2RaidVol0Settings_t, MPI2_POINTER pMpi2RaidVol0Settings_t;
+
+/* RAID Volume Page 0 HotSparePool defines, also used in RAID Physical Disk */
+#define MPI2_RAID_HOT_SPARE_POOL_0                      (0x01)
+#define MPI2_RAID_HOT_SPARE_POOL_1                      (0x02)
+#define MPI2_RAID_HOT_SPARE_POOL_2                      (0x04)
+#define MPI2_RAID_HOT_SPARE_POOL_3                      (0x08)
+#define MPI2_RAID_HOT_SPARE_POOL_4                      (0x10)
+#define MPI2_RAID_HOT_SPARE_POOL_5                      (0x20)
+#define MPI2_RAID_HOT_SPARE_POOL_6                      (0x40)
+#define MPI2_RAID_HOT_SPARE_POOL_7                      (0x80)
+
+/* RAID Volume Page 0 VolumeSettings defines */
+#define MPI2_RAIDVOL0_SETTING_USE_PRODUCT_ID_SUFFIX     (0x0008)
+#define MPI2_RAIDVOL0_SETTING_AUTO_CONFIG_HSWAP_DISABLE (0x0004)
+
+#define MPI2_RAIDVOL0_SETTING_MASK_WRITE_CACHING        (0x0003)
+#define MPI2_RAIDVOL0_SETTING_UNCHANGED                 (0x0000)
+#define MPI2_RAIDVOL0_SETTING_DISABLE_WRITE_CACHING     (0x0001)
+#define MPI2_RAIDVOL0_SETTING_ENABLE_WRITE_CACHING      (0x0002)
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength at runtime.
+ */
+#ifndef MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX
+#define MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX       (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_0
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U16                     DevHandle;                  /* 0x04 */
+    U8                      VolumeState;                /* 0x06 */
+    U8                      VolumeType;                 /* 0x07 */
+    U32                     VolumeStatusFlags;          /* 0x08 */
+    MPI2_RAIDVOL0_SETTINGS  VolumeSettings;             /* 0x0C */
+    U64                     MaxLBA;                     /* 0x10 */
+    U32                     StripeSize;                 /* 0x18 */
+    U16                     BlockSize;                  /* 0x1C */
+    U16                     Reserved1;                  /* 0x1E */
+    U8                      SupportedPhysDisks;         /* 0x20 */
+    U8                      ResyncRate;                 /* 0x21 */
+    U16                     DataScrubDuration;          /* 0x22 */
+    U8                      NumPhysDisks;               /* 0x24 */
+    U8                      Reserved2;                  /* 0x25 */
+    U8                      Reserved3;                  /* 0x26 */
+    U8                      InactiveStatus;             /* 0x27 */
+    MPI2_RAIDVOL0_PHYS_DISK PhysDisk[MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX]; /* 0x28 */
+} MPI2_CONFIG_PAGE_RAID_VOL_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_RAID_VOL_0,
+  Mpi2RaidVolPage0_t, MPI2_POINTER pMpi2RaidVolPage0_t;
+
+#define MPI2_RAIDVOLPAGE0_PAGEVERSION           (0x0A)
+
+/* values for RAID VolumeState */
+#define MPI2_RAID_VOL_STATE_MISSING                         (0x00)
+#define MPI2_RAID_VOL_STATE_FAILED                          (0x01)
+#define MPI2_RAID_VOL_STATE_INITIALIZING                    (0x02)
+#define MPI2_RAID_VOL_STATE_ONLINE                          (0x03)
+#define MPI2_RAID_VOL_STATE_DEGRADED                        (0x04)
+#define MPI2_RAID_VOL_STATE_OPTIMAL                         (0x05)
+
+/* values for RAID VolumeType */
+#define MPI2_RAID_VOL_TYPE_RAID0                            (0x00)
+#define MPI2_RAID_VOL_TYPE_RAID1E                           (0x01)
+#define MPI2_RAID_VOL_TYPE_RAID1                            (0x02)
+#define MPI2_RAID_VOL_TYPE_RAID10                           (0x05)
+#define MPI2_RAID_VOL_TYPE_UNKNOWN                          (0xFF)
+
+/* values for RAID Volume Page 0 VolumeStatusFlags field */
+#define MPI2_RAIDVOL0_STATUS_FLAG_PENDING_RESYNC            (0x02000000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BACKG_INIT_PENDING        (0x01000000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_MDC_PENDING               (0x00800000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_USER_CONSIST_PENDING      (0x00400000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_MAKE_DATA_CONSISTENT      (0x00200000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_DATA_SCRUB                (0x00100000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_CONSISTENCY_CHECK         (0x00080000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_CAPACITY_EXPANSION        (0x00040000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BACKGROUND_INIT           (0x00020000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS        (0x00010000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_OCE_ALLOWED               (0x00000040)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BGI_COMPLETE              (0x00000020)
+#define MPI2_RAIDVOL0_STATUS_FLAG_1E_OFFSET_MIRROR          (0x00000000)
+#define MPI2_RAIDVOL0_STATUS_FLAG_1E_ADJACENT_MIRROR        (0x00000010)
+#define MPI2_RAIDVOL0_STATUS_FLAG_BAD_BLOCK_TABLE_FULL      (0x00000008)
+#define MPI2_RAIDVOL0_STATUS_FLAG_VOLUME_INACTIVE           (0x00000004)
+#define MPI2_RAIDVOL0_STATUS_FLAG_QUIESCED                  (0x00000002)
+#define MPI2_RAIDVOL0_STATUS_FLAG_ENABLED                   (0x00000001)
+
+/* values for RAID Volume Page 0 SupportedPhysDisks field */
+#define MPI2_RAIDVOL0_SUPPORT_SOLID_STATE_DISKS             (0x08)
+#define MPI2_RAIDVOL0_SUPPORT_HARD_DISKS                    (0x04)
+#define MPI2_RAIDVOL0_SUPPORT_SAS_PROTOCOL                  (0x02)
+#define MPI2_RAIDVOL0_SUPPORT_SATA_PROTOCOL                 (0x01)
+
+/* values for RAID Volume Page 0 InactiveStatus field */
+#define MPI2_RAIDVOLPAGE0_UNKNOWN_INACTIVE                  (0x00)
+#define MPI2_RAIDVOLPAGE0_STALE_METADATA_INACTIVE           (0x01)
+#define MPI2_RAIDVOLPAGE0_FOREIGN_VOLUME_INACTIVE           (0x02)
+#define MPI2_RAIDVOLPAGE0_INSUFFICIENT_RESOURCE_INACTIVE    (0x03)
+#define MPI2_RAIDVOLPAGE0_CLONE_VOLUME_INACTIVE             (0x04)
+#define MPI2_RAIDVOLPAGE0_INSUFFICIENT_METADATA_INACTIVE    (0x05)
+#define MPI2_RAIDVOLPAGE0_PREVIOUSLY_DELETED                (0x06)
+
+
+/* RAID Volume Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_1
+{
+    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+    U16                     DevHandle;                  /* 0x04 */
+    U16                     Reserved0;                  /* 0x06 */
+    U8                      GUID[24];                   /* 0x08 */
+    U8                      Name[16];                   /* 0x20 */
+    U64                     WWID;                       /* 0x30 */
+    U32                     Reserved1;                  /* 0x38 */
+    U32                     Reserved2;                  /* 0x3C */
+} MPI2_CONFIG_PAGE_RAID_VOL_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_RAID_VOL_1,
+  Mpi2RaidVolPage1_t, MPI2_POINTER pMpi2RaidVolPage1_t;
+
+#define MPI2_RAIDVOLPAGE1_PAGEVERSION           (0x03)
+
+
+/****************************************************************************
+*   RAID Physical Disk Config Pages
+****************************************************************************/
+
+/* RAID Physical Disk Page 0 */
+
+typedef struct _MPI2_RAIDPHYSDISK0_SETTINGS
+{
+    U16                     Reserved1;                  /* 0x00 */
+    U8                      HotSparePool;               /* 0x02 */
+    U8                      Reserved2;                  /* 0x03 */
+} MPI2_RAIDPHYSDISK0_SETTINGS, MPI2_POINTER PTR_MPI2_RAIDPHYSDISK0_SETTINGS,
+  Mpi2RaidPhysDisk0Settings_t, MPI2_POINTER pMpi2RaidPhysDisk0Settings_t;
+
+/* use MPI2_RAID_HOT_SPARE_POOL_ defines for the HotSparePool field */
+
+typedef struct _MPI2_RAIDPHYSDISK0_INQUIRY_DATA
+{
+    U8                      VendorID[8];                /* 0x00 */
+    U8                      ProductID[16];              /* 0x08 */
+    U8                      ProductRevLevel[4];         /* 0x18 */
+    U8                      SerialNum[32];              /* 0x1C */
+} MPI2_RAIDPHYSDISK0_INQUIRY_DATA,
+  MPI2_POINTER PTR_MPI2_RAIDPHYSDISK0_INQUIRY_DATA,
+  Mpi2RaidPhysDisk0InquiryData_t, MPI2_POINTER pMpi2RaidPhysDisk0InquiryData_t;
+
+typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_0
+{
+    MPI2_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    U16                             DevHandle;                  /* 0x04 */
+    U8                              Reserved1;                  /* 0x06 */
+    U8                              PhysDiskNum;                /* 0x07 */
+    MPI2_RAIDPHYSDISK0_SETTINGS     PhysDiskSettings;           /* 0x08 */
+    U32                             Reserved2;                  /* 0x0C */
+    MPI2_RAIDPHYSDISK0_INQUIRY_DATA InquiryData;                /* 0x10 */
+    U32                             Reserved3;                  /* 0x4C */
+    U8                              PhysDiskState;              /* 0x50 */
+    U8                              OfflineReason;              /* 0x51 */
+    U8                              IncompatibleReason;         /* 0x52 */
+    U8                              PhysDiskAttributes;         /* 0x53 */
+    U32                             PhysDiskStatusFlags;        /* 0x54 */
+    U64                             DeviceMaxLBA;               /* 0x58 */
+    U64                             HostMaxLBA;                 /* 0x60 */
+    U64                             CoercedMaxLBA;              /* 0x68 */
+    U16                             BlockSize;                  /* 0x70 */
+    U16                             Reserved5;                  /* 0x72 */
+    U32                             Reserved6;                  /* 0x74 */
+} MPI2_CONFIG_PAGE_RD_PDISK_0,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_RD_PDISK_0,
+  Mpi2RaidPhysDiskPage0_t, MPI2_POINTER pMpi2RaidPhysDiskPage0_t;
+
+#define MPI2_RAIDPHYSDISKPAGE0_PAGEVERSION          (0x05)
+
+/* PhysDiskState defines */
+#define MPI2_RAID_PD_STATE_NOT_CONFIGURED               (0x00)
+#define MPI2_RAID_PD_STATE_NOT_COMPATIBLE               (0x01)
+#define MPI2_RAID_PD_STATE_OFFLINE                      (0x02)
+#define MPI2_RAID_PD_STATE_ONLINE                       (0x03)
+#define MPI2_RAID_PD_STATE_HOT_SPARE                    (0x04)
+#define MPI2_RAID_PD_STATE_DEGRADED                     (0x05)
+#define MPI2_RAID_PD_STATE_REBUILDING                   (0x06)
+#define MPI2_RAID_PD_STATE_OPTIMAL                      (0x07)
+
+/* OfflineReason defines */
+#define MPI2_PHYSDISK0_ONLINE                           (0x00)
+#define MPI2_PHYSDISK0_OFFLINE_MISSING                  (0x01)
+#define MPI2_PHYSDISK0_OFFLINE_FAILED                   (0x03)
+#define MPI2_PHYSDISK0_OFFLINE_INITIALIZING             (0x04)
+#define MPI2_PHYSDISK0_OFFLINE_REQUESTED                (0x05)
+#define MPI2_PHYSDISK0_OFFLINE_FAILED_REQUESTED         (0x06)
+#define MPI2_PHYSDISK0_OFFLINE_OTHER                    (0xFF)
+
+/* IncompatibleReason defines */
+#define MPI2_PHYSDISK0_COMPATIBLE                       (0x00)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_PROTOCOL            (0x01)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_BLOCKSIZE           (0x02)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_MAX_LBA             (0x03)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_SATA_EXTENDED_CMD   (0x04)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_REMOVEABLE_MEDIA    (0x05)
+#define MPI2_PHYSDISK0_INCOMPATIBLE_UNKNOWN             (0xFF)
+
+/* PhysDiskAttributes defines */
+#define MPI2_PHYSDISK0_ATTRIB_SOLID_STATE_DRIVE         (0x08)
+#define MPI2_PHYSDISK0_ATTRIB_HARD_DISK_DRIVE           (0x04)
+#define MPI2_PHYSDISK0_ATTRIB_SAS_PROTOCOL              (0x02)
+#define MPI2_PHYSDISK0_ATTRIB_SATA_PROTOCOL             (0x01)
+
+/* PhysDiskStatusFlags defines */
+#define MPI2_PHYSDISK0_STATUS_FLAG_NOT_CERTIFIED        (0x00000040)
+#define MPI2_PHYSDISK0_STATUS_FLAG_OCE_TARGET           (0x00000020)
+#define MPI2_PHYSDISK0_STATUS_FLAG_WRITE_CACHE_ENABLED  (0x00000010)
+#define MPI2_PHYSDISK0_STATUS_FLAG_OPTIMAL_PREVIOUS     (0x00000000)
+#define MPI2_PHYSDISK0_STATUS_FLAG_NOT_OPTIMAL_PREVIOUS (0x00000008)
+#define MPI2_PHYSDISK0_STATUS_FLAG_INACTIVE_VOLUME      (0x00000004)
+#define MPI2_PHYSDISK0_STATUS_FLAG_QUIESCED             (0x00000002)
+#define MPI2_PHYSDISK0_STATUS_FLAG_OUT_OF_SYNC          (0x00000001)
+
+
+/* RAID Physical Disk Page 1 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength or NumPhysDiskPaths at runtime.
+ */
+#ifndef MPI2_RAID_PHYS_DISK1_PATH_MAX
+#define MPI2_RAID_PHYS_DISK1_PATH_MAX   (1)
+#endif
+
+typedef struct _MPI2_RAIDPHYSDISK1_PATH
+{
+    U16             DevHandle;          /* 0x00 */
+    U16             Reserved1;          /* 0x02 */
+    U64             WWID;               /* 0x04 */
+    U64             OwnerWWID;          /* 0x0C */
+    U8              OwnerIdentifier;    /* 0x14 */
+    U8              Reserved2;          /* 0x15 */
+    U16             Flags;              /* 0x16 */
+} MPI2_RAIDPHYSDISK1_PATH, MPI2_POINTER PTR_MPI2_RAIDPHYSDISK1_PATH,
+  Mpi2RaidPhysDisk1Path_t, MPI2_POINTER pMpi2RaidPhysDisk1Path_t;
+
+/* RAID Physical Disk Page 1 Physical Disk Path Flags field defines */
+#define MPI2_RAID_PHYSDISK1_FLAG_PRIMARY        (0x0004)
+#define MPI2_RAID_PHYSDISK1_FLAG_BROKEN         (0x0002)
+#define MPI2_RAID_PHYSDISK1_FLAG_INVALID        (0x0001)
+
+typedef struct _MPI2_CONFIG_PAGE_RD_PDISK_1
+{
+    MPI2_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    U8                              NumPhysDiskPaths;           /* 0x04 */
+    U8                              PhysDiskNum;                /* 0x05 */
+    U16                             Reserved1;                  /* 0x06 */
+    U32                             Reserved2;                  /* 0x08 */
+    MPI2_RAIDPHYSDISK1_PATH         PhysicalDiskPath[MPI2_RAID_PHYS_DISK1_PATH_MAX];/* 0x0C */
+} MPI2_CONFIG_PAGE_RD_PDISK_1,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_RD_PDISK_1,
+  Mpi2RaidPhysDiskPage1_t, MPI2_POINTER pMpi2RaidPhysDiskPage1_t;
+
+#define MPI2_RAIDPHYSDISKPAGE1_PAGEVERSION          (0x02)
+
+
+/****************************************************************************
+*   values for fields used by several types of SAS Config Pages
+****************************************************************************/
+
+/* values for NegotiatedLinkRates fields */
+#define MPI2_SAS_NEG_LINK_RATE_MASK_LOGICAL             (0xF0)
+#define MPI2_SAS_NEG_LINK_RATE_SHIFT_LOGICAL            (4)
+#define MPI2_SAS_NEG_LINK_RATE_MASK_PHYSICAL            (0x0F)
+/* link rates used for Negotiated Physical and Logical Link Rate */
+#define MPI2_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE        (0x00)
+#define MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED             (0x01)
+#define MPI2_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED       (0x02)
+#define MPI2_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE        (0x03)
+#define MPI2_SAS_NEG_LINK_RATE_PORT_SELECTOR            (0x04)
+#define MPI2_SAS_NEG_LINK_RATE_SMP_RESET_IN_PROGRESS    (0x05)
+#define MPI2_SAS_NEG_LINK_RATE_1_5                      (0x08)
+#define MPI2_SAS_NEG_LINK_RATE_3_0                      (0x09)
+#define MPI2_SAS_NEG_LINK_RATE_6_0                      (0x0A)
+
+
+/* values for AttachedPhyInfo fields */
+#define MPI2_SAS_APHYINFO_INSIDE_ZPSDS_PERSISTENT       (0x00000040)
+#define MPI2_SAS_APHYINFO_REQUESTED_INSIDE_ZPSDS        (0x00000020)
+#define MPI2_SAS_APHYINFO_BREAK_REPLY_CAPABLE           (0x00000010)
+
+#define MPI2_SAS_APHYINFO_REASON_MASK                   (0x0000000F)
+#define MPI2_SAS_APHYINFO_REASON_UNKNOWN                (0x00000000)
+#define MPI2_SAS_APHYINFO_REASON_POWER_ON               (0x00000001)
+#define MPI2_SAS_APHYINFO_REASON_HARD_RESET             (0x00000002)
+#define MPI2_SAS_APHYINFO_REASON_SMP_PHY_CONTROL        (0x00000003)
+#define MPI2_SAS_APHYINFO_REASON_LOSS_OF_SYNC           (0x00000004)
+#define MPI2_SAS_APHYINFO_REASON_MULTIPLEXING_SEQ       (0x00000005)
+#define MPI2_SAS_APHYINFO_REASON_IT_NEXUS_LOSS_TIMER    (0x00000006)
+#define MPI2_SAS_APHYINFO_REASON_BREAK_TIMEOUT          (0x00000007)
+#define MPI2_SAS_APHYINFO_REASON_PHY_TEST_STOPPED       (0x00000008)
+
+
+/* values for PhyInfo fields */
+#define MPI2_SAS_PHYINFO_PHY_VACANT                     (0x80000000)
+#define MPI2_SAS_PHYINFO_CHANGED_REQ_INSIDE_ZPSDS       (0x04000000)
+#define MPI2_SAS_PHYINFO_INSIDE_ZPSDS_PERSISTENT        (0x02000000)
+#define MPI2_SAS_PHYINFO_REQ_INSIDE_ZPSDS               (0x01000000)
+#define MPI2_SAS_PHYINFO_ZONE_GROUP_PERSISTENT          (0x00400000)
+#define MPI2_SAS_PHYINFO_INSIDE_ZPSDS                   (0x00200000)
+#define MPI2_SAS_PHYINFO_ZONING_ENABLED                 (0x00100000)
+
+#define MPI2_SAS_PHYINFO_REASON_MASK                    (0x000F0000)
+#define MPI2_SAS_PHYINFO_REASON_UNKNOWN                 (0x00000000)
+#define MPI2_SAS_PHYINFO_REASON_POWER_ON                (0x00010000)
+#define MPI2_SAS_PHYINFO_REASON_HARD_RESET              (0x00020000)
+#define MPI2_SAS_PHYINFO_REASON_SMP_PHY_CONTROL         (0x00030000)
+#define MPI2_SAS_PHYINFO_REASON_LOSS_OF_SYNC            (0x00040000)
+#define MPI2_SAS_PHYINFO_REASON_MULTIPLEXING_SEQ        (0x00050000)
+#define MPI2_SAS_PHYINFO_REASON_IT_NEXUS_LOSS_TIMER     (0x00060000)
+#define MPI2_SAS_PHYINFO_REASON_BREAK_TIMEOUT           (0x00070000)
+#define MPI2_SAS_PHYINFO_REASON_PHY_TEST_STOPPED        (0x00080000)
+
+#define MPI2_SAS_PHYINFO_MULTIPLEXING_SUPPORTED         (0x00008000)
+#define MPI2_SAS_PHYINFO_SATA_PORT_ACTIVE               (0x00004000)
+#define MPI2_SAS_PHYINFO_SATA_PORT_SELECTOR_PRESENT     (0x00002000)
+#define MPI2_SAS_PHYINFO_VIRTUAL_PHY                    (0x00001000)
+
+#define MPI2_SAS_PHYINFO_MASK_PARTIAL_PATHWAY_TIME      (0x00000F00)
+#define MPI2_SAS_PHYINFO_SHIFT_PARTIAL_PATHWAY_TIME     (8)
+
+#define MPI2_SAS_PHYINFO_MASK_ROUTING_ATTRIBUTE         (0x000000F0)
+#define MPI2_SAS_PHYINFO_DIRECT_ROUTING                 (0x00000000)
+#define MPI2_SAS_PHYINFO_SUBTRACTIVE_ROUTING            (0x00000010)
+#define MPI2_SAS_PHYINFO_TABLE_ROUTING                  (0x00000020)
+
+
+/* values for SAS ProgrammedLinkRate fields */
+#define MPI2_SAS_PRATE_MAX_RATE_MASK                    (0xF0)
+#define MPI2_SAS_PRATE_MAX_RATE_NOT_PROGRAMMABLE        (0x00)
+#define MPI2_SAS_PRATE_MAX_RATE_1_5                     (0x80)
+#define MPI2_SAS_PRATE_MAX_RATE_3_0                     (0x90)
+#define MPI2_SAS_PRATE_MAX_RATE_6_0                     (0xA0)
+#define MPI2_SAS_PRATE_MIN_RATE_MASK                    (0x0F)
+#define MPI2_SAS_PRATE_MIN_RATE_NOT_PROGRAMMABLE        (0x00)
+#define MPI2_SAS_PRATE_MIN_RATE_1_5                     (0x08)
+#define MPI2_SAS_PRATE_MIN_RATE_3_0                     (0x09)
+#define MPI2_SAS_PRATE_MIN_RATE_6_0                     (0x0A)
+
+
+/* values for SAS HwLinkRate fields */
+#define MPI2_SAS_HWRATE_MAX_RATE_MASK                   (0xF0)
+#define MPI2_SAS_HWRATE_MAX_RATE_1_5                    (0x80)
+#define MPI2_SAS_HWRATE_MAX_RATE_3_0                    (0x90)
+#define MPI2_SAS_HWRATE_MAX_RATE_6_0                    (0xA0)
+#define MPI2_SAS_HWRATE_MIN_RATE_MASK                   (0x0F)
+#define MPI2_SAS_HWRATE_MIN_RATE_1_5                    (0x08)
+#define MPI2_SAS_HWRATE_MIN_RATE_3_0                    (0x09)
+#define MPI2_SAS_HWRATE_MIN_RATE_6_0                    (0x0A)
+
+
+
+/****************************************************************************
+*   SAS IO Unit Config Pages
+****************************************************************************/
+
+/* SAS IO Unit Page 0 */
+
+typedef struct _MPI2_SAS_IO_UNIT0_PHY_DATA
+{
+    U8          Port;                   /* 0x00 */
+    U8          PortFlags;              /* 0x01 */
+    U8          PhyFlags;               /* 0x02 */
+    U8          NegotiatedLinkRate;     /* 0x03 */
+    U32         ControllerPhyDeviceInfo;/* 0x04 */
+    U16         AttachedDevHandle;      /* 0x08 */
+    U16         ControllerDevHandle;    /* 0x0A */
+    U32         DiscoveryStatus;        /* 0x0C */
+    U32         Reserved;               /* 0x10 */
+} MPI2_SAS_IO_UNIT0_PHY_DATA, MPI2_POINTER PTR_MPI2_SAS_IO_UNIT0_PHY_DATA,
+  Mpi2SasIOUnit0PhyData_t, MPI2_POINTER pMpi2SasIOUnit0PhyData_t;
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhys at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT0_PHY_MAX
+#define MPI2_SAS_IOUNIT0_PHY_MAX        (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                             /* 0x00 */
+    U32                                 Reserved1;                          /* 0x08 */
+    U8                                  NumPhys;                            /* 0x0C */
+    U8                                  Reserved2;                          /* 0x0D */
+    U16                                 Reserved3;                          /* 0x0E */
+    MPI2_SAS_IO_UNIT0_PHY_DATA          PhyData[MPI2_SAS_IOUNIT0_PHY_MAX];  /* 0x10 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_0,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SASIOUNIT_0,
+  Mpi2SasIOUnitPage0_t, MPI2_POINTER pMpi2SasIOUnitPage0_t;
+
+#define MPI2_SASIOUNITPAGE0_PAGEVERSION                     (0x05)
+
+/* values for SAS IO Unit Page 0 PortFlags */
+#define MPI2_SASIOUNIT0_PORTFLAGS_DISCOVERY_IN_PROGRESS     (0x08)
+#define MPI2_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG          (0x01)
+
+/* values for SAS IO Unit Page 0 PhyFlags */
+#define MPI2_SASIOUNIT0_PHYFLAGS_ZONING_ENABLED             (0x10)
+#define MPI2_SASIOUNIT0_PHYFLAGS_PHY_DISABLED               (0x08)
+
+/* use MPI2_SAS_NEG_LINK_RATE_ defines for the NegotiatedLinkRate field */
+
+/* see mpi2_sas.h for values for SAS IO Unit Page 0 ControllerPhyDeviceInfo values */
+
+/* values for SAS IO Unit Page 0 DiscoveryStatus */
+#define MPI2_SASIOUNIT0_DS_MAX_ENCLOSURES_EXCEED            (0x80000000)
+#define MPI2_SASIOUNIT0_DS_MAX_EXPANDERS_EXCEED             (0x40000000)
+#define MPI2_SASIOUNIT0_DS_MAX_DEVICES_EXCEED               (0x20000000)
+#define MPI2_SASIOUNIT0_DS_MAX_TOPO_PHYS_EXCEED             (0x10000000)
+#define MPI2_SASIOUNIT0_DS_DOWNSTREAM_INITIATOR             (0x08000000)
+#define MPI2_SASIOUNIT0_DS_MULTI_SUBTRACTIVE_SUBTRACTIVE    (0x00008000)
+#define MPI2_SASIOUNIT0_DS_EXP_MULTI_SUBTRACTIVE            (0x00004000)
+#define MPI2_SASIOUNIT0_DS_MULTI_PORT_DOMAIN                (0x00002000)
+#define MPI2_SASIOUNIT0_DS_TABLE_TO_SUBTRACTIVE_LINK        (0x00001000)
+#define MPI2_SASIOUNIT0_DS_UNSUPPORTED_DEVICE               (0x00000800)
+#define MPI2_SASIOUNIT0_DS_TABLE_LINK                       (0x00000400)
+#define MPI2_SASIOUNIT0_DS_SUBTRACTIVE_LINK                 (0x00000200)
+#define MPI2_SASIOUNIT0_DS_SMP_CRC_ERROR                    (0x00000100)
+#define MPI2_SASIOUNIT0_DS_SMP_FUNCTION_FAILED              (0x00000080)
+#define MPI2_SASIOUNIT0_DS_INDEX_NOT_EXIST                  (0x00000040)
+#define MPI2_SASIOUNIT0_DS_OUT_ROUTE_ENTRIES                (0x00000020)
+#define MPI2_SASIOUNIT0_DS_SMP_TIMEOUT                      (0x00000010)
+#define MPI2_SASIOUNIT0_DS_MULTIPLE_PORTS                   (0x00000004)
+#define MPI2_SASIOUNIT0_DS_UNADDRESSABLE_DEVICE             (0x00000002)
+#define MPI2_SASIOUNIT0_DS_LOOP_DETECTED                    (0x00000001)
+
+
+/* SAS IO Unit Page 1 */
+
+typedef struct _MPI2_SAS_IO_UNIT1_PHY_DATA
+{
+    U8          Port;                       /* 0x00 */
+    U8          PortFlags;                  /* 0x01 */
+    U8          PhyFlags;                   /* 0x02 */
+    U8          MaxMinLinkRate;             /* 0x03 */
+    U32         ControllerPhyDeviceInfo;    /* 0x04 */
+    U16         MaxTargetPortConnectTime;   /* 0x08 */
+    U16         Reserved1;                  /* 0x0A */
+} MPI2_SAS_IO_UNIT1_PHY_DATA, MPI2_POINTER PTR_MPI2_SAS_IO_UNIT1_PHY_DATA,
+  Mpi2SasIOUnit1PhyData_t, MPI2_POINTER pMpi2SasIOUnit1PhyData_t;
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhys at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT1_PHY_MAX
+#define MPI2_SAS_IOUNIT1_PHY_MAX        (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_1
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                             /* 0x00 */
+    U16                                 ControlFlags;                       /* 0x08 */
+    U16                                 SASNarrowMaxQueueDepth;             /* 0x0A */
+    U16                                 AdditionalControlFlags;             /* 0x0C */
+    U16                                 SASWideMaxQueueDepth;               /* 0x0E */
+    U8                                  NumPhys;                            /* 0x10 */
+    U8                                  SATAMaxQDepth;                      /* 0x11 */
+    U8                                  ReportDeviceMissingDelay;           /* 0x12 */
+    U8                                  IODeviceMissingDelay;               /* 0x13 */
+    MPI2_SAS_IO_UNIT1_PHY_DATA          PhyData[MPI2_SAS_IOUNIT1_PHY_MAX];  /* 0x14 */
+} MPI2_CONFIG_PAGE_SASIOUNIT_1,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SASIOUNIT_1,
+  Mpi2SasIOUnitPage1_t, MPI2_POINTER pMpi2SasIOUnitPage1_t;
+
+#define MPI2_SASIOUNITPAGE1_PAGEVERSION     (0x09)
+
+/* values for SAS IO Unit Page 1 ControlFlags */
+#define MPI2_SASIOUNIT1_CONTROL_DEVICE_SELF_TEST                    (0x8000)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_3_0_MAX                        (0x4000)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_1_5_MAX                        (0x2000)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_SW_PRESERVE                    (0x1000)
+
+#define MPI2_SASIOUNIT1_CONTROL_MASK_DEV_SUPPORT                    (0x0600)
+#define MPI2_SASIOUNIT1_CONTROL_SHIFT_DEV_SUPPORT                   (9)
+#define MPI2_SASIOUNIT1_CONTROL_DEV_SUPPORT_BOTH                    (0x0)
+#define MPI2_SASIOUNIT1_CONTROL_DEV_SAS_SUPPORT                     (0x1)
+#define MPI2_SASIOUNIT1_CONTROL_DEV_SATA_SUPPORT                    (0x2)
+
+#define MPI2_SASIOUNIT1_CONTROL_SATA_48BIT_LBA_REQUIRED             (0x0080)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_SMART_REQUIRED                 (0x0040)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_NCQ_REQUIRED                   (0x0020)
+#define MPI2_SASIOUNIT1_CONTROL_SATA_FUA_REQUIRED                   (0x0010)
+#define MPI2_SASIOUNIT1_CONTROL_TABLE_SUBTRACTIVE_ILLEGAL           (0x0008)
+#define MPI2_SASIOUNIT1_CONTROL_SUBTRACTIVE_ILLEGAL                 (0x0004)
+#define MPI2_SASIOUNIT1_CONTROL_FIRST_LVL_DISC_ONLY                 (0x0002)
+#define MPI2_SASIOUNIT1_CONTROL_CLEAR_AFFILIATION                   (0x0001)
+
+/* values for SAS IO Unit Page 1 AdditionalControlFlags */
+#define MPI2_SASIOUNIT1_ACONTROL_MULTI_PORT_DOMAIN_ILLEGAL          (0x0080)
+#define MPI2_SASIOUNIT1_ACONTROL_SATA_ASYNCHROUNOUS_NOTIFICATION    (0x0040)
+#define MPI2_SASIOUNIT1_ACONTROL_INVALID_TOPOLOGY_CORRECTION        (0x0020)
+#define MPI2_SASIOUNIT1_ACONTROL_PORT_ENABLE_ONLY_SATA_LINK_RESET   (0x0010)
+#define MPI2_SASIOUNIT1_ACONTROL_OTHER_AFFILIATION_SATA_LINK_RESET  (0x0008)
+#define MPI2_SASIOUNIT1_ACONTROL_SELF_AFFILIATION_SATA_LINK_RESET   (0x0004)
+#define MPI2_SASIOUNIT1_ACONTROL_NO_AFFILIATION_SATA_LINK_RESET     (0x0002)
+#define MPI2_SASIOUNIT1_ACONTROL_ALLOW_TABLE_TO_TABLE               (0x0001)
+
+/* defines for SAS IO Unit Page 1 ReportDeviceMissingDelay */
+#define MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK                 (0x7F)
+#define MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16                      (0x80)
+
+/* values for SAS IO Unit Page 1 PortFlags */
+#define MPI2_SASIOUNIT1_PORT_FLAGS_AUTO_PORT_CONFIG                 (0x01)
+
+/* values for SAS IO Unit Page 2 PhyFlags */
+#define MPI2_SASIOUNIT1_PHYFLAGS_ZONING_ENABLE                      (0x10)
+#define MPI2_SASIOUNIT1_PHYFLAGS_PHY_DISABLE                        (0x08)
+
+/* values for SAS IO Unit Page 0 MaxMinLinkRate */
+#define MPI2_SASIOUNIT1_MAX_RATE_MASK                               (0xF0)
+#define MPI2_SASIOUNIT1_MAX_RATE_1_5                                (0x80)
+#define MPI2_SASIOUNIT1_MAX_RATE_3_0                                (0x90)
+#define MPI2_SASIOUNIT1_MAX_RATE_6_0                                (0xA0)
+#define MPI2_SASIOUNIT1_MIN_RATE_MASK                               (0x0F)
+#define MPI2_SASIOUNIT1_MIN_RATE_1_5                                (0x08)
+#define MPI2_SASIOUNIT1_MIN_RATE_3_0                                (0x09)
+#define MPI2_SASIOUNIT1_MIN_RATE_6_0                                (0x0A)
+
+/* see mpi2_sas.h for values for SAS IO Unit Page 1 ControllerPhyDeviceInfo values */
+
+
+/* SAS IO Unit Page 4 */
+
+typedef struct _MPI2_SAS_IOUNIT4_SPINUP_GROUP
+{
+    U8          MaxTargetSpinup;            /* 0x00 */
+    U8          SpinupDelay;                /* 0x01 */
+    U16         Reserved1;                  /* 0x02 */
+} MPI2_SAS_IOUNIT4_SPINUP_GROUP, MPI2_POINTER PTR_MPI2_SAS_IOUNIT4_SPINUP_GROUP,
+  Mpi2SasIOUnit4SpinupGroup_t, MPI2_POINTER pMpi2SasIOUnit4SpinupGroup_t;
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * four and check Header.ExtPageLength or NumPhys at runtime.
+ */
+#ifndef MPI2_SAS_IOUNIT4_PHY_MAX
+#define MPI2_SAS_IOUNIT4_PHY_MAX        (4)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_4
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                         /* 0x00 */
+    MPI2_SAS_IOUNIT4_SPINUP_GROUP       SpinupGroupParameters[4];       /* 0x08 */
+    U32                                 Reserved1;                      /* 0x18 */
+    U32                                 Reserved2;                      /* 0x1C */
+    U32                                 Reserved3;                      /* 0x20 */
+    U8                                  BootDeviceWaitTime;             /* 0x24 */
+    U8                                  Reserved4;                      /* 0x25 */
+    U16                                 Reserved5;                      /* 0x26 */
+    U8                                  NumPhys;                        /* 0x28 */
+    U8                                  PEInitialSpinupDelay;           /* 0x29 */
+    U8                                  PEReplyDelay;                   /* 0x2A */
+    U8                                  Flags;                          /* 0x2B */
+    U8                                  PHY[MPI2_SAS_IOUNIT4_PHY_MAX];  /* 0x2C */
+} MPI2_CONFIG_PAGE_SASIOUNIT_4,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SASIOUNIT_4,
+  Mpi2SasIOUnitPage4_t, MPI2_POINTER pMpi2SasIOUnitPage4_t;
+
+#define MPI2_SASIOUNITPAGE4_PAGEVERSION     (0x02)
+
+/* defines for Flags field */
+#define MPI2_SASIOUNIT4_FLAGS_AUTO_PORTENABLE               (0x01)
+
+/* defines for PHY field */
+#define MPI2_SASIOUNIT4_PHY_SPINUP_GROUP_MASK               (0x03)
+
+
+/****************************************************************************
+*   SAS Expander Config Pages
+****************************************************************************/
+
+/* SAS Expander Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_EXPANDER_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U8                                  PhysicalPort;               /* 0x08 */
+    U8                                  ReportGenLength;            /* 0x09 */
+    U16                                 EnclosureHandle;            /* 0x0A */
+    U64                                 SASAddress;                 /* 0x0C */
+    U32                                 DiscoveryStatus;            /* 0x14 */
+    U16                                 DevHandle;                  /* 0x18 */
+    U16                                 ParentDevHandle;            /* 0x1A */
+    U16                                 ExpanderChangeCount;        /* 0x1C */
+    U16                                 ExpanderRouteIndexes;       /* 0x1E */
+    U8                                  NumPhys;                    /* 0x20 */
+    U8                                  SASLevel;                   /* 0x21 */
+    U16                                 Flags;                      /* 0x22 */
+    U16                                 STPBusInactivityTimeLimit;  /* 0x24 */
+    U16                                 STPMaxConnectTimeLimit;     /* 0x26 */
+    U16                                 STP_SMP_NexusLossTime;      /* 0x28 */
+    U16                                 MaxNumRoutedSasAddresses;   /* 0x2A */
+    U64                                 ActiveZoneManagerSASAddress;/* 0x2C */
+    U16                                 ZoneLockInactivityLimit;    /* 0x34 */
+    U16                                 Reserved1;                  /* 0x36 */
+} MPI2_CONFIG_PAGE_EXPANDER_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_EXPANDER_0,
+  Mpi2ExpanderPage0_t, MPI2_POINTER pMpi2ExpanderPage0_t;
+
+#define MPI2_SASEXPANDER0_PAGEVERSION       (0x05)
+
+/* values for SAS Expander Page 0 DiscoveryStatus field */
+#define MPI2_SAS_EXPANDER0_DS_MAX_ENCLOSURES_EXCEED         (0x80000000)
+#define MPI2_SAS_EXPANDER0_DS_MAX_EXPANDERS_EXCEED          (0x40000000)
+#define MPI2_SAS_EXPANDER0_DS_MAX_DEVICES_EXCEED            (0x20000000)
+#define MPI2_SAS_EXPANDER0_DS_MAX_TOPO_PHYS_EXCEED          (0x10000000)
+#define MPI2_SAS_EXPANDER0_DS_DOWNSTREAM_INITIATOR          (0x08000000)
+#define MPI2_SAS_EXPANDER0_DS_MULTI_SUBTRACTIVE_SUBTRACTIVE (0x00008000)
+#define MPI2_SAS_EXPANDER0_DS_EXP_MULTI_SUBTRACTIVE         (0x00004000)
+#define MPI2_SAS_EXPANDER0_DS_MULTI_PORT_DOMAIN             (0x00002000)
+#define MPI2_SAS_EXPANDER0_DS_TABLE_TO_SUBTRACTIVE_LINK     (0x00001000)
+#define MPI2_SAS_EXPANDER0_DS_UNSUPPORTED_DEVICE            (0x00000800)
+#define MPI2_SAS_EXPANDER0_DS_TABLE_LINK                    (0x00000400)
+#define MPI2_SAS_EXPANDER0_DS_SUBTRACTIVE_LINK              (0x00000200)
+#define MPI2_SAS_EXPANDER0_DS_SMP_CRC_ERROR                 (0x00000100)
+#define MPI2_SAS_EXPANDER0_DS_SMP_FUNCTION_FAILED           (0x00000080)
+#define MPI2_SAS_EXPANDER0_DS_INDEX_NOT_EXIST               (0x00000040)
+#define MPI2_SAS_EXPANDER0_DS_OUT_ROUTE_ENTRIES             (0x00000020)
+#define MPI2_SAS_EXPANDER0_DS_SMP_TIMEOUT                   (0x00000010)
+#define MPI2_SAS_EXPANDER0_DS_MULTIPLE_PORTS                (0x00000004)
+#define MPI2_SAS_EXPANDER0_DS_UNADDRESSABLE_DEVICE          (0x00000002)
+#define MPI2_SAS_EXPANDER0_DS_LOOP_DETECTED                 (0x00000001)
+
+/* values for SAS Expander Page 0 Flags field */
+#define MPI2_SAS_EXPANDER0_FLAGS_ZONE_LOCKED                (0x1000)
+#define MPI2_SAS_EXPANDER0_FLAGS_SUPPORTED_PHYSICAL_PRES    (0x0800)
+#define MPI2_SAS_EXPANDER0_FLAGS_ASSERTED_PHYSICAL_PRES     (0x0400)
+#define MPI2_SAS_EXPANDER0_FLAGS_ZONING_SUPPORT             (0x0200)
+#define MPI2_SAS_EXPANDER0_FLAGS_ENABLED_ZONING             (0x0100)
+#define MPI2_SAS_EXPANDER0_FLAGS_TABLE_TO_TABLE_SUPPORT     (0x0080)
+#define MPI2_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE       (0x0010)
+#define MPI2_SAS_EXPANDER0_FLAGS_OTHERS_CONFIG              (0x0004)
+#define MPI2_SAS_EXPANDER0_FLAGS_CONFIG_IN_PROGRESS         (0x0002)
+#define MPI2_SAS_EXPANDER0_FLAGS_ROUTE_TABLE_CONFIG         (0x0001)
+
+
+/* SAS Expander Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_EXPANDER_1
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U8                                  PhysicalPort;               /* 0x08 */
+    U8                                  Reserved1;                  /* 0x09 */
+    U16                                 Reserved2;                  /* 0x0A */
+    U8                                  NumPhys;                    /* 0x0C */
+    U8                                  Phy;                        /* 0x0D */
+    U16                                 NumTableEntriesProgrammed;  /* 0x0E */
+    U8                                  ProgrammedLinkRate;         /* 0x10 */
+    U8                                  HwLinkRate;                 /* 0x11 */
+    U16                                 AttachedDevHandle;          /* 0x12 */
+    U32                                 PhyInfo;                    /* 0x14 */
+    U32                                 AttachedDeviceInfo;         /* 0x18 */
+    U16                                 ExpanderDevHandle;          /* 0x1C */
+    U8                                  ChangeCount;                /* 0x1E */
+    U8                                  NegotiatedLinkRate;         /* 0x1F */
+    U8                                  PhyIdentifier;              /* 0x20 */
+    U8                                  AttachedPhyIdentifier;      /* 0x21 */
+    U8                                  Reserved3;                  /* 0x22 */
+    U8                                  DiscoveryInfo;              /* 0x23 */
+    U32                                 AttachedPhyInfo;            /* 0x24 */
+    U8                                  ZoneGroup;                  /* 0x28 */
+    U8                                  SelfConfigStatus;           /* 0x29 */
+    U16                                 Reserved4;                  /* 0x2A */
+} MPI2_CONFIG_PAGE_EXPANDER_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_EXPANDER_1,
+  Mpi2ExpanderPage1_t, MPI2_POINTER pMpi2ExpanderPage1_t;
+
+#define MPI2_SASEXPANDER1_PAGEVERSION       (0x02)
+
+/* use MPI2_SAS_PRATE_ defines for the ProgrammedLinkRate field */
+
+/* use MPI2_SAS_HWRATE_ defines for the HwLinkRate field */
+
+/* use MPI2_SAS_PHYINFO_ for the PhyInfo field */
+
+/* see mpi2_sas.h for the MPI2_SAS_DEVICE_INFO_ defines used for the AttachedDeviceInfo field */
+
+/* use MPI2_SAS_NEG_LINK_RATE_ defines for the NegotiatedLinkRate field */
+
+/* use MPI2_SAS_APHYINFO_ defines for AttachedPhyInfo field */
+
+/* values for SAS Expander Page 1 DiscoveryInfo field */
+#define MPI2_SAS_EXPANDER1_DISCINFO_BAD_PHY_DISABLED    (0x04)
+#define MPI2_SAS_EXPANDER1_DISCINFO_LINK_STATUS_CHANGE  (0x02)
+#define MPI2_SAS_EXPANDER1_DISCINFO_NO_ROUTING_ENTRIES  (0x01)
+
+
+/****************************************************************************
+*   SAS Device Config Pages
+****************************************************************************/
+
+/* SAS Device Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_DEV_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                 /* 0x00 */
+    U16                                 Slot;                   /* 0x08 */
+    U16                                 EnclosureHandle;        /* 0x0A */
+    U64                                 SASAddress;             /* 0x0C */
+    U16                                 ParentDevHandle;        /* 0x14 */
+    U8                                  PhyNum;                 /* 0x16 */
+    U8                                  AccessStatus;           /* 0x17 */
+    U16                                 DevHandle;              /* 0x18 */
+    U8                                  AttachedPhyIdentifier;  /* 0x1A */
+    U8                                  ZoneGroup;              /* 0x1B */
+    U32                                 DeviceInfo;             /* 0x1C */
+    U16                                 Flags;                  /* 0x20 */
+    U8                                  PhysicalPort;           /* 0x22 */
+    U8                                  MaxPortConnections;     /* 0x23 */
+    U64                                 DeviceName;             /* 0x24 */
+    U8                                  PortGroups;             /* 0x2C */
+    U8                                  DmaGroup;               /* 0x2D */
+    U8                                  ControlGroup;           /* 0x2E */
+    U8                                  Reserved1;              /* 0x2F */
+    U32                                 Reserved2;              /* 0x30 */
+    U32                                 Reserved3;              /* 0x34 */
+} MPI2_CONFIG_PAGE_SAS_DEV_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_DEV_0,
+  Mpi2SasDevicePage0_t, MPI2_POINTER pMpi2SasDevicePage0_t;
+
+#define MPI2_SASDEVICE0_PAGEVERSION         (0x08)
+
+/* values for SAS Device Page 0 AccessStatus field */
+#define MPI2_SAS_DEVICE0_ASTATUS_NO_ERRORS                  (0x00)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_INIT_FAILED           (0x01)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_CAPABILITY_FAILED     (0x02)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_AFFILIATION_CONFLICT  (0x03)
+#define MPI2_SAS_DEVICE0_ASTATUS_SATA_NEEDS_INITIALIZATION  (0x04)
+#define MPI2_SAS_DEVICE0_ASTATUS_ROUTE_NOT_ADDRESSABLE      (0x05)
+#define MPI2_SAS_DEVICE0_ASTATUS_SMP_ERROR_NOT_ADDRESSABLE  (0x06)
+#define MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED             (0x07)
+/* specific values for SATA Init failures */
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_UNKNOWN                (0x10)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_AFFILIATION_CONFLICT   (0x11)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_DIAG                   (0x12)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_IDENTIFICATION         (0x13)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_CHECK_POWER            (0x14)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_PIO_SN                 (0x15)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_MDMA_SN                (0x16)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_UDMA_SN                (0x17)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_ZONING_VIOLATION       (0x18)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_NOT_ADDRESSABLE        (0x19)
+#define MPI2_SAS_DEVICE0_ASTATUS_SIF_MAX                    (0x1F)
+
+/* see mpi2_sas.h for values for SAS Device Page 0 DeviceInfo values */
+
+/* values for SAS Device Page 0 Flags field */
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_ASYNCHRONOUS_NOTIFY     (0x0400)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_SW_PRESERVE             (0x0200)
+#define MPI2_SAS_DEVICE0_FLAGS_UNSUPPORTED_DEVICE           (0x0100)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_48BIT_LBA_SUPPORTED     (0x0080)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_SMART_SUPPORTED         (0x0040)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_NCQ_SUPPORTED           (0x0020)
+#define MPI2_SAS_DEVICE0_FLAGS_SATA_FUA_SUPPORTED           (0x0010)
+#define MPI2_SAS_DEVICE0_FLAGS_PORT_SELECTOR_ATTACH         (0x0008)
+#define MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT               (0x0001)
+
+
+/* SAS Device Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_DEV_1
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                 /* 0x00 */
+    U32                                 Reserved1;              /* 0x08 */
+    U64                                 SASAddress;             /* 0x0C */
+    U32                                 Reserved2;              /* 0x14 */
+    U16                                 DevHandle;              /* 0x18 */
+    U16                                 Reserved3;              /* 0x1A */
+    U8                                  InitialRegDeviceFIS[20];/* 0x1C */
+} MPI2_CONFIG_PAGE_SAS_DEV_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_DEV_1,
+  Mpi2SasDevicePage1_t, MPI2_POINTER pMpi2SasDevicePage1_t;
+
+#define MPI2_SASDEVICE1_PAGEVERSION         (0x01)
+
+
+/****************************************************************************
+*   SAS PHY Config Pages
+****************************************************************************/
+
+/* SAS PHY Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                 /* 0x00 */
+    U16                                 OwnerDevHandle;         /* 0x08 */
+    U16                                 Reserved1;              /* 0x0A */
+    U16                                 AttachedDevHandle;      /* 0x0C */
+    U8                                  AttachedPhyIdentifier;  /* 0x0E */
+    U8                                  Reserved2;              /* 0x0F */
+    U32                                 AttachedPhyInfo;        /* 0x10 */
+    U8                                  ProgrammedLinkRate;     /* 0x14 */
+    U8                                  HwLinkRate;             /* 0x15 */
+    U8                                  ChangeCount;            /* 0x16 */
+    U8                                  Flags;                  /* 0x17 */
+    U32                                 PhyInfo;                /* 0x18 */
+    U8                                  NegotiatedLinkRate;     /* 0x1C */
+    U8                                  Reserved3;              /* 0x1D */
+    U16                                 Reserved4;              /* 0x1E */
+} MPI2_CONFIG_PAGE_SAS_PHY_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_PHY_0,
+  Mpi2SasPhyPage0_t, MPI2_POINTER pMpi2SasPhyPage0_t;
+
+#define MPI2_SASPHY0_PAGEVERSION            (0x03)
+
+/* use MPI2_SAS_PRATE_ defines for the ProgrammedLinkRate field */
+
+/* use MPI2_SAS_HWRATE_ defines for the HwLinkRate field */
+
+/* values for SAS PHY Page 0 Flags field */
+#define MPI2_SAS_PHY0_FLAGS_SGPIO_DIRECT_ATTACH_ENC             (0x01)
+
+/* use MPI2_SAS_APHYINFO_ defines for AttachedPhyInfo field */
+
+/* use MPI2_SAS_NEG_LINK_RATE_ defines for the NegotiatedLinkRate field */
+
+/* use MPI2_SAS_PHYINFO_ for the PhyInfo field */
+
+
+/* SAS PHY Page 1 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_1
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U32                                 Reserved1;                  /* 0x08 */
+    U32                                 InvalidDwordCount;          /* 0x0C */
+    U32                                 RunningDisparityErrorCount; /* 0x10 */
+    U32                                 LossDwordSynchCount;        /* 0x14 */
+    U32                                 PhyResetProblemCount;       /* 0x18 */
+} MPI2_CONFIG_PAGE_SAS_PHY_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_PHY_1,
+  Mpi2SasPhyPage1_t, MPI2_POINTER pMpi2SasPhyPage1_t;
+
+#define MPI2_SASPHY1_PAGEVERSION            (0x01)
+
+
+/****************************************************************************
+*   SAS Port Config Pages
+****************************************************************************/
+
+/* SAS Port Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PORT_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U8                                  PortNumber;                 /* 0x08 */
+    U8                                  PhysicalPort;               /* 0x09 */
+    U8                                  PortWidth;                  /* 0x0A */
+    U8                                  PhysicalPortWidth;          /* 0x0B */
+    U8                                  ZoneGroup;                  /* 0x0C */
+    U8                                  Reserved1;                  /* 0x0D */
+    U16                                 Reserved2;                  /* 0x0E */
+    U64                                 SASAddress;                 /* 0x10 */
+    U32                                 DeviceInfo;                 /* 0x18 */
+    U32                                 Reserved3;                  /* 0x1C */
+    U32                                 Reserved4;                  /* 0x20 */
+} MPI2_CONFIG_PAGE_SAS_PORT_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_PORT_0,
+  Mpi2SasPortPage0_t, MPI2_POINTER pMpi2SasPortPage0_t;
+
+#define MPI2_SASPORT0_PAGEVERSION           (0x00)
+
+/* see mpi2_sas.h for values for SAS Port Page 0 DeviceInfo values */
+
+
+/****************************************************************************
+*   SAS Enclosure Config Pages
+****************************************************************************/
+
+/* SAS Enclosure Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U32                                 Reserved1;                  /* 0x08 */
+    U64                                 EnclosureLogicalID;         /* 0x0C */
+    U16                                 Flags;                      /* 0x14 */
+    U16                                 EnclosureHandle;            /* 0x16 */
+    U16                                 NumSlots;                   /* 0x18 */
+    U16                                 StartSlot;                  /* 0x1A */
+    U16                                 Reserved2;                  /* 0x1C */
+    U16                                 SEPDevHandle;               /* 0x1E */
+    U32                                 Reserved3;                  /* 0x20 */
+    U32                                 Reserved4;                  /* 0x24 */
+} MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0,
+  Mpi2SasEnclosurePage0_t, MPI2_POINTER pMpi2SasEnclosurePage0_t;
+
+#define MPI2_SASENCLOSURE0_PAGEVERSION      (0x03)
+
+/* values for SAS Enclosure Page 0 Flags field */
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_MASK              (0x000F)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_UNKNOWN           (0x0000)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_IOC_SES           (0x0001)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_IOC_SGPIO         (0x0002)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_EXP_SGPIO         (0x0003)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_SES_ENCLOSURE     (0x0004)
+#define MPI2_SAS_ENCLS0_FLAGS_MNG_IOC_GPIO          (0x0005)
+
+
+/****************************************************************************
+*   Log Config Page
+****************************************************************************/
+
+/* Log Page 0 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhys at runtime.
+ */
+#ifndef MPI2_LOG_0_NUM_LOG_ENTRIES
+#define MPI2_LOG_0_NUM_LOG_ENTRIES          (1)
+#endif
+
+#define MPI2_LOG_0_LOG_DATA_LENGTH          (0x1C)
+
+typedef struct _MPI2_LOG_0_ENTRY
+{
+    U64         TimeStamp;                          /* 0x00 */
+    U32         Reserved1;                          /* 0x08 */
+    U16         LogSequence;                        /* 0x0C */
+    U16         LogEntryQualifier;                  /* 0x0E */
+    U8          VP_ID;                              /* 0x10 */
+    U8          VF_ID;                              /* 0x11 */
+    U16         Reserved2;                          /* 0x12 */
+    U8          LogData[MPI2_LOG_0_LOG_DATA_LENGTH];/* 0x14 */
+} MPI2_LOG_0_ENTRY, MPI2_POINTER PTR_MPI2_LOG_0_ENTRY,
+  Mpi2Log0Entry_t, MPI2_POINTER pMpi2Log0Entry_t;
+
+/* values for Log Page 0 LogEntry LogEntryQualifier field */
+#define MPI2_LOG_0_ENTRY_QUAL_ENTRY_UNUSED          (0x0000)
+#define MPI2_LOG_0_ENTRY_QUAL_POWER_ON_RESET        (0x0001)
+#define MPI2_LOG_0_ENTRY_QUAL_TIMESTAMP_UPDATE      (0x0002)
+#define MPI2_LOG_0_ENTRY_QUAL_MIN_IMPLEMENT_SPEC    (0x8000)
+#define MPI2_LOG_0_ENTRY_QUAL_MAX_IMPLEMENT_SPEC    (0xFFFF)
+
+typedef struct _MPI2_CONFIG_PAGE_LOG_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U32                                 Reserved1;                  /* 0x08 */
+    U32                                 Reserved2;                  /* 0x0C */
+    U16                                 NumLogEntries;              /* 0x10 */
+    U16                                 Reserved3;                  /* 0x12 */
+    MPI2_LOG_0_ENTRY                    LogEntry[MPI2_LOG_0_NUM_LOG_ENTRIES]; /* 0x14 */
+} MPI2_CONFIG_PAGE_LOG_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_LOG_0,
+  Mpi2LogPage0_t, MPI2_POINTER pMpi2LogPage0_t;
+
+#define MPI2_LOG_0_PAGEVERSION              (0x02)
+
+
+/****************************************************************************
+*   RAID Config Page
+****************************************************************************/
+
+/* RAID Page 0 */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhys at runtime.
+ */
+#ifndef MPI2_RAIDCONFIG0_MAX_ELEMENTS
+#define MPI2_RAIDCONFIG0_MAX_ELEMENTS       (1)
+#endif
+
+typedef struct _MPI2_RAIDCONFIG0_CONFIG_ELEMENT
+{
+    U16                     ElementFlags;               /* 0x00 */
+    U16                     VolDevHandle;               /* 0x02 */
+    U8                      HotSparePool;               /* 0x04 */
+    U8                      PhysDiskNum;                /* 0x05 */
+    U16                     PhysDiskDevHandle;          /* 0x06 */
+} MPI2_RAIDCONFIG0_CONFIG_ELEMENT,
+  MPI2_POINTER PTR_MPI2_RAIDCONFIG0_CONFIG_ELEMENT,
+  Mpi2RaidConfig0ConfigElement_t, MPI2_POINTER pMpi2RaidConfig0ConfigElement_t;
+
+/* values for the ElementFlags field */
+#define MPI2_RAIDCONFIG0_EFLAGS_MASK_ELEMENT_TYPE       (0x000F)
+#define MPI2_RAIDCONFIG0_EFLAGS_VOLUME_ELEMENT          (0x0000)
+#define MPI2_RAIDCONFIG0_EFLAGS_VOL_PHYS_DISK_ELEMENT   (0x0001)
+#define MPI2_RAIDCONFIG0_EFLAGS_HOT_SPARE_ELEMENT       (0x0002)
+#define MPI2_RAIDCONFIG0_EFLAGS_OCE_ELEMENT             (0x0003)
+
+
+typedef struct _MPI2_CONFIG_PAGE_RAID_CONFIGURATION_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U8                                  NumHotSpares;               /* 0x08 */
+    U8                                  NumPhysDisks;               /* 0x09 */
+    U8                                  NumVolumes;                 /* 0x0A */
+    U8                                  ConfigNum;                  /* 0x0B */
+    U32                                 Flags;                      /* 0x0C */
+    U8                                  ConfigGUID[24];             /* 0x10 */
+    U32                                 Reserved1;                  /* 0x28 */
+    U8                                  NumElements;                /* 0x2C */
+    U8                                  Reserved2;                  /* 0x2D */
+    U16                                 Reserved3;                  /* 0x2E */
+    MPI2_RAIDCONFIG0_CONFIG_ELEMENT     ConfigElement[MPI2_RAIDCONFIG0_MAX_ELEMENTS]; /* 0x30 */
+} MPI2_CONFIG_PAGE_RAID_CONFIGURATION_0,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_RAID_CONFIGURATION_0,
+  Mpi2RaidConfigurationPage0_t, MPI2_POINTER pMpi2RaidConfigurationPage0_t;
+
+#define MPI2_RAIDCONFIG0_PAGEVERSION            (0x00)
+
+/* values for RAID Configuration Page 0 Flags field */
+#define MPI2_RAIDCONFIG0_FLAG_FOREIGN_CONFIG        (0x00000001)
+
+
+/****************************************************************************
+*   Driver Persistent Mapping Config Pages
+****************************************************************************/
+
+/* Driver Persistent Mapping Page 0 */
+
+typedef struct _MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY
+{
+    U64                                 PhysicalIdentifier;         /* 0x00 */
+    U16                                 MappingInformation;         /* 0x08 */
+    U16                                 DeviceIndex;                /* 0x0A */
+    U32                                 PhysicalBitsMapping;        /* 0x0C */
+    U32                                 Reserved1;                  /* 0x10 */
+} MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY,
+  Mpi2DriverMap0Entry_t, MPI2_POINTER pMpi2DriverMap0Entry_t;
+
+typedef struct _MPI2_CONFIG_PAGE_DRIVER_MAPPING_0
+{
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    MPI2_CONFIG_PAGE_DRIVER_MAP0_ENTRY  Entry;                      /* 0x08 */
+} MPI2_CONFIG_PAGE_DRIVER_MAPPING_0,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_DRIVER_MAPPING_0,
+  Mpi2DriverMappingPage0_t, MPI2_POINTER pMpi2DriverMappingPage0_t;
+
+#define MPI2_DRIVERMAPPING0_PAGEVERSION         (0x00)
+
+/* values for Driver Persistent Mapping Page 0 MappingInformation field */
+#define MPI2_DRVMAP0_MAPINFO_SLOT_MASK              (0x07F0)
+#define MPI2_DRVMAP0_MAPINFO_SLOT_SHIFT             (4)
+#define MPI2_DRVMAP0_MAPINFO_MISSING_MASK           (0x000F)
+
+
+#endif
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
--- a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,294 @@
+ ==============================
+ Fusion-MPT MPI 2.0 Header File Change History
+ ==============================
+
+ Copyright (c) 2000-2009 LSI Corporation.
+
+ ---------------------------------------
+ Header Set Release Version:    02.00.11
+ Header Set Release Date:       01-19-09
+ ---------------------------------------
+
+ Filename               Current version     Prior version
+ ----------             ---------------     -------------
+ mpi2.h                 02.00.11            02.00.10
+ mpi2_cnfg.h            02.00.10            02.00.09
+ mpi2_init.h            02.00.06            02.00.06
+ mpi2_ioc.h             02.00.10            02.00.09
+ mpi2_raid.h            02.00.03            02.00.03
+ mpi2_sas.h             02.00.02            02.00.02
+ mpi2_targ.h            02.00.03            02.00.03
+ mpi2_tool.h            02.00.02            02.00.02
+ mpi2_type.h            02.00.00            02.00.00
+ mpi2_history.txt       02.00.11            02.00.10
+
+
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+
+mpi2.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  06-26-07  02.00.02  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  08-31-07  02.00.03  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Moved ReplyPostHostIndex register to offset 0x6C of the
+ *                      MPI2_SYSTEM_INTERFACE_REGS and modified the define for
+ *                      MPI2_REPLY_POST_HOST_INDEX_OFFSET.
+ *                      Added union of request descriptors.
+ *                      Added union of reply descriptors.
+ *  10-31-07  02.00.04  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Added define for MPI2_VERSION_02_00.
+ *                      Fixed the size of the FunctionDependent5 field in the
+ *                      MPI2_DEFAULT_REPLY structure.
+ *  12-18-07  02.00.05  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Removed the MPI-defined Fault Codes and extended the
+ *                      product specific codes up to 0xEFFF.
+ *                      Added a sixth key value for the WriteSequence register
+ *                      and changed the flush value to 0x0.
+ *                      Added message function codes for Diagnostic Buffer Post
+ *                      and Diagnsotic Release.
+ *                      New IOCStatus define: MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED
+ *                      Moved MPI2_VERSION_UNION from mpi2_ioc.h.
+ *  02-29-08  02.00.06  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  03-03-08  02.00.07  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  05-21-08  02.00.08  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Added #defines for marking a reply descriptor as unused.
+ *  06-27-08  02.00.09  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  10-02-08  02.00.10  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Moved LUN field defines from mpi2_init.h.
+ *  01-19-09  02.00.11  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  --------------------------------------------------------------------------
+
+mpi2_cnfg.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  Added defines for SAS IO Unit Page 2 PhyFlags.
+ *                      Added Manufacturing Page 11.
+ *                      Added MPI2_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE
+ *                      define.
+ *  06-26-07  02.00.02  Adding generic structure for product-specific
+ *                      Manufacturing pages: MPI2_CONFIG_PAGE_MANUFACTURING_PS.
+ *                      Rework of BIOS Page 2 configuration page.
+ *                      Fixed MPI2_BIOSPAGE2_BOOT_DEVICE to be a union of the
+ *                      forms.
+ *                      Added configuration pages IOC Page 8 and Driver
+ *                      Persistent Mapping Page 0.
+ *  08-31-07  02.00.03  Modified configuration pages dealing with Integrated
+ *                      RAID (Manufacturing Page 4, RAID Volume Pages 0 and 1,
+ *                      RAID Physical Disk Pages 0 and 1, RAID Configuration
+ *                      Page 0).
+ *                      Added new value for AccessStatus field of SAS Device
+ *                      Page 0 (_SATA_NEEDS_INITIALIZATION).
+ *  10-31-07  02.00.04  Added missing SEPDevHandle field to
+ *                      MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
+ *  12-18-07  02.00.05  Modified IO Unit Page 0 to use 32-bit version fields for
+ *                      NVDATA.
+ *                      Modified IOC Page 7 to use masks and added field for
+ *                      SASBroadcastPrimitiveMasks.
+ *                      Added MPI2_CONFIG_PAGE_BIOS_4.
+ *                      Added MPI2_CONFIG_PAGE_LOG_0.
+ *  02-29-08  02.00.06  Modified various names to make them 32-character unique.
+ *                      Added SAS Device IDs.
+ *                      Updated Integrated RAID configuration pages including
+ *                      Manufacturing Page 4, IOC Page 6, and RAID Configuration
+ *                      Page 0.
+ *  05-21-08  02.00.07  Added define MPI2_MANPAGE4_MIX_SSD_SAS_SATA.
+ *                      Added define MPI2_MANPAGE4_PHYSDISK_128MB_COERCION.
+ *                      Fixed define MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING.
+ *                      Added missing MaxNumRoutedSasAddresses field to
+ *                      MPI2_CONFIG_PAGE_EXPANDER_0.
+ *                      Added SAS Port Page 0.
+ *                      Modified structure layout for
+ *                      MPI2_CONFIG_PAGE_DRIVER_MAPPING_0.
+ *  06-27-08  02.00.08  Changed MPI2_CONFIG_PAGE_RD_PDISK_1 to use
+ *                      MPI2_RAID_PHYS_DISK1_PATH_MAX to size the array.
+ *  10-02-08  02.00.09  Changed MPI2_RAID_PGAD_CONFIGNUM_MASK from 0x0000FFFF
+ *                      to 0x000000FF.
+ *                      Added two new values for the Physical Disk Coercion Size
+ *                      bits in the Flags field of Manufacturing Page 4.
+ *                      Added product-specific Manufacturing pages 16 to 31.
+ *                      Modified Flags bits for controlling write cache on SATA
+ *                      drives in IO Unit Page 1.
+ *                      Added new bit to AdditionalControlFlags of SAS IO Unit
+ *                      Page 1 to control Invalid Topology Correction.
+ *                      Added SupportedPhysDisks field to RAID Volume Page 1 and
+ *                      added related defines.
+ *                      Added additional defines for RAID Volume Page 0
+ *                      VolumeStatusFlags field.
+ *                      Modified meaning of RAID Volume Page 0 VolumeSettings
+ *                      define for auto-configure of hot-swap drives.
+ *                      Added PhysDiskAttributes field (and related defines) to
+ *                      RAID Physical Disk Page 0.
+ *                      Added MPI2_SAS_PHYINFO_PHY_VACANT define.
+ *                      Added three new DiscoveryStatus bits for SAS IO Unit
+ *                      Page 0 and SAS Expander Page 0.
+ *                      Removed multiplexing information from SAS IO Unit pages.
+ *                      Added BootDeviceWaitTime field to SAS IO Unit Page 4.
+ *                      Removed Zone Address Resolved bit from PhyInfo and from
+ *                      Expander Page 0 Flags field.
+ *                      Added two new AccessStatus values to SAS Device Page 0
+ *                      for indicating routing problems. Added 3 reserved words
+ *                      to this page.
+ *  01-19-09  02.00.10  Fixed defines for GPIOVal field of IO Unit Page 3.
+ *                      Inserted missing reserved field into structure for IOC
+ *                      Page 6.
+ *                      Added more pending task bits to RAID Volume Page 0
+ *                      VolumeStatusFlags defines.
+ *                      Added MPI2_PHYSDISK0_STATUS_FLAG_NOT_CERTIFIED define.
+ *                      Added a new DiscoveryStatus bit for SAS IO Unit Page 0
+ *                      and SAS Expander Page 0 to flag a downstream initiator
+ *                      when in simplified routing mode.
+ *                      Removed SATA Init Failure defines for DiscoveryStatus
+ *                      fields of SAS IO Unit Page 0 and SAS Expander Page 0.
+ *                      Added MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED define.
+ *                      Added PortGroups, DmaGroup, and ControlGroup fields to
+ *                      SAS Device Page 0.
+ *  --------------------------------------------------------------------------
+
+mpi2_init.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  10-31-07  02.00.01  Fixed name for pMpi2SCSITaskManagementRequest_t.
+ *  12-18-07  02.00.02  Modified Task Management Target Reset Method defines.
+ *  02-29-08  02.00.03  Added Query Task Set and Query Unit Attention.
+ *  03-03-08  02.00.04  Fixed name of struct _MPI2_SCSI_TASK_MANAGE_REPLY.
+ *  05-21-08  02.00.05  Fixed typo in name of Mpi2SepRequest_t.
+ *  10-02-08  02.00.06  Removed Untagged and No Disconnect values from SCSI IO
+ *                      Control field Task Attribute flags.
+ *                      Moved LUN field defines to mpi2.h becasue they are
+ *                      common to many structures.
+ *  --------------------------------------------------------------------------
+
+mpi2_ioc.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  In IOCFacts Reply structure, renamed MaxDevices to
+ *                      MaxTargets.
+ *                      Added TotalImageSize field to FWDownload Request.
+ *                      Added reserved words to FWUpload Request.
+ *  06-26-07  02.00.02  Added IR Configuration Change List Event.
+ *  08-31-07  02.00.03  Removed SystemReplyQueueDepth field from the IOCInit
+ *                      request and replaced it with
+ *                      ReplyDescriptorPostQueueDepth and ReplyFreeQueueDepth.
+ *                      Replaced the MinReplyQueueDepth field of the IOCFacts
+ *                      reply with MaxReplyDescriptorPostQueueDepth.
+ *                      Added MPI2_RDPQ_DEPTH_MIN define to specify the minimum
+ *                      depth for the Reply Descriptor Post Queue.
+ *                      Added SASAddress field to Initiator Device Table
+ *                      Overflow Event data.
+ *  10-31-07  02.00.04  Added ReasonCode MPI2_EVENT_SAS_INIT_RC_NOT_RESPONDING
+ *                      for SAS Initiator Device Status Change Event data.
+ *                      Modified Reason Code defines for SAS Topology Change
+ *                      List Event data, including adding a bit for PHY Vacant
+ *                      status, and adding a mask for the Reason Code.
+ *                      Added define for
+ *                      MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING.
+ *                      Added define for MPI2_EXT_IMAGE_TYPE_MEGARAID.
+ *  12-18-07  02.00.05  Added Boot Status defines for the IOCExceptions field of
+ *                      the IOCFacts Reply.
+ *                      Removed MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER define.
+ *                      Moved MPI2_VERSION_UNION to mpi2.h.
+ *                      Changed MPI2_EVENT_NOTIFICATION_REQUEST to use masks
+ *                      instead of enables, and added SASBroadcastPrimitiveMasks
+ *                      field.
+ *                      Added Log Entry Added Event and related structure.
+ *  02-29-08  02.00.06  Added define MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID.
+ *                      Removed define MPI2_IOCFACTS_PROTOCOL_SMP_TARGET.
+ *                      Added MaxVolumes and MaxPersistentEntries fields to
+ *                      IOCFacts reply.
+ *                      Added ProtocalFlags and IOCCapabilities fields to
+ *                      MPI2_FW_IMAGE_HEADER.
+ *                      Removed MPI2_PORTENABLE_FLAGS_ENABLE_SINGLE_PORT.
+ *  03-03-08  02.00.07  Fixed MPI2_FW_IMAGE_HEADER by changing Reserved26 to
+ *                      a U16 (from a U32).
+ *                      Removed extra 's' from EventMasks name.
+ *  06-27-08  02.00.08  Fixed an offset in a comment.
+ *  10-02-08  02.00.09  Removed SystemReplyFrameSize from MPI2_IOC_INIT_REQUEST.
+ *                      Removed CurReplyFrameSize from MPI2_IOC_FACTS_REPLY and
+ *                      renamed MinReplyFrameSize to ReplyFrameSize.
+ *                      Added MPI2_IOCFACTS_EXCEPT_IR_FOREIGN_CONFIG_MAX.
+ *                      Added two new RAIDOperation values for Integrated RAID
+ *                      Operations Status Event data.
+ *                      Added four new IR Configuration Change List Event data
+ *                      ReasonCode values.
+ *                      Added two new ReasonCode defines for SAS Device Status
+ *                      Change Event data.
+ *                      Added three new DiscoveryStatus bits for the SAS
+ *                      Discovery event data.
+ *                      Added Multiplexing Status Change bit to the PhyStatus
+ *                      field of the SAS Topology Change List event data.
+ *                      Removed define for MPI2_INIT_IMAGE_BOOTFLAGS_XMEMCOPY.
+ *                      BootFlags are now product-specific.
+ *                      Added defines for the indivdual signature bytes
+ *                      for MPI2_INIT_IMAGE_FOOTER.
+ *  01-19-09  02.00.10  Added MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY define.
+ *                      Added MPI2_EVENT_SAS_DISC_DS_DOWNSTREAM_INITIATOR
+ *                      define.
+ *                      Added MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE
+ *                      define.
+ *                      Removed MPI2_EVENT_SAS_DISC_DS_SATA_INIT_FAILURE define.
+ *  --------------------------------------------------------------------------
+
+mpi2_raid.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  08-31-07  02.00.01  Modifications to RAID Action request and reply,
+ *                      including the Actions and ActionData.
+ *  02-29-08  02.00.02  Added MPI2_RAID_ACTION_ADATA_DISABL_FULL_REBUILD.
+ *  05-21-08  02.00.03  Added MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS so that
+ *                      the PhysDisk array in MPI2_RAID_VOLUME_CREATION_STRUCT
+ *                      can be sized by the build environment.
+ *  --------------------------------------------------------------------------
+
+mpi2_sas.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-26-07  02.00.01  Added Clear All Persistent Operation to SAS IO Unit
+ *                      Control Request.
+ *  10-02-08  02.00.02  Added Set IOC Parameter Operation to SAS IO Unit Control
+ *                      Request.
+ *  --------------------------------------------------------------------------
+
+mpi2_targ.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  08-31-07  02.00.01  Added Command Buffer Data Location Address Space bits to
+ *                      BufferPostFlags field of CommandBufferPostBase Request.
+ *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  10-02-08  02.00.03  Removed NextCmdBufferOffset from
+ *                      MPI2_TARGET_CMD_BUF_POST_BASE_REQUEST.
+ *                      Target Status Send Request only takes a single SGE for
+ *                      response data.
+ *  --------------------------------------------------------------------------
+
+mpi2_tool.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  12-18-07  02.00.01  Added Diagnostic Buffer Post and Diagnostic Release
+ *                      structures and defines.
+ *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  --------------------------------------------------------------------------
+
+mpi2_type.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  --------------------------------------------------------------------------
+
+mpi2_history.txt         Parts list history
+
+Filename     02.00.11  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06
+----------   --------  --------  --------  --------  --------  --------
+mpi2.h       02.00.11  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06
+mpi2_cnfg.h  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06  02.00.06
+mpi2_init.h  02.00.06  02.00.06  02.00.05  02.00.05  02.00.04  02.00.03
+mpi2_ioc.h   02.00.10  02.00.09  02.00.08  02.00.07  02.00.07  02.00.06
+mpi2_raid.h  02.00.03  02.00.03  02.00.03  02.00.03  02.00.02  02.00.02
+mpi2_sas.h   02.00.02  02.00.02  02.00.01  02.00.01  02.00.01  02.00.01
+mpi2_targ.h  02.00.03  02.00.03  02.00.02  02.00.02  02.00.02  02.00.02
+mpi2_tool.h  02.00.02  02.00.02  02.00.02  02.00.02  02.00.02  02.00.02
+mpi2_type.h  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
+
+Filename     02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+----------   --------  --------  --------  --------  --------  --------
+mpi2.h       02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+mpi2_cnfg.h  02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+mpi2_init.h  02.00.02  02.00.01  02.00.00  02.00.00  02.00.00  02.00.00
+mpi2_ioc.h   02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+mpi2_raid.h  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00  02.00.00
+mpi2_sas.h   02.00.01  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00
+mpi2_targ.h  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00  02.00.00
+mpi2_tool.h  02.00.01  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
+mpi2_type.h  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_init.h b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_init.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_init.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,420 @@
+/*
+ *  Copyright (c) 2000-2008 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_init.h
+ *          Title:  MPI SCSI initiator mode messages and structures
+ *  Creation Date:  June 23, 2006
+ *
+ *    mpi2_init.h Version:  02.00.06
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  10-31-07  02.00.01  Fixed name for pMpi2SCSITaskManagementRequest_t.
+ *  12-18-07  02.00.02  Modified Task Management Target Reset Method defines.
+ *  02-29-08  02.00.03  Added Query Task Set and Query Unit Attention.
+ *  03-03-08  02.00.04  Fixed name of struct _MPI2_SCSI_TASK_MANAGE_REPLY.
+ *  05-21-08  02.00.05  Fixed typo in name of Mpi2SepRequest_t.
+ *  10-02-08  02.00.06  Removed Untagged and No Disconnect values from SCSI IO
+ *                      Control field Task Attribute flags.
+ *                      Moved LUN field defines to mpi2.h becasue they are
+ *                      common to many structures.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_INIT_H
+#define MPI2_INIT_H
+
+/*****************************************************************************
+*
+*               SCSI Initiator Messages
+*
+*****************************************************************************/
+
+/****************************************************************************
+*  SCSI IO messages and associated structures
+****************************************************************************/
+
+typedef struct
+{
+    U8                      CDB[20];                    /* 0x00 */
+    U32                     PrimaryReferenceTag;        /* 0x14 */
+    U16                     PrimaryApplicationTag;      /* 0x18 */
+    U16                     PrimaryApplicationTagMask;  /* 0x1A */
+    U32                     TransferLength;             /* 0x1C */
+} MPI2_SCSI_IO_CDB_EEDP32, MPI2_POINTER PTR_MPI2_SCSI_IO_CDB_EEDP32,
+  Mpi2ScsiIoCdbEedp32_t, MPI2_POINTER pMpi2ScsiIoCdbEedp32_t;
+
+/* TBD: I don't think this is needed for MPI2/Gen2 */
+#if 0
+typedef struct
+{
+    U8                      CDB[16];                    /* 0x00 */
+    U32                     DataLength;                 /* 0x10 */
+    U32                     PrimaryReferenceTag;        /* 0x14 */
+    U16                     PrimaryApplicationTag;      /* 0x18 */
+    U16                     PrimaryApplicationTagMask;  /* 0x1A */
+    U32                     TransferLength;             /* 0x1C */
+} MPI2_SCSI_IO32_CDB_EEDP16, MPI2_POINTER PTR_MPI2_SCSI_IO32_CDB_EEDP16,
+  Mpi2ScsiIo32CdbEedp16_t, MPI2_POINTER pMpi2ScsiIo32CdbEedp16_t;
+#endif
+
+typedef union
+{
+    U8                      CDB32[32];
+    MPI2_SCSI_IO_CDB_EEDP32 EEDP32;
+    MPI2_SGE_SIMPLE_UNION   SGE;
+} MPI2_SCSI_IO_CDB_UNION, MPI2_POINTER PTR_MPI2_SCSI_IO_CDB_UNION,
+  Mpi2ScsiIoCdb_t, MPI2_POINTER pMpi2ScsiIoCdb_t;
+
+/* SCSI IO Request Message */
+typedef struct _MPI2_SCSI_IO_REQUEST
+{
+    U16                     DevHandle;                      /* 0x00 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved1;                      /* 0x04 */
+    U8                      Reserved2;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved3;                      /* 0x0A */
+    U32                     SenseBufferLowAddress;          /* 0x0C */
+    U16                     SGLFlags;                       /* 0x10 */
+    U8                      SenseBufferLength;              /* 0x12 */
+    U8                      Reserved4;                      /* 0x13 */
+    U8                      SGLOffset0;                     /* 0x14 */
+    U8                      SGLOffset1;                     /* 0x15 */
+    U8                      SGLOffset2;                     /* 0x16 */
+    U8                      SGLOffset3;                     /* 0x17 */
+    U32                     SkipCount;                      /* 0x18 */
+    U32                     DataLength;                     /* 0x1C */
+    U32                     BidirectionalDataLength;        /* 0x20 */
+    U16                     IoFlags;                        /* 0x24 */
+    U16                     EEDPFlags;                      /* 0x26 */
+    U32                     EEDPBlockSize;                  /* 0x28 */
+    U32                     SecondaryReferenceTag;          /* 0x2C */
+    U16                     SecondaryApplicationTag;        /* 0x30 */
+    U16                     ApplicationTagTranslationMask;  /* 0x32 */
+    U8                      LUN[8];                         /* 0x34 */
+    U32                     Control;                        /* 0x3C */
+    MPI2_SCSI_IO_CDB_UNION  CDB;                            /* 0x40 */
+    MPI2_SGE_IO_UNION       SGL;                            /* 0x60 */
+} MPI2_SCSI_IO_REQUEST, MPI2_POINTER PTR_MPI2_SCSI_IO_REQUEST,
+  Mpi2SCSIIORequest_t, MPI2_POINTER pMpi2SCSIIORequest_t;
+
+/* SCSI IO MsgFlags bits */
+
+/* MsgFlags for SenseBufferAddressSpace */
+#define MPI2_SCSIIO_MSGFLAGS_MASK_SENSE_ADDR        (0x0C)
+#define MPI2_SCSIIO_MSGFLAGS_SYSTEM_SENSE_ADDR      (0x00)
+#define MPI2_SCSIIO_MSGFLAGS_IOCDDR_SENSE_ADDR      (0x04)
+#define MPI2_SCSIIO_MSGFLAGS_IOCPLB_SENSE_ADDR      (0x08)
+#define MPI2_SCSIIO_MSGFLAGS_IOCPLBNTA_SENSE_ADDR   (0x0C)
+
+/* SCSI IO SGLFlags bits */
+
+/* base values for Data Location Address Space */
+#define MPI2_SCSIIO_SGLFLAGS_ADDR_MASK              (0x0C)
+#define MPI2_SCSIIO_SGLFLAGS_SYSTEM_ADDR            (0x00)
+#define MPI2_SCSIIO_SGLFLAGS_IOCDDR_ADDR            (0x04)
+#define MPI2_SCSIIO_SGLFLAGS_IOCPLB_ADDR            (0x08)
+#define MPI2_SCSIIO_SGLFLAGS_IOCPLBNTA_ADDR         (0x0C)
+
+/* base values for Type */
+#define MPI2_SCSIIO_SGLFLAGS_TYPE_MASK              (0x03)
+#define MPI2_SCSIIO_SGLFLAGS_TYPE_MPI               (0x00)
+#define MPI2_SCSIIO_SGLFLAGS_TYPE_IEEE32            (0x01)
+#define MPI2_SCSIIO_SGLFLAGS_TYPE_IEEE64            (0x02)
+
+/* shift values for each sub-field */
+#define MPI2_SCSIIO_SGLFLAGS_SGL3_SHIFT             (12)
+#define MPI2_SCSIIO_SGLFLAGS_SGL2_SHIFT             (8)
+#define MPI2_SCSIIO_SGLFLAGS_SGL1_SHIFT             (4)
+#define MPI2_SCSIIO_SGLFLAGS_SGL0_SHIFT             (0)
+
+/* SCSI IO IoFlags bits */
+
+/* Large CDB Address Space */
+#define MPI2_SCSIIO_CDB_ADDR_MASK                   (0x6000)
+#define MPI2_SCSIIO_CDB_ADDR_SYSTEM                 (0x0000)
+#define MPI2_SCSIIO_CDB_ADDR_IOCDDR                 (0x2000)
+#define MPI2_SCSIIO_CDB_ADDR_IOCPLB                 (0x4000)
+#define MPI2_SCSIIO_CDB_ADDR_IOCPLBNTA              (0x6000)
+
+#define MPI2_SCSIIO_IOFLAGS_LARGE_CDB               (0x1000)
+#define MPI2_SCSIIO_IOFLAGS_BIDIRECTIONAL           (0x0800)
+#define MPI2_SCSIIO_IOFLAGS_MULTICAST               (0x0400)
+#define MPI2_SCSIIO_IOFLAGS_CMD_DETERMINES_DATA_DIR (0x0200)
+#define MPI2_SCSIIO_IOFLAGS_CDBLENGTH_MASK          (0x01FF)
+
+/* SCSI IO EEDPFlags bits */
+
+#define MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG        (0x8000)
+#define MPI2_SCSIIO_EEDPFLAGS_INC_SEC_REFTAG        (0x4000)
+#define MPI2_SCSIIO_EEDPFLAGS_INC_PRI_APPTAG        (0x2000)
+#define MPI2_SCSIIO_EEDPFLAGS_INC_SEC_APPTAG        (0x1000)
+
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG          (0x0400)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG          (0x0200)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD           (0x0100)
+
+#define MPI2_SCSIIO_EEDPFLAGS_PASSTHRU_REFTAG       (0x0008)
+
+#define MPI2_SCSIIO_EEDPFLAGS_MASK_OP               (0x0007)
+#define MPI2_SCSIIO_EEDPFLAGS_NOOP_OP               (0x0000)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_OP              (0x0001)
+#define MPI2_SCSIIO_EEDPFLAGS_STRIP_OP              (0x0002)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP       (0x0003)
+#define MPI2_SCSIIO_EEDPFLAGS_INSERT_OP             (0x0004)
+#define MPI2_SCSIIO_EEDPFLAGS_REPLACE_OP            (0x0006)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_REGEN_OP        (0x0007)
+
+/* SCSI IO LUN fields: use MPI2_LUN_ from mpi2.h */
+
+/* SCSI IO Control bits */
+#define MPI2_SCSIIO_CONTROL_ADDCDBLEN_MASK      (0xFC000000)
+#define MPI2_SCSIIO_CONTROL_ADDCDBLEN_SHIFT     (26)
+
+#define MPI2_SCSIIO_CONTROL_DATADIRECTION_MASK  (0x03000000)
+#define MPI2_SCSIIO_CONTROL_NODATATRANSFER      (0x00000000)
+#define MPI2_SCSIIO_CONTROL_WRITE               (0x01000000)
+#define MPI2_SCSIIO_CONTROL_READ                (0x02000000)
+#define MPI2_SCSIIO_CONTROL_BIDIRECTIONAL       (0x03000000)
+
+#define MPI2_SCSIIO_CONTROL_TASKPRI_MASK        (0x00007800)
+#define MPI2_SCSIIO_CONTROL_TASKPRI_SHIFT       (11)
+
+#define MPI2_SCSIIO_CONTROL_TASKATTRIBUTE_MASK  (0x00000700)
+#define MPI2_SCSIIO_CONTROL_SIMPLEQ             (0x00000000)
+#define MPI2_SCSIIO_CONTROL_HEADOFQ             (0x00000100)
+#define MPI2_SCSIIO_CONTROL_ORDEREDQ            (0x00000200)
+#define MPI2_SCSIIO_CONTROL_ACAQ                (0x00000400)
+
+#define MPI2_SCSIIO_CONTROL_TLR_MASK            (0x000000C0)
+#define MPI2_SCSIIO_CONTROL_NO_TLR              (0x00000000)
+#define MPI2_SCSIIO_CONTROL_TLR_ON              (0x00000040)
+#define MPI2_SCSIIO_CONTROL_TLR_OFF             (0x00000080)
+
+
+/* SCSI IO Error Reply Message */
+typedef struct _MPI2_SCSI_IO_REPLY
+{
+    U16                     DevHandle;                      /* 0x00 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved1;                      /* 0x04 */
+    U8                      Reserved2;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved3;                      /* 0x0A */
+    U8                      SCSIStatus;                     /* 0x0C */
+    U8                      SCSIState;                      /* 0x0D */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+    U32                     TransferCount;                  /* 0x14 */
+    U32                     SenseCount;                     /* 0x18 */
+    U32                     ResponseInfo;                   /* 0x1C */
+    U16                     TaskTag;                        /* 0x20 */
+    U16                     Reserved4;                      /* 0x22 */
+    U32                     BidirectionalTransferCount;     /* 0x24 */
+    U32                     Reserved5;                      /* 0x28 */
+    U32                     Reserved6;                      /* 0x2C */
+} MPI2_SCSI_IO_REPLY, MPI2_POINTER PTR_MPI2_SCSI_IO_REPLY,
+  Mpi2SCSIIOReply_t, MPI2_POINTER pMpi2SCSIIOReply_t;
+
+/* SCSI IO Reply SCSIStatus values (SAM-4 status codes) */
+
+#define MPI2_SCSI_STATUS_GOOD                   (0x00)
+#define MPI2_SCSI_STATUS_CHECK_CONDITION        (0x02)
+#define MPI2_SCSI_STATUS_CONDITION_MET          (0x04)
+#define MPI2_SCSI_STATUS_BUSY                   (0x08)
+#define MPI2_SCSI_STATUS_INTERMEDIATE           (0x10)
+#define MPI2_SCSI_STATUS_INTERMEDIATE_CONDMET   (0x14)
+#define MPI2_SCSI_STATUS_RESERVATION_CONFLICT   (0x18)
+#define MPI2_SCSI_STATUS_COMMAND_TERMINATED     (0x22) /* obsolete */
+#define MPI2_SCSI_STATUS_TASK_SET_FULL          (0x28)
+#define MPI2_SCSI_STATUS_ACA_ACTIVE             (0x30)
+#define MPI2_SCSI_STATUS_TASK_ABORTED           (0x40)
+
+/* SCSI IO Reply SCSIState flags */
+
+#define MPI2_SCSI_STATE_RESPONSE_INFO_VALID     (0x10)
+#define MPI2_SCSI_STATE_TERMINATED              (0x08)
+#define MPI2_SCSI_STATE_NO_SCSI_STATUS          (0x04)
+#define MPI2_SCSI_STATE_AUTOSENSE_FAILED        (0x02)
+#define MPI2_SCSI_STATE_AUTOSENSE_VALID         (0x01)
+
+#define MPI2_SCSI_TASKTAG_UNKNOWN               (0xFFFF)
+
+
+/****************************************************************************
+*  SCSI Task Management messages
+****************************************************************************/
+
+/* SCSI Task Management Request Message */
+typedef struct _MPI2_SCSI_TASK_MANAGE_REQUEST
+{
+    U16                     DevHandle;                      /* 0x00 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U8                      Reserved1;                      /* 0x04 */
+    U8                      TaskType;                       /* 0x05 */
+    U8                      Reserved2;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved3;                      /* 0x0A */
+    U8                      LUN[8];                         /* 0x0C */
+    U32                     Reserved4[7];                   /* 0x14 */
+    U16                     TaskMID;                        /* 0x30 */
+    U16                     Reserved5;                      /* 0x32 */
+} MPI2_SCSI_TASK_MANAGE_REQUEST,
+  MPI2_POINTER PTR_MPI2_SCSI_TASK_MANAGE_REQUEST,
+  Mpi2SCSITaskManagementRequest_t,
+  MPI2_POINTER pMpi2SCSITaskManagementRequest_t;
+
+/* TaskType values */
+
+#define MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK           (0x01)
+#define MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET        (0x02)
+#define MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET         (0x03)
+#define MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET   (0x05)
+#define MPI2_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET       (0x06)
+#define MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK           (0x07)
+#define MPI2_SCSITASKMGMT_TASKTYPE_CLR_ACA              (0x08)
+#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_TASK_SET         (0x09)
+#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_UNIT_ATTENTION   (0x0A)
+
+/* MsgFlags bits */
+
+#define MPI2_SCSITASKMGMT_MSGFLAGS_MASK_TARGET_RESET    (0x18)
+#define MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET           (0x00)
+#define MPI2_SCSITASKMGMT_MSGFLAGS_NEXUS_RESET_SRST     (0x08)
+#define MPI2_SCSITASKMGMT_MSGFLAGS_SAS_HARD_LINK_RESET  (0x10)
+
+#define MPI2_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU  (0x01)
+
+
+
+/* SCSI Task Management Reply Message */
+typedef struct _MPI2_SCSI_TASK_MANAGE_REPLY
+{
+    U16                     DevHandle;                      /* 0x00 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U8                      ResponseCode;                   /* 0x04 */
+    U8                      TaskType;                       /* 0x05 */
+    U8                      Reserved1;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved2;                      /* 0x0A */
+    U16                     Reserved3;                      /* 0x0C */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+    U32                     TerminationCount;               /* 0x14 */
+} MPI2_SCSI_TASK_MANAGE_REPLY,
+  MPI2_POINTER PTR_MPI2_SCSI_TASK_MANAGE_REPLY,
+  Mpi2SCSITaskManagementReply_t, MPI2_POINTER pMpi2SCSIManagementReply_t;
+
+/* ResponseCode values */
+
+#define MPI2_SCSITASKMGMT_RSP_TM_COMPLETE               (0x00)
+#define MPI2_SCSITASKMGMT_RSP_INVALID_FRAME             (0x02)
+#define MPI2_SCSITASKMGMT_RSP_TM_NOT_SUPPORTED          (0x04)
+#define MPI2_SCSITASKMGMT_RSP_TM_FAILED                 (0x05)
+#define MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED              (0x08)
+#define MPI2_SCSITASKMGMT_RSP_TM_INVALID_LUN            (0x09)
+#define MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC          (0x80)
+
+
+/****************************************************************************
+*  SCSI Enclosure Processor messages
+****************************************************************************/
+
+/* SCSI Enclosure Processor Request Message */
+typedef struct _MPI2_SEP_REQUEST
+{
+    U16                     DevHandle;          /* 0x00 */
+    U8                      ChainOffset;        /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U8                      Action;             /* 0x04 */
+    U8                      Flags;              /* 0x05 */
+    U8                      Reserved1;          /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved2;          /* 0x0A */
+    U32                     SlotStatus;         /* 0x0C */
+    U32                     Reserved3;          /* 0x10 */
+    U32                     Reserved4;          /* 0x14 */
+    U32                     Reserved5;          /* 0x18 */
+    U16                     Slot;               /* 0x1C */
+    U16                     EnclosureHandle;    /* 0x1E */
+} MPI2_SEP_REQUEST, MPI2_POINTER PTR_MPI2_SEP_REQUEST,
+  Mpi2SepRequest_t, MPI2_POINTER pMpi2SepRequest_t;
+
+/* Action defines */
+#define MPI2_SEP_REQ_ACTION_WRITE_STATUS                (0x00)
+#define MPI2_SEP_REQ_ACTION_READ_STATUS                 (0x01)
+
+/* Flags defines */
+#define MPI2_SEP_REQ_FLAGS_DEVHANDLE_ADDRESS            (0x00)
+#define MPI2_SEP_REQ_FLAGS_ENCLOSURE_SLOT_ADDRESS       (0x01)
+
+/* SlotStatus defines */
+#define MPI2_SEP_REQ_SLOTSTATUS_REQUEST_REMOVE          (0x00040000)
+#define MPI2_SEP_REQ_SLOTSTATUS_IDENTIFY_REQUEST        (0x00020000)
+#define MPI2_SEP_REQ_SLOTSTATUS_REBUILD_STOPPED         (0x00000200)
+#define MPI2_SEP_REQ_SLOTSTATUS_HOT_SPARE               (0x00000100)
+#define MPI2_SEP_REQ_SLOTSTATUS_UNCONFIGURED            (0x00000080)
+#define MPI2_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT         (0x00000040)
+#define MPI2_SEP_REQ_SLOTSTATUS_DEV_REBUILDING          (0x00000004)
+#define MPI2_SEP_REQ_SLOTSTATUS_DEV_FAULTY              (0x00000002)
+#define MPI2_SEP_REQ_SLOTSTATUS_NO_ERROR                (0x00000001)
+
+
+/* SCSI Enclosure Processor Reply Message */
+typedef struct _MPI2_SEP_REPLY
+{
+    U16                     DevHandle;          /* 0x00 */
+    U8                      MsgLength;          /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U8                      Action;             /* 0x04 */
+    U8                      Flags;              /* 0x05 */
+    U8                      Reserved1;          /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved2;          /* 0x0A */
+    U16                     Reserved3;          /* 0x0C */
+    U16                     IOCStatus;          /* 0x0E */
+    U32                     IOCLogInfo;         /* 0x10 */
+    U32                     SlotStatus;         /* 0x14 */
+    U32                     Reserved4;          /* 0x18 */
+    U16                     Slot;               /* 0x1C */
+    U16                     EnclosureHandle;    /* 0x1E */
+} MPI2_SEP_REPLY, MPI2_POINTER PTR_MPI2_SEP_REPLY,
+  Mpi2SepReply_t, MPI2_POINTER pMpi2SepReply_t;
+
+/* SlotStatus defines */
+#define MPI2_SEP_REPLY_SLOTSTATUS_REMOVE_READY          (0x00040000)
+#define MPI2_SEP_REPLY_SLOTSTATUS_IDENTIFY_REQUEST      (0x00020000)
+#define MPI2_SEP_REPLY_SLOTSTATUS_REBUILD_STOPPED       (0x00000200)
+#define MPI2_SEP_REPLY_SLOTSTATUS_HOT_SPARE             (0x00000100)
+#define MPI2_SEP_REPLY_SLOTSTATUS_UNCONFIGURED          (0x00000080)
+#define MPI2_SEP_REPLY_SLOTSTATUS_PREDICTED_FAULT       (0x00000040)
+#define MPI2_SEP_REPLY_SLOTSTATUS_DEV_REBUILDING        (0x00000004)
+#define MPI2_SEP_REPLY_SLOTSTATUS_DEV_FAULTY            (0x00000002)
+#define MPI2_SEP_REPLY_SLOTSTATUS_NO_ERROR              (0x00000001)
+
+
+#endif
+
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,1295 @@
+/*
+ *  Copyright (c) 2000-2009 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_ioc.h
+ *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
+ *  Creation Date:  October 11, 2006
+ *
+ *  mpi2_ioc.h Version:  02.00.10
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  In IOCFacts Reply structure, renamed MaxDevices to
+ *                      MaxTargets.
+ *                      Added TotalImageSize field to FWDownload Request.
+ *                      Added reserved words to FWUpload Request.
+ *  06-26-07  02.00.02  Added IR Configuration Change List Event.
+ *  08-31-07  02.00.03  Removed SystemReplyQueueDepth field from the IOCInit
+ *                      request and replaced it with
+ *                      ReplyDescriptorPostQueueDepth and ReplyFreeQueueDepth.
+ *                      Replaced the MinReplyQueueDepth field of the IOCFacts
+ *                      reply with MaxReplyDescriptorPostQueueDepth.
+ *                      Added MPI2_RDPQ_DEPTH_MIN define to specify the minimum
+ *                      depth for the Reply Descriptor Post Queue.
+ *                      Added SASAddress field to Initiator Device Table
+ *                      Overflow Event data.
+ *  10-31-07  02.00.04  Added ReasonCode MPI2_EVENT_SAS_INIT_RC_NOT_RESPONDING
+ *                      for SAS Initiator Device Status Change Event data.
+ *                      Modified Reason Code defines for SAS Topology Change
+ *                      List Event data, including adding a bit for PHY Vacant
+ *                      status, and adding a mask for the Reason Code.
+ *                      Added define for
+ *                      MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING.
+ *                      Added define for MPI2_EXT_IMAGE_TYPE_MEGARAID.
+ *  12-18-07  02.00.05  Added Boot Status defines for the IOCExceptions field of
+ *                      the IOCFacts Reply.
+ *                      Removed MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER define.
+ *                      Moved MPI2_VERSION_UNION to mpi2.h.
+ *                      Changed MPI2_EVENT_NOTIFICATION_REQUEST to use masks
+ *                      instead of enables, and added SASBroadcastPrimitiveMasks
+ *                      field.
+ *                      Added Log Entry Added Event and related structure.
+ *  02-29-08  02.00.06  Added define MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID.
+ *                      Removed define MPI2_IOCFACTS_PROTOCOL_SMP_TARGET.
+ *                      Added MaxVolumes and MaxPersistentEntries fields to
+ *                      IOCFacts reply.
+ *                      Added ProtocalFlags and IOCCapabilities fields to
+ *                      MPI2_FW_IMAGE_HEADER.
+ *                      Removed MPI2_PORTENABLE_FLAGS_ENABLE_SINGLE_PORT.
+ *  03-03-08  02.00.07  Fixed MPI2_FW_IMAGE_HEADER by changing Reserved26 to
+ *                      a U16 (from a U32).
+ *                      Removed extra 's' from EventMasks name.
+ *  06-27-08  02.00.08  Fixed an offset in a comment.
+ *  10-02-08  02.00.09  Removed SystemReplyFrameSize from MPI2_IOC_INIT_REQUEST.
+ *                      Removed CurReplyFrameSize from MPI2_IOC_FACTS_REPLY and
+ *                      renamed MinReplyFrameSize to ReplyFrameSize.
+ *                      Added MPI2_IOCFACTS_EXCEPT_IR_FOREIGN_CONFIG_MAX.
+ *                      Added two new RAIDOperation values for Integrated RAID
+ *                      Operations Status Event data.
+ *                      Added four new IR Configuration Change List Event data
+ *                      ReasonCode values.
+ *                      Added two new ReasonCode defines for SAS Device Status
+ *                      Change Event data.
+ *                      Added three new DiscoveryStatus bits for the SAS
+ *                      Discovery event data.
+ *                      Added Multiplexing Status Change bit to the PhyStatus
+ *                      field of the SAS Topology Change List event data.
+ *                      Removed define for MPI2_INIT_IMAGE_BOOTFLAGS_XMEMCOPY.
+ *                      BootFlags are now product-specific.
+ *                      Added defines for the indivdual signature bytes
+ *                      for MPI2_INIT_IMAGE_FOOTER.
+ *  01-19-09  02.00.10  Added MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY define.
+ *                      Added MPI2_EVENT_SAS_DISC_DS_DOWNSTREAM_INITIATOR
+ *                      define.
+ *                      Added MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE
+ *                      define.
+ *                      Removed MPI2_EVENT_SAS_DISC_DS_SATA_INIT_FAILURE define.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_IOC_H
+#define MPI2_IOC_H
+
+/*****************************************************************************
+*
+*               IOC Messages
+*
+*****************************************************************************/
+
+/****************************************************************************
+*  IOCInit message
+****************************************************************************/
+
+/* IOCInit Request message */
+typedef struct _MPI2_IOC_INIT_REQUEST
+{
+    U8                      WhoInit;                        /* 0x00 */
+    U8                      Reserved1;                      /* 0x01 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+    U16                     MsgVersion;                     /* 0x0C */
+    U16                     HeaderVersion;                  /* 0x0E */
+    U32                     Reserved5;                      /* 0x10 */
+    U32                     Reserved6;                      /* 0x14 */
+    U16                     Reserved7;                      /* 0x18 */
+    U16                     SystemRequestFrameSize;         /* 0x1A */
+    U16                     ReplyDescriptorPostQueueDepth;  /* 0x1C */
+    U16                     ReplyFreeQueueDepth;            /* 0x1E */
+    U32                     SenseBufferAddressHigh;         /* 0x20 */
+    U32                     SystemReplyAddressHigh;         /* 0x24 */
+    U64                     SystemRequestFrameBaseAddress;  /* 0x28 */
+    U64                     ReplyDescriptorPostQueueAddress;/* 0x30 */
+    U64                     ReplyFreeQueueAddress;          /* 0x38 */
+    U64                     TimeStamp;                      /* 0x40 */
+} MPI2_IOC_INIT_REQUEST, MPI2_POINTER PTR_MPI2_IOC_INIT_REQUEST,
+  Mpi2IOCInitRequest_t, MPI2_POINTER pMpi2IOCInitRequest_t;
+
+/* WhoInit values */
+#define MPI2_WHOINIT_NOT_INITIALIZED            (0x00)
+#define MPI2_WHOINIT_SYSTEM_BIOS                (0x01)
+#define MPI2_WHOINIT_ROM_BIOS                   (0x02)
+#define MPI2_WHOINIT_PCI_PEER                   (0x03)
+#define MPI2_WHOINIT_HOST_DRIVER                (0x04)
+#define MPI2_WHOINIT_MANUFACTURER               (0x05)
+
+/* MsgVersion */
+#define MPI2_IOCINIT_MSGVERSION_MAJOR_MASK      (0xFF00)
+#define MPI2_IOCINIT_MSGVERSION_MAJOR_SHIFT     (8)
+#define MPI2_IOCINIT_MSGVERSION_MINOR_MASK      (0x00FF)
+#define MPI2_IOCINIT_MSGVERSION_MINOR_SHIFT     (0)
+
+/* HeaderVersion */
+#define MPI2_IOCINIT_HDRVERSION_UNIT_MASK       (0xFF00)
+#define MPI2_IOCINIT_HDRVERSION_UNIT_SHIFT      (8)
+#define MPI2_IOCINIT_HDRVERSION_DEV_MASK        (0x00FF)
+#define MPI2_IOCINIT_HDRVERSION_DEV_SHIFT       (0)
+
+/* minimum depth for the Reply Descriptor Post Queue */
+#define MPI2_RDPQ_DEPTH_MIN                     (16)
+
+
+/* IOCInit Reply message */
+typedef struct _MPI2_IOC_INIT_REPLY
+{
+    U8                      WhoInit;                        /* 0x00 */
+    U8                      Reserved1;                      /* 0x01 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+    U16                     Reserved5;                      /* 0x0C */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+} MPI2_IOC_INIT_REPLY, MPI2_POINTER PTR_MPI2_IOC_INIT_REPLY,
+  Mpi2IOCInitReply_t, MPI2_POINTER pMpi2IOCInitReply_t;
+
+
+/****************************************************************************
+*  IOCFacts message
+****************************************************************************/
+
+/* IOCFacts Request message */
+typedef struct _MPI2_IOC_FACTS_REQUEST
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+} MPI2_IOC_FACTS_REQUEST, MPI2_POINTER PTR_MPI2_IOC_FACTS_REQUEST,
+  Mpi2IOCFactsRequest_t, MPI2_POINTER pMpi2IOCFactsRequest_t;
+
+
+/* IOCFacts Reply message */
+typedef struct _MPI2_IOC_FACTS_REPLY
+{
+    U16                     MsgVersion;                     /* 0x00 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     HeaderVersion;                  /* 0x04 */
+    U8                      IOCNumber;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved1;                      /* 0x0A */
+    U16                     IOCExceptions;                  /* 0x0C */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+    U8                      MaxChainDepth;                  /* 0x14 */
+    U8                      WhoInit;                        /* 0x15 */
+    U8                      NumberOfPorts;                  /* 0x16 */
+    U8                      Reserved2;                      /* 0x17 */
+    U16                     RequestCredit;                  /* 0x18 */
+    U16                     ProductID;                      /* 0x1A */
+    U32                     IOCCapabilities;                /* 0x1C */
+    MPI2_VERSION_UNION      FWVersion;                      /* 0x20 */
+    U16                     IOCRequestFrameSize;            /* 0x24 */
+    U16                     Reserved3;                      /* 0x26 */
+    U16                     MaxInitiators;                  /* 0x28 */
+    U16                     MaxTargets;                     /* 0x2A */
+    U16                     MaxSasExpanders;                /* 0x2C */
+    U16                     MaxEnclosures;                  /* 0x2E */
+    U16                     ProtocolFlags;                  /* 0x30 */
+    U16                     HighPriorityCredit;             /* 0x32 */
+    U16                     MaxReplyDescriptorPostQueueDepth; /* 0x34 */
+    U8                      ReplyFrameSize;                 /* 0x36 */
+    U8                      MaxVolumes;                     /* 0x37 */
+    U16                     MaxDevHandle;                   /* 0x38 */
+    U16                     MaxPersistentEntries;           /* 0x3A */
+    U32                     Reserved4;                      /* 0x3C */
+} MPI2_IOC_FACTS_REPLY, MPI2_POINTER PTR_MPI2_IOC_FACTS_REPLY,
+  Mpi2IOCFactsReply_t, MPI2_POINTER pMpi2IOCFactsReply_t;
+
+/* MsgVersion */
+#define MPI2_IOCFACTS_MSGVERSION_MAJOR_MASK             (0xFF00)
+#define MPI2_IOCFACTS_MSGVERSION_MAJOR_SHIFT            (8)
+#define MPI2_IOCFACTS_MSGVERSION_MINOR_MASK             (0x00FF)
+#define MPI2_IOCFACTS_MSGVERSION_MINOR_SHIFT            (0)
+
+/* HeaderVersion */
+#define MPI2_IOCFACTS_HDRVERSION_UNIT_MASK              (0xFF00)
+#define MPI2_IOCFACTS_HDRVERSION_UNIT_SHIFT             (8)
+#define MPI2_IOCFACTS_HDRVERSION_DEV_MASK               (0x00FF)
+#define MPI2_IOCFACTS_HDRVERSION_DEV_SHIFT              (0)
+
+/* IOCExceptions */
+#define MPI2_IOCFACTS_EXCEPT_IR_FOREIGN_CONFIG_MAX      (0x0100)
+
+#define MPI2_IOCFACTS_EXCEPT_BOOTSTAT_MASK              (0x00E0)
+#define MPI2_IOCFACTS_EXCEPT_BOOTSTAT_GOOD              (0x0000)
+#define MPI2_IOCFACTS_EXCEPT_BOOTSTAT_BACKUP            (0x0020)
+#define MPI2_IOCFACTS_EXCEPT_BOOTSTAT_RESTORED          (0x0040)
+#define MPI2_IOCFACTS_EXCEPT_BOOTSTAT_CORRUPT_BACKUP    (0x0060)
+
+#define MPI2_IOCFACTS_EXCEPT_METADATA_UNSUPPORTED       (0x0010)
+#define MPI2_IOCFACTS_EXCEPT_MANUFACT_CHECKSUM_FAIL     (0x0008)
+#define MPI2_IOCFACTS_EXCEPT_FW_CHECKSUM_FAIL           (0x0004)
+#define MPI2_IOCFACTS_EXCEPT_RAID_CONFIG_INVALID        (0x0002)
+#define MPI2_IOCFACTS_EXCEPT_CONFIG_CHECKSUM_FAIL       (0x0001)
+
+/* defines for WhoInit field are after the IOCInit Request */
+
+/* ProductID field uses MPI2_FW_HEADER_PID_ */
+
+/* IOCCapabilities */
+#define MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY           (0x00002000)
+#define MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID        (0x00001000)
+#define MPI2_IOCFACTS_CAPABILITY_TLR                    (0x00000800)
+#define MPI2_IOCFACTS_CAPABILITY_MULTICAST              (0x00000100)
+#define MPI2_IOCFACTS_CAPABILITY_BIDIRECTIONAL_TARGET   (0x00000080)
+#define MPI2_IOCFACTS_CAPABILITY_EEDP                   (0x00000040)
+#define MPI2_IOCFACTS_CAPABILITY_SNAPSHOT_BUFFER        (0x00000010)
+#define MPI2_IOCFACTS_CAPABILITY_DIAG_TRACE_BUFFER      (0x00000008)
+#define MPI2_IOCFACTS_CAPABILITY_TASK_SET_FULL_HANDLING (0x00000004)
+
+/* ProtocolFlags */
+#define MPI2_IOCFACTS_PROTOCOL_SCSI_TARGET              (0x0001)
+#define MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR           (0x0002)
+
+
+/****************************************************************************
+*  PortFacts message
+****************************************************************************/
+
+/* PortFacts Request message */
+typedef struct _MPI2_PORT_FACTS_REQUEST
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      PortNumber;                     /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved3;                      /* 0x0A */
+} MPI2_PORT_FACTS_REQUEST, MPI2_POINTER PTR_MPI2_PORT_FACTS_REQUEST,
+  Mpi2PortFactsRequest_t, MPI2_POINTER pMpi2PortFactsRequest_t;
+
+/* PortFacts Reply message */
+typedef struct _MPI2_PORT_FACTS_REPLY
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      PortNumber;                     /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved3;                      /* 0x0A */
+    U16                     Reserved4;                      /* 0x0C */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+    U8                      Reserved5;                      /* 0x14 */
+    U8                      PortType;                       /* 0x15 */
+    U16                     Reserved6;                      /* 0x16 */
+    U16                     MaxPostedCmdBuffers;            /* 0x18 */
+    U16                     Reserved7;                      /* 0x1A */
+} MPI2_PORT_FACTS_REPLY, MPI2_POINTER PTR_MPI2_PORT_FACTS_REPLY,
+  Mpi2PortFactsReply_t, MPI2_POINTER pMpi2PortFactsReply_t;
+
+/* PortType values */
+#define MPI2_PORTFACTS_PORTTYPE_INACTIVE            (0x00)
+#define MPI2_PORTFACTS_PORTTYPE_FC                  (0x10)
+#define MPI2_PORTFACTS_PORTTYPE_ISCSI               (0x20)
+#define MPI2_PORTFACTS_PORTTYPE_SAS_PHYSICAL        (0x30)
+#define MPI2_PORTFACTS_PORTTYPE_SAS_VIRTUAL         (0x31)
+
+
+/****************************************************************************
+*  PortEnable message
+****************************************************************************/
+
+/* PortEnable Request message */
+typedef struct _MPI2_PORT_ENABLE_REQUEST
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U8                      Reserved2;                      /* 0x04 */
+    U8                      PortFlags;                      /* 0x05 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+} MPI2_PORT_ENABLE_REQUEST, MPI2_POINTER PTR_MPI2_PORT_ENABLE_REQUEST,
+  Mpi2PortEnableRequest_t, MPI2_POINTER pMpi2PortEnableRequest_t;
+
+
+/* PortEnable Reply message */
+typedef struct _MPI2_PORT_ENABLE_REPLY
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U8                      Reserved2;                      /* 0x04 */
+    U8                      PortFlags;                      /* 0x05 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+    U16                     Reserved5;                      /* 0x0C */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+} MPI2_PORT_ENABLE_REPLY, MPI2_POINTER PTR_MPI2_PORT_ENABLE_REPLY,
+  Mpi2PortEnableReply_t, MPI2_POINTER pMpi2PortEnableReply_t;
+
+
+/****************************************************************************
+*  EventNotification message
+****************************************************************************/
+
+/* EventNotification Request message */
+#define MPI2_EVENT_NOTIFY_EVENTMASK_WORDS           (4)
+
+typedef struct _MPI2_EVENT_NOTIFICATION_REQUEST
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+    U32                     Reserved5;                      /* 0x0C */
+    U32                     Reserved6;                      /* 0x10 */
+    U32                     EventMasks[MPI2_EVENT_NOTIFY_EVENTMASK_WORDS];/* 0x14 */
+    U16                     SASBroadcastPrimitiveMasks;     /* 0x24 */
+    U16                     Reserved7;                      /* 0x26 */
+    U32                     Reserved8;                      /* 0x28 */
+} MPI2_EVENT_NOTIFICATION_REQUEST,
+  MPI2_POINTER PTR_MPI2_EVENT_NOTIFICATION_REQUEST,
+  Mpi2EventNotificationRequest_t, MPI2_POINTER pMpi2EventNotificationRequest_t;
+
+
+/* EventNotification Reply message */
+typedef struct _MPI2_EVENT_NOTIFICATION_REPLY
+{
+    U16                     EventDataLength;                /* 0x00 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved1;                      /* 0x04 */
+    U8                      AckRequired;                    /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved2;                      /* 0x0A */
+    U16                     Reserved3;                      /* 0x0C */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+    U16                     Event;                          /* 0x14 */
+    U16                     Reserved4;                      /* 0x16 */
+    U32                     EventContext;                   /* 0x18 */
+    U32                     EventData[1];                   /* 0x1C */
+} MPI2_EVENT_NOTIFICATION_REPLY, MPI2_POINTER PTR_MPI2_EVENT_NOTIFICATION_REPLY,
+  Mpi2EventNotificationReply_t, MPI2_POINTER pMpi2EventNotificationReply_t;
+
+/* AckRequired */
+#define MPI2_EVENT_NOTIFICATION_ACK_NOT_REQUIRED    (0x00)
+#define MPI2_EVENT_NOTIFICATION_ACK_REQUIRED        (0x01)
+
+/* Event */
+#define MPI2_EVENT_LOG_DATA                         (0x0001)
+#define MPI2_EVENT_STATE_CHANGE                     (0x0002)
+#define MPI2_EVENT_HARD_RESET_RECEIVED              (0x0005)
+#define MPI2_EVENT_EVENT_CHANGE                     (0x000A)
+#define MPI2_EVENT_TASK_SET_FULL                    (0x000E)
+#define MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE         (0x000F)
+#define MPI2_EVENT_IR_OPERATION_STATUS              (0x0014)
+#define MPI2_EVENT_SAS_DISCOVERY                    (0x0016)
+#define MPI2_EVENT_SAS_BROADCAST_PRIMITIVE          (0x0017)
+#define MPI2_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE    (0x0018)
+#define MPI2_EVENT_SAS_INIT_TABLE_OVERFLOW          (0x0019)
+#define MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST         (0x001C)
+#define MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE    (0x001D)
+#define MPI2_EVENT_IR_VOLUME                        (0x001E)
+#define MPI2_EVENT_IR_PHYSICAL_DISK                 (0x001F)
+#define MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST     (0x0020)
+#define MPI2_EVENT_LOG_ENTRY_ADDED                  (0x0021)
+
+
+/* Log Entry Added Event data */
+
+/* the following structure matches MPI2_LOG_0_ENTRY in mpi2_cnfg.h */
+#define MPI2_EVENT_DATA_LOG_DATA_LENGTH             (0x1C)
+
+typedef struct _MPI2_EVENT_DATA_LOG_ENTRY_ADDED
+{
+    U64         TimeStamp;                          /* 0x00 */
+    U32         Reserved1;                          /* 0x08 */
+    U16         LogSequence;                        /* 0x0C */
+    U16         LogEntryQualifier;                  /* 0x0E */
+    U8          VP_ID;                              /* 0x10 */
+    U8          VF_ID;                              /* 0x11 */
+    U16         Reserved2;                          /* 0x12 */
+    U8          LogData[MPI2_EVENT_DATA_LOG_DATA_LENGTH];/* 0x14 */
+} MPI2_EVENT_DATA_LOG_ENTRY_ADDED,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_LOG_ENTRY_ADDED,
+  Mpi2EventDataLogEntryAdded_t, MPI2_POINTER pMpi2EventDataLogEntryAdded_t;
+
+/* Hard Reset Received Event data */
+
+typedef struct _MPI2_EVENT_DATA_HARD_RESET_RECEIVED
+{
+    U8                      Reserved1;                      /* 0x00 */
+    U8                      Port;                           /* 0x01 */
+    U16                     Reserved2;                      /* 0x02 */
+} MPI2_EVENT_DATA_HARD_RESET_RECEIVED,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_HARD_RESET_RECEIVED,
+  Mpi2EventDataHardResetReceived_t,
+  MPI2_POINTER pMpi2EventDataHardResetReceived_t;
+
+/* Task Set Full Event data */
+
+typedef struct _MPI2_EVENT_DATA_TASK_SET_FULL
+{
+    U16                     DevHandle;                      /* 0x00 */
+    U16                     CurrentDepth;                   /* 0x02 */
+} MPI2_EVENT_DATA_TASK_SET_FULL, MPI2_POINTER PTR_MPI2_EVENT_DATA_TASK_SET_FULL,
+  Mpi2EventDataTaskSetFull_t, MPI2_POINTER pMpi2EventDataTaskSetFull_t;
+
+
+/* SAS Device Status Change Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_DEVICE_STATUS_CHANGE
+{
+    U16                     TaskTag;                        /* 0x00 */
+    U8                      ReasonCode;                     /* 0x02 */
+    U8                      Reserved1;                      /* 0x03 */
+    U8                      ASC;                            /* 0x04 */
+    U8                      ASCQ;                           /* 0x05 */
+    U16                     DevHandle;                      /* 0x06 */
+    U32                     Reserved2;                      /* 0x08 */
+    U64                     SASAddress;                     /* 0x0C */
+    U8                      LUN[8];                         /* 0x14 */
+} MPI2_EVENT_DATA_SAS_DEVICE_STATUS_CHANGE,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_DEVICE_STATUS_CHANGE,
+  Mpi2EventDataSasDeviceStatusChange_t,
+  MPI2_POINTER pMpi2EventDataSasDeviceStatusChange_t;
+
+/* SAS Device Status Change Event data ReasonCode values */
+#define MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA               (0x05)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED              (0x07)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET    (0x08)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL      (0x09)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL  (0x0A)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL  (0x0B)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL      (0x0C)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION       (0x0D)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET   (0x0E)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_TASK_ABORT_INTERNAL  (0x0F)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE        (0x10)
+
+
+/* Integrated RAID Operation Status Event data */
+
+typedef struct _MPI2_EVENT_DATA_IR_OPERATION_STATUS
+{
+    U16                     VolDevHandle;               /* 0x00 */
+    U16                     Reserved1;                  /* 0x02 */
+    U8                      RAIDOperation;              /* 0x04 */
+    U8                      PercentComplete;            /* 0x05 */
+    U16                     Reserved2;                  /* 0x06 */
+    U32                     Resereved3;                 /* 0x08 */
+} MPI2_EVENT_DATA_IR_OPERATION_STATUS,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_IR_OPERATION_STATUS,
+  Mpi2EventDataIrOperationStatus_t,
+  MPI2_POINTER pMpi2EventDataIrOperationStatus_t;
+
+/* Integrated RAID Operation Status Event data RAIDOperation values */
+#define MPI2_EVENT_IR_RAIDOP_RESYNC                     (0x00)
+#define MPI2_EVENT_IR_RAIDOP_ONLINE_CAP_EXPANSION       (0x01)
+#define MPI2_EVENT_IR_RAIDOP_CONSISTENCY_CHECK          (0x02)
+#define MPI2_EVENT_IR_RAIDOP_BACKGROUND_INIT            (0x03)
+#define MPI2_EVENT_IR_RAIDOP_MAKE_DATA_CONSISTENT       (0x04)
+
+
+/* Integrated RAID Volume Event data */
+
+typedef struct _MPI2_EVENT_DATA_IR_VOLUME
+{
+    U16                     VolDevHandle;               /* 0x00 */
+    U8                      ReasonCode;                 /* 0x02 */
+    U8                      Reserved1;                  /* 0x03 */
+    U32                     NewValue;                   /* 0x04 */
+    U32                     PreviousValue;              /* 0x08 */
+} MPI2_EVENT_DATA_IR_VOLUME, MPI2_POINTER PTR_MPI2_EVENT_DATA_IR_VOLUME,
+  Mpi2EventDataIrVolume_t, MPI2_POINTER pMpi2EventDataIrVolume_t;
+
+/* Integrated RAID Volume Event data ReasonCode values */
+#define MPI2_EVENT_IR_VOLUME_RC_SETTINGS_CHANGED        (0x01)
+#define MPI2_EVENT_IR_VOLUME_RC_STATUS_FLAGS_CHANGED    (0x02)
+#define MPI2_EVENT_IR_VOLUME_RC_STATE_CHANGED           (0x03)
+
+
+/* Integrated RAID Physical Disk Event data */
+
+typedef struct _MPI2_EVENT_DATA_IR_PHYSICAL_DISK
+{
+    U16                     Reserved1;                  /* 0x00 */
+    U8                      ReasonCode;                 /* 0x02 */
+    U8                      PhysDiskNum;                /* 0x03 */
+    U16                     PhysDiskDevHandle;          /* 0x04 */
+    U16                     Reserved2;                  /* 0x06 */
+    U16                     Slot;                       /* 0x08 */
+    U16                     EnclosureHandle;            /* 0x0A */
+    U32                     NewValue;                   /* 0x0C */
+    U32                     PreviousValue;              /* 0x10 */
+} MPI2_EVENT_DATA_IR_PHYSICAL_DISK,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_IR_PHYSICAL_DISK,
+  Mpi2EventDataIrPhysicalDisk_t, MPI2_POINTER pMpi2EventDataIrPhysicalDisk_t;
+
+/* Integrated RAID Physical Disk Event data ReasonCode values */
+#define MPI2_EVENT_IR_PHYSDISK_RC_SETTINGS_CHANGED      (0x01)
+#define MPI2_EVENT_IR_PHYSDISK_RC_STATUS_FLAGS_CHANGED  (0x02)
+#define MPI2_EVENT_IR_PHYSDISK_RC_STATE_CHANGED         (0x03)
+
+
+/* Integrated RAID Configuration Change List Event data */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check NumElements at runtime.
+ */
+#ifndef MPI2_EVENT_IR_CONFIG_ELEMENT_COUNT
+#define MPI2_EVENT_IR_CONFIG_ELEMENT_COUNT          (1)
+#endif
+
+typedef struct _MPI2_EVENT_IR_CONFIG_ELEMENT
+{
+    U16                     ElementFlags;               /* 0x00 */
+    U16                     VolDevHandle;               /* 0x02 */
+    U8                      ReasonCode;                 /* 0x04 */
+    U8                      PhysDiskNum;                /* 0x05 */
+    U16                     PhysDiskDevHandle;          /* 0x06 */
+} MPI2_EVENT_IR_CONFIG_ELEMENT, MPI2_POINTER PTR_MPI2_EVENT_IR_CONFIG_ELEMENT,
+  Mpi2EventIrConfigElement_t, MPI2_POINTER pMpi2EventIrConfigElement_t;
+
+/* IR Configuration Change List Event data ElementFlags values */
+#define MPI2_EVENT_IR_CHANGE_EFLAGS_ELEMENT_TYPE_MASK   (0x000F)
+#define MPI2_EVENT_IR_CHANGE_EFLAGS_VOLUME_ELEMENT      (0x0000)
+#define MPI2_EVENT_IR_CHANGE_EFLAGS_VOLPHYSDISK_ELEMENT (0x0001)
+#define MPI2_EVENT_IR_CHANGE_EFLAGS_HOTSPARE_ELEMENT    (0x0002)
+
+/* IR Configuration Change List Event data ReasonCode values */
+#define MPI2_EVENT_IR_CHANGE_RC_ADDED                   (0x01)
+#define MPI2_EVENT_IR_CHANGE_RC_REMOVED                 (0x02)
+#define MPI2_EVENT_IR_CHANGE_RC_NO_CHANGE               (0x03)
+#define MPI2_EVENT_IR_CHANGE_RC_HIDE                    (0x04)
+#define MPI2_EVENT_IR_CHANGE_RC_UNHIDE                  (0x05)
+#define MPI2_EVENT_IR_CHANGE_RC_VOLUME_CREATED          (0x06)
+#define MPI2_EVENT_IR_CHANGE_RC_VOLUME_DELETED          (0x07)
+#define MPI2_EVENT_IR_CHANGE_RC_PD_CREATED              (0x08)
+#define MPI2_EVENT_IR_CHANGE_RC_PD_DELETED              (0x09)
+
+typedef struct _MPI2_EVENT_DATA_IR_CONFIG_CHANGE_LIST
+{
+    U8                              NumElements;        /* 0x00 */
+    U8                              Reserved1;          /* 0x01 */
+    U8                              Reserved2;          /* 0x02 */
+    U8                              ConfigNum;          /* 0x03 */
+    U32                             Flags;              /* 0x04 */
+    MPI2_EVENT_IR_CONFIG_ELEMENT    ConfigElement[MPI2_EVENT_IR_CONFIG_ELEMENT_COUNT];    /* 0x08 */
+} MPI2_EVENT_DATA_IR_CONFIG_CHANGE_LIST,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_IR_CONFIG_CHANGE_LIST,
+  Mpi2EventDataIrConfigChangeList_t,
+  MPI2_POINTER pMpi2EventDataIrConfigChangeList_t;
+
+/* IR Configuration Change List Event data Flags values */
+#define MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG   (0x00000001)
+
+
+/* SAS Discovery Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_DISCOVERY
+{
+    U8                      Flags;                      /* 0x00 */
+    U8                      ReasonCode;                 /* 0x01 */
+    U8                      PhysicalPort;               /* 0x02 */
+    U8                      Reserved1;                  /* 0x03 */
+    U32                     DiscoveryStatus;            /* 0x04 */
+} MPI2_EVENT_DATA_SAS_DISCOVERY,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_DISCOVERY,
+  Mpi2EventDataSasDiscovery_t, MPI2_POINTER pMpi2EventDataSasDiscovery_t;
+
+/* SAS Discovery Event data Flags values */
+#define MPI2_EVENT_SAS_DISC_DEVICE_CHANGE                   (0x02)
+#define MPI2_EVENT_SAS_DISC_IN_PROGRESS                     (0x01)
+
+/* SAS Discovery Event data ReasonCode values */
+#define MPI2_EVENT_SAS_DISC_RC_STARTED                      (0x01)
+#define MPI2_EVENT_SAS_DISC_RC_COMPLETED                    (0x02)
+
+/* SAS Discovery Event data DiscoveryStatus values */
+#define MPI2_EVENT_SAS_DISC_DS_MAX_ENCLOSURES_EXCEED            (0x80000000)
+#define MPI2_EVENT_SAS_DISC_DS_MAX_EXPANDERS_EXCEED             (0x40000000)
+#define MPI2_EVENT_SAS_DISC_DS_MAX_DEVICES_EXCEED               (0x20000000)
+#define MPI2_EVENT_SAS_DISC_DS_MAX_TOPO_PHYS_EXCEED             (0x10000000)
+#define MPI2_EVENT_SAS_DISC_DS_DOWNSTREAM_INITIATOR             (0x08000000)
+#define MPI2_EVENT_SAS_DISC_DS_MULTI_SUBTRACTIVE_SUBTRACTIVE    (0x00008000)
+#define MPI2_EVENT_SAS_DISC_DS_EXP_MULTI_SUBTRACTIVE            (0x00004000)
+#define MPI2_EVENT_SAS_DISC_DS_MULTI_PORT_DOMAIN                (0x00002000)
+#define MPI2_EVENT_SAS_DISC_DS_TABLE_TO_SUBTRACTIVE_LINK        (0x00001000)
+#define MPI2_EVENT_SAS_DISC_DS_UNSUPPORTED_DEVICE               (0x00000800)
+#define MPI2_EVENT_SAS_DISC_DS_TABLE_LINK                       (0x00000400)
+#define MPI2_EVENT_SAS_DISC_DS_SUBTRACTIVE_LINK                 (0x00000200)
+#define MPI2_EVENT_SAS_DISC_DS_SMP_CRC_ERROR                    (0x00000100)
+#define MPI2_EVENT_SAS_DISC_DS_SMP_FUNCTION_FAILED              (0x00000080)
+#define MPI2_EVENT_SAS_DISC_DS_INDEX_NOT_EXIST                  (0x00000040)
+#define MPI2_EVENT_SAS_DISC_DS_OUT_ROUTE_ENTRIES                (0x00000020)
+#define MPI2_EVENT_SAS_DISC_DS_SMP_TIMEOUT                      (0x00000010)
+#define MPI2_EVENT_SAS_DISC_DS_MULTIPLE_PORTS                   (0x00000004)
+#define MPI2_EVENT_SAS_DISC_DS_UNADDRESSABLE_DEVICE             (0x00000002)
+#define MPI2_EVENT_SAS_DISC_DS_LOOP_DETECTED                    (0x00000001)
+
+
+/* SAS Broadcast Primitive Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_BROADCAST_PRIMITIVE
+{
+    U8                      PhyNum;                     /* 0x00 */
+    U8                      Port;                       /* 0x01 */
+    U8                      PortWidth;                  /* 0x02 */
+    U8                      Primitive;                  /* 0x03 */
+} MPI2_EVENT_DATA_SAS_BROADCAST_PRIMITIVE,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_BROADCAST_PRIMITIVE,
+  Mpi2EventDataSasBroadcastPrimitive_t,
+  MPI2_POINTER pMpi2EventDataSasBroadcastPrimitive_t;
+
+/* defines for the Primitive field */
+#define MPI2_EVENT_PRIMITIVE_CHANGE                         (0x01)
+#define MPI2_EVENT_PRIMITIVE_SES                            (0x02)
+#define MPI2_EVENT_PRIMITIVE_EXPANDER                       (0x03)
+#define MPI2_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT             (0x04)
+#define MPI2_EVENT_PRIMITIVE_RESERVED3                      (0x05)
+#define MPI2_EVENT_PRIMITIVE_RESERVED4                      (0x06)
+#define MPI2_EVENT_PRIMITIVE_CHANGE0_RESERVED               (0x07)
+#define MPI2_EVENT_PRIMITIVE_CHANGE1_RESERVED               (0x08)
+
+
+/* SAS Initiator Device Status Change Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE
+{
+    U8                      ReasonCode;                 /* 0x00 */
+    U8                      PhysicalPort;               /* 0x01 */
+    U16                     DevHandle;                  /* 0x02 */
+    U64                     SASAddress;                 /* 0x04 */
+} MPI2_EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE,
+  Mpi2EventDataSasInitDevStatusChange_t,
+  MPI2_POINTER pMpi2EventDataSasInitDevStatusChange_t;
+
+/* SAS Initiator Device Status Change event ReasonCode values */
+#define MPI2_EVENT_SAS_INIT_RC_ADDED                (0x01)
+#define MPI2_EVENT_SAS_INIT_RC_NOT_RESPONDING       (0x02)
+
+
+/* SAS Initiator Device Table Overflow Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW
+{
+    U16                     MaxInit;                    /* 0x00 */
+    U16                     CurrentInit;                /* 0x02 */
+    U64                     SASAddress;                 /* 0x04 */
+} MPI2_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW,
+  Mpi2EventDataSasInitTableOverflow_t,
+  MPI2_POINTER pMpi2EventDataSasInitTableOverflow_t;
+
+
+/* SAS Topology Change List Event data */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check NumEntries at runtime.
+ */
+#ifndef MPI2_EVENT_SAS_TOPO_PHY_COUNT
+#define MPI2_EVENT_SAS_TOPO_PHY_COUNT           (1)
+#endif
+
+typedef struct _MPI2_EVENT_SAS_TOPO_PHY_ENTRY
+{
+    U16                     AttachedDevHandle;          /* 0x00 */
+    U8                      LinkRate;                   /* 0x02 */
+    U8                      PhyStatus;                  /* 0x03 */
+} MPI2_EVENT_SAS_TOPO_PHY_ENTRY, MPI2_POINTER PTR_MPI2_EVENT_SAS_TOPO_PHY_ENTRY,
+  Mpi2EventSasTopoPhyEntry_t, MPI2_POINTER pMpi2EventSasTopoPhyEntry_t;
+
+typedef struct _MPI2_EVENT_DATA_SAS_TOPOLOGY_CHANGE_LIST
+{
+    U16                             EnclosureHandle;            /* 0x00 */
+    U16                             ExpanderDevHandle;          /* 0x02 */
+    U8                              NumPhys;                    /* 0x04 */
+    U8                              Reserved1;                  /* 0x05 */
+    U16                             Reserved2;                  /* 0x06 */
+    U8                              NumEntries;                 /* 0x08 */
+    U8                              StartPhyNum;                /* 0x09 */
+    U8                              ExpStatus;                  /* 0x0A */
+    U8                              PhysicalPort;               /* 0x0B */
+    MPI2_EVENT_SAS_TOPO_PHY_ENTRY   PHY[MPI2_EVENT_SAS_TOPO_PHY_COUNT]; /* 0x0C*/
+} MPI2_EVENT_DATA_SAS_TOPOLOGY_CHANGE_LIST,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_TOPOLOGY_CHANGE_LIST,
+  Mpi2EventDataSasTopologyChangeList_t,
+  MPI2_POINTER pMpi2EventDataSasTopologyChangeList_t;
+
+/* values for the ExpStatus field */
+#define MPI2_EVENT_SAS_TOPO_ES_ADDED                        (0x01)
+#define MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING               (0x02)
+#define MPI2_EVENT_SAS_TOPO_ES_RESPONDING                   (0x03)
+#define MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING         (0x04)
+
+/* defines for the LinkRate field */
+#define MPI2_EVENT_SAS_TOPO_LR_CURRENT_MASK                 (0xF0)
+#define MPI2_EVENT_SAS_TOPO_LR_CURRENT_SHIFT                (4)
+#define MPI2_EVENT_SAS_TOPO_LR_PREV_MASK                    (0x0F)
+#define MPI2_EVENT_SAS_TOPO_LR_PREV_SHIFT                   (0)
+
+#define MPI2_EVENT_SAS_TOPO_LR_UNKNOWN_LINK_RATE            (0x00)
+#define MPI2_EVENT_SAS_TOPO_LR_PHY_DISABLED                 (0x01)
+#define MPI2_EVENT_SAS_TOPO_LR_NEGOTIATION_FAILED           (0x02)
+#define MPI2_EVENT_SAS_TOPO_LR_SATA_OOB_COMPLETE            (0x03)
+#define MPI2_EVENT_SAS_TOPO_LR_PORT_SELECTOR                (0x04)
+#define MPI2_EVENT_SAS_TOPO_LR_SMP_RESET_IN_PROGRESS        (0x05)
+#define MPI2_EVENT_SAS_TOPO_LR_RATE_1_5                     (0x08)
+#define MPI2_EVENT_SAS_TOPO_LR_RATE_3_0                     (0x09)
+#define MPI2_EVENT_SAS_TOPO_LR_RATE_6_0                     (0x0A)
+
+/* values for the PhyStatus field */
+#define MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT                (0x80)
+#define MPI2_EVENT_SAS_TOPO_PS_MULTIPLEX_CHANGE             (0x10)
+/* values for the PhyStatus ReasonCode sub-field */
+#define MPI2_EVENT_SAS_TOPO_RC_MASK                         (0x0F)
+#define MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED                   (0x01)
+#define MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING          (0x02)
+#define MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED                  (0x03)
+#define MPI2_EVENT_SAS_TOPO_RC_NO_CHANGE                    (0x04)
+#define MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING         (0x05)
+
+
+/* SAS Enclosure Device Status Change Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_ENCL_DEV_STATUS_CHANGE
+{
+    U16                     EnclosureHandle;            /* 0x00 */
+    U8                      ReasonCode;                 /* 0x02 */
+    U8                      PhysicalPort;               /* 0x03 */
+    U64                     EnclosureLogicalID;         /* 0x04 */
+    U16                     NumSlots;                   /* 0x0C */
+    U16                     StartSlot;                  /* 0x0E */
+    U32                     PhyBits;                    /* 0x10 */
+} MPI2_EVENT_DATA_SAS_ENCL_DEV_STATUS_CHANGE,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_ENCL_DEV_STATUS_CHANGE,
+  Mpi2EventDataSasEnclDevStatusChange_t,
+  MPI2_POINTER pMpi2EventDataSasEnclDevStatusChange_t;
+
+/* SAS Enclosure Device Status Change event ReasonCode values */
+#define MPI2_EVENT_SAS_ENCL_RC_ADDED                (0x01)
+#define MPI2_EVENT_SAS_ENCL_RC_NOT_RESPONDING       (0x02)
+
+
+/****************************************************************************
+*  EventAck message
+****************************************************************************/
+
+/* EventAck Request message */
+typedef struct _MPI2_EVENT_ACK_REQUEST
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+    U16                     Event;                          /* 0x0C */
+    U16                     Reserved5;                      /* 0x0E */
+    U32                     EventContext;                   /* 0x10 */
+} MPI2_EVENT_ACK_REQUEST, MPI2_POINTER PTR_MPI2_EVENT_ACK_REQUEST,
+  Mpi2EventAckRequest_t, MPI2_POINTER pMpi2EventAckRequest_t;
+
+
+/* EventAck Reply message */
+typedef struct _MPI2_EVENT_ACK_REPLY
+{
+    U16                     Reserved1;                      /* 0x00 */
+    U8                      MsgLength;                      /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     Reserved2;                      /* 0x04 */
+    U8                      Reserved3;                      /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved4;                      /* 0x0A */
+    U16                     Reserved5;                      /* 0x0C */
+    U16                     IOCStatus;                      /* 0x0E */
+    U32                     IOCLogInfo;                     /* 0x10 */
+} MPI2_EVENT_ACK_REPLY, MPI2_POINTER PTR_MPI2_EVENT_ACK_REPLY,
+  Mpi2EventAckReply_t, MPI2_POINTER pMpi2EventAckReply_t;
+
+
+/****************************************************************************
+*  FWDownload message
+****************************************************************************/
+
+/* FWDownload Request message */
+typedef struct _MPI2_FW_DOWNLOAD_REQUEST
+{
+    U8                      ImageType;                  /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U32                     TotalImageSize;             /* 0x0C */
+    U32                     Reserved5;                  /* 0x10 */
+    MPI2_MPI_SGE_UNION      SGL;                        /* 0x14 */
+} MPI2_FW_DOWNLOAD_REQUEST, MPI2_POINTER PTR_MPI2_FW_DOWNLOAD_REQUEST,
+  Mpi2FWDownloadRequest, MPI2_POINTER pMpi2FWDownloadRequest;
+
+#define MPI2_FW_DOWNLOAD_MSGFLGS_LAST_SEGMENT   (0x01)
+
+#define MPI2_FW_DOWNLOAD_ITYPE_FW                   (0x01)
+#define MPI2_FW_DOWNLOAD_ITYPE_BIOS                 (0x02)
+#define MPI2_FW_DOWNLOAD_ITYPE_MANUFACTURING        (0x06)
+#define MPI2_FW_DOWNLOAD_ITYPE_CONFIG_1             (0x07)
+#define MPI2_FW_DOWNLOAD_ITYPE_CONFIG_2             (0x08)
+#define MPI2_FW_DOWNLOAD_ITYPE_MEGARAID             (0x09)
+#define MPI2_FW_DOWNLOAD_ITYPE_COMMON_BOOT_BLOCK    (0x0B)
+
+/* FWDownload TransactionContext Element */
+typedef struct _MPI2_FW_DOWNLOAD_TCSGE
+{
+    U8                      Reserved1;                  /* 0x00 */
+    U8                      ContextSize;                /* 0x01 */
+    U8                      DetailsLength;              /* 0x02 */
+    U8                      Flags;                      /* 0x03 */
+    U32                     Reserved2;                  /* 0x04 */
+    U32                     ImageOffset;                /* 0x08 */
+    U32                     ImageSize;                  /* 0x0C */
+} MPI2_FW_DOWNLOAD_TCSGE, MPI2_POINTER PTR_MPI2_FW_DOWNLOAD_TCSGE,
+  Mpi2FWDownloadTCSGE_t, MPI2_POINTER pMpi2FWDownloadTCSGE_t;
+
+/* FWDownload Reply message */
+typedef struct _MPI2_FW_DOWNLOAD_REPLY
+{
+    U8                      ImageType;                  /* 0x00 */
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
+} MPI2_FW_DOWNLOAD_REPLY, MPI2_POINTER PTR_MPI2_FW_DOWNLOAD_REPLY,
+  Mpi2FWDownloadReply_t, MPI2_POINTER pMpi2FWDownloadReply_t;
+
+
+/****************************************************************************
+*  FWUpload message
+****************************************************************************/
+
+/* FWUpload Request message */
+typedef struct _MPI2_FW_UPLOAD_REQUEST
+{
+    U8                      ImageType;                  /* 0x00 */
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
+    MPI2_MPI_SGE_UNION      SGL;                        /* 0x14 */
+} MPI2_FW_UPLOAD_REQUEST, MPI2_POINTER PTR_MPI2_FW_UPLOAD_REQUEST,
+  Mpi2FWUploadRequest_t, MPI2_POINTER pMpi2FWUploadRequest_t;
+
+#define MPI2_FW_UPLOAD_ITYPE_FW_CURRENT         (0x00)
+#define MPI2_FW_UPLOAD_ITYPE_FW_FLASH           (0x01)
+#define MPI2_FW_UPLOAD_ITYPE_BIOS_FLASH         (0x02)
+#define MPI2_FW_UPLOAD_ITYPE_FW_BACKUP          (0x05)
+#define MPI2_FW_UPLOAD_ITYPE_MANUFACTURING      (0x06)
+#define MPI2_FW_UPLOAD_ITYPE_CONFIG_1           (0x07)
+#define MPI2_FW_UPLOAD_ITYPE_CONFIG_2           (0x08)
+#define MPI2_FW_UPLOAD_ITYPE_MEGARAID           (0x09)
+#define MPI2_FW_UPLOAD_ITYPE_COMPLETE           (0x0A)
+#define MPI2_FW_UPLOAD_ITYPE_COMMON_BOOT_BLOCK  (0x0B)
+
+typedef struct _MPI2_FW_UPLOAD_TCSGE
+{
+    U8                      Reserved1;                  /* 0x00 */
+    U8                      ContextSize;                /* 0x01 */
+    U8                      DetailsLength;              /* 0x02 */
+    U8                      Flags;                      /* 0x03 */
+    U32                     Reserved2;                  /* 0x04 */
+    U32                     ImageOffset;                /* 0x08 */
+    U32                     ImageSize;                  /* 0x0C */
+} MPI2_FW_UPLOAD_TCSGE, MPI2_POINTER PTR_MPI2_FW_UPLOAD_TCSGE,
+  Mpi2FWUploadTCSGE_t, MPI2_POINTER pMpi2FWUploadTCSGE_t;
+
+/* FWUpload Reply message */
+typedef struct _MPI2_FW_UPLOAD_REPLY
+{
+    U8                      ImageType;                  /* 0x00 */
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
+    U32                     ActualImageSize;            /* 0x14 */
+} MPI2_FW_UPLOAD_REPLY, MPI2_POINTER PTR_MPI2_FW_UPLOAD_REPLY,
+  Mpi2FWUploadReply_t, MPI2_POINTER pMPi2FWUploadReply_t;
+
+
+/* FW Image Header */
+typedef struct _MPI2_FW_IMAGE_HEADER
+{
+    U32                     Signature;                  /* 0x00 */
+    U32                     Signature0;                 /* 0x04 */
+    U32                     Signature1;                 /* 0x08 */
+    U32                     Signature2;                 /* 0x0C */
+    MPI2_VERSION_UNION      MPIVersion;                 /* 0x10 */
+    MPI2_VERSION_UNION      FWVersion;                  /* 0x14 */
+    MPI2_VERSION_UNION      NVDATAVersion;              /* 0x18 */
+    MPI2_VERSION_UNION      PackageVersion;             /* 0x1C */
+    U16                     VendorID;                   /* 0x20 */
+    U16                     ProductID;                  /* 0x22 */
+    U16                     ProtocolFlags;              /* 0x24 */
+    U16                     Reserved26;                 /* 0x26 */
+    U32                     IOCCapabilities;            /* 0x28 */
+    U32                     ImageSize;                  /* 0x2C */
+    U32                     NextImageHeaderOffset;      /* 0x30 */
+    U32                     Checksum;                   /* 0x34 */
+    U32                     Reserved38;                 /* 0x38 */
+    U32                     Reserved3C;                 /* 0x3C */
+    U32                     Reserved40;                 /* 0x40 */
+    U32                     Reserved44;                 /* 0x44 */
+    U32                     Reserved48;                 /* 0x48 */
+    U32                     Reserved4C;                 /* 0x4C */
+    U32                     Reserved50;                 /* 0x50 */
+    U32                     Reserved54;                 /* 0x54 */
+    U32                     Reserved58;                 /* 0x58 */
+    U32                     Reserved5C;                 /* 0x5C */
+    U32                     Reserved60;                 /* 0x60 */
+    U32                     FirmwareVersionNameWhat;    /* 0x64 */
+    U8                      FirmwareVersionName[32];    /* 0x68 */
+    U32                     VendorNameWhat;             /* 0x88 */
+    U8                      VendorName[32];             /* 0x8C */
+    U32                     PackageNameWhat;            /* 0x88 */
+    U8                      PackageName[32];            /* 0x8C */
+    U32                     ReservedD0;                 /* 0xD0 */
+    U32                     ReservedD4;                 /* 0xD4 */
+    U32                     ReservedD8;                 /* 0xD8 */
+    U32                     ReservedDC;                 /* 0xDC */
+    U32                     ReservedE0;                 /* 0xE0 */
+    U32                     ReservedE4;                 /* 0xE4 */
+    U32                     ReservedE8;                 /* 0xE8 */
+    U32                     ReservedEC;                 /* 0xEC */
+    U32                     ReservedF0;                 /* 0xF0 */
+    U32                     ReservedF4;                 /* 0xF4 */
+    U32                     ReservedF8;                 /* 0xF8 */
+    U32                     ReservedFC;                 /* 0xFC */
+} MPI2_FW_IMAGE_HEADER, MPI2_POINTER PTR_MPI2_FW_IMAGE_HEADER,
+  Mpi2FWImageHeader_t, MPI2_POINTER pMpi2FWImageHeader_t;
+
+/* Signature field */
+#define MPI2_FW_HEADER_SIGNATURE_OFFSET         (0x00)
+#define MPI2_FW_HEADER_SIGNATURE_MASK           (0xFF000000)
+#define MPI2_FW_HEADER_SIGNATURE                (0xEA000000)
+
+/* Signature0 field */
+#define MPI2_FW_HEADER_SIGNATURE0_OFFSET        (0x04)
+#define MPI2_FW_HEADER_SIGNATURE0               (0x5AFAA55A)
+
+/* Signature1 field */
+#define MPI2_FW_HEADER_SIGNATURE1_OFFSET        (0x08)
+#define MPI2_FW_HEADER_SIGNATURE1               (0xA55AFAA5)
+
+/* Signature2 field */
+#define MPI2_FW_HEADER_SIGNATURE2_OFFSET        (0x0C)
+#define MPI2_FW_HEADER_SIGNATURE2               (0x5AA55AFA)
+
+
+/* defines for using the ProductID field */
+#define MPI2_FW_HEADER_PID_TYPE_MASK            (0xF000)
+#define MPI2_FW_HEADER_PID_TYPE_SAS             (0x2000)
+
+#define MPI2_FW_HEADER_PID_PROD_MASK            (0x0F00)
+#define MPI2_FW_HEADER_PID_PROD_A               (0x0000)
+
+#define MPI2_FW_HEADER_PID_FAMILY_MASK          (0x00FF)
+/* SAS */
+#define MPI2_FW_HEADER_PID_FAMILY_2108_SAS      (0x0010)
+
+/* use MPI2_IOCFACTS_PROTOCOL_ defines for ProtocolFlags field */
+
+/* use MPI2_IOCFACTS_CAPABILITY_ defines for IOCCapabilities field */
+
+
+#define MPI2_FW_HEADER_IMAGESIZE_OFFSET         (0x2C)
+#define MPI2_FW_HEADER_NEXTIMAGE_OFFSET         (0x30)
+#define MPI2_FW_HEADER_VERNMHWAT_OFFSET         (0x64)
+
+#define MPI2_FW_HEADER_WHAT_SIGNATURE           (0x29232840)
+
+#define MPI2_FW_HEADER_SIZE                     (0x100)
+
+
+/* Extended Image Header */
+typedef struct _MPI2_EXT_IMAGE_HEADER
+
+{
+    U8                      ImageType;                  /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U16                     Reserved2;                  /* 0x02 */
+    U32                     Checksum;                   /* 0x04 */
+    U32                     ImageSize;                  /* 0x08 */
+    U32                     NextImageHeaderOffset;      /* 0x0C */
+    U32                     PackageVersion;             /* 0x10 */
+    U32                     Reserved3;                  /* 0x14 */
+    U32                     Reserved4;                  /* 0x18 */
+    U32                     Reserved5;                  /* 0x1C */
+    U8                      IdentifyString[32];         /* 0x20 */
+} MPI2_EXT_IMAGE_HEADER, MPI2_POINTER PTR_MPI2_EXT_IMAGE_HEADER,
+  Mpi2ExtImageHeader_t, MPI2_POINTER pMpi2ExtImageHeader_t;
+
+/* useful offsets */
+#define MPI2_EXT_IMAGE_IMAGETYPE_OFFSET         (0x00)
+#define MPI2_EXT_IMAGE_IMAGESIZE_OFFSET         (0x08)
+#define MPI2_EXT_IMAGE_NEXTIMAGE_OFFSET         (0x0C)
+
+#define MPI2_EXT_IMAGE_HEADER_SIZE              (0x40)
+
+/* defines for the ImageType field */
+#define MPI2_EXT_IMAGE_TYPE_UNSPECIFIED         (0x00)
+#define MPI2_EXT_IMAGE_TYPE_FW                  (0x01)
+#define MPI2_EXT_IMAGE_TYPE_NVDATA              (0x03)
+#define MPI2_EXT_IMAGE_TYPE_BOOTLOADER          (0x04)
+#define MPI2_EXT_IMAGE_TYPE_INITIALIZATION      (0x05)
+#define MPI2_EXT_IMAGE_TYPE_FLASH_LAYOUT        (0x06)
+#define MPI2_EXT_IMAGE_TYPE_SUPPORTED_DEVICES   (0x07)
+#define MPI2_EXT_IMAGE_TYPE_MEGARAID            (0x08)
+
+#define MPI2_EXT_IMAGE_TYPE_MAX                 (MPI2_EXT_IMAGE_TYPE_MEGARAID)
+
+
+
+/* FLASH Layout Extended Image Data */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check RegionsPerLayout at runtime.
+ */
+#ifndef MPI2_FLASH_NUMBER_OF_REGIONS
+#define MPI2_FLASH_NUMBER_OF_REGIONS        (1)
+#endif
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check NumberOfLayouts at runtime.
+ */
+#ifndef MPI2_FLASH_NUMBER_OF_LAYOUTS
+#define MPI2_FLASH_NUMBER_OF_LAYOUTS        (1)
+#endif
+
+typedef struct _MPI2_FLASH_REGION
+{
+    U8                      RegionType;                 /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U16                     Reserved2;                  /* 0x02 */
+    U32                     RegionOffset;               /* 0x04 */
+    U32                     RegionSize;                 /* 0x08 */
+    U32                     Reserved3;                  /* 0x0C */
+} MPI2_FLASH_REGION, MPI2_POINTER PTR_MPI2_FLASH_REGION,
+  Mpi2FlashRegion_t, MPI2_POINTER pMpi2FlashRegion_t;
+
+typedef struct _MPI2_FLASH_LAYOUT
+{
+    U32                     FlashSize;                  /* 0x00 */
+    U32                     Reserved1;                  /* 0x04 */
+    U32                     Reserved2;                  /* 0x08 */
+    U32                     Reserved3;                  /* 0x0C */
+    MPI2_FLASH_REGION       Region[MPI2_FLASH_NUMBER_OF_REGIONS];/* 0x10 */
+} MPI2_FLASH_LAYOUT, MPI2_POINTER PTR_MPI2_FLASH_LAYOUT,
+  Mpi2FlashLayout_t, MPI2_POINTER pMpi2FlashLayout_t;
+
+typedef struct _MPI2_FLASH_LAYOUT_DATA
+{
+    U8                      ImageRevision;              /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      SizeOfRegion;               /* 0x02 */
+    U8                      Reserved2;                  /* 0x03 */
+    U16                     NumberOfLayouts;            /* 0x04 */
+    U16                     RegionsPerLayout;           /* 0x06 */
+    U16                     MinimumSectorAlignment;     /* 0x08 */
+    U16                     Reserved3;                  /* 0x0A */
+    U32                     Reserved4;                  /* 0x0C */
+    MPI2_FLASH_LAYOUT       Layout[MPI2_FLASH_NUMBER_OF_LAYOUTS];/* 0x10 */
+} MPI2_FLASH_LAYOUT_DATA, MPI2_POINTER PTR_MPI2_FLASH_LAYOUT_DATA,
+  Mpi2FlashLayoutData_t, MPI2_POINTER pMpi2FlashLayoutData_t;
+
+/* defines for the RegionType field */
+#define MPI2_FLASH_REGION_UNUSED                (0x00)
+#define MPI2_FLASH_REGION_FIRMWARE              (0x01)
+#define MPI2_FLASH_REGION_BIOS                  (0x02)
+#define MPI2_FLASH_REGION_NVDATA                (0x03)
+#define MPI2_FLASH_REGION_FIRMWARE_BACKUP       (0x05)
+#define MPI2_FLASH_REGION_MFG_INFORMATION       (0x06)
+#define MPI2_FLASH_REGION_CONFIG_1              (0x07)
+#define MPI2_FLASH_REGION_CONFIG_2              (0x08)
+#define MPI2_FLASH_REGION_MEGARAID              (0x09)
+#define MPI2_FLASH_REGION_INIT                  (0x0A)
+
+/* ImageRevision */
+#define MPI2_FLASH_LAYOUT_IMAGE_REVISION        (0x00)
+
+
+
+/* Supported Devices Extended Image Data */
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check NumberOfDevices at runtime.
+ */
+#ifndef MPI2_SUPPORTED_DEVICES_IMAGE_NUM_DEVICES
+#define MPI2_SUPPORTED_DEVICES_IMAGE_NUM_DEVICES    (1)
+#endif
+
+typedef struct _MPI2_SUPPORTED_DEVICE
+{
+    U16                     DeviceID;                   /* 0x00 */
+    U16                     VendorID;                   /* 0x02 */
+    U16                     DeviceIDMask;               /* 0x04 */
+    U16                     Reserved1;                  /* 0x06 */
+    U8                      LowPCIRev;                  /* 0x08 */
+    U8                      HighPCIRev;                 /* 0x09 */
+    U16                     Reserved2;                  /* 0x0A */
+    U32                     Reserved3;                  /* 0x0C */
+} MPI2_SUPPORTED_DEVICE, MPI2_POINTER PTR_MPI2_SUPPORTED_DEVICE,
+  Mpi2SupportedDevice_t, MPI2_POINTER pMpi2SupportedDevice_t;
+
+typedef struct _MPI2_SUPPORTED_DEVICES_DATA
+{
+    U8                      ImageRevision;              /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      NumberOfDevices;            /* 0x02 */
+    U8                      Reserved2;                  /* 0x03 */
+    U32                     Reserved3;                  /* 0x04 */
+    MPI2_SUPPORTED_DEVICE   SupportedDevice[MPI2_SUPPORTED_DEVICES_IMAGE_NUM_DEVICES]; /* 0x08 */
+} MPI2_SUPPORTED_DEVICES_DATA, MPI2_POINTER PTR_MPI2_SUPPORTED_DEVICES_DATA,
+  Mpi2SupportedDevicesData_t, MPI2_POINTER pMpi2SupportedDevicesData_t;
+
+/* ImageRevision */
+#define MPI2_SUPPORTED_DEVICES_IMAGE_REVISION   (0x00)
+
+
+/* Init Extended Image Data */
+
+typedef struct _MPI2_INIT_IMAGE_FOOTER
+
+{
+    U32                     BootFlags;                  /* 0x00 */
+    U32                     ImageSize;                  /* 0x04 */
+    U32                     Signature0;                 /* 0x08 */
+    U32                     Signature1;                 /* 0x0C */
+    U32                     Signature2;                 /* 0x10 */
+    U32                     ResetVector;                /* 0x14 */
+} MPI2_INIT_IMAGE_FOOTER, MPI2_POINTER PTR_MPI2_INIT_IMAGE_FOOTER,
+  Mpi2InitImageFooter_t, MPI2_POINTER pMpi2InitImageFooter_t;
+
+/* defines for the BootFlags field */
+#define MPI2_INIT_IMAGE_BOOTFLAGS_OFFSET        (0x00)
+
+/* defines for the ImageSize field */
+#define MPI2_INIT_IMAGE_IMAGESIZE_OFFSET        (0x04)
+
+/* defines for the Signature0 field */
+#define MPI2_INIT_IMAGE_SIGNATURE0_OFFSET       (0x08)
+#define MPI2_INIT_IMAGE_SIGNATURE0              (0x5AA55AEA)
+
+/* defines for the Signature1 field */
+#define MPI2_INIT_IMAGE_SIGNATURE1_OFFSET       (0x0C)
+#define MPI2_INIT_IMAGE_SIGNATURE1              (0xA55AEAA5)
+
+/* defines for the Signature2 field */
+#define MPI2_INIT_IMAGE_SIGNATURE2_OFFSET       (0x10)
+#define MPI2_INIT_IMAGE_SIGNATURE2              (0x5AEAA55A)
+
+/* Signature fields as individual bytes */
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_0        (0xEA)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_1        (0x5A)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_2        (0xA5)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_3        (0x5A)
+
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_4        (0xA5)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_5        (0xEA)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_6        (0x5A)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_7        (0xA5)
+
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_8        (0x5A)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_9        (0xA5)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_A        (0xEA)
+#define MPI2_INIT_IMAGE_SIGNATURE_BYTE_B        (0x5A)
+
+/* defines for the ResetVector field */
+#define MPI2_INIT_IMAGE_RESETVECTOR_OFFSET      (0x14)
+
+
+#endif
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_raid.h b/drivers/scsi/mpt2sas/mpi/mpi2_raid.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_raid.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_raid.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,295 @@
+/*
+ *  Copyright (c) 2000-2008 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_raid.h
+ *          Title:  MPI Integrated RAID messages and structures
+ *  Creation Date:  April 26, 2007
+ *
+ *    mpi2_raid.h Version:  02.00.03
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  08-31-07  02.00.01  Modifications to RAID Action request and reply,
+ *                      including the Actions and ActionData.
+ *  02-29-08  02.00.02  Added MPI2_RAID_ACTION_ADATA_DISABL_FULL_REBUILD.
+ *  05-21-08  02.00.03  Added MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS so that
+ *                      the PhysDisk array in MPI2_RAID_VOLUME_CREATION_STRUCT
+ *                      can be sized by the build environment.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_RAID_H
+#define MPI2_RAID_H
+
+/*****************************************************************************
+*
+*               Integrated RAID Messages
+*
+*****************************************************************************/
+
+/****************************************************************************
+*  RAID Action messages
+****************************************************************************/
+
+/* ActionDataWord defines for use with MPI2_RAID_ACTION_DELETE_VOLUME action */
+#define MPI2_RAID_ACTION_ADATA_KEEP_LBA0            (0x00000000)
+#define MPI2_RAID_ACTION_ADATA_ZERO_LBA0            (0x00000001)
+
+/* use MPI2_RAIDVOL0_SETTING_ defines from mpi2_cnfg.h for MPI2_RAID_ACTION_CHANGE_VOL_WRITE_CACHE action */
+
+/* ActionDataWord defines for use with MPI2_RAID_ACTION_DISABLE_ALL_VOLUMES action */
+#define MPI2_RAID_ACTION_ADATA_DISABL_FULL_REBUILD  (0x00000001)
+
+/* ActionDataWord for MPI2_RAID_ACTION_SET_RAID_FUNCTION_RATE Action */
+typedef struct _MPI2_RAID_ACTION_RATE_DATA
+{
+    U8              RateToChange;               /* 0x00 */
+    U8              RateOrMode;                 /* 0x01 */
+    U16             DataScrubDuration;          /* 0x02 */
+} MPI2_RAID_ACTION_RATE_DATA, MPI2_POINTER PTR_MPI2_RAID_ACTION_RATE_DATA,
+  Mpi2RaidActionRateData_t, MPI2_POINTER pMpi2RaidActionRateData_t;
+
+#define MPI2_RAID_ACTION_SET_RATE_RESYNC            (0x00)
+#define MPI2_RAID_ACTION_SET_RATE_DATA_SCRUB        (0x01)
+#define MPI2_RAID_ACTION_SET_RATE_POWERSAVE_MODE    (0x02)
+
+/* ActionDataWord for MPI2_RAID_ACTION_START_RAID_FUNCTION Action */
+typedef struct _MPI2_RAID_ACTION_START_RAID_FUNCTION
+{
+    U8              RAIDFunction;                       /* 0x00 */
+    U8              Flags;                              /* 0x01 */
+    U16             Reserved1;                          /* 0x02 */
+} MPI2_RAID_ACTION_START_RAID_FUNCTION,
+  MPI2_POINTER PTR_MPI2_RAID_ACTION_START_RAID_FUNCTION,
+  Mpi2RaidActionStartRaidFunction_t,
+  MPI2_POINTER pMpi2RaidActionStartRaidFunction_t;
+
+/* defines for the RAIDFunction field */
+#define MPI2_RAID_ACTION_START_BACKGROUND_INIT      (0x00)
+#define MPI2_RAID_ACTION_START_ONLINE_CAP_EXPANSION (0x01)
+#define MPI2_RAID_ACTION_START_CONSISTENCY_CHECK    (0x02)
+
+/* defines for the Flags field */
+#define MPI2_RAID_ACTION_START_NEW                  (0x00)
+#define MPI2_RAID_ACTION_START_RESUME               (0x01)
+
+/* ActionDataWord for MPI2_RAID_ACTION_STOP_RAID_FUNCTION Action */
+typedef struct _MPI2_RAID_ACTION_STOP_RAID_FUNCTION
+{
+    U8              RAIDFunction;                       /* 0x00 */
+    U8              Flags;                              /* 0x01 */
+    U16             Reserved1;                          /* 0x02 */
+} MPI2_RAID_ACTION_STOP_RAID_FUNCTION,
+  MPI2_POINTER PTR_MPI2_RAID_ACTION_STOP_RAID_FUNCTION,
+  Mpi2RaidActionStopRaidFunction_t,
+  MPI2_POINTER pMpi2RaidActionStopRaidFunction_t;
+
+/* defines for the RAIDFunction field */
+#define MPI2_RAID_ACTION_STOP_BACKGROUND_INIT       (0x00)
+#define MPI2_RAID_ACTION_STOP_ONLINE_CAP_EXPANSION  (0x01)
+#define MPI2_RAID_ACTION_STOP_CONSISTENCY_CHECK     (0x02)
+
+/* defines for the Flags field */
+#define MPI2_RAID_ACTION_STOP_ABORT                 (0x00)
+#define MPI2_RAID_ACTION_STOP_PAUSE                 (0x01)
+
+/* ActionDataWord for MPI2_RAID_ACTION_CREATE_HOT_SPARE Action */
+typedef struct _MPI2_RAID_ACTION_HOT_SPARE
+{
+    U8              HotSparePool;               /* 0x00 */
+    U8              Reserved1;                  /* 0x01 */
+    U16             DevHandle;                  /* 0x02 */
+} MPI2_RAID_ACTION_HOT_SPARE, MPI2_POINTER PTR_MPI2_RAID_ACTION_HOT_SPARE,
+  Mpi2RaidActionHotSpare_t, MPI2_POINTER pMpi2RaidActionHotSpare_t;
+
+/* ActionDataWord for MPI2_RAID_ACTION_DEVICE_FW_UPDATE_MODE Action */
+typedef struct _MPI2_RAID_ACTION_FW_UPDATE_MODE
+{
+    U8              Flags;                              /* 0x00 */
+    U8              DeviceFirmwareUpdateModeTimeout;    /* 0x01 */
+    U16             Reserved1;                          /* 0x02 */
+} MPI2_RAID_ACTION_FW_UPDATE_MODE,
+  MPI2_POINTER PTR_MPI2_RAID_ACTION_FW_UPDATE_MODE,
+  Mpi2RaidActionFwUpdateMode_t, MPI2_POINTER pMpi2RaidActionFwUpdateMode_t;
+
+/* ActionDataWord defines for use with MPI2_RAID_ACTION_DEVICE_FW_UPDATE_MODE action */
+#define MPI2_RAID_ACTION_ADATA_DISABLE_FW_UPDATE        (0x00)
+#define MPI2_RAID_ACTION_ADATA_ENABLE_FW_UPDATE         (0x01)
+
+typedef union _MPI2_RAID_ACTION_DATA
+{
+    U32                                     Word;
+    MPI2_RAID_ACTION_RATE_DATA              Rates;
+    MPI2_RAID_ACTION_START_RAID_FUNCTION    StartRaidFunction;
+    MPI2_RAID_ACTION_STOP_RAID_FUNCTION     StopRaidFunction;
+    MPI2_RAID_ACTION_HOT_SPARE              HotSpare;
+    MPI2_RAID_ACTION_FW_UPDATE_MODE         FwUpdateMode;
+} MPI2_RAID_ACTION_DATA, MPI2_POINTER PTR_MPI2_RAID_ACTION_DATA,
+  Mpi2RaidActionData_t, MPI2_POINTER pMpi2RaidActionData_t;
+
+
+/* RAID Action Request Message */
+typedef struct _MPI2_RAID_ACTION_REQUEST
+{
+    U8                      Action;                         /* 0x00 */
+    U8                      Reserved1;                      /* 0x01 */
+    U8                      ChainOffset;                    /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     VolDevHandle;                   /* 0x04 */
+    U8                      PhysDiskNum;                    /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U8                      VP_ID;                          /* 0x08 */
+    U8                      VF_ID;                          /* 0x09 */
+    U16                     Reserved2;                      /* 0x0A */
+    U32                     Reserved3;                      /* 0x0C */
+    MPI2_RAID_ACTION_DATA   ActionDataWord;                 /* 0x10 */
+    MPI2_SGE_SIMPLE_UNION   ActionDataSGE;                  /* 0x14 */
+} MPI2_RAID_ACTION_REQUEST, MPI2_POINTER PTR_MPI2_RAID_ACTION_REQUEST,
+  Mpi2RaidActionRequest_t, MPI2_POINTER pMpi2RaidActionRequest_t;
+
+/* RAID Action request Action values */
+
+#define MPI2_RAID_ACTION_INDICATOR_STRUCT           (0x01)
+#define MPI2_RAID_ACTION_CREATE_VOLUME              (0x02)
+#define MPI2_RAID_ACTION_DELETE_VOLUME              (0x03)
+#define MPI2_RAID_ACTION_DISABLE_ALL_VOLUMES        (0x04)
+#define MPI2_RAID_ACTION_ENABLE_ALL_VOLUMES         (0x05)
+#define MPI2_RAID_ACTION_PHYSDISK_OFFLINE           (0x0A)
+#define MPI2_RAID_ACTION_PHYSDISK_ONLINE            (0x0B)
+#define MPI2_RAID_ACTION_FAIL_PHYSDISK              (0x0F)
+#define MPI2_RAID_ACTION_ACTIVATE_VOLUME            (0x11)
+#define MPI2_RAID_ACTION_DEVICE_FW_UPDATE_MODE      (0x15)
+#define MPI2_RAID_ACTION_CHANGE_VOL_WRITE_CACHE     (0x17)
+#define MPI2_RAID_ACTION_SET_VOLUME_NAME            (0x18)
+#define MPI2_RAID_ACTION_SET_RAID_FUNCTION_RATE     (0x19)
+#define MPI2_RAID_ACTION_ENABLE_FAILED_VOLUME       (0x1C)
+#define MPI2_RAID_ACTION_CREATE_HOT_SPARE           (0x1D)
+#define MPI2_RAID_ACTION_DELETE_HOT_SPARE           (0x1E)
+#define MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED  (0x20)
+#define MPI2_RAID_ACTION_START_RAID_FUNCTION        (0x21)
+#define MPI2_RAID_ACTION_STOP_RAID_FUNCTION         (0x22)
+
+
+/* RAID Volume Creation Structure */
+
+/*
+ * The following define can be customized for the targeted product.
+ */
+#ifndef MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS
+#define MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS        (1)
+#endif
+
+typedef struct _MPI2_RAID_VOLUME_PHYSDISK
+{
+    U8                      RAIDSetNum;                     /* 0x00 */
+    U8                      PhysDiskMap;                    /* 0x01 */
+    U16                     PhysDiskDevHandle;              /* 0x02 */
+} MPI2_RAID_VOLUME_PHYSDISK, MPI2_POINTER PTR_MPI2_RAID_VOLUME_PHYSDISK,
+  Mpi2RaidVolumePhysDisk_t, MPI2_POINTER pMpi2RaidVolumePhysDisk_t;
+
+/* defines for the PhysDiskMap field */
+#define MPI2_RAIDACTION_PHYSDISK_PRIMARY            (0x01)
+#define MPI2_RAIDACTION_PHYSDISK_SECONDARY          (0x02)
+
+typedef struct _MPI2_RAID_VOLUME_CREATION_STRUCT
+{
+    U8                          NumPhysDisks;               /* 0x00 */
+    U8                          VolumeType;                 /* 0x01 */
+    U16                         Reserved1;                  /* 0x02 */
+    U32                         VolumeCreationFlags;        /* 0x04 */
+    U32                         VolumeSettings;             /* 0x08 */
+    U8                          Reserved2;                  /* 0x0C */
+    U8                          ResyncRate;                 /* 0x0D */
+    U16                         DataScrubDuration;          /* 0x0E */
+    U64                         VolumeMaxLBA;               /* 0x10 */
+    U32                         StripeSize;                 /* 0x18 */
+    U8                          Name[16];                   /* 0x1C */
+    MPI2_RAID_VOLUME_PHYSDISK   PhysDisk[MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS];/* 0x2C */
+} MPI2_RAID_VOLUME_CREATION_STRUCT,
+  MPI2_POINTER PTR_MPI2_RAID_VOLUME_CREATION_STRUCT,
+  Mpi2RaidVolumeCreationStruct_t, MPI2_POINTER pMpi2RaidVolumeCreationStruct_t;
+
+/* use MPI2_RAID_VOL_TYPE_ defines from mpi2_cnfg.h for VolumeType */
+
+/* defines for the VolumeCreationFlags field */
+#define MPI2_RAID_VOL_CREATION_USE_DEFAULT_SETTINGS (0x80)
+#define MPI2_RAID_VOL_CREATION_BACKGROUND_INIT      (0x04)
+#define MPI2_RAID_VOL_CREATION_LOW_LEVEL_INIT       (0x02)
+#define MPI2_RAID_VOL_CREATION_MIGRATE_DATA         (0x01)
+
+
+/* RAID Online Capacity Expansion Structure */
+
+typedef struct _MPI2_RAID_ONLINE_CAPACITY_EXPANSION
+{
+    U32                     Flags;                          /* 0x00 */
+    U16                     DevHandle0;                     /* 0x04 */
+    U16                     Reserved1;                      /* 0x06 */
+    U16                     DevHandle1;                     /* 0x08 */
+    U16                     Reserved2;                      /* 0x0A */
+} MPI2_RAID_ONLINE_CAPACITY_EXPANSION,
+  MPI2_POINTER PTR_MPI2_RAID_ONLINE_CAPACITY_EXPANSION,
+  Mpi2RaidOnlineCapacityExpansion_t,
+  MPI2_POINTER pMpi2RaidOnlineCapacityExpansion_t;
+
+
+/* RAID Volume Indicator Structure */
+
+typedef struct _MPI2_RAID_VOL_INDICATOR
+{
+    U64                     TotalBlocks;                    /* 0x00 */
+    U64                     BlocksRemaining;                /* 0x08 */
+    U32                     Flags;                          /* 0x10 */
+} MPI2_RAID_VOL_INDICATOR, MPI2_POINTER PTR_MPI2_RAID_VOL_INDICATOR,
+  Mpi2RaidVolIndicator_t, MPI2_POINTER pMpi2RaidVolIndicator_t;
+
+/* defines for RAID Volume Indicator Flags field */
+#define MPI2_RAID_VOL_FLAGS_OP_MASK                 (0x0000000F)
+#define MPI2_RAID_VOL_FLAGS_OP_BACKGROUND_INIT      (0x00000000)
+#define MPI2_RAID_VOL_FLAGS_OP_ONLINE_CAP_EXPANSION (0x00000001)
+#define MPI2_RAID_VOL_FLAGS_OP_CONSISTENCY_CHECK    (0x00000002)
+#define MPI2_RAID_VOL_FLAGS_OP_RESYNC               (0x00000003)
+
+
+/* RAID Action Reply ActionData union */
+typedef union _MPI2_RAID_ACTION_REPLY_DATA
+{
+    U32                     Word[5];
+    MPI2_RAID_VOL_INDICATOR RaidVolumeIndicator;
+    U16                     VolDevHandle;
+    U8                      VolumeState;
+    U8                      PhysDiskNum;
+} MPI2_RAID_ACTION_REPLY_DATA, MPI2_POINTER PTR_MPI2_RAID_ACTION_REPLY_DATA,
+  Mpi2RaidActionReplyData_t, MPI2_POINTER pMpi2RaidActionReplyData_t;
+
+/* use MPI2_RAIDVOL0_SETTING_ defines from mpi2_cnfg.h for MPI2_RAID_ACTION_CHANGE_VOL_WRITE_CACHE action */
+
+
+/* RAID Action Reply Message */
+typedef struct _MPI2_RAID_ACTION_REPLY
+{
+    U8                          Action;                     /* 0x00 */
+    U8                          Reserved1;                  /* 0x01 */
+    U8                          MsgLength;                  /* 0x02 */
+    U8                          Function;                   /* 0x03 */
+    U16                         VolDevHandle;               /* 0x04 */
+    U8                          PhysDiskNum;                /* 0x06 */
+    U8                          MsgFlags;                   /* 0x07 */
+    U8                          VP_ID;                      /* 0x08 */
+    U8                          VF_ID;                      /* 0x09 */
+    U16                         Reserved2;                  /* 0x0A */
+    U16                         Reserved3;                  /* 0x0C */
+    U16                         IOCStatus;                  /* 0x0E */
+    U32                         IOCLogInfo;                 /* 0x10 */
+    MPI2_RAID_ACTION_REPLY_DATA ActionData;                 /* 0x14 */
+} MPI2_RAID_ACTION_REPLY, MPI2_POINTER PTR_MPI2_RAID_ACTION_REPLY,
+  Mpi2RaidActionReply_t, MPI2_POINTER pMpi2RaidActionReply_t;
+
+
+#endif
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_sas.h b/drivers/scsi/mpt2sas/mpi/mpi2_sas.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_sas.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_sas.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,282 @@
+/*
+ *  Copyright (c) 2000-2007 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_sas.h
+ *          Title:  MPI Serial Attached SCSI structures and definitions
+ *  Creation Date:  February 9, 2007
+ *
+ *  mpi2.h Version:  02.00.02
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-26-07  02.00.01  Added Clear All Persistent Operation to SAS IO Unit
+ *                      Control Request.
+ *  10-02-08  02.00.02  Added Set IOC Parameter Operation to SAS IO Unit Control
+ *                      Request.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_SAS_H
+#define MPI2_SAS_H
+
+/*
+ * Values for SASStatus.
+ */
+#define MPI2_SASSTATUS_SUCCESS                          (0x00)
+#define MPI2_SASSTATUS_UNKNOWN_ERROR                    (0x01)
+#define MPI2_SASSTATUS_INVALID_FRAME                    (0x02)
+#define MPI2_SASSTATUS_UTC_BAD_DEST                     (0x03)
+#define MPI2_SASSTATUS_UTC_BREAK_RECEIVED               (0x04)
+#define MPI2_SASSTATUS_UTC_CONNECT_RATE_NOT_SUPPORTED   (0x05)
+#define MPI2_SASSTATUS_UTC_PORT_LAYER_REQUEST           (0x06)
+#define MPI2_SASSTATUS_UTC_PROTOCOL_NOT_SUPPORTED       (0x07)
+#define MPI2_SASSTATUS_UTC_STP_RESOURCES_BUSY           (0x08)
+#define MPI2_SASSTATUS_UTC_WRONG_DESTINATION            (0x09)
+#define MPI2_SASSTATUS_SHORT_INFORMATION_UNIT           (0x0A)
+#define MPI2_SASSTATUS_LONG_INFORMATION_UNIT            (0x0B)
+#define MPI2_SASSTATUS_XFER_RDY_INCORRECT_WRITE_DATA    (0x0C)
+#define MPI2_SASSTATUS_XFER_RDY_REQUEST_OFFSET_ERROR    (0x0D)
+#define MPI2_SASSTATUS_XFER_RDY_NOT_EXPECTED            (0x0E)
+#define MPI2_SASSTATUS_DATA_INCORRECT_DATA_LENGTH       (0x0F)
+#define MPI2_SASSTATUS_DATA_TOO_MUCH_READ_DATA          (0x10)
+#define MPI2_SASSTATUS_DATA_OFFSET_ERROR                (0x11)
+#define MPI2_SASSTATUS_SDSF_NAK_RECEIVED                (0x12)
+#define MPI2_SASSTATUS_SDSF_CONNECTION_FAILED           (0x13)
+#define MPI2_SASSTATUS_INITIATOR_RESPONSE_TIMEOUT       (0x14)
+
+
+/*
+ * Values for the SAS DeviceInfo field used in SAS Device Status Change Event
+ * data and SAS Configuration pages.
+ */
+#define MPI2_SAS_DEVICE_INFO_SEP                (0x00004000)
+#define MPI2_SAS_DEVICE_INFO_ATAPI_DEVICE       (0x00002000)
+#define MPI2_SAS_DEVICE_INFO_LSI_DEVICE         (0x00001000)
+#define MPI2_SAS_DEVICE_INFO_DIRECT_ATTACH      (0x00000800)
+#define MPI2_SAS_DEVICE_INFO_SSP_TARGET         (0x00000400)
+#define MPI2_SAS_DEVICE_INFO_STP_TARGET         (0x00000200)
+#define MPI2_SAS_DEVICE_INFO_SMP_TARGET         (0x00000100)
+#define MPI2_SAS_DEVICE_INFO_SATA_DEVICE        (0x00000080)
+#define MPI2_SAS_DEVICE_INFO_SSP_INITIATOR      (0x00000040)
+#define MPI2_SAS_DEVICE_INFO_STP_INITIATOR      (0x00000020)
+#define MPI2_SAS_DEVICE_INFO_SMP_INITIATOR      (0x00000010)
+#define MPI2_SAS_DEVICE_INFO_SATA_HOST          (0x00000008)
+
+#define MPI2_SAS_DEVICE_INFO_MASK_DEVICE_TYPE   (0x00000007)
+#define MPI2_SAS_DEVICE_INFO_NO_DEVICE          (0x00000000)
+#define MPI2_SAS_DEVICE_INFO_END_DEVICE         (0x00000001)
+#define MPI2_SAS_DEVICE_INFO_EDGE_EXPANDER      (0x00000002)
+#define MPI2_SAS_DEVICE_INFO_FANOUT_EXPANDER    (0x00000003)
+
+
+/*****************************************************************************
+*
+*        SAS Messages
+*
+*****************************************************************************/
+
+/****************************************************************************
+*  SMP Passthrough messages
+****************************************************************************/
+
+/* SMP Passthrough Request Message */
+typedef struct _MPI2_SMP_PASSTHROUGH_REQUEST
+{
+    U8                      PassthroughFlags;   /* 0x00 */
+    U8                      PhysicalPort;       /* 0x01 */
+    U8                      ChainOffset;        /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U16                     RequestDataLength;  /* 0x04 */
+    U8                      SGLFlags;           /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved1;          /* 0x0A */
+    U32                     Reserved2;          /* 0x0C */
+    U64                     SASAddress;         /* 0x10 */
+    U32                     Reserved3;          /* 0x18 */
+    U32                     Reserved4;          /* 0x1C */
+    MPI2_SIMPLE_SGE_UNION   SGL;                /* 0x20 */
+} MPI2_SMP_PASSTHROUGH_REQUEST, MPI2_POINTER PTR_MPI2_SMP_PASSTHROUGH_REQUEST,
+  Mpi2SmpPassthroughRequest_t, MPI2_POINTER pMpi2SmpPassthroughRequest_t;
+
+/* values for PassthroughFlags field */
+#define MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE      (0x80)
+
+/* values for SGLFlags field are in the SGL section of mpi2.h */
+
+
+/* SMP Passthrough Reply Message */
+typedef struct _MPI2_SMP_PASSTHROUGH_REPLY
+{
+    U8                      PassthroughFlags;   /* 0x00 */
+    U8                      PhysicalPort;       /* 0x01 */
+    U8                      MsgLength;          /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U16                     ResponseDataLength; /* 0x04 */
+    U8                      SGLFlags;           /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved1;          /* 0x0A */
+    U8                      Reserved2;          /* 0x0C */
+    U8                      SASStatus;          /* 0x0D */
+    U16                     IOCStatus;          /* 0x0E */
+    U32                     IOCLogInfo;         /* 0x10 */
+    U32                     Reserved3;          /* 0x14 */
+    U8                      ResponseData[4];    /* 0x18 */
+} MPI2_SMP_PASSTHROUGH_REPLY, MPI2_POINTER PTR_MPI2_SMP_PASSTHROUGH_REPLY,
+  Mpi2SmpPassthroughReply_t, MPI2_POINTER pMpi2SmpPassthroughReply_t;
+
+/* values for PassthroughFlags field */
+#define MPI2_SMP_PT_REPLY_PT_FLAGS_IMMEDIATE    (0x80)
+
+/* values for SASStatus field are at the top of this file */
+
+
+/****************************************************************************
+*  SATA Passthrough messages
+****************************************************************************/
+
+/* SATA Passthrough Request Message */
+typedef struct _MPI2_SATA_PASSTHROUGH_REQUEST
+{
+    U16                     DevHandle;          /* 0x00 */
+    U8                      ChainOffset;        /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U16                     PassthroughFlags;   /* 0x04 */
+    U8                      SGLFlags;           /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved1;          /* 0x0A */
+    U32                     Reserved2;          /* 0x0C */
+    U32                     Reserved3;          /* 0x10 */
+    U32                     Reserved4;          /* 0x14 */
+    U32                     DataLength;         /* 0x18 */
+    U8                      CommandFIS[20];     /* 0x1C */
+    MPI2_SIMPLE_SGE_UNION   SGL;                /* 0x20 */
+} MPI2_SATA_PASSTHROUGH_REQUEST, MPI2_POINTER PTR_MPI2_SATA_PASSTHROUGH_REQUEST,
+  Mpi2SataPassthroughRequest_t, MPI2_POINTER pMpi2SataPassthroughRequest_t;
+
+/* values for PassthroughFlags field */
+#define MPI2_SATA_PT_REQ_PT_FLAGS_EXECUTE_DIAG      (0x0100)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_DMA               (0x0020)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_PIO               (0x0010)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_UNSPECIFIED_VU    (0x0004)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_WRITE             (0x0002)
+#define MPI2_SATA_PT_REQ_PT_FLAGS_READ              (0x0001)
+
+/* values for SGLFlags field are in the SGL section of mpi2.h */
+
+
+/* SATA Passthrough Reply Message */
+typedef struct _MPI2_SATA_PASSTHROUGH_REPLY
+{
+    U16                     DevHandle;          /* 0x00 */
+    U8                      MsgLength;          /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U16                     PassthroughFlags;   /* 0x04 */
+    U8                      SGLFlags;           /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved1;          /* 0x0A */
+    U8                      Reserved2;          /* 0x0C */
+    U8                      SASStatus;          /* 0x0D */
+    U16                     IOCStatus;          /* 0x0E */
+    U32                     IOCLogInfo;         /* 0x10 */
+    U8                      StatusFIS[20];      /* 0x14 */
+    U32                     StatusControlRegisters; /* 0x28 */
+    U32                     TransferCount;      /* 0x2C */
+} MPI2_SATA_PASSTHROUGH_REPLY, MPI2_POINTER PTR_MPI2_SATA_PASSTHROUGH_REPLY,
+  Mpi2SataPassthroughReply_t, MPI2_POINTER pMpi2SataPassthroughReply_t;
+
+/* values for SASStatus field are at the top of this file */
+
+
+/****************************************************************************
+*  SAS IO Unit Control messages
+****************************************************************************/
+
+/* SAS IO Unit Control Request Message */
+typedef struct _MPI2_SAS_IOUNIT_CONTROL_REQUEST
+{
+    U8                      Operation;          /* 0x00 */
+    U8                      Reserved1;          /* 0x01 */
+    U8                      ChainOffset;        /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U16                     DevHandle;          /* 0x04 */
+    U8                      IOCParameter;       /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved3;          /* 0x0A */
+    U16                     Reserved4;          /* 0x0C */
+    U8                      PhyNum;             /* 0x0E */
+    U8                      PrimFlags;          /* 0x0F */
+    U32                     Primitive;          /* 0x10 */
+    U8                      LookupMethod;       /* 0x14 */
+    U8                      Reserved5;          /* 0x15 */
+    U16                     SlotNumber;         /* 0x16 */
+    U64                     LookupAddress;      /* 0x18 */
+    U32                     IOCParameterValue;  /* 0x20 */
+    U32                     Reserved7;          /* 0x24 */
+    U32                     Reserved8;          /* 0x28 */
+} MPI2_SAS_IOUNIT_CONTROL_REQUEST,
+  MPI2_POINTER PTR_MPI2_SAS_IOUNIT_CONTROL_REQUEST,
+  Mpi2SasIoUnitControlRequest_t, MPI2_POINTER pMpi2SasIoUnitControlRequest_t;
+
+/* values for the Operation field */
+#define MPI2_SAS_OP_CLEAR_ALL_PERSISTENT        (0x02)
+#define MPI2_SAS_OP_PHY_LINK_RESET              (0x06)
+#define MPI2_SAS_OP_PHY_HARD_RESET              (0x07)
+#define MPI2_SAS_OP_PHY_CLEAR_ERROR_LOG         (0x08)
+#define MPI2_SAS_OP_SEND_PRIMITIVE              (0x0A)
+#define MPI2_SAS_OP_FORCE_FULL_DISCOVERY        (0x0B)
+#define MPI2_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL (0x0C)
+#define MPI2_SAS_OP_REMOVE_DEVICE               (0x0D)
+#define MPI2_SAS_OP_LOOKUP_MAPPING              (0x0E)
+#define MPI2_SAS_OP_SET_IOC_PARAMETER           (0x0F)
+#define MPI2_SAS_OP_PRODUCT_SPECIFIC_MIN        (0x80)
+
+/* values for the PrimFlags field */
+#define MPI2_SAS_PRIMFLAGS_SINGLE               (0x08)
+#define MPI2_SAS_PRIMFLAGS_TRIPLE               (0x02)
+#define MPI2_SAS_PRIMFLAGS_REDUNDANT            (0x01)
+
+/* values for the LookupMethod field */
+#define MPI2_SAS_LOOKUP_METHOD_SAS_ADDRESS          (0x01)
+#define MPI2_SAS_LOOKUP_METHOD_SAS_ENCLOSURE_SLOT   (0x02)
+#define MPI2_SAS_LOOKUP_METHOD_SAS_DEVICE_NAME      (0x03)
+
+
+/* SAS IO Unit Control Reply Message */
+typedef struct _MPI2_SAS_IOUNIT_CONTROL_REPLY
+{
+    U8                      Operation;          /* 0x00 */
+    U8                      Reserved1;          /* 0x01 */
+    U8                      MsgLength;          /* 0x02 */
+    U8                      Function;           /* 0x03 */
+    U16                     DevHandle;          /* 0x04 */
+    U8                      IOCParameter;       /* 0x06 */
+    U8                      MsgFlags;           /* 0x07 */
+    U8                      VP_ID;              /* 0x08 */
+    U8                      VF_ID;              /* 0x09 */
+    U16                     Reserved3;          /* 0x0A */
+    U16                     Reserved4;          /* 0x0C */
+    U16                     IOCStatus;          /* 0x0E */
+    U32                     IOCLogInfo;         /* 0x10 */
+} MPI2_SAS_IOUNIT_CONTROL_REPLY,
+  MPI2_POINTER PTR_MPI2_SAS_IOUNIT_CONTROL_REPLY,
+  Mpi2SasIoUnitControlReply_t, MPI2_POINTER pMpi2SasIoUnitControlReply_t;
+
+
+#endif
+
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_targ.h b/drivers/scsi/mpt2sas/mpi/mpi2_targ.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_targ.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_targ.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,440 @@
+/*
+ *  Copyright (c) 2000-2008 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_targ.h
+ *          Title:  MPI Target mode messages and structures
+ *  Creation Date:  September 8, 2006
+ *
+ *    mpi2_targ.h Version: 02.00.03
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  08-31-07  02.00.01  Added Command Buffer Data Location Address Space bits to
+ *                      BufferPostFlags field of CommandBufferPostBase Request.
+ *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  10-02-08  02.00.03  Removed NextCmdBufferOffset from
+ *                      MPI2_TARGET_CMD_BUF_POST_BASE_REQUEST.
+ *                      Target Status Send Request only takes a single SGE for
+ *                      response data.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_TARG_H
+#define MPI2_TARG_H
+
+
+/******************************************************************************
+*
+*        SCSI Target Messages
+*
+*******************************************************************************/
+
+/****************************************************************************
+*  Target Command Buffer Post Base Request
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_CMD_BUF_POST_BASE_REQUEST
+{
+    U8                      BufferPostFlags;        /* 0x00 */
+    U8                      Reserved1;              /* 0x01 */
+    U8                      ChainOffset;            /* 0x02 */
+    U8                      Function;               /* 0x03 */
+    U16                     TotalCmdBuffers;        /* 0x04 */
+    U8                      Reserved;               /* 0x06 */
+    U8                      MsgFlags;               /* 0x07 */
+    U8                      VP_ID;                  /* 0x08 */
+    U8                      VF_ID;                  /* 0x09 */
+    U16                     Reserved2;              /* 0x0A */
+    U32                     Reserved3;              /* 0x0C */
+    U16                     CmdBufferLength;        /* 0x10 */
+    U16                     Reserved4;              /* 0x12 */
+    U32                     BaseAddressLow;         /* 0x14 */
+    U32                     BaseAddressHigh;        /* 0x18 */
+} MPI2_TARGET_CMD_BUF_POST_BASE_REQUEST,
+  MPI2_POINTER PTR_MPI2_TARGET_CMD_BUF_POST_BASE_REQUEST,
+  Mpi2TargetCmdBufferPostBaseRequest_t,
+  MPI2_POINTER pMpi2TargetCmdBufferPostBaseRequest_t;
+
+/* values for the BufferPostflags field */
+#define MPI2_CMD_BUF_POST_BASE_ADDRESS_SPACE_MASK            (0x0C)
+#define MPI2_CMD_BUF_POST_BASE_SYSTEM_ADDRESS_SPACE          (0x00)
+#define MPI2_CMD_BUF_POST_BASE_IOCDDR_ADDRESS_SPACE          (0x04)
+#define MPI2_CMD_BUF_POST_BASE_IOCPLB_ADDRESS_SPACE          (0x08)
+#define MPI2_CMD_BUF_POST_BASE_IOCPLBNTA_ADDRESS_SPACE       (0x0C)
+
+#define MPI2_CMD_BUF_POST_BASE_FLAGS_AUTO_POST_ALL           (0x01)
+
+
+/****************************************************************************
+*  Target Command Buffer Post List Request
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_CMD_BUF_POST_LIST_REQUEST
+{
+    U16                     Reserved;               /* 0x00 */
+    U8                      ChainOffset;            /* 0x02 */
+    U8                      Function;               /* 0x03 */
+    U16                     CmdBufferCount;         /* 0x04 */
+    U8                      Reserved1;              /* 0x06 */
+    U8                      MsgFlags;               /* 0x07 */
+    U8                      VP_ID;                  /* 0x08 */
+    U8                      VF_ID;                  /* 0x09 */
+    U16                     Reserved2;              /* 0x0A */
+    U32                     Reserved3;              /* 0x0C */
+    U16                     IoIndex[2];             /* 0x10 */
+} MPI2_TARGET_CMD_BUF_POST_LIST_REQUEST,
+  MPI2_POINTER PTR_MPI2_TARGET_CMD_BUF_POST_LIST_REQUEST,
+  Mpi2TargetCmdBufferPostListRequest_t,
+  MPI2_POINTER pMpi2TargetCmdBufferPostListRequest_t;
+
+/****************************************************************************
+*  Target Command Buffer Post Base List Reply
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_BUF_POST_BASE_LIST_REPLY
+{
+    U8                      Flags;                  /* 0x00 */
+    U8                      Reserved;               /* 0x01 */
+    U8                      MsgLength;              /* 0x02 */
+    U8                      Function;               /* 0x03 */
+    U16                     Reserved1;              /* 0x04 */
+    U8                      Reserved2;              /* 0x06 */
+    U8                      MsgFlags;               /* 0x07 */
+    U8                      VP_ID;                  /* 0x08 */
+    U8                      VF_ID;                  /* 0x09 */
+    U16                     Reserved3;              /* 0x0A */
+    U16                     Reserved4;              /* 0x0C */
+    U16                     IOCStatus;              /* 0x0E */
+    U32                     IOCLogInfo;             /* 0x10 */
+    U16                     IoIndex;                /* 0x14 */
+    U16                     Reserved5;              /* 0x16 */
+    U32                     Reserved6;              /* 0x18 */
+} MPI2_TARGET_BUF_POST_BASE_LIST_REPLY,
+  MPI2_POINTER PTR_MPI2_TARGET_BUF_POST_BASE_LIST_REPLY,
+  Mpi2TargetCmdBufferPostBaseListReply_t,
+  MPI2_POINTER pMpi2TargetCmdBufferPostBaseListReply_t;
+
+/* Flags defines */
+#define MPI2_CMD_BUF_POST_REPLY_IOINDEX_VALID       (0x01)
+
+
+/****************************************************************************
+*  Command Buffer Formats (with 16 byte CDB)
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_SSP_CMD_BUFFER
+{
+    U8      FrameType;                                  /* 0x00 */
+    U8      Reserved1;                                  /* 0x01 */
+    U16     InitiatorConnectionTag;                     /* 0x02 */
+    U32     HashedSourceSASAddress;                     /* 0x04 */
+    U16     Reserved2;                                  /* 0x08 */
+    U16     Flags;                                      /* 0x0A */
+    U32     Reserved3;                                  /* 0x0C */
+    U16     Tag;                                        /* 0x10 */
+    U16     TargetPortTransferTag;                      /* 0x12 */
+    U32     DataOffset;                                 /* 0x14 */
+    /* COMMAND information unit starts here */
+    U8      LogicalUnitNumber[8];                       /* 0x18 */
+    U8      Reserved4;                                  /* 0x20 */
+    U8      TaskAttribute; /* lower 3 bits */           /* 0x21 */
+    U8      Reserved5;                                  /* 0x22 */
+    U8      AdditionalCDBLength; /* upper 5 bits */     /* 0x23 */
+    U8      CDB[16];                                    /* 0x24 */
+    /* Additional CDB bytes extend past the CDB field */
+} MPI2_TARGET_SSP_CMD_BUFFER, MPI2_POINTER PTR_MPI2_TARGET_SSP_CMD_BUFFER,
+  Mpi2TargetSspCmdBuffer, MPI2_POINTER pMp2iTargetSspCmdBuffer;
+
+typedef struct _MPI2_TARGET_SSP_TASK_BUFFER
+{
+    U8      FrameType;                                  /* 0x00 */
+    U8      Reserved1;                                  /* 0x01 */
+    U16     InitiatorConnectionTag;                     /* 0x02 */
+    U32     HashedSourceSASAddress;                     /* 0x04 */
+    U16     Reserved2;                                  /* 0x08 */
+    U16     Flags;                                      /* 0x0A */
+    U32     Reserved3;                                  /* 0x0C */
+    U16     Tag;                                        /* 0x10 */
+    U16     TargetPortTransferTag;                      /* 0x12 */
+    U32     DataOffset;                                 /* 0x14 */
+    /* TASK information unit starts here */
+    U8      LogicalUnitNumber[8];                       /* 0x18 */
+    U16     Reserved4;                                  /* 0x20 */
+    U8      TaskManagementFunction;                     /* 0x22 */
+    U8      Reserved5;                                  /* 0x23 */
+    U16     ManagedTaskTag;                             /* 0x24 */
+    U16     Reserved6;                                  /* 0x26 */
+    U32     Reserved7;                                  /* 0x28 */
+    U32     Reserved8;                                  /* 0x2C */
+    U32     Reserved9;                                  /* 0x30 */
+} MPI2_TARGET_SSP_TASK_BUFFER, MPI2_POINTER PTR_MPI2_TARGET_SSP_TASK_BUFFER,
+  Mpi2TargetSspTaskBuffer, MPI2_POINTER pMpi2TargetSspTaskBuffer;
+
+/* mask and shift for HashedSourceSASAddress field */
+#define MPI2_TARGET_HASHED_SAS_ADDRESS_MASK     (0xFFFFFF00)
+#define MPI2_TARGET_HASHED_SAS_ADDRESS_SHIFT    (8)
+
+
+/****************************************************************************
+*   Target Assist Request
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_ASSIST_REQUEST
+{
+    U8                  Reserved1;                          /* 0x00 */
+    U8                  TargetAssistFlags;                  /* 0x01 */
+    U8                  ChainOffset;                        /* 0x02 */
+    U8                  Function;                           /* 0x03 */
+    U16                 QueueTag;                           /* 0x04 */
+    U8                  Reserved2;                          /* 0x06 */
+    U8                  MsgFlags;                           /* 0x07 */
+    U8                  VP_ID;                              /* 0x08 */
+    U8                  VF_ID;                              /* 0x09 */
+    U16                 Reserved3;                          /* 0x0A */
+    U16                 IoIndex;                            /* 0x0C */
+    U16                 InitiatorConnectionTag;             /* 0x0E */
+    U16                 SGLFlags;                           /* 0x10 */
+    U8                  SequenceNumber;                     /* 0x12 */
+    U8                  Reserved4;                          /* 0x13 */
+    U8                  SGLOffset0;                         /* 0x14 */
+    U8                  SGLOffset1;                         /* 0x15 */
+    U8                  SGLOffset2;                         /* 0x16 */
+    U8                  SGLOffset3;                         /* 0x17 */
+    U32                 SkipCount;                          /* 0x18 */
+    U32                 DataLength;                         /* 0x1C */
+    U32                 BidirectionalDataLength;            /* 0x20 */
+    U16                 IoFlags;                            /* 0x24 */
+    U16                 EEDPFlags;                          /* 0x26 */
+    U32                 EEDPBlockSize;                      /* 0x28 */
+    U32                 SecondaryReferenceTag;              /* 0x2C */
+    U16                 SecondaryApplicationTag;            /* 0x30 */
+    U16                 ApplicationTagTranslationMask;      /* 0x32 */
+    U32                 PrimaryReferenceTag;                /* 0x34 */
+    U16                 PrimaryApplicationTag;              /* 0x38 */
+    U16                 PrimaryApplicationTagMask;          /* 0x3A */
+    U32                 RelativeOffset;                     /* 0x3C */
+    U32                 Reserved5;                          /* 0x40 */
+    U32                 Reserved6;                          /* 0x44 */
+    U32                 Reserved7;                          /* 0x48 */
+    U32                 Reserved8;                          /* 0x4C */
+    MPI2_SGE_IO_UNION   SGL[1];                             /* 0x50 */
+} MPI2_TARGET_ASSIST_REQUEST, MPI2_POINTER PTR_MPI2_TARGET_ASSIST_REQUEST,
+  Mpi2TargetAssistRequest_t, MPI2_POINTER pMpi2TargetAssistRequest_t;
+
+/* Target Assist TargetAssistFlags bits */
+
+#define MPI2_TARGET_ASSIST_FLAGS_REPOST_CMD_BUFFER      (0x80)
+#define MPI2_TARGET_ASSIST_FLAGS_TLR                    (0x10)
+#define MPI2_TARGET_ASSIST_FLAGS_RETRANSMIT             (0x04)
+#define MPI2_TARGET_ASSIST_FLAGS_AUTO_STATUS            (0x02)
+#define MPI2_TARGET_ASSIST_FLAGS_DATA_DIRECTION         (0x01)
+
+/* Target Assist SGLFlags bits */
+
+/* base values for Data Location Address Space */
+#define MPI2_TARGET_ASSIST_SGLFLAGS_ADDR_MASK           (0x0C)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_SYSTEM_ADDR         (0x00)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_IOCDDR_ADDR         (0x04)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_IOCPLB_ADDR         (0x08)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_PLBNTA_ADDR         (0x0C)
+
+/* base values for Type */
+#define MPI2_TARGET_ASSIST_SGLFLAGS_TYPE_MASK           (0x03)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_MPI_TYPE            (0x00)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_32IEEE_TYPE         (0x01)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_64IEEE_TYPE         (0x02)
+
+/* shift values for each sub-field */
+#define MPI2_TARGET_ASSIST_SGLFLAGS_SGL3_SHIFT          (12)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_SGL2_SHIFT          (8)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_SGL1_SHIFT          (4)
+#define MPI2_TARGET_ASSIST_SGLFLAGS_SGL0_SHIFT          (0)
+
+/* Target Assist IoFlags bits */
+
+#define MPI2_TARGET_ASSIST_IOFLAGS_BIDIRECTIONAL        (0x0800)
+#define MPI2_TARGET_ASSIST_IOFLAGS_MULTICAST            (0x0400)
+#define MPI2_TARGET_ASSIST_IOFLAGS_RECEIVE_FIRST        (0x0200)
+
+/* Target Assist EEDPFlags bits */
+
+#define MPI2_TA_EEDPFLAGS_INC_PRI_REFTAG            (0x8000)
+#define MPI2_TA_EEDPFLAGS_INC_SEC_REFTAG            (0x4000)
+#define MPI2_TA_EEDPFLAGS_INC_PRI_APPTAG            (0x2000)
+#define MPI2_TA_EEDPFLAGS_INC_SEC_APPTAG            (0x1000)
+
+#define MPI2_TA_EEDPFLAGS_CHECK_REFTAG              (0x0400)
+#define MPI2_TA_EEDPFLAGS_CHECK_APPTAG              (0x0200)
+#define MPI2_TA_EEDPFLAGS_CHECK_GUARD               (0x0100)
+
+#define MPI2_TA_EEDPFLAGS_PASSTHRU_REFTAG           (0x0008)
+
+#define MPI2_TA_EEDPFLAGS_MASK_OP                   (0x0007)
+#define MPI2_TA_EEDPFLAGS_NOOP_OP                   (0x0000)
+#define MPI2_TA_EEDPFLAGS_CHECK_OP                  (0x0001)
+#define MPI2_TA_EEDPFLAGS_STRIP_OP                  (0x0002)
+#define MPI2_TA_EEDPFLAGS_CHECK_REMOVE_OP           (0x0003)
+#define MPI2_TA_EEDPFLAGS_INSERT_OP                 (0x0004)
+#define MPI2_TA_EEDPFLAGS_REPLACE_OP                (0x0006)
+#define MPI2_TA_EEDPFLAGS_CHECK_REGEN_OP            (0x0007)
+
+
+/****************************************************************************
+*  Target Status Send Request
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_STATUS_SEND_REQUEST
+{
+    U8                      Reserved1;                  /* 0x00 */
+    U8                      StatusFlags;                /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     QueueTag;                   /* 0x04 */
+    U8                      Reserved2;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved3;                  /* 0x0A */
+    U16                     IoIndex;                    /* 0x0C */
+    U16                     InitiatorConnectionTag;     /* 0x0E */
+    U16                     SGLFlags;                   /* 0x10 */
+    U16                     Reserved4;                  /* 0x12 */
+    U8                      SGLOffset0;                 /* 0x14 */
+    U8                      Reserved5;                  /* 0x15 */
+    U16                     Reserved6;                  /* 0x16 */
+    U32                     Reserved7;                  /* 0x18 */
+    U32                     Reserved8;                  /* 0x1C */
+    MPI2_SIMPLE_SGE_UNION   StatusDataSGE;              /* 0x20 */
+} MPI2_TARGET_STATUS_SEND_REQUEST,
+  MPI2_POINTER PTR_MPI2_TARGET_STATUS_SEND_REQUEST,
+  Mpi2TargetStatusSendRequest_t, MPI2_POINTER pMpi2TargetStatusSendRequest_t;
+
+/* Target Status Send StatusFlags bits */
+
+#define MPI2_TSS_FLAGS_REPOST_CMD_BUFFER            (0x80)
+#define MPI2_TSS_FLAGS_RETRANSMIT                   (0x04)
+#define MPI2_TSS_FLAGS_AUTO_GOOD_STATUS             (0x01)
+
+/* Target Status Send SGLFlags bits */
+/* Data Location Address Space */
+#define MPI2_TSS_SGLFLAGS_ADDR_MASK                 (0x0C)
+#define MPI2_TSS_SGLFLAGS_SYSTEM_ADDR               (0x00)
+#define MPI2_TSS_SGLFLAGS_IOCDDR_ADDR               (0x04)
+#define MPI2_TSS_SGLFLAGS_IOCPLB_ADDR               (0x08)
+#define MPI2_TSS_SGLFLAGS_IOCPLBNTA_ADDR            (0x0C)
+/* Type */
+#define MPI2_TSS_SGLFLAGS_TYPE_MASK                 (0x03)
+#define MPI2_TSS_SGLFLAGS_MPI_TYPE                  (0x00)
+#define MPI2_TSS_SGLFLAGS_IEEE32_TYPE               (0x01)
+#define MPI2_TSS_SGLFLAGS_IEEE64_TYPE               (0x02)
+
+
+
+/*
+ * NOTE: The SSP status IU is big-endian. When used on a little-endian system,
+ * this structure properly orders the bytes.
+ */
+typedef struct _MPI2_TARGET_SSP_RSP_IU
+{
+    U32     Reserved0[6]; /* reserved for SSP header */ /* 0x00 */
+    /* start of RESPONSE information unit */
+    U32     Reserved1;                                  /* 0x18 */
+    U32     Reserved2;                                  /* 0x1C */
+    U16     Reserved3;                                  /* 0x20 */
+    U8      DataPres; /* lower 2 bits */                /* 0x22 */
+    U8      Status;                                     /* 0x23 */
+    U32     Reserved4;                                  /* 0x24 */
+    U32     SenseDataLength;                            /* 0x28 */
+    U32     ResponseDataLength;                         /* 0x2C */
+    U8      ResponseSenseData[4];                       /* 0x30 */
+} MPI2_TARGET_SSP_RSP_IU, MPI2_POINTER PTR_MPI2_TARGET_SSP_RSP_IU,
+  Mpi2TargetSspRspIu_t, MPI2_POINTER pMpi2TargetSspRspIu_t;
+
+
+/****************************************************************************
+*  Target Standard Reply - used with Target Assist or Target Status Send
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_STANDARD_REPLY
+{
+    U16                     Reserved;                   /* 0x00 */
+    U8                      MsgLength;                  /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved1;                  /* 0x04 */
+    U8                      Reserved2;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved3;                  /* 0x0A */
+    U16                     Reserved4;                  /* 0x0C */
+    U16                     IOCStatus;                  /* 0x0E */
+    U32                     IOCLogInfo;                 /* 0x10 */
+    U16                     IoIndex;                    /* 0x14 */
+    U16                     Reserved5;                  /* 0x16 */
+    U32                     TransferCount;              /* 0x18 */
+    U32                     BidirectionalTransferCount; /* 0x1C */
+} MPI2_TARGET_STANDARD_REPLY, MPI2_POINTER PTR_MPI2_TARGET_STANDARD_REPLY,
+  Mpi2TargetErrorReply_t, MPI2_POINTER pMpi2TargetErrorReply_t;
+
+
+/****************************************************************************
+*  Target Mode Abort Request
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_MODE_ABORT_REQUEST
+{
+    U8                      AbortType;                  /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U16                     IoIndexToAbort;             /* 0x0C */
+    U16                     Reserved6;                  /* 0x0E */
+    U32                     MidToAbort;                 /* 0x10 */
+} MPI2_TARGET_MODE_ABORT, MPI2_POINTER PTR_MPI2_TARGET_MODE_ABORT,
+  Mpi2TargetModeAbort_t, MPI2_POINTER pMpi2TargetModeAbort_t;
+
+/* Target Mode Abort AbortType values */
+
+#define MPI2_TARGET_MODE_ABORT_ALL_CMD_BUFFERS      (0x00)
+#define MPI2_TARGET_MODE_ABORT_ALL_IO               (0x01)
+#define MPI2_TARGET_MODE_ABORT_EXACT_IO             (0x02)
+#define MPI2_TARGET_MODE_ABORT_EXACT_IO_REQUEST     (0x03)
+#define MPI2_TARGET_MODE_ABORT_IO_REQUEST_AND_IO    (0x04)
+
+
+/****************************************************************************
+*  Target Mode Abort Reply
+****************************************************************************/
+
+typedef struct _MPI2_TARGET_MODE_ABORT_REPLY
+{
+    U16                     Reserved;                   /* 0x00 */
+    U8                      MsgLength;                  /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved1;                  /* 0x04 */
+    U8                      Reserved2;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved3;                  /* 0x0A */
+    U16                     Reserved4;                  /* 0x0C */
+    U16                     IOCStatus;                  /* 0x0E */
+    U32                     IOCLogInfo;                 /* 0x10 */
+    U32                     AbortCount;                 /* 0x14 */
+} MPI2_TARGET_MODE_ABORT_REPLY, MPI2_POINTER PTR_MPI2_TARGET_MODE_ABORT_REPLY,
+  Mpi2TargetModeAbortReply_t, MPI2_POINTER pMpi2TargetModeAbortReply_t;
+
+
+#endif
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,249 @@
+/*
+ *  Copyright (c) 2000-2008 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_tool.h
+ *          Title:  MPI diagnostic tool structures and definitions
+ *  Creation Date:  March 26, 2007
+ *
+ *    mpi2_tool.h Version:  02.00.02
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  12-18-07  02.00.01  Added Diagnostic Buffer Post and Diagnostic Release
+ *                      structures and defines.
+ *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_TOOL_H
+#define MPI2_TOOL_H
+
+/*****************************************************************************
+*
+*               Toolbox Messages
+*
+*****************************************************************************/
+
+/* defines for the Tools */
+#define MPI2_TOOLBOX_CLEAN_TOOL                     (0x00)
+#define MPI2_TOOLBOX_MEMORY_MOVE_TOOL               (0x01)
+#define MPI2_TOOLBOX_BEACON_TOOL                    (0x05)
+
+/****************************************************************************
+*  Toolbox reply
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_REPLY
+{
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
+} MPI2_TOOLBOX_REPLY, MPI2_POINTER PTR_MPI2_TOOLBOX_REPLY,
+  Mpi2ToolboxReply_t, MPI2_POINTER pMpi2ToolboxReply_t;
+
+
+/****************************************************************************
+*  Toolbox Clean Tool request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_CLEAN_REQUEST
+{
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
+    U32                     Flags;                      /* 0x0C */
+   } MPI2_TOOLBOX_CLEAN_REQUEST, MPI2_POINTER PTR_MPI2_TOOLBOX_CLEAN_REQUEST,
+  Mpi2ToolboxCleanRequest_t, MPI2_POINTER pMpi2ToolboxCleanRequest_t;
+
+/* values for the Flags field */
+#define MPI2_TOOLBOX_CLEAN_BOOT_SERVICES            (0x80000000)
+#define MPI2_TOOLBOX_CLEAN_PERSIST_MANUFACT_PAGES   (0x40000000)
+#define MPI2_TOOLBOX_CLEAN_OTHER_PERSIST_PAGES      (0x20000000)
+#define MPI2_TOOLBOX_CLEAN_FW_CURRENT               (0x10000000)
+#define MPI2_TOOLBOX_CLEAN_FW_BACKUP                (0x08000000)
+#define MPI2_TOOLBOX_CLEAN_MEGARAID                 (0x02000000)
+#define MPI2_TOOLBOX_CLEAN_INITIALIZATION           (0x01000000)
+#define MPI2_TOOLBOX_CLEAN_FLASH                    (0x00000004)
+#define MPI2_TOOLBOX_CLEAN_SEEPROM                  (0x00000002)
+#define MPI2_TOOLBOX_CLEAN_NVSRAM                   (0x00000001)
+
+
+/****************************************************************************
+*  Toolbox Memory Move request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_MEM_MOVE_REQUEST
+{
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
+    MPI2_SGE_SIMPLE_UNION   SGL;                        /* 0x0C */
+} MPI2_TOOLBOX_MEM_MOVE_REQUEST, MPI2_POINTER PTR_MPI2_TOOLBOX_MEM_MOVE_REQUEST,
+  Mpi2ToolboxMemMoveRequest_t, MPI2_POINTER pMpi2ToolboxMemMoveRequest_t;
+
+
+/****************************************************************************
+*  Toolbox Beacon Tool request
+****************************************************************************/
+
+typedef struct _MPI2_TOOLBOX_BEACON_REQUEST
+{
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
+    U8                      Reserved5;                  /* 0x0C */
+    U8                      PhysicalPort;               /* 0x0D */
+    U8                      Reserved6;                  /* 0x0E */
+    U8                      Flags;                      /* 0x0F */
+} MPI2_TOOLBOX_BEACON_REQUEST, MPI2_POINTER PTR_MPI2_TOOLBOX_BEACON_REQUEST,
+  Mpi2ToolboxBeaconRequest_t, MPI2_POINTER pMpi2ToolboxBeaconRequest_t;
+
+/* values for the Flags field */
+#define MPI2_TOOLBOX_FLAGS_BEACONMODE_OFF       (0x00)
+#define MPI2_TOOLBOX_FLAGS_BEACONMODE_ON        (0x01)
+
+
+/*****************************************************************************
+*
+*       Diagnostic Buffer Messages
+*
+*****************************************************************************/
+
+
+/****************************************************************************
+*  Diagnostic Buffer Post request
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_BUFFER_POST_REQUEST
+{
+    U8                      Reserved1;                  /* 0x00 */
+    U8                      BufferType;                 /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U64                     BufferAddress;              /* 0x0C */
+    U32                     BufferLength;               /* 0x14 */
+    U32                     Reserved5;                  /* 0x18 */
+    U32                     Reserved6;                  /* 0x1C */
+    U32                     Flags;                      /* 0x20 */
+    U32                     ProductSpecific[23];        /* 0x24 */
+} MPI2_DIAG_BUFFER_POST_REQUEST, MPI2_POINTER PTR_MPI2_DIAG_BUFFER_POST_REQUEST,
+  Mpi2DiagBufferPostRequest_t, MPI2_POINTER pMpi2DiagBufferPostRequest_t;
+
+/* values for the BufferType field */
+#define MPI2_DIAG_BUF_TYPE_TRACE                    (0x00)
+#define MPI2_DIAG_BUF_TYPE_SNAPSHOT                 (0x01)
+/* count of the number of buffer types */
+#define MPI2_DIAG_BUF_TYPE_COUNT                    (0x02)
+
+
+/****************************************************************************
+*  Diagnostic Buffer Post reply
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_BUFFER_POST_REPLY
+{
+    U8                      Reserved1;                  /* 0x00 */
+    U8                      BufferType;                 /* 0x01 */
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
+    U32                     TransferLength;             /* 0x14 */
+} MPI2_DIAG_BUFFER_POST_REPLY, MPI2_POINTER PTR_MPI2_DIAG_BUFFER_POST_REPLY,
+  Mpi2DiagBufferPostReply_t, MPI2_POINTER pMpi2DiagBufferPostReply_t;
+
+
+/****************************************************************************
+*  Diagnostic Release request
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_RELEASE_REQUEST
+{
+    U8                      Reserved1;                  /* 0x00 */
+    U8                      BufferType;                 /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+} MPI2_DIAG_RELEASE_REQUEST, MPI2_POINTER PTR_MPI2_DIAG_RELEASE_REQUEST,
+  Mpi2DiagReleaseRequest_t, MPI2_POINTER pMpi2DiagReleaseRequest_t;
+
+
+/****************************************************************************
+*  Diagnostic Buffer Post reply
+****************************************************************************/
+
+typedef struct _MPI2_DIAG_RELEASE_REPLY
+{
+    U8                      Reserved1;                  /* 0x00 */
+    U8                      BufferType;                 /* 0x01 */
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
+} MPI2_DIAG_RELEASE_REPLY, MPI2_POINTER PTR_MPI2_DIAG_RELEASE_REPLY,
+  Mpi2DiagReleaseReply_t, MPI2_POINTER pMpi2DiagReleaseReply_t;
+
+
+#endif
+
diff -uaprN a/drivers/scsi/mpt2sas/mpi/mpi2_type.h b/drivers/scsi/mpt2sas/mpi/mpi2_type.h
--- a/drivers/scsi/mpt2sas/mpi/mpi2_type.h	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_type.h	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,61 @@
+/*
+ *  Copyright (c) 2000-2007 LSI Corporation.
+ *
+ *
+ *           Name:  mpi2_type.h
+ *          Title:  MPI basic type definitions
+ *  Creation Date:  August 16, 2006
+ *
+ *    mpi2_type.h Version:  02.00.00
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  --------------------------------------------------------------------------
+ */
+
+#ifndef MPI2_TYPE_H
+#define MPI2_TYPE_H
+
+
+/*******************************************************************************
+ * Define MPI2_POINTER if it hasn't already been defined. By default
+ * MPI2_POINTER is defined to be a near pointer. MPI2_POINTER can be defined as
+ * a far pointer by defining MPI2_POINTER as "far *" before this header file is
+ * included.
+ */
+#ifndef MPI2_POINTER
+#define MPI2_POINTER     *
+#endif
+
+/* the basic types may have already been included by mpi_type.h */
+#ifndef MPI_TYPE_H
+/*****************************************************************************
+*
+*               Basic Types
+*
+*****************************************************************************/
+
+typedef u8 U8;
+typedef __le16 U16;
+typedef __le32 U32;
+typedef __le64 U64 __attribute__((aligned(4)));
+
+/*****************************************************************************
+*
+*               Pointer Types
+*
+*****************************************************************************/
+
+typedef U8      *PU8;
+typedef U16     *PU16;
+typedef U32     *PU32;
+typedef U64     *PU64;
+
+#endif
+
+#endif
+
