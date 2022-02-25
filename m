Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4B6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiBYCYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbiBYCYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:24:03 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D12B1ED4D4
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x11so3533504pll.10
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jnwedUWsrlsiK1kgtkzKelQcjtapijhSq4B7Vzd6eX0=;
        b=EOM4ApJYJ+/t1UiblzqyEyyodPalZLTkiHjXLOf+nuNFYZbwGk4RUm2zl8/eQDDOxj
         PP6iavkDW6q4r66+JV/p3JaVwR17OQUHFRFIB2wSiXKLa9wEjD6s2hnhysA+eJpTWzPG
         2Szp/3D4PPxhePwUMavgK48Yc9htBEIofhCT2ywNsibrkGVwjGUuobTyf7ercduW+lW5
         hB5hhp3SzxW+8tTv5ghnLbMbZTiZ09y5dCARVcB4eOHkks2bebVRRtxW199lc+5r38FR
         pv4O1O3eQyBgFz7B8EDgo3505zbSLUR0xdHCP40Me5s9twhKKNnF6ZevOBHkkDu7xhxo
         FArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jnwedUWsrlsiK1kgtkzKelQcjtapijhSq4B7Vzd6eX0=;
        b=r9h6BX1LneYuQwTdBSuV7+oyAf7RxnSaJOK3WN6fEp2xbm8Ax/FRzjahsQWHKK6SsJ
         MGaA0XfhQGjwYqcvS5Huj1pOQq4w1nj4hZj2wGacHAoMh54enr+8xicbIc5gfs/51aPZ
         FPQvlUvvCXAcAnEi6D3LP8DBFBxbZ61nJRph+QZg/EMdNV+izW+kQVPhMkMbJvgPe+bN
         zx4DIPHojrBs5/ll9WBjfWtjuyGXRlF5ciLAgCPAkycC0gs8fQGvzsyE1QGL0qvzsn8o
         jXqdOOK3OenK8HMCixE7E9glVP9Z0ZKrrzsdkAxFG7p/qH+1DmealMlzEx4QpwHES7JR
         T8ow==
X-Gm-Message-State: AOAM5327DwLxqJro754PSsLT8FmCQR0MQKAWavsIHNPm04q4hmbrMrNU
        sqsuQ56jXF7VObVxNoKuh8gxAvKj4nM=
X-Google-Smtp-Source: ABdhPJyXxxrdXsnxuX6IwlSEYeIuMgdBkvfTj2QCEZroksFyTnlAkz8YDV3elxsvA9wlF3dGRuxx2g==
X-Received: by 2002:a17:90a:7889:b0:1bc:7786:2aac with SMTP id x9-20020a17090a788900b001bc77862aacmr1004216pjk.47.1645755810443;
        Thu, 24 Feb 2022 18:23:30 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 15/17] lpfc: SLI path split: refactor BSG paths
Date:   Thu, 24 Feb 2022 18:23:06 -0800
Message-Id: <20220225022308.16486-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch refactors the BSG paths to use SLI-4 as the primary interface.

Changes include:
- conversion away from using sli-3 iocb structures to set/access fields
  in common routines. Use the new generic get/set routines that were added.
  This move changes code from indirect structure references to using
  local variables with the generic routines.
- refactor routines when setting non-generic fields, to have both
  both sli3 and sli4 specific sections. This replaces the set-as-sli3
  then translate to sli4 behavior of the past.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 8d49e4b2ebfe..f1bb40fe8206 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -564,7 +564,6 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	struct bsg_job_data *dd_data;
 	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
-	IOCB_t *rsp;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_dmabuf *pcmd = NULL, *prsp = NULL;
 	struct fc_bsg_ctels_reply *els_reply;
@@ -572,6 +571,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	unsigned long flags;
 	unsigned int rsp_size;
 	int rc = 0;
+	u32 ulp_status, ulp_word4, total_data_placed;
 
 	dd_data = cmdiocbq->context1;
 	ndlp = dd_data->context_un.iocb.ndlp;
@@ -592,7 +592,9 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
-	rsp = &rspiocbq->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocbq);
+	ulp_word4 = get_job_word4(phba, rspiocbq);
+	total_data_placed = get_job_data_placed(phba, rspiocbq);
 	pcmd = (struct lpfc_dmabuf *)cmdiocbq->context2;
 	prsp = (struct lpfc_dmabuf *)pcmd->list.next;
 
