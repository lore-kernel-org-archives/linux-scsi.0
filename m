Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B08FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 237AB60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347211AbhI2WKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:10:01 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:36478 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347212AbhI2WJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:53 -0400
Received: by mail-pg1-f171.google.com with SMTP id 75so4164626pga.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bb7RMcS6aWofjbIJF92wtw8NtOHtJtd4jm47r/Gt/Jg=;
        b=AjVEN6DClwLJtKu+H6PmRsCARuNNyj/47Le3NqTH78i1IQ6UVGfCMcQx2Lwh6MFrmn
         5Z3/HISciv+govzb5TTaJBYM8bzT4VMDCgmanJppZXeLopzFys4FVi+q0zHQXlVefDVH
         0EEDcAl856djtCtnpfL5X9JANITgAInPDzWqfklhoPkp6UlTyOnLO313cGb5aEqqh2D0
         rpoZlnc/sO0lgcOK0AwtbeUacVrHIQB1jTMdKllJiYHF1CTyZsrmdb6Qx7VP/oaPHdGw
         v8f3Ewrthz5ub/Ztd+lfQ5/Qlf/npQWKz0RmnV5FZCvq9UUvxOGXhxqoH1xQ7aXduL0Q
         Vglg==
X-Gm-Message-State: AOAM530u3YkGLvyDmHUE8I5vbvtZtFedgSzFrUQ/b4Y4Xmz52Plh2F5w
        /sew7gI8CrwxX7i6pNln8hFWVrnCbEY=
X-Google-Smtp-Source: ABdhPJxbCbtoknBNj7rIq3xyO94qQJIdo8e+plDrValhO63iRzxuHX2APcWRpzYaIDF5IlLkMv38Xg==
X-Received: by 2002:a65:6554:: with SMTP id a20mr1888655pgw.107.1632953291364;
        Wed, 29 Sep 2021 15:08:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 73/84] sym53c8xx_2: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:49 -0700
Message-Id: <20210929220600.3509089-74-bvanassche@acm.org>
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
 drivers/scsi/sym53c8xx_2/sym_glue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 6d0b07b9cb31..76747e180b17 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -133,7 +133,7 @@ void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 		complete(ucmd->eh_done);
 
 	scsi_dma_unmap(cmd);
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /*
@@ -493,7 +493,6 @@ static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
 	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	int sts = 0;
 
-	cmd->scsi_done = done;
 	memset(ucp, 0, sizeof(*ucp));
 
 	/*
