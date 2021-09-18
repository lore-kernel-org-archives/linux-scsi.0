Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6418AC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5113361164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345061AbhIRAJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:24 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:40835 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345013AbhIRAJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:19 -0400
Received: by mail-pj1-f53.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso11118854pjh.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfxVhZCFvk45D3OUj/xVsg8PqFWL9WcofwLGfuG8Jpw=;
        b=MavLfNmD3brv8V0Hs+pVYAhvIjxdh2ZFx1DjkZ1AlSGOONcGZkj7biDRTxB9bmvDoq
         qLeM0GtMazn5jv5iG11yl9Pl/tdbXuaA1IL8H1bdg5Fxn9v8wQP9sPJYLCWzNs1YzpuT
         Xw2XueL6ul7zrRWH8aqMXITwsJ0qC0s78hciqBtpkGHz8lkojtjuSq97NTf3/tPK98ex
         IS4tbwITrUvBH4MzYqEo6ABhKvIHOEPk3ekVCmECbgvh0EmUbYCkoUacurMM0WQ360+m
         aKS6gYM+vUxF9z8WAL0nrVHCxxSow0sQYNWH9yf48g0+ojC5IKZOCoAkaYTPW6rjXNv8
         t6DQ==
X-Gm-Message-State: AOAM5321UrZiBT/yyIJ1EfYBu5QeKaduWMUhzphB4ZJ29d/8qdHnw6Ay
        joR9/lwXL938p7nJLsG7cjY=
X-Google-Smtp-Source: ABdhPJyv2HgkTsHO2Y1i8vhvBPqrBwS4g88d42EKGBZ7rBJcwqnG1Xgh+1IOfgI1LPESIpI3i6h52w==
X-Received: by 2002:a17:90a:44:: with SMTP id 4mr15630369pjb.130.1631923676460;
        Fri, 17 Sep 2021 17:07:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 60/84] ppa: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:43 -0700
Message-Id: <20210918000607.450448-61-bvanassche@acm.org>
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
 drivers/scsi/ppa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 977315fdc254..799ad8562e24 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -665,7 +665,7 @@ static void ppa_interrupt(struct work_struct *work)
 
 	dev->cur_cmd = NULL;
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
@@ -798,7 +798,6 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->failed = 0;
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
-	cmd->scsi_done = done;
 	cmd->result = DID_ERROR << 16;	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
