Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34486C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346551AbiA1WWR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:17 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:35466 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245100AbiA1WWA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:22:00 -0500
Received: by mail-pj1-f52.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so6458560pjq.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:22:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6zI1xKLIByieRu856KEILmRQkM/5sQVnTaeWECi76uI=;
        b=30ArEZjL/clsvA4gAqhaixWcSEbqberLRMmNeCiIIqseVV7UIXKVw0j0Mju+PkCQDY
         h6W+ruQSegCw+QLSYsDz6PhYKy8/LQ5a1PWgzqcn/sjFMIfOxPeBuOa2BCJeLLeARo0b
         yTvNSgLTwT+15dPurzX2jmaMpPp3KDukugnrTFbOnceRNr1KlTQgPfqUrTO3FiZ11GXI
         6bqn/WgUAKh+8WsjTWuffvT/ZAVRPjceJsS8necI9Pt9Mr156Z+6KpZVp6jmbgjzI0yY
         x4qHOUY8AvVSpkVs3qclL3O6Fw4zCr2n6JNlBeo1bZhcrkSeqzS12PQXCnACYoOmUqBO
         XU9w==
X-Gm-Message-State: AOAM530faBAsIbC20cpHfpiIFa9FuxMyRcdhTZHfaffhjG96iA+qvWMv
        BHmlsQl/ku8KQ8HIUPJVA5g=
X-Google-Smtp-Source: ABdhPJxkW9tVq+13RRO72cElE2fwqJDszrPFPlUWcHomno/IelDAQ1i5+dpOy86wa+y5VdPih9IHPw==
X-Received: by 2002:a17:902:6b4b:: with SMTP id g11mr10490596plt.109.1643408520142;
        Fri, 28 Jan 2022 14:22:00 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 43/44] zalon: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:19:08 -0800
Message-Id: <20220128221909.8141-44-bvanassche@acm.org>
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

Cc: Helge Deller <deller@gmx.de>
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
