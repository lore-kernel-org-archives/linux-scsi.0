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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6DAC3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723F620820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEcN3lYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfIVD7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:34 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45715 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfIVD7d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:33 -0400
Received: by mail-oi1-f195.google.com with SMTP id o205so4975945oib.12
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hQsowzmgQxVF1VStR0cjXVeaa6Enj5dd81utoiTVYeM=;
        b=TEcN3lYfDO5UIbK3rOlgjDhIWm1zJmpXdPZ0iWG+zVATDiXaEHIGm+h1Ne9EscojGP
         7xTVdsn7q+DhHIBHh2mXGssdDjw+MsCrSA6AqhUvSrMMlCE6Iv7ltlA6v2liGcccIPc+
         OodMP941ofCjfG+HcxeKUh1bvazbe4pncKhF9NqNcdGN4UuwKUf9OL/5kKXA8WwYEZml
         6xthyNq/pe7LWxn52FNGTaIDyBs6nk/wM3vDppdW8Tdh7luTC9UhYM5nJScBYJjhEi5v
         ycvEy5uR94fiwy/b6BP4NN91jsUtDQ8gok214vN295T3aMVJymvtM1FuDIm2L8E2QH9o
         eqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hQsowzmgQxVF1VStR0cjXVeaa6Enj5dd81utoiTVYeM=;
        b=Aoa2Au+Zp/ns7XniS/Lg3U7++VRzINq9ODmnjvbdH9lIkniCBAPlHmRrBgdkoJdQK3
         /TJBBj0P1b6PVqSBoG5eBczsl9SZViNIsay+vFgwGEHh7VebKFfRK6sn+D78yCy5wEKb
         l5ZC5uEF2trhil12+PlIG4kjM9LPk1vk072VvhQxNz55NR78Q9LzQv7lAo6L93wh0ZKe
         2UxVJGhbsWr7ostS33a6DdJM3Wdp9DrFvEfpjbJS702ofSeCaYGZYFht+9buCydQ5Ynp
         4PQbq5ZWnwMmzlwTP+7dLq88bd5lSUTMDtCJMpxSylAV1yyfglvCFj+LmR/618TwoeAt
         /Vuw==
X-Gm-Message-State: APjAAAWPlL4Ha9oHyTzwBQemlcifl9D8S+hLr5Tj1+rXnAwlT/RUC6Re
        7vFA5xNfgeSzY3o4HrUtUwbksl7G
X-Google-Smtp-Source: APXvYqwbMHYZDV/+NyDSexlGepKJM91pJi7y0LrGNRFJ9S9Rh38R2lOyZjMDvzsjZXl2oVaotWyvBA==
X-Received: by 2002:aca:db44:: with SMTP id s65mr9273196oig.103.1569124772858;
        Sat, 21 Sep 2019 20:59:32 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:32 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 16/20] lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq
Date:   Sat, 21 Sep 2019 20:59:02 -0700
Message-Id: <20190922035906.10977-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_release_io_buf, an lpfc_io_buf is returned to the
'available' pool before any associated sgl or cmd and rsp
buffers are returned via their respective 'put' routines.
If xri rebalancing occurs and an lpfc_io_buf structure is
reused quickly, there may be a race condition between release
of old and association of new resources.

Re-ordered lpfc_release_io_buf to release sgl and cmd/rsp
buffer lists before releasing the lpfc_io_buf structure for re-use.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6d89dd3dd532..09e275e3bcd8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20138,6 +20138,13 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 	lpfc_ncmd->cur_iocbq.wqe_cmpl = NULL;
 	lpfc_ncmd->cur_iocbq.iocb_cmpl = NULL;
 
+	if (phba->cfg_xpsgl && !phba->nvmet_support &&
+	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
+		lpfc_put_sgl_per_hdwq(phba, lpfc_ncmd);
+
+	if (!list_empty(&lpfc_ncmd->dma_cmd_rsp_list))
+		lpfc_put_cmd_rsp_buf_per_hdwq(phba, lpfc_ncmd);
+
 	if (phba->cfg_xri_rebalancing) {
 		if (lpfc_ncmd->expedite) {
 			/* Return to expedite pool */
@@ -20202,13 +20209,6 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 		spin_unlock_irqrestore(&qp->io_buf_list_put_lock,
 				       iflag);
 	}
-
-	if (phba->cfg_xpsgl && !phba->nvmet_support &&
-	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
-		lpfc_put_sgl_per_hdwq(phba, lpfc_ncmd);
-
-	if (!list_empty(&lpfc_ncmd->dma_cmd_rsp_list))
-		lpfc_put_cmd_rsp_buf_per_hdwq(phba, lpfc_ncmd);
 }
 
 /**
-- 
2.13.7

