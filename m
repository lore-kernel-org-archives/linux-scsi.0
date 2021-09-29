Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B74C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C2D60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbhI2WKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:10:10 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46931 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347189AbhI2WKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:10:03 -0400
Received: by mail-pg1-f179.google.com with SMTP id m21so4099393pgu.13
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLjrkUrDGjiUH0yp0QEebobu1TDlTcuEBk039zm4Bj8=;
        b=dMgcr2J8uU3Is8bUvSRTBZ8+VtpzH9i91POZM6ZvYcP9LyPDMNdaZoB02JvWTGMM86
         4FjB5y2nWNV0ZnMUap/0XjCEJbXhVKIGG1886UgUUi+0zvdgaCBMjdfZKzsAV+yrFWwu
         GRswiNu/EzKf70QrdGLJpJv+HkpyIXZi5rIUO+H/VDnqdUxzA7DvizaredN4WtLRe5jZ
         I+hv09Bsr5ZFiStUK2AGWHRt80X22Rp+Ue01MoIyvMrhdOgKOj+Iv9EC0rdJ+2ue0zNk
         +DV8wWAP0XJTnfJz8xv3oUifLz5x+6ZGoejkWv2+taxV5yO6rgvA3MVJgOXnnTOkHgZu
         wIsQ==
X-Gm-Message-State: AOAM531lwiXrihGQGVcoTqkXHLO3SSIAawEZ/YSBcbki7UG/4U9moMaD
        Ep6G5XRGLPFJnpU1jSg/l0izOZoseN0=
X-Google-Smtp-Source: ABdhPJw6VqgUIpWFgCJFZuVdgUhQBFZHHAO/tkcqScqG0zd+gBeJvBglU6VvrjKNEx6bCY9mnXN4DQ==
X-Received: by 2002:aa7:96ab:0:b0:43d:f9e0:10bf with SMTP id g11-20020aa796ab000000b0043df9e010bfmr992826pfk.32.1632953302132;
        Wed, 29 Sep 2021 15:08:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 78/84] wd719x: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:54 -0700
Message-Id: <20210929220600.3509089-79-bvanassche@acm.org>
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
 drivers/scsi/wd719x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 6f10a43510fb..1a7947554581 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -200,7 +200,7 @@ static void wd719x_finish_cmd(struct wd719x_scb *scb, int result)
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
 	cmd->result = result << 16;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /* Build a SCB and send it to the card */
@@ -295,7 +295,7 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 			 DMA_BIDIRECTIONAL);
 out_error:
 	cmd->result = DID_ERROR << 16;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 
