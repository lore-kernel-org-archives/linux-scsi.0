Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DF0C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A45C261363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhDTALP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:15 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:41614 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhDTAKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:54 -0400
Received: by mail-pg1-f178.google.com with SMTP id f29so25378093pgm.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRZJXMegLHG9AXGLGKeqwxqu6K7SuWdBqNUfOWEMv7E=;
        b=ZJe/iz5ld/n4lwn62nDtJJUTuW89zqkLbg5qH3FZRwRYVM1SQS31yyuqY5QG98LjZ0
         UerXuI//BjDjUh7BlewmjUCKa2uz4UsTtyZKfwft1mn4Hn3znm8JFE+TlDIvIpI0mlyd
         U0AY16q0AlaT+hr5qFNoqayrGrRjev9JO4/CMZK9u2RVgqNeTMn+QRps5Y9+28gCegFg
         truYpCkg2ntOYKOzGiq8az++22eG4lc2eibsBx/vcLc4qV3F4MjkgcX6Ko1CG4f/1mPJ
         yXyuicuJ9mr8Ww/Upo0OwVeZEVzVuYuYVIzghnT202Nf5aba/ZupPhpQpt+ImVPk2nyD
         povA==
X-Gm-Message-State: AOAM530YHkDDDUk7Ze2jMd3+EolGOkqNHMdcvYVHLk1NHfSXpvfKGg7S
        jNLrmKyFBpmoZ6wCcmqpCnw=
X-Google-Smtp-Source: ABdhPJxffSfXkFCkX0NNx6zi+EVek2SmcDPJY/kuMP6Rd0jR6lr/so+7xD7vH5/MNzWcmX2QyIWO2A==
X-Received: by 2002:a63:ab05:: with SMTP id p5mr14214318pgf.149.1618877422987;
        Mon, 19 Apr 2021 17:10:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 079/117] pmcraid: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:07 -0700
