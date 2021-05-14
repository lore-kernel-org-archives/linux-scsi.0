Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1804C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9949561440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhENVhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:10 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:42542 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbhENVhD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:03 -0400
Received: by mail-pl1-f173.google.com with SMTP id v13so94816ple.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=geElLRMks0iQAYLilw8v93f07YLDAo8etaoW0tK14Ig=;
        b=jKee2BMg7hxT1hAI0fSWTNrV4QdP5is7i1+/UElOwWMAxDVRtxJIG2jtOIQcwwm0sl
         PzXtZ6fSfSKquy8n4A1hUlKuyP6nJXZbxHfN2TRPm1Y+0wfSySOvYrDXvZ6bcq6FL5br
         OQD8RTOSH/QeOsXnbHZSigYXYXeRgqYwkYG3FDydOWAnB6c6yZe3ssSLa8PtceF3O06Q
         hXjFqWL1DPOCcwmJoyGYK6/LIeh70+KTxPLCYtzqqkltBYMNSbfNqZs4rGHqSY9mlTqP
         8U7U/Nk0+2SXOD5JvTrSNmGtcAYJS92vA/r9/cFz0YwYOuJ2+mAgjx+bC0wRftvPul4o
         fBqw==
X-Gm-Message-State: AOAM533q74Ixs8A4XWz7DMJpX2UiGBY8NFxXsDRvGt1KB9pC0aR9NSdn
        VaHSqouO02RJA8mJWpHqRdw=
X-Google-Smtp-Source: ABdhPJzFGK6L5DtscySZYHpJ3zaikvOyau4UcJpEm3GTqZLevrsORGYKKkgLGAUEvdPT1iXJ00qAWA==
X-Received: by 2002:a17:903:2287:b029:ef:671e:c943 with SMTP id b7-20020a1709032287b02900ef671ec943mr19840684plh.35.1621028150739;
        Fri, 14 May 2021 14:35:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 10/50] zfcp: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:16 -0700
Message-Id: <20210514213356.5264-62-bvanassche@acm.org>
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
 drivers/s390/scsi/zfcp_fsf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 2e4804ef2fb9..ac9223a7677d 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2377,7 +2377,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 		}
 	}
 
-	blk_add_driver_data(scsi->request, &blktrc, sizeof(blktrc));
+	blk_add_driver_data(blk_req(scsi), &blktrc, sizeof(blktrc));
 }
 
 /**
