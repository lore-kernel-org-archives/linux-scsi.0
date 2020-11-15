Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E01C64E8A
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 288D622314
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="M7i82xSV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKOT1S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgKOT1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:16 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB3AC0613D1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:16 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id b63so7731702pfg.12
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=GvBXAQnElsvErMu/rai11Ebn8wbvn3a9fjf0GfDzg0k=;
        b=M7i82xSVdQT2cvciMfabJj2x42L3KAOoNynSf2hECMT9royG/TbsjPU2dQUh7XO8bb
         9kS5B7032rpL9UftnE+lykP3e73Q9hPGYCM7vFP5Hb6EYIJ92ezVW2CVGP2R9QH4c40K
         i/Nf1Jh9xRiFd3Eez4G/K4bLzTMA/3nr6u+L4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=GvBXAQnElsvErMu/rai11Ebn8wbvn3a9fjf0GfDzg0k=;
        b=fFXGygIy7Oo9GPnzdguhsExyMIY7WGMnASzgdZFRtYlys1vbheFNCk3R8GhT807zlS
         gEoH2Eztz+X54M+5ZK2a7nB0U4fepKLg7zt/4mLbHRgr9vFr11GG2goEI+CbUks+p4B3
         gcMm90TWFDuJkDdetnJ/zCZbD50J1QyOe3lEWchm+7pDHQZmuHdwiJRar4o2oP/yMuL9
         tIf68KzPfdRcp+cIGZLZdwf9xbYjnj+cfaF0cK1TYbSpxDxzRKqdy7JFvIq5Wg83dcZx
         mic31EP/teBb92JwofVUnNVNNG291vyP4sOYi7P0JsTPFOVMrhs6yLmYFMn9YjwxdwjI
         q65w==
X-Gm-Message-State: AOAM533eO24kwG/4diBdbsB6msujxbFRa5IaOq8SZck8+yHP9cBAcg15
        QlcnS9J1kUMrO+eIPJ9jZH9RbQeWf5+/OrqvDkOjBlD9a+LCljieVuTtGLOlhH3VcvAVjiEwSi1
        N1q4OJUgm5U/YDPsN1lYUO9Jci+ujpQzEGQzvCO0wABs+NdsspG2DcZqjyPKNDwqgaH0cXmAf3V
        xJzjg=
X-Google-Smtp-Source: ABdhPJwQbaKcYLB3GV1PNzCp1o/TDsBsN2B6e6gipu8RCrqzl5o3yBbkS8IZvUSG6pPbZN6intTugQ==
X-Received: by 2002:a65:52cc:: with SMTP id z12mr10164580pgp.24.1605468434931;
        Sun, 15 Nov 2020 11:27:14 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:14 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 15/17] lpfc: Convert abort handling to sli-3 and sli-4 handlers
Date:   Sun, 15 Nov 2020 11:26:44 -0800
Message-Id: <20201115192646.12977-16-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d1c4a605b42a3f0a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d1c4a605b42a3f0a
Content-Transfer-Encoding: 8bit

This patch reworks the abort interfaces such that SLI-3 retains the
iocb-based formatting and completions and SLI-4 now uses native WQEs
and completion routines.

The following changes are made:
- The code is refactored from a confusing 2 routine sequence of
  xx_abort_iotag_issue(), which creates/formats and abort cmd, and
  xx_issue_abort_tag(), which then issues and handles the completion
  of the abort cmd - into a single interface of xx_issue_abort_iotag().
  The new interface will determine whether sli-3 or sli-4 and then call
  the appropriate handler. A completion handler can now be specified to
  address the differences in completion handling.
  note: original code is all iocb based, with sli-4 converting to sli-3
  for the scsi/els path, and nvme natively using wqes.
- The sli-3 side is refactored:
   The older iocb-base lpfc_sli_issue_abort_iotag() routine is combined
   with the logic of lpfc_sli_abort_iotag_issue() as well as the
   iocb-specific code in lpfc_abort_handler() and lpfc_sli_abort_iocb()
   to create the new single sli-3 abort routine that formats and issues
   the iocb.
- The sli-4 side is refactored and added to:
   The native WQE abort code in nvme is moved to the new sli-4
   issue_abort_iotag() routine. Items in scsi that set fields not
   set by nvme is migrated into the new routine. Thus the routine supports
   nvme and scsi initiators. The nvmet block (target) formats the abort
   slightly different (like the old nvme initiator) thus it has its own
   prep routine stolen from nvme initiator and it retains the current
   code it has for issuing the wqe (does not use the commonized routine
   the initiators do). sli-4 completion handlers were also added.
