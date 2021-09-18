Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73942C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D09460F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344409AbhIRAIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:40 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:34310 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344404AbhIRAIi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:38 -0400
Received: by mail-pf1-f171.google.com with SMTP id g14so10707001pfm.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pgmaWbpH/nc41CqD55iaw+VDjWvWUX/PaAX77qHWYm0=;
        b=t1LMhTqFhOlYG0NQoOEoxtemnDwa1buqPYJNhTXLcUvEQgnfClvDRzRSfpgb6Brfl5
         pHZEwvKMOWTWGINhmP4gPSir3IXL6VnLQandMzI3KQ3ONkk91z9YULQ/8DE9vM/WhG1+
         /1JPI+5jUUxhRuUVTivGcDadd93F+GTAeeKElUQhyP+XwnlJnELUcLNMorct1Yiwmfd1
         iDjvvijYwii3bh11QypIpzk1uMlxEVRs+z5QbU8I67TJitCOQjaEjnr7jR7Wk1fx+q6+
         gl4yIW7ioJuKOiOuzAnUktXdHewp+K8YOFkbQ5vOLIcnfgqaPU9EmRNXiSiT2ZmShMzl
         dU+Q==
X-Gm-Message-State: AOAM533GCB91iEGph8PJE4IPd2trpEsUbr/zaVpzI0Pg15liZffTekPl
        ddbd+4pZE3JcS3QHVVtGaEJu4uFfz3M=
X-Google-Smtp-Source: ABdhPJxT10rCsSOX2jJyNNTmTF9OW/63gNzrvhBFGCJTxSPrE9OkPaFUIS5mt6nU8UoNWgLKgugKDA==
X-Received: by 2002:a05:6a00:2a2:b0:43d:ea13:9c06 with SMTP id q2-20020a056a0002a200b0043dea139c06mr13731999pfs.37.1631923635397;
        Fri, 17 Sep 2021 17:07:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 36/84] hpsa: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:19 -0700
Message-Id: <20210918000607.450448-37-bvanassche@acm.org>
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
 
