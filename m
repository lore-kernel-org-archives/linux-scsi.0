Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92008C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7551C613AF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhDTAKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:46 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:40925 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbhDTAKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:31 -0400
Received: by mail-pl1-f178.google.com with SMTP id 20so14724029pll.7
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdAZgY7tEc4FhpnmxMoXKlwIltYlXpVAr9VgyS6ySKY=;
        b=q5hrBSG5IAriCT8qqgDsKmB2tGtwbut1NFcKdCT+5FNniHNJuxvo/m5SGhx0tabg//
         pSEq5CI5XQxNivC7P/bM7ROLuCqlT0B1uCsjEEPMFS7UgnqbwE0FoaDOlEDAOcBZXNn0
         6NDIsbAsClgRD7cYtL4ttcy3kansVQESvaHfAOEotMJS97i7w8K7lnGMCW9/rcElIo15
         kOkZwmjuHQ09nIYjnwpM1URFTm2NIi//rW84E9xfreD9FyMXyx4S8CfGbaiPYOgqMyXi
         LgZNZIb77fQQCkf2f3k3mxcKf+MjUs104CAf1t67OZdHMCOrfRpyVsRsihtkzYmLMALE
         IJBA==
X-Gm-Message-State: AOAM533kwQix/ZkkkEM0h2LzTsHwprZPD5wHlUKztcClJPpeP/ygoySm
        xFm3tNUxtgURLQYQWxxiI/k=
X-Google-Smtp-Source: ABdhPJwtdqiI768dLMV5oRfQjcV+0x9lldKCnXirXFoCtyK1g+9T0aflNyhu/Hl/wOh1DsfxwXb22g==
X-Received: by 2002:a17:902:c407:b029:ec:aeb7:667f with SMTP id k7-20020a170902c407b02900ecaeb7667fmr4663846plk.9.1618877401097;
        Mon, 19 Apr 2021 17:10:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>
Subject: [PATCH 060/117] ipr: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:48 -0700
Message-Id: <20210420000845.25873-61-bvanassche@acm.org>
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

