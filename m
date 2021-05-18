Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57563C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D640611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351217AbhERRqa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:30 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:40475 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347101AbhERRqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:25 -0400
Received: by mail-pg1-f172.google.com with SMTP id j12so7531840pgh.7
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KYyvj8sPypakZuMmZlRPWY8QgoYwTR2Pr8+T7m6OEgU=;
        b=ZPs62solRlCqnevhNIM8qN8J/1/fnIQSu/FOIgNWvXvSBbUYmq1w4wigiQWPhjQNbK
         lOyfcqJr6NMATUEMvzo23smovgzfDf9tYKLZKjyNx5JD23uLYuG7/Mg0DwNrFPLCCQmI
         LCq75keeVjwVRew4PQLICOM/3un9UzdEQvB9N0U/bHjhmrKuCAiKDM8Y5lolj6sce8U7
         2KtWk7QU19E0gL8B2orCWvHRreZvvTf+JgnoGYNRbiUiqAgQqg+rNkfZ4jozLsUEvpoO
         DhZSliCygoDSWMeJJNZL/TznlVT4DWtyoBYzKDpHgH/zZpkmG7Xym0p0pk7Ud/S1ny2X
         mFGg==
X-Gm-Message-State: AOAM531yLW9nHqwRHmRTMc/s4tjLxV2kpPzcAFMIXvtU95sXNGjKaM7G
        E2VsmwI+3XMrJFoCJ+yoViM=
X-Google-Smtp-Source: ABdhPJxFDmHii8RkNfyMzAU2b3DOdFkyjgh80UnT0ip6SEhCXgEPqXTDX3oz9dqpwqr2Ese6GNQgZQ==
X-Received: by 2002:a63:2356:: with SMTP id u22mr6318078pgm.188.1621359906997;
        Tue, 18 May 2021 10:45:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v2 09/50] RDMA/srp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:09 -0700
Message-Id: <20210518174450.20664-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index 31f8aa2c40ed..e3a7ee8d451d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2182,8 +2182,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
-	WARN_ON_ONCE(scmnd->request->tag < 0);
-	tag = blk_mq_unique_tag(scmnd->request);
+	WARN_ON_ONCE(scsi_cmd_to_rq(scmnd)->tag < 0);
+	tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmnd));
 	ch = &target->ch[blk_mq_unique_tag_to_hwq(tag)];
 	idx = blk_mq_unique_tag_to_tag(tag);
 	WARN_ONCE(idx >= target->req_ring_size, "%s: tag %#x: idx %d >= %d\n",
@@ -2814,7 +2814,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	if (!req)
 		return SUCCESS;
-	tag = blk_mq_unique_tag(scmnd->request);
+	tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmnd));
 	ch_idx = blk_mq_unique_tag_to_hwq(tag);
 	if (WARN_ON_ONCE(ch_idx >= target->ch_count))
 		return SUCCESS;
