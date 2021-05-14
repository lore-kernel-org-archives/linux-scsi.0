Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E158C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2C761440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhENVgT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:19 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:33538 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhENVgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:14 -0400
Received: by mail-pg1-f179.google.com with SMTP id i5so289545pgm.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WWUU0YwL2SlXrpiy3QDQGrM1va0H4/rrlAT0jN881JE=;
        b=I5sNRLuNz/AEh6XX3FMu082VH2oNUIu1q8sUHaYVsMkLNlo0J+qHA+YEZeFwxtHFnR
         aRgAy3spIRipa2NigVQXdv9E/sxfrFf8GwylWMTUaLTW6zeEvTzJe5uMv4cQ3iznhnhj
         DaSYRTKTrc57ZOQha1KbgxYF76yES81e7s95XfF5+D0aH2EOrXe5Dl37b4zj6spoVWDe
         TRKWgjDL2DLSQejKGEfY652u9byl3uxVHRfucorAvxlLMxUgUqhWY7MtmHQWlE5JYNM+
         oPU7X5L+2AAG2zcrvHpmhm5WJNicRS5nfcw2WKLFnK/80Q3lSq2eJC2eXXzEKLLJK2GG
         pkiQ==
X-Gm-Message-State: AOAM533t9izEPCdQXDvLx/oEjX5jHuDsNnSQLf5JRpHD44QItzOq2DhQ
        QLE7jKiRgRAFc+Zyw7QakB0=
X-Google-Smtp-Source: ABdhPJxJc8yC3CY3yj51bXk0aTWI0gbceOA6rrb6LcLeiEiMLBCwzDpCFv3TsEir2SD1eqgQV6LipA==
X-Received: by 2002:a62:c504:0:b029:28e:b070:db71 with SMTP id j4-20020a62c5040000b029028eb070db71mr47206273pfg.55.1621028101355;
        Fri, 14 May 2021 14:35:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 32/50] ncr53c8xx: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:47 -0700
Message-Id: <20210514213356.5264-33-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c76e9f05d042..9bfa945dab42 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4164,8 +4164,8 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	**
 	**----------------------------------------------------
 	*/
-	if (np->settle_time && cmd->request->timeout >= HZ) {
-		u_long tlimit = jiffies + cmd->request->timeout - HZ;
+	if (np->settle_time && blk_req(cmd)->timeout >= HZ) {
+		u_long tlimit = jiffies + blk_req(cmd)->timeout - HZ;
 		if (time_after(np->settle_time, tlimit))
 			np->settle_time = tlimit;
 	}
