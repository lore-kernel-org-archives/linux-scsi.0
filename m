From: sumit.saxena@avagotech.com
Subject: [PATCH 04/12] megaraid_sas : Support for Cutlass(12 Gbps)
 controller
Date: Thu, 15 Oct 2015 13:39:54 +0530
Message-ID: <201510150817.t9F8HC6g029618@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.48]:42986 "EHLO
	rndsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbJOIUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |    5 +++++
 drivers/scsi/megaraid/megaraid_sas_base.c   |    6 ++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   12 ++++++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 7b651c1..d236cc2 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -54,6 +54,8 @@
 #define PCI_DEVICE_ID_LSI_FURY			0x005f
 #define PCI_DEVICE_ID_LSI_INTRUDER		0x00ce
 #define PCI_DEVICE_ID_LSI_INTRUDER_24		0x00cf
+#define PCI_DEVICE_ID_LSI_CUTLASS_52		0x0052
+#define PCI_DEVICE_ID_LSI_CUTLASS_53		0x0053
 
 /*
  * Intel HBA SSDIDs
@@ -64,6 +66,7 @@
 #define MEGARAID_INTEL_RS3MC044_SSDID		0x9381
 #define MEGARAID_INTEL_RS3WC080_SSDID		0x9341
 #define MEGARAID_INTEL_RS3WC040_SSDID		0x9343
+#define MEGARAID_INTEL_RMS3BC160_SSDID		0x352B
 
 /*
  * Intruder HBA SSDIDs
@@ -87,6 +90,8 @@
 	"Intel(R) RAID Controller RS3WC080"
 #define MEGARAID_INTEL_RS3WC040_BRANDING	\
 	"Intel(R) RAID Controller RS3WC040"
+#define MEGARAID_INTEL_RMS3BC160_BRANDING	\
+	"Intel(R) Integrated RAID Module RMS3BC160"
 
 /*
  * =====================================
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b68c318..92c5bbe 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -139,6 +139,8 @@ static struct pci_device_id megasas_pci_table[] = {
 	/* Intruder */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_INTRUDER_24)},
 	/* Intruder 24 port*/
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CUTLASS_52)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CUTLASS_53)},
 	{}
 };
 
@@ -4635,6 +4637,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	case PCI_DEVICE_ID_LSI_FURY:
 	case PCI_DEVICE_ID_LSI_INTRUDER:
 	case PCI_DEVICE_ID_LSI_INTRUDER_24:
+	case PCI_DEVICE_ID_LSI_CUTLASS_52:
+	case PCI_DEVICE_ID_LSI_CUTLASS_53:
 		instance->instancet = &megasas_instance_template_fusion;
 		break;
 	case PCI_DEVICE_ID_LSI_SAS1078R:
@@ -5332,6 +5336,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	case PCI_DEVICE_ID_LSI_FURY:
 	case PCI_DEVICE_ID_LSI_INTRUDER:
 	case PCI_DEVICE_ID_LSI_INTRUDER_24:
+	case PCI_DEVICE_ID_LSI_CUTLASS_52:
+	case PCI_DEVICE_ID_LSI_CUTLASS_53:
 	{
 		instance->ctrl_context_pages =
 			get_order(sizeof(struct fusion_context));
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 365ec52..72c731d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1037,6 +1037,18 @@ megasas_display_intel_branding(struct megasas_instance *instance)
 			break;
 		}
 		break;
+	case PCI_DEVICE_ID_LSI_CUTLASS_52:
+	case PCI_DEVICE_ID_LSI_CUTLASS_53:
+		switch (instance->pdev->subsystem_device) {
+		case MEGARAID_INTEL_RMS3BC160_SSDID:
+			dev_info(&instance->pdev->dev, "scsi host %d: %s\n",
+				instance->host->host_no,
+				MEGARAID_INTEL_RMS3BC160_BRANDING);
+			break;
+		default:
+			break;
+		}
+		break;
 	default:
 		break;
 	}
-- 
1.7.1

