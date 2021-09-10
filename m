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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CAAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3732611B0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhIJXdg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbhIJXd0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA409C06175F
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so1679091pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4PFJ+5cXtDvpz0WDtpK4XiTZaISaTldxnUnweyif6c=;
        b=peNpi04xILByRK5hCVEQpwZ7zchpPTyT1dYemI58pTjCVcAQ3HEAyjxf1JBabg2DoL
         +ZK7zKh6zkKcc1A63QTD27YpIO6J49dxtJgNIDEYgtJHr8Bufr5VHdftIEhs/j0nEG4C
         YKEh2mCMKOwpqvHcKqi0Mp1zA8kd6tqCglEvZV0ID+Xs8T3ozXsuBIV4P1VZnlAKAE9I
         tcx45EkdZQEdNZy37ef49L51YeBvQpGqD0M0i1QoCCr7xg8wFWvnEaHPrUAfEXsW843i
         YwRSXSIYM9XyTW28qXRJrRNsceoaUOnR57jTpIJcQ1lZiUChv39KXktJoGTy3mPqkhId
         eTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4PFJ+5cXtDvpz0WDtpK4XiTZaISaTldxnUnweyif6c=;
        b=PCoVGg66tEondDaujvhhJzbpMn3eMKnQXVt4ruGSKANSMKnsm5cil8SLZJJvRs1bkN
         ctCv3BqEHeZDc/I0WUHuDZroAmuXMxJ35ZMEfbT/jXoBTwI+vzP8UlrJ1gXrh+axkRHU
         F6MsOVGQxyBkaxevszhNZRyzuH/Hl0BuSk57TSkL6tIOr4SMiJ7lZRG92pMP/BrifsGN
         3nRuUFtMxbB0/Clyi32Hx4Hk5MO8WWjAxxhRVo5GK/LwtnFqlvwP/AfPwVqDdpslMnTQ
         U7Vi8PpDRc6JnkKStsvmAGjHOVow8Ui7FUCHpTj3kNU3fMVheBZwZv8N5FavjRKEo32H
         YkTQ==
X-Gm-Message-State: AOAM533udNpXJo8Hk87xTLp2f8Ai5jHsKUCCL41ANHeAvVDow2MMrpHR
        R9PNnAMFYxxi4KSBlHJbYhO8GU3og6D9R8gV
X-Google-Smtp-Source: ABdhPJzB9YZTV/HIqk5TaH87bN4xL069C/EMnF6JVm1sz5qTD31JQfa6pjylx+I/eQYI2cxzalF32Q==
X-Received: by 2002:a17:902:b691:b029:12d:2b6:d116 with SMTP id c17-20020a170902b691b029012d02b6d116mr105564pls.71.1631316734090;
        Fri, 10 Sep 2021 16:32:14 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/14] lpfc: Fix rediscovery of tape device after issue lip
Date:   Fri, 10 Sep 2021 16:31:50 -0700
Message-Id: <20210910233159.115896-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On link up and node discovery, a remote port is registered with the
scsi transport and the driver sets fc4_xpt_flags to track transport
registration.

A link down event causes the driver to deregister with the scsi
transport, starting the devloss timer, and calls a local unreg
routine to clear the login state. Part of the login state is the
fc4_xpt_flags.  However, with TAPE devices that support sequence level
error recovery, which wants to preserve the login, the local unreg
routine is skipped, thus the flags aren't cleared.

A subsequent link up, ADISC is performed and the lpfc_nlp_reg_node()
routine is called. As the fc4_xpt_flags is not clear, it's believed
the node is already registered with the transport. Unfortunately, the
registration was already terminated. Eventually the devloss tmo timer
expires and tears down the device.

Fix by ensuring the tape device, known by the ADISC flag, is always
unregistered if the link drops.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4ff93aef3295..12abfc027a67 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4693,8 +4693,11 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* Reg/Unreg for FCP and NVME Transport interface */
 	if ((old_state == NLP_STE_MAPPED_NODE ||
 	     old_state == NLP_STE_UNMAPPED_NODE)) {
-		/* For nodes marked for ADISC, Handle unreg in ADISC cmpl */
-		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
+		/* For nodes marked for ADISC, Handle unreg in ADISC cmpl
+		 * if linkup. In linkdown do unreg_node
+		 */
+		if (!(ndlp->nlp_flag & NLP_NPR_ADISC) ||
+		    !lpfc_is_link_up(vport->phba))
 			lpfc_nlp_unreg_node(vport, ndlp);
 	}
 
-- 
2.26.2

