Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33438C4BA0B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 11:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F7FC24690
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 11:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgBZLJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 06:09:53 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2466 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgBZLJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 06:09:53 -0500
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 6549A6E87B0A9156BA9C;
        Wed, 26 Feb 2020 11:09:50 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML714-CAH.china.huawei.com (10.201.108.37) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 26 Feb 2020 11:09:50 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5; Wed, 26 Feb
 2020 11:09:48 +0000
Subject: Re: [PATCH RFC v5 00/11] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
To:     Hannes Reinecke <hare@suse.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
References: <20191202153914.84722-1-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <14b627ba-890c-ffe1-a648-7f22a4829372@huawei.com>
Date:   Wed, 26 Feb 2020 11:09:46 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191202153914.84722-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml708-chm.china.huawei.com (10.201.108.57) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/12/2019 15:39, Hannes Reinecke wrote:
> Hi all,
> 

JFYI, Sumit requested that we rebase this patchset for testing against 
the latest kernel - it no longer applies for 5.6-rc. I'm going to do 
that now and repost.

Thanks,
John

> here now is an updated version of the v2 patchset from John Garry,
> including the suggestions and reviews from the mailing list.
> John, apologies for hijacking your work :-)
> 
> For this version I've only added some slight modifications to Johns
> original patch (renaming variables etc); the contentious separate sbitmap
> allocation has been dropped in favour of Johns original version with pointers
> to the embedded sbitmap.
> 
> But more importantly I've reworked the scheduler tag allocation after
> discussions with Ming Lei.
> 
> Point is, hostwide shared tags can't really be resized; they surely
> cannot be increased (as it's a hardware limitation), and even decreasing
> is questionable as any modification here would affect all devices
> served by this HBA.
> 
> Scheduler tags, OTOH, can be considered as per-queue, as the I/O scheduler
> might want to look at all requests on all queues. As such the queue depth
> is distinct from the actual queue depth of the tagset.
> Seeing that it is distinct the depth can now be changed independently of
> the underlying tagset, and there's no need ever to change the tagset itself.
> 
> I've also modified megaraid_sas, smartpqi and hpsa to take advantage of
> host_tags.
> 
> Performance for megaraid_sas is on par with the original implementation,
> with the added benefit that with this we should be able to handle cpu
> hotplug properly.
> 
> Differences to v4:
> - Rework scheduler tag allocations
> - Revert back to the original implementation from John
> 
> Differences to v3:
> - Include reviews from Ming Lei
> 
> Differences to v2:
> - Drop embedded tag bitmaps
> - Do not share scheduling tags
> - Add patches for hpsa and smartpqi
> 
> Differences to v1:
> - Use a shared sbitmap, and not a separate shared tags (a big change!)
> 	- Drop request.shared_tag
> - Add RB tags
> 
> Hannes Reinecke (7):
>    blk-mq: rename blk_mq_update_tag_set_depth()
>    blk-mq: add WARN_ON in blk_mq_free_rqs()
>    blk-mq: move shared sbitmap into elevator queue
>    scsi: Add template flag 'host_tagset'
>    megaraid_sas: switch fusion adapters to MQ
>    smartpqi: enable host tagset
>    hpsa: enable host_tagset and switch to MQ
> 
> John Garry (3):
>    blk-mq: Remove some unused function arguments
>    blk-mq: Facilitate a shared sbitmap per tagset
>    scsi: hisi_sas: Switch v3 hw to MQ
> 
> Ming Lei (1):
>    blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED
> 
>   block/bfq-iosched.c                         |   4 +-
>   block/blk-mq-debugfs.c                      |  12 +--
>   block/blk-mq-sched.c                        |  22 +++++
>   block/blk-mq-tag.c                          | 140 +++++++++++++++++++++-------
>   block/blk-mq-tag.h                          |  27 ++++--
>   block/blk-mq.c                              | 104 +++++++++++++++------
>   block/blk-mq.h                              |   7 +-
>   block/blk-sysfs.c                           |   7 ++
>   block/kyber-iosched.c                       |   4 +-
>   drivers/scsi/hisi_sas/hisi_sas.h            |   3 +-
>   drivers/scsi/hisi_sas/hisi_sas_main.c       |  36 +++----
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  86 +++++++----------
>   drivers/scsi/hpsa.c                         |  44 ++-------
>   drivers/scsi/hpsa.h                         |   1 -
>   drivers/scsi/megaraid/megaraid_sas.h        |   1 -
>   drivers/scsi/megaraid/megaraid_sas_base.c   |  65 ++++---------
>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  14 ++-
>   drivers/scsi/scsi_lib.c                     |   2 +
>   drivers/scsi/smartpqi/smartpqi_init.c       |  38 ++++++--
>   include/linux/blk-mq.h                      |   7 +-
>   include/linux/elevator.h                    |   3 +
>   include/scsi/scsi_host.h                    |   3 +
>   22 files changed, 380 insertions(+), 250 deletions(-)
> 

