Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADAEC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiBPVEp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiBPVEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:37 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1717C2AFEA6
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:23 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id l8so2960897pls.7
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ik4fUFCkFlenhZPbOaqGtMyvz7ystmwHP7ZXn9Wxrx0=;
        b=6PY/cjXlEDyIsO8f5LCAPm5aMiuEZ2ys21Mf78pOSGYVvCKD40wFn/FhF2+HcOPOgi
         VCT3xt1TGCQ6pw9SArIlyh8sVrs5Mq3Y7KzFa+e63XGU7UlvoVmTIj0ZZhcNrIgyQkgn
         2wbDqGEG8bdoaIOLx6gFB0TqL8iK7ySZWerTnXUhb5qdKN4GE1dXEVCJTHoLlireWCGD
         p3/Nx5hF1fSe7BGyT+v9AWHef6yYO363N/SelQSF8YySvYvY6FGJgU23RK87HE/A1ipF
         7xZDxtZNZq4ZB05nqRO8WivT9lh8RKZOTC1M/FnrDiFxTw3FAVbyyvYDW2t8VwIUFkoD
         DjOw==
X-Gm-Message-State: AOAM532iDIFFRtv8pViLV6anCJyhQUGWf1+7yoe5vO5RvGCC2m3XHt6L
        2ypcRqQI+1SSyJ+0sUwpgMCn07tqXhUdQC66
X-Google-Smtp-Source: ABdhPJxgOTXVyG/YzJ0BKiAi2O4WpUfxy24ITOFiX3AMR5K+EL1u3x19UNcpv5N4O9keBPNty9XLmw==
X-Received: by 2002:a17:90a:9f82:b0:1b9:e290:8960 with SMTP id o2-20020a17090a9f8200b001b9e2908960mr3866527pjp.222.1645045462510;
        Wed, 16 Feb 2022 13:04:22 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:04:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Helge Deller <deller@gmx.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 49/50] scsi: zalon: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:32 -0800
Message-Id: <20220216210233.28774-50-bvanassche@acm.org>
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

Cc: Helge Deller <deller@gmx.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ncr53c8xx.c | 22 ++++++++++++----------
 drivers/scsi/ncr53c8xx.h |  6 ++++++
 drivers/scsi/zalon.c     |  1 +
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index fc8abe05fa8f..4458449c960b 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -514,30 +514,29 @@ static m_addr_t __vtobus(m_bush_t bush, void *m)
  *  Deal with DMA mapping/unmapping.
  */
 
-/* To keep track of the dma mapping (sg/single) that has been set */
-#define __data_mapped	SCp.phase
-#define __data_mapping	SCp.have_data_in
-
 static void __unmap_scsi_data(struct device *dev, struct scsi_cmnd *cmd)
 {
-	switch(cmd->__data_mapped) {
+	struct ncr_cmd_priv *cmd_priv = scsi_cmd_priv(cmd);
+
+	switch(cmd_priv->data_mapped) {
 	case 2:
 		scsi_dma_unmap(cmd);
 		break;
 	}
-	cmd->__data_mapped = 0;
+	cmd_priv->data_mapped = 0;
 }
 
 static int __map_scsi_sg_data(struct device *dev, struct scsi_cmnd *cmd)
 {
+	struct ncr_cmd_priv *cmd_priv = scsi_cmd_priv(cmd);
 	int use_sg;
 
 	use_sg = scsi_dma_map(cmd);
 	if (!use_sg)
 		return 0;
 
-	cmd->__data_mapped = 2;
-	cmd->__data_mapping = use_sg;
+	cmd_priv->data_mapped = 2;
+	cmd_priv->data_mapping = use_sg;
 
 	return use_sg;
 }
@@ -7854,6 +7853,7 @@ static int ncr53c8xx_slave_configure(struct scsi_device *device)
 
 static int ncr53c8xx_queue_command_lck(struct scsi_cmnd *cmd)
 {
+     struct ncr_cmd_priv *cmd_priv = scsi_cmd_priv(cmd);
      void (*done)(struct scsi_cmnd *) = scsi_done;
      struct ncb *np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
      unsigned long flags;
@@ -7864,8 +7864,8 @@ printk("ncr53c8xx_queue_command\n");
 #endif
 
      cmd->host_scribble = NULL;
-     cmd->__data_mapped = 0;
-     cmd->__data_mapping = 0;
+     cmd_priv->data_mapped = 0;
+     cmd_priv->data_mapping = 0;
 
      spin_lock_irqsave(&np->smp_lock, flags);
 
@@ -8085,6 +8085,8 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 	u_long flags = 0;
 	int i;
 
+	WARN_ON_ONCE(tpnt->cmd_size < sizeof(struct ncr_cmd_priv));
+
 	if (!tpnt->name)
 		tpnt->name	= SCSI_NCR_DRIVER_NAME;
 	if (!tpnt->shost_groups)
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index fa14b5ca8783..be38c902859e 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -1288,6 +1288,12 @@ struct ncr_device {
 	u8 differential;
 };
 
+/* To keep track of the dma mapping (sg/single) that has been set */
+struct ncr_cmd_priv {
+	int	data_mapped;
+	int	data_mapping;
+};
+
 extern struct Scsi_Host *ncr_attach(struct scsi_host_template *tpnt, int unit, struct ncr_device *device);
 extern void ncr53c8xx_release(struct Scsi_Host *host);
 irqreturn_t ncr53c8xx_intr(int irq, void *dev_id);
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index f1e5cf8a17d9..22d412cab91d 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -81,6 +81,7 @@ lasi_scsi_clock(void * hpa, int defaultclock)
 static struct scsi_host_template zalon7xx_template = {
 	.module		= THIS_MODULE,
 	.proc_name	= "zalon7xx",
+	.cmd_size	= sizeof(struct ncr_cmd_priv),
 };
 
 static int __init
