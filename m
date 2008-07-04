From: akpm@linux-foundation.org
Subject: [patch 06/16] scsi: replace remaining __FUNCTION__ occurrences
Date: Thu, 03 Jul 2008 23:47:27 -0700
Message-ID: <200807040647.m646lR4L017484@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936AbYGDGsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 02:48:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com

From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c               |    2 -
 drivers/scsi/aha152x.c                |   12 +++---
 drivers/scsi/aic94xx/aic94xx.h        |    4 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c    |    2 -
 drivers/scsi/aic94xx/aic94xx_scb.c    |   46 ++++++++++++------------
 drivers/scsi/aic94xx/aic94xx_task.c   |    2 -
 drivers/scsi/aic94xx/aic94xx_tmf.c    |   18 ++++-----
 drivers/scsi/arm/fas216.c             |    4 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c      |    2 -
 drivers/scsi/imm.c                    |    2 -
 drivers/scsi/ipr.h                    |    6 +--
 drivers/scsi/libsas/sas_ata.c         |   16 ++++----
 drivers/scsi/libsas/sas_expander.c    |   12 +++---
 drivers/scsi/libsas/sas_port.c        |    4 +-
 drivers/scsi/libsas/sas_scsi_host.c   |   28 +++++++-------
 drivers/scsi/libsrp.c                 |    2 -
 drivers/scsi/lpfc/lpfc_init.c         |    4 +-
 drivers/scsi/lpfc/lpfc_scsi.c         |    2 -
 drivers/scsi/lpfc/lpfc_sli.c          |    6 +--
 drivers/scsi/megaraid/mega_common.h   |    2 -
 drivers/scsi/megaraid/megaraid_mbox.c |   16 ++++----
 drivers/scsi/megaraid/megaraid_mm.c   |    4 +-
 drivers/scsi/nsp32.c                  |    4 +-
 drivers/scsi/nsp32_debug.c            |    2 -
 drivers/scsi/pcmcia/nsp_cs.c          |    4 +-
 drivers/scsi/pcmcia/nsp_debug.c       |    2 -
 drivers/scsi/ppa.c                    |    2 -
 drivers/scsi/qla1280.c                |   12 +++---
 drivers/scsi/scsi_debug.c             |   12 +++---
 drivers/scsi/scsi_devinfo.c           |    6 +--
 drivers/scsi/scsi_error.c             |   26 ++++++-------
 drivers/scsi/scsi_lib.c               |    6 +--
 drivers/scsi/scsi_netlink.c           |    8 ++--
 drivers/scsi/scsi_proc.c              |    4 +-
 drivers/scsi/scsi_scan.c              |   12 +++---
 drivers/scsi/scsi_tgt_priv.h          |    2 -
 drivers/scsi/scsi_transport_fc.c      |   12 +++---
 drivers/scsi/scsi_transport_sas.c     |    4 +-
 drivers/scsi/tmscsim.c                |    8 ++--
 drivers/scsi/wd7000.c                 |    8 ++--
 drivers/scsi/zalon.c                  |    8 ++--
 41 files changed, 169 insertions(+), 169 deletions(-)

