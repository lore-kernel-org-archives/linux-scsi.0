Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABBDC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E7820795
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="dQKM7Xsw";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="dQKM7Xsw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgIOWmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:42:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42010 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727925AbgIOWmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 18:42:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A4B758EE188;
        Tue, 15 Sep 2020 15:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1600209755;
        bh=VEHO4Ug0kD8bPGj3t70lHdvhQIsfuBMa/2qcEUNGuho=;
        h=Subject:From:To:Cc:Date:From;
        b=dQKM7Xsw/Ncz9A1FlYdvJIr8nJ0BrSr39xrXUPxqASLoWTj0i2YEpoE6t+XMBFCHU
         1T+CBMAoyh0RXrw52xdS4CXumb9Q33hBSC8DPjBw0nyWWpDFQbFBgnh1zRnyG2sj/2
         mtMUV2C7LoIFGp8izh4TE4LTpifkFKozNB6AVthY=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Z0HsipziwS27; Tue, 15 Sep 2020 15:42:35 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3F5AD8EE107;
        Tue, 15 Sep 2020 15:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1600209755;
        bh=VEHO4Ug0kD8bPGj3t70lHdvhQIsfuBMa/2qcEUNGuho=;
        h=Subject:From:To:Cc:Date:From;
        b=dQKM7Xsw/Ncz9A1FlYdvJIr8nJ0BrSr39xrXUPxqASLoWTj0i2YEpoE6t+XMBFCHU
         1T+CBMAoyh0RXrw52xdS4CXumb9Q33hBSC8DPjBw0nyWWpDFQbFBgnh1zRnyG2sj/2
         mtMUV2C7LoIFGp8izh4TE4LTpifkFKozNB6AVthY=
Message-ID: <1600209754.5092.24.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.9-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Sep 2020 15:42:34 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just one fix in libsas for a resource leak in an error path.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      scsi: libsas: Fix error path in sas_notify_lldd_dev_found()

And the diffstat:

 drivers/scsi/libsas/sas_discover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index daf951b0b3f5..13ad2b3d314e 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -182,10 +182,11 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 		pr_warn("driver on host %s cannot handle device %016llx, error:%d\n",
 			dev_name(sas_ha->dev),
 			SAS_ADDR(dev->sas_addr), res);
+		return res;
 	}
 	set_bit(SAS_DEV_FOUND, &dev->state);
 	kref_get(&dev->kref);
-	return res;
+	return 0;
 }
 
 
