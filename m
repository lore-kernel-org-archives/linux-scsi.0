Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A28DC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiGAVPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiGAVPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:13 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727623DA7E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:12 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id b24so2731201qkn.4
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BAEN1wMf84UyFQgfzP7MAN43HLkGrvEb9+8MzIrRQ+Q=;
        b=gTEMPZzoRMllzAREtbFn5NdQ8KtsG7xHwGotVUUOX1cPu2kuksVgrGzrGhM6Fq7mzU
         D8KYf185zYooiiHAORSt0gg+NBRnu2QDOtadg+Xe55VEuxx3Qo5i4VTvoLAO+YP206b+
         QS9YTKKn5A5A+jetnSjXE8/OImG+gFTiiuNwDngNYV7Ej800MI3WpNi5mhK8bXsk9b3d
         PFIhi841JUL+6pUACtkxhzWt+OOd8BFdYCyBswitnqMnAhuGsSk1s31ycYpygguoLPre
         fo5kGhP7FapnBUBn/dLtfVRBsb51vT8UAjpI67dKJ+aLJgQJDs2DIBcVMXu8gguzmGTW
         k4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BAEN1wMf84UyFQgfzP7MAN43HLkGrvEb9+8MzIrRQ+Q=;
        b=xgAR0gGYxCRag0TqRgM/kH9fKnKQYtukU1a/400v0khD8gvXv456wlV7ujMK8Mr4sA
         nZxhnsvaLKF6HIaTRVYliQLS2DoEoETQuhSeIHLa5LP0rUqtFh9yUqDf5ZvYwjWAtsxF
         nb4PjSe6+YZU3Q7+YgESkm4AhXtOgz4GuUpKjvdB0PS/bQqbZj/gnZj7XweicQbkLDXk
         uOM9j6S0pzI5S+ZhHjxB5iSBK5/2uknJIgc15EYdCF2sHMsJKjENKcbQc8h9xcaNhSVc
         2Yr8iNd+bJSHgtsdCV4LgHb5EhZJjcoQxJKkTaJSksTGankYmQcU/+Dm6BKStutQviea
         dz+w==
X-Gm-Message-State: AJIora/UnQAfpbIdit84e3z0eghCHIklPy0dSp266US8+Ud1G4v0WtYg
        xTMgXSss3a1IiCSsSl2oLWzNkx5bwZ0=
X-Google-Smtp-Source: AGRyM1vMrIGHNLBM0DubJ6EyuyGnKcMmUnjRkiYl8RI5HFIvYUoSZqtFP88VnACn/+yh50PNCPjG2g==
X-Received: by 2002:a05:620a:410d:b0:6a7:571d:8615 with SMTP id j13-20020a05620a410d00b006a7571d8615mr12231251qko.259.1656710111378;
        Fri, 01 Jul 2022 14:15:11 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/12] lpfc: Refactor lpfc_nvmet_prep_abort_wqe into lpfc_sli_prep_abort_xri
Date:   Fri,  1 Jul 2022 14:14:22 -0700
Message-Id: <20220701211425.2708-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_nvmet_prep_abort_wqe has a lot of common code with
lpfc_sli_prep_abort_xri.

Delete lpfc_nvmet_prep_abort_wqe as the wqe can be filled out using the
generic lpfc_sli_prep_abort_xri routine.

