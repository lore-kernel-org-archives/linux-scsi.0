Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6E5C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670E161440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhENVgh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:37 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:42931 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhENVg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:26 -0400
Received: by mail-pg1-f181.google.com with SMTP id z4so245455pgb.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7e2Alb3YC7ktx7Fy9P+zokgyGRVNpRDvCveLdOBMALs=;
        b=WsYoYte6bcfsNgvKJDg1T+GhynI3mjZAZp1e3NCXPr8FM+I/Q0CveYWc7ObzI+GAS5
         Hx+OPkxYvKAmeKIfqOfJlDRfMQOLZhzeOqv9ffZT+H/oepumwRqaIZrbOvGZdbbBCyfk
         14b/XMIZvl1FND9UYrI21sMeBEKBEL8Lm1hYvCbkERDhenwJoLaQKqhwaYJe9fqtqJ6t
         KvpvfsK/GSgDKUbM7bsxTSGm8GqEqLhha0XtGHRP4wqCStSgjQaiB9V9WGFvDcgt/7MN
         9SI9In93swaQwdx/O4FdxPz8oCSzl617dnSBr7ouUwqg1ysEchbKcd7xTP1v+Lfu+XBE
         oSKg==
X-Gm-Message-State: AOAM530MsQw3esw6zmQz4Ur1bW618XEtZZv4WO9sfCWw+Y/B7hH12h2h
        9pQ3AqE8QH7A3/ch+sZNExCDgZ1+Mmr6Cg==
X-Google-Smtp-Source: ABdhPJyYKHqjBBBlRzysBGayNJiesfWRMa2LSjcJNzg1vqwIPeO60CgJ3REHJ6RQn2617aIbp+Qblw==
X-Received: by 2002:aa7:9313:0:b029:2c5:7e1c:2c77 with SMTP id 19-20020aa793130000b02902c57e1c2c77mr25116746pfj.73.1621028113655;
        Fri, 14 May 2021 14:35:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 40/50] smartpqi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:55 -0700
Message-Id: <20210514213356.5264-41-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5db16509b6e1..6d6594c9fc94 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5569,7 +5569,7 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 {
 	u16 hw_queue;
 
-	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scmd->request));
+	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(blk_req(scmd)));
 	if (hw_queue > ctrl_info->max_hw_queue_index)
 		hw_queue = 0;
 
@@ -5578,7 +5578,7 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 
 static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 {
-	if (blk_rq_is_passthrough(scmd->request))
+	if (blk_rq_is_passthrough(blk_req(scmd)))
 		return false;
 
 	return scmd->SCp.this_residual == 0;
