From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 4/8] lpfc 8.3.4: Fix a pair of FCoE issues
Date: Sun, 19 Jul 2009 10:01:21 -0400
Message-ID: <1248012081.15009.28.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34685 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZGSOBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:23 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE1NNM021587
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Fix a pair of FCoE issues

- Fix Region 23 FCoE Parameters not being read correctly
- Fix race condition when there are FCoE events during FCF table read

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h         |    3 +
 drivers/scsi/lpfc/lpfc_crtn.h    |    1 
 drivers/scsi/lpfc/lpfc_hbadisc.c |   77 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c    |    9 +++-
 drivers/scsi/lpfc/lpfc_sli.c     |    7 +++
 5 files changed, 92 insertions(+), 5 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -526,6 +526,7 @@ struct lpfc_hba {
 #define ELS_XRI_ABORT_EVENT	0x40
 #define ASYNC_EVENT		0x80
 #define LINK_DISABLED		0x100 /* Link disabled by user */
+#define FCF_DISC_INPROGRESS	0x200 /* FCF discovery in progress */
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
@@ -767,6 +768,8 @@ struct lpfc_hba {
 /* Maximum number of events that can be outstanding at any time*/
 #define LPFC_MAX_EVT_COUNT 512
 	atomic_t fast_event_count;
+	uint32_t fcoe_eventtag;
+	uint32_t fcoe_eventtag_at_fcf_scan;
 	struct lpfc_fcf fcf;
 	uint8_t fc_map[3];
 	uint8_t valid_vlan;
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -189,6 +189,7 @@ void lpfc_unreg_vfi(struct lpfcMboxq *, uint16_t);
 void lpfc_reg_fcfi(struct lpfc_hba *, struct lpfcMboxq *);
 void lpfc_unreg_fcfi(struct lpfcMboxq *, uint16_t);
 void lpfc_resume_rpi(struct lpfcMboxq *, struct lpfc_nodelist *);
+int lpfc_check_pending_fcoe_event(struct lpfc_hba *, uint8_t);
 
 void lpfc_config_hbq(struct lpfc_hba *, uint32_t, struct lpfc_hbq_init *,
 	uint32_t , LPFC_MBOXQ_t *);
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -61,6 +61,7 @@ static uint8_t lpfcAlpaArray[] = {
 
 static void lpfc_disc_timeout_handler(struct lpfc_vport *);
 static void lpfc_disc_flush_list(struct lpfc_vport *vport);
+static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 void
 lpfc_terminate_rport_io(struct fc_rport *rport)
@@ -1009,9 +1010,15 @@ lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	spin_lock_irqsave(&phba->hbalock, flags);
 	phba->fcf.fcf_flag |= FCF_REGISTERED;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
+	/* If there is a pending FCoE event, restart FCF table scan. */
+	if (lpfc_check_pending_fcoe_event(phba, 1)) {
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		return;
+	}
 	if (vport->port_state != LPFC_FLOGI) {
 		spin_lock_irqsave(&phba->hbalock, flags);
 		phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_initial_flogi(vport);
 	}
@@ -1199,6 +1206,7 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 	/* The FCF is already registered, start discovery */
 	if (phba->fcf.fcf_flag & FCF_REGISTERED) {
 		phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		if (phba->pport->port_state != LPFC_FLOGI)
 			lpfc_initial_flogi(phba->pport);
@@ -1388,6 +1396,60 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 }
 
 /**
+ * lpfc_check_pending_fcoe_event - Check if there is pending fcoe event.
+ * @phba: pointer to lpfc hba data structure.
+ * @unreg_fcf: Unregister FCF if FCF table need to be re-scaned.
+ *
+ * This function check if there is any fcoe event pending while driver
+ * scan FCF entries. If there is any pending event, it will restart the
+ * FCF saning and return 1 else return 0.
+ */
+int
+lpfc_check_pending_fcoe_event(struct lpfc_hba *phba, uint8_t unreg_fcf)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc;
+	/*
+	 * If the Link is up and no FCoE events while in the
+	 * FCF discovery, no need to restart FCF discovery.
+	 */
+	if ((phba->link_state  >= LPFC_LINK_UP) &&
+		(phba->fcoe_eventtag == phba->fcoe_eventtag_at_fcf_scan))
+		return 0;
+
+	spin_lock_irq(&phba->hbalock);
+	phba->fcf.fcf_flag &= ~FCF_AVAILABLE;
+	spin_unlock_irq(&phba->hbalock);
+
+	if (phba->link_state >= LPFC_LINK_UP)
+		lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
+
+	if (unreg_fcf) {
+		spin_lock_irq(&phba->hbalock);
+		phba->fcf.fcf_flag &= ~FCF_REGISTERED;
+		spin_unlock_irq(&phba->hbalock);
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!mbox) {
+			lpfc_printf_log(phba, KERN_ERR,
+				LOG_DISCOVERY|LOG_MBOX,
+				"2610 UNREG_FCFI mbox allocation failed\n");
+			return 1;
+		}
+		lpfc_unreg_fcfi(mbox, phba->fcf.fcfi);
+		mbox->vport = phba->pport;
+		mbox->mbox_cmpl = lpfc_unregister_fcfi_cmpl;
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+				"2611 UNREG_FCFI issue mbox failed\n");
+			mempool_free(mbox, phba->mbox_mem_pool);
+		}
+	}
+
+	return 1;
+}
+
+/**
  * lpfc_mbx_cmpl_read_fcf_record - Completion handler for read_fcf mbox.
  * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to mailbox object.
@@ -1419,6 +1481,12 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	unsigned long flags;
 	uint16_t vlan_id;
 
+	/* If there is pending FCoE event restart FCF table scan */
+	if (lpfc_check_pending_fcoe_event(phba, 0)) {
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return;
+	}
+
 	/* Get the first SGE entry from the non-embedded DMA memory. This
 	 * routine only uses a single SGE.
 	 */
