From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/8] scsi: hisi_sas: print device id for errors
Date: Sat, 24 Mar 2018 00:05:14 +0800
Message-ID: <1521821115-120040-8-git-send-email-john.garry@huawei.com>
References: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

When we find an erroneous slot completion, to help aid
debugging add the device index to the current debug
log.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index bed6afb..a5abde8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2459,10 +2459,10 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			slot_err_v2_hw(hisi_hba, task, slot, 2);
 
 		if (ts->stat != SAS_DATA_UNDERRUN)
-			dev_info(dev, "erroneous completion iptt=%d task=%p "
+			dev_info(dev, "erroneous completion iptt=%d task=%p dev id=%d "
 				"CQ hdr: 0x%x 0x%x 0x%x 0x%x "
 				"Error info: 0x%x 0x%x 0x%x 0x%x\n",
-				slot->idx, task,
+				slot->idx, task, sas_dev->device_id,
 				complete_hdr->dw0, complete_hdr->dw1,
 				complete_hdr->act, complete_hdr->dw3,
 				error_info[0], error_info[1],
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index aa52d5e..760724a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1641,10 +1641,10 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 
 		slot_err_v3_hw(hisi_hba, task, slot);
 		if (ts->stat != SAS_DATA_UNDERRUN)
-			dev_info(dev, "erroneous completion iptt=%d task=%p "
+			dev_info(dev, "erroneous completion iptt=%d task=%p dev id=%d "
 				"CQ hdr: 0x%x 0x%x 0x%x 0x%x "
 				"Error info: 0x%x 0x%x 0x%x 0x%x\n",
-				slot->idx, task,
+				slot->idx, task, sas_dev->device_id,
 				complete_hdr->dw0, complete_hdr->dw1,
 				complete_hdr->act, complete_hdr->dw3,
 				error_info[0], error_info[1],
-- 
1.9.1