- lpfc_abort_handler now becomes a wrapper that determines whether
  SLI-3 or SLI-4 and calls the proper abort handler.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |   4 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   7 +-
 drivers/scsi/lpfc/lpfc_els.c       |   7 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  72 +------
 drivers/scsi/lpfc/lpfc_nvmet.c     |  42 +++-
 drivers/scsi/lpfc/lpfc_scsi.c      |  62 +-----
 drivers/scsi/lpfc/lpfc_sli.c       | 329 ++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.h       |   5 +
 10 files changed, 253 insertions(+), 279 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index e2f87a0d5c4f..8fb84415893d 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5927,7 +5927,7 @@ lpfc_bsg_timeout(struct bsg_job *job)
 			}
 		}
 		if (list_empty(&completions))
-			lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb);
+			lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb, NULL);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		if (!list_empty(&completions)) {
 			lpfc_sli_cancel_iocbs(phba, &completions,
@@ -5964,7 +5964,7 @@ lpfc_bsg_timeout(struct bsg_job *job)
 			}
 		}
 		if (list_empty(&completions))
-			lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb);
+			lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb, NULL);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		if (!list_empty(&completions)) {
 			lpfc_sli_cancel_iocbs(phba, &completions,
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 2b1540c0c82e..69b1a357007b 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -324,6 +324,8 @@ int lpfc_sli_issue_fcp_io(struct lpfc_hba *phba, uint32_t ring_number,
 			  struct lpfc_iocbq *piocb, uint32_t flag);
 int lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 			struct lpfc_iocbq *pwqe);
+int lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba,
+			struct lpfc_iocbq *cmdiocb, void *cmpl);
 struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xri);
 struct lpfc_sglq *__lpfc_sli_get_nvmet_sglq(struct lpfc_hba *phba,
 					    struct lpfc_iocbq *piocbq);
@@ -348,7 +350,7 @@ int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
 int lpfc_sli_hbq_size(void);
 int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
-			       struct lpfc_iocbq *);
+			       struct lpfc_iocbq *, void *);
 int lpfc_sli_sum_iocb(struct lpfc_vport *, uint16_t, uint64_t, lpfc_ctx_cmd);
 int lpfc_sli_abort_iocb(struct lpfc_vport *, struct lpfc_sli_ring *, uint16_t,
 			uint64_t, lpfc_ctx_cmd);
@@ -371,6 +373,8 @@ int lpfc_sli_issue_iocb_wait(struct lpfc_hba *, uint32_t,
 			     uint32_t);
 void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *, struct lpfc_iocbq *,
 			     struct lpfc_iocbq *);
+void lpfc_sli4_abort_fcp_cmpl(struct lpfc_hba *h, struct lpfc_iocbq *i,
+			      struct lpfc_wcqe_complete *w);
 
 void lpfc_sli_free_hbq(struct lpfc_hba *, struct hbq_dmabuf *);
 
@@ -595,7 +599,6 @@ void lpfc_io_ktime(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd);
 void lpfc_wqe_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
 void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn);
-void lpfc_nvme_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt);
 extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 48095bebd47b..35cac231f871 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1424,7 +1424,8 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 		if (icmd->ulpCommand == CMD_ELS_REQUEST64_CR) {
 			ndlp = (struct lpfc_nodelist *)(iocb->context1);
 			if (ndlp && (ndlp->nlp_DID == Fabric_DID))
-				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+							   NULL);
 		}
 	}
 	spin_unlock_irq(&phba->hbalock);
@@ -8135,7 +8136,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 			 remote_ID, cmd->ulpCommand, cmd->ulpIoTag);
 		spin_lock_irq(&phba->hbalock);
 		list_del_init(&piocb->dlist);
-		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
+		lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
 		spin_unlock_irq(&phba->hbalock);
 	}
 
