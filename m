From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/7] lpfc 8.3.10: Added round robin FCF failover
Date: Fri, 26 Feb 2010 14:15:57 -0500
Message-ID: <1267211777.3372.8.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4983 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965816Ab0BZTQl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:16:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



- Added round robin FCF failover on initial or FCF rediscovery FLOGI failure.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h    |    4 
 lpfc_els.c     |   91 +++++++++-
 lpfc_hbadisc.c |  488 +++++++++++++++++++++++++++++++++++++++++++++------------
 lpfc_init.c    |  123 +++++++++++---
 lpfc_logmsg.h  |    1 
 lpfc_mbox.c    |    8 
 lpfc_sli.c     |  218 +++++++++++++++++++++++--
 lpfc_sli4.h    |   33 ++-
 8 files changed, 803 insertions(+), 163 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-25 16:34:30.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-25 16:34:52.000000000 -0500
@@ -63,6 +63,7 @@ void lpfc_linkdown_port(struct lpfc_vpor
 void lpfc_port_link_failure(struct lpfc_vport *);
 void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_init_vpi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_cancel_all_vport_retry_delay_timer(struct lpfc_hba *);
 void lpfc_retry_pport_discovery(struct lpfc_hba *);
 
 void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -222,6 +223,9 @@ void lpfc_unregister_unused_fcf(struct l
 int lpfc_sli4_redisc_fcf_table(struct lpfc_hba *);
 void lpfc_fcf_redisc_wait_start_timer(struct lpfc_hba *);
 void lpfc_sli4_fcf_dead_failthrough(struct lpfc_hba *);
+uint16_t lpfc_sli4_fcf_rr_next_index_get(struct lpfc_hba *);
+int lpfc_sli4_fcf_rr_index_set(struct lpfc_hba *, uint16_t);
+void lpfc_sli4_fcf_rr_index_clear(struct lpfc_hba *, uint16_t);
 
 int lpfc_mem_alloc(struct lpfc_hba *, int align);
 void lpfc_mem_free(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-02-25 16:34:30.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-02-25 16:34:52.000000000 -0500
@@ -771,6 +771,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 	struct lpfc_nodelist *ndlp = cmdiocb->context1;
 	struct lpfc_dmabuf *pcmd = cmdiocb->context2, *prsp;
 	struct serv_parm *sp;
+	uint16_t fcf_index;
 	int rc;
 
 	/* Check to see if link went down during discovery */
@@ -788,6 +789,54 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		vport->port_state);
 
 	if (irsp->ulpStatus) {
+		/*
+		 * In case of FIP mode, perform round robin FCF failover
+		 * due to new FCF discovery
+		 */
+		if ((phba->hba_flag & HBA_FIP_SUPPORT) &&
+		    (phba->fcf.fcf_flag & FCF_DISCOVERY)) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
+					"2611 FLOGI failed on registered "
+					"FCF record fcf_index:%d, trying "
+					"to perform round robin failover\n",
+					phba->fcf.current_rec.fcf_indx);
+			fcf_index = lpfc_sli4_fcf_rr_next_index_get(phba);
+			if (fcf_index == LPFC_FCOE_FCF_NEXT_NONE) {
+				/*
+				 * Exhausted the eligible FCF record list,
+				 * fail through to retry FLOGI on current
+				 * FCF record.
+				 */
+				lpfc_printf_log(phba, KERN_WARNING,
+						LOG_FIP | LOG_ELS,
+						"2760 FLOGI exhausted FCF "
+						"round robin failover list, "
+						"retry FLOGI on the current "
+						"registered FCF index:%d\n",
+						phba->fcf.current_rec.fcf_indx);
+				spin_lock_irq(&phba->hbalock);
+				phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
+				spin_unlock_irq(&phba->hbalock);
+			} else {
+				rc = lpfc_sli4_fcf_rr_read_fcf_rec(phba,
+								   fcf_index);
+				if (rc) {
+					lpfc_printf_log(phba, KERN_WARNING,
+							LOG_FIP | LOG_ELS,
+							"2761 FLOGI round "
+							"robin FCF failover "
+							"read FCF failed "
+							"rc:x%x, fcf_index:"
+							"%d\n", rc,
+						phba->fcf.current_rec.fcf_indx);
+					spin_lock_irq(&phba->hbalock);
+					phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
+					spin_unlock_irq(&phba->hbalock);
+				} else
+					goto out;
+			}
+		}
+
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
@@ -841,8 +890,18 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		else
 			rc = lpfc_cmpl_els_flogi_nport(vport, ndlp, sp);
 
-		if (!rc)
+		if (!rc) {
+			/* Mark the FCF discovery process done */
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_FIP | LOG_ELS,
+					 "2769 FLOGI successful on FCF record: "
+					 "current_fcf_index:x%x, terminate FCF "
+					 "round robin failover process\n",
+					 phba->fcf.current_rec.fcf_indx);
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
+			spin_unlock_irq(&phba->hbalock);
 			goto out;
+		}
 	}
 
 flogifail:
@@ -6075,21 +6134,18 @@ mbox_err_exit:
 }
 
 /**
- * lpfc_retry_pport_discovery - Start timer to retry FLOGI.
+ * lpfc_cancel_all_vport_retry_delay_timer - Cancel all vport retry delay timer
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine abort all pending discovery commands and
- * start a timer to retry FLOGI for the physical port
- * discovery.
+ * This routine cancels the retry delay timers to all the vports.
  **/
 void
-lpfc_retry_pport_discovery(struct lpfc_hba *phba)
+lpfc_cancel_all_vport_retry_delay_timer(struct lpfc_hba *phba)
 {
 	struct lpfc_vport **vports;
 	struct lpfc_nodelist *ndlp;
-	struct Scsi_Host  *shost;
-	int i;
 	uint32_t link_state;
+	int i;
 
 	/* Treat this failure as linkdown for all vports */
 	link_state = phba->link_state;
@@ -6107,13 +6163,30 @@ lpfc_retry_pport_discovery(struct lpfc_h
 		}
 		lpfc_destroy_vport_work_array(phba, vports);
 	}
+}
+
+/**
+ * lpfc_retry_pport_discovery - Start timer to retry FLOGI.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine abort all pending discovery commands and
+ * start a timer to retry FLOGI for the physical port
+ * discovery.
+ **/
+void
+lpfc_retry_pport_discovery(struct lpfc_hba *phba)
+{
+	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host  *shost;
+
+	/* Cancel the all vports retry delay retry timers */
+	lpfc_cancel_all_vport_retry_delay_timer(phba);
 
 	/* If fabric require FLOGI, then re-instantiate physical login */
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
 	if (!ndlp)
 		return;
 
-
 	shost = lpfc_shost_from_vport(phba->pport);
 	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
 	spin_lock_irq(shost->host_lock);
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-25 16:34:30.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-25 16:34:52.000000000 -0500
@@ -1481,8 +1481,6 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 int
 lpfc_check_pending_fcoe_event(struct lpfc_hba *phba, uint8_t unreg_fcf)
 {
-	LPFC_MBOXQ_t *mbox;
-	int rc;
 	/*
 	 * If the Link is up and no FCoE events while in the
 	 * FCF discovery, no need to restart FCF discovery.
@@ -1491,88 +1489,70 @@ lpfc_check_pending_fcoe_event(struct lpf
 		(phba->fcoe_eventtag == phba->fcoe_eventtag_at_fcf_scan))
 		return 0;
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2768 Pending link or FCF event during current "
+			"handling of the previous event: link_state:x%x, "
+			"evt_tag_at_scan:x%x, evt_tag_current:x%x\n",
+			phba->link_state, phba->fcoe_eventtag_at_fcf_scan,
+			phba->fcoe_eventtag);
+
 	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag &= ~FCF_AVAILABLE;
 	spin_unlock_irq(&phba->hbalock);
 
-	if (phba->link_state >= LPFC_LINK_UP)
-		lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
-	else {
+	if (phba->link_state >= LPFC_LINK_UP) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+				"2780 Restart FCF table scan due to "
+				"pending FCF event:evt_tag_at_scan:x%x, "
+				"evt_tag_current:x%x\n",
+				phba->fcoe_eventtag_at_fcf_scan,
+				phba->fcoe_eventtag);
+		lpfc_sli4_fcf_scan_read_fcf_rec(phba, LPFC_FCOE_FCF_GET_FIRST);
+	} else {
 		/*
 		 * Do not continue FCF discovery and clear FCF_DISC_INPROGRESS
 		 * flag
 		 */
 		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-		phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
-					FCF_DEAD_FOVER |
-					FCF_CVL_FOVER);
+		phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV | FCF_DISCOVERY);
 		spin_unlock_irq(&phba->hbalock);
 	}
 
