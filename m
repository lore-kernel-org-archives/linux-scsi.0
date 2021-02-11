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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C1DC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B3D64E55
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhBKXqW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhBKXqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:15 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8CEC061793
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:57 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z6so4735726pfq.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0XxQ4yV1rvBwY9foVXJfXu24f0cd9xTtMnhL/SvermA=;
        b=sdQDnVA5YmAgj6YKoiOH+k2EEay/UDQyRUpD3/hFTg3e4gfeu8EVrev4yw8XYDcQpf
         TSX1IZxKvg/FAo5DQ5NQjJuFxtZVyHUEunhMry3tDRh9eXu4hMyUCxhZHoHUInh0TCG3
         NVAJJc8qpj1E27eQVX8B8h7F7LdaWc9kUHF5SAp/g+IlHpCxveYu5YnqHxLOh3ztTVme
         WytIgu1nZRtPiOiQAlonIgyk7nEGvt4CUzvvtlLzdWLEqnsqcD+rggjEqXU3XUhM5YzG
         eM0SEAGv5DzxNCkGE3TYL5gmwajFQuHuGLvtZNceq4LJ6cSmgqAbNF//5DgX8xBg3P1Y
         pExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0XxQ4yV1rvBwY9foVXJfXu24f0cd9xTtMnhL/SvermA=;
        b=F7/fXkQnb/Fw+fWFDkN3vnDCHQ3ZbaVd5w1kcfB3Yf8DcXZK5Gn/R255ImrNZYujpj
         l45PtQhS8Q8JLaxwNEPtypQIzm2vlF6u+5H+8Jl5reeJ9kogFO7DX4U3hYHq0dxLh0L6
         rB1TZWwHyUBY5bBfKPIpUoZU0XRtfB82eIgovcmcWR7Pq5u0O9xbHR298exyt+R+UiLs
         HhFkYQjE/BO08F+O8+5IthTpLZAk9R7xbxWlbE2Hpmn2AlgsKb6FVjHL30DfqDFj+Q9W
         w6lQtPzM10y0WaepPZqwQxICtxACEM8W3jLzCnki7q9lNvZvuYP3HlX/R5zPjEnoP1HA
         tjlQ==
X-Gm-Message-State: AOAM532Q3B3cckBL9yJ0owjgYsBsEDptA5k1yzo8rI5eqiR99H6fNql7
        P25ID/62aIPq4U1fWLV71Isi6CY4wKc=
X-Google-Smtp-Source: ABdhPJy92r8g8sEI0fle2nBE6BOxOEZWs05fzVXuIAsFG4vYyma4XuoiuPuS4nARTZlKOfqB4/16Gw==
X-Received: by 2002:aa7:9293:0:b029:1df:4e2:c981 with SMTP id j19-20020aa792930000b02901df04e2c981mr476398pfa.41.1613087097295;
        Thu, 11 Feb 2021 15:44:57 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:57 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/22] lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()
Date:   Thu, 11 Feb 2021 15:44:30 -0800
Message-Id: <20210211234443.3107-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
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
index 788cb5d9054c..aabb3f115da2 100644
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

