From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/7] lpfc 8.3.28: SLI fixes and added SLI4 support
Date: Tue, 13 Dec 2011 13:21:35 -0500
Message-ID: <1323800496.1111.12.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:31044 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755396Ab1LMS0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2011 13:26:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adapter (SLI) interface fixes:

- Modify WQ handling to use entry_repost (CR 123981)
- Fix for ABTS.  Do not free original IOCB whenever ABTS fails. (CR 115829)
- Check board for FCoE before reading FCoE paramaters (CR124731)
- Add support for SLI4 FC Loop mode (CR 124721)
- Add support for resource count changes during fw reset. (CR 125888, 125675)
- Increase CQE count from 256 to 1024. (CR 126149)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c    |   23 +++++++
 lpfc_crtn.h    |    2 
 lpfc_els.c     |   18 ++---
 lpfc_hbadisc.c |    1 
 lpfc_init.c    |   52 +++++++++++++---
 lpfc_sli.c     |  184 ++++++++++++++++++++++++---------------------------------
 lpfc_sli4.h    |    2 
 7 files changed, 156 insertions(+), 126 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-12-12 20:49:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-12-12 20:50:38.000000000 -0500
@@ -2777,6 +2777,14 @@ lpfc_topology_store(struct device *dev, 
 	if (val >= 0 && val <= 6) {
 		prev_val = phba->cfg_topology;
 		phba->cfg_topology = val;
+		if (phba->cfg_link_speed == LPFC_USER_LINK_SPEED_16G &&
+			val == 4) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				"3113 Loop mode not supported at speed %d\n",
+				phba->cfg_link_speed);
+			phba->cfg_topology = prev_val;
+			return -EINVAL;
+		}
 		if (nolip)
 			return strlen(buf);
 
@@ -3222,6 +3230,14 @@ lpfc_link_speed_store(struct device *dev
 				val);
 		return -EINVAL;
 	}
