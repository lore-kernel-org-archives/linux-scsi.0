Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C21C17441
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A6B821A49
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKLRzi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 12:55:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34798 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLRzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 12:55:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id e6so19622689wrw.1;
        Tue, 12 Nov 2019 09:55:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PKqltzNuj9+V9K/S4mkpmqKkAX19ynUBErL0SLJsqZs=;
        b=b9mqxNVW7eA3ZPer+6ZW85xiC+6m2223omOhpaR+qIVF8D3+bvy9CdNeNzinyU7gEU
         Bc/qPwjm9qSJuKDeMfCp6088PeKwY47P3BiWUYol2yxUUx9vgxhD4CC2o9I7m7WTCIWC
         ZyoVgVf218/rgoFiVGJ5teRJXa1kXJm6oqrlRiWrnvFywbGK2gSL4DFkxUour3QrFFkw
         ugCXRrCm1TC4OoHGSkA6e/oAvIUcbdUimbkzGv7jbFm6wZYHN9pcnnAJvMV0w3ql6uMe
         xDEKf4mw5Yo4wGXY9zPrCPJknTwFgA6P7gd10tCEpODBNbV8cmBbFaO7zMMGQaXZWJHW
         aRIA==
X-Gm-Message-State: APjAAAUYKeRkxNZS+aVg/pomvCmW3+P6f/5Itx78azG8tPf7DnAgxyKA
        t4ugIpMxY6+ohrvEd2zcwLg=
X-Google-Smtp-Source: APXvYqxLiPDWnqkcjTCaRSjaKyoD44ZA0f5SKqdVCMWFCU45LZWQ10JagIAJdQGDMjlZn5wYhdgF6Q==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr26462034wru.30.1573581335747;
        Tue, 12 Nov 2019 09:55:35 -0800 (PST)
Received: from localhost.localdomain (82-75-169-199.cable.dynamic.v4.ziggo.nl. [82.75.169.199])
        by smtp.gmail.com with ESMTPSA id a8sm4229125wme.11.2019.11.12.09.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 09:55:35 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH v2] zorro_esp: Limit DMA transfers to 65536 bytes (except on Fastlane)
Date:   Tue, 12 Nov 2019 18:55:23 +0100
Message-Id: <20191112175523.23145-1-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <1573414513.3230.4.camel@linux.ibm.com>
References: <1573414513.3230.4.camel@linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When using this driver on a Blizzard 1260, there were failures whenever
DMA transfers from the SCSI bus to memory of 65535 bytes were followed by a
DMA transfer of 1 byte. This caused the byte at offset 65535 to be
overwritten with 0xff. The Blizzard hardware can't handle single byte DMA
transfers.

Besides this issue, limiting the DMA length to something that is not a
multiple of the page size is very inefficient on most file systems.

It seems this limit was chosen because the DMA transfer counter of the ESP
by default is 16 bits wide, thus limiting the length to 65535 bytes.
However, the value 0 means 65536 bytes, which is handled by the ESP and the
Blizzard just fine. It is also the default maximum used by esp_scsi when
drivers don't provide their own dma_length_limit() function.

The limit of 65536 bytes can be used by all boards except the Fastlane. The
old driver used a limit of 65532 bytes (0xfffc), which is reintroduced in
this patch.

Fixes: b7ded0e8b0d1 ("scsi: zorro_esp: Limit DMA transfers to 65535 bytes")
Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
---
 drivers/scsi/zorro_esp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index ca8e3abeb2c7..a23a8e5794f5 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -218,7 +218,14 @@ static int fastlane_esp_irq_pending(struct esp *esp)
 static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
 					u32 dma_len)
 {
-	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
+	return dma_len > (1U << 16) ? (1U << 16) : dma_len;
+}
+
+static u32 fastlane_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
+					u32 dma_len)
+{
+	/* The old driver used 0xfffc as limit, so do that here too */
+	return dma_len > 0xfffc ? 0xfffc : dma_len;
 }
 
 static void zorro_esp_reset_dma(struct esp *esp)
@@ -604,7 +611,7 @@ static const struct esp_driver_ops fastlane_esp_ops = {
 	.esp_write8		= zorro_esp_write8,
 	.esp_read8		= zorro_esp_read8,
 	.irq_pending		= fastlane_esp_irq_pending,
-	.dma_length_limit	= zorro_esp_dma_length_limit,
+	.dma_length_limit	= fastlane_esp_dma_length_limit,
 	.reset_dma		= zorro_esp_reset_dma,
 	.dma_drain		= zorro_esp_dma_drain,
 	.dma_invalidate		= fastlane_esp_dma_invalidate,
-- 
2.17.1

