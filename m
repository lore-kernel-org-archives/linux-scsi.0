Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06542C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB01860F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbhIRAIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:35 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:43772 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236753AbhIRAIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:32 -0400
Received: by mail-pf1-f173.google.com with SMTP id c1so7728296pfp.10
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gf/FCAlG1Su8RpHpomw7brVDwwgZ3/XgilRVi9Fgunc=;
        b=dlY5B2Wz8+LQIkmkps6/K8BPdNJTRs7BAgjbpvImR+TzhZ3YKiBQWP+wj/RFWWHmHc
         Ued+iP6MXZop1f5O77WNGDkVL3ZYxBUr/biw19KII2vvOdIEMwD2jqnkpsfW7qc2+z6L
         Id3vC5GT5frELA73srFBa3eIjrit6MwyP5Fv+uty0sgI0rO4wqB2s6jA2vaDSzKCUFqD
         5V9/jeQE1heUm3lZhXMkoKZv3ZYbIIZgrU2HrZ2JlHO5TvTDsTmE3gi5v9umJhTrr3H/
         H+6beNc49bRT1HP+enQUGodYRg3xuAP1jswi4zgDCXcKYXDDQuuVhLgNGjaTBYaqRNuq
         ByeA==
X-Gm-Message-State: AOAM533LWf9OibfyBTVO/c9nG/HhjGdSvsoCukvmajdtYISIpgthjwlk
        Ia7+mu1vlNAkrcsMOC89R6AhD5Vp/jI=
X-Google-Smtp-Source: ABdhPJzcp229+/wchp7QzVYbo6YIKO8DDolIU3JECH1odS7N2RSb7IspnbcIi7CLnpUehcK5w9jPbg==
X-Received: by 2002:a63:2b03:: with SMTP id r3mr4548225pgr.188.1631923629507;
        Fri, 17 Sep 2021 17:07:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 32/84] esp_scsi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:15 -0700
Message-Id: <20210918000607.450448-33-bvanassche@acm.org>
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
 
