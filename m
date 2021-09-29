Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0A5C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B857C61423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347174AbhI2WJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:41 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:43941 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347159AbhI2WJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:39 -0400
Received: by mail-pl1-f178.google.com with SMTP id y1so2514566plk.10
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vg4NuUFfPmND0Da/NnD2LD1i3OChRlEDjF3gHZeSqH4=;
        b=tm2D394bfqcM0HuVyR1yttsblf+YFURd+ZvMEqH9aOfzLjulO+giYZ/k/e+HqP8i+f
         S8lCbld5cnQ0DFCPHqVOgmkb3wF8ZSkgSfp8yoJ/087N80hqx0+wMq2HaHtlQDYfRltl
         o7bEjh/GgLUB6Cq8gXnTfe7EIIv9qT7G/fBxRDG84Dtd0K4PrQdE2TgaCOIWOWl2UbpJ
         KbScCrOuzbJO3cjiR0NIS8UZH78ZNX5zw8RzM4U4c2GJ/ysM2mPwrFmdwcPSA6UvOChl
         7tmK4ShKzlv9MuJHRiwUM4H1WUZqIz0xpfETXZKT2O3e/DnfkPa2n7hyH1Go9b+Jw86S
         grgQ==
X-Gm-Message-State: AOAM530F6x15tIKdmKWJ7sAM5BQ91JPtEnNUI4/xqLj7N+FYZ7h4MRv5
        gJExkkwgVcAlk1UnnjiePo+Jou71Tuo=
X-Google-Smtp-Source: ABdhPJxUctBIa97pVqxcEYg+JTw5TDY25xXw4CCHn7e46wWd9tvcBCnCqzL574T1G/NNH5mscZTD4Q==
X-Received: by 2002:a17:902:a613:b0:13d:d95c:c892 with SMTP id u19-20020a170902a61300b0013dd95cc892mr757197plq.35.1632953277592;
        Wed, 29 Sep 2021 15:07:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 63/84] qla1280: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:39 -0700
Message-Id: <20210929220600.3509089-64-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
