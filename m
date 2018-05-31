From: John Garry <john.garry@huawei.com>
Subject: [PATCH 9/9] scsi: hisi_sas: Update a couple of register settings for v3 hw
Date: Thu, 31 May 2018 20:50:50 +0800
Message-ID: <1527771050-200916-10-git-send-email-john.garry@huawei.com>
References: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Update CFG_1US_TIMER_TRSH and CON_CFG_DRIVER settings.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e43881d..4b7688a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -51,7 +51,6 @@
 #define CFG_ABT_SET_IPTT_DONE	0xd8
 #define CFG_ABT_SET_IPTT_DONE_OFF	0
 #define HGC_IOMB_PROC1_STATUS	0x104
-#define CFG_1US_TIMER_TRSH		0xcc
 #define CHNL_INT_STATUS			0x148
 #define HGC_AXI_FIFO_ERR_INFO  0x154
 #define AXI_ERR_INFO_OFF               0
@@ -428,7 +427,6 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
 	hisi_sas_write32(hisi_hba, CFG_MAX_TAG, 0xfff0400);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
-	hisi_sas_write32(hisi_hba, CFG_1US_TIMER_TRSH, 0xd);
 	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
 	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, OQ_INT_COAL_CNT, 0x1);
@@ -489,6 +487,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, SL_RX_BCAST_CHK_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x1);
 		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER, 0x7f7a120);
+		hisi_sas_phy_write32(hisi_hba, i, CON_CFG_DRIVER, 0x2a0a01);
 
 		/* used for 12G negotiate */
 		hisi_sas_phy_write32(hisi_hba, i, COARSETUNE_TIME, 0x1e);
-- 
1.9.1
