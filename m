Received: from mail-43172.protonmail.ch (mail-43172.protonmail.ch [185.70.43.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0A7369D72;
	Tue,  2 Jun 2026 11:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780399164; cv=none; b=uaR1yhDMcxNuZWP/p1/MDCIjndzpGI+ctpANm/XVg+NMmvmAk1pITKicOakLIZxgIHA4tKStVwAw4oDdJbQ2DSB5pdpx9qaM5FOU0nPMY+/JUT8thQ5ndFG7QWcbVh6ZTIOwWuiJgkLzDI9krEyZrWKG9/l5S1tnMDiD4HfQKtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780399164; c=relaxed/simple;
	bh=Ef8XFzQz97CJzVwRjg2h/0DRzg1raCATvIiuF/EGGOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqig7nlE7dNW6bp8RuqJfzgxOtb+4Mb8YTcDcHpksOGC0gvPygwxAEjhh++WmtinOGXRV3Y7PkO6JEQifevWxnzbom3fxYBaAF7+pS1VHRHD0DnrJR4FVjIMazycd9m2pffZ9p/B2StAJY51l42MHnA9zqTzStq2u/ajneesjPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net; spf=pass smtp.mailfrom=theesfeld.net; dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b=BrksqtJm; arc=none smtp.client-ip=185.70.43.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b="BrksqtJm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theesfeld.net;
	s=protonmail2; t=1780399158; x=1780658358;
	bh=ZEqxbr3w9WoGCn+f6B4K2AWxYXbflNcMAb4lrjSwQoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=BrksqtJmfbSiXR9A46uw/xhuq44ts6wDL9tC2wb0APLJkozOMLYBniylQ0wr4bMUw
	 +FtYEcznheKSW2MAdO+7WtJuxVt7MqNGiDMaNPRkSzsEvdM+H3d4QY7npr25U1duVk
	 EcP9MY55q8pEsc/VSuBQf3ohcUFbVFuKLW8/44t4mYCdf0Reen42BYe5kVwuXoA2Ue
	 uKmebArLocDntNwMlPNtE3iA/o50zHvX+wNoP8+H4bztYZZDyiI8K6FYydlZ7F6qG0
	 l3GHYDkamMH49JKCLLZdV+IjLlUIHo87QRaL3Vadm+i2pUw0La6biML3McIW3MM57q
	 jUhiRzkYHSiwA==
X-Pm-Submission-Id: 4gV7dG3PSWz2Scpl
From: William Theesfeld <william@theesfeld.net>
To: Justin Tee <justin.tee@broadcom.com>
Cc: Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: lpfc: fix spelling mistakes in comments
Date: Tue,  2 Jun 2026 07:19:12 -0400
Message-ID: <20260602111912.23864-1-william@theesfeld.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601202001.651088-1-william@theesfeld.net>
References: <20260601202001.651088-1-william@theesfeld.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Comment-only changes across the lpfc driver, found by running
scripts/checkpatch.pl with the kernel's scripts/spelling.txt list
against drivers/scsi/lpfc/.  No functional impact.

v1 covered a single site in lpfc_bsg.c.  v2 expands to all
checkpatch-detected comment misspellings across the driver, per
review feedback from Justin Tee on the v1 thread.  Identifiers that
happen to match common-typo entries (e.g. LSEXP_CANT_GIVE_DATA,
LPFC_FC_LA_TOP_UNKOWN) are intentionally left untouched, as renaming
them would change the driver's internal API.

Signed-off-by: William Theesfeld <william@theesfeld.net>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 10 +++++-----
 drivers/scsi/lpfc/lpfc_bsg.c     |  6 +++---
 drivers/scsi/lpfc/lpfc_els.c     |  2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 ++++++------
 drivers/scsi/lpfc/lpfc_hw4.h     |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 12 ++++++------
 drivers/scsi/lpfc/lpfc_scsi.c    | 12 ++++++------
 drivers/scsi/lpfc/lpfc_sli.c     | 22 +++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli4.h    |  2 +-
 9 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c91fa44b1..f4e8164b9 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -84,7 +84,7 @@ const char *const trunk_errmsg[] = {	/* map errcode */
 };
 
 /**
- * lpfc_jedec_to_ascii - Hex to ascii convertor according to JEDEC rules
+ * lpfc_jedec_to_ascii - Hex to ascii converter according to JEDEC rules
  * @incr: integer to convert.
  * @hdw: ascii string holding converted integer plus a string terminator.
  *
@@ -1748,12 +1748,12 @@ lpfc_issue_reset(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_sli4_pdev_status_reg_wait - Wait for pdev status register for readyness
+ * lpfc_sli4_pdev_status_reg_wait - Wait for pdev status register for readiness
  * @phba: lpfc_hba pointer.
  *
  * Description:
  * SLI4 interface type-2 device to wait on the sliport status register for
- * the readyness after performing a firmware reset.
+ * the readiness after performing a firmware reset.
  *
  * Returns:
  * zero for success, -EPERM when port does not have privilege to perform the
@@ -5403,7 +5403,7 @@ lpfc_vport_param_store(max_scsicmpl_time);
 static DEVICE_ATTR_RW(lpfc_max_scsicmpl_time);
 
 /*
-# lpfc_ack0: Use ACK0, instead of ACK1 for class 2 acknowledgement. Value
+# lpfc_ack0: Use ACK0, instead of ACK1 for class 2 acknowledgment. Value
 # range is [0,1]. Default value is 0.
 */
 LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 support");
@@ -5482,7 +5482,7 @@ LPFC_ATTR_R(multi_ring_support, 1, 1, 2, "Determines number of primary "
 /*
 # lpfc_multi_ring_rctl:  If lpfc_multi_ring_support is enabled, this
 # identifies what rctl value to configure the additional ring for.
-# Value range is [1,0xff]. Default value is 4 (Unsolicated Data).
+# Value range is [1,0xff]. Default value is 4 (Unsolicited Data).
 */
 LPFC_ATTR_R(multi_ring_rctl, FC_RCTL_DD_UNSOL_DATA, 1,
 	     255, "Identifies RCTL for additional ring configuration");
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7406dfa60..c95165905 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2066,12 +2066,12 @@ lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct bsg_job *job)
 	if (rc)
 		goto job_done;
 
-	/* indicate we are in loobpack diagnostic mode */
+	/* indicate we are in loopback diagnostic mode */
 	spin_lock_irq(&phba->hbalock);
 	phba->link_flag |= LS_LOOPBACK_MODE;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* reset port to start frome scratch */
+	/* reset port to start from scratch */
 	rc = lpfc_selective_reset(phba);
 	if (rc)
 		goto job_done;
@@ -5003,7 +5003,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	} else if (phba->sli_rev == LPFC_SLI_REV4) {
 		/* Let type 4 (well known data) through because the data is
 		 * returned in varwords[4-8]
-		 * otherwise check the recieve length and fetch the buffer addr
+		 * otherwise check the receive length and fetch the buffer addr
 		 */
 		if ((pmb->mbxCommand == MBX_DUMP_MEMORY) &&
 			(pmb->un.varDmp.type != DMP_WELL_KNOWN)) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4e3fe8928..52fc50589 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4850,7 +4850,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	case IOSTAT_LS_RJT:
 		stat.un.ls_rjt_error_be = cpu_to_be32(ulp_word4);
-		/* Added for Vendor specifc support
+		/* Added for Vendor specific support
 		 * Just keep retrying for these Rsn / Exp codes
 		 */
 		if (test_bit(FC_PT2PT, &vport->fc_flag) &&
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f3a85f6c7..c9b02d2c6 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1845,7 +1845,7 @@ lpfc_copy_fcf_record(struct lpfc_fcf_rec *fcf_rec,
  * @flag: flag bits to be set to the driver fcf record.
  *
  * This routine updates the driver FCF record from the new HBA FCF record
- * together with the address mode, vlan_id, and other informations. This
+ * together with the address mode, vlan_id, and other information. This
  * routine is called with the hbalock held.
  **/
 static void
@@ -2120,7 +2120,7 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 /**
  * lpfc_check_pending_fcoe_event - Check if there is pending fcoe event.
  * @phba: pointer to lpfc hba data structure.
- * @unreg_fcf: Unregister FCF if FCF table need to be re-scaned.
+ * @unreg_fcf: Unregister FCF if FCF table need to be re-scanned.
  *
  * This function check if there is any fcoe event pending while driver
  * scan FCF entries. If there is any pending event, it will restart the
@@ -2290,7 +2290,7 @@ lpfc_sli4_fcf_rec_mbox_parse(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
  * @vlan_id: the lowest vlan identifier associated to this fcf record.
  * @next_fcf_index: the index to the next fcf record in hba's fcf table.
  *
- * This routine logs the detailed FCF record if the LOG_FIP loggin is
+ * This routine logs the detailed FCF record if the LOG_FIP login is
  * enabled.
  **/
 static void
@@ -3475,7 +3475,7 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	phba->fc_edtov = ed_tov;
 	phba->fc_ratov = (2 * ed_tov) / 1000;
 	if (phba->fc_ratov < FF_DEF_RATOV) {
-		/* RA_TOV should be atleast 10sec for initial flogi */
+		/* RA_TOV should be at least 10sec for initial flogi */
 		phba->fc_ratov = FF_DEF_RATOV;
 	}
 
@@ -5239,7 +5239,7 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
  * Free rpi associated with LPFC_NODELIST entry.
  * This routine is called if the driver initiates a LOGO that completes
  * successfully, and we are waiting to PLOGI back to the remote NPort.
- * In addition, it is called after we receive and unsolicated ELS cmd,
+ * In addition, it is called after we receive and unsolicited ELS cmd,
  * send back a rsp, the rsp completes and we are waiting to PLOGI back
  * to the remote NPort.
  */
@@ -6551,7 +6551,7 @@ lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did)
 	return ndlp;
 }
 
-/* This routine releases all resources associated with a specifc NPort's ndlp
+/* This routine releases all resources associated with a specific NPort's ndlp
  * and mempool_free's the nodelist.
  */
 static void
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index f91bde4a6..41fa8f332 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3256,7 +3256,7 @@ struct lpfc_mbx_memory_dump_type3 {
 
 
 /*
- * Tranceiver codes Fibre Channel SFF-8472
+ * Transceiver codes Fibre Channel SFF-8472
  * Table 3.5.
  */
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 968a25235..82af59c91 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4103,7 +4103,7 @@ lpfc_sli4_els_sgl_update(struct lpfc_hba *phba)
 				 &phba->sli4_hba.lpfc_els_sgl_list);
 		spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
 	} else if (els_xri_cnt < phba->sli4_hba.els_xri_cnt) {
-		/* els xri-sgl shrinked */
+		/* els xri-sgl shrunk */
 		xri_cnt = phba->sli4_hba.els_xri_cnt - els_xri_cnt;
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"3158 ELS xri-sgl count decreased from "
@@ -8024,7 +8024,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 * Initialize driver internal slow-path work queues
 	 */
 
-	/* Driver internel slow-path CQ Event pool */
+	/* Driver internal slow-path CQ Event pool */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_cqe_event_pool);
 	/* Response IOCB work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_queue_event);
@@ -9740,7 +9740,7 @@ lpfc_create_bootstrap_mbox(struct lpfc_hba *phba)
 	 * Initialize the bootstrap mailbox pointers now so that the register
 	 * operations are simple later.  The mailbox dma address is required
 	 * to be 16-byte aligned.  Also align the virtual memory as each
-	 * maibox is copied into the bmbx mailbox region before issuing the
+	 * mailbox is copied into the bmbx mailbox region before issuing the
 	 * command to the port.
 	 */
 	phba->sli4_hba.bmbx.dmabuf = dmabuf;
@@ -10206,7 +10206,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 		goto read_cfg_out;
 	}
 
