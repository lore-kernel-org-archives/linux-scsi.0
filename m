Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D776AC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 12:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A696E611AD
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 12:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhIKMN1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 08:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKMN0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2021 08:13:26 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C773C061574
        for <linux-scsi@vger.kernel.org>; Sat, 11 Sep 2021 05:12:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q26so6642530wrc.7
        for <linux-scsi@vger.kernel.org>; Sat, 11 Sep 2021 05:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Soof2tC2ARGD1C8223fBJWGXQzh92gv3cAXXLMMpflM=;
        b=XWNLc9xBT2Oqmhrgc4Y+g+20bVrK9VSlI92FeHt8mNIdI/eao2DM8BalJUhlQ1K/W+
         xBkdIBLnWNX2+QmrbNOuc4IO2mVqJf/jdHz4aetJahzxW013ok1TAnF5M7XXfgmVAtnq
         7zjCBI7ZGMu1qsw4f8pn96ftcxbozEkNfAp76ehmzZKwh3X08F7IqueUl2ECe48d0tO/
         0/C6ge7RdZjndTby+ex2/PyUYekDcJ63Rf9cEWgFEduxdqJ4QWuXWiXrVmRjWzeAha4N
         Wn99QBh1HbYT81cS4E9fnY2pqZ/7aWwvwAY9aRXhNQXe0InmCu2JXUIvMmsxhjlAW/pN
         N1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Soof2tC2ARGD1C8223fBJWGXQzh92gv3cAXXLMMpflM=;
        b=6ePtpdRdjsyGQsuA/xPUMaXv3FmdFOmAKj0x1LZk9uWSt++v1TklRP4ycfBEM6UFBp
         ORGX4F7uHPShiSFzoxR0J0RZCs+2kokriHxuzmFUdFG1grVe6pNDVdQDmYkhDp9zI1kv
         V27D03wSCKwIM3K+Yy6AgxYhWMCm9nNSMeL5fyiczGEKVV2d9zRy0C8J8UkCZHVE3QEO
         dz0ms3Lnq/cnVwq6NULHaIbgkOOnpGf+K2fSgXPDfBOpSMGu2OVPOn03VySkJ7VPfzmL
         1uB+7Pj5qWiQ+p8WVTnL/u1c68ptvDpunFvf44QhJl+Te0jKfKRh32iKGuhXq3p3qceL
         GpDQ==
X-Gm-Message-State: AOAM532/T2DUlcD8HwfUt0YuC/LXkio9ZDNs+mCilgchRjNjIJ/8F3f7
        5HGTtfjB+wRzOSLkNhqG1uQ=
X-Google-Smtp-Source: ABdhPJzeIXX9TO6wZCjo5wYgj8gl8yWJCMKxXph8uscwSSPMEIdzzoevRQPJFJOxJwcQ6+a5r9ijrQ==
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr2925034wro.418.1631362332716;
        Sat, 11 Sep 2021 05:12:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:397f:e269:90:7644? (p200300ea8f084500397fe26900907644.dip0.t-ipconnect.de. [2003:ea:8f08:4500:397f:e269:90:7644])
        by smtp.googlemail.com with ESMTPSA id r26sm1442501wmh.27.2021.09.11.05.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 05:12:12 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>,
        Christian Loehle <cloehle@hyperstone.com>
Subject: [PATCH] scsi: sd: Make sd_spinup_disk less noisy
Message-ID: <a2d0a249-6035-9697-626a-e14ec50ef6ee@gmail.com>
Date:   Sat, 11 Sep 2021 14:11:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For my personal taste sd_spinup_disk() is a little bit noisy after
848ade90ba9c ("scsi: sd: Do not exit sd_spinup_disk() quietly").

scsi 0:0:0:0: Direct-Access     Multiple Card  Reader     1.00 PQ: 0 ANSI: 0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Media removed, stopped polling
sd 0:0:0:0: [sda] Media removed, stopped polling
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:0: [sda] Media removed, stopped polling

There's not really a benefit in printing the same message multiple
times. Therefore print it only if media_present was set before.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/scsi/sd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cbd9999f9..af7e7b0da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2124,6 +2124,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		retries = 0;
 
 		do {
+			bool media_was_present = sdkp->media_present;
+
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
@@ -2138,7 +2140,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * with any more polling.
 			 */
 			if (media_not_present(sdkp, &sshdr)) {
-				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
 				return;
 			}
 
-- 
2.33.0

