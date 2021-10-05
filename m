Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54EEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 861AB61381
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbhJEKah (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:30:37 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3917 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJEKah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:30:37 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNty61Ymlz67b2s;
        Tue,  5 Oct 2021 18:25:18 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:28:44 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:28:42 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 00/14] blk-mq: Reduce static requests memory footprint for shared sbitmap
Date:   Tue, 5 Oct 2021 18:23:25 +0800
Message-ID: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

This series changes shared sbitmap support by using a shared tags per
tagset and request queue. Ming suggested something along those lines in
v1 review. In using a shared tags, the static rqs also become shared,
reducing the number of sets of static rqs, reducing memory usage.

Patch "blk-mq: Use shared tags for shared sbitmap support" is a bit big,
and could potentially be broken down. But then maintaining ability to
bisect becomes harder and each sub-patch would get more convoluted.

For megaraid sas driver on my 128-CPU arm64 system with 1x SATA disk, we
save approx. 300MB(!) [370MB -> 60MB]

Baseline is 1b2d1439fc25 (block/for-next) Merge branch 'for-5.16/io_uring'
into for-next

Changes since v4:
- Add Hannes' and Ming's RB tags (thanks!) - but please check 12/14 rework
- Add patch to change "shared sbitmap" naming to "shared tags"
- Rebase "block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ"

Changes since v3:
- Fix transient error handling issue in  05/13
- Add Hannes RB tags (thanks!)

Changes since v2:
- Make blk_mq_clear_rq_mapping() static again
- Various function renaming for conciseness and consistency
- Add/refactor alloc/free map and rqs function
- Drop the new blk_mq_ops init_request method in favour of passing an
  invalid HW queue index for shared sbitmap
- Add patch to not clear rq mapping for driver tags
- Remove blk_mq_init_bitmap_tags()
- Add some more RB tags (thanks!)

Changes since v1:
- Switch to use blk_mq_tags for shared sbitmap
- Add new blk_mq_ops init request callback
- Add some RB tags (thanks!)

John Garry (14):
  blk-mq: Change rqs check in blk_mq_free_rqs()
  block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
  blk-mq: Relocate shared sbitmap resize in blk_mq_update_nr_requests()
  blk-mq: Invert check in blk_mq_update_nr_requests()
  blk-mq-sched: Rename blk_mq_sched_alloc_{tags -> map_and_rqs}()
  blk-mq-sched: Rename blk_mq_sched_free_{requests -> rqs}()
  blk-mq: Pass driver tags to blk_mq_clear_rq_mapping()
  blk-mq: Don't clear driver tags own mapping
  blk-mq: Add blk_mq_tag_update_sched_shared_sbitmap()
  blk-mq: Add blk_mq_alloc_map_and_rqs()
  blk-mq: Refactor and rename blk_mq_free_map_and_{requests->rqs}()
  blk-mq: Use shared tags for shared sbitmap support
  blk-mq: Stop using pointers for blk_mq_tags bitmap tags
  blk-mq: Change shared sbitmap naming to shared tags

 block/bfq-iosched.c    |   4 +-
 block/blk-core.c       |   6 +-
 block/blk-mq-debugfs.c |   8 +-
 block/blk-mq-sched.c   | 118 +++++++++++-------------
 block/blk-mq-sched.h   |   4 +-
 block/blk-mq-tag.c     | 135 ++++++++++------------------
 block/blk-mq-tag.h     |  16 ++--
 block/blk-mq.c         | 198 +++++++++++++++++++++++------------------
 block/blk-mq.h         |  36 ++++----
 block/blk.h            |   2 +-
 block/elevator.c       |   2 +-
 block/kyber-iosched.c  |   4 +-
 block/mq-deadline.c    |   2 +-
 drivers/block/rbd.c    |   2 +-
 include/linux/blk-mq.h |  17 ++--
 include/linux/blkdev.h |   5 +-
 16 files changed, 262 insertions(+), 297 deletions(-)

-- 
2.26.2

