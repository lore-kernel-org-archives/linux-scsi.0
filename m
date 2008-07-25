From: Denis ChengRq <crquan@gmail.com>
Subject: [PATCH 2/5] drivers/scsi/aic94xx/: replace __FUNCTION__ with __func__
Date: Fri, 25 Jul 2008 10:48:33 +0800
Message-ID: <1216954114-31949-1-git-send-email-crquan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:27792 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYGYCs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 22:48:57 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1613060tic.23
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2008 19:48:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 drivers/scsi/aic94xx/aic94xx.h      |    4 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c  |    2 +-
 drivers/scsi/aic94xx/aic94xx_scb.c  |   46 +++++++++++++++++-----------------
 drivers/scsi/aic94xx/aic94xx_task.c |    2 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |   18 +++++++-------
 5 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index 2ef459e..2863a9d 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -39,9 +39,9 @@
 
 #ifdef ASD_ENTER_EXIT
 #define ENTER  printk(KERN_NOTICE "%s: ENTER %s\n", ASD_DRIVER_NAME, \
-		__FUNCTION__)
+		__func__)
 #define EXIT   printk(KERN_NOTICE "%s: --EXIT %s\n", ASD_DRIVER_NAME, \
-		__FUNCTION__)
+		__func__)
 #else
 #define ENTER
 #define EXIT
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 83a7822..eb9dc31 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1359,7 +1359,7 @@ int asd_enable_phys(struct asd_ha_struct *asd_ha, const u8 phy_mask)
 	struct asd_ascb *ascb_list;
 
 	if (!phy_mask) {
-		asd_printk("%s called with phy_mask of 0!?\n", __FUNCTION__);
+		asd_printk("%s called with phy_mask of 0!?\n", __func__);
 		return 0;
 	}
 
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 4664331..7851f3c 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -211,7 +211,7 @@ static void asd_form_port(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
 		phy->asd_port = port;
 	}
 	ASD_DPRINTK("%s: updating phy_mask 0x%x for phy%d\n",
-		    __FUNCTION__, phy->asd_port->phy_mask, sas_phy->id);
+		    __func__, phy->asd_port->phy_mask, sas_phy->id);
 	asd_update_port_links(asd_ha, phy);
 	spin_unlock_irqrestore(&asd_ha->asd_ports_lock, flags);
 }
@@ -294,7 +294,7 @@ static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
 		struct asd_ascb *cp = asd_ascb_alloc_list(ascb->ha, &num,
 							  GFP_ATOMIC);
 		if (!cp) {
-			asd_printk("%s: out of memory\n", __FUNCTION__);
+			asd_printk("%s: out of memory\n", __func__);
 			goto out;
 		}
 		ASD_DPRINTK("phy%d: retries:0 performing link reset seq\n",
@@ -446,7 +446,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		struct domain_device *failed_dev = NULL;
 
 		ASD_DPRINTK("%s: REQ_TASK_ABORT, reason=0x%X\n",
-			    __FUNCTION__, dl->status_block[3]);
+			    __func__, dl->status_block[3]);
 
 		/*
 		 * Find the task that caused the abort and abort it first.
@@ -474,7 +474,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 
 		if (!failed_dev) {
 			ASD_DPRINTK("%s: Can't find task (tc=%d) to abort!\n",
-				    __FUNCTION__, tc_abort);
+				    __func__, tc_abort);
 			goto out;
 		}
 
@@ -502,7 +502,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		conn_handle = *((u16*)(&dl->status_block[1]));
 		conn_handle = le16_to_cpu(conn_handle);
 
-		ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason=0x%X\n", __FUNCTION__,
+		ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason=0x%X\n", __func__,
 			    dl->status_block[3]);
 
 		/* Find the last pending task for the device... */
@@ -522,7 +522,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 
 		if (!last_dev_task) {
 			ASD_DPRINTK("%s: Device reset for idle device %d?\n",
-				    __FUNCTION__, conn_handle);
+				    __func__, conn_handle);
 			goto out;
 		}
 
@@ -549,10 +549,10 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		goto out;
 	}
 	case SIGNAL_NCQ_ERROR:
-		ASD_DPRINTK("%s: SIGNAL_NCQ_ERROR\n", __FUNCTION__);
+		ASD_DPRINTK("%s: SIGNAL_NCQ_ERROR\n", __func__);
 		goto out;
 	case CLEAR_NCQ_ERROR:
-		ASD_DPRINTK("%s: CLEAR_NCQ_ERROR\n", __FUNCTION__);
+		ASD_DPRINTK("%s: CLEAR_NCQ_ERROR\n", __func__);
 		goto out;
 	}
 
