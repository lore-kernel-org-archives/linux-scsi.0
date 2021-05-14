Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B66FC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D7426143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhENVgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:22 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:33535 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhENVgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:19 -0400
Received: by mail-pg1-f169.google.com with SMTP id i5so289716pgm.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dzMV4G/EBdC4YA4YLk20EfAVOl39gvVVvCFY9AvGB4Y=;
        b=b9UkQbw+dq3CC0K0wCiUW8crn8wbu9vQAyKsjJt8kOC1GM9Jc1h9bgD7y18y1MxfQi
         4uln8Pv9spwEmb/RKm1rgHR4Hom8eN/gkDXjakHKoykNZj+/rScYFp52UmAVOMilhmmQ
         eFPGVDTSVL6Cs6ScOfwbKfS6gu4LhJuJTLsGPeAWwpLSYrWnx1c0UxdatXK2Li4tg3cG
         KDDi1TtwyyvafaTWtBUrwCGjzZW2l8uyS9yeSFbTLPfZrRwt3DUcteIxjagynHv7S+ki
         8He1/3/u1M/YuUVkxufwNoc5ILJKKHN+0bOX8BsElD51WNo8DlgabChu+xiY1Z9eu7XQ
         Lz8A==
X-Gm-Message-State: AOAM531s5rkzEiOpUqLAHlBfALV51h3LJOTkMxPvko3zloTykSn5ZDqD
        kQKGwoi35gKdS3mbUJ1m+sQ=
X-Google-Smtp-Source: ABdhPJw3rBiixwBHl46TV0HXu0IKxMztx8Q0ef9b5r+uWAKaDESG4gPBPNqj94uXwrU4Wv+TbRHyfw==
X-Received: by 2002:a65:60cc:: with SMTP id r12mr8137469pgv.164.1621028107490;
        Fri, 14 May 2021 14:35:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 36/50] qla2xxx: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:51 -0700
Message-Id: <20210514213356.5264-37-bvanassche@acm.org>
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
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4eab564ea6a0..454857fd25d6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -849,7 +849,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		uint16_t hwq;
 		struct qla_qpair *qpair = NULL;
 
-		tag = blk_mq_unique_tag(cmd->request);
+		tag = blk_mq_unique_tag(blk_req(cmd));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		qpair = ha->queue_pair_map[hwq];
 
@@ -1742,7 +1742,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(cmd->request))
+		if (ret_cmd && blk_mq_request_started(blk_req(cmd)))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
