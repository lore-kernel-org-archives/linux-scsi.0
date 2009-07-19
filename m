From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 1/8] lpfc 8.3.4: Various SLI4 fixes
Date: Sun, 19 Jul 2009 10:01:03 -0400
Message-ID: <1248012063.15009.22.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34668 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZGSOBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:05 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE15E8021568
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Various SLI4 fixes

- Fix switch name not used in the FCF record for FCoE HBAs
- Enabled HBA UE error polling error-condition action code
- Rewrite lpfc_sli4_scmd_to_wqidx_distr() to handle counter rollover cleanly
- Modify resume_rpi mailbox data structure to match current SLI4 spec
- Do not issue mailbox command in MBX_POLL mode when LPFC_HBA_ERROR is set
- Wait for HBA POST completion before checking Online and UE registers
- Fix accumulated total length not being filled in on unsolicited IOCBs
- Use PCI config space register to determine SLI rev of HBA
- Turn on starting ELS tmo function timer during device initialization

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h         |    2 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |   66 +++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_hw4.h     |   74 ++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_init.c    |   48 ++++++++++----------
 drivers/scsi/lpfc/lpfc_mbox.c    |    8 +--
 drivers/scsi/lpfc/lpfc_sli.c     |   90 +++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_sli4.h    |    1 
 7 files changed, 190 insertions(+), 99 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -616,6 +616,8 @@ struct lpfc_hba {
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
+	uint32_t fcp_qidx;		/* next work queue to post work to */
+
 	unsigned long pci_bar0_map;     /* Physical address for PCI BAR0 */
 	unsigned long pci_bar1_map;     /* Physical address for PCI BAR1 */
 	unsigned long pci_bar2_map;     /* Physical address for PCI BAR2 */
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1054,6 +1054,39 @@ lpfc_fab_name_match(uint8_t *fab_name, struct fcf_record *new_fcf_record)
 }
 
 /**
+ * lpfc_sw_name_match - Check if the fcf switch name match.
+ * @fab_name: pointer to fabric name.
+ * @new_fcf_record: pointer to fcf record.
+ *
+ * This routine compare the fcf record's switch name with provided
+ * switch name. If the switch name are identical this function
+ * returns 1 else return 0.
+ **/
+static uint32_t
+lpfc_sw_name_match(uint8_t *sw_name, struct fcf_record *new_fcf_record)
+{
+	if ((sw_name[0] ==
+		bf_get(lpfc_fcf_record_switch_name_0, new_fcf_record)) &&
+	    (sw_name[1] ==
+		bf_get(lpfc_fcf_record_switch_name_1, new_fcf_record)) &&
+	    (sw_name[2] ==
+		bf_get(lpfc_fcf_record_switch_name_2, new_fcf_record)) &&
+	    (sw_name[3] ==
+		bf_get(lpfc_fcf_record_switch_name_3, new_fcf_record)) &&
+	    (sw_name[4] ==
+		bf_get(lpfc_fcf_record_switch_name_4, new_fcf_record)) &&
+	    (sw_name[5] ==
+		bf_get(lpfc_fcf_record_switch_name_5, new_fcf_record)) &&
+	    (sw_name[6] ==
+		bf_get(lpfc_fcf_record_switch_name_6, new_fcf_record)) &&
+	    (sw_name[7] ==
+		bf_get(lpfc_fcf_record_switch_name_7, new_fcf_record)))
+		return 1;
+	else
+		return 0;
+}
+
+/**
  * lpfc_mac_addr_match - Check if the fcf mac address match.
  * @phba: pointer to lpfc hba data structure.
  * @new_fcf_record: pointer to fcf record.
@@ -1123,6 +1156,22 @@ lpfc_copy_fcf_record(struct lpfc_hba *phba, struct fcf_record *new_fcf_record)
 		bf_get(lpfc_fcf_record_mac_5, new_fcf_record);
 	phba->fcf.fcf_indx = bf_get(lpfc_fcf_record_fcf_index, new_fcf_record);
 	phba->fcf.priority = new_fcf_record->fip_priority;
+	phba->fcf.switch_name[0] =
+		bf_get(lpfc_fcf_record_switch_name_0, new_fcf_record);
+	phba->fcf.switch_name[1] =
+		bf_get(lpfc_fcf_record_switch_name_1, new_fcf_record);
+	phba->fcf.switch_name[2] =
+		bf_get(lpfc_fcf_record_switch_name_2, new_fcf_record);
+	phba->fcf.switch_name[3] =
+		bf_get(lpfc_fcf_record_switch_name_3, new_fcf_record);
+	phba->fcf.switch_name[4] =
+		bf_get(lpfc_fcf_record_switch_name_4, new_fcf_record);
+	phba->fcf.switch_name[5] =
+		bf_get(lpfc_fcf_record_switch_name_5, new_fcf_record);
+	phba->fcf.switch_name[6] =
+		bf_get(lpfc_fcf_record_switch_name_6, new_fcf_record);
+	phba->fcf.switch_name[7] =
+		bf_get(lpfc_fcf_record_switch_name_7, new_fcf_record);
 }
 
 /**
@@ -1239,9 +1288,12 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 
 		if ((conn_entry->conn_rec.flags & FCFCNCT_FBNM_VALID) &&
 			!lpfc_fab_name_match(conn_entry->conn_rec.fabric_name,
-				new_fcf_record))
+					     new_fcf_record))
+			continue;
+		if ((conn_entry->conn_rec.flags & FCFCNCT_SWNM_VALID) &&
+			!lpfc_sw_name_match(conn_entry->conn_rec.switch_name,
+					    new_fcf_record))
 			continue;
-
 		if (conn_entry->conn_rec.flags & FCFCNCT_VLAN_VALID) {
 			/*
 			 * If the vlan bit map does not have the bit set for the
@@ -1424,7 +1476,9 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (phba->fcf.fcf_flag & FCF_IN_USE) {
 		if (lpfc_fab_name_match(phba->fcf.fabric_name,
-			new_fcf_record) &&
+					new_fcf_record) &&
+		    lpfc_sw_name_match(phba->fcf.switch_name,
+					new_fcf_record) &&
 		    lpfc_mac_addr_match(phba, new_fcf_record)) {
 			phba->fcf.fcf_flag |= FCF_AVAILABLE;
 			spin_unlock_irqrestore(&phba->hbalock, flags);
@@ -1464,9 +1518,9 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		 * If there is a record with lower priority value for
 		 * the current FCF, use that record.
 		 */
