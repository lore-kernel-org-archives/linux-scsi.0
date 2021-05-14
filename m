Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563E4C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5FE6143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhENVgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:42 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:47073 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbhENVgb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:31 -0400
Received: by mail-pl1-f169.google.com with SMTP id s20so86304plr.13
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xu/t//jOs37VZtA2QmDpOAmcMU6PvcySoOT1+rnB38o=;
        b=ksuo6rmo0GhWKgflVrLpbxAyTLLvgfqIkqWED9erxpt91DTsupCgJTPMpvTXcXFCsq
         6DozSPuAJWFoJ1nDqef6TSPl0qMSrO4gUqpggMUh4Yk7Ecdr0W4RgJb75KVrnvn1WLw9
         bUqLpKhsEMYX1fPoHYvHiB+BWulHm1dIFL1N9J5KUziqCp5ClIoWeuU6Ty5yIKujuBiE
         X0qgIE+hI8x6hcu9Ar1UeQ1azOb8dhHkEz3l7X4yhu+ysQonBANCPJ+QJlyhFOz2Q1HV
         93pW5PiDnrPN0N9TjGo2/b/jAGmiirqlrVLTBx0jHafPDe+8aSYq2bxfvL3ABEm5RFIw
         huTQ==
X-Gm-Message-State: AOAM530i6edCzNHlwPHOem/hp4uqoRRpYZCL5xwk3uCgwRjBjgGxIJuw
        TujA3t8H/FhzclWaTcHSs/8=
X-Google-Smtp-Source: ABdhPJztnnIrsEZMl5XE+TvUVV8bFtt8OUXRt7bUZMhbyf/lcJH8X8gZKbzmFOIYpDQOUmUdjkqzZQ==
X-Received: by 2002:a17:90b:e09:: with SMTP id ge9mr10872906pjb.232.1621028118003;
        Fri, 14 May 2021 14:35:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 43/50] sun3_scsi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:58 -0700
Message-Id: <20210514213356.5264-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sun3_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2e3fbc2fae97..3cb543a369f6 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -336,7 +336,7 @@ static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 {
 	int wanted_len = cmd->SCp.this_residual;
 
-	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(cmd->request))
+	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(blk_req(cmd)))
 		return 0;
 
 	return wanted_len;
