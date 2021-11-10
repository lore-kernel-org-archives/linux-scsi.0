Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8AEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 487FB61181
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhKJAsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:10 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:37398 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhKJAsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:08 -0500
Received: by mail-pl1-f177.google.com with SMTP id n8so1585698plf.4
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g9s1fzRS+y58TYUG44MoMeeUMyJBoFAmA9RoI8sssXo=;
        b=JfhNtGmMJhsyZBdyFICpaSe+z9ueJN80/3EZO7TjTCoW0wXfLE9nh3yP3nH0LOh0xa
         GrpJ6iN4U54al6omjfjMk/eS6UNp4dWXjBy2hp+GTY7rmV8ZPDNh4xpaHcxzpJyJA9qd
         68MNhYdK4YbOk3BmmfSMevxvJwQRggn0UlWyvFUHwkQ/lgc3pzI/ls/6eyEUr4aZHUHz
         f/QLtticpNfcA2e2FBxkZtsQN1TIdNarg/SD/huQNOBJawmscNLxoyjy00i66P+RLUqS
         WLkk6gP9ICcgr2xb1WsIyQ0BRL8H+11OIUEcjLaSjEW7gTdyjKwzzEzbIlzXEjXdpKQC
         AVLw==
X-Gm-Message-State: AOAM531OzLz9Ai97NTUw0y0B290HEN/qbEFKtGBfhY8Otj3MrvwmNJ0E
        0pJx9iEEzTyU9y+ZyQReinw=
X-Google-Smtp-Source: ABdhPJzd4HO7rBuSn15ojw/93qYaB60qTTifenBH2awP8z421A7Fip9KjHvD2Fx3Tx0aqiIr+v3Lwg==
X-Received: by 2002:a17:90a:ccb:: with SMTP id 11mr11983721pjt.121.1636505121892;
        Tue, 09 Nov 2021 16:45:21 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 05/11] scsi: core: Add support for reserved tags
Date:   Tue,  9 Nov 2021 16:44:34 -0800
Message-Id: <20211110004440.3389311-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI LLDs to allocate reserved tags by passing the BLK_MQ_REQ_RESERVED
flag to blk_mq_alloc_request().

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 4 +++-
 include/scsi/scsi_host.h | 9 ++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 43151e5d07ab..51d4ae1a5b16 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1916,6 +1916,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
 	struct blk_mq_tag_set *tag_set = &shost->tag_set;
+	unsigned int reserved_tags = shost->hostt->reserved_tags;
 
 	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
 				scsi_mq_inline_sgl_size(shost));
@@ -1931,7 +1932,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		tag_set->ops = &scsi_mq_ops_no_commit;
 	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
 	tag_set->nr_maps = shost->nr_maps ? : 1;
-	tag_set->queue_depth = shost->can_queue;
+	tag_set->queue_depth = shost->can_queue + reserved_tags;
+	tag_set->reserved_tags = reserved_tags;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = NUMA_NO_NODE;
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ebe059badba0..0fa3ee73501a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -367,10 +367,17 @@ struct scsi_host_template {
 	/*
 	 * This determines if we will use a non-interrupt driven
 	 * or an interrupt driven scheme.  It is set to the maximum number
-	 * of simultaneous commands a single hw queue in HBA will accept.
+	 * of simultaneous commands a single hw queue in HBA will accept. Does
+	 * not include @reserved_tags.
 	 */
 	int can_queue;
 
+	/*
+	 * Number of tags to reserve. A reserved tag can be allocated by passing
+	 * the BLK_MQ_REQ_RESERVED flag to blk_get_request().
+	 */
+	unsigned reserved_tags;
+
 	/*
 	 * In many instances, especially where disconnect / reconnect are
 	 * supported, our host also has an ID on the SCSI bus.  If this is
