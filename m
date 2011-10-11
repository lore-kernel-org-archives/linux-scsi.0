From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.27: Miscellanous logic and interface fixes
Date: Mon, 10 Oct 2011 21:32:10 -0400
Message-ID: <1318296732.5189.10.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:33721 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751595Ab1JKBhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2011 21:37:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Miscellanous logic and interface fixes

- Fix lpfc_init_vfi_cmpl to check the interface type for interface type 0
  before parsing the results.
- Cast uint32_t values that are multiplied to uint64_t before the
  multiplication.
- Instead of "break" statement when PCI read returned error, use the goto
  statement to the end of the routine after setting return value
- moved the msleep(10) to the beginning of the wait loop for checking the
  SLIPort_Status register
- Added the code to follow the existing wait for SLIPort_Status register RDY,
  ERR, and RN bits to be set by the port before proceeding to perform PCI
  function reset.
- Do not override ulpCt_h and ulpCt_l for SLI 4 ports.
- For vport delete, call lpfc_nlp_put when the vport's vpi state is not
  marked with VPI_REGISTERED.
- Added missed fields into the driver's Controller Attributes Structure
- Changed ringing EQ/CQ/RQ doorbell register to be dependent on the size
  of the queue.
- Return -EACCES in issue_reset if cfg_enable_hba_reset is zero.
- Added new logging flag LOG_FCP_UNDER 0x00040000 to qualify underrun logging.
- Add a check in the fabric name display routine to display 0 if the port
  state is <= FLOGI.
- Add a check to the switch statement in lpfc_decode_firmware_rev to check
  for an 'X'.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c    |   25 +++++++++++++++------
 lpfc_ct.c      |    3 ++
 lpfc_els.c     |   22 ++++++++++---------
 lpfc_hbadisc.c |    5 +++-
 lpfc_hw4.h     |    1 
 lpfc_init.c    |   23 +++++++++++++-------
 lpfc_logmsg.h  |    1 
 lpfc_scsi.c    |   34 ++++++++++++++++++-----------
 lpfc_sli.c     |   65 +++++++++++++++++++++++++++++++++++++++++++++------------
 lpfc_sli4.h    |    5 +++-
 lpfc_vport.c   |   16 +++++++++++---
 11 files changed, 143 insertions(+), 57 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-10-10 16:46:35.000000000 -0400
@@ -749,9 +749,11 @@ lpfc_issue_reset(struct device *dev, str
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-
 	int status = -EINVAL;
 
+	if (!phba->cfg_enable_hba_reset)
+		return -EACCES;
+
 	if (strncmp(buf, "selective", sizeof("selective") - 1) == 0)
 		status = phba->lpfc_selective_reset(phba);
 
@@ -772,7 +774,7 @@ lpfc_issue_reset(struct device *dev, str
  * Returns:
  * zero for success
  **/
-static int
+int
 lpfc_sli4_pdev_status_reg_wait(struct lpfc_hba *phba)
 {
 	struct lpfc_register portstat_reg = {0};
@@ -4494,9 +4496,10 @@ lpfc_get_host_fabric_name (struct Scsi_H
 
 	spin_lock_irq(shost->host_lock);
 
-	if ((vport->fc_flag & FC_FABRIC) ||
-	    ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
-	     (vport->fc_flag & FC_PUBLIC_LOOP)))
+	if ((vport->port_state > LPFC_FLOGI) &&
+	    ((vport->fc_flag & FC_FABRIC) ||
+	     ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
+	      (vport->fc_flag & FC_PUBLIC_LOOP))))
 		node_name = wwn_to_u64(phba->fc_fabparam.nodeName.u.wwn);
 	else
 		/* fabric is local port if there is no F/FL_Port */
@@ -4569,9 +4572,17 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	memset(hs, 0, sizeof (struct fc_host_statistics));
 
 	hs->tx_frames = pmb->un.varRdStatus.xmitFrameCnt;
-	hs->tx_words = (pmb->un.varRdStatus.xmitByteCnt * 256);
+	/*
+	 * The MBX_READ_STATUS returns tx_k_bytes which has to
+	 * converted to words
+	 */
+	hs->tx_words = (uint64_t)
+			((uint64_t)pmb->un.varRdStatus.xmitByteCnt
+			* (uint64_t)256);
 	hs->rx_frames = pmb->un.varRdStatus.rcvFrameCnt;
-	hs->rx_words = (pmb->un.varRdStatus.rcvByteCnt * 256);
+	hs->rx_words = (uint64_t)
+			((uint64_t)pmb->un.varRdStatus.rcvByteCnt
+			 * (uint64_t)256);
 
 	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
 	pmb->mbxCommand = MBX_READ_LNK_STAT;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2011-07-06 10:53:52.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2011-10-10 16:46:35.000000000 -0400
@@ -1856,6 +1856,9 @@ lpfc_decode_firmware_rev(struct lpfc_hba
 		case 2:
 			c = 'B';
 			break;
+		case 3:
+			c = 'X';
+			break;
 		default:
 			c = 0;
 			break;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-10-10 16:46:35.000000000 -0400
@@ -3386,7 +3386,14 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 			cmdiocb->context1 = NULL;
 		}
 	}
+
+	/*
+	 * The driver received a LOGO from the rport and has ACK'd it.
+	 * At this point, the driver is done so release the IOCB and
+	 * remove the ndlp reference.
+	 */
 	lpfc_els_free_iocb(phba, cmdiocb);
+	lpfc_nlp_put(ndlp);
 	return;
 }
 
