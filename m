Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A71AC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 17:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488212177B
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 17:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Xkrwrg8W";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="blXCJjEe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGRREp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 13:04:45 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37404 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbgGRREp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jul 2020 13:04:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 058F58EE07B;
        Sat, 18 Jul 2020 10:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1595091885;
        bh=JMRpUVstGbmDoJPJdDp8Sz4EDdV+jhAXdx6hF7IqQPw=;
        h=Subject:From:To:Cc:Date:From;
        b=Xkrwrg8WHzCBVqWH1J30iare5qlbLbxtfILRXn+iQ2YTEeyb3hLTnv58eZqWgnrwd
         st84pYuDADZ4N/eZf+OfbkGGkDnNYk6rf6RbqHYRh6vqMLnBkY8etMNuiSuauhxu4t
         t3fFU8Hgi0MCehb0d4KYKPAb771eUubPOolOPQK0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tRP8SKbe9NaN; Sat, 18 Jul 2020 10:04:43 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 885A48EE064;
        Sat, 18 Jul 2020 10:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1595091883;
        bh=JMRpUVstGbmDoJPJdDp8Sz4EDdV+jhAXdx6hF7IqQPw=;
        h=Subject:From:To:Cc:Date:From;
        b=blXCJjEe+tznwmEcLKrz9iwxKpM9yAuWCwLs3CgEOphqfPq2npUmsWP3koLafdBE1
         tHiacL0N5a61Y3RtJPz/R3KhHEWJ4ef7iXM24hrGoDzjQPaLISS4eOCG28QvuVMxW7
         CVZBKu51+a4PgFcRjZ5xyZY8hjz8Q1HMTBcMhF40=
Message-ID: <1595091880.3281.5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.8-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 18 Jul 2020 10:04:40 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One small driver fix.  Although the one liner makes it sound like a
cosmetic change, it's a regression fix for the megaraid_sas driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chandrakanth Patil (1):
      scsi: megaraid_sas: Remove undefined ENABLE_IRQ_POLL macro

And the diffstat:

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
 1 file changed, 2 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 319f241da4b6..fcf03f733e41 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3739,10 +3739,8 @@ static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 	if (instance->mask_interrupts)
 		return IRQ_NONE;
 
-#if defined(ENABLE_IRQ_POLL)
 	if (irq_context->irq_poll_scheduled)
 		return IRQ_HANDLED;
-#endif
 
 	if (!instance->msix_vectors) {
 		mfiStatus = instance->instancet->clear_intr(instance);