-	/* search for fc_fcoe resrouce descriptor */
+	/* search for fc_fcoe resource descriptor */
 	get_func_cfg = &pmb->u.mqe.un.get_func_cfg;
 
 	pdesc_0 = (char *)&get_func_cfg->func_cfg.desc[0];
@@ -10414,7 +10414,7 @@ lpfc_alloc_io_wq_cq(struct lpfc_hba *phba, int idx)
  *
  * Return codes
  *      0 - successful
- *      -ENOMEM - No availble memory
+ *      -ENOMEM - No available memory
  *      -EIO - The mailbox failed to complete successfully.
  **/
 int
@@ -12490,7 +12490,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 
 			/* If so, find a new_cpup that is on the SAME
 			 * phys_id as cpup. start_cpu will start where we
-			 * left off so all unassigned entries don't get assgined
+			 * left off so all unassigned entries don't get assigned
 			 * the IRQ of the first entry.
 			 */
 			new_cpu = start_cpu;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1dce33b79..f2cab134a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2497,7 +2497,7 @@ lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
 
 	/*
 	 * If we are in DIF Type 1 mode every data block has a 8 byte
-	 * DIF (trailer) attached to it. Must ajust FCP data length
+	 * DIF (trailer) attached to it. Must adjust FCP data length
 	 * to account for the protection data.
 	 */
 	fcpdl += (fcpdl / scsi_prot_interval(sc)) * 8;
