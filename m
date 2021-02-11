Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2868C4332E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8337464E55
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhBKXpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhBKXpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:45:34 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EA8C061786
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:54 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id b21so5066820pgk.7
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hzlsgTfYah0Qt23g2v+3UTHuaupqpIjgpQG5TKl4Dno=;
        b=cwHR0aVuPuN9Vejso9ga6KbAYt7TN2sDA1eBwws0V2HhI5R70Su+AuIJbJp59L+M4D
         xoEUNvvBOSW4jT+nWI1REI/FmjYU3azZKMnYKw7YJjvJITnQr6VAhhMk2mPxOXCogFGi
         3hN4JotmmVDujz6XJHQt2xlER9kw4k6RCmLhNjBrUGBH5aeD/c6QWtIbCp67IAuusVvC
         d4x+RCwIqxwtNZ7+Ifv2JuFkv7XjXGTg9466hJpwORtb3+B1mVwMvatmMofsFfVn0/r5
         g334DgAC0ckcXwWpU+Q6eOkp79jRNmh96IxWVrO93qpUXAVn2LlKLL4c2e5vVKzSeXHG
         b1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hzlsgTfYah0Qt23g2v+3UTHuaupqpIjgpQG5TKl4Dno=;
        b=sBgXn92162nim+xakkLVfKyIYus025d19TLCG0yx09lUgwgvN1r3x31SrwtEXfOG5F
         XeqUmGc5nrl262eyvT/SIpNUQ5CtLk+Y+tSm+fPOf7IriR2kP/Vdh1rP+HqaxuJr5eGx
         QNQRSfoz9nQOKlyiZzvO2qaG0At50mJlmpWexMExgEOi1dGqE2IZURVRg7Zhf9TV+BdN
         ZwfWWfEdQJ9yDlRAZzzT8TML8U2733yG7xIQ1f7f/JKHsHKY+njtLUFeGK4zssyA9URV
         jl3ut56n1BYz7VBTPJu53eBS96R1UE6HAldGI5fgswVLnuaokBTu2S3WoAYEzAro133W
         kzxw==
X-Gm-Message-State: AOAM531MhFdT7F9TOEdeM99u1JUsS48j0/KBxNSVOZK0CG1eTcnzqq0D
        nsYvxrQmv061cNifuq+ZFW8Ep6lsUxo=
X-Google-Smtp-Source: ABdhPJy/Vsp3+0/g/jWz5AHIwXtwk11PQM62C0V7o3lHLsnKJEKzD29ko3w9H6wzneHQnMb7ZWTjTQ==
X-Received: by 2002:a05:6a00:1385:b029:1be:ac19:3a9d with SMTP id t5-20020a056a001385b02901beac193a9dmr467833pfg.65.1613087093445;
        Thu, 11 Feb 2021 15:44:53 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:53 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/22] lpfc: Fix stale node accesses on stale RRQ request
Date:   Thu, 11 Feb 2021 15:44:25 -0800
Message-Id: <20210211234443.3107-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Whenever an RRQ needs to be triggered, the DID from the node structure
and node pointer are stored in the RRQ data structure and the RRQ is
scheduled for later transmission. However, at the point in time that
the timer triggers, there's no validation on the node pointer. Reference
counters may have freed the structure. Additionally the DID in the node
may no longer be valid.

Fix by not tracking the node pointer in the RRQ, only the DID. At the
time of the timer expiration, look up the node with the did and if
present, send the RRQ. If no node exists, no need to send the RRQ.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h |  1 -
 drivers/scsi/lpfc/lpfc_els.c  | 32 ++++++++------------------------
 drivers/scsi/lpfc/lpfc_sli.c  | 18 ++++++++----------
 3 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 8ce13ef3cac3..3bd5bb17035a 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -159,7 +159,6 @@ struct lpfc_node_rrq {
 	uint16_t rxid;
 	uint32_t         nlp_DID;		/* FC D_ID of entry */
 	struct lpfc_vport *vport;
-	struct lpfc_nodelist *ndlp;
 	unsigned long rrq_stop_time;
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d1bb99220495..4687830e06da 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1849,7 +1849,7 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	IOCB_t *irsp;
-	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *ndlp = cmdiocb->context1;
 	struct lpfc_node_rrq *rrq;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
@@ -1862,22 +1862,12 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		irsp->ulpStatus, irsp->un.ulpWord[4],
 		irsp->un.elsreq64.remoteID);
 
