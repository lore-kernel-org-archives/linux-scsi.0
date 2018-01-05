From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 08/14] megaraid_sas: Use megasas_wait_for_adapter_operational to detect controller state in IOCTL path
Date: Fri,  5 Jan 2018 05:27:43 -0800
Message-ID: <1515158869-26693-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38317 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbeAEN33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:29 -0500
Received: by mail-pf0-f194.google.com with SMTP id u25so2181005pfg.5
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:29 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

In IOCTL path, re-use megasas_wait_for_adapter_operational API to detect
controller state. This will make driver to use this API uniformly in all cases
where we need to wait for adapter to become operational.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 60 ++-----------------------------
 1 file changed, 2 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5ab343d386f9..34d1fb75285a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7305,9 +7305,6 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	struct megasas_iocpacket *ioc;
 	struct megasas_instance *instance;
 	int error;
-	int i;
-	unsigned long flags;
-	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	ioc = memdup_user(user_ioc, sizeof(*ioc));
 	if (IS_ERR(ioc))
@@ -7319,10 +7316,6 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		goto out_kfree_ioc;
 	}
 
-	/* Adjust ioctl wait time for VF mode */
-	if (instance->requestorId)
-		wait_time = MEGASAS_ROUTINE_WAIT_TIME_VF;
-
 	/* Block ioctls in VF mode */
 	if (instance->requestorId && !allow_vf_ioctls) {
 		error = -ENODEV;
@@ -7345,32 +7338,10 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		goto out_kfree_ioc;
 	}
 
-	for (i = 0; i < wait_time; i++) {
-
-		spin_lock_irqsave(&instance->hba_lock, flags);
-		if (atomic_read(&instance->adprecovery) == MEGASAS_HBA_OPERATIONAL) {
-			spin_unlock_irqrestore(&instance->hba_lock, flags);
-			break;
-		}
-		spin_unlock_irqrestore(&instance->hba_lock, flags);
-
-		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			dev_notice(&instance->pdev->dev, "waiting"
-				"for controller reset to finish\n");
-		}
-
-		msleep(1000);
-	}
-
-	spin_lock_irqsave(&instance->hba_lock, flags);
-	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
-		spin_unlock_irqrestore(&instance->hba_lock, flags);
-
-		dev_err(&instance->pdev->dev, "timed out while waiting for HBA to recover\n");
+	if  (megasas_wait_for_adapter_operational(instance)) {
 		error = -ENODEV;
 		goto out_up;
 	}
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
 out_up:
@@ -7386,9 +7357,6 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	struct megasas_instance *instance;
 	struct megasas_aen aen;
 	int error;
-	int i;
-	unsigned long flags;
-	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	if (file->private_data != file) {
 		printk(KERN_DEBUG "megasas: fasync_helper was not "
@@ -7412,32 +7380,8 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 		return -ENODEV;
 	}
 
-	for (i = 0; i < wait_time; i++) {
-
-		spin_lock_irqsave(&instance->hba_lock, flags);
-		if (atomic_read(&instance->adprecovery) == MEGASAS_HBA_OPERATIONAL) {
-			spin_unlock_irqrestore(&instance->hba_lock,
-						flags);
-			break;
-		}
-
-		spin_unlock_irqrestore(&instance->hba_lock, flags);
-
-		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			dev_notice(&instance->pdev->dev, "waiting for"
-				"controller reset to finish\n");
-		}
-
-		msleep(1000);
-	}
-
-	spin_lock_irqsave(&instance->hba_lock, flags);
-	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
-		spin_unlock_irqrestore(&instance->hba_lock, flags);
-		dev_err(&instance->pdev->dev, "timed out while waiting for HBA to recover\n");
+	if  (megasas_wait_for_adapter_operational(instance))
 		return -ENODEV;
-	}
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	mutex_lock(&instance->reset_mutex);
 	error = megasas_register_aen(instance, aen.seq_num,
-- 
2.14.1
