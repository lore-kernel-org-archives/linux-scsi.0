Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A574BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CE3F613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347078AbhI2WIj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:39 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:35427 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347111AbhI2WIe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:34 -0400
Received: by mail-pf1-f177.google.com with SMTP id w14so3170243pfu.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=feBz4Y8C2Gs8Lf7Y5c7I+eadq9g2yg8K1qm0BqDiVj4=;
        b=I90WX5I6f1GAC3PFhKcKBVKXoaTLWi23CocnAe6eIQE/LbbUr7KmEzzaYJ1pe13s7C
         PY9+tv0aW9Ya9DhtEoRbuzVSe0VbTYACLYoCZlcOkRAj88/rx3FVaBR3DpfbDeGMtlX3
         QY6bI55mdOmdyc2MM6pYNHIgyXeldk/ximpYMfLL8Dn97gXlsyV4/BzXbyDWZnfIqyQH
         zZDcSJyQNMj1nQ5hX5BRcqg0ZCGTteiR+9L/Hh/mC18TO5E959bOO6YuWEcSZ3KtnK1O
         5y6USXjuMBvPJ3u6MnFtlc0eV600gyYJedG/5/KKFtl5XMvSfO8GueAlA19vj7tgJYO0
         /LOQ==
X-Gm-Message-State: AOAM531BWg86wFyDUyFXxcvUQ068eY5zhgmsMFMfwjBmocUf7t0I2aC6
        kMp8SlzxVD5xe8Z8W1wwmKE=
X-Google-Smtp-Source: ABdhPJzrpcqshOaQpRlXNOmynAVnXwyn1QerZZyJKXVnpNURaImWWx9LMyySlYApiMhkc+JUE7kGAA==
X-Received: by 2002:a62:1bc2:0:b0:44b:bd59:4b32 with SMTP id b185-20020a621bc2000000b0044bbd594b32mr2060341pfb.55.1632953212512;
        Wed, 29 Sep 2021 15:06:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Lee Jones <lee.jones@linaro.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 22/84] arcmsr: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:58 -0700
Message-Id: <20210929220600.3509089-23-bvanassche@acm.org>
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
