Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1F6C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B0EA60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346848AbhI2WJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:36 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:38597 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347163AbhI2WJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:28 -0400
Received: by mail-pl1-f173.google.com with SMTP id x4so2524749pln.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jT07YcNAYpM/yjLcB8hRpPTWU3XSM5z6Yr+Nf87OGNE=;
        b=5omwm2QkSf4h4wlHZUTllmuLBl6TwNHkDXJimenBjKSmi3g35a+xb+cbnbpslLek+p
         6ul3/aFgvYCN2mrB+VJYcODickYFEF4/OdqMf5kB3clNpDQsqbKLvrPO5W/ehCExt21H
         Lt+RG8V0eMAeft6i4sUMKxwEzp24u0s6nnJi6jU8yoF6neTkp6Gc3rsr3YfLGnnz0p+J
         KAUF4jwM9/hiuYfkmLdxpMeGmA0/OGze/xfr8sACrMonYiM2nju8QLIEwXD0pCH7ahqi
         Tl5J/1fnviE9f455jdm53V8Rfy1T76WwS0tQbrbXm1gZqlqPvYDvPxQ9CxlCDdgvn/xA
         k0GA==
X-Gm-Message-State: AOAM5311qZkW6m/ZB6msMlNn1G9yCPJJ44Kj4IHxPZF2P5pJMBzJzBEI
        g2SPnDxRQyrR+voas+GSzPw=
X-Google-Smtp-Source: ABdhPJyFd5a4iojneV4GVN8bS3JunqoV5dEDc7Xj06X28KxJT/KUOW6CH5K2yIoJF208wcakpfZnEA==
X-Received: by 2002:a17:90b:4b4b:: with SMTP id mi11mr8856123pjb.41.1632953266477;
        Wed, 29 Sep 2021 15:07:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 57/84] nsp32: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:33 -0700
Message-Id: <20210929220600.3509089-58-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
