From: adam radford <aradford@gmail.com>
Subject: [PATCH 8/11]: megaraid_sas: Add MegaRAID 9265/9285
 megaraid_sas_fusion.h header.
Date: Tue, 14 Dec 2010 19:06:03 -0800
Message-ID: <AANLkTimyvDW5dhkn8bNJFUj2XZtXZAAbAN74DG6TqiUW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363b8520b0a5f904976a37c2
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61498 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0LODGE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 22:06:04 -0500
Received: by qwa26 with SMTP id 26so1491954qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 19:06:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016363b8520b0a5f904976a37c2
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch adds the MegaRAID 9265/9285 specific header file
megaraid_sas_fusion.h.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.h	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.h	2010-12-14
17:16:26.000000000 -0800
@@ -0,0 +1,695 @@
+/*
+ *  Linux MegaRAID driver for SAS based RAID controllers
+ *
+ *  Copyright (c) 2009-2011  LSI Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *  FILE: megaraid_sas_fusion.h
+ *
+ *  Authors: LSI Corporation
+ *           Manoj Jose
+ *           Sumant Patro
+ *
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
+ */
+
+#ifndef _MEGARAID_SAS_FUSION_H_
+#define _MEGARAID_SAS_FUSION_H_
+
+/* Fusion defines */
+#define MEGASAS_MAX_SZ_CHAIN_FRAME 1024
+#define MFI_FUSION_ENABLE_INTERRUPT_MASK (0x00000009)
+#define MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE 256
+#define MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST   0xF0
+#define MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST         0xF1
+#define MEGASAS_LOAD_BALANCE_FLAG		    0x1
+#define MEGASAS_DCMD_MBOX_PEND_FLAG		    0x1
+#define HOST_DIAG_WRITE_ENABLE			    0x80
+#define HOST_DIAG_RESET_ADAPTER			    0x4
+#define MEGASAS_FUSION_MAX_RESET_TRIES		    3
+
+/* T10 PI defines */
+#define MR_PROT_INFO_TYPE_CONTROLLER                0x8
+#define MEGASAS_SCSI_VARIABLE_LENGTH_CMD            0x7f
+#define MEGASAS_SCSI_SERVICE_ACTION_READ32          0x9
+#define MEGASAS_SCSI_SERVICE_ACTION_WRITE32         0xB
+#define MEGASAS_SCSI_ADDL_CDB_LEN                   0x18
+#define MEGASAS_RD_WR_PROTECT_CHECK_ALL		    0x20
+#define MEGASAS_RD_WR_PROTECT_CHECK_NONE	    0x60
+#define MEGASAS_EEDPBLOCKSIZE			    512
+
+/*
+ * Raid context flags
+ */
+
+#define MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT   0x4
+#define MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_MASK    0x30
+enum MR_RAID_FLAGS_IO_SUB_TYPE {
+	MR_RAID_FLAGS_IO_SUB_TYPE_NONE = 0,
+	MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD = 1,
+};
+
+/*
+ * Request descriptor types
+ */
+#define MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO           0x7
+#define MEGASAS_REQ_DESCRIPT_FLAGS_MFA             0x1
+
+#define MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT      1
+
+#define MEGASAS_FP_CMD_LEN	16
+#define MEGASAS_FUSION_IN_RESET 0
+
+/*
+ * Raid Context structure which describes MegaRAID specific IO Paramenters
+ * This resides at offset 0x60 where the SGL normally starts in MPT IO Frames
+ */
+
+struct RAID_CONTEXT {
+	u16     resvd0;
+	u16     timeoutValue;
+	u8      regLockFlags;
+	u8      resvd1;
+	u16     VirtualDiskTgtId;
+	u64     regLockRowLBA;
+	u32     regLockLength;
+	u16     nextLMId;
+	u8      exStatus;
+	u8      status;
+	u8      RAIDFlags;
+	u8      numSGE;
+	u16	configSeqNum;
+	u8      spanArm;
+	u8      resvd2[3];
+};
+
+#define RAID_CTX_SPANARM_ARM_SHIFT	(0)
+#define RAID_CTX_SPANARM_ARM_MASK	(0x1f)
+
+#define RAID_CTX_SPANARM_SPAN_SHIFT	(5)
+#define RAID_CTX_SPANARM_SPAN_MASK	(0xE0)
+
+/*
+ * define region lock types
+ */
+enum REGION_TYPE {
+	REGION_TYPE_UNUSED       = 0,
+	REGION_TYPE_SHARED_READ  = 1,
+	REGION_TYPE_SHARED_WRITE = 2,
+	REGION_TYPE_EXCLUSIVE    = 3,
+};
+
+/* MPI2 defines */
+#define MPI2_FUNCTION_IOC_INIT              (0x02) /* IOC Init */
+#define MPI2_WHOINIT_HOST_DRIVER            (0x04)
+#define MPI2_VERSION_MAJOR                  (0x02)
+#define MPI2_VERSION_MINOR                  (0x00)
+#define MPI2_VERSION_MAJOR_MASK             (0xFF00)
+#define MPI2_VERSION_MAJOR_SHIFT            (8)
+#define MPI2_VERSION_MINOR_MASK             (0x00FF)
+#define MPI2_VERSION_MINOR_SHIFT            (0)
+#define MPI2_VERSION ((MPI2_VERSION_MAJOR << MPI2_VERSION_MAJOR_SHIFT) | \
+		      MPI2_VERSION_MINOR)
+#define MPI2_HEADER_VERSION_UNIT            (0x10)
+#define MPI2_HEADER_VERSION_DEV             (0x00)
+#define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
+#define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
+#define MPI2_HEADER_VERSION_DEV_MASK        (0x00FF)
+#define MPI2_HEADER_VERSION_DEV_SHIFT       (0)
+#define MPI2_HEADER_VERSION ((MPI2_HEADER_VERSION_UNIT << 8) | \
+			     MPI2_HEADER_VERSION_DEV)
+#define MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR      (0x03)
+#define MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG        (0x8000)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG          (0x0400)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP       (0x0003)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG          (0x0200)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD           (0x0100)
+#define MPI2_SCSIIO_EEDPFLAGS_INSERT_OP             (0x0004)
+#define MPI2_FUNCTION_SCSI_IO_REQUEST               (0x00) /* SCSI IO */
+#define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY           (0x06)
+#define MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO                 (0x00)
+#define MPI2_SGE_FLAGS_64_BIT_ADDRESSING        (0x02)
+#define MPI2_SCSIIO_CONTROL_WRITE               (0x01000000)
+#define MPI2_SCSIIO_CONTROL_READ                (0x02000000)
+#define MPI2_REQ_DESCRIPT_FLAGS_TYPE_MASK       (0x0E)
+#define MPI2_RPY_DESCRIPT_FLAGS_UNUSED          (0x0F)
+#define MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS (0x00)
+#define MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK       (0x0F)
+#define MPI2_WRSEQ_FLUSH_KEY_VALUE              (0x0)
+#define MPI2_WRITE_SEQUENCE_OFFSET              (0x00000004)
+#define MPI2_WRSEQ_1ST_KEY_VALUE                (0xF)
+#define MPI2_WRSEQ_2ND_KEY_VALUE                (0x4)
+#define MPI2_WRSEQ_3RD_KEY_VALUE                (0xB)
+#define MPI2_WRSEQ_4TH_KEY_VALUE                (0x2)
+#define MPI2_WRSEQ_5TH_KEY_VALUE                (0x7)
+#define MPI2_WRSEQ_6TH_KEY_VALUE                (0xD)
+
+struct MPI25_IEEE_SGE_CHAIN64 {
+	u64                     Address;
+	u32                     Length;
+	u16                     Reserved1;
+	u8                      NextChainOffset;
+	u8                      Flags;
+};
+
+struct MPI2_SGE_SIMPLE_UNION {
+	u32                     FlagsLength;
+	union {
+		u32                 Address32;
+		u64                 Address64;
+	} u;
+};
+
+struct MPI2_SCSI_IO_CDB_EEDP32 {
+	u8                      CDB[20];                    /* 0x00 */
+	u32                     PrimaryReferenceTag;        /* 0x14 */
+	u16                     PrimaryApplicationTag;      /* 0x18 */
+	u16                     PrimaryApplicationTagMask;  /* 0x1A */
+	u32                     TransferLength;             /* 0x1C */
+};
+
+struct MPI2_SGE_CHAIN_UNION {
+	u16                     Length;
+	u8                      NextChainOffset;
+	u8                      Flags;
+	union {
+		u32                 Address32;
+		u64                 Address64;
+	} u;
+};
+
+struct MPI2_IEEE_SGE_SIMPLE32 {
+	u32                     Address;
+	u32                     FlagsLength;
+};
+
+struct MPI2_IEEE_SGE_CHAIN32 {
+	u32                     Address;
+	u32                     FlagsLength;
+};
+
+struct MPI2_IEEE_SGE_SIMPLE64 {
+	u64                     Address;
+	u32                     Length;
+	u16                     Reserved1;
+	u8                      Reserved2;
+	u8                      Flags;
+};
+
+struct MPI2_IEEE_SGE_CHAIN64 {
+	u64                     Address;
+	u32                     Length;
+	u16                     Reserved1;
+	u8                      Reserved2;
+	u8                      Flags;
+};
+
+union MPI2_IEEE_SGE_SIMPLE_UNION {
+	struct MPI2_IEEE_SGE_SIMPLE32  Simple32;
+	struct MPI2_IEEE_SGE_SIMPLE64  Simple64;
+};
+
+union MPI2_IEEE_SGE_CHAIN_UNION {
+	struct MPI2_IEEE_SGE_CHAIN32   Chain32;
+	struct MPI2_IEEE_SGE_CHAIN64   Chain64;
+};
+
+union MPI2_SGE_IO_UNION {
+	struct MPI2_SGE_SIMPLE_UNION       MpiSimple;
+	struct MPI2_SGE_CHAIN_UNION        MpiChain;
+	union MPI2_IEEE_SGE_SIMPLE_UNION  IeeeSimple;
+	union MPI2_IEEE_SGE_CHAIN_UNION   IeeeChain;
+};
+
+union MPI2_SCSI_IO_CDB_UNION {
+	u8                      CDB32[32];
+	struct MPI2_SCSI_IO_CDB_EEDP32 EEDP32;
+	struct MPI2_SGE_SIMPLE_UNION SGE;
+};
+
+/*
+ * RAID SCSI IO Request Message
+ * Total SGE count will be one less than  _MPI2_SCSI_IO_REQUEST
+ */
+struct MPI2_RAID_SCSI_IO_REQUEST {
+	u16                     DevHandle;                      /* 0x00 */
+	u8                      ChainOffset;                    /* 0x02 */
+	u8                      Function;                       /* 0x03 */
+	u16                     Reserved1;                      /* 0x04 */
+	u8                      Reserved2;                      /* 0x06 */
+	u8                      MsgFlags;                       /* 0x07 */
+	u8                      VP_ID;                          /* 0x08 */
+	u8                      VF_ID;                          /* 0x09 */
+	u16                     Reserved3;                      /* 0x0A */
+	u32                     SenseBufferLowAddress;          /* 0x0C */
+	u16                     SGLFlags;                       /* 0x10 */
+	u8                      SenseBufferLength;              /* 0x12 */
+	u8                      Reserved4;                      /* 0x13 */
+	u8                      SGLOffset0;                     /* 0x14 */
+	u8                      SGLOffset1;                     /* 0x15 */
+	u8                      SGLOffset2;                     /* 0x16 */
+	u8                      SGLOffset3;                     /* 0x17 */
+	u32                     SkipCount;                      /* 0x18 */
+	u32                     DataLength;                     /* 0x1C */
+	u32                     BidirectionalDataLength;        /* 0x20 */
+	u16                     IoFlags;                        /* 0x24 */
+	u16                     EEDPFlags;                      /* 0x26 */
+	u32                     EEDPBlockSize;                  /* 0x28 */
+	u32                     SecondaryReferenceTag;          /* 0x2C */
+	u16                     SecondaryApplicationTag;        /* 0x30 */
+	u16                     ApplicationTagTranslationMask;  /* 0x32 */
+	u8                      LUN[8];                         /* 0x34 */
+	u32                     Control;                        /* 0x3C */
+	union MPI2_SCSI_IO_CDB_UNION  CDB;			/* 0x40 */
+	struct RAID_CONTEXT	RaidContext;                    /* 0x60 */
+	union MPI2_SGE_IO_UNION       SGL;			/* 0x80 */
+};
+
+/*
+ * MPT RAID MFA IO Descriptor.
+ */
+struct MEGASAS_RAID_MFA_IO_REQUEST_DESCRIPTOR {
+	u32     RequestFlags:8;
+	u32     MessageAddress1:24; /* bits 31:8*/
+	u32     MessageAddress2;      /* bits 61:32 */
+};
+
+/* Default Request Descriptor */
+struct MPI2_DEFAULT_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             DescriptorTypeDependent;    /* 0x06 */
+};
+
+/* High Priority Request Descriptor */
+struct MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             Reserved1;                  /* 0x06 */
+};
+
+/* SCSI IO Request Descriptor */
+struct MPI2_SCSI_IO_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             DevHandle;                  /* 0x06 */
+};
+
+/* SCSI Target Request Descriptor */
+struct MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             IoIndex;                    /* 0x06 */
+};
+
+/* RAID Accelerator Request Descriptor */
+struct MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             Reserved;                   /* 0x06 */
+};
+
+/* union of Request Descriptors */
+union MEGASAS_REQUEST_DESCRIPTOR_UNION {
+	struct MPI2_DEFAULT_REQUEST_DESCRIPTOR             Default;
+	struct MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR       HighPriority;
+	struct MPI2_SCSI_IO_REQUEST_DESCRIPTOR             SCSIIO;
+	struct MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR         SCSITarget;
+	struct MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR          RAIDAccelerator;
+	struct MEGASAS_RAID_MFA_IO_REQUEST_DESCRIPTOR      MFAIo;
+	union {
+		struct {
+			u32 low;
+			u32 high;
+		} u;
+		u64 Words;
+	};
+};
+
+/* Default Reply Descriptor */
+struct MPI2_DEFAULT_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             DescriptorTypeDependent1;   /* 0x02 */
+	u32             DescriptorTypeDependent2;   /* 0x04 */
+};
+
+/* Address Reply Descriptor */
+struct MPI2_ADDRESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u32             ReplyFrameAddress;          /* 0x04 */
+};
+
+/* SCSI IO Success Reply Descriptor */
+struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             TaskTag;                    /* 0x04 */
+	u16             Reserved1;                  /* 0x06 */
+};
+
+/* TargetAssist Success Reply Descriptor */
+struct MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u8              SequenceNumber;             /* 0x04 */
+	u8              Reserved1;                  /* 0x05 */
+	u16             IoIndex;                    /* 0x06 */
+};
+
+/* Target Command Buffer Reply Descriptor */
+struct MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u8              VP_ID;                      /* 0x02 */
+	u8              Flags;                      /* 0x03 */
+	u16             InitiatorDevHandle;         /* 0x04 */
+	u16             IoIndex;                    /* 0x06 */
+};
+
+/* RAID Accelerator Success Reply Descriptor */
+struct MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u32             Reserved;                   /* 0x04 */
+};
+
+/* union of Reply Descriptors */
+union MPI2_REPLY_DESCRIPTORS_UNION {
+	struct MPI2_DEFAULT_REPLY_DESCRIPTOR                   Default;
+	struct MPI2_ADDRESS_REPLY_DESCRIPTOR                   AddressReply;
+	struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR           SCSIIOSuccess;
+	struct MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR TargetAssistSuccess;
+	struct MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR TargetCommandBuffer;
+	struct MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR
+	RAIDAcceleratorSuccess;
+	u64                                             Words;
+};
+
+/* IOCInit Request message */
+struct MPI2_IOC_INIT_REQUEST {
+	u8                      WhoInit;                        /* 0x00 */
+	u8                      Reserved1;                      /* 0x01 */
+	u8                      ChainOffset;                    /* 0x02 */
+	u8                      Function;                       /* 0x03 */
+	u16                     Reserved2;                      /* 0x04 */
+	u8                      Reserved3;                      /* 0x06 */
+	u8                      MsgFlags;                       /* 0x07 */
+	u8                      VP_ID;                          /* 0x08 */
+	u8                      VF_ID;                          /* 0x09 */
+	u16                     Reserved4;                      /* 0x0A */
+	u16                     MsgVersion;                     /* 0x0C */
+	u16                     HeaderVersion;                  /* 0x0E */
+	u32                     Reserved5;                      /* 0x10 */
+	u16                     Reserved6;                      /* 0x14 */
+	u8                      Reserved7;                      /* 0x16 */
+	u8                      HostMSIxVectors;                /* 0x17 */
+	u16                     Reserved8;                      /* 0x18 */
+	u16                     SystemRequestFrameSize;         /* 0x1A */
+	u16                     ReplyDescriptorPostQueueDepth;  /* 0x1C */
+	u16                     ReplyFreeQueueDepth;            /* 0x1E */
+	u32                     SenseBufferAddressHigh;         /* 0x20 */
+	u32                     SystemReplyAddressHigh;         /* 0x24 */
+	u64                     SystemRequestFrameBaseAddress;  /* 0x28 */
+	u64                     ReplyDescriptorPostQueueAddress;/* 0x30 */
+	u64                     ReplyFreeQueueAddress;          /* 0x38 */
+	u64                     TimeStamp;                      /* 0x40 */
+};
+
+/* mrpriv defines */
+#define MR_PD_INVALID 0xFFFF
+#define MAX_SPAN_DEPTH 8
+#define MAX_RAIDMAP_SPAN_DEPTH (MAX_SPAN_DEPTH)
+#define MAX_ROW_SIZE 32
+#define MAX_RAIDMAP_ROW_SIZE (MAX_ROW_SIZE)
+#define MAX_LOGICAL_DRIVES 64
+#define MAX_RAIDMAP_LOGICAL_DRIVES (MAX_LOGICAL_DRIVES)
+#define MAX_RAIDMAP_VIEWS (MAX_LOGICAL_DRIVES)
+#define MAX_ARRAYS 128
+#define MAX_RAIDMAP_ARRAYS (MAX_ARRAYS)
+#define MAX_PHYSICAL_DEVICES 256
+#define MAX_RAIDMAP_PHYSICAL_DEVICES (MAX_PHYSICAL_DEVICES)
+#define MR_DCMD_LD_MAP_GET_INFO             0x0300e101
+
+struct MR_DEV_HANDLE_INFO {
+	u16     curDevHdl;
+	u8      validHandles;
+	u8      reserved;
+	u16     devHandle[2];
+};
+
+struct MR_ARRAY_INFO {
+	u16      pd[MAX_RAIDMAP_ROW_SIZE];
+};
+
+struct MR_QUAD_ELEMENT {
+	u64     logStart;
+	u64     logEnd;
+	u64     offsetInSpan;
+	u32     diff;
+	u32     reserved1;
+};
+
+struct MR_SPAN_INFO {
+	u32             noElements;
+	u32             reserved1;
+	struct MR_QUAD_ELEMENT quad[MAX_RAIDMAP_SPAN_DEPTH];
+};
+
+struct MR_LD_SPAN {
+	u64      startBlk;
+	u64      numBlks;
+	u16      arrayRef;
+	u8       reserved[6];
+};
+
+struct MR_SPAN_BLOCK_INFO {
+	u64          num_rows;
+	struct MR_LD_SPAN   span;
+	struct MR_SPAN_INFO block_span_info;
+};
+
+struct MR_LD_RAID {
+	struct {
+		u32     fpCapable:1;
+		u32     reserved5:3;
+		u32     ldPiMode:4;
+		u32     pdPiMode:4;
+		u32     encryptionType:8;
+		u32     fpWriteCapable:1;
+		u32     fpReadCapable:1;
+		u32     fpWriteAcrossStripe:1;
+		u32     fpReadAcrossStripe:1;
+		u32     reserved4:8;
+	} capability;
+	u32     reserved6;
+	u64     size;
+	u8      spanDepth;
+	u8      level;
+	u8      stripeShift;
+	u8      rowSize;
+	u8      rowDataSize;
+	u8      writeMode;
+	u8      PRL;
+	u8      SRL;
+	u16     targetId;
+	u8      ldState;
+	u8      regTypeReqOnWrite;
+	u8      modFactor;
+	u8      reserved2[1];
+	u16     seqNum;
+
+	struct {
+		u32 ldSyncRequired:1;
+		u32 reserved:31;
+	} flags;
+
+	u8      reserved3[0x5C];
+};
+
+struct MR_LD_SPAN_MAP {
+	struct MR_LD_RAID          ldRaid;
+	u8                  dataArmMap[MAX_RAIDMAP_ROW_SIZE];
+	struct MR_SPAN_BLOCK_INFO  spanBlock[MAX_RAIDMAP_SPAN_DEPTH];
+};
+
+struct MR_FW_RAID_MAP {
+	u32                 totalSize;
+	union {
+		struct {
+			u32         maxLd;
+			u32         maxSpanDepth;
+			u32         maxRowSize;
+			u32         maxPdCount;
+			u32         maxArrays;
+		} validationInfo;
+		u32             version[5];
+		u32             reserved1[5];
+	};
+
+	u32                 ldCount;
+	u32                 Reserved1;
+	u8                  ldTgtIdToLd[MAX_RAIDMAP_LOGICAL_DRIVES+
+					MAX_RAIDMAP_VIEWS];
+	u8                  fpPdIoTimeoutSec;
+	u8                  reserved2[7];
+	struct MR_ARRAY_INFO       arMapInfo[MAX_RAIDMAP_ARRAYS];
+	struct MR_DEV_HANDLE_INFO  devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES];
+	struct MR_LD_SPAN_MAP      ldSpanMap[1];
+};
+
+struct IO_REQUEST_INFO {
+	u64 ldStartBlock;
+	u32 numBlocks;
+	u16 ldTgtId;
+	u8 isRead;
+	u16 devHandle;
+	u64 pdBlock;
+	u8 fpOkForIo;
+};
+
+struct MR_LD_TARGET_SYNC {
+	u8  targetId;
+	u8  reserved;
+	u16 seqNum;
+};
+
+#define IEEE_SGE_FLAGS_ADDR_MASK            (0x03)
+#define IEEE_SGE_FLAGS_SYSTEM_ADDR          (0x00)
+#define IEEE_SGE_FLAGS_IOCDDR_ADDR          (0x01)
+#define IEEE_SGE_FLAGS_IOCPLB_ADDR          (0x02)
+#define IEEE_SGE_FLAGS_IOCPLBNTA_ADDR       (0x03)
+#define IEEE_SGE_FLAGS_CHAIN_ELEMENT        (0x80)
+#define IEEE_SGE_FLAGS_END_OF_LIST          (0x40)
+
+struct megasas_register_set;
+struct megasas_instance;
+
+union desc_word {
+	u64 word;
+	struct {
+		u32 low;
+		u32 high;
+	} u;
+};
+
+struct megasas_cmd_fusion {
+	struct MPI2_RAID_SCSI_IO_REQUEST	*io_request;
+	dma_addr_t			io_request_phys_addr;
+
+	union MPI2_SGE_IO_UNION	*sg_frame;
+	dma_addr_t		sg_frame_phys_addr;
+
+	u8 *sense;
+	dma_addr_t sense_phys_addr;
+
+	struct list_head list;
+	struct scsi_cmnd *scmd;
+	struct megasas_instance *instance;
+
+	u8 retry_for_fw_reset;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION  *request_desc;
+
+	/*
+	 * Context for a MFI frame.
+	 * Used to get the mfi cmd from list when a MFI cmd is completed
+	 */
+	u32 sync_cmd_idx;
+	u32 index;
+	u8 flags;
+};
+
+struct LD_LOAD_BALANCE_INFO {
+	u8	loadBalanceFlag;
+	u8	reserved1;
+	u16     raid1DevHandle[2];
+	atomic_t     scsi_pending_cmds[2];
+	u64     last_accessed_block[2];
+};
+
+struct MR_FW_RAID_MAP_ALL {
+	struct MR_FW_RAID_MAP raidMap;
+	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES - 1];
+} __attribute__ ((packed));
+
+struct fusion_context {
+	struct megasas_cmd_fusion **cmd_list;
+	struct list_head cmd_pool;
+
+	spinlock_t cmd_pool_lock;
+
+	dma_addr_t req_frames_desc_phys;
+	u8 *req_frames_desc;
+
+	struct dma_pool *io_request_frames_pool;
+	dma_addr_t io_request_frames_phys;
+	u8 *io_request_frames;
+
+	struct dma_pool *sg_dma_pool;
+	struct dma_pool *sense_dma_pool;
+
+	dma_addr_t reply_frames_desc_phys;
+	union MPI2_REPLY_DESCRIPTORS_UNION *reply_frames_desc;
+	struct dma_pool *reply_frames_desc_pool;
+
+	u16 last_reply_idx;
+
+	u32 reply_q_depth;
+	u32 request_alloc_sz;
+	u32 reply_alloc_sz;
+	u32 io_frames_alloc_sz;
+
+	u16	max_sge_in_main_msg;
+	u16	max_sge_in_chain;
+
+	u8	chain_offset_io_request;
+	u8	chain_offset_mfi_pthru;
+
+	struct MR_FW_RAID_MAP_ALL *ld_map[2];
+	dma_addr_t ld_map_phys[2];
+
+	u32 map_sz;
+	u8 fast_path_io;
+	struct LD_LOAD_BALANCE_INFO load_balance_info[MAX_LOGICAL_DRIVES];
+};
+
+union desc_value {
+	u64 word;
+	struct {
+		u32 low;
+		u32 high;
+	} u;
+};
+
+#endif /* _MEGARAID_SAS_FUSION_H_ */

