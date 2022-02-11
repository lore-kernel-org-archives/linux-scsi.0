Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6994BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354119AbiBKWdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354108AbiBKWdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:37 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1B3D4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:35 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id i6so16758247pfc.9
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rl+Ciw9thokj1IhmaFWCIUV+9vX0lMQltkfJqZRPd2I=;
        b=2hTCdTLKYn6epg6UIi9aHkLtIbyeaHcu+EfDz3PMmFNsvuCuqLBLix0QmySK0/OYVg
         HD05ih1MJg8+XDJ/3XgIia936Db5UpScYno8SjsIG5E4Zhx8oVQevwIE53eAJTemyZ2A
         0RVQoXGuCYYmzD8EUPANMb5DrRBflN9y6ZW02leyw53963QuwyabPBFLXTHqY6t74LpP
         8uoZBVauT3xyWoSXQjve0aRMk/Fs5kDERO4DAka32wtkVhNdidNaBSuDjAMDbBnq/HrT
         0v3mnybGT8AKxeamlHnuyjDyVZ8FuZ+mc7+cY4ZSeQuf6tWKoByewWECh7Ip8a57o/x0
         Jehg==
X-Gm-Message-State: AOAM530+dBwTcdi9Yb84Rtnziq3KdnGMg7hboGfJuB9vxhrsGZCbmSPv
        BK4Os6+gZJeszqUxOQK0//8=
X-Google-Smtp-Source: ABdhPJzjyt6agJTEhDZ9ojjilUwr2jCAmI0eRtRYLNfGHd4oYGu5ExHPou5ePe4oXpuPsrSypF0sRQ==
X-Received: by 2002:a05:6a00:c94:: with SMTP id a20mr3724597pfv.41.1644618815080;
        Fri, 11 Feb 2022 14:33:35 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 14/48] scsi: advansys: Move the SCSI pointer to private command data
Date:   Fri, 11 Feb 2022 14:32:13 -0800
Message-Id: <20220211223247.14369-15-bvanassche@acm.org>
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
