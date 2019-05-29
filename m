From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/6] scsi: hisi_sas: Disable stash for v3 hw
Date: Wed, 29 May 2019 17:58:47 +0800
Message-ID: <1559123927-160502-7-git-send-email-john.garry@huawei.com>
References: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For v3 hw, stash is enabled to promote performance, but it does little
help for promoting performance according to current test. What's more, it
causes exception for some situations, so disable it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index fbf0a1e9c8c2..b92aa6b37e1d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -28,6 +28,7 @@
 #define ITCT_CLR_EN_MSK			(0x1 << ITCT_CLR_EN_OFF)
 #define ITCT_DEV_OFF			0
 #define ITCT_DEV_MSK			(0x7ff << ITCT_DEV_OFF)
+#define SAS_AXI_USER3			0x50
 #define IO_SATA_BROKEN_MSG_ADDR_LO	0x58
 #define IO_SATA_BROKEN_MSG_ADDR_HI	0x5c
 #define SATA_INITI_D2H_STORE_ADDR_LO	0x60
@@ -554,6 +555,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	/* Global registers init */
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
+	hisi_sas_write32(hisi_hba, SAS_AXI_USER3, 0);
 	hisi_sas_write32(hisi_hba, CFG_MAX_TAG, 0xfff0400);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
-- 
2.17.1
