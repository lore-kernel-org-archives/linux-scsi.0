Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BAEC47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BDE61166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhEXDLA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:00 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:35504 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhEXDK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:57 -0400
Received: by mail-pj1-f47.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso8656854pjb.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q36SflnryTrObAIdoPQMJHITJRxt4At+O2hiMdePM0I=;
        b=ttH5GeEtkpL0uv4E0d7XGlWShimtziM2V9etpF3YWPu4sBOAGf+N21g7Myj0Tr2Fal
         Y5e/4L7AARdVp3hxt7m2NxX79JEOkI0sxUobq3ZkXbaLIUVvwfjbqQCTfX2ucqTHBbyl
         FT4KJNh6olACuYDo3BPlgpbR62ZkdP2jtsUikgzYdHxr8RIQCzreO3W7hz8I/v/SKKi2
         yqxbS/254RY9BkR/OmlV9+jwzgVI84gwzvk+7kCkhauGzYPdBTz8qQqfS593N9N4vgq1
         T5FyPbMPmPpmcr4kD/zqUmrqihW4oVFa5lkk1T1h1iJzBNEu85QPLHbC59uyDsfgEuQd
         N2XA==
X-Gm-Message-State: AOAM5321Frz1JWrwvzVWE87344wi2imsg4b88rhj6rBuGG+KkCu1vYVz
        IePCZ0gvl/1E8MI/t/jYcvrJwffxJTQ=
X-Google-Smtp-Source: ABdhPJz+S+hCDz1oVXh9zucyu3MwHc8c0ldCd85hXRiq9IDpTSGV51QNE1Ivk/zS/ByftqnIEdJTsg==
X-Received: by 2002:a17:90b:2397:: with SMTP id mr23mr21823120pjb.77.1621825768475;
        Sun, 23 May 2021 20:09:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 16/51] bnx2i: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:21 -0700
Message-Id: <20210524030856.2824-17-bvanassche@acm.org>
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
 drivers/scsi/bnx2i/bnx2i_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 43e8a1dafec0..5521469ce678 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1918,7 +1918,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 
 	spin_unlock(&session->back_lock);
 
-	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(sc->request));
+	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(scsi_cmd_to_rq(sc)));
 	spin_lock(&p->p_work_lock);
 	if (unlikely(!p->iothread)) {
 		rc = -EINVAL;
