From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH 4/6] pm80xx : Corrected SATA abort handling.
Date: Fri, 30 Jan 2015 11:36:43 +0530
Message-ID: <20150130060645.23653-5-Viswas.G@microsemi.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02hn0237.outbound.protection.outlook.com ([104.47.38.237]:49440
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755814AbdHYRMQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 13:12:16 -0400
In-Reply-To: <20150130060645.23653-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com

Modified SATA abort handling with following steps:
1) Set device state as recovery.
2) Send phy reset.
3) Wait for reset completion.
4) After successful reset, abort all IO's to the device.
5) After aborting all IO's to device, set device state as operational.

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  11 +++-
 drivers/scsi/pm8001/pm8001_sas.c | 125 +++++++++++++++++++++++++++------------
 drivers/scsi/pm8001/pm8001_sas.h |   8 +++
 drivers/scsi/pm8001/pm80xx_hwi.c |  52 +++++++++++++---
 4 files changed, 148 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 10546faac58c..db88a8e7ee0e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3198,19 +3198,28 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
+	u32 tag;
 	struct local_phy_ctl_resp *pPayload =
 		(struct local_phy_ctl_resp *)(piomb + 4);
 	u32 status = le32_to_cpu(pPayload->status);
 	u32 phy_id = le32_to_cpu(pPayload->phyop_phyid) & ID_BITS;
 	u32 phy_op = le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;
+	tag = le32_to_cpu(pPayload->tag);
 	if (status != 0) {
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("%x phy execute %x phy op failed!\n",
 			phy_id, phy_op));
-	} else
+	} else {
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("%x phy execute %x phy op success!\n",
 			phy_id, phy_op));
