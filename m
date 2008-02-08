From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/6] lpfc 8.2.5 : Miscellaneous discovery Fixes
Date: Fri, 08 Feb 2008 18:50:14 -0500
Message-ID: <1202514614.20924.17.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44706 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYBHXuD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 18:50:03 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m18No0U0018595
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 15:50:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous discovery fixes:
- Flush RSCN buffers on vports when reseting HBA.
- Fix incorrect FLOGI after vport reg failed
- Fix a potential fabric ELS race condition 
- Fix handling of failed PLOGI command under high lip rates
- Fix FDISC handling
- Fix debug logging for npiv handling


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h        |    1 
 lpfc_ct.c     |    2 
 lpfc_disc.h   |   33 +++++++-------
 lpfc_els.c    |  133 ++++++++++++++++++++++++++++++++++++++++------------------
 lpfc_hw.h     |    1 
 lpfc_init.c   |    5 +-
 lpfc_logmsg.h |   10 +++-
 lpfc_mem.c    |    4 +
 lpfc_sli.c    |    4 -
 9 files changed, 127 insertions(+), 66 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-02-08 18:10:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-02-08 18:13:15.000000000 -0500
@@ -775,7 +775,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba 
 				 "0267 NameServer GFF Rsp "
 				 "x%x Error (%d %d) Data: x%x x%x\n",
 				 did, irsp->ulpStatus, irsp->un.ulpWord[4],
-				 vport->fc_flag, vport->fc_rscn_id_cnt)
+				 vport->fc_flag, vport->fc_rscn_id_cnt);
 	}
 
 	/* This is a target port, unregistered port, or the GFF_ID failed */
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2008-02-08 18:10:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2008-02-08 18:12:46.000000000 -0500
@@ -91,25 +91,26 @@ struct lpfc_nodelist {
 };
 
 /* Defines for nlp_flag (uint32) */
-#define NLP_PLOGI_SND      0x20		/* sent PLOGI request for this entry */
-#define NLP_PRLI_SND       0x40		/* sent PRLI request for this entry */
-#define NLP_ADISC_SND      0x80		/* sent ADISC request for this entry */
-#define NLP_LOGO_SND       0x100	/* sent LOGO request for this entry */
-#define NLP_RNID_SND       0x400	/* sent RNID request for this entry */
-#define NLP_ELS_SND_MASK   0x7e0	/* sent ELS request for this entry */
-#define NLP_DEFER_RM       0x10000	/* Remove this ndlp if no longer used */
-#define NLP_DELAY_TMO      0x20000	/* delay timeout is running for node */
-#define NLP_NPR_2B_DISC    0x40000	/* node is included in num_disc_nodes */
-#define NLP_RCV_PLOGI      0x80000	/* Rcv'ed PLOGI from remote system */
-#define NLP_LOGO_ACC       0x100000	/* Process LOGO after ACC completes */
-#define NLP_TGT_NO_SCSIID  0x200000	/* good PRLI but no binding for scsid */
-#define NLP_ACC_REGLOGIN   0x1000000	/* Issue Reg Login after successful
+#define NLP_PLOGI_SND      0x00000020	/* sent PLOGI request for this entry */
+#define NLP_PRLI_SND       0x00000040	/* sent PRLI request for this entry */
+#define NLP_ADISC_SND      0x00000080	/* sent ADISC request for this entry */
+#define NLP_LOGO_SND       0x00000100	/* sent LOGO request for this entry */
+#define NLP_RNID_SND       0x00000400	/* sent RNID request for this entry */
+#define NLP_ELS_SND_MASK   0x000007e0	/* sent ELS request for this entry */
+#define NLP_DEFER_RM       0x00010000	/* Remove this ndlp if no longer used */
+#define NLP_DELAY_TMO      0x00020000	/* delay timeout is running for node */
+#define NLP_NPR_2B_DISC    0x00040000	/* node is included in num_disc_nodes */
+#define NLP_RCV_PLOGI      0x00080000	/* Rcv'ed PLOGI from remote system */
+#define NLP_LOGO_ACC       0x00100000	/* Process LOGO after ACC completes */
+#define NLP_TGT_NO_SCSIID  0x00200000	/* good PRLI but no binding for scsid */
+#define NLP_ACC_REGLOGIN   0x01000000	/* Issue Reg Login after successful
 					   ACC */
