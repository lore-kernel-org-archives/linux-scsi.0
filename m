Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE9DC2D0D2
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0348206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfLXWC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 17:02:59 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38869 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfLXWC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 17:02:59 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so10916039pgm.5
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 14:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cw38l09MEGCw1z1OCkPB/+1tRY7zZD7LW8gT4sveklE=;
        b=IdXJTePdxPk5KpTKzmGanQe3fpbBxZYLT0ubZwlj3yKnPbDW4TJvW2APAFdspR5+wf
         og7RfLKRIfoBJz8TPteYxkbmzY8M73MQ+ccdh1TRqeUtyMjLeIY1qKAe9osxbDtdRAWe
         TBliYFPDmuctBuczE3S8eaWb0NtLd7xYxzfFAQ7EocZRNYU8fzkDxNYsAowlCvVNXq4v
         EvkJx/CT15sioFBICsWMgL7qJKAiqtb3/aej2J6G9cVPxhcQSdeJNE5UqkbKWeWQK0CJ
         0p9X/IUjr9KDEv8HwPK/PEOgOeoRc+x2qh9Su/IEmZ67tPL/tr6eCuIxIjK4YUQwi54K
         TQQw==
X-Gm-Message-State: APjAAAUQBH4kaFIU1hSGpojZbTk3Yk96WxmxuJoojxkSKbISpJGnGPLc
        CS9R8raIDGRMqisJMIKKtbQ=
X-Google-Smtp-Source: APXvYqwxrcwBFT56cBCqQpZHQpJ8vWcRuSaGgCDCdW5CJ8FSjcvVZ+vCfHRs6HizN1jdV1oIUbSdMA==
X-Received: by 2002:a63:1c1d:: with SMTP id c29mr39703442pgc.14.1577224978874;
        Tue, 24 Dec 2019 14:02:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:1206:80fd:a97:a7d:f0c8])
        by smtp.gmail.com with ESMTPSA id m15sm26839779pgi.91.2019.12.24.14.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 14:02:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/6] ufs: Make ufshcd_add_command_trace() easier to read
Date:   Tue, 24 Dec 2019 14:02:44 -0800
Message-Id: <20191224220248.30138-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191224220248.30138-1-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the lrbp->cmd expression occurs multiple times, introduce a new
local variable to hold that pointer. This patch does not change any
functionality.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 48f2f94d51bc..acc84e964e8f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -327,27 +327,27 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 	u8 opcode = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct scsi_cmnd *cmd = lrbp->cmd;
 	int transfer_len = -1;
 
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
-		if (lrbp->cmd)
+		if (cmd)
 			ufshcd_add_cmd_upiu_trace(hba, tag, str);
 		return;
 	}
 
-	if (lrbp->cmd) { /* data phase exists */
+	if (cmd) { /* data phase exists */
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str);
-		opcode = (u8)(*lrbp->cmd->cmnd);
+		opcode = cmd->cmnd[0];
 		if ((opcode == READ_10) || (opcode == WRITE_10)) {
 			/*
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
-			if (lrbp->cmd->request && lrbp->cmd->request->bio)
-				lba =
-				  lrbp->cmd->request->bio->bi_iter.bi_sector;
+			if (cmd->request && cmd->request->bio)
+				lba = cmd->request->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 		}
