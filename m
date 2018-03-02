From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 7/8] scsi: hisi_sas: fix return value of hisi_sas_task_prep()
Date: Fri, 2 Mar 2018 23:06:21 +0800
Message-ID: <1520003182-26277-8-git-send-email-john.garry@huawei.com>
References: <1520003182-26277-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520003182-26277-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

It is an implicit regulation that error code that function returned
should be negative. But hisi_sas_task_prep() doesn't follow this.
This may cause problems in the upper layer code.

For example, in sas_expander.c of libsas, smp_execute_task_sg() may
return the number of bytes of underrun. It will be conflicted with
the scenaio lldd_execute_task() return an positive error code.

This patch change the return value from SAS_PHY_DOWN to -ECOMM in
hisi_sas_task_prep().

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 88ad8d4..dff9723 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -316,7 +316,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
 		 */
 		if (device->dev_type != SAS_SATA_DEV)
 			task->task_done(task);
-		return SAS_PHY_DOWN;
+		return -ECOMM;
 	}
 
 	if (DEV_IS_GONE(sas_dev)) {
@@ -327,7 +327,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
 			dev_info(dev, "task prep: device %016llx not ready\n",
 				 SAS_ADDR(device->sas_addr));
 
-		return SAS_PHY_DOWN;
+		return -ECOMM;
 	}
 
 	port = to_hisi_sas_port(sas_port);
@@ -337,7 +337,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
 			 "SATA/STP" : "SAS",
 			 device->port->id);
 
-		return SAS_PHY_DOWN;
+		return -ECOMM;
 	}
 
 	if (!sas_protocol_ata(task->task_proto)) {
-- 
1.9.1
