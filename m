Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB36C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E72764F60
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhBCIWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:22:23 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:57999 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232493AbhBCIWW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 03:22:22 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UNkcr5h_1612340378;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNkcr5h_1612340378)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 16:19:43 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     sathya.prakash@broadcom.com
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: mpt3sas: convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Wed,  3 Feb 2021 16:19:36 +0800
Message-Id: <1612340376-1549-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/ufs/ufshcd.c: WARNING: use scnprintf or sprintf.

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 71 ++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index c8a0ce1..1371831 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2746,11 +2746,11 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
-	    (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
-	    (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
-	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
-	    ioc->facts.FWVersion.Word & 0x000000FF);
+	return sysfs_emit(buf, "%02d.%02d.%02d.%02d\n",
+			  (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
+			  (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
+			  (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
+			  ioc->facts.FWVersion.Word & 0x000000FF);
 }
 static DEVICE_ATTR_RO(version_fw);
 
@@ -2771,11 +2771,11 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 
 	u32 version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
-	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
-	    (version & 0xFF000000) >> 24,
-	    (version & 0x00FF0000) >> 16,
-	    (version & 0x0000FF00) >> 8,
-	    version & 0x000000FF);
+	return sysfs_emit(buf, "%02d.%02d.%02d.%02d\n",
+			  (version & 0xFF000000) >> 24,
+			  (version & 0x00FF0000) >> 16,
+			  (version & 0x0000FF00) >> 8,
+			   version & 0x000000FF);
 }
 static DEVICE_ATTR_RO(version_bios);
 
@@ -2794,8 +2794,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%03x.%02x\n",
-	    ioc->facts.MsgVersion, ioc->facts.HeaderVersion >> 8);
+	return sysfs_emit(buf, "%03x.%02x\n", ioc->facts.MsgVersion, ioc->facts.HeaderVersion >> 8);
 }
 static DEVICE_ATTR_RO(version_mpi);
 
@@ -2833,8 +2832,8 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%08xh\n",
-	    le32_to_cpu(ioc->iounit_pg0.NvdataVersionPersistent.Word));
+	return sysfs_emit(buf, "%08xh\n",
+			  le32_to_cpu(ioc->iounit_pg0.NvdataVersionPersistent.Word));
 }
 static DEVICE_ATTR_RO(version_nvdata_persistent);
 
@@ -2853,8 +2852,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%08xh\n",
-	    le32_to_cpu(ioc->iounit_pg0.NvdataVersionDefault.Word));
+	return sysfs_emit(buf, "%08xh\n", le32_to_cpu(ioc->iounit_pg0.NvdataVersionDefault.Word));
 }
 static DEVICE_ATTR_RO(version_nvdata_default);
 
@@ -2933,7 +2931,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->io_missing_delay);
+	return sysfs_emit(buf, "%02d\n", ioc->io_missing_delay);
 }
 static DEVICE_ATTR_RO(io_delay);
 
@@ -2955,7 +2953,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->device_missing_delay);
+	return sysfs_emit(buf, "%02d\n", ioc->device_missing_delay);
 }
 static DEVICE_ATTR_RO(device_delay);
 
@@ -2976,7 +2974,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->facts.RequestCredit);
+	return sysfs_emit(buf, "%02d\n", ioc->facts.RequestCredit);
 }
 static DEVICE_ATTR_RO(fw_queue_depth);
 
@@ -2998,8 +2996,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
-	    (unsigned long long)ioc->sas_hba.sas_address);
+	return sysfs_emit(buf, "0x%016llx\n", (unsigned long long)ioc->sas_hba.sas_address);
 }
 static DEVICE_ATTR_RO(host_sas_address);
 
