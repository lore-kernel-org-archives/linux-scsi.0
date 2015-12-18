From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 01/15] megaraid_sas: Do not allow PCI access during OCR
Date: Fri, 18 Dec 2015 18:56:54 +0530
Message-ID: <1450445228-26571-2-git-send-email-Sumit.Saxena@avagotech.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:32889 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbLRN1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 08:27:53 -0500
Received: by mail-pf0-f177.google.com with SMTP id n128so31512125pfn.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 05:27:53 -0800 (PST)
In-Reply-To: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will do synhronization between OCR function and AEN function using "reset_mutex" lock.
reset_mutex will be acquire only in first half of the AEN function which issue DCMD. Second half
of the function calls SCSI API (scsi_add_device/scsi_remove_device) should be out of reset_mutex
to avoid deadlock between scsi_eh thread and Driver.

During chip reset(inside OCR function), there should not be any PCI access and AEN function
(which is called in delayed context) may be firirng DCMDs(doing PCI writes) when chip reset is
happening in parallel which will cause FW fault. This patch will solve the problem by making
AEN thread and OCR thread mutually exclusive.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    2 +
 drivers/scsi/megaraid/megaraid_sas_base.c |  254 +++++++++--------------------
 2 files changed, 82 insertions(+), 174 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index c0f7c8c..ef4ff03 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1083,6 +1083,8 @@ struct megasas_ctrl_info {
 
 #define VD_EXT_DEBUG 0
 
+#define SCAN_PD_CHANNEL	0x1
+#define SCAN_VD_CHANNEL	0x2
 
 enum MR_SCSI_CMD_TYPE {
 	READ_WRITE_LDIO = 0,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 97a1c1c..9650487 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5476,7 +5476,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
 
-	mutex_init(&instance->aen_mutex);
 	mutex_init(&instance->reset_mutex);
 
 	/*
@@ -6442,10 +6441,10 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	}
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-	mutex_lock(&instance->aen_mutex);
+	mutex_lock(&instance->reset_mutex);
 	error = megasas_register_aen(instance, aen.seq_num,
 				     aen.class_locale_word);
-	mutex_unlock(&instance->aen_mutex);
+	mutex_unlock(&instance->reset_mutex);
 	return error;
 }
 
@@ -6647,6 +6646,7 @@ megasas_aen_polling(struct work_struct *work)
 	int     i, j, doscan = 0;
 	u32 seq_num, wait_time = MEGASAS_RESET_WAIT_TIME;
 	int error;
+	u8  dcmd_ret = 0;
 
 	if (!instance) {
 		printk(KERN_ERR "invalid instance!\n");
@@ -6659,16 +6659,7 @@ megasas_aen_polling(struct work_struct *work)
 		wait_time = MEGASAS_ROUTINE_WAIT_TIME_VF;
 
 	/* Don't run the event workqueue thread if OCR is running */
-	for (i = 0; i < wait_time; i++) {
-		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL)
-			break;
-		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			dev_notice(&instance->pdev->dev, "%s waiting for "
-			       "controller reset to finish for scsi%d\n",
-			       __func__, instance->host->host_no);
-		}
-		msleep(1000);
-	}
+	mutex_lock(&instance->reset_mutex);
 
 	instance->ev = NULL;
 	host = instance->host;
@@ -6676,212 +6667,127 @@ megasas_aen_polling(struct work_struct *work)
 		megasas_decode_evt(instance);
 
 		switch (le32_to_cpu(instance->evt_detail->code)) {
-		case MR_EVT_PD_INSERTED:
-			if (megasas_get_pd_list(instance) == 0) {
-			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
-				for (j = 0;
-				j < MEGASAS_MAX_DEV_PER_CHANNEL;
-				j++) {
-
-				pd_index =
-				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
-
-				sdev1 = scsi_device_lookup(host, i, j, 0);
-
-				if (instance->pd_list[pd_index].driveState
-						== MR_PD_STATE_SYSTEM) {
-					if (!sdev1)
-						scsi_add_device(host, i, j, 0);
-
-					if (sdev1)
-						scsi_device_put(sdev1);
-					}
-				}
-			}
-			}
-			doscan = 0;
-			break;
 