@@ -8235,7 +8236,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		list_del_init(&piocb->dlist);
-		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
+		lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 	if (!list_empty(&abort_list))
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4c5a0ffec86f..6e6d9a57b9be 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5610,7 +5610,7 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 		icmd = &iocb->iocb;
 		if (icmd->ulpCommand == CMD_ELS_REQUEST64_CR ||
 		    icmd->ulpCommand == CMD_XMIT_ELS_RSP64_CX) {
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 		}
 	}
 	spin_unlock_irq(&phba->hbalock);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 1eddb40f009c..297fc92d01ce 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -247,7 +247,7 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	list_for_each_entry_safe(iocb, next_iocb, &abort_list, dlist) {
 			spin_lock_irq(&phba->hbalock);
 			list_del_init(&iocb->dlist);
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 			spin_unlock_irq(&phba->hbalock);
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5458b8ef949f..a821f36f66e6 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -62,46 +62,6 @@ lpfc_release_nvme_buf(struct lpfc_hba *, struct lpfc_io_buf *);
 
 static struct nvme_fc_port_template lpfc_nvme_template;
 
-/**
- * lpfc_nvme_prep_abort_wqe - set up 'abort' work queue entry.
- * @pwqeq: Pointer to command iocb.
- * @xritag: Tag that  uniqely identifies the local exchange resource.
- * @opt: Option bits -
- *		bit 0 = inhibit sending abts on the link
- *
- * This function is called with hbalock held.
- **/
-void
-lpfc_nvme_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt)
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
-	/* Abort the IO associated with this outstanding exchange ID. */
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
 /**
  * lpfc_nvme_create_queue -
  * @pnvme_lport: Transport localport that LS is to be issued from
@@ -767,7 +727,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	spin_unlock(&pring->ring_lock);
 
 	if (foundit)
-		lpfc_sli_issue_abort_iotag(phba, pring, wqe);
+		lpfc_sli_issue_abort_iotag(phba, pring, wqe, NULL);
 	spin_unlock_irq(&phba->hbalock);
 
 	if (foundit)
@@ -1778,7 +1738,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
 	struct lpfc_io_buf *lpfc_nbuf;
-	struct lpfc_iocbq *abts_buf;
 	struct lpfc_iocbq *nvmereq_wqe;
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	unsigned long flags;
@@ -1889,42 +1848,23 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		goto out_unlock;
 	}
 
-	abts_buf = __lpfc_sli_get_iocbq(phba);
-	if (!abts_buf) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "6136 No available abort wqes. Skipping "
-				 "Abts req for nvme_fcreq x%px xri x%x\n",
-				 pnvme_fcreq, nvmereq_wqe->sli4_xritag);
-		goto out_unlock;
-	}
-
-	/* Ready - mark outstanding as aborted by driver. */
-	nvmereq_wqe->iocb_flag |= LPFC_DRIVER_ABORTED;
+	ret_val = lpfc_sli4_issue_abort_iotag(phba, nvmereq_wqe,
+					      lpfc_nvme_abort_fcreq_cmpl);
 
-	lpfc_nvme_prep_abort_wqe(abts_buf, nvmereq_wqe->sli4_xritag, 0);
-
-	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abts_buf->iocb_flag |= LPFC_IO_NVME;
-	abts_buf->hba_wqidx = nvmereq_wqe->hba_wqidx;
-	abts_buf->vport = vport;
-	abts_buf->wqe_cmpl = lpfc_nvme_abort_fcreq_cmpl;
-	ret_val = lpfc_sli4_issue_wqe(phba, lpfc_nbuf->hdwq, abts_buf);
 	spin_unlock(&lpfc_nbuf->buf_lock);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	if (ret_val) {
+	if (ret_val != WQE_SUCCESS) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6137 Failed abts issue_wqe with status x%x "
 				 "for nvme_fcreq x%px.\n",
 				 ret_val, pnvme_fcreq);
-		lpfc_sli_release_iocbq(phba, abts_buf);
 		return;
 	}
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6138 Transport Abort NVME Request Issued for "
-			 "ox_id x%x on reqtag x%x\n",
-			 nvmereq_wqe->sli4_xritag,
-			 abts_buf->iotag);
+			 "ox_id x%x\n",
+			 nvmereq_wqe->sli4_xritag);
 	return;
 
 out_unlock:
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index fe8b3a80e3c8..dfd8e61b9daa 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3328,6 +3328,46 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	return 1;
 }
 
+/**
+ * lpfc_nvmet_prep_abort_wqe - set up 'abort' work queue entry.
+ * @pwqeq: Pointer to command iocb.
+ * @xritag: Tag that  uniqely identifies the local exchange resource.
+ * @opt: Option bits -
+ *		bit 0 = inhibit sending abts on the link
+ *
+ * This function is called with hbalock held.
+ **/
+void
+lpfc_nvmet_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt)
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
 static int
 lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 			       struct lpfc_async_xchg_ctx *ctxp,
