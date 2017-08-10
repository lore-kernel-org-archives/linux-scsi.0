From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/19] scsi: hisi_sas: kill tasklet when destroying irq in v3 hw
Date: Fri, 11 Aug 2017 00:09:38 +0800
Message-ID: <1502381384-219889-14-git-send-email-john.garry@huawei.com>
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

This patch adds calls to kill CQ takslets v3 hw during
probe failure.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a8bd557..992ccc2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1802,6 +1802,7 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 
 		free_irq(pci_irq_vector(pdev, i+16), cq);
+		tasklet_kill(&cq->tasklet);
 	}
 	pci_free_irq_vectors(pdev);
 }
-- 
1.9.1
