Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7309C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC17E60BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhHETUU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:20 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:42936 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242921AbhHETUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:17 -0400
Received: by mail-pj1-f47.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso12016647pjo.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2GfYpj0ri/8eJZhterRC9kCiraFGu+wCkkZN8MGTMwM=;
        b=Fy+00Ra+rtm3JRGI3/pyA5UkWqkmzfY8yAzzuzKIHZjZDE0L9oaWlbRa2Wyfug3nXj
         OXgduogOqLicODZGAsZmuYRWMo3FV1yoDqqqksE++N51tc9xSG0lSPezQqk5CoXTqmWK
         yd5x87PkxaUk9++FZgumMckj65GPiblLxFElOJVArbO2NPfzN6KCnO8mGPucK8truSIv
         kvMixlaM+CLw7+DOqgog5AoQtaCZVv/29Y9F5FWelA/0khuh8c3X6AYzAf1n7zd6UVYv
         H8gLSnf9O/S+4HNUEUbrgk7X2IV+Q6oJFmQPZzi4pvOrh4Entg6ED2bYwbODrS/viisB
         DHkg==
X-Gm-Message-State: AOAM531x5ttIdUvqO4vBu4DNhDwZ0JiYxxbYoofjwolxPWcx3frAwo5T
        BdYKTUyB9eyYozczP3svfSwd36oKYUOUg64teDQ=
X-Google-Smtp-Source: ABdhPJx/C0UWwR5PPI808plOcgCgaU0aOel46ncIpGdS8xwDYHXUpq4KRi9yoSCY+uJnunFnvzd//Q==
X-Received: by 2002:aa7:9e0d:0:b029:3a9:e8dc:2085 with SMTP id y13-20020aa79e0d0000b02903a9e8dc2085mr6708604pfq.73.1628191202243;
        Thu, 05 Aug 2021 12:20:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 46/52] sym53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:22 -0700
Message-Id: <20210805191828.3559897-47-bvanassche@acm.org>
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
