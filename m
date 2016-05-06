From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 1/6] mpt3sas: Update MPI header to 2.00.42
Date: Fri,  6 May 2016 14:29:26 +0530
Message-ID: <1462525171-6877-2-git-send-email-chaitra.basappa@broadcom.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Updated MPI version and MPI header files.

ChangeList:
* Added SATADeviceWaitTime to SAS IO Unit Page 4
* Added EEDPObservedValue added to SCSI IO Reply message
* Added MPI2_EVENT_ACTIVE_CABLE_EXCEPTION and
  MPI26_EVENT_DATA_ACTIVE_CABLE_EXCEPT

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2.h      |  7 +++++--
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 18 +++++++++++-----
 drivers/scsi/mpt3sas/mpi/mpi2_init.h | 15 +++++++++++---
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  | 40 +++++++++++++++++++++++++++++++-----
 4 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index dfad5b8..a9a659f 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                 scatter/gather formats.
  * Creation Date:  June 21, 2006
  *
- * mpi2.h Version:  02.00.39
+ * mpi2.h Version:  02.00.42
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -100,6 +100,9 @@
  *                     Added MPI2_DIAG_SBR_RELOAD.
  * 03-19-15  02.00.38  Bumped MPI2_HEADER_VERSION_UNIT.
  * 05-25-15  02.00.39  Bumped MPI2_HEADER_VERSION_UNIT.
+ * 08-25-15  02.00.40  Bumped MPI2_HEADER_VERSION_UNIT.
+ * 12-15-15  02.00.41  Bumped MPI_HEADER_VERSION_UNIT
+ * 01-01-16  02.00.42  Bumped MPI_HEADER_VERSION_UNIT
  * --------------------------------------------------------------------------
  */
 
@@ -139,7 +142,7 @@
 #define MPI2_VERSION_02_06		    (0x0206)
 
 /*Unit and Dev versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x27)
+#define MPI2_HEADER_VERSION_UNIT            (0x2A)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 9cf09bf..95356a8 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *         Title:  MPI Configuration messages and pages
  * Creation Date:  November 10, 2006
  *
- *   mpi2_cnfg.h Version:  02.00.33
+ *   mpi2_cnfg.h Version:  02.00.35
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -183,9 +183,12 @@
  *                     Added MPI2_BIOSPAGE1_OPTIONS_ADVANCED_CONFIG.
  *                     Added AdapterOrderAux fields to BIOS Page 3.
  * 03-16-15  02.00.31  Updated for MPI v2.6.
+ *                     Added Flags field to IO Unit Page 7.
  *                     Added new SAS Phy Event codes
  * 05-25-15  02.00.33  Added more defines for the BiosOptions field of
  *                     MPI2_CONFIG_PAGE_BIOS_1.
+ * 08-25-15  02.00.34  Bumped Header Version.
+ * 12-18-15  02.00.35  Added SATADeviceWaitTime to SAS IO Unit Page 4.
  * --------------------------------------------------------------------------
  */
 
@@ -958,13 +961,16 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_7 {
 	U8                      Reserved3;              /*0x17 */
 	U32			BoardPowerRequirement;	/*0x18 */
 	U32			PCISlotPowerAllocation;	/*0x1C */
-	U32			Reserved6;		/* 0x20 */
-	U32			Reserved7;		/* 0x24 */
+/* reserved prior to MPI v2.6 */
+	U8		Flags;			/* 0x20 */
+	U8		Reserved6;			/* 0x21 */
+	U16		Reserved7;			/* 0x22 */
+	U32		Reserved8;			/* 0x24 */
 } MPI2_CONFIG_PAGE_IO_UNIT_7,
 	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_7,
 	Mpi2IOUnitPage7_t, *pMpi2IOUnitPage7_t;
 
-#define MPI2_IOUNITPAGE7_PAGEVERSION			(0x04)
+#define MPI2_IOUNITPAGE7_PAGEVERSION			(0x05)
 
 /*defines for IO Unit Page 7 CurrentPowerMode and PreviousPowerMode fields */
 #define MPI25_IOUNITPAGE7_PM_INIT_MASK              (0xC0)
