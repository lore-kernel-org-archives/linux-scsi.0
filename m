Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB75EC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B565A61179
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243206AbhIRAHu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:50 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:53928 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242776AbhIRAHs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:48 -0400
Received: by mail-pj1-f47.google.com with SMTP id j1so7996355pjv.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RBZHjw3JHDrguqBG8cOIhGzgoMFOjtiQB2zA0sZuBU4=;
        b=ToWzq8GTOlgws2lX8yeCjJwTZzcVl6JGlK96BM9+IwlMKYS5LiHPm7qJyP9EnSi7UW
         kNMcMHNab4BJf8TfT1rGMiHTCyoJft9NdzC9Per3HEmlobqe0Ie4NwdSd9Ujn4U2LjAc
         qepj63ty0k6hmC19psxVXeQvCGszBEV8Gd3cXjlOMZQLsnWFIXiSycuKRPSsgQhRSz2b
         cFdRtoHmHQT5mpFaUcsKuWHCB08da12Mlp0MQpergexTOky/3S8nCCijiimQnkubOJbO
         OmkFldFsiciNvigRkGrXxaMlGOOHlNIvmU7C8ZzEULgNBc6jTyeeuOf5LLTh8NEbN06d
         Aepw==
X-Gm-Message-State: AOAM533JGiibdiJjzrC93Bvua/lfaIsYWLkVUbb2fDrAJYOhRLJvVdaP
        hUmC2lcMQlaLmp7aImotsfXcXzTasHg=
X-Google-Smtp-Source: ABdhPJyTclToVK7ZSWIJc31C4lFP06rLGNY2hWVOS4qEZInzZ6jykmEXjYY3BR5B4fNd0HaxnBHGYA==
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr24217878pjb.33.1631923585821;
        Fri, 17 Sep 2021 17:06:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 08/84] zfcp_scsi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:51 -0700
Message-Id: <20210918000607.450448-9-bvanassche@acm.org>
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
 drivers/s390/scsi/zfcp_fsf.c  | 2 +-
 drivers/s390/scsi/zfcp_scsi.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c1f979296c1a..4f1e4385ce58 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2501,7 +2501,7 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 	zfcp_dbf_scsi_result(scpnt, req);
 
 	scpnt->host_scribble = NULL;
-	(scpnt->scsi_done) (scpnt);
+	scsi_done(scpnt);
 	/*
 	 * We must hold this lock until scsi_done has been called.
 	 * Otherwise we may call scsi_done after abort regarding this
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9da9b2b2a580..e0a6d8c1f198 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -60,7 +60,7 @@ static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
 	set_host_byte(scpnt, result);
 	zfcp_dbf_scsi_fail_send(scpnt);
-	scpnt->scsi_done(scpnt);
+	scsi_done(scpnt);
 }
 
 static
@@ -78,7 +78,7 @@ int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;
 		zfcp_dbf_scsi_fail_send(scpnt);
-		scpnt->scsi_done(scpnt);
+		scsi_done(scpnt);
 		return 0;
 	}
 
