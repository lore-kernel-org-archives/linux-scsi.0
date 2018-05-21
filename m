From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/13] scsi: hisi_sas: change slot index allocation mode
Date: Mon, 21 May 2018 18:09:14 +0800
Message-ID: <1526897365-228549-3-git-send-email-john.garry@huawei.com>
References: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently we find the lowest available empty bit in the
IPTT bitmap to allocate the IPTT for a command.

To reduce possibility of hitting unknown SoC bugs and
also aid in the debugging of those same bugs, change
the allocation mode.

The next allocation method is to use the next free slot
adjacent to the most recently allocated slot, in a
round-robin fashion.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 52fc709..3c88400 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -274,6 +274,7 @@ struct hisi_hba {
 	struct workqueue_struct *wq;
 
 	int slot_index_count;
+	int last_slot_index;
 	unsigned long *slot_index_tags;
 	unsigned long reject_stp_links_msk;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f822d6f..1d300a2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -195,11 +195,18 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba, int *slot_idx)
 	unsigned int index;
 	void *bitmap = hisi_hba->slot_index_tags;
 
-	index = find_first_zero_bit(bitmap, hisi_hba->slot_index_count);
-	if (index >= hisi_hba->slot_index_count)
-		return -SAS_QUEUE_FULL;
+	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
+			hisi_hba->last_slot_index + 1);
+	if (index >= hisi_hba->slot_index_count) {
+		index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
+					   0);
+		if (index >= hisi_hba->slot_index_count)
+			return -SAS_QUEUE_FULL;
+	}
 	hisi_sas_slot_index_set(hisi_hba, index);
 	*slot_idx = index;
+	hisi_hba->last_slot_index = index;
+
 	return 0;
 }
 
-- 
1.9.1
