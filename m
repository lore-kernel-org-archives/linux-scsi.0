Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11F8C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbjEWSWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbjEWSW0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:26 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8F091
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:24 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1ae7dd22ea1so8345055ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866144; x=1687458144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=juio/Pg9uYgzAgvMiskTq/T9tNY5BZWX96HW+U6JJf0=;
        b=FQo0qt0fLxvaYTpW/1WTW7/Nn/vJtoHG+MY+RXoOMNiIZSiOadVUeS1J9QrdNKzIvf
         0mhCJg5vsnJ5wS5mLfAgS3vcc77cYe5JBBQZuHybNP8cdztkfW9+x4F9HnPM/fRu8+P4
         HhBiTGCkfBttizUgT9SeBYItCEeLuRphOFD0Hdky9GAclDizjf330D2NSin0q1cW1+uH
         N+gxgZx5oUyiO4eABRhO9T1koVALZuKdgLIDLAgZfgDxVvk7cnTlCDOWnTDXqe2T2u+A
         GjqrIXl8RfQzEDI2eUVb2R7fmYcpoZIHrKABhyL0D0b8GREZ9I864jxvm9gfMIqPVfiB
         Xdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866144; x=1687458144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=juio/Pg9uYgzAgvMiskTq/T9tNY5BZWX96HW+U6JJf0=;
        b=AWMzP6oXN7Z1+t94l6Q89YbcbXiJ8ofjogvMwP41pTZdJESeosUllrKMnpWHPQfOs/
         U7jDrwQkLyFo+0114RvQQUqaj/Lp2ECs6HNR7TWfWOvPyWfY8XcczYnT6sMMHTzzvxgK
         f5o2/5HDUOtFq5syzMUgqI3o9eubN7zlv1Sx/31ll+5CKzvGcSTQKx9NAhvS7DzuqGlM
         HtEhlTHAaoySGYDCvi59F0E4t4XTM+GYV5cxgCQAWsq9ptYxu6EmLbDOneb3YTSHLLU9
         aFzcJr/bsIjnP/gRJiLmn3cgjlgAGVPiyCvpubmMvVTkXbRLMx7wm0QvUwTGFhPG+afX
         tWCg==
X-Gm-Message-State: AC+VfDwNusGbLLwgDwhaG6HJ/XcwdRpnfOSYA5eZd/oYOIIDZ9ivOB6f
        fIKclvOoHXgRx29Eu4Nzh7UKcMFAQHs=
X-Google-Smtp-Source: ACHHUZ6AwDT+Fqf/kDke84wi/b8HCfV/HqYOkyFxHvSEk6d/N0HQNTJiBOFuGCeunafs++AtN+BRzg==
X-Received: by 2002:a17:902:d4cb:b0:1af:a349:3f31 with SMTP id o11-20020a170902d4cb00b001afa3493f31mr10352079plg.3.1684866144180;
        Tue, 23 May 2023 11:22:24 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:23 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/9] lpfc: Revise NPIV ELS unsol rcv cmpl logic to drop ndlp based on nlp_state
Date:   Tue, 23 May 2023 11:32:01 -0700
Message-Id: <20230523183206.7728-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When NPIV ports are zoned to devices that support both initiator and target
mode, a remote device's initiated PRLI results in unintended final kref
clean up of the device's ndlp structure.  This disrupts NPIV ports'
discovery for target devices that support both initiator and target mode.

Modify the NPIV lpfc_drop_node clause such that we allow the ndlp to live
so long as it was in NLP_STE_PLOGI_ISSUE, NLP_STE_REG_LOGIN_ISSUE, or
NLP_STE_PRLI_ISSUE nlp_state.  This allows lpfc's issued PRLI completion
routine to determine if the final kref clean up should execute rather than
a remote device's issued PRLI.

Fixes: db651ec22524 ("scsi: lpfc: Correct used_rpi count when devloss tmo fires with no recovery")

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a3c8550e9985..2bad9954c355 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5452,9 +5452,19 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
 				spin_unlock_irq(&ndlp->lock);
 			}
+			lpfc_drop_node(vport, ndlp);
+		} else if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
+			   ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE &&
+			   ndlp->nlp_state != NLP_STE_PRLI_ISSUE) {
+			/* Drop ndlp if there is no planned or outstanding
+			 * issued PRLI.
+			 *
+			 * In cases when the ndlp is acting as both an initiator
+			 * and target function, let our issued PRLI determine
+			 * the final ndlp kref drop.
+			 */
+			lpfc_drop_node(vport, ndlp);
 		}
-
-		lpfc_drop_node(vport, ndlp);
 	}
 
 	/* Release the originating I/O reference. */
-- 
2.38.0

