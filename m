Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A973C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7FF61074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351306AbhERRrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:09 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:40724 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351315AbhERRrF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:05 -0400
Received: by mail-pj1-f42.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso1962161pjp.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sp4ChfNEiSRF8tBgNXrRZhDtMX1chUozxV3cgDD8AUY=;
        b=JIME/QAuz7Lgobbt5uJsMlEe7Zb5W/bfLL1n5ldsvKG0RjXC9YKJU5tKtveQEamJY3
         S+y76mDoVgocvXSDv0J1st8eH7BAeYo8TuQGTu1nHQ7yAd5TkrnGLya3Clxe8fAhAwmc
         Tirdxilnc6B5iWvWRXPTXT9luLSOs2ZG6EPPuKJvr8qDGpXS/KcX0XHjdBb7nQRECUDb
         5YybwkGOHdqG8tPs4XV1qhTVGsQmFRLEU5CxYFYI/Zjf9JVDkr/cXxna4Ni/w1S5gOaw
         xGG6QhZo3v1gKOzaqprQ26TTyMrVkMKIKQkHF6ojgkoO+5qApm2SivlrZKaJxAiBH8XJ
         eoXg==
X-Gm-Message-State: AOAM533eSmCYPk1sRHw8HgsBqogdWI2bOvGchTVEgokjdYHR0clpuaaQ
        0hN2XZQdNeDYrZxMAeJ2wwA=
X-Google-Smtp-Source: ABdhPJwMPzsuGm9urjqWofQeEb4oAIZa1uDAjsmnyVELjMOQZH4TF8+FVYIR5SInD0sKqkTya5NSow==
X-Received: by 2002:a17:90a:71c7:: with SMTP id m7mr6336182pjs.9.1621359947064;
        Tue, 18 May 2021 10:45:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 42/50] stex: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:42 -0700
Message-Id: <20210518174450.20664-43-bvanassche@acm.org>
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
 drivers/scsi/stex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 12471208c7a8..b6eec2e51048 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -543,7 +543,7 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 	msg_h = (struct st_msg_header *)req - 1;
 	if (likely(cmd)) {
 		msg_h->channel = (u8)cmd->device->channel;
-		msg_h->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+		msg_h->timeout = cpu_to_le16(scsi_cmd_to_rq(cmd)->timeout / HZ);
 	}
 	addr = hba->dma_handle + hba->req_head * hba->rq_size;
 	addr += (hba->ccb[tag].sg_count+4)/11;
@@ -693,7 +693,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 
-	tag = cmd->request->tag;
+	tag = scsi_cmd_to_rq(cmd)->tag;
 
 	if (unlikely(tag >= host->can_queue))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1249,7 +1249,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct st_hba *hba = (struct st_hba *)host->hostdata;
-	u16 tag = cmd->request->tag;
+	u16 tag = scsi_cmd_to_rq(cmd)->tag;
 	void __iomem *base;
 	u32 data;
 	int result = SUCCESS;
