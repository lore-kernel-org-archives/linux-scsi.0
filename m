From: John Garry <john.garry@huawei.com>
Subject: [PATCH 17/19] scsi: hisi_sas: remove phy_down_v3_hw() res variable
Date: Fri, 11 Aug 2017 00:09:42 +0800
Message-ID: <1502381384-219889-18-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Variable res only holds value 0, so remove it.

This cleans up a coccicheck warning.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8e4bfad..3620a3e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1200,7 +1200,6 @@ static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 static int phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
-	int res = 0;
 	u32 phy_state, sl_ctrl, txid_auto;
 	struct device *dev = hisi_hba->dev;
 
@@ -1221,7 +1220,7 @@ static int phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, CHL_INT0_NOT_RDY_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 0);
 
-	return res;
+	return 0;
 }
 
 static void phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
-- 
1.9.1
