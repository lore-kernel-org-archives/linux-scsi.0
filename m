From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/6] lpfc 8.3.6 : Fix critical errors
Date: Wed, 18 Nov 2009 15:40:49 -0500
Message-ID: <1258576869.29086.17.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50889 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbZKRUlF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 15:41:05 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id nAIKfCFU012676
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 12:41:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix errors relating to crashes and hangs.
 - Fix crash due to list corruption while unloading driver.
 - Fix panic during pci-hot-plug testing.
 - Fix panic when unmapping luns.
 - Fixed total_scsi_bufs counting could cause exhausted memory.
 - Fixed locking issue causing hang.
 - Fixed the call from lpfc_new_scsi_buf_s3 to use lpfc_release_scsi_buf_s3.


 Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hbadisc.c |   14 ++++++++------
 drivers/scsi/lpfc/lpfc_init.c    |    4 ++--
 drivers/scsi/lpfc/lpfc_scsi.c    |   33 ++++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4d7d884..3b94244 100755
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1018,13 +1018,12 @@ lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		mempool_free(mboxq, phba->mbox_mem_pool);
 		return;
 	}
+	spin_lock_irqsave(&phba->hbalock, flags);
 	phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
 	phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-	if (vport->port_state != LPFC_FLOGI) {
-		spin_lock_irqsave(&phba->hbalock, flags);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+	if (vport->port_state != LPFC_FLOGI)
 		lpfc_initial_flogi(vport);
-	}
 
 	mempool_free(mboxq, phba->mbox_mem_pool);
 	return;
@@ -1460,12 +1459,15 @@ lpfc_check_pending_fcoe_event(struct lpfc_hba *phba, uint8_t unreg_fcf)
 
 	if (phba->link_state >= LPFC_LINK_UP)
 		lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
-	else
+	else {
 		/*
 		 * Do not continue FCF discovery and clear FCF_DISC_INPROGRESS
 		 * flag
 		 */
+		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
+		spin_unlock_irq(&phba->hbalock);
+	}
 
 	if (unreg_fcf) {
 		spin_lock_irq(&phba->hbalock);
@@ -2264,7 +2266,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 * This shost reference might have been taken at the beginning of
 	 * lpfc_vport_delete()
 	 */
-	if (vport->load_flag & FC_UNLOADING)
+	if ((vport->load_flag & FC_UNLOADING) && (vport != phba->pport))
 		scsi_host_put(shost);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 33ed4b3..954594b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2320,6 +2320,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 
 	spin_lock_irq(&phba->hbalock);
 	/* Release all the lpfc_scsi_bufs maintained by this host. */
+	spin_lock(&phba->scsi_buf_list_lock);
 	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list, list) {
 		list_del(&sb->list);
 		pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
@@ -2327,6 +2328,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 		kfree(sb);
 		phba->total_scsi_bufs--;
 	}
+	spin_unlock(&phba->scsi_buf_list_lock);
 
 	/* Release all the lpfc_iocbq entries maintained by this host. */
 	list_for_each_entry_safe(io, io_next, &phba->lpfc_iocb_list, list) {
@@ -2334,9 +2336,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 		kfree(io);
 		phba->total_iocbq_bufs--;
 	}
-
 	spin_unlock_irq(&phba->hbalock);
-
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index bf80cde..a246410 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -59,6 +59,8 @@ static char *dif_op_str[] = {
 };
 static void
 lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
+static void
+lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
 
 static void
 lpfc_debug_save_data(struct lpfc_hba *phba, struct scsi_cmnd *cmnd)
@@ -596,7 +598,7 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 		iocb->ulpClass = CLASS3;
 		psb->status = IOSTAT_SUCCESS;
 		/* Put it back into the SCSI buffer list */
-		lpfc_release_scsi_buf_s4(phba, psb);
+		lpfc_release_scsi_buf_s3(phba, psb);
 
 	}
 
@@ -2766,7 +2768,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
-	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct lpfc_nodelist *ndlp;
 	struct lpfc_scsi_buf *lpfc_cmd;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err;
@@ -2776,6 +2778,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		cmnd->result = err;
 		goto out_fail_command;
 	}
+	ndlp = rdata->pnode;
 
 	if (!(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
 		scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
@@ -3154,9 +3157,15 @@ static int
 lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 {
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
-	struct lpfc_nodelist *pnode = rdata->pnode;
+	struct lpfc_nodelist *pnode;
 	unsigned long later;
 
+	if (!rdata) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+			"0797 Tgt Map rport failure: rdata x%p\n", rdata);
+		return FAILED;
+	}
+	pnode = rdata->pnode;
 	/*
 	 * If target is not in a MAPPED state, delay until
 	 * target is rediscovered or devloss timeout expires.
@@ -3241,12 +3250,18 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
-	struct lpfc_nodelist *pnode = rdata->pnode;
+	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
 	unsigned int lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 
+	if (!rdata) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			"0798 Device Reset rport failure: rdata x%p\n", rdata);
+		return FAILED;
+	}
+	pnode = rdata->pnode;
 	fc_block_scsi_eh(cmnd);
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
@@ -3300,12 +3315,18 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
-	struct lpfc_nodelist *pnode = rdata->pnode;
+	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
 	unsigned int lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 
+	if (!rdata) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			"0799 Target Reset rport failure: rdata x%p\n", rdata);
+		return FAILED;
+	}
+	pnode = rdata->pnode;
 	fc_block_scsi_eh(cmnd);
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
@@ -3486,6 +3507,8 @@ lpfc_slave_alloc(struct scsi_device *sdev)
 				 "Allocated %d buffers.\n",
 				 num_to_alloc, num_allocated);
 	}
+	if (num_allocated > 0)
+		phba->total_scsi_bufs += num_allocated;
 	return 0;
 }
 
-- 
1.6.0.6



