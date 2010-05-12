From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/7] lpfc 8.3.13: Add TX Queue Support for SLI4 ELS commands
Date: Wed, 12 May 2010 09:32:28 -0400
Message-ID: <1273671184.24670.22.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16392 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753982Ab0ELNdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 09:33:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add TX Queue Support for SLI4 ELS commands.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    5 +
 lpfc_attr.c      |   58 ++++++++++++++++
 lpfc_bsg.c       |    9 ++
 lpfc_crtn.h      |    9 ++
 lpfc_els.c       |   36 +++++++---
 lpfc_hbadisc.c   |    2 
 lpfc_init.c      |    8 +-
 lpfc_nportdisc.c |   24 +++++-
 lpfc_scsi.c      |    4 -
 lpfc_sli.c       |  194 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 lpfc_sli.h       |    2 
 11 files changed, 310 insertions(+), 41 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-05-12 09:02:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-05-12 09:05:09.000000000 -0400
@@ -1949,6 +1949,59 @@ static DEVICE_ATTR(lpfc_enable_npiv, S_I
 LPFC_ATTR_R(suppress_link_up, LPFC_INITIALIZE_LINK, LPFC_INITIALIZE_LINK,
 		LPFC_DELAY_INIT_LINK_INDEFINITELY,
 		"Suppress Link Up at initialization");
+/*
+# lpfc_cnt: Number of IOCBs allocated for ELS, CT, and ABTS
+#       1 - (1024)
+#       2 - (2048)
+#       3 - (3072)
+#       4 - (4096)
+#       5 - (5120)
+*/
+static ssize_t
+lpfc_iocb_hw_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", phba->iocb_max);
+}
+
+static DEVICE_ATTR(iocb_hw, S_IRUGO,
+			 lpfc_iocb_hw_show, NULL);
+static ssize_t
+lpfc_txq_hw_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+		phba->sli.ring[LPFC_ELS_RING].txq_max);
+}
+
+static DEVICE_ATTR(txq_hw, S_IRUGO,
+			 lpfc_txq_hw_show, NULL);
+static ssize_t
+lpfc_txcmplq_hw_show(struct device *dev, struct device_attribute *attr,
+ char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+		phba->sli.ring[LPFC_ELS_RING].txcmplq_max);
+}
+
+static DEVICE_ATTR(txcmplq_hw, S_IRUGO,
+			 lpfc_txcmplq_hw_show, NULL);
+
+int lpfc_iocb_cnt = 2;
+module_param(lpfc_iocb_cnt, int, 1);
+MODULE_PARM_DESC(lpfc_iocb_cnt,
+	"Number of IOCBs alloc for ELS, CT, and ABTS: 1k to 5k IOCBs");
+lpfc_param_show(iocb_cnt);
+lpfc_param_init(iocb_cnt, 2, 1, 5);
+static DEVICE_ATTR(lpfc_iocb_cnt, S_IRUGO,
+			 lpfc_iocb_cnt_show, NULL);
 
 /*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
@@ -3332,6 +3385,10 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_aer_support,
 	&dev_attr_lpfc_aer_state_cleanup,
 	&dev_attr_lpfc_suppress_link_up,
+	&dev_attr_lpfc_iocb_cnt,
+	&dev_attr_iocb_hw,
+	&dev_attr_txq_hw,
+	&dev_attr_txcmplq_hw,
 	NULL,
 };
 
@@ -4511,6 +4568,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
 	lpfc_aer_support_init(phba, lpfc_aer_support);
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
+	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-05-12 09:04:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-05-12 09:05:09.000000000 -0400
@@ -419,6 +419,11 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 
 	if (rc == IOCB_SUCCESS)
 		return 0; /* done for now */
+	else if (rc == IOCB_BUSY)
+		rc = EAGAIN;
+	else
+		rc = EIO;
+
 
 	/* iocb failed so cleanup */
 	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
@@ -669,6 +674,10 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	lpfc_nlp_put(ndlp);
 	if (rc == IOCB_SUCCESS)
 		return 0; /* done for now */
+	else if (rc == IOCB_BUSY)
+		rc = EAGAIN;
+	else
+		rc = EIO;
 
 	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
 		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-05-12 09:00:35.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-05-12 09:05:09.000000000 -0400
