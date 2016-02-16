From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/6] hisi_sas: add TMF_RESP_FUNC_SUCC check
Date: Tue, 16 Feb 2016 20:22:26 +0800
Message-ID: <1455625351-165881-2-git-send-email-john.garry@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:24081 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbcBPMGG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2016 07:06:06 -0500
In-Reply-To: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

When a tmf is issued, various response codes can be
returned from the target. For a query tmf the
response may be TMF_RESP_FUNC_COMPLETE or
TMF_RESP_FUNC_SUCC.
Add a condition for TMF_RESP_FUNC_SUCC.
Also, check for SAM_STAT_GOOD is replaced with
TMF_RESP_FUNC_COMPLETE, which is a genuine tmf
response code. SAM_STAT_GOOD and
TMF_RESP_FUNC_COMPLETE have the same value, so
this is why it worked before.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2194917..c600f5e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -661,12 +661,18 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-		    task->task_status.stat == SAM_STAT_GOOD) {
+		     task->task_status.stat == TMF_RESP_FUNC_COMPLETE) {
 			res = TMF_RESP_FUNC_COMPLETE;
 			break;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == TMF_RESP_FUNC_SUCC) {
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

