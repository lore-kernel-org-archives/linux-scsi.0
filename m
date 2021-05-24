Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABE6C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C866061151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhEXDLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:44 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:37830 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbhEXDLm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:42 -0400
Received: by mail-pl1-f177.google.com with SMTP id u7so5342251plq.4
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OaYYFKNbGHJfyrEgp1V5dPIkQNPdZPWPXMt1X8L2btk=;
        b=KW4fpUHLGksx1FibgP6FtC8525yp0ulZRwlFggQt9XYRnpaNlAwZOx771D2igxuck4
         CTN/gNg75jQEwOqPSRrCyjL9t5yvHO4cWuocdiaq7KzlxeqAnuVDT+pU0UDpRdPovj+v
         BDRMfiJWhc2KMwGdjOmtK2wNFfB34bKcE5QruXplbd1GIG44Jau+qzuARmsNcglJCOtl
         Hn/iH5LpW71aoN2em3jRFYphW5gMa0UNs0XvbEufmWnj2EO0mYt8Wc9iYPRSjAmtKpmH
         /i5cF8+5EpoYKg8if1yTEsuUd1l9ak9yAi8sO7+MZHPUPhzqT2Rt7eB11abhsy2Bq4YI
         ZJZg==
X-Gm-Message-State: AOAM532fN2cbDr8iYHUfbAPyq4bQg+Yn6MS3x/sOLGZcx6tItWtLd7go
        R0z/jyCkdLi106QPRcO3UTY=
X-Google-Smtp-Source: ABdhPJy9UF8YkXPqYShYedsKa/s1f18JnYJeqI/09L61Ffnq8WQ6myecjC7CHPsqS4ayEhAOSu0kgQ==
X-Received: by 2002:a17:90b:17c9:: with SMTP id me9mr23298814pjb.13.1621825813359;
        Sun, 23 May 2021 20:10:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 41/51] smartpqi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:46 -0700
Message-Id: <20210524030856.2824-42-bvanassche@acm.org>
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
