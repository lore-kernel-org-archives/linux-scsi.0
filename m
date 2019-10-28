Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA89CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32193218BA
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732577AbfJ1UHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38540 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730303AbfJ1UHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id c13so7655478pfp.5;
        Mon, 28 Oct 2019 13:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qqmafbxvt6DIwPrQ8GK8JiWsq1zCk4bn8bjPAnXJ94o=;
        b=XeMbqqxpF+XpG8E1XvUmqM5AgW5npoTrQsFzGmAx1L+/vuBH4IWdI+wOVLDjAZ8cRx
         DbAyXCT3P56EyD81uXC/r9A2n4uyNz1JzV+yUsSZ9U9K/1/RKuTlhjAqe05oUMnzJrQi
         TpObNa9lr2r7PoBQ3bLOZsLdSBIgTQFvG7m8wJzg/jstJI7Jq6oMqUom0PLK3rfj3sfo
         cnKw6yMfwpYRQUKzUSnKNlF2a2CwDgE+p5BUSq6kP+FG4E0xeemLwvfNPuLpLxf1Jqfe
         WTUwD0AyY8c5UA6mZXM6cpKZwFMgiW8lilxP5cO7hifafvQffZvRJYNk4jOxQQy4SV2A
         unmw==
X-Gm-Message-State: APjAAAVLSh0XcXe2h2buG5XSgPJrSbFh5gJ2Cs7lsQawCHJpC6Ts2u/P
        csK9FRPfheI996783to0tII=
X-Google-Smtp-Source: APXvYqy10CadmomzITN/67Bio0fCL4NQieKkQErSkx+ODEEALJOyZM0aGK3wXkK2z/rgynMOGPbxSA==
X-Received: by 2002:a17:90a:86c1:: with SMTP id y1mr1387473pjv.71.1572293235698;
        Mon, 28 Oct 2019 13:07:15 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Kai Makisara <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 5/9] scsi/st: Use get_unaligned_signed_be24()
Date:   Mon, 28 Oct 2019 13:06:56 -0700
Message-Id: <20191028200700.213753-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use this function instead of open-coding it.

Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e3266a64a477..53dc7706c935 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -44,6 +44,7 @@ static const char *verstr = "20160209";
 
 #include <linux/uaccess.h>
 #include <asm/dma.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -2679,8 +2680,7 @@ static void deb_space_print(struct scsi_tape *STp, int direction, char *units, u
 	if (!debugging)
 		return;
 
-	sc = cmd[2] & 0x80 ? 0xff000000 : 0;
-	sc |= (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
+	sc = get_unaligned_signed_be24(&cmd[2]);
 	if (direction)
 		sc = -sc;
 	st_printk(ST_DEB_MSG, STp, "Spacing tape %s over %d %s.\n",
-- 
2.24.0.rc0.303.g954a862665-goog