@@ -560,26 +560,26 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 
 	switch (sb_opcode) {
 	case BYTES_DMAED:
-		ASD_DPRINTK("%s: phy%d: BYTES_DMAED\n", __FUNCTION__, phy_id);
+		ASD_DPRINTK("%s: phy%d: BYTES_DMAED\n", __func__, phy_id);
 		asd_bytes_dmaed_tasklet(ascb, dl, edb, phy_id);
 		break;
 	case PRIMITIVE_RECVD:
-		ASD_DPRINTK("%s: phy%d: PRIMITIVE_RECVD\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: PRIMITIVE_RECVD\n", __func__,
 			    phy_id);
 		asd_primitive_rcvd_tasklet(ascb, dl, phy_id);
 		break;
 	case PHY_EVENT:
-		ASD_DPRINTK("%s: phy%d: PHY_EVENT\n", __FUNCTION__, phy_id);
+		ASD_DPRINTK("%s: phy%d: PHY_EVENT\n", __func__, phy_id);
 		asd_phy_event_tasklet(ascb, dl);
 		break;
 	case LINK_RESET_ERROR:
-		ASD_DPRINTK("%s: phy%d: LINK_RESET_ERROR\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: LINK_RESET_ERROR\n", __func__,
 			    phy_id);
 		asd_link_reset_err_tasklet(ascb, dl, phy_id);
 		break;
 	case TIMER_EVENT:
 		ASD_DPRINTK("%s: phy%d: TIMER_EVENT, lost dw sync\n",
-			    __FUNCTION__, phy_id);
+			    __func__, phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		/* the device is gone */
 		sas_phy_disconnected(sas_phy);
@@ -587,7 +587,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		sas_ha->notify_port_event(sas_phy, PORTE_TIMER_EVENT);
 		break;
 	default:
-		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __func__,
 			    phy_id, sb_opcode);
 		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n",
 			    edb, dl->opcode);
@@ -654,7 +654,7 @@ static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 
 	if (status != 0) {
 		ASD_DPRINTK("%s: phy%d status block opcode:0x%x\n",
-			    __FUNCTION__, phy_id, status);
+			    __func__, phy_id, status);
 		goto out;
 	}
 
@@ -663,7 +663,7 @@ static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 		asd_ha->hw_prof.enabled_phys &= ~(1 << phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		asd_control_led(asd_ha, phy_id, 0);
-		ASD_DPRINTK("%s: disable phy%d\n", __FUNCTION__, phy_id);
+		ASD_DPRINTK("%s: disable phy%d\n", __func__, phy_id);
 		break;
 
 	case ENABLE_PHY:
@@ -673,40 +673,40 @@ static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 			get_lrate_mode(phy, oob_mode);
 			asd_turn_led(asd_ha, phy_id, 1);
 			ASD_DPRINTK("%s: phy%d, lrate:0x%x, proto:0x%x\n",
-				    __FUNCTION__, phy_id,phy->sas_phy.linkrate,
+				    __func__, phy_id, phy->sas_phy.linkrate,
 				    phy->sas_phy.iproto);
 		} else if (oob_status & CURRENT_SPINUP_HOLD) {
 			asd_ha->hw_prof.enabled_phys |= (1 << phy_id);
 			asd_turn_led(asd_ha, phy_id, 1);
-			ASD_DPRINTK("%s: phy%d, spinup hold\n", __FUNCTION__,
+			ASD_DPRINTK("%s: phy%d, spinup hold\n", __func__,
 				    phy_id);
 		} else if (oob_status & CURRENT_ERR_MASK) {
 			asd_turn_led(asd_ha, phy_id, 0);
 			ASD_DPRINTK("%s: phy%d: error: oob status:0x%02x\n",
-				    __FUNCTION__, phy_id, oob_status);
+				    __func__, phy_id, oob_status);
 		} else if (oob_status & (CURRENT_HOT_PLUG_CNCT
 					 | CURRENT_DEVICE_PRESENT))  {
 			asd_ha->hw_prof.enabled_phys |= (1 << phy_id);
 			asd_turn_led(asd_ha, phy_id, 1);
 			ASD_DPRINTK("%s: phy%d: hot plug or device present\n",
-				    __FUNCTION__, phy_id);
+				    __func__, phy_id);
 		} else {
 			asd_ha->hw_prof.enabled_phys |= (1 << phy_id);
 			asd_turn_led(asd_ha, phy_id, 0);
 			ASD_DPRINTK("%s: phy%d: no device present: "
 				    "oob_status:0x%x\n",
-				    __FUNCTION__, phy_id, oob_status);
+				    __func__, phy_id, oob_status);
 		}
 		break;
 	case RELEASE_SPINUP_HOLD:
 	case PHY_NO_OP:
 	case EXECUTE_HARD_RESET:
