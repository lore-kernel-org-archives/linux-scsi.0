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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AB4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 14:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D628461178
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 14:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhIUObr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 10:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhIUObp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 10:31:45 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66BEC061574
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 07:30:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so2029985pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 07:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jIaPbLgyhPhHpZ+oXGN1txCITfY2rCSJERJhFTy0SME=;
        b=GzYMn6wPOuwJCoeB1x0ROwJzCRmXav7JAZMkPGJ0R/Kc8Ivs0zOg13v0lJGuCqqJ3n
         ySNgceRRMXlfLwKS5EWv1suJBQ+ZGPQzNphoJQ6p2GidxJuyfvmUiK0t6KMTTRKWdhAm
         lMQbl30/kdXv053CSny8v2OLFLOgkzzMiGIsdFkf0oiOZWN5OA4lKq4z6/Oxthk6Nt0L
         hFt2vUoP+afwzlmBn3v/0sMYLbm7ZmjZYVRHsi8iQMKZQnjbIYAEruUCcsBhzdV6NBck
         FXnozgFxjNSXKt8TGmADaN34bzXf+9c11T1ote7yOwBniQM0N+v7dcBVtBad1BaoQP3L
         bScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jIaPbLgyhPhHpZ+oXGN1txCITfY2rCSJERJhFTy0SME=;
        b=Dr9spEj89oaJ7/s4v0r/9viKZlDRixZfIf9/KKPpsZfhjZPWSwYIIivUSoEKoKtXJp
         BWzfMLGQbtQ5y1fYAsZHj3eBx/XU3YKPzZCpD3AgRKMHQsli/1LhO7m8FvZl5XOh+dJT
         rFkfrfiRQqjE2RN085ndKlyWECV2Qp12vSy5lehYeEv1vGmOkcxSGl/b3eKPIWWLPGfk
         uZdWfBvx58/FZamZgWWiojfHUp7BDwSsq8uD+Xl46JQY1TGPqlt3yvnIARvFxC/khtKM
         2y1IzCn9WljpE8s1pWi91cW3jWz+EnAN8aQLarK1bx0jr4rSqr0cHvc3izpyxFxT5rYM
         JUkQ==
X-Gm-Message-State: AOAM530jygEvkdcoKHOWQwMP7WbierH/urw+BkN8H+3ZEECmRJocSesT
        q2ZXPS6eco7YLdntIs6fR6ds5fe3qf6MHQ==
X-Google-Smtp-Source: ABdhPJxzSfxzAcCKtf/ZfObLkxDbZxONl0LlXUq3fzssnDZogOa0OONx5VXxGB+85U7VHf60U1+qeQ==
X-Received: by 2002:a17:903:32c6:b0:13b:9cd4:908d with SMTP id i6-20020a17090332c600b0013b9cd4908dmr28012971plr.20.1632234615321;
        Tue, 21 Sep 2021 07:30:15 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id 75sm13886285pfx.134.2021.09.21.07.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 07:30:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Nigel Kirkland <nkirkland2304@gmail.com>
Subject: [PATCH] lpfc: Fix mailbox command failure during driver initialization
Date:   Tue, 21 Sep 2021 07:30:08 -0700
Message-Id: <20210921143008.64212-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Contention for the mailbox interface may occur during driver
initialization (immediately after a function reset), between mailbox
commands initiated via ioctl (bsg) and those driver requested by the
driver.

After setting SLI_ACTIVE flag for a port, there is a window in which
the driver will allow an ioctl to be initiated while the adapter is
initializing and issuing mailbox commands via polling. The polling
logic then gets confused.

Correct by having thread setting SLI_ACTIVE spot an active mailbox
command and allow it complete before proceeding.

Co-developed-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 34cf2bfcce07..3f911cb48cf2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8158,6 +8158,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_rqb *rqbp;
+	u32 flg;
 
 	/* Perform a PCI function reset to start from clean */
 	rc = lpfc_pci_function_reset(phba);
@@ -8171,7 +8172,17 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	else {
 		spin_lock_irq(&phba->hbalock);
 		phba->sli.sli_flag |= LPFC_SLI_ACTIVE;
+		flg = phba->sli.sli_flag;
 		spin_unlock_irq(&phba->hbalock);
+		/* Allow a little time after setting SLI_ACTIVE for any polled
+		 * MBX commands to complete via BSG.
+		 */
+		for (i = 0; i < 50 && (flg & LPFC_SLI_MBOX_ACTIVE); i++) {
+			msleep(20);
+			spin_lock_irq(&phba->hbalock);
+			flg = phba->sli.sli_flag;
+			spin_unlock_irq(&phba->hbalock);
+		}
 	}
 
 	lpfc_sli4_dip(phba);
@@ -9755,7 +9766,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 					"(%d):2541 Mailbox command x%x "
 					"(x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
@@ -9789,7 +9800,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 					"(%d):2597 Sync Mailbox command "
 					"x%x (x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
-- 
2.26.2

