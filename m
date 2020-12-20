Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64973C3526C
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E3123AC1
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgLTUiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 15:38:16 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35046 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgLTUiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 15:38:15 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608496611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlosfdauJl7ZrE12d2cuqqAT3nkgvFdbnMq5MkaS7pg=;
        b=plw/cqawwFOF/MX7S/joVviLZSXDG1Emjf6Cdd9AJeJnPxZJUhN3q5f04HeWAn2IsnWMem
        rlbCLGybGbr6nKAkd+NddKhFeCZI3HSMww9BXKG1QrIpUIDh1Ne1DgUuLpRGTLlv9bZwrw
        mDIJkIu8IVXU9s1nZhjTo+9ziU0r1iwGRfIwcf/BmqWgAioO3JCAslPzxBSYzXd9Wip4TV
        JAc1ilQqsxLarBas55SnHjlcBM7NJCk058/rDzM4T+y95DMOdZg/+08BOj+6nu1tikIZvb
        e8/FUtMZeEHrhzYebAkOvWmqI4QDmM/iTf501DLlWwNotlOUiWTR18OEJ64gqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608496611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlosfdauJl7ZrE12d2cuqqAT3nkgvFdbnMq5MkaS7pg=;
        b=hHtBOj1gZGhrW/XJWUnxRfVO1LCGetjbZNoGmg6Zy16+w7P+OUd23soK/sQc+dduI06I8J
        dBsJZ+BWzcOLJoBg==
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/6] scsi: target: Replace in_interrupt() usage in target_submit_cmd_map_sgls()
Date:   Sun, 20 Dec 2020 21:36:37 +0100
Message-Id: <20201220203638.43615-6-bigeasy@linutronix.de>
In-Reply-To: <20201220203638.43615-1-bigeasy@linutronix.de>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls() uses in_interrupt() to crash if it returns
true.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

The usage of in_interrupt() is clearly for debugging. might_sleep() is
better at this because it also detects other contexts in which it is not
allowed to sleep, like preempt-disabled section.

Replace BUG_ON(in_interrupt) with might_sleep().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index fca4bd079d02c..b4fdc3f41e90a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1613,10 +1613,11 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cm=
d, struct se_session *se_sess
 	sense_reason_t rc;
 	int ret;
=20
+	might_sleep();
+
 	se_tpg =3D se_sess->se_tpg;
 	BUG_ON(!se_tpg);
 	BUG_ON(se_cmd->se_tfo || se_cmd->se_sess);
-	BUG_ON(in_interrupt());
=20
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |=3D SCF_USE_CPUID;
--=20
2.29.2