-		if (lpfc_fab_name_match(phba->fcf.fabric_name, new_fcf_record)
-			&& (new_fcf_record->fip_priority <
-				phba->fcf.priority)) {
+		if (lpfc_fab_name_match(phba->fcf.fabric_name,
+					new_fcf_record) &&
+		    (new_fcf_record->fip_priority < phba->fcf.priority)) {
 			/* Use this FCF record */
 			lpfc_copy_fcf_record(phba, new_fcf_record);
 			phba->fcf.addr_mode = addr_mode;
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -52,6 +52,31 @@ struct dma_address {
 	uint32_t addr_hi;
 };
 
+#define LPFC_SLIREV_CONF_WORD	0x58
+struct lpfc_sli_intf {
+	uint32_t word0;
+#define lpfc_sli_intf_iftype_MASK 	0x00000007
+#define lpfc_sli_intf_iftype_SHIFT	0
+#define lpfc_sli_intf_iftype_WORD	word0
+#define lpfc_sli_intf_rev_MASK 		0x0000000f
+#define lpfc_sli_intf_rev_SHIFT		4
+#define lpfc_sli_intf_rev_WORD		word0
+#define LPFC_SLIREV_CONF_SLI4	4
+#define lpfc_sli_intf_family_MASK 	0x000000ff
+#define lpfc_sli_intf_family_SHIFT	8
+#define lpfc_sli_intf_family_WORD	word0
+#define lpfc_sli_intf_feat1_MASK 	0x000000ff
+#define lpfc_sli_intf_feat1_SHIFT	16
+#define lpfc_sli_intf_feat1_WORD	word0
+#define lpfc_sli_intf_feat2_MASK 	0x0000001f
+#define lpfc_sli_intf_feat2_SHIFT	24
+#define lpfc_sli_intf_feat2_WORD	word0
+#define lpfc_sli_intf_valid_MASK 	0x00000007
+#define lpfc_sli_intf_valid_SHIFT	29
+#define lpfc_sli_intf_valid_WORD	word0
+#define LPFC_SLI_INTF_VALID		6
+};
+
 #define LPFC_SLI4_BAR0		1
 #define LPFC_SLI4_BAR1		2
 #define LPFC_SLI4_BAR2		4
@@ -1181,6 +1206,32 @@ struct fcf_record {
 #define lpfc_fcf_record_fcf_state_MASK		0x0000FFFF
 #define lpfc_fcf_record_fcf_state_WORD		word8
 	uint8_t vlan_bitmap[512];
+	uint32_t word137;
+#define lpfc_fcf_record_switch_name_0_SHIFT	0
+#define lpfc_fcf_record_switch_name_0_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_0_WORD	word137
+#define lpfc_fcf_record_switch_name_1_SHIFT	8
+#define lpfc_fcf_record_switch_name_1_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_1_WORD	word137
+#define lpfc_fcf_record_switch_name_2_SHIFT	16
+#define lpfc_fcf_record_switch_name_2_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_2_WORD	word137
+#define lpfc_fcf_record_switch_name_3_SHIFT	24
+#define lpfc_fcf_record_switch_name_3_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_3_WORD	word137
+	uint32_t word138;
+#define lpfc_fcf_record_switch_name_4_SHIFT	0
+#define lpfc_fcf_record_switch_name_4_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_4_WORD	word138
+#define lpfc_fcf_record_switch_name_5_SHIFT	8
+#define lpfc_fcf_record_switch_name_5_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_5_WORD	word138
+#define lpfc_fcf_record_switch_name_6_SHIFT	16
+#define lpfc_fcf_record_switch_name_6_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_6_WORD	word138
+#define lpfc_fcf_record_switch_name_7_SHIFT	24
+#define lpfc_fcf_record_switch_name_7_MASK	0x000000FF
+#define lpfc_fcf_record_switch_name_7_WORD	word138
 };
 
 struct lpfc_mbx_read_fcf_tbl {
@@ -1385,20 +1436,17 @@ struct lpfc_mbx_unreg_vfi {
 
 struct lpfc_mbx_resume_rpi {
 	uint32_t word1;
-#define lpfc_resume_rpi_rpi_SHIFT	0
-#define lpfc_resume_rpi_rpi_MASK	0x0000FFFF
-#define lpfc_resume_rpi_rpi_WORD	word1
+#define lpfc_resume_rpi_index_SHIFT	0
+#define lpfc_resume_rpi_index_MASK	0x0000FFFF
+#define lpfc_resume_rpi_index_WORD	word1
+#define lpfc_resume_rpi_ii_SHIFT	30
+#define lpfc_resume_rpi_ii_MASK		0x00000003
+#define lpfc_resume_rpi_ii_WORD		word1
+#define RESUME_INDEX_RPI		0
+#define RESUME_INDEX_VPI		1
+#define RESUME_INDEX_VFI		2
+#define RESUME_INDEX_FCFI		3
 	uint32_t event_tag;
-	uint32_t word3_rsvd;
-	uint32_t word4_rsvd;
-	uint32_t word5_rsvd;
-	uint32_t word6;
-#define lpfc_resume_rpi_vpi_SHIFT	0
-#define lpfc_resume_rpi_vpi_MASK	0x0000FFFF
-#define lpfc_resume_rpi_vpi_WORD	word6
-#define lpfc_resume_rpi_vfi_SHIFT	16
-#define lpfc_resume_rpi_vfi_MASK	0x0000FFFF
-#define lpfc_resume_rpi_vfi_WORD	word6
 };
 
 #define REG_FCF_INVALID_QID	0xFFFF
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4489,23 +4489,6 @@ lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 	if (!phba->sli4_hba.STAregaddr)
 		return -ENODEV;
 
-	/* With uncoverable error, log the error message and return error */
-	onlnreg0 = readl(phba->sli4_hba.ONLINE0regaddr);
-	onlnreg1 = readl(phba->sli4_hba.ONLINE1regaddr);
-	if ((onlnreg0 != LPFC_ONLINE_NERR) || (onlnreg1 != LPFC_ONLINE_NERR)) {
-		uerrlo_reg.word0 = readl(phba->sli4_hba.UERRLOregaddr);
-		uerrhi_reg.word0 = readl(phba->sli4_hba.UERRHIregaddr);
-		if (uerrlo_reg.word0 || uerrhi_reg.word0) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"1422 HBA Unrecoverable error: "
-					"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
-					"online0_reg=0x%x, online1_reg=0x%x\n",
-					uerrlo_reg.word0, uerrhi_reg.word0,
-					onlnreg0, onlnreg1);
-		}
-		return -ENODEV;
-	}
-
 	/* Wait up to 30 seconds for the SLI Port POST done and ready */
 	for (i = 0; i < 3000; i++) {
 		sta_reg.word0 = readl(phba->sli4_hba.STAregaddr);
@@ -4545,6 +4528,23 @@ lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 			bf_get(lpfc_scratchpad_featurelevel1, &scratchpad),
 			bf_get(lpfc_scratchpad_featurelevel2, &scratchpad));
 
+	/* With uncoverable error, log the error message and return error */
+	onlnreg0 = readl(phba->sli4_hba.ONLINE0regaddr);
+	onlnreg1 = readl(phba->sli4_hba.ONLINE1regaddr);
+	if ((onlnreg0 != LPFC_ONLINE_NERR) || (onlnreg1 != LPFC_ONLINE_NERR)) {
+		uerrlo_reg.word0 = readl(phba->sli4_hba.UERRLOregaddr);
+		uerrhi_reg.word0 = readl(phba->sli4_hba.UERRHIregaddr);
+		if (uerrlo_reg.word0 || uerrhi_reg.word0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1422 HBA Unrecoverable error: "
+					"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
+					"online0_reg=0x%x, online1_reg=0x%x\n",
+					uerrlo_reg.word0, uerrhi_reg.word0,
+					onlnreg0, onlnreg1);
+		}
+		return -ENODEV;
+	}
+
 	return port_error;
 }
 
