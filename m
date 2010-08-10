From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 2/5] BNX2I: Added support for other TMFs besides
 ABORT_TASK
Date: Tue, 10 Aug 2010 12:09:31 -0700
Message-ID: <1281467374-6182-3-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3618 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992Ab0HJTIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2010 15:08:05 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Expanded the TMF request routine to support other TMFs such as LUN
RESET, etc.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Anil Veerabhadrappa <anilgv@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |   64 +++++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index ece2b62..2667b11 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -393,38 +393,48 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 						bnx2i_conn->ep->qp.sq_prod_qe;
 
 	tmfabort_wqe->op_code = tmfabort_hdr->opcode;
-	tmfabort_wqe->op_attr = 0;
-	tmfabort_wqe->op_attr =
-		ISCSI_TMF_REQUEST_ALWAYS_ONE | ISCSI_TM_FUNC_ABORT_TASK;
+	tmfabort_wqe->op_attr = tmfabort_hdr->flags;
 
 	tmfabort_wqe->itt = (mtask->itt | (ISCSI_TASK_TYPE_MPATH << 14));
 	tmfabort_wqe->reserved2 = 0;
 	tmfabort_wqe->cmd_sn = be32_to_cpu(tmfabort_hdr->cmdsn);
 
-	ctask = iscsi_itt_to_task(conn, tmfabort_hdr->rtt);
-	if (!ctask || !ctask->sc)
-		/*
-		 * the iscsi layer must have completed the cmd while this
-		 * was starting up.
-		 *
-		 * Note: In the case of a SCSI cmd timeout, the task's sc
-		 *       is still active; hence ctask->sc != 0
-		 *       In this case, the task must be aborted
-		 */
-		return 0;
-
-	ref_sc = ctask->sc;
-
-	/* Retrieve LUN directly from the ref_sc */
-	int_to_scsilun(ref_sc->device->lun, (struct scsi_lun *) scsi_lun);
-	tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
-	tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
-
-	if (ref_sc->sc_data_direction == DMA_TO_DEVICE)
-		dword = (ISCSI_TASK_TYPE_WRITE << ISCSI_CMD_REQUEST_TYPE_SHIFT);
-	else
-		dword = (ISCSI_TASK_TYPE_READ << ISCSI_CMD_REQUEST_TYPE_SHIFT);
-	tmfabort_wqe->ref_itt = (dword | (tmfabort_hdr->rtt & ISCSI_ITT_MASK));
+	switch (tmfabort_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+	case ISCSI_TM_FUNC_TASK_REASSIGN:
+		ctask = iscsi_itt_to_task(conn, tmfabort_hdr->rtt);
+		if (!ctask || !ctask->sc)
+			/*
+			 * the iscsi layer must have completed the cmd while
+			 * was starting up.
+			 *
+			 * Note: In the case of a SCSI cmd timeout, the task's
+			 *       sc is still active; hence ctask->sc != 0
+			 *       In this case, the task must be aborted
+			 */
+			return 0;
+
+		ref_sc = ctask->sc;
+
+		/* Retrieve LUN directly from the ref_sc */
+		int_to_scsilun(ref_sc->device->lun,
+			       (struct scsi_lun *) scsi_lun);
+		tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
+		tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
+
+		if (ref_sc->sc_data_direction == DMA_TO_DEVICE)
+			dword = (ISCSI_TASK_TYPE_WRITE <<
+				 ISCSI_CMD_REQUEST_TYPE_SHIFT);
+		else
+			dword = (ISCSI_TASK_TYPE_READ <<
+				 ISCSI_CMD_REQUEST_TYPE_SHIFT);
+		tmfabort_wqe->ref_itt = (dword |
+					(tmfabort_hdr->rtt & ISCSI_ITT_MASK));
+		break;
+	default:
+		memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, 8);
+		tmfabort_wqe->ref_itt = RESERVED_ITT;
+	}
 	tmfabort_wqe->ref_cmd_sn = be32_to_cpu(tmfabort_hdr->refcmdsn);
 
 	tmfabort_wqe->bd_list_addr_lo = (u32) bnx2i_conn->hba->mp_bd_dma;
-- 
1.7.0.5


