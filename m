Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48A3C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C027960F4A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbhJGUdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:44 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:33565 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241993AbhJGUda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:30 -0400
Received: by mail-pf1-f178.google.com with SMTP id s16so6361466pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bb7RMcS6aWofjbIJF92wtw8NtOHtJtd4jm47r/Gt/Jg=;
        b=iaCEPpAS3fwt5+P/zbYHf8DbHI5Fr5RlbQfk4D/xRt3sn+xFyg9gMzhR2YjOaDbiuC
         O2x4fFOu3ZACPPJ54qTolSugXXpuQrcJcYBamQfdyp5azoEoVvKfXcU3Kpl60881Qc6S
         bP0cpNTuvB55Nc/AuEXk0ySVYNzB5FiKQqlOhI0k2nMm0wbMqKb8t3AL1KXPJ+EsZ8Jj
         Sm68Qhf6aLQ/HJNLN7HkSSIi/KGv7MRYX/h7ppnMB/xzF8Hq+v3/JYgU0tmfOchanewZ
         daZGnpEaK4r252emeLhkAyCR0lk8sVmG+iFKrA5XkzXMK/uRgpP0Tsun31+lNXl3NMej
         KqIQ==
X-Gm-Message-State: AOAM531W2CTqSIjNfmw8HF/bMeKjEBG9PvkOHCDjUniDHfyJK2vJISgH
        VvyZA2xLR6/8TOXbwp4Te3tPlS+f0cw=
X-Google-Smtp-Source: ABdhPJyuQGedJzd93uB8uwJwFygSNJo0jgkBPbkOb6aL61D8pEF+mwbH4fRIrwzbqUueFCiWz++psw==
X-Received: by 2002:a62:6d07:0:b0:446:c141:7d2d with SMTP id i7-20020a626d07000000b00446c1417d2dmr6044675pfc.28.1633638695754;
        Thu, 07 Oct 2021 13:31:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 74/88] sym53c8xx_2: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:09 -0700
Message-Id: <20211007202923.2174984-75-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 6d0b07b9cb31..76747e180b17 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -133,7 +133,7 @@ void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 		complete(ucmd->eh_done);
 
 	scsi_dma_unmap(cmd);
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /*
@@ -493,7 +493,6 @@ static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
 	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	int sts = 0;
 
-	cmd->scsi_done = done;
 	memset(ucp, 0, sizeof(*ucp));
 
 	/*
