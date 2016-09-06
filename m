From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/15] hisi_sas: fix a potential warning for sata disk ejection
Date: Tue, 6 Sep 2016 23:36:18 +0800
Message-ID: <1473176185-217808-9-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47500 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935768AbcIFPXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2016 11:23:53 -0400
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

If hisi_sas_task_prep() fails for a SATA device due to PHY
down, we return a failure to libata and also call task_done(),
which will cause ata_qc_complete() to be called twice:
- first call from hisi_sas_task_prep(), which will clear flag
  ATA_QCFLAG_ACTIVE
- ata_qc_complete() called from libata
The warning call trace is as follows:

[  117.070206] [<ffff0000084f59b0>] __ata_qc_complete+0xf4/0x11c
[  117.070208] [<ffff0000084f5b58>] ata_qc_complete+0x180/0x200
[  117.070210] [<ffff0000084f5dd0>] ata_qc_issue+0x110/0x354
[  117.070212] [<ffff0000084f6254>] ata_exec_internal_sg+0x240/0x4d0
[  117.070214] [<ffff0000084f6544>] ata_exec_internal+0x60/0xa0
[  117.070217] [<ffff000008501580>] ata_read_log_page+0x188/0x1b4
[  117.070218] [<ffff0000085017dc>] ata_eh_analyze_ncq_error+0xa8/0x274
[  117.070220] [<ffff000008501a3c>] ata_eh_link_autopsy+0x94/0x8c8
[  117.070222] [<ffff0000085022a4>] ata_eh_autopsy+0x34/0xe8
[  117.070223] [<ffff00000850540c>] ata_do_eh+0x28/0xc0
[  117.070225] [<ffff0000085054e0>] ata_std_error_handler+0x3c/0x84
[  117.070227] [<ffff000008505140>] ata_scsi_port_error_handler+0x480/0x674
[  117.070230] [<ffff0000084e3020>] async_sas_ata_eh+0x44/0x78
[  117.070231] [<ffff0000080d6b8c>] async_run_entry_fn+0x40/0x104
[  117.070234] [<ffff0000080ce518>] process_one_work+0x128/0x2f0
[  117.070235] [<ffff0000080ce738>] worker_thread+0x58/0x434
[  117.070237] [<ffff0000080d416c>] kthread+0xd4/0xe8
[  117.070240] [<ffff000008084e10>] ret_from_fork+0x10/0x40

The issue is resolved by simply returning a failure status
code to the upper layer.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index dcb17a3..d58e223 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -205,26 +205,12 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	}
 	port = device->port->lldd_port;
 	if (port && !port->port_attached) {
-		if (sas_protocol_ata(task->task_proto)) {
-			struct task_status_struct *ts = &task->task_status;
-
-			dev_info(dev,
-				 "task prep: SATA/STP port%d not attach device\n",
-				 device->port->id);
-			ts->resp = SAS_TASK_COMPLETE;
-			ts->stat = SAS_PHY_DOWN;
-			task->task_done(task);
-		} else {
-			struct task_status_struct *ts = &task->task_status;
-
-			dev_info(dev,
-				 "task prep: SAS port%d does not attach device\n",
-				 device->port->id);
-			ts->resp = SAS_TASK_UNDELIVERED;
-			ts->stat = SAS_PHY_DOWN;
-			task->task_done(task);
-		}
-		return 0;
+		dev_info(dev, "task prep: %s port%d not attach device\n",
+			 (sas_protocol_ata(task->task_proto)) ?
+			 "SATA/STP" : "SAS",
+			 device->port->id);
+
+		return SAS_PHY_DOWN;
 	}
 
 	if (!sas_protocol_ata(task->task_proto)) {
-- 
1.9.1

