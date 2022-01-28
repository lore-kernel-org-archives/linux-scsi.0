Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3825EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbiA1WU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:58 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:44841 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345242AbiA1WU4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:56 -0500
Received: by mail-pj1-f41.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so7725858pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tWRKiJLOzSrfKnsXhD0IMRKdILPwrNJ/kqmVd+EMXJM=;
        b=3gNJNQaj3LXAMGII/F7/jboIDMtUVoz58TNG6TCZ42n/3tgQMF/A7zCnxFuV3QNZ8y
         Ia2e+JdD45Dr9Bq5m2BqjuzXQme/KuPaAez8Gn7Q+pYoVPpnbiLcC6RNF5T2mbQt8gGt
         yrSc+dMt5kHRDMrw6FZUIxH5VaJnMtmEvTaNpXQBa7vZZBYjDwLNrLLovApjyDT07caU
         YbpotQT21WJuE0ov3lN6UzPihybK15NknRMP+2W4VzNi8+kF0+xa5gnwgpbcfn2E/5ak
         Cha3GTZikbQ4z5D/kHJaUcZ6tXwAwbPOqPbV4ulcsteNf5aHXqPwLvXAQkACZJJ2IxIq
         WNNA==
X-Gm-Message-State: AOAM531+qyKUbenjzCUDINtCaqLrSeOGR2rp340O44YiRwYhgw2xVntg
        GEi6oPxTipNeq74NiAC2t5Y=
X-Google-Smtp-Source: ABdhPJw7BuDMyUioptzmd55GTCym75Xw59k5LjkxddB51d7XWwKE6MMJyVgYiyiXhDxbMv/rxesHYQ==
X-Received: by 2002:a17:903:24d:: with SMTP id j13mr10247194plh.145.1643408455817;
        Fri, 28 Jan 2022 14:20:55 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 10/44] advansys: Move the SCSI pointer to private command data
Date:   Fri, 28 Jan 2022 14:18:35 -0800
Message-Id: <20220128221909.8141-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/advansys.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ace5eff828e9..f301aec044bb 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2277,6 +2277,15 @@ struct asc_board {
 							dvc_var.adv_dvc_var)
 #define adv_dvc_to_pdev(adv_dvc) to_pci_dev(adv_dvc_to_board(adv_dvc)->dev)
 
+struct advansys_cmd {
+	dma_addr_t dma_handle;
+};
+
+static struct advansys_cmd *advansys_cmd(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 #ifdef ADVANSYS_DEBUG
 static int asc_dbglvl = 3;
 
@@ -6681,7 +6690,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 
 	ASC_STATS(boardp->shost, callback);
 
-	dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
+	dma_unmap_single(boardp->dev, advansys_cmd(scp)->dma_handle,
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	/*
 	 * 'qdonep' contains the command's ending status.
@@ -7399,15 +7408,15 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 static __le32 asc_get_sense_buffer_dma(struct scsi_cmnd *scp)
 {
 	struct asc_board *board = shost_priv(scp->device->host);
+	struct advansys_cmd *acmd = advansys_cmd(scp);
 
-	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
-					     SCSI_SENSE_BUFFERSIZE,
-					     DMA_FROM_DEVICE);
-	if (dma_mapping_error(board->dev, scp->SCp.dma_handle)) {
+	acmd->dma_handle = dma_map_single(board->dev, scp->sense_buffer,
+					SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(board->dev, acmd->dma_handle)) {
 		ASC_DBG(1, "failed to map sense buffer\n");
 		return 0;
 	}
-	return cpu_to_le32(scp->SCp.dma_handle);
+	return cpu_to_le32(acmd->dma_handle);
 }
 
 static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
@@ -10604,6 +10613,7 @@ static struct scsi_host_template advansys_template = {
 	.eh_host_reset_handler = advansys_reset,
 	.bios_param = advansys_biosparam,
 	.slave_configure = advansys_slave_configure,
+	.cmd_size = sizeof(struct advansys_cmd),
 };
 
 static int advansys_wide_init_chip(struct Scsi_Host *shost)
