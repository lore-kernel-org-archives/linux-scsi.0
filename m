Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46371C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C0996109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhDTALB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:01 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:34620 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbhDTAKo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:44 -0400
Received: by mail-pj1-f47.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so375984pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4piVXOunuMMGBrL3eyUsXOizM8pUR3l00+4uqZlvwg=;
        b=IowOJOQ87vEgGDlQoHslKr+zQW2MO4JUMsR5GPIN0eHbM1Ikx4OitefloB4VeOWoAZ
         CErWbXd8yDKeOuWdmTpZ9EoYzqN0IGyPIFUmJ/NwE+JhJjs6z+TLeAkqz4P5i7TBYq10
         AJDs9708lRxdGQEiBi4AK2/+zMicaWi4J2HnB5j9SqTY6GxWaYwFjlGsoJzXlbiYv1wN
         8BhdffbO6TkRvZWsUBT48rYQOqVMD3UG5oco0xJdWvFsgOK1OQicq7hYSxx4JNB6mSkU
         PDHE929Lhr0FtUjt5a2pdqrO/7+JlmNPqQMw3RUvBP/yhErxzZv7i4EMLF2xmxMAcuEZ
         l8WQ==
X-Gm-Message-State: AOAM530yRo4oGCLXToS+dzeiBCAGpSlu9tU82pKjuzia9FfEhbvP4QsH
        smSWE4g++r0GhTBT+hIxB3g=
X-Google-Smtp-Source: ABdhPJzbtHu7i3TTCBbpqIFh0N2d76P0ZWZwmICUZPf49Dwpwf6sEXPcVOT12dbV5B1h5SZTqAHkag==
X-Received: by 2002:a17:90a:e00f:: with SMTP id u15mr1781219pjy.26.1618877413754;
        Mon, 19 Apr 2021 17:10:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 071/117] mvumi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:59 -0700
Message-Id: <20210420000845.25873-72-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9d5743627604..e9f2d81404cf 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1303,25 +1303,25 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 	struct scsi_cmnd *scmd = cmd->scmd;
 
 	cmd->scmd->SCp.ptr = NULL;
-	scmd->result = ob_frame->req_status;
+	scmd->status.combined = ob_frame->req_status;
 
 	switch (ob_frame->req_status) {
 	case SAM_STAT_GOOD:
-		scmd->result |= DID_OK << 16;
+		scmd->status.combined |= DID_OK << 16;
 		break;
 	case SAM_STAT_BUSY:
-		scmd->result |= DID_BUS_BUSY << 16;
+		scmd->status.combined |= DID_BUS_BUSY << 16;
 		break;
 	case SAM_STAT_CHECK_CONDITION:
-		scmd->result |= (DID_OK << 16);
+		scmd->status.combined |= (DID_OK << 16);
 		if (ob_frame->rsp_flag & CL_RSP_FLAG_SENSEDATA) {
 			memcpy(cmd->scmd->sense_buffer, ob_frame->payload,
 				sizeof(struct mvumi_sense_data));
-			scmd->result |=  (DRIVER_SENSE << 24);
+			scmd->status.combined |=  (DRIVER_SENSE << 24);
 		}
 		break;
 	default:
-		scmd->result |= (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+		scmd->status.combined |= (DRIVER_INVALID << 24) | (DID_ABORT << 16);
 		break;
 	}
 
@@ -2068,7 +2068,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	return 0;
 
 error:
-	scmd->result = (DID_OK << 16) | (DRIVER_SENSE << 24) |
+	scmd->status.combined = (DID_OK << 16) | (DRIVER_SENSE << 24) |
 		SAM_STAT_CHECK_CONDITION;
 	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x24,
 									0);
@@ -2090,7 +2090,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
 	spin_lock_irqsave(shost->host_lock, irq_flags);
 
 	mhba = (struct mvumi_hba *) shost->hostdata;
-	scmd->result = 0;
+	scmd->status.combined = 0;
 	cmd = mvumi_get_cmd(mhba);
 	if (unlikely(!cmd)) {
 		spin_unlock_irqrestore(shost->host_lock, irq_flags);
@@ -2131,7 +2131,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 	else
 		atomic_dec(&mhba->fw_outstanding);
 
-	scmd->result = (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+	scmd->status.combined = (DRIVER_INVALID << 24) | (DID_ABORT << 16);
 	scmd->SCp.ptr = NULL;
 	if (scsi_bufflen(scmd)) {
 		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
