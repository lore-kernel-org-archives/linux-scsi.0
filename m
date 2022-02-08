Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17307C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384253AbiBHR1c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384349AbiBHR1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:27:15 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE914C0612AA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:59 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id y18so4795118plb.11
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H7nWqFmexBN4cNIn+3RDvgZk5artkKMai859h0HsZ7A=;
        b=E9HRClCKFb03YupWLla91Sjp5YbXHfC/6lsaF4fWTL//oB1vj+x22P2z0DTgxGlaxz
         neBidZXhck2KoYOVTY7x0QvLztvGL+6OmMwLtbOWvWZcNuS+qwHt0Kd0PYBiJ6tng0ng
         uvMdIWTvYjOtN9dh4ulUZ9vulDf01R8rOOkYtD+6Ozlly2oZi7WLUmBcVRPanQM/xQu0
         0+4qrWDPOl0FKkowhZ1OZAeEMny0xZtu+73fBNngee61jbYTGBnw7i3mIoRB85ZSw0Hh
         eW6mUwgBDiyYeQjAkHBJ9qgFN6d4Jb+cTY0XwSimk20xXGWK3bokXCn4KPnR9mFk1o8S
         h2VQ==
X-Gm-Message-State: AOAM531Z41gNfC8SlLnLkWNVVzwV1K/LvH834ZSyEd+zwLOqFDydd2bJ
        kxQvAk4cczcPPMyT+g/DamA=
X-Google-Smtp-Source: ABdhPJwuy1Dmhkudc8o7SFOe+LbAmcOr/zz3UQwTMsUcrqUU6yZOb/hqMBTtpPmYxV1z95NABltgxA==
X-Received: by 2002:a17:902:dac1:: with SMTP id q1mr249489plx.164.1644341218913;
        Tue, 08 Feb 2022 09:26:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ondrej Zary <linux@zary.sk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 41/44] wd719x: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:25:11 -0800
Message-Id: <20220208172514.3481-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
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