Cc: Brian King <brking@us.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 30c30a1db5b1..00b4688d3107 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -863,7 +863,7 @@ static void __ipr_scsi_eh_done(struct ipr_cmnd *ipr_cmd)
 {
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 
-	scsi_cmd->result |= (DID_ERROR << 16);
+	scsi_cmd->status.combined |= (DID_ERROR << 16);
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
 	scsi_cmd->scsi_done(scsi_cmd);
@@ -6051,7 +6051,7 @@ static void __ipr_erp_done(struct ipr_cmnd *ipr_cmd)
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 
 	if (IPR_IOASC_SENSE_KEY(ioasc) > 0) {
-		scsi_cmd->result |= (DID_ERROR << 16);
+		scsi_cmd->status.combined |= (DID_ERROR << 16);
 		scmd_printk(KERN_ERR, scsi_cmd,
 			    "Request Sense failed with IOASC: 0x%08X\n", ioasc);
 	} else {
@@ -6301,7 +6301,7 @@ static void ipr_gen_sense(struct ipr_cmnd *ipr_cmd)
 	if (ioasc >= IPR_FIRST_DRIVER_IOASC)
 		return;
 
-	ipr_cmd->scsi_cmd->result = SAM_STAT_CHECK_CONDITION;
+	ipr_cmd->scsi_cmd->status.combined = SAM_STAT_CHECK_CONDITION;
 
 	if (ipr_is_vset_device(res) &&
 	    ioasc == IPR_IOASC_MED_DO_NOT_REALLOC &&
@@ -6432,23 +6432,23 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 	switch (masked_ioasc) {
 	case IPR_IOASC_ABORTED_CMD_TERM_BY_HOST:
 		if (ipr_is_naca_model(res))
-			scsi_cmd->result |= (DID_ABORT << 16);
+			scsi_cmd->status.combined |= (DID_ABORT << 16);
 		else
-			scsi_cmd->result |= (DID_IMM_RETRY << 16);
+			scsi_cmd->status.combined |= (DID_IMM_RETRY << 16);
 		break;
 	case IPR_IOASC_IR_RESOURCE_HANDLE:
 	case IPR_IOASC_IR_NO_CMDS_TO_2ND_IOA:
-		scsi_cmd->result |= (DID_NO_CONNECT << 16);
+		scsi_cmd->status.combined |= (DID_NO_CONNECT << 16);
 		break;
 	case IPR_IOASC_HW_SEL_TIMEOUT:
-		scsi_cmd->result |= (DID_NO_CONNECT << 16);
+		scsi_cmd->status.combined |= (DID_NO_CONNECT << 16);
 		if (!ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
 		break;
 	case IPR_IOASC_SYNC_REQUIRED:
 		if (!res->in_erp)
 			res->needs_sync_complete = 1;
-		scsi_cmd->result |= (DID_IMM_RETRY << 16);
+		scsi_cmd->status.combined |= (DID_IMM_RETRY << 16);
 		break;
 	case IPR_IOASC_MED_DO_NOT_REALLOC: /* prevent retries */
 	case IPR_IOASA_IR_DUAL_IOA_DISABLED:
@@ -6456,8 +6456,8 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 		 * exception: do not set DID_PASSTHROUGH on CHECK CONDITION
 		 * so SCSI mid-layer and upper layers handle it accordingly.
 		 */
-		if (scsi_cmd->result != SAM_STAT_CHECK_CONDITION)
-			scsi_cmd->result |= (DID_PASSTHROUGH << 16);
+		if (scsi_cmd->status.combined != SAM_STAT_CHECK_CONDITION)
+			scsi_cmd->status.combined |= (DID_PASSTHROUGH << 16);
 		break;
 	case IPR_IOASC_BUS_WAS_RESET:
 	case IPR_IOASC_BUS_WAS_RESET_BY_OTHER:
@@ -6467,12 +6467,12 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 		 */
 		if (!res->resetting_device)
 			scsi_report_bus_reset(ioa_cfg->host, scsi_cmd->device->channel);
-		scsi_cmd->result |= (DID_ERROR << 16);
+		scsi_cmd->status.combined |= (DID_ERROR << 16);
 		if (!ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
 		break;
 	case IPR_IOASC_HW_DEV_BUS_STATUS:
-		scsi_cmd->result |= IPR_IOASC_SENSE_STATUS(ioasc);
+		scsi_cmd->status.combined |= IPR_IOASC_SENSE_STATUS(ioasc);
 		if (IPR_IOASC_SENSE_STATUS(ioasc) == SAM_STAT_CHECK_CONDITION) {
 			if (!ipr_get_autosense(ipr_cmd)) {
 				if (!ipr_is_naca_model(res)) {
@@ -6489,13 +6489,13 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 	case IPR_IOASC_IR_NON_OPTIMIZED:
 		if (res->raw_mode) {
 			res->raw_mode = 0;
-			scsi_cmd->result |= (DID_IMM_RETRY << 16);
+			scsi_cmd->status.combined |= (DID_IMM_RETRY << 16);
 		} else
-			scsi_cmd->result |= (DID_ERROR << 16);
+			scsi_cmd->status.combined |= (DID_ERROR << 16);
 		break;
 	default:
 		if (IPR_IOASC_SENSE_KEY(ioasc) > RECOVERED_ERROR)
-			scsi_cmd->result |= (DID_ERROR << 16);
+			scsi_cmd->status.combined |= (DID_ERROR << 16);
 		if (!ipr_is_vset_device(res) && !ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
 		break;
@@ -6571,7 +6571,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 
 	ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 
-	scsi_cmd->result = (DID_OK << 16);
+	scsi_cmd->status.combined = (DID_OK << 16);
 	res = scsi_cmd->device->hostdata;
 
 	if (ipr_is_gata(res) && res->sata_port) {
@@ -6684,7 +6684,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 err_nodev:
 	spin_lock_irqsave(hrrq->lock, hrrq_flags);
 	memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	scsi_cmd->result = (DID_NO_CONNECT << 16);
+	scsi_cmd->status.combined = (DID_NO_CONNECT << 16);
 	scsi_cmd->scsi_done(scsi_cmd);
 	spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
 	return 0;