+		case MR_EVT_PD_INSERTED:
 		case MR_EVT_PD_REMOVED:
-			if (megasas_get_pd_list(instance) == 0) {
-			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
-				for (j = 0;
-				j < MEGASAS_MAX_DEV_PER_CHANNEL;
-				j++) {
-
-				pd_index =
-				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
-
-				sdev1 = scsi_device_lookup(host, i, j, 0);
-
-				if (instance->pd_list[pd_index].driveState
-					== MR_PD_STATE_SYSTEM) {
-					if (sdev1)
-						scsi_device_put(sdev1);
-				} else {
-					if (sdev1) {
-						scsi_remove_device(sdev1);
-						scsi_device_put(sdev1);
-					}
-				}
-				}
-			}
-			}
-			doscan = 0;
+			dcmd_ret = megasas_get_pd_list(instance);
+			if (dcmd_ret == 0)
+				doscan = SCAN_PD_CHANNEL;
 			break;
 
 		case MR_EVT_LD_OFFLINE:
 		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_LD_DELETED:
-			if (!instance->requestorId ||
-			    megasas_get_ld_vf_affiliation(instance, 0)) {
-				if (megasas_ld_list_query(instance,
-							  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
-					megasas_get_ld_list(instance);
-				for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
-					for (j = 0;
-					     j < MEGASAS_MAX_DEV_PER_CHANNEL;
-					     j++) {
-
-						ld_index =
-							(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
-
-						sdev1 = scsi_device_lookup(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
-
-						if (instance->ld_ids[ld_index]
-						    != 0xff) {
-							if (sdev1)
-								scsi_device_put(sdev1);
-						} else {
-							if (sdev1) {
-								scsi_remove_device(sdev1);
-								scsi_device_put(sdev1);
-							}
-						}
-					}
-				}
-				doscan = 0;
-			}
-			break;
 		case MR_EVT_LD_CREATED:
 			if (!instance->requestorId ||
-			    megasas_get_ld_vf_affiliation(instance, 0)) {
-				if (megasas_ld_list_query(instance,
-							  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
-					megasas_get_ld_list(instance);
-				for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
-					for (j = 0;
-					     j < MEGASAS_MAX_DEV_PER_CHANNEL;
-					     j++) {
-						ld_index =
-							(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
-
-						sdev1 = scsi_device_lookup(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
-
-						if (instance->ld_ids[ld_index]
-						    != 0xff) {
-							if (!sdev1)
-								scsi_add_device(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
-						}
-						if (sdev1)
-							scsi_device_put(sdev1);
-					}
-				}
-				doscan = 0;
-			}
+				(instance->requestorId && megasas_get_ld_vf_affiliation(instance, 0)))
+				dcmd_ret = megasas_ld_list_query(instance, MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
+
+			if (dcmd_ret == 0)
+				doscan = SCAN_VD_CHANNEL;
+
 			break;
+
 		case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
 		case MR_EVT_FOREIGN_CFG_IMPORTED:
 		case MR_EVT_LD_STATE_CHANGE:
-			doscan = 1;
+			dcmd_ret = megasas_get_pd_list(instance);
+
+			if (dcmd_ret != 0)
+				break;
+
+			if (!instance->requestorId ||
+				(instance->requestorId && megasas_get_ld_vf_affiliation(instance, 0)))
+				dcmd_ret = megasas_ld_list_query(instance, MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
+
+			if (dcmd_ret != 0)
+				break;
+
+			doscan = SCAN_VD_CHANNEL | SCAN_PD_CHANNEL;
+			dev_info(&instance->pdev->dev, "scanning for scsi%d...\n",
+				instance->host->host_no);
 			break;
+
 		case MR_EVT_CTRL_PROP_CHANGED:
-			megasas_get_ctrl_info(instance);
-			break;
+				dcmd_ret = megasas_get_ctrl_info(instance);
+				break;
 		default:
 			doscan = 0;
 			break;
 		}
 	} else {
 		dev_err(&instance->pdev->dev, "invalid evt_detail!\n");
+		mutex_unlock(&instance->reset_mutex);
 		kfree(ev);
 		return;
 	}
 
-	if (doscan) {
-		dev_info(&instance->pdev->dev, "scanning for scsi%d...\n",
-		       instance->host->host_no);
-		if (megasas_get_pd_list(instance) == 0) {
-			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
-				for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
-					pd_index = i*MEGASAS_MAX_DEV_PER_CHANNEL + j;
-					sdev1 = scsi_device_lookup(host, i, j, 0);
-					if (instance->pd_list[pd_index].driveState ==
-					    MR_PD_STATE_SYSTEM) {
-						if (!sdev1) {
-							scsi_add_device(host, i, j, 0);
-						}
-						if (sdev1)
-							scsi_device_put(sdev1);
-					} else {
-						if (sdev1) {
-							scsi_remove_device(sdev1);
-							scsi_device_put(sdev1);
-						}
+	mutex_unlock(&instance->reset_mutex);
+
+	if (doscan & SCAN_PD_CHANNEL) {
+		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
+			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+				pd_index = i*MEGASAS_MAX_DEV_PER_CHANNEL + j;
+				sdev1 = scsi_device_lookup(host, i, j, 0);
+				if (instance->pd_list[pd_index].driveState ==
+							MR_PD_STATE_SYSTEM) {
+					if (!sdev1)
+						scsi_add_device(host, i, j, 0);
+					else
+						scsi_device_put(sdev1);
+				} else {
+					if (sdev1) {
+						scsi_remove_device(sdev1);
+						scsi_device_put(sdev1);
 					}
 				}
 			}
 		}
+	}
 
-		if (!instance->requestorId ||
-		    megasas_get_ld_vf_affiliation(instance, 0)) {
-			if (megasas_ld_list_query(instance,
-						  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
-				megasas_get_ld_list(instance);
-			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
-				for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL;
-				     j++) {
-					ld_index =
-						(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
-
-					sdev1 = scsi_device_lookup(host,
-								   MEGASAS_MAX_PD_CHANNELS + i, j, 0);
-					if (instance->ld_ids[ld_index]
-					    != 0xff) {
-						if (!sdev1)
-							scsi_add_device(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
-						else
-							scsi_device_put(sdev1);
-					} else {
-						if (sdev1) {
-							scsi_remove_device(sdev1);
-							scsi_device_put(sdev1);
-						}
+	if (doscan & SCAN_VD_CHANNEL) {
+		for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+				ld_index = (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+				sdev1 = scsi_device_lookup(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+				if (instance->ld_ids[ld_index] != 0xff) {
+					if (!sdev1)
+						scsi_add_device(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+					else
+						scsi_device_put(sdev1);
+				} else {
+					if (sdev1) {
+						scsi_remove_device(sdev1);
+						scsi_device_put(sdev1);
 					}
 				}
 			}
 		}
 	}
 
-	if (instance->aen_cmd != NULL) {
-		kfree(ev);
-		return ;
-	}
-
-	seq_num = le32_to_cpu(instance->evt_detail->seq_num) + 1;
+	if (dcmd_ret == 0)
+		seq_num = le32_to_cpu(instance->evt_detail->seq_num) + 1;
+	else
+		seq_num = instance->last_seq_num;
 
 	/* Register AEN with FW for latest sequence number plus 1 */
 	class_locale.members.reserved = 0;
 	class_locale.members.locale = MR_EVT_LOCALE_ALL;
 	class_locale.members.class = MR_EVT_CLASS_DEBUG;
-	mutex_lock(&instance->aen_mutex);
+
+	if (instance->aen_cmd != NULL) {
+		kfree(ev);
+		return;
+	}
+
+	mutex_lock(&instance->reset_mutex);
 	error = megasas_register_aen(instance, seq_num,
 					class_locale.word);
-	mutex_unlock(&instance->aen_mutex);
-
 	if (error)
-		dev_err(&instance->pdev->dev, "register aen failed error %x\n", error);
+		dev_err(&instance->pdev->dev,
+			"register aen failed error %x\n", error);
 
+	mutex_unlock(&instance->reset_mutex);
 	kfree(ev);
 }
 
-- 
1.7.1

