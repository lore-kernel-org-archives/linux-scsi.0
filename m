Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529D1C41535
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 18:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjKNSFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 13:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbjKNSEr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 13:04:47 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D51B9;
        Tue, 14 Nov 2023 10:04:35 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6b77ab73c6fso24963b3a.1;
        Tue, 14 Nov 2023 10:04:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699985074; x=1700589874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIp72GlkjbCmnVUUISbqMrl5dUpklTIjfpOKSRHa5Eo=;
        b=bfzEDzTbkFYT2oijnzFTR+YlkGnQ8hFJ2KC9H3VaXkwtDDSBIdV24unnkxN87DUXD9
         MOUaVZcb/HgIus5vbTNTKM2R1ePKuGmx7yKV8gjkvRTf4Vwb8uNwaJFu/lPzF2nRY7fm
         UZvcpmuVOboiJ6WhtbyDl4UExO6sHjU8H10jpd+zKz+tWH0AuzYBjHVf9FzbECpVIydD
         ScMiJEi0XoloYYX3Qzbumq7VqHPuTpjeVl/nWTyXb8Y8XUeL8iYIPG5skXSWra2/FKHe
         Npq/x90OBPTvmDVmkWK2JBn0UEHSmByVGl5MasaNRsM/bOEKc/quTAJ0nM7Dw78K2L3/
         4eAg==
X-Gm-Message-State: AOJu0YyTJbwUfcYmK2Yu52RLw69f8PCDlr0RzaR0jnk7SNLkRMYeTrwy
        2NAmqFU/waQqq2BN1xbBj54=
X-Google-Smtp-Source: AGHT+IGfgDJwGyRHAhvicjmHZpf0ti1TIzSKi22ZY/RsAKF/XoPf4CH+u9bWyFzhgzG2qacWocGPCg==
X-Received: by 2002:a05:6a00:2990:b0:68f:b5a3:5ec6 with SMTP id cj16-20020a056a00299000b0068fb5a35ec6mr5233874pfb.0.1699985074560;
        Tue, 14 Nov 2023 10:04:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id bq4-20020a056a02044400b0059d6f5196fasm5101937pgb.78.2023.11.14.10.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 10:04:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
Date:   Tue, 14 Nov 2023 10:04:16 -0800
Message-ID: <20231114180426.1184601-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
In-Reply-To: <20231114180426.1184601-1-bvanassche@acm.org>
References: <20231114180426.1184601-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI drivers to disable the block layer fair tag sharing algorithm.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 1 +
 drivers/scsi/scsi_lib.c  | 2 ++
 include/scsi/scsi_host.h | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index d7f51b84f3c7..872f87001374 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -442,6 +442,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	shost->no_write_same = sht->no_write_same;
 	shost->host_tagset = sht->host_tagset;
 	shost->queuecommand_may_block = sht->queuecommand_may_block;
+	shost->disable_fair_tag_sharing = sht->disable_fair_tag_sharing;
 
 	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
 		shost->eh_deadline = -1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf3864f72093..291fbfacf542 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1984,6 +1984,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	if (shost->queuecommand_may_block)
 		tag_set->flags |= BLK_MQ_F_BLOCKING;
+	if (shost->disable_fair_tag_sharing)
+		tag_set->flags |= BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
 	tag_set->driver_data = shost;
 	if (shost->host_tagset)
 		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b907fc2ef08..04238ae9e22c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -464,6 +464,9 @@ struct scsi_host_template {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
+	unsigned disable_fair_tag_sharing:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -662,6 +665,9 @@ struct Scsi_Host {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
+	unsigned disable_fair_tag_sharing:1;
+
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
 
