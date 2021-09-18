Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD18C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06298610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344348AbhIRAIg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:36 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:54853 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344061AbhIRAIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:35 -0400
Received: by mail-pj1-f47.google.com with SMTP id i19so7997311pjv.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9y0QsIwMPGSgzx5MSYES9jzyAyZhlnryYct60FKOcbI=;
        b=QeP+h8EbnywaelBdSQeVrY81HsoLRTmIqjIePx5hm+FflpJAoqIuD8aXrjav7KITBe
         /hyF5PBcknCFEKeQYQXe7T+o5SbmNAbQKDNw2lI8BVWKCu6WPKFNX0lo9FoH7LWQRQ6q
         yvQDjFmXyJJiEFYw2wwS6yFnUOjJ7+MqYUKvLlWPx5zewEQwFIdsJQ4mtbV65LXdOhyW
         VNh/31s+jP9eAR30SHimL52fmSEJcPa5D3axamw9AwDZh8Ud+vAm2t4nMXIVw8emCniN
         xGa1V07Mn6I7JPt9P5G2OloF7iu2WvA+KVtiYDlAnGzBwYn2mU65I6C6IxYOJS6qYNt6
         r1fg==
X-Gm-Message-State: AOAM530tVxwCdkbN9rjntQ8QOthP3DhR0OLKd3rJ1vjPuCW8JJFegKAv
        e33+y477OKumbTQdWg/JidI=
X-Google-Smtp-Source: ABdhPJwoJYs2gYQsvIGXLRkUv1yuJsEM6BYyEOaMB0nxr5UfQHjTjxmh6gUow55kKLb2mTXpw//5Uw==
X-Received: by 2002:a17:90b:3841:: with SMTP id nl1mr15351666pjb.206.1631923632211;
        Fri, 17 Sep 2021 17:07:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 34/84] fdomain: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:17 -0700
Message-Id: <20210918000607.450448-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index eda2be534aa7..9159b4057c5d 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -206,7 +206,7 @@ static void fdomain_finish_cmd(struct fdomain *fd)
 {
 	outb(0, fd->base + REG_ICTL);
 	fdomain_make_bus_idle(fd);
-	fd->cur_cmd->scsi_done(fd->cur_cmd);
+	scsi_done(fd->cur_cmd);
 	fd->cur_cmd = NULL;
 }
 
