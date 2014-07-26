From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 18:48:10 +0200
Message-ID: <1406393290-5391-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 8b88118..00005f0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1922,38 +1922,37 @@ _base_display_dell_branding(struct MPT2SAS_ADAPTER *ioc)
 	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_DELL)
 		return;
 
-	memset(dell_branding, 0, MPT2SAS_DELL_BRANDING_SIZE);
 	switch (ioc->pdev->subsystem_device) {
 	case MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID:
-		strncpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING,
-		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		strlcpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE);
 		break;
 	case MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID:
-		strncpy(dell_branding, MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING,
-		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		strlcpy(dell_branding, MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE);
 		break;
 	case MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID:
-		strncpy(dell_branding,
+		strlcpy(dell_branding,
 		    MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING,
-		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		    MPT2SAS_DELL_BRANDING_SIZE);
 		break;
 	case MPT2SAS_DELL_PERC_H200_MODULAR_SSDID:
-		strncpy(dell_branding,
+		strlcpy(dell_branding,
 		    MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING,
-		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		    MPT2SAS_DELL_BRANDING_SIZE);
 		break;
 	case MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID:
-		strncpy(dell_branding,
+		strlcpy(dell_branding,
 		    MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING,
-		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		    MPT2SAS_DELL_BRANDING_SIZE);
 		break;
 	case MPT2SAS_DELL_PERC_H200_SSDID:
-		strncpy(dell_branding, MPT2SAS_DELL_PERC_H200_BRANDING,
-		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		strlcpy(dell_branding, MPT2SAS_DELL_PERC_H200_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE);
 		break;
 	case MPT2SAS_DELL_6GBPS_SAS_SSDID:
-		strncpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_BRANDING,
-		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		strlcpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE);
 		break;
 	default:
 		sprintf(dell_branding, "0x%4X", ioc->pdev->subsystem_device);
@@ -2097,7 +2096,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 	u32 bios_version;
 
 	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
-	strncpy(desc, ioc->manu_pg0.ChipName, 16);
+	strlcpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
 	printk(MPT2SAS_INFO_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "
 	   "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
 	    ioc->name, desc,
-- 
1.7.10.4
