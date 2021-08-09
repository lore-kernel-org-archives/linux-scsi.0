Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1E3C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1414360FE3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhHIXFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:23 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:45983 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbhHIXFR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:17 -0400
Received: by mail-pj1-f43.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so2388636pjl.4
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8ZrZxpFyLWC/b8TX2g9suyIzirLulmQYWjh1aPwWLg=;
        b=t6RjTCIyq2i0wlu39bB8Yzi/3vhAZMuwJ13QmyO2b34lFsyetxkmsSUr+ZjPuX+vNT
         ysNa+E150Q13siPMr46840xnLx6AMlkECvGZsw3HxFsdeccxj3XCCHpOtZ0lY+F7Sazy
         zbgwsnXj8V2RTtEuas4bm9jBPZ9Lw4KN/VifX0a2piy6LzkrndunY+OpMRx3BZbEsOED
         pYkRtI4e6KFDyVW7/FJ9uEH2kR5VBG1GG7J+oRshbEz5rh0S4mvbz18S/KvPGGg0qyBF
         CeJm/tQgiUcJdj/iDe+TOaGeDDuYG1kk0UQEbzfUOn1CvBm/BYn34CVcnmxSzC4vw3An
         BQug==
X-Gm-Message-State: AOAM531d/odjwDUd2K+dE16nieXq3VN4mdzuj1F0kJgWdAnSPyq3QZGz
        s55LY6DnedXZFdzlt+FBfm0=
X-Google-Smtp-Source: ABdhPJwWK9dsLQwWM3f0Ast1iExvEfur3KKZZg8Zrdvv4WZjcF+ZyyBh2p0vQaeBouA3YjGpIZqzzA==
X-Received: by 2002:a05:6a00:179c:b029:3c8:e457:5f18 with SMTP id s28-20020a056a00179cb02903c8e4575f18mr15523974pfg.34.1628550296501;
        Mon, 09 Aug 2021 16:04:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 34/52] ncr53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:37 -0700
Message-Id: <20210809230355.8186-35-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c76e9f05d042..09958f78b70f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4164,8 +4164,8 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	**
 	**----------------------------------------------------
 	*/
-	if (np->settle_time && cmd->request->timeout >= HZ) {
-		u_long tlimit = jiffies + cmd->request->timeout - HZ;
+	if (np->settle_time && scsi_cmd_to_rq(cmd)->timeout >= HZ) {
+		u_long tlimit = jiffies + scsi_cmd_to_rq(cmd)->timeout - HZ;
 		if (time_after(np->settle_time, tlimit))
 			np->settle_time = tlimit;
 	}
