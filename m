Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D77C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A39F76112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242945AbhHETUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:19 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:43757 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242899AbhHETUO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:14 -0400
Received: by mail-pj1-f53.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so12007764pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G12c21RJ3AXLCNGZiS6sOUi3k1PYPMRZz1Ev3xIt3vE=;
        b=jvBvTlL9kwu4n2PqIe3hH4CbyQa9N5HbIXRifDQvlLoYUeQEh9xX9PHQwwAOtFiWKI
         IY7LDi8Y3YxjAhfryANMOI05lxQZwuwT/+oIBHJzccJTJUmHK5mYeVhIGLJ/u+knj9AW
         YJ9H45LCeXh2F0ulj+JvO+N5yVCA9/vf6OHlMtnsCZpoWR4C2HzKAGzJM9kCxUGJfNlV
         ntjrV/n4EmUSJztaHVOUYLDLOoSQverymh4xwJF30rUwzTG0ZN9n3L+M5LH9GByKUGj/
         iG068olrfZbc4AUUe/W7LqS+MUu0e6JH4XV7riCuKS7PqvXrn9ee/GNNx7WUbvBULPzm
         nNAg==
X-Gm-Message-State: AOAM5303BSZQqwBKMg3mUYZq3x1y4Bpg4KlJ4bk0joqc6gqUe8nHdu7B
        pWgmK1trauJM6tZvYr5Lumk=
X-Google-Smtp-Source: ABdhPJyNNNEqh7ZproQBoDDd/XNKfsLFYKraT8mh3uWD0cB5UT3eOi6xde/YSte2MlD9W1J5ub3R5g==
X-Received: by 2002:a63:6645:: with SMTP id a66mr607576pgc.339.1628191199322;
        Thu, 05 Aug 2021 12:19:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 44/52] stex: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:20 -0700
Message-Id: <20210805191828.3559897-45-bvanassche@acm.org>
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
 drivers/scsi/stex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 491b435273a6..f1ba7f5b52a8 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -540,7 +540,7 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 	msg_h = (struct st_msg_header *)req - 1;
 	if (likely(cmd)) {
 		msg_h->channel = (u8)cmd->device->channel;
-		msg_h->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+		msg_h->timeout = cpu_to_le16(scsi_cmd_to_rq(cmd)->timeout / HZ);
 	}
 	addr = hba->dma_handle + hba->req_head * hba->rq_size;
 	addr += (hba->ccb[tag].sg_count+4)/11;
@@ -690,7 +690,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 
-	tag = cmd->request->tag;
+	tag = scsi_cmd_to_rq(cmd)->tag;
 
 	if (unlikely(tag >= host->can_queue))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1246,7 +1246,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct st_hba *hba = (struct st_hba *)host->hostdata;
-	u16 tag = cmd->request->tag;
+	u16 tag = scsi_cmd_to_rq(cmd)->tag;
 	void __iomem *base;
 	u32 data;
 	int result = SUCCESS;