@@ -3423,7 +3463,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	/* Ready - mark outstanding as aborted by driver. */
 	abts_wqeq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
-	lpfc_nvme_prep_abort_wqe(abts_wqeq, ctxp->wqeq->sli4_xritag, opt);
+	lpfc_nvmet_prep_abort_wqe(abts_wqeq, ctxp->wqeq->sli4_xritag, opt);
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abts_wqeq->hba_wqidx = ctxp->wqeq->hba_wqidx;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0cd8f0b72605..cd502ed489d0 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5377,11 +5377,10 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *iocb;
-	struct lpfc_iocbq *abtsiocb;
 	struct lpfc_io_buf *lpfc_cmd;
-	IOCB_t *cmd, *icmd;
 	int ret = SUCCESS, status = 0;
 	struct lpfc_sli_ring *pring_s4 = NULL;
+	struct lpfc_sli_ring *pring = NULL;
 	int ret_val;
 	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
@@ -5458,64 +5457,22 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		goto wait_for_cmpl;
 	}
 
-	abtsiocb = __lpfc_sli_get_iocbq(phba);
-	if (abtsiocb == NULL) {
-		ret = FAILED;
-		goto out_unlock_ring;
-	}
-
-	/* Indicate the IO is being aborted by the driver. */
-	iocb->iocb_flag |= LPFC_DRIVER_ABORTED;
-
-	/*
-	 * The scsi command can not be in txq and it is in flight because the
-	 * pCmd is still pointig at the SCSI command we have to abort. There
-	 * is no need to search the txcmplq. Just send an abort to the FW.
-	 */
-
-	cmd = &iocb->iocb;
-	icmd = &abtsiocb->iocb;
-	icmd->un.acxri.abortType = ABORT_TYPE_ABTS;
-	icmd->un.acxri.abortContextTag = cmd->ulpContext;
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		icmd->un.acxri.abortIoTag = iocb->sli4_xritag;
-	else
-		icmd->un.acxri.abortIoTag = cmd->ulpIoTag;
-
-	icmd->ulpLe = 1;
-	icmd->ulpClass = cmd->ulpClass;
-
-	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abtsiocb->hba_wqidx = iocb->hba_wqidx;
-	abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
-	if (iocb->iocb_flag & LPFC_IO_FOF)
-		abtsiocb->iocb_flag |= LPFC_IO_FOF;
-
-	if (lpfc_is_link_up(phba))
-		icmd->ulpCommand = CMD_ABORT_XRI_CN;
-	else
-		icmd->ulpCommand = CMD_CLOSE_XRI_CN;
-
-	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
-	abtsiocb->vport = vport;
 	lpfc_cmd->waitq = &waitq;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		/* Note: both hbalock and ring_lock must be set here */
-		ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
-						abtsiocb, 0);
 		spin_unlock(&pring_s4->ring_lock);
+		ret_val = lpfc_sli4_issue_abort_iotag(phba, iocb,
+						      lpfc_sli4_abort_fcp_cmpl);
 	} else {
-		ret_val = __lpfc_sli_issue_iocb(phba, LPFC_FCP_RING,
-						abtsiocb, 0);
+		pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+						     lpfc_sli_abort_fcp_cmpl);
 	}
 
-	if (ret_val == IOCB_ERROR) {
+	if (ret_val != IOCB_SUCCESS) {
 		/* Indicate the IO is not being aborted by the driver. */
-		iocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 		lpfc_cmd->waitq = NULL;
 		spin_unlock(&lpfc_cmd->buf_lock);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_sli_release_iocbq(phba, abtsiocb);
 		ret = FAILED;
 		goto out;
 	}
@@ -5529,7 +5486,10 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 wait_for_cmpl:
-	/* Wait for abort to complete */
+	/*
+	 * iocb_flag is set to LPFC_DRIVER_ABORTED before we wait
+	 * for abort to complete.
+	 */
 	wait_event_timeout(waitq,
 			  (lpfc_cmd->pCmd != cmnd),
 			   msecs_to_jiffies(2*vport->cfg_devloss_tmo*1000));
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e58ad2ea11be..62218e41933e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4209,7 +4209,7 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 		spin_lock_irq(&phba->hbalock);
 		/* Next issue ABTS for everything on the txcmplq */
 		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 		spin_unlock_irq(&phba->hbalock);
 	} else {
 		spin_lock_irq(&phba->hbalock);
@@ -4218,7 +4218,7 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 
 		/* Next issue ABTS for everything on the txcmplq */
 		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 		spin_unlock_irq(&phba->hbalock);
 	}
 
