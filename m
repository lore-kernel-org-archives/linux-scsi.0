Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F81C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F168A61425
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347159AbhI2WJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:44 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:37872 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347188AbhI2WJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:43 -0400
Received: by mail-pf1-f177.google.com with SMTP id s55so2088540pfw.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EogJeHd60KWPM8Bgj6GzNq3078KvLLq17w1D0M4dPnU=;
        b=wFPtU7qg7D/afI4jHyRi7X8njld7ia+4HHNeKb0fQgUAZLOF/CekuS0buAk/a4bX9w
         7Vb8OnZpiSVLBkjsj/Cz7L/oYb85w37DxIExrdm5EjK+G0C93yufvErGJMLFkD645y+r
         aVc7hvkxnjdRWJD1uDgLDa9/767nK/kbYSO92jKBQaoyH+aQflxHtZyBu/mOLDT/lLxw
         atP+veHZKX4rJp/IdRh+bu4g3paSeX+I6R2L8m0ImQG3YcaSZ0bOsFKDKBx42GJOs1CH
         batNmgcBTeYMewUWAJBTJsvfrg2HK/JLxgLPw/qzLD4EaqMuLiQ5+wYIL7pV4ow+6jDn
         /sHQ==
X-Gm-Message-State: AOAM531zQdECk4QqTRoHLIPlqzZqxd40JLS9kPO4Ur2oEvzfwU2Zc3tP
        4dWpcM0Qgjs26tYq8qcu0Z0=
X-Google-Smtp-Source: ABdhPJz/sRZzQ/maQrbfujSykub54CTzcnBx7l6X9JYgZEkqOMP9u9I03EXdnLihuEG8lc0E1w7N2g==
X-Received: by 2002:a63:d709:: with SMTP id d9mr1876990pgg.377.1632953281659;
        Wed, 29 Sep 2021 15:08:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 66/84] qlogicfas408: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:42 -0700
Message-Id: <20210929220600.3509089-67-bvanassche@acm.org>
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
