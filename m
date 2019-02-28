From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/6] scsi: hisi_sas: Change return variable type in phy_up_v3_hw()
Date: Thu, 28 Feb 2019 22:50:57 +0800
Message-ID: <1551365462-128193-2-git-send-email-john.garry@huawei.com>
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

According to the tool fortify, phy_up_v3_hw() returns signed
value, while it should return an unsigned value.

So change variable "res" from int to irq_return_t.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 00738d0673fe..151a102c4cc7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1344,7 +1344,8 @@ static void prep_abort_v3_hw(struct hisi_hba *hisi_hba,
 
 static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
-	int i, res;
+	int i;
+	irqreturn_t res;
 	u32 context, port_id, link_rate;
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-- 
2.17.1
