Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72042C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiBPVEm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiBPVEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:37 -0500
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFE22B1AA3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:19 -0800 (PST)
Received: by mail-pf1-f182.google.com with SMTP id i6so3170410pfc.9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pnNf2VjhuumTX82Rj4aqfhA6PYW6ngKJyQvWPbUR7rY=;
        b=X9/3AEBSD7R2AwHxykfHYCZdwIt6mgIRCux7VQw972sVhJqH/8wnhd8RIpncOMkmVi
         7adjbgDtWe0/P/W/GTtVS0aTb/yk7it3WsK0Bc0cMQ188nl7tbeAUpOxps6OHTK/xd/J
         /tcgeT3K9b4ZXCdoo9HwacdFLghnH9z4TKIgDzz4b2qO16y26gOi0GmmpAoa2B8165JU
         p37RuZDCCGLgHg7ny+rWcDpDAnWiMM0dKB+51+TvmjfrJ7hl+dv9OjaME24W8dsKOAG2
         PKat9lZxfAR8/qpfeYIB31xI60IEu3DYX42aZhdIzO/MKjRvvACZYqFhhLhxYn7mzMK1
         y48Q==
X-Gm-Message-State: AOAM531m1jY5++UXXMfor92QuBTnRe5bfM5nsyQj1h4hmVuschdwxOL2
        VgL31eGPgQaWclz6SoeLBr4=
X-Google-Smtp-Source: ABdhPJykOhUvH73HHkwelj7BhJ1KvFwv/5Fm8LhPPaZ5qSuHXJ8oH+OE32sp4ooitmKnAOeA3eeVeg==
X-Received: by 2002:a62:8c8f:0:b0:4cf:4c5:b2ad with SMTP id m137-20020a628c8f000000b004cf04c5b2admr777340pfd.71.1645045458780;
        Wed, 16 Feb 2022 13:04:18 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:04:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ondrej Zary <linux@zary.sk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 47/50] scsi: wd719x: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:30 -0800
Message-Id: <20220216210233.28774-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the DMA handle into the per-command private data instead of using the
SCSI pointer from struct scsi_cmnd. This patch prepares for removal of the
SCSI pointer from struct scsi_cmnd.

Cc: Ondrej Zary <linux@zary.sk>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/wd719x.c | 12 ++++++------
 drivers/scsi/wd719x.h |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 1a7947554581..f341b79d8036 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -196,7 +196,7 @@ static void wd719x_finish_cmd(struct wd719x_scb *scb, int result)
 	dma_unmap_single(&wd->pdev->dev, scb->phys,
 			sizeof(struct wd719x_scb), DMA_BIDIRECTIONAL);
 	scsi_dma_unmap(cmd);
-	dma_unmap_single(&wd->pdev->dev, cmd->SCp.dma_handle,
+	dma_unmap_single(&wd->pdev->dev, scb->dma_handle,
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
 	cmd->result = result << 16;
@@ -229,11 +229,11 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	/* map sense buffer */
 	scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
-	cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
-			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&wd->pdev->dev, cmd->SCp.dma_handle))
+	scb->dma_handle = dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
+			       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&wd->pdev->dev, scb->dma_handle))
 		goto out_unmap_scb;
-	scb->sense_buf = cpu_to_le32(cmd->SCp.dma_handle);
+	scb->sense_buf = cpu_to_le32(scb->dma_handle);
 
 	/* request autosense */
 	scb->SCB_options |= WD719X_SCB_FLAGS_AUTO_REQUEST_SENSE;
@@ -288,7 +288,7 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	return 0;
 
 out_unmap_sense:
-	dma_unmap_single(&wd->pdev->dev, cmd->SCp.dma_handle,
+	dma_unmap_single(&wd->pdev->dev, scb->dma_handle,
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 out_unmap_scb:
 	dma_unmap_single(&wd->pdev->dev, scb->phys, sizeof(*scb),
diff --git a/drivers/scsi/wd719x.h b/drivers/scsi/wd719x.h
index abaabd419a54..966ab0fb4621 100644
--- a/drivers/scsi/wd719x.h
+++ b/drivers/scsi/wd719x.h
@@ -56,6 +56,7 @@ struct wd719x_scb {
 	u8 flags[2];	/* 62-63 SCB specific flags (local to each thread) */
 	/* everything below is for driver use (not used by card) */
 	dma_addr_t phys;	/* bus address of the SCB */
+	dma_addr_t dma_handle;
 	struct scsi_cmnd *cmd;	/* a copy of the pointer we were passed */
 	struct list_head list;
 	struct wd719x_sglist sg_list[WD719X_SG] __aligned(8); /* SG list */