@@ -11181,7 +11181,8 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 						 &pring->txcmplq, list) {
 				if (iocb->vport != vport)
 					continue;
-				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+							   NULL);
 			}
 			pring->flag = prev_pring_flag;
 		}
@@ -11208,7 +11209,8 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 						 &pring->txcmplq, list) {
 				if (iocb->vport != vport)
 					continue;
-				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+							   NULL);
 			}
 			pring->flag = prev_pring_flag;
 		}
@@ -11605,27 +11607,29 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_sli_abort_iotag_issue - Issue abort for a command iocb
+ * lpfc_sli_issue_abort_iotag - Abort function for a command iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @cmdiocb: Pointer to driver command iocb object.
+ * @cmpl: completion function.
+ *
+ * This function issues an abort iocb for the provided command iocb. In case
+ * of unloading, the abort iocb will not be issued to commands on the ELS
+ * ring. Instead, the callback function shall be changed to those commands
+ * so that nothing happens when them finishes. This function is called with
+ * hbalock held andno ring_lock held (SLI4). The function returns IOCB_SUCCESS
+ * when the command iocb is an abort request.
  *
- * This function issues an abort iocb for the provided command iocb down to
- * the port. Other than the case the outstanding command iocb is an abort
- * request, this function issues abort out unconditionally. This function is
- * called with hbalock held. The function returns 0 when it fails due to
- * memory allocation failure or when the command iocb is an abort request.
- * The hbalock is asserted held in the code path calling this routine.
  **/
-static int
-lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-			   struct lpfc_iocbq *cmdiocb)
+int
+lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			   struct lpfc_iocbq *cmdiocb, void *cmpl)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_iocbq *abtsiocbp;
 	IOCB_t *icmd = NULL;
 	IOCB_t *iabt = NULL;
-	int retval;
+	int retval = IOCB_ERROR;
 	unsigned long iflags;
 	struct lpfc_nodelist *ndlp;
 
@@ -11638,12 +11642,33 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
 	    icmd->ulpCommand == CMD_CLOSE_XRI_CN ||
 	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
-		return 0;
+		return IOCB_ABORTING;
+
+	if (!pring) {
+		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
+			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
+		else
+			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
+		return retval;
+	}
+
+	/*
+	 * If we're unloading, don't abort iocb on the ELS ring, but change
+	 * the callback so that nothing happens when it finishes.
+	 */
+	if ((vport->load_flag & FC_UNLOADING) &&
+	    pring->ringno == LPFC_ELS_RING) {
+		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
+			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
+		else
+			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
+		return retval;
+	}
 
 	/* issue ABTS for this IOCB based on iotag */
 	abtsiocbp = __lpfc_sli_get_iocbq(phba);
 	if (abtsiocbp == NULL)
-		return 0;
+		return IOCB_NORESOURCE;
 
 	/* This signals the response to set the correct status
 	 * before calling the completion handler
@@ -11655,7 +11680,8 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	iabt->un.acxri.abortContextTag = icmd->ulpContext;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		iabt->un.acxri.abortIoTag = cmdiocb->sli4_xritag;
-		iabt->un.acxri.abortContextTag = cmdiocb->iotag;
+		if (pring->ringno == LPFC_ELS_RING)
+			iabt->un.acxri.abortContextTag = cmdiocb->iotag;
 	} else {
 		iabt->un.acxri.abortIoTag = icmd->ulpIoTag;
 		if (pring->ringno == LPFC_ELS_RING) {
@@ -11668,8 +11694,10 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
-	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP) {
+		abtsiocbp->iocb_flag |= LPFC_IO_FCP;
 		abtsiocbp->iocb_flag |= LPFC_USE_FCPWQIDX;
+	}
 	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
 		abtsiocbp->iocb_flag |= LPFC_IO_FOF;
 
@@ -11678,20 +11706,16 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	else
 		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
 
-	abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
+	if (cmpl)
+		abtsiocbp->iocb_cmpl = cmpl;
+	else
+		abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
 	abtsiocbp->vport = vport;
 
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
-			 "0339 Abort xri x%x, original iotag x%x, "
-			 "abort cmd iotag x%x\n",
-			 iabt->un.acxri.abortIoTag,
-			 iabt->un.acxri.abortContextTag,
-			 abtsiocbp->iotag);
-
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		pring = lpfc_sli4_calc_ring(phba, abtsiocbp);
 		if (unlikely(pring == NULL))
-			return 0;
+			goto abort_iotag_exit;
 		/* Note: both hbalock and ring_lock need to be set here */
 		spin_lock_irqsave(&pring->ring_lock, iflags);
 		retval = __lpfc_sli_issue_iocb(phba, pring->ringno,
@@ -11702,76 +11726,20 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			abtsiocbp, 0);
 	}
 
