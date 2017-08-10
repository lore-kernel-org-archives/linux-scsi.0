From: John Garry <john.garry@huawei.com>
Subject: [PATCH 14/19] scsi: hisi_sas: update some v3 register init settings
Date: Fri, 11 Aug 2017 00:09:39 +0800
Message-ID: <1502381384-219889-15-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This patch updates some register setting according
to recommendation from HW designer and experiment.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 992ccc2..efc2e82 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -23,14 +23,11 @@
 #define PHY_STATE			0x24
 #define PHY_PORT_NUM_MA			0x28
 #define PHY_CONN_RATE			0x30
-#define AXI_AHB_CLK_CFG			0x3c
 #define ITCT_CLR			0x44
 #define ITCT_CLR_EN_OFF			16
 #define ITCT_CLR_EN_MSK			(0x1 << ITCT_CLR_EN_OFF)
 #define ITCT_DEV_OFF			0
 #define ITCT_DEV_MSK			(0x7ff << ITCT_DEV_OFF)
-#define AXI_USER1			0x48
-#define AXI_USER2			0x4c
 #define IO_SATA_BROKEN_MSG_ADDR_LO	0x58
 #define IO_SATA_BROKEN_MSG_ADDR_HI	0x5c
 #define SATA_INITI_D2H_STORE_ADDR_LO	0x60
@@ -355,8 +352,6 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	/* Global registers init */
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
-	hisi_sas_write32(hisi_hba, AXI_USER1, 0x0);
-	hisi_sas_write32(hisi_hba, AXI_USER2, 0x40000060);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
 	hisi_sas_write32(hisi_hba, CFG_1US_TIMER_TRSH, 0xd);
 	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
@@ -372,15 +367,14 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, CHNL_PHYUPDOWN_INT_MSK, 0x0);
 	hisi_sas_write32(hisi_hba, CHNL_ENT_INT_MSK, 0x0);
 	hisi_sas_write32(hisi_hba, HGC_COM_INT_MSK, 0x0);
-	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, 0xfff00c30);
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, 0x0);
 	hisi_sas_write32(hisi_hba, AWQOS_AWCACHE_CFG, 0xf0f0);
 	hisi_sas_write32(hisi_hba, ARQOS_ARCACHE_CFG, 0xf0f0);
 	for (i = 0; i < hisi_hba->queue_count; i++)
 		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK+0x4*i, 0);
 
-	hisi_sas_write32(hisi_hba, AXI_AHB_CLK_CFG, 1);
 	hisi_sas_write32(hisi_hba, HYPER_STREAM_ID_EN_CFG, 1);
-	hisi_sas_write32(hisi_hba, CFG_MAX_TAG, 0xfff07fff);
+	hisi_sas_write32(hisi_hba, AXI_MASTER_CFG_BASE, 0x30000);
 
 	for (i = 0; i < hisi_hba->n_phy; i++) {
 		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE, 0x801);
@@ -390,7 +384,6 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, RXOP_CHECK_CFG_H, 0x1000);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1_MSK, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x8ffffbff);
-		hisi_sas_phy_write32(hisi_hba, i, SL_CFG, 0x83f801fc);
 		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL_RDY_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_NOT_RDY_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_DWS_RESET_MSK, 0x0);
@@ -399,9 +392,9 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL, 0x199b4fa);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_SSP_CON_TIMER_CFG,
-				     0xa0064);
+				     0xa03e8);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_STP_CON_TIMER_CFG,
-				     0xa0064);
+				     0xa03e8);
 		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER,
 				     0x7f7a120);
 	}
-- 
1.9.1
