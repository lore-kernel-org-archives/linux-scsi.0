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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BC4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88EB065237
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbhCARZT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhCARUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:20:42 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAF0C061356
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:33 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id s23so12341133pji.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jNuLSKQq7RrfxOL1plioAEYn9nk9pxIG4P7Vdaci6PA=;
        b=pJOOXVse0dHRKjm8SE0Wx1qATCWdtEJ81c4YIngB8gAxlfZXQm2L5xkG28yEqyoEWX
         EZpGMQztqCYZPi0XTzJe8qVTibROVoi782XDWKgzG2LNIZfDeOLWahVa+rRk+pvSiXvd
         dqjyjq6sravBCYl3DCpZdQpITW5lygC/sgjC5bS813hlT61/bSnJjAJrPvnH6uePf9wS
         sRzWhvindBLNNRwIqy73Y3ENLk+gRYfmAynaTItMRBMrD4fOYNncRXkZh/fE9WPAzLaN
         PV2Kc85BDXj3uhi9hL4thFuNf0WvU82OvsM43iSFpI4aL16h0KGowfqBRKx3K/WOQZot
         RzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jNuLSKQq7RrfxOL1plioAEYn9nk9pxIG4P7Vdaci6PA=;
        b=dqhF3yGBfFJoC1eg1kJhNvTs7M0aBcCSQnbUfgzCdqNOEF5dNQylubpB6F5fH3Vh5O
         rRzM0Jl+xOf6oGmmbJZfPuzxQww7sdGqYRoHt9UM6obQJUJqm20X5c6thli7R+CinyOu
         IG7kl7SxW6mfhqIgCzrUs9MuifcDCekO3UR4d5LgwXvHwTLNT307pDMDumZhSuSMfAIK
         96NibIzzzT/3HraY3IJ6/RKbD1+hiJt7kuIUAn3yeyNuHXs7e1fHbZY1h+YIxM0nX2Ae
         lgZp5mPSP+clCn/e6LllxjusA1/pv9Cc4l9Wkd7HTfHuKCekEySPyi6eN2nyAtniQaEx
         zgVA==
X-Gm-Message-State: AOAM532RiqT5JbLzFF9bFtaj4vlEg3X7t8LX+kSXPyo9Mklf9uqQwDcV
        VAO6nXrYhLcka26PyvGvlkKrjZcqkoE=
X-Google-Smtp-Source: ABdhPJwdcCKruExvYcqhBk3lhqFHY61VS5JPVek6HedI69xX67/s4f3903g7xS/y6fJBUKe32x+WKA==
X-Received: by 2002:a17:90b:120f:: with SMTP id gl15mr7876272pjb.77.1614619112798;
        Mon, 01 Mar 2021 09:18:32 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:32 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 09/22] lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()
Date:   Mon,  1 Mar 2021 09:18:08 -0800
Message-Id: <20210301171821.3427-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is possible to call lpfc_issue_els_plogi() passing a did for which
no matching ndlp is found. A call is then made to lpfc_prep_els_iocb()
with a null pointer to a lpfc_nodelist structure resulting in a null
pointer dereference.

Fix by returning an error status if no valid ndlp is found. Fix up comments
regarding ndlp reference counting.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 50 +++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e0454c53267b..de67ba76374a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -2052,13 +2052,12 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * This routine issues a Port Login (PLOGI) command to a remote N_Port
  * (with the @did) for a @vport. Before issuing a PLOGI to a remote N_Port,
  * the ndlp with the remote N_Port DID must exist on the @vport's ndlp list.
- * This routine constructs the proper feilds of the PLOGI IOCB and invokes
+ * This routine constructs the proper fields of the PLOGI IOCB and invokes
  * the lpfc_sli_issue_iocb() routine to send out PLOGI ELS command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the PLOGI ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding
+ * the ndlp and the reference to ndlp will be stored into the context1 field
+ * of the IOCB for the completion callback function to the PLOGI ELS command.
  *
  * Return code
  *   0 - Successfully issued a plogi for @vport
@@ -2076,29 +2075,28 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	int ret;
 
 	ndlp = lpfc_findnode_did(vport, did);
+	if (!ndlp)
+		return 1;
 
-	if (ndlp) {
-		/* Defer the processing of the issue PLOGI until after the
-		 * outstanding UNREG_RPI mbox command completes, unless we
-		 * are going offline. This logic does not apply for Fabric DIDs
-		 */
-		if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
-		    ((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
-		    !(vport->fc_flag & FC_OFFLINE_MODE)) {
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-					 "4110 Issue PLOGI x%x deferred "
-					 "on NPort x%x rpi x%x Data: x%px\n",
-					 ndlp->nlp_defer_did, ndlp->nlp_DID,
-					 ndlp->nlp_rpi, ndlp);
-
-			/* We can only defer 1st PLOGI */
-			if (ndlp->nlp_defer_did == NLP_EVT_NOTHING_PENDING)
-				ndlp->nlp_defer_did = did;
-			return 0;
-		}
+	/* Defer the processing of the issue PLOGI until after the
+	 * outstanding UNREG_RPI mbox command completes, unless we
+	 * are going offline. This logic does not apply for Fabric DIDs
+	 */
+	if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
+	    ((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
+	    !(vport->fc_flag & FC_OFFLINE_MODE)) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "4110 Issue PLOGI x%x deferred "
+				 "on NPort x%x rpi x%x Data: x%px\n",
+				 ndlp->nlp_defer_did, ndlp->nlp_DID,
+				 ndlp->nlp_rpi, ndlp);
+
+		/* We can only defer 1st PLOGI */
+		if (ndlp->nlp_defer_did == NLP_EVT_NOTHING_PENDING)
+			ndlp->nlp_defer_did = did;
+		return 0;
 	}
 
-	/* If ndlp is not NULL, we will bump the reference count on it */
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp, did,
 				     ELS_CMD_PLOGI);
-- 
2.26.2