-#define NLP_NPR_ADISC      0x2000000	/* Issue ADISC when dq'ed from
+#define NLP_NPR_ADISC      0x02000000	/* Issue ADISC when dq'ed from
 					   NPR list */
-#define NLP_RM_DFLT_RPI    0x4000000	/* need to remove leftover dflt RPI */
-#define NLP_NODEV_REMOVE   0x8000000	/* Defer removal till discovery ends */
+#define NLP_RM_DFLT_RPI    0x04000000	/* need to remove leftover dflt RPI */
+#define NLP_NODEV_REMOVE   0x08000000	/* Defer removal till discovery ends */
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
+#define NLP_SC_REQ         0x20000000	/* Target requires authentication */
 
 /* ndlp usage management macros */
 #define NLP_CHK_NODE_ACT(ndlp)		(((ndlp)->nlp_usg_map \
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-02-08 18:11:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-02-08 18:13:04.000000000 -0500
@@ -1920,18 +1920,15 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			break;
 
 		case IOERR_ILLEGAL_COMMAND:
-			if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) &&
-			    (cmd == ELS_CMD_FDISC)) {
-				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-						 "0124 FDISC failed (3/6) "
-						 "retrying...\n");
-				lpfc_mbx_unreg_vpi(vport);
-				retry = 1;
-				/* FDISC retry policy */
-				maxretry = 48;
-				if (cmdiocb->retry >= 32)
-					delay = 1000;
-			}
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+					 "0124 Retry illegal cmd x%x "
+					 "retry:x%x delay:x%x\n",
+					 cmd, cmdiocb->retry, delay);
+			retry = 1;
+			/* All command's retry policy */
+			maxretry = 8;
+			if (cmdiocb->retry > 2)
+				delay = 1000;
 			break;
 
 		case IOERR_NO_RESOURCES:
@@ -2017,6 +2014,17 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			break;
 
 		case LSRJT_LOGICAL_ERR:
+			/* There are some cases where switches return this
+			 * error when they are not ready and should be returning
+			 * Logical Busy. We should delay every time.
+			 */
+			if (cmd == ELS_CMD_FDISC &&
+			    stat.un.b.lsRjtRsnCodeExp == LSEXP_PORT_LOGIN_REQ) {
+				maxretry = 3;
+				delay = 1000;
+				retry = 1;
+				break;
+			}
 		case LSRJT_PROTOCOL_ERR:
 			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 			  (cmd == ELS_CMD_FDISC) &&
