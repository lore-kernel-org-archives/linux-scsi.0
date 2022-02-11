Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694FCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348124AbiBKWeW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354146AbiBKWeK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:10 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3ABD52
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:09 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id c3so5785422pls.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rnPGc2HmiwKa1PtCl2I0Ff3xuRZvI73UsIWDdkAtGSY=;
        b=NLF1T4F50etvyowCdq5UWGZNpApFgib9bRIX45k27fxvlK1VyH805m1nEFoWoDQivT
         biM7mnxVBMURKoOwBJPw3l//MihC2Q57tbhBrh+6jgqkWjPvbxpGKI8JzGj2pvlUcTnv
         C3FkrpwGH+8NbZnTEzCXHLbQPv3SKa1gGM6cjaHNKK9ec9+t0HHvGJBgHaRZJeYTNIKw
         ozl4mrB3HrLbYbNOKnHUcI0MVISy8FRpf15DoTNTJ5Pi1UqCyY1JgtMUDVsEAZlgxqNe
         lI5aJ4kFIBPSp1XiitA71YQuYJBwSM1ELkT5TmHRfT4mNIIy20LEqlB35WGAwmu0byj3
         Ybsw==
X-Gm-Message-State: AOAM531TjlXUhpi2P3BqXYB8FVS8qUhfMiq+AYVw4b9yqLPgZvmMuJK0
        g6Enqds7bkWNslnTFKjEzOGrW08CROdfz8ct
X-Google-Smtp-Source: ABdhPJz3pLJJL9KprPsyt7e+cM06XFrBXNcqmfxZEFSSiId39bzBfqxYkjx44X8C5wj7Ob9Xk9hb3g==
X-Received: by 2002:a17:90b:3908:: with SMTP id ob8mr2576000pjb.73.1644618848585;
        Fri, 11 Feb 2022 14:34:08 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 29/48] scsi: mac53c94: Fix a set-but-not-used compiler warning
Date:   Fri, 11 Feb 2022 14:32:28 -0800
Message-Id: <20220211223247.14369-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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
 
