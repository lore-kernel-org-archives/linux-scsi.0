From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/8] lpfc 8.3.24: Miscellaneous Fixes and Corrections
Date: Tue, 24 May 2011 11:40:48 -0400
Message-ID: <1306251648.6335.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23119 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753529Ab1EXPlT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2011 11:41:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Fixes and Corrections
- Remove the memset in the lpfc_sli4_remove_rpi_hdrs call.
- Correct swapping of SGE word 2 relative to offset value
- Reorganize CQ and EQ usage to comply with SLI4 Specification.
- Expand the driver to check the rn bit. Only detect an error if the error bit
  is set and the RN bit is NOT set.
- If mailbox completion code is not success AND the mailbox status is success,
  then and only then will the driver overwrite the mailbox status.
- When driver initializing device, if the device is on a PCIe bus, set
  PCI's "needs fundamental reset" bit so that EEH uses fundamental reset
  instead of hot reset for recovery.
- Prevent driver from using new WWN when changed in firmware (until driver
  reload)
- When HBA reports maximum SGE size > 0xffffffff (infinite), override
  with 0x80000000.
- Fixed potential missed SLI4 device initialization failure conditions.
- Added 100ms delay before driver action following IF_TYPE_2 function reset.
- Reverted patch to UNREG/REG on PLOGI to mapped/unmapped node.
- Add a check for the CVL received flag in the fcf inuse routine to avoid
  unregistering the fcf if Devloss fires before Delay discover timer fires.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    1 
 lpfc_crtn.h      |    1 
 lpfc_debugfs.c   |   10 ++-
 lpfc_hbadisc.c   |   22 ++++----
 lpfc_hw4.h       |    2 
 lpfc_init.c      |  146 ++++++++++++++++++++++++++++++++++++++++++-------------
 lpfc_nportdisc.c |   11 +---
 lpfc_scsi.c      |    3 +
 lpfc_sli.c       |   46 ++++++++++-------
 9 files changed, 169 insertions(+), 73 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-03-27 11:03:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-23 16:51:47.000000000 -0400
@@ -171,6 +171,7 @@ void lpfc_delayed_disc_tmo(unsigned long
 void lpfc_delayed_disc_timeout_handler(struct lpfc_vport *);
 
 int lpfc_config_port_prep(struct lpfc_hba *);
+void lpfc_update_vport_wwn(struct lpfc_vport *vport);
 int lpfc_config_port_post(struct lpfc_hba *);
 int lpfc_hba_down_prep(struct lpfc_hba *);
 int lpfc_hba_down_post(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2011-05-20 19:54:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-05-23 16:51:40.000000000 -0400
@@ -1665,7 +1665,8 @@ lpfc_idiag_queinfo_read(struct file *fil
 	/* Get fast-path complete queue information */
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
 			"Fast-path FCP CQ information:\n");
-	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++) {
+	fcp_qidx = 0;
+	do {
 		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
 				"Associated EQID[%02d]:\n",
 				phba->sli4_hba.fcp_cq[fcp_qidx]->assoc_qid);
@@ -1678,7 +1679,7 @@ lpfc_idiag_queinfo_read(struct file *fil
 				phba->sli4_hba.fcp_cq[fcp_qidx]->entry_size,
 				phba->sli4_hba.fcp_cq[fcp_qidx]->host_index,
 				phba->sli4_hba.fcp_cq[fcp_qidx]->hba_index);
-	}
+	} while (++fcp_qidx < phba->cfg_fcp_eq_count);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 
 	/* Get mailbox queue information */
@@ -2012,7 +2013,8 @@ lpfc_idiag_queacc_write(struct file *fil
 			goto pass_check;
 		}
 		/* FCP complete queue */
