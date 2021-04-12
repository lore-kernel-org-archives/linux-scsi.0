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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CFDC43460
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C6E61025
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbhDLBcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbhDLBcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C83C06138D
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a85so7716798pfa.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EKObJA53CzZ7C7CLj5HUqeGQzhdG7yHMhNMuqlUmKKs=;
        b=TkqmnuLCvDCi6tFC8YTEJ9VLJCsPzzEpx23lCG0itmyV0NgM5HAXYeht4/lpeWH+2P
         0CRzY1XMIF54wJr2i1Pe9mencFPlhqvuBW5uxrHKOfOgUZ56o2kMkDkqDNfTYKYUMkF/
         EGifx7Vzoh0qEpgtk2arfJplzA0dv+WH89Pri8YyZIKiKJmZQ0j9ry4CgdHZPqb3h7ip
         ULgsU3pXds2G/R/ajSYlD/nVfPp75Fi3vlVdr8Nlunrpzl9oosgpfFx9QUWPOGA2vGsY
         Djx9J61UK1XhB+7vYKNgIB9OY8aY3tvSwgQovg7XZNU3tNBHa6upBjHdVHLzb0kCfqlT
         kvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKObJA53CzZ7C7CLj5HUqeGQzhdG7yHMhNMuqlUmKKs=;
        b=R5S1JTYRzwlqkYcGHnZxEGsZfm7MghUdJ9mTePefVSL850OgSDYigpwZkiBQNXTfA0
         cMY67x+JM3WpQbd3XBhx0cuHxdoGdTEqUDYLXbjaGbc7zCbCHdOm6REmHZSLErd+9ZAU
         bkm0bTUJkOk/s3FV34pgpunynBO37AuzcZJtmrnG5jIu6Ju8Xp3JIyLBYDtr0W/hoeOi
         NVq7t26d0veDuCjMhXXkfa70y9c6vzTVgAwy2/vXL6GtpDnTeAYw7XgybPULu22yGTFt
         kjlYMQ8CCGfcQkvlDLDuEx58VG1y51h3wtlp+v7SJs7xE556QYfetWnCrhNlhwo3BFxc
         YU/w==
X-Gm-Message-State: AOAM532/yy2J8SQ91a0nrfTIpmgyJIRRsQ4teEX2Mmdkw4NiiEQb8r8H
        JdXQTC3yHv5qtw53IsjVcrRlJNUt6Xo=
X-Google-Smtp-Source: ABdhPJx0L9PPK44V52m+5/FOw4WCWZF3iHtjSn43vg+XSt0+jILswnyfOso9xXINhOykNA3pfTNyLQ==
X-Received: by 2002:a62:7bc4:0:b029:1f1:58ea:4010 with SMTP id w187-20020a627bc40000b02901f158ea4010mr23430803pfc.70.1618191122459;
        Sun, 11 Apr 2021 18:32:02 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:02 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 04/16] lpfc: Fix NMI crash during rmmod due to circular hbalock dependency
Date:   Sun, 11 Apr 2021 18:31:15 -0700
Message-Id: <20210412013127.2387-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove hbalock dependency for lpfc_abts_els_sgl_list and
lpfc_abts_nvmet_ctx_list.  The lists are adaquately synchronized with
the sgl_list_lock and abts_nvmet_buf_list_lock.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c   | 24 +++++++++---------------
 drivers/scsi/lpfc/lpfc_init.c  | 26 ++++++++++----------------
 drivers/scsi/lpfc/lpfc_nvmet.c | 26 +++++++++++---------------
 3 files changed, 30 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c62c141342a6..1bb1e3cf7113 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10072,8 +10072,7 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	unsigned long iflag = 0;
 
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, iflag);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport) {
@@ -10081,8 +10080,7 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 			sglq_entry->ndlp = NULL;
 		}
 	}
-	spin_unlock(&phba->sli4_hba.sgl_list_lock);
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock, iflag);
 	return;
 }
 
@@ -10109,8 +10107,7 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 
 	pring = lpfc_phba_elsring(phba);
 
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, iflag);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->sli4_xritag == xri) {
@@ -10120,8 +10117,8 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			list_add_tail(&sglq_entry->list,
 				&phba->sli4_hba.lpfc_els_sgl_list);
 			sglq_entry->state = SGL_FREED;
-			spin_unlock(&phba->sli4_hba.sgl_list_lock);
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock,
+					       iflag);
 
 			if (ndlp) {
 				lpfc_set_rrq_active(phba, ndlp,
@@ -10136,21 +10133,18 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			return;
 		}
 	}
-	spin_unlock(&phba->sli4_hba.sgl_list_lock);
+	spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock, iflag);
 	lxri = lpfc_sli4_xri_inrange(phba, xri);
-	if (lxri == NO_XRI) {
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
+	if (lxri == NO_XRI)
 		return;
-	}
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
+
+	spin_lock_irqsave(&phba->hbalock, iflag);
 	sglq_entry = __lpfc_get_active_sglq(phba, lxri);
 	if (!sglq_entry || (sglq_entry->sli4_xritag != xri)) {
-		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return;
 	}
 	sglq_entry->state = SGL_XRI_ABORTED;
-	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5ea43c527e08..631f22baf45f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1043,12 +1043,11 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	 * driver is unloading or reposted if the driver is restarting
 	 * the port.
 	 */
-	spin_lock_irq(&phba->hbalock);  /* required for lpfc_els_sgl_list and */
-					/* scsl_buf_list */
+
 	/* sgl_list_lock required because worker thread uses this
 	 * list.
 	 */
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry(sglq_entry,
 		&phba->sli4_hba.lpfc_abts_els_sgl_list, list)
 		sglq_entry->state = SGL_FREED;
