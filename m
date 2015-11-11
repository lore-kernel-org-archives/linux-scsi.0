From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 16/25] mpt3sas: Added OEMs Gen2 PnP ID Branding names
Date: Wed, 11 Nov 2015 17:30:32 +0530
Message-ID: <1447243241-10912-17-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33627 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbbKKMCb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 07:02:31 -0500
Received: by pabfh17 with SMTP id fh17so29739016pab.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2015 04:02:31 -0800 (PST)
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Added OEMs Gen2 PnP ID Branding names from mpt2sas driver.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 326 ++++++++++++++++++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  93 +++++++++-
 2 files changed, 305 insertions(+), 114 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f7f2ab5..bec3163 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2508,143 +2508,261 @@ mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
- * _base_display_intel_branding - Display branding string
+ * _base_display_OEMs_branding - Display branding string
  * @ioc: per adapter object
  *
  * Return nothing.
  */
 static void
-_base_display_intel_branding(struct MPT3SAS_ADAPTER *ioc)
+_base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 {
 	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
 		return;
 
-	switch (ioc->pdev->device) {
-	case MPI25_MFGPAGE_DEVID_SAS3008:
-		switch (ioc->pdev->subsystem_device) {
-		case MPT3SAS_INTEL_RMS3JC080_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_INTEL_RMS3JC080_BRANDING);
-			break;
-
-		case MPT3SAS_INTEL_RS3GC008_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_INTEL_RS3GC008_BRANDING);
-			break;
-		case MPT3SAS_INTEL_RS3FC044_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_INTEL_RS3FC044_BRANDING);
-			break;
-		case MPT3SAS_INTEL_RS3UC080_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_INTEL_RS3UC080_BRANDING);
+	switch (ioc->pdev->subsystem_vendor) {
+	case PCI_VENDOR_ID_INTEL:
+		switch (ioc->pdev->device) {
+		case MPI2_MFGPAGE_DEVID_SAS2008:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT2SAS_INTEL_RMS2LL080_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS2LL080_BRANDING);
+				break;
+			case MPT2SAS_INTEL_RMS2LL040_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS2LL040_BRANDING);
+				break;
+			case MPT2SAS_INTEL_SSD910_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_SSD910_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				 "Intel(R) Controller: Subsystem ID: 0x%X\n",
+				 ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
+		case MPI2_MFGPAGE_DEVID_SAS2308_2:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT2SAS_INTEL_RS25GB008_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RS25GB008_BRANDING);
+				break;
+			case MPT2SAS_INTEL_RMS25JB080_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS25JB080_BRANDING);
+				break;
+			case MPT2SAS_INTEL_RMS25JB040_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS25JB040_BRANDING);
+				break;
+			case MPT2SAS_INTEL_RMS25KB080_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS25KB080_BRANDING);
+				break;
+			case MPT2SAS_INTEL_RMS25KB040_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS25KB040_BRANDING);
+				break;
+			case MPT2SAS_INTEL_RMS25LB040_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS25LB040_BRANDING);
+				break;
+			case MPT2SAS_INTEL_RMS25LB080_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_INTEL_RMS25LB080_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				 "Intel(R) Controller: Subsystem ID: 0x%X\n",
+				 ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
+		case MPI25_MFGPAGE_DEVID_SAS3008:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT3SAS_INTEL_RMS3JC080_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_INTEL_RMS3JC080_BRANDING);
+				break;
+
+			case MPT3SAS_INTEL_RS3GC008_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_INTEL_RS3GC008_BRANDING);
+				break;
+			case MPT3SAS_INTEL_RS3FC044_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_INTEL_RS3FC044_BRANDING);
+				break;
+			case MPT3SAS_INTEL_RS3UC080_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_INTEL_RS3UC080_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				 "Intel(R) Controller: Subsystem ID: 0x%X\n",
+				 ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
 			break;
 		default:
 			pr_info(MPT3SAS_FMT
-				"Intel(R) Controller: Subsystem ID: 0x%X\n",
-				ioc->name, ioc->pdev->subsystem_device);
+			 "Intel(R) Controller: Subsystem ID: 0x%X\n",
+			 ioc->name, ioc->pdev->subsystem_device);
 			break;
 		}
 		break;
