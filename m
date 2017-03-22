From: John Garry <john.garry@huawei.com>
Subject: [PATCH 16/23] scsi: hisi_sas: some modifications to v2 hw reg init values
Date: Thu, 23 Mar 2017 01:25:32 +0800
Message-ID: <1490203539-228029-17-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>, Zhao Nenglong <zhaonenglong@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

This patch includes:
(1) Disable transport layer retry
(2) Support CQ time and count interrupt coal
(3) fix link FIFO full issue

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Zhao Nenglong <zhaonenglong@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 66a458b..8e869d9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -893,7 +893,7 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
 	hisi_sas_write32(hisi_hba, AXI_USER1, 0xc0000000);
 	hisi_sas_write32(hisi_hba, AXI_USER2, 0x10000);
-	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
+	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x0);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TX_OPEN_FAIL_RETRY_CTRL, 0x7FF);
 	hisi_sas_write32(hisi_hba, OPENA_WT_CONTI_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, I_T_NEXUS_LOSS_TIME, 0x1F4);
@@ -902,9 +902,9 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, HGC_ERR_STAT_EN, 0x1);
 	hisi_sas_write32(hisi_hba, HGC_GET_ITV_TIME, 0x1);
-	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
-	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x1);
-	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x1);
+	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0xc);
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x60);
+	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x3);
 	hisi_sas_write32(hisi_hba, ENT_INT_COAL_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, ENT_INT_COAL_CNT, 0x1);
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 0x0);
@@ -927,14 +927,14 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, SL_TOUT_CFG, 0x7d7d7d7d);
 		hisi_sas_phy_write32(hisi_hba, i, SL_CONTROL, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, TXID_AUTO, 0x2);
-		hisi_sas_phy_write32(hisi_hba, i, DONE_RECEIVED_TIME, 0x10);
+		hisi_sas_phy_write32(hisi_hba, i, DONE_RECEIVED_TIME, 0x8);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2, 0xfff87fff);
 		hisi_sas_phy_write32(hisi_hba, i, RXOP_CHECK_CFG_H, 0x1000);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1_MSK, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x8ffffbff);
-		hisi_sas_phy_write32(hisi_hba, i, SL_CFG, 0x23f801fc);
+		hisi_sas_phy_write32(hisi_hba, i, SL_CFG, 0x13f801fc);
 		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL_RDY_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_NOT_RDY_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_DWS_RESET_MSK, 0x0);
-- 
1.9.1
