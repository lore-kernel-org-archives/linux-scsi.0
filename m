Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D93DC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2298661151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhEXDLv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:51 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:35487 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhEXDLp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:45 -0400
Received: by mail-pg1-f176.google.com with SMTP id m190so19062448pga.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qjkKBA4uNCWH2mTP+yZ3vIfvVwLp3WuZYDfjgLtrzT4=;
        b=aFz6fHPUuikU+7rIug4MeHVG/2ywxZca0Xbqn73bFGck5cjmwf+0AdsmKc1paznHhh
         KgTvIyS+E3dmzs+WyHRfEnJN7KNTQ79J/2o+GQonzWjLb3Efp/8oMyuFn7mhSqbtR39U
         DtCCgWwGjBMVIlFVQw3WV93f8ILfeT0it3iDCuVBn3V7/MJY7i1aYqheqjpxl4yRaWYh
         z1AurPkSBZ4ehaGn8M/OmuHvUjlW4LBhEfFlvMbR0LbEAIGOg5Qi9iFTcp4PZpvErkh1
         EKwTs+nI1RA1h9Fxu6d9ORkfzLaih84R1YNwnqrNMD+g+LaQXClZ1LDVloj3Wgyp0bQl
         9E9g==
X-Gm-Message-State: AOAM530gvWBuRxPbghIppCoxIW7l8IpfoBiNkHW5GeelEXdeqMYib8ZM
        Mdtbzg0epu1Ugpjox5Qs2ok=
X-Google-Smtp-Source: ABdhPJx/w+S+f+HLRMSlD5vDia3K95Ke3tXnk/mmL2btw1FgbsTOxM87VXei5JwwXuMg2DtU+gNLpQ==
X-Received: by 2002:a63:5b08:: with SMTP id p8mr11418744pgb.193.1621825817966;
        Sun, 23 May 2021 20:10:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 44/51] sun3_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:49 -0700
Message-Id: <20210524030856.2824-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sun3_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2e3fbc2fae97..d6000a397f73 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -336,7 +336,7 @@ static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 {
 	int wanted_len = cmd->SCp.this_residual;
 
-	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(cmd->request))
+	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
 		return 0;
 
 	return wanted_len;
