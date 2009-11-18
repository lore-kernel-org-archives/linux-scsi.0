From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/6] lpfc 8.3.6 : FC Protocol Fixes
Date: Wed, 18 Nov 2009 15:39:44 -0500
Message-ID: <1258576807.29086.15.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50802 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbZKRUkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 15:40:07 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id nAIKeExl012613
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 12:40:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


FC protocol fixes.
 - Fix send sequence logic to handle multi SGL IOCBs.
 - Fix FDISC completion always setting VPORT state to failed.
 - Ported the fix on reporting of max_vpi to uppper layer.
 - Fix incorrect number of Vports allowed to be created.
 - Fixed Dead FCoE port after creating vports.
 - Added handling of ELS request for Reinstate Recovery Qualifier (RRQ)
 - Handle unsolicited CT exchange initiator receiving CT exchange ABTS
 - Migrate LUN queue depth ramp up code to scsi mid-layer.
 - Made ABTS WQE go to the same WQ as the WQE to be aborted.
 - Fix Vport does not rediscover after FCF goes away.
 - Fixed lpfc_unreg_vfi failure after devloss timeout.
 - Fixed RPI bit leak.
 - Fix hbq pointer corruption during target discovery.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    1 
 lpfc_disc.h      |    2 
 lpfc_els.c       |   40 +++++++++++++---
 lpfc_hw.h        |    2 
 lpfc_hw4.h       |   23 ++++++++-
 lpfc_init.c      |    3 -
 lpfc_nportdisc.c |    7 ++
 lpfc_scsi.c      |  135 +++++++++++++++++++++----------------------------------
 lpfc_sli.c       |  133 +++++++++++++++++++++++++++++++++++++++++++-----------
 lpfc_sli.h       |    1 
 lpfc_sli4.h      |    5 ++
 lpfc_vport.c     |    2 
 12 files changed, 235 insertions(+), 119 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2009-11-18 10:55:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2009-11-18 12:04:24.000000000 -0500
@@ -105,8 +105,6 @@ struct lpfc_nodelist {
 	struct lpfc_vport *vport;
 	struct lpfc_work_evt els_retry_evt;
 	struct lpfc_work_evt dev_loss_evt;
-	unsigned long last_ramp_up_time;        /* jiffy of last ramp up */
-	unsigned long last_q_full_time;		/* jiffy of last queue full */
 	struct kref     kref;
 	atomic_t cmd_pending;
 	uint32_t cmd_qdepth;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-11-18 12:04:28.000000000 -0500
@@ -4521,6 +4521,29 @@ lpfc_els_rcv_lirr(struct lpfc_vport *vpo
 }
 
 /**
+ * lpfc_els_rcv_rrq - Process an unsolicited rrq iocb
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes a Reinstate Recovery Qualifier (RRQ) IOCB
+ * received as an ELS unsolicited event. A request to RRQ shall only
+ * be accepted if the Originator Nx_Port N_Port_ID or the Responder
+ * Nx_Port N_Port_ID of the target Exchange is the same as the
+ * N_Port_ID of the Nx_Port that makes the request. If the RRQ is
+ * not accepted, an LS_RJT with reason code "Unable to perform
+ * command request" and reason code explanation "Invalid Originator
+ * S_ID" shall be returned. For now, we just unconditionally accept
+ * RRQ from the target.
+ **/
+static void
+lpfc_els_rcv_rrq(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
+		 struct lpfc_nodelist *ndlp)
+{
+	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
+}
+
+/**
  * lpfc_els_rsp_rps_acc - Completion callbk func for MBX_READ_LNK_STAT mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
@@ -5636,6 +5659,16 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
+	case ELS_CMD_RRQ:
+		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
+			"RCV RRQ:         did:x%x/ste:x%x flg:x%x",
+			did, vport->port_state, ndlp->nlp_flag);
+
+		phba->fc_stat.elsRcvRRQ++;
+		lpfc_els_rcv_rrq(vport, elsiocb, ndlp);
+		if (newnode)
+			lpfc_nlp_put(ndlp);
+		break;
 	default:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 			"RCV ELS cmd:     cmd:x%x did:x%x/ste:x%x",
@@ -6042,11 +6075,6 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 				 irsp->ulpStatus, irsp->un.ulpWord[4]);
 		goto fdisc_failed;
 	}
-		if (vport->fc_vport->vport_state == FC_VPORT_INITIALIZING)
-			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
-		lpfc_nlp_put(ndlp);
-		/* giving up on FDISC. Cancel discovery timer */
-		lpfc_can_disctmo(vport);
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag |= FC_FABRIC;
 	if (vport->phba->fc_topology == TOPOLOGY_LOOP)
@@ -6125,6 +6153,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
 	int did = ndlp->nlp_DID;
 	int rc;
 
+	vport->port_state = LPFC_FDISC;
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp, did,
 				     ELS_CMD_FDISC);
