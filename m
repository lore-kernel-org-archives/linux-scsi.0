From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/8] hisi_sas: fail tmf task prep when port detached
Date: Wed, 10 Aug 2016 21:20:03 +0800
Message-ID: <1470835205-65684-7-git-send-email-john.garry@huawei.com>
References: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

When the port is detached we cannot execute a TMF,
as there can be no device attached to the port.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6c82e07..af92b137 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -204,7 +204,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 		return rc;
 	}
 	port = device->port->lldd_port;
-	if (port && !port->port_attached && !tmf) {
+	if (port && !port->port_attached) {
 		if (sas_protocol_ata(task->task_proto)) {
 			struct task_status_struct *ts = &task->task_status;
 
-- 
1.9.1
