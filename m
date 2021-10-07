Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADFFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C6161074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242246AbhJGUcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:14 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:33459 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242143AbhJGUcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:08 -0400
Received: by mail-pf1-f178.google.com with SMTP id s16so6358425pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=feBz4Y8C2Gs8Lf7Y5c7I+eadq9g2yg8K1qm0BqDiVj4=;
        b=ihP5pSX0onaRjL52dGw0A0yeyZMNXUP6MTVswuURYnWpQoEEbbx1kLTvvWlE2zKg0n
         PylasjqLvP1aFmFt1+PERo+Mzm+izG3m/tEK5HYe5sO3EvUM2s5TRbF3MAvsF+59uxUE
         fyHfUjQXs9fHAVoNCa4uarCdcI3U4V26Nosfyz93QQkWKQTeURXK6SfJ2k24sWFDN+nT
         +kGzbkciTsEBEGgArG532Qs7lnitWqRin37PJqb5SskKjD/YeF8eghHMXzyVrzdNTrZH
         z8gLB2kGABlAxXAVJCgvbe4F4ABDG6mF4xTf6drdCepHqZ55126KjNPnzgejOcCMQsam
         3B8Q==
X-Gm-Message-State: AOAM532Qc41ihzKavnfdWSReCdcN++Qr2gdctAb3eo2HKBE2EIHm63jl
        AZYhLkov/7ZYNuKICXRaqRA=
X-Google-Smtp-Source: ABdhPJx3CI56kqbiOlt33z/nnnyylBlXzjLzfPKpPdVexbQAaqP3Y53+cnHRw2QVt8syHttOWqw4cA==
X-Received: by 2002:a62:6587:0:b0:44b:5c4b:fe8c with SMTP id z129-20020a626587000000b0044b5c4bfe8cmr6452278pfb.33.1633638613186;
        Thu, 07 Oct 2021 13:30:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Lee Jones <lee.jones@linaro.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 22/88] arcmsr: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:17 -0700
Message-Id: <20211007202923.2174984-23-bvanassche@acm.org>
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