+	if (val == LPFC_USER_LINK_SPEED_16G &&
+		 phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3112 lpfc_link_speed attribute cannot be set "
+				"to %d. Speed is not supported in loop mode.\n",
+				val);
+		return -EINVAL;
+	}
 	if ((val >= 0) && (val <= LPFC_USER_LINK_SPEED_MAX) &&
 	    (LPFC_USER_LINK_SPEED_BITMAP & (1 << val))) {
 		prev_val = phba->cfg_link_speed;
@@ -3266,6 +3282,13 @@ lpfc_param_show(link_speed)
 static int
 lpfc_link_speed_init(struct lpfc_hba *phba, int val)
 {
+	if (val == LPFC_USER_LINK_SPEED_16G && phba->cfg_topology == 4) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"3111 lpfc_link_speed of %d cannot "
+			"support loop mode, setting topology to default.\n",
+			 val);
+		phba->cfg_topology = 0;
+	}
 	if ((val >= 0) && (val <= LPFC_USER_LINK_SPEED_MAX) &&
 	    (LPFC_USER_LINK_SPEED_BITMAP & (1 << val))) {
 		phba->cfg_link_speed = val;
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-12-12 20:49:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-12-12 20:50:38.000000000 -0500
@@ -453,3 +453,5 @@ int lpfc_sli_probe_sriov_nr_virtfn(struc
 uint16_t lpfc_sli_sriov_nr_virtfn_get(struct lpfc_hba *);
 int lpfc_sli4_queue_create(struct lpfc_hba *);
 void lpfc_sli4_queue_destroy(struct lpfc_hba *);
+int lpfc_sli4_read_config(struct lpfc_hba *phba);
+int lpfc_scsi_buf_update(struct lpfc_hba *phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-11-03 10:24:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-12-12 20:50:38.000000000 -0500
@@ -909,15 +909,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 */
 		if (phba->alpa_map[0] == 0) {
 			vport->cfg_discovery_threads = LPFC_MAX_DISC_THREADS;
-			if ((phba->sli_rev == LPFC_SLI_REV4) &&
-			    (!(vport->fc_flag & FC_VFI_REGISTERED) ||
-			     (vport->fc_prevDID != vport->fc_myDID))) {
-				if (vport->fc_flag & FC_VFI_REGISTERED)
-					lpfc_sli4_unreg_all_rpis(vport);
-				lpfc_issue_reg_vfi(vport);
-				lpfc_nlp_put(ndlp);
-				goto out;
-			}
+		}
+		if ((phba->sli_rev == LPFC_SLI_REV4) &&
+		    (!(vport->fc_flag & FC_VFI_REGISTERED) ||
+		     (vport->fc_prevDID != vport->fc_myDID))) {
+			if (vport->fc_flag & FC_VFI_REGISTERED)
+				lpfc_sli4_unreg_all_rpis(vport);
+			lpfc_issue_reg_vfi(vport);
+			lpfc_nlp_put(ndlp);
+			goto out;
 		}
 		goto flogifail;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-11-03 10:24:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-12-12 20:50:38.000000000 -0500
@@ -2858,7 +2858,6 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *p
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
 		/* For private loop just start discovery and we are done. */
 		if ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
-		    (phba->alpa_map[0] == 0) &&
 		    !(vport->fc_flag & FC_PUBLIC_LOOP)) {
 			/* Use loop map to make discovery list */
 			lpfc_disc_list_loopmap(vport);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-12-12 20:49:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-12-12 20:50:38.000000000 -0500
@@ -62,7 +62,6 @@ static int lpfc_post_rcv_buf(struct lpfc
 static int lpfc_sli4_queue_verify(struct lpfc_hba *);
 static int lpfc_create_bootstrap_mbox(struct lpfc_hba *);
 static int lpfc_setup_endian_order(struct lpfc_hba *);
-static int lpfc_sli4_read_config(struct lpfc_hba *);
 static void lpfc_destroy_bootstrap_mbox(struct lpfc_hba *);
 static void lpfc_free_sgl_list(struct lpfc_hba *);
 static int lpfc_init_sgl_list(struct lpfc_hba *);
@@ -2655,6 +2654,32 @@ lpfc_offline(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_scsi_buf_update - Update the scsi_buffers that are already allocated.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine goes through all the scsi buffers in the system and updates the
+ * Physical XRIs assigned to the SCSI buffer because these may change after any
+ * firmware reset
+ *
+ * Return codes
+ *   0 - successful (for now, it always returns 0)
+ **/
+int
+lpfc_scsi_buf_update(struct lpfc_hba *phba)
+{
+	struct lpfc_scsi_buf *sb, *sb_next;
+
+	spin_lock_irq(&phba->hbalock);
+	spin_lock(&phba->scsi_buf_list_lock);
+	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list, list)
+		sb->cur_iocbq.sli4_xritag =
+			phba->sli4_hba.xri_ids[sb->cur_iocbq.sli4_lxritag];
+	spin_unlock(&phba->scsi_buf_list_lock);
+	spin_unlock_irq(&phba->hbalock);
+	return 0;
+}
+
+/**
  * lpfc_scsi_free - Free all the SCSI buffers and IOCBs from driver lists
  * @phba: pointer to lpfc hba data structure.
  *
@@ -5021,15 +5046,8 @@ lpfc_sli4_init_rpi_hdrs(struct lpfc_hba 
 	struct lpfc_rpi_hdr *rpi_hdr;
 
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_rpi_hdr_list);
-	/*
-	 * If the SLI4 port supports extents, posting the rpi header isn't
-	 * required.  Set the expected maximum count and let the actual value
-	 * get set when extents are fully allocated.
-	 */
-	if (!phba->sli4_hba.rpi_hdrs_in_use) {
-		phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
+	if (!phba->sli4_hba.rpi_hdrs_in_use)
 		return rc;
-	}
 	if (phba->sli4_hba.extents_in_use)
 		return -EIO;
 
@@ -5923,7 +5941,7 @@ lpfc_destroy_bootstrap_mbox(struct lpfc_
  * 	-ENOMEM - No available memory
  *      -EIO - The mailbox failed to complete successfully.
  **/
-static int
+int
 lpfc_sli4_read_config(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *pmb;
@@ -5955,6 +5973,20 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 		rc = -EIO;
 	} else {
 		rd_config = &pmb->u.mqe.un.rd_config;
+		if (bf_get(lpfc_mbx_rd_conf_lnk_ldv, rd_config)) {
+			phba->sli4_hba.lnk_info.lnk_dv = LPFC_LNK_DAT_VAL;
+			phba->sli4_hba.lnk_info.lnk_tp =
+				bf_get(lpfc_mbx_rd_conf_lnk_type, rd_config);
+			phba->sli4_hba.lnk_info.lnk_no =
+				bf_get(lpfc_mbx_rd_conf_lnk_numb, rd_config);
+			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+					"3081 lnk_type:%d, lnk_numb:%d\n",
+					phba->sli4_hba.lnk_info.lnk_tp,
+					phba->sli4_hba.lnk_info.lnk_no);
+		} else
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"3082 Mailbox (x%x) returned ldv:x0\n",
+					bf_get(lpfc_mqe_command, &pmb->u.mqe));
 		phba->sli4_hba.extents_in_use =
 			bf_get(lpfc_mbx_rd_conf_extnts_inuse, rd_config);
 		phba->sli4_hba.max_cfg_param.max_xri =
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-11-03 10:24:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-12-12 20:50:38.000000000 -0500
@@ -291,7 +291,7 @@ struct lpfc_bmbx {
 #define LPFC_RQE_SIZE		8
 
 #define LPFC_EQE_DEF_COUNT	1024
-#define LPFC_CQE_DEF_COUNT      256
+#define LPFC_CQE_DEF_COUNT      1024
 #define LPFC_WQE_DEF_COUNT      256
 #define LPFC_MQE_DEF_COUNT      16
 #define LPFC_RQE_DEF_COUNT	512
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-12-12 20:49:51.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-12-12 20:50:38.000000000 -0500
@@ -97,7 +97,7 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 	if (((q->host_index + 1) % q->entry_count) == q->hba_index)
 		return -ENOMEM;
 	/* set consumption flag every once in a while */
-	if (!((q->host_index + 1) % LPFC_RELEASE_NOTIFICATION_INTERVAL))
+	if (!((q->host_index + 1) % q->entry_repost))
 		bf_set(wqe_wqec, &wqe->generic.wqe_com, 1);
 	if (q->phba->sli3_options & LPFC_SLI4_PHWQ_ENABLED)
 		bf_set(wqe_wqid, &wqe->generic.wqe_com, q->queue_id);
@@ -4551,9 +4551,9 @@ lpfc_sli_hba_setup_error:
  * data structure.
  **/
 static int
-lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba,
-		LPFC_MBOXQ_t *mboxq)
+lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba)
 {
+	LPFC_MBOXQ_t *mboxq;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_mqe *mqe;
 	uint32_t data_length;
@@ -4565,10 +4565,16 @@ lpfc_sli4_read_fcoe_params(struct lpfc_h
 	phba->fc_map[1] = LPFC_FCOE_FCF_MAP1;
 	phba->fc_map[2] = LPFC_FCOE_FCF_MAP2;
 
-	mqe = &mboxq->u.mqe;
-	if (lpfc_sli4_dump_cfg_rg23(phba, mboxq))
+	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
 		return -ENOMEM;
 
+	mqe = &mboxq->u.mqe;
+	if (lpfc_sli4_dump_cfg_rg23(phba, mboxq)) {
+		rc = -ENOMEM;
+		goto out_free_mboxq;
+	}
+
 	mp = (struct lpfc_dmabuf *) mboxq->context1;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 
@@ -4596,19 +4602,25 @@ lpfc_sli4_read_fcoe_params(struct lpfc_h
 	if (rc) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
-		return -EIO;
+		rc = -EIO;
+		goto out_free_mboxq;
 	}
 	data_length = mqe->un.mb_words[5];
 	if (data_length > DMP_RGN23_SIZE) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
-		return -EIO;
+		rc = -EIO;
+		goto out_free_mboxq;
 	}
 
 	lpfc_parse_fcoe_conf(phba, mp->virt, data_length);
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
-	return 0;
+	rc = 0;
+
+out_free_mboxq:
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return rc;
 }
 
 /**
@@ -4706,7 +4718,6 @@ static int
 lpfc_sli4_retrieve_pport_name(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *mboxq;
-	struct lpfc_mbx_read_config *rd_config;
 	struct lpfc_mbx_get_cntl_attributes *mbx_cntl_attr;
 	struct lpfc_controller_attribute *cntl_attr;
 	struct lpfc_mbx_get_port_name *get_port_name;
@@ -4724,33 +4735,11 @@ lpfc_sli4_retrieve_pport_name(struct lpf
 	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq)
 		return -ENOMEM;
-
 	/* obtain link type and link number via READ_CONFIG */
-	lpfc_read_config(phba, mboxq);
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	if (rc == MBX_SUCCESS) {
-		rd_config = &mboxq->u.mqe.un.rd_config;
-		if (bf_get(lpfc_mbx_rd_conf_lnk_ldv, rd_config)) {
-			phba->sli4_hba.lnk_info.lnk_dv = LPFC_LNK_DAT_VAL;
-			phba->sli4_hba.lnk_info.lnk_tp =
-				bf_get(lpfc_mbx_rd_conf_lnk_type, rd_config);
-			phba->sli4_hba.lnk_info.lnk_no =
-				bf_get(lpfc_mbx_rd_conf_lnk_numb, rd_config);
-			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-					"3081 lnk_type:%d, lnk_numb:%d\n",
-					phba->sli4_hba.lnk_info.lnk_tp,
-					phba->sli4_hba.lnk_info.lnk_no);
-			goto retrieve_ppname;
-		} else
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"3082 Mailbox (x%x) returned ldv:x0\n",
-					bf_get(lpfc_mqe_command,
-					       &mboxq->u.mqe));
-	} else
-		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-				"3083 Mailbox (x%x) failed, status:x%x\n",
-				bf_get(lpfc_mqe_command, &mboxq->u.mqe),
-				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+	phba->sli4_hba.lnk_info.lnk_dv = LPFC_LNK_DAT_INVAL;
+	lpfc_sli4_read_config(phba);
+	if (phba->sli4_hba.lnk_info.lnk_dv == LPFC_LNK_DAT_VAL)
+		goto retrieve_ppname;
 
 	/* obtain link type and link number via COMMON_GET_CNTL_ATTRIBUTES */
 	reqlen = sizeof(struct lpfc_mbx_get_cntl_attributes);
@@ -5457,6 +5446,8 @@ lpfc_sli4_alloc_resource_identifiers(str
 	uint16_t count, base;
 	unsigned long longs;
 
+	if (!phba->sli4_hba.rpi_hdrs_in_use)
+		phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
 	if (phba->sli4_hba.extents_in_use) {
 		/*
 		 * The port supports resource extents. The XRI, VPI, VFI, RPI
@@ -5538,9 +5529,10 @@ lpfc_sli4_alloc_resource_identifiers(str
 		 * need any action - just exit.
 		 */
 		if (bf_get(lpfc_idx_rsrc_rdy, &phba->sli4_hba.sli4_flags) ==
-		    LPFC_IDX_RSRC_RDY)
-			return 0;
-
+		    LPFC_IDX_RSRC_RDY) {
+			lpfc_sli4_dealloc_resource_identifiers(phba);
+			lpfc_sli4_remove_rpis(phba);
+		}
 		/* RPIs. */
 		count = phba->sli4_hba.max_cfg_param.max_rpi;
 		base = phba->sli4_hba.max_cfg_param.rpi_base;
@@ -5880,14 +5872,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	if (!mboxq)
 		return -ENOMEM;
 
-	/*
-	 * Continue initialization with default values even if driver failed
-	 * to read FCoE param config regions
-	 */
-	if (lpfc_sli4_read_fcoe_params(phba, mboxq))
-		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_INIT,
-			"2570 Failed to read FCoE parameters\n");
-
 	/* Issue READ_REV to collect vpd and FW information. */
 	vpd_size = SLI4_PAGE_SIZE;
 	vpd = kzalloc(vpd_size, GFP_KERNEL);
@@ -5925,6 +5909,16 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	}
 
 	/*
+	 * Continue initialization with default values even if driver failed
+	 * to read FCoE param config regions, only read parameters if the
+	 * board is FCoE
+	 */
+	if (phba->hba_flag & HBA_FCOE_MODE &&
+	    lpfc_sli4_read_fcoe_params(phba))
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_INIT,
+			"2570 Failed to read FCoE parameters\n");
+
+	/*
 	 * Retrieve sli4 device physical port name, failure of doing it
 	 * is considered as non-fatal.
 	 */
