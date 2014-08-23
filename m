From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v1 6/8][SCSI] mpt3sas: Added OEM branding Strings
Date: Sat, 23 Aug 2014 17:41:40 +0530
Message-ID: <1408795902-10523-7-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1408795902-10523-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408795902-10523-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Added following branding Strings for Intel custom HBAs support.

Driver String:                                  Vendor ID       Device ID       SubSystemVendor ID      SubSystemDevice ID
Intel(R) Integrated RAID Module RMS3JC080       0x1000          0x0097          0x8086                  0x3521
Intel(R) RAID Controller RS3GC008               0x1000          0x0097          0x8086                  0x3522
Intel(R) RAID Controller RS3FC044               0x1000          0x0097          0x8086                  0x3523
Intel(R) RAID Controller RS3UC080               0x1000          0x0097          0x8086                  0x3524

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 49 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h | 18 ++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index faa3380..d71f135 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2185,6 +2185,53 @@ mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	    &ioc->scsi_lookup_lock);
 }
 
+/**
+ * _base_display_intel_branding - Display branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_intel_branding(struct MPT3SAS_ADAPTER *ioc)
+{
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
+		return;
+
+	switch (ioc->pdev->device) {
+	case MPI25_MFGPAGE_DEVID_SAS3008:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT3SAS_INTEL_RMS3JC080_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RMS3JC080_BRANDING);
+			break;
+
+		case MPT3SAS_INTEL_RS3GC008_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RS3GC008_BRANDING);
+			break;
+		case MPT3SAS_INTEL_RS3FC044_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RS3FC044_BRANDING);
+			break;
+		case MPT3SAS_INTEL_RS3UC080_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RS3UC080_BRANDING);
+			break;
+		default:
+			pr_info(MPT3SAS_FMT
+				"Intel(R) Controller: Subsystem ID: 0x%X\n",
+				ioc->name, ioc->pdev->subsystem_device);
+			break;
+		}
+		break;
+	default:
+		pr_info(MPT3SAS_FMT
+			"Intel(R) Controller: Subsystem ID: 0x%X\n",
+			ioc->name, ioc->pdev->subsystem_device);
+		break;
+	}
+}
+
 
 
 /**
@@ -2216,6 +2263,8 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	   (bios_version & 0x0000FF00) >> 8,
 	    bios_version & 0x000000FF);
 
+	_base_display_intel_branding(ioc);
+
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 86b931e..e920728 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -130,7 +130,25 @@
 #define MPT_TARGET_FLAGS_DELETED	0x04
 #define MPT_TARGET_FASTPATH_IO		0x08
 
+/*
+ * Intel HBA branding
+ */
+#define MPT3SAS_INTEL_RMS3JC080_BRANDING       \
+	"Intel(R) Integrated RAID Module RMS3JC080"
+#define MPT3SAS_INTEL_RS3GC008_BRANDING       \
+	"Intel(R) RAID Controller RS3GC008"
+#define MPT3SAS_INTEL_RS3FC044_BRANDING       \
+	"Intel(R) RAID Controller RS3FC044"
+#define MPT3SAS_INTEL_RS3UC080_BRANDING       \
+	"Intel(R) RAID Controller RS3UC080"
 
+/*
+ * Intel HBA SSDIDs
+ */
+#define MPT3SAS_INTEL_RMS3JC080_SSDID	0x3521
+#define MPT3SAS_INTEL_RS3GC008_SSDID	0x3522
+#define MPT3SAS_INTEL_RS3FC044_SSDID	0x3523
+#define MPT3SAS_INTEL_RS3UC080_SSDID    0x3524
 
 /*
  * status bits for ioc->diag_buffer_status
-- 
2.0.2
