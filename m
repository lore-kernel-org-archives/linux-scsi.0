Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D52C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 08:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3B561058
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 08:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhHRIrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 04:47:09 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3657 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhHRIrI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 04:47:08 -0400
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqM1B5KVFz6D9Cn;
        Wed, 18 Aug 2021 16:45:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 18 Aug 2021 10:46:32 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 18 Aug 2021 09:46:31 +0100
Subject: Re: [PATCH v2 08/11] blk-mq: Add blk_mq_ops.init_request_no_hctx()
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-9-git-send-email-john.garry@huawei.com>
 <YRy5C1s0HetZCHQ1@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9a723528-3d4f-4b80-b10a-12ef50b00c50@huawei.com>
Date:   Wed, 18 Aug 2021 09:46:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YRy5C1s0HetZCHQ1@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/08/2021 08:38, Ming Lei wrote:
> On Mon, Aug 09, 2021 at 10:29:35PM +0800, John Garry wrote:
>> Add a variant of the init_request function which does not pass a hctx_idx
>> arg.
>>
>> This is important for shared sbitmap support, as it needs to be ensured for
>> introducing shared static rqs that the LLDD cannot think that requests
>> are associated with a specific HW queue.
>>
>> Signed-off-by: John Garry<john.garry@huawei.com>
>> ---
>>   block/blk-mq.c         | 15 ++++++++++-----
>>   include/linux/blk-mq.h |  7 +++++++
>>   2 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index f14cc2705f9b..4d6723cfa582 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2427,13 +2427,15 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>>   static int blk_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
>>   			       unsigned int hctx_idx, int node)
>>   {
>> -	int ret;
>> +	int ret = 0;
>>   
>> -	if (set->ops->init_request) {
>> +	if (set->ops->init_request)
>>   		ret = set->ops->init_request(set, rq, hctx_idx, node);
>> -		if (ret)
>> -			return ret;
>> -	}
>> +	else if (set->ops->init_request_no_hctx)
>> +		ret = set->ops->init_request_no_hctx(set, rq, node);

Hi Ming,

> The only shared sbitmap user of SCSI does not use passed hctx_idx, not
> sure we need such new callback.

Sure, actually most versions of init_request callback don't use 
hctx_idx. Or numa_node arg.
> If you really want to do this, just wondering why not pass '-1' as
> hctx_idx in case of shared sbitmap?

Yeah, I did consider that. hctx_idx is an unsigned, and I generally 
don't like -1U - but that's no big deal. But I also didn't like how it 
relies on the driver init_request callback to check the value, which 
changes the semantics.

Obviously we don't add new versions of init_request for new block 
drivers which use shared sbitmap everyday, and any new ones would get it 
right.

I suppose I can go the way you suggest - I just thought that this method 
was neat as well.

Thanks,
John

