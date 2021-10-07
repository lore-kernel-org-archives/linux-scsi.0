Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EEEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2EEA601FA
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbhJGUdZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:25 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:44797 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242668AbhJGUdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:16 -0400
Received: by mail-pg1-f177.google.com with SMTP id s11so901956pgr.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vg4NuUFfPmND0Da/NnD2LD1i3OChRlEDjF3gHZeSqH4=;
        b=MWF8hz8pHdPQHanJ4Nr69fYBaME8nWNixzRmS6NC/1wT4Ef6linFEVpKLwrFjxQLpn
         MVnxgXuqBvjn0/JuVK6xQ4dwIyZPL/TxLPtyd/NzuNKlPmtQgw5Zh++JS6XT2CuVJCuc
         jCJob3ai2YYIYCvv1d6CfDzXnupzsMc3GN57mqbzj6OmEG99QXS4OyMUSDGtnuG91aPJ
         OUpyUSWuzvWnq3Mtk20q6jTmQMPh1rWaQp4TFrDgpjHnB8nhSYQQ3bEBBsNKkpYflDgq
         OQLALDJJQNmTpaanPiaKEIyJeHXq7Q62zAw2cxAvnSqYkT5z3sph0licUVt8uki3W0ka
         YxOw==
X-Gm-Message-State: AOAM530LDkCLHVCRpJvi2bMxCO0HWtXarywtYZvVuzUPOr9hVXvHHBGj
        8Ke9oi4qUODJzv2EgBBwGKs=
X-Google-Smtp-Source: ABdhPJyirGQr3Eka61C8JIMW3hVXc3DiELy2rDzlZe1h4RurJQSWSY+b6auQubMJxFEj5RayPZrajg==
X-Received: by 2002:a62:7d4b:0:b0:44c:5f12:30ee with SMTP id y72-20020a627d4b000000b0044c5f1230eemr6218147pfc.32.1633638681920;
        Thu, 07 Oct 2021 13:31:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 64/88] qla1280: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:59 -0700
Message-Id: <20211007202923.2174984-65-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
