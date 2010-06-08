From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/4] lpfc 8.3.14: SCSI and SLI API fixes
Date: Tue, 8 Jun 2010 18:31:54 -0400
Message-ID: <1276036352.3169.3.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:14406 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756747Ab0FHWdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2010 18:33:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Fixed accounting of allocated SCSI buffers when post sgl fails.
- Restrict scsi buffer allocation based on LUN count (sdev_cnt).
- Create __lpfc_sli_free_rpi that doesn't take out the hbalock.
- Modify lpfc_sli_free_rpi to call __lpfc_sli_free_rpi.
- Call __lpfc_sli_free_rpi in lpfc_cleanup_pending_mbox.
- Do not swap the strings returned in mailbox commands and do
  not swap byte aligned data in VPD.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    1 +
 lpfc_crtn.h    |    1 +
 lpfc_hbadisc.c |    1 +
 lpfc_init.c    |    1 +
 lpfc_mbox.c    |   20 ++++++++++++++++++++
 lpfc_scsi.c    |   14 ++++++++++----
 lpfc_sli.c     |   34 +++++++++++++++++++++++++++-------
 lpfc_sli4.h    |    1 +
 8 files changed, 62 insertions(+), 11 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-06-08 12:02:33.000000000 -0400
@@ -191,6 +191,7 @@ irqreturn_t lpfc_sli4_sp_intr_handler(in
 irqreturn_t lpfc_sli4_fp_intr_handler(int, void *);
 
 void lpfc_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_sli4_swap_str(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_config_ring(struct lpfc_hba *, int, LPFC_MBOXQ_t *);
 void lpfc_config_port(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_kill_board(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2010-06-08 12:02:18.000000000 -0400
@@ -815,6 +815,7 @@ struct lpfc_hba {
 #define HBA_MENLO_SUPPORT	0x1 /* HBA supports menlo commands */
 	uint32_t iocb_cnt;
 	uint32_t iocb_max;
+	atomic_t sdev_cnt;
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-06-08 12:01:54.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-06-08 12:02:34.000000000 -0400
@@ -3845,6 +3845,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 				mempool_free(mbox, phba->mbox_mem_pool);
 		}
 		lpfc_no_rpi(phba, ndlp);
+
 		ndlp->nlp_rpi = 0;
 		ndlp->nlp_flag &= ~NLP_RPI_VALID;
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-06-08 12:01:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-06-08 12:02:18.000000000 -0400
@@ -4919,6 +4919,7 @@ lpfc_create_shost(struct lpfc_hba *phba)
 	phba->fc_altov = FF_DEF_ALTOV;
 	phba->fc_arbtov = FF_DEF_ARBTOV;
 
+	atomic_set(&phba->sdev_cnt, 0);
 	vport = lpfc_create_port(phba, phba->brd_no, &phba->pcidev->dev);
 	if (!vport)
 		return -ENODEV;
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-06-08 12:02:34.000000000 -0400
@@ -955,6 +955,26 @@ lpfc_read_rev(struct lpfc_hba * phba, LP
 	return;
 }
 
+void
+lpfc_sli4_swap_str(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	MAILBOX_t *mb = &pmb->u.mb;
+	struct lpfc_mqe *mqe;
+
+	switch (mb->mbxCommand) {
+	case  MBX_READ_REV:
+		 mqe = &pmb->u.mqe;
+		lpfc_sli_pcimem_bcopy(mqe->un.read_rev.fw_name,
+				 mqe->un.read_rev.fw_name, 16);
+		lpfc_sli_pcimem_bcopy(mqe->un.read_rev.ulp_fw_name,
+				 mqe->un.read_rev.ulp_fw_name, 16);
+		break;
+	default:
+		break;
+	}
+	return;
+}
+
 /**
  * lpfc_build_hbq_profile2 - Set up the HBQ Selection Profile 2
  * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-06-08 12:01:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-06-08 12:02:18.000000000 -0400
@@ -747,7 +747,6 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 	int status = 0, index;
 	int bcnt;
 	int non_sequential_xri = 0;
-	int rc = 0;
 	LIST_HEAD(sblist);
 
 	for (bcnt = 0; bcnt < num_to_alloc; bcnt++) {
@@ -860,7 +859,6 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 			if (status) {
 				/* Put this back on the abort scsi list */
 				psb->exch_busy = 1;
-				rc++;
 			} else {
 				psb->exch_busy = 0;
 				psb->status = IOSTAT_SUCCESS;
@@ -879,7 +877,6 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 			if (status) {
 				/* Put this back on the abort scsi list */
 				psb->exch_busy = 1;
-				rc++;
 			} else {
 				psb->exch_busy = 0;
 				psb->status = IOSTAT_SUCCESS;
@@ -889,7 +886,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		}
 	}
 
-	return bcnt + non_sequential_xri - rc;
+	return bcnt + non_sequential_xri;
 }
 
 /**
@@ -3572,11 +3569,13 @@ lpfc_slave_alloc(struct scsi_device *sde
 	uint32_t total = 0;
 	uint32_t num_to_alloc = 0;
 	int num_allocated = 0;
+	uint32_t sdev_cnt;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
 	sdev->hostdata = rport->dd_data;
+	sdev_cnt = atomic_inc_return(&phba->sdev_cnt);
 
 	/*
 	 * Populate the cmds_per_lun count scsi_bufs into this host's globally
@@ -3588,6 +3587,10 @@ lpfc_slave_alloc(struct scsi_device *sde
 	total = phba->total_scsi_bufs;
 	num_to_alloc = vport->cfg_lun_queue_depth + 2;
 
+	/* If allocated buffers are enough do nothing */
+	if ((sdev_cnt * (vport->cfg_lun_queue_depth + 2)) < total)
+		return 0;
+
 	/* Allow some exchanges to be available always to complete discovery */
 	if (total >= phba->cfg_hba_queue_depth - LPFC_DISC_IOCB_BUFF_COUNT ) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
@@ -3669,6 +3672,9 @@ lpfc_slave_configure(struct scsi_device 
 static void
 lpfc_slave_destroy(struct scsi_device *sdev)
 {
+	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	atomic_dec(&phba->sdev_cnt);
 	sdev->hostdata = NULL;
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-06-08 12:01:54.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-06-08 12:02:34.000000000 -0400
@@ -528,6 +528,7 @@ int lpfc_sli4_post_all_rpi_hdrs(struct l
 struct lpfc_rpi_hdr *lpfc_sli4_create_rpi_hdr(struct lpfc_hba *);
 void lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *);
 int lpfc_sli4_alloc_rpi(struct lpfc_hba *);
+void __lpfc_sli4_free_rpi(struct lpfc_hba *, int);
 void lpfc_sli4_free_rpi(struct lpfc_hba *, int);
 void lpfc_sli4_remove_rpis(struct lpfc_hba *);
 void lpfc_sli4_async_event_proc(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-06-08 12:01:54.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-06-08 12:02:34.000000000 -0400
@@ -4236,7 +4236,8 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba
 	if (mqe->un.read_rev.avail_vpd_len < *vpd_size)
 		*vpd_size = mqe->un.read_rev.avail_vpd_len;
 
-	lpfc_sli_pcimem_bcopy(dmabuf->virt, vpd, *vpd_size);
+	memcpy(vpd, dmabuf->virt, *vpd_size);
+
 	dma_free_coherent(&phba->pcidev->dev, dma_size,
 			  dmabuf->virt, dmabuf->phys);
 	kfree(dmabuf);
@@ -5305,7 +5306,8 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 	if (mcqe_status != MB_CQE_STATUS_SUCCESS) {
 		bf_set(lpfc_mqe_status, mb, LPFC_MBX_ERROR_RANGE | mcqe_status);
 		rc = MBXERR_ERROR;
-	}
+	} else
+		lpfc_sli4_swap_str(phba, mboxq);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
 			"(%d):0356 Mailbox cmd x%x (x%x) Status x%x "
@@ -7790,9 +7792,10 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 		 * if LPFC_MBX_WAKE flag is set the mailbox is completed
 		 * else do not free the resources.
 		 */
-		if (pmboxq->mbox_flag & LPFC_MBX_WAKE)
+		if (pmboxq->mbox_flag & LPFC_MBX_WAKE) {
 			retval = MBX_SUCCESS;
-		else {
+			lpfc_sli4_swap_str(phba, pmboxq);
+		} else {
 			retval = MBX_TIMEOUT;
 			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		}
@@ -11975,12 +11978,26 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
  * available rpis maintained by the driver.
  **/
 void
+__lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
+{
+	if (test_and_clear_bit(rpi, phba->sli4_hba.rpi_bmask)) {
+		phba->sli4_hba.rpi_count--;
+		phba->sli4_hba.max_cfg_param.rpi_used--;
+	}
+}
+
+/**
+ * lpfc_sli4_free_rpi - Release an rpi for reuse.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release an rpi to the pool of
+ * available rpis maintained by the driver.
+ **/
+void
 lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 {
 	spin_lock_irq(&phba->hbalock);
-	clear_bit(rpi, phba->sli4_hba.rpi_bmask);
-	phba->sli4_hba.rpi_count--;
-	phba->sli4_hba.max_cfg_param.rpi_used--;
+	__lpfc_sli4_free_rpi(phba, rpi);
 	spin_unlock_irq(&phba->hbalock);
 }
 
@@ -12751,6 +12768,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 			continue;
 
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				__lpfc_sli4_free_rpi(phba,
+						mb->u.mb.un.varRegLogin.rpi);
 			mp = (struct lpfc_dmabuf *) (mb->context1);
 			if (mp) {
 				__lpfc_mbuf_free(phba, mp->virt, mp->phys);