+	/* Unregister the currently registered FCF if required */
 	if (unreg_fcf) {
 		spin_lock_irq(&phba->hbalock);
 		phba->fcf.fcf_flag &= ~FCF_REGISTERED;
 		spin_unlock_irq(&phba->hbalock);
-		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-		if (!mbox) {
-			lpfc_printf_log(phba, KERN_ERR,
-				LOG_DISCOVERY|LOG_MBOX,
-				"2610 UNREG_FCFI mbox allocation failed\n");
-			return 1;
-		}
-		lpfc_unreg_fcfi(mbox, phba->fcf.fcfi);
-		mbox->vport = phba->pport;
-		mbox->mbox_cmpl = lpfc_unregister_fcfi_cmpl;
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
-				"2611 UNREG_FCFI issue mbox failed\n");
-			mempool_free(mbox, phba->mbox_mem_pool);
-		}
+		lpfc_sli4_unregister_fcf(phba);
 	}
-
 	return 1;
 }
 
 /**
- * lpfc_mbx_cmpl_read_fcf_record - Completion handler for read_fcf mbox.
+ * lpfc_sli4_fcf_rec_mbox_parse - parse non-embedded fcf record mailbox command
  * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to mailbox object.
+ * @next_fcf_index: pointer to holder of next fcf index.
  *
- * This function iterate through all the fcf records available in
- * HBA and choose the optimal FCF record for discovery. After finding
- * the FCF for discovery it register the FCF record and kick start
- * discovery.
- * If FCF_IN_USE flag is set in currently used FCF, the routine try to
- * use a FCF record which match fabric name and mac address of the
- * currently used FCF record.
- * If the driver support only one FCF, it will try to use the FCF record
- * used by BOOT_BIOS.
- */
-void
-lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+ * This routine parses the non-embedded fcf mailbox command by performing the
+ * necessarily error checking, non-embedded read FCF record mailbox command
+ * SGE parsing, and endianness swapping.
+ *
+ * Returns the pointer to the new FCF record in the non-embedded mailbox
+ * command DMA memory if successfully, other NULL.
+ */
+static struct fcf_record *
+lpfc_sli4_fcf_rec_mbox_parse(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
+			     uint16_t *next_fcf_index)
 {
 	void *virt_addr;
 	dma_addr_t phys_addr;
-	uint8_t *bytep;
 	struct lpfc_mbx_sge sge;
 	struct lpfc_mbx_read_fcf_tbl *read_fcf;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct fcf_record *new_fcf_record;
-	uint32_t boot_flag, addr_mode;
-	uint32_t next_fcf_index;
-	struct lpfc_fcf_rec *fcf_rec = NULL;
-	unsigned long iflags;
-	uint16_t vlan_id;
-	int rc;
-
-	/* If there is pending FCoE event restart FCF table scan */
-	if (lpfc_check_pending_fcoe_event(phba, 0)) {
-		lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		return;
-	}
 
 	/* Get the first SGE entry from the non-embedded DMA memory. This
 	 * routine only uses a single SGE.
@@ -1583,59 +1563,183 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
 				"2524 Failed to get the non-embedded SGE "
 				"virtual address\n");
-		goto out;
+		return NULL;
 	}
 	virt_addr = mboxq->sge_array->addr[0];
 
 	shdr = (union lpfc_sli4_cfg_shdr *)virt_addr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
-	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
-				 &shdr->response);
-	/*
-	 * The FCF Record was read and there is no reason for the driver
-	 * to maintain the FCF record data or memory. Instead, just need
-	 * to book keeping the FCFIs can be used.
-	 */
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status) {
-		if (shdr_status == STATUS_FCF_TABLE_EMPTY) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		if (shdr_status == STATUS_FCF_TABLE_EMPTY)
+			lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
 					"2726 READ_FCF_RECORD Indicates empty "
 					"FCF table.\n");
-		} else {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		else
+			lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
 					"2521 READ_FCF_RECORD mailbox failed "
-					"with status x%x add_status x%x, mbx\n",
-					shdr_status, shdr_add_status);
-		}
-		goto out;
+					"with status x%x add_status x%x, "
+					"mbx\n", shdr_status, shdr_add_status);
+		return NULL;
 	}
-	/* Interpreting the returned information of FCF records */
+
+	/* Interpreting the returned information of the FCF record */
 	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
 	lpfc_sli_pcimem_bcopy(read_fcf, read_fcf,
 			      sizeof(struct lpfc_mbx_read_fcf_tbl));
-	next_fcf_index = bf_get(lpfc_mbx_read_fcf_tbl_nxt_vindx, read_fcf);
-
+	*next_fcf_index = bf_get(lpfc_mbx_read_fcf_tbl_nxt_vindx, read_fcf);
 	new_fcf_record = (struct fcf_record *)(virt_addr +
 			  sizeof(struct lpfc_mbx_read_fcf_tbl));
 	lpfc_sli_pcimem_bcopy(new_fcf_record, new_fcf_record,
 			      sizeof(struct fcf_record));
-	bytep = virt_addr + sizeof(union lpfc_sli4_cfg_shdr);
 
