From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/7] scsi: hisi_sas: unmask interrupts ent72 and ent74
Date: Mon, 24 Sep 2018 23:06:32 +0800
Message-ID: <1537801594-207139-6-git-send-email-john.garry@huawei.com>
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

The interrupts of ent72 and ent74 are not processed by PCIe AER handling,
so we need to unmask the interrupts and process them first in the driver.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3995ff6..34c8f30 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -441,7 +441,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, 0xfefefefe);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK2, 0xfefefefe);
 	if (pdev->revision >= 0x21)
-		hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0xffff7fff);
+		hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0xffff7aff);
 	else
 		hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0xfffe20ff);
 	hisi_sas_write32(hisi_hba, CHNL_PHYUPDOWN_INT_MSK, 0x0);
-- 
1.9.1
