Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA4BC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5504B61132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbhHETTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:23 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:54104 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242768AbhHETTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:08 -0400
Received: by mail-pj1-f48.google.com with SMTP id j1so11303756pjv.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jYcasF5s6bExKNX5RrSYPnRLQO1J5Nr0CUqpUUb83dU=;
        b=qeZmQ7To9rBoK/Qz3NbV9IOTrm/gWqrsQb8OtTYq9iD7SPUeIFCAe0knF06jQtsDb+
         DnxS1t76BblXWRlxXDInEy1FoALwUYh+FF+Xk87QD2d+qMtMWz2UpuftEUkCM6mCCcZv
         BCsHQhp1C+3vYSXM3MGSgQfhsre1+5CK/PdN3IdqsGxKqfvcm5Jp1HRsFVm1z4W45F2K
         m0tFKZTEFe5ZL5QC0nEmI0bpeM2sk0mMwqme2t1QPT1pPDyNTiivNCLjcF7SrknWEynM
         FVMSCChejp8N3heVKWiq/Q9glgw2yLpKsfnV1NAQyI0amLq6gIcgwT6zC++iCqSZSft9
         IN+A==
X-Gm-Message-State: AOAM532IJEGtpq+EKi3jzkWfoszyRPfO6VObZYYPI/yvjeohA7hhS+GO
        mNmsKFB0QJqjRYo2BHBxcss=
X-Google-Smtp-Source: ABdhPJyf/uwHw9iFWV/kw14UVbvZzq0lJR9YCLfr6hLvzACDtShMAWAqH7e+j80dkpA2RyW5a8SVjQ==
X-Received: by 2002:a65:64d2:: with SMTP id t18mr260987pgv.131.1628191133322;
        Thu, 05 Aug 2021 12:18:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v4 09/52] RDMA/srp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:45 -0700
Message-Id: <20210805191828.3559897-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8d5cf5eb5778..d3339b4944b1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2166,8 +2166,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
-	WARN_ON_ONCE(scmnd->request->tag < 0);
-	tag = blk_mq_unique_tag(scmnd->request);
+	WARN_ON_ONCE(scsi_cmd_to_rq(scmnd)->tag < 0);
+	tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmnd));
 	ch = &target->ch[blk_mq_unique_tag_to_hwq(tag)];
 
 	spin_lock_irqsave(&ch->lock, flags);
@@ -2791,7 +2791,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	if (!req)
 		return SUCCESS;
-	tag = blk_mq_unique_tag(scmnd->request);
+	tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmnd));
 	ch_idx = blk_mq_unique_tag_to_hwq(tag);
 	if (WARN_ON_ONCE(ch_idx >= target->ch_count))
 		return SUCCESS;