Add the wqec option to lpfc_sli_prep_abort_xri for
lpfc_nvmet_prep_abort_wqe.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h       |  3 ++-
 drivers/scsi/lpfc/lpfc_crtn.h  |  2 +-
 drivers/scsi/lpfc/lpfc_hw4.h   |  1 -
 drivers/scsi/lpfc/lpfc_nvmet.c | 48 ++++------------------------------
 drivers/scsi/lpfc/lpfc_sli.c   | 16 +++++++-----
 5 files changed, 18 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 212f9b962187..cf4ccc54a7f2 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -986,7 +986,8 @@ struct lpfc_hba {
 					   u8 last_seq, u8 cr_cx_cmd);
 	void (*__lpfc_sli_prep_abort_xri)(struct lpfc_iocbq *cmdiocbq,
 					  u16 ulp_context, u16 iotag,
-					  u8 ulp_class, u16 cqid, bool ia);
+					  u8 ulp_class, u16 cqid, bool ia,
+					  bool wqec);
 
 	/* expedite pool */
 	struct lpfc_epd_pool epd_pool;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f5d74958b664..bcad91204328 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -370,7 +370,7 @@ void lpfc_sli_prep_xmit_seq64(struct lpfc_hba *phba,
 			      u8 cr_cx_cmd);
 void lpfc_sli_prep_abort_xri(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocbq,
 			     u16 ulp_context, u16 iotag, u8 ulp_class, u16 cqid,
-			     bool ia);
+			     bool ia, bool wqec);
 struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xri);
 struct lpfc_sglq *__lpfc_sli_get_nvmet_sglq(struct lpfc_hba *phba,
 					    struct lpfc_iocbq *piocbq);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index f024415731ac..4527fef23ae7 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4736,7 +4736,6 @@ struct create_xri_wqe {
 	uint32_t rsvd_12_15[4];         /* word 12-15 */
 };
 
-#define INHIBIT_ABORT 1
 #define T_REQUEST_TAG 3
 #define T_XRI_TAG 1
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c3cb7e8a2a7c..f7cfac0da9b6 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3335,46 +3335,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	return 1;
 }
 
