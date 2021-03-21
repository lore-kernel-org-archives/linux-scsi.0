Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16510C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 18:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5A0E61939
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 18:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCUSAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 14:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhCUR74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 13:59:56 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C255C061574;
        Sun, 21 Mar 2021 10:59:56 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id f12so10769417qtq.4;
        Sun, 21 Mar 2021 10:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=za7zMkNNDWnLhakvL3BwC03Aa6NgCUH2NkEEQ+CAd3E=;
        b=nl2adu8UHdj/HZXxK/BvVfr9UPKxoJcf7uogsWCtHgK071AcSGlEtEg3MKHMsHPFPK
         LHOuwmfRoiHAMM9FvK7+9Pu7srR0NBZWPpJCvwVJvc5v5HqqY4xA3UBGe70Is50NZ7S5
         xfrbpNSAFB6bZqFJbYgVfw+6dJPl9f+QGBDU6HtpsNvAA7n6xIwKud3qmRrFU6+SQ7mj
         JebuFpkNGPCx6WyD/r9QGWeqgqvqKTvewjg+OOsuRJXy1DIMR7uWEibhusbH4YPxH099
         Kw8xtIuawfelu7niD6oWuZl1njEDDNxOkAkwdaDNT0dGGTgF0hp7GvzjPYQP7q3Tw7PM
         LbBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=za7zMkNNDWnLhakvL3BwC03Aa6NgCUH2NkEEQ+CAd3E=;
        b=rhg1qpn3kayU0fwbXaAT3wRfYjiIoh3CJbdnSBHubzENzjMTEJwRSPzWULhwNyn6X2
         BXU5m6e1QKREtJ4ixFtC5xPHGWqVJJBQVUE6gOhh++rOGShe4dquNq3KmTx1pInVsHw5
         A2XQFIVfFOpMT7VNnEbb/Vdmw1cSKi3HrCqyR2j8/+Srcv6A50gkWP8/iQPh53ydF2Pj
         9FOblib40qWi+g3c3ac2m09mDJ8+coml7/x0PkUylCw1bJTeBR3YAx7psq4oLwE0w1j8
         Dq5u4sypuA/C8WGDG2xEzsBdWPviN3GnaF0kUBlaY5Awn/K0SZSRZ8zzqNad6Jm95JnS
         HKuw==
X-Gm-Message-State: AOAM531S8Rm+vC7oB3sf6kCeyNI4dmS4tLQDiv+grKV9IyKDz1Tw0L46
        FCoMGYmheBMqXpp3dgkcwi0=
X-Google-Smtp-Source: ABdhPJynb4Z513vckHdDDad1mE8qQuPKYHBeMUmi7dGMP0iecuRq2BMYAwLBBbRB6ahwG8L7agQXWQ==
X-Received: by 2002:a05:622a:491:: with SMTP id p17mr6419317qtx.279.1616349595405;
        Sun, 21 Mar 2021 10:59:55 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:f925:bb4b:54d2:533])
        by smtp.googlemail.com with ESMTPSA id j26sm7684888qtp.30.2021.03.21.10.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 10:59:55 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH] scsi: dc395x: fix null-ptr-dereference in adapter_uninit
Date:   Sun, 21 Mar 2021 13:59:50 -0400
Message-Id: <20210321175950.441818-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dcb_list is initialized in adapter_init_params(). When it is not
initialized, calling adapter_uninit() from dc395x_init_one() can cause
null-ptr-dereference. We can set acb to NULL and skip adapter_uninit()
alltogether if adapter_init() returns non zero, since adapter_init()
will handle its own unwinding without the help of adapter_uninit().

[    1.437872] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.438251] #PF: supervisor read access in kernel mode
[    1.438529] #PF: error_code(0x0000) - not-present page
[    1.440130] RIP: 0010:adapter_uninit+0x94/0x170 [dc395x]
[    1.445439] Call Trace:
[    1.445573]  dc395x_init_one.cold+0x72a/0x9bb [dc395x]
[    1.445849]  local_pci_probe+0x48/0x80

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/dc395x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 3ea345c12467..990308cbf943 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4647,6 +4647,7 @@ static int dc395x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* initialise the adapter and everything we need */
  	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
 		dprintkl(KERN_INFO, "adapter init failed\n");
+		acb = NULL;
 		goto fail;
 	}
 
-- 
2.25.1

