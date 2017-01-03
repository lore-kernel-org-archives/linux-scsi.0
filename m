From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/3] scsi: hisi_sas: lock sensitive region in hisi_sas_slot_abort()
Date: Tue, 3 Jan 2017 20:24:50 +0800
Message-ID: <1483446290-185084-4-git-send-email-john.garry@huawei.com>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:49890 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758146AbdACLzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 06:55:50 -0500
In-Reply-To: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org, John Garry <john.garry@huawei.com>

When we call hisi_sas_slot_task_free() we should grab the
hisi_hba.lock, as hisi_sas_slot_task_free() accesses common
hisi_hba elements.
Function hisi_sas_slot_abort() is missing this, so add it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d50e9cf..22dba01 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -146,6 +146,7 @@ static void hisi_sas_slot_abort(struct work_struct *work)
 	struct scsi_lun lun;
 	struct device *dev = &hisi_hba->pdev->dev;
 	int tag = abort_slot->idx;
+	unsigned long flags;
 
 	if (!(task->task_proto & SAS_PROTOCOL_SSP)) {
 		dev_err(dev, "cannot abort slot for non-ssp task\n");
@@ -159,7 +160,9 @@ static void hisi_sas_slot_abort(struct work_struct *work)
 	hisi_sas_debug_issue_ssp_tmf(task->dev, lun.scsi_lun, &tmf_task);
 out:
 	/* Do cleanup for this task */
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	hisi_sas_slot_task_free(hisi_hba, task, abort_slot);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	if (task->task_done)
 		task->task_done(task);
 	if (sas_dev)
-- 
1.9.1

