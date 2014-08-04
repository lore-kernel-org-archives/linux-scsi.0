From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 6/18] arcmsr: precise checking adapter ID
Date: Mon, 04 Aug 2014 16:55:12 +0800
Message-ID: <1407142512.4756.54.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch rewrites the arcmsr_define_adapter_type function to precisely check Areca adapter's ID.
This can prevent an unknown adapter being used as a default adapter type by driver.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

Thanks for Christoph advice.


diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-01 18:02:08.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-04 16:43:16.000000000 +0800
@@ -295,24 +295,43 @@ static int arcmsr_bios_param(struct scsi
 	return 0;
 }
 
-static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
+static int arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
 {
 	struct pci_dev *pdev = acb->pdev;
 	u16 dev_id;
-	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
+
+	dev_id = pdev->device;
 	acb->dev_id = dev_id;
 	switch (dev_id) {
-	case 0x1880: {
+	case 0x1880:
 		acb->adapter_type = ACB_ADAPTER_TYPE_C;
-		}
 		break;
-	case 0x1201: {
+	case 0x1200:
+	case 0x1201:
+	case 0x1202:
 		acb->adapter_type = ACB_ADAPTER_TYPE_B;
-		}
 		break;
-
-	default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
+	case 0x1110:
+	case 0x1120:
+	case 0x1130:
+	case 0x1160:
+	case 0x1170:
+	case 0x1210:
+	case 0x1220:
+	case 0x1230:
+	case 0x1260:
+	case 0x1270:
+	case 0x1280:
+	case 0x1380:
+	case 0x1381:
+	case 0x1680:
+		acb->adapter_type = ACB_ADAPTER_TYPE_A;
+		break;
+	default:
+		pr_notice("Unknown device ID = 0x%x\n", dev_id);
+		return false;
 	}
+	return true;
 }
 
 static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
@@ -710,7 +729,9 @@ static int arcmsr_probe(struct pci_dev *
 			ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-	arcmsr_define_adapter_type(acb);
+	error = arcmsr_define_adapter_type(acb);
+	if (!error)
+		goto pci_release_regs;
 	error = arcmsr_remap_pciregion(acb);
 	if(!error){
 		goto pci_release_regs;