@@ -2931,6 +2939,16 @@ lpfc_els_flush_rscn(struct lpfc_vport *v
 	struct lpfc_hba  *phba = vport->phba;
 	int i;
 
+	spin_lock_irq(shost->host_lock);
+	if (vport->fc_rscn_flush) {
+		/* Another thread is walking fc_rscn_id_list on this vport */
+		spin_unlock_irq(shost->host_lock);
+		return;
+	}
+	/* Indicate we are walking lpfc_els_flush_rscn on this vport */
+	vport->fc_rscn_flush = 1;
+	spin_unlock_irq(shost->host_lock);
+
 	for (i = 0; i < vport->fc_rscn_id_cnt; i++) {
 		lpfc_in_buf_free(phba, vport->fc_rscn_id_list[i]);
 		vport->fc_rscn_id_list[i] = NULL;
@@ -2940,6 +2958,8 @@ lpfc_els_flush_rscn(struct lpfc_vport *v
 	vport->fc_flag &= ~(FC_RSCN_MODE | FC_RSCN_DISCOVERY);
 	spin_unlock_irq(shost->host_lock);
 	lpfc_can_disctmo(vport);
+	/* Indicate we are done walking this fc_rscn_id_list */
+	vport->fc_rscn_flush = 0;
 }
 
 int
@@ -2949,6 +2969,7 @@ lpfc_rscn_payload_check(struct lpfc_vpor
 	D_ID rscn_did;
 	uint32_t *lp;
 	uint32_t payload_len, i;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	ns_did.un.word = did;
 
@@ -2960,6 +2981,15 @@ lpfc_rscn_payload_check(struct lpfc_vpor
 	if (vport->fc_flag & FC_RSCN_DISCOVERY)
 		return did;
 
+	spin_lock_irq(shost->host_lock);
+	if (vport->fc_rscn_flush) {
+		/* Another thread is walking fc_rscn_id_list on this vport */
+		spin_unlock_irq(shost->host_lock);
+		return 0;
+	}
+	/* Indicate we are walking fc_rscn_id_list on this vport */
+	vport->fc_rscn_flush = 1;
+	spin_unlock_irq(shost->host_lock);
 	for (i = 0; i < vport->fc_rscn_id_cnt; i++) {
 		lp = vport->fc_rscn_id_list[i]->virt;
 		payload_len = be32_to_cpu(*lp++ & ~ELS_CMD_MASK);
@@ -2970,16 +3000,16 @@ lpfc_rscn_payload_check(struct lpfc_vpor
 			switch (rscn_did.un.b.resv) {
 			case 0:	/* Single N_Port ID effected */
 				if (ns_did.un.word == rscn_did.un.word)
-					return did;
+					goto return_did_out;
 				break;
 			case 1:	/* Whole N_Port Area effected */
 				if ((ns_did.un.b.domain == rscn_did.un.b.domain)
 				    && (ns_did.un.b.area == rscn_did.un.b.area))
-					return did;
+					goto return_did_out;
 				break;
 			case 2:	/* Whole N_Port Domain effected */
 				if (ns_did.un.b.domain == rscn_did.un.b.domain)
-					return did;
+					goto return_did_out;
 				break;
 			default:
 				/* Unknown Identifier in RSCN node */
@@ -2988,11 +3018,17 @@ lpfc_rscn_payload_check(struct lpfc_vpor
 						 "RSCN payload Data: x%x\n",
 						 rscn_did.un.word);
 			case 3:	/* Whole Fabric effected */
-				return did;
+				goto return_did_out;
 			}
 		}
 	}
+	/* Indicate we are done with walking fc_rscn_id_list on this vport */
+	vport->fc_rscn_flush = 0;
 	return 0;
+return_did_out:
+	/* Indicate we are done with walking fc_rscn_id_list on this vport */
+	vport->fc_rscn_flush = 0;
+	return did;
 }
 
 static int
@@ -3034,7 +3070,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	uint32_t *lp, *datap;
 	IOCB_t *icmd;
 	uint32_t payload_len, length, nportid, *cmd;
-	int rscn_cnt = vport->fc_rscn_id_cnt;
+	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
 	int i;
 
@@ -3047,7 +3083,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	/* RSCN received */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0214 RSCN received Data: x%x x%x x%x x%x\n",
-			 vport->fc_flag, payload_len, *lp, rscn_cnt);
+			 vport->fc_flag, payload_len, *lp,
+			 vport->fc_rscn_id_cnt);
 	for (i = 0; i < payload_len/sizeof(uint32_t); i++)
 		fc_host_post_event(shost, fc_get_event_number(),
 			FCH_EVT_RSCN, lp[i]);
@@ -3085,7 +3122,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 					 "0214 Ignore RSCN "
 					 "Data: x%x x%x x%x x%x\n",
 					 vport->fc_flag, payload_len,
-					 *lp, rscn_cnt);
+					 *lp, vport->fc_rscn_id_cnt);
 			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 				"RCV RSCN vport:  did:x%x/ste:x%x flg:x%x",
 				ndlp->nlp_DID, vport->port_state,
@@ -3097,6 +3134,18 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 		}
 	}
 
+	spin_lock_irq(shost->host_lock);
+	if (vport->fc_rscn_flush) {
+		/* Another thread is walking fc_rscn_id_list on this vport */
+		spin_unlock_irq(shost->host_lock);
+		vport->fc_flag |= FC_RSCN_DISCOVERY;
+		return 0;
+	}
+	/* Indicate we are walking fc_rscn_id_list on this vport */
+	vport->fc_rscn_flush = 1;
+	spin_unlock_irq(shost->host_lock);
+	/* Get the array count after sucessfully have the token */
+	rscn_cnt = vport->fc_rscn_id_cnt;
 	/* If we are already processing an RSCN, save the received
 	 * RSCN payload buffer, cmdiocb->context2 to process later.
 	 */
@@ -3118,7 +3167,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 			if ((rscn_cnt) &&
 			    (payload_len + length <= LPFC_BPL_SIZE)) {
 				*cmd &= ELS_CMD_MASK;
-				*cmd |= be32_to_cpu(payload_len + length);
+				*cmd |= cpu_to_be32(payload_len + length);
 				memcpy(((uint8_t *)cmd) + length, lp,
 				       payload_len);
 			} else {
@@ -3129,7 +3178,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 				 */
 				cmdiocb->context2 = NULL;
 			}
