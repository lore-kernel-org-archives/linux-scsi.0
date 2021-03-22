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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89662C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6204461944
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCVAaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 20:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhCVA3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 20:29:43 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0076C061574;
        Sun, 21 Mar 2021 17:29:43 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id u7so11164549qtq.12;
        Sun, 21 Mar 2021 17:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iI8rxt66zYATN/fNvJ7MmsCX7tatuiO7IpRZEyDZfIA=;
        b=bTOpulPPOgm7yaqfGt1HMgRtws97kOCJ2nwngG66rdykSNglLYUqzZlH3sVbKqaz6b
         xfIi0hoCAUwTlEkVWSNqK6Id/U1JCJzKl7uMQkAp0YhDFgo4qNf5QFGbzP8GnPHd6Ee7
         u0JECJh0xAX8IshDOQYmpqa6WuRn8vFVSMjY+XqUGTIeR2XbJPyGtMPfWO8YlEB0qoSf
         4fnmuCxxEBNWEkK/FbtQ6egfUFjrUmypUrU3MxRzB3bc/9C7HLgQaFu6egEBPekjloC4
         ifyt4mJx+gPFH+WBqVG//YnfbrF0VpaBk0eiYHWdMwv7hHEb+XdAT2n2Ou+1Fz7TdTbA
         +ehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iI8rxt66zYATN/fNvJ7MmsCX7tatuiO7IpRZEyDZfIA=;
        b=EM47cnVG6vLLFQK4culMAQHmTMktxzaUKi1FPvQ+uV8W6M1sQ+DSlWOg6bluh1WhNV
         pdXVnUkm4gfTFbAzimwZ+qb82lCWOAZU9KY3R9v/FBfD2nGjFvgKTb7wTq6khyuS/D/r
         fy76khB3EzyGEkKvmjJ9MTbNz+kBCA5Zd2VZfqXYxunXhr34USUZRmkXsToOkZ44AcJf
         iZNgMKBneusdlKoOHz8jWdWe0zMuPsudzGGXp8QPFYqtd4OaxGHDbb3HFNU2WdIERSlp
         g5p+WkjGgMT39b7/+fuiu1s4mmrt4rkL9Ixf7SsTxSMhhaxJvA+Ew++syjTHZMaV9Ofu
         vKCg==
X-Gm-Message-State: AOAM530JaFrOaYnWWkaXFJvYo3VdsjBKmIx1oKpw1b3MCjYtCCc8mUVV
        wBOgVcWXKJW4pQLdf/jnoKc=
X-Google-Smtp-Source: ABdhPJx8EoNzPXUW2MBC88Yd7nHLAS8JppqrgE0p0EEHmfG6gP5mWdXsy0ajMWTIRX4LnLuJr/DnNw==
X-Received: by 2002:ac8:7f53:: with SMTP id g19mr7733952qtk.249.1616372982874;
        Sun, 21 Mar 2021 17:29:42 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:f925:bb4b:54d2:533])
        by smtp.googlemail.com with ESMTPSA id j3sm9721373qki.84.2021.03.21.17.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 17:29:42 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH 1/2] scsi: myrb: fix null-ptr-dereference in myrb_cleanup
Date:   Sun, 21 Mar 2021 20:29:34 -0400
Message-Id: <20210322002936.1352871-2-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322002936.1352871-1-ztong0001@gmail.com>
References: <20210322002936.1352871-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

cb->disable_intr may not be set yet when myrb_cleanup is called.
check before using this function pointer.

[    1.410913] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.411273] #PF: supervisor instruction fetch in kernel mode
[    1.411566] #PF: error_code(0x0010) - not-present page
[    1.413138] RIP: 0010:0x0
[    1.417711]  myrb_cleanup+0x13f/0x1b0 [myrb]
[    1.417939]  myrb_probe.cold+0xc6/0x6fc [myrb]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/myrb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3d8e91c07dc7..ee33d97fb92c 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1240,7 +1240,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
 	myrb_unmap(cb);
 
 	if (cb->mmio_base) {
-		cb->disable_intr(cb->io_base);
+		if (cb->disable_intr)
+			cb->disable_intr(cb->io_base);
 		iounmap(cb->mmio_base);
 	}
 	if (cb->irq)
-- 
2.25.1