@@ -1057,11 +1056,12 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 			&phba->sli4_hba.lpfc_els_sgl_list);
 
 
-	spin_unlock(&phba->sli4_hba.sgl_list_lock);
+	spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
 
 	/* abts_xxxx_buf_list_lock required because worker thread uses this
 	 * list.
 	 */
+	spin_lock_irq(&phba->hbalock);
 	cnt = 0;
 	for (idx = 0; idx < phba->cfg_hdw_queue; idx++) {
 		qp = &phba->sli4_hba.hdwq[idx];
@@ -3804,12 +3804,10 @@ lpfc_sli4_els_sgl_update(struct lpfc_hba *phba)
 			sglq_entry->state = SGL_FREED;
 			list_add_tail(&sglq_entry->list, &els_sgl_list);
 		}
-		spin_lock_irq(&phba->hbalock);
-		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
 		list_splice_init(&els_sgl_list,
 				 &phba->sli4_hba.lpfc_els_sgl_list);
-		spin_unlock(&phba->sli4_hba.sgl_list_lock);
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
 	} else if (els_xri_cnt < phba->sli4_hba.els_xri_cnt) {
 		/* els xri-sgl shrinked */
 		xri_cnt = phba->sli4_hba.els_xri_cnt - els_xri_cnt;
@@ -3817,8 +3815,7 @@ lpfc_sli4_els_sgl_update(struct lpfc_hba *phba)
 				"3158 ELS xri-sgl count decreased from "
 				"%d to %d\n", phba->sli4_hba.els_xri_cnt,
 				els_xri_cnt);
-		spin_lock_irq(&phba->hbalock);
-		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
 		list_splice_init(&phba->sli4_hba.lpfc_els_sgl_list,
 				 &els_sgl_list);
 		/* release extra els sgls from list */
@@ -3833,8 +3830,7 @@ lpfc_sli4_els_sgl_update(struct lpfc_hba *phba)
 		}
 		list_splice_init(&els_sgl_list,
 				 &phba->sli4_hba.lpfc_els_sgl_list);
-		spin_unlock(&phba->sli4_hba.sgl_list_lock);
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
 	} else
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"3163 ELS xri-sgl count unchanged: %d\n",
@@ -7388,11 +7384,9 @@ lpfc_free_els_sgl_list(struct lpfc_hba *phba)
 	LIST_HEAD(sglq_list);
 
 	/* Retrieve all els sgls from driver list */
-	spin_lock_irq(&phba->hbalock);
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
 	list_splice_init(&phba->sli4_hba.lpfc_els_sgl_list, &sglq_list);
-	spin_unlock(&phba->sli4_hba.sgl_list_lock);
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
 
 	/* Now free the sgl list */
 	lpfc_free_sgl_list(phba, &sglq_list);
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c84da8e6b65d..f2d9a3580887 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1440,7 +1440,10 @@ __lpfc_nvmet_clean_io_for_cpu(struct lpfc_hba *phba,
 		list_del_init(&ctx_buf->list);
 		spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
 
+		spin_lock(&phba->hbalock);
 		__lpfc_clear_active_sglq(phba, ctx_buf->sglq->sli4_lxritag);
+		spin_unlock(&phba->hbalock);
+
 		ctx_buf->sglq->state = SGL_FREED;
 		ctx_buf->sglq->ndlp = NULL;
 
@@ -1787,8 +1790,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		atomic_inc(&tgtp->xmt_fcp_xri_abort_cqe);
 	}
 
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
+	spin_lock_irqsave(&phba->sli4_hba.abts_nvmet_buf_list_lock, iflag);
 	list_for_each_entry_safe(ctxp, next_ctxp,
 				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
 				 list) {
@@ -1806,10 +1808,10 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		}
 		ctxp->flag &= ~LPFC_NVME_XBUSY;
 		spin_unlock(&ctxp->ctxlock);
-		spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
+		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock,
+				       iflag);
 
 		rrq_empty = list_empty(&phba->active_rrq_list);
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
 		if (ndlp &&
 		    (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE ||
@@ -1830,9 +1832,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 			lpfc_worker_wake_up(phba);
 		return;
 	}
-	spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
-
+	spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock, iflag);
 	ctxp = lpfc_nvmet_get_ctx_for_xri(phba, xri);
 	if (ctxp) {
 		/*
@@ -1876,8 +1876,7 @@ lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 	sid = sli4_sid_from_fc_hdr(fc_hdr);
 	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
 
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
+	spin_lock_irqsave(&phba->sli4_hba.abts_nvmet_buf_list_lock, iflag);
 	list_for_each_entry_safe(ctxp, next_ctxp,
 				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
 				 list) {
@@ -1886,9 +1885,8 @@ lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 
 		xri = ctxp->ctxbuf->sglq->sli4_xritag;
 
-		spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-
+		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock,
+				       iflag);
 		spin_lock_irqsave(&ctxp->ctxlock, iflag);
 		ctxp->flag |= LPFC_NVME_ABTS_RCV;
 		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
@@ -1907,9 +1905,7 @@ lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 		lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 1);
 		return 0;
 	}
-	spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
-
+	spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock, iflag);
 	/* check the wait list */
 	if (phba->sli4_hba.nvmet_io_wait_cnt) {
 		struct rqb_dmabuf *nvmebuf;
-- 
2.26.2

