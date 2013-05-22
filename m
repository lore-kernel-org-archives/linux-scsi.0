From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 07/12] megaraid_sas : Add support to display Customer
 branding details in syslog
Date: Wed, 22 May 2013 12:32:43 +0530
Message-ID: <201305221233.r4MCWx8x012554@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:24525
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617Ab3EVMdF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:33:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Add support to display Customer branding details in syslog.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 64cc4d4..474f79f 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -52,6 +52,32 @@
 #define PCI_DEVICE_ID_LSI_FURY			0x005f
 
 /*
+ * Intel HBA SSDIDs
+ */
+#define MEGARAID_INTEL_RS3DC080_SSDID		0x9360
+#define MEGARAID_INTEL_RS3DC040_SSDID		0x9362
+#define MEGARAID_INTEL_RS3SC008_SSDID		0x9380
+#define MEGARAID_INTEL_RS3MC044_SSDID		0x9381
+#define MEGARAID_INTEL_RS3WC080_SSDID		0x9341
+#define MEGARAID_INTEL_RS3WC040_SSDID		0x9343
+
+/*
+ * Intel HBA branding
+ */
+#define MEGARAID_INTEL_RS3DC080_BRANDING	\
+	"Intel(R) RAID Controller RS3DC080"
+#define MEGARAID_INTEL_RS3DC040_BRANDING	\
+	"Intel(R) RAID Controller RS3DC040"
+#define MEGARAID_INTEL_RS3SC008_BRANDING	\
+	"Intel(R) RAID Controller RS3SC008"
+#define MEGARAID_INTEL_RS3MC044_BRANDING	\
+	"Intel(R) RAID Controller RS3MC044"
+#define MEGARAID_INTEL_RS3WC080_BRANDING	\
+	"Intel(R) RAID Controller RS3WC080"
+#define MEGARAID_INTEL_RS3WC040_BRANDING	\
+	"Intel(R) RAID Controller RS3WC040"
+
+/*
  * =====================================
  * MegaRAID SAS MFI firmware definitions
  * =====================================
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 454743d..73aa68e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -864,6 +864,66 @@ megasas_sync_map_info(struct megasas_instance *instance)
 	return ret;
 }
 
+/*
+ * meagasas_display_intel_branding - Display branding string
+ * @instance: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+megasas_display_intel_branding(struct megasas_instance *instance)
+{
+	if (instance->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
+		return;
+
+	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_INVADER:
+		switch (instance->pdev->subsystem_device) {
+		case MEGARAID_INTEL_RS3DC080_SSDID:
+			dev_info(&instance->pdev->dev, "scsi host %d: %s\n",
+				instance->host->host_no,
+				MEGARAID_INTEL_RS3DC080_BRANDING);
+			break;
+		case MEGARAID_INTEL_RS3DC040_SSDID:
+			dev_info(&instance->pdev->dev, "scsi host %d: %s\n",
+				instance->host->host_no,
+				MEGARAID_INTEL_RS3DC040_BRANDING);
+			break;
+		case MEGARAID_INTEL_RS3SC008_SSDID:
+			dev_info(&instance->pdev->dev, "scsi host %d: %s\n",
+				instance->host->host_no,
+				MEGARAID_INTEL_RS3SC008_BRANDING);
+			break;
+		case MEGARAID_INTEL_RS3MC044_SSDID:
+			dev_info(&instance->pdev->dev, "scsi host %d: %s\n",
+				instance->host->host_no,
+				MEGARAID_INTEL_RS3MC044_BRANDING);
+			break;
+		default:
+			break;
+		}
+		break;
+	case PCI_DEVICE_ID_LSI_FURY:
+		switch (instance->pdev->subsystem_device) {
+		case MEGARAID_INTEL_RS3WC080_SSDID:
+			dev_info(&instance->pdev->dev, "scsi host %d: %s\n",
+				instance->host->host_no,
+				MEGARAID_INTEL_RS3WC080_BRANDING);
+			break;
+		case MEGARAID_INTEL_RS3WC040_SSDID:
+			dev_info(&instance->pdev->dev, "scsi host %d: %s\n",
+				instance->host->host_no,
+				MEGARAID_INTEL_RS3WC040_BRANDING);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 /**
  * megasas_init_adapter_fusion -	Initializes the FW
  * @instance:		Adapter soft state
@@ -944,6 +1004,8 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	if (megasas_ioc_init_fusion(instance))
 		goto fail_ioc_init;
 
+	megasas_display_intel_branding(instance);
+
 	instance->flag_ieee = 1;
 
 	fusion->map_sz =  sizeof(struct MR_FW_RAID_MAP) +

