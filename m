From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Subject: [RESEND][PATCH 6/8][SCSI]mpt3sas: Added OEM branding Strings
Date: Wed, 25 Jun 2014 16:11:10 +0530
Message-ID: <20140625104110.GA13027@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, sreekanth.reddy@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

Added following branding Strings for Intel custom HBAs support.

Driver String:                                  Vendor ID       Device ID       SubSystemVendor ID      SubSystemDevice ID
Intel(R) Integrated RAID Module RMS3JC080       0x1000          0x0097          0x8086                  0x3521
Intel(R) RAID Controller RS3GC008               0x1000          0x0097          0x8086                  0x3522
Intel(R) RAID Controller RS3FC044               0x1000          0x0097          0x8086                  0x3523
Intel(R) RAID Controller RS3UC080               0x1000          0x0097          0x8086                  0x3524

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   49 +++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h |   18 +++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8c77cd4..f1406cc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2219,6 +2219,53 @@ mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
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
@@ -2250,6 +2297,8 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	   (bios_version & 0x0000FF00) >> 8,
 	    bios_version & 0x000000FF);
 
+	_base_display_intel_branding(ioc);
+
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f163423..f61765c 100644
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
1.7.1
