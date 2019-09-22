Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FD7C4740C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A67A20B7C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0xePn7o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfIVD72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:28 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39153 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfIVD71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:27 -0400
Received: by mail-ot1-f67.google.com with SMTP id s22so9403850otr.6
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BKepWG1TifCcSv/9ZE3y9Mcnwboi1o+mrkXYo5hCMOU=;
        b=i0xePn7oJCybup2FUJJ9xYU6gIhgRWo75jl3if+0uVwU5RxzdVB6M3OazuLCiQn2NG
         Nl0/ENStTLyPIYB4E/aR9dh57IJ3GzWksGwd7+Qs47aphOI3YQjuU8AxBGDwewmMXJg8
         sB/fL6Lwhwm+o6ZigtqLFFrsbtciG55nEt1/MxQF2m/1uGBIEoX+zUmC+nIiceY5T1st
         P50o4zt49Wfb8hFf22UMPsagDTQ0+Wye4GnQtakGS9a9sVCnIbsWWKlM5RsF1rheIUIZ
         tGuybw5C1tAQHEwU5+uGAJRA5uBKQei1tHKkHYE2ShzqOrr5sT0gE6ET+wZBYaYhDLKe
         p+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BKepWG1TifCcSv/9ZE3y9Mcnwboi1o+mrkXYo5hCMOU=;
        b=hTi8KJ9FKX42UsdiRkFc4espY8SAI6usEqTu8JQqxFI81CeFAAlKju216gk5v4pBc2
         ovrVdgGY6YIz/+nqLze7W2JvlL6XsBvbakLgCdwk0Z79OETFxFD7TJOOGd+7aDbUpzvt
         PKM+TgiSOO/RMCcZtf83d3j7t0PRNGzA3ZjjccKNokWIUv1SDmLIhYrnw7ZrzTVSfw7Y
         g9gDddJL5nZhOqB1LfxB45ZIOE/b2k8iznA7Vs4DAHJ1j1M9jycMcLgueouwNV/ViTiU
         PJaD4yGy3bDCgte8cR7yI4gNlXJRSthSPcLPHuTlUYpbSNx5DZwIvAJWCbw1oaI8jtQ5
         0V/g==
X-Gm-Message-State: APjAAAXdY88EmQv0FFp0r3/ttCxZVUuyPYx1j4bprGRfoiQR7K4NPUYf
        kcj/4gCHk/ezw3Jbg4TpIFd/O/3l
X-Google-Smtp-Source: APXvYqzEf0GuHOnuA6zsmgSs0SjwEmKQjglBdLyt2Z7EMh8MZUUf48wOxqsEhiey7Vfpr3J2nYTWbQ==
X-Received: by 2002:a9d:6d82:: with SMTP id x2mr13529501otp.42.1569124766521;
        Sat, 21 Sep 2019 20:59:26 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/20] lpfc: Fix NVMe ABTS in response to receiving an ABTS
Date:   Sat, 21 Sep 2019 20:58:56 -0700
Message-Id: <20190922035906.10977-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the port, running as a nvme target, receives an ABTS, it
submits commands to the adapter to Abort i/o outstanding in the
adapter. The Abort command formatting routine left a command
field set to zero, which instructs the adapter to generate
an ABTS on the wire as part of cleaning up the I/O. This is
common operation for an initiator, but not for a target.

Fix the driver to check whether an ABTS had been received for
the I/O, and if so, change the Abort command formatting so that
the ABTS generation is disabled (IA=1). No need to ABTS it when
the other side already has.

Also refactored the code such that there is a single routine
being used for nvme or nvmet ABORT requests, and IA is an
argument.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h  |  1 +
 drivers/scsi/lpfc/lpfc_hw4.h   |  1 +
 drivers/scsi/lpfc/lpfc_nvme.c  | 73 ++++++++++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_nvmet.c | 34 ++------------------
 4 files changed, 46 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b2ad8c750486..6e09fd98a922 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -586,6 +586,7 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd,
 void lpfc_nvme_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
 void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn);
+void lpfc_nvme_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt);
 extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index bd533475c86a..f70fb7629c82 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4659,6 +4659,7 @@ struct create_xri_wqe {
 	uint32_t rsvd_12_15[4];         /* word 12-15 */
 };
 
