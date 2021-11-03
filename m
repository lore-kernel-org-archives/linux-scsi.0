Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2225FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB8661058
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhKCAIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 20:08:17 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:34507 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhKCAIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 20:08:14 -0400
Received: by mail-pf1-f178.google.com with SMTP id 127so580455pfu.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 17:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5z6idaVfnDTjgAwZO/6F3A9M/ZfnymDtoeecxCrj3L4=;
        b=CHuQJwqtneVyHHUOmzmmKVp0pjnKNijpe34niTISH3nMO9ofY+mBIpbXG00J3mNoRr
         UoIoN2EFDMbD5iqIuBzJsr7kQ6bTO3mHsTtSeVEm1QQeZcQAj9QkOEd95v4xi0wbySZb
         +lNXmHKFhB4+5W6Vo+3GxTGGqQmkS4kX0qKrXV5KLUL92mEVx/n8VDJcE1r3c+CT/bOI
         ikzne/D+Fm349doZEkS97LFZPUMZ4Mr+yRIFiKy4Z1XX9HGnodM3z0cILGXD4oroCvUk
         xM1giqgup2Ad6LEIYB07UQ1I7JkwLXVStRal7/bVKnzSgB+7vPDjMvfM/4VSisQMA3RQ
         DROw==
X-Gm-Message-State: AOAM530OU2F576O74zCUN6SLSQF8khZukRcDK21tHK+kZEVt0a3MuB45
        /kOmEySCtMrMPym0T1ZMgW8=
X-Google-Smtp-Source: ABdhPJwqaoYdpzWlCaaSI4bJ+HZjOOM1QRDZT6ffSdSaLvML6od4j4uQoT6+Pc8lGWapKk0vgpy7tg==
X-Received: by 2002:a05:6a00:1593:b0:481:1ffa:8c4a with SMTP id u19-20020a056a00159300b004811ffa8c4amr10901921pfk.80.1635897938950;
        Tue, 02 Nov 2021 17:05:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id u2sm279282pfk.142.2021.11.02.17.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 17:05:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/2] scsi: core: Add support for reserved tags
Date:   Tue,  2 Nov 2021 17:05:28 -0700
Message-Id: <20211103000529.1549411-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
In-Reply-To: <20211103000529.1549411-1-bvanassche@acm.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI LLDs to allocate reserved tags by passing the BLK_MQ_REQ_RESERVED
flag to blk_get_request().

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 4 +++-
 include/scsi/scsi_host.h | 9 ++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d0b7c6dc74f8..1cbade5fe990 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1917,6 +1917,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
 	struct blk_mq_tag_set *tag_set = &shost->tag_set;
+	unsigned int reserved_tags = shost->hostt->reserved_tags;
 
 	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
 				scsi_mq_inline_sgl_size(shost));
@@ -1932,7 +1933,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
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
index 97cdad14de56..5502fcb306db 100644
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
