Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11434C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388876AbiEFD73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388846AbiEFD7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1723ADF29
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:33 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g8so5265909pfh.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CFG4FVBjoMWKHe+LEoBTTsXpvwr10JyuuHeZnwcfE5Q=;
        b=jFOarW/XH8hoXPxkK4yoDpx5CdhSyBzvNAuTBk2iHi7eDCLekzyyYpiCldDgM4+QTb
         JtckQ5P9HUsZcSk/SA5v2BBLG/cmlH0M0fVm3de9A5jmZg2HVuWp3wx4wseDnyPIN3en
         yuKf+B+YW0VoSESLwjJg1K3581dPx8UZ2b67asHNBqv84kTCEFzq+p8TItkR8U+O3CXw
         dCROShOuZb70IHgrtozaeTU9CDPzs6wAfjY2SXK4Sg3rd4mRTzBH2RcjNcfvvEkSFakP
         D2DbbdTry4O73JSll82Sb1hFRh6OJJ0QQd+rmT8FbRybQ/PHiH6AHo4HxVPmxJnfAqfh
         tACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CFG4FVBjoMWKHe+LEoBTTsXpvwr10JyuuHeZnwcfE5Q=;
        b=uGX00TTzbb2PQl0Jc0OvN9pUU/GUMkz7WjW9u/zW4+/p65WgCfmP9TfBR2BVN90RVv
         M8RkitE9EGnMS1PSUvgmCpMocknUTCDRBR/tocgBhkaP2yiMC3Qlk2PhCbMbAd+TZQ9D
         a/godbiuRTs5qy4L6IsEddJjgaXAZ9ALz9lM3R9oflNc5v6MmLL3U6oXgeicPpDCT5PO
         lIucjY0u8fD+9LRGBWtmfhni/bnondItnxuKuQCGCk+VH4ZkEsRgeHpJPZEZuItsbhD0
         zJEapk8gutkSD3qcFG61H3Vqs+dUcQIinCeL0Hv20P9xqALspqTPfKxKmYNbHULIGFAI
         SFzQ==
X-Gm-Message-State: AOAM531ZnE/XLp5pfbkPbYwkdZbKlK7TM8GNZrxnzyi3nj8gCqOAkM1u
        1XkSft44jqVDnNu/Tv3tRPP7z06gJM0=
X-Google-Smtp-Source: ABdhPJzeiYzeJ6Nmli2aifJ80FpfsjP/eCWOw2dGNhwoOpPoqW84TWG+lS2uoSDFrdoicOXvJOCALQ==
X-Received: by 2002:a05:6a00:2310:b0:505:a8ac:40e7 with SMTP id h16-20020a056a00231000b00505a8ac40e7mr1393896pfh.11.1651809332411;
        Thu, 05 May 2022 20:55:32 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:32 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/12] lpfc: Use list_for_each_entry_safe on fc_nodes list in rscn_recovery_check
Date:   Thu,  5 May 2022 20:55:13 -0700
Message-Id: <20220506035519.50908-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In GID_PT mode with lpfc_ns_query=1, a race condition between iterating
the vport->fc_nodes list in lpfc_rscn_recovery_check and cleanup of an
ndlp can trigger a crash while processing the RSCN of another initiator
from the same zone.

During iteration of the vport->fc_nodes list, an ndlp is cleaned up and
released. lpfc_dequeue_node is called from lpfc_cleanup_node leading to
a bad ndlp dereference in lpfc_rscn_recovery_check.

Change list_for_each_entry to list_for_each_entry_safe in
lpfc_rscn_recovery_check to protect against removal of an initiator ndlp,
while walking the vport->fc_nodes list.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 583a287b2d0c..3671e0f8e041 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7708,10 +7708,10 @@ lpfc_rscn_payload_check(struct lpfc_vport *vport, uint32_t did)
 static int
 lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 {
-	struct lpfc_nodelist *ndlp = NULL;
+	struct lpfc_nodelist *ndlp = NULL, *n;
 
 	/* Move all affected nodes by pending RSCNs to NPR state. */
-	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+	list_for_each_entry_safe(ndlp, n, &vport->fc_nodes, nlp_listp) {
 		if ((ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
 		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
-- 
2.26.2