+	return new_fcf_record;
+}
+
+/**
+ * lpfc_sli4_log_fcf_record_info - Log the information of a fcf record
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_record: pointer to the fcf record.
+ * @vlan_id: the lowest vlan identifier associated to this fcf record.
+ * @next_fcf_index: the index to the next fcf record in hba's fcf table.
+ *
+ * This routine logs the detailed FCF record if the LOG_FIP loggin is
+ * enabled.
+ **/
+static void
+lpfc_sli4_log_fcf_record_info(struct lpfc_hba *phba,
+			      struct fcf_record *fcf_record,
+			      uint16_t vlan_id,
+			      uint16_t next_fcf_index)
+{
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2764 READ_FCF_RECORD:\n"
+			"\tFCF_Index     : x%x\n"
+			"\tFCF_Avail     : x%x\n"
+			"\tFCF_Valid     : x%x\n"
+			"\tFIP_Priority  : x%x\n"
+			"\tMAC_Provider  : x%x\n"
+			"\tLowest VLANID : x%x\n"
+			"\tFCF_MAC Addr  : x%x:%x:%x:%x:%x:%x\n"
+			"\tFabric_Name   : x%x:%x:%x:%x:%x:%x:%x:%x\n"
+			"\tSwitch_Name   : x%x:%x:%x:%x:%x:%x:%x:%x\n"
+			"\tNext_FCF_Index: x%x\n",
+			bf_get(lpfc_fcf_record_fcf_index, fcf_record),
+			bf_get(lpfc_fcf_record_fcf_avail, fcf_record),
+			bf_get(lpfc_fcf_record_fcf_valid, fcf_record),
+			fcf_record->fip_priority,
+			bf_get(lpfc_fcf_record_mac_addr_prov, fcf_record),
+			vlan_id,
+			bf_get(lpfc_fcf_record_mac_0, fcf_record),
+			bf_get(lpfc_fcf_record_mac_1, fcf_record),
+			bf_get(lpfc_fcf_record_mac_2, fcf_record),
+			bf_get(lpfc_fcf_record_mac_3, fcf_record),
+			bf_get(lpfc_fcf_record_mac_4, fcf_record),
+			bf_get(lpfc_fcf_record_mac_5, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_0, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_1, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_2, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_3, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_4, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_5, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_6, fcf_record),
+			bf_get(lpfc_fcf_record_fab_name_7, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_0, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_1, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_2, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_3, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_4, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_5, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_6, fcf_record),
+			bf_get(lpfc_fcf_record_switch_name_7, fcf_record),
+			next_fcf_index);
+}
+
+/**
+ * lpfc_mbx_cmpl_fcf_scan_read_fcf_rec - fcf scan read_fcf mbox cmpl handler.
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to mailbox object.
+ *
+ * This function iterates through all the fcf records available in
+ * HBA and chooses the optimal FCF record for discovery. After finding
+ * the FCF for discovery it registers the FCF record and kicks start
+ * discovery.
+ * If FCF_IN_USE flag is set in currently used FCF, the routine tries to
+ * use an FCF record which matches fabric name and mac address of the
+ * currently used FCF record.
+ * If the driver supports only one FCF, it will try to use the FCF record
+ * used by BOOT_BIOS.
+ */
+void
+lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct fcf_record *new_fcf_record;
+	uint32_t boot_flag, addr_mode;
+	uint16_t fcf_index, next_fcf_index;
+	struct lpfc_fcf_rec *fcf_rec = NULL;
+	uint16_t vlan_id;
+	int rc;
+
+	/* If there is pending FCoE event restart FCF table scan */
+	if (lpfc_check_pending_fcoe_event(phba, 0)) {
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return;
+	}
+
+	/* Parse the FCF record from the non-embedded mailbox command */
+	new_fcf_record = lpfc_sli4_fcf_rec_mbox_parse(phba, mboxq,
+						      &next_fcf_index);
+	if (!new_fcf_record) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+				"2765 Mailbox command READ_FCF_RECORD "
+				"failed to retrieve a FCF record.\n");
+		/* Let next new FCF event trigger fast failover */
+		spin_lock_irq(&phba->hbalock);
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
+		spin_unlock_irq(&phba->hbalock);
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return;
+	}
+
+	/* Check the FCF record against the connection list */
 	rc = lpfc_match_fcf_conn_list(phba, new_fcf_record, &boot_flag,
 				      &addr_mode, &vlan_id);
+
+	/* Log the FCF record information if turned on */
+	lpfc_sli4_log_fcf_record_info(phba, new_fcf_record, vlan_id,
+				      next_fcf_index);
+
 	/*
 	 * If the fcf record does not match with connect list entries
-	 * read the next entry.
+	 * read the next entry; otherwise, this is an eligible FCF
+	 * record for round robin FCF failover.
 	 */
-	if (!rc)
+	if (!rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+				"2781 FCF record fcf_index:x%x failed FCF "
+				"connection list check, fcf_avail:x%x, "
+				"fcf_valid:x%x\n",
+				bf_get(lpfc_fcf_record_fcf_index,
+				       new_fcf_record),
+				bf_get(lpfc_fcf_record_fcf_avail,
+				       new_fcf_record),
+				bf_get(lpfc_fcf_record_fcf_valid,
+				       new_fcf_record));
 		goto read_next_fcf;
+	} else {
+		fcf_index = bf_get(lpfc_fcf_record_fcf_index, new_fcf_record);
+		rc = lpfc_sli4_fcf_rr_index_set(phba, fcf_index);
+		if (rc)
+			goto read_next_fcf;
+	}
+
 	/*
 	 * If this is not the first FCF discovery of the HBA, use last
 	 * FCF record for the discovery. The condition that a rescan
 	 * matches the in-use FCF record: fabric name, switch name, mac
 	 * address, and vlan_id.
 	 */
-	spin_lock_irqsave(&phba->hbalock, iflags);
+	spin_lock_irq(&phba->hbalock);
 	if (phba->fcf.fcf_flag & FCF_IN_USE) {
 		if (lpfc_fab_name_match(phba->fcf.current_rec.fabric_name,
 					new_fcf_record) &&
@@ -1652,9 +1756,8 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 			else if (phba->fcf.fcf_flag & FCF_REDISC_FOV)
 				/* If in fast failover, mark it's completed */
 				phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
-							FCF_DEAD_FOVER |
-							FCF_CVL_FOVER);
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+							FCF_DISCOVERY);
+			spin_unlock_irq(&phba->hbalock);
 			goto out;
 		}
 		/*
@@ -1665,7 +1768,7 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 		 * next candidate.
 		 */
 		if (!(phba->fcf.fcf_flag & FCF_REDISC_FOV)) {
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			spin_unlock_irq(&phba->hbalock);
 			goto read_next_fcf;
 		}
 	}
@@ -1688,7 +1791,7 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 			/* Choose this FCF record */
 			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
 					addr_mode, vlan_id, BOOT_ENABLE);
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			spin_unlock_irq(&phba->hbalock);
 			goto read_next_fcf;
 		}
 		/*
@@ -1697,7 +1800,7 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 		 * the next FCF record.
 		 */
 		if (!boot_flag && (fcf_rec->flag & BOOT_ENABLE)) {
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			spin_unlock_irq(&phba->hbalock);
 			goto read_next_fcf;
 		}
 		/*
@@ -1709,7 +1812,7 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
 					addr_mode, vlan_id, 0);
 		}
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		spin_unlock_irq(&phba->hbalock);
 		goto read_next_fcf;
 	}
 	/*
@@ -1722,7 +1825,7 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 					 BOOT_ENABLE : 0));
 		phba->fcf.fcf_flag |= FCF_AVAILABLE;
 	}
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	spin_unlock_irq(&phba->hbalock);
 	goto read_next_fcf;
 
 read_next_fcf:
@@ -1738,9 +1841,22 @@ read_next_fcf:
 			 * FCF scan inprogress, and do nothing
 			 */
 			if (!(phba->fcf.failover_rec.flag & RECORD_VALID)) {
-				spin_lock_irqsave(&phba->hbalock, iflags);
+				lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+					       "2782 No suitable FCF record "
+					       "found during this round of "
+					       "post FCF rediscovery scan: "
+					       "fcf_evt_tag:x%x, fcf_index: "
+					       "x%x\n",
+					       phba->fcoe_eventtag_at_fcf_scan,
+					       bf_get(lpfc_fcf_record_fcf_index,
+						      new_fcf_record));
+				/*
+				 * Let next new FCF event trigger fast
+				 * failover
+				 */
+				spin_lock_irq(&phba->hbalock);
 				phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-				spin_unlock_irqrestore(&phba->hbalock, iflags);
