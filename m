From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 11/20] [SCSI] mpt3sas: Add branding string support for OEM custom HBA
Date: Mon, 30 Mar 2015 19:25:14 +0530
Message-ID: <1427723723-12676-12-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Add the following OEM's branding to the mpt3sas driver.

"VendorID"   "DeviceID"  "SubsystemVendor ID"   "SubsystemDevice ID"  Cisco Branding String
0x1000         0x97         SVID = 0x1137             0x014C          Cisco 9300-8E 12G SAS HBA

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h | 11 +++++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index db362cb..267e489 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2378,6 +2378,39 @@ _base_display_dell_branding(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/**
+ * _base_display_cisco_branding - Display branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_cisco_branding(struct MPT3SAS_ADAPTER *ioc)
+{
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_CISCO)
+		return;
+
+	switch (ioc->pdev->device) {
+	case MPI25_MFGPAGE_DEVID_SAS3008:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT3SAS_CISCO_12G_HBA_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_CISCO_12G_HBA_BRANDING);
+			break;
+		default:
+			pr_info(MPT3SAS_FMT
+			  "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
+			  ioc->name, ioc->pdev->subsystem_device);
+			break;
+		}
+		break;
+	default:
+		 pr_info(MPT3SAS_FMT
+			"Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
+			ioc->name, ioc->pdev->subsystem_device);
+		break;
+	}
+}
 
 /**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
@@ -2410,6 +2443,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 
 	_base_display_intel_branding(ioc);
 	_base_display_dell_branding(ioc);
+	_base_display_cisco_branding(ioc);
 
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 158a29c..8f99024 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -163,6 +163,17 @@
 #define MPT3SAS_DELL_12G_HBA_SSDID	0x1F46
 
 /*
+ * Cisco HBA branding
+ */
+#define MPT3SAS_CISCO_12G_HBA_BRANDING       \
+	"Cisco 9300-8E 12G SAS HBA"
+
+/*
+ * Cisco HBA SSSDIDs
+ */
+ #define MPT3SAS_CISCO_12G_HBA_SSDID  0x14C
+
+/*
  * status bits for ioc->diag_buffer_status
  */
 #define MPT3_DIAG_BUFFER_IS_REGISTERED	(0x01)
-- 
2.0.2
