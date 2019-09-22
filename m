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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97A3C3A5A6
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD2B120B7C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBo3dmqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfIVD7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:30 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43665 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfIVD73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:29 -0400
Received: by mail-ot1-f66.google.com with SMTP id o44so932271ota.10
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iLeIj0WGimlt6/z5APbjhpJoZj8auUfK6x3Y1RpGnzY=;
        b=gBo3dmqbJy8cmSh7OziO74raIDMkTC2ABHjTQ8Mc1ajJPf3HJfRvoec6CyCuSZogHW
         PGl7kfjCzg9+MmcZ6YW+mLxckRjkjVn5P2v0VY2ANEAd+u7GMtqAflpwEHrc1jVWQaLU
         K4jPpyoIM7EHQ5iAzADnogYvl5zS+xURAyupBAPaSjiogIk7vvtGLKgfTsc6j6H66D4m
         7I65ScPPA+X+V0V6d62/CcWfMIy6q+Dr3OYV0hzgup0vPMjIxFbhS/uoS3Ad9CRIG8f9
         CHFCysffJdJgU25cxj5oiFMbztGuIxnAdzj8WoiNyziM3uIGR4hGpGd0/jdskx4MnSCZ
         J9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iLeIj0WGimlt6/z5APbjhpJoZj8auUfK6x3Y1RpGnzY=;
        b=pQ4g8wweetakDvQtyCWduiq6KxdDnPY6a8G5B6yvbtAsdgcGhMoUaTtrb9iSwkpC96
         dVWRUkfgO9rOoUDDnP0XytNAQn21/K79WblOQWXItoOGQuFl8UuvXQxSX3Ft2QZJ+eNu
         Wyt6wwr6U8rPmTFUf7XWlIu4h8im22KiPjwV/PeiG4N6bvPwOfi1p8T36uSly8wCAm6A
         cwYpJ3U47A9Xu2F9JJLJ13swWlxAXdBJ1ArD6L8HL8oWyMFqEO/1JpmUOl6R8xGHmn2G
         MrRV5X1TfjAFMqy2afZxyRdcYwVsPUvW5QbPelcCVf/D4Jk8Glhm1MEnvrDYz3SqhGru
         TvBA==
X-Gm-Message-State: APjAAAWgrfGiHK1WzP23LdGl7WkIJcDhFRXArDAO/CBxooAA3SU8OFgT
        0mVLJPbP85ysfg0l2VuxwjHNaMVJ
X-Google-Smtp-Source: APXvYqz28ccYTu2K+PFJkB1aLhApAGNnv92CJECIZKyqo82vg+vDj5KxL/flmcnCkO9hRQQlY3KGbQ==
X-Received: by 2002:a9d:3f26:: with SMTP id m35mr17527018otc.66.1569124768861;
        Sat, 21 Sep 2019 20:59:28 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/20] lpfc: Fix host hang at boot or slow boot
Date:   Sat, 21 Sep 2019 20:58:58 -0700
Message-Id: <20190922035906.10977-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Scenarios were seen where a host hung when the system booted
or the host was very slow in booting. The link would not come
up and no luns were visible to the host.

After investigation, this was found to be due to the introduction
of a new ACQE that adapter may generate to report a adapter hw
warning. The ACQE was delivered to the driver very early in
adapter initialization, when the driver did not expect command
completion. As part of handling this unexpected interrupt the
an EQEs are consumed and discarded and the EQ rearmed. The issue
is the CQ that cause the EQE and thus the interrupt was not
processed and the CQ was left unarmed. Meaning it would no longer
generate a new interrupt condition. Subsequent mailbox commands
used to initialize the adapter use the same CQ, and as there was
no completion interrupt generated, the driver never saw the
mailbox commands complete and it would wait long command timeouts.

Fix by having the early flush routine also process the related CQ
and rearm the CQ.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 939efee6b5dd..412cd8c56d90 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -87,6 +87,10 @@ static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba,
 				     struct lpfc_eqe *eqe);
 static bool lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba);
 static bool lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba);
+static struct lpfc_cqe *lpfc_sli4_cq_get(struct lpfc_queue *q);
+static void __lpfc_sli4_consume_cqe(struct lpfc_hba *phba,
+				    struct lpfc_queue *cq,
+				    struct lpfc_cqe *cqe);
 
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
@@ -467,21 +471,47 @@ __lpfc_sli4_consume_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
 }
 
 static void
-lpfc_sli4_eq_flush(struct lpfc_hba *phba, struct lpfc_queue *eq)
+lpfc_sli4_eqcq_flush(struct lpfc_hba *phba, struct lpfc_queue *eq)
 {
-	struct lpfc_eqe *eqe;
-	uint32_t count = 0;
+	struct lpfc_eqe *eqe = NULL;
+	u32 eq_count = 0, cq_count = 0;
+	struct lpfc_cqe *cqe = NULL;
+	struct lpfc_queue *cq = NULL, *childq = NULL;
+	int cqid = 0;
 
 	/* walk all the EQ entries and drop on the floor */
 	eqe = lpfc_sli4_eq_get(eq);
 	while (eqe) {
+		/* Get the reference to the corresponding CQ */
+		cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
+		cq = NULL;
+
+		list_for_each_entry(childq, &eq->child_list, list) {
+			if (childq->queue_id == cqid) {
+				cq = childq;
+				break;
+			}
+		}
+		/* If CQ is valid, iterate through it and drop all the CQEs */
+		if (cq) {
+			cqe = lpfc_sli4_cq_get(cq);
+			while (cqe) {
+				__lpfc_sli4_consume_cqe(phba, cq, cqe);
+				cq_count++;
+				cqe = lpfc_sli4_cq_get(cq);
+			}
+			/* Clear and re-arm the CQ */
+			phba->sli4_hba.sli4_write_cq_db(phba, cq, cq_count,
+			    LPFC_QUEUE_REARM);
+			cq_count = 0;
+		}
 		__lpfc_sli4_consume_eqe(phba, eq, eqe);
-		count++;
+		eq_count++;
 		eqe = lpfc_sli4_eq_get(eq);
 	}
 
 	/* Clear and re-arm the EQ */
-	phba->sli4_hba.sli4_write_eq_db(phba, eq, count, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_write_eq_db(phba, eq, eq_count, LPFC_QUEUE_REARM);
 }
 
 static int
@@ -14236,7 +14266,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		spin_lock_irqsave(&phba->hbalock, iflag);
 		if (phba->link_state < LPFC_LINK_DOWN)
 			/* Flush, clear interrupt, and rearm the EQ */
-			lpfc_sli4_eq_flush(phba, fpeq);
+			lpfc_sli4_eqcq_flush(phba, fpeq);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return IRQ_NONE;
 	}
-- 
2.13.7

