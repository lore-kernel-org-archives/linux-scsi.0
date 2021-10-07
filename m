Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E214C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282DE60E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242523AbhJGUdH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:07 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:41902 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242486AbhJGUdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:04 -0400
Received: by mail-pj1-f48.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so6141284pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jT07YcNAYpM/yjLcB8hRpPTWU3XSM5z6Yr+Nf87OGNE=;
        b=bqMYm/sDcHhlKRFH+BypqdxTpA+r1+0CrY6+LQ4KF8gRb1jsCb39tEvpyEweaW+acc
         c2K+Tj4H8zg9FHVTYMnY9rrUSDJZCxvaPNWrkoz9EllXKBJB0pl8OvofGxCKMD1lTypi
         QJWHG7qB8RjJaso/Q26Dw8dcQvdX+CSuAW9Zpz2WE6asd+m4tRTpMZSm5aX18s2Ps348
         foGJp+bisfpk0bI32pKDcY34hPWMkc31sJXhDRbX2jvEfoy6s4TE6O814pHB6izsN16A
         LJaVKbLLPKtWAQpKw4WhNeNdqpuGJPJGdo5deMu8LfQBuI7zwP6aEgvGtBgV00Ym3JRx
         VIWA==
X-Gm-Message-State: AOAM533m4Bdw/80TErV6CxH0aqQdtFLNmYX6pQOrTi7mol7iwQ+E59u+
        iKHgOLxoElZFnD86s5RIMumNTEjzXVA=
X-Google-Smtp-Source: ABdhPJwYU97EX4DVlPLUmfFd0Me7d5H43l05xuochXYV+vXnIyV2volp7UM/Yy5Tt9GIW6NVIZ9/hw==
X-Received: by 2002:a17:90b:1d04:: with SMTP id on4mr7189592pjb.68.1633638670012;
        Thu, 07 Oct 2021 13:31:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 58/88] nsp32: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:53 -0700
Message-Id: <20211007202923.2174984-59-bvanassche@acm.org>
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
 drivers/scsi/nsp32.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index bc9d29e5fdba..1057b6fd7569 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -945,7 +945,6 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt,
 
 	show_command(SCpnt);
 
-	SCpnt->scsi_done     = done;
 	data->CurrentSC      = SCpnt;
 	SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
@@ -1546,7 +1545,7 @@ static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
 	/*
 	 * call scsi_done
 	 */
-	(*SCpnt->scsi_done)(SCpnt);
+	scsi_done(SCpnt);
 
 	/*
 	 * reset parameters
