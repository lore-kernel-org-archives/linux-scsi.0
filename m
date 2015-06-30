From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 16/20] [SCSI] mpt3sas: Added support for  customer specific branding
Date: Tue, 30 Jun 2015 12:25:02 +0530
Message-ID: <1435647306-36956-17-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Added support for below customer specific brandings

"VendorID"   "DeviceID"  "SubsystemVendor ID"   "SubsystemDevice ID"  Cisco Branding String
0x1000         0x97           0x1137                 0x154           Cisco 9300-8i 12Gbps SAS HBA
0x1000         0x97           0x1137                 0x155           Cisco 12G Modular SAS Pass through Controller
0x1000         0x97           0x1137                 0x156           UCS C3X60 12G SAS Pass through Controller

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 29 +++++++++++++++++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_base.h | 16 ++++++++++++----
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6e44370..dd04ec0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2413,9 +2413,17 @@ _base_display_cisco_branding(struct MPT3SAS_ADAPTER *ioc)
 	switch (ioc->pdev->device) {
 	case MPI25_MFGPAGE_DEVID_SAS3008:
 		switch (ioc->pdev->subsystem_device) {
-		case MPT3SAS_CISCO_12G_HBA_SSDID:
+		case MPT3SAS_CISCO_12G_8E_HBA_SSDID:
 			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_CISCO_12G_HBA_BRANDING);
+				MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
+			break;
+		case MPT3SAS_CISCO_12G_8I_HBA_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
+			break;
+		case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
 			break;
 		default:
 			pr_info(MPT3SAS_FMT
@@ -2424,6 +2432,23 @@ _base_display_cisco_branding(struct MPT3SAS_ADAPTER *ioc)
 			break;
 		}
 		break;
+	case MPI25_MFGPAGE_DEVID_SAS3108_1:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+			MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
+			break;
+		case MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+			MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING);
+			break;
+		default:
+			pr_info(MPT3SAS_FMT
+			 "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
+			 ioc->name, ioc->pdev->subsystem_device);
+			break;
+		}
+		break;
 	default:
 		 pr_info(MPT3SAS_FMT
 			"Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 3b03639..87e9000 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -165,13 +165,21 @@
 /*
  * Cisco HBA branding
  */
-#define MPT3SAS_CISCO_12G_HBA_BRANDING       \
-	"Cisco 9300-8E 12G SAS HBA"
-
+#define MPT3SAS_CISCO_12G_8E_HBA_BRANDING		\
+		"Cisco 9300-8E 12G SAS HBA"
+#define MPT3SAS_CISCO_12G_8I_HBA_BRANDING		\
+		"Cisco 9300-8i 12G SAS HBA"
+#define MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING	\
+		"Cisco 12G Modular SAS Pass through Controller"
+#define MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING		\
+		"UCS C3X60 12G SAS Pass through Controller"
 /*
  * Cisco HBA SSSDIDs
  */
- #define MPT3SAS_CISCO_12G_HBA_SSDID  0x14C
+#define MPT3SAS_CISCO_12G_8E_HBA_SSDID  0x14C
+#define MPT3SAS_CISCO_12G_8I_HBA_SSDID  0x154
+#define MPT3SAS_CISCO_12G_AVILA_HBA_SSDID  0x155
+#define MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID  0x156
 
 /*
  * status bits for ioc->diag_buffer_status
-- 
2.0.2
