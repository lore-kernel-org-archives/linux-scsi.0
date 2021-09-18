Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9F6C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35C16610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344529AbhIRAJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:07 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:42861 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344404AbhIRAI5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:57 -0400
Received: by mail-pj1-f43.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so2932740pjv.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cx5mLSqSRMTPAqHdKvTeRQWD317TuE1XEtb+GD/tb58=;
        b=6QetXWxx6ajFliSDHz9G257s50L32zV2iJ67IdkECnW8gEVFo2ig/Zns/QRKzw1RrZ
         TgR4spGaBKNbt7EDkH5MUjZqHNBVxN8F8aufPx0YXe5tVnb1xpC/ItFLoittZ3ygfbZ3
         8i9tV+CrXS3+EyUSsMggh+s77b8bAAWYM8VumoEIwf0lmwNPumHo0kmvtzlfy290uZRd
         19m3yXBJi2Lt3Quzur3eM6H52y7XjzYuc+vwjxbwfiZ6++UQ/Fb2hUM1NAB3K9PSGmGY
         4UWxam6te0wWuMj7DzkCZ83MNqDhYrtrcxe5nhu4Kg7pLHF4MHYzzA8NT6M6W7gRzSRx
         vu4w==
X-Gm-Message-State: AOAM531xus6QLjmoXweYCCDj0t8EKo4xHbwQQ5DU+qlQV2FbV2u2C5S9
        ttDWokRjFREqA8tstQ41BO0rn48v2WUj/A==
X-Google-Smtp-Source: ABdhPJwaSu4jEV5CvQblSVVNh3KcXJHuutl+H/rLKqTV6F09BqY7bT/v5RrjhpV6lSE0sl7jpRymXw==
X-Received: by 2002:a17:90a:301:: with SMTP id 1mr15487654pje.65.1631923654610;
        Fri, 17 Sep 2021 17:07:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 47/84] mac53c94: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:30 -0700
Message-Id: <20210918000607.450448-48-bvanassche@acm.org>
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
 drivers/scsi/mac53c94.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index ec9840d322e5..9731855805f5 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -83,7 +83,6 @@ static int mac53c94_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cm
 	}
 #endif
 
-	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
 	state = (struct fsc_state *) cmd->device->host->hostdata;
@@ -348,7 +347,7 @@ static void cmd_done(struct fsc_state *state, int result)
 	cmd = state->current_req;
 	if (cmd) {
 		cmd->result = result;
-		(*cmd->scsi_done)(cmd);
+		scsi_done(cmd);
 		state->current_req = NULL;
 	}
 	state->phase = idle;
