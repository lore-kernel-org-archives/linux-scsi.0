Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EABC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1FC56140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347140AbhI2WJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:19 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:41824 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347137AbhI2WJO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:14 -0400
Received: by mail-pl1-f170.google.com with SMTP id x8so2518735plv.8
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cx5mLSqSRMTPAqHdKvTeRQWD317TuE1XEtb+GD/tb58=;
        b=GjFr118mdS+SLGbc0AW52zTXFMdCq2NChQ3Lt8zQYTH/a8BnBLbv4+2d/pNSkkuEGn
         P6zDOoYsKYCu2dzLoOVW41xvAbg9bfu7ojXYXrVmxrNSDIrmfKVImnSz5Ogclg3tqxeF
         hocmSxiMKbY1KExQSUIMAa3KZl/977o0ZJbXhnjkETNzDzdtir8nqQEijxnDpTvkpw29
         3RgnQgfjpub9hCmW2u/CaMGi/mIOf1WH6n4NImRpg8Avy8KNMY1OYUX1s4g8j/8iZqcD
         e5UJ+e6vrJp6GbIxaJs3HTDRBf468Pkrl5W09wG2FPMY8dE05sAkpR1dFW8q6KnaVTq1
         vpOw==
X-Gm-Message-State: AOAM530WFDP6vKDFRSZNWyW1k/Sg+x67ct1pxETIbPfQsATOCrqjpXgB
        mdrokXtMlHuKvGBOf1T4RzA=
X-Google-Smtp-Source: ABdhPJwHeLzsH+l+ppaBcUJoWuuL3fS7mq9o6ntbr9LnhUi93m3rUmgjjsx7BkP2kIQEkWl4+D9Z8w==
X-Received: by 2002:a17:90a:304:: with SMTP id 4mr8901646pje.124.1632953252598;
        Wed, 29 Sep 2021 15:07:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 47/84] mac53c94: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:23 -0700
Message-Id: <20210929220600.3509089-48-bvanassche@acm.org>
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
 drivers/scsi/mac53c94.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index ec9840d322e5..9731855805f5 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -83,7 +83,6 @@ static int mac53c94_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cm
 	}
 #endif
 
-	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
 	state = (struct fsc_state *) cmd->device->host->hostdata;
@@ -348,7 +347,7 @@ static void cmd_done(struct fsc_state *state, int result)
 	cmd = state->current_req;
 	if (cmd) {
 		cmd->result = result;
-		(*cmd->scsi_done)(cmd);
+		scsi_done(cmd);
 		state->current_req = NULL;
 	}
 	state->phase = idle;