+				spin_unlock_irq(&phba->hbalock);
 				return;
 			}
 			/*
@@ -1752,18 +1868,23 @@ read_next_fcf:
 			 * record.
 			 */
 
-			/* unregister the current in-use FCF record */
+			/* Unregister the current in-use FCF record */
 			lpfc_unregister_fcf(phba);
-			/* replace in-use record with the new record */
+
+			/* Replace in-use record with the new record */
 			memcpy(&phba->fcf.current_rec,
 			       &phba->fcf.failover_rec,
 			       sizeof(struct lpfc_fcf_rec));
 			/* mark the FCF fast failover completed */
-			spin_lock_irqsave(&phba->hbalock, iflags);
-			phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
-						FCF_DEAD_FOVER |
-						FCF_CVL_FOVER);
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+			spin_unlock_irq(&phba->hbalock);
+			/*
+			 * Set up the initial registered FCF index for FLOGI
+			 * round robin FCF failover.
+			 */
+			phba->fcf.fcf_rr_init_indx =
+					phba->fcf.failover_rec.fcf_indx;
 			/* Register to the new FCF record */
 			lpfc_register_fcf(phba);
 		} else {
@@ -1776,13 +1897,25 @@ read_next_fcf:
 				return;
 			/*
 			 * Otherwise, initial scan or post linkdown rescan,
-			 * register with the best fit FCF record found so
-			 * far through the scanning process.
+			 * register with the best FCF record found so far
+			 * through the FCF scanning process.
 			 */
+
+			/* mark the initial FCF discovery completed */
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_INIT_DISC;
+			spin_unlock_irq(&phba->hbalock);
+			/*
+			 * Set up the initial registered FCF index for FLOGI
+			 * round robin FCF failover
+			 */
+			phba->fcf.fcf_rr_init_indx =
+					phba->fcf.current_rec.fcf_indx;
+			/* Register to the new FCF record */
 			lpfc_register_fcf(phba);
 		}
 	} else
-		lpfc_sli4_read_fcf_record(phba, next_fcf_index);
+		lpfc_sli4_fcf_scan_read_fcf_rec(phba, next_fcf_index);
 	return;
 
 out:
@@ -1793,6 +1926,141 @@ out:
 }
 
 /**
+ * lpfc_mbx_cmpl_fcf_rr_read_fcf_rec - fcf round robin read_fcf mbox cmpl hdler
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to mailbox object.
+ *
+ * This is the callback function for FLOGI failure round robin FCF failover
+ * read FCF record mailbox command from the eligible FCF record bmask for
+ * performing the failover. If the FCF read back is not valid/available, it
+ * fails through to retrying FLOGI to the currently registered FCF again.
+ * Otherwise, if the FCF read back is valid and available, it will set the
+ * newly read FCF record to the failover FCF record, unregister currently
+ * registered FCF record, copy the failover FCF record to the current
+ * FCF record, and then register the current FCF record before proceeding
+ * to trying FLOGI on the new failover FCF.
+ */
+void
+lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct fcf_record *new_fcf_record;
+	uint32_t boot_flag, addr_mode;
+	uint16_t next_fcf_index;
+	uint16_t current_fcf_index;
+	uint16_t vlan_id;
+
+	/* If link state is not up, stop the round robin failover process */
+	if (phba->link_state < LPFC_LINK_UP) {
+		spin_lock_irq(&phba->hbalock);
+		phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
+		spin_unlock_irq(&phba->hbalock);
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return;
+	}
+
+	/* Parse the FCF record from the non-embedded mailbox command */
+	new_fcf_record = lpfc_sli4_fcf_rec_mbox_parse(phba, mboxq,
+						      &next_fcf_index);
+	if (!new_fcf_record) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+				"2766 Mailbox command READ_FCF_RECORD "
+				"failed to retrieve a FCF record.\n");
+		goto out;
+	}
+
+	/* Get the needed parameters from FCF record */
+	lpfc_match_fcf_conn_list(phba, new_fcf_record, &boot_flag,
+				 &addr_mode, &vlan_id);
+
+	/* Log the FCF record information if turned on */
+	lpfc_sli4_log_fcf_record_info(phba, new_fcf_record, vlan_id,
+				      next_fcf_index);
+
+	/* Upload new FCF record to the failover FCF record */
+	spin_lock_irq(&phba->hbalock);
+	__lpfc_update_fcf_record(phba, &phba->fcf.failover_rec,
+				 new_fcf_record, addr_mode, vlan_id,
+				 (boot_flag ? BOOT_ENABLE : 0));
+	spin_unlock_irq(&phba->hbalock);
+
+	current_fcf_index = phba->fcf.current_rec.fcf_indx;
+
+	/* Unregister the current in-use FCF record */
+	lpfc_unregister_fcf(phba);
+
+	/* Replace in-use record with the new record */
+	memcpy(&phba->fcf.current_rec, &phba->fcf.failover_rec,
+	       sizeof(struct lpfc_fcf_rec));
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2783 FLOGI round robin FCF failover from FCF "
+			"(index:x%x) to FCF (index:x%x).\n",
+			current_fcf_index,
+			bf_get(lpfc_fcf_record_fcf_index, new_fcf_record));
+
+out:
+	lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	lpfc_register_fcf(phba);
+}
+
+/**
+ * lpfc_mbx_cmpl_read_fcf_rec - read fcf completion handler.
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to mailbox object.
+ *
+ * This is the callback function of read FCF record mailbox command for
+ * updating the eligible FCF bmask for FLOGI failure round robin FCF
+ * failover when a new FCF event happened. If the FCF read back is
+ * valid/available and it passes the connection list check, it updates
+ * the bmask for the eligible FCF record for round robin failover.
+ */
+void
+lpfc_mbx_cmpl_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct fcf_record *new_fcf_record;
+	uint32_t boot_flag, addr_mode;
+	uint16_t fcf_index, next_fcf_index;
+	uint16_t vlan_id;
+	int rc;
+
+	/* If link state is not up, no need to proceed */
+	if (phba->link_state < LPFC_LINK_UP)
+		goto out;
+
+	/* If FCF discovery period is over, no need to proceed */
+	if (phba->fcf.fcf_flag & FCF_DISCOVERY)
+		goto out;
+
+	/* Parse the FCF record from the non-embedded mailbox command */
+	new_fcf_record = lpfc_sli4_fcf_rec_mbox_parse(phba, mboxq,
+						      &next_fcf_index);
+	if (!new_fcf_record) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+				"2767 Mailbox command READ_FCF_RECORD "
+				"failed to retrieve a FCF record.\n");
+		goto out;
+	}
+
+	/* Check the connection list for eligibility */
+	rc = lpfc_match_fcf_conn_list(phba, new_fcf_record, &boot_flag,
+				      &addr_mode, &vlan_id);
+
+	/* Log the FCF record information if turned on */
+	lpfc_sli4_log_fcf_record_info(phba, new_fcf_record, vlan_id,
+				      next_fcf_index);
+
+	if (!rc)
+		goto out;
+
+	/* Update the eligible FCF record index bmask */
+	fcf_index = bf_get(lpfc_fcf_record_fcf_index, new_fcf_record);
+	rc = lpfc_sli4_fcf_rr_index_set(phba, fcf_index);
+
+out:
+	lpfc_sli4_mbox_cmd_free(phba, mboxq);
+}
+
+/**
  * lpfc_init_vpi_cmpl - Completion handler for init_vpi mbox command.
  * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to mailbox data structure.
@@ -2190,10 +2458,20 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 			spin_unlock_irq(&phba->hbalock);
 			return;
 		}
+		/* This is the initial FCF discovery scan */
+		phba->fcf.fcf_flag |= FCF_INIT_DISC;
 		spin_unlock_irq(&phba->hbalock);