-
 			/* Deferred RSCN */
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0235 Deferred RSCN "
@@ -3146,9 +3194,10 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 					 vport->fc_rscn_id_cnt, vport->fc_flag,
 					 vport->port_state);
 		}
+		/* Indicate we are done walking fc_rscn_id_list on this vport */
+		vport->fc_rscn_flush = 0;
 		/* Send back ACC */
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
-
 		/* send RECOVERY event for ALL nodes that match RSCN payload */
 		lpfc_rscn_recovery_check(vport);
 		spin_lock_irq(shost->host_lock);
@@ -3156,7 +3205,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 		spin_unlock_irq(shost->host_lock);
 		return 0;
 	}
-
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 		"RCV RSCN:        did:x%x/ste:x%x flg:x%x",
 		ndlp->nlp_DID, vport->port_state, ndlp->nlp_flag);
@@ -3165,20 +3213,18 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	vport->fc_flag |= FC_RSCN_MODE;
 	spin_unlock_irq(shost->host_lock);
 	vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] = pcmd;
+	/* Indicate we are done walking fc_rscn_id_list on this vport */
+	vport->fc_rscn_flush = 0;
 	/*
 	 * If we zero, cmdiocb->context2, the calling routine will
 	 * not try to free it.
 	 */
 	cmdiocb->context2 = NULL;
-
 	lpfc_set_disctmo(vport);
-
 	/* Send back ACC */
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
-
 	/* send RECOVERY event for ALL nodes that match RSCN payload */
 	lpfc_rscn_recovery_check(vport);
-
 	return lpfc_els_handle_rscn(vport);
 }
 
@@ -4343,15 +4389,15 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 			vport = lpfc_find_vport_by_vpid(phba, vpi);
 		}
 	}
-				/* If there are no BDEs associated
-				 * with this IOCB, there is nothing to do.
-				 */
+	/* If there are no BDEs associated
+	 * with this IOCB, there is nothing to do.
+	 */
 	if (icmd->ulpBdeCount == 0)
 		return;
 
-				/* type of ELS cmd is first 32bit word
-				 * in packet
-				 */
+	/* type of ELS cmd is first 32bit word
+	 * in packet
+	 */
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		elsiocb->context2 = bdeBuf1;
 	} else {
@@ -4464,6 +4510,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 		switch (mb->mbxStatus) {
 		case 0x11:	/* unsupported feature */
 		case 0x9603:	/* max_vpi exceeded */
+		case 0x9602:	/* Link event since CLEAR_LA */
 			/* giving up on vport registration */
 			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 			spin_lock_irq(shost->host_lock);
@@ -4477,7 +4524,10 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 			spin_unlock_irq(shost->host_lock);
-			lpfc_initial_fdisc(vport);
+			if (vport->port_type == LPFC_PHYSICAL_PORT)
+				lpfc_initial_flogi(vport);
+			else
+				lpfc_initial_fdisc(vport);
 			break;
 		}
 
@@ -4795,11 +4845,12 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba
 repeat:
 	iocb = NULL;
 	spin_lock_irqsave(&phba->hbalock, iflags);
-				/* Post any pending iocb to the SLI layer */
+	/* Post any pending iocb to the SLI layer */
 	if (atomic_read(&phba->fabric_iocb_count) == 0) {
 		list_remove_head(&phba->fabric_iocb_list, iocb, typeof(*iocb),
 				 list);
 		if (iocb)
+			/* Increment fabric iocb count to hold the position */
 			atomic_inc(&phba->fabric_iocb_count);
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -4846,9 +4897,7 @@ lpfc_block_fabric_iocbs(struct lpfc_hba 
 	int blocked;
 
 	blocked = test_and_set_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags);
-				/* Start a timer to unblock fabric
-				 * iocbs after 100ms
-				 */
+	/* Start a timer to unblock fabric iocbs after 100ms */
 	if (!blocked)
 		mod_timer(&phba->fabric_block_timer, jiffies + HZ/10 );
 
@@ -4896,8 +4945,8 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *p
 
 	atomic_dec(&phba->fabric_iocb_count);
 	if (!test_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags)) {
-				/* Post any pending iocbs to HBA */
-		    lpfc_resume_fabric_iocbs(phba);
+		/* Post any pending iocbs to HBA */
+		lpfc_resume_fabric_iocbs(phba);
 	}
 }
 
