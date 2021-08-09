Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65080C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ABD960F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbhHIXFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:36 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:42619 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbhHIXFd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:33 -0400
Received: by mail-pj1-f45.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso2421689pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EtzP95s/sIcg0wtWbViEQxbiXj2bFSd4Jio6b6QJdGw=;
        b=Jz/6idSx/qfuSZdJ6EQNrIkmgl4FGMdUhQwsNEub2ERkkdpmHN8DSMntDlqxx1bg4+
         bDGjT5hPlH8jVWF1hqjQ5NCFQoN2topPHzMTYj4DQy3Tb1beIJDYz4/mfS00vOsywoJu
         od6R1wPzY32gT9Ak5w1qOmKdEY6hkglgG98PxTAy7//PftQzn4Q60mWgVLtYB3aS7tU/
         Hzc3FkttGJ3+RxhOapQkkTjap0KfvKZuINc7XRcyy9ZVUNSt9cGPfjPLb0I6taxnwQID
         CkAhK7DeBJiUj/F+8ojbTiVc7J91OOb6H78nXNlyMijKQguVZdy0aC7vVXR+vXfPKnSV
         MzjQ==
X-Gm-Message-State: AOAM532H+UtFmgsU0VmHXENomKCLlgKvnXSiZkE0mj009QHWYapzPLRF
        tvlZ/WclLlYSdYRbvBxtNUc=
X-Google-Smtp-Source: ABdhPJy8X0FtHh9AsS5aVtsinA35yF7BvsnnHABEC+QnzSkq+2eVt9JOhtZha/4ZlgEbEAFbe+3AwQ==
X-Received: by 2002:a63:5119:: with SMTP id f25mr38334pgb.271.1628550312121;
        Mon, 09 Aug 2021 16:05:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 45/52] sun3_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:48 -0700
Message-Id: <20210809230355.8186-46-bvanassche@acm.org>
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
 drivers/scsi/sun3_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 9ed0bb7ecece..f7f724a3ff1d 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -336,7 +336,7 @@ static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 {
 	int wanted_len = cmd->SCp.this_residual;
 
-	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(cmd->request))
+	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
 		return 0;
 
 	return wanted_len;
