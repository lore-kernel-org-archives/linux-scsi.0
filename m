Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2A5C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 03:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28403221F8
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 03:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgLGDdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 22:33:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8702 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgLGDdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 22:33:46 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cq8552CDNzkm8c;
        Mon,  7 Dec 2020 11:32:25 +0800 (CST)
Received: from [127.0.0.1] (10.74.219.194) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Dec 2020
 11:32:54 +0800
Subject: Re: [PATCH] scsi: core: fix race between handling STS_RESOURCE and
 completion
To:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
References: <20201202100419.525144-1-ming.lei@redhat.com>
 <5f17e0b1-2bee-7dd2-6049-58088691204b@acm.org> <20201203010336.GC540033@T590>
CC:     <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Ewan Milne" <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <9923f475-a2e4-5dd9-e671-21948969b724@hisilicon.com>
Date:   Mon, 7 Dec 2020 11:32:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20201203010336.GC540033@T590>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.219.194]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/12/3 9:03, Ming Lei 写道:
> On Wed, Dec 02, 2020 at 10:10:30AM -0800, Bart Van Assche wrote:
>> On 12/2/20 2:04 AM, Ming Lei wrote:
>>> When queuing IO request to LLD, STS_RESOURCE may be returned because:
>>>
>>> - host in recovery or blocked
>>> - target queue throttling or blocked
>>> - LLD rejection
>>>
>>> Any one of the above doesn't happen frequently enough.
>>>
>>> BLK_STS_DEV_RESOURCE is returned to block layer for avoiding unnecessary
>>> re-run queue, and it is just one small optimization. However, all
>>> in-flight requests originated from this scsi device may be completed
>>> just after reading 'sdev->device_busy', so BLK_STS_DEV_RESOURCE is
>>> returned to block layer. And the current failed IO won't get chance
>>> to be queued any more, since it is invisible at that time for either
>>> scsi_run_queue_async() or blk-mq's RESTART.
>>>
>>> Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.
>>>
>>> Cc: Hannes Reinecke <hare@suse.com>
>>> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
>>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
>>> Cc: Bart Van Assche <bvanassche@acm.org>
>>> Cc: Ewan Milne <emilne@redhat.com>
>>> Cc: Long Li <longli@microsoft.com>
>>> Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
>>> Reported-by: John Garry <john.garry@huawei.com>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    drivers/scsi/scsi_lib.c | 3 +--
>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 60c7a7d74852..03c6d0620bfd 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1703,8 +1703,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>>    		break;
>>>    	case BLK_STS_RESOURCE:
>>>    	case BLK_STS_ZONE_RESOURCE:
>>> -		if (atomic_read(&sdev->device_busy) ||
>>> -		    scsi_device_blocked(sdev))
>>> +		if (scsi_device_blocked(sdev))
>>>    			ret = BLK_STS_DEV_RESOURCE;
>>>    		break;
>>>    	default:
>> Since this patch modifies code introduced in commit 86ff7c2a80cd ("blk-mq:
>> introduce BLK_STS_DEV_RESOURCE"), does this patch perhaps needs a Fixes:
>> tag?
> This same race exists before commit 86ff7c2a80cd, so I think the 'Fixes:' tag
> is misleading.

When reverted the patch "scsi: core: Only re-run queue in 
scsi_end_request() if device queue is busy", it also solves the issue.
Does the issue is brought by the patch? If so, maybe adding 
fixes("Fixes: ed5dd6a67d5e ("scsi: core: Only re-run queue in 
scsi_end_request() if device queue is busy")") is more accuratte.

>
>
>
> Thanks,
> Ming
>
>
> .
>


