Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8609C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 08:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749D064F74
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 08:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhCSIWq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 04:22:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14402 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbhCSIWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 04:22:25 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F1xfk6Gfhzkc5D;
        Fri, 19 Mar 2021 16:20:46 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 16:22:15 +0800
Subject: Re: [PATCH 2/3] scsi: only copy data to user when the whole result is
 good
To:     Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>,
        <ming.lei@redhat.com>, <hch@lst.de>, <keescook@chromium.org>,
        <kbusch@kernel.org>, <linux-block@vger.kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>
References: <20210319030128.1345061-1-yanaijie@huawei.com>
 <20210319030128.1345061-3-yanaijie@huawei.com>
 <7279b268-0b57-c78a-b189-75e1515c7166@suse.de>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <ce784b08-b020-f67e-d902-a15affbdb1ca@huawei.com>
Date:   Fri, 19 Mar 2021 16:22:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <7279b268-0b57-c78a-b189-75e1515c7166@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.92]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

在 2021/3/19 15:56, Hannes Reinecke 写道:
> On 3/19/21 4:01 AM, Jason Yan wrote:
>> When the scsi device status is offline, mode sense command will return a
>> result with only DID_NO_CONNECT set. Then in sg_scsi_ioctl(),
>> only status byte of the result is checked, and because of
>> bug [1], garbage data is copied to the userspace.
>>
>> Only copy the buffer to userspace when the whole result is good.
>>
>> [1] 
>> https://patchwork.kernel.org/project/linux-block/patch/20210318122621.330010-1-yanaijie@huawei.com/ 
>>
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   block/scsi_ioctl.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
>> index 6599bac0a78c..359bf0003af4 100644
>> --- a/block/scsi_ioctl.c
>> +++ b/block/scsi_ioctl.c
>> @@ -503,7 +503,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct 
>> gendisk *disk, fmode_t mode,
>>               if (copy_to_user(sic->data, req->sense, bytes))
>>                   err = -EFAULT;
>>           }
>> -    } else {
>> +    } else if (scsi_result_is_good(req->result)) {
>>           if (copy_to_user(sic->data, buffer, out_len))
>>               err = -EFAULT;
>>       }
>>
> Hmm. Not sure about this one.
> The prime motivator behind sg is to get _precisely_ all flags of the 
> command, and not do in-kernel error handling.
> So one could argue that this behaviour is intentional, and would break 
> existing use-cases.
> 

Thanks for the review.

The existing usersapce can do nothing with the uninitialized data. Or 
the driver or disk may fill some data and at the same time set host_byte 
or driver_byte to non-zero? I'm not sure about this. And the return 
value of sg_scsi_ioctl() just get the status byte(only 8 bit), how can 
the users know about this situation?

Thanks,
Jason

> Doug?
> 
> Cheers,
> 
> Hannes
