From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 12/19] cannot establish connection with target that sends PRLI in PT2PT
Date: Tue,  4 Apr 2017 10:17:05 -0700
Message-ID: <1491326232-11255-13-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38164 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755171AbdDDRZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:44 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 4DAC630C09C
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:32 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

The driver does not accept PRLI from the target  and this
causes the  target to reject the subsequent PRLI from the driver

Fix: Accept the incoming PRLI so that the target can also accept
the PRLI from the driver

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c  | 12 ++++++++----
 drivers/scsi/lpfc/lpfc_nvme.c  | 23 ++++++++++++-----------
 drivers/scsi/lpfc/lpfc_nvmet.c |  6 +++---
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index cca7f81..88977b8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11061,7 +11061,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
 	struct Scsi_Host  *shost = NULL;
-	int error;
+	int error, cnt;
 	uint32_t cfg_mode, intr_mode;
 
 	/* Allocate memory for HBA structure */
@@ -11095,11 +11095,15 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_unset_pci_mem_s4;
 	}
 
+	cnt = phba->cfg_iocb_cnt * 1024;
+	if (phba->nvmet_support)
+		cnt += (phba->cfg_nvmet_mrq_post * phba->cfg_nvmet_mrq);
+
 	/* Initialize and populate the iocb list per host */
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2821 initialize iocb list %d.\n",
-			phba->cfg_iocb_cnt*1024);
-	error = lpfc_init_iocb_list(phba, phba->cfg_iocb_cnt*1024);
+			"2821 initialize iocb list %d total %d\n",
+			phba->cfg_iocb_cnt, cnt);
+	error = lpfc_init_iocb_list(phba, cnt);
 
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 9d39093..9468679 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1495,6 +1495,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 				 "io buffer.  Skipping abort req.\n");
 		return;
 	}
+	nvmereq_wqe = &lpfc_nbuf->cur_iocbq;
 
 	/*
 	 * The lpfc_nbuf and the mapped nvme_fcreq in the driver's
@@ -1508,20 +1509,19 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
 				 "6143 NVME req mismatch: "
 				 "lpfc_nbuf %p nvmeCmd %p, "
-				 "pnvme_fcreq %p.  Skipping Abort\n",
+				 "pnvme_fcreq %p.  Skipping Abort xri x%x\n",
 				 lpfc_nbuf, lpfc_nbuf->nvmeCmd,
-				 pnvme_fcreq);
+				 pnvme_fcreq, nvmereq_wqe->sli4_xritag);
 		return;
 	}
 
 	/* Don't abort IOs no longer on the pending queue. */
-	nvmereq_wqe = &lpfc_nbuf->cur_iocbq;
 	if (!(nvmereq_wqe->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
 				 "6142 NVME IO req %p not queued - skipping "
-				 "abort req\n",
-				 pnvme_fcreq);
+				 "abort req xri x%x\n",
+				 pnvme_fcreq, nvmereq_wqe->sli4_xritag);
 		return;
 	}
 
@@ -1535,8 +1535,9 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
 				 "6144 Outstanding NVME I/O Abort Request "
 				 "still pending on nvme_fcreq %p, "
-				 "lpfc_ncmd %p\n",
-				 pnvme_fcreq, lpfc_nbuf);
+				 "lpfc_ncmd %p xri x%x\n",
+				 pnvme_fcreq, lpfc_nbuf,
+				 nvmereq_wqe->sli4_xritag);
 		return;
 	}
 
@@ -1545,8 +1546,8 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
 				 "6136 No available abort wqes. Skipping "
-				 "Abts req for nvme_fcreq %p.\n",
-				 pnvme_fcreq);
+				 "Abts req for nvme_fcreq %p xri x%x\n",
+				 pnvme_fcreq, nvmereq_wqe->sli4_xritag);
 		return;
 	}
 
@@ -1604,7 +1605,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	}
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
-			 "6138 Transport Abort NVME Request Issued for\n"
+			 "6138 Transport Abort NVME Request Issued for "
 			 "ox_id x%x on reqtag x%x\n",
 			 nvmereq_wqe->sli4_xritag,
 			 abts_buf->iotag);
@@ -2491,7 +2492,7 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  input_err:
 #endif
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
-			 "6168: State error: lport %p, rport%p FCID x%06x\n",
+			 "6168 State error: lport %p, rport%p FCID x%06x\n",
 			 vport->localport, ndlp->rport, ndlp->nlp_DID);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index cbd6371..3a0ff50 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -873,7 +873,6 @@ dropit:
 	ctxp->wqeq = NULL;
 	ctxp->state = LPFC_NVMET_STE_RCV;
 	ctxp->rqb_buffer = (void *)nvmebuf;
-	spin_lock_init(&ctxp->ctxlock);
 
 	lpfc_nvmeio_data(phba, "NVMET LS   RCV: xri x%x sz %d from %06x\n",
 			 oxid, size, sid);
@@ -982,6 +981,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	ctxp->rqb_buffer = nvmebuf;
 	ctxp->entry_cnt = 1;
 	ctxp->flag = 0;
+	spin_lock_init(&ctxp->ctxlock);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (phba->ktime_on) {
@@ -1004,8 +1004,8 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	}
 #endif
 
-	lpfc_nvmeio_data(phba, "NVMET FCP  RCV: xri x%x sz %d from %06x\n",
-			 oxid, size, sid);
+	lpfc_nvmeio_data(phba, "NVMET FCP  RCV: xri x%x sz %d CPU %02x\n",
+			 oxid, size, smp_processor_id());
 
 	atomic_inc(&tgtp->rcv_fcp_cmd_in);
 	/*
-- 
2.1.0