@@ -7636,19 +7636,17 @@ static int __devinit
 lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
 	int rc;
-	uint16_t dev_id;
+	struct lpfc_sli_intf intf;
 
-	if (pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id))
+	if (pci_read_config_dword(pdev, LPFC_SLIREV_CONF_WORD, &intf.word0))
 		return -ENODEV;
 
-	switch (dev_id) {
-	case PCI_DEVICE_ID_TIGERSHARK:
+	if ((bf_get(lpfc_sli_intf_valid, &intf) == LPFC_SLI_INTF_VALID) &&
+		(bf_get(lpfc_sli_intf_rev, &intf) == LPFC_SLIREV_CONF_SLI4))
 		rc = lpfc_pci_probe_one_s4(pdev, pid);
-		break;
-	default:
+	else
 		rc = lpfc_pci_probe_one_s3(pdev, pid);
-		break;
-	}
+
 	return rc;
 }
 
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1938,9 +1938,7 @@ lpfc_resume_rpi(struct lpfcMboxq *mbox, struct lpfc_nodelist *ndlp)
 	memset(mbox, 0, sizeof(*mbox));
 	resume_rpi = &mbox->u.mqe.un.resume_rpi;
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_RESUME_RPI);
-	bf_set(lpfc_resume_rpi_rpi, resume_rpi, ndlp->nlp_rpi);
-	bf_set(lpfc_resume_rpi_vpi, resume_rpi,
-	       ndlp->vport->vpi + ndlp->vport->phba->vpi_base);
-	bf_set(lpfc_resume_rpi_vfi, resume_rpi,
-	       ndlp->vport->vfi + ndlp->vport->phba->vfi_base);
+	bf_set(lpfc_resume_rpi_index, resume_rpi, ndlp->nlp_rpi);
+	bf_set(lpfc_resume_rpi_ii, resume_rpi, RESUME_INDEX_RPI);
+	resume_rpi->event_tag = ndlp->phba->fc_eventTag;
 }
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4522,12 +4522,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	lpfc_sli4_rb_setup(phba);
 
 	/* Start the ELS watchdog timer */