-		rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
-		if (rc)
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+				"2778 Start FCF table scan at linkup\n");
+
+		rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba,
+						     LPFC_FCOE_FCF_GET_FIRST);
+		if (rc) {
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_INIT_DISC;
+			spin_unlock_irq(&phba->hbalock);
 			goto out;
+		}
 	}
 
 	return;
@@ -3383,8 +3661,12 @@ lpfc_unreg_hba_rpis(struct lpfc_hba *phb
 		shost = lpfc_shost_from_vport(vports[i]);
 		spin_lock_irq(shost->host_lock);
 		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
-			if (ndlp->nlp_flag & NLP_RPI_VALID)
+			if (ndlp->nlp_flag & NLP_RPI_VALID) {
+				/* The mempool_alloc might sleep */
+				spin_unlock_irq(shost->host_lock);
 				lpfc_unreg_rpi(vports[i], ndlp);
+				spin_lock_irq(shost->host_lock);
+			}
 		}
 		spin_unlock_irq(shost->host_lock);
 	}
@@ -4770,13 +5052,21 @@ lpfc_unregister_fcf_rescan(struct lpfc_h
 	    (phba->link_state < LPFC_LINK_UP))
 		return;
 
-	rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
+	/* This is considered as the initial FCF discovery scan */
+	spin_lock_irq(&phba->hbalock);
+	phba->fcf.fcf_flag |= FCF_INIT_DISC;
+	spin_unlock_irq(&phba->hbalock);
+	rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba, LPFC_FCOE_FCF_GET_FIRST);
 
-	if (rc)
+	if (rc) {
+		spin_lock_irq(&phba->hbalock);
+		phba->fcf.fcf_flag &= ~FCF_INIT_DISC;
+		spin_unlock_irq(&phba->hbalock);
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
 				"2553 lpfc_unregister_unused_fcf failed "
 				"to read FCF record HBA state x%x\n",
 				phba->pport->port_state);
+	}
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:34:30.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:34:52.000000000 -0500
@@ -2201,8 +2201,8 @@ __lpfc_sli4_stop_fcf_redisc_wait_timer(s
 {
 	/* Clear pending FCF rediscovery wait and failover in progress flags */
 	phba->fcf.fcf_flag &= ~(FCF_REDISC_PEND |
-				FCF_DEAD_FOVER  |
-				FCF_CVL_FOVER);
+				FCF_DEAD_DISC |
+				FCF_ACVL_DISC);
 	/* Now, try to stop the timer */
 	del_timer(&phba->fcf.redisc_wait);
 }
@@ -2943,6 +2943,9 @@ lpfc_sli4_fcf_redisc_wait_tmo(unsigned l
 	/* FCF rediscovery event to worker thread */
 	phba->fcf.fcf_flag |= FCF_REDISC_EVT;
 	spin_unlock_irq(&phba->hbalock);
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2776 FCF rediscover wait timer expired, post "
+			"a worker thread event for FCF table scan\n");
 	/* wake up worker thread */
 	lpfc_worker_wake_up(phba);
 }
@@ -3300,10 +3303,11 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	switch (event_type) {
 	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
 	case LPFC_FCOE_EVENT_TYPE_FCF_PARAM_MOD:
-		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-			"2546 New FCF found index 0x%x tag 0x%x\n",
-			acqe_fcoe->index,
-			acqe_fcoe->event_tag);
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
+			"2546 New FCF found/FCF parameter modified event: "
+			"evt_tag:x%x, fcf_index:x%x\n",
+			acqe_fcoe->event_tag, acqe_fcoe->index);
+
 		spin_lock_irq(&phba->hbalock);
 		if ((phba->fcf.fcf_flag & FCF_SCAN_DONE) ||
 		    (phba->hba_flag & FCF_DISC_INPROGRESS)) {
@@ -3314,6 +3318,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			spin_unlock_irq(&phba->hbalock);
 			break;
 		}
+
 		if (phba->fcf.fcf_flag & FCF_REDISC_EVT) {
 			/*
 			 * If fast FCF failover rescan event is pending,
@@ -3324,12 +3329,33 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 		}
 		spin_unlock_irq(&phba->hbalock);
 
-		/* Read the FCF table and re-discover SAN. */
-		rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
+		if ((phba->fcf.fcf_flag & FCF_DISCOVERY) &&
+		    !(phba->fcf.fcf_flag & FCF_REDISC_FOV)) {
+			/*
+			 * During period of FCF discovery, read the FCF
+			 * table record indexed by the event to update
+			 * FCF round robin failover eligible FCF bmask.
+			 */
+			lpfc_printf_log(phba, KERN_INFO, LOG_FIP |
+					LOG_DISCOVERY,
+					"2779 Read new FCF record with "
+					"fcf_index:x%x for updating FCF "
+					"round robin failover bmask\n",
+					acqe_fcoe->index);
+			rc = lpfc_sli4_read_fcf_rec(phba, acqe_fcoe->index);
+		}
+
+		/* Otherwise, scan the entire FCF table and re-discover SAN */
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+				"2770 Start FCF table scan due to new FCF "
+				"event: evt_tag:x%x, fcf_index:x%x\n",
+				acqe_fcoe->event_tag, acqe_fcoe->index);
+		rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba,
+						     LPFC_FCOE_FCF_GET_FIRST);
 		if (rc)
-			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-					"2547 Read FCF record failed 0x%x\n",
-					rc);
+			lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
+					"2547 Issue FCF scan read FCF mailbox "
+					"command failed 0x%x\n", rc);
 		break;
 
 	case LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL:
@@ -3340,7 +3366,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 		break;
 
 	case LPFC_FCOE_EVENT_TYPE_FCF_DEAD:
-		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
 			"2549 FCF disconnected from network index 0x%x"
 			" tag 0x%x\n", acqe_fcoe->index,
 			acqe_fcoe->event_tag);
@@ -3349,21 +3375,32 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			break;
 		/* We request port to rediscover the entire FCF table for
 		 * a fast recovery from case that the current FCF record
-		 * is no longer valid if the last CVL event hasn't already
-		 * triggered process.
+		 * is no longer valid if we are not in the middle of FCF
+		 * failover process already.
 		 */
 		spin_lock_irq(&phba->hbalock);
-		if (phba->fcf.fcf_flag & FCF_CVL_FOVER) {
+		if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
 			spin_unlock_irq(&phba->hbalock);
+			/* Update FLOGI FCF failover eligible FCF bmask */
+			lpfc_sli4_fcf_rr_index_clear(phba, acqe_fcoe->index);
 			break;
 		}
 		/* Mark the fast failover process in progress */
-		phba->fcf.fcf_flag |= FCF_DEAD_FOVER;
+		phba->fcf.fcf_flag |= FCF_DEAD_DISC;
 		spin_unlock_irq(&phba->hbalock);
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+				"2771 Start FCF fast failover process due to "
+				"FCF DEAD event: evt_tag:x%x, fcf_index:x%x "
+				"\n", acqe_fcoe->event_tag, acqe_fcoe->index);
 		rc = lpfc_sli4_redisc_fcf_table(phba);
 		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
