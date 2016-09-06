From: John Garry <john.garry@huawei.com>
Subject: [PATCH 04/15] hisi_sas: only zero slot memory when reused
Date: Tue, 6 Sep 2016 23:36:14 +0800
Message-ID: <1473176185-217808-5-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently the slot memory is zeroed when it is
freed and also when it is reused, like in
hisi_sas_task_prep(). Optimise by avoiding the
redundant zeroing in the free.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5d56576..0e48751 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -97,7 +97,7 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 	slot->task = NULL;
 	slot->port = NULL;
 	hisi_sas_slot_index_free(hisi_hba, slot->idx);
-	memset(slot, 0, sizeof(*slot));
+	/* slot memory is fully zeroed when it is reused */
 }
 EXPORT_SYMBOL_GPL(hisi_sas_slot_task_free);
 
-- 
1.9.1
