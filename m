Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885B4C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5C8613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhENVft (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:49 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:33741 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhENVfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:47 -0400
Received: by mail-pj1-f52.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so1961866pjo.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6UYooSiQef4zit3Gqi6nc76HmL0lSxvqul04f7IY2Q=;
        b=rXOgOYhWKXG+KmWpb/Vqfc2B2H8VgNUWrs5TKMzjc+FQsLYtcwBaQXHOeHn4See2/V
         FHyk26JUvcOPhZQDXzDi466NtmwZkXrbvsaS88HzzqeVgePi19qBTKxMBaHrZjHXdM54
         4+byw1AwHdUE2hRbNV414vfp7/GTp7J9urw9yAPyqffhrAyh59RB5rPOm2Zl/YU1Ycth
         7ssAOhtN+k/iFic8Yh6zl/khaHyN1tNwuN7iDMbcS2i3pbmkMYdX2IrR6uuWeW+1D9Nj
         t17e88IP88TebYcrJw0Q5ZbH89+wtJmsNC3HFIVL/X6u8mqk6MC+drMv74FDAFjDbWbM
         NqBg==
X-Gm-Message-State: AOAM531mji0KpDSlbbghSr0o6+/Ck1+T1B9lP1vfvvMR3ikpPFJQnN/r
        gsVD2qsrjqjqBTnNIlN/cVk=
X-Google-Smtp-Source: ABdhPJwbDGTn/xMtpEdl6IXInXfnz7hIjdxgH/bgfDJMdsH8mZ0J49tAfdH5xxxWRTmOeDeCd/NGAg==
X-Received: by 2002:a17:902:d488:b029:f0:a4e2:7421 with SMTP id c8-20020a170902d488b02900f0a4e27421mr4120864plg.53.1621028074600;
        Fri, 14 May 2021 14:34:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 17/50] cxlflash: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:32 -0700
Message-Id: <20210514213356.5264-18-bvanassche@acm.org>
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
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 222593bc2afe..c3f5df2f3509 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -433,7 +433,7 @@ static u32 cmd_to_target_hwq(struct Scsi_Host *host, struct scsi_cmnd *scp,
 		hwq = afu->hwq_rr_count++ % afu->num_hwqs;
 		break;
 	case HWQ_MODE_TAG:
-		tag = blk_mq_unique_tag(scp->request);
+		tag = blk_mq_unique_tag(blk_req(scp));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		break;
 	case HWQ_MODE_CPU:
