From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Fix spin lock management in slot_index_alloc_quirk_v2_hw()
Date: Tue, 16 Oct 2018 23:00:36 +0800
Message-ID: <1539702036-191138-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr, linuxarm@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently a spin_unlock_irqrestore() call is missing on the error path, so
add it.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 70d6b28..cc36b64 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -806,8 +806,10 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 	while (1) {
 		start = find_next_zero_bit(bitmap,
 					hisi_hba->slot_index_count, start);
-		if (start >= end)
+		if (start >= end) {
+			spin_unlock_irqrestore(&hisi_hba->lock, flags);
 			return -SAS_QUEUE_FULL;
+		}
 		/*
 		  * SAS IPTT bit0 should be 1, and SATA IPTT bit0 should be 0.
 		  */
-- 
1.9.1
