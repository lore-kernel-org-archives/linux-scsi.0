Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8BDC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354142AbiBKWeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354147AbiBKWeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:06 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C73AD63
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:04 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id y7so5785908plp.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6urj33gaKkePqg1xUPmjUt8DwssrZsVJTG4tFiazOI=;
        b=Hwo5IiLarpq4+mVWO7xH+G1gSRDR4uaNZYZMQ9Qxz32mD7DzoDH5y45Par/RA4KwWm
         cfuzN1JOZVgiPpz4AyH8cV92oW82j/AcnYSCt5XfNgbJYjNxv9TLuAVN1S3l71IhI3zW
         pAENZTK9h5BkI/ur8udW74x4Vtx5v5qPFOnJBQDRCK3oYyqj31gUOXwh8DXCzvTztwMT
         iwhp36ZG/ifqaTL3lEquEH81vhPE+SWJB5g4wUTxOhgqas9yM6R5+7otiIxzSLmPRExf
         5eHjZI1wacg6G+VeKlZj4FZQa1tWtE3xIPMHKFQYK8NOJfbKqYJRTVaW4EHjiBb0Ubzi
         W1+w==
X-Gm-Message-State: AOAM531eyVqIarbCQZiK2i+R4X86DQQVFosB99DFLH4Gn1S90UqA/oV8
        sQZZ7g+IgYe1vpvsCdhhZgwOQHsb2Q67rg==
X-Google-Smtp-Source: ABdhPJzQv0cBJBIW3xtBEGAxj4mas9ib4yp8FQKW7/7cydVuzk6l6pabB0VQ0bLfR4qJsNIz6GxQmg==
X-Received: by 2002:a17:90b:4ac4:: with SMTP id mh4mr2552044pjb.89.1644618844084;
        Fri, 11 Feb 2022 14:34:04 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 27/48] scsi: initio: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:26 -0800
Message-Id: <20220211223247.14369-28-bvanassche@acm.org>
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
