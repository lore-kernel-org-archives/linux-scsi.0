Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93DDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3E561406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347132AbhI2WI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:59 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:39758 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346209AbhI2WI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:56 -0400
Received: by mail-pg1-f176.google.com with SMTP id g184so4148427pgc.6
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pgmaWbpH/nc41CqD55iaw+VDjWvWUX/PaAX77qHWYm0=;
        b=zN7SAdoyDL0y41sRH9qz0K/zS9I9PTMwov9miHSflCiJRpnaWOVt5lHBvdpgSFZ3/5
         h+ooqX98Lx+Ci2/zo9R4Jnl46wMDVx9u+yWH8MFPURIDqSHbu+zFn+SAmHM3qMl6+WEr
         hmSGPmZGprQ9VqcNsvUYqwEgL5Qb63CMHCmE5rzAVUEEQP7spzgEOcbFpvDnnollBcTC
         andRsV8WpkXAt1DaUKtTmbQZmWT0+zNzgCZZp7jOTK6S1tKZwQPwZlD75ap19jo1XMIn
         uAWN53BmZ9mBRTgNcBhstmr1jISxciP04gdboOJrAmDb70xdyWvilRtSGpydUI3UbXQm
         2RYw==
X-Gm-Message-State: AOAM533uo2VUZJ5Ls8W0FgopXy9fnl2QMOCq+DBdkI5jh1r1z3htCR5o
        F8obEB0R4ImuMWqQMsLNsK4=
X-Google-Smtp-Source: ABdhPJz3zD2f0/7AdQFk7s3HjjD9hAVRvfZ81o46OaC2474YihySjZGOgnc0gw8jdjaTGvCXzI2FEA==
X-Received: by 2002:aa7:8f31:0:b0:447:8167:46be with SMTP id y17-20020aa78f31000000b00447816746bemr836724pfr.61.1632953234666;
        Wed, 29 Sep 2021 15:07:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 36/84] hpsa: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:12 -0700
Message-Id: <20210929220600.3509089-37-bvanassche@acm.org>
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
 drivers/scsi/hpsa.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3faa87fa296a..a1153449344a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2482,8 +2482,8 @@ static void hpsa_cmd_free_and_done(struct ctlr_info *h,
 		struct CommandList *c, struct scsi_cmnd *cmd)
 {
 	hpsa_cmd_resolve_and_free(h, c);
-	if (cmd && cmd->scsi_done)
-		cmd->scsi_done(cmd);
+	if (cmd)
+		scsi_done(cmd);
 }
 
 static void hpsa_retry_cmd(struct ctlr_info *h, struct CommandList *c)
@@ -5671,7 +5671,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		 * if it encountered a dma mapping failure.
 		 */
 		cmd->result = DID_IMM_RETRY << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 }
 
@@ -5691,19 +5691,19 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
 	if (dev->removed) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
 	if (unlikely(lockup_detected(h))) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
