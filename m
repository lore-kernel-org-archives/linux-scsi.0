Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE935C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbiBRTxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238184AbiBRTxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:14 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E32291FA7
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:34 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id w1so7969692plb.6
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rnPGc2HmiwKa1PtCl2I0Ff3xuRZvI73UsIWDdkAtGSY=;
        b=V0TF98hx1PyE91azHyd/p5JcOAUwjX/CFOtUrdEN89RtJQuko//vT87oczAETi4563
         fbgdl98GdiTl3oFXI+RU4LyiuxErYrnpJX4dG7UR1SG+7DieePbFs7ZV6AyMUAd3xvkn
         aky/0OsjxYSGv+L+g0SIzcrWKH+ms2JlgxuXfmcfj8ukvhngKOB3oiyefzGruSRGZiSn
         MrlPQIe0PNyYXwQNqihxPdDlKUlu+QaAOE4VDob8wgo+M5zsKHZ+YTNklbEnSlMygkP7
         kKxf26tsqlgfoyIDInKqLEyRgiLOgvnXrO9lb0VKnyLzdZ+wIMwRR6rXHTgITYO1Xfxt
         CMOw==
X-Gm-Message-State: AOAM533buOAFFo4/dCCavrY3cd87HDeKCjqE8g5WRNngJWEVrF7vz4os
        rMfhEeR1nUXgrndAjlk8dcyHaCwphfDXVA==
X-Google-Smtp-Source: ABdhPJznSN7Z3wqCTO5g/HQ1tZjK/tU3Ds54/jKhG4eGthVMKbAj9aU4+JUDuW9vZG6eec9TVTGJ9w==
X-Received: by 2002:a17:90a:e642:b0:1b9:9ff0:e238 with SMTP id ep2-20020a17090ae64200b001b99ff0e238mr9937856pjb.121.1645213954015;
        Fri, 18 Feb 2022 11:52:34 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 30/49] scsi: mac53c94: Fix a set-but-not-used compiler warning
Date:   Fri, 18 Feb 2022 11:50:58 -0800
Message-Id: <20220218195117.25689-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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
 
