From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/7] scsi: hisi_sas: Update v3 hw AIP_LIMIT and CFG_AGING_TIME register values
Date: Mon, 24 Sep 2018 23:06:34 +0800
Message-ID: <1537801594-207139-8-git-send-email-john.garry@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Update registers as follows:
- Default value of AIP timer is 1ms, and it is easy for some expanders to
  cause IO error. Change the value to max value 65ms to avoid IO error for
  those expanders.

- A CQ completion will be reported by HW when 4 CQs have occurred or the
  aging timer expires, whichever happens first. Sor serial IO scenario, it
  will still wait 8us for every IO before it is reported. So in the
  situation, the performance is poor. So to improve it, change the limit
  time to the least value.
  For other scenario, it does little affect to the performance.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f30c4e4..bd4ce38 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -127,6 +127,7 @@
 #define PHY_CTRL_RESET_OFF		0
 #define PHY_CTRL_RESET_MSK		(0x1 << PHY_CTRL_RESET_OFF)
 #define SL_CFG				(PORT_BASE + 0x84)
+#define AIP_LIMIT			(PORT_BASE + 0x90)
 #define SL_CONTROL			(PORT_BASE + 0x94)
 #define SL_CONTROL_NOTIFY_EN_OFF	0
 #define SL_CONTROL_NOTIFY_EN_MSK	(0x1 << SL_CONTROL_NOTIFY_EN_OFF)
@@ -431,6 +432,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
 	hisi_sas_write32(hisi_hba, CFG_MAX_TAG, 0xfff0400);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
+	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
 	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x1);
@@ -495,6 +497,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 
 		/* used for 12G negotiate */
 		hisi_sas_phy_write32(hisi_hba, i, COARSETUNE_TIME, 0x1e);
+		hisi_sas_phy_write32(hisi_hba, i, AIP_LIMIT, 0x2ffff);
 	}
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
-- 
1.9.1
