Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CBAC4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDBB61164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344936AbhIRAJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:16 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:41565 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345038AbhIRAJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:01 -0400
Received: by mail-pj1-f41.google.com with SMTP id m21-20020a17090a859500b00197688449c4so8581630pjn.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4yIYwB2eiU/LfZfyzZZ6+4fmT9tDEj4nMNDV+tci8nQ=;
        b=n1z0lP0FufowMZ4vp7Qt/OKPKwPezrOOAN8tl9ZDNUbCqiV2xQx4lkgu8lgfH/++/V
         kJ8Ta9SPPJc7UWXXpQYQp3xjXTxXRWjNtTs+lvm/FCcGRvnq+pI+U3p7wsllj0Yw0C0G
         vDp9EUpT383UqPhwbWWGL/Md0uLYNUF/1A7G70ShHAt6sK2pow30UV2JmFO/gXki6aUk
         Kj8Egqy0LfIb5S06f1amltahaMF0zplRPIZHEMJ9TjTAMp6hlzkYvVCmxMP8na+y+NUE
         Y1VzHThWre87xWyQl7HeKl52KSTYwhUP9Y7afbAqGQMQmbuK0JvP4yAF/0wZdEkui3ry
         +Mlw==
X-Gm-Message-State: AOAM532itv8PyiWT7VyjNDTsX6GaXFDBr+YqP1C23927BIcfLjf+bVpN
        shYAByG/0pzyH+Q7CT0Dug0=
X-Google-Smtp-Source: ABdhPJzool6OP5xY3f1V5+KyWtJ6QBuW9p4+/2By0aCKf21WVs2+37SZ+VValnD9qgHoGGm6mD1nFQ==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr24293952pjv.39.1631923659075;
        Fri, 17 Sep 2021 17:07:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 50/84] mesh: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:33 -0700
Message-Id: <20210918000607.450448-51-bvanassche@acm.org>
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
 drivers/scsi/mesh.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 78b72bcf58fe..73a3e85802ad 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -342,15 +342,6 @@ static inline void mesh_flush_io(volatile struct mesh_regs __iomem *mr)
 }
 
 
-/*
- * Complete a SCSI command
- */
-static void mesh_completed(struct mesh_state *ms, struct scsi_cmnd *cmd)
-{
-	(*cmd->scsi_done)(cmd);
-}
-
-
 /* Called with  meshinterrupt disabled, initialize the chipset
  * and eventually do the initial bus reset. The lock must not be
  * held since we can schedule.
@@ -613,7 +604,7 @@ static void mesh_done(struct mesh_state *ms, int start_next)
 #endif
 		}
 		cmd->SCp.this_residual -= ms->data_ptr;
-		mesh_completed(ms, cmd);
+		scsi_done(cmd);
 	}
 	if (start_next) {
 		out_8(&ms->mesh->sequence, SEQ_ENBRESEL);
@@ -996,7 +987,7 @@ static void handle_reset(struct mesh_state *ms)
 		if ((cmd = tp->current_req) != NULL) {
 			set_host_byte(cmd, DID_RESET);
 			tp->current_req = NULL;
-			mesh_completed(ms, cmd);
+			scsi_done(cmd);
 		}
 		ms->tgts[tgt].sdtr_state = do_sdtr;
 		ms->tgts[tgt].sync_params = ASYNC_PARAMS;
@@ -1005,7 +996,7 @@ static void handle_reset(struct mesh_state *ms)
 	while ((cmd = ms->request_q) != NULL) {
 		ms->request_q = (struct scsi_cmnd *) cmd->host_scribble;
 		set_host_byte(cmd, DID_RESET);
-		mesh_completed(ms, cmd);
+		scsi_done(cmd);
 	}
 	ms->phase = idle;
 	ms->msgphase = msg_none;
@@ -1634,7 +1625,6 @@ static int mesh_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *
 {
 	struct mesh_state *ms;
 
-	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
 	ms = (struct mesh_state *) cmd->device->host->hostdata;
