From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 09/10] scsi: hisi_sas: modify some register config for hip08
Date: Wed, 7 Mar 2018 20:25:13 +0800
Message-ID: <1520425514-205565-10-git-send-email-john.garry@huawei.com>
References: <1520425514-205565-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520425514-205565-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Do some modifications for register configuring for hip08.

In future, to reduce kernel churn with patches to modify
registers, any registers which may change between board
models (mostly PHY/SERDES related) should be set in ACPI
reset handler.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4023fcb..5ce5ef2c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -172,6 +172,7 @@
 #define CHL_INT1_MSK			(PORT_BASE + 0x1c4)
 #define CHL_INT2_MSK			(PORT_BASE + 0x1c8)
 #define CHL_INT_COAL_EN			(PORT_BASE + 0x1d0)
+#define SAS_RX_TRAIN_TIMER		(PORT_BASE + 0x2a4)
 #define PHY_CTRL_RDY_MSK		(PORT_BASE + 0x2b0)
 #define PHYCTRL_NOT_RDY_MSK		(PORT_BASE + 0x2b4)
 #define PHYCTRL_DWS_RESET_MSK		(PORT_BASE + 0x2b8)
@@ -184,6 +185,8 @@
 #define DMA_RX_STATUS			(PORT_BASE + 0x2e8)
 #define DMA_RX_STATUS_BUSY_OFF		0
 #define DMA_RX_STATUS_BUSY_MSK		(0x1 << DMA_RX_STATUS_BUSY_OFF)
+
+#define COARSETUNE_TIME			(PORT_BASE + 0x304)
 #define ERR_CNT_DWS_LOST		(PORT_BASE + 0x380)
 #define ERR_CNT_RESET_PROB		(PORT_BASE + 0x384)
 #define ERR_CNT_INVLD_DW		(PORT_BASE + 0x390)
@@ -417,10 +420,10 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK+0x4*i, 0);
 
 	hisi_sas_write32(hisi_hba, HYPER_STREAM_ID_EN_CFG, 1);
-	hisi_sas_write32(hisi_hba, AXI_MASTER_CFG_BASE, 0x30000);
 
 	for (i = 0; i < hisi_hba->n_phy; i++) {
-		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE, 0x801);
+		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE, 0x855);
+		hisi_sas_phy_write32(hisi_hba, i, SAS_RX_TRAIN_TIMER, 0x13e80);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2, 0xffffffff);
@@ -432,17 +435,13 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_DWS_RESET_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_PHY_ENA_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, SL_RX_BCAST_CHK_MSK, 0x0);
-		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x0);
-		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL, 0x199b4fa);
-		hisi_sas_phy_write32(hisi_hba, i, SAS_SSP_CON_TIMER_CFG,
-				     0xa03e8);
-		hisi_sas_phy_write32(hisi_hba, i, SAS_STP_CON_TIMER_CFG,
-				     0xa03e8);
-		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER,
-				     0x7f7a120);
-		hisi_sas_phy_write32(hisi_hba, i, CON_CFG_DRIVER,
-				     0x2a0a80);
+		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x1);
+		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER, 0x7f7a120);
+
+		/* used for 12G negotiate */
+		hisi_sas_phy_write32(hisi_hba, i, COARSETUNE_TIME, 0x1e);
 	}
+
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		/* Delivery queue */
 		hisi_sas_write32(hisi_hba,
-- 
1.9.1
