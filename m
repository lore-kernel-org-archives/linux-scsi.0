From: John Garry <john.garry@huawei.com>
Subject: [PATCH 05/15] hisi_sas: use safe BITS_PER_BYTE for slot tag size calculation
Date: Tue, 6 Sep 2016 23:36:15 +0800
Message-ID: <1473176185-217808-6-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The memory calculation for the tags bitmap should use BITS_PER_BYTE
macro instead of coincidental same value of sizeof(unsigned long).

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0e48751..dcb17a3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1309,7 +1309,7 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	memset(hisi_hba->breakpoint, 0, s);
 
 	hisi_hba->slot_index_count = max_command_entries;
-	s = hisi_hba->slot_index_count / sizeof(unsigned long);
+	s = hisi_hba->slot_index_count / BITS_PER_BYTE;
 	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
 	if (!hisi_hba->slot_index_tags)
 		goto err_out;
-- 
1.9.1
