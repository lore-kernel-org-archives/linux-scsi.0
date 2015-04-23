From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 5/18] megaraid_sas : Enhanced few prints
Date: Thu, 23 Apr 2015 16:31:09 +0530
Message-ID: <201504231103.t3NB3PsF029726@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:35136
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964794AbbDWLBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:01:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will update few prints. 

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   49 ++++++++++++++---------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index dee61e8..3e8b8b3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4091,12 +4091,11 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		instance->fw_supported_vd_count = MAX_LOGICAL_DRIVES;
 		instance->fw_supported_pd_count = MAX_PHYSICAL_DEVICES;
 	}
-	dev_info(&instance->pdev->dev, "Firmware supports %d VD %d PD\n",
-		instance->fw_supported_vd_count,
-		instance->fw_supported_pd_count);
-	dev_info(&instance->pdev->dev, "Driver supports %d VD  %d PD\n",
-		instance->drv_supported_vd_count,
-		instance->drv_supported_pd_count);
+
+	dev_info(&instance->pdev->dev,
+		"firmware type\t: %s\n",
+		instance->supportmax256vd ? "Extended VD(240 VD)firmware" :
+		"Legacy(64 VD) firmware");
 
 	old_map_sz =  sizeof(struct MR_FW_RAID_MAP) +
 				(sizeof(struct MR_LD_SPAN_MAP) *
@@ -4750,9 +4749,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		ctrl_info->adapterOperations2.supportUnevenSpans;
 	if (instance->UnevenSpanSupport) {
 		struct fusion_context *fusion = instance->ctrl_context;
-
-		dev_info(&instance->pdev->dev, "FW supports: "
-		"UnevenSpanSupport=%x\n", instance->UnevenSpanSupport);
 		if (MR_ValidateMapInfo(instance))
 			fusion->fast_path_io = 1;
 		else
@@ -4779,13 +4775,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->crash_dump_drv_support =
 		(instance->crash_dump_fw_support &&
 		instance->crash_dump_buf);
-	if (instance->crash_dump_drv_support) {
-		dev_info(&instance->pdev->dev, "Firmware Crash dump "
-			"feature is supported\n");
+	if (instance->crash_dump_drv_support)
 		megasas_set_crash_dump_params(instance,
 			MR_CRASH_BUF_TURN_OFF);
 
-	} else {
+	else {
 		if (instance->crash_dump_buf)
 			pci_free_consistent(instance->pdev,
 				CRASH_DMA_BUF_SIZE,
@@ -4796,8 +4790,23 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	instance->secure_jbod_support =
 		ctrl_info->adapterOperations3.supportSecurityonJBOD;
-	if (instance->secure_jbod_support)
-		dev_info(&instance->pdev->dev, "Firmware supports Secure JBOD\n");
+
+	dev_info(&instance->pdev->dev,
+		"pci id\t\t: (0x%04x)/(0x%04x)/(0x%04x)/(0x%04x)\n",
+		le16_to_cpu(ctrl_info->pci.vendor_id),
+		le16_to_cpu(ctrl_info->pci.device_id),
+		le16_to_cpu(ctrl_info->pci.sub_vendor_id),
+		le16_to_cpu(ctrl_info->pci.sub_device_id));
+	dev_info(&instance->pdev->dev, "unevenspan support	: %s\n",
+		instance->UnevenSpanSupport ? "yes" : "no");
+	dev_info(&instance->pdev->dev, "disable ocr		: %s\n",
+		instance->disableOnlineCtrlReset ? "yes" : "no");
+	dev_info(&instance->pdev->dev, "firmware crash dump	: %s\n",
+		instance->crash_dump_drv_support ? "yes" : "no");
+	dev_info(&instance->pdev->dev, "secure jbod		: %s\n",
+		instance->secure_jbod_support ? "yes" : "no");
+
+
 	instance->max_sectors_per_req = instance->max_num_sge *
 						PAGE_SIZE / 512;
 	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
@@ -5234,16 +5243,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	}
 
 	/*
-	 * Announce PCI information
-	 */
-	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
-	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
-	       pdev->subsystem_device);
-
-	printk("bus %d:slot %d:func %d\n",
-	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
-
-	/*
 	 * PCI prepping: enable device set bus mastering and dma mask
 	 */
 	rval = pci_enable_device_mem(pdev);
-- 
1.7.1

