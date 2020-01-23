Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449BEC33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BECF21835
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgAWD4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 22:56:46 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38273 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAWD4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 22:56:46 -0500
Received: by mail-pj1-f65.google.com with SMTP id l35so597566pje.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 19:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ciKn95KNQqdf1ABU2Qcefo6cuXq8TcXvGcUbEueCHnE=;
        b=stLvFArPYs1YR7aDco2V1y5OLsHQJLX0jpMvlB/Bg48/vLNY97XqeC/7HFb2O+oQga
         Yrm5YfRd2GEOgaDJpN9BXw84DB6eTSlg7kGgvOtErChUFr+ZWhJUWDiNqvRmjHnPjQR9
         /zbPXICSuc01Q6QXP/GuCxqNweEuumhLKKpeEMm+as1agcdsLH4Z/Qgv/vLHcXCdg3px
         e3RHYgq52HPVgGrd3WiS1sTvaWGbqXk1ZceGaBmHNsCPwxLFveOUTr+bodmKVy269tkQ
         /+tEK9HIDGw8A19B65rpEMVPXM4qH3GsZOGzQKySoM7Y3KaR3HxHOT7Kc/KF8gClPfoR
         rssQ==
X-Gm-Message-State: APjAAAXZ07D7fqFe1J/xTx/eYdbNwga3zoRDF0GzN6ysqVETF3oCWunH
        LlgggRMWIWFnOV+jTMlbguE=
X-Google-Smtp-Source: APXvYqwcMdNUO3EbxVd1Pt9ssCGe/vo84xMA/eIy1oXuhq9SobtkTYH3Fjra26QA1WI/yH8deebVbA==
X-Received: by 2002:a17:902:b08e:: with SMTP id p14mr14914026plr.323.1579751805585;
        Wed, 22 Jan 2020 19:56:45 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id x197sm435287pfc.1.2020.01.22.19.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 19:56:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v2 1/4] Introduce {init,exit}_cmd_priv()
Date:   Wed, 22 Jan 2020 19:56:34 -0800
Message-Id: <20200123035637.21848-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123035637.21848-1-bvanassche@acm.org>
References: <20200123035637.21848-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current behavior of the SCSI core is to clear driver-private data
before preparing a request for submission to the SCSI LLD. Make it possible
for SCSI LLDs to disable clearing of driver-private data.

These hooks will be used by a later patch, namely "ufs: Let the SCSI core
allocate per-command UFS data".

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 29 +++++++++++++++++++++++------
 include/scsi/scsi_host.h |  3 +++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 97af9bf54b22..f0ea614ee49b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1127,7 +1127,7 @@ void scsi_del_cmd_from_list(struct scsi_cmnd *cmd)
 	}
 }
 
-/* Called after a request has been started. */
+/* Called before a request is prepared. See also scsi_mq_prep_fn(). */
 void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
 	void *buf = cmd->sense_buffer;
@@ -1135,7 +1135,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
 	unsigned long jiffies_at_alloc;
-	int retries;
+	int retries, to_clear;
 	bool in_flight;
 
 	if (!blk_rq_is_scsi(rq) && !(flags & SCMD_INITIALIZED)) {
@@ -1146,9 +1146,15 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	jiffies_at_alloc = cmd->jiffies_at_alloc;
 	retries = cmd->retries;
 	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
-	/* zero out the cmd, except for the embedded scsi_request */
-	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
+	/*
+	 * Zero out the cmd, except for the embedded scsi_request. Only clear
+	 * the driver-private command data if the LLD does not supply a
+	 * function to initialize that data.
+	 */
+	to_clear = sizeof(*cmd) - sizeof(cmd->req);
+	if (!dev->host->hostt->init_cmd_priv)
+		to_clear += dev->host->hostt->cmd_size;
+	memset((char *)cmd + sizeof(cmd->req), 0, to_clear);
 
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
@@ -1742,6 +1748,7 @@ static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	struct scatterlist *sg;
+	int ret = 0;
 
 	if (unchecked_isa_dma)
 		cmd->flags |= SCMD_UNCHECKED_ISA_DMA;
@@ -1757,14 +1764,24 @@ static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 		cmd->prot_sdb = (void *)sg + scsi_mq_inline_sgl_size(shost);
 	}
 
-	return 0;
+	if (shost->hostt->init_cmd_priv) {
+		ret = shost->hostt->init_cmd_priv(shost, cmd);
+		if (ret < 0)
+			scsi_free_sense_buffer(unchecked_isa_dma,
+					       cmd->sense_buffer);
+	}
+
+	return ret;
 }
 
 static void scsi_mq_exit_request(struct blk_mq_tag_set *set, struct request *rq,
 				 unsigned int hctx_idx)
 {
+	struct Scsi_Host *shost = set->driver_data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
+	if (shost->hostt->exit_cmd_priv)
+		shost->hostt->exit_cmd_priv(shost, cmd);
 	scsi_free_sense_buffer(cmd->flags & SCMD_UNCHECKED_ISA_DMA,
 			       cmd->sense_buffer);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f577647bf5f2..1fa81f9b063f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -62,6 +62,9 @@ struct scsi_host_template {
 			    void __user *arg);
 #endif
 
+	int (*init_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
+	int (*exit_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
+
 	/*
 	 * The queuecommand function is used to queue up a scsi
 	 * command block to the LLDD.  When the driver finished
