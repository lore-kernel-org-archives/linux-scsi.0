Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8FCC43462
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E75FA61442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhENVgn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:43 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:35337 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbhENVgc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:32 -0400
Received: by mail-pf1-f173.google.com with SMTP id y70so665324pfg.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZV24Zy7/LzvgacEXf1mTUhyxb4J5jBjl0GaxmsqqvQ=;
        b=PhS8vJKwSw4ss5Fd+8dWiaFxPqSPvYh5dGivJ5Tt5j/6l8yq1jGa2qUGOddeqI2hkV
         cOV+eVUMzdbZhWX6zFlV63t1TviHgcF4XCsLGyTdyoYSIGDjuZzYKOH56Zrx9Oncz+Az
         bWcQkOQ8UJhGCYmJ0xZ4oDyBFG4Yte4Ry24HITWZ9izkJia+kiuvK5Q8AgLy5bEeRZoe
         wfo0VmFVjtK2aWchbtkKm0IUQlBZdqjzfOm4msxXcYoeghlZOJZC6TArT7hmwOvtC1oD
         RL7VoU+z7fCXB9VvCQEZ9cA4shZd1ifxBFmdrhVFO+9mat0EnpTTJfTQlyqpEEnJ+Jvf
         7nww==
X-Gm-Message-State: AOAM532mUrUPmqqe0hsPtKT4PWXHYS3J9ArRq/H4MjK0X+EYHKiNNMnb
        KUHMCmRegfJEvl49s5cTQfg=
X-Google-Smtp-Source: ABdhPJyyrssFYj4rvVS2iSxyi7c84vJNYrHBzS9UAGo2YUBQNxvu6lo4LAXzy/rt7yBJAOOu1Br1Pg==
X-Received: by 2002:a63:fd44:: with SMTP id m4mr11585607pgj.396.1621028119440;
        Fri, 14 May 2021 14:35:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 44/50] sym53c8xx: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:59 -0700
Message-Id: <20210514213356.5264-45-bvanassche@acm.org>
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
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d9a045f9858c..cb061d8559ee 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -502,8 +502,8 @@ static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
 	 *  Shorten our settle_time if needed for 
 	 *  this command not to time out.
 	 */
-	if (np->s.settle_time_valid && cmd->request->timeout) {
-		unsigned long tlimit = jiffies + cmd->request->timeout;
+	if (np->s.settle_time_valid && blk_req(cmd)->timeout) {
+		unsigned long tlimit = jiffies + blk_req(cmd)->timeout;
 		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
 		if (time_after(np->s.settle_time, tlimit)) {
 			np->s.settle_time = tlimit;
