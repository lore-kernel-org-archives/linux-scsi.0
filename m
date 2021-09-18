Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E65C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20404610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344167AbhIRAKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:09 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:33478 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344983AbhIRAJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:23 -0400
Received: by mail-pj1-f48.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso4338530pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vg4NuUFfPmND0Da/NnD2LD1i3OChRlEDjF3gHZeSqH4=;
        b=pC+785Y44cZ2ODVJ/Yazfh7fBDU8axa1u+cajLVwWTc4Cufe4SpVrohTem7iVKT5ud
         lE05zXXQzHbLH+d9hHM7pvhNO4hg/MqqyMnaLanJlqoE7f446KxIqDSB5F7/Vdjmfnj3
         /4boXqDGweB9xiHDBG9L+0tzYUOGKcJMZFguTLIwsjpPAztEIcWWE3Dvr1htUguNhFk5
         U0e2ez/5ybQwWhYqB2TCcrQ48w0CAGxgrEJicZQXYh5dcG92TgZCIbGsPWT5G5p48u+Q
         rv1EWz/PBtenKE/NaaMnneD2EFSDrqb+Kiim9rb82CtPossGRDrnqVHNGzqHyemOkqTp
         MBog==
X-Gm-Message-State: AOAM532NQTD+lETsfOQ3so+VGWmS4qjJBVULivqhVxvJzDbTYeOH8AMX
        memE3V/5ngn8OcdnAbSaRWk=
X-Google-Smtp-Source: ABdhPJyaBDXDC+UT55GFnyamR1HQe4j7G0YBj8OKJR8BdPmTc/6orkMOh9+o5+AD2/HKJ8ziEfBLWQ==
X-Received: by 2002:a17:902:7d89:b0:13c:a5e1:f0f1 with SMTP id a9-20020a1709027d8900b0013ca5e1f0f1mr8979225plm.24.1631923680811;
        Fri, 17 Sep 2021 17:08:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 63/84] qla1280: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:46 -0700
Message-Id: <20210918000607.450448-64-bvanassche@acm.org>
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
 drivers/scsi/qla1280.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index d0b4e063bfe1..c508a6e20519 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -697,7 +697,6 @@ qla1280_queuecommand_lck(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 	struct srb *sp = (struct srb *)CMD_SP(cmd);
 	int status;
 
-	cmd->scsi_done = fn;
 	sp->cmd = cmd;
 	sp->flags = 0;
 	sp->wait = NULL;
@@ -755,7 +754,7 @@ _qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *sp,
 	sp->wait = NULL;
 	if(CMD_HANDLE(cmd) == COMPLETED_HANDLE) {
 		status = SUCCESS;
-		(*cmd->scsi_done)(cmd);
+		scsi_done(cmd);
 	}
 	return status;
 }
@@ -1277,7 +1276,7 @@ qla1280_done(struct scsi_qla_host *ha)
 		ha->actthreads--;
 
 		if (sp->wait == NULL)
-			(*(cmd)->scsi_done)(cmd);
+			scsi_done(cmd);
 		else
 			complete(sp->wait);
 	}
