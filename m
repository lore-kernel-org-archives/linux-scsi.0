Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA9CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A54C60F22
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242564AbhJGUdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:31 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:35829 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbhJGUdU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:20 -0400
Received: by mail-pl1-f180.google.com with SMTP id w14so4717912pll.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EogJeHd60KWPM8Bgj6GzNq3078KvLLq17w1D0M4dPnU=;
        b=A8wVkVqPjAWAfUxdxyo25/KOnozU2sk5jMqTBM+QsaAimAtxVh5FXKp/yusMnqRkzt
         fEebWuamliHkmYCfoBxykw4omYDUisNC7C99hhOJhuIa0VvxByKj25NjBGqjJeMjZAff
         DquTRdH02wPhKPWahEsYk+OTEePIDaBYBOIW4tQXsx7+4lNNpdf1KdRaDPAbB/x7U17K
         OjHLNfA9L8bn5AzkrnlJdxvSGN6de6W4H/UX0Ku+v3xxDHEo7MS4U9WPHDM/H15OcCMt
         GMznUijQD4Dzg6pRTv+HnTpuTqRPEk6KEzLQq2RpA6Z4UqlzXuqYo1guROZV7hrsKbKc
         a+aQ==
X-Gm-Message-State: AOAM533lSUVDex4EkfXLFUQJXcNrl+dTiAYNHLDYK6YeSJy5EK27z4AZ
        FVz+5viTJIASzmWgyNW+L74=
X-Google-Smtp-Source: ABdhPJzZPCVbaUPYW2tA6IUWOaYHks8Ei0ujKMIqfzj7DphYbHAc3ZTUaY7BIgLL+l2RG9uB6iMmoA==
X-Received: by 2002:a17:902:ab93:b0:13d:e3b5:7ec2 with SMTP id f19-20020a170902ab9300b0013de3b57ec2mr5932065plr.26.1633638686105;
        Thu, 07 Oct 2021 13:31:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 67/88] qlogicfas408: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:02 -0700
Message-Id: <20211007202923.2174984-68-bvanassche@acm.org>
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
 drivers/scsi/qlogicfas408.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 3bbe0b5545d9..5471c046a4b7 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -442,7 +442,7 @@ static void ql_ihandl(void *dev_id)
 	 *	If result is CHECK CONDITION done calls qcommand to request
 	 *	sense
 	 */
-	(icmd->scsi_done) (icmd);
+	scsi_done(icmd);
 }
 
 irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id)
@@ -473,7 +473,6 @@ static int qlogicfas408_queuecommand_lck(struct scsi_cmnd *cmd,
 		return 0;
 	}
 
-	cmd->scsi_done = done;
 	/* wait for the last command's interrupt to finish */
 	while (priv->qlcmd != NULL) {
 		barrier();