-	default:
-		pr_info(MPT3SAS_FMT
-			"Intel(R) Controller: Subsystem ID: 0x%X\n",
-			ioc->name, ioc->pdev->subsystem_device);
-		break;
-	}
-}
-
-
-
-/**
- * _base_display_dell_branding - Display branding string
- * @ioc: per adapter object
- *
- * Return nothing.
- */
-static void
-_base_display_dell_branding(struct MPT3SAS_ADAPTER *ioc)
-{
-	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_DELL)
-		return;
-
-	switch (ioc->pdev->device) {
-	case MPI25_MFGPAGE_DEVID_SAS3008:
-		switch (ioc->pdev->subsystem_device) {
-		case MPT3SAS_DELL_12G_HBA_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_DELL_12G_HBA_BRANDING);
+	case PCI_VENDOR_ID_DELL:
+		switch (ioc->pdev->device) {
+		case MPI2_MFGPAGE_DEVID_SAS2008:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING);
+				break;
+			case MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING);
+				break;
+			case MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING);
+				break;
+			case MPT2SAS_DELL_PERC_H200_MODULAR_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING);
+				break;
+			case MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING);
+				break;
+			case MPT2SAS_DELL_PERC_H200_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_DELL_PERC_H200_BRANDING);
+				break;
+			case MPT2SAS_DELL_6GBPS_SAS_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_DELL_6GBPS_SAS_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				   "Dell 6Gbps HBA: Subsystem ID: 0x%X\n",
+				   ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
+			break;
+		case MPI25_MFGPAGE_DEVID_SAS3008:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT3SAS_DELL_12G_HBA_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_DELL_12G_HBA_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				   "Dell 12Gbps HBA: Subsystem ID: 0x%X\n",
+				   ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
 			break;
 		default:
 			pr_info(MPT3SAS_FMT
-			   "Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
+			   "Dell HBA: Subsystem ID: 0x%X\n", ioc->name,
 			   ioc->pdev->subsystem_device);
 			break;
 		}
 		break;
-	default:
-		pr_info(MPT3SAS_FMT
-			"Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
-			ioc->pdev->subsystem_device);
-		break;
-	}
-}
-
-/**
- * _base_display_cisco_branding - Display branding string
- * @ioc: per adapter object
- *
- * Return nothing.
- */
-static void
-_base_display_cisco_branding(struct MPT3SAS_ADAPTER *ioc)
-{
-	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_CISCO)
-		return;
-
-	switch (ioc->pdev->device) {
-	case MPI25_MFGPAGE_DEVID_SAS3008:
-		switch (ioc->pdev->subsystem_device) {
-		case MPT3SAS_CISCO_12G_8E_HBA_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
-			break;
-		case MPT3SAS_CISCO_12G_8I_HBA_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
+	case PCI_VENDOR_ID_CISCO:
+		switch (ioc->pdev->device) {
+		case MPI25_MFGPAGE_DEVID_SAS3008:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT3SAS_CISCO_12G_8E_HBA_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
+				break;
+			case MPT3SAS_CISCO_12G_8I_HBA_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
+				break;
+			case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+					MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				  "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
+				  ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
 			break;
-		case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+		case MPI25_MFGPAGE_DEVID_SAS3108_1:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 				MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
+				break;
+			case MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING
+				);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				 "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
+				 ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
 			break;
 		default:
 			pr_info(MPT3SAS_FMT
-			  "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
-			  ioc->name, ioc->pdev->subsystem_device);
+			   "Cisco SAS HBA: Subsystem ID: 0x%X\n",
+			   ioc->name, ioc->pdev->subsystem_device);
 			break;
 		}
 		break;