+#define INHIBIT_ABORT 1
 #define T_REQUEST_TAG 3
 #define T_XRI_TAG 1
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index a227e36cbdc2..5af944b97c4c 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -196,6 +196,46 @@ lpfc_nvme_cmd_template(void)
 }
 
 /**
+ * lpfc_nvme_prep_abort_wqe - set up 'abort' work queue entry.
+ * @pwqeq: Pointer to command iocb.
+ * @xritag: Tag that  uniqely identifies the local exchange resource.
+ * @opt: Option bits -
+ *		bit 0 = inhibit sending abts on the link
+ *
+ * This function is called with hbalock held.
+ **/
+void
+lpfc_nvme_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt)
+{
+	union lpfc_wqe128 *wqe = &pwqeq->wqe;
+
+	/* WQEs are reused.  Clear stale data and set key fields to
+	 * zero like ia, iaab, iaar, xri_tag, and ctxt_tag.
+	 */
+	memset(wqe, 0, sizeof(*wqe));
+
+	if (opt & INHIBIT_ABORT)
+		bf_set(abort_cmd_ia, &wqe->abort_cmd, 1);
+	/* Abort specified xri tag, with the mask deliberately zeroed */
+	bf_set(abort_cmd_criteria, &wqe->abort_cmd, T_XRI_TAG);
+
+	bf_set(wqe_cmnd, &wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
+
+	/* Abort the IO associated with this outstanding exchange ID. */
+	wqe->abort_cmd.wqe_com.abort_tag = xritag;
+
+	/* iotag for the wqe completion. */
+	bf_set(wqe_reqtag, &wqe->abort_cmd.wqe_com, pwqeq->iotag);
+
+	bf_set(wqe_qosd, &wqe->abort_cmd.wqe_com, 1);
+	bf_set(wqe_lenloc, &wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
+
+	bf_set(wqe_cmd_type, &wqe->abort_cmd.wqe_com, OTHER_COMMAND);
+	bf_set(wqe_wqec, &wqe->abort_cmd.wqe_com, 1);
+	bf_set(wqe_cqid, &wqe->abort_cmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+}
+
+/**
  * lpfc_nvme_create_queue -
  * @lpfc_pnvme: Pointer to the driver's nvme instance data
  * @qidx: An cpu index used to affinitize IO queues and MSIX vectors.
@@ -1791,7 +1831,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_iocbq *abts_buf;
 	struct lpfc_iocbq *nvmereq_wqe;
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
-	union lpfc_wqe128 *abts_wqe;
 	unsigned long flags;
 	int ret_val;
 
@@ -1912,37 +1951,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	/* Ready - mark outstanding as aborted by driver. */
 	nvmereq_wqe->iocb_flag |= LPFC_DRIVER_ABORTED;
 
-	/* Complete prepping the abort wqe and issue to the FW. */
-	abts_wqe = &abts_buf->wqe;
-
-	/* WQEs are reused.  Clear stale data and set key fields to
-	 * zero like ia, iaab, iaar, xri_tag, and ctxt_tag.
-	 */
-	memset(abts_wqe, 0, sizeof(*abts_wqe));
-	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
-
-	/* word 7 */
-	bf_set(wqe_cmnd, &abts_wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
-	bf_set(wqe_class, &abts_wqe->abort_cmd.wqe_com,
-	       nvmereq_wqe->iocb.ulpClass);
-
-	/* word 8 - tell the FW to abort the IO associated with this
-	 * outstanding exchange ID.
-	 */
-	abts_wqe->abort_cmd.wqe_com.abort_tag = nvmereq_wqe->sli4_xritag;
-
-	/* word 9 - this is the iotag for the abts_wqe completion. */
-	bf_set(wqe_reqtag, &abts_wqe->abort_cmd.wqe_com,
-	       abts_buf->iotag);
-
-	/* word 10 */
-	bf_set(wqe_qosd, &abts_wqe->abort_cmd.wqe_com, 1);
-	bf_set(wqe_lenloc, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
-
-	/* word 11 */
-	bf_set(wqe_cmd_type, &abts_wqe->abort_cmd.wqe_com, OTHER_COMMAND);
-	bf_set(wqe_wqec, &abts_wqe->abort_cmd.wqe_com, 1);
-	bf_set(wqe_cqid, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+	lpfc_nvme_prep_abort_wqe(abts_buf, nvmereq_wqe->sli4_xritag, 0);
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abts_buf->iocb_flag |= LPFC_IO_NVME;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 9884228800a5..121dbdcbb583 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3239,9 +3239,9 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 {
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct lpfc_iocbq *abts_wqeq;
-	union lpfc_wqe128 *abts_wqe;
 	struct lpfc_nodelist *ndlp;
 	unsigned long flags;
+	u8 opt;
 	int rc;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
@@ -3280,8 +3280,8 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 		return 0;
 	}
 	abts_wqeq = ctxp->abort_wqeq;
-	abts_wqe = &abts_wqeq->wqe;
 	ctxp->state = LPFC_NVMET_STE_ABORT;
+	opt = (ctxp->flag & LPFC_NVMET_ABTS_RCV) ? INHIBIT_ABORT : 0;
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 
 	/* Announce entry to new IO submit field. */
@@ -3327,35 +3327,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	/* Ready - mark outstanding as aborted by driver. */
 	abts_wqeq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
-	/* WQEs are reused.  Clear stale data and set key fields to
-	 * zero like ia, iaab, iaar, xri_tag, and ctxt_tag.
-	 */
-	memset(abts_wqe, 0, sizeof(*abts_wqe));
-
-	/* word 3 */
-	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
-
-	/* word 7 */
-	bf_set(wqe_ct, &abts_wqe->abort_cmd.wqe_com, 0);
-	bf_set(wqe_cmnd, &abts_wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
-
-	/* word 8 - tell the FW to abort the IO associated with this
-	 * outstanding exchange ID.
-	 */
-	abts_wqe->abort_cmd.wqe_com.abort_tag = ctxp->wqeq->sli4_xritag;
-
-	/* word 9 - this is the iotag for the abts_wqe completion. */
-	bf_set(wqe_reqtag, &abts_wqe->abort_cmd.wqe_com,
-	       abts_wqeq->iotag);
-
-	/* word 10 */
-	bf_set(wqe_qosd, &abts_wqe->abort_cmd.wqe_com, 1);
-	bf_set(wqe_lenloc, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
-
-	/* word 11 */
-	bf_set(wqe_cmd_type, &abts_wqe->abort_cmd.wqe_com, OTHER_COMMAND);
-	bf_set(wqe_wqec, &abts_wqe->abort_cmd.wqe_com, 1);
-	bf_set(wqe_cqid, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+	lpfc_nvme_prep_abort_wqe(abts_wqeq, ctxp->wqeq->sli4_xritag, opt);
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abts_wqeq->hba_wqidx = ctxp->wqeq->hba_wqidx;
-- 
2.13.7