@@ -7257,16 +7264,11 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
 	icmd->un.elsreq64.myID = 0;
 	icmd->un.elsreq64.fl = 1;
 
-	if  ((phba->sli_rev == LPFC_SLI_REV4) &&
-	     (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
-	      LPFC_SLI_INTF_IF_TYPE_0)) {
-		/* FDISC needs to be 1 for WQE VPI */
-		elsiocb->iocb.ulpCt_h = (SLI4_CT_VPI >> 1) & 1;
-		elsiocb->iocb.ulpCt_l = SLI4_CT_VPI & 1 ;
-		/* Set the ulpContext to the vpi */
-		elsiocb->iocb.ulpContext = phba->vpi_ids[vport->vpi];
-	} else {
-		/* For FDISC, Let FDISC rsp set the NPortID for this VPI */
+	/*
+	 * SLI3 ports require a different context type value than SLI4.
+	 * Catch SLI3 ports here and override the prep.
+	 */
+	if (phba->sli_rev == LPFC_SLI_REV3) {
 		icmd->ulpCt_h = 1;
 		icmd->ulpCt_l = 0;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-10-10 16:46:35.000000000 -0400
@@ -2646,7 +2646,9 @@ lpfc_init_vfi_cmpl(struct lpfc_hba *phba
 {
 	struct lpfc_vport *vport = mboxq->vport;
 
-	if (mboxq->u.mb.mbxStatus && (mboxq->u.mb.mbxStatus != 0x4002)) {
+	/* VFI not supported on interface type 0, just do the flogi */
+	if (mboxq->u.mb.mbxStatus && (bf_get(lpfc_sli_intf_if_type,
+	    &phba->sli4_hba.sli_intf) != LPFC_SLI_INTF_IF_TYPE_0)) {
 		lpfc_printf_vlog(vport, KERN_ERR,
 				LOG_MBOX,
 				"2891 Init VFI mailbox failed 0x%x\n",
@@ -2655,6 +2657,7 @@ lpfc_init_vfi_cmpl(struct lpfc_hba *phba
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		return;
 	}
+
 	lpfc_initial_flogi(vport);
 	mempool_free(mboxq, phba->mbox_mem_pool);
 	return;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-10-10 16:46:35.000000000 -0400
@@ -680,7 +680,6 @@ struct lpfc_register {
 #define lpfc_rq_doorbell_num_posted_SHIFT	16
 #define lpfc_rq_doorbell_num_posted_MASK	0x3FFF
 #define lpfc_rq_doorbell_num_posted_WORD	word0
-#define LPFC_RQ_POST_BATCH		8	/* RQEs to post at one time */
 #define lpfc_rq_doorbell_id_SHIFT		0
 #define lpfc_rq_doorbell_id_MASK		0xFFFF
 #define lpfc_rq_doorbell_id_WORD		word0
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 16:46:35.000000000 -0400
@@ -1438,6 +1438,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 	struct Scsi_Host *shost;
 	uint32_t if_type;
 	struct lpfc_register portstat_reg;
+	int rc;
 
 	/* If the pci channel is offline, ignore possible errors, since
 	 * we cannot communicate with the pci card anyway.
@@ -1480,7 +1481,12 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 			lpfc_sli4_offline_eratt(phba);
 			return;
 		}
-		if (bf_get(lpfc_sliport_status_rn, &portstat_reg)) {
+		/*
+		 * On error status condition, driver need to wait for port
+		 * ready before performing reset.
+		 */
+		rc = lpfc_sli4_pdev_status_reg_wait(phba);
+		if (!rc) {
 			/* need reset: attempt for port recovery */
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"2887 Port Error: Attempting "
@@ -6725,6 +6731,10 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 				"0540 Receive Queue not allocated\n");
 		goto out_destroy_fcp_wq;
 	}
+
+	lpfc_rq_adjust_repost(phba, phba->sli4_hba.hdr_rq, LPFC_ELS_HBQ);
+	lpfc_rq_adjust_repost(phba, phba->sli4_hba.dat_rq, LPFC_ELS_HBQ);
+
 	rc = lpfc_rq_create(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
 			    phba->sli4_hba.els_cq, LPFC_USOL);
 	if (rc) {
@@ -6733,6 +6743,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 				"rc = 0x%x\n", rc);
 		goto out_destroy_fcp_wq;
 	}
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2592 USL RQ setup: hdr-rq-id=%d, dat-rq-id=%d "
 			"parent cq-id=%d\n",
@@ -7042,10 +7053,11 @@ lpfc_pci_function_reset(struct lpfc_hba 
 			 * the loop again.
 			 */
 			for (rdy_chk = 0; rdy_chk < 1000; rdy_chk++) {
+				msleep(10);
 				if (lpfc_readl(phba->sli4_hba.u.if_type2.
 					      STATUSregaddr, &reg_data.word0)) {
 					rc = -ENODEV;
-					break;
+					goto out;
 				}
 				if (bf_get(lpfc_sliport_status_rdy, &reg_data))
 					break;
@@ -7053,7 +7065,6 @@ lpfc_pci_function_reset(struct lpfc_hba 
 					reset_again++;
 					break;
 				}
-				msleep(10);
 			}
 
 			/*
@@ -7067,11 +7078,6 @@ lpfc_pci_function_reset(struct lpfc_hba 
 			}
 
 			/* Detect any port errors. */
-			if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
-				 &reg_data.word0)) {
-				rc = -ENODEV;
-				break;
-			}
 			if ((bf_get(lpfc_sliport_status_err, &reg_data)) ||
 			    (rdy_chk >= 1000)) {
 				phba->work_status[0] = readl(
@@ -7104,6 +7110,7 @@ lpfc_pci_function_reset(struct lpfc_hba 
 		break;
 	}
 
+out:
 	/* Catch the not-ready port failure after a port reset. */
 	if (num_resets >= MAX_IF_TYPE_2_RESETS)
 		rc = -ENODEV;
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2011-10-10 16:46:35.000000000 -0400
@@ -36,6 +36,7 @@
 #define LOG_SECURITY	0x00008000	/* Security events */
 #define LOG_EVENT	0x00010000	/* CT,TEMP,DUMP, logging */
 #define LOG_FIP		0x00020000	/* FIP events */
+#define LOG_FCP_UNDER	0x00040000	/* FCP underruns errors */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-10-10 16:46:35.000000000 -0400
@@ -2325,8 +2325,9 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 	}
 	lp = (uint32_t *)cmnd->sense_buffer;
 
-	if (!scsi_status && (resp_info & RESID_UNDER))
-		logit = LOG_FCP;
+	if (!scsi_status && (resp_info & RESID_UNDER) &&
+		vport->cfg_log_verbose & LOG_FCP_UNDER)
+		logit = LOG_FCP_UNDER;
 
 	lpfc_printf_vlog(vport, KERN_WARNING, logit,
 			 "9024 FCP command x%x failed: x%x SNS x%x x%x "
@@ -2342,7 +2343,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 	if (resp_info & RESID_UNDER) {
 		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
 
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_UNDER,
 				 "9025 FCP Read Underrun, expected %d, "
 				 "residual %d Data: x%x x%x x%x\n",
 				 be32_to_cpu(fcpcmd->fcpDl),
@@ -2449,6 +2450,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct lpfc_fast_path_event *fast_path_evt;
 	struct Scsi_Host *shost;
 	uint32_t queue_depth, scsi_id;
+	uint32_t logit = LOG_FCP;
 
 	/* Sanity check on return of outstanding command */
 	if (!(lpfc_cmd->pCmd))
@@ -2470,16 +2472,22 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 		else if (lpfc_cmd->status >= IOSTAT_CNT)
 			lpfc_cmd->status = IOSTAT_DEFAULT;
-
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
-				 "9030 FCP cmd x%x failed <%d/%d> "
-				 "status: x%x result: x%x Data: x%x x%x\n",
-				 cmd->cmnd[0],
-				 cmd->device ? cmd->device->id : 0xffff,
-				 cmd->device ? cmd->device->lun : 0xffff,
-				 lpfc_cmd->status, lpfc_cmd->result,
-				 pIocbOut->iocb.ulpContext,
-				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
+		if (lpfc_cmd->status == IOSTAT_FCP_RSP_ERROR
+			&& !lpfc_cmd->fcp_rsp->rspStatus3
+			&& (lpfc_cmd->fcp_rsp->rspStatus2 & RESID_UNDER)
+			&& !(phba->cfg_log_verbose & LOG_FCP_UNDER))
+			logit = 0;
+		else
+			logit = LOG_FCP | LOG_FCP_UNDER;
+		lpfc_printf_vlog(vport, KERN_WARNING, logit,
+			 "9030 FCP cmd x%x failed <%d/%d> "
+			 "status: x%x result: x%x Data: x%x x%x\n",
+			 cmd->cmnd[0],
+			 cmd->device ? cmd->device->id : 0xffff,
+			 cmd->device ? cmd->device->lun : 0xffff,
+			 lpfc_cmd->status, lpfc_cmd->result,
+			 pIocbOut->iocb.ulpContext,
+			 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
 
 		switch (lpfc_cmd->status) {
 		case IOSTAT_FCP_RSP_ERROR:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-10-10 16:46:35.000000000 -0400
@@ -23,7 +23,6 @@
 #define LPFC_XRI_EXCH_BUSY_WAIT_T1   		10
 #define LPFC_XRI_EXCH_BUSY_WAIT_T2              30000
 #define LPFC_RELEASE_NOTIFICATION_INTERVAL	32
-#define LPFC_GET_QE_REL_INT			32
 #define LPFC_RPI_LOW_WATER_MARK			10
 
 #define LPFC_UNREG_FCF                          1
@@ -126,6 +125,8 @@ struct lpfc_queue {
 	struct list_head child_list;
 	uint32_t entry_count;	/* Number of entries to support on the queue */
 	uint32_t entry_size;	/* Size of each queue entry. */
+	uint32_t entry_repost;	/* Count of entries before doorbell is rung */
+#define LPFC_QUEUE_MIN_REPOST	8
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
 	struct list_head page_list;
@@ -553,6 +554,7 @@ struct lpfc_rsrc_blks {
  * SLI4 specific function prototypes
  */
 int lpfc_pci_function_reset(struct lpfc_hba *);
+int lpfc_sli4_pdev_status_reg_wait(struct lpfc_hba *);
 int lpfc_sli4_hba_setup(struct lpfc_hba *);
 int lpfc_sli4_config(struct lpfc_hba *, struct lpfcMboxq *, uint8_t,
 		     uint8_t, uint32_t, bool);
@@ -576,6 +578,7 @@ uint32_t lpfc_wq_create(struct lpfc_hba 
 			struct lpfc_queue *, uint32_t);
 uint32_t lpfc_rq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, struct lpfc_queue *, uint32_t);
+void lpfc_rq_adjust_repost(struct lpfc_hba *, struct lpfc_queue *, int);
 uint32_t lpfc_eq_destroy(struct lpfc_hba *, struct lpfc_queue *);
 uint32_t lpfc_cq_destroy(struct lpfc_hba *, struct lpfc_queue *);
 uint32_t lpfc_mq_destroy(struct lpfc_hba *, struct lpfc_queue *);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 16:46:35.000000000 -0400
@@ -379,10 +379,10 @@ lpfc_sli4_rq_put(struct lpfc_queue *hq, 
 	dq->host_index = ((dq->host_index + 1) % dq->entry_count);
 
 	/* Ring The Header Receive Queue Doorbell */
-	if (!(hq->host_index % LPFC_RQ_POST_BATCH)) {
+	if (!(hq->host_index % hq->entry_repost)) {
 		doorbell.word0 = 0;
 		bf_set(lpfc_rq_doorbell_num_posted, &doorbell,
-		       LPFC_RQ_POST_BATCH);
+		       hq->entry_repost);
 		bf_set(lpfc_rq_doorbell_id, &doorbell, hq->queue_id);
 		writel(doorbell.word0, hq->phba->sli4_hba.RQDBregaddr);
 	}
@@ -1864,7 +1864,7 @@ lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hb
 {
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
-					 lpfc_hbq_defs[qno]->entry_count);
+					lpfc_hbq_defs[qno]->entry_count);
 	else
 		return lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
 					 lpfc_hbq_defs[qno]->init_count);
@@ -10419,12 +10419,17 @@ lpfc_sli4_sp_handle_mbox_event(struct lp
 	/* Move mbox data to caller's mailbox region, do endian swapping */
 	if (pmb->mbox_cmpl && mbox)
 		lpfc_sli_pcimem_bcopy(mbox, mqe, sizeof(struct lpfc_mqe));
-	/* Set the mailbox status with SLI4 range 0x4000 */
-	mcqe_status = bf_get(lpfc_mcqe_status, mcqe);
-	if (mcqe_status != MB_CQE_STATUS_SUCCESS)
-		bf_set(lpfc_mqe_status, mqe,
-		       (LPFC_MBX_ERROR_RANGE | mcqe_status));
 
+	/*
+	 * For mcqe errors, conditionally move a modified error code to
+	 * the mbox so that the error will not be missed.
+	 */
+	mcqe_status = bf_get(lpfc_mcqe_status, mcqe);
+	if (mcqe_status != MB_CQE_STATUS_SUCCESS) {
+		if (bf_get(lpfc_mqe_status, mqe) == MBX_SUCCESS)
+			bf_set(lpfc_mqe_status, mqe,
+			       (LPFC_MBX_ERROR_RANGE | mcqe_status));
+	}
 	if (pmb->mbox_flag & LPFC_MBX_IMED_UNREG) {
 		pmb->mbox_flag &= ~LPFC_MBX_IMED_UNREG;
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_MBOX_VPORT,
@@ -10800,7 +10805,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba 
 	case LPFC_MCQ:
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
 			workposted |= lpfc_sli4_sp_handle_mcqe(phba, cqe);
-			if (!(++ecount % LPFC_GET_QE_REL_INT))
+			if (!(++ecount % cq->entry_repost))
 				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 		}
 		break;
@@ -10812,7 +10817,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba 
 			else
 				workposted |= lpfc_sli4_sp_handle_cqe(phba, cq,
 								      cqe);
-			if (!(++ecount % LPFC_GET_QE_REL_INT))
+			if (!(++ecount % cq->entry_repost))
 				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 		}
 		break;
@@ -11044,7 +11049,7 @@ lpfc_sli4_fp_handle_eqe(struct lpfc_hba 
 	/* Process all the entries to the CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
-		if (!(++ecount % LPFC_GET_QE_REL_INT))
+		if (!(++ecount % cq->entry_repost))
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
 
@@ -11131,7 +11136,7 @@ lpfc_sli4_sp_intr_handler(int irq, void 
 	 */
 	while ((eqe = lpfc_sli4_eq_get(speq))) {
 		lpfc_sli4_sp_handle_eqe(phba, eqe);
-		if (!(++ecount % LPFC_GET_QE_REL_INT))
+		if (!(++ecount % speq->entry_repost))
 			lpfc_sli4_eq_release(speq, LPFC_QUEUE_NOARM);
 	}
 
@@ -11211,7 +11216,7 @@ lpfc_sli4_fp_intr_handler(int irq, void 
 	 */
 	while ((eqe = lpfc_sli4_eq_get(fpeq))) {
 		lpfc_sli4_fp_handle_eqe(phba, eqe, fcp_eqidx);
-		if (!(++ecount % LPFC_GET_QE_REL_INT))
+		if (!(++ecount % fpeq->entry_repost))
 			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
 	}
 
@@ -11363,6 +11368,15 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *p
 	}
 	queue->entry_size = entry_size;
 	queue->entry_count = entry_count;
+
+	/*
+	 * entry_repost is calculated based on the number of entries in the
+	 * queue. This works out except for RQs. If buffers are NOT initially
+	 * posted for every RQE, entry_repost should be adjusted accordingly.
+	 */
+	queue->entry_repost = (entry_count >> 3);
+	if (queue->entry_repost < LPFC_QUEUE_MIN_REPOST)
+		queue->entry_repost = LPFC_QUEUE_MIN_REPOST;
 	queue->phba = phba;
 
 	return queue;
@@ -11928,6 +11942,31 @@ out:
 }
 
 /**
+ * lpfc_rq_adjust_repost - Adjust entry_repost for an RQ
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @rq:   The queue structure to use for the receive queue.
+ * @qno:  The associated HBQ number
+ *
+ *
+ * For SLI4 we need to adjust the RQ repost value based on
+ * the number of buffers that are initially posted to the RQ.
+ */
+void
+lpfc_rq_adjust_repost(struct lpfc_hba *phba, struct lpfc_queue *rq, int qno)
+{
+	uint32_t cnt;
+
+	cnt = lpfc_hbq_defs[qno]->entry_count;
+
+	/* Recalc repost for RQs based on buffers initially posted */
+	cnt = (cnt >> 3);
+	if (cnt < LPFC_QUEUE_MIN_REPOST)
+		cnt = LPFC_QUEUE_MIN_REPOST;
+
+	rq->entry_repost = cnt;
+}
+
+/**
  * lpfc_rq_create - Create a Receive Queue on the HBA
  * @phba: HBA structure that indicates port to create a queue on.
  * @hrq: The queue structure to use to create the header receive queue.
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2011-07-06 10:53:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2011-10-10 16:46:36.000000000 -0400
@@ -692,13 +692,14 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 			/* Indicate free memory when release */
 			NLP_SET_FREE_REQ(ndlp);
 		} else {
-			if (!NLP_CHK_NODE_ACT(ndlp))
+			if (!NLP_CHK_NODE_ACT(ndlp)) {
 				ndlp = lpfc_enable_node(vport, ndlp,
 						NLP_STE_UNUSED_NODE);
 				if (!ndlp)
 					goto skip_logo;
+			}
 
-			/* Remove ndlp from vport npld list */
+			/* Remove ndlp from vport list */
 			lpfc_dequeue_node(vport, ndlp);
 			spin_lock_irq(&phba->ndlp_lock);
 			if (!NLP_CHK_FREE_REQ(ndlp))
@@ -711,8 +712,17 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 			}
 			spin_unlock_irq(&phba->ndlp_lock);
 		}
-		if (!(vport->vpi_state & LPFC_VPI_REGISTERED))
+
+		/*
+		 * If the vpi is not registered, then a valid FDISC doesn't
+		 * exist and there is no need for a ELS LOGO.  Just cleanup
+		 * the ndlp.
+		 */
+		if (!(vport->vpi_state & LPFC_VPI_REGISTERED)) {
+			lpfc_nlp_put(ndlp);
 			goto skip_logo;
+		}
+
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 		if (!lpfc_issue_els_npiv_logo(vport, ndlp))



