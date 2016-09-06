From: John Garry <john.garry@huawei.com>
Subject: [PATCH 06/15] hisi_sas: disable dlvry queues once at reset for v2 hw
Date: Tue, 6 Sep 2016 23:36:16 +0800
Message-ID: <1473176185-217808-7-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The Delivery queue enable register should only be written
to once at reset for v2 hw.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 25e7c58..aca2b80 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -685,9 +685,7 @@ static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
 	else
 		reset_val = 0x7ffff;
 
-	/* Disable all of the DQ */
-	for (i = 0; i < HISI_SAS_MAX_QUEUES; i++)
-		hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
+	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
 
 	/* Disable all of the PHYs */
 	for (i = 0; i < hisi_hba->n_phy; i++) {
-- 
1.9.1
