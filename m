Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E1BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348376103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbhJGUca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:30 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:45965 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242304AbhJGUcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:23 -0400
Received: by mail-pg1-f180.google.com with SMTP id q12so199153pgq.12
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gf/FCAlG1Su8RpHpomw7brVDwwgZ3/XgilRVi9Fgunc=;
        b=MNtk4eNCa7jCsbDCpvN558NHMmcjoyaSBhUKmeb5/dJtmf2B3p5u3s+Qm1+5ckP/2y
         k88j11BrrAr2aE42KP+MVr05FPMWFgLbyHlW7DJu7pCRBUuEpmNr7TCHDz8JymYI53c2
         UWYT++DjHHqh3JfUp0yO2eC39A19BfJ2gyUt+5rl4rkuH2jCJcH9fwN2m3Vi5hjfos0P
         tSGjJNuyRyNTp1Rc7/JIrIHwQBd70+xrlS0mrx/1znZQLatWJ6T2e44/Zr7nPqCeDW7u
         115zuVfDEYjEiJAu3yAQIf3gGfB+P5nG468RQpDltcmyN+DBxNSS0kpH52UWh61QvZC1
         Q8qg==
X-Gm-Message-State: AOAM5336Z0j8cSZ7ETcp/jtp9OMg5exmMa3N7j33GlBwiLv6tqJ8B8Pw
        84o/w9ambb4sojSfk+/SzRA=
X-Google-Smtp-Source: ABdhPJx5HmG4ldLEC6lr9thbre/EzgOsjn4GkOrs2ZVkQ0yi7USH9I0A9uOja4YgzFIzLfFCaD1LZg==
X-Received: by 2002:a62:52c7:0:b0:44b:d8b4:4b0f with SMTP id g190-20020a6252c7000000b0044bd8b44b0fmr6354086pfb.18.1633638629274;
        Thu, 07 Oct 2021 13:30:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 31/88] esp_scsi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:26 -0700
Message-Id: <20211007202923.2174984-32-bvanassche@acm.org>
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
 drivers/scsi/esp_scsi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 9a8c037a2f21..f7c2d64f1cef 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -936,7 +936,7 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 		}
 	}
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	list_del(&ent->list);
 	esp_put_ent(esp, ent);
@@ -965,8 +965,6 @@ static int esp_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 
 	ent->cmd = cmd;
 
-	cmd->scsi_done = done;
-
 	spriv = ESP_CMD_PRIV(cmd);
 	spriv->num_sg = 0;
 
@@ -2038,7 +2036,7 @@ static void esp_reset_cleanup_one(struct esp *esp, struct esp_cmd_entry *ent)
 	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE)
 		esp_unmap_sense(esp, ent);
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	list_del(&ent->list);
 	esp_put_ent(esp, ent);
 }
@@ -2061,7 +2059,7 @@ static void esp_reset_cleanup(struct esp *esp)
 
 		list_del(&ent->list);
 		cmd->result = DID_RESET << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		esp_put_ent(esp, ent);
 	}
 
@@ -2535,7 +2533,7 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 		list_del(&ent->list);
 
 		cmd->result = DID_ABORT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 
 		esp_put_ent(esp, ent);
 
