Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F07CC4320E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3DD960F35
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhHIXEj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:39 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:36382 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbhHIXEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:37 -0400
Received: by mail-pj1-f41.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1460437pjr.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=giX+Q5YLxAG/WYjc3QLRgqxBXl2k14UR8r/KtJMjROs=;
        b=BEeI1RhaB0G01hrqwlUi44TlKFcjH4ofkdjXX6qNoaQpduyh5TMUTtS2nCgQZYX74G
         1+vjCHc3DNrQNybEhz3I9ub/GmrDjnqZbU2ZG+3rZDWHUdzSKpDFWzfSDRwNwWxMhA1P
         puX0vyNtpQ8P27wR2NixIlPdkHmUKPuWVGI2CT9BWGa0e/SNif9XcsQYXiTQtBjpN/P7
         8Pim43yNbDK57azPMHEtJ49yBPoK20stHxdhZgC7m+Z1LZJHsm6e5UCU46r1HJYSYc3O
         GsNsHpCRD3XJVEwWwDfzeUrcZ8Y03dMLoDXPcpwvQDU8w8f6xWXJoz10T9F10Q+0Ghkq
         geQA==
X-Gm-Message-State: AOAM5316Af6c/SYaN/lAkbkU1UImZyiPl16uVV3BurYpCnFsMq0b7qmJ
        2Js7Uh+qpdHyHc+esR11H5A=
X-Google-Smtp-Source: ABdhPJzbjEP/1k3ald2qIZ52aFjhQD/PAXUV+dJY8UyRtLFyRIsk23qrCXTtbTiKyRdM6pcnp7bFeg==
X-Received: by 2002:a17:902:9897:b029:12d:17ac:3d40 with SMTP id s23-20020a1709029897b029012d17ac3d40mr8935514plp.67.1628550256615;
        Mon, 09 Aug 2021 16:04:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v5 09/52] RDMA/srp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:12 -0700
Message-Id: <20210809230355.8186-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8d5cf5eb5778..71eda91e810c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1280,7 +1280,7 @@ static bool srp_terminate_cmd(struct scsi_cmnd *scmnd, void *context_ptr,
 {
 	struct srp_terminate_context *context = context_ptr;
 	struct srp_target_port *target = context->srp_target;
-	u32 tag = blk_mq_unique_tag(scmnd->request);
+	u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmnd));
 	struct srp_rdma_ch *ch = &target->ch[blk_mq_unique_tag_to_hwq(tag)];
 	struct srp_request *req = scsi_cmd_priv(scmnd);
 
@@ -2152,6 +2152,7 @@ static void srp_handle_qp_err(struct ib_cq *cq, struct ib_wc *wc,
 
 static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 {
+	struct request *rq = scsi_cmd_to_rq(scmnd);
 	struct srp_target_port *target = host_to_target(shost);
 	struct srp_rdma_ch *ch;
 	struct srp_request *req = scsi_cmd_priv(scmnd);
@@ -2166,8 +2167,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
-	WARN_ON_ONCE(scmnd->request->tag < 0);
-	tag = blk_mq_unique_tag(scmnd->request);
+	WARN_ON_ONCE(rq->tag < 0);
+	tag = blk_mq_unique_tag(rq);
 	ch = &target->ch[blk_mq_unique_tag_to_hwq(tag)];
 
 	spin_lock_irqsave(&ch->lock, flags);
@@ -2791,7 +2792,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	if (!req)
 		return SUCCESS;
-	tag = blk_mq_unique_tag(scmnd->request);
+	tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmnd));
 	ch_idx = blk_mq_unique_tag_to_hwq(tag);
 	if (WARN_ON_ONCE(ch_idx >= target->ch_count))
 		return SUCCESS;
