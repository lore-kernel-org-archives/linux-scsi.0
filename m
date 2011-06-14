From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 06/07] mpt2sas: Adding support for customer specific branding
Date: Tue, 14 Jun 2011 10:57:31 +0530
Message-ID: <20110614052727.GH14349@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57590 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab1FNFCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 01:02:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Adding support for displaying customer branding info.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 1da606c..83035bd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1740,9 +1740,11 @@ _base_display_dell_branding(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 {
-	if (ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_INTEL &&
-	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008) {
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
+		return;
 
+	switch (ioc->pdev->device) {
+	case MPI2_MFGPAGE_DEVID_SAS2008:
 		switch (ioc->pdev->subsystem_device) {
 		case MPT2SAS_INTEL_RMS2LL080_SSDID:
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
@@ -1752,7 +1754,20 @@ _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 			    MPT2SAS_INTEL_RMS2LL040_BRANDING);
 			break;
+		default:
+			break;
 		}
+	case MPI2_MFGPAGE_DEVID_SAS2308_2:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT2SAS_INTEL_RS25GB008_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RS25GB008_BRANDING);
+			break;
+		default:
+			break;
+		}
+	default:
+		break;
 	}
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index df135db..b743847 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -161,12 +161,15 @@
 				"Intel Integrated RAID Module RMS2LL080"
 #define MPT2SAS_INTEL_RMS2LL040_BRANDING	\
 				"Intel Integrated RAID Module RMS2LL040"
+#define MPT2SAS_INTEL_RS25GB008_BRANDING       \
+				"Intel(R) RAID Controller RS25GB008"
 
 /*
  * Intel HBA SSDIDs
  */
 #define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
 #define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
+#define MPT2SAS_INTEL_RS25GB008_SSDID          0x3000
 
 
 /*
