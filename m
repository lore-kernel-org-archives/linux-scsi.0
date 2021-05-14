Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E61AC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604E561442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhENVgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:41 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:34333 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhENVg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:29 -0400
Received: by mail-pg1-f178.google.com with SMTP id l70so267410pga.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rbi4RBWBtWCkssVY425acRwWnCeDYmzAVGpgZKT4/7Q=;
        b=AoL3dfRR1LBE3gu6dJrsCgVbB8Tz/Xdw34y6pN7srKati8U1WkpY3VInKhGIniM+LX
         aQiw9aQbKTaLCSLrDEJxgQbebYhwyA+pK2Z4hz48/J5eENSpSZFXaYLoYsY+dwZGXA26
         +Pv3gRMrOiQx4lo6Cl/c3XoNfmMwQKeEVrLIFlZv7YtfmBaO5FSmGpZuss8U2+KFP8KA
         85OTxfdUpOP3kIKAcJOv+OlmCa55HKRrkS5N+XQfrheUsL1uKGdaZVYYZxXkbfzWX/ya
         wGaTxVPnotR8BzEKq+obFXub8tsUWko89IdCZO3q1ciZz/+Th5FlNVJ9xAK64Myhepck
         k3ww==
X-Gm-Message-State: AOAM532wwu+1OduNUc2MZMqXR0dmKjyPDoFu/tM81nrHUzMRwgvEWzWE
        2ZTivfpNajABQj9jSl7WGl4=
X-Google-Smtp-Source: ABdhPJz9+dRiknmnsULkPejcbtQEI8m2M9hQbb4kZwcZmzTT22rp7AZ2Q/vkSGTylROie0d13BEetg==
X-Received: by 2002:a05:6a00:c88:b029:23f:376d:a2f8 with SMTP id a8-20020a056a000c88b029023f376da2f8mr13117110pfv.20.1621028116521;
        Fri, 14 May 2021 14:35:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 42/50] stex: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:57 -0700
Message-Id: <20210514213356.5264-43-bvanassche@acm.org>
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
 drivers/scsi/stex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 12471208c7a8..8a4fad8c775d 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -543,7 +543,7 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 	msg_h = (struct st_msg_header *)req - 1;
 	if (likely(cmd)) {
 		msg_h->channel = (u8)cmd->device->channel;
-		msg_h->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+		msg_h->timeout = cpu_to_le16(blk_req(cmd)->timeout / HZ);
 	}
 	addr = hba->dma_handle + hba->req_head * hba->rq_size;
 	addr += (hba->ccb[tag].sg_count+4)/11;
@@ -693,7 +693,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 
-	tag = cmd->request->tag;
+	tag = blk_req(cmd)->tag;
 
 	if (unlikely(tag >= host->can_queue))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1249,7 +1249,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct st_hba *hba = (struct st_hba *)host->hostdata;
-	u16 tag = cmd->request->tag;
+	u16 tag = blk_req(cmd)->tag;
 	void __iomem *base;
 	u32 data;
 	int result = SUCCESS;
