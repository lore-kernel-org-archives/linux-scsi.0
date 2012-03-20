From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 01/12] [SCSI] mpt2sas : MPI next revision header update
Date: Tue, 20 Mar 2012 12:03:16 +0530
Message-ID: <201203200632.q2K6WiFW031584@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49473 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab2CTGcs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:32:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

MPI next revision header update

Changeset in MPI headers:
1) Bumped MPI2_HEADER_VERSION_UNIT
2) Added 4K sectors supported bit to CapabilitiesFlags field of IOC Page 6.
3) Added UEFIVersion field to BIOS Page 1 and defined additional
    BiosOptions bits to control UEFI behavior.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
index a01f0aa..0087d37 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h
@@ -8,8 +8,8 @@
  *                  scatter/gather formats.
  *  Creation Date:  June 21, 2006
  *
- *  mpi2.h Version:  02.00.22
- *
+ *  mpi2.h Version:  02.00.23
+ *
  *  Version History
  *  ---------------
  *
@@ -71,6 +71,7 @@
  *  03-09-11  02.00.20  Bumped MPI2_HEADER_VERSION_UNIT.
  *  05-25-11  02.00.21  Bumped MPI2_HEADER_VERSION_UNIT.
  *  08-24-11  02.00.22  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  11-18-11  02.00.23  Bumped MPI2_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
  */
 
@@ -96,7 +97,7 @@
 #define MPI2_VERSION_02_00                  (0x0200)
 
 /* versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x16)
+#define MPI2_HEADER_VERSION_UNIT            (0x17)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
@@ -480,7 +481,7 @@ typedef union _MPI2_REPLY_DESCRIPTORS_UNION
     MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR  RAIDAcceleratorSuccess;
     U64                                             Words;
 } MPI2_REPLY_DESCRIPTORS_UNION, MPI2_POINTER PTR_MPI2_REPLY_DESCRIPTORS_UNION,
-  Mpi2ReplyDescriptorsUnion_t, MPI2_POINTER pMpi2ReplyDescriptorsUnion_t;
+Mpi2ReplyDescriptorsUnion_t, MPI2_POINTER pMpi2ReplyDescriptorsUnion_t;
 
 
 
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
index 3a023da..737fa8c 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Configuration messages and pages
  *  Creation Date:  November 10, 2006
  *
- *    mpi2_cnfg.h Version:  02.00.21
+ *    mpi2_cnfg.h Version:  02.00.22
  *
  *  Version History
  *  ---------------
@@ -146,7 +146,9 @@
  *                      Added SpinupFlags field containing a Disable Spin-up
  *                      bit to the MPI2_SAS_IOUNIT4_SPINUP_GROUP fields of
  *                      SAS IO Unit Page 4.
-
+ *  11-18-11  02.00.22  Added define MPI2_IOCPAGE6_CAP_FLAGS_4K_SECTORS_SUPPORT.
+ *                      Added UEFIVersion field to BIOS Page 1 and defined new
+ *                      BiosOptions bits.
  *  --------------------------------------------------------------------------
  */
 
@@ -1131,9 +1133,10 @@ typedef struct _MPI2_CONFIG_PAGE_IOC_6
 } MPI2_CONFIG_PAGE_IOC_6, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IOC_6,
   Mpi2IOCPage6_t, MPI2_POINTER pMpi2IOCPage6_t;
 
-#define MPI2_IOCPAGE6_PAGEVERSION                       (0x04)
+#define MPI2_IOCPAGE6_PAGEVERSION                       (0x05)
 
 /* defines for IOC Page 6 CapabilitiesFlags */
+#define MPI2_IOCPAGE6_CAP_FLAGS_4K_SECTORS_SUPPORT      (0x00000020)
 #define MPI2_IOCPAGE6_CAP_FLAGS_RAID10_SUPPORT          (0x00000010)
 #define MPI2_IOCPAGE6_CAP_FLAGS_RAID1_SUPPORT           (0x00000008)
 #define MPI2_IOCPAGE6_CAP_FLAGS_RAID1E_SUPPORT          (0x00000004)