+		pm8001_ha->phy[phy_id].reset_success = true;
+	}
+	if (pm8001_ha->phy[phy_id].enable_completion) {
+		complete(pm8001_ha->phy[phy_id].enable_completion);
+		pm8001_ha->phy[phy_id].enable_completion = NULL;
+	}
+	pm8001_tag_free(pm8001_ha, tag);
 	return 0;
 }
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index ce584c31d36e..a409d3a6a3cb 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1159,40 +1159,47 @@ int pm8001_query_task(struct sas_task *task)
 int pm8001_abort_task(struct sas_task *task)
 {
 	unsigned long flags;
-	u32 tag = 0xdeadbeef;
+	u32 tag;
 	u32 device_id;
 	struct domain_device *dev ;
-	struct pm8001_hba_info *pm8001_ha = NULL;
+	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_ccb_info *ccb;
 	struct scsi_lun lun;
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_tmf_task tmf_task;
-	int rc = TMF_RESP_FUNC_FAILED;
+	int rc = TMF_RESP_FUNC_FAILED, ret;
+	u32 phy_id;
+	struct sas_task_slow slow_task;
+
 	if (unlikely(!task || !task->lldd_task || !task->dev))
-		return rc;
+		return TMF_RESP_FUNC_FAILED;
+
+	dev = task->dev;
+	pm8001_dev = dev->lldd_dev;
+	pm8001_ha = pm8001_find_ha_by_dev(dev);
+	device_id = pm8001_dev->device_id;
+	phy_id = pm8001_dev->attached_phy;
+	rc = pm8001_find_tag(task, &tag);
+	if (rc == 0) {
+		pm8001_printk("no tag for task:%p\n", task);
+		return TMF_RESP_FUNC_FAILED;
+	}
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
-		goto out;
+	}
+
+	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	if (task->slow_task == NULL) {
+		init_completion(&slow_task.completion);
+		task->slow_task = &slow_task;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
 	if (task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd *cmnd = task->uldd_task;
-		dev = task->dev;
-		ccb = task->lldd_task;
-		pm8001_dev = dev->lldd_dev;
-		pm8001_ha = pm8001_find_ha_by_dev(dev);
 		int_to_scsilun(cmnd->device->lun, &lun);
-		rc = pm8001_find_tag(task, &tag);
-		if (rc == 0) {
-			printk(KERN_INFO "No such tag in %s\n", __func__);
-			rc = TMF_RESP_FUNC_FAILED;
-			return rc;
-		}
-		device_id = pm8001_dev->device_id;
-		PM8001_EH_DBG(pm8001_ha,
-			pm8001_printk("abort io to deviceid= %d\n", device_id));
 		tmf_task.tmf = TMF_ABORT_TASK;
 		tmf_task.tag_of_task_to_be_managed = tag;
 		rc = pm8001_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
@@ -1200,33 +1207,75 @@ int pm8001_abort_task(struct sas_task *task)
 			pm8001_dev->sas_device, 0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
-		dev = task->dev;
-		pm8001_dev = dev->lldd_dev;
-		pm8001_ha = pm8001_find_ha_by_dev(dev);
-		rc = pm8001_find_tag(task, &tag);
-		if (rc == 0) {
-			printk(KERN_INFO "No such tag in %s\n", __func__);
-			rc = TMF_RESP_FUNC_FAILED;
-			return rc;
+		if (pm8001_ha->chip_id == chip_8006) {
+			DECLARE_COMPLETION_ONSTACK(completion_reset);
+			DECLARE_COMPLETION_ONSTACK(completion);
+			struct pm8001_phy *phy = pm8001_ha->phy + phy_id;
+
+			/* 1. Set Device state as Recovery*/
+			pm8001_dev->setds_completion = &completion;
+			PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
+				pm8001_dev, 0x03);
+			wait_for_completion(&completion);
+
+			/* 2. Send Phy Control Hard Reset */
+			reinit_completion(&completion);
+			phy->reset_success = false;
+			phy->enable_completion = &completion;
+			phy->reset_completion = &completion_reset;
+			ret = PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,
+				PHY_HARD_RESET);
+			if (ret)
+				goto out;
+			PM8001_MSG_DBG(pm8001_ha,
+				pm8001_printk("Waiting for local phy ctl\n"));
+			wait_for_completion(&completion);
+			if (!phy->reset_success)
+				goto out;
+
+			/* 3. Wait for Port Reset complete / Port reset TMO*/
+			PM8001_MSG_DBG(pm8001_ha,
+				pm8001_printk("Waiting for Port reset\n"));
+			wait_for_completion(&completion_reset);
+			if (phy->port_reset_status)
+				goto out;
+
+			/* 4. SATA Abort ALL
+			 * we wait for the task to be aborted so that the task
+			 * is removed from the ccb. on success the caller is
+			 * going to free the task.
+			 */
+			ret = pm8001_exec_internal_task_abort(pm8001_ha,
+				pm8001_dev, pm8001_dev->sas_device, 1, tag);
+			if (ret)
+				goto out;
+			ret = wait_for_completion_timeout(
+				&task->slow_task->completion,
+				PM8001_TASK_TIMEOUT * HZ);
+			if (!ret)
+				goto out;
+
+			/* 5. Set Device State as Operational */
+			reinit_completion(&completion);
+			pm8001_dev->setds_completion = &completion;
+			PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
+				pm8001_dev, 0x01);
+			wait_for_completion(&completion);
+		} else {
+			rc = pm8001_exec_internal_task_abort(pm8001_ha,
+				pm8001_dev, pm8001_dev->sas_device, 0, tag);
 		}
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-			pm8001_dev->sas_device, 0, tag);
+		rc = TMF_RESP_FUNC_COMPLETE;
 	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
-		dev = task->dev;
-		pm8001_dev = dev->lldd_dev;
-		pm8001_ha = pm8001_find_ha_by_dev(dev);
-		rc = pm8001_find_tag(task, &tag);
-		if (rc == 0) {
-			printk(KERN_INFO "No such tag in %s\n", __func__);
-			rc = TMF_RESP_FUNC_FAILED;
-			return rc;
-		}
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
 			pm8001_dev->sas_device, 0, tag);
-
 	}
 out:
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (task->slow_task == &slow_task)
+		task->slow_task = NULL;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 	if (rc != TMF_RESP_FUNC_COMPLETE)
 		pm8001_printk("rc= %d\n", rc);
 	return rc;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 2eb3b670bf45..e6c0da17966e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -358,8 +358,15 @@ struct pm8001_phy {
 	u8			phy_state;
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate;
+	struct completion	*reset_completion;
+	bool			port_reset_status;
+	bool			reset_success;
 };
 
