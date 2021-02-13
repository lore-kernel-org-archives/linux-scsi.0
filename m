Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4233C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Feb 2021 21:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C124A61493
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Feb 2021 21:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBMVIN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Feb 2021 16:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBMVIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Feb 2021 16:08:13 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D3AC061574;
        Sat, 13 Feb 2021 13:07:32 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2A74B1280663;
        Sat, 13 Feb 2021 13:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1613250451;
        bh=993rDJcjYQ3PvjxMChWLdvBsWy4nqxIR4dAe0NZOABE=;
        h=Message-ID:Subject:From:To:Date:From;
        b=seoQbEuYNH97QtoFP4yLtV0wRvICsuueXFGK3JMmZ2D+kUuxYBdxN8zNJZxGV/iRz
         0V7d3UGRMyrzQahIU7ALN2d9ZOnYZQwbN0OVDVYEP+g9b67imzFm39AOebKUIfrrEq
         cI8G3LcZjpYDpe4O2Np+iAid+tTMxBBbF7miQRY8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HGGJGFEVPbbg; Sat, 13 Feb 2021 13:07:31 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C22781280652;
        Sat, 13 Feb 2021 13:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1613250451;
        bh=993rDJcjYQ3PvjxMChWLdvBsWy4nqxIR4dAe0NZOABE=;
        h=Message-ID:Subject:From:To:Date:From;
        b=seoQbEuYNH97QtoFP4yLtV0wRvICsuueXFGK3JMmZ2D+kUuxYBdxN8zNJZxGV/iRz
         0V7d3UGRMyrzQahIU7ALN2d9ZOnYZQwbN0OVDVYEP+g9b67imzFm39AOebKUIfrrEq
         cI8G3LcZjpYDpe4O2Np+iAid+tTMxBBbF7miQRY8=
Message-ID: <df6ab78e106c6b792322fddbd75db0f3e2da69e3.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.11-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 13 Feb 2021 13:07:30 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One fix for scsi_debug that fixes a memory leak on module removal.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Maurizio Lombardi (1):
      scsi: scsi_debug: Fix a memory leak

And the diffstat:

 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4a08c450b756..b6540b92f566 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6881,6 +6881,7 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	kfree(sdebug_q_arr);
 }
 
 device_initcall(scsi_debug_init);

