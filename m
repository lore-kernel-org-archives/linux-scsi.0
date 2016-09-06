From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/15] hisi_sas: keep CHL_INT2 masked for v2 HW
Date: Tue, 6 Sep 2016 23:36:13 +0800
Message-ID: <1473176185-217808-4-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

None of the CHL_INT2 interrupts are serviced
in the channel irq ISR, so leave the interrupt
source masked.
The interrupt mask is initially set in
init_reg_v2_hw().

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e0c124b..25e7c58 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -965,14 +965,8 @@ static void start_phys_v2_hw(unsigned long data)
 
 static void phys_init_v2_hw(struct hisi_hba *hisi_hba)
 {
-	int i;
 	struct timer_list *timer = &hisi_hba->timer;
 
-	for (i = 0; i < hisi_hba->n_phy; i++) {
-		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x6a);
-		hisi_sas_phy_read32(hisi_hba, i, CHL_INT2_MSK);
-	}
-
 	setup_timer(timer, start_phys_v2_hw, (unsigned long)hisi_hba);
 	mod_timer(timer, jiffies + HZ);
 }
-- 
1.9.1