--0016363b8520b0a5f904976a37c2
Content-Type: application/octet-stream; name="megaraid_sas.patch8"
Content-Disposition: attachment; filename="megaraid_sas.patch8"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpmxxz50

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Z1c2lvbi5oIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgKLS0tIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgJMTk2OS0xMi0zMSAxNjowMDow
MC4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9t
ZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgJMjAxMC0xMi0xNCAxNzoxNjoyNi4wMDAwMDAw
MDAgLTA4MDAKQEAgLTAsMCArMSw2OTUgQEAKKy8qCisgKiAgTGludXggTWVnYVJBSUQgZHJpdmVy
IGZvciBTQVMgYmFzZWQgUkFJRCBjb250cm9sbGVycworICoKKyAqICBDb3B5cmlnaHQgKGMpIDIw
MDktMjAxMSAgTFNJIENvcnBvcmF0aW9uLgorICoKKyAqICBUaGlzIHByb2dyYW0gaXMgZnJlZSBz
b2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCisgKiAgbW9kaWZ5IGl0IHVu
ZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAqICBhcyBw
dWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24g
MgorICogIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJz
aW9uLgorICoKKyAqICBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhh
dCBpdCB3aWxsIGJlIHVzZWZ1bCwKKyAqICBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhv
dXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogIE1FUkNIQU5UQUJJTElUWSBvciBG
SVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUKKyAqICBHTlUgR2VuZXJh
bCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorICoKKyAqICBZb3Ugc2hvdWxkIGhh
dmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICog
IGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3
YXJlCisgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJv
c3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKKyAqCisgKiAgRklMRTogbWVnYXJhaWRfc2FzX2Z1c2lv
bi5oCisgKgorICogIEF1dGhvcnM6IExTSSBDb3Jwb3JhdGlvbgorICogICAgICAgICAgIE1hbm9q
IEpvc2UKKyAqICAgICAgICAgICBTdW1hbnQgUGF0cm8KKyAqCisgKiAgU2VuZCBmZWVkYmFjayB0
bzogPG1lZ2FyYWlkbGludXhAbHNpLmNvbT4KKyAqCisgKiAgTWFpbCB0bzogTFNJIENvcnBvcmF0
aW9uLCAxNjIxIEJhcmJlciBMYW5lLCBNaWxwaXRhcywgQ0EgOTUwMzUKKyAqICAgICBBVFROOiBM
aW51eHJhaWQKKyAqLworCisjaWZuZGVmIF9NRUdBUkFJRF9TQVNfRlVTSU9OX0hfCisjZGVmaW5l
IF9NRUdBUkFJRF9TQVNfRlVTSU9OX0hfCisKKy8qIEZ1c2lvbiBkZWZpbmVzICovCisjZGVmaW5l
IE1FR0FTQVNfTUFYX1NaX0NIQUlOX0ZSQU1FIDEwMjQKKyNkZWZpbmUgTUZJX0ZVU0lPTl9FTkFC
TEVfSU5URVJSVVBUX01BU0sgKDB4MDAwMDAwMDkpCisjZGVmaW5lIE1FR0FfTVBJMl9SQUlEX0RF
RkFVTFRfSU9fRlJBTUVfU0laRSAyNTYKKyNkZWZpbmUgTUVHQVNBU19NUEkyX0ZVTkNUSU9OX1BB
U1NUSFJVX0lPX1JFUVVFU1QgICAweEYwCisjZGVmaW5lIE1FR0FTQVNfTVBJMl9GVU5DVElPTl9M
RF9JT19SRVFVRVNUICAgICAgICAgMHhGMQorI2RlZmluZSBNRUdBU0FTX0xPQURfQkFMQU5DRV9G
TEFHCQkgICAgMHgxCisjZGVmaW5lIE1FR0FTQVNfRENNRF9NQk9YX1BFTkRfRkxBRwkJICAgIDB4
MQorI2RlZmluZSBIT1NUX0RJQUdfV1JJVEVfRU5BQkxFCQkJICAgIDB4ODAKKyNkZWZpbmUgSE9T
VF9ESUFHX1JFU0VUX0FEQVBURVIJCQkgICAgMHg0CisjZGVmaW5lIE1FR0FTQVNfRlVTSU9OX01B
WF9SRVNFVF9UUklFUwkJICAgIDMKKworLyogVDEwIFBJIGRlZmluZXMgKi8KKyNkZWZpbmUgTVJf
UFJPVF9JTkZPX1RZUEVfQ09OVFJPTExFUiAgICAgICAgICAgICAgICAweDgKKyNkZWZpbmUgTUVH
QVNBU19TQ1NJX1ZBUklBQkxFX0xFTkdUSF9DTUQgICAgICAgICAgICAweDdmCisjZGVmaW5lIE1F
R0FTQVNfU0NTSV9TRVJWSUNFX0FDVElPTl9SRUFEMzIgICAgICAgICAgMHg5CisjZGVmaW5lIE1F
R0FTQVNfU0NTSV9TRVJWSUNFX0FDVElPTl9XUklURTMyICAgICAgICAgMHhCCisjZGVmaW5lIE1F
R0FTQVNfU0NTSV9BRERMX0NEQl9MRU4gICAgICAgICAgICAgICAgICAgMHgxOAorI2RlZmluZSBN
RUdBU0FTX1JEX1dSX1BST1RFQ1RfQ0hFQ0tfQUxMCQkgICAgMHgyMAorI2RlZmluZSBNRUdBU0FT
X1JEX1dSX1BST1RFQ1RfQ0hFQ0tfTk9ORQkgICAgMHg2MAorI2RlZmluZSBNRUdBU0FTX0VFRFBC
TE9DS1NJWkUJCQkgICAgNTEyCisKKy8qCisgKiBSYWlkIGNvbnRleHQgZmxhZ3MKKyAqLworCisj
ZGVmaW5lIE1SX1JBSURfQ1RYX1JBSURfRkxBR1NfSU9fU1VCX1RZUEVfU0hJRlQgICAweDQKKyNk
ZWZpbmUgTVJfUkFJRF9DVFhfUkFJRF9GTEFHU19JT19TVUJfVFlQRV9NQVNLICAgIDB4MzAKK2Vu
dW0gTVJfUkFJRF9GTEFHU19JT19TVUJfVFlQRSB7CisJTVJfUkFJRF9GTEFHU19JT19TVUJfVFlQ
RV9OT05FID0gMCwKKwlNUl9SQUlEX0ZMQUdTX0lPX1NVQl9UWVBFX1NZU1RFTV9QRCA9IDEsCit9
OworCisvKgorICogUmVxdWVzdCBkZXNjcmlwdG9yIHR5cGVzCisgKi8KKyNkZWZpbmUgTUVHQVNB
U19SRVFfREVTQ1JJUFRfRkxBR1NfTERfSU8gICAgICAgICAgIDB4NworI2RlZmluZSBNRUdBU0FT
X1JFUV9ERVNDUklQVF9GTEFHU19NRkEgICAgICAgICAgICAgMHgxCisKKyNkZWZpbmUgTUVHQVNB
U19SRVFfREVTQ1JJUFRfRkxBR1NfVFlQRV9TSElGVCAgICAgIDEKKworI2RlZmluZSBNRUdBU0FT
X0ZQX0NNRF9MRU4JMTYKKyNkZWZpbmUgTUVHQVNBU19GVVNJT05fSU5fUkVTRVQgMAorCisvKgor
ICogUmFpZCBDb250ZXh0IHN0cnVjdHVyZSB3aGljaCBkZXNjcmliZXMgTWVnYVJBSUQgc3BlY2lm
aWMgSU8gUGFyYW1lbnRlcnMKKyAqIFRoaXMgcmVzaWRlcyBhdCBvZmZzZXQgMHg2MCB3aGVyZSB0
aGUgU0dMIG5vcm1hbGx5IHN0YXJ0cyBpbiBNUFQgSU8gRnJhbWVzCisgKi8KKworc3RydWN0IFJB
SURfQ09OVEVYVCB7CisJdTE2ICAgICByZXN2ZDA7CisJdTE2ICAgICB0aW1lb3V0VmFsdWU7CisJ
dTggICAgICByZWdMb2NrRmxhZ3M7CisJdTggICAgICByZXN2ZDE7CisJdTE2ICAgICBWaXJ0dWFs
RGlza1RndElkOworCXU2NCAgICAgcmVnTG9ja1Jvd0xCQTsKKwl1MzIgICAgIHJlZ0xvY2tMZW5n
dGg7CisJdTE2ICAgICBuZXh0TE1JZDsKKwl1OCAgICAgIGV4U3RhdHVzOworCXU4ICAgICAgc3Rh
dHVzOworCXU4ICAgICAgUkFJREZsYWdzOworCXU4ICAgICAgbnVtU0dFOworCXUxNgljb25maWdT
ZXFOdW07CisJdTggICAgICBzcGFuQXJtOworCXU4ICAgICAgcmVzdmQyWzNdOworfTsKKworI2Rl
ZmluZSBSQUlEX0NUWF9TUEFOQVJNX0FSTV9TSElGVAkoMCkKKyNkZWZpbmUgUkFJRF9DVFhfU1BB
TkFSTV9BUk1fTUFTSwkoMHgxZikKKworI2RlZmluZSBSQUlEX0NUWF9TUEFOQVJNX1NQQU5fU0hJ
RlQJKDUpCisjZGVmaW5lIFJBSURfQ1RYX1NQQU5BUk1fU1BBTl9NQVNLCSgweEUwKQorCisvKgor
ICogZGVmaW5lIHJlZ2lvbiBsb2NrIHR5cGVzCisgKi8KK2VudW0gUkVHSU9OX1RZUEUgeworCVJF
R0lPTl9UWVBFX1VOVVNFRCAgICAgICA9IDAsCisJUkVHSU9OX1RZUEVfU0hBUkVEX1JFQUQgID0g
MSwKKwlSRUdJT05fVFlQRV9TSEFSRURfV1JJVEUgPSAyLAorCVJFR0lPTl9UWVBFX0VYQ0xVU0lW
RSAgICA9IDMsCit9OworCisvKiBNUEkyIGRlZmluZXMgKi8KKyNkZWZpbmUgTVBJMl9GVU5DVElP
Tl9JT0NfSU5JVCAgICAgICAgICAgICAgKDB4MDIpIC8qIElPQyBJbml0ICovCisjZGVmaW5lIE1Q
STJfV0hPSU5JVF9IT1NUX0RSSVZFUiAgICAgICAgICAgICgweDA0KQorI2RlZmluZSBNUEkyX1ZF
UlNJT05fTUFKT1IgICAgICAgICAgICAgICAgICAoMHgwMikKKyNkZWZpbmUgTVBJMl9WRVJTSU9O
X01JTk9SICAgICAgICAgICAgICAgICAgKDB4MDApCisjZGVmaW5lIE1QSTJfVkVSU0lPTl9NQUpP
Ul9NQVNLICAgICAgICAgICAgICgweEZGMDApCisjZGVmaW5lIE1QSTJfVkVSU0lPTl9NQUpPUl9T
SElGVCAgICAgICAgICAgICg4KQorI2RlZmluZSBNUEkyX1ZFUlNJT05fTUlOT1JfTUFTSyAgICAg
ICAgICAgICAoMHgwMEZGKQorI2RlZmluZSBNUEkyX1ZFUlNJT05fTUlOT1JfU0hJRlQgICAgICAg
ICAgICAoMCkKKyNkZWZpbmUgTVBJMl9WRVJTSU9OICgoTVBJMl9WRVJTSU9OX01BSk9SIDw8IE1Q
STJfVkVSU0lPTl9NQUpPUl9TSElGVCkgfCBcCisJCSAgICAgIE1QSTJfVkVSU0lPTl9NSU5PUikK
KyNkZWZpbmUgTVBJMl9IRUFERVJfVkVSU0lPTl9VTklUICAgICAgICAgICAgKDB4MTApCisjZGVm
aW5lIE1QSTJfSEVBREVSX1ZFUlNJT05fREVWICAgICAgICAgICAgICgweDAwKQorI2RlZmluZSBN
UEkyX0hFQURFUl9WRVJTSU9OX1VOSVRfTUFTSyAgICAgICAoMHhGRjAwKQorI2RlZmluZSBNUEky
X0hFQURFUl9WRVJTSU9OX1VOSVRfU0hJRlQgICAgICAoOCkKKyNkZWZpbmUgTVBJMl9IRUFERVJf
VkVSU0lPTl9ERVZfTUFTSyAgICAgICAgKDB4MDBGRikKKyNkZWZpbmUgTVBJMl9IRUFERVJfVkVS
U0lPTl9ERVZfU0hJRlQgICAgICAgKDApCisjZGVmaW5lIE1QSTJfSEVBREVSX1ZFUlNJT04gKChN
UEkyX0hFQURFUl9WRVJTSU9OX1VOSVQgPDwgOCkgfCBcCisJCQkgICAgIE1QSTJfSEVBREVSX1ZF
UlNJT05fREVWKQorI2RlZmluZSBNUEkyX0lFRUVfU0dFX0ZMQUdTX0lPQ1BMQk5UQV9BRERSICAg
ICAgKDB4MDMpCisjZGVmaW5lIE1QSTJfU0NTSUlPX0VFRFBGTEFHU19JTkNfUFJJX1JFRlRBRyAg
ICAgICAgKDB4ODAwMCkKKyNkZWZpbmUgTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX1JFRlRB
RyAgICAgICAgICAoMHgwNDAwKQorI2RlZmluZSBNUEkyX1NDU0lJT19FRURQRkxBR1NfQ0hFQ0tf
UkVNT1ZFX09QICAgICAgICgweDAwMDMpCisjZGVmaW5lIE1QSTJfU0NTSUlPX0VFRFBGTEFHU19D
SEVDS19BUFBUQUcgICAgICAgICAgKDB4MDIwMCkKKyNkZWZpbmUgTVBJMl9TQ1NJSU9fRUVEUEZM
QUdTX0NIRUNLX0dVQVJEICAgICAgICAgICAoMHgwMTAwKQorI2RlZmluZSBNUEkyX1NDU0lJT19F
RURQRkxBR1NfSU5TRVJUX09QICAgICAgICAgICAgICgweDAwMDQpCisjZGVmaW5lIE1QSTJfRlVO
Q1RJT05fU0NTSV9JT19SRVFVRVNUICAgICAgICAgICAgICAgKDB4MDApIC8qIFNDU0kgSU8gKi8K
KyNkZWZpbmUgTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1NfSElHSF9QUklPUklUWSAgICAgICAgICAg
KDB4MDYpCisjZGVmaW5lIE1QSTJfUkVRX0RFU0NSSVBUX0ZMQUdTX1NDU0lfSU8gICAgICAgICAg
ICAgICAgICgweDAwKQorI2RlZmluZSBNUEkyX1NHRV9GTEFHU182NF9CSVRfQUREUkVTU0lORyAg
ICAgICAgKDB4MDIpCisjZGVmaW5lIE1QSTJfU0NTSUlPX0NPTlRST0xfV1JJVEUgICAgICAgICAg
ICAgICAoMHgwMTAwMDAwMCkKKyNkZWZpbmUgTVBJMl9TQ1NJSU9fQ09OVFJPTF9SRUFEICAgICAg
ICAgICAgICAgICgweDAyMDAwMDAwKQorI2RlZmluZSBNUEkyX1JFUV9ERVNDUklQVF9GTEFHU19U
WVBFX01BU0sgICAgICAgKDB4MEUpCisjZGVmaW5lIE1QSTJfUlBZX0RFU0NSSVBUX0ZMQUdTX1VO
VVNFRCAgICAgICAgICAoMHgwRikKKyNkZWZpbmUgTVBJMl9SUFlfREVTQ1JJUFRfRkxBR1NfU0NT
SV9JT19TVUNDRVNTICgweDAwKQorI2RlZmluZSBNUEkyX1JQWV9ERVNDUklQVF9GTEFHU19UWVBF
X01BU0sgICAgICAgKDB4MEYpCisjZGVmaW5lIE1QSTJfV1JTRVFfRkxVU0hfS0VZX1ZBTFVFICAg
ICAgICAgICAgICAoMHgwKQorI2RlZmluZSBNUEkyX1dSSVRFX1NFUVVFTkNFX09GRlNFVCAgICAg
ICAgICAgICAgKDB4MDAwMDAwMDQpCisjZGVmaW5lIE1QSTJfV1JTRVFfMVNUX0tFWV9WQUxVRSAg
ICAgICAgICAgICAgICAoMHhGKQorI2RlZmluZSBNUEkyX1dSU0VRXzJORF9LRVlfVkFMVUUgICAg
ICAgICAgICAgICAgKDB4NCkKKyNkZWZpbmUgTVBJMl9XUlNFUV8zUkRfS0VZX1ZBTFVFICAgICAg
ICAgICAgICAgICgweEIpCisjZGVmaW5lIE1QSTJfV1JTRVFfNFRIX0tFWV9WQUxVRSAgICAgICAg
ICAgICAgICAoMHgyKQorI2RlZmluZSBNUEkyX1dSU0VRXzVUSF9LRVlfVkFMVUUgICAgICAgICAg
ICAgICAgKDB4NykKKyNkZWZpbmUgTVBJMl9XUlNFUV82VEhfS0VZX1ZBTFVFICAgICAgICAgICAg
ICAgICgweEQpCisKK3N0cnVjdCBNUEkyNV9JRUVFX1NHRV9DSEFJTjY0IHsKKwl1NjQgICAgICAg
ICAgICAgICAgICAgICBBZGRyZXNzOworCXUzMiAgICAgICAgICAgICAgICAgICAgIExlbmd0aDsK
Kwl1MTYgICAgICAgICAgICAgICAgICAgICBSZXNlcnZlZDE7CisJdTggICAgICAgICAgICAgICAg
ICAgICAgTmV4dENoYWluT2Zmc2V0OworCXU4ICAgICAgICAgICAgICAgICAgICAgIEZsYWdzOwor
fTsKKworc3RydWN0IE1QSTJfU0dFX1NJTVBMRV9VTklPTiB7CisJdTMyICAgICAgICAgICAgICAg
ICAgICAgRmxhZ3NMZW5ndGg7CisJdW5pb24geworCQl1MzIgICAgICAgICAgICAgICAgIEFkZHJl
c3MzMjsKKwkJdTY0ICAgICAgICAgICAgICAgICBBZGRyZXNzNjQ7CisJfSB1OworfTsKKworc3Ry
dWN0IE1QSTJfU0NTSV9JT19DREJfRUVEUDMyIHsKKwl1OCAgICAgICAgICAgICAgICAgICAgICBD
REJbMjBdOyAgICAgICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXUzMiAgICAgICAgICAgICAg
ICAgICAgIFByaW1hcnlSZWZlcmVuY2VUYWc7ICAgICAgICAvKiAweDE0ICovCisJdTE2ICAgICAg
ICAgICAgICAgICAgICAgUHJpbWFyeUFwcGxpY2F0aW9uVGFnOyAgICAgIC8qIDB4MTggKi8KKwl1
MTYgICAgICAgICAgICAgICAgICAgICBQcmltYXJ5QXBwbGljYXRpb25UYWdNYXNrOyAgLyogMHgx
QSAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIFRyYW5zZmVyTGVuZ3RoOyAgICAgICAgICAg
ICAvKiAweDFDICovCit9OworCitzdHJ1Y3QgTVBJMl9TR0VfQ0hBSU5fVU5JT04geworCXUxNiAg
ICAgICAgICAgICAgICAgICAgIExlbmd0aDsKKwl1OCAgICAgICAgICAgICAgICAgICAgICBOZXh0
Q2hhaW5PZmZzZXQ7CisJdTggICAgICAgICAgICAgICAgICAgICAgRmxhZ3M7CisJdW5pb24gewor
CQl1MzIgICAgICAgICAgICAgICAgIEFkZHJlc3MzMjsKKwkJdTY0ICAgICAgICAgICAgICAgICBB
ZGRyZXNzNjQ7CisJfSB1OworfTsKKworc3RydWN0IE1QSTJfSUVFRV9TR0VfU0lNUExFMzIgewor
CXUzMiAgICAgICAgICAgICAgICAgICAgIEFkZHJlc3M7CisJdTMyICAgICAgICAgICAgICAgICAg
ICAgRmxhZ3NMZW5ndGg7Cit9OworCitzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9DSEFJTjMyIHsKKwl1
MzIgICAgICAgICAgICAgICAgICAgICBBZGRyZXNzOworCXUzMiAgICAgICAgICAgICAgICAgICAg
IEZsYWdzTGVuZ3RoOworfTsKKworc3RydWN0IE1QSTJfSUVFRV9TR0VfU0lNUExFNjQgeworCXU2
NCAgICAgICAgICAgICAgICAgICAgIEFkZHJlc3M7CisJdTMyICAgICAgICAgICAgICAgICAgICAg
TGVuZ3RoOworCXUxNiAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkMTsKKwl1OCAgICAgICAg
ICAgICAgICAgICAgICBSZXNlcnZlZDI7CisJdTggICAgICAgICAgICAgICAgICAgICAgRmxhZ3M7
Cit9OworCitzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9DSEFJTjY0IHsKKwl1NjQgICAgICAgICAgICAg
ICAgICAgICBBZGRyZXNzOworCXUzMiAgICAgICAgICAgICAgICAgICAgIExlbmd0aDsKKwl1MTYg
ICAgICAgICAgICAgICAgICAgICBSZXNlcnZlZDE7CisJdTggICAgICAgICAgICAgICAgICAgICAg
UmVzZXJ2ZWQyOworCXU4ICAgICAgICAgICAgICAgICAgICAgIEZsYWdzOworfTsKKwordW5pb24g
TVBJMl9JRUVFX1NHRV9TSU1QTEVfVU5JT04geworCXN0cnVjdCBNUEkyX0lFRUVfU0dFX1NJTVBM
RTMyICBTaW1wbGUzMjsKKwlzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9TSU1QTEU2NCAgU2ltcGxlNjQ7
Cit9OworCit1bmlvbiBNUEkyX0lFRUVfU0dFX0NIQUlOX1VOSU9OIHsKKwlzdHJ1Y3QgTVBJMl9J
RUVFX1NHRV9DSEFJTjMyICAgQ2hhaW4zMjsKKwlzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9DSEFJTjY0
ICAgQ2hhaW42NDsKK307CisKK3VuaW9uIE1QSTJfU0dFX0lPX1VOSU9OIHsKKwlzdHJ1Y3QgTVBJ
Ml9TR0VfU0lNUExFX1VOSU9OICAgICAgIE1waVNpbXBsZTsKKwlzdHJ1Y3QgTVBJMl9TR0VfQ0hB
SU5fVU5JT04gICAgICAgIE1waUNoYWluOworCXVuaW9uIE1QSTJfSUVFRV9TR0VfU0lNUExFX1VO
SU9OICBJZWVlU2ltcGxlOworCXVuaW9uIE1QSTJfSUVFRV9TR0VfQ0hBSU5fVU5JT04gICBJZWVl
Q2hhaW47Cit9OworCit1bmlvbiBNUEkyX1NDU0lfSU9fQ0RCX1VOSU9OIHsKKwl1OCAgICAgICAg
ICAgICAgICAgICAgICBDREIzMlszMl07CisJc3RydWN0IE1QSTJfU0NTSV9JT19DREJfRUVEUDMy
IEVFRFAzMjsKKwlzdHJ1Y3QgTVBJMl9TR0VfU0lNUExFX1VOSU9OIFNHRTsKK307CisKKy8qCisg
KiBSQUlEIFNDU0kgSU8gUmVxdWVzdCBNZXNzYWdlCisgKiBUb3RhbCBTR0UgY291bnQgd2lsbCBi
ZSBvbmUgbGVzcyB0aGFuICBfTVBJMl9TQ1NJX0lPX1JFUVVFU1QKKyAqLworc3RydWN0IE1QSTJf
UkFJRF9TQ1NJX0lPX1JFUVVFU1QgeworCXUxNiAgICAgICAgICAgICAgICAgICAgIERldkhhbmRs
ZTsgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICAgICAg
ICAgIENoYWluT2Zmc2V0OyAgICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXU4ICAgICAg
ICAgICAgICAgICAgICAgIEZ1bmN0aW9uOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMyAq
LworCXUxNiAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkMTsgICAgICAgICAgICAgICAgICAg
ICAgLyogMHgwNCAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkMjsgICAgICAg
ICAgICAgICAgICAgICAgLyogMHgwNiAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIE1zZ0Zs
YWdzOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwNyAqLworCXU4ICAgICAgICAgICAgICAg
ICAgICAgIFZQX0lEOyAgICAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwOCAqLworCXU4ICAg
ICAgICAgICAgICAgICAgICAgIFZGX0lEOyAgICAgICAgICAgICAgICAgICAgICAgICAgLyogMHgw
OSAqLworCXUxNiAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkMzsgICAgICAgICAgICAgICAg
ICAgICAgLyogMHgwQSAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIFNlbnNlQnVmZmVyTG93
QWRkcmVzczsgICAgICAgICAgLyogMHgwQyAqLworCXUxNiAgICAgICAgICAgICAgICAgICAgIFNH
TEZsYWdzOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgxMCAqLworCXU4ICAgICAgICAgICAg
ICAgICAgICAgIFNlbnNlQnVmZmVyTGVuZ3RoOyAgICAgICAgICAgICAgLyogMHgxMiAqLworCXU4
ICAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkNDsgICAgICAgICAgICAgICAgICAgICAgLyog
MHgxMyAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFNHTE9mZnNldDA7ICAgICAgICAgICAg
ICAgICAgICAgLyogMHgxNCAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFNHTE9mZnNldDE7
ICAgICAgICAgICAgICAgICAgICAgLyogMHgxNSAqLworCXU4ICAgICAgICAgICAgICAgICAgICAg
IFNHTE9mZnNldDI7ICAgICAgICAgICAgICAgICAgICAgLyogMHgxNiAqLworCXU4ICAgICAgICAg
ICAgICAgICAgICAgIFNHTE9mZnNldDM7ICAgICAgICAgICAgICAgICAgICAgLyogMHgxNyAqLwor
CXUzMiAgICAgICAgICAgICAgICAgICAgIFNraXBDb3VudDsgICAgICAgICAgICAgICAgICAgICAg
LyogMHgxOCAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIERhdGFMZW5ndGg7ICAgICAgICAg
ICAgICAgICAgICAgLyogMHgxQyAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIEJpZGlyZWN0
aW9uYWxEYXRhTGVuZ3RoOyAgICAgICAgLyogMHgyMCAqLworCXUxNiAgICAgICAgICAgICAgICAg
ICAgIElvRmxhZ3M7ICAgICAgICAgICAgICAgICAgICAgICAgLyogMHgyNCAqLworCXUxNiAgICAg
ICAgICAgICAgICAgICAgIEVFRFBGbGFnczsgICAgICAgICAgICAgICAgICAgICAgLyogMHgyNiAq
LworCXUzMiAgICAgICAgICAgICAgICAgICAgIEVFRFBCbG9ja1NpemU7ICAgICAgICAgICAgICAg
ICAgLyogMHgyOCAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIFNlY29uZGFyeVJlZmVyZW5j
ZVRhZzsgICAgICAgICAgLyogMHgyQyAqLworCXUxNiAgICAgICAgICAgICAgICAgICAgIFNlY29u
ZGFyeUFwcGxpY2F0aW9uVGFnOyAgICAgICAgLyogMHgzMCAqLworCXUxNiAgICAgICAgICAgICAg
ICAgICAgIEFwcGxpY2F0aW9uVGFnVHJhbnNsYXRpb25NYXNrOyAgLyogMHgzMiAqLworCXU4ICAg
ICAgICAgICAgICAgICAgICAgIExVTls4XTsgICAgICAgICAgICAgICAgICAgICAgICAgLyogMHgz
NCAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIENvbnRyb2w7ICAgICAgICAgICAgICAgICAg
ICAgICAgLyogMHgzQyAqLworCXVuaW9uIE1QSTJfU0NTSV9JT19DREJfVU5JT04gIENEQjsJCQkv
KiAweDQwICovCisJc3RydWN0IFJBSURfQ09OVEVYVAlSYWlkQ29udGV4dDsgICAgICAgICAgICAg
ICAgICAgIC8qIDB4NjAgKi8KKwl1bmlvbiBNUEkyX1NHRV9JT19VTklPTiAgICAgICBTR0w7CQkJ
LyogMHg4MCAqLworfTsKKworLyoKKyAqIE1QVCBSQUlEIE1GQSBJTyBEZXNjcmlwdG9yLgorICov
CitzdHJ1Y3QgTUVHQVNBU19SQUlEX01GQV9JT19SRVFVRVNUX0RFU0NSSVBUT1IgeworCXUzMiAg
ICAgUmVxdWVzdEZsYWdzOjg7CisJdTMyICAgICBNZXNzYWdlQWRkcmVzczE6MjQ7IC8qIGJpdHMg
MzE6OCovCisJdTMyICAgICBNZXNzYWdlQWRkcmVzczI7ICAgICAgLyogYml0cyA2MTozMiAqLwor
fTsKKworLyogRGVmYXVsdCBSZXF1ZXN0IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX0RFRkFV
TFRfUkVRVUVTVF9ERVNDUklQVE9SIHsKKwl1OCAgICAgICAgICAgICAgUmVxdWVzdEZsYWdzOyAg
ICAgICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAgICAgICAgICAgTVNJeEluZGV4OyAgICAg
ICAgICAgICAgICAgIC8qIDB4MDEgKi8KKwl1MTYgICAgICAgICAgICAgU01JRDsgICAgICAgICAg
ICAgICAgICAgICAgIC8qIDB4MDIgKi8KKwl1MTYgICAgICAgICAgICAgTE1JRDsgICAgICAgICAg
ICAgICAgICAgICAgIC8qIDB4MDQgKi8KKwl1MTYgICAgICAgICAgICAgRGVzY3JpcHRvclR5cGVE
ZXBlbmRlbnQ7ICAgIC8qIDB4MDYgKi8KK307CisKKy8qIEhpZ2ggUHJpb3JpdHkgUmVxdWVzdCBE
ZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9ISUdIX1BSSU9SSVRZX1JFUVVFU1RfREVTQ1JJUFRP
UiB7CisJdTggICAgICAgICAgICAgIFJlcXVlc3RGbGFnczsgICAgICAgICAgICAgICAvKiAweDAw
ICovCisJdTggICAgICAgICAgICAgIE1TSXhJbmRleDsgICAgICAgICAgICAgICAgICAvKiAweDAx
ICovCisJdTE2ICAgICAgICAgICAgIFNNSUQ7ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDAy
ICovCisJdTE2ICAgICAgICAgICAgIExNSUQ7ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDA0
ICovCisJdTE2ICAgICAgICAgICAgIFJlc2VydmVkMTsgICAgICAgICAgICAgICAgICAvKiAweDA2
ICovCit9OworCisvKiBTQ1NJIElPIFJlcXVlc3QgRGVzY3JpcHRvciAqLworc3RydWN0IE1QSTJf
U0NTSV9JT19SRVFVRVNUX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAgICBSZXF1ZXN0Rmxh
Z3M7ICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7
ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAgICAgICBTTUlEOyAgICAg
ICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXUxNiAgICAgICAgICAgICBMTUlEOyAgICAg
ICAgICAgICAgICAgICAgICAgLyogMHgwNCAqLworCXUxNiAgICAgICAgICAgICBEZXZIYW5kbGU7
ICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworfTsKKworLyogU0NTSSBUYXJnZXQgUmVxdWVz
dCBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9TQ1NJX1RBUkdFVF9SRVFVRVNUX0RFU0NSSVBU
T1IgeworCXU4ICAgICAgICAgICAgICBSZXF1ZXN0RmxhZ3M7ICAgICAgICAgICAgICAgLyogMHgw
MCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgw
MSAqLworCXUxNiAgICAgICAgICAgICBTTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgw
MiAqLworCXUxNiAgICAgICAgICAgICBMTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgw
NCAqLworCXUxNiAgICAgICAgICAgICBJb0luZGV4OyAgICAgICAgICAgICAgICAgICAgLyogMHgw
NiAqLworfTsKKworLyogUkFJRCBBY2NlbGVyYXRvciBSZXF1ZXN0IERlc2NyaXB0b3IgKi8KK3N0
cnVjdCBNUEkyX1JBSURfQUNDRUxfUkVRVUVTVF9ERVNDUklQVE9SIHsKKwl1OCAgICAgICAgICAg
ICAgUmVxdWVzdEZsYWdzOyAgICAgICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAgICAgICAg
ICAgTVNJeEluZGV4OyAgICAgICAgICAgICAgICAgIC8qIDB4MDEgKi8KKwl1MTYgICAgICAgICAg
ICAgU01JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDIgKi8KKwl1MTYgICAgICAgICAg
ICAgTE1JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDQgKi8KKwl1MTYgICAgICAgICAg
ICAgUmVzZXJ2ZWQ7ICAgICAgICAgICAgICAgICAgIC8qIDB4MDYgKi8KK307CisKKy8qIHVuaW9u
IG9mIFJlcXVlc3QgRGVzY3JpcHRvcnMgKi8KK3VuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQ
VE9SX1VOSU9OIHsKKwlzdHJ1Y3QgTVBJMl9ERUZBVUxUX1JFUVVFU1RfREVTQ1JJUFRPUiAgICAg
ICAgICAgICBEZWZhdWx0OworCXN0cnVjdCBNUEkyX0hJR0hfUFJJT1JJVFlfUkVRVUVTVF9ERVND
UklQVE9SICAgICAgIEhpZ2hQcmlvcml0eTsKKwlzdHJ1Y3QgTVBJMl9TQ1NJX0lPX1JFUVVFU1Rf
REVTQ1JJUFRPUiAgICAgICAgICAgICBTQ1NJSU87CisJc3RydWN0IE1QSTJfU0NTSV9UQVJHRVRf
UkVRVUVTVF9ERVNDUklQVE9SICAgICAgICAgU0NTSVRhcmdldDsKKwlzdHJ1Y3QgTVBJMl9SQUlE
X0FDQ0VMX1JFUVVFU1RfREVTQ1JJUFRPUiAgICAgICAgICBSQUlEQWNjZWxlcmF0b3I7CisJc3Ry
dWN0IE1FR0FTQVNfUkFJRF9NRkFfSU9fUkVRVUVTVF9ERVNDUklQVE9SICAgICAgTUZBSW87CisJ
dW5pb24geworCQlzdHJ1Y3QgeworCQkJdTMyIGxvdzsKKwkJCXUzMiBoaWdoOworCQl9IHU7CisJ
CXU2NCBXb3JkczsKKwl9OworfTsKKworLyogRGVmYXVsdCBSZXBseSBEZXNjcmlwdG9yICovCitz
dHJ1Y3QgTVBJMl9ERUZBVUxUX1JFUExZX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAgICBS
ZXBseUZsYWdzOyAgICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICBN
U0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAgICAgICBE
ZXNjcmlwdG9yVHlwZURlcGVuZGVudDE7ICAgLyogMHgwMiAqLworCXUzMiAgICAgICAgICAgICBE
ZXNjcmlwdG9yVHlwZURlcGVuZGVudDI7ICAgLyogMHgwNCAqLworfTsKKworLyogQWRkcmVzcyBS
ZXBseSBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9BRERSRVNTX1JFUExZX0RFU0NSSVBUT1Ig
eworCXU4ICAgICAgICAgICAgICBSZXBseUZsYWdzOyAgICAgICAgICAgICAgICAgLyogMHgwMCAq
LworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgwMSAq
LworCXUxNiAgICAgICAgICAgICBTTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMiAq
LworCXUzMiAgICAgICAgICAgICBSZXBseUZyYW1lQWRkcmVzczsgICAgICAgICAgLyogMHgwNCAq
LworfTsKKworLyogU0NTSSBJTyBTdWNjZXNzIFJlcGx5IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBN
UEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SIHsKKwl1OCAgICAgICAgICAgICAg
UmVwbHlGbGFnczsgICAgICAgICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAgICAgICAgICAg
TVNJeEluZGV4OyAgICAgICAgICAgICAgICAgIC8qIDB4MDEgKi8KKwl1MTYgICAgICAgICAgICAg
U01JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDIgKi8KKwl1MTYgICAgICAgICAgICAg
VGFza1RhZzsgICAgICAgICAgICAgICAgICAgIC8qIDB4MDQgKi8KKwl1MTYgICAgICAgICAgICAg
UmVzZXJ2ZWQxOyAgICAgICAgICAgICAgICAgIC8qIDB4MDYgKi8KK307CisKKy8qIFRhcmdldEFz
c2lzdCBTdWNjZXNzIFJlcGx5IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX1RBUkdFVEFTU0lT
VF9TVUNDRVNTX1JFUExZX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAgICBSZXBseUZsYWdz
OyAgICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7
ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAgICAgICBTTUlEOyAgICAg
ICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXU4ICAgICAgICAgICAgICBTZXF1ZW5jZU51
bWJlcjsgICAgICAgICAgICAgLyogMHgwNCAqLworCXU4ICAgICAgICAgICAgICBSZXNlcnZlZDE7
ICAgICAgICAgICAgICAgICAgLyogMHgwNSAqLworCXUxNiAgICAgICAgICAgICBJb0luZGV4OyAg
ICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworfTsKKworLyogVGFyZ2V0IENvbW1hbmQgQnVm
ZmVyIFJlcGx5IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX1RBUkdFVF9DT01NQU5EX0JVRkZF
Ul9SRVBMWV9ERVNDUklQVE9SIHsKKwl1OCAgICAgICAgICAgICAgUmVwbHlGbGFnczsgICAgICAg
ICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAgICAgICAgICAgTVNJeEluZGV4OyAgICAgICAg
ICAgICAgICAgIC8qIDB4MDEgKi8KKwl1OCAgICAgICAgICAgICAgVlBfSUQ7ICAgICAgICAgICAg
ICAgICAgICAgIC8qIDB4MDIgKi8KKwl1OCAgICAgICAgICAgICAgRmxhZ3M7ICAgICAgICAgICAg
ICAgICAgICAgIC8qIDB4MDMgKi8KKwl1MTYgICAgICAgICAgICAgSW5pdGlhdG9yRGV2SGFuZGxl
OyAgICAgICAgIC8qIDB4MDQgKi8KKwl1MTYgICAgICAgICAgICAgSW9JbmRleDsgICAgICAgICAg
ICAgICAgICAgIC8qIDB4MDYgKi8KK307CisKKy8qIFJBSUQgQWNjZWxlcmF0b3IgU3VjY2VzcyBS
ZXBseSBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9SQUlEX0FDQ0VMRVJBVE9SX1NVQ0NFU1Nf
UkVQTFlfREVTQ1JJUFRPUiB7CisJdTggICAgICAgICAgICAgIFJlcGx5RmxhZ3M7ICAgICAgICAg
ICAgICAgICAvKiAweDAwICovCisJdTggICAgICAgICAgICAgIE1TSXhJbmRleDsgICAgICAgICAg
ICAgICAgICAvKiAweDAxICovCisJdTE2ICAgICAgICAgICAgIFNNSUQ7ICAgICAgICAgICAgICAg
ICAgICAgICAvKiAweDAyICovCisJdTMyICAgICAgICAgICAgIFJlc2VydmVkOyAgICAgICAgICAg
ICAgICAgICAvKiAweDA0ICovCit9OworCisvKiB1bmlvbiBvZiBSZXBseSBEZXNjcmlwdG9ycyAq
LwordW5pb24gTVBJMl9SRVBMWV9ERVNDUklQVE9SU19VTklPTiB7CisJc3RydWN0IE1QSTJfREVG
QVVMVF9SRVBMWV9ERVNDUklQVE9SICAgICAgICAgICAgICAgICAgIERlZmF1bHQ7CisJc3RydWN0
IE1QSTJfQUREUkVTU19SRVBMWV9ERVNDUklQVE9SICAgICAgICAgICAgICAgICAgIEFkZHJlc3NS
ZXBseTsKKwlzdHJ1Y3QgTVBJMl9TQ1NJX0lPX1NVQ0NFU1NfUkVQTFlfREVTQ1JJUFRPUiAgICAg
ICAgICAgU0NTSUlPU3VjY2VzczsKKwlzdHJ1Y3QgTVBJMl9UQVJHRVRBU1NJU1RfU1VDQ0VTU19S
RVBMWV9ERVNDUklQVE9SIFRhcmdldEFzc2lzdFN1Y2Nlc3M7CisJc3RydWN0IE1QSTJfVEFSR0VU
X0NPTU1BTkRfQlVGRkVSX1JFUExZX0RFU0NSSVBUT1IgVGFyZ2V0Q29tbWFuZEJ1ZmZlcjsKKwlz
dHJ1Y3QgTVBJMl9SQUlEX0FDQ0VMRVJBVE9SX1NVQ0NFU1NfUkVQTFlfREVTQ1JJUFRPUgorCVJB
SURBY2NlbGVyYXRvclN1Y2Nlc3M7CisJdTY0ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgV29yZHM7Cit9OworCisvKiBJT0NJbml0IFJlcXVlc3QgbWVzc2FnZSAq
Lworc3RydWN0IE1QSTJfSU9DX0lOSVRfUkVRVUVTVCB7CisJdTggICAgICAgICAgICAgICAgICAg
ICAgV2hvSW5pdDsgICAgICAgICAgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTggICAgICAg
ICAgICAgICAgICAgICAgUmVzZXJ2ZWQxOyAgICAgICAgICAgICAgICAgICAgICAvKiAweDAxICov
CisJdTggICAgICAgICAgICAgICAgICAgICAgQ2hhaW5PZmZzZXQ7ICAgICAgICAgICAgICAgICAg
ICAvKiAweDAyICovCisJdTggICAgICAgICAgICAgICAgICAgICAgRnVuY3Rpb247ICAgICAgICAg
ICAgICAgICAgICAgICAvKiAweDAzICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2
ZWQyOyAgICAgICAgICAgICAgICAgICAgICAvKiAweDA0ICovCisJdTggICAgICAgICAgICAgICAg
ICAgICAgUmVzZXJ2ZWQzOyAgICAgICAgICAgICAgICAgICAgICAvKiAweDA2ICovCisJdTggICAg
ICAgICAgICAgICAgICAgICAgTXNnRmxhZ3M7ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDA3
ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgVlBfSUQ7ICAgICAgICAgICAgICAgICAgICAg
ICAgICAvKiAweDA4ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgVkZfSUQ7ICAgICAgICAg
ICAgICAgICAgICAgICAgICAvKiAweDA5ICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVz
ZXJ2ZWQ0OyAgICAgICAgICAgICAgICAgICAgICAvKiAweDBBICovCisJdTE2ICAgICAgICAgICAg
ICAgICAgICAgTXNnVmVyc2lvbjsgICAgICAgICAgICAgICAgICAgICAvKiAweDBDICovCisJdTE2
ICAgICAgICAgICAgICAgICAgICAgSGVhZGVyVmVyc2lvbjsgICAgICAgICAgICAgICAgICAvKiAw
eDBFICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQ1OyAgICAgICAgICAgICAg
ICAgICAgICAvKiAweDEwICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQ2OyAg
ICAgICAgICAgICAgICAgICAgICAvKiAweDE0ICovCisJdTggICAgICAgICAgICAgICAgICAgICAg
UmVzZXJ2ZWQ3OyAgICAgICAgICAgICAgICAgICAgICAvKiAweDE2ICovCisJdTggICAgICAgICAg
ICAgICAgICAgICAgSG9zdE1TSXhWZWN0b3JzOyAgICAgICAgICAgICAgICAvKiAweDE3ICovCisJ
dTE2ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQ4OyAgICAgICAgICAgICAgICAgICAgICAv
KiAweDE4ICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgU3lzdGVtUmVxdWVzdEZyYW1lU2l6
ZTsgICAgICAgICAvKiAweDFBICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVwbHlEZXNj
cmlwdG9yUG9zdFF1ZXVlRGVwdGg7ICAvKiAweDFDICovCisJdTE2ICAgICAgICAgICAgICAgICAg
ICAgUmVwbHlGcmVlUXVldWVEZXB0aDsgICAgICAgICAgICAvKiAweDFFICovCisJdTMyICAgICAg
ICAgICAgICAgICAgICAgU2Vuc2VCdWZmZXJBZGRyZXNzSGlnaDsgICAgICAgICAvKiAweDIwICov
CisJdTMyICAgICAgICAgICAgICAgICAgICAgU3lzdGVtUmVwbHlBZGRyZXNzSGlnaDsgICAgICAg
ICAvKiAweDI0ICovCisJdTY0ICAgICAgICAgICAgICAgICAgICAgU3lzdGVtUmVxdWVzdEZyYW1l
QmFzZUFkZHJlc3M7ICAvKiAweDI4ICovCisJdTY0ICAgICAgICAgICAgICAgICAgICAgUmVwbHlE
ZXNjcmlwdG9yUG9zdFF1ZXVlQWRkcmVzczsvKiAweDMwICovCisJdTY0ICAgICAgICAgICAgICAg
ICAgICAgUmVwbHlGcmVlUXVldWVBZGRyZXNzOyAgICAgICAgICAvKiAweDM4ICovCisJdTY0ICAg
ICAgICAgICAgICAgICAgICAgVGltZVN0YW1wOyAgICAgICAgICAgICAgICAgICAgICAvKiAweDQw
ICovCit9OworCisvKiBtcnByaXYgZGVmaW5lcyAqLworI2RlZmluZSBNUl9QRF9JTlZBTElEIDB4
RkZGRgorI2RlZmluZSBNQVhfU1BBTl9ERVBUSCA4CisjZGVmaW5lIE1BWF9SQUlETUFQX1NQQU5f
REVQVEggKE1BWF9TUEFOX0RFUFRIKQorI2RlZmluZSBNQVhfUk9XX1NJWkUgMzIKKyNkZWZpbmUg
TUFYX1JBSURNQVBfUk9XX1NJWkUgKE1BWF9ST1dfU0laRSkKKyNkZWZpbmUgTUFYX0xPR0lDQUxf
RFJJVkVTIDY0CisjZGVmaW5lIE1BWF9SQUlETUFQX0xPR0lDQUxfRFJJVkVTIChNQVhfTE9HSUNB
TF9EUklWRVMpCisjZGVmaW5lIE1BWF9SQUlETUFQX1ZJRVdTIChNQVhfTE9HSUNBTF9EUklWRVMp
CisjZGVmaW5lIE1BWF9BUlJBWVMgMTI4CisjZGVmaW5lIE1BWF9SQUlETUFQX0FSUkFZUyAoTUFY
X0FSUkFZUykKKyNkZWZpbmUgTUFYX1BIWVNJQ0FMX0RFVklDRVMgMjU2CisjZGVmaW5lIE1BWF9S
QUlETUFQX1BIWVNJQ0FMX0RFVklDRVMgKE1BWF9QSFlTSUNBTF9ERVZJQ0VTKQorI2RlZmluZSBN
Ul9EQ01EX0xEX01BUF9HRVRfSU5GTyAgICAgICAgICAgICAweDAzMDBlMTAxCisKK3N0cnVjdCBN
Ul9ERVZfSEFORExFX0lORk8geworCXUxNiAgICAgY3VyRGV2SGRsOworCXU4ICAgICAgdmFsaWRI
YW5kbGVzOworCXU4ICAgICAgcmVzZXJ2ZWQ7CisJdTE2ICAgICBkZXZIYW5kbGVbMl07Cit9Owor
CitzdHJ1Y3QgTVJfQVJSQVlfSU5GTyB7CisJdTE2ICAgICAgcGRbTUFYX1JBSURNQVBfUk9XX1NJ
WkVdOworfTsKKworc3RydWN0IE1SX1FVQURfRUxFTUVOVCB7CisJdTY0ICAgICBsb2dTdGFydDsK
Kwl1NjQgICAgIGxvZ0VuZDsKKwl1NjQgICAgIG9mZnNldEluU3BhbjsKKwl1MzIgICAgIGRpZmY7
CisJdTMyICAgICByZXNlcnZlZDE7Cit9OworCitzdHJ1Y3QgTVJfU1BBTl9JTkZPIHsKKwl1MzIg
ICAgICAgICAgICAgbm9FbGVtZW50czsKKwl1MzIgICAgICAgICAgICAgcmVzZXJ2ZWQxOworCXN0
cnVjdCBNUl9RVUFEX0VMRU1FTlQgcXVhZFtNQVhfUkFJRE1BUF9TUEFOX0RFUFRIXTsKK307CisK
K3N0cnVjdCBNUl9MRF9TUEFOIHsKKwl1NjQgICAgICBzdGFydEJsazsKKwl1NjQgICAgICBudW1C
bGtzOworCXUxNiAgICAgIGFycmF5UmVmOworCXU4ICAgICAgIHJlc2VydmVkWzZdOworfTsKKwor
c3RydWN0IE1SX1NQQU5fQkxPQ0tfSU5GTyB7CisJdTY0ICAgICAgICAgIG51bV9yb3dzOworCXN0
cnVjdCBNUl9MRF9TUEFOICAgc3BhbjsKKwlzdHJ1Y3QgTVJfU1BBTl9JTkZPIGJsb2NrX3NwYW5f
aW5mbzsKK307CisKK3N0cnVjdCBNUl9MRF9SQUlEIHsKKwlzdHJ1Y3QgeworCQl1MzIgICAgIGZw
Q2FwYWJsZToxOworCQl1MzIgICAgIHJlc2VydmVkNTozOworCQl1MzIgICAgIGxkUGlNb2RlOjQ7
CisJCXUzMiAgICAgcGRQaU1vZGU6NDsKKwkJdTMyICAgICBlbmNyeXB0aW9uVHlwZTo4OworCQl1
MzIgICAgIGZwV3JpdGVDYXBhYmxlOjE7CisJCXUzMiAgICAgZnBSZWFkQ2FwYWJsZToxOworCQl1
MzIgICAgIGZwV3JpdGVBY3Jvc3NTdHJpcGU6MTsKKwkJdTMyICAgICBmcFJlYWRBY3Jvc3NTdHJp
cGU6MTsKKwkJdTMyICAgICByZXNlcnZlZDQ6ODsKKwl9IGNhcGFiaWxpdHk7CisJdTMyICAgICBy
ZXNlcnZlZDY7CisJdTY0ICAgICBzaXplOworCXU4ICAgICAgc3BhbkRlcHRoOworCXU4ICAgICAg
bGV2ZWw7CisJdTggICAgICBzdHJpcGVTaGlmdDsKKwl1OCAgICAgIHJvd1NpemU7CisJdTggICAg
ICByb3dEYXRhU2l6ZTsKKwl1OCAgICAgIHdyaXRlTW9kZTsKKwl1OCAgICAgIFBSTDsKKwl1OCAg
ICAgIFNSTDsKKwl1MTYgICAgIHRhcmdldElkOworCXU4ICAgICAgbGRTdGF0ZTsKKwl1OCAgICAg
IHJlZ1R5cGVSZXFPbldyaXRlOworCXU4ICAgICAgbW9kRmFjdG9yOworCXU4ICAgICAgcmVzZXJ2
ZWQyWzFdOworCXUxNiAgICAgc2VxTnVtOworCisJc3RydWN0IHsKKwkJdTMyIGxkU3luY1JlcXVp
cmVkOjE7CisJCXUzMiByZXNlcnZlZDozMTsKKwl9IGZsYWdzOworCisJdTggICAgICByZXNlcnZl
ZDNbMHg1Q107Cit9OworCitzdHJ1Y3QgTVJfTERfU1BBTl9NQVAgeworCXN0cnVjdCBNUl9MRF9S
QUlEICAgICAgICAgIGxkUmFpZDsKKwl1OCAgICAgICAgICAgICAgICAgIGRhdGFBcm1NYXBbTUFY
X1JBSURNQVBfUk9XX1NJWkVdOworCXN0cnVjdCBNUl9TUEFOX0JMT0NLX0lORk8gIHNwYW5CbG9j
a1tNQVhfUkFJRE1BUF9TUEFOX0RFUFRIXTsKK307CisKK3N0cnVjdCBNUl9GV19SQUlEX01BUCB7
CisJdTMyICAgICAgICAgICAgICAgICB0b3RhbFNpemU7CisJdW5pb24geworCQlzdHJ1Y3Qgewor
CQkJdTMyICAgICAgICAgbWF4TGQ7CisJCQl1MzIgICAgICAgICBtYXhTcGFuRGVwdGg7CisJCQl1
MzIgICAgICAgICBtYXhSb3dTaXplOworCQkJdTMyICAgICAgICAgbWF4UGRDb3VudDsKKwkJCXUz
MiAgICAgICAgIG1heEFycmF5czsKKwkJfSB2YWxpZGF0aW9uSW5mbzsKKwkJdTMyICAgICAgICAg
ICAgIHZlcnNpb25bNV07CisJCXUzMiAgICAgICAgICAgICByZXNlcnZlZDFbNV07CisJfTsKKwor
CXUzMiAgICAgICAgICAgICAgICAgbGRDb3VudDsKKwl1MzIgICAgICAgICAgICAgICAgIFJlc2Vy
dmVkMTsKKwl1OCAgICAgICAgICAgICAgICAgIGxkVGd0SWRUb0xkW01BWF9SQUlETUFQX0xPR0lD
QUxfRFJJVkVTKworCQkJCQlNQVhfUkFJRE1BUF9WSUVXU107CisJdTggICAgICAgICAgICAgICAg
ICBmcFBkSW9UaW1lb3V0U2VjOworCXU4ICAgICAgICAgICAgICAgICAgcmVzZXJ2ZWQyWzddOwor
CXN0cnVjdCBNUl9BUlJBWV9JTkZPICAgICAgIGFyTWFwSW5mb1tNQVhfUkFJRE1BUF9BUlJBWVNd
OworCXN0cnVjdCBNUl9ERVZfSEFORExFX0lORk8gIGRldkhuZGxJbmZvW01BWF9SQUlETUFQX1BI
WVNJQ0FMX0RFVklDRVNdOworCXN0cnVjdCBNUl9MRF9TUEFOX01BUCAgICAgIGxkU3Bhbk1hcFsx
XTsKK307CisKK3N0cnVjdCBJT19SRVFVRVNUX0lORk8geworCXU2NCBsZFN0YXJ0QmxvY2s7CisJ
dTMyIG51bUJsb2NrczsKKwl1MTYgbGRUZ3RJZDsKKwl1OCBpc1JlYWQ7CisJdTE2IGRldkhhbmRs
ZTsKKwl1NjQgcGRCbG9jazsKKwl1OCBmcE9rRm9ySW87Cit9OworCitzdHJ1Y3QgTVJfTERfVEFS
R0VUX1NZTkMgeworCXU4ICB0YXJnZXRJZDsKKwl1OCAgcmVzZXJ2ZWQ7CisJdTE2IHNlcU51bTsK
K307CisKKyNkZWZpbmUgSUVFRV9TR0VfRkxBR1NfQUREUl9NQVNLICAgICAgICAgICAgKDB4MDMp
CisjZGVmaW5lIElFRUVfU0dFX0ZMQUdTX1NZU1RFTV9BRERSICAgICAgICAgICgweDAwKQorI2Rl
ZmluZSBJRUVFX1NHRV9GTEFHU19JT0NERFJfQUREUiAgICAgICAgICAoMHgwMSkKKyNkZWZpbmUg
SUVFRV9TR0VfRkxBR1NfSU9DUExCX0FERFIgICAgICAgICAgKDB4MDIpCisjZGVmaW5lIElFRUVf
U0dFX0ZMQUdTX0lPQ1BMQk5UQV9BRERSICAgICAgICgweDAzKQorI2RlZmluZSBJRUVFX1NHRV9G
TEFHU19DSEFJTl9FTEVNRU5UICAgICAgICAoMHg4MCkKKyNkZWZpbmUgSUVFRV9TR0VfRkxBR1Nf
RU5EX09GX0xJU1QgICAgICAgICAgKDB4NDApCisKK3N0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3Nl
dDsKK3N0cnVjdCBtZWdhc2FzX2luc3RhbmNlOworCit1bmlvbiBkZXNjX3dvcmQgeworCXU2NCB3
b3JkOworCXN0cnVjdCB7CisJCXUzMiBsb3c7CisJCXUzMiBoaWdoOworCX0gdTsKK307CisKK3N0
cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24geworCXN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFV
RVNUCSppb19yZXF1ZXN0OworCWRtYV9hZGRyX3QJCQlpb19yZXF1ZXN0X3BoeXNfYWRkcjsKKwor
CXVuaW9uIE1QSTJfU0dFX0lPX1VOSU9OCSpzZ19mcmFtZTsKKwlkbWFfYWRkcl90CQlzZ19mcmFt
ZV9waHlzX2FkZHI7CisKKwl1OCAqc2Vuc2U7CisJZG1hX2FkZHJfdCBzZW5zZV9waHlzX2FkZHI7
CisKKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CisJc3RydWN0IHNjc2lfY21uZCAqc2NtZDsKKwlz
dHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2U7CisKKwl1OCByZXRyeV9mb3JfZndfcmVz
ZXQ7CisJdW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04gICpyZXF1ZXN0X2Rl
c2M7CisKKwkvKgorCSAqIENvbnRleHQgZm9yIGEgTUZJIGZyYW1lLgorCSAqIFVzZWQgdG8gZ2V0
IHRoZSBtZmkgY21kIGZyb20gbGlzdCB3aGVuIGEgTUZJIGNtZCBpcyBjb21wbGV0ZWQKKwkgKi8K
Kwl1MzIgc3luY19jbWRfaWR4OworCXUzMiBpbmRleDsKKwl1OCBmbGFnczsKK307CisKK3N0cnVj
dCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyB7CisJdTgJbG9hZEJhbGFuY2VGbGFnOworCXU4CXJlc2Vy
dmVkMTsKKwl1MTYgICAgIHJhaWQxRGV2SGFuZGxlWzJdOworCWF0b21pY190ICAgICBzY3NpX3Bl
bmRpbmdfY21kc1syXTsKKwl1NjQgICAgIGxhc3RfYWNjZXNzZWRfYmxvY2tbMl07Cit9OworCitz
dHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMIHsKKwlzdHJ1Y3QgTVJfRldfUkFJRF9NQVAgcmFpZE1h
cDsKKwlzdHJ1Y3QgTVJfTERfU1BBTl9NQVAgbGRTcGFuTWFwW01BWF9MT0dJQ0FMX0RSSVZFUyAt
IDFdOworfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7CisKK3N0cnVjdCBmdXNpb25fY29udGV4
dCB7CisJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqKmNtZF9saXN0OworCXN0cnVjdCBsaXN0
X2hlYWQgY21kX3Bvb2w7CisKKwlzcGlubG9ja190IGNtZF9wb29sX2xvY2s7CisKKwlkbWFfYWRk
cl90IHJlcV9mcmFtZXNfZGVzY19waHlzOworCXU4ICpyZXFfZnJhbWVzX2Rlc2M7CisKKwlzdHJ1
Y3QgZG1hX3Bvb2wgKmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2w7CisJZG1hX2FkZHJfdCBpb19yZXF1
ZXN0X2ZyYW1lc19waHlzOworCXU4ICppb19yZXF1ZXN0X2ZyYW1lczsKKworCXN0cnVjdCBkbWFf
cG9vbCAqc2dfZG1hX3Bvb2w7CisJc3RydWN0IGRtYV9wb29sICpzZW5zZV9kbWFfcG9vbDsKKwor
CWRtYV9hZGRyX3QgcmVwbHlfZnJhbWVzX2Rlc2NfcGh5czsKKwl1bmlvbiBNUEkyX1JFUExZX0RF
U0NSSVBUT1JTX1VOSU9OICpyZXBseV9mcmFtZXNfZGVzYzsKKwlzdHJ1Y3QgZG1hX3Bvb2wgKnJl
cGx5X2ZyYW1lc19kZXNjX3Bvb2w7CisKKwl1MTYgbGFzdF9yZXBseV9pZHg7CisKKwl1MzIgcmVw
bHlfcV9kZXB0aDsKKwl1MzIgcmVxdWVzdF9hbGxvY19zejsKKwl1MzIgcmVwbHlfYWxsb2Nfc3o7
CisJdTMyIGlvX2ZyYW1lc19hbGxvY19zejsKKworCXUxNgltYXhfc2dlX2luX21haW5fbXNnOwor
CXUxNgltYXhfc2dlX2luX2NoYWluOworCisJdTgJY2hhaW5fb2Zmc2V0X2lvX3JlcXVlc3Q7CisJ
dTgJY2hhaW5fb2Zmc2V0X21maV9wdGhydTsKKworCXN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwg
KmxkX21hcFsyXTsKKwlkbWFfYWRkcl90IGxkX21hcF9waHlzWzJdOworCisJdTMyIG1hcF9zejsK
Kwl1OCBmYXN0X3BhdGhfaW87CisJc3RydWN0IExEX0xPQURfQkFMQU5DRV9JTkZPIGxvYWRfYmFs
YW5jZV9pbmZvW01BWF9MT0dJQ0FMX0RSSVZFU107Cit9OworCit1bmlvbiBkZXNjX3ZhbHVlIHsK
Kwl1NjQgd29yZDsKKwlzdHJ1Y3QgeworCQl1MzIgbG93OworCQl1MzIgaGlnaDsKKwl9IHU7Cit9
OworCisjZW5kaWYgLyogX01FR0FSQUlEX1NBU19GVVNJT05fSF8gKi8K
--0016363b8520b0a5f904976a37c2--
