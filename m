From: sumit.saxena@avagotech.com
Subject: [PATCH 06/12] megaraid_sas : Update OCR capability on controller
 properties change
Date: Thu, 15 Oct 2015 13:40:14 +0530
Message-ID: <201510150817.t9F8HWln029636@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.48]:60966 "EHLO
	rndsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbJOIUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    1 +
 drivers/scsi/megaraid/megaraid_sas_base.c |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index fab7602..7c14a20 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -420,6 +420,7 @@ enum MR_LD_QUERY_TYPE {
 #define MR_EVT_FOREIGN_CFG_IMPORTED                     0x00db
 #define MR_EVT_LD_OFFLINE                               0x00fc
 #define MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED             0x0152
+#define MR_EVT_CTRL_PROP_CHANGED			0x012f
 
 enum MR_PD_STATE {
 	MR_PD_STATE_UNCONFIGURED_GOOD   = 0x00,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6204a66..6777504 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4194,6 +4194,10 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 				"controller type\t: %s(%dMB)\n",
 				instance->is_imr ? "iMR" : "MR",
 				le16_to_cpu(ctrl_info->memory_size));
+		instance->disableOnlineCtrlReset =
+			ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
+		dev_info(&instance->pdev->dev, "Online Controller Reset(OCR)\t: %s\n",
+			instance->disableOnlineCtrlReset ? "Disabled" : "Enabled");
 	}
 
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_ctrl_info),
@@ -4799,8 +4803,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	tmp_sectors = min_t(u32, max_sectors_1, max_sectors_2);
 
-	instance->disableOnlineCtrlReset =
-	ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
 	instance->mpio = ctrl_info->adapterOperations2.mpio;
 	instance->UnevenSpanSupport =
 		ctrl_info->adapterOperations2.supportUnevenSpans;
@@ -4860,8 +4862,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		le16_to_cpu(ctrl_info->pci.sub_device_id));
 	dev_info(&instance->pdev->dev, "unevenspan support	: %s\n",
 		instance->UnevenSpanSupport ? "yes" : "no");
-	dev_info(&instance->pdev->dev, "disable ocr		: %s\n",
-		instance->disableOnlineCtrlReset ? "yes" : "no");
 	dev_info(&instance->pdev->dev, "firmware crash dump	: %s\n",
 		instance->crash_dump_drv_support ? "yes" : "no");
 	dev_info(&instance->pdev->dev, "secure jbod		: %s\n",
@@ -6745,6 +6745,9 @@ megasas_aen_polling(struct work_struct *work)
 		case MR_EVT_LD_STATE_CHANGE:
 			doscan = 1;
 			break;
+		case MR_EVT_CTRL_PROP_CHANGED:
+			megasas_get_ctrl_info(instance);
+			break;
 		default:
 			doscan = 0;
 			break;
-- 
1.7.1