@@ -403,3 +403,12 @@ int lpfc_bsg_request(struct fc_bsg_job *
 int lpfc_bsg_timeout(struct fc_bsg_job *);
 int lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_iocbq *);
+void __lpfc_sli_ringtx_put(struct lpfc_hba *, struct lpfc_sli_ring *,
+	struct lpfc_iocbq *);
+struct lpfc_iocbq *lpfc_sli_ringtx_get(struct lpfc_hba *,
+	struct lpfc_sli_ring *);
+int __lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
+	struct lpfc_iocbq *, uint32_t);
+uint32_t lpfc_drain_txq(struct lpfc_hba *);
+
+
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-05-12 09:00:35.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-05-12 09:05:09.000000000 -0400
@@ -1472,8 +1472,12 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 			}
 			goto out;
 		}
-		/* PLOGI failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+		/* PLOGI failed Don't print the vport to vport rjts */
+		if (irsp->ulpStatus != IOSTAT_LS_RJT ||
+			(((irsp->un.ulpWord[4]) >> 16 != LSRJT_INVALID_CMD) &&
+			((irsp->un.ulpWord[4]) >> 16 != LSRJT_UNABLE_TPC)) ||
+			(phba)->pport->cfg_log_verbose & LOG_ELS)
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "2753 PLOGI failure DID:%06X Status:x%x/x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4]);
@@ -5144,6 +5148,7 @@ lpfc_els_timeout(unsigned long ptr)
 	return;
 }
 
+
 /**
  * lpfc_els_timeout_handler - Process an els timeout event
  * @vport: pointer to a virtual N_Port data structure.
@@ -5164,13 +5169,19 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 	uint32_t els_command = 0;
 	uint32_t timeout;
 	uint32_t remote_ID = 0xffffffff;
+	LIST_HEAD(txcmplq_completions);
+	LIST_HEAD(abort_list);
+
 
-	spin_lock_irq(&phba->hbalock);
 	timeout = (uint32_t)(phba->fc_ratov << 1);
 
 	pring = &phba->sli.ring[LPFC_ELS_RING];
 
-	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
+	spin_lock_irq(&phba->hbalock);
+	list_splice_init(&pring->txcmplq, &txcmplq_completions);
+	spin_unlock_irq(&phba->hbalock);
+
+	list_for_each_entry_safe(piocb, tmp_iocb, &txcmplq_completions, list) {
 		cmd = &piocb->iocb;
 
 		if ((piocb->iocb_flag & LPFC_IO_LIBDFC) != 0 ||
@@ -5207,13 +5218,22 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 			if (ndlp && NLP_CHK_NODE_ACT(ndlp))
 				remote_ID = ndlp->nlp_DID;
 		}
+		list_add_tail(&piocb->dlist, &abort_list);
+	}
+	spin_lock_irq(&phba->hbalock);
+	list_splice(&txcmplq_completions, &pring->txcmplq);
+	spin_unlock_irq(&phba->hbalock);
+
+	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "0127 ELS timeout Data: x%x x%x x%x "
-				 "x%x\n", els_command,
-				 remote_ID, cmd->ulpCommand, cmd->ulpIoTag);
+			 "0127 ELS timeout Data: x%x x%x x%x "
+			 "x%x\n", els_command,
+			 remote_ID, cmd->ulpCommand, cmd->ulpIoTag);
+		spin_lock_irq(&phba->hbalock);
+		list_del_init(&piocb->dlist);
 		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
+		spin_unlock_irq(&phba->hbalock);
 	}
-	spin_unlock_irq(&phba->hbalock);
 
 	if (phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt)
 		mod_timer(&vport->els_tmofunc, jiffies + HZ * timeout);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-05-12 09:02:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2010-05-12 09:05:09.000000000 -0400
@@ -20,7 +20,6 @@
  *******************************************************************/
 
 #include <scsi/scsi_host.h>
-
 struct lpfc_sli2_slim;
 
 #define LPFC_PCI_DEV_LP		0x1
