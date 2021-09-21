Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08951C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E113C61166
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhIURgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:36:45 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:41638 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhIURgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 13:36:43 -0400
Received: by mail-pf1-f180.google.com with SMTP id k17so156121pff.8
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 10:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=d438B8uz2X7dv4EM4CLjoK5lXE0AO4mHS3+eYnxlwZM=;
        b=5OvxbmRZiOJ0nlcJWzo9ZiOSJ75ikRG8OyLwn6XEbY4smofCpSypt2AX3iaPwEdjvx
         TGLusIkmwjhquFSuED2Yg56/VFQ5BI3hdrjaqUN7H5oZPTezlvEJZHaG+/DIrNOZG58R
         u0h+5bA27SgVD/LIdIjUDFrRZQjcTj2rFGEa+pXj+PiuADXpI33eshqbYZcZR4e88tY9
         K9Ws1t/5J8BCicw4Rfk7LRNN020jEwFwS9M80WrDDyxHeAYMf3CeMp8LfsP/7IzWH7m4
         h2qp2hyLMqGNDZZKwKS3kekudb9DlxCjqDJa13D3zeiLVLq1C3lh4+TWrQIHOuYdlg4v
         V3+A==
X-Gm-Message-State: AOAM531PZhU/2kVRWzM7+2RVl12kRYMypaQtPLM6Bt8OmOTrTbg0oPS0
        OhnHizgl7cIOVPieTvan0sw=
X-Google-Smtp-Source: ABdhPJxNbEbOfRmnZwMgtMv3b9im2c/GMIjvGHWS5X7IYVT0ju2C+rZRu8bvuGWeIImkSX7scxIb7Q==
X-Received: by 2002:aa7:95a1:0:b0:43d:dbc5:c0af with SMTP id a1-20020aa795a1000000b0043ddbc5c0afmr31455578pfk.37.1632245714759;
        Tue, 21 Sep 2021 10:35:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f15:8d17:800:eea3])
        by smtp.gmail.com with ESMTPSA id w22sm14561603pgc.56.2021.09.21.10.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:35:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 84/84] scsi_lib: Call scsi_done() directly
Date:   Tue, 21 Sep 2021 10:34:36 -0700
Message-Id: <20210921173436.3533078-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210921173436.3533078-1-bvanassche@acm.org>
References: <20210921173436.3533078-1-bvanassche@acm.org>
Reply-To: 20210918000607.450448-1-bvanassche@acm.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly. Since this patch removes the last user of the
scsi_done member, also remove that data structure member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 3 +--
 include/scsi/scsi_cmnd.h | 4 ----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c3a0283dbff0..be1a21cec54b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1520,7 +1520,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	return rtn;
  done:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 
@@ -1693,7 +1693,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	cmd->scsi_done = scsi_done;
 
 	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 5b230d06527f..045f8c08ab70 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -124,10 +124,6 @@ struct scsi_cmnd {
 				 * command (auto-sense). Length must be
 				 * SCSI_SENSE_BUFFERSIZE bytes. */
 
-	/* Low-level done function - can be used by low-level driver to point
-	 *        to completion function.  Not used by mid/upper level code. */
-	void (*scsi_done) (struct scsi_cmnd *);
-
 	/*
 	 * The following fields can be written to by the host specific code. 
 	 * Everything else should be left alone. 
