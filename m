Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C8AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384302AbiBHR0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384267AbiBHRZ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:25:57 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E7CC0612B8
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:25:56 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id m7so16953243pjk.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:25:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rl+Ciw9thokj1IhmaFWCIUV+9vX0lMQltkfJqZRPd2I=;
        b=tZfJ4UrNUXOtGG2ZXs+8yhv5PHAvFTMoJHIaZpELqh1mMzow2dGcfAiXFnkXUzbVfx
         bwULIvVjCkYQ9FUyRZONKEkRJ3goIMVvPhTHGxc8OZKqoZe13dlw2vrv/BRoyJrC0ut/
         quxKFx3/Jk4g7wfd2HmoqddtCsUzNnN9Xhwqiqn/2zojVTxg/uaPo1ZUF/mly7k012Gb
         GSTdWrYRLQo68xiWCoJTFYFz1YG6hUX6PdK85lWk1lOm3wEy5P8E22u0TBck+Co753i6
         OZClDiXn6mm2YdyjdNjeww8tzbPO33FO70Zb/5nhXJkJeQwpcVIyk+9O9t2gowZCJrnC
         UEIQ==
X-Gm-Message-State: AOAM532b8M3S3KLgwcWyxzkoofJ9BYkG/jhH4//zmpShfByXsbeCHOxf
        XX2I7xQQKxowb8uflch8sTw=
X-Google-Smtp-Source: ABdhPJwTLEv7mo8ZPXTP45+zFx7v253tdZgBydPDu9pU7+IoNqYmw6kgbowota+ibEdHFey4zfcbDg==
X-Received: by 2002:a17:902:eb8c:: with SMTP id q12mr2527723plg.131.1644341155648;
        Tue, 08 Feb 2022 09:25:55 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:25:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 10/44] advansys: Move the SCSI pointer to private command data
Date:   Tue,  8 Feb 2022 09:24:40 -0800
Message-Id: <20220208172514.3481-11-bvanassche@acm.org>
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
