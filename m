From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/19] scsi: hisi_sas: use spin_lock_irqsave() for hisi_hba.lock
Date: Tue, 24 Oct 2017 23:51:33 +0800
Message-ID: <1508860309-212397-4-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:50580 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751705AbdJXPF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Oct 2017 11:05:29 -0400
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiaofei Tan <tanxiaofei@huawei.com>

We used spin_lock() to grab hisi_hba.lock in two places
where spin_lock_irqsave() should be used, as
hisi_hba.lock can be taken in interrupt context.

This patch is to fix this.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 5 +++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0eb9174..e038bdf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -505,9 +505,10 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 {
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_device *sas_dev = NULL;
+	unsigned long flags;
 	int i;
 
-	spin_lock(&hisi_hba->lock);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
 		if (hisi_hba->devices[i].dev_type == SAS_PHY_UNUSED) {
 			int queue = i % hisi_hba->queue_count;
@@ -524,7 +525,7 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 			break;
 		}
 	}
-	spin_unlock(&hisi_hba->lock);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 
 	return sas_dev;
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 779af97..73d12ff 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -843,8 +843,9 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = NULL;
 	int i, sata_dev = dev_is_sata(device);
 	int sata_idx = -1;
+	unsigned long flags;
 
-	spin_lock(&hisi_hba->lock);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 
 	if (sata_dev)
 		if (!sata_index_alloc_v2_hw(hisi_hba, &sata_idx))
@@ -874,7 +875,7 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 	}
 
 out:
-	spin_unlock(&hisi_hba->lock);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 
 	return sas_dev;
 }
-- 
1.9.1