+					LOG_DISCOVERY,
+					"2772 Issue FCF rediscover mabilbox "
+					"command failed, fail through to FCF "
+					"dead event\n");
 			spin_lock_irq(&phba->hbalock);
-			phba->fcf.fcf_flag &= ~FCF_DEAD_FOVER;
+			phba->fcf.fcf_flag &= ~FCF_DEAD_DISC;
 			spin_unlock_irq(&phba->hbalock);
 			/*
 			 * Last resort will fail over by treating this
@@ -3378,7 +3415,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			lpfc_sli4_perform_all_vport_cvl(phba);
 		break;
 	case LPFC_FCOE_EVENT_TYPE_CVL:
-		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
 			"2718 Clear Virtual Link Received for VPI 0x%x"
 			" tag 0x%x\n", acqe_fcoe->index, acqe_fcoe->event_tag);
 		vport = lpfc_find_vport_by_vpid(phba,
@@ -3419,21 +3456,31 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			 * Otherwise, we request port to rediscover
 			 * the entire FCF table for a fast recovery
 			 * from possible case that the current FCF
-			 * is no longer valid if the FCF_DEAD event
-			 * hasn't already triggered process.
+			 * is no longer valid if we are not already
+			 * in the FCF failover process.
 			 */
 			spin_lock_irq(&phba->hbalock);
-			if (phba->fcf.fcf_flag & FCF_DEAD_FOVER) {
+			if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
 				spin_unlock_irq(&phba->hbalock);
 				break;
 			}
 			/* Mark the fast failover process in progress */
-			phba->fcf.fcf_flag |= FCF_CVL_FOVER;
+			phba->fcf.fcf_flag |= FCF_ACVL_DISC;
 			spin_unlock_irq(&phba->hbalock);
+			lpfc_printf_log(phba, KERN_INFO, LOG_FIP |
+					LOG_DISCOVERY,
+					"2773 Start FCF fast failover due "
+					"to CVL event: evt_tag:x%x\n",
+					acqe_fcoe->event_tag);
 			rc = lpfc_sli4_redisc_fcf_table(phba);
 			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
+						LOG_DISCOVERY,
+						"2774 Issue FCF rediscover "
+						"mabilbox command failed, "
+						"through to CVL event\n");
 				spin_lock_irq(&phba->hbalock);
-				phba->fcf.fcf_flag &= ~FCF_CVL_FOVER;
+				phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
 				spin_unlock_irq(&phba->hbalock);
 				/*
 				 * Last resort will be re-try on the
@@ -3537,11 +3584,14 @@ void lpfc_sli4_fcf_redisc_event_proc(str
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Scan FCF table from the first entry to re-discover SAN */
-	rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+			"2777 Start FCF table scan after FCF "
+			"rediscovery quiescent period over\n");
+	rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba, LPFC_FCOE_FCF_GET_FIRST);
 	if (rc)
-		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-				"2747 Post FCF rediscovery read FCF record "
-				"failed 0x%x\n", rc);
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
+				"2747 Issue FCF scan read FCF mailbox "
+				"command failed 0x%x\n", rc);
 }
 
 /**
@@ -3833,6 +3883,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	int rc, i, hbq_count, buf_size, dma_buf_size, max_buf_size;
 	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
 	struct lpfc_mqe *mqe;
+	int longs;
 
 	/* Before proceed, wait for POST done and device ready */
 	rc = lpfc_sli4_post_status_check(phba);
@@ -4009,13 +4060,24 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_active_sgl;
 	}
 
+	/* Allocate eligible FCF bmask memory for FCF round robin failover */
+	longs = (LPFC_SLI4_FCF_TBL_INDX_MAX + BITS_PER_LONG - 1)/BITS_PER_LONG;
+	phba->fcf.fcf_rr_bmask = kzalloc(longs * sizeof(unsigned long),
+					 GFP_KERNEL);
+	if (!phba->fcf.fcf_rr_bmask) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2759 Failed allocate memory for FCF round "
+				"robin failover bmask\n");
+		goto out_remove_rpi_hdrs;
+	}
+
 	phba->sli4_hba.fcp_eq_hdl = kzalloc((sizeof(struct lpfc_fcp_eq_hdl) *
 				    phba->cfg_fcp_eq_count), GFP_KERNEL);
 	if (!phba->sli4_hba.fcp_eq_hdl) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2572 Failed allocate memory for fast-path "
 				"per-EQ handle array\n");
