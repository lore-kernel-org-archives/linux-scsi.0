From: John Garry <john.garry@huawei.com>
Subject: [PATCH 15/15] hisi_sas: send three identify before phy up
Date: Tue, 6 Sep 2016 23:36:25 +0800
Message-ID: <1473176185-217808-16-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>, NengLong Zhao <zhaonenglong@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

When the v2 hw is attached with many disks through
an expander, there may be OOB reset resulting in a PHY
going down after the speed is negotiated (very low
probability).

This issue is resolved by modifying the link control
registers to send three identify frames before the PHY
is ready (according to 6.10.3.3.2 in SAS 3.0 spec) and
close ready when the PHY is down.

Signed-off-by: NengLong Zhao <zhaonenglong@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 735ebff..9825a3f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -117,6 +117,8 @@
 #define SL_CONTROL			(PORT_BASE + 0x94)
 #define SL_CONTROL_NOTIFY_EN_OFF	0
 #define SL_CONTROL_NOTIFY_EN_MSK	(0x1 << SL_CONTROL_NOTIFY_EN_OFF)
+#define SL_CONTROL_CTA_OFF		17
+#define SL_CONTROL_CTA_MSK		(0x1 << SL_CONTROL_CTA_OFF)
 #define TX_ID_DWORD0			(PORT_BASE + 0x9c)
 #define TX_ID_DWORD1			(PORT_BASE + 0xa0)
 #define TX_ID_DWORD2			(PORT_BASE + 0xa4)
@@ -124,6 +126,9 @@
 #define TX_ID_DWORD4			(PORT_BASE + 0xaC)
 #define TX_ID_DWORD5			(PORT_BASE + 0xb0)
 #define TX_ID_DWORD6			(PORT_BASE + 0xb4)
+#define TXID_AUTO			(PORT_BASE + 0xb8)
+#define TXID_AUTO_CT3_OFF		1
+#define TXID_AUTO_CT3_MSK		(0x1 << TXID_AUTO_CT3_OFF)
 #define RX_IDAF_DWORD0			(PORT_BASE + 0xc4)
 #define RX_IDAF_DWORD1			(PORT_BASE + 0xc8)
 #define RX_IDAF_DWORD2			(PORT_BASE + 0xcc)
@@ -814,6 +819,8 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE, 0x855);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_PHY_CTRL, 0x30b9908);
 		hisi_sas_phy_write32(hisi_hba, i, SL_TOUT_CFG, 0x7d7d7d7d);
+		hisi_sas_phy_write32(hisi_hba, i, SL_CONTROL, 0x0);
+		hisi_sas_phy_write32(hisi_hba, i, TXID_AUTO, 0x2);
 		hisi_sas_phy_write32(hisi_hba, i, DONE_RECEIVED_TIME, 0x10);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1, 0xffffffff);
@@ -1901,16 +1908,21 @@ end:
 static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int res = 0;
-	u32 phy_cfg, phy_state;
+	u32 phy_state, sl_ctrl, txid_auto;
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 1);
 
-	phy_cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
-
 	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
-
 	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0);
 
+	sl_ctrl = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
+	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL,
+			     sl_ctrl & ~SL_CONTROL_CTA_MSK);
+
+	txid_auto = hisi_sas_phy_read32(hisi_hba, phy_no, TXID_AUTO);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TXID_AUTO,
+			     txid_auto | TXID_AUTO_CT3_MSK);
+
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, CHL_INT0_NOT_RDY_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 0);
 
-- 
1.9.1
