Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A065BC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52918613B2
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhDYI6p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 04:58:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhDYI6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 04:58:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619341085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b6ybz+qmRf2Zi4nCd5Sb3S6od2SpNl7/yvNkCu5afNM=;
        b=bg5O1AkdoBdry9/HRRrkku74B7K1HdnzuT3lrRIgxs59npwhX70/6cvmAY6/kCds6s1B34
        IamwsrzO+akRAnY0ihgrNfhkYsDqTYTER/2WNvDoXuDIiJtk58MRRO0nFA44h4L5ZlJn5X
        gpZQoGO+Yez+caNFl80DeK6JrZyGGkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-IVIFdt_CM9OX-FE2Fq9inA-1; Sun, 25 Apr 2021 04:58:02 -0400
X-MC-Unique: IVIFdt_CM9OX-FE2Fq9inA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E7D1343A6;
        Sun, 25 Apr 2021 08:58:00 +0000 (UTC)
Received: from localhost (ovpn-13-143.pek2.redhat.com [10.72.13.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67D182BFF1;
        Sun, 25 Apr 2021 08:57:55 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/8] blk-mq: fix request UAF related with iterating over tagset requests
Date:   Sun, 25 Apr 2021 16:57:45 +0800
Message-Id: <20210425085753.2617424-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Guys,

Revert 4 patches from Bart which try to fix request UAF issue related
with iterating over tagset wide requests, because:

1) request UAF caused by normal completion vs. async completion during
iterating can't be covered[1]

2) clearing ->rqs[] is added in fast path, which causes performance loss
by 1% according to Bart's test

3) Bart's approach is too complicated, and some changes aren't needed,
such as adding two versions of tagset iteration

This patchset fixes the request UAF issue by one simpler approach,
without any change in fast path.

1) always complete request synchronously when the completing is run
via blk_mq_tagset_busy_iter(), done in 1st two patches

2) grab request's ref before calling ->fn in blk_mq_tagset_busy_iter,
and release it after calling ->fn, so ->fn won't be called for one
request if its queue is frozen, done in 3rd patch

3) clearing any stale request referred in ->rqs[] before freeing the
request pool, one per-tags spinlock is added for protecting
grabbing request ref vs. clearing ->rqs[tag], so UAF by refcount_inc_not_zero
in bt_tags_iter() is avoided, done in 4th patch.


[1] https://lore.kernel.org/linux-block/YISzLal7Ur7jyuiy@T590/T/#u

Ming Lei (8):
  Revert "blk-mq: Fix races between blk_mq_update_nr_hw_queues() and
    iterating over tags"
  Revert "blk-mq: Make it safe to use RCU to iterate over
    blk_mq_tag_set.tag_list"
  Revert "blk-mq: Fix races between iterating over requests and freeing
    requests"
  Revert "blk-mq: Introduce atomic variants of
    blk_mq_(all_tag|tagset_busy)_iter"
  blk-mq: blk_mq_complete_request_locally
  block: drivers: complete request locally from blk_mq_tagset_busy_iter
  blk-mq: grab rq->refcount before calling ->fn in
    blk_mq_tagset_busy_iter
  blk-mq: clear stale request in tags->rq[] before freeing one request
    pool

 block/blk-core.c                  |  34 +------
 block/blk-mq-tag.c                | 147 ++++++------------------------
 block/blk-mq-tag.h                |   7 +-
 block/blk-mq.c                    | 100 +++++++++++++-------
 block/blk-mq.h                    |   2 +-
 block/blk.h                       |   2 -
 block/elevator.c                  |   1 -
 drivers/block/mtip32xx/mtip32xx.c |   2 +-
 drivers/block/nbd.c               |   2 +-
 drivers/nvme/host/core.c          |   2 +-
 drivers/scsi/hosts.c              |  16 ++--
 drivers/scsi/scsi_lib.c           |   6 +-
 drivers/scsi/ufs/ufshcd.c         |   4 +-
 include/linux/blk-mq.h            |   3 +-
 14 files changed, 119 insertions(+), 209 deletions(-)

-- 
2.29.2

