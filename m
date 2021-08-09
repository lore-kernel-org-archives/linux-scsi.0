Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C250C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E776560F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhHIXFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:32 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:52997 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbhHIXF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:29 -0400
Received: by mail-pj1-f54.google.com with SMTP id nt11so7150467pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rfmZ9jtIiXwmdU1gkit8tqxaOOEQ3YAK+sCHQE4YbbM=;
        b=W+8YCvCbCsCpHzJ40deGHQht7HuyKP8HTbOL4SFEuUFMEVcW3rp0RTFyfgAQLCiPOf
         0AbMKbvFI3R8o484i9hkdnLVe33HWMFRfRl6Pc+ZLCY4QQLdmMd7V4eX2vHxGUQvroi2
         W6Z+OIWh9DMNCPjC9Mghb8awu2fwhcMPokYqpLDm1yaCFA2v8+DJmHNfUbPAp23PZKUR
         nBAHp89YfIcoLGl8gy7l5dxoHcC49iiodO40JZo800+XrWISVOFJcYbradAE7+Ra4kEV
         FGeZffN0LvmGF8Xlt0rzHpCDuWI25jGVrP63CG5M0Ga2VRdgRo9i0F7P6kjLBfSozIT+
         z7Cw==
X-Gm-Message-State: AOAM533GF53ccVdXUj69BUk7TY+VnWqjHRMMtybv9FZi+L0+dYpDdX+D
        6JWhCwpqWrVx0pkHMbzXhWY=
X-Google-Smtp-Source: ABdhPJxrOCCVZ+sgPPJjEMMpbIJzdkeYE1OL4N2Ol1qMcDCY0lPkEoLX2eX1aToUxNymgSihmbr0SQ==
X-Received: by 2002:aa7:8058:0:b029:332:9da3:102d with SMTP id y24-20020aa780580000b02903329da3102dmr20200331pfm.21.1628550307874;
        Mon, 09 Aug 2021 16:05:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 42/52] smartpqi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:45 -0700
Message-Id: <20210809230355.8186-43-bvanassche@acm.org>
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
