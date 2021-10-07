Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8BFC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D386103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242282AbhJGUdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:23 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:51858 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242603AbhJGUdK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:10 -0400
Received: by mail-pj1-f51.google.com with SMTP id kk10so5818475pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSrM2Z9Mg4h89R9uYoLr4hjxm8pWMZLJ41n8sRkf/Tc=;
        b=vLyZjW3CTB6UXoO3hb7D93Lq3gWM1YhjwWMetzhPxpSN9rJziFJCzURKvi9fKGexCi
         19XIXyOIU0E4tpwuF2lSon6E1g4o6tC+X6sIGFNJoOxKYSRibvmfLjyuxhERYNOOvw8z
         wS8rhMrqldMjBdIwqTRKJKdakL8gdb9wtI1qCPSU9E8zP+A9kct/OX5/W+Y2JPQtxtzb
         HAjXz18sV/VhS5T3Et+aa0xoX2zfhncnq8mkVG6OkuO/WuPKpCHmSeoofpTQi2z6Fgre
         i3B0ff0FEHEPNY/3c2HYg5Do2rQFrO9c1pIdZ2ALPl8lR1a22sbsxhWu7fZcib0k8NdM
         /HLw==
X-Gm-Message-State: AOAM5328ydleH3CvLavUOkxLImLiojhr7GIeA4S28P6UMGV67kL37OEN
        eJs1a1+r6ZkHrqKCpoWnnC4=
X-Google-Smtp-Source: ABdhPJzvQPBF/pbjamFFiLvkpAZvT81olt06ohfAWKeDknerp5WsNPwGsYIRbp4lyyHisXLZ0jOJiw==
X-Received: by 2002:a17:90a:a60e:: with SMTP id c14mr7892269pjq.70.1633638676035;
        Thu, 07 Oct 2021 13:31:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 60/88] pmcraid: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:55 -0700
Message-Id: <20211007202923.2174984-61-bvanassche@acm.org>
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
 drivers/scsi/pmcraid.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bffd9a9349e7..11f36fd4e62f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -837,7 +837,7 @@ static void pmcraid_erp_done(struct pmcraid_cmd *cmd)
 
 	scsi_dma_unmap(scsi_cmd);
 	pmcraid_return_cmd(cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 }
 
 /**
@@ -2017,7 +2017,7 @@ static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 				     le32_to_cpu(resp) >> 2,
 				     cmd->ioa_cb->ioarcb.cdb[0],
 				     scsi_cmd->result);
-			scsi_cmd->scsi_done(scsi_cmd);
+			scsi_done(scsi_cmd);
 		} else if (cmd->cmd_done == pmcraid_internal_done ||
 			   cmd->cmd_done == pmcraid_erp_done) {
 			cmd->cmd_done(cmd);
@@ -2814,7 +2814,7 @@ static int _pmcraid_io_done(struct pmcraid_cmd *cmd, int reslen, int ioasc)
 
 	if (rc == 0) {
 		scsi_dma_unmap(scsi_cmd);
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 	}
 
 	return rc;
@@ -3328,7 +3328,6 @@ static int pmcraid_queuecommand_lck(
 	pinstance =
 		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
-	scsi_cmd->scsi_done = done;
 	res = scsi_cmd->device->hostdata;
 	scsi_cmd->result = (DID_OK << 16);
 
@@ -3338,7 +3337,7 @@ static int pmcraid_queuecommand_lck(
 	if (pinstance->ioa_state == IOA_STATE_DEAD) {
 		pmcraid_info("IOA is dead, but queuecommand is scheduled\n");
 		scsi_cmd->result = (DID_NO_CONNECT << 16);
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 		return 0;
 	}
 
@@ -3351,7 +3350,7 @@ static int pmcraid_queuecommand_lck(
 	 */
 	if (scsi_cmd->cmnd[0] == SYNCHRONIZE_CACHE) {
 		pmcraid_info("SYNC_CACHE(0x35), completing in driver itself\n");
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 		return 0;
 	}
 
