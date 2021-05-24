Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D01C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1CB61151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhEXDKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:49 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:39734 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhEXDKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:46 -0400
Received: by mail-pg1-f173.google.com with SMTP id v14so16330688pgi.6
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KYyvj8sPypakZuMmZlRPWY8QgoYwTR2Pr8+T7m6OEgU=;
        b=mCQnlit0Ft4DO3d1MJeGXqPhPHr/gSupF7hqG/q9LXIhtcrAnLFBx+P6bOneClnsHB
         dUWOUcOpNzU649sWgd5p1tlMYJPgnuhhYijDUJg+jpLgCvSoPoSkyNPj/fIpezku3J8t
         Mn7RM0vLWesmVWHk7CtvcfXMEsSAPpAAim4zjp1XMByASxDbZ5pgpbCSEO2iUwfGU68L
         eJxcFXapZ82BDK3etCrMGQHPcdw51TJMqPAU3SblPwpB8H3D+RX6MD+eJ4imFk09YpTf
         d3qZ+Rn4JbDO9EUrpBFu9IJbMbQKlXJzA5NYRPMwiOJ+YIvxj1jyY7S5XYw0MntgiJzx
         i5TA==
X-Gm-Message-State: AOAM5336LUb5Kz55rL7EnmxPcs60iUjCoPHX/gjb4ywwQr874zBDe0Hm
        1tgHEGw/WjRXIYs/BQ6Phws=
X-Google-Smtp-Source: ABdhPJyTWDnGKSmb/TQifXANyVjsKw0gFakYyFQ4ydQwaYdgbK5Z6ATCGyG2C7eExo4qH9YJ06jD1Q==
X-Received: by 2002:a63:1e64:: with SMTP id p36mr11138126pgm.105.1621825757513;
        Sun, 23 May 2021 20:09:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v3 09/51] RDMA/srp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:14 -0700
Message-Id: <20210524030856.2824-10-bvanassche@acm.org>
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
