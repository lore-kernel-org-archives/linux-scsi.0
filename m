From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/14] lpfc: LPFC_CMD_RRQ_ACTIVE flag to mark commands
Date: Thu,  2 Jun 2016 16:39:15 +0200
Message-ID: <1464878356-42407-14-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008AbcFBOjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:25 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

During aborts the xri might not be valid, so this patch
introduces a new command flag 'LPFC_CMD_RRQ_ACTIVE' which
signals that an RRQ is outstanding for this command and
the xri cannot be used ATM.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |  7 +++++++
 drivers/scsi/lpfc/lpfc_scsi.h |  1 +
 drivers/scsi/lpfc/lpfc_sli.c  | 43 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a3eb5ff..348cae6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -571,6 +571,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 			if (ndlp) {
 				lpfc_set_rrq_active(phba, ndlp,
 					psb->cur_iocbq.sli4_lxritag, rxid, 1);
+				set_bit(LPFC_CMD_RRQ_ACTIVE, &psb->flags);
 				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
 			}
 			lpfc_release_scsi_buf_s4(phba, psb);
@@ -4093,6 +4094,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 				lpfc_set_rrq_active(phba, pnode,
 					lpfc_cmd->cur_iocbq.sli4_lxritag,
 					0, 0);
+				set_bit(LPFC_CMD_RRQ_ACTIVE, &lpfc_cmd->flags);
 			}
 		/* else: fall through */
 		default:
@@ -4605,6 +4607,11 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "9036 iotag %x hwq %x busy\n",
 					 lpfc_cmd->iotag, hwq);
 			lpfc_cmd = NULL;
+		} else if (test_bit(LPFC_CMD_RRQ_ACTIVE, &lpfc_cmd->flags)) {
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_SCSI_CMD,
+					 "9037 iotag %x hwq %x rrq active\n",
+					 lpfc_cmd->iotag, hwq);
+			lpfc_cmd = NULL;
 		}
 	} else
 		lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index a07341e..017ae28 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -147,6 +147,7 @@ struct lpfc_scsi_buf {
 #define LPFC_CMD_EXCH_BUSY 0
 #define LPFC_CMD_ABORTED   1
 #define LPFC_CMD_QUEUED    2
+#define LPFC_CMD_RRQ_ACTIVE 3
 	dma_addr_t nonsg_phys;	/* Non scatter-gather physical address. */
 
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 52b1fa1..e5cd212 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -658,6 +658,26 @@ lpfc_clr_rrq_active(struct lpfc_hba *phba,
 		goto out;
 
 	if (test_and_clear_bit(xritag, ndlp->active_rrqs_xri_bitmap)) {
+		unsigned long iflag;
+		int i;
+		struct lpfc_iocbq *iocbq;
+		struct lpfc_scsi_buf *psb;
+
+		spin_lock_irqsave(&phba->hbalock, iflag);
+		for (i = 1; i <= phba->sli.last_iotag; i++) {
+			iocbq = phba->sli.iocbq_lookup[i];
+			if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+			    (iocbq->iocb_flag & LPFC_IO_LIBDFC))
+				continue;
+			if (iocbq->sli4_lxritag != rrq->xritag)
+				continue;
+
+			psb = container_of(iocbq, struct lpfc_scsi_buf,
+					   cur_iocbq);
+			clear_bit(LPFC_CMD_RRQ_ACTIVE, &psb->flags);
+			break;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		rrq->send_rrq = 0;
 		rrq->xritag = 0;
 		rrq->rrq_stop_time = 0;
@@ -15271,9 +15291,30 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	else
 		xri = rxid;
 	lxri = lpfc_sli4_xri_inrange(phba, xri);
-	if (lxri != NO_XRI)
+	if (lxri != NO_XRI) {
+		unsigned long iflag;
+		int i;
+		struct lpfc_iocbq *iocbq;
+		struct lpfc_scsi_buf *psb;
+
 		lpfc_set_rrq_active(phba, ndlp, lxri,
 			(xri == oxid) ? rxid : oxid, 0);
+		spin_lock_irqsave(&phba->hbalock, iflag);
+		for (i = 1; i <= phba->sli.last_iotag; i++) {
+			iocbq = phba->sli.iocbq_lookup[i];
+			if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+			    (iocbq->iocb_flag & LPFC_IO_LIBDFC))
+				continue;
+			if (iocbq->sli4_lxritag != lxri)
+				continue;
+
+			psb = container_of(iocbq, struct lpfc_scsi_buf,
+					   cur_iocbq);
+			set_bit(LPFC_CMD_RRQ_ACTIVE, &psb->flags);
+			break;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+	}
 	/* For BA_ABTS from exchange responder, if the logical xri with
 	 * the oxid maps to the FCP XRI range, the port no longer has
 	 * that exchange context, send a BLS_RJT. Override the IOCB for
-- 
1.8.5.6