-		for (qidx = 0; qidx < phba->cfg_fcp_eq_count; qidx++) {
+		qidx = 0;
+		do {
 			if (phba->sli4_hba.fcp_cq[qidx]->queue_id == queid) {
 				/* Sanity check */
 				rc = lpfc_idiag_que_param_check(
@@ -2024,7 +2026,7 @@ lpfc_idiag_queacc_write(struct file *fil
 						phba->sli4_hba.fcp_cq[qidx];
 				goto pass_check;
 			}
-		}
+		} while (++qidx < phba->cfg_fcp_eq_count);
 		goto error_out;
 		break;
 	case LPFC_IDIAG_MQ:
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-05-20 19:54:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2011-05-23 16:51:47.000000000 -0400
@@ -41,6 +41,7 @@ struct lpfc_sli2_slim;
 		downloads using bsg */
 #define LPFC_DEFAULT_PROT_SG_SEG_CNT 4096 /* sg protection elements count */
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
+#define LPFC_MAX_SGE_SIZE       0x80000000 /* Maximum data allowed in a SGE */
 #define LPFC_MAX_PROT_SG_SEG_CNT 4096	/* prot sg element count per scsi cmd*/
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
 #define LPFC_Q_RAMP_UP_INTERVAL 120     /* lun q_depth ramp up interval */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-05-20 19:54:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-05-23 16:51:47.000000000 -0400
@@ -2690,16 +2690,7 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hb
 
 	memcpy((uint8_t *) &vport->fc_sparam, (uint8_t *) mp->virt,
 	       sizeof (struct serv_parm));
-	if (phba->cfg_soft_wwnn)
-		u64_to_wwn(phba->cfg_soft_wwnn,
-			   vport->fc_sparam.nodeName.u.wwn);
-	if (phba->cfg_soft_wwpn)
-		u64_to_wwn(phba->cfg_soft_wwpn,
-			   vport->fc_sparam.portName.u.wwn);
-	memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
-	       sizeof(vport->fc_nodename));
-	memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
-	       sizeof(vport->fc_portname));
+	lpfc_update_vport_wwn(vport);
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		memcpy(&phba->wwnn, &vport->fc_nodename, sizeof(phba->wwnn));
 		memcpy(&phba->wwpn, &vport->fc_portname, sizeof(phba->wwnn));
@@ -5354,6 +5345,17 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 		shost = lpfc_shost_from_vport(vports[i]);
 		spin_lock_irq(shost->host_lock);
+		/*
+		 * IF the CVL_RCVD bit is not set then we have sent the
+		 * flogi.
+		 * If dev_loss fires while we are waiting we do not want to
+		 * unreg the fcf.
+		 */
+		if (!(vports[i]->fc_flag & FC_VPORT_CVL_RCVD)) {
+			spin_unlock_irq(shost->host_lock);
+			ret =  1;
+			goto out;
+		}
 		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
 			if (NLP_CHK_NODE_ACT(ndlp) && ndlp->rport &&
 			  (ndlp->rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-20 19:54:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 16:51:40.000000000 -0400
@@ -1229,7 +1229,7 @@ struct sli4_sge {	/* SLI-4 */
 
 	uint32_t word2;
 #define lpfc_sli4_sge_offset_SHIFT	0 /* Offset of buffer - Not used*/
-#define lpfc_sli4_sge_offset_MASK	0x00FFFFFF
+#define lpfc_sli4_sge_offset_MASK	0x1FFFFFFF
 #define lpfc_sli4_sge_offset_WORD	word2
 #define lpfc_sli4_sge_last_SHIFT	31 /* Last SEG in the SGL sets
 						this  flag !! */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-05-20 19:54:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 16:51:48.000000000 -0400
@@ -309,6 +309,45 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_
 }
 
 /**
+ * lpfc_update_vport_wwn - Updates the fc_nodename, fc_portname,
+ *	cfg_soft_wwnn, cfg_soft_wwpn
+ * @vport: pointer to lpfc vport data structure.
+ *
+ *
+ * Return codes
+ *   None.
+ **/
+void
+lpfc_update_vport_wwn(struct lpfc_vport *vport)
+{
+	/* If the soft name exists then update it using the service params */
+	if (vport->phba->cfg_soft_wwnn)
+		u64_to_wwn(vport->phba->cfg_soft_wwnn,
+			   vport->fc_sparam.nodeName.u.wwn);
+	if (vport->phba->cfg_soft_wwpn)
+		u64_to_wwn(vport->phba->cfg_soft_wwpn,
+			   vport->fc_sparam.portName.u.wwn);
+
+	/*
+	 * If the name is empty or there exists a soft name
+	 * then copy the service params name, otherwise use the fc name
+	 */
+	if (vport->fc_nodename.u.wwn[0] == 0 || vport->phba->cfg_soft_wwnn)
+		memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
+			sizeof(struct lpfc_name));
+	else
+		memcpy(&vport->fc_sparam.nodeName, &vport->fc_nodename,
+			sizeof(struct lpfc_name));
+
+	if (vport->fc_portname.u.wwn[0] == 0 || vport->phba->cfg_soft_wwpn)
+		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
+			sizeof(struct lpfc_name));
+	else
+		memcpy(&vport->fc_sparam.portName, &vport->fc_portname,
+			sizeof(struct lpfc_name));
+}
+
+/**
  * lpfc_config_port_post - Perform lpfc initialization after config port
  * @phba: pointer to lpfc hba data structure.
  *
@@ -377,17 +416,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	pmb->context1 = NULL;
-
-	if (phba->cfg_soft_wwnn)
-		u64_to_wwn(phba->cfg_soft_wwnn,
-			   vport->fc_sparam.nodeName.u.wwn);
-	if (phba->cfg_soft_wwpn)
-		u64_to_wwn(phba->cfg_soft_wwpn,
-			   vport->fc_sparam.portName.u.wwn);
-	memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
-	       sizeof (struct lpfc_name));
-	memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
-	       sizeof (struct lpfc_name));
+	lpfc_update_vport_wwn(vport);
 
 	/* Update the fc_host data structures with new wwn. */
 	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
