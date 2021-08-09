Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A53C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7DF860F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbhHIXFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:37 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:50800 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbhHIXFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:34 -0400
Received: by mail-pj1-f50.google.com with SMTP id bo18so8304542pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2GfYpj0ri/8eJZhterRC9kCiraFGu+wCkkZN8MGTMwM=;
        b=NuVemglXkZCzmO1Q4UH3YLIqBgCaWj1HQzcSkDppRSlIaGVLooHzy3HinaraHakK3c
         AiACBa756pWwJA+P0gGuM7cGjyPvnZ1mQsYsFNxXYQGisDPEXgrle9K0hntDH99sJRRC
         A3sM1p1KhcRh4+9pyXIRTdRleW9KtU0pRml7It0oCDT2I2PSWrAjMn/TsIdwSumfyTHw
         EOfEr2NoaNxwg34/a33yGeDZgUkfmzOLhyRig9LhOmE7RCkeqlc/R0Y56dAkB/YpXu3O
         J60SlsiFFhNtHnorZqn+tDOXNQ5nn2WXnUfwTtT0/e82Qnl27bLCC3sHCZoxrz05y7r6
         YgKQ==
X-Gm-Message-State: AOAM533PeADZT4FJ+iLeG8VOshA4qJ/mn7abhs35peMZ19mhRDCpArD3
        7keNr2uoIatFpVOpq4ezKmc=
X-Google-Smtp-Source: ABdhPJwhiZxO/2l5svPXMHs2PHGFw2XxLVDm5F/7XIpWZKoT5h47rOzb4zvpVKxzJUPuyPOb/Jbm1Q==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr172962pjb.96.1628550313653;
        Mon, 09 Aug 2021 16:05:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 46/52] sym53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:49 -0700
Message-Id: <20210809230355.8186-47-bvanassche@acm.org>
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
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 16b65fc4405c..6d0b07b9cb31 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -500,8 +500,8 @@ static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
 	 *  Shorten our settle_time if needed for 
 	 *  this command not to time out.
 	 */
-	if (np->s.settle_time_valid && cmd->request->timeout) {
-		unsigned long tlimit = jiffies + cmd->request->timeout;
+	if (np->s.settle_time_valid && scsi_cmd_to_rq(cmd)->timeout) {
+		unsigned long tlimit = jiffies + scsi_cmd_to_rq(cmd)->timeout;
 		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
 		if (time_after(np->s.settle_time, tlimit)) {
 			np->s.settle_time = tlimit;
