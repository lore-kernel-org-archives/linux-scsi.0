Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0280FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384340AbiBHR0f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384320AbiBHR03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:29 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C3C061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:28 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so3542638pjh.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rnINESWkv6hGS6ZMW8RYWYj63bHRQ9B5roMlceYidRc=;
        b=v56bUV7w3O4GWw+Nx0MTl7k9LcXdnf0OhDFRodBXBuDdiAJ1BNTex0AI5xL01fchQm
         E3rzf+SYaCpH8fDSv0/wMsofyudn1v3yzTIbY4guoPouqP+puF84FVQU38epxszDttTZ
         CEhGttEpg1dzlYonYbfrBdCn3yFM2aZGyKhSpqHeWBteCrh+k0QuXxfRr27aLvsTXecj
         ZzfXEO0UJMf3hwVCy26iorby7EBhZVvFeKtojPhlRJeb2Vdbdj7MPmkX27qCLq6ssy01
         0+yS9KvGm5MJvSGKc9VnWcPCP6NoUydkti9qKzVwRA/sbY/qtTvVkySWIAQ0acGVsRdq
         Juvg==
X-Gm-Message-State: AOAM533tbGj5mJ6+aDn2thb/3pCdSt6iWny4bASVdwtMo0EZvDuSeAEQ
        mEjLU1OCeJVtzJWkK+2neyw=
X-Google-Smtp-Source: ABdhPJwSfr9vRsF7noVLEt+5t22qbkf50d3yubBcmHNXbYsUbbMfLhgR94ApLR77z927WnlGsq51UQ==
X-Received: by 2002:a17:902:d48e:: with SMTP id c14mr4538621plg.129.1644341188121;
        Tue, 08 Feb 2022 09:26:28 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 25/44] mac53c94: Fix a set-but-not-used compiler warning
Date:   Tue,  8 Feb 2022 09:24:55 -0800
Message-Id: <20220208172514.3481-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mac53c94.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 3976a18f6333..afa08309de36 100644
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
+	(void)readb(&regs->interrupt);
 	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
 }
 
