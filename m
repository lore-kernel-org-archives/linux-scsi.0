Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248D5C43141
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 10:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 034E92089D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 10:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfKZKJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 05:09:38 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727921AbfKZKJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 05:09:38 -0500
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 8791E21FB4C8998B4454;
        Tue, 26 Nov 2019 10:09:36 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 26 Nov 2019 10:09:35 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 26 Nov
 2019 10:09:35 +0000
Subject: Re: [PATCH RFC v3 0/8] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Bart van Assche" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20191126091416.20052-1-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <923adbf4-5111-a2b2-c271-805240d747fe@huawei.com>
Date:   Tue, 26 Nov 2019 10:09:34 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191126091416.20052-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/11/2019 09:14, Hannes Reinecke wrote:
> Hi all,
> 
> here now is an updated version of the v2 patchset from John Garry,
> including the suggestions and reviews from the mailing list.
> John, apologies for hijacking your work :-)

No worries as long as we can keep moving this forward.

> 
> The main diffence is that I've changed the bitmaps to be allocated
> separately in all cases, and just set the pointer to the shared bitmap
> for the hostwide tags case.

Yeah, I was considering this also.

> I've also modified smartpqi and hpsa to take advantage of host_tags.
> 
> I did audit the iterators, and I _think_ they do the correct thing even
> in the shared bitmap case. But then I might have overlooked things,
> so feedback and reviews are welcome.
> 
> The one thing I'm not happy with is the debugfs interface; for shared
> bitmaps all will be displaying essentially the same information, which
> could be moved to a top-level directory. But that would change the
> layout and I'm not sure if that buys us anything.

I was having a look at this. I'd say we need to still show which bits 
are set per hctx.

Maybe we can do something like this:

a. In hctx_tags_bitmaphow() or other relevant functions, copy shared 
sbitmap map into temp sbitmap map (maybe even the per-hctx sbitmap)
b. iterate over to unset bits not relevant to hctx in temp sbitmap map
c. then do sbitmap_show

Locking may be a bit tricky.

Thanks,
John

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
> Hannes Reinecke (4):
>    blk-mq: Use a pointer for sbitmap
>    scsi: Add template flag 'host_tagset'
>    smartpqi: enable host tagset
>    hpsa: switch to using blk-mq
> 
> John Garry (3):
>    blk-mq: Remove some unused function arguments
>    blk-mq: Facilitate a shared sbitmap per tagset
>    scsi: hisi_sas: Switch v3 hw to MQ
> 
> Ming Lei (1):
>    blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED
> 
>   block/bfq-iosched.c                    |   4 +-
>   block/blk-mq-debugfs.c                 |  10 ++--
>   block/blk-mq-sched.c                   |   8 ++-
>   block/blk-mq-tag.c                     | 104 ++++++++++++++++++++++-----------
>   block/blk-mq-tag.h                     |  18 +++---
>   block/blk-mq.c                         |  80 ++++++++++++++++---------
>   block/blk-mq.h                         |   9 ++-
>   block/kyber-iosched.c                  |   4 +-
>   drivers/scsi/hisi_sas/hisi_sas.h       |   3 +-
>   drivers/scsi/hisi_sas/hisi_sas_main.c  |  36 ++++++------
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  86 +++++++++++----------------
>   drivers/scsi/hpsa.c                    |  44 +++-----------
>   drivers/scsi/hpsa.h                    |   1 -
>   drivers/scsi/scsi_lib.c                |   2 +
>   drivers/scsi/smartpqi/smartpqi_init.c  |  38 ++++++++----
>   include/linux/blk-mq.h                 |   9 ++-
>   include/scsi/scsi_host.h               |   3 +
>   17 files changed, 260 insertions(+), 199 deletions(-)
> 

