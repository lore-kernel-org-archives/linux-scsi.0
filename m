Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96265C28E82
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A08F64F00
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhCLJsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbhCLJsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:14 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BD9C0613D7
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:14 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id g8so3403141wmd.4
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l+1EJFBCtfo9l4gZLbyeXef//j2IlwdufiBKnHN8Ms4=;
        b=etOJppZ0N6Hc5WuXjMl/Rq7RPdhqLpqkPvoenm70t2iJLGNWCJF3hUhVcYbGHzOsaP
         ISlklt18zy37gZIRUD0Sh0/GoGxM0vTMfkb+dPoWq8wwXLl5BLbNZDXDUcbuohHwd6QY
         KazOWxWWTjHc9hdnB3RhLrNh66P5mUt1SCagZX1l/4cEEy6i7vSrNZIywzKYA4uNFIP1
         OP1uo2gTEQUqR4kHhCVU9QFfvEX6kj/jBTe2TpGrrmx3Jd2Masl2xT5THLwm3I/lfCt6
         +xeT/KHaQr3T/c5gX7iM+h2PWlQCUheqfYg87dPIAFHbbRkNxYkFp18sb1Zs4fDu/IOy
         lgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l+1EJFBCtfo9l4gZLbyeXef//j2IlwdufiBKnHN8Ms4=;
        b=lAiwBEIfOVp6VrdLw96Te6VFObR0r4veCCqArcGEesnE3GUoxWDlz+/aEH9vthhYQK
         a6kxhpG6BUjbqkMjknTNC4d7CN37URFscIXcMHMc+sUnZGmeO1Qtp00YRQz8z4wiOyJL
         z9TMlwWhAeoublPfmogPFc4VGVx1y/c3YNHBIMbEPYJCItN8klv8jkqoF8e/t7wQPm+g
         rrGeUFSjZKInK2V0OY4Zi2gEuLssSVGEB2o9Jo5Rm8CTzKQHv2KI8LQYTQeg8fQBQL6u
         fiNnJCy/cE1C7yz03T2mg6n53CAXLbypdXVxSbUV0bkNPJdm7WsFlXTTZlc/s5J6cL1X
         v8Lg==
X-Gm-Message-State: AOAM5324qUrTdvy0aERxT2+i3FI7OW13w6vaRwDFpwRHPOxTr924FHTw
        VRLZXHmfeOifcTns0Bw/xloB1w==
X-Google-Smtp-Source: ABdhPJzMXSxiudKZzRxEjzG62a0M6Fz7KbcGhlbgRIF1Jxho9qurTmOPoLb1MMSXuRI9AFO1Pgg0uw==
X-Received: by 2002:a1c:a543:: with SMTP id o64mr12229175wme.107.1615542492647;
        Fri, 12 Mar 2021 01:48:12 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:12 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
Subject: [PATCH 24/30] scsi: a100u2w: Remove unused variable 'bios_phys'
Date:   Fri, 12 Mar 2021 09:47:32 +0000
Message-Id: <20210312094738.2207817-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
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