-	/*
-	 * The driver for SLI4 is not yet ready to process timeouts
-	 * or interrupts.  Once it is, the comment bars can be removed.
-	 */
-	/* mod_timer(&vport->els_tmofunc,
-	 *           jiffies + HZ * (phba->fc_ratov*2)); */
+	mod_timer(&vport->els_tmofunc,
+		  jiffies + HZ * (phba->fc_ratov * 2));
 
 	/* Start heart beat timer */
 	mod_timer(&phba->hb_tmofunc,
@@ -5279,6 +5275,18 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	unsigned long iflags;
 	int rc;
 
+	rc = lpfc_mbox_dev_check(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):2544 Mailbox command x%x (x%x) "
+				"cannot issue Data: x%x x%x\n",
+				mboxq->vport ? mboxq->vport->vpi : 0,
+				mboxq->u.mb.mbxCommand,
+				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				psli->sli_flag, flag);
+		goto out_not_finished;
+	}
+
 	/* Detect polling mode and jump to a handler */
 	if (!phba->sli4_hba.intr_enable) {
 		if (flag == MBX_POLL)
@@ -5338,17 +5346,6 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 				psli->sli_flag, flag);
 		goto out_not_finished;
 	}
-	rc = lpfc_mbox_dev_check(phba);
-	if (unlikely(rc)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"(%d):2544 Mailbox command x%x (x%x) "
-				"cannot issue Data: x%x x%x\n",
-				mboxq->vport ? mboxq->vport->vpi : 0,
-				mboxq->u.mb.mbxCommand,
-				lpfc_sli4_mbox_opcode_get(phba, mboxq),
-				psli->sli_flag, flag);
-		goto out_not_finished;
-	}
 
 	/* Put the mailbox command to the driver internal FIFO */
 	psli->slistat.mbox_busy++;
