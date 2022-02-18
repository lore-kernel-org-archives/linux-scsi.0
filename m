Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32CF2C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbiBRTwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbiBRTwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:11 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64400291F99
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:54 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id 27so3523864pgk.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2vuShzWu3ZIh6QSM2HQ53oBiJIY+AOjKbypfgrmVa24=;
        b=TLewBYpXnLfClWjhddLou9MNFjMmxweJEdmain3U1q5Uy2Dk+LlRzWI0moM9Y7KnKb
         uRyJHGoUDgR/kzSdcRZ2wREOVrxZmsYWnCmiqGLGxGtN8i+DeiLNYX+1lZY5hA5Zv4sg
         Eh6wJKnd6IQiLWWoPziTDRP+F/It/3TDZ7Rjp1ZR8fe/Q5Vlrwet4HOW22xGOy7e13gL
         cEBJFVpzgSn4D63JB7IG9zSCE3XXvIYvtTLYbACZwcwiSAabgVS+sm/SHkbQHaEUsNbi
         hv3dHNUAHK8tIYtCY32YazSsYe0zG/TXtQWt3QmRC1BkdNpIHx4CzhSba+W7EzuOBYGy
         vuew==
X-Gm-Message-State: AOAM532fs9V+Crskd+4T+doyxdO6fH+yLhrrTxsyDPZ4r/0jUTEfvQaK
        nes08tBrH4WSt5FW/2T8FiA=
X-Google-Smtp-Source: ABdhPJx7kNfHSShhZTH2l6JP5TzYvE40hnBiicF/6V1Gt1UAmziLXe6f45svzJIPckFUCpzJD/mSWA==
X-Received: by 2002:a05:6a00:1822:b0:4df:56b7:afc7 with SMTP id y34-20020a056a00182200b004df56b7afc7mr9379414pfa.58.1645213913822;
        Fri, 18 Feb 2022 11:51:53 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:52 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 13/49] scsi: advansys: Move the SCSI pointer to private command data
Date:   Fri, 18 Feb 2022 11:50:41 -0800
Message-Id: <20220218195117.25689-14-bvanassche@acm.org>
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