-	case MPI25_MFGPAGE_DEVID_SAS3108_1:
-		switch (ioc->pdev->subsystem_device) {
-		case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-			MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
-			break;
-		case MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID:
-			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-			MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING);
-			break;
+	case MPT2SAS_HP_3PAR_SSVID:
+		switch (ioc->pdev->device) {
+		case MPI2_MFGPAGE_DEVID_SAS2004:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				   "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
+				   ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
+		case MPI2_MFGPAGE_DEVID_SAS2308_2:
+			switch (ioc->pdev->subsystem_device) {
+			case MPT2SAS_HP_2_4_INTERNAL_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_HP_2_4_INTERNAL_BRANDING);
+				break;
+			case MPT2SAS_HP_2_4_EXTERNAL_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_HP_2_4_EXTERNAL_BRANDING);
+				break;
+			case MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				 MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING);
+				break;
+			case MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_SSDID:
+				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				    MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING);
+				break;
+			default:
+				pr_info(MPT3SAS_FMT
+				   "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
+				   ioc->name, ioc->pdev->subsystem_device);
+				break;
+			}
 		default:
 			pr_info(MPT3SAS_FMT
-			 "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
-			 ioc->name, ioc->pdev->subsystem_device);
+			   "HP SAS HBA: Subsystem ID: 0x%X\n",
+			   ioc->name, ioc->pdev->subsystem_device);
 			break;
 		}
-		break;
 	default:
-		 pr_info(MPT3SAS_FMT
-			"Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
-			ioc->name, ioc->pdev->subsystem_device);
 		break;
 	}
 }
@@ -2678,9 +2796,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	   (bios_version & 0x0000FF00) >> 8,
 	    bios_version & 0x000000FF);
 
-	_base_display_intel_branding(ioc);
-	_base_display_dell_branding(ioc);
-	_base_display_cisco_branding(ioc);
+	_base_display_OEMs_branding(ioc);
 
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index b61a785..c92be3c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -158,6 +158,27 @@
 /*
  * Intel HBA branding
  */
+#define MPT2SAS_INTEL_RMS25JB080_BRANDING    \
+	"Intel(R) Integrated RAID Module RMS25JB080"
+#define MPT2SAS_INTEL_RMS25JB040_BRANDING    \
+	"Intel(R) Integrated RAID Module RMS25JB040"
+#define MPT2SAS_INTEL_RMS25KB080_BRANDING    \
+	"Intel(R) Integrated RAID Module RMS25KB080"
+#define MPT2SAS_INTEL_RMS25KB040_BRANDING    \
+	"Intel(R) Integrated RAID Module RMS25KB040"
+#define MPT2SAS_INTEL_RMS25LB040_BRANDING	\
+	"Intel(R) Integrated RAID Module RMS25LB040"
+#define MPT2SAS_INTEL_RMS25LB080_BRANDING	\
+	"Intel(R) Integrated RAID Module RMS25LB080"
+#define MPT2SAS_INTEL_RMS2LL080_BRANDING	\
+	"Intel Integrated RAID Module RMS2LL080"
+#define MPT2SAS_INTEL_RMS2LL040_BRANDING	\
+	"Intel Integrated RAID Module RMS2LL040"
+#define MPT2SAS_INTEL_RS25GB008_BRANDING       \
+	"Intel(R) RAID Controller RS25GB008"
+#define MPT2SAS_INTEL_SSD910_BRANDING          \
+	"Intel(R) SSD 910 Series"
+
 #define MPT3SAS_INTEL_RMS3JC080_BRANDING       \
 	"Intel(R) Integrated RAID Module RMS3JC080"
 #define MPT3SAS_INTEL_RS3GC008_BRANDING       \
@@ -170,33 +191,62 @@
 /*
  * Intel HBA SSDIDs
  */
-#define MPT3SAS_INTEL_RMS3JC080_SSDID	0x3521
-#define MPT3SAS_INTEL_RS3GC008_SSDID	0x3522
-#define MPT3SAS_INTEL_RS3FC044_SSDID	0x3523
-#define MPT3SAS_INTEL_RS3UC080_SSDID    0x3524
+#define MPT2SAS_INTEL_RMS25JB080_SSDID		0x3516
+#define MPT2SAS_INTEL_RMS25JB040_SSDID		0x3517
+#define MPT2SAS_INTEL_RMS25KB080_SSDID		0x3518
+#define MPT2SAS_INTEL_RMS25KB040_SSDID		0x3519
+#define MPT2SAS_INTEL_RMS25LB040_SSDID		0x351A
+#define MPT2SAS_INTEL_RMS25LB080_SSDID		0x351B
+#define MPT2SAS_INTEL_RMS2LL080_SSDID		0x350E
+#define MPT2SAS_INTEL_RMS2LL040_SSDID		0x350F
+#define MPT2SAS_INTEL_RS25GB008_SSDID		0x3000
+#define MPT2SAS_INTEL_SSD910_SSDID		0x3700
+
+#define MPT3SAS_INTEL_RMS3JC080_SSDID		0x3521
+#define MPT3SAS_INTEL_RS3GC008_SSDID		0x3522
+#define MPT3SAS_INTEL_RS3FC044_SSDID		0x3523
+#define MPT3SAS_INTEL_RS3UC080_SSDID		0x3524
 
 /*
  * Dell HBA branding
  */
