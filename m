From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 6/17] arcmsr: precise checking adapter ID
Date: Tue, 19 Aug 2014 14:55:57 +0800
Message-ID: <1408431357.4748.41.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51665 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaHSG4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 02:56:06 -0400
Received: by mail-pa0-f54.google.com with SMTP id fa1so9312739pad.41
        for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2014 23:56:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

change since v2:
1. This patch pre-define the adapter->type in private data of struct pci_device_id.
2. Remove arcmsr_define_adapter_type function.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-08 19:36:00.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:36:38.000000000 +0800
@@ -144,25 +144,25 @@ static struct scsi_host_template arcmsr_
 	.no_write_same		= 1,
 };
 static struct pci_device_id arcmsr_device_id_table[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1130)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1160)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1170)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1200)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1130), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1160), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1170), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1200), .driver_data = ACB_ADAPTER_TYPE_B,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201), .driver_data = ACB_ADAPTER_TYPE_B,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202), .driver_data = ACB_ADAPTER_TYPE_B,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681), .driver_data = ACB_ADAPTER_TYPE_A,},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880), .driver_data = ACB_ADAPTER_TYPE_C,},
 	{0, 0}, /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
@@ -295,26 +295,6 @@ static int arcmsr_bios_param(struct scsi
 	return 0;
 }
 
-static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
-{
-	struct pci_dev *pdev = acb->pdev;
-	u16 dev_id;
-	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
-	acb->dev_id = dev_id;
-	switch (dev_id) {
-	case 0x1880: {
-		acb->adapter_type = ACB_ADAPTER_TYPE_C;
-		}
-		break;
-	case 0x1201: {
-		acb->adapter_type = ACB_ADAPTER_TYPE_B;
-		}
-		break;
-
-	default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
-	}
-}
-
 static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -710,7 +690,7 @@ static int arcmsr_probe(struct pci_dev *
 			ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-	arcmsr_define_adapter_type(acb);
+	acb->adapter_type = id->driver_data;
 	error = arcmsr_remap_pciregion(acb);
 	if(!error){
 		goto pci_release_regs;