-		goto out_remove_rpi_hdrs;
+		goto out_free_fcf_rr_bmask;
 	}
 
 	phba->sli4_hba.msix_entries = kzalloc((sizeof(struct msix_entry) *
@@ -4068,6 +4130,8 @@ lpfc_sli4_driver_resource_setup(struct l
 
 out_free_fcp_eq_hdl:
 	kfree(phba->sli4_hba.fcp_eq_hdl);
+out_free_fcf_rr_bmask:
+	kfree(phba->fcf.fcf_rr_bmask);
 out_remove_rpi_hdrs:
 	lpfc_sli4_remove_rpi_hdrs(phba);
 out_free_active_sgl:
@@ -4113,6 +4177,9 @@ lpfc_sli4_driver_resource_unset(struct l
 	lpfc_sli4_remove_rpi_hdrs(phba);
 	lpfc_sli4_remove_rpis(phba);
 
+	/* Free eligible FCF index bmask */
+	kfree(phba->fcf.fcf_rr_bmask);
+
 	/* Free the ELS sgl list */
 	lpfc_free_active_sgl(phba);
 	lpfc_free_sgl_list(phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2010-02-25 16:34:52.000000000 -0500
@@ -35,6 +35,7 @@
 #define LOG_VPORT	0x00004000	/* NPIV events */
 #define LOF_SECURITY	0x00008000	/* Security events */
 #define LOG_EVENT	0x00010000	/* CT,TEMP,DUMP, logging */
+#define LOG_FIP		0x00020000	/* FIP events */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-02-25 16:34:52.000000000 -0500
@@ -1748,7 +1748,7 @@ lpfc_sli4_mbox_opcode_get(struct lpfc_hb
 }
 
 /**
- * lpfc_sli4_mbx_read_fcf_record - Allocate and construct read fcf mbox cmd
+ * lpfc_sli4_mbx_read_fcf_rec - Allocate and construct read fcf mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index: index to fcf table.
  *
@@ -1759,9 +1759,9 @@ lpfc_sli4_mbox_opcode_get(struct lpfc_hb
  * NULL.
  **/
 int
-lpfc_sli4_mbx_read_fcf_record(struct lpfc_hba *phba,
-			      struct lpfcMboxq *mboxq,
-			      uint16_t fcf_index)
+lpfc_sli4_mbx_read_fcf_rec(struct lpfc_hba *phba,
+			   struct lpfcMboxq *mboxq,
+			   uint16_t fcf_index)
 {
 	void *virt_addr;
 	dma_addr_t phys_addr;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-25 16:34:30.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-25 16:34:52.000000000 -0500
@@ -153,17 +153,27 @@ struct lpfc_fcf {
 #define FCF_REGISTERED	0x02 /* FCF registered with FW */
 #define FCF_SCAN_DONE	0x04 /* FCF table scan done */
 #define FCF_IN_USE	0x08 /* Atleast one discovery completed */
-#define FCF_DEAD_FOVER  0x10 /* FCF DEAD triggered fast FCF failover */
-#define FCF_CVL_FOVER	0x20 /* CVL triggered fast FCF failover */
-#define FCF_REDISC_PEND	0x40 /* FCF rediscovery pending */
-#define FCF_REDISC_EVT	0x80 /* FCF rediscovery event to worker thread */
-#define FCF_REDISC_FOV	0x100 /* Post FCF rediscovery fast failover */
+#define FCF_INIT_DISC	0x10 /* Initial FCF discovery */
+#define FCF_DEAD_DISC	0x20 /* FCF DEAD fast FCF failover discovery */
+#define FCF_ACVL_DISC	0x40 /* All CVL fast FCF failover discovery */
+#define FCF_DISCOVERY	(FCF_INIT_DISC | FCF_DEAD_DISC | FCF_ACVL_DISC)
+#define FCF_REDISC_PEND	0x80 /* FCF rediscovery pending */
+#define FCF_REDISC_EVT	0x100 /* FCF rediscovery event to worker thread */
+#define FCF_REDISC_FOV	0x200 /* Post FCF rediscovery fast failover */
 	uint32_t addr_mode;
+	uint16_t fcf_rr_init_indx;
 	struct lpfc_fcf_rec current_rec;
 	struct lpfc_fcf_rec failover_rec;
 	struct timer_list redisc_wait;
+	unsigned long *fcf_rr_bmask; /* Eligible FCF indexes for RR failover */
 };
 
+/*
+ * Maximum FCF table index, it is for driver internal book keeping, it
+ * just needs to be no less than the supported HBA's FCF table size.
+ */
+#define LPFC_SLI4_FCF_TBL_INDX_MAX	32
+
 #define LPFC_REGION23_SIGNATURE "RG23"
 #define LPFC_REGION23_VERSION	1
 #define LPFC_REGION23_LAST_REC  0xff
@@ -472,8 +482,8 @@ void lpfc_sli4_mbox_cmd_free(struct lpfc
 void lpfc_sli4_mbx_sge_set(struct lpfcMboxq *, uint32_t, dma_addr_t, uint32_t);
 void lpfc_sli4_mbx_sge_get(struct lpfcMboxq *, uint32_t,
 			   struct lpfc_mbx_sge *);
-int lpfc_sli4_mbx_read_fcf_record(struct lpfc_hba *, struct lpfcMboxq *,
-				  uint16_t);
+int lpfc_sli4_mbx_read_fcf_rec(struct lpfc_hba *, struct lpfcMboxq *,
+			       uint16_t);
 
 void lpfc_sli4_hba_reset(struct lpfc_hba *);
 struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
@@ -532,8 +542,13 @@ int lpfc_sli4_init_vpi(struct lpfc_hba *
 uint32_t lpfc_sli4_cq_release(struct lpfc_queue *, bool);
 uint32_t lpfc_sli4_eq_release(struct lpfc_queue *, bool);
 void lpfc_sli4_fcfi_unreg(struct lpfc_hba *, uint16_t);
-int lpfc_sli4_read_fcf_record(struct lpfc_hba *, uint16_t);
-void lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_sli4_fcf_scan_read_fcf_rec(struct lpfc_hba *, uint16_t);
+int lpfc_sli4_fcf_rr_read_fcf_rec(struct lpfc_hba *, uint16_t);
+int lpfc_sli4_read_fcf_rec(struct lpfc_hba *, uint16_t);
+void lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_mbx_cmpl_read_fcf_rec(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_sli4_unregister_fcf(struct lpfc_hba *);
 int lpfc_sli4_post_status_check(struct lpfc_hba *);
 uint8_t lpfc_sli4_mbox_opcode_get(struct lpfc_hba *, struct lpfcMboxq *);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:34:30.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:34:52.000000000 -0500
@@ -11996,15 +11996,19 @@ lpfc_sli4_build_dflt_fcf_record(struct l
 }
 
 /**
- * lpfc_sli4_read_fcf_record - Read the driver's default FCF Record.
+ * lpfc_sli4_fcf_scan_read_fcf_rec - Read hba fcf record for fcf scan.
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index: FCF table entry offset.
  *
- * This routine is invoked to read up to @fcf_num of FCF record from the
- * device starting with the given @fcf_index.
+ * This routine is invoked to scan the entire FCF table by reading FCF
+ * record and processing it one at a time starting from the @fcf_index
+ * for initial FCF discovery or fast FCF failover rediscovery.
+ *
+ * Return 0 if the mailbox command is submitted sucessfully, none 0
+ * otherwise.
  **/
 int
-lpfc_sli4_read_fcf_record(struct lpfc_hba *phba, uint16_t fcf_index)
+lpfc_sli4_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, uint16_t fcf_index)
 {
 	int rc = 0, error;
 	LPFC_MBOXQ_t *mboxq;
@@ -12016,17 +12020,17 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 				"2000 Failed to allocate mbox for "
 				"READ_FCF cmd\n");
 		error = -ENOMEM;
-		goto fail_fcfscan;
+		goto fail_fcf_scan;
 	}
 	/* Construct the read FCF record mailbox command */
-	rc = lpfc_sli4_mbx_read_fcf_record(phba, mboxq, fcf_index);
+	rc = lpfc_sli4_mbx_read_fcf_rec(phba, mboxq, fcf_index);
 	if (rc) {
 		error = -EINVAL;
-		goto fail_fcfscan;
+		goto fail_fcf_scan;
 	}
 	/* Issue the mailbox command asynchronously */
 	mboxq->vport = phba->pport;
-	mboxq->mbox_cmpl = lpfc_mbx_cmpl_read_fcf_record;
+	mboxq->mbox_cmpl = lpfc_mbx_cmpl_fcf_scan_read_fcf_rec;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED)
 		error = -EIO;
@@ -12034,9 +12038,13 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag |= FCF_DISC_INPROGRESS;
 		spin_unlock_irq(&phba->hbalock);
+		/* Reset FCF round robin index bmask for new scan */
+		if (fcf_index == LPFC_FCOE_FCF_GET_FIRST)
+			memset(phba->fcf.fcf_rr_bmask, 0,
+			       sizeof(*phba->fcf.fcf_rr_bmask));
 		error = 0;
 	}
-fail_fcfscan:
+fail_fcf_scan:
 	if (error) {
 		if (mboxq)
 			lpfc_sli4_mbox_cmd_free(phba, mboxq);
@@ -12049,6 +12057,181 @@ fail_fcfscan:
 }
 
 /**
+ * lpfc_sli4_fcf_rr_read_fcf_rec - Read hba fcf record for round robin fcf.
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_index: FCF table entry offset.
+ *
+ * This routine is invoked to read an FCF record indicated by @fcf_index
+ * and to use it for FLOGI round robin FCF failover.
+ *
+ * Return 0 if the mailbox command is submitted sucessfully, none 0
+ * otherwise.
+ **/
+int
+lpfc_sli4_fcf_rr_read_fcf_rec(struct lpfc_hba *phba, uint16_t fcf_index)
+{
+	int rc = 0, error;
+	LPFC_MBOXQ_t *mboxq;
+
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_INIT,
+				"2763 Failed to allocate mbox for "
+				"READ_FCF cmd\n");
+		error = -ENOMEM;
+		goto fail_fcf_read;
+	}
+	/* Construct the read FCF record mailbox command */
+	rc = lpfc_sli4_mbx_read_fcf_rec(phba, mboxq, fcf_index);
+	if (rc) {
+		error = -EINVAL;
+		goto fail_fcf_read;
+	}
+	/* Issue the mailbox command asynchronously */
+	mboxq->vport = phba->pport;
+	mboxq->mbox_cmpl = lpfc_mbx_cmpl_fcf_rr_read_fcf_rec;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED)
+		error = -EIO;
+	else
+		error = 0;
+
+fail_fcf_read:
+	if (error && mboxq)
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	return error;
+}
+
+/**
+ * lpfc_sli4_read_fcf_rec - Read hba fcf record for update eligible fcf bmask.
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_index: FCF table entry offset.
+ *
+ * This routine is invoked to read an FCF record indicated by @fcf_index to
+ * determine whether it's eligible for FLOGI round robin failover list.
+ *
+ * Return 0 if the mailbox command is submitted sucessfully, none 0
+ * otherwise.
+ **/
+int
+lpfc_sli4_read_fcf_rec(struct lpfc_hba *phba, uint16_t fcf_index)
+{
+	int rc = 0, error;
+	LPFC_MBOXQ_t *mboxq;
+
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_INIT,
+				"2758 Failed to allocate mbox for "
+				"READ_FCF cmd\n");
+				error = -ENOMEM;
+				goto fail_fcf_read;
+	}
+	/* Construct the read FCF record mailbox command */
+	rc = lpfc_sli4_mbx_read_fcf_rec(phba, mboxq, fcf_index);
+	if (rc) {
+		error = -EINVAL;
+		goto fail_fcf_read;
+	}
+	/* Issue the mailbox command asynchronously */
+	mboxq->vport = phba->pport;
+	mboxq->mbox_cmpl = lpfc_mbx_cmpl_read_fcf_rec;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED)
+		error = -EIO;
+	else
+		error = 0;
+
+fail_fcf_read:
+	if (error && mboxq)
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	return error;
+}
+
+/**
+ * lpfc_sli4_fcf_rr_next_index_get - Get next eligible fcf record index
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is to get the next eligible FCF record index in a round
+ * robin fashion. If the next eligible FCF record index equals to the
+ * initial round robin FCF record index, LPFC_FCOE_FCF_NEXT_NONE (0xFFFF)
+ * shall be returned, otherwise, the next eligible FCF record's index
+ * shall be returned.
+ **/
+uint16_t
+lpfc_sli4_fcf_rr_next_index_get(struct lpfc_hba *phba)
+{
+	uint16_t next_fcf_index;
+
+	/* Search from the currently registered FCF index */
+	next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
+				       LPFC_SLI4_FCF_TBL_INDX_MAX,
+				       phba->fcf.current_rec.fcf_indx);
+	/* Wrap around condition on phba->fcf.fcf_rr_bmask */
+	if (next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX)
+		next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
+					       LPFC_SLI4_FCF_TBL_INDX_MAX, 0);
+	/* Round robin failover stop condition */
+	if (next_fcf_index == phba->fcf.fcf_rr_init_indx)
+		return LPFC_FCOE_FCF_NEXT_NONE;
+
+	return next_fcf_index;
+}
+
+/**
+ * lpfc_sli4_fcf_rr_index_set - Set bmask with eligible fcf record index
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine sets the FCF record index in to the eligible bmask for
+ * round robin failover search. It checks to make sure that the index
+ * does not go beyond the range of the driver allocated bmask dimension
+ * before setting the bit.
+ *
+ * Returns 0 if the index bit successfully set, otherwise, it returns
+ * -EINVAL.
+ **/
+int
+lpfc_sli4_fcf_rr_index_set(struct lpfc_hba *phba, uint16_t fcf_index)
+{
+	if (fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
+				"2610 HBA FCF index reached driver's "
+				"book keeping dimension: fcf_index:%d, "
+				"driver_bmask_max:%d\n",
+				fcf_index, LPFC_SLI4_FCF_TBL_INDX_MAX);
+		return -EINVAL;
+	}
+	/* Set the eligible FCF record index bmask */
+	set_bit(fcf_index, phba->fcf.fcf_rr_bmask);
+
+	return 0;
+}
+
+/**
+ * lpfc_sli4_fcf_rr_index_set - Clear bmask from eligible fcf record index
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine clears the FCF record index from the eligible bmask for
+ * round robin failover search. It checks to make sure that the index
+ * does not go beyond the range of the driver allocated bmask dimension
+ * before clearing the bit.
+ **/
+void
+lpfc_sli4_fcf_rr_index_clear(struct lpfc_hba *phba, uint16_t fcf_index)
+{
+	if (fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
+				"2762 HBA FCF index goes beyond driver's "
+				"book keeping dimension: fcf_index:%d, "
+				"driver_bmask_max:%d\n",
+				fcf_index, LPFC_SLI4_FCF_TBL_INDX_MAX);
+		return;
+	}
+	/* Clear the eligible FCF record index bmask */
+	clear_bit(fcf_index, phba->fcf.fcf_rr_bmask);
+}
+
+/**
  * lpfc_mbx_cmpl_redisc_fcf_table - completion routine for rediscover FCF table
  * @phba: pointer to lpfc hba data structure.
  *
@@ -12069,13 +12252,13 @@ lpfc_mbx_cmpl_redisc_fcf_table(struct lp
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
 			     &redisc_fcf->header.cfg_shdr.response);
 	if (shdr_status || shdr_add_status) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
 				"2746 Requesting for FCF rediscovery failed "
 				"status x%x add_status x%x\n",
 				shdr_status, shdr_add_status);
-		if (phba->fcf.fcf_flag & FCF_CVL_FOVER) {
+		if (phba->fcf.fcf_flag & FCF_ACVL_DISC) {
 			spin_lock_irq(&phba->hbalock);
-			phba->fcf.fcf_flag &= ~FCF_CVL_FOVER;
+			phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
 			spin_unlock_irq(&phba->hbalock);
 			/*
 			 * CVL event triggered FCF rediscover request failed,
@@ -12084,7 +12267,7 @@ lpfc_mbx_cmpl_redisc_fcf_table(struct lp
 			lpfc_retry_pport_discovery(phba);
 		} else {
 			spin_lock_irq(&phba->hbalock);
-			phba->fcf.fcf_flag &= ~FCF_DEAD_FOVER;
+			phba->fcf.fcf_flag &= ~FCF_DEAD_DISC;
 			spin_unlock_irq(&phba->hbalock);
 			/*
 			 * DEAD FCF event triggered FCF rediscover request
@@ -12093,12 +12276,16 @@ lpfc_mbx_cmpl_redisc_fcf_table(struct lp
 			 */
 			lpfc_sli4_fcf_dead_failthrough(phba);
 		}
-	} else
+	} else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+				"2775 Start FCF rediscovery quiescent period "
+				"wait timer before scaning FCF table\n");
 		/*
 		 * Start FCF rediscovery wait timer for pending FCF
 		 * before rescan FCF record table.
 		 */
 		lpfc_fcf_redisc_wait_start_timer(phba);
+	}
 
 	mempool_free(mbox, phba->mbox_mem_pool);
 }
@@ -12117,6 +12304,9 @@ lpfc_sli4_redisc_fcf_table(struct lpfc_h
 	struct lpfc_mbx_redisc_fcf_tbl *redisc_fcf;
 	int rc, length;
 
+	/* Cancel retry delay timers to all vports before FCF rediscover */
+	lpfc_cancel_all_vport_retry_delay_timer(phba);
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,


