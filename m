From: John Garry <john.garry@huawei.com>
Subject: [PATCH 04/23] scsi: hisi_sas: add softreset function for SATA disk
Date: Thu, 23 Mar 2017 01:25:20 +0800
Message-ID: <1490203539-228029-5-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4378 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760889AbdCVQ6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:47 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

Add softreset to clear IO after internal abort device
for SATA disk.

The SATA error handling for the controller is based on
device internal abort and softreset function.

The controller does not support internal abort for single
IO, so we need to execute internal abort for device.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/Kconfig          |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 70 ++++++++++++++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 +-
 3 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index d1dd161..ded2c20 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -2,7 +2,7 @@ config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
 	depends on HAS_DMA && HAS_IOMEM
 	depends on ARM64 || COMPILE_TEST
-	select SCSI_SAS_LIBSAS
+	depends on SCSI_SAS_ATA
 	select BLK_DEV_INTEGRITY
 	help
 		This driver supports HiSilicon's SAS HBA
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b86a228..9d9f305 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -21,6 +21,7 @@ static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			     struct domain_device *device,
 			     int abort_flag, int tag);
+static int hisi_sas_softreset_ata_disk(struct domain_device *device);
 
 static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 {
@@ -720,7 +721,12 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		task->dev = device;
 		task->task_proto = device->tproto;
 
-		memcpy(&task->ssp_task, parameter, para_len);
+		if (dev_is_sata(device)) {
+			task->ata_task.device_control_reg_update = 1;
+			memcpy(&task->ata_task.fis, parameter, para_len);
+		} else {
+			memcpy(&task->ssp_task, parameter, para_len);
+		}
 		task->task_done = hisi_sas_task_done;
 
 		task->slow_task->timer.data = (unsigned long) task;
@@ -742,8 +748,7 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		/* Even TMF timed out, return direct. */
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				dev_err(dev, "abort tmf: TMF task[%d] timeout\n",
-					tmf->tag_of_task_to_be_managed);
+				dev_err(dev, "abort tmf: TMF task timeout\n");
 				if (task->lldd_task) {
 					struct hisi_sas_slot *slot =
 						task->lldd_task;
@@ -803,6 +808,63 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 	return res;
 }
 
+static void hisi_sas_fill_ata_reset_cmd(struct ata_device *dev,
+		bool reset, int pmp, u8 *fis)
+{
+	struct ata_taskfile tf;
+
+	ata_tf_init(dev, &tf);
+	if (reset)
+		tf.ctl |= ATA_SRST;
+	else
+		tf.ctl &= ~ATA_SRST;
+	tf.command = ATA_CMD_DEV_RESET;
+	ata_tf_to_fis(&tf, pmp, 0, fis);
+}
+
+static int hisi_sas_softreset_ata_disk(struct domain_device *device)
+{
+	u8 fis[20] = {0};
+	struct ata_port *ap = device->sata_dev.ap;
+	struct ata_link *link;
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct device *dev = &hisi_hba->pdev->dev;
+	int s = sizeof(struct host_to_dev_fis);
+	unsigned long flags;
+
+	ata_for_each_link(link, ap, EDGE) {
+		int pmp = sata_srst_pmp(link);
+
+		hisi_sas_fill_ata_reset_cmd(link->device, 1, pmp, fis);
+		rc = hisi_sas_exec_internal_tmf_task(device, fis, s, NULL);
+		if (rc != TMF_RESP_FUNC_COMPLETE)
+			break;
+	}
+
+	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		ata_for_each_link(link, ap, EDGE) {
+			int pmp = sata_srst_pmp(link);
+
+			hisi_sas_fill_ata_reset_cmd(link->device, 0, pmp, fis);
+			rc = hisi_sas_exec_internal_tmf_task(device, fis,
+							     s, NULL);
+			if (rc != TMF_RESP_FUNC_COMPLETE)
+				dev_err(dev, "ata disk de-reset failed\n");
+		}
+	} else {
+		dev_err(dev, "ata disk reset failed\n");
+	}
+
+	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		spin_lock_irqsave(&hisi_hba->lock, flags);
+		hisi_sas_release_task(hisi_hba, device);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	}
+
+	return rc;
+}
+
 static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 				u8 *lun, struct hisi_sas_tmf_task *tmf)
 {
@@ -908,7 +970,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		if (task->dev->dev_type == SAS_SATA_DEV) {
 			hisi_sas_internal_task_abort(hisi_hba, device,
 						     HISI_SAS_INT_ABT_DEV, 0);
-			rc = TMF_RESP_FUNC_COMPLETE;
+			rc = hisi_sas_softreset_ata_disk(device);
 		}
 	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 73e4f66..401e5c6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1961,7 +1961,8 @@ static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 		dw1 &= ~CMD_HDR_DIR_MSK;
 	}
 
-	if (0 == task->ata_task.fis.command)
+	if ((task->ata_task.fis.command == ATA_CMD_DEV_RESET) &&
+			(task->ata_task.fis.control & ATA_SRST))
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
 	dw1 |= (get_ata_protocol(task->ata_task.fis.command, task->data_dir))
-- 
1.9.1
