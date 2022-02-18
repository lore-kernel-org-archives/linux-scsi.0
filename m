Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90758C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbiBRTxf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbiBRTxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:25 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDF42944CC
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:52 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id f8so8738458pgc.8
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lHPHxz+0fUNEna5QsRJQJZs6i2Z4BPsfQCMVcXEb8iM=;
        b=HNjwlxG3g4Qo/hxO8PWCMJv668A4BN2B0KhVltnp1m6fgQdmE6wywe55drg7IpHODH
         01YloV/aSI74oXVASninTxUuFGWZXj4Q63h+yvq/YEvFyv4B2vM/MIqE+xbRjKzjsTmJ
         laDzPqRapr1YCCLP9tJR0Hryem9Vdq6G59UIxapWNNVcADeekrbYiazydUd7Fzz0AjSE
         CdT/v31rNIClKhGW11/zaT53dWs13Hd13GAB+pYIwkhfQ5WePKGH/M6KBFnPsAUi72pE
         btvbCb64vJysxJYyIyNmIIPj0arqha3/aUzHR/GaQP+nZw90vM8OmOeY0v8gqpDwKIBW
         BewA==
X-Gm-Message-State: AOAM5338PjzPKETEccFcIfZ6MUG7scB3YMoexDl83tEwLh03mlclE+ki
        BbY/KzPW5dUAnF9eX1mi+kA=
X-Google-Smtp-Source: ABdhPJzBf59HjAtoYgEhrWdQ9HOtd+U9rlJTTdXIt2uFYqGS0gl+Hc7pteG2lI60Y8QvufyebgP8LA==
X-Received: by 2002:a63:5208:0:b0:36c:4447:ab85 with SMTP id g8-20020a635208000000b0036c4447ab85mr7396625pgb.371.1645213972055;
        Fri, 18 Feb 2022 11:52:52 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 36/49] scsi: mvumi: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:51:04 -0800
Message-Id: <20220218195117.25689-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