-		ASD_DPRINTK("%s: phy%d: sub_func:0x%x\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: sub_func:0x%x\n", __func__,
 			    phy_id, control_phy->sub_func);
 		/* XXX finish */
 		break;
 	default:
-		ASD_DPRINTK("%s: phy%d: sub_func:0x%x?\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: sub_func:0x%x?\n", __func__,
 			    phy_id, control_phy->sub_func);
 		break;
 	}
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 326765c..75d20f7 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -320,7 +320,7 @@ Again:
 	case TC_RESUME:
 	case TC_PARTIAL_SG_LIST:
 	default:
-		ASD_DPRINTK("%s: dl opcode: 0x%x?\n", __FUNCTION__, opcode);
+		ASD_DPRINTK("%s: dl opcode: 0x%x?\n", __func__, opcode);
 		break;
 	}
 
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 633ff40..d4640ef 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -75,12 +75,12 @@ static void asd_clear_nexus_tasklet_complete(struct asd_ascb *ascb,
 					     struct done_list_struct *dl)
 {
 	struct tasklet_completion_status *tcs = ascb->uldd_task;
-	ASD_DPRINTK("%s: here\n", __FUNCTION__);
+	ASD_DPRINTK("%s: here\n", __func__);
 	if (!del_timer(&ascb->timer)) {
-		ASD_DPRINTK("%s: couldn't delete timer\n", __FUNCTION__);
+		ASD_DPRINTK("%s: couldn't delete timer\n", __func__);
 		return;
 	}
-	ASD_DPRINTK("%s: opcode: 0x%x\n", __FUNCTION__, dl->opcode);
+	ASD_DPRINTK("%s: opcode: 0x%x\n", __func__, dl->opcode);
 	tcs->dl_opcode = dl->opcode;
 	complete(ascb->completion);
 	asd_ascb_free(ascb);
@@ -91,7 +91,7 @@ static void asd_clear_nexus_timedout(unsigned long data)
 	struct asd_ascb *ascb = (void *)data;
 	struct tasklet_completion_status *tcs = ascb->uldd_task;
 
-	ASD_DPRINTK("%s: here\n", __FUNCTION__);
+	ASD_DPRINTK("%s: here\n", __func__);
 	tcs->dl_opcode = TMF_RESP_FUNC_FAILED;
 	complete(ascb->completion);
 }
@@ -103,7 +103,7 @@ static void asd_clear_nexus_timedout(unsigned long data)
 	DECLARE_COMPLETION_ONSTACK(completion); \
 	DECLARE_TCS(tcs); \
 		\
-	ASD_DPRINTK("%s: PRE\n", __FUNCTION__); \
+	ASD_DPRINTK("%s: PRE\n", __func__); \
         res = 1;                \
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL); \
 	if (!ascb)              \
@@ -115,12 +115,12 @@ static void asd_clear_nexus_timedout(unsigned long data)
 	scb->header.opcode = CLEAR_NEXUS
 
 #define CLEAR_NEXUS_POST        \
-	ASD_DPRINTK("%s: POST\n", __FUNCTION__); \
+	ASD_DPRINTK("%s: POST\n", __func__); \
 	res = asd_enqueue_internal(ascb, asd_clear_nexus_tasklet_complete, \
 				   asd_clear_nexus_timedout);              \
 	if (res)                \
 		goto out_err;   \
-	ASD_DPRINTK("%s: clear nexus posted, waiting...\n", __FUNCTION__); \
+	ASD_DPRINTK("%s: clear nexus posted, waiting...\n", __func__); \
 	wait_for_completion(&completion); \
 	res = tcs.dl_opcode; \
 	if (res == TC_NO_ERROR) \
@@ -417,7 +417,7 @@ int asd_abort_task(struct sas_task *task)
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		res = TMF_RESP_FUNC_COMPLETE;
-		ASD_DPRINTK("%s: task 0x%p done\n", __FUNCTION__, task);
+		ASD_DPRINTK("%s: task 0x%p done\n", __func__, task);
 		goto out_done;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -481,7 +481,7 @@ int asd_abort_task(struct sas_task *task)
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		res = TMF_RESP_FUNC_COMPLETE;
-		ASD_DPRINTK("%s: task 0x%p done\n", __FUNCTION__, task);
+		ASD_DPRINTK("%s: task 0x%p done\n", __func__, task);
 		goto out_done;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-- 
1.5.6.3