@@ -6044,6 +6038,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 				"rc = x%x\n", rc);
 		goto out_free_mbox;
 	}
+	/* update physical xri mappings in the scsi buffers */
+	lpfc_scsi_buf_update(phba);
 
 	/* Read the port's service parameters. */
 	rc = lpfc_read_sparam(phba, mboxq, vport->vpi);
@@ -7632,6 +7628,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	int numBdes, i;
 	struct ulp_bde64 bde;
 	struct lpfc_nodelist *ndlp;
+	uint32_t *pcmd;
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
@@ -7685,6 +7682,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 				iocbq->iocb.ulpCommand);
 			return IOCB_ERROR;
 		}
+
 		wqe->els_req.payload_len = xmit_len;
 		/* Els_reguest64 has a TMO */
 		bf_set(wqe_tmo, &wqe->els_req.wqe_com,
@@ -7699,9 +7697,25 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_ct, &wqe->els_req.wqe_com, ct);
 		bf_set(wqe_pu, &wqe->els_req.wqe_com, 0);
 		/* CCP CCPE PV PRI in word10 were set in the memcpy */
-		if (command_type == ELS_COMMAND_FIP) {
+		if (command_type == ELS_COMMAND_FIP)
 			els_id = ((iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK)
 					>> LPFC_FIP_ELS_ID_SHIFT);
+		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
+					iocbq->context2)->virt);
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
+			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
+				*pcmd == ELS_CMD_PLOGI)) {
+				bf_set(els_req64_sp, &wqe->els_req, 1);
+				bf_set(els_req64_sid, &wqe->els_req,
+					iocbq->vport->fc_myDID);
+				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
+				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+					phba->vpi_ids[phba->pport->vpi]);
+			} else if (iocbq->context1) {
+				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
+				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+					phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+			}
 		}
 		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com,
 		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