@@ -601,24 +603,28 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	 */
 
 	if (job) {
-		if (rsp->ulpStatus == IOSTAT_SUCCESS) {
-			rsp_size = rsp->un.elsreq64.bdl.bdeSize;
+		if (ulp_status == IOSTAT_SUCCESS) {
+			rsp_size = total_data_placed;
 			bsg_reply->reply_payload_rcv_len =
 				sg_copy_from_buffer(job->reply_payload.sg_list,
 						    job->reply_payload.sg_cnt,
 						    prsp->virt,
 						    rsp_size);
-		} else if (rsp->ulpStatus == IOSTAT_LS_RJT) {
+		} else if (ulp_status == IOSTAT_LS_RJT) {
 			bsg_reply->reply_payload_rcv_len =
 				sizeof(struct fc_bsg_ctels_reply);
 			/* LS_RJT data returned in word 4 */
-			rjt_data = (uint8_t *)&rsp->un.ulpWord[4];
+			rjt_data = (uint8_t *)&ulp_word4;
 			els_reply = &bsg_reply->reply_data.ctels_reply;
 			els_reply->status = FC_CTELS_STATUS_REJECT;
 			els_reply->rjt_data.action = rjt_data[3];
 			els_reply->rjt_data.reason_code = rjt_data[2];
 			els_reply->rjt_data.reason_explanation = rjt_data[1];
 			els_reply->rjt_data.vendor_unique = rjt_data[0];
+		} else if (ulp_status == IOSTAT_LOCAL_REJECT &&
+			   (ulp_word4 & IOERR_PARAM_MASK) ==
+			   IOERR_SEQUENCE_TIMEOUT) {
+			rc = -ETIMEDOUT;
 		} else {
 			rc = -EIO;
 		}
@@ -695,7 +701,6 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	 * we won't be dma into memory that is no longer allocated to for the
 	 * request.
 	 */
-
 	cmdiocbq = lpfc_prep_els_iocb(vport, 1, cmdsize, 0, ndlp,
 				      ndlp->nlp_DID, elscmd);
 	if (!cmdiocbq) {
@@ -707,12 +712,13 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	sg_copy_to_buffer(job->request_payload.sg_list,
 			  job->request_payload.sg_cnt,
 			  ((struct lpfc_dmabuf *)cmdiocbq->context2)->virt,
-			  cmdsize);
+			  job->request_payload.payload_len);
 
 	rpi = ndlp->nlp_rpi;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
-		cmdiocbq->iocb.ulpContext = phba->sli4_hba.rpi_ids[rpi];
+		bf_set(wqe_ctxt_tag, &cmdiocbq->wqe.generic.wqe_com,
+		       phba->sli4_hba.rpi_ids[rpi]);
 	else
 		cmdiocbq->iocb.ulpContext = rpi;
 	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
@@ -1372,11 +1378,11 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	struct bsg_job_data *dd_data;
 	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
-	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp;
 	struct lpfc_nodelist *ndlp;
 	unsigned long flags;
 	int rc = 0;
+	u32 ulp_status, ulp_word4;
 
 	dd_data = cmdiocbq->context1;
 
@@ -1397,15 +1403,17 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	ndlp = dd_data->context_un.iocb.ndlp;
 	cmp = cmdiocbq->context2;
 	bmp = cmdiocbq->context3;
-	rsp = &rspiocbq->iocb;
+
+	ulp_status = get_job_ulpstatus(phba, rspiocbq);
+	ulp_word4 = get_job_word4(phba, rspiocbq);
 
 	/* Copy the completed job data or set the error status */
 
 	if (job) {
 		bsg_reply = job->reply;
-		if (rsp->ulpStatus) {
-			if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-				switch (rsp->un.ulpWord[4] & IOERR_PARAM_MASK) {
+		if (ulp_status) {
+			if (ulp_status == IOSTAT_LOCAL_REJECT) {
+				switch (ulp_word4 & IOERR_PARAM_MASK) {
 				case IOERR_SEQUENCE_TIMEOUT:
 					rc = -ETIMEDOUT;
 					break;
-- 
2.26.2