@@ -1823,6 +1891,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, READ_LA_VAR *la)
 			goto out;
 		}
 	} else {
+		vport->port_state = LPFC_VPORT_UNKNOWN;
 		/*
 		 * Add the driver's default FCF record at FCF index 0 now. This
 		 * is phase 1 implementation that support FCF index 0 and driver
@@ -1858,6 +1927,12 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, READ_LA_VAR *la)
 		 * The driver is expected to do FIP/FCF. Call the port
 		 * and get the FCF Table.
 		 */
+		spin_lock_irq(&phba->hbalock);
+		if (phba->hba_flag & FCF_DISC_INPROGRESS) {
+			spin_unlock_irq(&phba->hbalock);
+			return;
+		}
+		spin_unlock_irq(&phba->hbalock);
 		rc = lpfc_sli4_read_fcf_record(phba,
 					LPFC_FCOE_FCF_GET_FIRST);
 		if (rc)
@@ -4414,7 +4489,7 @@ lpfc_read_fcoe_param(struct lpfc_hba *phba,
 	fcoe_param_hdr = (struct lpfc_fip_param_hdr *)
 		buff;
 	fcoe_param = (struct lpfc_fcoe_params *)
-		buff + sizeof(struct lpfc_fip_param_hdr);
+		(buff + sizeof(struct lpfc_fip_param_hdr));
 
 	if ((fcoe_param_hdr->parm_version != FIPP_VERSION) ||
 		(fcoe_param_hdr->length != FCOE_PARAM_LENGTH))
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2829,6 +2829,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	att_type = lpfc_sli4_parse_latt_type(phba, acqe_link);
 	if (att_type != AT_LINK_DOWN && att_type != AT_LINK_UP)
 		return;
+	phba->fcoe_eventtag = acqe_link->event_tag;
 	pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -2916,6 +2917,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 	uint8_t event_type = bf_get(lpfc_acqe_fcoe_event_type, acqe_fcoe);
 	int rc;
 
+	phba->fcoe_eventtag = acqe_fcoe->event_tag;
 	switch (event_type) {
 	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
@@ -2923,11 +2925,12 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 			acqe_fcoe->fcf_index,
 			acqe_fcoe->event_tag);
 		/*
-		 * If the current FCF is in discovered state,
-		 * do nothing.
+		 * If the current FCF is in discovered state, or
+		 * FCF discovery is in progress do nothing.
 		 */
 		spin_lock_irq(&phba->hbalock);
-		if (phba->fcf.fcf_flag & FCF_DISCOVERED) {
+		if ((phba->fcf.fcf_flag & FCF_DISCOVERED) ||
+		   (phba->hba_flag & FCF_DISC_INPROGRESS)) {
 			spin_unlock_irq(&phba->hbalock);
 			break;
 		}
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11536,6 +11536,7 @@ lpfc_sli4_read_fcf_record(struct lpfc_hba *phba, uint16_t fcf_index)
 	uint32_t alloc_len, req_len;
 	struct lpfc_mbx_read_fcf_tbl *read_fcf;
 
+	phba->fcoe_eventtag_at_fcf_scan = phba->fcoe_eventtag;
 	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -11587,8 +11588,12 @@ lpfc_sli4_read_fcf_record(struct lpfc_hba *phba, uint16_t fcf_index)
 	if (rc == MBX_NOT_FINISHED) {
 		lpfc_sli4_mbox_cmd_free(phba, mboxq);
 		error = -EIO;
-	} else
+	} else {
+		spin_lock_irq(&phba->hbalock);
+		phba->hba_flag |= FCF_DISC_INPROGRESS;
+		spin_unlock_irq(&phba->hbalock);
 		error = 0;
+	}
 	return error;
 }
 


