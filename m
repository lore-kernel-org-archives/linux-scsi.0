Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FEBC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 07:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B3BC60F5C
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 07:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhHQHDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 03:03:01 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3653 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbhHQHDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 03:03:00 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gphlc1rRfz6FH0J;
        Tue, 17 Aug 2021 15:01:32 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 17 Aug 2021 09:02:25 +0200
Received: from [10.47.93.112] (10.47.93.112) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 17 Aug
 2021 08:02:24 +0100
Subject: Re: [PATCH v2 00/11] blk-mq: Reduce static requests memory footprint
 for shared sbitmap
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        <hare@suse.de>, <ming.lei@redhat.com>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2bb17ba5-2c7e-f1e3-6369-541369efd6b6@huawei.com>
Date:   Tue, 17 Aug 2021 08:02:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.93.112]
X-ClientProxiedBy: lhreml728-chm.china.huawei.com (10.201.108.79) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/08/2021 15:29, John Garry wrote:

Hi guys,

Any chance to review or test this?

Thanks!

> Currently a full set of static requests are allocated per hw queue per
> tagset when shared sbitmap is used.
> 
> However, only tagset->queue_depth number of requests may be active at
> any given time. As such, only tagset->queue_depth number of static
> requests are required.
> 
> The same goes for using an IO scheduler, which allocates a full set of
> static requests per hw queue per request queue.
> 
> This series changes shared sbitmap support by using a shared tags per
> tagset and request queue. Ming suggested something along those lines in
> v1. But we'll keep name "shared sbitmap" name as it is fimilar. In using
> a shared tags, the static rqs also become shared, reducing the number of
> sets of static rqs, reducing memory usage.
> 
> Patch "blk-mq: Use shared tags for shared sbitmap support" is a bit big,
> and could be broken down. But then maintaining ability to bisect
> becomes harder and each sub-patch would get more convoluted.
> 
> For megaraid sas driver on my 128-CPU arm64 system with 1x SATA disk, we
> save approx. 300MB(!) [370MB -> 60MB]
> 
> Baseline is 2112f5c1330a (for-5.15/block) loop: Select I/O scheduler ...
> 
> Changes since v1:
> - Switch to use blk_mq_tags for shared sbitmap
> - Add new blk_mq_ops init request callback
> - Add some RB tags (thanks!)
> 
> John Garry (11):
>    blk-mq: Change rqs check in blk_mq_free_rqs()
>    block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
>    blk-mq: Relocate shared sbitmap resize in blk_mq_update_nr_requests()
>    blk-mq: Invert check in blk_mq_update_nr_requests()
>    blk-mq-sched: Rename blk_mq_sched_alloc_{tags -> map_and_request}()
>    blk-mq: Pass driver tags to blk_mq_clear_rq_mapping()
>    blk-mq: Add blk_mq_tag_update_sched_shared_sbitmap()
>    blk-mq: Add blk_mq_ops.init_request_no_hctx()
>    scsi: Set blk_mq_ops.init_request_no_hctx
>    blk-mq: Use shared tags for shared sbitmap support
>    blk-mq: Stop using pointers for blk_mq_tags bitmap tags
> 
>   block/bfq-iosched.c      |   4 +-
>   block/blk-core.c         |   2 +-
>   block/blk-mq-debugfs.c   |   8 +--
>   block/blk-mq-sched.c     |  92 +++++++++++++------------
>   block/blk-mq-sched.h     |   2 +-
>   block/blk-mq-tag.c       | 111 +++++++++++++-----------------
>   block/blk-mq-tag.h       |  12 ++--
>   block/blk-mq.c           | 144 +++++++++++++++++++++++----------------
>   block/blk-mq.h           |   8 +--
>   block/kyber-iosched.c    |   4 +-
>   block/mq-deadline-main.c |   2 +-
>   drivers/block/rbd.c      |   2 +-
>   drivers/scsi/scsi_lib.c  |   6 +-
>   include/linux/blk-mq.h   |  20 +++---
>   include/linux/blkdev.h   |   5 +-
>   15 files changed, 218 insertions(+), 204 deletions(-)
> 

