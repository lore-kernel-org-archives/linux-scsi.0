From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/19] scsi: hisi_sas: Modify v3 hw STP_LINK_TIMER setting
Date: Fri, 11 Aug 2017 00:09:36 +0800
Message-ID: <1502381384-219889-12-git-send-email-john.garry@huawei.com>
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

Modify STP link timer from 10ms to 500ms. Also add
the register address.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index dc5c551..bb79b776 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -137,6 +137,7 @@
 #define TX_HARDRST_MSK          (0x1 << TX_HARDRST_OFF)
 #define RX_IDAF_DWORD0			(PORT_BASE + 0xc4)
 #define RXOP_CHECK_CFG_H		(PORT_BASE + 0xfc)
+#define STP_LINK_TIMER			(PORT_BASE + 0x120)
 #define SAS_SSP_CON_TIMER_CFG		(PORT_BASE + 0x134)
 #define SAS_SMP_CON_TIMER_CFG		(PORT_BASE + 0x138)
 #define SAS_STP_CON_TIMER_CFG		(PORT_BASE + 0x13c)
@@ -401,6 +402,8 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 				     0xa0064);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_STP_CON_TIMER_CFG,
 				     0xa0064);
+		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER,
+				     0x7f7a120);
 	}
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		/* Delivery queue */
-- 
1.9.1
