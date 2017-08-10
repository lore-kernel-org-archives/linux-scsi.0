From: John Garry <john.garry@huawei.com>
Subject: [PATCH 12/19] scsi: hisi_sas: fix v3 hw channel interrupt processing
Date: Fri, 11 Aug 2017 00:09:37 +0800
Message-ID: <1502381384-219889-13-git-send-email-john.garry@huawei.com>
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

The channel interrupt is to process all the interrupts
except PHY UP/DOWN and broadcast interrupt. So we need to
clear all the interrupts except those 3 interrupts after
processing channel interrupts.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bb79b776..a8bd557 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1260,7 +1260,7 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 		if (irq_msk & (2 << (phy_no * 4)) && irq_value0) {
 			hisi_sas_phy_write32(hisi_hba, phy_no,
 					CHL_INT0, irq_value0
-					& (~CHL_INT0_HOTPLUG_TOUT_MSK)
+					& (~CHL_INT0_SL_RX_BCST_ACK_MSK)
 					& (~CHL_INT0_SL_PHY_ENABLE_MSK)
 					& (~CHL_INT0_NOT_RDY_MSK));
 		}
-- 
1.9.1
