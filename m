Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB47CC2BC73
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 10:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B82AC20833
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 10:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfLDKYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 05:24:36 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2154 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726899AbfLDKYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Dec 2019 05:24:36 -0500
Received: from lhreml707-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 8B14B77D71B06C2BE9CD;
        Wed,  4 Dec 2019 10:24:35 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml707-cah.china.huawei.com (10.201.108.48) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 4 Dec 2019 10:24:35 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5; Wed, 4 Dec 2019
 10:24:35 +0000
Subject: Re: [PATCH 04/11] blk-mq: Facilitate a shared sbitmap per tagset
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "James Bottomley" <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-5-hare@suse.de>
 <ab7555b2-2e95-6fb1-2e44-fe3a323a24e4@huawei.com>
 <5beb7d51-500e-5bda-4e46-8414fd8b64ff@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6c8b8676-a3c7-6fd5-3b6d-c0b469c80756@huawei.com>
Date:   Wed, 4 Dec 2019 10:24:34 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <5beb7d51-500e-5bda-4e46-8414fd8b64ff@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/12/2019 15:02, Hannes Reinecke wrote:
>>> +     */
>> If you don't have a shared sched bitmap - which I didn't think we needed
>> - then all we need is a simple sbitmap_queue_resize(&tagset->__bitmap_tags)
>>
>> Otherwise it's horrible to resize shared sched bitmaps...
>>
> Resizing shared sched bitmaps is done in patch 6/11.
> General idea is to move the scheduler bitmap into the request queue
> (well, actually the elevator), as this gives us a per-request_queue
> bitmap. Which is actually what we want here, as the scheduler will need
> to look at all requests, hence needing to access to the same bitmap.
> And it also gives us an easy way of resizing the sched tag bitmap, as
> then we can resize the bitmap on a per-queue basis, and leave the
> underlying tagset bitmap untouched.

OK, but I am just concerned if that is really required in this series 
and whether it is just another obstacle to getting it accepted.

Thanks,
John

> 
> [ .. ]
>>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>>> index 78d38b5f2793..4c1ea206d3f4 100644
>>> --- a/block/blk-mq.h
>>> +++ b/block/blk-mq.h

