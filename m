Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E937CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1FC761406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347128AbhI2WIx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:53 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:46060 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347092AbhI2WIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:49 -0400
Received: by mail-pj1-f53.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so3130076pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gf/FCAlG1Su8RpHpomw7brVDwwgZ3/XgilRVi9Fgunc=;
        b=Kp/0+TurQbnplmW6AnF2UrXAAm38PpSJVn7FHWMhEi5rqIfpDxqhj8N4gf0mJfUcGb
         5P7zZ4FsZ/2ZV/Y8RlXmR5BLSjn4xgrcE2JyP0wDsDByAJKQJ6vJjtmPZY97F3+JBfAs
         e3Zs5h/GG0Y9/I5fb0Vx703VkcmNAcyr8TzpTzkdevuJId+RX+tpaEQSsRTxhGBSkWO0
         FwguMVEJkmnvFeted1/6MYJCKFNrE0YTQzNuObUc4iJU1pHPUstDMuMMC4eensCtu+Iw
         WjhWr73s9zh5sCArDRjkq9L5wS3zx3t8pOYjpQC5GBEQl9f69uUvUjreS5hncepSTzvx
         dvAA==
X-Gm-Message-State: AOAM531oD0TnNvstdle8Qt6nl8pmiTk31lmIvFT3USDZPRwilMmDPRD0
        PNlhl0XqTiRvbwGbt1O2vXY=
X-Google-Smtp-Source: ABdhPJzv3RJcx6BdxFehwZoU1s+12ABrlR5MIaw5EWKq0MbMLOwcWWsmnUkKrwOQTut/W4UHHyNy1g==
X-Received: by 2002:a17:903:1207:b0:138:e2f9:6c98 with SMTP id l7-20020a170903120700b00138e2f96c98mr796069plh.11.1632953227849;
        Wed, 29 Sep 2021 15:07:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 31/84] esp_scsi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:07 -0700
Message-Id: <20210929220600.3509089-32-bvanassche@acm.org>
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
 
