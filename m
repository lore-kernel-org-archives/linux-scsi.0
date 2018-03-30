From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 12/15] mpt3sas: Update MPI Headers
Date: Fri, 30 Mar 2018 15:07:21 +0530
Message-ID: <1522402644-3016-13-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Update MPI Files to support protocol level reset for NVMe device.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2.h      |  9 ++++++---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 30 ++++++++++++++++++++++++------
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |  7 ++++++-
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index b015c30..1e45268 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -9,7 +9,7 @@
  *                 scatter/gather formats.
  * Creation Date:  June 21, 2006
  *
- * mpi2.h Version:  02.00.48
+ *  mpi2.h Version:  02.00.50
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -114,6 +114,8 @@
  * 09-02-16  02.00.46  Bumped MPI2_HEADER_VERSION_UNIT.
  * 11-23-16  02.00.47  Bumped MPI2_HEADER_VERSION_UNIT.
  * 02-03-17  02.00.48  Bumped MPI2_HEADER_VERSION_UNIT.
+ * 06-13-17  02.00.49  Bumped MPI2_HEADER_VERSION_UNIT.
+ * 09-29-17  02.00.50  Bumped MPI2_HEADER_VERSION_UNIT.
  * --------------------------------------------------------------------------
  */
 
@@ -152,8 +154,9 @@
 					MPI26_VERSION_MINOR)
 #define MPI2_VERSION_02_06		    (0x0206)
 
-/*Unit and Dev versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x30)
+
+/* Unit and Dev versioning for this MPI header set */
+#define MPI2_HEADER_VERSION_UNIT            (0x32)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 0ad88de..5122920 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -7,7 +7,7 @@
  *         Title:  MPI Configuration messages and pages
  * Creation Date:  November 10, 2006
  *
- *   mpi2_cnfg.h Version:  02.00.40
+ *    mpi2_cnfg.h Version:  02.00.42
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -219,6 +219,18 @@
  *                     Added ChassisSlot field to SAS Enclosure Page 0.
  *                     Added ChassisSlot Valid bit (bit 5) to the Flags field
  *                     in SAS Enclosure Page 0.
+ * 06-13-17  02.00.41  Added MPI26_MFGPAGE_DEVID_SAS3816 and
+ *                     MPI26_MFGPAGE_DEVID_SAS3916 defines.
+ *                     Removed MPI26_MFGPAGE_DEVID_SAS4008 define.
+ *                     Added MPI26_PCIEIOUNIT1_LINKFLAGS_SRNS_EN define.
+ *                     Renamed PI26_PCIEIOUNIT1_LINKFLAGS_EN_SRIS to
+ *                     PI26_PCIEIOUNIT1_LINKFLAGS_SRIS_EN.
+ *                     Renamed MPI26_PCIEIOUNIT1_LINKFLAGS_DIS_SRIS to
+ *                     MPI26_PCIEIOUNIT1_LINKFLAGS_DIS_SEPARATE_REFCLK.
+ * 09-29-17  02.00.42  Added ControllerResetTO field to PCIe Device Page 2.
+ *                     Added NOIOB field to PCIe Device Page 2.
+ *                     Added MPI26_PCIEDEV2_CAP_DATA_BLK_ALIGN_AND_GRAN to
+ *                     the Capabilities field of PCIe Device Page 2.
  * --------------------------------------------------------------------------
  */
 
