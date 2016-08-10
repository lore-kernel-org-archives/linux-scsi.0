From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/8] hisi_sas: add internal abort to hisi_sas_abort_task()
Date: Wed, 10 Aug 2016 21:20:00 +0800
Message-ID: <1470835205-65684-4-git-send-email-john.garry@huawei.com>
References: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:49139 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063AbcHJSMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 14:12:08 -0400
In-Reply-To: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

Execute an internal abort for executing an internal
task abort. This is for case of command still being
present in host when abort is executed.

For a SATA internal abort, we set abort for all tasks
associated with the device.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9540953..6c82e07 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -840,18 +840,23 @@ static int hisi_sas_abort_task(struct sas_task *task)
 			}
 		}
 
+		hisi_sas_internal_task_abort(hisi_hba, device, 0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		if (task->dev->dev_type == SAS_SATA_DEV) {
-			struct hisi_slot_info *slot = task->lldd_task;
+			struct hisi_sas_slot *slot = task->lldd_task;
+			u32 tag = slot->idx;
 
-			dev_notice(dev, "abort task: hba=%p task=%p slot=%p\n",
-				   hisi_hba, task, slot);
-			task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+			hisi_sas_internal_task_abort(hisi_hba, device,
+						     1, tag);
 			rc = TMF_RESP_FUNC_COMPLETE;
-			goto out;
 		}
+	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
+		/* SMP */
+		struct hisi_sas_slot *slot = task->lldd_task;
+		u32 tag = slot->idx;
 
+		hisi_sas_internal_task_abort(hisi_hba, device, 0, tag);
 	}
 
 out:
-- 
1.9.1