-	if (retval)
-		__lpfc_sli_release_iocbq(phba, abtsiocbp);
-
-	/*
-	 * Caller to this routine should check for IOCB_ERROR
-	 * and handle it properly.  This routine no longer removes
-	 * iocb off txcmplq and call compl in case of IOCB_ERROR.
-	 */
-	return retval;
-}
-
-/**
- * lpfc_sli_issue_abort_iotag - Abort function for a command iocb
- * @phba: Pointer to HBA context object.
- * @pring: Pointer to driver SLI ring object.
- * @cmdiocb: Pointer to driver command iocb object.
- *
- * This function issues an abort iocb for the provided command iocb. In case
- * of unloading, the abort iocb will not be issued to commands on the ELS
- * ring. Instead, the callback function shall be changed to those commands
- * so that nothing happens when them finishes. This function is called with
- * hbalock held. The function returns 0 when the command iocb is an abort
- * request.
- **/
-int
-lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-			   struct lpfc_iocbq *cmdiocb)
-{
-	struct lpfc_vport *vport = cmdiocb->vport;
-	int retval = IOCB_ERROR;
-	IOCB_t *icmd = NULL;
-
-	lockdep_assert_held(&phba->hbalock);
-
-	/*
-	 * There are certain command types we don't want to abort.  And we
-	 * don't want to abort commands that are already in the process of
-	 * being aborted.
-	 */
-	icmd = &cmdiocb->iocb;
-	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
-	    icmd->ulpCommand == CMD_CLOSE_XRI_CN ||
-	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
-		return 0;
+abort_iotag_exit:
 
-	if (!pring) {
-		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
-		else
-			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
-		goto abort_iotag_exit;
-	}
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+			 "0339 Abort xri x%x, original iotag x%x, "
+			 "abort cmd iotag x%x retval x%x\n",
+			 iabt->un.acxri.abortIoTag,
+			 iabt->un.acxri.abortContextTag,
+			 abtsiocbp->iotag, retval);
 
-	/*
-	 * If we're unloading, don't abort iocb on the ELS ring, but change
-	 * the callback so that nothing happens when it finishes.
-	 */
-	if ((vport->load_flag & FC_UNLOADING) &&
-	    (pring->ringno == LPFC_ELS_RING)) {
-		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
-		else
-			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
-		goto abort_iotag_exit;
+	if (retval) {
+		cmdiocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+		__lpfc_sli_release_iocbq(phba, abtsiocbp);
 	}
 
-	/* Now, we try to issue the abort to the cmdiocb out */
-	retval = lpfc_sli_abort_iotag_issue(phba, pring, cmdiocb);
-
-abort_iotag_exit:
 	/*
 	 * Caller to this routine should check for IOCB_ERROR
 	 * and handle it properly.  This routine no longer removes
@@ -11915,6 +11883,33 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 	return sum;
 }
 
+/**
+ * lpfc_sli4_abort_fcp_cmpl - Completion handler function for aborted FCP IOCBs
+ * @phba: Pointer to HBA context object
+ * @cmdiocb: Pointer to command iocb object.
+ * @wcqe: pointer to the complete wcqe
+ *
+ * This function is called when an aborted FCP iocb completes. This
+ * function is called by the ring event handler with no lock held.
+ * This function frees the iocb. It is called for sli-4 adapters.
+ **/
+void
+lpfc_sli4_abort_fcp_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+			 struct lpfc_wcqe_complete *wcqe)
+{
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"3017 ABORT_XRI_CN completing on rpi x%x "
+			"original iotag x%x, abort cmd iotag x%x "
+			"status 0x%x, reason 0x%x\n",
+			cmdiocb->iocb.un.acxri.abortContextTag,
+			cmdiocb->iocb.un.acxri.abortIoTag,
+			cmdiocb->iotag,
+			(bf_get(lpfc_wcqe_c_status, wcqe)
+			& LPFC_IOCB_STATUS_MASK),
+			wcqe->parameter);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
+}
+
 /**
  * lpfc_sli_abort_fcp_cmpl - Completion handler function for aborted FCP IOCBs
  * @phba: Pointer to HBA context object
@@ -11968,10 +11963,8 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *iocbq;
-	struct lpfc_iocbq *abtsiocb;
-	struct lpfc_sli_ring *pring_s4;
-	IOCB_t *cmd = NULL;
 	int errcnt = 0, ret_val = 0;
+	unsigned long iflags;
 	int i;
 
 	/* all I/Os are in process of being flushed */
