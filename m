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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1C5C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E5D665075
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbhCAR03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbhCARV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:28 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9608EC061225
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:39 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g20so10332282plo.2
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rlvTP1LxTWr1Jm68l9z5rIe/zD5lnVcwmYbosICTVDY=;
        b=NitEf58P0VdqBcT9ZVUgrAlcg9mCg1CRgfhG9o6A3wIADecwd+SYb/PiZ+nQYQEv+K
         l29M2AceMJYsgB+9rc4DMpv5tmnVoYRfAQsBbYWVIQg7Ew0qIMBmoh6ZFQjZjwemXHgW
         Mr1A7crBhM9vRized088IqKKRsHDXs6WqHf+0v9do8+5jM9DIvaN4HNovWbLL+liyMws
         Njo0/FZnaaO2DzjBcMBEVh44Yuoi5rzHaIc+xBlMMXykxJUMJfOU7/WiZXSlV+F+w5MY
         mCTtptt3oW/0uBjJxx4kT0v7QTCH+1e7yzYCblemTzDUHMah4W51SHUQ6qZKFA1wMKee
         4bKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rlvTP1LxTWr1Jm68l9z5rIe/zD5lnVcwmYbosICTVDY=;
        b=MIy14P+MSGbVF5++H8/CDyiierciVMEZMMBTpcF5RtO6togKcfevZZn2Q7s/YKmnjj
         +6sWaGJVyPtPtP3k2alexOqaBYcoAjwKrNpfYcS/GeOVsqupGvyr5GRnMywiPi1r3oXn
         W/ioDdFX3IFznfEBCjslKyRcmRZfrc1v1vZBcG/a9k1AEOuWUrkG9isD34gocoZ49Cki
         MqNqd85bOknI8hIk7eOknJzXcPOFZQSH+i7Gv4L9sMlyCKI+wDCtf1KJMwNH7ifLZ0YB
         lGKu84DwjaUJoE5feRgUQ4dut9PrtoFKEsrQuy9CZGP9Y8gBTvkVHP24Z4gtBMkBIi54
         CAYQ==
X-Gm-Message-State: AOAM532SKPgX66o22IwddVfM0THTV4258bxYl7KGvRS/yvYSPuprZeIM
        sbtVSU5nWe4cacR1RRxrSo8R0aNBR8Q=
X-Google-Smtp-Source: ABdhPJxoNTb3TKneot9nozx6g3ICMZ+uxbSvY/2QDcuUiShv9wvE69405SIIYkI3pUZHo+4Wu+C98g==
X-Received: by 2002:a17:90a:2ec6:: with SMTP id h6mr18714317pjs.103.1614619118960;
        Mon, 01 Mar 2021 09:18:38 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:38 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 17/22] lpfc: Fix crash caused by switch reboot
Date:   Mon,  1 Mar 2021 09:18:16 -0800
Message-Id: <20210301171821.3427-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver is causing a crash in __lpfc_sli_release_iocbq_s4() when it
dereferences the els_wq which is NULL.

Validate the pring for the els_wq before dereferencing. Reorg the code
to move the pring assignment closer to where it is actually used.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 56112c9fb6aa..941540fe67ba 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1403,7 +1403,6 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 			goto out;
 		}
 
-		pring = phba->sli4_hba.els_wq->pring;
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 			(sglq->state != SGL_XRI_ABORTED)) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
@@ -1426,9 +1425,9 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 				      &phba->sli4_hba.lpfc_els_sgl_list);
 			spin_unlock_irqrestore(
 				&phba->sli4_hba.sgl_list_lock, iflag);
-
+			pring = lpfc_phba_elsring(phba);
 			/* Check if TXQ queue needs to be serviced */
-			if (!list_empty(&pring->txq))
+			if (pring && (!list_empty(&pring->txq)))
 				lpfc_worker_wake_up(phba);
 		}
 	}
-- 
2.26.2

