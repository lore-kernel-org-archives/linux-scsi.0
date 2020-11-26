Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7178EC64E7C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 195CD21D7E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="D9WUf0FR";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wY4F9US2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389937AbgKZNaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:39 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56576 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390090AbgKZNai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:38 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STvXLhib2DiuGdj/XJWl8ZdJjfyQ63o5jIE034MX1z8=;
        b=D9WUf0FRBkSPU67vTFe9SxSW4dy/pxtsAxzYsbYqUQYxo/sdg3JjFdPuk5MSLiawed+K4A
        VrPm4u9HPkzbclKIrAqahFYNwiF2K1Xc3qmzwywjpsubq+IwH4q1IPzjJZlq9sQG3LNCVZ
        OWDeVH4TZd5i6cB/Qu62Ya69Kig6lUt0EXVmG0avYT+onQH3uTstcrvUO2H8ZrrTucgahn
        DQAQdF5tDoAlBE9G4u5+w0yWWivro0EKyMnIKnTrsUL6y4N8VYVo6D3l3dPCHMGwcv6ejn
        vt6IzZzsqNssHVjzGA2a0rYVZInHOiBre3GA2NoCoyz30vUi9Y0PHaLSxzluhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STvXLhib2DiuGdj/XJWl8ZdJjfyQ63o5jIE034MX1z8=;
        b=wY4F9US2+fO340CMFDIUC4+fwTyaldHwU1WU8xCqvN431uXGAGu92DymV5qC5xcODm7DQA
        pqDVO5BZpnPjJzCw==
To:     linux-scsi@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 11/14] scsi: myrs: Remove WARN_ON(in_interrupt()).
Date:   Thu, 26 Nov 2020 14:29:49 +0100
Message-Id: <20201126132952.2287996-12-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

The in_interrupt() macro is ill-defined and does not provide what the
name suggests. The usage especially in driver code is deprecated and a
tree-wide effort to clean up and consolidate the (ab)usage of
in_interrupt() and related checks is happening.

In this case the check covers only parts of the contexts in which these
functions cannot be called. It fails to detect preemption or interrupt
disabled invocations.

As wait_for_completion() already contains a broad variety of checks
(always enabled or debug option dependent) which cover all invalid
conditions already, there is no point in having extra inconsistent
warnings in drivers.

Just remove it.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/myrs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 7a3ade765ce3b..4adf9ded296aa 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -136,7 +136,6 @@ static void myrs_exec_cmd(struct myrs_hba *cs,
 	myrs_qcmd(cs, cmd_blk);
 	spin_unlock_irqrestore(&cs->queue_lock, flags);
=20
-	WARN_ON(in_interrupt());
 	wait_for_completion(&complete);
 }
=20
--=20
2.29.2

