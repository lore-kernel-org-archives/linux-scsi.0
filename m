Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF308C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 10:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C9261026
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 10:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhEDK4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 06:56:18 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2992 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhEDK4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2021 06:56:17 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FZGkf2GbJz6wj8n;
        Tue,  4 May 2021 18:47:22 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 4 May 2021 12:55:21 +0200
Received: from [10.47.95.108] (10.47.95.108) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 4 May 2021
 11:55:21 +0100
Subject: Re: [PATCH 10/18] scsi: implement reserved command handling
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-11-hare@suse.de>
 <3e41e5ea-6313-9718-c07d-20f8b203efd2@acm.org>
 <1db7fc49-17a9-1c8d-9d94-9a1b3694f392@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <7a9ceb36-32dc-4fcc-49a2-f4c2ca2286c3@huawei.com>
Date:   Tue, 4 May 2021 11:55:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1db7fc49-17a9-1c8d-9d94-9a1b3694f392@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.108]
X-ClientProxiedBy: lhreml708-chm.china.huawei.com (10.201.108.57) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/05/2021 07:17, Hannes Reinecke wrote:
> On 5/4/21 5:20 AM, Bart Van Assche wrote:
>> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>>> These commands are set aside before allocating the block-mq tag bitmap,
>>> so they'll never show up as busy in the tag map.
>>
>> That doesn't sound correct to me. Should the above perhaps be changed
>> into "blk_mq_start_request() is never called for internal commands so
>> they'll never show up as busy in the tag map"?
>>
> Yes, will do.

So why don't these - or shouldn't these - turn up in the busy tag map?

One of the motivations to use these block requests for internal commands 
is that we can take advantage of the block layer handling for CPU 
hotplug for MQ hosts, i.e. if blk-mq can't see these are inflight, then 
they would be missed in blk_mq_hctx_notify_offline() -> 
blk_mq_hctx_has_requests(), right? And who knows what else...

Thanks,
John
