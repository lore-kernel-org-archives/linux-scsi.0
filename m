From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 07/14] megaraid_sas: Avoid firing DCMDs while OCR is in progress
Date: Fri,  5 Jan 2018 05:27:42 -0800
Message-ID: <1515158869-26693-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37873 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbeAEN31 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:27 -0500
Received: by mail-pf0-f194.google.com with SMTP id n6so2183671pfa.4
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:27 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Driver needs to avoid PCI writes while OCR is in progress.
Use reset_mutex to synchronize between firing DCMDs MR_DCMD_PD_GET_INFO and
MR_DCMD_DRV_GET_TARGET_PROP while OCR is triggered.
Without this fix, if Device/VD add/creation is in progress and at the same
time MR Firmware is going through OCR, user may see OCR never completed and
it may need system reboot.
This scenario is rare to occur. Fix is provided as part of review.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 1 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index f5a36ccb8606..0a66935ddf33 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2188,7 +2188,6 @@ struct megasas_instance {
 	struct megasas_evt_detail *evt_detail;
 	dma_addr_t evt_detail_h;
 	struct megasas_cmd *aen_cmd;
-	struct mutex hba_mutex;
 	struct semaphore ioctl_sem;
 
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8a0776d6c6fa..5ab343d386f9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1952,7 +1952,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 		}
 	}
 
-	mutex_lock(&instance->hba_mutex);
+	mutex_lock(&instance->reset_mutex);
 	/* Send DCMD to Firmware and cache the information */
 	if ((instance->pd_info) && !MEGASAS_IS_LOGICAL(sdev))
 		megasas_get_pd_info(instance, sdev);
@@ -1966,7 +1966,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
 	megasas_set_static_target_properties(sdev, is_target_prop);
 
-	mutex_unlock(&instance->hba_mutex);
+	mutex_unlock(&instance->reset_mutex);
 
 	/* This sdev property may change post OCR */
 	megasas_set_dynamic_target_properties(sdev);
@@ -6350,7 +6350,6 @@ static inline void megasas_init_ctrl_params(struct megasas_instance *instance)
 	spin_lock_init(&instance->stream_lock);
 	spin_lock_init(&instance->completion_lock);
 
-	mutex_init(&instance->hba_mutex);
 	mutex_init(&instance->reset_mutex);
 
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-- 
2.14.1
