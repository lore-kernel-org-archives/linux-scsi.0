Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BEFC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 03:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5519265159
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 03:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhCHDxZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 22:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhCHDwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 22:52:49 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2BDC06174A;
        Sun,  7 Mar 2021 19:52:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fu20so2284115pjb.2;
        Sun, 07 Mar 2021 19:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f7RIVNoogGg6Yzyzf9tYT+saaS2pPENRI1a3e4spOmc=;
        b=NsdL93mgY334JXDHUmA6k5oMm0RMUneWVRCe6PrS3ozbbRU7FNtnkui8RuoqY3iilj
         l9cZUZYVGEaEly+O6L18d5SBC68Of1rskzwOgWKq9h73wSSr1bwAH4i/SRLkolZXEceg
         fDRvekUVl/NAbKScRFUbLKtlS/LNrbykx89EbEjLVUXMqLlDZG6nmjdEx/k4wokIbUEU
         km8rw8KkWIglkj+LZS5rdfGA3MRLpgkWThhu6/OVUUJU76MVhmipvkU3g7kkxkoBhw7v
         3P7FSHeNiiFBicbN7SdivSEzy1rI8L6EWLjhLs95nRKjTZjixg/EzXS0awoelvYzpNZ/
         AftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f7RIVNoogGg6Yzyzf9tYT+saaS2pPENRI1a3e4spOmc=;
        b=EZpsKUQSGY7sWAGXBuXpFdryo88w+PNAHkwv5A1mJY/rzIyQOYZ7TnR9fQxEb7aV5P
         MopGWPfY6suMeocTu/sKjnqThBx0L4UHAfVmyFJJjubtPr4d1zt3qDTuUyxfAPK/KYZf
         CGziqGsisgoS3G4V7FV5PEoYDZej+fQWaQk58oDvULJx8gBrHs3Qq2peRAm6bNqRU9BY
         0Uezot0OTtY1fIH9W3ok3JykDyzLizGkaUPq+se0UPkh8ZuULarjcsnakjlLl7W16nYi
         DELF17012kTCKokSrpESqVBycpJ1bsbxMCxp4xWUvL1BijUhAuQQ2Ukpbz5nZd92PxHw
         I0Dw==
X-Gm-Message-State: AOAM532VbuoJdZvdiTuJRpRyrKHg49h2Y4kt4gu9V/gNgJ5U7DwR27Wq
        Jzkwp/+PjINYVb/9MCTjFW5r3I7UHuADSTkJ
X-Google-Smtp-Source: ABdhPJy58rtPLlHCK8JXmOc3AIdTE5FcyDD6AZGUxrrVgVLslWs2zmk+BQuwTiAOZO0JiOsfGK0WMw==
X-Received: by 2002:a17:90a:cf8f:: with SMTP id i15mr19375031pju.22.1615175569059;
        Sun, 07 Mar 2021 19:52:49 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id 186sm8788042pfx.132.2021.03.07.19.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:52:48 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: mpt3sas: fix error return code of mpt3sas_base_attach()
Date:   Sun,  7 Mar 2021 19:52:41 -0800
Message-Id: <20210308035241.3288-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When kzalloc() returns NULL, no error return code of
mpt3sas_base_attach() is assigned.
To fix this bug, r is assigned with -ENOMEM in this case.

Fixes: c696f7b83ede ("scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ac066f86bb14..ac0eef975f17 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7806,14 +7806,18 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->pend_os_device_add_sz++;
 	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
 	    GFP_KERNEL);
-	if (!ioc->pend_os_device_add)
+	if (!ioc->pend_os_device_add) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->device_remove_in_progress_sz = ioc->pend_os_device_add_sz;
 	ioc->device_remove_in_progress =
 		kzalloc(ioc->device_remove_in_progress_sz, GFP_KERNEL);
-	if (!ioc->device_remove_in_progress)
+	if (!ioc->device_remove_in_progress) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->fwfault_debug = mpt3sas_fwfault_debug;
 
-- 
2.17.1

