Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386F4C33C9E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE72B206F0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="IJpiYTLn";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="IOJqlnNA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgAIBVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 20:21:35 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51138 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgAIBVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 20:21:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1D8B88EE0CE;
        Wed,  8 Jan 2020 17:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1578532895;
        bh=m3X8rjKDjjbks1Z8gsCeZue8Yi/hRu8t70pTwI6/tZE=;
        h=Subject:From:To:Cc:Date:From;
        b=IJpiYTLn9QWx/5Bgv3p6CzxTZF2jiQ89kxHQQ2VxMwgt/y0rXbCwt5jVwDluge0bX
         PmnSNkF31hO7rgluxCcCQrbctwWeUKh4vjcEl6yrJvYjFBd1fZi2BHflgx7hotdUZ1
         ZnGw6NPSezaRaPxMTciDczRb3ezkox8JaflbBsrc=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2YICj8MWdSMO; Wed,  8 Jan 2020 17:21:34 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5BCA68EE079;
        Wed,  8 Jan 2020 17:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1578532894;
        bh=m3X8rjKDjjbks1Z8gsCeZue8Yi/hRu8t70pTwI6/tZE=;
        h=Subject:From:To:Cc:Date:From;
        b=IOJqlnNAQ4AaXV4J8EY2n8meg8CfYcHYbSmFPXHlFVpqM+mFyzv9gDCdDkgLPbpSe
         31NdjkSSRzqp3fln1/9r7eRpWlWwbzUWyLMqOGOXyosdHnw9llYs2V2/Zbal7CG1TY
         gVuxok5W9N4TEHbil9k23s2pZTjN7+d423Bb2R5Y=
Message-ID: <1578532892.3852.10.camel@HansenPartnership.com>
Subject: [PATCH] enclosure: Fix stale device oops with hot replug
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Date:   Wed, 08 Jan 2020 17:21:32 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Doing an add/remove/add on a SCSI device in an enclosure leads to an
oops caused by poisoned values in the enclosure device list pointers.
The reason is because we are keeping the enclosure device across the
enclosed device add/remove/add but the current code is doing a
device_add/device_del/device_add on it.  This is the wrong thing to do
in sysfs, so fix it by not doing a device_del on the enclosure device
simply because of a hot remove of the drive in the slot.

Fixes: 43d8eb9cfd0a ("[SCSI] ses: add support for enclosure component hot removal")
Reported-by: Luo Jiaxing 
Tested-by: John Garry 
Signed-off-by: James Bottomley 
---
 drivers/misc/enclosure.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 6d27ccfe0680..3c2d405bc79b 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -406,10 +406,9 @@ int enclosure_remove_device(struct enclosure_device *edev, struct device *dev)
 		cdev = &edev->component[i];
 		if (cdev->dev == dev) {
 			enclosure_remove_links(cdev);
-			device_del(&cdev->cdev);
 			put_device(dev);
 			cdev->dev = NULL;
-			return device_add(&cdev->cdev);
+			return 0;
 		}
 	}
 	return -ENODEV;
-- 
2.16.4