@@ -1204,24 +1207,29 @@ typedef struct _MPI2_CONFIG_PAGE_IOC_8
 
 typedef struct _MPI2_CONFIG_PAGE_BIOS_1
 {
-    MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
-    U32                     BiosOptions;                /* 0x04 */
-    U32                     IOCSettings;                /* 0x08 */
-    U32                     Reserved1;                  /* 0x0C */
-    U32                     DeviceSettings;             /* 0x10 */
-    U16                     NumberOfDevices;            /* 0x14 */
-    U16                     Reserved2;                  /* 0x16 */
-    U16                     IOTimeoutBlockDevicesNonRM; /* 0x18 */
-    U16                     IOTimeoutSequential;        /* 0x1A */
-    U16                     IOTimeoutOther;             /* 0x1C */
-    U16                     IOTimeoutBlockDevicesRM;    /* 0x1E */
+	MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
+	U32                     BiosOptions;                /* 0x04 */
+	U32                     IOCSettings;                /* 0x08 */
+	U32                     Reserved1;                  /* 0x0C */
+	U32                     DeviceSettings;             /* 0x10 */
+	U16                     NumberOfDevices;            /* 0x14 */
+	U16                     UEFIVersion;                /* 0x16 */
+	U16                     IOTimeoutBlockDevicesNonRM; /* 0x18 */
+	U16                     IOTimeoutSequential;        /* 0x1A */
+	U16                     IOTimeoutOther;             /* 0x1C */
+	U16                     IOTimeoutBlockDevicesRM;    /* 0x1E */
 } MPI2_CONFIG_PAGE_BIOS_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_BIOS_1,
   Mpi2BiosPage1_t, MPI2_POINTER pMpi2BiosPage1_t;
 
-#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x04)
+#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x05)
 
 /* values for BIOS Page 1 BiosOptions field */
-#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_BIOS             (0x00000001)
+#define MPI2_BIOSPAGE1_OPTIONS_MASK_UEFI_HII_REGISTRATION   (0x00000006)
+#define MPI2_BIOSPAGE1_OPTIONS_ENABLE_UEFI_HII              (0x00000000)
+#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_UEFI_HII             (0x00000002)
+#define MPI2_BIOSPAGE1_OPTIONS_VERSION_CHECK_UEFI_HII       (0x00000004)
+
+#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_BIOS                 (0x00000001)
 
 /* values for BIOS Page 1 IOCSettings field */
 #define MPI2_BIOSPAGE1_IOCSET_MASK_BOOT_PREFERENCE      (0x00030000)
@@ -1248,6 +1256,13 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1
 #define MPI2_BIOSPAGE1_DEVSET_DISABLE_NON_RM_LUN        (0x00000002)
 #define MPI2_BIOSPAGE1_DEVSET_DISABLE_OTHER_LUN         (0x00000001)
 
+/* defines for BIOS Page 1 UEFIVersion field */
+#define MPI2_BIOSPAGE1_UEFI_VER_MAJOR_MASK              (0xFF00)
+#define MPI2_BIOSPAGE1_UEFI_VER_MAJOR_SHIFT             (8)
+#define MPI2_BIOSPAGE1_UEFI_VER_MINOR_MASK              (0x00FF)
+#define MPI2_BIOSPAGE1_UEFI_VER_MINOR_SHIFT             (0)
+
+
 
 /* BIOS Page 2 */
 
@@ -2216,6 +2231,27 @@ typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_8 {
 
 
 
+/* SAS IO Unit Page 16 */
+
+typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT16 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER  Header;                  /* 0x00 */
+	U64                         TimeStamp;                     /* 0x08 */
+	U32                         Reserved1;                     /* 0x10 */
+	U32                         Reserved2;                     /* 0x14 */
+	U32                         FastPathPendedRequests;        /* 0x18 */
+	U32                         FastPathUnPendedRequests;      /* 0x1C */
+	U32                         FastPathHostRequestStarts;     /* 0x20 */
+	U32                         FastPathFirmwareRequestStarts; /* 0x24 */
+	U32                         FastPathHostCompletions;       /* 0x28 */
+	U32                         FastPathFirmwareCompletions;   /* 0x2C */
+	U32                         NonFastPathRequestStarts;      /* 0x30 */
+	U32			    NonFastPathHostCompletions;    /* 0x30 */
+} MPI2_CONFIG_PAGE_SASIOUNIT16,
+MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SASIOUNIT16,
+Mpi2SasIOUnitPage16_t, MPI2_POINTER pMpi2SasIOUnitPage16_t;
+
+#define MPI2_SASIOUNITPAGE16_PAGEVERSION    (0x00)
+
 
 /****************************************************************************
 *   SAS Expander Config Pages