+/* port reset status */
+#define PORT_RESET_SUCCESS	0x00
+#define PORT_RESET_TMO		0x01
+
 struct pm8001_device {
 	enum sas_device_type	dev_type;
 	struct domain_device	*sas_device;
@@ -628,6 +635,7 @@ struct pm8001_hba_info {
 	u32			smp_exp_mode;
 	const struct firmware 	*fw_image;
 	struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
+	u32			reset_in_progress;
 };
 
 struct pm8001_work {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a07b023c09bf..ae9252cf1706 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -597,6 +597,12 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &= 0xffff0000;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
 							PORT_RECOVERY_TIMEOUT;
+	if (pm8001_ha->chip_id == chip_8006) {
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &=
+								0x0000ffff;
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
+								0x140000;
+	}
 	pm8001_mw32(address, MAIN_PORT_RECOVERY_TIMER,
 			pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer);
 }
@@ -1775,6 +1781,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			"task 0x%p done with io_status 0x%x resp 0x%x "
 			"stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
+		if (t->slow_task)
+			complete(&t->slow_task->completion);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -3038,6 +3046,7 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
+	u32 port_sata = (phy->phy_type & PORT_TYPE_SATA);
 	port->port_state = portstate;
 	phy->identify.device_type = 0;
 	phy->phy_attached = 0;
@@ -3049,7 +3058,7 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk(" PortInvalid portID %d\n", port_id));
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" Last phy Down and port invalid\n"));
-		if (phy->phy_type & PORT_TYPE_SATA) {
+		if (port_sata) {
 			phy->phy_type = 0;
 			port->port_attached = 0;
 			pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
@@ -3071,7 +3080,7 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk(" Phy Down and PORT_LOSTCOMM\n"));
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" Last phy Down and port invalid\n"));
-		if (phy->phy_type & PORT_TYPE_SATA) {
+		if (port_sata) {
 			port->port_attached = 0;
 			phy->phy_type = 0;
 			pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
@@ -3087,6 +3096,11 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 
 	}
+	if (port_sata && (portstate != PORT_IN_RESET)) {
+		struct sas_ha_struct *sas_ha = pm8001_ha->sas;
+
+		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+	}
 }
 
 static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
@@ -3189,12 +3203,14 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_PHY_DOWN:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PHY_DOWN\n"));
-		if (phy->phy_type & PORT_TYPE_SATA)
-			sas_ha->notify_phy_event(&phy->sas_phy,
-				PHYE_LOSS_OF_SIGNAL);
+		hw_event_phy_down(pm8001_ha, piomb);
+		if (pm8001_ha->reset_in_progress) {
+			PM8001_MSG_DBG(pm8001_ha,
+				pm8001_printk("Reset in progress\n"));
+			return 0;
+		}
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
-		hw_event_phy_down(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_PORT_INVALID:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3301,9 +3317,17 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO\n"));
+		pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
+			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		if (pm8001_ha->phy[phy_id].reset_completion) {
+			pm8001_ha->phy[phy_id].port_reset_status =
+							PORT_RESET_TMO;
+			complete(pm8001_ha->phy[phy_id].reset_completion);
+			pm8001_ha->phy[phy_id].reset_completion = NULL;
+		}
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3328,6 +3352,12 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_PORT_RESET_COMPLETE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE\n"));
+		if (pm8001_ha->phy[phy_id].reset_completion) {
+			pm8001_ha->phy[phy_id].port_reset_status =
+							PORT_RESET_SUCCESS;
+			complete(pm8001_ha->phy[phy_id].reset_completion);
+			pm8001_ha->phy[phy_id].reset_completion = NULL;
+		}
 		break;
 	case EVENT_BROADCAST_ASYNCH_EVENT:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -4500,17 +4530,21 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op)
 {
+	u32 tag;
+	int rc;
 	struct local_phy_ctl_req payload;
 	struct inbound_queue_table *circularQ;
 	int ret;
 	u32 opc = OPC_INB_LOCAL_PHY_CONTROL;
 	memset(&payload, 0, sizeof(payload));
+	rc = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (rc)
+		return rc;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
-	payload.tag = cpu_to_le32(1);
+	payload.tag = cpu_to_le32(tag);
 	payload.phyop_phyid =
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
-	return ret;
+	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 }
 
 static u32 pm80xx_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
-- 
2.12.3
