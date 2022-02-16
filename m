Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9990FC4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiBPVET (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiBPVEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:08 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7409222DCD
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:48 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id m7so3653332pjk.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rnPGc2HmiwKa1PtCl2I0Ff3xuRZvI73UsIWDdkAtGSY=;
        b=xfmEZPV3fwZNCrqG6pJqa/evgwTpF81//7Nr1W6v41mFX0r/virYNiyW5cD57ifogT
         F/uikVnwPmlDIHSIUqrdF+z5Sr/4+z4wmSv9GXzR8qNmmcyjBx1VghKg6h47TDmCGjvN
         d/yFFf2TTACnUbiMgW7UqJ17TnMXCvXp7zY2c7BzgkRPWLn4sXX7AqUM/t728/mymYr5
         l9caCG58atvWr/aJM9gu7xnvXTb1EZEZx0mThZJbC2e9gMZ5zx9ScATiUxd5xbXE4vg/
         wxDcLvpcfQvJXn6VEXIgr2NUfkF2o+vz8XBi0lBFv30vkypaVW9h6glD+E2tZnTYL8xG
         j+Bw==
X-Gm-Message-State: AOAM533D8ASBx9tm5iP0HymdNXTx3dbdeEEl7dXkeu6TfoL2XUZQztVD
        N+S76SIV9vPxGhOpumFZpi4=
X-Google-Smtp-Source: ABdhPJxUqYn9vQGoloc5GozziNoaeh0vhJE2hPdNex9StgI0VVewzcKXOV+lVoHI4fE/FrSugPVKzw==
X-Received: by 2002:a17:903:120b:b0:14f:14b:3485 with SMTP id l11-20020a170903120b00b0014f014b3485mr4277761plh.18.1645045428314;
        Wed, 16 Feb 2022 13:03:48 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 31/50] scsi: mac53c94: Fix a set-but-not-used compiler warning
Date:   Wed, 16 Feb 2022 13:02:14 -0800
Message-Id: <20220216210233.28774-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
 