@@ -3935,6 +3964,10 @@ lpfc_enable_pci_dev(struct lpfc_hba *phb
 	pci_try_set_mwi(pdev);
 	pci_save_state(pdev);
 
+	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
+	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
+		pdev->needs_freset = 1;
+
 	return 0;
 
 out_disable_device:
@@ -4366,6 +4399,7 @@ lpfc_sli4_driver_resource_setup(struct l
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2759 Failed allocate memory for FCF round "
 				"robin failover bmask\n");
+		rc = -ENOMEM;
 		goto out_remove_rpi_hdrs;
 	}
 
@@ -4375,6 +4409,7 @@ lpfc_sli4_driver_resource_setup(struct l
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2572 Failed allocate memory for fast-path "
 				"per-EQ handle array\n");
+		rc = -ENOMEM;
 		goto out_free_fcf_rr_bmask;
 	}
 
@@ -4384,6 +4419,7 @@ lpfc_sli4_driver_resource_setup(struct l
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2573 Failed allocate memory for msi-x "
 				"interrupt vector entries\n");
+		rc = -ENOMEM;
 		goto out_free_fcp_eq_hdl;
 	}
 
@@ -4998,9 +5034,7 @@ lpfc_sli4_remove_rpi_hdrs(struct lpfc_hb
 		kfree(rpi_hdr->dmabuf);
 		kfree(rpi_hdr);
 	}
-
 	phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.rpi_base;
-	memset(phba->sli4_hba.rpi_bmask, 0, sizeof(*phba->sli4_hba.rpi_bmask));
 }
 
 /**
@@ -5487,7 +5521,8 @@ lpfc_sli4_post_status_check(struct lpfc_
 			/* Final checks.  The port status should be clean. */
 			if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
 				&reg_data.word0) ||
-				bf_get(lpfc_sliport_status_err, &reg_data)) {
+				(bf_get(lpfc_sliport_status_err, &reg_data) &&
+				 !bf_get(lpfc_sliport_status_rn, &reg_data))) {
 				phba->work_status[0] =
 					readl(phba->sli4_hba.u.if_type2.
 					      ERR1regaddr);
@@ -6229,8 +6264,10 @@ lpfc_sli4_queue_destroy(struct lpfc_hba 
 	phba->sli4_hba.mbx_cq = NULL;
 
 	/* Release FCP response complete queue */
-	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
+	fcp_qidx = 0;
+	do
 		lpfc_sli4_queue_free(phba->sli4_hba.fcp_cq[fcp_qidx]);
+	while (++fcp_qidx < phba->cfg_fcp_eq_count);
 	kfree(phba->sli4_hba.fcp_cq);
 	phba->sli4_hba.fcp_cq = NULL;
 
@@ -6353,16 +6390,24 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 			phba->sli4_hba.sp_eq->queue_id);
 
 	/* Set up fast-path FCP Response Complete Queue */
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++) {
+	fcp_cqidx = 0;
+	do {
 		if (!phba->sli4_hba.fcp_cq[fcp_cqidx]) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0526 Fast-path FCP CQ (%d) not "
 					"allocated\n", fcp_cqidx);
 			goto out_destroy_fcp_cq;
 		}
