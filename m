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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117B9C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 16:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16A460F4A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 16:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhG3Qd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 12:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhG3QdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2021 12:33:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB18C06175F
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jul 2021 09:33:18 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so21536054pja.5
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jul 2021 09:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0nwD6XTYPEmsLsHNrgKGqslYtt4dO1wy54e7IY0qBik=;
        b=RoKU7FaMpTMNDPDhH5Bb8tcD62pbrURvblCzoW+NZvkjVkCg/+1lMiGddX+VdC0Gu/
         KZYe3BxGnYj3b18w6QB6x/P+RT6/+dH/s/vo7W1d6egqUoKd4omWSpyt1ihfVRblmcD6
         WAkcN8/X/oSkPhVzJisoTwDRTsVenJb52MFGxf5RQLcYRezHRkejb0i7cIFbeBBisxHp
         g3zKsz205ayNkXzkMkhZbSXYMWaYFRM4hYBjtGvHFm9PT/afEpQZ1L4bhNOr2DeEhfIU
         lZA5d6WGzYNz5SwuePah3C8OrPFCPylRx2MIlX5hvqBR9Em9xy3DFnsaYWZhTAJKF4cq
         8R/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0nwD6XTYPEmsLsHNrgKGqslYtt4dO1wy54e7IY0qBik=;
        b=krwjpSmRpbOtlnNK6/c2fbryjB/FExzwWoMgTmmes9zlynQgU68V1ZQ2L9Aq3dyNTe
         zrO1qwl8dzNmcn5uDMcKPILzTHNhDm4vSsYWq2W9CXal64cQzkjfhg1UoU/Y3ZjKUDIX
         EiHstl3RCC0JFjvCOf5+Ucmu5FWuFr1fIZTtcQT9PXzVZVwC0guAxRXx1lLuDyx9r7Pf
         QnMrTz/hXO+lJpztUK7aI2SK50zgZt660OcKFUbP8RzYpFBQrFDeQro0284gm/fZdaB7
         GCDvXqENhIXNBMTrBioGs5zIATnA2Qh+8/U99tft6e/nExhBxEvGqphFS2UQ9CH6dH/+
         3v+Q==
X-Gm-Message-State: AOAM532fWcG1q6b++D2zByAIDeYmape829DnIcYoZE2whYUjiiacS/vY
        etSbY680y6t8GE2fEFfip+o/NhusHr0=
X-Google-Smtp-Source: ABdhPJyb5tWakGUhI80PGdAKE+1lMy9CEFvAvcifHTMyZ4DdorEbSWpFku+PRu41HwFSUsQVhFJGZA==
X-Received: by 2002:a17:90a:bd98:: with SMTP id z24mr3924406pjr.99.1627662798023;
        Fri, 30 Jul 2021 09:33:18 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f24sm2912505pjj.45.2021.07.30.09.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 09:33:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] lpfc: fix possible ABBA deadlock in nvmet_xri_aborted
Date:   Fri, 30 Jul 2021 09:33:09 -0700
Message-Id: <20210730163309.25809-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The lpfc_sli4_nvmet_xri_aborted routine takes out the abts_buf_list_lock
and traverses the buffer contexts to match the xri. Upon match, it then
takes the context lock before potentially removing the context from the
associated buffer list. This violates the lock hierarchy used elsewhere
in the driver of locking context, then the abts_buf_list_lock - thus a
possible deadlock.

Resolve by: after matching, release the abts_buf_list_lock, then take
the context lock, and if to be deleted from the list, retake the
abts_buf_list_lock, maintaining lock hierarchy. This matches same list
lock hierarchy as elsewhere in the driver

Reported-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f2d9a3580887..6e3dd0b9bcfa 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1797,19 +1797,22 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		if (ctxp->ctxbuf->sglq->sli4_xritag != xri)
 			continue;
 
-		spin_lock(&ctxp->ctxlock);
+		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock,
+				       iflag);
+
+		spin_lock_irqsave(&ctxp->ctxlock, iflag);
 		/* Check if we already received a free context call
 		 * and we have completed processing an abort situation.
 		 */
 		if (ctxp->flag & LPFC_NVME_CTX_RLS &&
 		    !(ctxp->flag & LPFC_NVME_ABORT_OP)) {
+			spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
 			list_del_init(&ctxp->list);
+			spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
 			released = true;
 		}
 		ctxp->flag &= ~LPFC_NVME_XBUSY;
-		spin_unlock(&ctxp->ctxlock);
-		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock,
-				       iflag);
+		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 
 		rrq_empty = list_empty(&phba->active_rrq_list);
 		ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
-- 
2.26.2