@@ -4916,6 +4965,9 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *
 	ready = atomic_read(&phba->fabric_iocb_count) == 0 &&
 		!test_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags);
 
+	if (ready)
+		/* Increment fabric iocb count to hold the position */
+		atomic_inc(&phba->fabric_iocb_count);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (ready) {
 		iocb->fabric_iocb_cmpl = iocb->iocb_cmpl;
@@ -4926,7 +4978,6 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *
 			"Fabric sched2:   ste:x%x",
 			iocb->vport->port_state, 0, 0);
 
-		atomic_inc(&phba->fabric_iocb_count);
 		ret = lpfc_sli_issue_iocb(phba, pring, iocb, 0);
 
 		if (ret == IOCB_ERROR) {
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:12:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:12:31.000000000 -0500
@@ -307,6 +307,7 @@ struct lpfc_vport {
 
 	uint32_t fc_nlp_cnt;	/* outstanding NODELIST requests */
 	uint32_t fc_rscn_id_cnt;	/* count of RSCNs payloads in list */
+	uint32_t fc_rscn_flush;		/* flag use of fc_rscn_id_list */
 	struct lpfc_dmabuf *fc_rscn_id_list[FC_MAX_HOLD_RSCN];
 	struct lpfc_name fc_nodename;	/* fc nodename */
 	struct lpfc_name fc_portname;	/* fc portname */
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-02-08 18:13:04.000000000 -0500
@@ -581,6 +581,7 @@ struct ls_rjt {	/* Structure is in Big E
 #define LSEXP_INVALID_O_SID     0x15
 #define LSEXP_INVALID_OX_RX     0x17
 #define LSEXP_CMD_IN_PROGRESS   0x19
+#define LSEXP_PORT_LOGIN_REQ    0x1E
 #define LSEXP_INVALID_NPORT_ID  0x1F
 #define LSEXP_INVALID_SEQ_ID    0x21
 #define LSEXP_INVALID_XCHG      0x23
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:12:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:12:31.000000000 -0500
@@ -475,7 +475,8 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
 			for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++)
 				lpfc_cleanup_discovery_resources(vports[i]);
 		lpfc_destroy_vport_work_array(phba, vports);
-	}	return 0;
+	}
+	return 0;
 }
 
 /************************************************************************/
@@ -1740,9 +1741,9 @@ lpfc_create_port(struct lpfc_hba *phba, 
 
 	vport = (struct lpfc_vport *) shost->hostdata;
 	vport->phba = phba;
-
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+	vport->fc_rscn_flush = 0;
 
 	lpfc_get_vport_cfgparam(vport);
 	shost->unique_id = instance;
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2008-02-08 18:13:15.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -35,11 +35,15 @@
 #define LOG_ALL_MSG                   0xffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
+	do { \
 	{ if (((mask) &(vport)->cfg_log_verbose) || (level[1] <= '3')) \
 		dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
-			   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); }
+			   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); } \
+	} while (0)
 
 #define lpfc_printf_log(phba, level, mask, fmt, arg...) \
+	do { \
 	{ if (((mask) &(phba)->pport->cfg_log_verbose) || (level[1] <= '3')) \
 		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
-			   fmt, phba->brd_no, ##arg); }
+			   fmt, phba->brd_no, ##arg); } \
+	} while (0)
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2008-02-08 18:12:31.000000000 -0500
@@ -265,6 +265,9 @@ lpfc_in_buf_free(struct lpfc_hba *phba, 
 {
 	struct hbq_dmabuf *hbq_entry;
 
+	if (!mp)
+		return;
+
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
 		if (hbq_entry->tag == -1) {
@@ -279,4 +282,3 @@ lpfc_in_buf_free(struct lpfc_hba *phba, 
 	}
 	return;
 }
-
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-02-08 18:11:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-02-08 18:13:15.000000000 -0500
@@ -2623,14 +2623,14 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 
 		/* Mbox command <mbxCommand> cannot issue */
-		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag)
+		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
 		return MBX_NOT_FINISHED;
 	}
 
 	if (mb->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT &&
 	    !(readl(phba->HCregaddr) & HC_MBINT_ENA)) {
 		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
-		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag)
+		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
 		return MBX_NOT_FINISHED;
 	}
 