@@ -11985,62 +11978,12 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 					       abort_cmd) != 0)
 			continue;
 
-		/*
-		 * If the iocbq is already being aborted, don't take a second
-		 * action, but do count it.
-		 */
-		if (iocbq->iocb_flag & LPFC_DRIVER_ABORTED)
-			continue;
-
-		/* issue ABTS for this IOCB based on iotag */
-		abtsiocb = lpfc_sli_get_iocbq(phba);
-		if (abtsiocb == NULL) {
-			errcnt++;
-			continue;
-		}
-
-		/* indicate the IO is being aborted by the driver. */
-		iocbq->iocb_flag |= LPFC_DRIVER_ABORTED;
-
-		cmd = &iocbq->iocb;
-		abtsiocb->iocb.un.acxri.abortType = ABORT_TYPE_ABTS;
-		abtsiocb->iocb.un.acxri.abortContextTag = cmd->ulpContext;
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			abtsiocb->iocb.un.acxri.abortIoTag = iocbq->sli4_xritag;
-		else
-			abtsiocb->iocb.un.acxri.abortIoTag = cmd->ulpIoTag;
-		abtsiocb->iocb.ulpLe = 1;
-		abtsiocb->iocb.ulpClass = cmd->ulpClass;
-		abtsiocb->vport = vport;
-
-		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-		abtsiocb->hba_wqidx = iocbq->hba_wqidx;
-		if (iocbq->iocb_flag & LPFC_IO_FCP)
-			abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
-		if (iocbq->iocb_flag & LPFC_IO_FOF)
-			abtsiocb->iocb_flag |= LPFC_IO_FOF;
-
-		if (lpfc_is_link_up(phba))
-			abtsiocb->iocb.ulpCommand = CMD_ABORT_XRI_CN;
-		else
-			abtsiocb->iocb.ulpCommand = CMD_CLOSE_XRI_CN;
-
-		/* Setup callback routine and issue the command. */
-		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
-		if (phba->sli_rev == LPFC_SLI_REV4) {
-			pring_s4 = lpfc_sli4_calc_ring(phba, iocbq);
-			if (!pring_s4)
-				continue;
-			ret_val = lpfc_sli_issue_iocb(phba, pring_s4->ringno,
-						      abtsiocb, 0);
-		} else
-			ret_val = lpfc_sli_issue_iocb(phba, pring->ringno,
-						      abtsiocb, 0);
-		if (ret_val == IOCB_ERROR) {
-			lpfc_sli_release_iocbq(phba, abtsiocb);
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocbq,
+						     lpfc_sli_abort_fcp_cmpl);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		if (ret_val != IOCB_SUCCESS)
 			errcnt++;
-			continue;
-		}
 	}
 
 	return errcnt;
@@ -20551,6 +20494,88 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	return WQE_ERROR;
 }
 
