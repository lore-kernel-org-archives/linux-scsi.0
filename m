From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/6] scsi: hisi_sas: Do some more tidy-up
Date: Wed, 6 Feb 2019 18:52:56 +0800
Message-ID: <1549450376-114929-7-git-send-email-john.garry@huawei.com>
References: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Do some very minor tidy-up, for things like needlessly initing
variable and not leaving whitespace before quote endings.

Originally-from: Xiang Chen <chenxiang66@hisilicon.com>
Originally-from: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 10 +++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index eff31472b96e..923296653ed7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -144,7 +144,7 @@ EXPORT_SYMBOL_GPL(hisi_sas_get_ncq_tag);
  */
 u8 hisi_sas_get_prog_phy_linkrate_mask(enum sas_linkrate max)
 {
-	u16 rate = 0;
+	u8 rate = 0;
 	int i;
 
 	max -= SAS_LINK_RATE_1_5_GBPS;
@@ -1180,7 +1180,7 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		task->task_done = hisi_sas_task_done;
 
 		task->slow_task->timer.function = hisi_sas_tmf_timedout;
-		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT*HZ;
+		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT * HZ;
 		add_timer(&task->slow_task->timer);
 
 		res = hisi_sas_task_exec(task, GFP_KERNEL, 1, tmf);
@@ -1701,8 +1701,8 @@ static int hisi_sas_abort_task_set(struct domain_device *device, u8 *lun)
 
 static int hisi_sas_clear_aca(struct domain_device *device, u8 *lun)
 {
-	int rc = TMF_RESP_FUNC_FAILED;
 	struct hisi_sas_tmf_task tmf_task;
+	int rc;
 
 	tmf_task.tmf = TMF_CLEAR_ACA;
 	rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
@@ -1752,7 +1752,7 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 {
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = hisi_hba->dev;
-	int rc = TMF_RESP_FUNC_FAILED;
+	int rc;
 
 	rc = hisi_sas_internal_task_abort(hisi_hba, device,
 					  HISI_SAS_INT_ABT_DEV, 0);
@@ -2005,7 +2005,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	task->task_proto = device->tproto;
 	task->task_done = hisi_sas_task_done;
 	task->slow_task->timer.function = hisi_sas_tmf_timedout;
-	task->slow_task->timer.expires = jiffies + INTERNAL_ABORT_TIMEOUT*HZ;
+	task->slow_task->timer.expires = jiffies + INTERNAL_ABORT_TIMEOUT * HZ;
 	add_timer(&task->slow_task->timer);
 
 	res = hisi_sas_internal_abort_task_exec(hisi_hba, sas_dev->device_id,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d734aef263d1..0f05fd409f6b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -11,7 +11,7 @@
 #include "hisi_sas.h"
 #define DRV_NAME "hisi_sas_v3_hw"
 
-/* global registers need init*/
+/* global registers need init */
 #define DLVRY_QUEUE_ENABLE		0x0
 #define IOST_BASE_ADDR_LO		0x8
 #define IOST_BASE_ADDR_HI		0xc
@@ -728,7 +728,7 @@ static void clear_itct_v3_hw(struct hisi_hba *hisi_hba,
 		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 				 ENT_INT_SRC3_ITC_INT_MSK);
 
-	/* clear the itct table*/
+	/* clear the itct table */
 	reg_val = ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
 	hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
 
-- 
2.17.1