-		rc = lpfc_cq_create(phba, phba->sli4_hba.fcp_cq[fcp_cqidx],
-				    phba->sli4_hba.fp_eq[fcp_cqidx],
-				    LPFC_WCQ, LPFC_FCP);
+		if (phba->cfg_fcp_eq_count)
+			rc = lpfc_cq_create(phba,
+					    phba->sli4_hba.fcp_cq[fcp_cqidx],
+					    phba->sli4_hba.fp_eq[fcp_cqidx],
+					    LPFC_WCQ, LPFC_FCP);
+		else
+			rc = lpfc_cq_create(phba,
+					    phba->sli4_hba.fcp_cq[fcp_cqidx],
+					    phba->sli4_hba.sp_eq,
+					    LPFC_WCQ, LPFC_FCP);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0527 Failed setup of fast-path FCP "
@@ -6371,12 +6416,15 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 		}
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"2588 FCP CQ setup: cq[%d]-id=%d, "
-				"parent eq[%d]-id=%d\n",
+				"parent %seq[%d]-id=%d\n",
 				fcp_cqidx,
 				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id,
+				(phba->cfg_fcp_eq_count) ? "" : "sp_",
 				fcp_cqidx,
-				phba->sli4_hba.fp_eq[fcp_cqidx]->queue_id);
-	}
+				(phba->cfg_fcp_eq_count) ?
+				   phba->sli4_hba.fp_eq[fcp_cqidx]->queue_id :
+				   phba->sli4_hba.sp_eq->queue_id);
+	} while (++fcp_cqidx < phba->cfg_fcp_eq_count);
 
 	/*
 	 * Set up all the Work Queues (WQs)
@@ -6445,7 +6493,9 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 				fcp_cq_index,
 				phba->sli4_hba.fcp_cq[fcp_cq_index]->queue_id);
 		/* Round robin FCP Work Queue's Completion Queue assignment */
-		fcp_cq_index = ((fcp_cq_index + 1) % phba->cfg_fcp_eq_count);
+		if (phba->cfg_fcp_eq_count)
+			fcp_cq_index = ((fcp_cq_index + 1) %
+					phba->cfg_fcp_eq_count);
 	}
 
 	/*
@@ -6827,6 +6877,8 @@ lpfc_pci_function_reset(struct lpfc_hba 
 			if (rdy_chk < 1000)
 				break;
 		}
+		/* delay driver action following IF_TYPE_2 function reset */
+		msleep(100);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
@@ -7419,11 +7471,15 @@ enable_msix_vectors:
 	/*
 	 * Assign MSI-X vectors to interrupt handlers
 	 */
-
-	/* The first vector must associated to slow-path handler for MQ */
-	rc = request_irq(phba->sli4_hba.msix_entries[0].vector,
-			 &lpfc_sli4_sp_intr_handler, IRQF_SHARED,
-			 LPFC_SP_DRIVER_HANDLER_NAME, phba);
+	if (vectors > 1)
+		rc = request_irq(phba->sli4_hba.msix_entries[0].vector,
+				 &lpfc_sli4_sp_intr_handler, IRQF_SHARED,
+				 LPFC_SP_DRIVER_HANDLER_NAME, phba);
+	else
+		/* All Interrupts need to be handled by one EQ */
+		rc = request_irq(phba->sli4_hba.msix_entries[0].vector,
+				 &lpfc_sli4_intr_handler, IRQF_SHARED,
+				 LPFC_DRIVER_NAME, phba);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0485 MSI-X slow-path request_irq failed "
@@ -7878,6 +7934,11 @@ lpfc_pc_sli4_params_get(struct lpfc_hba 
 	sli4_params->hdr_pp_align = bf_get(hdr_pp_align, &mqe->un.sli4_params);
 	sli4_params->sgl_pages_max = bf_get(sgl_pages, &mqe->un.sli4_params);
 	sli4_params->sgl_pp_align = bf_get(sgl_pp_align, &mqe->un.sli4_params);
+
+	/* Make sure that sge_supp_len can be handled by the driver */
+	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
+		sli4_params->sge_supp_len = LPFC_MAX_SGE_SIZE;
+
 	return rc;
 }
 
@@ -7938,6 +7999,11 @@ lpfc_get_sli4_parameters(struct lpfc_hba
 					    mbx_sli4_parameters);
 	sli4_params->sgl_pp_align = bf_get(cfg_sgl_pp_align,
 					   mbx_sli4_parameters);
+
+	/* Make sure that sge_supp_len can be handled by the driver */
+	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
+		sli4_params->sge_supp_len = LPFC_MAX_SGE_SIZE;
+
 	return 0;
 }
 
@@ -8591,6 +8657,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	int error;
 	uint32_t cfg_mode, intr_mode;
 	int mcnt;
