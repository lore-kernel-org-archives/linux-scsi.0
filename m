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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F107C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2857164E45
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhBKXqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhBKXqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:17 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3447EC0617AA
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:01 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id w18so4714067pfu.9
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CxsMad5k/3ffEXYeNG0RvxIidWONStWnXltbzLNu+Js=;
        b=eUZHnC41Tqfn23dGqijyguRg8BeBPoGjWUVtr6u8FFNT43SOXw4YdpEgcjrDETaG+w
         PdHnUCd8EdqfmxpSi7GlfPNiytqdBY6ByBcaCCeAoWO6f0t8Z4EfXfn9rIO6SDlWf7If
         By1mEn7GwIOnI22X2D8M/MYL1bSu/Sv2mkwaypzf6vvFWgimzV0H5tbUhUrco7bIdgTd
         731uOXjHWtuP9LvtHELNWHMqcWB+mhwAeMT44C0LqbQNjAX3hv9nqMejpZpBqoCsDUVm
         8mbs6MyaQhVQjxbw+FDk751pwJ6dhGjKFLbMOMcxt+y9SuwcEpiNAV7GtX5HtFsz04Ri
         3VDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CxsMad5k/3ffEXYeNG0RvxIidWONStWnXltbzLNu+Js=;
        b=Mq2RG1XrsHG4gUBgga9xU/Po0oK0F8t7r2XjmKFflYFAFYOXGmIbO90OrNoEIRjQZD
         Q2HWtSiXS35qN12OjVsQF5tlRLvTEgfOfGTsnklIU8JXU1ko4NQAJ7/UsUCDb9sMuULU
         KRZ1rnCDu9oLGZttrbisgHGAND/Hg+2qHsE/p5pllQARMNxS6+9u9jy75hrKLRP9sMnl
         KaT6cPTsiyVYrYOcuMMzhy/iRIfvjMfwXP/Sl8y5eEJ+CElanScG4wfOxsnzOympVR9W
         hZLUbPFCTtLQ46+zY05KG6WU888gvs99FEmYl3p2MIU4H93Bcbt6w2zoyh0JsY651v9G
         +U3Q==
X-Gm-Message-State: AOAM531ACIQWXEMXuPbZoYYdoy2HaXoTKsWJdK0dqzKg9rQ+fCzIwHhm
        A4vhHb4MczDtRwmLqc1OEJtIzss823k=
X-Google-Smtp-Source: ABdhPJwmbIfhIjrYtC75Ar7Iy+dwk8XQASfBCreUvoZDqodQzsitIYHXwmcLlPFP8PMz81CClN8OCA==
X-Received: by 2002:a62:1c84:0:b029:1c4:f959:7b29 with SMTP id c126-20020a621c840000b02901c4f9597b29mr361001pfc.34.1613087100620;
        Thu, 11 Feb 2021 15:45:00 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:45:00 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 14/22] lpfc: Fix ADISC handling that never frees nodes
Date:   Thu, 11 Feb 2021 15:44:35 -0800
Message-Id: <20210211234443.3107-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
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
index fc70b4a23c8e..a96536988ca1 100644
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

