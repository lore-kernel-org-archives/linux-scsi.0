Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F03CA9EA1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 095B221897
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504693AbfJRHuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:50:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:36804 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504689AbfJRHuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 03:50:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 534E8B823;
        Fri, 18 Oct 2019 07:50:12 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 3/3] lpfc: access nvme nodelist through nvme rport structure
Date:   Fri, 18 Oct 2019 09:50:10 +0200
Message-Id: <20191018075010.55653-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191018075010.55653-1-hare@suse.de>
References: <20191018075010.55653-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of referencing the nodelist directly via a point in the
I/O buffer we should be storing the nvme rport pointer in the
protocol-specific section and access the nodelist through that.
With this we reduce the size of the I/O buffer, eliminate a possible
race and align the protoco-specific sections.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 14 ++++++++------
 drivers/scsi/lpfc/lpfc_sli.h  |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index defb19cdc7fe..80a58003b6aa 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1056,7 +1056,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
 	 */
-	ndlp = lpfc_ncmd->ndlp;
+	ndlp = lpfc_ncmd->nvme.rport->ndlp;
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
 				 "6062 Ignoring NVME cmpl.  No ndlp\n");
@@ -1695,7 +1695,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	 */
 	freqpriv->nvme_buf = lpfc_ncmd;
 	lpfc_ncmd->nvme.nvmeCmd = pnvme_fcreq;
-	lpfc_ncmd->ndlp = ndlp;
+	lpfc_ncmd->nvme.rport = rport;
 	lpfc_ncmd->nvme.qidx = lpfc_queue_info->qidx;
 
 	/*
@@ -2085,11 +2085,13 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd)
 {
 	struct lpfc_sli4_hdw_queue *qp;
 	unsigned long iflag = 0;
+	struct lpfc_nodelist *ndlp =
+	    lpfc_ncmd->nvme.rport ? lpfc_ncmd->nvme.rport->ndlp : NULL;
 
-	if ((lpfc_ncmd->flags & LPFC_SBUF_BUMP_QDEPTH) && lpfc_ncmd->ndlp)
-		atomic_dec(&lpfc_ncmd->ndlp->cmd_pending);
+	if ((lpfc_ncmd->flags & LPFC_SBUF_BUMP_QDEPTH) && ndlp)
+		atomic_dec(&ndlp->cmd_pending);
 
-	lpfc_ncmd->ndlp = NULL;
+	lpfc_ncmd->nvme.rport = NULL;
 	lpfc_ncmd->flags &= ~LPFC_SBUF_BUMP_QDEPTH;
 
 	qp = lpfc_ncmd->hdwq;
@@ -2646,7 +2648,7 @@ lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 {
 	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
 	struct nvmefc_fcp_req *nvme_cmd = NULL;
-	struct lpfc_nodelist *ndlp = lpfc_ncmd->ndlp;
+	struct lpfc_nodelist *ndlp = lpfc_ncmd->nvme.rport->ndlp;
 
 
 	if (ndlp)
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index f0c51288b10a..bb499904bdb6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -382,7 +382,6 @@ struct lpfc_io_buf {
 	uint16_t hdwq_no;
 	uint16_t cpu;
 
-	struct lpfc_nodelist *ndlp;
 	uint32_t timeout;
 	uint16_t flags;  /* TBD convert exch_busy to flags */
 #define LPFC_SBUF_XBUSY		0x1	/* SLI4 hba reported XB on WCQE cmpl */
@@ -439,6 +438,7 @@ struct lpfc_io_buf {
 		/* NVME specific fields */
 		struct {
 			struct nvmefc_fcp_req *nvmeCmd;
+			struct lpfc_nvme_rport *rport;
 			uint16_t qidx;
 		} nvme;
 	};
-- 
2.16.4

