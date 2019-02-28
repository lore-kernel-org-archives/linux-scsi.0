From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/6] scsi: hisi_sas: Fix a timeout race of driver internal and SMP IO
Date: Thu, 28 Feb 2019 22:50:58 +0800
Message-ID: <1551365462-128193-3-git-send-email-john.garry@huawei.com>
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

For internal IO and SMP IO, there is a time-out timer for them. In the
timer handler, it checks whether IO is done according to the flag
task->task_state_lock.

There is an issue which may cause system suspended: internal IO or SMP IO
is sent, but at that time because of hardware exception (such as inject
2Bit ECC error), so IO is not completed and also not timeout. But, at that
time, the SAS controller reset occurs to recover system. It will release
the resource and set the status of IO to be SAS_TASK_STATE_DONE, so when
IO timeout, it will never complete the completion of IO and wait for ever.

[  729.123632] Call trace:
[  729.126791] [<ffff00000808655c>] __switch_to+0x94/0xa8
[  729.133106] [<ffff000008d96e98>] __schedule+0x1e8/0x7fc
[  729.138975] [<ffff000008d974e0>] schedule+0x34/0x8c
[  729.144401] [<ffff000008d9b000>] schedule_timeout+0x1d8/0x3cc
[  729.150690] [<ffff000008d98218>] wait_for_common+0xdc/0x1a0
[  729.157101] [<ffff000008d98304>] wait_for_completion+0x28/0x34
[  729.165973] [<ffff000000dcefb4>] hisi_sas_internal_task_abort+0x2a0/0x424 [hisi_sas_test_main]
[  729.176447] [<ffff000000dd18f4>] hisi_sas_abort_task+0x244/0x2d8 [hisi_sas_test_main]
[  729.185258] [<ffff000008971714>] sas_eh_handle_sas_errors+0x1c8/0x7b8
[  729.192391] [<ffff000008972774>] sas_scsi_recover_host+0x130/0x398
[  729.199237] [<ffff00000894d8a8>] scsi_error_handler+0x148/0x5c0
[  729.206009] [<ffff0000080f4118>] kthread+0x10c/0x138
[  729.211563] [<ffff0000080855dc>] ret_from_fork+0x10/0x18

To solve the issue, callback function task_done of those IOs need to be
called when on SAS controller reset.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 923296653ed7..dd03dcbd3786 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -980,7 +980,8 @@ static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba, struct sas_task
 		spin_lock_irqsave(&task->task_state_lock, flags);
 		task->task_state_flags &=
 			~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
-		task->task_state_flags |= SAS_TASK_STATE_DONE;
+		if (!slot->is_internal && task->task_proto != SAS_PROTOCOL_SMP)
+			task->task_state_flags |= SAS_TASK_STATE_DONE;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 	}
 
-- 
2.17.1