@@ -376,6 +375,7 @@ struct lpfc_vport {
 #define WORKER_FABRIC_BLOCK_TMO        0x400	/* hba: fabric block timeout */
 #define WORKER_RAMP_DOWN_QUEUE         0x800	/* hba: Decrease Q depth */
 #define WORKER_RAMP_UP_QUEUE           0x1000	/* hba: Increase Q depth */
+#define WORKER_SERVICE_TXQ             0x2000	/* hba: IOCBs on the txq */
 
 	struct timer_list fc_fdmitmo;
 	struct timer_list els_tmofunc;
@@ -624,6 +624,7 @@ struct lpfc_hba {
 	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
+	uint32_t cfg_iocb_cnt;
 	uint32_t cfg_suppress_link_up;
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
 #define LPFC_DELAY_INIT_LINK              1	/* layered driver hold off */
@@ -812,6 +813,8 @@ struct lpfc_hba {
 
 	uint8_t menlo_flag;	/* menlo generic flags */
 #define HBA_MENLO_SUPPORT	0x1 /* HBA supports menlo commands */
+	uint32_t iocb_cnt;
+	uint32_t iocb_max;
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-05-12 09:00:35.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-05-12 09:05:09.000000000 -0400
@@ -587,6 +587,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 							(status &
 							 HA_RXMASK));
 		}
+		if (phba->pport->work_port_events & WORKER_SERVICE_TXQ)
+			lpfc_drain_txq(phba);
 		/*
 		 * Turn on Ring interrupts
 		 */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-05-12 09:03:52.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-05-12 09:05:09.000000000 -0400
@@ -8147,8 +8147,12 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	}
 
 	/* Initialize and populate the iocb list per host */
-	error = lpfc_init_iocb_list(phba,
-			phba->sli4_hba.max_cfg_param.max_xri);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2821 initialize iocb list %d.\n",
+			phba->cfg_iocb_cnt*1024);
+	error = lpfc_init_iocb_list(phba, phba->cfg_iocb_cnt*1024);
+
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1413 Failed to initialize iocb list.\n");
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-05-12 09:00:35.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-05-12 09:05:09.000000000 -0400
@@ -190,6 +190,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba 
 }
 

+
 /*
  * Free resources / clean up outstanding I/Os
  * associated with a LPFC_NODELIST entry. This
@@ -199,13 +200,15 @@ int
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(completions);
+	LIST_HEAD(txcmplq_completions);
+	LIST_HEAD(abort_list);
 	struct lpfc_sli  *psli = &phba->sli;
 	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	struct lpfc_iocbq *iocb, *next_iocb;
 
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
-			 "0205 Abort outstanding I/O on NPort x%x "
+			 "2819 Abort outstanding I/O on NPort x%x "
 			 "Data: x%x x%x x%x\n",
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
@@ -224,14 +227,25 @@ lpfc_els_abort(struct lpfc_hba *phba, st
 	}
 
 	/* Next check the txcmplq */
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
+	list_splice_init(&pring->txcmplq, &txcmplq_completions);
+	spin_unlock_irq(&phba->hbalock);
+
+	list_for_each_entry_safe(iocb, next_iocb, &txcmplq_completions, list) {
 		/* Check to see if iocb matches the nport we are looking for */
-		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp)) {
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
-		}
+		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))
+			list_add_tail(&iocb->dlist, &abort_list);
 	}
+	spin_lock_irq(&phba->hbalock);
+	list_splice(&txcmplq_completions, &pring->txcmplq);
 	spin_unlock_irq(&phba->hbalock);
 
+	list_for_each_entry_safe(iocb, next_iocb, &abort_list, dlist) {
+			spin_lock_irq(&phba->hbalock);
+			list_del_init(&iocb->dlist);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			spin_unlock_irq(&phba->hbalock);
+	}
+
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_ABORTED);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-05-12 09:03:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-05-12 09:05:09.000000000 -0400
@@ -3228,7 +3228,9 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 			 lpfc_taskmgmt_name(task_mgmt_cmd),
 			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
 			 iocbqrsp->iocb.un.ulpWord[4]);
-	} else
+	} else if (status == IOCB_BUSY)
+		ret = FAILED;
+	else
 		ret = SUCCESS;
 
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-05-12 09:03:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-05-12 09:05:09.000000000 -0400
@@ -455,6 +455,11 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *ph
 	struct lpfc_iocbq * iocbq = NULL;
 
 	list_remove_head(lpfc_iocb_list, iocbq, struct lpfc_iocbq, list);