diff -puN drivers/scsi/advansys.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/advansys.c
@@ -2278,7 +2278,7 @@ do { \
 #define ASC_DBG(lvl, format, arg...) {					\
 	if (asc_dbglvl >= (lvl))					\
 		printk(KERN_DEBUG "%s: %s: " format, DRV_NAME,		\
-			__FUNCTION__ , ## arg);				\
+			__func__ , ## arg);				\
 }
 
 #define ASC_DBG_PRT_SCSI_HOST(lvl, s) \
diff -puN drivers/scsi/aha152x.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/aha152x.c
@@ -288,20 +288,20 @@ static LIST_HEAD(aha152x_host_list);
 #define DO_LOCK(flags)	\
 	do { \
 		if(spin_is_locked(&QLOCK)) { \
-			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
 		} \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		spin_lock_irqsave(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
-		QLOCKER=__FUNCTION__; \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
+		QLOCKER=__func__; \
 		QLOCKERL=__LINE__; \
 	} while(0)
 
 #define DO_UNLOCK(flags)	\
 	do { \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
 		spin_unlock_irqrestore(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		QLOCKER="(not locked)"; \
 		QLOCKERL=0; \
 	} while(0)
diff -puN drivers/scsi/aic94xx/aic94xx.h~scsi-replace-remaining-__function__-occurrences drivers/scsi/aic94xx/aic94xx.h
--- a/drivers/scsi/aic94xx/aic94xx.h~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/aic94xx/aic94xx.h
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
diff -puN drivers/scsi/aic94xx/aic94xx_hwi.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/aic94xx/aic94xx_hwi.c
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1359,7 +1359,7 @@ int asd_enable_phys(struct asd_ha_struct
 	struct asd_ascb *ascb_list;
 
 	if (!phy_mask) {
-		asd_printk("%s called with phy_mask of 0!?\n", __FUNCTION__);
+		asd_printk("%s called with phy_mask of 0!?\n", __func__);
 		return 0;
 	}
 
diff -puN drivers/scsi/aic94xx/aic94xx_scb.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/aic94xx/aic94xx_scb.c
--- a/drivers/scsi/aic94xx/aic94xx_scb.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -211,7 +211,7 @@ static void asd_form_port(struct asd_ha_
 		phy->asd_port = port;
 	}
 	ASD_DPRINTK("%s: updating phy_mask 0x%x for phy%d\n",
-		    __FUNCTION__, phy->asd_port->phy_mask, sas_phy->id);
+		    __func__, phy->asd_port->phy_mask, sas_phy->id);
 	asd_update_port_links(asd_ha, phy);
 	spin_unlock_irqrestore(&asd_ha->asd_ports_lock, flags);
 }
@@ -294,7 +294,7 @@ static void asd_link_reset_err_tasklet(s
 		struct asd_ascb *cp = asd_ascb_alloc_list(ascb->ha, &num,
 							  GFP_ATOMIC);
 		if (!cp) {
-			asd_printk("%s: out of memory\n", __FUNCTION__);
+			asd_printk("%s: out of memory\n", __func__);
 			goto out;
 		}
 		ASD_DPRINTK("phy%d: retries:0 performing link reset seq\n",
@@ -446,7 +446,7 @@ static void escb_tasklet_complete(struct
 		struct domain_device *failed_dev = NULL;
 
 		ASD_DPRINTK("%s: REQ_TASK_ABORT, reason=0x%X\n",
-			    __FUNCTION__, dl->status_block[3]);
+			    __func__, dl->status_block[3]);
 
 		/*
 		 * Find the task that caused the abort and abort it first.
@@ -474,7 +474,7 @@ static void escb_tasklet_complete(struct
 
 		if (!failed_dev) {
 			ASD_DPRINTK("%s: Can't find task (tc=%d) to abort!\n",
-				    __FUNCTION__, tc_abort);
+				    __func__, tc_abort);
 			goto out;
 		}
 
@@ -502,7 +502,7 @@ static void escb_tasklet_complete(struct
 		conn_handle = *((u16*)(&dl->status_block[1]));
 		conn_handle = le16_to_cpu(conn_handle);
 
-		ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason=0x%X\n", __FUNCTION__,
+		ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason=0x%X\n", __func__,
 			    dl->status_block[3]);
 
 		/* Find the last pending task for the device... */
@@ -522,7 +522,7 @@ static void escb_tasklet_complete(struct
 
 		if (!last_dev_task) {
 			ASD_DPRINTK("%s: Device reset for idle device %d?\n",
-				    __FUNCTION__, conn_handle);
+				    __func__, conn_handle);
 			goto out;
 		}
 
@@ -549,10 +549,10 @@ static void escb_tasklet_complete(struct
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
 
@@ -560,26 +560,26 @@ static void escb_tasklet_complete(struct
 
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
@@ -587,7 +587,7 @@ static void escb_tasklet_complete(struct
 		sas_ha->notify_port_event(sas_phy, PORTE_TIMER_EVENT);
 		break;
 	default:
-		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __func__,
 			    phy_id, sb_opcode);
 		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n",
 			    edb, dl->opcode);
@@ -654,7 +654,7 @@ static void control_phy_tasklet_complete
 
 	if (status != 0) {
 		ASD_DPRINTK("%s: phy%d status block opcode:0x%x\n",
-			    __FUNCTION__, phy_id, status);
+			    __func__, phy_id, status);
 		goto out;
 	}
 
@@ -663,7 +663,7 @@ static void control_phy_tasklet_complete
 		asd_ha->hw_prof.enabled_phys &= ~(1 << phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		asd_control_led(asd_ha, phy_id, 0);
-		ASD_DPRINTK("%s: disable phy%d\n", __FUNCTION__, phy_id);
+		ASD_DPRINTK("%s: disable phy%d\n", __func__, phy_id);
 		break;
 
 	case ENABLE_PHY:
@@ -673,40 +673,40 @@ static void control_phy_tasklet_complete
 			get_lrate_mode(phy, oob_mode);
 			asd_turn_led(asd_ha, phy_id, 1);
 			ASD_DPRINTK("%s: phy%d, lrate:0x%x, proto:0x%x\n",
-				    __FUNCTION__, phy_id,phy->sas_phy.linkrate,
+				    __func__, phy_id,phy->sas_phy.linkrate,
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
diff -puN drivers/scsi/aic94xx/aic94xx_task.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/aic94xx/aic94xx_task.c
--- a/drivers/scsi/aic94xx/aic94xx_task.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/aic94xx/aic94xx_task.c
@@ -320,7 +320,7 @@ Again:
 	case TC_RESUME:
 	case TC_PARTIAL_SG_LIST:
 	default:
-		ASD_DPRINTK("%s: dl opcode: 0x%x?\n", __FUNCTION__, opcode);
+		ASD_DPRINTK("%s: dl opcode: 0x%x?\n", __func__, opcode);
 		break;
 	}
 
diff -puN drivers/scsi/aic94xx/aic94xx_tmf.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/aic94xx/aic94xx_tmf.c
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -75,12 +75,12 @@ static void asd_clear_nexus_tasklet_comp
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
@@ -91,7 +91,7 @@ static void asd_clear_nexus_timedout(uns
 	struct asd_ascb *ascb = (void *)data;
 	struct tasklet_completion_status *tcs = ascb->uldd_task;
 
-	ASD_DPRINTK("%s: here\n", __FUNCTION__);
+	ASD_DPRINTK("%s: here\n", __func__);
 	tcs->dl_opcode = TMF_RESP_FUNC_FAILED;
 	complete(ascb->completion);
 }
@@ -103,7 +103,7 @@ static void asd_clear_nexus_timedout(uns
 	DECLARE_COMPLETION_ONSTACK(completion); \
 	DECLARE_TCS(tcs); \
 		\
-	ASD_DPRINTK("%s: PRE\n", __FUNCTION__); \
+	ASD_DPRINTK("%s: PRE\n", __func__); \
         res = 1;                \
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL); \
 	if (!ascb)              \
@@ -115,12 +115,12 @@ static void asd_clear_nexus_timedout(uns
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
@@ -417,7 +417,7 @@ int asd_abort_task(struct sas_task *task
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		res = TMF_RESP_FUNC_COMPLETE;
-		ASD_DPRINTK("%s: task 0x%p done\n", __FUNCTION__, task);
+		ASD_DPRINTK("%s: task 0x%p done\n", __func__, task);
 		goto out_done;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -481,7 +481,7 @@ int asd_abort_task(struct sas_task *task
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		res = TMF_RESP_FUNC_COMPLETE;
-		ASD_DPRINTK("%s: task 0x%p done\n", __FUNCTION__, task);
+		ASD_DPRINTK("%s: task 0x%p done\n", __func__, task);
 		goto out_done;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
diff -puN drivers/scsi/arm/fas216.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/arm/fas216.c
--- a/drivers/scsi/arm/fas216.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/arm/fas216.c
@@ -240,7 +240,7 @@ static void __fas216_checkmagic(FAS216_I
 		panic("scsi memory space corrupted in %s", func);
 	}
 }
-#define fas216_checkmagic(info) __fas216_checkmagic((info), __FUNCTION__)
+#define fas216_checkmagic(info) __fas216_checkmagic((info), __func__)
 #else
 #define fas216_checkmagic(info)
 #endif
@@ -2658,7 +2658,7 @@ int fas216_eh_host_reset(struct scsi_cmn
 	fas216_checkmagic(info);
 
 	printk("scsi%d.%c: %s: resetting host\n",
-		info->host->host_no, '0' + SCpnt->device->id, __FUNCTION__);
+		info->host->host_no, '0' + SCpnt->device->id, __func__);
 
 	/*
 	 * Reset the SCSI chip.
diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/ibmvscsi/ibmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -55,7 +55,7 @@
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
diff -puN drivers/scsi/imm.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/imm.c
--- a/drivers/scsi/imm.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/imm.c
@@ -163,7 +163,7 @@ static int imm_proc_info(struct Scsi_Hos
 
 #if IMM_DEBUG > 0
 #define imm_fail(x,y) printk("imm: imm_fail(%i) from %s at line %d\n",\
-	   y, __FUNCTION__, __LINE__); imm_fail_func(x,y);
+	   y, __func__, __LINE__); imm_fail_func(x,y);
 static inline void
 imm_fail_func(imm_struct *dev, int error_code)
 #else
diff -puN drivers/scsi/ipr.h~scsi-replace-remaining-__function__-occurrences drivers/scsi/ipr.h
--- a/drivers/scsi/ipr.h~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/ipr.h
@@ -1403,10 +1403,10 @@ struct ipr_ucode_image_header {
 }
 
 #define ipr_trace ipr_dbg("%s: %s: Line: %d\n",\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 
-#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __FUNCTION__))
-#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __FUNCTION__))
+#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __func__))
+#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __func__))
 
 #define ipr_err_separator \
 ipr_err("----------------------------------------------------------\n")
diff -puN drivers/scsi/libsas/sas_ata.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -74,7 +74,7 @@ static enum ata_completion_errors sas_to
 		case SAS_OPEN_TO:
 		case SAS_OPEN_REJECT:
 			SAS_DPRINTK("%s: Saw error %d.  What to do?\n",
-				    __FUNCTION__, ts->stat);
+				    __func__, ts->stat);
 			return AC_ERR_OTHER;
 
 		case SAS_ABORTED_TASK:
@@ -115,7 +115,7 @@ static void sas_ata_task_done(struct sas
 	} else if (stat->stat != SAM_STAT_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
-			SAS_DPRINTK("%s: SAS error %x\n", __FUNCTION__,
+			SAS_DPRINTK("%s: SAS error %x\n", __func__,
 				    stat->stat);
 			/* We saw a SAS error. Send a vague error. */
 			qc->err_mask = ac;
@@ -244,20 +244,20 @@ static void sas_ata_phy_reset(struct ata
 		res = i->dft->lldd_I_T_nexus_reset(dev);
 
 	if (res != TMF_RESP_FUNC_COMPLETE)
-		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __FUNCTION__);
+		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __func__);
 
 	switch (dev->sata_dev.command_set) {
 		case ATA_COMMAND_SET:
-			SAS_DPRINTK("%s: Found ATA device.\n", __FUNCTION__);
+			SAS_DPRINTK("%s: Found ATA device.\n", __func__);
 			ap->link.device[0].class = ATA_DEV_ATA;
 			break;
 		case ATAPI_COMMAND_SET:
-			SAS_DPRINTK("%s: Found ATAPI device.\n", __FUNCTION__);
+			SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
 			ap->link.device[0].class = ATA_DEV_ATAPI;
 			break;
 		default:
 			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
-				    __FUNCTION__,
+				    __func__,
 				    dev->sata_dev.command_set);
 			ap->link.device[0].class = ATA_DEV_UNKNOWN;
 			break;
@@ -299,7 +299,7 @@ static int sas_ata_scr_write(struct ata_
 {
 	struct domain_device *dev = ap->private_data;
 
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
+	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
 		case SCR_STATUS:
 			dev->sata_dev.sstatus = val;
@@ -324,7 +324,7 @@ static int sas_ata_scr_read(struct ata_p
 {
 	struct domain_device *dev = ap->private_data;
 
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
+	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
 		case SCR_STATUS:
 			*val = dev->sata_dev.sstatus;
diff -puN drivers/scsi/libsas/sas_expander.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/libsas/sas_expander.c
--- a/drivers/scsi/libsas/sas_expander.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/libsas/sas_expander.c
@@ -121,7 +121,7 @@ static int smp_execute_task(struct domai
 			break;
 		} else {
 			SAS_DPRINTK("%s: task to dev %016llx response: 0x%x "
-				    "status 0x%x\n", __FUNCTION__,
+				    "status 0x%x\n", __func__,
 				    SAS_ADDR(dev->sas_addr),
 				    task->task_status.resp,
 				    task->task_status.stat);
@@ -1279,7 +1279,7 @@ static int sas_configure_present(struct 
 			goto out;
 		} else if (res != SMP_RESP_FUNC_ACC) {
 			SAS_DPRINTK("%s: dev %016llx phy 0x%x index 0x%x "
-				    "result 0x%x\n", __FUNCTION__,
+				    "result 0x%x\n", __func__,
 				    SAS_ADDR(dev->sas_addr), phy_id, i, res);
 			goto out;
 		}
@@ -1901,7 +1901,7 @@ int sas_smp_handler(struct Scsi_Host *sh
 
 	if (!rsp) {
 		printk("%s: space for a smp response is missing\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EINVAL;
 	}
 
@@ -1914,20 +1914,20 @@ int sas_smp_handler(struct Scsi_Host *sh
 	if (type != SAS_EDGE_EXPANDER_DEVICE &&
 	    type != SAS_FANOUT_EXPANDER_DEVICE) {
 		printk("%s: can we send a smp request to a device?\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EINVAL;
 	}
 
 	dev = sas_find_dev_by_rphy(rphy);
 	if (!dev) {
-		printk("%s: fail to find a domain_device?\n", __FUNCTION__);
+		printk("%s: fail to find a domain_device?\n", __func__);
 		return -EINVAL;
 	}
 
 	/* do we need to support multiple segments? */
 	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
 		printk("%s: multiple segments req %u %u, rsp %u %u\n",
-		       __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		       __func__, req->bio->bi_vcnt, req->data_len,
 		       rsp->bio->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
diff -puN drivers/scsi/libsas/sas_port.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/libsas/sas_port.c
--- a/drivers/scsi/libsas/sas_port.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/libsas/sas_port.c
@@ -50,7 +50,7 @@ static void sas_form_port(struct asd_sas
 			sas_deform_port(phy);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
-				    __FUNCTION__, phy->id, phy->port->id,
+				    __func__, phy->id, phy->port->id,
 				    phy->port->num_phys);
 			return;
 		}
@@ -78,7 +78,7 @@ static void sas_form_port(struct asd_sas
 
 	if (i >= sas_ha->num_phys) {
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",
-		       __FUNCTION__);
+		       __func__);
 		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 		return;
 	}
diff -puN drivers/scsi/libsas/sas_scsi_host.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -343,7 +343,7 @@ static enum task_disposition sas_scsi_fi
 						       flags);
 				SAS_DPRINTK("%s: task 0x%p aborted from "
 					    "task_queue\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_ABORTED;
 			}
 		}
@@ -351,13 +351,13 @@ static enum task_disposition sas_scsi_fi
 	}
 
 	for (i = 0; i < 5; i++) {
-		SAS_DPRINTK("%s: aborting task 0x%p\n", __FUNCTION__, task);
+		SAS_DPRINTK("%s: aborting task 0x%p\n", __func__, task);
 		res = si->dft->lldd_abort_task(task);
 
 		spin_lock_irqsave(&task->task_state_lock, flags);
 		if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 			spin_unlock_irqrestore(&task->task_state_lock, flags);
-			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
+			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
 			return TASK_IS_DONE;
 		}
@@ -365,24 +365,24 @@ static enum task_disposition sas_scsi_fi
 
 		if (res == TMF_RESP_FUNC_COMPLETE) {
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			return TASK_IS_ABORTED;
 		} else if (si->dft->lldd_query_task) {
 			SAS_DPRINTK("%s: querying task 0x%p\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			res = si->dft->lldd_query_task(task);
 			switch (res) {
 			case TMF_RESP_FUNC_SUCC:
 				SAS_DPRINTK("%s: task 0x%p at LU\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_AT_LU;
 			case TMF_RESP_FUNC_COMPLETE:
 				SAS_DPRINTK("%s: task 0x%p not at LU\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_NOT_AT_LU;
 			case TMF_RESP_FUNC_FAILED:
                                 SAS_DPRINTK("%s: task 0x%p failed to abort\n",
-                                                __FUNCTION__, task);
+                                                __func__, task);
                                 return TASK_ABORT_FAILED;
                         }
 
@@ -556,13 +556,13 @@ Again:
 
 		switch (res) {
 		case TASK_IS_DONE:
-			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
+			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
 			sas_eh_finish_cmd(cmd);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			sas_eh_finish_cmd(cmd);
 			continue;
 		case TASK_IS_AT_LU:
@@ -633,7 +633,7 @@ Again:
 	}
 	return list_empty(work_q);
 clear_q:
-	SAS_DPRINTK("--- Exit %s -- clear_q\n", __FUNCTION__);
+	SAS_DPRINTK("--- Exit %s -- clear_q\n", __func__);
 	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
 		sas_eh_finish_cmd(cmd);
 
@@ -650,7 +650,7 @@ void sas_scsi_recover_host(struct Scsi_H
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	SAS_DPRINTK("Enter %s\n", __FUNCTION__);
+	SAS_DPRINTK("Enter %s\n", __func__);
 	/*
 	 * Deal with commands that still have SAS tasks (i.e. they didn't
 	 * complete via the normal sas_task completion mechanism)
@@ -669,7 +669,7 @@ void sas_scsi_recover_host(struct Scsi_H
 
 out:
 	scsi_eh_flush_done_q(&ha->eh_done_q);
-	SAS_DPRINTK("--- Exit %s\n", __FUNCTION__);
+	SAS_DPRINTK("--- Exit %s\n", __func__);
 	return;
 }
 
@@ -990,7 +990,7 @@ int __sas_task_abort(struct sas_task *ta
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED ||
 	    task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		SAS_DPRINTK("%s: Task %p already finished.\n", __FUNCTION__,
+		SAS_DPRINTK("%s: Task %p already finished.\n", __func__,
 			    task);
 		return 0;
 	}
diff -puN drivers/scsi/libsrp.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/libsrp.c
@@ -39,7 +39,7 @@ enum srp_task_attributes {
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
diff -puN drivers/scsi/lpfc/lpfc_init.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -2083,7 +2083,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		if (iocbq_entry == NULL) {
 			printk(KERN_ERR "%s: only allocated %d iocbs of "
 				"expected %d count. Unloading driver.\n",
-				__FUNCTION__, i, LPFC_IOCB_LIST_CNT);
+				__func__, i, LPFC_IOCB_LIST_CNT);
 			error = -ENOMEM;
 			goto out_free_iocbq;
 		}
@@ -2093,7 +2093,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 			kfree (iocbq_entry);
 			printk(KERN_ERR "%s: failed to allocate IOTAG. "
 			       "Unloading driver.\n",
-				__FUNCTION__);
+				__func__);
 			error = -ENOMEM;
 			goto out_free_iocbq;
 		}
diff -puN drivers/scsi/lpfc/lpfc_scsi.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/lpfc/lpfc_scsi.c
@@ -341,7 +341,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
 			printk(KERN_ERR "%s: Too many sg segments from "
 			       "dma_map_sg.  Config %d, seg_cnt %d",
-			       __FUNCTION__, phba->cfg_sg_seg_cnt,
+			       __func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
 			scsi_dma_unmap(scsi_cmnd);
 			return 1;
diff -puN drivers/scsi/lpfc/lpfc_sli.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -219,7 +219,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_IOCB_LOGENTRY_CN:
 	case CMD_IOCB_LOGENTRY_ASYNC_CN:
 		printk("%s - Unhandled SLI-3 Command x%x\n",
-				__FUNCTION__, iocb_cmnd);
+				__func__, iocb_cmnd);
 		type = LPFC_UNKNOWN_IOCB;
 		break;
 	default:
@@ -1715,7 +1715,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 		rspiocbp = __lpfc_sli_get_iocbq(phba);
 		if (rspiocbp == NULL) {
 			printk(KERN_ERR "%s: out of buffers! Failing "
-			       "completion.\n", __FUNCTION__);
+			       "completion.\n", __func__);
 			break;
 		}
 
@@ -3793,7 +3793,7 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 		break;
 	default:
 		printk(KERN_ERR "%s: Unknown context cmd type, value %d\n",
-			__FUNCTION__, ctx_cmd);
+			__func__, ctx_cmd);
 		break;
 	}
 
diff -puN drivers/scsi/megaraid/mega_common.h~scsi-replace-remaining-__function__-occurrences drivers/scsi/megaraid/mega_common.h
--- a/drivers/scsi/megaraid/mega_common.h~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/megaraid/mega_common.h
@@ -265,7 +265,7 @@ typedef struct {
 #define ASSERT(expression)						\
 	if (!(expression)) {						\
 	ASSERT_ACTION("assertion failed:(%s), file: %s, line: %d:%s\n",	\
-			#expression, __FILE__, __LINE__, __FUNCTION__);	\
+			#expression, __FILE__, __LINE__, __func__);	\
 	}
 #else
 #define ASSERT(expression)
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -458,7 +458,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 
 	if (adapter == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-		"megaraid: out of memory, %s %d.\n", __FUNCTION__, __LINE__));
+		"megaraid: out of memory, %s %d.\n", __func__, __LINE__));
 
 		goto out_probe_one;
 	}
@@ -1002,7 +1002,7 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 
 	if (!raid_dev->una_mbox64) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		return -1;
 	}
@@ -1030,7 +1030,7 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 	if (!adapter->ibuf) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		goto out_free_common_mbox;
@@ -1052,7 +1052,7 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 
 	if (adapter->kscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		goto out_free_ibuf;
 	}
@@ -1060,7 +1060,7 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 	// memory allocation for our command packets
 	if (megaraid_mbox_setup_dma_pools(adapter) != 0) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		goto out_free_scb_list;
 	}
@@ -2981,7 +2981,7 @@ megaraid_mbox_product_info(adapter_t *ad
 
 	if (pinfo == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		return -1;
@@ -3508,7 +3508,7 @@ megaraid_cmm_register(adapter_t *adapter
 
 	if (adapter->uscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		return -1;
 	}
@@ -3879,7 +3879,7 @@ megaraid_sysfs_alloc_resources(adapter_t
 		!raid_dev->sysfs_buffer) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		rval = -ENOMEM;
diff -puN drivers/scsi/megaraid/megaraid_mm.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/megaraid/megaraid_mm.c
--- a/drivers/scsi/megaraid/megaraid_mm.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/megaraid/megaraid_mm.c
@@ -929,7 +929,7 @@ mraid_mm_register_adp(mraid_mmadp_t *lld
 			!adapter->pthru_dma_pool) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid cmm: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid cmm: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		rval = (-ENOMEM);
@@ -957,7 +957,7 @@ mraid_mm_register_adp(mraid_mmadp_t *lld
 
 			con_log(CL_ANN, (KERN_WARNING
 				"megaraid cmm: out of memory, %s %d\n",
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 
 			rval = (-ENOMEM);
 
diff -puN drivers/scsi/nsp32.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/nsp32.c
@@ -299,9 +299,9 @@ static struct scsi_host_template nsp32_t
 #else
 # define NSP32_DEBUG_MASK	      0xffffff
 # define nsp32_msg(type, args...) \
-	nsp32_message (__FUNCTION__, __LINE__, (type), args)
+	nsp32_message (__func__, __LINE__, (type), args)
 # define nsp32_dbg(mask, args...) \
-	nsp32_dmessage(__FUNCTION__, __LINE__, (mask), args)
+	nsp32_dmessage(__func__, __LINE__, (mask), args)
 #endif
 
 #define NSP32_DEBUG_QUEUECOMMAND	BIT(0)
diff -puN drivers/scsi/nsp32_debug.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/nsp32_debug.c
--- a/drivers/scsi/nsp32_debug.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/nsp32_debug.c
@@ -88,7 +88,7 @@ static void print_commandk (unsigned cha
 	int i,s;
 //	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG "%s ", __func__);*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
 		s = 12; /* vender specific */
diff -puN drivers/scsi/pcmcia/nsp_cs.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -107,9 +107,9 @@ static nsp_hw_data nsp_data_base; /* att
 #else
 # define NSP_DEBUG_MASK		0xffffff
 # define nsp_msg(type, args...) \
-	nsp_cs_message (__FUNCTION__, __LINE__, (type), args)
+	nsp_cs_message (__func__, __LINE__, (type), args)
 # define nsp_dbg(mask, args...) \
-	nsp_cs_dmessage(__FUNCTION__, __LINE__, (mask), args)
+	nsp_cs_dmessage(__func__, __LINE__, (mask), args)
 #endif
 
 #define NSP_DEBUG_QUEUECOMMAND		BIT(0)
diff -puN drivers/scsi/pcmcia/nsp_debug.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/pcmcia/nsp_debug.c
--- a/drivers/scsi/pcmcia/nsp_debug.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/pcmcia/nsp_debug.c
@@ -90,7 +90,7 @@ static void print_commandk (unsigned cha
 	int i, s;
 	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG "%s ", __func__);*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
 		s = 12; /* vender specific */
diff -puN drivers/scsi/ppa.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/ppa.c
--- a/drivers/scsi/ppa.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/ppa.c
@@ -171,7 +171,7 @@ static int device_check(ppa_struct *dev)
 
 #if PPA_DEBUG > 0
 #define ppa_fail(x,y) printk("ppa: ppa_fail(%i) from %s at line %d\n",\
-	   y, __FUNCTION__, __LINE__); ppa_fail_func(x,y);
+	   y, __func__, __LINE__); ppa_fail_func(x,y);
 static inline void ppa_fail_func(ppa_struct *dev, int error_code)
 #else
 static inline void ppa_fail(ppa_struct *dev, int error_code)
diff -puN drivers/scsi/qla1280.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/qla1280.c
@@ -1695,7 +1695,7 @@ qla1280_load_firmware_dma(struct scsi_ql
 	risc_code_size = *ql1280_board_tbl[ha->devnum].fwlen;
 
 	dprintk(1, "%s: DMA RISC code (%i) words\n",
-			__FUNCTION__, risc_code_size);
+			__func__, risc_code_size);
 
 	num = 0;
 	while (risc_code_size > 0) {
@@ -1721,7 +1721,7 @@ qla1280_load_firmware_dma(struct scsi_ql
 		mb[7] = pci_dma_hi32(ha->request_dma) & 0xffff;
 		mb[6] = pci_dma_hi32(ha->request_dma) >> 16;
 		dprintk(2, "%s: op=%d  0x%p = 0x%4x,0x%4x,0x%4x,0x%4x\n",
-				__FUNCTION__, mb[0],
+				__func__, mb[0],
 				(void *)(long)ha->request_dma,
 				mb[6], mb[7], mb[2], mb[3]);
 		err = qla1280_mailbox_command(ha, BIT_4 | BIT_3 | BIT_2 |
@@ -1753,10 +1753,10 @@ qla1280_load_firmware_dma(struct scsi_ql
 			if (tbuf[i] != sp[i] && warn++ < 10) {
 				printk(KERN_ERR "%s: FW compare error @ "
 						"byte(0x%x) loop#=%x\n",
-						__FUNCTION__, i, num);
+						__func__, i, num);
 				printk(KERN_ERR "%s: FWbyte=%x  "
 						"FWfromChip=%x\n",
-						__FUNCTION__, sp[i], tbuf[i]);
+						__func__, sp[i], tbuf[i]);
 				/*break; */
 			}
 		}
@@ -1781,7 +1781,7 @@ qla1280_start_firmware(struct scsi_qla_h
 	int err;
 
 	dprintk(1, "%s: Verifying checksum of loaded RISC code.\n",
-			__FUNCTION__);
+			__func__);
 
 	/* Verify checksum of loaded RISC code. */
 	mb[0] = MBC_VERIFY_CHECKSUM;
@@ -1794,7 +1794,7 @@ qla1280_start_firmware(struct scsi_qla_h
 	}
 
 	/* Start firmware execution. */
-	dprintk(1, "%s: start firmware running.\n", __FUNCTION__);
+	dprintk(1, "%s: start firmware running.\n", __func__);
 	mb[0] = MBC_EXECUTE_FIRMWARE;
 	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
 	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
diff -puN drivers/scsi/scsi_debug.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_debug.c
@@ -1753,7 +1753,7 @@ static struct sdebug_dev_info * devInfoR
 		open_devip = sdebug_device_create(sdbg_host, GFP_ATOMIC);
 		if (!open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
-				__FUNCTION__, __LINE__);
+				__func__, __LINE__);
 			return NULL;
 		}
 	}
@@ -2656,7 +2656,7 @@ static int sdebug_add_adapter(void)
         sdbg_host = kzalloc(sizeof(*sdbg_host),GFP_KERNEL);
         if (NULL == sdbg_host) {
                 printk(KERN_ERR "%s: out of memory at line %d\n",
-                       __FUNCTION__, __LINE__);
+                       __func__, __LINE__);
                 return -ENOMEM;
         }
 
@@ -2667,7 +2667,7 @@ static int sdebug_add_adapter(void)
 		sdbg_devinfo = sdebug_device_create(sdbg_host, GFP_KERNEL);
 		if (!sdbg_devinfo) {
                         printk(KERN_ERR "%s: out of memory at line %d\n",
-                               __FUNCTION__, __LINE__);
+                               __func__, __LINE__);
                         error = -ENOMEM;
 			goto clean;
                 }
@@ -2987,7 +2987,7 @@ static int sdebug_driver_probe(struct de
 
         hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
         if (NULL == hpnt) {
-                printk(KERN_ERR "%s: scsi_register failed\n", __FUNCTION__);
+                printk(KERN_ERR "%s: scsi_register failed\n", __func__);
                 error = -ENODEV;
 		return error;
         }
@@ -3002,7 +3002,7 @@ static int sdebug_driver_probe(struct de
 
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
-                printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
+                printk(KERN_ERR "%s: scsi_add_host failed\n", __func__);
                 error = -ENODEV;
 		scsi_host_put(hpnt);
         } else
@@ -3021,7 +3021,7 @@ static int sdebug_driver_remove(struct d
 
 	if (!sdbg_host) {
 		printk(KERN_ERR "%s: Unable to locate host info\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENODEV;
 	}
 
diff -puN drivers/scsi/scsi_devinfo.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_devinfo.c
@@ -272,7 +272,7 @@ static void scsi_strcpy_devinfo(char *na
 	}
 	if (from_length > to_length)
 		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
-			__FUNCTION__, name, from);
+			__func__, name, from);
 }
 
 /**
@@ -298,7 +298,7 @@ static int scsi_dev_info_list_add(int co
 
 	devinfo = kmalloc(sizeof(*devinfo), GFP_KERNEL);
 	if (!devinfo) {
-		printk(KERN_ERR "%s: no memory\n", __FUNCTION__);
+		printk(KERN_ERR "%s: no memory\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -363,7 +363,7 @@ static int scsi_dev_info_list_add_str(ch
 			strflags = strsep(&next, next_check);
 		if (!model || !strflags) {
 			printk(KERN_ERR "%s: bad dev info string '%s' '%s'"
-			       " '%s'\n", __FUNCTION__, vendor, model,
+			       " '%s'\n", __func__, vendor, model,
 			       strflags);
 			res = -EINVAL;
 		} else
diff -puN drivers/scsi/scsi_error.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_error.c
@@ -139,7 +139,7 @@ void scsi_add_timer(struct scsi_cmnd *sc
 	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p, time:"
-					  " %d, (%p)\n", __FUNCTION__,
+					  " %d, (%p)\n", __func__,
 					  scmd, timeout, complete));
 
 	add_timer(&scmd->eh_timeout);
@@ -163,7 +163,7 @@ int scsi_delete_timer(struct scsi_cmnd *
 	rtn = del_timer(&scmd->eh_timeout);
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p,"
-					 " rtn: %d\n", __FUNCTION__,
+					 " rtn: %d\n", __func__,
 					 scmd, rtn));
 
 	scmd->eh_timeout.data = (unsigned long)NULL;
@@ -233,7 +233,7 @@ int scsi_block_when_processing_errors(st
 
 	online = scsi_device_online(sdev);
 
-	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __FUNCTION__,
+	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __func__,
 					  online));
 
 	return online;
@@ -271,7 +271,7 @@ static inline void scsi_eh_prt_fail_stat
 			SCSI_LOG_ERROR_RECOVERY(3,
 				sdev_printk(KERN_INFO, sdev,
 					    "%s: cmds failed: %d, cancel: %d\n",
-					    __FUNCTION__, cmd_failed,
+					    __func__, cmd_failed,
 					    cmd_cancel));
 			cmd_cancel = 0;
 			cmd_failed = 0;
@@ -470,7 +470,7 @@ static void scsi_eh_done(struct scsi_cmn
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s scmd: %p result: %x\n",
-			__FUNCTION__, scmd, scmd->result));
+			__func__, scmd, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
 	if (eh_action)
@@ -487,7 +487,7 @@ static int scsi_try_host_reset(struct sc
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
-					  __FUNCTION__));
+					  __func__));
 
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
@@ -516,7 +516,7 @@ static int scsi_try_bus_reset(struct scs
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
-					  __FUNCTION__));
+					  __func__));
 
 	if (!scmd->device->host->hostt->eh_bus_reset_handler)
 		return FAILED;
@@ -766,7 +766,7 @@ static int scsi_send_eh_cmnd(struct scsi
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: scmd: %p, timeleft: %ld\n",
-			__FUNCTION__, scmd, timeleft));
+			__func__, scmd, timeleft));
 
 	/*
 	 * If there is time left scsi_eh_done got called, and we will
@@ -778,7 +778,7 @@ static int scsi_send_eh_cmnd(struct scsi
 		rtn = scsi_eh_completed_normally(scmd);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			printk("%s: scsi_eh_completed_normally %x\n",
-			       __FUNCTION__, rtn));
+			       __func__, rtn));
 
 		switch (rtn) {
 		case SUCCESS:
@@ -913,7 +913,7 @@ retry_tur:
 	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6, SENSE_TIMEOUT, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
-		__FUNCTION__, scmd, rtn));
+		__func__, scmd, rtn));
 
 	switch (rtn) {
 	case NEEDS_RETRY:
@@ -1296,7 +1296,7 @@ int scsi_decide_disposition(struct scsi_
 	if (!scsi_device_online(scmd->device)) {
 		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
 						  " as SUCCESS\n",
-						  __FUNCTION__));
+						  __func__));
 		return SUCCESS;
 	}
 
@@ -1511,7 +1511,7 @@ static void scsi_restart_operations(stru
 	 * ioctls to queued block devices.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
-					  __FUNCTION__));
+					  __func__));
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RUNNING))
@@ -1835,7 +1835,7 @@ scsi_reset_provider(struct scsi_device *
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: waking up host to restart after TMF\n",
-		__FUNCTION__));
+		__func__));
 
 	wake_up(&shost->host_wait);
 
diff -puN drivers/scsi/scsi_lib.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_lib.c
@@ -1359,7 +1359,7 @@ static void scsi_kill_request(struct req
 
 	if (unlikely(cmd == NULL)) {
 		printk(KERN_CRIT "impossible request in %s.\n",
-				 __FUNCTION__);
+				 __func__);
 		BUG();
 	}
 
@@ -1483,7 +1483,7 @@ static void scsi_request_fn(struct reque
 			printk(KERN_CRIT "impossible request in %s.\n"
 					 "please mail a stack trace to "
 					 "linux-scsi@vger.kernel.org\n",
-					 __FUNCTION__);
+					 __func__);
 			blk_dump_rq_flags(req, "foo");
 			BUG();
 		}
@@ -2478,7 +2478,7 @@ void *scsi_kmap_atomic_sg(struct scatter
 	if (unlikely(i == sg_count)) {
 		printk(KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, "
 			"elements %d\n",
-		       __FUNCTION__, sg_len, *offset, sg_count);
+		       __func__, sg_len, *offset, sg_count);
 		WARN_ON(1);
 		return NULL;
 	}
diff -puN drivers/scsi/scsi_netlink.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_netlink.c
--- a/drivers/scsi/scsi_netlink.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_netlink.c
@@ -55,7 +55,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
 		if ((nlh->nlmsg_len < (sizeof(*nlh) + sizeof(*hdr))) ||
 		    (skb->len < nlh->nlmsg_len)) {
 			printk(KERN_WARNING "%s: discarding partial skb\n",
-				 __FUNCTION__);
+				 __func__);
 			return;
 		}
 
@@ -82,7 +82,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
 
 		if (nlh->nlmsg_len < (sizeof(*nlh) + hdr->msglen)) {
 			printk(KERN_WARNING "%s: discarding partial message\n",
-				 __FUNCTION__);
+				 __func__);
 			return;
 		}
 
@@ -139,7 +139,7 @@ scsi_netlink_init(void)
 	error = netlink_register_notifier(&scsi_netlink_notifier);
 	if (error) {
 		printk(KERN_ERR "%s: register of event handler failed - %d\n",
-				__FUNCTION__, error);
+				__func__, error);
 		return;
 	}
 
@@ -148,7 +148,7 @@ scsi_netlink_init(void)
 				THIS_MODULE);
 	if (!scsi_nl_sock) {
 		printk(KERN_ERR "%s: register of recieve handler failed\n",
-				__FUNCTION__);
+				__func__);
 		netlink_unregister_notifier(&scsi_netlink_notifier);
 	}
 
diff -puN drivers/scsi/scsi_proc.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_proc.c
@@ -114,7 +114,7 @@ void scsi_proc_hostdir_add(struct scsi_h
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
         	if (!sht->proc_dir)
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
-			       __FUNCTION__, sht->proc_name);
+			       __func__, sht->proc_name);
 		else
 			sht->proc_dir->owner = sht->module;
 	}
@@ -157,7 +157,7 @@ void scsi_proc_host_add(struct Scsi_Host
 			sht->proc_dir, proc_scsi_read, shost);
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
-		       "%s\n", __FUNCTION__, shost->host_no,
+		       "%s\n", __func__, shost->host_no,
 		       sht->proc_name);
 		return;
 	} 
diff -puN drivers/scsi/scsi_scan.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_scan.c
@@ -318,7 +318,7 @@ out_device_destroy:
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		printk(ALLOC_FAILURE_MSG, __func__);
 	return NULL;
 }
 
@@ -404,7 +404,7 @@ static struct scsi_target *scsi_alloc_ta
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
 	}
 	dev = &starget->dev;
@@ -1337,7 +1337,7 @@ static int scsi_report_lun_scan(struct s
 	lun_data = kmalloc(length, GFP_ATOMIC |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
 	}
 
@@ -1649,7 +1649,7 @@ int scsi_scan_host_selected(struct Scsi_
 {
 	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
 		"%s: <%u:%u:%u>\n",
-		__FUNCTION__, channel, id, lun));
+		__func__, channel, id, lun));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
@@ -1703,7 +1703,7 @@ static struct async_scan_data *scsi_prep
 		return NULL;
 
 	if (shost->async_scan) {
-		printk("%s called twice for host %d", __FUNCTION__,
+		printk("%s called twice for host %d", __func__,
 				shost->host_no);
 		dump_stack();
 		return NULL;
@@ -1757,7 +1757,7 @@ static void scsi_finish_async_scan(struc
 	mutex_lock(&shost->scan_mutex);
 
 	if (!shost->async_scan) {
-		printk("%s called twice for host %d", __FUNCTION__,
+		printk("%s called twice for host %d", __func__,
 				shost->host_no);
 		dump_stack();
 		return;
diff -puN drivers/scsi/scsi_tgt_priv.h~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_tgt_priv.h
--- a/drivers/scsi/scsi_tgt_priv.h~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_tgt_priv.h
@@ -6,7 +6,7 @@ struct task_struct;
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 
 #define dprintk(fmt, args...)
diff -puN drivers/scsi/scsi_transport_fc.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -571,7 +571,7 @@ send_fail:
 	name = get_fc_host_event_code_name(event_code);
 	printk(KERN_WARNING
 		"%s: Dropped Event : host %d %s data 0x%08x - err %d\n",
-		__FUNCTION__, shost->host_no,
+		__func__, shost->host_no,
 		(name) ? name : "<unknown>", event_data, err);
 	return;
 }
@@ -644,7 +644,7 @@ send_vendor_fail_skb:
 send_vendor_fail:
 	printk(KERN_WARNING
 		"%s: Dropped Event : host %d vendor_unique - err %d\n",
-		__FUNCTION__, shost->host_no, err);
+		__func__, shost->host_no, err);
 	return;
 }
 EXPORT_SYMBOL(fc_host_post_vendor_event);
@@ -2464,7 +2464,7 @@ fc_rport_create(struct Scsi_Host *shost,
 	size = (sizeof(struct fc_rport) + fci->f->dd_fcrport_size);
 	rport = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!rport)) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
 	}
 
@@ -3137,7 +3137,7 @@ fc_vport_create(struct Scsi_Host *shost,
 	size = (sizeof(struct fc_vport) + fci->f->dd_fcvport_size);
 	vport = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!vport)) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -3201,7 +3201,7 @@ fc_vport_create(struct Scsi_Host *shost,
 			printk(KERN_ERR
 				"%s: Cannot create vport symlinks for "
 				"%s, err=%d\n",
-				__FUNCTION__, dev->bus_id, error);
+				__func__, dev->bus_id, error);
 	}
 	spin_lock_irqsave(shost->host_lock, flags);
 	vport->flags &= ~FC_VPORT_CREATING;
@@ -3314,7 +3314,7 @@ fc_vport_sched_delete(struct work_struct
 	if (stat)
 		dev_printk(KERN_ERR, vport->dev.parent,
 			"%s: %s could not be deleted created via "
-			"shost%d channel %d - error %d\n", __FUNCTION__,
+			"shost%d channel %d - error %d\n", __func__,
 			vport->dev.bus_id, vport->shost->host_no,
 			vport->channel, stat);
 }
diff -puN drivers/scsi/scsi_transport_sas.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/scsi_transport_sas.c
@@ -779,7 +779,7 @@ static void sas_port_create_link(struct 
 	return;
 err:
 	printk(KERN_ERR "%s: Cannot create port links, err=%d\n",
-	       __FUNCTION__, res);
+	       __func__, res);
 }
 
 static void sas_port_delete_link(struct sas_port *port,
@@ -1029,7 +1029,7 @@ void sas_port_mark_backlink(struct sas_p
 	return;
 err:
 	printk(KERN_ERR "%s: Cannot create port backlink, err=%d\n",
-	       __FUNCTION__, res);
+	       __func__, res);
 
 }
 EXPORT_SYMBOL(sas_port_mark_backlink);
diff -puN drivers/scsi/tmscsim.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/tmscsim.c
@@ -452,7 +452,7 @@ static int dc390_pci_map (struct dc390_s
 		/* TODO: error handling */
 		if (pSRB->SGcount != 1)
 			error = 1;
-		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
+		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __func__, pcmd->sense_buffer, cmdp->saved_dma_handle));
 	/* Map SG list */
 	} else if (scsi_sg_count(pcmd)) {
 		int nseg;
@@ -466,7 +466,7 @@ static int dc390_pci_map (struct dc390_s
 		if (nseg < 0)
 			error = 1;
 		DEBUG1(printk("%s(): Mapped SG %p with %d (%d) elements\n",\
-			      __FUNCTION__, scsi_sglist(pcmd), nseg, scsi_sg_count(pcmd)));
+			      __func__, scsi_sglist(pcmd), nseg, scsi_sg_count(pcmd)));
 	/* Map single segment */
 	} else
 		pSRB->SGcount = 0;
@@ -483,11 +483,11 @@ static void dc390_pci_unmap (struct dc39
 
 	if (pSRB->SRBFlag) {
 		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, DMA_FROM_DEVICE);
-		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
+		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __func__, cmdp->saved_dma_handle));
 	} else {
 		scsi_dma_unmap(pcmd);
 		DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n",
-			      __FUNCTION__, scsi_sglist(pcmd), scsi_sg_count(pcmd)));
+			      __func__, scsi_sglist(pcmd), scsi_sg_count(pcmd)));
 	}
 }
 