@@ -6190,7 +6219,6 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
 		return 1;
 	}
 	lpfc_vport_set_state(vport, FC_VPORT_INITIALIZING);
-	vport->port_state = LPFC_FDISC;
 	return 0;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2009-11-18 12:04:24.000000000 -0500
@@ -202,6 +202,7 @@ struct lpfc_stats {
 	uint32_t elsRcvLIRR;
 	uint32_t elsRcvRPS;
 	uint32_t elsRcvRPL;
+	uint32_t elsRcvRRQ;
 	uint32_t elsXmitFLOGI;
 	uint32_t elsXmitFDISC;
 	uint32_t elsXmitPLOGI;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2009-11-18 12:04:24.000000000 -0500
@@ -194,6 +194,26 @@ struct lpfc_sli4_flags {
 #define lpfc_fip_flag_WORD word0
 };
 
+struct sli4_bls_acc {
+	uint32_t word0_rsvd;      /* Word0 must be reserved */
+	uint32_t word1;
+#define lpfc_abts_orig_SHIFT      0
+#define lpfc_abts_orig_MASK       0x00000001
+#define lpfc_abts_orig_WORD       word1
+#define LPFC_ABTS_UNSOL_RSP       1
+#define LPFC_ABTS_UNSOL_INT       0
+	uint32_t word2;
+#define lpfc_abts_rxid_SHIFT      0
+#define lpfc_abts_rxid_MASK       0x0000FFFF
+#define lpfc_abts_rxid_WORD       word2
+#define lpfc_abts_oxid_SHIFT      16
+#define lpfc_abts_oxid_MASK       0x0000FFFF
+#define lpfc_abts_oxid_WORD       word2
+	uint32_t word3;
+	uint32_t word4;
+	uint32_t word5_rsvd;	/* Word5 must be reserved */
+};
+
 /* event queue entry structure */
 struct lpfc_eqe {
 	uint32_t word0;
@@ -1980,7 +2000,8 @@ struct lpfc_bmbx_create {
 #define SGL_ALIGN_SZ 64
 #define SGL_PAGE_SIZE 4096
 /* align SGL addr on a size boundary - adjust address up */
-#define NO_XRI ((uint16_t)-1)
+#define NO_XRI  ((uint16_t)-1)
+
 struct wqe_common {
 	uint32_t word6;
 #define wqe_xri_tag_SHIFT     0
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2009-11-18 12:04:24.000000000 -0500
@@ -3538,7 +3538,7 @@ typedef struct _IOCB {	/* IOCB structure
 		ASYNCSTAT_FIELDS asyncstat; /* async_status iocb */
 		QUE_XRI64_CX_FIELDS quexri64cx; /* que_xri64_cx fields */
 		struct rcv_seq64 rcvseq64;	/* RCV_SEQ64 and RCV_CONT64 */
-
+		struct sli4_bls_acc bls_acc; /* UNSOL ABTS BLS_ACC params */
 		uint32_t ulpWord[IOCB_WORD_SZ - 2];	/* generic 6 'words' */
 	} un;
 	union {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-11-18 12:04:24.000000000 -0500
@@ -4931,7 +4931,8 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 		phba->vpi_base = phba->sli4_hba.max_cfg_param.vpi_base;
 		phba->vfi_base = phba->sli4_hba.max_cfg_param.vfi_base;
 		phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.rpi_base;
-		phba->max_vpi = phba->sli4_hba.max_cfg_param.max_vpi;
+		phba->max_vpi = (phba->sli4_hba.max_cfg_param.max_vpi > 0) ?
+				(phba->sli4_hba.max_cfg_param.max_vpi - 1) : 0;
 		phba->max_vports = phba->max_vpi;
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"2003 cfg params XRI(B:%d M:%d), "
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-11-18 12:04:28.000000000 -0500
@@ -1223,6 +1223,12 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
+			if (phba->sli_rev == LPFC_SLI_REV4) {
+				spin_unlock_irq(&phba->hbalock);
+				lpfc_sli4_free_rpi(phba,
+					mb->u.mb.un.varRegLogin.rpi);
+				spin_lock_irq(&phba->hbalock);
+			}
 			mp = (struct lpfc_dmabuf *) (mb->context1);
 			if (mp) {
 				__lpfc_mbuf_free(phba, mp->virt, mp->phys);
@@ -1230,6 +1236,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 			}
 			lpfc_nlp_put(ndlp);
 			list_del(&mb->list);
+			phba->sli.mboxq_cnt--;
 			mempool_free(mb, phba->mbox_mem_pool);
 		}
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-11-18 10:56:31.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-11-18 12:04:24.000000000 -0500
@@ -246,6 +246,36 @@ lpfc_send_sdev_queuedepth_change_event(s
 }
 
 /**
+ * lpfc_change_queue_depth - Alter scsi device queue depth
+ * @sdev: Pointer the scsi device on which to change the queue depth.
+ * @qdepth: New queue depth to set the sdev to.
+ * @reason: The reason for the queue depth change.
+ *
+ * This function is called by the midlayer and the LLD to alter the queue
+ * depth for a scsi device. This function sets the queue depth to the new
+ * value and sends an event out to log the queue depth change.
+ **/
+int
+lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_rport_data *rdata;
+	unsigned long new_queue_depth, old_queue_depth;
+
+	old_queue_depth = sdev->queue_depth;
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	new_queue_depth = sdev->queue_depth;
+	rdata = sdev->hostdata;
+	if (rdata)
+		lpfc_send_sdev_queuedepth_change_event(phba, vport,
+						       rdata->pnode, sdev->lun,
+						       old_queue_depth,
+						       new_queue_depth);
+	return sdev->queue_depth;
+}
+
+/**
  * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
  *
@@ -309,8 +339,10 @@ lpfc_rampup_queue_depth(struct lpfc_vpor
 	if (vport->cfg_lun_queue_depth <= queue_depth)
 		return;
 	spin_lock_irqsave(&phba->hbalock, flags);
-	if (((phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL) > jiffies) ||
-	 ((phba->last_rsrc_error_time + QUEUE_RAMP_UP_INTERVAL ) > jiffies)) {
+	if (time_before(jiffies,
+			phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL) ||
+	    time_before(jiffies,
+			phba->last_rsrc_error_time + QUEUE_RAMP_UP_INTERVAL)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
@@ -342,10 +374,9 @@ lpfc_ramp_down_queue_handler(struct lpfc
 	struct lpfc_vport **vports;
 	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
-	unsigned long new_queue_depth, old_queue_depth;
+	unsigned long new_queue_depth;
 	unsigned long num_rsrc_err, num_cmd_success;
 	int i;
-	struct lpfc_rport_data *rdata;
 
 	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
 	num_cmd_success = atomic_read(&phba->num_cmd_success);
@@ -363,22 +394,8 @@ lpfc_ramp_down_queue_handler(struct lpfc
 				else
 					new_queue_depth = sdev->queue_depth -
 								new_queue_depth;
-				old_queue_depth = sdev->queue_depth;
-				if (sdev->ordered_tags)
-					scsi_adjust_queue_depth(sdev,
-							MSG_ORDERED_TAG,
-							new_queue_depth);
-				else
-					scsi_adjust_queue_depth(sdev,
-							MSG_SIMPLE_TAG,
-							new_queue_depth);
-				rdata = sdev->hostdata;
-				if (rdata)
-					lpfc_send_sdev_queuedepth_change_event(
-						phba, vports[i],
-						rdata->pnode,
-						sdev->lun, old_queue_depth,
-						new_queue_depth);
+				lpfc_change_queue_depth(sdev, new_queue_depth,
+							SCSI_QDEPTH_DEFAULT);
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -402,7 +419,6 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
 	int i;
-	struct lpfc_rport_data *rdata;
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
@@ -412,22 +428,9 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 				if (vports[i]->cfg_lun_queue_depth <=
 				    sdev->queue_depth)
 					continue;
-				if (sdev->ordered_tags)
-					scsi_adjust_queue_depth(sdev,
-							MSG_ORDERED_TAG,
-							sdev->queue_depth+1);
-				else
-					scsi_adjust_queue_depth(sdev,
-							MSG_SIMPLE_TAG,
-							sdev->queue_depth+1);
-				rdata = sdev->hostdata;
-				if (rdata)
-					lpfc_send_sdev_queuedepth_change_event(
-						phba, vports[i],
-						rdata->pnode,
-						sdev->lun,
-						sdev->queue_depth - 1,
-						sdev->queue_depth);
+				lpfc_change_queue_depth(sdev,
+							sdev->queue_depth+1,
+							SCSI_QDEPTH_RAMP_UP);
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -2208,7 +2211,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	int result;
 	struct scsi_device *tmp_sdev;
-	int depth = 0;
+	int depth;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
 	struct Scsi_Host *shost = cmd->device->host;
@@ -2375,67 +2378,29 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		return;
 	}
 
-
 	if (!result)
 		lpfc_rampup_queue_depth(vport, queue_depth);
 
-	if (!result && pnode && NLP_CHK_NODE_ACT(pnode) &&
-	   ((jiffies - pnode->last_ramp_up_time) >
-		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
-	   ((jiffies - pnode->last_q_full_time) >
-		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
-	   (vport->cfg_lun_queue_depth > queue_depth)) {
-		shost_for_each_device(tmp_sdev, shost) {
-			if (vport->cfg_lun_queue_depth > tmp_sdev->queue_depth){
-				if (tmp_sdev->id != scsi_id)
-					continue;
-				if (tmp_sdev->ordered_tags)
-					scsi_adjust_queue_depth(tmp_sdev,
-						MSG_ORDERED_TAG,
-						tmp_sdev->queue_depth+1);
-				else
-					scsi_adjust_queue_depth(tmp_sdev,
-						MSG_SIMPLE_TAG,
-						tmp_sdev->queue_depth+1);
-
-				pnode->last_ramp_up_time = jiffies;
-			}
-		}
-		lpfc_send_sdev_queuedepth_change_event(phba, vport, pnode,
-			0xFFFFFFFF,
-			queue_depth , queue_depth + 1);
-	}
-
 	/*
 	 * Check for queue full.  If the lun is reporting queue full, then
 	 * back off the lun queue depth to prevent target overloads.
 	 */
 	if (result == SAM_STAT_TASK_SET_FULL && pnode &&
 	    NLP_CHK_NODE_ACT(pnode)) {
-		pnode->last_q_full_time = jiffies;
-
 		shost_for_each_device(tmp_sdev, shost) {
 			if (tmp_sdev->id != scsi_id)
 				continue;
 			depth = scsi_track_queue_full(tmp_sdev,
-					tmp_sdev->queue_depth - 1);
-		}
-		/*
-		 * The queue depth cannot be lowered any more.
-		 * Modify the returned error code to store
-		 * the final depth value set by
-		 * scsi_track_queue_full.
-		 */
-		if (depth == -1)
-			depth = shost->cmd_per_lun;
-
-		if (depth) {
+						      tmp_sdev->queue_depth-1);
+			if (depth <= 0)
+				continue;
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 					 "0711 detected queue full - lun queue "
 					 "depth adjusted to %d.\n", depth);
 			lpfc_send_sdev_queuedepth_change_event(phba, vport,
-				pnode, 0xFFFFFFFF,
-				depth+1, depth);
+							       pnode,
+							       tmp_sdev->lun,
+							       depth+1, depth);
 		}
 	}
 
