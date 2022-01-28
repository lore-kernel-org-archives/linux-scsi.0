Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611C0C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351691AbiA1WWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:10 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:41745 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346175AbiA1WV0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:26 -0500
Received: by mail-pj1-f46.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so7778585pjp.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BKokjTJ6BCRvKB5Q/r+o0ldLHgSA4imTESI+X5QjBHU=;
        b=u0CsJugjUx7vpg0+o4b8ysrVpYtW9H31f92vsqr4HjKJScKflBWfPRWqKgzkwZTUL4
         YTUBGAniwCBQMV9evN2bQf3ayoDFF6I+hmy2zfeomZG1H/TT/cKsAFzbjE0PQqI3PTmA
         5XqEa6Tr0lLS6569JxyxouYUls/GQIcZq8+mvRTvYt0Gys5knR4ug6HNMm99ZZNrUonn
         xNy/FI576thEzMnv0KnGqkXJpcIwUUlNASXVwhW0afkwJgEFW6WUnMeJujzw3vP9ldVq
         t/ElD6EAPnAmBCzDF5EOxshD7Yjoih/zq721FEM9/D5ehkuJbidA7NEMF8F+Rq4JZgDk
         K62w==
X-Gm-Message-State: AOAM5311pbinxZwE82qoNowrSKvRrzGUu1M+7swzH9Vn5Ra8nNv2uwQs
        FnzjIvE5qGeZZ+Sixs9NAIw=
X-Google-Smtp-Source: ABdhPJwgTKeUi7ORtNH8zIqOkLAuGQnGZTZ1tb8CcDTo9Z7o+yrNQGqePeThUxXV9ECMKaVn9ZR2dw==
X-Received: by 2002:a17:902:e552:: with SMTP id n18mr10499844plf.152.1643408486355;
        Fri, 28 Jan 2022 14:21:26 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 25/44] mac53c94: Fix a set-but-not-used compiler warning
Date:   Fri, 28 Jan 2022 14:18:50 -0800
Message-Id: <20220128221909.8141-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following compiler warning:

   drivers/scsi/mac53c94.c: In function 'mac53c94_init':
   drivers/scsi/mac53c94.c:128:13: warning: variable 'x' set but not used [-Wunused-but-set-variable]
     128 |         int x;

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mac53c94.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 3976a18f6333..cf81cbb0043a 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -125,7 +125,6 @@ static void mac53c94_init(struct fsc_state *state)
 {
 	struct mac53c94_regs __iomem *regs = state->regs;
 	struct dbdma_regs __iomem *dma = state->dma;
-	int x;
 
 	writeb(state->host->this_id | CF1_PAR_ENABLE, &regs->config1);
 	writeb(TIMO_VAL(250), &regs->sel_timeout);	/* 250ms */
@@ -134,7 +133,7 @@ static void mac53c94_init(struct fsc_state *state)
 	writeb(0, &regs->config3);
 	writeb(0, &regs->sync_period);
 	writeb(0, &regs->sync_offset);
-	x = readb(&regs->interrupt);
+	readb(&regs->interrupt);
 	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
 }
 
