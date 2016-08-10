From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/8] hisi_sas: add TMF success check
Date: Wed, 10 Aug 2016 21:20:04 +0800
Message-ID: <1470835205-65684-8-git-send-email-john.garry@huawei.com>
References: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

When a tmf is issued, various response codes can be
returned from the target. For a query tmf the
response may be TMF_RESP_FUNC_COMPLETE or
TMF_RESP_FUNC_SUCC.
Add a condition for TMF_RESP_FUNC_SUCC to
hisi_sas_exec_internal_tmf_task().
This affects query tmf, as the result is success
the returned value was for failure.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index af92b137..3ba8dc7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -743,6 +743,12 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+			task->task_status.stat == TMF_RESP_FUNC_SUCC) {
+			res = TMF_RESP_FUNC_SUCC;
+			break;
+		}
+
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
 		      task->task_status.stat == SAS_DATA_UNDERRUN) {
 			/* no error, but return the number of bytes of
 			 * underrun
-- 
1.9.1
