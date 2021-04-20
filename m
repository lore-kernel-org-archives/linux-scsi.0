Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A04C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC35613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhDTAKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:14 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:36537 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhDTAJ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:57 -0400
Received: by mail-pj1-f41.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so21357360pjh.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4HyuekF2NhvlDK/R3K3jpHV/KDSGmRipp0zFJgr++I=;
        b=Jo5oGJ4PjOqesgENd6CywhgrYSSKUSGKvw3Ifl/V5Gens38tKDfDcASL+HudDnR6aD
         MK1zz72lC2D7TM1Jwb2jVhJtTq6WbGS2R5xr4H+pddDBzIZ5nyh1ELV+3gU+GinkItqT
         fWwg7Pq5MV6jDMzwJpbN1XhgET+QSm8y+uwNjjfdle9fmzGVb8WdEIrocKIcmiaW4OZp
         Gk+xZOIb/4nGLEx7sAcTfPTDTOJw2cUKhaKusyUfFlHw7q+w3aOerTecuNjIhRMxTrDP
         rEs+N6xLhSXYA3Roj7OWodyUWLGNvTSYgXs1pbYqaXHEhoUmatvIoVSqaz6st81nWx6/
         Ak0A==
X-Gm-Message-State: AOAM532Zgx0itFsmgurp3WC6wipSr1oVbCNK3/ROsxjxWRnfziHbA9Uc
        KbdOU/f39e5SCB2/lI/GLJ4=
X-Google-Smtp-Source: ABdhPJwdPF8gSdhyKBXiEs/dL6Vuh+qPGK5/IYXpgVCeXkFZGd60wUr4t8e0MQbHucgNHFBtmes70g==
X-Received: by 2002:a17:902:c14d:b029:ec:acd9:d5a0 with SMTP id 13-20020a170902c14db02900ecacd9d5a0mr5207199plj.60.1618877366810;
        Mon, 19 Apr 2021 17:09:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 030/117] arcmsr: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:18 -0700
Message-Id: <20210420000845.25873-31-bvanassche@acm.org>
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
 drivers/scsi/arcmsr/arcmsr_hba.c | 38 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4b79661275c9..c410fcd1c11f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1326,7 +1326,7 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 
 	struct scsi_cmnd *pcmd = ccb->pcmd;
 	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-	pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+	pcmd->status.combined = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 	if (sensebuffer) {
 		int sense_data_length =
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
@@ -1335,7 +1335,7 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
 		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
 		sensebuffer->Valid = 1;
-		pcmd->result |= (DRIVER_SENSE << 24);
+		pcmd->status.b.driver = DRIVER_SENSE;
 	}
 }
 
@@ -1390,13 +1390,13 @@ static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
 	if (!error) {
 		if (acb->devstate[id][lun] == ARECA_RAID_GONE)
 			acb->devstate[id][lun] = ARECA_RAID_GOOD;
-		ccb->pcmd->result = DID_OK << 16;
+		ccb->pcmd->status.combined = DID_OK << 16;
 		arcmsr_ccb_complete(ccb);
 	}else{
 		switch (ccb->arcmsr_cdb.DeviceStatus) {
 		case ARCMSR_DEV_SELECT_TIMEOUT: {
 			acb->devstate[id][lun] = ARECA_RAID_GONE;
-			ccb->pcmd->result = DID_NO_CONNECT << 16;
+			ccb->pcmd->status.combined = DID_NO_CONNECT << 16;
 			arcmsr_ccb_complete(ccb);
 			}
 			break;
@@ -1405,7 +1405,7 @@ static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
 
 		case ARCMSR_DEV_INIT_FAIL: {
 			acb->devstate[id][lun] = ARECA_RAID_GONE;
-			ccb->pcmd->result = DID_BAD_TARGET << 16;
+			ccb->pcmd->status.combined = DID_BAD_TARGET << 16;
 			arcmsr_ccb_complete(ccb);
 			}
 			break;
@@ -1426,7 +1426,7 @@ static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
 				, lun
 				, ccb->arcmsr_cdb.DeviceStatus);
 				acb->devstate[id][lun] = ARECA_RAID_GONE;
-				ccb->pcmd->result = DID_NO_CONNECT << 16;
+				ccb->pcmd->status.combined = DID_NO_CONNECT << 16;
 				arcmsr_ccb_complete(ccb);
 			break;
 		}