-	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
-	if (!ndlp || ndlp != rrq->ndlp) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2882 RRQ completes to NPort x%x "
-				 "with no ndlp. Data: x%x x%x x%x\n",
-				 irsp->un.elsreq64.remoteID,
-				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 irsp->ulpIoTag);
-		goto out;
-	}
-
 	/* rrq completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "2880 RRQ completes to NPort x%x "
+			 "2880 RRQ completes to DID x%x "
 			 "Data: x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
+			 irsp->un.elsreq64.remoteID,
+			 irsp->ulpStatus, irsp->un.ulpWord[4],
 			 irsp->ulpTimeout, rrq->xritag, rrq->rxid);
 
 	if (irsp->ulpStatus) {
@@ -1893,10 +1883,8 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 ndlp->nlp_DID, irsp->ulpStatus,
 					 irsp->un.ulpWord[4]);
 	}
-out:
-	if (rrq)
-		lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
 
+	lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
 	return;
@@ -7619,9 +7607,6 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint16_t cmdsize;
 	int ret;
 
-
-	if (ndlp != rrq->ndlp)
-		ndlp = rrq->ndlp;
 	if (!ndlp)
 		return 1;
 
@@ -7651,9 +7636,9 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		did, rrq->xritag, rrq->rxid);
 	elsiocb->context_un.rrq = rrq;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rrq;
-	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+
+	lpfc_nlp_get(ndlp);
+	elsiocb->context1 = ndlp;
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (ret == IOCB_ERROR)
@@ -7662,7 +7647,6 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
  io_err:
 	lpfc_nlp_put(ndlp);
- node_err:
 	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fa1a714a78f0..99307bb7b62c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -987,16 +987,10 @@ lpfc_clr_rrq_active(struct lpfc_hba *phba,
 {
 	struct lpfc_nodelist *ndlp = NULL;
 
+	/* Lookup did to verify if did is still active on this vport */
 	if (rrq->vport)
 		ndlp = lpfc_findnode_did(rrq->vport, rrq->nlp_DID);
 
-	/* The target DID could have been swapped (cable swap)
-	 * we should use the ndlp from the findnode if it is
-	 * available.
-	 */
-	if ((!ndlp) && rrq->ndlp)
-		ndlp = rrq->ndlp;
-
 	if (!ndlp)
 		goto out;
 
@@ -1118,9 +1112,14 @@ lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		lpfc_sli4_vport_delete_fcp_xri_aborted(vport);
 	}
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list)
-		if ((rrq->vport == vport) && (!ndlp  || rrq->ndlp == ndlp))
+	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
+		if (rrq->vport != vport)
+			continue;
+
+		if (!ndlp || ndlp == lpfc_findnode_did(vport, rrq->nlp_DID))
 			list_move(&rrq->list, &rrq_list);
+
+	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	list_for_each_entry_safe(rrq, nextrrq, &rrq_list, list) {
@@ -1213,7 +1212,6 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	rrq->xritag = xritag;
 	rrq->rrq_stop_time = jiffies +
 				msecs_to_jiffies(1000 * (phba->fc_ratov + 1));
-	rrq->ndlp = ndlp;
 	rrq->nlp_DID = ndlp->nlp_DID;
 	rrq->vport = ndlp->vport;
 	rrq->rxid = rxid;
-- 
2.26.2

