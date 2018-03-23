From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/8] scsi: hisi_sas: use dma_zalloc_coherent()
Date: Sat, 24 Mar 2018 00:05:11 +0800
Message-ID: <1521821115-120040-5-git-send-email-john.garry@huawei.com>
References: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This is a warning coming from Coccinelle, and need to use
new interface dma_zalloc_coherent() instead of
dma_alloc_coherent()/memset().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a216795..9563dfa 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1822,13 +1822,11 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 		goto err_out;
 
 	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
-	hisi_hba->itct = dma_alloc_coherent(dev, s, &hisi_hba->itct_dma,
+	hisi_hba->itct = dma_zalloc_coherent(dev, s, &hisi_hba->itct_dma,
 					    GFP_KERNEL);
 	if (!hisi_hba->itct)
 		goto err_out;
 
-	memset(hisi_hba->itct, 0, s);
-
 	hisi_hba->slot_info = devm_kcalloc(dev, max_command_entries,
 					   sizeof(struct hisi_sas_slot),
 					   GFP_KERNEL);
-- 
1.9.1
