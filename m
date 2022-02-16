Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10464C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiBPVDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiBPVDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:32 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866E8213F14
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:14 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id x4so2965791plb.4
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2vuShzWu3ZIh6QSM2HQ53oBiJIY+AOjKbypfgrmVa24=;
        b=TQOWP0CxcogfJojb5jqapLUBi4PDIuZ4Z8KYEUFiGIgE/Egbq235y2B8VwM91nGcAB
         XXtWpMTcTktbF4xXDCJtRbCl/gBoVeaQhhlfL8fxGP9WOhHn7Otr4nyXalDA9uRMyBTc
         HoMZNweWI3TmaBLC1TZFmvyvd0PvaTrNMIRzboXhtiI2EODpFOE38utUaWb4t3fPq/AK
         MMnD3hQcu42AkQsFU1JUljJg/fUy9ny+Z+TlJ/fz65L+gqfMDtH2C37zZ5/FS7kxjIQi
         z9iMe/8bOzaKIcNv/5Uc9ZUh55oz/7rAmODxuMiJoIaFNuWiscg7Xy9ShoUhyPxOdiMa
         0yrA==
X-Gm-Message-State: AOAM5314vaQN64IKfWoIgNASCLcQQ5xOu2CxB+TqaAngo4UyYo5U331V
        VdEIkFTDljhnDZDn7sa2fAA=
X-Google-Smtp-Source: ABdhPJwi8r71dJP2twe6Zsnpc81Vrk6RCBE8U+exWKbWWSUyvE3pP6kuTTcK2sai6ATqAoQ6lDh8dQ==
X-Received: by 2002:a17:90a:b017:b0:1b9:485b:3005 with SMTP id x23-20020a17090ab01700b001b9485b3005mr3858532pjq.33.1645045393854;
        Wed, 16 Feb 2022 13:03:13 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:13 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 14/50] scsi: advansys: Move the SCSI pointer to private command data
Date:   Wed, 16 Feb 2022 13:01:57 -0800
Message-Id: <20220216210233.28774-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
