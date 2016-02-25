From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/6] hisi_sas: change tmf func complete check
Date: Thu, 25 Feb 2016 17:42:10 +0800
Message-ID: <1456393335-38294-2-git-send-email-john.garry@huawei.com>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

In hisi_sas_exec_internal_tmf_task(), the check for
SAM_STAT_GOOD is replaced with
TMF_RESP_FUNC_COMPLETE, which is a genuine tmf
response code.
SAM_STAT_GOOD and TMF_RESP_FUNC_COMPLETE have the
same value, so this is why it worked before.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2194917..58ca336 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -661,7 +661,7 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-		    task->task_status.stat == SAM_STAT_GOOD) {
+		     task->task_status.stat == TMF_RESP_FUNC_COMPLETE) {
 			res = TMF_RESP_FUNC_COMPLETE;
 			break;
 		}
-- 
1.9.1
