Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D27C4740C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6241120820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f322eH6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfIVD7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:35 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46969 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbfIVD7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:34 -0400
Received: by mail-ot1-f68.google.com with SMTP id f21so9360574otl.13
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3K7++IeZpyrBG124O+pGw85sMPw3M/9Yzwc2BeSgE4Q=;
        b=f322eH6wCosmM+0wA90QKhU+E6c2j5yKWHumQnhq6QVbiD1vunGZkW6o0gpsud9FDP
         M4fi5t4rTmx2pCNTmqlbisZ10P1yj0M97DT7ePptK9EjeyprXF1aUEKQbMCDBf3g2gLZ
         UXwygSZy2vtINzoPAeyjhAmiWabtO3YeVDYVrVXcw7CqiQv7KmfDUMT9GXf/B14saXAc
         noobqd8zsU9piTwN+ArFXNyW2+Gzvc7HbQZ62g/lutE7iYNurJDwbzd8F20lVbjJH23g
         zTrEqC0wowpD4TtFqKWzHBNAKeRfm2twGrW4w7qH4ihTcB/h/DFwhbRs2t9hQX4SHD/I
         8UHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3K7++IeZpyrBG124O+pGw85sMPw3M/9Yzwc2BeSgE4Q=;
        b=YDEelYoccPV494CTSfjvvg89fKLC038pIqzGuw7R+JOaHiLaEVI6R4qtEe0DpTDIbT
         5iWvPvCDExDflJ2ungPmN5tAH4Rw2WLHI1/oLlBRXw36ASPfPFK41JyqVVsYTkcYYm6L
         yi9zq7mIttMNStlWinN9Y9H7dn3seP++qpWmP9otSWPwUlBnpaM/U6JJO7K8I+eTNHPP
         NYqAgOkxn+NDc/dTufpipD50v6pCFQXLtdKwJUSUney7pXycdnFPd5L3+Hyi+iYJ8rA2
         Vk16TeCa+pL/560UjwB/O0mUn8UyMAxV6EIFuPzDm/E9qPTlFZcVfVtBjLUSSlibE7QM
         wRyA==
X-Gm-Message-State: APjAAAX4A27Btp8FCf/g3ZCji9bxfxCpfBbLtS5JYK1fv18YJiBoH1wl
        /M5yIrMkrPRcxpEfISqsJAIX6Jh4
X-Google-Smtp-Source: APXvYqyBEOKnBv4DTWDTQEh5LNkmf7QWsmR6EyxkditZrMnWvJ5pqt3iEjz9NeKJxp5CpOsXTQijoQ==
X-Received: by 2002:a9d:664:: with SMTP id 91mr2257990otn.189.1569124771798;
        Sat, 21 Sep 2019 20:59:31 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:31 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 15/20] lpfc: Fix hdwq sgl locks and irq handling
Date:   Sat, 21 Sep 2019 20:59:01 -0700
Message-Id: <20190922035906.10977-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many of the sgl-per-hdwq paths are locking with spin_lock_irq()
and spin_unlock_irq() and may unwittingly raising irq when it
shouldn't. Hard deadlocks were seen around lpfc_scsi_prep_cmnd().

Fix by converting the locks to irqsave/irqrestore.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ff261c0c738a..6d89dd3dd532 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20444,8 +20444,9 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 	struct sli4_hybrid_sgl *allocated_sgl = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->sgl_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(buf_list))) {
 		/* break off 1 chunk from the sgl_list */
@@ -20457,7 +20458,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 		}
 	} else {
 		/* allocate more */
-		spin_unlock_irq(&hdwq->hdwq_lock);
+		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
 				   cpu_to_node(smp_processor_id()));
 		if (!tmp) {
@@ -20479,7 +20480,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 			return NULL;
 		}
 
-		spin_lock_irq(&hdwq->hdwq_lock);
+		spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 		list_add_tail(&tmp->list_node, &lpfc_buf->dma_sgl_xtra_list);
 	}
 
@@ -20487,7 +20488,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 					struct sli4_hybrid_sgl,
 					list_node);
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 
 	return allocated_sgl;
 }
@@ -20511,8 +20512,9 @@ lpfc_put_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 	struct sli4_hybrid_sgl *tmp = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->sgl_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(&lpfc_buf->dma_sgl_xtra_list))) {
 		list_for_each_entry_safe(list_entry, tmp,
@@ -20525,7 +20527,7 @@ lpfc_put_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 		rc = -EINVAL;
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 	return rc;
 }
 
@@ -20546,8 +20548,9 @@ lpfc_free_sgl_per_hdwq(struct lpfc_hba *phba,
 	struct list_head *buf_list = &hdwq->sgl_list;
 	struct sli4_hybrid_sgl *list_entry = NULL;
 	struct sli4_hybrid_sgl *tmp = NULL;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	/* Free sgl pool */
 	list_for_each_entry_safe(list_entry, tmp,
@@ -20559,7 +20562,7 @@ lpfc_free_sgl_per_hdwq(struct lpfc_hba *phba,
 		kfree(list_entry);
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 }
 
 /**
@@ -20583,8 +20586,9 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 	struct fcp_cmd_rsp_buf *allocated_buf = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->cmd_rsp_buf_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(buf_list))) {
 		/* break off 1 chunk from the list */
@@ -20597,7 +20601,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		}
 	} else {
 		/* allocate more */
-		spin_unlock_irq(&hdwq->hdwq_lock);
+		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
 				   cpu_to_node(smp_processor_id()));
 		if (!tmp) {
@@ -20624,7 +20628,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		tmp->fcp_rsp = (struct fcp_rsp *)((uint8_t *)tmp->fcp_cmnd +
 				sizeof(struct fcp_cmnd));
 
-		spin_lock_irq(&hdwq->hdwq_lock);
+		spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 		list_add_tail(&tmp->list_node, &lpfc_buf->dma_cmd_rsp_list);
 	}
 
@@ -20632,7 +20636,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 					struct fcp_cmd_rsp_buf,
 					list_node);
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 
 	return allocated_buf;
 }
@@ -20657,8 +20661,9 @@ lpfc_put_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 	struct fcp_cmd_rsp_buf *tmp = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->cmd_rsp_buf_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(&lpfc_buf->dma_cmd_rsp_list))) {
 		list_for_each_entry_safe(list_entry, tmp,
@@ -20671,7 +20676,7 @@ lpfc_put_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		rc = -EINVAL;
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 	return rc;
 }
 
@@ -20692,8 +20697,9 @@ lpfc_free_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 	struct list_head *buf_list = &hdwq->cmd_rsp_buf_list;
 	struct fcp_cmd_rsp_buf *list_entry = NULL;
 	struct fcp_cmd_rsp_buf *tmp = NULL;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	/* Free cmd_rsp buf pool */
 	list_for_each_entry_safe(list_entry, tmp,
@@ -20706,5 +20712,5 @@ lpfc_free_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		kfree(list_entry);
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 }
-- 
2.13.7

