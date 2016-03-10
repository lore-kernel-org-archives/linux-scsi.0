From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH] megaraid_sas: Don't issue kill adapter for MFI controllers in case of PD list DCMD failure
Date: Thu, 10 Mar 2016 02:14:37 -0800
Message-ID: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35460 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbcCJKPS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 05:15:18 -0500
Received: by mail-pf0-f180.google.com with SMTP id n5so27253916pfn.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 02:15:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, jbottomley@parallels.com, martin.petersen@oracle.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>

There are few MFI adapters which do not support MR_DCMD_PD_LIST_QUERY so
if MFI adapters fail this DCMD, it should not be considered as FATAL and
driver should not issue kill adapter and set per controller's instance
variable- pd_list_not_supported so that same variable can be used inside
functions- slave_alloc and slave_configure to allow firmware scan.

Killing adapter because of DCMD failure when this DCMD is not supported
causes driver's probe getting failed. This issue got introduced because
of below commit when MFI IO timeout handling was introduced-

6d40afb megaraid_sas: MFI IO timeout handling

Killing adapter in case of this DCMD failure should be limited to Fusion
adapters only. Per controller's instance variable allow_fw_scan is removed
as pd_list_not_supported better reflect the purpose.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 14 ++++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 4484e63..fce414a 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2097,7 +2097,7 @@ struct megasas_instance {
 	u8 UnevenSpanSupport;
 
 	u8 supportmax256vd;
-	u8 allow_fw_scan;
+	u8 pd_list_not_supported;
 	u16 fw_supported_vd_count;
 	u16 fw_supported_pd_count;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5c08568..69d375b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1838,7 +1838,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	struct megasas_instance *instance;
 
 	instance = megasas_lookup_instance(sdev->host->host_no);
-	if (instance->allow_fw_scan) {
+	if (instance->pd_list_not_supported) {
 		if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
 			sdev->type == TYPE_DISK) {
 			pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
@@ -1874,7 +1874,8 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 		pd_index =
 			(sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 			sdev->id;
-		if ((instance->allow_fw_scan || instance->pd_list[pd_index].driveState ==
+		if ((instance->pd_list_not_supported ||
+			instance->pd_list[pd_index].driveState ==
 			MR_PD_STATE_SYSTEM)) {
 			goto scan_target;
 		}
@@ -4087,7 +4088,13 @@ megasas_get_pd_list(struct megasas_instance *instance)
 
 	switch (ret) {
 	case DCMD_FAILED:
-		megaraid_sas_kill_hba(instance);
+		dev_info(&instance->pdev->dev, "MR_DCMD_PD_LIST_QUERY "
+			"failed/not supported by firmware\n");
+
+		if (instance->ctrl_context)
+			megaraid_sas_kill_hba(instance);
+		else
+			instance->pd_list_not_supported = 1;
 		break;
 	case DCMD_TIMEOUT:
 
@@ -5034,7 +5041,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	case PCI_DEVICE_ID_DELL_PERC5:
 	default:
 		instance->instancet = &megasas_instance_template_xscale;
-		instance->allow_fw_scan = 1;
 		break;
 	}
 
-- 
2.4.3

