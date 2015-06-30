From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 10/20] [SCSI] mpt3sas: Add branding string  support for OEM's  HBA
Date: Tue, 30 Jun 2015 12:24:56 +0530
Message-ID: <1435647306-36956-11-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33881 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbbF3G4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:56:09 -0400
Received: by pabvl15 with SMTP id vl15so687187pab.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:56:08 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Added the following Dell branding to the mpt3sas driver.

"VendorID"   "DeviceID"  "SubsystemVendor ID"  "SubsystemDevice ID"  Dell Branding String
0x1000        0x0097          0x1028                 0x1F46            DELL 12Gbps HBA

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h | 11 +++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8730160..e8b93a8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2365,6 +2365,41 @@ _base_display_intel_branding(struct MPT3SAS_ADAPTER *ioc)
 
 
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
@@ -2394,6 +2429,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	    bios_version & 0x000000FF);
 
 	_base_display_intel_branding(ioc);
+	_base_display_dell_branding(ioc);
 
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index c0c774f..a5a34f3 100644
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

