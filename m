Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71276C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiBRTxq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiBRTxc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:32 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE07294105
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:13 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id s16so8726239pgs.13
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pnNf2VjhuumTX82Rj4aqfhA6PYW6ngKJyQvWPbUR7rY=;
        b=wC1pQpbSVYZ40BdMV+v+pOMaBaWOfsSwxokGzGO8XO3bUx6o2Tjp0NZgJd9ouuZrvm
         lz/kD2WnBqSNv3nAIHunBBs5ssG986dpqOrIaaafL/L9suCoe0+/UNMq42PMAS8BYKxD
         ydro4RPwzy+bFayeGypOc/lqzWlVEoW1ffo7k3S+2LCDSaTE0k47/FsB/F4B5yYBaRjJ
         LODMeCIZo1h+gMoB+XWYOKIJ7xQe/FlBDsQt7gq/JalK5xOcLwovcFwaQJAHi5pANt1U
         Spjn2/tVO5uxN4mLoB4GTrIqBcZiKONhqlzCZZ/JRjkBFe2+wdVzP8Elxkj6jtE3jap1
         jFYw==
X-Gm-Message-State: AOAM530qj1h5PRDaimnXPFGALlFMCipPh+ga4+DaSP1kYoDUl66Cxi8s
        FSbFfj1/uSBG8lccA5b+tO8=
X-Google-Smtp-Source: ABdhPJxHhA6kb9Wpzk1JVuuQtuiBGgzEvsMeBrZQrIdA7roL2knxqTqDm5rUW2cEdNji1/gY58ELrA==
X-Received: by 2002:a63:a1c:0:b0:341:760a:1b03 with SMTP id 28-20020a630a1c000000b00341760a1b03mr7505218pgk.484.1645213992685;
        Fri, 18 Feb 2022 11:53:12 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:53:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ondrej Zary <linux@zary.sk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 46/49] scsi: wd719x: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:51:14 -0800
Message-Id: <20220218195117.25689-47-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
