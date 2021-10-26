Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C8FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C64F60F92
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhJZQ4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 12:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbhJZQ4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 12:56:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF75CC061745
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 09:54:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m17so4980067edc.12
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 09:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=lrJ05Ai9WwApEpT26ZesWSV9nC3EDaeMEn67reBF5mQ=;
        b=cMHwRb80leHU8MEpeu6N/LWKicCvBGHLCdjNzaEgZDq5qgmWdZ0VSZlWrU4AMiR47r
         iGEiPRATIXipLTX0MVsGKWASjoWZE+FgSUrEfHWXYKN8mvFYYORpMc9AeimEPgK4vD61
         KkQMU9HT3J/cGW0COzZKLwzotST9BpW3ayNU3rKyabnULVy/KZupTxUiB/dPJLTv1YFs
         o+ZR99ajVFNbKDZfMomG258RO1+n5DD+/HR6TMLJrEn1JZpyIzg54hiPBWEKB0K8yECm
         1x42SSmbwLW3hEo5aREiWffXa2KxReZ6sXcIHO6PMZeEb0bve5/U6BouoSE4E8tbGLlI
         2W0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=lrJ05Ai9WwApEpT26ZesWSV9nC3EDaeMEn67reBF5mQ=;
        b=WYvrWaxk7lDMcWRZI6LC/+BZSWxmWz80oI2k8VAsBTid4yjzeVgPm/2fMO4Z9J412Q
         irslK9GYvBiOATdkqah/F7wbm4+KHnFxXoRUfLns1Ys70nlnm6FB9NN/gwsSq2KtZscH
         X1VP3sdd+K8cdM/7r8cmjvhnnZAKF6nngWYKDjFNP3y2/OO0zm7eH/6Ori5DyP60AMqg
         EDz4mNchMEWtkwXT3L9UXIPJlRlRQtd0CUuKBuzRYwLjwm8s4eI9L5A3xzbrGtK1CbTn
         34rKA7yQM6O5oZrkolo6rwljnFYdjWAUuSgbipEP6K8Q2zF7Q6VQpzYUkIA8aM1qvCdK
         bLIQ==
X-Gm-Message-State: AOAM533zE0MVUcoZikGMpOOMMHkgELx6EZ9l9N7iE0asPk8vdgqdPU/v
        a1y7aTASOMysGIAYj8uPCg==
X-Google-Smtp-Source: ABdhPJx0bNNwubPWFxtD+KtP6tLVS7TNDtPCkE/7/Hy1QDWEK5AaQREAq6ocJntMt/A1PKxxOrIlVQ==
X-Received: by 2002:a50:9dca:: with SMTP id l10mr37334628edk.61.1635267184207;
        Tue, 26 Oct 2021 09:53:04 -0700 (PDT)
Received: from localhost.localdomain ([46.53.251.249])
        by smtp.gmail.com with ESMTPSA id g26sm3010632ejz.21.2021.10.26.09.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 09:53:03 -0700 (PDT)
Date:   Tue, 26 Oct 2021 19:53:01 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi, sr: remove duplicate assignment
Message-ID: <YXgybUhYN+Vrruj8@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/sr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -692,7 +692,6 @@ static int sr_probe(struct device *dev)
 	cd->device = sdev;
 	cd->disk = disk;
 	cd->driver = &sr_template;
-	cd->disk = disk;
 	cd->capacity = 0x1fffff;
 	cd->device->changed = 1;	/* force recheck CD type */
 	cd->media_present = 1;
