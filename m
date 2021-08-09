Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19161C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E933A60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbhHIXFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:36 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:42616 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhHIXFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:31 -0400
Received: by mail-pj1-f44.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso2421629pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G12c21RJ3AXLCNGZiS6sOUi3k1PYPMRZz1Ev3xIt3vE=;
        b=q3k9Q5yuVCdSl07TGE98fWMk/c9WC/uE//IylVgqq14UyV2S/VfWrAmqXvkq3tTssH
         5s6dbYQHqqKGokxkqpew0G/DOpfPXmuxQU7xKt+tcTwITV14MsCSN6Ku6aZrHCYnMaD3
         F/XkAvfPBA2IOAi2/hEMBdBuiGL2skPwrmRZa327fPFJrQScBXCWapAnfxNRREw3DDUe
         LAOCj3xMokXhLbB2g26G9zDjLT9/HswxgJZpGAf6krN8+zYyn/WgmB4C3OxnDDVAnZPv
         rqtnz+AobvtBDDBhLYHcE5IhaZH+IGGO160796d9vT4wiM3Nj/JZuYO+GFMYKq/oD57Z
         nbYA==
X-Gm-Message-State: AOAM531v8AN7LcPR+S5IvLFreZU6HBYTrkgX/cPhoH9TkxxCB5FIhloR
        qF4HPo60AXXRfcvl3ZsoTjE=
X-Google-Smtp-Source: ABdhPJx/LGLgiIU4uVyljjVmfZFe62elvfZm1FCTwc0pAVGE9Z/QQsoqY4CplmCS+bDjdGOlrGa4eQ==
X-Received: by 2002:a65:40c6:: with SMTP id u6mr46143pgp.390.1628550310673;
        Mon, 09 Aug 2021 16:05:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 44/52] stex: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:47 -0700
Message-Id: <20210809230355.8186-45-bvanassche@acm.org>
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