+	int adjusted_fcp_eq_count;
+	int fcp_qidx;
 
 	/* Allocate memory for HBA structure */
 	phba = lpfc_hba_alloc(pdev);
@@ -8688,11 +8756,25 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 			error = -ENODEV;
 			goto out_free_sysfs_attr;
 		}
-		/* Default to single FCP EQ for non-MSI-X */
+		/* Default to single EQ for non-MSI-X */
 		if (phba->intr_type != MSIX)
-			phba->cfg_fcp_eq_count = 1;
-		else if (phba->sli4_hba.msix_vec_nr < phba->cfg_fcp_eq_count)
-			phba->cfg_fcp_eq_count = phba->sli4_hba.msix_vec_nr - 1;
+			adjusted_fcp_eq_count = 0;
+		else if (phba->sli4_hba.msix_vec_nr <
+					phba->cfg_fcp_eq_count + 1)
+			adjusted_fcp_eq_count = phba->sli4_hba.msix_vec_nr - 1;
+		else
+			adjusted_fcp_eq_count = phba->cfg_fcp_eq_count;
+		/* Free unused EQs */
+		for (fcp_qidx = adjusted_fcp_eq_count;
+		     fcp_qidx < phba->cfg_fcp_eq_count;
+		     fcp_qidx++) {
+			lpfc_sli4_queue_free(phba->sli4_hba.fp_eq[fcp_qidx]);
+			/* do not delete the first fcp_cq */
+			if (fcp_qidx)
+				lpfc_sli4_queue_free(
+					phba->sli4_hba.fcp_cq[fcp_qidx]);
+		}
+		phba->cfg_fcp_eq_count = adjusted_fcp_eq_count;
 		/* Set up SLI-4 HBA */
 		if (lpfc_sli4_hba_setup(phba)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2011-04-16 08:29:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2011-05-23 16:51:48.000000000 -0400
@@ -350,11 +350,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	ndlp->nlp_maxframe =
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
 
-	/*
-	 * Need to unreg_login if we are already in one of these states and
-	 * change to NPR state. This will block the port until after the ACC
-	 * completes and the reg_login is issued and completed.
-	 */
+	/* no need to reg_login if we are already in one of these states */
 	switch (ndlp->nlp_state) {
 	case  NLP_STE_NPR_NODE:
 		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
@@ -363,9 +359,8 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	case  NLP_STE_PRLI_ISSUE:
 	case  NLP_STE_UNMAPPED_NODE:
 	case  NLP_STE_MAPPED_NODE:
-		lpfc_unreg_rpi(vport, ndlp);
-		ndlp->nlp_prev_state = ndlp->nlp_state;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
+		return 1;
 	}
 
 	if ((vport->fc_flag & FC_PT2PT) &&
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-05-20 19:54:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-05-23 16:51:40.000000000 -0400
@@ -861,6 +861,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		 */
 		sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_cmd));
 		sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_cmd));
+		sgl->word2 = le32_to_cpu(sgl->word2);
 		bf_set(lpfc_sli4_sge_last, sgl, 0);
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		sgl->sge_len = cpu_to_le32(sizeof(struct fcp_cmnd));
@@ -869,6 +870,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		/* Setup the physical region for the FCP RSP */
 		sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_rsp));
 		sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_rsp));
+		sgl->word2 = le32_to_cpu(sgl->word2);
 		bf_set(lpfc_sli4_sge_last, sgl, 1);
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		sgl->sge_len = cpu_to_le32(sizeof(struct fcp_rsp));
@@ -2081,6 +2083,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 			dma_len = sg_dma_len(sgel);
 			sgl->addr_lo = cpu_to_le32(putPaddrLow(physaddr));
 			sgl->addr_hi = cpu_to_le32(putPaddrHigh(physaddr));
+			sgl->word2 = le32_to_cpu(sgl->word2);
 			if ((num_bde + 1) == nseg)
 				bf_set(lpfc_sli4_sge_last, sgl, 1);
 			else
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-05-20 19:54:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-05-23 16:51:48.000000000 -0400
@@ -65,6 +65,9 @@ static struct lpfc_iocbq *lpfc_sli4_els_
 							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
+static int lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *, struct lpfc_queue *,
+				    struct lpfc_cqe *);
+
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
 {
@@ -3881,8 +3884,10 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 	list_del_init(&phba->sli4_hba.els_cq->list);
 	for (qindx = 0; qindx < phba->cfg_fcp_wq_count; qindx++)
 		list_del_init(&phba->sli4_hba.fcp_wq[qindx]->list);
-	for (qindx = 0; qindx < phba->cfg_fcp_eq_count; qindx++)
+	qindx = 0;
+	do
 		list_del_init(&phba->sli4_hba.fcp_cq[qindx]->list);
+	while (++qindx < phba->cfg_fcp_eq_count);
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Now physically reset the device */
@@ -4677,9 +4682,11 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba 
 
 	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
 	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++)