@@ -3019,6 +2984,10 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
 	icmd->ulpLe = 1;
 	icmd->ulpClass = cmd->ulpClass;
+
+	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
+	abtsiocb->fcp_wqidx = iocb->fcp_wqidx;
+
 	if (lpfc_is_link_up(phba))
 		icmd->ulpCommand = CMD_ABORT_XRI_CN;
 	else
@@ -3596,6 +3565,7 @@ struct scsi_host_template lpfc_template 
 	.shost_attrs		= lpfc_hba_attrs,
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
+	.change_queue_depth	= lpfc_change_queue_depth,
 };
 
 struct scsi_host_template lpfc_vport_template = {
@@ -3617,4 +3587,5 @@ struct scsi_host_template lpfc_vport_tem
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
+	.change_queue_depth	= lpfc_change_queue_depth,
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2009-11-18 10:56:31.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2009-11-18 12:04:24.000000000 -0500
@@ -63,6 +63,11 @@
 	 (fc_hdr)->fh_s_id[1] <<  8 | \
 	 (fc_hdr)->fh_s_id[2])
 
+#define sli4_fctl_from_fc_hdr(fc_hdr)  \
+	((fc_hdr)->fh_f_ctl[0] << 16 | \
+	 (fc_hdr)->fh_f_ctl[1] <<  8 | \
+	 (fc_hdr)->fh_f_ctl[2])
+
 enum lpfc_sli4_queue_type {
 	LPFC_EQ,
 	LPFC_GCQ,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-11-18 12:04:28.000000000 -0500
@@ -5748,7 +5748,7 @@ static int
 lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		union lpfc_wqe *wqe)
 {
-	uint32_t payload_len = 0;
+	uint32_t xmit_len = 0, total_len = 0;
 	uint8_t ct = 0;
 	uint32_t fip;
 	uint32_t abort_tag;
@@ -5757,6 +5757,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	uint16_t xritag;
 	struct ulp_bde64 *bpl = NULL;
 	uint32_t els_id = ELS_ID_DEFAULT;
+	int numBdes, i;
+	struct ulp_bde64 bde;
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
@@ -5774,6 +5776,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	wqe->words[7] = 0; /* The ct field has moved so reset */
 	/* words0-2 bpl convert bde */
 	if (iocbq->iocb.un.genreq64.bdl.bdeFlags == BUFF_TYPE_BLP_64) {
+		numBdes = iocbq->iocb.un.genreq64.bdl.bdeSize /
+				sizeof(struct ulp_bde64);
 		bpl  = (struct ulp_bde64 *)
 			((struct lpfc_dmabuf *)iocbq->context3)->virt;
 		if (!bpl)
@@ -5786,9 +5790,14 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		 * can assign it to the sgl.
 		 */
 		wqe->generic.bde.tus.w  = le32_to_cpu(bpl->tus.w);
-		payload_len = wqe->generic.bde.tus.f.bdeSize;
+		xmit_len = wqe->generic.bde.tus.f.bdeSize;
+		total_len = 0;
+		for (i = 0; i < numBdes; i++) {
+			bde.tus.w  = le32_to_cpu(bpl[i].tus.w);
+			total_len += bde.tus.f.bdeSize;
+		}
 	} else
-		payload_len = iocbq->iocb.un.fcpi64.bdl.bdeSize;
+		xmit_len = iocbq->iocb.un.fcpi64.bdl.bdeSize;
 
 	iocbq->iocb.ulpIoTag = iocbq->iotag;
 	cmnd = iocbq->iocb.ulpCommand;
@@ -5802,7 +5811,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 				iocbq->iocb.ulpCommand);
 			return IOCB_ERROR;
 		}