@@ -556,7 +568,8 @@ typedef struct _MPI2_CONFIG_REPLY {
 #define MPI26_MFGPAGE_DEVID_SAS3616                 (0x00D1)
 #define MPI26_MFGPAGE_DEVID_SAS3708                 (0x00D2)
 
-#define MPI26_MFGPAGE_DEVID_SAS4008                 (0x00A1)
+#define MPI26_MFGPAGE_DEVID_SAS3816                 (0x00A1)
+#define MPI26_MFGPAGE_DEVID_SAS3916                 (0x00A0)
 
 
 /*Manufacturing Page 0 */
@@ -3864,20 +3877,25 @@ typedef struct _MPI26_CONFIG_PAGE_PCIEDEV_0 {
 typedef struct _MPI26_CONFIG_PAGE_PCIEDEV_2 {
 	MPI2_CONFIG_EXTENDED_PAGE_HEADER	Header;	/*0x00 */
 	U16	DevHandle;		/*0x08 */
-	U16	Reserved1;		/*0x0A */
-	U32	MaximumDataTransferSize;/*0x0C */
+	U8	ControllerResetTO;		/* 0x0A */
+	U8	Reserved1;		/* 0x0B */
+	U32	MaximumDataTransferSize;	/*0x0C */
 	U32	Capabilities;		/*0x10 */
-	U32	Reserved2;		/*0x14 */
+	U16	NOIOB;		/* 0x14 */
+	U16	Reserved2;		/* 0x16 */
 } MPI26_CONFIG_PAGE_PCIEDEV_2, *PTR_MPI26_CONFIG_PAGE_PCIEDEV_2,
 	Mpi26PCIeDevicePage2_t, *pMpi26PCIeDevicePage2_t;
 
-#define MPI26_PCIEDEVICE2_PAGEVERSION       (0x00)
+#define MPI26_PCIEDEVICE2_PAGEVERSION       (0x01)
 
 /*defines for PCIe Device Page 2 Capabilities field */
+#define MPI26_PCIEDEV2_CAP_DATA_BLK_ALIGN_AND_GRAN     (0x00000008)
 #define MPI26_PCIEDEV2_CAP_SGL_FORMAT                  (0x00000004)
 #define MPI26_PCIEDEV2_CAP_BIT_BUCKET_SUPPORT          (0x00000002)
 #define MPI26_PCIEDEV2_CAP_SGL_SUPPORT                 (0x00000001)
 
+/* Defines for the NOIOB field */
+#define MPI26_PCIEDEV2_NOIOB_UNSUPPORTED                (0x0000)
 
 /****************************************************************************
 *  PCIe Link Config Pages (MPI v2.6 and later)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index cc2aff7..1faec3a 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -7,7 +7,7 @@
  *         Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  * Creation Date:  October 11, 2006
  *
- * mpi2_ioc.h Version:  02.00.32
+ * mpi2_ioc.h Version:  02.00.34
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -167,6 +167,10 @@
  * 02-02-17   02.00.32 Added MPI2_FW_DOWNLOAD_ITYPE_CBB_BACKUP.
  *                     Added MPI25_EVENT_DATA_ACTIVE_CABLE_EXCEPT and related
  *                     defines for the ReasonCode field.
+ * 06-13-17   02.00.33 Added MPI2_FW_DOWNLOAD_ITYPE_CPLD.
+ * 09-29-17   02.00.34 Added MPI26_EVENT_PCIDEV_STAT_RC_PCIE_HOT_RESET_FAILED
+ *                     to the ReasonCode field in PCIe Device Status Change
+ *                     Event Data.
  * --------------------------------------------------------------------------
  */
 
@@ -1182,6 +1186,7 @@ typedef struct _MPI26_EVENT_DATA_PCIE_DEVICE_STATUS_CHANGE {
 #define MPI26_EVENT_PCIDEV_STAT_RC_CMP_INTERNAL_DEV_RESET               (0x0E)
 #define MPI26_EVENT_PCIDEV_STAT_RC_CMP_TASK_ABORT_INTERNAL              (0x0F)
 #define MPI26_EVENT_PCIDEV_STAT_RC_DEV_INIT_FAILURE                     (0x10)
+#define MPI26_EVENT_PCIDEV_STAT_RC_PCIE_HOT_RESET_FAILED                (0x11)
 
 
 /*PCIe Enumeration Event data (MPI v2.6 and later) */
-- 
1.8.3.1
