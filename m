From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/6] scsi: hisi_sas: Change SERDES_CFG init value to increase reliability of HiLink
Date: Thu, 28 Feb 2019 22:51:02 +0800
Message-ID: <1551365462-128193-7-git-send-email-john.garry@huawei.com>
References: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

With default value of register SERDES_CFG, the link is not stable for some
special disks when running IO. According to HW guys' suggestion, need to
make the bit10~19 value of register SERDES_CFG the max value to increase
the reliability of the HiLink.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Yupeng Zhou <zhouyupeng1@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 720721196b12..e2f2c04355b9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -129,6 +129,7 @@
 #define PHY_CTRL_RESET_MSK		(0x1 << PHY_CTRL_RESET_OFF)
 #define CMD_HDR_PIR_OFF			8
 #define CMD_HDR_PIR_MSK			(0x1 << CMD_HDR_PIR_OFF)
+#define SERDES_CFG			(PORT_BASE + 0x1c)
 #define SL_CFG				(PORT_BASE + 0x84)
 #define AIP_LIMIT			(PORT_BASE + 0x90)
 #define SL_CONTROL			(PORT_BASE + 0x94)
@@ -525,6 +526,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		}
 		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE,
 			prog_phy_link_rate);
+		hisi_sas_phy_write32(hisi_hba, i, SERDES_CFG, 0xffc00);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_RX_TRAIN_TIMER, 0x13e80);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1, 0xffffffff);
-- 
2.17.1
