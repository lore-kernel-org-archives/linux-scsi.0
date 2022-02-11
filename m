Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641D9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243649AbiBKWej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352407AbiBKWeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:23 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61473D4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:21 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id n23so18717536pfo.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lHPHxz+0fUNEna5QsRJQJZs6i2Z4BPsfQCMVcXEb8iM=;
        b=fn8eODShMA0+I6BrMBiGzxcC/ThP7b8++S8nROfJMYcPcDs7jy/5CpIf/Y+a6x3j9N
         Ln6JUnC3vCXI8pIH/G63QSxIe7MCgZuGg1E0GymwiTb0Kf6Ipo+TGj320cemRrr4vjVH
         brhRoqnM1eZyV/Qnzvb0EETp/52OkrJP7E/lmdIa+Gu+MIC50N/GglijxHu6zNfOKvM9
         wPjn6ZAZpi15L3FnK21rc1Hsa6I7vpvCIeANXZ2OleHsfTSr3ctDSFZ3tryi90u7Hy8R
         GS/ksmzwtSdUEeFPg3cqpSPjbg3GbHrNXdWpzMSbcKXKw1rxwT1str3slLw7lJbNVfLp
         azWw==
X-Gm-Message-State: AOAM532Y8wLO0OzI0Guy9/rQuWi3X+TB3ZEjcvnQPata6Q+X/IXE4ICQ
        vX7SV8wSM+s7BZ0hYPyj9e4=
X-Google-Smtp-Source: ABdhPJxt1pCeOYPk3BtoeKiRZHcTBB3lpVSeuWYzFHbf6Pne2B1EB8YNL7lCnuGn5gjnMLrsy3wDqQ==
X-Received: by 2002:a05:6a00:1a10:: with SMTP id g16mr3766786pfv.51.1644618860759;
        Fri, 11 Feb 2022 14:34:20 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 35/48] scsi: mvumi: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:34 -0800
Message-Id: <20220211223247.14369-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvumi.c | 9 +++++----
 drivers/scsi/mvumi.h | 9 +++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 904de62c974c..05d3ce9b72db 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1302,7 +1302,7 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 {
 	struct scsi_cmnd *scmd = cmd->scmd;
 
-	cmd->scmd->SCp.ptr = NULL;
+	mvumi_priv(cmd->scmd)->cmd_priv = NULL;
 	scmd->result = ob_frame->req_status;
 
 	switch (ob_frame->req_status) {
@@ -2097,7 +2097,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
 		goto out_return_cmd;
 
 	cmd->scmd = scmd;
-	scmd->SCp.ptr = (char *) cmd;
+	mvumi_priv(scmd)->cmd_priv = cmd;
 	mhba->instancet->fire_cmd(mhba, cmd);
 	spin_unlock_irqrestore(shost->host_lock, irq_flags);
 	return 0;
@@ -2111,7 +2111,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
 
 static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 {
-	struct mvumi_cmd *cmd = (struct mvumi_cmd *) scmd->SCp.ptr;
+	struct mvumi_cmd *cmd = mvumi_priv(scmd)->cmd_priv;
 	struct Scsi_Host *host = scmd->device->host;
 	struct mvumi_hba *mhba = shost_priv(host);
 	unsigned long flags;
@@ -2128,7 +2128,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 		atomic_dec(&mhba->fw_outstanding);
 
 	scmd->result = (DID_ABORT << 16);
-	scmd->SCp.ptr = NULL;
+	mvumi_priv(scmd)->cmd_priv = NULL;
 	if (scsi_bufflen(scmd)) {
 		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
 			     scsi_sg_count(scmd),
@@ -2179,6 +2179,7 @@ static struct scsi_host_template mvumi_template = {
 	.bios_param = mvumi_bios_param,
 	.dma_boundary = PAGE_SIZE - 1,
 	.this_id = -1,
+	.cmd_size = sizeof(struct mvumi_cmd_priv),
 };
 
 static int mvumi_cfg_hw_reg(struct mvumi_hba *mhba)
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index 60d5691fc4ab..a88c58787b68 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -254,6 +254,15 @@ struct mvumi_cmd {
 	unsigned char cmd_status;
 };
 
+struct mvumi_cmd_priv {
+	struct mvumi_cmd *cmd_priv;
+};
+
+static inline struct mvumi_cmd_priv *mvumi_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 /*
  * the function type of the in bound frame
  */
