Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EEFC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1D2613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhENVfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:46 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:53017 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhENVfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:41 -0400
Received: by mail-pj1-f47.google.com with SMTP id q6so532807pjj.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yIIFvRIv7OLSpsGdeLExpFVQyXxiBLPv0iUfrznOEYQ=;
        b=hlSgRwIvur/iNVxVEr+e/sRSpyX3Ew//nXd1hFl9BDcpmhtevgM3nkxlHzDX/068lx
         TbCrxkYeBJMc/itHNT5wqZG4iYHB8Bs4EA+66aeumV9hoqKFYufJ0n6bMnhw178jESmM
         DINyJ++v8aY0mP6v8bJYym0fgc9cqErXkfieCHvUZ07gBwthZXH6UAd+ZGQNnRGHCEqx
         Lo7LIfNMcJYOtWdfOKyCC3pa0Q1rR24gtDrnrqWdloIyUIaSIAcnZGxwQ8dEb1iG5b2J
         stesc6DMwiXck4Kj1bKGwkOTh8sAgahCzXNd85FcLmw4uPIf2wgkjU9KcVSa0KdUhi1j
         UKaA==
X-Gm-Message-State: AOAM533Rv46444cCBuVSnwcceOx7UyryUhYxVOHKLl6miL4vNbVjbthy
        ezAKeVmB2wx2NFQUsl7k4a7EnASETCgIVA==
X-Google-Smtp-Source: ABdhPJzX5mblcoTFuAxrkL6OnizStP0N9bB7QWWdHHQSnSOMjr+L+cksqufpLjTJoCAqXG1wpGgxUQ==
X-Received: by 2002:a17:902:c784:b029:ef:b14e:2b0b with SMTP id w4-20020a170902c784b02900efb14e2b0bmr5973434pla.64.1621028069885;
        Fri, 14 May 2021 14:34:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 15/50] bnx2i: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:30 -0700
Message-Id: <20210514213356.5264-16-bvanassche@acm.org>
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
 drivers/scsi/bnx2i/bnx2i_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 43e8a1dafec0..70e9a8e6329d 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1918,7 +1918,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 
 	spin_unlock(&session->back_lock);
 
-	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(sc->request));
+	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(blk_req(sc)));
 	spin_lock(&p->p_work_lock);
 	if (unlikely(!p->iothread)) {
 		rc = -EINVAL;