@@ -1045,6 +1051,8 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_7 {
 #define MPI2_IOUNITPAGE7_BOARD_TEMP_FAHRENHEIT      (0x01)
 #define MPI2_IOUNITPAGE7_BOARD_TEMP_CELSIUS         (0x02)
 
+/* defines for IO Unit Page 7 Flags field */
+#define MPI2_IOUNITPAGE7_FLAG_CABLE_POWER_EXC       (0x01)
 
 /*IO Unit Page 8 */
 
@@ -2271,7 +2279,7 @@ typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_4 {
 	U8
 		BootDeviceWaitTime;             /*0x24 */
 	U8
-		Reserved4;                      /*0x25 */
+		SATADeviceWaitTime;		/*0x25 */
 	U16
 		Reserved5;                      /*0x26 */
 	U8
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_init.h b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
index c38f624..bba56b6 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
@@ -6,7 +6,7 @@
  *         Title:  MPI SCSI initiator mode messages and structures
  * Creation Date:  June 23, 2006
  *
- * mpi2_init.h Version:  02.00.17
+ * mpi2_init.h Version:  02.00.20
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -51,6 +51,9 @@
  *                     Added MPI26_SCSIIO_IOFLAGS_ESCAPE_PASSTHROUGH.
  *                     Added MPI2_SEP_REQ_SLOTSTATUS_DEV_OFF and
  *                     MPI2_SEP_REPLY_SLOTSTATUS_DEV_OFF.
+ * 08-26-15  02.00.18  Added SCSITASKMGMT_MSGFLAGS for Target Reset.
+ * 12-18-15  02.00.19  Added EEDPObservedValue added to SCSI IO Reply message.
+ * 01-04-16  02.00.20  Modified EEDP reported values in SCSI IO Reply message.
  * --------------------------------------------------------------------------
  */
 
@@ -359,8 +362,14 @@ typedef struct _MPI2_SCSI_IO_REPLY {
 	U16 TaskTag;		/*0x20 */
 	U16 SCSIStatusQualifier; /* 0x22 */
 	U32 BidirectionalTransferCount;	/*0x24 */
-	U32 EEDPErrorOffset;	/*0x28 *//*MPI 2.5 only; Reserved in MPI 2.0*/
-	U32 Reserved6;		/*0x2C */
+ /* MPI 2.5+ only; Reserved in MPI 2.0 */
+	U32 EEDPErrorOffset;	/* 0x28 */
+ /* MPI 2.5+ only; Reserved in MPI 2.0 */
+	U16 EEDPObservedAppTag;	/* 0x2C */
+ /* MPI 2.5+ only; Reserved in MPI 2.0 */
+	U16 EEDPObservedGuard;	/* 0x2E */
+ /* MPI 2.5+ only; Reserved in MPI 2.0 */
+	U32 EEDPObservedRefTag;	/* 0x30 */
 } MPI2_SCSI_IO_REPLY, *PTR_MPI2_SCSI_IO_REPLY,
 	Mpi2SCSIIOReply_t, *pMpi2SCSIIOReply_t;
 
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index cf510ed..8bae305 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -6,7 +6,7 @@
  *         Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  * Creation Date:  October 11, 2006
  *
- * mpi2_ioc.h Version:  02.00.26
+ * mpi2_ioc.h Version:  02.00.27
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -134,9 +134,13 @@
  *			Added Encrypted Hash Extended Image.
  * 12-05-13  02.00.24  Added MPI25_HASH_IMAGE_TYPE_BIOS.
  * 11-18-14  02.00.25  Updated copyright information.
- * 03-16-15  02.00.26  Added MPI26_FW_HEADER_PID_FAMILY_3324_SAS and
+ * 03-16-15  02.00.26  Updated for MPI v2.6.
+ *		       Added MPI2_EVENT_ACTIVE_CABLE_EXCEPTION and
+ *		       MPI26_EVENT_DATA_ACTIVE_CABLE_EXCEPT.
+ *                     Added MPI26_FW_HEADER_PID_FAMILY_3324_SAS and
  *                     MPI26_FW_HEADER_PID_FAMILY_3516_SAS.
  *                     Added MPI26_CTRL_OP_SHUTDOWN.
+ * 08-25-15  02.00.27  Added IC ARCH Class based signature defines
  * --------------------------------------------------------------------------
  */
 
@@ -168,7 +172,7 @@ typedef struct _MPI2_IOC_INIT_REQUEST {
 	U16 MsgVersion;		/*0x0C */
 	U16 HeaderVersion;	/*0x0E */
 	U32 Reserved5;		/*0x10 */
-	U16 Reserved6;		/*0x14 */
+	U16 ConfigurationFlags;	/* 0x14 */
 	U8 HostPageSize;	/*0x16 */
 	U8 HostMSIxVectors;	/*0x17 */
 	U16 Reserved8;		/*0x18 */
@@ -516,6 +520,7 @@ typedef struct _MPI2_EVENT_NOTIFICATION_REPLY {
 #define MPI2_EVENT_TEMP_THRESHOLD                   (0x0027)
 #define MPI2_EVENT_HOST_MESSAGE                     (0x0028)
 #define MPI2_EVENT_POWER_PERFORMANCE_CHANGE         (0x0029)
+#define MPI2_EVENT_ACTIVE_CABLE_EXCEPTION           (0x0034)
 #define MPI2_EVENT_MIN_PRODUCT_SPECIFIC             (0x006E)
 #define MPI2_EVENT_MAX_PRODUCT_SPECIFIC             (0x007F)
 
@@ -580,7 +585,7 @@ typedef struct _MPI2_EVENT_DATA_HOST_MESSAGE {
 } MPI2_EVENT_DATA_HOST_MESSAGE, *PTR_MPI2_EVENT_DATA_HOST_MESSAGE,
 	Mpi2EventDataHostMessage_t, *pMpi2EventDataHostMessage_t;
 
-/*Power Performance Change Event */
+/*Power Performance Change Event data */
 
 typedef struct _MPI2_EVENT_DATA_POWER_PERF_CHANGE {
 	U8 CurrentPowerMode;	/*0x00 */
@@ -605,6 +610,21 @@ typedef struct _MPI2_EVENT_DATA_POWER_PERF_CHANGE {
 #define MPI2_EVENT_PM_MODE_REDUCED_POWER     (0x05)
 #define MPI2_EVENT_PM_MODE_STANDBY           (0x06)
 
+/* Active Cable Exception Event data */
+
+typedef struct _MPI26_EVENT_DATA_ACTIVE_CABLE_EXCEPT {
+	U32         ActiveCablePowerRequirement;        /* 0x00 */
+	U8          ReasonCode;                         /* 0x04 */
+	U8          ReceptacleID;                       /* 0x05 */
+	U16         Reserved1;                          /* 0x06 */
+} MPI26_EVENT_DATA_ACTIVE_CABLE_EXCEPT,
+	*PTR_MPI26_EVENT_DATA_ACTIVE_CABLE_EXCEPT,
+	Mpi26EventDataActiveCableExcept_t,
+	*pMpi26EventDataActiveCableExcept_t;
+
+/* defines for ReasonCode field */
+#define MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER     (0x00)
+
 /*Hard Reset Received Event data */
 
 typedef struct _MPI2_EVENT_DATA_HARD_RESET_RECEIVED {
@@ -1366,7 +1386,16 @@ typedef struct _MPI2_FW_IMAGE_HEADER {
 /*Signature0 field */
 #define MPI2_FW_HEADER_SIGNATURE0_OFFSET        (0x04)
 #define MPI2_FW_HEADER_SIGNATURE0               (0x5AFAA55A)
-#define MPI26_FW_HEADER_SIGNATURE0              (0x5AEAA55A)
+/* Last byte is defined by architecture */
+#define MPI26_FW_HEADER_SIGNATURE0_BASE         (0x5AEAA500)
+#define MPI26_FW_HEADER_SIGNATURE0_ARC_0        (0x5A)
+#define MPI26_FW_HEADER_SIGNATURE0_ARC_1        (0x00)
+#define MPI26_FW_HEADER_SIGNATURE0_ARC_2        (0x01)
+/* legacy (0x5AEAA55A) */
+#define MPI26_FW_HEADER_SIGNATURE0 \
+	(MPI26_FW_HEADER_SIGNATURE0_BASE+MPI26_FW_HEADER_SIGNATURE0_ARC_0)
+#define MPI26_FW_HEADER_SIGNATURE0_3516 \
+	(MPI26_FW_HEADER_SIGNATURE0_BASE+MPI26_FW_HEADER_SIGNATURE0_ARC_1)
 
 /*Signature1 field */
 #define MPI2_FW_HEADER_SIGNATURE1_OFFSET        (0x08)
@@ -1778,6 +1807,7 @@ typedef struct _MPI26_IOUNIT_CONTROL_REQUEST {
 #define MPI26_CTRL_OP_SAS_PHY_LINK_RESET                (0x06)
 #define MPI26_CTRL_OP_SAS_PHY_HARD_RESET                (0x07)
 #define MPI26_CTRL_OP_PHY_CLEAR_ERROR_LOG               (0x08)
+#define MPI26_CTRL_OP_LINK_CLEAR_ERROR_LOG              (0x09)
 #define MPI26_CTRL_OP_SAS_SEND_PRIMITIVE                (0x0A)
 #define MPI26_CTRL_OP_FORCE_FULL_DISCOVERY              (0x0B)
 #define MPI26_CTRL_OP_REMOVE_DEVICE                     (0x0D)
-- 
1.8.3.1
