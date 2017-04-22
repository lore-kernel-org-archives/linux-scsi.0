From: jsmart2021@gmail.com
Subject: [PATCH] lpfc: Fix memory corruption of the lpfc_ncmd->list pointers
Date: Fri, 21 Apr 2017 17:49:08 -0700
Message-ID: <20170422004908.24261-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33132 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1042941AbdDVAtQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 20:49:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, emilne@redhat.com, jthumshirn@suse.de, linux-block@vger.kernel.org, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

lpfc was changing the private pointer that is set/maintained by
the nvme_fc transport. This caused two issues: a) the transport, on
teardown may erroneous attempt to free whatever address was set;
and b) lfpc uses any value set in lpfc_nvme_fcp_abort() and
assumes its a valid io request.

Correct issue by properly defining a context structure for lpfc.
Lpfc also updated to clear the private context structure on io
completion.

Since this bug caused scrutiny of the way lpfc moves local request
structures between lists, also cleaned up list_del()'s to
list_del_inits()'s.

This is a nvme-specific bug. The patch was cut against the
linux-block tree, for-4.12/block tree. It should be pulled in through
that tree.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 17 +++++++++++------
 drivers/scsi/lpfc/lpfc_nvme.h |  4 ++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index f98cbc2..8008c82 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -761,6 +761,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	struct nvme_fc_cmd_iu *cp;
 	struct lpfc_nvme_rport *rport;
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	unsigned long flags;
 	uint32_t code;
 	uint16_t cid, sqhd, data;
@@ -918,6 +919,8 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			phba->cpucheck_cmpl_io[lpfc_ncmd->cpu]++;
 	}
 #endif
+	freqpriv = nCmd->private;
+	freqpriv->nvme_buf = NULL;
 	nCmd->done(nCmd);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
@@ -1214,6 +1217,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_buf *lpfc_ncmd;
 	struct lpfc_nvme_rport *rport;
 	struct lpfc_nvme_qhandle *lpfc_queue_info;
+	struct lpfc_nvme_fcpreq_priv *freqpriv = pnvme_fcreq->private;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t start = 0;
 #endif
@@ -1292,7 +1296,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	 * Do not let the IO hang out forever.  There is no midlayer issuing
 	 * an abort so inform the FW of the maximum IO pending time.
 	 */
-	pnvme_fcreq->private = (void *)lpfc_ncmd;
+	freqpriv->nvme_buf = lpfc_ncmd;
 	lpfc_ncmd->nvmeCmd = pnvme_fcreq;
 	lpfc_ncmd->nrport = rport;
 	lpfc_ncmd->ndlp = ndlp;
@@ -1422,6 +1426,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_buf *lpfc_nbuf;
 	struct lpfc_iocbq *abts_buf;
 	struct lpfc_iocbq *nvmereq_wqe;
+	struct lpfc_nvme_fcpreq_priv *freqpriv = pnvme_fcreq->private;
 	union lpfc_wqe *abts_wqe;
 	unsigned long flags;
 	int ret_val;
@@ -1484,7 +1489,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		return;
 	}
 
-	lpfc_nbuf = (struct lpfc_nvme_buf *)pnvme_fcreq->private;
+	lpfc_nbuf = freqpriv->nvme_buf;
 	if (!lpfc_nbuf) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
@@ -1637,7 +1642,7 @@ static struct nvme_fc_port_template lpfc_nvme_template = {
 	.local_priv_sz = sizeof(struct lpfc_nvme_lport),
 	.remote_priv_sz = sizeof(struct lpfc_nvme_rport),
 	.lsrqst_priv_sz = 0,
-	.fcprqst_priv_sz = 0,
+	.fcprqst_priv_sz = sizeof(struct lpfc_nvme_fcpreq_priv),
 };
 
 /**
@@ -2068,7 +2073,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 		if (lpfc_test_rrq_active(phba, ndlp,
 					 lpfc_ncmd->cur_iocbq.sli4_lxritag))
 			continue;
-		list_del(&lpfc_ncmd->list);
+		list_del_init(&lpfc_ncmd->list);
 		found = 1;
 		break;
 	}
@@ -2083,7 +2088,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 			if (lpfc_test_rrq_active(
 				phba, ndlp, lpfc_ncmd->cur_iocbq.sli4_lxritag))
 				continue;
-			list_del(&lpfc_ncmd->list);
+			list_del_init(&lpfc_ncmd->list);
 			found = 1;
 			break;
 		}
@@ -2542,7 +2547,7 @@ lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 				 &phba->sli4_hba.lpfc_abts_nvme_buf_list,
 				 list) {
 		if (lpfc_ncmd->cur_iocbq.sli4_xritag == xri) {
-			list_del(&lpfc_ncmd->list);
+			list_del_init(&lpfc_ncmd->list);
 			lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
 			lpfc_ncmd->status = IOSTAT_SUCCESS;
 			spin_unlock(
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 2582f46..ec32f45 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -97,3 +97,7 @@ struct lpfc_nvme_buf {
 	uint64_t ts_data_nvme;
 #endif
 };
+
+struct lpfc_nvme_fcpreq_priv {
+	struct lpfc_nvme_buf *nvme_buf;
+};
-- 
2.9.3
