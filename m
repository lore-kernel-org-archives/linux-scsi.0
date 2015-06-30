From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 13/20] [SCSI] mpt3sas: MPI 2.5 Rev K (2.5.6)  specifications
Date: Tue, 30 Jun 2015 12:24:59 +0530
Message-ID: <1435647306-36956-14-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33294 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbbF3G4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:56:22 -0400
Received: by pdjd13 with SMTP id d13so821756pdj.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:56:21 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Below are the new changes to MPI 2.5 Rev K(2.5.6) specification and 2.00.35 header files
1) Added a minimum size requirement for target mode command buffers.
2) Added MinMSIxIndex and MaxMSIxIndex fields to CommandBufferPostBase Request.
3) For BIOS Page 1, added SSUTimeout field, and added Product Name String Format bits to the BiosOptions field

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpi/mpi2.h      |  5 +++--
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 17 ++++++++++++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index c2d127c..ec27ad2 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                 scatter/gather formats.
  * Creation Date:  June 21, 2006
  *
- * mpi2.h Version:  02.00.34
+ * mpi2.h Version:  02.00.35
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -91,6 +91,7 @@
  * 08-19-13  02.00.32  Bumped MPI2_HEADER_VERSION_UNIT.
  * 12-05-13  02.00.33  Bumped MPI2_HEADER_VERSION_UNIT.
  * 01-08-14  02.00.34  Bumped MPI2_HEADER_VERSION_UNIT
+ * 06-13-14  02.00.35  Bumped MPI2_HEADER_VERSION_UNIT.
  * --------------------------------------------------------------------------
  */
 
@@ -124,7 +125,7 @@
 #define MPI2_VERSION_02_05                  (0x0205)
 
 /*Unit and Dev versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x22)
+#define MPI2_HEADER_VERSION_UNIT            (0x23)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index cf2b6bf..581fdb3 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *         Title:  MPI Configuration messages and pages
  * Creation Date:  November 10, 2006
  *
- *   mpi2_cnfg.h Version:  02.00.28
+ *   mpi2_cnfg.h Version:  02.00.29
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -177,6 +177,8 @@
  *		       MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
  * 01-08-14  02.00.28  Added more defines for the BiosOptions field of
  *		       MPI2_CONFIG_PAGE_BIOS_1.
+ * 06-13-14  02.00.29  Added SSUTimeout field to MPI2_CONFIG_PAGE_BIOS_1, and
+ *		       more defines for the BiosOptions field..
  * --------------------------------------------------------------------------
  */
 
@@ -1324,7 +1326,9 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
 	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
 	U32                     BiosOptions;                /*0x04 */
 	U32                     IOCSettings;                /*0x08 */
-	U32                     Reserved1;                  /*0x0C */
+	U8                      SSUTimeout;                 /*0x0C */
+	U8                      Reserved1;                  /*0x0D */
+	U16                     Reserved2;                  /*0x0E */
 	U32                     DeviceSettings;             /*0x10 */
 	U16                     NumberOfDevices;            /*0x14 */
 	U16                     UEFIVersion;                /*0x16 */
@@ -1336,9 +1340,16 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
 	*PTR_MPI2_CONFIG_PAGE_BIOS_1,
 	Mpi2BiosPage1_t, *pMpi2BiosPage1_t;
 
-#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x06)
+#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x07)
 
 /*values for BIOS Page 1 BiosOptions field */
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_MASK                         (0x00003800)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_PBDHL                        (0x00000000)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_ENCSLOSURE                   (0x00000800)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_LWWID                        (0x00001000)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_PSENS                        (0x00001800)
+#define MPI2_BIOSPAGE1_OPTIONS_PNS_ESPHY                        (0x00002000)
+
 #define MPI2_BIOSPAGE1_OPTIONS_X86_DISABLE_BIOS		(0x00000400)
 
 #define MPI2_BIOSPAGE1_OPTIONS_MASK_REGISTRATION_UEFI_BSD	(0x00000300)
-- 
2.0.2

