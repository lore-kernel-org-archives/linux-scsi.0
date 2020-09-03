Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FA9C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 015A720775
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="D4ZikL5L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgICQPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 12:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgICQPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 12:15:04 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FB3C061244
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 09:15:03 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d20so3579042qka.5
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 09:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ThhuR6MYXXv6PPRUm9jABsy2W4T9U+tqGeq3Dgtn8kY=;
        b=D4ZikL5LWuZXPC92iEFqMnMGBFgYjj8whCy+lS9W1gz1X9zIsYIfUO9FVeVkLAUhDn
         +cuJp1L6xe8XKG7GBdxtMRQCdN5yt6tjinTTpIys1Mv/k2jx/LamYIyantrkvFFGjATw
         shvDO1ZwLnS1smYVy6EAVv53dB1Fk1P/ZkWqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ThhuR6MYXXv6PPRUm9jABsy2W4T9U+tqGeq3Dgtn8kY=;
        b=KDsYFozncty9M4QdQKMeDTRUaKSq2q8iau9JAHEHZ/O5/JlohQ1U0eDSWqy1CWUb5d
         gp2q/WiAQnY01HTCj3cae56KKPUDTBCYqeEsai+p7mjCTpTpS7gpCykEvdbriiXpkLE5
         /tWBiy22/OCH9Vpba2gfkQ5P9TkkQydeHMcPGkmSuw2X5N9uGUny7YseLBubBSyjH+ce
         0kmXnN5evDPkULU62352tFnatce5Tn4E/FJ/rhRnMjS8VXTGygZ9RS5W2CtZZjcCXFQ1
         SasK9rzNRASADx0rf+aGwGoXVXA/Snob6XhrDAFQ2tCATnmtOl/y1mOIZtVTqP7fsDtv
         TqsA==
X-Gm-Message-State: AOAM5315L7LJqaJcztUzfhV4biZUWWVLQ4VYQzxAL6Ig4POzrI1MnG4J
        6StAqLFSPl0g3/J2dbsL6y6flsU9r0Eqak0vwz85rZ3yHJ1/wQ==
X-Google-Smtp-Source: ABdhPJw6zJfpG/cAbaEbcz2mhfuZJKqC2tstPNhHC8eGUVE8KbP8lh5hcE9LohuBzMHM7wf0L6vd+RQM60/P1/IeQII=
X-Received: by 2002:a37:8fc6:: with SMTP id r189mr3905847qkd.70.1599149702429;
 Thu, 03 Sep 2020 09:15:02 -0700 (PDT)
MIME-Version: 1.0
From:   Kashyap Desai <kashyap.desai@broadcom.com>
Date:   Thu, 3 Sep 2020 21:44:38 +0530
Message-ID: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
Subject: [RFC] add io_uring support in scsi layer
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Philip Wong <philip.wong@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently io_uring support is only available in the block layer.
This RFC is to extend support of mq_poll in the scsi layer.

megaraid_sas and mpt3sas driver will be immediate users of this interface.
Both the drivers can use mq_poll only if it has exposed more than one
nr_hw_queues.
Waiting for below changes to enable shared host tag support.

https://patchwork.kernel.org/cover/11724429/

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/scsi_lib.c  | 16 ++++++++++++++++
 include/scsi/scsi_cmnd.h |  1 +
 include/scsi/scsi_host.h |  3 +++
 3 files changed, 20 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 780cf084e366..7a3c59d2dfcc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1802,6 +1802,19 @@ static void scsi_mq_exit_request(struct
blk_mq_tag_set *set, struct request *rq,
                               cmd->sense_buffer);
 }

+
+static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
+{
+       struct request_queue *q = hctx->queue;
+       struct scsi_device *sdev = q->queuedata;
+       struct Scsi_Host *shost = sdev->host;
+
+       if (shost->hostt->mq_poll)
+               return shost->hostt->mq_poll(shost, hctx->queue_num);
+
+       return 0;
+}
+
 static int scsi_map_queues(struct blk_mq_tag_set *set)
 {
        struct Scsi_Host *shost = container_of(set, struct Scsi_Host, tag_set);
@@ -1869,6 +1882,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
        .cleanup_rq     = scsi_cleanup_rq,
        .busy           = scsi_mq_lld_busy,
        .map_queues     = scsi_map_queues,
+       .poll           = scsi_mq_poll,
 };


@@ -1897,6 +1911,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
        .cleanup_rq     = scsi_cleanup_rq,
        .busy           = scsi_mq_lld_busy,
        .map_queues     = scsi_map_queues,
+       .poll           = scsi_mq_poll,
 };

 struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
@@ -1929,6 +1944,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
        else
                tag_set->ops = &scsi_mq_ops_no_commit;
        tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
+       tag_set->nr_maps = shost->nr_maps ? : 1;
        tag_set->queue_depth = shost->can_queue;
        tag_set->cmd_size = cmd_size;
        tag_set->numa_node = NUMA_NO_NODE;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index e76bac4d14c5..5844374a85b1 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_request.h>

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 701f178b20ae..d34602c68d0b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -269,6 +269,8 @@ struct scsi_host_template {
         * Status: OPTIONAL
         */
        int (* map_queues)(struct Scsi_Host *shost);
+
+       int (* mq_poll)(struct Scsi_Host *shost, unsigned int queue_num);

        /*
         * Check if scatterlists need to be padded for DMA draining.
@@ -610,6 +612,7 @@ struct Scsi_Host {
         * the total queue depth is can_queue.
         */
        unsigned nr_hw_queues;
+       unsigned nr_maps;
        unsigned active_mode:2;
        unsigned unchecked_isa_dma:1;
