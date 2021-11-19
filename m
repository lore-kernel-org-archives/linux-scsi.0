Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FFDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B2EE610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhKSUBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:06 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:35483 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbhKSUBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:00 -0500
Received: by mail-pj1-f47.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso11805056pji.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:57:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jMovzKB6VEpk/VZdlOB5mJ28Z83h+mD0/btK5LTCbbU=;
        b=TDRczUOzNXrucReTCZuI4FBIq2UuM99rE2GIixeN9aL/ysBTVG7167O/ofiV5KXKbM
         X+Fc3EegqkaDeVG1vDnZkEHEAwJUT+rFGlDIzpv8Sn1Frsa+JgWDGwhLkynWstKmojm5
         QWdw6RJq1BYP4vYKXkNMDDgw0B7k0hTSqj2X7whls93Nt8O+3bGMZ7cC3kSSV+tGjw+8
         9Q/D8ldIe0feybFxFBhFP9lKWAIs2STKjmySZcjCguHAihuurfHyW9MCYykRKxRb4hMk
         fTJXayA50nydset6YBU5eqD+MU5Dsl+GSCENSVlPQAbEymlF0kBqbBwS2urrsyAK1noV
         ETFQ==
X-Gm-Message-State: AOAM531OixQb1FfIWfPtR+ybO3TNgJUDILJbLn56qxCEDcH5y21lgviU
        UclWM4f82Br4pWavNqZA3Ek=
X-Google-Smtp-Source: ABdhPJy3sFI6YXMh5uGv3dEWoj7EmK1xHV8O/T0u5oSSOjx1g6tc3/w+1PxIwDQ0046EQmA7HfYb7Q==
X-Received: by 2002:a17:90a:ca11:: with SMTP id x17mr2815217pjt.61.1637351878071;
        Fri, 19 Nov 2021 11:57:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:57:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 06/20] scsi: core: Add support for reserved tags
Date:   Fri, 19 Nov 2021 11:57:29 -0800
Message-Id: <20211119195743.2817-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
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
index 59c3c4fbcfc0..44489ddc646c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1925,6 +1925,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
 	struct blk_mq_tag_set *tag_set = &shost->tag_set;
+	unsigned int reserved_tags = shost->hostt->reserved_tags;
 
 	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
 				scsi_mq_inline_sgl_size(shost));
@@ -1940,7 +1941,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
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
index 72e1a347baa6..ec0f7705e06a 100644
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
