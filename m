Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCCAC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9990760FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347165AbhI2WJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:23 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:45661 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347168AbhI2WJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:18 -0400
Received: by mail-pf1-f174.google.com with SMTP id w19so3128459pfn.12
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4yIYwB2eiU/LfZfyzZZ6+4fmT9tDEj4nMNDV+tci8nQ=;
        b=c/2tNrsUVWE5PQf8rMk/rxO+MbhMLDch2WdhFierj9C9z4+uGboHewyzHm6I566bnp
         WeZy1JRBNmcsjLgXJ5/7QIs3hq5ve1MnfN+N/ZBSmi6F/ivVlg2/0UfPNiKBxwumNoUK
         pn5sUWRqzLYVohZOUn+RY6KhK9rkF8YNm+Rl/hbbExApt0/dNV+m5+zii+r712DCZzyX
         oz6GpoL4alqsSmCYpsd61VjQyZLWnH9f0Y1j+LgtMxlqLvg7Y3k7phMdyOvsb1vRz9dG
         QhMXEt+hCGp6lETCQPGoG4pQU6+oi4zFLsfi/zhCGiUW7FF7TxAieD98IrY1Al4erN+2
         Lseg==
X-Gm-Message-State: AOAM531Jvwqvve0LB2XwlkxZF5Uf+4+gKvv0dshwEhYwx7tq6GZ7h93H
        9lwHHH6FVdHs9Ok6Zx5PGh+n+Yd8yug=
X-Google-Smtp-Source: ABdhPJwunGBW6cFoWZQN32kkYXGs0BlOCwliuJKyungsgYYmDXXMCElwqpjEdgrKJ3BsAvuOt4NS3A==
X-Received: by 2002:a63:1547:: with SMTP id 7mr1925973pgv.122.1632953256776;
        Wed, 29 Sep 2021 15:07:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 50/84] mesh: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:26 -0700
Message-Id: <20210929220600.3509089-51-bvanassche@acm.org>
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
