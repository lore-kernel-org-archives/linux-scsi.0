Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CD2C25B49
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 20:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjJWUg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjJWUgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 16:36:54 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559FBD7A;
        Mon, 23 Oct 2023 13:36:52 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6b497c8575aso3730468b3a.1;
        Mon, 23 Oct 2023 13:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698093412; x=1698698212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rzazhz3pJNtMrLPLf65MSg+veUxWS3Czg4sZVKyrr/E=;
        b=wxRMDoyN71mw9CbLXb5kcucBvjy1UsZEJFPQQgrv/198/wLnuvzM2rhB0h61RNCBnI
         O4Jyy1hCgM/fRedaWPtzJR+0Xgz5//p2/9HpUi2fIDJr74EMqMMOJJq4IvwbuteIG4TZ
         veonT7mr46KWkvRTVEprE8agqRmQgZ6dxFvZ4CQ7tSlklSvq2x9tvf/uyZY+UyJIqWnD
         EjwJgtTjZDQblarpLAO/IV0ba7VEwTzz5zecARjlK20eq2ZCQ91OgJwPPQ/w3FPtb6ce
         FTalljQlBM79xABgmr+B/rD4irkV+tDYepnfKjCKK4dZkTlJe1Pu05ZsUcDgPeV44Ywp
         M0Jw==
X-Gm-Message-State: AOJu0Yy1KAnM6NokGKWkBqyAhUHjdS8K/guMb3b0+1B6D+w0HHVGSbkd
        GU4X0KmflaDa71luqTXuwnE=
X-Google-Smtp-Source: AGHT+IGyq9vTRFR0XF2Np0Mp0z5zonOlx+6qHuBgaPVX49kLwfxfO4P3ts8iW0SERptq2G7TknmDcg==
X-Received: by 2002:a05:6a00:174c:b0:6ba:2ba7:b9cb with SMTP id j12-20020a056a00174c00b006ba2ba7b9cbmr12112155pfc.12.1698093411408;
        Mon, 23 Oct 2023 13:36:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id g29-20020aa79ddd000000b0068be4ce33easm5776025pfq.96.2023.10.23.13.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 13:36:50 -0700 (PDT)
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
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH v4 2/3] scsi: core: Support disabling fair tag sharing
Date:   Mon, 23 Oct 2023 13:36:34 -0700
Message-ID: <20231023203643.3209592-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023203643.3209592-1-bvanassche@acm.org>
References: <20231023203643.3209592-1-bvanassche@acm.org>
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
index c2f647a7c1b0..68683988c466 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1985,6 +1985,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	if (shost->queuecommand_may_block)
 		tag_set->flags |= BLK_MQ_F_BLOCKING;
+	if (shost->disable_fair_tag_sharing)
+		tag_set->flags |= BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
 	tag_set->driver_data = shost;
 	if (shost->host_tagset)
 		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 49f768d0ff37..2cd8a41b1f1c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -461,6 +461,9 @@ struct scsi_host_template {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
+	unsigned disable_fair_tag_sharing:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -659,6 +662,9 @@ struct Scsi_Host {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
+	unsigned disable_fair_tag_sharing:1;
+
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
 