@@ -3018,7 +3015,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%08xh\n", ioc->logging_level);
+	return sysfs_emit(buf, "%08xh\n", ioc->logging_level);
 }
 static ssize_t
 logging_level_store(struct device *cdev, struct device_attribute *attr,
@@ -3054,7 +3051,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc->fwfault_debug);
+	return sysfs_emit(buf, "%d\n", ioc->fwfault_debug);
 }
 static ssize_t
 fwfault_debug_store(struct device *cdev, struct device_attribute *attr,
@@ -3091,7 +3088,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc->ioc_reset_count);
+	return sysfs_emit(buf, "%d\n", ioc->ioc_reset_count);
 }
 static DEVICE_ATTR_RO(ioc_reset_count);
 
@@ -3119,7 +3116,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	else
 		reply_queue_count = 1;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", reply_queue_count);
+	return sysfs_emit(buf, "%d\n", reply_queue_count);
 }
 static DEVICE_ATTR_RO(reply_queue_count);
 
@@ -3191,7 +3188,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 
 	/* BRM status is in bit zero of GPIOVal[24] */
 	backup_rail_monitor_status = le16_to_cpu(io_unit_pg3->GPIOVal[24]);
-	rc = snprintf(buf, PAGE_SIZE, "%d\n", (backup_rail_monitor_status & 1));
+	rc = sysfs_emit(buf, "%d\n", (backup_rail_monitor_status & 1));
 
  out:
 	kfree(io_unit_pg3);
@@ -3249,7 +3246,7 @@ struct DIAG_BUFFER_START {
 		size = le32_to_cpu(request_data->Size);
 
 	ioc->ring_buffer_sz = size;
-	return snprintf(buf, PAGE_SIZE, "%d\n", size);
+	return sysfs_emit(buf, "%d\n", size);
 }
 static DEVICE_ATTR_RO(host_trace_buffer_size);
 
@@ -3336,12 +3333,12 @@ struct DIAG_BUFFER_START {
 	if ((!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) ||
 	   ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0))
-		return snprintf(buf, PAGE_SIZE, "off\n");
+		return sysfs_emit(buf, "off\n");
 	else if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED))
-		return snprintf(buf, PAGE_SIZE, "release\n");
+		return sysfs_emit(buf, "release\n");
 	else
-		return snprintf(buf, PAGE_SIZE, "post\n");
+		return sysfs_emit(buf, "post\n");
 }
 
 static ssize_t
@@ -3677,7 +3674,7 @@ struct DIAG_BUFFER_START {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "0x%08x\n", ioc->drv_support_bitmap);
+	return sysfs_emit(buf, "0x%08x\n", ioc->drv_support_bitmap);
 }
 static DEVICE_ATTR_RO(drv_support_bitmap);
 
@@ -3697,7 +3694,7 @@ struct DIAG_BUFFER_START {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc->enable_sdev_max_qd);
+	return sysfs_emit(buf, "%d\n", ioc->enable_sdev_max_qd);
 }
 
 /**
@@ -3835,8 +3832,8 @@ struct device_attribute *mpt3sas_host_attrs[] = {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
-	    (unsigned long long)sas_device_priv_data->sas_target->sas_address);
+	return sysfs_emit(buf, "0x%016llx\n",
+			  (unsigned long long)sas_device_priv_data->sas_target->sas_address);
 }
 static DEVICE_ATTR_RO(sas_address);
 
@@ -3857,8 +3854,7 @@ struct device_attribute *mpt3sas_host_attrs[] = {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "0x%04x\n",
-	    sas_device_priv_data->sas_target->handle);
+	return sysfs_emit(buf, "0x%04x\n", sas_device_priv_data->sas_target->handle);
 }
 static DEVICE_ATTR_RO(sas_device_handle);
 
@@ -3877,8 +3873,7 @@ struct device_attribute *mpt3sas_host_attrs[] = {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-			sas_device_priv_data->ncq_prio_enable);
+	return sysfs_emit(buf, "%d\n", sas_device_priv_data->ncq_prio_enable);
 }
 
 static ssize_t
-- 
1.8.3.1

