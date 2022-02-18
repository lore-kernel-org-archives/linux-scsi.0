Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D90FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbiBRTwr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbiBRTwo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:44 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FB6291FAB
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:25 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id y16so1299694pjt.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6urj33gaKkePqg1xUPmjUt8DwssrZsVJTG4tFiazOI=;
        b=3yIkHfpV+VtzkM/cUu37s7IKjswyTMhdcq/o7VetXC7NJhYrzXpod3P0Vwr3xLs8fC
         7Fpwy1y2R9CF4xxYTmnlAgmmVlm1PttxFw1IVlm4AiRewrQRCyyN7q7MoWC2GaJNfKM7
         sfmqhFfXMeweA+pxIY9OEmIMucBwdrsk39RRMFMWh5qQWlIaINRjgnmALUZ3sJoYIEJa
         UnPNjUepI1hgdHsaOYjXpD0JnkR0v5GFc22g6lCaLI5XYqhDGj0dk361vQ9yR4X4wcGc
         JrODfas7yyqNMSS9mgS45WZriB46oWcI01wICZ6R6Xhq3tSJZWF2WlnhGmeBcBPZ4gPA
         ClnQ==
X-Gm-Message-State: AOAM530xjaVm2x9H1o9fv67FOmQiEyA9yAImqz02FYEA6mJq+sjYVOU1
        DU90AcYF/IMtKRPNQxI8JM8=
X-Google-Smtp-Source: ABdhPJwwo6YhomJwyGyTydfUOpJse15qo7NoSEfY74/WVTTxLpU+0KkXQO0T1C0snGED9/2jkYdhxg==
X-Received: by 2002:a17:90a:aa83:b0:1b9:7c62:61e5 with SMTP id l3-20020a17090aaa8300b001b97c6261e5mr10010385pjq.118.1645213944401;
        Fri, 18 Feb 2022 11:52:24 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 26/49] scsi: initio: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:50:54 -0800
Message-Id: <20220218195117.25689-27-bvanassche@acm.org>
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
