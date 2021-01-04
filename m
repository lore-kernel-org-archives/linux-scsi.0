Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1C2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DC7207BC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbhADSEQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbhADSEQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:16 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418E3C0617A2
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id t8so16873896pfg.8
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bW6yScAM5NY4/2R9yPe9SMg4GozEMiKY4ikoNdeSsgY=;
        b=kt0aJ3W7H+N5BsZ1PTLsJ7n6f7Ybtrb0ohp+MPSnU1EjnJ5Hd+ugGfUA0YMlCps1aZ
         d2euGMX74ndciAbS2SsQHKZqIBY569B6aQu0lrcwiTZRkO6/XH75C4xjPxIaWo2zoGHj
         M9+hTykoyx76170mAv/8oN014L0pVXVfzlkJLKl7BUgjM5kN2/C8IztY5a0KBH2CG2sP
         q+eEmey5CERMLcDu3si7elWKWGBO3HM1cKE/B/u2LID+Ze8qTA4MubFGYptyK6qv+/j+
         NkSbuJsTT6ApUkJoRSRqzDcDXTulWjzXmVpfUyalfgoE+yEQgYHNwOvQwG6iLV/puwOM
         6bfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bW6yScAM5NY4/2R9yPe9SMg4GozEMiKY4ikoNdeSsgY=;
        b=Uyng7A3oczxS3T+D9bLJnMPnVhkQtmPRJx+a6qNlStmLfQ+VZS9N7UWf0kGt6/LbBK
         Vq4Zr3mNKnNJ0uQX+M7gh09RD4su8+y5M+j8MW0MdsbeY8r7TxdCGD6Bu4RfaRHP1X4n
         r1zd7q1hLPyJKS+pK5HBLhIjagPeZWWQyxOV7L4FoNQOTXMT1bdeAo7pPRQnPJHGwcZ6
         D4bZGpfW3TBecWxXj9ACCJljv4YFnyPeQuOhXY5HDLV64CPMCFPBqjpyzfjpZUd960gW
         /8GjFxFXKAltO09qgNT9xl956cHLI4VP1hnXV/7eSwiGS0lIZ4IyrgaCtZg6wWwdvZ3S
         InVw==
X-Gm-Message-State: AOAM532eIT01hCr7Tfo1W6oOcSPA9VRVFQ5cumxkMZFmS1wFoA4psc4x
        GojliWSFWcKQyQPHtpUwIC/27n7JD6g=
X-Google-Smtp-Source: ABdhPJxD8pL3k3sbWTe5YLAVrlmWD8uXYRAOKzUQSKfmYFCYmMzdiFdXZDQoln+UF0ezM+CNXkvFYQ==
X-Received: by 2002:a63:d814:: with SMTP id b20mr36721919pgh.202.1609783396663;
        Mon, 04 Jan 2021 10:03:16 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:16 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 10/15] lpfc: Fix NVME recovery after mailbox timeout
Date:   Mon,  4 Jan 2021 10:02:35 -0800
Message-Id: <20210104180240.46824-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a mailbox command times out, the SLI port is deemd in error and the
port is reset.  The hba cleanup is not returning I/O's to the NVMe layer
before the port is unregistered. This is due to the hba being marked
offline (!SLI_ACTIVE) and cleanup being done by the mailbox timeout
handler rather than an general adapter reset routine.  The mailbox timeout
handler mailbox handler only cleaned up scsi ios.

Fix by reworking the mailbox handler to:
- After handling the mailbox error, detect the board is already in
  failure (may be due to another error), and leave cleanup to the
  other handler.
- If the mailbox command timeout is initial detector of the port error,
  continue with the board cleanup and marking the adapter offline
  (!SLI_ACTIVE). Remove the scsi-only io cleanup routine. The generic
  reset adapter routine that is subsequently invoked, will clean up the
  ios.
- Have the reset adapter routine flush all nvme and scsi ios if the
  adapter has been marked failed (!SLI_ACTIVE).
- Rework the nvme io terminate routine to take a status code to fail
  the io with and update so that cleaned up io calls the wqe completion
  routine. Currently it is bypassing the wqe cleanup and calling the nvme
  io completion directly. The wqe completion routine will take care of
  data structure and node cleanup then call the nvme io completion
  handler.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  4 ++--
 drivers/scsi/lpfc/lpfc_init.c |  8 ++++++--
 drivers/scsi/lpfc/lpfc_nvme.c | 33 +++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_sli.c  | 20 ++++++++++++--------
 4 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f78e52a18b0b..e70db9ec7da4 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -255,7 +255,6 @@ void lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba,
 int lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 			       struct fc_frame_header *fc_hdr);
 void lpfc_nvmet_wqfull_process(struct lpfc_hba *phba, struct lpfc_queue *wq);
-void lpfc_sli_flush_nvme_rings(struct lpfc_hba *phba);
 void lpfc_nvme_wait_for_io_drain(struct lpfc_hba *phba);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
@@ -598,7 +597,8 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd,
 void lpfc_io_ktime(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd);
 void lpfc_wqe_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
-void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn);
+void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
+			   uint32_t stat, uint32_t param);
 extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index af926768bcae..c2619d56be12 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6191,10 +6191,14 @@ lpfc_reset_hba(struct lpfc_hba *phba)
 		phba->link_state = LPFC_HBA_ERROR;
 		return;
 	}
