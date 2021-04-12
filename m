Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CACC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DB5361027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhDLBcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbhDLBcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:19 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EF5C06138C
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:02 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g35so8131122pgg.9
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Af0EVa6qgaoImVHiw8HNNJfHEzShruXKXmQGKEkM3V8=;
        b=JG6GzTKw7X3plkn72p0It0sg6IHsb7IMLx0qU5eU81r/MmiYtq4IHgzQMmSBPF5wh+
         esbASbOHjYikKLUpqIP1/idZhSXjMWCbzb480uE7nR1ydtwdOOLphTcoFoHOkydhLZtf
         iQCYJznHs2Mu/h8aANe5ZlQqDwbLPb8Fca/OyDIP31JROUdA2HRYYinu+EEGq3ig2m8Y
         GxFdI3UZG18rEr/M/ftB3MsZ01Y98rCnXnl4lka3GSsThi+NhZ/okQZp+RAXxLwiwn3f
         SnLsn+tUHzMjyo1eursJKjlHOqISYHa0mbd1dLllPpZo2ltBEBrFYLWfrIs9ohXQ3wQI
         lalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Af0EVa6qgaoImVHiw8HNNJfHEzShruXKXmQGKEkM3V8=;
        b=GYk1QFxp9MHXUDiSZrL0GrfhHtx1c6BQsj9V5vDLYMzzzkQ/DtjuIqakplr+RrqUIi
         n9f986/r4Hvw0z3vwXNgzcT5HtEBEl+oarCEhzysnCG6PfaflumQigG/kn6ZTWjNuum9
         1ceQvNGnY7cgrlNYiNptb3VzkYqV9tirj7do+Sq01Y7QHTbbVwUvvsIzq7iWqmujCLvY
         Xm3eWDavrKuWiC6ahzbCd4jtJf5XbpuJISH61msKeBfWYsV+kRNGCdbjVxzemtHQdCKv
         8Qrgxhl6OCC62lp0ut9MvunCFjVxsOKvXScx6RB5QXpY7JWcoqHt87t8IUQ14a2kdL89
         bxJA==
X-Gm-Message-State: AOAM530etDKyAy8wVD0HxkmsgrTJYmJOGRbs9XeAM5FoP/OW62TJPFPK
        p0mJ+S8MnOvTvHWr2FmF0sJodO+6EDA=
X-Google-Smtp-Source: ABdhPJx1Ag4agNaAok+GFb2vWngVoxVz+8amCk84g4/FBgWeNs1omXFJfeMjPycWc4EjAmw2nSvxpQ==
X-Received: by 2002:a05:6a00:d41:b029:241:6449:e96 with SMTP id n1-20020a056a000d41b029024164490e96mr22057921pfv.75.1618191121809;
        Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 03/16] lpfc: Fix reference counting errors in lpfc_cmpl_els_rsp()
Date:   Sun, 11 Apr 2021 18:31:14 -0700
Message-Id: <20210412013127.2387-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call traces are being seen that result from a nodelist structure ref
counting error. They are typically seen after transmission of an LS_RJT
ELS response.

Aged code in lpfc_cmpl_els_rsp() calls lpfc_nlp_not_used() which, if the
ndlp reference count is exactly 1, will decrement the reference count.
Previously lpfc_nlp_put() was within lpfc_els_free_iocb, and the 'put'
within the free would only be invoked if cmdiocb->context1 was not NULL.
Since the nodelist structure reference count is decremented when exiting
lpfc_cmpl_els_rsp() the lpfc_nlp_not_used() calls are no longer required.
Calling them is causing the reference count issue.

Fix by removing the lpfc_nlp_not_used() calls

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v2:
 Remove ls_rjt code that is now set and not used.
 When that code was removed, also removed pcmd.
---
 drivers/scsi/lpfc/lpfc_els.c | 64 +-----------------------------------
 1 file changed, 1 insertion(+), 63 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a04546eca18f..c62c141342a6 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4444,10 +4444,7 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
  * nlp_flag bitmap in the ndlp data structure, if the mbox command reference
  * field in the command IOCB is not NULL, the referred mailbox command will
  * be send out, and then invokes the lpfc_els_free_iocb() routine to release
- * the IOCB. Under error conditions, such as when a LS_RJT is returned or a
- * link down event occurred during the discovery, the lpfc_nlp_not_used()
- * routine shall be invoked trying to release the ndlp if no other threads
- * are currently referring it.
+ * the IOCB.
  **/
 static void
 lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
@@ -4457,10 +4454,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vport *vport = ndlp ? ndlp->vport : NULL;
 	struct Scsi_Host  *shost = vport ? lpfc_shost_from_vport(vport) : NULL;
 	IOCB_t  *irsp;
-	uint8_t *pcmd;
 	LPFC_MBOXQ_t *mbox = NULL;
 	struct lpfc_dmabuf *mp = NULL;
-	uint32_t ls_rjt = 0;
 
 	irsp = &rspiocb->iocb;
 
@@ -4472,18 +4467,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (cmdiocb->context_un.mbox)
 		mbox = cmdiocb->context_un.mbox;
 
-	/* First determine if this is a LS_RJT cmpl. Note, this callback
-	 * function can have cmdiocb->contest1 (ndlp) field set to NULL.
-	 */
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
-	if (ndlp && (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
-		/* A LS_RJT associated with Default RPI cleanup has its own
-		 * separate code path.
-		 */
-		if (!(ndlp->nlp_flag & NLP_RM_DFLT_RPI))
-			ls_rjt = 1;
-	}
-
 	/* Check to see if link went down during discovery */
 	if (!ndlp || lpfc_els_chk_latt(vport)) {
 		if (mbox) {
@@ -4494,15 +4477,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
-		if (ndlp && (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
-			if (lpfc_nlp_not_used(ndlp)) {
-				ndlp = NULL;
-				/* Indicate the node has already released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
-			}
 		goto out;
 	}
 
@@ -4580,29 +4554,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				"Data: x%x x%x x%x\n",
 				ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 				ndlp->nlp_rpi);
-
-			if (lpfc_nlp_not_used(ndlp)) {
-				ndlp = NULL;
-				/* Indicate node has already been released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
-			}
-		} else {
-			/* Do not drop node for lpfc_els_abort'ed ELS cmds */
-			if (!lpfc_error_lost_link(irsp) &&
-			    ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-				if (lpfc_nlp_not_used(ndlp)) {
-					ndlp = NULL;
-					/* Indicate node has already been
-					 * released, should not reference
-					 * to it from within the routine
-					 * lpfc_els_free_iocb.
-					 */
-					cmdiocb->context1 = NULL;
-				}
-			}
 		}
 		mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
 		if (mp) {
@@ -4618,19 +4569,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
 		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
 		spin_unlock_irq(&ndlp->lock);
-
-		/* If the node is not being used by another discovery thread,
-		 * and we are sending a reject, we are done with it.
-		 * Release driver reference count here and free associated
-		 * resources.
-		 */
-		if (ls_rjt)
-			if (lpfc_nlp_not_used(ndlp))
-				/* Indicate node has already been released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
 	}
 
 	/* Release the originating I/O reference. */
-- 
2.26.2

