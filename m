Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D8DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C672611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351328AbhERRrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:09 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:41835 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351335AbhERRrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:03 -0400
Received: by mail-pj1-f49.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso1979697pji.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OaYYFKNbGHJfyrEgp1V5dPIkQNPdZPWPXMt1X8L2btk=;
        b=E+a/3Deary0NvVWBFqDrglbvw4Xo5/nT/VJLE3QsOtuwZPAsJK3G/lp++sMHPmhhhD
         zNoUDjc+dCSXCoFuTRmkhkx9Wmm12kJ2EvfI3po5wADsHzhETfJtQEE7RQ+JpayUvHRP
         +nOLf0AkS3mkjk9bQCTYjDGdXpLD2OKo0Wsw7uHxHBn17ojJ4rXEI+aSGm78moUB/EVl
         +s0nvzfPy5DzEZD+X9rhJ+hAh8qid5+sHKcCCRaArdZiZC5tFIolq+IcTYtqja4zloFh
         xXQKnOOdShLSEggYEXWQPeY8bXSO8CpN1PoajYcq2kjoSJfh664enYs2quCRCHL+iBv7
         pupw==
X-Gm-Message-State: AOAM530i73WFQ0IpOEygaE89AL7q/8At0D2G37ttOSVTO6DnxRXjYXqF
        PbJKE7wqss1lmlSoyPwx2Jc=
X-Google-Smtp-Source: ABdhPJwak/Q+RfFPCx5JLyCSA4DCQDZ43gpLaRfPGTJvnZ2DvlOWFQKAoQ67vyhMyTbQHiGdbMShKQ==
X-Received: by 2002:a17:90a:6046:: with SMTP id h6mr3663670pjm.152.1621359945179;
        Tue, 18 May 2021 10:45:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 40/50] smartpqi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:40 -0700
Message-Id: <20210518174450.20664-41-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index 5db16509b6e1..6c841a1fa4a2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5569,7 +5569,7 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 {
 	u16 hw_queue;
 
-	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scmd->request));
+	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));
 	if (hw_queue > ctrl_info->max_hw_queue_index)
 		hw_queue = 0;
 
@@ -5578,7 +5578,7 @@ static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 
 static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 {
-	if (blk_rq_is_passthrough(scmd->request))
+	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd)))
 		return false;
 
 	return scmd->SCp.this_residual == 0;
