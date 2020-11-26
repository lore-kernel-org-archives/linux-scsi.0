Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E230C63777
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5859721D7E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ip+FKZTk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xhGeS/Ic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390123AbgKZNai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390119AbgKZNai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B5C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 05:30:37 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DmSpUn3TvaIi0YjTfs82cRBGlzSa3RE3+yQ+8tMx+Q=;
        b=ip+FKZTkGX8NbmXLvAJYkFappUHQxrXaFJMpzAQeQsR2492Di6leYrwY8GeibG9sBC7ND0
        rTQCa6NQ2ZcMA8FRAzL8xQH5cHfgrIfnWfj0sdyKbXrFZxmJU9Vs4+niNG+8NZj4nC5ULu
        6FxdwKcmvDsMcr37LzYnmWAbDn+/XUaceQvWmcaIP8h8Vn6P7MnMhgjFqg7LzyYySq38uk
        IE4dCjbjEcqiTGVZiypa63skfGeILt06vJYD30MJx6SiwEapGBBNn0gQ2gcYMARD/cWLkF
        WAQNTKJJc0Wnm4HdZh7R1CnyKpceZyia8u28BtbyB0PmyMiyUSEVl5y2Xt8jXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DmSpUn3TvaIi0YjTfs82cRBGlzSa3RE3+yQ+8tMx+Q=;
        b=xhGeS/Icf3b18Dtesq1lK9vvQDd665cpSUVQ3Hvb5YcbxW/EvIlQbP3mH64Y7CmeY0r69u
        7ZtlIQtUKGYKHeCg==
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
Subject: [PATCH 10/14] scsi: myrb: Remove WARN_ON(in_interrupt()).
Date:   Thu, 26 Nov 2020 14:29:48 +0100
Message-Id: <20201126132952.2287996-11-bigeasy@linutronix.de>
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
 drivers/scsi/myrb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 5fa0f4ed6565f..3d8e91c07dc77 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -194,7 +194,6 @@ static unsigned short myrb_exec_cmd(struct myrb_hba *cb,
 	cb->qcmd(cb, cmd_blk);
 	spin_unlock_irqrestore(&cb->queue_lock, flags);
=20
-	WARN_ON(in_interrupt());
 	wait_for_completion(&cmpl);
 	return cmd_blk->status;
 }
--=20
2.29.2

