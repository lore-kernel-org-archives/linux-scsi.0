Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE34CCA9EC2
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3AAF208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732323AbfJ1UHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:22 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35340 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732399AbfJ1UHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id x6so2155286pln.2;
        Mon, 28 Oct 2019 13:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qgYaQ/4w6DU5OAfx3juTipbLvhVJGJbsViU8yUiC/dU=;
        b=Ox/OWwkPyk4mh2RW6gI/L5NAsNR579MbAjgTlaY4Wd7/YTRtwUwrRA/Uf6Sxv+G0Hh
         gjCUh/K8DDZw3J4yq3KJ39u0KURZsH3nTgJfnRDYk8TyqqAGXvsRqhRRjRR26Vm794Aj
         lfOn0n5VHRyjK7kxBUUN7nnLQA5mynor9EzVca4+/+tdtjHvL6/BtHR4CYhy5LoSeLS3
         uDESFiPKW6JF60LB/RnWof6nEPiyL4Jh7YNVZmDnpZlBztjLWOvQoRrksyJoJ2JeuGjH
         KugjcUXfOGUOBP4uGIK8U2mKoJx1nMXYr/cZnyKCOIbEEjW0dB+Iwa4KS6fxau6TUHFH
         vUfQ==
X-Gm-Message-State: APjAAAWZHI+g/YYE865Fomd1QAAe/re+WbQWTbz8RSkYShvO7QVt87oj
        tUMGV+SjyIh+srwkFhUrw8M=
X-Google-Smtp-Source: APXvYqxECuqfJhEN4zSLeOmEK6k51rQVb9Fler5QHU7PuW0Xo8hSyRLLoC3ofFeK1dnL+ymZ098IBw==
X-Received: by 2002:a17:902:d209:: with SMTP id t9mr21318494ply.278.1572293238573;
        Mon, 28 Oct 2019 13:07:18 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 7/9] arm/ecard: Use get_unaligned_le{16,24}()
Date:   Mon, 28 Oct 2019 13:06:58 -0700
Message-Id: <20191028200700.213753-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use these functions instead of open-coding them.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 arch/arm/mach-rpc/ecard.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-rpc/ecard.c b/arch/arm/mach-rpc/ecard.c
index 75cfad2cb143..4db4ef085fcb 100644
--- a/arch/arm/mach-rpc/ecard.c
+++ b/arch/arm/mach-rpc/ecard.c
@@ -89,16 +89,6 @@ ecard_loader_reset(unsigned long base, loader_t loader);
 asmlinkage extern int
 ecard_loader_read(int off, unsigned long base, loader_t loader);
 
-static inline unsigned short ecard_getu16(unsigned char *v)
-{
-	return v[0] | v[1] << 8;
-}
-
-static inline signed long ecard_gets24(unsigned char *v)
-{
-	return v[0] | v[1] << 8 | v[2] << 16 | ((v[2] & 0x80) ? 0xff000000 : 0);
-}
-
 static inline ecard_t *slot_to_ecard(unsigned int slot)
 {
 	return slot < MAX_ECARDS ? slot_to_expcard[slot] : NULL;
@@ -915,13 +905,13 @@ static int __init ecard_probe(int slot, unsigned irq, card_type_t type)
 	ec->cid.cd	= cid.r_cd;
 	ec->cid.is	= cid.r_is;
 	ec->cid.w	= cid.r_w;
-	ec->cid.manufacturer = ecard_getu16(cid.r_manu);
-	ec->cid.product = ecard_getu16(cid.r_prod);
+	ec->cid.manufacturer = get_unaligned_le16(cid.r_manu);
+	ec->cid.product = get_unaligned_le16(cid.r_prod);
 	ec->cid.country = cid.r_country;
 	ec->cid.irqmask = cid.r_irqmask;
-	ec->cid.irqoff  = ecard_gets24(cid.r_irqoff);
+	ec->cid.irqoff  = get_unaligned_le24_sign_extend(cid.r_irqoff);
 	ec->cid.fiqmask = cid.r_fiqmask;
-	ec->cid.fiqoff  = ecard_gets24(cid.r_fiqoff);
+	ec->cid.fiqoff  = get_unaligned_le24_sign_extend(cid.r_fiqoff);
 	ec->fiqaddr	=
 	ec->irqaddr	= addr;
 
-- 
2.24.0.rc0.303.g954a862665-goog

