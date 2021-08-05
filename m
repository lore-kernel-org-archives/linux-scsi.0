Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C2DC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D4E060BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbhHETUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:16 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:46767 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242930AbhHETUK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:10 -0400
Received: by mail-pj1-f46.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso8232863pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rfmZ9jtIiXwmdU1gkit8tqxaOOEQ3YAK+sCHQE4YbbM=;
        b=OXohXEe73NsJ3SawOBCXYD+gdE0LI6rpWdqQdfRxw0YgQU0IGPA0fYbrnwQzwOJ+df
         ss/E7A7dVp0P4SJ1QbGsD9tizGiRJp3/0BKN9NAyWBZHAVDIeqrBetT+2FJDT1tSbP0E
         Jhxfxa90h+SYP/00ih6HdNrhIJF4czVt0i+QSPAE51HVqya53xmfNOv7n0SSij7YOZdf
         bbX+VCVOysY18DGf9kpz0g46kz/6LEMlEvJ86T22MDqrX8UUzJR4642eT9127kxUnmji
         5qga+IxKJxAUqCfAp062c3ibU+9SRuOK9yub4KkskYj6Op8YuJ0iJbkEzaGGp0sAZYZ2
         wEVQ==
X-Gm-Message-State: AOAM530YWnFsiXldjqCXrTxLdCnVg9YFtHNQhnwvlWtwDUG6V+hVKpvO
        lf85mQ2rjWM76lkBLupUeDY=
X-Google-Smtp-Source: ABdhPJw1JBywh3g5kn4kPduyqn6sMf0hxpMEEByxmLywi66ddY01kPIbZjO6n2A7+bzXsvaB+ihxCw==
X-Received: by 2002:a63:d044:: with SMTP id s4mr2003607pgi.32.1628191195877;
        Thu, 05 Aug 2021 12:19:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 42/52] smartpqi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:18 -0700
Message-Id: <20210805191828.3559897-43-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c1f0f8da9fe2..d95498ff136a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5568,7 +5568,7 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 {
 	u16 hw_queue;
 
-	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scmd->request));
+	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));
 	if (hw_queue > ctrl_info->max_hw_queue_index)
 		hw_queue = 0;
 
@@ -5577,7 +5577,7 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 
 static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 {
-	if (blk_rq_is_passthrough(scmd->request))
+	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd)))
 		return false;
 
 	return scmd->SCp.this_residual == 0;