@@ -7862,6 +7876,16 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_ebde_cnt, &wqe->xmit_els_rsp.wqe_com, 0);
 		bf_set(wqe_rsp_temp_rpi, &wqe->xmit_els_rsp,
 		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
+					iocbq->context2)->virt);
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
+				bf_set(els_req64_sp, &wqe->els_req, 1);
+				bf_set(els_req64_sid, &wqe->els_req,
+					iocbq->vport->fc_myDID);
+				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
+				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+					phba->vpi_ids[phba->pport->vpi]);
+		}
 		command_type = OTHER_COMMAND;
 		break;
 	case CMD_CLOSE_XRI_CN:
@@ -8839,12 +8863,14 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 {
 	IOCB_t *irsp = &rspiocb->iocb;
 	uint16_t abort_iotag, abort_context;
-	struct lpfc_iocbq *abort_iocb;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-
-	abort_iocb = NULL;
+	struct lpfc_iocbq *abort_iocb = NULL;
 
 	if (irsp->ulpStatus) {
+
+		/*
+		 * Assume that the port already completed and returned, or
+		 * will return the iocb. Just Log the message.
+		 */
 		abort_context = cmdiocb->iocb.un.acxri.abortContextTag;
 		abort_iotag = cmdiocb->iocb.un.acxri.abortIoTag;
 
@@ -8862,68 +8888,15 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 			 */
 			abort_iocb = phba->sli.iocbq_lookup[abort_context];
 
-		/*
-		 *  If the iocb is not found in Firmware queue the iocb
-		 *  might have completed already. Do not free it again.
-		 */
-		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-			if (irsp->un.ulpWord[4] != IOERR_NO_XRI) {
-				spin_unlock_irq(&phba->hbalock);
-				lpfc_sli_release_iocbq(phba, cmdiocb);
-				return;
-			}
-			/* For SLI4 the ulpContext field for abort IOCB
-			 * holds the iotag of the IOCB being aborted so
-			 * the local abort_context needs to be reset to
-			 * match the aborted IOCBs ulpContext.
-			 */
-			if (abort_iocb && phba->sli_rev == LPFC_SLI_REV4)
-				abort_context = abort_iocb->iocb.ulpContext;
-		}
-
 		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS | LOG_SLI,
 				"0327 Cannot abort els iocb %p "
 				"with tag %x context %x, abort status %x, "
 				"abort code %x\n",
 				abort_iocb, abort_iotag, abort_context,
 				irsp->ulpStatus, irsp->un.ulpWord[4]);
