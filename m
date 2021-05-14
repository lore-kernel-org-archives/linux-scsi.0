Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9FAC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5078461446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhENVfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:37 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:34311 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhENVfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:33 -0400
Received: by mail-pl1-f171.google.com with SMTP id h7so111378plt.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/xwVNWxEkfoxLUwXj2D3n0bcSpzVFbgjluocNlb2IDo=;
        b=GlCyzelVcsU85pjUXIExGesGPmNsPUlDtNJmR5HMHk01jzcGZ0dKOZfvPh0sMctD2F
         5hfQtJ4QzaZRlKzp4xR0GGyIts9T/lfjMXnmmXWwj86xtqg51PRtUfipmy2nXH6lfs06
         QARNOW317v6FwtxV0twnPaA06UnvBo3MCwOvsk0cW+txFjot4t6eVGXeFBZRtdEqg2vK
         8DeBfLrepXIWPpa2PgOPlnVEnjSnImgxA2j3I08eYByvLkK5AIH3VYOPUBcVHr6T5RMc
         p8/b9WtrP4gSLxWvnQ+4EaK1uBfKCevYTn2xF+BTuDfC+kmSitz7AsoktoQP8ANo3KWC
         8oAg==
X-Gm-Message-State: AOAM530q61cZH1HX19+lwnuVFyIn/FszcRq/3UoDeSwgWvqiPmrgpPop
        2UnLkOHvTMgMCk95vAWSjjHd/9BmTM8=
X-Google-Smtp-Source: ABdhPJzwGG1T2XXbT4t+1dG+jlcvonpMauY+L7i96kFjIv9slA+SIRK40Ij44wB9SXBIXBA2UDypYw==
X-Received: by 2002:a17:90b:4d82:: with SMTP id oj2mr9060475pjb.61.1621028060656;
        Fri, 14 May 2021 14:34:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 09/50] rdma/srp: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:24 -0700
Message-Id: <20210514213356.5264-10-bvanassche@acm.org>
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
