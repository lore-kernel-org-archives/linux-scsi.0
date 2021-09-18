Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC86C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121DF60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbhIRAIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:17 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:37836 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245505AbhIRAIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:16 -0400
Received: by mail-pf1-f173.google.com with SMTP id j6so10671588pfa.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=feBz4Y8C2Gs8Lf7Y5c7I+eadq9g2yg8K1qm0BqDiVj4=;
        b=UPWP3nWXOveYpKa8t85muoXq2p1piAJUlFrMeUhKjbV9Yk9tc9w7Hgza+8skskhxEu
         8sfZUUWpxPjb34Jsnb5ReN1/8BjVccvefoZYfDDYhQDdzo2eZn6yQlACOoT7mWBA8vmU
         hA35L3L5esQa7V3rWyJva0GL9gxzj5YkPklL7Kmk0yhlRG+okxtHD3GEqR6Xt8CVMeDb
         ZDtiV4DeaoyTDYO1gbQie2PBlvoTtHP1NAgIaPSv0NsATQEmAtlc8vAUu1iuZVadgGzd
         6aaoxG55pjWk4QohA0U6cEtip0yA+nuqhG3pglamQxWEhxdH1CqppDr7aElu83MYYflh
         lCPg==
X-Gm-Message-State: AOAM5301YysrrPsu0b/bO0ZyDLMD+ZXUXzc7JzVOFPtwWDQwiWKNgPmc
        7EpBlRn1ZhV2b2PnanPzw/IVPvkqk8s=
X-Google-Smtp-Source: ABdhPJxd/3FnMqiOXVDf8GfidstS/lexfu4C/T6Ksl0kr7MHtEoKbjtLxpbviZf4kE8QJxvQl5Ukzw==
X-Received: by 2002:a63:ac43:: with SMTP id z3mr3287811pgn.14.1631923613317;
        Fri, 17 Sep 2021 17:06:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Hannes Reinecke <hare@suse.de>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 23/84] arcmsr: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:06 -0700
Message-Id: <20210918000607.450448-24-bvanassche@acm.org>
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
 drivers/scsi/arcmsr/arcmsr_hba.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ec1a834c922d..e2692ca87a6e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1318,7 +1318,7 @@ static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)
 	spin_lock_irqsave(&acb->ccblist_lock, flags);
 	list_add_tail(&ccb->list, &acb->ccb_free_list);
 	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
-	pcmd->scsi_done(pcmd);
+	scsi_done(pcmd);
 }
 
 static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
@@ -1598,7 +1598,7 @@ static void arcmsr_remove_scsi_devices(struct AdapterControlBlock *acb)
 		if (ccb->startdone == ARCMSR_CCB_START) {
 			ccb->pcmd->result = DID_NO_CONNECT << 16;
 			arcmsr_pci_unmap_dma(ccb);
-			ccb->pcmd->scsi_done(ccb->pcmd);
+			scsi_done(ccb->pcmd);
 		}
 	}
 	for (target = 0; target < ARCMSR_MAX_TARGETID; target++) {
@@ -3192,7 +3192,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 
 		if (cmd->device->lun) {
 			cmd->result = (DID_TIME_OUT << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return;
 		}
 		inqdata[0] = TYPE_PROCESSOR;
@@ -3216,18 +3216,18 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		sg = scsi_sglist(cmd);
 		kunmap_atomic(buffer - sg->offset);
 
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 	break;
 	case WRITE_BUFFER:
 	case READ_BUFFER: {
 		if (arcmsr_iop_message_xfer(acb, cmd))
 			cmd->result = (DID_ERROR << 16);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 	break;
 	default:
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 }
 
@@ -3241,10 +3241,9 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
 
 	if (acb->acb_flags & ACB_F_ADAPTER_REMOVED) {
 		cmd->result = (DID_NO_CONNECT << 16);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
-	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
 	if (target == 16) {
@@ -3257,7 +3256,7 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {
 		cmd->result = (DID_ERROR << 16) | SAM_STAT_RESERVATION_CONFLICT;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 	arcmsr_post_ccb(acb, ccb);
