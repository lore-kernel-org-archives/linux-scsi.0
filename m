Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF81C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 10:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FD7860FC1
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 10:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbhKHKPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:15:19 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38212 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237780AbhKHKPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Nov 2021 05:15:05 -0500
Received: from zn.tnic (p200300ec2f33110088892b77bd117736.dip0.t-ipconnect.de [IPv6:2003:ec:2f33:1100:8889:2b77:bd11:7736])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 375691EC0502;
        Mon,  8 Nov 2021 11:12:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636366340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBZ1A5tB9PEyEysd4o7ShtLFS9cLl8se3Ll8FfNnbiM=;
        b=hN28XcZ9uyPH9rwCvLaCI38e+6pBp4QiUpEzatHpSmZGDJdMRBxjE1RGZQ8ATE778AIFzZ
        5VnXd7BOeC6UDxyJKjqEi23QnagWkeTVeVKwDEwsx3EGbSzzq90SE+FCHeZT2kIhnGOzwP
        QNjyuUaM6r8m5yjWkYvwhaM72I7yjOs=
From:   Borislav Petkov <bp@alien8.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH v0 15/42] scsi: target: Check notifier registration return value
Date:   Mon,  8 Nov 2021 11:11:30 +0100
Message-Id: <20211108101157.15189-16-bp@alien8.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211108101157.15189-1-bp@alien8.de>
References: <20211108101157.15189-1-bp@alien8.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Avoid homegrown notifier registration checks.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/target/tcm_fc/tfc_conf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 1a38c98f681b..28960f68de08 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -465,7 +465,9 @@ static int __init ft_init(void)
 	if (ret)
 		goto out_unregister_template;
 
-	blocking_notifier_chain_register(&fc_lport_notifier_head, &ft_notifier);
+	if (blocking_notifier_chain_register(&fc_lport_notifier_head, &ft_notifier))
+		pr_warn("FC lport notifier already registered\n");
+
 	fc_lport_iterate(ft_lport_add, NULL);
 	return 0;
 
-- 
2.29.2