-		/*
-		 * make sure we have the right iocbq before taking it
-		 * off the txcmplq and try to call completion routine.
-		 */
-		if (!abort_iocb ||
-		    abort_iocb->iocb.ulpContext != abort_context ||
-		    (abort_iocb->iocb_flag & LPFC_DRIVER_ABORTED) == 0)
-			spin_unlock_irq(&phba->hbalock);
-		else if (phba->sli_rev < LPFC_SLI_REV4) {
-			/*
-			 * leave the SLI4 aborted command on the txcmplq
-			 * list and the command complete WCQE's XB bit
-			 * will tell whether the SGL (XRI) can be released
-			 * immediately or to the aborted SGL list for the
-			 * following abort XRI from the HBA.
-			 */
-			list_del_init(&abort_iocb->list);
-			if (abort_iocb->iocb_flag & LPFC_IO_ON_Q) {
-				abort_iocb->iocb_flag &= ~LPFC_IO_ON_Q;
-				pring->txcmplq_cnt--;
-			}
-
-			/* Firmware could still be in progress of DMAing
-			 * payload, so don't free data buffer till after
-			 * a hbeat.
-			 */
-			abort_iocb->iocb_flag |= LPFC_DELAY_MEM_FREE;
-			abort_iocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
-			spin_unlock_irq(&phba->hbalock);
 
-			abort_iocb->iocb.ulpStatus = IOSTAT_LOCAL_REJECT;
-			abort_iocb->iocb.un.ulpWord[4] = IOERR_ABORT_REQUESTED;
-			(abort_iocb->iocb_cmpl)(phba, abort_iocb, abort_iocb);
-		} else
-			spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->hbalock);
 	}
-
 	lpfc_sli_release_iocbq(phba, cmdiocb);
 	return;
 }
@@ -12167,6 +12140,7 @@ lpfc_wq_create(struct lpfc_hba *phba, st
 	wq->subtype = subtype;
 	wq->host_index = 0;
 	wq->hba_index = 0;
+	wq->entry_repost = LPFC_RELEASE_NOTIFICATION_INTERVAL;
 
 	/* link the wq onto the parent cq child list */
 	list_add_tail(&wq->list, &cq->child_list);



