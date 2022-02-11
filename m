Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1243C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354178AbiBKWez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354164AbiBKWes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:48 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3533D5C
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:43 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id y8so15935906pfa.11
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ik4fUFCkFlenhZPbOaqGtMyvz7ystmwHP7ZXn9Wxrx0=;
        b=PVlV9ZqZXHe4RQ/3gewf/dHD0mffiC8EXivuY5H6wBDWHYoFL4LeoNIenkCTtTWq/K
         Pc5ZBmAGHYpbpEMusAQ2GPbA4ju26/4GFrQUJMg6JkAHvCXJHRJQm6p63shP2NUMDnjq
         Pvcq+iFnYv8+9RApb5H/2/eZI8FMxvf2k1LF4YJhzX+TdRB6OwtCqaMIWzxtpnIJ3Lml
         44maYe0m7D6k47LewlaYjZ+QI1x3wGlkN9pvbB3Vfy3r+Fao3nTMqpfekUR2LAZGavpH
         pD4uzhXgTsysHeuePZSrIpAPHSM8ukl2B6xQYCwt5UmLOlg0G4CQcALoNwYUP8Unf6HY
         uQww==
X-Gm-Message-State: AOAM53233k1Bb310gEU4sibpU2atWCYpLAOWAq7Vx7SWctxeKwcUs3j/
        C+J3JPbLspXOajWzHZcp8OE=
X-Google-Smtp-Source: ABdhPJzKy9gc/UKwr7JeT8LwXT1LO7XR/0LnmkLGYD4CwvHOuEpmYfrvUakvMgK8Qis/7xuJUs1CWg==
X-Received: by 2002:a05:6a00:1486:: with SMTP id v6mr3779593pfu.73.1644618883356;
        Fri, 11 Feb 2022 14:34:43 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Helge Deller <deller@gmx.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 47/48] scsi: zalon: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:46 -0800
Message-Id: <20220211223247.14369-48-bvanassche@acm.org>
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