@@ -1439,7 +1439,7 @@ static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct Comma
 		if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
 			struct scsi_cmnd *abortcmd = pCCB->pcmd;
 			if (abortcmd) {
-				abortcmd->result |= DID_ABORT << 16;
+				abortcmd->status.combined |= DID_ABORT << 16;
 				arcmsr_ccb_complete(pCCB);
 				printk(KERN_NOTICE "arcmsr%d: pCCB ='0x%p' isr got aborted command \n",
 				acb->host->host_no, pCCB);
@@ -1594,7 +1594,7 @@ static void arcmsr_remove_scsi_devices(struct AdapterControlBlock *acb)
 	for (i = 0; i < acb->maxFreeCCB; i++) {
 		ccb = acb->pccb_pool[i];
 		if (ccb->startdone == ARCMSR_CCB_START) {
-			ccb->pcmd->result = DID_NO_CONNECT << 16;
+			ccb->pcmd->status.combined = DID_NO_CONNECT << 16;
 			arcmsr_pci_unmap_dma(ccb);
 			ccb->pcmd->scsi_done(ccb->pcmd);
 		}
@@ -1686,7 +1686,7 @@ static void arcmsr_remove(struct pci_dev *pdev)
 			struct CommandControlBlock *ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				ccb->startdone = ARCMSR_CCB_ABORTED;
-				ccb->pcmd->result = DID_ABORT << 16;
+				ccb->pcmd->status.combined = DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb);
 			}
 		}
@@ -3178,7 +3178,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		struct scatterlist *sg;
 
 		if (cmd->device->lun) {
-			cmd->result = (DID_TIME_OUT << 16);
+			cmd->status.combined = (DID_TIME_OUT << 16);
 			cmd->scsi_done(cmd);
 			return;
 		}
@@ -3209,7 +3209,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 	case WRITE_BUFFER:
 	case READ_BUFFER: {
 		if (arcmsr_iop_message_xfer(acb, cmd))
-			cmd->result = (DID_ERROR << 16);
+			cmd->status.combined = (DID_ERROR << 16);
 		cmd->scsi_done(cmd);
 	}
 	break;
@@ -3227,13 +3227,13 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
 	int target = cmd->device->id;
 
 	if (acb->acb_flags & ACB_F_ADAPTER_REMOVED) {
-		cmd->result = (DID_NO_CONNECT << 16);
+		cmd->status.combined = (DID_NO_CONNECT << 16);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
-	cmd->result = 0;
+	cmd->status.combined = 0;
 	if (target == 16) {
 		/* virtual device for iop message transfer */
 		arcmsr_handle_virtual_command(acb, cmd);
@@ -3243,7 +3243,7 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
 	if (!ccb)
 		return SCSI_MLQUEUE_HOST_BUSY;
 	if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {
-		cmd->result = (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);
+		cmd->status.combined = (DID_ERROR << 16) | SAM_STAT_RESERVATION_CONFLICT;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
@@ -3516,7 +3516,7 @@ static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
 					, ccb->pcmd->device->id
 					, (u32)ccb->pcmd->device->lun
 					, ccb);
-				ccb->pcmd->result = DID_ABORT << 16;
+				ccb->pcmd->status.combined = DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb);
 				continue;
 			}
@@ -3585,7 +3585,7 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 					,ccb->pcmd->device->id
 					,(u32)ccb->pcmd->device->lun
 					,ccb);
-				ccb->pcmd->result = DID_ABORT << 16;
+				ccb->pcmd->status.combined = DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb);
 				continue;
 			}
@@ -3647,7 +3647,7 @@ static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,
 					, pCCB->pcmd->device->id
 					, (u32)pCCB->pcmd->device->lun
 					, pCCB);
-				pCCB->pcmd->result = DID_ABORT << 16;
+				pCCB->pcmd->status.combined = DID_ABORT << 16;
 				arcmsr_ccb_complete(pCCB);
 				continue;
 			}
@@ -3722,7 +3722,7 @@ static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
 					, pCCB->pcmd->device->id
 					, (u32)pCCB->pcmd->device->lun
 					, pCCB);
-				pCCB->pcmd->result = DID_ABORT << 16;
+				pCCB->pcmd->status.combined = DID_ABORT << 16;
 				arcmsr_ccb_complete(pCCB);
 				continue;
 			}
@@ -3790,7 +3790,7 @@ static int arcmsr_hbaE_polling_ccbdone(struct AdapterControlBlock *acb,
 					, pCCB->pcmd->device->id
 					, (u32)pCCB->pcmd->device->lun
 					, pCCB);
-				pCCB->pcmd->result = DID_ABORT << 16;
+				pCCB->pcmd->status.combined = DID_ABORT << 16;
 				arcmsr_ccb_complete(pCCB);
 				continue;
 			}
