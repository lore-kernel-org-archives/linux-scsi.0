From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : Added customer specific display support
Date: Tue, 15 Mar 2011 20:04:26 +0530
Message-ID: <20110315143422.GB6966@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47064 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754964Ab1COOWv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2011 10:22:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Added Vendor specific branding message support.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6bd1711..8745b8b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1757,6 +1757,54 @@ _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
+ * _base_display_hp_branding - Display branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_hp_branding(struct MPT2SAS_ADAPTER *ioc)
+{
+	if (ioc->pdev->subsystem_vendor != MPT2SAS_HP_3PAR_SSVID)
+		return;
+
+	switch (ioc->pdev->device) {
+	case MPI2_MFGPAGE_DEVID_SAS2004:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING);
+			break;
+		default:
+			break;
+		}
+	case MPI2_MFGPAGE_DEVID_SAS2308_2:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT2SAS_HP_2_4_INTERNAL_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_HP_2_4_INTERNAL_BRANDING);
+			break;
+		case MPT2SAS_HP_2_4_EXTERNAL_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_HP_2_4_EXTERNAL_BRANDING);
+			break;
+		case MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING);
+			break;
+		case MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING);
+			break;
+		default:
+			break;
+		}
+	default:
+		break;
+	}
+}
+
+/**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
  * @ioc: per adapter object
  *
@@ -1787,6 +1835,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 
 	_base_display_dell_branding(ioc);
 	_base_display_intel_branding(ioc);
+	_base_display_hp_branding(ioc);
 
 	printk(MPT2SAS_INFO_FMT "Protocol=(", ioc->name);
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index b4aa105..cc02794 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -178,6 +178,26 @@
 #define MPT2_WARPDRIVE_LC_SSDLF		(0x44)
 #define MPT2_WARPDRIVE_LC_BRMF		(0x4D)
 
+
+/*
+ * HP HBA branding
+ */
+#define MPT2SAS_HP_3PAR_SSVID                0x1590
+#define MPT2SAS_HP_2_4_INTERNAL_BRANDING        "HP H220 Host Bus Adapter"
+#define MPT2SAS_HP_2_4_EXTERNAL_BRANDING        "HP H221 Host Bus Adapter"
+#define MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING "HP H222 Host Bus Adapter"
+#define MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING    "HP H220i Host Bus Adapter"
+#define MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING    "HP H210i Host Bus Adapter"
+
+/*
+ * HO HBA SSDIDs
+ */
+#define MPT2SAS_HP_2_4_INTERNAL_SSDID            0x0041
+#define MPT2SAS_HP_2_4_EXTERNAL_SSDID            0x0042
+#define MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_SSDID    0x0043
+#define MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_SSDID        0x0044
+#define MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_SSDID        0x0046
+
 /*
  * per target private data
  */
