From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 10/20] [SCSI] mpt3sas: Add branding string support for OEM's HBA
Date: Mon, 30 Mar 2015 19:25:13 +0530
Message-ID: <1427723723-12676-11-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Added the following Dell branding to the mpt3sas driver.

"VendorID"   "DeviceID"  "SubsystemVendor ID"  "SubsystemDevice ID"  Dell Branding String
0x1000        0x0097          0x1028                 0x1F46            DELL 12Gbps HBA

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h | 11 +++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6739c0a..db362cb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2345,6 +2345,41 @@ _base_display_intel_branding(struct MPT3SAS_ADAPTER *ioc)
 
 
 /**
+ * _base_display_dell_branding - Display branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_dell_branding(struct MPT3SAS_ADAPTER *ioc)
+{
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_DELL)
+		return;
+
+	switch (ioc->pdev->device) {
+	case MPI25_MFGPAGE_DEVID_SAS3008:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT3SAS_DELL_12G_HBA_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_DELL_12G_HBA_BRANDING);
+			break;
+		default:
+			pr_info(MPT3SAS_FMT
+			   "Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
+			   ioc->pdev->subsystem_device);
+			break;
+		}
+		break;
+	default:
+		pr_info(MPT3SAS_FMT
+			"Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
+			ioc->pdev->subsystem_device);
+		break;
+	}
+}
+
+
+/**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
  * @ioc: per adapter object
  *
@@ -2374,6 +2409,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	    bios_version & 0x000000FF);
 
 	_base_display_intel_branding(ioc);
+	_base_display_dell_branding(ioc);
 
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 175499c..158a29c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -152,6 +152,17 @@
 #define MPT3SAS_INTEL_RS3UC080_SSDID    0x3524
 
 /*
+ * Dell HBA branding
+ */
+#define MPT3SAS_DELL_12G_HBA_BRANDING       \
+	"Dell 12Gbps HBA"
+
+/*
+ * Dell HBA SSDIDs
+ */
+#define MPT3SAS_DELL_12G_HBA_SSDID	0x1F46
+
+/*
  * status bits for ioc->diag_buffer_status
  */
 #define MPT3_DIAG_BUFFER_IS_REGISTERED	(0x01)
-- 
2.0.2
