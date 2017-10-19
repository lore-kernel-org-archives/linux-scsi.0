From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 02/19] megaraid_sas: Add support for Crusader controllers
Date: Thu, 19 Oct 2017 02:48:49 -0700
Message-ID: <1508406546-25944-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:44856 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdJSJuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:03 -0400
Received: by mail-pf0-f195.google.com with SMTP id x7so6205014pfa.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:03 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Add support for PCI VID/DID 0x1000/0x0015 based MegaRAID controllers.
Since the DID 0x0015 conflicts with DELL PERC5 controllers,
add vendor ID based check specific for DELL PERC5.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 51 ++++++++++++++++++-------------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 90b9b5d7f0f8..3f20273b115b 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -57,6 +57,7 @@
 #define PCI_DEVICE_ID_LSI_CUTLASS_52		0x0052
 #define PCI_DEVICE_ID_LSI_CUTLASS_53		0x0053
 #define PCI_DEVICE_ID_LSI_VENTURA		    0x0014
+#define PCI_DEVICE_ID_LSI_CRUSADER		    0x0015
 #define PCI_DEVICE_ID_LSI_HARPOON		    0x0016
 #define PCI_DEVICE_ID_LSI_TOMCAT		    0x0017
 #define PCI_DEVICE_ID_LSI_VENTURA_4PORT		0x001B
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2f9955c6c2af..eba627ccd041 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -161,6 +161,7 @@ static struct pci_device_id megasas_pci_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CUTLASS_53)},
 	/* VENTURA */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VENTURA)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CRUSADER)},
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_HARPOON)},
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_TOMCAT)},
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VENTURA_4PORT)},
@@ -5980,29 +5981,35 @@ megasas_set_dma_mask(struct pci_dev *pdev)
  */
 static inline void megasas_set_adapter_type(struct megasas_instance *instance)
 {
-	switch (instance->pdev->device) {
-	case PCI_DEVICE_ID_LSI_VENTURA:
-	case PCI_DEVICE_ID_LSI_HARPOON:
-	case PCI_DEVICE_ID_LSI_TOMCAT:
-	case PCI_DEVICE_ID_LSI_VENTURA_4PORT:
-	case PCI_DEVICE_ID_LSI_CRUSADER_4PORT:
-		instance->adapter_type = VENTURA_SERIES;
-		break;
-	case PCI_DEVICE_ID_LSI_FUSION:
-	case PCI_DEVICE_ID_LSI_PLASMA:
-		instance->adapter_type = THUNDERBOLT_SERIES;
-		break;
-	case PCI_DEVICE_ID_LSI_INVADER:
-	case PCI_DEVICE_ID_LSI_INTRUDER:
-	case PCI_DEVICE_ID_LSI_INTRUDER_24:
-	case PCI_DEVICE_ID_LSI_CUTLASS_52:
-	case PCI_DEVICE_ID_LSI_CUTLASS_53:
-	case PCI_DEVICE_ID_LSI_FURY:
-		instance->adapter_type = INVADER_SERIES;
-		break;
-	default: /* For all other supported controllers */
+	if ((instance->pdev->vendor == PCI_VENDOR_ID_DELL) &&
+	    (instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5)) {
 		instance->adapter_type = MFI_SERIES;
-		break;
+	} else {
+		switch (instance->pdev->device) {
+		case PCI_DEVICE_ID_LSI_VENTURA:
+		case PCI_DEVICE_ID_LSI_CRUSADER:
+		case PCI_DEVICE_ID_LSI_HARPOON:
+		case PCI_DEVICE_ID_LSI_TOMCAT:
+		case PCI_DEVICE_ID_LSI_VENTURA_4PORT:
+		case PCI_DEVICE_ID_LSI_CRUSADER_4PORT:
+			instance->adapter_type = VENTURA_SERIES;
+			break;
+		case PCI_DEVICE_ID_LSI_FUSION:
+		case PCI_DEVICE_ID_LSI_PLASMA:
+			instance->adapter_type = THUNDERBOLT_SERIES;
+			break;
+		case PCI_DEVICE_ID_LSI_INVADER:
+		case PCI_DEVICE_ID_LSI_INTRUDER:
+		case PCI_DEVICE_ID_LSI_INTRUDER_24:
+		case PCI_DEVICE_ID_LSI_CUTLASS_52:
+		case PCI_DEVICE_ID_LSI_CUTLASS_53:
+		case PCI_DEVICE_ID_LSI_FURY:
+			instance->adapter_type = INVADER_SERIES;
+			break;
+		default: /* For all other supported controllers */
+			instance->adapter_type = MFI_SERIES;
+			break;
+		}
 	}
 }
 
-- 
2.14.1.dirty