Message-Id: <20210420000845.25873-80-bvanassche@acm.org>
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
 drivers/scsi/pmcraid.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bffd9a9349e7..2f8fb2717696 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -822,7 +822,7 @@ static void pmcraid_erp_done(struct pmcraid_cmd *cmd)
 	u32 ioasc = le32_to_cpu(cmd->ioa_cb->ioasa.ioasc);
 
 	if (PMCRAID_IOASC_SENSE_KEY(ioasc) > 0) {
-		scsi_cmd->result |= (DID_ERROR << 16);
+		scsi_cmd->status.combined |= (DID_ERROR << 16);
 		scmd_printk(KERN_INFO, scsi_cmd,
 			    "command CDB[0] = %x failed with IOASC: 0x%08X\n",
 			    cmd->ioa_cb->ioarcb.cdb[0], ioasc);
@@ -2008,7 +2008,7 @@ static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 			struct scsi_cmnd *scsi_cmd = cmd->scsi_cmd;
 			__le32 resp = cmd->ioa_cb->ioarcb.response_handle;
 
-			scsi_cmd->result |= DID_ERROR << 16;
+			scsi_cmd->status.combined |= DID_ERROR << 16;
 
 			scsi_dma_unmap(scsi_cmd);
 			pmcraid_return_cmd(cmd);
@@ -2016,7 +2016,7 @@ static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 			pmcraid_info("failing(%d) CDB[0] = %x result: %x\n",
 				     le32_to_cpu(resp) >> 2,
 				     cmd->ioa_cb->ioarcb.cdb[0],
-				     scsi_cmd->result);
+				     scsi_cmd->status.combined);
 			scsi_cmd->scsi_done(scsi_cmd);
 		} else if (cmd->cmd_done == pmcraid_internal_done ||
 			   cmd->cmd_done == pmcraid_erp_done) {
@@ -2510,7 +2510,7 @@ static void pmcraid_frame_auto_sense(struct pmcraid_cmd *cmd)
 	u32 failing_lba = 0;
 
 	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
-	cmd->scsi_cmd->result = SAM_STAT_CHECK_CONDITION;
+	cmd->scsi_cmd->status.combined = SAM_STAT_CHECK_CONDITION;
 
 	if (RES_IS_VSET(res->cfg_entry) &&
 	    ioasc == PMCRAID_IOASC_ME_READ_ERROR_NO_REALLOC &&
@@ -2605,21 +2605,21 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 	switch (masked_ioasc) {
 
 	case PMCRAID_IOASC_AC_TERMINATED_BY_HOST:
-		scsi_cmd->result |= (DID_ABORT << 16);
+		scsi_cmd->status.combined |= (DID_ABORT << 16);
 		break;
 
 	case PMCRAID_IOASC_IR_INVALID_RESOURCE_HANDLE:
 	case PMCRAID_IOASC_HW_CANNOT_COMMUNICATE:
-		scsi_cmd->result |= (DID_NO_CONNECT << 16);
+		scsi_cmd->status.combined |= (DID_NO_CONNECT << 16);
 		break;
 
 	case PMCRAID_IOASC_NR_SYNC_REQUIRED:
 		res->sync_reqd = 1;
-		scsi_cmd->result |= (DID_IMM_RETRY << 16);
+		scsi_cmd->status.combined |= (DID_IMM_RETRY << 16);
 		break;
 
 	case PMCRAID_IOASC_ME_READ_ERROR_NO_REALLOC:
-		scsi_cmd->result |= (DID_PASSTHROUGH << 16);
+		scsi_cmd->status.combined |= (DID_PASSTHROUGH << 16);
 		break;
 
 	case PMCRAID_IOASC_UA_BUS_WAS_RESET:
@@ -2627,11 +2627,11 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 		if (!res->reset_progress)
 			scsi_report_bus_reset(pinstance->host,
 					      scsi_cmd->device->channel);
-		scsi_cmd->result |= (DID_ERROR << 16);
+		scsi_cmd->status.combined |= (DID_ERROR << 16);
 		break;
 
 	case PMCRAID_IOASC_HW_DEVICE_BUS_STATUS_ERROR:
-		scsi_cmd->result |= PMCRAID_IOASC_SENSE_STATUS(ioasc);
+		scsi_cmd->status.combined |= PMCRAID_IOASC_SENSE_STATUS(ioasc);
 		res->sync_reqd = 1;
 
 		/* if check_condition is not active return with error otherwise
@@ -2670,7 +2670,7 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 
 	default:
 		if (PMCRAID_IOASC_SENSE_KEY(ioasc) > RECOVERED_ERROR)
-			scsi_cmd->result |= (DID_ERROR << 16);
+			scsi_cmd->status.combined |= (DID_ERROR << 16);
 		break;
 	}
 	return 0;
@@ -2807,7 +2807,7 @@ static int _pmcraid_io_done(struct pmcraid_cmd *cmd, int reslen, int ioasc)
 	pmcraid_info("response(%d) CDB[0] = %x ioasc:result: %x:%x\n",
 		le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle) >> 2,
 		cmd->ioa_cb->ioarcb.cdb[0],
-		ioasc, scsi_cmd->result);
+		ioasc, scsi_cmd->status.combined);
 
 	if (PMCRAID_IOASC_SENSE_KEY(ioasc) != 0)
 		rc = pmcraid_error_handler(cmd);
@@ -3330,14 +3330,14 @@ static int pmcraid_queuecommand_lck(
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
 	scsi_cmd->scsi_done = done;
 	res = scsi_cmd->device->hostdata;
-	scsi_cmd->result = (DID_OK << 16);
+	scsi_cmd->status.combined = (DID_OK << 16);
 
 	/* if adapter is marked as dead, set result to DID_NO_CONNECT complete
 	 * the command
 	 */
 	if (pinstance->ioa_state == IOA_STATE_DEAD) {
 		pmcraid_info("IOA is dead, but queuecommand is scheduled\n");
-		scsi_cmd->result = (DID_NO_CONNECT << 16);
+		scsi_cmd->status.combined = (DID_NO_CONNECT << 16);
 		scsi_cmd->scsi_done(scsi_cmd);
 		return 0;
 	}
