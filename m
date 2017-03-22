From: John Garry <john.garry@huawei.com>
Subject: [PATCH 12/23] scsi: hisi_sas: free slots after hardreset
Date: Thu, 23 Mar 2017 01:25:28 +0800
Message-ID: <1490203539-228029-13-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

After hardreset, we clear up IOs of remote disks, so we
need to free those slots in LLDD.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 19f2892..49cac22 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1028,11 +1028,12 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 
 	rc = hisi_sas_debug_I_T_nexus_reset(device);
 
-	spin_lock_irqsave(&hisi_hba->lock, flags);
-	hisi_sas_release_task(hisi_hba, device);
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
-
-	return 0;
+	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		spin_lock_irqsave(&hisi_hba->lock, flags);
+		hisi_sas_release_task(hisi_hba, device);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	}
+	return rc;
 }
 
 static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
-- 
1.9.1
