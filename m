From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] tcmu: Fix possible overflow for memcpy address in iovec
Date: Tue, 11 Jul 2017 17:21:49 +0800
Message-ID: <f2b64f57-19c5-7915-9195-570c4652d3ec@cmss.chinamobile.com>
References: <1499758843-14159-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <c77ef933-1d47-b885-e3be-4a8b39b5e9fe@cmss.chinamobile.com>
 <1499762465.28145.48.camel@haakon3.daterainc.com>
 <f6d78118-ae7a-219e-005c-820d80b02477@wdc.com>
 <45bc0296-7b3a-c2d5-8e3b-c7b60ff6e2bb@cmss.chinamobile.com>
 <1499764634.16582.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:58483 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752299AbdGKJVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 05:21:55 -0400
In-Reply-To: <1499764634.16582.1.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>



On 2017年07月11日 17:17, Damien Le Moal wrote:
> Xiubo,
>
> On Tue, 2017-07-11 at 17:04 +0800, Xiubo Li wrote:
>>>>>> diff --git a/drivers/target/target_core_user.c
>>>>>> b/drivers/target/target_core_user.c
>>>>>> index 930800c..86a845a 100644
>>>>>> --- a/drivers/target/target_core_user.c
>>>>>> +++ b/drivers/target/target_core_user.c
>>>>>> @@ -437,7 +437,7 @@ static int scatter_data_area(struct tcmu_dev
>>>>>> *udev,
>>>>>>     			to_offset = get_block_offset_user(udev,
>>>>>> dbi,
>>>>>>     					block_remaining);
>>>>>>     			offset = DATA_BLOCK_SIZE -
>>>>>> block_remaining;
>>>>>> -			to = (void *)(unsigned long)to + offset;
>>>>>> +			to = (void *)((unsigned long)to + offset);
>>>>>>     
>>>>>>     			if (*iov_cnt != 0 &&
>>>>>>     			    to_offset == iov_tail(udev, *iov)) {
>>>>>> @@ -510,7 +510,7 @@ static void gather_data_area(struct tcmu_dev
>>>>>> *udev, struct tcmu_cmd *cmd,
>>>>>>     			copy_bytes = min_t(size_t, sg_remaining,
>>>>>>     					block_remaining);
>>>>>>     			offset = DATA_BLOCK_SIZE -
>>>>>> block_remaining;
>>>>>> -			from = (void *)(unsigned long)from +
>>>>>> offset;
>>>>>> +			from = (void *)((unsigned long)from +
>>>>>> offset);
>>>>>>     			tcmu_flush_dcache_range(from,
>>>>>> copy_bytes);
>>>>>>     			memcpy(to + sg->length - sg_remaining,
>>>>>> from,
>>>>>>     					copy_bytes);
>>> I was just looking at this patch and about to try to see if it fixes my
>>> problem... It cannot hurt. Trying...
>> Hi Damien,
>>
>> Please test another patch, I think that one maybe fix this.
> void * pointer arithmetic is OK and equivalent to unsigned long. So I do not
> think this actually fixes anything and could be rewritten more simply as

Yes, it is. So I just discard this one.
I meant to sent the second patch(tcmu: Fix possbile memory leak when 
recalculating the cmd base size) but just for mistake by handy this one.

Actually (void *) == (char *) from the GUN C manual.

Thanks,
BRs


> to += offset;
> and
>
> from += offset.
>
> And that compiles without a warning and there are no complaints from sparse.
>
> Cheers.
>
>