-/**
- * lpfc_nvmet_prep_abort_wqe - set up 'abort' work queue entry.
- * @pwqeq: Pointer to command iocb.
- * @xritag: Tag that  uniqely identifies the local exchange resource.
- * @opt: Option bits -
- *		bit 0 = inhibit sending abts on the link
- *
- * This function is called with hbalock held.
- **/
-static void
-lpfc_nvmet_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt)
-{
-	union lpfc_wqe128 *wqe = &pwqeq->wqe;
-
-	/* WQEs are reused.  Clear stale data and set key fields to
-	 * zero like ia, iaab, iaar, xri_tag, and ctxt_tag.
-	 */
-	memset(wqe, 0, sizeof(*wqe));
-
-	if (opt & INHIBIT_ABORT)
-		bf_set(abort_cmd_ia, &wqe->abort_cmd, 1);
-	/* Abort specified xri tag, with the mask deliberately zeroed */
-	bf_set(abort_cmd_criteria, &wqe->abort_cmd, T_XRI_TAG);
-
-	bf_set(wqe_cmnd, &wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
-
-	/* Abort the I/O associated with this outstanding exchange ID. */
-	wqe->abort_cmd.wqe_com.abort_tag = xritag;
-
-	/* iotag for the wqe completion. */
-	bf_set(wqe_reqtag, &wqe->abort_cmd.wqe_com, pwqeq->iotag);
-
-	bf_set(wqe_qosd, &wqe->abort_cmd.wqe_com, 1);
-	bf_set(wqe_lenloc, &wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
-
-	bf_set(wqe_cmd_type, &wqe->abort_cmd.wqe_com, OTHER_COMMAND);
-	bf_set(wqe_wqec, &wqe->abort_cmd.wqe_com, 1);
-	bf_set(wqe_cqid, &wqe->abort_cmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-}
-
 static int
 lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 			       struct lpfc_async_xchg_ctx *ctxp,
@@ -3384,7 +3344,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	struct lpfc_iocbq *abts_wqeq;
 	struct lpfc_nodelist *ndlp;
 	unsigned long flags;
-	u8 opt;
+	bool ia;
 	int rc;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
@@ -3424,7 +3384,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	}
 	abts_wqeq = ctxp->abort_wqeq;
 	ctxp->state = LPFC_NVME_STE_ABORT;
-	opt = (ctxp->flag & LPFC_NVME_ABTS_RCV) ? INHIBIT_ABORT : 0;
+	ia = (ctxp->flag & LPFC_NVME_ABTS_RCV) ? true : false;
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 
 	/* Announce entry to new IO submit field. */
@@ -3470,7 +3430,9 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	/* Ready - mark outstanding as aborted by driver. */
 	abts_wqeq->cmd_flag |= LPFC_DRIVER_ABORTED;
 
-	lpfc_nvmet_prep_abort_wqe(abts_wqeq, ctxp->wqeq->sli4_xritag, opt);
+	lpfc_sli_prep_abort_xri(phba, abts_wqeq, ctxp->wqeq->sli4_xritag,
+				abts_wqeq->iotag, CLASS3,
+				LPFC_WQE_CQ_ID_DEFAULT, ia, true);
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abts_wqeq->hba_wqidx = ctxp->wqeq->hba_wqidx;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 71442faaa6c2..3aa9e5c85aa5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10863,7 +10863,8 @@ lpfc_sli_prep_xmit_seq64(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocbq,
 
 static void
 __lpfc_sli_prep_abort_xri_s3(struct lpfc_iocbq *cmdiocbq, u16 ulp_context,
-			     u16 iotag, u8 ulp_class, u16 cqid, bool ia)
+			     u16 iotag, u8 ulp_class, u16 cqid, bool ia,
+			     bool wqec)
 {
 	IOCB_t *icmd = NULL;
 
@@ -10892,7 +10893,8 @@ __lpfc_sli_prep_abort_xri_s3(struct lpfc_iocbq *cmdiocbq, u16 ulp_context,
 
 static void
 __lpfc_sli_prep_abort_xri_s4(struct lpfc_iocbq *cmdiocbq, u16 ulp_context,
-			     u16 iotag, u8 ulp_class, u16 cqid, bool ia)
+			     u16 iotag, u8 ulp_class, u16 cqid, bool ia,
+			     bool wqec)
 {
 	union lpfc_wqe128 *wqe;
 
@@ -10919,6 +10921,8 @@ __lpfc_sli_prep_abort_xri_s4(struct lpfc_iocbq *cmdiocbq, u16 ulp_context,
 	bf_set(wqe_qosd, &wqe->abort_cmd.wqe_com, 1);
 
 	/* Word 11 */
+	if (wqec)
+		bf_set(wqe_wqec, &wqe->abort_cmd.wqe_com, 1);
 	bf_set(wqe_cqid, &wqe->abort_cmd.wqe_com, cqid);
 	bf_set(wqe_cmd_type, &wqe->abort_cmd.wqe_com, OTHER_COMMAND);
 }
@@ -10926,10 +10930,10 @@ __lpfc_sli_prep_abort_xri_s4(struct lpfc_iocbq *cmdiocbq, u16 ulp_context,
 void
 lpfc_sli_prep_abort_xri(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocbq,
 			u16 ulp_context, u16 iotag, u8 ulp_class, u16 cqid,
-			bool ia)
+			bool ia, bool wqec)
 {
 	phba->__lpfc_sli_prep_abort_xri(cmdiocbq, ulp_context, iotag, ulp_class,
-					cqid, ia);
+					cqid, ia, wqec);
 }
 
 /**
@@ -12207,7 +12211,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	lpfc_sli_prep_abort_xri(phba, abtsiocbp, ulp_context, iotag,
 				cmdiocb->iocb.ulpClass,
-				LPFC_WQE_CQ_ID_DEFAULT, ia);
+				LPFC_WQE_CQ_ID_DEFAULT, ia, false);
 
 	abtsiocbp->vport = vport;
 
@@ -12667,7 +12671,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 
 		lpfc_sli_prep_abort_xri(phba, abtsiocbq, ulp_context, iotag,
 					iocbq->iocb.ulpClass, cqid,
-					ia);
+					ia, false);
 
 		abtsiocbq->vport = vport;
 
-- 
2.26.2

