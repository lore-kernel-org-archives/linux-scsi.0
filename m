From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 4/5] BNX2I - Task management ABORT TASK fixes
Date: Mon, 7 Dec 2009 11:40:29 -0800
Message-ID: <1260214829.31468.99.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2181 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273AbZLGTkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 14:40:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, mchan@broadcom.com, poswald@novell.com


    * Due to typo error driver was failing TMF Abort Task request
      when ctask->sc != NULL. Fixed code to fail TMF ABORT Task
      request only when ctask->sc == NULL
    * Clear age component (19 most significant bits) of reference ITT
      carried in iSCSI TMF PDU. Age component is internal to initiator
      side and only lower bits of ITT as defined by ISCSI_ITT_MASK is
      is sent on wire
    * Retrieve LUN directly from the ref_sc and update SQ wqe as per
      chip HSI (Host Software Interface) specification

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 57f4ca9..af350b2 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -384,6 +384,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	struct bnx2i_cmd *bnx2i_cmd;
 	struct bnx2i_tmf_request *tmfabort_wqe;
 	u32 dword;
+	u32 scsi_lun[2];
 
 	bnx2i_cmd = (struct bnx2i_cmd *)mtask->dd_data;
 	tmfabort_hdr = (struct iscsi_tm *)mtask->hdr;
@@ -394,27 +395,35 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	tmfabort_wqe->op_attr = 0;
 	tmfabort_wqe->op_attr =
 		ISCSI_TMF_REQUEST_ALWAYS_ONE | ISCSI_TM_FUNC_ABORT_TASK;
-	tmfabort_wqe->lun[0] = be32_to_cpu(tmfabort_hdr->lun[0]);
-	tmfabort_wqe->lun[1] = be32_to_cpu(tmfabort_hdr->lun[1]);
 
 	tmfabort_wqe->itt = (mtask->itt | (ISCSI_TASK_TYPE_MPATH << 14));
 	tmfabort_wqe->reserved2 = 0;
 	tmfabort_wqe->cmd_sn = be32_to_cpu(tmfabort_hdr->cmdsn);
 
 	ctask = iscsi_itt_to_task(conn, tmfabort_hdr->rtt);
-	if (!ctask || ctask->sc)
+	if (!ctask || !ctask->sc)
 		/*
 		 * the iscsi layer must have completed the cmd while this
 		 * was starting up.
+		 * 
+		 * Note: In the case of a SCSI cmd timeout, the task's sc
+		 *       is still active; hence ctask->sc != 0
+		 *       In this case, the task must be aborted
 		 */
 		return 0;
+
 	ref_sc = ctask->sc;
 
+	/* Retrieve LUN directly from the ref_sc */
+	int_to_scsilun(ref_sc->device->lun, (struct scsi_lun *) scsi_lun);
+	tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
+	tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);	
+
 	if (ref_sc->sc_data_direction == DMA_TO_DEVICE)
 		dword = (ISCSI_TASK_TYPE_WRITE << ISCSI_CMD_REQUEST_TYPE_SHIFT);
 	else
 		dword = (ISCSI_TASK_TYPE_READ << ISCSI_CMD_REQUEST_TYPE_SHIFT);
-	tmfabort_wqe->ref_itt = (dword | tmfabort_hdr->rtt);
+	tmfabort_wqe->ref_itt = (dword | (tmfabort_hdr->rtt & ISCSI_ITT_MASK));
 	tmfabort_wqe->ref_cmd_sn = be32_to_cpu(tmfabort_hdr->refcmdsn);
 
 	tmfabort_wqe->bd_list_addr_lo = (u32) bnx2i_conn->hba->mp_bd_dma;
-- 
1.6.5.1