@@ -2596,7 +2596,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 			lpfc_cmd->prot_seg_cnt = protsegcnt;
 
 			/*
-			 * There is a minimun of 4 BPLs used for every
+			 * There is a minimum of 4 BPLs used for every
 			 * protection data segment.
 			 */
 			if ((lpfc_cmd->prot_seg_cnt * 4) >
@@ -2678,7 +2678,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 
 /*
  * This function calcuates the T10 DIF guard tag
- * on the specified data using a CRC algorithmn
+ * on the specified data using a CRC algorithm
  * using crc_t10dif.
  */
 static uint16_t
@@ -2694,7 +2694,7 @@ lpfc_bg_crc(uint8_t *data, int count)
 
 /*
  * This function calcuates the T10 DIF guard tag
- * on the specified data using a CSUM algorithmn
+ * on the specified data using a CSUM algorithm
  * using ip_compute_csum.
  */
 static uint16_t
@@ -3378,7 +3378,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 
 			lpfc_cmd->prot_seg_cnt = protsegcnt;
 			/*
-			 * There is a minimun of 3 SGEs used for every
+			 * There is a minimum of 3 SGEs used for every
 			 * protection data segment.
 			 */
 			if (((lpfc_cmd->prot_seg_cnt * 3) >
@@ -5712,7 +5712,7 @@ lpfc_taskmgmt_name(uint8_t task_mgmt_cmd)
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_io_buf data structure.
  *
- * This routine checks the FCP RSP INFO to see if the tsk mgmt command succeded
+ * This routine checks the FCP RSP INFO to see if the tsk mgmt command succeeded
  *
  * Return code :
  *   0x2003 - Error
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d38fb374b..8823d2e69 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1155,9 +1155,9 @@ lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
  *
  * This function takes the hbalock.
  * The active bit is always set in the active rrq xri_bitmap even
- * if there is no slot avaiable for the other rrq information.
+ * if there is no slot available for the other rrq information.
  *
- * returns 0 rrq actived for this xri
+ * returns 0 rrq activated for this xri
  *         < 0 No memory or invalid ndlp.
  **/
 int
@@ -4827,11 +4827,11 @@ lpfc_sli_brdready_s4(struct lpfc_hba *phba, uint32_t mask)
 }
 
 /**
- * lpfc_sli_brdready - Wrapper func for checking the hba readyness
+ * lpfc_sli_brdready - Wrapper func for checking the hba readiness
  * @phba: Pointer to HBA context object.
  * @mask: Bit mask to be checked.
  *
- * This routine wraps the actual SLI3 or SLI4 hba readyness check routine
+ * This routine wraps the actual SLI3 or SLI4 hba readiness check routine
  * from the API jump table function pointer from the lpfc_hba struct.
  **/
 int
@@ -8512,7 +8512,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	if (unlikely(rc))
 		return -ENODEV;
 
-	/* Check the HBA Host Status Register for readyness */
+	/* Check the HBA Host Status Register for readiness */
 	rc = lpfc_sli4_post_status_check(phba);
 	if (unlikely(rc))
 		return -ENODEV;
@@ -9984,7 +9984,7 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	phba->sli.mbox_active = mboxq;
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 
-	/* wait for bootstrap mbox register for readyness */
+	/* wait for bootstrap mbox register for readiness */
 	rc = lpfc_sli4_wait_bmbx_ready(phba, mboxq);
 	if (rc)
 		goto exit;
@@ -13955,7 +13955,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
  * device-level interrupt handler. When the PCI slot is in error recovery
  * or the HBA is undergoing initialization, the interrupt handler will not
  * process the interrupt. The SCSI FCP fast-path ring event are handled in
- * the intrrupt context. This function is called without any lock held.
+ * the interrupt context. This function is called without any lock held.
  * It gets the hbalock to access and update SLI data structures.
  *
  * This function returns IRQ_HANDLED when interrupt is handled else it
@@ -15561,7 +15561,7 @@ lpfc_sli4_dly_hba_process_cq(struct work_struct *work)
  * device-level interrupt handler. When the PCI slot is in error recovery
  * or the HBA is undergoing initialization, the interrupt handler will not
  * process the interrupt. The SCSI FCP fast-path ring event are handled in
- * the intrrupt context. This function is called without any lock held.
+ * the interrupt context. This function is called without any lock held.
  * It gets the hbalock to access and update SLI data structures. Note that,
  * the FCP EQ to FCP CQ are one-to-one map such that the FCP EQ index is
  * equal to that of FCP CQ index.
@@ -16004,7 +16004,7 @@ lpfc_dpp_wc_map(struct lpfc_hba *phba, uint8_t dpp_barset)
  * On success this function will return a zero. If unable to allocate
  * enough memory this function will return -ENOMEM. If a mailbox command
  * fails this function will return -ENXIO. Note: on ENXIO, some EQs may
- * have had their delay multipler changed.
+ * have had their delay multiplier changed.
  **/
 void
 lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq,
@@ -20453,7 +20453,7 @@ lpfc_sli4_fcf_rr_next_index_get(struct lpfc_hba *phba)
 		/*
 		 * If next fcf index is not found check if there are lower
 		 * Priority level fcf's in the fcf_priority list.
-		 * Set up the rr_bmask with all of the avaiable fcf bits
+		 * Set up the rr_bmask with all of the available fcf bits
 		 * at that level and continue the selection process.
 		 */
 	} while (lpfc_check_next_fcf_pri_level(phba));
@@ -21697,7 +21697,7 @@ void lpfc_adjust_high_watermark(struct lpfc_hba *phba, u32 hwqid)
  * @phba: pointer to lpfc hba data structure.
  * @hwqid: belong to which HWQ.
  *
- * This routine is called from hearbeat timer when pvt_pool is idle.
+ * This routine is called from heartbeat timer when pvt_pool is idle.
  * All free XRIs are moved from private to public pool on hwqid with 2 steps.
  * The first step moves (all - low_watermark) amount of XRIs.
  * The second step moves the rest of XRIs.
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 2744786d9..95dc8d158 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -335,7 +335,7 @@ struct lpfc_fcf {
 #define FCF_AVAILABLE	0x01 /* FCF available for discovery */
 #define FCF_REGISTERED	0x02 /* FCF registered with FW */
 #define FCF_SCAN_DONE	0x04 /* FCF table scan done */
-#define FCF_IN_USE	0x08 /* Atleast one discovery completed */
+#define FCF_IN_USE	0x08 /* At Least one discovery completed */
 #define FCF_INIT_DISC	0x10 /* Initial FCF discovery */
 #define FCF_DEAD_DISC	0x20 /* FCF DEAD fast FCF failover discovery */
 #define FCF_ACVL_DISC	0x40 /* All CVL fast FCF failover discovery */
-- 
2.54.0

