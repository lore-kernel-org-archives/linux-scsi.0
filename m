Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5979C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A141613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhENVhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:09 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:41949 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbhENVhC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:02 -0400
Received: by mail-pf1-f172.google.com with SMTP id v191so643580pfc.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/xwVNWxEkfoxLUwXj2D3n0bcSpzVFbgjluocNlb2IDo=;
        b=PZR7FMXm95SFB0GhBDt2Pneq7ozo4KaDNfX9/1xEjXZcWDzz2xefMqW2m9REVdS+71
         h3bQugP3//l4mp8lsdCi0goXbYdib5SC7KpP0vgJkG/+NNm1yll06rBHqPijJQupK8Sm
         IFvVeZj6U4+D2t1tYyoC2hGtrMP9dD2lnM3NHxS4tlog+UKH25arEO3gyjWT7agygKNy
         VHFph8LTU2Oock9IPw8oOrm1cmp0oeiMMvYlJIJzX3Ufs5n+irjPLKUruMivGnvxA0qW
         JhR3YbFbxgWF1KzSJ3v/IgweM6YslYBjoMd7NOmDAvpSR1gxS7jCObVEE2XV955/st8H
         KuWw==
X-Gm-Message-State: AOAM532/JR+znx4b84eravHse5I6xCDC01qc75yKmEHNnGpaTBKMghz1
        s6PZ5Np2lYNvIe3ABbUkrdc=
X-Google-Smtp-Source: ABdhPJwhBT00tX1pSv9tz1K0vtGbKz4L7K2uasq0RKPodXMj74J7w0Dc6zGehEYgYJINxaS32MxR6g==
X-Received: by 2002:a63:b243:: with SMTP id t3mr39945159pgo.253.1621028149168;
        Fri, 14 May 2021 14:35:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 09/50] rdma/srp: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:15 -0700
Message-Id: <20210514213356.5264-61-bvanassche@acm.org>
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
 drivers/infiniband/ulp/srp/ib_srp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31f8aa2c40ed..0575f5f3ae53 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2182,8 +2182,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
-	WARN_ON_ONCE(scmnd->request->tag < 0);
-	tag = blk_mq_unique_tag(scmnd->request);
+	WARN_ON_ONCE(blk_req(scmnd)->tag < 0);
+	tag = blk_mq_unique_tag(blk_req(scmnd));
 	ch = &target->ch[blk_mq_unique_tag_to_hwq(tag)];
 	idx = blk_mq_unique_tag_to_tag(tag);
 	WARN_ONCE(idx >= target->req_ring_size, "%s: tag %#x: idx %d >= %d\n",
@@ -2814,7 +2814,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	if (!req)
 		return SUCCESS;
-	tag = blk_mq_unique_tag(scmnd->request);
+	tag = blk_mq_unique_tag(blk_req(scmnd));
 	ch_idx = blk_mq_unique_tag_to_hwq(tag);
 	if (WARN_ON_ONCE(ch_idx >= target->ch_count))
 		return SUCCESS;