+/**
+ * lpfc_sli4_issue_abort_iotag - SLI-4 WQE init & issue for the Abort
+ * @phba: Pointer to HBA context object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ * @cmpl: completion function.
+ *
+ * Fill the appropriate fields for the abort WQE and call
+ * internal routine lpfc_sli4_issue_wqe to send the WQE
+ * This function is called with hbalock held and no ring_lock held.
+ *
+ * RETURNS 0 - SUCCESS
+ **/
+
+int
+lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+			    void *cmpl)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct lpfc_iocbq *abtsiocb = NULL;
+	union lpfc_wqe128 *abtswqe;
+	struct lpfc_io_buf *lpfc_cmd;
+	int retval = IOCB_ERROR;
+	u16 xritag = cmdiocb->sli4_xritag;
+
+	/*
+	 * The scsi command can not be in txq and it is in flight because the
+	 * pCmd is still pointing at the SCSI command we have to abort. There
+	 * is no need to search the txcmplq. Just send an abort to the FW.
+	 */
+
+	abtsiocb = __lpfc_sli_get_iocbq(phba);
+	if (!abtsiocb)
+		return WQE_NORESOURCE;
+
+	/* Indicate the IO is being aborted by the driver. */
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
+
+	abtswqe = &abtsiocb->wqe;
+	memset(abtswqe, 0, sizeof(*abtswqe));
+
+	if (lpfc_is_link_up(phba))
+		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 1);
+	else
+		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 0);
+	bf_set(abort_cmd_criteria, &abtswqe->abort_cmd, T_XRI_TAG);
+	abtswqe->abort_cmd.rsrvd5 = 0;
+	abtswqe->abort_cmd.wqe_com.abort_tag = xritag;
+	bf_set(wqe_reqtag, &abtswqe->abort_cmd.wqe_com, abtsiocb->iotag);
+	bf_set(wqe_cmnd, &abtswqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
+	bf_set(wqe_xri_tag, &abtswqe->generic.wqe_com, 0);
+	bf_set(wqe_qosd, &abtswqe->abort_cmd.wqe_com, 1);
+	bf_set(wqe_lenloc, &abtswqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
+	bf_set(wqe_cmd_type, &abtswqe->abort_cmd.wqe_com, OTHER_COMMAND);
+
+	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
+	abtsiocb->hba_wqidx = cmdiocb->hba_wqidx;
+	abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+		abtsiocb->iocb_flag |= LPFC_IO_FCP;
+	if (cmdiocb->iocb_flag & LPFC_IO_NVME)
+		abtsiocb->iocb_flag |= LPFC_IO_NVME;
+	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
+		abtsiocb->iocb_flag |= LPFC_IO_FOF;
+	abtsiocb->vport = vport;
+	abtsiocb->wqe_cmpl = cmpl;
+
+	lpfc_cmd = container_of(cmdiocb, struct lpfc_io_buf, cur_iocbq);
+	retval = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, abtsiocb);
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI | LOG_NVME_ABTS | LOG_FCP,
+			 "0359 Abort xri x%x, original iotag x%x, "
+			 "abort cmd iotag x%x retval x%x\n",
+			 xritag, cmdiocb->iotag, abtsiocb->iotag, retval);
+
+	if (retval) {
+		cmdiocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+		__lpfc_sli_release_iocbq(phba, abtsiocb);
+	}
+
+	return retval;
+}
+
 #ifdef LPFC_MXP_STAT
 /**
  * lpfc_snapshot_mxp - Snapshot pbl, pvt and busy count
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 93d976ea8c5d..3ddaac57f99e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -130,6 +130,9 @@ struct lpfc_iocbq {
 #define IOCB_BUSY           1
 #define IOCB_ERROR          2
 #define IOCB_TIMEDOUT       3
+#define IOCB_ABORTED        4
+#define IOCB_ABORTING	    5
+#define IOCB_NORESOURCE	    6
 
 #define SLI_WQE_RET_WQE    1    /* Return WQE if cmd ring full */
 
@@ -138,6 +141,8 @@ struct lpfc_iocbq {
 #define WQE_ERROR          2
 #define WQE_TIMEDOUT       3
 #define WQE_ABORTED        4
+#define WQE_ABORTING	   5
+#define WQE_NORESOURCE	   6
 
 #define LPFC_MBX_WAKE		1
 #define LPFC_MBX_IMED_UNREG	2
-- 
2.26.2


--000000000000d1c4a605b42a3f0a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgdiLaxP7w5sSbYCXw
BkivA82Xm2ZnrXEXDSqt7WCRbrswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzE1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGNOJi4lIVZ6GI8n+eRBn2lm+WtYW8GuDjDs
E3/UB3VOPO4mZqBY6VnsVfeiTjN9NUduWE3kvW9ABJQxL888aHt/ltyAVXeeJdVPhI++E86DkE89
/1dKaKmUC0nUFQRIGJzcFLLO7ZZ8Jb5J6Qj/f4k0Ej1/AXge0YNzxijUd5TIWBQ+BlyTF2XzCEEJ
b5+MTHKxEEOWvbH2h7S8JO+Ufjl5zN1v/AyZaoWvxzojDRaXy+imFjVbL6siXFubFXTd4Re3NJQz
TDNcQuSLFsjh+RZtE0gp1yIFsg7qtBlTjaPa1yjPqeYgIqivjA4DfnTvGMO6hc9vCW/eWyoj1AIF
abU=
--000000000000d1c4a605b42a3f0a--
