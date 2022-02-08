Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80232C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384336AbiBHR1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384354AbiBHR1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:27:15 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6BFC0611DA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:27:03 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id qe15so7504996pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:27:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rdXrV+4PAdk1fuoDE001AXbnmsuyuzwRIr6D3mtjHiw=;
        b=HXg6yB93nelMGLttu9g+i+H1ekRuL8jIigg0RisjtJZAExXvok77Q9NsmGjxyxOhoR
         aNXEHPM/hfx4WmWAHjLe0w7PPVqw0yOc9xdnDi9p0L9ScnodPN4D4WsP1RAdPzdvLLBx
         UXalTmnjDXyoUdSB7ZYH9wBoWiuMbvhC6dO0YChguhElgrUvQorv3PRLQ/dgTuq3WKq1
         bIycPtS2ZDZgpOdDUdzoEsWnels9sJSSHKVibEAR9JWdOmeMGXXNt3/zVWTa65iN8Jx1
         eNZfptgpLlluldGeY+NBma9WDuNpv5F+z6tMMLMBtDIf14v8ewyNadcAA94S7b34A63a
         ZM+w==
X-Gm-Message-State: AOAM5321JbYeSR08mmfVahNccLCfnLcM87k+mInaYy/ZAN999QjvIQQA
        FZfrYhAZ4sQ/hBZnJ5z8W8A=
X-Google-Smtp-Source: ABdhPJzNuP9mYzobOdNzClQKRPUVwJ92pI1m6AUiMABYQAhB4ytFgn2tjryvSWT2JBe6ZmXmG8UJuQ==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr2486419pjb.190.1644341223238;
        Tue, 08 Feb 2022 09:27:03 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:27:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Helge Deller <deller@gmx.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 43/44] zalon: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:25:13 -0800
Message-Id: <20220208172514.3481-44-bvanassche@acm.org>
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

Cc: Helge Deller <deller@gmx.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
