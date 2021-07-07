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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A115FC07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A90161CD2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhGGSqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhGGSqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCCFC061765
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:06 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v7so3257010pgl.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n8/aFQB7mqMNfN205fqFBT5VKFuSC7RRpVl/FyjQWqA=;
        b=h6BFYwgNxXve2bXHtltGqps2vxJMM5YXPunnHu7QkImBarZ3sIntEYNyeXNuWe3plR
         oQ4fRX5NVfiaGEtXFL8+TXfw/PLYrPspOicQss/WmGBo9L3sl2HVVWdKOeNAUtL/FlAu
         y9PQOtOnf4mEgYpHyFpWuJq8Y/gV4/2pjKBhNh/qOM8BhY1mDZuX5FiiT1FEK8n9ct43
         5HYnHIDxdK3Zf2iR6IxuURBHo8rQNHM7sdUBDLVHvNkGvDaJJyPW6mPoXKPih/kOwsRV
         x8mFR0AcoyjuC1n7nZZrYJY9l1EEDcVLw+GdcQVcJez2ruNsuxOgC0+e6BBoAQpv53cN
         HW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n8/aFQB7mqMNfN205fqFBT5VKFuSC7RRpVl/FyjQWqA=;
        b=SiS5yXgk75t6Ah1T6bX+Jg5eJ1oThhWDlbJC6EMPhdnCXg10KfaX6gMEmmEZAq5jXY
         HMbMEzxesfKzs62QUQO3aUqRDT5uYu2EiQNplM34FmHtoM6ZcFG0AkvwsQHXsfdbZDLe
         Z6bec/jU+TG4IdUjgM2u9OU/AHKgoZcDXSfbsO83m8YvDTSEkREBEt3CslzKglAtd0hW
         AEZXxUWuOhQYGsbMqAg3Nh69t3Qoy6NbL310UA0hTpmZo3rEFkYXnjXW+OPZNGoj7e5L
         53V9puhu8MiuantJiQpVE/ppci++exxuoZf8ZidTGmEO62AB2d4aGSIKr446h/Vm2Cis
         IcWg==
X-Gm-Message-State: AOAM530GfPku2XFjU+p1ddneoJdonpa5UXBAdVbdENok0VNLTX3nOmQ7
        q9zfAbNgQrLOTHLC9lcEgj9JruZkZWo=
X-Google-Smtp-Source: ABdhPJzoleVXqJJ8JS5D17/Ds/o0Ca9GTV0JixkF4GI7q1iQFmyauxjInjwli3aIoKPb/zkeod/urw==
X-Received: by 2002:a65:50ca:: with SMTP id s10mr28064030pgp.68.1625683446180;
        Wed, 07 Jul 2021 11:44:06 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:05 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 16/20] lpfc: Call discovery state machine when handling PLOGI/ADISC completions
Date:   Wed,  7 Jul 2021 11:43:47 -0700
Message-Id: <20210707184351.67872-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the PLOGI and ADISC completion handling, the device removal event
could be skipped during some link errors. This could leave a stale node
in UNUSED state.  Driver unload would hang for a long time waiting for
this node to be freed.

Resolve by taking the following steps:
- Always post ADISC completion events to discovery state machine upon
  ADISC completion.
- In case of a completion error for PLOGI/ADISC, ensure that init
  refcount is dropped if not registered with transport.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 32f5f00f0a85..11e56534b8f0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2031,9 +2031,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->un.ulpWord[4]);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp))
-			goto check_plogi;
-		else
+		if (!lpfc_error_lost_link(irsp))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PLOGI);
 
@@ -2086,7 +2084,6 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					NLP_EVT_CMPL_PLOGI);
 	}
 
- check_plogi:
 	if (disc && vport->num_disc_nodes) {
 		/* Check to see if there are more PLOGIs to be sent */
 		lpfc_more_plogi(vport);
@@ -2755,12 +2752,9 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 "2755 ADISC failure DID:%06X Status:x%x/x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4]);
-		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp))
-			goto check_adisc;
-		else
-			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-						NLP_EVT_CMPL_ADISC);
+
+		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
+				NLP_EVT_CMPL_ADISC);
 
 		/* As long as this node is not registered with the SCSI or NVMe
 		 * transport, it is no longer an active node. Otherwise
@@ -2778,7 +2772,6 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
 
- check_adisc:
 	/* Check to see if there are more ADISCs to be sent */
 	if (disc && vport->num_disc_nodes)
 		lpfc_more_adisc(vport);
-- 
2.26.2