diff -puN drivers/scsi/wd7000.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/wd7000.c
--- a/drivers/scsi/wd7000.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/wd7000.c
@@ -148,7 +148,7 @@
  *
  * 2002/10/04 - Alan Cox <alan@redhat.com>
  *
- * Use dev_id for interrupts, kill __FUNCTION__ pasting
+ * Use dev_id for interrupts, kill __func__ pasting
  * Add a lock for the scb pool, clean up all other cli/sti usage stuff
  * Use the adapter lock for the other places we had the cli's
  *
@@ -640,12 +640,12 @@ static int __init wd7000_setup(char *str
 	(void) get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (wd7000_card_num >= NUM_CONFIGS) {
-		printk(KERN_ERR "%s: Too many \"wd7000=\" configurations in " "command line!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Too many \"wd7000=\" configurations in " "command line!\n", __func__);
 		return 0;
 	}
 
 	if ((ints[0] < 3) || (ints[0] > 5)) {
-		printk(KERN_ERR "%s: Error in command line!  " "Usage: wd7000=<IRQ>,<DMA>,IO>[,<BUS_ON>" "[,<BUS_OFF>]]\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Error in command line!  " "Usage: wd7000=<IRQ>,<DMA>,IO>[,<BUS_ON>" "[,<BUS_OFF>]]\n", __func__);
 	} else {
 		for (i = 0; i < NUM_IRQS; i++)
 			if (ints[1] == wd7000_irq[i])
@@ -1642,7 +1642,7 @@ static int wd7000_biosparam(struct scsi_
 			ip[2] = info[2];
 
 			if (info[0] == 255)
-				printk(KERN_INFO "%s: current partition table is " "using extended translation.\n", __FUNCTION__);
+				printk(KERN_INFO "%s: current partition table is " "using extended translation.\n", __func__);
 		}
 	}
 
diff -puN drivers/scsi/zalon.c~scsi-replace-remaining-__function__-occurrences drivers/scsi/zalon.c
--- a/drivers/scsi/zalon.c~scsi-replace-remaining-__function__-occurrences
+++ a/drivers/scsi/zalon.c
@@ -68,11 +68,11 @@ lasi_scsi_clock(void * hpa, int defaultc
 	if (status == PDC_RET_OK) {
 		clock = (int) pdc_result[16];
 	} else {
-		printk(KERN_WARNING "%s: pdc_iodc_read returned %d\n", __FUNCTION__, status);
+		printk(KERN_WARNING "%s: pdc_iodc_read returned %d\n", __func__, status);
 		clock = defaultclock; 
 	}
 
-	printk(KERN_DEBUG "%s: SCSI clock %d\n", __FUNCTION__, clock);
+	printk(KERN_DEBUG "%s: SCSI clock %d\n", __func__, clock);
  	return clock;
 }
 #endif
@@ -108,13 +108,13 @@ zalon_probe(struct parisc_device *dev)
 	*/
 	dev->irq = gsc_alloc_irq(&gsc_irq);
 
-	printk(KERN_INFO "%s: Zalon version %d, IRQ %d\n", __FUNCTION__,
+	printk(KERN_INFO "%s: Zalon version %d, IRQ %d\n", __func__,
 		zalon_vers, dev->irq);
 
 	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, zalon + IO_MODULE_EIM);
 
 	if (zalon_vers == 0)
-		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __func__);
 
 	memset(&device, 0, sizeof(struct ncr_device));
 
_
