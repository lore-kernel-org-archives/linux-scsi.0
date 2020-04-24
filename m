Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A75C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 22:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E714B21556
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 22:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="slvaJ6Ja";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="lE4oJgKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDXWWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 18:22:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59062 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbgDXWWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 18:22:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 52AB78EE157;
        Fri, 24 Apr 2020 15:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587766961;
        bh=MUa5hmhvIZ06LZY7X1HZZ/vqw6X/xHhf88NvO1fE3f8=;
        h=Subject:From:To:Cc:Date:From;
        b=slvaJ6JayPB6lYhkgB+ViOlraQMB92BXOn2g/ig5z+v6682bAaN2E4VKbPiX34MN7
         RYr6t8qbN2nqLBsM377uEetxJbiXUC0SWeS/sAwiPph/Yz3l/cKPOqaIjd/mbY0O7V
         a9xpw7g6HCXTgjlGU/Jl2nWA+Ht0jgMIqd3EQpYQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n3gvE-JkSEaR; Fri, 24 Apr 2020 15:22:40 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 53DC88EE0C9;
        Fri, 24 Apr 2020 15:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587766959;
        bh=MUa5hmhvIZ06LZY7X1HZZ/vqw6X/xHhf88NvO1fE3f8=;
        h=Subject:From:To:Cc:Date:From;
        b=lE4oJgKptWhM+ZFgpL9mRgu/DiT3MP1qGuTwaCWxpGAGqyVuY67k/vSM2gukl6arh
         PpxpgfeZLxggEZTtQAdYgkgqOlMWZsYvNr3WWwXE5aY8Y1h5iKTRmIwD8lMwbk71XB
         HwzBjTltuZZBYDOJTXtSaToVj9bb99x9TnJOp8Zw=
Message-ID: <1587766958.4513.19.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.7-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 24 Apr 2020 15:22:38 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two minor fixes one to update a Kconfig reference and the other to fix
an unreleased resource on an error path in sg.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Diego Elio Pettenò (1):
      scsi: Update referenced link to cdrtools

Wu Bo (1):
      scsi: sg: add sg_remove_request in sg_write

And the diffstat:

 drivers/scsi/Kconfig | 2 +-
 drivers/scsi/sg.c    | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

With full diff below

James

---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 17feff174f57..2017c43dac1b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -127,7 +127,7 @@ config CHR_DEV_SG
 
 	  For scanners, look at SANE (<http://www.sane-project.org/>). For CD
 	  writer software look at Cdrtools
-	  (<http://cdrecord.berlios.de/private/cdrecord.html>)
+	  (<http://cdrtools.sourceforge.net/>)
 	  and for burning a "disk at once": CDRDAO
 	  (<http://cdrdao.sourceforge.net/>). Cdparanoia is a high
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9c0ee192f0f9..20472aaaf630 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -685,8 +685,10 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	hp->flags = input_size;	/* structure abuse ... */
 	hp->pack_id = old_hdr.pack_id;
 	hp->usr_ptr = NULL;
-	if (copy_from_user(cmnd, buf, cmd_size))
+	if (copy_from_user(cmnd, buf, cmd_size)) {
+		sg_remove_request(sfp, srp);
 		return -EFAULT;
+	}
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there

