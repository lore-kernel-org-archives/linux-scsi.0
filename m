From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 05/22] [SCSI] mpt2sas: MPI2 Rev BB (2.00.20) specification and 2.00.35 header files
Date: Thu, 20 Nov 2014 12:35:38 +0530
Message-ID: <1416467155-16869-6-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Change List in this MPI2 specification,

1. Added SSUTimeout field to MPI2_CONFIG_PAGE_BIOS_1,
   and more defines for the BiosOptions field.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpi/mpi2.h      |  5 +++--
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h | 17 ++++++++++++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
index 76cde3f..7fc6f23 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                  scatter/gather formats.
  *  Creation Date:  June 21, 2006
  *
- *  mpi2.h Version:  02.00.34
+ *  mpi2.h Version:  02.00.35
  *
  *  Version History
  *  ---------------
@@ -85,6 +85,7 @@
  *  08-19-13  02.00.32  Bumped MPI2_HEADER_VERSION_UNIT.
  *  12-05-13  02.00.33  Bumped MPI2_HEADER_VERSION_UNIT.
  *  01-08-14  02.00.34  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  06-13-14  02.00.35  Bumped MPI2_HEADER_VERSION_UNIT.
  *  --------------------------------------------------------------------------
  */
 
@@ -110,7 +111,7 @@
 #define MPI2_VERSION_02_00                  (0x0200)
 
 /* versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x20)
+#define MPI2_HEADER_VERSION_UNIT            (0x23)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
index f055310..d3e4319 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Configuration messages and pages
  *  Creation Date:  November 10, 2006
  *
- *    mpi2_cnfg.h Version:  02.00.28
+ *    mpi2_cnfg.h Version:  02.00.29
  *
  *  Version History
  *  ---------------
@@ -169,6 +169,8 @@
  *			MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
  *  01-08-14  02.00.28  Added more defines for the BiosOptions field of
  *			MPI2_CONFIG_PAGE_BIOS_1.
+ *  06-13-14  02.00.29  Added SSUTimeout field to MPI2_CONFIG_PAGE_BIOS_1, and
+ *			more defines for the BiosOptions field.
  *  --------------------------------------------------------------------------
  */
 
@@ -1237,7 +1239,9 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1
 	MPI2_CONFIG_PAGE_HEADER Header;                     /* 0x00 */
 	U32                     BiosOptions;                /* 0x04 */
 	U32                     IOCSettings;                /* 0x08 */
-	U32                     Reserved1;                  /* 0x0C */
+	U8			SSUTimeout;		    /* 0x0C */
+	U8			Reserved1;		    /* 0x0D */
+	U16			Reserved2;		    /* 0x0E */
 	U32                     DeviceSettings;             /* 0x10 */
 	U16                     NumberOfDevices;            /* 0x14 */
 	U16                     UEFIVersion;                /* 0x16 */
@@ -1248,9 +1252,16 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1
 } MPI2_CONFIG_PAGE_BIOS_1, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_BIOS_1,
   Mpi2BiosPage1_t, MPI2_POINTER pMpi2BiosPage1_t;
 
-#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x06)
+#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x07)
 
 /* values for BIOS Page 1 BiosOptions field */
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_MASK			(0x00003800)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_PBDHL			(0x00000000)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_ENCSLOSURE			(0x00000800)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_LWWID			(0x00001000)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_PSENS			(0x00001800)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_ESPHY			(0x00002000)
+
 #define MPI2_BIOSPAGE1_OPTIONS_X86_DISABLE_BIOS                 (0x00000400)
 
 #define MPI2_BIOSPAGE1_OPTIONS_MASK_REGISTRATION_UEFI_BSD       (0x00000300)
-- 
2.0.2