@@ -5817,19 +5814,21 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
 /**
  * lpfc_sli4_scmd_to_wqidx_distr - scsi command to SLI4 WQ index distribution
  * @phba: Pointer to HBA context object.
- * @piocb: Pointer to command iocb.
  *
  * This routine performs a round robin SCSI command to SLI4 FCP WQ index
- * distribution.
+ * distribution.  This is called by __lpfc_sli_issue_iocb_s4() with the hbalock
+ * held.
  *
  * Return: index into SLI4 fast-path FCP queue index.
  **/
 static uint32_t
-lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
+lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba)
 {
-	static uint32_t fcp_qidx;
+	++phba->fcp_qidx;
+	if (phba->fcp_qidx >= phba->cfg_fcp_wq_count)
+		phba->fcp_qidx = 0;
 
-	return fcp_qidx++ % phba->cfg_fcp_wq_count;
+	return phba->fcp_qidx;
 }
 
 /**
@@ -6156,7 +6155,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 		return IOCB_ERROR;
 
 	if (piocb->iocb_flag &  LPFC_IO_FCP) {
-		fcp_wqidx = lpfc_sli4_scmd_to_wqidx_distr(phba, piocb);
+		fcp_wqidx = lpfc_sli4_scmd_to_wqidx_distr(phba);
 		if (lpfc_sli4_wq_put(phba->sli4_hba.fcp_wq[fcp_wqidx], &wqe))
 			return IOCB_ERROR;
 	} else {
@@ -7678,12 +7677,6 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 					"online0_reg=0x%x, online1_reg=0x%x\n",
 					uerr_sta_lo, uerr_sta_hi,
 					onlnreg0, onlnreg1);
-			/* TEMP: as the driver error recover logic is not
-			 * fully developed, we just log the error message
-			 * and the device error attention action is now
-			 * temporarily disabled.
-			 */
-			return 0;
 			phba->work_status[0] = uerr_sta_lo;
 			phba->work_status[1] = uerr_sta_hi;
 			/* Set the driver HA work bitmap */