+
+	if (iocbq)
+		phba->iocb_cnt++;
+	if (phba->iocb_cnt > phba->iocb_max)
+		phba->iocb_max = phba->iocb_cnt;
 	return iocbq;
 }
 
@@ -575,7 +580,8 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 {
 	struct lpfc_sglq *sglq;
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
-	unsigned long iflag;
+	unsigned long iflag = 0;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	if (iocbq->sli4_xritag == NO_XRI)
 		sglq = NULL;
@@ -593,6 +599,17 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 		} else {
 			sglq->state = SGL_FREED;
 			list_add(&sglq->list, &phba->sli4_hba.lpfc_sgl_list);
+
+			/* Check if TXQ queue needs to be serviced */
+			if (pring->txq_cnt) {
+				spin_lock_irqsave(
+					&phba->pport->work_port_lock, iflag);
+				phba->pport->work_port_events |=
+					WORKER_SERVICE_TXQ;
+				lpfc_worker_wake_up(phba);
+				spin_unlock_irqrestore(
+					&phba->pport->work_port_lock, iflag);
+			}
 		}
 	}
 
@@ -605,6 +622,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
 
+
 /**
  * __lpfc_sli_release_iocbq_s3 - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
@@ -642,6 +660,7 @@ static void
 __lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	phba->__lpfc_sli_release_iocbq(phba, iocbq);
+	phba->iocb_cnt--;
 }
 
 /**
@@ -872,7 +891,11 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba 
 			struct lpfc_iocbq *piocb)
 {
 	list_add_tail(&piocb->list, &pring->txcmplq);
+	piocb->iocb_flag |= LPFC_IO_ON_Q;
 	pring->txcmplq_cnt++;
+	if (pring->txcmplq_cnt > pring->txcmplq_max)
+		pring->txcmplq_max = pring->txcmplq_cnt;
+
 	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
 	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
@@ -897,7 +920,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba 
  * the txq, the function returns first iocb in the list after
  * removing the iocb from the list, else it returns NULL.
  **/
-static struct lpfc_iocbq *
+struct lpfc_iocbq *
 lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
 	struct lpfc_iocbq *cmd_iocb;
@@ -2150,7 +2173,10 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
 		list_del_init(&cmd_iocb->list);
-		pring->txcmplq_cnt--;
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_Q) {
+			pring->txcmplq_cnt--;
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_Q;
+		}
 		return cmd_iocb;
 	}
 
@@ -2183,7 +2209,10 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
 		list_del_init(&cmd_iocb->list);
-		pring->txcmplq_cnt--;
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_Q) {
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_Q;
+			pring->txcmplq_cnt--;
+		}
 		return cmd_iocb;
 	}
 
