Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9EAC43470
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51B3611C1
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhDJRbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhDJRbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:03 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F53C06138A
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:47 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y2so4245293plg.5
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jIVe7Lhm68fisYNHOMcyVCopnQe93wabL8ajJtDy7G8=;
        b=BBHl98MzbSnklAG+3hGgBkRZAMGBX4tAKt9QAtCIWMq8qcoWt+uIrdjx+6pKh72b5A
         lEDqRS+DSWi3ne8xtI+UiCXNTtYHL/0EXcmS6WW7yY9r36XyUm++xDhXzF41jEuyDXYu
         uUvevjK4jkqfxD/p24qSQ5uOJM93ixkLwKfRXJS1xexenwkga4wC08Pn9FCA0NVuPQ95
         F3qD3Zjqoter5QiNp//5ZgkjreUDq+JUGQiO81Oesr8QrX+3YQzq4RKQdg2Yi+67wKj2
         cZ6infbzCMa/GKfIhm0C2cbdWoPC15SuE61lftNPLUiCLuGEooEmJBiW7yPRp8LWdwE/
         8VYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jIVe7Lhm68fisYNHOMcyVCopnQe93wabL8ajJtDy7G8=;
        b=sxOWSTUy9pD3jHsjnqGqvHBUYOoOzNwwhzosVYEbEh3h9BgQpseZN27WoEteZM/6Ow
         997RM8kGBEfERqoEww7+OJgbOt3Iwexpon2kNVzgWz35r4XsNMn/Q7D7/cyP8ctw6aiJ
         JNxB8oGy+28veWAB/Gp1QqyvcGF8vNlxMSYGMb6mxfOybhdT9ch9brDpHE7NTU/ziteQ
         4jbzP6gZ4DtyARwJ0MwwezHj3/NqpN/4L41Pnekx0CfbgJrK5VNu6HmvuruErmuHOZAC
         GVrI5PcUer74iGbwk4SCI5XsZvm2RP4XXMaHgzsSfY8kjGRWZcPsTU8ckIHWd4KDoSZh
         6MJQ==
X-Gm-Message-State: AOAM532hYa+io0ZkE3JqxZggp3EF0LAreIPy1bBa5uGNrQ7Aaxn4wai6
        p2PmTa4b3TzU3oriJMFVZX2ZhC1m74c=
X-Google-Smtp-Source: ABdhPJxDZtXMYWy5dCiqIn++hPqUMmQw1wCGNm1ZTXR1QAp2AfTGmJZps6duhrwgEJ8kZEkYyaZOwg==
X-Received: by 2002:a17:902:b482:b029:e8:c21a:6ad2 with SMTP id y2-20020a170902b482b02900e8c21a6ad2mr18205276plr.51.1618075846763;
        Sat, 10 Apr 2021 10:30:46 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:46 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/16] lpfc: Fix NMI crash during rmmod due to circular hbalock dependency
Date:   Sat, 10 Apr 2021 10:30:22 -0700
Message-Id: <20210410173034.67618-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
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
index 67159b957344..e71b37608f60 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10086,8 +10086,7 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	unsigned long iflag = 0;
 
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, iflag);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport) {
@@ -10095,8 +10094,7 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 			sglq_entry->ndlp = NULL;
 		}
 	}
-	spin_unlock(&phba->sli4_hba.sgl_list_lock);
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock, iflag);
 	return;
 }
 
@@ -10123,8 +10121,7 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 
 	pring = lpfc_phba_elsring(phba);
 
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, iflag);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->sli4_xritag == xri) {
@@ -10134,8 +10131,8 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			list_add_tail(&sglq_entry->list,
 				&phba->sli4_hba.lpfc_els_sgl_list);
 			sglq_entry->state = SGL_FREED;
-			spin_unlock(&phba->sli4_hba.sgl_list_lock);
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock,
+					       iflag);
 
 			if (ndlp) {
 				lpfc_set_rrq_active(phba, ndlp,
@@ -10150,21 +10147,18 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
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

