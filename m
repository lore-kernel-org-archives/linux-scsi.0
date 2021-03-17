Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E43CC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396BB64EE2
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCQI5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhCQI5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:15 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0179C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:14 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y124-20020a1c32820000b029010c93864955so2908107wmy.5
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l+1EJFBCtfo9l4gZLbyeXef//j2IlwdufiBKnHN8Ms4=;
        b=SKA3psbfj5f7Um44JGG8FKNE9H0hMuOoWt6WNZmaOG3Zqzw4HRofNMesdpsoJxVplR
         j4yvm5gbPpdspzpBGwdC1paXhtqKo0lblnAavll/x0LLH2fW1iJR1qnrrGGkW8i0u3R0
         ibov7RikkU5XHX3MtoFuzFsbG8BD5l2If2FkQDcc3PdWALyJSxekxL62SZa53XdVWyQr
         Vya6eZRAf2PQ8Y0oh1GEQtFLV9Y4RAJxba+YdVg5dk2R9xbf9rPPLvsdKLIh+v/gl3LT
         i5FPw5F6clmJxzE8ljdyz3ZbHwm8EYKC0rEb1Pxm1Llx1B6F6drv6BmFmvYeLiNhVfRQ
         agAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l+1EJFBCtfo9l4gZLbyeXef//j2IlwdufiBKnHN8Ms4=;
        b=dKWj76UI6pKX4sMSNFXUHreIDKYQRQ5kHBe3FnMrUokGV/V8GfhoR/11R40hVBnfBP
         TTVyNu0ZY2vKNX1Xbe+STy19B+5GLPgok6w6fks01JGnUYtW6fEiB5FLEvpNxXl6T4Ad
         rYxWXl9+hGDmCMMFYOg/JrW396PQvSpeU0sUM8BK4z2YT41gp6hMG3opra4IgMld0d7o
         TWzpwYr5R/SXH/2136yuAn7hBv/i1oSd0C0f8HycqLnM17COI+JYmubwwfxD0J7dusIl
         bmU/ZOrMnlwRxS7VieK+LbHqez7lcUW+r+SyG1F6lBebSO2htmNZE/k/mQ52pF9fimkj
         iNIw==
X-Gm-Message-State: AOAM530/zUVSv+agyK1+BpzhxRi2CbA1ez1oT1AEAC6FuIBwVeKMp6tR
        kKSITlM4mBh/zVN/7gPQe9h+gA==
X-Google-Smtp-Source: ABdhPJz181LhBLmutFOYGnihVIaN6OavW4rkwV7VElcenpA9Qb98+4DwhdTWR24irt6eFOE5AFPGEg==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr2649152wml.147.1615971433784;
        Wed, 17 Mar 2021 01:57:13 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
Subject: [PATCH 08/18] scsi: a100u2w: Remove unused variable 'bios_phys'
Date:   Wed, 17 Mar 2021 08:56:51 +0000
Message-Id: <20210317085701.2891231-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/a100u2w.c: In function ‘inia100_probe_one’:
 drivers/scsi/a100u2w.c:1092:8: warning: variable ‘bios_phys’ set but not used [-Wunused-but-set-variable]

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/a100u2w.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 66c514310f3c5..c99224a128f82 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1089,7 +1089,6 @@ static int inia100_probe_one(struct pci_dev *pdev,
 	int error = -ENODEV;
 	u32 sz;
 	unsigned long biosaddr;
-	char *bios_phys;
 
 	if (pci_enable_device(pdev))
 		goto out;
@@ -1141,7 +1140,6 @@ static int inia100_probe_one(struct pci_dev *pdev,
 
 	biosaddr = host->BIOScfg;
 	biosaddr = (biosaddr << 4);
-	bios_phys = phys_to_virt(biosaddr);
 	if (init_orchid(host)) {	/* Initialize orchid chip */
 		printk("inia100: initial orchid fail!!\n");
 		goto out_free_escb_array;
-- 
2.27.0

