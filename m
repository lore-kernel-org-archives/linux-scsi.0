Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EB6C07E9B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 08:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C4F9611C1
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 08:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGTHZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 03:25:26 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3434 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhGTHZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jul 2021 03:25:25 -0400
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GTWFk2B5xz6H7nW;
        Tue, 20 Jul 2021 15:54:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 10:06:01 +0200
Received: from [10.47.85.214] (10.47.85.214) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Jul
 2021 09:06:00 +0100
Subject: Re: [PATCH 3/9] blk-mq: Relocate shared sbitmap resize in
 blk_mq_update_nr_requests()
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
 <1626275195-215652-4-git-send-email-john.garry@huawei.com>
 <YPaARLPPZxcbat8H@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <49151de5-0505-6cbd-d368-e032676232b9@huawei.com>
Date:   Tue, 20 Jul 2021 09:06:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YPaARLPPZxcbat8H@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.214]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/07/2021 08:50, Ming Lei wrote:
>> Signed-off-by: John Garry<john.garry@huawei.com>
>> ---
>>   block/blk-mq.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index ae28f470893c..56e3c6fdba60 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -3624,8 +3624,6 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>>   		if (!hctx->sched_tags) {
>>   			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
>>   							false);
>> -			if (!ret && blk_mq_is_sbitmap_shared(set->flags))
>> -				blk_mq_tag_resize_shared_sbitmap(set, nr);
>>   		} else {
>>   			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
>>   							nr, true);
>> @@ -3643,9 +3641,14 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>>   	}
>>   	if (!ret) {
>>   		q->nr_requests = nr;
>> -		if (q->elevator && blk_mq_is_sbitmap_shared(set->flags))
>> -			sbitmap_queue_resize(&q->sched_bitmap_tags,
>> -					     nr - set->reserved_tags);
>> +		if (blk_mq_is_sbitmap_shared(set->flags)) {

Hi Ming,

>> +			if (q->elevator) {
>> +				sbitmap_queue_resize(&q->sched_bitmap_tags,
>> +						     nr - set->reserved_tags);

I have learned that some people prefer {} for multi-line single 
statements, like this.

Anyway, more code is added here later in the series, so better to add {} 
now, rather than re-arrange code later.

>> +			} else {
>> +				blk_mq_tag_resize_shared_sbitmap(set, nr);
>> +			}
> The above two {} can be removed.

Thanks,
John


