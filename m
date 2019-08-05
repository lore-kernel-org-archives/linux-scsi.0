From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/15] scsi: hisi_sas: Make slot buf minimum allocation of PAGE_SIZE
Date: Mon, 5 Aug 2019 21:48:05 +0800
Message-ID: <1565012892-75940-9-git-send-email-john.garry@huawei.com>
References: <1565012892-75940-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1565012892-75940-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For a system with PAGE_SIZE of 16K or 64K, the size every time we want to
alloc may be small like 4K, but for function dmam_alloc_coherent(), the
least size it allocates is PAGE_SIZE, so it will waste much memory for the
situation.

To solve the issue, limit the minimum allocation size of slot buf to
PAGE_SIZE.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7efa8dfa0cc1..39ae69e42d26 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2389,7 +2389,7 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 	else
 		sz_slot_buf_ru = sizeof(struct hisi_sas_slot_buf_table);
 	sz_slot_buf_ru = roundup(sz_slot_buf_ru, 64);
-	s = lcm(max_command_entries_ru, sz_slot_buf_ru);
+	s = max(lcm(max_command_entries_ru, sz_slot_buf_ru), PAGE_SIZE);
 	blk_cnt = (max_command_entries_ru * sz_slot_buf_ru) / s;
 	slots_per_blk = s / sz_slot_buf_ru;
 
-- 
2.17.1
