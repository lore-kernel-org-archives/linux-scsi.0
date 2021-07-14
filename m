Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03B3C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D94FC613D1
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbhGNPOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3403 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbhGNPOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:07 -0400
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ12W2F5Dz6K604;
        Wed, 14 Jul 2021 23:02:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:13 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:11 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 0/9] blk-mq: Reduce static requests memory footprint for shared sbitmap
Date:   Wed, 14 Jul 2021 23:06:26 +0800
Message-ID: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently a full set of static requests are allocated per hw queue per
tagset when shared sbitmap is used.

However, only tagset->queue_depth number of requests may be active at
any given time. As such, only tagset->queue_depth number of static
requests are required.

The same goes for using an IO scheduler, which allocates a full set of
static requests per hw queue per request queue.

This series very significantly reduces memory usage in both scenarios by
allocating static rqs per tagset and per request queue, respectively,
rather than per hw queue per tagset and per request queue.

For megaraid sas driver on my 128-CPU arm64 system with 1x SATA disk, we
save approx. 300MB(!) [370MB -> 60MB]

A couple of patches are marked as RFC, as maybe there is a better
implementation approach.

Any more testing would be appreciated also.

John Garry (9):
  blk-mq: Change rqs check in blk_mq_free_rqs()
  block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
  blk-mq: Relocate shared sbitmap resize in blk_mq_update_nr_requests()
  blk-mq: Add blk_mq_tag_resize_sched_shared_sbitmap()
  blk-mq: Invert check in blk_mq_update_nr_requests()
  blk-mq: Refactor blk_mq_{alloc,free}_rqs
  blk-mq: Allocate per tag set static rqs for shared sbitmap
  blk-mq: Allocate per request queue static rqs for shared sbitmap
  blk-mq: Clear mappings for shared sbitmap sched static rqs

 block/blk-core.c       |   2 +-
 block/blk-mq-sched.c   |  57 ++++++++++++--
 block/blk-mq-sched.h   |   2 +-
 block/blk-mq-tag.c     |  22 ++++--
 block/blk-mq-tag.h     |   1 +
 block/blk-mq.c         | 165 +++++++++++++++++++++++++++++++----------
 block/blk-mq.h         |   9 +++
 drivers/block/rbd.c    |   2 +-
 include/linux/blk-mq.h |   4 +
 include/linux/blkdev.h |   6 +-
 10 files changed, 215 insertions(+), 55 deletions(-)

-- 
2.26.2

