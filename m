Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F96C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 12:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36DD420658
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 12:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bI6/xgmD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgGOMCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 08:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbgGOMCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 08:02:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F07C08C5C1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 05:02:30 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id j18so5321427wmi.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 05:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=bI6/xgmDdLl1CYvhidaQxvatrhyjRmj76zy+BAn+Nogfq6Chu5oa8Bwrr6Wxci2DfD
         REq3n329UPvQgqhjoWGD39l4iW7NUUJr+PVOEEcNqOhwgiGgVKDQyZ/zKwdaWFMg6bwZ
         0NbONILkQ/D+SugIh9c1U9KuDzhm6Fad/wNWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=Cj4FmWQJGBZ3pqzvTF6UYZBYZYTsAq3xL9jOgTUF1uI63IOdJqPiWmRDvr9Bfk/xVC
         APALlPH+2NaLB9aTpvfpJSkxYEzHVPYmRD16aio8wrA8hhYuSWg193orWTNNUqDaV9do
         +7GI+9aEFbTrHNviQsHmNLS/CXo27dQUIARl1o7ZREZw/C3HYXdR0mYXX4VOPfXYKdzp
         ymatFwt+BtQQvXLfA5fK8BlHmrPq0SOocGdHMCAA1H6Eq8jiE3MZN3tZszKPUVPDpcis
         arCVzYPPAJUdHnR2P29bRTEdf4otYGtfal03B7109wSW57mCuj78rc1F9QWuPLvmDu8I
         W2mA==
X-Gm-Message-State: AOAM530ZQ93gN37Bfr1nbagCXpOBeKhId+/FEEiFTjEQ/QhUNAa1ABAI
        kcKDSPH+r/4sHyZAQKDgalZUpfUaOuvvSNnsZ8Lls88HG7IvQi4ohKZvDUInp7JLdXFtvLY1dRv
        GulrAOkkoT1ukpZiYf3wLLKVwc8VGod9k06x5FHSKseiQvgoDBJmTzLvor+EQbLE7oxZiV8DuM9
        iv3uOPHvNyP+gv
X-Google-Smtp-Source: ABdhPJxpzCCTWfaSQGJ7J2T4VC0vrkpKvlNqlenAr0YScPOoHsP3N9Gn7hzOOfRzjyUBZxKoLDHXGg==
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr8178717wmg.17.1594814548309;
        Wed, 15 Jul 2020 05:02:28 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm3969452wre.6.2020.07.15.05.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 05:02:27 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        "# v5 . 3+" <stable@vger.kernel.org>
Subject: [PATCH] megaraid_sas: remove undefined ENABLE_IRQ_POLL macro
Date:   Wed, 15 Jul 2020 17:31:53 +0530
Message-Id: <20200715120153.20512-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Issue:
As ENABLE_IRQ_POLL macro is undefined, the check for ENABLE_IRQ_POLL
macro in ISR will always be false leads to irq polling non-functional.

Fix:
Remove ENABLE_IRQ_POLL check from isr

Fixes: a6ffd5bf6819 ("scsi: megaraid_sas: Call disable_irq from process IRQ")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bb34278..0824410 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3740,10 +3740,8 @@ static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 	if (instance->mask_interrupts)
 		return IRQ_NONE;
 
-#if defined(ENABLE_IRQ_POLL)
 	if (irq_context->irq_poll_scheduled)
 		return IRQ_HANDLED;
-#endif
 
 	if (!instance->msix_vectors) {
 		mfiStatus = instance->instancet->clear_intr(instance);
-- 
2.9.5

