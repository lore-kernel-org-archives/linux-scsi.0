Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1072AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384257AbiBHR02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384320AbiBHR0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:24 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4745DC061578
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:24 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id b3so1555216pfg.7
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9fEis8oNULSoPzqZCmLsqz947RY/IWVM7TI0Dij2tEg=;
        b=1UDiAPOiwITiazHGqMMOh4w//alvYillNdmZpe3ZyKTGtynSs3BEIec7YoLs6I7h63
         igyV0WyDr9/Vqz29zhZM60YL2u4nWpVULn1dtq0TlIwK5H+6yTDtVHZOYbMCHN+o3sD/
         Pa5ioIJR7UBAN5iFEeY9itYtlniSF/ILgy+g4hi4Ubm1zBeUn4FSGNfW2N5UpzsL5Jjt
         yhhuVtaMMB/qW6VOaZWO55/7i/cg7i5oNEXYs2MyKWopKk2Wa6eRa9PUPZCQruBKFVYb
         R1jIn07E4HF5PMaZ43/UHtlJ1x1vHrphvvj72MSzKSI1rSJIpKzLCqAKRCxFezQJhon7
         eYEw==
X-Gm-Message-State: AOAM530wnWqelSVKmwe88t1GuiV+6iWgOjhQ4wu6gD7JwXtJJTInBGP1
        esD7QyUsED8Xr9k+kTZo1j0=
X-Google-Smtp-Source: ABdhPJyUj2P89BVTc17152waGTjZKPjGGKQRqCOzqZGzQPvSDDWedw/Xjs4bXS2SisiGjYFAcRa7GQ==
X-Received: by 2002:a65:6182:: with SMTP id c2mr4357098pgv.95.1644341183733;
        Tue, 08 Feb 2022 09:26:23 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 23/44] initio: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:24:53 -0800
Message-Id: <20220208172514.3481-24-bvanassche@acm.org>
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
 drivers/scsi/initio.c | 14 ++++++++------
 drivers/scsi/initio.h |  9 +++++++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 5f96ac47d7fd..f585d6e5fab9 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2553,7 +2553,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 				  SENSE_SIZE, DMA_FROM_DEVICE);
 	cblk->senseptr = (u32)dma_addr;
 	cblk->senselen = SENSE_SIZE;
-	cmnd->SCp.ptr = (char *)(unsigned long)dma_addr;
+	initio_priv(cmnd)->sense_dma_addr = dma_addr;
 	cblk->cdblen = cmnd->cmd_len;
 
 	/* Clear the returned status */
@@ -2577,7 +2577,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 					  sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
 					  DMA_BIDIRECTIONAL);
 		cblk->bufptr = (u32)dma_addr;
-		cmnd->SCp.dma_handle = dma_addr;
+		initio_priv(cmnd)->sglist_dma_addr = dma_addr;
 
 		cblk->sglen = nseg;
 
@@ -2704,16 +2704,17 @@ static int i91u_biosparam(struct scsi_device *sdev, struct block_device *dev,
 static void i91u_unmap_scb(struct pci_dev *pci_dev, struct scsi_cmnd *cmnd)
 {
 	/* auto sense buffer */
-	if (cmnd->SCp.ptr) {
+	if (initio_priv(cmnd)->sense_dma_addr) {
 		dma_unmap_single(&pci_dev->dev,
-				 (dma_addr_t)((unsigned long)cmnd->SCp.ptr),
+				 initio_priv(cmnd)->sense_dma_addr,
 				 SENSE_SIZE, DMA_FROM_DEVICE);
-		cmnd->SCp.ptr = NULL;
+		initio_priv(cmnd)->sense_dma_addr = 0;
 	}
 
 	/* request buffer */
 	if (scsi_sg_count(cmnd)) {
-		dma_unmap_single(&pci_dev->dev, cmnd->SCp.dma_handle,
+		dma_unmap_single(&pci_dev->dev,
+				 initio_priv(cmnd)->sglist_dma_addr,
 				 sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
 				 DMA_BIDIRECTIONAL);
 
@@ -2796,6 +2797,7 @@ static struct scsi_host_template initio_template = {
 	.can_queue		= MAX_TARGETS * i91u_MAXQUEUE,
 	.this_id		= 1,
 	.sg_tablesize		= SG_ALL,
+	.cmd_size		= sizeof(struct initio_cmd_priv),
 };
 
 static int initio_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index 9fd010cf1f8a..7c9741552654 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -640,3 +640,12 @@ typedef struct _NVRAM {
 #define SCSI_RESET_HOST_RESET 0x200
 #define SCSI_RESET_ACTION   0xff
 
+struct initio_cmd_priv {
+	dma_addr_t sense_dma_addr;
+	dma_addr_t sglist_dma_addr;
+};
+
+static inline struct initio_cmd_priv *initio_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
