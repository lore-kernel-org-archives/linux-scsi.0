From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 29/32] scsi: hisi_sas: add tmf methods
Date: Mon, 26 Oct 2015 22:15:00 +0800
Message-ID: <1445868903-183817-30-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add function methods for tmf's.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 353 ++++++++++++++++++++++++++++++++++
 1 file changed, 353 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 13e34cb..4f3a818 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -573,6 +573,45 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	return hisi_sas_dev_found_notify(device, 1);
 }
 
+static int hisi_sas_find_dev_phyno(struct domain_device *device, int *phyno)
+{
+	int i = 0, j = 0, num = 0, n = 0;
+	struct sas_ha_struct *sha = device->port->ha;
+
+	while (sha->sas_port[i]) {
+		if (sha->sas_port[i] == device->port) {
+			struct asd_sas_phy *phy;
+
+			list_for_each_entry(phy,
+				&sha->sas_port[i]->phy_list, port_phy_el) {
+				j = 0;
+
+				while (sha->sas_phy[j]) {
+					if (sha->sas_phy[j] == phy)
+						break;
+					j++;
+				}
+				phyno[n] = j;
+				num++;
+				n++;
+			}
+			break;
+		}
+		i++;
+	}
+	return num;
+}
+
+static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
+			struct domain_device *device)
+{
+	int i, phyno[4], num;
+
+	num = hisi_sas_find_dev_phyno(device, phyno);
+	for (i = 0; i < num; i++)
+		hisi_sas_do_release_task(hisi_hba, phyno[i], device);
+}
+
 static void hisi_sas_dev_gone_notify(struct domain_device *device)
 {
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
@@ -603,6 +642,314 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 }
 
 
+static void hisi_sas_task_done(struct sas_task *task)
+{
+	if (!del_timer(&task->slow_task->timer))
+		return;
+	complete(&task->slow_task->completion);
+}
+
+static void hisi_sas_tmf_timedout(unsigned long data)
+{
+	struct sas_task *task = (struct sas_task *)data;
+
+	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	complete(&task->slow_task->completion);
+}
+
+#define TASK_TIMEOUT 20
+static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
+					   void *parameter,
+					   u32 para_len,
+					   struct hisi_sas_tmf_task *tmf)
+{
+	int res, retry;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_hba *hisi_hba = sas_dev->hisi_hba;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct sas_task *task = NULL;
+
+	for (retry = 0; retry < 3; retry++) {
+		task = sas_alloc_slow_task(GFP_KERNEL);
+		if (!task)
+			return -ENOMEM;
+
+		task->dev = device;
+		task->task_proto = device->tproto;
+
+		memcpy(&task->ssp_task, parameter, para_len);
+		task->task_done = hisi_sas_task_done;
+
+		task->slow_task->timer.data = (unsigned long) task;
+		task->slow_task->timer.function = hisi_sas_tmf_timedout;
+		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT*HZ;
+		add_timer(&task->slow_task->timer);
+
+		res = hisi_sas_task_exec(task, GFP_KERNEL, NULL, 1, tmf);
+
+		if (res) {
+			del_timer(&task->slow_task->timer);
+			dev_err(dev, "executing internal task failed: %d\n",
+				res);
+			goto ex_err;
+		}
+
+		wait_for_completion(&task->slow_task->completion);
+		res = TMF_RESP_FUNC_FAILED;
+		/* Even TMF timed out, return direct. */
+		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+				dev_err(dev, "TMF task[%d] timeout\n",
+				       tmf->tag_of_task_to_be_managed);
+				if (task->lldd_task) {
+					struct hisi_sas_slot *slot;
+
+					slot = (struct hisi_sas_slot *)
+						task->lldd_task;
+					hisi_sas_slot_task_free(hisi_hba,
+								task, slot);
+				}
+
+				goto ex_err;
+			}
+		}
+
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == SAM_STAT_GOOD) {
+			res = TMF_RESP_FUNC_COMPLETE;
+			break;
+		}
+
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_UNDERRUN) {
+			/* no error, but return the number of bytes of
+			 * underrun */
+			pr_warn(" ok: task to dev %016llx response: 0x%x "
+				    "status 0x%x underrun\n",
+				    SAS_ADDR(device->sas_addr),
+				    task->task_status.resp,
+				    task->task_status.stat);
+			res = task->task_status.residual;
+			break;
+		}
+
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+			task->task_status.stat == SAS_DATA_OVERRUN) {
+			pr_warn("%s: blocked task error\n", __func__);
+			res = -EMSGSIZE;
+			break;
+		}
+
+		pr_warn("%s: task to dev %016llx response: 0x%x "
+			"status 0x%x\n", __func__,
+			SAS_ADDR(device->sas_addr),
+			task->task_status.resp,
+			task->task_status.stat);
+		sas_free_task(task);
+		task = NULL;
+	}
+ex_err:
+	BUG_ON(retry == 3 && task != NULL);
+	sas_free_task(task);
+	return res;
+}
+
+static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
+				u8 *lun, struct hisi_sas_tmf_task *tmf)
+{
+	struct sas_ssp_task ssp_task;
+
+	if (!(device->tproto & SAS_PROTOCOL_SSP))
+		return TMF_RESP_FUNC_ESUPP;
+
+	memcpy(ssp_task.LUN, lun, 8);
+
+	return hisi_sas_exec_internal_tmf_task(device, &ssp_task,
+				sizeof(ssp_task), tmf);
+}
+
+static int hisi_sas_abort_task(struct sas_task *task)
+{
+	struct scsi_lun lun;
+	struct hisi_sas_tmf_task tmf_task;
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_hba *hisi_hba;
+	struct device *dev;
+	int rc = TMF_RESP_FUNC_FAILED;
+	unsigned long flags;
+
+	if (!sas_dev) {
+		pr_warn("%s: Device has been removed\n", __func__);
+		return TMF_RESP_FUNC_FAILED;
+	}
+
+	hisi_hba = dev_to_hisi_hba(task->dev);
+	dev = &hisi_hba->pdev->dev;
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		rc = TMF_RESP_FUNC_COMPLETE;
+		goto out;
+	}
+
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	sas_dev->dev_status = HISI_SAS_DEV_EH;
+	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
+		struct scsi_cmnd *cmnd = (struct scsi_cmnd *)task->uldd_task;
+		struct hisi_sas_slot *slot = task->lldd_task;
+		u32 tag = slot->idx;
+
+		int_to_scsilun(cmnd->device->lun, &lun);
+		tmf_task.tmf = TMF_ABORT_TASK;
+		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
+
+		rc = hisi_sas_debug_issue_ssp_tmf(task->dev,
+						  lun.scsi_lun,
+						  &tmf_task);
+
+		/* if successful, clear the task and callback forwards.*/
+		if (rc == TMF_RESP_FUNC_COMPLETE) {
+			if (task->lldd_task) {
+				struct hisi_sas_slot *slot;
+
+				slot = &hisi_hba->slot_info
+					[tmf_task.tag_of_task_to_be_managed];
+				spin_lock_irqsave(&hisi_hba->lock, flags);
+				hisi_hba->hw->slot_complete(hisi_hba, slot, 1);
+				spin_unlock_irqrestore(&hisi_hba->lock, flags);
+			}
+		}
+
+	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
+		task->task_proto & SAS_PROTOCOL_STP) {
+		if (SAS_SATA_DEV == task->dev->dev_type) {
+			struct hisi_slot_info *slot = task->lldd_task;
+
+			dev_notice(dev, "abort task: hba=%p task=%p slot=%p\n",
+				   hisi_hba, task, slot);
+			task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+			rc = TMF_RESP_FUNC_COMPLETE;
+			goto out;
+		}
+
+	}
+
+out:
+	if (rc != TMF_RESP_FUNC_COMPLETE)
+		dev_notice(dev, "abort task: rc=%d\n", rc);
+	return rc;
+}
+
+static int hisi_sas_abort_task_set(struct domain_device *device, u8 *lun)
+{
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct hisi_sas_tmf_task tmf_task;
+
+	tmf_task.tmf = TMF_ABORT_TASK_SET;
+	rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
+
+	return rc;
+}
+
+static int hisi_sas_clear_aca(struct domain_device *device, u8 *lun)
+{
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct hisi_sas_tmf_task tmf_task;
+
+	tmf_task.tmf = TMF_CLEAR_ACA;
+	rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
+
+	return rc;
+}
+
+static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
+{
+	int rc;
+	struct sas_phy *phy = sas_get_local_phy(device);
+	int reset_type = (device->dev_type == SAS_SATA_DEV ||
+			(device->tproto & SAS_PROTOCOL_STP)) ? 0 : 1;
+	rc = sas_phy_reset(phy, reset_type);
+	sas_put_local_phy(phy);
+	msleep(2000);
+	return rc;
+}
+
+static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
+{
+	unsigned long flags;
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+
+	if (sas_dev->dev_status != HISI_SAS_DEV_EH)
+		return TMF_RESP_FUNC_FAILED;
+	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
+
+	rc = hisi_sas_debug_I_T_nexus_reset(device);
+
+	spin_lock_irqsave(&hisi_hba->lock, flags);
+	hisi_sas_release_task(hisi_hba, device);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+
+	return 0;
+}
+
+static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
+{
+	unsigned long flags;
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct hisi_sas_tmf_task tmf_task;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	tmf_task.tmf = TMF_LU_RESET;
+	sas_dev->dev_status = HISI_SAS_DEV_EH;
+	rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
+	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		spin_lock_irqsave(&hisi_hba->lock, flags);
+		hisi_sas_release_task(hisi_hba, device);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	}
+	/* If failed, fall-through I_T_Nexus reset */
+	dev_err(dev, "lu_reset: for device[%llx]:rc= %d\n",
+		sas_dev->device_id, rc);
+	return rc;
+}
+
+static int hisi_sas_query_task(struct sas_task *task)
+{
+	struct scsi_lun lun;
+	struct hisi_sas_tmf_task tmf_task;
+	int rc = TMF_RESP_FUNC_FAILED;
+
+	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
+		struct scsi_cmnd *cmnd = (struct scsi_cmnd *)task->uldd_task;
+		struct domain_device *device = task->dev;
+		struct hisi_sas_slot *slot = task->lldd_task;
+		u32 tag = slot->idx;
+
+		int_to_scsilun(cmnd->device->lun, &lun);
+		tmf_task.tmf = TMF_QUERY_TASK;
+		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
+
+		rc = hisi_sas_debug_issue_ssp_tmf(device,
+						  lun.scsi_lun,
+						  &tmf_task);
+		switch (rc) {
+		/* The task is still in Lun, release it then */
+		case TMF_RESP_FUNC_SUCC:
+		/* The task is not in Lun or failed, reset the phy */
+		case TMF_RESP_FUNC_FAILED:
+		case TMF_RESP_FUNC_COMPLETE:
+			break;
+		}
+	}
+	return rc;
+}
+
 static void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
 {
 	hisi_sas_port_notify_formed(sas_phy, 1);
@@ -680,6 +1027,12 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
 	.lldd_dev_gone		= hisi_sas_dev_gone,
 	.lldd_execute_task	= hisi_sas_queue_command,
+	.lldd_abort_task	= hisi_sas_abort_task,
+	.lldd_abort_task_set	= hisi_sas_abort_task_set,
+	.lldd_clear_aca		= hisi_sas_clear_aca,
+	.lldd_I_T_nexus_reset	= hisi_sas_I_T_nexus_reset,
+	.lldd_lu_reset		= hisi_sas_lu_reset,
+	.lldd_query_task	= hisi_sas_query_task,
 	.lldd_port_formed	= hisi_sas_port_formed,
 	.lldd_port_deformed	= hisi_sas_port_deformed,
 };
-- 
1.9.1