-		wqe->els_req.payload_len = payload_len;
+		wqe->els_req.payload_len = xmit_len;
 		/* Els_reguest64 has a TMO */
 		bf_set(wqe_tmo, &wqe->els_req.wqe_com,
 			iocbq->iocb.ulpTimeout);
@@ -5831,6 +5840,15 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(lpfc_wqe_gen_els_id, &wqe->generic, els_id);
 
 	break;
+	case CMD_XMIT_SEQUENCE64_CX:
+		bf_set(lpfc_wqe_gen_context, &wqe->generic,
+					iocbq->iocb.un.ulpWord[3]);
+		wqe->generic.word3 = 0;
+		bf_set(wqe_rcvoxid, &wqe->generic, iocbq->iocb.ulpContext);
+		bf_set(wqe_xc, &wqe->generic, 1);
+		/* The entire sequence is transmitted for this IOCB */
+		xmit_len = total_len;
+		cmnd = CMD_XMIT_SEQUENCE64_CR;
 	case CMD_XMIT_SEQUENCE64_CR:
 		/* word3 iocb=io_tag32 wqe=payload_offset */
 		/* payload offset used for multilpe outstanding
@@ -5840,7 +5858,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		/* word4 relative_offset memcpy */
 		/* word5 r_ctl/df_ctl memcpy */
 		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
