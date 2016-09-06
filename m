From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/15] hisi_sas: remove init_id_frame_v1_hw()
Date: Tue, 6 Sep 2016 23:36:23 +0800
Message-ID: <1473176185-217808-14-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Function config_id_frame_v1_hw() is called twice for
each PHY during initialisation, which is unneeded.

So remove init_id_frame_v1_hw(), which only calls
config_id_frame_v1_hw().

We will keep the call to config_id_frame_v1_hw()
in start_phy_v1_hw() since it will be used for
PHY reset functions.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index c030df0..c0ac49d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -501,14 +501,6 @@ static void config_id_frame_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 			__swab32(identify_buffer[5]));
 }
 
-static void init_id_frame_v1_hw(struct hisi_hba *hisi_hba)
-{
-	int i;
-
-	for (i = 0; i < hisi_hba->n_phy; i++)
-		config_id_frame_v1_hw(hisi_hba, i);
-}
-
 static void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_device *sas_dev)
 {
@@ -774,8 +766,6 @@ static int hw_init_v1_hw(struct hisi_hba *hisi_hba)
 	msleep(100);
 	init_reg_v1_hw(hisi_hba);
 
-	init_id_frame_v1_hw(hisi_hba);
-
 	return 0;
 }
 
-- 
1.9.1
