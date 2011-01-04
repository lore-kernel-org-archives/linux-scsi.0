From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 05/10] mpt2sas: Add support for Customer specific branding messages
Date: Tue, 4 Jan 2011 11:36:37 +0530
Message-ID: <20110104060628.GF5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33351 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab1ADGv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 01:51:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Add support for Customer specific branding messages when device driver loads,
based on specific customer subsystem vendor and device Ids

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a11ac67..4f1f3f2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1725,6 +1725,31 @@ _base_display_dell_branding(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
+ * _base_display_intel_branding - Display branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
+{
+	if (ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_INTEL &&
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008) {
+
+		switch (ioc->pdev->subsystem_device) {
+		case MPT2SAS_INTEL_RMS2LL080_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS2LL080_BRANDING);
+			break;
+		case MPT2SAS_INTEL_RMS2LL040_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS2LL040_BRANDING);
+			break;
+		}
+	}
+}
+
+/**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
  * @ioc: per adapter object
  *
@@ -1754,6 +1779,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 	    ioc->bios_pg3.BiosVersion & 0x000000FF);
 
 	_base_display_dell_branding(ioc);
+	_base_display_intel_branding(ioc);
 
 	printk(MPT2SAS_INFO_FMT "Protocol=(", ioc->name);
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 283568c..82579fb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -154,6 +154,20 @@
 #define MPT2SAS_DELL_6GBPS_SAS_SSDID               0x1F22
 
 /*
+ * Intel HBA branding
+ */
+#define MPT2SAS_INTEL_RMS2LL080_BRANDING	\
+				"Intel Integrated RAID Module RMS2LL080"
+#define MPT2SAS_INTEL_RMS2LL040_BRANDING	\
+				"Intel Integrated RAID Module RMS2LL040"
+
+/*
+ * Intel HBA SSDIDs
+ */
+#define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
+#define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
+
+/*
  * per target private data
  */
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x01
