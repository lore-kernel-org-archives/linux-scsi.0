Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBB7C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30B7C6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhDTAK0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:26 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:39917 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbhDTAKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:13 -0400
Received: by mail-pj1-f46.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so21335282pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0btYXBax5Zwl5iOG3NcrJugqEI1+E6ICTJcqCpGD4k=;
        b=Xlj89qQmMnxeU5ieTCMJP16eyctqrvjarjV5ZmoM8ieQbD1uEOMlLuVcR0a+ojlclY
         f0W8tierpIkVRJSrghDOgOhtkU+jSUuVKrAtri5NNrTbgrBEiMPdOsyVD5NTd8ko7BZs
         h3nerRMkSet9pymsujE6XIrVDqrBwdepK+5niboZVysAHY+lb+PwFTxC0tR/8g6bODKp
         48MGiVd28Qykp978AxtLWOtxZl4Ci7tRbE1ZSIB9AahnK1gB/6xCgbJWf1pMLu/UPsCH
         5hz8PwLvP/Pkz02vRj7eXzlFzcWTUZKOk4+BeRpRf0PxyTUMf24wnAWNagMt7jh7xY7T
         2/dg==
X-Gm-Message-State: AOAM53202D0NB0O+Rz5xUjU6cgxKnxsbOw7NhUayiNZZGnWOKdCbyTtW
        FqtSQ3CJ6UWexeGTBImwV94=
X-Google-Smtp-Source: ABdhPJxpxb0x0Yp5C+rgYyZOjsXg0D+38+bpWF1Xaso+rUtDO7u3uHM6mtIVa4us4A9Epsu6cvhmlQ==
X-Received: by 2002:a17:902:d70f:b029:ec:b679:f122 with SMTP id w15-20020a170902d70fb02900ecb679f122mr1333238ply.38.1618877383013;
        Mon, 19 Apr 2021 17:09:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 044/117] esp_scsi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:32 -0700
Message-Id: <20210420000845.25873-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esp_scsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 342535ac0570..694d98a20b5f 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -905,7 +905,7 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 	esp->active_cmd = NULL;
 	esp_unmap_dma(esp, cmd);
 	esp_free_lun_tag(ent, dev->hostdata);
-	cmd->result = 0;
+	cmd->status.combined = 0;
 	set_host_byte(cmd, host_byte);
 	if (host_byte == DID_OK)
 		set_status_byte(cmd, ent->status);
@@ -922,7 +922,7 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 		 * saw originally.  Also, report that we are providing
 		 * the sense data.
 		 */
-		cmd->result = ((DRIVER_SENSE << 24) |
+		cmd->status.combined = ((DRIVER_SENSE << 24) |
 			       (DID_OK << 16) |
 			       (SAM_STAT_CHECK_CONDITION << 0));
 
@@ -2035,7 +2035,7 @@ static void esp_reset_cleanup_one(struct esp *esp, struct esp_cmd_entry *ent)
 
 	esp_unmap_dma(esp, cmd);
 	esp_free_lun_tag(ent, cmd->device->hostdata);
-	cmd->result = DID_RESET << 16;
+	cmd->status.combined = DID_RESET << 16;
 
 	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE)
 		esp_unmap_sense(esp, ent);
@@ -2062,7 +2062,7 @@ static void esp_reset_cleanup(struct esp *esp)
 		struct scsi_cmnd *cmd = ent->cmd;
 
 		list_del(&ent->list);
-		cmd->result = DID_RESET << 16;
+		cmd->status.combined = DID_RESET << 16;
 		cmd->scsi_done(cmd);
 		esp_put_ent(esp, ent);
 	}
@@ -2536,7 +2536,7 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 		 */
 		list_del(&ent->list);
 
-		cmd->result = DID_ABORT << 16;
+		cmd->status.combined = DID_ABORT << 16;
 		cmd->scsi_done(cmd);
 
 		esp_put_ent(esp, ent);
