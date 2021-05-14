Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADDEC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0636143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhENVhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:25 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:44778 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbhENVhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:15 -0400
Received: by mail-pj1-f50.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so465752pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6UYooSiQef4zit3Gqi6nc76HmL0lSxvqul04f7IY2Q=;
        b=GrZDmo/nQCEnzqOJ56R5Fi/BzLTzWjdOBncE6nWRTZBqvQ1mo9R+I8sBMnv7KwDINW
         BnbAfwLml0/jHq8uSl+z2gH++6yYf4Joi/IuU/vZ0Vth5WGVezsf0QX6iyJ6Ec9QkKMi
         3BiC3y5V+N4Bo85/2WkbdD6WLPD9Ap9WdvLznDrkZtEeMEihXZT/Z+NkMJZtsr4dpNAq
         HAqmi/gR1TwqNK5mzGbi1oWzy0xEJUCdKJdNkOGf0lxAvP2lHAK1iTDOpMd0Nz/EM9K7
         Bm6sZuuvusKuUXN5Z2hwkU2cW1XG9MM6RYTcAoyVT6NdcqUX75ivSPlVgBGT4y1bvMJt
         oDRQ==
X-Gm-Message-State: AOAM531yvi1cowi6WsUUTzcjqr1Lu8/I9Zlch7ZI5wi8tOFobCAJyw3W
        8bBZBqAig0PSxJJojQYmg3Y=
X-Google-Smtp-Source: ABdhPJwTkehg4g+PlejQdV+1BVqCnUo6OytEOrRk+i2zF9hwHFtCJa3F5LlaRByozO+liH31Nz37yw==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr54210078pjt.197.1621028163141;
        Fri, 14 May 2021 14:36:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:36:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 17/50] cxlflash: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:23 -0700
Message-Id: <20210514213356.5264-69-bvanassche@acm.org>
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
