From: sumit.saxena@avagotech.com
Subject: PATCH 03/12] megaraid_sas : Support for Intruder(12 Gbps)
 controller
Date: Thu, 15 Oct 2015 13:39:44 +0530
Message-ID: <201510150817.t9F8H2lv029611@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rndsmtp2.avagotech.com ([199.3.246.48]:42987 "EHLO
	rndsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbJOIUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    9 +++++++++
 drivers/scsi/megaraid/megaraid_sas_base.c |    8 ++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index fc58ba3..7b651c1 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -52,6 +52,8 @@
 #define PCI_DEVICE_ID_LSI_PLASMA		0x002f
 #define PCI_DEVICE_ID_LSI_INVADER		0x005d
 #define PCI_DEVICE_ID_LSI_FURY			0x005f
+#define PCI_DEVICE_ID_LSI_INTRUDER		0x00ce
+#define PCI_DEVICE_ID_LSI_INTRUDER_24		0x00cf
 
 /*
  * Intel HBA SSDIDs
@@ -64,6 +66,13 @@
 #define MEGARAID_INTEL_RS3WC040_SSDID		0x9343
 
 /*
+ * Intruder HBA SSDIDs
+ */
+#define MEGARAID_INTRUDER_SSDID1		0x9371
+#define MEGARAID_INTRUDER_SSDID2		0x9390
+#define MEGARAID_INTRUDER_SSDID3		0x9370
+
+/*
  * Intel HBA branding
  */
 #define MEGARAID_INTEL_RS3DC080_BRANDING	\
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index bc2bb13..b68c318 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -135,6 +135,10 @@ static struct pci_device_id megasas_pci_table[] = {
 	/* Invader */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FURY)},
 	/* Fury */
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_INTRUDER)},
+	/* Intruder */
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_INTRUDER_24)},
+	/* Intruder 24 port*/
 	{}
 };
 
@@ -4629,6 +4633,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	case PCI_DEVICE_ID_LSI_PLASMA:
 	case PCI_DEVICE_ID_LSI_INVADER:
 	case PCI_DEVICE_ID_LSI_FURY:
+	case PCI_DEVICE_ID_LSI_INTRUDER:
+	case PCI_DEVICE_ID_LSI_INTRUDER_24:
 		instance->instancet = &megasas_instance_template_fusion;
 		break;
 	case PCI_DEVICE_ID_LSI_SAS1078R:
@@ -5324,6 +5330,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	case PCI_DEVICE_ID_LSI_PLASMA:
 	case PCI_DEVICE_ID_LSI_INVADER:
 	case PCI_DEVICE_ID_LSI_FURY:
+	case PCI_DEVICE_ID_LSI_INTRUDER:
+	case PCI_DEVICE_ID_LSI_INTRUDER_24:
 	{
 		instance->ctrl_context_pages =
 			get_order(sizeof(struct fusion_context));
-- 
1.7.1

