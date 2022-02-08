Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF5CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384341AbiBHR0y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbiBHR0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:52 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE4BC0613C9
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:40 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id c3so14407647pls.5
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cg4Ov2kCvPOcNYccmzmYB6WBfgOawCf+kij7byZpP64=;
        b=DQ0m2IJpXJRMK3UBGvHo+0i5Va5TJDcwc3nkYYYIrPGQEw6dlsrPEUf6YBAgup7/xd
         ndEtJVGviK8BZZeT2BE2FrAOLpSTW05BVs9orpJCf9ePkuDd06IZtP8yg+R1JI9uSfSo
         mAUaGGRIfvJtb5SzxGKkJ1rDz3MGiocMNqUNDwD14ONQClbFnFjdpHKL6L2CynVCp43K
         PcZPRG92v5ChoHmludA+uoo/Pr3IAfm2CGPWkVrCfMs6VELaZ+W9riTLvUQ752dijDfb
         mT5v+iONUN17rbOX0IQJXamwCz442zI1tp5KSeu1AY6oOz1iEfeF/SBfdfKOlRK9ZEya
         B7wg==
X-Gm-Message-State: AOAM530ZqolQnFrVdYB2PDDQtjCJlM47CO3MRtv1l4hwNrGplD3v/jWh
        BOtPFUUnBvrZ8/u472ZYPy4=
X-Google-Smtp-Source: ABdhPJy0DQ5SchUOcvva9rBIU3QMA3D2nGpn6nk5vcecmgZM1UgBMCLw15PHS3WBCrnjVt1sKIAYwQ==
X-Received: by 2002:a17:90b:3810:: with SMTP id mq16mr1229147pjb.26.1644341199978;
        Tue, 08 Feb 2022 09:26:39 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:39 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 31/44] mvumi: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:25:01 -0800
Message-Id: <20220208172514.3481-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
