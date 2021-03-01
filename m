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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C779FC433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE6C65268
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbhCAR2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbhCARVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DA4C061222
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:37 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id i4-20020a17090a7184b02900bfb60fbc6bso2633111pjk.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DjTFs4AXMpRwa/jiNwB+LIMmXJAeYZ96/u3n8gyX/IQ=;
        b=MVFbe/wHf1csfLveQxVlvqoOUDRvfhtK9a5KJZShA76c9qwMSToSBHf2WmPKD4HXyJ
         IEAO/3vi8E68Sym6hDqY6Pg2fJ7Om+sHlyEAA6kXhPy9GWHce/wz02fzaEItz0rVcGf2
         daGJbvb7lQvImDE4o1WmqGFWSnb6hbgFvjwl+7lDiVlVhpR7qKnoH2XjaHwgScyEr9VH
         u86GP8+M41DOMTy/hiVxv2qCmTCp52xJzRRw0xYt/S2JGgK9JszLLVenBM7dCbqvjdFj
         WgBUPb/5i0Xld5Fq6Tap8n1UwD/xqnL9ccFXMC784Za9MxSmLSAxHPv+cmfdP9a2jzdI
         pgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DjTFs4AXMpRwa/jiNwB+LIMmXJAeYZ96/u3n8gyX/IQ=;
        b=SVWmqAuPHZgcaTHK1HZsMSvQVGQ09M33BRAMxzFnSlouSoi5QFeZ+r53J0AXJOUnzg
         MwzWQIGiRBQzNDc3HNqFPmBJl1xjLYUZKhBXIyKq/oiD1EHuZKcvA3axESje1cPVjd2E
         EwQfYOlS1vd8+TSaEM+40hXgghn2/TyBiZ75I3UJf7XtUa+EI1auqxGAxaKRqDHNLZ/P
         HPkDDt83Tv6fFuR4maujxNy+4aEzZcjdmrgM2GdewTPmqLCJCH5kGo9mzsGYilYzqAvQ
         6h5Wf8grsXES3Sd3nzLWyJKugNC5vdElii7ZSl1ffA3v5SptBiE97tY0m9il0DBix8AE
         RXAg==
X-Gm-Message-State: AOAM530CIm5OkKdMXTFXhLOay/x0T5YUM+9FpU9D5QTGIjBSxPNWavZm
        qQSGffSuwKbvir9kxPHzRZOOEqKmky4=
X-Google-Smtp-Source: ABdhPJztwy0nIukHYD1tIgJ4UdGPk495f6Xd8+qWxxKnmwyuOguTpXswK8cRN3r4eNonmX0xgzwW/g==
X-Received: by 2002:a17:90a:154e:: with SMTP id y14mr10192059pja.229.1614619116631;
        Mon, 01 Mar 2021 09:18:36 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:36 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 14/22] lpfc: Fix ADISC handling that never frees nodes
Date:   Mon,  1 Mar 2021 09:18:13 -0800
Message-Id: <20210301171821.3427-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While testing target port swap test with ADISC enabled, several nodes
remain in UNUSED state. These nodes are never freed and rmmod hangs
for long time before finising with "0233 Nodelist not empty" error.

During PLOGI completion lpfc_plogi_confirm_nport() looks for existing
nodes with same WWPN. If found, the existing node is used to continue
discovery. The node on which plogi was performed is freed.  When ADISC
is enabled, an ADISC els request is triggered in response to an RSCN.
It's possible that the ADISC may be rejected by the remote port causing
the ADISC completion handler to clear the port and node name in the node.
If this occurs, if a PLOGI is received it causes a node lookup based on
wwpn to now fail, causing the port swap logic to kick in which allocates
a new node and swaps to it. This effectively orphans the original node
structure.

Fix the situation by detecting when the lookup fails and forgo the node
swap and node allocation by using the node on which the PLOGI was issued.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0e92a0b61e77..9f81113208b8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1608,7 +1608,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct lpfc_nodelist *new_ndlp;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
-	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
+	uint32_t keepDID = 0, keep_nlp_flag = 0;
 	uint32_t keep_new_nlp_flag = 0;
 	uint16_t keep_nlp_state;
 	u32 keep_nlp_fc4_type = 0;
@@ -1630,7 +1630,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
 	/* return immediately if the WWPN matches ndlp */
-	if (new_ndlp == ndlp)
+	if (!new_ndlp || (new_ndlp == ndlp))
 		return ndlp;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -1649,30 +1649,11 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			 (new_ndlp ? new_ndlp->nlp_flag : 0),
 			 (new_ndlp ? new_ndlp->nlp_fc4_type : 0));
 
-	if (!new_ndlp) {
-		rc = memcmp(&ndlp->nlp_portname, name,
-			    sizeof(struct lpfc_name));
-		if (!rc) {
-			if (active_rrqs_xri_bitmap)
-				mempool_free(active_rrqs_xri_bitmap,
-					     phba->active_rrq_pool);
-			return ndlp;
-		}
-		new_ndlp = lpfc_nlp_init(vport, ndlp->nlp_DID);
-		if (!new_ndlp) {
-			if (active_rrqs_xri_bitmap)
-				mempool_free(active_rrqs_xri_bitmap,
-					     phba->active_rrq_pool);
-			return ndlp;
-		}
-	} else {
-		keepDID = new_ndlp->nlp_DID;
-		if (phba->sli_rev == LPFC_SLI_REV4 &&
-		    active_rrqs_xri_bitmap)
-			memcpy(active_rrqs_xri_bitmap,
-			       new_ndlp->active_rrqs_xri_bitmap,
-			       phba->cfg_rrq_xri_bitmap_sz);
-	}
+	keepDID = new_ndlp->nlp_DID;
+
+	if (phba->sli_rev == LPFC_SLI_REV4 && active_rrqs_xri_bitmap)
+		memcpy(active_rrqs_xri_bitmap, new_ndlp->active_rrqs_xri_bitmap,
+		       phba->cfg_rrq_xri_bitmap_sz);
 
 	/* At this point in this routine, we know new_ndlp will be
 	 * returned. however, any previous GID_FTs that were done
-- 
2.26.2