+#define MPT2SAS_DELL_BRANDING_SIZE                 32
+
+#define MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING        "Dell 6Gbps SAS HBA"
+#define MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING    "Dell PERC H200 Adapter"
+#define MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING "Dell PERC H200 Integrated"
+#define MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING    "Dell PERC H200 Modular"
+#define MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING   "Dell PERC H200 Embedded"
+#define MPT2SAS_DELL_PERC_H200_BRANDING            "Dell PERC H200"
+#define MPT2SAS_DELL_6GBPS_SAS_BRANDING            "Dell 6Gbps SAS"
+
 #define MPT3SAS_DELL_12G_HBA_BRANDING       \
 	"Dell 12Gbps HBA"
 
 /*
  * Dell HBA SSDIDs
  */
-#define MPT3SAS_DELL_12G_HBA_SSDID	0x1F46
+#define MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID	0x1F1C
+#define MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID	0x1F1D
+#define MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID	0x1F1E
+#define MPT2SAS_DELL_PERC_H200_MODULAR_SSDID	0x1F1F
+#define MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID	0x1F20
+#define MPT2SAS_DELL_PERC_H200_SSDID		0x1F21
+#define MPT2SAS_DELL_6GBPS_SAS_SSDID		0x1F22
+
+#define MPT3SAS_DELL_12G_HBA_SSDID		0x1F46
 
 /*
  * Cisco HBA branding
  */
 #define MPT3SAS_CISCO_12G_8E_HBA_BRANDING		\
-		"Cisco 9300-8E 12G SAS HBA"
+	"Cisco 9300-8E 12G SAS HBA"
 #define MPT3SAS_CISCO_12G_8I_HBA_BRANDING		\
-		"Cisco 9300-8i 12G SAS HBA"
+	"Cisco 9300-8i 12G SAS HBA"
 #define MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING	\
-		"Cisco 12G Modular SAS Pass through Controller"
+	"Cisco 12G Modular SAS Pass through Controller"
 #define MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING		\
-		"UCS C3X60 12G SAS Pass through Controller"
+	"UCS C3X60 12G SAS Pass through Controller"
 /*
  * Cisco HBA SSSDIDs
  */
@@ -213,6 +263,31 @@
 #define MPT3_DIAG_BUFFER_IS_DIAG_RESET	(0x04)
 
 /*
+ * HP HBA branding
+ */
+#define MPT2SAS_HP_3PAR_SSVID                0x1590
+
+#define MPT2SAS_HP_2_4_INTERNAL_BRANDING	\
+	"HP H220 Host Bus Adapter"
+#define MPT2SAS_HP_2_4_EXTERNAL_BRANDING	\
+	"HP H221 Host Bus Adapter"
+#define MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING	\
+	"HP H222 Host Bus Adapter"
+#define MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING	\
+	"HP H220i Host Bus Adapter"
+#define MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING	\
+	"HP H210i Host Bus Adapter"
+
+/*
+ * HO HBA SSDIDs
+ */
+#define MPT2SAS_HP_2_4_INTERNAL_SSDID			0x0041
+#define MPT2SAS_HP_2_4_EXTERNAL_SSDID			0x0042
+#define MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_SSDID	0x0043
+#define MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_SSDID		0x0044
+#define MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_SSDID		0x0046
+
+/*
  * Combined Reply Queue constants,
  * There are twelve Supplemental Reply Post Host Index Registers
  * and each register is at offset 0x10 bytes from the previous one.
-- 
2.0.2