@@ -5578,7 +5607,7 @@ lpfc_mbox_api_table_setup(struct lpfc_hb
  * iocb to the txq when SLI layer cannot submit the command iocb
  * to the ring.
  **/
-static void
+void
 __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb)
 {
@@ -6195,7 +6224,6 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 			 struct lpfc_iocbq *piocb, uint32_t flag)
 {
 	struct lpfc_sglq *sglq;
-	uint16_t xritag;
 	union lpfc_wqe wqe;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
 
@@ -6204,10 +6232,26 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
 			sglq = NULL;
 		else {
+			if (pring->txq_cnt) {
+				if (!(flag & SLI_IOCB_RET_IOCB)) {
+					__lpfc_sli_ringtx_put(phba,
+						pring, piocb);
+					return IOCB_SUCCESS;
+				} else {
+					return IOCB_BUSY;
+				}
+			} else {
 			sglq = __lpfc_sli_get_sglq(phba);
-			if (!sglq)
-				return IOCB_ERROR;
-			piocb->sli4_xritag = sglq->sli4_xritag;
+				if (!sglq) {
+					if (!(flag & SLI_IOCB_RET_IOCB)) {
+						__lpfc_sli_ringtx_put(phba,
+								pring,
+								piocb);
+						return IOCB_SUCCESS;
+					} else
+						return IOCB_BUSY;
+				}
+			}
 		}
 	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
 		sglq = NULL; /* These IO's already have an XRI and
@@ -6223,8 +6267,9 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 	}
 
 	if (sglq) {
-		xritag = lpfc_sli4_bpl2sgl(phba, piocb, sglq);
-		if (xritag != sglq->sli4_xritag)
+		piocb->sli4_xritag = sglq->sli4_xritag;
+
+		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocb, sglq))
 			return IOCB_ERROR;
 	}
 
@@ -6264,7 +6309,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
  * 	IOCB_SUCCESS - Success
  * 	IOCB_BUSY - Busy
  **/
-static inline int
+int
 __lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		struct lpfc_iocbq *piocb, uint32_t flag)
 {
@@ -7081,13 +7126,6 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 			 */
 			abort_iocb = phba->sli.iocbq_lookup[abort_context];
 
-		lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_SLI,
-				"0327 Cannot abort els iocb %p "
-				"with tag %x context %x, abort status %x, "
-				"abort code %x\n",
-				abort_iocb, abort_iotag, abort_context,
-				irsp->ulpStatus, irsp->un.ulpWord[4]);
-
 		/*
 		 *  If the iocb is not found in Firmware queue the iocb
 		 *  might have completed already. Do not free it again.
@@ -7106,6 +7144,13 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 			if (abort_iocb && phba->sli_rev == LPFC_SLI_REV4)
 				abort_context = abort_iocb->iocb.ulpContext;
 		}
+
+		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS | LOG_SLI,
+				"0327 Cannot abort els iocb %p "
+				"with tag %x context %x, abort status %x, "
+				"abort code %x\n",
+				abort_iocb, abort_iotag, abort_context,
+				irsp->ulpStatus, irsp->un.ulpWord[4]);
 		/*
 		 * make sure we have the right iocbq before taking it
 		 * off the txcmplq and try to call completion routine.
@@ -7123,7 +7168,10 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 			 * following abort XRI from the HBA.
 			 */
 			list_del_init(&abort_iocb->list);
-			pring->txcmplq_cnt--;
+			if (abort_iocb->iocb_flag & LPFC_IO_ON_Q) {
+				abort_iocb->iocb_flag &= ~LPFC_IO_ON_Q;
+				pring->txcmplq_cnt--;
+			}
 
 			/* Firmware could still be in progress of DMAing
 			 * payload, so don't free data buffer till after
@@ -7255,8 +7303,9 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
 			 "0339 Abort xri x%x, original iotag x%x, "
 			 "abort cmd iotag x%x\n",
+			 iabt->un.acxri.abortIoTag,
 			 iabt->un.acxri.abortContextTag,
-			 iabt->un.acxri.abortIoTag, abtsiocbp->iotag);
+			 abtsiocbp->iotag);
 	retval = __lpfc_sli_issue_iocb(phba, pring->ringno, abtsiocbp, 0);
 
 	if (retval)
@@ -7586,7 +7635,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	long timeleft, timeout_req = 0;
 	int retval = IOCB_SUCCESS;
 	uint32_t creg_val;
-
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 	/*
 	 * If the caller has provided a response iocbq buffer, then context2
 	 * is NULL or its an error.
@@ -7608,7 +7657,8 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 		readl(phba->HCregaddr); /* flush */
 	}
 
-	retval = lpfc_sli_issue_iocb(phba, ring_number, piocb, 0);
+	retval = lpfc_sli_issue_iocb(phba, ring_number, piocb,
+				     SLI_IOCB_RET_IOCB);
 	if (retval == IOCB_SUCCESS) {
 		timeout_req = timeout * HZ;
 		timeleft = wait_event_timeout(done_q,
@@ -7630,6 +7680,11 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 					timeout, (timeleft / jiffies));
 			retval = IOCB_TIMEDOUT;
 		}
+	} else if (retval == IOCB_BUSY) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"2818 Max IOCBs %d txq cnt %d txcmplq cnt %d\n",
+			phba->iocb_cnt, pring->txq_cnt, pring->txcmplq_cnt);
+		return retval;
 	} else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"0332 IOCB wait issue failed, Data x%x\n",