-		wqe->xmit_sequence.xmit_len = payload_len;
+		wqe->xmit_sequence.xmit_len = xmit_len;
+		command_type = OTHER_COMMAND;
 	break;
 	case CMD_XMIT_BCAST64_CN:
 		/* word3 iocb=iotag32 wqe=payload_len */
@@ -5869,7 +5888,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	case CMD_FCP_IREAD64_CR:
 		/* FCP_CMD is always the 1st sgl entry */
 		wqe->fcp_iread.payload_len =
-			payload_len + sizeof(struct fcp_rsp);
+			xmit_len + sizeof(struct fcp_rsp);
 
 		/* word 4 (xfer length) should have been set on the memcpy */
 
@@ -5906,7 +5925,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		 * sgl[1] = rsp.
 		 *
 		 */
-		wqe->gen_req.command_len = payload_len;
+		wqe->gen_req.command_len = xmit_len;
 		/* Word4 parameter  copied in the memcpy */
 		/* Word5 [rctl, type, df_ctl, la] copied in memcpy */
 		/* word6 context tag copied in memcpy */
@@ -5979,10 +5998,25 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		 * iocbq from scratch.
 		 */
 		memset(wqe, 0, sizeof(union lpfc_wqe));
+		/* OX_ID is invariable to who sent ABTS to CT exchange */
 		bf_set(xmit_bls_rsp64_oxid, &wqe->xmit_bls_rsp,
-		       iocbq->iocb.un.ulpWord[3]);
-		bf_set(xmit_bls_rsp64_rxid, &wqe->xmit_bls_rsp,
-		       iocbq->sli4_xritag);
+		       bf_get(lpfc_abts_oxid, &iocbq->iocb.un.bls_acc));
+		if (bf_get(lpfc_abts_orig, &iocbq->iocb.un.bls_acc) ==
+		    LPFC_ABTS_UNSOL_INT) {
+			/* ABTS sent by initiator to CT exchange, the
+			 * RX_ID field will be filled with the newly
+			 * allocated responder XRI.
+			 */
+			bf_set(xmit_bls_rsp64_rxid, &wqe->xmit_bls_rsp,
+			       iocbq->sli4_xritag);
+		} else {
+			/* ABTS sent by responder to CT exchange, the
+			 * RX_ID field will be filled with the responder
+			 * RX_ID from ABTS.
+			 */
+			bf_set(xmit_bls_rsp64_rxid, &wqe->xmit_bls_rsp,
+			       bf_get(lpfc_abts_rxid, &iocbq->iocb.un.bls_acc));
+		}
 		bf_set(xmit_bls_rsp64_seqcnthi, &wqe->xmit_bls_rsp, 0xffff);
 		bf_set(wqe_xmit_bls_pt, &wqe->xmit_bls_rsp.wqe_dest, 0x1);
 		bf_set(wqe_ctxt_tag, &wqe->xmit_bls_rsp.wqe_com,
@@ -6044,7 +6078,6 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 	uint16_t xritag;
 	union lpfc_wqe wqe;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
-	uint32_t fcp_wqidx;
 
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
@@ -6079,8 +6112,17 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 		return IOCB_ERROR;
 
 	if (piocb->iocb_flag &  LPFC_IO_FCP) {
-		fcp_wqidx = lpfc_sli4_scmd_to_wqidx_distr(phba);
-		if (lpfc_sli4_wq_put(phba->sli4_hba.fcp_wq[fcp_wqidx], &wqe))
+		/*
+		 * For FCP command IOCB, get a new WQ index to distribute
+		 * WQE across the WQsr. On the other hand, for abort IOCB,
+		 * it carries the same WQ index to the original command
+		 * IOCB.
+		 */
+		if ((piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
+		    (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN))
+			piocb->fcp_wqidx = lpfc_sli4_scmd_to_wqidx_distr(phba);
+		if (lpfc_sli4_wq_put(phba->sli4_hba.fcp_wq[piocb->fcp_wqidx],
+				     &wqe))
 			return IOCB_ERROR;
 	} else {
 		if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, &wqe))
@@ -7070,6 +7112,9 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 	iabt->ulpLe = 1;
 	iabt->ulpClass = icmd->ulpClass;
 
+	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
+	abtsiocbp->fcp_wqidx = cmdiocb->fcp_wqidx;
+
 	if (phba->link_state >= LPFC_LINK_UP)
 		iabt->ulpCommand = CMD_ABORT_XRI_CN;
 	else
@@ -7273,6 +7318,9 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 		abtsiocb->iocb.ulpClass = cmd->ulpClass;
 		abtsiocb->vport = phba->pport;
 
+		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
+		abtsiocb->fcp_wqidx = iocbq->fcp_wqidx;
+
 		if (lpfc_is_link_up(phba))
 			abtsiocb->iocb.ulpCommand = CMD_ABORT_XRI_CN;
 		else
@@ -8671,7 +8719,6 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 	uint32_t status;
 	unsigned long iflags;
 
-	lpfc_sli4_rq_release(hrq, drq);
 	if (bf_get(lpfc_rcqe_rq_id, rcqe) != hrq->queue_id)
 		goto out;
 
@@ -8681,6 +8728,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2537 Receive Frame Truncated!!\n");
 	case FC_STATUS_RQ_SUCCESS:
+		lpfc_sli4_rq_release(hrq, drq);
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		dma_buf = lpfc_sli_hbqbuf_get(&phba->hbqs[0].hbq_buffer_list);
 		if (!dma_buf) {
@@ -10997,8 +11045,8 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 {
 	struct lpfc_iocbq *ctiocb = NULL;
 	struct lpfc_nodelist *ndlp;
-	uint16_t oxid;
-	uint32_t sid;
+	uint16_t oxid, rxid;
+	uint32_t sid, fctl;
 	IOCB_t *icmd;
 
 	if (!lpfc_is_link_up(phba))
@@ -11006,6 +11054,7 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 
 	sid = sli4_sid_from_fc_hdr(fc_hdr);
 	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
+	rxid = be16_to_cpu(fc_hdr->fh_rx_id);
 
 	ndlp = lpfc_findnode_did(phba->pport, sid);
 	if (!ndlp) {
@@ -11020,9 +11069,12 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 	if (!ctiocb)
 		return;
 
+	/* Extract the F_CTL field from FC_HDR */
+	fctl = sli4_fctl_from_fc_hdr(fc_hdr);
+
 	icmd = &ctiocb->iocb;
-	icmd->un.xseq64.bdl.ulpIoTag32 = 0;
 	icmd->un.xseq64.bdl.bdeSize = 0;
+	icmd->un.xseq64.bdl.ulpIoTag32 = 0;
 	icmd->un.xseq64.w5.hcsw.Dfctl = 0;
 	icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_ACC;
 	icmd->un.xseq64.w5.hcsw.Type = FC_TYPE_BLS;
@@ -11033,13 +11085,30 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 	icmd->ulpLe = 1;
 	icmd->ulpClass = CLASS3;
 	icmd->ulpContext = ndlp->nlp_rpi;
-	icmd->un.ulpWord[3] = oxid;
 
-	ctiocb->sli4_xritag = NO_XRI;
 	ctiocb->iocb_cmpl = NULL;
 	ctiocb->vport = phba->pport;
 	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_acc_cmpl;
 
+	if (fctl & FC_FC_EX_CTX) {
+		/* ABTS sent by responder to CT exchange, construction
+		 * of BA_ACC will use OX_ID from ABTS for the XRI_TAG
+		 * field and RX_ID from ABTS for RX_ID field.
+		 */
+		bf_set(lpfc_abts_orig, &icmd->un.bls_acc, LPFC_ABTS_UNSOL_RSP);
+		bf_set(lpfc_abts_rxid, &icmd->un.bls_acc, rxid);
+		ctiocb->sli4_xritag = oxid;
+	} else {
+		/* ABTS sent by initiator to CT exchange, construction
+		 * of BA_ACC will need to allocate a new XRI as for the
+		 * XRI_TAG and RX_ID fields.
+		 */
+		bf_set(lpfc_abts_orig, &icmd->un.bls_acc, LPFC_ABTS_UNSOL_INT);
+		bf_set(lpfc_abts_rxid, &icmd->un.bls_acc, NO_XRI);
+		ctiocb->sli4_xritag = NO_XRI;
+	}
+	bf_set(lpfc_abts_oxid, &icmd->un.bls_acc, oxid);
+
 	/* Xmit CT abts accept on exchange <xid> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"1200 Xmit CT ABTS ACC on exchange x%x Data: x%x\n",
@@ -11066,19 +11135,31 @@ lpfc_sli4_handle_unsol_abort(struct lpfc
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_frame_header fc_hdr;
+	uint32_t fctl;
 	bool abts_par;
 
-	/* Try to abort partially assembled seq */
-	abts_par = lpfc_sli4_abort_partial_seq(vport, dmabuf);
-
 	/* Make a copy of fc_hdr before the dmabuf being released */
 	memcpy(&fc_hdr, dmabuf->hbuf.virt, sizeof(struct fc_frame_header));
+	fctl = sli4_fctl_from_fc_hdr(&fc_hdr);
 
-	/* Send abort to ULP if partially seq abort failed */
-	if (abts_par == false)
-		lpfc_sli4_send_seq_to_ulp(vport, dmabuf);
-	else
+	if (fctl & FC_FC_EX_CTX) {
+		/*
+		 * ABTS sent by responder to exchange, just free the buffer
+		 */
 		lpfc_in_buf_free(phba, &dmabuf->dbuf);
+	} else {
+		/*
+		 * ABTS sent by initiator to exchange, need to do cleanup
+		 */
+		/* Try to abort partially assembled seq */
+		abts_par = lpfc_sli4_abort_partial_seq(vport, dmabuf);
+
+		/* Send abort to ULP if partially seq abort failed */
+		if (abts_par == false)
+			lpfc_sli4_send_seq_to_ulp(vport, dmabuf);
+		else
+			lpfc_in_buf_free(phba, &dmabuf->dbuf);
+	}
 	/* Send basic accept (BA_ACC) to the abort requester */
 	lpfc_sli4_seq_abort_acc(phba, &fc_hdr);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2009-11-18 12:04:24.000000000 -0500
@@ -66,6 +66,7 @@ struct lpfc_iocbq {
 	uint8_t abort_count;
 	uint8_t rsvd2;
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
+	uint32_t fcp_wqidx;	/* index to FCP work queue */
 	struct lpfc_vport *vport;/* virtual port pointer */
 	void *context1;		/* caller context information */
 	void *context2;		/* caller context information */
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2009-11-18 12:03:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2009-11-18 12:04:24.000000000 -0500
@@ -700,6 +700,8 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 			}
 			spin_unlock_irq(&phba->ndlp_lock);
 		}
+		if (vport->vpi_state != LPFC_VPI_REGISTERED)
+			goto skip_logo;
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 		if (!lpfc_issue_els_npiv_logo(vport, ndlp))


