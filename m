Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5015C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 17:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF97E61C17
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 17:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhGGRQG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 13:16:06 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3374 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGGRQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 13:16:05 -0400
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GKlyD0Bmlz6H9FN;
        Thu,  8 Jul 2021 00:59:16 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 19:13:23 +0200
Received: from [10.47.24.69] (10.47.24.69) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 7 Jul 2021
 18:13:22 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
References: <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com> <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com> <YIbkX2G0+dp3PV+u@T590>
 <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com> <YIdTyyVE5azlYwtO@T590>
 <ab83eec4-20f1-ad74-7f43-52a4a87a8aa9@huawei.com> <YIfVVRheF9ZWjzbh@T590>
 <cb81d990-e5a6-49b1-5d96-8079a80c73f5@huawei.com> <YIfe+mpcV17XsHuL@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ddb65e36-28e8-b5ff-9ae9-37fe3d455acb@huawei.com>
Date:   Wed, 7 Jul 2021 18:06:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YIfe+mpcV17XsHuL@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.24.69]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/04/2021 10:52, Ming Lei wrote:
>>> Then you just waste lots of memory, I remember that scsi request payload
>>> is a bit big.
>> It's true that we waste much memory for regular static requests for when
>> using hostwide tags today.
>>
>> One problem in trying to use a single set of "hostwide" static requests is
>> that we call blk_mq_init_request(..., hctx_idx, ...) ->
>> set->ops->init_request(.., hctx_idx, ...) for each static rq, and this would
>> not work for a single set of "hostwide" requests.
>>
>> And I see a similar problem for a "request queue-wide" sched static
>> requests.
>>
>> Maybe we can improve this in future.
> OK, fair enough.
> 

JFYI, I am working on this now.

My idea is to introduce a hostwide and request-wide static requests (for 
hostwide tagset), and have the per-hctx tags point at them, so that we 
don't need to allocate per-hctx static requests.

SCSI init_request callback just ignores hctx_idx passed, so then we can 
just call init_request(hctx_idx = 0) for those hostwide/request 
queue-wide static requests.

Thanks,
John