@@ -8775,12 +8830,17 @@ lpfc_sli4_sp_handle_els_wcqe(struct lpfc
 {
 	struct lpfc_iocbq *irspiocbq;
 	unsigned long iflags;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_FCP_RING];
 
 	/* Get an irspiocbq for later ELS response processing use */
 	irspiocbq = lpfc_sli_get_iocbq(phba);
 	if (!irspiocbq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0387 Failed to allocate an iocbq\n");
+			"0387 NO IOCBQ data: txq_cnt=%d iocb_cnt=%d "
+			"fcp_txcmplq_cnt=%d, els_txcmplq_cnt=%d\n",
+			pring->txq_cnt, phba->iocb_cnt,
+			phba->sli.ring[LPFC_FCP_RING].txcmplq_cnt,
+			phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt);
 		return false;
 	}
 
@@ -12695,3 +12755,89 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 	spin_unlock_irq(&phba->hbalock);
 }
 
+/**
+ * lpfc_drain_txq - Drain the txq
+ * @phba: Pointer to HBA context object.
+ *
+ * This function attempt to submit IOCBs on the txq
+ * to the adapter.  For SLI4 adapters, the txq contains
+ * ELS IOCBs that have been deferred because the there
+ * are no SGLs.  This congestion can occur with large
+ * vport counts during node discovery.
+ **/
+
+uint32_t
+lpfc_drain_txq(struct lpfc_hba *phba)
+{
+	LIST_HEAD(completions);
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_iocbq *piocbq = 0;
+	unsigned long iflags = 0;
+	char *fail_msg = NULL;
+	struct lpfc_sglq *sglq;
+	union lpfc_wqe wqe;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	if (pring->txq_cnt > pring->txq_max)
+		pring->txq_max = pring->txq_cnt;
+
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	while (pring->txq_cnt) {
+		spin_lock_irqsave(&phba->hbalock, iflags);
+
+		sglq = __lpfc_sli_get_sglq(phba);
+		if (!sglq) {
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			break;
+		} else {
+			piocbq = lpfc_sli_ringtx_get(phba, pring);
+			if (!piocbq) {
+				/* The txq_cnt out of sync. This should
+				 * never happen
+				 */
+				sglq = __lpfc_clear_active_sglq(phba,
+						 sglq->sli4_xritag);
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2823 txq empty and txq_cnt is %d\n ",
+					pring->txq_cnt);
+				break;
+			}
+		}
+
+		/* The xri and iocb resources secured,
+		 * attempt to issue request
+		 */
+		piocbq->sli4_xritag = sglq->sli4_xritag;
+		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocbq, sglq))
+			fail_msg = "to convert bpl to sgl";
+		else if (lpfc_sli4_iocb2wqe(phba, piocbq, &wqe))
+			fail_msg = "to convert iocb to wqe";
+		else if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, &wqe))
+			fail_msg = " - Wq is full";
+		else
+			lpfc_sli_ringtxcmpl_put(phba, pring, piocbq);
+
+		if (fail_msg) {
+			/* Failed means we can't issue and need to cancel */
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2822 IOCB failed %s iotag 0x%x "
+					"xri 0x%x\n",
+					fail_msg,
+					piocbq->iotag, piocbq->sli4_xritag);
+			list_add_tail(&piocbq->list, &completions);
+		}
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+	}
+
+	spin_lock_irqsave(&phba->pport->work_port_lock, iflags);
+	phba->pport->work_port_events &= ~WORKER_SERVICE_TXQ;
+	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflags);
+
+	/* Cancel all the IOCBs that cannot be issued */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+				IOERR_SLI_ABORTED);
+
+	return pring->txq_cnt;
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2010-05-12 09:05:09.000000000 -0400
@@ -48,6 +48,7 @@ struct lpfc_iocbq {
 	/* lpfc_iocbqs are used in double linked lists */
 	struct list_head list;
 	struct list_head clist;
+	struct list_head dlist;
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 	struct lpfc_cq_event cq_event;
@@ -64,6 +65,7 @@ struct lpfc_iocbq {
 #define LPFC_EXCHANGE_BUSY	0x40    /* SLI4 hba reported XB in response */
 #define LPFC_USE_FCPWQIDX	0x80    /* Submit to specified FCPWQ index */
 #define DSS_SECURITY_OP		0x100	/* security IO */
+#define LPFC_IO_ON_Q		0x200	/* The IO is still on the TXCMPLQ */
 
 #define LPFC_FIP_ELS_ID_MASK	0xc000	/* ELS_ID range 0-3, non-shifted mask */
 #define LPFC_FIP_ELS_ID_SHIFT	14


