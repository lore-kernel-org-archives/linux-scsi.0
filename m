From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/6] scsi: hisi_sas: Delete PHYs' timer when rmmod or probe failed
Date: Wed, 29 May 2019 17:58:42 +0800
Message-ID: <1559123927-160502-2-git-send-email-john.garry@huawei.com>
References: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When removing the driver or for when probe fails, we need to delete PHY's
timer.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8a7feb8ed8d6..256f93e6f89f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2480,6 +2480,14 @@ EXPORT_SYMBOL_GPL(hisi_sas_alloc);
 
 void hisi_sas_free(struct hisi_hba *hisi_hba)
 {
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
+
+		del_timer_sync(&phy->timer);
+	}
+
 	if (hisi_hba->wq)
 		destroy_workqueue(hisi_hba->wq);
 }
-- 
2.17.1
