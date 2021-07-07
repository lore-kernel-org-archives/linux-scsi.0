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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664C6C07E9C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DC7461CCE
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhGGSqx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhGGSqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:47 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474A4C061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:07 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p9so2068217pjl.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1XRHycLuBv2mlw/4Sks8C19TtCruVWziBnfzmR/aUIE=;
        b=THVKqtrgmuAxvn8ENg9qPNpX1BDiejMP5Q4oA8oiPMLIR3FN9udjUk1J60YCEYbCrS
         2A8ullvmXJTby4oRCeKfxEnGbmhpXcSduszchxIAjQAVRVaImVm8f1egQUG2Gv1LxGtE
         LqDRrUpumBYXUpQl4KRJuxQvk2Mr7gkODaltpEuDdw+uioUrPl+e8EIg8foa5MV+4Yot
         3lc3bpz5SR+N2k09UqTDJz4xoHjPYKfE78zLr9WOKkorWd2jgSuFqX0VfQ8t1DuvSgh0
         IJ4VVNA4tTg0UBQu3dJEl3u49pI8CzGlhj6XP5FpN1Sqa7LO1J+7jCPCEse3Yk3hPx6i
         KKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1XRHycLuBv2mlw/4Sks8C19TtCruVWziBnfzmR/aUIE=;
        b=j9XT+Ys1OPCev3wjKeZv6V838UatrjVSslyI65YZkC1BIhWfyupG/01XJopBrp8sqJ
         diRejxGsb9zEZN+Mg5/5RS7q82t97wkPOtUPU/f7i5wkW6cx8z9GCX2t17ZTywfuAF77
         y0ZSm7ZRYGtRmqPrWRtYJMa24caX+OeOdSePg1+fmMfrMg1yEimDdXJ4cBJwIyLUoLy8
         A48NV4Sf+S1kcFA0mcObni2J0Wpxv9qY2QMcDO0+7xybusQBqreKuretXwhAczh5Ue85
         RdNbIyayClFIE9+lcCDgZWHeC+fSXqQ0DICki5CglBwrpYaN8DOESKIvDPdVOZJtRsrP
         7RMA==
X-Gm-Message-State: AOAM530IE97NvBUprglEFVd7QjyKgVlZT15MxjrNxQsK1J74bjB6THfW
        PVw3XVI1MEDQHTrInqYAMIJYNMlHw8I=
X-Google-Smtp-Source: ABdhPJxLsiKuZLlICd5dO8FS6mC/5I9JQaYj5s4+xz80BXwvQ/TICZhQPhJwsW4u6Kmff3oAiH9vCA==
X-Received: by 2002:a17:90b:124f:: with SMTP id gx15mr476005pjb.8.1625683446797;
        Wed, 07 Jul 2021 11:44:06 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:06 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 17/20] lpfc: Skip reg_vpi when link is down for SLI3 in ADISC cmpl path
Date:   Wed,  7 Jul 2021 11:43:48 -0700
Message-Id: <20210707184351.67872-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During RSCN storms, some instances of LIP on SLI-3 adapters lead to a
situation where FLOGIs keep failing with firmware indicating an illegal
command error code.  This situation was preceded by an ADISC completion
that was processed while the link was down. This path on SLI-3 performs
a CLEAR_LA and attempts to activate a VPI with REG_VPI.  Later, as the
FLOGI completes, it's no longer in sync with the VPI state.  In SLI-3
it is illegal to have an active VPI during FLOGI.

Resolve by circumventing the SLI-3 path that performs the CLEAR_LA and
REG_VPI. The path will be taken after the FLOGI after the next Link Up.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 11e56534b8f0..342c7e28ee95 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2610,6 +2610,14 @@ lpfc_adisc_done(struct lpfc_vport *vport)
 	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 	    !(vport->fc_flag & FC_RSCN_MODE) &&
 	    (phba->sli_rev < LPFC_SLI_REV4)) {
+
+		/*
+		 * If link is down, clear_la and reg_vpi will be done after
+		 * flogi following a link up event
+		 */
+		if (!lpfc_is_link_up(phba))
+			return;
+
 		/* The ADISCs are complete.  Doesn't matter if they
 		 * succeeded or failed because the ADISC completion
 		 * routine guarantees to call the state machine and
-- 
2.26.2

