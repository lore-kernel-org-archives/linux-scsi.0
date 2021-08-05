Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9905C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D46660BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242739AbhHETUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:08 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:50730 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242934AbhHETUE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:04 -0400
Received: by mail-pj1-f52.google.com with SMTP id l19so11384262pjz.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPKq1F1MPTyTLjK6rpWD5zr2FjUTqF7F8c4lG2mKQnc=;
        b=t+pirfKVRJTC/4AbQe6Knz8SRl/p8VvDnxOKkYo/jAy49nImnAm5t8r5J6EppEzK6Z
         7SjBDZJcoGe1qODLwIfdPc0+hYfiHL7JDn9vHyE7V516ZATccXQRJgHolunhZDfnCir8
         TN5O0XrPRV8W16UA8lLIH1Dd2xpiP5iXbfu07R6cgSDZDAwnwXEySARl50jatWvWVNZc
         AcUutXlHSGvFBqtVnJvYjalrlMT2XzbYuFpsq3vLY32D1F5V2xxtp3RkDjd5byECZFTg
         rf/i/ofRWjVC7kJBX+nONiqRupdS7ZR3s2mcjRnNibDVAKfMeHVFtJg3yJbDfuch7CF0
         SY+w==
X-Gm-Message-State: AOAM533Up6O7rDM3L39xenM/fFwiA9hRTt5NErdlPPDQci7VdlWICODm
        PV6OAB5RTlRK8BeICvYClj0=
X-Google-Smtp-Source: ABdhPJyAIiKmXbVBh/yRo76j5YVk7rBR0cgPtDqxB2X+L4jmbGq4aRF7hfVXD6WVJElkXRhgQ8c/iA==
X-Received: by 2002:a63:ce54:: with SMTP id r20mr1405291pgi.164.1628191189823;
        Thu, 05 Aug 2021 12:19:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 38/52] qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:14 -0700
Message-Id: <20210805191828.3559897-39-bvanassche@acm.org>
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
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 868037c7d608..126ac7e24ea9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -854,7 +854,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		uint16_t hwq;
 		struct qla_qpair *qpair = NULL;
 
-		tag = blk_mq_unique_tag(cmd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmd));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		qpair = ha->queue_pair_map[hwq];
 
@@ -1763,7 +1763,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(cmd->request))
+		if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
