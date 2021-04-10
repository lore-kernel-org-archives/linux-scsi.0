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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9DDC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 330E0611C1
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhDJRbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhDJRbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB78BC06138C
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:46 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r13so683341pjf.2
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wdBkbtYzW6nob1I+F3ny5IoY4vgoUxoBfRznJfF1Lf4=;
        b=FGcKLaOEv03WgCWbFz09nAdOlwSrDQuNQXVXKPUaXNUy9g8/g2oX71Hpe2XoXauHXd
         rE6qzzdP17728FRlvrA5QA4pL/gxoh+hqFykrIfXlAF0N1tSKExE0jj6RnMx/DOpbnNS
         TfJUAEA4geChJtug5O0W+6gGHZ7XqkvPIMHpsHt6g9WA2xiSNQOMbxFst1fNsqZ5z0b/
         U28PBDKfe4uuYPR6YpYEak+SfsLWARsz33mrrDtKkJHjDpCrJu2JrFl8Ste2c8h7iia+
         YfrbIrwPVPvup6hiBr3x/uacYHy+NDa60Yw4qHEqgl8bnIvtUN8pEQ7we+JZxrAGaZsZ
         jKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wdBkbtYzW6nob1I+F3ny5IoY4vgoUxoBfRznJfF1Lf4=;
        b=al3H+QZWw3bDR4AGnXJRwa88OqGkizsN6Yhx2fSUy3dRYz9yPUlEU1KCBsqARTk+FN
         I2KWclHbPDdoIjlt44keojoALdwrhaVSM5RMuhsZAWF9xxa22XdhnTJR3Fl4wGxGFjdq
         4OVUv7Tu0s509rDNND+nw6F5JEfNpu9VzOGjq1Nlfnc+ewM+L4g+d7wZxPWhrc5YgObR
         ioG2RQyPRqmyX2zaf1eTFM14Icde2k0G4UkRG2lO/hX6c2f0iePlrfueS67OqR94+Lve
         HyizLfOyEaPWW5p/ESl0q9GDeFL7J9YysMb9KYA4VhPNFgO8h7mv6sKvFsF8RlvdRCik
         lHig==
X-Gm-Message-State: AOAM531f1Nxnsa3CHFLHmxDgynjhBcV4As3rtdRNZc69mcEwP4w7AF5Q
        dSsn/owitYAfHalQsa4U/y+Ef+qhvZ0=
X-Google-Smtp-Source: ABdhPJy8KkJfsmWUhhzfI5FYiHk5YjVc03OWJMbtOukGPdcIUV4CX3FdG/AmptvyE8IUpuh/fwky6g==
X-Received: by 2002:a17:902:9a45:b029:e6:1444:5287 with SMTP id x5-20020a1709029a45b02900e614445287mr18455581plv.54.1618075845532;
        Sat, 10 Apr 2021 10:30:45 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:45 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/16] lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
Date:   Sat, 10 Apr 2021 10:30:20 -0700
Message-Id: <20210410173034.67618-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a crash caused by a double put on the node when the driver
completed an ACC for an unsolicted abort on the same node.  The
second put was executed by lpfc_nlp_not_used and is wrong because
the completion routine executes the nlp_put when the iocbq was
released.  Additionally, the driver is issuing a LOGO then
immediately calls lpfc_nlp_set_state to put the node into NPR.
This call does nothing.

Remove the lpfc_nlp_not_used call and additional set_state in the
  completion routine.
Remove the lpfc_nlp_set_state post issue_logo.  Isn't necessary.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 --
 drivers/scsi/lpfc/lpfc_sli.c       | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8472c5e716db..fd3d0197d155 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1901,8 +1901,6 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		lpfc_issue_els_logo(vport, ndlp, 0);
-		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		return ndlp->nlp_state;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7832f8470667..cd9943f91eff 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18071,7 +18071,6 @@ lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc_hba *phba,
 	if (cmd_iocbq) {
 		ndlp = (struct lpfc_nodelist *)cmd_iocbq->context1;
 		lpfc_nlp_put(ndlp);
-		lpfc_nlp_not_used(ndlp);
 		lpfc_sli_release_iocbq(phba, cmd_iocbq);
 	}
 
-- 
2.26.2

