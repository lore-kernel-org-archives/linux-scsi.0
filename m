Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E9AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD29861108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242227AbhJGUcz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:55 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:53826 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242220AbhJGUcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:53 -0400
Received: by mail-pj1-f51.google.com with SMTP id ls18so5795718pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4yIYwB2eiU/LfZfyzZZ6+4fmT9tDEj4nMNDV+tci8nQ=;
        b=t8QuEAFGiTXwoHu8o+tWdkxvzi5o0gu0m6gMwfcaf9E13+/9YlSDuoQIEuw/Df90dD
         FM3wS3cJEzWDtgjbKIWhoEmAuazoCJ3/YQrVy31MbF644wtnVqD1J6dp3+4V1gMv7ASM
         By/suRsQGdUmX3tJGk+7avUF2RiPYgCn9anog8E6aMvB9scmIoTEWJTn+PQIOgGnlSiS
         69hwFDpixiZEgeKlgXNF87voH0CKXF+vIOZzWDB6puwQk14UXeeg8CVr5qpPG0ppyF3R
         Cw29q0ANhXnvXoHZnSh65HP5gl9P1xoL3enD+2y4Jv2TornulgCA/72E59lhtyK1jAyE
         Lpqg==
X-Gm-Message-State: AOAM531JH981xgeEqC0dwpuuCE9hpSpCVMF7RFMRC1tEnWVI37FduN3h
        hjWw6EDrTlI9ll9TAF/ay3o=
X-Google-Smtp-Source: ABdhPJy7nvqXF/OERMntY45nfbXsB+yI3mq5kSludEcQ5oWvBxbR/KToioE/2sjy4XifOUXzZ+mtSg==
X-Received: by 2002:a17:90a:d58b:: with SMTP id v11mr7133561pju.207.1633638658975;
        Thu, 07 Oct 2021 13:30:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 50/88] mesh: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:45 -0700
Message-Id: <20211007202923.2174984-51-bvanassche@acm.org>
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