@@ -9499,8 +9492,7 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint16_t imax)
 	eq->host_index = 0;
 	eq->hba_index = 0;
 
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
+	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
 }
 
@@ -9604,10 +9596,9 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	cq->queue_id = bf_get(lpfc_mbx_cq_create_q_id, &cq_create->u.response);
 	cq->host_index = 0;
 	cq->hba_index = 0;
-out:
 
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
+out:
+	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
 }
 
@@ -9712,8 +9703,7 @@ lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
 	/* link the mq onto the parent cq child list */
 	list_add_tail(&mq->list, &cq->child_list);
 out:
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
+	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
 }
 
@@ -9795,8 +9785,7 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	/* link the wq onto the parent cq child list */
 	list_add_tail(&wq->list, &cq->child_list);
 out:
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
+	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
 }
 
@@ -9970,8 +9959,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	list_add_tail(&drq->list, &cq->child_list);
 
 out:
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
+	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
 }
 
@@ -10026,8 +10014,7 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 
 	/* Remove eq from any list */
 	list_del_init(&eq->list);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, eq->phba->mbox_mem_pool);
+	mempool_free(mbox, eq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -10080,8 +10067,7 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
 	}
 	/* Remove cq from any list */
 	list_del_init(&cq->list);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, cq->phba->mbox_mem_pool);
+	mempool_free(mbox, cq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -10134,8 +10120,7 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
 	}
 	/* Remove mq from any list */
 	list_del_init(&mq->list);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, mq->phba->mbox_mem_pool);
+	mempool_free(mbox, mq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -10187,8 +10172,7 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
 	}
 	/* Remove wq from any list */
 	list_del_init(&wq->list);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, wq->phba->mbox_mem_pool);
+	mempool_free(mbox, wq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -10258,8 +10242,7 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	}
 	list_del_init(&hrq->list);
 	list_del_init(&drq->list);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, hrq->phba->mbox_mem_pool);
+	mempool_free(mbox, hrq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -10933,6 +10916,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 	first_iocbq = lpfc_sli_get_iocbq(vport->phba);
 	if (first_iocbq) {
 		/* Initialize the first IOCB. */
+		first_iocbq->iocb.unsli3.rcvsli3.acc_len = 0;
 		first_iocbq->iocb.ulpStatus = IOSTAT_SUCCESS;
 		first_iocbq->iocb.ulpCommand = CMD_IOCB_RCV_SEQ64_CX;
 		first_iocbq->iocb.ulpContext = be16_to_cpu(fc_hdr->fh_ox_id);
@@ -10945,6 +10929,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 		first_iocbq->iocb.un.cont64[0].tus.f.bdeSize =
 							LPFC_DATA_BUF_SIZE;
 		first_iocbq->iocb.un.rcvels.remoteID = sid;
+		first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
+				bf_get(lpfc_rcqe_length, &seq_dmabuf->rcqe);
 	}
 	iocbq = first_iocbq;
 	/*
@@ -10961,6 +10947,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 			iocbq->iocb.ulpBdeCount++;
 			iocbq->iocb.unsli3.rcvsli3.bde2.tus.f.bdeSize =
 							LPFC_DATA_BUF_SIZE;
+			first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
+				bf_get(lpfc_rcqe_length, &seq_dmabuf->rcqe);
 		} else {
 			iocbq = lpfc_sli_get_iocbq(vport->phba);
 			if (!iocbq) {
@@ -10978,6 +10966,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 			iocbq->iocb.ulpBdeCount = 1;
 			iocbq->iocb.un.cont64[0].tus.f.bdeSize =
 							LPFC_DATA_BUF_SIZE;
+			first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
+				bf_get(lpfc_rcqe_length, &seq_dmabuf->rcqe);
 			iocbq->iocb.un.rcvels.remoteID = sid;
 			list_add_tail(&iocbq->list, &first_iocbq->list);
 		}
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -132,6 +132,7 @@ struct lpfc_sli4_link {
 
 struct lpfc_fcf {
 	uint8_t	 fabric_name[8];
+	uint8_t	 switch_name[8];
 	uint8_t  mac_addr[6];
 	uint16_t fcf_indx;
 	uint16_t fcfi;