-	if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
+
+	/* If not LPFC_SLI_ACTIVE, force all IO to be flushed */
+	if (phba->sli.sli_flag & LPFC_SLI_ACTIVE) {
 		lpfc_offline_prep(phba, LPFC_MBX_WAIT);
-	else
+	} else {
 		lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
+		lpfc_sli_flush_io_rings(phba);
+	}
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);
 	lpfc_online(phba);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index fd4a1cf0e4a6..e72c4cd3a97a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2596,14 +2596,17 @@ lpfc_nvme_wait_for_io_drain(struct lpfc_hba *phba)
 }
 
 void
-lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn)
+lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
+		      uint32_t stat, uint32_t param)
 {
 #if (IS_ENABLED(CONFIG_NVME_FC))
 	struct lpfc_io_buf *lpfc_ncmd;
 	struct nvmefc_fcp_req *nCmd;
-	struct lpfc_nvme_fcpreq_priv *freqpriv;
+	struct lpfc_wcqe_complete wcqe;
+	struct lpfc_wcqe_complete *wcqep = &wcqe;
 
-	if (!pwqeIn->context1) {
+	lpfc_ncmd = (struct lpfc_io_buf *)pwqeIn->context1;
+	if (!lpfc_ncmd) {
 		lpfc_sli_release_iocbq(phba, pwqeIn);
 		return;
 	}
@@ -2613,31 +2616,29 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn)
 		lpfc_sli_release_iocbq(phba, pwqeIn);
 		return;
 	}
-	lpfc_ncmd = (struct lpfc_io_buf *)pwqeIn->context1;
 
 	spin_lock(&lpfc_ncmd->buf_lock);
-	if (!lpfc_ncmd->nvmeCmd) {
+	nCmd = lpfc_ncmd->nvmeCmd;
+	if (!nCmd) {
 		spin_unlock(&lpfc_ncmd->buf_lock);
 		lpfc_release_nvme_buf(phba, lpfc_ncmd);
 		return;
 	}
+	spin_unlock(&lpfc_ncmd->buf_lock);
 
-	nCmd = lpfc_ncmd->nvmeCmd;
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_IOERR,
 			"6194 NVME Cancel xri %x\n",
 			lpfc_ncmd->cur_iocbq.sli4_xritag);
 
-	nCmd->transferred_length = 0;
-	nCmd->rcv_rsplen = 0;
-	nCmd->status = NVME_SC_INTERNAL;
-	freqpriv = nCmd->private;
-	freqpriv->nvme_buf = NULL;
-	lpfc_ncmd->nvmeCmd = NULL;
-
-	spin_unlock(&lpfc_ncmd->buf_lock);
-	nCmd->done(nCmd);
+	wcqep->word0 = 0;
+	bf_set(lpfc_wcqe_c_status, wcqep, stat);
+	wcqep->parameter = param;
+	wcqep->word3 = 0; /* xb is 0 */
 
 	/* Call release with XB=1 to queue the IO into the abort list. */
-	lpfc_release_nvme_buf(phba, lpfc_ncmd);
+	if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
+		bf_set(lpfc_wcqe_c_xb, wcqep, 1);
+
+	(pwqeIn->wqe_cmpl)(phba, pwqeIn, wcqep);
 #endif
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 735fa1d484eb..dedea5de7d78 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1532,15 +1532,19 @@ lpfc_sli_cancel_iocbs(struct lpfc_hba *phba, struct list_head *iocblist,
 
 	while (!list_empty(iocblist)) {
 		list_remove_head(iocblist, piocb, struct lpfc_iocbq, list);
-		if (!piocb->iocb_cmpl) {
+		if (piocb->wqe_cmpl) {
 			if (piocb->iocb_flag & LPFC_IO_NVME)
-				lpfc_nvme_cancel_iocb(phba, piocb);
+				lpfc_nvme_cancel_iocb(phba, piocb,
+						      ulpstatus, ulpWord4);
 			else
 				lpfc_sli_release_iocbq(phba, piocb);
-		} else {
+
+		} else if (piocb->iocb_cmpl) {
 			piocb->iocb.ulpStatus = ulpstatus;
 			piocb->iocb.un.ulpWord[4] = ulpWord4;
 			(piocb->iocb_cmpl) (phba, piocb, piocb);
+		} else {
+			lpfc_sli_release_iocbq(phba, piocb);
 		}
 	}
 	return;
@@ -8269,8 +8273,10 @@ lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 
 	struct lpfc_sli *psli = &phba->sli;
 
-	/* If the mailbox completed, process the completion and return */
-	if (lpfc_sli4_process_missed_mbox_completions(phba))
+	/* If the mailbox completed, process the completion */
+	lpfc_sli4_process_missed_mbox_completions(phba);
+
+	if (!(psli->sli_flag & LPFC_SLI_ACTIVE))
 		return;
 
 	if (pmbox != NULL)
@@ -8311,8 +8317,6 @@ lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
-	lpfc_sli_abort_fcp_rings(phba);
-
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"0345 Resetting board due to mailbox timeout\n");
 
@@ -11783,7 +11787,7 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 	struct lpfc_io_buf *lpfc_cmd;
 	int rc = 1;
 
-	if (iocbq->vport != vport)
+	if (!iocbq || iocbq->vport != vport)
 		return rc;
 
 	if (!(iocbq->iocb_flag &  LPFC_IO_FCP) ||
-- 
2.26.2

