Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C61C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiA1WWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:16 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:38884 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351091AbiA1WV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:58 -0500
Received: by mail-pg1-f169.google.com with SMTP id q75so6454644pgq.5
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QChkotYHIfmMO6ya1WPSvStpawxIaayg7tfOE7syp+8=;
        b=XTvZfAHWpUPkFZGToTlak1/uPUjoZewLORqCocUZ7UExwX05j6QptPXaL0tQ1DpwPd
         RKpPVjW4UafvBBEaiV6rwGMIzH9TbBBqpvPyYqxab5KccZClMyJcl47iYtnY5qCUNZck
         TnyV1j9ZILLTWB6ZLVk5+m5l3+Q9T7YXW1prrhHD372FEMg1LiuOLMefDPn92hGX4Mxo
         F8WLG3nq2H0z0/wcIaMqRY6LbDyOD2ATEoKBz1IJuxSeEXoSTXDmJuWclDqryowVXAk9
         jFbcyrozrPSyEerQ4kSlX1xogEEpSau0BZ2lRKr1HWRXdNM3t67SUEsDljqv9deQr0Lq
         BQ/Q==
X-Gm-Message-State: AOAM533dlVMM26kJ9ARJxFFgHHgCOy4Ki0N8QHJ9hMz79d/iMoNPv7Sc
        5yydJFPn31ozvpcVSWRtapCW92artq4+MA==
X-Google-Smtp-Source: ABdhPJx2YteUunO2uGIfVGsZ+snjIgPrxkvyUdzb/5k3QNoyA2tLyV5rr3fvdjdWaEHs1RynJWCGPQ==
X-Received: by 2002:a63:1b65:: with SMTP id b37mr8301610pgm.173.1643408516392;
        Fri, 28 Jan 2022 14:21:56 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ondrej Zary <linux@zary.sk>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 41/44] wd719x: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:19:06 -0800
Message-Id: <20220128221909.8141-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
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