+	fcp_eqidx = 0;
+	do
 		lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[fcp_eqidx],
 				     LPFC_QUEUE_REARM);
+	while (++fcp_eqidx < phba->cfg_fcp_eq_count);
 	lpfc_sli4_eq_release(phba->sli4_hba.sp_eq, LPFC_QUEUE_REARM);
 	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++)
 		lpfc_sli4_eq_release(phba->sli4_hba.fp_eq[fcp_eqidx],
@@ -4740,7 +4747,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	 * to read FCoE param config regions
 	 */
 	if (lpfc_sli4_read_fcoe_params(phba, mboxq))
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_INIT,
 			"2570 Failed to read FCoE parameters\n");
 
 	/* Issue READ_REV to collect vpd and FW information. */
@@ -4906,16 +4913,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		goto out_free_mbox;
 	}
 
-	if (phba->cfg_soft_wwnn)
-		u64_to_wwn(phba->cfg_soft_wwnn,
-			   vport->fc_sparam.nodeName.u.wwn);
-	if (phba->cfg_soft_wwpn)
-		u64_to_wwn(phba->cfg_soft_wwpn,
-			   vport->fc_sparam.portName.u.wwn);
-	memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
-	       sizeof(struct lpfc_name));
-	memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
-	       sizeof(struct lpfc_name));
+	lpfc_update_vport_wwn(vport);
 
 	/* Update the fc_host data structures with new wwn. */
 	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
@@ -5747,10 +5745,15 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 	lpfc_sli_pcimem_bcopy(&mbox_rgn->mcqe, &mboxq->mcqe,
 			      sizeof(struct lpfc_mcqe));
 	mcqe_status = bf_get(lpfc_mcqe_status, &mbox_rgn->mcqe);
-
-	/* Prefix the mailbox status with range x4000 to note SLI4 status. */
+	/*
+	 * When the CQE status indicates a failure and the mailbox status
+	 * indicates success then copy the CQE status into the mailbox status
+	 * (and prefix it with x4000).
+	 */
 	if (mcqe_status != MB_CQE_STATUS_SUCCESS) {
-		bf_set(lpfc_mqe_status, mb, LPFC_MBX_ERROR_RANGE | mcqe_status);
+		if (bf_get(lpfc_mqe_status, mb) == MBX_SUCCESS)
+			bf_set(lpfc_mqe_status, mb,
+			       (LPFC_MBX_ERROR_RANGE | mcqe_status));
 		rc = MBXERR_ERROR;
 	} else
 		lpfc_sli4_swap_str(phba, mboxq);
@@ -5819,7 +5822,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 		else
 			rc = -EIO;
 		if (rc != MBX_SUCCESS)
-			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
 					"(%d):2541 Mailbox command x%x "
 					"(x%x) cannot issue Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
@@ -6307,6 +6310,7 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 			sgl->addr_hi = bpl->addrHigh;
 			sgl->addr_lo = bpl->addrLow;
 
+			sgl->word2 = le32_to_cpu(sgl->word2);
 			if ((i+1) == numBdes)
 				bf_set(lpfc_sli4_sge_last, sgl, 1);
 			else
@@ -6343,6 +6347,7 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 				cpu_to_le32(icmd->un.genreq64.bdl.addrHigh);
 			sgl->addr_lo =
 				cpu_to_le32(icmd->un.genreq64.bdl.addrLow);
+			sgl->word2 = le32_to_cpu(sgl->word2);
 			bf_set(lpfc_sli4_sge_last, sgl, 1);
 			sgl->word2 = cpu_to_le32(sgl->word2);
 			sgl->sge_len =
@@ -9799,7 +9804,12 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba 
 		break;
 	case LPFC_WCQ:
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
-			workposted |= lpfc_sli4_sp_handle_cqe(phba, cq, cqe);
+			if (cq->subtype == LPFC_FCP)
+				workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq,
+								       cqe);
+			else
+				workposted |= lpfc_sli4_sp_handle_cqe(phba, cq,
+								      cqe);
 			if (!(++ecount % LPFC_GET_QE_REL_INT))
 				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 		}


